/**
* @description A wrapper class to store all the needed attributes for Commercial Proposals (Quotes) List View
*/
public with sharing class DS_ProposalWrapper {
	@AuraEnabled public String id;
	@AuraEnabled public String qLink;
	@AuraEnabled public String name;				// Quote ID
	@AuraEnabled public String quoteNumber;		 // Quote Number
	@AuraEnabled public String proposalName;		// Quote Name

	@AuraEnabled public String aId;
	@AuraEnabled public String aLink;
	@AuraEnabled public String accountName;

	@AuraEnabled public String agreementName;
	@AuraEnabled public Date creationDate;
	@AuraEnabled public String quoteStage;
	@AuraEnabled public Boolean isDisabled;
	@AuraEnabled public String PONumber;
	@AuraEnabled public Date PODate;
	@AuraEnabled public Decimal grandTotal;
	@AuraEnabled public String currencyIsoCode;

	@AuraEnabled public String extraInfo;
	@AuraEnabled public String displayExtraInfo;
	@AuraEnabled public String extraInfoText;
	@AuraEnabled public String extraInfoButton;
	@AuraEnabled public String truncExtraInfo;

	@AuraEnabled public String technology;
	@AuraEnabled public String useCase;

	@AuraEnabled public String selectIcon;
	@AuraEnabled public String selectTitle;
	@AuraEnabled public Boolean selected;
	@AuraEnabled public String selectVariant;
}