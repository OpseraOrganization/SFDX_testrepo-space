/*********************************************************************
* Class : QTO_CreateROControllerTest
* Created Date: 14 Dec 2020
* Created By : Shaik, Johny Basha
* Description : This class is test class for QTO_CreateROController 
* Description : DSI-2155 
*******************************************************************/
@IsTest
public class QTO_CreateROControllerTest {
	@isTest
	private static void positiveTest() {
		Account parentAccount = TestDataFactory.createAccount(1)[0];
		parentAccount.AccountNumber='101234567';
		parentAccount.Acc_No__c = '101234567';
		parentAccount.Name = 'Parent Account';
		parentAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		insert parentAccount;  
		
		Customer_Document__c cd = QTO_TestDataFactory.createCustomerDocument();
		cd.Customer_Document_Id__c = '672338872039';
		
		insert cd;
		
		
		
		List<OpportunityTeamMember> opportunityTeamMemberList = new List<OpportunityTeamMember>();
		List<User> userList = new List<User>();  
		userList = TestDataFactory.userCreation(3, 'System Administrator');
		
		userList[0].NSA_Compliant__c = True;
		userList[0].Restriction_Level__c = 'Unrestricted';
		userList[1].Restriction_Level__c = 'Unrestricted';
		userList[2].Restriction_Level__c = 'Unrestricted';
		Database.insert(userList);	
		
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		
		Account acc = new Account();
		acc.Name='Legal Entity Account For Test';
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		acc.ParentId = accounts[0].Id;
		acc.AccountNumber = '100006843';
		database.insert(acc);   
		
		
		//create opportunity with non-euro currency
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(2,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		opportunities[0].CurrencyIsoCode = 'GBP'; 
		opportunities[1].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		opportunities[1].CurrencyIsoCode = 'EUR'; 
		insert opportunities;  
		opportunityTeamMemberList = TestDataFactory.optyTeamMemberCreation(2, userList[0], opportunities[0]);
		opportunityTeamMemberList[1].OpportunityId = opportunities[1].Id;
		database.insert(opportunityTeamMemberList); 
		Test.startTest();
		
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].CurrencyIsoCode = 'GBP';
		proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(); //direct quote
		proposals[0].NokiaCPQ_Maintenance_Type__c = '';
		insert proposals;		
		
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		Shipping_Location__c shipping_location = new Shipping_Location__c();
		shipping_location.Portfolio__c = 'IP Routing';
		shipping_location.Pricing_Cluster__c = 'Europe';
		insert shipping_location;
		
		
		List<Apttus_Proposal__Proposal__c > proposals1 = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
		proposals1[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals1[0].Apttus_Proposal__Opportunity__c = opportunities[1].Id;
		proposals1[0].CurrencyIsoCode = 'EUR';
		proposals1[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(); //direct quote
		proposals1[0].NokiaCPQ_Maintenance_Type__c = '';
		insert proposals1;   
		
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalsLineItem1 = NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
		proposalsLineItem1[0].Apttus_Proposal__Proposal__c = proposals1[0].id;
		proposalsLineItem1[0].Apttus_QPConfig__LineType__c = 'Product/Service';
		proposalsLineItem1[0].NokiaCPQ_ExtendedPrice_CNP__c = 1234.50;
		proposalsLineItem1[0].Apttus_QPConfig__Quantity2__c = 1;
		proposalsLineItem1[0].Apttus_Proposal__Quantity__c = null;
		proposalsLineItem1[0].Apttus_QPConfig__NetUnitPrice__c=12134.50;
		insert proposalsLineItem1;
		
		List<QTO_CPO_Field_Mapping__c>  fieldMapList = new List<QTO_CPO_Field_Mapping__c>();
		QTO_CPO_Field_Mapping__c cpoFieldMap1 = new QTO_CPO_Field_Mapping__c(Type__c='Customer Name',
																			 PDF_Value__c='Pan Dacom Networking AG',
																			 Mapping__c='Customer Account');
		
		fieldMapList.add(cpoFieldMap1);
		QTO_CPO_Field_Mapping__c incoFieldMap1 = new QTO_CPO_Field_Mapping__c(Type__c='Inco Terms',
																			  PDF_Value__c='60NE',
																			  Mapping__c='P60',
																			  Customer_Name__c = accounts[0].Name);
		fieldMapList.add(incoFieldMap1);
		
		QTO_CPO_Field_Mapping__c payFieldMap1 = new QTO_CPO_Field_Mapping__c(Type__c='Payment Terms',
																			 PDF_Value__c='30 Tage netto',
																			 Mapping__c='P30',
																			 Customer_Name__c = accounts[0].Name);
		fieldMapList.add(payFieldMap1);
		
		insert fieldMapList;
		
		
		
		
		
		
		
		
		
		
		
		// create cfa
		Customer_facing_Attribute__c cfaSiteName = new Customer_facing_Attribute__c(Attribute_Value__c = 'Beverly',Attribute_Label__c='Site Name',Attribute_Name__c='Site Name',Quote__c=proposals1[0].Id);
		Customer_facing_Attribute__c cfaSiteCode = new Customer_facing_Attribute__c(Attribute_Value__c = '3jnjni3mi',Attribute_Label__c='Site Code',Attribute_Name__c='Site Code',Quote__c=proposals1[0].Id);
		insert new List<Customer_facing_Attribute__c>{cfaSiteName,cfaSiteCode};
			
		QTO_CreateROController.retriveStatus(proposals1[0].Id);
		
		QTO_CreateROController.createRO('111111', proposals1[0].Id);
		QTO_CreateROController.getPDFFieldValueMappingsByType(accounts[0].Name, new List<String>{'P30'});
	}
}