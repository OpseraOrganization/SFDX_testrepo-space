@IsTest
private class GDMFSL_SkillRequirementProcessorTest {

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
    static void testBehavior(){
        WorkOrder theWO = [SELECT Id FROM WorkOrder LIMIT 1];
        List<Skill> theSkills = [SELECT Id FROM Skill LIMIT 2];

        SkillRequirement sr = new SkillRequirement(RelatedRecordId = theWO.Id, SkillId = theSkills[0].Id, SkillLevel = 1);        
        insert sr;

        Test.startTest();
            Set<Id> srIds = new Set<Id>{sr.Id};
            Map<Id, SkillRequirement> mapSkillRequirement = GDMFSL_SkillRequirementProcessor.getRecords(srIds);

            System.assertEquals(1, mapSkillRequirement.size(), 'Number of SkillRequirement Records returned are not correct');


            SkillRequirement srNew = new SkillRequirement(RelatedRecordId = theWO.Id, SkillId = theSkills[1].Id, SkillLevel = 1);        
            insert srNew;

            srIds.clear();
            srIds.add(sr.Id);
            srIds.add(srNew.Id);

            Map<Id, SkillRequirement> newmapSkillRequirement = GDMFSL_SkillRequirementProcessor.getRecords(srIds);
            System.assertEquals(2, newmapSkillRequirement.size(), 'Number of SkillRequirement Records returned in second attempt are not correct');
        Test.stopTest();        
    }


    @IsTest
    static void testgetRecordsForParentId(){

        WorkOrder theWO = [SELECT Id FROM WorkOrder LIMIT 1];
        List<Skill> theSkills = [SELECT Id FROM Skill LIMIT 2];
        
        SkillRequirement srNew = new SkillRequirement(RelatedRecordId = theWO.Id, SkillId = theSkills[0].Id, SkillLevel = 1);        
        insert srNew;

        Map<Id,List<SkillRequirement>> result;

        Test.startTest();
            result = GDMFSL_SkillRequirementProcessor.getRecordsForParentId(new Set<Id>{theWO.Id});
        Test.stopTest();

        System.assertEquals(1, result.keyset().size(),'Did not return the correct number of SkillRequirement records');
        System.assertEquals(true, result.containsKey(theWO.Id),'Did not return records for the specified Work Order');
        System.assertEquals(1, result.get(theWO.Id).size(),'Did not return the expected SkillRequirement record');
        System.assertEquals(srNew.Id, result.get(theWO.Id)[0].Id,'Did not return the expected SkillRequirement record');
    }

    @IsTest
    static void testgetRecordsForSkillLevels(){

        WorkOrder theWO = [SELECT Id FROM WorkOrder LIMIT 1];
        List<Skill> theSkills = [SELECT Id FROM Skill LIMIT 2];
        
        SkillRequirement srNew = new SkillRequirement(RelatedRecordId = theWO.Id, SkillId = theSkills[0].Id, SkillLevel = 3);        
        insert srNew;

        Map<Id,List<SkillRequirement>> woSkillRequirementsMap;
        Map<Id, Map<Id, Decimal>> result;

        Test.startTest();
            woSkillRequirementsMap = GDMFSL_SkillRequirementProcessor.getRecordsForParentId(new Set<Id>{theWO.Id});
            result = GDMFSL_SkillRequirementProcessor.getParentRecordIdSkillLevels(woSkillRequirementsMap);
        Test.stopTest();

        System.assertEquals(1, result.keyset().size(),'Did not return the correct number of SkillRequirement records');
        System.assertEquals(true, result.containsKey(theWO.Id),'Did not return records for the specified Work Order');
        System.assertEquals(1, result.get(theWO.Id).size(),'Did not return the expected SkillRequirement record');
        System.assertEquals(true, result.get(theWO.Id).containsKey(theSkills[0].Id),'Did not return the expected Skill');
        System.assertEquals(3, result.get(theWO.Id).get(theSkills[0].Id),'Did not return the expected Skill Level');
    }    

}