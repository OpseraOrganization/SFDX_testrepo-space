/**
 * Created by bkandov on 2019-06-12.
 */

global class NCP_ServiceContractShare_Batch implements Database.Batchable<sObject>, Database.Stateful {

	private static final String RAW_CAUSE_MANUAL = 'Manual';
	private Map<Id, Set<Id>> userIdsByServiceContractIds;
	private String query;
	private Set<Id> serviceContractIds;
	private NCP_ServiceContractShare_Batch.SharingOperation operation;

	global NCP_ServiceContractShare_Batch(Map<Id, Set<Id>> userIdsByServiceContractIds, NCP_ServiceContractShare_Batch.SharingOperation operation) {
		this.userIdsByServiceContractIds = userIdsByServiceContractIds;
		this.operation = operation;
	}

	global NCP_ServiceContractShare_Batch(Set<Id> serviceContractIds) {
		this.serviceContractIds = serviceContractIds;
		this.operation = SharingOperation.SHARING_DELETE_ALL;
	}

	global Database.QueryLocator start(Database.BatchableContext BC) {
		Set<Id> scIds = null;
		String raw_cause = 'Manual';
		if (this.operation == SharingOperation.SHARING_DELETE_ALL) {
			scIds = this.serviceContractIds;
		} else if (this.operation == SharingOperation.SHARING_DELETE) {
			scIds = this.userIdsByServiceContractIds.keySet();
		}
		this.query = 'SELECT Id,ParentId,UserOrGroupId,AccessLevel,RowCause FROM ServiceContractShare WHERE ParentId IN: scIds AND RowCause = :raw_cause';

		return Database.getQueryLocator(this.query);
	}

	global void execute(Database.BatchableContext BC, List<sObject> scope) {

		if (operation == NCP_ServiceContractShare_Batch.SharingOperation.SHARING_DELETE) {
			List<ServiceContractShare> scSharesToDelete = new List<ServiceContractShare>();
			for (ServiceContractShare scShare : (List<ServiceContractShare>) scope) {

				String scId = scShare.ParentId;
				String userId = scShare.UserOrGroupId;
				if (userIdsByServiceContractIds.get(scId).contains(userId)) {
					scSharesToDelete.add(scShare);
				}
			}

			if (scSharesToDelete.size() > 0) {
				delete scSharesToDelete;
			}
		} else if (operation == NCP_ServiceContractShare_Batch.SharingOperation.SHARING_DELETE_ALL) {
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