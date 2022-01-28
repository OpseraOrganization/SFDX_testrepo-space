/****************************************
 * Name : Batch_copyOpptyPfToOif
 * Author : Accenture
 * Description : Sales Process SF Ticket: 
 * 
 *****************************************/
global class Batch_copyOpptyPfToOif implements Database.Batchable<sObject>
{
	/****************************************
	 * Name : Batch_copyOpptyPfToOif
	 * Author : Accenture
	 * Description : constructor for the batch 
	 *****************************************/
	global Batch_copyOpptyPfToOif()
	{
	}
	/****************************************
	 * Name : start
	 * Author : Accenture
	 * Description : this method will contain the SOQL query for the batch 
	 *****************************************/
	global Database.QueryLocator start(Database.BatchableContext BC)
	{
		//List<Id> opptyIdList = new List<Id>{'00641000008zmFe','00641000008zljn','00641000008znCb','00641000008znDK','00641000008zllb'};
		//system.debug('opptyIdList>>'+opptyIdList .size());
		//String query = 'SELECT id, Opportunity__c, Program_Flag__c FROM OptyProgramFlagJunction__c WHERE Opportunity__c IN: opptyIdList';
		String query = 'SELECT id, Opportunity__c, Program_Flag__c FROM OptyProgramFlagJunction__c';
		//String query = 'SELECT id, Opportunity__c, Program_Flag__c FROM OptyProgramFlagJunction__c';   
		//String query = 'SELECT id,Master_Opty__c, Related_Opportunity_s_Unweighted_Value__c, Unweighted_Value_of_Master_Opportunity__c FROM Deal__c';
		//Id dealFramedRecordTypeId = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Framed Deal').getRecordTypeId();
		//String query = 'SELECT id, Master_Opty__c, Related_Opportunity_s_Unweighted_Value__c,RecordTypeId FROM Deal__c WHERE RecordTypeId =: dealFramedRecordTypeId';
		system.debug('query>>'+query);
		return Database.getQueryLocator(query);
	}
	/****************************************
	 * Name : execute
	 * Author : Accenture
	 * Description : Execution of the batch
	 *****************************************/
	global void execute(Database.BatchableContext BC, List<OptyProgramFlagJunction__c> scope)
	{
		OptyProgramFlagJunctionTriggerHelper.copyOpptyProgramFlagToOif(scope, true);
		//DealTriggerHelper.compareUnweightedValueOnDeal(new Map<Id, Deal__c>(scope));
		//database.update(scope);
	}
	
	global void finish(Database.BatchableContext BC)
	{
		
	}
}