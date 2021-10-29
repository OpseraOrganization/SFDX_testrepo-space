/***********************************************
 * @Description : Apex Class to handle all Cases related logic.
 * *********************************************/
public with Sharing class SPoG_MyCasesHelper {
    /***********************************************************
     * @Description: Method to get the cases chart data for the 
     * current assigned user. 
     * ********************************************************/
    public String getCaseChartData(Map<String,Object> mapInputRequest){
        System.debug('::Filters ===>> '+mapInputRequest);
        ResponseCaseInfo objResponse = new ResponseCaseInfo(); 
        List<AggregateResult> groupedResults = new List<AggregateResult>();
        //To Check status and its related colour
        Map<String, String> caseStatusToColor   = new Map<String, String>();
		for(SPoG_Case_Status__mdt caseStatus: [SELECT MasterLabel, Colour_code__c FROM SPoG_Case_Status__mdt]) {
            caseStatusToColor.put(caseStatus.MasterLabel, caseStatus.Colour_code__c);
        }
        List<String> selectedAccountIds = new List<String>();
        String isDBView = mapInputRequest.containsKey('isDashboardView')?(String)mapInputRequest.get('isDashboardView'):'false';
        if(isDBView == 'true'){
            if(mapInputRequest.containsKey('filtersData') && mapInputRequest.get('filtersData')==null){
                selectedAccountIds = new List<String>();
                groupedResults = getCaseData(selectedAccountIds,caseStatusToColor,True);
            }else{
                Map<String,Object> dbfilters = mapInputRequest.containsKey('filtersData') && mapInputRequest.get('filtersData')!=null?(Map<String,Object>)mapInputRequest.get('filtersData'):new Map<String,Object>();
                System.debug('::=dbfilters=:: '+dbfilters);
                String accountval  = dbfilters.containsKey('accname')?(String)dbfilters.get('accname'):'';
                String assignmtval = dbfilters.containsKey('assgnval')?(String)dbfilters.get('assgnval'):'';
                String segmentval  = dbfilters.containsKey('segval')?(String)dbfilters.get('segval'):'';
                String regionval   = dbfilters.containsKey('regionval')?(String)dbfilters.get('regionval'):'';
                String typeval     = dbfilters.containsKey('typeval')?(String)dbfilters.get('typeval'):'';
                String query = ' SELECT Id,Name,Sbl_Account_Row_Id__c FROM Account WHERE Customer_Status__c =\'Active\' ';
                if(String.isNotBlank(accountval)) {
                    query += ' AND Name LIKE \''+accountval+'%\' '; 
                }
                if(String.isNotBlank(assignmtval)) {
                    query += ' AND GCE_CSS_Assignment__c =: assignmtval '; 
                }
                if(String.isNotBlank(segmentval)) {
                    query += ' AND GCE_Customer_Segment__c =: segmentval '; 
                }
                if(String.isNotBlank(regionval)) {
                    query += ' AND GCE_CSS__c =: regionval '; 
                }
                if(String.isNotBlank(typeval)) {
                    query += ' AND GCE_CSS_Type__c =: typeval '; 
                }
                System.debug('::query ==>> '+query);
                List<Account> listaccs = DataBase.query(query);
                Map<String,Account> mapaccs = new Map<String,Account>(listaccs);
                selectedAccountIds = new List<String>(mapaccs.keySet());
                System.debug('::selectedAccountIds ==>> '+selectedAccountIds);
                groupedResults = selectedAccountIds.size()>0?getCaseData(selectedAccountIds,caseStatusToColor,True):new List<AggregateResult>();
            }
        }else{
            String selectedAccountId = mapInputRequest.containsKey('selectedAccountId') && mapInputRequest.get('selectedAccountId') != null ?JSON.serialize(mapInputRequest.get('selectedAccountId')):'' ; 
            System.debug('=====selectedAccountId==>>'+selectedAccountId);
            selectedAccountIds = selectedAccountId != '' && selectedAccountId.length() != 2 ?(List<String>)JSON.deserialize(selectedAccountId, List<String>.class) : new List<String>();
            System.debug('Selected Account Ids'+selectedAccountIds);
            groupedResults = getCaseData(selectedAccountIds,caseStatusToColor,False);
        }
        for(AggregateResult groupedResult : groupedResults)
        {
            String caseStatus = (String) groupedResult.get('status');
            objResponse.lstCaseInfos.add(new CaseInfo( caseStatus,
                                                      (Integer) groupedResult.get('totalCount'),
                                                      (String) caseStatusToColor.get(caseStatus))); 
        }
        objResponse.selectedAccounts = selectedAccountIds;
        return JSON.serialize(objResponse) ; 
    }
    /***********************************************************
     * @Description: Method to get the cases data for the 
     * current assigned user. 
     * ********************************************************/
    public List<AggregateResult> getCaseData(List<String> selectedAccountIds,Map<String, String> caseStatusToColor, Boolean isDBView){
        List<AggregateResult> groupedResults = new List<AggregateResult>();
        List<String> Rectyp = new List<String>();
        Rectyp = System.Label.spog_Case_RecordTypes.Split(',');
        List<String> case_owners = Test.isRunningTest()?new List<String>():System.Label.Appian_Case_Owners.split(',');
        if(isDBView){
            if(selectedAccountIds.size() == 0){
            groupedResults = [SELECT COUNT(id) totalCount , status 
                              FROM Case 
                              WHERE Government_Compliance_SM_M_Content__c != 'Yes'
                              AND Export_Compliance_Content_ITAR_EAR__c != 'Yes'
                              AND IsClosed = FALSE
                              AND RecordType.DeveloperName IN :Rectyp
                              AND Status IN : caseStatusToColor.keySet()
                              AND Owner.Name NOT IN : case_owners 
                              GROUP BY Status
                              LIMIT : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
            }
            else {
                groupedResults = [SELECT COUNT(id) totalCount , status 
                                  FROM Case 
                                  WHERE Government_Compliance_SM_M_Content__c != 'Yes'
                                  AND Export_Compliance_Content_ITAR_EAR__c != 'Yes'
                                  AND AccountId IN : selectedAccountIds
                                  AND IsClosed = FALSE
                                  AND RecordType.DeveloperName IN :Rectyp
                                  AND Status IN : caseStatusToColor.keySet()
                                  AND Owner.Name NOT IN : case_owners
                                  GROUP BY Status
                                  LIMIT : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
            }
        }else{
            if(selectedAccountIds.size() == 0){
                groupedResults = [SELECT COUNT(id) totalCount , status 
                                  FROM Case 
                                  WHERE OwnerId =: UserInfo.getUserId()
                                  AND Government_Compliance_SM_M_Content__c != 'Yes'
                                  AND Export_Compliance_Content_ITAR_EAR__c != 'Yes'
                                  AND IsClosed = FALSE
                                  AND RecordType.DeveloperName IN :Rectyp
                                  AND Status IN : caseStatusToColor.keySet()
                                  GROUP BY Status
                                  LIMIT : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
            }
            else {
                groupedResults = [SELECT COUNT(id) totalCount , status 
                                  FROM Case 
                                  WHERE OwnerId =: UserInfo.getUserId()
                                  AND Government_Compliance_SM_M_Content__c != 'Yes'
                                  AND Export_Compliance_Content_ITAR_EAR__c != 'Yes'
                                  AND AccountId IN : selectedAccountIds
                                  AND IsClosed = FALSE
                                  AND RecordType.DeveloperName IN :Rectyp
                                  AND Status IN : caseStatusToColor.keySet()
                                  GROUP BY Status
                                  LIMIT : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
            }
        }
        return groupedResults;
    }
    /**************************************************************
     * @Description: Method to get list of cases matching the filters. 
     * ************************************************************/
    public String getCasesListData(Map<String,Object> mapInputRequest){
        String query = 'SELECT id , Status ,Sales_Order_Number__c, CaseNumber  , CreatedDate ,Type , Account.Name , Age_in_Hours__c, Reason_for_hold__c FROM Case WHERE Government_Compliance_SM_M_Content__c != \'Yes\' AND Export_Compliance_Content_ITAR_EAR__c != \'Yes\' '; 
        List<CaseSummary> lstSummary = new List<CaseSummary>();
        String isDBView = mapInputRequest.containsKey('isDBView')?(String)mapInputRequest.get('isDBView'):'No';
        CaseSummary objSummary = new CaseSummary(); 
        CaseFilter objFilter = new CaseFilter(); 
        List<String> selectedAccountId = new List<String>(); 
        String selectedStatus ; 
        String searchInput ; 
        List<Case> lstCases = new List<Case>(); 
        String filterString = (String) mapInputRequest.get('filterParams'); 
        System.debug('==filterString===>>'+filterString);
        List<String> StatusSelected = new List<String>();
        for(SPoG_Case_Status__mdt caseStatus: [SELECT MasterLabel FROM SPoG_Case_Status__mdt]) {
            StatusSelected.add(caseStatus.MasterLabel);
        }
        List<String> Rectyp = new List<String>();
        Rectyp =System.Label.spog_Case_RecordTypes.Split(',');
        if(String.isNotBlank(filterString)){
        	objFilter = (CaseFilter) JSON.deserialize(filterString, CaseFilter.Class);     
        }
        if(isDBView == 'No'){
            Id currentUserId = UserInfo.getUserId();
            query += ' AND OwnerId =: currentUserId '; 
        }else{
            List<String> case_owners = Test.isRunningTest()?new List<String>():System.Label.Appian_Case_Owners.split(',');
        	query += ' AND Owner.Name NOT IN : case_owners '; 
        }
        query += ' AND IsClosed = FALSE '; 
        System.debug('===objFilter.customerId=>>>'+objFilter.customerId);
        if(objFilter.customerId != null && objFilter.customerId.size()>0) {
            selectedAccountId = objFilter.customerId ; 
            query += ' AND AccountId IN : selectedAccountId ';
        }
        if(String.isNotBlank(objFilter.status)) {
            selectedStatus  = objFilter.status ; 
            query += ' AND Status =: selectedStatus '; 
        }
        else
        {
         query += ' AND Status =: StatusSelected ';    
        }
        if(String.isNotBlank(objFilter.searchInput)) {
            searchInput = objFilter.searchInput; 
            query += ' AND CaseNumber LIKE \'%'+searchInput+'%\''; 
        }
        //RecordType Check
        query += ' AND RecordType.DeveloperName IN : Rectyp';
        Integer limitCount = Limits.getLimitQueryRows() - Limits.getQueryRows() ;
        query += ' LIMIT : limitCount ';
        System.debug('Constructed Query before SOQL '+query);
        lstCases = (List<Case>) Database.query(query);
        for(Case objCase : lstCases) {
            objSummary = new CaseSummary(); 
            objSummary.CaseNumber = objCase.CaseNumber; 
            objSummary.CaseId = objCase.Id; 
            objSummary.CaseAge = String.valueOf(Integer.valueOf(objCase.Age_in_Hours__c)); 
            objSummary.CaseAgeInteger = Integer.valueOf(objCase.Age_in_Hours__c);
            objSummary.SalesOrderNumber = objCase.Sales_Order_Number__c ; 
            objSummary.Status = objCase.Status ; 
            objSummary.CustomerName = objCase.Account.Name ; 
            objSummary.ReasonForHold = objCase.Reason_for_hold__c ; 
            lstSummary.add(objSummary); 
        }
        return JSON.serialize(lstSummary);
    }
    public with Sharing Class CaseSummary {
        String CaseId ; 
        String CaseNumber ; 
        String CustomerName ; 
        String SalesOrderNumber ; 
        String CaseAge ; 
        Integer CaseAgeInteger;
        String Status; 
        String ReasonForHold;
    }
    public with Sharing Class ResponseCaseInfo {
        List<String> selectedAccounts = new List<String>();
        List<CaseInfo> lstCaseInfos = new List<CaseInfo>(); 
    }
    public with Sharing Class CaseInfo {
        String label = null ; 
        Integer count = 0 ; 
        String color = null;
        public CaseInfo(String displayValue , Integer displayCount, String displayColor) {
            label = displayValue ; 
            count = displayCount ; 
            color = displayColor ;
        }
    }
    public with Sharing Class CaseFilter {
        List<String> customerId = new List<String>() ; 
        String status = null ; 
        String searchInput = null ; 
    }
}