/****************************************
* Name : CCRE_Offers_ListTest
* Author : Accenture
* Description : Test class CCRE_Offers_List
*****************************************/
@IsTest
private with sharing class CCRE_Offers_ListTest {
	/******************************
	*Method Name: getProposalTest
	*Description: Test Method to cover getProposalTest
	********************************/
	public static Id swxquoteRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CCRE_Proposal').getRecordTypeId(); 
	static testmethod void getProposalTest(){
		
			Account acct = TestDataFactory.createAccount(1)[0];
			acct.AccountNumber='3011234567';
acct.Acc_No__c = '3011234567';
acct.CountryCode__c='IN';
			database.insert(acct);
			Opportunity oppty = TestDataFactory.OpportunityCreation(1,acct)[0];
			oppty.StageName = 'Develop Opportunity';
			oppty.Phase_Status__c = 'Opportunity in Progress';
			oppty.Lead_BG__c = 'MN';
			database.insert(oppty);
		
			Apttus_Proposal__Proposal__c quoteProposal = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
			quoteProposal.NokiaCPQ_Portfolio__c = 'IP Routing';
			//quoteProposal.NokiaCPQ_SSP_Level__c = 'Unlimited';
			quoteProposal.RecordTypeId=swxquoteRecordTypeId;
			quoteProposal.Apttus_Proposal__Opportunity__c=oppty.id;
			database.insert(quoteProposal);
		
			CCRE_Offers_List.getProposalOnLoad();
			CCRE_Offers_List.getProposal('Name567',true, '2017-12-20','Accepted');
			CCRE_Offers_List.getProposal('Name',false, '2017-12-20','Published');	   
			CCRE_Offers_List.getQuoteStages(); 
		  
		
		
	}

}