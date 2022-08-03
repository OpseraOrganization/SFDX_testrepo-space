/**
*   @desc : Global Entity Manager for CH_Workgroup_Member__c.
*/
public with sharing class CH_EM_WorkgroupMember {
	/**
	*   @desc : Do Insert CH_Workgroup_Member__c
	*   @param : CH_Workgroup_Member__c List
	*/
	public static void doInsertCHWorkgroupMemberList(List<CH_Workgroup_Member__c> oCHWorkgroupMemberList) {
		CH_DM_WorkgroupMember.getInstance().doInsert(oCHWorkgroupMemberList, false);
	}

	/**
	*   @desc : Do Update CH_Workgroup_Member__c
	*   @param : CH_Workgroup_Member__c List
	*/
	public static void doUpdateCHWorkgroupMemberList(List<CH_Workgroup_Member__c> oCHWorkgroupMemberList) {
		CH_DM_WorkgroupMember.getInstance().doUpdate(oCHWorkgroupMemberList, false);
	}

	/**
	*   @desc : Do Delete CH_Workgroup_Member__c
	*   @param : CH_Workgroup_Member__c List
	*/
	public static void doDeleteCHWorkgroupMemberList(List<CH_Workgroup_Member__c> oCHWorkgroupMemberList) {
		CH_DM_WorkgroupMember.getInstance().doDelete(oCHWorkgroupMemberList, false);
	}

	/**
	* @description : method to get the Workgroups based on Workgroup Name
	* @param : Set<String>
	* @return : List<CH_Workgroup_Member__c>
	*/
	public static List<CH_Workgroup_Member__c> getAllWorkgroupMembersPerUser(Set<Id> userIdSet) {
		return CH_DM_WorkgroupMember.getInstance().getAllWorkgroupMembersPerUser(userIdSet);
	}
	
	/**
	* @description : method to check if Current User belongs to Workgroup
	* @return : List<CH_Workgroup_Member__c>
	*/
	public static List<CH_Workgroup_Member__c> validateIfUserIsAWorkgroupMember(String userIdString, Id workgroupMemberRT) {
		return CH_DM_WorkgroupMember.getInstance().validateIfUserIsAWorkgroupMember(userIdString, workgroupMemberRT);
	}
}