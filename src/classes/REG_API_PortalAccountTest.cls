@isTest
private class REG_API_PortalAccountTest 
{
   /*** @TestSetup
    static void fncDataSetup() {
        Reg_TestDataFactory.createTestRecords();        
    }***/
    
        @TestSetup
    static void testData()  
    {
        Country__c countryval = new Country__c(name='India',SFDC_Country_Name__c='India');
        insert countryval;
        Country__c countryval1 = new Country__c(name='US',SFDC_Country_Name__c='US');
        insert countryval1;
        Country__c countryval2 = new Country__c(name='Canada',SFDC_Country_Name__c='Canada');
        insert countryval2;
        Country_States__c conStat = new Country_States__c(Country__c = countryval2.Id, Name = 'GA');
        insert conStat;
        account honeywellAccount = new account(name='Exchange',Customer_Status__c='Active',Country__c=countryval.id,Report_Country_Name__c='India',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        insert honeywellAccount;
        account honeywellAccount1 = new account(name='REG_API_PortalAccountTest',Customer_Status__c='Active',Country__c=countryval1.id,Report_Country_Name__c='US',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account1');
        insert honeywellAccount1;
        account honeywellAccount2 = new account(name='Test Factory',Customer_Status__c='Active',Country__c=countryval2.id,Report_Country_Name__c='Canada',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account2');
        insert honeywellAccount2;
        Account_Email_Domains__c accEmailDom = new Account_Email_Domains__c(Account__c = honeywellAccount.Id, Account_Email_Domain__c = 'tcs.com' );
        insert accEmailDom;
        Account_Email_Domains__c accEmailDom1 = new Account_Email_Domains__c(Account__c = honeywellAccount1.Id, Account_Email_Domain__c = 'tcs.com' );
        insert accEmailDom1;
        Account_Email_Domains__c accEmailDom2 = new Account_Email_Domains__c(Account__c = honeywellAccount2.Id, Account_Email_Domain__c = 'tcs.com' );
        insert accEmailDom2;
        Account_Address__c accadd = new Account_Address__c(Account_Name__c = honeywellAccount.Id, Report_City_Name__c = 'Pune', Report_Country_Codes__c = 'IN', Report_State_Code__c = 'MH', Is_Primary_Address__c = True );
        insert accadd;
        Account_Address__c accadd1 = new Account_Address__c(Account_Name__c = honeywellAccount.Id, Report_City_Name__c = 'Bangalore', Report_Country_Codes__c = 'IN',Report_State_Code__c = 'MH', Is_Primary_Address__c = False );
        insert accadd1;
        Account_Address__c accadd2 = new Account_Address__c(Account_Name__c = honeywellAccount2.Id, Report_City_Name__c = '', Report_Country_Codes__c = 'CN', Report_State_Code__c = '', Is_Primary_Address__c = False );
        insert accadd2;
        Account_Address__c accadd3 = new Account_Address__c(Account_Name__c = honeywellAccount1.Id, Report_City_Name__c = '', Report_Country_Codes__c = 'US', Report_State_Code__c = 'GA', Is_Primary_Address__c = True );
        insert accadd3;
        Account_Address__c accadd4 = new Account_Address__c(Account_Name__c = honeywellAccount1.Id, Report_City_Name__c = 'Boston', Report_Country_Codes__c = 'US', Report_State_Code__c = 'GA', Is_Primary_Address__c = False);
        insert accadd4;
        Account_Address__c accadd5 = new Account_Address__c(Account_Name__c = honeywellAccount2.Id, Report_City_Name__c = 'Toronto', Report_Country_Codes__c = 'CN', Report_State_Code__c = '', Is_Primary_Address__c = False );
        insert accadd5;
        Account_Address__c accadd6 = new Account_Address__c(Account_Name__c = honeywellAccount2.Id, Report_City_Name__c = 'Toronto', Report_Country_Codes__c = 'CN', Report_State_Code__c = 'MN', Is_Primary_Address__c = False );
        insert accadd6;
        /*Account_Address__c accadd7 = new Account_Address__c(Account_Name__c = honeywellAccount2.Id, Report_City_Name__c = 'Toronto', Report_Country_Codes__c = 'CN', Report_State_Code__c = 'TR', Is_Primary_Address__c = True );
        insert accadd7;
        */
    }
    
    
    static testMethod void testAccount1(){
        
        // code to cover getToolStatus method      
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        request.requestURI = '/accounts/domain-match';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        request.addHeader('domain', 'tcs.com');
        request.addHeader('countrycode', 'US');
        request.addHeader('statecode', 'GA');
        request.addHeader('city', 'Boston');
        request.addHeader('output', 'combined');
        RestContext.request = request;  
        RestContext.response= response;
        Test.starttest();
        REG_API_PortalAccount.doGet(); 
        Test.stopTest();
        String result = response.responseBody.toString();
        System.assert(result.contains('matchedAccounts'));
        System.assert(result.contains('allAccounts'));
    }
    static testMethod void testAccount8(){
        
        // code to cover getToolStatus method      
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        request.requestURI = '/accounts/domain-match';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        request.addHeader('domain', 'tcs.com');
        request.addHeader('countrycode', 'IN');
        request.addHeader('statecode', 'MH');
        request.addHeader('city', 'nagpur');
        request.addHeader('output', 'filtered');
        RestContext.request = request;  
        RestContext.response= response;
        Test.starttest();
        REG_API_PortalAccount.doGet(); 
        Test.stopTest();
        String result = response.responseBody.toString();
        //System.assert(result.contains('matchedAccounts'));
        //System.assert(result.contains('allAccounts'));
    }
    
    static testMethod void testAccount2(){
        
        // code to cover getToolStatus method      
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        request.requestURI = '/accounts/domain-match';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        request.addHeader('domain', '');
        request.addHeader('countrycode', 'US');
        request.addHeader('statecode', 'GA');
        request.addHeader('city', 'Boston');
        request.addHeader('output', 'combined');
        RestContext.request = request;  
        RestContext.response= response;
        Test.starttest();
        REG_API_PortalAccount.doGet(); 
        Test.stoptest();
        String result = response.responseBody.toString();
        System.assert(result.contains('Please provide domain'));
    }   
    
    static testMethod void testAccount3(){
        
        // code to cover getToolStatus method      
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        request.requestURI = '/accounts/domain-match';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        request.addHeader('domain', 'tcs.com');
        request.addHeader('countrycode', 'CN');
        request.addHeader('statecode', '');
        request.addHeader('city', '');
        request.addHeader('output', 'filtered');
        RestContext.request = request;  
        RestContext.response= response;
        Test.starttest();
        REG_API_PortalAccount.doGet(); 
        Test.stoptest();
        String result = response.responseBody.toString();
        System.assert(result!=Null);
    } 
    
    static testMethod void testAccount4(){
        
        // code to cover getToolStatus method      
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        request.requestURI = '/accounts/domain-match';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        request.addHeader('domain', 'tcs.com');
        request.addHeader('countrycode', 'CN');
        request.addHeader('statecode', '');
        request.addHeader('city', 'Toronto');
        request.addHeader('output', 'unfiltered');
        RestContext.request = request;  
        RestContext.response= response;
        Test.starttest();
        REG_API_PortalAccount.doGet(); 
        Test.stoptest();
        String result = response.responseBody.toString();
        System.assert(result!=Null);
    }
    static testMethod void testAccount5(){
        
        // code to cover getToolStatus method      
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        request.requestURI = '/accounts/domain-match';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        request.addHeader('domain', 'tcs.com');
        request.addHeader('countrycode', 'CN');
        request.addHeader('statecode', 'MN');
        request.addHeader('city', 'Toronto');
        request.addHeader('output', 'filtered');
        RestContext.request = request;  
        RestContext.response= response;
        Test.starttest();
        REG_API_PortalAccount.doGet();
        Test.stoptest(); 
        String result = response.responseBody.toString();
        System.assert(result!=Null);
    } 
    static testMethod void testAccount6(){
        
        // code to cover getToolStatus method      
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        request.requestURI = '/accounts/domain-match';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        request.addHeader('domain', 'honeywell.com');
        request.addHeader('countrycode', 'CN');
        request.addHeader('statecode', 'MN');
        request.addHeader('city', 'Toronto');
        request.addHeader('output', 'filtered');
        RestContext.request = request;  
        RestContext.response= response;
        Test.starttest();
        REG_API_PortalAccount.doGet(); 
        Test.stoptest();
        String result = response.responseBody.toString();
        System.assert(result!=Null);
    }                  
    static testMethod void testAccount7(){
        
        // code to cover getToolStatus method      
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        request.requestURI = '/accounts/domain-match';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        request.addHeader('domain', 'honeywell.com');
        request.addHeader('countrycode', 'CN');
        request.addHeader('statecode', 'TR');
        request.addHeader('city', 'Toronto');
        request.addHeader('output', 'filtered');
        RestContext.request = request;  
        RestContext.response= response;
        Test.starttest();
        REG_API_PortalAccount.doGet(); 
        Test.stoptest();
        String result = response.responseBody.toString();
        System.assert(result!=Null);
    }   
    
    static testMethod void testAccount71(){
        
        // code to cover getToolStatus method      
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        request.requestURI = '/accounts/';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        request.addHeader('domain', 'honeywell.com');
        request.addHeader('countrycode', 'CN');
        request.addHeader('statecode', 'TR');
        request.addHeader('city', 'Toronto');
        request.addHeader('output', 'filtered');
        RestContext.request = request;  
        RestContext.response= response;
        Test.starttest();
        REG_API_PortalAccount.doGet(); 
        Test.stoptest();
        String result = response.responseBody.toString();
        System.assert(result!=Null);
    } 
    static testMethod void searchAllSoldToAccounts(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        request.requestURI = '/accounts/all-soldto/test';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type       
        RestContext.request = request;  
        RestContext.response= response;
        Test.starttest();
        REG_API_PortalAccount.doGet(); 
        Test.stoptest();
        String result = response.responseBody.toString();
        System.assert(result!=Null);
    }
}