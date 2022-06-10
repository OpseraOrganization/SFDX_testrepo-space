/****************************************
* Class Name : ContactTriggerHandler
* Created Date: 27 December 2016
* Created By : Accenture
* Last Modified by: Accenture
* Last Modified Date: 27 December 2016
* Description : Handle the sequence of the ContactTriggerHelper
* Test Class: 
*****************************************/
public class ContactTriggerHandler{
	/********************
*Method Name: afterInsertOperation
*Parameter: New Contact List
*Description: Used to handle after Insert activities req#770
1. Check Contact is for VZW Account(301001643) if yes then send it to fALU.
*******************/
	public static void afterInsertOperation(List<Contact> contactList){
		//if(GlobalConstants.executeFALUContactSync){ 
		// ContactTriggerHelper.validateAndSendContact(contactList);
		//GlobalConstants.executeFALUContactSync =false; 
		//}
	} 
	
	/********************
*Method Name: afterUpdateOperation
*Parameter: New Contact List, old Contact Map
*Description: Used to handle after Insert activities req#770
1. Check Contact is for VZW Account(301001643) if yes then send it to fALU.
*******************/
	public static void afterUpdateOperation(List<Contact> contactList,Map<Id,Contact> oldContactMap){
		//if(GlobalConstants.executeFALUContactSync){ 
		//  ContactTriggerHelper.validateAndSendContactforUpdate(contactList,oldContactMap);
		//  GlobalConstants.executeFALUContactSync =false; 
		//}
	} 
	
	/********************
*Method Name: beforeUpdateOperation
*Parameter: New Contact List
*Description: Used to handle before update activities req#770
1. 
*******************/
	public static void beforeUpdateOperation(List<Contact> contactList){
		//ContactTriggerHelper.updateContact(contactList, oldContactMap);
		// validateBlacklistedMailDomains method is commented by Manoj Gahlot (08/08/2018) - Ref NOKIASC-4989
		// ContactTriggerHelper.validateBlacklistedMailDomains( contactList );
	}	
	
	/********************
*Method Name: beforeInsertOperation
*Parameter: New Contact
*Description: Used to handle before insert activities
*******************/
	
	public static void beforeInsertOperation( List<Contact> newContacts ){
		// validateBlacklistedMailDomains method is commented by Manoj Gahlot (08/08/2018) - Ref NOKIASC-4989
		// ContactTriggerHelper.validateBlacklistedMailDomains( newContacts );
		ContactTriggerHelper.BypassDuplicateRuleValidation( newContacts );
		// contactMatchIndustryWithLead added by Zheng Li from SDC, ticket 12448, 20180907
		ContactTriggerHelper.contactMatchIndustryWithLead(newContacts);
		// end of ticket 12448, 20180907
	}
	
	public static void beforeOperation(List<Contact> conList,Map<Id, Contact> oldContactMap){ 
		List<ISO_Country_Codes__c> allCountryCodes =  ISO_Country_Codes__c.getall().values();
		
		ContactTriggerHelper.contactCampaignAutoPopulation(conList,oldContactMap);
		
		List<Contact> contactListoUpdate = new List<Contact> ();
		List<Contact> contactListoUpdatelookup = new List<Contact> ();
		
		for(Contact con : conList){	  
			
			system.debug('countrycode....'+con.mailingcountrycode);
			system.debug('country....'+con.mailingcountry);
			system.debug('stateCode....'+con.mailingstateCode);
			
			if(con.mailingcountry != null || con.mailingcountrycode!=NULL){
				
				if(con.MailingCountry!=null && con.MailingCountryCode==null){
					for(ISO_Country_Codes__c countryCode : allCountryCodes){ 
						if(con.MailingCountry == countryCode.Country_Name__c){
							con.MailingCountryCode = countryCode.name;
							break;
						}
					}
				}
				
				if(con.Market__c == null){
					con.Market__c = ISO_Country_Codes__c.getvalues(con.mailingCountryCode).Market__c;
				}
				else if(con.Market__c  != ISO_Country_Codes__c.getvalues(con.mailingCountryCode).Market__c){
					con.addError(System.Label.Incorrect_Market_Value + ' ' +ISO_Country_Codes__c.getvalues(con.mailingCountryCode).Country_Name__c+ ' ' + System.Label.Is + ' ' + ISO_Country_Codes__c.getvalues(con.mailingCountryCode).Market__c);
				}
				con.country__c= ISO_Country_Codes__c.getvalues(con.mailingcountrycode).country_name__c;
				//con.Country_Code__c = con.mailingcountrycode;
				if(con.mailingState != null)
					con.State__c = con.mailingState;
			}
			
		}
	}
	
	/********************
*Method Name: afterInsertOperation
*Parameter: Lead List
*Description: Used to handle after update activities
**************1. 
**************2. 
*******************/
	public static void afterInsertOperation(List<Contact> contactList,Map<id, Contact> OldContactMap){  
		system.debug('new list......');
		system.debug('oldMap.....');
		system.debug('contactListoUpdatelookup .....'+ContactTriggerHelper.contactListoUpdatelookup);
		system.debug('campaignIdList.........'+ContactTriggerHelper.campaignIdList);
		if(ContactTriggerHelper.contactListoUpdatelookup.size()>0){
			ContactTriggerHelper.contactLookupCampaignAutoPopulation(ContactTriggerHelper.contactListoUpdatelookup ,ContactTriggerHelper.campaignIdList);
		}
	}//end of afterInsertOperation
	
}