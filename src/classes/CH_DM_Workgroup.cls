public without sharing class CH_DM_Workgroup extends DM_KB_SObject{
	private static CH_DM_Workgroup classInstance;

	static {
		classInstance = new CH_DM_Workgroup();
	}

	private CH_DM_Workgroup() {
	}

	/**
	* @description Method provide instance of the object.
	* @return CH_DM_Workgroup Instance of the object.
	*/
	public static CH_DM_Workgroup getInstance() {
		return classInstance;
	}

	/**
	* @description : method to get all the Workgroups
	* @return : List<CH_Workgroup__c>
	*/
	public List<CH_Workgroup__c> getAllWorkgroups(Id workgroupRTId){
		return [SELECT
					Id,
					RecordTypeId,
					Name
				FROM
					CH_Workgroup__c
				WHERE
					RecordTypeId = :workgroupRTId
		];
	}

	/**
	* @description : method to get the Workgroups based on Workgroup Name
	* @param : Set<String>
	* @return : List<CH_Workgroup__c>
	*/
	public List<CH_Workgroup__c> getWorkgroupByName(Set<String> oWGNames){
		return [SELECT
					Id,
					RecordTypeId,
					Name
				FROM
					CH_Workgroup__c
				WHERE
					Name in :oWGNames
		];
	}
	
	/**
	* @description : method to get the Workgroups based on Workgroup Name
	* @param : Set<String>
	* @return : List<CH_Workgroup__c>
	*/
	public List<CH_Workgroup__c> getWorkgroupById(Set<Id> oWGId){
		return [SELECT
					Id,
					RecordTypeId,
					Name,
					OwnerId 
				FROM
					CH_Workgroup__c
				WHERE
					Id in :oWGId
		];
	}
	
	/**
	* @description : method to get the Workgroups Share
	* @param : Set<Id>
	* @return : List<CH_Workgroup__Share>
	*/
	public List<CH_Workgroup__Share> getAllWorkgroupShares(Set<Id> workgroupIdSet){
		return [SELECT
					Id, 
					ParentId, 
					UserOrGroupId
				FROM
					CH_Workgroup__Share
				WHERE
					ParentId in :workgroupIdSet
		];
	}
	
	/**
	* @description : method to get the Workgroups Share by Id
	* @param : Set<Id>
	* @return : List<CH_Workgroup__Share>
	*/
	public List<CH_Workgroup__Share> getAllWorkgroupSharesById(Set<Id> workgroupShareIdSet){
		return [SELECT
					Id
				FROM
					CH_Workgroup__Share
				WHERE
					Id in :workgroupShareIdSet
		];
	}
}