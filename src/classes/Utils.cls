/**
About
-----
Description: Utils - Utils class to be used in other classes.

Created for: Nokia Portugal COE
Created: 12 05 2018

Update History
--------------
Created: 12 05 2018 – flavio.toscano@nokia.com
-------------
**/
public with sharing class Utils {

	/**
	*   @desc : method used to return list of Active RecordTypes per sObject
	*   @param : String : sObjectName
	*   @return : Mar<String, Id>
	*/
	public static Map<String, ID> MapRecordType(String sObjectName) {
		List<RecordType> lstRecordType = new List<RecordType>();
		lstRecordType = [Select ID, SobjectType, Name, DeveloperName from RecordType where SobjectType = :sObjectName and IsActive = true];
		Map<String, ID> mapRTCaseToDeveloperName = new Map<String, ID>();
		for (RecordType rec : lstRecordType) {
			mapRTCaseToDeveloperName.put(rec.DeveloperName, rec.ID);
		}
		return mapRTCaseToDeveloperName;
	}

	/**
	*   Method used to get Public Group Id by Name
	*   @param  : String with Public Group Name
	*   @return : Id
	*/
	public static Id getPublicGroupIdByApiName(String sPublicGroupName){
		return [Select Id From Group Where developername = :sPublicGroupName LIMIT 1].Id;
	}

	/**
	*   Method used to get Queue Id by Name
	*   @param  : String with Queue Name
	*   @return : Id
	*/
	public static Id getQueueIdByApiName(String sQueueName){
		return [Select Id From Group Where developername = :sQueueName LIMIT 1].Id;
	}
 
	/**
	*   @desc : method used to return list of RecordTypes per sObject
	*   @param : String : sObjectName
	*   @return : List<RecordType>
	*/
	public static List<RecordType> getRecordTypesBySobjectName(String sObjectName){
		return [Select id,DeveloperName, Name From RecordType Where sObjectType = :sObjectName];
	}

	/**
	*   Method used to get the map of picklist fields mapping by Label and Value
	*   @param  : String objectName
	*   @param  : String fieldName
	*   @return : Map of field picklist Label and Value
	*/
	public static Map<String,String> getMapPickLabelAndValues(String objectName, String fieldName){
		Map<String,String> mapLabelPickListValue = new Map<String,String>();
		for(Schema.PicklistEntry entry : getPicklistValues(objectName, fieldName)){
			mapLabelPickListValue.put(entry.getLabel() ,entry.getValue());
		}
		return mapLabelPickListValue;
	}

	/**
	*   Method used to get a Set of Ids from a List of a SObject
	*   @param  : List<sObject>
	*   @return : Set<String>
	*/
	public static Set<String> getIdSetFromSObjectList(List<sObject> records) {
		Set<String> recordIds = new Set<String>();

		for (sObject record : records) {
			recordIds.add((String) record.get('Id'));
		}
		return recordIds;
	}

	/**
	*   Method used to TBD
	*   @param  : String with ObjectName and String of DeveloperName
	*   @return : String
	*/
	public static String getRecordTypeIdByDeveloperName(String sObjectName, String DeveloperName){
		Map<String,Schema.RecordTypeInfo> mapRecordTypes = getRecordtypeNameMap(sObjectName);
		for(String name : mapRecordTypes.keySet()){
			if(mapRecordTypes.get(name).isAvailable() && mapRecordTypes.get(name).getDeveloperName().toUpperCase().equals(DeveloperName.toUpperCase())){
				return mapRecordTypes.get(name).getRecordTypeId();
			}
		}
		return null;
	}

	/**
	*   @desc :   Dynamically generates picklist values for checkboxes based on field metadata
	*   @param :  String :objName
	*   @param :  String : field
	*   @return : List<Schema.PicklistEntry>
	*/
	public static Schema.PicklistEntry[] getPicklistValues(String objName, String field){
		Schema.PicklistEntry[] values = new Schema.PicklistEntry[0];
		Schema.SObjectField soField;
		Schema.DescribeFieldResult dfResult;

		// get the object token, return the empty optsions if not found
		SObjectType soType = Schema.getGlobalDescribe().get(objName);
		if (soType == null){
			return values;
		}

		// get the field token, return the empty optsions if not found
		soField = soType.getDescribe().fields.getMap().get(field);
		if (soField == null) {
			return values;
		}

		// get the field result, return if not found or if field isn't a picklist
		dfResult = soField.getDescribe();
		if (dfResult == null || (dfResult.getType() != DisplayType.picklist && dfResult.getType() != DisplayType.multipicklist)) {
			return values;
		}

		// build the SelectOption list from the values and names of the field's picklist entries
		for (Schema.PicklistEntry p : dfResult.getPicklistValues()) {
			values.add(p);
		}
		return values;
	}
	
	/**
	*   Method used to get Permission Set Id by Name
	*   @param  : String with Permission Set Name
	*   @return : Id
	*/
	public static Id getPermissionSetIdByPermissionSetName(String sPermissionName){
		List<PermissionSet> permission= [Select Id From PermissionSet Where Name = :sPermissionName LIMIT 1];
		if(permission!=null && !permission.isEmpty()){
			return permission[0].id;
		} 
		else{
			return null;
		}
	}

	public static String generateRandomInteger(Integer len) {
		final String chars = '1234567890123454327658902348901234565487690678453789';
		String randStr = '';
		while (randStr.length() < len) {
			Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
			randStr += chars.substring(idx, idx+1);
		}
		return randStr;
	}

	public static String generateRandomString(Integer len) {
		final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
		String randStr = '';
		while (randStr.length() < len) {
			Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
			randStr += chars.substring(idx, idx+1);
		}
		return randStr;
	}

	public static Map<String,Schema.RecordTypeInfo> getRecordtypeNameMap(String sObjectType){
		return getSobjectDescribe(getObjectInstanceByName(sObjectType)).getRecordTypeInfosByName();
	}

	public static Sobject getObjectInstanceByName (String objectName){
		return getObjectTypeByName(objectName).newSObject();
	}

	public static Schema.SObjectType getObjectTypeByName(String objectName){
		return Schema.getGlobalDescribe().get(objectName);
	}

	public static Schema.DescribeSObjectResult getSobjectDescribe(sObject objectToWork){
		return objectToWork.getSObjectType().getDescribe();
	}
	
	public static Map<Id,boolean> hasRoleInOthersWorkgroups(Map<Id,String> userRoleMap, Map<Id,String> userWorkGroupMapIds){
		Map<Id,boolean> result = new Map<Id,boolean>();
		List<CH_Workgroup_Member__c> workgroupMembers = CH_EM_WorkgroupMember.getAllWorkgroupMembersPerUser(userRoleMap.keySet());
		if(!workgroupMembers.isEmpty()){
			for(Id userId : userRoleMap.keySet()){
				Boolean hasRole = false;
				for(CH_Workgroup_Member__c workgroupMember : workgroupMembers){
					if(workgroupMember.CH_User__c == userId && workgroupMember.CH_WorkgroupId__c != userWorkGroupMapIds.get(userId)){
						if(workgroupMember.CH_Role__c == userRoleMap.get(userId) && userRoleMap.get(userId) != 'Owner' ||
								workgroupMember.CH_Owner__c == true && userRoleMap.get(userId) == 'Owner'){
							hasRole= true;
							break;
						}						
					}
				}
				result.put(userId, hasRole);
			}
		}
		return result;
	}
	
	public static Map<Id,String> userRolesInOthersWorkgroups(Map<Id,String> userRoleMap, Map<Id,String> userWorkGroupMapIds){
		Map<Id,String> result = new Map<Id,String>();
		List<CH_Workgroup_Member__c> workgroupMembers = CH_EM_WorkgroupMember.getAllWorkgroupMembersPerUser(userRoleMap.keySet());
		for(Id userId : userRoleMap.keySet()){
			String roles = '';
			if(!workgroupMembers.isEmpty()){
				for(CH_Workgroup_Member__c workgroupMember : workgroupMembers){
					if(workgroupMember.CH_User__c == userId && workgroupMember.CH_WorkgroupId__c != userWorkGroupMapIds.get(userId)){
						if(roles.indexOf(workgroupMember.CH_Role__c) == -1){
							roles= roles+workgroupMember.CH_Role__c+',';
						}
					}
				}
				roles = roles.removeEnd(',');
			}
			result.put(userId, roles.removeEnd(','));
		}
		return result;
	}
}