@isTest
private class Test_Account_Contact_Webservices {

    private static testMethod void testWebServices() {
        
        Country__c countryval = new Country__c(name='INDIA',SFDC_Country_Name__c='INDIA');
        insert countryval;
        account honeywellAccount = new account(name='test_case_account',Customer_Status__c='Active',Country__c=countryval.id,Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        insert honeywellAccount;
        contact honeywellContact = new contact(firstname='test',lastname='user1',accountid=honeywellAccount.id,Honeywell_ID__c='T134297',contact_status__c='Active');
        insert honeywellContact;
        Portal_Honeywell_Id__c  portalHWContact = new Portal_Honeywell_Id__c(Contact__c=honeywellContact.Id,name='T134297');
        insert portalHWContact;
        
        // for fetching contact information             
        RestRequest req2 = new RestRequest(); 
        RestResponse res2 = new RestResponse();
        req2.requestURI = '/services/apexrest/AerospaceAccountServices';  //Request URL
        req2.httpMethod = 'GET';//HTTP Request Type
        req2.addParameter('honeywellid', 'T134297');
        req2.addParameter('type', 'contact');
        RestContext.request = req2;
        RestContext.response= res2;
        AccountAndContactWebserviceController.getRecord();
        
        // for fetching account info
        RestRequest req3 = new RestRequest(); 
        RestResponse res3 = new RestResponse();
        req3.requestURI = '/services/apexrest/AerospaceAccountServices';  //Request URL
        req3.httpMethod = 'GET';//HTTP Request Type
        req3.addParameter('honeywellid', 'T134297');
        req3.addParameter('type', 'account');
        RestContext.request = req3;
        RestContext.response= res3;
        AccountAndContactWebserviceController.getRecord();
        
        // for Auto Suggest Accounts
        RestRequest req4 = new RestRequest(); 
        RestResponse res4 = new RestResponse();
        req4.requestURI = '/services/apexrest/AerospaceAccountServices';  //Request URL
        req4.httpMethod = 'GET';//HTTP Request Type
        req4.addParameter('accountname', 'test');
        req4.addParameter('accounttype', 'operator');
        RestContext.request = req4;
        RestContext.response= res4;
        AccountAndContactWebserviceController.getRecord();
    
    	// for Auto Suggest Accounts
        RestRequest req5 = new RestRequest(); 
        RestResponse res5 = new RestResponse();
        req5.requestURI = '/services/apexrest/AerospaceAccountServices';  //Request URL
        req5.httpMethod = 'GET';//HTTP Request Type
        req5.addParameter('accountname', '');
        req5.addParameter('accounttype', 'dealer');
        RestContext.request = req5;
        RestContext.response= res5;
        AccountAndContactWebserviceController.getRecord();
    
    }

}