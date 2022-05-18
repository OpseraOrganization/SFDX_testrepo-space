public without sharing class CRM_CPVDataController {
	@AuraEnabled
	public static WrapperFull getAccountCPVApex(Id accId)
	{
		System.debug('CRM_CPVDataController');
		WrapperFull wrapper = new WrapperFull();	
		try
		{
			wrapper.errorMessage = '';
			wrapper.accountCPV = null;
			List<CRM_Customer_Perceived_Value__c> cpvList = [SELECT Id, Name, Account_Number__c, Nokia_CPV__c, Nokia_CPV_Trend__c, Competition_CPV__c, Competition_CPV_Trend__c, Report_Published_Date__c, Top_down_support_for_CT_actions__c FROM CRM_Customer_Perceived_Value__c WHERE Account__r.Id = :accId ORDER BY Report_Published_Date__c DESC, LastModifiedDate  DESC LIMIT 1];
			if(cpvList.size() == 0)
			{
	wrapper.errorMessage = 'No CPV data found for this account';
			}
			else
			{
	wrapper.accountCPV = cpvList[0];
	wrapper.successMessage = 'CPV data found for this account';
			}
		}
		catch (Exception err)
		{
			if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) )
			{
	wrapper.errorMessage = err.getMessage().split('error:')[1].split(':')[0] + '.';
			}
			else
			{
	wrapper.errorMessage = err.getMessage();
			}
		}
		return wrapper;
	}
	/** WRAPPER CLASSES**/
	public class WrapperFull
	{
		@AuraEnabled
		public CRM_Customer_Perceived_Value__c accountCPV  {get;set;}
		@AuraEnabled
		public String successMessage  {get;set;}
		@AuraEnabled
		public String errorMessage  {get;set;}
	}
}