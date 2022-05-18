public without sharing class CH_Portal_Case_Response {
	
	/*****************************************************************
	Description:  
	Get the case record for the case id
	
	Parameters: Id of the case 
	Returns: Case object
	Throws [Exceptions]: [optional]	
	
	History			
	DATE	 AUTHOR	 Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/	
	@AuraEnabled
	public static Case getCaseDetails(Id caseId) {
		Case caseRecord = getCase(caseId);
		return caseRecord;	
	}
	
	/*****************************************************************
	Description:  
	Add a comment to the feed
	
	Parameters: Id of the case and the comment to add
	Returns: NA
	Throws [Exceptions]: [optional]	
	
	History			
	DATE	 AUTHOR	 Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/ 
	@AuraEnabled
	public static void addCommentToFeed(Id caseId, string comment) {	
		casecomment newCaseComment = new casecomment();
		newCaseComment.ParentId = caseid;
		newCaseComment.commentbody=comment.replaceAll('<[/a-zAZ0-9]*>','');
		Database.DMLOptions dlo = new Database.DMLOptions();
		dlo.EmailHeader.triggerUserEmail = true;
		database.insert( newCaseComment, dlo);
	}

	@AuraEnabled
	public static Boolean checkIfSurveyExists(Id caseId) {
		CH_Survey__c survey = [SELECT Id, CH_Expiration_Date__c, CH_Survey_ID__c, CH_Survey_Name__c FROM CH_Survey__c LIMIT 1];
		Network myNetwork = [SELECT Id, Name, UrlPathPrefix FROM Network WHERE Name = 'Customers' LIMIT 1];
		SurveyInvitation existingSurveyInvitation;
		
		for(SurveyInvitation record : [SELECT Id FROM SurveyInvitation WHERE CommunityId = :myNetwork.Id AND Support_Ticket__c = :caseId AND SurveyId = :survey.CH_Survey_ID__c LIMIT 1]){ existingSurveyInvitation = record;		 
		}
		
		if(existingSurveyInvitation != NULL){ return true;	
		} else { return false;
		}
	}
	
	@AuraEnabled
	public static String createSurveyInvitation(Id caseId) {	
		String encodedURLString;
		CH_Survey__c survey = [SELECT Id, CH_Expiration_Date__c, CH_Survey_ID__c, CH_Survey_Name__c FROM CH_Survey__c LIMIT 1];
		User contact = [SELECT Id, ContactId FROM User WHERE Id = :UserInfo.getUserId() AND IsActive = TRUE];
		Network myNetwork = [SELECT Id, Name, UrlPathPrefix FROM Network WHERE Name = 'Customers' LIMIT 1];
		Case supportTicket = [SELECT Id, CaseNumber FROM Case WHERE Id = :caseId];

		SurveyInvitation surveyInvitationToInsert = new SurveyInvitation(CommunityId = myNetwork.Id, InviteExpiryDateTime = System.Today().addDays(Integer.valueOf(survey.CH_Expiration_Date__c)), Name = supportTicket.CaseNumber, OptionsAllowGuestUserResponse = FALSE, ParticipantId = contact.ContactId, Support_Ticket__c = caseId, SurveyId = survey.CH_Survey_ID__c);
		
		insert surveyInvitationToInsert;
		
		SurveyInvitation surveyInvitationRecord = [SELECT Id, UUID, CreatedDate, InvitationLink FROM SurveyInvitation WHERE Id = :surveyInvitationToInsert.Id LIMIT 1];
		encodedURLString = surveyInvitationRecord.InvitationLink;
		
		Case c = new Case(Id=caseId);
		c.CH_Invitation_Link__c = encodedURLString;
		update c;
		
		return encodedURLString;
	}
	
   /*****************************************************************
	Description:  
	Query the case
	
	Parameters: Id of the case to query
	Returns: NA
	Throws [Exceptions]: [optional]	
	
	History			
	DATE	 AUTHOR	 Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/	
	private static Case getCase(Id caseId){
		Case caseRecord = [SELECT Status, CaseNumber, Subject,CH_Product_Name__c, Severity__c,Contact.Name,Product.Name FROM Case WHERE Id = :caseId];
		return caseRecord;	 
	}
}