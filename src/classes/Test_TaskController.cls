/** * File Name: Test_TaskController
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest
private  class Test_TaskController {
    static Tasks taskCon = null;
    static void setupEnv(){
        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr = new User(LastName = 'Test', FirstName = ' UserCSO2', Username = 'tu1cso@test.com',Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1cso' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');insert usr;   
        Account acc= new Account(name='Test Account', Market_Name__c = 'Military');
        insert acc;
        Task tasks= new Task (whatId=acc.Id,ownerid=usr.Id);
        insert tasks;

        PageReference pageRef = Page.TaskPage;
        Test.setCurrentPage(pageRef);

        ApexPages.StandardController sc = new ApexPages.StandardController(tasks);
        taskCon = new Tasks(sc);
    }
    static testmethod void testTasksPage1(){
        setupEnv();

        list<String> srtExp = new list<String>();
        srtExp.add('subject');
        srtExp.add('Priority');
        srtExp.add('Status');

        list<String> listSel = new list<String>();
        listSel.add('Today');
        listSel.add('Tomorrow');
        listSel.add('All Open');
        listSel.add('Next 7 days');
        listSel.add('This Month');
        listSel.add('OverDue');
        listSel.add('Today+OverDue');
        listSel.add('Next 7 days+OverDue');
        

        for(String sel : listSel){
            taskCon.setlistSel(sel);
            for(String srt : srtExp){
                taskCon.sortExpression = srt;
                taskCon.setsortDirection('ASC');
                taskCon.RefreshData();
                taskCon.setsortDirection('DESC');
                taskCon.RefreshData();
            }
        }
        taskCon.getSortDirection();
        taskCon.getlistSel();
        taskCon.getTasks();
    }
    static testmethod void testTasksPage2(){
        setupEnv();

        list<String> srtExp = new list<String>();
        srtExp.add('WhatId');
        srtExp.add('Type');
        srtExp.add('ActivityDate');
        srtExp.add('Activity_Number__c');

        list<String> listSel = new list<String>();
        listSel.add('Today');
        listSel.add('Tomorrow');
        listSel.add('All Open');
        listSel.add('Next 7 days');
        listSel.add('This Month');
        listSel.add('OverDue');
        listSel.add('Today+OverDue');
        listSel.add('Next 7 days+OverDue');
        

        for(String sel : listSel){
            taskCon.setlistSel(sel);
            for(String srt : srtExp){
                taskCon.sortExpression = srt;
                taskCon.setsortDirection('ASC');
                taskCon.RefreshData();
                taskCon.setsortDirection('DESC');
                taskCon.RefreshData();
            }
        }
    }
    /*
        taskCon.sortExpression = 'subject';
        taskCon.RefreshData();
        taskCon.sortExpression = 'subject';
        taskCon.RefreshData();
        //taskCon.sortExpression = 'Priority';
        taskCon.RefreshData();
        //taskCon.sortExpression = 'Priority';
        taskCon.RefreshData();  
        taskCon.getSortDirection();
        taskCon.setSortDirection('DESC');
        taskCon.getlistSel();
        taskCon.setlistSel('Today');
        taskCon.RefreshData();
        taskCon.getTasks();
        taskCon.setlistSel('Tomorrow');
        taskCon.RefreshData();
        taskCon.setlistSel('All Open');
        taskCon.RefreshData();
        taskCon.setlistSel('Next 7 days');
        taskCon.RefreshData();
        taskCon.setlistSel('This Month');
        taskCon.RefreshData();
        taskCon.setlistSel('OverDue');
        taskCon.RefreshData();
        taskCon.setlistSel('Today+OverDue');
        taskCon.RefreshData();
        taskCon.setlistSel('Next 7 days+OverDue');
        taskCon.RefreshData();
        */
}