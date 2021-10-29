/*****************************************************
 * @Description: 
 * ****************************************************/
public with Sharing class SPoG_Utility {
    
    // For pilot , PMT_AM is fixed, but this should change based on Order/Customer for which
    // the information needs to be retrieved. Setting contains information for SAP Source System & Client Number  
    private static final String GENERAL_SETTING = 'AERO';
    public final String TYPE_PO_NUMBER = 'PO_NUMBER'; 
    public final String TYPE_CUSTOMER_NUMBER = 'SOLD_TO_NUMBER';
    public final String TYPE_SALES_ORDER = 'SALES_ORDER_NUMBER'; 
    public final String TYPE_MAT_NUMBER = 'MATERIAL_NUMBER';
    public final String TYPE_DELIVERY_NUMBER = 'DELIVERY_NUMBER'; 
    
    
    public Id getClaimCaseRecordTypeId() {
        Id returnValue = null ; 
        List<RecordType> lstRecordType = [SELECT id,DeveloperName
                                         FROM RecordType 
                                         WHERE sObjectType = 'Case'
                                         AND DeveloperName = 'Consumer_Support'
                                         LIMIT 1];
        if(!lstRecordType.isEmpty()){
            returnValue = lstRecordType[0].Id ; 
        }
        return returnValue ; 
    }
    
    /**********************************************************
     * @Descrpition : Utility method to parse and display date
     * fields
     * ********************************************************/
    public String parseDateForOutput(String inputValue){
        
        if(String.isNotBlank(inputValue)) {
            String year = inputValue.substring(0, 4) ; 
            String month = inputValue.substring(4,6) ; 
            String dateValue =inputValue.substring(6,8) ;
            inputValue = month+'/'+dateValue+'/'+year ;
        }
        
        return inputValue ; 
    }
    
    /**********************************************************
     * @Descrpition : Utility method to parse and display date
     * fields
     * ********************************************************/
    public String parseDateForInput(String inputValue) {
        
        if(String.isNotBlank(inputValue)){
            inputValue = inputValue.replaceAll('-', ''); 
        }
        
        return inputvalue ;
    }
    
    
    /********************************************************
     * @Description : Method to get Customer Ids associated to Service Agent
     * 
     * *******************************************************/
    public List<Account> getMyCustomers(String searchInput) {
        Set<Id> setAccountIds = new Set<Id>(); 
        SPoG_Utility objUtility = new SPoG_Utility(); 
        List<Account> lstResults = new List<Account>(); 
        for(Case objCase : objUtility.getCases()) {
            setAccountIds.add(objCase.AccountId); 
        }
        if(!setAccountIds.isEmpty()) {
            lstResults = [SELECT id , Name , AccountNumber 
                          FROM Account WHERE ID IN: setAccountIds 
                          LIMIT : (Limits.getLimitQueryRows() - Limits.getQueryRows()) ]; 
        }
        return lstResults ; 
    }
    
    /********************************************************
     * @Description : Method to retrieve open cases for the current user
     * ******************************************************/
    public List<Case> getCases(){
        Set<Id> setOwnerIds = new Set<Id>(); 
        setOwnerIds.add(UserInfo.getUserId()); 
        List<Case> lstCases = new List<Case>();
        List<String> Rectyp = new List<String>();
        Rectyp =System.Label.spog_Case_RecordTypes.Split(',');
                    
        List<String> caseStatus = new List<String>();
        for(SPoG_Case_Status__mdt status : [SELECT MasterLabel FROM SPoG_Case_Status__mdt]) {
        caseStatus.add(status.MasterLabel);
        }
        
        lstCases = [SELECT id , AccountId FROM Case 
                    WHERE OwnerId IN :setOwnerIds 
                    AND IsClosed = FALSE 
                    AND RecordType.DeveloperName IN :Rectyp
                    AND Status IN : caseStatus
                    LIMIT : (Limits.getLimitQueryRows() - Limits.getQueryRows())]; 
        return lstCases ; 
    }
    
    /*************************************************************
     * @Description : Method to get the Sales Office information
     * configured on User record
     * ************************************************************/
    public String getCurrentUserInfo() {
        OptionsInfo objOption = new OptionsInfo(); 
        List<OptionsInfo> lstOptions = new List<OptionsInfo>(); 
        
        OP_UserInfo objResponse = new OP_UserInfo(); 
        
        List<User> lstCurrentUser = [SELECT Id //, SPoG_Sales_Office__c 
                                     FROM User WHERE Id =: UserInfo.getUserId() 
                                     LIMIT 1]; 
        /*if(!lstCurrentUser.isEmpty() && String.isNotBlank(lstCurrentUser[0].SPoG_Sales_Office__c)) {
            for(String salesOffice : lstCurrentUser[0].SPoG_Sales_Office__c.split(',') ){
                objOption = new OptionsInfo();
                objOption.label = salesOffice ; 
                objOption.value = salesOffice ; 
                lstOptions.add(objOption);
            }*/
            objResponse.isSuccess = true ; 
            //objResponse.salesOffices = lstOptions; 
       // }
        
        return JSON.serialize(objResponse) ; 
    }
    
    public String addPrefix(String inputValue , String inputType) {
        String paddingValue = '';
        Integer paddingIterations = 0 ; 
        if(String.isNotBlank(inputValue) && String.isNotBlank(inputType)) {
            if(TYPE_PO_NUMBER.equalsIgnoreCase(inputType) && inputValue.length() <20) {
                paddingIterations = 20 - inputValue.length() ; 
            }
            else if(TYPE_MAT_NUMBER.equalsIgnoreCase(inputType) && inputValue.length() <18) {
                paddingIterations = 18 - inputValue.length(); 
            }
            else if(TYPE_SALES_ORDER.equalsIgnoreCase(inputType) && inputValue.length() < 10) {
                paddingIterations = 10 - inputValue.length(); 
            }
            else if(TYPE_CUSTOMER_NUMBER.equalsIgnoreCase(inputType) && inputValue.length() < 10) {
                paddingIterations = 10 - inputValue.length(); 
            }
            else if(TYPE_DELIVERY_NUMBER.equalsIgnoreCase(inputType) && inputValue.length() < 10) {
                paddingIterations = 10 - inputValue.length(); 
            }
        }
        for(Integer i = 0 ; i < paddingIterations ; i++){
            paddingValue+='0'; 
        }
        inputValue = paddingValue+inputValue; 
        return inputValue ; 
    }
    
    public SPoG_General_Settings__mdt getSystemSetting() {
        
        return [SELECT id , APIGEE_Client_ID__c, APIGEE_Client_Secret__c ,
                SAP_Client_Number__c , SAP_Source_System__c,
                APIGEE_Attachment_Path__c , APIGEE_Claims_Path__c , 
                APIGEE_Customer_Search_Path__c , APIGEE_Delivery_Path__c , 
                APIGEE_Order_Details_Path__c , APIGEE_Order_Metric_Path__c , 
                APIGEE_Order_Summary_Path__c, APIGEE_Pricing_Path__c , APIGEE_Shipment_Metric_Path__c,
                APIGEE_Access_Token_Client_Id__c,APIGEE_Access_Token_Client_Secret__c,APIGEE_Access_Token_Path__c,
                APIGEE_Stocks_Path__c,APIGEE_Stocks_Overview_Path__c, APIGEE_Search_Path__c,
                APIGEE_UserStatus_Path__c
                FROM SPoG_General_Settings__mdt WHERE DeveloperName =: GENERAL_SETTING
                LIMIT 1];
    }
    
    private with Sharing Class OP_UserInfo {
        Boolean isSuccess = false ; 
        List<OptionsInfo> salesOffices = new List<OptionsInfo>(); 
    }
    
    private with Sharing Class OptionsInfo {
        String label ; 
        String value ;
    }

}