/**
 * @description	   :
 * @author			: Yashdeep Prajapati
 * @group			 :
 * @last modified on  : 01-28-2022
 * @last modified by  : Yashdeep Prajapati
 **/
@isTest public with sharing class NokiaCPQ_EaControllerExtensionTest {
@isTest static void testMethod1(){
	Nokia_CPQ_Constants.isCloneRun = true;
	// Create a test account
	List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
	accounts[0].Acc_No__c = 'Test10';
	accounts[0].Partner_Type__c='Value Added Reseller';
	accounts[0].Partner_Program__c ='GPP 3.0';
	insert accounts;
	CPQ_ExportAttach__c ea = new CPQ_ExportAttach__c();
	ea.CPQ_Portfolio__c = 'IP Routing';
	ea.CPQ_Account__c = accounts[0].id;
	ea.Name = 'IP Routing';
	insert ea;
	//nokiaCPQ_AccreditationExportFromEA is the Visualforce page created
	PageReference testPage = Page.nokiaCPQ_AccreditationExportFromEA;
	Test.setCurrentPage(testPage);
	testPage.getParameters().put('Id', String.valueOf(ea.Id));

	ApexPages.StandardController sc = new  ApexPages.StandardController(ea);
	NokiaCPQ_EaControllerExtension ext = new NokiaCPQ_EaControllerExtension(sc);

	System.debug(ext.getAccount());
}
}