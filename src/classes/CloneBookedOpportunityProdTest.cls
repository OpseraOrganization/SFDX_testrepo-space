@isTest(SeeAllData=true)
private class CloneBookedOpportunityProdTest {
    static testMethod void CloneBookedOpportunityProdTest(){
      Test.startTest();  
        date testdate = date.parse('03/27/2011');
        
        Platform__c p = new Platform__c();
        p.Name = 'Test Paltform';
        p.Model__c = '36-16A';
        p.Make__c = 'VARIOUS OEMS';
        p.SAP_External_System__c=True;
        
        insert p;
         
        Id accId = [Select Id from Account where Customer_Status__c = 'Active' limit 1].Id;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Method Opportunity';
        //opp.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'Focus'].Id;
        opp.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name like '%D&S PrePriced' limit 1].Id;
        opp.SBU__c = 'D&S';
        opp.CBT_Tier_2__c = 'DAA';
        opp.CBT_Team_Tier_3__c = 'CBMS';
        opp.AccountId = accId;
        opp.End_User__c = accId ;
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
        //opp.Is_Restricted_Opportunity__c = TRUE;
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
        //opp.Program_Terms__c = '3';
        //opp.Type = 'Catalog';
        //opp.Amount = 100;
        opp.IC_Scorecard_Opportunity__c = false;
        insert opp;
        
        List<Opportunity> oppList = new List<Opportunity>();
        oppList.add(opp);
        
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.UnitPrice = 100;
        oli.Quantity = 2;
        oli.pricebookentryid = [Select Id from PricebookEntry where IsActive=TRUE limit 1].Id;
        oli.OpportunityId = opp.Id;
        oli.Type__c = 'Booked';
        
        
        insert oli;
        
        OpportunityLineItem oli1 = [Select UnitPrice, Quantity, Type__c from OpportunityLineItem where Id =: oli.Id];
        oli1.UnitPrice = 150;
        oli1.Quantity = 3;
        TriggerInactive.TestOpportunityProduct_UpdateTechSales = false;
        update oli1;
        
        List<OpportunityLineItem> lstopp = new List<OpportunityLineItem>();
        lstopp.add(oli1);
        
        String profileId;
        profileId=Userinfo.getprofileId();
        profileid=profileId.substring(0,15);
        String pName = [SELECT Name FROM Profile where Id  =: profileid].Name;
        System.debug('Profile Name : '+pName );
        for(Integer i=0;i<lstopp.size();i++){
            if(lstopp[i].Type__c == 'Booked' && pName == 'D&S Sales'){
                lstopp[i].Type__c = 'Forecast';
            }
        }
        TriggerInactive.TestOpportunityProduct_UpdateTechSales = false;
        update lstopp;
        
        Test.stopTest();
        
    }
}