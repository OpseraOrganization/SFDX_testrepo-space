@IsTest
private with sharing class DS_cpActionsControllerTest {

	@testSetup
	static void setup(){
		User sysAdminUser = TestDataFactory.createSystemAdminUser();
		System.runAs(sysAdminUser) {
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

			// Portal User
			User portalUser = TestDataFactory.userCreation(1, 'Digital Sales Customer Profile')[0];
			portalUser.alias = 'puser9';
			portalUser.ContactId = contacts[0].Id;
			Database.insert(portalUser);
			portalUser.IsPortalEnabled = True;
			Database.update(portalUser);

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

			// Internal User to Opportunity Team
			List<OpportunityTeamMember> opptyTeamMemberList = TestDataFactory.optyTeamMemberCreation(1, internalUser, opportunity);
			Database.insert(opptyTeamMemberList);

			Test.startTest();
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

			//Quote/Proposal sharing with Portal User
			Apttus_Proposal__Proposal__Share quoteShare = new Apttus_Proposal__Proposal__Share(
	AccessLevel = 'Edit',
	ParentID = quoteProposal.Id,
	RowCause = 'Manual',
	UserOrGroupId = portalUser.Id
			);
			Database.insert(quoteShare);

			//Quote Line Item
			Apttus_Proposal__Proposal_Line_Item__c quoteLI = new Apttus_Proposal__Proposal_Line_Item__c(
	Apttus_Proposal__Proposal__c = quoteProposal.id,
	Apttus_QPConfig__ItemSequence__c = 1,
	Apttus_QPConfig__LineNumber__c =1
			);
			Database.insert(quoteLI);

			//Customer Facing Attributes
			List<Sobject> attributeList = new List<Customer_facing_Attribute__c>();
			Customer_facing_Attribute__c attribute1 = new Customer_facing_Attribute__c(
	Attribute_Name__c = 'Use Case',
	Attribute_Label__c = 'Use Case',
	Attribute_Value__c = 'Energy Efficiency',
	Attribute_Indicator__c = 'Header',
	Attribute_Visibility__c = 'Yes',
	Quote__c = quoteProposal.Id
			);
			attributeList.add(attribute1);

			Customer_facing_Attribute__c attribute2 = new Customer_facing_Attribute__c(
	Attribute_Name__c = 'Technology',
	Attribute_Label__c = 'Technology',
	Attribute_Value__c = 'FDD LTE',
	Attribute_Indicator__c = 'Header',
	Attribute_Visibility__c = 'Yes',
	Quote__c = quoteProposal.Id
			);
			attributeList.add(attribute2);

			Customer_facing_Attribute__c attribute3 = new Customer_facing_Attribute__c(
	Attribute_Name__c = 'Not visible test Attribute',
	Attribute_Label__c = 'Not visible test Attribute',
	Attribute_Value__c = 'Whatever',
	Attribute_Indicator__c = 'Header',
	Attribute_Visibility__c = 'No',
	Quote__c = quoteProposal.Id
			);
			attributeList.add(attribute3);

			Customer_facing_Attribute__c attribute4 = new Customer_facing_Attribute__c(
	Attribute_Name__c = 'Item Attribute',
	Attribute_Label__c = 'Item Attribute',
	Attribute_Value__c = 'Item',
	Attribute_Indicator__c = 'Item',
	Attribute_Visibility__c = 'Yes',
	Quote__c = quoteProposal.Id,
	Quote_Line_Item__c = quoteLI.Id
			);
			attributeList.add(attribute4);

			Customer_facing_Attribute__c attribute5 = new Customer_facing_Attribute__c(
	Attribute_Name__c = 'Not visible Item Attribute',
	Attribute_Label__c = 'Not visible Item Attribute',
	Attribute_Value__c = 'Item',
	Attribute_Indicator__c = 'Item',
	Attribute_Visibility__c = 'No',
	Quote__c = quoteProposal.Id,
	Quote_Line_Item__c = quoteLI.Id
			);
			attributeList.add(attribute5);
			Database.insert(attributeList);
			Test.stopTest();
		}
	}

	static testmethod void hasUploadedDocumentTest() {
		Test.startTest();
		Apttus_Proposal__Proposal__c quoteProposal = [SELECT Id FROM Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Proposal_Name__c = 'Test Data' LIMIT 1];

		// no Attacmhment uploaded yet to a newly created Quote/Proposal
		System.assertEquals(false, DS_cpActionsController.hasUploadedDocument(quoteProposal.Id));

		// upload Attachment (PO Document) related to the Quote/Proposal
		ContentVersion newContentVersion = TestDataFactory.createContentVersion(1)[0];
		newContentVersion.Title = CSWXGlobalConstant.VBA_and_Interdependency;
		Database.insert(newContentVersion);

		ContentVersion contentVersion = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :newContentVersion.Id LIMIT 1];
		ContentDocumentLink contentDocumentLink = TestDataFactory.createContentDocumentLink(1, quoteProposal.Id, contentVersion.ContentDocumentId)[0];
		Database.insert(contentDocumentLink);

		System.assertEquals(true, DS_cpActionsController.hasUploadedDocument(quoteProposal.Id));
		Test.stopTest();
	}

	static testmethod void updateStageAcceptTest() {
		Test.startTest();
		Apttus_Proposal__Proposal__c quoteProposal = [SELECT Id FROM Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Proposal_Name__c = 'Test Data' LIMIT 1];
		Apttus_Proposal__Proposal__c acceptedQuoteProposal = new Apttus_Proposal__Proposal__c(
			Id = quoteProposal.Id,
			Apttus_Proposal__Approval_Stage__c = CSWXGlobalConstant.Approval_stage_accepted,
			Rejection_Reason__c = ''
		);
		System.runAs([SELECT Id FROM User WHERE Alias = 'puser9' LIMIT 1][0]) {
			System.assertEquals(acceptedQuoteProposal, DS_cpActionsController.updateStage(quoteProposal.Id, CSWXGlobalConstant.Approval_stage_accepted, ''));
		}
		Test.stopTest();
	}

	static testmethod void updateStageRejectTest() {
		Test.startTest();
		Apttus_Proposal__Proposal__c quoteProposal = [SELECT Id FROM Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Proposal_Name__c = 'Test Data' LIMIT 1];

		String rejectReason = 'Test Reject Reason';
		Apttus_Proposal__Proposal__c rejectedQuoteProposal = new Apttus_Proposal__Proposal__c(
			Id = quoteProposal.Id,
			Apttus_Proposal__Approval_Stage__c = CSWXGlobalConstant.Approval_stage_rejected,
			Rejection_Reason__c = rejectReason
		);

		System.runAs([SELECT Id FROM User WHERE Alias = 'puser9' LIMIT 1][0]) {
			System.assertEquals(rejectedQuoteProposal, DS_cpActionsController.updateStage(quoteProposal.Id, CSWXGlobalConstant.Approval_stage_rejected, rejectReason));
		}
		Test.stopTest();
	}

	static testmethod void updateIntermediateStageTest() {
		Test.startTest();
		Apttus_Proposal__Proposal__c quoteProposal = [SELECT Id, Apttus_Proposal__Approval_Stage__c FROM Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Proposal_Name__c = 'Test Data' LIMIT 1];
		//User portalUser1 = [SELECT Id, Profile.Name FROM User WHERE Alias = 'puser9' LIMIT 1][0];

		//System.runAs(portalUser1) {
			//System.debug('updateIntermediateStageTest -> profile' + portalUser1.Profile.Name);
			System.debug('updateIntermediateStageTest -> stage=' + quoteProposal.Apttus_Proposal__Approval_Stage__c);
			DS_cpActionsController.updateIntermediateStage(quoteProposal.Id, CSWXGlobalConstant.Approval_stage_publishedInProgress);

			List<Customer_facing_Attribute__c> attributes = [SELECT Id, Quote_Approval_Stage__c FROM Customer_facing_Attribute__c WHERE Quote__c = :quoteProposal.Id];
			System.debug('updateIntermediateStageTest -> attributes=' + attributes);
			System.assertEquals(CSWXGlobalConstant.Approval_stage_publishedInProgress, attributes[0].Quote_Approval_Stage__c);
		//}
		Test.stopTest();
	}

	static testmethod void getExtraInformationForQuoteIdTest() {
		Test.startTest();
		Apttus_Proposal__Proposal__c quoteProposal = [SELECT Id FROM Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Proposal_Name__c = 'Test Data' LIMIT 1];

		//System.runAs([SELECT Id FROM User WHERE Alias = 'puser9' LIMIT 1][0]) {
			List<Customer_facing_Attribute__c> attributeQuery = [SELECT Id, Attribute_Label__c, Attribute_Value__c, Attribute_Indicator__c
				 FROM Customer_facing_Attribute__c
				 WHERE Quote__c = :quoteProposal.Id AND Attribute_Indicator__c = 'Header' AND Attribute_Visibility__c = 'Yes' AND Attribute_Label__c != null
				 ORDER BY Attribute_Label__c ASC];
			System.debug('getExtraInformationForQuoteIdTest -> attributeQuery=' + attributeQuery);
			List<Customer_facing_Attribute__c> headerAttributes = DS_cpActionsController.getExtraInformationForQuoteId(quoteProposal.Id);
			System.debug('getExtraInformationForQuoteIdTest -> headerAttributes=' + headerAttributes);
			System.assertEquals(2, headerAttributes.size());
			System.assertEquals('Technology', headerAttributes[0].Attribute_Label__c);
			System.assertEquals('FDD LTE', headerAttributes[0].Attribute_Value__c);
		//}
		Test.stopTest();
	}

	static testmethod void getHelpTextForQuoteTest() {
		Test.startTest();
		System.runAs([SELECT Id FROM User WHERE Alias = 'puser9' LIMIT 1][0]) {
			Map<String, String> helptextList = DS_cpActionsController.getHelpTextForQuote();
			System.debug('getHelpTextForQuoteTest -> helptextList=' + helptextList);
			System.debug('getHelpTextForQuoteTest -> isDSCustomerProfile' + DS_cpActionsController.isDSCustomerProfile());
			System.assertEquals(true, helptextList.containsKey('Apttus_QPConfig__PONumber__c'));
			System.assertEquals(Apttus_Proposal__Proposal__c.Apttus_QPConfig__PONumber__c.getDescribe().getInlineHelpText(), helptextList.get('Apttus_QPConfig__PONumber__c'));
		}
		Test.stopTest();
	}
}