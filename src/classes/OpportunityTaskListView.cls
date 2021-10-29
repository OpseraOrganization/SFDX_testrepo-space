/**
 * Created by Meiying Liang on 12/14/2019.
 */

public with sharing class OpportunityTaskListView {
    @AuraEnabled(cacheable=true)
    public static List<Task> getOpportunityTaskList(string recordId) {
        system.debug('recordId:' + recordId);
        
        List<Task> result = [
                SELECT Id, Subject, Description, Status, CreatedDate, ActivityDate, Activity_Date__c,CreatedBy.Name
                FROM Task
                WHERE WhatId = :recordId
                LIMIT 1000
        ];

        system.debug('OpportunityTaskList:' + result);

        return result;
    }

    @AuraEnabled
    public static Task saveOpportunityTask(Task objTask, string type) {
        try
        {
            Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get(type).getRecordTypeId();
            String recTypeLableName = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get(type).getName();

            objTask.Subject = recTypeLableName;
            objTask.OwnerId = UserInfo.getUserId();
            objTask.RecordTypeId = recTypeId;
            objTask.CreatedDate = system.now();

            insert objTask;

            system.debug('save opportunity task:' + objTask);
        }
        catch (Exception exp)
        {
            system.debug(exp);
        }
        return objTask;
    }

}