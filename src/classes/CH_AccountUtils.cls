/** 
 * About 
 * ----- 
 * @Description	  : Case Handling Account Utils Class.
 * @TestClass		: CH_AccountUtils_Test.
 * @Project		  : Case Handling.
 * @Modification Log : 
 *  Created  : 2019 12 03 – tiago.almeida@nokia.com
 * ----- 
**/
public class CH_AccountUtils {
	public static DML_SObject DM_Account = new DML_SObject(Account.sObjectType);
	private static Map<String, Schema.RecordTypeInfo> oAccountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
	
	/**
	 * @description : Get the CH Nokia Internal Account - NOKIASC-22262
	 * @return	  : Account
	**/
	public static Account getInternalAccount() {
		List<Account> result = (List<Account>) DM_Account
			.doSelect('Id, Name, AccountNumber, OperationalCustomerName__c, Acc_No__c, CH_ParentAccountName__c, CH_Account_Name_Alias__c')
			.doWhere('AccountNumber = "' + System.Label.CH_Nokia_Internal_Account + '"')
			.setOptions('LIMIT 1').doQuery();
		return !result.isEmpty() ? result.get(0) : null;
	}
	
	/**
	 * @description :  - NOKIASC-
	 * @param	   : Boolean withoutSharing
	 * @param	   : String contactId
	 * @param	   : Boolean swMaintenance
	 * @return	  : List<Account>
	**/
	public static List<Account> getContactAuthorizedLegalEntities(Boolean withoutSharing, String contactId, boolean swMaintenance){
		List<Account> oAccountList = new List<Account>();
		if(String.isNotBlank(contactId)){
			Id legalEntityRecordTypeId = oAccountRecordTypeMap.get('Legal_Entity').getRecordTypeId();
			Set<Account> oAccountSet = new Set<Account>();
			String sQuery = 'SELECT Entitlement.AccountId, Entitlement.Account.Name, Entitlement.Account.CH_CareContract__c, Entitlement.Account.Active__c, Entitlement.Account.OperationalCustomerName__c, ';
			sQuery += 'Entitlement.Account.Acc_No__c, Entitlement.Account.AccountNumber, Entitlement.Account.CH_ParentAccountName__c, Entitlement.Account.CH_Account_Name_Alias__c, ';
			sQuery += 'Entitlement.Account.BillingStreet, Entitlement.Account.BillingCity, Entitlement.Account.Country__c FROM EntitlementContact ';
			sQuery += 'WHERE ContactId = "' + contactId + '" AND Entitlement.ServiceContract.NCP_External_Status__c = "Active" ';
			sQuery += 'AND Entitlement.ServiceContract.Status = "Active" AND Entitlement.Account.Type != "Vendor" ';
			sQuery += 'AND Entitlement.Account.RecordTypeId = "' + legalEntityRecordTypeId + '" ';
			sQuery += swMaintenance ? 'AND Entitlement.ServiceContract.CH_PortalCaseCreationSWMaintenance__c = true' : '';
			for(EntitlementContact oEntitlementContact : (List<EntitlementContact>) DML_SObject.doQuery(sQuery, withoutSharing)) {
				if(oEntitlementContact.Entitlement != null && oEntitlementContact.Entitlement.Account != null) {
					oAccountSet.add(oEntitlementContact.Entitlement.Account);													 
				}
			}
			oAccountList.addAll(oAccountSet);
		}
		return oAccountList;
	}
	
	/**
	 * @description :  - NOKIASC-
	 * @param	   : String searchString
	 * @param	   : String contactId
	 * @param	   : String serviceType
	 * @return	  : List<Account>
	**/
	public static List<Account> searchLegalEntities(String searchString, String contactId, String serviceType) {
		List<Account> oAccountList = new List<Account>();
		if(String.isNotBlank(searchString)) {
			Map<Id ,Account> eligibleAccountsMap = serviceType == 'Customer Support'?new Map<Id,Account>(getContactAuthorizedLegalEntities(false, contactId, false)):new map<Id,Account>();
			Id legalEntityRecordTypeId = oAccountRecordTypeMap.get('Legal_Entity').getRecordTypeId();		
			String sQuery = 'FIND ' + '\'' + String.escapeSingleQuotes(searchString.trim()) + '\' ';
			sQuery += 'IN All FIELDS RETURNING Account (Id, Name, AccountNumber, CH_CareContract__c, Active__c, BillingStreet, BillingCity, Country__c, OperationalCustomerName__c, CH_Account_Name_Alias__c WHERE RecordTypeId = ' + '\'' + legalEntityRecordTypeId + '\'' + ')'; 
			List<List<sObject>> sResults = DML_SObject.doSearch(sQuery);
			if(sResults != null && !sResults.isEmpty()) {
				for(Account oAccount: (List<Account>) sResults[0]) {
					if(!eligibleAccountsMap.containsKey(oAccount.Id)) {
						oAccountList.add(oAccount);
					}
				}
			}
		}
		return oAccountList;
	}
}