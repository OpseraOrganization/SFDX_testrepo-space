trigger UpdateCarryOver_DP on Discretionary_Plan__c (after insert,after update) {
Set<String> Yearset = new Set<String>();
List<Id> OpptyId= new List<Id> ();
List<Discretionary_Plan__c> dp = Trigger.new;

    for(Discretionary_Plan__c DPlan : Trigger.new){
        if(DPlan.Year__c != '' && DPlan.Year__c != null){
        Yearset.add(DPlan.Year__c);    
        OpptyId.add(DPlan.Opportunity__c);   
        }
    }
    
    if(UpdateCarryOverDP.flag == true){
        UpdateCarryOverDP.flag = false;
        UpdateCarryOverDP.updateCarryOver(OpptyId,Yearset,dp);
    }    
       
}