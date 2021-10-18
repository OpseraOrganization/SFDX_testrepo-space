/**
About
-----
Description: Helper Class for OverrideDeleteButtonOnKnowledgeArticleController Lightning component.
Purpose- To Check and provide delete access based on the record owner and publish Status
Created: 01 06 2019
Update History
Author -Rajeshwari Padmasali
--------------
Created:  01 06 2019 – Nokia IN Bangalore
-------------
**/
public class CH_OverrideDeleteButtonOnKnowledgeHelper {
   //This method checks and and provides delete access based on the record owner and publish Status 
	public static Boolean deleteKnowledgeArticle(String recordId){
		system.debug('deleteKnowledgeArticle Method starts here -->'+recordId);
		Boolean executed = true;
		Id strCurrentUserId = UserInfo.getUserId();
		//Checking if recordId is not empty
		if(recordId !=null){
			KnowledgeArticleVersion objKnowledgeArticle = [SELECT Title, Id, KnowledgeArticleId,  PublishStatus, VersionNumber
											  FROM KnowledgeArticleVersion WHERE Id = :recordId];
			Knowledge__kav KnowledgeArticle =[SELECT Id, KnowledgeArticleId, OwnerId, IsDeleted, ValidationStatus, PublishStatus FROM Knowledge__kav where Id=:recordID];
		 //Check the owner of the record and Publication Status as Draft  
			if(KnowledgeArticle.Ownerid ==strCurrentUserId && KnowledgeArticle.PublishStatus=='Draft'){
				String articleId = objKnowledgeArticle.KnowledgeArticleId;
				KbManagement.PublishingService.deleteDraftArticle(articleId);
				executed= true;
			}else{
				executed= false;
			}
		}
		return executed;
	}
}