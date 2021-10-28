public class CH_CaseAssignment {
	@AuraEnabled
	public string contract;
	@AuraEnabled
	public string severity;
	@AuraEnabled
	public string region;
	@AuraEnabled
	public string country;
	@AuraEnabled
	public List<string> levelOfSupport;
	@AuraEnabled
	public Id customerId;
	@AuraEnabled
	public List<Id> customerGroupIds;
	@AuraEnabled
	public Id customerGroupId;
	@AuraEnabled
	public Id productId;
	@AuraEnabled
	public List<Id> productGroupIds;
	@AuraEnabled
	public Id productGroupId;
	@AuraEnabled
	public string outage;
	@AuraEnabled
	public Case supportCase;
	@AuraEnabled
	public List<CH_Workgroup_Rule__c> validWorkgroupRules;
	@AuraEnabled
	public boolean isActiveAssignment;
	@AuraEnabled
	public boolean isCaseTeamAssignment;
	@AuraEnabled
	public boolean isAvailableAccordingToRota;
	@AuraEnabled
	public List<CH_Workgroup_Member__c> validWorkgroupMembers;
	
	public CH_CaseAssignment(){
		levelOfSupport = new List<string>();
		customerGroupIds = new List<Id>();
		productGroupIds = new List<Id>();
		outage = 'Any';
		validWorkgroupRules = new List<CH_Workgroup_Rule__c>();
		isActiveAssignment = false;
		isCaseTeamAssignment = false;
		isAvailableAccordingToRota = false;
		validWorkgroupMembers = new List<CH_Workgroup_Member__c>();
	}
	
	// Get all the customer groups that the customer is part of
	public void GetCustomerGroupsForCustomer(){
		// If no customer id is filled in
		if (customerId == null){
			return;
		}
		
		// Get the customgroups that the case accont is part of
		List<CH_CustomerGroup_Account__c> validCustomerGroups = [SELECT Id, CH_Customer_Grouping__c 
														 	 FROM CH_CustomerGroup_Account__c 
														 WHERE CH_Account__c =:customerId];
		customerGroupIds = new List<Id>();
		if(validCustomerGroups.size() > 0){
			for(CH_CustomerGroup_Account__c validCustomerGroup :validCustomerGroups){
				customerGroupIds.add(validCustomerGroup.CH_Customer_Grouping__c);
			}
		}
	}
	
	// Get all the products groups that the product is part of
	public void GetProductGroupsForProduct(){
		// If no customer id is filled in
		if (productId == null){
			return;
		}

		// Get the productgroups that the case product is part of
		List<CH_ProductGroup_Product__c> productGroupList = [SELECT id, CH_Product_Grouping__c 
															 FROM CH_ProductGroup_Product__c 
															 WHERE CH_Product__c =:productId];
		productGroupIds = new List<Id>();
		if(productGroupList.size() > 0){		  
			for(CH_ProductGroup_Product__c validProductGroup :productGroupList){
				productGroupIds.add(validProductGroup.CH_Product_Grouping__c);
			}
		}
	}
}