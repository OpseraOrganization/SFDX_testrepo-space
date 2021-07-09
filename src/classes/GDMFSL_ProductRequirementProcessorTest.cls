@IsTest
private class GDMFSL_ProductRequirementProcessorTest {

    @IsTest
    static void getRecordsTest(){

        OperatingHours theOpHours = GDMFSL_DataFactory.createOperatingHour();
        insert theOpHours;

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('ResPref Test', theOpHours.Id);
        insert st;

        Schema.Location theLoc = GDMFSL_DataFactory.createLocation('Campus', st.Id, theOpHours.Id);
        Schema.Location location1 = GDMFSL_DataFactory.createLocation('Campus', null, theOpHours.Id);
        List<Schema.Location > lstlocation = new List<Schema.Location >();
        lstlocation.add(theLoc);
        lstlocation.add(location1);
        insert lstlocation;

        List<WorkType> lstworkType = new List<WorkType>();
        lstworkType.addAll(GDMFSL_DataFactory.createWorkTypes('PMWorkType', 1, 30, GDMFSL_WorkTypeProcessor.WORKTYPECATEGORY_PM, 'High'));
        lstworkType.addAll(GDMFSL_DataFactory.createWorkTypes('BFWorkType', 1, 30, GDMFSL_WorkTypeProcessor.WORKTYPECATEGORY_BF, 'Critical'));
        insert lstworkType;

        Account ac = GDMFSL_DataFactory.createTestAccount('TestAccount');
        insert ac;

        List<Product2> p = GDMFSL_DataFactory.createProducts('Test Product',2);
        insert p;

        List<Asset> a = GDMFSL_DataFactory.createAssets('Test Asset',p[0].Id,ac.Id,1);
        insert a;

        Case c = GDMFSL_DataFactory.createCase('North America', a[0].Id);
        c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        c.Origin = 'Community';
        c.GDMFSL_On_Demand__c = true;
        insert c;

        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(lstworkType[0].Id, ac.Id, lstlocation[0].Id, System.now(),System.now());
        wo.GDMFSL_PO_Number__c = '123';
        wo.CaseId = c.Id;
        insert wo;

        List<ProductRequired> prToInsert = new List<ProductRequired>();

        ProductRequired pr = new ProductRequired(Product2Id=p[0].Id,ParentRecordId=wo.Id);
        prToInsert.add(pr);
        ProductRequired prNew = new ProductRequired(Product2Id=p[1].Id,ParentRecordId=wo.Id);
        prToInsert.add(prNew);

        insert prToInsert;

        Test.startTest();

        Map<Id, ProductRequired> mapProductRequired = GDMFSL_ProductRequirementProcessor.getRecords(new Set<Id>{pr.Id});

        System.assertEquals(1, mapProductRequired.size(), 'Number of ProductRequired Records returned');
        System.assertEquals(pr.Id, mapProductRequired.get(pr.Id).Id, 'Wrong ProductRequired record returned');

        Map<Id, ProductRequired> newmapProductRequired = GDMFSL_ProductRequirementProcessor.getRecords(new Set<Id>{prNew.Id});

        System.assertEquals(2, newmapProductRequired.size(), 'Number of ProductRequired Records returned in second attempt');
        System.assertEquals(pr.Id, mapProductRequired.get(pr.Id).Id, 'Wrong original ProductRequired record returned in second attempt');
        System.assertEquals(prNew.Id, mapProductRequired.get(prNew.Id).Id, 'Wrong subsequent ProductRequired record returned in second attempt');

        Test.stopTest();
    }

    @IsTest
    static void testGetRecordsForParentId() {

        OperatingHours theOpHours = GDMFSL_DataFactory.createOperatingHour();
        insert theOpHours;

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('ResPref Test', theOpHours.Id);
        insert st;

        Schema.Location theLoc = GDMFSL_DataFactory.createLocation('Campus', st.Id, theOpHours.Id);
        Schema.Location location1 = GDMFSL_DataFactory.createLocation('Campus', null, theOpHours.Id);
        List<Schema.Location > lstlocation = new List<Schema.Location >();
        lstlocation.add(theLoc);
        lstlocation.add(location1);
        insert lstlocation;

        List<WorkType> lstworkType = new List<WorkType>();
        lstworkType.addAll(GDMFSL_DataFactory.createWorkTypes('PMWorkType', 1, 30, GDMFSL_WorkTypeProcessor.WORKTYPECATEGORY_PM, 'High'));
        lstworkType.addAll(GDMFSL_DataFactory.createWorkTypes('BFWorkType', 1, 30, GDMFSL_WorkTypeProcessor.WORKTYPECATEGORY_BF, 'Critical'));
        insert lstworkType;

        Account ac = GDMFSL_DataFactory.createTestAccount('TestAccount');
        insert ac;

        List<Product2> p = GDMFSL_DataFactory.createProducts('Test Product',1);
        insert p;

        List<Asset> a = GDMFSL_DataFactory.createAssets('Test Asset',p[0].Id,ac.Id,1);
        insert a;

        Case c = GDMFSL_DataFactory.createCase('North America', a[0].Id);
        c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        c.Origin = 'Community';
        c.GDMFSL_On_Demand__c = true;
        insert c;

        List<WorkOrder> wosToInsert = new List<WorkOrder>();

        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(lstworkType[0].Id, ac.Id, lstlocation[0].Id, System.now(),System.now());
        wo.GDMFSL_PO_Number__c = '123';
        wo.CaseId = c.Id;
        wosToInsert.add(wo);

        WorkOrder wo2 = GDMFSL_DataFactory.createWorkOrder(lstworkType[0].Id, ac.Id, lstlocation[0].Id, System.now(),System.now());
        wo2.GDMFSL_PO_Number__c = '123';
        wo2.CaseId = c.Id;
        wosToInsert.add(wo2);

        insert wosToInsert;

        List<ProductRequired> prsToInsert = new List<ProductRequired>();

        ProductRequired pr = new ProductRequired(Product2Id = p[0].Id, ParentRecordId = wo.Id);
        prsToInsert.add(pr);
        ProductRequired pr2 = new ProductRequired(Product2Id = p[0].Id, ParentRecordId = wo2.Id);
        prsToInsert.add(pr2);

        insert prsToInsert;


        Test.startTest();

        Map<Id, List<ProductRequired>> result = GDMFSL_ProductRequirementProcessor.getRecordsForParentId(new Set<Id>{wo.Id});

        System.assertEquals(1, result.size(), 'getRecordsForParentId() returned the wrong number of ParentRecord Ids');
        System.assertEquals(wo.Id, result.get(wo.Id)[0].ParentRecordId,'getRecordsForParentId() returned ProdRequired records for the wrong Parent ID');
        System.assertEquals(pr.Id, result.get(wo.Id)[0].Id,'getRecordsForParentId() returned the wrong ProductRequired record');
        System.assertEquals(1, result.get(wo.Id).size(),'getRecordsForParentId() returned the wrong number of ProdRequired records for the specified Parent ID');

        result = GDMFSL_ProductRequirementProcessor.getRecordsForParentId(new Set<Id>{wo2.Id});

        System.assertEquals(2, result.size(), 'getRecordsForParentId() returned the wrong number of ParentRecord Ids for the subsequent call');
        System.assertEquals(wo2.Id, result.get(wo2.Id)[0].ParentRecordId,'getRecordsForParentId() returned ProdRequired records for the wrong Parent ID on the subsequent call');
        System.assertEquals(pr2.Id, result.get(wo2.Id)[0].Id,'getRecordsForParentId() returned the wrong ProductRequired record on the subsequent call');
        System.assertEquals(1, result.get(wo2.Id).size(),'getRecordsForParentId() returned the wrong number of ProdRequired records for the specified Parent ID on the subsequent call');

        Test.stopTest();

    }
}