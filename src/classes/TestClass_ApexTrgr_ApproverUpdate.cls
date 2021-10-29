@isTest(SeeAllData=true)
private class TestClass_ApexTrgr_ApproverUpdate{ 

    static testMethod void ApproverUpdateTest()
    {
        Platform__c PLFrec= new Platform__c();
        PLFrec.name='PLF_Test_rec';
        insert PLFrec;
        
        Account acc = new Account();
        acc.name='Acc_Text_rec';
        acc.Type='OEM';
        acc.Strategic_Business_Unit__c='ATR';
        acc.CBT__c='Airbus';
        acc.Customer_Status__c='Active';
        acc.Region_Name__c='Americas';
        acc.Sub_Region_Name__c='Canada';
        acc.Service_Level__c='Standard';
        insert acc;
    
        Workflow_details__c WFrec= new Workflow_details__c();
        WFrec.Wokflow_Name__c='WF_Test_rec';
        WFrec.Approval_Level_in_Progress__c='Draft';
        WFrec.Atlas_or_P_DR__c='Test';
        WFrec.Proposal_Title__c='TM_rec';
        WFrec.Contract_Manager__c='TM_Mngr';
        WFrec.Pricing_Proposal_Type__c='TINA';
        WFrec.Sales_K__c=1;
        WFrec.X5_Year_Revenue_K__c=1;
        WFrec.Terms_and_Conditions__c='Standard';
        WFrec.Front_End_Loss__c=1;
        WFrec.Exposed_Cost__c=1;
        WFrec.Front_End_Loss_Max_Year__c=1;
        WFrec.Exposed_Cost_Max_Year_K__c=1;
        WFrec.Contract_Type__c='Cost Sharing';
        WFrec.Platform__c=PLFrec.id;
        WFrec.Customer_Name__c=acc.id;
        WFrec.Status__c='Draft';
        WFrec.Approval_Level_Required__c='Aero Tier 0';
        WFrec.Approval_Level_in_Progress__c='Aero Tier 0';
        WFRec.Americas__c=True;
        insert WFrec;
        
        Profile pf= [select id from Profile where name = 'System Administrator'];

        User usr = new User(FirstName = 'Test', LastName = 'UserEgreen',Username = 'tu1egreen1@test.com',Email = 'testuser@test.com',
        Alias = 'tu11' ,CommunityNickname= 'tu1cso1' ,TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        insert usr;
        
        User usr2 = new User(FirstName = 'Test', LastName = 'UserEEgreen2',Username = 'tu11egreen2@test.com',Email = 'testuser@test.com',
        Alias = 'tu111' ,CommunityNickname= 'tu1cso3' ,TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        insert usr2;
                
        Approver__c app1 = new Approver__c(Name = 'Test UserEgreen', Approver_Name__c=usr.Id,Terms_and_Conditions__c='Standard'
        ); 
        insert app1;
        
        Approver__c app2 = new Approver__c( Approver_Name__c=usr2.Id, Terms_and_Conditions__c='Standard', Out_of_Office__c = True, 
        Delegate_Name_dummy__c=app1.id, Delegate_Name__c = 'Test UserEgreen', From__c = System.today(), To__c = System.today()+2,
        Delegate_Name1__c=app1.Id, Delegate_Name_Text1__c = 'Test UserEgreen', Out_of_Office1__c = True, Delegation_Valid_From1__c = System.today()+3, Delegation_Valid_To1__c = System.today()+5,
        Delegate_Name2__c=app1.Id, Delegate_Name_Text2__c = 'Test UserEgreen', Out_of_Office2__c = True, Delegation_Valid_From2__c = System.today()+6, Delegation_Valid_To2__c = System.today()+8,
        Delegate_Name3__c=app1.Id, Delegate_Name_Text3__c = 'Test UserEgreen', Out_of_Office3__c = True, Delegation_Valid_From3__c = System.today()+9, Delegation_Valid_To3__c = System.today()+11,
        Delegate_Name4__c=app1.Id, Delegate_Name_Text4__c = 'Test UserEgreen', Out_of_Office4__c = True, Delegation_Valid_From4__c = System.today()+12, Delegation_Valid_To4__c = System.today()+14
        ); 
        insert app2;
        system.debug('asdasdasd : '+app2);
        
        test.starttest();
        WorkFlow_Approval_History__c Wah = new WorkFlow_Approval_History__c(Workflow_details__c = WFrec.id,Tier__c=WFrec.approval_level_in_progress__c, Approval_Status__c = 'Pending Approval', Select_Approver__c = app2.id, Approval_submitted_date__c = system.today()+1
        );
        insert wah;
        
        wah.Approval_submitted_date__c = system.today()+4;
        update wah;
        
        wah.Approval_submitted_date__c = system.today()+7;
        update wah;
        
        wah.Approval_submitted_date__c = system.today()+10;
        update wah;
        
        wah.Approval_submitted_date__c = system.today()+13;
        update wah;
        
        test.stoptest();
        
    }
}