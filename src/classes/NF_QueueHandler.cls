public without sharing abstract  class NF_QueueHandler {

	private static final String QUEUE = 'Queue';
	public String queueException = '';
	
	public void notifyQueueMembers(String queueId, Id oppId){
		set<Id> queueMembers = getQueueMembers(new set<String>{queueId});
		if(!queueMembers.isEmpty()){
			sendEmail(queueMembers, oppId); 
		}
	}
	
	private NF_G3FacilitatorQueueMatrix__c getFacilitatorSetting(sObject sobjectRec){
		Opportunity myOpp = (Opportunity)sobjectRec;
		List<NF_G3FacilitatorQueueMatrix__c> facilitatorSettings = new List<NF_G3FacilitatorQueueMatrix__c>();
		
		if(myOpp.Org_L4__c == GlobalConstants.MARKET_LATIN_AMERICA) {
			facilitatorSettings = [SELECT Id, Queue_Developer_Name__c FROM NF_G3FacilitatorQueueMatrix__c WHERE Lead_BG__c = :myOpp.Lead_BG__c AND Lead_BU__c = :myOpp.Lead_BU__c AND Organisation_Level_4__c = :myOpp.Org_L4__c ];
		} else {
			facilitatorSettings =[SELECT Id, Queue_Developer_Name__c FROM NF_G3FacilitatorQueueMatrix__c WHERE Lead_BG__c = :myOpp.Lead_BG__c AND Lead_BU__c = :myOpp.Lead_BU__c AND Organisation_Level_5__c = :myOpp.Org_L5__c ];
		}
		if(!facilitatorSettings.isEmpty()){
			return facilitatorSettings[0];
		}
		return null;
	}
	
	public Group getQueue(sObject sobjectRec){
		NF_G3FacilitatorQueueMatrix__c facilitatorSetting = getFacilitatorSetting(sobjectRec);
		Group queueLoc = null;
		try{
			if(facilitatorSetting != null){
	queueLoc = [Select Id, Name from Group where type= :QUEUE and Name= :facilitatorSetting.Queue_Developer_Name__c];
			}
		}catch(QueryException e){
			queueLoc = null;
			system.debug('##Query Exception : '+e.getMessage());
		}
		return queueLoc;
	}
	public set<Id> getQueueMembers(set<String> queueIds){
		set<Id> memebersIds = new set<Id>();
		for(GroupMember members : [Select UserOrGroupId From GroupMember where GroupId in :queueIds]){
			memebersIds.add(members.UserOrGroupId);
		}
		return memebersIds;
	}
	
	@TestVisible private void sendEmail(set<Id> recipients, ID recordId) {
		//New instance of a single email message
		try{
			EmailTemplate template = [Select Id from EmailTemplate where developername = :GlobalConstants.FACILITATOR_EMAIL_TEMPLATE];
			// Who you are sending the email to
			List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
			for(Id recipient : recipients){
	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	mail.setTargetObjectId(recipient);
	mail.setWhatId(recordId);
	mail.setTemplateId(template.Id);
	mail.setSaveAsActivity(false);
	mails.add(mail);
			}
			Messaging.sendEmail(mails); 
			
		}catch(QueryException e){
			system.debug('###Exception Email Template Not Found : '+e.getMessage());
			queueException += 'Email not delivered correctly.';
		}
		
	}
	
	public Group searchForQueue (Opportunity opp){
		
		list<NF_G3FacilitatorQueueMatrix__c> facilitatorSetting = new list<NF_G3FacilitatorQueueMatrix__c>(); 
		String leadBG = '\'' + opp.Lead_BG__c + '\'';
		String leadBU = opp.Lead_BU__c == null ? null : '\'' + opp.Lead_BU__c + + '\'';
		String orgL4 = '\'' + opp.Org_L4__c + '\'';
		String orgL5 = opp.Org_L5__c == null ? null : '\'' + opp.Org_L5__c + + '\'';
		String UnweightedVal = 'NULL';
		String typeRequest = 'NULL';
		
		string query = 'SELECT Id , Queue_Developer_Name__c FROM NF_G3FacilitatorQueueMatrix__c WHERE '+ 'Lead_BG__c ='+ leadBG +' AND Organisation_Level_4__c = ' + orgL4; 
		
		if(GlobalConstants.BG_NI.equalsIgnoreCase(opp.Lead_BG__c)){
			query += ' AND Lead_BU__c = ' + leadBU;
		}
		
		if(opp.Amount < Decimal.valueOf(System.Label.Total_Net_Sales_Value_EUR_Threshold)){
			UnweightedVal = '\'' + GlobalConstants.BELOW5M + '\'' ;
		}	   
		else if(opp.Amount >= Decimal.valueOf(System.Label.Total_Net_Sales_Value_EUR_Threshold)){
			UnweightedVal = '\'' + GlobalConstants.ABOVEOREQUAL5M + '\'' ;
		}		
		query += ' AND Unweighted_Value__c = ' + UnweightedVal ;
		
		if(!(GlobalConstants.BG_NI.equalsIgnoreCase(opp.Lead_BG__c) && opp.Amount < Decimal.valueOf(System.Label.Total_Net_Sales_Value_EUR_Threshold) 
			 && opp.Type_of_Request__c != GlobalConstants.TYPE_REQUEST_RFP_RFI)){
		   query += ' AND Organisation_Level_5__c = ' + orgL5;
		}
		
		if(opp.Amount < Decimal.valueOf(System.Label.Total_Net_Sales_Value_EUR_Threshold) && opp.Type_of_Request__c == GlobalConstants.TYPE_REQUEST_RFP_RFI ){
			typeRequest = '\'' + GlobalConstants.TYPE_REQUEST_RFP_RFI + '\'';
		}
		query += ' AND Type_of_Request__c = ' + typeRequest; 
			
		System.debug(query);	
		facilitatorSetting = database.query(query);
		Group queueLoc = null;
		try{
			if(facilitatorSetting.IsEmpty() == false){
				queueLoc = [Select Id, Name from Group where type= :QUEUE and Name = :facilitatorSetting[0].Queue_Developer_Name__c limit 1];
			}else{
				queueLoc = [Select Id, Name from Group where type= :QUEUE and Name = :Label.NF_Default_Queue limit 1];
			}
		}catch(exception e){
			system.debug('###Exception Email Template Not Found : '+e.getMessage());
		}
		return queueLoc;
	}
	
	/** Code block for SF Ticket#: 01693085: NFS: G3 Faciltator queues**/					 
	public Group searchNFSForQueue (Opportunity opp){
		list<NF_G3FacilitatorQueueMatrix__c> facilitatorSetting = new list<NF_G3FacilitatorQueueMatrix__c>(); 
		String leadBG = '\'' + opp.Lead_BG__c + '\'';
		String leadBU = opp.Lead_BU__c == null ? null : '\'' + opp.Lead_BU__c + + '\'';
		String orgL4 = '\'' + opp.Org_L4__c + '\'';
		String orgL5 = opp.Org_L5__c == null ? null : '\'' + opp.Org_L5__c + + '\'';
		String unWeightedVal = 'NULL';
		String typeRequest = 'NULL';	


		String query = 'SELECT Id , Queue_Developer_Name__c FROM NF_G3FacilitatorQueueMatrix__c WHERE '+ 'Lead_BG__c ='+ leadBG +' AND Organisation_Level_4__c = ' + orgL4;	 

		if(opp.Amount < Decimal.valueOf(System.Label.Total_Net_Sales_Value_EUR_Threshold)){
			unWeightedVal = '\'' + GlobalConstants.BELOW5M + '\'' ;
		}else if(opp.Amount >= Decimal.valueOf(System.Label.Total_Net_Sales_Value_EUR_Threshold)){
			unWeightedVal = '\'' + GlobalConstants.ABOVEOREQUAL5M + '\'' ;
		}
				

		if(opp.Amount >= Decimal.valueOf(System.Label.Total_Net_Sales_Value_EUR_Threshold)){
			query += ' AND Unweighted_Value__c = ' + unWeightedVal ;

		}else if(opp.Amount < Decimal.valueOf(System.Label.Total_Net_Sales_Value_EUR_Threshold) && opp.Type_of_Request__c == GlobalConstants.TYPE_REQUEST_RFP_RFI ){
			typeRequest = '\'' + GlobalConstants.TYPE_REQUEST_RFP_RFI + '\'';
			query += ' AND Type_of_Request__c = ' + typeRequest;
		}else if((GlobalConstants.BG_NI.equalsIgnoreCase(opp.Lead_BG__c) && (GlobalConstants.BU_NI_FN.equalsIgnoreCase(opp.Lead_BU__c) || GlobalConstants.BU_NI_IPRTG.equalsIgnoreCase(opp.Lead_BU__c) || GlobalConstants.BU_NI_OPTICS.equalsIgnoreCase(opp.Lead_BU__c))) && opp.Amount < Decimal.valueOf(System.Label.Total_Net_Sales_Value_EUR_Threshold) && opp.Type_of_Request__c != GlobalConstants.TYPE_REQUEST_RFP_RFI){
			query += ' AND Lead_BU__c = ' + leadBU;
		}else if(opp.Amount < Decimal.valueOf(System.Label.Total_Net_Sales_Value_EUR_Threshold) && opp.Type_of_Request__c != GlobalConstants.TYPE_REQUEST_RFP_RFI && (GlobalConstants.BG_CNS.equalsIgnoreCase(opp.Lead_BG__c) || GlobalConstants.LEAD_BG_MN.equalsIgnoreCase(opp.Lead_BG__c))){
			typeRequest = '\'' + GlobalConstants.TYPE_REQUEST_RFP_RFI + '\'';
			query += ' AND Unweighted_Value__c = ' + unWeightedVal ;
			query += ' AND Type_of_Request__c != ' + typeRequest;
		}

		System.debug('>>>query>>> '+query);

		facilitatorSetting = database.query(query);
		Group queueLoc = null;

		try{
			if(facilitatorSetting.IsEmpty() == false){
				queueLoc = [Select Id, Name from Group where type= :QUEUE and DeveloperName = :facilitatorSetting[0].Queue_Developer_Name__c limit 1];
			}
		}catch(exception e){
			system.debug('###Exception Email Template Not Found : '+e.getMessage());
		}
		return queueLoc;
	}
}