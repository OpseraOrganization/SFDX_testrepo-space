/****************************************
 * Class Name : SWX_CreateUpsellProposal_Webservice 
 * Created Date: 20 Nov 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Description : Insert SWx Upsell Proposal and SWx Upsell Items from input JSON request
			  
 *****************************************/
@RestResource(urlMapping='/upsertUpsellProposal/*')
global with sharing class SWX_CreateUpsellProposal_Webservice  
{   
	@HttpPost
	global static void UpsertUpsellProposal(){
		//CCRE_CreateUpsellProposalHelper.UpsertProposal();
	}
}