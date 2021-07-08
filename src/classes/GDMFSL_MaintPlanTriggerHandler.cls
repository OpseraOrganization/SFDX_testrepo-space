public without sharing class GDMFSL_MaintPlanTriggerHandler {

    public static void handleOperations(TriggerOperation operation, List<MaintenancePlan> newRecs, Map<Id, MaintenancePlan> oldRecsMap) {

        if (GDMFSL_CommonUtilities.isProcessingDisabled()){
            System.debug('Processing is disabled via Custom Setting');
            return;
        }

        switch on operation {

            when AFTER_UPDATE{
                doAfterUpdateWork(newRecs, oldRecsMap);
            }
        }
    }


    public static void doAfterUpdateWork(List<MaintenancePlan> newRecs, Map<Id, MaintenancePlan> oldRecsMap){

        GDMFSL_MaintenancePlanProcessor.processWOGenerationCompleted(newRecs, oldRecsMap);
    }

}