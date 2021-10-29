trigger Update_ExpectedDate_OpportunityPhases on Opportunity_Gate__c (after update) {
    List<Opportunity_Gate__c> Opp_phases=Trigger.new;
    Map<String,Id> OppPhase_map=new Map<String,Id>();
    Map<String,Id> OppPhase_map_ad=new Map<String,Id>();
    Map<String,String> OppPhase_map1=new Map<String,String>();
    Map<String,String> OppPhase_map1_ad=new Map<String,String>();
    Map<String,Date> OppPhase_Actualdates=new Map<String,Date>();
    Map<String,Date> OppPhase_Actualdates_ad=new Map<String,Date>();
    Map<String,Date> OppPhase_Expecteddates=new Map<String,Date>();
    Map<String,Date> OppPhase_Expecteddates_ad=new Map<String,Date>();        
    Map<String,String> OppPhase_Stage_ad=new Map<String,String>();//Added for Certido Ticket #349340
     triggerinactive.TestOppRequiredFields=false;//Inactivate OpportunityRequiredFieldsTrigger Certido Ticket # 347890
    List<Opportunity> OppIds=new List<Opportunity>();
    List<Opportunity> OppIds1=new List<Opportunity>();
    Opportunity Opp_Update;
    Opportunity Opp_Update1;
    for(Integer i=0;i<Opp_phases.size();i++){
        if(Trigger.old[i].Completion_Date__c!=Trigger.new[i].Completion_Date__c){
            oppPhase_map.put(Opp_phases[i].Name,Opp_phases[i].Opportunity__c);
            oppPhase_map1.put(Opp_phases[i].Name,Opp_phases[i].Name);
            OppPhase_Actualdates.put(Opp_phases[i].Name,Opp_phases[i].Actual_Date__c);
            OppPhase_Expecteddates.put(Opp_phases[i].Name,Opp_phases[i].Completion_Date__c);
            //OppIds.add(Opp_phases[i].Opportunity__c);
        }
        
        if(Trigger.old[i].Actual_Date__c!=Trigger.new[i].Actual_Date__c && Trigger.new[i].Actual_Date__c==NULL){
            oppPhase_map_ad.put(Trigger.new[i].Name,Trigger.new[i].Opportunity__c);
            oppPhase_map1_ad.put(Trigger.new[i].Name,Trigger.new[i].Name);
            OppPhase_Actualdates_ad.put(Trigger.new[i].Name,Trigger.new[i].Actual_Date__c);
            OppPhase_Expecteddates_ad.put(Trigger.new[i].Name,Trigger.new[i].Completion_Date__c);            
            OppPhase_Stage_ad.put(Trigger.new[i].Name,Trigger.new[i].Stage__c);//Added for Certido Ticket #349340
        }
    }
    if(oppPhase_map.size()>0){  
        for(Opportunity opp:[Select Id,Next_Phase__c,Next_Phase_Date__c from Opportunity where Id IN:oppPhase_map.values()]){
            if(opp.Next_Phase__c == OppPhase_map1.get(opp.Next_Phase__c)){
            
                if(OppPhase_Actualdates.get(opp.Next_Phase__c)== NULL){
                    Opp_Update = new Opportunity(ID=OppPhase_map.get(opp.Next_Phase__c));
                    Opp_Update.Next_Phase_Date__c=  OppPhase_Expecteddates.get(opp.Next_Phase__c);
                    OppIds.add(Opp_Update);     
                }
            }
        }
    }
    if(oppPhase_map_ad.size()>0){
        for(Opportunity opp1:[Select Id,Next_Phase__c,Next_Phase_Date__c,StageName,IsClosed from Opportunity where Id IN:oppPhase_map_ad.values()]){
            if(opp1.Next_Phase__c != OppPhase_map1_ad.get(opp1.Next_Phase__c)){
                
                if(OppPhase_Actualdates_ad.get(OppPhase_map1_ad.get(opp1.Next_Phase__c))==NULL){
                    Opp_Update1 = new Opportunity(ID=OppPhase_map_ad.get(Trigger.new[0].Name));
                    Opp_Update1.Next_Phase_Date__c= OppPhase_Expecteddates_ad.get(Trigger.new[0].Name);
                    Opp_Update1.Next_Phase__c=OppPhase_map1_ad.get(Trigger.new[0].Name); 
                    if(opp1.IsClosed!=true)// added for SR# 385376
                     Opp_Update1.StageName=OppPhase_Stage_ad.get(Trigger.new[0].Name);//Added for Certido Ticket #349340
                    OppIds1.add(Opp_Update1);   
                }
            }
        }
    }
    if(OppIds.size()>0){
        try{
      
            Update OppIds;
        }
        catch(Exception e){
            System.Debug('Exception'+e);
        }
    }
    if(OppIds1.size()>0){
        try{
       
            Update OppIds1;
        }
        catch(Exception e){
            System.Debug('Exception'+e);
        }
    }
}