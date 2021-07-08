@IsTest
private class GDMFSL_MaintPlanTriggerHandlerTest {

    @TestSetup
    static void init() {

        List<Product2> theProduct = GDMFSL_DataFactory.createProducts('Test Product', 2);
        insert theProduct;


        Account theAccount = new Account(Name = 'Test Account', Phone = '1234561234', BillingStreet = 'Anywhere', BillingCity = 'City', BillingState = 'Florida', BillingCountry = 'United States');
        insert theAccount;

        WorkType wt = GDMFSL_DataFactory.createWorkType('Break/Fix', 4);
        insert wt;

        OperatingHours ohs = GDMFSL_DataFactory.createOperatingHour();
        insert ohs;

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('SSProc Test', ohs.Id);
        insert st;

        Schema.Location aLocation = GDMFSL_DataFactory.createLocation('Test Location', st.Id);
        insert aLocation;

        List<Asset> assetList = GDMFSL_DataFactory.createAssets('Test Asset', theProduct[0].Id, theAccount.Id, 1, aLocation.Id);
        assetList[0].Annual_Maintenance_Date__c = System.now().date();
        assetList.addAll(GDMFSL_DataFactory.createAssets('Test Asset1',theProduct[0].Id,theAccount.Id,1,aLocation.Id));
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


        List<MaintenancePlan> mplans = new List<MaintenancePlan>();

        MaintenancePlan mp = GDMFSL_DataFactory.createMaintenancePlan(wt.Id);
        mp.LocationId = aLocation.Id;
        mplans.add(mp);

        MaintenancePlan mp2 = GDMFSL_DataFactory.createMaintenancePlan(wt.Id);
        mp2.LocationId = aLocation.Id;
        mplans.add(mp2);
        insert mplans;

    }


    @IsTest
    static void getMaintPlanRecordsTest() {

        List<MaintenancePlan> theMaintPlans = new List<MaintenancePlan>([SELECT Id FROM MaintenancePlan]);

        Map<Id, MaintenancePlan> foundRecs = GDMFSL_MaintenancePlanProcessor.getRecords(new Set<Id>{
                theMaintPlans[0].Id
        });

        System.assertEquals(1, foundRecs.size(), 'getRecords() returned wrong number of record Ids');
        System.assertEquals(theMaintPlans[0].Id, foundRecs.get(theMaintPlans[0].Id).Id, 'getRecords() returned incorrect record ID');


        System.debug('Now testing that additional MaintPlans are also retrieved');

        foundRecs = GDMFSL_MaintenancePlanProcessor.getRecords(new Set<Id>{
                theMaintPlans[1].Id
        });
        System.assertEquals(2, foundRecs.size(), 'getRecords() subseqent call returned wrong number of record Ids');
        System.assertEquals(theMaintPlans[0].Id, foundRecs.get(theMaintPlans[0].Id).Id, 'getRecords() returned incorrect original record ID');
        System.assertEquals(theMaintPlans[1].Id, foundRecs.get(theMaintPlans[1].Id).Id, 'getRecords() returned incorrect subsequent record ID');
    }

    @IsTest
    static void getMaintWorkRuleRecordsTest() {

        List<MaintenancePlan> theMaintPlans = new List<MaintenancePlan>([SELECT Id FROM MaintenancePlan]);

        List<MaintenanceWorkRule> allMWRules = new List<MaintenanceWorkRule>();
        MaintenanceWorkRule mwRule = new MaintenanceWorkRule(ParentMaintenancePlanId = theMaintPlans[0].Id,
                Title = 'Rule 1',
                SortOrder = 1,
                RecurrencePattern = 'FREQ=MONTHLY;BYMONTHDAY=27;INTERVAL=1');
        allMWRules.add(mwRule);
        MaintenanceWorkRule mwRule2 = new MaintenanceWorkRule(ParentMaintenancePlanId = theMaintPlans[1].Id,
                Title = 'Rule 2',
                SortOrder = 1,
                RecurrencePattern = 'FREQ=MONTHLY;BYMONTHDAY=27;INTERVAL=1');
        allMWRules.add(mwRule2);
        insert allMWRules;


        Map<Id, MaintenanceWorkRule> foundRecs = GDMFSL_MaintenancePlanProcessor.getMaintWorkRuleRecords(new Set<Id>{
                allMWRules[0].Id
        });

        System.assertEquals(1, foundRecs.size(), 'getMaintWorkRuleRecords() returned wrong number of record Ids');
        System.assertEquals(allMWRules[0].Id, foundRecs.get(allMWRules[0].Id).Id, 'getMaintWorkRuleRecords() returned incorrect record ID');


        System.debug('Now testing that additional MaintWorkRules are also retrieved');

        foundRecs = GDMFSL_MaintenancePlanProcessor.getMaintWorkRuleRecords(new Set<Id>{
                allMWRules[1].Id
        });
        System.assertEquals(2, foundRecs.size(), 'getRecords() subseqent call returned wrong number of record Ids');
        System.assertEquals(allMWRules[0].Id, foundRecs.get(allMWRules[0].Id).Id, 'getMaintWorkRuleRecords() returned incorrect original record ID');
        System.assertEquals(allMWRules[1].Id, foundRecs.get(allMWRules[1].Id).Id, 'getMaintWorkRuleRecords() returned incorrect subsequent record ID');
    }

    @IsTest
    static void checkCompletedForAssistTest() {

        List<MaintenancePlan> theMaintPlans = new List<MaintenancePlan>([SELECT Id FROM MaintenancePlan]);

        theMaintPlans[0].GDMFSL_Requires_Assistant__c = true;

        Test.startTest();

        System.debug('TEST start');

        update theMaintPlans;

        Test.stopTest();

        System.debug('There is nothing to assert since we are unable to mark a MaintPlan as WorkOrderGenerationStatus = \'Complete\'');
    }

    @IsTest
    static void updateMaintenancePlanfromSCTest() {

        Account theAccount = [SELECT Id FROM Account LIMIT 1];

        ServiceContract theServContract = GDMFSL_DataFactory.createServiceContract('Test', theAccount.Id);
        insert theServContract;

        List<MaintenancePlan> theMaintPlans = new List<MaintenancePlan>([SELECT Id, EndDate FROM MaintenancePlan]);

        System.debug('Set 1 MaintPlan with StartDate after SC.EndDate');
        theMaintPlans[0].ServiceContractId = theServContract.Id;
        theMaintPlans[0].StartDate = theServContract.EndDate.addDays(1);

        System.debug('Set 1 MaintPlan with StartDate before SC.EndDate (to be updated)');
        theMaintPlans[1].ServiceContractId = theServContract.Id;
        theMaintPlans[1].StartDate = theServContract.EndDate.addDays(-2);

        update theMaintPlans;

        Test.startTest();

        System.debug('TEST start');

        GDMFSL_MaintenancePlanProcessor.updateMaintenancePlanfromSC(new Map<Id, ServiceContract>{
                theServContract.Id => theServContract
        });

        Test.stopTest();

        for (MaintenancePlan mPlanToCheck : [
                SELECT Id, ServiceContractId, EndDate
                FROM MaintenancePlan
                WHERE ServiceContractId = :theServContract.Id
        ]) {

            if (mPlanToCheck.Id == theMaintPlans[0].Id) {

                System.assertEquals(null, mPlanToCheck.EndDate, 'MaintPlan EndDate changed when StartDate is in the future');

            } else if (mPlanToCheck.Id == theMaintPlans[1].Id) {

                System.assertEquals(theServContract.EndDate, mPlanToCheck.EndDate, 'MaintPlan EndDate is not set to ServContract EndDate');
            }
        }
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
        ];
        List<MaintenanceWorkRule> mWorkRules = [
                SELECT Id,
                        ParentMaintenanceRecordId,
                        WorkTypeId,
                        SortOrder,
                        NextSuggestedMaintenanceDate,
                        RecurrencePattern
                FROM MaintenanceWorkRule
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


}