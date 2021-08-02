@isTest
public class CAPS_GetUsersAndGroup4NokiaIDRESTTest {
  @testSetup   
  static void setuptestdata(){
	Profile sys_Admin_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
	
	list<User> userList = CAPS_SecurityGroupTestData.createUserData(5);
	   list<User> userListNew = CAPS_SecurityGroupTestData.createUserDataNew(2);
	list<User> nonChUserList = CAPS_SecurityGroupTestData.createNonChUserData(2);
	userList.addAll(nonChUserList);
	userList.addAll(userListNew);
	list<User> newuserList= new list<User>();
	Set<String> finalPermissionSetSet = new Set<String>();
	List<String> permissionSetSetId = new List<String>();
	  Set<String> SFProfileSet =new Set<String>();
		Map<String,String> profiletoProfileMap =new Map<String,String>();
	Integer i = 100087;
	for(User eachUser: userList){
	  eachUser.Nokia_ID__c = String.valueOf(i+1);
	  newuserList.add(eachUser);
	  i = i+1;
	}
	insert newuserList;

	for(CHPermissionSet2ProfileMapSecurityGroup__mdt data: [SELECT CH_PermissionSetAPIName__c, CH_ProfileName_CH__c 
								  FROM CHPermissionSet2ProfileMapSecurityGroup__mdt])
	{
	  finalPermissionSetSet.add(data.CH_PermissionSetAPIName__c);
	}
	for(PermissionSet pset : [SELECT Id FROM PermissionSet WHERE Name IN: finalPermissionSetSet]){
	  permissionSetSetId.add(pset.Id);
	}
	List<PermissionSetAssignment> psAssignmentList = new List<PermissionSetAssignment>();
	for(User usr: newuserList){
	  if(usr.ProfileId == sys_Admin_profile.Id && !permissionSetSetId.isEmpty()){
		psAssignmentList.add(CAPS_SecurityGroupTestData.createPermssionSetAssignData(permissionSetSetId[0], usr.Id));
	  }
	}
	insert psAssignmentList;
	  for(CHProfile2ProfileMapSecurityGroup__mdt data: [SELECT CH_ProfileAPIName__c, CH_CapsProfileName__c 
								  FROM CHProfile2ProfileMapSecurityGroup__mdt])
	  {
		SFProfileSet.add(data.CH_ProfileAPIName__c);
		profiletoProfileMap.put(data.CH_ProfileAPIName__c,data.CH_CapsProfileName__c);
	  }
	list<Group> groupList = CAPS_SecurityGroupTestData.createPublicGroupData(7);
	insert groupList;
	List<GroupMember> grpMemberList = new List<GroupMember>();
	Integer listSize = groupList.Size();
	for(Integer j=0;j<listSize;j++){
	  grpMemberList.add(CAPS_SecurityGroupTestData.createPublicGroupMemberData(newuserList[j].Id, groupList[j].Id));
	}
	insert grpMemberList;
  }
  @isTest
  public static void whenNoGroupinCustomSettings(){
	RestRequest req = new RestRequest();
	RestResponse res = new RestResponse();
	req.requestURI = '/services/apexrest/CAPS_GetUsersAndGroup4NokiaIDREST';
	req.httpMethod = 'POST';
	String jsonBody = '[ { "nokiaEmployeeId" : "100087"}, {  "nokiaEmployeeId" : "100088"}, {  "nokiaEmployeeId" : "100089"} ]';
	req.requestBody = blob.valueOf(jsonBody);
	RestContext.response = res;
	RestContext.request = req;
	List<CH_Settings__c> chSetList = new List<CH_Settings__c>();
	CH_Settings__c chSet = new CH_Settings__c();
	chSet.Name = 'LogInterfaceLogOrNot4SecurityGroupAPIs';
	chSet.SettingValue__c = 'Yes';
	chSetList.add(chSet);
	insert chSetList;
	system.runAs(new User(Id = Userinfo.getUserId())){
	  Test.startTest();
	  CAPS_GetUsersAndGroup4NokiaIDREST.usersdetailsAndGroupMembership();
	  System.assert(res.ResponseBody.toString().contains('Group Setup is not correct in Salesforce Custom Settings'));
	  Test.stopTest();
	}
  }
  @isTest
  public static void whenNoBody(){
	Set<String> nokiaIdSet = new Set<String>{'100087','100088','100089','100090','100091'};
	List<User> userList = new List<User>([SELECT Id, Name, Nokia_ID__c, ProfileId, Profile.Name,CreatedDate 
					  FROM User 
					  WHERE Nokia_ID__c IN :nokiaIdSet]);
	Set<String> userIdSet = new Set<String>();
	for(User usr: userList){
	  userIdSet.add(usr.Id);
	}
	integer i = 1001;
	List<CH_SecurityGroups__c> csList = new List<CH_SecurityGroups__c>();
	Set<String> grpIdSet = new Set<String>();
	
	List<GroupMember> groupmembrList = new List<GroupMember>([SELECT Id,GroupId,UserOrGroupId FROM GroupMember WHERE UserOrGroupId IN: userIdSet]);
	for(GroupMember grpmbr: groupmembrList){
	  grpIdSet.add(grpmbr.GroupId);
	}
	List<Group> groupList = new List<Group>([SELECT Id, DeveloperName FROM Group WHERE Id IN: grpIdSet]);
	for(Group grp: groupList)
	{
	  CH_SecurityGroups__c sgSet = new CH_SecurityGroups__c();
	  sgSet = CAPS_SecurityGroupTestData.createCustomSettingData(grp.Id, grp.DeveloperName);
	  sgSet.Name = 'test'+String.ValueOf(i);
	  i = i+1;
	  csList.add(sgSet);
	  
	}
	insert csList;
	RestRequest req = new RestRequest();
	RestResponse res = new RestResponse();
	req.requestURI = '/services/apexrest/CAPS_GetUsersAndGroup4NokiaIDREST';
	req.httpMethod = 'POST';
	String jsonBody = '';
	req.requestBody = blob.valueOf(jsonBody);
	RestContext.response = res;
	RestContext.request = req;
	List<CH_Settings__c> chSetList = new List<CH_Settings__c>();
	CH_Settings__c chSet = new CH_Settings__c();
	chSet.Name = 'LogInterfaceLogOrNot4SecurityGroupAPIs';
	chSet.SettingValue__c = 'Yes';
	chSetList.add(chSet);
	insert chSetList;
	system.runAs(new User(Id = Userinfo.getUserId())){
	  Test.startTest();
	  CAPS_GetUsersAndGroup4NokiaIDREST.usersdetailsAndGroupMembership();
	  System.assert(res.ResponseBody.toString().contains('Could not find a body in the request'));
	  Test.stopTest();
	}
  }
  @isTest
  public static void withBody(){
	Set<String> nokiaIdSet = new Set<String>{'100087','100088','100089','100090','100091','100092','100093','100094'};
	List<User> userList = new List<User>([SELECT Id, Name, Nokia_ID__c, ProfileId, Profile.Name,CreatedDate 
					  FROM User 
					  WHERE Nokia_ID__c IN :nokiaIdSet]);
	Set<String> userIdSet = new Set<String>();
	for(User usr: userList){
	  userIdSet.add(usr.Id);
	}
	integer i = 1001;
	List<CH_SecurityGroups__c> csList = new List<CH_SecurityGroups__c>();
	Set<String> grpIdSet = new Set<String>();
	
	List<GroupMember> groupmembrList = new List<GroupMember>([SELECT Id,GroupId,UserOrGroupId FROM GroupMember WHERE UserOrGroupId IN: userIdSet]);
	for(GroupMember grpmbr: groupmembrList){
	  grpIdSet.add(grpmbr.GroupId);
	}
	List<PermissionSetAssignment> psAssignmentList = [SELECT PermissionSetId, AssigneeId
						FROM PermissionSetAssignment 
						WHERE AssigneeId IN : userIdSet];
	List<Group> groupList = new List<Group>([SELECT Id, DeveloperName FROM Group WHERE Id IN: grpIdSet]);
	for(Group grp: groupList)
	{
	  CH_SecurityGroups__c sgSet = new CH_SecurityGroups__c();
	  sgSet = CAPS_SecurityGroupTestData.createCustomSettingData(grp.Id, grp.DeveloperName);
	  sgSet.Name = 'test'+String.ValueOf(i);
	  i = i+1;
	  csList.add(sgSet);
	  
	}
	insert csList;
	RestRequest req = new RestRequest();
	RestResponse res = new RestResponse();
	req.requestURI = '/services/apexrest/CAPS_GetUsersAndGroup4NokiaIDREST';
	req.httpMethod = 'POST';
	String jsonBody = '[ { "nokiaEmployeeId" : "100087"}, {  "nokiaEmployeeId" : "100088"}, {  "nokiaEmployeeId" : "100089"}, {  "nokiaEmployeeId" : "100090"}, {  "nokiaEmployeeId" : "100091"}, {  "nokiaEmployeeId" : "100092"}, {  "nokiaEmployeeId" : "100093"}, {  "nokiaEmployeeId" : "100094"} ]';
	req.requestBody = blob.valueOf(jsonBody);
	RestContext.response = res;
	RestContext.request = req;
	List<CH_Settings__c> chSetList = new List<CH_Settings__c>();
	CH_Settings__c chSet = new CH_Settings__c();
	chSet.Name = 'LogInterfaceLogOrNot4SecurityGroupAPIs';
	chSet.SettingValue__c = 'Yes';
	chSetList.add(chSet);
	insert chSetList;
	system.runAs(new User(Id = Userinfo.getUserId())){
	  Test.startTest();
	  CAPS_GetUsersAndGroup4NokiaIDREST.usersdetailsAndGroupMembership();
	  System.assert(res.ResponseBody.toString().contains('CH_Case Handler'));
	  jsonBody = '[ { "nokiaEmployeeId" : "100087"}, {  "nokiaEmployeeId" : ""}, {  "nokiaEmployeeId" : "100089"} ]';
	  req.requestBody = blob.valueOf(jsonBody);
	  req.requestBody = blob.valueOf(jsonBody);
	  RestContext.request = req;
	  CAPS_GetUsersAndGroup4NokiaIDREST.usersdetailsAndGroupMembership();
	  System.assert(res.ResponseBody.toString().contains('Nokia Employee Id Cannot be empty or null in request'));
	  Test.stopTest();
	}
  }
  @isTest
  public static void withBodyNoUserFound(){
	Set<String> nokiaIdSet = new Set<String>{'100087','100088','100089','100090','100091'};
	List<User> userList = new List<User>([SELECT Id, Name, Nokia_ID__c, ProfileId, Profile.Name,CreatedDate 
					  FROM User 
					  WHERE Nokia_ID__c IN :nokiaIdSet]);
	Set<String> userIdSet = new Set<String>();
	for(User usr: userList){
	  userIdSet.add(usr.Id);
	}
	integer i = 1001;
	List<CH_SecurityGroups__c> csList = new List<CH_SecurityGroups__c>();
	Set<String> grpIdSet = new Set<String>();
	
	List<GroupMember> groupmembrList = new List<GroupMember>([SELECT Id,GroupId,UserOrGroupId FROM GroupMember WHERE UserOrGroupId IN: userIdSet]);
	for(GroupMember grpmbr: groupmembrList){
	  grpIdSet.add(grpmbr.GroupId);
	}
	List<Group> groupList = new List<Group>([SELECT Id, DeveloperName FROM Group WHERE Id IN: grpIdSet]);
	for(Group grp: groupList)
	{
	  CH_SecurityGroups__c sgSet = new CH_SecurityGroups__c();
	  sgSet = CAPS_SecurityGroupTestData.createCustomSettingData(grp.Id, grp.DeveloperName);
	  sgSet.Name = 'test'+String.ValueOf(i);
	  i = i+1;
	  csList.add(sgSet);
	  
	}
	insert csList;
	RestRequest req = new RestRequest();
	RestResponse res = new RestResponse();
	req.requestURI = '/services/apexrest/CAPS_GetUsersAndGroup4NokiaIDREST';
	req.httpMethod = 'POST'; 
	String jsonBody = '[ { "nokiaEmployeeId" : "100098"}]';
	req.requestBody = blob.valueOf(jsonBody);
	RestContext.response = res;
	RestContext.request = req;
	List<CH_Settings__c> chSetList = new List<CH_Settings__c>();
	CH_Settings__c chSet = new CH_Settings__c();
	chSet.Name = 'LogInterfaceLogOrNot4SecurityGroupAPIs';
	chSet.SettingValue__c = 'Yes';
	chSetList.add(chSet);
	insert chSetList;
	system.runAs(new User(Id = Userinfo.getUserId())){
	  Test.startTest();
	  CAPS_GetUsersAndGroup4NokiaIDREST.usersdetailsAndGroupMembership();
	  System.assert(res.ResponseBody.toString().contains('No User Found'));
	  Test.stopTest();
	}
  }
}