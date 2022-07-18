/**
 * Created by bkandov on 10/06/2018.
 * Modified By: HCL Technologies
 * Modified Date: 9 February 2021
 * History: Commenting unused methods 
 */

public without sharing class AuthorisedEntitlementShareSync {

	private static final String ACCESS_LEVEL_READ = 'Read';
   /*********************************************************************************************
	* Name: createNewInstance
	* Param: record Id, User or group Id, string
	* Return: NCP_Authorised_Entitlement__Share
	* Description:  method called from  createAuthorisedEntitlementShares
	**********************************************************************************************/
	public static NCP_Authorised_Entitlement__Share createNewInstance(Id recordId, Id userOrGroupId, String accessLevel) {
		// Create new sharing object for the custom object Service Contract.
		NCP_Authorised_Entitlement__Share aeShare = new NCP_Authorised_Entitlement__Share();

		// Set the ID of record being shared.
		aeShare.ParentId = recordId;

		// Set the ID of user or group being granted access.
		aeShare.UserOrGroupId = userOrGroupId;

		// Set the access level.
		aeShare.AccessLevel = accessLevel;

		aeShare.RowCause = Schema.NCP_Authorised_Entitlement__Share.RowCause.NCP_Custom_Authorised_Entitlement_Share__c;

		return aeShare;
	}
	
   /*********************************************************************************************
	* Name: createAuthorisedEntitlementShares
	* Param: Map, set
	* Return: void
	* Description:  method called from  AccountContactRelationTriggerHelper
	**********************************************************************************************/
	public static void createAuthorisedEntitlementShares(Map<Id, Set<Id>> userIdsByAEIds) {

		List<NCP_Authorised_Entitlement__Share> aeShares = new List<NCP_Authorised_Entitlement__Share>();
		for (Id aEId : userIdsByAEIds.keySet()) {
			for (Id userId : userIdsByAEIds.get(aEId)) {

	NCP_Authorised_Entitlement__Share aeShare = AuthorisedEntitlementShareSync.createNewInstance(aEId, userId, ACCESS_LEVEL_READ);
	aeShares.add(aeShare);
			}
		}

		if (aeShares.size() > 0) {
			List<NCP_Authorised_Entitlement__Share> aeSharesToInsert = new List<NCP_Authorised_Entitlement__Share>();
			Integer count = 0;
			for (NCP_Authorised_Entitlement__Share aeShare : aeShares) {
	aeSharesToInsert.add(aeShare);
	count++;

	if (count == 1000) {
		count = 0;
		// create batch
		System.debug('batch run NCP_AuthEntitlementShareCreate_BATCH :: ' + aeSharesToInsert);
		Database.executeBatch(new NCP_AuthEntitlementShareCreate_BATCH(aeSharesToInsert));
		aeSharesToInsert = new List<NCP_Authorised_Entitlement__Share>();
	}
			}

			if (count > 0) {
	//create batch
	System.debug('batch run NCP_AuthEntitlementShareCreate_BATCH :: ' + aeSharesToInsert);
	Database.executeBatch(new NCP_AuthEntitlementShareCreate_BATCH(aeSharesToInsert));
			}
		}

	}
	
/* //Start of unused method comment

	public static void deleteAuthorisedEntitlementShares(Set<Id> aeIdsToDelete) {

		String rawValueString = Schema.NCP_Authorised_Entitlement__Share.RowCause.NCP_Custom_Authorised_Entitlement_Share__c;

		List<NCP_Authorised_Entitlement__Share> aeSharesToDelete = [
	SELECT Id,ParentId,UserOrGroupId,AccessLevel,RowCause
	FROM NCP_Authorised_Entitlement__Share
	WHERE ParentId IN:aeIdsToDelete AND RowCause = :rawValueString
		];

		if (aeSharesToDelete.size() > 0) {
			delete aeSharesToDelete;
		}
	}

	public static void deleteAESharesByUsers(Map<Id, Set<Id>> userIdsByAEIds) {

		String rawValueString = Schema.NCP_Authorised_Entitlement__Share.RowCause.NCP_Custom_Authorised_Entitlement_Share__c;

		List<NCP_Authorised_Entitlement__Share> aeShares = [
	SELECT Id,ParentId,UserOrGroupId,AccessLevel,RowCause
	FROM NCP_Authorised_Entitlement__Share
	WHERE ParentId IN:userIdsByAEIds.keySet() AND RowCause = :rawValueString
		];

		List<NCP_Authorised_Entitlement__Share> aeSharesToDelete = new List<NCP_Authorised_Entitlement__Share>();
		for (NCP_Authorised_Entitlement__Share aeShare : aeShares) {

			String aeId = aeShare.ParentId;
			String userId = aeShare.UserOrGroupId;
			if (userIdsByAEIds.get(aeId).contains(userId)) {
	aeSharesToDelete.add(aeShare);
			}
		}

		if (aeSharesToDelete.size() > 0) {
			delete aeSharesToDelete;
		}
	}
	 End of Unused methods comment */

}