/**
 *
 * @description: A helper class for User Trigger.
 * @author: Accenture IDC.
 * Modified By: HCL Technologies
 * ============================================================================
 * History:
 * -------
 *
 * API VERSION   DATE	   DETAIL
 * 39.0   06/03/2017   Sprint 5 Account,Contact and Lead requirements.
 * 49.0   10/02/2021   Access modifier change from public to private of method solveUsers
 * ============================================================================
 */
public with sharing class UserTriggerHelper
{
	/**********************************************************************************************************************
	* author: Accenture
	* Date: Mar-2017
	* Param: List<User> newUserList
	* Return: void
	* Description: Helper method for before update and insert operation.
	* Add the NSA Compliant flag change timestamp
	* Method to populate NSA_Modified__c, NSA_Class_A_Modified__c and NSA_GEN_IT_SDHLR_Modified__c fields
	* Requirement No. 774
	* High Level Process :
	**********************************************************************************************************************/
	public static void updateNSA_Mod(Map<Id,User>oldUserMap,Map<Id,User>newUserMap)
	{
		try{
			for (User newUser : newUserMap.values()){
				if ((oldUserMap.size() == 0 && newUser.NSA_Compliant__c) || (oldUserMap.size() > 0 && newUser.NSA_Compliant__c != oldUserMap.get(newUser.Id).NSA_Compliant__c)){
					//Checking if values in oldMap is not null or null and the NSA compliant is checked,if yes then update value
					newUser.NSA_Modified__c = System.now();
					//assigning NSA Modified field with the current Date/Time
				}if ((oldUserMap.size() == 0 && newUser.NSA_Class_A__c) || (oldUserMap.size() > 0 && newUser.NSA_Class_A__c != oldUserMap.get(newUser.Id).NSA_Class_A__c)){ //change related to DEM0060769					
					newUser.NSA_Class_A_Modified__c = System.now();					
				}if ((oldUserMap.size() == 0 && newUser.NSA_GEN_IT_SDHLR__c) || (oldUserMap.size() > 0 && newUser.NSA_GEN_IT_SDHLR__c != oldUserMap.get(newUser.Id).NSA_GEN_IT_SDHLR__c)){ //change related to DEM0060769				   
					newUser.NSA_GEN_IT_SDHLR_Modified__c = System.now();					
				}
			}
		}
		catch (Exception Ex)
		{
			ExceptionHandler.addException(Ex,GlobalConstants.USER_HELPER,GlobalConstants.UPDATE_NSA_MOD_USER);
		}
	}
	/********************
	*Method Name: updateDeactivationDate
	*Parameter: new User List,old user map
	*Description:Method to populate Deactivation_Date__c field
	*******************/
	public static void updateDeactivationDate(Map<Id,User>oldUserMap,Map<Id,User>newUserMap)
	{
		try{
			for (User newUser : newUserMap.values()){
				//Running User List in for loop
				if (oldUserMap.size() > 0 && newUser.IsActive == false && oldUserMap.get(newUser.Id).IsActive == true){
					//If Old value set is null then compare the old and new values and update if not equals
					newUser.Deactivation_Date__c = Date.Today();
					//assigning Deactivation_Date__c field with the current Date/Time
				}
				else if (oldUserMap.size() > 0 && newUser.IsActive == true && oldUserMap.get(newUser.Id).IsActive == false){
					newUser.Deactivation_Date__c = null;
				}
			}
		}
		catch (Exception Ex){
			ExceptionHandler.addException(Ex,GlobalConstants.USER_HELPER,GlobalConstants.UPDATE_DEACTIVATION_DATE);
		}
	}
	/********************
	*Method Name: AddtoKeyUserGroup
	*Parameter: new User List,old user map
	*Description:Method to add the Key user in Public Group
	*******************/
	public static void AddtoKeyUserGroup(Map<Id,User>oldUserMap,Map<Id,User>newUserMap)
	{
		set <ID> keyUserIDSet = new set <ID>();
		try{
			for (User newUser : newUserMap.values()){
				if (OldUserMap.Containskey(newUser.id) && (oldUserMap.get(newUser.Id).Is_Key_User__c != newUser.Is_Key_User__c)){
					keyUserIDSet.add(newUser.id);
				}
			}
			if (keyUserIDSet != null && keyUserIDSet.size() > 0){
				ID jobID = System.enqueueJob(new AddKeyUserToPGQueue(keyUserIDSet));
			}
		}
		catch (Exception Ex)
		{
			ExceptionHandler.addException(Ex,GlobalConstants.USER_HELPER,GlobalConstants.ADD_TO_KEY_USER_GROUP);
		}
	}

	/**********************************************************************************************************************
	* author: Accenture
	* Date: AUG-2017
	* Param: List<User> newUserList
	* Return: void
	* Description: Helper method for before update and insert operation.
	* Copy NokiaId in Federation Id
	* Requirement No. 2131
	* High Level Process :
	**********************************************************************************************************************/
	public static void updateFederationId(Map<Id,User>oldUserMap,Map<Id,User>newUserMap)
	{
		String customerUserProfile = NCP_Constants.PROFILE_CUSTOMERS;
		String customerLoginUserProfile = NCP_Constants.PROFILE_LOGIN_CUSTOMERS;

		List<Profile> profiles = [Select Id,Name from Profile Where Name IN (:customerUserProfile,:customerLoginUserProfile)];
		String customerProfileId = '';
		String customerLoginProfileId = '';

		for (Profile p : profiles) {
			if (p.Name == customerUserProfile){
				customerProfileId = p.Id;
			}
			else if (p.Name == customerLoginUserProfile){
				customerLoginProfileId = p.Id;
			}
		}

		try{
			if (!Schema.sObjectType.User.fields.FederationIdentifier.isUpdateable()){
				return;
			}
			set<Id> setValidIDtoCheckWithNewUser = new set<Id>();
			setValidIDtoCheckWithNewUser.add((Id)system.label.PRM_Partner_Profile_Id);
			setValidIDtoCheckWithNewUser.add((Id)system.label.PRM_Partner_Relationship_Manager_Login_ID);
			setValidIDtoCheckWithNewUser.add((Id)system.label.PRM_Unauthorized_Partner_Profile);
			setValidIDtoCheckWithNewUser.add((Id)customerProfileId);
			setValidIDtoCheckWithNewUser.add((Id)customerLoginProfileId);
			
			for (User newUsr : newUserMap.values()){
				if(!setValidIDtoCheckWithNewUser.contains(newUsr.ProfileId) && (newUsr.FederationIdentifier == NULL || newUsr.FederationIdentifier != newUsr.Nokia_ID__c) && newUsr.Nokia_ID__c <> NULL ){
					newUsr.FederationIdentifier = newUsr.Nokia_ID__c;
				}
				
				/*if (newUsr.ProfileId <> system.label.PRM_Partner_Profile_Id && newUsr.ProfileId <> system.label.PRM_Partner_Relationship_Manager_Login_ID && newUsr.ProfileId <> system.label.PRM_Unauthorized_Partner_Profile && newUsr.ProfileId<> customerProfileId && newUsr.ProfileId <> customerLoginProfileId)
				{
					if (newUsr.FederationIdentifier == NULL || newUsr.FederationIdentifier != newUsr.Nokia_ID__c){
						if(newUsr.Nokia_ID__c <> NULL) {
							newUsr.FederationIdentifier = newUsr.Nokia_ID__c;
						}
					}
				}*/
			}
		}
		catch (Exception Ex){
			ExceptionHandler.addException(Ex,GlobalConstants.USER_HELPER,GlobalConstants.UPDATE_FEDERATION_ID);
		}
	}

	/**********************************************************************************************************************
	* author: Accenture
	* Date: June-2018
	* Param: List<User> userListNew,userOldMap
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
			ExceptionHandler.addException(Ex,GlobalConstants.USER_HELPER,GlobalConstants.assignPermissionSetOnInsertUpdate);
		}

	}
	/**********************************************************************************************************************
	* author: Accenture
	* Date: June-2018
	* Param: List<User> userListNew,userOldMap
	* Return: void
	* Description: Helper method for after update operation delete permission set from user
	**********************************************************************************************************************/
	@future
	public static void removePermissionSetOnUpdate(Set<id> userIdset) {
		PermissionSet confiPermissionSet = new PermissionSet();
		confiPermissionSet = [SELECT Id,Name FROM PermissionSet WHERE Name = :GlobalConstants.CONFIDENTIAL_FILES_PERMISSION Limit 1 ];
		List<PermissionSetAssignment> permissionSetAssignmentList = new List<PermissionSetAssignment>();
		try {
			for (PermissionSetAssignment instance : [SELECT AssigneeId,Id,PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId IN:userIdset AND PermissionSetId = :confiPermissionSet.Id LIMIT:Limits.getLimitQueryRows() - Limits.getQueryRows()]) {
	permissionSetAssignmentList.add(instance);
			}
			if (!permissionSetAssignmentList.IsEmpty()) {
	Database.Delete(permissionSetAssignmentList);
			}
		} catch (Exception Ex) {
			ExceptionHandler.addException(Ex,GlobalConstants.USER_HELPER,GlobalConstants.removePermissionSetOnUpdate);
		}

	}

	/*
	* @author AES (salesforce)
	* @description create apex sharing when the portal user is enabled
	* @param list users
	* @return null
	*/

	public static void createAccountContactRelationShare(Map<Id,User>oldUserMap,Map<Id,User>newUserMap)
	{
		Set<Id> contIds = new Set<Id>();
		Map<Id,AccountContactRelation> acrMap = new Map<Id,AccountContactRelation>();
		for (User newUsr : newUserMap.values()){
			if (String.isNotBlank(newUsr.contactId)){
				contIds.add(newUsr.contactId);
			}
		}
		if(!contIds.isEmpty()){
			for (AccountContactRelation acr : [Select Id,NCP_Entitlement_Relationship__c,AccountId,ContactId From AccountContactRelation where NCP_Entitlement_Relationship__c = true and ContactId IN:contIds]){
				acrMap.put(acr.Id,acr);
			}
			if (!acrMap.isEmpty()){
				System.enqueueJob(new NCP_AccountSharingQueueable(acrMap));
			}
		}
	}

	/****************************************
	* Name : removeUserFromNSATerritory
	* Description : Add or Remove user from NSA public group
	* Parameters: User new List,User old map
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
			AND UserId in :userIds ];
			if(userTerrAssoc <> null && !userTerrAssoc.isEmpty())
			{
	Database.Delete(userTerrAssoc,false);
			}
		}catch(Exception ex){
			ExceptionHandler.addException(ex,GlobalConstants.USER_HELPER,GlobalConstants.removeUserFromNSATerritory);
		}
	}
	
	/*********************************************************************************************
	* Param:user old map and user new map
	* Return: void
	* Description: Helper method to create authorization entitlements
	**********************************************************************************************/
	public static void createAuthorizedEntitlements(Map<Id,User>oldUserMap,Map<Id,User>newUserMap)
	{
		Map<Id,Id> contIdsToUserIds = new Map<Id,Id>();
		for (User newUsr : newUserMap.values())
		{
			if (String.isNotBlank(newUsr.contactId))
			{
	contIdsToUserIds.put(newUsr.contactId,newUsr.Id);
			}
		}

		List<NCP_Authorised_Entitlement__c> authorisedEntitlements = [ SELECT Id,NCP_Contact__c,NCP_Account__c,NCP_External_Status__c
	FROM NCP_Authorised_Entitlement__c
	WHERE NCP_External_Status__c =: NCP_Constants.STATUS_ACTIVE AND NCP_Contact__c IN:contIdsToUserIds.keySet()];

		if(!authorisedEntitlements.isEmpty())
		{
			Map<Id,Set<Id>> aeUsers = new Map<Id,Set<Id>>();

			for (NCP_Authorised_Entitlement__c ae : authorisedEntitlements)
			{
	Id userId = contIdsToUserIds.get(ae.NCP_Contact__c);
	if (aeUsers.containsKey(ae.Id) == false)
	{
		aeUsers.put(ae.Id,new Set<Id>());
	}
	aeUsers.get(ae.Id).add(userId);
			}
			AuthorisedEntitlementShareSync.createAuthorisedEntitlementShares(aeUsers);
		}
	}
	
	/*********************************************************************************************
	* Param:user old map and user new map, id and list of costs visibility manager
	* Return: void
	* Description: Helper method to called from handler 
	**********************************************************************************************/
	public static void managePSROCostsVisibilities(Map<Id,User> oldMap,Map<Id,User> newMap, ID psId, List<PSRO_Costs_Visibilities_Manager__mdt> allowedRoles)
	{
		if(psId == null || allowedRoles == null){
			allowedRoles = [SELECT ID,BG__c,Role_Name__c FROM PSRO_Costs_Visibilities_Manager__mdt];
			List<PermissionSet> pSROCostsVisibilities = [SELECT ID,Name FROM PermissionSet WHERE name='PSRO_Costs_Visibilities'];
			if(!pSROCostsVisibilities.isEmpty() && pSROCostsVisibilities[0] != null) psId = pSROCostsVisibilities[0].Id; 
		}
		
		Map<String,Map<Id,PermissionSetAssignment>> psaCandidates = solveUsers(oldMap,newMap,psId);
		Map<Id,PermissionSetAssignment> psaCandidatesToBeAdded = psaCandidates.get('Add');
		Map<Id,PermissionSetAssignment>  psaCandidatesToBeRemoved = psaCandidates.get('Remove');
		Map<Id,List<Sales_role__c>>  mappingSalesRolesIntoUserIds =  new Map<Id,List<Sales_role__c>>();
		for(Sales_Role__c currentSalesRole:[SELECT ID,User__c,User__r.isActive,User__r.Restriction_Level__c,Role_code__c,Role_Name__c,BG__c
			 FROM Sales_Role__c
			WHERE User__c in:psaCandidatesToBeRemoved.keySet()]){
			for(PSRO_Costs_Visibilities_Manager__mdt allowRole: allowedRoles){			  
				if((String.isBlank(allowRole.BG__c) || (String.isNotBlank(allowRole.BG__c) && String.isNotBlank(currentSalesRole.BG__c) && (currentSalesRole.BG__c).contains(allowRole.BG__c))) && (String.isNotBlank(currentSalesRole.Role_Name__c) && (currentSalesRole.Role_Name__c).contains(allowRole.Role_Name__c) && String.isNotBlank(currentSalesRole.User__c))){ // Jan'22 Release
					if(mappingSalesRolesIntoUserIds.get(currentSalesRole.User__c) == null)
							mappingSalesRolesIntoUserIds.put(currentSalesRole.User__c,new List<Sales_Role__c>{currentSalesRole});
					else{
						List<Sales_Role__c> srListToBeAdded = mappingSalesRolesIntoUserIds.get(currentSalesRole.User__c);
						srListToBeAdded.add(currentSalesRole);
						mappingSalesRolesIntoUserIds.put(currentSalesRole.User__c,srListToBeAdded);
					}
				}
			}//Jan'22 Release
		}
		for(ID currentUserId : mappingSalesRolesIntoUserIds.keySet()){
			if(mappingSalesRolesIntoUserIds.containsKey(currentUserId)){
				psaCandidatesToBeRemoved.remove(currentUserId);
			}
		}
		try{
			Database.insert(psaCandidatesToBeAdded.values(),false);
		}
		catch(Exception e){
			//System.debug(e.getMessage());
		}
		if(!psaCandidatesToBeRemoved.isEmpty()){
			Database.delete([SELECT ID,AssigneeId,PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId in:psaCandidatesToBeRemoved.keySet() AND PermissionSetId=:psId],false);
		}
	}
	/*********************************************************************************************
	* Param:user old map and user new map, id 
	* Return: map
	* Description:  method to called from  managePSROCostsVisibilities
	* History: Changing access modifier from public to private
	**********************************************************************************************/
	@testVisible
	private static Map<String,Map<Id,PermissionSetAssignment>> solveUsers(Map<Id,User> oldMap,Map<Id,User> newMap, ID psId)
	{
		Map<Id,PermissionSetAssignment> psaListToAdd	= new Map<Id,PermissionSetAssignment>();
		Map<Id,PermissionSetAssignment> psaListToRemove   = new Map<Id,PermissionSetAssignment>();
		PermissionSetAssignment costsPSA = new PermissionSetAssignment(PermissionSetId = psId);

		//insert mode
		if(oldMap==null || oldMap.IsEmpty())
		{
			for(User currentUser : newMap.values())
			{
	if(currentUser.isActive && (currentUser.Restriction_Level__c).equals('Confidential'))
	{
		costsPSA.AssigneeId = currentUser.Id;
		psaListToAdd.put(costsPSA.AssigneeId,costsPSA);
	}
			}
		}
		else
		{
			//update mode
			if(!oldMap.IsEmpty() && !newMap.IsEmpty())
			{
	for(User currentUser : newMap.values())
	{
		if(currentUser.isActive)
		{
			User oldUser = oldMap.get(currentUser.Id);
			if(oldUser!=null && String.isNotBlank(currentUser.Restriction_Level__c) && !(currentUser.Restriction_Level__c).equals(oldUser.Restriction_Level__c))
			{
				costsPSA.AssigneeId = currentUser.Id;
				if((currentUser.Restriction_Level__c).equals(GlobalConstants.CONFIDENTIAL_VALUE))
				{
		psaListToAdd.put(costsPSA.AssigneeId,costsPSA);
				}
				else
				{
		psaListToRemove.put(costsPSA.AssigneeId,costsPSA);
				}
			}
		}
	}
			}
		}
		Map<String,Map<Id,PermissionSetAssignment>> result = new Map<String,Map<Id,PermissionSetAssignment>>();
		result.put('Add',psaListToAdd);
		result.put('Remove',psaListToRemove);
		return result;
	}
}