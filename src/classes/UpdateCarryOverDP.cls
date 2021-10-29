global class UpdateCarryOverDP {
    
    public static boolean flag = true; 
    public static void updateCarryOver(List<Id> opptyId, Set<String> Yearset, List<Discretionary_Plan__c> dp ){
    List<Discretionary_Plan__c> DR = new List<Discretionary_Plan__c>();   
    try{
        DR = [Select Id, Carry_Over__c, Year__c, Opportunity__c,DLI_Spent__c,DR_Funded__c from Discretionary_plan__c where Opportunity__c in :opptyId order by Year__c,Opportunity__c ];
    }
    catch(Exception e){
    }
    
    //Boolean flg = false;  
    //for(Integer k=0; k<dp.size();k++){
       for(integer i=0;i<DR.size()-1;i++){
       //System.debug('Year1 : '+DR[i].Year__c + ' Year2 : '+year);
       //DR[i].Opportunity__c == dp[k].Opportunity__c &&
         if( DR[i].Year__c < DR[i+1].Year__c && DR[i].DLI_Spent__c != 0){
             //flg = true;
             DR[i+1].Carry_Over__c = true;
         }else {
             //flg = false;
             DR[i+1].Carry_Over__c = false;
         }
         /*
         if(flg == true){
           DR[i+1].Carry_Over__c = true;
           //dptot.Carry_Over__c = true;
         }else{
           DR[i+1].Carry_Over__c = false;
           //dptot.Carry_Over__c = false;
         }*/
       }
       
    //}
      if(DR.size()>0){  
        try {
            update DR;
        }catch(Exception ex){} 
      }     
    } 
}