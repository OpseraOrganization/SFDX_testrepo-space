public without sharing class CH_CA_WorkGroup_Rule_Controller {
	// This method is used to get the Picklist records from the CDBServiceContractType.
	@AuraEnabled
	public static List<String> getCdbRecords() {  
		List<String> pickListValues= new List<String>();
		pickListValues.add('--None--');
		Schema.DescribeFieldResult fieldResult = CH_CDB_ServiceContractType__c.CH_CDB_ContractType__c.getDescribe();
		List<Schema.PicklistEntry> listOfValues = fieldResult.getPicklistValues();
		if(listOfValues.size()>0){
			for( Schema.PicklistEntry pickListVal : listOfValues){
	pickListValues.add(pickListVal.getLabel());
			} 
		}
		pickListValues.sort();
		return pickListValues;
	}
	@AuraEnabled
	public static CH_Workgroup_Rule__c getWGRuleDetails(Id wgId){
		CH_Workgroup_Rule__c wg= [select id,Name,CH_Workgroup__c,CH_OrderNumber__c,CH_Active__c,CH_ServiceType__c,CH_Contract_Type__c,CH_Workgroup_Type__c,CH_Severity__c,CH_Outage__c,CH_LevelOfSupport__c,CH_Customer_Group__c,CH_Account__c,CH_ServiceContract__c,
		  CH_Region1__c,CH_Country1__c,CH_Product_Group__c,CH_Product__c,CH_Solution__c,CH_ProductRelease__c,CH_ProductVariant__c,CH_Product_Module__c from CH_Workgroup_Rule__c where id=:wgId];
		return wg;
	}
	@AuraEnabled
	public static CH_Workgroup_Rule__c getKBRuleDetails(Id wgId){
		CH_Workgroup_Rule__c wg= [select id,Name,CH_Workgroup__c,CH_Product__c from CH_Workgroup_Rule__c where id=:wgId];
		return wg;
	}
	
}