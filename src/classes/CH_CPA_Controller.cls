/**************************************************************************
 * Apex Class to implement the logic needed to handle CH_CPA_AcceptReject.cmp
 **************************************************************************/

public class CH_CPA_Controller {
@AuraEnabled
	public static void acceptCPA(string recordId){
	 	
		system.debug('Accept CPA');
		try {
			/*CH_Corrective_Preventive_Action__c objCPAUpdate = new CH_Corrective_Preventive_Action__c();
			objCPAUpdate.Id = recordId;
			objCPAUpdate.CH_CPA_Status__c = 'In Progress';
			update objCPAUpdate;*/
			system.debug('record is '+recordId);
			CH_Corrective_Preventive_Action__c objCPAUpdate = [select id, CH_CPA_Status__c from CH_Corrective_Preventive_Action__c where id =: recordId];   
			objCPAUpdate.CH_CPA_Status__c = 'In Progress'; 
			update objCPAUpdate;
	 system.debug('cpa--'+objCPAUpdate);	
		}
		catch(Exception e) {
			system.debug('###Exception : while update CPA Status' + e);
		}
			
	  
	}
	
	@AuraEnabled
	public static void rejectCPA(string recordId, string rejectcause){
	 	
		system.debug('Reject CPA');
		try {
			/*CH_Corrective_Preventive_Action__c objCPAUpdate = new CH_Corrective_Preventive_Action__c();
			objCPAUpdate.Id = recordId;
			objCPAUpdate.CH_CPA_Status__c = 'In Progress';
			update objCPAUpdate;*/
			system.debug('record is '+recordId);
			system.debug('rejectcause is '+rejectcause);
			CH_Corrective_Preventive_Action__c objCPAUpdate = [select id, CH_CPA_Status__c,CH_Rejection_Cause__c from CH_Corrective_Preventive_Action__c where id =: recordId];   
			objCPAUpdate.CH_CPA_Status__c = 'Rejected'; 
			objCPAUpdate.CH_Rejection_Cause__c= rejectcause;
			system.debug('record is '+recordId);
			update objCPAUpdate;
			system.debug('CPA--'+objCPAUpdate);
			
		}
		catch(Exception e) {
			system.debug('###Exception : while update CPA Status' + e);
		}
			
	  
	}
	
	
	@AuraEnabled
	public static CH_Corrective_Preventive_Action__c transferCPAFieldsQuery(string recordId) {
		CH_Corrective_Preventive_Action__c CPA = [select CH_Rejection_Cause__c,CH_Free_text_box__c,OwnerId from CH_Corrective_Preventive_Action__c where id=: recordId];
		system.debug('CPA Value Fetched');
		 
		return CPA;
	}
}