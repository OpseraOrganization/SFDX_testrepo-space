public with sharing class NCP_MyEntitledProducts_Wrapper {
	
	@AuraEnabled
	public sObject product {get;set;}
	@AuraEnabled
	public Boolean checked {get;set;}
}