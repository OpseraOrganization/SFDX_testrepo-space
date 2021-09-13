public without sharing class CH_SurveyPublicAccessController {
	
	
	@AuraEnabled
	public static String callSurveyApex(String supportTicket, String email){
		String result = '';
		result = verifySurveyAvailability(supportTicket);
		if(result == 'NotStarted'){
			result = getLinkIfAuthorized(email,supportTicket);
		}
		return result;
	}
	
	@AuraEnabled
	public static String verifySurveyAvailability(String supportTicket){
		String result = '';
		List<Case> surveyStatus = [
			SELECT CH_Survey_Invitation__r.ResponseStatus
			FROM Case
			WHERE CaseNumber = :supportTicket
			LIMIT 1
		];
		
		if(!surveyStatus.isEmpty()){
			result = surveyStatus[0].CH_Survey_Invitation__r.ResponseStatus;
		}
		return result;
	}
	
	public static String getLinkIfAuthorized(String email, String supportTicket)
	{
		String result = '';
		
		List<Case> emailCase = [ SELECT Contact.Email, Contact.Email1__c, Contact.CH_Email3__c, CH_Invitation_Link__c
					FROM Case
					  WHERE CaseNumber = :supportTicket
					  LIMIT 1
				  ];
		if(!emailCase.isEmpty())
		{
			String domain1;
			String domain2;
			String domain3;
			
			String email1 = emailCase[0].Contact.Email;
			String email2 = emailCase[0].Contact.Email1__c;
			String email3 = emailCase[0].Contact.CH_Email3__c;
			
			if(!String.isEmpty(email1)){
				domain1 = email1.substring(email.indexOf('@')+1);
			}
			if(!String.isEmpty(email2)){
				domain2 = email2.substring(email.indexOf('@')+1);
			}
			if(!String.isEmpty(email3)){
				domain3 = email3.substring(email.indexOf('@')+1);
			}
			if((!String.isEmpty(email1) && email1.equals(email) && !(domain1.contains('nokia.')) && !(domain1.contains('nsn.')) && !(domain1.contains('alcatel')) && !(domain1.contains('nokia-'))) ||
			   (!String.isEmpty(email2) && email2.equals(email) && !(domain2.contains('nokia.')) && !(domain2.contains('nsn.')) && !(domain2.contains('alcatel')) && !(domain2.contains('nokia-'))) ||
			   (!String.isEmpty(email3) && email3.equals(email) && !(domain3.contains('nokia.')) && !(domain3.contains('nsn.')) && !(domain3.contains('alcatel')) && !(domain3.contains('nokia-')))){
				  result= emailCase[0].CH_Invitation_Link__c;
			}
		}
		return result;
	} 
}