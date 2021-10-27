@isTest
public class DS_StagingObjParsingTest {
	
	
	public testmethod static void parseJson_test(){
		
		List<Account> accountCreation = TestDataFactory.createAccount(1);
		database.insert(accountCreation);
		Account acc = new Account();
		acc.Name='Legal Entinty Account For Test';
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		acc.ParentId = accountCreation[0].Id;
		acc.AccountNumber = '100006843';
		database.insert(acc);
		
		//	accountCreation[1].AccountNumber = '3011235';
		
		String json = '{'+
			'  \"header\": {'+
			'	\"source_id\": \"CXM-FDD LTE-Robot12321\",'+
			'	\"file_reference_id\": \"CXM000001-DCOOcdfdgasad\",'+
			'	\"account_id\": \"100006843\",'+
			'	\"creation_date\": \"2018-07-04\",'+
			'	\"start_date\": \"2018-05-02\",'+
			'	\"end_date\": \"2018-05-02\",'+
			'	\"category_Type\": \"SW Recommendation\"'+
			'  },'+
			'  \"line_items\":['+
			'   '+
			'	{'+
			'	  \"use_case\":\"Air interface UL\",'+
			'	  \"bundle_id\": \"\",'+
			'	  \"sales_item_code\": \"RL000319.T\",'+
			'	  \"quantity\": 11'+
			'	},'+
			'	{'+
			'	  \"use_case\":\"Energy Efficiency\",'+
			'	  \"bundle_id\": \"\",'+
			'	  \"sales_item_code\": \"RL000172.T\",'+
			'	  \"quantity\": 7'+
			'	}'+
			'  ]'+
			'}';
		
		
		List<product2> productObj2 = TestDataFactory.productCreation(2);
		productObj2[0].ProductCode = 'RL000319.T';
		productObj2[1].ProductCode = 'RL000172.T';
		//   productObj2[2].ProductCode = 'RL000286.T';
		database.insert(productObj2);
		
		Apttus_Config2__ClassificationName__c category = new Apttus_Config2__ClassificationName__c();
		category.Apttus_Config2__Active__c = true;
		category.APTS_Ext_ID__c = 'ABCXYZ123436789';
		category.Apttus_Config2__HierarchyLabel__c = 'Dummy Heirarchy';
		insert category;
		
		Apttus_Config2__ClassificationHierarchy__c category_hier = new Apttus_Config2__ClassificationHierarchy__c();
		category_hier.Apttus_Config2__Label__c  = 'Dummy Label';
		category_hier.Apttus_Config2__Level__c  = 2;
		category_hier.Name = 'Dummy Category Hierarchy';
		category_hier.Apttus_Config2__HierarchyId__c = category.id;
		insert category_hier;
		
		Apttus_Config2__ProductClassification__c prod_classification = new Apttus_Config2__ProductClassification__c();
		prod_classification.Apttus_Config2__ClassificationId__c = category_hier.id ;
		prod_classification.Apttus_Config2__ProductId__c = productObj2[0].id;
		//prod_classification.Name = 'Dummy Prod Classification_1';
		insert prod_classification;
		
		Commercial_Entitlement__c  comEnt = new Commercial_Entitlement__c();
		comEnt.Product_Name__c=productObj2[0].id;
		comEnt.Sold_To_Party__c=acc.id;
		comEnt.Consumed_Quantity__c=0;
		comEnt.Authorised_Quantity__c=9;			
		comEnt.Parent_Account__c=accountCreation[0].Id;
		
		database.insert(comEnt);
		
		Commercial_Entitlement__c  comEnt1 = new Commercial_Entitlement__c();
		comEnt1.Product_Name__c=productObj2[1].id;
		comEnt1.Sold_To_Party__c=acc.id;
		comEnt1.Consumed_Quantity__c=0;
		comEnt1.Authorised_Quantity__c=8;			
		comEnt1.Parent_Account__c=accountCreation[0].Id;
		
		database.insert(comEnt1);
		/*Apttus_Proposal__Proposal__c quotep = new Apttus_Proposal__Proposal__c();
quotep.Name

Apttus_Config2__CustomerPurchaseOrder__c custPusrchaseOrder = new Apttus_Config2__CustomerPurchaseOrder__c();
custPusrchaseOrder.Sold_to_party__c=acc.id;
custPusrchaseOrder.CurrencyIsoCode='EUR';
custPusrchaseOrder.Apttus_QPConfig__ProposalId__c=
custPusrchaseOrder.Apttus_CMConfig__AgreementId__c
database.insert(custPusrchaseOrder);

Apttus_Config2__CustomerPOItem__c cpoItem = new Apttus_Config2__CustomerPOItem__c();
cpoItem.Apttus_Config2__PurchaseOrderId__c=custPusrchaseOrder.Id;
cpoItem.Apttus_Config2__ProductId__c=productObj2[0].id;
cpoItem.Consumed_Quantity__c=0;
cpoItem.Authorised_Quantity__c=100;
cpoItem.Non_Consumed_Quantity__c=0;
cpoItem.Commercial_Entitlement__c=comEnt.Id;
database.insert(cpoItem); */
		
		Apttus_Config2__ProductClassification__c prod_classification1 = new Apttus_Config2__ProductClassification__c();
		prod_classification1.Apttus_Config2__ClassificationId__c = category_hier.id ;
		prod_classification1.Apttus_Config2__ProductId__c = productObj2[1].id;
		//  prod_classification1.Name = 'Dummy Prod Classification_2';
		insert prod_classification1;
		
		DS_Staging__c stagingObjRec1 = new DS_Staging__c ();
		stagingObjRec1 .Payload_Status__c='Success';
		stagingObjRec1 .DS_Payload__c= json ;
		insert stagingObjRec1 ;
		
		
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/upsertUpsellProposal/*';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueof(json);
		RestContext.request = req;
		RestContext.response= res;
		test.startTest();
		DS_StagingObjParsing obj = new DS_StagingObjParsing(req.requestBody.tostring(), stagingObjRec1 ,acc.id,acc.ParentId);
		DS_StagingObjParsing obj1 = new DS_StagingObjParsing(null, null ,null,null);
		ID jobID = System.enqueueJob(obj); 
		obj.cxmDPCreation();
		
		test.stopTest();
		
		
		
		
	}
	
	
	public testmethod static void parseJson_test_negativeScenarios(){
		
		List<Account> accountCreation = TestDataFactory.createAccount(1);
		database.insert(accountCreation);
		Account acc = new Account();
		acc.Name='Legal Entinty Account For Test';
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		acc.ParentId = accountCreation[0].Id;
		acc.AccountNumber = '100006843';
		database.insert(acc);
		
		//	accountCreation[1].AccountNumber = '3011235';
		
		String json = '{'+
			'  \"header\": {'+
			'	\"source_id\": \"CXM-FDD LTE-Robot12321\",'+
			'	\"file_reference_id\": \"CXM000001-DCOOcdfdgasad\",'+
			'	\"account_id\": \"100006843\",'+
			'	\"creation_date\": \"2018-07-04\",'+
			'	\"start_date\": \"2018-05-02\",'+
			'	\"end_date\": \"2018-05-02\",'+
			'	\"category_Type\": \"SW Recommendation\"'+
			'  },'+
			'  \"line_items\":['+
			'   '+
			'	{'+
			'	  \"use_case\":\"\",'+
			'	  \"bundle_id\": \"\",'+
			'	  \"sales_item_code\": \"RL000319.T\",'+
			'	  \"quantity\": 11'+
			'	},'+
			'	{'+
			'	  \"use_case\":\"\",'+
			'	  \"bundle_id\": \"\",'+
			'	  \"sales_item_code\": \"RL000172.T\",'+
			'	  \"quantity\": 7'+
			'	}'+
			'  ]'+
			'}';
		
		
		List<product2> productObj2 = TestDataFactory.productCreation(2);
		productObj2[0].ProductCode = 'RL000319.T';
		productObj2[1].ProductCode = 'RL000172.T';
		//   productObj2[2].ProductCode = 'RL000286.T';
		database.insert(productObj2);
		
		Apttus_Config2__ClassificationName__c category = new Apttus_Config2__ClassificationName__c();
		category.Apttus_Config2__Active__c = true;
		category.APTS_Ext_ID__c = 'ABCXYZ123436789';
		category.Apttus_Config2__HierarchyLabel__c = 'Dummy Heirarchy';
		insert category;
		
		Apttus_Config2__ClassificationHierarchy__c category_hier = new Apttus_Config2__ClassificationHierarchy__c();
		category_hier.Apttus_Config2__Label__c  = 'Dummy Label';
		category_hier.Apttus_Config2__Level__c  = 2;
		category_hier.Name = 'Dummy Category Hierarchy';
		category_hier.Apttus_Config2__HierarchyId__c = Label.DS_Category_Id;
		insert category_hier;
		
		Apttus_Config2__ProductClassification__c prod_classification = new Apttus_Config2__ProductClassification__c();
		prod_classification.Apttus_Config2__ClassificationId__c = category_hier.id ;
		prod_classification.Apttus_Config2__ProductId__c = productObj2[0].id;
		//prod_classification.Name = 'Dummy Prod Classification_1';
		insert prod_classification;
		
		Commercial_Entitlement__c  comEnt = new Commercial_Entitlement__c();
		comEnt.Product_Name__c=productObj2[0].id;
		comEnt.Sold_To_Party__c=acc.id;
		comEnt.Consumed_Quantity__c=0;
		comEnt.Authorised_Quantity__c=9;			
		comEnt.Parent_Account__c=accountCreation[0].Id;
		
		database.insert(comEnt);
		
		Commercial_Entitlement__c  comEnt1 = new Commercial_Entitlement__c();
		comEnt1.Product_Name__c=productObj2[1].id;
		comEnt1.Sold_To_Party__c=acc.id;
		comEnt1.Consumed_Quantity__c=0;
		comEnt1.Authorised_Quantity__c=8;			
		comEnt1.Parent_Account__c=accountCreation[0].Id;
		
		database.insert(comEnt1);
		/*Apttus_Proposal__Proposal__c quotep = new Apttus_Proposal__Proposal__c();
quotep.Name

Apttus_Config2__CustomerPurchaseOrder__c custPusrchaseOrder = new Apttus_Config2__CustomerPurchaseOrder__c();
custPusrchaseOrder.Sold_to_party__c=acc.id;
custPusrchaseOrder.CurrencyIsoCode='EUR';
custPusrchaseOrder.Apttus_QPConfig__ProposalId__c=
custPusrchaseOrder.Apttus_CMConfig__AgreementId__c
database.insert(custPusrchaseOrder);

Apttus_Config2__CustomerPOItem__c cpoItem = new Apttus_Config2__CustomerPOItem__c();
cpoItem.Apttus_Config2__PurchaseOrderId__c=custPusrchaseOrder.Id;
cpoItem.Apttus_Config2__ProductId__c=productObj2[0].id;
cpoItem.Consumed_Quantity__c=0;
cpoItem.Authorised_Quantity__c=100;
cpoItem.Non_Consumed_Quantity__c=0;
cpoItem.Commercial_Entitlement__c=comEnt.Id;
database.insert(cpoItem); */
		
		Apttus_Config2__ProductClassification__c prod_classification1 = new Apttus_Config2__ProductClassification__c();
		prod_classification1.Apttus_Config2__ClassificationId__c = category_hier.id ;
		prod_classification1.Apttus_Config2__ProductId__c = productObj2[1].id;
		//  prod_classification1.Name = 'Dummy Prod Classification_2';
		insert prod_classification1;
		
		DS_Staging__c stagingObjRec1 = new DS_Staging__c ();
		stagingObjRec1 .Payload_Status__c='Success';
		stagingObjRec1 .DS_Payload__c= json ;
		insert stagingObjRec1 ;
		
		
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/upsertUpsellProposal/*';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueof(json);
		RestContext.request = req;
		RestContext.response= res;
		test.startTest();
		DS_StagingObjParsing obj = new DS_StagingObjParsing(req.requestBody.tostring(), stagingObjRec1 ,acc.id,acc.ParentId);
		DS_StagingObjParsing obj1 = new DS_StagingObjParsing(null, null ,null,null);
		ID jobID = System.enqueueJob(obj); 
		obj.cxmDPCreation();
		
		test.stopTest();
		
		
		
		
	} 
	
	
	
	
	
	
	
	public testmethod static void parseJson_test1(){
		
		List<Account> accountCreation = TestDataFactory.createAccount(1);
		database.insert(accountCreation);
		Account acc = new Account();
		acc.Name='Legal Entinty Account For Test';
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		acc.ParentId = accountCreation[0].Id;
		acc.AccountNumber = '100006843';
		database.insert(acc);
		String json = '{'+
			'  \"header\": {'+
			'	\"source_id\": \"CXM--Robot12321\",'+
			'	\"file_reference_id\": \"CXM000001-DCOOcdfdgasad\",'+
			'	\"account_id\": \"100006843\",'+
			'	\"creation_date\": \"2018-07-04\",'+
			'	\"start_date\": \"2018-05-02\",'+
			'	\"end_date\": \"2018-05-02\",'+
			'	\"category_Type\": \"SW Recommendation\"'+
			'  },'+
			'  \"line_items\":['+
			'   '+
			'	{'+
			'	  \"use_case\":\"Air interface UL\",'+
			'	  \"bundle_id\": \"\",'+
			'	  \"sales_item_code\": \"RL000319.T\",'+
			'	  \"quantity\": 11'+
			'	},'+
			'	{'+
			'	  \"use_case\":\"Energy Efficiency\",'+
			'	  \"bundle_id\": \"\",'+
			'	  \"sales_item_code\": \"RL000172.T\",'+
			'	  \"quantity\": 7'+
			'	}'+
			'  ]'+
			'}';
		
		
		List<product2> productObj2 = TestDataFactory.productCreation(2);
		productObj2[0].ProductCode = 'RL000319.T';
		productObj2[1].ProductCode = 'RL000172.T';
		//   productObj2[2].ProductCode = 'RL000286.T';
		database.insert(productObj2);
		
		Apttus_Config2__ClassificationName__c category = new Apttus_Config2__ClassificationName__c();
		category.Apttus_Config2__Active__c = true;
		category.APTS_Ext_ID__c = 'ABCXYZ123436789';
		category.Apttus_Config2__HierarchyLabel__c = 'Dummy Heirarchy';
		insert category;
		
		Commercial_Entitlement__c  comEnt = new Commercial_Entitlement__c();
		comEnt.Product_Name__c=productObj2[1].id;
		comEnt.Sold_To_Party__c=acc.id;
		comEnt.Consumed_Quantity__c=0;
		comEnt.Authorised_Quantity__c=8;			
		comEnt.Parent_Account__c=accountCreation[0].Id;
		
		database.insert(comEnt);
		
		Commercial_Entitlement__c  comEnt2 = new Commercial_Entitlement__c();
		comEnt2.Product_Name__c=productObj2[0].id;
		comEnt2.Sold_To_Party__c=acc.id;
		comEnt2.Consumed_Quantity__c=0;
		comEnt2.Authorised_Quantity__c=8;			
		comEnt2.Parent_Account__c=accountCreation[0].Id;
		
		database.insert(comEnt2);				   
		
		
		Apttus_Config2__ClassificationHierarchy__c category_hier = new Apttus_Config2__ClassificationHierarchy__c();
		category_hier.Apttus_Config2__Label__c  = 'Dummy Label';
		category_hier.Apttus_Config2__Level__c  = 2;
		category_hier.Name = 'Dummy Category Hierarchy';
		category_hier.Apttus_Config2__HierarchyId__c = category.id;
		insert category_hier;
		
		Apttus_Config2__ProductClassification__c prod_classification = new Apttus_Config2__ProductClassification__c();
		prod_classification.Apttus_Config2__ClassificationId__c = category_hier.id ;
		prod_classification.Apttus_Config2__ProductId__c = productObj2[0].id;
		//prod_classification.Name = 'Dummy Prod Classification_1';
		insert prod_classification;
		
		Apttus_Config2__ProductClassification__c prod_classification1 = new Apttus_Config2__ProductClassification__c();
		prod_classification1.Apttus_Config2__ClassificationId__c = category_hier.id ;
		prod_classification1.Apttus_Config2__ProductId__c = productObj2[1].id;
		//  prod_classification1.Name = 'Dummy Prod Classification_2';
		insert prod_classification1;
		
		DS_Staging__c stagingObjRec1 = new DS_Staging__c ();
		stagingObjRec1 .Payload_Status__c='Success';
		stagingObjRec1 .DS_Payload__c= json ;
		insert stagingObjRec1 ;
		Map<String,String> productCodeToTechMap = new Map<String,String>();
		
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/upsertUpsellProposal/*';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueof(json);
		RestContext.request = req;
		RestContext.response= res;
		test.startTest();
		DS_StagingObjParsing obj = new DS_StagingObjParsing(req.requestBody.tostring(), stagingObjRec1 ,acc.id,acc.ParentId);
		ID jobID = System.enqueueJob(obj); 
		obj.cxmDPCreation();
		obj.checkForDifferentTechnology(productCodeToTechMap);
		 
		test.stopTest();
		
	   
		
	}
   
	 public testmethod static void parseJson_test13(){
		test.startTest();
		List<Account> accountCreation = TestDataFactory.createAccount(1);
		database.insert(accountCreation);
		Account acc = new Account();
		acc.Name='Legal Entinty Account For Test';
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		acc.ParentId = accountCreation[0].Id;
		acc.AccountNumber = '100006843';
		database.insert(acc);
		String json = '{'+
			'  \"header\": {'+
			'	\"source_id\": \"CXM--Robot12321\",'+
			'	\"file_reference_id\": \"CXM000001-DCOOcdfdgasad\",'+
			'	\"account_id\": \"100006843\",'+
			'	\"creation_date\": \"2018-07-04\",'+
			'	\"start_date\": \"2018-05-02\",'+
			'	\"end_date\": \"2018-05-02\",'+
			'	\"category_Type\": \"SW Recommendation\"'+
			'  },'+
			'  \"line_items\":['+
			'   '+
			'	{'+
			'	  \"use_case\":\"null\",'+
			'	  \"bundle_id\": \"\",'+
			'	  \"sales_item_code\": \"RL000319.T\",'+
			'	  \"quantity\": 11'+
			'	},'+
			'	{'+
			'	  \"use_case\":\"Null\",'+
			'	  \"bundle_id\": \"\",'+
			'	  \"sales_item_code\": \"RL000172.T\",'+
			'	  \"quantity\": 7'+
			'	}'+
			'  ]'+
			'}';
		
		
		List<product2> productObj2 = TestDataFactory.productCreation(2);
		productObj2[0].ProductCode = 'RL000319.T';
		productObj2[1].ProductCode = 'RL000172.T';
		//   productObj2[2].ProductCode = 'RL000286.T';
		database.insert(productObj2);
		
		Apttus_Config2__ClassificationName__c category = new Apttus_Config2__ClassificationName__c();
		category.Apttus_Config2__Active__c = true;
		category.APTS_Ext_ID__c = 'ABCXYZ123436789';
		category.Apttus_Config2__HierarchyLabel__c = 'Dummy Heirarchy';
		insert category;
		
						
		
		
		Apttus_Config2__ClassificationHierarchy__c category_hier = new Apttus_Config2__ClassificationHierarchy__c();
		category_hier.Apttus_Config2__Label__c  = 'Dummy Label';
		category_hier.Name= 'Dummy Label 2';
		category_hier.Apttus_Config2__Level__c  = 2;
	   // category_hier.Name = 'Dummy Category Hierarchy';
		//category_hier.Apttus_Config2__HierarchyId__c = category.id;
		category_hier.Apttus_Config2__HierarchyId__c =Label.DS_Category_Id ;
		insert category_hier;
		 
	   /*   Apttus_Config2__ClassificationHierarchy__c category_hier_new = new Apttus_Config2__ClassificationHierarchy__c();
		category_hier_new.Apttus_Config2__Label__c  = 'Dummy Label 21';
		category_hier_new.Name= 'Test';
		category_hier_new.Apttus_Config2__Level__c  = 2;
		category_hier_new.Name = 'Dummy Category Hierarchy';
		//category_hier.Apttus_Config2__HierarchyId__c = category.id;
		category_hier_new.Apttus_Config2__HierarchyId__c =Label.DS_Category_Id ;
		insert category_hier_new;*/
		 
		  Apttus_Config2__ClassificationHierarchy__c category_hier2 = new Apttus_Config2__ClassificationHierarchy__c();
		category_hier2.Apttus_Config2__Label__c  = 'Dummy Label 2';
		category_hier2.Apttus_Config2__AncestorId__c=category_hier.Id;
		category_hier2.Apttus_Config2__Level__c  = 3;
		//category_hier2.Name = 'Dummy Category Hierarchy 2';
		category_hier2.Name = 'Dummy Label 2';
		//category_hier.Apttus_Config2__HierarchyId__c = category.id;
		category_hier2.Apttus_Config2__HierarchyId__c =Label.DS_Category_Id ;
		insert category_hier2;
		
		Apttus_Config2__ProductClassification__c prod_classification = new Apttus_Config2__ProductClassification__c();
		prod_classification.Apttus_Config2__ClassificationId__c = category_hier.id ;
		prod_classification.Apttus_Config2__ProductId__c = productObj2[0].id;
		//prod_classification.Name = 'Dummy Prod Classification_1';
		insert prod_classification;
		
		Apttus_Config2__ProductClassification__c prod_classification1 = new Apttus_Config2__ProductClassification__c();
		prod_classification1.Apttus_Config2__ClassificationId__c = category_hier.id ;
		prod_classification1.Apttus_Config2__ProductId__c = productObj2[1].id;
		//  prod_classification1.Name = 'Dummy Prod Classification_2';
		insert prod_classification1;
		 
		  Apttus_Config2__ProductClassification__c prod_classification2 = new Apttus_Config2__ProductClassification__c();
		prod_classification2.Apttus_Config2__ClassificationId__c = category_hier2.id ;
		prod_classification2.Apttus_Config2__ProductId__c = productObj2[1].id;
		//  prod_classification1.Name = 'Dummy Prod Classification_2';
		insert prod_classification2; 
		 
	  /*   Commercial_Entitlement__c  comEnt = new Commercial_Entitlement__c();
		comEnt.Product_Name__c=productObj2[1].id;
		comEnt.Sold_To_Party__c=acc.id;
		comEnt.Consumed_Quantity__c=0;
		comEnt.Authorised_Quantity__c=80;			
		comEnt.Parent_Account__c=accountCreation[0].Id;
		
		database.insert(comEnt);
		
		Commercial_Entitlement__c  comEnt2 = new Commercial_Entitlement__c();
		comEnt2.Product_Name__c=productObj2[0].id;
		comEnt2.Sold_To_Party__c=acc.id;
		comEnt2.Consumed_Quantity__c=0;
		comEnt2.Authorised_Quantity__c=80;			
		comEnt2.Parent_Account__c=accountCreation[0].Id; 
		
		database.insert(comEnt2);  */ 
		
		DS_Staging__c stagingObjRec1 = new DS_Staging__c ();
		stagingObjRec1 .Payload_Status__c='Success';
		stagingObjRec1 .DS_Payload__c= json ;
		insert stagingObjRec1 ;
		Map<String,String> productCodeToTechMap = new Map<String,String>();
		
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/upsertUpsellProposal/*';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueof(json);
		RestContext.request = req;
		RestContext.response= res;
	   // test.startTest();
		DS_StagingObjParsing obj = new DS_StagingObjParsing(req.requestBody.tostring(), stagingObjRec1 ,acc.id,acc.ParentId);
		ID jobID = System.enqueueJob(obj); 
		obj.cxmDPCreation();
		obj.checkForDifferentTechnology(productCodeToTechMap);
		  obj.checkForFailureDP(null,null,null);
		 category_hier.Name= 'Dummy Label';
		 update category_hier;
		test.stopTest();
	 
		 
	   
		
	}
   
	
	public testmethod static void parseJson_test3(){
		
		List<Account> accountCreation = TestDataFactory.createAccount(1);
		database.insert(accountCreation);
		Account acc = new Account();
		acc.Name='Legal Entinty Account For Test';
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		acc.ParentId = accountCreation[0].Id;
		acc.AccountNumber = '100006843';
		database.insert(acc);
		String json = '{'+
			'  \"header\": {'+
			'	\"source_id\": \"CXM-FDD LTE-Robot12321\",'+
			'	\"file_reference_id\": \"CXM000001-DCOOcdfdgasad\",'+
			'	\"account_id\": \"100006843\",'+
			'	\"creation_date\": \"2018-07-04\",'+
			'	\"start_date\": \"2018-05-02\",'+
			'	\"end_date\": \"2018-05-02\",'+
			'	\"category_Type\": \"SW Recommendation\"'+
			'  },'+
			'  \"line_items\":['+
			'   '+
			'	{'+
			'	  \"use_case\":\"\",'+
			'	  \"bundle_id\": \"\",'+
			'	  \"sales_item_code\": \"RL000319.T\",'+
			'	  \"quantity\": 11'+
			'	},'+
			'	{'+
			'	  \"use_case\":\"Air interface DL\",'+
			'	  \"bundle_id\": \"\",'+
			'	  \"sales_item_code\": \"RL000172.T\",'+
			'	  \"quantity\": 7'+
			'	}'+
			'  ]'+
			'}';
		
		
		List<product2> productObj2 = TestDataFactory.productCreation(2);
		productObj2[0].ProductCode = 'RL000319.T';
		productObj2[1].ProductCode = 'RL000172.T';
		//   productObj2[2].ProductCode = 'RL000286.T';
		database.insert(productObj2);
		
		Apttus_Config2__ClassificationName__c category = new Apttus_Config2__ClassificationName__c();
		category.Apttus_Config2__Active__c = true;
		category.APTS_Ext_ID__c = 'ABCXYZ123436789';
		category.Apttus_Config2__HierarchyLabel__c = 'Dummy Heirarchy';
		insert category;
		
		Apttus_Config2__ClassificationHierarchy__c category_hierRec = new Apttus_Config2__ClassificationHierarchy__c();
		category_hierRec.Apttus_Config2__Label__c  = 'Dummy Label1';
		category_hierRec.Apttus_Config2__Level__c  = 2;
		category_hierRec.Name = 'Dummy Category Hierarchy';
		category_hierRec.Apttus_Config2__HierarchyId__c = category.id;
		insert category_hierRec;
		
		Apttus_Config2__ClassificationHierarchy__c category_hier = new Apttus_Config2__ClassificationHierarchy__c();
		category_hier.Apttus_Config2__Label__c  = 'Dummy Label';
		category_hier.Apttus_Config2__Level__c  = 2;
		category_hier.Name = 'Dummy Category Hierarchy';
		category_hier.Apttus_Config2__HierarchyId__c = category.id;
		insert category_hier;
		
		Apttus_Config2__ProductClassification__c prod_classification = new Apttus_Config2__ProductClassification__c();
		prod_classification.Apttus_Config2__ClassificationId__c = category_hierRec.id ;
		prod_classification.Apttus_Config2__ProductId__c = productObj2[0].id;
		//prod_classification.Name = 'Dummy Prod Classification_1';
		insert prod_classification;
		
		Apttus_Config2__ProductClassification__c prod_classification1 = new Apttus_Config2__ProductClassification__c();
		prod_classification1.Apttus_Config2__ClassificationId__c = category_hier.id ;
		prod_classification1.Apttus_Config2__ProductId__c = productObj2[1].id;
		//  prod_classification1.Name = 'Dummy Prod Classification_2';
		insert prod_classification1;
		
		DS_Staging__c stagingObjRec1 = new DS_Staging__c ();
		stagingObjRec1 .Payload_Status__c='Success';
		stagingObjRec1 .DS_Payload__c= json ;
		insert stagingObjRec1 ;
		
		
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/upsertUpsellProposal/*';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueof(json);
		RestContext.request = req;
		RestContext.response= res;
		test.startTest();
		DS_StagingObjParsing obj = new DS_StagingObjParsing(req.requestBody.tostring(), stagingObjRec1 ,acc.id,acc.ParentId);
		ID jobID = System.enqueueJob(obj); 
		obj.cxmDPCreation();
		
		test.stopTest();
		
		
		
		
	}
	
	public testmethod static void parseJson_test2(){
		
		List<Account> accountCreation = TestDataFactory.createAccount(1);
		database.insert(accountCreation);
		Account acc = new Account();
		acc.Name='Legal Entinty Account For Test';
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		acc.ParentId = accountCreation[0].Id;
		acc.AccountNumber = '100006843';
		database.insert(acc);
		String json = '{'+
			'  \"header\": {'+
			'	\"source_id\": \"CXM-FDD LTE-Robot12321\",'+
			'	\"file_reference_id\": \"CXM000001-DCOOcdfdgasad\",'+
			'	\"account_id\": \"100006843\",'+
			'	\"creation_date\": \"2018-07-04\",'+
			'	\"start_date\": \"2018-05-02\",'+
			'	\"end_date\": \"2018-05-02\",'+
			'	\"category_Type\": \"SW Recommendation\"'+
			'  },'+
			'  \"line_items\":['+
			'   '+
			'	{'+
			'	  \"use_case\":\"\",'+
			'	  \"bundle_id\": \"\",'+
			'	  \"sales_item_code\": \"RL000319.T\",'+
			'	  \"quantity\": 11'+
			'	},'+
			'	{'+
			'	  \"use_case\":\"Air interface DL\",'+
			'	  \"bundle_id\": \"\",'+
			'	  \"sales_item_code\": \"RL000172.T\",'+
			'	  \"quantity\": 7'+
			'	}'+
			'  ]'+
			'}';
		
		
		List<product2> productObj2 = TestDataFactory.productCreation(2);
		productObj2[0].ProductCode = 'RL000319.T';
		productObj2[1].ProductCode = 'RL000172.T';
		//   productObj2[2].ProductCode = 'RL000286.T';
		database.insert(productObj2);
		
		Apttus_Config2__ClassificationName__c category = new Apttus_Config2__ClassificationName__c();
		category.Apttus_Config2__Active__c = true;
		category.APTS_Ext_ID__c = 'ABCXYZ123436789';
		category.Apttus_Config2__HierarchyLabel__c = 'Dummy Heirarchy';
		insert category;
		
		
		
		Apttus_Config2__ClassificationHierarchy__c category_hier = new Apttus_Config2__ClassificationHierarchy__c();
		category_hier.Apttus_Config2__Label__c  = 'Dummy Label';
		category_hier.Apttus_Config2__Level__c  = 2;
		category_hier.Name = 'Dummy Category Hierarchy';
		category_hier.Apttus_Config2__HierarchyId__c = category.id;
		insert category_hier;
		
		Apttus_Config2__ProductClassification__c prod_classification = new Apttus_Config2__ProductClassification__c();
		prod_classification.Apttus_Config2__ClassificationId__c = category_hier.id ;
		prod_classification.Apttus_Config2__ProductId__c = productObj2[0].id;
		//prod_classification.Name = 'Dummy Prod Classification_1';
		insert prod_classification;
		
		Apttus_Config2__ProductClassification__c prod_classification1 = new Apttus_Config2__ProductClassification__c();
		prod_classification1.Apttus_Config2__ClassificationId__c = category_hier.id ;
		prod_classification1.Apttus_Config2__ProductId__c = productObj2[1].id;
		//  prod_classification1.Name = 'Dummy Prod Classification_2';
		insert prod_classification1;
		
		DS_Staging__c stagingObjRec1 = new DS_Staging__c ();
		stagingObjRec1 .Payload_Status__c='Success';
		stagingObjRec1 .DS_Payload__c= json ;
		insert stagingObjRec1 ;
		
		
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/upsertUpsellProposal/*';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueof(json);
		RestContext.request = req;
		RestContext.response= res;
		test.startTest();
		DS_StagingObjParsing obj = new DS_StagingObjParsing(req.requestBody.tostring(), stagingObjRec1 ,acc.id,acc.ParentId);
		ID jobID = System.enqueueJob(obj); 
		obj.cxmDPCreation();
		
		test.stopTest();
		
		
		
		
	}
	
	
	public testmethod static void parseJson_test5(){
		
		List<Account> accountCreation = TestDataFactory.createAccount(1);
		database.insert(accountCreation);
		Account acc = new Account();
		acc.Name='Legal Entinty Account For Test';
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		acc.ParentId = accountCreation[0].Id;
		acc.AccountNumber = '100006843';
		database.insert(acc);									   
		String json = '{'+
			'  \"header\": {'+
			'	\"source_id\": \"RMP-FDD LTE-Robot12321\",'+
			'	\"file_reference_id\": \"CXM000001-DCOOcdfdgasad\",'+
			'	\"account_id\": \"100006843\",'+
			'	\"creation_date\": \"2018-07-04\",'+
			'	\"start_date\": \"2018-05-02\",'+
			'	\"end_date\": \"2018-05-02\",'+
			'	\"category_Type\": \"SW Recommendation\"'+
			'  },'+
			'  \"line_items\":['+
			'   '+
			'	{'+
			'	  \"use_case\":\"Air interface UL\",'+
			'	  \"bundle_id\": \"\",'+
			'	  \"sales_item_code\": \"RL000319.T\",'+
			'	  \"quantity\": 11'+
			'	},'+
			'	{'+
			'	  \"use_case\":\"Air interface DL\",'+
			'	  \"bundle_id\": \"RL0003xx19\",'+
			'	  \"sales_item_code\": \"RL0001ss72.T\",'+
			'	  \"quantity\": 7'+
			'	}'+
			'  ]'+
			'}';
		
		
		List<product2> productObj2 = TestDataFactory.productCreation(2);
		productObj2[0].ProductCode = 'RL000319.T';
		productObj2[1].ProductCode = 'RL000172.T';
		//   productObj2[2].ProductCode = 'RL000286.T';
		database.insert(productObj2);
		
		Apttus_Config2__ClassificationName__c category = new Apttus_Config2__ClassificationName__c();
		category.Apttus_Config2__Active__c = true;
		category.APTS_Ext_ID__c = 'ABCXYZ123436789';
		category.Apttus_Config2__HierarchyLabel__c = 'Dummy Heirarchy';
		insert category;
		 
		 
		
		
		
		Apttus_Config2__ClassificationHierarchy__c category_hier = new Apttus_Config2__ClassificationHierarchy__c();
		category_hier.Apttus_Config2__Label__c  = 'Dummy Label';
		category_hier.Apttus_Config2__Level__c  = 2;
		category_hier.Name = 'Dummy Category Hierarchy';
		category_hier.Apttus_Config2__HierarchyId__c = category.id;
		insert category_hier;
		
		Apttus_Config2__ProductClassification__c prod_classification = new Apttus_Config2__ProductClassification__c();
		prod_classification.Apttus_Config2__ClassificationId__c = category_hier.id ;
		prod_classification.Apttus_Config2__ProductId__c = productObj2[0].id;
		//prod_classification.Name = 'Dummy Prod Classification_1';
		insert prod_classification;
		
		Apttus_Config2__ProductClassification__c prod_classification1 = new Apttus_Config2__ProductClassification__c();
		prod_classification1.Apttus_Config2__ClassificationId__c = category_hier.id ;
		prod_classification1.Apttus_Config2__ProductId__c = productObj2[1].id;
		//  prod_classification1.Name = 'Dummy Prod Classification_2';
		insert prod_classification1;
		
		DS_Staging__c stagingObjRec1 = new DS_Staging__c ();
		stagingObjRec1 .Payload_Status__c='Success';
		stagingObjRec1 .DS_Payload__c= json ;
		insert stagingObjRec1 ;
		
		
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/upsertUpsellProposal/*';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueof(json);
		RestContext.request = req;
		RestContext.response= res;
		test.startTest();
		DS_StagingObjParsing obj = new DS_StagingObjParsing(req.requestBody.tostring(), stagingObjRec1 ,acc.id,acc.ParentId);
		ID jobID = System.enqueueJob(obj); 
		obj.cxmDPCreation();
		
		test.stopTest();
		
		
		
		
	}
	
	
	public testmethod static void parseJson_test4(){
		
		List<Account> accountCreation = TestDataFactory.createAccount(1);
		database.insert(accountCreation);
		Account acc = new Account();
		acc.Name='Legal Entinty Account For Test';
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		acc.ParentId = accountCreation[0].Id;
		acc.AccountNumber = '100006843';
		database.insert(acc);
		String json = '{'+
			'  \"header\": {'+
			'	\"source_id\": \"RMP--Robot12321\",'+
			'	\"file_reference_id\": \"CXM000001-DCOOcdfdgasad\",'+
			'	\"account_id\": \"100006843\",'+
			'	\"creation_date\": \"2018-07-04\",'+
			'	\"start_date\": \"2018-05-02\",'+
			'	\"end_date\": \"2018-05-02\",'+
			'	\"category_Type\": \"SW Recommendation\"'+
			'  },'+
			'  \"line_items\":['+
			'   '+
			'	{'+
			'	  \"use_case\":\"Air interface UL\",'+
			'	  \"bundle_id\": \"\",'+
			'	  \"sales_item_code\": \"RL000319.T\",'+
			'	  \"quantity\": 11'+
			'	},'+
			'	{'+
			'	  \"use_case\":\"Air interface DL\",'+
			'	  \"bundle_id\": \"\",'+
			'	  \"sales_item_code\": \"RL000172.T\",'+
			'	  \"quantity\": 7'+
			'	}'+
			'  ]'+
			'}';
		
		
		List<product2> productObj2 = TestDataFactory.productCreation(2);
		productObj2[0].ProductCode = 'RL000319.T';
		productObj2[1].ProductCode = 'RL000172.T';
		//   productObj2[2].ProductCode = 'RL000286.T';
		database.insert(productObj2);
		
		Apttus_Config2__ClassificationName__c category = new Apttus_Config2__ClassificationName__c();
		category.Apttus_Config2__Active__c = true;
		category.APTS_Ext_ID__c = 'ABCXYZ123436789';
		category.Apttus_Config2__HierarchyLabel__c = 'Dummy Heirarchy';
		insert category;						
		
		Apttus_Config2__ClassificationHierarchy__c category_hier = new Apttus_Config2__ClassificationHierarchy__c();
		category_hier.Apttus_Config2__Label__c  = 'Dummy Label';
		category_hier.Apttus_Config2__Level__c  = 2;
		category_hier.Name = 'Dummy Category Hierarchy';
		category_hier.Apttus_Config2__HierarchyId__c = category.id;
		insert category_hier;
		
		Apttus_Config2__ProductClassification__c prod_classification = new Apttus_Config2__ProductClassification__c();
		prod_classification.Apttus_Config2__ClassificationId__c = category_hier.id ;
		prod_classification.Apttus_Config2__ProductId__c = productObj2[0].id;
		//prod_classification.Name = 'Dummy Prod Classification_1';
		insert prod_classification;
		
		Apttus_Config2__ProductClassification__c prod_classification1 = new Apttus_Config2__ProductClassification__c();
		prod_classification1.Apttus_Config2__ClassificationId__c = category_hier.id ;
		prod_classification1.Apttus_Config2__ProductId__c = productObj2[1].id;
		//  prod_classification1.Name = 'Dummy Prod Classification_2';
		insert prod_classification1;
		
		DS_Staging__c stagingObjRec1 = new DS_Staging__c ();
		stagingObjRec1 .Payload_Status__c='Success';
		stagingObjRec1 .DS_Payload__c= json ;
		insert stagingObjRec1 ;
		
		
		
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/upsertUpsellProposal/*';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueof(json);
		RestContext.request = req;
		RestContext.response= res;
		test.startTest();
		DS_StagingObjParsing obj = new DS_StagingObjParsing(req.requestBody.tostring(), stagingObjRec1 ,acc.id,acc.ParentId);
		ID jobID = System.enqueueJob(obj); 
		obj.cxmDPCreation();
		
		test.stopTest();
		
		
		
		
	}
	
	public testmethod static void hwAntenaTechTestmethod(){
		
		List<Account> accountCreation = TestDataFactory.createAccount(1);
		database.insert(accountCreation);
		Account acc = new Account();
		acc.Name='Legal Entinty Account For Test';
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		acc.ParentId = accountCreation[0].Id;
		acc.AccountNumber = '100006843';
		database.insert(acc);
		
		//	accountCreation[1].AccountNumber = '3011235';
		
		String json = '{'+
			'  \"header\": {'+
			'	\"source_id\": \"CXM-HW extension-Robot12321\",'+
			'	\"file_reference_id\": \"CXM000001-DCOOcdfdgasad\",'+
			'	\"account_id\": \"100006843\",'+
			'	\"creation_date\": \"2018-07-04\",'+
			'	\"start_date\": \"2018-05-02\",'+
			'	\"end_date\": \"2018-05-02\",'+
			'	\"category_Type\": \"SW Recommendation\"'+
			'  },'+
			'  \"line_items\":['+
			'   '+
			'	{'+
			'	  \"use_case\":\"\",'+
			'	  \"bundle_id\": \"\",'+
			'	  \"sales_item_code\": \"RL000319.T\",'+
			'	  \"quantity\": 11'+
			'	},'+
			'	{'+
			'	  \"use_case\":\"\",'+
			'	  \"bundle_id\": \"\",'+
			'	  \"sales_item_code\": \"472797A\",'+
			'	  \"quantity\": 100'+
			'	}'+		 
			'  ]'+
			'}';
		
		
		List<product2> productObj2 = TestDataFactory.productCreation(2);
		productObj2[0].ProductCode = 'RL000319.T';
		productObj2[1].ProductCode = '472797A';
		//   productObj2[2].ProductCode = 'RL000286.T';
		database.insert(productObj2);
		
		Apttus_Config2__ClassificationName__c category = new Apttus_Config2__ClassificationName__c();
		category.Apttus_Config2__Active__c = true;
		category.APTS_Ext_ID__c = 'ABCXYZ123436789';
		category.Apttus_Config2__HierarchyLabel__c = 'Dummy Heirarchy';
		insert category;
		
		Apttus_Config2__ClassificationHierarchy__c category_hier = new Apttus_Config2__ClassificationHierarchy__c();
		category_hier.Apttus_Config2__Label__c  = 'Dummy Label';
		category_hier.Apttus_Config2__Level__c  = 2;
		category_hier.Name = 'Dummy Category Hierarchy';
		category_hier.Apttus_Config2__HierarchyId__c = category.id;
		insert category_hier;
		
		Apttus_Config2__ProductClassification__c prod_classification = new Apttus_Config2__ProductClassification__c();
		prod_classification.Apttus_Config2__ClassificationId__c = category_hier.id ;
		prod_classification.Apttus_Config2__ProductId__c = productObj2[0].id;
		//prod_classification.Name = 'Dummy Prod Classification_1';
		insert prod_classification;
		
		Apttus_Config2__ProductClassification__c prod_classification1 = new Apttus_Config2__ProductClassification__c();
		prod_classification1.Apttus_Config2__ClassificationId__c = category_hier.id ;
		prod_classification1.Apttus_Config2__ProductId__c = productObj2[1].id;
		//  prod_classification1.Name = 'Dummy Prod Classification_2';
		insert prod_classification1;
		
		Commercial_Entitlement__c  comEnt = new Commercial_Entitlement__c();
		comEnt.Product_Name__c=productObj2[0].id;
		comEnt.Sold_To_Party__c=acc.id;
		comEnt.Consumed_Quantity__c=0;
		comEnt.Authorised_Quantity__c=9;			
		comEnt.Parent_Account__c=accountCreation[0].Id; 
		
		database.insert(comEnt);
		
		Commercial_Entitlement__c  comEnt1 = new Commercial_Entitlement__c();
		comEnt1.Product_Name__c=productObj2[1].id;
		comEnt1.Sold_To_Party__c=acc.id;
		comEnt1.Consumed_Quantity__c=0;
		comEnt1.Authorised_Quantity__c=8;			
		comEnt1.Parent_Account__c=accountCreation[0].Id;
		
		database.insert(comEnt1);							
		
		DS_Staging__c stagingObjRec1 = new DS_Staging__c ();
		stagingObjRec1 .Payload_Status__c='Success';
		stagingObjRec1 .DS_Payload__c= json ;
		insert stagingObjRec1 ;
		
		
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/upsertUpsellProposal/*';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueof(json);
		RestContext.request = req;
		RestContext.response= res;
		test.startTest();
		DS_StagingObjParsing obj = new DS_StagingObjParsing(req.requestBody.tostring(), stagingObjRec1 ,acc.id,acc.ParentId);
		DS_StagingObjParsing obj1 = new DS_StagingObjParsing(null, null ,null,null);
		ID jobID = System.enqueueJob(obj); 
		obj.cxmDPCreation();
		
		test.stopTest();
		
		
		
		
	}
	
	public testmethod static void hwAntenaTechTestmethod1(){
		
		List<Account> accountCreation = TestDataFactory.createAccount(1);
		database.insert(accountCreation);
		Account acc = new Account();
		acc.Name='Legal Entinty Account For Test';
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		acc.ParentId = accountCreation[0].Id;
		acc.AccountNumber = '100006843';
		database.insert(acc);
		
		//	accountCreation[1].AccountNumber = '3011235';
		
		String json = '{'+
			'  \"header\": {'+
			'	\"source_id\": \"CXM-\",'+
			'	\"file_reference_id\": \"CXM000001-DCOOcdfdgasad\",'+
			'	\"account_id\": \"100006843\",'+
			'	\"creation_date\": \"2018-07-04\",'+
			'	\"start_date\": \"2018-05-02\",'+
			'	\"end_date\": \"2018-05-02\",'+
			'	\"category_Type\": \"SW Recommendation\"'+
			'  },'+
			'  \"line_items\":['+
			'   '+
			'	{'+
			'	  \"use_case\":\"Air interface UL\",'+
			'	  \"bundle_id\": \"\",'+
			'	  \"sales_item_code\": \"RL000319.T\",'+
			'	  \"quantity\": 11'+
			'	},'+
			'	{'+
			'	  \"use_case\":\"Energy Efficiency\",'+
			'	  \"bundle_id\": \"\",'+
			'	  \"sales_item_code\": \"472797A\",'+
			'	  \"quantity\": 100'+
			'	}'+		 
			'  ]'+
			'}';
		
		
		List<product2> productObj2 = TestDataFactory.productCreation(2);
		productObj2[0].ProductCode = '472797A';
		productObj2[1].ProductCode = 'RL000319.T';
		//   productObj2[2].ProductCode = 'RL000286.T';
		database.insert(productObj2);
		
		Apttus_Config2__ClassificationName__c category = new Apttus_Config2__ClassificationName__c();
		category.Apttus_Config2__Active__c = true;
		category.APTS_Ext_ID__c = 'ABCXYZ123436789';
		category.Apttus_Config2__HierarchyLabel__c = 'Dummy Heirarchy';
		insert category;
		
		Apttus_Config2__ClassificationHierarchy__c category_hier = new Apttus_Config2__ClassificationHierarchy__c();
		category_hier.Apttus_Config2__Label__c  = 'Dummy Label';
		category_hier.Apttus_Config2__Level__c  = 2;
		category_hier.Name = 'Dummy Category Hierarchy';
		category_hier.Apttus_Config2__HierarchyId__c = category.id;
		insert category_hier;
		
		Apttus_Config2__ProductClassification__c prod_classification = new Apttus_Config2__ProductClassification__c();
		prod_classification.Apttus_Config2__ClassificationId__c = category_hier.id ;
		prod_classification.Apttus_Config2__ProductId__c = productObj2[0].id;
		//prod_classification.Name = 'Dummy Prod Classification_1';
		insert prod_classification;
		
		Apttus_Config2__ProductClassification__c prod_classification1 = new Apttus_Config2__ProductClassification__c();
		prod_classification1.Apttus_Config2__ClassificationId__c = category_hier.id ;
		prod_classification1.Apttus_Config2__ProductId__c = productObj2[1].id;
		//  prod_classification1.Name = 'Dummy Prod Classification_2';
		insert prod_classification1;
		
		Commercial_Entitlement__c  comEnt = new Commercial_Entitlement__c();
		comEnt.Product_Name__c=productObj2[0].id;
		comEnt.Sold_To_Party__c=acc.id;
		comEnt.Consumed_Quantity__c=0;
		comEnt.Authorised_Quantity__c=11;			
		comEnt.Parent_Account__c=accountCreation[0].Id; 
		
		database.insert(comEnt);
		
		Commercial_Entitlement__c  comEnt1 = new Commercial_Entitlement__c();
		comEnt1.Product_Name__c=productObj2[1].id;
		comEnt1.Sold_To_Party__c=acc.id;
		comEnt1.Consumed_Quantity__c=0;
		comEnt1.Authorised_Quantity__c=8;			
		comEnt1.Parent_Account__c=accountCreation[0].Id;
		
		database.insert(comEnt1);							
		
		DS_Staging__c stagingObjRec1 = new DS_Staging__c ();
		stagingObjRec1 .Payload_Status__c='Success';
		stagingObjRec1 .DS_Payload__c= json ;
		insert stagingObjRec1 ;
		
		
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/upsertUpsellProposal/*';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueof(json);
		RestContext.request = req;
		RestContext.response= res;
		test.startTest();
		DS_StagingObjParsing obj = new DS_StagingObjParsing(req.requestBody.tostring(), stagingObjRec1 ,acc.id,acc.ParentId);
		DS_StagingObjParsing obj1 = new DS_StagingObjParsing(null, null ,null,null);
		ID jobID = System.enqueueJob(obj); 
		obj.cxmDPCreation();
		
		test.stopTest();
		
		
		
		
	}
	
	public testmethod static void parseJson_test11(){
		
		List<Account> accountCreation = TestDataFactory.createAccount(1);
		database.insert(accountCreation);
		Account acc = new Account();
		acc.Name='Legal Entinty Account For Test';
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		acc.ParentId = accountCreation[0].Id;
		acc.AccountNumber = '100006843';
		database.insert(acc);
		String json = '{'+
			'  \"header\": {'+
			'	\"source_id\": \"CXM- -\",'+
			'	\"file_reference_id\": \"CXM000001-DCOOcdfdgasad\",'+
			'	\"account_id\": \"100006843\",'+
			'	\"creation_date\": \"2018-07-04\",'+
			'	\"start_date\": \"2018-05-02\",'+
			'	\"end_date\": \"2018-05-02\",'+
			'	\"category_Type\": \"SW Recommendation\"'+
			'  },'+
			'  \"line_items\":['+
			'   '+
			'	{'+
			'	  \"use_case\":\"Air interface UL\",'+
			'	  \"bundle_id\": \"\",'+
			'	  \"sales_item_code\": \"RL000319.T\",'+
			'	  \"quantity\": 11'+
			'	},'+
			'	{'+
			'	  \"use_case\":\"Energy Efficiency\",'+
			'	  \"bundle_id\": \"\",'+
			'	  \"sales_item_code\": \"RL000172212.T\",'+
			'	  \"quantity\": 7'+
			'	}'+
			'  ]'+
			'}';
		
		
		List<product2> productObj2 = TestDataFactory.productCreation(2);
		productObj2[0].ProductCode = 'RL000319.T';
		productObj2[1].ProductCode = 'RL000172.T';
		//   productObj2[2].ProductCode = 'RL000286.T';
		database.insert(productObj2);
		
		Apttus_Config2__ClassificationName__c category = new Apttus_Config2__ClassificationName__c();
		category.Apttus_Config2__Active__c = true;
		category.APTS_Ext_ID__c = 'ABCXYZ123436789';
		category.Apttus_Config2__HierarchyLabel__c = 'Dummy Heirarchy';
		insert category;
		
		Commercial_Entitlement__c  comEnt = new Commercial_Entitlement__c();
		comEnt.Product_Name__c=productObj2[1].id;
		comEnt.Sold_To_Party__c=acc.id;
		comEnt.Consumed_Quantity__c=0;
		comEnt.Authorised_Quantity__c=8;			
		comEnt.Parent_Account__c=accountCreation[0].Id;
		
		database.insert(comEnt);				   
		
		Apttus_Config2__ClassificationHierarchy__c category_hier = new Apttus_Config2__ClassificationHierarchy__c();
		category_hier.Apttus_Config2__Label__c  = 'Dummy Label';
		category_hier.Apttus_Config2__Level__c  = 2;
		category_hier.Name = 'Dummy Category Hierarchy';
		category_hier.Apttus_Config2__HierarchyId__c = category.id;
		insert category_hier;
		
		Apttus_Config2__ProductClassification__c prod_classification = new Apttus_Config2__ProductClassification__c();
		prod_classification.Apttus_Config2__ClassificationId__c = category_hier.id ;
		prod_classification.Apttus_Config2__ProductId__c = productObj2[0].id;
		//prod_classification.Name = 'Dummy Prod Classification_1';
		insert prod_classification;
		
		Apttus_Config2__ProductClassification__c prod_classification1 = new Apttus_Config2__ProductClassification__c();
		prod_classification1.Apttus_Config2__ClassificationId__c = category_hier.id ;
		prod_classification1.Apttus_Config2__ProductId__c = productObj2[1].id;
		//  prod_classification1.Name = 'Dummy Prod Classification_2';
		insert prod_classification1;
		
		DS_Staging__c stagingObjRec1 = new DS_Staging__c ();
		stagingObjRec1 .Payload_Status__c='Success';
		stagingObjRec1 .DS_Payload__c= json ;
		insert stagingObjRec1 ;
		
		
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/upsertUpsellProposal/*';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueof(json);
		RestContext.request = req;
		RestContext.response= res;
		test.startTest();
		DS_StagingObjParsing obj = new DS_StagingObjParsing(req.requestBody.tostring(), stagingObjRec1 ,acc.id,acc.ParentId);
		ID jobID = System.enqueueJob(obj); 
		obj.cxmDPCreation();
		
		test.stopTest();
		
		
		
		
	}
 public testmethod static void parseJson_testagain(){
		
		List<Account> accountCreation = TestDataFactory.createAccount(1);
		database.insert(accountCreation);
		Account acc = new Account();
		acc.Name='Legal Entinty Account For Test';
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		acc.ParentId = accountCreation[0].Id;
		acc.AccountNumber = '100006843';
		database.insert(acc);
		
		//	accountCreation[1].AccountNumber = '3011235';
		
		String json = '{'+
			'  \"header\": {'+
			'	\"source_id\": \"CXM-FDD LTE-Robot12321\",'+
			'	\"file_reference_id\": \"CXM000001-DCOOcdfdgasad\",'+
			'	\"account_id\": \"100006843\",'+
			'	\"creation_date\": \"2018-07-04\",'+
			'	\"start_date\": \"2018-05-02\",'+
			'	\"end_date\": \"2018-05-02\",'+
			'	\"category_Type\": \"SW Recommendation\"'+
			'  },'+
			'  \"line_items\":['+
			'   '+
			'	{'+
			'	  \"use_case\":\"\",'+
			'	  \"bundle_id\": \"\",'+
			'	  \"sales_item_code\": \"RL000319.T\",'+
			'	  \"quantity\": 11'+
			'	},'+
			'	{'+
			'	  \"use_case\":\"\",'+
			'	  \"bundle_id\": \"\",'+
			'	  \"sales_item_code\": \"RL000172.T\",'+
			'	  \"quantity\": 7'+
			'	}'+
			'  ]'+
			'}';
		
		
		List<product2> productObj2 = TestDataFactory.productCreation(2);
		productObj2[0].ProductCode = 'RL000319.T';
		productObj2[1].ProductCode = 'RL000172.T';
		//   productObj2[2].ProductCode = 'RL000286.T';
		database.insert(productObj2);
		
		Apttus_Config2__ClassificationName__c category = new Apttus_Config2__ClassificationName__c();
		category.Apttus_Config2__Active__c = true;
		category.APTS_Ext_ID__c = 'ABCXYZ123436789';
		category.Apttus_Config2__HierarchyLabel__c = 'Dummy Heirarchy';
		insert category;
		
		Apttus_Config2__ClassificationHierarchy__c category_hier = new Apttus_Config2__ClassificationHierarchy__c();
		category_hier.Apttus_Config2__Label__c  = 'Dummy Label';
		category_hier.Apttus_Config2__Level__c  = 2;
		category_hier.Name = 'Dummy Category Hierarchy';
		category_hier.Apttus_Config2__HierarchyId__c = category.id;
		insert category_hier;
		
		Apttus_Config2__ProductClassification__c prod_classification = new Apttus_Config2__ProductClassification__c();
		prod_classification.Apttus_Config2__ClassificationId__c = category_hier.id ;
		prod_classification.Apttus_Config2__ProductId__c = productObj2[0].id;
		//prod_classification.Name = 'Dummy Prod Classification_1';
		insert prod_classification;
		
		Commercial_Entitlement__c  comEnt = new Commercial_Entitlement__c();
		comEnt.Product_Name__c=productObj2[0].id;
		comEnt.Sold_To_Party__c=acc.id;
		comEnt.Consumed_Quantity__c=0;
		comEnt.Authorised_Quantity__c=9;			
		comEnt.Parent_Account__c=accountCreation[0].Id;
		
		database.insert(comEnt);
		
		Commercial_Entitlement__c  comEnt1 = new Commercial_Entitlement__c();
		comEnt1.Product_Name__c=productObj2[1].id;
		comEnt1.Sold_To_Party__c=acc.id;
		comEnt1.Consumed_Quantity__c=0;
		comEnt1.Authorised_Quantity__c=8;			
		comEnt1.Parent_Account__c=accountCreation[0].Id;
		
		database.insert(comEnt1);
		/*Apttus_Proposal__Proposal__c quotep = new Apttus_Proposal__Proposal__c();
quotep.Name

Apttus_Config2__CustomerPurchaseOrder__c custPusrchaseOrder = new Apttus_Config2__CustomerPurchaseOrder__c();
custPusrchaseOrder.Sold_to_party__c=acc.id;
custPusrchaseOrder.CurrencyIsoCode='EUR';
custPusrchaseOrder.Apttus_QPConfig__ProposalId__c=
custPusrchaseOrder.Apttus_CMConfig__AgreementId__c
database.insert(custPusrchaseOrder);

Apttus_Config2__CustomerPOItem__c cpoItem = new Apttus_Config2__CustomerPOItem__c();
cpoItem.Apttus_Config2__PurchaseOrderId__c=custPusrchaseOrder.Id;
cpoItem.Apttus_Config2__ProductId__c=productObj2[0].id;
cpoItem.Consumed_Quantity__c=0;
cpoItem.Authorised_Quantity__c=100;
cpoItem.Non_Consumed_Quantity__c=0;
cpoItem.Commercial_Entitlement__c=comEnt.Id;
database.insert(cpoItem); */
		
		Apttus_Config2__ProductClassification__c prod_classification1 = new Apttus_Config2__ProductClassification__c();
		prod_classification1.Apttus_Config2__ClassificationId__c = category_hier.id ;
		prod_classification1.Apttus_Config2__ProductId__c = productObj2[1].id;
		//  prod_classification1.Name = 'Dummy Prod Classification_2';
		insert prod_classification1;
		
		DS_Staging__c stagingObjRec1 = new DS_Staging__c ();
		stagingObjRec1 .Payload_Status__c='Success';
		stagingObjRec1 .DS_Payload__c= json ;
		insert stagingObjRec1 ;
		
		
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/upsertUpsellProposal/*';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueof(json);
		RestContext.request = req;
		RestContext.response= res;
		test.startTest();
		DS_StagingObjParsing obj = new DS_StagingObjParsing(req.requestBody.tostring(), stagingObjRec1 ,acc.id,acc.ParentId);
		DS_StagingObjParsing obj1 = new DS_StagingObjParsing(null, null ,null,null);
		ID jobID = System.enqueueJob(obj); 
		obj.cxmDPCreation();
		
		test.stopTest();
		
		
		
		
	}
	
	public testmethod static void parseJson_test55(){
	   
		List<Account> accountCreation = TestDataFactory.createAccount(1);
		database.insert(accountCreation);
		Account acc = new Account();
		acc.Name='Legal Entinty Account For Test';
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		acc.ParentId = accountCreation[0].Id;
		acc.AccountNumber = '100006843';
		database.insert(acc);
		String json = '{'+
			'  \"header\": {'+
			'	\"source_id\": \"-FDD LTE-Robot12321\",'+
			'	\"file_reference_id\": \"CXM000001-DCOOcdfdgasad\",'+
			'	\"account_id\": \"100006843\",'+
			'	\"creation_date\": \"2018-07-04\",'+
			'	\"start_date\": \"2018-05-02\",'+
			'	\"end_date\": \"2018-05-02\",'+
			'	\"category_Type\": \"SW Recommendation\"'+
			'  },'+
			'  \"line_items\":['+
			'   '+
			'	{'+
			'	  \"use_case\":\"Air interface UL\",'+
			'	  \"bundle_id\": \"\",'+
			'	  \"sales_item_code\": \"RL000319.T\",'+
			'	  \"quantity\": 11'+
			'	},'+
			'	{'+
			'	  \"use_case\":\"Air interface DL\",'+
			'	  \"bundle_id\": \"\",'+
			'	  \"sales_item_code\": \"RL000172.T\",'+
			'	  \"quantity\": 7'+
			'	}'+
			'  ]'+
			'}';
		
		 
		List<product2> productObj2 = TestDataFactory.productCreation(2);
		productObj2[0].ProductCode = 'RL000319.T';
		productObj2[1].ProductCode = 'RL000172.T';
		//   productObj2[2].ProductCode = 'RL000286.T';
		database.insert(productObj2);
		
		Apttus_Config2__ClassificationName__c category = new Apttus_Config2__ClassificationName__c();
		category.Apttus_Config2__Active__c = true;
		category.APTS_Ext_ID__c = 'ABCXYZ123436789';
		category.Apttus_Config2__HierarchyLabel__c = 'Dummy Heirarchy';
		insert category;						
		
		Apttus_Config2__ClassificationHierarchy__c category_hier = new Apttus_Config2__ClassificationHierarchy__c();
		category_hier.Apttus_Config2__Label__c  = 'Dummy Label';
		category_hier.Apttus_Config2__Level__c  = 2;
		category_hier.Name = 'Dummy Category Hierarchy';
		category_hier.Apttus_Config2__HierarchyId__c = category.id;
		insert category_hier;
		
		Apttus_Config2__ProductClassification__c prod_classification = new Apttus_Config2__ProductClassification__c();
		prod_classification.Apttus_Config2__ClassificationId__c = category_hier.id ;
		prod_classification.Apttus_Config2__ProductId__c = productObj2[0].id;
		//prod_classification.Name = 'Dummy Prod Classification_1';
		insert prod_classification;
		
		Apttus_Config2__ProductClassification__c prod_classification1 = new Apttus_Config2__ProductClassification__c();
		prod_classification1.Apttus_Config2__ClassificationId__c = category_hier.id ;
		prod_classification1.Apttus_Config2__ProductId__c = productObj2[1].id;
		//  prod_classification1.Name = 'Dummy Prod Classification_2';
		insert prod_classification1;
		
		DS_Staging__c stagingObjRec1 = new DS_Staging__c ();
		stagingObjRec1 .Payload_Status__c='Success';
		stagingObjRec1 .DS_Payload__c= json ;
		insert stagingObjRec1 ;
		
		
		
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/upsertUpsellProposal/*';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueof(json);
		RestContext.request = req;
		RestContext.response= res;
		test.startTest();
		DS_StagingObjParsing obj = new DS_StagingObjParsing(req.requestBody.tostring(), stagingObjRec1 ,acc.id,acc.ParentId);
		ID jobID = System.enqueueJob(obj); 
		obj.cxmDPCreation();
		obj.checkReadyForReview(null,null,null,null);
		DS_StagingObjParsing.sendChatterMessageToAM(null);
		obj.checkForFailureDP(null,null,null);
		obj.updateDPonFailure(null,null);
		//obj.getUseCase(null,null,null,null,null);
		//obj.checkForDifferentTechnology(null);
		obj.execute(null);
	   
		test.stopTest();
		
		
		
		
	}
}