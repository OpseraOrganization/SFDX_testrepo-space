/*******************************************************************************************
Name       :    GDMFSL_ServiceAppointmentTriggerHandler
Purpose    :    Handler for Service Appointment object trigger. See method descriptions for proper context for calling each method
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
Udbhav                  2020-Aug-31    Created
**********************************************************************************************/

public without sharing class GDMFSL_ServiceAppointmentTriggerHandler {

    /*************************************************************
  * @Description  Handler method for Trigger on ServiceAppointment Object
  * ***********************************************************/
    public static void handleOperations(TriggerOperation operation, List<ServiceAppointment> newRecs, Map<Id, ServiceAppointment> oldRecsMap) {

        if (GDMFSL_CommonUtilities.isProcessingDisabled()) {
            System.debug('Processing is disabled via Custom Setting');
            return;
        }

        switch on operation {

            when BEFORE_INSERT {
                doBeforeInsertWork(newRecs);
            }

            when AFTER_INSERT {
                doAfterInsertWork(newRecs);
            }

            when AFTER_UPDATE {
                doAfterUpdateWork(newRecs, oldRecsMap);
            }
        }
    }


    /*************************************************************
* @Description  Method to have business logic to be done before Insert Operation on ServiceAppointments
* @param lstSA List of New ServiceAppointments Inserted
* ***********************************************************/
    private static void doBeforeInsertWork(List<ServiceAppointment> lstSA) {
        System.debug('SA Before Insert');
        List<ServiceAppointment> sasToUpdate = new List<ServiceAppointment>();

        for (ServiceAppointment sa : lstSA) {
            if (!sa.GDMFSL_IsFollowUp__c) {
                sasToUpdate.add(sa);
            }
        }

        if (!sasToUpdate.isEmpty()) {
            GDMFSL_ServiceAppointmentProcessor.setSAFieldsFromWO(sasToUpdate);
        }

    }

    /*************************************************************
* @Description  Method to have business logic to be done after Update Operation on ServiceAppointments
* @param theSAs List of New ServiceAppointments Inserted
* ***********************************************************/
    private static void doAfterUpdateWork(List<ServiceAppointment> theSAs, Map<Id, ServiceAppointment> oldRecsMap) {

        if (!GDMFSL_CommonUtilities.isFlagSet('afterUpdateSADone')) {

            List<ServiceAppointment> onlystatusUpdate = new List<ServiceAppointment>();

            for (ServiceAppointment sa : theSAs) {
                if (sa.Status != oldRecsMap.get(sa.Id).Status) {
                    onlystatusUpdate.add(sa);
                }
            }

            if (!onlystatusUpdate.isEmpty()) {
                GDMFSL_CommonUtilities.setFlag('afterUpdateSADone');
                GDMFSL_ServiceAppointmentProcessor.processCompletedSAs(onlystatusUpdate);
            }

            GDMFSL_ServiceAppointmentProcessor.updateRelatedWorkOrderStatus(theSAs, oldRecsMap);


        }

    }


    @TestVisible
    private static void doAfterInsertWork(List<ServiceAppointment> newRecs) {
        GDMFSL_ServiceAppointmentProcessor.deleteSAsIfNeeded(newRecs);


    }


}