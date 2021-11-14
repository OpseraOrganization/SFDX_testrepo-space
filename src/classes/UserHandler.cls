/**
* @description: A handler class for User Trigger.
* @author:	Accenture IDC.
*
* ============================================================================
* History:
* -------
* 
* VERSION AUTHOR		  DATE		DETAIL										  FEATURES/CSR/TTP
* 1.0				   26/12/2016   Sprint 3 Doc Stretegy & LoA requirements.
* ============================================================================ 
*/
public with sharing class UserHandler
{
	
	/**********************************************************************************************************************
* author: Accenture
* Date: Dec-2016
* Param: Map<Id, User> newUserMap, Map<Id, User> oldUserMap
* Return: void
* Description: Handler method for after update operation.
* High Level Process : 
**********************************************************************************************************************/	 
	public static void onAfterUpdate(Map<Id, User> newUserMap, Map<Id, User> oldUserMap)
	{
		try{
			if(!GlobalConstants.STOP_TRIGGER_USER_ON_AFTERUPDATE){
			GlobalConstants.STOP_TRIGGER_USER_ON_AFTERUPDATE = true;
			//UpdateRestrictionLevelHelper.handleUserUpdate(newUserMap, oldUserMap);
			 // To delete share fund with inserted users
			 Set<id> userIdset = new Set<id>(); 
				for(User userinstance : newUserMap.values() ){
					if(oldUserMap.get(userinstance.Id).IsPortalEnabled != newUserMap.get(userinstance.Id).IsPortalEnabled && !(newUserMap.get(userinstance.Id).IsPortalEnabled)){
						userIdset.add(userinstance.id);
					}
			}
			// To add key user in Key Market group
			UserHelper.AddtoKeyUserGroup(newUserMap.values(), oldUserMap);
			
			//Permission Set assignment code
			set<id> userIdAdd = new Set<Id> ();
			set<id> userIdRemove = new Set<Id> ();
			set<id> removeUserFromGroup = new set<Id>();
				
			for(User userNew : newUserMap.values()){
					if((oldUserMap.get(userNew.id).Restriction_Level__c  != GlobalConstants.CONFIDENTIAL_VALUE) && userNew.Restriction_Level__c  == GlobalConstants.CONFIDENTIAL_VALUE){
						userIdAdd.add(userNew.id);
					}else if((oldUserMap.get(userNew.id).Restriction_Level__c  == GlobalConstants.CONFIDENTIAL_VALUE) && userNew.Restriction_Level__c  != GlobalConstants.CONFIDENTIAL_VALUE){
						userIdRemove.add(userNew.id);
					 }
				  if(userNew.IsActive == false && userNew.IsActive <> oldUserMap.get(userNew.id).IsActive)
					{
						removeUserFromGroup.add(userNew.Id);
					}
				}
				if(!userIdAdd.IsEmpty()){
					UserHelper.assignPermissionSetOnInsertUpdate(userIdAdd);
				}
				if(!userIdRemove.IsEmpty()){
					UserHelper.removePermissionSetOnUpdate(userIdRemove);
				}
				 ///Req 5991 - Remove NSA territories when a user's NSA flag is deactivated
				UserHelper.removeUserFromNSATerritory(newUserMap.values(), oldUserMap);
				
			}
		}catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.USER_HANDLER , GlobalConstants.ON_AFTER_UPDATE_ACC );
		}
		
	}
	
	/**********************************************************************************************************************
* author: Accenture
* Date: March-2016
* Param: List<User> userNew, Map<Id, User> oldUserMap
* Return: void
* Description: Handler method for before update operation.
* High Level Process : 
**********************************************************************************************************************/	 
	public static void onBeforeUpdate(List<User> newUserList, Map<Id, User> oldUserMap)
	{
		try{
			if(!GlobalConstants.STOP_TRIGGER_USER_ON_BEFOERUPDATE){
			GlobalConstants.STOP_TRIGGER_USER_ON_BEFOERUPDATE = true;
			UserHelper.updateNSA_Mod(newUserList, oldUserMap);
			UserHelper.updateDeactivationDate(newUserList, oldUserMap);
			UserHelper.updateFederationId(newUserList); 
			
		}
		}catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.USER_HANDLER , GlobalConstants.ON_BEFORE_UPDATE_ACC  );
		}
		
	}
	
	/**********************************************************************************************************************
* author: Accenture
* Date: March-2016
* Param: List<User> userListNew
* Return: void
* Description: Handler method for before Insert operation.
* High Level Process : 
**********************************************************************************************************************/	 
	public static void onBeforeInsert(List<User> newUserList)
	{
		try{
			if(!GlobalConstants.STOP_TRIGGER_USER_ON_BEFOREINSERT){
			GlobalConstants.STOP_TRIGGER_USER_ON_BEFOREINSERT = true;
			UserHelper.updateNSA_Mod(newUserList, new Map<Id,user>());
			UserHelper.updateDeactivationDate(newUserList, new Map<Id,user>());
			//UserHelper.updateUserRole(newUserList);
			UserHelper.updateFederationId(newUserList);
			}
		}catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.USER_HANDLER , GlobalConstants.ON_BEFORE_INSERT_ACC   );
		}
		
	}
	
	/**********************************************************************************************************************
* author: Accenture
* Date: April-2018
* Param: List<User> userListNew
* Return: void
* Description: Handler method for after Insert operation.code bloack for contact field update when partner user created 
	Latest modified : 05/12/2018 by Priyanka Agrawal to add Independent contractor account check for JIT SSO Requirment 
* High Level Process : 
**********************************************************************************************************************/ 
	public static void onAfterInsert(List<User> newUserList){
		try{
		/* comemnted by priyanka as we are wrking on separating out userhandler for PRM and craeting new class to take care of PRM logic
			
		Set<Id> contactIds = new Set<Id>();
		Set<Id> contactPRMIds = new Set<Id>();
		List<User> userList = new List<User>();
		   
			for (User u : newUserList)
			{
				if (u.ContactId != null && (u.ProfileId == system.Label.PRM_Partner_Profile_Id || 
											u.ProfileId == system.Label.PRM_Partner_Relationship_Manager_Login_ID) && (!u.contact.account.name.equals(PRMGlobalConstants.IndependentContractor))){
					contactIds.add(u.ContactId);
				}
				userList.add(u); 
				
				System.debug('user-->'+u);
				
			}
		
			if (contactIds.size() > 0) {
				ContactUpdateWithNewTool.updateContacts(contactIds);
			}*/
		
			/* comemnted by sonali as we are wrking on separating out userhandler for PRM and craeting new class to take care of PRM logic
		 
		   if (!userList.IsEmpty()) {
				Database.executeBatch(new CoOpFundBatch(userList));
			} */
			//Permission Set assignment code
			set<id> userIdAdd = new Set<Id> ();
			for(User userNew : newUserList){
				if(userNew.Restriction_Level__c == GlobalConstants.CONFIDENTIAL_VALUE){
					userIdAdd.add(userNew.id);
				}		 
				
				
			}  
			UserHelper.assignPermissionSetOnInsertUpdate(userIdAdd);
			
			
		}catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.UserHandler,PRMGlobalConstants.afterInsertOperation);}
	}

  
		
}