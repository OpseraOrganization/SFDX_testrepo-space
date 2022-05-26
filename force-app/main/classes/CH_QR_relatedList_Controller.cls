public without sharing class CH_QR_relatedList_Controller 
{
	@AuraEnabled
	public static List<SurveyQuestionResponse> getRelatedQuestionResponsesList(ID recordId)
	{
		try
		{
			List<Case> casesList= [SELECT subject,status,CH_Survey_Invitation__c,OwnerId,ContactId FROM Case WHERE ID=:recordId LIMIT 1];
			
			if(casesList.isEmpty())
				return null;			
			else
				if(!(casesList[0].status).equals('Closed'))
					return null;
			
			List<User > userList = [SELECT Id FROM User WHERE ContactId = :casesList[0].ContactId LIMIT 1];
			
			if(!(casesList[0].OwnerId).equals(UserInfo.getUserId()) && !(userList[0].Id).equals(UserInfo.getUserId()))
				return null;
			
			List<SurveyQuestionResponse> surveyQuestionsResponsesList = [SELECT Id,Question.Name,Response.Name,QuestionChoice.Name,CreatedDate,ResponseShortText 
																		   FROM SurveyQuestionResponse 
																		  WHERE invitationId =: casesList[0].CH_Survey_Invitation__c
																		];
			if(!surveyQuestionsResponsesList.isEmpty())
			{
				return surveyQuestionsResponsesList;
			}				
			else 
				return null;
		}
		catch(Exception e)
		{
			return null;
		}
	}//end getStatus method
	
}//end class