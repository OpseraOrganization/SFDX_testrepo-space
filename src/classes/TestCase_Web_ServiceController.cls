@isTest
private class TestCase_Web_ServiceController {

    private static testMethod void testCaseServices() {
        
        Group g1 = new Group(Name='testQueuename', type='Queue');
        insert g1;
         User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        system.runAs(thisUser){
        QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'case');
        insert q1;
        
        RecordType rectype = new RecordType();
        rectype = [select id,name,SObjectType from RecordType where Name='Warranty' and SObjectType = 'Case'];
        
       
            Country__c countryval = new Country__c(name='INDIA',SFDC_Country_Name__c='INDIA');
            insert countryval;
            account honeywellAccount = new account(name='test_case_account',Customer_Status__c='Active',Country__c=countryval.id,Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
            insert honeywellAccount;
            contact honeywellContact = new contact(firstname='test',lastname='user1',accountid=honeywellAccount.id,Honeywell_ID__c='T134297');
            insert honeywellContact;
        }
        Case newCase = new Case(status='Open');
        insert newCase;
        String JsonMsg='{ "honeywellID":"T134297","subject":"Test Case webservices","description":"testclass for the web service",'+
                        '"classification":"0708217 BC LTD","comments":"testclass for the web service","recordtypename":"Warranty",'+
                        '"substatus":"1st Follow-up","ownerQueue":"testQueuename","status":"status"}';
        //System.debug('JsonMsg'+);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
    
        req.requestURI = '/services/apexrest/AerospaceCaseServices';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        CaseWebServiceController.doPost();
        
        String JsonMsg1='{ "honeywellID":"T134297","subject":"Test Case webservices","description":"testclass for the web service",'+
                        '"classification":"0708217 BC LTD","comments":"testclass for the web service","recordtypename":"Warranty",'+
                        '"substatus":"1st Follow-up","ownerQueue":"testQueuename","status":"status","caseID":"'+newCase.Id+'"}';
        //System.debug('JsonMsg'+);
        RestRequest req1 = new RestRequest(); 
        RestResponse res1 = new RestResponse();
    
        req1.requestURI = '/services/apexrest/AerospaceCaseServices';  //Request URL
        req1.httpMethod = 'POST';//HTTP Request Type
        req1.requestBody = Blob.valueof(JsonMsg1);
        RestContext.request = req1;
        RestContext.response= res1;
        CaseWebServiceController.doPost();
        }
    }