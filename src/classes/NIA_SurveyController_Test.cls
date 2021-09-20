@isTest(SeeAllData = True) //SeeAllData = True is required to cover Salesforce Survey OOT
private class NIA_SurveyController_Test {
	
	static testMethod void testSurvey() {
		User oAdminUser = TestDataFactory.createUser('Admin', 'Test');
		
		System.runAs(oAdminUser) {
			
			List<SurveyVersion> activeSurveys = NIA_SurveyController.getActiveSurveys();
			
			if(!activeSurveys.isEmpty()){
				List<SurveyQuestion> getSurveyQuestionsPerSurvey = NIA_SurveyController.getSurveyQuestionsPerSurvey(activeSurveys[0].Id);
				
				if(!getSurveyQuestionsPerSurvey.isEmpty()){
					List<SurveyQuestionResponse> surveyQuestionResponseList = [SELECT Id, ResponseId, QuestionId, QuestionChoiceId, SurveyVersionId, InvitationId, ResponseShortText, Datatype FROM SurveyQuestionResponse LIMIT 25];
					
					if(!surveyQuestionResponseList.isEmpty()){
						String SurveyQuestionsResponses = JSON.serialize(surveyQuestionResponseList);
						NIA_SurveyController.insertSurveyQuestionsResponses(SurveyQuestionsResponses);
					}
				}
			}
		}	
	}
}