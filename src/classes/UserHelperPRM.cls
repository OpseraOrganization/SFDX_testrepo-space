/**
 * @description: A helper class for User Trigger.
 * @author:	Accenture IDC.
 *
 * ============================================================================
 * History:
 * -------
 * 
 * API VERSION		   DATE		 DETAIL
 * 39.0				  06/03/2017   Sprint 5 Account, Contact and Lead requirements.
 * ============================================================================ 
 */
public with sharing class UserHelperPRM {
	/**********************************************************************************************************************
	* author: Accenture
	* Date: FEB - 2018
	* Param: List<User> newUserId
	* Return: void
	* Description: Helper method for setting "UserPreferencesShowEmailToExternalUsers" for external users
	* High Level Process : 
	**********************************************************************************************************************/ 
	public static void updateShowEmailToExternalUsers(List<User> newUserId){
		try{
			List<user> userToUpdate = new List<User>();
			for(User newUsr : newUserId){
				if((newUsr.ProfileId == system.label.PRM_Partner_Profile_Id) || (newUsr.ProfileId == system.label.PRM_Partner_Relationship_Manager_Login_ID)){   
					newUsr.UserPreferencesShowEmailToExternalUsers=true;
				}
			}
		 }
		catch(Exception Ex){
			ExceptionHandler.addException(Ex,GlobalConstants.USER_HELPER, PRMGlobalConstants.updateShowEmailToExternalUsers);
		}
	}  
/**********************************************************************************************************************
	* author: Accenture
	* Date: MAY - 2018
	* Return: void
	* Description: Helper method for removing fund share record "unshareFundOnUserDeactivation" 
	* High Level Process : 
	**********************************************************************************************************************/ 
	public static void unshareFundOnUserDeactivation(Set<id> userIdset){		
		try{	
			List<Fund__Share> shareList = [Select Id from Fund__Share where UserOrGroupId in : userIdset 
										   Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			if(!shareList.IsEmpty()){
				Database.DeleteResult[] fndList = Database.delete(shareList, false);
			}
		}catch(Exception Ex){
			ExceptionHandler.addException(Ex,GlobalConstants.USER_HELPER,PRMGlobalConstants.unshareFundOnUserDeactivation);
		}

	}


}