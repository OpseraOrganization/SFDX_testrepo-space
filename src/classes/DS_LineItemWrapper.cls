/**
* @description A wrapper class to store all the needed attributes for Quote/Proposal Line Items
*/
public with sharing class DS_LineItemWrapper {
	@AuraEnabled public String accountName;
	@AuraEnabled public String accountNumber;
	@AuraEnabled public String configType;
	@AuraEnabled public String currencyIsoCode;
	@AuraEnabled public String customerGroupingName;
	@AuraEnabled public String externalDescription;
	@AuraEnabled public String externalReference;
	@AuraEnabled public String lineType;
	@AuraEnabled public Decimal netPrice;
	@AuraEnabled public Date PODate;
	@AuraEnabled public String PONumber;
	@AuraEnabled public String productCode;
	@AuraEnabled public String productDescription;
	@AuraEnabled public Decimal quantity;
	@AuraEnabled public String quoteId;
	@AuraEnabled public String quoteLineItemId;
	@AuraEnabled public String quoteNumber;
	@AuraEnabled public String soldToPartyName;
	@AuraEnabled public String soldToPartyNumber;
	@AuraEnabled public String stage;

	@AuraEnabled public List<DS_ListWrapper> itemAttributes;
}