/**
*   @desc : Global Entity Manager for Survey.
*/
public with sharing class EM_Survey {

	/**
	* @description : method to get the Active Surveys
	* @return : List<Survey>
	*/
	public static List<Survey> getActiveSurveys(){
		return DM_Survey.getInstance().getActiveSurveys();
	}
	
	/**
	* @description : method to get the Active Surveys in SurveyVersion
	* @return : SurveyVersion<Survey>
	*/
	public static List<SurveyVersion> getActiveSurveysVersion() {
		return DM_Survey.getInstance().getActiveSurveysVersion();
	}

	/**
	* @description : method to get the Question per Survey Version
	* @param : Id
	* @return : List<SurveyQuestion>
	*/
	public static List<SurveyQuestion> getSurveyQuestionsPerSurvey(Id SurveyActiveVersionId){
		return DM_Survey.getInstance().getSurveyQuestionsPerSurvey(SurveyActiveVersionId);
	}

	/**
	* @description : method to get the Active Invitation
	* @return : List<SurveyInvitation>
	*/
	public static List<SurveyInvitation> getActiveSurveyInvitation(){
		return DM_Survey.getInstance().getActiveSurveyInvitation();
	}

	/**
	* @description : method to get the Active Survey Version
	* @param : Id
	* @return : List<Survey>
	*/
	public static List<Survey> getActiveSurveyVersion(Id idSurvey){
		return DM_Survey.getInstance().getActiveSurveyVersion(idSurvey);
	}
}