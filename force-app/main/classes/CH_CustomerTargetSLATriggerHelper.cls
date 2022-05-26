/****************************************
 * Class Name : CH_CustomerTargetSLATriggerHelper 
 * Created Date: 26 October 2018
 * Created By : TCS
 * Last Modified by: TCS
 * Last Modified Date: 26 October 2018
 * Description : Contains common business logic
 * Test Class: CH_CustomerTargetSLATriggerTest
 *****************************************/
public class CH_CustomerTargetSLATriggerHelper {
	/********************
	* Method Name: inActiveOldSlaRecords
	* Parameter: List < CH_CustomerSpecificTargetSLA__c >
	* Description: Used to inactive status of old SLA records when CDB sends in new SLAs
	* Reference: NOKIASC-14033
	*******************/
	public static void inActiveOldSlaRecords(List < CH_CustomerSpecificTargetSLA__c > newCustomerSlaList) {
		if(newCustomerSlaList != null && !newCustomerSlaList.isEmpty()) {
			Set < Id > accountIds = new Set < Id > ();
			Set < Id > entitlementIds = new Set < Id > ();
			Set < Id > contractIds = new Set < Id > ();
			Set < Id > lineItemIds = new Set < Id > ();
			Set < String > severityTypes = new Set < String > ();
			Map < String, CH_CustomerSpecificTargetSLA__c > newCustomerSlaMap = new Map < String, CH_CustomerSpecificTargetSLA__c > ();
			
			for(CH_CustomerSpecificTargetSLA__c customerSlaObj: newCustomerSlaList) {
				accountIds.add(customerSlaObj.CH_Account__c);
				entitlementIds.add(customerSlaObj.CH_Entitlement__c);
				contractIds.add(customerSlaObj.CH_ServiceContract__c);
				lineItemIds.add(customerSlaObj.CH_LineItemNumber__c);
				severityTypes.add(customerSlaObj.CH_Severity__c);
				newCustomerSlaMap.put(getUniqueKey(customerSlaObj), customerSlaObj);
			}
			
			List < CH_CustomerSpecificTargetSLA__c > existingCustomerSlaList = [
				SELECT Id, CH_Account__c, CH_Entitlement__c, CH_ServiceContract__c, CH_LineItemNumber__c, CH_Severity__c, CH_Outage__c, CH_SLARecordStatus__c FROM CH_CustomerSpecificTargetSLA__c 
					WHERE CH_Account__c IN :accountIds AND
						CH_Entitlement__c IN :entitlementIds AND
						CH_ServiceContract__c IN :contractIds AND
						CH_LineItemNumber__c IN :lineItemIds AND
						CH_Severity__c IN :severityTypes AND
						CH_SLARecordStatus__c = 'Active'
			];
			
			if(existingCustomerSlaList != null && !existingCustomerSlaList.isEmpty()) {
				List < CH_CustomerSpecificTargetSLA__c > updateCustomerSlaList = new List < CH_CustomerSpecificTargetSLA__c > ();
				for(CH_CustomerSpecificTargetSLA__c existingCustomerSlaObj: existingCustomerSlaList) {
					if(newCustomerSlaMap.containsKey(getUniqueKey(existingCustomerSlaObj))) {
						existingCustomerSlaObj.CH_SLARecordStatus__c = 'Inactive';
						updateCustomerSlaList.add(existingCustomerSlaObj);
					} 
				}
				if(!updateCustomerSlaList.isEmpty()) {
					try {
						update updateCustomerSlaList;
					} catch(Exception ex) {
						System.debug('### Exception Occurred at CH_CustomerTargetSLATriggerHelper.inActiveOldSlaRecords ### ' + ex.getMessage());
					}
				}
			}
		}
	}
	
	/********************
	* Method Name: getUniqueKey
	* Parameter: CH_CustomerSpecificTargetSLA__c
	* Description: Used to prepare unique key which will be used to match old sla records
	* Reference: NOKIASC-14033
	*******************/
	public static String getUniqueKey(CH_CustomerSpecificTargetSLA__c customerSlaObj) {
		String key = customerSlaObj.CH_Account__c;
		key = key + '-' + customerSlaObj.CH_Entitlement__c;
		key = key + '-' + customerSlaObj.CH_ServiceContract__c;
		key = key + '-' + customerSlaObj.CH_LineItemNumber__c;
		key = key + '-' + customerSlaObj.CH_Severity__c;
		key = key + '-' + customerSlaObj.CH_Outage__c;
		return key;
	}
}