@isTest(SeeAllData=true)
private class UpdateCarryOver_DRTest {
    static testMethod void UpdateCarryOverTest(){
        
        Set<String> Yearset = new Set<String>();
        List<Id> OpptyId= new List<Id> ();
        List<Discretionary__c> DR1 = new List<Discretionary__c>();
        List<Discretionary_Plan__c> DP1 = new List<Discretionary_Plan__c>();
        List<Discretionary_Plan__c> DP4 = new List<Discretionary_Plan__c>();

        date testdate = System.Today();        
        Id oppId = [Select Id, Account.Customer_Status__c from Opportunity where Account.Customer_Status__c='Active' limit 1].Id;
        
        Discretionary__c dr = new Discretionary__c();
        dr.Fiscal_Year__c = '2012';
        dr.Opportunity__c = oppId;
        dr.M_PM_Funded_VOC_Project__c = 'NO';
        dr.Estimated_Completion_Date__c = testdate;
        dr.SBU__c = 'D&S';
        dr.CBT__c = 'DAA';
        dr.CBT_Team__c = 'CBMS';
        dr.Type__c = 'Demo';
        
        insert dr;
        DR1.add(dr);
        
        Discretionary__c dr2 = new Discretionary__c();
        dr2.Fiscal_Year__c = '2012';
        dr2.Opportunity__c = oppId;
        dr2.M_PM_Funded_VOC_Project__c = 'NO';
        dr2.Estimated_Completion_Date__c = testdate;
        dr2.SBU__c = 'D&S';
        dr2.CBT__c = 'DAA';
        dr2.CBT_Team__c = 'CBMS';
        dr2.Type__c = 'Demo';
        
        //insert dr2;
        
        DR1.add(dr2);
        /**
        Discretionary_Plan__c dp = new Discretionary_Plan__c();
        dp.Year__c = '2012';
        dp.Opportunity__c = oppId;
        dp.DLI_Spent__c = 100.50;
        dp.DR_Funded__c = 200;
        dp.DR_Requested__c = 300;
        insert dp;
        
        DP4.add(dp);
        
        Discretionary_Plan__c dp2 = new Discretionary_Plan__c();
        dp2.Year__c = '2012';
        dp2.Opportunity__c = oppId;
        dp2.DLI_Spent__c = 200.50;
        dp2.DR_Funded__c = 1200;
        dp2.DR_Requested__c = 1400;
        insert dp2;
        
        DP4.add(dp2);
        **/
        for(Discretionary__c DPlan : DR1){
            if(DPlan.Fiscal_Year__c != '' && DPlan.Fiscal_Year__c != null){
            Yearset.add(DPlan.Fiscal_Year__c);    
            OpptyId.add(DPlan.Opportunity__c);   
            }
        }
        
        try {    
            DP1 = [Select Id, Carry_Over__c, Year__c, Opportunity__c,DLI_Spent__c, DR_Funded__c from Discretionary_plan__c where Opportunity__c = :oppId order by Year__c];
        }catch(Exception e){}
        
        Boolean flag = false;  
        for(Discretionary__c dptot : DR1){
           for(integer i=0;i<DP1.size()-1;i++){
             if(DP1[i].Opportunity__c == dptot.Opportunity__c && DP1[i].Year__c < DP1[i+1].Year__c && DP1[i].DLI_Spent__c != 0){
                 flag = true;
             }else {
                 flag = false;
             }
             if(flag == true){
               DP1[i+1].Carry_Over__c = true;
           }else{
               DP1[i+1].Carry_Over__c = false;
           }
           }
           
        }
        if(DP1.size() > 0){ 
            try {
            update DP1; 
            }catch(Exception ex){}
        } 
    }
}