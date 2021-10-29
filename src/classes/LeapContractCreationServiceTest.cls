@isTest 
public with sharing class LeapContractCreationServiceTest {
    @TestSetup
    static void makeData(){
        Account acc= new Account(Name='New Account',BillingStreet = '1st street', BillingCity = 'Chennai', BillingCountry = 'India', Phone = '7708218788', Type ='End User');
        insert acc;
        //Opportunity Creation
        Contact c1 = new Contact(LastName='My Contact', AccountID=acc.id, Email = 'test@test.com');
        insert c1;
        //Service Contract Creation
        Opportunity opp = new Opportunity(name='My New Opportunity', amount=600000, AccountID=acc.id,StageName = 'Qualify',CloseDate = system.today());
        insert opp;
        //User Creation
        Profile prof = [select id from profile where name LIKE '%marketing%' LIMIT 1];

       // Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        system.debug('++prof++'+prof);

    }
    @isTest
   //Access Token Success and Creating Contract Success 
    public static void testMethod1(){
        Account acc = [Select Id from Account LIMIT 1];
        Contact con = [Select Id from Contact LIMIT  1];
        Opportunity opp = [SELECT Id from Opportunity LIMIT 1];
        User ContractOwner = [SELECT Id from User LIMIT 1];
        ID recordTypeID = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Contracts').getRecordTypeId();
        //Contract cont = New Contract(Description = 'Test', Name = 'Test ', Leap_Opportunity__c = opp.Id, Type__c = 'Sales Contract',AccountId=acc.Id);
        Contract cont = New Contract(RecordTypeId = recordTypeID,Description = 'Test', Name = 'Test ', Opportunity__c = opp.Id,AccountId=acc.Id,Customer_Contact_Name__c = con.Id,Leap_Contract_Owner__C = ContractOwner.Id);        
        //Contract SerCont = New Contract(Description = 'Test', Name = 'Test ', Leap_Opportunity__c = opp.Id,AccountId=acc.Id,Customer_Contact_Name__c = con.Id,Leap_Contract_Owner__C = ContractOwner.Id);
        Test.setMock(HttpCalloutMock.class, new LeapContractCreationServiceMockCallout(true,true,false,false));
        Test.StartTest();
        insert cont;
        Test.StopTest();
        
    }
    //Access Token Success and Creating Contract Failure 
    @isTest
    public static void testMethod2(){
        Account acc = [Select Id from Account LIMIT 1];
        Contact con = [Select Id from Contact LIMIT  1];
        Opportunity opp = [SELECT Id from Opportunity LIMIT 1];
        User ContractOwner = [SELECT Id from User LIMIT 1];
        String RecordTypeName = (Label.Leap_Record_Name.Split(','))[0];
        ID recordTypeID = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Contracts').getRecordTypeId();
        Contract cont = New Contract(RecordTypeId = recordTypeID,Description = 'Test', Name = 'Test ', Opportunity__c = opp.Id,AccountId=acc.Id,Customer_Contact_Name__c = con.Id,Leap_Contract_Owner__C = ContractOwner.Id);
        Test.setMock(HttpCalloutMock.class, new LeapContractCreationServiceMockCallout(true,false,false, false));
        Test.StartTest();
        insert cont;
        
        Contract assertValues = [SELECT Id, Leap_Contract_Id__c, Integration_Status__c from Contract where id =: cont.Id];
        System.assertEquals(null ,assertValues.Leap_Contract_Id__c);
        System.assertEquals(null ,assertValues.Integration_Status__c);
        
    }
    //Access Token - Failure
    @isTest
    public static void testMethod3(){
        Account acc = [Select Id from Account LIMIT 1];
        Contact con = [Select Id from Contact LIMIT  1];
        Opportunity opp = [SELECT Id from Opportunity LIMIT 1];
        User ContractOwner = [SELECT Id from User LIMIT 1];
        ID recordTypeID = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Contracts').getRecordTypeId();
        Contract cont = New Contract(Description = 'Test', Name = 'Test ', Opportunity__c = opp.Id,AccountId=acc.Id,Customer_Contact_Name__c = con.Id,Leap_Contract_Owner__C = ContractOwner.Id);
        Test.setMock(HttpCalloutMock.class, new LeapContractCreationServiceMockCallout(false,false,false,false));
        Test.StartTest();
        insert cont;
        Test.StopTest();
        Contract assertValues = [SELECT Id, Leap_Contract_Id__c, Integration_Status__c from Contract where id =: cont.Id];
        System.assertEquals(null,assertValues.Leap_Contract_Id__c);
        System.assertEquals(null ,assertValues.Integration_Status__c);
        
    }
    @isTest
    public static void testMethod4(){
        Account acc = [Select Id from Account LIMIT 1];
        Contact con = [Select Id from Contact LIMIT  1];
        Opportunity opp = [SELECT Id from Opportunity LIMIT 1];
        User ContractOwner = [SELECT Id from User LIMIT 1];
        ID recordTypeID = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Contracts').getRecordTypeId();
        Contract cont = New Contract(RecordTypeId = recordTypeID,Description = 'Test', Name = 'Test ', Opportunity__c = opp.Id,AccountId=acc.Id,Customer_Contact_Name__c = con.Id,Leap_Contract_Owner__C = ContractOwner.Id);
        Test.setMock(HttpCalloutMock.class, new LeapContractCreationServiceMockCallout(true,true,false,false));
        insert cont;
        cont.Leap_Contract_Id__c = '';
        update cont;
        Test.StartTest();
        //Contract Re Sync Button
        Contract assertValues = [SELECT Id, Leap_Contract_Id__c, Integration_Status__c from Contract where id =: cont.Id];
        LeapContractCreationService.Request req = new LeapContractCreationService.Request();
        List<LeapContractCreationService.Request> listreq = new List<LeapContractCreationService.Request>();
        req.ContractId = assertValues.Id;
        //req.ContractType = 'Sales Contract';
        req.source = 'Flow';
        listreq.add(req);
        LeapContractCreationService.syncContractAgain(listreq);
         LeapContractCreationService.searchContractinLeap('56523','contract');
        Test.StopTest();
        
    }
    @isTest
    public static void testMethod5(){
        Account acc = [Select Id from Account LIMIT 1];
        Contact con = [Select Id from Contact LIMIT  1];
        Opportunity opp = [SELECT Id from Opportunity LIMIT 1];
        User ContractOwner = [SELECT Id from User LIMIT 1];
        ID recordTypeID = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Contracts').getRecordTypeId();
        Contract cont = New Contract(RecordTypeId = recordTypeID,Description = 'Test', Name = 'Test ', Opportunity__c = opp.Id,AccountId=acc.Id,Customer_Contact_Name__c = con.Id,Leap_Contract_Owner__C = ContractOwner.Id);
        Test.setMock(HttpCalloutMock.class, new LeapContractCreationServiceMockCallout(true,true,true,false));
        insert cont;
        cont.Leap_Contract_Id__c = '';
        update cont;
        Test.StartTest();
        //Contract Re Sync Button
        Contract assertValues = [SELECT Id, Leap_Contract_Id__c, Integration_Status__c from Contract where id =: cont.Id];
        LeapContractCreationService.Request req = new LeapContractCreationService.Request();
        List<LeapContractCreationService.Request> listreq = new List<LeapContractCreationService.Request>();
        req.ContractId = assertValues.Id;
        //req.ContractType = 'Sales Contract';
        req.source = 'Flow';
        listreq.add(req);
        LeapContractCreationService.syncContractAgain(listreq);
        Test.StopTest();
        
    }
    @isTest
    public static void testMethod6(){
        Account acc = [Select Id from Account LIMIT 1];
        Contact con = [Select Id from Contact LIMIT  1];
        Opportunity opp = [SELECT Id from Opportunity LIMIT 1];
        User ContractOwner = [SELECT Id from User LIMIT 1];
        ID recordTypeID = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Contracts').getRecordTypeId();
        //Contract cont = New Contract(Description = 'Test', Name = 'Test ', Leap_Opportunity__c = opp.Id, Type__c = 'Service Contract',AccountId=acc.Id);
        Contract cont = New Contract(RecordTypeId = recordTypeID,Description = 'Test', Name = 'Test ', Opportunity__c = opp.Id,AccountId=acc.Id,Customer_Contact_Name__c = con.Id,Leap_Contract_Owner__C = ContractOwner.Id);        
        Test.setMock(HttpCalloutMock.class, new LeapContractCreationServiceMockCallout(true,true,false,true));
        insert cont;
        cont.Leap_Contract_Id__c = '';
        update cont;
        Test.StartTest();
        //Contract Re Sync Button
        Contract assertValues = [SELECT Id, Leap_Contract_Id__c, Integration_Status__c from Contract where id =: cont.Id];
        LeapContractCreationService.Request req = new LeapContractCreationService.Request();
        List<LeapContractCreationService.Request> listreq = new List<LeapContractCreationService.Request>();
        req.ContractId = assertValues.Id;
        //req.ContractType = 'Sales Contract';
        req.source = 'Flow';
        listreq.add(req);
        LeapContractCreationService.syncContractAgain(listreq);
        Test.StopTest();
        
    }
    
    
}