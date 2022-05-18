/**
 * @description	   :
 * @author			: Yashdeep Prajapati
 * @group			 :
 * @last modified on  : 02-09-2022
 * @last modified by  : Yashdeep Prajapati
 **/
@istest
public with sharing class NokiaCPQ_AccreditationExportCtrlTest {
@testSetup static void methodName() {
	List<user> runUSer = TestDataFactory.userCreation(1,'Data Loader Profile');
	runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
	runUSer[0].NSA_Compliant__c = true;
	database.insert(runUSer);
	system.runAs(runUSer[0]){
		Nokia_CPQ_Constants.isCloneRun = true;
		// Create a test account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		accounts[0].Acc_No__c = 'Test10';
		accounts[0].Partner_Type__c='Value Added Reseller';
		accounts[0].Partner_Program__c ='GPP 3.0';
		insert accounts;

		//Create Accreditations
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditationforProd(1);
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[0].Accreditation_Type__c = 'Product';
		accreditations[0].Accreditation_Level__c = 'Authorized';
		accreditations[0].Pricing_Level_Override__c ='Authorized';
		accreditations[0].RecordTypeId = Schema.SObjectType.Accreditation__c.getRecordTypeInfosByDeveloperName().get('Reseller_GPP_3_0').getRecordTypeId();

		accreditations.addAll(NOKIA_CPQ_TestDataFactory.createAccreditationMaintenance(1));
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[1].RecordTypeId = Schema.SObjectType.Accreditation__c.getRecordTypeInfosByDeveloperName().get('Reseller_GPP_3_0').getRecordTypeId();
		insert accreditations;

		CPQ_ExportAttach__c ea = new CPQ_ExportAttach__c();
		ea.CPQ_Portfolio__c = 'IP Routing';
		ea.CPQ_Account__c = accounts[0].Id;
		ea.Name = 'IP Routing';
		insert ea;

		CPQ_AccreditationExports__c ata = new CPQ_AccreditationExports__c();
		ata.CPQ_Accreditation__c = accreditations[0].Id;
		ata.CPQ_ExportAttachment__c = ea.Id;
		insert ata;

		List<Attachment> attList = new List<Attachment>();
		Attachment attachment = new Attachment();
		attachment.Body = Blob.valueOf('Hello');
		attachment.Name = String.valueOf('test.txt');
		attachment.ParentId = ea.Id;
		attList.add(attachment);
		insert attList;
	}
}

static testMethod void getDetailsTest(){
	Account acc = [SELECT ID from Account LIMIT 1];
	Test.startTest();
	NokiaCPQ_AccreditationExportController.getDetails(acc.Id);
	Test.stopTest();
}
static testMethod void exportTest(){
	Account acc = [SELECT ID from Account LIMIT 1];
	List<string> accrSet = new List<string>();
	for (Accreditation__c accr : [SELECT ID FROM Accreditation__c]) {
		accrSet.add(accr.Id);
	}
	Test.startTest();
	NokiaCPQ_AccreditationExportController.export(accrSet, 'FN',acc.Id);
	NokiaCPQ_AccreditationExportController.export(accrSet, 'IP Routing',acc.Id);
	Test.stopTest();
}

static testMethod void getAttachmentsTest(){
	Account acc = [SELECT ID from Account LIMIT 1];
	Test.startTest();
	NokiaCPQ_AccreditationExportController.getAttachments(acc.Id);
	Test.stopTest();
}
}