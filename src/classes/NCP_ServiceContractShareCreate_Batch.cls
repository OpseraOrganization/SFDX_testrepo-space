/**
 * Created by bkandov on 2019-06-21.
 */

global class NCP_ServiceContractShareCreate_Batch implements Database.Batchable<sObject> {

	global List<ServiceContractShare> serviceContractShares;

	global NCP_ServiceContractShareCreate_Batch(List<ServiceContractShare> serviceContractShares) {
		this.serviceContractShares = serviceContractShares;
	}

	global List<sObject> start(Database.BatchableContext BC) {
		return this.serviceContractShares;
	}

	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		insert scope;
	}

	global void finish(Database.BatchableContext BC) {
	}

}