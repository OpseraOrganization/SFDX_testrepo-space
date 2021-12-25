@isTest
private class NCP_Product2TriggerHandler_Test {

	@isTest
	static void TestDeleteRecord() {
		Product2 pr = NCP_TestFactory.createProduct();
		Account acc = NCP_TestFactory.createAccount();
		User admin = NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev');
		NCP_Favorite_Product__c fp = NCP_TestFactory.createFavoriteProduct(pr, admin);
		Test.startTest();
		delete pr;
		Test.stopTest();
	}

	@isTest
	static void TestInsertPricebookEntries() {

		PriceBook2 standardPriceBook = new PriceBook2(name='Standard Price Book', isActive = true);
		PriceBook2 cdbPriceBook = new PriceBook2(name='CDB Price Book', isActive = true);
		PriceBook2 caresPriceBook = new PriceBook2(name='CARES Price Book', isActive = true);
		insert standardPriceBook;
		insert cdbPriceBook;
		insert caresPriceBook;

		Product2 pr = new Product2();
		pr.Name = 'TEST PRODUCT';
		pr.Family = 'Hardware';
		pr.IsActive = true;
		pr.NCP_Origin__c = 'OLCS';
		//pr.NCP_Product_Content_Count__c = 1;

		pr.NokiaCPQ_State__c = 'Available';
		pr.PMD_PRODUCT_ITEM_TYPE__C = 'Design Item';
		pr.NCP_CAREACTIVATE__c = 'true';
		pr.NCP_ALTERNATE_CODE2__c = 'XYZ-1234567890';
		pr.NCP_Nokia_Product_Id__c = 'ABC-12345678901';

		Test.startTest();
		NCP_Product2TriggerHandler.forcePBEupsert = true; // guarantee the upsertPricebookEntries is called
		insert pr;
		NCP_Product2TriggerHandler.forcePBEupsert = false; // stop it again

		upsert pr;
		Test.stopTest();
		pr.recalculateFormulas();

		Id stdPricebookId = Test.getStandardPricebookId();
		list<PricebookEntry> listPBEs = [SELECT id, CurrencyIsoCode, isActive, NCP_External_ID__c FROM PricebookEntry WHERE Pricebook2Id = :stdPricebookId AND Product2Id = :pr.Id];

		System.assertEquals(1, listPBEs.size(), 'Expected 1 PriceBookEntry');
		PriceBookEntry PBE = listPBEs[0];
		string expectedID = 'Standard Price Book-' + pr.NCP_Nokia_Product_Id__c;
		System.assertEquals(expectedID, PBE.NCP_External_ID__c, 'Incorrect NCP_External_ID__c');

	}
	@isTest
	static void TestUpdatePricebookEntries() {
		PriceBook2 standardPriceBook = new PriceBook2(name='Standard Price Book', isActive = true);
		PriceBook2 cdbPriceBook = new PriceBook2(name='CDB Price Book', isActive = true);
		PriceBook2 caresPriceBook = new PriceBook2(name='CARES Price Book', isActive = true);
		insert standardPriceBook;
		insert cdbPriceBook;
		insert caresPriceBook;
		Id stdPricebookId = Test.getStandardPricebookId();

		Product2 pr = new Product2();
		pr.Name = 'TEST PRODUCT';
		pr.Family = 'Hardware';
		pr.IsActive = true;
		pr.NCP_Origin__c = 'OLCS';
		//pr.NCP_Product_Content_Count__c = 1;

		pr.NokiaCPQ_State__c = 'Available';
		pr.PMD_PRODUCT_ITEM_TYPE__C = 'Design Item';
		//pr.NCP_CAREACTIVATE__c = 'false';
		pr.NCP_Nokia_Product_Id__c = 'ABC-1234567890';
		pr.NCP_ALTERNATE_CODE2__c = 'XYZ-12345678901';
		pr.NCP_CAREACTIVATE__c = 'true';
		NCP_Product2TriggerHandler.forcePBEupsert = true;
		insert pr;
		NCP_Product2TriggerHandler.forcePBEupsert = false;

		//list<PricebookEntry> listPBEs = [SELECT id, CurrencyIsoCode, isActive, NCP_External_ID__c FROM PricebookEntry WHERE Product2Id = :pr.Id];
		//DELETE listPBEs; // Delete pricebook entries (if any exists)

		// update the product to trigger creation of pricebook entry
		pr.PMD_PRODUCT_ITEM_TYPE__C = 'Design Item';
		pr.NCP_CAREACTIVATE__c = 'true';

		Test.startTest();
		NCP_Product2TriggerHandler.forcePBEupsert = true; // guarantee the upsertPricebookEntries is called
		update pr;
		NCP_Product2TriggerHandler.forcePBEupsert = false; // stop it again
		Test.stopTest();

		// check new PBE is created for the updated product
		list<PricebookEntry> listPBEs = [SELECT id, CurrencyIsoCode, isActive, NCP_External_ID__c FROM PricebookEntry WHERE Pricebook2Id = :stdPricebookId AND Product2Id = :pr.Id];

		System.assertEquals(1, listPBEs.size(), 'Expected 1 PriceBookEntry');
		PriceBookEntry PBE = listPBEs[0];
		pr.recalculateFormulas();
		string expectedID = 'Standard Price Book-' + pr.NCP_Nokia_Product_Id__c;
		//string expectedID = 'CARES Price Book-' + pr.NCP_NOKIA_EXT_PRODUCT_CODE__c;
		System.assertEquals(expectedID, PBE.NCP_External_ID__c, 'Incorrect NCP_External_ID__c');


	}

}