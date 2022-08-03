@IsTest
private with sharing class DS_ProposalControllerTest {
	public static final String ASSERT_MISMATCH_IN_ROW_COUNT = 'Mismatch in row count!';
	public static final String ASSERT_MISMATCH_IN_QUOTE_ID = 'Mismatch in Quote ID!';
	public static final String ASSERT_MISMATCH_IN_QUOTE_STAGE = 'Mismatch in Quote Stage!';
	public static final String ASSERT_MISMATCH_IN_EXTRA_INFO = 'Mismatch in Extra Info!';

	public static final String ASSERT_TRUNCATED_EXTRA_INFO = 'Item Attribute Label: Item ...';

	@testSetup
	static void setup() {
		User sysAdminUser = TestDataFactory.createSystemAdminUser();
		System.runAs(sysAdminUser) {
			//Account
			Account account = TestDataFactory.createAccount(1)[0];
			account.DMP_Account__c = true;
			Database.insert(account);

			Account legalEntity = TestDataFactory.createAccount(1)[0];
			legalEntity.AccountNumber = '100006843';
			legalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
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
			opportunity.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
			opportunity.Lead_BG__c = 'MN';
			opportunity.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
			Database.insert(opportunity);

			// Internal User to Opportunity Team
			List<OpportunityTeamMember> opptyTeamMemberList = TestDataFactory.optyTeamMemberCreation(1, internalUser, opportunity);
			Database.insert(opptyTeamMemberList);

			//Customer Document
			Customer_Document__c cd = new Customer_Document__c();
			cd.Status__c = 'Draft';
			cd.Customer__c = account.Id;
			cd.Customer_Document_ID__c = '123456';
			cd.Classification__c = 'Standard PO';
			cd.Sub_Classification__c = 'Quote-based';
			database.insert(cd,false);

			Test.startTest();
			//Quote/Proposal
			Apttus_Proposal__Proposal__c quoteProposal = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
			quoteProposal.Analytics_Source__c  = CSWXGlobalConstant.AnalyticsSource;
			quoteProposal.RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CCRE_Proposal').getRecordTypeId();
			quoteProposal.Contract_Type_Name__c = 'Project';
			quoteProposal.Apttus_Proposal__Proposal_Name__c = 'Test Data';
			quoteProposal.Apttus_Proposal__Opportunity__c = opportunity.id;
			quoteProposal.Apttus_Proposal__Account__c = account.Id;
			quoteProposal.Sold_To_Party__c = legalEntity.id;
			quoteProposal.Apttus_Proposal__Approval_Stage__c = 'Approved';
			quoteProposal.LOA_Status__c = 'Approved';
			quoteProposal.CurrencyIsoCode = 'EUR';
			quoteProposal.Apttus_QPConfig__PONumber__c = '4500055830';
			quoteProposal.Apttus_QPConfig__PODate__c = Date.today();
			quoteProposal.Nokia_Customer_Document_ID__c = cd.Id;
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
	Attribute_Label__c = 'Item Attribute Label',
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

			Group testGroup = new Group(Name='Test Logistics Queue', Type='Queue');
			Database.insert(testGroup);

			DS_LE_Logistics_Queue_Map__c legalEntityQueue = new DS_LE_Logistics_Queue_Map__c(
	Name = 'Test',
	Legal_Entity_ID__c = legalEntity.Id,
	Queue_ID__c = testGroup.Id
			);
			Database.insert(legalEntityQueue);
			System.debug('--->legalEntityQueue =' + legalEntityQueue);
			Test.stopTest();
		}
	}

	static testmethod void getCommercialProposalListTestForSysAdmin() {
		Test.startTest();
		List<DS_ProposalWrapper> resultListForSysAdmin = DS_ProposalController.getCommercialProposalList();
		Test.stopTest();

		System.debug('getCommercialProposalList -> resultListForSysAdmin[0].truncExtraInfo=' + resultListForSysAdmin[0].truncExtraInfo);
		System.debug('getCommercialProposalList -> siteId=' + Site.getSiteId());
		System.assert(resultListForSysAdmin.size() == 1, ASSERT_MISMATCH_IN_ROW_COUNT);
		System.assertEquals('Approved', resultListForSysAdmin[0].quoteStage, ASSERT_MISMATCH_IN_QUOTE_STAGE);
		System.assertEquals('Test Data', resultListForSysAdmin[0].proposalName, ASSERT_MISMATCH_IN_QUOTE_ID);
		System.assertEquals(ASSERT_TRUNCATED_EXTRA_INFO, resultListForSysAdmin[0].truncExtraInfo, ASSERT_MISMATCH_IN_EXTRA_INFO);
	}

	static testmethod void getCommercialProposalListTestForPortalUser() {
		System.runAs([SELECT Id FROM User WHERE Alias = 'puser9' LIMIT 1][0]) {
			//Portal User can retrieve his own Quote/Proposal
			Test.startTest();
			List<DS_ProposalWrapper> resultListForPortalUser = DS_ProposalController.getCommercialProposalList();
			Test.stopTest();

			System.assert(resultListForPortalUser.size() == 1, ASSERT_MISMATCH_IN_ROW_COUNT);
			System.assertEquals('Published', resultListForPortalUser[0].quoteStage, ASSERT_MISMATCH_IN_QUOTE_STAGE);
			System.assertEquals('Test Data', resultListForPortalUser[0].proposalName, ASSERT_MISMATCH_IN_QUOTE_ID);
			System.assertEquals(ASSERT_TRUNCATED_EXTRA_INFO, resultListForPortalUser[0].truncExtraInfo, ASSERT_MISMATCH_IN_EXTRA_INFO);
		}
	}

	static testmethod void getCommercialProposalListTestForInternalUser() {
		System.runAs([SELECT Id FROM User WHERE Alias = 'iuser9' LIMIT 1][0]) {
			//Internal User can retrieve his own Quote/Proposal
			Test.startTest();
			List<DS_ProposalWrapper> resultListForInternalUser = DS_ProposalController.getCommercialProposalList();
			Test.stopTest();

			System.assert(resultListForInternalUser.size() == 1, ASSERT_MISMATCH_IN_ROW_COUNT);
			System.assertEquals('Approved', resultListForInternalUser[0].quoteStage, ASSERT_MISMATCH_IN_QUOTE_STAGE);
			System.assertEquals('Test Data', resultListForInternalUser[0].proposalName, ASSERT_MISMATCH_IN_QUOTE_ID);
			System.assertEquals(ASSERT_TRUNCATED_EXTRA_INFO, resultListForInternalUser[0].truncExtraInfo, ASSERT_MISMATCH_IN_EXTRA_INFO);
		}
	}

	static testmethod void getCommercialProposalListTestForAcceptedQuote() {
		Test.startTest();
		Apttus_Proposal__Proposal__c quoteProposal = [SELECT Id FROM Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Proposal_Name__c = 'Test Data' LIMIT 1];
		//Check if Accepted Quote/Proposal is also listed
		quoteProposal.Apttus_Proposal__Approval_Stage__c = CSWXGlobalConstant.Approval_stage_accepted;
		Database.update(quoteProposal);

		List<DS_ProposalWrapper> resultListAccepted = DS_ProposalController.getCommercialProposalList();
		System.debug('getCommercialProposalList -> resultListAccepted[0].truncExtraInfo=' + resultListAccepted[0].truncExtraInfo);
		System.assert(resultListAccepted.size() == 1, ASSERT_MISMATCH_IN_ROW_COUNT);
		Test.stopTest();

		System.assertEquals(CSWXGlobalConstant.Approval_stage_accepted, resultListAccepted[0].quoteStage, ASSERT_MISMATCH_IN_QUOTE_STAGE);
	}

	static testmethod void getQuoteStagesTest() {
		List<DS_ListWrapper> resultList = DS_ProposalController.getQuoteStages();
		System.debug('getQuoteStagesTest -> resultList=' + resultList);
		System.assertEquals(CSWXGlobalConstant.Approval_stage_accepted, resultList[5].label, ASSERT_MISMATCH_IN_QUOTE_STAGE);
	}

	static testmethod void getAvailableAttributeLabelsForQuotesTest() {
		Apttus_Proposal__Proposal__c quoteProposal = [SELECT Id FROM Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Proposal_Name__c = 'Test Data' LIMIT 1];

		Test.startTest();
		List<DS_ListWrapper> resultProposalList = DS_ProposalController.getAvailableAttributeLabelsForQuotes(quoteProposal.Id);
		Test.stopTest();

		System.assertEquals(3, resultProposalList.size(), ASSERT_MISMATCH_IN_ROW_COUNT);
		System.assertEquals('Item Attribute Label', resultProposalList[0].label, 'Mismatch in Item Attribute');
		System.assertEquals('Technology', resultProposalList[1].label, 'Mismatch in Technology');
		System.assertEquals('Use Case', resultProposalList[2].label, 'Mismatch in Use Case');
		System.assertEquals(new List<DS_ListWrapper>(), DS_ProposalController.getAvailableAttributeLabelsForQuotes(''), 'Mismatch in Proposal List');
	}

	static testmethod void getQuoteLineItemListTest() {
		Apttus_Proposal__Proposal__c quoteProposal = [SELECT Id FROM Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Proposal_Name__c = 'Test Data' LIMIT 1];

		Test.startTest();
		List<DS_LineItemWrapper> resultQLIList = DS_ProposalController.getQuoteLineItemList(quoteProposal.Id, false);
		Test.stopTest();

		System.assertEquals(1, resultQLIList.size(), ASSERT_MISMATCH_IN_ROW_COUNT);
		System.assertEquals(new List<DS_LineItemWrapper>(), DS_ProposalController.getQuoteLineItemList('', true), 'Mismatch in Proposal Line Item List');
	}

	static testmethod void updateIntermediateStageForQuotesPublishedInProgressTest() {
		Apttus_Proposal__Proposal__c quoteProposal = [SELECT Id FROM Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Proposal_Name__c = 'Test Data' LIMIT 1];

		Test.startTest();
		//set to Published - In Progress
		DS_ProposalController.updateIntermediateStageForQuotes(quoteProposal.Id, CSWXGlobalConstant.Approval_stage_publishedInProgress);
		Test.stopTest();

		System.assertEquals(CSWXGlobalConstant.Approval_stage_publishedInProgress, [SELECT Apttus_Proposal__Approval_Stage__c FROM Apttus_Proposal__Proposal__c WHERE Id = :quoteProposal.Id].Apttus_Proposal__Approval_Stage__c, 'Mismatch in Quote State');
	}

	static testmethod void updateIntermediateStageForQuotesCallOffReadyTest() {
		Apttus_Proposal__Proposal__c quoteProposal = [SELECT Id FROM Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Proposal_Name__c = 'Test Data' LIMIT 1];

		Test.startTest();
		//set to Call-off Ready
		Boolean didCatchProperException = false;
		try {
			DS_ProposalController.updateIntermediateStageForQuotes(quoteProposal.Id, CSWXGlobalConstant.Approval_stage_callofReady);
		} catch (Exception e) {
			didCatchProperException = true;
		}
		Test.stopTest();

		System.assert(didCatchProperException, 'No exception is thrown!');
	}

	static testmethod void updateIntermediateStageForQuotesAcceptedTest() {
		Apttus_Proposal__Proposal__c quoteProposal = [SELECT Id FROM Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Proposal_Name__c = 'Test Data' LIMIT 1];

		Test.startTest();
		Datetime startTime = Datetime.now();
		//set to Accepted (valid transition though it's not yet on either of the views)
		DS_ProposalController.updateIntermediateStageForQuotes(quoteProposal.Id, CSWXGlobalConstant.Approval_stage_accepted);
		System.debug('Duration of accept = ' + (Datetime.now().getTime()-startTime.getTime()) + 'msec = ');
		//set back to Approved (invalid transition)
		Boolean didCatchProperException = false;
		try {
			DS_ProposalController.updateIntermediateStageForQuotes(quoteProposal.Id, CSWXGlobalConstant.Approval_stage_approved);
		} catch (AuraHandledException e) {
			didCatchProperException = true;
			System.debug('updateIntermediateStageForQuotesAcceptedTest exception = ' + e.getMessage());
		}
		Test.stopTest();

		System.assert(didCatchProperException, 'No exception is thrown!');
	}
}