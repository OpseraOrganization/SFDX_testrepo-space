/****************************************
* Class Name : Batch_EDPSuppliersToAccountTest
* Created By : Raj Dubey
* Last Modified by: 
* Last Modified Date: 
* Description : Test classs for Batch_EDPSuppliersToAccount
*****************************************/
@isTest
public class Batch_EDPSuppliersToAccountTest 
{  
	@testSetup
	static void createTestData()
	{	 
		Id vendorRecordTypeId =
		Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
		.get('Vendor').getRecordTypeId();
	Id legalEntityRecordTypeId =
		Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
		.get('Legal_Entity').getRecordTypeId();
		List <Supplier_Staging__c> supplierList = new List <Supplier_Staging__c>();
		List<Account> accList = new List<Account>();
		Supplier_Staging__c supp1 = new Supplier_Staging__c();
		
			supp1.Supplier_ID__c = '211011';
			supp1.Company_Name__c = 'TEKNOLOGIAINFO TEKNOVA OY OY';
			supp1.Current_Supplier_Role__c = 'Vendor'; 
			supp1.URL__c = 'www.abcd.com';		 
			supp1.Street_Name__c = 'ETELÄRANTA 10';
			supp1.City__c = 'HELSINKI' ;
			supp1.Name_Of_Street_District__c = 'Karnataka';
			supp1.ZIP_Code__c = '560076';
			supp1.Country__c = 'IN';
			supp1.Company_Lifecycle_Status__c= 'true';
			supp1.Is_Processed__c = False;
		
		
		Supplier_Staging__c supp2 = new Supplier_Staging__c();
		
			supp2.Supplier_ID__c = '2110123';
			supp2.Company_Name__c = 'TEKNOLOGIAINFO TEKNOVA OY OY';
			supp2.Current_Supplier_Role__c = 'Vendor'; 
			supp2.URL__c = 'www.abcd.com';		 
			supp2.Street_Name__c = 'ETELÄRANTA 10';
			supp2.City__c = 'HELSINKI' ;
			supp2.Name_Of_Street_District__c = 'California';
			supp2.ZIP_Code__c = '';
			supp2.Country__c = 'POP';
			//supp2.EDP_LastModifiedDate__c= DateTime.valueOf('2019-06-25 16:13:22');
			supp2.Is_Processed__c = False;
		
		supplierList.add(supp1);
		supplierList.add(supp2);
		
		Account acc = new Account ();  
		
	acc.AccountNumber = 'Accn1234';	  
	acc.ALCR_Record_Type__c = 'Vendor';
	acc.Type = 'Vendor';	 
	//acc.RecordTypeId = legalEntityRecordTypeId;
	//BillingCity = supp.City__c,
					acc.BillingCountryCode  = 'IN';
					acc.BillingState = 'Karnataka';			
					acc.BillingStreet = 'Church Street';
					acc.BillingPostalCode = '560077'; 
		acc.RecordTypeId = vendorRecordTypeId; 
	acc.Country__c = 'India';	 
	acc.Name = 'test';
	acc.default_legal_entity__c = false;
	acc.Active__c = true;
		
		accList.add(acc);
		 Account acc1 = new Account ();  
		
	acc1.AccountNumber = 'Accn1234';	  
	acc1.ALCR_Record_Type__c = 'Vendor';
	acc1.Type = 'Vendor';	 
	//acc1.RecordTypeId = legalEntityRecordTypeId;
			 acc1.BillingCountryCode  = 'IN';
					acc1.BillingState = 'Karnataka';			
					acc1.BillingStreet = 'Church Street';
					acc1.BillingPostalCode = '560077';
		acc1.RecordTypeId = vendorRecordTypeId;
	acc1.Country__c = 'Sweden';	 
	acc1.Name = 'test';
	acc1.default_legal_entity__c = true;
	acc1.Active__c = false;
		
		accList.add(acc1);
		Insert accList;
		
		
		Insert supplierList;
		
	}
	
	
	
	@isTest
	static void testBatch()
	{
		Test.startTest();
		
		
		Batch_EDPSuppliersToAccount batch = new Batch_EDPSuppliersToAccount();
		Database.executeBatch(batch, 200) ;
	 
		Test.StopTest();
	
		
		
	}   
	
	
}