/************************************************************
* @Description: Batch Class to assign closed cases for evaluation. 
* This class is invoked from a scheduler class. 
* Batch will create QA Evaluations object records for the identified closed cases. 
*
* Test Class Name: CQI_BatchAssignmentsTest.
* *********************************************************/
public with Sharing class CQI_BatchAssignments implements Database.Batchable<sObject> {
    // Class Instance variable declaration
    Integer lastNDays = 0 ; 
    List<String> caseRecordTypes = new List<String>();  
    List<String> caseExcludedReasons = new List<String>(); 
    List<String> applicableAgentTitles = new List<String>(); 
    private final String RECORD_PREFIX = 'QA Evaluation '; 
    /*
     * @Description: Batch Start Method.
     * This method will fetch the custom metadata (CQI Batch Setting) & apply filters to the
     * Case query. 
     * 
     * */
    public Database.QueryLocator start (Database.BatchableContext objBC) {
        initBatchSettings(); //method to initialize filters from custom metadata
        String queryClosedCases = 'SELECT id, OwnerId, '+ 
            ' (SELECT Id FROM Quality_Assessments__r WHERE RecordType.DeveloperName = \'KPI_Assessment\') '+
            ' FROM Case '+
            ' WHERE ClosedDate = LAST_N_DAYS:'+lastNDays+' AND RecordType.DeveloperName IN :caseRecordTypes'+
            ' AND Status IN :caseExcludedReasons '+
            ' AND Origin <> \'Quick Case\' '+
            ' ORDER BY OwnerId'; 
        System.debug('Batch Assignment Query:'+queryClosedCases); 
        return Database.getQueryLocator(queryClosedCases) ; 
    }
    
    /*
     * @Description: Utility method to read custom metadata settings & 
     * initialize filters for Batch query. 
     * 1. Last_N_Days_SOQL -- to fetch cases/calls closed from current date to specified value in past. 
     * 2. Case_Record_Types -- to fetch only specific record types like Customer Support, Technical support. 
     * 3. Exclude_Case_Close_Reasons -- to exclude cases having SPAM or Duplicate. 
     * 4. Agent_Title -- select cases owned by users having specific profiles. 
     * This can be added/removed from custom metadata anytime. If there is a need to add more than 255 chars.
     * Create New custom metadata entry with DeveloperName Starting with 'Agent_Title'
     * */
    private void initBatchSettings() {
        
        for(CQI_Batch_Setting__mdt cqiBatchSetting : [SELECT Id , DeveloperName, Value__c 
                                                      FROM CQI_Batch_Setting__mdt]) 
        {
            if('Last_N_Days_SOQL'.equalsIgnoreCase(cqiBatchSetting.DeveloperName)) {
                lastNDays = Integer.valueOf(cqiBatchSetting.value__c) ; 
            }
            
            if(cqiBatchSetting.DeveloperName.StartsWith('Case_Record_Types')) {
                caseRecordTypes.addAll(cqiBatchSetting.value__c.split(';'));  
            }
            if(cqiBatchSetting.DeveloperName.StartsWith('Exclude_Case_Close_Reasons')) {
                caseExcludedReasons.addAll(cqiBatchSetting.value__c.split(';'));  
            }
            if(cqiBatchSetting.DeveloperName.StartsWith('Agent_Title')) {
                applicableAgentTitles.addAll(cqiBatchSetting.value__c.split(';')); 
            }
            
        } 
        
    }
    
    /*
     * @Description: execute method.
     * For each identified cases, group the cases by using case owner's Manager or QA user (if any). 
     * Construct a map User Id --> list of cases (eg: each manager/QA --> list of cases to evaluate). 
     * Create QA Evaluations record & child records using this information. 
     * */
    public void execute(Database.BatchableContext objBC , List<Case> lstClosedCases) {
        initBatchSettings(); 
        Id parentSummaryRecTypeId = null ; 
        Id relatedChildRecTypeId = null ; 
        Set<Id> setCaseOwnerIds = new Set<Id>();
        //Map to avoid suggesting more than 1 case for an agent, when batch runs in multiple iterations. 
        Map<Id,Set<Id>> mapExistingOwners = new Map<Id,Set<Id>>();
        
        CQI_Batch_Setting__mdt cqiBatchSetting = [SELECT Id , Value__c FROM CQI_Batch_Setting__mdt
                                                  WHERE DeveloperName = 'Last_N_Days_SOQL' LIMIT 1] ;
        
        lastNDays = Integer.valueOf(cqiBatchSetting.value__c) ; 
        
        List<RecordType> lstParentRecType = [SELECT Id, DeveloperName FROM RecordType WHERE sObjectType = 'CQA_Summary__c' 
                                             AND DeveloperName ='QA_Eval_Parent_Summary'
                                             LIMIT 1]; 
        if(! lstParentRecType.isEmpty()) {
            parentSummaryRecTypeId = lstParentRecType[0].Id ; 
        }
        List<RecordType> lstChildRecType = [SELECT Id, DeveloperName FROM RecordType WHERE sObjectType = 'CQA_Summary__c'
                                           AND DeveloperName = 'QA_Eval_Related_Case_Call' LIMIT 1]; 
        if( ! lstChildRecType.isEmpty()) {
            relatedChildRecTypeId = lstChildRecType[0].Id ; 
        }
        
        List<CQA_Summary__c> lstParentSuggestions = new List<CQA_Summary__c>(); 
        List<CQA_Summary__c> lstToUpdate = new List<CQA_Summary__c>(); 
        List<CQA_Summary__c> lstCaseSuggestions = new List<CQA_Summary__c>(); 
        Map<Id , CQA_Summary__c> mapExistingSuggestions = new Map<Id, CQA_Summary__c>();
        
        CQA_Summary__c objSuggestion = new CQA_Summary__c(); 
        CQA_Summary__c objCaseSuggestion = new CQA_Summary__c(); 
        //Map variables to consolidate list of cases which needs to assigned for Manager or QA. 
        Map<Id, List<Case>> mapAssignments = new Map<Id,List<Case>>();
        Set<Id> existingCaseAssignments = new Set<Id>(); 
        Set<Id> setCaseIds = new Set<Id>(); 
        
        System.debug('List of cases for processing: '+lstClosedCases.size());
        User objCaseOwner = new User(); 
        Map<Id, User> mapCaseOwnerInfo = getMapCaseOwnerInfo(lstClosedCases); 
        /*
         * NOTE: This variable will be having ids of Manager users, 
         * suppose if a case is owned by Manager, it will not
         * be suggested for evaluation. 
         * */
        Set<Id> managerIds = getMapManagerUsers( lstClosedCases ); 
        
        //list to filter cases, which does not contain an existing call assessment in the child record relationship
        //Map owner id -> case, This is to select max. 1 case per agent. -- THIS NEEDS TO BE UPDATED TO USE METADATA
        Map<Id,Case> mapPendingEvalCases = new Map<Id,Case>(); 
        for(Case objCase : lstClosedCases) {
            objCaseOwner = mapCaseOwnerInfo.get(objCase.OwnerId); 
            if(objCase.Quality_Assessments__r.size() == 0) {
                if(objCaseOwner != null && 
                   (applicableAgentTitles.contains(objCaseOwner.Profile.Name) &&
                    ! managerIds.contains(objCase.OwnerId)
                   ) 
                  )
                {
                    mapPendingEvalCases.put(objCase.OwnerId, objCase);     
                }
            }
        }
        System.debug('Case Ids which has no evaluations completed:' +mapPendingEvalCases.keySet()); 
        
        List<Case> lstMapData = new List<Case>(); 
        Set<Id> setExistingAgentIds = new Set<Id>(); 
        //for each case, group them for Manager or QA.
        for(Case objCase: mapPendingEvalCases.values()) {
            objCaseOwner = mapCaseOwnerInfo.get(objCase.OwnerId); //get the case owner information
            setCaseIds.add(objCase.Id); 
            if(objCaseOwner != null) {
                if( String.isNotBlank(objCaseOwner.CQI_Coach_User__c )) {
                    //if there is QA user is , assign this case to QA user. 
                    lstMapData = mapAssignments.get(objCaseOwner.CQI_Coach_User__c); 
                    if ( lstMapData == null ) {
                        lstMapData = new List<Case>(); 
                    }
                    lstMapData.add(objCase); 
                    mapAssignments.put(objCaseOwner.CQI_Coach_User__c , lstMapData); 
                }
                else if (String.isNotBlank(objCaseOwner.ManagerId )){
                    lstMapData = mapAssignments.get(objCaseOwner.ManagerId); 
                    if ( lstMapData == null ) {
                        lstMapData = new List<Case>(); 
                    }
                    lstMapData.add(objCase); 
                    mapAssignments.put(objCaseOwner.ManagerId , lstMapData);   
                }    
            }
        } 
        Date recentAssignedDate = Date.today().addDays(-lastNDays); 
        List<CQA_Summary__c> lstExisting = [SELECT Id, OwnerId, QA_Eval_Recommended_Date__c,
                                            QA_Eval_No_of_case_evaluation_suggested__c
                                            FROM CQA_Summary__c
                                            WHERE OwnerID IN: mapAssignments.keySet()
                                            AND RecordTypeId =: parentSummaryRecTypeId
                                            AND QA_Eval_Recommended_Date__c >= :recentAssignedDate 
                                            LIMIT : (Limits.getLimitQueryRows()  - Limits.getQueryRows())
                                           ];
        for(CQA_Summary__c objVar : lstExisting ) {
            mapExistingSuggestions.put(objVar.OwnerId , objVar); 
        }
        
        for(CQA_Summary__c objVar : [SELECT Id, QA_Eval_Case__c FROM CQA_Summary__c 
                                     WHERE QA_Evaluation_Suggestion_Parent__c IN :mapExistingSuggestions.keyset() 
                                     AND RecordTypeId =: relatedChildRecTypeId
                                     AND QA_Eval_Case__c IN: setCaseIds 
                                     LIMIT : (Limits.getLimitQueryRows()  - Limits.getQueryRows())
                                    ]) 
        {
            existingCaseAssignments.add(objVar.QA_Eval_Case__c); //to avoid same case repeated more than once. 
        }
        System.debug('Map Assignments: '+mapAssignments);
        for(Id userId : mapAssignments.keySet()) {
            if(! mapExistingSuggestions.containsKey(userId)) {
                objSuggestion = new CQA_Summary__c();
                objSuggestion.OwnerId = userId ; 
                objSuggestion.Name = RECORD_PREFIX ; //record name prefix QA Evaluation Record - {Number}
                objSuggestion.QA_Eval_Recommended_Date__c = System.today() ; 
                objSuggestion.RecordTypeId = parentSummaryRecTypeId;
                lstParentSuggestions.add(objSuggestion);     
            }
        }
        
        if(lstParentSuggestions.size() >0 ) {
            Database.insert(lstParentSuggestions); 
            
            lstParentSuggestions = [SELECT Id, OwnerId, QA_Eval_Recommended_Date__c,
                                    QA_Eval_No_of_case_evaluation_suggested__c,
                                    (SELECT Id , Case__r.OwnerId FROM Case_Evaluation_Suggestions__r)
                                    FROM CQA_Summary__c
                                    WHERE OwnerID IN: mapAssignments.keySet()
                                    AND RecordTypeId =: parentSummaryRecTypeId
                                    AND QA_Eval_Recommended_Date__c >= :recentAssignedDate
                                    LIMIT : (Limits.getLimitQueryRows()  - Limits.getQueryRows())
                                   ];
            for(CQA_Summary__c objVar : lstParentSuggestions ) {
                mapExistingSuggestions.put(objVar.OwnerId , objVar);
                //create a map to set of already identified case owners 
                setCaseOwnerIds = new Set<Id>(); 
                for(CQA_Summary__c objCaseEval : objVar.Case_Evaluation_Suggestions__r) {
                    setCaseOwnerIds.add(objCaseEval.Case__r.OwnerId); 
                }
                mapExistingOwners.put(objVar.OwnerId , setCaseOwnerIds);
            }
        }
        
        for(Id userId : mapAssignments.keySet()) {
            objSuggestion = mapExistingSuggestions.get(userId); 
            if(objSuggestion != null) {
                lstMapData = mapAssignments.get(userId) ; 
                setExistingAgentIds = mapExistingOwners.get(userId); 
                if(lstMapData != null) {
                    for(Case objCase: lstMapData ) {
                        if(
                            !existingCaseAssignments.contains(objCase.Id) &&
                            (setExistingAgentIds == null || (setExistingAgentIds != null && !setExistingAgentIds.contains(objCase.OwnerId)) )
                           
                          ) 
                        {
                            objCaseSuggestion = new CQA_Summary__c(); 
                            objCaseSuggestion.QA_Evaluation_Suggestion_Parent__c = objSuggestion.Id ; 
                            objCaseSuggestion.ownerId = userId ; 
                            objCaseSuggestion.Name = RECORD_PREFIX ; 
                            objCaseSuggestion.QA_Eval_Case__c = objCase.Id ; 
                            objCaseSuggestion.RecordTypeId = relatedChildRecTypeId ; 
                            lstCaseSuggestions.add(objCaseSuggestion);   
                            
                        }
                    }
                }
                
            }
        }
        
        if(lstCaseSuggestions.size() > 0 ) {
            //insert with allorNone to false, if failures, continue insert with others. 
            Database.SaveResult[] resultList = Database.insert(lstCaseSuggestions,false); 
            //update number of recommended cases back to parent. 
            Set<Id> caseSuggestionIds = new Set<Id>();
            for ( Database.SaveResult objResult : resultList ) {
                caseSuggestionIds.add(objResult.getId()); 
            }
            //map parent --> child record ids, this value will be assigned to Case Evaluation Assigned field
            Map<Id, Set<Id>> mapParentToChildSuggestions = new Map<Id, Set<Id>>(); 
            Set<Id> setRecordIds = new Set<Id>(); 
            for(CQA_Summary__c objEval : [SELECT Id , QA_Evaluation_Suggestion_Parent__c
                                          FROM CQA_Summary__c 
                                          WHERE ID IN: caseSuggestionIds 
                                         ])
            {
                setRecordIds = mapParentToChildSuggestions.get(objEval.QA_Evaluation_Suggestion_Parent__c); 
                if (setRecordIds == null) {//first entry, to initialize
                    setRecordIds = new Set<Id>(); 
                }
                if(String.isNotBlank(objEval.Id)) {
                    setRecordIds.add(objEval.Id) ;
                    mapParentToChildSuggestions.put(objEval.QA_Evaluation_Suggestion_Parent__c ,setRecordIds ); 
                }
                
            }
            
            //query all parent records
            
            for(CQA_Summary__c objEval : [SELECT Id , QA_Eval_No_of_case_evaluation_suggested__c
                                          FROM CQA_Summary__c
                                          WHERE ID IN: mapParentToChildSuggestions.keySet()])
            {
                setRecordIds = mapParentToChildSuggestions.get(objEval.Id); 
                if(setRecordIds != null) {
                    objEval.QA_Eval_No_of_case_evaluation_suggested__c += setRecordIds.size() ; 
                    lstToUpdate.add(objEval); 
                }
            }
        }
        //update parent records with number of cases recommended
        if(lstToUpdate.size() > 0) {
            Database.update(lstToUpdate); 
        }
        System.debug('Evaluation Suggestions: '+lstToUpdate); 
    }
    
    /*
     * @Description: Utility method to get the case owner information to identify the owner's manager or QA user. 
     * */
    private Map<Id, User> getMapCaseOwnerInfo(List<Case> lstInputs ) {
        Set<Id> setOwnerIds = new Set<Id>(); 
        for(Case objCase: lstInputs) {
            setOwnerIds.add(objCase.OwnerId); 
        }
        Map<Id, User> results = new Map<Id, User>(
            [SELECT Id, ManagerId, CQI_Coach_User__c , Title , Profile.Name 
             FROM User 
             WHERE Id IN: setOwnerIds
             AND IsActive = TRUE AND Manager.IsActive = TRUE 
             LIMIT : (Limits.getLimitQueryRows()  - Limits.getQueryRows())
            ]
        ); 
        
        return results ; 
    }
    
    /*
     * @Description: Method to query case owner ids with ManagerId to
     * verify if the case owner is a manager for any other user. 
     * */
    private Set<Id> getMapManagerUsers( List<Case> lstInputs) {
        Set<Id> setOwnerIds = new Set<Id>(); 
        for(Case objCase: lstInputs) {
            setOwnerIds.add(objCase.OwnerId); 
        }
        Set<Id> results = new Set<Id>(); 
        for(User objUser : [SELECT Id, ManagerId, CQI_Coach_User__c , Title , Profile.Name
                            FROM User 
                            WHERE ManagerId IN: setOwnerIds
                            AND IsActive = TRUE 
                            LIMIT : (Limits.getLimitQueryRows()  - Limits.getQueryRows())
                           ])
        {
            results.add(objUser.ManagerId); 
        }
        
        return results ; 
    }
    /*
     * @Description: finish method to call Task Assignments batch. 
     * */
    public void finish(Database.BatchableContext objBC) {
        //call batch for finding call tasks evaluations.
        CQI_BatchAssignmentsforCall obj = new CQI_BatchAssignmentsforCall(); 
        Database.executeBatch(obj) ; 
    }
    
}