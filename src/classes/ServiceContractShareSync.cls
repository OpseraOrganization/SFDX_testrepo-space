/**
* Created by bkandov on 06/06/2018.
* It's called from ServiceContractTriggerHelper and usedd in ServiceContractTrigger execution
*/

public with sharing class ServiceContractShareSync {

	private static final String RAW_CAUSE_OWNER = 'Owner';
	private static final String RAW_CAUSE_MANUAL = 'Manual';
	private static final String ACCESS_LEVEL_READ = 'Read';

	public static ServiceContractShare createNewInstance(Id recordId, Id userOrGroupId, String accessLevel) {
		// Create new sharing object for the custom object Service Contract.
		ServiceContractShare serviceContractShare = new ServiceContractShare();

		// Set the ID of record being shared.
		serviceContractShare.ParentId = recordId;

		// Set the ID of user or group being granted access.
		serviceContractShare.UserOrGroupId = userOrGroupId;

		// Set the access level.
		serviceContractShare.AccessLevel = accessLevel;

		return serviceContractShare;
	}

	public static void createServiceContractShares(Map<Id, Set<Id>> userIdsBySCIds) {

		System.debug('inside createServiceContractShares :: ' + userIdsBySCIds);

		List<ServiceContractShare> serviceContractShares = new List<ServiceContractShare>();
		for (Id SCId : userIdsBySCIds.keySet()) {
			for (Id userId : userIdsBySCIds.get(SCId)) {
				ServiceContractShare scShare = ServiceContractShareSync.createNewInstance(SCId, userId, ACCESS_LEVEL_READ);
				serviceContractShares.add(scShare);
			}
		}
		
			if(!serviceContractShares.isEmpty()){
				Database.executeBatch(new NCP_ServiceContractShareCreate_Batch(serviceContractShares));
			}
	}
   
}