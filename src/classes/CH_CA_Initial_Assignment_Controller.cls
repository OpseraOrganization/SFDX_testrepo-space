public class CH_CA_Initial_Assignment_Controller {
	@AuraEnabled
	public static Boolean checkInitialAssignment(String caseId){			   
		Boolean returnMsg =false;		 
		
		Case supportCase = [SELECT Id, Status,OwnerId,CH_CurrentQueue__c
							FROM Case 
							WHERE Id =:caseId];
		System.debug('CH_CA : SupprotCase : ' + supportCase);
		String currentQueue=supportCase.CH_CurrentQueue__c;
		if( supportCase.Status=='Created' && String.isBlank(currentQueue)){
			return true;
		}
		return returnMsg;
	}
}