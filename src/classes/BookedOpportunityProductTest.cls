@isTest(SeeAllData=true)
private class BookedOpportunityProductTest {
    static testMethod void BookedOpportunityProductTest(){
       Test.StartTest(); 
       /* Account acc = new Account();
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
        */
        Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%honeywell%' limit 1];
        
        
        date testdate = date.parse('03/27/2011');
        
       // Platform__c p=[select id,Name,Model__c,Make__c from Platform__c where Name like '%DSPC%' Limit 1];
        
         Platform__c p = new Platform__c();
        p.Name = 'Test Platform1';
        p.Model__c = '36-16A';
        p.Make__c = 'VARIOUS OEMS';
        p.SAP_External_System__c=True;
        insert p;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Method Opportunity'; 
        
        
        //opp.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'Catalog' limit 1].Id;        
        opp.RecordTypeId = label.D_S_PrePriced;        
        opp.SBU__c = 'D&S';
        opp.CBT_Tier_2__c = 'DAA';
        opp.CBT_Team_Tier_3__c = 'CBMS';
        opp.AccountId = acc.Id;
        opp.End_User__c = acc.Id;
        opp.Tech_Sales_Product_Area__c = 'APU';
        opp.Tech_Sales__c = 'Mechanical Systems';
        opp.Prime_Sub__c = 'Prime';
        opp.Opportunity_Type__c = 'D&S PrePriced';
        opp.StageName = 'Offer/Negotiate/Close';
        opp.CloseDate = testdate;
        opp.Revenue_Type__c = 'ENG';
        opp.Bid_Type_Name__c = 'LTA';
        opp.International_Code__c = 'FMS';
        opp.Incumbent__c = 'Incumbent';
        opp.RMU__c = 'YES';
        opp.Platform__c = p.Id;       
        opp.Active__c = TRUE;
        opp.Proposal_Submitted_Date__c = System.today();
        opp.RFP_Expected_Date__c = System.today();
        opp.Proposal_Complexity_Description__c = 'test';
        opp.Ship_Set_Parts__c = 'test';
        opp.Ship_Set_Quantity__c = 11;
        opp.Certification_Requirements__c = 'FAR 15 TINA';
        opp.Ship_Set_Delivery_Period__c = 'test';
        opp.Proposal_Due_Date__c = System.today();
        opp.Proposal_Kickoff_Date__c = System.today();
        opp.ATR_Aircraft_Quantity__c = 1;
        insert opp;
        
        //Opportunity opp=[select id,name,SBU__c,CBT_Tier_2__c,AccountId,End_User__c,Tech_Sales_Product_Area__c,Prime_Sub__c,Opportunity_Type__c,StageName,CloseDate,Revenue_Type__c,Bid_Type_Name__c,International_Code__c,Incumbent__c,
          //               RMU__c,Platform__c,Active__c,Proposal_Submitted_Date__c,RFP_Expected_Date__c,Proposal_Complexity_Description__c,];
        
        List<Opportunity> oppList = new List<Opportunity>();
        oppList.add(opp);
        
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.UnitPrice = 100;
        oli.Quantity = 2;
        oli.pricebookentryid = [Select Id from PricebookEntry where IsActive=TRUE limit 1].Id;
        oli.OpportunityId = opp.Id;
        oli.Type__c = 'Booked';
        oli.Solution_Type__c ='RMU';
        oli.Revenue_Type__c = 'License';
        
        insert oli;
        
        OpportunityLineItem oli1 = [Select UnitPrice, Quantity, Type__c from OpportunityLineItem where Id =: oli.Id];
        oli1.UnitPrice = 150;
        oli1.Quantity = 3;        
        update oli1;
        
        
        if(oli.Type__c == 'Booked' && opp.Active__c == false && opp.SBU__c == 'D&S'){
            oppList.get(0).addError('Opportunity having booked product can not be set as InActive.');             
        }
        Test.stopTest(); 
        
        
    }
}