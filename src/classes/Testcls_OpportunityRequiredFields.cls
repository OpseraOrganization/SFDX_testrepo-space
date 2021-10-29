@isTest(SeeAllData=true)
private class Testcls_OpportunityRequiredFields{
  /*  static testMethod void Testcls_ApxTrgr_OpportunityUpdateStageTest(){
    String profileId;
    profileId=Userinfo.getprofileId();
    String profileName = [SELECT Name FROM Profile where Id =: profileId].Name;    
    // Commented and modified the profile name for SR#375409 - Start 
    //if(profileName !='D&S Sales Spiral API User')
    if(profileName !='D&S Sales API Spiral User')
    // Commented and modified the profile name for SR#375409 - End
    {
       Test.startTest();
        Profile p = [select id from profile where name='System Administrator' limit 1];
        User u = new User();
        u.alias = 'standt';
        u.email='harikishore.vutukuri@nttdata.com';
        u.emailencodingkey='UTF-8';
        u.lastname='Testing';
        u.languagelocalekey='en_US';
        u.localesidkey='en_US';
        u.profileid = p.Id;
        u.timezonesidkey='America/Los_Angeles';
        u.CommunityNickname='tcs';
        u.Username='harikishore.vutukuri@nttdata.com.qa1';
insert u;
  
        
        Account acc = new Account();
        acc.Name = 'Honeywell Test';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'D&S';
        acc.CBT__c = 'DAA';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST';
        insert acc;
           
        Platform__c pf = new Platform__c();
        pf.Name = 'Test Paltform';
        pf.Model__c = '36-16A';
        pf.Make__c = 'VARIOUS OEMS';
        insert pf;
 List<Opportunity> opps = new List<Opportunity>();
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Method Opportunity';opp.SBU__c = 'D&S';
        opp.CBT_Tier_2__c = 'DAA';
        opp.CBT_Team_Tier_3__c = 'CBMS';
        opp.AccountId = acc.Id;
        opp.End_User__c = acc.Id;
        opp.Tech_Sales_Product_Area__c = 'APU';
        opp.Tech_Sales__c = 'Mechanical Systems';
        opp.Prime_Sub__c = 'Prime';
        opp.Opportunity_Type__c = 'D&S Complex';
        opp.StageName = 'Cultivate';
        opp.RecordtypeId='01230000000ZIv3';
        opp.CloseDate = System.today();
        opp.Revenue_Type__c = 'ENG';
        opp.Bid_Type_Name__c = 'LTA';
        opp.International_Code__c = 'FMS';
        opp.Incumbent__c = 'Incumbent';
        opp.RMU__c = 'YES';
        opp.Platform__c = pf.Id; 
        opp.Active__c = TRUE;
 opps.add(opp);
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Test Method Opportunity';
        opp1.SBU__c = 'D&S';
        opp1.CBT_Tier_2__c = 'DAA';
        opp1.AccountId = acc.Id;
        opp1.Tech_Sales_Product_Area__c = 'APU';
        opp1.Tech_Sales__c = 'Mechanical Systems';
        opp1.Prime_Sub__c = 'Prime';
        opp1.Opportunity_Type__c = 'D&S Complex';
        opp1.StageName = 'Cultivate';
        opp1.RecordtypeId='01230000000ZIv3';
        opp1.CloseDate = System.today();
        opp1.Revenue_Type__c = 'ENG';
        opp1.Bid_Type_Name__c = 'LTA';
        opp1.International_Code__c = 'FMS';
        opp1.Incumbent__c = 'Incumbent';
        opp1.RMU__c = 'YES';
        opp1.Platform__c = pf.Id;
        opp1.Proposal_Complexity__c = 'CIJ New';
        opp1.Active__c = TRUE;
 opps.add(opp1);
        Opportunity opp2 = new Opportunity();
        opp2.Name = 'Test Method Opportunity';opp2.SBU__c = 'D&S';
        opp2.CBT_Tier_2__c = 'DAA';
        opp2.CBT_Team_Tier_3__c = 'CBMS';
        opp2.AccountId = acc.Id;
        opp2.End_User__c = acc.Id;
        opp2.Tech_Sales_Product_Area__c = 'APU';
        opp2.Tech_Sales__c = 'Mechanical Systems';
        opp2.Prime_Sub__c = 'Prime';
        opp2.opportunity_Type__c = 'D&S Complex';
        opp2.StageName = 'Propose';
        opp.RecordtypeId='01230000000ZIv3';
        opp2.CloseDate = System.today();
        opp2.Revenue_Type__c = 'ENG';
        opp2.Bid_Type_Name__c = 'LTA';
        opp2.International_Code__c = 'FMS';
        opp2.Incumbent__c = 'Incumbent';
        opp2.RMU__c = 'YES';
        opp2.Platform__c = pf.Id; 
        opp2.Ship_Set_Parts__c = 'test';
        opp2.Active__c = TRUE;
 opps.add(opp2);
        Opportunity opp3 = new Opportunity();
        opp3.Name = 'Test Method Opportunity';opp3.SBU__c = 'D&S';
        opp3.CBT_Tier_2__c = 'DAA';
        opp3.CBT_Team_Tier_3__c = 'CBMS';
        opp3.AccountId = acc.Id;
        opp3.End_User__c = acc.Id;
        opp3.Tech_Sales_Product_Area__c = 'APU';
        opp3.Tech_Sales__c = 'Mechanical Systems';
        opp3.Prime_Sub__c = 'Prime';
        opp3.opportunity_Type__c = 'D&S Complex';
        opp3.StageName = 'Propose';
        opp.RecordtypeId='01230000000ZIv3';
        opp3.CloseDate = System.today();
        opp3.Revenue_Type__c = 'ENG';
        opp3.Bid_Type_Name__c = 'LTA';
        opp3.International_Code__c = 'FMS';
        opp3.Incumbent__c = 'Incumbent';
        opp3.RMU__c = 'YES';
        opp3.Platform__c = pf.Id; 
        opp3.Active__c = TRUE;
 opps.add(opp3); 
        Opportunity opp4 = new Opportunity();
        opp4.Name = 'Test Method Opportunity';opp4.SBU__c = 'D&S';
        opp4.CBT_Tier_2__c = 'DAA';
        opp4.CBT_Team_Tier_3__c = 'CBMS';
        opp4.AccountId = acc.Id;
        opp4.End_User__c = acc.Id;
        opp4.Tech_Sales_Product_Area__c = 'APU';
        opp4.Tech_Sales__c = 'Mechanical Systems';
        opp4.Prime_Sub__c = 'Prime';
        opp4.opportunity_Type__c = 'D&S Complex';
        opp4.StageName = 'Offer/Negotiate/Close';
        opp4.RecordtypeId='01230000000ZIv3';
        opp4.CloseDate = System.today();
        opp4.Revenue_Type__c = 'ENG';
        opp4.Bid_Type_Name__c = 'LTA';
        opp4.International_Code__c = 'FMS';
        opp4.Incumbent__c = 'Incumbent';
        opp4.RMU__c = 'YES';
        opp4.Platform__c = pf.Id;
        opp4.Active__c = TRUE;
 opps.add(opp4); 
        Opportunity opp5 = new Opportunity();
        opp5.Name = 'Test Method Opportunity';opp5.SBU__c = 'D&S';
        opp5.CBT_Tier_2__c = 'DAA';
        opp5.CBT_Team_Tier_3__c = 'CBMS';
        opp5.AccountId = acc.Id;
        opp5.End_User__c = acc.Id;
        opp5.Tech_Sales_Product_Area__c = 'APU';
        opp5.Tech_Sales__c = 'Mechanical Systems';
        opp5.Prime_Sub__c = 'Prime';
        opp5.opportunity_Type__c = 'D&S Complex';
        opp5.StageName = 'Offer/Negotiate/Close';
        opp5.RecordtypeId='01230000000ZIv3';
        opp5.CloseDate = System.today();
        opp5.Revenue_Type__c = 'ENG';
        opp5.Bid_Type_Name__c = 'LTA';
        opp5.International_Code__c = 'FMS';
        opp5.Incumbent__c = 'Incumbent';
        opp5.RMU__c = 'YES';
        opp5.Platform__c = pf.Id; 
        opp5.Active__c = TRUE;
 opps.add(opp5); 
 triggerinactive.TestOppUpdate_UpdateStage = false;
 insert opps;
 

        TriggerInactive.TestOppRequiredFields = true;
        opp1.Ship_Set_Quantity__c = 11;
        opp1.RFP_Expected_Date__c = System.today();
        opp1.Certification_Requirements__c = 'Direct Commercial';
        opp1.Proposal_Complexity_Description__c = 'test';
update opp1;

        opp.Certification_Requirements__c = 'FAR 15 TINA';
        opp.Ship_Set_Quantity__c = 11;
        opp.RFP_Expected_Date__c = System.today();
        opp.Proposal_Complexity_Description__c = 'test';
        opp.Ship_Set_Delivery_Period__c = 'test';
        opp.Ship_Set_Parts__c = 'test';
update opp;
      
              
        opp2.Ship_Set_Quantity__c = 11;
        opp2.RFP_Expected_Date__c = System.today();
        opp2.Certification_Requirements__c = 'Direct Commercial';
        opp2.Proposal_Complexity_Description__c = 'test';
        opp2.Proposal_Kickoff_Date__c = System.today();
        opp2.Proposal_Due_Date__c = System.today();
        opp2.RFP_Receipt_Date__c = System.today();
update opp2;


        opp3.Ship_Set_Quantity__c = 11;
        opp3.RFP_Expected_Date__c = System.today();
        opp3.Ship_Set_Delivery_Period__c = 'test';
        opp3.Ship_Set_Parts__c = 'test';
        opp3.Certification_Requirements__c = 'FAR 15 TINA';
        opp3.Proposal_Complexity_Description__c = 'test';
        opp3.Proposal_Kickoff_Date__c = System.today();
        opp3.Proposal_Due_Date__c = System.today();
        opp3.RFP_Receipt_Date__c = System.today();
update opp3;

        opp4.Ship_Set_Quantity__c = 11;
        opp4.RFP_Expected_Date__c = System.today();
        opp4.Certification_Requirements__c = 'Direct Commercial';
        opp4.Proposal_Complexity_Description__c = 'test';
        opp4.Proposal_Kickoff_Date__c = System.today();
        opp4.Proposal_Due_Date__c = System.today();
        opp4.Proposal_Submitted_Date__c = System.today();
        opp4.RFP_Receipt_Date__c = System.today();
update opp4;

        opp5.Proposal_Submitted_Date__c = System.today();
        opp5.RFP_Expected_Date__c = System.today();
        opp5.Proposal_Complexity_Description__c = 'test';
        opp5.Ship_Set_Parts__c = 'test';
        opp5.Ship_Set_Quantity__c = 11;
        opp5.Certification_Requirements__c = 'FAR 15 TINA';
        opp5.Ship_Set_Delivery_Period__c = 'test';
        opp5.Proposal_Due_Date__c = System.today();
        opp5.Proposal_Kickoff_Date__c = System.today();
        opp5.RFP_Receipt_Date__c = System.today();
update opp5;

Test.stopTest();

    }    
        
    }*/
}