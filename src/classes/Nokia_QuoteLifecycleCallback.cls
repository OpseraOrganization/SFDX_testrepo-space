/*
 * Quote Life Cycle Call Back - Use Case 2
 * CreatedDate : 22 July 2019
 */
global with sharing class Nokia_QuoteLifecycleCallback implements Apttus_Proposal.CustomClass.IQuoteLifecycleCallback2 {

Apttus_Proposal__Proposal__c createdProposalSO = null;

/**
 * Callback invoked after a quote/proposal is created from an account
 * @param quoteSO the new quote sobject
 */
global void afterCreateFromAccount(Apttus_Proposal__Proposal__c quoteSO) {

}

/**
 * Callback invoked after a quote/proposal is created from an opportunity
 * @param quoteSO the new quote sobject
 */
global void afterCreateFromOpportunity(Apttus_Proposal__Proposal__c quoteSO) {

}

/**
 * Callback invoked after an agreement is created from a quote/proposal
 * @param quoteSO the quote sobject
 * @param agreementSO the new agreement sobject
 */
global void afterCreateAgreement(Apttus_Proposal__Proposal__c quoteSO, Apttus__APTS_Agreement__c agreementSO) {

}

/**
 * Callback invoked after a quote/proposal is cloned
 * @param originalSO the original quote sobject
 * @param cloneSO the clone quote sobject
 */
global void afterClone(Apttus_Proposal__Proposal__c originalSO, Apttus_Proposal__Proposal__c cloneSO) {
	System.debug('***QuoteLifeCycleCallback > afterClone()-originalSO => ' + originalSO + ' > cloneSO => '+ cloneSO);
	cloneSO.NokiaCPQ_Orignal_Quote_Id__c = originalSO.id;
	System.debug('***QuoteLifeCycleCallback > cloneSO.NokiaCPQ_systemVerifiedContract__c => ' + cloneSO.NokiaCPQ_systemVerifiedContract__c);

	//Added for ITCCPQ-2637 by Christie JJ
	system.debug('[+] cloneSO.CPQ_SubPortfolio__c = '+cloneSO.CPQ_SubPortfolio__c);
	system.debug('[+] cloneSO.CPQ_Portfolio__c = '+cloneSO.NokiaCPQ_Portfolio__c);
	Nokia_CPQ_Utility.Nokia_CPQ_UtilityNoSharing utilObj = new Nokia_CPQ_Utility.Nokia_CPQ_UtilityNoSharing();
	if(utilObj.checkQuoteAccredSoln(cloneSO)) {
		cloneSO.NokiaCPQ_Needs_Reprice__c = true;
	}else if(string.isNotBlank(cloneSO.CPQ_SubPortfolio__c)) {//if subportfolio is there then check if they are still valid
		List<String> validAccreditedSolns= utilObj.fetchSubPortfolios(cloneSO.NokiaCPQ_Portfolio__c,cloneSO.Apttus_Proposal__Account__c);
		if(!validAccreditedSolns.isEmpty()) {
			for(integer i = 0; i<validAccreditedSolns.size(); i++)
			{
	if(!cloneSO.CPQ_SubPortfolio__c.contains(validAccreditedSolns[i]))
	{
		cloneSO.CPQ_SubPortfolio__c = String.join(validAccreditedSolns, ';');
		cloneSO.NokiaCPQ_Needs_Reprice__c = true;
		break;
	}
			}
		}
	}
	system.debug('[+] cloneSO.NokiaCPQ_Needs_Reprice__c = '+cloneSO.NokiaCPQ_Needs_Reprice__c);


	if(cloneSO.NokiaCPQ_systemVerifiedContract__c) {
		Nokia_CPQ_Utility.existingMaintenanceContractCheck(cloneSO);

	}
}

/**
 * Callback invoked before a quote/proposal is cloned
 * @param originalSO the original quote sobject
 * @param cloneSO the clone quote sobject
 */
global void beforeClone(Apttus_Proposal__Proposal__c originalSO, Apttus_Proposal__Proposal__c cloneSO) {
	// System.debug('***QuoteLifeCycleCallback > beforeClone()-originalSO => ' + originalSO + ' > cloneSO => '+ cloneSO);
	// cloneSO.NokiaCPQ_Orignal_Quote_Id__c = originalSO.id;
}

/**
 * Callback invoked after the completion of a lifecycle action
 * @param quoteSO the quote sobject
 * @PARAM actionType the lifecycle action type
 */
global void afterComplete(Apttus_Proposal__Proposal__c quoteSO, Apttus_Proposal.CustomClass.ActionType actionType) {
	System.debug('***QuoteLifeCycleCallback > afterComplete()-Proposal > actionType: ' + actionType+ ', <> quoteSO: ' + quoteSO);
	List<Apttus_Proposal__Proposal__c> newQuote = new List<Apttus_Proposal__Proposal__c>();
	Boolean flag=false;
	newQuote = [select id,Quote_Type__c,Quote_Status__c,Submitted_Date__c,Offer__c from Apttus_Proposal__Proposal__c where Id= : quoteSO.id limit 1];
	if(newQuote[0].Quote_Type__c == 'Direct CPQ' && (newQuote[0].Quote_Status__c != 'Configure' || newQuote[0].Submitted_Date__c != null)) {
		quoteSO.Quote_Status__c='Configure';
		quoteSO.Submitted_Date__c = null;
		flag=true;

	}

	if(newQuote[0].Quote_Type__c == 'Direct CPQ' && newQuote[0].Offer__c!=null)
	{
		quoteSO.Offer__c=null;
		flag=true;

	}
	if(flag)
	{
		update quoteSO;
	}
}

/**
 * Callback invoked after the completion of a lifecycle action
 * @param agreementSO the agreement sobject
 * @PARAM actionType the lifecycle action type
 */
global void afterComplete(Apttus__APTS_Agreement__c agreementSO, Apttus_Proposal.CustomClass.ActionType actionType) {

}
}