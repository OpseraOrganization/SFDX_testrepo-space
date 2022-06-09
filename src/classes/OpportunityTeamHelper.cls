/***********************************************
*	Class Name : OpportunityTeamHelper
*	Created By : Accenture IDC
*	Created Date :23/Dec/2016
*	Description : This will share or unshare the documents of an Opportunity to new Opportunity Team member	   
*	Requirement : Doc Strategy Requirement 657
Change log: v.1.1 
*********************************************/
public with sharing class OpportunityTeamHelper {


/**********************************************************************************************************************
* author: Accenture
* Date: March-2017
* Param: List<OpportunityTeamMember>
* Return: void
* Description: It restricts updation, creation and deletion of OTM when oppty is locked
* High Level Process : 
**********************************************************************************************************************/ 
	public static void restrictOTM(List<OpportunityTeamMember > opportunityTeamMemberList){
		try{
			Map<ID,ID> otmIDOppIDMap = new Map<ID,ID>();
			
			for(OpportunityTeamMember otm : opportunityTeamMemberList){
	if(otm.OpportunityID != null){
		otmIDOppIDMap.put(otm.Id,otm.OpportunityID);
	}  
			}
			if(otmIDOppIDMap.size() > 0){
	Map<ID,Opportunity> oppMap = new Map<ID,Opportunity>([Select id, StageName, Phase_Status__c, Sales_Outcome__c from Opportunity where Id IN: otmIDOppIDMap.Values()]);
	for(OpportunityTeamMember otm : opportunityTeamMemberList){
		if(otm.OpportunityID != null){
			Opportunity opp = oppMap.get(otmIDOppIDMap.get(otm.id));
			//Adding logic as per D-1687
			//if(opp.StageName != null && opp.Sales_Outcome__c != null){
				if(opp.Phase_Status__c.equalsIgnoreCase(GlobalConstants.PHASE_STATUS_CLOSED) || opp.Phase_Status__c.equalsIgnoreCase(GlobalConstants.PHASE_STATUS_CLOSED_NOT_WON)){
		otm.addError(System.Label.Opportunity_Team_Error_Message);
		system.debug('OpptyTeamErrorMessage');
				}
			//}
		}
	}
			}
		}
		catch(Exception e){
			ExceptionHandler.addException(e,GlobalConstants.OPPORTUNITY_TEAM_HELPER ,GlobalConstants.RESTRICTOTM );			
		}
	}

/**********************************************************************************************************************
* author: Accenture
* Date: Mar-2017
* Param: OTM List
* Return: void
* Description: To get the time of latest update of OTM and update on Oppty
* High Level Process : 
**********************************************************************************************************************/ 
	public static void changeOnOTMs(List<OpportunityTeamMember > opportunityTeamMemberList){
		try{
			Map<ID,ID> otmIDOppIDMap = new Map<ID,ID>();
			List<Opportunity> opptyToUpdateList = new List<Opportunity>();
			for(OpportunityTeamMember otm : opportunityTeamMemberList){
	if(otm.OpportunityID != null){
		otmIDOppIDMap.put(otm.Id,otm.OpportunityID);
	}  
			}
			if(otmIDOppIDMap.size() > 0){
	Map<ID,Opportunity> oppMap = new Map<ID,Opportunity>([Select id, StageName, Sales_Outcome__c from Opportunity where Id IN: otmIDOppIDMap.Values()]);
	for(OpportunityTeamMember otm : opportunityTeamMemberList){
		if(otm.OpportunityID != null){
			Opportunity opp = oppMap.get(otmIDOppIDMap.get(otm.id));
			opp.Last_OTM_Change__c = system.now();
			opptyToUpdateList.add(opp);
		}
	}
			}
			if(!opptyToUpdateList.isEmpty()){
	database.update(opptyToUpdateList);
			}
		}
		catch(Exception e){
			ExceptionHandler.addException(e,GlobalConstants.OPPORTUNITY_TEAM_HELPER ,GlobalConstants.OPPORTUNITY_TEAM_HELPER );			
		}
	} 
	
  /*****************************
	* author: Accenture
	* Date: Oct-2017
	* Param:
	* Return: void
	* Description: To restrict same oppty Team Member and Additional Team Member Role
	* High Level Process :
	 *******************************/	  
	 public static void restrictSameTeamandAdditionalTeamRole(List<OpportunityTeamMember> opportunityTeamMemberList){
	System.debug('opportunityTeamMemberList---->'+opportunityTeamMemberList);
	try{
	 for(OpportunityTeamMember optyteamMemberObj : opportunityTeamMemberList){
	  String strTest = optyteamMemberObj.Additional_Team_Role__c;
	  List<String> additionalTeamRoleList = strTest.split(';');
	  Set<String> additionalTeamRoleSet = new Set<String>(); 
	  additionalTeamRoleSet.addAll(additionalTeamRoleList ); 
	  if(additionalTeamRoleSet.contains(optyteamMemberObj.TeamMemberRole)){
	
	   optyteamMemberObj.addError(Label.ErrorMsgOnSameTeamRole);
	  
	  }
	 }
	}catch(Exception ex){
	 ExceptionHandler.addException(ex,GlobalConstants.OPPORTUNITY_TEAM_HELPER ,GlobalConstants.RESTRICTSAMETEAMROLE);
	}
	 }


 /*****************************
	 * author: Accenture
	* Date: April-2017
	* Param: OTM List
	* Return: void
	* Description: To insert into Deleted_OTM__c
	* High Level Process :
	 *******************************/	
	public static void insertIntoDeleted_OTM(List<OpportunityTeamMember> opportunityTeamMemberOldList){
		List<Deleted_OTM__c> otmList = new List<Deleted_OTM__c>();
		Deleted_OTM__c otmObj = new Deleted_OTM__c();
		try{
		for(OpportunityTeamMember optyteamMemberObj : opportunityTeamMemberOldList){
			otmObj = new Deleted_OTM__c();
			otmObj.User__c = optyteamMemberObj.UserId;
			otmObj.Opportunity__c = optyteamMemberObj.OpportunityId;
			otmObj.Team_Role__c = optyteamMemberObj.TeamMemberRole;
			otmList.add(otmObj);
		}			
		if(!otmList.isEmpty()){
			Database.SaveResult[] savedResults = database.insert(otmList);
			Boolean someFailure = false;
			for (Database.SaveResult sr: savedResults) {
	if (!sr.isSuccess()) {
		someFailure = true;
		for (Database.Error err: sr.getErrors()) {
			System.debug('Error occured : ' + err.getStatusCode() + ' : ' + err.getMessage());
			System.debug('Fields that affected this error : ' + err.getFields());
		}
	}
			}
			if (!someFailure) {
	System.debug('Opportunity updated successfully');
			}	   
		}  
		}catch(Exception ex)  {
			ExceptionHandler.addException(ex,GlobalConstants.OPPORTUNITY_TEAM_HELPER ,GlobalConstants.INSERTINTODELETEDOTM );
		}
	}
	
	/**********************************************************************************************************************
	* author: Accenture
	* Date: November-2017
	* Param: OTM List
	* Return: void
	* Description: Team Insert Error if account user is not NSA Complaint
	   Req :- 3353 -Enhancement Request - Ability to block oppty team add's missing NSA compliance flag
	* High Level Process : 
	**********************************************************************************************************************/ 
	public static void CheckNSACompliantAccount(List<OpportunityTeamMember > opportunityTeamMemberList)
	{
		Id DirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.DIRECT_OPPTY).getRecordTypeId(); 
		Id InDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.INDIRECT_OPPTY).getRecordTypeId(); 

		Set<Id> setOpptyId = new set<Id>();
		Set<Id> setNSAOpptyID ;
		
		Map<Id,Id> mapUserOpptyID = new Map<Id,Id>();	  
		Map<Id,Boolean> mapNSAValue ;
		Map<Id,Opportunity> mapIdOppty ;
		Map<Id,User> mapIdUser ;
		
		try{
			for(OpportunityTeamMember optyteamMemberObj : opportunityTeamMemberList)
			{
	mapUserOpptyID.put(optyteamMemberObj.UserId,optyteamMemberObj.OpportunityId);
	setOpptyId.add(optyteamMemberObj.OpportunityId); 
			}
			
			system.debug('Oppty team Users-->'+mapUserOpptyID);
			
			if(mapUserOpptyID.size() > 0)
			{
	setNSAOpptyID = new set<Id>();
	mapIdOppty = new Map<Id,Opportunity>([select Id,Account.Customer_Compliance__c,RecordTypeId from opportunity where id in: setOpptyId]);	  
	for(opportunity OpptyObj : mapIdOppty.values())
	{
		if(OpptyObj.Account.Customer_Compliance__c == Label.Account_Compliance_Value && (OpptyObj.RecordTypeId == DirectRecordTypeId || OpptyObj.RecordTypeId == InDirectRecordTypeId) ) 
		{
			setNSAOpptyID.add(OpptyObj.id);
		}
	}
	
	system.debug('NSA Compliance Oppty-->'+setNSAOpptyID);
	
	if(setNSAOpptyID.size() > 0)
	{
		mapNSAValue = new Map<Id,Boolean>();
		mapIdUser = new  Map<Id,User>([select id,NSA_Compliant__c from user where id=:mapUserOpptyID.keyset()]); 
		for(User userObj : mapIdUser.values())
		{
			if(userObj.NSA_Compliant__c == false)
			{
				mapNSAValue.put(userObj.id,userObj.NSA_Compliant__c);
			}
		}
		
		system.debug('Non NSA Compliance Users-->'+mapNSAValue);
		
		if(mapNSAValue.size() > 0 )
		{
			for(OpportunityTeamMember optyteamMemberObjN : opportunityTeamMemberList)
			{
				if(mapNSAValue.get(optyteamMemberObjN.UserId) == false && setNSAOpptyID.contains(mapUserOpptyID.get(optyteamMemberObjN.UserId)))
				{
		optyteamMemberObjN.addError(Label.NSA_Compliance_Error_Msg);
				}
			}
		}
	}
			}
			
			GlobalConstants.RUN_OPPORTUNITYTEAM_TRIGGER_ON_NSACompliantAcc = true;
			
		}
		catch(Exception e){
			ExceptionHandler.addException(e,GlobalConstants.OPPORTUNITY_TEAM_HELPER ,GlobalConstants.CHECK_NSA_COMPLIENT_ACCOUNT);			
		}
	} 
	
/**********************************************************************************************************************
* author: Accenture
* Date: June-2018
* Param: List<OpportunityTeamMember>
* Return: void
* Description: Pricing Manager Validation in Opportunity Team
* High Level Process : 
**********************************************************************************************************************/   
	public static void oppTeamPrMValidation ( List<OpportunityTeamMember> oppTeamlst)
	{
		set<Id> oppIdSet = new set<Id>();
		set<String> orgL2 = new set<String>();
		set<String> orgL3 = new set<String>();
		set<String> orgL4 = new set<String>();
		set<String> orgL5 = new set<String>();
		set<String> orgL6 = new set<String>();
		set<String> orgL7 = new set<String>();
		Map<String,String> sRmap = new Map<String, String>();
		System.debug('Calling PrM validation Oppty team');
		try
		{
			for(OpportunityTeamMember oppteam : oppTeamlst)
			{
	//if(oppteam.TeamMemberRole == System.Label.NF_PricingManager || (oppteam.Additional_Team_Role__c != null && oppteam.Additional_Team_Role__c.Contains(System.Label.NF_PricingManager)))
	if((oppTeam.TeamMemberRole == System.Label.NF_PricingManager || oppTeam.TeamMemberRole ==System.Label.NF_PricingManagerLead)
		|| (oppTeam.Additional_Team_Role__c != null 
		 && (oppTeam.Additional_Team_Role__c.Contains(System.Label.NF_PricingManager) || oppTeam.Additional_Team_Role__c.Contains(System.Label.NF_PricingManagerLead))))
	{
		oppIdSet.add(oppteam.OpportunityId);
	}
			}
			System.debug('oppIdSet::> '+oppIdSet);
			
			
			
			if(!oppIdSet.isEmpty())
			{
	for(Opportunity opp : [SELECT Id,Org_L2__c,Org_L3__c,Org_L4__c,Org_L5__c,Org_L6__c,Org_L7__c FROM Opportunity WHERE Id IN :oppIdSet ])
	{
		orgL2.add(opp.Org_L2__c);
		orgL3.add(opp.Org_L3__c);
		orgL4.add(opp.Org_L4__c);
		orgL5.add(opp.Org_L5__c);
		orgL6.add(opp.Org_L7__c);
		orgL7.add(opp.Org_L7__c);
	}
	
	for(Sales_Role__c sR : [SELECT User__c,Organisation__c FROM Sales_Role__c WHERE Role_Code__c LIKE :System.Label.NF_PrM_Role AND
	(Organisation__c IN: orgL2 OR
	 Organisation__c IN: orgL3 OR
	 Organisation__c IN: orgL4 OR 
	 Organisation__c IN: orgL5 OR 
	 Organisation__c IN: orgL6 OR 
	 Organisation__c IN: orgL7)])
	{
		sRmap.put(sR.User__c, sR.Organisation__c);
	}
			}
			
			for(OpportunityTeamMember oppTeam : oppTeamlst)
			{   
	System.debug('oppTeam::> '+oppTeam);
	if((!sRmap.isEmpty() && !sRmap.containsKey(oppTeam.UserId)) || sRmap.isEmpty())
	{
	/*if(oppTeam.TeamMemberRole == System.Label.NF_PricingManager 
		|| (oppTeam.Additional_Team_Role__c != null 
		 && oppTeam.Additional_Team_Role__c.Contains(System.Label.NF_PricingManager)))*/
		
		if((oppTeam.TeamMemberRole == System.Label.NF_PricingManager || oppTeam.TeamMemberRole ==System.Label.NF_PricingManagerLead)
		|| (oppTeam.Additional_Team_Role__c != null 
		 && (oppTeam.Additional_Team_Role__c.Contains(System.Label.NF_PricingManager) || oppTeam.Additional_Team_Role__c.Contains(System.Label.NF_PricingManagerLead))))
		{   
			System.debug('Error for PrM');
			oppTeam.addError(System.Label.NF_PrM_Validation);
			System.debug('Error for PrM after');
		}
	
			}
			}
		}
		Catch (Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITY_TEAM_HELPER, GlobalConstants.METHOD_OPPORTUNITYTEAM_PrMVALIDATION);
		}
	}
	
/**********************************************************************************************************************
* Created By: HCL Team
* Description: To restrict User in Opportunity Team member based on Profiles.
* Creaed On: 4th July 2019
**********************************************************************************************************************/   
	
	public static void restrictUser(List<OpportunityTeamMember> newOpptyMember, Map<Id,OpportunityTeamMember> oldMapOpptyMember){
		Set<Id> opptyMemUserIds = new Set<Id>();
		Set<String> allowedProfilesForOTM = new Set<String>();
		Map<Id,User> mapOfUserIdAndProfileName = new Map<Id,User>();
		
		List<Profile_to_be_added_in_OTM__mdt> metadataList = [Select MasterLabel from Profile_to_be_added_in_OTM__mdt];
		for(Profile_to_be_added_in_OTM__mdt mt : metadataList){
	 allowedProfilesForOTM.add(mt.MasterLabel); 
		}
		
		for(OpportunityTeamMember oppyMem: newOpptyMember){
			opptyMemUserIds.add(oppyMem.UserId);
		}
		if(opptyMemUserIds != null){
			for(User us: [Select Id, ProfileId, Profile.Name from User where Id IN:opptyMemUserIds]){
	mapOfUserIdAndProfileName.put(us.Id, us);
			}
		}
		
		for(OpportunityTeamMember opptyMem: newOpptyMember){
			if(oldMapOpptyMember == null || (opptyMem.UserId != oldMapOpptyMember.get(opptyMem.Id).UserId)){
	System.debug('mapOfUserIdAndProfileName.get(opptyMem.UserId) '+mapOfUserIdAndProfileName.get(opptyMem.UserId));
	if(mapOfUserIdAndProfileName.get(opptyMem.UserId) != null){
		String profileName = mapOfUserIdAndProfileName.get(opptyMem.UserId).Profile.Name;
		System.debug('profileName '+profileName);
		if(!allowedProfilesForOTM.contains(profileName)){
			opptyMem.addError('This User can not be added as Opportunity Team Member (his/her User Profile is not authorized to be part of Opportunity Team).' );
		}
	}
			}
		}
	}
}