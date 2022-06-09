/****************************************
 * Trigger Name : AccreditationTrigger 
 * Created Date: April 2019
 * Created By : Accenture
 * Last Modified by: 
 * Last Modified Date: 
 * Description : Trigger on Platfrm event-product availality from Ipass-SWMP
 *****************************************/
 
trigger DSProductNotificationEvent on DS_Products_Notification__e (after insert) {
   try{
	   if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
			if(Trigger.isAfter){
				if(Trigger.isInsert){
				   //Since Eccenca is sending only one record at a time so passing one record  for processing.
					DSProductNotificationEventHelper.afterInsertOperation(Trigger.new[0]); 
				}
			}
	   }
 
	}
 
	catch(Exception e){ExceptionHandler.addException(e,
					'DSProductNotificationEvent Trigger','DSProductNotificationEvent Trigger');} 

}