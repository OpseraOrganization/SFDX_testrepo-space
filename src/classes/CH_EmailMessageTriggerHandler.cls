/****************************************
* Class Name : EmailMessageTriggerHandler
* Created Date: 22 Nov 2018
* Created By : TCS
* Last Modified by: TCS
* Last Modified Date: 
* Description : 
* Test Class:
*****************************************/
public class CH_EmailMessageTriggerHandler {
	/********************
	*Method Name: beforeInsertOperation
	*Parameter: New Case List
	*Description: Used to handle before insert operation
	*******************/
  
	public static void beforeInsertOperation(List<EmailMessage> newCaseList) { 
		
		 CH_EmailMessageTriggerHelper.scramblingLogic(newCaseList);
		
	}
	public static void afterInsertOperation(List<EmailMessage> emailMessageList) { 
		CH_EmailMessageTriggerHelper.cpaCustomerDeliveryUpdate(emailMessageList);
	}
	
}