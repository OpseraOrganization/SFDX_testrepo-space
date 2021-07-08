/*******************************************************************************************
Name       :    GDMFSL_ServiceAppointmentProcessorTest
Purpose    :    Test Method for DMFSL_ServiceAppointmentProcessor class . See method descriptions for proper context for calling each method
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
Udbhav                  2020-Sep-01    Created
**********************************************************************************************/
@IsTest
public without sharing class GDMFSL_ServiceAppointmentProcessorTest {

    @IsTest
    static void testSetSAFieldsFromWO() {

        Account account = GDMFSL_DataFactory.createTestAccount('TestAcc');
        insert account;

        Contact contact = GDMFSL_DataFactory.createTestContact(account.Id);
        insert contact;

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


        List<WorkType> lstworktype = GDMFSL_DataFactory.createWorkTypes('W001',3,30,'BF', null);
        lstworktype[0].ShouldAutoCreateSvcAppt = true;
        insert lstworktype;

        List<Product2> prdts = GDMFSL_DataFactory.createProducts('Test Product', 1);
        insert prdts;

        List<Asset> assets = GDMFSL_DataFactory.createAssets('Asset Test', prdts[0].Id, account.Id, 1);
        insert assets;

        Case c = GDMFSL_DataFactory.createCase('North America', assets[0].Id);
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        c.Origin = 'Phone';
        c.RecordTypeId = caseRecordTypeId;
        insert c;

        WorkOrder workorder = GDMFSL_DataFactory.createWorkOrder(lstworktype[0].Id, account.Id, aLocation.Id, System.now(), System.now());
        workorder.GDMFSL_PO_Number__c = '12345';
        workOrder.CaseId = c.Id;
        workorder.ServiceTerritoryId = serT.Id;
        workorder.GDMFSL_Created_by_WO_Merge_Process__c = true;
        workorder.Duration = 4.00;
        workorder.GDMFSL_Chargeable__c = true;

        Test.startTest();
        insert workorder;
        Test.stopTest();
        ServiceAppointment sa = [Select Id, GDMFSL_Location__c, GDMFSL_Chargeable__c, ServiceTerritoryId, ParentRecordId, ParentRecordType, AccountId, Duration, GDMFSL_Vertical__c, GDMFSL_Site_License__c From ServiceAppointment Where ParentRecordId =: workorder.Id AND ParentRecordType = 'WorkOrder'];
        System.Debug('SA Created: ' + sa);
        System.assertEquals(sa.GDMFSL_Location__c, workorder.LocationId, 'Locations Should Match');
        System.assertEquals(sa.AccountId, workorder.AccountId, 'Account Should Match');
        System.assertEquals(sa.GDMFSL_Vertical__c, vert.Id, 'Vertical Should Match');
        System.assertEquals(sa.GDMFSL_Site_License__c, siteLic.Id, 'Site License Should Match');
        System.assertEquals(sa.ServiceTerritoryId, workorder.ServiceTerritoryId, 'Service Territory Should Match');
        System.assertEquals(sa.Duration, workorder.Duration, 'Duration Should Match');
        System.assertEquals(sa.GDMFSL_Chargeable__c, 'Yes', 'Chargable Should Be true');
       
        
    }

    @IsTest
    static void testGetRecords(){
        Set<Id> saIds = new Set<Id>();
        Map<Id, ServiceAppointment> mapToTest = new Map<Id, ServiceAppointment>();
        Account account = GDMFSL_DataFactory.createTestAccount('TestAcc');
        insert account;

        ServiceAppointment sa = GDMFSL_DataFactory.createServiceAppointment(account.Id,'None' );
        insert sa;

        saIds.add(sa.Id);
        
        Test.startTest();
        mapToTest = GDMFSL_ServiceAppointmentProcessor.getRecords(saIds);
        Test.stopTest();

        System.assert(!mapToTest.isEmpty(), 'Map Should Not Be Empty');

    }

    @IsTest
    static void testCanSABeCancelledValid(){
        FSL.GlobalAPIS.addStatusTransition('None', 'Canceled');
        Account account = GDMFSL_DataFactory.createTestAccount('TestAcc');
        insert account;

        Contact contact = GDMFSL_DataFactory.createTestContact(account.Id);
        insert contact;

        OperatingHours operatingHours = GDMFSL_DataFactory.createOperatingHour();
        insert operatingHours;

        ServiceTerritory serviceTerritory = GDMFSL_DataFactory.createServiceTerritory('SA Test', operatingHours.Id);
        insert serviceTerritory;

        Schema.Location aLocation = GDMFSL_DataFactory.createLocation('Campus',serviceTerritory.Id);
        insert aLocation;


        List<WorkType> lstworktype = GDMFSL_DataFactory.createWorkTypes('W001',3,30,'BF', null);
        lstworktype[0].ShouldAutoCreateSvcAppt = true;
        insert lstworktype;

        List<Product2> prdts = GDMFSL_DataFactory.createProducts('Test Product', 1);
        insert prdts;

        List<Asset> assets = GDMFSL_DataFactory.createAssets('Asset Test', prdts[0].Id, account.Id, 1);
        insert assets;

        Case c = GDMFSL_DataFactory.createCase('North America', assets[0].Id);
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        c.Origin = 'Phone';
        c.RecordTypeId = caseRecordTypeId;
        insert c;

        WorkOrder workorder = GDMFSL_DataFactory.createWorkOrder(lstworktype[0].Id, account.Id, aLocation.Id, System.now(), System.now());
        workorder.GDMFSL_PO_Number__c = '12345';
        workOrder.CaseId = c.Id;
        insert workorder;

        Case caseToUdpate = [Select Id, Status FROM Case Where Id =: c.Id Limit 1];

        Test.startTest();
        caseToUdpate.status = 'Canceled';
        update caseToUdpate;
        Test.stopTest();

        WorkOrder woToCheck = [Select Id, Status from WorkOrder WHere CaseID =: caseToUdpate.Id];
        System.assertEquals('Canceled', woToCheck.Status,'WO not Cancelled');
        


    }



    @IsTest
    static void testprocessCompletedSAs(){
        FSL.GlobalAPIS.addStatusTransition('None', 'Scheduled');
        FSL.GlobalAPIS.addStatusTransition('Scheduled', 'Dispatched');
        FSL.GlobalAPIS.addStatusTransition('Dispatched', 'Accepted');
        FSL.GlobalAPIS.addStatusTransition('Accepted', 'Travel');
        FSL.GlobalAPIS.addStatusTransition('Travel', 'Onsite');
        FSL.GlobalAPIS.addStatusTransition('Onsite', 'Check Out');
        FSL.GlobalAPIS.addStatusTransition('Check Out', 'Completed');


        Account account = GDMFSL_DataFactory.createTestAccount('TestAcc');
        insert account;

        Contact contact = GDMFSL_DataFactory.createTestContact(account.Id);
        insert contact;

        OperatingHours operatingHours = GDMFSL_DataFactory.createOperatingHour();
        insert operatingHours;

        ServiceTerritory serviceTerritory = GDMFSL_DataFactory.createServiceTerritory('SA Test', operatingHours.Id);
        insert serviceTerritory;

        Schema.Location aLocation = GDMFSL_DataFactory.createLocation('Campus',serviceTerritory.Id);
        insert aLocation;


        List<WorkType> lstworktype = GDMFSL_DataFactory.createWorkTypes('W001',3,30,'BF', null);
        lstworktype[0].ShouldAutoCreateSvcAppt = true;
        insert lstworktype;

        List<Product2> prdts = GDMFSL_DataFactory.createProducts('Test Product', 1);
        insert prdts;

        List<Asset> assets = GDMFSL_DataFactory.createAssets('Asset Test', prdts[0].Id, account.Id, 1);
        insert assets;

        Case c = GDMFSL_DataFactory.createCase('North America', assets[0].Id);
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        c.Origin = 'Phone';
        c.RecordTypeId = caseRecordTypeId;
        insert c;

        WorkOrder workorder = GDMFSL_DataFactory.createWorkOrder(lstworktype[0].Id, account.Id, aLocation.Id, System.now(), System.now());
        workorder.GDMFSL_PO_Number__c = '12345';
        workOrder.CaseId = c.Id;
        insert workorder;

        Id p = [SELECT Id FROM Profile WHERE Name = :GDMFSL_LocationTriggerHandler.COMMUNPROFILENAME].Id;
        
        User user = new User(Alias = 'test123', Email='test123@noemail.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p, Country='United States',IsActive =true,
        ContactId = contact.Id,
        TimeZoneSidKey='America/Los_Angeles', Username='tester@noemail.com');
        insert user;

        System.runAs(user)
        {
            List<PermissionSet> pSetList = [SELECT Id FROM PermissionSet WHERE Name = 'FSL_Resource_Permissions'];
            PermissionSetAssignment  pr = new PermissionSetAssignment (AssigneeId=user.Id,PermissionSetId=pSetList[0].Id);
            insert pr;
        }

        ServiceResource serRes = GDMFSL_DataFactory.createServiceResource(user.Id, null);
        serRes.GDMFSL_IsContractor__c = true;
        insert serRes;

        ServiceTerritoryMember stm = new ServiceTerritoryMember(ServiceTerritoryId=serviceTerritory.Id,ServiceResourceId=serRes.Id,
                                                                    TerritoryType='P', EffectiveStartDate=System.today()-1);
        insert stm;

        ServiceAppointment sa = [Select Id, Status, SchedStartTime, ParentRecordId, ParentRecordType, SchedEndTime From ServiceAppointment Where ParentRecordId =: workorder.Id AND ParentRecordType = 'WorkOrder'];

        System.debug('The SA: ' + sa);
        System.debug('The SA SobjectType: ' + sa.ParentRecordId.getSobjectType());
        sa.Status = 'Scheduled';
        sa.SchedStartTime = System.now();
        sa.SchedEndTime = System.now();
        update sa;

        AssignedResource assignedResource = GDMFSL_DataFactory.createAssignedResource(sa.Id,serRes.Id);
        insert assignedResource;        
        
        sa.Status = 'Dispatched';
        update sa;

        sa.Status = 'Accepted';
        update sa;

        sa.Status = 'Travel';
        update sa;

        sa.Status = 'Onsite';
        update sa;

        sa.Status = 'Check Out';
        update sa;

        sa.Status = 'Completed';
        update sa;

        List<ServiceAppointment> lstToTest = new List<ServiceAppointment>();
        lstToTest.add(sa);

        Test.startTest();
        GDMFSL_ServiceAppointmentProcessor.processCompletedSAs(lstToTest);
        Test.stopTest(); 

        WorkOrder relatedWO = [Select Id, GDMFSL_Executed_by_Sub_Contractor__c from WorkOrder Where Id =: lstToTest[0].ParentRecordId];
        System.assertEquals(true, relatedWO.GDMFSL_Executed_by_Sub_Contractor__c,'Executed by Contractor not True');

    }

    @isTest
    public static void testUnscheduleServContractSAs(){
        FSL.GlobalAPIS.addStatusTransition('None', 'Scheduled');
        FSL.GlobalAPIS.addStatusTransition('Scheduled', 'None');
        
        Account account = GDMFSL_DataFactory.createTestAccount('TestAcc');
        insert account;

        Contact contact = GDMFSL_DataFactory.createTestContact(account.Id);
        insert contact;

        OperatingHours operatingHours = GDMFSL_DataFactory.createOperatingHour();
        insert operatingHours;

        ServiceTerritory serviceTerritory = GDMFSL_DataFactory.createServiceTerritory('SA Test', operatingHours.Id);
        insert serviceTerritory;

        Schema.Location aLocation = GDMFSL_DataFactory.createLocation('Campus',serviceTerritory.Id);
        insert aLocation;


        List<WorkType> lstworktype = GDMFSL_DataFactory.createWorkTypes('W001',3,30,'BF', null);
        lstworktype[0].ShouldAutoCreateSvcAppt = true;
        insert lstworktype;

        List<Product2> prdts = GDMFSL_DataFactory.createProducts('Test Product', 1);
        insert prdts;

        List<Asset> assets = GDMFSL_DataFactory.createAssets('Asset Test', prdts[0].Id, account.Id, 1);
        insert assets;

        Case c = GDMFSL_DataFactory.createCase('North America', assets[0].Id);
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        c.Origin = 'Phone';
        c.RecordTypeId = caseRecordTypeId;
        insert c;

        ServiceContract sc = GDMFSL_DataFactory.createServiceContract('Test Service Contract', account.Id);
        sc.GDMFSL_SC_Block__c = false;
        insert sc;

        WorkOrder workorder = GDMFSL_DataFactory.createWorkOrder(lstworktype[0].Id, account.Id, aLocation.Id, System.now(), System.now());
        workorder.GDMFSL_PO_Number__c = '12345';
        workOrder.CaseId = c.Id;
        workorder.ServiceContractId = sc.Id;
        insert workorder;

        Id p = [SELECT Id FROM Profile WHERE Name = :GDMFSL_LocationTriggerHandler.COMMUNPROFILENAME].Id;
        
        User user = new User(Alias = 'test123', Email='test123@noemail.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p, Country='United States',IsActive =true,
        ContactId = contact.Id,
        TimeZoneSidKey='America/Los_Angeles', Username='tester@noemail.com');
        insert user;

        System.runAs(user)
        {
            List<PermissionSet> pSetList = [SELECT Id FROM PermissionSet WHERE Name = 'FSL_Resource_Permissions'];
            PermissionSetAssignment  pr = new PermissionSetAssignment (AssigneeId=user.Id,PermissionSetId=pSetList[0].Id);
            insert pr;
        }

        ServiceResource serRes = GDMFSL_DataFactory.createServiceResource(user.Id, null);
        serRes.GDMFSL_IsContractor__c = true;
        insert serRes;

        ServiceTerritoryMember stm = new ServiceTerritoryMember(ServiceTerritoryId=serviceTerritory.Id,ServiceResourceId=serRes.Id,
                                                                    TerritoryType='P', EffectiveStartDate=System.today());
        insert stm;

        

        ServiceAppointment sa = [Select Id, Status, SchedStartTime, GDMFSL_Service_Contract__c, ParentRecordId, ParentRecordType, SchedEndTime From ServiceAppointment Where ParentRecordId =: workorder.Id AND ParentRecordType = 'WorkOrder'];
        sa.Status = 'Scheduled';
        sa.SchedStartTime = System.now();
        sa.SchedEndTime = System.now();
        sa.GDMFSL_Service_Contract__c = sc.Id;
        update sa;

        ServiceContract scToUpdate = [Select Id, GDMFSL_SC_Block_Type__c, GDMFSL_SC_Block__c from ServiceContract Where Id =: workorder.ServiceContractId];
        scToUpdate.GDMFSL_SC_Block__c = true;
        scToUpdate.GDMFSL_SC_Block_Type__c = 'ZR_Serv Contrt Renewal';
        update scToUpdate;

        Set<Id> serviceContractIds = new Set<Id>();
        serviceContractIds.add(scToUpdate.Id);

        Test.startTest();
        GDMFSL_ServiceAppointmentProcessor.unscheduleServContractSAs(serviceContractIds);
        Test.stopTest();

        ServiceAppointment updatedSa = [Select id, GDMFSL_Service_Contract__c, status from ServiceAppointment where GDMFSL_Service_Contract__c =: scToUpdate.Id ];
        system.assertEquals('None', updatedSa.Status, 'SA Status should be None');

    }

    @isTest
    public static void unScheduleAccountBlockedSAs(){
        FSL.GlobalAPIS.addStatusTransition('None', 'Scheduled');
        FSL.GlobalAPIS.addStatusTransition('Scheduled', 'None');
        
        Account account = GDMFSL_DataFactory.createTestAccount('TestAcc');
        insert account;

        Source_System__c souSys = GDMFSL_DataFactory.createSourceSystem(account.Id, 'SCID123');
        souSys.GDMFSL_Delivery_Block__c = false;
        souSys.Customer_Order_Block__c = false;
        insert souSys;

        Contact contact = GDMFSL_DataFactory.createTestContact(account.Id);
        insert contact;

        OperatingHours operatingHours = GDMFSL_DataFactory.createOperatingHour();
        insert operatingHours;

        ServiceTerritory serviceTerritory = GDMFSL_DataFactory.createServiceTerritory('SA Test', operatingHours.Id);
        insert serviceTerritory;

        Schema.Location aLocation = GDMFSL_DataFactory.createLocation('Campus',serviceTerritory.Id);
        insert aLocation;


        List<WorkType> lstworktype = GDMFSL_DataFactory.createWorkTypes('W001',3,30,'BF', null);
        lstworktype[0].ShouldAutoCreateSvcAppt = true;
        insert lstworktype;

        List<Product2> prdts = GDMFSL_DataFactory.createProducts('Test Product', 1);
        insert prdts;

        List<Asset> assets = GDMFSL_DataFactory.createAssets('Asset Test', prdts[0].Id, account.Id, 1);
        insert assets;

        Case c = GDMFSL_DataFactory.createCase('North America', assets[0].Id);
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        c.Origin = 'Phone';
        c.RecordTypeId = caseRecordTypeId;
        insert c;

        ServiceContract sc = GDMFSL_DataFactory.createServiceContract('Test Service Contract', account.Id);
        sc.GDMFSL_SC_Block__c = false;
        insert sc;

        WorkOrder workorder = GDMFSL_DataFactory.createWorkOrder(lstworktype[0].Id, account.Id, aLocation.Id, System.now(), System.now());
        workorder.GDMFSL_PO_Number__c = '12345';
        workOrder.CaseId = c.Id;
        workorder.ServiceContractId = sc.Id;
        workorder.GDMFSL_Sold_To_Source_System_Reference__c = souSys.Id;
        workorder.GDMFSL_Bill_To_Source_System_Reference__c = souSys.Id;
        insert workorder;

        Id p = [SELECT Id FROM Profile WHERE Name = :GDMFSL_LocationTriggerHandler.COMMUNPROFILENAME].Id;
        
        User user = new User(Alias = 'test123', Email='test123@noemail.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p, Country='United States',IsActive =true,
        ContactId = contact.Id,
        TimeZoneSidKey='America/Los_Angeles', Username='tester@noemail.com');
        insert user;

        System.runAs(user)
        {
            List<PermissionSet> pSetList = [SELECT Id FROM PermissionSet WHERE Name = 'FSL_Resource_Permissions'];
            PermissionSetAssignment  pr = new PermissionSetAssignment (AssigneeId=user.Id,PermissionSetId=pSetList[0].Id);
            insert pr;
        }

        ServiceResource serRes = GDMFSL_DataFactory.createServiceResource(user.Id, null);
        serRes.GDMFSL_IsContractor__c = true;
        insert serRes;

        ServiceTerritoryMember stm = new ServiceTerritoryMember(ServiceTerritoryId=serviceTerritory.Id,ServiceResourceId=serRes.Id,
                                                                    TerritoryType='P', EffectiveStartDate=System.today());
        insert stm;

        

        ServiceAppointment sa = [Select Id, Status, SchedStartTime, GDMFSL_Service_Contract__c, ParentRecordId, ParentRecordType, SchedEndTime From ServiceAppointment Where ParentRecordId =: workorder.Id AND ParentRecordType = 'WorkOrder'];
        sa.Status = 'Scheduled';
        sa.SchedStartTime = System.now();
        sa.SchedEndTime = System.now();
        sa.GDMFSL_Service_Contract__c = sc.Id;
        sa.GDMFSL_Sold_To_Source_System_Reference__c = souSys.Id;
        update sa;
        
        List<Source_System__c> sourceSystToUpdate = [Select id, Name, Customer_Order_Block__c, GDMFSL_Delivery_Block__c from Source_System__c where Id =: souSys.Id ];
        sourceSystToUpdate[0].Customer_Order_Block__c = true;
        sourceSystToUpdate[0].GDMFSL_Delivery_Block__c = true;
        update sourceSystToUpdate;

        Test.startTest();
        GDMFSL_SourceSystemProcessor.checkWOsRelatedToBlockedSourceSystem(sourceSystToUpdate, null);
        Test.stopTest();

        ServiceAppointment updatedSa = [Select id, GDMFSL_Sold_To_Source_System_Reference__c, status from ServiceAppointment where GDMFSL_Sold_To_Source_System_Reference__c =: souSys.Id ];
        system.assertEquals('None', updatedSa.Status, 'SA Status should be None');

    }
}