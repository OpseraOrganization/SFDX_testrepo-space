/**
 * Created by bkandov on 06/06/2018.
 */

trigger AuthorisedEntitlementTrigger on NCP_Authorised_Entitlement__c (before insert,
		before update,
		before delete,
		after insert,
		after update,
		after delete,
		after undelete) {

	if (!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)) {
		new AuthorisedEntitlementTriggerHandler().run();
	}
}