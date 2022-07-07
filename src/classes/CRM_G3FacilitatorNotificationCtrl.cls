public with sharing class CRM_G3FacilitatorNotificationCtrl {

	@Testvisible public static FacilitatorWrapper info;
	@Testvisible private static Map<Integer, String> roleCodesMap = new Map<Integer,String>{
		7 => 'NSNG_OQM',
		6 => 'NSNE_OQM',
		5 => 'NSND_OQM',
		4 => 'NSNC_OQM'
	};
	@Testvisible private static Map<Integer, String> orgLevelsMap = new Map<Integer,String>{
		7 => 'Org_L7__c',
		6 => 'Org_L6__c',
		5 => 'Org_L5__c',
		4 => 'Org_L4__c'
	};
	@Testvisible private static final String Market_North_America='Market North America';
	@Testvisible private static final String Market_Latin_America='Market Latin America';
	@Testvisible private static final String Market_NFS = 'Market NFS';

	@AuraEnabled
	public static FacilitatorWrapper initAction(Id opportunityId){
		info = new FacilitatorWrapper();
		Opportunity oppty = getOpportunity(opportunityId);
		verifyOpportunity(oppty);
		if( info.errorMessage != null ) return info;
		if( accManagerAsG3Fac(oppty) ) return info;
		findFacilitator(oppty);
		System.debug(info);
		return info;
	}

	@AuraEnabled
	public static FacilitatorWrapper recalculateFacilitator(Opportunity editedOppty, List<String> editedFields){
		info = new FacilitatorWrapper();
		Opportunity oppty = getOpportunity(editedOppty.Id);
		for(String editedField : editedFields){
			oppty.put(editedField, editedOppty.get(editedField));
		}
		findFacilitator(oppty);
		return info;
	}

	@AuraEnabled
	public static String updateOppty( Id opptyId, String opptyFields){
		try{
			Opportunity oppty = (Opportunity) System.JSON.deserialize(opptyFields, Opportunity.class);
			oppty.Id = opptyId;
			System.debug(oppty);
			update oppty;
			if(oppty.Queue_Id__c != null){
	notifyQueueMembers(oppty.Queue_Id__c,opptyId);
			}
			return 'SUCCESS';
		} catch(DMLException  e){
			System.debug('Issue on updateOppty ' + e.getMessage());
			return e.getDmlMessage(0);
		} catch(Exception e){
			System.debug('Issue on updateOppty ' + e.getMessage());
			return e.getMessage();
		}
	}

	//INI - ft358
	@AuraEnabled
	public static Id getOfferId(Id opportunityId){
		Id offerId = [Select Id FROM Offer__c
					 WHERE Opportunity__c =: opportunityId
					 AND ActiveOffer__c = True
					 LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()].Id;
		return offerId;
	}
	//ENd - ft358

	/**
*   @description : Get the opportunity details
*/
	private static Opportunity getOpportunity(Id opportunityId){
		return [SELECT Id,SWx_Upsell_Proposal__c,StageName,Gate_3_Bypass_no_offer_support__c,G4_Planned_Date__c,OIF_Lines__c,NF_Facilitator_Notified__c,
		Org_L4__c, Org_L5__c, Org_L6__c, Org_L7__c, Lead_BG__c, Lead_BU__c, Unweighted_Amount_EUR__c, Type_Of_Request__c, isMultiBG__c,
		(SELECT Id, TeamMemberRole, User.Id, User.Name FROM OpportunityTeamMembers where TeamMemberRole = :CSWXGlobalConstant.AM limit 1)
		FROM Opportunity WHERE Id =:opportunityId];
	}

	/**
*   @description : Verify if the opportunity is ready to proceed for G3 Facilitator Notification
*/
	private static void verifyOpportunity(Opportunity oppty){
		if(!oppty.StageName.equalsIgnoreCase(GlobalConstants.DEVELOP_OPPORTUNITY)){
			info.errorMessage = String.format(Label.NF_OnlyFacilitatorCanBeNotified,new String[] {GlobalConstants.DEVELOP_OPPORTUNITY});
			return;
		}
		if( oppty.Gate_3_Bypass_no_offer_support__c ) {
			info.errorMessage = GlobalConstants.G3_FACILITATOR_BYPASS ;
			return;
		}
		if( oppty.G4_Planned_Date__c == NULL ){
			info.errorMessage = Label.NF_G4_PlannedDate_Error;
			return;
		}
		if(oppty.OIF_Lines__c==0 ){
			info.errorMessage = GlobalConstants.MANDATORY_OIF_FOR_APPROVAL;
			return;
		}
		if(oppty.NF_Facilitator_Notified__c){
			info.errorMessage =  Label.NF_Facilitator_already_notified ;
			return;
		}
	}

	/**
*   @description : Select AM as facilitator if the oppty has Digital Proposal
*/
	private static Boolean accManagerAsG3Fac(Opportunity oppty){
		if(oppty.SWx_Upsell_Proposal__c != null && oppty.OpportunityTeamMembers.size() > 0){
			info.facilitator = new UserInfoWrapper(oppty.OpportunityTeamMembers[0].User.Id,oppty.OpportunityTeamMembers[0].User.Name);
			return true;
		}
		return false;
	}

	/**
*   @description : find the facilitator to be assigned to the opportunity
*/
	private static void findFacilitator(Opportunity oppty){

		Group facilitatorQueue = null;
		Sales_Role__c facilitatorRole = null;

		//Market North America , Market Latin America , NFS - Queue
		if( Market_North_America.equalsIgnoreCase(oppty.Org_L4__c)   || Market_NFS.equalsIgnoreCase(oppty.Org_L4__c) ||
	 (Market_Latin_America.equalsIgnoreCase(oppty.Org_L4__c) && GlobalConstants.BG_NI.equalsIgnoreCase(oppty.Lead_BG__c) && !GlobalConstants.BU_NI_FN.equalsIgnoreCase(oppty.Lead_BU__c) && !oppty.isMultiBG__c) ){
	  facilitatorQueue = searchForQueue(oppty);
	  if(facilitatorQueue != null){
	   info.queueName = facilitatorQueue.Name;
	   info.queueID = facilitatorQueue.Id;
	   return;
	  }
	 }
		//Other Markets
		else {
			facilitatorRole = getFacilitator(7, oppty);
			if(facilitatorRole != null){
	info.facilitator = new UserInfoWrapper(facilitatorRole.User__c,facilitatorRole.User__r.Name);
	info.organization = facilitatorRole.Organisation__c;
	info.roleCode = facilitatorRole.Role_Code__c;
	findFacilitatorDelegates(facilitatorRole);
	return;
			}
		}
		info.errorMessage = GlobalConstants.G3_FACILITATOR_NOTFOUND;
		info.notFound = true;
	}
	/**
*   @description : find the facilitator queue
*/
	private static Group searchForQueue (Opportunity oppty){
		try {
			List<NF_G3FacilitatorQueueMatrix__c> facilitatorSetting = NF_G3FacilitatorQueueMatrix__c.getAll().values();
			String queueName = getDefaultQueueName(oppty);
			String unweightedValue = getUnweightedValue(oppty);
			String typeRequest = getTypeRequestValue(oppty);
			String leadBU = GlobalConstants.BG_NI.equalsIgnoreCase(oppty.Lead_BG__c) ? oppty.Lead_BU__c : null;
			String orgL5 = getOrgL5Value(oppty);

			for(NF_G3FacilitatorQueueMatrix__c setting : facilitatorSetting) {
	if(setting.Organisation_Level_4__c == oppty.Org_L4__c && setting.Organisation_Level_5__c == orgL5 && setting.Lead_BG__c == oppty.Lead_BG__c
	   && setting.Lead_BU__c == leadBU && setting.Unweighted_Value__c == unweightedValue && setting.Type_of_Request__c == typeRequest){
		queueName = setting.Queue_Developer_Name__c;
	   }
			}
			return [Select Id, Name from Group where type= :GlobalConstants.QUEUE and Name = :queueName limit 1];
		}catch(Exception e){
			System.debug('Issue on searchForQueue : '+e.getMessage());
		}
		return null;
	}

	private static String getDefaultQueueName(Opportunity oppty){
		if ( oppty.Org_L4__c == Market_North_America ) {
			return Label.NF_Default_Queue;
		}
		return null; //Market NFS && LAT
	}

	private static String getUnweightedValue(Opportunity oppty){
		if ( oppty.Org_L4__c == Market_North_America || oppty.Org_L4__c == Market_NFS ) {
			return oppty.Unweighted_Amount_EUR__c < Decimal.valueOf(System.Label.Total_Net_Sales_Value_EUR_Threshold) ? GlobalConstants.BELOW5M : GlobalConstants.ABOVEOREQUAL5M;
		}
		return null; //Market LAT
	}

	private static String getTypeRequestValue(Opportunity oppty){
		if ( oppty.Org_L4__c == Market_North_America || oppty.Org_L4__c == Market_NFS ) {
			return oppty.Unweighted_Amount_EUR__c < Decimal.valueOf(System.Label.Total_Net_Sales_Value_EUR_Threshold) && oppty.Type_of_Request__c == GlobalConstants.TYPE_REQUEST_RFP_RFI ? GlobalConstants.TYPE_REQUEST_RFP_RFI : null;
		}
		return null; //Market LAT
	}

	private static String getOrgL5Value(Opportunity oppty){
		if ( oppty.Org_L4__c == Market_North_America ) {
			return !( GlobalConstants.BG_NI.equalsIgnoreCase(oppty.Lead_BG__c) && oppty.Unweighted_Amount_EUR__c < Decimal.valueOf(System.Label.Total_Net_Sales_Value_EUR_Threshold) && oppty.Type_of_Request__c != GlobalConstants.TYPE_REQUEST_RFP_RFI ) ? oppty.Org_L5__c : null;
		}
		return null; //Market NFS & LAT
	}

/**
*   @description : Method used to find the faciliator starting at L7 until L4 if not found
*/
	private static Sales_Role__c getFacilitator(Integer orgLevel, Opportunity oppty){
		try{
			List<Sales_Role__c> facilitatorList = null;
			String roleCodeSearch = roleCodesMap.get(orgLevel);
			String oppOrganizationLevel = (String)oppty.get(orgLevelsMap.get(orgLevel));
			facilitatorList = querySalesRole(oppOrganizationLevel,roleCodeSearch);
			if(facilitatorList != null && !facilitatorList.isEmpty()) {
	return facilitatorList[0];
			} else if(orgLevel==4){
	return null;
			} else {
	--orgLevel;
	return getFacilitator(orgLevel, oppty);
			}
		}catch(Exception e){
			System.debug('Issue on getFacilitator : '+e.getMessage());
			return null;
		}
	}
/**
*   @description : Method used to query Sales Roles
*/
	private static List<Sales_Role__c> querySalesRole(String organisation , String roleCode){
		return [ SELECT Id, User__c, Role_Code__c, Organisation__c, User__r.Name FROM Sales_Role__c WHERE Role_Code__c = :roleCode AND Organisation__c = :organisation LIMIT 1];
	}
/**
*   @description : Find the delegates
*/
	private static void findFacilitatorDelegates(Sales_Role__c facilitator){
		List<Apttus_Approval__Backup_Approver__c> facilitatorDelegates =  [SELECT Id ,Delegate_Approver1__c, Delegate_Approver1__r.Name, Delegate_Approver2__c, Delegate_Approver2__r.Name, Delegate_Approver3__c, Delegate_Approver3__r.Name
					 FROM Apttus_Approval__Backup_Approver__c WHERE Apttus_Approval__Current_User__c =: facilitator.User__c AND
					 Apttus_Approval__IsActive__c = true AND Apttus_Approval__InEffect__c = true AND Apttus_Approval__IsDelegate__c = true LIMIT 1 ];

		for(Apttus_Approval__Backup_Approver__c facilitatorDel : facilitatorDelegates){
			info.delegate1 = facilitatorDel.Delegate_Approver1__c == null ? null : new UserInfoWrapper(facilitatorDel.Delegate_Approver1__c, facilitatorDel.Delegate_Approver1__r.Name);
			info.delegate2 = facilitatorDel.Delegate_Approver2__c == null ? null : new UserInfoWrapper(facilitatorDel.Delegate_Approver2__c, facilitatorDel.Delegate_Approver2__r.Name);
			info.delegate3 = facilitatorDel.Delegate_Approver3__c == null ? null : new UserInfoWrapper(facilitatorDel.Delegate_Approver3__c, facilitatorDel.Delegate_Approver3__r.Name);
		}
	}
/**
*   @description : Notify the queue members
*/
	private static void notifyQueueMembers(Id queueId, Id oppId){
		Set<Id> queueMembers = getQueueMembers(queueId);
		if(!queueMembers.isEmpty()){
			sendEmail(queueMembers, oppId);
		}
	}
	private static Set<Id> getQueueMembers(Id queueID){
		Set<Id> members = new Set<Id>();
		for(GroupMember member : [SELECT UserOrGroupId FROM GroupMember WHERE GroupId = :queueID]){
			members.add(member.UserOrGroupId);
		}
		return members;
	}
	private static void sendEmail(Set<Id> recipients, ID recordId) {
		try{
			EmailTemplate template = [SELECT Id FROM EmailTemplate WHERE developername = :GlobalConstants.FACILITATOR_EMAIL_TEMPLATE];
			List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
			for(Id recipient : recipients){
	Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
	email.setTargetObjectId(recipient);
	email.setWhatId(recordId);
	email.setTemplateId(template.Id);
	email.setSaveAsActivity(false);
	emails.add(email);
			}
			if(!Test.isRunningTest())
	Messaging.sendEmail(emails);

		}catch(QueryException e){
			system.debug('Issue on sendEmail '+e.getMessage());
		}
	}

	public class FacilitatorWrapper {
		@AuraEnabled
		public UserInfoWrapper facilitator {get;set;}
		@AuraEnabled
		public Id queueID {get;set;}
		@AuraEnabled
		public String queueName {get;set;}
		@AuraEnabled
		public String roleCode {get;set;}
		@AuraEnabled
		public String organization {get;set;}
		@AuraEnabled
		public UserInfoWrapper delegate1 {get;set;}
		@AuraEnabled
		public UserInfoWrapper delegate2 {get;set;}
		@AuraEnabled
		public UserInfoWrapper delegate3 {get;set;}
		@AuraEnabled
		public String errorMessage {get;set;}
		@AuraEnabled
		public Boolean notFound {get;set;}
	}
	public class UserInfoWrapper {
		@AuraEnabled
		public Id userId {get;set;}
		@AuraEnabled
		public String name {get;set;}
		public UserInfoWrapper(Id userId, String name){
			this.userId = userId;
			this.name = name;
		}
	}

}