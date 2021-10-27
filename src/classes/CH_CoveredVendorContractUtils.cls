/** 
 * About 
 * ----- 
 * @Description	  : Case Handling Covered Vendor Contract Object Utility Class.
 * @TestClass		: CH_CoveredVendorContractUtils_Test.
 * @Project		  : Case Handling.
 * @Modification Log : 
 *  Created  : 2020 10 09 – tiago.almeida@nokia.com
 * ----- 
**/
public class CH_CoveredVendorContractUtils {
	public static final DML_SObject DML = new DML_SObject(CH_CoveredVendorContract__c.sObjectType);
	
	public static List<CH_CoveredVendorContract__c> get(String sObjectType, Id sObjectId) {
		return DML.doSelect(
			(sObjectType.equals('ServiceContract') ? (
				'CH_ContractLineItem__r.Asset.Name, CH_ContractLineItem__r.CH_Entitlement__r.Name, CH_ContractLineItem__r.CH_Account__c, ' +
				'CH_ContractLineItem__r.EndDate, CH_ContractLineItem__r.ServiceContract.Name, CH_ContractLineItem__r.NCP_External_Status__c, ' +
				'CH_ContractLineItem__r.Status, CH_ContractLineItem__r.LineItemNumber'
			):(
				'CH_VendorContract__r.Account.Name, CH_VendorContract__r.Name, CH_VendorContract__r.ContractNumber, ' + 
				'CH_VendorContract__r.CH_PaidToEndDate__c, CH_VendorContract__r.StartDate, CH_VendorContract__r.EndDate'
			))
		).doWhere(
			(sObjectType.equals('ServiceContract') ? 'CH_VendorContract__c' : 'CH_ContractLineItem__c') + ' = "' + sObjectId + '"'
		).doQuery();
	}
	
	public static String create(Id oVendorContractId, List<String> oContractLineItemIdList) {
		//Check Existing
		Set<String> oContractLineItemIdSet = new Set<String>();
		for(CH_CoveredVendorContract__c oCoveredVendorContract : (List<CH_CoveredVendorContract__c>) DML.doSelect('CH_ContractLineItem__c').doWhere('CH_VendorContract__c = "' + oVendorContractId + '"').doQuery()) {
			oContractLineItemIdSet.add(oCoveredVendorContract.CH_ContractLineItem__c);
		}
		//
		List<CH_CoveredVendorContract__c> oCoveredVendorContractList = new List<CH_CoveredVendorContract__c>();
		for(String oContractLineItemId : oContractLineItemIdList) {
			if(!oContractLineItemIdSet.contains(oContractLineItemId)) {
				CH_CoveredVendorContract__c oCoveredVendorContract = new CH_CoveredVendorContract__c();
				oCoveredVendorContract.CH_VendorContract__c = oVendorContractId;
				oCoveredVendorContract.CH_ContractLineItem__c = oContractLineItemId;
				oCoveredVendorContractList.add(oCoveredVendorContract);
			}
		}
		if(!oCoveredVendorContractList.isEmpty()) {
			try {
				DML_SObject.doInsert(oCoveredVendorContractList, true, true);
				return '';
			}
			catch (Exception e) {
				return e.getMessage();
			}
		}
		return 'duplicated';
	}
	
	public static boolean remove(Id sObjectId) {
		List<CH_CoveredVendorContract__c> oCoveredVendorContractList = DML.doSelect('Id').doWhere('Id = "' + sObjectId + '"').doQuery(true);
		if(!oCoveredVendorContractList.isEmpty()) {
			try {
				DML_SObject.doDelete(oCoveredVendorContractList, true, true);
				return true;
			} catch (Exception e) { 
			   throw new AuraHandledException(e.getMessage());
			}
		}
		return false;
	}
}