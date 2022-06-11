/** 
* About 
* ----- 
* @Description	 	: Nokia Global Utility Class.
* @TestClass		: NokiaUtils_Test.
* @Project	: All.
* @Modification Log :
*  Created  : 2021 12 17 – tiago.almeida@nokia.com
* ----- 
**/
public without sharing class NokiaUtils {
	public static final string NOKIA_ADMINISTRATOR = 'Nokia Admin Profile';
	public static final string SYSTEM_ADMINISTRATOR = 'System Administrator';
	
	public static DateTime getCurrentDateTime(){
		return System.now();
	}
	
	public static Boolean isCommunity(){
		return Site.getSiteId() != null;
	}
	
	@AuraEnabled(cacheable=true)
	public static String getBaseURL() {
		return URL.getOrgDomainUrl().toExternalForm();
	}
	
	@AuraEnabled(cacheable=true)
	public static String getCommunityLink(String communityName){
		Site site = [SELECT Id FROM Site WHERE Name =: communityName LIMIT 1];
		return [SELECT SecureURL FROM SiteDetail WHERE DurableId =: site.Id].SecureUrl;
	}

	/**
	 * @description : Method that gets SObject Type from Id.
	 * @param	: Id recordId
	 * @return	: String
	**/
	@AuraEnabled(cacheable=true)
	public static String getSObjectType(Id recordId) {
		return recordId.getSObjectType().getDescribe().getName();
	}


	/**
	 * @description : Method that get Picklist Values for a given Object.
	 * @param	: String objectApiName
	 * @param	: String field
	 * @return	: List<String>
	**/
	public static List<String> getPicklistValues(String objectApiName, String field) {
		return getPicklistValues((SObject) Type.forName(objectApiName).newInstance(), field);
	}
	
	/**
	 * @description : Method that get Picklist Values for a given Object.
	 * @param	: SObject sfObject
	 * @param	: String field
	 * @return	: List<String>
	**/
	public static List<String> getPicklistValues(SObject sfObject, String field) {
		List<String> result = new List<String>();
		Map<String, Schema.SObjectField> fieldMap = sfObject.getSObjectType().getDescribe().fields.getMap();
		if(fieldMap.containsKey(field)) {
			List<Schema.PicklistEntry> picklistEntries = fieldMap.get(field).getDescribe().getPickListValues();
			for (Schema.PicklistEntry picklistEntry : picklistEntries) {
	result.add(picklistEntry.getValue());
			}
		}
		return result;
	}
	
	/**
	 * @description : Method that checks if a user has one or all Permission Sets and Profile.
	 * @param	: Id userId
	 * @param	: String profileName
	 * @param	: List<String> permissionSetList
	 * @param	: Boolean mustHaveAll
	 * @return	: Boolean
	**/
	public static Boolean checkUserPermissions(Id userId, List<String> profileList, List<String> permissionSetList, Boolean mustHaveAll) {
		Boolean result = false;
		if(!profileList.isEmpty()) {
			result = !(DML_SObject.get('User', 'Profile.Name').filteredBy(
				'Id = "{0}" AND Profile.Name IN {1}', userId, DML_SObject.toString(profileList)
			).run(true)).isEmpty();
		}
		if(!permissionSetList.isEmpty()) {
			List<PermissionSetAssignment> oPermissionSetAssignmentList = DML_SObject.get('PermissionSetAssignment', 'PermissionSet.Name').filteredBy(
				'AssigneeId = "{0}" AND PermissionSet.Name IN {1}', userId, DML_SObject.toString(permissionSetList)
			).run(true);
			result = mustHaveAll ? result && oPermissionSetAssignmentList.size() == permissionSetList.size() : result || !oPermissionSetAssignmentList.isEmpty();
		}
		return result;
	}
	
	/**
	 * @description : Method that checks if a user has access to a specific object.
	 * @param	  : Id userId
	 * @param	  : Id ObjectId
	 * @param	  : Boolean hasRead
	 * @param	  : Boolean hasEdit
	 * @param	  : Boolean hasDelete
	 * @param	  : Boolean mustHaveAll
	 * @return	: Boolean
	**/
	public static Boolean checkUserAccess(Id userId, Id objectId, Boolean hasRead, Boolean hasEdit, Boolean hasDelete, Boolean mustHaveAll) {
		Boolean result = false;
		if(userId != null && objectId != null) {
			UserRecordAccess recordAccess = (UserRecordAccess) DML_SObject.get(
				'UserRecordAccess', 'RecordId, HasReadAccess, HasEditAccess, HasDeleteAccess, HasTransferAccess, MaxAccessLevel'
			).filteredBy(
				'RecordId = "{0}" AND UserId = "{1}"', objectId, userId
			).run(true, 0);
			result = hasRead ? (mustHaveAll ? (result && recordAccess.HasReadAccess) : (result || recordAccess.HasReadAccess)) : result;
			result = hasEdit ? (mustHaveAll ? (result && recordAccess.HasEditAccess) : (result || recordAccess.HasEditAccess)) : result;
			result = hasDelete ? (mustHaveAll ? (result && recordAccess.HasDeleteAccess) : (result || recordAccess.HasDeleteAccess)) : result;
		}
		return result;
	}
	
	/**
	 * @description : Method that checks if a user has access to specific objects.
	 * @param	  : Id userId
	 * @param	  : Set<String> ObjectId
	 * @param	  : Boolean hasRead
	 * @param	  : Boolean hasEdit
	 * @param	  : Boolean hasDelete
	 * @param	  : Boolean mustHaveAll
	 * @return	: Map<String, Boolean>
	**/
	public static Map<String, Boolean> checkUserAccess(Id userId, Set<String> objectsId, Boolean hasRead, Boolean hasEdit, Boolean hasDelete, Boolean mustHaveAll) {
		Map<String, Boolean> result = new Map<String, Boolean>();
		if(userId != null && objectsId != null && !objectsId.isEmpty()) {
			List<UserRecordAccess> recordsAccess = DML_SObject.get(
				'UserRecordAccess', 'RecordId, HasReadAccess, HasEditAccess, HasDeleteAccess, HasTransferAccess, MaxAccessLevel'
			).filteredBy(
	'RecordId IN {0} AND UserId = "{1}"', DML_SObject.toString(objectsId), userId
			).run(true);
			for(UserRecordAccess recordAccess : recordsAccess) {
				Boolean hasAccess = false;
				hasAccess = hasRead ? (mustHaveAll ? (hasAccess && recordAccess.HasReadAccess) : (hasAccess || recordAccess.HasReadAccess)) : hasAccess;
				hasAccess = hasEdit ? (mustHaveAll ? (hasAccess && recordAccess.HasEditAccess) : (hasAccess || recordAccess.HasEditAccess)) : hasAccess;
				hasAccess = hasDelete ? (mustHaveAll ? (hasAccess && recordAccess.HasDeleteAccess) : (hasAccess || recordAccess.HasDeleteAccess)) : hasAccess;
				result.put(recordAccess.RecordId, hasAccess);
			}
		}
		return result;
	}
	
	@AuraEnabled(cacheable=false)
	public static SObject upsertRecord(SObject recordInput) {
		upsert recordInput;
		return recordInput;
	}
}