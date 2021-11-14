@isTest
public class HWS_EDP_BuildRelation_Product_Part_Test {
	public static testmethod void testEdpBuildRelationProductPart(){
		List<HWS_Product_Serviceable_Relations__c> prodServiceRelationList = new List<HWS_Product_Serviceable_Relations__c>();
		HWS_Product_Serviceable_Relations__c prodServiceRelation = new HWS_Product_Serviceable_Relations__c();
		prodServiceRelation.HWS_HWSSIPartNumber__c = '833-049122_00';
		prodServiceRelation.HWS_Product_Code__c = '833-049122_00';
		prodServiceRelation.HWS_Is_Processed__c = false;
		prodServiceRelationList.add(prodServiceRelation);
		insert prodServiceRelationList;
		
		Product2 prod = new Product2();
		prod.Name ='Test Product 1';
		prod.ProductCode = '833-049122_00';
		prod.NokiaCPQ_Item_Type__c = 'Hardware';
		insert prod;
		System.assertNotEquals(prod.Name, null);
		
		Product2 prod1 = new Product2();
		prod1.Name ='Test Product 2';
		prod1.ProductCode = '833-049122_00';
		prod1.NokiaCPQ_Item_Type__c = 'OTHER';
		insert prod1;
		
		CH_ProductRelation__c chProdRelation = new CH_ProductRelation__c();
		chProdRelation.CH_Child_Product__c = prod.Id;
		chProdRelation.CH_Parent_Product__c = prod1.Id;
		chProdRelation.CH_ExternalId__c = '085849A833-049122_00';
		insert chProdRelation;
		 
		HWS_EDP_BuildRelation_Product_Part edpBuildRelProdPartBatch = new HWS_EDP_BuildRelation_Product_Part();
		Database.BatchableContext bc;
		SchedulableContext sc;
		Test.startTest();
		edpBuildRelProdPartBatch.start(bc);
		edpBuildRelProdPartBatch.execute(bc,prodServiceRelationList);
		edpBuildRelProdPartBatch.execute(sc);
		edpBuildRelProdPartBatch.finish(bc);
		Test.stopTest();
	}
}