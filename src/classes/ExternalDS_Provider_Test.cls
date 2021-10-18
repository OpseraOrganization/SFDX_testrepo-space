@isTest
private class ExternalDS_Provider_Test {
	
	@isTest
	static void testGetConnection_MIKA() {
		DataSource.ConnectionParams connectionParams = new DataSource.ConnectionParams();
		Test.startTest();
		ExternalDS_MIKA_Provider provider = new ExternalDS_MIKA_Provider();
		DataSource.Connection connection = provider.getConnection(connectionParams);
		Test.stopTest();
		system.assertNotEquals(null, connection, 'Message');
	}
	 
	@isTest
	static void testGetAuthenticationCapabilities_MIKA() {
		Test.startTest();
		ExternalDS_MIKA_Provider provider = new ExternalDS_MIKA_Provider();
		List<DataSource.AuthenticationCapability> capabilities = provider.getAuthenticationCapabilities();
		Test.stopTest();
		system.assertEquals(DataSource.AuthenticationCapability.ANONYMOUS, capabilities[0], 'Message');
	}
	
	@isTest
	static void testGetCapabilities_MIKA() {
		Test.startTest();
		ExternalDS_MIKA_Provider provider = new ExternalDS_MIKA_Provider();
		List<DataSource.Capability> capabilities = provider.getCapabilities();
		Test.stopTest();
		//system.assertEquals(DataSource.Capability.ROW_QUERY, capabilities[0], 'Message');
		system.assertEquals(DataSource.Capability.SEARCH, capabilities[0], 'Message');
	}
}