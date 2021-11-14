/**
About
-----
Description: This Class is used as Controller for NIA_Survey Lightning Component.

Created for: Nokia Portugal COE (ERM)
Created: 12 05 2018

Update History
--------------
Created: 12 05 2018 – flavio.toscano@nokia.com
-------------
**/
public with sharing class NIA_SurveyController {

	@AuraEnabled(cacheable=true)
	public static List<SurveyVersion> getActiveSurveys () {

		List<SurveyVersion> activeSurveys = EM_Survey.getActiveSurveysVersion();

		if(!activeSurveys.isEmpty()){
			return activeSurveys;
		} else{
			return null;
		}   
	}
	
	@AuraEnabled(cacheable=true)
	public static List<SurveyQuestion> getSurveyQuestionsPerSurvey (Id SurveyActiveVersionId) {

		List<SurveyQuestion> surveyQuestions = EM_Survey.getSurveyQuestionsPerSurvey(SurveyActiveVersionId);

		if(!surveyQuestions.isEmpty()){
			return surveyQuestions;
		} else{
			return null;
		}
	}

	@AuraEnabled
	public static void insertSurveyQuestionsResponses (String SurveyQuestionsResponses) {
		List<SurveyQuestionResponse> surveyQuestionResponseList = new List<SurveyQuestionResponse>();
		List<NIA_SurveyQuestionResponse__c> surveyQuestionResponseCustomList = new List<NIA_SurveyQuestionResponse__c>();
		List<SurveyResponse> surveyResponseList = new List<SurveyResponse>();
		List<NIA_SurveyResponse__c> surveyResponseCustomList = new List<NIA_SurveyResponse__c>();
		List<SurveyInvitation> surveyInvitationList = new List<SurveyInvitation>();
		List<Survey> surveyList = new List<Survey>();
		Id idInvitation;
		Id idSurveyVersion;
		Id idSurvey;
		Id idInsertedSurveyResponse;
		Boolean createSurveyResponse = TRUE;

		surveyQuestionResponseList = (List<SurveyQuestionResponse>) JSON.deserialize(SurveyQuestionsResponses, List<SurveyQuestionResponse>.class);

		surveyInvitationList = EM_Survey.getActiveSurveyInvitation();

		if(!surveyInvitationList.isEmpty()){
			for(SurveyInvitation surveyInv : surveyInvitationList){
	idInvitation = surveyInv.Id;
	idSurvey = surveyInv.SurveyId;
			}

			surveyList = EM_Survey.getActiveSurveyVersion(idSurvey);
		}

		if(!surveyList.isEmpty()){
			for(Survey surv : surveyList){
	idSurveyVersion = surv.ActiveVersionId;
			}
		}

		if(!surveyQuestionResponseList.isEmpty()){
			for(SurveyQuestionResponse surveyQR : surveyQuestionResponseList){
	if(createSurveyResponse){
		NIA_SurveyResponse__c newSurveyResponse = new NIA_SurveyResponse__c(
			SubmitterId__c = surveyQR.CreatedById,
			InvitationId__c = idInvitation,
			Status__c = 'Completed',
			SurveyId__c = idSurvey,
			CompletionDateTime__c = Date.today(),
			SurveyVersionId__c = idSurveyVersion
		);
		surveyResponseCustomList.add(newSurveyResponse);
		createSurveyResponse = FALSE;
	}				
			}

			if(!surveyResponseCustomList.isEmpty()){
				insert surveyResponseCustomList;
	for(NIA_SurveyResponse__c survresp : surveyResponseCustomList){
		idInsertedSurveyResponse = survresp.Id;
	}
			}

			for(SurveyQuestionResponse surveyQR : surveyQuestionResponseList){
	NIA_SurveyQuestionResponse__c newSurveyQuestionResponse = new NIA_SurveyQuestionResponse__c(
			Datatype__c = surveyQR.Datatype,
			InvitationId__c = idInvitation,
			ResponseShortText__c = surveyQR.ResponseShortText,
			QuestionId__c = surveyQR.QuestionId,
			QuestionChoiceId__c = surveyQR.QuestionChoiceId,
			ResponseId__c = idInsertedSurveyResponse,
			SurveyVersionId__c = idSurveyVersion
	);
	surveyQuestionResponseCustomList.add(newSurveyQuestionResponse);
			}

			if(!surveyQuestionResponseCustomList.isEmpty()){
	insert surveyQuestionResponseCustomList;
			}
		}
	}
}