@isTest(SeeAllData=true)
private class UpdateCarryOver_DPTest {
    static testMethod void UpdateCarryOverDisPlanTest(){
        
        Set<String> Yearset = new Set<String>();
        List<Id> OpptyId= new List<Id> ();
        List<Discretionary__c> DR1 = new List<Discretionary__c>();
        List<Discretionary_Plan__c> DP1 = new List<Discretionary_Plan__c>();
        List<Discretionary_Plan__c> DP4 = new List<Discretionary_Plan__c>();

        /*Account acc = new Account();
        acc.Name = 'Honeywell Test';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'D&S';
        acc.CBT__c = 'DAA';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST';
        
        insert acc;*/
        Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%honeywell%' limit 1]; 
        date testdate = date.parse('03/27/2011');
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Method Opportunity';
        //opp.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'Focus'].Id;
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
        opp.Active__c = FALSE;
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
        
        List<Opportunity> oppList = new List<Opportunity>();
        oppList.add(opp);
 
        
        Discretionary_Plan__c dp = new Discretionary_Plan__c();
        dp.Year__c = '2012';
        dp.Opportunity__c = opp.Id;
        dp.DLI_Spent__c = 100.50;
        dp.DR_Funded__c = 200;
        dp.DR_Requested__c = 300;
        insert dp;
        
        DP4.add(dp);
        
        Discretionary_Plan__c dp2 = new Discretionary_Plan__c();
        dp2.Year__c = '2013';
        dp2.Opportunity__c = opp.Id;
        dp2.DLI_Spent__c = 200.50;
        dp2.DR_Funded__c = 1200;
        dp2.DR_Requested__c = 1400;
        insert dp2;
        
        DP4.add(dp2);
        
        for(Discretionary_Plan__c DPlan : DP4){
            if(DPlan.Year__c != '' && DPlan.Year__c != null){
            Yearset.add(DPlan.Year__c);    
            OpptyId.add(DPlan.Opportunity__c);   
            }
        }
        
        if(UpdateCarryOverDP.flag == true){
            UpdateCarryOverDP.flag = false;
            UpdateCarryOverDP.updateCarryOver(OpptyId,Yearset,DP4);
        }    
    }
}