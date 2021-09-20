@IsTest

public class CPO_OrderEnrichmentLineItemCreationTest {

	@IsTest
	private static void positiveTest(){
		Account parentAccount = TestDataFactory.createAccount(1)[0];
		parentAccount.AccountNumber='101234567';
		parentAccount.Acc_No__c = '101234567';
		parentAccount.Name = 'Parent Account';
		parentAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		insert parentAccount;  
		
		Customer_Document__c cd = QTO_TestDataFactory.createCustomerDocument();
		cd.Customer_Document_Id__c = '672338872039';
		
		insert cd;
		
		Apttus__APTS_Agreement__c agr = QTO_TestDataFactory.createAgreement(parentAccount);
		agr.Apttus__Status_Category__c = QTO_Constants.IN_EFFECT;
		agr.Apttus__Contract_End_Date__c = Date.today();
		insert agr;
		
		QTO_Customer_Document_Agreement__c objCD = new QTO_Customer_Document_Agreement__c();
		objCD.QTO_Agreement__c = agr.Id;
		objCD.QTO_Customer_Document__c = cd.Id;
		objCD.QTO_Source__c = QTO_Constants.MANUAL;
		insert objCD;
		
		List<Customer_Document_Line_Items__c> customerDocLines = new List<Customer_Document_Line_Items__c>();
		
		Customer_Document_Line_Items__c cdli1 = new Customer_Document_Line_Items__c();
		
		cdli1.High_level_Product__c = 'My SFR Cutlery';
		cdli1.High_level_Product_Description__c = 'My SFR Bundle Description';
		cdli1.Detailed_Product__c = 'Bundle1S4ABIA';
		cdli1.Detailed_Product_Description__c = 'Test Detailed Product Description';
		cdli1.QTO_PDF_Quantity__c = '1';
		cdli1.Quantity__c = '1';
		cdli1.QTO_PDF_Unit_Of_Measure__c = 'PCE';
		cdli1.QTO_Unit_Of_Measure__c = 'PCE';
		cdli1.QTO_PDF_Unit_Price__c = '2222,00';
		cdli1.Total_Value__c = 50;
		cdli1.QTO_PDF_Currency_Code__c = 'EUR';
		cdli1.CurrencyIsoCode = 'EUR';
		cdli1.QTO_Unit_Price__c	= 2222.00;
		cdli1.Customer_Document__c = cd.Id;
		customerDocLines.add(cdli1);
		
		insert customerDocLines;
		
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
		 proposalsLineItem1[0].Apttus_QPConfig__LineType__c = 'Option';
		 proposalsLineItem1[0].NokiaCPQ_ExtendedPrice_CNP__c = 1234.50;
		 proposalsLineItem1[0].Apttus_QPConfig__Quantity2__c = 1;
		
		insert proposalsLineItem1;
			
		QTO_Customer_Document_Quote_Line__c cdql = new QTO_Customer_Document_Quote_Line__c();
		cdql.QTO_Customer_Document_Line_Items__c = customerDocLines[0].Id;
		cdql.QTO_Proposal_Line_Item__c = proposalsLineItem1[0].Id;
		
		insert cdql;
		
		List<Customer_facing_Attribute__c> allCusfacingAttributes = new List<Customer_facing_Attribute__c>();
		
		Customer_facing_Attribute__c cfa = new Customer_facing_Attribute__c();
		cfa.Attribute_Label__c = 'PDF QUOTE REF';
		cfa.Attribute_Value__c = 'Q-00123360';
		cfa.QTO_Customer_Document__c = cd.Id;
		
		allCusfacingAttributes.add(cfa);
		
		Customer_facing_Attribute__c cfa1 = new Customer_facing_Attribute__c();
		cfa1.Attribute_Label__c = 'PDF QUOTE REF';
		cfa1.Attribute_Value__c = 'Q-00123360';
		cfa1.QTO_Customer_Document_Line_Items__c = customerDocLines[0].Id;
	  	allCusfacingAttributes.add(cfa1);
		
		Customer_facing_Attribute__c cfa2 = new Customer_facing_Attribute__c();
		cfa2.Attribute_Label__c = 'PDF QUOTE REF';
		cfa2.Attribute_Value__c = 'Q-00123360';
		cfa2.Quote__c = proposals1[0].id;
	  	allCusfacingAttributes.add(cfa2);
		
		Customer_facing_Attribute__c cfa3 = new Customer_facing_Attribute__c();
		cfa3.Attribute_Label__c = 'PDF QUOTE REF';
		cfa3.Attribute_Value__c = 'Q-00123360';
		cfa3.Quote_Line_Item__c = proposalsLineItem1[0].Id;
	  	allCusfacingAttributes.add(cfa3);
		
		insert allCusfacingAttributes;
		
		cd.Status__c = QTO_Constants.CD_STATUS_LEGACY;
		
		update cd;
		
		List<String> cpoFieldList = getAllObjectFields('Apttus_Config2__CustomerPurchaseOrder__c');
		String queryString = 'SELECT ' + String.join(cpoFieldList, ',') + ' FROM Apttus_Config2__CustomerPurchaseOrder__c LIMIT 1';
		List<Apttus_Config2__CustomerPurchaseOrder__c> cpo = Database.query(queryString);
		
		System.debug('cpocpo:::::' + cpo);
		
	   // CPO_OrderEnrichmentLineItemCreation.createLineItems(cpo);
	}
	
	private static List<String> getAllObjectFields(String type) {
		List<String> allFields = new List<String>();
		Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
		Schema.SObjectType leadSchema = schemaMap.get(type);
		Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
		
		for (String fieldName: fieldMap.keySet()) {
			allFields.add(fieldName);
		}
		
		return allFields;
	}
}