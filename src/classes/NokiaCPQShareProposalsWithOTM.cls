/***********************************************
*   Class Name : NokiaCPQShareProposalsWithOTM
*   Created By : Accenture IDC
*   Created Date :22/05/2017
*   Description : This class contains the logic to share proposals records to Opportunity team members dynamically.
*   Requirement : Open a quote from CPQ 2061
Manage Opportunity Teams 2071
View and edit Quotes 2087
*********************************************/
public class NokiaCPQShareProposalsWithOTM {

	
   public static void unshareProposalRecordAfterOTMTriggerDelete(Map<Id,OpportunityTeamMember> opportunityTeamMembersMap) {
	   try{
		   set<Id> userId = new set<Id>();
		   map<Id,set<Id>> oppIdWithDeletedUserId = new map<Id,set<Id>>();
		   map<Id,list<Apttus_Proposal__Proposal__c>> oppIdWithProposalRec = new map<Id,list<Apttus_Proposal__Proposal__c>>();
		   list<Apttus_Proposal__Proposal__Share> deletedItemList = new list<Apttus_Proposal__Proposal__Share>();
		   for(OpportunityTeamMember otm : opportunityTeamMembersMap.values()){
			   userId.add(Otm.UserId);
			   If(otm.OpportunityId != null && oppIdWithDeletedUserId.containskey(otm.OpportunityId)){
				   oppIdWithDeletedUserId.get(otm.OpportunityId).add(Otm.UserId);
			   }
			   else{
				   Set<Id> UserIdSet = new Set<Id>();
				   UserIdSet.add(Otm.UserId);
				   oppIdWithDeletedUserId.put(otm.OpportunityId,UserIdSet);
			   }
		   }
		   for(Apttus_Proposal__Proposal__Share quoteShare : [Select id,AccessLevel,ParentId,UserOrGroupId,RowCause,Parent.Apttus_Proposal__Opportunity__c,Parent.OwnerId from Apttus_Proposal__Proposal__Share where Parent.Apttus_Proposal__Opportunity__c in : oppIdWithDeletedUserId.keyset() AND UserOrGroupId in: userId]){
			   if(!oppIdWithDeletedUserId.isEmpty() && oppIdWithDeletedUserId.containskey(quoteShare.Parent.Apttus_Proposal__Opportunity__c) && !oppIdWithDeletedUserId.get(quoteShare.Parent.Apttus_Proposal__Opportunity__c).isEmpty() && oppIdWithDeletedUserId.get(quoteShare.Parent.Apttus_Proposal__Opportunity__c).contains(quoteShare.UserOrGroupId) && quoteShare.RowCause == 'Manual' && quoteShare.UserOrGroupId!=quoteShare.Parent.OwnerId){
				   deletedItemList.add(quoteShare);
			   }
		   }
		   if(!deletedItemList.IsEmpty()){
			   Database.DeleteResult[] DR_Dels = Database.delete(deletedItemList);
		   }
		}
		catch(Exception e)
		{
			System.debug(e);
		}
	}
	/*********************************
	* author: Accenture
	* Date: 9 SEP 2019
	* Param: Set<OpportunityTeamMember> setOpportunityTeamMembersId
	* Return: None
	* Description: Method to share Quote with Opportunity Team members.
	* High Level Process :   
	**********************************/
	@future
	public static void quoteProposalShare(Set<Id> setOpportunityTeamMemberId){
		Map<Id,List<id>> OTMOppMap = new map<Id,List<Id>>();
		Map<Id,List<id>> OppQuoteMap = new map<Id,List<Id>>();
		Map<Id,Set<Id>> QuoteShareMap = new map<Id,Set<Id>>();
		Set<Id> oppIds = new set<Id>();
		List<Id> oppIdsList = new List<Id>();
		set<Id> quoteIds = new set<Id>();
		set<Id> userIdshare = new set<Id>();
		list<OpportunityTeamMember> newOpportunityTeamMemberid = new list<OpportunityTeamMember>([Select Id, OpportunityId,UserId from OpportunityTeamMember where Id in: setOpportunityTeamMemberId]);
		List<Apttus_Proposal__Proposal__Share> quoteShareToOpportunityTeamMemberInsert  = new List<Apttus_Proposal__Proposal__Share>();
		for(OpportunityTeamMember Otm : newOpportunityTeamMemberid){
			oppIds.add(Otm.OpportunityId);
			oppIdsList.add(Otm.OpportunityId);		   
		}
		for(OpportunityTeamMember Otm : [Select Id, OpportunityId,UserId from OpportunityTeamMember where OpportunityId in: oppIds]){
			if(Otm!=null){
				userIdshare.add(Otm.UserId);
			}
			If(otm.OpportunityId != null && OTMOppMap.containskey(otm.OpportunityId)){
				OTMOppMap.get(otm.OpportunityId).add(Otm.UserId);
			}
			else{
				List<Id> UserIdList = new List<Id>();
				UserIdList.add(Otm.UserId);
				OTMOppMap.put(otm.OpportunityId,UserIdList);
			}
		}
		for(Apttus_Proposal__Proposal__c quote : [Select Id,Apttus_Proposal__Opportunity__c,OwnerId from Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c in: oppIds]){
			quoteIds.add(quote.Id);
			If(quote.Apttus_Proposal__Opportunity__c != null && OppQuoteMap.containskey(quote.Apttus_Proposal__Opportunity__c)){
				OppQuoteMap.get(quote.Apttus_Proposal__Opportunity__c).add(quote.Id);
			}
			else{
				List<Id> quoteIdList = new List<Id>();
				quoteIdList.add(quote.Id);
				OppQuoteMap.put(quote.Apttus_Proposal__Opportunity__c,quoteIdList);
			}
		}
		for(Apttus_Proposal__Proposal__Share proposalShare : [Select id,AccessLevel,ParentId,UserOrGroupId,RowCause,Parent.Apttus_Proposal__Opportunity__c from Apttus_Proposal__Proposal__Share where ParentId in : quoteIds AND UserOrGroupId in :userIdshare]){
			If(proposalShare.ParentId != null && QuoteShareMap.containskey(proposalShare.ParentId)){
				QuoteShareMap.get(proposalShare.ParentId).add(proposalShare.UserOrGroupId);
			}
			else{
				Set<Id> quoteIdset = new Set<Id>();
				quoteIdset.add(proposalShare.UserOrGroupId);
				QuoteShareMap.put(proposalShare.ParentId,quoteIdset);
			}
			}
		for(Id oppId : oppIdsList){
			if(!OppQuoteMap.isEmpty() && OppQuoteMap.containskey(oppId) && !OppQuoteMap.get(oppId).isEmpty()){
				for(Id quote : OppQuoteMap.get(oppId)){
					if(!OTMOppMap.isEmpty() && OTMOppMap.containskey(oppId) && !OTMOppMap.get(oppId).isEmpty()){
						for(Id userId : OTMOppMap.get(oppId)){
							if(!QuoteShareMap.isEmpty() && QuoteShareMap.containskey(quote) && !QuoteShareMap.get(quote).contains(userId)){
								Apttus_Proposal__Proposal__Share share = new Apttus_Proposal__Proposal__Share();
								share.UserOrGroupId = userId;
								share.ParentId  = quote;
								share.AccessLevel = PRMGlobalConstants.EDIT;
								share.RowCause = PRMGlobalConstants.MANUAL;
								quoteShareToOpportunityTeamMemberInsert.add(share);
							}
						}
					}
				}
			}
		}
		System.debug('outinsert'+quoteShareToOpportunityTeamMemberInsert);
		if(!quoteShareToOpportunityTeamMemberInsert.IsEmpty()){
			System.debug('insert'+quoteShareToOpportunityTeamMemberInsert);
			Database.SaveResult[] fdList = Database.insert(quoteShareToOpportunityTeamMemberInsert, false);
		}
	}
}