public without sharing class DM_GroupMember extends DM_WS_SObject {
	private static DM_GroupMember classInstance;

	static {
		classInstance = new DM_GroupMember();
	}

	private DM_GroupMember() {
	}

	/**
	* @description Method provide instance of the object.
	* @return DM_GroupMember Instance of the object.
	*/
	public static DM_GroupMember getInstance() {
		return classInstance;
	}

	/**
	* @description : method to get the all GroupMembers
	* @return : List<GroupMember>
	*/
	public List<GroupMember> getAll(){
		return [SELECT
					Id,
					GroupId,
					UserOrGroupId
				FROM
					GroupMember
		];
	}

	/**
	* @description : method to get the all GroupMembers
	* @return : List<GroupMember>
	*/
	public List<GroupMember> getAll(Set<Id> groupMemberIds){
		return [SELECT
					Id,
					GroupId,
					UserOrGroupId
				FROM
					GroupMember
				WHERE
					GroupId in :groupMemberIds
		];
	}
	
	/**
	* @description : method to get the all GroupMembers by group name
	* @return : List<GroupMember>
	*/
	public List<GroupMember> getAllByGroupName(Set<Id> groupMemberIds){
		return [SELECT
					Id,
					GroupId,
					UserOrGroupId
				FROM
					GroupMember
				WHERE
					GroupId in :groupMemberIds
		];
	}
	
	/**
	* @description : method to delete GroupMembers by group ID
	* @return : void
	*/
	public void doDeleteGroupMemberListByGroupID(Set<String> oGroupIdsSet){
		delete [SELECT
					Id,
					GroupId,
					UserOrGroupId
				FROM
					GroupMember
				WHERE
					GroupId in :oGroupIdsSet
		];
	}
	
	/**
	* @description : method to get the all GroupMembers by group ID
	* @return : List<GroupMember>
	*/
	public List<GroupMember> getAllGroupMemberByGroupId(Set<ID> oGroupIdsSet) {
	   return [SELECT
					Id,
					GroupId,
					Group.name,
					UserOrGroupId
				FROM
					GroupMember
				WHERE
					GroupId in :oGroupIdsSet
		];

		
	}
	
	/**
	* @description : method to get the all GroupMembers by group name
	* @return : List<GroupMember>
	*/
	public List<GroupMember> getAllGroupMemberByGroupName(Set<String> groupNameSet) {
	   return [SELECT
					Id,
					GroupId,
					Group.name,
					UserOrGroupId
				FROM
					GroupMember
				WHERE
					group.name in :groupNameSet
		]; 
	}
}