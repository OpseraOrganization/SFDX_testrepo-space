public abstract  class NF_QueueHandler {
	private static final String QUEUE = 'Queue';
	public String queueException = '';

	public void notifyQueueMembers(String queueId, Id oppId){
		set<Id> queueMembers = getQueueMembers(new set<String>{queueId});
		if(!queueMembers.isEmpty()){
			sendEmail(queueMembers, oppId); 
		}
	}

	private NF_FacilitatorCustomQueue__mdt getFacilitatorSetting(sObject sobjectRec){
		Opportunity myOpp = (Opportunity)sobjectRec;
		List<NF_FacilitatorCustomQueue__mdt> facilitatorSettings = new List<NF_FacilitatorCustomQueue__mdt>();
		
		if(myOpp.Org_L4__c == GlobalConstants.MARKET_LATIN_AMERICA) {
			facilitatorSettings = [SELECT DeveloperName,Queue_Developer_Name__c,Lead_BG__c,Lead_BU__c, Market__c FROM NF_FacilitatorCustomQueue__mdt WHERE Lead_BG__c = :myOpp.Lead_BG__c AND Lead_BU__c = :myOpp.Lead_BU__c AND Market__c = :myOpp.Org_L4__c ];
		} else {
	 facilitatorSettings =[SELECT DeveloperName,Queue_Developer_Name__c,Lead_BG__c,Lead_BU__c, Market__c FROM NF_FacilitatorCustomQueue__mdt WHERE Lead_BG__c = :myOpp.Lead_BG__c AND Lead_BU__c = :myOpp.Lead_BU__c AND Organisation_Level_5__c = :myOpp.Org_L5__c ];
		}
		if(!facilitatorSettings.isEmpty()){
			return facilitatorSettings[0];
		}
		return null;
	}

	public Group getQueue(sObject sobjectRec){
		NF_FacilitatorCustomQueue__mdt facilitatorSetting = getFacilitatorSetting(sobjectRec);
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
		
		list<NF_FacilitatorCustomQueue__mdt> facilitatorSetting = new list<NF_FacilitatorCustomQueue__mdt>(); 
		String leadBG = '\'' + opp.Lead_BG__c + '\'';
		String leadBU = opp.Lead_BU__c == null ? 'NULL' : '\'' + opp.Lead_BU__c + + '\'';
		String orgL4 = '\'' + opp.Org_L4__c + '\'';
		String orgL5 = '\'' + opp.Org_L5__c + '\'';
		String expectedLoALevel = '\'' + opp.Expected_LoA_Approval_Level__c + '\'';
		String typeRequest = 'NULL';
		
		string query = 'SELECT Id , DeveloperName,Queue_Developer_Name__c FROM NF_FacilitatorCustomQueue__mdt WHERE '+
			'Lead_BG__c ='+ leadBG + ' AND Lead_BU__c =' + leadBU +' AND Market__c = ' + orgL4 + ' AND Expected_LoA_Level__c = ' + expectedLoALevel;

		if(  opp.Org_L4__c != GlobalConstants.MARKET_NORTH_AMERICA || 
		   ( (GlobalConstants.Lead_BG_NSW == opp.Lead_BG__c || GlobalConstants.LEAD_BG_MN == opp.Lead_BG__c || GlobalConstants.LEAD_BG_GS == opp.Lead_BG__c ) && opp.Type_of_Request__c != GlobalConstants.TYPE_REQUEST_RFP_RFI && (GlobalConstants.LOA_LEVEL_E.equalsIgnoreCase(opp.Expected_LoA_Approval_Level__c) || GlobalConstants.LOA_BYPASS_LEVEL.equalsIgnoreCase(opp.Expected_LoA_Approval_Level__c))) ){
				query += ' AND Organisation_Level_5__c = ' + orgL5 ;
		}
		if( (GlobalConstants.LOA_LEVEL_E.equalsIgnoreCase(opp.Expected_LoA_Approval_Level__c) || GlobalConstants.LOA_BYPASS_LEVEL.equalsIgnoreCase(opp.Expected_LoA_Approval_Level__c)) && opp.Type_of_Request__c == GlobalConstants.TYPE_REQUEST_RFP_RFI){
			typeRequest = '\'' + GlobalConstants.TYPE_REQUEST_RFP_RFI + '\'' ;
		} 
		query += ' AND Type_of_Request__c = ' + typeRequest ;
		
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
}