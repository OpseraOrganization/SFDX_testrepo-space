/*************************************************************************************************
  * Class Name : CAPS_GetNewUsersInDefinedSpanREST
  * Created Date: 15 April 2019
  * Created By : TCS
  * Description: Return details users created in span of period. 
	Start and End Date Time will be suppied by CAPS. 
	Also sent GroupMemeber(Only Security Groups) details for those users in Response.
  * Last Modified by: 
  * Last Modified Date: 
  * Description : 
*************************************************************************************************/
@RestResource(urlMapping='/GetNewUsers/*')
global with sharing class CAPS_GetNewUsersInDefinedSpanREST {
  /*********************************************************
	* Class Name: ResponseWrapper
	* Created Date: 15 April 2019
	* Created By : TCS
	* Description: This is inner class of CAPS_GetNewUsersInDefinedSpanREST to send response to CAPS
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
	* Description: This is inner class of CAPS_GetNewUsersInDefinedSpanREST.
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
  //https://test.salesforce.com/services/apexrest/GetNewUsers/startdatetime=2012-04-15T13:50:58.000Z/enddatetime=2019-04-16T10:50:58.000Z
   /*****************************************************
	* Method Name : userdetails
	* Created Date: 15 April 2019
	* Created By : TCS
	* Descsription: This is a REST GET Service to get newly created users and group information of the user
	* Parameter: EndPoint, Start Date Time, End Date Time
	* Return: JSON Response to CAPS - String nokiaEmployeeId, String profileName, List<GroupNamesList> groupNames
	* Last Modified by: 
	* Last Modified Date: 
	* Description: 
	*******************************************/ 
  @HttpGet
  global static void userdetails() {
	RestResponse res = RestContext.response;
	CAPS_SecurityGroupsRESTUtil.StatusDetails errormsg;
	String interfaceLogName = 'CAPS-GETCALL-API-GetNewUsers-Class-CAPS_GetNewUsersInDefinedSpanREST';
	RestRequest req = RestContext.request;
	try{
	  List<ResponseWrapper> responseWrapList = new List<ResponseWrapper>();
	  Set<Id> userIdSet = new Set<Id>();
	  Map<Id,String> userIdVsNokiaIdMap = new Map<Id,String>();
	  Map<Id,String> userIdVsProfileNameMap = new Map<Id,String>();
	  Map<Id,List<String>> userIdVsGrpNameListMap = new Map<Id,List<String>>();
	  Set<Id> nonCHProfileUserId = new Set<Id>();
	  Map<Id,User> usermap = new Map<Id,User>();
	  Map<String,String> assigneVsProfileNameMap = new Map<String,String>();
	  //Get Profile Names for which newly created user information needs to be sent to CAPS
	  Map<Id,Profile> profileMap = new Map<Id,Profile>();
	  Map<Id,String> ProfiletoProfileMap=new Map<Id,String>();
	  profileMap = CAPS_SecurityGroupsRESTUtil.profileNames();
	  ProfiletoProfileMap= CAPS_SecurityGroupsRESTUtil.profileCAPSName();// US-27474
	  /*1. Get Security Groups(actually they are public groups in Salesforce) configured in Salesforce.
		2. Mainly security groups are Starts with "SEC, but not make that constraint 
	for this implementation this has been configured in custom settings
		3. Whenever new security group is created custom settings also needs to be updated.
		4. Group Ids should be same once evenrything is refreshed from Production.*/
	  Map<Id,String> groupIdVsNameMap = new Map<Id,String>();
	  groupIdVsNameMap = CAPS_SecurityGroupsRESTUtil.securityGroups();
	  if(profileMap.isEmpty() || groupIdVsNameMap.isEmpty())
	  {
		res.statusCode = 500;
		CAPS_SecurityGroupsRESTUtil.StatusDetails msg = new CAPS_SecurityGroupsRESTUtil.StatusDetails(null,'Group or Profile Setup is not correct in Salesforce Custom Settings');
		res.responseBody = Blob.valueOf(JSON.serialize(msg));
		CAPS_SecurityGroupsRESTUtil.createInterfaceLog('Request Body: '+req.requestBody.toString(), 'Response Body: '+res.responseBody.toString(), 'Failure', interfaceLogName, 'Request URI: '+req.requestURI);
		return;
	  }
	  //Get start and end date time in required format
	  String startdatetime = req.requestURI.substringAfter('/startdatetime=').substringBefore('/enddatetime=');
	  String enddatetime = req.requestURI.substringAfter('/enddatetime=');
	  Datetime fromDatetime = Datetime.valueOfGMT(startdatetime.replace('T',' '));
	  Datetime toDatetime = Datetime.valueOfGMT(enddatetime.replace('T',' '));
	  //Get users
	  for(User usr : [SELECT Id, Nokia_ID__c,Profile.Name,ProfileId
	 FROM User 
	 WHERE (Createddate >=:fromDatetime 
	 AND Createddate <= : toDatetime) OR
	 (LastModifiedDate>=:fromDatetime
	 AND LastModifiedDate <= : toDatetime) 
	 LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())])
	  {
		if(!profileMap.containskey(usr.ProfileId)&& !ProfiletoProfileMap.containskey(usr.ProfileId)){
	nonCHProfileUserId.add(usr.Id);
		}
		usermap.put(usr.Id, usr);
	  }
	  //Get user id and profile map for non ch profiles vs permission map 
	  assigneVsProfileNameMap = CAPS_SecurityGroupsRESTUtil.permissionSetProfileMap(nonCHProfileUserId);
	  //process users data
	  for(User usr : usermap.values()){
		if(profileMap.containskey(usr.ProfileId) || assigneVsProfileNameMap.containskey(usr.Id)||ProfiletoProfileMap.containskey(usr.ProfileId)){
	userIdVsNokiaIdMap.put(usr.Id, usr.Nokia_ID__c);
	if(profileMap.containskey(usr.ProfileId)){//When CH Profile present in Csutom Settings
			userIdVsProfileNameMap.put(usr.Id, profileMap.get(usr.ProfileId).Name);
	}else if(ProfiletoProfileMap.containskey(usr.ProfileId)){
	 userIdVsProfileNameMap.put(usr.Id, ProfiletoProfileMap.get(usr.ProfileId)); 
	}else{//when non ch profile but having ch permissionset listed in metadata
			userIdVsProfileNameMap.put(usr.Id, assigneVsProfileNameMap.get(usr.Id));
	}
	userIdSet.add(usr.Id);
		}
	  }
	  if(userIdSet.isEmpty()){
		res.statusCode = 200;
		CAPS_SecurityGroupsRESTUtil.StatusDetails msg = new CAPS_SecurityGroupsRESTUtil.StatusDetails(null,'No User Found');
		res.responseBody = Blob.valueOf(JSON.serialize(msg));
		CAPS_SecurityGroupsRESTUtil.createInterfaceLog('Request Body: '+req.requestBody.toString(), 'Response Body: '+res.responseBody.toString(), 'Success', interfaceLogName, 'Request URI: '+req.requestURI);
		return;
	  }else{
		//Get GroupMember of new users
		for(GroupMember grpMembr: [SELECT Id, GroupId, UserOrGroupId 
		  FROM GroupMember 
		  WHERE UserOrGroupId IN : userIdSet 
		  AND GroupId IN : groupIdVsNameMap.keySet() 
		  LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())])
		{
	List<String> groupNameLst = new List<String>();
	if(userIdVsGrpNameListMap.containskey(grpMembr.UserOrGroupId)){
			groupNameLst = userIdVsGrpNameListMap.get(grpMembr.UserOrGroupId);
			groupNameLst.add(groupIdVsNameMap.get(grpMembr.GroupId));
			userIdVsGrpNameListMap.put(grpMembr.UserOrGroupId,groupNameLst);
	}else{
			groupNameLst.add(groupIdVsNameMap.get(grpMembr.GroupId));
			userIdVsGrpNameListMap.put(grpMembr.UserOrGroupId,groupNameLst);
	}
		}
		//create response message
		for(Id userId: userIdSet)
		{
	List<GroupNamesList> grpMemListWrap = new List<GroupNamesList>();
	if(userIdVsGrpNameListMap.get(userId) != null){
			for(String grp: userIdVsGrpNameListMap.get(userId)){
	 grpMemListWrap.add(new GroupNamesList(grp));
			}
	}
	responseWrapList.add(new ResponseWrapper(userId, userIdVsNokiaIdMap.get(userId), 
		 userIdVsProfileNameMap.get(userId), 
		 grpMemListWrap));
		}
		res.statusCode = 200;
		res.responseBody = Blob.valueOf(JSON.serialize(responseWrapList));
		CAPS_SecurityGroupsRESTUtil.createInterfaceLog('Request Body: '+req.requestBody.toString(), 'Response Body: '+res.responseBody.toString(), 'Success', interfaceLogName, 'Request URI: '+req.requestURI);
	  }
	}catch(Exception exp){
	  CAPS_SecurityGroupsRESTUtil.excptionHandle(exp, res, errormsg);
	  if(!test.isRunningTest()){CAPS_SecurityGroupsRESTUtil.createInterfaceLog('Request Body: '+req.requestBody.toString(), 'Response Body: '+res.responseBody.toString(), 'Failure', interfaceLogName, 'Request URI: '+req.requestURI);}
	}
  }
}