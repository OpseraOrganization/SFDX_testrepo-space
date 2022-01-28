@istest
private with sharing class Batch_CPOItems_Test{
	public static Id swxRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('SWx Upsell Proposal').getRecordTypeId();
	public static Id ccreRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('CCRE Upsell Proposal').getRecordTypeId();
	public static Id swxQuoteRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal').getRecordTypeId();
	
	static testmethod void entitledCPO(){
		User sysAdminUser = TestDataFactory.createSystemAdminUser();
		System.runAs(sysAdminUser){ 
			
			//Account Creation
			List<Account> accountCreation = TestDataFactory.createAccount(1);
			database.insert(accountCreation);
			Account acc = new Account();
			acc.Name='Legal Entity Account For Test';
			acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			acc.ParentId = accountCreation[0].Id;
			acc.AccountNumber = '100006843';
			database.insert(acc);
			
			//DP Creation
			SWx_Upsell_Proposal__c upsellProposal_SWX= new SWx_Upsell_Proposal__c();
			upsellProposal_SWX.Analytics_File_Refer_ID__c='GBR-61940-82356';
			upsellProposal_SWX.Analytics_Source__c='CXM';
			upsellProposal_SWX.Proposal_Recommendation_Type__c='renewal';
			upsellProposal_SWX.P20_Id__c=215616;
			upsellProposal_SWX.CurrencyIsoCode='EUR';
			upsellProposal_SWX.Unweighted_Value__c=429052.07;
			upsellProposal_SWX.Account_ID__c = accountCreation[0].id;
			upsellProposal_SWX.RecordTypeID=swxRecordTypeId;
			upsellProposal_SWX.sold_to_party__c = acc.Id;			
			database.insert(upsellProposal_SWX);
			
			//DP Creation
			SWx_Upsell_Proposal__c upsellProposal_SWX1= new SWx_Upsell_Proposal__c();
			upsellProposal_SWX1.Analytics_File_Refer_ID__c='GBR-61940-823561';
			upsellProposal_SWX1.Analytics_Source__c='CXM';
			upsellProposal_SWX1.Proposal_Recommendation_Type__c='renewal';
			upsellProposal_SWX1.P20_Id__c=215616;
			upsellProposal_SWX1.CurrencyIsoCode='EUR';
			upsellProposal_SWX1.Unweighted_Value__c=429052.07;
			upsellProposal_SWX1.Account_ID__c = accountCreation[0].id;
	upsellProposal_SWX1.Upsell_Status__c = 'Ready For Review';
			upsellProposal_SWX1.RecordTypeID=swxRecordTypeId;
			upsellProposal_SWX1.sold_to_party__c = acc.Id;			
			database.insert(upsellProposal_SWX1);
			
			//DP Creation
			SWx_Upsell_Proposal__c upsellProposal_SWX2= new SWx_Upsell_Proposal__c();
			upsellProposal_SWX2.Analytics_File_Refer_ID__c='GBR-61940-8235611';
			upsellProposal_SWX2.Analytics_Source__c='CXM';
			upsellProposal_SWX2.Proposal_Recommendation_Type__c='renewal';
			upsellProposal_SWX2.P20_Id__c=215616;
			upsellProposal_SWX2.CurrencyIsoCode='EUR';
			upsellProposal_SWX2.Unweighted_Value__c=429052.07;
			upsellProposal_SWX2.Account_ID__c = accountCreation[0].id;
	upsellProposal_SWX2.Upsell_Status__c = 'Ready For Review';
			upsellProposal_SWX2.RecordTypeID=swxRecordTypeId;
			upsellProposal_SWX2.sold_to_party__c = acc.Id;			
			database.insert(upsellProposal_SWX2);
			
			
			//Intermediate Data Setup
			List<product2> productObj2 = TestDataFactory.productCreation(3);
			productObj2[0].ProductCode = 'RL000319.T';
			productObj2[1].ProductCode = 'RL000172.T';
			productObj2[2].ProductCode = 'RL000286.T';
			database.insert(productObj2);
			
			Apttus_Config2__ClassificationName__c category = new Apttus_Config2__ClassificationName__c();
			category.Apttus_Config2__Active__c = true;
			category.APTS_Ext_ID__c = 'ABCXYZ123436789';
			category.Apttus_Config2__HierarchyLabel__c = 'Dummy Heirarchy';
			database.insert(category);
			
			Apttus_Config2__ClassificationHierarchy__c category_hier = new Apttus_Config2__ClassificationHierarchy__c();
			category_hier.Apttus_Config2__Label__c  = 'Dummy Label';
			category_hier.Apttus_Config2__Level__c  = 2;
			category_hier.Name = 'Dummy Category Hierarchy';
			category_hier.Apttus_Config2__HierarchyId__c = category.id;
			database.insert(category_hier);
			
			Apttus_Config2__ProductClassification__c prod_classification = new Apttus_Config2__ProductClassification__c();
			prod_classification.Apttus_Config2__ClassificationId__c = category_hier.id ;
			prod_classification.Apttus_Config2__ProductId__c = productObj2[0].id;
			//prod_classification.Name = 'Dummy Prod Classification_1';
			database.insert(prod_classification);
			
			
			Apttus_Config2__ProductClassification__c prod_classification1 = new Apttus_Config2__ProductClassification__c();
			prod_classification1.Apttus_Config2__ClassificationId__c = category_hier.id ;
			prod_classification1.Apttus_Config2__ProductId__c = productObj2[1].id;
			//prod_classification.Name = 'Dummy Prod Classification_1';
			database.insert(prod_classification1);
			
			Apttus_Config2__ProductClassification__c prod_classification2 = new Apttus_Config2__ProductClassification__c();
			prod_classification2.Apttus_Config2__ClassificationId__c = category_hier.id ;
			prod_classification2.Apttus_Config2__ProductId__c = productObj2[2].id;
			//prod_classification.Name = 'Dummy Prod Classification_1';
			database.insert(prod_classification2);
			
			//Agreement
			Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c();
			agreement.Apttus__Account__c = accountCreation[0].Id;
			agreement.CurrencyIsoCode = 'EUR';
			insert agreement;
			
			Commercial_Entitlement__c  comEnt = new Commercial_Entitlement__c();
			comEnt.Product_Name__c=productObj2[0].id;
			comEnt.Sold_To_Party__c=acc.id;
			comEnt.Consumed_Quantity__c=0;
			comEnt.Authorised_Quantity__c=0; 
			comEnt.Status__c = 'Pending';
			comEnt.pending_quantity__c=50; 
			comEnt.Non_Consumed_Quantity__c = 0;
			comEnt.Parent_Account__c=accountCreation[0].Id;   
			database.insert(comEnt);  
			
			Commercial_Entitlement__c  comEnt1 = new Commercial_Entitlement__c();
			comEnt1.Product_Name__c=productObj2[1].id;
			comEnt1.Sold_To_Party__c=acc.id;
			comEnt1.Consumed_Quantity__c=0;
			comEnt1.Authorised_Quantity__c=0; 
			comEnt1.Status__c = 'Pending';
			comEnt1.pending_quantity__c=50; 
			comEnt1.Non_Consumed_Quantity__c = 0;
			comEnt1.Parent_Account__c=accountCreation[0].Id;   
			database.insert(comEnt1);  
			
			Commercial_Entitlement__c  comEnt2 = new Commercial_Entitlement__c();
			comEnt2.Product_Name__c=productObj2[2].id;
			comEnt2.Sold_To_Party__c=acc.id;
			comEnt2.Consumed_Quantity__c=0;
			comEnt2.Authorised_Quantity__c=0; 
			comEnt2.Status__c = 'Pending';
			comEnt2.pending_quantity__c=50; 
			comEnt2.Non_Consumed_Quantity__c = 0;
			comEnt2.Parent_Account__c=accountCreation[0].Id;   
			database.insert(comEnt2); 
			
			//CPO Creation
			Apttus_Config2__CustomerPurchaseOrder__c custPusrchaseOrder = new Apttus_Config2__CustomerPurchaseOrder__c();
			custPusrchaseOrder.Sold_to_party__c=acc.id;
			custPusrchaseOrder.CurrencyIsoCode='EUR';
			//custPusrchaseOrder.Legacy_cpo__c = false;
			custPusrchaseOrder.Apttus_QPConfig__ProposalId__c= custPusrchaseOrder.Apttus_CMConfig__AgreementId__c;
			custPusrchaseOrder.legacy_cpo__c = true;
			database.insert(custPusrchaseOrder);
			
			//CPO LI
			
			List<Apttus_Config2__CustomerPOItem__c> poItemList = new List<Apttus_Config2__CustomerPOItem__c>();
			Apttus_Config2__CustomerPOItem__c cpoItem = new Apttus_Config2__CustomerPOItem__c();
			cpoItem.Apttus_Config2__PurchaseOrderId__c=custPusrchaseOrder.Id;
			cpoItem.Apttus_Config2__ProductId__c=productObj2[0].id;
			cpoItem.Consumed_Quantity__c=0;
			cpoItem.Authorised_Quantity__c=0;
			cpoItem.Pending_Quantity__c=5;
			cpoItem.Non_Consumed_Quantity__c = 0;
			cpoItem.Apttus_Config2__Quantity__c = 5;
			cpoItem.Commercial_Entitlement_Status__c = 'Pending';
			cpoItem.Apttus_Config2__StartDate__c = system.today() ;
			cpoItem.Apttus_Config2__EndDate__c = system.today()+30;
			cpoItem.Quantity_Batch_Update__c = null;
			cpoItem.Commercial_Entitlement__c=comEnt.Id;
			database.insert(cpoItem);
			
			
			Apttus_Config2__CustomerPOItem__c cpoItem2 = new Apttus_Config2__CustomerPOItem__c();
			cpoItem2.Apttus_Config2__PurchaseOrderId__c=custPusrchaseOrder.Id;
			cpoItem2.Apttus_Config2__ProductId__c=productObj2[1].id;
			cpoItem2.Consumed_Quantity__c=0;
			cpoItem2.Authorised_Quantity__c=0;
			cpoItem2.Pending_Quantity__c=50;
			cpoItem2.Non_Consumed_Quantity__c = 0;
			cpoItem2.Apttus_Config2__Quantity__c = 50;
			cpoItem2.Commercial_Entitlement_Status__c = 'Pending';
			cpoItem2.Apttus_Config2__StartDate__c = system.today() ;
			cpoItem2.Apttus_Config2__EndDate__c = system.today()+30;		  
			cpoItem2.Commercial_Entitlement__c=comEnt1.Id; 
			cpoItem2.Quantity_Batch_Update__c = null;
			database.insert(cpoItem2);
			
			Apttus_Config2__CustomerPOItem__c cpoItem3 = new Apttus_Config2__CustomerPOItem__c();
			cpoItem3.Apttus_Config2__PurchaseOrderId__c=custPusrchaseOrder.Id;
			cpoItem3.Apttus_Config2__ProductId__c=productObj2[2].id;
			cpoItem3.Consumed_Quantity__c=0;
			cpoItem3.Authorised_Quantity__c=0;
			cpoItem3.Pending_Quantity__c=50;
			cpoItem3.Non_Consumed_Quantity__c = 0;
			cpoItem3.Apttus_Config2__Quantity__c = 50;
			cpoItem3.Commercial_Entitlement_Status__c = 'Pending';
			cpoItem3.Apttus_Config2__StartDate__c = system.today() ;
			cpoItem3.Apttus_Config2__EndDate__c = system.today()+30;
			cpoItem3.Quantity_Batch_Update__c = null;
			cpoItem3.Commercial_Entitlement__c=comEnt2.Id;
			database.insert(cpoItem3);
			
			//CPO Creation
			Apttus_Config2__CustomerPurchaseOrder__c custPusrchaseOrder1 = new Apttus_Config2__CustomerPurchaseOrder__c();
			custPusrchaseOrder1.Sold_to_party__c=acc.id;
			custPusrchaseOrder1.CurrencyIsoCode='EUR';
			//custPusrchaseOrder.Legacy_cpo__c = false;
			custPusrchaseOrder1.Apttus_QPConfig__ProposalId__c= custPusrchaseOrder.Apttus_CMConfig__AgreementId__c;
			custPusrchaseOrder1.legacy_cpo__c = true;
			database.insert(custPusrchaseOrder1);
			
			//CPO LI
			
			List<Apttus_Config2__CustomerPOItem__c> poItemList1 = new List<Apttus_Config2__CustomerPOItem__c>();
			Apttus_Config2__CustomerPOItem__c cpoItem1 = new Apttus_Config2__CustomerPOItem__c();
			cpoItem1.Apttus_Config2__PurchaseOrderId__c=custPusrchaseOrder1.Id;
			cpoItem1.Apttus_Config2__ProductId__c=productObj2[0].id;
			cpoItem1.Consumed_Quantity__c=0;
			cpoItem1.Authorised_Quantity__c=0;
			cpoItem1.Pending_Quantity__c=45;
			cpoItem1.Non_Consumed_Quantity__c = 0;
			cpoItem1.Apttus_Config2__Quantity__c = 45;
			cpoItem1.Commercial_Entitlement_Status__c = 'Pending';
			cpoItem1.Apttus_Config2__StartDate__c = system.today() ;
			cpoItem1.Apttus_Config2__EndDate__c = system.today()+30;
			cpoItem1.Quantity_Batch_Update__c = null;
			cpoItem1.Commercial_Entitlement__c=comEnt.Id;
			database.insert(cpoItem1);
			
			
			//SWX Items
			SWx_Upsell_Items__c SWXLineItem = new SWx_Upsell_Items__c();
			SWXLineItem.Sales_Item_Code__c=productObj2[0].Id;
			SWXLineItem.Entitlement_Status__c='Pending';
			SWXLineItem.Quantity__c=10;
			SWXLineItem.SWx_Upsell_Proposal__c  = upsellProposal_SWX.Id;
			database.insert(SWXLineItem);
		   
			SWx_Upsell_Items__c SWXLineItem1 = new SWx_Upsell_Items__c();
			SWXLineItem1.Sales_Item_Code__c=productObj2[1].Id;
			SWXLineItem1.Entitlement_Status__c='Pending';
			SWXLineItem1.Quantity__c=10;
			SWXLineItem1.SWx_Upsell_Proposal__c  = upsellProposal_SWX.Id;
			
			database.insert(SWXLineItem1);
			
			SWx_Upsell_Items__c SWXLineItem2 = new SWx_Upsell_Items__c();
			SWXLineItem2.Sales_Item_Code__c=productObj2[2].Id;
			SWXLineItem2.Entitlement_Status__c='Cannot be entitled';
			SWXLineItem2.Quantity__c=10;
			SWXLineItem2.SWx_Upsell_Proposal__c  = upsellProposal_SWX1.Id;
			
			database.insert(SWXLineItem2);

			SWx_Upsell_Items__c SWXLineItem3 = new SWx_Upsell_Items__c();
			SWXLineItem3.Sales_Item_Code__c=productObj2[2].Id;
			SWXLineItem3.Entitlement_Status__c='Cannot be entitled';
			SWXLineItem3.Quantity__c=200;
			SWXLineItem3.SWx_Upsell_Proposal__c  = upsellProposal_SWX2.Id;
			
			database.insert(SWXLineItem3);
			
			SWx_Upsell_Items__c SWXLineItem4 = new SWx_Upsell_Items__c();
			SWXLineItem4.Sales_Item_Code__c=productObj2[0].Id;
			SWXLineItem4.Entitlement_Status__c='Cannot be entitled';
			SWXLineItem4.Quantity__c=2;
			SWXLineItem4.SWx_Upsell_Proposal__c  = upsellProposal_SWX2.Id;
			database.insert(SWXLineItem4);
			
			test.startTest();
			
			Database.executebatch(new Batch_cpoitems(), 100);
			//atabase.executebatch(new Batch_DPFulfillment(lstSWXUpsellItems), 100);				
			test.stopTest();			
			
		}
		
	}   
	static testmethod void expiredCPO(){
		User sysAdminUser = TestDataFactory.createSystemAdminUser();
		System.runAs(sysAdminUser){
			
			//Account Creation
			List<Account> accountCreation = TestDataFactory.createAccount(1);
			database.insert(accountCreation);
			Account acc = new Account();
			acc.Name='Legal Entinty Account For Test';
			acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			acc.ParentId = accountCreation[0].Id;
			acc.AccountNumber = '100006843';
			database.insert(acc);
			
			//Intermediate Data Setup
			List<product2> productObj2 = TestDataFactory.productCreation(1);
			productObj2[0].ProductCode = 'RL000319.T';
			//  productObj2[1].ProductCode = 'RL000172.T';
			//   productObj2[2].ProductCode = 'RL000286.T';
			database.insert(productObj2);
			
			Apttus_Config2__ClassificationName__c category = new Apttus_Config2__ClassificationName__c();
			category.Apttus_Config2__Active__c = true;
			category.APTS_Ext_ID__c = 'ABCXYZ123436789';
			category.Apttus_Config2__HierarchyLabel__c = 'Dummy Heirarchy';
			database.insert(category);
			
			Apttus_Config2__ClassificationHierarchy__c category_hier = new Apttus_Config2__ClassificationHierarchy__c();
			category_hier.Apttus_Config2__Label__c  = 'Dummy Label';
			category_hier.Apttus_Config2__Level__c  = 2;
			category_hier.Name = 'Dummy Category Hierarchy';
			category_hier.Apttus_Config2__HierarchyId__c = category.id;
			database.insert(category_hier);
			
			Apttus_Config2__ProductClassification__c prod_classification = new Apttus_Config2__ProductClassification__c();
			prod_classification.Apttus_Config2__ClassificationId__c = category_hier.id ;
			prod_classification.Apttus_Config2__ProductId__c = productObj2[0].id;
			//prod_classification.Name = 'Dummy Prod Classification_1';
			database.insert(prod_classification);
			
			//Agreement
			Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c();
			agreement.Apttus__Account__c = accountCreation[0].Id;
			insert agreement;
			
			Commercial_Entitlement__c  comEnt = new Commercial_Entitlement__c();
			comEnt.Product_Name__c=productObj2[0].id;
			comEnt.Sold_To_Party__c=acc.id;
			comEnt.Consumed_Quantity__c=10;
			comEnt.Authorised_Quantity__c=15; 
			comEnt.Status__c = 'Entitled';
			comEnt.pending_quantity__c=0; 
			comEnt.Non_Consumed_Quantity__c = null;
			comEnt.Parent_Account__c=accountCreation[0].Id;
			
			database.insert(comEnt);
			
			//CPO Creation
			Apttus_Config2__CustomerPurchaseOrder__c custPusrchaseOrder = new Apttus_Config2__CustomerPurchaseOrder__c();
			custPusrchaseOrder.Sold_to_party__c=acc.id;
			custPusrchaseOrder.CurrencyIsoCode='EUR';
			custPusrchaseOrder.Legacy_cpo__c = false;
			custPusrchaseOrder.Apttus_QPConfig__ProposalId__c=
				custPusrchaseOrder.Apttus_CMConfig__AgreementId__c;
			custPusrchaseOrder.legacy_cpo__c = true;
			database.insert(custPusrchaseOrder);
			
			//CPO LI
			Apttus_Config2__CustomerPOItem__c cpoItem = new Apttus_Config2__CustomerPOItem__c();
			cpoItem.Apttus_Config2__PurchaseOrderId__c=custPusrchaseOrder.Id;
			cpoItem.Apttus_Config2__ProductId__c=productObj2[0].id;
			cpoItem.Consumed_Quantity__c=10;
			cpoItem.Authorised_Quantity__c=15;
			cpoItem.Pending_Quantity__c=0;
			cpoItem.Non_Consumed_Quantity__c = null;
			cpoItem.Commercial_Entitlement_Status__c = 'Entitled';
			cpoItem.Apttus_Config2__StartDate__c = system.today() -10;
			cpoItem.Apttus_Config2__EndDate__c = system.today()-1;
			
			cpoItem.Commercial_Entitlement__c=comEnt.Id;
			
			database.insert(cpoItem);
			
			test.startTest();
			DS_CPOLineItem_Scheduler schedule = new DS_CPOLineItem_Scheduler();
			schedule.execute(null );		   
			test.stopTest();												
			
		}
		
	}
}