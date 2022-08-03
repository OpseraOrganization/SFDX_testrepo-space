global class ExternalDS_NCP_GlobalSearch_Provider extends DataSource.Provider {
	override global List<DataSource.AuthenticationCapability>getAuthenticationCapabilities(){
		List<DataSource.AuthenticationCapability> capabilities = new List<DataSource.AuthenticationCapability>();
		capabilities.add(DataSource.AuthenticationCapability.ANONYMOUS);
		capabilities.add(DataSource.AuthenticationCapability.BASIC);
		return capabilities;
	}

	override global List<DataSource.Capability> getCapabilities(){
		List<DataSource.Capability> capabilities = new List<DataSource.Capability>();
		capabilities.add(DataSource.Capability.SEARCH);
		return capabilities;
	}

	override global DataSource.Connection getConnection(DataSource.ConnectionParams connectionParams){
		return new ExternalDS_NCP_GlobalSearch_Connection(connectionParams);
	}
}