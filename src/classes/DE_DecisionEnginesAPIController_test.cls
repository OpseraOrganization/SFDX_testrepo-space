@isTest
public class DE_DecisionEnginesAPIController_test {
	@isTest static void testMethod1(){ 
		Apttus__DocumentVersion__c doc = new Apttus__DocumentVersion__c();
		doc.Name='Test';
		doc.Apttus__Title__c='Test';
		doc.Apttus__LatestVersion__c='One';
		insert doc;
		PageReference testPage = Page.DE_DecisionEnginesAPI; 
		Test.setCurrentPage(testPage);
		testPage.getParameters().put('Id', String.valueOf(doc.Id));
		test.startTest();
		test.setMock(HttpCalloutMock.class, new DE_integrationMock());
		DE_DecisionEnginesAPIController DEapi = new DE_DecisionEnginesAPIController();
		DEapi.ShowPopup();
		DE_DecisionEnginesAPIController.updateDocVersionRec();
		test.stopTest();
		
	}
	@isTest static void testMethod2(){ 
		//		DocumentVersionClass.createObject('Test');
		Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c();
		agreement.Name ='Test';
		agreement.ERP__c ='P20';
		insert agreement;
		Apttus__DocumentVersion__c doc = new Apttus__DocumentVersion__c();
		doc.Name='Test';
		doc.Apttus__Title__c='Test';
		doc.Apttus__LatestVersion__c='One';
		insert doc;
		test.startTest();
		DE_DocumentVersionClass.createObject('Test');  
		test.stopTest();   
		DE_DataStorage.token = '';
		test.setMock(HttpCalloutMock.class, new DE_integrationMock());
		//DE_DecisionEnginesAPIController DEapi = new DE_DecisionEnginesAPIController();
		DE_DataStorage ds = new DE_DataStorage();
	}
}