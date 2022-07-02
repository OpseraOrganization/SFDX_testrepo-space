global with sharing class CAPS_SecurityGroupsRESTUtil{
	
	global static final string TO_CREATE_INTERFACE_LOG_OR_NOT = 
			CH_Settings__c.getValues('LogInterfaceLogOrNot4SecurityGroupAPIs') != null ? 
			CH_Settings__c.getValues('LogInterfaceLogOrNot4SecurityGroupAPIs').SettingValue__c :'';
	global static Map<Id,Profile> profileNames(){
		Set<String> profileNames = new Set<String>();
		Map<Id,Profile> profileMap = new Map<Id,Profile>();
		final string CAPS_SECURITYGROUP_PROFILES = 
			CH_Settings__c.getValues('SecurityGroupsProfileNameForCAPS') != null ? 
			CH_Settings__c.getValues('SecurityGroupsProfileNameForCAPS').SettingValue__c :'';
		if(!String.isBlank(CAPS_SECURITYGROUP_PROFILES))
		{
			for(String str: CAPS_SECURITYGROUP_PROFILES.split(','))
			{
				profileNames.add(str.trim());
			}
		}
		if(!profileNames.isEmpty()){
			profileMap = new Map<Id,Profile>([SELECT Id, Name 
															FROM Profile 
															WHERE Name 
															IN : profileNames 
															LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]);
		}
		return profileMap;
	}
	/* 
	US-27474:
	*/
	
  /****************************************
* Class Name : CAPS_SecurityGroupsRESTUtil
* Method Name: profileCAPSName
* Last Modified by: Gopi Krishna
* Last Modified Date: 24 Feb 2021
* Description : Remove SOQL statements to retrieve the Custom Metadata for US-34697. Updated the version to 51.
*****************************************/	  
   global static Map<Id,String> profileCAPSName(){
	  Map<String,String>  profiletoProfileMap =new Map<String,String>();
	  Map<Id,String> sftoCAPSProfileNameMap =new Map<Id,String>();
	  Set<String> SFProfileSet = new Set<String>();
	  Map<string,CHProfile2ProfileMapSecurityGroup__mdt> profileMDT = CHProfile2ProfileMapSecurityGroup__mdt.getAll();
	 if(!profileMDT.isEmpty()){ 
	  for(CHProfile2ProfileMapSecurityGroup__mdt data: profileMDT.values())//[SELECT CH_ProfileAPIName__c, CH_CapsProfileName__c FROM CHProfile2ProfileMapSecurityGroup__mdt])
	  {
		SFProfileSet.add(data.CH_ProfileAPIName__c);
		profiletoProfileMap.put(data.CH_ProfileAPIName__c,data.CH_CapsProfileName__c);
	  }
	 } 
	 List<Profile> prList= [select Id,Name From Profile 
					 WHERE Name IN:SFProfileSet
					 LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())];
	 if(prList.size()>0){   
		 for(Profile pr:prList){
	if(profiletoProfileMap.containskey(pr.Name)){
	sftoCAPSProfileNameMap.put(pr.Id,profiletoProfileMap.get(pr.Name));
	}
	
		 }
	}
	return sftoCAPSProfileNameMap;			 
  }
	global static Map<Id,String> securityGroups(){
		Map<Id,String> groupIdVsNameMap = new Map<Id,String>();
		Map<String,CH_SecurityGroups__c> allGroups = CH_SecurityGroups__c.getAll();
		if(allGroups != null){
			for(CH_SecurityGroups__c grp: allGroups.values()){
				groupIdVsNameMap.put(grp.GroupId__c,grp.GroupName__c);
			}
		}
		return groupIdVsNameMap;
	}
	global class StatusDetails{
		global String error{get;set;}
		global String message{get;set;}
		global StatusDetails(String error,String message){
			this.error = error;
			this.message = message;
		}
	}
	global static void excptionHandle(Exception exp, RestResponse res, StatusDetails errormsg){
		String expMessage = 'Cause: '+exp.getCause() +', Line: '+exp.getLineNumber()+', ExceptionMessage: '+exp.getMessage()+', ExceptionType: '+exp.getTypeName()+', StackStace: '+exp.getStackTraceString();
			if(exp.getTypeName() == 'System.TypeException' || exp.getTypeName() == 'System.StringException'){res.statusCode = 400;
			}else if(exp.getTypeName() == 'System.QueryException'){res.statusCode = 404;
			}else{res.statusCode = 500;}
			errormsg = new StatusDetails('Exception has Occurred',expMessage);
			res.responseBody = Blob.valueOf(JSON.serialize(errormsg));
	}
	global static void createInterfaceLog
		(
		String interfaceRequest, 
		String responseMsg, 
		String status, 
		String name,
		String rqstURI
		){
		String yesValue = 'Yes';
		if(TO_CREATE_INTERFACE_LOG_OR_NOT.equalsIgnoreCase(yesValue))
		{
			List<Interface_log__c> logList = new List<Interface_log__c>();
			Interface_log__c logMessage = new Interface_log__c();
			logMessage.comment__c = rqstURI;
			logMessage.DS_Payload__c = responseMsg;
			logMessage.Interface_Type__c = 'CAPSV to SF';
			logMessage.Message_Type__c = 'Inbound';
			logMessage.Interface_Request_Sent__c = interfaceRequest;
			logMessage.Status__c = status;
			logMessage.Name = name;
			logList.add(logMessage);
			Database.insert(logList, false);
		}
	}
	global static Map<String,String> permissionSetProfileMap(Set<Id> nonCHProfileUserId){
		Map<String,String> assigneVsProfileNameMap = new Map<String,String>();
		Map<String,String> permissionSetsProfileMap = new Map<String,String>();
		Set<String> finalPermissionSetSet = new Set<String>();
		Map<String,CHPermissionSet2ProfileMapSecurityGroup__mdt> permissionMDT = CHPermissionSet2ProfileMapSecurityGroup__mdt.getAll();
		if(!nonCHProfileUserId.isEmpty() && !permissionMDT.isEmpty()){
			for(CHPermissionSet2ProfileMapSecurityGroup__mdt data: permissionMDT.values()) //[SELECT CH_PermissionSetAPIName__c, CH_ProfileName_CH__c FROM CHPermissionSet2ProfileMapSecurityGroup__mdt])
			{
				finalPermissionSetSet.add(data.CH_PermissionSetAPIName__c);
				permissionSetsProfileMap.put(data.CH_PermissionSetAPIName__c,data.CH_ProfileName_CH__c);
			}
			for(PermissionSetAssignment assign: [SELECT PermissionSetId, AssigneeId, PermissionSet.Name 
												FROM PermissionSetAssignment 
												WHERE PermissionSet.Name IN : finalPermissionSetSet 
												AND AssigneeId IN : nonCHProfileUserId 
												LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())])
			{
				assigneVsProfileNameMap.put(assign.AssigneeId, permissionSetsProfileMap.get(assign.PermissionSet.Name));
			}
		}
		return assigneVsProfileNameMap;
	}
}