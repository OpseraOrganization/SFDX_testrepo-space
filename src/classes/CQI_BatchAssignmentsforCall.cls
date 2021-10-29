/************************************************************
 * @Description: Batch execution class to assign closed call tasks for evaluation. 
 * This batch class is executed from finish method of CQI_BatchAssignments. 
 * Once completed case are suggested, completed calls batch will be executed & added to the existing QA Evaluation (if any)
 * for given user or create new QA evaluation.   
 * Test Class: CQI_BatchAssignmentsforCallTest
 * *********************************************************/
public with Sharing class CQI_BatchAssignmentsforCall implements Database.Batchable<sObject> {
    
    Integer lastNDays = 0 ; 
    List<String> caseRecordTypes = new List<String>();  
    List<String> caseExcludedReasons = new List<String>(); 
    Integer callMinLength = 0 ; 
    Integer callMaxLength = 0 ; 
    List<String> applicableAgentTitles = new List<String>(); 
    private final String RECORD_PREFIX = 'QA Evaluation '; 
    /*
     * @Description: start method 
     * */
    public Database.QueryLocator start (Database.BatchableContext objBC) {
        initBatchSettings(); 
        String queryClosedCases = 'SELECT Id,OwnerId,Owner.name,Owner.Title, Subject,WhatId,inContact_Call_Duration_in_Sec__c FROM Task '+
            ' WHERE CompletedDateTime = LAST_N_DAYS:'+lastNDays+' AND WhatId != null AND Type = \'Call\' '+
            ' AND inContact_ContactId__c != null '; 
        
        return Database.getQueryLocator(queryClosedCases) ; 
    }
    
    /*
     * @Description: Utility method to initiate batch settings from custom metadata
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
            if(cqiBatchSetting.DeveloperName.StartsWith('Call_Recording_Length_Min_Value')) {
                callMinLength = Integer.ValueOf(cqiBatchSetting.value__c ); 
            }
            if(cqiBatchSetting.DeveloperName.StartsWith('Call_Recording_Length_Max_Value')) {
                callMaxLength = Integer.ValueOf(cqiBatchSetting.value__c ); 
            }
            if(cqiBatchSetting.DeveloperName.StartsWith('Agent_Title')) {
                applicableAgentTitles.addAll(cqiBatchSetting.value__c.split(';')); 
            }
        }
    }
    
    /*
     * @Description: execute method of batch. 
     * */
    public void execute(Database.BatchableContext objBC , List<Task> lstCallTasks) {
        initBatchSettings(); 
        Id parentSummaryRecTypeId = null ; 
        Id relatedChildRecTypeId = null ;
        User objTaskOwner = new User(); 
        Date recentAssignedDate = Date.today().addDays(-lastNDays);
        Set<Id> setTaskOwnerIds = new Set<Id>();
        //Map to avoid suggesting more than 1 case for an agent, when batch runs in multiple iterations. 
        Map<Id,Set<Id>> mapExistingOwners = new Map<Id,Set<Id>>();
        Map<Id,Id> mapTaskExistingEvals = new Map<Id, Id>(); 
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
        List<CQA_Summary__c> lstTaskSuggestions = new List<CQA_Summary__c>();
        
        Map<Id , CQA_Summary__c> mapExistingSuggestions = new Map<Id, CQA_Summary__c>(); 
        CQA_Summary__c objSuggestion = new CQA_Summary__c(); 
        CQA_Summary__c objTaskSuggestion = new CQA_Summary__c(); 
        //Map variables to consolidate list of cases which needs to assigned for Manager or QA. 
        Map<Id, List<Task>> mapAssignments = new Map<Id,List<Task>>(); 
        Map<Id, User> mapTaskOwnerInfo = getMapTaskOwnerInfo(lstCallTasks); 
        
        /*
         * NOTE: This variable will be having ids of Manager users, 
         * suppose if a case is owned by Manager, it will not
         * be suggested for evaluation. 
         * */
        Set<Id> managerIds = getMapManagerUsers( lstCallTasks ); 
        
        System.debug('List of cases for processing: '+lstCallTasks.size());
        //get task's related cases
        Map<Id,Case> mapCaseInfo = getMapCaseInfo(lstCallTasks); 
        //list to filter cases, which does not contain an existing call assessment in the child record relationship
        //Map owner id -> case, This is to select max. 1 case per agent. 
        Set<Id> taskIds = new Set<Id>(); 
        for(Task objTask : lstCallTasks) {
            taskIds.add(objTask.Id); 
        }
        // verify if the completed Tasks have a completed assessment or already suggested assessment
        for(CQA_Summary__c objEval : [SELECT ID , QA_Eval_Task_Id__c,Task_Id__c 
                                      FROM CQA_Summary__c
                                      WHERE ( QA_Eval_Task_Id__c IN : taskIds  OR Task_Id__c IN: taskIds )
                                      LIMIT : (Limits.getLimitQueryRows()  - Limits.getQueryRows())])
        {
            //task id entries in this map will be ignored for creating task suggestion records.  
            if(String.isNotBlank(objEval.QA_Eval_Task_Id__c)) {
                // if this task has been already recommended , add it to map
            	mapTaskExistingEvals.put(objEval.QA_Eval_Task_Id__c , objEval.Id);     
            }
            if(String.isNotBlank(objEval.Task_Id__c)) {
                mapTaskExistingEvals.put(objEval.QA_Eval_Task_Id__c , objEval.Id);     
            }
        }
        Map<Id,Task> mapPendingEvalCases = new Map<Id, Task>(); 
        Integer callDuration ;
        Case relatedCase = new Case(); 
        for(Task objTask : lstCallTasks) {
            if(String.isNotBlank(objTask.inContact_Call_Duration_in_Sec__c)) {
                callDuration = Integer.valueOf(objTask.inContact_Call_Duration_in_Sec__c); 
            }
            else {
                callDuration = null ; 
            }
            
            relatedCase = mapCaseInfo.get(objTask.WhatId); 
            objTaskOwner = mapTaskOwnerInfo.get(objTask.OwnerId); 
            if(relatedCase != null && callDuration != null && objTaskOwner != null) {
                //Tasks are filtered in this way, since, these filter can't be applied in SOQL. Integer to String constraint
                if(
                    callDuration >= callMinLength && callDuration <= callMaxLength &&
                    caseRecordTypes.contains(relatedCase.RecordType.DeveloperName) &&
                    caseExcludedReasons.contains(relatedCase.Status) &&
                    !mapTaskExistingEvals.containsKey(objTask.id) && 
                    ( 
                        applicableAgentTitles.contains(objTaskOwner.Profile.Name) &&
                        ! managerIds.contains(objTask.OwnerId)
                    )
                ) 
                {
                    mapPendingEvalCases.put(objTask.OwnerId, objTask);     
                }
            }
        }
        System.debug('Case Ids which has no evaluations completed:' +mapPendingEvalCases.keySet()); 
        List<Task> lstMapData = new List<Task>(); 
        Set<Id> setExistingAgentIds = new Set<Id>(); 
        //for each case, group them for Manager or QA.
        for(Task objTask: mapPendingEvalCases.values()) {
            objTaskOwner = mapTaskOwnerInfo.get(objTask.OwnerId); //get the case owner information
            if(objTaskOwner != null ) {
                if( String.isNotBlank(objTaskOwner.CQI_Coach_User__c )) {
                    //if there is QA user is , assign this case to QA user. 
                    lstMapData = mapAssignments.get(objTaskOwner.CQI_Coach_User__c); 
                    if ( lstMapData == null ) {
                        lstMapData = new List<Task>(); 
                    }
                    lstMapData.add(objTask); 
                    mapAssignments.put(objTaskOwner.CQI_Coach_User__c , lstMapData); 
                }
                else if (String.isNotBlank(objTaskOwner.ManagerId )) {
                    lstMapData = mapAssignments.get(objTaskOwner.ManagerId); 
                    if ( lstMapData == null ) {
                        lstMapData = new List<Task>(); 
                    }
                    lstMapData.add(objTask); 
                    mapAssignments.put(objTaskOwner.ManagerId , lstMapData);   
                }    
            }
            
        }
        
        List<CQA_Summary__c> lstExisting = [SELECT Id, OwnerId, 
                                            QA_Eval_Recommended_Date__c,
                                            QA_Eval_No_of_call_evaluation_suggested__c
                                            FROM CQA_Summary__c
                                            WHERE OwnerID IN: mapAssignments.keySet()
                                            AND RecordTypeId =: parentSummaryRecTypeId
                                            AND QA_Eval_Recommended_Date__c >= :recentAssignedDate 
                                            LIMIT : (Limits.getLimitQueryRows()  - Limits.getQueryRows())
                                           ];
        for(CQA_Summary__c objVar : lstExisting ) {
            mapExistingSuggestions.put(objVar.OwnerId , objVar); 
        }
        
        for(Id userId : mapAssignments.keySet()) {
            if(! mapExistingSuggestions.containsKey(userId)) {
                objSuggestion = new CQA_Summary__c();
                objSuggestion.OwnerId = userId ; 
                objSuggestion.Name = RECORD_PREFIX ; 
                objSuggestion.QA_Eval_Recommended_Date__c = System.today() ; 
                objSuggestion.RecordTypeId = parentSummaryRecTypeId ; 
                lstParentSuggestions.add(objSuggestion);     
            }
        }
        
        if(lstParentSuggestions.size() >0 ) {
            Database.insert(lstParentSuggestions); 
            
            lstParentSuggestions = [SELECT Id, OwnerId, QA_Eval_Recommended_Date__c,
                                    QA_Eval_No_of_call_evaluation_suggested__c,
                                    (SELECT Id, QA_Eval_Task_Owner_Id__c FROM Call_Evaluation_Suggestions__r)
                                    FROM CQA_Summary__c
                                    WHERE OwnerID IN: mapAssignments.keySet()
                                    AND RecordTypeId =: parentSummaryRecTypeId
                                    AND QA_Eval_Recommended_Date__c >= :recentAssignedDate 
                                    LIMIT : (Limits.getLimitQueryRows()  - Limits.getQueryRows())
                                   ];
            for(CQA_Summary__c objVar : lstParentSuggestions ) {
                mapExistingSuggestions.put(objVar.OwnerId , objVar); 
                //create a map to set of already identified case owners 
                setTaskOwnerIds = new Set<Id>(); 
                for(CQA_Summary__c objCaseEval : objVar.Call_Evaluation_Suggestions__r) {
                    if(objCaseEval.QA_Eval_Task_Owner_Id__c != null) {
                        setTaskOwnerIds.add(objCaseEval.QA_Eval_Task_Owner_Id__c);     
                    }
                }
                mapExistingOwners.put(objVar.OwnerId , setTaskOwnerIds); 
            }
        }
        Set<Id> parentIds = new Set<Id>(); 
        Map<Id , Id> mapTaskIdToEvals = new Map<Id, Id>(); 
        
        for(Id userId : mapAssignments.keySet()) {
            objSuggestion = mapExistingSuggestions.get(userId); 
            if(objSuggestion != null) {
                lstMapData = mapAssignments.get(userId) ; 
                parentIds.add(objSuggestion.Id); 
                setExistingAgentIds = mapExistingOwners.get(userId); 
                
                for(Task objTask: lstMapData ) {
                    if(setExistingAgentIds == null || (setExistingAgentIds != null && ! setExistingAgentIds.contains(objTask.OwnerId))) {
                        objTaskSuggestion = new CQA_Summary__c(); 
                        objTaskSuggestion.QA_Evaluation_Suggestion_Call__c = objSuggestion.Id ; 
                        objTaskSUggestion.Name = RECORD_PREFIX ; 
                        objTaskSuggestion.QA_Eval_Task_Id__c = objTask.Id ; 
                        objTaskSuggestion.QA_Eval_Task_Subject__c = objTask.Subject ; 
                        objTaskSUggestion.OwnerId = userId ; 
                        objTaskSuggestion.QA_Eval_Task_Assigned_To__c = objTask.Owner.name ; 
                        objTaskSuggestion.RecordTypeId = relatedChildRecTypeId ; 
                        objTaskSuggestion.QA_Eval_Task_Owner_Id__c = objTask.OwnerId ; 
                        // to prevent any duplicate entries in suggestion for a case owner under same parent suggestion record. 
                        objTaskSuggestion.QA_Evaluation_Unique_Key__c = 'Task'+'_'+objSuggestion.Id+'_'+objTask.OwnerId ; 
                        
                        
                        if(objTask.WhatId!= null && mapCaseInfo.containsKey(objTask.WhatId)) {
                            objTaskSuggestion.QA_Eval_Task_Related_Case_Id__c = mapCaseInfo.get(objTask.WhatId).Id ; 
                            objTaskSuggestion.QA_Eval_Task_Related_Case_Number__c = mapCaseInfo.get(objTask.WhatId).CaseNumber ; 
                        }
                        
                        lstTaskSuggestions.add(objTaskSuggestion); 
                        
                    }
                        
                }
                
            }
        }
        
        if(lstTaskSuggestions.size() > 0) {
            //insert with allorNone to false, if failures, continue insert with others. 
            Database.SaveResult[] resultList = Database.insert(lstTaskSuggestions,false) ;
            //update number of recommended cases back to parent. 
            Set<Id> callSuggestionIds = new Set<Id>();
            for ( Database.SaveResult objResult : resultList ) {
                callSuggestionIds.add(objResult.getId()); 
            }
            //map parent --> child record ids, this value will be assigned to Case Evaluation Assigned field
            Map<Id, Set<Id>> mapParentToChildSuggestions = new Map<Id, Set<Id>>(); 
            Set<Id> setRecordIds = new Set<Id>(); 
            for(CQA_Summary__c objEval : [SELECT Id , QA_Evaluation_Suggestion_Call__c
                                          FROM CQA_Summary__c 
                                          WHERE ID IN: callSuggestionIds])
            {
                setRecordIds = mapParentToChildSuggestions.get(objEval.QA_Evaluation_Suggestion_Call__c); 
                if (setRecordIds == null) {//first entry, to initialize
                    setRecordIds = new Set<Id>(); 
                }
                if(String.isNotBlank(objEval.Id)) {
                    setRecordIds.add(objEval.Id) ;
                    mapParentToChildSuggestions.put(objEval.QA_Evaluation_Suggestion_Call__c ,setRecordIds ); 
                }
                
            }
            
            //query all parent records
            
            for(CQA_Summary__c objEval : [SELECT Id , QA_Eval_No_of_call_evaluation_suggested__c
                                          FROM CQA_Summary__c
                                          WHERE ID IN: mapParentToChildSuggestions.keySet()])
            {
                setRecordIds = mapParentToChildSuggestions.get(objEval.Id); 
                if(setRecordIds != null) {
                    objEval.QA_Eval_No_of_call_evaluation_suggested__c += setRecordIds.size() ; 
                    lstToUpdate.add(objEval); 
                }
            }
        }
        
        for(CQA_Summary__c objEval : [SELECT Id, QA_Eval_Task_Owner_Id__c 
                                      FROM CQA_Summary__c
                                      WHERE QA_Evaluation_Suggestion_Call__c IN :parentIds 
                                      AND QA_Eval_Task_Owner_Id__c != null])
        {
            mapTaskIdToEvals.put(objEval.QA_Eval_Task_Owner_Id__c , objEval.Id) ; 
        }
        system.debug('Map Task Ids to Evals'+mapTaskIdToEvals); 
        
        if(lstToUpdate.size() > 0) {
            Database.update(lstToUpdate); 
        }
        System.debug('Evaluation Suggestions: '+lstToUpdate); 
    }
    
        
    /*
     * @Description: Utlity method to get the task owner information 
     * */
    private Map<Id, User> getMapTaskOwnerInfo(List<Task> lstInputs ) {
        Set<Id> setOwnerIds = new Set<Id>(); 
        for(Task objTask: lstInputs) {
            setOwnerIds.add(objTask.OwnerId); 
        }
        Map<Id, User> results = new Map<Id, User>(
            [SELECT Id, ManagerId, CQI_Coach_User__c, Title, Profile.Name
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
    private Set<Id> getMapManagerUsers( List<Task> lstInputs) {
        Set<Id> setOwnerIds = new Set<Id>(); 
        for(Task objTask: lstInputs) {
            setOwnerIds.add(objTask.OwnerId); 
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
     * @Description: Method to get Task's related case information
     * */
    private Map<Id,Case> getMapCaseInfo(List<Task> lstInputs) {
        Set<Id> setCaseIds = new Set<Id>(); 
        for(Task objTask: lstInputs) {
            setCaseIds.add(objTask.WhatId); 
        }
        Map<Id, Case> results = new Map<Id, Case>(
            [SELECT Id, CaseNumber , RecordType.DeveloperName, 
            Status
             FROM Case
             WHERE Id IN: setCaseIds
             LIMIT : (Limits.getLimitQueryRows()  - Limits.getQueryRows())
            ]
        ); 
        
        return results ; 
        
    }
    
    /*
     * @Description: finish method 
     * */
    public void finish(Database.BatchableContext objBC) {
        // no operation. 
    }

}