/**
* @description: NF_TaskUpdate is an apex class created to update the Task status.		   
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
global class NF_TaskUpdate implements Database.Batchable<sObject>, Database.Stateful,Schedulable{
	 public static Date todayDate =Date.Today();
	 public	Set<Id> oppIdSet = new Set<Id>();
	 //Integer todayDate =(system.today().daysBetween(Date.valueOf(opprec.Oppty_Completion_Date__c)));
	 public static Integer numOfDays = Integer.valueOf(System.Label.Number_of_Days);
	
	/********************
	 *Method Name:execute 
	 *Parameter:SchedulableContext SC
	 *Description:Execute the bacth 
	 *********************/	  
	 global void execute(SchedulableContext SC){
	  NF_TaskUpdate tskUpdateBatch = new NF_TaskUpdate ();
	  Database.executebatch(tskUpdateBatch,50);
	 }
	
	/********************
	*Method Name:start
	*Parameter:Database.BatchableContext BC
	*Description:Collect the opportunities that are closed 
	*******************/
	global Database.QueryLocator start(Database.BatchableContext BC){
		return Database.getQueryLocator([Select Id,StageName,Days_until_Closing__c,Oppty_Completion_Date__c from Opportunity where StageName =:GlobalConstants.COMPLETED_OPPTY AND Days_until_Closing__c <> Null AND Days_until_Closing__c >=:GlobalConstants.ZERO
											Limit:Limits.getLimitQueryRows()]);												   
	}
  
	/********************
	*Method Name:execute
	*Parameter:BC, List<Opportunity>
	*Description:Updating the Task List 
	*******************/
	global void execute(Database.BatchableContext BC, List<Opportunity> OpttyList){
	 System.debug('@@@@@@@@@@@' +OpttyList);

	 List<Task> taskToUpdateList = new List<Task>();
	 try
	 {
			for(Opportunity oppRec : OpttyList){
				System.debug('#####Inside for'+todayDate.daysBetween(Date.valueOf(opprec.Oppty_Completion_Date__c)));
				System.debug('#####Inside fornum'+numOfDays);
				
				if(opprec.Oppty_Completion_Date__c <> Null && (todayDate.daysBetween(Date.valueOf(opprec.Oppty_Completion_Date__c))) <= numOfDays)
				{
					System.debug('****Inside if');
					oppIdSet.add(oppRec.Id);
				}
			}
			System.debug('oppIdSet#####'+oppIdSet);
			// collecting the Active Task
			if(!oppIdSet.isEmpty())
			{ 
				for(Task taskRec :[SELECT Id,Status,WhatId FROM Task where WhatID=:oppIdSet and Status=:GlobalConstants.Open Limit:Limits.getLimitQueryRows()])
				{
				   // taskRec.status = GlobalConstants.CLOSED_NOT_COMPLETED;
					taskRec.Open_Task_At_Closure__c = GlobalConstants.VALUE_TRUE;
					taskRec.Task_Creation_By_Pass_Check__c = GlobalConstants.VALUE_TRUE;
					taskToUpdateList.add(taskRec);
				}
			}
			system.debug('^^^^^'+taskToUpdateList);
			
			if(taskToUpdateList!= null)
			{
				Database.update(taskToUpdateList,false);  
			}
		   
		   } 
		   
		   catch(Exception ex) {
			String Error = GlobalConstants.GENERIC_EXCEPTION;
			System.debug(Error+' --> '+ex.getLineNumber()+'::'+ex.getCause());
			System.debug(ex.getMessage());
			System.debug(ex.getCause());
		}
	}
	
	/********************
	*Method Name:finish
	*Parameter:BC
	*Description:No Operation here 
	*******************/   
  global void finish(Database.BatchableContext BC){  
  }
}