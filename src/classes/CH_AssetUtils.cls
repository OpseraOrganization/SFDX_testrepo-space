/** 
 * About 
 * ----- 
 * @Description	  : Case Handling Asset Object Utility Class.
 * @TestClass		: CH_AssetUtils_Test.
 * @Project	: Case Handling.
 * @Modification Log : 
 *  Created  : 2019 11 27 – tiago.almeida@nokia.com
 * ----- 
**/
public without sharing class CH_AssetUtils {
	private final static DML_SObject DM_Asset = new DML_SObject(Asset.sObjectType);
	
	/**
	 * @description : Get a specific Asset - NOKIASC-#####
	 * @param	: Id Asset
	 * @return	  : Asset
	**/
	public static Asset getAsset(Id assetId) {
		try{
			List<Asset> oAssetList = DM_Asset.doSelect(
	'Id, Account.Name, Contact.Name, Name, ' + 
	'Product2Id, Product2.Name, Product2.NCP_Nokia_Product_Id__c, ' + 
	'CH_ProductRelease__c, CH_ProductRelease__r.Name, CH_ProductRelease__r.CH_NSNLegacyCode__c, ' + 
	'CH_Solution__c, CH_Solution__r.Name, CH_Solution__r.NCP_Nokia_Product_Id__c, ' + 
	'CH_ProductVariant__c, CH_ProductVariant__r.Name, CH_ProductVariant__r.NCP_Nokia_Product_Id__c, '+ //Changes added for NOKIASC-36197
	'CH_SWRelease__c,CH_SWRelease__r.Name,CH_SWRelease__r.CH_NSNLegacyCode__c,CH_SWRelease__r.Id, '+ 
	'CH_SWComponent__c,CH_SWComponent__r.Name,CH_SWComponent__r.NCP_Nokia_Product_Id__c,CH_SWComponent__r.Id, '+
	'CH_SWModule__c,CH_SWModule__r.Name,CH_SWModule__r.NCP_Nokia_Product_Id__c,CH_SWModule__r.Id, '+
	'CH_SWBuild__c,CH_SWBuild__r.Name,CH_SWBuild__r.CH_NSNLegacyCode__c,CH_SWBuild__r.Id '
			).doWhere('Id = "' + assetId + '"').doQuery();
			return oAssetList.get(0);
		}catch(Exception e){
			throw new AuraHandledException('Something went wrong: ' + e.getMessage());
		}
	}
	
	/**
	 * @description : Get Contact Authorized related Assets - NOKIASC-#####
	 * @param	: Boolean withoutSharing
	 * @param	: String accountId
	 * @param	: String contactId
	 * @param	: Asset netElemAsset
	 * @param	: String serviceType
	 * @param	: boolean swMaintenance
	 * @return	  : List<Asset>
	**/
	public static List<Asset> getContactAuthorizedAssets(Boolean withoutSharing, String accountId, String contactId, Asset netElemAsset, String serviceType, boolean swMaintenance) {
		Map<Id, Asset> oAssetMap = new Map<Id, Asset>();
		if(String.isNotBlank(contactId) && String.isNotBlank(accountId)) {			
			Set<String> contractIdSet = new Set<String>();
			for(EntitlementContact oEntitlementContact : (List<EntitlementContact>) DML_SObject.doQuery('SELECT Entitlement.ServiceContractId FROM EntitlementContact WHERE ContactId = "' + contactId + '"', withoutSharing)) {
	contractIdSet.add(oEntitlementContact.Entitlement.ServiceContractId);	
			}
			// NOKIASC-38809, Added Asset.Product2.NCP_Marketing_Text__c into sQuery
			String sQuery = 'SELECT Id, CH_CountryISOName__c, AssetId, Asset.Name, Asset.ProductDescription, Asset.Product2.Description, Asset.Product2.NCP_Marketing_Text__c, Asset.Product2Id, Asset.Product2.Name, Asset.Product2.NCP_Nokia_Product_Id__c, Asset.Product2.CH_Business_Group__c, ';			
			sQuery += 'Asset.CH_Solution__c, Asset.CH_Solution__r.Name, Asset.CH_ProductVariant__c, Asset.CH_ProductVariant__r.Name, Asset.CH_ProductRelease__c, Asset.CH_ProductRelease__r.Name, Asset.CH_CountryISOName__c ';
			sQuery += 'FROM ContractLineItem WHERE ServiceContractId IN ' + DML_SObject.setToString(contractIdSet) + ' AND ServiceContract.NCP_External_Status__c = "Active" AND ServiceContract.Status = "Active" ';
			sQuery += !serviceType.equals('Internal Support') ? 'AND Asset.AccountId = "'+accountId+'" ' : '';
			sQuery += 'AND CH_ServiceType__c = "' + serviceType + '" AND NCP_External_Status__c = "Active" AND Status = "Active" AND Asset.RecordType.DeveloperName = "CH_CoveredProduct" ';
			sQuery += swMaintenance ? 'AND ServiceContract.CH_PortalCaseCreationSWMaintenance__c = true ' : '';
			if(netElemAsset != null && serviceType == 'Customer Support') {
	sQuery += 'AND CH_CountryISOName__c = "'+netElemAsset.CH_CountryISOName__c+'" ';
	sQuery += 'AND Asset.Product2Id = '+( netElemAsset.Product2Id != null ? '"'+netElemAsset.Product2Id+'" ': 'null ');
	sQuery += (netElemAsset.CH_Solution__c != null ? ('AND Asset.CH_Solution__c IN ("'+netElemAsset.CH_Solution__c+'", null) ') : '');
	sQuery += (netElemAsset.CH_ProductVariant__c != null ? ('AND Asset.CH_ProductVariant__c IN ("'+netElemAsset.CH_ProductVariant__c+'", null) ') : '');
	sQuery += (netElemAsset.CH_ProductRelease__c != null ? ('AND Asset.CH_ProductRelease__c = "'+netElemAsset.CH_ProductRelease__c+'"') : '');
			}
			sQuery += 'ORDER BY Asset.Name';
			for(ContractLineItem oContractLineItem : (List<ContractLineItem>) DML_SObject.doQuery(sQuery, withoutSharing)) {
	Asset oAsset = oContractLineItem.Asset;
	oAsset.CH_ContractLineItem__r = new ContractLineItem(
		Id = oContractLineItem.Id, CH_CountryISOName__c = oContractLineItem.CH_CountryISOName__c
	);
	oAssetMap.put(oAsset.Id, oAsset);
			}
		}
		return oAssetMap.values();
	}

	/**
	 * @description : Get Account related Network Element Assets - NOKIASC-#####
	 * @param	: Boolean withoutSharing
	 * @param	: String accountId
	 * @param	: Asset asset
	 * @param	: Entitlement entitlement
	 * @return	  : List<Asset>
	**/
	public static List<Asset> getAccountRelatedNetworkElementAssets(Boolean withoutSharing, String accountId, Asset asset, Entitlement entitlement, Product2 product) {
		List<Asset> oAssetList = new List<Asset>();
		if(String.isNotBlank(accountId)) {
			if(entitlement == null) {
				String sQuery = 'SELECT Id, Name, CH_LabEnvironment__c, CH_NetworkElementID__c, Product2Id, Product2.Name, CH_Solution__c, CH_Solution__r.Name, ';
				sQuery += 'CH_ProductVariant__c, CH_ProductVariant__r.Name, CH_ProductRelease__c, CH_ProductRelease__r.Name, Address__r.CH_AddressDetails__c, ';
	sQuery += 'CH_SiteName__c, CH_SWComponent__r.Name, CH_SWModule__r.Name, CH_SWRelease__r.Name, CH_SWBuild__r.Name, ';
				sQuery += 'CH_CountryISOName__c, Address__r.Street, Address__r.City, Address__r.State, Address__r.Country, CH_NetworkManagementSystemID__c FROM Asset ';
				sQuery += 'WHERE RecordType.DeveloperName = "CH_NetworkElementAsset" AND Status = "Active" AND AccountId = "'+accountId+'" ';
				if(product != null) {
					sQuery += 'AND Product2Id ='+( product.Id != null ? '"'+product.Id+'" ': 'null ');
				}
				if(asset != null) {
					sQuery += 'AND CH_CountryISOName__c ='+( asset.CH_ContractLineItem__r.CH_CountryISOName__c != null ? '"'+asset.CH_ContractLineItem__r.CH_CountryISOName__c+'" ': 'null ');
					sQuery += 'AND Product2Id ='+( asset.Product2Id != null ? '"'+asset.Product2Id+'" ': 'null ');
					sQuery += (asset.CH_Solution__c != null ? ('AND CH_Solution__c IN ("' + asset.CH_Solution__c +'", null) ') : '');
					sQuery += (asset.CH_ProductVariant__c != null ? ('AND CH_ProductVariant__c IN ("' + asset.CH_ProductVariant__c +'", null) ') : '');
					sQuery += 'AND CH_ProductRelease__c '+( asset.CH_ProductRelease__c != null ? 'IN ("'+asset.CH_ProductRelease__c+'", null) ': ' = null ');
				}
				oAssetList = DML_SObject.doQuery(sQuery, withoutSharing);
			}
			else {
				String sQuery = 'SELECT CH_NetworkElementAsset__r.Id, CH_NetworkElementAsset__r.Name, CH_NetworkElementAsset__r.CH_LabEnvironment__c, CH_NetworkElementAsset__r.CH_NetworkElementID__c,';
				sQuery += 'CH_NetworkElementAsset__r.Product2Id, CH_NetworkElementAsset__r.Product2.Name, CH_NetworkElementAsset__r.CH_Solution__c, CH_NetworkElementAsset__r.CH_Solution__r.Name, ';
				sQuery += 'CH_NetworkElementAsset__r.CH_ProductVariant__c, CH_NetworkElementAsset__r.CH_ProductVariant__r.Name, CH_NetworkElementAsset__r.CH_ProductRelease__c, CH_NetworkElementAsset__r.CH_ProductRelease__r.Name, ';
				sQuery += 'CH_NetworkElementAsset__r.CH_CountryISOName__c, CH_NetworkElementAsset__r.Address__r.CH_AddressDetails__c, CH_NetworkElementAsset__r.Address__r.Street, ';
				sQuery += 'CH_NetworkElementAsset__r.Address__r.City, CH_NetworkElementAsset__r.Address__r.State, CH_NetworkElementAsset__r.Address__r.Country, CH_NetworkElementAsset__r.CH_NetworkManagementSystemID__c  FROM CH_CoveredNetworkElementAsset__c ';
				sQuery += 'WHERE CH_NetworkElementAsset__r.RecordType.DeveloperName = "CH_NetworkElementAsset" AND CH_Status__c = "Active" AND CH_NetworkElementAsset__r.Status = "Active" ';
				sQuery += 'AND CH_ContractLineItem__r.Status = "Active" AND CH_ContractLineItem__r.NCP_External_Status__c = "Active" AND CH_NetworkElementAsset__r.AccountId = "'+accountId+'" ';
				if(asset != null) {
					sQuery += 'AND CH_NetworkElementAsset__r.CH_CountryISOName__c ='+( asset.CH_ContractLineItem__r.CH_CountryISOName__c != null ? '"'+asset.CH_ContractLineItem__r.CH_CountryISOName__c+'" ': 'null ');
					sQuery += 'AND CH_NetworkElementAsset__r.Product2Id ='+( asset.Product2Id != null ? '"'+asset.Product2Id+'" ': 'null ');
					sQuery += (asset.CH_Solution__c != null ? ('AND CH_NetworkElementAsset__r.CH_Solution__c IN ("' + asset.CH_Solution__c +'", null) ') : '');
					sQuery += (asset.CH_ProductVariant__c != null ? ('AND CH_NetworkElementAsset__r.CH_ProductVariant__c IN ("' + asset.CH_ProductVariant__c +'", null) ') : '');
					sQuery += 'AND CH_NetworkElementAsset__r.CH_ProductRelease__c '+( asset.CH_ProductRelease__c != null ? 'IN ("'+asset.CH_ProductRelease__c+'", null) ': ' = null ');
					sQuery += 'AND CH_ContractLineItem__c = "'+entitlement.ContractLineItem.Id+'" ';
				}
				for(CH_CoveredNetworkElementAsset__c oCoveredNetworkElementAsset : (List<CH_CoveredNetworkElementAsset__c>) DML_SObject.doQuery(sQuery, withoutSharing)) {
					oAssetList.add(oCoveredNetworkElementAsset.CH_NetworkElementAsset__r);
				}
			}
		}
		return oAssetList ;
	}

	/**
	 * @description : Get CLI related Network Element Assets Id's - NOKIASC-25564
	 * @param	: Boolean withoutSharing
	 * @param	: Set<String> contractLineItemIdSet
	 * @return	  : Map<Id, Set<Id>>
	**/
	public static Map<Id, Set<Id>> getNetworkElementAssetIdsFromCLIList(Boolean withoutSharing, Set<String> contractLineItemIdSet) {
		Map<Id, Set<Id>> oCLItoNEAIdsMap = new Map<Id, Set<Id>>();
		if(!contractLineItemIdSet.isEmpty()) {
			String sQuery = 'SELECT CH_NetworkElementAsset__r.Id, CH_NetworkElementAsset__r.Name, CH_NetworkElementAsset__r.Product2.Name, CH_NetworkElementAsset__r.CH_Solution__r.Name, ';
			sQuery += 'CH_NetworkElementAsset__r.CH_ProductVariant__r.Name, CH_NetworkElementAsset__r.CH_ProductRelease__r.Name, CH_NetworkElementAsset__r.CH_LabEnvironment__c, ';
			sQuery += 'CH_NetworkElementAsset__r.Address__r.CH_AddressDetails__c, CH_NetworkElementAsset__r.Address__r.TimeZone, CH_NetworkElementAsset__r.CH_CountryISOName__c, CH_ContractLineItem__c, ';
			sQuery += 'CH_NetworkElementAsset__r.CH_NetworkElementID__c FROM CH_CoveredNetworkElementAsset__c ';
			sQuery += 'WHERE CH_NetworkElementAsset__r.RecordType.DeveloperName = "CH_NetworkElementAsset" AND CH_Status__c = "Active" AND CH_NetworkElementAsset__r.Status = "Active" AND CH_ContractLineItem__c IN '+DML_SObject.setToString(contractLineItemIdSet);
			for(CH_CoveredNetworkElementAsset__c oCoveredNetworkElementAsset : (List<CH_CoveredNetworkElementAsset__c>) DML_SObject.doQuery(sQuery, withoutSharing)) {
	Set<Id> oNEAIdSet = oCLItoNEAIdsMap.containsKey(oCoveredNetworkElementAsset.CH_ContractLineItem__c) ? oCLItoNEAIdsMap.get(oCoveredNetworkElementAsset.CH_ContractLineItem__c) : new Set<Id>();
	oNEAIdSet.add(oCoveredNetworkElementAsset.CH_NetworkElementAsset__r.Id);
	oCLItoNEAIdsMap.put(oCoveredNetworkElementAsset.CH_ContractLineItem__c, oNEAIdSet);
			}
		}
		return oCLItoNEAIdsMap;
	}
	
	/**
	 * @description : Do Asset DML operations from the Lightning Components - NOKIASC-#####
	 * @param	: String operationType
	 * @param	: Asset oAsset
	 * @return	  : Id
	**/
	public static Id database(String operationType, Asset oAsset, Boolean withoutSharing) {
		try {
			if(operationType.equals('insert')) DML_SObject.doInsert(oAsset, withoutSharing);
			else if(operationType.equals('update')) DML_SObject.doUpdate(oAsset, withoutSharing);
			else if(operationType.equals('delete')) DML_SObject.doDelete(oAsset, withoutSharing);
			return operationType.equals('delete')?null:oAsset.Id;
		} catch (Exception e) {
			throw new AuraHandledException('Something went wrong! '+ e.getMessage());
		}
	}
}