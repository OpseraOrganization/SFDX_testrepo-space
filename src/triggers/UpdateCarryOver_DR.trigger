trigger UpdateCarryOver_DR on Discretionary__c (after insert, after update) {
Set<String> Yearset = new Set<String>();
List<Id> OpptyId= new List<Id> ();
List<Discretionary__c> DR = new List<Discretionary__c>();
List<Discretionary_Plan__c> DP = new List<Discretionary_Plan__c>();


    for(Discretionary__c DPlan : Trigger.new){
        if(DPlan.Fiscal_Year__c != '' || DPlan.Fiscal_Year__c != null){
        Yearset.add(DPlan.Fiscal_Year__c);    
        OpptyId.add(DPlan.Opportunity__c);   
        }
    }

    try{
        if(OpptyId.size()>0){
            DP = [Select Id, Carry_Over__c, Year__c, Opportunity__c,DLI_Spent__c, DR_Funded__c from Discretionary_plan__c where Opportunity__c in :OpptyId order by Year__c,Opportunity__c];
        }
    }
    catch(Exception e){
    } 
    
    //Boolean flag = false;  
    for(Discretionary__c dptot : Trigger.new){
       for(integer i=0;i<DP.size()-1;i++){
         if(DP[i].Opportunity__c == dptot.Opportunity__c && DP[i].Year__c < DP[i+1].Year__c && DP[i].DLI_Spent__c != 0){
             //flag = true;
             DP[i+1].Carry_Over__c = true;
         }else {
             //flag = false;
             DP[i+1].Carry_Over__c = false;
         }
       }
       
    }
    if(DP.size() > 0){ 
        try {
        update DP; 
        }catch(Exception ex){}
    } 
}