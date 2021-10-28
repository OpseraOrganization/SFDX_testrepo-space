/** 
 * About 
 * ----- 
 * @Description	  : CH_CaseTag__c Object Trigger Helper.
 * @TestClass		 : CH_CaseTagTriggerTest.
 * @Project	: Case Handling.
 * @Modification Log : 
 *  Created  : 2020 06 25 – tiago.almeida@nokia.com
 * ----- 
**/
public without sharing class CH_CaseTagTriggerHelper {
	private static Map<String, Product2> oProductMap = new Map<String, Product2>();
	private static Map<String, CH_CaseTag__c> oDuplicatedTagsMap = new Map<String, CH_CaseTag__c>();

	/**
	 * @description : Validates if the Products from the Case Tag List are valid. NOKIASC-28844
	 * @param 		: List<CH_CaseTag__c> oCaseTagList
	**/
	public static void validateProducts(List<CH_CaseTag__c> oCaseTagList) {
		Set<String> oProductIdSet = new Set<String>();
		for(CH_CaseTag__c oCaseTag: oCaseTagList) {
			if(oCaseTag.CH_Product__c != null) {
	oProductIdSet.add(oCaseTag.CH_Product__c);
			}
		}
		getValidProductMap(oProductIdSet);		
		for(CH_CaseTag__c oCaseTag: oCaseTagList) {
			if(oCaseTag.CH_Product__c != null && !oProductMap.containsKey(oCaseTag.CH_Product__c)) {
	oCaseTag.addError('Invalid Product');
			}
		}
	}
	
	/**
	 * @description : Prevents duplication from the Case Tag Object. NOKIASC-28905
	 * @param 		: List<CH_CaseTag__c> oCaseTagList
	**/
	public static void preventDuplication(List<CH_CaseTag__c> oCaseTagList) {
		Set<String> oTagNameSet = new Set<String>();
		for(CH_CaseTag__c oCaseTag: oCaseTagList) {
			if(oCaseTag.CH_Product__c != null) {
	oTagNameSet.add(oCaseTag.CH_TagName__c);
			}
		}
		getDuplicatedTagsMap(oTagNameSet);		
		for(CH_CaseTag__c oCaseTag: oCaseTagList) {
			if(oDuplicatedTagsMap.containsKey(oCaseTag.CH_TagName__c) && oCaseTag.Id != oDuplicatedTagsMap.get(oCaseTag.CH_TagName__c).Id) {
				  oCaseTag.addError('Error while saving tag, duplicated record found');
			}
		}
	}
	
	/**
	 * @description : Gets and stores a map of Valid Products from a Set.
	 * @param 		: Set<String> oProductIdSet
	**/
	private static void getValidProductMap(Set<String> oProductIdSet) {
		Set<String> oProductKeySet = oProductMap.keySet();
		if(!oProductKeySet.containsAll(oProductIdSet) && !oProductIdSet.isEmpty()) {
			oProductMap = CH_ProductUtils.getValidProductsFromIds(oProductIdSet);
		}
	}
	
	/**
	 * @description : Gets and stores a map of Valid Products from a Set.
	 * @param 		: Set<String> oProductIdSet
	**/
	private static void getDuplicatedTagsMap(Set<String> oTagNameSet) {
		Set<String> oTagKeySet = oDuplicatedTagsMap.keySet();
		if(!oTagKeySet.containsAll(oTagNameSet) && !oTagNameSet.isEmpty()) {
			for(CH_CaseTag__c oCaseTag : [SELECT Id, CH_TagName__c FROM CH_CaseTag__c WHERE CH_TagName__c IN :oTagNameSet AND RecordType.DeveloperName = 'CH_CaseTag']) {
	oDuplicatedTagsMap.put(oCaseTag.CH_TagName__c, oCaseTag);
			}
		}
	}
}