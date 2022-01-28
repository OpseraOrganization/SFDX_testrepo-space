@isTest
public class CAPS_GetSFCHSecurityGroupsRESTTest {
	@testSetup   
	static void setuptestdata(){
		list<User> userList = CAPS_SecurityGroupTestData.createUserData(5);
		list<User> newuserList= new list<User>();
		Integer i = 100087;
		for(User eachUser: userList){
			eachUser.Nokia_ID__c = String.valueOf(i+1);
			newuserList.add(eachUser);
			i = i+1;
		}
		insert newuserList;
		list<Group> groupList = CAPS_SecurityGroupTestData.createPublicGroupData(5);
		insert groupList;
		List<GroupMember> grpMemberList = new List<GroupMember>();
		for(Group grp : groupList){
			grpMemberList.add(CAPS_SecurityGroupTestData.createPublicGroupMemberData(newuserList[0].Id, grp.Id));
		}
		insert grpMemberList;
	}
	@isTest
	public static void whenNoProfileOrGroupinCustomSettings(){
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/services/apexrest/GetSFCHSecurityGroups';
		req.httpMethod = 'GET';
		req.requestBody = blob.valueOf('test');
		RestContext.request = req;
		RestContext.response = res;
		List<CH_Settings__c> chSetList = new List<CH_Settings__c>();
		CH_Settings__c chSet = new CH_Settings__c();
		chSet.Name = 'LogInterfaceLogOrNot4SecurityGroupAPIs';
		chSet.SettingValue__c = 'Yes';
		chSetList.add(chSet);
		insert chSetList;
		system.runAs(new User(Id = Userinfo.getUserId())){
			Test.startTest();
			CAPS_GetSFCHSecurityGroupsREST.chSecurityGroups();
			System.assert(res.ResponseBody.toString().contains('Group Setup is not correct in Salesforce Custom Settings'));
			Test.stopTest();
		}
	}
	@isTest
	public static void withCustomSettingsDataButInvalidGrps(){
		Set<String> nokiaIdSet = new Set<String>{'100087','100088','100089','100090','100091'};
		List<User> userList = new List<User>([SELECT Id, Name, Nokia_ID__c, ProfileId, Profile.Name,CreatedDate 
					FROM User 
					WHERE Nokia_ID__c IN :nokiaIdSet]);
		Set<String> userIdSet = new Set<String>();
		for(User usr: userList){
			userIdSet.add(usr.Id);
		}
		Set<String> grpIdSet = new Set<String>();
		
		List<GroupMember> groupmembrList = new List<GroupMember>([SELECT Id,GroupId,UserOrGroupId FROM GroupMember WHERE UserOrGroupId IN: userIdSet]);
		for(GroupMember grpmbr: groupmembrList){
			grpIdSet.add(grpmbr.GroupId);
		}
		List<Group> groupList = new List<Group>([SELECT Id, DeveloperName FROM Group WHERE Id IN: grpIdSet]);
		integer i = 1001;
		List<CH_SecurityGroups__c> csList = new List<CH_SecurityGroups__c>();

			CH_SecurityGroups__c sgSet = new CH_SecurityGroups__c();
			sgSet = CAPS_SecurityGroupTestData.createCustomSettingData('00G3C78900o03f', 'testGrp');
			sgSet.Name = 'test'+String.ValueOf(i);
			csList.add(sgSet);
		insert csList;
		
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/services/apexrest/GetSFCHSecurityGroups';
		req.httpMethod = 'GET';
		req.requestBody = blob.valueOf('test');
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
			CAPS_GetSFCHSecurityGroupsREST.chSecurityGroups();
			System.assert(res.ResponseBody.toString().contains('Exception'));
			Test.stopTest();
		}
	}
	@isTest
	public static void withCustomSettingsDataButNoGrps(){
		Set<String> nokiaIdSet = new Set<String>{'100087','100088','100089','100090','100091'};
		List<User> userList = new List<User>([SELECT Id, Name, Nokia_ID__c, ProfileId, Profile.Name,CreatedDate 
					FROM User 
					WHERE Nokia_ID__c IN :nokiaIdSet]);
		Set<String> userIdSet = new Set<String>();
		for(User usr: userList){
			userIdSet.add(usr.Id);
		}
		Set<String> grpIdSet = new Set<String>();
		
		List<GroupMember> groupmembrList = new List<GroupMember>([SELECT Id,GroupId,UserOrGroupId FROM GroupMember WHERE UserOrGroupId IN: userIdSet]);
		for(GroupMember grpmbr: groupmembrList){
			grpIdSet.add(grpmbr.GroupId);
		}
		List<Group> groupList = new List<Group>([SELECT Id, DeveloperName FROM Group WHERE Id IN: grpIdSet]);
		integer i = 1001;
		List<CH_SecurityGroups__c> csList = new List<CH_SecurityGroups__c>();

			CH_SecurityGroups__c sgSet = new CH_SecurityGroups__c();
			sgSet = CAPS_SecurityGroupTestData.createCustomSettingData('00G3C000000o03f', 'testGrp');
			sgSet.Name = 'test'+String.ValueOf(i);
			csList.add(sgSet);
		insert csList;
		
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/services/apexrest/GetSFCHSecurityGroups';
		req.httpMethod = 'GET';
		req.requestBody = blob.valueOf('test');
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
			CAPS_GetSFCHSecurityGroupsREST.chSecurityGroups();
			System.assert(res.ResponseBody.toString().contains('No Group Found'));
			Test.stopTest();
		}
	}
	@isTest
	public static void withCustomSettingsData(){
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
		req.requestURI = '/services/apexrest/GetSFCHSecurityGroups';
		req.httpMethod = 'GET';
		req.requestBody = blob.valueOf('test');
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
			CAPS_GetSFCHSecurityGroupsREST.chSecurityGroups();
			System.assert(res.ResponseBody.toString().contains(groupList[0].Id));
			System.assert(res.ResponseBody.toString().contains(groupList[1].Id));
			System.assert(res.ResponseBody.toString().contains(groupList[0].DeveloperName));
			System.assert(res.ResponseBody.toString().contains(groupList[1].DeveloperName));
			System.assert(res.ResponseBody.toString().contains('testGroup0'));
			System.assert(res.ResponseBody.toString().contains('testGroup1'));
			Test.stopTest();
		}
	}
}