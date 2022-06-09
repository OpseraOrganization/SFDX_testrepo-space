/**
 * @description	   :
 * @author			: Yashdeep Prajapati
 * @group			 :
 * @last modified on  : 07-09-2021
 * @last modified by  : Yashdeep Prajapati
 * Modifications Log
 * Ver   Date		 Author			   Modification
 * 1.0   07-09-2021   Yashdeep Prajapati   Initial Version
 **/
public without sharing class NokiaCPQ_ProposalTriggerHelper_NoSharing {
// Quote versioning Logic for Direct/Indirect Quotes.
//added by surinder
public static void quoteVersioningMethod(List<Apttus_Proposal__Proposal__c> directAndDirectQuotes){
	
	Set<ID> oppIdSet= new Set<ID>();
	Set<String> quoteIdSet= new Set<String>();
	Map<Id,Opportunity> oppIdwithOpp= new Map<Id,Opportunity>();

	Map<Id,List<Apttus_Proposal__Proposal__c> > oppWithListQuotes= new Map<Id,List<Apttus_Proposal__Proposal__c> >();
	for(Apttus_Proposal__Proposal__c objQuote:directAndDirectQuotes) {
		oppIdSet.add(objQuote.Apttus_Proposal__Opportunity__c);
	}
	try{
		for(Opportunity oppRec:[SELECT id,Name,Opportunity_ID__c,NokiaCPQ_Quote_Count__c FROM Opportunity WHERE id IN:oppIdSet FOR UPDATE]) {
			oppIdwithOpp.put(oppRec.id,oppRec);
		}
	}catch(QueryException e) {

	}
	for(Apttus_Proposal__Proposal__c objQuote:[SELECT id,NokiaCPQ_Proposal_Id__c,CPQ_Is_Rebid_Completed__c,Parent_Rebid_Quote__c,Apttus_Proposal__Opportunity__c FROM Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Opportunity__c IN:oppIdSet and Parent_Rebid_Quote__c=null]) {

		quoteIdSet.add(objQuote.NokiaCPQ_Proposal_Id__c);
		if (oppWithListQuotes.containsKey(objQuote.Apttus_Proposal__Opportunity__c))
		{
			oppWithListQuotes.get(objQuote.Apttus_Proposal__Opportunity__c).add(objQuote);
		}else{
			oppWithListQuotes.put(objQuote.Apttus_Proposal__Opportunity__c,new List<Apttus_Proposal__Proposal__c> {objQuote});
		}

	}

	for(Apttus_Proposal__Proposal__c objQuote1:directAndDirectQuotes) {

		if(!objQuote1.DI_Rebid__c) {
			objQuote1.Parent_Rebid_Quote__c=null;

			if(!oppWithListQuotes.isEmpty() && oppWithListQuotes.get(objQuote1.Apttus_Proposal__Opportunity__c).size()>0) {

	Integer count= oppWithListQuotes.get(objQuote1.Apttus_Proposal__Opportunity__c).size();
	count=count+1;

	objQuote1.NokiaCPQ_Proposal_Id__c=oppIdwithOpp.get(objQuote1.Apttus_Proposal__Opportunity__c).Opportunity_ID__c + ' ' + 'Q' +' '+ count;

	objQuote1.isFirstRebidQuote__c=true;
			}else{
	objQuote1.NokiaCPQ_Proposal_Id__c=oppIdwithOpp.get(objQuote1.Apttus_Proposal__Opportunity__c).Opportunity_ID__c + ' ' + 'Q' + ' '+1;
	objQuote1.isFirstRebidQuote__c=true;
			}
		}else{
			objQuote1.isFirstRebidQuote__c=true;
		}



		// update newList;
	}


}

}