/**************************************************************************
 * Apex Class to implement the logic needed to handle CH_CPA_AcceptReject.cmp 
 * Gourisankar Patra- CH1- TCS- 12.11.2019
 **************************************************************************/

public class CH_ME_Controller {
@AuraEnabled
	public static void acceptME(string recordId){
	 	
		system.debug('Accept ME');
		try {
			system.debug('record is '+recordId);
			CH_Manage_Escalation__c objMEUpdate = [select id, CH_EscalationStatus__c,CH_EscalationProcessStage__c from CH_Manage_Escalation__c where id =: recordId];   
			objMEUpdate.CH_EscalationStatus__c = 'In-Progress'; 
			objMEUpdate.CH_EscalationProcessStage__c='Activate';
			objMEUpdate.CH_EscalationLevelSetTime__c=System.now();
			objMEUpdate.CH_RejectionCause__c= '';
			update objMEUpdate;
						
					}
		catch(Exception e) {
			system.debug('###Exception : while update ME Status' + e);
		}
			
	  
	}
	
	@AuraEnabled
	public static void rejectME(string recordId, string rejectcause){
	 	
		system.debug('Reject ME');
		try {

			system.debug('record is '+recordId);
			system.debug('rejectcause is '+rejectcause);
			CH_Manage_Escalation__c objMEUpdate = [select id, CH_EscalationProcessStage__c,CH_EscalationStatus__c,CH_RejectionCause__c from CH_Manage_Escalation__c where id =: recordId];   
			objMEUpdate.CH_EscalationStatus__c = 'Rejected'; 
			objMEUpdate.CH_RejectionCause__c= rejectcause;
			objMEUpdate.CH_EscalationProcessStage__c='Close';
			objMEUpdate.CH_EscalationRejectionDate__c=System.now();
			update objMEUpdate;
						
					}
		catch(Exception e) {
			system.debug('###Exception : while update ME Status' + e);
		}
			
	  
	}
	
	
	@AuraEnabled
	public static CH_Manage_Escalation__c transferMEFieldsQuery(string recordId) {
		CH_Manage_Escalation__c ME = [select CH_RejectionCause__c,OwnerId from CH_Manage_Escalation__c where id=: recordId];
		system.debug('ME Value Fetched' +ME);
		 
		return ME;
	}
	
  
	
}