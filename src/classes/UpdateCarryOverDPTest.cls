@isTest(SeeAllData=true)
private class UpdateCarryOverDPTest {
    static testMethod void UpdateCarryOverDPTest(){
        
        Set<String> Yearset = new Set<String>();
        List<Id> OpptyId= new List<Id> ();
        List<Discretionary__c> DR1 = new List<Discretionary__c>();
        List<Discretionary_Plan__c> DP1 = new List<Discretionary_Plan__c>();
        List<Discretionary_Plan__c> DP4 = new List<Discretionary_Plan__c>();
        /*
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
        */
        /*account acc = [select id from account where Customer_Status__c = 'Active' and Strategic_Business_Unit__c = 'D&S'
                    and CBT__c = 'DAA' and Type = 'OEM' limit 1];*/
        Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%honeywell%' limit 1];             
        date testdate = date.parse('03/27/2011');
        
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
        
        Discretionary__c dr = new Discretionary__c();
        dr.Fiscal_Year__c = '2012';
        dr.Opportunity__c = opp.Id;
        dr.M_PM_Funded_VOC_Project__c = 'NO';
        dr.Estimated_Completion_Date__c = testdate;
        dr.SBU__c = 'D&S';
        dr.CBT__c = 'DAA';
        dr.CBT_Team__c = 'CBMS';
        dr.Type__c = 'Demo';
      
        
        //insert dr;
        DR1.add(dr);
        
        Discretionary__c dr2 = new Discretionary__c();
        dr2.Fiscal_Year__c = '2013';
        dr2.Opportunity__c = opp.Id;
        dr2.M_PM_Funded_VOC_Project__c = 'NO';
        dr2.Estimated_Completion_Date__c = testdate;
        dr2.SBU__c = 'D&S';
        dr2.CBT__c = 'DAA';
        dr2.CBT_Team__c = 'CBMS';
        dr2.Type__c = 'Demo';
       
        
        DR1.add(dr2);
        
        Discretionary__c dr3 = new Discretionary__c();
        dr3.Fiscal_Year__c = '2017';
        dr3.Opportunity__c = opp.Id;
        dr3.M_PM_Funded_VOC_Project__c = 'NO';
        dr3.Estimated_Completion_Date__c = testdate;
        dr3.SBU__c = 'D&S';
        dr3.CBT__c = 'DAA';
        dr3.CBT_Team__c = 'CBMS';
        dr3.Type__c = 'Demo';
        
      
        
        DR1.add(dr3);
        Test.StartTest(); 
        insert DR1;     
        Test.stopTest();
        
        Discretionary_Plan__c dp = new Discretionary_Plan__c();
        dp.Year__c = '2016';
        dp.Opportunity__c = opp.Id;
        dp.DLI_Spent__c = 100.50;
        dp.DR_Funded__c = 200;
        dp.DR_Requested__c = 300;
        insert dp;
        
        DP4.add(dp);
        
        Discretionary_Plan__c dp2 = new Discretionary_Plan__c();
        dp2.Year__c = '2017';
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
        
        UpdateCarryOverDP.updateCarryOver(OpptyId,Yearset,DP4);
        /*
        try {    
            DP1 = [Select Id, Carry_Over__c, Year__c, Opportunity__c,DLI_Spent__c, DR_Funded__c from Discretionary_plan__c where Opportunity__c in :OpptyId order by Year__c];
        }
        catch(Exception e){}
        
        Date dt=Date.Today();
        String year = String.valueOf(dt.year());
    
        Boolean flg = false;  
        for(integer i=0;i<DP1.size()-1;i++){
         if( DP1[i].Year__c < DP1[i+1].Year__c && DP1[i].DLI_Spent__c != 0){
             flg = true;
         }else {
             flg = false;
         }
         if(flg == true){
           DP1[i+1].Carry_Over__c = true;
       }else{
           DP1[i+1].Carry_Over__c = false;
       }
       }

      if(DP1.size()>0){  
        try {
            update DP1;
        }catch(Exception ex){} 
      }
      */   
    }
}