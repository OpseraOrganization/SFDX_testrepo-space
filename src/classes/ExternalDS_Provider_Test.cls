@isTest 
private class ExternalDS_Provider_Test {
	
	@isTest
	static void testGetConnection_NDA() {
		DataSource.ConnectionParams connectionParams = new DataSource.ConnectionParams();
		Test.startTest();
		ExternalDS_NDA_Provider provider = new ExternalDS_NDA_Provider();
		DataSource.Connection connection = provider.getConnection(connectionParams);
		Test.stopTest();
		system.assertNotEquals(null, connection, 'Message');
	}
	 
	@isTest
	static void testGetAuthenticationCapabilities_NDA() {
		Test.startTest();
		ExternalDS_NDA_Provider provider = new ExternalDS_NDA_Provider();
		List<DataSource.AuthenticationCapability> capabilities = provider.getAuthenticationCapabilities();
		Test.stopTest();
		system.assertEquals(DataSource.AuthenticationCapability.ANONYMOUS, capabilities[0], 'Message');
	}
	
	@isTest
	static void testGetCapabilities_NDA() {
		Test.startTest();
		ExternalDS_NDA_Provider provider = new ExternalDS_NDA_Provider();
		List<DataSource.Capability> capabilities = provider.getCapabilities();
		Test.stopTest();
		system.assertEquals(DataSource.Capability.SEARCH, capabilities[0], 'Message');
	}
}