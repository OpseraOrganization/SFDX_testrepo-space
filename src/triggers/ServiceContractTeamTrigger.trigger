/**
 * Created by bkandov on 01/07/2018.
 */

trigger ServiceContractTeamTrigger on NCP_Service_Contract_Team__c (before insert,
		before update,
		before delete,
		after insert,
		after update,
		after delete) {

	if (!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)) {
		new ServiceContractTeamTriggerHandler().run();
	}
}