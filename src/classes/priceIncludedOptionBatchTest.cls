@isTest(seeAllData=false)
public class priceIncludedOptionBatchTest{
	
	public static testmethod void method1(){
		  List<Product2> prods = new List<Product2>();

		Product2 prod1 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod1.Apttus_Config2__ConfigurationType__c = 'Bundle';
	  prod1.NokiaCPQ_Static_Bundle_Option__c = true;
	  prods.add(prod1);
	  
	  Product2 prod2 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod2.Name = 'Option1Care';
	  prod2.ProductCode = '784800098209';
	//  prod2.Business_Group__c = 'MN';
	  prods.add(prod2);
	  
	  insert prods;
	  Product2 prod3 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod3.Name = 'Option2SRS'; 
	  prod3.Business_Group__c = 'MN';
	  prod3.ProductCode = 'SRS';
	  prod3.NokiaCPQ_Product_Discount_Category__c = 'NFM-P';
	  prods.add(prod3);
	  
	 /* Product2 prod4 = TestDataSetup.createCPQTestproduct(1)[0];
	  prod4.Name = 'Option3';
	  prod4.Business_Group__c = 'MN';
	  prods.add(prod4); */
	   List<Apttus_Config2__ProductOptionComponent__c> pocList = new List<Apttus_Config2__ProductOptionComponent__c>();
	Apttus_Config2__ProductOptionComponent__c productOptionComponentObj1 = TestDataFactory.CreateproductOptionComponent(prods[1].id,1)[0];
	productOptionComponentObj1.Apttus_Config2__ParentProductId__c = prods[0].id;
	productOptionComponentObj1.Apttus_Config2__Sequence__c = 46511;
	pocList.add(productOptionComponentObj1);

		Apttus_Config2__ProductOptionComponent__c productOptionComponentObj2 = TestDataFactory.CreateproductOptionComponent(prods[2].id,1)[0];
	productOptionComponentObj2.Apttus_Config2__ParentProductId__c = prods[0].id;
	productOptionComponentObj2.Apttus_Config2__Sequence__c = 46511;
	pocList.add(productOptionComponentObj2);
		insert pocList;
	
	//Create PriceList
	  
	  Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
		Name = 'Commercial Price List', 
		Apttus_Config2__Active__c = True
	  );
	  insert ApttusTestPriceList;
	  
	  //create price list items
	  List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
	  Apttus_Config2__PriceListItem__c pLI1 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI1.Apttus_Config2__ProductId__c = prods[0].Id;
	  plistItems.add(pLI1);
	  
	  Apttus_Config2__PriceListItem__c pLI2 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI2.Apttus_Config2__ProductId__c = prods[1].Id;
	  pLI2.Apttus_Config2__PriceIncludedInBundle__c = true;
	  pLI2.Apttus_Config2__ChargeType__c = 'Standard Price';
	  plistItems.add(pLI2); 
	  
	  Apttus_Config2__PriceListItem__c pLI3 = TestDataSetup.creatPriceListItem(ApttusTestPriceList, 1)[0];
	  pLI3.Apttus_Config2__ProductId__c = prods[2].Id;
	  pLI3.Apttus_Config2__PriceIncludedInBundle__c = true;
	  pLI3.Apttus_Config2__ChargeType__c = 'Standard Price';
	  plistItems.add(pLI3);   
	  insert  plistItems;
	
	Apttus_Config2__ProductOptionPrice__c POP = new Apttus_Config2__ProductOptionPrice__c();
	pop.Apttus_Config2__PriceListId__c = ApttusTestPriceList.id;
				pop.Apttus_Config2__AdjustmentAmount__c = 0;
				pop.Apttus_Config2__AdjustmentType__c = 'Price Override';
				pop.Apttus_Config2__ChargeType__c = 'Standard Price';
				pop.Apttus_Config2__IsQuantityReadOnly__c = true;
				pop.Apttus_Config2__PriceIncludedInBundle__c = true;
				pop.Apttus_Config2__PriceOverride__c = 0;
				pop.Apttus_Config2__ProductOptionId__c = pocList[0].id;
				pop.Apttus_Config2__RollupPriceToBundle__c = true;
				pop.Apttus_Config2__Sequence__c = 1;	
	  insert POP;
		Test.startTest();
			  Database.executeBatch(new priceIncludedOptionBatch(), 1);
		Test.stopTest();

	}
	
}