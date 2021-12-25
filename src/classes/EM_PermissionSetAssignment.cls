/**
*   @desc : Global Entity Manager for PermissionSetAssignment.
*/
public with sharing class EM_PermissionSetAssignment {
	/**
	*   @desc : Do Insert PermissionSetAssignment
	*   @param : PermissionSetAssignment List
	*/
	public static void doInsertPermissionSetAssignmentList(List<PermissionSetAssignment> oPermissionSetAssignmentList){
		DM_PermissionSetAssignment.getInstance().doInsert(oPermissionSetAssignmentList, false);
	}

	/**
	*   @desc : Do Update PermissionSetAssignment
	*   @param : PermissionSetAssignment List
	*/
	public static void doUpdatePermissionSetAssignmentList(List<PermissionSetAssignment> oPermissionSetAssignmentList){
		DM_PermissionSetAssignment.getInstance().doUpdate(oPermissionSetAssignmentList, false);
	}

	/**
	*   @desc : Do Delete PermissionSetAssignment
	*   @param : PermissionSetAssignment List
	*/
	public static void doDeletePermissionSetAssignmentList(List<PermissionSetAssignment> oPermissionSetAssignmentList){
		DM_PermissionSetAssignment.getInstance().doDelete(oPermissionSetAssignmentList, false);
	}

	/**
	*   @desc : Do Upsert PermissionSetAssignment
	*   @param : PermissionSetAssignment List
	*/
	public static void doUpsertPermissionSetAssignmentList(List<PermissionSetAssignment> oPermissionSetAssignmentList){
		DM_PermissionSetAssignment.getInstance().doUpsert(oPermissionSetAssignmentList, false, Schema.PermissionSetAssignment.getSObjectType());
	}

	/**
	* @description : method to get the all Queues
	* @return : List<PermissionSetAssignment>
	*/
	public static List<PermissionSetAssignment> getAllPermissionSetAssignments(Set<Id> getAllPermissionSetAssignments) {
		return DM_PermissionSetAssignment.getInstance().getAllPermissionSetAssignments(getAllPermissionSetAssignments);
	}

	/**
	* @description : method to know if User have a certain Permission Set
	* @return : Boolean
	*/
	public static Boolean getPermissionSetAssignmentPerUser(Id permissionSetId, Id userId) {
		return ![SELECT
					Id
				FROM
					PermissionSetAssignment
				WHERE
					PermissionSetId = :permissionSetId
				AND
					AssigneeId = :userId
				].isEmpty();
	}
}