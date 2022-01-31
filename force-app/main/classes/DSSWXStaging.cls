/****************************************
 * Class Name : DSSWXStaging 
 * Created Date: 16 july 2018
 * Created By : Accenture
 * Last Modified by: Accenture
 * Description : create DStaging and interface log record based on  Json request			  
 *****************************************/
@RestResource(urlMapping='/DSSWXStaging/*')
global with sharing class DSSWXStaging
{   
	@HttpPost
	/****************************************
 * Method Name : UpsertUpsellProposal 
 * Created Date: 20 Nov 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Description : Insert SWx Upsell Proposal and SWx Upsell Items from input JSON request
 * Parameter :			
 *****************************************/
	global static void UpsertUpsellProposal(){
		DS_StagingHelper.UpsertSWXDSStaging();
	}
}