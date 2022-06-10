public with sharing class CH_InterfaceMappingDetailPanelController {
	@AuraEnabled
	public static String upsertInterfaceMappingRecord(CH_Case_PA_InterfaceMapping__c record) {
		try {
			Database.UpsertResult ur = Database.upsert(record);
			return ur.isSuccess() ? '' : ur.getErrors()[0].getMessage();
		} catch (DmlException e) {
			return e.getDmlMessage(0);
		}
	}

	@AuraEnabled
	public static String getCaseOriginSystemValues() {
		Schema.DescribeFieldResult fieldResult = CH_Case_PA_InterfaceMapping__c.CaseOriginSystem__c.getDescribe();

		List<InputSelectPicklistValue> result = new List<InputSelectPicklistValue>();

		for (Schema.PicklistEntry aPicklistEntry : fieldResult.getPicklistValues()) {
			if (aPicklistEntry.isActive()) {
				result.add(new InputSelectPicklistValue(aPicklistEntry.getValue(), aPicklistEntry.getLabel()));
			}
		}

		return JSON.serialize(result);
	}

	@testVisible
	private class InputSelectPicklistValue {
		public String label = null;
		public String value = null;

		public InputSelectPicklistValue(String value, String label) {
			this.label = label;
			this.value = value;
		}
	}
}