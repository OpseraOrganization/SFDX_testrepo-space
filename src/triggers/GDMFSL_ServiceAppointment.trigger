/**
 * Name       :    GDMFSL_ServiceAppointment
 * Purpose    :    Trigger for Service Appointment object . See method descriptions for proper context for calling each method
 * --------------------------------------------------------------------------
 * Developer               Date          Description
 * --------------------------------------------------------------------------
 * Udbhav                  2020-Aug-31    Created
 **/
trigger GDMFSL_ServiceAppointment on ServiceAppointment (before insert, before update, after insert, after update) {

    GDMFSL_ServiceAppointmentTriggerHandler.handleOperations(Trigger.operationType, Trigger.new, Trigger.oldMap);
}