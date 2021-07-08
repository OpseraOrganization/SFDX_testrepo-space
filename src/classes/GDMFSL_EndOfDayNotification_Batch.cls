global without sharing class GDMFSL_EndOfDayNotification_Batch implements Database.Batchable<SObject>, Schedulable {

    public GDMFSL_EndOfDayNotification_Batch() {}

    global Database.QueryLocator start(Database.BatchableContext context){
        DateTime dt = System.now().addHours(-18);
        System.debug('HW debug - End of Day Notification timeframe is ' + dt);
        // Get all the Service Resources who have started a shift in the last 18 hours
        String queryString = 'select id, RelatedRecordId, GDMFSL_Start_Of_Shift__c, RelatedRecord.MobilePhone, RelatedRecord.Phone from ServiceResource where GDMFSL_Start_of_Shift__c > :dt order by GDMFSL_Start_of_Shift__c';
        return Database.getQueryLocator(queryString);
    }

    global void execute(Database.BatchableContext context, List<SObject> scope){
        List<GDMFSL_SMSMessageRecipient> deliveryList = getSMSRecipients((List<ServiceResource>)scope);
        if(deliveryList.size() > 0){
            System.debug('HW debug - Sending End of Day Notifications to ' + deliveryList.size() + ' participants');
            Map<String, Object> params = new Map<String, Object>{'vSMSMessageRecipients' => deliveryList};
            Flow.Interview pmFlow = new Flow.Interview.GDMFSL_Send_SMS_Bulk(params);
            pmFlow.start();  
        } else {
            System.debug('HW debug - No current recipients for End of Day Notifications');
        }
    }

    global void finish(Database.BatchableContext context){}

    global void execute(System.SchedulableContext context){
        Database.executeBatch(new GDMFSL_EndOfDayNotification_Batch());
    }

    @TestVisible
    private static List<GDMFSL_SMSMessageRecipient> getSMSRecipients(List<ServiceResource> resourceList){
        List<GDMFSL_SMSMessageRecipient> result = new List<GDMFSL_SMSMessageRecipient>();

        DateTime dt = System.now().addHours(-18);  // a randomly chosen amount of time (18 hours) to include all possible shift lengths
        Map<Id,ServiceResource> srStartOfShiftResources = new Map<Id,ServiceResource>();
        Map<Id, GDMFSL_Safe_and_Sound__c> lastSrEndOfDayTravel = new Map<Id,GDMFSL_Safe_and_Sound__c>();
        Map<Id,Id> serviceResourceUserIdMap = new Map<Id,Id>();
        Map<Id,double> serviceResourceWorkdayMap = new Map<Id,double>();
        List<Id> smsUserSendList = new List<Id>();

        for(ServiceResource sr : resourceList){
            srStartOfShiftResources.put(sr.id,sr);
            serviceResourceUserIdMap.put(sr.Id,sr.RelatedRecordId);
        }

        // Get the standard workday duration for all relevant Territories
        for(ServiceTerritoryMember stm : [select id, ServiceResourceId, ServiceTerritory.GDMFSL_Standard_Workday_Duration__c from ServiceTerritoryMember
                                            where TerritoryType = 'P' and ServiceResourceId in :serviceResourceUserIdMap.keySet()]){
            serviceResourceWorkdayMap.put(stm.serviceResourceId,stm.ServiceTerritory.GDMFSL_Standard_Workday_Duration__c);
        }

        // Get all the end of day travel records for those resources, that happened after the latest start of day
        // Map the latest End of Day Travel time to service resources
        for(GDMFSL_Safe_and_Sound__c sas : [select GDMFSL_Service_Resource__c, GDMFSL_Start__c from GDMFSL_Safe_and_Sound__c 
                                        where GDMFSL_Service_Resource__c in :serviceResourceUserIdMap.keySet() and GDMFSL_Start__c > :dt ORDER BY GDMFSL_Start__c]){
                lastSrEndOfDayTravel.put(sas.GDMFSL_Service_Resource__c,sas);
        }

        for(Id srId : srStartOfShiftResources.keySet()){
            ServiceResource serviceResource = srStartOfShiftResources.get(srId);
            GDMFSL_Safe_and_Sound__c sas = lastSrEndOfDayTravel.get(serviceResource.Id);
            DateTime endDt = (sas != null) ? sas.GDMFSL_Start__c : null;
            DateTime startDt = serviceResource.GDMFSL_Start_of_Shift__c;
            double minutesSinceStartOfShift = (System.now().getTime() - startDt.getTime()) / 60000;
            double standardWorkDayInMinutes = serviceResourceWorkdayMap.get(srId);
            System.debug('*****> Service Resource Id: '+srId);
            System.debug('*****> Last Safe and Sound: '+endDt);
            System.debug('*****> Start of Shift: '+startDt);
            System.debug('*****> Minutes Since Start of Shift: '+minutesSinceStartOfShift);
            System.debug('*****> Standard WorkDay In Minutes: '+standardWorkDayInMinutes);
            // If they don't have a last end of day or it happened before their latest start of shift AND they are in the last half hour of their standard work day length,
            // send them a text.
            if((sas == null || endDt == null || endDt < startDt) && (standardWorkDayInMinutes != null && (minutesSinceStartOfShift > (standardWorkDayInMinutes-30)))){
                if(serviceResource.RelatedRecord.MobilePhone != null || serviceResource.RelatedRecord.phone != null){
                    GDMFSL_SMSMessageRecipient recipient = new GDMFSL_SMSMessageRecipient();
                    recipient.messagingTempateName = 'GDMFSL_End_of_Day_Prompt';
                    recipient.contextRecordId = serviceResource.Id;
                    recipient.userId = serviceResource.RelatedRecordId;
                    recipient.phone = (serviceResource.RelatedRecord.mobilePhone == null) ? serviceResource.RelatedRecord.phone : serviceResource.RelatedRecord.mobilePhone;
                    result.add(recipient);
                } else {
                    System.debug('HW debug - No phone number was found for this resource');
                }
            }
        }

        return result;
    }
}