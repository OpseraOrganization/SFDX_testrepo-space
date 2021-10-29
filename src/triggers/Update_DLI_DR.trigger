trigger Update_DLI_DR on Discretionary_Plan__c (Before Insert,before update) {
public static boolean recursive=true;
Set<String> Yearset = new Set<String>();
List<Id> OpptyId= new List<Id> ();
List<Id> SpendOpptyId= new List<Id> ();
List<Discretionary__c> DR = new List<Discretionary__c>();
List<Discretionary_Spend__c> DS = new List<Discretionary_Spend__c>();

for(Discretionary_Plan__c DPlan : Trigger.new){
    if(DPlan.Year__c != '' && DPlan.Year__c != null){
    Yearset.add(DPlan.Year__c);    
    OpptyId.add(DPlan.Opportunity__c);   
    }
}
//getting all DR associated to fiscal year    
    try{
        DR = [Select ID, Fiscal_Year__c, Total_Spent_Amount__c, Total_Request_Amount_rollup__c,Opportunity__c, Total_Approved_Amount__c from Discretionary__c where Fiscal_Year__c in : Yearset  and Opportunity__c in :OpptyId];
    }
    catch(Exception e){
    }
     
      
    try{
        DS = [SELECT Discretionary_Line_Item__r.Discretionary_Request__r.Opportunity__c,Year__c, Weekly_Actuals__c FROM Discretionary_Spend__c where Year__c in : Yearset and Discretionary_Line_Item__r.Discretionary_Request__r.Opportunity__c in : OpptyId];
        System.debug('Spend : '+DS.size());
    }
    catch(Exception e){
    }  
      
    for(Discretionary_Plan__c dptot : Trigger.new){
      decimal DLISpent=0;
      decimal DRfunded=0;
      decimal DRRequested=0;
     try{
       for(integer i=0;i<DR.size();i++){
         if(DR[i].Opportunity__c==dptot.Opportunity__c && DR[i].Fiscal_Year__c==dptot.Year__c){
         DRfunded=DRfunded+  DR[i].Total_Approved_Amount__c;
         DRRequested=DRRequested+  DR[i].Total_Request_Amount_rollup__c;
         //DRfunded=DRfunded+  DR[i].Total_Request_Amount_rollup__c;
         //DLISpent=DLISpent+  DR[i].Total_Spent_Amount__c;
         }
         
       }
        //dptot.DLI_Spent__c=DLISpent;
        dptot.DR_Funded__c=DRfunded;
        dptot.DR_Requested__c=DRRequested;
       
       
       for(integer k=0;k<DS.size();k++){
         if(DS[k].Discretionary_Line_Item__r.Discretionary_Request__r.Opportunity__c==dptot.Opportunity__c && DS[k].Year__c==dptot.Year__c){
             DLISpent=DLISpent+  DS[k].Weekly_Actuals__c;
         } 
       }
       
       dptot.DLI_Spent__c=DLISpent; 
       }catch(Exception ex){}
       
    }   
}