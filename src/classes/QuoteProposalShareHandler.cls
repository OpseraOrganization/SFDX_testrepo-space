/*********************************
* Author: Ankit Maheshwari
* Company: Accenture
* Date: 23 OCT 2019
* High Level Process : Class to share Quote records with OTM
**********************************/
public without sharing class QuoteProposalShareHandler {
	public static void quoteProposalShare(Set<Id> proposalListTrigger){
	try{
			if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id))
			{
	if(!System.isFuture() && !System.isBatch()){
		quoteShare(proposalListTrigger);
	}
			}
		}
		
		catch(exception ex){
			ExceptionHandler.addException(ex, QuoteProposalShareHandler.class.getName(), GlobalConstants.ProposalTriggerHandler_afterInsertCPQTrigger);			
		}
	}

	@future
	public static void quoteShare(Set<Id> proposalListTrigger){
		List<Apttus_Proposal__Proposal__c> proposalList = new List<Apttus_Proposal__Proposal__c>();
		Set<Id> OpportunityIds = new Set<Id>();
		Map<Id, List<OpportunityTeamMember>> mapOTM = new Map<Id, List<OpportunityTeamMember>>();
		list<Apttus_Proposal__Proposal__Share> proposalShareList = new list<Apttus_Proposal__Proposal__Share>();
		for(Apttus_Proposal__Proposal__c proposal : [Select Id,OwnerId,Apttus_Proposal__Opportunity__c,Quote_Type__c from Apttus_Proposal__Proposal__c where Id in: proposalListTrigger]){
			if(proposal.Apttus_Proposal__Opportunity__c!=null && (proposal.Quote_Type__c=='Indirect CPQ' ||proposal.Quote_Type__c=='Direct CPQ' || proposal.Quote_Type__c=='Direct DS' || proposal.Quote_Type__c=='Indirect DS')){
	OpportunityIds.add(proposal.Apttus_Proposal__Opportunity__c);
	proposalList.add(proposal);
			}
		}
		for(OpportunityTeamMember OTM : [SELECT id, userid, teammemberrole, opportunityid FROM OpportunityTeamMember WHERE opportunityid IN: OpportunityIds]) {
			if(mapOTM.containsKey(OTM.opportunityid)) {
	List<OpportunityTeamMember> OTMList = mapOTM.get(OTM.opportunityid);
	OTMList.add(OTM);
	mapOTM.put(OTM.opportunityid, OTMList);
			} else {
	mapOTM.put(OTM.opportunityid, new List<OpportunityTeamMember> { OTM });
			}
		}
		for(Apttus_Proposal__Proposal__c proposal : proposalList){
			list<OpportunityTeamMember> OTMLstProposal = new list<OpportunityTeamMember>();
			if(!mapOTM.isEmpty()){
	OTMLstProposal.addAll(mapOTM.get(proposal.Apttus_Proposal__Opportunity__c));
	if(!OTMLstProposal.isEmpty()){
		for(OpportunityTeamMember OTM : OTMLstProposal){
			Apttus_Proposal__Proposal__Share proposalShare= new Apttus_Proposal__Proposal__Share();
			if(OTM.userid!=proposal.OwnerId){
				proposalShare.AccessLevel='Edit';
				proposalShare.ParentId=proposal.Id;
				proposalShare.UserOrGroupId=OTM.userid;
				proposalShareList.add(proposalShare);
			}
		}   
	}	
			}
		}
		if(!proposalShareList.IsEmpty()){
			Database.SaveResult[] fdList = Database.insert(proposalShareList, false);
		}
	}
}