/** 
 * About 
 * ----- 
 * @Description	  : Case Handling Entitlement Object Utility Class.
 * @TestClass		: CH_EntitlementUtils_Test.
 * @Project	: Case Handling.
 * @Modification Log : 
 *  Created  : 2019 11 27 – tiago.almeida@nokia.com
 * ----- 
**/
public class CH_EntitlementUtils {
	private final static DML_SObject DM_Entitlement = new DML_SObject(Entitlement.sObjectType);
	
	/**
	 * @description : Get Contact Authorized Entitlements - NOKIASC-25564
	 * @param 		: Boolean withoutSharing
	 * @param 		: String accountId
	 * @param 		: String assetId
	 * @param 		: String contactId
	 * @param 		: String serviceType
	 * @param 		: boolean swMaintenance
	 * @return	  : List<Entitlement>
	**/
	public static List<Entitlement> getContactAuthorizedEntitlements(Boolean withoutSharing, String accountId, String assetId, String contactId, Asset netElemAsset, String serviceType, boolean swMaintenance) {
		List<Entitlement> oEntitlementResultList = new List<Entitlement>();
		if(String.isNotBlank(contactId) && String.isNotBlank(assetId)) {
			Set<String> oServiceContractIdSet = new Set<String>();
			Set<String> oCLIIdSet = new Set<String>();
			for(EntitlementContact oEntitlementContact : (List<EntitlementContact>) DML_SObject.doQuery('SELECT Entitlement.ServiceContractId FROM EntitlementContact WHERE ContactId = "' + contactId + '"', withoutSharing)) {
	oServiceContractIdSet.add(oEntitlementContact.Entitlement.ServiceContractId);	
			}
			//
			String sQuery = 'SELECT Id, Name, StartDate, EndDate, Status, Entitlement_Status__c, Type, AccountId, Account.Name, AssetId, Asset.Name, ';
			sQuery += 'ServiceContractId, ServiceContract.Name, ServiceContract.CH_Service_Contract_Type_Text__c, ServiceContract.CH_Project__c, ServiceContract.CH_EntitlementScript__c, ServiceContract.CH_CustomerContractNumber__c, ';
			sQuery += 'ContractLineItemId, ContractLineItem.CH_LineItemEntitlementScript__c, ContractLineItem.LineItemNumber, ContractLineItem.CH_CountryISOName__c, ';
			sQuery += 'ContractLineItem.CH_CountryISO2__c, ContractLineItem.CH_BusinessHour__c, ContractLineItem.CH_BusinessHour__r.Name, ';
			sQuery += 'ContractLineItem.CH_QtyCoveredNetworkElementAssets__c, ContractLineItem.CH_EquipmentLocationBasedTZCoverage__c FROM Entitlement WHERE ';
			sQuery += 'ServiceContractId IN ' + DML_SObject.setToString(oServiceContractIdSet) + ' AND Name != "Authorized Contact" ';
			sQuery += 'AND CH_RecordTypeCheck__c = true AND Status = "Active" AND ContractLineItem.CH_ServiceType__c = "' + serviceType + '" AND AssetId = "' + assetId + '" ';
			sQuery += 'AND ServiceContract.NCP_External_Status__c = "Active" AND ServiceContract.Status = "Active" ';
			sQuery += 'AND ContractLineItem.NCP_External_Status__c = "Active" AND ContractLineItem.Status = "Active" ';
			sQuery += !serviceType.equals('Internal Support') ? 'AND AccountId = "'+accountId+'" ' : '';
			sQuery += swMaintenance ? ' AND ServiceContract.CH_PortalCaseCreationSWMaintenance__c = true' : '';
			List<Entitlement> oEntitlementList = DML_SObject.doQuery(sQuery, withoutSharing);
			//
			if(!oEntitlementList.isEmpty()) {
	if(netElemAsset != null) {
		for(Entitlement oEntitlement : oEntitlementList) { oCLIIdSet.add(oEntitlement.ContractLineItemId); } 
		//
		Map<Id, Set<Id>> oCLItoNEAIdsMap = CH_AssetUtils.getNetworkElementAssetIdsFromCLIList(withoutSharing, oCLIIdSet);
		for(Entitlement oEntitlement : oEntitlementList) {
			Set<Id> oNEAIdSet = (oCLItoNEAIdsMap.containsKey(oEntitlement.ContractLineItemId) ? oCLItoNEAIdsMap.get(oEntitlement.ContractLineItemId) : new Set<Id>());
			if(oEntitlement.ContractLineItem.CH_QtyCoveredNetworkElementAssets__c == 0 || oNEAIdSet.contains(netElemAsset.Id)) {
	oEntitlementResultList.add(oEntitlement);
			}
		}
	}
	else oEntitlementResultList = oEntitlementList;
			}
		}
		return oEntitlementResultList;
	}
	
	/**
	 * @description : display P20 fields - NOKIASC-#####
	 * @return	  : Boolean
	**/
	public static Boolean displayP20fields(Id entitlementId){
		try {
			Boolean result = false;
			CH_Hierarchical_Setting__c oHierarchicalSetting = CH_Hierarchical_Setting__c.getInstance();
			if(!string.isBlank(entitlementId)) {
	List<Entitlement> oEntitlementList = (List<Entitlement>) DM_Entitlement.doSelect(
		'ServiceContract.CH_CARES_ServiceAgreement__c, ServiceContract.CH_CDB_ContractNumber__c'
	).doWhere('Id = "' + entitlementId + '"').setOptions('LIMIT 1').doQuery();
	result = (oHierarchicalSetting != null && oHierarchicalSetting.P20OrderDetails__c && !oEntitlementList.isEmpty() && string.isBlank(oEntitlementList.get(0).ServiceContract.CH_CARES_ServiceAgreement__c) && !string.isBlank(oEntitlementList.get(0).ServiceContract.CH_CDB_ContractNumber__c));
			}
			return result;
		}
		catch(Exception e) {
			system.debug(Logginglevel.ERROR, '###Exception:' + e.getStackTraceString() + ':' + e.getLineNumber() + ':' + e.getCause() + ':' + e.getTypeName());
			throw new AuraHandledException('Something went wrong: ' + e.getMessage());
		}
	}
}