/****************************************************************
* Class Name : HWS_ServiceQuoteSharingTrigger 
* Created Date: 05-11-2021
* Created By: TCS
* Description : This Trigger is excuted Whenever ServiceQuote record is 
inserted or updated, then we have to provide ServiceQuote record access 
to customer/business user.
* Modification Log:
---------------------------------------------------------
Modified By	 Modified For US#	Modified Date

******************************************************************/
trigger HWS_ServiceQuoteSharingTrigger on HWS_Service_Quote__c ( after insert, after update, before insert, before update) {
	Boolean byPass = String.IsEmpty((Global_Control__c.getInstance().ObjectTriggerByPass__c))  ? true : !(Global_Control__c.getInstance().ObjectTriggerByPass__c).containsIgnoreCase('Case');
	if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) && byPass && !TriggerHandler.isBypassed('Case')) {
		new HWS_ServiceQuoteSharingTriggerHandler().run();
	}
}