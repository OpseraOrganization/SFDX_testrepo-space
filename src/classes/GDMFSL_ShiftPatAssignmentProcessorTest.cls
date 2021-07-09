@IsTest
private class GDMFSL_ShiftPatAssignmentProcessorTest {

    @TestSetup
    static void init() {
        //ST
        OperatingHours ohs = GDMFSL_DataFactory.createOperatingHour();
        insert ohs;

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('SPA Test', ohs.Id);
        insert st;

        Schema.Location aLocation = GDMFSL_DataFactory.createLocation('Campus', st.Id);
        insert aLocation;

        List<User> theUsers = new List<User>();
        theUsers.add(GDMFSL_DataFactory.createTestUser());
        theUsers.add(GDMFSL_DataFactory.createTestUser());
        theUsers.add(GDMFSL_DataFactory.createTestUser());
        theUsers.add(GDMFSL_DataFactory.createTestUser());
        insert theUsers;

        List<ServiceResource> theServResources = new List<ServiceResource>();

        ServiceResource sr1 = GDMFSL_DataFactory.createServiceResource(theUsers[0].Id, aLocation.Id);
        theServResources.add(sr1);

        ServiceResource sr2 = GDMFSL_DataFactory.createServiceResource(theUsers[1].Id, aLocation.Id);
        theServResources.add(sr2);

        ServiceResource sr3 = GDMFSL_DataFactory.createServiceResource(theUsers[2].Id, aLocation.Id);
        theServResources.add(sr3);

        ServiceResource sr4 = GDMFSL_DataFactory.createServiceResource(theUsers[3].Id, aLocation.Id);
        theServResources.add(sr4);

        insert theServResources;


        List<ServiceTerritoryMember> stMembers = new List<ServiceTerritoryMember>();

        ServiceTerritoryMember stm1 = GDMFSL_DataFactory.createServiceTerritoryMember(sr1.Id,st.Id);
        stm1.TerritoryType = 'P';
        stm1.OperatingHoursId=ohs.Id;
        stMembers.add(stm1);

        ServiceTerritoryMember stm2 = GDMFSL_DataFactory.createServiceTerritoryMember(sr2.Id,st.Id);
        stm2.TerritoryType = 'P';
        stm2.OperatingHoursId=ohs.Id;
        stMembers.add(stm2);

        ServiceTerritoryMember stm3 = GDMFSL_DataFactory.createServiceTerritoryMember(sr3.Id,st.Id);
        stm3.TerritoryType = 'P';
        stm3.EffectiveStartDate=system.today()-10;
        stm3.EffectiveEndDate=System.today()+10;
        stMembers.add(stm3);


        ServiceTerritoryMember stm4 = GDMFSL_DataFactory.createServiceTerritoryMember(sr4.Id,st.Id);
        stm4.TerritoryType = 'P';
        stMembers.add(stm4);

        insert stMembers;

        ShiftPattern theShiftPattern = GDMFSL_DataFactory.createShiftPattern('3 Day Shift Pattern', 4);
        insert theShiftPattern;

        ShiftTemplate theShiftTemplate = GDMFSL_DataFactory.createShiftTemplate('8 hr ShiftTemp');
        insert theShiftTemplate;

        List<ShiftPatternEntry> theSPEs = new List<ShiftPatternEntry>();
        theSPEs.add(GDMFSL_DataFactory.createShiftPatternEntry(1, theShiftPattern.Id, theShiftTemplate.Id));
        theSPEs.add(GDMFSL_DataFactory.createShiftPatternEntry(2, theShiftPattern.Id, theShiftTemplate.Id));
        theSPEs.add(GDMFSL_DataFactory.createShiftPatternEntry(3, theShiftPattern.Id, theShiftTemplate.Id));
        insert theSPEs;

    }

    @IsTest
    static void testgetRecSetFilterCrit() {

        List<RecordsetFilterCriteria> allrsfc = new List<RecordsetFilterCriteria>();

        allrsfc.add(new RecordsetFilterCriteria(Name = 'Test 1'));
        allrsfc.add(new RecordsetFilterCriteria(Name = 'Test 2'));
        allrsfc.add(new RecordsetFilterCriteria(Name = 'Test 3'));

        insert allrsfc;

        Set<String> namsToGet = new Set<String>{
                'Test 1', 'Test 3'
        };

        Map<String, RecordsetFilterCriteria> results = GDMFSL_ShiftPatternAssignmentProcessor.getRecordSetFilterCriteria(namsToGet);

        System.assertEquals(2, results.size(), 'getRecordSetFilterCriteria returned the wrong number of records');

        for (RecordsetFilterCriteria rsfc : results.values()) {

            System.assert(namsToGet.contains(rsfc.Name), 'getRecordSetFilterCriteria returned the wrong records');
        }

        Set<String> moreNamsToGet = new Set<String>{
                'Test 2'
        };

        results = GDMFSL_ShiftPatternAssignmentProcessor.getRecordSetFilterCriteria(moreNamsToGet);

        System.assertEquals(3, results.size(), 'getRecordSetFilterCriteria returned the wrong number of records on subsequent call');

        for (RecordsetFilterCriteria rsfc : results.values()) {

            System.assert(namsToGet.contains(rsfc.Name) || moreNamsToGet.contains(rsfc.Name), 'getRecordSetFilterCriteria returned the wrong records on subsequent call');
        }
    }

    @IsTest
    static void testGetShiftPatternRecords() {
        List<ShiftPattern> theShiftPatterns = [SELECT Id from ShiftPattern];
        Map<Id, ShiftPattern> mapShiftPatternsByIds = GDMFSL_ShiftPatternAssignmentProcessor.getShiftPatternRecords(new Set<Id>{
                theShiftPatterns[0].Id
        });
        System.assertEquals(theShiftPatterns.size(), mapShiftPatternsByIds.size(), 'The records found for Shift Pattern did not return 1 record of Shift Pattern');

        ShiftPattern sp1 = GDMFSL_DataFactory.createShiftPattern('Test Shift Pattern', 1);
        insert sp1;

        mapShiftPatternsByIds = GDMFSL_ShiftPatternAssignmentProcessor.getShiftPatternRecords(new Set<Id>{
                sp1.Id
        });

        System.assertEquals(2, mapShiftPatternsByIds.size(), 'The records found for Shift Pattern did not return 2 record of Shift Pattern');


    }

    @IsTest
    static void testFindShiftPattern() {

        List<ServiceResource> sr = [SELECT Id FROM ServiceResource];
        List<ServiceTerritory> st = [SELECT Id FROM ServiceTerritory];
        List<ShiftPattern> sp = [SELECT Id FROM ShiftPattern];
        List<Shift_Pattern_Assignment__c> theSPAs = new List<Shift_Pattern_Assignment__c>();
        System.debug('Pattern Assignment with Days to create shifts is equal to pattern length');
        theSPAs.add(GDMFSL_DataFactory.createShiftPatternAssign(sr[0].Id, null, sp[0].Id, null, system.today() + 3,system.today()));
        insert theSPAs;

        List<Shift> createdShifts = [SELECT Id,ServiceResourceId FROM Shift];

        System.assertEquals(3, createdShifts.size(), 'Number of shifts created after Service Pattern Assignment do not match');
        System.assertEquals(sr[0].Id, createdShifts[0].ServiceResourceId, 'Shift was not correctly created for the right resource');

        List<Shift_Pattern_Assignment__c> spa = [SELECT Status__c FROM Shift_Pattern_Assignment__c];

        System.assertEquals('Completed', spa[0].Status__c, 'The status od Shift Pattern Assignment was not set to Completed');


        sp[0].PatternLength = 3;
        update sp;

        Shift_Pattern_Assignment__c spa1 = GDMFSL_DataFactory.createShiftPatternAssign(sr[1].Id, st[0].Id, sp[0].Id, 3, null,System.today()+5);
        insert spa1;
        System.debug('Pattern Assignment with Scheduling Occurrence Count');
        List<Shift> theShifts = [SELECT Id,ServiceResourceId FROM Shift WHERE ServiceResourceId=  :sr[1].Id];
        List<Shift_Pattern_Assignment__c> spa2 = [SELECT Status__c FROM Shift_Pattern_Assignment__c where Service_Resource__c= :sr[1].Id];
        System.assertEquals(9, theShifts.size(), 'Number of shifts created after Service Pattern Assignment do not match');
        System.assertEquals(sr[1].Id, theShifts[0].ServiceResourceId, 'Shift was not correctly created for the right resource');
        System.assertEquals('Completed', spa2[0].Status__c, 'The status of Shift Pattern Assignment was not set to Completed');

        System.debug('Pattern Assignment with Days to create shifts is less than pattern length');
        Shift_Pattern_Assignment__c spa3 = GDMFSL_DataFactory.createShiftPatternAssign(sr[2].Id,null, sp[0].Id, null,System.today()+1 ,System.today());
        spa3.Recordset_Filter_Criteria__c='test';
        insert spa3;

        List<Shift> theShifts1 = [SELECT Id,ServiceResourceId FROM Shift WHERE ServiceResourceId=  :sr[2].Id];
        List<Shift_Pattern_Assignment__c> spa4 = [SELECT Status__c FROM Shift_Pattern_Assignment__c where Service_Resource__c= :sr[2].Id];
        System.assertEquals(2, theShifts1.size(), 'Number of shifts created after Service Pattern Assignment do not match');
        System.assertEquals(sr[2].Id, theShifts1[0].ServiceResourceId, 'Shift was not correctly created for the right resource');
        System.assertEquals('Completed', spa4[0].Status__c, 'The status od Shift Pattern Assignment was not set to Completed');


        Shift_Pattern_Assignment__c spa5 = GDMFSL_DataFactory.createShiftPatternAssign(sr[3].Id, st[0].Id, sp[0].Id, null,System.today()+6 ,System.today());
        insert spa5;

        List<Shift> theShifts2 = [SELECT Id,ServiceResourceId FROM Shift WHERE ServiceResourceId=  :sr[3].Id];
        List<Shift_Pattern_Assignment__c> spa6 = [SELECT Status__c FROM Shift_Pattern_Assignment__c WHERE Service_Resource__c= :sr[3].Id];
        System.assertEquals(6, theShifts2.size(), 'Number of shifts created after Service Pattern Assignment do not match');
        System.assertEquals(sr[3].Id, theShifts2[0].ServiceResourceId, 'Shift was not correctly created for the right resource');
        System.assertEquals('Completed', spa6[0].Status__c, 'The status od Shift Pattern Assignment was not set to Completed');

    }

    @IsTest
    static void testCreateShifts()
    {

        List<ServiceResource> sr = [SELECT Id FROM ServiceResource];
        List<ServiceTerritory> st = [SELECT Id FROM ServiceTerritory];
        List<ShiftPattern> sp = [SELECT Id FROM ShiftPattern];
        List<Shift_Pattern_Assignment__c> theSPAs = new List<Shift_Pattern_Assignment__c>();

        theSPAs.add(GDMFSL_DataFactory.createShiftPatternAssign(sr[0].Id, null, sp[0].Id, null, system.today() + 3,system.today()));
        theSPAs[0].Recordset_Filter_Criteria__c='Test';
        Set<String> recordSetFilterCriteriaStrings = new Set<String>();
        recordSetFilterCriteriaStrings.add(theSPAs[0].Recordset_Filter_Criteria__c);
        GDMFSL_ShiftPatternAssignmentProcessor.getRecordSetFilterCriteria(recordSetFilterCriteriaStrings);

        GDMFSL_ShiftPatternAssignmentProcessor.createShifts(theSPAs[0],0);

        List<Shift> createdShifts = [SELECT Id,ServiceResourceId FROM Shift];
        System.assertEquals(0,createdShifts.size(),'Shift should not have been created');
    }


    @IsTest
    static void skipProcessTest() {


        List<ServiceResource> sr = [SELECT Id FROM ServiceResource];
        List<ServiceTerritory> st = [SELECT Id FROM ServiceTerritory];
        List<ShiftPattern> sp = [SELECT Id FROM ShiftPattern];


        Skip_Automation_Process__c profileCustomSetting = new Skip_Automation_Process__c();
        profileCustomSetting.SetupOwnerId = UserInfo.getOrganizationId();
        profileCustomSetting.ByPass_Automation__c = true;
        insert profileCustomSetting;

        List<Shift_Pattern_Assignment__c> theSPAs = new List<Shift_Pattern_Assignment__c>();
        System.debug('Pattern Assignment with Days to create shifts is equal to pattern length');
        theSPAs.add(GDMFSL_DataFactory.createShiftPatternAssign(sr[0].Id, null, sp[0].Id, null, system.today() + 3,system.today()));
        insert theSPAs;

        List<Shift> createdShifts = [SELECT Id,ServiceResourceId FROM Shift];

        System.assertEquals(0, createdShifts.size(), 'Number of shifts created after Service Pattern Assignmenteven if skip process was true');

    }


}