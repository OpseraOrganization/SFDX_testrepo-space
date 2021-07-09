@IsTest
public class GDMFSL_EndOfDayNotification_BatchTest {

    @IsTest
    static void testSendSMSBatch(){
        OperatingHours theOpHours = GDMFSL_DataFactory.createOperatingHour();
        insert theOpHours;

        ServiceTerritory theServiceTerritory = GDMFSL_DataFactory.createServiceTerritory('EOD Test', theOpHours.Id);
        theServiceTerritory.GDMFSL_Standard_Workday_Duration__c = 450;
        insert theServiceTerritory;

        User u = GDMFSL_DataFactory.createTestUser();
        u.MobilePhone = '3135551212';
        insert u;

        Schema.Location aLocation = GDMFSL_DataFactory.createLocation('Campus',theServiceTerritory.Id);
        insert aLocation;

        ServiceResource theServRes = GDMFSL_DataFactory.createServiceResource(u.Id, aLocation.Id);
        theServRes.GDMFSL_Start_of_Shift__c = System.now().addMinutes(-425);
        insert theServRes;

        GDMFSL_Safe_and_Sound__c sas = new GDMFSL_Safe_and_Sound__c(GDMFSL_Service_Resource__c=theServRes.Id,GDMFSL_Start__c=System.now().addMinutes(-600));
        insert sas;

        ServiceTerritoryMember theSTM = GDMFSL_DataFactory.createServiceTerritoryMember(theServRes.Id,theServiceTerritory.Id);
        theSTM.TerritoryType = 'P';
        insert theSTM;

        Test.startTest();
            Database.executeBatch(new GDMFSL_EndOfDayNotification_Batch());
        Test.stopTest();

        System.debug('No meaningful way to assert the SMS message was sent');
    }

    @IsTest
    static void testSendSMS(){
        OperatingHours theOpHours = GDMFSL_DataFactory.createOperatingHour();
        insert theOpHours;

        ServiceTerritory theServiceTerritory = GDMFSL_DataFactory.createServiceTerritory('EODNotif Test', theOpHours.Id);
        theServiceTerritory.GDMFSL_Standard_Workday_Duration__c = 450;
        insert theServiceTerritory;

        User u = GDMFSL_DataFactory.createTestUser();
        u.MobilePhone = '3135551212';
        insert u;

        Schema.Location aLocation = GDMFSL_DataFactory.createLocation('Campus',theServiceTerritory.Id);
        insert aLocation;

        ServiceResource theServRes = GDMFSL_DataFactory.createServiceResource(u.Id, aLocation.Id);
        theServRes.GDMFSL_Start_of_Shift__c = System.now().addMinutes(-425);
        insert theServRes;

        GDMFSL_Safe_and_Sound__c sas = new GDMFSL_Safe_and_Sound__c(GDMFSL_Service_Resource__c=theServRes.Id,GDMFSL_Start__c=System.now().addMinutes(-600));
        insert sas;

        ServiceTerritoryMember theSTM = GDMFSL_DataFactory.createServiceTerritoryMember(theServRes.Id,theServiceTerritory.Id);
        theSTM.TerritoryType = 'P';
        insert theSTM;


        Test.startTest();

            List<ServiceResource> resourceList = [SELECT Id, RelatedRecordId, RelatedRecord.MobilePhone, RelatedRecord.Phone, GDMFSL_Start_of_Shift__c FROM ServiceResource WHERE GDMFSL_Start_of_Shift__c > :System.now().addHours(-18) ORDER BY GDMFSL_Start_of_Shift__c];
            List<GDMFSL_SMSMessageRecipient> results = GDMFSL_EndOfDayNotification_Batch.getSMSRecipients(resourceList);

        Test.stopTest();

        System.assertEquals(1, results.size(), 'Found an incorrect number of message recipients');
        System.assertEquals(u.Id, results[0].userId, 'Founda n incorrect user as GDMFSL_SMSMessageRecipient');
        System.assertEquals('GDMFSL_End_of_Day_Prompt', results[0].messagingTempateName, 'Incorrect SMS Template name');
        System.assertEquals('3135551212', results[0].phone, ' Phone number of GDMFSL_SMSMessageRecipient does not match');
    }

    @IsTest
    static void testDoNotSendSMS(){
        OperatingHours theOpHours = GDMFSL_DataFactory.createOperatingHour();
        insert theOpHours;

        ServiceTerritory theServiceTerritory = GDMFSL_DataFactory.createServiceTerritory('EOD Notifica Test', theOpHours.Id);
        theServiceTerritory.GDMFSL_Standard_Workday_Duration__c = 450;
        insert theServiceTerritory;

        User u = GDMFSL_DataFactory.createTestUser();
        u.MobilePhone = '3135551212';
        insert u;

        Schema.Location aLocation = GDMFSL_DataFactory.createLocation('Campus',theServiceTerritory.Id);
        insert aLocation;

        ServiceResource theServRes = GDMFSL_DataFactory.createServiceResource(u.Id, aLocation.Id);
        theServRes.GDMFSL_Start_of_Shift__c = System.now().addMinutes(-415);
        insert theServRes;

        GDMFSL_Safe_and_Sound__c sas = new GDMFSL_Safe_and_Sound__c(GDMFSL_Service_Resource__c=theServRes.Id,GDMFSL_Start__c=System.now().addMinutes(-600));
        insert sas;

        ServiceTerritoryMember theSTM = GDMFSL_DataFactory.createServiceTerritoryMember(theServRes.Id,theServiceTerritory.Id);
        theSTM.TerritoryType = 'P';
        insert theSTM;


        Test.startTest();

            List<ServiceResource> resourceList = [SELECT Id, RelatedRecordId, GDMFSL_Start_of_Shift__c FROM ServiceResource WHERE GDMFSL_Start_of_Shift__c > :System.now().addHours(-18) ORDER BY GDMFSL_Start_of_Shift__c];
            List<GDMFSL_SMSMessageRecipient> results = GDMFSL_EndOfDayNotification_Batch.getSMSRecipients(resourceList);

        Test.stopTest();

        System.assertEquals(0, results.size(), 'Incorrectly found GDMFSL_SMSMessageRecipients to send');
    }

    @IsTest
    static void schedulableTest(){

        OperatingHours theOpHours = GDMFSL_DataFactory.createOperatingHour();
        insert theOpHours;

        ServiceTerritory theServiceTerritory = GDMFSL_DataFactory.createServiceTerritory('EOD Test', theOpHours.Id);
        theServiceTerritory.GDMFSL_Standard_Workday_Duration__c = 450;
        insert theServiceTerritory;

        User u = GDMFSL_DataFactory.createTestUser();
        u.MobilePhone = '3135551212';
        insert u;

        Schema.Location aLocation = GDMFSL_DataFactory.createLocation('Campus',theServiceTerritory.Id);
        insert aLocation;

        ServiceResource theServRes = GDMFSL_DataFactory.createServiceResource(u.Id, aLocation.Id);
        theServRes.GDMFSL_Start_of_Shift__c = System.now().addMinutes(-425);
        insert theServRes;

        GDMFSL_Safe_and_Sound__c sas = new GDMFSL_Safe_and_Sound__c(GDMFSL_Service_Resource__c=theServRes.Id,GDMFSL_Start__c=System.now().addMinutes(-600));
        insert sas;

        ServiceTerritoryMember theSTM = GDMFSL_DataFactory.createServiceTerritoryMember(theServRes.Id,theServiceTerritory.Id);
        theSTM.TerritoryType = 'P';
        insert theSTM;

        Test.startTest();

        GDMFSL_EndOfDayNotification_Batch theJob = new GDMFSL_EndOfDayNotification_Batch();
        String chron = '0 0 23 * * ?';

        System.schedule('Test Sched', chron, theJob);

        Test.stopTest();

        System.debug('No meaningful way to assert the SMS message was sent');

    }
}