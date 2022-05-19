/**
 * @description	   :
 * @author			: Yashdeep Prajapati
 * @group			 :
 * @last modified on  : 09-24-2021
 * @last modified by  : Yashdeep Prajapati
 * Modifications Log
 * Ver   Date		 Author			   Modification
 * 1.0   06-16-2021   Yashdeep Prajapati   Initial Version
 **/
public inherited sharing class NokiaCPQ_CloneSitePhase implements Queueable {
Map<string,string> proposalMap = new Map<string,string>();
//Map<Id,Apttus_Proposal__Proposal__c> nProposal = new Map<Id,Apttus_Proposal__Proposal__c>();
public NokiaCPQ_CloneSitePhase(Map<string,string> proposalMap){
	this.proposalMap = proposalMap;
}
public void execute(QueueableContext context) {
	for(String quoteId :proposalMap.keyset()) {
		Nokia_CPQ_Utility.cloneSiteConfiguration(quoteId, proposalMap.get(quoteId));
		Nokia_CPQ_Utility.cloneSitePhaseQuanity(quoteId, proposalMap.get(quoteId));
	}
}
}