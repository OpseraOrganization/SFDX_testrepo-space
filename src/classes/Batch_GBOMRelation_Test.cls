@isTest
public class Batch_GBOMRelation_Test {
   
   static testmethod void GBOMRelationTestMethod(){

	User sysAdminUser = TestDataFactory.createSystemAdminUser();
	System.runAs(sysAdminUser){
	
		ProductFeature__c objProdFeature = TestDataFactory.createFeature();
	   
		insert objProdFeature;
		
		
		
		Product_Relation__c obProdRelation = new Product_Relation__c();
		obProdRelation.Child_ID__c ='C74044._A2A';
		obProdRelation.Child_Name__c ='C74044.';
		obProdRelation.Parent_ID__c ='C105263._A2A';
		obProdRelation.Parent_Name__c ='Test11111';
		obProdRelation.Parent_Type__c ='Feature';
		obProdRelation.Child_Type__c ='NSN Software SI';
		obProdRelation.RelationType__c ='GBOM';
		
		insert obProdRelation;
		
		
		
		Product2 pro = new Product2(Name = 'iPhone X', Family = 'Mobile',ProductCode ='C74044.');
		Insert pro;
		
		/*Product_Feature_Junction__c newJunction = new Product_Feature_Junction__c();
		newJunction.Product__c = pro.Id;
		newJunction.Product_Feature__c = objProdFeature.Id;
		newJunction.PMDI_Created__c = true;
		
		insert newJunction;*/
		
		Batch_GBOMRelation objGbomBatch = new Batch_GBOMRelation();
		DataBase.executeBatch(objGbomBatch);
		 
	  }  
	}
}