public without sharing class GDMFSL_DeadManCheckInFailure_Batch implements Database.Batchable<SObject>, Schedulable{

    String queryString = 'SELECT id, AppointmentNumber, GDMFSL_Last_Dead_Man_Switch__c, GDMFSL_Dead_Man_Switch_Timer__c, FSL__InJeopardy__c, FSL__InJeopardyReason__c, ActualStartTime FROM ServiceAppointment  WHERE status = \'Onsite\' AND GDMFSL_Dead_Man_Switch_Timer__c != NULL AND GDMFSL_Dead_Man_Switch_Timer__c != 0 AND (GDMFSL_Last_Dead_Man_Switch__c != NULL OR ActualStartTime != null)';

    public Database.QueryLocator start(Database.BatchableContext context){
        return Database.getQueryLocator(queryString);
    }

    public void execute(Database.BatchableContext context, List<ServiceAppointment> scope){

        Map<Id, ServiceAppointment> needToNotify = new Map<Id, ServiceAppointment>();

        for(ServiceAppointment sa : scope){

            System.debug('Checking ServAppt: ' + sa.Id);

            // If it's been more time since the last dead man switch timer than is allowed (dead man timer, expressed in minutes),
            // This is an sa that needs to go into jeopardy and perform a notification
            Long rightNowMinutes = System.now().getTime() / 1000 / 60;
            System.debug('HW debug - rightNowMinutes is ' + rightNowMinutes);

            Long lastDeadManSwitchMinutes = ((sa.GDMFSL_Last_Dead_Man_Switch__c == null) ? sa.ActualStartTime.getTime() : sa.GDMFSL_Last_Dead_Man_Switch__c.getTime()) / 1000 / 60;
            System.debug('HW debug - lastDeadManSwitchMinutes is ' + lastDeadManSwitchMinutes);
            System.debug('HW debug - Difference is ' + (rightNowMinutes - lastDeadManSwitchMinutes));
            
            Decimal deadManTimerMinutes = sa.GDMFSL_Dead_Man_Switch_Timer__c * 60;
            System.debug('HW debug - deadManTimerMinutes is ' + deadManTimerMinutes);

            if((rightNowMinutes - lastDeadManSwitchMinutes) > deadManTimerMinutes){
                sa.FSL__InJeopardy__c = true;
                sa.FSL__InJeopardyReason__c = 'Dead Man Follow Up';
                needToNotify.put(sa.Id, sa);

                System.debug('HW debug - adding ' + sa.AppointmentNumber + ' to update list');
            }
        }

        if(needToNotify.size() > 0){

            GDMFSL_CommonUtilities.updateRecords(needToNotify.values());

            List<GDMFSL_SMSMessageRecipient> recipientList = new List<GDMFSL_SMSMessageRecipient>();
            for(AssignedResource ar : [select Id, ServiceResource.RelatedRecordId, ServiceResource.RelatedRecord.MobilePhone, ServiceResource.RelatedRecord.Phone from AssignedResource
                                            where ServiceAppointmentId in :needToNotify.keySet()]){

                GDMFSL_SMSMessageRecipient recipient = new GDMFSL_SMSMessageRecipient();
                recipient.messagingTempateName = 'GDMFSL_Dead_Man_Check_In_Prompt';
                recipient.userId = ar.ServiceResource.RelatedRecordId;
                recipient.phone = (ar.ServiceResource.RelatedRecord.MobilePhone == null) ? ar.ServiceResource.RelatedRecord.Phone : ar.ServiceResource.RelatedRecord.MobilePhone;
                recipient.contextRecordId = ar.Id; 
                recipientList.add(recipient);
            }

            if(recipientList.size() > 0){
                Map<String, Object> params = new Map<String, Object>{'vSMSMessageRecipients' => recipientList};
                Flow.Interview pmFlow = new Flow.Interview.GDMFSL_Send_SMS_Bulk(params);
                pmFlow.start();  
            }
        }
    }

    public void finish(Database.BatchableContext context){}

    public void execute(SchedulableContext context){
        Database.executeBatch(new GDMFSL_DeadManCheckInFailure_Batch());
    }
}