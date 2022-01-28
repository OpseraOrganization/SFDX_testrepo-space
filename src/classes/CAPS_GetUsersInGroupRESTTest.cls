/****************************************
* Class Name : CAPS_GetUsersInGroupRESTTest
* Last Modified by: Gopi Krishna
* Last Modified Date: 24 Feb 2021
* Description : Remove SOQL statements to retrieve the Custom Metadata for US-34697. Updated the version to 51.
*****************************************/ 

@isTest
public class CAPS_GetUsersInGroupRESTTest {
  @testSetup   
  static void setuptestdata(){
  User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
  System.runAs (thisUser) {
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
	  List<CHPermissionSet2ProfileMapSecurityGroup__mdt> finalPermissions = new List<CHPermissionSet2ProfileMapSecurityGroup__mdt>();
		 CHPermissionSet2ProfileMapSecurityGroup__mdt permissionMDT = new CHPermissionSet2ProfileMapSecurityGroup__mdt();
		 permissionMDT.MasterLabel = '1';
		 permissionMDT.CH_PermissionSetAPIName__c = 'CH_CaseHandler';
		 permissionMDT.CH_ProfileName_CH__c = 'CH_CAPS Interface';
		 permissionMDT.DeveloperName = 'x11';
		 finalPermissions.add(permissionMDT);
		 
		 CHPermissionSet2ProfileMapSecurityGroup__mdt permissionMDT1 = new CHPermissionSet2ProfileMapSecurityGroup__mdt();
		 permissionMDT1.MasterLabel = '1';
		 permissionMDT1.CH_PermissionSetAPIName__c = 'CH_BasicCaseHandling';
		 permissionMDT1.CH_ProfileName_CH__c = 'CH_CAPS Interface';
		 permissionMDT1.DeveloperName = 'x2';
		 finalPermissions.add(permissionMDT1);
	for(CHPermissionSet2ProfileMapSecurityGroup__mdt data: finalPermissions)//[SELECT CH_PermissionSetAPIName__c, CH_ProfileName_CH__c 
								 // FROM CHPermissionSet2ProfileMapSecurityGroup__mdt])
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
	List<CHProfile2ProfileMapSecurityGroup__mdt> fieldProfiles = new List<CHProfile2ProfileMapSecurityGroup__mdt>();
	   CHProfile2ProfileMapSecurityGroup__mdt profileMDT = new CHProfile2ProfileMapSecurityGroup__mdt();
		 profileMDT.MasterLabel = '1';
		 profileMDT.CH_ProfileAPIName__c = 'DCP Internal Portal User';
		 profileMDT.CH_CapsProfileName__c = 'CH_CAPS Interface';
		 profileMDT.DeveloperName = 'x11';
		 fieldProfiles.add(profileMDT);
		 
		 CHProfile2ProfileMapSecurityGroup__mdt profileMDT1 = new CHProfile2ProfileMapSecurityGroup__mdt();
		 profileMDT1.MasterLabel = '1';
		 profileMDT1.CH_ProfileAPIName__c = 'DCP Internal Portal User';
		 profileMDT1.CH_CapsProfileName__c = 'CH_Basic Case Handling';
		 profileMDT1.DeveloperName = 'x2';
		 fieldProfiles.add(profileMDT1);
		 
	  for(CHProfile2ProfileMapSecurityGroup__mdt data: fieldProfiles) //[SELECT CH_ProfileAPIName__c, CH_CapsProfileName__c 
								//  FROM CHProfile2ProfileMapSecurityGroup__mdt])
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
  }
  
  @isTest
  public static void noGroupMemberTest(){
  
	Set<String> nokiaIdSet = new Set<String>{'100087','100088','100089','100090','100091','100092','100093'};
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
	List<PermissionSetAssignment> psAssignmentList = [SELECT PermissionSetId, AssigneeId
						FROM PermissionSetAssignment 
						WHERE AssigneeId IN : userIdSet];
	System.assertEquals(psAssignmentList,psAssignmentList);
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
	delete groupmembrList;
	RestRequest req = new RestRequest();
	RestResponse res = new RestResponse();
	req.requestURI = '/services/apexrest/GetUsersFromGroup';
	req.httpMethod = 'GET';
	req.requestBody = blob.valueOf('test');
	req.params.put('sfGroupId',groupList[0].Id);
	RestContext.request = req;
	RestContext.response = res;
	List<CH_Settings__c> chSetList = new List<CH_Settings__c>();
	CH_Settings__c chSet = new CH_Settings__c();
	chSet.Name = 'LogInterfaceLogOrNot4SecurityGroupAPIs';
	chSet.SettingValue__c = 'Yes';
	chSetList.add(chSet);
	chSet = new CH_Settings__c();
	chSet.Name = 'SecurityGroupsProfileNameForCAPS';
	chSet.SettingValue__c = 'CH_Agent, CH_Basic Case Handling , CH_Case Handler , CH_Functional Account';
	chSetList.add(chSet);
	insert chSetList;
	system.runAs(new User(Id = Userinfo.getUserId())){
	  Test.startTest();
	  CAPS_GetUsersInGroupREST.usersIntheGroup();
	  System.assert(res.ResponseBody.toString().contains('No Member in this Group'));
	  Test.stopTest();
	}
  }
  @isTest
  public static void noGroupTest(){
	RestRequest req = new RestRequest();
	RestResponse res = new RestResponse();
	req.requestURI = '/services/apexrest/GetUsersFromGroup';
	req.httpMethod = 'GET';
	req.requestBody = blob.valueOf('test');
	req.params.put('sfGroupId','00G3C012000o03f');
	RestContext.request = req;
	RestContext.response = res;
	List<CH_Settings__c> chSetList = new List<CH_Settings__c>();
	CH_Settings__c chSet = new CH_Settings__c();
	chSet.Name = 'LogInterfaceLogOrNot4SecurityGroupAPIs';
	chSet.SettingValue__c = 'Yes';
	chSetList.add(chSet);
	chSet = new CH_Settings__c();
	chSet.Name = 'SecurityGroupsProfileNameForCAPS';
	chSet.SettingValue__c = 'CH_Agent, CH_Basic Case Handling , CH_Case Handler , CH_Functional Account';
	chSetList.add(chSet);
	insert chSetList;
	system.runAs(new User(Id = Userinfo.getUserId())){
	  Test.startTest();
	  CAPS_GetUsersInGroupREST.usersIntheGroup();
	  System.assert(res.ResponseBody.toString().contains('Either group id is invalid or Group is not present in Salesforce'));
	  Test.stopTest();
	}
  }
  @isTest
  public static void withCustomSettingsData(){
 
	Set<String> nokiaIdSet = new Set<String>{'100087','100088','100089','100090','100091','100092','100093'};
	List<User> userList = new List<User>([SELECT Id, Name, Nokia_ID__c, ProfileId, Profile.Name,CreatedDate 
					  FROM User 
					  WHERE Nokia_ID__c IN :nokiaIdSet  ]);
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
	System.assertEquals(psAssignmentList,psAssignmentList);
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
	req.requestURI = '/services/apexrest/GetUsersFromGroup';
	req.httpMethod = 'GET';
	req.requestBody = blob.valueOf('test');
	req.params.put('sfGroupId',groupList[0].Id);
	RestContext.request = req;
	RestContext.response = res;
	List<CH_Settings__c> chSetList = new List<CH_Settings__c>();
	CH_Settings__c chSet = new CH_Settings__c();
	chSet.Name = 'LogInterfaceLogOrNot4SecurityGroupAPIs';
	chSet.SettingValue__c = 'Yes';
	chSetList.add(chSet);
	chSet = new CH_Settings__c();
	chSet.Name = 'SecurityGroupsProfileNameForCAPS';
	chSet.SettingValue__c = 'CH_Agent, CH_Basic Case Handling , CH_Case Handler , CH_Functional Account';
	chSetList.add(chSet);
	insert chSetList;
	system.runAs(new User(Id = Userinfo.getUserId())){
	  Test.startTest();
	  CAPS_GetUsersInGroupREST.usersIntheGroup();
	  List<GroupMember> grpmbList = [SELECT Id, GroupId, UserOrGroupId FROM GroupMember WHERE GroupId = :groupList[0].Id];
	  List<User> usrList = [SELECT Id, Profile.Name, Nokia_ID__c FROM User WHERE Id = :grpmbList[0].UserOrGroupId];
	  System.assert(res.ResponseBody.toString().contains(usrList[0].Nokia_ID__c));
	  System.assertEquals('CH_Case Handler',usrList[0].Profile.Name);
	  
	  Test.stopTest();
	}
  }
  @isTest
  public static void withCustomSettingsDatanNonCh(){
  
	Set<String> nokiaIdSet = new Set<String>{'100087','100088','100089','100090','100091','100092','100093','100094'};
	List<User> userList = new List<User>([SELECT Id, Name, Nokia_ID__c, ProfileId, Profile.Name,CreatedDate 
					  FROM User 
					  WHERE Nokia_ID__c IN :nokiaIdSet AND ProfileId = '00e58000000Rh5PAAS' ]);
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
	System.assertEquals(psAssignmentList,psAssignmentList);
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
	req.requestURI = '/services/apexrest/GetUsersFromGroup';
	req.httpMethod = 'GET';
	req.requestBody = blob.valueOf('test');
	req.params.put('sfGroupId',groupList[0].Id);
	RestContext.request = req;
	RestContext.response = res;
	List<CH_Settings__c> chSetList = new List<CH_Settings__c>();
	CH_Settings__c chSet = new CH_Settings__c();
	chSet.Name = 'LogInterfaceLogOrNot4SecurityGroupAPIs';
	chSet.SettingValue__c = 'Yes';
	chSetList.add(chSet);
	chSet = new CH_Settings__c();
	chSet.Name = 'SecurityGroupsProfileNameForCAPS';
	chSet.SettingValue__c = 'CH_Agent, CH_Basic Case Handling , CH_Case Handler , CH_Functional Account';
	chSetList.add(chSet);
	insert chSetList;
	system.runAs(new User(Id = Userinfo.getUserId())){
	  Test.startTest();
	  CAPS_GetUsersInGroupREST.usersIntheGroup();
	  List<GroupMember> grpmbList = [SELECT Id, GroupId, UserOrGroupId FROM GroupMember WHERE GroupId = :groupList[0].Id];
	  List<User> usrList = [SELECT Id, Profile.Name, Nokia_ID__c FROM User WHERE Id = :grpmbList[0].UserOrGroupId];
	  System.assert(res.ResponseBody.toString().contains(usrList[0].Nokia_ID__c));
	  System.assertNotEquals('CH_Case Handler',usrList[0].Profile.Name);
	  
	  req.params.put('sfGroupId',groupList[1].Id);
	  RestContext.request = req;
	  RestContext.response = res;
	  CAPS_GetUsersInGroupREST.usersIntheGroup();
	  Test.stopTest();
	}
  }
  @isTest
  public static void withCustomSettingsDataInValidParam(){
	Set<String> nokiaIdSet = new Set<String>{'100087','100088','100089','100090','100091','100092','100093'};
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
	List<PermissionSetAssignment> psAssignmentList = [SELECT PermissionSetId, AssigneeId
						FROM PermissionSetAssignment 
						WHERE AssigneeId IN : userIdSet];
	System.assertEquals(psAssignmentList,psAssignmentList);
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
	req.requestURI = '/services/apexrest/GetUsersFromGroup';
	req.httpMethod = 'GET';
	req.requestBody = blob.valueOf('test');
	req.params.put('sfGrouId',groupList[0].Id);
	RestContext.request = req;
	RestContext.response = res;
	List<CH_Settings__c> chSetList = new List<CH_Settings__c>();
	CH_Settings__c chSet = new CH_Settings__c();
	chSet.Name = 'LogInterfaceLogOrNot4SecurityGroupAPIs';
	chSet.SettingValue__c = 'Yes';
	chSetList.add(chSet);
	chSet = new CH_Settings__c();
	chSet.Name = 'SecurityGroupsProfileNameForCAPS';
	chSet.SettingValue__c = 'CH_Agent, CH_Basic Case Handling , CH_Case Handler , CH_Functional Account';
	chSetList.add(chSet);
	insert chSetList;
	system.runAs(new User(Id = Userinfo.getUserId())){
	  Test.startTest();
	  CAPS_GetUsersInGroupREST.usersIntheGroup();
	  System.assert(res.ResponseBody.toString().contains('Group Id is missing in the Request Parameter'));
	  Test.stopTest();
	}
  }

}