/****************************************************
Class Name: DS_Populate_CFAttributes
Created by: Accenture
Created Date: 27 June 2019
Last modified by: Accenture
Description: Test class for DS_Populate_CFAttributes
****************************************************/

@isTest
public with sharing class DS_Populate_CFAttributesTest{

public static Id swxQuoteRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal').getRecordTypeId();   

	static testmethod void DS_Populate_CFAttributesTest(){	   
		 
		//Account Insertion
		Account accLegalEntity = TestDataFactory.createAccount(1)[0];
		accLegalEntity.AccountNumber='100006843';
		accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		database.insert(accLegalEntity);	  
		 
		Account accountCreationDP = TestDataFactory.createAccount(1)[0];
		database.insert(accountCreationDP);
		
		//DS Staging
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
	  
		DS_Staging__c stagingObjRec1 = new DS_Staging__c ();
		stagingObjRec1 .Payload_Status__c='Success';
		stagingObjRec1 .DS_Payload__c= json ;
		insert stagingObjRec1 ;
	
		// Agreement Insertion
		Apttus__APTS_Agreement__c agree = new Apttus__APTS_Agreement__c();
		agree.Apttus__Account__c = accLegalEntity.id;
		agree.Sold_to_party_number__c =accLegalEntity.id;
		insert agree;
		
		//Product Insertion
		List<Product2> prods = new List<Product2>();
		Product2 prod1 = new product2(
			Name = 'Test1', 
			ProductCode = '123', 
			Business_Group__c = 'NSW', 
			CurrencyIsoCode = 'USD',
			IsActive = true
		); 
		 insert prod1;	   
		  
		//Price List 
		Apttus_Config2__PriceList__c priceList= TestdataFactory.priceList(1)[0];
		database.insert(priceList);
		
		// PLI Record
		Apttus_Config2__PriceListItem__c PriceListItem= TestdataFactory.createPriceListItem(1,priceList)[0];
		database.insert(PriceListItem);
			   
		//opty Insertion
		Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();
		Opportunity oppty ;
		oppty = TestDataFactory.OpportunityCreation(1,accountCreationDP)[0];
		oppty.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
		oppty.RecordTypeId=RecordTypeId;
		oppty.Lead_BG__c ='MN';
		oppty.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
	   
		database.insert(oppty);
		
		//Quote Insertion	
		Apttus_Proposal__Proposal__c quoteProposal2 = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];		 
		quoteProposal2.Analytics_Source__c  = CSWXGlobalConstant.AnalyticsSource;
		quoteProposal2.DS_Staging__c = stagingObjRec1.id;
		quoteProposal2.RecordTypeId = swxQuoteRecordTypeId;
		quoteProposal2.Contract_Type_Name__c= 'Project';
		quoteProposal2.Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource;
		quoteProposal2.Apttus_Proposal__Proposal_Name__c = 'Test Data';
		quoteProposal2.Apttus_Proposal__Opportunity__c = oppty.id;
		quoteProposal2.Apttus_Proposal__Account__c  = accountCreationDP.id;
		quoteProposal2.Sold_To_Party__c =  accLegalEntity.id;
		quoteProposal2.Apttus_QPConfig__PriceListId__c  = priceList.Id;
		database.insert(quoteProposal2); 
		
		//create product configuration
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
																Name = 'APTTUS Test Config', 
																Apttus_Config2__AccountId__c = accountCreationDP.Id, 
																Apttus_Config2__PriceListId__c = priceList.Id, 
																Apttus_QPConfig__Proposald__c = quoteproposal2.Id, 
																Apttus_Config2__Status__c = 'New', 
																Apttus_Config2__VersionNumber__c = 1, 
																Apttus_Config2__EffectivePriceListId__c = priceList.Id,
																Apttus_Config2__BusinessObjectId__c = String.valueOf(quoteproposal2.Id),
																Apttus_Config2__BusinessObjectType__c = 'Proposal');
		insert ProdConfig;
		
		//Create Line Items
		list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();
		Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
										Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
										Apttus_Config2__ItemSequence__c = 1,  
										Apttus_Config2__LineStatus__c='New',
										Apttus_Config2__PriceListId__c = priceList.id,
										Apttus_Config2__ChargeType__c = 'Standard Price', 
										Apttus_Config2__LineType__c = 'Product/Service',
										Apttus_Config2__ProductId__c = prod1.Id,
										Apttus_Config2__PriceListItemId__c = pricelistitem.id,
										Apttus_Config2__PriceMethod__c = 'Per Unit',
										Apttus_Config2__Frequency__c = 'One Time',
										Apttus_Config2__ListPrice__c = 100,
										Apttus_Config2__LineNumber__c = 1.0,
										Apttus_Config2__Quantity__c = 1,
										Apttus_Config2__PrimaryLineNumber__c = 1,
										Apttus_Config2__ShipToAccountId__c = accountCreationDP.Id,
										Apttus_Config2__AddedBy__c = 'added by code' );
		allLineItems.add(LineItem1);
		insert allLineItems;
		 
		//Attributes  
		map<Integer,List<Sobject>> Line_AttrMap=new map<Integer,List<Sobject>>();
		List<Sobject> ds_sobj = new List<SObject>();
		Customer_facing_Attribute__c ds_attr = new Customer_facing_Attribute__c(Attribute_Name__c='Use Case', Attribute_Label__c='Use Case',Attribute_Value__c='energy efficiency', Attribute_Visibility__c='yes');
		Sobject dsobj = (SObject) ds_attr;
		ds_sobj.add(dsobj);
		Line_Attrmap.put(1,ds_Sobj);
		Customer_facing_Attribute__c ds_attr1 = new Customer_facing_Attribute__c(Attribute_Name__c='Technology', Attribute_Label__c='Technology',Attribute_Value__c='FDD LTE', Attribute_Visibility__c='yes');
		Sobject dsobj1 = (SObject) ds_attr1;
		ds_sobj.add(dsobj1);
		Line_Attrmap.put(1,ds_Sobj); 
		 
		Apttus_Config2__CustomerPurchaseOrder__c cpoRecord = new Apttus_Config2__CustomerPurchaseOrder__c();
		cpoRecord.Sold_to_party__c = accLegalEntity.id;
		cpoRecord.Opportunity__c =oppty.id;
		cpoRecord.Contract_start_date__c = system.today();
		cpoRecord.Contract_end_date__c=system.today()+365;
		cpoRecord.Terms__c = 12;
		cpoRecord.WBS__c='Test_WBS';
		cpoRecord.Legacy_CPO__c=true;
		cpoRecord.Apttus_QPConfig__ProposalId__c =quoteProposal2.id;
		
		database.insert(cpoRecord);
		List<Apttus_Config2__CustomerPurchaseOrder__c> cpoList = new List<Apttus_Config2__CustomerPurchaseOrder__c>();
		cpolist.add(cpoRecord);
		Apttus_Proposal__Proposal_Line_Item__c QuoteLI = new Apttus_Proposal__Proposal_Line_Item__c();
		QuoteLI.Apttus_Proposal__Proposal__c = quoteProposal2.id;
		QuoteLI.Apttus_QPConfig__ItemSequence__c = 1;
		QuoteLI.Apttus_QPConfig__LineNumber__c =1;
		insert QuoteLI;
		List<Apttus_Proposal__Proposal__c> qpList = new List<Apttus_Proposal__Proposal__c>();
		qplist.add(quoteproposal2);
		 
	   
		Apttus_Config2__CustomerPOItem__c cpoItem = new Apttus_Config2__CustomerPOItem__c();
		List<Apttus_Config2__CustomerPOItem__c> cpoItemList = new List<Apttus_Config2__CustomerPOItem__c>();
		cpoItem.Apttus_Config2__PurchaseOrderId__c  = cpoRecord.id;
		cpoItem.Apttus_QPConfig__ProposalLineItemId__c = QuoteLi.id;
		cpoItem.Apttus_Config2__ProductId__c  = prod1.id;
		cpoItem.Apttus_Config2__StartDate__c=Date.today()+5;
		cpoItem.Apttus_Config2__EndDate__c=system.today()+365;
		database.insert(cpoItem);
		cpoitemlist.add(cpoItem);
		 
		Test.startTest();
		DS_Populate_CFAttributes.createCFAforQuote(ds_sobj, qpList);
		DS_Populate_CFAttributes.createCFAforConfigItem(Line_AttrMap, qpList);
		DS_Populate_CFAttributes.updateCFAforCPO(cpolist,cpoitemlist);
		Test.stopTest(); 
	  
	}
}