@isTest
private class Test_Fleet_Asset_Webservices 
{
    private static testMethod void testWebServices() 
    {
        Country__c countryval = new Country__c(name='India',SFDC_Country_Name__c='India');
        insert countryval;
        account honeywellAccount = new account(name='test_case_account',Customer_Status__c='Active',Country__c=countryval.id,Report_Country_Name__c='India',Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        insert honeywellAccount;
        contact honeywellContact = new contact(firstname='test',lastname='user1',Email='testuser@itc.com',accountid=honeywellAccount.id,Honeywell_ID__c='T134297');
        insert honeywellContact;
                
        // for fetching contact information        
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        request.requestURI = '/services/apexrest/AerospaceAircraftandProgramServices';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        
        request.addParameter('requestType', '');
        RestContext.request = request; 
        RestContext.response= response;       
        AircraftandServiceWebserviceController.getRecord();
        
        request.addParameter('requestType', 'aircraftandservice');
        RestContext.request = request;        
        AircraftandServiceWebserviceController.getRecord();
        
        request.addParameter('requestType', 'aircraft');
        request.addParameter('honeywellid', '');        
        RestContext.request = request;        
        AircraftandServiceWebserviceController.getRecord();
        
        request.addParameter('honeywellid', 'E23456');        
        RestContext.request = request;        
        AircraftandServiceWebserviceController.getRecord(); 
               
        request.addParameter('honeywellid', 'T134297');
        RestContext.request = request;        
        honeywellContact.accountid =null;
        update honeywellContact;
        AircraftandServiceWebserviceController.getRecord();
        
        honeywellContact.accountid =honeywellAccount.id;
        honeywellContact.Contact_Status__c ='Inactive';        
        update honeywellContact;
        AircraftandServiceWebserviceController.getRecord();
        
        honeywellContact.Contact_Status__c ='active';
        update honeywellContact;
        AircraftandServiceWebserviceController.getRecord();
        Platform__c p = new Platform__c(Name='test plaform',Platform_Type__c='Airplane');
        insert p;
        
        Fleet_Asset_Detail__c fleetAsset = new Fleet_Asset_Detail__c(Name='test Fleet',Account__c=honeywellAccount.id,Platform_Name__c=p.id);
        insert fleetAsset;
        AircraftandServiceWebserviceController.getRecord(); 
        
        request.addParameter('requestType', 'serviceprogram');
        RestContext.request = request;       
        AircraftandServiceWebserviceController.getRecord();
        
        Master_Service_Program__c serviceProgram = new Master_Service_Program__c(Name='Service program');
        insert serviceProgram;  
        AircraftandServiceWebserviceController.getRecord();
        
    }
}