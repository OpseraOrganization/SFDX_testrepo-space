/**
 * @description	   : 
 * @author			: Yashdeep Prajapati
 * @group			 : 
 * @last modified on  : 06-29-2021
 * @last modified by  : Yashdeep Prajapati
 * Modifications Log 
 * Ver   Date		 Author			   Modification
 * 1.0   06-24-2021   Yashdeep Prajapati   Initial Version
**/
@isTest
public without sharing class NokiaCPQ_DataUpdateTest{
	@TestSetup
	static void makeData(){
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[0].Acc_No__c = 'RG_NAMtest';
		accounts[1].Acc_No__c ='RG_NAMtest1';
		accounts[0].GEOLevel1ID__c = 'RG_NAM';
		accounts[1].GEOLevel1ID__c = 'RG_NAM';
		accounts[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		accounts[1].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;
		Apttus_Config2__PriceList__c testPriceList = new Apttus_Config2__PriceList__c(
			Name = 'Commercial Price List', 
			PriceList_Type__c='Partner',
			Apttus_Config2__Type__c='Standard',
			Apttus_Config2__Active__c = True,
			Apttus_Config2__AccountId__c = accounts[0].id,
			Apttus_Config2__ContractNumber__c = '123Test'
			);
		insert testPriceList;
		testPriceList.CPQ_Region__c = null;
		update testPriceList;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].Account_Role__c = 'Alliance Partner';
		opportunities[0].Contract_Price_List__c = testPriceList.id;
		opportunities[0].End_Customer_LE__c = accounts[1].id;
		insert opportunities;
		opportunities[0].NokiaCPQ_Region__c = null;
		update opportunities[0];
	}

	@IsTest
	static void testBatch(){
		
		Test.startTest();
		Database.executeBatch(new NokiaCPQ_DataUpdate());
		Test.stopTest();
		
	}
}