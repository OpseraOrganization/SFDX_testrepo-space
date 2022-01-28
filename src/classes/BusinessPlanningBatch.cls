/****************************************
 * Class Name : BusinessPlanningBatch
 * Created Date: 8 Sept 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 10 July 2018
 * Description : Send Business Planning notifications to all PRM and PSM 
 * Modified By : Anukriti
 * Description : Create Task insted of sending emails
 * Test Class: BusinessPlanningBatchTest
 *****************************************/
global class BusinessPlanningBatch implements Database.Batchable<sObject>, Database.Stateful {
	
	private String notifyType;
	private String subject;
	private String msgBody;
	
	/********************
	*Method Name: BusinessPlanningBatch
	*Parameter: String
	*Description: Constructor
	*******************/
	global BusinessPlanningBatch(String type) {
	   notifyType = type;
	}
	
	/********************
	*Method Name: start
	*Parameter: Database.BatchableContext
	*Description: Start Method of Batch Class
	*******************/
	global Database.QueryLocator start(Database.BatchableContext BC) {
		String query = PRMGlobalConstants.BP_Bacth_Query1 +
					   PRMGlobalConstants.BP_Bacth_Query2;
		List<String> validAccType = System.Label.Business_Plan_Valid_Account.split(PRMGlobalConstants.SemiColon);
		for(String s : validAccType) {
			query += 'Partner_Type__c = \'' + s + '\' OR ';
		}
		query = query.substring(0, query.lastIndexOf(PRMGlobalConstants.OR_STRING));
		query += PRMGlobalConstants.BP_Bacth_Query3;
		
		//String query = 'SELECT Id, Partner_Type__c FROM Account ' +
		//			  'WHERE Active__c = True AND (Partner_Type__c = \'Distributor\' OR Partner_Type__c = \'Value Added Reseller\')';
		return Database.getQueryLocator(query);
	}
	
	/********************
	*Method Name: execute
	*Parameter: Database.BatchableContext BC, List<Account> accountList
	*Description: Execute Method of Batch Class
	*******************/
	global void execute(Database.BatchableContext BC, List<Account> accountList){
		try{
			Set<Id> accountIds = new Set<Id>();
			for(Account a : accountList) {
				accountIds.add(a.Id);
			}
			if(notifyType.contains(PRMGlobalConstants.BPR)) {
				String currentYearStr = String.valueOf(System.Today().year());
				for(Business_plan__c bp : [SELECT Id, Year__c, Account_BP__c FROM Business_plan__c WHERE Year__c =: currentYearStr 
													 AND Account_BP__c IN: accountIds LIMIT : (Limits.getLimitQueryRows() - Limits.getQueryRows())]) {
					accountIds.remove(bp.Account_BP__c);
				}
			}
			List<Account_Member__c> acMemberList = [SELECT Id, Type__c, Account_Role__c, Name__c, Account__c, Email__c 
													FROM Account_Member__c 
													WHERE Account__c IN: accountIds
														AND Is_active_User__c = true 
														AND (Account_Role__c =: PRMGlobalConstants.PARTNER_SALES_MANAGER
															OR Account_Role__c =: PRMGlobalConstants.Partner_Relationship_Manager) 
													LIMIT : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			if(notifyType != null && notifyType.equalsIgnoreCase(PRMGlobalConstants.BPN)) {
				createTasksForBPN(acMemberList);
			}else if(notifyType != null && notifyType.equalsIgnoreCase(PRMGlobalConstants.BPR1)) {
				createTasksForBPR1(acMemberList);
			}else if(notifyType != null && notifyType.equalsIgnoreCase(PRMGlobalConstants.BPR2)) {
				createTasksForBPR2(acMemberList);
			}else {}
		}Catch(Exception e) {
			ExceptionHandler.addException(e,PRMGlobalConstants.BusinessPlanningBatch ,PRMGlobalConstants.Execute);
		}
   }
   
  /********************
   *Method Name: createTasksForBPN
   *Parameter: List<Account_Member__c accountMemberList
   *Description: Create Task for December Reminders
   *******************/
   global void createTasksForBPN(List<Account_Member__c> accountMemberList) {
	   try{
		   List<Task> taskPRM = new List<Task>();
		   Set<Id> psMs = new Set<Id>();
		   for(Account_Member__c am : accountMemberList) {
			   if(am.Account_Role__c.equals(PRMGlobalConstants.Partner_Relationship_Manager)) {
				   Task tsk = new Task();
				   tsk.Subject = PRMGlobalConstants.BPN_PRM_SUBJECT;
				   tsk.WhatId = am.Account__c;
				   tsk.OwnerId = am.Name__c;
				   tsk.Description = PRMGlobalConstants.BPN_PRM_COMMENT;
				   tsk.ActivityDate = Date.newInstance(Date.Today().Year()+1, 02, 28);
				   taskPRM.add(tsk);
			   }else if(am.Account_Role__c.equals(PRMGlobalConstants.PARTNER_SALES_MANAGER)) {
				   psMs.add(am.Name__c);
			   }else {}
		   }
		  for(Id psmId : psMs) {
			   Task tsk  = new Task();
			   tsk.Subject = PRMGlobalConstants.BPN_PSM_SUBJECT;
			   tsk.OwnerId = psmId;
			   tsk.Description = PRMGlobalConstants.BPN_PSM_COMMENT;
			   tsk.ActivityDate = Date.newInstance(Date.Today().Year()+1, 02, 28);
			   taskPRM.add(tsk);
		   }
		   database.insert(taskPRM);
	   }catch(Exception e) {
		   ExceptionHandler.addException(e,PRMGlobalConstants.BusinessPlanningBatch ,PRMGlobalConstants.createTasksForBPN);
	   }
	   
	}
	
	/********************
   *Method Name: createTasksForBPR1
   *Parameter: List<Account_Member__c accountMemberList
   *Description: Create Task for January Reminders
   *******************/
	global void createTasksForBPR1(List<Account_Member__c> accountMemberList) {
		try{
			List<Task> taskPRM = new List<Task>();
			for(Account_Member__c am : accountMemberList) {
				if(am.Account_Role__c.equals(PRMGlobalConstants.Partner_Relationship_Manager)) {
					Task tsk = new Task();
					tsk.Subject = PRMGlobalConstants.BPR1_PRM_SUBJECT;
					tsk.WhatId = am.Account__c;
					tsk.OwnerId = am.Name__c;
					tsk.Description = PRMGlobalConstants.BPR1_PRM_COMMENT;
					tsk.ActivityDate = Date.newInstance(Date.Today().Year(), 02, 28);
					taskPRM.add(tsk);
				} 
			}
			database.insert(taskPRM);
		}catch(Exception e) {
			ExceptionHandler.addException(e,PRMGlobalConstants.BusinessPlanningBatch ,PRMGlobalConstants.createTasksForBPR1);
		}
		
	}
	
	/********************
   *Method Name: createTasksForBPR2
   *Parameter: List<Account_Member__c accountMemberList
   *Description: Create Task for February Reminders
   *******************/
	global void createTasksForBPR2(List<Account_Member__c> accountMemberList) {
		try{
			List<Task> taskPRM = new List<Task>();
			for(Account_Member__c am : accountMemberList) {
			   if(am.Account_Role__c.equals(PRMGlobalConstants.Partner_Relationship_Manager)) {
				   Task tsk = new Task();
				   tsk.Subject = PRMGlobalConstants.BPR2_PRM_SUBJECT;
				   tsk.WhatId = am.Account__c;
				   tsk.OwnerId = am.Name__c;
				   tsk.Description = PRMGlobalConstants.BPR2_PRM_COMMENT;
				   tsk.ActivityDate = Date.Today();
				   taskPRM.add(tsk);
			   }
		   }
		  database.insert(taskPRM);
		}catch(Exception e) {
			ExceptionHandler.addException(e,PRMGlobalConstants.BusinessPlanningBatch ,PRMGlobalConstants.createTasksForBPR2);
		}
	   
	}
   /********************
   *Method Name: finish
   *Parameter: Database.BatchableContext
   *Description: Finish Method of Batch Class
   *******************/
   global void finish(Database.BatchableContext BC) {
	   AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email
						 FROM AsyncApexJob WHERE Id =:BC.getJobId() Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
	   // Send an email to the Apex job's submitter notifying of job completion.
	   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	   String[] toAddresses = new String[] {job.CreatedBy.Email};
	   mail.setToAddresses(toAddresses);
	   mail.setSubject(PRMGlobalConstants.BP_Subject + job.Status);
	   mail.setPlainTextBody(PRMGlobalConstants.BP_body + job.TotalJobItems 
							 + PRMGlobalConstants.BP_batches+ job.NumberOfErrors + PRMGlobalConstants.BP_failures);
	   
	if(!Test.isRunningTest()){
		   Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
	   }	   
   }
  
}