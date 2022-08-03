/*********************************************
* Class Name: CQ_CustomerContactTriggerHelper
* Created by: Accenture
* Created Date: 5th Apr 2019
* Last modified by: Accenture
* Description: This class will handle the logic implemented on CQ_CustomerContactTrigger
* ******************************************/
public class CQ_CustomerContactTriggerHelper {
  
  private static boolean isupdateRun = false;
  /*****************************
*Method Name: setPrimaryContact
*Description: Contains the logic to mark the first contact added to the quote as primary by default
*Parameters: contactList 
*******************************/
  public static void setPrimaryContact(List<CQ_Customer_Contact__c> contactList){
	Set<Id> QuoteIdSet = new Set<Id>();
	List<CQ_Customer_Contact__c> custconList = new List<CQ_Customer_Contact__c>();
	List<CQ_Customer_Contact__c> primaryCustconList = new List<CQ_Customer_Contact__c>();
	
	
	for(CQ_Customer_Contact__c custContact : contactList){
	  if(!custContact.CQ_isCloned__c)
		QuoteIdSet.add(custContact.CQ_CQ_Name__c);	   
	}
	
	system.debug('contactList--->'+contactList);
	if(!QuoteIdSet.isEmpty())
	  custconList = [select id, CQ_Is_Primary__c from CQ_Customer_Contact__c where CQ_CQ_Name__c IN: QuoteIdSet];
	//primaryCustconList = [select id, CQ_Is_Primary__c from CQ_Customer_Contact__c where CQ_CQ_Name__c IN: QuoteIdSet and CQ_Is_Primary__c=true];
	
	
	system.debug('custconList--->'+custconList);
	system.debug('primaryCustconList--->'+primaryCustconList); 
	
	if(!custconList.isEmpty()){
	  system.debug('inside if--->');
	   List<CQ_Customer_Contact__c> custContactAll2 = new List<CQ_Customer_Contact__c>();
	  for(CQ_Customer_Contact__c custContact : contactList){
		
		system.debug('custContact--->'+custContact);		   
		for(CQ_Customer_Contact__c custContactAll : custconList){
		  
		  system.debug('custContactAll--->'+custContactAll);
		  if(custContact.CQ_Is_Primary__c){
			if(custContactAll.CQ_Is_Primary__c && custContact.Id != custContactAll.Id){
			  custContactAll.CQ_Is_Primary__c = false;
			  isupdateRun = true;
			  custContactAll2.add(custContactAll);
			  //update custContactAll;
			}
		  }		  
		}
		
	  }
	  update custContactAll2;
	}else{
	  system.debug('inside else--->');
	  for(CQ_Customer_Contact__c custContact : contactList){
		if(!custContact.CQ_isCloned__c)
		custContact.CQ_Is_Primary__c = true;   
	  }
	}  
	
  }
  /*****************************
*Method Name: checkPrimary
*Description: Contains the logic to throw error message if there is no Primary
*Parameters: contactList, oldcontactMap
*******************************/
  public static void checkPrimary(List<CQ_Customer_Contact__c> contactList, Map<id, CQ_Customer_Contact__c> oldcontactMap){
	for(CQ_Customer_Contact__c custContact : contactList){
	  if(!isupdateRun && !custContact.CQ_isCloned__c)
		custContact.addError('One customer contact needs to be primary');   
	}  
  }
  /*****************************
*Method Name: restrictDeleteOnPrimary
*Description: Contains the logic to throw error message if Primary customer contact is deleted
*Parameters: contactList
*******************************/
  public static void restrictDeleteOnPrimary(List<CQ_Customer_Contact__c> contactList){
	for(CQ_Customer_Contact__c custContact : contactList){
	  custContact.addError('One customer contact needs to be primary');   
	}  
  }
}