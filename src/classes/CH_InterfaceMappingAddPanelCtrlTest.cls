@isTest
public with sharing class CH_InterfaceMappingAddPanelCtrlTest {
	@testSetup static void setup() {
		CH_Case_PA_InterfaceMapping__c im = new CH_Case_PA_InterfaceMapping__c();
		im.CaseOriginSystem__c = 'orange-irma';
		insert im;
	}
	@isTest
	public static void getImListTest() {
		Test.startTest();
		List<CH_Case_PA_InterfaceMapping__c> imList = CH_InterfaceMappingAddPanelController.getImList();
		Test.stopTest();

		System.assertEquals(imList.size(), 1);
	}

	@isTest
	public static void deleteImRecordTest() {
		Test.startTest();
		List<CH_Case_PA_InterfaceMapping__c> imList = CH_InterfaceMappingAddPanelController.getImList();
		CH_InterfaceMappingAddPanelController.deleteImRecord(imList[0].Id);
		Test.stopTest();

		System.assertEquals([SELECT Id FROM CH_Case_PA_InterfaceMapping__c WHERE Id =: imList[0].Id].size(), 0);
	}

	@isTest
	public static void getCsvBase64Test() {
		Test.startTest();
		String csvTest = CH_InterfaceMappingAddPanelController.getCsvBase64();
		Test.stopTest();

		System.assert(csvTest.length() > 0);
	}

}