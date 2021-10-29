/**
 * Created by Meiying Liang on 5/11/2020.
 */

trigger Create_Account_Task on Task (before insert, after insert, before update) {
    String accountId;

    if (Trigger.isInsert || Trigger.isUpdate) {
        for (Task ntask : Trigger.new) {
            if (ntask.WhatId != null) {
                accountId = ntask.WhatId;
                accountId = accountId.substring(0,3);
            }
        }

        if (accountId == '001')
        {
            if(Trigger.isBefore)
            {
                Set<Id> recordTypeIds = new Set<Id>();

                recordTypeIds.add(Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Customer_Status').getRecordTypeId());
                recordTypeIds.add(Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Next_Step').getRecordTypeId());

                recordTypeIds.add(Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Log_F2F').getRecordTypeId());
                recordTypeIds.add(Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Log_Meeting').getRecordTypeId());

                recordTypeIds.add(Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Log_Call').getRecordTypeId());
                recordTypeIds.add(Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Log_Email').getRecordTypeId());
                recordTypeIds.add(Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Sales_Activity').getRecordTypeId());

                for(Task ntsk : Trigger.new)
                {
                    if(recordTypeIds.contains(ntsk.RecordTypeId))
                    {
                        if(Trigger.isInsert)
                        {
                            if(ntsk.RecordTypeId == Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Next_Step').getRecordTypeId())
                            {
                                ntsk.Status = 'In Progress';
                            }
                            else
                            {
                                ntsk.Status = 'Completed';
                            }
                        }

                        //make ActivityDate and Activity_Date__c equal
                        ntsk.Subject = Schema.SObjectType.Task.getRecordTypeInfosById().get(ntsk.RecordTypeId).getName();

                        if(ntsk.RecordTypeId == Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Customer_Status').getRecordTypeId())
                        {
                            ntsk.ActivityDate = date.today();
                            ntsk.Activity_Date__c = date.today();
                        }
                        else if(ntsk.RecordTypeId == Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Next_Step').getRecordTypeId())
                        {
                            if(ntsk.ActivityDate == null)
                            {
                                system.debug('ActivityDate is null, set ActivityDate and Activity_Date__c to current date');
                                ntsk.ActivityDate = date.today();
                                ntsk.Activity_Date__c = date.today();
                            }
                            else
                            {
                                system.debug('ActivityDate is not null, set Activity_Date__c:' + ntsk.ActivityDate);
                                ntsk.Activity_Date__c = ntsk.ActivityDate;
                            }
                        }
                        else
                        {
                            if(recordTypeIds.contains(ntsk.RecordTypeId))
                            {
                                if(ntsk.Activity_Date__c == null)
                                {
                                    system.debug('ActivityDate is null, set ActivityDate and Activity_Date__c to current date');
                                    ntsk.Activity_Date__c = date.today();
                                    ntsk.ActivityDate = date.today();
                                }
                                else
                                {
                                    system.debug('ActivityDate is not null, set Activity_Date__c:' + ntsk.ActivityDate);
                                    ntsk.ActivityDate = ntsk.Activity_Date__c;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}