/***************************************
* Helper Class   : CH_ProductLogTypeTrigger_Helper
* Description	-To prevent duplicate "Product Log Types" Record creation.
* Handler Class  - 'CH_ProductLogTypeTrigger_Handler ' 
* Test Class	 - CH_ProductLogTypeTrigger_Test 
* Created Details- 
* Developer	  - TCS 
* Date		   - 16 June 2021
* User Story	 - NOKIASC-36516
*****************************************/
public without sharing class CH_ProductLogTypeTrigger_Helper {
	public static void validateDuplication(List<CH_ProductLogType__c> newProductLogTypeList) {
		Set<String> sProductSet = new Set<String>();
		Set<String> sLogTypeSet = new Set<String>();
		Set<String> sCategorySet = new Set<String>();
		Set<String> sCollectorLogTypeSet = new Set<String>();
		
		for(CH_ProductLogType__c oProductLogType : newProductLogTypeList) {
			sProductSet.add(oProductLogType.CH_Product__c);
			sLogTypeSet.add(oProductLogType.CH_LogType__c);
			sCategorySet.add(oProductLogType.CH_Category__c);
			sCollectorLogTypeSet.add(oProductLogType.CH_CollectorLogType__c);
		}
		
		Map<String, CH_ProductLogType__c> oExistingLogTypesMap = new Map<String, CH_ProductLogType__c>();
		for(CH_ProductLogType__c oProductLogType : [
			SELECT Id, Name, CH_Product__c, CH_LogType__c, CH_CollectorLogType__c, CH_Category__c, CH_AutoLogCollection__c From CH_ProductLogType__c
			WHERE CH_Product__c IN :sProductSet AND CH_LogType__c IN :sLogTypeSet AND CH_Category__c IN :sCategorySet AND CH_CollectorLogType__c IN :sCollectorLogTypeSet
		]) {
			oExistingLogTypesMap.put(
				oProductLogType.CH_Product__c + '-' + oProductLogType.CH_LogType__c + '-' + oProductLogType.CH_Category__c + '-' + oProductLogType.CH_CollectorLogType__c + '-' + oProductLogType.CH_AutoLogCollection__c,
				oProductLogType
			);
		}
		
		for(CH_ProductLogType__c oProductLogType : newProductLogTypeList) {
			String key = oProductLogType.CH_Product__c + '-' + oProductLogType.CH_LogType__c + '-' + oProductLogType.CH_Category__c + '-' + oProductLogType.CH_CollectorLogType__c + '-' + oProductLogType.CH_AutoLogCollection__c;
			CH_ProductLogType__c existingProductLogType = oExistingLogTypesMap.containsKey(key) ? oExistingLogTypesMap.get(key) : null;
			if(existingProductLogType != null && existingProductLogType.Id != oProductLogType.Id) {
				oProductLogType.addError(System.Label.CH_Duplicate_ProductLogType_Found + ' ' + existingProductLogType.Name);
			}
		}
	}
}