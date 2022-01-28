/**
*   @desc : Global Entity Manager for CH_Workgroup__c.
*/
public with sharing class CH_EM_Workgroup {
	/**
	*   @desc : Do Insert CH_Workgroup
	*   @param : CH_Workgroup List
	*/
	public static void doInsertCHWorkgroupList(List<CH_Workgroup__c> oCHWorkgroupList) {
		CH_DM_Workgroup.getInstance().doInsert(oCHWorkgroupList, false);
	}

	/**
	*   @desc : Do Update CH_Workgroup
	*   @param : CH_Workgroup List
	*/
	public static void doUpdateCHWorkgroupList(List<CH_Workgroup__c> oCHWorkgroupList) {
		CH_DM_Workgroup.getInstance().doUpdate(oCHWorkgroupList, false);
	}

	/**
	*   @desc : Do Delete CH_Workgroup
	*   @param : CH_Workgroup List
	*/
	public static void doDeleteCHWorkgroupList(List<CH_Workgroup__c> oCHWorkgroupList) {
		CH_DM_Workgroup.getInstance().doDelete(oCHWorkgroupList, false);
	}
	
	/**
	*   @desc : Do Delete CH_Workgroup__Share
	*   @param : CH_Workgroup__Share List
	*/
	public static void doDeleteCHWorkgroupShareList(List<CH_Workgroup__Share> oCHWorkgroupShareList) {
		CH_DM_Workgroup.getInstance().doDelete(oCHWorkgroupShareList, false);
	}
	
	/**
	*   @desc : Do Upsert CH_Workgroup__Share
	*   @param : CH_Workgroup__Share List
	*/
	public static void doUpsertCHWorkgroupShareList(List<CH_Workgroup__Share> oCHWorkgroupShareList) {
		CH_DM_Workgroup.getInstance().doUpsert(oCHWorkgroupShareList, false, Schema.CH_Workgroup__Share.getSObjectType());
	}

	/**
	* @description : method to get all the Workgroups
	* @return : List<CH_Workgroup__c>
	*/
	public static List<CH_Workgroup__c> getAllWorkgroups(Id workgroupRTId) {
		return CH_DM_Workgroup.getInstance().getAllWorkgroups(workgroupRTId);
	}
		
	/**
	* @description : method to get the Workgroups based on Workgroup Name
	* @param : Set<String>
	* @return : List<CH_Workgroup__c>
	*/
	public static List<CH_Workgroup__c> getWorkgroupByName(Set<String> oWGNames) {
		return CH_DM_Workgroup.getInstance().getWorkgroupByName(oWGNames);
	}
	
	/**
	* @description : method to get the Workgroups based on Workgroup Name
	* @param : Set<String>
	* @return : List<CH_Workgroup__c>
	*/
	public static List<CH_Workgroup__c> getWorkgroupById(Set<Id> oWGId) {
		return CH_DM_Workgroup.getInstance().getWorkgroupById(oWGId);
	}
	
	/**
	* @description : method to get the Workgroups Share
	* @param : Set<Id>
	* @return : List<CH_Workgroup__Share>
	*/
	public static List<CH_Workgroup__Share> getAllWorkgroupShares(Set<Id> workgroupIdSet) {
		return CH_DM_Workgroup.getInstance().getAllWorkgroupShares(workgroupIdSet);
	}
	
	/**
	* @description : method to get the Workgroups Share by Id
	* @param : Set<Id>
	* @return : List<CH_Workgroup__Share>
	*/
	public static List<CH_Workgroup__Share> getAllWorkgroupSharesById(Set<Id> workgroupShareIdSet) {
		return CH_DM_Workgroup.getInstance().getAllWorkgroupSharesById(workgroupShareIdSet);
	}
}