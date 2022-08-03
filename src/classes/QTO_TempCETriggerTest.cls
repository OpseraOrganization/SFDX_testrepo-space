/*
Name - QTO_TempCETriggerHelperTest
Test Class For - QTO_TempCETriggerHelper, QTO_TempCETriggerHandler, QTO_TempCETrigger
Created - Neeharika Upadrasta, Nokia, Oct/14/2020
*/
@isTest
public with sharing class QTO_TempCETriggerTest {

	@testsetup
	static void setupData(){
		
		//Create Account
		Account acc1 = new Account(name='LegalEntity',
								  Acc_No__c='1003451233',
								  BillingCity='San Francisco',
								  BillingState='California',
								  BillingCountry='United States of America',
								  BillingStreet='143 West Ken',
								  BillingPostalCode='94404');
		Account acc2 = new Account(name='Customer',Acc_No__c='3003154',
								   BillingCity='San Francisco',
								   BillingState='California',
								   BillingCountry='United States of America',
								   BillingStreet='143 West Ken',
								   BillingPostalCode='94404');
		List<Account> accList = new List<Account>{acc1,acc2};
		insert acclist;
		
		acc1.ParentId = acc2.Id;
		update acc1;
		
		//Create Product codes
		Product2 prod1 = new Product2(name='prod1', ProductCode='1234');
		insert prod1;
			   
	}
	
	@isTest
	static void testmethod1Insert(){
		test.startTest();
		List<Account> acclist = new List<Account>([Select Id,Acc_No__c from Account where ParentId!=null limit 1]);
		QTO_Temp_CE__c tempCE1 = new QTO_Temp_CE__c(QTO_ProductCode__c='1234',
												   QTO_Authorized_Quantity__c=4,
												   QTO_Comments__c='New insert',
												   QTO_EntitlementStartDate__c=date.today(),
												   QTO_EntitlementEndDate__c=date.today()+365,
												   QTO_EndUser__c=acclist[0].Acc_No__c,
												   QTO_Importer__c=acclist[0].Acc_No__c,
												   QTO_SoldToParty__c=acclist[0].Acc_No__c);
		insert tempCE1;
		test.stopTest();
		
		Commercial_Entitlement__c ce = [Select Id,Authorised_Quantity__c from Commercial_Entitlement__c limit 1];
		system.assertEquals(4, ce.Authorised_Quantity__c);
	}
	
	@isTest
	static void testmethod2Update(){
		test.startTest();
		List<Account> acclist = new List<Account>([Select Id,Acc_No__c from Account where ParentId!=null limit 1]);
		QTO_Temp_CE__c tempCE1 = new QTO_Temp_CE__c(QTO_ProductCode__c='1234',
												   QTO_Authorized_Quantity__c=4,
												   QTO_Comments__c='New insert 2',
												   QTO_EntitlementStartDate__c=date.today(),
												   QTO_EntitlementEndDate__c=date.today()+365,
												   QTO_EndUser__c=acclist[0].Acc_No__c,
												   QTO_Importer__c=acclist[0].Acc_No__c,
												   QTO_SoldToParty__c=acclist[0].Acc_No__c);
		insert tempCE1;
		
		tempCE1.QTO_Authorized_Quantity__c = 7;
		tempCE1.QTO_Comments__c = 'Quantity updated';
		update tempCE1;
		
		test.stopTest();
		
		Commercial_Entitlement__c ce = [Select Id,Authorised_Quantity__c from Commercial_Entitlement__c limit 1];
		system.assertEquals(7, ce.Authorised_Quantity__c);
	}
	
	@isTest
	static void testmethod3Invalid(){
		test.startTest();
		List<Account> acclist = new List<Account>([Select Id,Acc_No__c from Account where ParentId!=null limit 1]);
		QTO_Temp_CE__c tempCE1 = new QTO_Temp_CE__c(QTO_ProductCode__c='1234',												   
												   QTO_Comments__c='New insert 2',
													QTO_Authorized_Quantity__c=4,
												   QTO_EntitlementStartDate__c=date.today(),
												   QTO_EntitlementEndDate__c=date.today()+365,
												   QTO_EndUser__c=acclist[0].Acc_No__c,
												   QTO_Importer__c=acclist[0].Acc_No__c,
												   QTO_SoldToParty__c=acclist[0].Acc_No__c);
		QTO_Temp_CE__c tempCE2 = new QTO_Temp_CE__c(QTO_ProductCode__c='1',												   
												   QTO_Comments__c='New insert 2',
													QTO_Authorized_Quantity__c=4,
												   QTO_EntitlementStartDate__c=date.today(),
												   QTO_EntitlementEndDate__c=date.today()+365,
												   QTO_EndUser__c=acclist[0].Acc_No__c,
												   QTO_Importer__c=acclist[0].Acc_No__c,
												   QTO_SoldToParty__c=acclist[0].Acc_No__c);
		
		try{
			insert new List<QTO_Temp_CE__c>{tempCE1, tempCE2} ;
		}
		catch(exception ex){
			system.assert(ex!=null);
		}
		
		test.stopTest();
	}
}