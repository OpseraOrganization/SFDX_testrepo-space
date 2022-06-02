public with sharing class QTO_CDLineItemsService {
	public void onBeforeUpdate(Map<Id, Customer_Document_Line_Items__c> newRecordsDataById, Map<Id, Customer_Document_Line_Items__c> oldRecordsDataById) {
		List<Customer_Document_Line_Items__c> manuallyEnrichedLines = new List<Customer_Document_Line_Items__c>();
		for (Customer_Document_Line_Items__c eachCDLineItem : newRecordsDataById.values()) {
			// filter manually enriched cd lines
			if(isManuallyEnriched(eachCDLineItem, oldRecordsDataById.get(eachCDLineItem.Id))){
				manuallyEnrichedLines.add(eachCDLineItem);
			}
		}
		autoPopulateFields(manuallyEnrichedLines);
	}

	@TestVisible
	private Boolean isManuallyEnriched(Customer_Document_Line_Items__c newRecord, Customer_Document_Line_Items__c oldRecord) {
		return newRecord.Status__c == 'Manually-Enriched(Lines)' && newRecord.Status__c <> oldRecord.Status__c;
	}

	@TestVisible
	private Map<Id, Apttus_Config2__PriceListItem__c> getPriceListItemsById(List<Id> priceListItemIds) {
		return new Map<Id, Apttus_Config2__PriceListItem__c>(
			[
				SELECT Id, Apttus_Config2__ProductId__c,
				DS_Grouping_Name__c, Apttus_Config2__ProductCode__c,
				Apttus_Config2__ContractItemNumber__c
				FROM Apttus_Config2__PriceListItem__c
				WHERE Id = :priceListItemIds
			]
		);
	}

	@TestVisible
	private Map<Id, Product2> getProductsById(List<Id> productIds) {
		return new Map<Id, Product2>([SELECT Id, ProductCode FROM Product2 WHERE Id = :productIds]);
	}
	
	@TestVisible
	private void autoPopulateFields(List<Customer_Document_Line_Items__c> customerDocumentLineItems) {
		if(customerDocumentLineItems == null || customerDocumentLineItems.isEmpty()) { return; }

		List<Id> productIds = new List<Id>();
		List<Id> priceListItemIds = new List<Id>();

		for (Customer_Document_Line_Items__c eachCustomerDocumentLineItem : customerDocumentLineItems) {
			if(eachCustomerDocumentLineItem.QTO_Product_Name__c <> null) { productIds.add(eachCustomerDocumentLineItem.QTO_Product_Name__c); }
			if(eachCustomerDocumentLineItem.Price_List_Item__c <> null) { priceListItemIds.add(eachCustomerDocumentLineItem.Price_List_Item__c); }
		}

		Map<Id, Apttus_Config2__PriceListItem__c> priceListItemsById = getPriceListItemsById(priceListItemIds);
		Map<Id, Product2> productsById = getProductsById(productIds) ;

		for (Customer_Document_Line_Items__c eachCustomerDocumentLineItem : customerDocumentLineItems) {
			eachCustomerDocumentLineItem.Contract_Item_Number__c = 
				String.isBlank(eachCustomerDocumentLineItem.Contract_Item_Number__c) &&
				priceListItemsById.get(eachCustomerDocumentLineItem.Price_List_Item__c) <> null
				? priceListItemsById.get(eachCustomerDocumentLineItem.Price_List_Item__c).Apttus_Config2__ContractItemNumber__c
				: eachCustomerDocumentLineItem.Contract_Item_Number__c; // priceListLineItem.Apttus_Config2__ContractItemNumber__c
			eachCustomerDocumentLineItem.QTO_Customer_Grouping__c = 
				String.isBlank(eachCustomerDocumentLineItem.QTO_Customer_Grouping__c) &&
				priceListItemsById.get(eachCustomerDocumentLineItem.Price_List_Item__c) <> null
				? priceListItemsById.get(eachCustomerDocumentLineItem.Price_List_Item__c).DS_Grouping_Name__c
				: eachCustomerDocumentLineItem.QTO_Customer_Grouping__c; // priceListLineItem.DS_Grouping_Name__c
			eachCustomerDocumentLineItem.QTO_Product_Code__c = 
				String.isBlank(eachCustomerDocumentLineItem.QTO_Product_Code__c) &&
				priceListItemsById.get(eachCustomerDocumentLineItem.Price_List_Item__c) <> null
				? priceListItemsById.get(eachCustomerDocumentLineItem.Price_List_Item__c).Apttus_Config2__ProductCode__c
				: productsById.get(eachCustomerDocumentLineItem.QTO_Product_Name__c)?.ProductCode;  // product.productcode
			eachCustomerDocumentLineItem.QTO_Product_Name__c = 
				eachCustomerDocumentLineItem.QTO_Product_Name__c == null &&
				priceListItemsById.get(eachCustomerDocumentLineItem.Price_List_Item__c) <> null
				? priceListItemsById.get(eachCustomerDocumentLineItem.Price_List_Item__c).Apttus_Config2__ProductId__c
				: eachCustomerDocumentLineItem.QTO_Product_Name__c;
		}
	}
}