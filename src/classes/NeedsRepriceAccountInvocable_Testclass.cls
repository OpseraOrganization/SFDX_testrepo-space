@isTest(SeeAllData = false)
private class NeedsRepriceAccountInvocable_Testclass {

	static testMethod void needsRepriceAccountInvocable_testMethod1() {
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		List<String> accId=new List<String>();
		accId.add(accounts[0].id);	 
		
		  test.startTest();
		  NeedsRepriceAccountInvocable.updateQuotes(accId);
		  test.stopTest();
	}
	static testmethod void needsRepriceBatch_testMethod()
	{
		   
		   //create a Account
			List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
			accounts[0].Acc_No__c = 'Test101';
			accounts[0].NokiaCPQ_Applicable_Price_Lists__c = 'Test';
			insert accounts;
			   system.debug('accountinserted--->'+accounts);
			
		
			List<String> accId=new List<String>();
			accId.add(accounts[0].id); 
		
			//Create an Opportunity
			List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
			opportunities[0].PSR_Pre_Sales_Risk_Opportunity_Type__c ='test';
			opportunities[0].SWx_Upsell_Proposal__c = null;
			opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Direct Sales Opportunity').getRecordTypeId();
			insert opportunities; 
			system.debug('opportunities--->'+opportunities);
			
			//Create Accreditations
			List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditationforProd(2);
			accreditations[0].partner__c = accounts[0].Id;
			accreditations[1].partner__c = accounts[0].Id;
			accreditations[0].Accreditation_Type__c = 'Maintenance';
			accreditations[0].Accreditation_Level__c = 'Authorized - Accreditation In Progress';
			insert accreditations;
		
			system.debug('accreditations--->'+accreditations);
		
			Test.startTest();
			
			Apttus_Config2__PriceList__c plist = new Apttus_Config2__PriceList__c();
			plist.Name = 'Test';
			plist.CurrencyIsoCode = 'EUR';
			plist.Apttus_Config2__Active__c  = true;
			plist.PriceList_Type__c = 'Direct';
			//insert plist;
		 
			Apttus_Config2__PriceList__c plist2 = new Apttus_Config2__PriceList__c();
			plist2.Name = 'Test1' ;
			plist2.CurrencyIsoCode = 'EUR';
			plist2.Apttus_Config2__Active__c  = true;
			plist2.PriceList_Type__c = 'Direct';
		 List<Apttus_Config2__PriceList__c> priceList = new List<Apttus_Config2__PriceList__c>{plist,plist2};
			insert priceList;
		
			
	 
			//create a quote
			List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
			proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Direct Quote').getRecordTypeId(); 
			proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
			proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
			proposals[0].NokiaCPQ_Needs_Reprice__c = true;
			proposals[0].Reprice_In_Progress__c = false;
			proposals[0].Apttus_Proposal__Approval_Stage__c = 'Rejected';
			proposals[0].CurrencyIsoCode = 'EUR';
			proposals[0].NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)';
			proposals[0].NokiaCPQ_No_of_Years__c ='1'; 
			insert proposals;
		   // system.debug('proposals--->'+proposals);	 
				
		
			accreditations[0].Accreditation_Level__c = 'Basic';
			accreditations[0].Reason_for_Level_Change__c = 'Change in Business Plan';
			update accreditations;
			system.debug('accreditations upsert--->'+accreditations);
			
			accounts[0].NokiaCPQ_Applicable_Price_Lists__c = 'Test,Test1';
			update accounts;
			NeedsRepriceAccountInvocable.updateQuotes(accId);
			Test.stopTest();	 
	}
	static testmethod void needsRepriceBatch_testMethod22()
	{
		   
		   //create a Account
			List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
			accounts[0].Acc_No__c = 'Test101';
			accounts[0].NokiaCPQ_Applicable_Price_Lists__c = 'Test';
			insert accounts;
			   system.debug('accountinserted--->'+accounts);
			
		
			List<String> accId=new List<String>();
			accId.add(accounts[0].id); 
		
			//Create an Opportunity
			List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
			opportunities[0].PSR_Pre_Sales_Risk_Opportunity_Type__c ='test';
			opportunities[0].SWx_Upsell_Proposal__c = null;
			opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Direct Sales Opportunity').getRecordTypeId();
			insert opportunities; 
			system.debug('opportunities--->'+opportunities);
			
			//Create Accreditations
			List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditationforProd(2);
			accreditations[0].partner__c = accounts[0].Id;
			accreditations[1].partner__c = accounts[0].Id;
			accreditations[0].Accreditation_Type__c = 'Maintenance';
			accreditations[0].Accreditation_Level__c = 'Authorized - Accreditation In Progress';
			insert accreditations;
		
			system.debug('accreditations--->'+accreditations);
		
			Test.startTest();
		
			Apttus_Config2__PriceList__c plist = new Apttus_Config2__PriceList__c();
			plist.Name = 'Test';
			plist.CurrencyIsoCode = 'EUR';
			plist.Apttus_Config2__Active__c  = true;
			plist.PriceList_Type__c = 'Direct';
			//insert plist;
		 
			Apttus_Config2__PriceList__c plist2 = new Apttus_Config2__PriceList__c();
			plist2.Name = 'Test1' ;
			plist2.CurrencyIsoCode = 'EUR';
			plist2.Apttus_Config2__Active__c  = true;
			plist2.PriceList_Type__c = 'Direct';
		
			Apttus_Config2__PriceList__c plist3 = new Apttus_Config2__PriceList__c();
			plist3.Name = 'Global Price List' ;
			plist3.CurrencyIsoCode = 'EUR';
			plist3.Apttus_Config2__Active__c  = true;
			plist3.PriceList_Type__c = 'CPQ';
			List<Apttus_Config2__PriceList__c> priceList = new List<Apttus_Config2__PriceList__c>{plist,plist2,plist3};
			insert priceList;
	   
		  
			//create a quote
			List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
			proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Direct Quote').getRecordTypeId(); 
			proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
			proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
			proposals[0].NokiaCPQ_Needs_Reprice__c = true;
			proposals[0].Reprice_In_Progress__c = false;
			proposals[0].Apttus_Proposal__Approval_Stage__c = 'Rejected';
			proposals[0].CurrencyIsoCode = 'EUR';
			proposals[0].NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)';
			proposals[0].NokiaCPQ_No_of_Years__c ='1';
		   // proposals[0].Apttus_QPConfig__PriceListId__c = priceList[0].Id;
			insert proposals;
		   // system.debug('proposals--->'+proposals);	 
			
			accreditations[0].Accreditation_Level__c = 'Basic';
			accreditations[0].Reason_for_Level_Change__c = 'Change in Business Plan';
			update accreditations;
			system.debug('accreditations upsert--->'+accreditations);
			
			accounts[0].NokiaCPQ_Applicable_Price_Lists__c = '';
			update accounts;
			NeedsRepriceAccountInvocable.updateQuotes(accId);
			Test.stopTest();	 
	}
}