@isTest(SeeAllData=true)
private class DeliveryContent_Creation_Test{
 static testmethod void DeliveryContent_Creation_Test(){
 
 test.starttest();
 Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%honeywell%' limit 1]; 

        Platform__c p = new Platform__c();
        p.Name = 'Test Paltform';
        p.Model__c = '36-16A';
        p.Make__c = 'VARIOUS OEMS';
        p.SAP_External_System__c=True;
        insert p;
 
  Opportunity opp5 = new Opportunity();
      opp5.Name = 'Test Method Opportunity';
      opp5.SBU__c = 'ATR';
      opp5.CBT_Tier_2__c = 'DAA';
      opp5.CBT_Team_Tier_3__c = 'CBMS';
      opp5.AccountId = acc.Id;
      opp5.End_User__c = acc.Id;
      opp5.Tech_Sales_Product_Area__c = 'APU';
      opp5.Tech_Sales__c = 'Mechanical Systems';
      opp5.Prime_Sub__c = 'Prime';
      opp5.opportunity_Type__c = 'D&S Complex';
      opp5.StageName = 'Offer/Negotiate/Close';
      opp5.RecordtypeId=label.D_S_Complex;
      opp5.CloseDate = System.today();
      opp5.Revenue_Type__c = 'ENG';
      opp5.Bid_Type_Name__c = 'LTA';
      opp5.International_Code__c = 'FMS';
      opp5.Incumbent__c = 'Incumbent';
      opp5.RMU__c = 'YES';
      opp5.Platform__c = p.Id; 
      opp5.Active__c = TRUE;
      opp5.Certification_Requirements__c = 'FAR 15 Tina';
      opp5.Proposal_Complexity__c ='Pre-work initiated';
     
     insert opp5;
 
    Opportunity_Platform__c oppplt = new Opportunity_Platform__c();
    oppplt.Opportunity__c = opp5.id;
    oppplt.Platform__c = p.id;
    
    insert oppplt;
    
    test.stoptest();
    
    }
}