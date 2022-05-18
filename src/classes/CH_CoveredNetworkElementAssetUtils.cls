/** 
 * About
 * ----- 
 * @Description	  : Case Handling Covered Network Element Asset Object Utility Class.
 * @TestClass		: CH_CoveredNetworkElementAssetUtils_Test.
 * @Project	: Case Handling.
 * @Modification Log : 
 *  Created  : 2020 10 26 – tiago.almeida@nokia.com
 * ----- 
**/
public without sharing class CH_CoveredNetworkElementAssetUtils {
	public static final DML_SObject DML = new DML_SObject(CH_CoveredNetworkElementAsset__c.sObjectType);
	
	public static List<CH_CoveredNetworkElementAsset__c> get(Id sObjectId, Boolean active) {
		return DML.doSelect(
			'CH_NetworkElementAsset__r.Name, CH_NetworkElementAsset__r.CH_LabEnvironment__c, CH_NetworkElementAsset__r.Status,CH_NetworkElementAsset__r.CH_NetworkElementID__c, ' +
			'CH_NetworkElementAsset__r.Product2.Name, CH_NetworkElementAsset__r.CH_ProductVariant__r.Name, CH_NetworkElementAsset__r.CH_Solution__r.Name,CH_NetworkElementAsset__r.CH_SiteName__c, ' +
			'CH_NetworkElementAsset__r.CH_ProductRelease__r.Name, CH_NetworkElementAsset__r.CH_City__c, CH_NetworkElementAsset__r.CH_State_Province__c,CH_NetworkElementAsset__r.CH_SWBuild__r.Name, ' +
			'CH_NetworkElementAsset__r.Address__r.CH_AddressDetails__c, CH_NetworkElementAsset__r.Address__c, CH_NetworkElementAsset__r.Address__r.Street,CH_NetworkElementAsset__r.CH_NetworkManagementSystemID__c, ' + 
			'CH_NetworkElementAsset__r.CH_SWComponent__r.Name, CH_NetworkElementAsset__r.CH_SWModule__r.Name, CH_NetworkElementAsset__r.CH_SWRelease__r.Name, ' +
			'CH_NetworkElementAsset__r.Address__r.Country, CH_NetworkElementAsset__r.Address__r.postalcode, CH_Status__c, CH_ContractLineItem__c '
		).doWhere(
			'CH_ContractLineItem__c = "' + sObjectId + '"' + (active ? ' AND CH_Status__c = "Active"' : '')
		).doQuery();
	}
	
	public static List<CH_CoveredNetworkElementAsset__c> getAvailableForLinking(Id sObjectId) {
		List<CH_CoveredNetworkElementAsset__c> results = new List<CH_CoveredNetworkElementAsset__c>();
		Set<Id> oCoveredNetworkElementAssetSetId = new Set<Id>();
		for(CH_CoveredNetworkElementAsset__c oCoveredNetworkElementAsset : get(sObjectId, false)) {
			if(!oCoveredNetworkElementAsset.CH_Status__c.equals('Active') && oCoveredNetworkElementAsset.CH_NetworkElementAsset__r.Status.equals('Active')) {
	results.add(oCoveredNetworkElementAsset);
			}
			oCoveredNetworkElementAssetSetId.add(oCoveredNetworkElementAsset.CH_NetworkElementAsset__r.Id);
		}
		//
		List<ContractLineItem> oCLIList = CH_ContractLineItemUtils.get(new Set<String>{sObjectId});
		if(!oCLIList.isEmpty()){
			ContractLineItem oCLI = oCLIList.get(0);
			oCLI.Asset.CH_ContractLineItem__r = new ContractLineItem();
			oCLI.Asset.CH_ContractLineItem__r.CH_CountryISOName__c = oCLI.CH_CountryISOName__c;
			for(Asset oAsset : CH_AssetUtils.getAccountRelatedNetworkElementAssets(true, oCLI.ServiceContract.AccountId, oCLI.Asset, null, null)) {
	if(!oCoveredNetworkElementAssetSetId.contains(oAsset.Id)) {
		CH_CoveredNetworkElementAsset__c oCoveredNetworkElementAsset = new CH_CoveredNetworkElementAsset__c();
		oCoveredNetworkElementAsset.CH_ContractLineItem__c = sObjectId;
		oCoveredNetworkElementAsset.CH_NetworkElementAsset__c = oAsset.Id;
		oCoveredNetworkElementAsset.CH_NetworkElementAsset__r = oAsset;
		results.add(oCoveredNetworkElementAsset);		
	}
			}			
		}
		return results;
	}
	
	public static boolean link(List<CH_CoveredNetworkElementAsset__c> oCoveredNetworkElementAssetList) {
		if(oCoveredNetworkElementAssetList.isEmpty()) {
			return false;
		}
		//
		for(CH_CoveredNetworkElementAsset__c oCoveredNetworkElementAsset : oCoveredNetworkElementAssetList) {
			oCoveredNetworkElementAsset.CH_Status__c = 'Active';
		}
		upsert oCoveredNetworkElementAssetList;
		return true;   
	}
	
	public static boolean unlink(List<CH_CoveredNetworkElementAsset__c> oCoveredNetworkElementAssetList) {
		if(oCoveredNetworkElementAssetList.isEmpty()) {
			return false;
		}
		//
		for(CH_CoveredNetworkElementAsset__c oCoveredNetworkElementAsset : oCoveredNetworkElementAssetList) {
			oCoveredNetworkElementAsset.CH_Status__c = 'Inactive';
		}
		update oCoveredNetworkElementAssetList;
		return true;	
	}
}