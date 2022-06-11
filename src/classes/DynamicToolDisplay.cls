/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
Name:			DynamicToolDisplay
Description:	 DynamicToolDispla class to get tool assigned to current user
Date		Version	  Author		Summary of Changes 
-----------	  ----------	  -----------------	---------------------------------------------------------------------------------------------------
10/08/2017	  1.0		Supriyam			get tool assigned to current user
----------------------------------------------------------------------------------------------------------------------------------------------------------*/

public with sharing class DynamicToolDisplay {
	/**
* Description : getDynamicTool
* @param NA
* @return tool Details
* @throws NA
**/
	@AuraEnabled
	public static LIST<Additional_Resource_Request__c> getDynamicTool() 
	{
		LIST<Additional_Resource_Request__c> dynamicTool;
		try{
			dynamicTool = [select Additional_Resource__c,Procurement_Status__c,Partner_User__c,Partner_Contact__c,Partner_Contact__r.MailingCountry 
		 from Additional_Resource_Request__c 
		 where Partner_User__c=:UserInfo.getUserId() Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())
		];
			for(Integer j = 0; j < dynamicTool.size(); j++){if(dynamicTool.get(j).Additional_Resource__c == PRMGlobalConstants.SFDC_PRM_Access){ dynamicTool.remove(j);}}
			for(Integer j = 0; j < dynamicTool.size(); j++){if(dynamicTool.get(j).Additional_Resource__c == PRMGlobalConstants.Personal_Space){ dynamicTool.remove(j);}}
			for(Integer j = 0; j < dynamicTool.size(); j++){if(dynamicTool.get(j).Additional_Resource__c == PRMGlobalConstants.Deal_Registration){dynamicTool.remove(j);}}
			for(Integer j = 0; j < dynamicTool.size(); j++){if(dynamicTool.get(j).Additional_Resource__c == PRMGlobalConstants.CPQ_Tool){dynamicTool.remove(j);}}
			for(Integer j = 0; j < dynamicTool.size(); j++){if(dynamicTool.get(j).Additional_Resource__c == PRMGlobalConstants.NDAC_OfferOrder_Name){dynamicTool.remove(j);}}
			for(Integer j = 0; j < dynamicTool.size(); j++){if(dynamicTool.get(j).Additional_Resource__c == PRMGlobalConstants.NDAC_Name){dynamicTool.get(j).Additional_Resource__c = PRMGlobalConstants.NDAC_DisplayName;}}
			
		}
		Catch(Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.DynamicToolDisplay,PRMGlobalConstants.getDynamicTool);}
		return dynamicTool;
	}
	/**
* Description : getDynamicToolURL
* @param NA
* @return tool Details
* @throws NA
**/
	@AuraEnabled
	public static List<AdditionalResourceToolUrl__c>  getDynamicToolURL() 
	{
		List<AdditionalResourceToolUrl__c> dynamicToolURL;
		try{dynamicToolURL = AdditionalResourceToolUrl__c.getall().values();}
		Catch(Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.DynamicToolDisplay,PRMGlobalConstants.getDynamicToolURL);}
		return dynamicToolURL;
		
	}
}