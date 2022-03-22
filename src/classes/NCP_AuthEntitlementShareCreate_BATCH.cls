/**
 * Created by bkandov on 2019-06-23.
 */

global class NCP_AuthEntitlementShareCreate_BATCH implements Database.Batchable<sObject> {

	global List<NCP_Authorised_Entitlement__Share> authorisedEntitlementShares;

	global NCP_AuthEntitlementShareCreate_BATCH(List<NCP_Authorised_Entitlement__Share> authorisedEntitlementShares) {
		this.authorisedEntitlementShares = authorisedEntitlementShares;
	}

	global List<sObject> start(Database.BatchableContext BC) {
		return this.authorisedEntitlementShares;
	}

	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		insert scope;
	}

	global void finish(Database.BatchableContext BC) {
	}

}