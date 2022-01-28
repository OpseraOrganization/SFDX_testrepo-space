@istest 
public class NeedsRepricePriceListTest{
   static testmethod void directInitTest1(){
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		 insert accounts;	 
		
		//create opportunity with euro currency
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Direct Sales Opportunity').getRecordTypeId();
		opportunities[0].CurrencyIsoCode = 'EUR'; 
		insert opportunities; 
		
		//get a Price List
		Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
		priceList.Name='Global Price List (EUR)';
		priceList.CurrencyIsoCode='GBP';
		priceList.Apttus_Config2__Active__c=false;
		priceList.PriceList_Type__c='CPQ';
		priceList.Apttus_Config2__Type__c='Standard';
		insert priceList;

		//create a quote with non-euro currency
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].CurrencyIsoCode = 'EUR';
		proposals[0].Apttus_QPConfig__PriceListId__c = priceList.Id;
		proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Direct Quote').getRecordTypeId(); //direct quote
		insert proposals;  

		Quote_Reprice__c quoterep = new Quote_Reprice__c();
		quoterep.RecordTypeId = Schema.SObjectType.Quote_Reprice__c.getRecordTypeInfosByName().get('Price List').getRecordTypeId();
		quoterep.Price_List__c = priceList.Id;
		insert quoterep;	   
}
	static testmethod void directInitTest2(){
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		 insert accounts;	 
		
		//create opportunity with euro currency
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Direct Sales Opportunity').getRecordTypeId();
		opportunities[0].CurrencyIsoCode = 'EUR'; 
		insert opportunities; 
		
		//get a Price List
		Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
		priceList.Name='Global Price List (EUR)';
		priceList.CurrencyIsoCode='GBP';
		priceList.Apttus_Config2__Active__c=false;
		priceList.PriceList_Type__c='CPQ';
		priceList.Apttus_Config2__Type__c='Standard';
		priceList.PriceList_Type__c = 'Direct';
		insert priceList;

		//create a quote with non-euro currency
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].CurrencyIsoCode = 'EUR';
		proposals[0].Apttus_QPConfig__PriceListId__c = priceList.Id;
		proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Direct Quote').getRecordTypeId(); //direct quote
		insert proposals;  

		Quote_Reprice__c quoterep = new Quote_Reprice__c();
		quoterep.RecordTypeId = Schema.SObjectType.Quote_Reprice__c.getRecordTypeInfosByName().get('Price List').getRecordTypeId();
		quoterep.Price_List__c = priceList.Id;
		insert quoterep;	 
}

	static testmethod void marketPriceListTest1(){
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		 insert accounts;	  
		
		//create opportunity with euro currency
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Direct Sales Opportunity').getRecordTypeId();
		opportunities[0].CurrencyIsoCode = 'EUR'; 
		insert opportunities; 
		
		
		//get a Price List
		Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
		priceList.Name='LATAM Market Price List (EUR)';
		priceList.CurrencyIsoCode='EUR';
		priceList.Apttus_Config2__Active__c=True;
		priceList.PriceList_Type__c='Indirect Market';
		priceList.Apttus_Config2__Type__c='Standard';
		
		insert priceList;

		//create a quote with non-euro currency
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].CurrencyIsoCode = 'EUR';
		proposals[0].Apttus_QPConfig__PriceListId__c = priceList.Id;
		proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Direct Quote').getRecordTypeId(); //direct quote
		insert proposals;  

		Quote_Reprice__c quoterep = new Quote_Reprice__c();
		quoterep.RecordTypeId = Schema.SObjectType.Quote_Reprice__c.getRecordTypeInfosByName().get('Price List').getRecordTypeId();
		quoterep.Price_List__c = priceList.Id;
		insert quoterep;
		   
		
		
}
}