@isTest
public class DS_BatchGBOMRelationTest {
	static testmethod void testmethod1()
	{
		List<Account> accountCreation = TestDataFactory.createAccount(1);
		database.insert(accountCreation);
		Account acc = new Account();
		acc.Name='Legal Entinty Account For Test';
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		acc.ParentId = accountCreation[0].Id;
		acc.AccountNumber = '100006843';
		database.insert(acc);
		ProductFeature__c prodFeature = new ProductFeature__c();
		prodFeature.Description__c = '256 QAM in downlink SMB';
		prodFeature.ItemId__c = 'Product12AAX';
		prodFeature.NSN_Code__c = '0000051453';
		prodFeature.NSNClassification__c = 'Sales Marketing Bundle';
		prodFeature.ItemType__c = 'Software';
		
		prodFeature.createdDate = system.today();
		insert prodFeature;
		/***Product relation Records***/
		
		Product_Relation__c productRel = new Product_Relation__c();
		productRel.Child_ID__c		= '00000001';
		productRel.Child_Name__c	= '00000001';
		productRel.Parent_ID__c	= '133-060762_00';
		productRel.Parent_Name__c  = '0000051453';
		productRel.Parent_Type__c = 'Feature';
		productRel.EDPActiveStatus__c		= true;
		productRel.RelationType__c			= 'GBOM';
		productRel.Child_Type__c = 'NSN Product Configuration Item';
		productRel.Combined_key__c		  = '00000001_133-060762_00';
		insert productRel;
		
		List<product2> productObj = TestDataFactory.productCreation(2);
		productObj[0].ProductCode = 'RL000340LK';
		productObj[1].ProductCode = 'RL000340.T';
		database.insert(productObj);
		
		Product_Feature_Junction__c prodjunc = new Product_Feature_Junction__c();
		prodjunc.Product__c = productObj[0].id;
	   
	   // prodjunc[0].Product_Feature__c ='Feature';
		
		insert prodjunc;
		
		Test.startTest();
		Batch_GBOMRelation obj = new Batch_GBOMRelation();
		
		database.executeBatch(obj);
		
		Test.stopTest();
	}
	
}