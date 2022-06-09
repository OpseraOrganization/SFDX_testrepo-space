/****************************************
 * Class Name : ContactTriggerHelper
 * Created Date: 4 May 2016
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 4 May 2016
 * Description : 1. Validate email domain
				 2. Check Contact is for VZW Account(301001643) if yes then send it to fALU.
 * Test Class: 
 *****************************************/
public class ContactTriggerHelper {

	public Static Final String ERR_INVALID_DOMAIN = 'The Email field contains invalid domain, Please correct the email and save again..!';
	public static List < Contact > contactListoUpdatelookup = new List < Contact > ();
	public static List < string > campaignIdList = new List < string > ();

	/********************
	 *Method Name: afterInsertOperation
	 *Parameter: Account List
	 *Description: Used to handle after Insert activities req#770
				   1. Check Contact is for VZW Account(301001643) if yes then send it to fALU.
	 *******************/
	public static void validateAndSendContact(List < Contact > contactList) {
		try {
			FALU_VZW_Sync__c setting = FALU_VZW_Sync__c.getvalues(GlobalConstants.FALU);
			if (setting != null) {
				List < contact > conList = [select Id, firstname, lastname, account.accountNumber, accountId, email from contact
					where account.accountNumber =: setting.SCRM_Customer_Number__c
					and Id IN: contactList
				];

				System.debug('conList:' + conList);
				Map < string, contact > emailVsContacttoCheck = new Map < string, contact > ();
				Map < Id, contact > newContactMap = new Map < Id, contact > ();
				for (contact c: conList) {
					emailVsContacttoCheck.put(c.email, c);
					newContactMap.put(c.Id, c);
				}
				if (emailVsContacttoCheck.size() > 0 && newContactMap.size() > 0) {
					System.enqueueJob(new FALUContacts(emailVsContacttoCheck, setting.fALU_Account_SFDC_ID__c, newContactMap));
				}
			}
		} catch (Exception exc) {
			ExceptionHandler.addException(exc, GlobalConstants.CONTACT_TRIGGER_HELPER, GlobalConstants.VALIDATE_AND_SEND_CONTACT);
		}
	}

	/********************
	*Method Name: afterInsertOperation
	*Parameter: Account List
	*Description: Used to handle after Insert activities req#770
				  1. Check Contact is for VZW Account(301001643) if yes then send it to fALU.
	*******************/
	public static void validateAndSendContactforUpdate(List < Contact > contactList, Map < Id, Contact > oldContactMap) {
		try {
			FALU_VZW_Sync__c setting = FALU_VZW_Sync__c.getvalues(GlobalConstants.FALU);
			if (setting != null) {
				List < contact > conList = [select Id, firstname, lastname, account.accountNumber, accountId, email from contact
					where account.accountNumber =: setting.SCRM_Customer_Number__c
					and Id IN: contactList
				];

				System.debug('conList:' + conList);
				Map < string, contact > emailVsContacttoCheck = new Map < string, contact > ();
				Map < Id, contact > newContactMap = new Map < Id, contact > ();
				for (contact c: conList) {
					emailVsContacttoCheck.put(oldContactMap.get(c.Id).email, c);
					newContactMap.put(c.Id, c);
				}
				if (emailVsContacttoCheck.size() > 0 && newContactMap.size() > 0) {
					System.enqueueJob(new FALUContacts(emailVsContacttoCheck, setting.fALU_Account_SFDC_ID__c, newContactMap));
				}
			}
		} catch (Exception exc) {
			ExceptionHandler.addException(exc, GlobalConstants.CONTACT_TRIGGER_HELPER, GlobalConstants.VALIDATE_AND_SEND_CONTACT_FOR_UPDATE);
		}
	}

	/********************
	 *Method Name: validateBlacklistedMailDomains
	 *Parameter: Contact List
	 *Description: Used to handle before update
		 1. validate Contact Email ddress in blacklist email domain 
	 *******************/

	public static void validateBlacklistedMailDomains(List < Contact > contactList) {
		try {
			InvalidEmailDomain__c invalidDomains = InvalidEmailDomain__c.getOrgDefaults();
			system.debug('xxxxxxxxxxx' + invalidDomains);
			List < String > lstInvalidDomains = invalidDomains.Domain__c.split(GlobalConstants.COMMA);


			for (Contact objContact: contactList) {
				Boolean isValid = true;
				if (!String.isBlank(objContact.Email)) {
					String sendingEmailDomain = objContact.Email.substringAfter(GlobalConstants.AT_THE_RATE_SYMBOL);
					String strContactDomain = sendingEmailDomain.substring(0, sendingEmailDomain.IndexOf(GlobalConstants.DOT));

					system.debug('domain from @ == > ' + sendingEmailDomain);
					system.debug('domain extension after . == > ' + strContactDomain);

					for (String strInvalidDomain: lstInvalidDomains) {
						if (strContactDomain.equalsIgnoreCase(strInvalidDomain)) {
							isValid = false;
							break;
						}
					}

					if (!isvalid) {
						objContact.adderror(ERR_INVALID_DOMAIN);
					}

				}
			}
		} catch (Exception exc) {
			ExceptionHandler.addException(exc, GlobalConstants.CONTACT_TRIGGER_HELPER, GlobalConstants.VALIDATE_BLACKLISTED_EMAIL_DOMAINS);
		}
	}

	/*******************************
	*Method name: contactCampaignAutoPopulation
	*Description: This method will populate Campaign Name from "Campaign Name" text field 
				  to the "Campaign Lookup" field.				
	*Parameter: Lead Values
	*******************************/
	public static void contactCampaignAutoPopulation(List < Contact > contactList, Map < id, Contact > OldContactMap) {
		try {

			List < String > campaignNameList = new list < string > ();
			Map < id, String > contactToCampaignNameMap = new Map < id, String > ();


			for (Contact contactInstance: contactList) {

				if (contactInstance.Campaign_Name__c != NULL) {
					if (OldContactMap == Null || OldContactMap.size() == 0)
						contactToCampaignNameMap.put(contactInstance.Id, contactInstance.Campaign_Name__c);
					else if (contactInstance.Campaign_Name__c != OldContactMap.get(contactInstance.Id).Campaign_Name__c)
						contactToCampaignNameMap.put(contactInstance.Id, contactInstance.Campaign_Name__c);
				}
				if (contactInstance.Marketing_Campaign__c != NULL) {

					if (OldContactMap == Null || OldContactMap.size() == 0) {
						contactListoUpdatelookup.add(contactInstance);
						campaignIdList.add(contactInstance.Marketing_Campaign__c);

					} else if (contactInstance.Marketing_Campaign__c != OldContactMap.get(contactInstance.Id).Marketing_Campaign__c) {

						contactListoUpdatelookup.add(contactInstance);
						campaignIdList.add(contactInstance.Marketing_Campaign__c);
					}
				}
			}

			if (contactToCampaignNameMap.size() > 0) {
				Map < String, string > campaignNameVsId = new Map < string, string > ();
				for (Campaign cmp: [select Id, name from campaign where name in: contactToCampaignNameMap.Values()]) {
					campaignNameVsId.put(cmp.name, cmp.Id);
				}

				for (Contact contactInstance: contactList) {
					if (contactToCampaignNameMap.containsKey(contactInstance.Id) && contactInstance.Campaign_Name__c != NULL) {
						if (campaignNameVsId.containsKey(contactToCampaignNameMap.get(contactInstance.Id))) {
							contactInstance.Marketing_Campaign__c = campaignNameVsId.get(contactInstance.Campaign_Name__c);

						}
					}
				}
			}
			if (contactListoUpdatelookup.size() > 0) {
				ContactTriggerHelper.contactLookupCampaignAutoPopulation(contactListoUpdatelookup, campaignIdList);
			}

		} catch (Exception exc) {
			ExceptionHandler.addException(exc, 'ContactCaerror', 'Errorxxx');
		}
	} //end of method contactCampaignAutoPopulation

	/*******************************
	*Method name: contactLookupCampaignAutoPopulation
	*Description: This method will populate Campaign Name from "Marketing Campaign" 
				  lookup field to the "Campaign Name" text field.			
	*Parameter: contact Values
	*******************************/
	public static void contactLookupCampaignAutoPopulation(List < Contact > contactList, List < string > campaignIdList) {
		try {

			List < String > campaignNameList = new list < string > ();
			Map < id, String > contactToCampaignNameMap = new Map < id, String > ();
			Map < id, campaign > relatedCampaignMap = new Map < Id, Campaign > ([select Id, name from campaign where Id In: campaignIdList]);
			List < Campaignmember > memberList = new List < campaignmember > ();

			for (contact contactInstance: contactList) {  
				if (contactInstance.Marketing_Campaign__c != NULL) { 
					contactInstance.Campaign_Name__c = relatedCampaignMap.get(contactInstance.Marketing_Campaign__c).name;
					if (contactInstance.id != NULL) {
						Campaignmember member = new campaignmember();
						member.contactId = contactInstance.id;
						member.campaignId = contactInstance.Marketing_Campaign__c;
						member.Status = 'Sent';
						memberList.add(member);
					}
				}
			}

			insert memberList;

		} catch (Exception exc) {
			ExceptionHandler.addException(exc, 'contactCaerror', 'Errorxxx');
		}
	} //end of contactLookupCampaignAutoPopulation
	/********************
	*Method Name: BypassDuplicateRuleValidation *SDC
	*Parameter: Contact List
	*Description: Used to handle before insert
		Change ByPassDuplicateRule__c base on Business need.
	*******************/
	public static void BypassDuplicateRuleValidation(List < Contact > contactList) {
		System.debug('====>Enter BypassDuplicateRuleValidation');
		List < Contact > cons = new List < Contact > ();
		Map < String, Contact > leadIdToCon = new Map < String, Contact > ();
		//Map<String,String> leIDTORecordType= new Map<String,String>();
		List < String > leadBypassRTList = new List < String > ();
		List < Schema.RecordTypeInfo > RT = Lead.SObjectType.getDescribe().getRecordTypeInfos();
		List < String > leadRunRTList = System.Label.RunDuplicateRuleLeadType.split(',');
		for (Schema.RecordTypeInfo re: RT) {
			if (!leadRunRTList.contains(re.getRecordTypeId())) {
				leadBypassRTList.add(re.getRecordTypeId());
			}

		}
		System.debug('====>RTList ' + leadBypassRTList);
		for (Contact con: contactList) {
			if (con.Lead_ID__c != null) {
				System.debug('====>Lead ID ' + con.Lead_ID__c);
				leadIdToCon.put(con.Lead_ID__c, con);
			}
		}
		if (leadIdToCon.size() > 0) {
			for (Lead le: [Select Id, Lead_Id__c, RecordTypeId from Lead where Lead_Id__c in: leadIdToCon.keyset()]) {
				System.debug(le);
				if (le.RecordTypeId == null) {
					Continue;
				}
				if (leadBypassRTList.size() > 0 && leadBypassRTList.contains(le.RecordTypeId)) {
					cons.add(leadIdToCon.get(le.Lead_Id__c));
					System.debug('====>' + cons);
				}
			}
			if (cons.size() > 0) {
				for (Contact c: cons) {
					c.ByPassDuplicateRule__c = true;
					System.debug('====>Lead ID: ' + c.Lead_ID__c + ' Bypass: ' + c.ByPassDuplicateRule__c);
				}
			}

		}

	}
	/********************
	 *Method Name: contactMatchIndustryWithLead
	 *Parameter: Contact List
	 *Description: Used to match Contact Industry with Lead Industry when lead convert
	 *Support Ticket: 12448
	 *Date: 20180907
	 *******************/
	public static void contactMatchIndustryWithLead(List < Contact > contactList) {
		try {
			map < String, String > leadIndustryMap = new map < String, String > ();
			Set < String > leadIDSet = new Set < String > ();
			for (Contact contact: contactList) {
				// if(contact.Lead_ID__c != GlobalConstants.BLANK_VALUE){
				if (!GlobalConstants.BLANK_VALUE.equalsIgnoreCase(contact.Lead_ID__c) && contact.Lead_ID__c != null) {
					leadIDSet.add(contact.Lead_ID__c);
				} // End of if
			} //End of for
			if (!leadIDSet.isEmpty()) {
				System.debug('##########leadIDSet:------>' + leadIDSet);
				for (Lead tmpLead: [select Lead_Id__c, Industry from lead where Lead_Id__c in: leadIDSet]) {
					leadIndustryMap.put(tmpLead.Lead_Id__c, tmpLead.Industry);
				} // End of for
				System.debug('##########leadIndustryMap:------>' + leadIndustryMap);

				for (Contact cont: contactList) {
					cont.Industry__c = leadIndustryMap.get(cont.Lead_ID__c);
				} //End of for
			} //End of if
		} catch (Exception exc) {
			ExceptionHandler.addException(exc, GlobalConstants.CONTACT_TRIGGER_HELPER, GlobalConstants.CONTACT_MATCH_INDUSTRY_WITH_LEAD);
		}
	} //End of contactMatchIndustryWithLead Method
}