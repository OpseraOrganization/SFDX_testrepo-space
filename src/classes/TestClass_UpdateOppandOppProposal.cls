@isTest(SeeAllData=true)
private class TestClass_UpdateOppandOppProposal{
    static testMethod void TestMthd_UpdateOppandOppProposal(){
        User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];
        Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%honeywell%' limit 1];
        
        Contact objContact = new Contact();
        objContact.LastName = 'hari';
        objContact.FirstName = 'vnv1';
        objContact.AccountId = acc.Id;
        objContact.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        objContact.Email='harikishore.vutukuri@honeywell.com';
        objContact.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
        objContact.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c; 
        objContact.Employee_Number__c = 'E123123';    
        insert objContact;
         
        Opportunity opp = [select id,Name from Opportunity where Name Like '%Boeing%' limit 1];
        Opportunity_Proposal__c oppPr = [Select id,name from Opportunity_Proposal__c where Name Like '%OPRO%' limit 1];
        
        Case cs = new Case();
        cs.Origin = 'Email';
        cs.Status = 'Open';
        cs.ContactId = objContact.Id;
        cs.HON_Commit_Date__c = System.now();
        cs.Classification__c = 'CSO Repair/Overhaul';
        cs.Type = 'Shipping/Invoicing';
        cs.RecordtypeId = label.D_S_Clear_House_RecordTypeId_Case;
        cs.Opportunity__c = opp.id;
        cs.Opportunity_Proposal__c = oppPr.id;
        insert cs;
        
        Case cs1 = new Case();
        cs1.Origin = 'Email';
        cs1.Status = 'Open';
        cs1.ContactId = objContact.Id;
        cs1.HON_Commit_Date__c = System.now();
        cs1.Classification__c = 'CSO Repair/Overhaul';
        cs1.Type = 'Shipping/Invoicing';
        cs1.RecordtypeId = label.Aero_Export_Holds_RT_ID;
        insert cs1;
        
        Workflow_details__c wf = new Workflow_details__c();
        wf.Case__c = cs.Id;
        insert wf;
        
        test.StartTest();
        wf.Opportunity_Description__c = cs.Opportunity__c;
        wf.Opportunity_Proposal__c = cs.Opportunity_Proposal__c;
        try{
            update wf;
        }catch(DMLException e){}
        
        cs.Opportunity__c = null;
        try{
            update cs;
        }Catch(DMLException e){}
        
        wf.Opportunity_Description__c = null;
        wf.Opportunity_Number__c = null;
        wf.Opportunity_Name__c = null;
        try{
            update wf;
        }catch(DMLException e){}
        
        /*wf.Case__c = cs1.id
        try{
            update wf;
        }Catch(DMLException e){}*/
        wf.Case__c = cs1.id;
        wf.Opportunity_Description__c = null;
        wf.Opportunity_Proposal__c = null;
        wf.Opportunity_Number__c = null;
        wf.Opportunity_Name__c = null;
        try{
            update wf;
        }catch(DMLException e){}
        test.stopTest();
    }
}