/**
 * @description	   :
 * @author			: Yashdeep Prajapati
 * @group			 :
 * @last modified on  : 10-04-2021
 * @last modified by  : Yashdeep Prajapati
 **/
trigger NokiaCPQ_SitePhaseQuntityTrigger on CPQ_Site_Phase_and_Quantity__c (after update, after delete) {
	system.debug('NokiaCPQ_SitePhaseQuntityTrigger--> ' + Trigger.old);
	system.debug('NokiaCPQ_SitePhaseQuntityTrigger--> ' + Nokia_CPQ_Constants.SKIP_EXECUTION);
	if(!Nokia_CPQ_Constants.SKIP_EXECUTION) {
		if(Trigger.isafter && Trigger.isdelete) // Using context variable.
		{
			NokiaCPQ_SitePhaseQuntityTriggerHandler.sitePhaseConfigCheck(Trigger.old); // Calling apex class method.
		}else if(Trigger.isafter && Trigger.isupdate) // Using context variable.
		{
			NokiaCPQ_SitePhaseQuntityTriggerHandler.afterUpdate(Trigger.new);
		}
	}
}