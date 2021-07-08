/**
 * Name       :    GDMFSL_Maintenance
 * Purpose    :    Wrapper class to encapsulate Maintenance requirements data
 * --------------------------------------------------------------------------
 * Developer               Date          Description
 * --------------------------------------------------------------------------
 * JMay                  2020-Sep-23    Created
 **/
public without sharing class GDMFSL_AssetMaintenance {

    public Id theAssetId;
    public Id theWorkTypeId;
    public Decimal durationInMinutes;
    public Decimal frequency;
    public String frequencyType;
    public String recurrenceType;
    public String rRuleTemplate;
    public Id recordId;
    public Decimal sortOrder;
    public String name;

    public GDMFSL_AssetMaintenance() {
    }

    public static void createAssetMaints(List<Asset> theAssets) {

        Map<Id, List<GDMFSL_AssetMaintenance>> assetMaintByAssetId = populateAssetMaintFromTemplates(theAssets, GDMFSL_MaintenanceTemplate.getMaintenanceTemplateForProducts(GDMFSL_AssetProcessor.getAssetProductIds(theAssets)));

        List<GDMFSL_AssetMaintenance> recsToSave = new List<GDMFSL_AssetMaintenance>();

        for (List<GDMFSL_AssetMaintenance> recs : assetMaintByAssetId.values()) {
            recsToSave.addAll(recs);
        }

        if (!recsToSave.isEmpty()) {
            saveAssetMaintenanceToSF(recsToSave);
        }
    }

    public static Map<Id, List<GDMFSL_Asset_Maintenance_Frequency__c>> getAssetMaintFrequencyRecords(Set<Id> theAssetIds){

        Map<Id, List<GDMFSL_Asset_Maintenance_Frequency__c>> assetIdsToAssetMaintFreq = new Map<Id, List<GDMFSL_Asset_Maintenance_Frequency__c>>();

        if (theAssetIds != null && !theAssetIds.isEmpty()){

            for (GDMFSL_Asset_Maintenance_Frequency__c afm : [SELECT Id,
                    CurrencyIsoCode,
                    GDMFSL_April__c,
                    GDMFSL_Asset__c,
                    GDMFSL_Asset__r.Name,
                    GDMFSL_August__c,
                    GDMFSL_Date_of_First_Work_Order__c,
                    GDMFSL_December__c,
                    GDMFSL_Duration_minutes__c,
                    GDMFSL_February__c,
                    GDMFSL_Frequency_Every_N__c,
                    GDMFSL_Frequency_Type__c,
                    GDMFSL_January__c,
                    GDMFSL_July__c,
                    GDMFSL_June__c,
                    GDMFSL_March__c,
                    GDMFSL_May__c,
                    GDMFSL_November__c,
                    GDMFSL_October__c,
                    GDMFSL_Recurrence_Type__c,
                    GDMFSL_RRULE_Template__c,
                    GDMFSL_September__c,
                    GDMFSL_Sort_Order__c,
                    GDMFSL_Work_Type__c,
                    Name
            FROM GDMFSL_Asset_Maintenance_Frequency__c
            WHERE GDMFSL_Asset__c IN :theAssetIds]){

                if (!assetIdsToAssetMaintFreq.containsKey(afm.GDMFSL_Asset__c)){
                    assetIdsToAssetMaintFreq.put(afm.GDMFSL_Asset__c, new List<GDMFSL_Asset_Maintenance_Frequency__c>());
                }

                assetIdsToAssetMaintFreq.get(afm.GDMFSL_Asset__c).add(afm);
            }
        }

        System.debug('Found this many AssetMaintFreqs: ' + assetIdsToAssetMaintFreq.size());

        return assetIdsToAssetMaintFreq;
    }

    public static void deleteMaintenanceDataForAssets(Set<Id> theAssetIds) {

        System.debug('deleteMaintenanceDataForAssets() deleting for asset IDs: ' + theAssetIds);

        if (theAssetIds != null && !theAssetIds.isEmpty()) {

            List<GDMFSL_Asset_Maintenance_Frequency__c> recsToDelete = new List<GDMFSL_Asset_Maintenance_Frequency__c>([
                    SELECT Id
                    FROM GDMFSL_Asset_Maintenance_Frequency__c
                    WHERE GDMFSL_Asset__c IN :theAssetIds
            ]);


            System.debug('this many Asset Maintenance records to delete: ' + recsToDelete.size());

            if (recsToDelete.size() > 0) {
                GDMFSL_CommonUtilities.deleteRecords(recsToDelete);
            }
        }
    }

    @TestVisible
    private static void saveAssetMaintenanceToSF(List<GDMFSL_AssetMaintenance> aMaintToSave) {

        if (aMaintToSave != null && !aMaintToSave.isEmpty()) {

            List<GDMFSL_Asset_Maintenance_Frequency__c> amfs = new List<GDMFSL_Asset_Maintenance_Frequency__c>();

            for (GDMFSL_AssetMaintenance r : aMaintToSave) {
                amfs.add(mapAssetMaintTosObject(r));
            }

            if (!amfs.isEmpty()) {
                GDMFSL_CommonUtilities.upsertRecords(amfs);
            }
        }
    }

    @TestVisible
    private static Map<Id, List<GDMFSL_AssetMaintenance>> populateAssetMaintFromTemplates(List<Asset> assets,
            Map<Id, List<GDMFSL_MaintenanceTemplate>> productIdToMaintenanceTemplates) {

        Map<Id, List<GDMFSL_AssetMaintenance>> assetMaints = new Map<Id, List<GDMFSL_AssetMaintenance>>();

        if (assets != null && !assets.isEmpty()) {

            for (Asset theAsset : assets) {

                if (theAsset.Product2Id != null && productIdToMaintenanceTemplates.containsKey(theAsset.Product2Id)) {

                    if (!assetMaints.containsKey(theAsset.Id)) {
                        assetMaints.put(theAsset.Id, new List<GDMFSL_AssetMaintenance>());
                    }

                    for (GDMFSL_MaintenanceTemplate maintenanceTemplate : productIdToMaintenanceTemplates.get(theAsset.Product2Id)) {

                        GDMFSL_AssetMaintenance thisMaint = new GDMFSL_AssetMaintenance();
                        thisMaint.theAssetId = theAsset.Id;
                        thisMaint.theWorkTypeId = maintenanceTemplate.theWorkTypeId;
                        thisMaint.recurrenceType = maintenanceTemplate.recurrenceType;
                        thisMaint.frequencyType = maintenanceTemplate.frequencyType;
                        thisMaint.frequency = maintenanceTemplate.frequency;
                        thisMaint.durationInMinutes = maintenanceTemplate.durationInMinutes;
                        thisMaint.sortOrder = maintenanceTemplate.sortOrder;
                        thisMaint.name = maintenanceTemplate.name;

                        assetMaints.get(theAsset.Id).add(thisMaint);
                    }
                }
            }
        }

        return assetMaints;
    }

    @TestVisible
    private static GDMFSL_Asset_Maintenance_Frequency__c mapAssetMaintTosObject(GDMFSL_AssetMaintenance theSource) {

        GDMFSL_Asset_Maintenance_Frequency__c theResult = new GDMFSL_Asset_Maintenance_Frequency__c();
        theResult.Id = theSource.recordId;
        theResult.GDMFSL_Asset__c = theSource.theAssetId;
        theResult.GDMFSL_Work_Type__c = theSource.theWorkTypeId;
        theResult.GDMFSL_Duration_minutes__c = theSource.durationInMinutes;
        theResult.GDMFSL_Frequency_Every_N__c = theSource.frequency;
        theResult.GDMFSL_Frequency_Type__c = theSource.frequencyType;
        theResult.GDMFSL_Recurrence_Type__c = theSource.recurrenceType;
        theResult.GDMFSL_Sort_Order__c = theSource.sortOrder;
        theResult.Name = theSource.name;

        return theResult;
    }

}