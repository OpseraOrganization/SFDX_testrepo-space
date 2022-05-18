@isTest
public class CPQ_ProgressBarControllerTest {
	@isTest static void testProgressBar(){
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		//accounts[1].AccountNumber='301030872';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;
	 
		List<Opportunity> oppties = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		oppties[0].RecordTypeId =Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		insert oppties;
	 
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = oppties[0].Id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = false;
		proposals[0].Reprice_In_Progress__c = false;
		//proposals[0].RecordTypeId ='012290000008kdZAAQ'; //direct quote
		proposals[0].NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c = true;
		proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId();
		proposals[0].Apttus_Proposal__Approval_Stage__c = 'Approved';
		
		insert proposals;

		Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
		priceList.Name='Global Price List (EUR)';
		priceList.CurrencyIsoCode='GBP';
		priceList.Apttus_Config2__Active__c=true;
		priceList.PriceList_Type__c='CPQ';
		priceList.Apttus_Config2__Type__c='Standard';
		
		insert priceList;
	 
	 // Create Product
	 Product2 prod1 = new product2(
			Name = 'Test1', 
			ProductCode = '123', 
			Business_Group__c = 'MN', 
			CurrencyIsoCode = 'USD',
			Portfolio__c = 'IP Routing',
			IsActive = true  ); 
	 insert prod1;
	 
	  //create price list items
	 Apttus_Config2__PriceListItem__c pLI1 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = priceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = prod1.Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
	 );
	 insert pLI1;
			
	 List<Apttus_Config2__ProductConfiguration__c> prodConfigs = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
		prodConfigs[0].Apttus_Config2__PriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__EffectivePriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__AccountId__c = accounts[0].Id;
		prodConfigs[0].Apttus_QPConfig__Proposald__c = proposals[0].Id;
		prodConfigs[0].Apttus_Config2__Status__c = 'New';
		insert prodConfigs;
	 
	 List<Apttus_Config2__LineItem__c> ConfigLineitems = NOKIA_CPQ_TestDataFactory.createLineItem(5);
	 for(integer i=0; i<ConfigLineitems.size(); i++ ){
		 ConfigLineitems[i].Apttus_Config2__ConfigurationId__c = prodConfigs[0].Id;
		 ConfigLineitems[i].Apttus_Config2__ListPrice__c = 10;
		 ConfigLineitems[i].Apttus_Config2__PriceListItemId__c= pLI1.Id;
		 ConfigLineitems[i].Apttus_Config2__ProductId__c= prod1.Id;
		 ConfigLineitems[i].Apttus_Config2__LineStatus__c='New';
		 ConfigLineitems[i].Apttus_Config2__PriceListId__c = priceList.Id;
		 ConfigLineitems[i].Apttus_Config2__ChargeType__c = 'Standard Price';
		 ConfigLineitems[i].Apttus_Config2__LineType__c = 'Product/Service';
		 ConfigLineitems[i].Apttus_Config2__PriceMethod__c = 'Per Unit';
		 ConfigLineitems[i].Apttus_Config2__Frequency__c = 'One Time';
		 ConfigLineitems[i].Apttus_Config2__BasePrice__c=4427;
		 ConfigLineitems[i].Apttus_Config2__PriceIncludedInBundle__c=false;
		 ConfigLineitems[i].Apttus_Config2__PrimaryLineNumber__c = 1;
		 ConfigLineitems[i].Apttus_Config2__NetPrice__c=120;
	
	 }
	 //ConfigLineitems[0].Flexible_group_code__c='SOLUTION001';
	 ConfigLineitems[0].cpq_market_model__c = 'test1';
	 insert ConfigLineitems;
		Apttus_Proposal__Proposal__c prop = [select id from Apttus_Proposal__Proposal__c limit 1];
		Apttus_Config2__ProductConfiguration__c config = [select id from Apttus_Config2__ProductConfiguration__c limit 1];
		Apttus_Config2.CPQWebService.finalizeConfiguration(config.Id);
		//Apttus_Config2.CPQWebService.finalizeConfigurationAndSync(config.Id,  null, 'PostSyncCartQJob');
		CPQ_ProgressBarController.checkIfValidTransaction(prop.Id);
		CPQ_ProgressBarController.checkJobStatus(prop.Id);
	}

}