/** @description: Email notification for OTM & Direct Opportuniy creation by PSM *******************************
* @author:	Accenture IDC.
*
* ============================================================================
* History:
* -------
* 
* VERSION AUTHOR	DATE		DETAIL			FEATURES/CSR/TTP
* 2	Pooja			Email notification for OTM & Direct Opportuniy creation by PSM
* ============================================================================ 
***************************************************************************************************************/

public without sharing  class OpportunityTriggerHelperPRM{
	/*******************************
*Method name: sendNotificationOnApproved
*Description: This Method will send mail on approved support to otm
*Parameter: Opportunity Values
*******************************/  
	public static void sendNotificationOnApproved(opportunity oppty){
		try{
			List<OpportunityTeamMember> otm = new List<OpportunityTeamMember>();
			List<id> userIdList = new List<id>();
			Opportunity opp = new Opportunity();
			otm = [SELECT Id,UserId,Name FROM OpportunityTeamMember WHERE OpportunityId =: oppty.id  Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows()) ];
			opp = [SELECT Id,Name,PRMOther_Support_Status__c,PRMPricing_Support_Status__c,PRMSales_Support_Status__c,PRMTechnical_Support_Status__c FROM Opportunity WHERE Id =: oppty.id Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows()) ];
			for(OpportunityTeamMember oppMember : otm ){
	userIdList.add(oppMember.UserId);
			}
			if(opp.PRMSales_Support_Status__c == PRMGlobalConstants.Accepted ){
	EmailNotification.SendMailsOnSupportRequestApproved(userIdList,opp,otm);
			}
			if(opp.PRMOther_Support_Status__c== PRMGlobalConstants.Accepted ){
	EmailNotification.SendMailsOnOtherSupportRequestApproved(userIdList,opp,otm);
			}
			if(opp.PRMPricing_Support_Status__c == PRMGlobalConstants.Accepted ){
	EmailNotification.SendMailsOnPricingSupportRequestApproved(userIdList,opp,otm); 
			}
			if(opp.PRMTechnical_Support_Status__c == PRMGlobalConstants.Accepted ){
	EmailNotification.SendMailsOnTechnicalSupportRequestApproved(userIdList,opp,otm);	 
			}
		}
		catch(System.Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.OpportunityTriggerHelperPRM,PRMGlobalConstants.sendNotificationOnApproved);
		}
	}
	
	/*******************************
*Method name: sendNotificationOnDeclined
*Description: This Method will send mail on rejected support to otm
*Parameter: Opportunity Values
*******************************/ 
	
	public static void sendNotificationOnDeclined(opportunity oppty){
		try{
			List<OpportunityTeamMember> otm = new List<OpportunityTeamMember>();
			List<id> userIdList = new List<id>();
			Opportunity opp = new Opportunity();
			otm = [SELECT Id,UserId,Name FROM OpportunityTeamMember WHERE OpportunityId =: oppty.id  Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows()) ];
			opp = [SELECT Id,Name,PRMOther_Support_Status__c,PRMPricing_Support_Status__c,PRMSales_Support_Status__c,PRMTechnical_Support_Status__c FROM Opportunity WHERE Id =: oppty.id Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows()) ];
			for(OpportunityTeamMember oppMember : otm ){
	userIdList.add(oppMember.UserId);
			}
			if(opp.PRMSales_Support_Status__c == PRMGlobalConstants.Declined ){
	EmailNotification.SendMailsOnSupportRequestDeclined(userIdList,opp,otm);
			}
			if(opp.PRMOther_Support_Status__c == PRMGlobalConstants.Declined ){
	EmailNotification.SendMailsOnOtherSupportRequestDeclined(userIdList,opp,otm); 
			}
			if(opp.PRMPricing_Support_Status__c == PRMGlobalConstants.Declined ){
	EmailNotification.SendMailsOnPricingSupportRequestDeclined(userIdList,opp,otm); 
			}
			if(opp.PRMTechnical_Support_Status__c == PRMGlobalConstants.Declined ){
	EmailNotification.SendMailsOnTechnicalSupportRequestDeclined(userIdList,opp,otm); 
			}
		}
		catch(System.Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.OpportunityTriggerHelperPRM,PRMGlobalConstants.sendNotificationOnDeclined);
		}
		
	}  
	
	/*******************************
*Method name: PartnerOpportunityTeam
*Description: This Method will add partner in otm
*Parameter: Opportunity Values
******************************/
	
	public static void partnerOpportunityTeam(opportunity opp){
		try{
			List<User> user = new  List<User>();
			List<OpportunityTeamMember> opportunityMemberList = new List<OpportunityTeamMember>(); 
			Map<ID, Schema.RecordTypeInfo>recTypeMap = Schema.SObjectType.Opportunity.getRecordTypeInfosById();
			List<Account_Member__c> accountMemberList = new List<Account_Member__c>();
			Set<id> idSet = new Set<id>();
			OpportunityTeamMember otm = new OpportunityTeamMember();
			
			user =  [SELECT Id,IsActive FROM User WHERE Id =: opp.PRMPartner_User_Name__c limit 1];
			accountMemberList = [SELECT Account_Role__c,Id,Name__c,Name__r.Name,Type__c FROM Account_Member__c 
		 WHERE Account__c =: opp.AccountId AND Account_Role__c =: PRMGlobalConstants.Partner_Relationship_Manager AND 
		 Name__r.ID  !=:user[0].Id AND Name__r.IsActive =: PRMGlobalConstants.TRUE_VALUE   Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			String opptyRecordType = recTypeMap.get(opp.RecordTypeId).getName();
			if( opp.PRMPartner_User_Name__c != null && opptyRecordType != 'Create Indirect Sales Opportunity'){ 
	if(user[0].IsActive == PRMGlobalConstants.TRUE_VALUE ){
		otm.TeamMemberRole = PRMGlobalConstants.PARTNER;
		otm.OpportunityId= opp.Id;
		otm.UserId= User[0].Id;	
		otm.OpportunityAccessLevel = GlobalConstants.EDIT;
		opportunityMemberList.add(otm);
		
	}
	else opp.PRMPartner_User_Name__c.addError(PRMGlobalConstants.ERROR_INACTIVE_USER );
			}
			
			if(!accountMemberList.IsEmpty() ){
	for(Account_Member__c accTeamMeamber : accountMemberList){
		OpportunityTeamMember otm1 = new OpportunityTeamMember();
		otm1.TeamMemberRole = PRMGlobalConstants.PARTNER;
		otm1.UserId= accTeamMeamber.Name__c; 
		otm1.OpportunityId= opp.Id;  
		otm1.OpportunityAccessLevel = GlobalConstants.EDIT;
		opportunityMemberList.add(otm1);
	}
			}   
			Database.Insert(opportunityMemberList);
		}	
		catch(System.Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.OpportunityTriggerHelperPRM,PRMGlobalConstants.partnerOpportunityTeam);
		}
	}
	
	
	/*******************************
*Method name: deletePartnerFromOTM
*Description: This Method will delete Partner from OTM
*Parameter: Opportunity Values
******************************/
	public static void deletePartnerFromOTM(List<OpportunityTeamMember> opptyTeamListNew , Opportunity OpptyOld,  Opportunity OpptyNew ){
		try{ 
			User user = new User();
			OpportunityTeamMember opptyTeam = new OpportunityTeamMember();
			user = [SELECT  Id FROM User WHERE Id =: OpptyOld.PRMPartner_User_Name__c Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			
			opptyTeam = [SELECT Id,Name,OpportunityAccessLevel,OpportunityId,TeamMemberRole,Title,UserId FROM OpportunityTeamMember WHERE 
			 (OpportunityId =:OpptyOld.Id AND UserId =: user.ID) Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			if(OpptyNew.PRMPartner_User_Name__c != OpptyOld.PRMPartner_User_Name__c && OpptyOld.PRMPartner_User_Name__c != NULL 
	  && (OpptyOld.PartnerAvailable__c == PRMGlobalConstants.YES || OpptyNew.PartnerAvailable__c == PRMGlobalConstants.YES)){
	   database.delete(opptyTeam);
	  }
		}
		catch(System.Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.OpportunityTriggerHelperPRM,PRMGlobalConstants.deletePartnerFromOTM);
		}
		
	}
	/*******************************
*Method name: indirectToDirectUpdate
*Description: This Method will Remove PRM realted fields on Indirect to direct Record type Update
*Parameter: Opportunity Values
******************************/  
	public static void indirectToDirectUpdate(Map<Id,opportunity> opportunityNewMap){
		try{   
			List<Opportunity> oppList = new List<Opportunity>();
			set<Id> opptyId = new set<Id>();
			List<Case> caseList = new List<Case>();
			for(opportunity opportunity : opportunityNewMap.values() ){
	opportunityNewMap.get(opportunity.Id).PRMPartner_User_Name__c = null;
	opportunityNewMap.get(opportunity.Id).PartnerAvailable__c = null;
	opportunityNewMap.get(opportunity.Id).Lead_Type__c = null;
	opportunityNewMap.get(opportunity.Id).PRMOther_Support_Requested__c = false;
	opportunityNewMap.get(opportunity.Id).PRMPricing_Support_Requested__c = false;
	opportunityNewMap.get(opportunity.Id).PRMSales_Support_Requested__c = false;
	opportunityNewMap.get(opportunity.Id).PRMTechnical_Support_Requested__c = false;
	opportunityNewMap.get(opportunity.Id).End_Customer__c = opportunityNewMap.get(opportunity.Id).Account.Id;
	opportunityNewMap.get(opportunity.Id).End_Customer_LE__c = opportunityNewMap.get(opportunity.Id).Legal_Entity__c;
	oppList.add(opportunityNewMap.get(opportunity.Id));
			}
			for(opportunity opptyInst :oppList){
	opptyId.add(opptyInst.id);
			} 
			caseList = [SELECT Id, Status, Reason, Opportunity__c FROM Case WHERE Opportunity__c IN : opptyId AND Subject =: PRMGlobalConstants.SalesSupportRequested  Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			if(!caseList.IsEmpty()){
	for(Case caseInstance : caseList){
		caseInstance.Status = PRMGlobalConstants.Closed;
		caseInstance.Reason = PRMGlobalConstants.Cancelled;	
	} 
			}
			
			Database.update(caseList);
		}catch(System.Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.OpportunityTriggerHelperPRM,PRMGlobalConstants.indirectToDirectUpdate);
		}
	} 
	
	/**********************************************************************************************************************
* author: Accenture
* Date: Dec-2016
* Param: Map<Id,Lead> leadNewMap
* Return: void
* Methode : ShareOpptyWithApprover
* Description: Method for afterUpdateOpportunity
* High Level Process : share oppty
**********************************************************************************************************************/  
	public static void shareOpptyWithRBCApprover(Opportunity oppty){
		try{
			List<OpportunityShare> opptyShareToInsert = new List<OpportunityShare> ();	 
			OpportunityShare share = new OpportunityShare();
			share.UserOrGroupId = oppty.PRMRBC_Direct_Sales_Approver__c;
			share.OpportunityId = oppty.Id;
			share.OpportunityAccessLevel = PRMGlobalConstants.READ;
			share.RowCause = PRMGlobalConstants.MANUAL;
			opptyShareToInsert.add(share);
			
			Database.SaveResult[] srList = Database.insert(opptyShareToInsert, false);
			
		}
		
		catch(System.Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.OpportunityTriggerHelperPRM,PRMGlobalConstants.ShareOpptyWithApprover);
		}
	}
}