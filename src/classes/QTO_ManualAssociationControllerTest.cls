/**
 * @description	   : 
 * @author			: Lovel Panchal
 * @group			 : 
 * @last modified on  : 12-16-2020
 * @last modified by  : Raj Kamdar
 * Modifications Log 
 * Ver   Date		 Author		  Modification
 * 1.0   11-18-2020   Lovel Panchal   Initial Version
**/
@isTest
private class QTO_ManualAssociationControllerTest{
	@isTest static void testMethod1() {
		
		Account parentAccount = TestDataFactory.createAccount(1)[0];
		parentAccount.AccountNumber='101234567';
		parentAccount.Acc_No__c = '101234567';
		parentAccount.Name = 'Parent Account';
		parentAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		insert parentAccount;
		
		Account customerAccount = TestDataFactory.createAccount(1)[0];
		customerAccount.AccountNumber='101234568';
		customerAccount.Acc_No__c = '101234568';
		customerAccount.Name = 'Customer Account';
		customerAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		customerAccount.ParentId = parentAccount.Id;
		customerAccount.Active__c = true;
		customerAccount.BillingPostalCode = '92661';		
	  
		insert customerAccount;

		Customer_Document__c cd =new Customer_Document__c();
		cd = QTO_TestDataFactory.createCustomerDocument();	
		cd.Customer_Document_Id__c = '672338872039';
		cd.Customer__c = customerAccount.Id;
		insert cd;

	   // Account acc = [Select id from Account limit 1];
		List<Apttus_Proposal__Proposal__c> Quote =  QTO_TestDataFactory.createProposal(1,QTO_TestDataFactory.OpportunityCreation(customerAccount).Id);
		insert Quote;
		System.debug('Quote ...'+Quote);
		String str = '[{"Id":"'+Quote[0].Id+'","Name":"Q-00123361","Quote_Total__c":1743,"Apttus_Proposal__Approval_Stage__c":"Approved","Agreement_Name__c":"Contrat dExecution Accès Radio N°2009/00998 - amendment n°10 #HW Copy Copy Copy","Apttus_Proposal__Proposal_Name__c":"SFR - MN - Winback Renewal Husky - 4G MN and NI diplexers + 5G HW FoC","QTO_Association_Status__c":"Not Associated"}]';
		
		Quote =  QTO_TestDataFactory.createProposal(1,QTO_TestDataFactory.OpportunityCreation(customerAccount).Id);
		insert Quote;
		str = '[{"Id":"'+Quote[0].Id+'","Name":"Q-00123361","Quote_Total__c":1743,"Apttus_Proposal__Approval_Stage__c":"Approved","Agreement_Name__c":"Contrat dExecution Accès Radio N°2009/00998 - amendment n°10 #HW Copy Copy Copy","Apttus_Proposal__Proposal_Name__c":"SFR - MN - Winback Renewal Husky - 4G MN and NI diplexers + 5G HW FoC","QTO_Association_Status__c":"Not Associated"}]';
		Customer_Document__c objCD = [Select Id from Customer_Document__c where Customer_Document_Id__c ='672338872039' Limit 1];
		QTO_ManualAssociationController.saveAssociationData(str,objCD.Id,'Quote');
	   
   
		QTO_ManualAssociationController.getAllAssociationData('Quote',cd.Id);
		QTO_ManualAssociationController.getAllAssociationData('Agreement',cd.Id); 
		QTO_ManualAssociationController.getAllAssociationData('Customer_Document__c',cd.Id); 
		
		QTO_ManualAssociationController.getTableHeaders('Quote');
		QTO_ManualAssociationController.getTableHeaders('Agreement');
		QTO_ManualAssociationController.getTableHeaders('Customer_Document__c');
		
		QTO_ManualAssociationController.getTableHeaders(cd.Id);
		QTO_ManualAssociationController.getStatus(cd.Id);
		QTO_ManualAssociationController.saveAssociationData(str,cd.Id,'Quote');
		QTO_ManualAssociationController.saveAssociationData(str,cd.Id,'Agreement');
		
		QTO_ManualAssociationControllerHelper ctrl = new QTO_ManualAssociationControllerHelper();
		QTO_ManualAssociationControllerHelper.dataTableHeader dt = new QTO_ManualAssociationControllerHelper.dataTableHeader();
		dt.fieldName = '';
		dt.label = '';
		dt.type = '';  
		
		str = '[{"Id":"'+cd.Id+'","Customer_Document_Id__c":"672338872039"}]';
		QTO_ManualAssociationControllerHelper.saveCustomerDocumentAssociationData(str,cd.Id);

	}
}