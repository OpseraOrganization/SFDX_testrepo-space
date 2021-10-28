/******************************************************************************************************
Name : SalesRoleTrigger
Created Date: JULY 2018
Created by: Accenture
Description : To handle insert,update,delete/mass DML on Sales Role Table
*********************************************************************************************************/
trigger SalesRoleTrigger on Sales_Role__c  (before insert,before update, after insert,after update, before delete)
{
	if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id))
	{
		new SalesRoleTriggerHandler().run();
	}
}