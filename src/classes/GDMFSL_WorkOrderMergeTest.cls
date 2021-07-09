/**
 * Name       :    GDMFSL_WorkOrderMergeTest
 * Purpose    :    Test class for WorkOrder merge utility
 * --------------------------------------------------------------------------
 * Developer               Date          Description
 * --------------------------------------------------------------------------
 * JMay                  2020-Nov-30    Created
 **/
@IsTest
private class GDMFSL_WorkOrderMergeTest {

    @TestSetup
    static void init() {

        Schema.Location vanLoc = GDMFSL_DataFactory.createLocation('Van', null, null);
        vanLoc.TimeZone = 'America/New_York';
        insert vanLoc;

        WorkType wType = GDMFSL_DataFactory.createWorkType('Test', 1);
        insert wType;

        Account theAcct = GDMFSL_DataFactory.createTestAccount('MergeTest');
        Id stdAcctRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Standard').getRecordTypeId();
        theAcct.RecordTypeId = stdAcctRecTypeId;
        theAcct.Source_System_Types__c = 'ShipTo';
        insert theAcct;

        MaintenancePlan theMP = GDMFSL_DataFactory.createMaintenancePlan(wType.Id);
        theMP.LocationId = vanLoc.Id;
        theMP.GDMFSL_Requires_Assistant__c = false;
        theMP.GDMFSL_Multi_day_Asset_Maintenance__c = false;
        insert theMP;

        ServiceContract theSC = GDMFSL_DataFactory.createServiceContract('Main SC', theAcct.Id);
        insert theSC;

        List<WorkOrder> wosToInsert = new List<WorkOrder>();

        WorkOrder theWO = GDMFSL_DataFactory.createWorkOrder(wType.Id, theAcct.Id, vanLoc.Id, Datetime.now(), Datetime.now().addDays(5));
        theWO.MaintenancePlanId = theMP.Id;
        theWO.ServiceContractId = theSC.Id;
        theWO.GDMFSL_Ship_To_Account__c = theAcct.Id;
        theWO.SuggestedMaintenanceDate = Date.today();
        theWO.GDMFSL_Created_by_WO_Merge_Process__c = true;
        wosToInsert.add(theWO);

        WorkOrder theWO1 = GDMFSL_DataFactory.createWorkOrder(wType.Id, theAcct.Id, vanLoc.Id, Datetime.now(), Datetime.now().addDays(5));
        theWO1.MaintenancePlanId = theMP.Id;
        theWO1.ServiceContractId = theSC.Id;
        theWO1.GDMFSL_Ship_To_Account__c = theAcct.Id;
        theWO1.SuggestedMaintenanceDate = Date.today();
        theWO1.GDMFSL_Created_by_WO_Merge_Process__c = true;
        wosToInsert.add(theWO1);

        System.debug('TEST init - About to insert WOs');
        insert wosToInsert;

        List<Product2> theProds = GDMFSL_DataFactory.createProducts('Test', 1);
        insert theProds;

        List<Asset> theAssets = GDMFSL_DataFactory.createAssets('Test', theProds[0].Id, theAcct.Id, 1);
        insert theAssets;

        List<WorkOrderLineItem> wolisToUse = new List<WorkOrderLineItem>();

        WorkOrderLineItem woli1 = GDMFSL_DataFactory.createWorkOrderLineItem(wType.Id, theWO.Id, theAssets[0].Id);
        wolisToUse.add(woli1);
        WorkOrderLineItem woli2 = GDMFSL_DataFactory.createWorkOrderLineItem(wType.Id, theWO1.Id, theAssets[0].Id);
        wolisToUse.add(woli2);

        insert wolisToUse;
    }


    @IsTest
    static void testWorkOrderMerge() {

        List<WorkOrder> wosToMerge = new List<WorkOrder>([SELECT Id FROM WorkOrder]);

        GDMFSL_WorkOrderMerge merger = new GDMFSL_WorkOrderMerge();
        merger.deleteOrigWOs = true;

        for (WorkOrder aWO : wosToMerge){
            merger.woIdsToTestWith.add(aWO.Id);
        }

        Test.startTest();

        System.debug('TEST: ');

        Database.executeBatch(merger);

        Test.stopTest();

        System.debug('See if only 1 WO remains');
        List<WorkOrder> allWOs = new List<WorkOrder>([SELECT Id FROM WorkOrder]);

        System.assertEquals(1, allWOs.size(), 'WorkOrder merge did not result in just 1 WorkOrder');

    }

    @IsTest
    static void testDefaultSystemID(){

        String sysIDToUse;
        String sysIDReturned = GDMFSL_WorkOrderMerge.getSystemIDToUse(sysIDToUse);

        System.assertEquals(GDMFSL_WorkOrderMerge.DEFAULTSYSTEMID, sysIDReturned, 'System ID default is not correct');

    }

    @IsTest
    static void testgetSystemID(){

        String sysIDToUse = 'Hello';
        String sysIDReturned = GDMFSL_WorkOrderMerge.getSystemIDToUse(sysIDToUse);

        System.assertEquals(sysIDToUse, sysIDReturned, 'get System ID did not return specified System ID');

    }

    @IsTest
    static void createWOSkillKeysTest(){

        WorkOrder theWO = [SELECT Id FROM WorkOrder LIMIT 1];

        Map<Id, List<SkillRequirement>> woIDToSkillRequirements = new Map<Id, List<SkillRequirement>>();
        woIDToSkillRequirements.put(theWO.Id, new List<SkillRequirement>());


        List<Skill> theSkills = [SELECT Id FROM Skill LIMIT 2];

        SkillRequirement sr1 = new SkillRequirement(
                RelatedRecordId = theWO.Id,
                SkillId = theSkills[0].Id,
                SkillLevel = 1
        );
        woIDToSkillRequirements.get(theWO.Id).add(sr1);

        SkillRequirement sr2 = new SkillRequirement(
                RelatedRecordId = theWO.Id,
                SkillId = theSkills[1].Id,
                SkillLevel = 2
        );
        woIDToSkillRequirements.get(theWO.Id).add(sr2);

        insert woIDToSkillRequirements.get(theWO.Id);


        System.debug('TEST start');
        Map<Id, String> woToSkillKey = GDMFSL_WorkOrderMerge.createWOIdSkillKeys(woIDToSkillRequirements);


        System.assertEquals(1, woToSkillKey.size(), 'Returned map does not have the correct number of key entries');
        System.assertEquals(true, woToSkillKey.containsKey(theWO.Id), 'Returned map key is not the WorkOrder Id');

        String expectedSkillKEy = sr1.SkillId + GDMFSL_WorkOrderMerge.KEYSEP + sr2.SkillId + GDMFSL_WorkOrderMerge.KEYSEP;

        System.assertEquals(expectedSkillKEy, woToSkillKey.get(theWO.Id), 'Skill Key is not correct');
    }

    @IsTest
    static void createWOSkillKeyDefaultTest(){

        WorkOrder theWO = [SELECT Id FROM WorkOrder LIMIT 1];

        Map<Id, List<SkillRequirement>> woIDToSkillRequirements = new Map<Id, List<SkillRequirement>>();
        woIDToSkillRequirements.put(theWO.Id, new List<SkillRequirement>());


        System.debug('TEST start');
        Map<Id, String> woToSkillKey = GDMFSL_WorkOrderMerge.createWOIdSkillKeys(woIDToSkillRequirements);


        System.assertEquals(1, woToSkillKey.size(), 'Returned map does not have the correct number of key entries');
        System.assertEquals(true, woToSkillKey.containsKey(theWO.Id), 'Returned map key is not the WorkOrder Id');
        System.assertEquals(GDMFSL_WorkOrderMerge.DEFAULTSKILLKEY, woToSkillKey.get(theWO.Id), 'Default Skill Key is not correct');
    }

    @IsTest
    private static void workOrderMergeSchedulableNoMergeTest(){

        Test.startTest();

        System.debug('TEST: start');

        GDMFSL_WorkOrderMerge merger = new GDMFSL_WorkOrderMerge();
        System.schedule('WorkOrderMerge Sched', '0 0 23 * * ?', merger);

        Test.stopTest();

        System.debug('See if only 1 WO remains after Schedulable job');
        List<WorkOrder> allWOs = new List<WorkOrder>([SELECT Id FROM WorkOrder]);
        System.assertEquals(2, allWOs.size(), 'Scheduled WorkOrder merged WOs that should not have been');

    }


}