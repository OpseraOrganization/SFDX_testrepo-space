/****************************************
*Class Name : leadTriggerHelper
*Created Date: 7 December 2016
*Created By : Accenture
*Last Modified by: Accenture
*Last Modified Date: 7 December 2016
11 December 2017
*Author: Avishek Hazra LastModifiedDate:10-08-2020 Story:IBCM15 Description:Updated OverrideContactFields method if lead is converted without Opportunity		  
*Description : This class check lead conversion validations, Add constant values for some fields on opportunity and Account.
*************  at the time of Lead Conversion. 
*Test Class: LeadTriggerHelperTest
*****************************************/
public without sharing class LeadTriggerHelper {
	//variable to store Opportunity assicated with lead conversion
	private static Opportunity opp;
	public static List < Lead > leadListoUpdatelookup = new List < Lead > ();
	public static List < string > campaignIdList = new List < string > ();
	/*******************************
*Method name: leadConversionValidations
*Description: This method will check all validations related to lead conversion
*Parameter: Lead Values
*******************************/
	public static void leadConversionValidations(List < Lead > leadList,Map<Id,Lead>oldMap) {
		try {
			System.debug('Lead.IsConverted........' + Lead.IsConverted);
			Map < String, Lead > convertedAccountIdVsLeadMap = new Map < String, Lead > ();
			System.debug('GlobalConstants.NEW_ACCOUNT ........' + GlobalConstants.NEW_ACCOUNT);
			for (Lead lead: leadList) {
				if (!oldMap.get(lead.Id).IsConverted && lead.IsConverted) {
					
					//Requirement#1422
					//Stop Prospect Creation for lead conversion
					if (GlobalConstants.NEW_ACCOUNT) {
						lead.addError(System.label.LeadConversionAccount);
					} else {
						convertedAccountIdVsLeadMap.put(lead.convertedAccountId, lead);
					}
				}
			} //end of for loop
			
			
			for (Account newAccount: [select Id, name, active__c, recordtype.name, AccountStatusInCRMOM__c from account
									  where Id IN: convertedAccountIdVsLeadMap.keySet() LIMIT: convertedAccountIdVsLeadMap.keySet().size()
									 ]) {
										 //We can not convert a lead to Inactive account
										 //Requirement #236
										 if (!newAccount.active__c && newAccount.recordtype.name == GlobalConstants.ACC_PROSPECT) {
											 convertedAccountIdVsLeadMap.get(newAccount.Id).addError(System.label.Associated_Account_is_not_active);
										 }
										 
										 if ((!newAccount.active__c || newAccount.AccountStatusInCRMOM__c != GlobalConstants.ACTIVE) && newAccount.recordtype.name == GlobalConstants.ACC_CUSTOMER) {
											 convertedAccountIdVsLeadMap.get(newAccount.Id).addError(System.label.Associated_Account_is_not_active);
										 }
										 
										 
										 //We can not convert lead to Legal Entity
										 //Requirement # 187
										 //Defect # D-0260
										 system.debug('newAccount.recordtype.name ' + newAccount.recordtype.name);
										 if (newAccount.recordtype.name.equals(GlobalConstants.LEGAL_ENTITY)) {
											 convertedAccountIdVsLeadMap.get(newAccount.Id).addError(System.label.Legal_Entity_Selection_on_Lead_Conversion);
										 }
									 } //end of for loop
		} catch (Exception exc) {
			ExceptionHandler.addException(exc, GlobalConstants.LEADTRIGGERHELPER, GlobalConstants.LEAD_CONVERSION_VALIDATIONS);
		}
	} //end of method leadConversionValidations
	
	/*******************************
*Method name: addOppDefaultValues
*Description: This method will add default values on opportunity at the time of lead conversion by referring custom Setting "OpportunityDefaultLeadConversion__c".
*Parameter: Lead Values
*******************************/
	public static void addOppDefaultValues(List < Lead > leadList,Map<Id,Lead>oldMap) {
		try {
			List < Opportunity > oppList = new List < Opportunity > ();
			Map < String, String > oppIdVsleadIdMap = new Map < String, String > ();
			//Requirement#3431
			//Populate campaign name on 'Choose existing opportunity' on Lead Conversion
			Map < String, String > leadIdVscampaignIds = new Map < String, String > ();
			//Since lead conversion always happens on one record lead list size will be one
			for (Lead lead: leadList) {
				system.debug('++++++++++++++++++++++++++++++' + lead.Campaign_name__c);
				if(lead.MKT_AttributionCampaign__c!=null)
					leadIdVscampaignIds.put(lead.Id, lead.MKT_AttributionCampaign__c);
				else if(lead.Campaign_Lookup__c!=null)
					leadIdVscampaignIds.put(lead.Id, lead.Campaign_Lookup__c);
				System.debug('*****************Leadvalues****'+oldMap.get(lead.Id).IsConverted+':'+lead.IsConverted+':'+lead.convertedOpportunityId);
				if (!oldMap.get(lead.Id).IsConverted && lead.IsConverted && lead.convertedOpportunityId != NULL) {
					oppIdVsleadIdMap.put(lead.convertedOpportunityId, lead.Id);
				} //end of if
			} //end of outer for loop running on leadlist
			
			oppList = [select Id, campaignId, Influencing_Campaign__c from opportunity where Id in: oppIdVsleadIdMap.keySet() limit: oppIdVsleadIdMap.size()];
			
			if (!oppList.isEmpty()) {
				for (Opportunity opp: oppList) {
					//Requirement#3431
					system.debug('++++++++++++++++++++++++++++++' + opp.CampaignId);
					system.debug('++++++++++++++++++++++++++++++' + leadIdVscampaignIds.get(oppIdVsleadIdMap.get(opp.Id)));
					if (opp.CampaignId == NULL && leadIdVscampaignIds.containsKey(oppIdVsleadIdMap.get(opp.Id)) && opp.Influencing_Campaign__c == null){
						opp.CampaignId = leadIdVscampaignIds.get(oppIdVsleadIdMap.get(opp.Id));
					}   
					//Set required fields on opportunities with default values
					//requirement #478
					//Defect# D-0158,D-0240
					Integer checkOptyNew = DS_Oppty_Main_Reasons.checkOpttyStageParams(opp.id);
					if (checkOptyNew == 1) {
						for (OpportunityDefaultLeadConversion__c ODLC: OpportunityDefaultLeadConversion__c.getAll().values()) {
							opp.put(ODLC.name, ODLC.DefaultValue__c);
						}
						
					} //end of inner for loop running on custom setting values
				}
				update oppList;
			}
		} catch (Exception exc) {
			System.debug('Exception Occured in ADD_OPP_DEFAULT_VALUES .....' + exc);
			ExceptionHandler.addException(exc, GlobalConstants.LEADTRIGGERHELPER, GlobalConstants.ADD_OPP_DEFAULT_VALUES);
		}
	} //end of method addOppDefaultValues
	
	/*******************************
*Method name: OverrideContactFields
*Description: This method will check if the converted contact contains leads vales or not.
If not then this method will override all conatct fields value with new lead.
This feature is mostky applicable if user select existing contact at the time of lead conversion.
*Parameter: Lead Values
*******************************/
	public static void OverrideContactFields(List < Lead > leadList,Map<Id,Lead>oldMap) {
		try {
			List < Contact > conList = new List < Contact > ();
			//add some code to prevent the complete override.
			List < String > conIdList = new list < String > ();
			String directSales_RectypId = Schema.describeSObjects(new List<String>{'Lead'})[0].getRecordTypeInfosByDeveloperName().get('Direct_Sales').getRecordTypeId();
			Map < String, Contact > contactMap = new Map < String, Contact > ();
			for (Lead le: LeadList) {
				if (!oldMap.get(le.Id).IsConverted && le.IsConverted && le.convertedContactId != NULL)  {
					conIdList.add(le.convertedContactId);
				}
			}
			if (conIdList.size() > 0) {
				List < Contact > conBeforeList = [Select Id from Contact where id in: conIdList];
				for (Contact cat: conBeforeList) {
					contactMap.put(cat.id, cat);
				}
			}
			for (Lead lead: leadList) {
				if (!oldMap.get(lead.Id).IsConverted && lead.IsConverted && lead.convertedContactId != NULL) {
					Contact con = contactMap.get(lead.convertedContactId);
					con.Id = lead.convertedContactId;
					//
					if(lead.recordTypeId == directSales_RectypId){
						
						System.debug('************Lead*****'+lead+'********oldLead***'+oldMap);
						
						con.Description = lead.Description;
						con.DoNotCall = lead.DoNotCall;
						con.Email = lead.Email;
						con.HasOptedOutOfEmail = lead.HasOptedOutOfEmail;
						con.HasOptedOutOfFax = lead.HasOptedOutOfFax;
						con.LeadSource = lead.LeadSource;
						con.MobilePhone = lead.MobilePhone;
						con.Phone = lead.Phone;
						con.MailingStreet = lead.Street;
						con.MailingCity = lead.City;
						con.MailingState = lead.State;
						con.MailingCountry = lead.Country;
						con.MailingPostalCode = lead.PostalCode;
						con.title = lead.title;
						con.Job_Function_Sales__c = lead.Job_Function__c;
						con.Purchasing_Role_Sales__c = lead.Purchasing_Role__c;
						
					}
					con.Sync_To_Marketo__c = lead.Sync_To_Marketo__c;
					 if(lead.MKT_IsConvertedForSupportProcess__c)
					 con.MKT_IsConvertedForSupportProcess__c=true;
					
					if (lead.Campaign_Lookup__c   != NULL || lead.MKT_AttributionCampaign__c  != NULL) {
						con.Campaign_Name__c = lead.Campaign_Lookup__r.Name;
						if(lead.convertedOpportunityId==null)
						{
							con.status__c=oldMap.get(lead.id).status;

						}
						else{
							con.status__c = lead.status;
						}
					}
					conList.add(con);
				}
			}
			if (!conList.isEmpty()) {
				update conList;
			}
		} catch (Exception exc) {
			ExceptionHandler.addException(exc, GlobalConstants.LEADTRIGGERHELPER, GlobalConstants.ADD_OPP_DEFAULT_VALUES);
		}
	} //end of method OverrideContactFields
	
	/*******************************
*Method name: leadCampaignAutoPopulation
*Description: This method will populate Campaign Name from "Campaign Name" text field 
to the "Marketing Campaign" lookup field.	   
*Parameter: Lead Values
*******************************/
	public static void leadCampaignAutoPopulation(List < Lead > leadList, Map < id, Lead > OldLeadMap) {
		try {
			
			List < String > campaignNameList = new list < string > ();
			Map < id, String > leadToCampaignNameMap = new Map < id, String > ();
			
			
			for (Lead leadInstance: leadList) {
				if (leadInstance.Campaign_Name__c != NULL) {
					if (OldLeadMap == Null || OldLeadMap.size() == 0)
						leadToCampaignNameMap.put(leadInstance.Id, leadInstance.Campaign_Name__c);
					else if (leadInstance.Campaign_Name__c != OldLeadMap.get(leadInstance.Id).Campaign_Name__c)
						leadToCampaignNameMap.put(leadInstance.Id, leadInstance.Campaign_Name__c);
				}
				
				if (OldLeadMap == Null || OldLeadMap.size() == 0) {
					if (leadInstance.Campaign_Lookup__c != NULL) {
						leadListoUpdatelookup.add(leadInstance);
						campaignIdList.add(leadInstance.Campaign_Lookup__c);
					}
				} else if (leadInstance.Campaign_Lookup__c != OldLeadMap.get(leadInstance.Id).Campaign_Lookup__c) {
					leadListoUpdatelookup.add(leadInstance);
					campaignIdList.add(leadInstance.Campaign_Lookup__c);
				}
			}
			
			if (leadToCampaignNameMap.size() > 0) {
				Map < String, string > campaignNameVsId = new Map < string, string > ();
				for (Campaign cmp: [select Id, name from campaign where name in: leadToCampaignNameMap.Values()]) {
					campaignNameVsId.put(cmp.name, cmp.Id);
				}
				
				for (Lead leadInstance: leadList) {
					
					if (leadToCampaignNameMap.containsKey(leadInstance.Id) && leadInstance.Campaign_Name__c != NULL) {
						if (campaignNameVsId.containsKey(leadToCampaignNameMap.get(leadInstance.Id))) {
							leadInstance.Campaign_Lookup__c = campaignNameVsId.get(leadInstance.Campaign_Name__c);
							
						}
					}
				}
				
			}
			if (leadListoUpdatelookup.size() > 0) {
				LeadTriggerHelper.leadLookupCampaignAutoPopulation(leadListoUpdatelookup, campaignIdList);
			}
			
		} catch (Exception exc) {
			ExceptionHandler.addException(exc, GlobalConstants.Campaign_Error2, GlobalConstants.Campaign_Error3);
		}
	} //end of method leadCampaignAutoPopulation
	
	/*******************************
*Method name: leadLookupCampaignAutoPopulation
*Description: This method will populate Campaign Name from "Marketing Campaign" 
lookup field to the "Campaign Name" text field.   
*Parameter: Lead Values
*******************************/
	public static void leadLookupCampaignAutoPopulation(List < Lead > leadList, List < string > campaignIdList) {
		try {
			
			List < String > campaignNameList = new list < string > ();
			Map < id, String > leadToCampaignNameMap = new Map < id, String > ();
			Map < id, campaign > relatedCampaignMap = new Map < Id, Campaign > ([select Id, name from campaign where Id In: campaignIdList]);
			List < Campaignmember > memberList = new List < campaignmember > ();
			
			for (Lead leadInstance: leadList) {
				if (leadInstance.Campaign_Lookup__c != NULL) {
					leadInstance.Campaign_Name__c = relatedCampaignMap.get(leadInstance.Campaign_Lookup__c).name;
					if (leadInstance.id != null) {
						Campaignmember member = new campaignmember();
						member.leadId = leadInstance.id;
						member.campaignId = leadInstance.Campaign_Lookup__c;
						member.Status = GlobalConstants.SENT;
						memberList.add(member);
					}
				} else {
					leadInstance.Campaign_Name__c = NULL;
				}
			}
			
			insert memberList;
			
		} catch (Exception exc) {
			ExceptionHandler.addException(exc, GlobalConstants.Campaign_Error2, GlobalConstants.Campaign_Error3);
		}
	} //end of leadLookupCampaignAutoPopulation
	
} //end of class LeadTriggerHepler