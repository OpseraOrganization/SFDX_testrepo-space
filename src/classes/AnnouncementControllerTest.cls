@IsTest

/****************************************
 * Class Name : AnnouncementControllerTest
 * Created Date: 1 May 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 1 May 2017
 * Description : Test Class of AnnouncementController
 *****************************************/
private class AnnouncementControllerTest {
	
	/********************
	*Method Name: createTestData
	*Parameter: 
	*Description: createTestData
	*******************/
	
		
	@testSetup static void createTestData() {
		//create the kav instance 
		NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
		
		User SysAdmin = [SELECT IsActive,Id FROM User WHERE Profile.name = 'System Administrator' and IsActive = true Limit 1];
		system.runAs(SysAdmin){
			//Test.startTest();
			String orgId = UserInfo.getOrganizationId();
			String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
			Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
			String uniqueName =   dateString + randomInt;
			Contact con = new Contact();
			OpportunityTeamMember otm = new OpportunityTeamMember();
			user user  = new user();
			List<user> runAsUSer = new List<user>();
			runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
			runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
			runAsUSer[0].NSA_Compliant__c = true;
			runAsUSer[0].UserPermissionsKnowledgeUser = true;
			database.insert(runAsUSer);
			system.runAs(runAsUSer[0]){
			Knowledge__kav announce = new Knowledge__kav(
					Title = 'Test Article',
					Summary = 'Test Article',
					URLName = 'Test-Article-URL',
					Article_Category__c = 'Gates/LOA'
			);
			Test.startTest();   
			Database.insert(new List<Knowledge__kav>{announce});
				
			Knowledge__kav announcement = [SELECT Id, KnowledgeArticleId
											  FROM Knowledge__kav 
											  WHERE Id =: announce.Id LIMIT 1];
			String articleId = announcement.KnowledgeArticleId;
			//publish articles
			KbManagement.PublishingService.publishArticle(articleId, true);
			Test.stopTest();
			}
		}
	}
	
	/********************
	*Method Name: getAnnouncementsPositiveTest
	*Parameter: 
	*Description: Positive Test getAnnouncementsTest Method
	*******************/
	static testMethod void getAnnouncementsPositiveTest() {
		//createTestData();
		Test.startTest();	 
		User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
		system.runAs(thisUser) {
			List<Knowledge__kav> announcementsList = AnnouncementController.getAnnouncements();
		  //  System.assert(announcementsList.size() == 1);
		  Test.stopTest();
		}
	}   
	
	
}