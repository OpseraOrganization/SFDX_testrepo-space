public with sharing class NCP_MyEntitlementAccessGroup_Wrapper {

	@AuraEnabled
	public String label {get;set;}
	@AuraEnabled
	public Boolean hasAccess {get;set;}
 
	public NCP_MyEntitlementAccessGroup_Wrapper(String l ,Boolean b){
		this.label = l;
		this.hasAccess = b;
	}
}