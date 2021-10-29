/**
 * Created by Satya Mohanty on 6/11/2019.
 * OWNED BY THE CRM SALES TEAM.
 */

@IsTest
private class LogErrorEvent_Test {
    @IsTest
    static void testBehavior() {
        Log_Error_Event__e errLogEvent = new Log_Error_Event__e();
        errLogEvent.Team_Name__c = 'My Team';
        errLogEvent.Object__c = 'Opportunity';
        errLogEvent.Description__c = 'my description';

        System.Test.startTest();
        EventBus.publish(errLogEvent);
        System.Test.stopTest();

        List<Error_Log__c> errLogs = [SELECT Id FROM Error_Log__c WHERE Team_Name__c = 'My Team'];

        System.assertEquals(1, errLogs.size());
    }
}