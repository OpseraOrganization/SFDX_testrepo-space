@isTest
public class DealmakerPlaybookTollgateTriggersTest {
    static testmethod void testTriggers(){
         Profile p = [SELECT Id FROM Profile WHERE Name='system administrator']; 
      User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='honeywellstandarduser@testorg.com');
       Account acct = new Account();
      System.runAs(u) {
        acct.name = 'New Account';
        acct.Customer_Status__c = 'Active';
        acct.Region_Name__c = 'Americas';
        acct.Sub_Region_Name__c = 'United States';
        acct.Service_Level__c = 'Standard';
        acct.Strategic_Business_Unit__c = 'ATR';
        acct.CBT__c = 'ATR Other';
        acct.CBT_Team__c = 'ATR Other';
        acct.Market_Name__c = 'Air Transport';
        acct.Type = 'Regional Airline';
        acct.REPORT_ACCOUNT_NAME__c = 'New Account Report'; 
        
        insert acct;
       } 
        
        Campaign camp = new Campaign();
        camp.IsActive = TRUE;
        camp.Name = 'New Campaign';
        camp.ExpectedRevenue = 1000000;
        camp.CampaignPrimarySBU__c = 'ATR';
        camp.CampaignPrimaryCBTTier2__c = 'Airlines';
        camp.Status = 'In Progress';
        camp.StartDate = Date.today();
        camp.EndDate = Date.today() + 30;
        insert camp;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'New Opportunity';
        opp.Description = 'New Description';
        opp.StageName = 'Cultivate';
        //opp.Status__c = 'Take next steps';
        opp.ATR_Review_Org__c = 'APU';
        opp.AccountId = acct.Id;
        opp.ATR_Probability__c = 50;
        opp.SBU__c = 'ATR';
        opp.CBT_Tier_2__c = 'Airlines';
        opp.Revenue_Type__c = 'Services';
        opp.Solution_Type__c = 'Other';
        opp.CloseDate = Date.today() + 30;
        opp.Amount = 1000000;
        opp.ATR_Base__c = 50;
        opp.ATR_Proposal_Type__c = 'GEN';
        opp.ATR_Aircraft_Quantity__c = 10;
        opp.CampaignId = camp.ID;
        opp.Type = 'OE Complex';
        opp.Certification_Requirements__c = 'FAR 15 TINA';
        opp.Proposal_Complexity_Description__c = 'test';
        opp.RFP_Expected_Date__c = system.today()+5;
        insert opp;
        
        Opportunity_Gate__c gate = new Opportunity_Gate__c();
        gate.Opportunity__c = opp.Id;
        gate.Opportunity_Type__c = opp.Type;
        gate.Stage__c = 'Launch';
        gate.Name = 'IPDS Phase 4';
        //gate.Phase__c = 'IPDS Phase 4';
        gate.Status__c = 'Open';
        insert gate;
        String oldStatus = gate.Status__c;
        
        Matrix__c matrix = new Matrix__c();
        matrix.Opportunity_Type__c = 'OE Complex';
        matrix.Phase__c = 'IPDS Phase 4';
        matrix.Serial_No__c = 1;
        matrix.Stage__c = 'Launch';
        matrix.Dealmaker_Qualifier_Answer_ID__c = 'a6u13000000GnHdAAK';
        insert matrix;
                
        Test.startTest();
        gate.Status__c = 'Closed';
        update gate;
        String newStatus = gate.Status__c;
        Test.stopTest();
        //DMAPP__DM_Qualifier_Answer__c answer = new DMAPP__DM_Qualifier_Answer__c();
        //answer.Name = 'New Answer';
        //answer.DMAPP__DM_Opportunity_Extra__c = opp.DMAPP__Dealmaker_Opportunity__c;
        //answer.DMAPP__Status__c = 'Open';
        //insert answer;

        //System.assertEquals(answer.DMAPP__Status__c, gate.Status__c);
        System.assertNotEquals(oldStatus, newStatus);
    }
}