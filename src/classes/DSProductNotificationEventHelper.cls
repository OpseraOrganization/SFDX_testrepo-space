/****************************************
* Class Name : DSProductNotificationEventHelper
* Created Date: April 2019
* Created By : Accenture
* Last Modified by: Accenture
* Last Modified Date: 
* Description : Helper for DSProductNotificationEvent trigger
* Test Class: 
*****************************************/
public without sharing class DSProductNotificationEventHelper {
	
	/********************
	*Method Name: afterInsertOperation
	*Parameter: newContractList, Old Accreditation Map
	*Description: Used to handle after Update activities
	*******************/
	public static void afterInsertOperation(DS_Products_Notification__e DSProductNotificationEvent) {								 
		try{	  
					
			List<Account> accList = [Select Id from Account where AccountNumber = : DSProductNotificationEvent.SoldToParty__c];
			if(accList.isEmpty()) {
			   Interface_Log__c objInterfaceLog = new Interface_Log__c();
			   objInterfaceLog.Comment__c =Label.DS_Invalid_Sold_To_Party_Message_1+CSWXGlobalConstant.space+DSProductNotificationEvent.SoldToParty__c+CSWXGlobalConstant.space+ Label.DS_Invalid_Sold_To_Party_Message_2 ;
			   objInterfaceLog.Interface_Type__c=Label.DS_Interface_Type_Value;
			   objInterfaceLog.Status__c=Label.DS_Status_Value;
			   objInterfaceLog.Message_Type__c=Label.DS_Message_Type;
			   insert objInterfaceLog;
			}
			else {
				Map<String, Object> params = new Map<String, Object>();
				params.put('SoldToAccountNumber', DSProductNotificationEvent.SoldToParty__c);
				params.put('ProductCode', DSProductNotificationEvent.Productcode__c);
				Flow.Interview.DS_notify_Customer_on_product_avalability sendNotification = new Flow.Interview.DS_notify_Customer_on_product_avalability(params);
				sendNotification.start();
			}
				
		}
		catch(System.Exception e){ExceptionHandler.addException(e, 'DSProductNotificationEventHelper' , 'DSProductNotificationEventHelper');}
	}  
	
}