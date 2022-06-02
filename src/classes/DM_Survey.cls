public with sharing class DM_Survey extends DM_SObject{
	private static DM_Survey classInstance;

	static {
		classInstance = new DM_Survey();
	}

	private DM_Survey() {}

	/**
	* @description Method provide instance of the object.
	* @return DM_Survey Instance of the object.
	*/
	public static DM_Survey getInstance() {
		return classInstance;
	}

	/**
	* @description : method to get the Active Surveys
	* @return : List<Survey>
	*/
	public List<Survey> getActiveSurveys() {
		return [
				SELECT
					Id,
					Name,
					ActiveVersionId,
					LatestVersionId
				FROM
					Survey
				WHERE
					Id IN (
						SELECT
								SurveyId
						FROM
								SurveyVersion
						WHERE
								SurveyStatus = 'Active'
					)
		];
	}

	/**
	* @description : method to get the Active Surveys in SurveyVersion
	* @return : SurveyVersion<Survey>
	*/
	public List<SurveyVersion> getActiveSurveysVersion() {
		return [
			SELECT
				Id,
				Name,
				SurveyId
			FROM
				SurveyVersion
			WHERE
				SurveyStatus = 'Active'
		];
	}

	/**
	* @description : method to get the Question per Survey Version
	* @param : Id
	* @return : List<SurveyQuestion>
	*/
	public List<SurveyQuestion> getSurveyQuestionsPerSurvey(Id SurveyActiveVersionId) {
		return [
				SELECT
					Id,
					Name,
					SurveyVersionId,
					SurveyPage.Name,
					QuestionType,
					(SELECT
						Name
					FROM
						QuestionChoices
					ORDER BY Name ASC)
				FROM
					SurveyQuestion
				WHERE
					SurveyVersionId =: SurveyActiveVersionId
				ORDER BY SurveyPage.Name, Name ASC
		];
	}

	/**
	* @description : method to get the Active Invitation
	* @return : List<SurveyInvitation>
	*/
	public List<SurveyInvitation> getActiveSurveyInvitation() {
		return [
				SELECT
					Id,
					CommunityId,
					InvitationLink,
					SurveyId,
					OptionsAllowParticipantAccessTheirResponse,
					OptionsCollectAnonymousResponse,
					OptionsAllowGuestUserResponse
				FROM
					SurveyInvitation
				WHERE
					IsDefault = TRUE
				LIMIT 1
		];
	}

	/**
	* @description : method to get the Active Survey Version
	* @param : Id
	* @return : List<Survey>
	*/
	public List<Survey> getActiveSurveyVersion(Id idSurvey) {
		return [
				SELECT
					Id,
					Name,
					ActiveVersionId
				FROM
					Survey
				WHERE
					Id =: idSurvey
		];
	}
}