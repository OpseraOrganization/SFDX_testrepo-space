public class NCP_MyEntitlementProductAccess_Wrapper {

	@AuraEnabled
	public Object myProduct {get;set;}
	
	@AuraEnabled
	public List<NCP_MyEntitlementAccessGroup_Wrapper> accessGroup {get;set;}
 
	public NCP_MyEntitlementProductAccess_Wrapper(Object p ,List<NCP_MyEntitlementAccessGroup_Wrapper> acc) {
		this.myProduct = p;
		this.accessGroup = acc;
	}
}