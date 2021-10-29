/********************************************************
* @Description : Apex Class to retrieve the customer information
* for the current user. 
* ******************************************************/
public with Sharing class SPoG_MyCustomerHelper {
    /**************************************************************
     * @Description: Method to get All SFDC Accounts 
     * ***********************************************************/
    public String getSFDCAccountInfo(String searchString, List<String> selData){
        AccountInfo results = new AccountInfo();
        try{
            List<Option> options = new List<Option>();
            Map<String,AccountData> accountdata = new Map<String,AccountData>();
            String query = 'select sbl_account_row_id__c,external_account_id__c,external_account_name__c, external_address_line_1__c, external_address_line_2__c,external_address_line_3__c, external_city_name__c, external_country_name__c, id FROM Account_Cross_Ref__c ';
            if(selData != null && selData.size()>0){
                String query1 = query+' WHERE ID IN :selData Order By external_account_name__c ASC ';
                for(Account_Cross_Ref__c each_acc : DataBase.query(query1)){
                    options.add(new Option(each_acc.external_account_name__c!=null?each_acc.external_account_name__c.toUpperCase():'',each_acc.external_account_id__c!=null?each_acc.external_account_id__c.replace('-01',''):'',each_acc.Id,true));
                    String address = each_acc.external_address_line_1__c!=null?each_acc.external_address_line_1__c+',':'';
                    address += each_acc.external_address_line_2__c!=null?each_acc.external_address_line_2__c+',':'';
                    address += each_acc.external_address_line_3__c!=null?each_acc.external_address_line_3__c+',':'';
                    address += each_acc.external_city_name__c!=null?each_acc.external_city_name__c+',':'';
                    address += each_acc.external_country_name__c!=null?each_acc.external_country_name__c:'';
                    accountdata.put(each_acc.Id,new AccountData(each_acc.external_account_name__c,each_acc.external_account_id__c!=null?each_acc.external_account_id__c.replace('-01',''):'',each_acc.Sbl_Account_Row_Id__c,address));
            	}
            }
            query += ' where (((not external_account_name__c like \'%do not use%\') and (not external_account_name__c like \'%reference account%\') and (not external_account_name__c like \'%various%\') and (not account_name__r.name like \'%various%\') and (not external_account_id__c like \'%-02\' ))  and (external_account_name__c !=\'\' and account_status__c=\'active\' and xref_type__c = \'SAP_SOLD_TO\')) ';
            if(String.isNotEmpty(searchString)){
                query += ' AND ( external_account_name__c LIKE \''+searchString+'%\' ) ';
            }
            query += ' Order By external_account_name__c ASC LIMIT 50 ';
            Set<String> setseldata = new Set<String>(selData);
            for(Account_Cross_Ref__c each_acc : DataBase.query(query)){
                if(!setseldata.contains(each_acc.Id)){
                    options.add(new Option(each_acc.external_account_name__c!=null?each_acc.external_account_name__c.toUpperCase():'',each_acc.external_account_id__c!=null?each_acc.external_account_id__c.replace('-01',''):'',each_acc.Id,false));
                    String address = each_acc.external_address_line_1__c!=null?each_acc.external_address_line_1__c+',':'';
                    address += each_acc.external_address_line_2__c!=null?each_acc.external_address_line_2__c+',':'';
                    address += each_acc.external_address_line_3__c!=null?each_acc.external_address_line_3__c+',':'';
                    address += each_acc.external_city_name__c!=null?each_acc.external_city_name__c+',':'';
                    address += each_acc.external_country_name__c!=null?each_acc.external_country_name__c:'';
                    accountdata.put(each_acc.Id,new AccountData(each_acc.external_account_name__c,each_acc.external_account_id__c!=null?each_acc.external_account_id__c.replace('-01',''):'',each_acc.Sbl_Account_Row_Id__c,address));
                }
            }
            results.count		 = options.size();
            results.message      = 'Success';
            results.isSuccess    = true;
            results.options      = options;
            results.accountdata  = accountdata;
        }catch(Exception ex){
            results.message   = ex.getMessage();
            results.isSuccess = false;
        }
        return JSON.serialize(results);
    }
    public class AccountInfo{
        public Integer count;
        public string message;
        public Boolean isSuccess;
        public List<Option> options;
        public Map<String,AccountData> accountdata;
    }
    public class AccountData{
        public String acc_name;
        public string soldto;
        public string crmid;
        public string address;
        public AccountData(String acc_name,string soldto,string crmid,string address){
            this.acc_name = acc_name;
            this.soldto   = soldto;
            this.crmid    = crmid;
            this.address  = address;
        }
    }
    public class Option{
        public string label;
        public string sublabel;
        public string value;
        public Boolean selected;
        public Option(string label,string sublabel,string value,Boolean selected){
            this.label = label;
            this.sublabel = sublabel;
            this.value = value;
            this.selected = selected;
        }
    }
    /**************************************************************
     * @Description: Method to get the SAP information from a 
     * case. 
     * ***********************************************************/
    public String getSAPInfo(Map<String , Object> mapInputRequest){
        Id caseId = (Id) mapInputRequest.get('caseId'); 
        SAPInfo objResult = new SAPInfo(); 
        if(caseId != null) { 
            List<Case> lstCurrentCase = [SELECT id,CaseNumber,SAP_Account_Number1__c,
                                         Customer_PO_RO_WONumber__c,Repair_Notification_Number__c,
                                         Sales_Order_Number__c
                                         FROM Case WHERE Id =: caseId
                                         LIMIT 1
                                        ];
            if(!lstCurrentCase.isEmpty()){
                objResult.isSuccess = true ; 
                objResult.message = 'Success';
                objResult.custNO = lstCurrentCase[0].SAP_Account_Number1__c!=null?lstCurrentCase[0].SAP_Account_Number1__c:''; 
                objResult.caseNumber = lstCurrentCase[0].CaseNumber.containsIgnoreCase('CASE-')?lstCurrentCase[0].CaseNumber.split('CASE-')[1]:lstCurrentCase[0].CaseNumber; 
                objResult.orderNO = lstCurrentCase[0].Sales_Order_Number__c!=null?lstCurrentCase[0].Sales_Order_Number__c:''; 
                objResult.custPO = lstCurrentCase[0].Customer_PO_RO_WONumber__c!=null?lstCurrentCase[0].Customer_PO_RO_WONumber__c:'';
            }
        }
        return JSON.serialize(objResult) ; 
    }
    
    public with Sharing Class SAPInfo {
        Boolean isSuccess = false ; 
        String message = '';
        String custNO = '' ; 
        String caseNumber = '' ; 
        String orderNO = '' ; 
        String custPO = '';
    }

    /*******************************************************
* @Description : Method to get customer for the current user. 
* ******************************************************/
    public String getCustomerInfo(Map<String , Object> mapInputRequest){
        String result ;
        SPoG_Utility objUtility = new SPoG_Utility(); 
        //ResponseCustomerInfo objResult = new ResponseCustomerInfo(); 
        List<Account> lstAccounts = objUtility.getMyCustomers(null); 
        List<CustomerInfo> objResult = new List<CustomerInfo>();
        for(Account objAccount : lstAccounts) {
            objResult.add(new CustomerInfo(objAccount.Id , objAccount.Name.toUpperCase())); 
        }
        result = JSON.serialize(objResult); 
        return result ; 
    }
    
    /**************************************************************
*@Description: Method to send the search key to SAP HANA, to get the
customer search results. 
* ************************************************************/
    public String doCustomerSearch(Map<String,Object> mapInputRequest) {
        //add search input headers
        Map<String,String> mapSearchInputs = addInputHeader(mapInputRequest); 
        SPoG_InterfaceHelper objHelper = new SPoG_InterfaceHelper(); 
        HttpResponse objHttpResponse = objHelper.getSearchResult(mapSearchInputs); 
        
        return objHttpResponse.getBody() ; 
    }
    
    /*************************************************************
* 
* 
* ***********************************************************/
    private Map<String,String> addInputHeader(Map<String,Object> mapInputRequest) {
       
         String searchByDChnl = (String) mapInputRequest.get('searchByDChnl'); 
         String soldToName = (String) mapInputRequest.get('soldToName'); 
        system.debug('soldToName::::::'+soldToName);
         String soldToNumb = (String) mapInputRequest.get('soldToNumb'); 
         String vatNumb = (String) mapInputRequest.get('vatNumb'); 
         String postalCode = (String) mapInputRequest.get('postalCode'); 
         String salesOrg = (String) mapInputRequest.get('salesOrg'); 
         String searchByCountry = (String) mapInputRequest.get('searchByCountry'); 
        
        Map<String,String> mapInputs = new Map<String,String>(); 
        mapInputs.put('IP_HON_ID','ALL'); //Hon Id selection to ALL
       
        /*
        
        if(String.isNotBlank(soldToName)){
            mapInputs.put('IP_SOLDTO_NAME',soldToName); 
        }else{
            mapInputs.put('IP_SOLDTO_NAME','ALL'); 
        }
         if(String.isNotBlank(soldToNumb)){
            mapInputs.put('IP_SOLDTO',soldToNumb); 
        }else{
            mapInputs.put('IP_SOLDTO','ALL'); 
        }
         if(String.isNotBlank(vatNumb)){
            mapInputs.put('IP_VAT_NUMBER',vatNumb); 
        }else{
            mapInputs.put('IP_VAT_NUMBER','ALL'); 
        }
         if(String.isNotBlank(postalCode)){
            mapInputs.put('IP_POSTAL_CODE',postalCode); 
        }else{
            mapInputs.put('IP_POSTAL_CODE','ALL'); 
        }
         if(String.isNotBlank(salesOrg)){
            mapInputs.put('IP_SALES_ORG',salesOrg); 
        }else{
            mapInputs.put('IP_SALES_ORG','ALL'); 
        }
         if(String.isNotBlank(searchByDChnl) && searchByDChnl != 'None'){
            mapInputs.put('IP_DIST_CHNL',searchByDChnl); 
        }else{
            mapInputs.put('IP_DIST_CHNL','ALL'); 
        }
         if(String.isNotBlank(searchByCountry) && searchByCountry != 'None'){
            mapInputs.put('IP_COUNTRY',searchByCountry); 
        }*/
        //else{
            mapInputs.put('IP_COUNTRY','ALL'); 
        //}
        
        return mapInputs ; 
    }
    
    /***************************************************************
* @Description : Wrapper instances to de-serialize responses. 
* 
* ************************************************************
    private with Sharing Class ResponseSearch {
        Boolean isSuccess = false ; 
        Integer total_results = 0 ; 
        
        List<CustomerSearchInfo> results = new List<CustomerSearchInfo>();
    }
    private with Sharing Class CustomerSearch {
        SearchResults OPEN_ORDERS = new SearchResults(); 
    }    
    private with Sharing Class SearchResults {
        List<CustomerSearchInfo> results = new List<CustomerSearchInfo>(); 
    }
    
    private with Sharing Class CustomerSearchInfo {
        String CLIENT_NUMBER ; 
        String SOLDTO ; 
        String SOLDTO_NAME ; 
        String SALES_ORG ; 
        String DISTRIBUTION_CHANNEL ; 
        String ORDER_NUMBER;
        String PO_NUMBER ; 
        String DIVISION ; 
        String POSTAL_CODE; 
        String VAT_REG_NUMBER ;
        String PART_NUMBER ; 
    }
    
    /****************************************************
* @Description : Method to Show Customer information
* ****************************************************/
   /* public with Sharing Class ResponseCustomerInfo {
        Boolean isSuccess = false ; 
        List<CustomerInfo> lstCustomers = new List<CustomerInfo>(); 
    }*/
    
    /**************************************************
* @Description : wrapper instance to send account id , name
* ************************************************/
    public with Sharing Class CustomerInfo {
        String value ; 
        String label ;
        //String soldToNumber ; 
        public CustomerInfo(String value , String label ) {
            this.value = value ; 
            this.label = label ; 
            //this.soldToNumber = soldToNumber ; 
        }
    }
    
        
     /**************************************************
* @Description : To Extract All The Coutry Names
* ************************************************/
    
    public String doCountryInfo() {
        
        String result ;
        List<String> countryList = new List<String>();
        countryList.add('None');
       Schema.DescribeFieldResult fieldResult = Account.Region__c.getDescribe(); 
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues(); 
        System.debug('Picklist::'+ple); 
        for( Schema.PicklistEntry f : ple)
        { 
            System.debug(f.getLabel() +'::'+ f.getValue()); 
            countryList.add(f.getValue());
        }
        
        result = JSON.serialize(countryList);
        
        return result ; 
    }
    
}