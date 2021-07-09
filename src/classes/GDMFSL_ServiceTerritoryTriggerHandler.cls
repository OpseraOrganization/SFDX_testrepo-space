public without sharing class GDMFSL_ServiceTerritoryTriggerHandler {


    public static void handleOperations(TriggerOperation operation, List<ServiceTerritory> newRecs, Map<Id, ServiceTerritory> oldMap) {

        if (GDMFSL_CommonUtilities.isProcessingDisabled()) {
            System.debug('Processing is disabled via Custom Setting');
            return;
        }

        switch on operation {

            when AFTER_UPDATE {
                System.debug('After Update');
                doAfterUpdateWork(newRecs, oldMap);
            }
        }
    }

    @TestVisible
    private static void doAfterUpdateWork(List<ServiceTerritory> newRecs, Map<Id, ServiceTerritory> oldMap){

        System.debug('About to call processHolidays');
        GDMFSL_ServiceTerritoryProcessor.updateRelatedServResources(newRecs, oldMap);
    }

}