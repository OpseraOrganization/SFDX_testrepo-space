/****************************
   Class Name:Nokia_QuoteLifecycleCallBackTest
   Created by: Accenture
   Created Date: 29 July 2019
   Description: Test class for Nokia_QuoteLifecycleCallBack
 *******************************/
@istest

public class Nokia_QuoteLifecycleCallBackTest
{

static testmethod void testmethod1()
{
	List<User> userList = new List<User>();
	userList = TestDataFactory.userCreation(1,'Data Loader Profile');

	System.runAs(userList[0]){


		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].AccountNumber='301030872';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;

		List<Account> acclist = new List<Account>();
		acclist.add(accounts[0]);

		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,acclist);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = accounts[1].id;
		insert opportunities;

		Offer__c offer = TestDataFactory.OfferCreation(1, opportunities[0])[0];
		insert offer;


		//create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Premium';
		accreditations[1].Pricing_Level_Override__c = 'Premium';
		insert accreditations;


		test.startTest();
		Apttus_Proposal__Proposal__c proposal =new Apttus_Proposal__Proposal__c(
			Apttus_Proposal__Account__c = accounts[0].Id,
			Apttus_Proposal__Opportunity__c = opportunities[0].Id,
			NokiaCPQ_Portfolio__c  = 'IP Routing',
			//NokiaCPQ_No_of_Years__c	= '1',
			//NokiaCPQ_Maintenance_Type__c  = 'Gold (Return for Repair)',
			Offer__c = offer.id,
			Quote_Status__c='Price',
			//Offer__c= offer.id,
			Submitted_Date__c = System.today(),
			RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId()//direct draft quote
			);
		insert proposal;

		Apttus_Proposal__Proposal__c proposal1 =new Apttus_Proposal__Proposal__c(
			Apttus_Proposal__Account__c = accounts[0].Id,
			Apttus_Proposal__Opportunity__c = opportunities[0].Id,
			NokiaCPQ_Portfolio__c  = 'IP Routing',
			//  NokiaCPQ_No_of_Years__c	= '1',
			//  NokiaCPQ_Maintenance_Type__c  = 'Gold (Return for Repair)',
			Quote_Status__c='Price',
			Submitted_Date__c = System.today(),
			RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId()//direct draft quote
			);
		insert proposal1;

		Apttus_Proposal__Proposal__c proposal5 =[select id,Submitted_Date__c,Quote_Type__c,Quote_Status__c from Apttus_Proposal__Proposal__c where id=: proposal.Id ];




		Apttus__APTS_Agreement__c agreement= new Apttus__APTS_Agreement__c();


		//String actiontype = Apttus_Proposal.CustomClass.ActionType.ACTION_CLONE;
		Nokia_QuoteLifecycleCallback qq = new Nokia_QuoteLifecycleCallback();
		qq.afterCreateFromAccount(proposal);
		qq.afterCreateFromOpportunity(proposal);
		qq.afterClone(proposal, proposal1);
		qq.afterComplete(proposal, Apttus_Proposal.CustomClass.ActionType.ACTION_CLONE);
		qq.afterCreateAgreement(proposal, agreement);
		qq.afterComplete(agreement,Apttus_Proposal.CustomClass.ActionType.ACTION_CLONE);
		qq.beforeClone(proposal, proposal1);

		test.stopTest();
	}

}

static testmethod void testmethod2()
{
	List<User> userList = new List<User>();
	userList = TestDataFactory.userCreation(1,'Data Loader Profile');

	System.runAs(userList[0]){
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].AccountNumber='301030872';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;

		List<Account> acclist = new List<Account>();
		acclist.add(accounts[0]);

		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,acclist);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = accounts[1].id;
		insert opportunities;

		Offer__c offer = TestDataFactory.OfferCreation(1, opportunities[0])[0];
		insert offer;

		//create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(4);
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[2].partner__c = accounts[0].Id;
		accreditations[3].partner__c = accounts[0].Id;
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Premium';
		accreditations[1].Pricing_Level_Override__c = 'Premium';
		accreditations[3].Accreditation_Type__c = 'Maintenance';
		accreditations[3].Accreditation_Level__c = 'Premium';
		accreditations[3].Pricing_Level_Override__c = 'Premium';
		accreditations[0].Portfolio__c = 'Fixed Access - FBA';
		accreditations[1].Portfolio__c = 'Fixed Access - FBA';
		accreditations[2].Portfolio__c = 'Fixed Access - POL';
		accreditations[3].Portfolio__c = 'Fixed Access - POL';
		insert accreditations;


		test.startTest();
		Apttus_Proposal__Proposal__c proposal =new Apttus_Proposal__Proposal__c(
			Apttus_Proposal__Account__c = accounts[0].Id,
			Apttus_Proposal__Opportunity__c = opportunities[0].Id,
			NokiaCPQ_Portfolio__c  = 'Fixed Networks',
			CPQ_SubPortfolio__c = 'Fixed Access - FBA',
			Offer__c = offer.id,
			Quote_Status__c='Price',
			Submitted_Date__c = System.today(),
			RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId()//indirect draft quote
			);
		insert proposal;

		Apttus_Proposal__Proposal__c proposal1 =new Apttus_Proposal__Proposal__c(
			Apttus_Proposal__Account__c = accounts[0].Id,
			Apttus_Proposal__Opportunity__c = opportunities[0].Id,
			NokiaCPQ_Portfolio__c  = 'Fixed Networks',
			CPQ_SubPortfolio__c = 'Fixed Access - FBA',
			Offer__c = offer.id,
			Quote_Status__c='Price',
			Submitted_Date__c = System.today(),
			RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId()//indirect draft quote
			);
		insert proposal1;

		Apttus_Proposal__Proposal__c proposal5 =[select id,Submitted_Date__c,Quote_Type__c,Quote_Status__c from Apttus_Proposal__Proposal__c where id=: proposal.Id ];
		Nokia_QuoteLifecycleCallback qq = new Nokia_QuoteLifecycleCallback();
		qq.afterClone(proposal, proposal1);
		test.stopTest();
	}

}

}