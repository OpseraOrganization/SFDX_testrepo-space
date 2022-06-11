/**
 * Created by tweinberger on 06/09/2018.
 */
trigger ContractLineItemTrigger on ContractLineItem (
	before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete) {
   if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)) {
		new ContractLineItemTriggerHandler().run();
		new CH_ContractLineItemTriggerHandler().run();
	   
   }
}