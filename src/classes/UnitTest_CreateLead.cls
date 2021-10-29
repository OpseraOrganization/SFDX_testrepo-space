@isTest (seealldata = true)
public class UnitTest_CreateLead{
    testMethod static void testCreateLead(){
        Contract contract = [select id from contract limit 1];
        Account acct = [select id from Account limit 1];
        Fleet_Asset_Detail__c faa = [select id from Fleet_Asset_Detail__c limit 1];
        List<task> t = new List<task>{ new task(
        WhatID = contract.id,
        Subject='Test',
        Status='Completed',
        Priority='Normal',
        Accounts_Name__c = acct.id,
        Create_Lead__c = true        
        )};

        insert t;  
    }
}