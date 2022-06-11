/**	
About   
-----
Description: Controller called from produact2Trigger

Created for: Nokia Customer Portal 
Created date: 01 31 2018

Details / Methods   
-----------------	
beforeDeleteOperation - Used to get product Id's from favorite products sObject
upsertPricebookEntries - Automatic creation of Pricebook entries (EUR) in the standard pricebook if certain criterias are fullfilled: PMD_PRODUCT_ITEM_TYPE__C in ('Design Item','Service Design Item') AND NokiaCPQ_State__c not in ('Obsolete','Rejected') AND NCP_CAREACTIVATE__c!=''

Update History	
--------------	

Updated date: 06 20 2018 â€“ AES 
Updated date: 08 23 2018 â€“ AHOYBYE, added method for automatic creation of PriceBookEntries (upsertPricebookEntries) - called from ProductTrigger

Issues / TODOs  
--------------
**/


public class NCP_Product2TriggerHandler {
	private static ID standardPricebookId = Test.isRunningTest() ? Test.getStandardPricebookId() : [select Id from Pricebook2 where name = 'Standard Price Book'].Id;
	//private static ID cdbPricebookId = Test.isRunningTest() ? Test.getStandardPricebookId() : [select Id from Pricebook2 where name = 'CDB Price Book'].Id;
	//private static ID caresPricebookId = Test.isRunningTest() ? Test.getStandardPricebookId() : [select Id from Pricebook2 where name = 'CARES Price Book'].Id;
	
	@TestVisible private static boolean forcePBEupsert = false;  // use by test method to ensure upsertPricebookEntries is called - regardless of formula value

	public static void beforeDeleteOperation(Set<Id> product2Set) {	   
		// Delete favorite records related to the product
		List<NCP_Favorite_Product__c> favoriteProducts = [select NCP_Product_Id__c from NCP_Favorite_Product__c WHERE NCP_Product_Id__c IN :product2Set];
		if (!Schema.sObjectType.NCP_Favorite_Product__c.isDeletable()) {
			System.debug(LoggingLevel.Error, 'you don\'t have access to delete Favorite Product');
		} else {
			delete favoriteProducts;
		}
		// Delete product content records related to the product  
		List<NCP_Product_Content__c> contentProducts = [SELECT Id,NCP_Service__c FROM NCP_Product_Content__c where NCP_Product__c IN :product2Set];
		if (!Schema.sObjectType.NCP_Product_Content__c.isDeletable()) {
			System.debug(LoggingLevel.Error, 'you don\'t have access to delete Favorite Product');
		} else {
			delete contentProducts;
		}
	}

	public static void upsertPricebookEntries(List<Product2> products) {
		ID cdbPricebookId = null;
		ID caresPricebookId = null;
		List<Pricebook2> priceBooks = [select Id, name from Pricebook2 where name in ('CDB Price Book', 'CARES Price Book')];
		for (Pricebook2 pb : priceBooks) {
			if(pb.Name == 'CDB Price Book'){
			   cdbPricebookId = pb.Id; 
			}
			if(pb.Name == 'CARES Price Book'){
				   caresPricebookId = pb.Id; 
			}
		} 

		List<PricebookEntry> pbEntriesToUpsert = new List<PricebookEntry>();

		List<Id> ProductIdList = new List<Id>();
		for (Product2 product : products) {
			System.debug('product.createStdPriceBookEntry__c= ' + product.createStdPriceBookEntry__c);
			if (forcePBEupsert || product.createStdPriceBookEntry__c) {
				ProductIdList.add(product.Id);
			}
		}

		// get a list of product existing in the standard price book
		Map<Id, PricebookEntry> pbExistingStandardMap = new Map<Id, PricebookEntry>();
		List<PricebookEntry> pbExistingStandardList = [SELECT id, Product2Id, isActive FROM PricebookEntry WHERE Pricebook2Id = :standardPricebookId AND Product2Id = :ProductIdList AND CurrencyIsoCode = 'EUR'];
		for (PriceBookEntry pbe : pbExistingStandardList) {
			pbExistingStandardMap.put(pbe.Product2Id, pbe);
		}
		// get a list of product existing in the CDB price book
		Map<Id, PricebookEntry> pbExistingCDBMap = new Map<Id, PricebookEntry>();
		List<PricebookEntry> pbExistingCDBList = [SELECT id, Product2Id, isActive FROM PricebookEntry WHERE Pricebook2Id = :cdbPricebookId AND Product2Id = :ProductIdList AND CurrencyIsoCode = 'EUR'];
		for (PriceBookEntry pbe : pbExistingCDBList) {
			pbExistingCDBMap.put(pbe.Product2Id, pbe);
		}
		// get a list of product existing in the CARES price book
		Map<Id, PricebookEntry> pbExistingCARESMap = new Map<Id, PricebookEntry>();
		List<PricebookEntry> pbExistingCARESList = [SELECT id, Product2Id, isActive FROM PricebookEntry WHERE Pricebook2Id = :caresPricebookId AND Product2Id = :ProductIdList AND CurrencyIsoCode = 'EUR'];
		for (PriceBookEntry pbe : pbExistingCARESList) {
			pbExistingCARESMap.put(pbe.Product2Id, pbe);
		}

		for (Product2 pr : products) {
			if (forcePBEupsert || pr.createStdPriceBookEntry__c) {
				if (pr.NCP_Nokia_Product_Id__c != null) {
					if (pbExistingStandardMap.containsKey(pr.Id)) {
						PricebookEntry pbe = pbExistingStandardMap.get(pr.Id);
						pbe.NCP_External_ID__c = 'Standard Price Book-' + pr.NCP_Nokia_Product_Id__c;
						pbe.UnitPrice = 1;
						pbEntriesToUpsert.add(pbe);
					} else {
						pbEntriesToUpsert.add(new PricebookEntry(Pricebook2Id = standardPricebookId, Product2Id = pr.Id, UnitPrice = 1, IsActive = true, CurrencyIsoCode = 'EUR', NCP_External_ID__c = 'Standard Price Book-' + pr.NCP_Nokia_Product_Id__c));
					}
					if (pbExistingCDBMap.containsKey(pr.Id)) {
						PricebookEntry pbe = pbExistingCDBMap.get(pr.Id);
						pbe.NCP_External_ID__c = 'CDB Price Book-' + pr.NCP_Nokia_Product_Id__c;
						pbe.UnitPrice = 1;
						pbEntriesToUpsert.add(pbe);
					} else {
						pbEntriesToUpsert.add(new PricebookEntry(Pricebook2Id = cdbPricebookId, Product2Id = pr.Id, UnitPrice = 1, IsActive = true, CurrencyIsoCode = 'EUR', NCP_External_ID__c = 'CDB Price Book-' + pr.NCP_Nokia_Product_Id__c));
					}

				}
				if (pr.NCP_ALTERNATE_CODE2__c != null) {
					if (pbExistingCARESMap.containsKey(pr.Id)) {
						PricebookEntry pbe3 = pbExistingCARESMap.get(pr.Id);
						pbe3.NCP_External_ID__c = 'CARES Price Book-' + pr.NCP_ALTERNATE_CODE2__c;
						pbe3.UnitPrice = 1;
						pbEntriesToUpsert.add(pbe3);
					} else {
						pbEntriesToUpsert.add(new PricebookEntry(Pricebook2Id = caresPricebookId, Product2Id = pr.Id, UnitPrice = 1, IsActive = true, CurrencyIsoCode = 'EUR', NCP_External_ID__c = 'CARES Price Book-' + pr.NCP_ALTERNATE_CODE2__c));
					}

				}
			}
		}

		if (pbEntriesToUpsert.size() > 0) {
			System.debug('pbEntriesToUpsert :: ' + pbEntriesToUpsert);
			Database.upsert(pbEntriesToUpsert, false);
		}
	}
}