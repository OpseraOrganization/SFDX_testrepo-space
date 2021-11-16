/**
 * About
 * -----
 * @Description	  : This class contains unit tests for Agreement Invoicing Milestones in Agreement Related List View
 * @Project		  : CLM QTO
 * @Modification Log :
 *  Created  : 2020 11 23 – gyorgyi.kovacs@nokia.com
 *  Modified :
 * -----
**/
@isTest
private with sharing class CLM_AIMControllerTest {

	private static Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c();
	private static List<CLM_Agreement_Invoicing_Milestone__c> aims = new List<CLM_Agreement_Invoicing_Milestone__c>();
	private static CLM_AIMController.CLM_AIMWrapper wrap;

	@testSetup
	static void testSetup() {
		User u = TestDataFactory.userCreation(1,GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		insert u;
		System.runAs(u) {
			List<Account> accounts = TestDataFactory.createAccount(5);
			for(Integer i = 0; i < accounts.size(); i++) {
	accounts[i].AccountNumber = '301030998' + i;
			}
			insert accounts;

			//OPPORTUNITIES
			// direct Opportunity
			Opportunity o = TestDataFactory.OpportunityCreation(1, accounts[0])[0];
			o.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
			o.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(CSWXGlobalConstant.DIRECTRECORDTYPEOPPORTUNITY).getRecordTypeId();
			o.Lead_BG__c = 'MN';
			o.Description = 'Test Description 1';
			o.Amount = 111111;
			o.End_Customer__c = accounts[0].Id;
			o.Indirect_Reseller_Account__c = accounts[1].Id;
			o.Account_Role__c = 'Alliance Partner';
			o.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
			insert o;

			Apttus__APTS_Agreement__c a = new Apttus__APTS_Agreement__c();
			a.Name = 'Test Agreement';
			a.Apttus__Account__c = accounts[2].Id;
			a.CurrencyIsoCode = 'EUR';
			a.Delivery_System__c = 'Scratch Order via P20';
			a.ERP__c = 'P20';
			a.Sales_Mode__c = 'Corporate Sales Mode';
			a.Confidence_Level__c = 'Low Level';
			a.Apttus__Related_Opportunity__c = o.Id;
			insert a;
		}
	}

	public static testmethod void getAgreementInvoicingMilestonesWithNullAgreementTest() {
		User u = TestDataFactory.userCreation(1, GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		insert u;
		System.runAs(u) {
			Test.startTest();
	wrap = (CLM_AIMController.CLM_AIMWrapper) JSON.deserialize(CLM_AIMController.getAgreementInvoicingMilestones(null), CLM_AIMController.CLM_AIMWrapper.class);
	aims = (List<CLM_Agreement_Invoicing_Milestone__c>) wrap.aims;
			Test.stopTest();
		}
		System.assertEquals(0, aims.size(), 'Size of the result is not 0');
	}

	public static testmethod void getAgreementInvoicingMilestonesWithoutClassAccess() {
		agreement = [SELECT Id FROM Apttus__APTS_Agreement__c WHERE Name = 'Test Agreement'];
		User u = TestDataFactory.userCreation(1, 'Nokia Read Only')[0];
		insert u;
		System.runAs(u) {
			Test.startTest();
	wrap = (CLM_AIMController.CLM_AIMWrapper) JSON.deserialize(CLM_AIMController.getAgreementInvoicingMilestones(agreement.Id), CLM_AIMController.CLM_AIMWrapper.class);
	aims = (List<CLM_Agreement_Invoicing_Milestone__c>) wrap.aims;
			Test.stopTest();
		}
		System.assertEquals(0, aims.size(), 'Size of the result is not 0');
	}

	public static testmethod void getAgreementInvoicingMilestonesTest() {
		agreement = [SELECT Id FROM Apttus__APTS_Agreement__c WHERE Name = 'Test Agreement'];
		List<CLM_Agreement_Invoicing_Milestone__c> aimsResult = new List<CLM_Agreement_Invoicing_Milestone__c>();
		User u = TestDataFactory.userCreation(1, /*GlobalConstants.SYSTEM_AdMINISTRATOR*/ 'Nokia Sales Profile')[0];
		insert u;
		System.runAs(u) {
			Test.startTest();
	wrap = (CLM_AIMController.CLM_AIMWrapper) JSON.deserialize(CLM_AIMController.getAgreementInvoicingMilestones(agreement.Id), CLM_AIMController.CLM_AIMWrapper.class);
	aims = (List<CLM_Agreement_Invoicing_Milestone__c>) wrap.aims;
			Test.stopTest();
			aimsResult = [SELECT Id, Category__c FROM CLM_Agreement_Invoicing_Milestone__c WHERE Agreement__c =: agreement.Id];
		}
		System.assertEquals(aimsResult.size(), aims.size(), 'Size does not match');
		System.assertEquals(aimsResult[0].Category__c, aims[0].Category__c, 'Category does not match');
	}
}