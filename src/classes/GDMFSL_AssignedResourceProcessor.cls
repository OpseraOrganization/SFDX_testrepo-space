/**
 * Name       :    GDMFSL_AssignedResourceProcessor
 * Purpose    :    Business Logic for AssignedResources
 * --------------------------------------------------------------------------
 * Developer               Date          Description
 * --------------------------------------------------------------------------
 * Jmay                  2020-Sep-10    Created
 * BDaniels              2021-Feb-22    Added getAssignedResByServiceAppointmentId method
 **/
public without sharing class GDMFSL_AssignedResourceProcessor {

    private static Map<Id, List<AssignedResource>> servResIdToAssignedResources = new Map<Id, List<AssignedResource>>();
    private static Map<Id, List<AssignedResource>> servApptIdToAssignedResources = new Map<Id, List<AssignedResource>>();

    public static Map<Id, List<AssignedResource>> getAssignedResByServiceResourceId(Set<Id> servResIds) {

        Set<Id> newRecIds = new Set<Id>();

        if (servResIds != null && !servResIds.isEmpty()) {

            System.debug('Adding in specified recordIDs');

            if (servResIdToAssignedResources.isEmpty()) {
                newRecIds.addAll(servResIds);
            } else {
                for (Id thisRecId : servResIds) {
                    if (!servResIdToAssignedResources.containsKey(thisRecId)) {
                        newRecIds.add(thisRecId);
                    }
                }
            }
        }

        if (!newRecIds.isEmpty()) {
            getRecordsFromRelatedIds(newRecIds, 'ServiceResourceId');
        }

        System.debug('returning AssignedResources By Service Resource: ' + servResIdToAssignedResources);
        return servResIdToAssignedResources;
    }

    public static Map<Id, List<AssignedResource>> getAssignedResByServiceAppointmentId(Set<Id> servApptIds) {

        Set<Id> newRecIds = new Set<Id>();

        if (servApptIds != null && !servApptIds.isEmpty()) {

            System.debug('Adding in specified recordIDs');

            if (servApptIdToAssignedResources.isEmpty()) {
                newRecIds.addAll(servApptIds);
            } else {
                for (Id thisRecId : servApptIds) {
                    if (!servApptIdToAssignedResources.containsKey(thisRecId)) {
                        newRecIds.add(thisRecId);
                    }
                }
            }
        }

        if (!newRecIds.isEmpty()) {
            getRecordsFromRelatedIds(newRecIds, 'ServiceAppointmentId');
        }

        System.debug('Returning AssignedResources By Service Appointments: ' + servApptIdToAssignedResources);
        return servApptIdToAssignedResources;
    }

    @TestVisible
    private static void getRecordsFromRelatedIds(Set<Id> idsToGet, String whereClauseFieldName) {

        if (whereClauseFieldName != null && !idsToGet.isEmpty()) {

            String theQuery = 'SELECT ServiceAppointmentId, ServiceResourceId ';
            theQuery += ' , ServiceResource.GDMFSL_IsContractor__c ';
            theQuery += ' , ServiceAppointment.GDMFSL_Disable_GeoTracking__c ';
            theQuery += ' FROM AssignedResource ';

            theQuery += ' WHERE ' + whereClauseFieldName + ' IN :idsToGet ';

            System.debug('getRecordsFromRelatedIds query: ' + theQuery);

            for (AssignedResource ar : Database.query(theQuery)) {

                if (!servResIdToAssignedResources.containsKey(ar.ServiceResourceId)) {
                    servResIdToAssignedResources.put(ar.ServiceResourceId, new List<AssignedResource>());
                }

                servResIdToAssignedResources.get(ar.ServiceResourceId).add(ar);

                if (!servApptIdToAssignedResources.containsKey(ar.ServiceAppointmentId)) {
                    servApptIdToAssignedResources.put(ar.ServiceAppointmentId, new List<AssignedResource>());
                }

                servApptIdToAssignedResources.get(ar.ServiceAppointmentId).add(ar);
            }
        }
    }

    public static void createContractorLocationAndAssetShares(List<AssignedResource> newRecs) {

        if (newRecs != null && !newRecs.isEmpty()) {

            Set<Id> serviceAppointmentIdSet = new Set<Id>();
            Set<Id> serviceResourceIdSet = new Set<Id>();

            for (AssignedResource ar : newRecs) {

                serviceResourceIdSet.add(ar.ServiceResourceId);

                if (ar.ServiceAppointmentId != null) {
                    serviceAppointmentIdSet.add(ar.ServiceAppointmentId);
                }
            }

            if (!serviceAppointmentIdSet.isEmpty()) {

                System.debug('Have SAs so we can do work');

                Map<Id, ServiceResource> serviceResourceMap = new Map<Id, ServiceResource>([
                        SELECT Id, RelatedRecordId
                        FROM ServiceResource
                        WHERE Id IN :serviceResourceIdSet
                        AND GDMFSL_IsContractor__c = TRUE
                ]);

                Map<Id, Id> saToLocationIdMap = new Map<Id, Id>();

                for (ServiceAppointment sa : [
                        SELECT Id, ParentRecordType,
                                TYPEOF ParentRecord
                                        WHEN WorkOrder THEN Id, LocationId
                                END
                        FROM ServiceAppointment
                        WHERE ParentRecordType = 'WorkOrder'
                        AND Id IN :serviceAppointmentIdSet
                ]) {

                    if (sa.ParentRecord != null && sa.ParentRecord.isSet('LocationId')) {
                        saToLocationIdMap.put(sa.Id, (Id) sa.ParentRecord.get('LocationId'));
                    }
                }

                Map<Id, List<Id>> locationIdToAssetIdsMap = new Map<Id, List<Id>>();

                for (Asset thisAsset : [SELECT Id, LocationId FROM Asset WHERE LocationId IN :saToLocationIdMap.values()]) {

                    if (!locationIdToAssetIdsMap.containsKey(thisAsset.LocationId)) {
                        locationIdToAssetIdsMap.put(thisAsset.LocationId, new List<Id>());
                    }

                    locationIdToAssetIdsMap.get(thisAsset.LocationId).add(thisAsset.Id);
                }

                addLocationAndAssetShares(saToLocationIdMap, locationIdToAssetIdsMap, serviceResourceMap, newRecs);
            }
        }
    }

    @TestVisible
    private static void addLocationAndAssetShares(Map<Id, Id> saLocationsMap, Map<Id, List<Id>> saLocationAssetsMap, Map<Id, ServiceResource> serviceResourceMap, List<AssignedResource> newRecs) {

        List<LocationShare> locationSharesToCreate = new List<LocationShare>();
        List<AssetShare> assetSharesToCreate = new List<AssetShare>();

        for (AssignedResource ar : newRecs) {

            System.debug('Checking Assigned Resource: ' + ar.Id);

            if (saLocationsMap.containsKey(ar.ServiceAppointmentId) && serviceResourceMap.containsKey(ar.ServiceResourceId)) {

                System.debug('Creating Location Share');

                locationSharesToCreate.add(new LocationShare(
                                AccessLevel = 'Read',
                                ParentId = saLocationsMap.get(ar.ServiceAppointmentId),
                                UserOrGroupId = serviceResourceMap.get(ar.ServiceResourceId).RelatedRecordId));


                if (saLocationAssetsMap.containsKey(saLocationsMap.get(ar.ServiceAppointmentId))) {

                    System.debug('Creating Asset Shares');
                    for (Id assetId : saLocationAssetsMap.get(saLocationsMap.get(ar.ServiceAppointmentId))) {

                        assetSharesToCreate.add(new AssetShare(
                        AssetAccessLevel = 'Read',
                        AssetId = assetId,
                        UserOrGroupId = serviceResourceMap.get(ar.ServiceResourceId).RelatedRecordId));
                    }
                }
            }
        }

        if (!locationSharesToCreate.isEmpty()) {
            GDMFSL_CommonUtilities.insertRecords(locationSharesToCreate, false);
        }

        if (!assetSharesToCreate.isEmpty()) {
            GDMFSL_CommonUtilities.insertRecords(assetSharesToCreate, false);
        }
    }
}