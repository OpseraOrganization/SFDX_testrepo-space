/****************************************
* Name : CPOTriggerHelperTest
* Author : Accenture 

*****************************************/
@isTest
public class CPOTriggerHelperTest {
	
	 public static Id swxRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('SWx Upsell Proposal').getRecordTypeId();
   public static Id ccreRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('CCRE Upsell Proposal').getRecordTypeId();
	public static Id swxQuoteRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal').getRecordTypeId();
/****************************************
* Method Name : createEntitlementTest
* Author : Accenture

*****************************************/
	/*public static testmethod void createEntitlementTest(){
		//Test.startTest();
		List <Apttus_Config2__CustomerPurchaseOrder__c> cpolist = new List<Apttus_Config2__CustomerPurchaseOrder__c>();
		test.startTest();
		Account soldtopartyAcc =  TestDataFactory.createAccount(1)[0];
		//soldtopartyAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		database.insert(soldtopartyAcc);
		
		Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();
		//creating user
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		Opportunity oppty;
		insert userCreation;
		system.runAs(userCreation){
		oppty = TestDataFactory.OpportunityCreation(1,soldtopartyAcc)[0];
		oppty.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
		oppty.RecordTypeId=RecordTypeId;
		oppty.Lead_BG__c ='MN';
		oppty.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
		//insert new File_Sharing_Custom_Setting__c(Name = GlobalConstants.OPPORTUNITY_DOC_FREEZE_STAGE,Value__c='7');
		database.insert(oppty);
		}
		/
		Apttus_Config2__PriceList__c priceList= TestdataFactory.priceList(1)[0];
		database.insert(priceList);
		
		Apttus_Config2__PriceListItem__c PriceListItem= TestdataFactory.createPriceListItem(1,priceList)[0];
		database.insert(PriceListItem);
		/
		SWx_Upsell_Proposal__c upsellProposal_SWX=TestDataFactory.upsellList(1,soldtopartyAcc)[0];
		upsellProposal_SWX.Analytics_File_Refer_ID__c='GBR-61940-82356';
		upsellProposal_SWX.Analytics_Source__c='CXM';
		upsellProposal_SWX.Proposal_Recommendation_Type__c='renewal';
		upsellProposal_SWX.P20_Id__c=215616;
		upsellProposal_SWX.CurrencyIsoCode='EUR';
		upsellProposal_SWX.Unweighted_Value__c=429052.07;
		upsellProposal_SWX.Account_ID__c=soldtopartyAcc.Id;
		upsellProposal_SWX.Sold_To_Party__c = soldtopartyAcc.Id;
		upsellProposal_SWX.RecordTypeID=swxRecordTypeId;
	// upsellProposal_SWX.Sold_To_Party__c = accountCreationDP.Id;
		database.insert(upsellProposal_SWX);
		
		/set<ID> upsellproposalId_SWX= new set<Id>();
		upsellproposalId_SWX.add(upsellProposal_SWX.Id);
		
		List<SWx_Upsell_Items__c> lstSWXUpsellItems = TestDataFactory.createSWXLineItems(upsellproposalId_SWX,1);
		database.insert(lstSWXUpsellItems);
		
		
		Apttus_Proposal__Proposal__c quoteProposal1 = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
		quoteProposal1.Apttus_Proposal__Opportunity__c = oppty.id; 
		quoteProposal1.Apttus_QPConfig__PriceListId__c = priceList.Id;
		quoteProposal1.NokiaCPQ_Portfolio__c = 'IP Routing';
		quoteProposal1.NokiaCPQ_SSP_Level__c = 'Unlimited';
		quoteProposal1.SWx_Upsell_Proposal__c=upsellProposal_SWX.Id;
		quoteProposal1.Analytics_Source__c  = CSWXGlobalConstant.AnalyticsSource;
		quoteProposal1.RecordTypeId = swxQuoteRecordTypeId;
		quoteProposal1.Apttus_Proposal__Account__c=accountCreationDP.id;
		
		database.insert(quoteProposal1); 
		quoteProposal1.Apttus_Proposal__Approval_Stage__c='In Review';
		update quoteProposal1;
		/   
		Apttus_Proposal__Proposal__c quoteProposal2 = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
		quoteProposal2.Apttus_Proposal__Opportunity__c = oppty.id; 
		//quoteProposal2.Apttus_QPConfig__PriceListId__c = priceList.Id;
		quoteProposal2.NokiaCPQ_Portfolio__c = 'IP Routing';
		quoteProposal2.NokiaCPQ_SSP_Level__c = 'Unlimited';
		quoteProposal2.SWx_Upsell_Proposal__c=upsellProposal_SWX.Id;
		quoteProposal2.Analytics_Source__c  = CSWXGlobalConstant.AnalyticsSource;
		quoteProposal2.RecordTypeId = swxQuoteRecordTypeId;
		quoteProposal2.Prices_Aligned__c=true;
		quoteProposal2.Apttus_Proposal__Account__c=soldtopartyAcc.id;
		database.insert(quoteProposal2); 
		quoteProposal2.Apttus_Proposal__Approval_Stage__c='Accepted';
		update quoteProposal2;   
		/
		Map<Id,Apttus_Proposal__Proposal__c > oldrecords = new Map<Id,Apttus_Proposal__Proposal__c >();
		oldrecords.put(quoteProposal1.id, quoteProposal1);
		List<Apttus_Proposal__Proposal__c> quoteProposalList=new List<Apttus_Proposal__Proposal__c>();
		quoteProposalList.add(quoteProposal2);
			
		Test.startTest();
		CCREProposalTriggerHandler.updateQuoteShare(quoteProposalList,oldrecords);
		Test.stopTest();
		/
		Apttus_Config2__PaymentTerm__c payTerms = new Apttus_Config2__PaymentTerm__c();
		payTerms.Name='testPT';
		payTerms.Apttus_Config2__Sequence__c = 2;
		payTerms.Apttus_Config2__Label__c = 'Due Upon Receipt';
		database.insert(payTerms);
		
		Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c();
		agreement.Name= 'test Agreement';
		agreement.Apttus__Account__c = soldtopartyAcc.id;
		agreement.CurrencyIsoCode = 'EUR';
		
		Apttus_Config2__CustomerPurchaseOrder__c cpoRecord = new Apttus_Config2__CustomerPurchaseOrder__c();
		cpoRecord.Sold_to_party__c = soldtopartyAcc.id;
		cpoRecord.Opportunity__c =oppty.id;
		cpoRecord.Contract_start_date__c = system.today();
		cpoRecord.Contract_end_date__c=system.today()+365;
		cpoRecord.Terms__c = 12;
		cpoRecord.WBS__c='Test_WBS';
		cpoRecord.Legacy_CPO__c=true;
		cpoRecord.Apttus_QPConfig__ProposalId__c =quoteProposal2.id;
		
		database.insert(cpoRecord);
		cpoRecord.Apttus_Config2__Status__c = 'Ready for Enrichment';
		database.update(cpoRecord);
		
		Apttus_Config2__CustomerPurchaseOrder__c cpoRecord1 = new Apttus_Config2__CustomerPurchaseOrder__c();
		cpoRecord1.Sold_to_party__c = soldtopartyAcc.id;
		cpoRecord1.Payer__c = soldtopartyAcc.id;
		cpoRecord.Contract_start_date__c = system.today();
		cpoRecord.Contract_end_date__c=system.today()+365;
		cpoRecord.Terms__c = 12;
		cpoRecord.WBS__c='Test_WBS';
		cpoRecord1.Apttus_Config2__BillToAccountId__c = soldtopartyAcc.id;
		cpoRecord1.Apttus_Config2__ShipToAccountId__c = soldtopartyAcc.id;
		cpoRecord1.Sales_Org__c = 'Test';
		cpoRecord1.Sales_Office__c = 'Test';
		cpoRecord1.Sales_Group__c = 'Test';
		cpoRecord1.Distribution_Channel__c = 'Test';
		cpoRecord1.Division__c = 'Test';
		cpoRecord1.Apttus_QPConfig__ProposalId__c = quoteProposal2.id;
		//cpoRecord1.Grand_Total__c = 230;
		cpoRecord1.CurrencyIsoCode ='EUR';
		cpoRecord1.Apttus_CMConfig__AgreementId__c = agreement.Id;
		cpoRecord1.PO_number__c = '12564';
		cpoRecord1.Apttus_Config2__PODate__c =system.today();
		cpoRecord1.Comments__c = 'test';
		cpoRecord1.Contract_Type_Name__c ='Contract';
		cpoRecord1.Business_category__c = '2G';
		cpoRecord1.Reporting__c ='Excl contr from OBL';
		cpoRecord1.Master_contract__c = 'NA';
		cpoRecord1.ERP__c = 'P20';		
		cpoRecord1.Opportunity__c =oppty.id;
		cpoRecord1.Legacy_CPO__c=true;
		database.insert(cpoRecord1);
		
		 Apttus_Config2__CustomerPOItem__c cpoItem = new Apttus_Config2__CustomerPOItem__c();
		cpoItem.Apttus_Config2__PurchaseOrderId__c  = cpoRecord1.id;
		cpoItem.Apttus_Config2__StartDate__c=system.today();
		cpoItem.Apttus_Config2__EndDate__c=system.today()+365;
		database.insert(cpoItem);
		
		Apttus_Config2__CustomerPOItem__c cpoItem1 = new Apttus_Config2__CustomerPOItem__c();
		cpoItem1.Apttus_Config2__PurchaseOrderId__c  = cpoRecord1.id;
		cpoItem1.Apttus_Config2__StartDate__c=system.today()-1;
		cpoItem1.Apttus_Config2__EndDate__c=system.today()+365;
		database.insert(cpoItem1);

		cpoRecord1.Apttus_Config2__Status__c = 'Ready for Execution';
		database.update(cpoRecord1);
		
	
		
		 Map<Id,Apttus_Config2__CustomerPurchaseOrder__c > oldrecords = new Map<Id,Apttus_Config2__CustomerPurchaseOrder__c >();
		oldrecords.put(cpoRecord.id, cpoRecord);
		List<Apttus_Config2__CustomerPurchaseOrder__c> cpoNewList=new List<Apttus_Config2__CustomerPurchaseOrder__c>();
		cpoNewList.add(cpoRecord1);
		
		
	  // CPOTriggerHandler.createEntitlement(cpoNewList,oldrecords);
		test.stopTest();
		
	}*/
	
	public static testmethod void createEntitlementTest1(){
		 //Test.startTest();
		List <Apttus_Config2__CustomerPurchaseOrder__c> cpolist = new List<Apttus_Config2__CustomerPurchaseOrder__c>();
		
	 Account accountCreationDP = TestDataFactory.createAccount(1)[0];
			database.insert(accountCreationDP);
		 
		Account soldtopartyAcc =  TestDataFactory.createAccount(1)[0];
		 soldtopartyAcc.ParentId=accountCreationDP.id;

		//soldtopartyAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		database.insert(soldtopartyAcc);
		
		Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();
		//creating user
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		Opportunity oppty;
		insert userCreation;
		system.runAs(userCreation){
		oppty = TestDataFactory.OpportunityCreation(1,soldtopartyAcc)[0];
		oppty.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
		oppty.RecordTypeId=RecordTypeId;
		oppty.Lead_BG__c ='MN';
		oppty.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
		//insert new File_Sharing_Custom_Setting__c(Name = GlobalConstants.OPPORTUNITY_DOC_FREEZE_STAGE,Value__c='7');
		database.insert(oppty);
		}
		
		SWx_Upsell_Proposal__c upsellProposal_SWX=TestDataFactory.upsellList(1,soldtopartyAcc)[0];
		upsellProposal_SWX.Analytics_File_Refer_ID__c='GBR-61940-82356';
		upsellProposal_SWX.Analytics_Source__c='CXM';
		upsellProposal_SWX.Proposal_Recommendation_Type__c='renewal';
		upsellProposal_SWX.P20_Id__c=215616;
		upsellProposal_SWX.CurrencyIsoCode='EUR';
		upsellProposal_SWX.Unweighted_Value__c=429052.07;
		upsellProposal_SWX.Account_ID__c=soldtopartyAcc.Id;
		upsellProposal_SWX.Sold_To_Party__c = soldtopartyAcc.Id;
		upsellProposal_SWX.RecordTypeID=swxRecordTypeId;
	// upsellProposal_SWX.Sold_To_Party__c = accountCreationDP.Id;
		database.insert(upsellProposal_SWX);
		
	
		Apttus_Proposal__Proposal__c quoteProposal2 = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
		quoteProposal2.Apttus_Proposal__Opportunity__c = oppty.id; 
		//quoteProposal2.Apttus_QPConfig__PriceListId__c = priceList.Id;
		quoteProposal2.NokiaCPQ_Portfolio__c = 'IP Routing';
		quoteProposal2.NokiaCPQ_SSP_Level__c = 'Unlimited';
		quoteProposal2.SWx_Upsell_Proposal__c=upsellProposal_SWX.Id;
		quoteProposal2.Analytics_Source__c  = CSWXGlobalConstant.AnalyticsSource;
		quoteProposal2.RecordTypeId = swxQuoteRecordTypeId;
		quoteProposal2.Prices_Aligned__c=true;
		quoteProposal2.Apttus_Proposal__Account__c=soldtopartyAcc.id;
		database.insert(quoteProposal2); 
		quoteProposal2.Apttus_Proposal__Approval_Stage__c='Accepted';
		update quoteProposal2;   
	  
		Apttus_Config2__PaymentTerm__c payTerms = new Apttus_Config2__PaymentTerm__c();
		payTerms.Name='testPT';
		payTerms.Apttus_Config2__Sequence__c = 2;
		payTerms.Apttus_Config2__Label__c = 'Due Upon Receipt';
		database.insert(payTerms);
		
		Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c();
		agreement.Name= 'test Agreement';
		agreement.Apttus__Account__c = soldtopartyAcc.id;
		agreement.CurrencyIsoCode = 'EUR';
		
		Apttus_Config2__CustomerPurchaseOrder__c cpoRecord = new Apttus_Config2__CustomerPurchaseOrder__c();
		cpoRecord.Sold_to_party__c = soldtopartyAcc.id;
		cpoRecord.Opportunity__c =oppty.id;
		cpoRecord.Contract_start_date__c = system.today();
		cpoRecord.Contract_end_date__c=system.today()+365;
		cpoRecord.Terms__c = 12;
		cpoRecord.WBS__c='Test_WBS';
		cpoRecord.Legacy_CPO__c=true;
		cpoRecord.Apttus_QPConfig__ProposalId__c =quoteProposal2.id;
		cpoRecord.Apttus_Config2__Status__c = 'Ready for Enrichment';	
		//database.insert(cpoRecord);
		
		//database.update(cpoRecord);
		test.startTest();
	Product2 product = TestDataFactory.productCreation(1)[0];
			product.ProductCode = '151421';
			//database.insert(product);
	Product2 product1 = TestDataFactory.productCreation(1)[0];
			product1.ProductCode = '151424';
		 database.insert(new List<Product2>{product,product1});
		 
		 Commercial_Entitlement__c commercialEntitlement = new Commercial_Entitlement__c();
	 commercialEntitlement.Parent_Account__c = accountCreationDP.Id;
		 commercialEntitlement.Sold_To_Party__c = soldtopartyAcc.id;
		 commercialEntitlement.Authorised_Quantity__c = 5;
			commercialEntitlement.Product_Name__c = product.id;
			database.insert(commercialEntitlement);
		 
		Apttus_Config2__CustomerPurchaseOrder__c cpoRecord1 = new Apttus_Config2__CustomerPurchaseOrder__c();
		cpoRecord1.Sold_to_party__c = soldtopartyAcc.id;
		cpoRecord1.Payer__c = soldtopartyAcc.id;
		cpoRecord.Contract_start_date__c = system.today();
		cpoRecord.Contract_end_date__c=system.today()+365;
		cpoRecord.Terms__c = 12;
		cpoRecord.WBS__c='Test_WBS';
		cpoRecord1.Apttus_Config2__BillToAccountId__c = soldtopartyAcc.id;
		cpoRecord1.Apttus_Config2__ShipToAccountId__c = soldtopartyAcc.id;
		cpoRecord1.Sales_Org__c = 'Test';
		cpoRecord1.Sales_Office__c = 'Test';
		cpoRecord1.Sales_Group__c = 'Test';
		cpoRecord1.Distribution_Channel__c = 'Test';
		cpoRecord1.Division__c = 'Test';
		cpoRecord1.Apttus_QPConfig__ProposalId__c = quoteProposal2.id;
		//cpoRecord1.Grand_Total__c = 230;
		cpoRecord1.CurrencyIsoCode ='EUR';
		cpoRecord1.Apttus_CMConfig__AgreementId__c = agreement.Id;
		cpoRecord1.PO_number__c = '12564';
		cpoRecord1.Apttus_Config2__PODate__c =system.today();
		cpoRecord1.Comments__c = 'test';
		cpoRecord1.Contract_Type_Name__c ='Contract';
		cpoRecord1.Business_category__c = '2G';
		cpoRecord1.Reporting__c ='Excl contr from OBL';
		cpoRecord1.Master_contract__c = 'NA';
		cpoRecord1.ERP__c = 'P20';
		cpoRecord1.Legacy_CPO__c=true;		
		cpoRecord1.Opportunity__c =oppty.id;
		 database.insert(new List<Apttus_Config2__CustomerPurchaseOrder__c>{cpoRecord,cpoRecord1});
	
		 
		 Apttus_Config2__CustomerPOItem__c cpoItem = new Apttus_Config2__CustomerPOItem__c();
		cpoItem.Apttus_Config2__PurchaseOrderId__c  = cpoRecord1.id;
		 cpoItem.Apttus_Config2__ProductId__c  = product.id;
		 //  cpoItem.Apttus_Config2__Quantity__c  = 3;
		cpoItem.Apttus_Config2__StartDate__c=system.today();
		cpoItem.Apttus_Config2__EndDate__c=system.today()+365;
		database.insert(cpoItem);
		
	  //  cpoRecord1.Apttus_Config2__Status__c = 'Ready for Execution';
		database.update(cpoRecord1);
		
	
		
		 Map<Id,Apttus_Config2__CustomerPurchaseOrder__c > oldrecords = new Map<Id,Apttus_Config2__CustomerPurchaseOrder__c >();
		oldrecords.put(cpoRecord.id, cpoRecord);
		List<Apttus_Config2__CustomerPurchaseOrder__c> cpoNewList=new List<Apttus_Config2__CustomerPurchaseOrder__c>();
		cpoNewList.add(cpoRecord1);
		 cpoNewList.add(cpoRecord1); 
		
		
	CPOTriggerHelper.createEntitlement(null);
		 CPOTriggerHelper.createEntitlement(cpoNewList);  
	 commercialEntitlement.Product_Name__c = product1.id;
			database.update(commercialEntitlement);
	 CPOTriggerHelper.createEntitlement(cpoNewList); 
		 
		 cpoItem.Apttus_Config2__StartDate__c=system.today()-1;
		database.update(cpoItem);
		CPOTriggerHelper.createEntitlement(cpoNewList);  
		test.stopTest();
	}
	 public static testmethod void createEntitlementTest3(){
		 Test.startTest();
		List <Apttus_Config2__CustomerPurchaseOrder__c> cpolist = new List<Apttus_Config2__CustomerPurchaseOrder__c>();
		
	 Account accountCreationDP = TestDataFactory.createAccount(1)[0];
			database.insert(accountCreationDP);
		 
		Account soldtopartyAcc =  TestDataFactory.createAccount(1)[0];
		 soldtopartyAcc.ParentId=accountCreationDP.id;

		//soldtopartyAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		database.insert(soldtopartyAcc);
		
		Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();
		//creating user
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		Opportunity oppty;
		insert userCreation;
		system.runAs(userCreation){
		oppty = TestDataFactory.OpportunityCreation(1,soldtopartyAcc)[0];
		oppty.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
		oppty.RecordTypeId=RecordTypeId;
		oppty.Lead_BG__c ='MN';
		oppty.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
		//insert new File_Sharing_Custom_Setting__c(Name = GlobalConstants.OPPORTUNITY_DOC_FREEZE_STAGE,Value__c='7');
		database.insert(oppty);
		}
		
		SWx_Upsell_Proposal__c upsellProposal_SWX=TestDataFactory.upsellList(1,soldtopartyAcc)[0];
		upsellProposal_SWX.Analytics_File_Refer_ID__c='GBR-61940-82356';
		upsellProposal_SWX.Analytics_Source__c='CXM';
		upsellProposal_SWX.Proposal_Recommendation_Type__c='renewal';
		upsellProposal_SWX.P20_Id__c=215616;
		upsellProposal_SWX.CurrencyIsoCode='EUR';
		upsellProposal_SWX.Unweighted_Value__c=429052.07;
		upsellProposal_SWX.Account_ID__c=soldtopartyAcc.Id;
		upsellProposal_SWX.Sold_To_Party__c = soldtopartyAcc.Id;
		upsellProposal_SWX.RecordTypeID=swxRecordTypeId;
	// upsellProposal_SWX.Sold_To_Party__c = accountCreationDP.Id;
		database.insert(upsellProposal_SWX);
		
	
		Apttus_Proposal__Proposal__c quoteProposal2 = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
		quoteProposal2.Apttus_Proposal__Opportunity__c = oppty.id; 
		//quoteProposal2.Apttus_QPConfig__PriceListId__c = priceList.Id;
		quoteProposal2.NokiaCPQ_Portfolio__c = 'IP Routing';
		quoteProposal2.NokiaCPQ_SSP_Level__c = 'Unlimited';
		quoteProposal2.SWx_Upsell_Proposal__c=upsellProposal_SWX.Id;
		quoteProposal2.Analytics_Source__c  = CSWXGlobalConstant.AnalyticsSource;
		quoteProposal2.RecordTypeId = swxQuoteRecordTypeId;
		quoteProposal2.Prices_Aligned__c=true;
		quoteProposal2.Apttus_Proposal__Account__c=soldtopartyAcc.id;
		database.insert(quoteProposal2); 
		quoteProposal2.Apttus_Proposal__Approval_Stage__c='Accepted';
		update quoteProposal2;   
	  
		Apttus_Config2__PaymentTerm__c payTerms = new Apttus_Config2__PaymentTerm__c();
		payTerms.Name='testPT';
		payTerms.Apttus_Config2__Sequence__c = 2;
		payTerms.Apttus_Config2__Label__c = 'Due Upon Receipt';
		database.insert(payTerms);
		
		Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c();
		agreement.Name= 'test Agreement';
		agreement.Apttus__Account__c = soldtopartyAcc.id;
		agreement.CurrencyIsoCode = 'EUR';
		
		Apttus_Config2__CustomerPurchaseOrder__c cpoRecord = new Apttus_Config2__CustomerPurchaseOrder__c();
		cpoRecord.Sold_to_party__c = soldtopartyAcc.id;
		cpoRecord.Opportunity__c =oppty.id;
		cpoRecord.Contract_start_date__c = system.today();
		cpoRecord.Contract_end_date__c=system.today()+365;
		cpoRecord.Terms__c = 12;
		cpoRecord.WBS__c='Test_WBS';
		cpoRecord.Legacy_CPO__c=true;
		cpoRecord.Apttus_QPConfig__ProposalId__c = quoteProposal2.id;
		cpoRecord.Apttus_Config2__Status__c = 'Ready for Enrichment';
		//database.insert(cpoRecord);
		
		//database.update(cpoRecord); 
		
	Product2 product = TestDataFactory.productCreation(1)[0];
			product.ProductCode = '151421';
			//database.insert(product);
	Product2 product1 = TestDataFactory.productCreation(1)[0];
			product1.ProductCode = '151424';
		 database.insert(new List<Product2>{product,product1});
		 
		 Commercial_Entitlement__c commercialEntitlement = new Commercial_Entitlement__c();
	 commercialEntitlement.Parent_Account__c = accountCreationDP.Id;
		 commercialEntitlement.Sold_To_Party__c = soldtopartyAcc.id;
		 commercialEntitlement.Authorised_Quantity__c = 5;
			commercialEntitlement.Product_Name__c = product.id;
			database.insert(commercialEntitlement);
		 
		Apttus_Config2__CustomerPurchaseOrder__c cpoRecord1 = new Apttus_Config2__CustomerPurchaseOrder__c();
		cpoRecord1.Sold_to_party__c = soldtopartyAcc.id;
		cpoRecord1.Payer__c = soldtopartyAcc.id;
		cpoRecord.Contract_start_date__c = system.today();
		cpoRecord.Contract_end_date__c=system.today()+365;
		cpoRecord.Terms__c = 12;
		cpoRecord.WBS__c='Test_WBS';
		cpoRecord1.Apttus_Config2__BillToAccountId__c = soldtopartyAcc.id;
		cpoRecord1.Apttus_Config2__ShipToAccountId__c = soldtopartyAcc.id;
		cpoRecord1.Sales_Org__c = 'Test';
		cpoRecord1.Sales_Office__c = 'Test';
		cpoRecord1.Sales_Group__c = 'Test';
		cpoRecord1.Distribution_Channel__c = 'Test';
		cpoRecord1.Division__c = 'Test';
		cpoRecord1.Apttus_QPConfig__ProposalId__c = quoteProposal2.id;
		//cpoRecord1.Grand_Total__c = 230;
		cpoRecord1.CurrencyIsoCode ='EUR';
		cpoRecord1.Apttus_CMConfig__AgreementId__c = agreement.Id;
		cpoRecord1.PO_number__c = '12564';
		cpoRecord1.Apttus_Config2__PODate__c =system.today();
		cpoRecord1.Comments__c = 'test';
		cpoRecord1.Contract_Type_Name__c ='Contract';
		cpoRecord1.Business_category__c = '2G';
		cpoRecord1.Reporting__c ='Excl contr from OBL';
		cpoRecord1.Master_contract__c = 'NA';
		cpoRecord1.Legacy_CPO__c=true;
		cpoRecord1.ERP__c = 'P20';		
		cpoRecord1.Opportunity__c =oppty.id;
		 database.insert(new List<Apttus_Config2__CustomerPurchaseOrder__c>{cpoRecord,cpoRecord1});
	
		//cpoRecord1.Apttus_Config2__Status__c = 'Ready for Execution';
	// database.update(cpoRecord1);		 
		 Apttus_Config2__CustomerPOItem__c cpoItem = new Apttus_Config2__CustomerPOItem__c();
		cpoItem.Apttus_Config2__PurchaseOrderId__c  = cpoRecord1.id;
		 cpoItem.Apttus_Config2__ProductId__c  = product.id;
		cpoItem.Apttus_Config2__StartDate__c=Date.today()+5;
		cpoItem.Apttus_Config2__EndDate__c=system.today()+365;
		database.insert(cpoItem);
		
	
		
	
		
		 Map<Id,Apttus_Config2__CustomerPurchaseOrder__c > oldrecords = new Map<Id,Apttus_Config2__CustomerPurchaseOrder__c >();
		oldrecords.put(cpoRecord.id, cpoRecord);
		List<Apttus_Config2__CustomerPurchaseOrder__c> cpoNewList=new List<Apttus_Config2__CustomerPurchaseOrder__c>();
		cpoNewList.add(cpoRecord1);
		 cpoNewList.add(cpoRecord); 
		
		
	CPOTriggerHelper.createEntitlement(null);
		 CPOTriggerHelper.createEntitlement(cpoNewList);  
	 test.stopTest();
	}
	  public static testmethod void createEntitlementTest2(){
		 //Test.startTest();
		List <Apttus_Config2__CustomerPurchaseOrder__c> cpolist = new List<Apttus_Config2__CustomerPurchaseOrder__c>();
		
	 Account accountCreationDP = TestDataFactory.createAccount(1)[0];
			database.insert(accountCreationDP);
		 
		Account soldtopartyAcc =  TestDataFactory.createAccount(1)[0];
		 soldtopartyAcc.ParentId=accountCreationDP.id;

		//soldtopartyAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		database.insert(soldtopartyAcc);
		
		Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();
		//creating user
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		Opportunity oppty;
		insert userCreation;
		system.runAs(userCreation){
		oppty = TestDataFactory.OpportunityCreation(1,soldtopartyAcc)[0];
		oppty.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
		oppty.RecordTypeId=RecordTypeId;
		oppty.Lead_BG__c ='MN';
		oppty.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
		//insert new File_Sharing_Custom_Setting__c(Name = GlobalConstants.OPPORTUNITY_DOC_FREEZE_STAGE,Value__c='7');
		database.insert(oppty);
		}
		
		SWx_Upsell_Proposal__c upsellProposal_SWX=TestDataFactory.upsellList(1,soldtopartyAcc)[0];
		upsellProposal_SWX.Analytics_File_Refer_ID__c='GBR-61940-82356';
		upsellProposal_SWX.Analytics_Source__c='CXM';
		upsellProposal_SWX.Proposal_Recommendation_Type__c='renewal';
		upsellProposal_SWX.P20_Id__c=215616;
		upsellProposal_SWX.CurrencyIsoCode='EUR';
		upsellProposal_SWX.Unweighted_Value__c=429052.07;
		upsellProposal_SWX.Account_ID__c=soldtopartyAcc.Id;
		upsellProposal_SWX.Sold_To_Party__c = soldtopartyAcc.Id;
		upsellProposal_SWX.RecordTypeID=swxRecordTypeId;
	// upsellProposal_SWX.Sold_To_Party__c = accountCreationDP.Id;
		database.insert(upsellProposal_SWX);
		
	
		Apttus_Proposal__Proposal__c quoteProposal2 = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
		quoteProposal2.Apttus_Proposal__Opportunity__c = oppty.id; 
		//quoteProposal2.Apttus_QPConfig__PriceListId__c = priceList.Id;
		quoteProposal2.NokiaCPQ_Portfolio__c = 'IP Routing';
		quoteProposal2.NokiaCPQ_SSP_Level__c = 'Unlimited';
		quoteProposal2.SWx_Upsell_Proposal__c=upsellProposal_SWX.Id;
		quoteProposal2.Analytics_Source__c  = CSWXGlobalConstant.AnalyticsSource;
		quoteProposal2.RecordTypeId = swxQuoteRecordTypeId;
		quoteProposal2.Prices_Aligned__c=true;
		quoteProposal2.Apttus_Proposal__Account__c=soldtopartyAcc.id;
		database.insert(quoteProposal2); 
		quoteProposal2.Apttus_Proposal__Approval_Stage__c='Accepted';
		update quoteProposal2;   
	  
		Apttus_Config2__PaymentTerm__c payTerms = new Apttus_Config2__PaymentTerm__c();
		payTerms.Name='testPT';
		payTerms.Apttus_Config2__Sequence__c = 2;
		payTerms.Apttus_Config2__Label__c = 'Due Upon Receipt';
		database.insert(payTerms);
		
		Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c();
		agreement.Name= 'test Agreement';
		agreement.Apttus__Account__c = soldtopartyAcc.id;
		agreement.CurrencyIsoCode = 'EUR';
		
		Apttus_Config2__CustomerPurchaseOrder__c cpoRecord = new Apttus_Config2__CustomerPurchaseOrder__c();
		cpoRecord.Sold_to_party__c = soldtopartyAcc.id;
		cpoRecord.Opportunity__c =oppty.id;
		cpoRecord.Contract_start_date__c = system.today();
		cpoRecord.Contract_end_date__c=system.today()+365;
		cpoRecord.Terms__c = 12;
		cpoRecord.WBS__c='Test_WBS';
		cpoRecord.Legacy_CPO__c=true;
		cpoRecord.Apttus_QPConfig__ProposalId__c = quoteProposal2.Id;
		
		database.insert(cpoRecord);
		cpoRecord.Apttus_Config2__Status__c = 'Ready for Enrichment';
		database.update(cpoRecord);
		
	Product2 product = TestDataFactory.productCreation(1)[0];
			product.ProductCode = '151421';
			database.insert(product);
		 
		 Commercial_Entitlement__c commercialEntitlement = new Commercial_Entitlement__c();
	 commercialEntitlement.Parent_Account__c = accountCreationDP.Id;
		 commercialEntitlement.Sold_To_Party__c = soldtopartyAcc.id;
		 commercialEntitlement.Authorised_Quantity__c = 5;
			commercialEntitlement.Product_Name__c = product.id;
			database.insert(commercialEntitlement);
		 
		Apttus_Config2__CustomerPurchaseOrder__c cpoRecord1 = new Apttus_Config2__CustomerPurchaseOrder__c();
		cpoRecord1.Sold_to_party__c = soldtopartyAcc.id;
		cpoRecord1.Payer__c = soldtopartyAcc.id;
		cpoRecord.Contract_start_date__c = system.today();
		cpoRecord.Contract_end_date__c=system.today()+365;
		cpoRecord.Terms__c = 12;
		cpoRecord.WBS__c='Test_WBS';
		cpoRecord1.Apttus_Config2__BillToAccountId__c = soldtopartyAcc.id;
		cpoRecord1.Apttus_Config2__ShipToAccountId__c = soldtopartyAcc.id;
		cpoRecord1.Sales_Org__c = 'Test';
		cpoRecord1.Sales_Office__c = 'Test';
		cpoRecord1.Sales_Group__c = 'Test';
		cpoRecord1.Distribution_Channel__c = 'Test';
		cpoRecord1.Division__c = 'Test';
		cpoRecord1.Apttus_QPConfig__ProposalId__c = quoteProposal2.id;
		//cpoRecord1.Grand_Total__c = 230;
		cpoRecord1.CurrencyIsoCode ='EUR';
		cpoRecord1.Apttus_CMConfig__AgreementId__c = agreement.Id;
		cpoRecord1.PO_number__c = '12564';
		cpoRecord1.Apttus_Config2__PODate__c =system.today();
		cpoRecord1.Comments__c = 'test';
		cpoRecord1.Contract_Type_Name__c ='Contract';
		cpoRecord1.Business_category__c = '2G';
		cpoRecord1.Reporting__c ='Excl contr from OBL';
		cpoRecord1.Master_contract__c = 'NA';
		cpoRecord1.ERP__c = 'P20';
		cpoRecord1.Legacy_CPO__c=true;		
		cpoRecord1.Opportunity__c =oppty.id;
		database.insert(cpoRecord1);
	
		 
		 Apttus_Config2__CustomerPOItem__c cpoItem = new Apttus_Config2__CustomerPOItem__c();
		cpoItem.Apttus_Config2__PurchaseOrderId__c  = cpoRecord1.id;
		 cpoItem.Apttus_Config2__ProductId__c  = product.id;
	cpoItem.Commercial_Entitlement__c  = commercialEntitlement.id;
		cpoItem.Apttus_Config2__StartDate__c=system.today();
		cpoItem.Apttus_Config2__EndDate__c=system.today()+365;
		database.insert(cpoItem);
		
		//cpoRecord1.Apttus_Config2__Status__c = 'Ready for Execution';
		database.update(cpoRecord1);
		
	
		
		 Map<Id,Apttus_Config2__CustomerPurchaseOrder__c > oldrecords = new Map<Id,Apttus_Config2__CustomerPurchaseOrder__c >();
		oldrecords.put(cpoRecord.id, cpoRecord);
		List<Apttus_Config2__CustomerPurchaseOrder__c> cpoNewList=new List<Apttus_Config2__CustomerPurchaseOrder__c>();
		cpoNewList.add(cpoRecord1);
		 cpoNewList.add(cpoRecord1); 
	
	DS_CPO_validation__c csObj = new DS_CPO_validation__c();
		csObj.Name='test Mandatory Fields';
		csObj.CPO_MandatoryFields__c='Payment_Terms__c,Incoterm__c,Sold_to_party__c,Payer__c,Apttus_Config2__BillToAccountId__c,Apttus_Config2__ShipToAccountId__c,Sales_Org__c,Sales_Office__c,Sales_Group__c,Distribution_Channel__c,Division__c,Apttus_QPConfig__ProposalId__c,Grand_Total__c';
		csObj.CPO_Mandatory_Fields2__c='CurrencyIsoCode,Apttus_CMConfig__AgreementId__c,PO_number__c,Apttus_Config2__PODate__c,Comments__c,Opportunity__c,Contract_end_date__c,Contract_start_date__c,Contract_Type_Name__c,WBS__c,Terms__c,Business_category__c,Reporting__c,Master_contract__c';
		csObj.CPO_Mandatory_Fields3__c='';
		csObj.CPO_Status__c='Ready for Execution';	
		database.insert(csObj);
		
		test.startTest();
	CPOTriggerHelper.createEntitlement(null);
		 CPOTriggerHelper.createEntitlement(cpoNewList);  
	CPOTriggerHelper.getCPOFields('Ready for Execution');
	
		test.stopTest();
	}
	
	
	/*public static testmethod void checkMandatoryFieldsTest(){
		List <Apttus_Config2__CustomerPurchaseOrder__c> cpolist = new List<Apttus_Config2__CustomerPurchaseOrder__c>();
		test.startTest();
		Account soldtopartyAcc =  TestDataFactory.createAccount(1)[0];
		//soldtopartyAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		database.insert(soldtopartyAcc);
		
		Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();
		//creating user
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		Opportunity oppty;
		insert userCreation;
		system.runAs(userCreation){
		oppty = TestDataFactory.OpportunityCreation(1,soldtopartyAcc)[0];
		oppty.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
		oppty.RecordTypeId=RecordTypeId;
		oppty.Lead_BG__c ='MN';
		oppty.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
		//insert new File_Sharing_Custom_Setting__c(Name = GlobalConstants.OPPORTUNITY_DOC_FREEZE_STAGE,Value__c='7');
		database.insert(oppty);
		}
		/
		Apttus_Config2__PriceList__c priceList= TestdataFactory.priceList(1)[0];
		database.insert(priceList);
		
		Apttus_Config2__PriceListItem__c PriceListItem= TestdataFactory.createPriceListItem(1,priceList)[0];
		database.insert(PriceListItem);
		/
		SWx_Upsell_Proposal__c upsellProposal_SWX=TestDataFactory.upsellList(1,soldtopartyAcc)[0];
		upsellProposal_SWX.Analytics_File_Refer_ID__c='GBR-61940-82356';
		upsellProposal_SWX.Analytics_Source__c='CXM';
		upsellProposal_SWX.Proposal_Recommendation_Type__c='renewal';
		upsellProposal_SWX.P20_Id__c=215616;
		upsellProposal_SWX.CurrencyIsoCode='EUR';
		upsellProposal_SWX.Unweighted_Value__c=429052.07;
		upsellProposal_SWX.Account_ID__c=soldtopartyAcc.Id;
		upsellProposal_SWX.Sold_To_Party__c = soldtopartyAcc.Id;
		upsellProposal_SWX.RecordTypeID=swxRecordTypeId;
	// upsellProposal_SWX.Sold_To_Party__c = accountCreationDP.Id;
		database.insert(upsellProposal_SWX);
		
		/set<ID> upsellproposalId_SWX= new set<Id>();
		upsellproposalId_SWX.add(upsellProposal_SWX.Id);
		
		List<SWx_Upsell_Items__c> lstSWXUpsellItems = TestDataFactory.createSWXLineItems(upsellproposalId_SWX,1);
		database.insert(lstSWXUpsellItems);
		
		
		Apttus_Proposal__Proposal__c quoteProposal1 = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
		quoteProposal1.Apttus_Proposal__Opportunity__c = oppty.id; 
		quoteProposal1.Apttus_QPConfig__PriceListId__c = priceList.Id;
		quoteProposal1.NokiaCPQ_Portfolio__c = 'IP Routing';
		quoteProposal1.NokiaCPQ_SSP_Level__c = 'Unlimited';
		quoteProposal1.SWx_Upsell_Proposal__c=upsellProposal_SWX.Id;
		quoteProposal1.Analytics_Source__c  = CSWXGlobalConstant.AnalyticsSource;
		quoteProposal1.RecordTypeId = swxQuoteRecordTypeId;
		quoteProposal1.Apttus_Proposal__Account__c=accountCreationDP.id;
		
		database.insert(quoteProposal1); 
		quoteProposal1.Apttus_Proposal__Approval_Stage__c='In Review';
		update quoteProposal1;
		/   
		Apttus_Proposal__Proposal__c quoteProposal2 = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
		quoteProposal2.Apttus_Proposal__Opportunity__c = oppty.id; 
		//quoteProposal2.Apttus_QPConfig__PriceListId__c = priceList.Id;
		quoteProposal2.NokiaCPQ_Portfolio__c = 'IP Routing';
		quoteProposal2.NokiaCPQ_SSP_Level__c = 'Unlimited';
		quoteProposal2.SWx_Upsell_Proposal__c=upsellProposal_SWX.Id;
		quoteProposal2.Analytics_Source__c  = CSWXGlobalConstant.AnalyticsSource;
		quoteProposal2.RecordTypeId = swxQuoteRecordTypeId;
		quoteProposal2.Prices_Aligned__c=true;
		quoteProposal2.Apttus_Proposal__Account__c=soldtopartyAcc.id;
		database.insert(quoteProposal2); 
		quoteProposal2.Apttus_Proposal__Approval_Stage__c='Accepted';
		update quoteProposal2;   
		/
		Map<Id,Apttus_Proposal__Proposal__c > oldrecords = new Map<Id,Apttus_Proposal__Proposal__c >();
		oldrecords.put(quoteProposal1.id, quoteProposal1);
		List<Apttus_Proposal__Proposal__c> quoteProposalList=new List<Apttus_Proposal__Proposal__c>();
		quoteProposalList.add(quoteProposal2);
			
		Test.startTest();
		CCREProposalTriggerHandler.updateQuoteShare(quoteProposalList,oldrecords);
		Test.stopTest();
		/
		
		DS_CPO_validation__c csObj = new DS_CPO_validation__c();
		csObj.Name='test Mandatory Fields';
		csObj.CPO_MandatoryFields__c='Payment_Terms__c,Incoterm__c,Sold_to_party__c,Payer__c,Apttus_Config2__BillToAccountId__c,Apttus_Config2__ShipToAccountId__c,Sales_Org__c,Sales_Office__c,Sales_Group__c,Distribution_Channel__c,Division__c,Apttus_QPConfig__ProposalId__c,Grand_Total__c';
		csObj.CPO_Mandatory_Fields2__c='CurrencyIsoCode,Apttus_CMConfig__AgreementId__c,PO_number__c,Apttus_Config2__PODate__c,Comments__c,Opportunity__c,Contract_end_date__c,Contract_start_date__c,Contract_Type_Name__c,WBS__c,Terms__c,Business_category__c,Reporting__c,Master_contract__c';
		csObj.CPO_Mandatory_Fields3__c='ERP__c';
		csObj.CPO_Status__c='Ready for Execution';	
		database.insert(csObj);
		
		Apttus_Config2__PaymentTerm__c payTerms = new Apttus_Config2__PaymentTerm__c();
		payTerms.Name='testPT';
		payTerms.Apttus_Config2__Sequence__c = 2;
		payTerms.Apttus_Config2__Label__c = 'Due Upon Receipt';
		database.insert(payTerms);
		
		Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c();
		agreement.Name= 'test Agreement';
		agreement.Apttus__Account__c = soldtopartyAcc.id;
		agreement.CurrencyIsoCode = 'EUR';
		database.insert(agreement);
		
		Apttus_Config2__CustomerPurchaseOrder__c cpoRecord = new Apttus_Config2__CustomerPurchaseOrder__c();
		cpoRecord.Sold_to_party__c = soldtopartyAcc.id;
		cpoRecord.Opportunity__c =oppty.id;
	cpoRecord.Apttus_Config2__Status__c ='Draft'; 
		cpoRecord.Contract_start_date__c = system.today();
		cpoRecord.Contract_end_date__c=system.today()+365;
		cpoRecord.Terms__c = 12;
		cpoRecord.WBS__c='Test_WBS';
		cpoRecord.Legacy_CPO__c=true;
		cpoRecord.Apttus_QPConfig__ProposalId__c=quoteProposal2.id;
		
		database.insert(cpoRecord);
		cpoRecord.Apttus_Config2__Status__c = 'Ready for Enrichment';
		database.update(cpoRecord);
		
		Apttus_Config2__CustomerPurchaseOrder__c cpoRecord1 = new Apttus_Config2__CustomerPurchaseOrder__c();
		cpoRecord1.Sold_to_party__c = soldtopartyAcc.id;
		cpoRecord1.Payment_Terms__c=payTerms.id;
		cpoRecord1.Payer__c = soldtopartyAcc.id;
		cpoRecord1.Contract_start_date__c = system.today();
		cpoRecord1.Contract_end_date__c=system.today()+365;
		cpoRecord1.Terms__c = 12;
		cpoRecord1.WBS__c='Test_WBS';
		cpoRecord1.Apttus_Config2__BillToAccountId__c = soldtopartyAcc.id;
		cpoRecord1.Apttus_Config2__ShipToAccountId__c = soldtopartyAcc.id;
		cpoRecord1.Sales_Org__c = 'Test';
		cpoRecord1.Sales_Office__c = 'Test';
		cpoRecord1.Sales_Group__c = 'Test';
		cpoRecord1.Distribution_Channel__c = 'Test';
		cpoRecord1.Division__c = 'Test';
		cpoRecord1.Apttus_QPConfig__ProposalId__c = quoteProposal2.id;
		//cpoRecord1.Grand_Total__c = 230;
		cpoRecord1.CurrencyIsoCode ='EUR';
		cpoRecord1.Legacy_CPO__c=true;
		cpoRecord1.Apttus_CMConfig__AgreementId__c = agreement.Id;
		cpoRecord1.PO_number__c = '12564';
		cpoRecord1.Apttus_Config2__PODate__c =system.today();
		cpoRecord1.Comments__c = 'test';
		cpoRecord1.Contract_Type_Name__c ='Contract';
		cpoRecord1.Business_category__c = '2G';
		cpoRecord1.Reporting__c ='Excl contr from OBL';
		cpoRecord1.Master_contract__c = 'NA';
		cpoRecord1.ERP__c = 'P20';		
		cpoRecord1.Opportunity__c =oppty.id;
		database.insert(cpoRecord1);
		
		cpoRecord1.Apttus_Config2__Status__c = 'Ready for Execution';
		database.update(cpoRecord1);
		
		 Map<Id,Apttus_Config2__CustomerPurchaseOrder__c > oldrecords = new Map<Id,Apttus_Config2__CustomerPurchaseOrder__c >();
		oldrecords.put(cpoRecord1.id, cpoRecord1);
		List<Apttus_Config2__CustomerPurchaseOrder__c> cpoNewList=new List<Apttus_Config2__CustomerPurchaseOrder__c>();
		cpoNewList.add(cpoRecord1);
		
		
		//CPOTriggerHandler.checkMandatoryFields(cpoNewList,oldrecords);
		//CPOTriggerHandler.checkMandatoryFields(Null,Null);
		CPOTriggerHelper.checkMandatoryFields(null);
		CPOTriggerHelper.getCPOFields(null);
		cpoRecord1.Apttus_Config2__Status__c = 'Ready for Delivery';
		database.update(cpoRecord1);
		List<Apttus_Config2__CustomerPurchaseOrder__c> cpoNewList1=new List<Apttus_Config2__CustomerPurchaseOrder__c>();
		cpoNewList1.add(cpoRecord1);
		CPOTriggerHandler.checkMandatoryFields(cpoNewList1,oldrecords);
		
		test.stopTest();
	}*/
	
}