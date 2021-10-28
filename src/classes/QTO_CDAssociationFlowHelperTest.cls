/**
 * @description	   : 
 * @author			: Raj Kamdar
 * @group			 : 
 * @last modified on  : 12-16-2020
 * @last modified by  : Raj Kamdar
 * Modifications Log 
 * Ver   Date		 Author	   Modification
 * 1.0   11-25-2020   Raj Kamdar   Initial Version
**/
@isTest
public class QTO_CDAssociationFlowHelperTest {
		
	@TestSetup
	static void setup(){
		List<Account> accList = QTO_TestDataFactory.createAccount(1);
		insert accList; 
		Opportunity opp = QTO_TestDataFactory.OpportunityCreation(accList[0]);
		insert opp;
		Apttus__APTS_Agreement__c agr = QTO_TestDataFactory.createAgreement(accList[0]);
		insert agr;		 
		Customer_Document__c cd = QTO_TestDataFactory.createCustomerDocument();
		insert cd; 
		Customer_Document_Line_Items__c cdLine = QTO_TestDataFactory.createCustomerDocumentLineItem(cd);
		insert cdLine; 
		Apttus_Config2__PriceList__c pl = QTO_TestDataFactory.priceList(); 
		insert pl;  
		Apttus_Config2__PriceListItem__c plLines = QTO_TestDataFactory.createPriceListItem(pl); 
		insert plLines;	
		List<Apttus_Proposal__Proposal__c> quotes = QTO_TestDataFactory.createProposal(1,opp.id);
		quotes[0].Apttus_Proposal__Approval_Stage__c = 'Approved';
		quotes[0].Apttus_Proposal__Proposal_Name__c = 'PDF CONTRACT REF' ; 
		quotes[0].Sold_To_Party__c = accList[0].id;
		insert quotes;
		System.debug('name--'+quotes[0].Apttus_Proposal__Proposal_Name__c+'accountid---'+quotes[0].Sold_To_Party__c);
		Apttus_Proposal__Proposal_Line_Item__c quoteLines = QTO_TestDataFactory.proposalLineItemCreation(quotes[0].id,plLines); 
		insert quoteLines;	  
		Customer_facing_Attribute__c cfa = QTO_TestDataFactory.createCFA(quotes[0].id,quoteLines.id); 
		insert cfa;  
	}
	@isTest static void testMethod1() {
		System.debug('TEST METHOD 1');
		List<Customer_Document__c> customerDocList = new List<Customer_Document__c>();
		Customer_Document__c cd =new Customer_Document__c();
		cd = QTO_TestDataFactory.createCustomerDocument();
		insert cd;
		
		Customer_Document_Line_Items__c cdLine = QTO_TestDataFactory.createCustomerDocumentLineItem(cd);
		insert cdLine; 
		customerDocList.add(cd);
		QTO_AutomateAssociationController.autoAssociateCustomerDocuments(customerDocList);
		
	}
	@isTest static void testMethod4() {
		System.debug('TEST METHOD 4');
		List<Customer_Document__c> customerDocList = new List<Customer_Document__c>();
		Customer_Document__c cd =new Customer_Document__c();
		cd = QTO_TestDataFactory.createCustomerDocument();
		insert cd;
		
		Customer_Document_Line_Items__c cdLine = QTO_TestDataFactory.createCustomerDocumentLineItem(cd);
		insert cdLine; 
		customerDocList.add(cd);
		Account acc = new Account();
		acc.id =cd.Customer__c;		
		Apttus__APTS_Agreement__c agr =new Apttus__APTS_Agreement__c();		
		agr = QTO_TestDataFactory.createAgreement(acc);
		agr.Agreement_External_Contract_Number__c= 'PDF CONTRACT REF';
		agr.Apttus__Status_Category__c ='In Application';
		insert agr;   
		QTO_AutomateAssociationController.autoAssociateCustomerDocuments(customerDocList);
		
	}
	@isTest static void testMethod5() {
		System.debug('TEST METHOD 5');
		List<Customer_Document__c> customerDocList = new List<Customer_Document__c>();
		Customer_Document__c cd =new Customer_Document__c();
		cd = QTO_TestDataFactory.createCustomerDocument();
		insert cd;
		
		Customer_Document_Line_Items__c cdLine = QTO_TestDataFactory.createCustomerDocumentLineItem(cd);
		insert cdLine; 
		customerDocList.add(cd);
		Customer_facing_Attribute__c cdp =new Customer_facing_Attribute__c();
		cdp.QTO_Customer_Document__c=cd.id;
		cdp.Attribute_Label__c = 'PDF CONTRACT REF';
		cdp.Attribute_Value__c = 'PDF CONTRACT REF';
		insert cdp;
		Customer_facing_Attribute__c cdp1 =new Customer_facing_Attribute__c();
		cdp1.QTO_Customer_Document__c=cd.id;
		cdp1.Attribute_Label__c = 'PDF Quote Ref';
		cdp1.Attribute_Value__c = 'PDF Quote Ref';
		insert cdp1;
		Customer_facing_Attribute__c cdp1i1 =new Customer_facing_Attribute__c();
		cdp1i1.QTO_Customer_Document_Line_Items__c=cdLine.id;
		cdp1i1.Attribute_Label__c = 'PDF Quote Ref';
		cdp1i1.Attribute_Value__c = 'PDF Quote Ref';
		insert cdp1i1;
		Customer_facing_Attribute__c cdp1i2 =new Customer_facing_Attribute__c();
		cdp1i2.QTO_Customer_Document_Line_Items__c=cdLine.id;
		cdp1i2.Attribute_Label__c = 'PDF Quote Ref';
		cdp1i2.Attribute_Value__c = 'PDF Quote Ref';
		insert cdp1i2;
		Account acc = new Account();
		acc.id =cd.Customer__c;		
		Apttus__APTS_Agreement__c agr =new Apttus__APTS_Agreement__c();		
		agr = QTO_TestDataFactory.createAgreement(acc);
		agr.Agreement_External_Contract_Number__c= 'PDF CONTRACT REF';
		agr.Apttus__Status_Category__c ='In Application';
		insert agr;   
		QTO_AutomateAssociationController.autoAssociateCustomerDocuments(customerDocList);
		System.assertEquals('PDF Quote Ref', cdp1i2.Attribute_Value__c);
		
	}
	@isTest static void testMethod3() {
		System.debug('TEST METHOD 3');
		Opportunity opp = [Select Id,AccountId From Opportunity];	
		List<Customer_Document__c> customerDocList = new List<Customer_Document__c>();
		Customer_Document__c cd =new Customer_Document__c();
		cd = QTO_TestDataFactory.createCustomerDocument();
		insert cd;
		Customer_facing_Attribute__c cdp =new Customer_facing_Attribute__c();
		cdp.QTO_Customer_Document__c=cd.id;
		cdp.Attribute_Label__c = 'PDF Quote Ref';
		cdp.Attribute_Value__c = 'PDF Quote Ref';
		insert cdp;
		Customer_Document_Line_Items__c cdLine = QTO_TestDataFactory.createCustomerDocumentLineItem(cd);
		insert cdLine;
		customerDocList.add(cd);
		Account acc = new Account();
		acc.id =cd.Customer__c;		
		Apttus__APTS_Agreement__c agr =new Apttus__APTS_Agreement__c();		
		agr = QTO_TestDataFactory.createAgreement(acc);
		agr.Agreement_External_Contract_Number__c= 'PDF Quote Ref';		
		agr.Apttus__Status_Category__c ='In Application';
		insert agr;	 
		Test.startTest();
		List<Apttus_Proposal__Proposal__c> quotes = QTO_TestDataFactory.createProposal(1,opp.id);
		quotes[0].Apttus_Proposal__Approval_Stage__c = 'Approved';
		quotes[0].Apttus_Proposal__Proposal_Name__c = 'PDF Quote Ref' ; 
		quotes[0].Agreement_Lookup__c = agr.Id;
		quotes[0].Sold_To_Party__c = opp.AccountId;
		insert quotes;
		QTO_AutomateAssociationController.autoAssociateCustomerDocuments(customerDocList);
		Test.stopTest();
		System.assertEquals('In Application', agr.Apttus__Status_Category__c);
	}
	@isTest static void testMethod6(){

			QTO_CustomException e = new QTO_CustomException('Test Exception','');
		
	}
	@isTest static void testMethod2() {
		System.debug('TEST METHOD 2');
		Opportunity opp = [Select Id,AccountId From Opportunity]; 
		List<Customer_Document__c> customerDocList = new List<Customer_Document__c>();
		Customer_Document__c cd =new Customer_Document__c();
		cd = QTO_TestDataFactory.createCustomerDocument();
		insert cd;
		Customer_facing_Attribute__c cdp =new Customer_facing_Attribute__c();
		cdp.QTO_Customer_Document__c=cd.id;
		cdp.Attribute_Label__c = 'PDF CONTRACT REF';
		cdp.Attribute_Value__c = 'PDF CONTRACT REF';
		insert cdp;
		Customer_facing_Attribute__c cdp1 =new Customer_facing_Attribute__c();
		cdp1.QTO_Customer_Document__c=cd.id;
		cdp1.Attribute_Label__c = 'PDF Quote Ref';
		cdp1.Attribute_Value__c = 'PDF Quote Ref';
		insert cdp1;
		Customer_Document_Line_Items__c cdLine = QTO_TestDataFactory.createCustomerDocumentLineItem(cd);
		insert cdLine; 
		customerDocList.add(cd);
		Account acc = new Account();
		acc.id =cd.Customer__c;		
		Apttus__APTS_Agreement__c agr =new Apttus__APTS_Agreement__c();		
		agr = QTO_TestDataFactory.createAgreement(acc);
		agr.Agreement_External_Contract_Number__c= 'PDF CONTRACT REF';
		agr.Apttus__Status_Category__c ='In Application';
		insert agr;		
		Test.startTest();
		List<Apttus_Proposal__Proposal__c> quotes = QTO_TestDataFactory.createProposal(1,opp.id);
		quotes[0].Apttus_Proposal__Approval_Stage__c = 'Approved';
		quotes[0].Apttus_Proposal__Proposal_Name__c = 'PDF Quote Ref' ; 
		quotes[0].Agreement_Lookup__c = agr.Id;
		quotes[0].Sold_To_Party__c = cd.Customer__c;
		insert quotes;
		QTO_Customer_Document_Issue_Log__c logs = new QTO_Customer_Document_Issue_Log__c();
		logs.QTO_CustomerDocumentId__c = cd.Id;
		logs.QTO_CustomerDocumentItemId__c = cdLine.Id;
		logs.QTO_IssueDetails__c = 'message';
		logs.QTO_Return_Code__c = 'returnCode';
		logs.QTO_ErrorType__c  = 'Error';
		insert logs;
		QTO_Customer_Document_Agreement__c cda = new QTO_Customer_Document_Agreement__c();
		cda.QTO_Customer_Document__c = cd.Id;
		cda.QTO_Agreement__c = agr.id;
		insert cda;
		Customer_Document_Junction__c cdq = new Customer_Document_Junction__c();
		cdq.Customer_Document__c = cd.Id;
		cdq.Quote_Proposal__c = quotes[0].Id;
		insert cdq;
		QTO_AutomateAssociationController.autoAssociateCustomerDocuments(customerDocList); 
		QTO_ReAssociationController.submitBatchJob(cd.Id);  
		Test.stopTest();
	}
	   
	
}