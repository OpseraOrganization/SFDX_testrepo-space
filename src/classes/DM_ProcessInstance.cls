public without sharing class DM_ProcessInstance extends DM_KB_SObject{
	private static DM_ProcessInstance classInstance;

	static {
		classInstance = new DM_ProcessInstance();
	}

	private DM_ProcessInstance() {
	}

	/**
	* @description Method provide instance of the object.
	* @return DM_ProcessInstance Instance of the object.
	*/
	public static DM_ProcessInstance getInstance() {
		return classInstance;
	}

	/**
	* @description : Method to get the ProcessInstance based on TargetObjectId
	* @return : List<ProcessInstance>
	*/
	public List<ProcessInstance> getProcessInstanceByTargetObjectId(Set<Id> targetObjectId){
		return [SELECT
					Id, 
					ProcessDefinitionId, 
					TargetObjectId
				FROM
					ProcessInstance
				WHERE
					TargetObjectId = :targetObjectId
		];
	}
	
	/**
	* @description : Method to get the ProcessInstanceWorkitem based on TargetObjectId
	* @return : List<ProcessInstanceWorkitem>
	*/
	public List<ProcessInstanceWorkitem> getProcessInstanceWorkitemByProcessInstanceId(Set<Id> processInstanceId){
		return [SELECT
					Id, 
					ProcessInstanceId, 
					OriginalActorId, 
					ActorId
				FROM
					ProcessInstanceWorkitem
				WHERE
					ProcessInstanceId = :processInstanceId
		];
	}
	
	/**
	* @description : method to get all the Workgroups
	* @return : List<ProcessInstanceWorkitem>
	*/
	public List<ProcessInstanceWorkitem> getProcessInstanceWorkitemByTargetObjectId(Set<Id> targetObjectId){
		return [SELECT
					Id, 
					ProcessInstanceId, 
					OriginalActorId,
					ProcessInstance.TargetObjectId,
					ActorId
				FROM
					ProcessInstanceWorkitem
				WHERE
					ProcessInstance.TargetObjectId = :targetObjectId
		];
	}
}