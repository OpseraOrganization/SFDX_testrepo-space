public with sharing class DM_Group extends DM_KB_SObject {
	private static DM_Group classInstance;
	
	static {
		classInstance = new DM_Group();
	}
	
	private DM_Group() {
	}
	
	/**
	* @description Method provide instance of the object.
	* @return DM_Group Instance of the object.
	*/
	public static DM_Group getInstance() {
		return classInstance;
	}
	
	/**
	* @description : method to get the Queues Id based on Queue Name
	* @param : Set<String>
	* @return : List<Group>
	*/
	public List<Group> getQueueIdByDeveloperName(Set<String> oQueueNames){ //getQueueIdByQueueName
		return [SELECT
				Id,
				Name,
				DeveloperName
				FROM
				Group
				WHERE
				DeveloperName in :oQueueNames
			   ];
	}
	
	/**
	* @description : method to get the Queues Id based on Queue Name
	* @param : Set<String>
	* @return : List<Group>
	*/
	public List<Group> getQueueIdByQueueName(Set<String> oQueueNames){
		return [SELECT
				Id,
				Name
				FROM
				Group
				WHERE
				Name in :oQueueNames
			   ];
	}
	
	/**
	* @description : method to get the all Queues
	* @return : List<Group>
	*/
	public List<Group> getAllQueuesByDeveloperName(){ //getAllQueues
		return [SELECT
				Id,
				Name,
				DeveloperName
				FROM
				Group
				WHERE
				DeveloperName like '%_OQ' 
				AND 
				type = 'Queue'
			   ];
	}
	
	/**
	* @description : method to get the all Queues
	* @return : List<Group>
	*/
	public List<Group> getAllQueues(){
		return [SELECT
				Id,
				Name
				FROM
				Group
				WHERE
				(DeveloperName like '%_AQ' OR DeveloperName like '%_PQ' OR DeveloperName like '%_OQ')
				AND
				type = 'Queue'
			   ];
	}
	
	/**
	* @description : method to get the List Views based on Queue Name
	* @return : List<ListView>
	*/
	public List<ListView> getListViewsByQueueName(Set<String> oQueueNames){
		return [SELECT
				Id,
				Name,
				DeveloperName
				FROM
				ListView
				WHERE
				Name in :oQueueNames
			   ];
	}
	
	/**
	* @description : method to get the all KB Queues
	* @return : List<Group>
	*/
	public List<Group> getAllKBQueues(){
		return [SELECT
					Id,
					Name,
					DeveloperName
				FROM
					Group
				WHERE
					(DeveloperName like '%_AQ' OR DeveloperName like '%_PQ')
				AND 
					type = 'Queue'
		];
	}
}