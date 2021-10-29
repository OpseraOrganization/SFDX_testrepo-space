@isTest(SeeAllData=true)
private class TestClass_Apextgr_SendAttachmentbyMail{
    static testMethod void TestMthd_SendAttachmentbyMail(){
        User usr =[select id,Name,Email,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive = true limit 1];
        Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%HONEYWELL%' limit 1];
        
        Contact objContact = new Contact();
        objContact.LastName = 'hari13';
        objContact.FirstName = 'vnv123';
        objContact.AccountId = acc.Id;
        objContact.Primary_Email_Address__c = 'hari2355@test.com';
        objContact.Email='hari2355@test.com';
        objContact.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
        objContact.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;     
        insert objContact;
         
        Platform__c pf = new Platform__c();
        pf.Model__c = 'Test1';
        pf.Make__c = 'Test2';
        pf.Platform_Type__c = 'Airplane';
        insert pf;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'TestOpp61614';
        opp.SBU__c = 'Intercompany';
        opp.CBT_Tier_2__c = 'Business Development';
        opp.StageName = 'Offer/Negotiate/Close';
        opp.AccountId = acc.id;
        opp.End_User__c = acc.id;
        opp.Prime_Sub__c = 'None';
        opp.Contract_Type__c = 'BPA';
        opp.Revenue_Type__c = 'ENG';
        opp.Bid_Type_Name__c = 'Competitive';
        opp.International_Code__c = 'Domestic';
        opp.Incumbent__c = 'Incumbent';
        opp.RMU__c = 'Yes';
        opp.CloseDate = Date.Today()+10;
        opp.Platform__c = pf.id;
        insert opp;
        
        Opportunity_Sales_Team__c ot = new Opportunity_Sales_Team__c();
        ot.User__c = usr.id;
        ot.Opportunity_Team_Role__c = 'Vol. Lead Tech.';
        try{
        insert ot;
        }catch(Exception e){}
        
        Opportunity_Gate__c og = new Opportunity_Gate__c();
        og.Opportunity_Type__c = 'D&S PrePriced';
        og.Stage__c = 'Offer/Negotiate/Close';
        og.Phase__c = 'Award Notification';
        og.Opportunity__c = opp.id;
        insert og;
        
        Attachment attachment = new Attachment();  
        attachment.ParentId = og.Id;  
        attachment.Name = 'Test Attachment for Parent';  
        attachment.Body = Blob.valueOf('Test Data');
        test.startTest();
        insert attachment;  
        test.stopTest();
        
        Opportunity_Gate_Approval_History__c ogah = new Opportunity_Gate_Approval_History__c();
        ogah.Approval_Status__c = 'Pending';
        ogah.Opportunity_Gate__c = og.id;
        ogah.Approver__c = usr.Email;
        ogah.Approver_Name__c = usr.Name;
        ogah.Email__c = usr.Email;
        insert ogah;
        
        Opportunity_Gate__c og1 = new Opportunity_Gate__c();
        og1.Opportunity_Type__c = 'AM Complex';
        og1.Stage__c = 'Propose';
        og1.Phase__c = 'Finalize Proposals';
        og1.Opportunity__c = opp.id;
        insert og1;
        
        Opportunity_Gate_Approval_History__c ogah1 = new Opportunity_Gate_Approval_History__c();
        ogah1.Approval_Status__c = 'Pending';
        ogah1.Opportunity_Gate__c = og1.id;
        ogah1.Approver__c = usr.Email;
        ogah1.Approver_Name__c = usr.Name;
        ogah1.Email__c = usr.Email;
        insert ogah1;
    }
}