trigger Update_Discretionary_Plan_Spend on Discretionary_Spend__c (after insert, after update) {
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
     
     for(Discretionary_Spend__c DR : Trigger.new){
     //System.debug('opp111 : '+DR.OppId__c);
     
     if(Trigger.isUpdate){
        If(DR.OppId__c != null && ((System.Trigger.OldMap.get(DR.id).Weekly_Actuals__c != System.Trigger.NewMap.get(DR.id).Weekly_Actuals__c) || 
        (System.Trigger.OldMap.get(DR.id).Year__c != System.Trigger.NewMap.get(DR.id).Year__c))){
           OpptyId.add(DR.OppId__c);
           Yearset.add(DR.Year__c);
           lstId.addAll(OpptyId);
           lstYear.addAll(Yearset);
        }
      }  
      if(Trigger.isInsert){
      If(DR.OppId__c != null){
          OpptyId.add(DR.OppId__c);
          Yearset.add(DR.Year__c);
          lstId.addAll(OpptyId);
          lstYear.addAll(Yearset);
          }
      }
      
      }
      System.debug('oppId : '+OpptyId+ ' Spend Year : ' +Yearset);   
      System.debug('oppId : '+lstId + ' Spend Year : ' +lstYear);
    try{  
    if   (OpptyId.size()>0){
    DPrec = [Select ID, Year__c,opportunity__c from Discretionary_Plan__c where Year__c in : Yearset
    and opportunity__c in :OpptyId ];
    }
    //System.debug('DPrec : '+DPrec);
    }
     
   catch(Exception e){}
    if(DPrec.size()>0){
        //System.debug('in If loop');
        for(Discretionary_Plan__c dpc : DPrec){
            OpptyId.remove(dpc.opportunity__c); 
            Yearset.remove(dpc.Year__c);   
        }
        lstIdnew.addAll(OpptyId);
        lstYearnew.addAll(Yearset);
        try{
            Update DPrec;
        }catch(Exception ex){}
    }else{
        lstIdnew.addAll(OpptyId);
        lstYearnew.addAll(Yearset);
    } 
    System.debug('oppId3 : '+lstIdnew+ ' Spend Year3 : ' +lstYearnew);   
    if(lstIdnew.size() > 0 && lstYearnew.size()>0){
        //System.debug('in else loop'); 
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
            }catch(Exception ex){}
        }
    }
}