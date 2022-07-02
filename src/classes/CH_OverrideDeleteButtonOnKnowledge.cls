/**
About
-----
Description: Controller Class for OverrideDeleteButtonOnKnowledgeArticleController Lightning component.
Purpose- To override delete button and using the new delete quick Action
Created: 01 06 2019
Update History
Author -Rajeshwari Padmasali
--------------
Created:  01 06 2019 – Nokia IN Bangalore
-------------
**/public class CH_OverrideDeleteButtonOnKnowledge {
	@AuraEnabled
	public static Boolean  deleteKnowledgeArticle(String recordID){
		//Fetch Record ids
		Boolean executed=CH_OverrideDeleteButtonOnKnowledgeHelper.deleteKnowledgeArticle(recordID);
		return executed;
	}
}