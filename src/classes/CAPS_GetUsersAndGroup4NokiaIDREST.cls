/*************************************************************************************************
  * Class Name : CAPS_GetUsersAndGroup4NokiaIDREST
  * Created Date: 15 April 2019
  * Created By : TCS
  * Description: Return group(security groups) membersship details and their profilename, sf userid to CAPS.
		  As input paramter CAPS sends Nokia Employee Id for the user.
		  CAPS can sent more than one Nokia Employee Id in a single request.
  * Last Modified by: 
  * Last Modified Date: 
  * Description : 
*************************************************************************************************/
@RestResource(urlMapping='/GetUserAndGroupBasedOnNokiaId/*')
global with sharing class CAPS_GetUsersAndGroup4NokiaIDREST {
  /*********************************************************
	* Class Name: ResponseWrapper
	* Created Date: 15 April 2019
	* Created By : TCS
	* Description: This is inner class of CAPS_GetUsersAndGroup4NokiaIDREST to send response to CAPS
	* Last Modified by: 
	* Last Modified Date: 
	* Description : 
  *********************************************************/
  global class ResponseWrapper{
	global String sfUserId{get;set;}
	global String nokiaEmployeeId{get;set;}
	global String profileName{get;set;}
	global List<GroupNamesList> groupNames{get;set;}
	global ResponseWrapper(String sfUserId, String nokiaEmployeeId, String profileName, List<GroupNamesList> groupNames){
	  this.sfUserId = sfUserId;
	  this.nokiaEmployeeId = nokiaEmployeeId;
	  this.profileName = profileName;
	  this.groupNames = groupNames;
	}
  }
  /************************************************************************
	* Class Name: GroupNamesList
	* Created Date: 15 April 2019
	* Created By : TCS
	* Description: This is inner class of CAPS_GetUsersAndGroup4NokiaIDREST.
			This is wrapper of Security Group Names for an User
	* Last Modified by: 
	* Last Modified Date: 
	* Description : 
  *************************************************************************/
  global class GroupNamesList{
	global String name{get;set;}
	global GroupNamesList(String name){
	  this.name = name;
	}
  }
  //https://test.salesforce.com/services/apexrest/GetUserAndGroupBasedOnNokiaId - POST
  /*****************************************************
	* Method Name : userdetails
	* Created Date: 15 April 2019
	* Created By : TCS
	* Descsription: This is a REST POST Service to get users and group membersship information of users
	* Request Body: nokiaEmployeeId of users in JSON format
	* Return: JSON Response to CAPS - String nokiaEmployeeId, String profileName, List<GroupNamesList>   groupNames
	* Last Modified by: 
	* Last Modified Date: 
	* Description: 
  *******************************************/
  @HttpPost
  global static void usersdetailsAndGroupMembership() {
	RestResponse res = RestContext.response;
	CAPS_SecurityGroupsRESTUtil.StatusDetails errormsg;
	String interfaceLogName = 'CAPSPOSTAPIGetUserAndGroupBasedOnNokiaId-ClassCAPS_GetUsersAndGroup4NokiaIDREST';
	RestRequest req = RestContext.request;
	try{
	  List<ResponseWrapper> responseWrapList = new List<ResponseWrapper>();
	  Set<Id> userIdSet = new Set<Id>();
	  Map<Id,String> userIdVsNokiaIdMap = new Map<Id,String>();
	  Map<Id,String> userIdVsProfileNameMap = new Map<Id,String>();
	  Set<Id> nonCHProfileUserId = new Set<Id>();
	  Map<Id,User> usermap = new Map<Id,User>();
	  Map<String,String> assigneVsProfileNameMap = new Map<String,String>();
	  Map<Id,List<String>> userIdVsGrpNameListMap = new Map<Id,List<String>>();
	  List<Map<String, String>> nokiaIdList = new List<Map<String, String>>();
	  String jsonStr;
	  Integer lsitSize;
	  Set<String> employeeIDSet = new Set<String>();
	  Set<String> nokieidSet = new Set<String>();
	  Map<Id,Profile> profileMap = new Map<Id,Profile>();
	  Map<Id,String> ProfiletoProfileMap=new Map<Id,String>();
	  profileMap = CAPS_SecurityGroupsRESTUtil.profileNames();
	  ProfiletoProfileMap= CAPS_SecurityGroupsRESTUtil.profileCAPSName();// US-27477
	  System.debug('ProfiletoProfileMap****'+ProfiletoProfileMap);
	  /*1. Get Security Groups(actually they are public groups in Salesforce) configured in Salesforce.
		2. Mainly security groups are Starts with "SEC, but not make that constraint 
		  for this implementation this has been configured in custom settings
		3. Whenever new security group is created custom settings also needs to be updated.
		4. Group Ids should be same once evenrything is refreshed from Production.*/
	  Map<Id,String> groupIdVsNameMap = new Map<Id,String>();
	  groupIdVsNameMap = CAPS_SecurityGroupsRESTUtil.securityGroups();
	  if(groupIdVsNameMap.isEmpty()){//when no group is set up in custom settings
		res.statusCode = 500;
		CAPS_SecurityGroupsRESTUtil.StatusDetails msg = new CAPS_SecurityGroupsRESTUtil.StatusDetails(null,'Group Setup is not correct in Salesforce Custom Settings');
		res.responseBody = Blob.valueOf(JSON.serialize(msg));
		CAPS_SecurityGroupsRESTUtil.createInterfaceLog('Request Body: '+req.requestBody.toString(), 'Response Body: '+res.responseBody.toString(), 'Failure', interfaceLogName, 'Request URI: '+req.requestURI);
		return;
	  }else{
		jsonStr = RestContext.request.requestBody.toString();//get request body
		if(!String.isBlank(jsonStr)){//parse request body
		  nokiaIdList = (List<Map<String, String>>)JSON.deserialize(jsonStr, List<Map<String, String>>.class);
		}else{// if no body in request
		  res.statusCode = 400;
		  CAPS_SecurityGroupsRESTUtil.StatusDetails msg = new CAPS_SecurityGroupsRESTUtil.StatusDetails('Bad Request','Could not find a body in the request.');
		  res.responseBody = Blob.valueOf(JSON.serialize(msg));
		  CAPS_SecurityGroupsRESTUtil.createInterfaceLog('Request Body: '+req.requestBody.toString(), 'Response Body: '+res.responseBody.toString(), 'Failure', interfaceLogName, 'Request URI: '+req.requestURI);
		  return;
		}
		if(!nokiaIdList.isEmpty()){//nokia employee ids in a set
		  lsitSize = nokiaIdList.size();
		  for(integer i=0; i< lsitSize; i++)
		  {
			String emplId = (String)nokiaIdList.get(i).get('nokiaEmployeeId');
			if(!String.isBlank(emplId))
			{
			  employeeIDSet.add(emplId);
			}else{//when nokia employee in the request is blank or null
			  res.statusCode = 400;
			  CAPS_SecurityGroupsRESTUtil.StatusDetails msg = new CAPS_SecurityGroupsRESTUtil.StatusDetails('Bad Request','Nokia Employee Id Cannot be empty or null in request.');
			  res.responseBody = Blob.valueOf(JSON.serialize(msg));
			  CAPS_SecurityGroupsRESTUtil.createInterfaceLog('Request Body: '+req.requestBody.toString(), 'Response Body: '+res.responseBody.toString(), 'Failure', interfaceLogName, 'Request URI: '+req.requestURI);
			  return;
			}
		  }
		}
		if(!employeeIDSet.isEmpty())
		{//Get users
		  for(User usr : [SELECT Id, Nokia_ID__c, Profile.Name, ProfileId 
				FROM User 
				WHERE Nokia_ID__c IN : employeeIDSet 
				LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())])
		  {
			if(!profileMap.containskey(usr.ProfileId) || !ProfiletoProfileMap.containskey(usr.ProfileId)){
			  nonCHProfileUserId.add(usr.Id);
			}
			usermap.put(usr.Id, usr);
		  }
		  assigneVsProfileNameMap = CAPS_SecurityGroupsRESTUtil.permissionSetProfileMap(nonCHProfileUserId);
		  for(User usr : usermap.values())
		  {
			userIdVsNokiaIdMap.put(usr.Id, usr.Nokia_ID__c);
			userIdSet.add(usr.Id);
			nokieidSet.add(usr.Nokia_ID__c);
			if(profileMap.containskey(usr.ProfileId)){//user has CH profile
			  userIdVsProfileNameMap.put(usr.Id, profileMap.get(usr.ProfileId).Name);
			}else if(ProfiletoProfileMap.containskey(usr.ProfileId)){//US-27477
			   userIdVsProfileNameMap.put(usr.Id, ProfiletoProfileMap.get(usr.ProfileId));
			}else if(assigneVsProfileNameMap.containskey(usr.Id)){//user has non ch profile but has permission set mentioned in metadata
			  userIdVsProfileNameMap.put(usr.Id, assigneVsProfileNameMap.get(usr.Id));
			}else{//non ch profile and no ch permissionset mentioned in metadata
			  userIdVsProfileNameMap.put(usr.Id, usr.Profile.Name);
			}
		  }
		  for(String empId : employeeIDSet){
			if(!nokieidSet.contains(empId)){
			//if nokia employee sent in the request is not present in Salesforce against any user. 
			//For request with single nokia employee id, this will go into the response. 
			//but if there was bulk request and for some nokia id no users found, then this also will listed in the response
			  responseWrapList.add(new ResponseWrapper('No such User in Salesforce', empId, null, new List<GroupNamesList>()));
			}
		  }
		}
		if(!userIdSet.isEmpty())
		{
		  for(GroupMember grpMembr: [SELECT Id, GroupId, UserOrGroupId 
					  FROM GroupMember 
					  WHERE UserOrGroupId IN : userIdSet 
					  AND GroupId IN : groupIdVsNameMap.keySet() 
					  LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())])
		  {//Get Current Group(Security Groups) memberships of users in scope
			List<String> groupNameLst = new List<String>();
			if(userIdVsGrpNameListMap.containskey(grpMembr.UserOrGroupId))
			{
			  groupNameLst = userIdVsGrpNameListMap.get(grpMembr.UserOrGroupId);
			  groupNameLst.add(groupIdVsNameMap.get(grpMembr.GroupId));
			  userIdVsGrpNameListMap.put(grpMembr.UserOrGroupId,groupNameLst);
			}else
			{
			  groupNameLst.add(groupIdVsNameMap.get(grpMembr.GroupId));
			  userIdVsGrpNameListMap.put(grpMembr.UserOrGroupId,groupNameLst);
			}
		  }
		  for(Id userId: userIdSet)
		  {//Generate final response
			List<GroupNamesList> grpMemListWrap = new List<GroupNamesList>();
			if(userIdVsGrpNameListMap.get(userId) != null)
			{
			  for(String grp: userIdVsGrpNameListMap.get(userId))
			  {
				grpMemListWrap.add(new GroupNamesList(grp));
			  }
			}
			responseWrapList.add(new ResponseWrapper(userId, userIdVsNokiaIdMap.get(userId), userIdVsProfileNameMap.get(userId), grpMemListWrap));
		  }
		}else{// when there was no user for the complete request
		  res.statusCode = 200;
		  CAPS_SecurityGroupsRESTUtil.StatusDetails msg = new CAPS_SecurityGroupsRESTUtil.StatusDetails(null,'No User Found.');
		  res.responseBody = Blob.valueOf(JSON.serialize(msg));
		  CAPS_SecurityGroupsRESTUtil.createInterfaceLog('Request Body: '+req.requestBody.toString(), 'Response Body: '+res.responseBody.toString(), 'Success', interfaceLogName, 'Request URI: '+req.requestURI);
		  return;
		}
		if(!responseWrapList.isEmpty()){
		  res.statusCode = 200;
		  res.responseBody = Blob.valueOf(JSON.serialize(responseWrapList));
		  CAPS_SecurityGroupsRESTUtil.createInterfaceLog('Request Body: '+req.requestBody.toString(), 'Response Body: '+res.responseBody.toString(), 'Success', interfaceLogName, 'Request URI: '+req.requestURI);
		}
	  }
	}catch(Exception exp){CAPS_SecurityGroupsRESTUtil.excptionHandle(exp, res, errormsg);
	  CAPS_SecurityGroupsRESTUtil.createInterfaceLog('Request Body: '+req.requestBody.toString(), 'Response Body: '+res.responseBody.toString(), 'Failure', interfaceLogName, 'Request URI: '+req.requestURI);
	}
  }
}