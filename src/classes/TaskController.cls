/**
 * Created by Satya Mohanty on 11/18/2019.
 * OWNED BY THE CRM SALES TEAM.
 */
public with sharing class TaskController {
    static List<Task> tskNew;
    @AuraEnabled
    public static List<Task> loadTasks(Id recordId){
        System.debug('i am init -----'+recordId);
        return[SELECT Subject, ActivityDate FROM Task WHERE WhatId=:recordId];
    }

    @AuraEnabled
    public static List<String> GetOpportunityStage(){
        List<String> lstData=new List<String>();
        Schema.DescribeFieldResult fieldResult = Task.Status.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        /*for(Schema.PicklistEntry s:ple){
            lstData.add(s.getLabel());
        }*/
        lstData.add('In Progress');
        return lstData;
    }

    @AuraEnabled
    public static List<String> GetPriority(){
        List<String> lstData=new List<String>();
        Schema.DescribeFieldResult fieldResult = Task.Priority.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        /*for(Schema.PicklistEntry s:ple){
            lstData.add(s.getLabel());
        } */
        lstData.add('Normal');
        return lstData;
    }

    @AuraEnabled
    public static Task saveTask(Task task){
        tskNew = new List<Task>();
        System.debug('Hi i am in----'+task);
        Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Customer Status').getRecordTypeId();
        if(task.Description !='' && task.Description !=null){
            tskNew.add( new Task(
                    RecordtypeID = recTypeId,
                    Subject = 'Customer Status',
                    WhatId = task.WhatId,
                    //This is the default..
                    OwnerId = UserInfo.getUserId(),
                    Status = 'In Progress',
                    Type = 'Call',
                    Description = task.Description,
                    ActivityDate = task.ActivityDate,
                    CreatedDate = system.now()));
        }
        System.debug('Hi i am new task----'+tskNew);
        try{

            if(tskNew.size()>0){
                insert tskNew;
/*
                List<Opportunity> opptListu = new List<Opportunity>();
                for(Opportunity oppty :[SELECT Name, Id, Status__c FROM Opportunity WHERE ID =: task.WhatId]){
                    Opportunity opptObj = new Opportunity();
                    opptObj.id = task.WhatId;
                    opptObj.Status__c = task.Description;
                    opptListu.add(opptObj);
                }
                if(opptListu.size()>0){
                    System.debug('rsdjbjc============='+opptListu);
                    //update opptListu;
                }
 */
            }
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Record Created Successfully.Thank you!'));
            // tskNew = new Task();
        }
        catch (Exception e) {
            // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There was an Error! Cannot Create Task'));
        }
        return null;
    }
    @AuraEnabled
    public static Task saveTask1(Task task){
        tskNew = new List<Task>();
        Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Next Step').getRecordTypeId();
        if(task.Description !='' && task.Description !=null){
            tskNew.add( new Task(
                    RecordtypeID = recTypeId,
                    Subject = 'Next Step',

                    WhatId = task.WhatId,
                    //This is the default..
                    OwnerId = UserInfo.getUserId(),
                    Status = 'In Progress',
                    Type = 'Call',
                    Description = task.Description,
                    ActivityDate = task.ActivityDate,
                    CreatedDate = system.now()
            ));
        }

        if(tskNew.size()>0){
            system.debug('saveTask1:' + tskNew);

            insert tskNew;
/*
            List<Opportunity> opptListu = new List<Opportunity>();
            for(Opportunity oppty :[SELECT Name, Id, Status__c FROM Opportunity WHERE ID =: task.WhatId]){
                Opportunity opptObj = new Opportunity();
                opptObj.id = task.WhatId;
                opptObj.Next_Step__c  = task.Description;
                opptObj.Next_Step_Date__c = task.ActivityDate;
                opptListu.add(opptObj);
            }
            if(opptListu.size()>0){

                //update opptListu;
            }
 */
        }
        return null;
    }
    @AuraEnabled
    public static Task saveTask2(Task task){
        List<Task> tskNew = new List<Task>();
        Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('General Task').getRecordTypeId();
        if(task.Description !='' && task.Description !=null){
            tskNew.add( new Task(
                    RecordtypeID = recTypeId,
                    Subject = 'General Task',
                    WhatId = task.WhatId,
                    //WhoId = task.Ownerid,
                    //This is the default..
                    OwnerId = UserInfo.getUserId(),
                    Status = 'In Progress',
                    Priority= 'Normal',
                    Type = 'Call',
                    Description = task.Description,
                    ActivityDate = task.ActivityDate));
        }
        try{
            insert tskNew;
        }
        catch (Exception e) {
        }
        return null;
    }
    @AuraEnabled
    public static Task saveTask3(Task task){
        List<Task> tskNew = new List<Task>();

        system.debug('task is:' + task);

        Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Sales Activity').getRecordTypeId();
        if(task.Description !='' && task.Description !=null){
            tskNew.add( new Task(
                    RecordtypeID = recTypeId,
                    Subject = 'Sales Activity',
                    WhatId = task.WhatId,
                    //This is the default..
                    OwnerId = UserInfo.getUserId(),
                    Status = 'In Progress',
                    Priority= 'Normal',
                    Type = 'Call',
                    Description = task.Description,
                    ActivityDate = task.ActivityDate));
        }
        try{
            insert tskNew;
        }
        catch (Exception e) {
        }
        return null;

    }
}