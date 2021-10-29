@isTest(SeeAllData=true)
private class Opportunity_Provideaccess_Test{

 static testmethod void Opportunity_Provideaccess_Test(){


     Test.startTest();   
        Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%honeywell%' limit 1]; 

        Platform__c p = new Platform__c();
        p.Name = 'Test Paltform';
        p.Model__c = '36-16A';
        p.Make__c = 'VARIOUS OEMS';
        insert p;
         
      Opportunity opp = new Opportunity();
      opp.Name = 'Test Method Opportunity';
      opp.SBU__c = 'D&S';
      opp.CBT_Tier_2__c = 'DAA';
      opp.CBT_Team_Tier_3__c = 'CBMS';
      opp.AccountId = acc.Id;
      opp.End_User__c = acc.Id;
      opp.Tech_Sales_Product_Area__c = 'APU';
      opp.Tech_Sales__c = 'Mechanical Systems';
      opp.Prime_Sub__c = 'Prime';
      //opp.opportunity_Type__c = 'Competitive';
      opp.StageName = 'Offer/Negotiate/Close';
      opp.RecordtypeId='01230000000ZIv3';
      opp.CloseDate = System.today();
      opp.Revenue_Type__c = 'ENG';
      opp.Bid_Type_Name__c = 'LTA';
      opp.International_Code__c = 'FMS';
      opp.Incumbent__c = 'Incumbent';
      opp.RMU__c = 'YES';
      opp.Platform__c = p.Id; 
      opp.Active__c = TRUE;
      //opp.Certification_Requirements__c = 'FAR 15 Tina';
     // opp.Proposal_Complexity__c ='Pre-work initiated';
     opp.Ship_Set_Quantity__c = 1;
     opp.Ship_Set_Parts__c ='1234';
     opp.ATR_Aircraft_Quantity__c = 1;
     //opp.Proposal_Complexity_Description__c = 'test';
     opp.RFP_Expected_Date__c =System.today(); 
     opp.Ship_Set_Delivery_Period__c= 'test';
    
 
 
 TriggerInactive.testTrigger = false;
 TriggerInactive.TestCaseCancelled = false;
 TriggerInactive.TestCSMCaseCreation = false;
 TriggerInactive.TestOppRequiredFields = false;
 TriggerInactive.TestOppUpdate_UpdateStage = false;
 TriggerInactive.TestCasValUpdtBasOnOwner = false;
 TriggerInactive.TestATROpp_ContentDeliveries_Automation = false;
 TriggerInactive.TestOpportunityProduct_UpdateTechSales = false;
 TriggerInactive.TestOpportunity_InsertPhases = false;

   insert opp;
     
     opp.Is_Restricted_Opportunity__c  = true;
     opp.Is_Follow_On_Opportunity__c = true;
     //opp.Parent_Opportunity__c = [select id from opportunity WHERE Amount = 0 and Win_Only_Opportunity__c = false limit 1].id; 
     opp.Win_Only_Opportunity__c = true;
     
  // update opp;
 Test.stopTest();
  }
  
   static testmethod void Opportunity_Provideaccess_Test1(){

        
        Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%honeywell%' limit 1]; 

        Platform__c p = new Platform__c();
        p.Name = 'Test Paltform';
        p.Model__c = '36-16A';
        p.Make__c = 'VARIOUS OEMS';
        insert p;
         
      Opportunity opp = new Opportunity();
      opp.Name = 'Test Method Opportunity';
      opp.SBU__c = 'D&S';
      opp.CBT_Tier_2__c = 'DAA';
      opp.CBT_Team_Tier_3__c = 'CBMS';
      opp.AccountId = acc.Id;
      opp.End_User__c = acc.Id;
      opp.Tech_Sales_Product_Area__c = 'APU';
      opp.Tech_Sales__c = 'Mechanical Systems';
      opp.Prime_Sub__c = 'Prime';
      //opp.opportunity_Type__c = 'Competitive';
      opp.StageName = 'Offer/Negotiate/Close';
      opp.RecordtypeId='01230000000ZIv2';
      opp.CloseDate = System.today();
      opp.Revenue_Type__c = 'ENG';
      opp.Bid_Type_Name__c = 'LTA';
      opp.International_Code__c = 'FMS';
      opp.Incumbent__c = 'Incumbent';
      opp.RMU__c = 'YES';
      opp.Platform__c = p.Id; 
      opp.Active__c = TRUE;
      opp.Certification_Requirements__c = 'FAR 15 Tina';
      opp.Proposal_Complexity__c ='Pre-work initiated';
     opp.Ship_Set_Quantity__c = 1;
     opp.Ship_Set_Parts__c ='1234';
     opp.ATR_Aircraft_Quantity__c = 1;
     opp.Proposal_Complexity_Description__c = 'test';
     opp.RFP_Expected_Date__c =System.today(); 
     opp.Ship_Set_Delivery_Period__c= 'test';
     opp.Is_Restricted_Opportunity__c  =true;
 
Test.startTest();
 TriggerInactive.testTrigger = false;
 TriggerInactive.TestCaseCancelled = false;
 TriggerInactive.TestCSMCaseCreation = false;
 TriggerInactive.TestOppRequiredFields = false;
 TriggerInactive.TestOppUpdate_UpdateStage = false;
 TriggerInactive.TestCasValUpdtBasOnOwner = false;
 TriggerInactive.TestATROpp_ContentDeliveries_Automation = false;
 TriggerInactive.TestOpportunityProduct_UpdateTechSales = false;
 TriggerInactive.TestOpportunity_InsertPhases = false;

    
      insert opp;
     opp.Is_Restricted_Opportunity__c  = false;
     update opp;
      
 Test.stopTest();
     
   
  }
  
  static testmethod void Opportunity_Provideaccess_Test2(){

        
        Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%honeywell%' limit 1]; 

        Platform__c p = new Platform__c();
        p.Name = 'Test Paltform';
        p.Model__c = '36-16A';
        p.Make__c = 'VARIOUS OEMS';
        insert p;
         
      Opportunity opp1 = new Opportunity();
      opp1.Name = 'Test Method Opportunity';
      opp1.SBU__c = 'D&S';
      opp1.CBT_Tier_2__c = 'DAA';
      opp1.CBT_Team_Tier_3__c = 'CBMS';
      opp1.AccountId = acc.Id;
      opp1.End_User__c = acc.Id;
      opp1.Tech_Sales_Product_Area__c = 'APU';
      opp1.Tech_Sales__c = 'Mechanical Systems';
      opp1.Prime_Sub__c = 'Prime';
      //opp.opportunity_Type__c = 'Competitive';
      opp1.StageName = 'Offer/Negotiate/Close';
      opp1.RecordtypeId='01230000000ZIv6';
      opp1.CloseDate = System.today();
      opp1.Revenue_Type__c = 'ENG';
      opp1.Bid_Type_Name__c = 'LTA';
      opp1.International_Code__c = 'FMS';
      opp1.Incumbent__c = 'Incumbent';
      opp1.RMU__c = 'YES';
      opp1.Platform__c = p.Id; 
      opp1.Active__c = TRUE;
      opp1.Certification_Requirements__c = 'FAR 15 Tina';
      opp1.Proposal_Complexity__c ='Pre-work initiated';
     opp1.Ship_Set_Quantity__c = 1;
     opp1.Ship_Set_Parts__c ='1234';
     opp1.ATR_Aircraft_Quantity__c = 1;
     opp1.Proposal_Complexity_Description__c = 'test';
     opp1.RFP_Expected_Date__c =System.today(); 
     opp1.Ship_Set_Delivery_Period__c= 'test';
     opp1.Is_Restricted_Opportunity__c = true;
     opp1.Is_Follow_On_Opportunity__c = true;
     //opp1.Parent_Opportunity__c = [select id from opportunity WHERE Amount = 0 and Win_Only_Opportunity__c = false limit 1].id; 
     opp1.Win_Only_Opportunity__c = true;
     opp1.Win_Loss_Amount__c = 10000;
      opp1.Win_Probability__c = 10;
Test.startTest();
 TriggerInactive.testTrigger = false;
 TriggerInactive.TestCaseCancelled = false;
 TriggerInactive.TestCSMCaseCreation = false;
 TriggerInactive.TestOppRequiredFields = false;
 TriggerInactive.TestOppUpdate_UpdateStage = false;
 TriggerInactive.TestCasValUpdtBasOnOwner = false;
 TriggerInactive.TestATROpp_ContentDeliveries_Automation = false;
 TriggerInactive.TestOpportunityProduct_UpdateTechSales = false;
 TriggerInactive.TestOpportunity_InsertPhases = false;

    
      insert opp1;
       opp1.Is_Restricted_Opportunity__c = false;
     opp1.Is_Follow_On_Opportunity__c = true;
     update opp1;
     /*  opp1.Is_Restricted_Opportunity__c = false;
     opp1.Is_Follow_On_Opportunity__c = false;
     update opp1;*/
    Test.stopTest();
  }
 }