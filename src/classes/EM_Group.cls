/**
*   @desc : Global Entity Manager for Group.
*/
public with sharing class EM_Group {
	/**
	*   @desc : Do Insert Group
	*   @param : Group List
	*/
	public static void doInsertGroupList(List<Group> oGroupList) {
		DM_Group.getInstance().doInsert(oGroupList, false);
	}

	/**
	*   @desc : Do Update Group
	*   @param : Group List
	*/
	public static void doUpdateGroupList(List<Group> oGroupList) {
		DM_Group.getInstance().doUpdate(oGroupList, false);
	}

	/**
	*   @desc : Do Upsert Group
	*   @param : Group List
	*/
	public static void doUpsertGroupList(List<Group> oGroupList){
		DM_Group.getInstance().doUpsert(oGroupList, false, Schema.Group.getSObjectType());
	}

	/**
	*   @desc : Do Delete Group
	*   @param : Group List
	*/
	public static void doDeleteGroupList(List<Group> oGroupList) {
		DM_Group.getInstance().doDelete(oGroupList, false);
	}

	/**
	*   @desc : Do Insert QueuesObject
	*   @param : QueuesObject List
	*/
	public static void doInsertQueuesObjectList(List<QueuesObject> oQueuesObjectList) {
		DM_Group.getInstance().doInsert(oQueuesObjectList, false);
	}

	/**
	*   @desc : Do Update QueuesObject
	*   @param : QueuesObject List
	*/
	public static void doUpdateQueuesObjectList(List<QueuesObject> oQueuesObjectList) {
		DM_Group.getInstance().doUpdate(oQueuesObjectList, false);
	}

	/**
	*   @desc : Do Delete QueuesObject
	*   @param : QueuesObject List
	*/
	public static void doDeleteQueuesObjectList(List<QueuesObject> oQueuesObjectList) {
		DM_Group.getInstance().doDelete(oQueuesObjectList, false);
	}

	/**
	*   @desc : Do Delete ListView
	*   @param : ListView List
	*/
	public static void doDeleteListViewList(List<ListView> oListViewList) {
		DM_Group.getInstance().doDelete(oListViewList, false);
	}
	
	/**
	* @description : method to get the Queues Id based on Queue Name
	* @param : Set<String>
	* @return : List<Group>
	*/
	public static List<Group> getQueueIdByDeveloperName(Set<String> oQueueNames) {
		return DM_Group.getInstance().getQueueIdByDeveloperName(oQueueNames);
	}

	/**
	* @description : method to get the Queues Id based on Queue Name
	* @param : Set<String>
	* @return : List<Group>
	*/
	public static List<Group> getQueueIdByQueueName(Set<String> oQueueNames) {
		return DM_Group.getInstance().getQueueIdByQueueName(oQueueNames);
	}

	/**
	* @description : method to get the all Queues by developer name
	* @return : List<Group>
	*/
	public static List<Group> getAllQueuesByDeveloperName() {
		return DM_Group.getInstance().getAllQueuesByDeveloperName();
	}
	
	/**
	* @description : method to get the all Queues
	* @return : List<Group>
	*/
	public static List<Group> getAllQueues() {
		return DM_Group.getInstance().getAllQueues();
	}

	/**
	* @description : method to get the List Views based on Queue Name
	* @param : Set<String>
	* @return : List<ListView>
	*/
	public static List<ListView> getListViewsByQueueName(Set<String> oQueueNames) {
		return DM_Group.getInstance().getListViewsByQueueName(oQueueNames);
	}
	
	/**
	* @description : method to get the all KB Queues
	* @return : List<Group>
	*/
	public static List<Group> getAllKBQueues() {
		return DM_Group.getInstance().getAllKBQueues();
	}
}