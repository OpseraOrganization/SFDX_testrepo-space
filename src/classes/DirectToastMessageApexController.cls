/*******************************
Class Name: DirectToastMessageApexController
Created by: Accenture
Created Date: 11th April 2018
Last modified by: Accenture
Last modified date: 
Description: Class is used as a controller class of directToastMessage lightning component.
Note : 
*******************************/
public without sharing class DirectToastMessageApexController {
	
   /*****************************
	*Method Name: checkExistingConfigurationLineItems
	*Description: This method is used to collect the Configuration Line Items of Quote Record. 
	*			 If Configuration items found for the Quote, method will return Flag value 1 else it will return 0 as value.
	*Requirement: 4222 (Direct CPQ requirements)
	*Parameters: recordId (Direct Quote record id)
	****************************/
	@AuraEnabled  
	public static Integer checkExistingConfigurationLineItems(Id recordId)
	{		
		Integer flag = 0;
		List< Apttus_Config2__ProductConfiguration__c> lineitemlist1 = new List< Apttus_Config2__ProductConfiguration__c>();		
		// perform SOQL on COnfiguration object and collect data.
		lineitemlist1 = [SELECT id,Apttus_Config2__NumberOfItems__c from Apttus_Config2__ProductConfiguration__c where Apttus_QPConfig__Proposald__c =: recordId Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];		
		if(lineitemlist1.size() > 0){
			flag = 1;
		}
		return flag;   
	}	
}