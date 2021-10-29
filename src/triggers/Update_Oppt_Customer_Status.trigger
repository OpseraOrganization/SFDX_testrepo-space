/**
 * Created by Satya Mohanty on 11/21/2019.
 * OWNED BY THE CRM SALES TEAM.
 */
trigger Update_Oppt_Customer_Status on Task (before insert, after insert, after update, after delete) {
    Set<Id> oppID = new Set<Id>();
    String opptId;


    if (Trigger.isInsert || Trigger.isUpdate) {
        for (Task ntask : Trigger.new) {
            if (ntask.WhatId != null) {
                opptId = ntask.WhatId;
                opptId = opptId.substring(0, 3);
                if (opptId == '006') {
                    oppID.add(ntask.WhatId);
                }
            }
        }

        if (opptId == '006')
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
                    if(recordTypeIds.contains(ntsk.RecordTypeId) && Trigger.isInsert)
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

                    //Tact.AI: make ActivityDate and Activity_Date__c equal
                    if(!String.isBlank(ntsk.Source__c) && ntsk.Source__c == 'TACT AI')
                    {
                        if(ntsk.RecordTypeId == Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Next_Step').getRecordTypeId())
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
                    }
                }
            }
            else
            {
                Map<Id, Task> oldTaskMap = (Map<Id, Task>) Trigger.oldMap;
                for (Task ntsk : Trigger.new) {
                    Opportunity opp = [SELECT Id, Status__c,Next_Step__c,Next_Step_Date__c,Log_Virtual_Meeting__c,Log_Virtual_Meeting_Date__c,Log_F2F_Meeting__c,Log_F2F_Meeting_Date__c FROM Opportunity WHERE Id = :ntsk.WhatId LIMIT 1];

                    if(Trigger.isInsert || (Trigger.isUpdate && oldTaskMap.get(ntsk.Id).Description == opp.Status__c)) {
                        if (opp.Status__c != ntsk.Description) {
                            if (ntsk.RecordTypeId == Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Customer_Status').getRecordTypeId()) {
                                Opportunity opptObj = new Opportunity();
                                opptObj.Id = ntsk.WhatId;
                                opptObj.Status__c = ntsk.Description;
                                update opptObj;
                            }
                        }
                    }
                    if(Trigger.isInsert || (Trigger.isUpdate && oldTaskMap.get(ntsk.Id).Description == opp.Next_Step__c && oldTaskMap.get(ntsk.Id).ActivityDate == opp.Next_Step_Date__c))
                    {
                        if (opp.Next_Step__c != ntsk.Description || opp.Next_Step_Date__c != ntsk.ActivityDate) {
                            if (ntsk.RecordTypeId == Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Next_Step').getRecordTypeId()) {
                                Opportunity opptObj1 = new Opportunity();
                                opptObj1.Id = ntsk.WhatId;
                                opptObj1.Next_Step__c = ntsk.Description;
                                opptObj1.Next_Step_Date__c = ntsk.ActivityDate;
                                update opptObj1;
                            }
                        }
                    }
                    if(Trigger.isInsert || (Trigger.isUpdate && oldTaskMap.get(ntsk.Id).Description == opp.Log_Virtual_Meeting__c && oldTaskMap.get(ntsk.Id).Activity_Date__c == opp.Log_Virtual_Meeting_Date__c))
                    {
                        if (opp.Log_Virtual_Meeting__c != ntsk.Description || opp.Log_Virtual_Meeting_Date__c != ntsk.Activity_Date__c) {
                            if (ntsk.RecordTypeId == Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Log_Meeting').getRecordTypeId()) {
                                Opportunity opptObj1 = new Opportunity();
                                opptObj1.Id = ntsk.WhatId;
                                opptObj1.Log_Virtual_Meeting__c = ntsk.Description;
                                opptObj1.Log_Virtual_Meeting_Date__c = ntsk.Activity_Date__c;
                                update opptObj1;
                            }
                        }
                    }
                    if(Trigger.isInsert || (Trigger.isUpdate && oldTaskMap.get(ntsk.Id).Description == opp.Log_F2F_Meeting__c && oldTaskMap.get(ntsk.Id).Activity_Date__c == opp.Log_F2F_Meeting_Date__c))
                    {
                        if (opp.Log_F2F_Meeting__c != ntsk.Description || opp.Log_F2F_Meeting_Date__c != ntsk.Activity_Date__c) {
                            if (ntsk.RecordTypeId == Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Log_F2F').getRecordTypeId()) {
                                Opportunity opptObj1 = new Opportunity();
                                opptObj1.Id = ntsk.WhatId;
                                opptObj1.Log_F2F_Meeting__c = ntsk.Description;
                                opptObj1.Log_F2F_Meeting_Date__c = ntsk.Activity_Date__c;
                                update opptObj1;
                            }
                        }
                    }

                    //Clone another task in Tact.AI
                    if(Trigger.isInsert && ntsk.Type__c != null && ntsk.Source__c == 'TACT AI')
                    {
                        system.debug('Clone another task in Tact.AI:' + ntsk.Type__c);

                        Task clonedTask = ntsk.clone(false,false,false,false);
                        if(ntsk.Type__c == 'Customer Status')
                        {
                            clonedTask.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Customer_Status').getRecordTypeId();
                        }
                        else if(ntsk.Type__c == 'Log F2F Meeting')
                        {
                            clonedTask.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Log_F2F').getRecordTypeId();
                        }
                        else if(ntsk.Type__c == 'Log Virtual Meeting')
                        {
                            clonedTask.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Log_Meeting').getRecordTypeId();
                        }
                        else if(ntsk.Type__c == 'Log Call')
                        {
                            clonedTask.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Log_Call').getRecordTypeId();
                        }

                        clonedTask.Subject = ntsk.Type__c;
                        clonedTask.Type__c = null;

                        Insert clonedTask;
                    }
                }
            }
        }
    }
    else if (Trigger.isDelete) {
        for (Task ntask : Trigger.old) {
            if (ntask.WhatId != null) {
                opptId = ntask.WhatId;
                opptId = opptId.substring(0, 3);
                if (opptId == '006') {
                    oppID.add(ntask.WhatId);
                }
            }
        }

        if (opptId == '006') {
            for (Task ntsk : Trigger.old) {
                List<Task> previousTasks = new List<Task>();
                Id recTypeIdCustomerStatus = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Customer_Status').getRecordTypeId();
                Id recTypeIdNextStep = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Next_Step').getRecordTypeId();
                Id recTypeIdLogMeeting = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Log_Meeting').getRecordTypeId();
                Id recTypeIdLogF2F = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Log_F2F').getRecordTypeId();

                previousTasks = [Select Id, WhatId, Description, ActivityDate,Activity_Date__c From Task Where WhatId =: ntsk.WhatId AND RecordTypeId =:ntsk.RecordTypeId Order By CreatedDate DESC Limit 1];

                //if it is the only Customer Status Task then wipe out Customer Status value in Opportunity
                if(previousTasks.size() == 0)
                {
                    Opportunity opptObj = new Opportunity();
                    opptObj.Id = ntsk.WhatId;

                    if(ntsk.RecordTypeId == recTypeIdCustomerStatus)
                    {
                        opptObj.Status__c = '';
                        system.debug('Wipe out Customer Status for Opp Id:' + ntsk.WhatId);
                    }
                    else if(ntsk.RecordTypeId == recTypeIdNextStep)
                    {
                        opptObj.Next_Step__c = '';
                        opptObj.Next_Step_Date__c = null;
                        system.debug('Wipe out Next Step for Opp Id:' + ntsk.WhatId);
                    }
                    else if(ntsk.RecordTypeId == recTypeIdLogMeeting)
                    {
                        opptObj.Log_Virtual_Meeting__c = '';
                        opptObj.Log_Virtual_Meeting_Date__c = null;
                        system.debug('Wipe out Log Virtual Meeting for Opp Id:' + ntsk.WhatId);
                    }
                    else if(ntsk.RecordTypeId == recTypeIdLogF2F)
                    {
                        opptObj.Log_F2F_Meeting__c = '';
                        opptObj.Log_F2F_Meeting_Date__c = null;
                        system.debug('Wipe out Log F2F Meeting for Opp Id:' + ntsk.WhatId);
                    }

                    update opptObj;
                }
                else if(previousTasks.size() > 0)
                {
                    Opportunity opp = [Select Id, Status__c, Next_Step__c, Next_Step_Date__c,Log_Virtual_Meeting__c,Log_Virtual_Meeting_Date__c,Log_F2F_Meeting__c,Log_F2F_Meeting_Date__c From Opportunity Where Id =: ntsk.WhatId LIMIT 1];

                    if(ntsk.RecordTypeId == recTypeIdCustomerStatus)
                    {
                        if(opp.Status__c != ntsk.Description)
                        {
                            //Do nothing
                        }
                        else
                        {
                            //use previous Customer Status to override in Customer Status of Opportunity
                            opp.Id = ntsk.WhatId;
                            opp.Status__c = previousTasks[0].Description;

                            update opp;
                        }
                    }
                    else if(ntsk.RecordTypeId == recTypeIdNextStep)
                    {
                        if(opp.Next_Step__c != ntsk.Description || opp.Next_Step_Date__c != ntsk.ActivityDate)
                        {
                            //Do nothing
                        }
                        else
                        {
                            //user previous Next Step to override in Next Step of Opportunity
                            opp.Id = ntsk.WhatId;
                            opp.Next_Step__c = previousTasks[0].Description;
                            opp.Next_Step_Date__c = previousTasks[0].ActivityDate;

                            update opp;
                        }
                    }
                    else if(ntsk.RecordTypeId == recTypeIdLogMeeting)
                    {
                        if(opp.Log_Virtual_Meeting__c != ntsk.Description || opp.Log_Virtual_Meeting_Date__c != ntsk.Activity_Date__c)
                        {
                            //Do nothing
                        }
                        else
                        {
                            //user previous Log Virtual Meeting to override in Log Virtual Meeting of Opportunity
                            opp.Id = ntsk.WhatId;
                            opp.Log_Virtual_Meeting__c = previousTasks[0].Description;
                            opp.Log_Virtual_Meeting_Date__c = previousTasks[0].Activity_Date__c;

                            update opp;
                        }
                    }
                    else if(ntsk.RecordTypeId == recTypeIdLogF2F)
                    {
                        if(opp.Log_F2F_Meeting__c != ntsk.Description || opp.Log_F2F_Meeting_Date__c != ntsk.Activity_Date__c)
                        {
                            //Do nothing
                        }
                        else
                        {
                            //user previous Log F2F Meeting to override in Log F2F Meeting of Opportunity
                            opp.Id = ntsk.WhatId;
                            opp.Log_F2F_Meeting__c = previousTasks[0].Description;
                            opp.Log_F2F_Meeting_Date__c = previousTasks[0].Activity_Date__c;

                            update opp;
                        }
                    }
                }
            }
        }
    }
}