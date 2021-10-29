@isTest
public with sharing class LeapContractUpdateRestServiceTest {
    @TestSetup
    static void makeData(){
        Account acc= new Account(Name='New Account',BillingStreet = '1st street', BillingCity = 'Chennai', BillingCountry = 'India', Phone = '7708218788', Type ='End User');
        insert acc;
        //Contact Creation
        Contact c1 = new Contact(LastName='My Contact', AccountID=acc.id, Email = 'test@test.com');
        insert c1;
        //Opportunity Creation
        Opportunity opp = new Opportunity(name='My New Opportunity', amount=600000, AccountID=acc.id,StageName = 'Qualify',CloseDate = system.today());
        insert opp;
        //User Creation
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User ContractOwner = new User(LastName='test',alias='test',LocaleSidKey = 'en_US',TimeZoneSidKey = 'America/Los_Angeles',EmailEncodingKey = 'UTF-8',LanguageLocaleKey = 'en_US', email='test01@test.com',username='test01@test.domain.com',profileId=profileId.Id);
        insert ContractOwner;
    }

    @isTest
    public static void testMethod1(){
        Account acc = [Select Id from Account LIMIT 1];
        Contact con = [Select Id from Contact LIMIT  1];
        Opportunity opp = [SELECT Id from Opportunity LIMIT 1];
        User ContractOwner = [SELECT Id from User LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new LeapContractCreationServiceMockCallout(true,true,false,false));
        Test.startTest();
        //Contract Creation
        ID recordTypeID = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Contracts').getRecordTypeId();
        Contract cont = New Contract(RecordTypeId = recordTypeID,CurrencyISOCode='EUR',Description = 'Test', Name = 'Test ', Opportunity__c = opp.Id, AccountId=acc.Id,Customer_Contact_Name__C = con.id,Leap_Contract_Owner__c = ContractOwner.id);        
        insert cont;
        //CallInLpHttpCalloutMock 
        
        Map<String, String> jsonMap = new Map<String,String>();
        //Contract con = [Select Id, AccountId, Leap_Opportunity__c, Type__C from Contract LIMIT 1];
        jsonMap.put('SFDCContractId',cont.Id);
        jsonMap.put('LeapContractId','23');
        jsonMap.put('SObjectType','Sales Contract');
        jsonMap.put('ContractStatus','Activated');
        jsonMap.put('contract_start_date','04/26/2020');
        jsonMap.put('contract_end_date','6/4/2020');
        jsonMap.put('PDFLink','https://honeywell.agiloft.com/gui2/samlssologin.jsp?kb=Leap&State=View:attachment&record=104846&record_access=view&exiturl=leaveLoggedIn&cancelurl=leaveLoggedIn');
        jsonMap.put('Amount','15400');
        jsonMap.put('AgreementType','Delivery Contract');
        jsonMap.put('AgreementSubType','Delivery Sub Contract');
        String JsonMsg=JSON.serialize(jsonMap);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/updateContract'; 
        req.httpMethod = 'Post';
        req.addHeader('Content-Type', 'application/json'); 
        req.requestBody = Blob.valueof(JsonMsg);
        req.addParameter('ManagingUnit', 'Aero Sales');
        req.addParameter('SBU', 'AERO');
       
        RestContext.response = res; 
        
        RestContext.request = req;
        LeapContractUpdateRestService.doUpdate();
        Test.stopTest();  
    }
    @isTest
    public static void testMethod2(){
        Account acc = [Select Id from Account LIMIT 1];
        Contact con = [Select Id from Contact LIMIT  1];
        Opportunity opp = [SELECT Id,accountId from Opportunity LIMIT 1];
        User ContractOwner = [SELECT Id from User LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new LeapContractCreationServiceMockCallout(true,true,false,false));
        Test.startTest();
        //Contract Creation
        ID recordTypeID = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Contracts').getRecordTypeId();
        Contract cont = New Contract(RecordTypeId = recordTypeID,Description = 'Test', Name = 'Test ', Opportunity__c = opp.Id,AccountId=opp.AccountId,Customer_Contact_Name__c = con.id,Leap_Contract_Owner__c = ContractOwner.id);
        insert cont;
        //CallInLpHttpCalloutMock 
        
        Map<String, String> jsonMap = new Map<String,String>();
        //Contract con = [Select Id, AccountId, Leap_Opportunity__c, Type__C from Contract LIMIT 1];
        jsonMap.put('SFDCContractId',cont.Id);
        jsonMap.put('LeapContractId','23');
        jsonMap.put('SObjectType','Service Contract');
        jsonMap.put('ContractStatus','Activated');
        jsonMap.put('contract_start_date','04/26/2020');
        jsonMap.put('contract_end_date','4/4/2020');
        jsonMap.put('PDFLink','https://honeywell.agiloft.com/gui2/samlssologin.jsp?kb=Leap&State=View:attachment&record=104846&record_access=view&exiturl=leaveLoggedIn&cancelurl=leaveLoggedIn');
        jsonMap.put('Amount','15400');
        jsonMap.put('AgreementType','Delivery Contract');
        jsonMap.put('AgreementSubType','Delivery Sub Contract');
        String JsonMsg=JSON.serialize(jsonMap);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/updateContract'; 
        req.httpMethod = 'Post';
        req.addHeader('Content-Type', 'application/json'); 
        req.requestBody = Blob.valueof(JsonMsg);
        req.addParameter('ManagingUnit', 'Aero Sales');
        req.addParameter('AERO', 'AERO'); 
       
        RestContext.response = res; 
        
        RestContext.request = req;
        LeapContractUpdateRestService.doUpdate();
        Test.stopTest();  
    }
    @isTest
    public static void testMethod4(){
        Account acc = [Select Id from Account LIMIT 1];
        Contact con = [Select Id from Contact LIMIT  1];
        Opportunity opp = [SELECT Id from Opportunity LIMIT 1];
        User ContractOwner = [SELECT Id from User LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new LeapContractCreationServiceMockCallout(true,true,false,false));
        Test.startTest();
        //Contract Creation
        String RecordTypeName = (Label.Leap_Record_Name.Split(','))[0];
        ID recordTypeID = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Contracts').getRecordTypeId();
        Contract cont = New Contract(RecordTypeId = recordTypeID,Description = 'Test', Name = 'Test ', Opportunity__c = opp.Id,AccountId=acc.Id,Customer_Contact_Name__C = con.id,Leap_Contract_Owner__c = ContractOwner.id);        
        insert cont;
        //CallInLpHttpCalloutMock 
        
        Map<String, String> jsonMap = new Map<String,String>();
        //Contract con = [Select Id, AccountId, Leap_Opportunity__c, Type__C from Contract LIMIT 1];
        jsonMap.put('SFDCContractId',cont.Id);
        jsonMap.put('LeapContractId','23');
        //jsonMap.put('SObjectType','Service Contract');
        jsonMap.put('ContractStatus','Activated');
        jsonMap.put('contract_start_date','04/26/2020');
        jsonMap.put('contract_end_date','4/4/2020');
        jsonMap.put('PDFLink','https://honeywell.agiloft.com/gui2/samlssologin.jsp?kb=Leap&State=View:attachment&record=104846&record_access=view&exiturl=leaveLoggedIn&cancelurl=leaveLoggedIn');
        jsonMap.put('Amount','15400');
        jsonMap.put('AgreementType','Delivery Contract');
        jsonMap.put('AgreementSubType','Delivery Sub Contract');
        String JsonMsg=JSON.serialize(jsonMap);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/updateContract'; 
        req.httpMethod = 'Post';
        req.addHeader('Content-Type', 'application/json'); 
        req.requestBody = Blob.valueof(JsonMsg);
        req.addParameter('ManagingUnit', 'Aero Sales');
        req.addParameter('SBU', 'AERO');
   
        RestContext.response = res; 
        
        RestContext.request = req;
        LeapContractUpdateRestService.doUpdate();
        Test.stopTest();  
    }
   /* @isTest
    public static void testMethod5(){
        Account acc = [Select Id from Account LIMIT 1];
        Contact con = [Select Id from Contact LIMIT  1];
        Opportunity opp = [SELECT Id from Opportunity LIMIT 1];
        User ContractOwner = [SELECT Id from User LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new LeapContractCreationServiceMockCallout(true,true,false,false));
        Test.startTest();
        ID recordTypeID = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Contracts').getRecordTypeId();
        Contract cont = New Contract(RecordTypeId = recordTypeID,Description = 'Test', Name = 'Test ', AccountId=acc.Id,Customer_Contact_Name__C = con.id,Leap_Contract_Owner__c = ContractOwner.id);        
        insert cont;
        
        Map<String, String> jsonMap = new Map<String,String>();
        jsonMap.put('SFDCContractId',cont.Id);
        jsonMap.put('LeapContractId','23');
        jsonMap.put('SObjectType','Sales Contract');
        jsonMap.put('ContractStatus','Activated');
        jsonMap.put('contract_start_date','04/26/2020');
        jsonMap.put('contract_end_date','4/4/2020');
        jsonMap.put('PDFLink','https://honeywell.agiloft.com/gui2/samlssologin.jsp?kb=Leap&State=View:attachment&record=104846&record_access=view&exiturl=leaveLoggedIn&cancelurl=leaveLoggedIn');
        jsonMap.put('Amount','15400');
        jsonMap.put('AgreementType','Delivery Contract');
        jsonMap.put('AgreementSubType','Delivery Sub Contract');
        String JsonMsg=JSON.serialize(jsonMap);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/updateContract'; 
        req.httpMethod = 'Post';
        req.addHeader('Content-Type', 'application/json'); 
        req.requestBody = Blob.valueof(JsonMsg);
        
        RestContext.response = res; 
        
        RestContext.request = req;
        LeapContractUpdateRestService.doUpdate();
        Test.stopTest();  
    }*/

    }