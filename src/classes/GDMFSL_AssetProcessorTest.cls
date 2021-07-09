/*******************************************************************************************
Name       :    GDMFSL_AssetProcessorTest
Purpose    :    Test class for GDMFSL_AssetProcessor.
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
Udbhav                  2020-Sep-14    Created
**********************************************************************************************/
@IsTest
private class GDMFSL_AssetProcessorTest {

    public static Integer numberOfProducts      = 2;
    public static Integer numberOfAssets        = 3;
    public static Integer numberOfMainTemplates = 5;
    public static Integer numberOfAMF           = 10;

    @TestSetup
    static void testData() {
        List<Asset> assets = new List<Asset>();
        List<GDMFSL_Asset_Maintenance_Frequency__c> assetMaintenances = new List<GDMFSL_Asset_Maintenance_Frequency__c>();
        List<GDMFSL_Maintenance_Template__c> productMaintTemplates = new List<GDMFSL_Maintenance_Template__c>();

        Skip_Automation_Process__c profileCustomSetting = GDMFSL_DataFactory.createProfileCustomSetting(false);
        insert profileCustomSetting;

        Account account = GDMFSL_DataFactory.createTestAccount('TestAcc');
        insert account;

        OperatingHours operatingHours = GDMFSL_DataFactory.createOperatingHour();
        insert operatingHours;
        System.debug('operatingHours  Inserted : ' + operatingHours);

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('Asset Trigger Test', operatingHours.Id);
        insert st;
        System.debug('ServiceTerritory Inserted : ' + st);

        Schema.Location location = GDMFSL_DataFactory.createLocation('Campus', st.Id, operatingHours.Id);
        Schema.Location location1 = GDMFSL_DataFactory.createLocation('Campus',null, operatingHours.Id);
        List<Schema.Location > lstlocation = new List<Schema.Location >();
        lstlocation.add(location);
        lstlocation.add(location1);
        insert lstlocation;
        System.debug('location Inserted : ' + location);

        List<Product2> products = GDMFSL_DataFactory.createProducts('TestFSLProds', numberOfProducts);
        insert products;

        List<WorkType> workTypes = GDMFSL_DataFactory.createWorkTypes('TestWorktype', 1, 30);

        for (Product2 product2 : products) {
            assets.addAll(GDMFSL_DataFactory.createAssets('TestFSLAsset', product2.Id, account.Id, numberOfAssets, lstlocation[0].Id));
        }
        insert assets;

        for (Asset asset : assets) {
            productMaintTemplates.addAll(GDMFSL_DataFactory.createCompleteMaintTemplates('Testplates',
                    asset.Product2Id, workTypes[0].Id, numberOfMainTemplates));
        }
        insert productMaintTemplates;

        for (Asset asset: assets) {
            assetMaintenances.addAll(GDMFSL_DataFactory.createAssetMaintenances(asset.Id, numberOfAMF));
        }
        insert assetMaintenances;
    }


    @IsTest
    static void testBehavior() {

        Account ac = GDMFSL_DataFactory.createTestAccount('TestAccount');
        insert ac;
        System.debug('Account Inserted : ' + ac);

        OperatingHours operatingHours = GDMFSL_DataFactory.createOperatingHour();
        insert operatingHours;
        System.debug('operatingHours  Inserted : ' + operatingHours);

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('Asset Test', operatingHours.Id);
        insert st;
        System.debug('ServiceTerritory Inserted : ' + st);

        Schema.Location location = GDMFSL_DataFactory.createLocation('Campus', st.Id, operatingHours.Id);
        Schema.Location location1 = GDMFSL_DataFactory.createLocation('Campus',null, operatingHours.Id);
        List<Schema.Location > lstlocation = new List<Schema.Location >();
        lstlocation.add(location);
        lstlocation.add(location1);
        insert lstlocation;
        System.debug('location Inserted : ' + location);

        List<Product2> lstproduct = GDMFSL_DataFactory.createProducts('TestProduct', 1);
        insert lstproduct;
        System.debug('Product2 Inserted : ' + lstproduct);

        List<Asset> lstasset = GDMFSL_DataFactory.createAssets('TestAsset', lstproduct[0].Id, ac.Id, 1, lstlocation[0].Id);
        insert lstasset;
        System.debug('Asset Inserted : ' + lstasset);

        Test.startTest();

        Set<Id> assetIds = new Set<Id>();
        for (Asset asset : lstasset) {
            assetIds.add(asset.Id);
        }
        Map<Id, Asset> mapAsset = GDMFSL_AssetProcessor.getRecords(assetIds);

        System.assertEquals(1, mapAsset.size(), 'Did not return a Single Asset Record as expected');

        List<Asset> assetnew = GDMFSL_DataFactory.createAssets('TestAsset1', lstproduct[0].Id, ac.Id, 1, lstlocation[0].Id);

        insert assetnew;
        lstasset.addAll(assetnew);
        System.debug('Complete list of Assets : '+lstasset);

        for (Asset a : lstasset) {
            if (!assetIds.contains(a.Id)) {
                assetIds.add(a.Id);
            }

        }
        Map<Id, Asset> newmapAsset = GDMFSL_AssetProcessor.getRecords(assetIds);
        System.assertEquals(2, newmapAsset.size(), 'Did not return  Asset Record as expected');
        Test.stopTest();

    }

    @IsTest
    static void testInsert() {
        Test.startTest();
        List<Product2> testProducts = [SELECT Id, Name FROM Product2];
        List<Asset> testAssets = [SELECT Id, Name, Product2Id, AccountId FROM Asset WHERE Product2Id =: testProducts];
        List<GDMFSL_Maintenance_Template__c> testProductMaintTemplates = [SELECT Id, Name, GDMFSL_Product__c
        FROM GDMFSL_Maintenance_Template__c WHERE GDMFSL_Product__c =: testProducts];
        List<GDMFSL_Asset_Maintenance_Frequency__c> testAMFs = [SELECT Id, Name, GDMFSL_Asset__c
        FROM GDMFSL_Asset_Maintenance_Frequency__c WHERE GDMFSL_Asset__c =: testAssets];
        Test.stopTest();
        System.assert(testProducts.size() == numberOfProducts, 'testProducts is empty');
        System.assert(testAssets.size() == (numberOfProducts * numberOfAssets), 'All assets are not created equal');
        System.assert(testProductMaintTemplates.size() == numberOfProducts * numberOfAssets * numberOfMainTemplates,
                'Actual ProductMaintTemplates size != (numberOfProducts * numberOfAssets * numberOfMainTemplates)');
        System.assert(testAMFs.size() == numberOfProducts * numberOfAssets * numberOfAMF,
                'Actual AMFs size != (numberOfProducts * numberOfAssets * numberOfAMF)');
    }

    @IsTest
    static void testUpdates() {
        Test.startTest();
        Product2 testProduct = new Product2(Name = 'TestProduct');
        insert testProduct;
        List<Asset> oldAssets = [SELECT Id, Name, Product2Id, AccountId FROM Asset];
        List<Asset> newAssets = new List<Asset>(oldAssets);
        for (Asset asset : newAssets) {
            asset.Product2Id = testProduct.Id;
        }
        update newAssets;
        Test.stopTest();
        for (Asset asset : newAssets) {
            System.assert(asset.Product2Id == testProduct.Id, 'Asset is not updated with the new Product Id ' + asset);
        }
        List<GDMFSL_Maintenance_Template__c> testProductMaintTemplates = [SELECT Id, Name, GDMFSL_Product__c
        FROM GDMFSL_Maintenance_Template__c];
        List<GDMFSL_Asset_Maintenance_Frequency__c> testAMFs = [SELECT Id, Name, GDMFSL_Asset__c
        FROM GDMFSL_Asset_Maintenance_Frequency__c WHERE GDMFSL_Asset__c IN: newAssets];
        System.assert(testProductMaintTemplates.size() == numberOfProducts * numberOfAssets * numberOfMainTemplates,
                'Actual ProductMaintTemplates size != (numberOfProducts * numberOfAssets * numberOfMainTemplates)');
        System.debug('Actual testAMFs.size::' + testAMFs.size());

    }

    @IsTest
    static void testDeletes() {
        Test.startTest();
        List<Asset> testAssets = [SELECT Id, Product2Id, Name FROM Asset];
        List<GDMFSL_Asset_Maintenance_Frequency__c> testAMFs = [SELECT Id, Name, GDMFSL_Asset__c
        FROM GDMFSL_Asset_Maintenance_Frequency__c WHERE GDMFSL_Asset__c =: testAssets];
        delete testAssets;
        List<Asset> testAssets1 = [SELECT Id, Product2Id, Name FROM Asset];
        System.assertEquals(0,testAssets1.size(),'Asset was not deleted successfully');
        Test.stopTest();
    }
}