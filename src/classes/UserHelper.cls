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
public with sharing class UserHelper {
	/**********************************************************************************************************************
	* author: Accenture
	* Date: Mar-2017
	* Param: List<User> newUserList
	* Return: void
	* Description: Helper method for before update and insert operation.
					Add the NSA Compliant flag change timestamp 
					Method to populate NSA_Modified__c field
					Requirement No. 774 
	* High Level Process : 
**********************************************************************************************************************/
	public static void updateNSA_Mod(List<User> newUserList, Map<Id, User>oldUserMap) {

		try {
			for (User newUser : newUserList) {
				//Running User List in for loop

				if (oldUserMap.size() == 0 && newUser.NSA_Compliant__c) {
					//Checking if values in oldMap is not null and the NSA compliant is checked, if yes then update value

					newUser.NSA_Modified__c = System.now();
					//assigning NSA Modified field with the current Date/Time

				} else if (oldUserMap.size() > 0 && newUser.NSA_Compliant__c != oldUserMap.get(newUser.Id).NSA_Compliant__c) {
					//If Old value set is null then compare the old and new values and update if not equals

					newUser.NSA_Modified__c = System.now();
					//assigning NSA Modified field with the current Date/Time

				}
				system.debug('newUser.NSA_Modified__c ......in updateNSA_Mod' + newUser.NSA_Modified__c);
			}
		} catch (Exception Ex) {
			ExceptionHandler.addException(Ex, GlobalConstants.USER_HELPER, GlobalConstants.UPDATE_NSA_MOD_USER);

		}
	}
	/********************
	*Method Name: updateDeactivationDate
	*Parameter: new User List,old user map
	*Description:Method to populate Deactivation_Date__c field
	*******************/
	public static void updateDeactivationDate(List<User> newUserList, Map<Id, User>oldUserMap) {

		try {
			for (User newUser : newUserList) {
				//Running User List in for loop

				if (oldUserMap.size() > 0 && newUser.IsActive == false && oldUserMap.get(newUser.Id).IsActive == true) {
					//If Old value set is null then compare the old and new values and update if not equals

					//newUser.Deactivation_Date__c = System.now();
					newUser.Deactivation_Date__c = Date.Today();
					//assigning Deactivation_Date__c field with the current Date/Time
				} else if (oldUserMap.size() > 0 && newUser.IsActive == true && oldUserMap.get(newUser.Id).IsActive == false) {
					newUser.Deactivation_Date__c = null;
				}

				system.debug('newUser.Deactivation_Date__c ......in updateDeactivationDate' + newUser.Deactivation_Date__c);
			}
		} catch (Exception Ex) {
			ExceptionHandler.addException(Ex, GlobalConstants.USER_HELPER, GlobalConstants.UPDATE_DEACTIVATION_DATE);

		}
	}
	/********************
*Method Name: AddtoKeyUserGroup
*Parameter: new User List,old user map
*Description:Method to add the Key user in Public Group
*******************/
	public static void AddtoKeyUserGroup(List<User> newUserList, Map<Id, User>oldUserMap) {
		set <ID> keyUserIDSet = new set <ID>();
		try {
			for (User newUser : newUserList)

			{
				If (OldUserMap.Containskey(newUser.id)) {
					If ((oldUserMap.get(newUser.Id).Is_Key_User__c == false && newUser.Is_Key_User__c == True) || (oldUserMap.get(newUser.Id).Is_Key_User__c == True && newUser.Is_Key_User__c == False)) {
						keyUserIDSet.add(newUser.id);
					}
				}
			}

			if (keyUserIDSet != null && keyUserIDSet.size() > 0) {

				ID jobID = System.enqueueJob(new AddKeyUserToPGQueue(keyUserIDSet));
				System.debug('Quable job id for user update is: ' + jobID);
			}
		} catch (Exception Ex) {
			ExceptionHandler.addException(Ex, GlobalConstants.USER_HELPER, GlobalConstants.ADD_TO_KEY_USER_GROUP);

		}
	}

	/**********************************************************************************************************************
	* author: Accenture
	* Date: AUG-2017
	* Param: List<User> newUserList
	* Return: void
	* Description: Helper method for before update and insert operation.
				   Copy NokiaId in Federation Id
					Requirement No. 2131
	* High Level Process :
	**********************************************************************************************************************/
	public static void updateFederationId(List<User> newUserList) {
		//String customerUserProfile = NCP_CustomerCommunitySetting__c.getValues('Default').Customer_User_Profile__c;
		//String customerLoginUserProfile = NCP_CustomerCommunitySetting__c.getValues('Default').NCP_Customer_Login_Profile__c;
		String customerUserProfile = NCP_Constants.PROFILE_CUSTOMERS;
		String customerLoginUserProfile = NCP_Constants.PROFILE_LOGIN_CUSTOMERS;

		List<Profile> profiles = [Select Id,Name from Profile Where Name IN (:customerUserProfile, :customerLoginUserProfile)];
		String customerProfileId = '';
		String customerLoginProfileId = '';

		for (Profile p : profiles) {
			if (p.Name == customerUserProfile) {
				customerProfileId = p.Id;
			} else if (p.Name == customerLoginUserProfile) {
				customerLoginProfileId = p.Id;
			}
		}

		try {
			if (!Schema.sObjectType.User.fields.FederationIdentifier.isUpdateable()) {
				return;
			}
			for (User newUsr : newUserList) {
				system.debug('newUsr.Profile.Name.....' + newUsr.Profile.Name);
				system.debug('newUsr.ProfileId.....' + newUsr.ProfileId);
				if (newUsr.ProfileId <> system.label.PRM_Partner_Profile_Id && newUsr.ProfileId <> system.label.PRM_Partner_Relationship_Manager_Login_ID && newUsr.ProfileId <> system.label.PRM_Unauthorized_Partner_Profile && newUsr.ProfileId<> customerProfileId && newUsr.ProfileId <> customerLoginProfileId) {
					if (newUsr.FederationIdentifier == NULL || newUsr.FederationIdentifier != newUsr.Nokia_ID__c) {
						if (newUsr.Nokia_ID__c <> NULL) newUsr.FederationIdentifier = newUsr.Nokia_ID__c;
					}
				}
			}
		} catch (Exception Ex) {
			ExceptionHandler.addException(Ex, GlobalConstants.USER_HELPER, GlobalConstants.UPDATE_FEDERATION_ID);

		}
	}

	/**********************************************************************************************************************
* author: Accenture
* Date: June-2018
* Param: List<User> userListNew, userOldMap
* Return: void
* Description: Helper method for after update/Insert operation Add permission set to user
**********************************************************************************************************************/
	@future
	public static void assignPermissionSetOnInsertUpdate(Set<id> userIdset) {
		PermissionSet confiPermissionSet = new PermissionSet();
		confiPermissionSet = [SELECT Id,Name FROM PermissionSet WHERE Name = :GlobalConstants.CONFIDENTIAL_FILES_PERMISSION Limit 1];

		List<PermissionSetAssignment> permissionSetAssignmentList = new List<PermissionSetAssignment>();
		try {
			for (Id userInstance : userIdset) {
				PermissionSetAssignment instance = new PermissionSetAssignment();
				instance.AssigneeId = userInstance;
				instance.PermissionSetId = confiPermissionSet.Id;
				permissionSetAssignmentList.add(instance);
			}
			if (!permissionSetAssignmentList.IsEmpty()) {
				Database.Insert(permissionSetAssignmentList);
			}
		} catch (Exception Ex) {
			ExceptionHandler.addException(Ex, GlobalConstants.USER_HELPER, GlobalConstants.assignPermissionSetOnInsertUpdate);
		}

	}
	/**********************************************************************************************************************
* author: Accenture
* Date: June-2018
* Param: List<User> userListNew, userOldMap
* Return: void
* Description: Helper method for after update operation delete permission set from user
**********************************************************************************************************************/
	@future
	public static void removePermissionSetOnUpdate(Set<id> userIdset) {
		PermissionSet confiPermissionSet = new PermissionSet();
		confiPermissionSet = [SELECT Id,Name FROM PermissionSet WHERE Name = :GlobalConstants.CONFIDENTIAL_FILES_PERMISSION Limit 1];
		List<PermissionSetAssignment> permissionSetAssignmentList = new List<PermissionSetAssignment>();
		try {
			for (PermissionSetAssignment Instance : [SELECT AssigneeId,Id,PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId IN:userIdset AND PermissionSetId = :confiPermissionSet.Id LIMIT:Limits.getLimitQueryRows() - Limits.getQueryRows()]) {
				permissionSetAssignmentList.add(Instance);
			}
			if (!permissionSetAssignmentList.IsEmpty()) {
				Database.Delete(permissionSetAssignmentList);
			}
		} catch (Exception Ex) {
			ExceptionHandler.addException(Ex, GlobalConstants.USER_HELPER, GlobalConstants.removePermissionSetOnUpdate);
		}

	}

	/*
	* @author AES (salesforce)
	* @description create apex sharing when the portal user is enabled
	* @param list users
	* @return null
	*/

	public static void createAccountContactRelationShare(List<User> newUserList) {
		Set<Id> contIds = new Set<Id>();
		Map<Id, AccountContactRelation> acrMap = new Map<Id, AccountContactRelation>();
		for (User newUsr : newUserList) {
			if (String.isNotBlank(newUsr.contactId)) {
				contIds.add(newUsr.contactId);
			}
		}
		system.debug('### AES newUserList ' + newUserList);
		if (!contIds.isEmpty()) {
			for (AccountContactRelation acr : [Select Id,NCP_Entitlement_Relationship__c,AccountId,ContactId From AccountContactRelation where NCP_Entitlement_Relationship__c = true and ContactId IN:contIds]) {
				acrMap.put(acr.Id, acr);
			}
			system.debug('### AES acrMap ' + acrMap);
			if (!acrMap.isEmpty()) {
				System.enqueueJob(new NCP_AccountSharingQueueable(acrMap));
			}
		}
	}

	/****************************************
		* Name : removeUserFromNSATerritory
		* Description : Add or Remove user from NSA public group
		* Parameters: User new List, User old map
		* Returns : NA
	*****************************************/
	public static void removeUserFromNSATerritory(List<User> userList,Map<Id,User> userOldMap)
	{
		try{
			Set<Id> userIds = new Set<Id>();
			for(User u : userList)
			{
				if(userOldMap.get(u.Id).NSA_Compliant__c == true && u.NSA_Compliant__c == false){
					userIds.add(u.Id);
				}
			}
			List<UserTerritory2Association> userTerrAssoc = [SELECT Id
			FROM UserTerritory2Association
			WHERE Territory2.NSA_Territory__c = true
			AND UserId in :userIds];
			if(userTerrAssoc <> null && !userTerrAssoc.isEmpty())
			{
				Database.Delete(userTerrAssoc,false);
			}
		}catch(Exception ex){
			ExceptionHandler.addException(ex,GlobalConstants.USER_HELPER,GlobalConstants.removeUserFromNSATerritory);
		}
	}

	public static void createAuthorizedEntitlements(List<User> newUserList) {
		Map<Id, Id> contIdsToUserIds = new Map<Id, Id>();
		for (User newUsr : newUserList) {
			if (String.isNotBlank(newUsr.contactId)) {
				contIdsToUserIds.put(newUsr.contactId, newUsr.Id);
			}
		}

		List<NCP_Authorised_Entitlement__c> authorisedEntitlements = [
				SELECT Id,NCP_Contact__c,NCP_Account__c,NCP_External_Status__c
				FROM NCP_Authorised_Entitlement__c
				WHERE NCP_External_Status__c =: NCP_Constants.STATUS_ACTIVE AND NCP_Contact__c IN:contIdsToUserIds.keySet()
		];

		if (authorisedEntitlements.isEmpty() == false) {
			Map<Id, Set<Id>> aeUsers = new Map<Id, Set<Id>>();

			for (NCP_Authorised_Entitlement__c ae : authorisedEntitlements) {
				Id userId = contIdsToUserIds.get(ae.NCP_Contact__c);
				if (aeUsers.containsKey(ae.Id) == false) {
					aeUsers.put(ae.Id, new Set<Id>());
				}
				aeUsers.get(ae.Id).add(userId);
			}
			AuthorisedEntitlementShareSync.createAuthorisedEntitlementShares(aeUsers);
		}
	}


}