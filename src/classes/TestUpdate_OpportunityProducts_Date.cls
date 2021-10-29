@isTest(seeAlldata=true)
private class TestUpdate_OpportunityProducts_Date{
     static testMethod void methodUpdate_OpportunityProducts_DateTest() {
        
        
        OpportunityLineItem oppLine = [select OpportunityID from OpportunityLineItem where ServiceDate<>null and Type__c = 'Forecast' limit 1];
        Opportunity opp = [select id,CloseDate from Opportunity where CloseDate<>null and id =:oppLine.OpportunityID];
        opp.CloseDate = opp.CloseDate+1;
        update opp;
        
        User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];
        Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%HONEYWELL%' limit 1];
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Test';
        opp1.Description = 'Test';
        opp1.RecordtypeId = '01230000000bN7k';
        opp1.End_User__c = acc.id;
        opp1.Accountid = acc.id;
        opp1.SBU__c = 'Intracompany';
        opp1.Type = 'OE Standard';
        opp1.StageName = 'Open';
        opp1.ATR_Probability__c = 10;
        opp1.CloseDate = System.today();
        opp1.Next_Phase__c = 'test';
        insert opp1;
        Test.startTest();
        Opportunity_Gate__c oppgate = new Opportunity_Gate__c();
        oppgate.Opportunity__c = opp1.Id;
        oppgate.name = 'Solicitation Review';
        oppgate.Stage__c = 'launch';
        oppgate.Completion_Date__c = system.today()-1;
        oppgate.Actual_Date__c = system.today();
        insert oppgate;
        oppgate.Completion_Date__c = system.today()+1;
        oppgate.Actual_Date__c = null;
        
        update oppgate;
       
        Opportunity_Gate__c oppgate1 = new Opportunity_Gate__c();
        oppgate1.Opportunity__c = opp.Id;
        oppgate1.name = 'Pricing Meeting';
        oppgate1.Completion_Date__c = system.today()-1;
        oppgate1.Stage__c = 'propose';
        insert oppgate1;
        oppgate1.Completion_Date__c = system.today()+1;
        update oppgate1;
        Test.stopTest();
     }
 }