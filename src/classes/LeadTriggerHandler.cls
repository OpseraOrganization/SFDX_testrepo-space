/****************************************
* Class Name : LeadTriggerHandler
* Created Date: 7 December 2016
* Created By : Accenture
* Last Modified by: Accenture
* Last Modified Date: 7 December 2016
* Description : Handle the sequence of the LeadTriggerHelper
*Author: Avishek Hazra LastModifiedDate:10-08-2020 Story:IBCM43 Description:Updated afterUpdateOperationmethod with new parameters as old map
* Test Class: 
*****************************************/
public without sharing class LeadTriggerHandler{
	/********************
*Method Name: afterOperation
*Parameter: Lead List
*Description: Used to handle after update activities
**************1. Validations for Lead Conversion
**************2. Add default values in opportunity at the time of conversion
*******************/
	public static void afterUpdateOperation(List<Lead> leadList,Map<Id,Lead>oldMap){
		
		try{
			
			List<Lead> directSalesLeadList = new List<Lead>();
			List<Lead> txleLeadList = new List<Lead>();
			
			for(Lead ld : leadList){
				if(ld.recordtypeId == system.label.DirectLeadRecordType)
					directSalesLeadList.add(ld);
				
				if(ld.recordtypeId == system.label.TXLELeadRecordType)
					txleLeadList.add(ld);  
			} 
			//Check Lead Conversion Validations
			if(!directSalesLeadList.isEmpty()){
				LeadTriggerHelper.leadConversionValidations(directSalesLeadList,oldMap);
				LeadTriggerHelper.addOppDefaultValues(directSalesLeadList,oldMap);
				LeadTriggerHelper.OverrideContactFields(directSalesLeadList,oldMap);
			}
			
			if(!txleLeadList.isEmpty()){ 
				LeadTriggerHelper.leadConversionValidations(txleLeadList,oldMap);
				LeadTriggerHelper.OverrideContactFields(txleLeadList,oldMap);
			}
			
		}
		catch(System.Exception e){
			
		}
		
		
		
	}//end of afterOperation  
	
	/*Method Name: beforeUpdateOperation
*Parameter: Lead List
*Description: Used to handle before update activities
**************1. Vpoulate market and country code based on country value
*/
	public static void beforeOperation(List<Lead> leadList,Map<id, Lead> OldLeadMap){  
		//Check Lead Conversion Validations
		try{
			LeadTriggerHelper.leadCampaignAutoPopulation(leadList,OldLeadMap);
			
			List<Lead> leadListoUpdate = new List<Lead> ();
			List<Lead> leadListoUpdatelookup = new List<Lead> ();
			
			for(lead ld : leadList){
				
				
				if(ld.country != null || ld.countrycode!=NULL){
					
					if(ld.Market__c == null){
						ld.Market__c = ISO_Country_Codes__c.getvalues(ld.CountryCode).Market__c;
					}
					else if(ld.Market__c  != ISO_Country_Codes__c.getvalues(ld.CountryCode).Market__c){
						ld.addError(System.Label.Incorrect_Market_Value + ' ' +ISO_Country_Codes__c.getvalues(ld.CountryCode).Country_Name__c+ ' ' + System.Label.Is + ' ' + ISO_Country_Codes__c.getvalues(ld.CountryCode).Market__c);
					}
					ld.country__c= ISO_Country_Codes__c.getvalues(ld.countrycode).country_name__c;
					ld.Country_Code__c = ld.countrycode;
					ld.State__c = ld.State;
				}
			}
			
			
			
		}
		catch(Exception exc){
			ExceptionHandler.addException(exc, GlobalConstants.LEAD_TRIGGER_HANDLER , GlobalConstants.LEAD_TRIGGER_HANDLER_BEFORE_OP );
		}
		
		
	}//end of beforeUpdateOperation  
	
	/********************
*Method Name: afterInsertOperation
*Parameter: Lead List
*Description: Used to handle after update activities
**************1. 
**************2. 
*******************/
	public static void afterInsertOperation(List<Lead> leadList,Map<id, Lead> OldLeadMap){
		try{
			if(LeadTriggerHelper.leadListoUpdatelookup.size()>0){
				LeadTriggerHelper.leadLookupCampaignAutoPopulation(LeadTriggerHelper.leadListoUpdatelookup,LeadTriggerHelper.campaignIdList);
			}
		}
		catch(System.Exception e){
			
		}
	}//end of afterInsertOperation
}//end of class LeadTriggerHandler