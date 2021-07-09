/*******************************************************************************************
Name       :    GDMFSL_ResourcePreferenceProcessor
Purpose    :    Business Logic for Resource Preference object . See method descriptions for proper context for calling each method
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
Udbhav                  2020-Sep-09    Created
**********************************************************************************************/

public without sharing class GDMFSL_ResourcePreferenceProcessor {


    public static final String RESPREFREQUIREDVALUE = 'required';

    private static Map<Id, ResourcePreference> resPrefsById = new Map<Id, ResourcePreference>();
    private static Map<Id, ServiceContract> mapServiceContracts = new Map<Id, ServiceContract>();
    private static Map<Id, List<ResourcePreference>> mapParentRecIdToResourcePrefs = new Map<Id, List<ResourcePreference>>();
    private static Map<Id, List<WorkOrderLineItem>> mapWOIdToWOLIS = new Map<Id, List<WorkOrderLineItem>>();
    private static Map<Id, List<GDMFSL_Service_Contract_Resource_Pref__c>> servContIdToResPrefs = new Map<Id, List<GDMFSL_Service_Contract_Resource_Pref__c>>();
    private static Map<Id, GDMFSL_Associated_Contract__c> mapAssociatedContract = new Map<Id, GDMFSL_Associated_Contract__c>();
    private static Map<Id, ServiceTerritory> mapServiceTerritory = new Map<Id, ServiceTerritory>();
    private static Map<Id, Schema.Location> mapLocations = new Map<Id, Schema.Location>();
    private static Map<Id, Asset> mapAssets = new Map<Id, Asset>();
    private static Map<Id, List<GDMFSL_On_Demand_Assignment__c>> mapWOServiceTerritoryOnDemandResource = new Map<Id, List<GDMFSL_On_Demand_Assignment__c>>();

    public static Map<Id, ResourcePreference> getRecords(Set<Id> recIds) {

        if (recIds != null && !recIds.isEmpty()) {

            Set<Id> newRecIds = new Set<Id>();

            if (resPrefsById.isEmpty()) {
                newRecIds.addAll(recIds);
            } else {
                for (Id thisRecId : recIds) {
                    if (!resPrefsById.containsKey(thisRecId)) {
                        newRecIds.add(thisRecId);
                    }
                }
            }

            if (!newRecIds.isEmpty()) {

                Map<Id, ResourcePreference> theRecs = new Map<Id, ResourcePreference>([
                        SELECT Id, PreferenceType, ServiceResourceId, RelatedRecordId
                        FROM ResourcePreference
                        WHERE Id IN :newRecIds

                ]);

                resPrefsById.putAll(theRecs);
                System.debug('Retrieved Resource Preferences: ' + resPrefsById);
            }
        }

        return resPrefsById;
    }


    public static Map<Id, List<ResourcePreference>> getRecordsForParentId(Set<Id> parentRecIds) {


        if (parentRecIds != null && !parentRecIds.isEmpty()) {

            Set<Id> newRecIds = new Set<Id>();

            if (mapParentRecIdToResourcePrefs.isEmpty()) {
                newRecIds.addAll(parentRecIds);
            } else {
                for (Id thisRecId : parentRecIds) {
                    if (!mapParentRecIdToResourcePrefs.containsKey(thisRecId)) {
                        newRecIds.add(thisRecId);
                    }
                }
            }

            if (!newRecIds.isEmpty()) {

                for (ResourcePreference r : [
                        SELECT Id, RelatedRecordId, PreferenceType, ServiceResourceId
                        FROM ResourcePreference
                        WHERE RelatedRecordId IN :parentRecIds
                ]) {

                    if (!mapParentRecIdToResourcePrefs.containsKey(r.RelatedRecordId)) {
                        mapParentRecIdToResourcePrefs.put(r.RelatedRecordId, new List<ResourcePreference>());
                    }

                    mapParentRecIdToResourcePrefs.get(r.RelatedRecordId).add(r);
                }
            }
        }

        return mapParentRecIdToResourcePrefs;
    }


    public static void assessExistingWOResourcePreferences(List<WorkOrder> workOrders) {


        Set<Id> scIdSet = new Set<Id>();
        Set<Id> locIdSet = new Set<Id>();
        Set<Id> woIdSet = new Set<Id>();
        Set<Id> assetIdSet = new Set<Id>();
        Set<Id> serviceTerritoryIds = new Set<Id>();
        List<ResourcePreference> resourcePrefsToDelete = new List<ResourcePreference>();
        List<ResourcePreference> rpListToInsert = new List<ResourcePreference>();

        for (WorkOrder wo : workOrders) {

            if (wo.ServiceContractId != null) {
                scIdSet.add(wo.ServiceContractId);
            }

            if (wo.Id != null) {
                woIdSet.add(wo.Id);
            }

            if (wo.LocationId != null) {
                locIdSet.add(wo.LocationId);
            }

            if (wo.AssetId != null) {
                assetIdSet.add(wo.AssetId);
            }
            if (wo.ServiceTerritoryId != null) {
                serviceTerritoryIds.add(wo.ServiceTerritoryId);
            }
        }

        System.debug('ResourcePreferenceProcessor Service Contract Set: ' + scIdSet.isEmpty());
        System.debug('ResourcePreferenceProcessor Worker Order Id Set: ' + woIdSet.isEmpty());
        System.debug('ResourcePreferenceProcessor Location Set: ' + locIdSet.isEmpty());
        System.debug('ResourcePreferenceProcessor Asset Set: ' + assetIdSet.isEmpty());
        System.debug('ResourcePreferenceProcessor Service Territory Set: ' + serviceTerritoryIds.isEmpty());


        if (!scIdSet.isEmpty()) {
            mapServiceContracts = GDMFSL_ServiceContractProcessor.getRecords(scIdSet);
            System.debug('ResourcePreferenceProcessor Service Contracts Map: ' + mapServiceContracts);

            if (!mapServiceContracts.isEmpty()) {
                servContIdToResPrefs = GDMFSL_ServiceContractProcessor.getServContractResourcePrefRecords(mapServiceContracts.keySet());
                System.debug('ResourcePreferenceProcessor Service Contract Resource Pref Map: ' + servContIdToResPrefs);
            }

            if (!locIdSet.isEmpty()) {
                mapAssociatedContract = GDMFSL_AssociatedContractProcessor.getRecords(scIdSet, locIdSet);
                System.debug('ResourcePreferenceProcessor Associated Contracts Map: ' + mapAssociatedContract);
            }
        }

        if (!woIdSet.isEmpty()) {
            mapParentRecIdToResourcePrefs = getRecordsForParentId(woIdSet);
            System.debug('ResourcePreferenceProcessor Current Resource Preferences Map: ' + mapParentRecIdToResourcePrefs);
            mapWOIdToWOLIS = GDMFSL_WorkOrderLIProcessor.getRecordsByWorkOrderId(woIdSet);
            System.debug('ResourcePreferenceProcessor Current Related WOLI Map: ' + mapWOIdToWOLIS);

        }

        if (!assetIdSet.isEmpty()) {
            mapAssets = GDMFSL_AssetProcessor.getRecords(assetIdSet);
            System.debug('ResourcePreferenceProcessor Asset Map: ' + mapAssets);
        }

        if (!serviceTerritoryIds.isEmpty()) {
            mapServiceTerritory = GDMFSL_ServiceTerritoryProcessor.getRecords(serviceTerritoryIds);
            System.debug('ResourcePreferenceProcessor Service Territory Map: ' + mapServiceTerritory);

            System.debug('Getting GDMFSL_On_Demand_Assignment__c records for ServiceTerritories');
            mapWOServiceTerritoryOnDemandResource = GDMFSL_OnDemandAssignmentProcessor.getRecordsByTerritoryId(mapServiceTerritory.keySet());
        }

        if (!locIdSet.isEmpty()) {
            mapLocations = GDMFSL_LocationProcessor.getRecords(locIdSet);
            System.debug('ResourcePreferenceProcessor Location Map: ' + mapLocations);
        }


        for (WorkOrder wo : workOrders) {

            Set<Id> serviceResourceIds = new Set<Id>();
            System.debug('Looking at WO: ' + wo.Id);

            if (mapParentRecIdToResourcePrefs.containsKey(wo.Id)) {
                System.debug('Deleting existing Resource Prefs');
                resourcePrefsToDelete.addAll(mapParentRecIdToResourcePrefs.get(wo.Id));
            }

            System.debug('Checking the On Demand flag');

            if (wo.ServiceTerritoryId != null && wo.GDMFSL_On_Demand__c && mapServiceTerritory.containsKey(wo.ServiceTerritoryId)) {

                System.debug('Is On Demand Resource');

                if (mapWOServiceTerritoryOnDemandResource.containsKey(wo.ServiceTerritoryId)) {

                    System.debug('Has OnDemandResources');

                    for (GDMFSL_On_Demand_Assignment__c thisonDemandAssign : mapWOServiceTerritoryOnDemandResource.get(wo.ServiceTerritoryId)) {
                        System.Debug('On Demand Assignments By Teriiroty: ' + thisonDemandAssign);

                        if (thisonDemandAssign.GDMFSL_Start_Date_Time__c <= wo.StartDate && thisonDemandAssign.GDMFSL_End_Date_Time__c >= wo.EndDate) {

                            System.debug('Creating ResourcePref');
                            if(!serviceResourceIds.contains(thisonDemandAssign.GDMFSL_Service_Resource__c)) {
                                serviceResourceIds.add(thisonDemandAssign.GDMFSL_Service_Resource__c);
                                rpListToInsert.add(new ResourcePreference(PreferenceType = RESPREFREQUIREDVALUE,
                                        RelatedRecordId = wo.Id, ServiceResourceId = thisonDemandAssign.GDMFSL_Service_Resource__c));
                            }
                        }
                    }
                }
            } else {

                System.debug('Is Not On Demand Resource');

                System.debug('Check Service Contract');

                if (wo.ServiceContractId != null
                        && mapServiceContracts.containsKey(wo.ServiceContractId)
                        && mapServiceContracts.get(wo.ServiceContractId).GDMFSL_Site_Resident_Labour_Present__c
                        && servContIdToResPrefs.containsKey(wo.ServiceContractId)
                        && !mapAssociatedContract.isEmpty()) {

                    System.debug('Service Contract Present & Site Resident Labour Present & WO Location associated with SC');
                    System.debug('Service Contract Resource Preference: ' + servContIdToResPrefs.values());

                    for (GDMFSL_Associated_Contract__c ac : mapAssociatedContract.values()) {

                        if (ac.Location__c == wo.LocationId && ac.Service_Contract__c == wo.ServiceContractId) {

                            for (GDMFSL_Service_Contract_Resource_Pref__c serviceContractPref : ac.GDMFSL_Service_Contract_Resource_Pref__r) {

                                if (serviceContractPref.GDMFSL_Preference_Type__c == null) {
                                    serviceContractPref.GDMFSL_Preference_Type__c = RESPREFREQUIREDVALUE;
                                }
                                if(!serviceResourceIds.contains(serviceContractPref.GDMFSL_Service_Resource__c)) {
                                    serviceResourceIds.add(serviceContractPref.GDMFSL_Service_Resource__c);
                                    rpListToInsert.add(new ResourcePreference(PreferenceType = serviceContractPref.GDMFSL_Preference_Type__c,
                                            RelatedRecordId = wo.Id, ServiceResourceId = serviceContractPref.GDMFSL_Service_Resource__c));
                                }
                            }
                        }
                    }

                } else if (mapWOIdToWOLIS.containsKey(wo.Id) && !mapWOIdToWOLIS.isEmpty()) {

                    System.debug('WO has WOLIs');

                    System.debug('Checking the Asset');

                    Boolean foundAssetPrefs = false;

                    if (wo.AssetId != null && mapAssets.containsKey(wo.AssetId)) {

                        System.debug('WO has AssetId: ' + wo.AssetId);
                        if (mapAssets.get(wo.AssetId).Asset_Resource_Preferences__r != null &&
                                mapAssets.get(wo.AssetId).Asset_Resource_Preferences__r.size() > 0) {

                            System.debug('Adding Asset_Resource_Prefs');
                            foundAssetPrefs = true;

                            for (GDMFSL_Asset_Resource_Preference__c assetPref : mapAssets.get(wo.AssetId).Asset_Resource_Preferences__r) {

                                if (assetPref.GDMFSL_Preference_Type__c == null) {
                                    assetPref.GDMFSL_Preference_Type__c = RESPREFREQUIREDVALUE;
                                }
                                if(!serviceResourceIds.contains(assetPref.GDMFSL_Service_Resource__c)) {
                                    serviceResourceIds.add(assetPref.GDMFSL_Service_Resource__c);
                                    rpListToInsert.add(new ResourcePreference(PreferenceType = assetPref.GDMFSL_Preference_Type__c,
                                            RelatedRecordId = wo.Id, ServiceResourceId = assetPref.GDMFSL_Service_Resource__c));
                                }
                            }
                        }
                    }

                    System.debug('Did we find Asset Resource Prefs: ' + foundAssetPrefs);

                    if (!foundAssetPrefs
                            && wo.LocationId != null && mapLocations.containsKey(wo.LocationId)) {

                        System.debug('WO has LocationId: ' + wo.LocationId);

                        if (mapLocations.get(wo.LocationId).Location_Resource_Preferences__r != null) {

                            System.debug('Adding Location_Resource_Prefs');

                            for (GDMFSL_Location_Resource_Preference__c locationPref : mapLocations.get(wo.LocationId).Location_Resource_Preferences__r) {

                                if (locationPref.GDMFSL_Preference_Type__c == null) {
                                    locationPref.GDMFSL_Preference_Type__c = RESPREFREQUIREDVALUE;
                                }
                                if(!serviceResourceIds.contains(locationPref.GDMFSL_Service_Resource__c)) {
                                    serviceResourceIds.add(locationPref.GDMFSL_Service_Resource__c);
                                    rpListToInsert.add(new ResourcePreference(PreferenceType = locationPref.GDMFSL_Preference_Type__c,
                                            RelatedRecordId = wo.Id, ServiceResourceId = locationPref.GDMFSL_Service_Resource__c));
                                }
                            }
                        }
                    }
                }
            }
        }

        System.debug('ResourcePrefs to be deleted: ' + resourcePrefsToDelete);

        if (resourcePrefsToDelete.size() > 0) {
            GDMFSL_CommonUtilities.deleteRecords(resourcePrefsToDelete);
            System.debug('Clearing the Map so that on Update it is fetched again the records and which are deleted are no more in the map');
            mapParentRecIdToResourcePrefs.clear();

        }

        System.debug('ResourcePrefs to be inserted: ' + rpListToInsert);

        if (!rpListToInsert.isEmpty()) {
            GDMFSL_CommonUtilities.insertRecords(rpListToInsert);
        }
    }


}