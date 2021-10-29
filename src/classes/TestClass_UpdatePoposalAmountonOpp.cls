@isTest(SeeAllData=true)
private class TestClass_UpdatePoposalAmountonOpp{
    static testMethod void TestMthd_UpdatePoposalAmountonOpp(){
       User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where alias = 'sadmin' and isactive = true order by createddate asc limit 1];
        //User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];
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
         
        Plant_Code_Master__c pcm = new Plant_Code_Master__c();
        pcm.Postal_Code__c = 'Test';
        pcm.Plant_Name__c = 'Test1';
        pcm.Public_Plant_Name__c = 'Test2';
        pcm.City__c = 'Bangalore';
        pcm.Country_Code__c = 'IN';
        pcm.SAP_Plant_Code__c = '123Test';
        insert pcm;
        
        Platform__c pf = [select id,Name from Platform__c where Name Like '%Test%' limit 1];
        Opportunity opp = [select id,Name,Opp_Update__c,Win_Loss_Proposal_Amount__c,Win_Loss_Amount__c,Parent_Opportunity__c,Total_Win_Loss_Proposal_Amount__c,Total_Win_Loss_Amount__c from Opportunity where Name Like '%Boeing%' limit 1];
        Opportunity_Proposal__c oppPr = new Opportunity_Proposal__c();
        oppPr.Opportunity__c = opp.id;
        oppPr.Request_Type__c = 'RFP / RFQ';
        oppPr.Proposal_Status__c = 'Cost Update';
        oppPr.Total_Contract_Value_BAFO__c  = 200;
        oppPr.Pricing_Analyst__c = usr.id;
        oppPr.Pricing_Manager__c = usr.id;
        oppPr.Site__c = pcm.id;
        insert oppPr;
        
        Opportunity oppchild1 = new Opportunity();
        oppchild1.Parent_Opportunity__c = opp.id;
        oppchild1.Name = 'OppChild';
        oppchild1.AccountId = acc.id;
        oppchild1.End_User__c = acc.id;
        oppchild1.SBU__c = 'Intercompany';
        oppchild1.CBT_Tier_2__c = 'IAI';
        oppchild1.StageName = 'Prospecting';
        oppchild1.CloseDate = system.today();
        oppchild1.Win_Loss_Amount__c = 300;
        oppchild1.Prime_Sub__c = 'None';
        oppchild1.Contract_Type__c = 'BPA';
        oppchild1.Revenue_Type__c = 'ENG';
        oppchild1.Bid_Type_Name__c = 'Competetive';
        oppchild1.International_Code__c = 'Domestic';
        oppchild1.Incumbent__c = 'Incumbent';
        oppchild1.RMU__c = 'Yes';
        oppchild1.Platform__c = pf.id;
        oppchild1.Total_Win_Loss_Amount__c = 0;
        oppchild1.Total_Win_Loss_Proposal_Amount__c = 0;
        insert oppchild1;
        
        Opportunity_Proposal__c oppPrchild = new Opportunity_Proposal__c();
        oppPrchild.Opportunity__c = oppchild1.id;
        oppPrchild.Request_Type__c = 'RFP / RFQ';
        oppPrchild.Proposal_Status__c = 'Cost Update';
        oppPrchild.Total_Contract_Value_BAFO__c  = 500;
        oppPrchild.Pricing_Analyst__c = usr.id;
        oppPrchild.Pricing_Manager__c = usr.id;
        oppPrchild.Site__c = pcm.id;
        insert oppPrchild;
        
        test.StartTest();
        OppUpdate.opportunityfieldupdate(opp.id);
        opp.Win_Loss_Proposal_Amount__c = oppPr.Total_Contract_Value_BAFO__c;
        opp.Opp_Update__c = true;
        try{
            update opp;
        }catch(DMLException e){}
        oppchild1.Win_Loss_Proposal_Amount__c = oppPrchild.Total_Contract_Value_BAFO__c;
        try{
            update oppchild1;
        }catch(DMLException e1){}
        opp.Total_Win_Loss_Proposal_Amount__c = oppchild1.Win_Loss_Proposal_Amount__c + opp.Win_Loss_Proposal_Amount__c;
        opp.Total_Win_Loss_Amount__c = oppchild1.Win_Loss_Amount__c + opp.Win_Loss_Amount__c;
        try{
            update opp;
        }catch(DMLException e2){}
        test.stopTest();
    }
}