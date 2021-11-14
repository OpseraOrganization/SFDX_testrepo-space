@isTest 
private class DS_DPSWXLineItemTest {
		Public static Id swxRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('SWx Upsell Proposal').getRecordTypeId();
   
	static testMethod void DS_DPSWXLineItemTest_1() {
		User sysAdminUser = TestDataFactory.createSystemAdminUser();
		   
		System.runAs(sysAdminUser){
		Account accountCreationDP = TestDataFactory.createAccount(1)[0];
		database.insert(accountCreationDP);
		
		Account acc = new Account();
		acc.Name='Legal Entity Account For Test';
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		acc.ParentId = accountCreationDP.Id;
		acc.AccountNumber = '100006843';
		database.insert(acc);
		
		Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c();
		agreement.Apttus__Account__c = accountCreationDP.Id;
		insert agreement;  
		 
		Product2 prod = TestDataFactory.productCreation(1)[0];
		prod.ProductCode = '1514211';
		insert prod;
		
		Product_Feature_Junction__c prodFeature = new Product_Feature_Junction__c();
		prodFeature.Product__c = prod.id;
		prodFeature.Is_New__c = true;
		insert prodFeature;
		
		
		SWx_Upsell_Proposal__c UpsellProposal=TestDataFactory.upsellList(1,accountCreationDP)[0];
		upsellProposal.Analytics_File_Refer_ID__c='GBR-61940-82356';
		upsellProposal.Analytics_Source__c='CXM';
		upsellProposal.Proposal_Recommendation_Type__c='renewal';
		upsellProposal.P20_Id__c=215616;
		upsellProposal.CurrencyIsoCode='EUR';
		upsellProposal.Sold_To_Party__c = accountCreationDP.Id;
		upsellProposal.Unweighted_Value__c=429052.07;
		upsellProposal.Account_ID__c=accountCreationDP.Id;
		upsellProposal.RecordTypeID=swxRecordTypeId;
	   // upsellProposal.Frame_Contract__c = agreement.ID;
		
		upsellProposal.DS_Show_In_Portal__c=true;
		upsellProposal.Ready_to_Convert__c = true;
		database.insert(UpsellProposal);
		
		SWx_Upsell_Items__c SWXLineItem = TestDataFactory.createUpsellItem(1,upsellProposal)[0];
		SWXLineItem.Quantity__c = 5;
		SWXLineItem.Feature_ID__c = '89763';
		SWXLineItem.SWx_Product_Code__c = '1514211';
		insert SWXLineItem;
		
		Test.startTest();								
			DS_DPSWXLineItem.getDPType(UpsellProposal.id);
			DS_DPSWXLineItem.method(UpsellProposal.id);
		Test.stopTest(); 

	}
	}
   static testMethod void DS_DPSWXLineItemTest_2() {
		User sysAdminUser = TestDataFactory.createSystemAdminUser();
		   
		System.runAs(sysAdminUser){
		Account accountCreationDP = TestDataFactory.createAccount(1)[0];
		database.insert(accountCreationDP);
		
		Account acc = new Account();
		acc.Name='Legal Entity Account For Test';
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		acc.ParentId = accountCreationDP.Id;
		acc.AccountNumber = '100006843';
		database.insert(acc);
		
		Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c();
		agreement.Apttus__Account__c = accountCreationDP.Id;
		insert agreement;

		 
		Product2 prod = TestDataFactory.productCreation(1)[0];
		prod.ProductCode = '151421';
		insert prod;
		
		Product_Feature_Junction__c prodFeature = new Product_Feature_Junction__c();
		prodFeature.Product__c = prod.id;
		prodFeature.Is_New__c = false;
		insert prodFeature;
		
		
		SWx_Upsell_Proposal__c UpsellProposal=TestDataFactory.upsellList(1,accountCreationDP)[0];
		upsellProposal.Analytics_File_Refer_ID__c='GBR-61940-82356';
		upsellProposal.Sold_To_Party__c = accountCreationDP.Id;
		upsellProposal.Analytics_Source__c='CXM';
		upsellProposal.Proposal_Recommendation_Type__c='renewal';
		upsellProposal.P20_Id__c=215616;
		upsellProposal.CurrencyIsoCode='EUR';
		upsellProposal.Unweighted_Value__c=429052.07;
		upsellProposal.Account_ID__c=accountCreationDP.Id;
		upsellProposal.RecordTypeID=swxRecordTypeId;
		upsellProposal.Frame_Contract__c = agreement.ID;
		
		upsellProposal.DS_Show_In_Portal__c=true;
		upsellProposal.Ready_to_Convert__c = true;
		database.insert(UpsellProposal);
		
		SWx_Upsell_Items__c SWXLineItem = TestDataFactory.createUpsellItem(1,upsellProposal)[0];
		SWXLineItem.Quantity__c = 5;
		SWXLineItem.Feature_ID__c = '89763';
		SWXLineItem.SWx_Product_Code__c = '1514211';
		insert SWXLineItem;
		
		Test.startTest();								
			DS_DPSWXLineItem.getDPType(UpsellProposal.id);
			DS_DPSWXLineItem.method(UpsellProposal.id);
		Test.stopTest(); 

	}
	}
}