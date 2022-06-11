/******************************************************************************************************
Name : Territory2Trigger
Created Date: JULY 2020
Created by: CO Dev
Description : To handle insert,update,delete/mass on Territory
*********************************************************************************************************/
trigger Territory2Trigger on Territory2  (before insert, after delete)
{
	new Territory2TriggerHandler().run();
}