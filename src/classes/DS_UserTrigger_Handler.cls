/******************************************************************************************************
Name : DS_UserTrigger_Handler 
Created Date: 29 Jan 2019
Created by: Accenture
Description : This class is used for processing only the Record sharing with Account manager and DMP users.	  
*********************************************************************************************************/
public without sharing class DS_UserTrigger_Handler {
	
	/******************************************************************************************************
	Name : processOnlyDMPUser
	Created Date: 29 Jan 2019
	Created by: Accenture
	Description : This method will call the fucntionality for sharing records with DMP users and Account manager.   
	*********************************************************************************************************/
	
	public static void processOnlyDMPUser(Map<Id,User> userMap) {
	
		DS_UserTrigger_Helper.shareCustomerUserWithAM(userMap.keySet());
		DS_UserTrigger_Helper.shareCustomerUserWithPublicGroup(userMap.keySet());
		DS_UserTrigger_Helper.shareDSQuoteWithNewlyCreatedCustomer(userMap.keySet());
	
	}
}