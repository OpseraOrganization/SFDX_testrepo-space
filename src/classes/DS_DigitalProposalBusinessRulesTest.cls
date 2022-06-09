@IsTest
private with sharing class DS_DigitalProposalBusinessRulesTest{
   public static Id swxRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('SWx Upsell Proposal').getRecordTypeId();
   public static Id ccreRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('CCRE Upsell Proposal').getRecordTypeId();
			
   
	/******************************
	*Method Name: validateProductForCartTest
	*Description: Test Method to cover validateProductForCart method
	********************************/
	static testmethod void validateProductForCartTest(){
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		userCreation.Nokia_ID__c = '54214';
			List<product2> productObj = TestDataFactory.productCreation(2);
			productObj[0].ProductCode = '151421';
			productObj[1].ProductCode = '151422';
			database.insert(productObj);
	  
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
			upsellObj[1].Upsell_Status__c = CSWXGlobalConstant.draft;
			upsellObj[0].Ready_to_Convert__c = false;
			upsellObj[0].Account_ID__c = accountCreation.id;
			upsellObj[0].Sold_To_Party__c = acc.Id;
			upsellObj[1].Sold_To_Party__c = acc.Id;
			upsellObj[2].Sold_To_Party__c = acc.Id;
			upsellObj[1].Account_ID__c = accountCreation.id;
			upsellObj[2].Account_ID__c = accountCreation.id;
			upsellObj[0].Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource;
			upsellObj[1].Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource;
			upsellObj[0].RecordTypeId = swxRecordTypeId;
			upsellObj[1].RecordTypeId = swxRecordTypeId;
			
			upsellObj[2].Analytics_Source__c = 'CCRE';
			upsellObj[2].Upsell_Status__c = CSWXGlobalConstant.draft;
			upsellObj[2].RecordTypeId = ccreRecordTypeId;
			upsellObjList.add(upsellObj[0]);
			upsellObjList.add(upsellObj[1]);
			upsellObjList.add(upsellObj[2]);
			database.insert(upsellObjList);
			System.assertEquals(upsellObj[1].Analytics_Source__c,CSWXGlobalConstant.AnalyticsSource);
		
			List<SWx_Upsell_Items__c> insertItems = new List<SWx_Upsell_Items__c>();
			SWx_Upsell_Items__c upsellItem = TestDataFactory.createUpsellItem(1,upsellObj[0])[0];
			upsellItem.Feature_ID__c = 'Test';
			upsellItem.Sales_Item_Code_SWx__c = 'Test';
			upsellItem.SWx_Upsell_Proposal__c = upsellObj[0].id;
			insertItems.add(upsellItem);
			
			SWx_Upsell_Items__c upsellItem1 = TestDataFactory.createUpsellItem(1,upsellObj[1])[0];
			upsellItem1.Feature_ID__c = 'Test';
			upsellItem1.Sales_Item_Code_SWx__c = 'Test';
			upsellItem1.SWx_Upsell_Proposal__c = upsellObj[1].id;
			insertItems.add(upsellItem1);
			
			database.insert(insertItems);
			
			CCRE_UpSell_LineItem__c CCREItem = new CCRE_UpSell_LineItem__c();
			CCREItem.Service_PCI__c = 'Test';
			CCREItem.Sales_Item_Code__c = 'Test';
			CCREItem.Upsell_Proposal__c= upsellObj[2].Id;
			database.insert(CCREItem);
			
		   // DS_DigitalProposalBusinessRules.validateProductForCart(upsellObjList);
			
			upsellObj[2].Upsell_Status__c = CSWXGlobalConstant.readyForConversion;
			 upsellObj[1].Upsell_Status__c = CSWXGlobalConstant.readyForConversion;
			 database.update(upsellObjList);
			
			upsellItem.Feature_ID__c = '151421';
			upsellItem.Sales_Item_Code_SWx__c = '151422';
			upsellItem1.Feature_ID__c = '151421';
			upsellItem1.Sales_Item_Code_SWx__c = '151422';
			
			CCREItem.Service_PCI__c = '151421';
			CCREItem.Sales_Item_Code__c = '151422';
			update insertItems;
			update CCREItem;
			//DS_DigitalProposalBusinessRules.validateProductForCart(upsellObjList);
	   
	}
	/******************************
	*Method Name: validateProductForCartCCRETest
	*Description: Test Method to cover validateProductForCart method
	********************************/
	static testmethod void validateProductForCartCCRETest(){
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		userCreation.Nokia_ID__c = '54214';
			List<product2> productObj = TestDataFactory.productCreation(2);
			productObj[0].ProductCode = '151421';
			productObj[1].ProductCode = '151422';
			database.insert(productObj);
			
			 
		
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			database.insert(accountCreation);
			
			 Account acc = new Account();
				acc.Name='Legal Entinty Account For Test';
				acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
				acc.ParentId = accountCreation.Id;
				acc.AccountNumber = '100006843';
				insert acc;
			
			List<SWx_Upsell_Proposal__c> upsellObjList = new List<SWx_Upsell_Proposal__c>();
			List<SWx_Upsell_Proposal__c> upsellObj = TestDataFactory.upsellList(2,accountCreation);
			upsellObj[0].Upsell_Status__c = CSWXGlobalConstant.readyForConversion;
			upsellObj[1].Upsell_Status__c = CSWXGlobalConstant.draft;
			upsellObj[0].Ready_to_Convert__c = false;
			upsellObj[0].Sold_To_Party__c = acc.Id;
			upsellObj[1].Sold_To_Party__c = acc.Id;
			upsellObj[0].Account_ID__c = accountCreation.id;
			upsellObj[1].Account_ID__c = accountCreation.id;
			upsellObj[0].Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource_CCRE;
			upsellObj[1].Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource_CCRE;
			upsellObj[0].RecordTypeId = ccreRecordTypeId;
			upsellObj[1].RecordTypeId = ccreRecordTypeId;
			upsellObjList.add(upsellObj[0]);
			upsellObjList.add(upsellObj[1]);
			database.insert(upsellObjList);
			System.assertEquals(upsellObj[1].Analytics_Source__c,CSWXGlobalConstant.AnalyticsSource_CCRE);
		
			
			Map<Id,SWx_Upsell_Proposal__c> oldmap = new Map<Id,SWx_Upsell_Proposal__c>();
			oldmap.put(upsellObj[0].id,upsellObj[1]);
			
			SWx_Upsell_Items__c upsellItem = TestDataFactory.createUpsellItem(1,upsellObj[1])[0];
			upsellItem.Feature_ID__c = 'testId';
			upsellItem.Sales_Item_Code_SWx__c = 'testSourceItemCode';
			upsellItem.SWx_Upsell_Proposal__c = upsellObj[0].id;
			database.insert(upsellItem);
			
			//DS_DigitalProposalBusinessRules.validateProductForCart(upsellObjList);
			
			upsellItem.Feature_ID__c = '151421';
			upsellItem.Sales_Item_Code_SWx__c = '151422';
			database.update(upsellItem);
			DS_BusinessRulesCheck_Controller.checkRules(upsellObj[0].id);
			DS_BusinessRulesCheck_Controller.checkRules(upsellObj[1].id);
		}
	
	/******************************
	*Method Name: validateProductForPriceListTest
	*Description: Test Method to cover validateProductForPriceList method
	********************************/
	static testmethod void validateProductForPriceListTest(){
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		userCreation.Nokia_ID__c = '54217';
	   
		
	   
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			database.insert(accountCreation);
			
			
			 Account acc = new Account();
				acc.Name='Legal Entinty Account For Test';
				acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
				acc.ParentId = accountCreation.Id;
				acc.AccountNumber = '100006843';
				insert acc;
			
			List<SWx_Upsell_Proposal__c> upsellObj = TestDataFactory.upsellList(2,accountCreation);
			List<SWx_Upsell_Proposal__c> upsellObjInsertList = new List<SWx_Upsell_Proposal__c>();
			upsellObj[0].Upsell_Status__c = CSWXGlobalConstant.draft;
			upsellObj[0].Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource_CCRE;
			upsellObj[0].Account_ID__c = accountCreation.id;
			upsellObj[0].Sold_To_Party__c = acc.Id;
			upsellObj[1].Sold_To_Party__c = acc.Id;
			 
			upsellObj[1].Account_ID__c = accountCreation.id;
			upsellObj[1].Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource;
			upsellObj[1].Upsell_Status__c = CSWXGlobalConstant.draft;
			upsellObj[0].RecordTypeId = ccreRecordTypeId;
			upsellObj[1].RecordTypeId = swxRecordTypeId;
			upsellObjInsertList.add(upsellObj[0]);
			upsellObjInsertList.add(upsellObj[1]);
			database.insert(upsellObjInsertList);
			
			System.assertEquals(upsellObj[1].Analytics_Source__c,CSWXGlobalConstant.AnalyticsSource);
		
			
			List<product2> productObj = TestDataFactory.productCreation(2);
			productObj[0].ProductCode = '151421';
			productObj[1].ProductCode = '151422';
			database.insert(productObj);
			
			List<Apttus_Config2__PriceList__c> priceListObj = TestDataFactory.priceList(1);
			priceListObj[0].Apttus_Config2__AccountId__c = accountCreation.id;
			priceListObj[0].Type__c  = CSWXGlobalConstant.AnalyticsSource_CCRE;
			database.insert(priceListObj[0]);
			
			Apttus_Config2__PriceListItem__c priceListItemObj = TestDataFactory.createPriceListItem(1,priceListObj[0])[0];
			priceListItemObj.Apttus_Config2__PriceListId__c = priceListObj[0].id;
			priceListItemObj.Apttus_Config2__ProductId__c = productObj[1].id;
			database.insert(priceListItemObj);	  

			CCRE_UpSell_LineItem__c upsellLineItemObj = new CCRE_UpSell_LineItem__c();
			upsellLineItemObj.Line_Item_Type__c = 'sales_line_items';
			upsellLineItemObj.Service_PCI__c = '151422';
			upsellLineItemObj.Sales_Item_Code__c = '151421';
			upsellLineItemObj.Upsell_Proposal__c  = upsellObjInsertList[0].id;
			database.insert(upsellLineItemObj); 
			
			SWx_Upsell_Items__c upsellItem = TestDataFactory.createUpsellItem(1,upsellObj[1])[0];
			upsellItem.Feature_ID__c = '151422';
			upsellItem.Sales_Item_Code_SWx__c = '151421';
			upsellItem.SWx_Upsell_Proposal__c = upsellObjInsertList[1].id;
			database.insert(upsellItem);
			
			upsellObj[0].Upsell_Status__c = CSWXGlobalConstant.readyForConversion;
			upsellObj[1].Upsell_Status__c = CSWXGlobalConstant.readyForConversion;
			database.update(upsellObjInsertList);
			
			//DS_DigitalProposalBusinessRules.validateProductForPriceList(upsellObjInsertList);
			priceListItemObj.Apttus_Config2__ProductId__c = productObj[0].id;
			update(priceListItemObj);
			
		   // DS_DigitalProposalBusinessRules.validateProductForPriceList(upsellObjInsertList);
		}
	
	/******************************
	*Method Name: validateUpsellItemTest
	*Description: Test Method to cover validateUpsellItem method
	********************************/
	static testmethod void validateUpsellItemTest(){
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		userCreation.Nokia_ID__c = '21514';
		
		 
	   
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			database.insert(accountCreation);
			
			
			 Account acc = new Account();
				acc.Name='Legal Entinty Account For Test';
				acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
				acc.ParentId = accountCreation.Id;
				acc.AccountNumber = '100006843';
				insert acc;
			
			List<SWx_Upsell_Proposal__c> upsellObj = TestDataFactory.upsellList(2,accountCreation);
			List<SWx_Upsell_Proposal__c> upsellObjInsertList = new List<SWx_Upsell_Proposal__c>();
			upsellObj[0].Upsell_Status__c = CSWXGlobalConstant.readyForConversion;
			upsellObj[0].Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource;
			upsellObj[0].Account_ID__c = accountCreation.id;
			upsellObj[0].Sold_To_Party__c = acc.Id;
			upsellObj[1].Sold_To_Party__c = acc.Id;
			upsellObj[1].Account_ID__c = accountCreation.id;
			upsellObj[1].Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource;
			upsellObj[1].Upsell_Status__c = CSWXGlobalConstant.draft;
			upsellObj[0].RecordTypeId = swxRecordTypeId;
			upsellObj[1].RecordTypeId = swxRecordTypeId;
			upsellObjInsertList.add(upsellObj[0]);
			database.insert(upsellObjInsertList);
			
			System.assertEquals(upsellObj[1].Analytics_Source__c,CSWXGlobalConstant.AnalyticsSource);
			Map<Id,SWx_Upsell_Proposal__c> upsellProposalOldmap = new Map<Id,SWx_Upsell_Proposal__c>();
			upsellProposalOldmap.put(upsellObj[0].id, upsellObj[1]);
			
			product2 productObj = TestDataFactory.productCreation(1)[0];
			productObj.ProductCode = '151421';
			database.insert(productObj);
			
			Apttus_Config2__ProductOptionComponent__c productOptionComponentObj = TestDataFactory.productOptionComponent(1)[0];
			productOptionComponentObj.Apttus_Config2__ParentProductId__c = productObj.id;
			productOptionComponentObj.Apttus_Config2__Sequence__c = 46511;
			database.insert(productOptionComponentObj);
			
			SWx_Upsell_Items__c upsellItem = TestDataFactory.createUpsellItem(1,upsellObjInsertList[0])[0];
			upsellItem.Feature_ID__c = '151421';
			upsellItem.Sales_Item_Code_SWx__c = '151421';
			database.insert(upsellItem); 
			
			DS_BusinessRulesCheck_Controller.checkRules(upsellObjInsertList[0].id);
			
		   // DS_DigitalProposalBusinessRules.validateUpsellItem(upsellObjInsertList);
	 
	}
	/******************************
	*Method Name: validateUpsellItemCCRETest
	*Description: Test Method to cover validateUpsellItem method CCRE part
	********************************/
	static testmethod void validateUpsellItemCCRETest(){
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		userCreation.Nokia_ID__c = '1123';
	   
		
				
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			database.insert(accountCreation);
			
			 Account acc = new Account();
				acc.Name='Legal Entinty Account For Test';
				acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
				acc.ParentId = accountCreation.Id;
				acc.AccountNumber = '100006843';
				insert acc;
			
			List<SWx_Upsell_Proposal__c> upsellObj = TestDataFactory.upsellList(2,accountCreation);
			List<SWx_Upsell_Proposal__c> upsellObjInsertList = new List<SWx_Upsell_Proposal__c>();
			upsellObj[0].Upsell_Status__c = CSWXGlobalConstant.readyForConversion;
			upsellObj[0].Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource_CCRE;
			upsellObj[0].Account_ID__c = accountCreation.id;
			upsellObj[1].Account_ID__c = accountCreation.id;
			upsellObj[0].Sold_To_Party__c = acc.Id;
			upsellObj[1].Sold_To_Party__c = acc.Id;
			upsellObj[1].Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource_CCRE;
			upsellObj[1].Upsell_Status__c = CSWXGlobalConstant.draft;
			upsellObj[0].RecordTypeId = ccreRecordTypeId;
			upsellObj[1].RecordTypeId = ccreRecordTypeId;
			upsellObjInsertList.add(upsellObj[0]);
			database.insert(upsellObjInsertList);
			
			 System.assertEquals(upsellObj[1].Analytics_Source__c,CSWXGlobalConstant.AnalyticsSource_CCRE);
			Map<Id,SWx_Upsell_Proposal__c> upsellProposalOldmap = new Map<Id,SWx_Upsell_Proposal__c>();
			upsellProposalOldmap.put(upsellObj[0].id, upsellObj[1]);
			
			product2 productObj = TestDataFactory.productCreation(1)[0];
			productObj.ProductCode = '151421';
			database.insert(productObj);
			
			Apttus_Config2__ProductOptionComponent__c productOptionComponentObj = TestDataFactory.productOptionComponent(1)[0];
			productOptionComponentObj.Apttus_Config2__ParentProductId__c = productObj.id;
			productOptionComponentObj.Apttus_Config2__Sequence__c = 46511;
			database.insert(productOptionComponentObj);
			
			CCRE_UpSell_LineItem__c upsellLineItemObj = TestDataFactory.upsellLineItem(1,upsellObjInsertList[0].id)[0];
			upsellLineItemObj.Line_Item_Type__c = 'sales_line_items';
			upsellLineItemObj.Service_PCI__c = '151421';
			upsellLineItemObj.Sales_Item_Code__c = '151421';
			upsellLineItemObj.Upsell_Proposal__c  = upsellObjInsertList[0].id;
			database.insert(upsellLineItemObj);		 
			
		   // DS_DigitalProposalBusinessRules.validateUpsellItem(upsellObjInsertList);
		}
}