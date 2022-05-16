/****************************************
 * Name : ProductTriggerTest
 * Author : Accenture
 * Description : Test class for ProductTrigger and ProductTriggerHelper
 * Fixed by Salesforce Aug 15,2018
 *****************************************/
@isTest 
private class ProductTriggerTest { 
	@testSetup static void setup() {
		Product2 pr = NCP_TestFactory.createProduct();
		Account acc = NCP_TestFactory.createAccount();
		Account acc2 = NCP_TestFactory.createLegalAccount(acc.id);
		Contact cont = NCP_TestFactory.createContact(acc);
		AccountContactRelation acr = NCP_TestFactory.createAccountContactRelation(cont.Id, acc2.Id, true);
		ServiceContract scCDB = NCP_TestFactory.createServiceContract(acc2, 'CDB');
		//NCP_Product_Content__c pc = NCP_TestFactory.createProductService(pr.Id,'PIC');
		//contractLineItem cli = NCP_TestFactory.createContractLineItem(pr,scCDB);
	}

	/***********************
	* Method Name: productUpdateTest
	* Description: To create Product and update it
	* Parameters: NA
	************************/
	@isTest
	static void productUpdateTest() {

		User admin = CustomLeadConversionTest.createSystemAdminUser();
		System.runAs(admin) {
			List<Product2> prodList = new List<Product2>();
			Id prodRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Sales_Product').getRecordTypeId();
			Product_Hierarchy__c ph=new Product_Hierarchy__c();
			ph.Business_Group_Code__c='MN';
			ph.Business_Unit_Code__c='BUAASER';
			ph.Portfolio_Package_Code__c='L00147';
			ph.Business_Line_Code__c='L082002';
			database.insert(ph);

			//Creating a Product prod1
			Product2 prod1 = NCP_TestFactory.createProduct('Test1', '1231', 'MN', 'USD', 'IP Routing', 'Release', 1.00, true);
			//Creating a product prod2
			Product2 prod2 = NCP_TestFactory.createProduct('Test2', '1232', 'MN', 'USD', 'IP Routing', 'Maintain', 2.00, true);
			//Creating a product prod3
			Product2 prod3 = NCP_TestFactory.createProduct('Test3', '1233', 'MN', 'USD', 'IP Routing', '', 3.00, true);
			//Creating a product prod4
			Product2 prod4 = NCP_TestFactory.createProduct('Test4', '1234', 'MN', 'USD', 'Fixed Access - FBA', '', 4.00, true);

			Product2 prod5 = NCP_TestFactory.createProduct('Test4', '1234', 'MN', 'USD', 'Fixed Access - FBA', '', 5.00, true);

			prodList.add(prod1);
			prodList.add(prod2);
			prodList.add(prod3);
			prodList.add(prod4);
			prodList.add(prod5);

			//inserting the products created above
			insert prodList;
			Test.startTest();
			Product2 productTest2 = new Product2();
			productTest2 = [select Id, Apttus_Config2__Version__c from Product2 where Id = :prod1.Id];

			productTest2.Apttus_Config2__Version__c = 11.10;
			update productTest2;

			prod5.Product_Hierarchy__c = ph.Id;
			prod5.RecordTypeId = prodRecordTypeId;
			update prod5;

			CollaborationGroup CollaborationGroupObject = new CollaborationGroup();
			CollaborationGroupObject = TestDataFactory.createCollaborationGroup('Unlisted', 'Partner Users Group');
			database.insert(CollaborationGroupObject);

			TestDataFactory.createCollaborationGroupMember(CollaborationGroupObject.Id, admin.Id);

			//updating the List inserted above

			ProductTriggerHelper.sendChatter(prodList);
			Test.stopTest();
		}
	}

	@isTest
	static void TestDeleteProduct2() {
		User admin = NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev');
		System.runAs(admin) {

			Product2 simplePr = [SELECT Id FROM Product2 LIMIT 1];
			NCP_Favorite_Product__c favoritePr = NCP_TestFactory.createFavoriteProduct(simplePr, admin);

			// Perform test
			Test.startTest();
			Database.DeleteResult result = Database.delete(simplePr, false);
			List<Product2> checkIfExistList = [SELECT Id FROM Product2 WHERE Id = :simplePr.Id];

			System.assertEquals(checkIfExistList.size(), 0);
			Test.stopTest();
		}
	}

	@IsTest
	static void testInActiveProduct(){
		
		List<Product2> prods = TestDataFactory.productCreation(4);
		prods[0].IsActive = false;
		for (Product2 prod : prods) {
			prod.Portfolio__c = 'IP Routing';
		}
		insert prods;

		NokiaCPQ_Deactivated_Products__c dap1 = new NokiaCPQ_Deactivated_Products__c();
		dap1.NCPQ_Product__c = prods[0].id;
		insert dap1;

		List<Apttus_Config2__ProductOptionComponent__c> pocList = new List<Apttus_Config2__ProductOptionComponent__c>();
		Apttus_Config2__ProductOptionComponent__c productOptionComponentObj1 = TestDataFactory.CreateproductOptionComponent(prods[0].id,1)[0];
		productOptionComponentObj1.Apttus_Config2__ParentProductId__c = prods[2].id;
		productOptionComponentObj1.Apttus_Config2__Sequence__c = 46511;
		pocList.add(productOptionComponentObj1);

		Apttus_Config2__ProductOptionComponent__c productOptionComponentObj2 = TestDataFactory.CreateproductOptionComponent(prods[1].id,1)[0];
		productOptionComponentObj2.Apttus_Config2__ParentProductId__c = prods[3].id;
		productOptionComponentObj2.Apttus_Config2__Sequence__c = 46511;
		pocList.add(productOptionComponentObj2);
		insert pocList;

		prods[1].IsActive = false;
		prods[0].IsActive = true;
		Test.startTest();
		upsert prods;
		Test.stopTest();
		
	}
}