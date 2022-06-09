public without sharing class CH_DM_WorkgroupMember extends DM_KB_SObject {
	private static CH_DM_WorkgroupMember classInstance;

	static {
		classInstance = new CH_DM_WorkgroupMember();
	}

	private CH_DM_WorkgroupMember() {
	}

	/**
	* @description Method provide instance of the object.
	* @return CH_DM_WorkgroupMember Instance of the object.
	*/
	public static CH_DM_WorkgroupMember getInstance() {
		return classInstance;
	}

	/**
	* @description : method to get all the Workgroups Members per Workgroup
	* @return : List<CH_Workgroup_Member__c>
	*/
	public List<CH_Workgroup_Member__c> getAllWorkgroupMembersPerUser(Set<Id> userIdSet) {
		return [
				SELECT
					Id,
					RecordTypeId,
					Name,
					CH_User__c,
					CH_Role__c,
					CH_Workgroup__c,
					CH_Owner__c,
					CH_WorkgroupId__c
				FROM
					CH_Workgroup_Member__c
				WHERE
					CH_User__c in : userIdSet
		];
	}
	
	/**
	* @description : method to check if Current User belongs to Workgroup
	* @return : List<CH_Workgroup_Member__c>
	*/
	public List<CH_Workgroup_Member__c> validateIfUserIsAWorkgroupMember(String userIdString, Id workgroupMemberRT) {
		return [
				SELECT
					Id,
					RecordTypeId,
					Name,
					CH_User__c,
					CH_Role__c,
					CH_Workgroup__c,
					CH_Owner__c,
					CH_WorkgroupId__c
				FROM
					CH_Workgroup_Member__c
				WHERE
					CH_User__c = : userIdString
				AND 
					RecordTypeId = : workgroupMemberRT
		];
	}
}