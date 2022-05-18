/** 
 * About 
 * ----- 
 * @Description : DML_SObject_Batch - Data Manager Batch to retry DML operations.
 * @testClass	: DML_SObject_Test.
 * @project		: All. 
 * @changeLog 	: 
 *  Created  : 2021 05 31 – tiago.almeida@nokia.com
 * ----- 
**/
public with sharing class DML_SObject_Batch implements Database.Batchable<sObject>, Database.Stateful {
	private static Integer RETRY_ATTEMPTS = (Integer) DML_Controller__c.getInstance().DML_RetryAttempts__c;
	//
	private List<SObject> failedSObjects;
	private DML_SObject_Helper.DatabaseOperation operationType;
	private Boolean allMustSucceed;
	private Boolean withoutSharing;
	private Integer currentAttempt;
	private Exception failedOperation = null;
	
	public DML_SObject_Batch(List<SObject> failedSObjects, DML_SObject_Helper.DatabaseOperation operationType, Boolean withoutSharing) {
		this.failedSObjects = failedSObjects;
		this.operationType = operationType;
		this.allMustSucceed = allMustSucceed;
		this.withoutSharing = withoutSharing;
		this.currentAttempt = 0;
	}
	
	public DML_SObject_Batch(List<SObject> failedSObjects, DML_SObject_Helper.DatabaseOperation operationType, Boolean withoutSharing, Integer currentAttempt) {
		this.failedSObjects = failedSObjects;
		this.operationType = operationType;
		this.allMustSucceed = allMustSucceed;
		this.withoutSharing = withoutSharing;
		this.currentAttempt = currentAttempt;
	}
	
	public Iterable<sObject> start(Database.BatchableContext bc) {
		return failedSObjects;		
	}
	
	public void execute(Database.BatchableContext BC, List<sObject> scope) {
		try {
			DML_SObject.doOperation(scope, operationType, true, withoutSharing, false);
		}
		catch(Exception e) { failedOperation = e; }
	}
	
	public void finish(Database.BatchableContext BC) {
		currentAttempt++;
		if(failedOperation != null) {
			System.debug('###DML_SObject_Batch retry ' + failedSObjects.get(0).getSObjectType() + ' ' + DML_SObject_Helper.operationName(operationType) + ':' + failedOperation.getMessage());
			if(currentAttempt <= RETRY_ATTEMPTS) {
	Database.executeBatch(new DML_SObject_Batch(failedSObjects, operationType, withoutSharing, currentAttempt));
			}
			else new DML_CriticalErrorHandler(failedOperation, DML_SObject_Helper.operationName(operationType) + ' and Retry Attempt('+ RETRY_ATTEMPTS +')', failedSObjects);
		}
		else System.debug('###DML_SObject_Batch retry ' + failedSObjects.get(0).getSObjectType() + ' ' + DML_SObject_Helper.operationName(operationType) + ' sucessfull.');
	}
}