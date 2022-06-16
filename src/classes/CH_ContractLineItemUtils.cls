/** 
 * About 
 * ----- 
 * @Description	  : Case Handling Contract Line Item Object Utility Class.
 * @TestClass		: CH_ContractLineItemUtils_Test.
 * @Project		  : Case Handling.
 * @Modification Log : 
 *  Created  : 2020 09 20 – tiago.almeida@nokia.com
 * ----- 
**/
public class CH_ContractLineItemUtils {
	public static final DML_SObject DML_CLI = new DML_SObject(ContractLineItem.sObjectType);
	public static final DML_SObject DML_CVC = new DML_SObject(CH_CoveredVendorContract__c.sObjectType);

	public static List<ContractLineItem> searchCLI(Id oVendorContractId, Id oAccountId, String sServiceAgreement, String sCaresLineItem, String sCDBNumber, String sContractNumber, String sLineItemNumber, String sProductName, String sStatus, String sExternalStatus) {
		String sWhere = oAccountId != null ? ('ServiceContract.AccountId = "' + oAccountId + '"') : '';
		sWhere += !string.isBlank(sServiceAgreement) ? ((sWhere != '' ? ' AND ' : '') + 'ServiceContract.CH_CARES_ServiceAgreement__c = "' + sServiceAgreement + '"') : '';
		sWhere += !string.isBlank(sCaresLineItem) ? ((sWhere != '' ? ' AND ' : '') + 'CH_CARES_LineItem__c = "' + sCaresLineItem + '"') : '';
		sWhere += !string.isBlank(sCDBNumber) ? ((sWhere != '' ? ' AND ' : '') + 'CH_CDB_ContractId__c = "' + sCDBNumber + '"') : '';
		sWhere += !string.isBlank(sContractNumber) ? ((sWhere != '' ? ' AND ' : '') + 'ServiceContract.ContractNumber = "' + sContractNumber + '"') : '';
		sWhere += !string.isBlank(sLineItemNumber) ? ((sWhere != '' ? ' AND ' : '') + 'LineItemNumber = "' + sLineItemNumber + '"') : '';
		sWhere += !string.isBlank(sProductName) ? ((sWhere != '' ? ' AND ' : '') + 'Product2.Name = "' + sProductName + '"') : '';
		sWhere += !string.isBlank(sStatus) ? ((sWhere != '' ? ' AND ' : '') + 'Status = "' + sStatus + '"') : '';
		sWhere += !string.isBlank(sExternalStatus) ? ((sWhere != '' ? ' AND ' : '') + 'NCP_External_Status__c = "' + sExternalStatus + '"') : '';
		//Check Existing
		Set<String> oContractLineItemIdSet = new Set<String>();
		for(CH_CoveredVendorContract__c oCoveredVendorContract : (List<CH_CoveredVendorContract__c>) DML_CVC.doSelect('CH_ContractLineItem__c').doWhere('CH_VendorContract__c = "' + oVendorContractId + '"').doQuery()) {
			oContractLineItemIdSet.add(oCoveredVendorContract.CH_ContractLineItem__c);
		}
		sWhere += !oContractLineItemIdSet.isEmpty() ? ((sWhere != '' ? ' AND ' : '') + 'Id NOT IN ' + DML_SObject.setToString(oContractLineItemIdSet)) : '';
		sWhere += ' limit 2000 '; 
		return DML_CLI.doSelect(
			'Id, ServiceContract.Account.Name, ServiceContract.Name, LineItemNumber, Asset.Name, CH_ServiceOffering__c, EndDate, CH_CARES_LineItem__c, ServiceContract.NCP_External_Status__c, NCP_External_Status__c'
		).doWhere(sWhere).doQuery();
	}
	
	
	
	public static List<ContractLineItem> get(Set<String> sObjectIdSet) {
		return DML_CLI.doSelect(
			'ServiceContract.AccountId, Asset.Name, Asset.Product2Id, Asset.CH_ProductVariant__c, Asset.CH_Solution__c, Asset.CH_ProductRelease__c, ' +
			'CH_CountryISOName__c'
		).doWhere(
			'Id IN ' + DML_SObject.setToString(sObjectIdSet)
		).doQuery();
	}
}