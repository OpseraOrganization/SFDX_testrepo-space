/*  * File Name: WFAH_EmailReminder
    * Description: Batch Job Class To Send Daily Email Reminder
    * Copyright : Wipro Technologies Limited Copyright (c) 2010
    * @author : wipro
    * Modification Log ===============================================================
      Ver Date Author Modification --- ---- ------ -------------*
     */

//BatchhJob class

global class WFAH_EmailReminder implements Database.Batchable<sObject>{
    global String query;

    //Start Method of Batch Apex   
    global database.querylocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
    }

    //Execute method
    global void execute(Database.BatchableContext BC, List<sObject> AppoverEmail){
        list<Workflow_Approval_History__c> aapis = new list<Workflow_Approval_History__c>();
        for(sObject test: AppoverEmail){
            Workflow_Approval_History__c wf= (Workflow_Approval_History__c)test;
            // Updating the Workflow Approval Hisstory Records' Reminder field as Scheduler
            wf.Reminder__c = 'Scheduler';
            aapis.add(wf); 
        }
    Update aapis;
    }
    global void finish(Database.BatchableContext BC){
    }
}