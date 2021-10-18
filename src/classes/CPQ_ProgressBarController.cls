/******************************
* Author : Jithin
* Date : Jun - 2021
* Description : The class controls visibility and progress of the progress bar Lightning Component in proposal page
*******************************/
public without sharing class CPQ_ProgressBarController {
   
	
	/***************************
	* Description : The method checks if the component should be shown or not
	* Parameter passed : proposalId
	* return : Boolean
	***************************/ 
	@AuraEnabled
	public static Boolean checkIfValidTransaction(Id proposalId) {
		Boolean isValidTransaction = false;
		try {
			Apttus_Proposal__Proposal__c proposal = [select id, Apttus_Proposal__Approval_Stage__c from Apttus_Proposal__Proposal__c where id = :proposalId];
			if(proposal != null && (String.isBlank(proposal.Apttus_Proposal__Approval_Stage__c) || proposal.Apttus_Proposal__Approval_Stage__c.equalsIgnoreCase('Approved') || proposal.Apttus_Proposal__Approval_Stage__c.equalsIgnoreCase('Draft'))) {
				AsyncApexJob cartFinalizeJob = [select id, CreatedDate from AsyncApexJob where (CreatedById = :UserInfo.getUserId() and ApexClass.Name = 'ActionInvokerWebService') order by CreatedDate desc limit 1];
				if(cartFinalizeJob != null && cartFinalizeJob.CreatedDate > DateTime.now().addMinutes(-5)) {
					isValidTransaction = true;
				}
			}
		} catch(Exception e) {
			System.debug('Exception: CPQ_ProgressBarController.checkIfValidTransaction: ' + e.getStackTraceString());
		}
		return isValidTransaction;
	}

	/***************************
	* Description : The method checks for the status of outstanding async calls
	* Parameter passed : proposalId
	* return : Boolean
	***************************/ 
	@AuraEnabled
	public static Boolean checkJobStatus() {
		Boolean isJobPending = true;
		Datetime cartFinalizeTime = System.now();
		try {
			List<AsyncApexJob> cartFinalizeJobs = [select id, CreatedDate from AsyncApexJob where (CreatedById = :UserInfo.getUserId() and ApexClass.Name = 'ActionInvokerWebService') order by CreatedDate desc limit 1];
			if(Test.isRunningTest() || (cartFinalizeJobs != null && !cartFinalizeJobs.isEmpty())) {
				if(!Test.isRunningTest()) {
					cartFinalizeTime = cartFinalizeJobs[0].CreatedDate;
				}
				List<AsyncApexJob> customJobs;
				if(Test.isRunningTest()) {
					customJobs = [select id, CreatedDate, Status from AsyncApexJob limit 2];
				} else {
					customJobs = [select id, CreatedDate, Status from AsyncApexJob where CreatedById = :UserInfo.getUserId() and ApexClass.Name in ('PostSyncCartQJob') and CreatedDate > :cartFinalizeTime];
				}
				if(customJobs != null && customJobs.size() > 0) {
					Set<String> pendingStatuses = new Set<String>{'Holding','Preparing','Processing','Queued'};
					isJobPending = false;
					for(AsyncApexJob job : customJobs) {
						if(String.isNotBlank(job.Status) && pendingStatuses.contains(job.Status)) {
							isJobPending = true;
							break;
						}
					}
				}
			}
		} catch(Exception e) {
			System.debug('Exception: CPQ_ProgressBarController.checkJobStatus: ' + e.getStackTraceString());
		}
		return isJobPending;
	}

}