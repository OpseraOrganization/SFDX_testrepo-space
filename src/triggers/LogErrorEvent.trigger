/**
 * Created by Nikolay Kolev on 6/11/2019.
 * OWNED BY THE CRM SALES TEAM.
 */

trigger LogErrorEvent on Log_Error_Event__e (after insert) {
    List<Error_Log__c> errLogs = new List<Error_Log__c>();
    for(Log_Error_Event__e event: Trigger.new) {
        errLogs.add(new ErrorLogBuilder(event.Team_Name__c)
                .setObjectInfo(event.Object__c)
                .setDescription(event.Description__c)
                .build());
    }
    Database.insert(errLogs, false);
}