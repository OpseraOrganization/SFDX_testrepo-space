/*********************************************
 * Class Name: CQ_CustomerContactTriggerHandler
 * Created by: Accenture
 * Created Date: 5th Apr 2019
 * Last modified by: Accenture
 * Description: This class will handle the logic implemented on CQ_CustomerContactTrigger
 * ******************************************/
public without sharing class CQ_CustomerContactTriggerHandler {
  
/******************************
 *Method Name: setPrimaryContact
 *Description: used to call helper method to mark the first contact added to the quote as primary by default
 *Parameters: contactList 
 *******************************/
	public static void setPrimaryContact(List<CQ_Customer_Contact__c> contactList){
		CQ_CustomerContactTriggerHelper.setPrimaryContact(contactList);
	}
/*****************************
 *Method Name: checkPrimary
 *Description: used to call helper method to throw error message on no primary
 *Parameters: contactList, oldcontactMap
 *******************************/
	  public static void checkPrimary(List<CQ_Customer_Contact__c> contactList, Map<id,CQ_Customer_Contact__c> oldcontactMap){
		  for(CQ_Customer_Contact__c custContact : contactList){
			  if(oldcontactMap.get(custContact.id).CQ_Is_Primary__c == true && custContact.CQ_Is_Primary__c == false){
				CQ_CustomerContactTriggerHelper.checkPrimary(contactList,oldcontactMap);	
			  }
		  }
	}
	/*****************************
 *Method Name: restrictDeleteOnPrimary
 *Description: used to call helper method to throw error message if primary contact is deleted
 *Parameters: contactList
 *******************************/
	  public static void restrictDeleteOnPrimary(List<CQ_Customer_Contact__c> contactList){
		  for(CQ_Customer_Contact__c custContact : contactList){
			  if(custContact.CQ_Is_Primary__c){
				CQ_CustomerContactTriggerHelper.restrictDeleteOnPrimary(contactList);	
			  }
		  }
	}
}