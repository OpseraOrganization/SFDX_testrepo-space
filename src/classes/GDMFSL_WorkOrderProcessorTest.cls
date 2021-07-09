/*******************************************************************************************
Name       :    GDMFSL_WorkOrderProcessorTest
Purpose    :    Test class for GDMFSL_WorkOrderProcessor.
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
Udbhav                  2020-Sep-09    Created
**********************************************************************************************/

@IsTest
public class GDMFSL_WorkOrderProcessorTest {

    @TestSetup
    static void setupData() {

        //Variations status transitions
        FSL.GlobalAPIS.addStatusTransition('None', 'Canceled');
        FSL.GlobalAPIS.addStatusTransition('None', 'Onsite');
        FSL.GlobalAPIS.addStatusTransition('Scheduled', 'Completed');
        FSL.GlobalAPIS.addStatusTransition('Scheduled', 'None');
        FSL.GlobalAPIS.addStatusTransition('None', 'Scheduled');

        Account acct = new Account(Name = 'Test Account', Phone = '1234561234', BillingStreet = 'Anywhere', BillingCity = 'City', BillingState = 'Florida', BillingCountry = 'United States');
        Id stdAcctRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Standard').getRecordTypeId();
        acct.RecordTypeId = stdAcctRecTypeId;
        acct.Source_System_Types__c = 'ShipTo';
        insert acct;

        List<Product2> prd = GDMFSL_DataFactory.createProducts('Test Product1', 1);
        insert prd;

        List<Asset> a = GDMFSL_DataFactory.createAssets('Test Asset1', prd[0].Id, acct.Id, 1);
        insert a;

        WorkType wtBF = GDMFSL_DataFactory.createWorkType('Break/Fix', 5);
        wtBF.GDMFSL_WorkType_Category__c = 'BF';
        insert wtBF;

        WorkType wtPM = GDMFSL_DataFactory.createWorkType('Preventive Maintenance1', 5);
        wtPM.GDMFSL_WorkType_Category__c = 'PM';
        insert wtPM;

        Pricebook2 thePriceBook = GDMFSL_DataFactory.createPriceBook('TestPriceBook');
        thePriceBook.GDMFSL_Default_Service_Offerings__c = true;
        insert thePriceBook;


        OperatingHours oh = GDMFSL_DataFactory.createOperatingHour();
        insert oh;

        ServiceTerritory servTerr = GDMFSL_DataFactory.createServiceTerritory('TestService Territory1', oh.Id);
        servTerr.GDMFSL_Price_Book__c = thePriceBook.Id;
        insert servTerr;


        PricebookEntry pricebookentry = GDMFSL_DataFactory.createPriceBookEntry(prd[0].Id);
        insert pricebookentry;

        PricebookEntry pricebookentryCustom = GDMFSL_DataFactory.createPriceBookEntry(prd[0].Id);
        pricebookentryCustom.Pricebook2Id = thePriceBook.Id;
        insert pricebookentryCustom;


        GDMFSL_Vertical__c vert = GDMFSL_DataFactory.createEnvironmentVertical('Test Vert1');
        insert vert;

        Schema.Location lo = GDMFSL_DataFactory.createLocation('Test Location1', servTerr.Id);
        lo.GDMFSL_SAP_Customer_Number__c = '12345';
//        lo.GDMFSL_Ship_To_Account__c = acct.Id;
        lo.GDMFSL_Working_Hours__c = oh.Id;
        insert lo;

        Source_System__c ss1 = GDMFSL_DataFactory.createSourceSystem(acct.Id, lo.GDMFSL_SAP_Customer_Number__c);
        ss1.Customer_Order_Block__c = true;
        ss1.GDMFSL_Delivery_Block__c = false;
        ss1.Source_System_Company_Id__c = ss1.Source_Id__c;
        ss1.Type__c = 'SHIPTO';
        insert ss1;

        Schema.Address addy = GDMFSL_DataFactory.createAddress('Anywhere', 'City', 'Florida', '123456', 'United States', lo.Id);
        insert addy;

        lo.GDMFSL_Address__c = addy.Id;
        update lo;

        Id servReqRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        Case ca = GDMFSL_DataFactory.createCase('APAC', a[0].Id);
        ca.RecordTypeId = servReqRecTypeId;
        insert ca;


        Time startTime = Time.newInstance(06, 00, 00, 00);
        Time endTime = Time.newInstance(14, 00, 00, 00);
        List<TimeSlot> timsSlots = new List<TimeSlot>();
        TimeSlot monTSlot = GDMFSL_DataFactory.createTimeSlot(oh.Id, 'Monday', startTime, endTime);
        timsSlots.add(monTSlot);
        TimeSlot tueTSlot = GDMFSL_DataFactory.createTimeSlot(oh.Id, 'Tuesday', startTime, endTime);
        timsSlots.add(tueTSlot);
        TimeSlot wedTSlot = GDMFSL_DataFactory.createTimeSlot(oh.Id, 'Wednesday', startTime, endTime);
        timsSlots.add(wedTSlot);
        TimeSlot thurTSlot = GDMFSL_DataFactory.createTimeSlot(oh.Id, 'Thursday', startTime, endTime);
        timsSlots.add(thurTSlot);
        TimeSlot friTSlot = GDMFSL_DataFactory.createTimeSlot(oh.Id, 'Friday', startTime, endTime);
        timsSlots.add(friTSlot);
        insert timsSlots;


        ServiceContract sc = GDMFSL_DataFactory.createServiceContract('Test Service Contract', acct.Id);
        sc.Pricebook2Id = thePriceBook.Id;
        insert sc;

        MaintenancePlan mp = GDMFSL_DataFactory.createMaintenancePlan(wtBF.Id);
        insert mp;

        MaintenanceAsset ma = GDMFSL_DataFactory.createMaintenanceAsset(mp.Id, a[0].Id);
        insert ma;

        MaintenanceWorkRule mwr = GDMFSL_DataFactory.createMaintenanceWorkRule(mp.Id, ma.Id, 'Test Maintenance Work Rule', 'FREQ=MONTHLY;BYMONTHDAY=1;INTERVAL=1');
        insert mwr;

        Source_System__c souSys = GDMFSL_DataFactory.createSourceSystem(acct.Id, 'SCID123');
        insert souSys;


        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(wtBF.Id, acct.Id, lo.Id, System.now(), System.now());
        wo.CaseId = ca.Id;
        wo.GDMFSL_PO_Number__c = '1234';
        wo.Subject = 'Test Work Order General';
        wo.AssetId = a[0].Id;
        wo.ServiceTerritoryId = servTerr.Id;
        wo.ServiceContractId = sc.Id;
        wo.MaintenancePlanId = mp.Id;
        wo.SuggestedMaintenanceDate = Date.today();
        wo.Priority = 'Low';
        wo.GDMFSL_Sold_To_Source_System_Reference__c = souSys.Id;

        insert wo;


        ServiceAppointment sa = GDMFSL_DataFactory.createServiceAppointment(acct.Id, 'Scheduled');
        sa.ParentRecordId = wo.Id;
        insert sa;

        WorkOrder woPM = GDMFSL_DataFactory.createWorkOrder(wtPM.Id, acct.Id, lo.Id, System.now(), System.now());
        woPM.CaseId = ca.Id;
        woPM.GDMFSL_PO_Number__c = '1234';
        woPM.Subject = 'Test Work Order General PM';
        woPM.AssetId = a[0].Id;
        woPM.ServiceTerritoryId = servTerr.Id;
        woPM.ServiceContractId = sc.Id;
        woPM.MaintenancePlanId = mp.Id;
        woPM.SuggestedMaintenanceDate = Date.today();
        woPM.Priority = 'Low';
        woPM.GDMFSL_Sold_To_Source_System_Reference__c = souSys.Id;

        insert woPM;


        ServiceAppointment saPM = GDMFSL_DataFactory.createServiceAppointment(acct.Id, 'Scheduled');
        saPM.ParentRecordId = woPM.Id;
        insert saPM;
        Test.startTest();
        WorkOrderLineItem woli = GDMFSL_DataFactory.createWorkOrderLineItem(wtBF.Id, wo.Id, a[0].Id);
        insert woli;

        WorkOrderLineItem woliPM = GDMFSL_DataFactory.createWorkOrderLineItem(wtPM.Id, woPM.Id, a[0].Id);
        insert woliPM;


        Id p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;

        User user = new User(Alias = 'work', Email = 'test123@noemail.com',
                EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US', ProfileId = p, Country = 'United States', IsActive = true,
                //  ContactId = cont.Id,
                TimeZoneSidKey = 'America/Los_Angeles', Username = 'workOrderProcessor@noemail.com');
        insert user;

        System.runAs(user) {
            PermissionSet pSetList = [SELECT Id FROM PermissionSet WHERE Name = 'FSL_Resource_Permissions'];
            PermissionSetAssignment pr = new PermissionSetAssignment (AssigneeId = user.Id, PermissionSetId = pSetList.Id);
            insert pr;
        }



        ServiceResource serRes = GDMFSL_DataFactory.createServiceResource(user.Id, lo.Id);
        insert serRes;

        ServiceTerritoryMember stm = new ServiceTerritoryMember(ServiceTerritoryId = servTerr.Id, ServiceResourceId = serRes.Id, TerritoryType = 'P', EffectiveStartDate = System.today());
        insert stm;

        List<ContentDocumentLink> listOfCdl = new List<ContentDocumentLink>();

        List <ContentVersion> contentVersionList = GDMFSL_DataFactory.createListOfContentVersions(10);

        insert contentVersionList;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        for (Integer i = 0; i < 10; i++) {
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.LinkedEntityId = ca.Id;
            cdl.ShareType = 'V';
            cdl.ContentDocumentId = documents[i].Id;
            listOfCdl.add(cdl);
        }

        insert listOfCdl;


        TimeSheet tiSheet = GDMFSL_DataFactory.createTimeSheet(Date.today(), Date.today().addDays(4), serRes.Id);
        insert tiSheet;


        Test.stopTest();

        ContractLineItem cli = GDMFSL_DataFactory.createCLI(sc.Id, pricebookentryCustom.Id);
        cli.Quantity = 1;
        cli.AssetId = a[0].Id;
        insert cli;

        GDMFSL_Associated_Contract__c ac = GDMFSL_DataFactory.createAssociatedContract(lo.Id, sc.Id, 60);
        insert ac;

        List<GDMFSL_SLA__c> slasToInset = new List<GDMFSL_SLA__c>();
        slasToInset.add(GDMFSL_DataFactory.createSLAforCLI(cli.Id, 'Low', 1, 1, 1));

        slasToInset.add(GDMFSL_DataFactory.createSLAforAssociatedContract(ac.Id, 'Low', 1, 1, 1));
        insert slasToInset;
    }


    @IsTest
    static void testCopyFilesFromCaseToWO() {
        Test.startTest();
        List<WorkOrder> workOrderToInsert = new List<WorkOrder>();

        WorkOrder woToUpdate = [SELECT Id, CaseId, WorkTypeId, WorkOrderNumber, LocationId, Subject FROM WorkOrder WHERE Subject = 'Test Work Order General' LIMIT 1];

        workOrderToInsert.add(woToUpdate);


        GDMFSL_WorkOrderProcessor.copyFilesFromCaseToWO(workOrderToInsert);


        List<ContentDocumentLink> cdl = [SELECT LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId = :woToUpdate.Id];
        Test.stopTest();
        System.assert(cdl.size() > 0);


    }

    @IsTest
    static void testSetSLAOnWOMPNull() {
        Test.startTest();
        List<WorkOrder> workOrderToInsert = new List<WorkOrder>();

        WorkOrder woToUpdate = [SELECT Id, CaseId, Priority, ServiceTerritoryId, CreatedDate, WorkTypeId,Work_Type_Category__c, SuggestedMaintenanceDate, MaintenanceWorkRuleId, StartDate, EndDate, GDMFSL_Arrival_Time__c, GDMFSL_Response_Time__c, MaintenancePlanId, ServiceContractId, AssetId, WorkOrderNumber, LocationId, Subject FROM WorkOrder WHERE Subject = 'Test Work Order General' LIMIT 1];
        woToUpdate.MaintenancePlanId = null;
        woToUpdate.SuggestedMaintenanceDate = null;


        update woToUpdate;
        workOrderToInsert.add(woToUpdate);
        GDMFSL_WorkOrderProcessor.setSLAOnWO(workOrderToInsert);

        WorkOrder woToUpdateFound = [SELECT Id, StartDate, EndDate, GDMFSL_Arrival_Time__c, GDMFSL_Response_Time__c FROM WorkOrder WHERE Subject = 'Test Work Order General' LIMIT 1];
        Test.stopTest();

        System.assert(woToUpdateFound.StartDate != null);
        System.assert(woToUpdateFound.EndDate != null);
        System.assert(woToUpdateFound.GDMFSL_Response_Time__c != null);
        System.assert(woToUpdateFound.GDMFSL_Arrival_Time__c != null);
    }

    @IsTest
    static void testSetSLAOnWONullAsset() {
        Test.startTest();
        List<WorkOrder> workOrderToInsert = new List<WorkOrder>();

        WorkOrder woToUpdate = [SELECT Id, CaseId, Priority, ServiceTerritoryId, CreatedDate, WorkTypeId,Work_Type_Category__c, SuggestedMaintenanceDate, MaintenanceWorkRuleId, StartDate, EndDate, GDMFSL_Arrival_Time__c, GDMFSL_Response_Time__c, MaintenancePlanId, ServiceContractId, AssetId, WorkOrderNumber, LocationId, Subject FROM WorkOrder WHERE Subject = 'Test Work Order General' LIMIT 1];
        woToUpdate.AssetId = null;


        update woToUpdate;
        workOrderToInsert.add(woToUpdate);
        GDMFSL_WorkOrderProcessor.setSLAOnWO(workOrderToInsert);
        WorkOrder woToUpdateFound = [SELECT Id, StartDate, EndDate, GDMFSL_Arrival_Time__c, GDMFSL_Response_Time__c FROM WorkOrder WHERE Subject = 'Test Work Order General' LIMIT 1];
        Test.stopTest();
        System.assert(woToUpdateFound.StartDate != null);
        System.assert(woToUpdateFound.EndDate != null);
        System.assert(woToUpdateFound.GDMFSL_Response_Time__c == null);
        System.assert(woToUpdateFound.GDMFSL_Arrival_Time__c == null);

    }
    @IsTest
    static void testSetSLAOnWOExtraTravel() {
        Test.startTest();
        List<WorkOrder> workOrderToInsert = new List<WorkOrder>();

        WorkOrder woToUpdate = [SELECT Id, CaseId, Priority, ServiceTerritoryId, CreatedDate, WorkTypeId,Work_Type_Category__c, SuggestedMaintenanceDate, MaintenanceWorkRuleId, StartDate, EndDate, GDMFSL_Arrival_Time__c, GDMFSL_Response_Time__c, MaintenancePlanId, ServiceContractId, AssetId, WorkOrderNumber, LocationId, Subject FROM WorkOrder WHERE Subject = 'Test Work Order General' LIMIT 1];
        woToUpdate.AssetId = null;

        Schema.Location lo = [SELECT GDMFSL_Extra_Travel_Time__c, GDMFSL_Region__c FROM Location LIMIT 1];
        lo.GDMFSL_Extra_Travel_Time__c = 5;
        lo.GDMFSL_Region__c = 'META';


        update lo;
        update woToUpdate;
        workOrderToInsert.add(woToUpdate);
        GDMFSL_WorkOrderProcessor.setSLAOnWO(workOrderToInsert);


        WorkOrder woToUpdateFound = [SELECT Id, StartDate, EndDate, GDMFSL_Arrival_Time__c, GDMFSL_Response_Time__c FROM WorkOrder WHERE Subject = 'Test Work Order General' LIMIT 1];
        Test.stopTest();
        System.assert(woToUpdateFound.StartDate != null);
        System.assert(woToUpdateFound.EndDate != null);
        System.assert(woToUpdateFound.GDMFSL_Response_Time__c == null);
        System.assert(woToUpdateFound.GDMFSL_Arrival_Time__c == null);

    }

    @IsTest
    static void testcalculateSLAStartDateNo24() {
        Test.startTest();
        GDMFSL_Associated_Contract__c ac = [
                SELECT Id, Service_Contract__r.GDMFSL_24HrCoverage_BusinessDays__c,
                        Service_Contract__r.GDMFSL_HolidayNoReactiveCoverage__c,
                        Service_Contract__r.GDMFSL_After_Hr_Reactive_Response__c,
                        Service_Contract__r.GDMFSL_Reactive_Work_Not_Chargeable__c,
                        Service_Contract__r.GDMFSL_Office_Hr_Reactive_Response__c,
                        Service_Contract__r.GDMFSL_X24hr_Reactive_Response__c
                FROM GDMFSL_Associated_Contract__c
                LIMIT 1
        ];
        ContractLineItem cli = [SELECT Id,GDMFSL_24HrCoverage_BusinessDays__c,GDMFSL_HolidayNoReactiveCoverage__c, GDMFSL_After_Hr_Reactive_Response__c, GDMFSL_Reactive_Work_Not_Chargeable__c FROM ContractLineItem LIMIT 1];
        cli.GDMFSL_24HrCoverage_BusinessDays__c = false;
        cli.GDMFSL_HolidayNoReactiveCoverage__c = true;
        cli.GDMFSL_After_Hr_Reactive_Response__c = true;
        update cli;


        WorkOrder woToTest = [SELECT Id, CaseId, Priority, ServiceTerritoryId, CreatedDate, WorkTypeId,Work_Type_Category__c, SuggestedMaintenanceDate, MaintenanceWorkRuleId, StartDate, EndDate, GDMFSL_Arrival_Time__c, GDMFSL_Response_Time__c, MaintenancePlanId, ServiceContractId, AssetId, WorkOrderNumber, LocationId, Subject FROM WorkOrder WHERE Subject = 'Test Work Order General' LIMIT 1];

        Datetime dt = GDMFSL_WorkOrderProcessor.calculateSLAStartDate(woToTest, ac, 30, Datetime.now());
        Test.stopTest();

        System.assert(dt != null);
    }

    @IsTest
    static void testcalculateSLAStartDateNo24Bus() {
        Test.startTest();
        GDMFSL_Associated_Contract__c ac = [
                SELECT Id, Service_Contract__r.GDMFSL_24HrCoverage_BusinessDays__c,
                        Service_Contract__r.GDMFSL_HolidayNoReactiveCoverage__c,
                        Service_Contract__r.GDMFSL_After_Hr_Reactive_Response__c,
                        Service_Contract__r.GDMFSL_Reactive_Work_Not_Chargeable__c,
                        Service_Contract__r.GDMFSL_Office_Hr_Reactive_Response__c,
                        Service_Contract__r.GDMFSL_X24hr_Reactive_Response__c
                FROM GDMFSL_Associated_Contract__c
                LIMIT 1
        ];
        ContractLineItem cli = [SELECT Id,GDMFSL_24HrCoverage_BusinessDays__c,GDMFSL_HolidayNoReactiveCoverage__c, GDMFSL_After_Hr_Reactive_Response__c, GDMFSL_Reactive_Work_Not_Chargeable__c FROM ContractLineItem LIMIT 1];
        cli.GDMFSL_24HrCoverage_BusinessDays__c = false;
        cli.GDMFSL_HolidayNoReactiveCoverage__c = true;
        cli.GDMFSL_Office_Hr_Reactive_Response__c = true;
        update cli;

        WorkOrder woToTest = [SELECT Id, CaseId, Priority, ServiceTerritoryId, CreatedDate, WorkTypeId,Work_Type_Category__c, SuggestedMaintenanceDate, MaintenanceWorkRuleId, StartDate, EndDate, GDMFSL_Arrival_Time__c, GDMFSL_Response_Time__c, MaintenancePlanId, ServiceContractId, AssetId, WorkOrderNumber, LocationId, Subject FROM WorkOrder WHERE Subject = 'Test Work Order General' LIMIT 1];

        Datetime dt = GDMFSL_WorkOrderProcessor.calculateSLAStartDate(woToTest, ac, 30, Datetime.now());
        Test.stopTest();
        System.assert(dt != null);
    }
    @IsTest
    static void testcalculateSLAStartDate24RR() {
        Test.startTest();
        GDMFSL_Associated_Contract__c ac = [
                SELECT Id, Service_Contract__r.GDMFSL_24HrCoverage_BusinessDays__c,
                        Service_Contract__r.GDMFSL_HolidayNoReactiveCoverage__c,
                        Service_Contract__r.GDMFSL_After_Hr_Reactive_Response__c,
                        Service_Contract__r.GDMFSL_Reactive_Work_Not_Chargeable__c,
                        Service_Contract__r.GDMFSL_Office_Hr_Reactive_Response__c,
                        Service_Contract__r.GDMFSL_X24hr_Reactive_Response__c
                FROM GDMFSL_Associated_Contract__c
                LIMIT 1
        ];
        ContractLineItem cli = [SELECT Id,GDMFSL_24HrCoverage_BusinessDays__c,GDMFSL_HolidayNoReactiveCoverage__c, GDMFSL_After_Hr_Reactive_Response__c, GDMFSL_Reactive_Work_Not_Chargeable__c FROM ContractLineItem LIMIT 1];
        cli.GDMFSL_24HrCoverage_BusinessDays__c = false;
        cli.GDMFSL_HolidayNoReactiveCoverage__c = true;
        cli.GDMFSL_X24hr_Reactive_Response__c = true;
        update cli;

        WorkOrder woToTest = [SELECT Id, CaseId, Priority, ServiceTerritoryId, CreatedDate, WorkTypeId,Work_Type_Category__c, SuggestedMaintenanceDate, MaintenanceWorkRuleId, StartDate, EndDate, GDMFSL_Arrival_Time__c, GDMFSL_Response_Time__c, MaintenancePlanId, ServiceContractId, AssetId, WorkOrderNumber, LocationId, Subject FROM WorkOrder WHERE Subject = 'Test Work Order General' LIMIT 1];

        Datetime dt = GDMFSL_WorkOrderProcessor.calculateSLAStartDate(woToTest, ac, 30, Datetime.now());
        Test.stopTest();
        System.assert(dt != null);
    }

    @IsTest
    static void testcalculateSLAStartDateNoHoliday() {
        Test.startTest();
        GDMFSL_Associated_Contract__c ac = [
                SELECT Id, Service_Contract__r.GDMFSL_24HrCoverage_BusinessDays__c,
                        Service_Contract__r.GDMFSL_HolidayNoReactiveCoverage__c,
                        Service_Contract__r.GDMFSL_After_Hr_Reactive_Response__c,
                        Service_Contract__r.GDMFSL_Reactive_Work_Not_Chargeable__c,
                        Service_Contract__r.GDMFSL_Office_Hr_Reactive_Response__c,
                        Service_Contract__r.GDMFSL_X24hr_Reactive_Response__c
                FROM GDMFSL_Associated_Contract__c
                LIMIT 1
        ];
        ContractLineItem cli = [SELECT Id,GDMFSL_24HrCoverage_BusinessDays__c,GDMFSL_HolidayNoReactiveCoverage__c, GDMFSL_After_Hr_Reactive_Response__c, GDMFSL_Reactive_Work_Not_Chargeable__c FROM ContractLineItem LIMIT 1];
        cli.GDMFSL_24HrCoverage_BusinessDays__c = true;
        cli.GDMFSL_HolidayNoReactiveCoverage__c = false;
        cli.GDMFSL_Office_Hr_Reactive_Response__c = true;
        update cli;

        WorkOrder woToTest = [SELECT Id, CaseId, Priority, ServiceTerritoryId, CreatedDate, WorkTypeId,Work_Type_Category__c, SuggestedMaintenanceDate, MaintenanceWorkRuleId, StartDate, EndDate, GDMFSL_Arrival_Time__c, GDMFSL_Response_Time__c, MaintenancePlanId, ServiceContractId, AssetId, WorkOrderNumber, LocationId, Subject FROM WorkOrder WHERE Subject = 'Test Work Order General' LIMIT 1];

        Datetime dt = GDMFSL_WorkOrderProcessor.calculateSLAStartDate(woToTest, ac, 30, Datetime.now());
        Test.stopTest();
        System.assert(dt != null);
    }

    @IsTest
    static void testcalculateSLAStartDateACTrue() {
        Test.startTest();
        GDMFSL_Associated_Contract__c ac = [
                SELECT Id, Service_Contract__r.GDMFSL_24HrCoverage_BusinessDays__c,
                        Service_Contract__r.GDMFSL_HolidayNoReactiveCoverage__c,
                        Service_Contract__r.GDMFSL_After_Hr_Reactive_Response__c,
                        Service_Contract__r.GDMFSL_Reactive_Work_Not_Chargeable__c,
                        Service_Contract__r.GDMFSL_Office_Hr_Reactive_Response__c,
                        Service_Contract__r.GDMFSL_X24hr_Reactive_Response__c
                FROM GDMFSL_Associated_Contract__c
                LIMIT 1
        ];
        ContractLineItem cli = [SELECT Id,GDMFSL_24HrCoverage_BusinessDays__c,GDMFSL_HolidayNoReactiveCoverage__c, GDMFSL_After_Hr_Reactive_Response__c, GDMFSL_Reactive_Work_Not_Chargeable__c FROM ContractLineItem LIMIT 1];
        cli.GDMFSL_24HrCoverage_BusinessDays__c = true;
        cli.GDMFSL_HolidayNoReactiveCoverage__c = true;
        cli.GDMFSL_After_Hr_Reactive_Response__c = true;
        cli.GDMFSL_Reactive_Work_Not_Chargeable__c = true;
        update cli;


        WorkOrder woToTest = [SELECT Id, CaseId, Priority, ServiceTerritoryId, CreatedDate, WorkTypeId,Work_Type_Category__c, SuggestedMaintenanceDate, MaintenanceWorkRuleId, StartDate, EndDate, GDMFSL_Arrival_Time__c, GDMFSL_Response_Time__c, MaintenancePlanId, ServiceContractId, AssetId, WorkOrderNumber, LocationId, Subject FROM WorkOrder WHERE Subject = 'Test Work Order General' LIMIT 1];

        Datetime dt = GDMFSL_WorkOrderProcessor.calculateSLAStartDate(woToTest, ac, 0, Datetime.now());
        Test.stopTest();
        System.assert(dt != null);
    }

    @IsTest
    static void testgetDateInWoOperatingHoursTimeZone() {
        Test.startTest();
        WorkOrder wo = [SELECT Id, LocationId, ServiceTerritoryId FROM WorkOrder WHERE Subject = 'Test Work Order General' LIMIT 1];


        Datetime dt = GDMFSL_WorkOrderProcessor.getDateInWoOperatingHoursTimeZone(wo, Datetime.now());
        Test.stopTest();
        System.assert(dt != null);

    }

    @IsTest
    static void testgetMaintPlanWOs() {
        Test.startTest();
        Set<Id> mainIds = new Set<Id>();
        WorkOrder wo = [SELECT Id, MaintenancePlanId FROM WorkOrder WHERE Subject = 'Test Work Order General' LIMIT 1];
        mainIds.add(wo.MaintenancePlanId);


        Map<Id, List<WorkOrder>> mp = GDMFSL_WorkOrderProcessor.getMaintPlanWOs(mainIds);
        Test.stopTest();

        System.assert(mp.size() > 0);

    }

    @IsTest
    static void testCreateRequireAssistWOs() {
        Test.startTest();
        Set<Id> mainIds = new Set<Id>();
        WorkOrder wo = [SELECT Id, MaintenancePlanId FROM WorkOrder WHERE Subject = 'Test Work Order General' LIMIT 1];
        mainIds.add(wo.MaintenancePlanId);


        GDMFSL_WorkOrderProcessor.createRequireAssistWOs(mainIds);


        List<WorkOrder> lstWo = [SELECT Id, MaintenancePlanId FROM WorkOrder WHERE MaintenancePlanId IN:mainIds];
        Test.stopTest();
        System.assert(lstWo.size() > 0);
    }

    @IsTest
    static void testExecute() {

        Test.startTest();
        List<WorkOrder> woLst = [SELECT Id FROM WorkOrder WHERE Subject = 'Test Work Order General'];
        GDMFSL_WorkOrderProcessor gdm = new GDMFSL_WorkOrderProcessor(woLst);
        System.enqueueJob(gdm);
        Test.stopTest();
    }

    //TODO: Research Inserts


    @IsTest
    static void makeData() {

        Test.startTest();
        Account acct = new Account(Name = 'Test Account', Phone = '1234561234', BillingStreet = 'Anywhere', BillingCity = 'City', BillingState = 'Florida', BillingCountry = 'United States');
        acct.Source_System_Types__c = 'ShipTo';
        insert acct;

        List<Product2> prd = GDMFSL_DataFactory.createProducts('Test Product', 1);
        insert prd;

        List<Asset> a = GDMFSL_DataFactory.createAssets('Test Asset', prd[0].Id, acct.Id, 1);
        insert a;

        WorkType wtBF = GDMFSL_DataFactory.createWorkType('Break/Fix', 5);
        wtBF.GDMFSL_WorkType_Category__c = 'BF';
        insert wtBF;

        WorkType wtPM = GDMFSL_DataFactory.createWorkType('Preventive Maintenance', 5);
        wtPM.GDMFSL_WorkType_Category__c = 'PM';
        insert wtPM;

        OperatingHours oh = [
                SELECT Id, TimeZone
                FROM OperatingHours
                LIMIT 1
        ];


        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(), IsActive = true);
        update standardPricebook;

        ServiceTerritory st = [SELECT Id FROM ServiceTerritory LIMIT 1];


        GDMFSL_Vertical__c vert = GDMFSL_DataFactory.createEnvironmentVertical('Test Vert');
        insert vert;

        Schema.Location lo = GDMFSL_DataFactory.createLocation('Test Location', st.Id);
        lo.GDMFSL_Vertical__c = vert.Id;
        lo.GDMFSL_Working_Hours__c = oh.Id;
        insert lo;

        Schema.Address addy = GDMFSL_DataFactory.createAddress('Anywhere', 'City', 'Florida', '123456', 'United States', lo.Id);
        insert addy;

        lo.GDMFSL_Address__c = addy.Id;
        update lo;

        Id servReqRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        Case ca = GDMFSL_DataFactory.createCase('APAC', a[0].Id);
        ca.RecordTypeId = servReqRecTypeId;
        insert ca;

        PricebookEntry pbe = GDMFSL_DataFactory.createPriceBookEntry(prd[0].Id);
        pbe.Pricebook2Id = standardPricebook.Id;
        insert pbe;

        ServiceContract servct = GDMFSL_DataFactory.createServiceContract('Test Service Contract', acct.Id);
        servct.Pricebook2Id = standardPricebook.Id;
        insert servct;

        ContractLineItem cli = GDMFSL_DataFactory.createCLI(servct.Id, pbe.Id);
        cli.Quantity = 1;
        cli.AssetId = a[0].Id;
        cli.GDMFSL_24HrCoverage_BusinessDays__c = true;
        cli.GDMFSL_HolidayNoReactiveCoverage__c = true;
        cli.GDMFSL_After_Hr_Reactive_Response__c = true;
        cli.GDMFSL_Reactive_Work_Not_Chargeable__c = true;

        insert cli;


        //Creating Service Terrritory for usage
        ServiceTerritory servTerr = GDMFSL_DataFactory.createServiceTerritory('Test Service Territory', oh.Id);
        insert servTerr;

        GDMFSL_Associated_Contract__c assoCont = GDMFSL_DataFactory.createAssociatedContract(lo.Id, servct.Id, 10);
        insert assoCont;


        GDMFSL_SLA__c sla = GDMFSL_DataFactory.createSLAforCLI(cli.Id, 'Low', 1, 1, 1);
        insert sla;

        GDMFSL_SLA__c slaAC = GDMFSL_DataFactory.createSLAforAssociatedContract(assoCont.Id, 'Low', 1, 1, 1);
        insert slaAC;


        List<WorkOrder> tobeInsertedWOs = new List<WorkOrder>();

        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(wtBF.Id, acct.Id, lo.Id, System.now(), System.now());
        wo.CaseId = ca.Id;
        wo.GDMFSL_PO_Number__c = '12345';
        wo.Subject = 'Test Work Order';
        wo.AssetId = a[0].Id;
        wo.ServiceContractId = servct.Id;
        wo.ServiceTerritoryId = servTerr.Id;
        wo.AccountId = acct.Id;
        tobeInsertedWOs.add(wo);

        insert tobeInsertedWOs;
        Test.stopTest();

    }

    @IsTest
    static void makeDataNot24() {

        Test.startTest();
        Account acct = new Account(Name = 'Test Account', Phone = '1234561234', BillingStreet = 'Anywhere', BillingCity = 'City', BillingState = 'Florida', BillingCountry = 'United States');
        acct.Source_System_Types__c = 'ShipTo';
        insert acct;

        List<Product2> prd = GDMFSL_DataFactory.createProducts('Test Product', 1);
        insert prd;

        List<Asset> a = GDMFSL_DataFactory.createAssets('Test Asset', prd[0].Id, acct.Id, 1);
        insert a;

        WorkType wtBF = GDMFSL_DataFactory.createWorkType('Break/Fix', 5);
        wtBF.GDMFSL_WorkType_Category__c = 'BF';
        insert wtBF;

        WorkType wtPM = GDMFSL_DataFactory.createWorkType('Preventive Maintenance', 5);
        wtPM.GDMFSL_WorkType_Category__c = 'PM';
        insert wtPM;

        OperatingHours oh = [
                SELECT Id, TimeZone
                FROM OperatingHours
                LIMIT 1
        ];


        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(), IsActive = true);
        update standardPricebook;

        ServiceTerritory st = [SELECT Id FROM ServiceTerritory LIMIT 1];


        GDMFSL_Vertical__c vert = GDMFSL_DataFactory.createEnvironmentVertical('Test Vert');
        insert vert;

        Schema.Location lo = GDMFSL_DataFactory.createLocation('Test Location', st.Id);
        lo.GDMFSL_Vertical__c = vert.Id;
        lo.GDMFSL_Working_Hours__c = oh.Id;
        insert lo;

        Schema.Address addy = GDMFSL_DataFactory.createAddress('Anywhere', 'City', 'Florida', '123456', 'United States', lo.Id);
        insert addy;

        lo.GDMFSL_Address__c = addy.Id;
        update lo;

        Id servReqRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        Case ca = GDMFSL_DataFactory.createCase('APAC', a[0].Id);
        ca.RecordTypeId = servReqRecTypeId;
        insert ca;

        PricebookEntry pbe = GDMFSL_DataFactory.createPriceBookEntry(prd[0].Id);
        pbe.Pricebook2Id = standardPricebook.Id;
        insert pbe;

        ServiceContract servct = GDMFSL_DataFactory.createServiceContract('Test Service Contract', acct.Id);
        servct.Pricebook2Id = standardPricebook.Id;
        insert servct;

        ContractLineItem cli = GDMFSL_DataFactory.createCLI(servct.Id, pbe.Id);
        cli.Quantity = 1;
        cli.AssetId = a[0].Id;
        cli.GDMFSL_24HrCoverage_BusinessDays__c = false;
        cli.GDMFSL_HolidayNoReactiveCoverage__c = true;
        cli.GDMFSL_After_Hr_Reactive_Response__c = true;

        insert cli;


        //Creating Service Terrritory for usage
        ServiceTerritory servTerr = GDMFSL_DataFactory.createServiceTerritory('Test Service Territory', oh.Id);
        insert servTerr;

        GDMFSL_Associated_Contract__c assoCont = GDMFSL_DataFactory.createAssociatedContract(lo.Id, servct.Id, 10);
        insert assoCont;


        GDMFSL_SLA__c sla = GDMFSL_DataFactory.createSLAforCLI(cli.Id, 'Low', 1, 1, 1);
        insert sla;

        GDMFSL_SLA__c slaAC = GDMFSL_DataFactory.createSLAforAssociatedContract(assoCont.Id, 'Low', 1, 1, 1);
        insert slaAC;


        List<WorkOrder> tobeInsertedWOs = new List<WorkOrder>();

        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(wtBF.Id, acct.Id, lo.Id, System.now(), System.now());
        wo.CaseId = ca.Id;
        wo.GDMFSL_PO_Number__c = '12345';
        wo.Subject = 'Test Work Order';
        wo.AssetId = a[0].Id;
        wo.ServiceContractId = servct.Id;
        wo.ServiceTerritoryId = servTerr.Id;
        wo.AccountId = acct.Id;
        tobeInsertedWOs.add(wo);

        insert tobeInsertedWOs;

        Test.stopTest();


    }


    @IsTest
    static void makeDataOfficeHourFullWeek() {

        Test.startTest();
        Account acct = new Account(Name = 'Test Account', Phone = '1234561234', BillingStreet = 'Anywhere', BillingCity = 'City', BillingState = 'Florida', BillingCountry = 'United States');
        acct.Source_System_Types__c = 'ShipTo';
        insert acct;

        List<Product2> prd = GDMFSL_DataFactory.createProducts('Test Product', 1);
        insert prd;

        List<Asset> a = GDMFSL_DataFactory.createAssets('Test Asset', prd[0].Id, acct.Id, 1);
        insert a;

        WorkType wtBF = GDMFSL_DataFactory.createWorkType('Break/Fix', 5);
        wtBF.GDMFSL_WorkType_Category__c = 'BF';
        insert wtBF;

        WorkType wtPM = GDMFSL_DataFactory.createWorkType('Preventive Maintenance', 5);
        wtPM.GDMFSL_WorkType_Category__c = 'PM';
        insert wtPM;

        OperatingHours oh = [
                SELECT Id, TimeZone
                FROM OperatingHours
                LIMIT 1
        ];


        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(), IsActive = true);
        update standardPricebook;

        ServiceTerritory st = [SELECT Id FROM ServiceTerritory LIMIT 1];


        GDMFSL_Vertical__c vert = GDMFSL_DataFactory.createEnvironmentVertical('Test Vert');
        insert vert;

        Schema.Location lo = GDMFSL_DataFactory.createLocation('Test Location', st.Id);
        lo.GDMFSL_Vertical__c = vert.Id;
        lo.GDMFSL_Working_Hours__c = oh.Id;
        insert lo;

        Schema.Address addy = GDMFSL_DataFactory.createAddress('Anywhere', 'City', 'Florida', '123456', 'United States', lo.Id);
        insert addy;

        lo.GDMFSL_Address__c = addy.Id;
        update lo;

        Id servReqRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        Case ca = GDMFSL_DataFactory.createCase('APAC', a[0].Id);
        ca.RecordTypeId = servReqRecTypeId;
        insert ca;

        PricebookEntry pbe = GDMFSL_DataFactory.createPriceBookEntry(prd[0].Id);
        pbe.Pricebook2Id = standardPricebook.Id;
        insert pbe;

        ServiceContract servct = GDMFSL_DataFactory.createServiceContract('Test Service Contract', acct.Id);
        servct.Pricebook2Id = standardPricebook.Id;
        insert servct;

        ContractLineItem cli = GDMFSL_DataFactory.createCLI(servct.Id, pbe.Id);
        cli.Quantity = 1;
        cli.AssetId = a[0].Id;
        cli.GDMFSL_24HrCoverage_BusinessDays__c = false;
        cli.GDMFSL_HolidayNoReactiveCoverage__c = true;
        cli.GDMFSL_Office_Hr_Reactive_Response__c = true;

        insert cli;


        //Creating Service Terrritory for usage
        ServiceTerritory servTerr = GDMFSL_DataFactory.createServiceTerritory('Test Service Territory', oh.Id);
        insert servTerr;

        GDMFSL_Associated_Contract__c assoCont = GDMFSL_DataFactory.createAssociatedContract(lo.Id, servct.Id, 10);
        insert assoCont;


        GDMFSL_SLA__c sla = GDMFSL_DataFactory.createSLAforCLI(cli.Id, 'Low', 1, 1, 1);
        insert sla;

        GDMFSL_SLA__c slaAC = GDMFSL_DataFactory.createSLAforAssociatedContract(assoCont.Id, 'Low', 1, 1, 1);
        insert slaAC;


        List<WorkOrder> tobeInsertedWOs = new List<WorkOrder>();

        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(wtBF.Id, acct.Id, lo.Id, System.now(), System.now());
        wo.CaseId = ca.Id;
        wo.GDMFSL_PO_Number__c = '12345';
        wo.Subject = 'Test Work Order';
        wo.AssetId = a[0].Id;
        wo.ServiceContractId = servct.Id;
        wo.ServiceTerritoryId = servTerr.Id;
        wo.AccountId = acct.Id;
        tobeInsertedWOs.add(wo);

        insert tobeInsertedWOs;

        Test.stopTest();


    }


    @IsTest
    static void makeDataOfficeHourSLA() {


        Test.startTest();
        Account acct = new Account(Name = 'Test Account', Phone = '1234561234', BillingStreet = 'Anywhere', BillingCity = 'City', BillingState = 'Florida', BillingCountry = 'United States');
        acct.Source_System_Types__c = 'ShipTo';
        insert acct;

        List<Product2> prd = GDMFSL_DataFactory.createProducts('Test Product', 1);
        insert prd;

        List<Asset> a = GDMFSL_DataFactory.createAssets('Test Asset', prd[0].Id, acct.Id, 1);
        insert a;

        WorkType wtBF = GDMFSL_DataFactory.createWorkType('Break/Fix', 5);
        wtBF.GDMFSL_WorkType_Category__c = 'BF';
        insert wtBF;

        WorkType wtPM = GDMFSL_DataFactory.createWorkType('Preventive Maintenance', 5);
        wtPM.GDMFSL_WorkType_Category__c = 'PM';
        insert wtPM;

        OperatingHours oh = [
                SELECT Id, TimeZone
                FROM OperatingHours
                LIMIT 1
        ];


        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(), IsActive = true);
        update standardPricebook;

        ServiceTerritory st = [SELECT Id FROM ServiceTerritory LIMIT 1];


        GDMFSL_Vertical__c vert = GDMFSL_DataFactory.createEnvironmentVertical('Test Vert');
        insert vert;

        Schema.Location lo = GDMFSL_DataFactory.createLocation('Test Location', st.Id);
        lo.GDMFSL_Vertical__c = vert.Id;
        lo.GDMFSL_Working_Hours__c = oh.Id;
        insert lo;

        Schema.Address addy = GDMFSL_DataFactory.createAddress('Anywhere', 'City', 'Florida', '123456', 'United States', lo.Id);
        insert addy;

        lo.GDMFSL_Address__c = addy.Id;
        update lo;

        Id servReqRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        Case ca = GDMFSL_DataFactory.createCase('APAC', a[0].Id);
        ca.RecordTypeId = servReqRecTypeId;
        insert ca;

        PricebookEntry pbe = GDMFSL_DataFactory.createPriceBookEntry(prd[0].Id);
        pbe.Pricebook2Id = standardPricebook.Id;
        insert pbe;

        ServiceContract servct = GDMFSL_DataFactory.createServiceContract('Test Service Contract', acct.Id);
        servct.Pricebook2Id = standardPricebook.Id;
        insert servct;

        ContractLineItem cli = GDMFSL_DataFactory.createCLI(servct.Id, pbe.Id);
        cli.Quantity = 1;
        cli.AssetId = a[0].Id;
        cli.GDMFSL_24HrCoverage_BusinessDays__c = false;
        cli.GDMFSL_HolidayNoReactiveCoverage__c = true;
        cli.GDMFSL_Office_Hr_Reactive_Response__c = true;

        insert cli;


        //Creating Service Terrritory for usage
        ServiceTerritory servTerr = GDMFSL_DataFactory.createServiceTerritory('Test Service Territory', oh.Id);
        insert servTerr;


        GDMFSL_Associated_Contract__c assoCont = GDMFSL_DataFactory.createAssociatedContract(lo.Id, servct.Id, 10);
        insert assoCont;


        GDMFSL_SLA__c sla = GDMFSL_DataFactory.createSLAforCLI(cli.Id, 'Low', 1, 1, 1);
        insert sla;

        GDMFSL_SLA__c slaAC = GDMFSL_DataFactory.createSLAforAssociatedContract(assoCont.Id, 'Low', 1, 1, 1);
        insert slaAC;


        List<WorkOrder> tobeInsertedWOs = new List<WorkOrder>();

        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(wtBF.Id, acct.Id, lo.Id, System.now(), System.now());
        wo.CaseId = ca.Id;
        wo.GDMFSL_PO_Number__c = '12345';
        wo.Subject = 'Test Work Order';
        wo.AssetId = a[0].Id;
        wo.ServiceContractId = servct.Id;
        wo.ServiceTerritoryId = servTerr.Id;
        wo.AccountId = acct.Id;
        tobeInsertedWOs.add(wo);

        insert tobeInsertedWOs;

        Test.stopTest();


    }


    @IsTest
    static void makeDataOfficeHourSLAwithHoliday() {


        Test.startTest();
        Account acct = new Account(Name = 'Test Account', Phone = '1234561234', BillingStreet = 'Anywhere', BillingCity = 'City', BillingState = 'Florida', BillingCountry = 'United States');
        acct.Source_System_Types__c = 'ShipTo';
        insert acct;

        List<Product2> prd = GDMFSL_DataFactory.createProducts('Test Product', 1);
        insert prd;

        List<Asset> a = GDMFSL_DataFactory.createAssets('Test Asset', prd[0].Id, acct.Id, 1);
        insert a;

        WorkType wtBF = GDMFSL_DataFactory.createWorkType('Break/Fix', 5);
        wtBF.GDMFSL_WorkType_Category__c = 'BF';
        insert wtBF;

        WorkType wtPM = GDMFSL_DataFactory.createWorkType('Preventive Maintenance', 5);
        wtPM.GDMFSL_WorkType_Category__c = 'PM';
        insert wtPM;

        OperatingHours oh = [
                SELECT Id, TimeZone
                FROM OperatingHours
                LIMIT 1
        ];


        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(), IsActive = true);
        update standardPricebook;

        ServiceTerritory st = [SELECT Id FROM ServiceTerritory LIMIT 1];


        GDMFSL_Vertical__c vert = GDMFSL_DataFactory.createEnvironmentVertical('Test Vert');
        insert vert;

        Schema.Location lo = GDMFSL_DataFactory.createLocation('Test Location', st.Id);
        lo.GDMFSL_Vertical__c = vert.Id;
        lo.GDMFSL_Working_Hours__c = oh.Id;
        insert lo;

        Schema.Address addy = GDMFSL_DataFactory.createAddress('Anywhere', 'City', 'Florida', '123456', 'United States', lo.Id);
        insert addy;

        lo.GDMFSL_Address__c = addy.Id;
        update lo;

        Id servReqRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        Case ca = GDMFSL_DataFactory.createCase('APAC', a[0].Id);
        ca.RecordTypeId = servReqRecTypeId;
        insert ca;

        PricebookEntry pbe = GDMFSL_DataFactory.createPriceBookEntry(prd[0].Id);
        pbe.Pricebook2Id = standardPricebook.Id;
        insert pbe;

        ServiceContract servct = GDMFSL_DataFactory.createServiceContract('Test Service Contract', acct.Id);
        servct.Pricebook2Id = standardPricebook.Id;
        insert servct;

        ContractLineItem cli = GDMFSL_DataFactory.createCLI(servct.Id, pbe.Id);
        cli.Quantity = 1;
        cli.AssetId = a[0].Id;
        cli.GDMFSL_24HrCoverage_BusinessDays__c = false;
        cli.GDMFSL_HolidayNoReactiveCoverage__c = true;
        cli.GDMFSL_X24hr_Reactive_Response__c = true;

        insert cli;


        //Creating Service Terrritory for usage
        ServiceTerritory servTerr = GDMFSL_DataFactory.createServiceTerritory('Test Service Territory', oh.Id);
        insert servTerr;


        GDMFSL_Associated_Contract__c assoCont = GDMFSL_DataFactory.createAssociatedContract(lo.Id, servct.Id, 10);
        insert assoCont;


        GDMFSL_SLA__c sla = GDMFSL_DataFactory.createSLAforCLI(cli.Id, 'Low', 35, 20, 40);
        insert sla;

        GDMFSL_SLA__c slaAC = GDMFSL_DataFactory.createSLAforAssociatedContract(assoCont.Id, 'Low', 1, 1, 1);
        insert slaAC;


        List<WorkOrder> tobeInsertedWOs = new List<WorkOrder>();

        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(wtBF.Id, acct.Id, lo.Id, System.now(), System.now());
        wo.CaseId = ca.Id;
        wo.GDMFSL_PO_Number__c = '12345';
        wo.Subject = 'Test Work Order';
        wo.AssetId = a[0].Id;
        wo.ServiceContractId = servct.Id;
        wo.ServiceTerritoryId = servTerr.Id;
        wo.AccountId = acct.Id;
        tobeInsertedWOs.add(wo);

        insert tobeInsertedWOs;

        Test.stopTest();


    }


    @IsTest
    static void testSetSLAOnWOElse() {

        Test.startTest();
        Account acct = new Account(Name = 'Test Account', Phone = '1234561234', BillingStreet = 'Anywhere', BillingCity = 'City', BillingState = 'Florida', BillingCountry = 'United States');
        acct.Source_System_Types__c = 'ShipTo';
        insert acct;

        List<Product2> prd = GDMFSL_DataFactory.createProducts('Test Product', 1);
        insert prd;

        List<Asset> a = GDMFSL_DataFactory.createAssets('Test Asset', prd[0].Id, acct.Id, 1);
        insert a;

        WorkType wtBF = GDMFSL_DataFactory.createWorkType('Break/Fix', 5);
        wtBF.GDMFSL_WorkType_Category__c = 'BF';
        insert wtBF;

        WorkType wtPM = GDMFSL_DataFactory.createWorkType('Preventive Maintenance', 5);
        wtPM.GDMFSL_WorkType_Category__c = 'PM';
        insert wtPM;

        OperatingHours oh = GDMFSL_DataFactory.createOperatingHour();
        insert oh;


        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(), IsActive = true);
        update standardPricebook;

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('CaseProc Test', oh.Id);
        st.GDMFSL_Price_Book__c = standardPricebook.Id;
        insert st;

        GDMFSL_Vertical__c vert = GDMFSL_DataFactory.createEnvironmentVertical('Test Vert');
        insert vert;

        Schema.Location lo = GDMFSL_DataFactory.createLocation('Test Location', st.Id);
        lo.GDMFSL_Vertical__c = vert.Id;
        lo.GDMFSL_Working_Hours__c = oh.Id;
        insert lo;

        Schema.Address addy = GDMFSL_DataFactory.createAddress('Anywhere', 'City', 'Florida', '123456', 'United States', lo.Id);
        insert addy;

        lo.GDMFSL_Address__c = addy.Id;
        update lo;

        Id servReqRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        Case ca = GDMFSL_DataFactory.createCase('APAC', a[0].Id);
        ca.RecordTypeId = servReqRecTypeId;
        insert ca;

        PricebookEntry pbe = GDMFSL_DataFactory.createPriceBookEntry(prd[0].Id);
        pbe.Pricebook2Id = standardPricebook.Id;
        insert pbe;

        ServiceContract servct = GDMFSL_DataFactory.createServiceContract('Test Service Contract', acct.Id);
        servct.Pricebook2Id = standardPricebook.Id;
        insert servct;

        ContractLineItem cli = GDMFSL_DataFactory.createCLI(servct.Id, pbe.Id);
        cli.Quantity = 1;
        cli.AssetId = a[0].Id;
        insert cli;


        //Creating Service Terrritory for usage
        ServiceTerritory servTerr = GDMFSL_DataFactory.createServiceTerritory('Test Service Territory', oh.Id);
        insert servTerr;


        GDMFSL_Associated_Contract__c assoCont = GDMFSL_DataFactory.createAssociatedContract(lo.Id, servct.Id, 10);
        insert assoCont;


        GDMFSL_SLA__c sla = GDMFSL_DataFactory.createSLAforCLI(cli.Id, 'Low', 1, 1, 1);
        insert sla;

        GDMFSL_SLA__c slaAC = GDMFSL_DataFactory.createSLAforAssociatedContract(assoCont.Id, 'Low', 1, 1, 1);
        insert slaAC;


        List<WorkOrder> tobeInsertedWOs = new List<WorkOrder>();

        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(wtBF.Id, acct.Id, lo.Id, System.now(), System.now());
        wo.CaseId = ca.Id;
        wo.GDMFSL_PO_Number__c = '12345';
        wo.Subject = 'Test Work Order';
        wo.AssetId = null;
        wo.ServiceContractId = servct.Id;
        wo.ServiceTerritoryId = servTerr.Id;
        wo.AccountId = acct.Id;
        tobeInsertedWOs.add(wo);

        insert tobeInsertedWOs;


        Test.stopTest();

    }

    @IsTest
    static void testSetSLAOnWOElse2() {


        Test.startTest();
        Account acct = new Account(Name = 'Test Account', Phone = '1234561234', BillingStreet = 'Anywhere', BillingCity = 'City', BillingState = 'Florida', BillingCountry = 'United States');
        acct.Source_System_Types__c = 'ShipTo';
        insert acct;

        List<Product2> prd = GDMFSL_DataFactory.createProducts('Test Product', 1);
        insert prd;

        List<Asset> a = GDMFSL_DataFactory.createAssets('Test Asset', prd[0].Id, acct.Id, 1);
        insert a;

        WorkType wtBF = GDMFSL_DataFactory.createWorkType('Break/Fix', 5);
        wtBF.GDMFSL_WorkType_Category__c = 'BF';
        insert wtBF;

        WorkType wtPM = GDMFSL_DataFactory.createWorkType('Preventive Maintenance', 5);
        wtPM.GDMFSL_WorkType_Category__c = 'PM';
        insert wtPM;

        OperatingHours oh = GDMFSL_DataFactory.createOperatingHour();
        insert oh;


        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(), IsActive = true);
        update standardPricebook;

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('CaseProc Test', oh.Id);
        st.GDMFSL_Price_Book__c = standardPricebook.Id;
        insert st;

        GDMFSL_Vertical__c vert = GDMFSL_DataFactory.createEnvironmentVertical('Test Vert');
        insert vert;

        Schema.Location lo = GDMFSL_DataFactory.createLocation('Test Location', st.Id);
        lo.GDMFSL_Vertical__c = vert.Id;
        lo.GDMFSL_Working_Hours__c = oh.Id;
        lo.GDMFSL_Extra_Travel_Time__c = 5;
        lo.GDMFSL_Region__c = 'META';
        insert lo;

        Schema.Address addy = GDMFSL_DataFactory.createAddress('Anywhere', 'City', 'Florida', '123456', 'United States', lo.Id);
        insert addy;

        lo.GDMFSL_Address__c = addy.Id;
        update lo;

        Id servReqRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        Case ca = GDMFSL_DataFactory.createCase('APAC', a[0].Id);
        ca.RecordTypeId = servReqRecTypeId;
        insert ca;

        PricebookEntry pbe = GDMFSL_DataFactory.createPriceBookEntry(prd[0].Id);
        pbe.Pricebook2Id = standardPricebook.Id;
        insert pbe;

        ServiceContract servct = GDMFSL_DataFactory.createServiceContract('Test Service Contract', acct.Id);
        servct.Pricebook2Id = standardPricebook.Id;
        insert servct;

        ContractLineItem cli = GDMFSL_DataFactory.createCLI(servct.Id, pbe.Id);
        cli.Quantity = 1;
        cli.AssetId = a[0].Id;
        insert cli;


        //Creating Service Terrritory for usage
        ServiceTerritory servTerr = GDMFSL_DataFactory.createServiceTerritory('Test Service Territory', oh.Id);
        insert servTerr;

        MaintenancePlan mp = GDMFSL_DataFactory.createMaintenancePlan(wtBF.Id);
        insert mp;

        MaintenanceAsset ma = GDMFSL_DataFactory.createMaintenanceAsset(mp.Id, a[0].Id);
        insert ma;

        MaintenanceWorkRule mwr = GDMFSL_DataFactory.createMaintenanceWorkRule(mp.Id, ma.Id, 'Test Maintenance Work Rule', 'FREQ=MONTHLY;BYMONTHDAY=1;INTERVAL=1');
        insert mwr;

        GDMFSL_Associated_Contract__c assoCont = GDMFSL_DataFactory.createAssociatedContract(lo.Id, servct.Id, 10);
        insert assoCont;


        GDMFSL_SLA__c sla = GDMFSL_DataFactory.createSLAforCLI(cli.Id, 'Low', 1, 1, 1);
        insert sla;

        GDMFSL_SLA__c slaAC = GDMFSL_DataFactory.createSLAforAssociatedContract(assoCont.Id, 'Low', 1, 1, 1);
        insert slaAC;


        List<WorkOrder> tobeInsertedWOs = new List<WorkOrder>();

        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(wtBF.Id, acct.Id, lo.Id, System.now(), System.now());
        wo.CaseId = ca.Id;
        wo.GDMFSL_PO_Number__c = '12345';
        wo.Subject = 'Test Work Order';
        wo.AssetId = null;
        wo.ServiceContractId = servct.Id;
        wo.ServiceTerritoryId = servTerr.Id;
        wo.AccountId = acct.Id;
        wo.MaintenancePlanId = mp.Id;
        wo.SuggestedMaintenanceDate = Date.today();
        wo.Priority = 'Low';
        tobeInsertedWOs.add(wo);

        insert tobeInsertedWOs;

        Test.stopTest();
    }


    @IsTest
    static void testCheckOrGetNextBusinessDay() {

        Test.startTest();
        Account acct = new Account(Name = 'Test Account', Phone = '1234561234', BillingStreet = 'Anywhere', BillingCity = 'City', BillingState = 'Florida', BillingCountry = 'United States');
        acct.Source_System_Types__c = 'ShipTo';
        insert acct;

        List<Product2> prd = GDMFSL_DataFactory.createProducts('Test Product', 1);
        insert prd;

        List<Asset> a = GDMFSL_DataFactory.createAssets('Test Asset', prd[0].Id, acct.Id, 1);
        insert a;

        WorkType wtBF = GDMFSL_DataFactory.createWorkType('Break/Fix', 5);
        wtBF.GDMFSL_WorkType_Category__c = 'BF';
        insert wtBF;

        WorkType wtPM = GDMFSL_DataFactory.createWorkType('Preventive Maintenance', 5);
        wtPM.GDMFSL_WorkType_Category__c = 'PM';
        insert wtPM;

        OperatingHours oh = GDMFSL_DataFactory.createOperatingHour();
        insert oh;


        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(), IsActive = true);
        update standardPricebook;

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('CaseProc Test', oh.Id);
        st.GDMFSL_Price_Book__c = standardPricebook.Id;
        insert st;

        GDMFSL_Vertical__c vert = GDMFSL_DataFactory.createEnvironmentVertical('Test Vert');
        insert vert;

        Schema.Location lo = GDMFSL_DataFactory.createLocation('Test Location', st.Id);
        lo.GDMFSL_Vertical__c = vert.Id;
        lo.GDMFSL_Working_Hours__c = oh.Id;
        insert lo;

        Schema.Address addy = GDMFSL_DataFactory.createAddress('Anywhere', 'City', 'Florida', '123456', 'United States', lo.Id);
        insert addy;

        lo.GDMFSL_Address__c = addy.Id;
        update lo;

        Id servReqRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        Case ca = GDMFSL_DataFactory.createCase('APAC', a[0].Id);
        ca.RecordTypeId = servReqRecTypeId;
        insert ca;

        PricebookEntry pbe = GDMFSL_DataFactory.createPriceBookEntry(prd[0].Id);
        pbe.Pricebook2Id = standardPricebook.Id;
        insert pbe;

        ServiceContract servct = GDMFSL_DataFactory.createServiceContract('Test Service Contract', acct.Id);
        servct.Pricebook2Id = standardPricebook.Id;
        insert servct;

        ContractLineItem cli = GDMFSL_DataFactory.createCLI(servct.Id, pbe.Id);
        cli.Quantity = 1;
        cli.AssetId = a[0].Id;
        insert cli;


        //Creating Service Terrritory for usage
        ServiceTerritory servTerr = GDMFSL_DataFactory.createServiceTerritory('Test Service Territory', oh.Id);
        insert servTerr;


        GDMFSL_Associated_Contract__c assoCont = GDMFSL_DataFactory.createAssociatedContract(lo.Id, servct.Id, 10);
        insert assoCont;


        GDMFSL_SLA__c sla = GDMFSL_DataFactory.createSLAforCLI(cli.Id, 'Low', 1, 1, 1);
        insert sla;

        GDMFSL_SLA__c slaAC = GDMFSL_DataFactory.createSLAforAssociatedContract(assoCont.Id, 'Low', 1, 1, 1);
        insert slaAC;


        List<WorkOrder> tobeInsertedWOs = new List<WorkOrder>();

        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(wtBF.Id, acct.Id, lo.Id, System.now(), System.now());
        wo.CaseId = ca.Id;
        wo.GDMFSL_PO_Number__c = '12345';
        wo.Subject = 'Test Work Order';
        wo.AssetId = null;
        wo.ServiceTerritoryId = servTerr.Id;
        tobeInsertedWOs.add(wo);

        insert tobeInsertedWOs;

        Test.stopTest();


    }


    @IsTest
    static void testCheckOrGetNextBusinessDayFalse() {


        Test.startTest();
        Account acct = new Account(Name = 'Test Account', Phone = '1234561234', BillingStreet = 'Anywhere', BillingCity = 'City', BillingState = 'Florida', BillingCountry = 'United States');
        acct.Source_System_Types__c = 'ShipTo';
        insert acct;

        List<Product2> prd = GDMFSL_DataFactory.createProducts('Test Product', 1);
        insert prd;

        List<Asset> a = GDMFSL_DataFactory.createAssets('Test Asset', prd[0].Id, acct.Id, 1);
        insert a;

        WorkType wtBF = GDMFSL_DataFactory.createWorkType('Break/Fix', 5);
        wtBF.GDMFSL_WorkType_Category__c = 'BF';
        insert wtBF;

        WorkType wtPM = GDMFSL_DataFactory.createWorkType('Preventive Maintenance', 5);
        wtPM.GDMFSL_WorkType_Category__c = 'PM';
        insert wtPM;

        OperatingHours oh = GDMFSL_DataFactory.createOperatingHour();
        insert oh;


        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(), IsActive = true);
        update standardPricebook;

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('CaseProc Test', oh.Id);
        st.GDMFSL_Price_Book__c = standardPricebook.Id;
        insert st;

        GDMFSL_Vertical__c vert = GDMFSL_DataFactory.createEnvironmentVertical('Test Vert');
        insert vert;

        Schema.Location lo = GDMFSL_DataFactory.createLocation('Test Location', st.Id);
        lo.GDMFSL_Vertical__c = vert.Id;
        lo.GDMFSL_Working_Hours__c = oh.Id;
        insert lo;

        Schema.Address addy = GDMFSL_DataFactory.createAddress('Anywhere', 'City', 'Florida', '123456', 'United States', lo.Id);
        insert addy;

        lo.GDMFSL_Address__c = addy.Id;
        update lo;

        Id servReqRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        Case ca = GDMFSL_DataFactory.createCase('APAC', a[0].Id);
        ca.RecordTypeId = servReqRecTypeId;
        insert ca;

        PricebookEntry pbe = GDMFSL_DataFactory.createPriceBookEntry(prd[0].Id);
        pbe.Pricebook2Id = standardPricebook.Id;
        insert pbe;

        ServiceContract servct = GDMFSL_DataFactory.createServiceContract('Test Service Contract', acct.Id);
        servct.Pricebook2Id = standardPricebook.Id;
        insert servct;

        ContractLineItem cli = GDMFSL_DataFactory.createCLI(servct.Id, pbe.Id);
        cli.Quantity = 1;
        cli.AssetId = a[0].Id;
        insert cli;


        //Creating Service Terrritory for usage
        ServiceTerritory servTerr = GDMFSL_DataFactory.createServiceTerritory('Test Service Territory', oh.Id);
        insert servTerr;


        GDMFSL_Associated_Contract__c assoCont = GDMFSL_DataFactory.createAssociatedContract(lo.Id, servct.Id, 10);
        insert assoCont;


        GDMFSL_SLA__c sla = GDMFSL_DataFactory.createSLAforCLI(cli.Id, 'Low', 1, 1, 1);
        insert sla;

        GDMFSL_SLA__c slaAC = GDMFSL_DataFactory.createSLAforAssociatedContract(assoCont.Id, 'Low', 1, 1, 1);
        insert slaAC;


        List<WorkOrder> tobeInsertedWOs = new List<WorkOrder>();

        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(wtBF.Id, acct.Id, lo.Id, System.now(), System.now());
        wo.CaseId = ca.Id;
        wo.GDMFSL_PO_Number__c = '12345';
        wo.Subject = 'Test Work Order';
        wo.AssetId = null;
        wo.ServiceTerritoryId = servTerr.Id;
        tobeInsertedWOs.add(wo);

        insert tobeInsertedWOs;


        Datetime dt = GDMFSL_WorkOrderProcessor.checkOrGetNextBusinessDay(oh.Id, Datetime.now(), false, false);
        Test.stopTest();
        System.assert(dt != null);


    }

    @IsTest
    static void testGetDateAfterAddingHours() {

        Test.startTest();
        Account acct = new Account(Name = 'Test Account', Phone = '1234561234', BillingStreet = 'Anywhere', BillingCity = 'City', BillingState = 'Florida', BillingCountry = 'United States');
        acct.Source_System_Types__c = 'ShipTo';
        insert acct;

        List<Product2> prd = GDMFSL_DataFactory.createProducts('Test Product', 1);
        insert prd;

        List<Asset> a = GDMFSL_DataFactory.createAssets('Test Asset', prd[0].Id, acct.Id, 1);
        insert a;

        WorkType wtBF = GDMFSL_DataFactory.createWorkType('Break/Fix', 5);
        wtBF.GDMFSL_WorkType_Category__c = 'BF';
        insert wtBF;

        WorkType wtPM = GDMFSL_DataFactory.createWorkType('Preventive Maintenance', 5);
        wtPM.GDMFSL_WorkType_Category__c = 'PM';
        insert wtPM;

        OperatingHours oh = GDMFSL_DataFactory.createOperatingHour();
        insert oh;


        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(), IsActive = true);
        update standardPricebook;

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('CaseProc Test', oh.Id);
        st.GDMFSL_Price_Book__c = standardPricebook.Id;
        insert st;

        GDMFSL_Vertical__c vert = GDMFSL_DataFactory.createEnvironmentVertical('Test Vert');
        insert vert;

        Schema.Location lo = GDMFSL_DataFactory.createLocation('Test Location', st.Id);
        lo.GDMFSL_Vertical__c = vert.Id;
        lo.GDMFSL_Working_Hours__c = oh.Id;
        insert lo;

        Schema.Address addy = GDMFSL_DataFactory.createAddress('Anywhere', 'City', 'Florida', '123456', 'United States', lo.Id);
        insert addy;

        lo.GDMFSL_Address__c = addy.Id;
        update lo;

        Id servReqRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        Case ca = GDMFSL_DataFactory.createCase('APAC', a[0].Id);
        ca.RecordTypeId = servReqRecTypeId;
        insert ca;

        PricebookEntry pbe = GDMFSL_DataFactory.createPriceBookEntry(prd[0].Id);
        pbe.Pricebook2Id = standardPricebook.Id;
        insert pbe;

        ServiceContract servct = GDMFSL_DataFactory.createServiceContract('Test Service Contract', acct.Id);
        servct.Pricebook2Id = standardPricebook.Id;
        insert servct;

        ContractLineItem cli = GDMFSL_DataFactory.createCLI(servct.Id, pbe.Id);
        cli.Quantity = 1;
        cli.AssetId = a[0].Id;
        insert cli;


        //Creating Service Terrritory for usage
        ServiceTerritory servTerr = GDMFSL_DataFactory.createServiceTerritory('Test Service Territory', oh.Id);
        insert servTerr;


        GDMFSL_Associated_Contract__c assoCont = GDMFSL_DataFactory.createAssociatedContract(lo.Id, servct.Id, 10);
        insert assoCont;


        GDMFSL_SLA__c sla = GDMFSL_DataFactory.createSLAforCLI(cli.Id, 'Low', 1, 1, 1);
        insert sla;

        GDMFSL_SLA__c slaAC = GDMFSL_DataFactory.createSLAforAssociatedContract(assoCont.Id, 'Low', 1, 1, 1);
        insert slaAC;


        List<WorkOrder> tobeInsertedWOs = new List<WorkOrder>();

        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(wtBF.Id, acct.Id, lo.Id, System.now(), System.now());
        wo.CaseId = ca.Id;
        wo.GDMFSL_PO_Number__c = '12345';
        wo.Subject = 'Test Work Order';
        wo.AssetId = null;
        wo.ServiceTerritoryId = servTerr.Id;
        tobeInsertedWOs.add(wo);

        insert tobeInsertedWOs;


        Datetime dt = GDMFSL_WorkOrderProcessor.getDateAfterAddingHours(oh.Id, Datetime.now().addDays(5), 20, false, false, true);
        Test.stopTest();

        System.assert(dt != null);


    }

    @IsTest
    static void testGetDateAfterAddingHoursElse() {
        Test.startTest();
        Account acct = new Account(Name = 'Test Account', Phone = '1234561234', BillingStreet = 'Anywhere', BillingCity = 'City', BillingState = 'Florida', BillingCountry = 'United States');
        acct.Source_System_Types__c = 'ShipTo';
        insert acct;

        List<Product2> prd = GDMFSL_DataFactory.createProducts('Test Product', 1);
        insert prd;

        List<Asset> a = GDMFSL_DataFactory.createAssets('Test Asset', prd[0].Id, acct.Id, 1);
        insert a;

        WorkType wtBF = GDMFSL_DataFactory.createWorkType('Break/Fix', 5);
        wtBF.GDMFSL_WorkType_Category__c = 'BF';
        insert wtBF;

        WorkType wtPM = GDMFSL_DataFactory.createWorkType('Preventive Maintenance', 5);
        wtPM.GDMFSL_WorkType_Category__c = 'PM';
        insert wtPM;

        OperatingHours oh = GDMFSL_DataFactory.createOperatingHour();
        insert oh;


        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(), IsActive = true);
        update standardPricebook;

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('CaseProc Test', oh.Id);
        st.GDMFSL_Price_Book__c = standardPricebook.Id;
        insert st;

        GDMFSL_Vertical__c vert = GDMFSL_DataFactory.createEnvironmentVertical('Test Vert');
        insert vert;

        Schema.Location lo = GDMFSL_DataFactory.createLocation('Test Location', st.Id);
        lo.GDMFSL_Vertical__c = vert.Id;
        lo.GDMFSL_Working_Hours__c = oh.Id;
        insert lo;

        Schema.Address addy = GDMFSL_DataFactory.createAddress('Anywhere', 'City', 'Florida', '123456', 'United States', lo.Id);
        insert addy;

        lo.GDMFSL_Address__c = addy.Id;
        update lo;

        Id servReqRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        Case ca = GDMFSL_DataFactory.createCase('APAC', a[0].Id);
        ca.RecordTypeId = servReqRecTypeId;
        insert ca;

        PricebookEntry pbe = GDMFSL_DataFactory.createPriceBookEntry(prd[0].Id);
        pbe.Pricebook2Id = standardPricebook.Id;
        insert pbe;

        ServiceContract servct = GDMFSL_DataFactory.createServiceContract('Test Service Contract', acct.Id);
        servct.Pricebook2Id = standardPricebook.Id;
        insert servct;

        ContractLineItem cli = GDMFSL_DataFactory.createCLI(servct.Id, pbe.Id);
        cli.Quantity = 1;
        cli.AssetId = a[0].Id;
        insert cli;


        //Creating Service Terrritory for usage
        ServiceTerritory servTerr = GDMFSL_DataFactory.createServiceTerritory('Test Service Territory', oh.Id);
        insert servTerr;


        GDMFSL_Associated_Contract__c assoCont = GDMFSL_DataFactory.createAssociatedContract(lo.Id, servct.Id, 10);
        insert assoCont;


        GDMFSL_SLA__c sla = GDMFSL_DataFactory.createSLAforCLI(cli.Id, 'Low', 1, 1, 1);
        insert sla;

        GDMFSL_SLA__c slaAC = GDMFSL_DataFactory.createSLAforAssociatedContract(assoCont.Id, 'Low', 1, 1, 1);
        insert slaAC;


        List<WorkOrder> tobeInsertedWOs = new List<WorkOrder>();

        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(wtBF.Id, acct.Id, lo.Id, System.now(), System.now());
        wo.CaseId = ca.Id;
        wo.GDMFSL_PO_Number__c = '12345';
        wo.Subject = 'Test Work Order';
        wo.AssetId = null;
        wo.ServiceTerritoryId = servTerr.Id;
        tobeInsertedWOs.add(wo);

        insert tobeInsertedWOs;


        Datetime dt = GDMFSL_WorkOrderProcessor.getDateAfterAddingHours(oh.Id, Datetime.now().addDays(1), 200, false, false, true);
        Test.stopTest();
        System.assert(dt != null);


    }

    @IsTest
    static void testGetDateAfterAddingHoursElse24HourFalse() {
        Test.startTest();
        Account acct = new Account(Name = 'Test Account', Phone = '1234561234', BillingStreet = 'Anywhere', BillingCity = 'City', BillingState = 'Florida', BillingCountry = 'United States');
        acct.Source_System_Types__c = 'ShipTo';
        insert acct;

        List<Product2> prd = GDMFSL_DataFactory.createProducts('Test Product', 1);
        insert prd;

        List<Asset> a = GDMFSL_DataFactory.createAssets('Test Asset', prd[0].Id, acct.Id, 1);
        insert a;

        WorkType wtBF = GDMFSL_DataFactory.createWorkType('Break/Fix', 5);
        wtBF.GDMFSL_WorkType_Category__c = 'BF';
        insert wtBF;

        WorkType wtPM = GDMFSL_DataFactory.createWorkType('Preventive Maintenance', 5);
        wtPM.GDMFSL_WorkType_Category__c = 'PM';
        insert wtPM;

        OperatingHours oh = GDMFSL_DataFactory.createOperatingHour();
        insert oh;


        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(), IsActive = true);
        update standardPricebook;

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('CaseProc Test', oh.Id);
        st.GDMFSL_Price_Book__c = standardPricebook.Id;
        insert st;

        GDMFSL_Vertical__c vert = GDMFSL_DataFactory.createEnvironmentVertical('Test Vert');
        insert vert;

        Schema.Location lo = GDMFSL_DataFactory.createLocation('Test Location', st.Id);
        lo.GDMFSL_Vertical__c = vert.Id;
        lo.GDMFSL_Working_Hours__c = oh.Id;
        insert lo;

        Schema.Address addy = GDMFSL_DataFactory.createAddress('Anywhere', 'City', 'Florida', '123456', 'United States', lo.Id);
        insert addy;

        lo.GDMFSL_Address__c = addy.Id;
        update lo;

        Id servReqRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        Case ca = GDMFSL_DataFactory.createCase('APAC', a[0].Id);
        ca.RecordTypeId = servReqRecTypeId;
        insert ca;

        PricebookEntry pbe = GDMFSL_DataFactory.createPriceBookEntry(prd[0].Id);
        pbe.Pricebook2Id = standardPricebook.Id;
        insert pbe;

        ServiceContract servct = GDMFSL_DataFactory.createServiceContract('Test Service Contract', acct.Id);
        servct.Pricebook2Id = standardPricebook.Id;
        insert servct;

        ContractLineItem cli = GDMFSL_DataFactory.createCLI(servct.Id, pbe.Id);
        cli.Quantity = 1;
        cli.AssetId = a[0].Id;
        insert cli;


        //Creating Service Terrritory for usage
        ServiceTerritory servTerr = GDMFSL_DataFactory.createServiceTerritory('Test Service Territory', oh.Id);
        insert servTerr;


        GDMFSL_Associated_Contract__c assoCont = GDMFSL_DataFactory.createAssociatedContract(lo.Id, servct.Id, 10);
        insert assoCont;


        GDMFSL_SLA__c sla = GDMFSL_DataFactory.createSLAforCLI(cli.Id, 'Low', 1, 1, 1);
        insert sla;

        GDMFSL_SLA__c slaAC = GDMFSL_DataFactory.createSLAforAssociatedContract(assoCont.Id, 'Low', 1, 1, 1);
        insert slaAC;


        List<WorkOrder> tobeInsertedWOs = new List<WorkOrder>();

        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(wtBF.Id, acct.Id, lo.Id, System.now(), System.now());
        wo.CaseId = ca.Id;
        wo.GDMFSL_PO_Number__c = '12345';
        wo.Subject = 'Test Work Order';
        wo.AssetId = null;
        wo.ServiceTerritoryId = servTerr.Id;
        tobeInsertedWOs.add(wo);

        insert tobeInsertedWOs;


        Datetime dt = GDMFSL_WorkOrderProcessor.getDateAfterAddingHours(oh.Id, Datetime.now().addDays(1), 200, false, false, false);
        Test.stopTest();
        System.assert(dt != null);


    }


    @IsTest
    static void testSetReactiveCoverageOnWO() {
        Test.startTest();
        List<WorkOrder> lstWO = [SELECT Id, WorkTypeId, LocationId, AssetId,GDMFSL_Chargeable__c FROM WorkOrder];
        GDMFSL_WorkOrderProcessor.setReactiveCoverageOnWO(lstWO);
        Test.stopTest();


    }

    @IsTest
    static void testUpdateWorkOrderStatusFromServiceAppointment() {


        Test.startTest();
        Account acct = new Account(Name = 'Test Account', Phone = '1234561234', BillingStreet = 'Anywhere', BillingCity = 'City', BillingState = 'Florida', BillingCountry = 'United States');
        acct.Source_System_Types__c = 'ShipTo';
        insert acct;

        List<Product2> prd = GDMFSL_DataFactory.createProducts('Test Product', 1);
        insert prd;

        List<Asset> a = GDMFSL_DataFactory.createAssets('Test Asset', prd[0].Id, acct.Id, 1);
        insert a;

        WorkType wtBF = GDMFSL_DataFactory.createWorkType('Break/Fix', 5);
        wtBF.GDMFSL_WorkType_Category__c = 'BF';
        insert wtBF;

        WorkType wtPM = GDMFSL_DataFactory.createWorkType('Preventive Maintenance', 5);
        wtPM.GDMFSL_WorkType_Category__c = 'PM';
        insert wtPM;

        OperatingHours oh = GDMFSL_DataFactory.createOperatingHour();
        insert oh;


        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(), IsActive = true);
        update standardPricebook;

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('CaseProc Test', oh.Id);
        st.GDMFSL_Price_Book__c = standardPricebook.Id;
        insert st;

        GDMFSL_Vertical__c vert = GDMFSL_DataFactory.createEnvironmentVertical('Test Vert');
        insert vert;

        Schema.Location lo = GDMFSL_DataFactory.createLocation('Test Location', st.Id);
        lo.GDMFSL_Vertical__c = vert.Id;
        lo.GDMFSL_Working_Hours__c = oh.Id;
        insert lo;

        Schema.Address addy = GDMFSL_DataFactory.createAddress('Anywhere', 'City', 'Florida', '123456', 'United States', lo.Id);
        insert addy;

        lo.GDMFSL_Address__c = addy.Id;
        update lo;

        Id servReqRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        Case ca = GDMFSL_DataFactory.createCase('APAC', a[0].Id);
        ca.RecordTypeId = servReqRecTypeId;
        insert ca;

        PricebookEntry pbe = GDMFSL_DataFactory.createPriceBookEntry(prd[0].Id);
        pbe.Pricebook2Id = standardPricebook.Id;
        insert pbe;

        ServiceContract servct = GDMFSL_DataFactory.createServiceContract('Test Service Contract', acct.Id);
        servct.Pricebook2Id = standardPricebook.Id;
        insert servct;

        ContractLineItem cli = GDMFSL_DataFactory.createCLI(servct.Id, pbe.Id);
        cli.Quantity = 1;
        cli.AssetId = a[0].Id;
        insert cli;


        //Creating Service Terrritory for usage
        ServiceTerritory servTerr = GDMFSL_DataFactory.createServiceTerritory('Test Service Territory', oh.Id);
        insert servTerr;


        GDMFSL_Associated_Contract__c assoCont = GDMFSL_DataFactory.createAssociatedContract(lo.Id, servct.Id, 10);
        insert assoCont;


        GDMFSL_SLA__c sla = GDMFSL_DataFactory.createSLAforCLI(cli.Id, 'Low', 1, 1, 1);
        insert sla;

        GDMFSL_SLA__c slaAC = GDMFSL_DataFactory.createSLAforAssociatedContract(assoCont.Id, 'Low', 1, 1, 1);
        insert slaAC;


        List<WorkOrder> tobeInsertedWOs = new List<WorkOrder>();

        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(wtBF.Id, acct.Id, lo.Id, System.now(), System.now());
        wo.CaseId = ca.Id;
        wo.GDMFSL_PO_Number__c = '12345';
        wo.Subject = 'Test Work Order';
        wo.AssetId = null;
        wo.ServiceTerritoryId = servTerr.Id;
        tobeInsertedWOs.add(wo);

        insert tobeInsertedWOs;

        WorkOrderLineItem woli = GDMFSL_DataFactory.createWorkOrderLineItem(wtBF.Id, wo.Id, a[0].Id);
        insert woli;

        WorkOrderLineItem woli2 = GDMFSL_DataFactory.createWorkOrderLineItem(wtBF.Id, wo.Id, a[0].Id);
        insert woli2;

        ServiceAppointment sa = GDMFSL_DataFactory.createServiceAppointment(acct.Id, 'None');
        sa.ParentRecordId = wo.Id;
        insert sa;

        ServiceAppointment saToUpdate = [SELECT Id, ParentRecordId, Status FROM ServiceAppointment LIMIT 1];
        System.debug('saToUpdate : ' + saToUpdate.Status);
        saToUpdate.Status = 'Scheduled';
        update saToUpdate;
        Test.stopTest();


    }

    @IsTest
    static void testCanWOBeCanceled() {

        Test.startTest();
        Account acct = new Account(Name = 'Test Account', Phone = '1234561234', BillingStreet = 'Anywhere', BillingCity = 'City', BillingState = 'Florida', BillingCountry = 'United States');
        acct.Source_System_Types__c = 'ShipTo';
        insert acct;

        List<Product2> prd = GDMFSL_DataFactory.createProducts('Test Product', 1);
        insert prd;

        List<Asset> a = GDMFSL_DataFactory.createAssets('Test Asset', prd[0].Id, acct.Id, 1);
        insert a;

        WorkType wtBF = GDMFSL_DataFactory.createWorkType('Break/Fix', 5);
        wtBF.GDMFSL_WorkType_Category__c = 'BF';
        insert wtBF;

        WorkType wtPM = GDMFSL_DataFactory.createWorkType('Preventive Maintenance', 5);
        wtPM.GDMFSL_WorkType_Category__c = 'PM';
        insert wtPM;

        OperatingHours oh = GDMFSL_DataFactory.createOperatingHour();
        insert oh;


        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(), IsActive = true);
        update standardPricebook;

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('CaseProc Test', oh.Id);
        st.GDMFSL_Price_Book__c = standardPricebook.Id;
        insert st;

        GDMFSL_Vertical__c vert = GDMFSL_DataFactory.createEnvironmentVertical('Test Vert');
        insert vert;

        Schema.Location lo = GDMFSL_DataFactory.createLocation('Test Location', st.Id);
        lo.GDMFSL_Vertical__c = vert.Id;
        lo.GDMFSL_Working_Hours__c = oh.Id;
        insert lo;

        Schema.Address addy = GDMFSL_DataFactory.createAddress('Anywhere', 'City', 'Florida', '123456', 'United States', lo.Id);
        insert addy;

        lo.GDMFSL_Address__c = addy.Id;
        update lo;

        Id servReqRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        Case ca = GDMFSL_DataFactory.createCase('APAC', a[0].Id);
        ca.RecordTypeId = servReqRecTypeId;
        insert ca;

        PricebookEntry pbe = GDMFSL_DataFactory.createPriceBookEntry(prd[0].Id);
        pbe.Pricebook2Id = standardPricebook.Id;
        insert pbe;

        ServiceContract servct = GDMFSL_DataFactory.createServiceContract('Test Service Contract', acct.Id);
        servct.Pricebook2Id = standardPricebook.Id;
        insert servct;

        ContractLineItem cli = GDMFSL_DataFactory.createCLI(servct.Id, pbe.Id);
        cli.Quantity = 1;
        cli.AssetId = a[0].Id;
        insert cli;


        //Creating Service Terrritory for usage
        ServiceTerritory servTerr = GDMFSL_DataFactory.createServiceTerritory('Test Service Territory', oh.Id);
        insert servTerr;


        GDMFSL_Associated_Contract__c assoCont = GDMFSL_DataFactory.createAssociatedContract(lo.Id, servct.Id, 10);
        insert assoCont;


        GDMFSL_SLA__c sla = GDMFSL_DataFactory.createSLAforCLI(cli.Id, 'Low', 1, 1, 1);
        insert sla;

        GDMFSL_SLA__c slaAC = GDMFSL_DataFactory.createSLAforAssociatedContract(assoCont.Id, 'Low', 1, 1, 1);
        insert slaAC;


        List<WorkOrder> tobeInsertedWOs = new List<WorkOrder>();

        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(wtBF.Id, acct.Id, lo.Id, System.now(), System.now());
        wo.CaseId = ca.Id;
        wo.GDMFSL_PO_Number__c = '12345';
        wo.Subject = 'Test Work Order';
        wo.AssetId = null;
        wo.ServiceTerritoryId = servTerr.Id;
        tobeInsertedWOs.add(wo);

        insert tobeInsertedWOs;


        Set<Id> caseId = new Set<Id>();
        caseId.add(ca.Id);

        GDMFSL_WorkOrderProcessor.canWOBeCanceled(caseId);
        Test.stopTest();


    }

    @IsTest
    static void testCancelNonCaseRelatedWOs() {
        //Normal Complete status Transition

        Test.startTest();
        Account acct = new Account(Name = 'Test Account', Phone = '1234561234', BillingStreet = 'Anywhere', BillingCity = 'City', BillingState = 'Florida', BillingCountry = 'United States');
        acct.Source_System_Types__c = 'ShipTo';
        insert acct;

        List<Product2> prd = GDMFSL_DataFactory.createProducts('Test Product', 1);
        insert prd;

        List<Asset> a = GDMFSL_DataFactory.createAssets('Test Asset', prd[0].Id, acct.Id, 1);
        insert a;

        WorkType wtBF = GDMFSL_DataFactory.createWorkType('Break/Fix', 5);
        wtBF.GDMFSL_WorkType_Category__c = 'BF';
        insert wtBF;

        WorkType wtPM = GDMFSL_DataFactory.createWorkType('Preventive Maintenance', 5);
        wtPM.GDMFSL_WorkType_Category__c = 'PM';
        insert wtPM;

        OperatingHours oh = GDMFSL_DataFactory.createOperatingHour();
        insert oh;


        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(), IsActive = true);
        update standardPricebook;

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('CaseProc Test', oh.Id);
        st.GDMFSL_Price_Book__c = standardPricebook.Id;
        insert st;

        GDMFSL_Vertical__c vert = GDMFSL_DataFactory.createEnvironmentVertical('Test Vert');
        insert vert;

        Schema.Location lo = GDMFSL_DataFactory.createLocation('Test Location', st.Id);
        lo.GDMFSL_Vertical__c = vert.Id;
        lo.GDMFSL_Working_Hours__c = oh.Id;
        insert lo;

        Schema.Address addy = GDMFSL_DataFactory.createAddress('Anywhere', 'City', 'Florida', '123456', 'United States', lo.Id);
        insert addy;

        lo.GDMFSL_Address__c = addy.Id;
        update lo;

        Id servReqRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        Case ca = GDMFSL_DataFactory.createCase('APAC', a[0].Id);
        ca.RecordTypeId = servReqRecTypeId;
        insert ca;

        PricebookEntry pbe = GDMFSL_DataFactory.createPriceBookEntry(prd[0].Id);
        pbe.Pricebook2Id = standardPricebook.Id;
        insert pbe;

        ServiceContract servct = GDMFSL_DataFactory.createServiceContract('Test Service Contract', acct.Id);
        servct.Pricebook2Id = standardPricebook.Id;
        insert servct;

        ContractLineItem cli = GDMFSL_DataFactory.createCLI(servct.Id, pbe.Id);
        cli.Quantity = 1;
        cli.AssetId = a[0].Id;
        insert cli;


        //Creating Service Terrritory for usage
        ServiceTerritory servTerr = GDMFSL_DataFactory.createServiceTerritory('Test Service Territory', oh.Id);
        insert servTerr;


        GDMFSL_Associated_Contract__c assoCont = GDMFSL_DataFactory.createAssociatedContract(lo.Id, servct.Id, 10);
        insert assoCont;


        GDMFSL_SLA__c sla = GDMFSL_DataFactory.createSLAforCLI(cli.Id, 'Low', 1, 1, 1);
        insert sla;

        GDMFSL_SLA__c slaAC = GDMFSL_DataFactory.createSLAforAssociatedContract(assoCont.Id, 'Low', 1, 1, 1);
        insert slaAC;


        List<WorkOrder> tobeInsertedWOs = new List<WorkOrder>();

        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(wtBF.Id, acct.Id, lo.Id, System.now(), System.now());
        wo.CaseId = ca.Id;
        wo.GDMFSL_PO_Number__c = '12345';
        wo.Subject = 'Test Work Order';
        wo.AssetId = null;
        wo.ServiceTerritoryId = servTerr.Id;
        tobeInsertedWOs.add(wo);
        wo.EndDate = null;

        insert tobeInsertedWOs;


        Map<Id, ServiceContract> scMap = new Map<Id, ServiceContract>([SELECT Id, Status, EndDate FROM ServiceContract]);


        GDMFSL_WorkOrderProcessor.cancelNonCaseRelatedWOs(scMap);
        Test.stopTest();


    }


    @IsTest
    static void testCancelNonCaseRelatedWOsNullCase() {
        //Normal Complete status Transition

        Test.startTest();
        Account acct = new Account(Name = 'Test Account', Phone = '1234561234', BillingStreet = 'Anywhere', BillingCity = 'City', BillingState = 'Florida', BillingCountry = 'United States');
        acct.Source_System_Types__c = 'ShipTo';
        insert acct;

        List<Product2> prd = GDMFSL_DataFactory.createProducts('Test Product', 1);
        insert prd;

        List<Asset> a = GDMFSL_DataFactory.createAssets('Test Asset', prd[0].Id, acct.Id, 1);
        insert a;

        WorkType wtBF = GDMFSL_DataFactory.createWorkType('Break/Fix', 5);
        wtBF.GDMFSL_WorkType_Category__c = 'BF';
        insert wtBF;

        WorkType wtPM = GDMFSL_DataFactory.createWorkType('Preventive Maintenance', 5);
        wtPM.GDMFSL_WorkType_Category__c = 'PM';
        insert wtPM;

        OperatingHours oh = GDMFSL_DataFactory.createOperatingHour();
        insert oh;


        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(), IsActive = true);
        update standardPricebook;

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('CaseProc Test', oh.Id);
        st.GDMFSL_Price_Book__c = standardPricebook.Id;
        insert st;

        GDMFSL_Vertical__c vert = GDMFSL_DataFactory.createEnvironmentVertical('Test Vert');
        insert vert;

        Schema.Location lo = GDMFSL_DataFactory.createLocation('Test Location', st.Id);
        lo.GDMFSL_Vertical__c = vert.Id;
        lo.GDMFSL_Working_Hours__c = oh.Id;
        insert lo;

        Schema.Address addy = GDMFSL_DataFactory.createAddress('Anywhere', 'City', 'Florida', '123456', 'United States', lo.Id);
        insert addy;

        lo.GDMFSL_Address__c = addy.Id;
        update lo;

        Id servReqRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        Case ca = GDMFSL_DataFactory.createCase('APAC', a[0].Id);
        ca.RecordTypeId = servReqRecTypeId;
        insert ca;

        PricebookEntry pbe = GDMFSL_DataFactory.createPriceBookEntry(prd[0].Id);
        pbe.Pricebook2Id = standardPricebook.Id;
        insert pbe;

        ServiceContract servct = GDMFSL_DataFactory.createServiceContract('Test Service Contract', acct.Id);
        servct.Pricebook2Id = standardPricebook.Id;
        insert servct;

        ContractLineItem cli = GDMFSL_DataFactory.createCLI(servct.Id, pbe.Id);
        cli.Quantity = 1;
        cli.AssetId = a[0].Id;
        insert cli;


        //Creating Service Terrritory for usage
        ServiceTerritory servTerr = GDMFSL_DataFactory.createServiceTerritory('Test Service Territory', oh.Id);
        insert servTerr;


        GDMFSL_Associated_Contract__c assoCont = GDMFSL_DataFactory.createAssociatedContract(lo.Id, servct.Id, 10);
        insert assoCont;


        GDMFSL_SLA__c sla = GDMFSL_DataFactory.createSLAforCLI(cli.Id, 'Low', 1, 1, 1);
        insert sla;

        GDMFSL_SLA__c slaAC = GDMFSL_DataFactory.createSLAforAssociatedContract(assoCont.Id, 'Low', 1, 1, 1);
        insert slaAC;


        List<WorkOrder> tobeInsertedWOs = new List<WorkOrder>();

        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(wtBF.Id, acct.Id, lo.Id, System.now(), System.now());
        wo.CaseId = null;
        wo.GDMFSL_PO_Number__c = '12345';
        wo.Subject = 'Test Work Order';
        wo.AssetId = null;
        wo.ServiceTerritoryId = servTerr.Id;
        tobeInsertedWOs.add(wo);
        wo.EndDate = null;

        insert tobeInsertedWOs;


        Map<Id, ServiceContract> scMap = new Map<Id, ServiceContract>([SELECT Id, Status, EndDate FROM ServiceContract]);


        GDMFSL_WorkOrderProcessor.cancelNonCaseRelatedWOs(scMap);
        Test.stopTest();


    }

    @IsTest
    static void testsetRollUpFiedls() {

        Test.startTest();
        WorkOrder theWO = [SELECT Id,Status FROM WorkOrder LIMIT 1];
        ServiceAppointment theSA = [SELECT Id FROM ServiceAppointment LIMIT 1];
        TimeSheet tiSheet = [SELECT Id FROM TimeSheet LIMIT 1];

        List<TimeSheetEntry> tsesToInsert = new List<TimeSheetEntry>();


        tsesToInsert.add(new TimeSheetEntry(TimeSheetId = tiSheet.Id,
                WorkOrderId = theWO.Id,
                GDMFSL_Service_Appointment__c = theSA.Id,
                StartTime = Datetime.now().addMinutes(-200),
                EndTime = Datetime.now(),
                Type = 'PT',
                GDMFSL_Classification__c = 'Labor'));

        tsesToInsert.add(new TimeSheetEntry(TimeSheetId = tiSheet.Id,
                WorkOrderId = theWO.Id,
                GDMFSL_Service_Appointment__c = theSA.Id,
                StartTime = Datetime.now().addMinutes(-200),
                EndTime = Datetime.now(),
                Type = 'PT',
                GDMFSL_Classification__c = 'Travel'));

        tsesToInsert.add(new TimeSheetEntry(TimeSheetId = tiSheet.Id,
                WorkOrderId = theWO.Id,
                GDMFSL_Service_Appointment__c = theSA.Id,
                StartTime = Datetime.now().addMinutes(-200),
                EndTime = Datetime.now(),
                Type = 'OT',
                GDMFSL_Classification__c = 'Travel'));

        tsesToInsert.add(new TimeSheetEntry(TimeSheetId = tiSheet.Id,
                WorkOrderId = theWO.Id,
                GDMFSL_Service_Appointment__c = theSA.Id,
                StartTime = Datetime.now().addMinutes(-200),
                EndTime = Datetime.now(),
                Type = 'OT',
                GDMFSL_Classification__c = 'Labor'));

        tsesToInsert.add(new TimeSheetEntry(TimeSheetId = tiSheet.Id,
                WorkOrderId = theWO.Id,
                GDMFSL_Service_Appointment__c = theSA.Id,
                StartTime = Datetime.now().addMinutes(-200),
                EndTime = Datetime.now(),
                Type = 'RT',
                GDMFSL_Classification__c = 'Labor'));

        tsesToInsert.add(new TimeSheetEntry(TimeSheetId = tiSheet.Id,
                WorkOrderId = theWO.Id,
                GDMFSL_Service_Appointment__c = theSA.Id,
                StartTime = Datetime.now().addMinutes(-200),
                EndTime = Datetime.now(),
                Type = 'RT',
                GDMFSL_Classification__c = 'Travel'));
        insert tsesToInsert;


        theWO.Status = 'Completed';
        update theWO;
        Test.stopTest();


    }

    @IsTest
    static void testCheckIfWOCanBeUnscheduledAlongWithSA() {
        Test.startTest();
        Set<Id> setToBeTest = new Set<Id>();
        List<WorkOrder> woToUpdate = new List<WorkOrder>();
        List<WorkOrder> lisWrk = [SELECT Id, Status FROM WorkOrder];

        for (WorkOrder wo : lisWrk) {

            wo.Status = 'Scheduled';
            woToUpdate.add(wo);
            setToBeTest.add(wo.Id);
        }
        update woToUpdate;

        GDMFSL_WorkOrderProcessor.checkIfWOCanBeUnscheduledAlongWithSA(setToBeTest);
        Test.stopTest();
    }

    @IsTest
    static void testCheckIfWOCanBeUnscheduledAlongWithSANotUnscheduled() {

        Test.startTest();

        Set<Id> setToBeTest = new Set<Id>();
        List<WorkOrder> woToUpdate = new List<WorkOrder>();
        List<WorkOrder> lisWrk = [SELECT Id, Status FROM WorkOrder];

        for (WorkOrder wo : lisWrk) {

            wo.Status = 'Scheduled';
            woToUpdate.add(wo);
            setToBeTest.add(wo.Id);
        }
        update woToUpdate;

        List<ServiceAppointment> theSAs = [SELECT Id FROM ServiceAppointment WHERE ParentRecordId IN :setToBeTest];

        for (ServiceAppointment thisSA : theSAs){
            thisSA.Status = GDMFSL_ServiceAppointmentProcessor.COMPLETEDSTATUS;
        }

        update theSAs;


        GDMFSL_WorkOrderProcessor.checkIfWOCanBeUnscheduledAlongWithSA(setToBeTest);

        Test.stopTest();
    }

    @IsTest
    static void testSetSAPAccountNumber() {
        Test.startTest();
        WorkOrder wo = [SELECT Id,Status FROM WorkOrder LIMIT 1];
        ServiceContract sc = [SELECT Id FROM ServiceContract LIMIT 1];
        Account a = [SELECT Id FROM Account LIMIT 1];
        ServiceTerritory st = [SELECT Id FROM ServiceTerritory LIMIT 1];
        WorkType wtPM = [SELECT Id FROM WorkType WHERE GDMFSL_WorkType_Category__c = 'PM' LIMIT 1];
        Source_System__c souSys = GDMFSL_DataFactory.createSourceSystem(a.Id, 'SCID12345');
        insert souSys;
        GDMFSL_Discipline__c anotherDisc = GDMFSL_DataFactory.createDiscipline('Test');
        insert anotherDisc;

        GDMFSL_Profit_Center__c newPCtr = GDMFSL_DataFactory.createProfitCenter('Test2', st.Id, anotherDisc.Id, 'ABCD');
        insert newPCtr;

        sc.AccountId = a.Id;
        sc.GDMFSL_Bill_to_Account__c = a.Id;
        sc.GDMFSL_Bill_To_Account_Number__c = '12345';
        sc.GDMFSL_Sold_To_Account_Number__c = '23456';
        sc.GDMFSL_Sold_To_Source_System__c = souSys.Id;
        sc.GDMFSL_Bill_To_Source_System__c = souSys.Id;
        sc.GDMFSL_Sales_Office__c = 'ABC';
        sc.GDMFSL_Sales_Organization__c = 'XYZ';
        sc.GDMFSL_Distribution_Channel__c = '10';
        sc.GDMFSL_Profit_Center__c = newPCtr.Id;

        update sc;
        wo.ServiceContractId = sc.Id;
        wo.WorkTypeId = wtPM.Id;

        update wo;
        Test.stopTest();
    }

    @IsTest
    static void testGetBusinessHoursStartDateTrue() {

        Test.startTest();
        Account acct = new Account(Name = 'Test Account', Phone = '1234561234', BillingStreet = 'Anywhere', BillingCity = 'City', BillingState = 'Florida', BillingCountry = 'United States');
        acct.Source_System_Types__c = 'ShipTo';
        insert acct;

        List<Product2> prd = GDMFSL_DataFactory.createProducts('Test Product', 1);
        insert prd;

        List<Asset> a = GDMFSL_DataFactory.createAssets('Test Asset', prd[0].Id, acct.Id, 1);
        insert a;

        WorkType wtBF = GDMFSL_DataFactory.createWorkType('Break/Fix', 5);
        wtBF.GDMFSL_WorkType_Category__c = 'BF';
        insert wtBF;

        WorkType wtPM = GDMFSL_DataFactory.createWorkType('Preventive Maintenance', 5);
        wtPM.GDMFSL_WorkType_Category__c = 'PM';
        insert wtPM;

        OperatingHours oh = GDMFSL_DataFactory.createOperatingHour();
        insert oh;


        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(), IsActive = true);
        update standardPricebook;

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('CaseProc Test', oh.Id);
        st.GDMFSL_Price_Book__c = standardPricebook.Id;
        insert st;

        GDMFSL_Vertical__c vert = GDMFSL_DataFactory.createEnvironmentVertical('Test Vert');
        insert vert;

        Schema.Location lo = GDMFSL_DataFactory.createLocation('Test Location', st.Id);
        lo.GDMFSL_Vertical__c = vert.Id;
        lo.GDMFSL_Working_Hours__c = oh.Id;
        insert lo;

        Schema.Address addy = GDMFSL_DataFactory.createAddress('Anywhere', 'City', 'Florida', '123456', 'United States', lo.Id);
        insert addy;

        lo.GDMFSL_Address__c = addy.Id;
        update lo;

        Id servReqRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        Case ca = GDMFSL_DataFactory.createCase('APAC', a[0].Id);
        ca.RecordTypeId = servReqRecTypeId;
        insert ca;

        PricebookEntry pbe = GDMFSL_DataFactory.createPriceBookEntry(prd[0].Id);
        pbe.Pricebook2Id = standardPricebook.Id;
        insert pbe;

        ServiceContract servct = GDMFSL_DataFactory.createServiceContract('Test Service Contract', acct.Id);
        servct.Pricebook2Id = standardPricebook.Id;
        insert servct;

        ContractLineItem cli = GDMFSL_DataFactory.createCLI(servct.Id, pbe.Id);
        cli.Quantity = 1;
        cli.AssetId = a[0].Id;
        insert cli;


        //Creating Service Terrritory for usage
        ServiceTerritory servTerr = GDMFSL_DataFactory.createServiceTerritory('Test Service Territory', oh.Id);
        insert servTerr;


        GDMFSL_Associated_Contract__c assoCont = GDMFSL_DataFactory.createAssociatedContract(lo.Id, servct.Id, 10);
        insert assoCont;


        GDMFSL_SLA__c sla = GDMFSL_DataFactory.createSLAforCLI(cli.Id, 'Low', 1, 1, 1);
        insert sla;

        GDMFSL_SLA__c slaAC = GDMFSL_DataFactory.createSLAforAssociatedContract(assoCont.Id, 'Low', 1, 1, 1);
        insert slaAC;


        List<WorkOrder> tobeInsertedWOs = new List<WorkOrder>();

        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(wtBF.Id, acct.Id, lo.Id, System.now(), System.now());
        wo.CaseId = ca.Id;
        wo.GDMFSL_PO_Number__c = '12345';
        wo.Subject = 'Test Work Order';
        wo.AssetId = null;
        wo.ServiceTerritoryId = servTerr.Id;
        tobeInsertedWOs.add(wo);

        insert tobeInsertedWOs;


        GDMFSL_WorkOrderProcessor.getBusinessHoursStartDate(oh.Id, Datetime.now(), true, true, true);
        Test.stopTest();


    }

    @IsTest
    static void testGetBusinessHoursStartDateTrueWD() {

        Test.startTest();
        Account acct = new Account(Name = 'Test Account', Phone = '1234561234', BillingStreet = 'Anywhere', BillingCity = 'City', BillingState = 'Florida', BillingCountry = 'United States');
        acct.Source_System_Types__c = 'ShipTo';
        insert acct;

        List<Product2> prd = GDMFSL_DataFactory.createProducts('Test Product', 1);
        insert prd;

        List<Asset> a = GDMFSL_DataFactory.createAssets('Test Asset', prd[0].Id, acct.Id, 1);
        insert a;

        WorkType wtBF = GDMFSL_DataFactory.createWorkType('Break/Fix', 5);
        wtBF.GDMFSL_WorkType_Category__c = 'BF';
        insert wtBF;

        WorkType wtPM = GDMFSL_DataFactory.createWorkType('Preventive Maintenance', 5);
        wtPM.GDMFSL_WorkType_Category__c = 'PM';
        insert wtPM;

        OperatingHours oh = GDMFSL_DataFactory.createOperatingHour();
        insert oh;


        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(), IsActive = true);
        update standardPricebook;

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('CaseProc Test', oh.Id);
        st.GDMFSL_Price_Book__c = standardPricebook.Id;
        insert st;

        GDMFSL_Vertical__c vert = GDMFSL_DataFactory.createEnvironmentVertical('Test Vert');
        insert vert;

        Schema.Location lo = GDMFSL_DataFactory.createLocation('Test Location', st.Id);
        lo.GDMFSL_Vertical__c = vert.Id;
        lo.GDMFSL_Working_Hours__c = oh.Id;
        insert lo;

        Schema.Address addy = GDMFSL_DataFactory.createAddress('Anywhere', 'City', 'Florida', '123456', 'United States', lo.Id);
        insert addy;

        lo.GDMFSL_Address__c = addy.Id;
        update lo;

        Id servReqRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        Case ca = GDMFSL_DataFactory.createCase('APAC', a[0].Id);
        ca.RecordTypeId = servReqRecTypeId;
        insert ca;

        PricebookEntry pbe = GDMFSL_DataFactory.createPriceBookEntry(prd[0].Id);
        pbe.Pricebook2Id = standardPricebook.Id;
        insert pbe;

        ServiceContract servct = GDMFSL_DataFactory.createServiceContract('Test Service Contract', acct.Id);
        servct.Pricebook2Id = standardPricebook.Id;
        insert servct;

        ContractLineItem cli = GDMFSL_DataFactory.createCLI(servct.Id, pbe.Id);
        cli.Quantity = 1;
        cli.AssetId = a[0].Id;
        insert cli;


        //Creating Service Terrritory for usage
        ServiceTerritory servTerr = GDMFSL_DataFactory.createServiceTerritory('Test Service Territory', oh.Id);
        insert servTerr;


        GDMFSL_Associated_Contract__c assoCont = GDMFSL_DataFactory.createAssociatedContract(lo.Id, servct.Id, 10);
        insert assoCont;


        GDMFSL_SLA__c sla = GDMFSL_DataFactory.createSLAforCLI(cli.Id, 'Low', 1, 1, 1);
        insert sla;

        GDMFSL_SLA__c slaAC = GDMFSL_DataFactory.createSLAforAssociatedContract(assoCont.Id, 'Low', 1, 1, 1);
        insert slaAC;


        List<WorkOrder> tobeInsertedWOs = new List<WorkOrder>();

        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(wtBF.Id, acct.Id, lo.Id, System.now(), System.now());
        wo.CaseId = ca.Id;
        wo.GDMFSL_PO_Number__c = '12345';
        wo.Subject = 'Test Work Order';
        wo.AssetId = null;
        wo.ServiceTerritoryId = servTerr.Id;
        tobeInsertedWOs.add(wo);

        insert tobeInsertedWOs;


        GDMFSL_WorkOrderProcessor.getBusinessHoursStartDate(oh.Id, Datetime.now() - 5, true, true, true);
        Test.stopTest();


    }
    @IsTest
    static void testGetBusinessHoursStartDateTrueAH() {

        Test.startTest();
        Account acct = new Account(Name = 'Test Account', Phone = '1234561234', BillingStreet = 'Anywhere', BillingCity = 'City', BillingState = 'Florida', BillingCountry = 'United States');
        acct.Source_System_Types__c = 'ShipTo';
        insert acct;

        List<Product2> prd = GDMFSL_DataFactory.createProducts('Test Product', 1);
        insert prd;

        List<Asset> a = GDMFSL_DataFactory.createAssets('Test Asset', prd[0].Id, acct.Id, 1);
        insert a;

        WorkType wtBF = GDMFSL_DataFactory.createWorkType('Break/Fix', 5);
        wtBF.GDMFSL_WorkType_Category__c = 'BF';
        insert wtBF;

        WorkType wtPM = GDMFSL_DataFactory.createWorkType('Preventive Maintenance', 5);
        wtPM.GDMFSL_WorkType_Category__c = 'PM';
        insert wtPM;

        OperatingHours oh = GDMFSL_DataFactory.createOperatingHour();
        insert oh;


        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(), IsActive = true);
        update standardPricebook;

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('CaseProc Test', oh.Id);
        st.GDMFSL_Price_Book__c = standardPricebook.Id;
        insert st;

        GDMFSL_Vertical__c vert = GDMFSL_DataFactory.createEnvironmentVertical('Test Vert');
        insert vert;

        Schema.Location lo = GDMFSL_DataFactory.createLocation('Test Location', st.Id);
        lo.GDMFSL_Vertical__c = vert.Id;
        lo.GDMFSL_Working_Hours__c = oh.Id;
        insert lo;

        Schema.Address addy = GDMFSL_DataFactory.createAddress('Anywhere', 'City', 'Florida', '123456', 'United States', lo.Id);
        insert addy;

        lo.GDMFSL_Address__c = addy.Id;
        update lo;

        Id servReqRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        Case ca = GDMFSL_DataFactory.createCase('APAC', a[0].Id);
        ca.RecordTypeId = servReqRecTypeId;
        insert ca;

        PricebookEntry pbe = GDMFSL_DataFactory.createPriceBookEntry(prd[0].Id);
        pbe.Pricebook2Id = standardPricebook.Id;
        insert pbe;

        ServiceContract servct = GDMFSL_DataFactory.createServiceContract('Test Service Contract', acct.Id);
        servct.Pricebook2Id = standardPricebook.Id;
        insert servct;

        ContractLineItem cli = GDMFSL_DataFactory.createCLI(servct.Id, pbe.Id);
        cli.Quantity = 1;
        cli.AssetId = a[0].Id;
        insert cli;


        //Creating Service Terrritory for usage
        ServiceTerritory servTerr = GDMFSL_DataFactory.createServiceTerritory('Test Service Territory', oh.Id);
        insert servTerr;


        GDMFSL_Associated_Contract__c assoCont = GDMFSL_DataFactory.createAssociatedContract(lo.Id, servct.Id, 10);
        insert assoCont;


        GDMFSL_SLA__c sla = GDMFSL_DataFactory.createSLAforCLI(cli.Id, 'Low', 1, 1, 1);
        insert sla;

        GDMFSL_SLA__c slaAC = GDMFSL_DataFactory.createSLAforAssociatedContract(assoCont.Id, 'Low', 1, 1, 1);
        insert slaAC;


        List<WorkOrder> tobeInsertedWOs = new List<WorkOrder>();

        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(wtBF.Id, acct.Id, lo.Id, System.now(), System.now());
        wo.CaseId = ca.Id;
        wo.GDMFSL_PO_Number__c = '12345';
        wo.Subject = 'Test Work Order';
        wo.AssetId = null;
        wo.ServiceTerritoryId = servTerr.Id;
        tobeInsertedWOs.add(wo);

        insert tobeInsertedWOs;


        GDMFSL_WorkOrderProcessor.getBusinessHoursStartDate(oh.Id, Datetime.now() - 5, false, true, true);
        Test.stopTest();


    }

    @IsTest
    static void testIsWOStartDateWithinBZHours() {

        Test.startTest();
        Account acct = new Account(Name = 'Test Account', Phone = '1234561234', BillingStreet = 'Anywhere', BillingCity = 'City', BillingState = 'Florida', BillingCountry = 'United States');
        acct.Source_System_Types__c = 'ShipTo';
        insert acct;

        List<Product2> prd = GDMFSL_DataFactory.createProducts('Test Product', 1);
        insert prd;

        List<Asset> a = GDMFSL_DataFactory.createAssets('Test Asset', prd[0].Id, acct.Id, 1);
        insert a;

        WorkType wtBF = GDMFSL_DataFactory.createWorkType('Break/Fix', 5);
        wtBF.GDMFSL_WorkType_Category__c = 'BF';
        insert wtBF;

        WorkType wtPM = GDMFSL_DataFactory.createWorkType('Preventive Maintenance', 5);
        wtPM.GDMFSL_WorkType_Category__c = 'PM';
        insert wtPM;

        OperatingHours oh = GDMFSL_DataFactory.createOperatingHour();
        insert oh;


        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(), IsActive = true);
        update standardPricebook;

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('CaseProc Test', oh.Id);
        st.GDMFSL_Price_Book__c = standardPricebook.Id;
        insert st;

        GDMFSL_Vertical__c vert = GDMFSL_DataFactory.createEnvironmentVertical('Test Vert');
        insert vert;

        Schema.Location lo = GDMFSL_DataFactory.createLocation('Test Location', st.Id);
        lo.GDMFSL_Vertical__c = vert.Id;
        lo.GDMFSL_Working_Hours__c = oh.Id;
        insert lo;

        Schema.Address addy = GDMFSL_DataFactory.createAddress('Anywhere', 'City', 'Florida', '123456', 'United States', lo.Id);
        insert addy;

        lo.GDMFSL_Address__c = addy.Id;
        update lo;

        Id servReqRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        Case ca = GDMFSL_DataFactory.createCase('APAC', a[0].Id);
        ca.RecordTypeId = servReqRecTypeId;
        insert ca;

        PricebookEntry pbe = GDMFSL_DataFactory.createPriceBookEntry(prd[0].Id);
        pbe.Pricebook2Id = standardPricebook.Id;
        insert pbe;

        ServiceContract servct = GDMFSL_DataFactory.createServiceContract('Test Service Contract', acct.Id);
        servct.Pricebook2Id = standardPricebook.Id;
        insert servct;

        ContractLineItem cli = GDMFSL_DataFactory.createCLI(servct.Id, pbe.Id);
        cli.Quantity = 1;
        cli.AssetId = a[0].Id;
        insert cli;


        //Creating Service Terrritory for usage
        ServiceTerritory servTerr = GDMFSL_DataFactory.createServiceTerritory('Test Service Territory', oh.Id);
        insert servTerr;


        GDMFSL_Associated_Contract__c assoCont = GDMFSL_DataFactory.createAssociatedContract(lo.Id, servct.Id, 10);
        insert assoCont;


        GDMFSL_SLA__c sla = GDMFSL_DataFactory.createSLAforCLI(cli.Id, 'Low', 1, 1, 1);
        insert sla;

        GDMFSL_SLA__c slaAC = GDMFSL_DataFactory.createSLAforAssociatedContract(assoCont.Id, 'Low', 1, 1, 1);
        insert slaAC;


        List<WorkOrder> tobeInsertedWOs = new List<WorkOrder>();

        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(wtBF.Id, acct.Id, lo.Id, System.now(), System.now());
        wo.CaseId = ca.Id;
        wo.GDMFSL_PO_Number__c = '12345';
        wo.Subject = 'Test Work Order';
        wo.AssetId = null;
        wo.ServiceTerritoryId = servTerr.Id;
        tobeInsertedWOs.add(wo);

        insert tobeInsertedWOs;


        GDMFSL_WorkOrderProcessor.isWOStartDateWithinBZHours(wo);
        Test.stopTest();

    }

    @IsTest
    static private void testsetStatusforIntegrationClosed() {
       Test.startTest();
        WorkOrder theWO = [
                SELECT Id, SAP_Job_Type__c, Status, WorkTypeId,
                        GDMFSL_Executed_by_Sub_Contractor__c, GDMFSL_Chargeable__c, Work_Type_Category__c
                FROM WorkOrder
                WHERE WorkTypeId != NULL
                AND Status != :GDMFSL_WorkOrderProcessor.COMPLETEDSTATUS
                LIMIT 1
        ];

        List<String> sapJobs = new List<String>();
        sapJobs.addAll(GDMFSL_WorkOrderProcessor.SAPJOBTYPE);

        theWO.SAP_Job_Type__c = sapJobs[0];

        WorkOrder newWO = theWO.clone(true, true, true, false);
        newWO.Status = GDMFSL_WorkOrderProcessor.COMPLETEDSTATUS;

        Map<Id, WorkOrder> oldVal = new Map<Id, WorkOrder>();
        oldVal.put(theWO.Id, theWO);

        List<WorkOrder> newVal = new List<WorkOrder>();
        newVal.add(newWO);

        

        GDMFSL_WorkOrderProcessor.setStatusforIntegration(newVal, oldVal);

        Test.stopTest();

        System.assertEquals(GDMFSL_WorkOrderProcessor.CLOSEDSTATUS, newVal[0].Status, 'setStatusforIntegration() did not result in the correct WO status for SAP Integration');

    }

    @IsTest
    static private void testsetStatusforIntegrationExport() {
        Test.startTest();
        WorkOrder theWO = [
                SELECT Id, SAP_Job_Type__c, Status, WorkTypeId,
                        GDMFSL_Executed_by_Sub_Contractor__c, GDMFSL_Chargeable__c, Work_Type_Category__c
                FROM WorkOrder
                WHERE WorkTypeId != NULL
                AND Work_Type_Category__c != :GDMFSL_WorkTypeProcessor.WORKTYPECATEGORY_BF
                AND Status != :GDMFSL_WorkOrderProcessor.COMPLETEDSTATUS
                LIMIT 1
        ];

        WorkOrder newWO = theWO.clone(true, true, true, false);
        newWO.Status = GDMFSL_WorkOrderProcessor.COMPLETEDSTATUS;
        newWO.GDMFSL_Executed_by_Sub_Contractor__c = false;
        newWO.GDMFSL_Chargeable__c = false;

        Map<Id, WorkOrder> oldVal = new Map<Id, WorkOrder>();
        oldVal.put(theWO.Id, theWO);

        List<WorkOrder> newVal = new List<WorkOrder>();
        newVal.add(newWO);

        

        GDMFSL_WorkOrderProcessor.setStatusforIntegration(newVal, oldVal);

        Test.stopTest();

        System.assertEquals(GDMFSL_WorkOrderProcessor.EXPORTSTATUS, newVal[0].Status, 'setStatusforIntegration() did not result in the correct WO status for SAP Integration Export');

    }

    @IsTest
    static private void testCancelNonCaseRelatedWOsNoCase() {
        Test.startTest();
        WorkOrder theWO = [
                SELECT Id, SAP_Job_Type__c, Status, WorkTypeId, ServiceContractId,
                        GDMFSL_Executed_by_Sub_Contractor__c, GDMFSL_Chargeable__c, Work_Type_Category__c
                FROM WorkOrder
                WHERE ServiceContractId != NULL
                AND Status IN :GDMFSL_WorkOrderProcessor.STATUSFORUPDATES
                LIMIT 1
        ];

        ServiceContract theSC = [SELECT Id, EndDate
                                FROM ServiceContract
                                WHERE Id = :theWO.ServiceContractId
                                LIMIT 1];

        

        theWO.CaseId = null;
        theWO.EndDate = theSC.EndDate.addDays(3);
        update theWO;

        GDMFSL_WorkOrderProcessor.cancelNonCaseRelatedWOs(new Map<Id, ServiceContract>{theSC.Id => theSC});

        Test.stopTest();

        System.debug('This test is just here for code coverage, not functional testing');

    }

}