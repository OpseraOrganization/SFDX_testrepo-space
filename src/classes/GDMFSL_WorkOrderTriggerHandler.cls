/*******************************************************************************************
Name       :    GDMFSL_WorkOrderTriggerHandler
Purpose    :    Handler for WorkOrder object trigger. See method descriptions for proper context for calling each method
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
Udbhav                  2020-Aug-31    Created
**********************************************************************************************/

public without sharing class GDMFSL_WorkOrderTriggerHandler {

    public static Set<String> NOCODEEXECUTIONFORLISTEDFIELDS = new Set<String>{
            'Status',
            'StatusCategory'
    };
    /**
     * Handler method for Trigger on WorkOrder Object
     *
     * @param operation
     * @param newWorkOrders
     * @param oldWorkOrderMap
     **/
    public static void handleOperations(TriggerOperation operation, List<WorkOrder> newWorkOrders, Map<Id, WorkOrder> oldWorkOrderMap) {

        if (GDMFSL_CommonUtilities.isProcessingDisabled()) {
            System.debug('Processing is disabled via Custom Setting');
            return;
        }

        switch on operation {

            when BEFORE_INSERT {
                doBeforeInsertWork(newWorkOrders);
            }

            when AFTER_INSERT {
                doAfterInsertWork(newWorkOrders);
            }

            when BEFORE_UPDATE {

                doBeforeUpdateWork(newWorkOrders, oldWorkOrderMap);

            }

            when AFTER_UPDATE {

                doAfterUpdateWork(newWorkOrders, oldWorkOrderMap);

            }
        }
    }

    /**
     * Method to have business logic to be done before Insert Operation on WorkOrder
     *
     * @param lstworkOrders List of New WorkOrders Inserted
     **/
    @TestVisible
    private static void doBeforeInsertWork(List<WorkOrder> lstworkOrders) {
        System.debug('WO beforeInsert');
        GDMFSL_CommonUtilities.setFlag('beforeInsertWODone');
        GDMFSL_WorkOrderProcessor.setWOFields(lstworkOrders, null);
        GDMFSL_WorkOrderProcessor.clearWOFields(lstworkOrders, null);


    }

    /**
     * Method to have business logic to be done before Insert Operation on WorkOrder
     *
     * @param lstworkOrders List of New WorkOrders Inserted
     **/
    @TestVisible
    private static void doAfterInsertWork(List<WorkOrder> lstworkOrders) {

        System.debug('WO afterInsert');
        GDMFSL_CommonUtilities.setFlag('afterInsertWODone');
        GDMFSL_WorkOrderLIProcessor.createWOLIForWOs(lstworkOrders, null);
        GDMFSL_WorkOrderProcessor.createWorkOrderResourcePreference(lstworkOrders, null);
        GDMFSL_WorkOrderProcessor.copyFilesFromCaseToWO(lstworkOrders);

    }

    /**
     * Method to have business logic to be done before Update Operation on WorkOrder
     *
     * @param newWorkOrders List of New WorkOrders Update
     * @param oldWorkOrdersMap Map of WorkOrder with its value before Update
     **/
    @TestVisible
    private static void doBeforeUpdateWork(List<WorkOrder> newWorkOrders, Map<Id, WorkOrder> oldWorkOrdersMap) {

        if (!GDMFSL_CommonUtilities.isFlagSet('beforeUpdateWODone')) {
            List<WorkOrder> validWorkOrders = new List<WorkOrder>();
            System.debug('WO beforeUpdate');
            GDMFSL_CommonUtilities.setFlag('beforeUpdateWODone');
            if (!GDMFSL_CommonUtilities.isFlagSet('beforeInsertWODone')) {
                GDMFSL_WorkOrderProcessor.setWOFields(newWorkOrders, oldWorkOrdersMap);
                GDMFSL_WorkOrderProcessor.clearWOFields(newWorkOrders, oldWorkOrdersMap);
                GDMFSL_WorkOrderProcessor.rollUpTimeOnWOFromSA(newWorkOrders, oldWorkOrdersMap);
                GDMFSL_WorkOrderProcessor.setStatusforIntegration(newWorkOrders, oldWorkOrdersMap);


            }
        }

    }

    @TestVisible
    private static void doAfterUpdateWork(List<WorkOrder> newWorkOrders, Map<Id, WorkOrder> oldWorkOrdersMap) {
        System.debug('doAfterUpdateWork()');

        if (!GDMFSL_CommonUtilities.isFlagSet('afterUpdateWODone')) {
            GDMFSL_CommonUtilities.setFlag('afterUpdateWODone');
            GDMFSL_WorkOrderLIProcessor.createWOLIForWOs(newWorkOrders, oldWorkOrdersMap);
            GDMFSL_WorkOrderProcessor.updateRelatedServiceAppointment(newWorkOrders, oldWorkOrdersMap);
            GDMFSL_WorkOrderProcessor.updateParentCaseStatus(newWorkOrders);
            GDMFSL_ServiceReportProcessor.sendSiteContactEmailCompletedWOs(newWorkOrders, oldWorkOrdersMap);

        }
        GDMFSL_WorkOrderProcessor.createWorkOrderResourcePreference(newWorkOrders, oldWorkOrdersMap);

    }
}