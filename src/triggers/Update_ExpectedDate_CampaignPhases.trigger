trigger Update_ExpectedDate_CampaignPhases on Campaign_Gate__c (after update) {
	List<Campaign_Gate__c> Campaign_phases=Trigger.new;
	Map<String,Id> CampaignPhase_map=new Map<String,Id>();
	Map<String,Id> CampaignPhase_map_ad=new Map<String,Id>();
	Map<String,String> CampaignPhase_map1=new Map<String,String>();
	Map<String,String> CampaignPhase_map1_ad=new Map<String,String>();
	Map<String,Date> CampaignPhase_Actualdates=new Map<String,Date>();
	Map<String,Date> CampaignPhase_Actualdates_ad=new Map<String,Date>();
	Map<String,Date> CampaignPhase_Expecteddates=new Map<String,Date>();
	Map<String,Date> CampaignPhase_Expecteddates_ad=new Map<String,Date>();
	List<Campaign> CampaignIds=new List<Campaign>();
	List<Campaign> CampaignIds1=new List<Campaign>();
	Campaign Campaign_Update,Campaign_Update1;
	
	for(Integer i=0;i<Campaign_phases.size();i++){
		if(Trigger.old[i].Expected_Date__c!=Trigger.new[i].Expected_Date__c){
		CampaignPhase_map.put(Campaign_phases[i].Name,Campaign_phases[i].Campaign__c);
		CampaignPhase_map1.put(Campaign_phases[i].Name,Campaign_phases[i].Name);
		CampaignPhase_Actualdates.put(Campaign_phases[i].Name,Campaign_phases[i].Actual_Date__c);
		CampaignPhase_Expecteddates.put(Campaign_phases[i].Name,Campaign_phases[i].Expected_Date__c);
		//CampaignIds.add(Campaign_phases[i].Campaign__c);
	}
	
	if(Trigger.old[i].Actual_Date__c!=Trigger.new[i].Actual_Date__c && Trigger.new[i].Actual_Date__c==NULL){
			System.Debug('Inside Actual Dt');
			CampaignPhase_map_ad.put(Trigger.new[i].Name,Trigger.new[i].Campaign__c);
			CampaignPhase_map1_ad.put(Trigger.new[i].Name,Trigger.new[i].Name);
			CampaignPhase_Actualdates_ad.put(Trigger.new[i].Name,Trigger.new[i].Actual_Date__c);
			CampaignPhase_Expecteddates_ad.put(Trigger.new[i].Name,Trigger.new[i].Expected_Date__c);
		}
	}
	System.Debug('CampaignPhase_map'+CampaignPhase_map);
	System.Debug('CampaignPhase_Actualdates'+CampaignPhase_Actualdates);
	System.Debug('CampaignPhase_map_ad'+CampaignPhase_map_ad);
	System.Debug('CampaignPhase_map1_ad'+CampaignPhase_map1_ad);
	System.Debug('CampaignPhase_Actualdates'+CampaignPhase_Actualdates);
	System.Debug('CampaignPhase_Actualdates_ad'+CampaignPhase_Actualdates_ad);
	
	if(CampaignPhase_map.size()>0){
		for(Campaign Campaigns:[Select Id,Next_Phase__c,Next_Phase_Date__c from Campaign where Id IN:CampaignPhase_map.values()]){
			System.Debug('Campaign'+Campaigns);
			if(Campaigns.Next_Phase__c == CampaignPhase_map1.get(Campaigns.Next_Phase__c)){
				System.Debug('Campaign.Next_Phase__c'+Campaigns.Next_Phase__c+'***'+CampaignPhase_map.get(Campaigns.Next_Phase__c));
				if(CampaignPhase_Actualdates.get(Campaigns.Next_Phase__c)== NULL){
					System.Debug('Update Campaign'+CampaignPhase_Expecteddates.get(Campaigns.Next_Phase__c));	
					Campaign_Update = new Campaign(ID=CampaignPhase_map.get(Campaigns.Next_Phase__c));
					Campaign_Update.Next_Phase_Date__c=	CampaignPhase_Expecteddates.get(Campaigns.Next_Phase__c);
					CampaignIds.add(Campaign_Update);		
				}
			}
		}
	}
	if(CampaignPhase_map_ad.size()>0){
		for(Campaign Campaign1:[Select Id,Next_Phase__c,Next_Phase_Date__c from Campaign where Id IN:CampaignPhase_map_ad.values()]){
			System.Debug('Campaign1'+Campaign1);
			if(Campaign1.Next_Phase__c != CampaignPhase_map1_ad.get(Campaign1.Next_Phase__c)){
				System.Debug('Campaign.Next_Phase__c'+Campaign1.Next_Phase__c+'***'+CampaignPhase_map_ad.get(Campaign1.Next_Phase__c));
				
				if(CampaignPhase_Actualdates_ad.get(CampaignPhase_map1_ad.get(Campaign1.Next_Phase__c))==NULL){
					Campaign_Update1 = new Campaign(ID=CampaignPhase_map_ad.get(Trigger.new[0].Name));
					Campaign_Update1.Next_Phase_Date__c=CampaignPhase_Expecteddates_ad.get(Trigger.new[0].Name);
					Campaign_Update1.Next_Phase__c=CampaignPhase_map1_ad.get(Trigger.new[0].Name);
					CampaignIds1.add(Campaign_Update1);	
				}
			}
		}
	}
	System.Debug('CampaignIds'+CampaignIds);
	System.Debug('CampaignIds1'+CampaignIds1);
	if(CampaignIds.size()>0){
		try{
			Update CampaignIds;
		}
		catch(Exception e){
			System.Debug('Exception'+e);
		}
	}
	if(CampaignIds1.size()>0){
		try{
			Update CampaignIds1;
		}
		catch(Exception e){
			System.Debug('Exception'+e);
		}
	}
}