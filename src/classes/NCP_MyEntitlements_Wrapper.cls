public with sharing class NCP_MyEntitlements_Wrapper {
	
	@AuraEnabled
	public ServiceContract sContract {get;set;}

	@AuraEnabled
	public List<NCP_MyEntitlementProductAccess_Wrapper> products {get;set;}

	@AuraEnabled
	public List<String> services {get;set;}

	public NCP_MyEntitlements_Wrapper(ServiceContract sc, List<NCP_MyEntitlementProductAccess_Wrapper> p, List<String> s) {
		sContract = sc;
		products = p;
		services = s;
	}
}