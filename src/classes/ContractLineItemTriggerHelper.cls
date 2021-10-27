/**
 * Created by tweinberger on 06/09/2018.
 */

public with sharing class ContractLineItemTriggerHelper {

	/*
		Description : Before Insert
	*/
	public static void createBeforeInsertContractLineItem(List<ContractLineItem> newContractLineItemList) {

		//if(trigger.isInsert && trigger.isBefore){
		system.debug('CLI Trigger IN Before Insert ');
		Set<String> externalPBEIdsSet = new Set<String>();
		List<PricebookEntry> PriceBookEntriesList = new List<PricebookEntry>();
		Map<String, Id> priceBookEntryMap = new Map<String, Id>();

		for (ContractLineItem newCLI : newContractLineItemList) {
			system.debug('CLI Trigger IN Before Insert newCLI.PricebookEntryId=' + newCLI.PricebookEntryId);
			if (newCLI.PricebookEntryId == null && newCLI.ExternalPricebookEntryId__c != null) {
				system.debug('newCLI.NCP_Product_ID__c=' + newCLI.ExternalPricebookEntryId__c);
				externalPBEIdsSet.add(newCLI.ExternalPricebookEntryId__c);
			}
		}

		system.debug('externalPBEIdsSet.size()= ' + externalPBEIdsSet.size());
		if (externalPBEIdsSet.size() != 0) {
			PriceBookEntriesList = [
					SELECT id, NCP_External_ID__c
					FROM PricebookEntry
					WHERE NCP_External_ID__c
							IN :externalPBEIdsSet
			];
			system.debug('PriceBookEntriesList= ' + PriceBookEntriesList);

			for (PricebookEntry pbe : PriceBookEntriesList) {
				priceBookEntryMap.put(pbe.NCP_External_ID__c, pbe.Id);
			}

			for (ContractLineItem newCLI : newContractLineItemList) {
				Id value = priceBookEntryMap.get(newCLI.ExternalPricebookEntryId__c);
				if (value != null) {
					newCLI.PricebookEntryId = value;
				}
			}
		}
	}
}