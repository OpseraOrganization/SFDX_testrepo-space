/**
 * Created by bkandov on 10/12/2018.
 */
global class AuthorisedEntitlementSCShareBatch implements Database.Batchable<sObject> {

	global Map<Id, Set<Id>> usersIdsBySCIds;

	global AuthorisedEntitlementSCShareBatch(Map<Id, Set<Id>> usersIdsBySCIds) {
		this.usersIdsBySCIds = usersIdsBySCIds;
	}

	global Database.QueryLocator start(Database.BatchableContext BC) {
		return null;
	}

	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		ServiceContractShareSync.createServiceContractShares(this.usersIdsBySCIds);
	}

	global void finish(Database.BatchableContext BC) {
	}

}