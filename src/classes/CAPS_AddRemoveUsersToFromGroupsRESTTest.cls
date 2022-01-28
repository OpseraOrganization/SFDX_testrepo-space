@isTest
public class CAPS_AddRemoveUsersToFromGroupsRESTTest {
	public static final string REQUEST_URI = '/services/apexrest/AddRemoveGroupmembership';
	public static final string ADD_OPERATION = '"operation":"add"';
	public static final string REMOVE_OPERATION = '"operation":"remove"';
	@testSetup   
	static void setuptestdata(){
		list<User> userList = CAPS_SecurityGroupTestData.createUserData(2);
		list<User> newuserList= new list<User>();
		Integer i = 100087;
		for(User eachUser: userList){
			eachUser.Nokia_ID__c = String.valueOf(i+1);
			newuserList.add(eachUser);
			i = i+1;
		}
		insert newuserList;
		list<Group> groupList = CAPS_SecurityGroupTestData.createPublicGroupData(2);
		insert groupList;
		List<GroupMember> grpMemberList = new List<GroupMember>();
		for(Group grp : groupList){
			grpMemberList.add(CAPS_SecurityGroupTestData.createPublicGroupMemberData(newuserList[0].Id, grp.Id));
		}
		System.runAs ( new User(Id = UserInfo.getUserId()) ) {
		insert grpMemberList;
		}
	}
	@isTest
	public static void whenNoGroupinCustomSettingsOrNoBody(){
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = REQUEST_URI;
		req.httpMethod = 'POST';
		String jsonBody = '[{"nokiaEmployeeId":"6161","sfGroupId":"00G3C001001WoX4UAK",'+ADD_OPERATION+'},{"nokiaEmployeeId":"6767","sfGroupId":"00G3C000101WoXJUA0",'+ADD_OPERATION+'}]';
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
			CAPS_AddRemoveUsersToFromGroupsREST.addOrRemoveGroupMemberPOST();// no group in custom settings
			System.assert(res.ResponseBody.toString().contains('Group Setup is not correct in Salesforce Custom Settings'));
			req.requestBody = blob.valueOf('');
			RestContext.request = req;
			CAPS_AddRemoveUsersToFromGroupsREST.addOrRemoveGroupMemberPOST();//empty body
			System.assert(res.ResponseBody.toString().contains('Could not find a body in the request'));
			Test.stopTest();
		}
	}
	@isTest
	public static void addUserORNoNokiaIdOrInvalidOprationOrDuplicateRqst(){
		Set<String> nokiaIdSet = new Set<String>{'100087','100088'};
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
		req.requestURI = REQUEST_URI;
		req.httpMethod = 'POST';
		String jsonBody = '[{"nokiaEmployeeId":"100087","sfGroupId":"'+groupList[0].Id+'",'+ADD_OPERATION+'},{"nokiaEmployeeId":"100088","sfGroupId":"'+groupList[0].Id+'",'+ADD_OPERATION+'}]';
		req.requestBody = blob.valueOf(jsonBody);
		RestContext.response = res;
		RestContext.request = req;
		List<CH_Settings__c> chSetList = new List<CH_Settings__c>();
		CH_Settings__c chSet = new CH_Settings__c();
		chSet.Name = 'LogInterfaceLogOrNot4SecurityGroupAPIs';
		chSet.SettingValue__c = 'Yes';
		chSetList.add(chSet);
		insert chSetList;
		string emptyString = '';
		system.runAs(new User(Id = Userinfo.getUserId())){
			Test.startTest();
			CAPS_AddRemoveUsersToFromGroupsREST.addOrRemoveGroupMemberPOST();// add user
			System.assert(res.ResponseBody.toString().contains('Successfully Added'));
			jsonBody = '[{"sfUserId":"00541000077fnM3","nokiaEmployeeId":"","sfGroupId":"'+groupList[0].Id+'",'+ADD_OPERATION+'},{"sfUserId":"00541000087fnM3","nokiaEmployeeId":"100088","sfGroupId":"'+groupList[0].Id+'",'+ADD_OPERATION+'}]';
			req.requestBody = blob.valueOf(jsonBody);
			RestContext.request = req;
			CAPS_AddRemoveUsersToFromGroupsREST.addOrRemoveGroupMemberPOST();//when nokia id is null
			System.assert(res.ResponseBody.toString().contains('Invalid Request. Both nokiaEmployeeId and sfUserId can not be populated in the request.'));
			jsonBody = '[{"sfUserId":"","nokiaEmployeeId":"","sfGroupId":"'+groupList[0].Id+'",'+REMOVE_OPERATION+'},{"sfUserId":"00541000097fnM3","nokiaEmployeeId":"100088","sfGroupId":"'+groupList[0].Id+'",'+ADD_OPERATION+'}]';
			req.requestBody = blob.valueOf(jsonBody);
			RestContext.request = req;
			CAPS_AddRemoveUsersToFromGroupsREST.addOrRemoveGroupMemberPOST();//when incorrect operation type
			System.assert(res.ResponseBody.toString().contains('Invalid Request. nokiaEmployeeId OR sfUserId, sfGroupId and operation can not be blank.'));
			jsonBody = '[{"sfUserId":"00541000077fnM3","nokiaEmployeeId":"","sfGroupId":"'+groupList[0].Id+'",'+REMOVE_OPERATION+'},{"sfUserId":"00541000077fnM3","nokiaEmployeeId":"","sfGroupId":"'+groupList[0].Id+'",'+REMOVE_OPERATION+'}]';
			req.requestBody = blob.valueOf(jsonBody);
			RestContext.request = req;
			CAPS_AddRemoveUsersToFromGroupsREST.addOrRemoveGroupMemberPOST();//when duplicate rqust body 
			System.assert(res.ResponseBody.toString().contains('Invalid Request. Duplicates in Request Body.'));
			jsonBody = '[{"sfUserId":"00541000077fnM3","nokiaEmployeeId":"","sfGroupId":"'+groupList[0].Id+'","operation":"remov"},{"sfUserId":"00541000097fnM3","nokiaEmployeeId":"","sfGroupId":"'+groupList[0].Id+'",'+ADD_OPERATION+'}]';
			req.requestBody = blob.valueOf(jsonBody);
			RestContext.request = req;
			CAPS_AddRemoveUsersToFromGroupsREST.addOrRemoveGroupMemberPOST();//invalid operation
			Test.stopTest();
		}
	}
	@isTest
	public static void withBodyRemoveUser(){
		Set<String> nokiaIdSet = new Set<String>{'100088','100089'};
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
		req.requestURI = REQUEST_URI;
		req.httpMethod = 'POST';
		String jsonBody = '[{"nokiaEmployeeId":"100088","sfGroupId":"'+groupList[1].Id+'",'+REMOVE_OPERATION+'}]';
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
			CAPS_AddRemoveUsersToFromGroupsREST.addOrRemoveGroupMemberPOST();//remove user
			System.assert(res.ResponseBody.toString().contains('Successfully Removed'));
			CAPS_AddRemoveUsersToFromGroupsREST.addOrRemoveGroupMemberPOST();//when already deleted
			System.assert(res.ResponseBody.toString().contains('User not in the Group'));
			jsonBody = '[{"sfUserId":"'+userList[0].Id+'","nokiaEmployeeId":"","sfGroupId":"'+groupList[1].Id+'",'+REMOVE_OPERATION+'},{"sfUserId":"'+userList[1].Id+'","nokiaEmployeeId":"","sfGroupId":"'+groupList[1].Id+'",'+REMOVE_OPERATION+'}]';
			req.requestBody = blob.valueOf(jsonBody);
			RestContext.request = req;
			CAPS_AddRemoveUsersToFromGroupsREST.addOrRemoveGroupMemberPOST();
			Test.stopTest();
		}
	}
	@isTest
	public static void invalidIdSoExp(){
		Set<String> nokiaIdSet = new Set<String>{'100087','100088'};
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
		req.requestURI = REQUEST_URI;
		req.httpMethod = 'POST';
		String jsonBody = '[{"nokiaEmployeeId":"100087","sfGroupId":"00G3C012000o03f",'+ADD_OPERATION+'},{"nokiaEmployeeId":"100088","sfGroupId":"00G3C012000o03f",'+ADD_OPERATION+'}]';
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
			CAPS_AddRemoveUsersToFromGroupsREST.addOrRemoveGroupMemberPOST();//invalid id to generate exception
			System.assert(res.ResponseBody.toString().contains('Exception'));
			Test.stopTest();
		}
	}
	@isTest
	public static void fifteenDigitGrpOrWrongGroup(){
		Set<String> nokiaIdSet = new Set<String>{'100087','100088'};
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
		String grpNotInSF = '00G3C000000oDP2';
		insert csList;
		String grpIdSTR = String.valueOf(groupList[0].Id).substring(0, 15);
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = REQUEST_URI;
		req.httpMethod = 'POST';
		String jsonBody = '[{"nokiaEmployeeId":"100087","sfGroupId":"'+grpIdSTR+'",'+ADD_OPERATION+'},{"nokiaEmployeeId":"100088","sfGroupId":"'+grpIdSTR+'",'+ADD_OPERATION+'}]';
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
			CAPS_AddRemoveUsersToFromGroupsREST.addOrRemoveGroupMemberPOST();// 15 digit id, so not present in SF in message. always using 18 digit id
			System.assert(res.ResponseBody.toString().contains('nokiaEmployeeId and sfGroupId are not available.'));
			jsonBody = '[{"nokiaEmployeeId":"100087","sfGroupId":"'+grpNotInSF+'",'+ADD_OPERATION+'},{"nokiaEmployeeId":"100088","sfGroupId":"'+grpNotInSF+'",'+ADD_OPERATION+'}]';
			req.requestBody = blob.valueOf(jsonBody);
			RestContext.request = req;
			CAPS_AddRemoveUsersToFromGroupsREST.addOrRemoveGroupMemberPOST();//probably hardcoded group is not SF
			System.assertEquals(res.statusCode, 500);
			Test.stopTest();
		}
	}
}