/***********************************************
*	Class Name : OfferTeamHelper
*	Created By : Accenture IDC
*	Created Date :15/Dec/2016
*	Description : This will handle the methods from OfferTeamHandler
*	Requirement : Sales Process Requirement 649
*********************************************/
public without sharing class OfferTeamHelper{

	//Test coverage from CloneOfferTeamTest
	/****************************************
	*Method Name: OfferTeamRecordShare
	*Description: Give same access to Offer Team as that of Opportunity Team
	*Parameters: Offer Team  List
	*****************************************/	
	public static void offerTeamRecordShare(List<Offer_Team__c> offerTeamList, Boolean isInsert){		
		//Creating Opportuntiy Share in order to share the record 
		List<OpportunityShare> opptyShareList = new List<OpportunityShare>();
		OpportunityShare opptyShare = new OpportunityShare();
		//Quering Offer's, Opportunity's details from Offer Team
		Set<ID> offerTeamIdSet = new Set<ID>();
		try{
			for(Offer_Team__c offerTeam : [Select id,Name__c,Offer_Access__c, Offer__c, Offer__r.Opportunity__c FROM Offer_Team__c WHERE ID IN: offerTeamList LIMIT: offerTeamList.size()]){
	//Creating new opportunity share for the user
	opptyShare = new OpportunityShare();
	//Id of the user you need to give access to
	opptyShare.UserOrGroupId = offerTeam.Name__c;
	system.debug('opptyShare.UserOrGroupId'+opptyShare.UserOrGroupId);
	opptyShare.OpportunityId = offerTeam.Offer__r.Opportunity__c;
	if(offerTeam.Offer_Access__c.equalsIgnoreCase(GlobalConstants.READ_ACCESS)){
		//Read access to the Opportunity record
		opptyShare.OpportunityAccessLevel = GlobalConstants.READ;
		system.debug('opptyShare.OpportunityAccessLevel'+opptyShare.OpportunityAccessLevel);
	}
	else if(offerTeam.Offer_Access__c.equalsIgnoreCase(GlobalConstants.WRITE_ACCESS)){
		//Edit access to the Opportunity record
		opptyShare.OpportunityAccessLevel = GlobalConstants.EDIT;
		system.debug('opptyShare.OpportunityAccessLevel'+opptyShare.OpportunityAccessLevel);
	} else{
		system.debug('Else Part');
	}
	if(offerTeam != NULL){
		opptyShareList.add(opptyShare);
		system.debug('opptyShareList'+opptyShareList);
	}
			}
			if(isInsert){
	if(opptyShareList != NULL){
		database.insert(opptyShareList);
	}
			}
			else{
	for(Offer_Team__c offerTeamDelObj : [SELECT id, Offer__r.Opportunity__c FROM Offer_Team__c WHERE Id IN: offerTeamList LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]){
		//Adding Offer Team Id
		offerTeamIdSet.add(offerTeamDelObj.Offer__r.Opportunity__c);
		system.debug('offerTeamDelObj.Offer__r.Opportunity__c>>'+offerTeamDelObj.Offer__r.Opportunity__c);
		system.debug('offerTeamIdSet>>'+offerTeamIdSet);
	}
	opptyShareList = [SELECT UserOrGroupId, OpportunityId, OpportunityAccessLevel FROM OpportunityShare WHERE OpportunityId IN: offerTeamIdSet AND RowCause =: GlobalConstants.MANUAL LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()];
	system.debug('opptyShareList>>'+opptyShareList);
	database.delete(opptyShareList);
			}
		 }catch(Exception ex){
	ExceptionHandler.addException(ex,GlobalConstants.OFFER_TEAM_HELPER_CLASS,GlobalConstants.OFFER_SHARE);
		 }

	}

	/**********************************************************************************************************************
* author: Accenture
* Date: June-2018
* Param: List<Offer_Team__c>
* Return: void
* Description: Pricing Manager Validation in Offer Team
* High Level Process : 
**********************************************************************************************************************/   
	public static void offerTeamPrMValidation ( List<Offer_Team__c> offTeamlst)
	{
		set<Id> offIdSet = new set<Id>();
		set<Id> oppIdSet = new set<Id>();
		set<String> orgL2 = new set<String>();
		set<String> orgL3 = new set<String>();
		set<String> orgL4 = new set<String>();
		set<String> orgL5 = new set<String>();
		set<String> orgL6 = new set<String>();
		set<String> orgL7 = new set<String>();
		Map<String,String> sRmap = new Map<String, String>();
		
		try
		{
			for(Offer_Team__c offteam : offTeamlst)
			{
	if((offteam.Team_Member_Role__c == System.Label.NF_PricingManager || offteam.Team_Member_Role__c.Contains(System.Label.NF_PricingManager)) || (offteam.Additional_Team_Role__c != null && offteam.Additional_Team_Role__c.Contains(System.Label.NF_PricingManager)))	
	{
		offIdSet.add(offteam.Offer__c);
	}
			}
			System.debug('offIdSet::> '+offIdSet);
			
			if(!offIdSet.isEmpty())
			{
	for( Offer__c off : [SELECT Opportunity__c FROM Offer__c WHERE Id IN:offIdSet]){
		oppIdSet.add(off.Opportunity__c);
	}
			}  
			if(!oppIdSet.isEmpty())
			{
	for(Opportunity opp : [SELECT Org_L2__c,Org_L3__c,Org_L4__c,Org_L5__c,Org_L6__c,Org_L7__c FROM Opportunity WHERE Id IN :oppIdSet AND SWx_Upsell_Proposal__c = null])
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
			System.debug('sRmap::> '+sRmap);
			
			
			for(Offer_Team__c offTeam : offTeamlst)
			{   
	System.debug('offTeam::> '+offTeam);
	if( ((!sRmap.isEmpty() && !sRmap.containsKey(offTeam.Name__c) )|| sRmap.isEmpty()) 
	 && ((offteam.Team_Member_Role__c == System.Label.NF_PricingManager || offteam.Team_Member_Role__c.Contains(System.Label.NF_PricingManager)) || (offteam.Additional_Team_Role__c != null && offteam.Additional_Team_Role__c.Contains(System.Label.NF_PricingManager))))
	{
		offTeam.addError(System.Label.NF_PrM_Validation);
	}
			}
			
		}
		Catch (Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.OFFER_TEAM_HELPER_CLASS, GlobalConstants.METHOD_OFFERTEAM_PrMVALIDATION);
		}
	}
	
	
	/*
	* @description  	Aux method to build the offer team when the first offer is created  
	* @param	ID offerId, ID oppId
	* @return
	*/
	@InvocableMethod
	public static void createOfferTeam(List<Opportunity> opp){
		List<Offer_Team__c> newOfferTeam = new List<Offer_Team__c>();
		Boolean hasBidRole = false;
		List<Opportunity> oppty = [Select Id, OwnerId,
		   (Select Id, UserId, TeamMemberRole,Additional_Team_Role__c, OpportunityAccessLevel, OpportunityId from OpportunityTeamMembers Where User.isActive = TRUE),
		   (Select Id From Offers__r Where ActiveOffer__c = True)
		  From Opportunity Where Id = :opp[0].ID];
		
		List<OpportunityTeamMember> oppTeam = oppty[0].OpportunityTeamMembers;
		Id offerId = oppty[0].Offers__r[0].Id;
		for(OpportunityTeamMember teamMember: oppTeam){
			Offer_Team__c newOfferMember = new Offer_Team__c();
			newOfferMember.Offer__c = offerId;
			newOfferMember.Name__c = teamMember.UserId;
			newOfferMember.Team_Member_Role__c = teamMember.TeamMemberRole;
			newOfferMember.Additional_Team_Role__c = teamMember.Additional_Team_Role__c;
			if(teamMember.OpportunityAccessLevel == GlobalConstants.ALL_ACCESS_OFFER || teamMember.OpportunityAccessLevel == GlobalConstants.EDIT_ACCESS )
				newOfferMember.Offer_Access__c = GlobalConstants.READ_EDIT_ACCESS;
			else
				newOfferMember.Offer_Access__c = GlobalConstants.READ_ONLY_ACCESS;
			
			newOfferTeam.add(newOfferMember);
			
			if(teamMember.TeamMemberRole.equals(GlobalConstants.BID_MANAGER_OFFER_TEAM_ROLE)){
				hasBidRole = true;
			}
		}
		
		if(!hasBidRole){
			Offer_Team__c bidManager = null;
			bidManager = new Offer_Team__c();
			bidManager.Offer__c = offerId;
			bidManager.Name__c = oppty[0].OwnerId;
			bidManager.Team_Member_Role__c = GlobalConstants.BID_MANAGER_OFFER_TEAM_ROLE;
			bidManager.Offer_Access__c = GlobalConstants.READ_EDIT_ACCESS;
			newOfferTeam.add(bidManager);
		}
		
		Database.SaveResult[] srList = Database.insert(newOfferTeam, false);

		// Iterate through each returned result
		for (Database.SaveResult sr : srList) {
			if (sr.isSuccess()) {
				// Operation was successful, so get the ID of the record that was processed
				System.debug('Successfully inserted Offer Team Member. Offer Team: ' + sr.getId());
			}
			else {
				// Operation failed, so get all errors				
				for(Database.Error err : sr.getErrors()) {
					System.debug('The following error has occurred.');					
					System.debug(err.getStatusCode() + ': ' + err.getMessage());
				}
			}
		}
	}	
}