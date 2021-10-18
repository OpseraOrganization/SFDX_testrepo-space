/****************************************
* Name : AgreementTriggerHelperTest
* Author : Accenture
* Modified by: Gyorgyi Kovacs, Nokia
*****************************************/
@isTest 
private with sharing class AgreementTriggerHelperTest {

	public static final String NEW_DESCRIPTION = 'New Description';
	public static final Decimal NEW_AMOUNT = 999999;
	public static final String OLD_BG = 'MN';
	public static final String NEW_BG = 'NI';
	public static final String MANUALLY_CHANGED_DESCRIPTION = 'Manually Changed Description';
	public static final String ERROR_LEAD_BG_DOES_NOT_MATCH = 'Lead BG does not match!';
	public static final String ERROR_DESCRIPTION_DOES_NOT_MATCH = 'Description does not match!';
	public static final String ERROR_TCV_DOES_NOT_MATCH = 'Total Contract Value does not match!';
  
	@testSetup
	static void testSetup() {
		User u = TestDataFactory.userCreation(1, 'System Administrator')[0]; 
		insert u;
		System.runAs(u) {
			List<Account> accounts = TestDataFactory.createAccount(6);
			for(Integer i = 0; i < accounts.size(); i++) {
	accounts[i].AccountNumber = '301030999' + i;
			}
			accounts[5].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(CSWXGlobalConstant.DS_legalEntity).getRecordTypeId();
			insert accounts;

			//OPPORTUNITIES
			List<Opportunity> opportunities = new List<Opportunity>();
			// direct Opportunity
			Opportunity o1 = TestDataFactory.OpportunityCreation(1, accounts[0])[0];
			o1.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
			o1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(CSWXGlobalConstant.DIRECTRECORDTYPEOPPORTUNITY).getRecordTypeId();
			o1.Lead_BG__c = OLD_BG;
			o1.Description = 'Test Description 1';
			o1.Amount = 111111;
			o1.End_Customer__c = accounts[1].Id;
			o1.Indirect_Reseller_Account__c = accounts[2].Id;
			o1.Account_Role__c = 'Alliance Partner';
			o1.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
			opportunities.add(o1);

			// indirect Opportunity
			Opportunity o2 = TestDataFactory.OpportunityCreation(1, accounts[0])[0];
			o2.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
			o2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(CSWXGlobalConstant.INDIRECTRECORDTYPEOPPORTUNITY).getRecordTypeId();
			o2.Lead_BG__c = 'MN';
			o2.Description = 'Test Description 2';
			o2.Amount = 222222;
			o2.End_Customer__c = accounts[3].Id;
			o2.Indirect_Reseller_Account__c = accounts[4].Id;
			o2.Account_Role__c = 'GPP VAR partner';
			o2.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
			o2.End_Customer_LE__c = accounts[5].Id;
			opportunities.add(o2);
			insert opportunities;

			// OPPORTUNITY TEAM MEMBERS
			List<User> otmUsers = TestDataFactory.userCreation(3, 'Non-Sales User Profile');
			insert otmUsers;

			List<OpportunityTeamMember> otms = new List<OpportunityTeamMember>();
			OpportunityTeamMember otmCCM1 = TestDataFactory.optyTeamMemberCreation(1, otmUsers[0], opportunities[0])[0];
			otmCCM1.TeamMemberRole = 'Commercial Contract Manager and Legal';
			otms.add(otmCCM1);
			OpportunityTeamMember otmPCM1 = TestDataFactory.optyTeamMemberCreation(1, otmUsers[1], opportunities[0])[0];
			otmPCM1.TeamMemberRole = 'Project Contract Manager';
			otms.add(otmPCM1);
			OpportunityTeamMember otmCDM1 = TestDataFactory.optyTeamMemberCreation(1, otmUsers[2], opportunities[0])[0];
			otmCDM1.TeamMemberRole = 'One Customer Delivery Manager';
			otms.add(otmCDM1);

			OpportunityTeamMember otmCCM2 = TestDataFactory.optyTeamMemberCreation(1, otmUsers[0], opportunities[1])[0];
			otmCCM2.TeamMemberRole = 'Commercial Contract Manager and Legal';
			otms.add(otmCCM2);
			OpportunityTeamMember otmPCM2 = TestDataFactory.optyTeamMemberCreation(1, otmUsers[1], opportunities[1])[0];
			otmPCM2.TeamMemberRole = 'Project Contract Manager';
			otms.add(otmPCM2);
			OpportunityTeamMember otmAM2 = TestDataFactory.optyTeamMemberCreation(1, otmUsers[2], opportunities[1])[0];
			otmAM2.TeamMemberRole = 'Account Manager';
			otms.add(otmAM2);
			insert otms;
		}
	}

	/*------------------------------------------------------------------------------------------------*/
	public static testmethod void populateFieldsTestWhenAgreementNull() {
		Boolean didCatchProperException = false;
		try {
			AgreementTriggerHelper.populateFieldsForNewAgreement(null);
		} catch (IllegalArgumentException e) {
			didCatchProperException = true;
		}
		System.assert(didCatchProperException, 'No exception is thrown! (1)');
	}
	public static testmethod void populateFieldsTestWhenAllNull() {
		Boolean didCatchProperException = false;
		try {
			AgreementTriggerHelper.updateAgreementFieldsOnOpportunityChange(null, null);
		} catch (IllegalArgumentException e) {
			didCatchProperException = true;
		}
		System.assert(didCatchProperException, 'No exception is thrown! (2)');
	}

	public static testmethod void populateFieldsTestWhenOneOpptyNull() {
		Boolean didCatchProperException = false;
		Account account = getAccount();
		Opportunity opp1 = TestDataFactory.OpportunityCreation(1, account)[0];
		Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
		oppMap.put(opp1.Id, opp1);

		try {
			AgreementTriggerHelper.updateAgreementFieldsOnOpportunityChange(null, oppMap);
		} catch (IllegalArgumentException e) {
			didCatchProperException = true;
		}
		System.assert(didCatchProperException, 'No exception is thrown! (3)');
	}

	public static testmethod void populateFieldsTestWhenOneOpptyEmpty() {
		Boolean didCatchProperException = false;
		Map<Id, Opportunity> oppMapEmpty = new Map<Id, Opportunity>();
		try {
			AgreementTriggerHelper.updateAgreementFieldsOnOpportunityChange(oppMapEmpty, null);
		} catch (IllegalArgumentException e) {
			didCatchProperException = true;
		}
		System.assert(didCatchProperException, 'No exception is thrown! (4)');
	}

	public static testmethod void populateFieldsWithNewAgreementTest() {
		Account account = getAccount();
		List<Opportunity> opportunities = getOpportunities();
		List<Apttus__APTS_Agreement__c> agreements = createAgreements(account, opportunities);

		Test.startTest();
			insert agreements; // this fires AgreementTriggerHelper.populateFieldsForNewAgreement(agreements)
		Test.stopTest();

		List<Apttus__APTS_Agreement__c> result = getAgreements();
		List<CLM_Agreement_Invoicing_Milestone__c> milestones = getMilestones();

		System.assertEquals(opportunities[0].Lead_BG__c, result[0].Lead_BG__c, ERROR_LEAD_BG_DOES_NOT_MATCH);
		System.assertEquals(opportunities[0].Description, result[0].Apttus__Description__c, ERROR_DESCRIPTION_DOES_NOT_MATCH);
		System.assertEquals(opportunities[0].Amount, result[0].Apttus__Total_Contract_Value__c, ERROR_TCV_DOES_NOT_MATCH);
		
	}

	public static testmethod void createMilestonesWithNull() {
		Boolean didCatchProperException = false;
		try {
			AgreementTriggerHelper.createMilestones(null);
		} catch (IllegalArgumentException e) {
			didCatchProperException = true;
		}
		System.assert(didCatchProperException, 'No exception is thrown! (5)');
	}

	public static testmethod void populateFieldsWithOpportunityUpdateTest() {
		Account account = getAccount();
		List<Opportunity> opportunities = getOpportunities();
		List<Apttus__APTS_Agreement__c> agreements = createAgreements(account, opportunities);
		insert agreements; // trigger fires, initial copy done from Oppty

		Map<Id, Opportunity> oldOpps = new Map<Id, Opportunity>();
		for (Opportunity o : opportunities) {
			oldOpps.put(o.Id, o);
		}

		Map<Id, Opportunity> newOpps = new Map<Id, Opportunity>();
		Opportunity newOpp = opportunities[0].clone(true, true, false, true);
		newOpp.Lead_BG__c = NEW_BG;
		newOpp.Description = NEW_DESCRIPTION;
		newOpp.Amount = NEW_AMOUNT;
		newOpps.put(newOpp.Id, newOpp);
		newOpps.put(opportunities[1].Id, opportunities[1]);

		Test.startTest();
			AgreementTriggerHelper.updateAgreementFieldsOnOpportunityChange(oldOpps, newOpps);
		Test.stopTest();

		List<Apttus__APTS_Agreement__c> agreementResult = getAgreements();

		System.assertEquals(OLD_BG, agreementResult[0].Lead_BG__c, ERROR_LEAD_BG_DOES_NOT_MATCH); // Lead BG should not be copied again
		System.assertEquals(NEW_DESCRIPTION, agreementResult[0].Apttus__Description__c, ERROR_DESCRIPTION_DOES_NOT_MATCH);
		System.assertEquals(NEW_AMOUNT, agreementResult[0].Apttus__Total_Contract_Value__c, ERROR_TCV_DOES_NOT_MATCH);

	}

	public static testmethod void populateFieldsWithOpportunityUpdate2Test() {
		Account account = getAccount();
		List<Opportunity> opportunities = getOpportunities();
		List<Apttus__APTS_Agreement__c> agreements = createAgreements(account, opportunities);
		insert agreements; // trigger fires, initial copy done from Oppty

		opportunities[0].Lead_BG__c = NEW_BG;
		opportunities[0].Description = NEW_DESCRIPTION;
		opportunities[0].Amount = NEW_AMOUNT;

		Test.startTest();
			update opportunities[0];
		Test.stopTest();

		List<Apttus__APTS_Agreement__c> agreementResult = getAgreements();

		System.assertEquals(OLD_BG, agreementResult[0].Lead_BG__c, ERROR_LEAD_BG_DOES_NOT_MATCH); // Lead BG should not be copied again
		System.assertEquals(NEW_DESCRIPTION, agreementResult[0].Apttus__Description__c, ERROR_DESCRIPTION_DOES_NOT_MATCH);
		System.assertEquals(NEW_AMOUNT, agreementResult[0].Apttus__Total_Contract_Value__c, ERROR_TCV_DOES_NOT_MATCH);
	}

	public static testmethod void populateFieldsWithOpportunityUpdateWithoutAgreementTest() {
		Account account = getAccount();
		List<Opportunity> opportunities = getOpportunities();

		Map<Id, Opportunity> oldOpps = new Map<Id, Opportunity>();
		for (Opportunity o : opportunities) {
			oldOpps.put(o.Id, o);
		}

		Map<Id, Opportunity> newOpps = new Map<Id, Opportunity>();
		Opportunity newOpp = opportunities[0].clone(true, true, false, true);
		newOpp.Lead_BG__c = NEW_BG;
		newOpp.Description = NEW_DESCRIPTION;
		newOpp.Amount = NEW_AMOUNT;
		newOpps.put(newOpp.Id, newOpp);
		newOpps.put(opportunities[1].Id, opportunities[1]);

		Test.startTest();
			AgreementTriggerHelper.updateAgreementFieldsOnOpportunityChange(oldOpps, newOpps);
		Test.stopTest();

		List<Apttus__APTS_Agreement__c> agreementResult = getAgreements();

		System.assertEquals(0, agreementResult.size(), 'Agreement size does not match');
	}

	public static testmethod void populateFieldsWithOpportunityUpdateWhenAgreementChangedTest() {
		Account account = getAccount();
		List<Opportunity> opportunities = getOpportunities();
		List<Apttus__APTS_Agreement__c> agreements = createAgreements(account, opportunities);
		insert agreements; // trigger fires, initial copy done from Oppty

		agreements[0].Apttus__Description__c = MANUALLY_CHANGED_DESCRIPTION;
		update agreements;

		Map<Id, Opportunity> oldOpps = new Map<Id, Opportunity>();
		for (Opportunity o : opportunities) {
			oldOpps.put(o.Id, o);
		}

		Map<Id, Opportunity> newOpps = new Map<Id, Opportunity>();
		Opportunity newOpp = opportunities[0].clone(true, true, false, true);
		newOpp.Description = NEW_DESCRIPTION;
		newOpp.Amount = NEW_AMOUNT;
		newOpps.put(newOpp.Id, newOpp);
		newOpps.put(opportunities[1].Id, opportunities[1]);

		Test.startTest();
			AgreementTriggerHelper.updateAgreementFieldsOnOpportunityChange(oldOpps, newOpps);
		Test.stopTest();

		List<Apttus__APTS_Agreement__c> agreementResult = getAgreements();

		System.assertEquals(MANUALLY_CHANGED_DESCRIPTION, agreementResult[0].Apttus__Description__c, ERROR_DESCRIPTION_DOES_NOT_MATCH); // once it has been changed manually, Description shall not be synced from Opportunity.
		System.assertEquals(NEW_AMOUNT, agreementResult[0].Apttus__Total_Contract_Value__c, ERROR_TCV_DOES_NOT_MATCH);
	}

	public static testmethod void checkMandatoryFieldsTest(){

		List<DS_Agreement_Validation__c> avs = new List<DS_Agreement_Validation__c>();
		DS_Agreement_Validation__c av1 = new DS_Agreement_Validation__c();
		av1.Name = 'ERP is P20';
		av1.ERP__c = 'P20';
		av1.Agreement_MandatoryFields__c = 'Apttus_CMConfig__PaymentTermId__c,Inco_Term_Description__c,Sold_to_party_number__c,Payer__c,Delivery_System__c,Sales_Org_Number__c,Sales_Office_Number__c,Sales_Group_Number__c,Dist_Channel__c';
		av1.Agreement_MandatoryFields2__c = 'Division__c,WBS_Number__c,Sales_Mode__c,Nokia_Legal_Entity__c,Apttus_CMConfig__PayoutFrequency__c,Apttus_CMConfig__BillToAccountId__c';
		av1.Agreement_MandatoryFields3__c = 'ERP__c';
		avs.add(av1);

		DS_Agreement_Validation__c av2 = new DS_Agreement_Validation__c();
		av2.Name = 'ERP is Blue Planet';
		av2.ERP__c = 'Blue Planet';
		av2.Agreement_MandatoryFields__c = 'ERP__c,Apttus_CMConfig__PaymentTermId__c,Inco_Term_Description__c,Sold_to_party_number__c,Payer__c,Delivery_System__c,WBS_Number__c,Sales_Mode__c,Nokia_Legal_Entity__c';
		av2.Agreement_MandatoryFields2__c = 'Apttus_CMConfig__PayoutFrequency__c,Apttus_CMConfig__BillToAccountId__c';
		av2.Agreement_MandatoryFields3__c = null;
		avs.add(av2);

		insert avs;

		Account account = getAccount();
		List<Opportunity> opportunities = getOpportunities();
		List<Apttus__APTS_Agreement__c> agreements = createAgreements(account, opportunities);
		agreements[0].ERP__c = 'P20';
		agreements[0].Confidence_Level__c = 'Low Level';
		agreements[1].ERP__c = 'Blue Planet';
		agreements[1].Confidence_Level__c = 'Low Level';
		insert agreements;

		Map<Id,Apttus__APTS_Agreement__c> oldRecords1 = new Map<Id,Apttus__APTS_Agreement__c>();
		oldRecords1.put(agreements[0].Id, agreements[0]);
		Map<Id,Apttus__APTS_Agreement__c> oldRecords2 = new Map<Id,Apttus__APTS_Agreement__c>();
		oldRecords2.put(agreements[1].Id, agreements[1]);

		Test.startTest();
			AgreementTriggerHelper.checkMandatoryFields(agreements);

			AgreementTriggerHandler.checkMandatoryFields(agreements, oldRecords1);
			AgreementTriggerHandler.checkMandatoryFields(agreements, oldRecords2);

			AgreementTriggerHelper.checkMandatoryFields(null);
			AgreementTriggerHandler.checkMandatoryFields(null,null);
			AgreementTriggerHelper.getMandatoryFields();
		Test.stopTest();
	}

	/*------------------------------------------------------------------------------------------------*/
	private static List<Apttus__APTS_Agreement__c> createAgreements(Account account, List<Opportunity> opportunities) {
		// AGREEMENTS
		List<Apttus__APTS_Agreement__c> agreements = new List<Apttus__APTS_Agreement__c>();
		for (Integer i = 0; i < opportunities.size(); i++) {
			Apttus__APTS_Agreement__c a = new Apttus__APTS_Agreement__c();
			a.Name = 'Test Agreement ' + (i+1);
			a.Apttus__Account__c = account.Id;
			a.CurrencyIsoCode = 'EUR';
			a.Delivery_System__c = 'Scratch Order via P20';
			a.ERP__c = 'P20';
			a.Sales_Mode__c = 'Corporate Sales Mode';
			a.Confidence_Level__c = 'Low Level';
			a.Lead_BG__c = 'MN';
			a.Apttus__Related_Opportunity__c = opportunities[i].Id;
			a.Apttus__Total_Contract_Value__c =  opportunities[i].Amount;
			a.Apttus__Description__c = opportunities[i].Description;
			agreements.add(a);
		}
		return agreements;
	}

	private static Account getAccount() {
		return [SELECT Id FROM Account LIMIT 1];
	}

	private static List<Opportunity> getOpportunities() {
		return [SELECT Id, Lead_BG__c, Description, Amount, Account_Role__c, End_Customer__c FROM Opportunity];
	}

	private static List<Apttus__APTS_Agreement__c> getAgreements() {
		return [SELECT Id, Apttus__Account__c, Apttus__Related_Opportunity__c, Apttus_CMConfig__BillToAccountId__c, Apttus__Description__c, Lead_BG__c, Payer__c, Apttus_CMConfig__ShipToAccountId__c, Apttus__Total_Contract_Value__c, Account_Role__c, End_Customer__c
		FROM Apttus__APTS_Agreement__c];
	}

	private static List<CLM_Agreement_Invoicing_Milestone__c> getMilestones() {
		return [SELECT Id, Agreement__c, Category__c
		FROM CLM_Agreement_Invoicing_Milestone__c];
	}
}