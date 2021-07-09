/**
 * Name       :    GDMFSL_ServiceContractProcessorTest
 * Purpose    :    Test Logic for Service Contract Processor . See method descriptions for proper context for calling each method
 * --------------------------------------------------------------------------
 * Developer               Date          Description
 * --------------------------------------------------------------------------
 * Udbhav                  2021-Jan-22    Created
 **/
@IsTest
private class GDMFSL_ServiceContractProcessorTest {

    @TestSetup
    static void init() {

        Account theAcct = GDMFSL_DataFactory.createTestAccount('MergeTest');
        Id stdAcctRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Standard').getRecordTypeId();
        theAcct.RecordTypeId = stdAcctRecTypeId;
        theAcct.Source_System_Types__c = 'ShipTo';
        insert theAcct;

        Pricebook2 pricebook2 = GDMFSL_DataFactory.createPriceBook('DummyPriceBook');
        pricebook2.IsActive = true;
        pricebook2.GDMFSL_Default_Service_Offerings__c = true;
        insert pricebook2;

        GDMFSL_Agreement_Level__c agreementLevel = GDMFSL_DataFactory.createAgreementLevel('ALE1');
        agreementLevel.GDMFSL_After_Hr_Reactive_Coverage__c = true;
        insert agreementLevel;


        Schema.Location vanLoc = GDMFSL_DataFactory.createLocation('Van', null, null);
        vanLoc.TimeZone = 'America/New_York';
        insert vanLoc;


        List<ServiceContract> theSCs = new List<ServiceContract>();
        ServiceContract sc1 = GDMFSL_DataFactory.createServiceContract('SC1', theAcct.Id);
        sc1.GDMFSL_ATS_BreakFix_Hours__c = 100;
        theSCs.add(sc1);
        ServiceContract sc2 = GDMFSL_DataFactory.createServiceContract('SC2', theAcct.Id);
        theSCs.add(sc2);
        insert theSCs;
        System.debug('Inserted Test SCs from GDMFSL_ServiceContractProcessorTest.init');

        GDMFSL_Associated_Contract__c associatedContract = GDMFSL_DataFactory.createAssociatedContract(vanLoc.Id, sc1.Id, 5);
        insert associatedContract;

        User testUser = GDMFSL_DataFactory.createTestUser();
        insert testUser;

        ServiceResource sr = GDMFSL_DataFactory.createServiceResource(testUser.Id, vanLoc.Id);
        insert sr;


        GDMFSL_Service_Contract_Resource_Pref__c scResourcePref = GDMFSL_DataFactory.createServiceContractResourcePref(associatedContract.Id, sr.Id, 'Required');
        insert scResourcePref;
    }

    @IsTest
    static void getRecordsTest() {

        Set<Id> scIds = new Set<Id>();

        List<ServiceContract> lstSC = new List<ServiceContract>([SELECT Id FROM ServiceContract WHERE Name = 'SC1']);

        for (ServiceContract sc : lstSC) {
            scIds.add(sc.Id);
        }

        Map<Id, ServiceContract> mapSCsContractsByIds = GDMFSL_ServiceContractProcessor.getRecords(scIds);

        System.assertEquals(lstSC.size(), mapSCsContractsByIds.size(), 'getRecords() returned the wrong number of records');

        for (ServiceContract sc : mapSCsContractsByIds.values()) {
            System.assertEquals('SC1', sc.Name, 'getRecords() returned the wrong records');
        }

        List<ServiceContract> moreSC = new List<ServiceContract>([SELECT Id FROM ServiceContract WHERE Name = 'SC2']);

        scIds.clear();

        for (ServiceContract sc : moreSC) {
            scIds.add(sc.Id);
        }

        mapSCsContractsByIds = GDMFSL_ServiceContractProcessor.getRecords(scIds);

        System.assertEquals(2, mapSCsContractsByIds.size(), 'getRecords() returned the wrong number of records on subsequent call');

        for (ServiceContract sc : mapSCsContractsByIds.values()) {

            if (sc.Name != 'SC1' && sc.Name != 'SC2') {
                System.assert(false, 'getRecords() returned the wrong records on subsequent call');
            }
        }

    }

    @IsTest
    static void setInitialFieldsTest() {

        List<ServiceContract> lstSC = new List<ServiceContract>([SELECT Id,Pricebook2Id FROM ServiceContract]);

        Test.startTest();

        GDMFSL_ServiceContractProcessor.setInitialFields(lstSC);

        Test.stopTest();

        Pricebook2 thePBook = [
                SELECT Id
                FROM Pricebook2
                WHERE IsActive = TRUE
                AND GDMFSL_Default_Service_Offerings__c = TRUE
                LIMIT 1
        ];

        for (ServiceContract sc : lstSC) {
            System.assertEquals(thePBook.Id, sc.Pricebook2Id, 'Default PriceBook is not set on ServiceContract');
        }
    }

    @IsTest
    static void updateALEFieldsOnSCTest() {

        List<GDMFSL_Agreement_Level__c> agreementLevels = new List<GDMFSL_Agreement_Level__c>([
                SELECT Id,
                        Name,
                        GDMFSL_After_Hr_Reactive_Coverage__c
                FROM GDMFSL_Agreement_Level__c
        ]);
        List<ServiceContract> lstSC = new List<ServiceContract>([SELECT Id,AccountId,GDMFSL_After_Hr_Reactive_Response__c FROM ServiceContract]);

        for (ServiceContract sc : lstSC) {
            sc.GDMFSL_Agreement_Level__c = agreementLevels[0].Id;
        }

        Test.startTest();

        GDMFSL_ServiceContractProcessor.updateALEFieldsOnSC(lstSC);

        Test.stopTest();

        for (ServiceContract sc : lstSC) {
            System.assertEquals(agreementLevels[0].GDMFSL_After_Hr_Reactive_Coverage__c, sc.GDMFSL_After_Hr_Reactive_Response__c, 'ALE field not copied to SC');
        }
    }

    @IsTest
    static void updateALEFieldsSCALEChangesTest() {

        List<GDMFSL_Agreement_Level__c> agreementLevels = new List<GDMFSL_Agreement_Level__c>([
                SELECT Id,
                        Name,
                        GDMFSL_After_Hr_Reactive_Coverage__c
                FROM GDMFSL_Agreement_Level__c
        ]);
        List<ServiceContract> lstSC = new List<ServiceContract>([SELECT AccountId,
                ActivationDate,
                ApprovalStatus,
                BillingCity,
                BillingCountry,
                BillingCountryCode,
                BillingGeocodeAccuracy,
                BillingLatitude,
                BillingLongitude,
                BillingPostalCode,
                BillingState,
                BillingStateCode,
                BillingStreet,
                ContactId,
                ContractNumber,
                CreatedById,
                CreatedDate,
                CurrencyIsoCode,
                Description,
                Discount,
                EndDate,
                GDMFS_PO_Number_Reactive_Coverage__c,
                GDMFSL_24HrCoverage_BusinessDays__c,
                GDMFSL_Account_Manager__c,
                GDMFSL_Account_Manager_Name__c,
                GDMFSL_Actual_Time_Consumed_BF_Hours__c,
                GDMFSL_Actual_Time_Consumed_PM_Hours__c,
                GDMFSL_After_Hr_Reactive_Response__c,
                GDMFSL_Agreement_Level__c,
                GDMFSL_ATS_BreakFix_Hours__c,
                GDMFSL_ATS_PM_Hours__c,
                GDMFSL_Bill_to_Account__c,
                GDMFSL_Bill_To_Account_Number__c,
                GDMFSL_Bill_To_Source_System__c,
                GDMFSL_Billing_Frequency__c,
                GDMFSL_Cancellation_Reason__c,
                GDMFSL_Cancelled__c,
                GDMFSL_Connected_Digital_Services__c,
                GDMFSL_Contract_Amount__c,
                GDMFSL_Contract_Last_Renewal_Date__c,
                GDMFSL_Contract_Priority__c,
                GDMFSL_Contract_Type__c,
                GDMFSL_Customer_Care_Advocate__c,
                GDMFSL_Customer_Care_Rep__c,
                GDMFSL_DigitalServices_CS__c,
                GDMFSL_DigitalServices_OTS__c,
                GDMFSL_Distribution_Channel__c,
                GDMFSL_Email_BFHoursExhausted_Sent__c,
                GDMFSL_Email_PMHoursExhausted_Sent__c,
                GDMFSL_ERP_Contract_ID__c,
                GDMFSL_HolidayNoReactiveCoverage__c,
                GDMFSL_IsActive__c,
                GDMFSL_IsActiveInFuture__c,
                GDMFSL_L1__c,
                GDMFSL_L2__c,
                GDMFSL_Mobilization_Status__c,
                GDMFSL_Office_Hr_Reactive_Response__c,
                GDMFSL_Parts_Replacement_Management__c,
                GDMFSL_PartsReplacementManagement_L__c,
                GDMFSL_PartsStockManagement__c,
                GDMFSL_Preventative_Maintenance__c,
                GDMFSL_Profit_Center__c,
                GDMFSL_Reactive_Work_Chargeable__c,
                GDMFSL_Reactive_Work_Not_Chargeable__c,
                GDMFSL_ReactiveWork_Chargeable_L__c,
                GDMFSL_Region__c,
                GDMFSL_Remaining_BF_Hours__c,
                GDMFSL_Remaining_PM_Hours__c,
                GDMFSL_RemoteReactiveWork_Chargeable_L__c,
                GDMFSL_RemoteReactiveWork_NotChargeable__c,
                GDMFSL_RemoteSupport_AM__c,
                GDMFSL_RemoteSupport_BO__c,
                GDMFSL_RemoteSupport_SH__c,
                GDMFSL_Sales_Office__c,
                GDMFSL_Sales_Organization__c,
                GDMFSL_Sales_Rep__c,
                GDMFSL_SAP_Contract_Type__c,
                GDMFSL_SAP_Net_Price__c,
                GDMFSL_SC_Block__c,
                GDMFSL_SC_Block_Type__c,
                GDMFSL_Service_Leader__c,
                GDMFSL_Site_Resident_Labour_Present__c,
                GDMFSL_SLA_Guarantee_w_Financial_Penalty__c,
                GDMFSL_Software_Assurance__c,
                GDMFSL_Sold_To_Account_Number__c,
                GDMFSL_Sold_To_Source_System__c,
                GDMFSL_Tech_Phone_Support__c,
                GDMFSL_Third_Party_Support__c,
                GDMFSL_Travel_Time_Chargeable__c,
                GDMFSL_Warranty_Services__c,
                GDMFSL_X24hr_Reactive_Response__c,
                GrandTotal,
                Id,
                IsDeleted,
                LastModifiedById,
                LastModifiedDate,
                LastReferencedDate,
                LastViewedDate,
                LineItemCount,
                Name,
                Owner__c,
                OwnerId,
                ParentServiceContractId,
                Pricebook2Id,
                RootServiceContractId,
                ShippingCity,
                ShippingCountry,
                ShippingCountryCode,
                ShippingGeocodeAccuracy,
                ShippingHandling,
                ShippingLatitude,
                ShippingLongitude,
                ShippingPostalCode,
                ShippingState,
                ShippingStateCode,
                ShippingStreet,
                SpecialTerms,
                StartDate,
                Status,
                Subtotal,
                SystemModstamp,
                Tax,
                Term,
                TotalPrice
                FROM ServiceContract]);

        Map<Id, ServiceContract> oldValues = new Map<Id, ServiceContract>();

        for (ServiceContract sc : lstSC) {
            ServiceContract oldSC = sc.clone(true, true,true, true );

            oldValues.put(sc.Id, oldSC);

            sc.GDMFSL_Agreement_Level__c = agreementLevels[0].Id;
        }

        Test.startTest();

        GDMFSL_ServiceContractProcessor.updateALEFieldsOnSC(lstSC, oldValues);

        Test.stopTest();

        for (ServiceContract sc : lstSC) {
            System.assertEquals(agreementLevels[0].GDMFSL_After_Hr_Reactive_Coverage__c, sc.GDMFSL_After_Hr_Reactive_Response__c, 'ALE field not copied to SC');
        }
    }

    @IsTest
    static void getServContractResourcePrefRecordsTest() {

        Set<Id> scIds = new Set<Id>();

        List<ServiceContract> lstSC = new List<ServiceContract>([SELECT Id FROM ServiceContract WHERE Name = 'SC1']);

        for (ServiceContract sc : lstSC) {
            scIds.add(sc.Id);
        }

        Map<Id, List<GDMFSL_Service_Contract_Resource_Pref__c>> mapSCResourcPref = GDMFSL_ServiceContractProcessor.getServContractResourcePrefRecords(scIds);

        System.assertEquals(lstSC.size(), mapSCResourcPref.size(), 'getServContractResourcePrefRecords() - Found wrong number of ServiceContracts');
    }

    @IsTest
    static void skipProcess() {

        Skip_Automation_Process__c profileCustomSetting = new Skip_Automation_Process__c();
        profileCustomSetting.SetupOwnerId = UserInfo.getOrganizationId();
        profileCustomSetting.ByPass_Automation__c = true;

        insert profileCustomSetting;

        List<Account> theAc = [SELECT Id FROM Account];

        List<Pricebook2> pbs = new List<Pricebook2>([
                SELECT Id
                FROM Pricebook2
                WHERE IsActive = TRUE
                AND GDMFSL_Default_Service_Offerings__c = TRUE
                LIMIT 1
        ]);

        ServiceContract sc3 = GDMFSL_DataFactory.createServiceContract('SC3', theAc[0].Id);
        insert sc3;

        List<ServiceContract> lstSC = new List<ServiceContract>([SELECT Id,Pricebook2Id FROM ServiceContract WHERE Name = 'SC3']);

        Skip_Automation_Process__c profileCustomSetting1 = Skip_Automation_Process__c.getInstance();

        System.debug('Skip Automation Process : ' + profileCustomSetting1.ByPass_Automation__c);

        for (ServiceContract sc : lstSC) {
            System.assertNotEquals(sc.Pricebook2Id, pbs[0].Id, 'Default PriceBook Set on Service Contract but should not have been since process was skipped');
        }

    }


    @IsTest
    static void setATSHoursTest(){

        Account theAccount = GDMFSL_DataFactory.createTestAccount('TestAcc');
        insert theAccount;

        Contact theContact = GDMFSL_DataFactory.createTestContact(theAccount.Id);
        insert theContact;

        OperatingHours operatingHours = GDMFSL_DataFactory.createOperatingHour();
        insert operatingHours;

        ServiceTerritory serT = GDMFSL_DataFactory.createServiceTerritory('SA Test', operatingHours.Id);
        insert serT;

        GDMFSL_Vertical__c vert = GDMFSL_DataFactory.createEnvironmentVertical('TestVert');
        insert vert;

        GDMFSL_Site_License__c siteLic = GDMFSL_DataFactory.createSiteLicense('TestSiteLicense');
        insert siteLic;


        Schema.Location aLocation = GDMFSL_DataFactory.createLocation('Campus',serT.Id);
        aLocation.GDMFSL_Vertical__c = vert.Id;
        aLocation.GDMFSL_Site_License__c = siteLic.Id;
        insert aLocation;


        List<WorkType> allWTypes = GDMFSL_DataFactory.createWorkTypes('W001',1,30,'BF', null);
        allWTypes[0].ShouldAutoCreateSvcAppt = true;
        allWTypes.addAll(GDMFSL_DataFactory.createWorkTypes('W001',1,30,'PM', null));
        allWTypes[1].ShouldAutoCreateSvcAppt = true;
        insert allWTypes;

        List<Product2> prdts = GDMFSL_DataFactory.createProducts('Test Product', 1);
        insert prdts;

        List<Asset> assets = GDMFSL_DataFactory.createAssets('Asset Test', prdts[0].Id, theAccount.Id, 1);
        insert assets;

        Case c = GDMFSL_DataFactory.createCase('North America', assets[0].Id);
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        c.Origin = 'Phone';
        c.RecordTypeId = caseRecordTypeId;
        insert c;

        ServiceContract theSC = [SELECT Id FROM ServiceContract where Name='SC1'];

        List<WorkOrder> allWOs = new List<WorkOrder>();

        WorkOrder theWO = GDMFSL_DataFactory.createWorkOrder(allWTypes[0].Id, theAccount.Id, aLocation.Id, System.now(), System.now());
        theWO.GDMFSL_PO_Number__c = '12345';
        theWO.CaseId = c.Id;
        theWO.ServiceTerritoryId = serT.Id;
        theWO.GDMFSL_Created_by_WO_Merge_Process__c = true;
        theWO.Duration = 4.00;
        theWO.GDMFSL_Chargeable__c = true;
        theWO.ServiceContractId = theSC.Id;
        allWOs.add(theWO);

        WorkOrder theWO2 = GDMFSL_DataFactory.createWorkOrder(allWTypes[0].Id, theAccount.Id, aLocation.Id, System.now(), System.now());
        theWO2.GDMFSL_PO_Number__c = '12346';
        theWO2.CaseId = c.Id;
        theWO2.ServiceTerritoryId = serT.Id;
        theWO2.GDMFSL_Created_by_WO_Merge_Process__c = true;
        theWO2.Duration = 3.00;
        theWO2.GDMFSL_Chargeable__c = true;
        theWO2.ServiceContractId = theSC.Id;
        allWOs.add(theWO2);

        insert allWOs;

        Test.startTest();

        GDMFSL_ServiceContractProcessor.setATSHours(allWOs);

        Test.stopTest();
        ServiceContract theSC1 = [SELECT Id,GDMFSL_Actual_Time_Consumed_BF_Hours__c FROM ServiceContract where Name='SC1'];
        System.assertEquals(0,theSC1.GDMFSL_Actual_Time_Consumed_BF_Hours__c,'Derived Actual Time Consumed on BF is not correct');

    }

    @IsTest
    static void setATSHoursOnBFWithNoActTimeConsumedTest(){

        Account theAccount = GDMFSL_DataFactory.createTestAccount('TestAcc');
        insert theAccount;

        Contact theContact = GDMFSL_DataFactory.createTestContact(theAccount.Id);
        insert theContact;

        OperatingHours operatingHours = GDMFSL_DataFactory.createOperatingHour();
        insert operatingHours;

        ServiceTerritory serT = GDMFSL_DataFactory.createServiceTerritory('SA Test', operatingHours.Id);
        insert serT;

        GDMFSL_Vertical__c vert = GDMFSL_DataFactory.createEnvironmentVertical('TestVert');
        insert vert;

        GDMFSL_Site_License__c siteLic = GDMFSL_DataFactory.createSiteLicense('TestSiteLicense');
        insert siteLic;


        Schema.Location aLocation = GDMFSL_DataFactory.createLocation('Campus',serT.Id);
        aLocation.GDMFSL_Vertical__c = vert.Id;
        aLocation.GDMFSL_Site_License__c = siteLic.Id;
        insert aLocation;


        List<WorkType> allWTypes = GDMFSL_DataFactory.createWorkTypes('W001',1,30,'BF', null);
        allWTypes[0].ShouldAutoCreateSvcAppt = true;
        allWTypes.addAll(GDMFSL_DataFactory.createWorkTypes('W001',1,30,'PM', null));
        allWTypes[1].ShouldAutoCreateSvcAppt = true;
        insert allWTypes;

        List<Product2> prdts = GDMFSL_DataFactory.createProducts('Test Product', 1);
        insert prdts;

        List<Asset> assets = GDMFSL_DataFactory.createAssets('Asset Test', prdts[0].Id, theAccount.Id, 1);
        insert assets;

        Case c = GDMFSL_DataFactory.createCase('North America', assets[0].Id);
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        c.Origin = 'Phone';
        c.RecordTypeId = caseRecordTypeId;
        insert c;

        ServiceContract theSC = [SELECT Id FROM ServiceContract LIMIT 1];
        theSC.GDMFSL_Actual_Time_Consumed_BF_Hours__c = null;
        theSC.GDMFSL_Travel_Time_Chargeable__c = true;
        update theSC;

        List<WorkOrder> allWOs = new List<WorkOrder>();

        WorkOrder theWO = GDMFSL_DataFactory.createWorkOrder(allWTypes[0].Id, theAccount.Id, aLocation.Id, System.now(), System.now());
        theWO.GDMFSL_PO_Number__c = '12345';
        theWO.CaseId = c.Id;
        theWO.ServiceTerritoryId = serT.Id;
        theWO.GDMFSL_Created_by_WO_Merge_Process__c = true;
        theWO.Duration = 4.00;
        theWO.GDMFSL_Chargeable__c = true;
        theWO.ServiceContractId = theSC.Id;
        allWOs.add(theWO);

        WorkOrder theWO2 = GDMFSL_DataFactory.createWorkOrder(allWTypes[0].Id, theAccount.Id, aLocation.Id, System.now(), System.now());
        theWO2.GDMFSL_PO_Number__c = '12346';
        theWO2.CaseId = c.Id;
        theWO2.ServiceTerritoryId = serT.Id;
        theWO2.GDMFSL_Created_by_WO_Merge_Process__c = true;
        theWO2.Duration = 3.00;
        theWO2.GDMFSL_Chargeable__c = true;
        theWO2.ServiceContractId = theSC.Id;
        allWOs.add(theWO2);

        insert allWOs;

        Test.startTest();

        GDMFSL_ServiceContractProcessor.setATSHours(allWOs);

        Test.stopTest();
        ServiceContract theSC1 = [SELECT Id,GDMFSL_Actual_Time_Consumed_BF_Hours__c FROM ServiceContract where Name='SC1'];
        System.assertEquals(0,theSC1.GDMFSL_Actual_Time_Consumed_BF_Hours__c,'Derived Actual Time Consumed on BF is not correct');

    }

}