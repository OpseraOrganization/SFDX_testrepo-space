/**
*   @desc : Global Entity Manager for ProcessInstance and ProcessInstanceWorkitem.
*/
public with sharing class EM_ProcessInstance {

	/**
	*   @desc : Do Insert ProcessInstance
	*   @param : ProcessInstance List
	*/
	public static void doInsertProcessInstanceList(List<ProcessInstance> oCHProcessInstanceList) {
		DM_ProcessInstance.getInstance().doInsert(oCHProcessInstanceList, false);
	}

	/**
	*   @desc : Do Update ProcessInstance
	*   @param : ProcessInstance List
	*/
	public static void doUpdateProcessInstanceList(List<ProcessInstance> oCHProcessInstanceList) {
		DM_ProcessInstance.getInstance().doUpdate(oCHProcessInstanceList, false);
	}

	/**
	*   @desc : Do Delete ProcessInstance
	*   @param : ProcessInstance List
	*/
	public static void doDeleteProcessInstanceList(List<ProcessInstance> oCHProcessInstanceList) {
		DM_ProcessInstance.getInstance().doDelete(oCHProcessInstanceList, false);
	}
	
	/**
	* @description : Method to get the ProcessInstance based on TargetObjectId
	* @param : Set<Id>
	* @return : List<ProcessInstance>
	*/
	public static List<ProcessInstance> getProcessInstanceByTargetObjectId(Set<Id> targetObjectId) {
		return DM_ProcessInstance.getInstance().getProcessInstanceByTargetObjectId(targetObjectId);
	}
	
	/**
	*   @desc : Do Insert ProcessInstanceWorkitem
	*   @param : ProcessInstanceWorkitem List
	*/
	public static void doInsertProcessInstanceWorkitemList(List<ProcessInstanceWorkitem> oCHProcessInstanceWorkitemList) {
		DM_ProcessInstance.getInstance().doInsert(oCHProcessInstanceWorkitemList, false);
	}

	/**
	*   @desc : Do Update ProcessInstanceWorkitem
	*   @param : ProcessInstance List
	*/
	public static void doUpdateProcessInstanceWorkitemList(List<ProcessInstanceWorkitem> oCHProcessInstanceWorkitemList) {
		DM_ProcessInstance.getInstance().doUpdate(oCHProcessInstanceWorkitemList, false);
	}

	/**
	*   @desc : Do Delete ProcessInstanceWorkitem
	*   @param : ProcessInstance List
	*/
	public static void doDeleteProcessInstanceWorkitemList(List<ProcessInstanceWorkitem> oCHProcessInstanceWorkitemList) {
		DM_ProcessInstance.getInstance().doDelete(oCHProcessInstanceWorkitemList, false);
	}
	
	/**
	* @description : Method to get the ProcessInstanceWorkitem based on ProcessInstanceId
	* @param : Set<Id>
	* @return : List<ProcessInstanceWorkitem>
	*/
	public static List<ProcessInstanceWorkitem> getProcessInstanceWorkitemByProcessInstanceId(Set<Id> processInstanceId) {
		return DM_ProcessInstance.getInstance().getProcessInstanceWorkitemByProcessInstanceId(processInstanceId);
	}
	
	/**
	* @description : Method to get the ProcessInstanceWorkitem based on ProcessInstance.TargetObjectId
	* @param : Set<Id>
	* @return : List<ProcessInstanceWorkitem>
	*/
	public static List<ProcessInstanceWorkitem> getProcessInstanceWorkitemByTargetObjectId(Set<Id> targetObjectId) {
		return DM_ProcessInstance.getInstance().getProcessInstanceWorkitemByTargetObjectId(targetObjectId);
	}
}