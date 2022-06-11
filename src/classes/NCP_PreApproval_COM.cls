public without sharing class NCP_PreApproval_COM {
	
	@AuraEnabled
	public static string getNAMResponse(ID oppId){
		// should prolly use a try/catch here
		string x = System.enqueueJob(new NCP_NAMQueueable(oppId));
		/*Boolean jobDone = false;
		AsyncApexJob jobInfo = [SELECT Status, NumberOfErrors FROM AsyncApexJob WHERE Id=:queuedItem];
		System.debug('Queued item = ' + queuedItem);
		System.debug('jobInfo = ' + jobInfo);
		System.debug('jobInfo-Status = ' + jobInfo.Status);
		while (jobDone == false) {
			jobInfo = [SELECT Status, NumberOfErrors FROM AsyncApexJob WHERE Id=:queuedItem];
			System.debug('jobInfo-Status = ' + jobInfo.Status);
			if (jobInfo.Status == 'Completed') {
				System.debug('jobInfo-Status = ' + jobInfo.Status);
				jobDone = true;
			}
		}
		return jobInfo.Status;*/
		System.debug('### AES x '+x);
		return x;
	}

	@AuraEnabled
	public static AsyncApexJob pollAsyncJob(string jobId){
		System.debug('Dom:jobId = ' + jobId);
		AsyncApexJob jobInfo = [SELECT Status, NumberOfErrors FROM AsyncApexJob WHERE Id=:jobId];
		System.debug('jobInfo-Status = ' + jobInfo.Status);
		System.debug('jobInfo-ErrorCount = ' + jobInfo.NumberOfErrors);
		return jobInfo;
	}
	
	@AuraEnabled
	public static String updateCaseStatus(Id caseId) {
		List<Case> caseLst = [SELECT Id, Status, NCP_Contract_Type__c FROM Case WHERE Id = :caseId];
		if(caseLst!=null && caseLst.size() > 0) {
			
			caseLst[0].NCP_NAM_Entitlement_Requested__c='SUCCESS';
			if(caseLst[0].NCP_Contract_Type__c == 'CARES'){
				caseLst[0].Status = 'Approved';
			}
			update caseLst[0];
			
			return 'Success';
		}
		return 'Error';
	}


}