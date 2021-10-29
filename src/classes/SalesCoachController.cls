/*************************************************
 * @Description : Controller Class for the component Gamification
 * ************************************************/
public with Sharing class SalesCoachController {
    
    private static final String CURRENT_USER = UserInfo.getUserId() ; 
    private static Set<Id> MY_TEAM_USERS = new Set<Id>(); 
    private static Set<Id> oppId = new Set<Id>();
    private static String appName;
    private static final String QUARTER_PERIOD_TYPE = 'Quarter';
    
    /******************************************************
     * @Description : Method to get the fiscal end date of the current organization. 
     * ****************************************************/
    @AuraEnabled
    public static String getFiscalEndDate() {
        Date closeDate ; 
        TimeInfoWrapper objTimeInfo = new TimeInfoWrapper(); 
        closeDate = [SELECT EndDate FROM Period WHERE Type =: QUARTER_PERIOD_TYPE AND StartDate =THIS_FISCAL_QUARTER LIMIT 1].EndDate ; 
        objTimeInfo.fiscalEndDateTime = String.valueOf(DateTime.newInstance(closeDate, Time.newInstance(23, 59, 59, 0))) ; 
        objTimeInfo.systemNowTime = String.valueOf(System.now()); 
        return JSON.serialize(objTimeInfo); 
    } 
    
    /****************************************************
     * Description : Method to get the list of fields configured for the current view. 
     * **************************************************/
    @AuraEnabled
    public static List<String> getConfiguredFields(String metadataName) {
        List<String> lstResults = new List<String>() ; 
        //System.debug('metadataName===='+metadataName);
        if(String.isNotBlank(metadataName)) {
            List<Pipeline_Review__mdt> lstCurrentMetadata = [SELECT id , Fields_API_Name__c, Fields_API_Name2__c
                                                             FROM Pipeline_Review__mdt 
                                                             WHERE DeveloperName =: metadataName LIMIT 1];
            if(!lstCurrentMetadata.isEmpty()) {
                if(metadataName == 'GROUP1_1_Health' || metadataName == 'GROUP1_1_Team_Health'){
                    for(String fieldName : lstCurrentMetadata[0].Fields_API_Name2__c.split(',')) {
                        fieldName = fieldName.trim(); //trim all empty spaces
                        if(!fieldName.contains('.')){//ignore look ups like Account.Name 
                            lstResults.add(fieldName);     
                        }                    
                    }
                }else{
                    for(String fieldName : lstCurrentMetadata[0].Fields_API_Name__c.split(',')) {
                        fieldName = fieldName.trim(); //trim all empty spaces
                        if(!fieldName.contains('.')){//ignore look ups like Account.Name 
                            lstResults.add(fieldName);     
                        }                    
                    }
                }
            }
        }
        //System.debug('lstResults===='+lstResults);
        return lstResults ; 
    } 
    
    /**********************************************
     * @Description : Method to get the pipeline review records with their current counts. 
     * ********************************************/
    @AuraEnabled
    public static string getPipelineReviews(Boolean isTeamView) {
        
        SalesCoach_Utility objUtility = new SalesCoach_Utility(); 
        List<ReviewInfoWrapper> lstResults = new List<ReviewInfoWrapper>(); 
        ReviewInfoWrapper objResult = new ReviewInfoWrapper(); 
        List<String> lstQueryStrings = new List<String>(); 
        ReviewInfo objInfo = new ReviewInfo(); 
        List<User> lstCurrentUser = new List<User>(); 
        Map<String , List<ReviewInfo>> mapReviewToTitle = new Map<String , List<ReviewInfo>>(); 
        List<ReviewInfo> lstInfos = new List<ReviewInfo>(); 
        
        
        if(objUtility.isUserCanManageMetadata()) {
            //System.debug('Inside system admin for getting all data' + objUtility.getAllRecords(isTeamView)); 
            for(Pipeline_Review__mdt objReview : objUtility.getAllRecords(isTeamView)) 
            {
                objInfo = new ReviewInfo(); 
                objInfo.label = objReview.MasterLabel ; 
                objInfo.uniqueName = objReview.DeveloperName ;
                objInfo.helpText = objReview.Help_Text__c ; 
                objInfo.count = 0 ; //initalize all counts to 0 ,
                objInfo.cssProp.firstRangeLimit = Integer.valueOf(objReview.First_Range_Limit__c ); 
                objInfo.cssProp.firstRangeColor = objReview.First_Range_Limit_Color__c ; 
                objInfo.cssProp.secondRangeLimit = Integer.valueOf(objReview.Second_Range_Limit__c ); 
                objInfo.cssProp.secondRangeColor = objReview.Second_Range_Limit_Color__c ; 
                objInfo.cssProp.endLimitColor = objReview.End_Limit_Color__c ; 
                if(mapReviewToTitle.containsKey(objReview.Grouping_Title__c)) {
                    lstInfos = mapReviewToTitle.get(objReview.Grouping_Title__c); 
                    lstInfos.add(objInfo) ; 
                }
                else {
                    lstInfos = new List<ReviewInfo>();
                    lstInfos.add(objInfo) ; 
                }
                mapReviewToTitle.put(objReview.Grouping_Title__c , lstInfos); 
                
            }
        }
        else {
            
            for(Pipeline_Review__mdt objReview : objUtility.getConfiguredRecords(isTeamView)) 
            {
                objInfo = new ReviewInfo(); 
                objInfo.label = objReview.MasterLabel ; 
                objInfo.uniqueName = objReview.DeveloperName ;
                objInfo.helpText = objReview.Help_Text__c ; 
                objInfo.count = 0 ; //initalize all counts to 0 ,
                objInfo.cssProp.firstRangeLimit = Integer.valueOf(objReview.First_Range_Limit__c ); 
                objInfo.cssProp.firstRangeColor = objReview.First_Range_Limit_Color__c ; 
                objInfo.cssProp.secondRangeLimit = Integer.valueOf(objReview.Second_Range_Limit__c ); 
                objInfo.cssProp.secondRangeColor = objReview.Second_Range_Limit_Color__c ; 
                objInfo.cssProp.endLimitColor = objReview.End_Limit_Color__c ; 
                if(mapReviewToTitle.containsKey(objReview.Grouping_Title__c)) {
                    lstInfos = mapReviewToTitle.get(objReview.Grouping_Title__c); 
                    lstInfos.add(objInfo) ; 
                }
                else {
                    lstInfos = new List<ReviewInfo>();
                    lstInfos.add(objInfo) ; 
                }
                mapReviewToTitle.put(objReview.Grouping_Title__c , lstInfos); 
            }            
        }
       //System.debug('mapReviewToTitle apex=====>'+mapReviewToTitle);
        for(String key : mapReviewToTitle.keySet()) {
            objResult = new ReviewInfoWrapper(); 
            objResult.groupingTitle = key ; 
            objResult.lstReviews = mapReviewToTitle.get(key) ; 
            lstResults.add(objResult) ; 
        }   
        //System.debug('lstResults apex=====>'+lstResults);
        return JSON.serialize(lstResults);
    }
       /**********************************************
     * @Description : Method to get the list of configured Pipeline Review records. 
     * ********************************************/
    @AuraEnabled 
    public static String getTableData(String inputValue) {
        TableViewInfoWrapper objResponse = new TableViewInfoWrapper(); 
        appName = inputValue;
        //System.debug(appName+'<-- app name ==>Table inputValue == '+inputValue);
        if(String.isNotBlank(inputValue)) {
            List<Pipeline_Review__mdt> lstMetaData = [SELECT id , Object_API_Name__c , Fields_API_Name__c , Condition_Expression__c ,
                                                      Restrict_Records_to_Owner__c , MasterLabel , DeveloperName , Limit__c , 
                                                      Generate_From_Apex__c , Apex_Unique_Identifier__c , Help_Text__c,
                                                      Is_Team_View__c, Condition_Expression_2__c, Fields_API_Name2__c
                                                      FROM Pipeline_Review__mdt WHERE DeveloperName =: inputValue LIMIT 1];
            if(!lstMetaData.isEmpty()) {
                objResponse.lstResults  = getSOQLRecords(lstMetaData[0]) ; //get the sobject records from Database.
                if(appName == 'GROUP1_1_Health' || appName == 'GROUP1_1_Team_Health'){
                    objResponse.lstResults  = getSOQLRecordsH(lstMetaData[0]) ; //get the sobject records from Database.
                }
                if(appName == 'GROUP1_2_QUALITY' || appName == 'GROUP1_2_Team_QUALITY'){
                    objResponse.lstResults  = getSOQLRecordsQ(lstMetaData[0]) ; //get the sobject records from Database.
                }
                if(appName == 'GROUP1_3_WINS' || appName == 'GROUP1_3_Teams_WINS'){
                    objResponse.lstResults  = getSOQLRecordsW(lstMetaData[0]) ; //get the sobject records from Database.
                }
                if(appName == 'GROUP1_4_LOADS' || appName == 'GROUP1_4_Team_LOADS'){
                    objResponse.lstResults  = getSOQLRecordsL(lstMetaData[0]) ; //get the sobject records from Database.
                }
                if(appName == 'GROUP2_1_F2F_MEETINGS'){
                    objResponse.lstResults  = getSOQLRecordsFTF(lstMetaData[0]) ; //get the sobject records from Database.
                }
                if(appName == 'GROUP2_2_VIRTUAL_MEETINGS'){
                    objResponse.lstResults  = getSOQLRecordsVM(lstMetaData[0]) ; //get the sobject records from Database.
                }
                if(appName == 'GROUP3_1_EXPIRED_CLOSE_DATE' || appName == 'GROUP3_1_Team_EXPIRED_CLOSE_DATE'){
                    objResponse.lstResults  = getSOQLRecordsECD(lstMetaData[0]) ; //get the sobject records from Database.
                }
                
                objResponse.lstColumns = parseColumnFields(lstMetaData[0]);
            }
        }
        //System.debug('Table objResponse ===='+objResponse);
        return JSON.serialize(objResponse); 
    }
    
    /***************************************************************
     * @Description: Method to get the Adjust Opps.
     * *************************************************************/
    @AuraEnabled
    public static String getAdjustOpps(Boolean isTeamView) {
        TableViewInfoWrapper objResponse = new TableViewInfoWrapper(); 
        SalesCoach_Utility objUtility = new SalesCoach_Utility(); 
        
        //initialize My team's set of ids
        
        if(isTeamView) {
            MY_TEAM_USERS = objUtility.getMyTeamUsers();
        }
        else{
            MY_TEAM_USERS.add(UserInfo.getUserId()); 
        }
        objResponse.lstResults  = [SELECT Id , Owner.Name , Amount , CloseDate 
                                   FROM Opportunity WHERE 
                                   CloseDate = THIS_FISCAL_QUARTER AND
                                   OwnerId IN: MY_TEAM_USERS
                                   LIMIT : (Limits.getLimitQueryRows() - Limits.getQueryRows())]; 
        
        objResponse.lstColumns = getAdjustOppColumns(); 
        
        return JSON.serialize(objResponse) ; 
    }
    
    /**********************************************
     * @Description : Method to identify type of fields , which is used by lightning data table to display 
     * the information. 
     * ********************************************/
    public static List<ColumnInfos> parseColumnFields(Pipeline_Review__mdt objInput) {
        List<ColumnInfos> lstResults = new List<ColumnInfos>();
        List<String> inputFieldNames = new List<String>(); //split using ',' identifier
        ColumnInfos objColumnInfo  = new ColumnInfos();
        Map<String , Schema.SObjectType> schemaTypes; 
            Schema.SObjectType objSchema; 
            Map<String , Schema.SObjectField> fieldTypes;
        if(appName == 'GROUP1_1_Health' || appName == 'GROUP1_1_Team_Health' || appName == 'GROUP1_2_QUALITY' || appName == 'GROUP1_2_Team_QUALITY' || appName == 'GROUP1_3_WINS' || appName == 'GROUP1_3_Teams_WINS' || appName == 'GROUP1_4_LOADS' || appName == 'GROUP1_4_Team_LOADS' || appName == 'GROUP3_1_EXPIRED_CLOSE_DATE' || appName == 'GROUP3_1_Team_EXPIRED_CLOSE_DATE'){
            String sObjectName = 'Opportunity' ; 
            //ColumnInfos objColumnInfo  = new ColumnInfos();         
            //Map<String , Schema.SObjectType> schemaTypes = Schema.getGlobalDescribe() ; 
            //Schema.SObjectType objSchema = schemaTypes.get(sObjectName) ; 
            //Map<String , Schema.SObjectField> fieldTypes = objSchema.getDescribe().fields.getMap() ;            
            schemaTypes = Schema.getGlobalDescribe() ; 
            objSchema = schemaTypes.get(sObjectName) ; 
            fieldTypes = objSchema.getDescribe().fields.getMap() ;
            for(String fieldName : objInput.Fields_API_Name2__c.split(',')) {
                fieldName = fieldName.trim(); //trim all empty spaces
                inputFieldNames.add(fieldName); 
            }
        }else{
            String sObjectName = objInput.Object_API_Name__c ; 
            //ColumnInfos objColumnInfo  = new ColumnInfos();         
            //Map<String , Schema.SObjectType> schemaTypes = Schema.getGlobalDescribe() ; 
            //Schema.SObjectType objSchema = schemaTypes.get(sObjectName) ; 
            //Map<String , Schema.SObjectField> fieldTypes = objSchema.getDescribe().fields.getMap() ; 
            schemaTypes = Schema.getGlobalDescribe() ; 
            objSchema = schemaTypes.get(sObjectName) ; 
            fieldTypes = objSchema.getDescribe().fields.getMap() ;
            //List<String> inputFieldNames = new List<String>(); //split using ',' identifier
            for(String fieldName : objInput.Fields_API_Name__c.split(',')) {
                fieldName = fieldName.trim(); //trim all empty spaces
                inputFieldNames.add(fieldName); 
            }
        }
        //System.debug('Fields list from metadata'+inputFieldNames);
        //System.debug('fieldTypeMap'+fieldTypes); 
        for(String fieldName : inputFieldNames) {
            objColumnInfo = new ColumnInfos(); 
            objColumnInfo.sortable = true ;
            //objColumnInfo.initialWidth = 150 ; 
            if(fieldName.indexOf('.')>1){
                objColumnInfo.label = fieldName.replace('.', ' '); 
                objColumnInfo.type = 'text'; 
                objColumnInfo.editable = false ;//dont allow edit on lookups.
                objColumnInfo.fieldName = fieldName ;//for unique column identifier
            }
            else {
                objColumnInfo.fieldName = fieldName ; 
                //System.debug('api name to process'+fieldName) ; 
                objColumnInfo.label = fieldTypes.get(fieldName).getDescribe().getLabel(); 
                Schema.DisplayType fielddatatype = fieldTypes.get(fieldName).getDescribe().getType();
                
                if(fielddataType == Schema.DisplayType.address) {
                    objColumnInfo.type = 'address' ; 
                    objColumnInfo.editable = true ; 
                }
                else if(fielddataType == Schema.DisplayType.email) {
                    objColumnInfo.type = 'email' ; 
                    objColumnInfo.editable = true ; 
                }
                else if(fielddataType == Schema.DisplayType.currency) {
                    objColumnInfo.type = 'currency' ; 
                    objColumnInfo.editable = true ; 
                }
                else if(fielddataType == Schema.DisplayType.phone) {
                    objColumnInfo.type = 'phone' ; 
                    objColumnInfo.editable = true ; 
                }
                else if(fielddataType == Schema.DisplayType.percent) {
                    objColumnInfo.type = 'percent' ; 
                    objColumnInfo.editable = true ; 
                }
                else if(fielddataType == Schema.DisplayType.url) {
                    objColumnInfo.type = 'url' ; 
                    objColumnInfo.editable = true ; 
                }
                else if(fielddataType == Schema.DisplayType.datetime) {
                    objColumnInfo.type = 'datetime' ; 
                    objColumnInfo.editable = true ; 
                }
                else if(fielddataType == Schema.DisplayType.Double) {
                    objColumnInfo.type = 'number' ; 
                    objColumnInfo.editable = true ; 
                }
                else if(fielddataType == Schema.DisplayType.Integer) {
                    objColumnInfo.type = 'number' ; 
                    objColumnInfo.editable = true ; 
                }
                else if(fielddataType == Schema.DisplayType.date) {
                    objColumnInfo.type = 'date-local' ; 
                    Map<String , String> attrMap = new Map<String , String>(); 
                    //objColumnInfo.typeAttributes.year = 'numeric';
                    attrMap.put('year', 'numeric');
                    //objColumnInfo.typeAttributes.month = 'short';
                    attrMap.put('month','short'); 
                    //objColumnInfo.typeAttributes.day = 'numeric';
                    attrMap.put('day','numeric'); 
                    //objColumnInfo.typeAttributes.minute = '2-digit';
                    //objColumnInfo.typeAttributes.hour = '2-digit';
                    objColumnInfo.typeAttributes = attrMap ; 
                    objColumnInfo.editable = true ; 
                }
                else if(fielddataType == Schema.DisplayType.string) {
                    objColumnInfo.type = 'text' ; 
                    objColumnInfo.editable = true ; 
                }
                else if(fielddataType == Schema.DisplayType.id) {
                    objColumnInfo.type = 'text' ; 
                    objColumnInfo.editable = false ; 
                }
                else if(fielddataType == Schema.DisplayType.reference) {
                    objColumnInfo.type = 'text' ; 
                    objColumnInfo.editable = false ; 
                }
                else if(fielddataType == Schema.DisplayType.picklist) {
                    objColumnInfo.type = 'text' ; 
                    objColumnInfo.editable = false ; 
                }
            }
            
            lstResults.add(objColumnInfo); 
        }
        
        return lstResults ; 
    }
    
    /**********************************************
     * @Description : Method to perform SOQL and identify the number of records 
     * for the configured pipeline review. 
     * This method take review name as input , runs the configured soql and get the record count. 
     * ********************************************/
    @AuraEnabled 
    public static String getCountValue(String apiName) {
        appName = apiName;
        CountInfoWrapper objResults = new CountInfoWrapper();  
        if(String.isNotBlank(apiName)) {
            List<Pipeline_Review__mdt> lstMetaData = [SELECT id , Object_API_Name__c , Fields_API_Name__c , Condition_Expression__c ,
                                                      Restrict_Records_to_Owner__c , MasterLabel , DeveloperName , Limit__c , 
                                                      Help_Text__c, Generate_From_Apex__c , Apex_Unique_Identifier__c,
                                                      Is_Team_View__c, Condition_Expression_2__c, Fields_API_Name2__c
                                                      FROM Pipeline_Review__mdt WHERE DeveloperName =: apiName LIMIT 1];
            if(!lstMetaData.isEmpty()) {                              
                //List<sObject> lstResults = getSOQLRecordsHel(lstMetaData[0]);

                List<sObject> lstResults = getSOQLRecords(lstMetaData[0]);
                objResults.metaApiName = apiName ;
                //objResults.count = lstResults.size();
                //System.debug('objResults====>'+objResults);
                if(apiName == 'GROUP1_1_Health' || apiName == 'GROUP1_1_Team_Health'){
                    lstResults = getSOQLRecordsH(lstMetaData[0]);
                    Decimal pipeAmout = getSOQLHEALTHRecords(lstMetaData[0]);
                  //  System.debug('Total Amount===='+pipeAmout);
                    objResults.count = pipeAmout;
                    objResults.countps = String.valueOf(objResults.count)+'%';
                    //System.debug('the ps is ===='+objResults.countps);
                }
                if(apiName == 'GROUP1_2_QUALITY' || apiName == 'GROUP1_2_Team_QUALITY'){
                    lstResults = getSOQLRecordsQ(lstMetaData[0]);
                    Decimal pipeAmout = getSOQLQUALITYRecords(lstMetaData[0]);
                  //  System.debug('Total Amount===='+pipeAmout);
                    objResults.count = pipeAmout;
                    objResults.countps = String.valueOf(pipeAmout)+'%';
                }
                if(apiName == 'GROUP1_4_LOADS' || apiName == 'GROUP1_4_Team_LOADS'){
                    lstResults = getSOQLRecordsL(lstMetaData[0]);
                    Decimal pipeAmout = getSOQLLOADSRecords(lstMetaData[0]);
                  //  System.debug('Total Amount===='+pipeAmout);
                    objResults.count = pipeAmout;
                    objResults.countps = String.valueOf(pipeAmout)+'%';
                }
                if(apiName == 'GROUP1_3_WINS' || apiName == 'GROUP1_3_Teams_WINS'){
                    lstResults = getSOQLRecordsW(lstMetaData[0]);
                    Decimal pipeAmout = getSOQLWinsRecords(lstMetaData[0]);
                   // System.debug('Total Amount===='+pipeAmout);
                    objResults.count = pipeAmout;
                    objResults.countps = String.valueOf(pipeAmout)+'%';
                }
                if(apiName == 'GROUP3_1_EXPIRED_CLOSE_DATE' || apiName == 'GROUP3_1_Team_EXPIRED_CLOSE_DATE'){
                    lstResults = getSOQLRecordsECD(lstMetaData[0]);
                    Decimal pipeAmout = getSOQLExpiredclosedateRecords(lstMetaData[0]);
                   // System.debug('Total Amount===='+pipeAmout);
                    objResults.count = pipeAmout;
                    objResults.countps = String.valueOf(pipeAmout);
                }
                if(apiName == 'GROUP2_1_F2F_MEETINGS'){
                    lstResults = getSOQLRecordsFTF(lstMetaData[0]);
                    Decimal pipeAmout = getSOQLF2FMeetingsRecords(lstMetaData[0]);
                  //  System.debug('Total Amount===='+pipeAmout);
                    objResults.count = pipeAmout;
                    objResults.countps = String.valueOf(pipeAmout);
                }
                if(apiName == 'GROUP2_2_VIRTUAL_MEETINGS'){
                    lstResults = getSOQLRecordsVM(lstMetaData[0]);
                    Decimal pipeAmout = getSOQLVirtualMeetingsRecords(lstMetaData[0]);
                   // System.debug('Total Amount===='+pipeAmout);
                    objResults.count = pipeAmout;
                    objResults.countps = String.valueOf(pipeAmout);
                }
            }    
        }
       // System.debug('objResults====>'+objResults);
        
        return JSON.serialize(objResults ); 
    }
    
    /**********************************************
     * @Description : Method to construct dynamic SOQL HEALTH Pipeline. 
     * ********************************************/
    
    private static Decimal getSOQLHEALTHRecords(Pipeline_Review__mdt objInput){
        List<sObject> lstResults = new List<sObject>(); 
        SalesCoach_Utility objUtility = new SalesCoach_Utility(); 
        Decimal sumHealth = 0.0;
        AggregateResult[] groupedResults;
        AggregateResult[] groupedResults1;
        //System.debug('objInput==='+objInput);
        //initialize My team's set of ids
        MY_TEAM_USERS = objUtility.getMyTeamUsers();
        if(objInput.Generate_From_Apex__c) { //if custom logic is required for getting sobjects
            SG_CustomLogicHelper objHelper = new SG_CustomLogicHelper(); 
            lstResults = objHelper.executeRequest(objInput) ; 
        }else{ //use configured simple SOQL             
            String query = 'SELECT User__c, SUM(Opportunity__r.Pipeline_Amount__c) total FROM '+objInput.Object_API_Name__c;
            String query1 = 'SELECT SUM(Opportunity__r.Pipeline_Amount__c) total FROM '+objInput.Object_API_Name__c;
            //Apply where condition if specified.
            Integer soqlLimit = Integer.valueOf(objInput.Limit__c);
           // System.debug('CURRENT_USER==='+CURRENT_USER);
            if(String.isNotBlank(objInput.Condition_Expression__c)) {
                query+= ' WHERE '+objInput.Condition_Expression__c ; 
                if(objInput.Restrict_Records_to_Owner__c) {
                    query += ' AND User__c =:CURRENT_USER ' ; 
                }else{
                    query += ' AND User__c =:MY_TEAM_USERS ' ; 
                }
            }
            if(String.isNotBlank(objInput.Condition_Expression_2__c)) {
                query1+= ' WHERE '+objInput.Condition_Expression_2__c ; 
                if(objInput.Restrict_Records_to_Owner__c) {
                    query1 += ' AND User__c =:CURRENT_USER ' ; 
                }else{
                    query1 += ' AND User__c =:MY_TEAM_USERS ' ; 
                }
            }
             
            query += ' GROUP BY User__c LIMIT :soqlLimit';
            query1 += ' GROUP BY User__c LIMIT :soqlLimit';
           // System.debug('Constructed SOQL ==>'+query); 
            //System.debug('Constructed SOQL ==>'+query1);
            String oppQuery = 'SELECT Opportunity__c, Opportunity__r.Pipeline_Amount__c FROM Opportunity_Sales_Team__c WHERE Opportunity__r.CBT_Tier_2__c != \'BendixKing CBT\' AND Opportunity__r.CloseDate = LAST_N_DAYS:365 AND (Opportunity__r.StageName = \'Closed Won\' OR Opportunity__r.StageName = \'Closed Lost\' OR Opportunity__r.StageName = \'Closed Cancelled\') AND User__c =\'0051300000CE3oU\' LIMIT 2000';
            //Fields and object name should be present before performing query. 
            if(String.isNotBlank(objInput.Fields_API_Name__c) && String.isNotBlank(objInput.Object_API_Name__c)) {
                groupedResults = Database.query(query);
                groupedResults1 = Database.query(query1);
                
            }
        }
        for(Opportunity_Sales_Team__c ost:[SELECT Opportunity__c, Opportunity__r.Pipeline_Amount__c FROM Opportunity_Sales_Team__c WHERE Opportunity__r.CBT_Tier_2__c != 'BendixKing CBT' AND Opportunity__r.CloseDate = LAST_N_DAYS:365 AND (Opportunity__r.StageName = 'Closed Won' OR Opportunity__r.StageName = 'Closed Lost' OR Opportunity__r.StageName = 'Closed Cancelled') AND User__c ='0051300000CE3oU' LIMIT 2000] ){
            oppId.add(ost.Opportunity__c);           
        }
        if(groupedResults.size() > 0 && groupedResults1.size() > 0){
            Decimal a = 0.00;
            Decimal b = 0.00;
            for(AggregateResult ar : groupedResults){
                Decimal a1 = (Decimal)ar.get('total');
                a += a1;
            }
            for(AggregateResult ar1 : groupedResults1){
              Decimal b1 = (Decimal) ar1.get('total');
                b += b1;
            }
            if(a > 0.00){
              sumHealth = (((a - b) / b)*100).setScale(1);
            }
           // System.debug('AggregateResult Health ===='+a);
          //  System.debug('AggregateResult Health opportuniy ===='+b);
          //  System.debug(sumHealth+'AggregateResult Health1===='+b);
        }
        
        return sumHealth;
    }
    /**********************************************
     * @Description : Method to construct dynamic SOQL QUALITY Pipeline. 
     * ********************************************/
    
    private static Decimal getSOQLQUALITYRecords(Pipeline_Review__mdt objInput){
        List<sObject> lstResults = new List<sObject>(); 
        SalesCoach_Utility objUtility = new SalesCoach_Utility(); 
        Decimal sumQUALITY = 0.0;
        AggregateResult[] groupedResults;
        AggregateResult[] groupedResults1;
        //System.debug('objInput==='+objInput);
        //initialize My team's set of ids
        MY_TEAM_USERS = objUtility.getMyTeamUsers();
        if(objInput.Generate_From_Apex__c) { //if custom logic is required for getting sobjects
            SG_CustomLogicHelper objHelper = new SG_CustomLogicHelper(); 
            lstResults = objHelper.executeRequest(objInput) ; 
        }else{ //use configured simple SOQL             
            String query = 'SELECT User__c, Count(Opportunity__c) total FROM '+objInput.Object_API_Name__c;
            String query1 = 'SELECT User__c, Count(Opportunity__c) total FROM '+objInput.Object_API_Name__c;
            //Apply where condition if specified.
            Integer soqlLimit = Integer.valueOf(objInput.Limit__c);
            if(String.isNotBlank(objInput.Condition_Expression__c)) {
                query+= ' WHERE '+objInput.Condition_Expression__c ; 
                if(objInput.Restrict_Records_to_Owner__c) {
                    query += ' AND User__c =:CURRENT_USER ' ; 
                }else{
                    query += ' AND User__c =:MY_TEAM_USERS ' ; 
                }
            }
            if(String.isNotBlank(objInput.Condition_Expression_2__c)) {
                query1+= ' WHERE '+objInput.Condition_Expression_2__c ; 
                if(objInput.Restrict_Records_to_Owner__c) {
                    query1 += ' AND User__c =:CURRENT_USER ' ; 
                }else{
                    query1 += ' AND User__c =:MY_TEAM_USERS ' ; 
                }
            }
             
            query += ' GROUP BY User__c LIMIT :soqlLimit';
            query1 += ' GROUP BY User__c LIMIT :soqlLimit';
            //System.debug('Constructed SOQL for Quality ==>'+query); 
            //System.debug('Constructed SOQL for Quality ==>'+query1);
            //Fields and object name should be present before performing query. 
            if(String.isNotBlank(objInput.Fields_API_Name__c) && String.isNotBlank(objInput.Object_API_Name__c)) {
                groupedResults = Database.query(query);
                groupedResults1 = Database.query(query1);
            }
        }
        if(groupedResults.size() > 0 && groupedResults1.size() > 0){
            //Decimal a = (Decimal)groupedResults[0].get('total');
            //Decimal b = (Decimal)groupedResults1[0].get('total');
            Decimal a = 0.00;
            Decimal b = 0.00;
            for(AggregateResult ar : groupedResults){
                Decimal a1 = (Decimal)ar.get('total');
                a += a1;
            }
            for(AggregateResult ar1 : groupedResults1){
              Decimal b1 = (Decimal) ar1.get('total');
                b += b1;
            }
            if(a > 0.00){
              sumQUALITY = ((b/a)*100).setScale(1);
            }
            //System.debug('AggregateResult ===='+a);
            //System.debug(sumQUALITY+'AggregateResult 1===='+b);
        }
        return sumQUALITY;
    }
    /**********************************************
     * @Description : Method to construct dynamic SOQL LOADS Pipeline. 
     * ********************************************/
    
    private static Decimal getSOQLLOADSRecords(Pipeline_Review__mdt objInput){
        List<sObject> lstResults = new List<sObject>(); 
        SalesCoach_Utility objUtility = new SalesCoach_Utility(); 
        Decimal sumLOADS = 0.0;
        AggregateResult[] groupedResults;
        AggregateResult[] groupedResults1;
        //System.debug('objInput==='+objInput);
        //initialize My team's set of ids
        MY_TEAM_USERS = objUtility.getMyTeamUsers();
        if(objInput.Generate_From_Apex__c) { //if custom logic is required for getting sobjects
            SG_CustomLogicHelper objHelper = new SG_CustomLogicHelper(); 
            lstResults = objHelper.executeRequest(objInput) ; 
        }else{ //use configured simple SOQL             
            String query = 'SELECT User__c, SUM(Opportunity__r.Pipeline_Amount__c) total FROM '+objInput.Object_API_Name__c;
            String query1 = 'SELECT User__c, SUM(Opportunity__r.Pipeline_Amount__c) total FROM '+objInput.Object_API_Name__c;
            //Apply where condition if specified.
            Integer soqlLimit = Integer.valueOf(objInput.Limit__c);
            if(String.isNotBlank(objInput.Condition_Expression__c)) {
                query+= ' WHERE '+objInput.Condition_Expression__c ; 
                if(objInput.Restrict_Records_to_Owner__c) {
                    query += ' AND User__c =:CURRENT_USER ' ; 
                }else{
                    query += ' AND User__c =:MY_TEAM_USERS ' ; 
                }
            }
            if(String.isNotBlank(objInput.Condition_Expression_2__c)) {
                query1+= ' WHERE '+objInput.Condition_Expression_2__c ; 
                if(objInput.Restrict_Records_to_Owner__c) {
                    query1 += ' AND User__c =:CURRENT_USER ' ; 
                }else{
                    query1 += ' AND User__c =:MY_TEAM_USERS ' ; 
                }
            }
            Datetime dt = System.today();
            String clDate = (dt.Year()-1)+'-01-01';
            Date closeDt = Date.valueOf(clDate);
            Date closeD1 = System.today().addYears(-1);
            Date closeDate = date.newinstance(closeDt.year(), closeDt.month(), closeDt.day());
            Date closeDate1 = date.newinstance(closeD1.year(), closeD1.month(), closeD1.day());
           //System.debug(closeDate+'The Date is==='+closeDate1);
            query += ' AND (Opportunity__r.CreatedDate >=: closeDate AND Opportunity__r.CreatedDate <=: closeDate1) GROUP BY User__c LIMIT :soqlLimit';
            query1 += ' GROUP BY User__c LIMIT :soqlLimit';     
            //System.debug('Constructed SOQL For Loads ==>'+query); 
            //System.debug('Constructed SOQL For Loads ==>'+query1);
            //Fields and object name should be present before performing query. 
            if(String.isNotBlank(objInput.Fields_API_Name__c) && String.isNotBlank(objInput.Object_API_Name__c)) {
                groupedResults = Database.query(query);
                groupedResults1 = Database.query(query1);
            }
        }
        if(groupedResults.size() > 0 && groupedResults1.size() > 0){
            //Decimal a = (Decimal)groupedResults[0].get('total');
            //Decimal b = (Decimal)groupedResults1[0].get('total');
            Decimal a = 0.00;
            Decimal b = 0.00;
            for(AggregateResult ar : groupedResults){
                Decimal a1 = (Decimal)ar.get('total');
                a += a1;
            }
            for(AggregateResult ar1 : groupedResults1){
              Decimal b1 = (Decimal) ar1.get('total');
                b += b1;
            }
            if(a > 0.00){
              sumLOADS = (((b - a) / a)*100).setScale(1);
            }
            //System.debug('AggregateResult ===='+a);
            //System.debug(sumLOADS+'AggregateResult 1===='+b);
        }
        return sumLOADS;
    }
 /**********************************************
     * @Description : Method to construct dynamic SOQL WINS Pipeline. 
     * ********************************************/
    
    private static Decimal getSOQLWinsRecords(Pipeline_Review__mdt objInput){
        List<sObject> lstResults = new List<sObject>(); 
        SalesCoach_Utility objUtility = new SalesCoach_Utility(); 
        Decimal sumWins = 0.0;
        AggregateResult[] groupedResults;
        AggregateResult[] groupedResults1;
        //System.debug('objInput==='+objInput);
        //initialize My team's set of ids
        MY_TEAM_USERS = objUtility.getMyTeamUsers();
        if(objInput.Generate_From_Apex__c) { //if custom logic is required for getting sobjects
            SG_CustomLogicHelper objHelper = new SG_CustomLogicHelper(); 
            lstResults = objHelper.executeRequest(objInput) ; 
        }else{ //use configured simple SOQL             
            String query = 'SELECT User__c, SUM(Opportunity__r.Pipeline_Amount__c) total FROM '+objInput.Object_API_Name__c;
            String query1 = 'SELECT User__c, SUM(Opportunity__r.Pipeline_Amount__c) total FROM '+objInput.Object_API_Name__c;
            //Apply where condition if specified.
            Integer soqlLimit = Integer.valueOf(objInput.Limit__c);
            if(String.isNotBlank(objInput.Condition_Expression__c)) {
                query+= ' WHERE '+objInput.Condition_Expression__c ; 
                if(objInput.Restrict_Records_to_Owner__c) {
                    query += ' AND User__c =:CURRENT_USER ' ; 
                }else{
                    query += ' AND User__c =:MY_TEAM_USERS ' ; 
                }
            }
            if(String.isNotBlank(objInput.Condition_Expression_2__c)) {
                query1+= ' WHERE '+objInput.Condition_Expression_2__c ; 
                if(objInput.Restrict_Records_to_Owner__c) {
                    query1 += ' AND User__c =:CURRENT_USER ' ; 
                }else{
                    query1 += ' AND User__c =:MY_TEAM_USERS ' ; 
                }
            }
            Datetime dt = System.today();
            String clDate = (dt.Year()-1)+'-01-01';
            Date closeDt = Date.valueOf(clDate);
            Date closeD1 = System.today().addYears(-1);
            Date closeDate = date.newinstance(closeDt.year(), closeDt.month(), closeDt.day());
            Date closeDate1 = date.newinstance(closeD1.year(), closeD1.month(), closeD1.day());
            //System.debug(closeDate+'The Date is==='+closeDate1);
            query += ' AND (Opportunity__r.CloseDate >=: closeDate AND Opportunity__r.CloseDate <=: closeDate1) GROUP BY User__c LIMIT :soqlLimit';
            query1 += ' GROUP BY User__c LIMIT :soqlLimit';
            //System.debug('Constructed SOQL1 For Loads ==>'+query); 
            //System.debug('Constructed SOQL2 For Loads ==>'+query1);
            //Fields and object name should be present before performing query. 
            if(String.isNotBlank(objInput.Fields_API_Name__c) && String.isNotBlank(objInput.Object_API_Name__c)) {
                groupedResults = Database.query(query);
                groupedResults1 = Database.query(query1);
            }
        }
        if(groupedResults.size() > 0 && groupedResults1.size() > 0){
            //Decimal a = (Decimal)groupedResults[0].get('total');
            //Decimal b = (Decimal)groupedResults1[0].get('total');
            Decimal a = 0.00;
            Decimal b = 0.00;
            for(AggregateResult ar : groupedResults){
                Decimal a1 = (Decimal)ar.get('total');
                a += a1;
            }
            for(AggregateResult ar1 : groupedResults1){
              Decimal b1 = (Decimal) ar1.get('total');
                b += b1;
            }
            if(a > 0.00){
              sumWins = (((b - a) / a)*100).setScale(2);
            }
            //System.debug('AggregateResult ===='+a);
            //System.debug(sumWins+'AggregateResult 1===='+b);
        }
        return sumWins;
    }   
     /**********************************************
     * @Description : Method to construct dynamic SOQL EXPIRED CLOSE DATE Pipeline. 
     * ********************************************/
    
    private static Decimal getSOQLExpiredclosedateRecords(Pipeline_Review__mdt objInput){
        List<sObject> lstResults = new List<sObject>(); 
        SalesCoach_Utility objUtility = new SalesCoach_Utility(); 
        Decimal sumExpiredclosedate = 0.0;
        AggregateResult[] groupedResults;
       
        //System.debug('objInput==='+objInput);
        //initialize My team's set of ids
        MY_TEAM_USERS = objUtility.getMyTeamUsers();
        if(objInput.Generate_From_Apex__c) { //if custom logic is required for getting sobjects
            SG_CustomLogicHelper objHelper = new SG_CustomLogicHelper(); 
            lstResults = objHelper.executeRequest(objInput) ; 
        }else{ //use configured simple SOQL             
            String query = 'SELECT User__c, Count(Opportunity__c) total FROM '+objInput.Object_API_Name__c;
            
            //Apply where condition if specified.
            Integer soqlLimit = Integer.valueOf(objInput.Limit__c);
            if(String.isNotBlank(objInput.Condition_Expression__c)) {
                query+= ' WHERE '+objInput.Condition_Expression__c ; 
                if(objInput.Restrict_Records_to_Owner__c) {
                    query += ' AND User__c =:CURRENT_USER ' ; 
                }else{
                    query += ' AND User__c =:MY_TEAM_USERS ' ; 
                }
            }
                         
            query += ' GROUP BY User__c LIMIT :soqlLimit';
            
           // System.debug('Constructed SOQL For Loads ==>'+query); 
            
            //Fields and object name should be present before performing query. 
            if(String.isNotBlank(objInput.Fields_API_Name__c) && String.isNotBlank(objInput.Object_API_Name__c)) {
                groupedResults = Database.query(query);
               
            }
        }
        if(groupedResults.size() > 0 ){
            //Decimal a = (Decimal)groupedResults[0].get('total');
            Decimal a = 0.00;
            for(AggregateResult ar : groupedResults){
                Decimal a1 = (Decimal)ar.get('total');
                a += a1;
            }
            sumExpiredclosedate = a.setScale(1);
            //System.debug('AggregateResult ===='+a);
            
        }
        return sumExpiredclosedate;
    }   
    /**********************************************
     * @Description : Method to construct dynamic SOQL F2F MEETINGS Pipeline. 
     * ********************************************/
    
    private static Decimal getSOQLF2FMeetingsRecords(Pipeline_Review__mdt objInput){
        List<sObject> lstResults = new List<sObject>(); 
        SalesCoach_Utility objUtility = new SalesCoach_Utility(); 
        Decimal sumF2FMeetings = 0.0;
        AggregateResult[] groupedResults;       
        //System.debug('objInput==='+objInput);
        //initialize My team's set of ids
        MY_TEAM_USERS = objUtility.getMyTeamUsers();
        if(objInput.Generate_From_Apex__c) { //if custom logic is required for getting sobjects
            SG_CustomLogicHelper objHelper = new SG_CustomLogicHelper(); 
            lstResults = objHelper.executeRequest(objInput) ; 
        }else{ //use configured simple SOQL             
            String query = 'SELECT OwnerId, Count(Id) total FROM '+objInput.Object_API_Name__c;
            
            //Apply where condition if specified.
            Integer soqlLimit = Integer.valueOf(objInput.Limit__c);
            if(String.isNotBlank(objInput.Condition_Expression__c)) {
                query+= ' WHERE '+objInput.Condition_Expression__c ; 
                if(objInput.Restrict_Records_to_Owner__c) {
                    query += ' AND OwnerId =:CURRENT_USER ' ; 
                }else{
                    query += ' AND OwnerId =:MY_TEAM_USERS ' ; 
                }
            }                         
            query += ' GROUP BY OwnerId LIMIT :soqlLimit';            
            //System.debug('Constructed SOQL For Loads ==>'+query); 
            
            //Fields and object name should be present before performing query. 
            if(String.isNotBlank(objInput.Fields_API_Name__c) && String.isNotBlank(objInput.Object_API_Name__c)) {
                groupedResults = Database.query(query);              
            }
        }
        if(groupedResults.size() > 0 ){
            //Decimal a = (Decimal)groupedResults[0].get('total');
            Decimal a = 0.00;
            for(AggregateResult ar : groupedResults){
                Decimal a1 = (Decimal)ar.get('total');
                a += a1;
            }
            sumF2FMeetings = (a/4).setScale(1);
            //System.debug('AggregateResult ===='+a);
        }
        return sumF2FMeetings;
    } 
    /**********************************************
     * @Description : Method to construct dynamic SOQL VIRTUAL MEETINGS  Pipeline. 
     * ********************************************/
    private static Decimal getSOQLVirtualMeetingsRecords(Pipeline_Review__mdt objInput){
        List<sObject> lstResults = new List<sObject>(); 
        SalesCoach_Utility objUtility = new SalesCoach_Utility(); 
        Decimal sumVirtualMeetings = 0.0;
        AggregateResult[] groupedResults;       
        //System.debug('objInput==='+objInput);
        //initialize My team's set of ids
        MY_TEAM_USERS = objUtility.getMyTeamUsers();
        if(objInput.Generate_From_Apex__c) { //if custom logic is required for getting sobjects
            SG_CustomLogicHelper objHelper = new SG_CustomLogicHelper(); 
            lstResults = objHelper.executeRequest(objInput) ; 
        }else{ //use configured simple SOQL             
            String query = 'SELECT OwnerId, Count(Id) total FROM '+objInput.Object_API_Name__c;
            
            //Apply where condition if specified.
            Integer soqlLimit = Integer.valueOf(objInput.Limit__c);
            if(String.isNotBlank(objInput.Condition_Expression__c)) {
                query+= ' WHERE '+objInput.Condition_Expression__c ; 
                if(objInput.Restrict_Records_to_Owner__c) {
                    query += ' AND OwnerId =:CURRENT_USER ' ; 
                }else{
                    query += ' AND OwnerId =:MY_TEAM_USERS ' ; 
                }
            }                         
            query += ' GROUP BY OwnerId LIMIT :soqlLimit';            
            //System.debug('Constructed SOQL For Loads ==>'+query); 
            
            //Fields and object name should be present before performing query. 
            if(String.isNotBlank(objInput.Fields_API_Name__c) && String.isNotBlank(objInput.Object_API_Name__c)) {
                groupedResults = Database.query(query);              
            }
        }
        if(groupedResults.size() > 0 ){
            //Decimal a = (Decimal)groupedResults[0].get('total');
            Decimal a = 0.00;
            for(AggregateResult ar : groupedResults){
                Decimal a1 = (Decimal)ar.get('total');
                a += a1;
            }
            sumVirtualMeetings = (a/4).setScale(1);
            //System.debug('AggregateResult ===='+a);           
        }
        return sumVirtualMeetings;
    }   
    /**********************************************
     * @Description : Method to construct dynamic SOQL from the configured metadata type. 
     * ********************************************/
    private static List<sObject> getSOQLRecords(Pipeline_Review__mdt objInput) {
        List<sObject> lstResults = new List<sObject>(); 
        SalesCoach_Utility objUtility = new SalesCoach_Utility(); 
        //System.debug('objInput==='+objInput);
        //initialize My team's set of ids
        MY_TEAM_USERS = objUtility.getMyTeamUsers(); 
        if(objInput.Generate_From_Apex__c) { //if custom logic is required for getting sobjects
            SG_CustomLogicHelper objHelper = new SG_CustomLogicHelper(); 
            lstResults = objHelper.executeRequest(objInput) ;
        }
        else { //use configured simple SOQL
            
            String query = 'SELECT '+objInput.Fields_API_Name__c+' FROM '+objInput.Object_API_Name__c;
            //Apply where condition if specified.
            if(String.isNotBlank(objInput.Condition_Expression__c)) {
                query+= ' WHERE '+objInput.Condition_Expression__c ;
                if(objInput.Restrict_Records_to_Owner__c) {
                    if(objInput.DeveloperName == 'GROUP2_1_F2F_MEETINGS' || objInput.DeveloperName == 'GROUP2_2_VIRTUAL_MEETINGS'){
                        query += ' AND OwnerId =:CURRENT_USER';
                    }else{
                      query += ' AND User__C =:CURRENT_USER';
                    }
                }
            }
            else {
                if(objInput.Restrict_Records_to_Owner__c) {
                    if(objInput.DeveloperName == 'GROUP2_1_F2F_MEETINGS' || objInput.DeveloperName == 'GROUP2_2_VIRTUAL_MEETINGS'){
                        query += ' AND OwnerId =:CURRENT_USER';
                    }else{
                      query += ' WHERE User__c =:CURRENT_USER';
                    }
                }
            }
            Integer soqlLimit = Integer.valueOf(objInput.Limit__c);
            query += ' LIMIT :soqlLimit ' ;         
            //System.debug('Constructed SOQL ==>'+query) ; 
            //Fields and object name should be present before performing query. 
            if(String.isNotBlank(objInput.Fields_API_Name__c) && String.isNotBlank(objInput.Object_API_Name__c)) {
                lstResults = Database.query(query) ;
            }
            
        }
       //System.debug('lstResults apex ===='+lstResults);
        
        return lstResults ; 
    }
    private static List<sObject> getSOQLRecordsH(Pipeline_Review__mdt objInput) {
        List<sObject> lstResults = new List<sObject>(); 
        SalesCoach_Utility objUtility = new SalesCoach_Utility(); 
        //System.debug('objInput==='+objInput);
        //initialize My team's set of ids
        MY_TEAM_USERS = objUtility.getMyTeamUsers(); 
        if(objInput.Generate_From_Apex__c) { //if custom logic is required for getting sobjects
            SG_CustomLogicHelper objHelper = new SG_CustomLogicHelper(); 
            lstResults = objHelper.executeRequest(objInput) ; 
        }
        else { //use configured simple SOQL
            String query;
            //System.debug(CURRENT_USER+'appName=='+appName);
            // Data to Query A
            if(appName == 'GROUP1_1_Health' || appName == 'GROUP1_1_Team_Health'){
                Set<Id> oppIds = new Set<Id>();
                String cond = 'AND '+ objInput.Condition_Expression__c;
                List<Opportunity_Sales_Team__c> OSTeam = new List<Opportunity_Sales_Team__c>();
                if(objInput.Restrict_Records_to_Owner__c) {
                    OSTeam = [SELECT Opportunity__c, Opportunity__r.Pipeline_Amount__c FROM Opportunity_Sales_Team__c WHERE Opportunity__r.CBT_Tier_2__c != 'BendixKing CBT' AND Opportunity__r.CloseDate = NEXT_N_DAYS:365 AND RecordType.Name != 'ATR_BGA Run Rate'AND RecordType.Name != 'D_S_Run_Rate' AND User__c =:CURRENT_USER];
                }else{
                    OSTeam = [SELECT Opportunity__c, Opportunity__r.Pipeline_Amount__c FROM Opportunity_Sales_Team__c WHERE Opportunity__r.CBT_Tier_2__c != 'BendixKing CBT' AND Opportunity__r.CloseDate = NEXT_N_DAYS:365 AND RecordType.Name != 'ATR_BGA Run Rate'AND RecordType.Name != 'D_S_Run_Rate' AND User__c IN:MY_TEAM_USERS];
                }
                /*for(Opportunity_Sales_Team__c ost:[SELECT Opportunity__c, Opportunity__r.Pipeline_Amount__c FROM Opportunity_Sales_Team__c WHERE Opportunity__r.CBT_Tier_2__c != 'BendixKing CBT' AND Opportunity__r.CloseDate = NEXT_N_DAYS:365 AND RecordType.Name != 'ATR_BGA Run Rate'AND RecordType.Name != 'D_S_Run_Rate' AND User__c =:CURRENT_USER]){
                    oppIds.add(ost.Opportunity__c);
                }*/
                for(Opportunity_Sales_Team__c ost:OSTeam){
                    oppIds.add(ost.Opportunity__c);
                }
                //System.debug('Records to Display'+oppIds);
                query = 'SELECT '+objInput.Fields_API_Name2__c+' FROM Opportunity WHERE Id IN : oppIds';
            }
            
            //System.debug('Constructed SOQL ==>'+query) ; 
            //Fields and object name should be present before performing query. 
            if(String.isNotBlank(objInput.Fields_API_Name__c) && String.isNotBlank(objInput.Object_API_Name__c)) {
                lstResults = Database.query(query) ;
            }
            
        }
       //System.debug('lstResults apex ===='+lstResults);
        
        return lstResults ; 
    }
    private static List<sObject> getSOQLRecordsQ(Pipeline_Review__mdt objInput) {
        List<sObject> lstResults = new List<sObject>(); 
        SalesCoach_Utility objUtility = new SalesCoach_Utility(); 
        //System.debug('objInput==='+objInput);
        //initialize My team's set of ids
        MY_TEAM_USERS = objUtility.getMyTeamUsers(); 
        if(objInput.Generate_From_Apex__c) { //if custom logic is required for getting sobjects
            SG_CustomLogicHelper objHelper = new SG_CustomLogicHelper(); 
            lstResults = objHelper.executeRequest(objInput) ; 
        }
        else { //use configured simple SOQL
            
            String query;            
           // System.debug('appName=='+appName);          
            if(appName == 'GROUP1_2_QUALITY' || appName == 'GROUP1_2_Team_QUALITY'){
                Set<Id> oppIds = new Set<Id>();
                String condB = 'AND '+ objInput.Condition_Expression_2__c;
                List<Opportunity_Sales_Team__c> OSTeam = new List<Opportunity_Sales_Team__c>();
                if(objInput.Restrict_Records_to_Owner__c) {
                    OSTeam = [SELECT Opportunity__c, Opportunity__r.Pipeline_Amount__c FROM Opportunity_Sales_Team__c WHERE User__c =:CURRENT_USER AND Opportunity__r.CloseDate = NEXT_90_DAYS AND Opportunity__r.CBT_Tier_2__c != 'BendixKing CBT' AND Opportunity__r.IsClosed = False AND Opportunity__r.isWon = False AND Opportunity__r.LastModifiedDate != LAST_N_DAYS:30 AND RecordType.Name != 'ATR_BGA Run Rate' AND RecordType.Name != 'D_S_Run_Rate' AND User__c =:CURRENT_USER];
                }else{
                    OSTeam = [SELECT Opportunity__c, Opportunity__r.Pipeline_Amount__c FROM Opportunity_Sales_Team__c WHERE User__c =:CURRENT_USER AND Opportunity__r.CloseDate = NEXT_90_DAYS AND Opportunity__r.CBT_Tier_2__c != 'BendixKing CBT' AND Opportunity__r.IsClosed = False AND Opportunity__r.isWon = False AND Opportunity__r.LastModifiedDate != LAST_N_DAYS:30 AND RecordType.Name != 'ATR_BGA Run Rate' AND RecordType.Name != 'D_S_Run_Rate' AND User__c IN:MY_TEAM_USERS];
                }
               /* for(Opportunity_Sales_Team__c ost:[SELECT Opportunity__c, Opportunity__r.Pipeline_Amount__c FROM Opportunity_Sales_Team__c WHERE User__c =:CURRENT_USER AND Opportunity__r.CloseDate = NEXT_90_DAYS AND Opportunity__r.CBT_Tier_2__c != 'BendixKing CBT' AND Opportunity__r.IsClosed = False AND Opportunity__r.isWon = False AND Opportunity__r.LastModifiedDate != LAST_N_DAYS:30 AND RecordType.Name != 'ATR_BGA Run Rate' AND RecordType.Name != 'D_S_Run_Rate']){
                    oppIds.add(ost.Opportunity__c);
                }*/
                for(Opportunity_Sales_Team__c ost:OSTeam){
                    oppIds.add(ost.Opportunity__c);
                }
               // System.debug('Records to Display'+oppIds);
                query = 'SELECT '+objInput.Fields_API_Name2__c+' FROM Opportunity WHERE Id IN: oppIds';
            }            
            //System.debug('Constructed SOQL ==>'+query) ; 
            //Fields and object name should be present before performing query. 
            if(String.isNotBlank(objInput.Fields_API_Name__c) && String.isNotBlank(objInput.Object_API_Name__c)) {
                lstResults = Database.query(query) ;
            }
            
        }
       //System.debug('lstResults apex ===='+lstResults);
        
        return lstResults ; 
    }
    private static List<sObject> getSOQLRecordsW(Pipeline_Review__mdt objInput) {
        List<sObject> lstResults = new List<sObject>(); 
        SalesCoach_Utility objUtility = new SalesCoach_Utility(); 
        //System.debug('objInput==='+objInput);
        //initialize My team's set of ids
        MY_TEAM_USERS = objUtility.getMyTeamUsers(); 
        if(objInput.Generate_From_Apex__c) { //if custom logic is required for getting sobjects
            SG_CustomLogicHelper objHelper = new SG_CustomLogicHelper(); 
            lstResults = objHelper.executeRequest(objInput) ; 
        }
        else { //use configured simple SOQL
            
            String query; 
            //System.debug('appName=='+appName);          
            if(appName == 'GROUP1_3_WINS' || appName == 'GROUP1_3_Teams_WINS'){
                Set<Id> oppIds = new Set<Id>();
                String condB = 'AND '+ objInput.Condition_Expression_2__c;
                List<Opportunity_Sales_Team__c> OSTeam = new List<Opportunity_Sales_Team__c>();
                if(objInput.Restrict_Records_to_Owner__c) {
                    OSTeam = [SELECT Opportunity__c, Opportunity__r.Pipeline_Amount__c FROM Opportunity_Sales_Team__c WHERE User__c =:CURRENT_USER AND Opportunity__r.CBT_Tier_2__c != 'BendixKing CBT' AND Opportunity__r.StageName = 'Closed Won' AND (Opportunity__r.CloseDate >= THIS_YEAR AND Opportunity__r.CloseDate <= TODAY) AND RecordType.Name != 'ATR_BGA Run Rate' AND RecordType.Name != 'D_S_Run_Rate' AND User__c =:CURRENT_USER];
                }else{
                    OSTeam = [SELECT Opportunity__c, Opportunity__r.Pipeline_Amount__c FROM Opportunity_Sales_Team__c WHERE User__c =:CURRENT_USER AND Opportunity__r.CBT_Tier_2__c != 'BendixKing CBT' AND Opportunity__r.StageName = 'Closed Won' AND (Opportunity__r.CloseDate >= THIS_YEAR AND Opportunity__r.CloseDate <= TODAY) AND RecordType.Name != 'ATR_BGA Run Rate' AND RecordType.Name != 'D_S_Run_Rate' AND User__c IN:MY_TEAM_USERS];
                }
                /*for(Opportunity_Sales_Team__c ost:[SELECT Opportunity__c, Opportunity__r.Pipeline_Amount__c FROM Opportunity_Sales_Team__c WHERE User__c =:CURRENT_USER AND Opportunity__r.CBT_Tier_2__c != 'BendixKing CBT' AND Opportunity__r.StageName = 'Closed Won' AND (Opportunity__r.CloseDate >= THIS_YEAR AND Opportunity__r.CloseDate <= TODAY) AND RecordType.Name != 'ATR_BGA Run Rate' AND RecordType.Name != 'D_S_Run_Rate']){
                    oppIds.add(ost.Opportunity__c);
                }*/
                for(Opportunity_Sales_Team__c ost:OSTeam){
                    oppIds.add(ost.Opportunity__c);
                }
                //System.debug('Records to Display'+oppIds);
                query = 'SELECT '+objInput.Fields_API_Name2__c+' FROM Opportunity WHERE Id IN: oppIds';
            }
            //System.debug('Constructed SOQL ==>'+query) ; 
            //Fields and object name should be present before performing query. 
            if(String.isNotBlank(objInput.Fields_API_Name__c) && String.isNotBlank(objInput.Object_API_Name__c)) {
                lstResults = Database.query(query) ;
            }
            
        }
       //System.debug('lstResults apex ===='+lstResults);
        
        return lstResults ; 
    }
    private static List<sObject> getSOQLRecordsL(Pipeline_Review__mdt objInput) {
        List<sObject> lstResults = new List<sObject>(); 
        SalesCoach_Utility objUtility = new SalesCoach_Utility(); 
        //System.debug('objInput==='+objInput);
        //initialize My team's set of ids
        MY_TEAM_USERS = objUtility.getMyTeamUsers(); 
        if(objInput.Generate_From_Apex__c) { //if custom logic is required for getting sobjects
            SG_CustomLogicHelper objHelper = new SG_CustomLogicHelper(); 
            lstResults = objHelper.executeRequest(objInput) ; 
        }
        else { //use configured simple SOQL
            
            String query; 
            //System.debug('appName=='+appName);          
            if(appName == 'GROUP1_4_LOADS' || appName == 'GROUP1_4_Team_LOADS'){
                Set<Id> oppIds = new Set<Id>();
                String condB = 'AND '+ objInput.Condition_Expression_2__c;
                List<Opportunity_Sales_Team__c> OSTeam = new List<Opportunity_Sales_Team__c>();
                if(objInput.Restrict_Records_to_Owner__c) {
                    OSTeam = [SELECT Opportunity__c, Opportunity__r.Pipeline_Amount__c FROM Opportunity_Sales_Team__c WHERE User__c =:CURRENT_USER AND Opportunity__r.CBT_Tier_2__c != 'BendixKing CBT' AND (Opportunity__r.CreatedDate>= THIS_YEAR AND Opportunity__r.CreatedDate <= TODAY) AND RecordType.Name != 'ATR_BGA Run Rate' AND RecordType.Name != 'D_S_Run_Rate' AND User__c =:CURRENT_USER];
                }else{
                    OSTeam = [SELECT Opportunity__c, Opportunity__r.Pipeline_Amount__c FROM Opportunity_Sales_Team__c WHERE User__c =:CURRENT_USER AND Opportunity__r.CBT_Tier_2__c != 'BendixKing CBT' AND (Opportunity__r.CreatedDate>= THIS_YEAR AND Opportunity__r.CreatedDate <= TODAY) AND RecordType.Name != 'ATR_BGA Run Rate' AND RecordType.Name != 'D_S_Run_Rate' AND User__c IN:MY_TEAM_USERS];
                }
                /*for(Opportunity_Sales_Team__c ost:[SELECT Opportunity__c, Opportunity__r.Pipeline_Amount__c FROM Opportunity_Sales_Team__c WHERE User__c =:CURRENT_USER AND Opportunity__r.CBT_Tier_2__c != 'BendixKing CBT' AND (Opportunity__r.CreatedDate>= THIS_YEAR AND Opportunity__r.CreatedDate <= TODAY) AND RecordType.Name != 'ATR_BGA Run Rate' AND RecordType.Name != 'D_S_Run_Rate']){
                    oppIds.add(ost.Opportunity__c);
                }*/
                for(Opportunity_Sales_Team__c ost:OSTeam){
                    oppIds.add(ost.Opportunity__c);
                }
                //System.debug('Records to Display'+oppIds);
                query = 'SELECT '+objInput.Fields_API_Name2__c+' FROM Opportunity WHERE Id IN: oppIds';
            }
            //System.debug('Constructed SOQL ==>'+query) ; 
            //Fields and object name should be present before performing query. 
            if(String.isNotBlank(objInput.Fields_API_Name__c) && String.isNotBlank(objInput.Object_API_Name__c)) {
                lstResults = Database.query(query) ;
            }
            
        }
       //System.debug('lstResults apex ===='+lstResults);
        
        return lstResults ; 
    }
    private static List<sObject> getSOQLRecordsFTF(Pipeline_Review__mdt objInput) {
        List<sObject> lstResults = new List<sObject>(); 
        SalesCoach_Utility objUtility = new SalesCoach_Utility(); 
        //System.debug('objInput==='+objInput);
        //initialize My team's set of ids
        MY_TEAM_USERS = objUtility.getMyTeamUsers(); 
        if(objInput.Generate_From_Apex__c) { //if custom logic is required for getting sobjects
            SG_CustomLogicHelper objHelper = new SG_CustomLogicHelper(); 
            lstResults = objHelper.executeRequest(objInput) ; 
        }
        else { //use configured simple SOQL
            String query; 
            //System.debug('appName=='+appName);          
            if(appName == 'GROUP2_1_F2F_MEETINGS'){
                if(objInput.Restrict_Records_to_Owner__c){
                  query = 'SELECT '+objInput.Fields_API_Name2__c+' FROM TASK WHERE (RecordTypeId = \'0121B000001dUwfQAE\') AND CreatedDate = LAST_N_DAYS:30 AND OwnerId =:CURRENT_USER';
                }else{
                    query = 'SELECT '+objInput.Fields_API_Name2__c+' FROM TASK WHERE (RecordTypeId = \'0121B000001dUwfQAE\') AND CreatedDate = LAST_N_DAYS:30 AND OwnerId IN:MY_TEAM_USERS';
                }
            }
            //System.debug('Constructed SOQL ==>'+query) ; 
            //Fields and object name should be present before performing query. 
            if(String.isNotBlank(objInput.Fields_API_Name__c) && String.isNotBlank(objInput.Object_API_Name__c)) {
                lstResults = Database.query(query) ;
            }
            
        }
       //System.debug('lstResults apex ===='+lstResults);
        
        return lstResults ; 
    }
    private static List<sObject> getSOQLRecordsVM(Pipeline_Review__mdt objInput) {
        List<sObject> lstResults = new List<sObject>(); 
        SalesCoach_Utility objUtility = new SalesCoach_Utility(); 
        //System.debug('objInput==='+objInput);
        //initialize My team's set of ids
        MY_TEAM_USERS = objUtility.getMyTeamUsers(); 
        if(objInput.Generate_From_Apex__c) { //if custom logic is required for getting sobjects
            SG_CustomLogicHelper objHelper = new SG_CustomLogicHelper(); 
            lstResults = objHelper.executeRequest(objInput) ; 
        }
        else { //use configured simple SOQL            
            String query; 
           // System.debug('appName=='+appName);          
            if(appName == 'GROUP2_2_VIRTUAL_MEETINGS'){
                if(objInput.Restrict_Records_to_Owner__c){
                  query = 'SELECT '+objInput.Fields_API_Name2__c+' FROM Task WHERE (RecordTypeId = \'0121B000001dUwaQAE\') AND CreatedDate = LAST_N_DAYS:30 AND OwnerId =:CURRENT_USER';
                }else{
                    query = 'SELECT '+objInput.Fields_API_Name2__c+' FROM Task WHERE (RecordTypeId = \'0121B000001dUwaQAE\') AND CreatedDate = LAST_N_DAYS:30 AND OwnerId IN:MY_TEAM_USERS';
                }
            }
            //System.debug('Constructed SOQL ==>'+query) ;
            //Fields and object name should be present before performing query. 
            if(String.isNotBlank(objInput.Fields_API_Name__c) && String.isNotBlank(objInput.Object_API_Name__c)) {
                lstResults = Database.query(query) ;
            }
            
        }
       //System.debug('lstResults apex ===='+lstResults);
        
        return lstResults ; 
    }
    private static List<sObject> getSOQLRecordsECD(Pipeline_Review__mdt objInput) {
        List<sObject> lstResults = new List<sObject>(); 
        SalesCoach_Utility objUtility = new SalesCoach_Utility(); 
        //System.debug('objInput==='+objInput);
        //initialize My team's set of ids
        MY_TEAM_USERS = objUtility.getMyTeamUsers(); 
        if(objInput.Generate_From_Apex__c) { //if custom logic is required for getting sobjects
            SG_CustomLogicHelper objHelper = new SG_CustomLogicHelper(); 
            lstResults = objHelper.executeRequest(objInput) ; 
        }
        else { //use configured simple SOQL
            
            String query; 
           // System.debug('appName=='+appName);          
            if(appName == 'GROUP3_1_EXPIRED_CLOSE_DATE' || appName == 'GROUP3_1_Team_EXPIRED_CLOSE_DATE'){
                Set<Id> oppIds = new Set<Id>();
                List<Opportunity_Sales_Team__c> OSTeam = new List<Opportunity_Sales_Team__c>();
                if(objInput.Restrict_Records_to_Owner__c) {
                    OSTeam = [SELECT Opportunity__c, Opportunity__r.Pipeline_Amount__c FROM Opportunity_Sales_Team__c WHERE User__c =:CURRENT_USER AND Opportunity__r.CloseDate = LAST_N_DAYS:365 AND Opportunity__r.IsClosed = False AND Opportunity__r.isWon = False AND User__c =:CURRENT_USER];
                }else{
                    OSTeam = [SELECT Opportunity__c, Opportunity__r.Pipeline_Amount__c FROM Opportunity_Sales_Team__c WHERE User__c =:CURRENT_USER AND Opportunity__r.CloseDate = LAST_N_DAYS:365 AND Opportunity__r.IsClosed = False AND Opportunity__r.isWon = False AND User__c IN:MY_TEAM_USERS];
                }
                /*for(Opportunity_Sales_Team__c ost:[SELECT Opportunity__c, Opportunity__r.Pipeline_Amount__c FROM Opportunity_Sales_Team__c WHERE User__c =:CURRENT_USER AND Opportunity__r.CloseDate = LAST_N_DAYS:365 AND Opportunity__r.IsClosed = False AND Opportunity__r.isWon = False]){
                    oppIds.add(ost.Opportunity__c);
                }*/
                for(Opportunity_Sales_Team__c ost:OSTeam){
                    oppIds.add(ost.Opportunity__c);
                }
                //System.debug('Records to Display'+oppIds);
                query = 'SELECT '+objInput.Fields_API_Name2__c+' FROM Opportunity WHERE Id IN: oppIds';
            }
            //System.debug('Constructed SOQL ==>'+query) ; 
            //Fields and object name should be present before performing query. 
            if(String.isNotBlank(objInput.Fields_API_Name__c) && String.isNotBlank(objInput.Object_API_Name__c)) {
                lstResults = Database.query(query) ;
            }
            
        }
       //System.debug('lstResults apex ===='+lstResults);
        
        return lstResults ; 
    }
    
    /**********************************************
     * @Description : Method to update the sObjects updated by inline edit
     * ********************************************/
    @AuraEnabled
    public static Integer updateSObjects(List<sObject> lstInputs ) {
        
        database.update(lstInputs) ; 
        
        return 0 ; 
    } 
    /**********************************************
     * @Description : Method to get the fiscal summary information, which is displayed
     * in the My Order Committement screen. 
     * ********************************************/
    @AuraEnabled
    public static String getFiscalSummary(Boolean isTeamView) {
       // String result = SG_MyTeamHandler.getCommittedOrders(isTeamView) ; 
       String result = 'true';
        //return null;
        return result;  
    }
    
    @AuraEnabled
    public static Boolean getUserAccess() {
        //SG_MyTeamHandler objHandler = new SG_MyTeamHandler(); 
       // Boolean result = objHandler.getAccessResult() ; 
        Boolean result = false;
        //return null; 
        return result ; 
    }
    
    /**********************************************
     * @Description : Wrapper Instance to generate formatted JSON response
     * ********************************************/
    public with Sharing Class TableViewInfoWrapper {
        List<sObject> lstResults = new List<sObject>(); 
        List<ColumnInfos> lstColumns = new List<ColumnInfos>(); 
    }
    /**********************************************
     * @Description : Wrapper Instance to generate formatted JSON response
     * ********************************************/
    public with Sharing Class ReviewInfoWrapper {
        String groupingTitle = null ; 
        List<ReviewInfo> lstReviews = new List<ReviewInfo>(); 
    }
    /**********************************************
     * @Description : Wrapper Instance to generate formatted JSON response
     * ********************************************/
    public with Sharing Class ReviewInfo {
        String label ; 
        String uniqueName ; 
        Integer count = 0 ; 
        String helpText ; 
        CssAttr cssProp = new CssAttr() ; 
        
    }
    /**********************************************
     * @Description : Wrapper Instance to generate formatted JSON response
     * ********************************************/
    public with Sharing Class TimeInfoWrapper {
        String fiscalEndDateTime ; 
        String systemNowTime ; 
    }
    /**********************************************
     * @Description : Wrapper Instance to generate formatted JSON response
     * ********************************************/    
    public with Sharing Class ColumnInfos {
        String label ; 
        String fieldName ; 
        Boolean editable ; 
        String type ; 
        Boolean sortable ; 
        //Integer initialWidth ; 
        Map<String , String> typeAttributes = new Map<String , String>(); 
    }
    /**********************************************
     * @Description : Wrapper Instance to generate formatted JSON response
     * ********************************************/
    public with Sharing Class TypeAttributes {
        String year ; 
        String month ; 
        String day ; 
        String hour ; 
        String minute ; 
    }
    /**********************************************
     * @Description : Wrapper Instance to generate formatted JSON response
     * ********************************************/
    public with Sharing Class CountInfoWrapper {
        String metaApiName ; 
        Decimal count = 0.0 ;
        String countps = '0.0';
    }
    /**********************************************
     * @Description : Wrapper Instance to generate formatted JSON response
     * ********************************************/
    public with Sharing Class CssAttr { // pre-set to defaults 
        Integer firstRangeLimit = 5 ; 
        String firstRangeColor = 'border-green' ; 
        Integer secondRangeLimit = 10 ; 
        String secondRangeColor = 'border-yellow'; 
        String endLimitColor = 'border-red' ; 
    }
    /**********************************************
     * @Description : Method to fetch Opportunities
     * ********************************************/
      @AuraEnabled
    public static List < Opportunity > fetchOpps() {
        return [ Select Id, Name,Owner.Name, Amount ,CloseDate from Opportunity LIMIT 10 ];
    }
    /*******************************************************
     * @Description: Method to get the table columns for 
     * viewing adjustment opps. 
     * 
* **************************************************/
    public static List<ColumnInfos> getAdjustOppColumns() {
        List<ColumnInfos> lstResults = new List<ColumnInfos>(); 
        ColumnInfos objColumnInfo  = new ColumnInfos();  
        objColumnInfo.label = 'Owner Name'; 
        objColumnInfo.fieldName = 'Owner.Name' ;
        objColumnInfo.type = 'text' ; 
        objColumnInfo.editable = false ; 
        lstResults.add(objColumnInfo); 
        
        objColumnInfo  = new ColumnInfos();  
        objColumnInfo.label = 'Amount'; 
        objColumnInfo.fieldName = 'Amount' ;
        objColumnInfo.type = 'currency' ; 
        objColumnInfo.editable = true ; 
        lstResults.add(objColumnInfo); 
        
        
        
        objColumnInfo  = new ColumnInfos();  
        objColumnInfo.label = 'Close Date'; 
        objColumnInfo.fieldName = 'CloseDate' ;
        objColumnInfo.type = 'date-local' ; 
        Map<String , String> attrMap = new Map<String , String>(); 
        //objColumnInfo.typeAttributes.year = 'numeric';
        attrMap.put('year', 'numeric');
        //objColumnInfo.typeAttributes.month = 'short';
        attrMap.put('month','short'); 
        //objColumnInfo.typeAttributes.day = 'numeric';
        attrMap.put('day','numeric'); 
        //objColumnInfo.typeAttributes.minute = '2-digit';
        //objColumnInfo.typeAttributes.hour = '2-digit';
        objColumnInfo.typeAttributes = attrMap ; 
        
        objColumnInfo.editable = true ; 
        
        
        lstResults.add(objColumnInfo); 
        
        objColumnInfo  = new ColumnInfos();  
        objColumnInfo.label = 'Fiscal Period'; 
        objColumnInfo.fieldName = 'Fiscal_Period_APEX2__c' ;
        objColumnInfo.type = 'text' ; 
        objColumnInfo.editable = false ; 
        lstResults.add(objColumnInfo); 
        
        objColumnInfo  = new ColumnInfos();  
        objColumnInfo.label = 'GBE'; 
        objColumnInfo.fieldName = 'GBE__c' ;
        objColumnInfo.type = 'text' ; 
        objColumnInfo.editable = false ; 
        lstResults.add(objColumnInfo); 
        
        objColumnInfo  = new ColumnInfos();  
        objColumnInfo.label = 'Region'; 
        objColumnInfo.fieldName = 'Region__c' ;
        objColumnInfo.type = 'text' ; 
        objColumnInfo.editable = false ; 
        lstResults.add(objColumnInfo); 
        
        objColumnInfo  = new ColumnInfos();  
        objColumnInfo.label = 'Division'; 
        objColumnInfo.fieldName = 'Brand__c' ;
        objColumnInfo.type = 'text' ; 
        objColumnInfo.editable = false ; 
        lstResults.add(objColumnInfo);
        
        return lstResults ; 
    }

}