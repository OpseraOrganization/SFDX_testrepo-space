@isTest
public class CH_CreateAssetControllerTest {
	public static Profile profile;
	public static User agentUser;
	
	@isTest
	public static void testcheckFieldAccess(){
		profile = [Select Id from Profile where name = 'CH_Agent' LIMIT 1];
		
		agentUser = new User(
			Lastname='Agent',
			Firstname='USER',
			Alias = 'AG-OWNER',
			ProfileId = profile.Id,
			Username = System.now().millisecond() + 'AG-OWNER@test.com',
			Email= System.now().millisecond() + 'test2@test.com',
			EmailEncodingKey='UTF-8',
			LanguageLocaleKey='en_US',
			LocaleSidKey='en_US',
			TimeZoneSidKey='America/Chicago',
			Nokia_ID__c = 'CHTEST100'
		);
		system.runAs(agentUser){
			test.startTest();
			Map < String, String > fieldMap = new Map < String, String >{'CH_CARES_ServiceAgreement__c' => 'Edit', 'CH_CaseMilestoneStartDate__c' => 'Read', 'Company_type_CP__c' => ''};
			Map < String, String > outputMap = CH_CreateAssetController.checkFieldAccess('Case', fieldMap);
			test.stopTest();
			
			System.assertEquals('No Edit Access for field', outputMap.get('CH_CARES_ServiceAgreement__c'));
		}
	}
}