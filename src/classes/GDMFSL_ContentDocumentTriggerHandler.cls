public without sharing class GDMFSL_ContentDocumentTriggerHandler {

    public static void handleOperations(TriggerOperation operation, List<ContentDocument> newRecs, Map<Id, ContentDocument> oldMap) {

        if (GDMFSL_CommonUtilities.isProcessingDisabled()) {
            System.debug('Processing is disabled via Custom Setting');
            return;
        }

        switch on operation {

            when AFTER_UPDATE {

                doAfterUpdateWork(newRecs);
            }
        }
    }

    @TestVisible
    private static void doAfterUpdateWork(List<ContentDocument> newRecs) {
        System.debug('After Update of Content Document');
        if (!GDMFSL_CommonUtilities.isFlagSet('afterUpdateOfContentDocument')) {
            GDMFSL_CommonUtilities.setFlag('afterUpdateOfContentDocument');
            GDMFSL_ContentDocumentProcessor.connectContentDocumentToAsset(newRecs);

        }
    }

}