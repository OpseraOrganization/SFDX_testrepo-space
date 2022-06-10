global without sharing class APTS_CustomAgreementLifecycleCallback implements Apttus.CustomClass.IAgreementLifecycleCallback2 {

	global void afterActivate(Apttus__APTS_Agreement__c originalSO, Apttus.CustomClass.ActivationType activationType){
		logMessage('Action after Activate' , 'After Activate');
	}
				
	global void afterAmend(Apttus__APTS_Agreement__c originalSO, Apttus__APTS_Agreement__c amendmentSO){
		if(string.isNotBlank(originalSO.CLM_Reference_Contract_Request__c)){
			Apttus__APTS_Agreement__c rec = [SELECT Id,Apttus__Related_Opportunity__c FROM Apttus__APTS_Agreement__c
											 WHERE ID=:originalSO.CLM_Reference_Contract_Request__c];
			amendmentSO.Apttus__Related_Opportunity__c = rec.Apttus__Related_Opportunity__c;
			amendmentSO.CLM_Related_Contract_Request__c = rec.Id;
		}
	}
	global void afterCancel(Apttus__APTS_Agreement__c agreementSO){
		logMessage('Action after Cancel' , 'After Cancel');
	}
	global void afterClone(Apttus__APTS_Agreement__c originalSO, Apttus__APTS_Agreement__c cloneSO){
		logMessage('Action after Clone' , 'After Clone');
	}
	global void afterComplete(Apttus__APTS_Agreement__c agreementSO, Apttus.CustomClass.ActionType actionType){
	   logMessage('Action after Complete' , ''+actionType);
	}
	global void afterCreate(Apttus__APTS_Agreement__c agreementSO){
		system.debug('====20=====');
		logMessage('Action after Create' , 'After Create====202020202===');
	}
	global void afterCreateChild(Apttus__APTS_Agreement__c parentSO, Apttus__APTS_Agreement__c childSO){
		 logMessage('Action after Create Child ' , 'After Create '+childSo);
	}
	global void afterCreateExecuted(Apttus__APTS_Agreement__c agreementSO){
		logMessage('Action after Executed' , 'After Execute '+agreementSO);
	}
	global void afterCreateFromOpportunity(Apttus__APTS_Agreement__c agreementSO){
		logMessage('Action after Create agreement from Opp' , 'After Create');
	}
	global void afterCreateOffline(Apttus__APTS_Agreement__c agreementSO){ 
			logMessage('Action after Create offline' , 'After Create');
	}
	global void afterExpire(Apttus__APTS_Agreement__c agreementSO){ 
			logMessage('Action after Expire' , 'After Expire');
	} 
	global void afterRenew(Apttus__APTS_Agreement__c originalSO, Apttus__APTS_Agreement__c renewalSO){
			 if(string.isNotBlank(originalSO.CLM_Reference_Contract_Request__c)){
			Apttus__APTS_Agreement__c rec = [SELECT Id,Apttus__Related_Opportunity__c FROM Apttus__APTS_Agreement__c
											 WHERE ID=:originalSO.CLM_Reference_Contract_Request__c];
			renewalSO.Apttus__Related_Opportunity__c = rec.Apttus__Related_Opportunity__c;
			renewalSO.CLM_Related_Contract_Request__c = rec.Id;
		}
   
	}
	global void afterTerminate(Apttus__APTS_Agreement__c agreementSO){ 
			logMessage('Action after Terminate' , 'After Terminate');
	}
	
	private void logMessage(String message , String action){
		System.debug('[LifecycleCallback ('+action+')] :'+message);
	}
}