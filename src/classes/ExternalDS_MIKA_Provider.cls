/**
About
-----
Description: DataSource.Provider class required to connect to the external system "MIKA"

Created for: Nokia Portugal COE
Created: 19 02 2019

Update History
--------------
Created: 16 07 2019 – flavio.toscano@nokia.com
-------------
**/
global class ExternalDS_MIKA_Provider extends DataSource.Provider{
	  
	// Define Supported Authentication capability
	override global List<DataSource.AuthenticationCapability> getAuthenticationCapabilities() {
		List<DataSource.AuthenticationCapability> capabilities =  new List<DataSource.AuthenticationCapability>();
		capabilities.add(DataSource.AuthenticationCapability.ANONYMOUS);
	  return capabilities;
  }
	
  // Other capabilities supported by Custom Adapters 
	override global List<DataSource.Capability> getCapabilities()
	{
		List<DataSource.Capability> capabilities = new List<DataSource.Capability>();
		capabilities.add(DataSource.Capability.SEARCH);
		return capabilities;
	}
	
  // Declares the associated DataSource.Connection class
	override global DataSource.Connection getConnection(DataSource.ConnectionParams connectionParams) {
		return new ExternalDS_MIKA(connectionParams);
	} 
}