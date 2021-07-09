/*******************************************************************************************
Name       :    GDMFSL_AssetTriggerHandler
Purpose    :    Handler for Asset object trigger. See method descriptions for proper context for calling each method
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
Masood                  2020-Aug-06    Created
**********************************************************************************************/

public without sharing class GDMFSL_AssetTriggerHandler {

    /**
     * method called from Asset trigger
     *
     * @param operation
     * @param newAssets
     * @param oldAssetsMap
     **/
    public static void handleOperations(TriggerOperation operation, List<Asset> newAssets, Map<Id, Asset> oldAssetsMap) {

        if (GDMFSL_CommonUtilities.isProcessingDisabled()) {
            System.debug('Processing is disabled via Custom Setting');
            return;
        }

        switch on operation {

            when AFTER_DELETE {
                GDMFSL_AssetMaintenance.deleteMaintenanceDataForAssets(oldAssetsMap.keySet());
            }

            when AFTER_INSERT {
                GDMFSL_AssetMaintenance.createAssetMaints(newAssets);
            }

            when AFTER_UPDATE {
                doAfterUpdateWork(newAssets, oldAssetsMap);
            }
            when BEFORE_INSERT {
                doBeforeInsertWork(newAssets);
            }
            when BEFORE_UPDATE {
                doBeforeUpdateWork(newAssets, oldAssetsMap);
            }
        }
    }

    @TestVisible
    private static void doBeforeInsertWork(List<Asset> newAssets) {
        if(!GDMFSL_CommonUtilities.isFlagSet('doBeforeInsertWork')) {
            GDMFSL_CommonUtilities.setFlag('doBeforeInsertWork');
            GDMFSL_AssetProcessor.setAssetFields(newAssets);
            
        }
    }

    @TestVisible
    private static void doAfterUpdateWork(List<Asset> newAssets, Map<Id, Asset> oldAssetsMap) {
        Map<Id, Asset> assetsWithDiffProd = new Map<Id, Asset>();
    
        for (Asset newAsset : newAssets) {
            if (newAsset.Product2Id != oldAssetsMap.get(newAsset.Id).Product2Id) {
                System.debug('Asset ProductID changed: ' + newAsset.Id);
                assetsWithDiffProd.put(newAsset.Id, newAsset);
            }
           
        }
        if (assetsWithDiffProd.size() > 0) {
            GDMFSL_AssetMaintenance.deleteMaintenanceDataForAssets(assetsWithDiffProd.keySet());
            GDMFSL_AssetMaintenance.createAssetMaints(assetsWithDiffProd.values());
        }

       
    }

    @TestVisible
    private static void doBeforeUpdateWork(List<Asset> newAssets, Map<Id, Asset> oldAssetsMap) {
        Map<Id, Asset> assetsWithDiffLocation = new Map<Id, Asset>();
        for (Asset newAsset : newAssets) {
            if (newAsset.LocationId != oldAssetsMap.get(newAsset.Id).LocationId) {
                System.debug('Asset Location changed: ' + newAsset.Id);
                assetsWithDiffLocation.put(newAsset.Id, newAsset);
            }
        }
        if(assetsWithDiffLocation.size() > 0){
            if(!GDMFSL_CommonUtilities.isFlagSet('doBeforeUpdateWork')) {
                GDMFSL_CommonUtilities.setFlag('doBeforeUpdateWork');
                GDMFSL_AssetProcessor.setAssetFields(assetsWithDiffLocation.values());
                
            }
        }
        
    }

}