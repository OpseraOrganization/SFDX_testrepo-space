global class ExternalDS_NDA_Provider extends DataSource.Provider {
	// Define Supported Authentication capability
	override global List<DataSource.AuthenticationCapability> getAuthenticationCapabilities() {
		system.debug('HERE1 ');
		List<DataSource.AuthenticationCapability> capabilities =  new List<DataSource.AuthenticationCapability>();
		capabilities.add(DataSource.AuthenticationCapability.ANONYMOUS);
		capabilities.add(DataSource.AuthenticationCapability.BASIC);
	  return capabilities;
  }
	
  // Other capabilities supported by Custom Adapters 
	override global List<DataSource.Capability> getCapabilities() {
		system.debug('HERE2 ');
		List<DataSource.Capability> capabilities = new List<DataSource.Capability>();
		capabilities.add(DataSource.Capability.SEARCH);
		return capabilities;
	}
	
  // Declares the associated DataSource.Connection class
	override global DataSource.Connection getConnection(DataSource.ConnectionParams connectionParams) {
		system.debug('HERE3 ');
		return new ExternalDS_NDA(connectionParams);
	} 
}