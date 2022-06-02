/***
* Class created for ft-123
* Created By: CO Team (joao.5.rodrigues@gmail.com)
* Created Date: 27/08/2020
***/
public without sharing class CRM_NokiaNCIBLoginCtlr 
{
	/****************
	 * Method Name: fetchNCIBUrl
	 * Parameter: accId
	 * Created by: joao.5.rodrigues@nokia.com
	 * Description: To get NCIB URL from accountId and respective country 
	 * User Story: ft-123
	****************/
	@AuraEnabled
	public static AccWrapper fetchNCIBUrl(Id accId) 
	{
		AccWrapper wrp = new AccWrapper();
		List<Account> AccList = [Select Country__c from Account where id=:accId];
		if(AccList.size() > 0 && AccList[0].Country__c!=null)
		{
			List<ISO_Country_Codes__c> countryList =[Select NCIBURL__c from ISO_Country_Codes__c where Country_Name__c=:AccList[0].Country__c];
			if(countryList.size() > 0 && countryList[0].NCIBURL__c != null)
			{
				wrp.ncibUrl = countryList[0].NCIBURL__c;
			}
			else
			{
				wrp.errorMsg = 'Country code did not return any NCIB URL.';
			}
		}
		else
		{
			wrp.errorMsg = 'Account is not linked to a country.';
		}
		return wrp;
	}
	
	public class AccWrapper
	{
		@AuraEnabled
		public String ncibUrl {get;set;} 
		@AuraEnabled
		public String errorMsg {get;set;} 
	}
}