public without sharing class CH_Workgroup_Controller {

	@AuraEnabled
	public static String getRecordTypeName(String recordTypeId, string objectName){
		System.debug('CH_CA: recordTypeId ' + recordTypeId);
		System.debug('CH_CA: objectName ' + objectName);
		String returnedRecordTypes;
		List<RecordType> recordTypeList = [SELECT Id, DeveloperName FROM RecordType 
	WHERE SObjectType = :objectName AND Id =: recordTypeId LIMIT 1];
		String recordTypeName = '';
		if (recordTypeList.size() > 0){
			recordTypeName = recordTypeList.get(0).DeveloperName;
		}
		System.debug('CH_CA: RecordTypeName ' + recordTypeName);
		return recordTypeName;
	}
	
	@AuraEnabled
	public static String getDefaultRecordTypeName(string objectName){
		System.debug('CH_CA: objectName ' + objectName);
		String returnedRecordTypes;
		List<RecordType> recordTypeList = [SELECT Id, DeveloperName FROM RecordType 
	WHERE SObjectType = :objectName];
		String recordTypeName = '';
		if (recordTypeList.size() > 0){
			recordTypeName = recordTypeList.get(0).DeveloperName;
		}
		
		SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
		for (Schema.RecordTypeInfo rtInfo : objectType.getDescribe().getRecordTypeInfos()) {
			if (rtInfo.isDefaultRecordTypeMapping()) {
	recordTypeName = rtInfo.getDeveloperName();
	break;
		}
		}
		
		System.debug('CH_CA: RecordTypeName ' + recordTypeName);
		return recordTypeName;
	}
	
	 @AuraEnabled
	public static boolean accessCheck(Id getRecordId){
		boolean flag=false;
		Id profileId=userinfo.getProfileId();
		if(getRecordId!=null){
			UserRecordAccess[] getRecordAccess=[SELECT RecordId, MaxAccessLevel, HasAllAccess, HasDeleteAccess, HasEditAccess, HasReadAccess, HasTransferAccess FROM UserRecordAccess where UserId =:  Userinfo.getUserId() and RecordId =:getRecordId];
			if(getRecordAccess.size()>0){
	if(getRecordAccess[0].HasEditAccess==true){
		flag=true;
	}
			}
			
		}
		else{
			Schema.DescribeSObjectResult describeSObject = CH_Workgroup_Rule__c.sObjectType.getDescribe();
			flag = describeSObject.isCreateable(); 
			System.debug('CH_CA :describeSObject accessCheck' + describeSObject);
			
		}
		
		return flag;
	}
	
	
	@AuraEnabled
	public static CH_Workgroup_Rule__c getRecrdTypeName(Id  RecordId){
		CH_Workgroup_Rule__c returnWorkgroupRule=new CH_Workgroup_Rule__c();
		CH_Workgroup_Rule__c[] recordTypeList = [SELECT Id, CH_RecordTypeName__c,RecordTypeId FROM CH_Workgroup_Rule__c 
			 WHERE Id = :RecordId LIMIT 1];
		if (recordTypeList.size() > 0){
			returnWorkgroupRule = recordTypeList[0];
		}
		return returnWorkgroupRule;
	}
	
	@AuraEnabled
	public static boolean accessCheckMember(id getRecordId){
		boolean flag=false;
		Id profileId=userinfo.getProfileId();
		Id userId = Userinfo.getUserId();
		if(getRecordId!=null){
			UserRecordAccess[] getRecordAccess=[SELECT RecordId, MaxAccessLevel, HasAllAccess, HasDeleteAccess, HasEditAccess, HasReadAccess, HasTransferAccess FROM UserRecordAccess where UserId =:userId and RecordId =:getRecordId];
			if(getRecordAccess.size()>0){
	
	if(getRecordAccess[0].HasEditAccess==true){
		flag=true;
	}
			}
			
		}
		else{
			
			Schema.DescribeSObjectResult describeSObject = CH_Workgroup_Member__c.sObjectType.getDescribe();
			flag = describeSObject.isCreateable(); 
			System.debug('CH_CA :describeSObject accessCheck member' + describeSObject);
		}
		System.debug('CH_CA: flag' + flag);
		return flag;
	}
	@AuraEnabled
	public static CH_Workgroup_Member__c getRecrdTypeNameMember(Id  RecordId){
		System.debug('CH_CA: RecordId' + RecordId);
		CH_Workgroup_Member__c returnWorkgroupMember =new CH_Workgroup_Member__c();
		CH_Workgroup_Member__c[] recordTypeList = [SELECT Id, CH_RecordTypeName__c,RecordTypeId,CH_Workgroup_Member_Type__c,CH_User__c,CH_Off_Duty__c FROM CH_Workgroup_Member__c 
			   WHERE Id = :RecordId LIMIT 1];
		try{
			System.debug('CH_CA: recordTypeList.size--' + recordTypeList.size());
			if (recordTypeList.size() > 0){
	returnWorkgroupMember = recordTypeList[0];
			}
			System.debug('CH_CA: returnWorkgroupMember' + returnWorkgroupMember);
			return returnWorkgroupMember;
		}
		catch (system.QueryException e){
			System.debug('CH_CA: exception occured' + e);
			
			return null;
		}
		
	}
	
	@AuraEnabled
	public static boolean getValidUser(){
		Boolean getValidUser=false;
		String getPermissionSet = System.Label.CH_CA_Permission_Set;
		Set<String> userPermissionSets = new Set<String>();
		if(getPermissionSet!= null){
			for(String getPermissionSetValue : getPermissionSet.split(','))
			{
	userPermissionSets.add(getPermissionSetValue);
			}
		}
		List<PermissionSetAssignment> perAssignments = [SELECT AssigneeId, PermissionSet.Name FROM PermissionSetAssignment WHERE   PermissionSet.Name IN :userPermissionSets  AND AssigneeId=:UserInfo.getUserId()];
		if(perAssignments.size()>0){
			getValidUser=true;
		}
		else{
			Id profileId= userinfo.getProfileId();
			String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
			String getProfiles = System.Label.CH_CA_Profiles;
			Set<String> userProfiles = new Set<String>();
			if(getProfiles!= null){
	for(String getProfileValue : getProfiles.split(','))
	{
		if(profileName==getProfileValue){
			getValidUser=true;
			break;
		}
		
	}
			}
		}
		return getValidUser;
	}
	
}