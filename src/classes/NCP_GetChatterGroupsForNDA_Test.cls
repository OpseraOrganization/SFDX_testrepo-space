/**********************************************************************************************************************
* Class Name - NCP_GetChatterGroupsForNDA_Test 
* author: Karan Monga
* Date: Aug-2021
* Description: Apex class without sharing for creating collaboration group member
* Modified By : Karan Monga
********************************************************************************************************************* */
@isTest
private class NCP_GetChatterGroupsForNDA_Test {
  @testSetup static void setup() {
	
	Test.startTest();
	CollaborationGroup groupe = new CollaborationGroup(Name = 'Test1', CollaborationType = 'Public');
	insert groupe;
	
	Profile prof = [select id from profile where name LIKE '%System%'];
	
	User u = new User(Alias = 'sd', Email='test2@nokian.com.dev', 
			  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
			  LocaleSidKey='en_US', ProfileId = prof.Id, 
			  TimeZoneSidKey='America/Los_Angeles', UserName='test2@nokian.com.dev');
	insert u;
	
	CollaborationGroupMember cgm = new CollaborationGroupMember();
	cgm.CollaborationGroupId = groupe.Id;
	cgm.MemberId = u.Id;
	cgm.CollaborationRole = 'Standard';
	cgm.NotificationFrequency='P';
	insert cgm;
	
	Test.stopTest();  
	   
  }
  
  static testMethod void GetChatterGroupsForNDA_Test() {  
	User customerUser = [SELECT Id,FederationIdentifier FROM User WHERE Email = 'test2@nokian.com.dev' LIMIT 1]; 
	System.runAs(customerUser) { 
	  test.startTest();   
	  List<CollaborationGroupMember> ApicollgrpMember = NCP_GetChatterGroupsForNDA.getCollaborationGroupMember(customerUser.Id);
	  List<CollaborationGroupMember> collgrpMember = [SELECT Id, CollaborationGroupId,CollaborationGroup.Name FROM CollaborationGroupMember WHERE MemberId =:customerUser.Id];
	  System.assertEquals('Test1', collgrpMember[0].CollaborationGroup.Name,ApicollgrpMember[0].CollaborationGroup.Name);
	  test.stopTest();
	}
  }
  
}