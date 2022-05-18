@isTest
public with sharing class ExternalDS_NCP_GlobalSearchProviderTest {

	@isTest
	static void testGetAuthenticationCapabilities() {
		Test.startTest();
		ExternalDS_NCP_GlobalSearch_Provider provider = new ExternalDS_NCP_GlobalSearch_Provider();
		List<DataSource.AuthenticationCapability> capabilities = provider.getAuthenticationCapabilities();
		Test.stopTest();
		system.assertEquals(DataSource.AuthenticationCapability.ANONYMOUS, capabilities[0], 'Message');
	}
	
	@isTest
	static void testGetCapabilities() {
		Test.startTest();
		ExternalDS_NCP_GlobalSearch_Provider provider = new ExternalDS_NCP_GlobalSearch_Provider();
		List<DataSource.Capability> capabilities = provider.getCapabilities();
		Test.stopTest();
		system.assertEquals(DataSource.Capability.SEARCH, capabilities[0], 'Message');
	}

	@isTest
	static void testGetConnection() {
		DataSource.ConnectionParams connectionParams = new DataSource.ConnectionParams();
		Test.startTest();
		ExternalDS_NCP_GlobalSearch_Provider provider = new ExternalDS_NCP_GlobalSearch_Provider();
		DataSource.Connection connection = provider.getConnection(connectionParams);
		Test.stopTest();
		system.assertNotEquals(null, connection, 'Message');
	}
}