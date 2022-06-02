/****************************************
 * Trigger Name : DealProductTrigger 
 * Created Date: 2 November 2018
 * Created By : Accenture
 * Last Modified by: Accenture
 * Description : All Deal Product Related Actions will be tracked here
 *****************************************/
trigger DealProductTrigger on DealProduct__c (after Delete) { 
	if(Trigger.isAfter){
		if(Trigger.isDelete){
			DealProductHelper.afterInsertDealProductHelperMethod(Trigger.old);
		}
	}
}