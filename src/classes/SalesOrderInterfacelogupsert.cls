/**
* Class Name: Interfacelogupsert
* Created Date: 04/JAN/2021
* Created By: HCL Technologies
* Description: This class is used for logging all inserted/updated records to Interface log asynchronously.
*/

public class SalesOrderInterfacelogupsert implements Database.Batchable<sObject> {

	public List<Interface_Log__c> interfaceLog;

	public SalesOrderInterfacelogupsert(List<Interface_Log__c> interfaceLog) {
		this.interfaceLog = interfaceLog;
	}

	public List<sObject> start(Database.BatchableContext BC) {
		return this.interfaceLog;
	}

	public void execute(Database.BatchableContext BC, List<sObject> scope) {
		insert scope;
	}

	public void finish(Database.BatchableContext BC) {
	}

}