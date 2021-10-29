@isTest
private class TestCaseAircraft_Web_ServiceController {

    private static testMethod void testCaseServices() {
        Test.startTest();
        Group g1 = new Group(Name='testQueuename', type='Queue');
        insert g1;
         User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        system.runAs(thisUser){
        QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'case');
        insert q1;
        Country__c countryval = new Country__c(name='INDIA',SFDC_Country_Name__c='INDIA');
        insert countryval;
        account honeywellAccount = new account(name='test_case_account',Customer_Status__c='Active',Country__c=countryval.id,Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        insert honeywellAccount;
        contact honeywellContact = new contact(firstname='test',lastname='user1',accountid=honeywellAccount.id,Honeywell_ID__c='T134297');
        insert honeywellContact;
        Platform__c plat = new Platform__c(Name='test platform',Platform_Type__c='Space',Managing_SBU__c='ATR',Make__c='test',Model__c='test');
        insert plat;
        Fleet_Asset_Detail__c fleetAsset = new Fleet_Asset_Detail__c(Name='test Fleet',Account__c=honeywellAccount.id,Serial_Number__c='test',Tail_Number__c='test',Platform_Name__c=plat.id);
        insert fleetAsset;
            
        }
        Case newCase = new Case(status='Open');
        insert newCase;
        Case cc = [Select CaseNumber from Case where id =: newCase.id];
        
        String JsonMsg='{ "honeywellID":"T134297","subject":"Test Case webservices","description":"testclass for the web service",'+
                        '"classification":"0708217 BC LTD","comments":"testclass for the web service","recordtypename":"Warranty",'+
                        '"substatus":"1st Follow-up","ownerQueue":"testQueuename","status":"status","contractType":"test","leadSource":"test","aircraftModel":"test","aircraftMake":"test","aircraftSerialNumber":"test","aircraftTail":"test","quoteNumber":"123","quotePrice":"5","operatorName":"test_case_account","dealerName":"test_case_account"}';
        //System.debug('JsonMsg'+);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
    
        req.requestURI = '/services/apexrest/AerospaceAircraftCaseServices';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        caseWithAircraftWebServiceController.doPost();
        Test.stopTest();
        
       }
       
       private static testMethod void unitTest(){
       
       Test.startTest();
        Group g1 = new Group(Name='testQueuename', type='Queue');
        insert g1;
         User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        system.runAs(thisUser){
        QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'case');
        insert q1;
        Country__c countryval = new Country__c(name='INDIA',SFDC_Country_Name__c='INDIA');
        insert countryval;
        account honeywellAccount = new account(name='test_case_account',Customer_Status__c='Active',Country__c=countryval.id,Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        insert honeywellAccount;
        contact honeywellContact = new contact(firstname='test',lastname='user1',accountid=honeywellAccount.id,Honeywell_ID__c='T134297');
        insert honeywellContact;
        Platform__c plat = new Platform__c(Name='test platform',Platform_Type__c='Space',Managing_SBU__c='ATR',Make__c='test',Model__c='test');
        insert plat;
        Fleet_Asset_Detail__c fleetAsset = new Fleet_Asset_Detail__c(Name='test Fleet',Account__c=honeywellAccount.id,Serial_Number__c='test',Tail_Number__c='test',Platform_Name__c=plat.id);
        insert fleetAsset;
            
        }
        Case newCase = new Case(status='Open');
        insert newCase;
        Case cc = [Select CaseNumber from Case where id =: newCase.id];
        
       String JsonMsg1='{ "honeywellID":"T134297","subject":"Test Case webservices","description":"testclass for the web service",'+
                        '"classification":"0708217 BC LTD","comments":"testclass for the web service","recordtypename":"Warranty",'+
                        '"substatus":"1st Follow-up","ownerQueue":"testQueuename","status":"status","caseNumber":"'+cc.CaseNumber+'","updationType":"Quote Created"}';
        //System.debug('JsonMsg'+);
        RestRequest req1 = new RestRequest(); 
        RestResponse res1 = new RestResponse();
        caseWithAircraftWebServiceController.CaseDetailRecord csDetRec=new caseWithAircraftWebServiceController.CaseDetailRecord();
        req1.requestURI = '/services/apexrest/AerospaceAircraftCaseServices';  //Request URL
        req1.httpMethod = 'POST';//HTTP Request Type
        req1.requestBody = Blob.valueof(JsonMsg1);
        RestContext.request = req1;
        RestContext.response= res1;
        caseWithAircraftWebServiceController.doPost();
       
         test.stopTest();
       
       
        }
        private static testMethod void unitTestOne(){
           Test.startTest();
            Group g1 = new Group(Name='testQueuename', type='Queue');
            insert g1;
            User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
            system.runAs(thisUser){
            QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'case');
            insert q1;
            Country__c countryval = new Country__c(name='INDIA',SFDC_Country_Name__c='INDIA');
            insert countryval;
            account honeywellAccount = new account(name='test_case_account',Customer_Status__c='Active',Country__c=countryval.id,Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
            insert honeywellAccount;
            contact honeywellContact = new contact(firstname='test',lastname='user1',accountid=honeywellAccount.id,Honeywell_ID__c='T134297');
            insert honeywellContact;
            Platform__c plat = new Platform__c(Name='test platform',Platform_Type__c='Space',Managing_SBU__c='ATR',Make__c='test',Model__c='test');
            insert plat;
            Fleet_Asset_Detail__c fleetAsset = new Fleet_Asset_Detail__c(Name='test Fleet',Account__c=honeywellAccount.id,Serial_Number__c='test',Tail_Number__c='test',Platform_Name__c=plat.id);
            insert fleetAsset;

            }
            Case newCase = new Case(status='Open');
            insert newCase;
            Case cc = [Select CaseNumber from Case where id =: newCase.id];
            String JsonMsg2='{ "honeywellID":"T134297","subject":"Test Case webservices","description":"testclass for the web service",'+
                                '"classification":"0708217 BC LTD","comments":"testclass for the web service","recordtypename":"Warranty",'+
                                '"substatus":"1st Follow-up","ownerQueue":"testQueuename","status":"status","caseNumber":"'+cc.CaseNumber+'","updationType":"Accept-Reject"}';
                //System.debug('JsonMsg'+);
                
                RestRequest req2 = new RestRequest(); 
                RestResponse res2 = new RestResponse();
                req2.requestURI = '/services/apexrest/AerospaceAircraftCaseServices';  //Request URL
                req2.httpMethod = 'POST';//HTTP Request Type
                req2.requestBody = Blob.valueof(JsonMsg2);
                RestContext.request = req2;
                RestContext.response= res2;
                caseWithAircraftWebServiceController.doPost();
           Test.stopTest();
        
        }
    }