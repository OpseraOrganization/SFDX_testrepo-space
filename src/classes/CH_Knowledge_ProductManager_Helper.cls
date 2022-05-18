/****************************************
* Class Name : CH_Knowledge_ProductManager_Helper
* Created Date: 9 May 2019
* Created By : Tiago Almeida (tiago.almeida@nokia.com)
* Last Modified by: Tiago Almeida
* Last Modified Date: 9 May 2019
* Description : Helper for CH_Knowledge_ProductManager
* Test Class: CH_Knowledge_ProductManager_Test
*****************************************/
public without sharing class CH_Knowledge_ProductManager_Helper {
	
	public static Boolean createTopic(Id articleId, Id productRelationId) {
		try {
			CH_ProductRelation__c oProductRelation = [SELECT Id, CH_Parent_Product__r.Id, CH_Parent_Product__r.Name FROM CH_ProductRelation__c WHERE Id =: productRelationId LIMIT 1];
			Topic topic = new Topic(Name = oProductRelation.CH_Parent_Product__r.Name);
			upsert topic;
			TopicAssignment topicAssignment = new TopicAssignment(EntityId = articleId, TopicId= topic.Id);
			upsert topicAssignment;
		}
		catch (Exception e) { 
	  //Added empty line  
		}
		return true;
	}
	
	public static Boolean removeTopic(Id articleId, string productName) {
		try {
			List<Topic> oTopic = [SELECT Id FROM Topic WHERE Name =: productName LIMIT 1];
			if(!oTopic.isEmpty()){
	List<TopicAssignment> oTopicAssignment = [SELECT Id, TopicId FROM TopicAssignment WHERE EntityId =: articleId AND TopicId =: oTopic[0].Id LIMIT 1];
	if(!oTopicAssignment.isEmpty()) delete oTopicAssignment;
	delete oTopic;
			}
		} catch (Exception e) {
			system.debug('###Exception:' + e.getMessage());
			throw new AuraHandledException('Something went wrong! '+ e.getMessage());
		}
		return true;
	}
	
	public static void updateKBProducts(Id articleId) {
		String result = '';
		//for(CH_ProductRelation__c oProductRelation : [SELECT CH_Parent_Product__r.Name FROM CH_ProductRelation__c WHERE CH_Knowledge__c =: articleId AND CH_Parent_Product__c != NULL AND CH_Parent_Release__c = NULL]){
		for(CH_ProductRelation__c oProductRelation : [SELECT CH_Knowledge__r.Id, CH_Parent_Product__r.Name, CH_Parent_Product__c FROM CH_ProductRelation__c WHERE CH_Knowledge__r.Id =: articleId AND CH_Parent_Release__c = NULL]){
			if((oProductRelation.CH_Parent_Product__c != NULL) && ((result + oProductRelation.CH_Parent_Product__r.Name+'; ').length() < 1500)){
	result += oProductRelation.CH_Parent_Product__r.Name+'; ';		 
			}
		}
		Knowledge__kav oKnowledge = [SELECT Id, CH_KB_Products__c FROM Knowledge__kav  WHERE Id =: articleId LIMIT 1];
		oKnowledge.CH_KB_Products__c = result;
		update oKnowledge;
	}
}