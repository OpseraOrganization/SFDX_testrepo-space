/**
 * Created by bkandov on 2019-06-23.
 */

global class NCP_AuthEntitlementShareDelete_BATCH implements Database.Batchable<sObject>, Database.Stateful {

	private Map<Id, Set<Id>> userIdsByAuthorisedEntitlementIds;
	private String query;
	private Set<Id> authorisedEntitlementIds;
	private NCP_AuthEntitlementShareDelete_BATCH.SharingOperation operation;

	global NCP_AuthEntitlementShareDelete_BATCH(Map<Id, Set<Id>> userIdsByAuthorisedEntitlementIds, NCP_AuthEntitlementShareDelete_BATCH.SharingOperation operation) {
		this.userIdsByAuthorisedEntitlementIds = userIdsByAuthorisedEntitlementIds;
		this.operation = operation;
	}

	global NCP_AuthEntitlementShareDelete_BATCH(Set<Id> authorisedEntitlementIds) {
		this.authorisedEntitlementIds = authorisedEntitlementIds;
		this.operation = NCP_AuthEntitlementShareDelete_BATCH.SharingOperation.SHARING_DELETE_ALL;
	}

	global Database.QueryLocator start(Database.BatchableContext BC) {
		Set<Id> aeIds = null;

		if (this.operation == NCP_AuthEntitlementShareDelete_BATCH.SharingOperation.SHARING_DELETE_ALL) {
			aeIds = this.authorisedEntitlementIds;
		} else if (this.operation == NCP_AuthEntitlementShareDelete_BATCH.SharingOperation.SHARING_DELETE) {
			aeIds = this.userIdsByAuthorisedEntitlementIds.keySet();
		}

		String raw_cause = Schema.NCP_Authorised_Entitlement__Share.RowCause.NCP_Custom_Authorised_Entitlement_Share__c;
		this.query = 'SELECT Id,ParentId,UserOrGroupId,AccessLevel,RowCause FROM NCP_Authorised_Entitlement__Share WHERE ParentId IN: aeIds AND RowCause = :raw_cause';

		return Database.getQueryLocator(this.query);
	}

	global void execute(Database.BatchableContext BC, List<sObject> scope) {

		if (operation == NCP_AuthEntitlementShareDelete_BATCH.SharingOperation.SHARING_DELETE) {
			List<NCP_Authorised_Entitlement__Share> aeSharesToDelete = new List<NCP_Authorised_Entitlement__Share>();
			for (NCP_Authorised_Entitlement__Share aeShare : (List<NCP_Authorised_Entitlement__Share>) scope) {

				String aeId = aeShare.ParentId;
				String userId = aeShare.UserOrGroupId;
				if (this.userIdsByAuthorisedEntitlementIds.get(aeId).contains(userId)) {
					aeSharesToDelete.add(aeShare);
				}
			}

			if (aeSharesToDelete.size() > 0) {
				delete aeSharesToDelete;
			}
		} else if (operation == NCP_AuthEntitlementShareDelete_BATCH.SharingOperation.SHARING_DELETE_ALL) {
			delete scope;
		}
	}

	global void finish(Database.BatchableContext BC) {
	}

	global enum SharingOperation {
		SHARING_CREATE,
		SHARING_DELETE,
		SHARING_DELETE_ALL
	}

}