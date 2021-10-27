public class SummaryGroupTriggerHandler {
	
	/**********************************************
* Param: List<Apttus_Config2__SummaryGroup__c>
* Return: None 
* Date: Nov 2019
* Details: Workflows converted to Trigger as 
part of Performance Improvement  
***********************************************/
	public static void beforeInsert(List<Apttus_Config2__SummaryGroup__c> summaryGroupList)
	{
		SummaryGroupTriggerHelper.updateFieldsBeforeInsert(summaryGroupList);
	}
	
	/**********************************************
* Param: List<Apttus_Config2__SummaryGroup__c>
* Return: None 
* Date: Nov 2019
* Details: Workflows converted to Trigger as 
part of Performance Improvement  
***********************************************/
	public static void beforeUpdate(List<Apttus_Config2__SummaryGroup__c> summaryGroupList)
	{
		if(Nokia_CPQ_Constants.flagOnSummary)
			SummaryGroupTriggerHelper.updateFieldsBeforeUpdate(summaryGroupList);
		Nokia_CPQ_Constants.flagOnSummary = false;
	}
}