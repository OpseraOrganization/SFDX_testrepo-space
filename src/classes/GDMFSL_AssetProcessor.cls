/*******************************************************************************************
Name       :    GDMFSL_AssetProcessor
Purpose    :    Processor Logic for Asset object . See method descriptions for proper context for calling each method
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
Udbhav                  2020-Sep-07    Created
**********************************************************************************************/

public without sharing class GDMFSL_AssetProcessor {

    private static Map<Id, Asset> retVals = new Map<Id, Asset>();

    public static Map<Id, Asset> getRecords(Set<Id> assetIds) {

        System.debug('Inside GDMFSL_AssetProcessor:getRecords');

        if (assetIds != null && !assetIds.isEmpty()) {

            Set<Id> newRecIds = new Set<Id>();

            if (retVals.isEmpty()) {
                newRecIds.addAll(assetIds);
            } else {
                for (Id assetId : assetIds) {
                    if (!retVals.containsKey(assetId)) {
                        newRecIds.add(assetId);
                    }
                }
            }

            if (!newRecIds.isEmpty()) {
                Map<Id, Asset> newAssetMap = new Map<Id, Asset>([
                        SELECT Id,
                                LocationId,
                                Product2Id, (
                                SELECT Id,
                                        GDMFSL_Preference_Type__c,
                                        GDMFSL_Service_Resource__c
                                FROM Asset_Resource_Preferences__r
                                WHERE GDMFSL_Service_Resource__r.IsActive = TRUE
                                AND GDMFSL_Service_Resource__r.ResourceType != 'D'
                        )
                        FROM Asset
                        WHERE
                                Id IN :newRecIds
                ]);
                retVals.putAll(newAssetMap);
                System.debug('Retrieved Assets : ' + retVals);
            }
        }

        return retVals;
    }

    public static Set<Id> getAssetProductIds(List<Asset> newAssets) {

        Set<Id> productIds = new Set<Id>();

        if (newAssets != null && !newAssets.isEmpty()) {
            for (Asset asset : newAssets) {
                if (asset.Product2Id != null) {
                    productIds.add(asset.Product2Id);
                }
            }
        }

        return productIds;
    }

    private static Map<Id, Schema.Location> mapLocations = new Map<Id, Schema.Location>();

    public static void setAssetFields(List<Asset> lstAssets) {

        if (lstAssets != null && !lstAssets.isEmpty()) {

            Set<Id> locationIds = new Set<Id>();

            for(Asset ast : lstAssets){
                if(ast.LocationId != null){
                    locationIds.add(ast.LocationId);
                    ast.GDMFSL_Location_is_Classified__c = false;
                }
            }

            mapLocations = GDMFSL_LocationProcessor.getRecords(locationIds);

            for(Asset ast : lstAssets){
                if (ast.LocationId != null && mapLocations.containsKey(ast.LocationId)) {
                    ast.GDMFSL_Location_is_Classified__c = mapLocations.get(ast.LocationId).GDMFSL_Is_Classified__c;
                    ast.GDMFSL_Region__c = mapLocations.get(ast.LocationId).GDMFSL_Region__c;
                }
            }
        }
    }



}