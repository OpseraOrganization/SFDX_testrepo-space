@IsTest
private class GDMFSL_WorkOrderLIProcessorTest {

    @TestSetup
    static void init() {


        Account theAccount = new Account(Name = 'WOLI Test Account', Phone = '1234561234', BillingStreet = 'Anywhere', BillingCity = 'City', BillingState = 'Florida', BillingCountry = 'United States');
        insert theAccount;

        List<Product2> p = GDMFSL_DataFactory.createProducts('WOLI Test Product', 2);
        insert p;

        List<ServiceReportLayout> srLayouts = [SELECT Id FROM ServiceReportLayout LIMIT 1];


        OperatingHours ohs = GDMFSL_DataFactory.createOperatingHour();
        insert ohs;
        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('WOLI Test Test', ohs.Id);
        insert st;
        Schema.Location lo = GDMFSL_DataFactory.createLocation('WOLI Test Location', st.Id);
        lo.GDMFSL_Region__c = 'META';
        insert lo;

        List<Asset> assetList = GDMFSL_DataFactory.createAssets('Test Asset', p[0].Id, theAccount.Id, 1, lo.Id);
        assetList[0].Annual_Maintenance_Date__c = System.now().date();
        assetList.addAll(GDMFSL_DataFactory.createAssets('Test Asset1', p[0].Id, theAccount.Id, 1, lo.Id));
        insert assetList;

        WorkType wt = GDMFSL_DataFactory.createWorkType('PM Test', 4);
        wt.GDMFSL_WorkType_Category__c = 'PM';
        wt.ServiceReportTemplateId = srLayouts[0].Id;
        wt.GDMFSL_Asset_Certification__c = true;
        insert wt;

        GDMFSL_Asset_Component__c assetComp = GDMFSL_DataFactory.createAssetComponent(assetList[0].Id, p[0].Id, 2);
        insert assetComp;

        List<ServiceContract> theSCs = new List<ServiceContract>();
        ServiceContract sc1 = GDMFSL_DataFactory.createServiceContract('SC1', theAccount.Id);
        sc1.GDMFSL_ATS_BreakFix_Hours__c = 100;
        theSCs.add(sc1);
        ServiceContract sc2 = GDMFSL_DataFactory.createServiceContract('SC2', theAccount.Id);
        theSCs.add(sc2);
        insert theSCs;
        System.debug('Inserted Test SCs from GDMFSL_ServiceContractProcessorTest.init');


        List<WorkPlanTemplate> wptToInsert = new List<WorkPlanTemplate>();
        WorkPlanTemplate theWPTemplate = new WorkPlanTemplate(Name = 'Heating Coil', RelativeExecutionOrder = 5, Description = 'Test WPT', IsActive = true);
        wptToInsert.add(theWPTemplate);

        WorkPlanTemplate theOtherWPTemplate = new WorkPlanTemplate(Name = 'Acoustic joints', RelativeExecutionOrder = 3, Description = 'Test Another WPT', IsActive = true);
        wptToInsert.add(theOtherWPTemplate);

        insert wptToInsert;

        WorkPlanSelectionRule workPlanSelRule = GDMFSL_DataFactory.createWorkPlanSelectionRule(theSCs[0].Id, st.Id, p[0].Id, wptToInsert[0].Id, wt.Id);
        insert workPlanSelRule;

        List<WorkStepTemplate> wstToInsert = new List<WorkStepTemplate>();
        WorkStepTemplate theWSTemplate = new WorkStepTemplate(Name = 'Test', IsActive = true, GDMFSL_Relative_Sort_Order__c = 1);
        wstToInsert.add(theWSTemplate);

        WorkStepTemplate theOtherWSTemplate = new WorkStepTemplate(Name = 'Test 2', IsActive = true);
        wstToInsert.add(theOtherWSTemplate);

        insert wstToInsert;

        WorkPlanTemplateEntry wpte = new WorkPlanTemplateEntry(WorkPlanTemplateId = wptToInsert[0].Id, WorkStepTemplateId = wstToInsert[0].Id, ExecutionOrder = 1);
        insert wpte;

        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(wt.Id, theAccount.Id, lo.Id, System.Now(), System.Now());
        wo.GDMFSL_PO_Number__c = '44444';
        insert wo;
    }

    @IsTest
    static void setFieldsTest() {
        List<ServiceReportLayout> srLayout = [SELECT Id FROM ServiceReportLayout LIMIT 1];
        List<Account> account = [SELECT Id FROM Account];
        List<Schema.Location> location = [SELECT Id FROM Location];
        List<Asset> assetList = [SELECT Id FROM Asset];

        WorkType wt = GDMFSL_DataFactory.createWorkType('Break/Fix', 4);
        wt.ServiceReportTemplateId = srLayout[0].Id;
        insert wt;

        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(wt.Id, account[0].Id, location[0].Id, System.Now(), System.Now());
        wo.GDMFSL_PO_Number__c = '11111';
        wo.AssetId = assetList[0].Id;

        insert wo;

        List<WorkOrderLineItem> theWOLIs = [SELECT Id,ServiceReportTemplateId FROM WorkOrderLineItem where WorkOrderId = :wo.Id];

        System.debug('srLayout : ' + srLayout);
        System.assertEquals(srLayout[0].Id, theWOLIs[0].ServiceReportTemplateId, 'Service Report Template Id not derived on WOLI from WorkType');
    }

    @IsTest
    static void getRecordsTest() {

        List<ServiceReportLayout> srLayout = [SELECT Id FROM ServiceReportLayout LIMIT 1];
        List<Account> account = [SELECT Id FROM Account];
        List<Schema.Location> location = [SELECT Id FROM Location];
        List<Asset> assetList = [SELECT Id FROM Asset];

        List<Id> recIds = new List<Id>();

        Map<Id, WorkOrderLineItem> mapWOLI = new Map<Id, WorkOrderLineItem>();

        WorkType wt = GDMFSL_DataFactory.createWorkType('Break/Fix', 4);
        wt.ServiceReportTemplateId = srLayout[0].Id;
        insert wt;

        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(wt.Id, account[0].Id, location[0].Id, System.Now(), System.Now());
        wo.GDMFSL_PO_Number__c = '22222';
        wo.AssetId = assetList[0].Id;

        insert wo;

        List<WorkOrderLineItem> theWOLIs = [SELECT Id,ServiceReportTemplateId FROM WorkOrderLineItem where WorkOrderId = :wo.Id];


        recIds.add(theWOLIs[0].Id);
        mapWOLI = GDMFSL_WorkOrderLIProcessor.getRecords(recIds);

        System.assertEquals(1, mapWOLI.size(), 'The Maps Count has more than the expected records');
        System.assert(mapWOLI.containsKey(theWOLIs[0].Id), 'The Id of WOLI in the Map is not correct to the one it was supposed to fetch');

        List<WorkOrder> wo1 = [SELECT Id FROM WorkOrder WHERE Id = :wo.Id];


        WorkOrderLineItem woli1 = GDMFSL_DataFactory.createWorkOrderLineItem(wt.Id, wo1[0].Id, assetList[0].Id);
        insert woli1;


        recIds.add(woli1.Id);
        mapWOLI = GDMFSL_WorkOrderLIProcessor.getRecords(recIds);

        System.assertEquals(2, mapWOLI.size(), 'The map retrieved did not bring the Source system from Get Records');


    }

    @IsTest
    static void skipProcessTest() {

        Skip_Automation_Process__c profileCustomSetting = new Skip_Automation_Process__c();
        profileCustomSetting.SetupOwnerId = UserInfo.getOrganizationId();
        profileCustomSetting.ByPass_Automation__c = true;
        insert profileCustomSetting;

        List<Asset> assetList = [SELECT Id FROM Asset];
        List<WorkOrderLineItem> theWOLIs = [
                SELECT Id,ServiceReportTemplateId, (SELECT Id,GDMFSL_Total__c FROM Asset_Component_Summaries__r)
                FROM WorkOrderLineItem
        ];

        theWOLIs[0].AssetId = assetList[0].Id;
        update theWOLIs;

        List<GDMFSL_Asset_Component_Summary__c> theACs = new List<GDMFSL_Asset_Component_Summary__c>();

        System.assertEquals(0, theACs.size(), 'As Skip Process is true nothing should be created on Asset Component Summary');


    }

    @IsTest
    static void createAssetComponentSummaryForWOLITest() {

        List<Asset> assetList = [SELECT Id FROM Asset];
        List<WorkOrderLineItem> theWOLIs = [
                SELECT Id,ServiceReportTemplateId, (SELECT Id,GDMFSL_Total__c FROM Asset_Component_Summaries__r)
                FROM WorkOrderLineItem
        ];

        theWOLIs[0].AssetId = assetList[0].Id;
        update theWOLIs;

        List<GDMFSL_Asset_Component_Summary__c> theACs = new List<GDMFSL_Asset_Component_Summary__c>();

        System.assertEquals(theWOLIs[0].Asset_Component_Summaries__r.size(), theACs.size(), 'Expected Asset Component Summary was 1 but thats not true');


    }

    @IsTest
    static void callMethodToDeriveWorkPlansAndStepsOnWOLITest() {


        List<Account> account = [SELECT Id FROM Account];
        List<Schema.Location> location = [SELECT Id FROM Location];
        List<Asset> assetList = [SELECT Id FROM Asset];
        List<ServiceContract> serviceContractList = [SELECT Id FROM ServiceContract];
        List<WorkType> wt = [SELECT Id FROM WorkType];

        List<WorkOrder> toBeCreatedWOs = New List<WorkOrder>();

        WorkOrder wo1 = GDMFSL_DataFactory.createWorkOrder(wt[0].Id, account[0].Id, location[0].Id, System.Now(), System.Now());
        wo1.GDMFSL_PO_Number__c = '7777777';
        wo1.AssetId = assetList[0].Id;
        wo1.ServiceContractId = serviceContractList[0].Id;
        System.debug('WorkOrder to be Inserted : ' + wo1);
        toBeCreatedWOs.add(wo1);

        WorkOrder wo2 = GDMFSL_DataFactory.createWorkOrder(wt[0].Id, account[0].Id, location[0].Id, System.Now(), System.Now());
        wo2.GDMFSL_PO_Number__c = '88888';
        wo2.AssetId = assetList[0].Id;
        wo2.ServiceContractId = serviceContractList[0].Id;
        System.debug('WorkOrder to be Inserted : ' + wo2);
        toBeCreatedWOs.add(wo2);

        WorkOrder wo3 = GDMFSL_DataFactory.createWorkOrder(wt[0].Id, account[0].Id, location[0].Id, System.Now(), System.Now());
        wo3.GDMFSL_PO_Number__c = '9999';
        wo3.AssetId = assetList[0].Id;
        System.debug('WorkOrder to be Inserted : ' + wo3);
        toBeCreatedWOs.add(wo3);

        WorkOrder wo4 = GDMFSL_DataFactory.createWorkOrder(wt[0].Id, account[0].Id, location[0].Id, System.Now(), System.Now());
        wo4.GDMFSL_PO_Number__c = '6666';
        wo4.AssetId = assetList[0].Id;
        System.debug('WorkOrder to be Inserted : ' + wo4);
        toBeCreatedWOs.add(wo4);

        insert toBeCreatedWOs;

        List<WorkOrderLineItem> theWOLIs1 = [
                SELECT Id,ServiceReportTemplateId,AssetId,ServiceTerritoryId,LineItemNumber,GDMFSL_Created_From_Mobile__c,
                        WorkOrderId,WorkTypeId,LocationId
                FROM WorkOrderLineItem
                WHERE WorkOrderId IN(:wo1.Id, :wo2.Id, :wo3.Id, :wo4.Id)
        ];


        for (WorkOrderLineItem woli : theWOLIs1) {
            if (woli.WorkOrderId == wo2.Id || woli.WorkOrderId == wo4.Id) {
                woli.ServiceTerritoryId = null;
            }
        }
        update theWOLIs1;


        Test.startTest();
        GDMFSL_WorkOrderLIProcessor.setWorkPlanWorkStepsOnWOLI(theWOLIs1);
        Test.stopTest();

        List<WorkPlanTemplate> workPlanTemplates = [SELECT Id,Name,Description,RelativeExecutionOrder FROM WorkPlanTemplate];
        List<WorkStepTemplate> workStepTemplates = [SELECT Id,Name,Description,GDMFSL_Relative_Sort_Order__c FROM WorkStepTemplate];
        List<WorkOrderLineItem> theWOLIs = [
                SELECT Id,ServiceReportTemplateId,WorkOrderId, (SELECT Id,Name,Description,ExecutionOrder,WorkOrderId,WorkOrderLineItemId FROM WorkPlans), (SELECT Id,GDMFSL_Relative_Sort_Order__c,WorkPlanId,ExecutionOrder,WorkOrderId,WorkOrderLineItemId FROM WorkSteps)
                FROM WorkOrderLineItem
                where WorkOrderId = :wo1.Id
        ];
        List<WorkPlan> wp0 = [SELECT Id FROM WorkPlan WHERE WorkOrderLineItemId = :theWOLIs[0].Id];
        for (WorkOrderLineItem woli : theWOLIs) {

            for (WorkPlan wp : woli.WorkPlans) {
                System.assertEquals(wp.Name, workPlanTemplates[0].Name, 'WorkPlan Name did not Derive');
                System.assertEquals(wp.Description, workPlanTemplates[0].Description, 'WorkPlan Description did not Derive');
                System.assertEquals(wp.ExecutionOrder, workPlanTemplates[0].RelativeExecutionOrder, 'WorkPlan execution order did not Derive');
                System.assertEquals(wp.WorkOrderId, woli.WorkOrderId, 'WorkPlan WorkOrder Id did not Derive');
                System.assertEquals(wp.WorkOrderLineItemId, woli.Id, 'WorkPlan WOLI Id did not Derive');
                break;
            }

            for (WorkStep ws : woli.WorkSteps) {

                System.assertEquals(ws.WorkOrderId, woli.WorkOrderId, 'WorkOrder Id  did not Derive on Work Step');
                System.assertEquals(ws.WorkPlanId, wp0[0].Id, 'WorkPlan Id did not Derive on Work Step');
                System.assertEquals(ws.WorkOrderLineItemId, woli.Id, 'WOLI Id did not Derive on Work Step');
                System.assertEquals(ws.ExecutionOrder, workStepTemplates[0].GDMFSL_Relative_Sort_Order__c, 'Sort Order did not Derive on Work Step');
                break;

            }

        }

        System.debug('Testing for the case where Work Plan Selection Rule is fetched without matching Service territory');

        List<WorkOrderLineItem> theWOLIs3 = [
                SELECT Id,ServiceReportTemplateId,WorkOrderId, (SELECT Id,Name,Description,ExecutionOrder,WorkOrderId,WorkOrderLineItemId FROM WorkPlans), (SELECT Id,GDMFSL_Relative_Sort_Order__c,WorkPlanId,ExecutionOrder,WorkOrderId,WorkOrderLineItemId FROM WorkSteps)
                FROM WorkOrderLineItem
                WHERE WorkOrderId = :wo2.Id
        ];
        List<WorkPlan> wp1 = [SELECT Id FROM WorkPlan WHERE WorkOrderLineItemId = :theWOLIs3[0].Id];
        for (WorkOrderLineItem woli : theWOLIs3) {

            for (WorkPlan wp : woli.WorkPlans) {
                System.assertEquals(wp.Name, workPlanTemplates[0].Name, 'WorkPlan Name did not Derive');
                System.assertEquals(wp.Description, workPlanTemplates[0].Description, 'WorkPlan Description did not Derive');
                System.assertEquals(wp.ExecutionOrder, workPlanTemplates[0].RelativeExecutionOrder, 'WorkPlan execution order did not Derive');
                System.assertEquals(wp.WorkOrderId, woli.WorkOrderId, 'WorkPlan WorkOrder Id did not Derive');
                System.assertEquals(wp.WorkOrderLineItemId, woli.Id, 'WorkPlan WOLI Id did not Derive');
                break;
            }


            for (WorkStep ws : woli.WorkSteps) {

                System.assertEquals(ws.WorkOrderId, woli.WorkOrderId, 'WorkOrder Id  did not Derive on Work Step');
                System.assertEquals(ws.WorkPlanId, wp1[0].Id, 'WorkPlan Id did not Derive on Work Step');
                System.assertEquals(ws.WorkOrderLineItemId, woli.Id, 'WOLI Id did not Derive on Work Step');
                System.assertEquals(ws.ExecutionOrder, workStepTemplates[0].GDMFSL_Relative_Sort_Order__c, 'Sort Order did not Derive on Work Step');
                break;

            }

        }


        System.debug('Testing for the case where Work Plan Selection Rule is fetched without matching Service Contract');


        List<WorkOrderLineItem> theWOLIs5 = [
                SELECT Id,ServiceReportTemplateId,WorkOrderId, (SELECT Id,Name,Description,ExecutionOrder,WorkOrderId,WorkOrderLineItemId FROM WorkPlans), (SELECT Id,GDMFSL_Relative_Sort_Order__c,WorkPlanId,ExecutionOrder,WorkOrderId,WorkOrderLineItemId FROM WorkSteps)
                FROM WorkOrderLineItem
                where WorkOrderId = :wo3.Id
        ];
        List<WorkPlan> wp2 = [SELECT Id FROM WorkPlan where WorkOrderLineItemId = :theWOLIs5[0].Id];
        for (WorkOrderLineItem woli : theWOLIs5) {

            for (WorkPlan wp : woli.WorkPlans) {
                System.assertEquals(wp.Name, workPlanTemplates[0].Name, 'WorkPlan Name did not Derive');
                System.assertEquals(wp.Description, workPlanTemplates[0].Description, 'WorkPlan Description did not Derive');
                System.assertEquals(wp.ExecutionOrder, workPlanTemplates[0].RelativeExecutionOrder, 'WorkPlan execution order did not Derive');
                System.assertEquals(wp.WorkOrderId, woli.WorkOrderId, 'WorkPlan WorkOrder Id did not Derive');
                System.assertEquals(wp.WorkOrderLineItemId, woli.Id, 'WorkPlan WOLI Id did not Derive');
                break;
            }

            for (WorkStep ws : woli.WorkSteps) {

                System.assertEquals(ws.WorkOrderId, woli.WorkOrderId, 'WorkOrder Id  did not Derive on Work Step');
                System.assertEquals(ws.WorkPlanId, wp2[0].Id, 'WorkPlan Id did not Derive on Work Step');
                System.assertEquals(ws.WorkOrderLineItemId, woli.Id, 'WOLI Id did not Derive on Work Step');
                System.assertEquals(ws.ExecutionOrder, workStepTemplates[0].GDMFSL_Relative_Sort_Order__c, 'Sort Order did not Derive on Work Step');
                break;

            }

        }


        System.debug('Testing for the case where Work Plan Selection Rule is fetched with matching only Product and WorkType');


        List<WorkOrderLineItem> theWOLIs7 = [
                SELECT Id,ServiceReportTemplateId,WorkOrderId, (SELECT Id,Name,Description,ExecutionOrder,WorkOrderId,WorkOrderLineItemId FROM WorkPlans), (SELECT Id,GDMFSL_Relative_Sort_Order__c,WorkPlanId,ExecutionOrder,WorkOrderId,WorkOrderLineItemId FROM WorkSteps)
                FROM WorkOrderLineItem
                where WorkOrderId = :wo4.Id
        ];
        List<WorkPlan> wp3 = [SELECT Id FROM WorkPlan where WorkOrderLineItemId = :theWOLIs7[0].Id];
        for (WorkOrderLineItem woli : theWOLIs7) {

            for (WorkPlan wp : woli.WorkPlans) {
                System.assertEquals(wp.Name, workPlanTemplates[0].Name, 'WorkPlan Name did not Derive');
                System.assertEquals(wp.Description, workPlanTemplates[0].Description, 'WorkPlan Description did not Derive');
                System.assertEquals(wp.ExecutionOrder, workPlanTemplates[0].RelativeExecutionOrder, 'WorkPlan execution order did not Derive');
                System.assertEquals(wp.WorkOrderId, woli.WorkOrderId, 'WorkPlan WorkOrder Id did not Derive');
                System.assertEquals(wp.WorkOrderLineItemId, woli.Id, 'WorkPlan WOLI Id did not Derive');
                break;
            }

            for (WorkStep ws : woli.WorkSteps) {

                System.assertEquals(ws.WorkOrderId, woli.WorkOrderId, 'WorkOrder Id  did not Derive on Work Step');
                System.assertEquals(ws.WorkPlanId, wp3[0].Id, 'WorkPlan Id did not Derive on Work Step');
                System.assertEquals(ws.WorkOrderLineItemId, woli.Id, 'WOLI Id did not Derive on Work Step');
                System.assertEquals(ws.ExecutionOrder, workStepTemplates[0].GDMFSL_Relative_Sort_Order__c, 'Sort Order did not Derive on Work Step');
                break;

            }

        }
    }

    @IsTest
    static void deriveVisitingHoursForWOTest() {

        List<ServiceReportLayout> srLayout = [SELECT Id FROM ServiceReportLayout LIMIT 1];
        List<Account> account = [SELECT Id FROM Account];
        List<Schema.Location> location = [SELECT Id FROM Location];
        List<Asset> assetList = [SELECT Id FROM Asset];
        List<Product2> lstproduct = [SELECT Id from Product2];
        List<ServiceContract> serviceContractList = [SELECT Id FROM ServiceContract];
        List<OperatingHours> operatingHours = [SELECT Id FROM OperatingHours];
        ServiceContract sc = GDMFSL_DataFactory.createServiceContract('TestServiceContract', account[0].Id);
        insert sc;

        set<Id> serviceContractIds = new set<Id>();
        serviceContractIds.add(sc.id);

        Pricebook2 PriceBook = GDMFSL_DataFactory.createPriceBook('TestPriceBook');
        insert PriceBook;
        System.debug('Pricebook Inserted : ' + PriceBook.Id);

        PricebookEntry pricebookentry = GDMFSL_DataFactory.createPriceBookEntry(lstproduct[0].Id);
        insert pricebookentry;

        System.debug('pricebookentry with stand. price book  Inserted : ' + pricebookentry);

        PricebookEntry pricebookentryCustom = GDMFSL_DataFactory.createPriceBookEntry(lstproduct[0].Id);
        pricebookentryCustom.Pricebook2Id = PriceBook.Id;
        insert pricebookentryCustom;
        System.debug('pricebookentry Custom Inserted : ' + pricebookentryCustom);

        sc.Pricebook2Id = PriceBook.Id;
        update sc;

        ContractLineItem theCLI = GDMFSL_DataFactory.createCLI(sc.Id, pricebookentryCustom.Id);
        theCLI.Quantity = 10;
        theCLI.AssetId = assetList[0].Id;
        theCLI.GDMFSL_Maintenance_Hours__c = operatingHours[0].Id;
        insert theCLI;
        System.debug('CLI Inserted : ' + theCLI);


        WorkType wt = GDMFSL_DataFactory.createWorkType('PM Test', 4);
        wt.GDMFSL_WorkType_Category__c = 'PM';
        insert wt;

        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(wt.Id, account[0].Id, location[0].Id, System.Now(), System.Now());
        wo.GDMFSL_PO_Number__c = '989898';
        wo.AssetId = assetList[0].Id;
        wo.ServiceContractId = sc.Id;
        insert wo;


        List<WorkOrderLineItem> theWOLIs = [
                SELECT Id,WorkOrderId,ServiceReportTemplateId,AssetId,WorkTypeId
                FROM WorkOrderLineItem
                WHERE WorkOrderId = :wo.Id
        ];

        System.debug('WOLI retrieved in test Class : ' + theWOLIs[0]);

        GDMFSL_WorkOrderLIProcessor.setWOVisitingHoursFromWOLIs(theWOLIs);

        List<WorkOrder> wo1 = [SELECT FSL__VisitingHours__c,Id FROM WorkOrder WHERE Id = :theWOLIs[0].WorkOrderId];

        System.assertEquals(operatingHours[0].Id, wo1[0].FSL__VisitingHours__c, 'Operating Hour on WO not derived Correctly');

    }

    @IsTest
    static void testGetRecordsByWorkOrderIdForMaintPlanIds() {
        WorkOrder wo = [SELECT Id FROM WorkOrder LIMIT 1];
        WorkType wt = [SELECT Id FROM WorkType LIMIT 1];
        List<Asset> a = [SELECT Id from Asset];
        MaintenancePlan mp = GDMFSL_DataFactory.createMaintenancePlan(wt.Id);
        insert mp;
        MaintenanceAsset ma = GDMFSL_DataFactory.createMaintenanceAsset(mp.Id, a[0].Id);
        insert ma;

        wo.MaintenancePlanId = mp.Id;
        wo.SuggestedMaintenanceDate = system.today();
        update wo;

        WorkOrderLineItem woli = GDMFSL_DataFactory.createWorkOrderLineItem(wt.Id, wo.Id, a[0].Id);
        insert woli;

        Set<Id> mpId = new Set<Id>();
        mpId.add(mp.Id);

        Map<Id, Map<Id, WorkOrderLineItem>> mapWOIdToWOLIs = GDMFSL_WorkOrderLIProcessor.getRecordsByWorkOrderIdForMaintPlanIds(mpId);
        System.assertEquals(1, mapWOIdToWOLIs.size(), 'NUmber of records fetched by get records for WO is not correct');


    }

    @IsTest
    static void testAddWOLIRelatedRecordsToMaintPlanWOs() {
        WorkOrder wo = [SELECT Id FROM WorkOrder LIMIT 1];
        WorkType wt = [SELECT Id FROM WorkType LIMIT 1];
        List<Asset> a = [SELECT Id from Asset];
        MaintenancePlan mp = GDMFSL_DataFactory.createMaintenancePlan(wt.Id);
        insert mp;
        MaintenanceAsset ma = GDMFSL_DataFactory.createMaintenanceAsset(mp.Id, a[0].Id);
        insert ma;

        wo.MaintenancePlanId = mp.Id;
        wo.SuggestedMaintenanceDate = system.today();
        update wo;

        WorkOrderLineItem woli = GDMFSL_DataFactory.createWorkOrderLineItem(wt.Id, wo.Id, a[0].Id);
        insert woli;

        List<Skill> theSkills = [SELECT Id FROM Skill LIMIT 2];
        List<SkillRequirement> skr = new List<SkillRequirement>();
        SkillRequirement sr = new SkillRequirement(RelatedRecordId = wo.Id, SkillId = theSkills[0].Id, SkillLevel = 1);
        SkillRequirement sr1 = new SkillRequirement(RelatedRecordId = woli.Id, SkillId = theSkills[0].Id, SkillLevel = 3);
        skr.add(sr);
        skr.add(sr1);
        insert skr;

        Set<Id> mpId = new Set<Id>();
        mpId.add(mp.Id);

        GDMFSL_WorkOrderLIProcessor.addWOLIRelatedRecordsToMaintPlanWOs(mpId);

        List<SkillRequirement> skillReq = [SELECT Id,SkillLevel from SkillRequirement where RelatedRecordId = :wo.Id];
        System.assertEquals(1, skillReq.size(), 'Instead of an update to the Skill Level a New SKill Requirement was created');
        System.assertEquals(3, skillReq[0].SkillLevel, 'Skill Level was not updated with the higher skill level');

        SkillRequirement sr3 = new SkillRequirement(RelatedRecordId = woli.Id, SkillId = theSkills[1].Id, SkillLevel = 3);
        insert sr3;
        GDMFSL_WorkOrderLIProcessor.addWOLIRelatedRecordsToMaintPlanWOs(mpId);

    }

    @IsTest
    static void testAddNewWOLIRelatedRecordsToMaintPlanWOs() {
        WorkOrder wo = [SELECT Id FROM WorkOrder LIMIT 1];
        WorkType wt = [SELECT Id FROM WorkType LIMIT 1];
        List<Asset> a = [SELECT Id from Asset];
        MaintenancePlan mp = GDMFSL_DataFactory.createMaintenancePlan(wt.Id);
        insert mp;
        MaintenanceAsset ma = GDMFSL_DataFactory.createMaintenanceAsset(mp.Id, a[0].Id);
        insert ma;

        wo.MaintenancePlanId = mp.Id;
        wo.SuggestedMaintenanceDate = system.today();
        update wo;

        WorkOrderLineItem woli = GDMFSL_DataFactory.createWorkOrderLineItem(wt.Id, wo.Id, a[0].Id);
        insert woli;

        List<Skill> theSkills = [SELECT Id FROM Skill LIMIT 2];
        List<SkillRequirement> skr = new List<SkillRequirement>();

        SkillRequirement sr1 = new SkillRequirement(RelatedRecordId = woli.Id, SkillId = theSkills[0].Id, SkillLevel = 3);

        skr.add(sr1);
        insert skr;

        Set<Id> mpId = new Set<Id>();
        mpId.add(mp.Id);

        GDMFSL_WorkOrderLIProcessor.addWOLIRelatedRecordsToMaintPlanWOs(mpId);

        List<SkillRequirement> skillReq = [SELECT Id,SkillLevel from SkillRequirement where RelatedRecordId = :wo.Id];
        System.assertEquals(1, skillReq.size(), 'New SKill Req was not Added to WO');
        System.assertEquals(3, skillReq[0].SkillLevel, 'Skill Level was not correctly Derived');


    }
}