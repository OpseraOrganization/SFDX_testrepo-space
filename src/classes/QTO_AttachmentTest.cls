@isTest
public class QTO_AttachmentTest {

	public static testmethod void testMethod1(){

		List<Account> accountsNew = new List<Account>();
		Account accLegalEntity = TestDataFactory.createAccount(1)[0];
		accLegalEntity.AccountNumber='101234567';
		accLegalEntity.Acc_No__c = '101234567';
		accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accountsNew.add(accLegalEntity);

		insert accountsNew;

		Case caseSO = new Case();
		caseSO.Account = accountsNew[0];
		caseSO.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Quote_to_Order_CPO_Case').getRecordTypeId();
		caseSO.Subject = 'Test';
		caseSO.Status = 'Exception';
		caseSO.Description = 'Test';
		caseSO.of_Employees_to_represent_Nokia_CP__c = '0-10%';

		insert caseSO;

		Attachment attchSO = new Attachment();
		Blob bodyBlob = Blob.valueOf('Unit Test  Body');
		attchSO.ParentId = caseSO.Id;
		attchSO.Name = 'CPO Test.pdf';
		attchSO.Body = bodyBlob;

		insert attchSO;
	}

}