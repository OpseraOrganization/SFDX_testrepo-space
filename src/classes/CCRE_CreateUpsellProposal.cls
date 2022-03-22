/****************************************
 * Class Name : CCRE_CreateUpsellProposal
 * Created Date: 2 Nov 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Description : Insert CCRE Upsell Proposal and CCRE Contract Items from input Json request
			  
 *****************************************/
@RestResource(urlMapping='/ccreCreateUpsellProposal/*')
global with sharing class CCRE_CreateUpsellProposal  
{
	/* insert ccre record */
	@HttpPost
	global static void CCRE_UpsertProposal()
	{
		CCRE_CreateUpsellProposalHelper.CCRE_UpsertNewProposal();
	}
}