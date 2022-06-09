public without sharing class priceIncludedOptionBatch implements Database.Batchable<sObject>{
	
	public static string query;
	
	public static void execute() {
		Database.executeBatch(new priceIncludedOptionBatch(), 1);
	}

	public Database.QueryLocator start(Database.BatchableContext BC){
		if(query == null || query == '') {
			query = 'SELECT Id,NokiaCPQ_Static_Bundle_Option__c FROM product2 WHERE NokiaCPQ_Static_Bundle_Option__c = true AND IsActive = true ';
		}
		return Database.getQueryLocator(query);
	}

	public void execute(Database.BatchableContext BC, List<product2> scope){
		map<Id,Id> optionComponentOptionProduct = new map<Id,Id>();
		list<Apttus_Config2__ProductOptionPrice__c> popList = new list<Apttus_Config2__ProductOptionPrice__c>();
		list<Apttus_Config2__PriceListItem__c> pliList = new list<Apttus_Config2__PriceListItem__c>();
		for(Apttus_Config2__ProductOptionComponent__c poc : [SELECT Id,Name,Apttus_Config2__ParentProductId__c, 
																Apttus_Config2__ComponentProductId__c  
																FROM Apttus_Config2__ProductOptionComponent__c
																WHERE Apttus_Config2__ParentProductId__c =: scope[0].Id]) {
			
			optionComponentOptionProduct.put(poc.Apttus_Config2__ComponentProductId__c,poc.Id);
		}
		set<String> exisitingPop = new set<String>();
		for(Apttus_Config2__ProductOptionPrice__c popSO : [SELECT Id,Apttus_Config2__PriceListId__c,Apttus_Config2__ProductOptionId__c 
															FROM Apttus_Config2__ProductOptionPrice__c
															WHERE Apttus_Config2__ProductOptionId__c IN : optionComponentOptionProduct.values()]) {
							
			exisitingPop.add(popSO.Apttus_Config2__ProductOptionId__c+''+popSO.Apttus_Config2__PriceListId__c);
		}
		//get all the price list and price list items Ids of each optionComponentOptionProduct
		for(Apttus_Config2__PriceListItem__c pliSO : [SELECT Id,Apttus_Config2__PriceListId__c,Apttus_Config2__PriceIncludedInBundle__c,
														Apttus_Config2__ProductId__c
														FROM Apttus_Config2__PriceListItem__c
														WHERE Apttus_Config2__ProductId__c IN : optionComponentOptionProduct.keySet()]) {
			
			
			string existingCheck = optionComponentOptionProduct.get(pliSO.Apttus_Config2__ProductId__c)+''+pliSO.Apttus_Config2__PriceListId__c;
			if(!exisitingPop.contains(existingCheck)) {
	pliSO.Apttus_Config2__PriceIncludedInBundle__c = true;
				Apttus_Config2__ProductOptionPrice__c pop = new Apttus_Config2__ProductOptionPrice__c();
				pop.Apttus_Config2__PriceListId__c = pliSO.Apttus_Config2__PriceListId__c;
				pop.Apttus_Config2__AdjustmentAmount__c = 0;
				pop.Apttus_Config2__AdjustmentType__c = 'Price Override';
				pop.Apttus_Config2__ChargeType__c = 'Standard Price';
				pop.Apttus_Config2__IsQuantityReadOnly__c = true;
				pop.Apttus_Config2__PriceIncludedInBundle__c = true;
				pop.Apttus_Config2__PriceOverride__c = 0;
				pop.Apttus_Config2__ProductOptionId__c = optionComponentOptionProduct.get(pliSO.Apttus_Config2__ProductId__c);
				pop.Apttus_Config2__RollupPriceToBundle__c = true;
				pop.Apttus_Config2__Sequence__c = 1;
				popList.add(pop);
	pliList.add(pliSO);
			}
		}
		if(!pliList.isEmpty()) {
			update pliList;
		}
		if(!popList.isEmpty()) {
			insert popList;
		}
	}

	public void finish(Database.BatchableContext BC){
	}
}