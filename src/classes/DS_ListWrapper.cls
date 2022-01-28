/**
* @description A wrapper class to store label-value pairs for lists in Quote Proposal list components
*/
public with sharing class DS_ListWrapper {

	@AuraEnabled public String label;
	@AuraEnabled public String value;

	public DS_ListWrapper(String pLabel, String pValue) {
		label = pLabel;
		value = pValue;
	}
}