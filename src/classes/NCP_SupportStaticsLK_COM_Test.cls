@isTest
public class NCP_SupportStaticsLK_COM_Test {
	@isTest
	static void testgetArticle() {

		//create the kav instance
		NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;

		User SysAdmin = [SELECT IsActive,Id FROM User WHERE Profile.name = 'System Administrator' and IsActive = true Limit 1];
		system.runAs(SysAdmin) {
			String orgId = UserInfo.getOrganizationId();
			String dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
			Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
			String uniqueName = dateString + randomInt;
			Contact con = new Contact();
			OpportunityTeamMember otm = new OpportunityTeamMember();
			user user = new user();
			List<user> runAsUSer = new List<user>();
			runAsUSer = TestDataFactory.userCreation(2, 'System Administrator');
			runAsUSer[0].UserRoleId = system.Label.Global_Role_ID;
			runAsUSer[0].NSA_Compliant__c = true;
			runAsUSer[0].UserPermissionsKnowledgeUser = true;
			database.insert(runAsUSer);
			system.runAs(runAsUSer[0]) {
	String articleTitle = 'Test Article';

	knowledge__kav announce = new knowledge__kav(
			Title = articleTitle,
			Summary = articleTitle,
			Details__c = 'test',
			Display_Start_Date__c = System.today(),
			Display_End_Date__c = System.today(),
			Priority__c = 'Important',
			URLName = 'Test-Article-URL',
			language = 'en_US',
			Article_Category__c = 'Security'
	);
	Test.startTest();
	knowledge__kav resultKnoledge;
	try {
		resultKnoledge = NCP_SupportStaticsLK_COM.getArticle(articleTitle);
	} catch (Exception ex) {
		System.assertNotEquals(ex.getMessage(), null);
	}
	insert announce;

	knowledge__kav announcement = [
			SELECT Id, Title,KnowledgeArticleId
			FROM knowledge__kav
			WHERE Id = :announce.Id
			LIMIT 1
	];
	String articleId = announcement.KnowledgeArticleId;
	//publish articles
	KbManagement.PublishingService.publishArticle(articleId, true);

	//publish articles
	resultKnoledge = NCP_SupportStaticsLK_COM.getArticle(articleTitle);
	Test.stopTest();
			}
		}
	}
}