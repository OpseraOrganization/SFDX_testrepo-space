public without sharing class DM_PermissionSetAssignment extends DM_WS_SObject {
	private static DM_PermissionSetAssignment classInstance;

	static {
		classInstance = new DM_PermissionSetAssignment();
	}

	private DM_PermissionSetAssignment() {
	}

	/**
	* @description Method provide instance of the object.
	* @return DM_PermissionSetAssignment Instance of the object.
	*/
	public static DM_PermissionSetAssignment getInstance() {
		return classInstance;
	}

	/**
	* @description : method to get the all PermissionSetAssignments
	* @return : List<PermissionSetAssignment>
	*/
	public List<PermissionSetAssignment> getAllPermissionSetAssignments(Set<Id> getAllPermissionSetAssignments){
		return [SELECT
					Id,
					PermissionSetId,
					AssigneeId
				FROM
					PermissionSetAssignment
				WHERE 
					PermissionSetId in :getAllPermissionSetAssignments
		];
	}
}