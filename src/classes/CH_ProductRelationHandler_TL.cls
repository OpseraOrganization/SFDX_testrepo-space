/**
About
-----
Description: This Class is used as Helper for CH_ProductRelationTrigger.

Created for: Nokia Portugal COE
Created: 17 04 2019

Update History
--------------
Created: 17 04 2019 – flavio.toscano@nokia.com
-------------
**/
public with sharing class CH_ProductRelationHandler_TL {

	/*
	* @description : Update Knowledge Article KB Product Fields
	* @param : List<CH_ProductRelease__c>
	* @return : void
	*/
	public static void updateKBProducts(List<CH_ProductRelation__c> oCH_ProductRelation) {
		Set<Id> knowledgeIds = new Set<Id>();
		for(CH_ProductRelation__c oProductRelation: oCH_ProductRelation) {
			if(oProductRelation.CH_Knowledge__c != NULL){
	knowledgeIds.add(oProductRelation.CH_Knowledge__c);
			}
		}
		
		if(!knowledgeIds.isEmpty()){
			List<CH_ProductRelation__c> oProductRelationList = [SELECT CH_Knowledge__r.Id, CH_Parent_Product__r.Name, CH_Parent_Product__c FROM CH_ProductRelation__c WHERE CH_Knowledge__r.Id =: knowledgeIds AND CH_Parent_Release__c = NULL];
			Map<Id,String> knowledgeProductMap = new Map<Id,String>();
			for(Id kbIds: knowledgeIds){
	String result = '';
	for(CH_ProductRelation__c oProductRelation : oProductRelationList){
		if(oProductRelation.CH_Parent_Product__c != NULL && oProductRelation.CH_Knowledge__c == kbIds && (result + oProductRelation.CH_Parent_Product__r.Name+'; ').length() < 1500){
						result += oProductRelation.CH_Parent_Product__r.Name+'; ';
						knowledgeProductMap.put(oProductRelation.CH_Knowledge__c, result);		
		}
	}
			}
			updateKnowledgeArticleProduct(knowledgeProductMap);
		}
		

	}
	
	@future
	private static void updateKnowledgeArticleProduct(Map<Id,String> knowledgeProductMap) {
		List<Knowledge__kav> knowledgeToUpdate = new List<Knowledge__kav>();
		for(Knowledge__kav oKnowledge : [SELECT Id, CH_KB_Products__c, CH_Products_Short__c FROM Knowledge__kav WHERE Id =: knowledgeProductMap.keySet()]){
			oKnowledge.CH_KB_Products__c = knowledgeProductMap.get(oKnowledge.Id);
			oKnowledge.CH_Products_Short__c = knowledgeProductMap.get(oKnowledge.Id);
			knowledgeToUpdate.add(oKnowledge);
		}
		
		if(!knowledgeToUpdate.isEmpty() && !Test.isRunningTest()){
			update knowledgeToUpdate;
		}
	}
}