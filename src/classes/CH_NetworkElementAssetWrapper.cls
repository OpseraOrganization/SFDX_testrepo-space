public class CH_NetworkElementAssetWrapper {
	// create a wrapper class with @AuraEnabled Properties	
	public class AssetPagerWrapper {
		@AuraEnabled public Integer pageSize {get;set;}
		@AuraEnabled public Integer page {get;set;}
		@AuraEnabled public Integer total {get;set;}
		@AuraEnabled public List<CH_CoveredNetworkElementAsset__c> networkEleAssests {get;set;}
		@AuraEnabled public List<Asset> oAssets {get;set;}
		@AuraEnabled public set<String> releaseValue {get;set;}
		@AuraEnabled public set<String> variantValue {get;set;}
		@AuraEnabled public set<String> solutionValue {get;set;}
		@AuraEnabled public set<String> assetId {get;set;}
	}
	// create a wrapper class with @AuraEnabled Properties	
	public class FilterSelectionWrapper {
		@AuraEnabled public List<String> fieldList {get;set;}
		@AuraEnabled public List<string> operators {get;set;}
		@AuraEnabled public List<string> picklistValue {get;set;}
		@AuraEnabled public string fieldValue {get;set;}
		@AuraEnabled public string fieldName {get;set;}
		@AuraEnabled public string fieldAPI {get;set;}
		@AuraEnabled public Boolean isSelected {get;set;}
		@AuraEnabled public Boolean isPickValue {get;set;}
		@AuraEnabled public string fieldOperator {get;set;}
		@AuraEnabled public Boolean isNew {get;set;}
	} 
}