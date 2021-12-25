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
		Case caseRecord = [SELECT Status, CaseNumber FROM Case WHERE Id = :caseId];
		return caseRecord;	 
	}
}