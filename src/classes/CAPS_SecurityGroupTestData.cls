@isTest
public class CAPS_SecurityGroupTestData {
  
  public static list<User> createUserData(Integer size) {
	
	Profile ch_profile = [SELECT Id FROM Profile WHERE Name = 'CH_Case Handler'];
	
	list<User> userList = new list<User>();
	for(Integer i=0; i<size; i++)
	{
	  User eachUser = new User();
	  
	  eachUser.LastName = 'Sherwood'+i;
	  eachUser.FirstName = 'Alex'+i;
	  eachUser.Email = 'emailtest'+i+'@nokia.com';
	  eachUser.Username = 'usenametest'+i+'@nokia.com';
	  eachUser.Alias = 'alsher';
	  eachUser.ProfileId = ch_profile.Id;
	  eachUser.TimeZoneSidKey  = 'America/Denver';
	  eachUser.LocaleSidKey	= 'en_US';
	  eachUser.EmailEncodingKey  = 'UTF-8';
	  eachUser.LanguageLocaleKey = 'en_US';
	  userList.add(eachUser);
	}
	return userList;
  }
	public static list<User> createUserDataNew(Integer size) {
	
	Profile ch_profile = [SELECT Id FROM Profile WHERE Name = 'DCP Internal Portal User'];
	
	list<User> userList = new list<User>();
	for(Integer i=0; i<size; i++)
	{
	  User eachUser = new User();
	  
	  eachUser.LastName = 'Sher'+i;
	  eachUser.FirstName = 'Test'+i;
	  eachUser.Email = 'emailt'+i+'@nokia.com';
	  eachUser.Username = 'usename'+i+'@nokia.com';
	  eachUser.Alias = 'alsh1';
	  eachUser.ProfileId = ch_profile.Id;
	  eachUser.TimeZoneSidKey  = 'America/Denver';
	  eachUser.LocaleSidKey	= 'en_US';
	  eachUser.EmailEncodingKey  = 'UTF-8';
	  eachUser.LanguageLocaleKey = 'en_US';
	  eachUser.Nokia_ID__c ='10009'+i;
	  userList.add(eachUser);
	}
	
	return userList;
  }
   public static list<User> createNonChUserData(Integer size) {
	
	Profile nonch_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
	
	list<User> userList = new list<User>();
	for(Integer i=0; i<size; i++)
	{
	  User eachUser = new User();
	  
	  eachUser.LastName = 'Sherwood1'+i;
	  eachUser.FirstName = 'Alex1'+i;
	  eachUser.Email = 'emailtest1'+i+'@nokia.com';
	  eachUser.Username = 'usenametest1'+i+'@nokia.com';
	  eachUser.Alias = 'alsher';
	  eachUser.ProfileId = nonch_profile.Id;
	  eachUser.TimeZoneSidKey  = 'America/Denver';
	  eachUser.LocaleSidKey	= 'en_US';
	  eachUser.EmailEncodingKey  = 'UTF-8';
	  eachUser.LanguageLocaleKey = 'en_US';
	  userList.add(eachUser);
	}
	return userList;
  }
  
  public static list<Group> createPublicGroupData(Integer size) {
	
	list<Group> groupList = new list<Group>();
	for(Integer i=0; i<size; i++)
	{
	  Group testGroup = new Group();
	  testGroup.Name = 'testGroup'+i;
	  testGroup.DeveloperName = 'testGroup'+i;
	  groupList.add(testGroup);
	}
	return groupList;
  }
  
  public static GroupMember createPublicGroupMemberData(String userId, String groupId){
	GroupMember testGroupMember = new GroupMember();
	testGroupMember.UserOrGroupId = userId;
	testGroupMember.GroupId = groupId;
	return testGroupMember;
  }
  
  public static CH_SecurityGroups__c createCustomSettingData(String groupId, String groupName){
	CH_SecurityGroups__c chSet = new CH_SecurityGroups__c();
	chSet.GroupId__c = groupId;
	chSet.GroupName__c = groupName;
	return chSet;
  }
  public static PermissionSetAssignment createPermssionSetAssignData(String permissionSetId, String assigneeId){
	PermissionSetAssignment  psAssignment = new PermissionSetAssignment();
	psAssignment.PermissionSetId = permissionSetId;
	psAssignment.AssigneeId = assigneeId;
	return psAssignment;
  }
  
}