@isTest
private class ReValidateAccessTest {        
    static testMethod void testScheduler(){
Test.startTest();
String jobId = System.schedule('testScheduledApex','0 0 0 3 9 ? 2022', new SchBatSinEmailMsg());

Test.stopTest();
}
static testMethod void testBatch(){
Test.startTest();
id batchId=Database.executeBatch(new SingleEmailMsg('SELECT Id,Email,Email_Count__c FROM Contact limit 10'));
Test.stopTest();
} 
}