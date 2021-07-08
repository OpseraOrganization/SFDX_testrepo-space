@IsTest
private class GDMFSL_OnDemandAssignmentProcessorTest {

    @TestSetup
    static void init() {

        Account theAccount = GDMFSL_DataFactory.createTestAccount('TestAcc');
        insert theAccount;

        OperatingHours theOpHours = GDMFSL_DataFactory.createOperatingHour();
        insert theOpHours;

        List<ServiceTerritory> servTerrs = new List<ServiceTerritory>();
        servTerrs.add(GDMFSL_DataFactory.createServiceTerritory('ServAppt Test', theOpHours.Id));
        servTerrs.add(GDMFSL_DataFactory.createServiceTerritory('ServAppt Test 2', theOpHours.Id));
        insert servTerrs;

        OperatingHours theOpHrs = GDMFSL_DataFactory.createOperatingHour();
        insert theOpHrs;

        List<Schema.Location > theLocs = new List<Schema.Location>();
        theLocs.add(GDMFSL_DataFactory.createLocation('Campus', servTerrs[0].Id, theOpHrs.Id));
        theLocs.add(GDMFSL_DataFactory.createLocation('CampusA', null, theOpHrs.Id));
        insert theLocs;

        List<User> theUsers = new List<User>();
        theUsers.add(GDMFSL_DataFactory.createTestUser());
        theUsers.add(GDMFSL_DataFactory.createTestUser());
        insert theUsers;

        List<ServiceResource> theServRes = new List<ServiceResource>();
        theServRes.add(GDMFSL_DataFactory.createServiceResource(theUsers[0].Id, theLocs[0].Id));
        theServRes.add(GDMFSL_DataFactory.createServiceResource(theUsers[1].Id, theLocs[1].Id));
        insert theServRes;
    }

    @IsTest
    static void getRecordsByServTerrIdTest() {

        List<GDMFSL_On_Demand_Assignment__c> theOnDems = new List<GDMFSL_On_Demand_Assignment__c>();

        List<ServiceTerritory> theServTerrs = new List<ServiceTerritory>([SELECT Id FROM ServiceTerritory]);
        List<ServiceResource> theServRes = new List<ServiceResource>([SELECT Id FROM ServiceResource]);

        theOnDems.add(new GDMFSL_On_Demand_Assignment__c(
                GDMFSL_Start_Date_Time__c = Datetime.now().addMinutes(-900),
                GDMFSL_End_Date_Time__c = Datetime.now().addMinutes(900),
                GDMFSL_Service_Territory__c = theServTerrs[0].Id,
                GDMFSL_Service_Resource__c = theServRes[0].Id));

        theOnDems.add(new GDMFSL_On_Demand_Assignment__c(
                GDMFSL_Start_Date_Time__c = Datetime.now().addMinutes(-900),
                GDMFSL_End_Date_Time__c = Datetime.now().addMinutes(900),
                GDMFSL_Service_Territory__c = theServTerrs[0].Id,
                GDMFSL_Service_Resource__c = theServRes[1].Id));

        theOnDems.add(new GDMFSL_On_Demand_Assignment__c(
                GDMFSL_Start_Date_Time__c = Datetime.now().addMinutes(-900),
                GDMFSL_End_Date_Time__c = Datetime.now().addMinutes(900),
                GDMFSL_Service_Territory__c = theServTerrs[1].Id,
                GDMFSL_Service_Resource__c = theServRes[0].Id));

        theOnDems.add(new GDMFSL_On_Demand_Assignment__c(
                GDMFSL_Start_Date_Time__c = Datetime.now().addMinutes(-900),
                GDMFSL_End_Date_Time__c = Datetime.now().addMinutes(900),
                GDMFSL_Service_Territory__c = theServTerrs[1].Id,
                GDMFSL_Service_Resource__c = theServRes[1].Id));


        insert theOnDems;

        Test.startTest();

        Set<Id> servTerrIds = new Set<Id>{theServTerrs[0].Id};

        Map<Id, List<GDMFSL_On_Demand_Assignment__c>> foundRecs = GDMFSL_OnDemandAssignmentProcessor.getRecordsByTerritoryId(servTerrIds);

        System.assertEquals(1, foundRecs.size(), 'getRecordsByTerritoryId() returned wrong number of ServTerritory ID keys');
        System.assertEquals(2, foundRecs.get(theServTerrs[0].Id).size(), 'getRecordsByTerritoryId() returned wrong number of ServTerritory ID values');

        servTerrIds.clear();
        servTerrIds.add(theServTerrs[1].Id);

        foundRecs = GDMFSL_OnDemandAssignmentProcessor.getRecordsByTerritoryId(servTerrIds);

        System.assertEquals(2, foundRecs.size(), 'getRecordsByTerritoryId() did not add new ServTerritory ID on subsequent call');
        System.assertEquals(2, foundRecs.get(theServTerrs[0].Id).size(), 'getRecordsByTerritoryId() returned wrong number of ServTerritory ID values for original ID');
        System.assertEquals(2, foundRecs.get(theServTerrs[1].Id).size(), 'getRecordsByTerritoryId() returned wrong number of ServTerritory ID values for subsequent ID');


    }
}