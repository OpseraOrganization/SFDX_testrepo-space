@IsTest
private with sharing class DS_NewCDAssocBtnControllerTest {
	@TestSetup
	static void setup(){
		User sysAdminUser = TestDataFactory.createSystemAdminUser();
		System.runAs(sysAdminUser) {
			Test.startTest();
			//Account
			Account account = TestDataFactory.createAccount(1)[0];
			account.DMP_Account__c = true;
			Database.insert(account);

			Account legalEntity = TestDataFactory.createAccount(1)[0];
			legalEntity.AccountNumber = '100006843';
			legalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			legalEntity.ParentId = account.id;
			Database.insert(legalEntity);

			List<Contact> contacts = TestDataFactory.createContact2(1, account);
			Database.insert(contacts);

			// Internal User
			User internalUser = TestDataFactory.userCreation(1, 'Nokia Sales Profile')[0];
			internalUser.alias = 'iuser9';
			Database.insert(internalUser);

			//Opportunity
			Opportunity opportunity = TestDataFactory.OpportunityCreation(1, account)[0];
			opportunity.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
			opportunity.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();
			opportunity.Lead_BG__c = 'MN';
			opportunity.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
			Database.insert(opportunity);

			//Quote/Proposal
			Apttus_Proposal__Proposal__c quoteProposal = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
			quoteProposal.Analytics_Source__c  = CSWXGlobalConstant.AnalyticsSource;
			quoteProposal.RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal').getRecordTypeId();
			quoteProposal.Contract_Type_Name__c = 'Project';
			quoteProposal.Apttus_Proposal__Proposal_Name__c = 'Test Data';
			quoteProposal.Apttus_Proposal__Opportunity__c = opportunity.id;
			quoteProposal.Apttus_Proposal__Account__c = account.Id;
			quoteProposal.Sold_To_Party__c = legalEntity.id;
			quoteProposal.Apttus_Proposal__Approval_Stage__c = 'Approved';
			quoteProposal.LOA_Status__c = 'Approved';
			quoteProposal.CurrencyIsoCode = 'EUR';
			Database.insert(quoteProposal);

			//Customer Document
			Customer_Document__c cd = new Customer_Document__c();
			cd.Status__c = 'Draft';
			cd.Customer__c = account.Id;
			cd.Customer_Document_ID__c = '123456';
			cd.Classification__c = 'Standard PO';
			cd.Sub_Classification__c = 'Quote-based';
			database.insert(cd,false);

			Test.stopTest();
		}
	}

	static testmethod void addAssociationToQuoteProposalTest() {
		Test.startTest();
		Apttus_Proposal__Proposal__c quoteProposal = [SELECT Id FROM Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Proposal_Name__c = 'Test Data' LIMIT 1];
		Customer_Document__c cd = [SELECT Id FROM Customer_Document__c WHERE Customer_Document_ID__c = '123456' LIMIT 1];

		//Successful update
		DS_NewCDAssocBtnController.addAssociationToQuoteProposal(quoteProposal.Id, cd.Id);

		//Unsuccessful update - invalid Quote/Proposal
		try {
			DS_NewCDAssocBtnController.addAssociationToQuoteProposal('123', cd.Id);
		} catch (AuraHandledException e) {
			System.assertEquals(e.getMessage(), e.getMessage());
		}

		//Unsuccessful update - invalid User
		System.runAs([SELECT Id FROM User WHERE Alias = 'iuser9' LIMIT 1][0]) {
			try {
	DS_NewCDAssocBtnController.addAssociationToQuoteProposal(quoteProposal.Id, cd.Id);
			} catch (AuraHandledException e) {
	System.assertEquals(e.getMessage(), e.getMessage());
			}
		}
		Test.stopTest();
	}


	static testmethod void getQuoteProposalRecordTest() {
		Test.startTest();
		Apttus_Proposal__Proposal__c quoteProposal = [SELECT Id, Nokia_Customer_Document_ID__c, Nokia_Customer_Document_ID__r.Name FROM Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Proposal_Name__c = 'Test Data' LIMIT 1];
		System.assertEquals(quoteProposal, DS_NewCDAssocBtnController.getQuoteProposalRecord(quoteProposal.Id));

		System.runAs([SELECT Id FROM User WHERE Alias = 'iuser9' LIMIT 1][0]) {
			System.assertEquals(null, DS_NewCDAssocBtnController.getQuoteProposalRecord(quoteProposal.Id));
		}

		Test.stopTest();
	}

}