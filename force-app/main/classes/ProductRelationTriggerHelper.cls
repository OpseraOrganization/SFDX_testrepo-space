/** 
 * About 
 * ----- 
 * @Description	  : Product_Relation__c Object Trigger Helper.
 * @TestClass		: ProductRelationTriggerTest.
 * @Project		  : Case Handling.
 * @Modification Log : 
 *  Created  : 2020 01 23 – tiago.almeida@nokia.com
 * ----- 
**/
public class ProductRelationTriggerHelper {
	
	/**
	 * @description : Auto Completes the Product References when Product_Relation__c is created.
	 * @param	  	: List<Product_Relation__c> newList
	**/
	public static void CH_AutoCompleteRelations(List<Product_Relation__c> newList) {
		Set<String> sProductNamesSet = new Set<String>();
		Map<String, Id> oProductNameToIdMap = new Map<String, Id>();
		for(Product_Relation__c oProductRelation : newList) {
			if(oProductRelation.Parent_Name__c != null && oProductRelation.Parent_Name__c != '' && oProductRelation.Parent_Product__c == null) {
				sProductNamesSet.add(oProductRelation.Parent_Name__c);				
			}
			if(oProductRelation.Child_Name__c != null && oProductRelation.Child_Name__c != '' && oProductRelation.Child_Product__c == null) {
				sProductNamesSet.add(oProductRelation.Child_Name__c);
			}
		}
		if(!sProductNamesSet.isEmpty()) {
			for(Product2 oProduct : [SELECT Id, NCP_Nokia_Product_Id__c FROM Product2 WHERE NCP_Nokia_Product_Id__c IN :sProductNamesSet]) {
				oProductNameToIdMap.put(oProduct.NCP_Nokia_Product_Id__c, oProduct.Id);
			}
			if(!oProductNameToIdMap.isEmpty()) {
				for(Product_Relation__c oProductRelation : newList) {
					if(oProductRelation.Parent_Name__c != null && oProductRelation.Parent_Name__c != '' && oProductRelation.Parent_Product__c == null) {
						oProductRelation.Parent_Product__c = oProductNameToIdMap.containsKey(oProductRelation.Parent_Name__c) ? oProductNameToIdMap.get(oProductRelation.Parent_Name__c) : null;
						sProductNamesSet.add(oProductRelation.Parent_Name__c);				
					}
					if(oProductRelation.Child_Name__c != null && oProductRelation.Child_Name__c != '' && oProductRelation.Child_Product__c == null) {
						oProductRelation.Child_Product__c = oProductNameToIdMap.containsKey(oProductRelation.Child_Name__c) ? oProductNameToIdMap.get(oProductRelation.Child_Name__c) : null;
					}
				}
			}
		}
	}
}