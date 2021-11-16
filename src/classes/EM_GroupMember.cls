/**
*   @desc : Global Entity Manager for GroupMember.
*/
public with sharing class EM_GroupMember {
	/**
	*   @desc : Do Insert GroupMember
	*   @param : GroupMember List
	*/
	public static List<DMLOperationResult_DTO> doInsertGroupMemberList(List<GroupMember> oGroupMemberList) {
		return DM_GroupMember.getInstance().doInsert(oGroupMemberList, false);
	}

	/**
	*   @desc : Do Update GroupMember
	*   @param : GroupMember List
	*/
	public static void doUpdateGroupMemberList(List<GroupMember> oGroupMemberList) {
		DM_GroupMember.getInstance().doUpdate(oGroupMemberList, false);
	}

	/**
	*   @desc : Do Upsert GroupMember
	*   @param : GroupMember List
	*/
	public static void doUpsertGroupMemberList(List<GroupMember> oGroupMemberList){
		DM_GroupMember.getInstance().doUpsert(oGroupMemberList, false, Schema.GroupMember.getSObjectType());
	}

	/**
	*   @desc : Do Delete GroupMember
	*   @param : GroupMember List
	*/
	public static void doDeleteGroupMemberList(List<GroupMember> oGroupMemberList) {
		DM_GroupMember.getInstance().doDelete(oGroupMemberList, false);
	}
	
	/**
	*   @desc : Do Delete GroupMember by Group ID
	*   @param : GroupMember List
	*/
	public static void doDeleteGroupMemberListByGroupID(Set<String> oGroupIdsSet) {
		DM_GroupMember.getInstance().doDeleteGroupMemberListByGroupID(oGroupIdsSet);
	}

	/**
	* @description : method to get the all GroupMembers
	* @return : List<GroupMember>
	*/
	public static List<GroupMember> getAll() {
		return DM_GroupMember.getInstance().getAll();
	}

	/**
	* @description : method to get the all GroupMembers
	* @return : List<GroupMember>
	*/
	public static List<GroupMember> getAll(Set<Id> groupMemberIds) {
		return DM_GroupMember.getInstance().getAll(groupMemberIds);
	}
	
	/**
	* @description : method to get the all GroupMembers by groupID
	* @return : List<GroupMember>
	*/
	public static List<GroupMember> getAllGroupMemberByGroupId(Set<Id> groupIds) {
		return DM_GroupMember.getInstance().getAllGroupMemberByGroupId(groupIds);
	}
	
	/**
	* @description : method to get the all GroupMembers by group name
	* @return : List<GroupMember>
	*/
	public static List<GroupMember> getAllGroupMemberByGroupName(Set<String> groupNameSet) {
		return DM_GroupMember.getInstance().getAllGroupMemberByGroupName(groupNameSet);
	}
	
}