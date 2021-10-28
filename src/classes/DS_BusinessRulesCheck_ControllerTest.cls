/****************************************
* Name : DS_BusinessRulesCheck_ControllerTest
* Author : Accenture
* Description : Test class DS_BusinessRulesCheck_ControllerTest
*****************************************/
@IsTest
public class DS_BusinessRulesCheck_ControllerTest {
	
	public static Id swxRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('SWx Upsell Proposal').getRecordTypeId();
	public static Id rmpRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('DS SWMP Proposals').getRecordTypeId();
	
	/******************************
*Method Name: checkRulesTest
*Description: Test Method to cover checkRulesTest
*******************************/
	
	static testmethod void checkRulesTest(){
		
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		database.insert(accountCreation);
		
		Account acc = new Account();
		acc.Name='Legal Entinty Account For Test';
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		acc.ParentId = accountCreation.Id;
		acc.AccountNumber = '100006843';
		insert acc;
		
		List<SWx_Upsell_Proposal__c> upsellObjList = new List<SWx_Upsell_Proposal__c>();
		List<SWx_Upsell_Proposal__c> upsellObj = TestDataFactory.upsellList(3,accountCreation);
		upsellObj[0].Upsell_Status__c = CSWXGlobalConstant.readyForConversion;
		upsellObj[0].Ready_to_Convert__c = false;
		upsellObj[0].Account_ID__c = accountCreation.id;
		upsellObj[0].Sold_To_Party__c = acc.Id;
		upsellObj[0].Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource;
		upsellObj[0].RecordTypeId = swxRecordTypeId ; 
		upsellObj[1].Upsell_Status__c = CSWXGlobalConstant.readyForConversion;
		upsellObj[1].Ready_to_Convert__c = false;
		upsellObj[1].Account_ID__c = accountCreation.id;
		upsellObj[1].Sold_To_Party__c = acc.Id;
		upsellObj[1].Analytics_Source__c = 'CXM';
		upsellObj[1].RecordTypeId = swxRecordTypeId ; 
		upsellObjList.add(upsellObj[0]);
		upsellObjList.add(upsellObj[1]);
		database.insert(upsellObjList);
		
		List<product2> productObj = TestDataFactory.productCreation(2);
		productObj[0].ProductCode = 'Test';
		productObj[1].ProductCode = 'Test123';
		database.insert(productObj);
		
		List<SWx_Upsell_Items__c> insertItems = new List<SWx_Upsell_Items__c>();
		SWx_Upsell_Items__c upsellItem = TestDataFactory.createUpsellItem(1,upsellObj[0])[0];
		upsellItem.Bundle_ID__c = productObj[0].id;
		upsellItem.Sales_Item_Code__c = productObj[0].id;
		upsellItem.SWx_Upsell_Proposal__c = upsellObj[0].id;
		insertItems.add(upsellItem);
		database.insert(insertItems);
		
		Map<String,SWx_Upsell_Proposal__c> dpIdTodpObjectMap = new Map<String,SWx_Upsell_Proposal__c>();
		dpIdTodpObjectMap.put(upsellObj[0].id,upsellObj[0]);
		Set<String> productCode = new Set<String>();
		productCode.add(productObj[0].id);
		String accountId =  accountCreation.id;
		Map<Id,List<SWx_Upsell_Items__c>> dpTolineItemMap = new  Map<Id,List<SWx_Upsell_Items__c>>();
		dpTolineItemMap.put(upsellObj[0].Id,insertItems);
		
		
		
		List<Apttus_Config2__ProductOptionComponent__c>  ProductOptionComponentList = new List<Apttus_Config2__ProductOptionComponent__c>();
		Apttus_Config2__ProductOptionComponent__c productOptionComponentObj = TestDataFactory.CreateproductOptionComponent(productObj[0].id,1)[0];
		productOptionComponentObj.Apttus_Config2__ParentProductId__c = productObj[0].id;
		productOptionComponentObj.Apttus_Config2__Sequence__c = 46511;
		ProductOptionComponentList.add(productOptionComponentObj);
		database.insert(ProductOptionComponentList);	
		
		List<Apttus_Config2__PriceList__c> priceListObj = TestDataFactory.priceList(1);
		priceListObj[0].Apttus_Config2__AccountId__c = accountCreation.id;
		priceListObj[0].Type__c  = 'CXM';
		database.insert(priceListObj[0]);
		
		List<Apttus_Config2__PriceList__c> priceListObj2 = TestDataFactory.priceList(1);
		priceListObj2[0].Apttus_Config2__AccountId__c = accountCreation.id;
		priceListObj2[0].Type__c  = 'CCRE';
		database.insert(priceListObj2[0]);
		
		Apttus_Config2__PriceListItem__c priceListItemObj = TestDataFactory.createPriceListItem(1,priceListObj[0])[0];
		priceListItemObj.Apttus_Config2__PriceListId__c = priceListObj[0].id;
		priceListItemObj.Apttus_Config2__ProductId__c = productObj[0].id;
		//priceListItemObj.Apttus_Config2__ProductCode__c = 'Test';
		database.insert(priceListItemObj);
		
		DS_BusinessRulesCheck_Controller.checkRules(upsellObj[0].Id);
		DS_BusinessRulesCheck_Controller.checkRulesfromStagingObjParserClass(dpIdTodpObjectMap,productCode,accountId,dpTolineItemMap, ProductOptionComponentList);
		DS_DigitalProposalBusinessRules.updateDPforPricingValidation(true,upsellObj[0]);
		DS_BusinessRulesCheck_Controller.getDPInfo(upsellObjList[0].Id);
		DS_BusinessRulesCheck_Controller.getJsonFile(upsellObjList[0].Id);		  
		DS_DigitalProposalBusinessRules.updateDPforBundleValidation(true,upsellObj[0]); 
		DS_DigitalProposalBusinessRules.updateDPProductValidation(true,upsellObj[0]);
		
		List<SWx_Upsell_Proposal__c> upsellObjList1 = new List<SWx_Upsell_Proposal__c>();
		List<SWx_Upsell_Proposal__c> upsellObj1 = TestDataFactory.upsellList(3,accountCreation);
		upsellObj1[0].Upsell_Status__c = CSWXGlobalConstant.readyForReview;
		upsellObj1[0].Ready_to_Convert__c = false;
		upsellObj1[0].Account_ID__c = accountCreation.id;
		upsellObj1[0].Sold_To_Party__c = acc.Id;
		upsellObj1[0].Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource;
		upsellObjList1.add(upsellObj1[0]);
		database.insert(upsellObjList1);	
		
		DS_DigitalProposalBusinessRules.updateDPforPricingValidation(false,upsellObj1[0]);	  
		DS_DigitalProposalBusinessRules.updateDPforBundleValidation(false,upsellObj1[0]);   
		DS_DigitalProposalBusinessRules.updateDPProductValidation(false,upsellObj1[0]);
		
		
		//DS_DigitalProposalBusinessRules.validateUpsellItem(upsellObj[0],insertItems,ProductOptionComponentList);
		List<SWx_Upsell_Items__c> insertItems1 = new List<SWx_Upsell_Items__c>();
		SWx_Upsell_Items__c upsellItem1 = TestDataFactory.createUpsellItem(1,upsellObj[0])[0];
		
		// upsellItem1.Bundle_ID__c='Test4546566';
		upsellItem1.SWx_Product_Code__c = 'Test';
		upsellItem1.SWx_Upsell_Proposal__c = upsellObj[0].id;
		insertItems1.add(upsellItem1);
		database.insert(insertItems1);
		
		
		Map<Id, String> priceListType1 = new Map<Id, String>();
		
		List<Apttus_Config2__PriceListItem__c> priceListItemObjlist = new List<Apttus_Config2__PriceListItem__c>();
		priceListItemObjlist.add(priceListItemObj);
		// database.insert(priceListItemObjlist);
		
		
		DS_DigitalProposalBusinessRules.validateProductForPriceList(upsellObj[0],priceListObj,priceListItemObjlist,insertItems1,priceListType1);
		DS_DigitalProposalBusinessRules.validateUpsellItem(upsellObj[0],insertItems1,ProductOptionComponentList);
		
		DS_DigitalProposalBusinessRules.validateProductForCart(upsellObj[0],insertItems1,productObj);
		
		//Negative Data
		List<product2> productObj2 = TestDataFactory.productCreation(1);
		productObj2[0].ProductCode = 'Test55';
		database.insert(productObj2);
		
		List<SWx_Upsell_Items__c> insertItems2 = new List<SWx_Upsell_Items__c>();
		SWx_Upsell_Items__c upsellItem2 = TestDataFactory.createUpsellItem(1,upsellObj[0])[0];
		upsellItem2.Bundle_ID__c = productObj2[0].id;
		upsellItem2.Sales_Item_Code__c = productObj2[0].id;
		upsellItem2.SWx_Upsell_Proposal__c = upsellObj[0].id;
		insertItems2.add(upsellItem2);
		database.insert(insertItems2);
		
		DS_DigitalProposalBusinessRules.validateUpsellItem(upsellObj[0],insertItems2,ProductOptionComponentList);
	}
	
	
	/******************************
*Method Name: checkRulesTest
*Description: Test Method to cover checkRulesTest
*******************************/
 /*   
	static testmethod void checkRulesTest1(){
		
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		database.insert(accountCreation);
		
		Account acc = new Account();
		acc.Name='Legal Entinty Account For Test';
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		acc.ParentId = accountCreation.Id;
		acc.AccountNumber = '100006843';
		insert acc;
		
		List<SWx_Upsell_Proposal__c> upsellObjList = new List<SWx_Upsell_Proposal__c>();
		List<SWx_Upsell_Proposal__c> upsellObj = TestDataFactory.upsellList(3,accountCreation);
		upsellObj[0].Upsell_Status__c = 'Draft';
		upsellObj[0].Ready_to_Convert__c = false;
		upsellObj[0].Account_ID__c = accountCreation.id;
		upsellObj[0].Sold_To_Party__c = acc.Id;
		upsellObj[0].Analytics_Source__c = 'RMP';
		upsellObj[0].RecordTypeId = rmpRecordTypeId ; 
		upsellObj[1].Upsell_Status__c = CSWXGlobalConstant.readyForConversion;
		upsellObj[1].Ready_to_Convert__c = false;
		upsellObj[1].Account_ID__c = accountCreation.id;
		upsellObj[1].Sold_To_Party__c = acc.Id;
		upsellObj[1].Analytics_Source__c = 'CXM';
		upsellObj[1].RecordTypeId = swxRecordTypeId ; 
		upsellObjList.add(upsellObj[0]);
		upsellObjList.add(upsellObj[1]);
		database.insert(upsellObjList);
		
		List<product2> productObj = TestDataFactory.productCreation(2);
		productObj[0].ProductCode = 'Test';
		productObj[1].ProductCode = 'Test123';
		database.insert(productObj);
		
		List<SWx_Upsell_Items__c> insertItems = new List<SWx_Upsell_Items__c>();
		SWx_Upsell_Items__c upsellItem = TestDataFactory.createUpsellItem(1,upsellObj[0])[0];
		upsellItem.Bundle_ID__c = productObj[0].id;
		upsellItem.Sales_Item_Code__c = productObj[0].id;
		upsellItem.SWx_Upsell_Proposal__c = upsellObj[0].id;
		insertItems.add(upsellItem);
		database.insert(insertItems);
		
		Map<String,SWx_Upsell_Proposal__c> dpIdTodpObjectMap = new Map<String,SWx_Upsell_Proposal__c>();
		dpIdTodpObjectMap.put(upsellObj[0].id,upsellObj[0]);
		Set<String> productCode = new Set<String>();
		productCode.add(productObj[0].id);
		String accountId =  accountCreation.id;
		Map<Id,List<SWx_Upsell_Items__c>> dpTolineItemMap = new  Map<Id,List<SWx_Upsell_Items__c>>();
		dpTolineItemMap.put(upsellObj[0].Id,insertItems);
		
		
		
		List<Apttus_Config2__ProductOptionComponent__c>  ProductOptionComponentList = new List<Apttus_Config2__ProductOptionComponent__c>();
		Apttus_Config2__ProductOptionComponent__c productOptionComponentObj = TestDataFactory.CreateproductOptionComponent(productObj[0].id,1)[0];
		productOptionComponentObj.Apttus_Config2__ParentProductId__c = productObj[0].id;
		productOptionComponentObj.Apttus_Config2__Sequence__c = 46511;
		ProductOptionComponentList.add(productOptionComponentObj);
		database.insert(ProductOptionComponentList);	
		
		List<Apttus_Config2__PriceList__c> priceListObj = TestDataFactory.priceList(1);
		priceListObj[0].Apttus_Config2__AccountId__c = accountCreation.id;
		priceListObj[0].Type__c  = 'CXM';
		database.insert(priceListObj[0]);
		
		List<Apttus_Config2__PriceList__c> priceListObj2 = TestDataFactory.priceList(1);
		priceListObj2[0].Apttus_Config2__AccountId__c = accountCreation.id;
		priceListObj2[0].Type__c  = 'CCRE';
		database.insert(priceListObj2[0]);
		
		Apttus_Config2__PriceListItem__c priceListItemObj = TestDataFactory.createPriceListItem(1,priceListObj[0])[0];
		priceListItemObj.Apttus_Config2__PriceListId__c = priceListObj[0].id;
		priceListItemObj.Apttus_Config2__ProductId__c = productObj[0].id;
		//priceListItemObj.Apttus_Config2__ProductCode__c = 'Test';
		database.insert(priceListItemObj);
		
		DS_BusinessRulesCheck_Controller.checkRules(upsellObj[0].Id);
		DS_BusinessRulesCheck_Controller.checkRulesfromStagingObjParserClass(dpIdTodpObjectMap,productCode,accountId,dpTolineItemMap, ProductOptionComponentList);
		DS_DigitalProposalBusinessRules.updateDPforPricingValidation(true,upsellObj[0]);
		
		DS_DigitalProposalBusinessRules.updateDPforBundleValidation(true,upsellObj[0]); 
		DS_DigitalProposalBusinessRules.updateDPProductValidation(true,upsellObj[0]);
		
		List<SWx_Upsell_Proposal__c> upsellObjList1 = new List<SWx_Upsell_Proposal__c>();
		List<SWx_Upsell_Proposal__c> upsellObj1 = TestDataFactory.upsellList(3,accountCreation);
		upsellObj1[0].Upsell_Status__c = CSWXGlobalConstant.readyForReview;
		upsellObj1[0].Ready_to_Convert__c = false;
		upsellObj1[0].Account_ID__c = accountCreation.id;
		upsellObj1[0].Sold_To_Party__c = acc.Id;
		upsellObj1[0].Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource;
		upsellObjList1.add(upsellObj1[0]);
		database.insert(upsellObjList1);	
		
		DS_DigitalProposalBusinessRules.updateDPforPricingValidation(false,upsellObj1[0]);	  
		DS_DigitalProposalBusinessRules.updateDPforBundleValidation(false,upsellObj1[0]);   
		DS_DigitalProposalBusinessRules.updateDPProductValidation(false,upsellObj1[0]);
		
		
		//DS_DigitalProposalBusinessRules.validateUpsellItem(upsellObj[0],insertItems,ProductOptionComponentList);
		List<SWx_Upsell_Items__c> insertItems1 = new List<SWx_Upsell_Items__c>();
		SWx_Upsell_Items__c upsellItem1 = TestDataFactory.createUpsellItem(1,upsellObj[0])[0];
		
		// upsellItem1.Bundle_ID__c='Test4546566';
		upsellItem1.SWx_Product_Code__c = 'Test';
		upsellItem1.SWx_Upsell_Proposal__c = upsellObj[0].id;
		insertItems1.add(upsellItem1);
		database.insert(insertItems1);
		
		
		Map<Id, String> priceListType1 = new Map<Id, String>();
		
		List<Apttus_Config2__PriceListItem__c> priceListItemObjlist = new List<Apttus_Config2__PriceListItem__c>();
		priceListItemObjlist.add(priceListItemObj);
		// database.insert(priceListItemObjlist);
		
		
		DS_DigitalProposalBusinessRules.validateProductForPriceList(upsellObj[0],priceListObj,priceListItemObjlist,insertItems1,priceListType1);
		DS_DigitalProposalBusinessRules.validateUpsellItem(upsellObj[0],insertItems1,ProductOptionComponentList);
		
		DS_DigitalProposalBusinessRules.validateProductForCart(upsellObj[0],insertItems1,productObj);
		
		//Negative Data
		List<product2> productObj2 = TestDataFactory.productCreation(1);
		productObj2[0].ProductCode = 'Test55';
		database.insert(productObj2);
		
		List<SWx_Upsell_Items__c> insertItems2 = new List<SWx_Upsell_Items__c>();
		SWx_Upsell_Items__c upsellItem2 = TestDataFactory.createUpsellItem(1,upsellObj[0])[0];
		upsellItem2.Bundle_ID__c = productObj2[0].id;
		upsellItem2.Sales_Item_Code__c = productObj2[0].id;
		upsellItem2.SWx_Upsell_Proposal__c = upsellObj[0].id;
		insertItems2.add(upsellItem2);
		database.insert(insertItems2);
		
		DS_DigitalProposalBusinessRules.validateUpsellItem(upsellObj[0],insertItems2,ProductOptionComponentList);
	}	*/	
	
	/******************************
*Method Name: checkRulesTestForNegativeNull
*Description: Test Method to cover checkRulesTest
*******************************/
	
	static testmethod void checkRulesTestForNegativeNull(){
		
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		database.insert(accountCreation);
		
		Account acc = new Account();
		acc.Name='Legal Entinty Account For Test';
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		acc.ParentId = accountCreation.Id;
		acc.AccountNumber = '100006843';
		insert acc;
		
		List<SWx_Upsell_Proposal__c> upsellObjList = new List<SWx_Upsell_Proposal__c>();
		List<SWx_Upsell_Proposal__c> upsellObj = TestDataFactory.upsellList(3,accountCreation);
		upsellObj[0].Upsell_Status__c = CSWXGlobalConstant.readyForConversion;
		upsellObj[0].Ready_to_Convert__c = false;
		upsellObj[0].Account_ID__c = accountCreation.id;
		upsellObj[0].Sold_To_Party__c = acc.Id;
		upsellObj[0].Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource;
		upsellObj[0].RecordTypeId = swxRecordTypeId ; 
		upsellObj[1].Upsell_Status__c = CSWXGlobalConstant.readyForConversion;
		upsellObj[1].Ready_to_Convert__c = false;
		upsellObj[1].Account_ID__c = accountCreation.id;
		upsellObj[1].Analytics_Source__c = 'CXM';
		upsellObj[1].Sold_To_Party__c = acc.Id;
		upsellObj[1].RecordTypeId = swxRecordTypeId ; 
		upsellObjList.add(upsellObj[0]);
		upsellObjList.add(upsellObj[1]);
		database.insert(upsellObjList);
		
		List<product2> productObj = TestDataFactory.productCreation(2);
		productObj[0].ProductCode = 'Test';
		productObj[1].ProductCode = 'Test123';
		database.insert(productObj);
		
		List<SWx_Upsell_Items__c> insertItems = new List<SWx_Upsell_Items__c>();
		SWx_Upsell_Items__c upsellItem = TestDataFactory.createUpsellItem(1,upsellObj[0])[0];
		upsellItem.Bundle_ID__c = productObj[0].id;
		upsellItem.Sales_Item_Code__c = productObj[0].id;
		upsellItem.SWx_Upsell_Proposal__c = upsellObj[0].id;
		insertItems.add(upsellItem);
		database.insert(insertItems);
		
		Map<String,SWx_Upsell_Proposal__c> dpIdTodpObjectMap = new Map<String,SWx_Upsell_Proposal__c>();
		dpIdTodpObjectMap.put(upsellObj[0].id,upsellObj[0]);
		Set<String> productCode = new Set<String>();
		productCode.add(productObj[0].id);
		String accountId =  accountCreation.id;
		Map<Id,List<SWx_Upsell_Items__c>> dpTolineItemMap = new  Map<Id,List<SWx_Upsell_Items__c>>();
		dpTolineItemMap.put(upsellObj[0].Id,insertItems);
		
		
		
		List<Apttus_Config2__ProductOptionComponent__c>  ProductOptionComponentList = new List<Apttus_Config2__ProductOptionComponent__c>();
		Apttus_Config2__ProductOptionComponent__c productOptionComponentObj = TestDataFactory.CreateproductOptionComponent(productObj[0].id,1)[0];
		productOptionComponentObj.Apttus_Config2__ParentProductId__c = productObj[0].id;
		productOptionComponentObj.Apttus_Config2__Sequence__c = 46511;
		ProductOptionComponentList.add(productOptionComponentObj);
		database.insert(ProductOptionComponentList);	
		
		List<Apttus_Config2__PriceList__c> priceListObj = TestDataFactory.priceList(1);
		priceListObj[0].Apttus_Config2__AccountId__c = accountCreation.id;
		priceListObj[0].Type__c  = 'CXM';
		database.insert(priceListObj[0]);
		
		List<Apttus_Config2__PriceList__c> priceListObj2 = TestDataFactory.priceList(1);
		priceListObj2[0].Apttus_Config2__AccountId__c = accountCreation.id;
		priceListObj2[0].Type__c  = 'CCRE';
		database.insert(priceListObj2[0]);
		
		Apttus_Config2__PriceListItem__c priceListItemObj = TestDataFactory.createPriceListItem(1,priceListObj[0])[0];
		priceListItemObj.Apttus_Config2__PriceListId__c = priceListObj[0].id;
		priceListItemObj.Apttus_Config2__ProductId__c = productObj[0].id;
		//priceListItemObj.Apttus_Config2__ProductCode__c = 'Test';
		database.insert(priceListItemObj);
		
		DS_BusinessRulesCheck_Controller.checkRules(upsellObj[0].Id);
		DS_BusinessRulesCheck_Controller.checkRulesfromStagingObjParserClass(null,null,null,null,null);
		DS_DigitalProposalBusinessRules.updateDPforPricingValidation(true,null);
		
		DS_DigitalProposalBusinessRules.updateDPforBundleValidation(true,null); 
		DS_DigitalProposalBusinessRules.updateDPProductValidation(true,null);
		
		List<SWx_Upsell_Proposal__c> upsellObjList1 = new List<SWx_Upsell_Proposal__c>();
		List<SWx_Upsell_Proposal__c> upsellObj1 = TestDataFactory.upsellList(3,accountCreation);
		upsellObj1[0].Upsell_Status__c = CSWXGlobalConstant.readyForReview;
		upsellObj1[0].Ready_to_Convert__c = false;
		upsellObj1[0].Account_ID__c = accountCreation.id;
		upsellObj1[0].Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource;
		upsellObj1[0].Sold_To_Party__c = acc.Id;
		upsellObjList1.add(upsellObj1[0]);
		database.insert(upsellObjList1);	
		
		DS_DigitalProposalBusinessRules.updateDPforPricingValidation(false,null);	  
		DS_DigitalProposalBusinessRules.updateDPforBundleValidation(false,null);   
		DS_DigitalProposalBusinessRules.updateDPProductValidation(false,null);
		
		
		//DS_DigitalProposalBusinessRules.validateUpsellItem(upsellObj[0],insertItems,ProductOptionComponentList);
		List<SWx_Upsell_Items__c> insertItems1 = new List<SWx_Upsell_Items__c>();
		SWx_Upsell_Items__c upsellItem1 = TestDataFactory.createUpsellItem(1,upsellObj[0])[0];
		
		// upsellItem1.Bundle_ID__c='Test4546566';
		
		upsellItem1.SWx_Upsell_Proposal__c = upsellObj[0].id;
		upsellItem1.Sales_Item_Code__c = productObj[0].id;
		insertItems1.add(upsellItem1);
		database.insert(insertItems1);
		
		
		Map<Id, String> priceListType1 = new Map<Id, String>();
		
		List<Apttus_Config2__PriceListItem__c> priceListItemObjlist = new List<Apttus_Config2__PriceListItem__c>();
		priceListItemObjlist.add(priceListItemObj);
		// database.insert(priceListItemObjlist);
		
		
		DS_DigitalProposalBusinessRules.validateProductForPriceList(null,null,null,null,null);
		
		
		DS_DigitalProposalBusinessRules.validateProductForCart(null,null,null);
		
		//Negative Data
		List<product2> productObj2 = TestDataFactory.productCreation(1);
		productObj2[0].ProductCode = 'Test55';
		database.insert(productObj2);
		
		List<SWx_Upsell_Items__c> insertItems2 = new List<SWx_Upsell_Items__c>();
		SWx_Upsell_Items__c upsellItem2 = TestDataFactory.createUpsellItem(1,upsellObj[0])[0];
		upsellItem2.Bundle_ID__c = productObj2[0].id;
		upsellItem2.Sales_Item_Code__c = productObj2[0].id;
		upsellItem2.SWx_Upsell_Proposal__c = upsellObj[0].id;
		insertItems2.add(upsellItem2);
		database.insert(insertItems2);
		
		
		DS_DigitalProposalBusinessRules.createPriceItemList(null);
		DS_DigitalProposalBusinessRules.getListOfPriceList('');
	}
	
	/******************************
*Method Name: checkRulesTest
*Description: Test Method to cover checkRulesTest
*******************************/
	
	static testmethod void checkRulesTest4(){
		
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		database.insert(accountCreation);
		
		Account acc = new Account();
		acc.Name='Legal Entinty Account For Test';
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		acc.ParentId = accountCreation.Id;
		acc.AccountNumber = '100006843';
		insert acc;
		
		List<SWx_Upsell_Proposal__c> upsellObjList = new List<SWx_Upsell_Proposal__c>();
		List<SWx_Upsell_Proposal__c> upsellObj = TestDataFactory.upsellList(3,accountCreation);
		upsellObj[0].Upsell_Status__c = CSWXGlobalConstant.readyForConversion;
		upsellObj[0].Ready_to_Convert__c = false;
		upsellObj[0].Account_ID__c = accountCreation.id;
		upsellObj[0].Sold_To_Party__c = acc.Id;
		upsellObj[0].Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource;
		upsellObj[0].RecordTypeId = swxRecordTypeId ; 
		upsellObj[1].Upsell_Status__c = CSWXGlobalConstant.readyForConversion;
		upsellObj[1].Ready_to_Convert__c = false;
		upsellObj[1].Account_ID__c = accountCreation.id;
		upsellObj[1].Sold_To_Party__c = acc.Id;
		upsellObj[1].Analytics_Source__c = 'CXM';
		upsellObj[1].RecordTypeId = swxRecordTypeId ; 
		upsellObjList.add(upsellObj[0]);
		upsellObjList.add(upsellObj[1]);
		database.insert(upsellObjList);
		
		List<product2> productObj = TestDataFactory.productCreation(2);
		productObj[0].ProductCode = 'Test';
		productObj[1].ProductCode = 'Test123';
		database.insert(productObj);
		
		List<SWx_Upsell_Items__c> insertItems = new List<SWx_Upsell_Items__c>();
		SWx_Upsell_Items__c upsellItem = TestDataFactory.createUpsellItem(1,upsellObj[0])[0];
		upsellItem.Bundle_ID__c = productObj[0].id;
		upsellItem.Sales_Item_Code__c = productObj[0].id;
		upsellItem.SWx_Upsell_Proposal__c = upsellObj[0].id;
		insertItems.add(upsellItem);
		database.insert(insertItems);
		
		Map<String,SWx_Upsell_Proposal__c> dpIdTodpObjectMap = new Map<String,SWx_Upsell_Proposal__c>();
		dpIdTodpObjectMap.put(upsellObj[0].id,upsellObj[0]);
		Set<String> productCode = new Set<String>();
		productCode.add(productObj[0].id);
		String accountId =  accountCreation.id;
		Map<Id,List<SWx_Upsell_Items__c>> dpTolineItemMap = new  Map<Id,List<SWx_Upsell_Items__c>>();
		dpTolineItemMap.put(upsellObj[0].Id,insertItems);
		
		
		
		List<Apttus_Config2__ProductOptionComponent__c>  ProductOptionComponentList = new List<Apttus_Config2__ProductOptionComponent__c>();
		Apttus_Config2__ProductOptionComponent__c productOptionComponentObj = TestDataFactory.CreateproductOptionComponent(productObj[0].id,1)[0];
		productOptionComponentObj.Apttus_Config2__ParentProductId__c = productObj[0].id;
		productOptionComponentObj.Apttus_Config2__Sequence__c = 46511;
		ProductOptionComponentList.add(productOptionComponentObj);
		database.insert(ProductOptionComponentList);	
		
		List<Apttus_Config2__PriceList__c> priceListObj = TestDataFactory.priceList(1);
		priceListObj[0].Apttus_Config2__AccountId__c = accountCreation.id;
		priceListObj[0].Type__c  = 'CXM';
		database.insert(priceListObj[0]);
		
		List<Apttus_Config2__PriceList__c> priceListObj2 = TestDataFactory.priceList(1);
		priceListObj2[0].Apttus_Config2__AccountId__c = accountCreation.id;
		priceListObj2[0].Type__c  = 'CCRE';
		database.insert(priceListObj2[0]);
		
		Apttus_Config2__PriceListItem__c priceListItemObj = TestDataFactory.createPriceListItem(1,priceListObj[0])[0];
		priceListItemObj.Apttus_Config2__PriceListId__c = priceListObj[0].id;
		priceListItemObj.Apttus_Config2__ProductId__c = productObj[0].id;
		//priceListItemObj.Apttus_Config2__ProductCode__c = 'Test';
		database.insert(priceListItemObj);
		
		DS_BusinessRulesCheck_Controller.checkRules(upsellObj[0].Id);
		DS_BusinessRulesCheck_Controller.checkRulesfromStagingObjParserClass(dpIdTodpObjectMap,productCode,accountId,dpTolineItemMap, ProductOptionComponentList);
		DS_DigitalProposalBusinessRules.updateDPforPricingValidation(true,upsellObj[0]);
		
		DS_DigitalProposalBusinessRules.updateDPforBundleValidation(true,upsellObj[0]); 
		DS_DigitalProposalBusinessRules.updateDPProductValidation(true,upsellObj[0]);
		
		List<SWx_Upsell_Proposal__c> upsellObjList1 = new List<SWx_Upsell_Proposal__c>();
		List<SWx_Upsell_Proposal__c> upsellObj1 = TestDataFactory.upsellList(3,accountCreation);
		upsellObj1[0].Upsell_Status__c = CSWXGlobalConstant.readyForConversion;
		upsellObj1[0].Ready_to_Convert__c = false;
		upsellObj1[0].Account_ID__c = accountCreation.id;
		upsellObj1[0].Sold_To_Party__c = acc.Id;
		upsellObj1[0].Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource;
		upsellObjList1.add(upsellObj1[0]);
		database.insert(upsellObjList1);	
		
		DS_DigitalProposalBusinessRules.updateDPforPricingValidation(false,upsellObj1[0]);	  
		DS_DigitalProposalBusinessRules.updateDPforBundleValidation(false,upsellObj1[0]);   
		DS_DigitalProposalBusinessRules.updateDPProductValidation(false,upsellObj1[0]);
		
		
		//DS_DigitalProposalBusinessRules.validateUpsellItem(upsellObj[0],insertItems,ProductOptionComponentList);
		List<SWx_Upsell_Items__c> insertItems1 = new List<SWx_Upsell_Items__c>();
		SWx_Upsell_Items__c upsellItem1 = TestDataFactory.createUpsellItem(1,upsellObj[0])[0];
		
		// upsellItem1.Bundle_ID__c='Test4546566';
		upsellItem1.SWx_Product_Code__c = 'Test';
		upsellItem1.SWx_Upsell_Proposal__c = upsellObj[0].id;
		insertItems1.add(upsellItem1);
		database.insert(insertItems1);
		
		
		Map<Id, String> priceListType1 = new Map<Id, String>(); 
		
		List<Apttus_Config2__PriceListItem__c> priceListItemObjlist = new List<Apttus_Config2__PriceListItem__c>();
		priceListItemObjlist.add(priceListItemObj);
		// database.insert(priceListItemObjlist);
		
		
		DS_DigitalProposalBusinessRules.validateProductForPriceList(upsellObj[0],priceListObj,priceListItemObjlist,insertItems1,priceListType1);
		DS_DigitalProposalBusinessRules.validateUpsellItem(upsellObj[0],insertItems1,ProductOptionComponentList);
		
		DS_DigitalProposalBusinessRules.validateProductForCart(upsellObj[0],insertItems1,productObj);
		
		//Negative Data
		List<product2> productObj2 = TestDataFactory.productCreation(1);
		productObj2[0].ProductCode = 'Test55';
		database.insert(productObj2);
		
		List<SWx_Upsell_Items__c> insertItems2 = new List<SWx_Upsell_Items__c>();
		SWx_Upsell_Items__c upsellItem2 = TestDataFactory.createUpsellItem(1,upsellObj[0])[0];
		upsellItem2.Bundle_ID__c = productObj2[0].id;
		upsellItem2.Sales_Item_Code__c = productObj2[0].id;
		upsellItem2.SWx_Upsell_Proposal__c = upsellObj[0].id;
		insertItems2.add(upsellItem2);
		database.insert(insertItems2);
		
		DS_DigitalProposalBusinessRules.validateUpsellItem(upsellObj[0],insertItems2,ProductOptionComponentList);
	}
}