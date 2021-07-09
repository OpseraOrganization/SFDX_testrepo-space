public without sharing class GDMFSL_AssignedResourceTriggerHandler {

    public static void handleOperations(TriggerOperation operation, List<AssignedResource> newRecs, Map<Id, AssignedResource> oldMap) {

        if (GDMFSL_CommonUtilities.isProcessingDisabled()) {
            System.debug('Processing is disabled via Custom Setting');
            return;
        }

        switch on operation {
            when AFTER_INSERT {
                System.debug('After Update');
                doAfterInsertWork(newRecs);
            }
        }
    }


    @TestVisible
    private static void doAfterInsertWork(List<AssignedResource> newRecs){
        GDMFSL_AssignedResourceProcessor.createContractorLocationAndAssetShares(newRecs);
    }    
}