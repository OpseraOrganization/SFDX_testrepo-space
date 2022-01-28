/******************************************************************************************************
Name : CollaborationGroupTrigger 
Created Date: FEB 2021
Created by: HCL
Description : To handle insert,update,delete/mass DML on CollaborationGroup
*********************************************************************************************************/
trigger CollaborationGroupTrigger on CollaborationGroup (before insert,before update, after insert,after update, before delete) {
	//Skipping for Data Load Profile
	if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id))
	{
		//Calling CollaborationGroupTriggerHandler.
		new CollaborationGroupTriggerHandler().run();
	}
}