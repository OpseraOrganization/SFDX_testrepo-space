@isTest
public class UpdateProductConfigBatchTest 
{
	static testMethod void testMethod1()
	{
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		insert accounts;
		
		//create opportunity
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Direct Sales Opportunity').getRecordTypeId();		
		insert opportunities;
		Test.startTest();
		  List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Direct Quote').getRecordTypeId(); //direct quote
		insert proposals; 
		
		
		List<Apttus_Config2__ProductConfiguration__c> prodconfig=NOKIA_CPQ_TestDataFactory.createProdConfig(2);
			prodconfig[0].Apttus_Config2__Status__c = 'New';
			prodconfig[0].Apttus_Config2__BusinessObjectType__c = 'Proposal';
			prodconfig[0].Apttus_Config2__AccountId__c = accounts[1].Id;
			prodconfig[0].Apttus_QPConfig__Proposald__c = proposals[0].Id;
			prodconfig[0].NokiaCPQ_Quote_Type__c='Direct CPQ';
			prodconfig[0].NokiaCPQ_Pricing_Cluster__c='';
			prodconfig[0].NokiaCPQ_Portfolio__c='Nokia Software';
			
			prodconfig[1].Apttus_Config2__Status__c = 'Saved';
			prodconfig[1].Apttus_Config2__BusinessObjectType__c = 'Proposal';
			prodconfig[1].Apttus_Config2__AccountId__c = accounts[1].Id;
			prodconfig[1].Apttus_QPConfig__Proposald__c = proposals[0].Id;
			prodconfig[1].NokiaCPQ_Quote_Type__c='Direct CPQ';
			prodconfig[1].NokiaCPQ_Pricing_Cluster__c='';
			prodconfig[1].NokiaCPQ_Portfolio__c='Nokia Software';

			  insert prodconfig;
		
		UpdateProductConfigBatch updbatch = new UpdateProductConfigBatch();
		ID batchprocessid = Database.executeBatch(updbatch);
		Test.stopTest();
	}


}