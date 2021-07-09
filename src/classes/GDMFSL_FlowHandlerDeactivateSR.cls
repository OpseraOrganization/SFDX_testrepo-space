/**
 * Name       :    GDMFSL_FlowHandlerDeactivateSR
 * Purpose    :    This is a  utility class to be triggered from the flow to fetch the in Progress
 * Service Appointment assigned to the current user
 * --------------------------------------------------------------------------
 * Developer               Date          Description
 * --------------------------------------------------------------------------
 * Udbhav Zaroo	        2020-08-26    Created
 **/
public class GDMFSL_FlowHandlerDeactivateSR {

    private static final Set<String> NOTINPROGRESS = new Set<String>{
            GDMFSL_ServiceAppointmentProcessor.UNSCHEDULEDSTATUS,
            GDMFSL_ServiceAppointmentProcessor.COMPLETEDSTATUS,
            GDMFSL_ServiceAppointmentProcessor.CANCELLEDSTATUS
    };

    @InvocableMethod
    public static List<List<ServiceAppointment>> getServiceAppointments(List<List<AssignedResource>> lstAssignedResource) {
        return fetchInProgressSA(getSAIDs(lstAssignedResource));
    }

    @TestVisible
    private static Set<Id> getSAIDs (List<List<AssignedResource>> lstAssignedRes) {
        Set<Id> serviceAppointmentId = new Set<Id>();

        if (lstAssignedRes != null) {
            for (List<AssignedResource> lst : lstAssignedRes) {
                for (AssignedResource ar : lst) {
                    if (ar.ServiceAppointmentId != null) {
                        serviceAppointmentId.add(ar.ServiceAppointmentId);
                    }
                }
            }
        }
        return serviceAppointmentId;
    }

    @TestVisible
    private static List<List<ServiceAppointment>> fetchInProgressSA(Set<Id> serviceApptId) {
        return new List<List<ServiceAppointment>>{new List<ServiceAppointment>([SELECT Id,Status FROM ServiceAppointment WHERE Id IN :serviceApptId AND Status NOT IN :NOTINPROGRESS])};
    }

}