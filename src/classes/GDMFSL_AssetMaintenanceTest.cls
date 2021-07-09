@IsTest
private class GDMFSL_AssetMaintenanceTest {

    @TestSetup
    static void init() {

       WorkType WT = GDMFSL_DataFactory.createWorkType('testWT',30);

        List<Product2> lstProducts = GDMFSL_DataFactory.createProducts('Prod', 1);
        insert lstProducts;
        System.debug('Products Inserted' + lstProducts);

        List<GDMFSL_Maintenance_Template__c> lstMaintTemplates = GDMFSL_DataFactory.createCompleteMaintTemplates('MaintTemplates', lstProducts[0].Id,WT.Id, 1);
        insert lstMaintTemplates;
        System.debug('Maint Templates Inserted' + lstMaintTemplates);


        Account Acc = GDMFSL_DataFactory.createTestAccount('Account');
        insert Acc;
        System.debug('Account Inserted' + Acc);


        OperatingHours operatingHours = GDMFSL_DataFactory.createOperatingHour();
        insert operatingHours;
        System.debug('operatingHours  Inserted : ' + operatingHours);

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('Asset Test', operatingHours.Id);
        insert st;
        System.debug('ServiceTerritory Inserted : ' + st);

        Schema.Location location = GDMFSL_DataFactory.createLocation('Campus', st.Id, operatingHours.Id);
        List<Schema.Location> lstlocation = new List<Schema.Location >();
        lstlocation.add(location);
        insert lstlocation;
        System.debug('Location(s) Inserted : ' + lstlocation);


        List<Asset> lstasset = GDMFSL_DataFactory.createAssets('TestAsset', lstProducts[0].Id, Acc.Id, 1, location.Id);
        insert lstasset;
        System.debug('Asset(s) Inserted : ' + lstasset);
    }

    @IsTest
    static void testCreateAssetMaints() {

        List<Asset> lstAssets = [SELECT Id, Product2Id FROM Asset];
        //GDMFSL_AssetMaintenance.createAssetMaints(lstAssets);
        System.debug('Assets list::' + lstAssets);

        List<GDMFSL_Maintenance_Template__c> maintTemp = [SELECT Id,GDMFSL_Frequency_Every_N__c FROM GDMFSL_Maintenance_Template__c WHERE GDMFSL_Maintenance_Template__c.GDMFSL_Product__r.Id=:lstAssets[0].Product2Id];
        System.debug('Maint templates Found: '+ maintTemp);

        List<GDMFSL_Asset_Maintenance_Frequency__c> MAFreq = [SELECT Id FROM GDMFSL_Asset_Maintenance_Frequency__c WHERE GDMFSL_Asset__c =: lstAssets[0].Id];
        System.debug('Maint Asset Frequencies Found: '+ MAFreq);
        System.assertEquals(maintTemp.size(),MAFreq.size(),'Asset Maintenance Frequencies did not match the Maintenance Templates for Asset=' + lstAssets[0].Id);

   }

    @IsTest
    static void testGetAssetMaintFrequencyRecords() {

        List<Asset> lstAssets = [SELECT Id, Product2Id FROM Asset WHERE Name='TestAsset'];
        Set<Id> assetIds = new Set<Id>();
        for (Asset asset : lstAssets) {
            assetIds.add(asset.Id);
        }

        List<Product2> prd = [SELECT Id FROM Product2 WHERE Name='Prod'];

        System.debug('list of assets: '+ lstAssets);
        //ist<GDMFSL_Maintenance_Template__c> lstMaintTemplates = GDMFSL_DataFactory.createMaintTemplates('MaintTemplates', prd[0].Id, 1);
       // insert lstMaintTemplates;
        //System.debug('Maint Templates Inserted' + lstMaintTemplates);

        List<GDMFSL_Asset_Maintenance_Frequency__c> assetfreq = [SELECT Id FROM GDMFSL_Asset_Maintenance_Frequency__c WHERE GDMFSL_Asset__c IN:lstAssets];
        System.debug('list of Asset freq: '+ assetfreq);

        Map<Id, List<GDMFSL_Asset_Maintenance_Frequency__c>> assetMaintFreq = GDMFSL_AssetMaintenance.getAssetMaintFrequencyRecords(assetIds);
        System.debug('list of Asset freq from func(): '+ assetMaintFreq);

        System.assertEquals(assetfreq.size(), assetMaintFreq.size(), 'The map did not retrieved the Maintenance Frequency records from Get Records');
    }

    @IsTest
    static void testDeleteMaintenanceDataForAssets() {

        Map<Id, Asset> lstAssets = new Map<Id, Asset>([SELECT Id, Product2Id FROM Asset WHERE Name LIKE 'TestAsset%']);

        System.debug('Have this many Assets to work with: ' + lstAssets.size());

        List<GDMFSL_Asset_Maintenance_Frequency__c> maintAssetsBeforeDelete = [SELECT Id FROM GDMFSL_Asset_Maintenance_Frequency__c WHERE GDMFSL_Asset__c IN :lstAssets.keySet()];

        System.debug('Maintenance Assets before delete::' + maintAssetsBeforeDelete.size());

        GDMFSL_AssetMaintenance.deleteMaintenanceDataForAssets(lstAssets.keySet());

        List<GDMFSL_Asset_Maintenance_Frequency__c> maintAssetAfterDelete = [SELECT Id FROM GDMFSL_Asset_Maintenance_Frequency__c WHERE GDMFSL_Asset__c = :lstAssets.keySet()];

        System.assertNotEquals(maintAssetAfterDelete.size(), maintAssetsBeforeDelete.size(),'Maintenance records returned wrong number of records for asset ' + lstAssets.keySet());
    }

}