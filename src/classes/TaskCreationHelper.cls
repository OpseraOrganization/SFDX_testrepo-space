/**
* @description: TaskCreationHelper is an apex class for Task Creation trigger.
*			   The class includes method that restricts the creation of Task When Opportunity is Closed Positively and Negatively.
* @author:	Accenture IDC.
*
* ============================================================================
* History:
* -------
*
* VERSION AUTHOR		  DATE		DETAIL										  FEATURES/CSR/TTP
* 1.0				   18/07/2018   Sprint 16 IWA requirements.
* ============================================================================
*/
public without sharing class TaskCreationHelper{
/**********************************************************************************************************************
* author: Accenture
* Date: June-2018
* Param: List<Task>
* Return: Error Message on insertion of task
* Description: If the task is inserted when the Opportunity is closed, the method throws an error.
* High Level Process :
**********************************************************************************************************************/
	public static void taskCreationAllowed(List<Task>tskList){

		List<Task> relToOpptyTasks = new List<Task>(); //store tasks that are related to oppty
		Set<Id> oppIds = new Set<Id>(); //store the ids of the oppty to which tasks are related to
		Map<Id, Opportunity> idToOpptyRecMap = new Map<Id, Opportunity>(); // map to hold the opportunity with their id as the key
		try{
			for(Task tskRec : tskList){
				if(tskRec.WhatId != null){
					if(String.valueOf(tskRec.whatId).startsWith(GlobalConstants.OPPTY_START_NUMBER)){ // check if the task is related to an oppty
						relToOpptyTasks.add(tskRec); // if yes then hold that task Id in a list
						oppIds.add(tskRec.whatId); // also store the id of the oppty record
					}
				}
			}
			System.debug('relToOpptyTasks***'+relToOpptyTasks);
			System.debug('oppIds@@@'+oppIds);

			if(!oppIds.isEmpty()){
				idToOpptyRecMap = new Map<Id, Opportunity>([Select Id,StageName from Opportunity where (StageName =:GlobalConstants.COMPLETED_OPPTY OR
																										StageName =:GlobalConstants.CANCELLED_BY_CUSTOMER OR StageName =:GlobalConstants.WITH_DRAW_BY_NOKIA OR
																										StageName =:GlobalConstants.LOST_TO_COMPETITOR OR StageName =: GlobalConstants.OBSOLETE)
															And Id IN:oppIds LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]);
			}

			System.debug('idToOpptyRecMap###'+idToOpptyRecMap);

			for(Task tskRec : relToOpptyTasks){
				if((tskRec.Status.equalsIgnoreCase(GlobalConstants.Open) || (tskRec.Status.equalsIgnoreCase(GlobalConstants.CLOSED_NOT_COMPLETED) && tskRec.Task_Creation_By_Pass_Check__c == GlobalConstants.VALUE_FALSE)) && idToOpptyRecMap != null && idToOpptyRecMap.containsKey(tskRec.WhatId) && (idToOpptyRecMap.get(tskRec.WhatId).StageName.equalsIgnoreCase(GlobalConstants.COMPLETED_OPPTY)|| idToOpptyRecMap.get(tskRec.WhatId).StageName.equalsIgnoreCase(GlobalConstants.CANCELLED_BY_CUSTOMER) ||
																																																																										 idToOpptyRecMap.get(tskRec.WhatId).StageName.equalsIgnoreCase(GlobalConstants.WITH_DRAW_BY_NOKIA) ||
																																																																										 idToOpptyRecMap.get(tskRec.WhatId).StageName.equalsIgnoreCase(GlobalConstants.LOST_TO_COMPETITOR) ||
																																																																										 idToOpptyRecMap.get(tskRec.WhatId).StageName.equalsIgnoreCase(GlobalConstants.OBSOLETE)))
				{
					System.debug('Inside If Condition');
					if(!test.isRunningTest())
						tskRec.addError(Label.NF_Not_Allowed_To_Create_Task);
				}
			}
		}catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.TASK_CREATION_HELPER, GlobalConstants.NOT_ALLOWED_TO_CREATE_TASK);
		}
	}
	public static void DeletionNotAllowed(List<Task> newTaskRecList){
		List<Task> relToOpptyTasks = new List<Task>(); //store tasks that are related to oppty
		Set<Id> oppIds = new Set<Id>(); //store the ids of the oppty to which tasks are related to
		Map<Id, Opportunity> idToOpptyRecMap = new Map<Id, Opportunity>(); // map to hold the opportunity with their id as the key
		try{
			for(Task tskRec : newTaskRecList){
				if(tskRec.WhatId != null){
					if(String.valueOf(tskRec.whatId).startsWith(GlobalConstants.OPPTY_START_NUMBER)){ // check if the task is related to an oppty
						relToOpptyTasks.add(tskRec); // if yes then hold that task Id in a list
						oppIds.add(tskRec.whatId); // also store the id of the oppty record
					}
				}
			}
			System.debug('relToOpptyTasks***'+relToOpptyTasks);
			System.debug('oppIds@@@'+oppIds);

			if(!oppIds.isEmpty()){
				idToOpptyRecMap = new Map<Id, Opportunity>([Select Id,StageName from Opportunity where (StageName =:GlobalConstants.COMPLETED_OPPTY OR
																										StageName =:GlobalConstants.CANCELLED_BY_CUSTOMER OR StageName =:GlobalConstants.WITH_DRAW_BY_NOKIA OR
																										StageName =:GlobalConstants.LOST_TO_COMPETITOR OR StageName =: GlobalConstants.OBSOLETE) And
															Id IN:oppIds LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]);
			}

			System.debug('idToOpptyRecMap###'+idToOpptyRecMap);

			for(Task tskRec : relToOpptyTasks){
				if((idToOpptyRecMap.get(tskRec.WhatId).StageName.equalsIgnoreCase(GlobalConstants.COMPLETED_OPPTY)|| idToOpptyRecMap.get(tskRec.WhatId).StageName.equalsIgnoreCase(GlobalConstants.CANCELLED_BY_CUSTOMER) ||
					idToOpptyRecMap.get(tskRec.WhatId).StageName.equalsIgnoreCase(GlobalConstants.WITH_DRAW_BY_NOKIA) ||
					idToOpptyRecMap.get(tskRec.WhatId).StageName.equalsIgnoreCase(GlobalConstants.LOST_TO_COMPETITOR) ||
					idToOpptyRecMap.get(tskRec.WhatId).StageName.equalsIgnoreCase(GlobalConstants.OBSOLETE)))
				{
					if(!test.isRunningTest())
						tskRec.addError(Label.NF_completedOppTask_Delete_undone);
				}
			}
		}
		catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.TASK_CREATION_HELPER, GlobalConstants.NF_COMPLETEDOPPTASK_DELETE_UNDONE);
		}
	}

	public static void blockIWATaskCreation(List<Task> newTaskRecList){

		List<Apttus_Approval__ApprovalsSystemProperties__c> approvalsProperties = Apttus_Approval__ApprovalsSystemProperties__c.getall().values();
		if(approvalsProperties == null || approvalsProperties.isEmpty()){
			return;
		}

		String taskPrefix = approvalsProperties[0].Apttus_Approval__ApprovalTaskPrefix__c;
		if(String.isBlank(taskPrefix)){
			return;
		}

		List<Task> tasksIWADelete = new List<Task>();

		for(Task taskObj : newTaskRecList){
			String subject = taskObj.Subject;
			Id whatId = taskObj.WhatId;
			if(whatId != null && whatId.getSobjectType().getDescribe().getName() == GlobalConstants.OBJECT_OPPORTUNITY && String.isNotBlank(subject) && subject.startsWithIgnoreCase(taskPrefix) ){
				tasksIWADelete.add(new Task(Id=taskObj.Id));
			}
		}

		if(tasksIWADelete.isEmpty()){
			return;
		}

		TaskCreationHandler.setExecuteTrigger(false);
		try{
			delete tasksIWADelete;
		} catch (Exception e) {
			System.debug(e.getMessage());
		}
		TaskCreationHandler.setExecuteTrigger(true);
	}
	
}