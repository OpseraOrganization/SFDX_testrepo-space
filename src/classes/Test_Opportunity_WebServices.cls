/** * File Name: Test_Opportunity_WebServices
* Description Test class for Opportunity web services
* Copyright : ITC INFOTECH Limited Copyright (c) 2017
* * @author : ITC INFOTECH
Ver Date Author v1.0 06/02/2017
* */ 
@isTest
private class Test_Opportunity_WebServices {

    private static testMethod void testOpptyServices() {
        Country__c countryval = new Country__c(name='INDIA',SFDC_Country_Name__c='INDIA');
        insert countryval;
        account honeywellAccount = new account(name='test_case_account',Customer_Status__c='Active',Country__c=countryval.id,Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        insert honeywellAccount;
        
        account honeywellAccount1 = new account(name='HONEYWELL DEFAULT ACCOUNT',Customer_Status__c='Active',Country__c=countryval.id,Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        insert honeywellAccount1;
        
        list<RecordType> recVal = [select id from RecordType where Name ='BGA AM' AND SObjectType = 'Opportunity'];
        
        Opportunity updateOppty = new Opportunity(RecordTypeid=recVal[0].id,name='test oppty',accountid=honeywellAccount.id,stagename='Request Sent',Comments__c='test comments',Opportunity_Notes__c='sample notes',CloseDate=date.valueof('2017-02-22'));
        insert updateOppty;
        
        Test.StartTest();
        Platform__c pf1 = new Platform__c(name='testPlatform1',Model__c='Tesla',Platform_Type__c='Airplane',Make__c='TS12435',Managing_SBU__c='BGA');
        insert pf1;
        Platform__c pf2 = new Platform__c(name='testPlatform2',Model__c='Teslas',Platform_Type__c='Airplane',Make__c='TS3245',Managing_SBU__c='BGA');
        insert pf2;
        Fleet_Asset_Detail__c aircraftinfo1 =  new Fleet_Asset_Detail__c(name='testaircraftValue',Serial_Number__c='te2432423',Tail_Number__c='TA5678',Platform_Name__c=pf1.id);
        insert aircraftinfo1;
        Fleet_Asset_Detail__c aircraftinfo2 =  new Fleet_Asset_Detail__c(name='testaircraftValue2',Serial_Number__c='te243890',Platform_Name__c=pf2.id);
        insert aircraftinfo2;
        
        // For inserting the Opporunity 
        String JsonMsg2='{"contractType":"MSP - HAPP","recordtypeName":"BGA AM","quotePrice":"40000","dealerName":"deal123","operatorName":"operator123","stage":"Request Sent","aircraftMake":"TS12435","aircraftModel":"Tesla","aircraftSerialNumber":"te2432423","aircraftTail":"TA5678","notes":"Test Note","quotenumber":"q453434","leadSourcevalue":"Web","comments":"test","quoteValidDate":"2017-02-22"}';
                        
        RestRequest req2 = new RestRequest(); 
        RestResponse res2 = new RestResponse();
    
        req2.requestURI = '/services/apexrest/AerospaceOpportunityService';  //Request URL
        req2.httpMethod = 'POST';//HTTP Request Type
        req2.requestBody = Blob.valueof(JsonMsg2);
        RestContext.request = req2;
        RestContext.response= res2;
        OpportunityWebserviceController.doPost();
        
        String JsonMsg='{"contractType":"MSP - HAPP","recordtypeName":"BGA AM","quotePrice":"40000","dealerName":"test_case_account","operatorName":"HONEYWELL DEFAULT ACCOUNT","stage":"Request Sent","aircraftMake":"TS12fg5","aircraftModel":"Tesdsla","aircraftSerialNumber":"trty2423","aircraftTail":"TAfdf78","notes":"Test Note","quotenumber":"q453434","leadSourcevalue":"Web","comments":"test","quoteValidDate":"2017-02-22"}';
                        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
    
        req.requestURI = '/services/apexrest/AerospaceOpportunityService';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        OpportunityWebserviceController.doPost();
        
        // For updating the opportunity
        String JsonMsg3='{"opportunityID":"'+updateOppty.id+'","stage":"Rejected","notes":"Test Note343","comments":"test232"}';
                        
        RestRequest req3 = new RestRequest(); 
        RestResponse res3 = new RestResponse();
    
        req3.requestURI = '/services/apexrest/AerospaceOpportunityService';  //Request URL
        req3.httpMethod = 'POST';//HTTP Request Type
        req3.requestBody = Blob.valueof(JsonMsg3);
        RestContext.request = req3;
        RestContext.response= res3;
        OpportunityWebserviceController.doPost();
        
        Test.StopTest();
    }

}