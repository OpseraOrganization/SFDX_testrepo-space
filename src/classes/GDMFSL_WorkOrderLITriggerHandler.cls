/**
 * Name       :    GDMFSL_WorkOrderLITriggerHandler
 * Purpose    :    Trigger handler for WorkOrderLineItem object.
 * --------------------------------------------------------------------------
 * Developer               Date          Description
 * --------------------------------------------------------------------------
 * JMay                  2020-Sep-25    Created
 **/
public without sharing class GDMFSL_WorkOrderLITriggerHandler {

    public static void handleOperations(TriggerOperation operation, List<WorkOrderLineItem> newRecs, Map<Id, WorkOrderLineItem> oldRecMap) {

        if (GDMFSL_CommonUtilities.isProcessingDisabled()) {
            System.debug('Processing is disabled via Custom Setting');
            return;
        }

        switch on operation {

            when BEFORE_INSERT {
                doBeforeInsertWork(newRecs);
            }
            when AFTER_INSERT
            {
                doAfterInsertWork(newRecs);
            }
            when AFTER_UPDATE
            {
                doAfterUpdateWork(oldRecMap,newRecs);
            }
        }
    }

    @TestVisible
    private static void doBeforeInsertWork(List<WorkOrderLineItem> lstWOLI) {
        System.debug('Inside WOLI doBeforeInsert: ' + lstWOLI);
        GDMFSL_WorkOrderLIProcessor.setFields(lstWOLI);

    }

    @TestVisible
    private static void doAfterInsertWork(List<WorkOrderLineItem> lstWOLI) {

        if(!GDMFSL_CommonUtilities.isFlagSet('AfterInsert')) {

            GDMFSL_CommonUtilities.setFlag('AfterInsert');
            System.debug('Inside WOLI doAfterInsert: ' + lstWOLI);
            GDMFSL_WorkOrderLIProcessor.setWOVisitingHoursFromWOLIs(lstWOLI);
            GDMFSL_WorkOrderLIProcessor.createAssetComponentSummaryForWOLI(lstWOLI, null);
            GDMFSL_WorkOrderLIProcessor.deriveWorkPlansAndStepsOnWOLI(lstWOLI,null);
        }
    }

    @TestVisible
    private static void doAfterUpdateWork(Map<Id, WorkOrderLineItem> oldMapIdToWOLI,List<WorkOrderLineItem> lstWOLI) {

        if (!GDMFSL_CommonUtilities.isFlagSet('AfterUpdate')) {

            GDMFSL_CommonUtilities.setFlag('AfterUpdate');
            System.debug('Inside WOLI doAfterUpdateWork: ' + lstWOLI);

            if (!GDMFSL_CommonUtilities.isFlagSet('AfterInsert')) {
                GDMFSL_WorkOrderLIProcessor.createAssetComponentSummaryForWOLI(lstWOLI, oldMapIdToWOLI);
                GDMFSL_WorkOrderLIProcessor.deriveWorkPlansAndStepsOnWOLI(lstWOLI, oldMapIdToWOLI);
            }
        }
    }

}