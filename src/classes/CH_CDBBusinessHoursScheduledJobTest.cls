@isTest
private class CH_CDBBusinessHoursScheduledJobTest {
	private static void testSuccessBusinessHoursSync() {
		Test.setMock(HttpCalloutMock.class, new iPaasMock());

		Test.startTest();
		new CH_CDBBusinessHoursScheduledJob().execute(NULL);
		System.assertEquals(Limits.getFutureCalls(), 1);
		Test.stopTest();
		
		CH_Business_Hours_Integration__c integrationSettings = CH_Business_Hours_Integration__c.getOrgDefaults();
		System.assertNotEquals(NULL, integrationSettings.CH_Start_Sync_DateTime__c);
	}
	
	@isTest
	private static void testInitialBusinessHoursSync() {
		testSuccessBusinessHoursSync();
	}

	@isTest
	private static void testFirstSuccessBusinessHoursSync() {
		CH_Business_Hours_Integration__c integrationSettings = new CH_Business_Hours_Integration__c(SetupOwnerId = UserInfo.getOrganizationId());
		insert integrationSettings;

		testSuccessBusinessHoursSync();
	}
	
	@isTest
	private static void testSkipBusinessHoursSync() {
		CH_Business_Hours_Integration__c integrationSettings = new CH_Business_Hours_Integration__c(SetupOwnerId = UserInfo.getOrganizationId(), CH_Last_Success_Sync_DateTime__c = DateTime.now());
		insert integrationSettings;
		
		Test.startTest();
		new CH_CDBBusinessHoursScheduledJob().execute(NULL);
		System.assertEquals(Limits.getFutureCalls(), 0);
		Test.stopTest();

		integrationSettings = CH_Business_Hours_Integration__c.getOrgDefaults();
		System.assertEquals(NULL, integrationSettings.CH_Start_Sync_DateTime__c);
	}

	@isTest
	private static void testBusinessHoursInterfaceLog() {
		CH_Business_Hours_Integration__c integrationSettings = new CH_Business_Hours_Integration__c(SetupOwnerId = UserInfo.getOrganizationId(), CH_Start_Sync_DateTime__c = DateTime.now());
		insert integrationSettings;

		Test.startTest();
		insert new Interface_Log__c(Name = 'test', Status__c = 'Success');
		integrationSettings = CH_Business_Hours_Integration__c.getOrgDefaults();
		System.assertNotEquals(integrationSettings.CH_Start_Sync_DateTime__c, NULL);
		System.assertEquals(integrationSettings.CH_Last_Success_Sync_DateTime__c, NULL);

		insert new Interface_Log__c(Name = 'test', Interface_Type__c = 'Business Hours', Status__c = 'Failure');
		integrationSettings = CH_Business_Hours_Integration__c.getOrgDefaults();
		System.assertNotEquals(integrationSettings.CH_Start_Sync_DateTime__c, NULL);
		System.assertEquals(integrationSettings.CH_Last_Success_Sync_DateTime__c, NULL);

		insert new Interface_Log__c(Name = 'test', Interface_Type__c = 'Business Hours', Status__c = 'Success');
		integrationSettings = CH_Business_Hours_Integration__c.getOrgDefaults();
		System.assertEquals(integrationSettings.CH_Start_Sync_DateTime__c, NULL);
		System.assertNotEquals(integrationSettings.CH_Last_Success_Sync_DateTime__c, NULL);
		Test.stopTest();
	}

	public class iPaasMock implements HttpCalloutMock {
		public HTTPResponse respond(HTTPRequest request) {
			System.assertEquals('POST', request.getMethod());
			
			HttpResponse response = new HttpResponse();
			response.setHeader('Content-Type', 'application/json');
			response.setStatusCode(200);
			return response;
		}
	}
}