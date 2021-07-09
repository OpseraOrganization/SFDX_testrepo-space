/*******************************************************************************************
Name       :    GDMFSL_ResourcePreferenceProcessorTest
Purpose    :    Test class for GDMFSL_ResourcePreferenceProcessor.
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
Udbhav                  2020-Sep-14    Created
************************************************************************************************/

@IsTest
private class GDMFSL_ResourcePreferenceProcessorTest {

    @IsTest
    static void testBehavior() {

        OperatingHours operatingHours = GDMFSL_DataFactory.createOperatingHour();
        insert operatingHours;
        System.debug('operatingHours Inserted: ' + operatingHours);

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('ResPref Test', operatingHours.Id);
        insert st;
        System.debug('ServiceTerritory Inserted: ' + st);

        Schema.Location location = GDMFSL_DataFactory.createLocation('Campus', st.Id, operatingHours.Id);
        Schema.Location location1 = GDMFSL_DataFactory.createLocation('Campus', null, operatingHours.Id);
        List<Schema.Location > lstlocation = new List<Schema.Location >();
        lstlocation.add(location);
        lstlocation.add(location1);
        insert lstlocation;
        System.debug('locations Inserted: ' + lstlocation);

        User testUser = GDMFSL_DataFactory.createTestUser();
        insert testUser;
        System.debug('User Inserted: ' + testUser);

        ServiceResource sr = GDMFSL_DataFactory.createServiceResource(testUser.Id, lstlocation[0].Id);
        insert sr;
        System.debug('ServiceResource Inserted: ' + sr);

        List<WorkType> lstworkType = new List<WorkType>();
        lstworkType.addAll(GDMFSL_DataFactory.createWorkTypes('PMWorkType', 1, 30, GDMFSL_WorkTypeProcessor.WORKTYPECATEGORY_PM, 'High'));
        lstworkType.addAll(GDMFSL_DataFactory.createWorkTypes('BFWorkType', 1, 30, GDMFSL_WorkTypeProcessor.WORKTYPECATEGORY_BF, 'Critical'));
        insert lstworkType;
        System.debug('WorkType Inserted: ' + lstworkType);

        Account ac = GDMFSL_DataFactory.createTestAccount('TestAccount');
        insert ac;
        System.debug('Account Inserted: ' + ac);

        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(lstworkType[0].Id, ac.Id, lstlocation[0].Id, System.now(), System.now());
        wo.GDMFSL_PO_Number__c = '123';
        insert wo;
        System.debug('WorkOrder Inserted: ' + wo);

        ResourcePreference rp = GDMFSL_DataFactory.createResourcePreference('Required', sr.Id, wo.Id);
        insert rp;
        System.debug('Resource preference Inserted');

        Set<Id> resourcePrefIds = new Set<Id>();
        resourcePrefIds.add(rp.Id);

        Set<Id> workOrderIds = new Set<Id>();
        workOrderIds.add(wo.Id);

        Map<Id, ResourcePreference> mapresourcePref = GDMFSL_ResourcePreferenceProcessor.getRecords(resourcePrefIds);
        System.assertEquals(1, mapresourcePref.size(), 'Resource Preference was not fetched');
    }

    @IsTest
    static void testGetRecordsRelatedToWO() {
        OperatingHours operatingHours = GDMFSL_DataFactory.createOperatingHour();
        insert operatingHours;
        System.debug('operatingHours Inserted: ' + operatingHours);

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('ResPref Test', operatingHours.Id);
        insert st;
        System.debug('ServiceTerritory Inserted: ' + st);

        Schema.Location location = GDMFSL_DataFactory.createLocation('Campus', st.Id, operatingHours.Id);
        Schema.Location location1 = GDMFSL_DataFactory.createLocation('Campus', null, operatingHours.Id);
        List<Schema.Location > lstlocation = new List<Schema.Location >();
        lstlocation.add(location);
        lstlocation.add(location1);
        insert lstlocation;
        System.debug('locations Inserted: ' + lstlocation);

        User testUser = GDMFSL_DataFactory.createTestUser();
        insert testUser;
        System.debug('User Inserted: ' + testUser);

        ServiceResource sr = GDMFSL_DataFactory.createServiceResource(testUser.Id, lstlocation[0].Id);
        insert sr;
        System.debug('ServiceResource Inserted: ' + sr);

        List<WorkType> lstworkType = new List<WorkType>();
        lstworkType.addAll(GDMFSL_DataFactory.createWorkTypes('PMWorkType', 1, 30, GDMFSL_WorkTypeProcessor.WORKTYPECATEGORY_PM, 'High'));
        lstworkType.addAll(GDMFSL_DataFactory.createWorkTypes('BFWorkType', 1, 30, GDMFSL_WorkTypeProcessor.WORKTYPECATEGORY_BF, 'Critical'));
        insert lstworkType;
        System.debug('WorkType Inserted: ' + lstworkType);

        Account ac = GDMFSL_DataFactory.createTestAccount('TestAccount');
        insert ac;
        System.debug('Account Inserted: ' + ac);

        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(lstworkType[0].Id, ac.Id, lstlocation[0].Id, System.now(), System.now());
        wo.GDMFSL_PO_Number__c = '123';
        insert wo;
        System.debug('WorkOrder Inserted: ' + wo);

        ResourcePreference rp = GDMFSL_DataFactory.createResourcePreference('Required', sr.Id, wo.Id);
        insert rp;
        System.debug('Resource preference Inserted');

        Set<Id> resourcePrefIds = new Set<Id>();
        resourcePrefIds.add(rp.Id);

        Set<Id> workOrderIds = new Set<Id>();
        workOrderIds.add(wo.Id);
        Test.startTest();
        Map<Id, List<ResourcePreference>> maprelatedWOresourcePref = GDMFSL_ResourcePreferenceProcessor.getRecordsForParentId(workOrderIds);
        Test.stopTest();

        System.assertEquals(1, maprelatedWOresourcePref.size(), 'Does not return the correct number of WO ResourcePreferences');
        System.assert(maprelatedWOresourcePref.containsKey(wo.Id), 'Does not return the correct WO');
        System.assertEquals(1, maprelatedWOresourcePref.get(wo.Id).size(), 'Does not return the correct number of ResourcePreferences for this WO');
        System.assertEquals(rp.Id, maprelatedWOresourcePref.get(wo.Id)[0].Id, 'Does not return the correct ResourcePreference for this WO');
    }

    @IsTest
    static void testOnDemandAssignment() {
        OperatingHours operatingHours = GDMFSL_DataFactory.createOperatingHour();
        insert operatingHours;
        System.debug('operatingHours Inserted: ' + operatingHours);


        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('ResPref Test', operatingHours.Id);
        insert st;
        System.debug('ServiceTerritory Inserted: ' + st);

        Schema.Location location = GDMFSL_DataFactory.createLocation('Campus', st.Id, operatingHours.Id);
        Schema.Location location1 = GDMFSL_DataFactory.createLocation('Campus', null, operatingHours.Id);
        List<Schema.Location > lstlocation = new List<Schema.Location >();
        lstlocation.add(location);
        lstlocation.add(location1);
        insert lstlocation;
        System.debug('locations Inserted: ' + lstlocation);

        User testUser = GDMFSL_DataFactory.createTestUser();
        insert testUser;
        System.debug('User Inserted: ' + testUser);

        ServiceResource sr = GDMFSL_DataFactory.createServiceResource(testUser.Id, lstlocation[0].Id);
        insert sr;
        System.debug('ServiceResource Inserted: ' + sr);

        List<WorkType> lstworkType = new List<WorkType>();
        lstworkType.addAll(GDMFSL_DataFactory.createWorkTypes('PMWorkType', 1, 30, GDMFSL_WorkTypeProcessor.WORKTYPECATEGORY_PM, 'High'));
        lstworkType.addAll(GDMFSL_DataFactory.createWorkTypes('BFWorkType', 1, 30, GDMFSL_WorkTypeProcessor.WORKTYPECATEGORY_BF, 'Critical'));
        insert lstworkType;
        System.debug('WorkType Inserted: ' + lstworkType);

        Account ac = GDMFSL_DataFactory.createTestAccount('TestAccount');
        insert ac;
        System.debug('Account Inserted: ' + ac);

        List<Product2> p = GDMFSL_DataFactory.createProducts('Test Product', 1);
        insert p;
        List<Asset> a = GDMFSL_DataFactory.createAssets('Test Asset', p[0].Id, ac.Id, 1);
        insert a;

        Case c = GDMFSL_DataFactory.createCase('North America', a[0].Id);
        c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        c.Origin = 'Community';
        c.GDMFSL_On_Demand__c = true;
        insert c;


        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(lstworkType[0].Id, ac.Id, lstlocation[0].Id, System.now(), System.now());
        wo.GDMFSL_PO_Number__c = '123';
        wo.CaseId = c.Id;
        insert wo;
        System.debug('WorkOrder Inserted: ' + wo);

        ResourcePreference rp = GDMFSL_DataFactory.createResourcePreference('Required', sr.Id, wo.Id);
        insert rp;
        System.debug('Resource preference Inserted');

        Set<Id> resourcePrefIds = new Set<Id>();
        resourcePrefIds.add(rp.Id);

        Set<Id> workOrderIds = new Set<Id>();
        workOrderIds.add(wo.Id);
        Test.startTest();
        Map<Id, List<ResourcePreference>> maprelatedWOresourcePref = GDMFSL_ResourcePreferenceProcessor.getRecordsForParentId(workOrderIds);
        Test.stopTest();

        System.assertEquals(1, maprelatedWOresourcePref.size(), 'Does not return the correct number of WO ResourcePreferences');
        System.assert(maprelatedWOresourcePref.containsKey(wo.Id), 'Does not return the correct WO');
        System.assertEquals(1, maprelatedWOresourcePref.get(wo.Id).size(), 'Does not return the correct number of ResourcePreferences for this WO');
        System.assertEquals(rp.Id, maprelatedWOresourcePref.get(wo.Id)[0].Id, 'Does not return the correct ResourcePreference for this WO');
    }
    @IsTest
    static void testassessExistingWOResourcePreferences() {
        system.debug('inside method testassessExistingWOResourcePreferences()');
        WorkType WT = GDMFSL_DataFactory.createWorkType('WorkTypeTest', 30);
        insert WT;

        list<Product2> products = GDMFSL_DataFactory.createProducts('Prod', 1);
        insert products;

        OperatingHours operatingHours = GDMFSL_DataFactory.createOperatingHour();
        insert operatingHours;
        System.debug('operatingHours Inserted: ' + operatingHours);

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('ST000', operatingHours.Id);
        insert st;
        System.debug('ServiceTerritory Inserted: ' + st);

        Schema.Location location = GDMFSL_DataFactory.createLocation('Campus', st.Id, operatingHours.Id);
        insert location;
        System.debug('location Inserted: ' + location);

        Account acc = GDMFSL_DataFactory.createTestAccount('TestAccount111');
        insert acc;
        System.debug('Account Inserted: ' + acc);

        list<Asset> assets = GDMFSL_DataFactory.createAssets('Asset', products[0].Id, acc.Id, 1);
        insert assets;
        System.debug('assets Inserted testassessExistingWOResourcePreferences: ' + acc);

        ServiceContract sc = GDMFSL_DataFactory.createServiceContract('SCtest', acc.Id);
        sc.GDMFSL_Site_Resident_Labour_Present__c = true;
        insert sc;

        GDMFSL_Associated_Contract__c AC = GDMFSL_DataFactory.createAssociatedContract(location.Id, sc.Id, 23);
        insert AC;
        System.debug('GDMFSL_Associated_Contract__c inserted: ' + AC);

        User testuser = GDMFSL_DataFactory.createTestUser();
        insert testuser;
        ServiceResource sr = GDMFSL_DataFactory.createServiceResource(testuser.Id, location.Id);
        sr.ResourceType = 'T';
        sr.IsActive = TRUE;
        insert sr;
        System.debug('test user inserted ' + sr);

        GDMFSL_Asset_Resource_Preference__c AssetResPref = GDMFSL_DataFactory.createAssetResourcePreference(assets[0].Id, sr.Id, 'Preferred');
        insert AssetResPref;
        System.debug('Asset Resource Preference inserted ' + AssetResPref);


        GDMFSL_On_Demand_Assignment__c ODA = GDMFSL_DataFactory.createOnDemandAssignment(sr.Id, st.Id);
        insert ODA;
        System.debug('ODA inserted ' + ODA);

        ServiceTerritoryMember StMem = GDMFSL_DataFactory.createServiceTerritoryMember(sr.Id, st.Id);
        insert StMem;
        System.debug('ServiceTerritoryMember inserted ' + ODA);

        GDMFSL_Service_Contract_Resource_Pref__c SCPref = GDMFSL_DataFactory.createServiceContractResourcePref(AC.Id, sr.Id, 'Preferred');
        insert SCPref;

        GDMFSL_Location_Resource_Preference__c LocPref = GDMFSL_DataFactory.createLocationResourcePreference(location.Id, sr.Id, '', WT.Id);
        insert LocPref;
        System.debug('LOcation Pref inserted ' + LocPref);

        Id servReqRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        Id genInqRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_General_Inquiry').getRecordTypeId();
        Case ca = GDMFSL_DataFactory.createCase('APAC',assets[0].Id);
        ca.RecordTypeId = servReqRecTypeId;
        ca.GDMFSL_On_Demand__c = true;
        insert ca;


        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(WT.Id, acc.Id, location.Id, System.now(), System.now());
        wo.GDMFSL_PO_Number__c = '999999';
        wo.ServiceContractId = sc.Id;
        wo.ServiceTerritoryId = st.Id;
        wo.AssetId = assets[0].Id;
        wo.CaseId = ca.Id;

        insert wo;

        list<WorkOrder>lstWO = new List<WorkOrder>();
        lstWO.add(wo);

        System.debug('WorkOrder Inserted testassessExistingWOResourcePreferences: ' + wo);
        Test.startTest();
        GDMFSL_ResourcePreferenceProcessor.assessExistingWOResourcePreferences(lstWO);
        Test.stopTest();
        list<ResourcePreference> respref = [Select ID,RelatedRecordId from ResourcePreference where RelatedRecordId = :wo.Id AND ServiceResourceId = :sr.Id];
        System.debug('ResourcePreference list from SOQL' + respref);

        system.assertNotEquals(0,respref.size(), 'No Resource preferences were returned');

    }
    @IsTest
    static void testassessExistingWOResourcePreferences_2() {
        system.debug('inside method testassessExistingWOResourcePreferences()');
        WorkType WT = GDMFSL_DataFactory.createWorkType('WorkTypeTest', 30);
        insert WT;

        list<Product2> products = GDMFSL_DataFactory.createProducts('Prod', 1);
        insert products;

        OperatingHours operatingHours = GDMFSL_DataFactory.createOperatingHour();
        insert operatingHours;
        System.debug('operatingHours Inserted: ' + operatingHours);

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('ST000', operatingHours.Id);
        insert st;
        System.debug('ServiceTerritory Inserted: ' + st);

        Schema.Location location = GDMFSL_DataFactory.createLocation('Campus', st.Id, operatingHours.Id);
        insert location;
        System.debug('location Inserted: ' + location);

        Account acc = GDMFSL_DataFactory.createTestAccount('TestAccount111');
        insert acc;
        System.debug('Account Inserted: ' + acc);

        list<Asset> assets = GDMFSL_DataFactory.createAssets('Asset', products[0].Id, acc.Id, 1);
        insert assets;
        System.debug('assets Inserted testassessExistingWOResourcePreferences: ' + acc);

        ServiceContract sc = GDMFSL_DataFactory.createServiceContract('SCtest', acc.Id);
        sc.GDMFSL_Site_Resident_Labour_Present__c = true;
        insert sc;

        GDMFSL_Associated_Contract__c AC = GDMFSL_DataFactory.createAssociatedContract(location.Id, sc.Id, 23);
        insert AC;
        System.debug('GDMFSL_Associated_Contract__c inserted: ' + AC);

        User testuser = GDMFSL_DataFactory.createTestUser();
        insert testuser;
        ServiceResource sr = GDMFSL_DataFactory.createServiceResource(testuser.Id, location.Id);
        sr.ResourceType = 'T';
        sr.IsActive = TRUE;
        insert sr;
        System.debug('test user inserted ' + sr);


        GDMFSL_On_Demand_Assignment__c ODA = GDMFSL_DataFactory.createOnDemandAssignment(sr.Id, st.Id);
        insert ODA;
        System.debug('ODA inserted ' + ODA);

        ServiceTerritoryMember StMem = GDMFSL_DataFactory.createServiceTerritoryMember(sr.Id, st.Id);
        insert StMem;
        System.debug('ServiceTerritoryMember inserted ' + ODA);

        GDMFSL_Service_Contract_Resource_Pref__c SCPref = GDMFSL_DataFactory.createServiceContractResourcePref(AC.Id, sr.Id, 'Preferred');
        insert SCPref;

        GDMFSL_Location_Resource_Preference__c LocPref = GDMFSL_DataFactory.createLocationResourcePreference(location.Id, sr.Id, '', WT.Id);
        insert LocPref;
        System.debug('LOcation Pref inserted ' + LocPref);

        Id servReqRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        Id genInqRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_General_Inquiry').getRecordTypeId();
        Case ca = GDMFSL_DataFactory.createCase('APAC',assets[0].Id);
        ca.RecordTypeId = servReqRecTypeId;
        ca.GDMFSL_On_Demand__c = true;
        insert ca;


        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(WT.Id, acc.Id, location.Id, System.now(), System.now());
        wo.GDMFSL_PO_Number__c = '999999';
        wo.ServiceTerritoryId = st.Id;
        wo.AssetId = assets[0].Id;
        wo.CaseId = ca.Id;

        insert wo;

        list<WorkOrder>lstWO = new List<WorkOrder>();
        lstWO.add(wo);

        System.debug('WorkOrder Inserted testassessExistingWOResourcePreferences: ' + wo);
        Test.startTest();
        GDMFSL_ResourcePreferenceProcessor.assessExistingWOResourcePreferences(lstWO);
        Test.stopTest();
        list<ResourcePreference> respref = [Select ID,RelatedRecordId from ResourcePreference where RelatedRecordId = :wo.Id AND ServiceResourceId = :sr.Id];
        System.debug('ResourcePreference list from SOQL' + respref);

        system.assertNotEquals(0,respref.size(), 'No Resource preferences were returned');

    }

    @IsTest
    static void testassessExistingWOResourcePreferences_3() {
        system.debug('inside method testassessExistingWOResourcePreferences()');
        WorkType WT = GDMFSL_DataFactory.createWorkType('WorkTypeTest', 30);
        insert WT;

        list<Product2> products = GDMFSL_DataFactory.createProducts('Prod', 1);
        insert products;

        OperatingHours operatingHours = GDMFSL_DataFactory.createOperatingHour();
        insert operatingHours;
        System.debug('operatingHours Inserted: ' + operatingHours);

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('ST000', operatingHours.Id);
        insert st;
        System.debug('ServiceTerritory Inserted: ' + st);

        Schema.Location location = GDMFSL_DataFactory.createLocation('Campus', st.Id, operatingHours.Id);
        insert location;
        System.debug('location Inserted: ' + location);

        Account acc = GDMFSL_DataFactory.createTestAccount('TestAccount111');
        insert acc;
        System.debug('Account Inserted: ' + acc);

        list<Asset> assets = GDMFSL_DataFactory.createAssets('Asset', products[0].Id, acc.Id, 1);
        insert assets;
        System.debug('assets Inserted testassessExistingWOResourcePreferences: ' + acc);

        ServiceContract sc = GDMFSL_DataFactory.createServiceContract('SCtest', acc.Id);
        sc.GDMFSL_Site_Resident_Labour_Present__c = true;
        insert sc;

        GDMFSL_Associated_Contract__c AC = GDMFSL_DataFactory.createAssociatedContract(location.Id, sc.Id, 23);
        insert AC;
        System.debug('GDMFSL_Associated_Contract__c inserted: ' + AC);

        User testuser = GDMFSL_DataFactory.createTestUser();
        insert testuser;
        ServiceResource sr = GDMFSL_DataFactory.createServiceResource(testuser.Id, location.Id);
        sr.ResourceType = 'T';
        sr.IsActive = TRUE;
        insert sr;
        System.debug('test user inserted ' + sr);

        GDMFSL_Asset_Resource_Preference__c AssetResPref = GDMFSL_DataFactory.createAssetResourcePreference(assets[0].Id, sr.Id, 'Preferred');
        insert AssetResPref;
        System.debug('Asset Resource Preference inserted ' + AssetResPref);


        GDMFSL_On_Demand_Assignment__c ODA = GDMFSL_DataFactory.createOnDemandAssignment(sr.Id, st.Id);
        insert ODA;
        System.debug('ODA inserted ' + ODA);

        ServiceTerritoryMember StMem = GDMFSL_DataFactory.createServiceTerritoryMember(sr.Id, st.Id);
        insert StMem;
        System.debug('ServiceTerritoryMember inserted ' + ODA);

        GDMFSL_Service_Contract_Resource_Pref__c SCPref = GDMFSL_DataFactory.createServiceContractResourcePref(AC.Id, sr.Id, 'Preferred');
        insert SCPref;

        GDMFSL_Location_Resource_Preference__c LocPref = GDMFSL_DataFactory.createLocationResourcePreference(location.Id, sr.Id, '', WT.Id);
        insert LocPref;
        System.debug('LOcation Pref inserted ' + LocPref);


        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(WT.Id, acc.Id, location.Id, System.now(), System.now());
        wo.GDMFSL_PO_Number__c = '999999';
        wo.ServiceTerritoryId = st.Id;
        wo.AssetId = assets[0].Id;
        insert wo;

        list<WorkOrder>lstWO = new List<WorkOrder>();
        lstWO.add(wo);

        System.debug('WorkOrder Inserted testassessExistingWOResourcePreferences: ' + wo);
        Test.startTest();
        GDMFSL_ResourcePreferenceProcessor.assessExistingWOResourcePreferences(lstWO);
        Test.stopTest();
        list<ResourcePreference> respref = [Select ID,RelatedRecordId from ResourcePreference where RelatedRecordId = :wo.Id AND ServiceResourceId = :sr.Id];
        System.debug('ResourcePreference list from SOQL' + respref);

        system.assertNotEquals(0,respref.size(), 'No Resource preferences were returned');

    }

}