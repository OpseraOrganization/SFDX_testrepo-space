/**
* @Name: QTO_Utility
* @Author: Raj Kamdar
* @CreateDate: 12/04/2020
* @Description: Utility Helper. 
* @CalledFrom : QTO_AutomaticAssociationHelper
* @LastModifiedBy: Raj Kamdar
* @LastModifiedDate: 12/10/2020
* @ChangeDescription: Added relevant comments.
**/


public class QTO_Utility {

	public Static Map<Id,List<QTO_Customer_Document_Issue_Log__c>> logCDMap = new Map<Id,List<QTO_Customer_Document_Issue_Log__c>>();
	public Static Map<Id,List<Task>> mapTasks = new Map<Id,List<Task>>();
	public Static final String QUEUE_ID = '00G3h000000pd93';

	/**
	* @description : create the log record and add it logMap 
	* @author Akanksha Triveri
	* @param message 
	* @param customerDocumentID 
	* @param customerDocumentItemsID 
	* @param returnCode 
	* @param type 
	**/
	public static void createLogs(String message, ID customerDocumentID, ID customerDocumentItemsID, String returnCode, String type){
		QTO_Customer_Document_Issue_Log__c logs = new QTO_Customer_Document_Issue_Log__c();
		logs.QTO_CustomerDocumentId__c = customerDocumentID;
		logs.QTO_CustomerDocumentItemId__c = customerDocumentItemsID;
		logs.QTO_IssueDetails__c = message;
		logs.QTO_Return_Code__c = returnCode;
		logs.QTO_ErrorType__c  = type;
		if(logCDMap.containsKey(customerDocumentID)){
			List<QTO_Customer_Document_Issue_Log__c> logList =logCDMap.get(customerDocumentID);						
			logList.add(logs);
		}
		else{
			logCDMap.put(customerDocumentID, new List<QTO_Customer_Document_Issue_Log__c>{logs});
		}
		
	}
	
	/**
	* @description : To get the logs created for all customer documents
	* @author Akanksha Triveri
	* @param customerDocList 
	* @return List<QTO_Customer_Document_Issue_Log__c> 
	**/
	public static List<QTO_Customer_Document_Issue_Log__c> getLogs(List<Customer_Document__c> customerDocList){
		 List<QTO_Customer_Document_Issue_Log__c> logList = new List<QTO_Customer_Document_Issue_Log__c>();
		 if(logCDMap != null && logCDMap.size()> 0){
			for(Customer_Document__c cdObj :customerDocList){
				if(logCDMap.containsKey(cdObj.id) && logCDMap.get(cdObj.id).size()>0 ){
					logList.addAll(logCDMap.get(cdObj.id));
				   //2.Customer-Document status needs to be update with Association-Exception or Association Sucessful.
					cdObj.Status__c = QTO_Constants.CD_STATUS_EXCEPTION;
				}
				else{
				   cdObj.Status__c = QTO_Constants.CD_STATUS_SUCESSFUL;  
				}
				
			}
		  }
		return logList;
	}

	/**
	* @description : Create a new task.
	* @author Raj Kamdar
	* @param customerDocumentId 
	* @param description 
	* @param errorCode 
	* @param subject 
	* @param priority 
	* @param dueDate 
	* @param status 
	**/
	public static void createTask(Id customerDocumentId, String description, Decimal errorCode, String subject, String priority, Date dueDate, String status, String investigatingGroup){
		Task newTask = new Task();
		newTask.Description = description + QTO_Constants.TASK_MESSAGE;
		newTask.QTO_Error_Code__c = String.valueOf(errorCode);
		newTask.Subject = subject;
		newTask.WhatId = customerDocumentId;
		if(!Test.isRunningTest()){
			newTask.OwnerId = getQueueId();
		}
		newTask.Priority = priority;
		newTask.Status = status;
		newTask.Investigating_Groups__c = investigatingGroup;
		newTask.ActivityDate = system.today();
		if(!mapTasks.containsKey(customerDocumentId)){
			mapTasks.put(customerDocumentId,new List<Task>());
		}
		mapTasks.get(customerDocumentId).add(newTask);
	}

	/**
	* @description : Fetch All Tasks created.
	* @author Raj Kamdar
	* @param customerDocumentId 
	* @return List<Task> 
	**/
	public static List<Task> fetchTasks(Id customerDocumentId){
		if(mapTasks.containsKey(customerDocumentId)){
			return mapTasks.get(customerDocumentId);
		}
		return new List<Task>();
	}

	/**
	* @description : Fetch Log Metadata.
	* @author Raj Kamdar
	* @param statusCode 
	* @return QTO_Exception_Configuration__mdt 
	**/
	public static QTO_Exception_Configuration__mdt fetchLogMetadata(Integer statusCode){
		QTO_Exception_Configuration__mdt returnMetadata = new QTO_Exception_Configuration__mdt();
		if(statusCode!=null){
			returnMetadata = [select id,QTO_Return_Code__c,QTO_Return_Description__c,QTO_Return_Type__c,QTO_Task_Subject__c,QTO_Tasks_Due_Date__c,QTO_Tasks_Priority__c,QTO_Tasks_Status__c,QTO_Investigating_Group__c from QTO_Exception_Configuration__mdt where QTO_Return_Code__c= :statusCode];
		}
		return returnMetadata;
	}


	/**
	* @description : Fetch queue id.
	* @author Raj Kamdar
	* @return String 
	**/
	private static String getQueueId(){
		User queue = new User();
		queue = [select Id,Name from User where NAME = :QTO_Constants.ASSIGNEE_QUEUE];
		return queue.Id;
	}
	
}