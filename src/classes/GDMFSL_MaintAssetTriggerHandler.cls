public without sharing class GDMFSL_MaintAssetTriggerHandler {

    public static void handleOperations(TriggerOperation operation, List<MaintenanceAsset> newRecs, Map<Id, MaintenanceAsset> oldRecsMap) {

        if (GDMFSL_CommonUtilities.isProcessingDisabled()){
            System.debug('Processing is disabled via Custom Setting');
            return;
        }

        switch on operation {

            when AFTER_INSERT{
                doAfterInsertWork(newRecs);
            }
        }
    }


    public static void doAfterInsertWork(List<MaintenanceAsset> newRecs){

        GDMFSL_MaintenancePlanProcessor.createMaintenanceWorkRules(newRecs);

    }

}