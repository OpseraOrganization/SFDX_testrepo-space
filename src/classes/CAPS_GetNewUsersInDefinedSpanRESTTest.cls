@isTest
public class CAPS_GetNewUsersInDefinedSpanRESTTest {
	
	@testSetup   
	static void setuptestdata(){
		Profile sys_Admin_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
		
		list<User> userList = CAPS_SecurityGroupTestData.createUserData(5);
		list<User> userListNew = CAPS_SecurityGroupTestData.createUserDataNew(2);
		list<User> nonChUserList = CAPS_SecurityGroupTestData.createNonChUserData(2);
		userList.addAll(nonChUserList);
		userList.addAll(userListNew);
		list<User> newuserList = new list<User>();
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
		Set<String> nokiaIdSet = new Set<String>{'100087','100088','100089','100090','100091','100092','100093'};
		List<User> userList = new List<User>([SELECT Id, Name, Nokia_ID__c, ProfileId, Profile.Name,CreatedDate 
					FROM User 
					WHERE Nokia_ID__c IN :nokiaIdSet]);
		datetime startTime = system.now().addMinutes(-10);
		datetime endTime = system.now();
		String startday = string.valueOf(startTime.day());
		String startmonth = string.valueOf(startTime.month());
		String starthour = string.valueOf(startTime.hour());
		String startminute = string.valueOf(startTime.minute());
		String startsecond = string.valueOf(startTime.second());
		String startyear = string.valueOf(startTime.year());
		
		String endday = string.valueOf(endTime.day());
		String endmonth = string.valueOf(endTime.month());
		String endhour = string.valueOf(endTime.hour());
		String endminute = string.valueOf(endTime.minute());
		String endsecond = string.valueOf(endTime.second());
		String endyear = string.valueOf(endTime.year());
		
		String startDtTime = startyear+'-'+startmonth+'-'+ startday +'T'+starthour+':' + startminute+':'+ startsecond +':58.000Z';
		String endDtTime = endyear+'-'+endmonth+'-'+ endday +'T'+endhour+':' + endminute+':'+ endsecond +':58.000Z';
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/services/apexrest/GetNewUsers/startdatetime='+startDtTime+'/enddatetime='+endDtTime;
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
			CAPS_GetNewUsersInDefinedSpanREST.userdetails();
			System.assert(res.ResponseBody.toString().contains('Group or Profile Setup is not correct in Salesforce Custom Settings'));
			Test.stopTest();
		}
	}
	@isTest
	public static void whenNoProfileOrGroupinCustomSettingsNoRQSTBody(){
		Set<String> nokiaIdSet = new Set<String>{'100087','100088','100089','100090','100091','100092','100093'};
		List<User> userList = new List<User>([SELECT Id, Name, Nokia_ID__c, ProfileId, Profile.Name,CreatedDate 
					FROM User 
					WHERE Nokia_ID__c IN :nokiaIdSet]);
		datetime startTime = system.now().addMinutes(-10);
		datetime endTime = system.now();
		String startday = string.valueOf(startTime.day());
		String startmonth = string.valueOf(startTime.month());
		String starthour = string.valueOf(startTime.hour());
		String startminute = string.valueOf(startTime.minute());
		String startsecond = string.valueOf(startTime.second());
		String startyear = string.valueOf(startTime.year());
		
		String endday = string.valueOf(endTime.day());
		String endmonth = string.valueOf(endTime.month());
		String endhour = string.valueOf(endTime.hour());
		String endminute = string.valueOf(endTime.minute());
		String endsecond = string.valueOf(endTime.second());
		String endyear = string.valueOf(endTime.year());
		
		String startDtTime = startyear+'-'+startmonth+'-'+ startday +'T'+starthour+':' + startminute+':'+ startsecond +':58.000Z';
		String endDtTime = endyear+'-'+endmonth+'-'+ endday +'T'+endhour+':' + endminute+':'+ endsecond +':58.000Z';
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/services/apexrest/GetNewUsers/startdatetime='+startDtTime+'/enddatetime='+endDtTime;
		req.httpMethod = 'GET';
		//req.requestBody = blob.valueOf('test');
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
			CAPS_GetNewUsersInDefinedSpanREST.userdetails();
			System.assert(res.ResponseBody.toString().contains('Exception'));
			Test.stopTest();
		}
	}
	@isTest
	public static void withCustomSettingsData(){
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
		datetime startTime = system.now().addMinutes(-10);
		datetime endTime = system.now();
		String startday = string.valueOf(startTime.day());
		String startmonth = string.valueOf(startTime.month());
		String starthour = string.valueOf(startTime.hour());
		String startminute = string.valueOf(startTime.minute());
		String startsecond = string.valueOf(startTime.second());
		String startyear = string.valueOf(startTime.year());
		
		String endday = string.valueOf(endTime.day());
		String endmonth = string.valueOf(endTime.month());
		String endhour = string.valueOf(endTime.hour());
		String endminute = string.valueOf(endTime.minute());
		String endsecond = string.valueOf(endTime.second());
		String endyear = string.valueOf(endTime.year());
		
		String startDtTime = startyear+'-'+startmonth+'-'+ startday +'T'+starthour+':' + startminute+':'+ startsecond +':58.000Z';
		String endDtTime = endyear+'-'+endmonth+'-'+ endday +'T'+endhour+':' + endminute+':'+ endsecond +':58.000Z';
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/services/apexrest/GetNewUsers/startdatetime='+startDtTime+'/enddatetime='+endDtTime;
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
			CAPS_GetNewUsersInDefinedSpanREST.userdetails();
			System.assert(res.ResponseBody.toString().contains(groupList[0].DeveloperName));
			System.assert(res.ResponseBody.toString().contains(groupList[0].DeveloperName));
			System.assert(res.ResponseBody.toString().contains('CH_Case Handler'));
			Test.stopTest();
		}
	}
	@isTest
	public static void withCustomSettingsDataNoUser(){
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
		datetime startTime = system.now().addMinutes(-1);
		datetime endTime = system.now();
		String startday = string.valueOf(startTime.day());
		String startmonth = string.valueOf(startTime.month());
		String starthour = string.valueOf(startTime.hour());
		String startminute = string.valueOf(startTime.minute());
		String startsecond = string.valueOf(startTime.second());
		String startyear = string.valueOf(startTime.year());
		
		String endday = string.valueOf(endTime.day());
		String endmonth = string.valueOf(endTime.month());
		String endhour = string.valueOf(endTime.hour());
		String endminute = string.valueOf(endTime.minute());
		String endsecond = string.valueOf(endTime.second());
		String endyear = string.valueOf(endTime.year());
		
		String startDtTime = startyear+'-'+startmonth+'-'+ startday +'T'+starthour+':' + startminute+':'+ startsecond +':58.000Z';
		String endDtTime = endyear+'-'+endmonth+'-'+ endday +'T'+endhour+':' + endminute+':'+ endsecond +':58.000Z';
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		//res.responseBody ='';
		req.requestURI = '/services/apexrest/GetNewUsers/startdatetime=2078-05-17T13:50:58.000Z/enddatetime=2078-05-17T10:50:58.000Z';
		req.httpMethod = 'GET';
		req.requestBody = blob.valueOf('test');
		///services/apexrest/GetNewUsers/startdatetime=2012-04-15T13:50:58.000Z/enddatetime=2019-04-16T10:50:58.000Z
		RestContext.request = req;
		RestContext.response = res;
		
		system.runAs(new User(Id = Userinfo.getUserId())){
			Test.startTest();
			CAPS_GetNewUsersInDefinedSpanREST.userdetails();
			Test.stopTest();
		}
	}
}