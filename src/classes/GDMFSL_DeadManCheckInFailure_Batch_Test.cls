@IsTest
public without sharing class GDMFSL_DeadManCheckInFailure_Batch_Test {

    @IsTest
    static void testBatchNoDeadManTimer(){

        Account acct = new Account(Name='Test Account',Phone = '1234561234',BillingStreet = 'Anywhere',BillingCity = 'City',BillingState = 'Florida',BillingCountry = 'United States');
        insert acct;

        ServiceAppointment sa = GDMFSL_DataFactory.createServiceAppointment(acct.Id, 'Onsite');
        sa.GDMFSL_Dead_Man_Switch_Timer__c = null;
        insert sa;

        Test.startTest();
            Database.executeBatch(new GDMFSL_DeadManCheckInFailure_Batch());
        Test.stopTest();

        ServiceAppointment sa2 = [SELECT Id, AppointmentNumber, GDMFSL_Last_Dead_Man_Switch__c, GDMFSL_Dead_Man_Switch_Timer__c, FSL__InJeopardy__c, FSL__InJeopardyReason__c, ActualStartTime FROM ServiceAppointment];

        System.assertEquals(false, sa2.FSL__InJeopardy__c, 'FSL__InJeopardy__c was set when SA did not meet Deadman criteria');
        System.assertEquals(null, sa2.FSL__InJeopardyReason__c, 'FSL__InJeopardyReason__c was set when SA did not meet Deadman criteria');
    }

    @IsTest
    static void testBatchDeadManTimerInProgress(){

        Account acct = new Account(Name='Test Account',Phone = '1234561234',BillingStreet = 'Anywhere',BillingCity = 'City',BillingState = 'Florida',BillingCountry = 'United States');
        insert acct;

        ServiceAppointment sa = GDMFSL_DataFactory.createServiceAppointment(acct.Id, 'Onsite');
        sa.ActualStartTime = System.now().addHours(-2);
        sa.GDMFSL_Dead_Man_Switch_Timer__c = 3;
        insert sa;

        Test.startTest();
            Database.executeBatch(new GDMFSL_DeadManCheckInFailure_Batch());
        Test.stopTest();

        ServiceAppointment sa2 = [SELECT Id, AppointmentNumber, GDMFSL_Last_Dead_Man_Switch__c, GDMFSL_Dead_Man_Switch_Timer__c, FSL__InJeopardy__c, FSL__InJeopardyReason__c, ActualStartTime FROM ServiceAppointment];

        System.assertEquals(null, sa2.GDMFSL_Last_Dead_Man_Switch__c, 'GDMFSL_Last_Dead_Man_Switch__c was set for InProgress timer');
        System.assertEquals(false, sa2.FSL__InJeopardy__c, 'FSL__InJeopardy__c was set for InProgress timer');
        System.assertEquals(null, sa2.FSL__InJeopardyReason__c, 'FSL__InJeopardyReason__c was set for InProgress timer');
    }    

    @IsTest
    static void testBatchDeadManTimerHasElapsed(){

        Account acct = new Account(Name='Test Account',Phone = '1234561234',BillingStreet = 'Anywhere',BillingCity = 'City',BillingState = 'Florida',BillingCountry = 'United States');
        insert acct;

        ServiceAppointment sa = GDMFSL_DataFactory.createServiceAppointment(acct.Id, 'Onsite');
        sa.ActualStartTime = System.now().addHours(-4);
        sa.GDMFSL_Dead_Man_Switch_Timer__c = 3;
        sa.GDMFSL_Last_Dead_Man_Switch__c = sa.ActualStartTime;
        insert sa;

        Test.startTest();
            Database.executeBatch(new GDMFSL_DeadManCheckInFailure_Batch());
        Test.stopTest();

        ServiceAppointment sa2 = [SELECT Id, AppointmentNumber, GDMFSL_Last_Dead_Man_Switch__c, GDMFSL_Dead_Man_Switch_Timer__c, FSL__InJeopardy__c, FSL__InJeopardyReason__c, ActualStartTime FROM ServiceAppointment];

        System.assertNotEquals(null, sa2.GDMFSL_Last_Dead_Man_Switch__c, 'GDMFSL_Last_Dead_Man_Switch__c was not set');
        System.assertEquals(true, sa2.FSL__InJeopardy__c, 'FSL__InJeopardy__c was not set');
        System.assertEquals('Dead Man Follow Up', sa2.FSL__InJeopardyReason__c, 'FSL__InJeopardyReason__c was not set');
    }
    
    @IsTest
    static void testDeadManSendSMS(){

        Account account = GDMFSL_DataFactory.createTestAccount('TestAcc');
        insert account;

        Contact contact = GDMFSL_DataFactory.createTestContact(account.Id);
        insert contact;

        OperatingHours operatingHours = GDMFSL_DataFactory.createOperatingHour();
        insert operatingHours;

        ServiceTerritory serviceTerritory = GDMFSL_DataFactory.createServiceTerritory('DeadMan Test', operatingHours.Id);
        insert serviceTerritory;

        Schema.Location aLocation = GDMFSL_DataFactory.createLocation('Campus',serviceTerritory.Id);
        insert aLocation;

        List<WorkType> lstworktype = GDMFSL_DataFactory.createWorkTypes('W001',3,30);
        insert lstworktype;

        WorkOrder workorder = GDMFSL_DataFactory.createWorkOrder(lstworktype[0].Id, account.Id, aLocation.Id, System.now(), System.now());
        workorder.GDMFSL_PO_Number__c = '12345';
        insert workorder;

        Id p = [SELECT Id FROM Profile WHERE Name = :GDMFSL_LocationTriggerHandler.COMMUNPROFILENAME].Id;
        
        User user = new User(Alias = 'test123', Email='test123@noemail.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p, Country='United States',IsActive =true,
        ContactId = contact.Id, Phone='1234567890',
        TimeZoneSidKey='America/Los_Angeles', Username='tester@noemail.com');
        insert user;

        System.runAs(user)
        {
            List<PermissionSet> pSetList = [SELECT Id FROM PermissionSet WHERE Name = 'FSL_Resource_Permissions'];
            PermissionSetAssignment  pr = new PermissionSetAssignment (AssigneeId=user.Id,PermissionSetId=pSetList[0].Id);
            insert pr;
        }

        ServiceResource serviceResource = GDMFSL_DataFactory.createServiceResource(user.Id, null);
        serviceResource.GDMFSL_IsContractor__c = true;
        insert serviceResource;

        ServiceTerritoryMember stm = new ServiceTerritoryMember(ServiceTerritoryId=serviceTerritory.Id,ServiceResourceId=serviceResource.Id,
                                                                    TerritoryType='P', EffectiveStartDate=System.today());
        insert stm;

        ServiceAppointment serviceAppointment = GDMFSL_DataFactory.createServiceAppointment(workorder.Id, 'Onsite');
        serviceAppointment.ActualStartTime = System.now().addHours(-4);
        serviceAppointment.GDMFSL_Dead_Man_Switch_Timer__c = 3;
        serviceAppointment.GDMFSL_Last_Dead_Man_Switch__c = serviceAppointment.ActualStartTime;
        insert serviceAppointment;        

        AssignedResource assignedResource = GDMFSL_DataFactory.createAssignedResource(serviceAppointment.Id,serviceResource.Id);
        insert assignedResource;        

        Test.startTest();
            Database.executeBatch(new GDMFSL_DeadManCheckInFailure_Batch());
        Test.stopTest();

        System.debug('No meaningful way to assert the SMS message was sent');
    }

    @IsTest
    static void schedulableTest(){

        Account acct = new Account(Name='Test Account',Phone = '1234561234',BillingStreet = 'Anywhere',BillingCity = 'City',BillingState = 'Florida',BillingCountry = 'United States');
        insert acct;

        ServiceAppointment sa = GDMFSL_DataFactory.createServiceAppointment(acct.Id, 'Onsite');
        sa.ActualStartTime = System.now().addHours(-4);
        sa.GDMFSL_Dead_Man_Switch_Timer__c = 3;
        sa.GDMFSL_Last_Dead_Man_Switch__c = sa.ActualStartTime;
        insert sa;

        Test.startTest();

        GDMFSL_DeadManCheckInFailure_Batch theJob = new GDMFSL_DeadManCheckInFailure_Batch();
        String chron = '0 0 23 * * ?';

        System.schedule('Test Sched', chron, theJob);

        Test.stopTest();

        ServiceAppointment sa2 = [SELECT Id, AppointmentNumber, GDMFSL_Last_Dead_Man_Switch__c, GDMFSL_Dead_Man_Switch_Timer__c, FSL__InJeopardy__c, FSL__InJeopardyReason__c, ActualStartTime FROM ServiceAppointment];

        System.assertNotEquals(null, sa2.GDMFSL_Last_Dead_Man_Switch__c, 'GDMFSL_Last_Dead_Man_Switch__c was not set from scheduled batch run');
        System.assertEquals(false, sa2.FSL__InJeopardy__c, 'FSL__InJeopardy__c was set from scheduled batch run');
        System.assertEquals(null, sa2.FSL__InJeopardyReason__c, 'FSL__InJeopardyReason__c was set from scheduled batch run');

    }
}