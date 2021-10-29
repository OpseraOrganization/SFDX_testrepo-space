global with sharing class AutomatedUpdateAccounts implements Schedulable {
    global void execute(SchedulableContext SC) {
        Database.ExecuteBatch(new updateAccounts(),50);
    }
}