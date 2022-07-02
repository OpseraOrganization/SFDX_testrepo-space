@isTest
public with sharing class CH_InterfaceMappingDetailPanelCtrlTest {
	@isTest
	public static void updateInterfaceMappingRecordTestInsert() {
		List<Schema.PicklistEntry> picklistEntries = new List<PicklistEntry>(CH_Case_PA_InterfaceMapping__c.CaseOriginSystem__c.getDescribe().getPicklistValues());

		CH_Case_PA_InterfaceMapping__c im = new CH_Case_PA_InterfaceMapping__c(
			Name = 'updateInterfaceMappingRecordTestInsert',
			CaseOriginSystem__c = picklistEntries[0].getValue()
		);

		Test.startTest();
		String result = CH_InterfaceMappingDetailPanelController.upsertInterfaceMappingRecord(im);
		Test.stopTest();

		System.assertEquals('', result);
		System.assertNotEquals(null, [SELECT Id FROM CH_Case_PA_InterfaceMapping__c WHERE Name = :im.Name]);
	}

	@isTest
	public static void updateInterfaceMappingRecordTestUpdate() {
		List<Schema.PicklistEntry> picklistEntries = new List<PicklistEntry>(CH_Case_PA_InterfaceMapping__c.CaseOriginSystem__c.getDescribe().getPicklistValues());

		CH_Case_PA_InterfaceMapping__c im = new CH_Case_PA_InterfaceMapping__c(
			Name = 'updateInterfaceMappingRecordTestUpdate',
			CaseOriginSystem__c = picklistEntries[0].getValue()
		);

		insert im;

		im.Name = 'test';

		Test.startTest();
		String result = CH_InterfaceMappingDetailPanelController.upsertInterfaceMappingRecord(im);
		Test.stopTest();

		System.assertEquals('', result);
		System.assertEquals(im.Name, [SELECT Name FROM CH_Case_PA_InterfaceMapping__c WHERE Id = :im.Id].Name);
	}

	@isTest
	public static void updateInterfaceMappingRecordTestError() {
		CH_Case_PA_InterfaceMapping__c im = new CH_Case_PA_InterfaceMapping__c(Name = 'test');

		Test.startTest();
		String result = CH_InterfaceMappingDetailPanelController.upsertInterfaceMappingRecord(im);
		Test.stopTest();

		System.assertNotEquals('', result);
	}

	@isTest
	public static void getCaseOriginSystemValuesTest() {
		List<Schema.PicklistEntry> picklistEntries = new List<PicklistEntry>(CH_Case_PA_InterfaceMapping__c.CaseOriginSystem__c.getDescribe().getPicklistValues());

		Test.startTest();
		String JSONString = CH_InterfaceMappingDetailPanelController.getCaseOriginSystemValues();
		Test.stopTest();

		List<CH_InterfaceMappingDetailPanelController.InputSelectPicklistValue> picklistValues =
			(List<CH_InterfaceMappingDetailPanelController.InputSelectPicklistValue>)JSON.deserialize(
				JSONString,
				List<CH_InterfaceMappingDetailPanelController.InputSelectPicklistValue>.class
			);

		for (Schema.PicklistEntry aPicklistEntry : picklistEntries) {
			if (aPicklistEntry.isActive()) {
				Boolean success = false;

				for (CH_InterfaceMappingDetailPanelController.InputSelectPicklistValue aPicklistValue : picklistValues) {
					if (aPicklistValue.label == aPicklistEntry.getLabel() && aPicklistValue.value == aPicklistEntry.getValue()) {
						success = true;
						break;
					}
				}

				System.assert(success, 'JSON has no entry for a picklist value: ' + aPicklistEntry.getLabel());
			}
		}
	}

}