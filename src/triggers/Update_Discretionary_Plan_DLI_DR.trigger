trigger Update_Discretionary_Plan_DLI_DR on Discretionary__c (after insert, after update) {
public static boolean recursive=true;
Set<ID> OpptyId = new Set<ID>();
List<String> Fyear = new List<String>();
List<Discretionary_Plan__c> DPrec = new List<Discretionary_Plan__c>();
List<Discretionary_Plan__c> DP = new List<Discretionary_Plan__c>();
Set<String> Yearset = new Set<String>();
List<Discretionary__c> DRnew = new List<Discretionary__c>();
List<Id> lstId = new List<Id>();
List<String> lstYear = new List<String>();
List<Id> lstIdnew = new List<Id>();
List<String> lstYearnew = new List<String>();
     
     for(Discretionary__c DR : Trigger.new){
     if(Trigger.isUpdate){
        If(dr.opportunity__c!=null&&((System.Trigger.OldMap.get(DR.id).Total_Spent_Amount__c != System.Trigger.NewMap.get(DR.id).Total_Spent_Amount__c) || (System.Trigger.OldMap.get(DR.id).Total_Approved_Amount__c != System.Trigger.NewMap.get(DR.id).Total_Approved_Amount__c) ||
        (System.Trigger.OldMap.get(DR.id).Total_Request_Amount_rollup__c != System.Trigger.NewMap.get(DR.id).Total_Request_Amount_rollup__c))){
           OpptyId.add(DR.opportunity__c);
           Yearset.add(DR.Fiscal_Year__c);
           lstId.addAll(OpptyId);
           lstYear.addAll(Yearset);
        }
      }  
      if(Trigger.isInsert && dr.opportunity__c!=null){
          OpptyId.add(DR.opportunity__c);
          Yearset.add(DR.Fiscal_Year__c);
          lstId.addAll(OpptyId);
          lstYear.addAll(Yearset);
      }
      
      }   
     //System.debug('lstId1 : '+lstId +'lstYear : '+lstYear);
     /*
     List<Discretionary_Spend__c> ds = [SELECT Year__c, Discretionary_Line_Item__r.Discretionary_Request__r.Opportunity__c FROM Discretionary_Spend__c where Discretionary_Line_Item__r.Discretionary_Request__r.Opportunity__c in : OpptyId and Year__c not in : Fyear];
     System.debug('ds1 : '+ds);
     if(ds.size() > 0){
         for(Discretionary_Spend__c dsc : ds){
             Fyear.add(dsc.Year__c);
             OpptyId.add(dsc.Discretionary_Line_Item__r.Discretionary_Request__r.Opportunity__c);
             lstId.addAll(OpptyId);
             lstYear.addAll(Fyear); 
         }
     }
     */
     //System.debug('lstId2 : '+lstId +'lstYear : '+lstYear);
    try{ 
         DPrec = [Select ID, Year__c,opportunity__c from Discretionary_Plan__c where Year__c in : Yearset and opportunity__c in :OpptyId limit 80];
    } 
   catch(Exception e){}
    if(DPrec.size()>0){
        for(Discretionary_Plan__c dpc : DPrec){
            OpptyId.remove(dpc.opportunity__c); 
            Yearset.remove(dpc.Year__c);   
        }
        lstIdnew.addAll(OpptyId);
        lstYearnew.addAll(Yearset);
        try {
            Update DPrec;
        }catch(Exception ex){}
    }else if (OpptyId!=null){
        lstIdnew.addAll(OpptyId);
        lstYearnew.addAll(Yearset);
    } 
    
    if(lstIdnew.size()>0 && lstYearnew.size()>0){
        List<Discretionary_Plan__c> DPrec1 = new List<Discretionary_Plan__c>();
        for(Integer k=0;k<lstIdnew.size();k++){
            Discretionary_Plan__c dpc = new Discretionary_Plan__c();
            dpc.opportunity__c = lstIdnew[k];
            dpc.Year__c = lstYearnew[k];
            DPrec1.add(dpc);
        }
        if(DPrec1.size()>0){
            try {
                insert DPrec1;
            }catch(Exception exc){}
        }
        try {    
            
            DP = [Select Id, Carry_Over__c, Year__c, Opportunity__c,DLI_Spent__c, DR_Funded__c from Discretionary_plan__c where Opportunity__c in :lstId order by Year__c ];
        }
        catch(Exception e){
        }
        
        //Boolean flag = false;
        try {  
        for(Discretionary__c dptot : Trigger.new){
           for(integer i=0;i<DP.size()-1;i++){
           //System.debug('Y1 : '+DP[i].Year__c + ' Y2 : '+DP[i+1].Year__c + ' Spent : ' +DP[i].DLI_Spent__c);
             if(DP[i].Opportunity__c == dptot.Opportunity__c && DP[i].Year__c < DP[i+1].Year__c && DP[i].DLI_Spent__c != 0){
                 //flag = true;
                 DP[i+1].Carry_Over__c = true;
             }else{
                 //flag = false;
                 DP[i+1].Carry_Over__c = false;
             }
             /*
             if(flag == true){
               DP[i+1].Carry_Over__c = true;
             }else{
               DP[i+1].Carry_Over__c = false;
             }*/
           }
           
        }
        if(DP.size()>0){ 
            update DP;
        }
        }catch(Exception ex){}     
        }
}