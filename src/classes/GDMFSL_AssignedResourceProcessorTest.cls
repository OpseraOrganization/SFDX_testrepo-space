@IsTest
private class GDMFSL_AssignedResourceProcessorTest {


    @IsTest
    static void testLocationAndAssetShare(){

        Account theAccount = GDMFSL_DataFactory.createTestAccount('TestAcc');
        insert theAccount;

        OperatingHours theOpHours = GDMFSL_DataFactory.createOperatingHour();
        insert theOpHours;

        ServiceTerritory theServiceTerritory = GDMFSL_DataFactory.createServiceTerritory('ARes Test', theOpHours.Id);
        insert theServiceTerritory;

        Schema.Location aLocation = GDMFSL_DataFactory.createLocation('Campus',theServiceTerritory.Id);
        insert aLocation;

        List<Product2> theProd = GDMFSL_DataFactory.createProducts('Test Product',2);
        insert theProd;

        List<Asset> assetList = GDMFSL_DataFactory.createAssets('Test Asset',theProd[0].Id,theAccount.Id,1,aLocation.Id);
        assetList.addAll(GDMFSL_DataFactory.createAssets('Test Asset1',theProd[0].Id,theAccount.Id,1,aLocation.Id));
        assetList.addAll(GDMFSL_DataFactory.createAssets('Test Asset2',theProd[0].Id,theAccount.Id,1));  // NOT connected to the Location.
        insert assetList;

        Set<Id> assetIdSet = new Set<Id>();
        for(Asset a : assetList){
            assetIdSet.add(a.Id);
        }

        List<WorkType> lstworktype = GDMFSL_DataFactory.createWorkTypes('W001',3,30);
        insert lstworktype;

        WorkOrder theWorkOrder = GDMFSL_DataFactory.createWorkOrder(lstworktype[0].Id, theAccount.Id, aLocation.Id, Datetime.valueOfGmt('2020-09-04 18:00:00'), Datetime.valueOfGmt('2020-09-05 18:00:00'));
        theWorkOrder.GDMFSL_PO_Number__c = '12345';
        insert theWorkOrder;

        ServiceAppointment theSA = GDMFSL_DataFactory.createServiceAppointmentwithParentWO(theWorkOrder.Id,'Scheduled');
        theSA.SchedStartTime = System.now();
        theSA.SchedEndTime = System.now().addHours(4);
        insert theSA;

        User theUser = GDMFSL_DataFactory.createTestUser();
        insert theUser;

        ServiceResource theServRes = GDMFSL_DataFactory.createServiceResource(theUser.Id, aLocation.Id);
        theServRes.GDMFSL_IsContractor__c = true;
        insert theServRes;

        ServiceTerritoryMember theSTM = GDMFSL_DataFactory.createServiceTerritoryMember(theServRes.Id,theServiceTerritory.Id);
        theSTM.TerritoryType = 'P';
        insert theSTM;

        Test.startTest();
            AssignedResource ar = GDMFSL_DataFactory.createAssignedResource(theSA.Id,theServRes.Id);
            insert ar;
        Test.stopTest();

        List<LocationShare> lShareList2 = [SELECT Id, ParentId, UserOrGroupId, RowCause FROM LocationShare WHERE ParentId = :aLocation.Id AND UserOrGroupId = :theUser.Id];
        System.assertEquals(1, lShareList2.size(), 'Wrong number of LocationShares were created');
        System.assertEquals('Manual', lShareList2[0].RowCause, 'LocationShare has wrong RowCause');

        List<AssetShare> aShareList2 = [SELECT Id, AssetId, UserOrGroupId, RowCause FROM AssetShare WHERE AssetId IN :assetIdSet AND UserOrGroupId = :theUser.Id];
        System.assertEquals(2, aShareList2.size(), 'Wrong  number of AssetShares were created');
        System.assertEquals('Manual', aShareList2[0].RowCause, 'First AssetShare has wrong RowCause');
        System.assertEquals('Manual', aShareList2[1].RowCause, 'Second AssetShare has wrong RowCause');

    }

    @IsTest
    static void testLocationAndAssetShareNonContractor(){

        Account theAccount = GDMFSL_DataFactory.createTestAccount('TestAcc');
        insert theAccount;

        OperatingHours theOpHours = GDMFSL_DataFactory.createOperatingHour();
        insert theOpHours;

        ServiceTerritory theServiceTerritory = GDMFSL_DataFactory.createServiceTerritory('ARes Test', theOpHours.Id);
        insert theServiceTerritory;

        Schema.Location aLocation = GDMFSL_DataFactory.createLocation('Campus',theServiceTerritory.Id);
        insert aLocation;

        List<Product2> theProd = GDMFSL_DataFactory.createProducts('Test Product',2);
        insert theProd;

        List<Asset> assetList = GDMFSL_DataFactory.createAssets('Test Asset',theProd[0].Id,theAccount.Id,1,aLocation.Id);
        assetList.addAll(GDMFSL_DataFactory.createAssets('Test Asset1',theProd[0].Id,theAccount.Id,1,aLocation.Id));
        assetList.addAll(GDMFSL_DataFactory.createAssets('Test Asset2',theProd[0].Id,theAccount.Id,1));  // NOT connected to the Location.
        insert assetList;

        Set<Id> assetIdSet = new Set<Id>();
        for(Asset a : assetList){
            assetIdSet.add(a.Id);
        }

        List<WorkType> lstworktype = GDMFSL_DataFactory.createWorkTypes('W001',3,30);
        insert lstworktype;

        WorkOrder theWorkOrder = GDMFSL_DataFactory.createWorkOrder(lstworktype[0].Id, theAccount.Id, aLocation.Id, Datetime.valueOfGmt('2020-09-04 18:00:00'), Datetime.valueOfGmt('2020-09-05 18:00:00'));
        theWorkOrder.GDMFSL_PO_Number__c = '12345';
        insert theWorkOrder;

        ServiceAppointment theSA = GDMFSL_DataFactory.createServiceAppointmentwithParentWO(theWorkOrder.Id,'Scheduled');
        theSA.SchedStartTime = System.now();
        theSA.SchedEndTime = System.now().addHours(4);
        insert theSA;

        User theUser = GDMFSL_DataFactory.createTestUser();
        insert theUser;

        ServiceResource serviceResource = GDMFSL_DataFactory.createServiceResource(theUser.Id, aLocation.Id);
        serviceResource.GDMFSL_IsContractor__c = false;
        insert serviceResource;

        ServiceTerritoryMember serviceTerritoryMember = GDMFSL_DataFactory.createServiceTerritoryMember(serviceResource.Id,theServiceTerritory.Id);
        serviceTerritoryMember.TerritoryType = 'P';
        insert serviceTerritoryMember;

        Test.startTest();
        AssignedResource ar = GDMFSL_DataFactory.createAssignedResource(theSA.Id,serviceResource.Id);
        insert ar;
        Test.stopTest();

        List<LocationShare> shareList2 = [SELECT Id, ParentId, UserOrGroupId, RowCause FROM LocationShare WHERE ParentId = :aLocation.Id AND UserOrGroupId = :theUser.Id];
        System.assertEquals(0, shareList2.size(), 'Non-contractor LocationShares were created but should not have been');

        List<AssetShare> aShareList2 = [SELECT Id, AssetId, UserOrGroupId, RowCause FROM AssetShare WHERE AssetId IN :assetIdSet AND UserOrGroupId = :theUser.Id];
        System.assertEquals(0, aShareList2.size(), 'Non-contractor AssetShares were created but should not have been');

    }

    @IsTest
    static void getRecordsByServResId(){

        Account theAccount = GDMFSL_DataFactory.createTestAccount('TestAcc');
        insert theAccount;

        OperatingHours theOpHours = GDMFSL_DataFactory.createOperatingHour();
        insert theOpHours;

        ServiceTerritory theServiceTerritory = GDMFSL_DataFactory.createServiceTerritory('ARes Test', theOpHours.Id);
        insert theServiceTerritory;

        Schema.Location aLocation = GDMFSL_DataFactory.createLocation('Campus',theServiceTerritory.Id);
        insert aLocation;

        List<WorkType> lstworktype = GDMFSL_DataFactory.createWorkTypes('W001',3,30);
        insert lstworktype;

        WorkOrder theWorkOrder = GDMFSL_DataFactory.createWorkOrder(lstworktype[0].Id, theAccount.Id, aLocation.Id, Datetime.valueOfGmt('2020-09-04 18:00:00'), Datetime.valueOfGmt('2020-09-05 18:00:00'));
        theWorkOrder.GDMFSL_PO_Number__c = '12345';
        insert theWorkOrder;

        ServiceAppointment theSA = GDMFSL_DataFactory.createServiceAppointmentwithParentWO(theWorkOrder.Id,'Scheduled');
        theSA.SchedStartTime = System.now();
        theSA.SchedEndTime = System.now().addHours(4);
        insert theSA;

        List<User> theUsers = new List<User>();
        theUsers.add(GDMFSL_DataFactory.createTestUser());
        theUsers.add(GDMFSL_DataFactory.createTestUser());
        insert theUsers;

        List<ServiceResource> theServResources = new List<ServiceResource>();

        ServiceResource sr1 = GDMFSL_DataFactory.createServiceResource(theUsers[0].Id, aLocation.Id);
        sr1.GDMFSL_IsContractor__c = false;
        theServResources.add(sr1);

        ServiceResource sr2 = GDMFSL_DataFactory.createServiceResource(theUsers[1].Id, aLocation.Id);
        sr2.GDMFSL_IsContractor__c = true;
        theServResources.add(sr2);

        insert theServResources;

        List<ServiceTerritoryMember> stMembers = new List<ServiceTerritoryMember>();

        ServiceTerritoryMember stm1 = GDMFSL_DataFactory.createServiceTerritoryMember(sr1.Id,theServiceTerritory.Id);
        stm1.TerritoryType = 'P';
        stMembers.add(stm1);

        ServiceTerritoryMember stm2 = GDMFSL_DataFactory.createServiceTerritoryMember(sr2.Id,theServiceTerritory.Id);
        stm2.TerritoryType = 'P';
        stMembers.add(stm2);

        insert stMembers;

        List<AssignedResource> theAResources = new List<AssignedResource>();

        theAResources.add(GDMFSL_DataFactory.createAssignedResource(theSA.Id, sr1.Id));
        theAResources.add(GDMFSL_DataFactory.createAssignedResource(theSA.Id, sr2.Id));
        insert theAResources;

        Test.startTest();

        Map<Id, List<AssignedResource>> theAssignedResByServResId = GDMFSL_AssignedResourceProcessor.getAssignedResByServiceResourceId(new Set<Id>{sr1.Id});

        Test.stopTest();

        System.assertEquals(1, theAssignedResByServResId.size(), 'Wrong number of ServiceResource Ids returned');
        System.assertEquals(1, theAssignedResByServResId.get(sr1.Id).size(), 'Wrong number of AssignedResources returned for ServiceResource ID');
        System.assertEquals(sr1.Id, theAssignedResByServResId.get(sr1.Id)[0].ServiceResourceId, 'AssignedResources returned are not related to the requested ServiceResource ID');

        theAssignedResByServResId = GDMFSL_AssignedResourceProcessor.getAssignedResByServiceResourceId(new Set<Id>{sr2.Id});

        System.assertEquals(2, theAssignedResByServResId.size(), 'Wrong number of ServiceResource Ids returned on subsequent call');
        System.assertEquals(1, theAssignedResByServResId.get(sr1.Id).size(), 'Wrong number of AssignedResources returned for original ServiceResource ID');
        System.assertEquals(1, theAssignedResByServResId.get(sr2.Id).size(), 'Wrong number of AssignedResources returned for subsequent ServiceResource ID');
        System.assertEquals(sr1.Id, theAssignedResByServResId.get(sr1.Id)[0].ServiceResourceId, 'AssignedResources returned are not related to the originally requested ServiceResource ID on subsequent call');
        System.assertEquals(sr2.Id, theAssignedResByServResId.get(sr2.Id)[0].ServiceResourceId, 'AssignedResources returned are not related to the newly requested ServiceResource ID on subsequent call');

    }

    @IsTest
    static void getRecordsByServApptId(){

        Account theAccount = GDMFSL_DataFactory.createTestAccount('TestAcc');
        insert theAccount;

        OperatingHours theOpHours = GDMFSL_DataFactory.createOperatingHour();
        insert theOpHours;

        ServiceTerritory theServiceTerritory = GDMFSL_DataFactory.createServiceTerritory('ARes Test', theOpHours.Id);
        insert theServiceTerritory;

        Schema.Location aLocation = GDMFSL_DataFactory.createLocation('Campus',theServiceTerritory.Id);
        insert aLocation;
        System.debug('TestLocation Inserted : ' + aLocation);

        List<WorkType> lstworktype = GDMFSL_DataFactory.createWorkTypes('W001',3,30);
        insert lstworktype;

        WorkOrder theWorkOrder = GDMFSL_DataFactory.createWorkOrder(lstworktype[0].Id, theAccount.Id, aLocation.Id, Datetime.valueOfGmt('2020-09-04 18:00:00'), Datetime.valueOfGmt('2020-09-05 18:00:00'));
        theWorkOrder.GDMFSL_PO_Number__c = '12345';
        insert theWorkOrder;

        List<ServiceAppointment> theServAppts = new List<ServiceAppointment>();

        ServiceAppointment sa1 = GDMFSL_DataFactory.createServiceAppointmentwithParentWO(theWorkOrder.Id,'Scheduled');
        sa1.SchedStartTime = System.now();
        sa1.SchedEndTime = System.now().addHours(4);
        theServAppts.add(sa1);
        ServiceAppointment sa2 = GDMFSL_DataFactory.createServiceAppointmentwithParentWO(theWorkOrder.Id,'Scheduled');
        sa2.SchedStartTime = System.now();
        sa2.SchedEndTime = System.now().addHours(4);
        theServAppts.add(sa2);
        insert theServAppts;

        List<User> theUsers = new List<User>();
        theUsers.add(GDMFSL_DataFactory.createTestUser());
        theUsers.add(GDMFSL_DataFactory.createTestUser());
        insert theUsers;

        List<ServiceResource> theServResources = new List<ServiceResource>();

        ServiceResource sr1 = GDMFSL_DataFactory.createServiceResource(theUsers[0].Id, aLocation.Id);
        sr1.GDMFSL_IsContractor__c = false;
        theServResources.add(sr1);

        ServiceResource sr2 = GDMFSL_DataFactory.createServiceResource(theUsers[1].Id, aLocation.Id);
        sr2.GDMFSL_IsContractor__c = true;
        theServResources.add(sr2);

        insert theServResources;

        List<ServiceTerritoryMember> stMembers = new List<ServiceTerritoryMember>();

        ServiceTerritoryMember stm1 = GDMFSL_DataFactory.createServiceTerritoryMember(sr1.Id,theServiceTerritory.Id);
        stm1.TerritoryType = 'P';
        stMembers.add(stm1);

        ServiceTerritoryMember stm2 = GDMFSL_DataFactory.createServiceTerritoryMember(sr2.Id,theServiceTerritory.Id);
        stm2.TerritoryType = 'P';
        stMembers.add(stm2);

        insert stMembers;

        List<AssignedResource> theAResources = new List<AssignedResource>();

        theAResources.add(GDMFSL_DataFactory.createAssignedResource(sa1.Id, sr1.Id));
        theAResources.add(GDMFSL_DataFactory.createAssignedResource(sa2.Id, sr2.Id));
        insert theAResources;

        Test.startTest();

        Map<Id, List<AssignedResource>> theAssignedResByServApptId = GDMFSL_AssignedResourceProcessor.getAssignedResByServiceAppointmentId(new Set<Id>{sa1.Id});

        System.assertEquals(1, theAssignedResByServApptId.size(), 'Wrong number of ServiceAppointment Ids returned');
        System.assertEquals(1, theAssignedResByServApptId.get(sa1.Id).size(), 'Wrong number of AssignedResources returned for ServiceAppointment ID');
        System.assertEquals(sa1.Id, theAssignedResByServApptId.get(sa1.Id)[0].ServiceAppointmentId, 'AssignedResources returned are not related to the requested ServiceAppointment ID');

        theAssignedResByServApptId = GDMFSL_AssignedResourceProcessor.getAssignedResByServiceAppointmentId(new Set<Id>{sa2.Id});

        Test.stopTest();

        System.assertEquals(2, theAssignedResByServApptId.size(), 'Wrong number of ServiceAppointment Ids returned on subsequent call');
        System.assertEquals(1, theAssignedResByServApptId.get(sa1.Id).size(), 'Wrong number of AssignedResources returned for original ServiceAppointment ID');
        System.assertEquals(1, theAssignedResByServApptId.get(sa2.Id).size(), 'Wrong number of AssignedResources returned for subsequent ServiceAppointment ID');
        System.assertEquals(sa1.Id, theAssignedResByServApptId.get(sa1.Id)[0].ServiceAppointmentId, 'AssignedResources returned are not related to the originally requested ServiceAppointment ID on subsequent call');
        System.assertEquals(sa2.Id, theAssignedResByServApptId.get(sa2.Id)[0].ServiceAppointmentId, 'AssignedResources returned are not related to the newly requested ServiceAppointment ID on subsequent call');
    }

    @IsTest
    static void skipProcessTest() {

        Skip_Automation_Process__c profileCustomSetting = new Skip_Automation_Process__c();
        profileCustomSetting.SetupOwnerId = UserInfo.getOrganizationId();
        profileCustomSetting.ByPass_Automation__c = true;
        insert profileCustomSetting;


        Account theAccount = GDMFSL_DataFactory.createTestAccount('TestAcc');
        insert theAccount;

        OperatingHours theOpHours = GDMFSL_DataFactory.createOperatingHour();
        insert theOpHours;

        ServiceTerritory theServiceTerritory = GDMFSL_DataFactory.createServiceTerritory('ARes Test', theOpHours.Id);
        insert theServiceTerritory;

        Schema.Location aLocation = GDMFSL_DataFactory.createLocation('Campus',theServiceTerritory.Id);
        insert aLocation;

        List<Product2> theProd = GDMFSL_DataFactory.createProducts('Test Product',2);
        insert theProd;

        List<Asset> assetList = GDMFSL_DataFactory.createAssets('Test Asset',theProd[0].Id,theAccount.Id,1,aLocation.Id);
        assetList.addAll(GDMFSL_DataFactory.createAssets('Test Asset1',theProd[0].Id,theAccount.Id,1,aLocation.Id));
        assetList.addAll(GDMFSL_DataFactory.createAssets('Test Asset2',theProd[0].Id,theAccount.Id,1));  // NOT connected to the Location.
        insert assetList;

        Set<Id> assetIdSet = new Set<Id>();
        for(Asset a : assetList){
            assetIdSet.add(a.Id);
        }

        List<WorkType> lstworktype = GDMFSL_DataFactory.createWorkTypes('W001',3,30);
        insert lstworktype;

        WorkOrder theWorkOrder = GDMFSL_DataFactory.createWorkOrder(lstworktype[0].Id, theAccount.Id, aLocation.Id, Datetime.valueOfGmt('2020-09-04 18:00:00'), Datetime.valueOfGmt('2020-09-05 18:00:00'));
        theWorkOrder.GDMFSL_PO_Number__c = '12345';
        insert theWorkOrder;

        ServiceAppointment theSA = GDMFSL_DataFactory.createServiceAppointmentwithParentWO(theWorkOrder.Id,'Scheduled');
        theSA.SchedStartTime = System.now();
        theSA.SchedEndTime = System.now().addHours(4);
        insert theSA;

        User theUser = GDMFSL_DataFactory.createTestUser();
        insert theUser;

        ServiceResource theServRes = GDMFSL_DataFactory.createServiceResource(theUser.Id, aLocation.Id);
        theServRes.GDMFSL_IsContractor__c = true;
        insert theServRes;

        ServiceTerritoryMember theSTM = GDMFSL_DataFactory.createServiceTerritoryMember(theServRes.Id,theServiceTerritory.Id);
        theSTM.TerritoryType = 'P';
        insert theSTM;

        Test.startTest();
        AssignedResource ar = GDMFSL_DataFactory.createAssignedResource(theSA.Id,theServRes.Id);
        insert ar;
        Test.stopTest();

        List<LocationShare> lShareList2 = [SELECT Id, ParentId, UserOrGroupId, RowCause FROM LocationShare WHERE ParentId = :aLocation.Id AND UserOrGroupId = :theUser.Id];
        System.assertEquals(0, lShareList2.size(), 'LocationShares were created when Skip Processing is TRUE');

        List<AssetShare> aShareList2 = [SELECT Id, AssetId, UserOrGroupId, RowCause FROM AssetShare WHERE AssetId IN :assetIdSet AND UserOrGroupId = :theUser.Id];
        System.assertEquals(0, aShareList2.size(), 'AssetShares were created when Skip Processing is TRUE');
    }


}