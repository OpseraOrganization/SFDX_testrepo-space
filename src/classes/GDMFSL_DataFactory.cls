/*******************************************************************************************
Name       :    GDMFSL_DataFactory
Purpose    :    Class with factory methods for creating/setting up the SObject data for unit tests.
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
Masood                  2020-Aug-25    Created
Udbhav                  2020-Aug-26    Updated with new methods for ServiceAppointment,ServiceTerritory,
                                       ServiceTerritoryMember,OperatingHours
**********************************************************************************************/

@IsTest
public class GDMFSL_DataFactory {


    public static Skip_Automation_Process__c createProfileCustomSetting(Boolean automationFlag) {
        return new Skip_Automation_Process__c(ByPass_Automation__c = automationFlag);
    }

    public static Account createTestAccount(String accName) {
        return new Account(Name = accName, BillingStreet = 'TestStreet', BillingCity = 'TestCity',
                BillingCountry = 'United States');
    }


    public static Contact createTestContact(Id accid) {
        return new Contact(FirstName = 'John', LastName = 'Doe', Email = 'testTESTtest@grr.la', Birthdate = null, AccountId = accid);
    }


    public static User createTestUser(String profileNameToUse) {

        if (profileNameToUse == null) {
            profileNameToUse = 'System Administrator';
        }

        Profile p = [SELECT Id FROM Profile WHERE Name = :profileNameToUse];

        return new User(Alias = 'standa', Email = 'saplingstandarduser@testorg.com', LastName = 'Testing',
                LocaleSidKey = 'en_US', ProfileId = p.Id, EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US',
                TimeZoneSidKey = 'America/Los_Angeles', Username = System.now().millisecond() + Math.random() + '@testorg.com');
    }

    public static User createTestUser() {
        return createTestUser(null);
    }

    public static AssignedResource createAssignedResource(Id saId, Id srId) {
        return new AssignedResource(ServiceAppointmentId = saId, ServiceResourceId = srId,
                FSL__UpdatedByOptimization__c = false);
    }

    public static ServiceResource createServiceResource(Id userId, Id locId) {
        return new ServiceResource(Name = 'TestUserSR', IsActive = true,
                RelatedRecordId = userId, LocationId = locId, ResourceType = 'T');
    }

    public static FSL__User_Territory__c createUserTerritories(Id userid, Id servterrid) {
        return new FSL__User_Territory__c (FSL__ServiceTerritory__c = servterrid, FSL__User__c = userid);
    }

    public static List<Product2> createProducts(String productName, Integer numberOfProducts) {

        List<Product2> products = new List<Product2>();

        for (Integer i = 0; i < numberOfProducts; i++) {
            Product2 product = new Product2 (Name = productName + i + 1);
            products.add(product);
        }

        return products;
    }

    public static List<Asset> createAssets(String assetName, Id ProductId, Id AccId, Integer numberOfAssets) {
        return createAssets(assetName, ProductId, AccId, numberOfAssets, null);
    }

    public static List<Asset> createAssets(String assetName, Id ProductId, Id AccId, Integer numberOfAssets, Id locationId) {

        List<Asset> assets = new List<Asset>();

        for (Integer i = 0; i < numberOfAssets; i++) {
            Asset asset = new Asset (Name = assetName + i + 1, Product2Id = ProductId, AccountId = AccId, LocationId = locationId);
            assets.add(asset);
        }

        return assets;
    }

    public static List<GDMFSL_Maintenance_Template__c> createMaintTemplates(String mainTemplateName, Id ProductId, Integer numberOfMainTemplates) {

        List<GDMFSL_Maintenance_Template__c> maintenanceTemplates = new List<GDMFSL_Maintenance_Template__c>();

        for (Integer i = 0; i < numberOfMainTemplates; i++) {
            maintenanceTemplates.add(new GDMFSL_Maintenance_Template__c (Name = mainTemplateName, GDMFSL_Product__c = ProductId));
        }

        return maintenanceTemplates;
    }

    public static List<GDMFSL_Maintenance_Template__c> createCompleteMaintTemplates(String mainTemplateName, Id productId,
            Id worktypeId, Integer numberOfMainTemplates) {

        List<GDMFSL_Maintenance_Template__c> maintenanceTemplates = new List<GDMFSL_Maintenance_Template__c>();

        for (Integer i = 0; i < numberOfMainTemplates; i++) {
            GDMFSL_Maintenance_Template__c maintenanceTemplate = new GDMFSL_Maintenance_Template__c (Name = mainTemplateName,
                    GDMFSL_Work_Type__c = worktypeId, GDMFSL_Product__c = productId, GDMFSL_Frequency_Type__c = 'Weekly',
                    GDMFSL_Recurrence_Type__c = 'Monthly On Day of Month', GDMFSL_Frequency_Every_N__c = 1, GDMFSL_Duration_minutes__c = 30);
            maintenanceTemplates.add(maintenanceTemplate);
        }

        return maintenanceTemplates;
    }

    public static List<GDMFSL_Asset_Maintenance_Frequency__c> createAssetMaintenances(Id assetId, Integer numberOfASMFs) {
        List<GDMFSL_Asset_Maintenance_Frequency__c> assetMaintenanceFrequencies = new List<GDMFSL_Asset_Maintenance_Frequency__c>();
        for (Integer i = 0; i < numberOfASMFs; i++) {
            assetMaintenanceFrequencies.add(new GDMFSL_Asset_Maintenance_Frequency__c (GDMFSL_Asset__c = assetId));
        }
        return assetMaintenanceFrequencies;
    }

    public static WorkType createWorkType(String workTypeName, Double EstDuration) {
        return createWorkTypes(workTypeName, 1, EstDuration, null, null)[0];
    }


    public static List<WorkType> createWorkTypes(String workTypeName, Integer numberOfWorkTypes, Double EstDuration) {
        return createWorkTypes(workTypeName, numberOfWorkTypes, EstDuration, null, null);
    }

    public static List<WorkType> createWorkTypes(String workTypeName, Integer numberOfWorkTypes, Double EstDuration, String workTypeCategory, String priority) {
        List<WorkType> workTypes = new List<WorkType>();

        for (Integer i = 0; i < numberOfWorkTypes; i++) {
            WorkType workType = new WorkType (Name = workTypeName, EstimatedDuration = EstDuration, DurationType = 'Minutes',
                    GDMFSL_Priority__c = priority, GDMFSL_WorkType_Category__c = workTypeCategory);
            workTypes.add(workType);
        }

        return workTypes;
    }

    public static OperatingHours createOperatingHour() {
        return new OperatingHours (Name = 'Sample Operating Hour', TimeZone = 'America/Los_Angeles');
    }

    public static TimeSlot createTimeSlot(Id opId, String dow, Time sTime, Time eTime ){
        return new TimeSlot(OperatingHoursId=opId, DayOfWeek=dow, StartTime=sTime, EndTime=eTime, Type = 'Normal' );
    }

    public static ServiceTerritory createServiceTerritory(String sTerrName, Id operatingHourId) {
        return new ServiceTerritory (Name = sTerrName, OperatingHoursId = operatingHourId, IsActive = true);
    }

    public static GDMFSL_On_Demand_Assignment__c createOnDemandAssignment(Id ServiceResourceID, Id ServiceTerritoryId) {
        return new GDMFSL_On_Demand_Assignment__c (GDMFSL_Service_Resource__c = ServiceResourceID, GDMFSL_Service_Territory__c = ServiceTerritoryId);
    }

    public static ServiceAppointment createServiceAppointment(Id accountId, String status) {
        return new ServiceAppointment (ParentRecordId = accountId, Status = status, DueDate = System.today() + 3,
                EarliestStartTime = System.today(),
                SchedStartTime = System.today(), SchedEndTime = System.today() + 1);
    }

    public static List<ServiceAppointment> createServiceAppointments(Id accountId, String status, Integer numSAs) {

        List<ServiceAppointment> saEmptyList = new List<ServiceAppointment>();

        for (Integer i = 0; i < numSAs; i++) {
            ServiceAppointment sa = new ServiceAppointment();
            sa.ParentRecordId = accountId;
            sa.Status = status;
            sa.DueDate = System.today() + 3;
            sa.EarliestStartTime = System.today();
            sa.SchedStartTime = System.today();
            sa.SchedEndTime = System.today() + 1;
            saEmptyList.add(sa);
        }


        return saEmptyList;
    }


    public static ServiceTerritoryMember createServiceTerritoryMember(Id serviceResourceId, Id serviceTerritoryId) {
        return new ServiceTerritoryMember (ServiceResourceId = serviceResourceId, ServiceTerritoryId = serviceTerritoryId, EffectiveStartDate = System.today()-2);
    }

    public static Schema.Location createLocation(String locationType, Id serviceTerritoryId) {
        return createLocation(locationType, serviceTerritoryId, null);
    }

    public static WorkOrder createWorkOrder(Id worktypeId, Id accountId, Id locationId, Datetime startdate, Datetime endTime) {
        return new WorkOrder(WorkTypeId = worktypeId, AccountId = accountId, LocationId = locationId, StartDate = startdate, EndDate = endTime);
    }

    public static ServiceAppointment createServiceAppointmentwithParentWO(Id workOrderId, String status) {
        return new ServiceAppointment (ParentRecordId = workOrderId, Status = status);
    }

    public static WorkOrderLineItem createWorkOrderLineItem(Id workTypeId, Id workOrderId, Id assetId) {
        return new WorkOrderLineItem(WorkTypeId = workTypeId, WorkOrderId = workOrderId, AssetId = assetId);
    }

    public static ServiceContract createServiceContract(String scName, Id theAccountId) {
        return new ServiceContract (AccountId = theAccountId, Name = scName, StartDate = System.today(), EndDate = System.today() + 2);
    }

    public static ContractLineItem createCLI(Id serviceContractId, Id priceBookEntryId) {
        return new ContractLineItem(ServiceContractId = serviceContractId, PricebookEntryId = priceBookEntryId, UnitPrice = 1.0);
    }

    public static Schema.Address createAddress(String street, String city, String state, String postcode, String country, Id parentId) {
        return new Schema.Address(Street = street, City = city, State = state, PostalCode = postcode, Country = country, ParentId = parentId);
    }

    public static MaintenancePlan createMaintenancePlan(Id theWorkTypeId) {
        return new MaintenancePlan ( MaintenanceWindowStartDays = 3, WorkTypeId = theWorkTypeId, Frequency = 5, FrequencyType = 'Months', StartDate = Date.today(), NextSuggestedMaintenanceDate = Date.today().addDays(5), GenerationTimeframe = 2, GenerationTimeframeType = 'Months');
    }

    public static MaintenanceAsset createMaintenanceAsset(Id mPlanId, Id assetId) {
        return new MaintenanceAsset (MaintenancePlanId = mPlanId, AssetId = assetId);
    }

    public static MaintenanceWorkRule createMaintenanceWorkRule(Id mPlanId, Id mAssetId, String title, String recurr){
        return new MaintenanceWorkRule (Title = title, ParentMaintenanceRecordId = mAssetId, ParentMaintenancePlanId = mPlanId, SortOrder = 1, RecurrencePattern = recurr);
    }

    public static Schema.Location createLocation(String locationType, Id serviceTerritoryId, Id operatinghoursId) {
        return new Schema.Location(Name = 'Sample Location', LocationType = locationType,
                IsInventoryLocation = true, IsMobile = true, GDMFSL_Service_Territory__c = serviceTerritoryId,
                GDMFSL_Working_Hours__c = operatinghoursId);
    }

    public static GDMFSL_Location_Resource_Preference__c createLocationResourcePreference(Id locationId, Id serviceresourceId, String preferenceType, Id worktypeId) {
        return new GDMFSL_Location_Resource_Preference__c(GDMFSL_Location__c = locationId, GDMFSL_Service_Resource__c = serviceresourceId,
                GDMFSL_Preference_Type__c = preferenceType);
    }

    public static GDMFSL_Asset_Resource_Preference__c createAssetResourcePreference(Id assetId, Id serviceresourceId, String preferenceType) {
        return new GDMFSL_Asset_Resource_Preference__c(GDMFSL_Asset__c = assetId, GDMFSL_Service_Resource__c = serviceresourceId,
                GDMFSL_Preference_Type__c = preferenceType);
    }

    public static GDMFSL_Service_Contract_Resource_Pref__c createServiceContractResourcePref(Id associatedContract, Id serviceresourceId, String preferenceType) {
        return new GDMFSL_Service_Contract_Resource_Pref__c(GDMFSL_Associated_Contract__c = associatedContract, GDMFSL_Service_Resource__c = serviceresourceId,
                GDMFSL_Preference_Type__c = preferenceType);
    }

    public static GDMFSL_Associated_Contract__c createAssociatedContract(Id locationId, Id servicecontractId, Integer minChargeTime) {
        return new GDMFSL_Associated_Contract__c(Service_Contract__c = servicecontractId, Location__c = locationId,
                GDMFSL_Min_Charge_Time__c = minChargeTime);
    }

    public static GDMFSL_SLA__c createSLAforCLI(Id cliId, String priority, Integer arrivaltime, Integer responsetime, Integer resolutionTime) {
        return new GDMFSL_SLA__c(GDMFSL_Contract_Line_Item__c = cliId, GDMFSL_Priority__c = priority, GDMFSL_Arrival_Time__c = arrivaltime,
                GDMFSL_Resolution_Time__c = resolutionTime, GDMFSL_Response_Time__c = responsetime);
    }

    public static GDMFSL_SLA__c createSLAforAssociatedContract(Id acId, String priority, Integer arrivaltime, Integer responsetime, Integer resolutionTime) {
        return new GDMFSL_SLA__c(GDMFSL_Associated_Contract__c = acId, GDMFSL_Priority__c = priority, GDMFSL_Arrival_Time__c = arrivaltime,
                GDMFSL_Resolution_Time__c = resolutionTime, GDMFSL_Response_Time__c = responsetime);
    }

    public static List<Expense> createExpenses(Id WOId, String expType, Decimal expAmount, Integer numberOfExpenses) {
        List<Expense> expenses = new List<Expense>();

        for (Integer i = 0; i < numberOfExpenses; i++) {
            expenses.add(new Expense(WorkOrderId = WOId, ExpenseType = expType, Amount = expAmount, TransactionDate = System.today()));
        }

        return expenses;
    }

    public static ResourcePreference createResourcePreference(String preferenceType, Id resourceId, Id relatedrecordId) {
        return new ResourcePreference(RelatedRecordId = relatedrecordId, PreferenceType = preferenceType, ServiceResourceId = resourceId);
    }

    public static Pricebook2 createPriceBook(String priceBookName) {
        return new Pricebook2(Name = priceBookName);
    }

    public static PricebookEntry createPriceBookEntry(Id productId) {
        Id pricebookId = Test.getStandardPricebookId();
        return new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = productId, UnitPrice = 1.0, IsActive = true);
    }

    public static Case createCase(String region, Id assetId) {
       
        return new Case(Region__c = region, AssetId = assetId, Origin = 'HBS_US_South_Field_Support'); 
         
    }

    public static GDMFSL_Agreement_Level__c createAgreementLevel(String name) {
        return new GDMFSL_Agreement_Level__c(Name = name);
    }

    public static List<Shift> createShift(Integer numberOfShifts) {
        List<Shift> shifts = new List<Shift>();

        for (Integer i = 0; i < numberOfShifts; i++) {
            shifts.add(new Shift(StartTime = Datetime.now(), EndTime = Datetime.now().addDays(10), Status = 'Tentative'));
        }

        return shifts;
    }

    public static Source_System__c createSourceSystem(Id accountId, String sourceId) {
        return new Source_System__c(Account__c = accountId, Source_Id__c = sourceId);
    }

    public static GDMFSL_Discipline__c createDiscipline(String disciplineName) {
        return new GDMFSL_Discipline__c(Name = disciplineName);
    }

    public static GDMFSL_Profit_Center__c createProfitCenter(String recName, Id servTerrId, Id disciplineId, String salesOrg) {
        return new GDMFSL_Profit_Center__c(Name = recName, GDMFSL_Service_Territory__c = servTerrId, GDMFSL_Discipline__c = disciplineId,
                GDMFSL_Sales_Organization__c = salesOrg.left(4));
    }

    public static ShiftPattern createShiftPattern(String recName, Integer patternLength) {
        return new ShiftPattern(Name = recName, PatternLength = patternLength, IsActive = true);
    }
    public static ShiftTemplate createShiftTemplate(string name) {
        return new ShiftTemplate(Name = name, IsActive = true, StartTime = Time.newInstance(08, 0, 0, 0), ShiftTemplateDurationType = 'H', Duration = 8);
    }

    public static ShiftPatternEntry createShiftPatternEntry(Integer dayPosition, Id shiftPatternId, Id shiftTemplateId) {
        return new ShiftPatternEntry(DayOrder = dayPosition, ShiftPatternId = shiftPatternId, ShiftTemplateId = shiftTemplateId);
    }

    public static Shift_Pattern_Assignment__c createShiftPatternAssign(Id serviceResourceId, Id serviceTerritoryId, Id shiftPatternId, Decimal schedulingOccurence,
            Date endDate, Date startDate) {
        return new Shift_Pattern_Assignment__c(Shift_Pattern__c = shiftPatternId, Service_Resource__c = serviceResourceId, Service_Territory__c = serviceTerritoryId,
                Scheduling_Start_Date__c = startDate, Scheduling_End_Date__c = endDate, Scheduling_Occurrences__c = schedulingOccurence);
    }

    public static GDMFSL_Vertical__c createEnvironmentVertical(String name) {
        return new GDMFSL_Vertical__c(Name = name);
    }

    public static GDMFSL_Site_License__c createSiteLicense(String name) {
        return new GDMFSL_Site_License__c(Name = name);
    }

    public static GDMFSL_Asset_Component__c createAssetComponent(Id assetId,Id productId,Decimal quantity)
    {
        return new GDMFSL_Asset_Component__c(GDMFSL_Parent_Asset__c=assetId,GDMFSL_Product__c=productId,GDMFSL_Qty__c=quantity);
    }

    public static WorkPlanSelectionRule createWorkPlanSelectionRule(Id serviceContractId,Id serviceTerrId ,Id productId,Id workPlanTempId,Id workTypeId)
    {
      return new WorkPlanSelectionRule(ServiceContractId=serviceContractId,ServiceTerritoryId=serviceTerrId,Product2Id=productId,
              WorkPlanTemplateId=workPlanTempId,
              WorkTypeId=workTypeId,
              IsActive=true);
    }

    public static List<ContentVersion> createListOfContentVersions(Integer nOfCV){
        List <contentVersion> contentVersionList = new List<contentVersion>();
        for(integer i=0;i<nOfCV;i++)
        {
            ContentVersion contentVersion = new ContentVersion(Title = 'Penguins'+i,
                                                          PathOnClient = 'Penguins.jpg',
                                                          VersionData = Blob.valueOf('Test Content'),
                                                          IsMajorVersion = true);
            contentVersionList.add(contentVersion);
        }
        return contentVersionList;
    }

    public static TimeSheet createTimeSheet(Date sDate, Date eDate, Id servResource){
        return new TimeSheet(startDate=sDate, EndDate=eDate, ServiceResourceId=servResource);
    }

    public static TimeSheetEntry createTimeSheetEntry(DateTime sTime, DateTime eTime, Id tSheetId, Id woId){
        return new TimeSheetEntry(StartTime=sTime, EndTime=eTime, TimeSheetId=tSheetId, WorkOrderId=woId);
        
    }


}