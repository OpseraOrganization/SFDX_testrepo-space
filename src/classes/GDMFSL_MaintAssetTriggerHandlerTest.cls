@IsTest
private class GDMFSL_MaintAssetTriggerHandlerTest {

    @TestSetup
    static void init() {

        Account theAccount = GDMFSL_DataFactory.createTestAccount('TestAcc');
        insert theAccount;

        List<Product2> p = GDMFSL_DataFactory.createProducts('Test Product', 2);
        insert p;

        OperatingHours theOpHours = GDMFSL_DataFactory.createOperatingHour();
        insert theOpHours;

        ServiceTerritory theServiceTerritory = GDMFSL_DataFactory.createServiceTerritory('ARes Test', theOpHours.Id);
        insert theServiceTerritory;

        Schema.Location aLocation = GDMFSL_DataFactory.createLocation('Campus',theServiceTerritory.Id);
        insert aLocation;

        List<Asset> assetList = GDMFSL_DataFactory.createAssets('Test Asset', p[0].Id, theAccount.Id, 1, aLocation.Id);
        assetList[0].Annual_Maintenance_Date__c = System.now().date();
        assetList.addAll(GDMFSL_DataFactory.createAssets('Test Asset1',p[0].Id,theAccount.Id,1,aLocation.Id));
        insert assetList;

        List<WorkType> lstworktype = GDMFSL_DataFactory.createWorkTypes('W001', 3, 30);
        insert lstworktype;

        List<GDMFSL_Asset_Maintenance_Frequency__c> assetMFs = GDMFSL_DataFactory.createAssetMaintenances(assetList[0].Id, 1);
        assetMFs[0].GDMFSL_Recurrence_Type__c = 'Monthly On Day of Month';
        assetMFs[0].GDMFSL_Frequency_Every_N__c = 6;
        assetMFs[0].GDMFSL_Frequency_Type__c = 'Monthly';
        assetMFs[0].GDMFSL_Work_Type__c = lstworktype[0].Id;
        assetMFs[0].GDMFSL_Sort_Order__c = 2;
        insert assetMFs;


        MaintenancePlan mPlan = GDMFSL_DataFactory.createMaintenancePlan(lstworktype[0].Id);
        insert mPlan;


    }

    @IsTest
    static void createMaintenanceWorkRulesTest() {

        List<Asset> theAssets = [SELECT Id,Name FROM Asset];

        List<MaintenancePlan> theMPs =[SELECT Id FROM MaintenancePlan];

        MaintenanceAsset mAsset = GDMFSL_DataFactory.createMaintenanceAsset(theMPs[0].Id, theAssets[0].Id);
        insert mAsset;

        List<GDMFSL_Asset_Maintenance_Frequency__c> theAssetMaintFrequencies = [
                SELECT Id,
                        Name,
                        GDMFSL_Work_Type__c,
                        GDMFSL_Sort_Order__c,
                        GDMFSL_Date_of_First_Work_Order__c,
                        GDMFSL_RRULE_Template__c
                FROM GDMFSL_Asset_Maintenance_Frequency__c
                WHERE GDMFSL_Asset__c= :theAssets[0].Id
        ];
        List<MaintenanceWorkRule> mWorkRules = [
                SELECT Id,
                        ParentMaintenanceRecordId,
                        WorkTypeId,
                        SortOrder,
                        NextSuggestedMaintenanceDate,
                        RecurrencePattern
                FROM MaintenanceWorkRule
                WHERE ParentMaintenanceRecordId= :mAsset.Id
        ];

        System.assert(mWorkRules.size() > 0, 'The Maintenance Work Rule did not get created');


        for (MaintenanceWorkRule mWorkRule : mWorkRules) {
            System.assertEquals(mWorkRule.ParentMaintenanceRecordId, mAsset.Id, 'WorkRule did not get created based on the Maintenance Asset');
            if (mWorkRule.ParentMaintenanceRecordId == mAsset.Id) {
                System.assertEquals(mWorkRule.WorkTypeId, theAssetMaintFrequencies[0].GDMFSL_Work_Type__c, 'WorkType did not derive on the Work Rule from WorkPlan');
                System.assertEquals(mWorkRule.SortOrder, theAssetMaintFrequencies[0].GDMFSL_Sort_Order__c, 'SortOrder did not derive on the Work Rule from WorkPlan');
                System.assertEquals(mWorkRule.NextSuggestedMaintenanceDate, theAssetMaintFrequencies[0].GDMFSL_Date_of_First_Work_Order__c, 'Date of First WorkOrder did not derive on the Work Rule from WorkPlan');
                System.assertEquals(mWorkRule.RecurrencePattern, theAssetMaintFrequencies[0].GDMFSL_RRULE_Template__c, 'RRUle Template did not derive on the Work Rule from WorkPlan');


            }
        }

    }

   @IsTest
    static void skipProcessTest() {


        List<Asset> asset1 = [SELECT Id FROM Asset];
       List<WorkType> wType =[SELECT Id from WorkType];

       MaintenancePlan mPlan = GDMFSL_DataFactory.createMaintenancePlan(wType[0].Id);
       insert mPlan;


        List<GDMFSL_Asset_Maintenance_Frequency__c> assetMFs = GDMFSL_DataFactory.createAssetMaintenances(asset1[0].Id, 1);
        assetMFs[0].GDMFSL_Recurrence_Type__c = 'Monthly On Day of Month';
        assetMFs[0].GDMFSL_Frequency_Every_N__c = 8;
        assetMFs[0].GDMFSL_Frequency_Type__c = 'Monthly';
        insert assetMFs;

       Skip_Automation_Process__c profileCustomSetting = new Skip_Automation_Process__c();
       profileCustomSetting.SetupOwnerId = UserInfo.getOrganizationId();
       profileCustomSetting.ByPass_Automation__c = true;
       insert profileCustomSetting;

       MaintenanceAsset maintenanceAsset= GDMFSL_DataFactory.createMaintenanceAsset(mPlan.Id,asset1[0].Id);
        insert maintenanceAsset;

        List<MaintenanceWorkRule> mWorkRules = [
                SELECT Id,
                        ParentMaintenanceRecordId,
                        WorkTypeId,
                        SortOrder,
                        NextSuggestedMaintenanceDate,
                        RecurrencePattern
                FROM MaintenanceWorkRule
                WHERE ParentMaintenanceRecordId= : maintenanceAsset.Id
        ];


        System.assert(mWorkRules.size()==0,'Skip Process was set but still WorkRule got created');

    }
}