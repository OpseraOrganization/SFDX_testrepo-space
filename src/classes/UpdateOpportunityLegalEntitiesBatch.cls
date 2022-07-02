/****************************************
 * Class Name : UpdateOpportunityLegalEntitiesBatch 
 * Created Date: 27 December 2016
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 29 March 2017
 * Description : Update the opprtunity with Account legal Entity and End customer legal Entity values
 * Test Class: 
 *****************************************/
global class UpdateOpportunityLegalEntitiesBatch implements Database.Batchable<sObject>{

   public list<String> parentaccountList= new list<String>();
   public List<string> parentIdList = new list<string>();
   global final String query;

   /********************
	*Method Name: UpdateOpportunityLegalEntitiesBatch
	*Parameter: parent Account Id List
	*Description: costructor used to set the query string which will get passed for Batch execute method
   *******************/
   global UpdateOpportunityLegalEntitiesBatch(List<string> pList){
		parentIdList = pList;
		query='select id,name,accountId,RecordTypeId,end_customer__c,Legal_Entity__c,End_Customer_LE__c from opportunity where (accountId IN : parentIdList OR end_customer__c IN : parentIdList) and (Legal_Entity__c=NULL OR End_Customer_LE__c=NULL)';
   }

   /********************
	*Method Name: start
	*Parameter: parent Account Id List
	*Return Type: Database.QueryLocator
	*Description: start the batch execution
   *******************/
   global Database.QueryLocator start(Database.BatchableContext BC){
		return Database.getQueryLocator(query);
   }
   
   /********************
	*Method Name: execute
	*Parameter: Batcheable context, opportunity list
	*Return Type: Database.QueryLocator
	*Description: batch execution
   *******************/ 
   global void execute(Database.BatchableContext BC, List<Opportunity> oppList){
		Map<string,string> customerVsDefaultLE = new Map<string,string>(); 
	 
		for(Opportunity opp : oppList){
			parentaccountList.add(opp.end_customer__c);
			parentaccountList.add(opp.accountId);
		}
		
		List<Account> defaultLEList = [select Id,parentId from Account where RecordType.name=: GlobalConstants.LEGAL_ENTITY 
												 and Default_Legal_Entity__c = true
												 and parentId IN : parentaccountList
												 limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
		
		if(defaultLEList.size()>0){
			for(Account defaultLE : defaultLEList){
				customerVsDefaultLE.put(defaultLE.parentId,defaultLE.Id);													 
			}
			
			/*******SF Ticket 00573431 -Added below line************/
			Id oppDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.CREATE_DIRECT_SALES_OPPORTUNITY).getRecordTypeId();
			 
			for(Opportunity opp : oppList){
				/*******SF Ticket 00573431 - Commented below line and added 'if' at line no. 66********/
				//opp.End_Customer_LE__c = customerVsDefaultLE.get(opp.End_Customer__c);
				if(opp.RecordTypeId == oppDirectRecordTypeId) opp.End_Customer_LE__c = customerVsDefaultLE.get(opp.End_Customer__c);
				
				opp.Legal_Entity__c = customerVsDefaultLE.get(opp.accountId);
			} 
		} 
		update oppList;				
   }
	
	/********************
	*Method Name: finish
	*Parameter: Batcheable context
	*Return Type: Database.QueryLocator
	*Description: nothing to do in this method
   *******************/ 
   global void finish(Database.BatchableContext BC){
   }
}