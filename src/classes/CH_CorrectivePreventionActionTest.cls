@IsTest(seeAllData = false)
public class CH_CorrectivePreventionActionTest {
	
	public static User createUsr(String oUsr){
		Profile profile = [Select Id from Profile where name = 'System Administrator' LIMIT 1];
		// Create account owner
		User chUser = new User(
			Lastname='NONPORTAL1',
			Firstname='NONPORTAL1'+oUsr,
			Alias = 'NP1'+oUsr,
			ProfileId = profile.Id,
			Username = System.now().millisecond()  +oUsr+'NP1@test.com',
			Email= System.now().millisecond() + oUsr+'test2@test.com',
			EmailEncodingKey='UTF-8',
			LanguageLocaleKey='en_US',
			LocaleSidKey='en_US',
			TimeZoneSidKey='America/Chicago',
			Nokia_ID__c = oUsr
		);
		insert chUser;
		return chUser;
	}
	
	static testMethod void testCPATrigger() {
		User chUser = createUsr('User1');
		User chUser2 = createUsr('User2');
		User chUser3 = createUsr('User3');
		system.runAs(chUser){
			CH_Corrective_Preventive_Action__c objCPA = new CH_Corrective_Preventive_Action__c();
			objCPA.CH_Result__c = 'testResult';
			objCPA.CH_Closing_criteria__c= 'CPA no longer needed';
			objCPA.CH_CPA_Manager__c = chUser.Id;
			objCPA.CH_CPA_Status__c = 'Created';
			objCPA.OwnerID = chUser3.id;
			insert objCPA;
			objCPA.CH_CPA_Manager__c = chUser2.Id;
			objCPA.CH_CPA_Status__c = 'Rejected';
			update objCPA;
		}
	}
}