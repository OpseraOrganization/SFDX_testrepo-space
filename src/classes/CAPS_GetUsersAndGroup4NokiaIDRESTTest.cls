/****************************************
* Class Name : CAPS_GetUsersAndGroup4NokiaIDRESTTest
* Last Modified by: Gopi Krishna
* Last Modified Date: 24 Feb 2021
* Description : Remove SOQL statements to retrieve the Custom Metadata for US-34697. Updated the version to 51.
*****************************************/ 

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
		 
   /* for(CHPermissionSet2ProfileMapSecurityGroup__mdt data: [SELECT CH_PermissionSetAPIName__c, CH_ProfileName_CH__c 
								  FROM CHPermissionSet2ProfileMapSecurityGroup__mdt]) */
	  for(CHPermissionSet2ProfileMapSecurityGroup__mdt data: finalPermissions)							  
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
	system.runAs(newuserList[0]){
	insert psAssignmentList;}
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
		 
	 /* for(CHProfile2ProfileMapSecurityGroup__mdt data: [SELECT CH_ProfileAPIName__c, CH_CapsProfileName__c 
								  FROM CHProfile2ProfileMapSecurityGroup__mdt]) */
		 for(CHProfile2ProfileMapSecurityGroup__mdt data: fieldProfiles)						   
	  {
		SFProfileSet.add(data.CH_ProfileAPIName__c);
		profiletoProfileMap.put(data.CH_ProfileAPIName__c,data.CH_CapsProfileName__c);
	  }
		  List<GroupMember> grpMemberList = new List<GroupMember>();
	User SysAdmin = [SELECT IsActive,Id FROM User WHERE Profile.name = 'System Administrator' and IsActive = true Limit 1];

   system.runAs(SysAdmin){  
	list<Group> groupListNew = CAPS_SecurityGroupTestData.createPublicGroupData(7);
	insert groupListNew;
	Integer listSize = groupListNew.Size();
	for(Integer j=0;j<listSize;j++){
	  grpMemberList.add(CAPS_SecurityGroupTestData.createPublicGroupMemberData(newuserList[j].Id, groupListNew[j].Id));
	}
   
	insert grpMemberList;}
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
	List<CH_Settings__c> chSetListNew = new List<CH_Settings__c>();
	CH_Settings__c chSetNew = new CH_Settings__c();
	chSetNew.Name = 'LogInterfaceLogOrNot4SecurityGroupAPIs';
	chSetNew.SettingValue__c = 'Yes';
	chSetListNew.add(chSetNew);
	insert chSetListNew;
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
	Set<String> nokiaIdSet1 = new Set<String>{'100087','100088','100089','100090','100091','100092','100093','100094'};
	List<User> userList1 = new List<User>([SELECT Id, Name, Nokia_ID__c, ProfileId, Profile.Name,CreatedDate 
					  FROM User 
					  WHERE Nokia_ID__c IN :nokiaIdSet1]);
	Set<String> userIdSet1 = new Set<String>();
	for(User usr1: userList1){
	  userIdSet1.add(usr1.Id);
	}
	integer i = 1001;
	List<CH_SecurityGroups__c> csList1 = new List<CH_SecurityGroups__c>();
	Set<String> grpIdSet1 = new Set<String>();
	
	List<GroupMember> groupmembrList1 = new List<GroupMember>([SELECT Id,GroupId,UserOrGroupId FROM GroupMember WHERE UserOrGroupId IN: userIdSet1]);
	for(GroupMember grpmbr1: groupmembrList1){
	  grpIdSet1.add(grpmbr1.GroupId);
	}
	List<PermissionSetAssignment> psAssignmentList = [SELECT PermissionSetId, AssigneeId
						FROM PermissionSetAssignment 
						WHERE AssigneeId IN : userIdSet1];
	System.assertEquals(psAssignmentList,psAssignmentList);
	List<Group> groupList1 = new List<Group>([SELECT Id, DeveloperName FROM Group WHERE Id IN: grpIdSet1]);
	for(Group grp1: groupList1)
	{
	  CH_SecurityGroups__c sgSet1 = new CH_SecurityGroups__c();
	  sgSet1 = CAPS_SecurityGroupTestData.createCustomSettingData(grp1.Id, grp1.DeveloperName);
	  sgSet1.Name = 'test'+String.ValueOf(i);
	  i = i+1;
	  csList1.add(sgSet1);
	  
	}
	insert csList1;
	RestRequest req1 = new RestRequest();
	RestResponse res1 = new RestResponse();
	req1.requestURI = '/services/apexrest/CAPS_GetUsersAndGroup4NokiaIDREST';
	req1.httpMethod = 'POST';
	String jsonBody = '[ { "nokiaEmployeeId" : "100087"}, {  "nokiaEmployeeId" : "100088"}, {  "nokiaEmployeeId" : "100089"}, {  "nokiaEmployeeId" : "100090"}, {  "nokiaEmployeeId" : "100091"}, {  "nokiaEmployeeId" : "100092"}, {  "nokiaEmployeeId" : "100093"}, {  "nokiaEmployeeId" : "100094"} ]';
	req1.requestBody = blob.valueOf(jsonBody);
	RestContext.response = res1;
	RestContext.request = req1;
	List<CH_Settings__c> chSetList1 = new List<CH_Settings__c>();
	CH_Settings__c chSet1 = new CH_Settings__c();
	chSet1.Name = 'LogInterfaceLogOrNot4SecurityGroupAPIs';
	chSet1.SettingValue__c = 'Yes';
	chSetList1.add(chSet1);
	insert chSetList1;
	system.runAs(new User(Id = Userinfo.getUserId())){
	  Test.startTest();
	  CAPS_GetUsersAndGroup4NokiaIDREST.usersdetailsAndGroupMembership();
	  System.assert(res1.ResponseBody.toString().contains('CH_Case Handler'));
	  jsonBody = '[ { "nokiaEmployeeId" : "100087"}, {  "nokiaEmployeeId" : ""}, {  "nokiaEmployeeId" : "100089"} ]';
	  req1.requestBody = blob.valueOf(jsonBody);
	  req1.requestBody = blob.valueOf(jsonBody);
	  RestContext.request = req1;
	  CAPS_GetUsersAndGroup4NokiaIDREST.usersdetailsAndGroupMembership();
	  System.assert(res1.ResponseBody.toString().contains('Nokia Employee Id Cannot be empty or null in request'));
	  Test.stopTest();
	}
  }
  @isTest
  public static void withBodyNoUserFound(){
	Set<String> nokiaIdSet2 = new Set<String>{'100087','100088','100089','100090','100091'};
	List<User> userList2 = new List<User>([SELECT Id, Name, Nokia_ID__c, ProfileId, Profile.Name,CreatedDate 
					  FROM User 
					  WHERE Nokia_ID__c IN :nokiaIdSet2]);
	Set<String> userIdSet2 = new Set<String>();
	for(User usr2: userList2){
	  userIdSet2.add(usr2.Id);
	}
	integer i = 1001;
	List<CH_SecurityGroups__c> csList2 = new List<CH_SecurityGroups__c>();
	Set<String> grpIdSet2 = new Set<String>();
	
	List<GroupMember> groupmembrList2 = new List<GroupMember>([SELECT Id,GroupId,UserOrGroupId FROM GroupMember WHERE UserOrGroupId IN: userIdSet2]);
	for(GroupMember grpmbr2: groupmembrList2){
	  grpIdSet2.add(grpmbr2.GroupId);
	}
	List<Group> groupList2 = new List<Group>([SELECT Id, DeveloperName FROM Group WHERE Id IN: grpIdSet2]);
	for(Group grp2: groupList2)
	{
	  CH_SecurityGroups__c sgSet2 = new CH_SecurityGroups__c();
	  sgSet2 = CAPS_SecurityGroupTestData.createCustomSettingData(grp2.Id, grp2.DeveloperName);
	  sgSet2.Name = 'test'+String.ValueOf(i);
	  i = i+1;
	  csList2.add(sgSet2);
	  
	}
	insert csList2;
	RestRequest req2 = new RestRequest();
	RestResponse res2 = new RestResponse();
	req2.requestURI = '/services/apexrest/CAPS_GetUsersAndGroup4NokiaIDREST';
	req2.httpMethod = 'POST'; 
	String jsonBody = '[ { "nokiaEmployeeId" : "100098"}]';
	req2.requestBody = blob.valueOf(jsonBody);
	RestContext.response = res2;
	RestContext.request = req2;
	List<CH_Settings__c> chSetList2 = new List<CH_Settings__c>();
	CH_Settings__c chSet2 = new CH_Settings__c();
	chSet2.Name = 'LogInterfaceLogOrNot4SecurityGroupAPIs';
	chSet2.SettingValue__c = 'Yes';
	chSetList2.add(chSet2);
	insert chSetList2;
	system.runAs(new User(Id = Userinfo.getUserId())){
	  Test.startTest();
	  CAPS_GetUsersAndGroup4NokiaIDREST.usersdetailsAndGroupMembership();
	  System.assert(res2.ResponseBody.toString().contains('No User Found'));
	  Test.stopTest();
	}
  }
}