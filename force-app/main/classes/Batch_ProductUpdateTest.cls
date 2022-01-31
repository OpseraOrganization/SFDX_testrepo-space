@isTest

public class Batch_ProductUpdateTest {

	private static testmethod void preparedata(){
	User sysAdminUser = TestDataFactory.createSystemAdminUser();
		System.runAs(sysAdminUser){
			Test.startTest();
			//Product Hierarchy Creation
			Product_Hierarchy__c ph=new Product_Hierarchy__c();
			ph.Business_Group_Code__c='FN';
			ph.Business_Unit_Code__c='BUAASER';
			ph.Portfolio_Package_Code__c='L00147';
			ph.Business_Line_Code__c='L082002';
			database.insert(ph);
		  
			//Product Creation
			  Product2 prod=new Product2();
			  prod.Name='Test ph';
			  prod.Product_Hierarchy__c=ph.Id;
			  database.insert(prod);
			
		   // List<Product_Hierarchy__c> phli=[Select Id,Business_Group_Code__c From Product_Hierarchy__c Where Business_Line_Code__c='L082002'];
		   // phli[0].Business_Group_Code__c='ION';
			ph.Business_Group_Code__c='ION';
			database.update(ph);
			
		   
			
		   // Batch_ProductUpdate batch = new Batch_ProductUpdate(null,null);
			//database.executeBatch(batch,20);
			
			test.stopTest();
		  }
	}
}