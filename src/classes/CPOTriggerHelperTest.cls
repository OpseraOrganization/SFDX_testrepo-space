/****************************************
* Name : CPOTriggerHelperTest
* Author : Accenture
* Test class for : CPO_Trigger, CPOTriggerHandler, CPOTriggerHelper
* Updated by : Neeharika, Nokia
*****************************************/
@isTest
public class CPOTriggerHelperTest {
	
	public static Id swxRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByDeveloperName().get('SWx_Upsell_Proposal').getRecordTypeId();
	public static Id ccreRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByDeveloperName().get('CCRE_Upsell_Proposal').getRecordTypeId();
	public static Id swxQuoteRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CCRE_Proposal').getRecordTypeId();

	@testSetup
	public static void testDataSetup(){

		List <Apttus_Config2__CustomerPurchaseOrder__c> cpolist = new List<Apttus_Config2__CustomerPurchaseOrder__c>();
		Account accountCreationDP = TestDataFactory.createAccount(1)[0];
		database.insert(accountCreationDP);
		
		Account soldtopartyAcc =  TestDataFactory.createAccount(1)[0];
		soldtopartyAcc.ParentId=accountCreationDP.id;
		soldtopartyAcc.AccountNumber = '301030872';

		database.insert(soldtopartyAcc);
		
		Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
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
		//
		Apttus_Config2__PriceList__c priceList= TestdataFactory.priceList(1)[0];
		database.insert(priceList);
		
		Apttus_Config2__PriceListItem__c PriceListItem= TestdataFactory.createPriceListItem(1,priceList)[0];
		database.insert(PriceListItem);
		//
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
		database.insert(upsellProposal_SWX);

		set<ID> upsellproposalId_SWX= new set<Id>();
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
		database.insert(new List<Apttus_Proposal__Proposal__c>{quoteProposal1, quoteProposal2}); 
		
		Product2 product1 = TestDataFactory.productCreation(1)[0];
		product1.ProductCode = '151421';
		Product2 product2 = TestDataFactory.productCreation(1)[0];
		product2.ProductCode = '151424';
		database.insert(new List<Product2>{product1,product2});
		
		Commercial_Entitlement__c commercialEntitlement = new Commercial_Entitlement__c();
		commercialEntitlement.Parent_Account__c = accountCreationDP.Id;
		commercialEntitlement.Sold_To_Party__c = soldtopartyAcc.id;
		commercialEntitlement.Authorised_Quantity__c = 5;
		commercialEntitlement.Product_Name__c = product1.id;
		database.insert(commercialEntitlement);

		Map<Id,Apttus_Proposal__Proposal__c > oldrecords = new Map<Id,Apttus_Proposal__Proposal__c >();
		oldrecords.put(quoteProposal1.id, quoteProposal1);
		List<Apttus_Proposal__Proposal__c> quoteProposalList=new List<Apttus_Proposal__Proposal__c>();
		quoteProposalList.add(quoteProposal2);		

		Apttus_Config2__PaymentTerm__c payTerms = new Apttus_Config2__PaymentTerm__c();
		payTerms.Name='testPT';
		payTerms.Apttus_Config2__Sequence__c = 2;
		payTerms.Apttus_Config2__Label__c = 'Due Upon Receipt';
		database.insert(payTerms);
		
		Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c();
		agreement.Name= 'test Agreement';
		agreement.Apttus__Account__c = soldtopartyAcc.id;
		agreement.CurrencyIsoCode = 'EUR';
		
		Customer_Document__c cd = QTO_TestDataFactory.createCustomerDocument();
		cd.Status__c = 'Closed-validated';
		cd.Customer_Document_ID__c = '12435678';
		cd.Classification__c = 'Purchase Order';
		cd.Sub_Classification__c = 'Standard';
		cd.Nokia_Legal_Entity_Account__c = soldtopartyAcc.Id;
		cd.Customer__c = soldtopartyAcc.Id;
		
		Apttus_Config2__CustomerPurchaseOrder__c cpoRecord = new Apttus_Config2__CustomerPurchaseOrder__c();
		cpoRecord.Sold_to_party__c = soldtopartyAcc.id;
		cpoRecord.Opportunity__c =oppty.id;
		cpoRecord.Contract_start_date__c = system.today();
		cpoRecord.Contract_end_date__c=system.today()+365;
		cpoRecord.Terms__c = 12;
		cpoRecord.WBS__c='Test_WBS';
		cpoRecord.Legacy_CPO__c = true;
		cpoRecord.Apttus_QPConfig__ProposalId__c =quoteProposal2.id;					 
		
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
		cpoRecord1.Apttus_Config2__Status__c = 'Draft';
		cpoList.add(cpoRecord);   
		cpoList.add(cpoRecord1);		
		insert cpoList;				
		
		Apttus_Config2__CustomerPOItem__c cpoItem = new Apttus_Config2__CustomerPOItem__c();
		cpoItem.Apttus_Config2__PurchaseOrderId__c  = cpoRecord1.id;
		cpoItem.Apttus_Config2__StartDate__c=system.today();
		cpoItem.Apttus_Config2__EndDate__c=system.today()+365;
		cpoItem.Apttus_Config2__ProductId__c  = product1.id;
		cpoItem.Commercial_Entitlement__c  = commercialEntitlement.id;
		
		Apttus_Config2__CustomerPOItem__c cpoItem1 = new Apttus_Config2__CustomerPOItem__c();
		cpoItem1.Apttus_Config2__PurchaseOrderId__c  = cpoRecord1.id;
		cpoItem1.Apttus_Config2__StartDate__c=system.today()-1;
		cpoItem1.Apttus_Config2__EndDate__c=system.today()+365;
		cpoItem1.Line_Type__c = CSWXGlobalConstant.Option;
		
		Apttus_Config2__CustomerPOItem__c cpoItem2 = new Apttus_Config2__CustomerPOItem__c();
		cpoItem2.Apttus_Config2__PurchaseOrderId__c  = cpoRecord1.id;
		cpoItem2.Apttus_Config2__StartDate__c=system.today()-1;
		cpoItem2.Apttus_Config2__EndDate__c=system.today()+365;
		
		Apttus_Config2__CustomerPOItem__c cpoItem3 = new Apttus_Config2__CustomerPOItem__c();
		cpoItem3.Apttus_Config2__PurchaseOrderId__c  = cpoRecord.id;
		cpoItem3.Apttus_Config2__StartDate__c=system.today()-1;
		cpoItem3.Apttus_Config2__EndDate__c=system.today()+365;
		
		Apttus_Config2__CustomerPOItem__c cpoItem4 = new Apttus_Config2__CustomerPOItem__c();
		cpoItem4.Apttus_Config2__PurchaseOrderId__c  = cpoRecord.id;
		cpoItem4.Apttus_Config2__StartDate__c=system.today()+1;
		cpoItem4.Apttus_Config2__EndDate__c=system.today()+365;		
		
		Apttus_Config2__CustomerPOItem__c cpoItem5 = new Apttus_Config2__CustomerPOItem__c();
		cpoItem5.Apttus_Config2__PurchaseOrderId__c  = cpoRecord.id;
		cpoItem5.Apttus_Config2__StartDate__c=system.today()-1;
		cpoItem5.Apttus_Config2__EndDate__c=system.today()+365;
		database.insert(new List<Apttus_Config2__CustomerPOItem__c>{cpoItem,cpoItem1,cpoItem2,cpoItem3,cpoItem4,cpoItem5});
		
		cpoRecord.Apttus_Config2__Status__c = 'Ready for Enrichment';
		database.update(cpoRecord);
		
		DS_CPO_validation__c csObj = new DS_CPO_validation__c();
		csObj.Name='test Mandatory Fields';
		csObj.CPO_MandatoryFields__c='Apttus_CMConfig__AgreementId__c';
		csObj.CPO_Mandatory_Fields2__c='';
		csObj.CPO_Mandatory_Fields3__c='';
		csObj.CPO_Status__c='Ready for Execution';
		
		DS_CPO_validation__c csObj1 = new DS_CPO_validation__c();
		csObj1.Name='test Mandatory Fields 1';
		csObj1.CPO_MandatoryFields__c='Payment_Terms__c';
		csObj1.CPO_Mandatory_Fields2__c='';
		csObj1.CPO_Mandatory_Fields3__c='';
		csObj1.CPO_Status__c='Ready for Enrichment';
		List<DS_CPO_validation__c> dscpoValList = new List<DS_CPO_validation__c>{csObj, csObj1};
		insert dscpoValList;
		
		DS_Legacy_CPO_MandatoryCheckBypass__c dsl1 = new DS_Legacy_CPO_MandatoryCheckBypass__c();
		dsl1.Name = 'Apttus_CMConfig__AgreementId__c';
		DS_Legacy_CPO_MandatoryCheckBypass__c dsl2 = new DS_Legacy_CPO_MandatoryCheckBypass__c();
		dsl2.Name = 'Payment_Terms__c';
		insert new List<DS_Legacy_CPO_MandatoryCheckBypass__c>{dsl1,dsl2};
		
		
	}
	
	@isTest
	public static void test1_checkEnrichment(){		
				
		List<Apttus_Config2__CustomerPurchaseOrder__c> cpoNewList=new List<Apttus_Config2__CustomerPurchaseOrder__c>();
		Map<Id,Apttus_Config2__CustomerPurchaseOrder__c> cpoMap = new Map<Id,Apttus_Config2__CustomerPurchaseOrder__c >();
		
		test.startTest();
		cpoNewList = [Select Id,Apttus_Config2__Status__c from Apttus_Config2__CustomerPurchaseOrder__c
					  where Apttus_Config2__Status__c = 'Ready for Enrichment'];
		cpoMap.put(cpoNewList[0].id, cpoNewList[0]);		

		CPOTriggerHandler.checkEnrichment(cpoNewList,cpoMap);
		test.stopTest();		
	}
	
	@isTest
	public static void test2_checkMandatoryFields(){
		
		List<Apttus_Config2__CustomerPurchaseOrder__c> cpoNewList=new List<Apttus_Config2__CustomerPurchaseOrder__c>();
		Map<Id,Apttus_Config2__CustomerPurchaseOrder__c> cpoMap = new Map<Id,Apttus_Config2__CustomerPurchaseOrder__c >();
		
		test.startTest();
		cpoNewList = [Select Id,Apttus_Config2__Status__c,Legacy_CPO__c,Apttus_CMConfig__AgreementId__c,Payment_Terms__c
					  from Apttus_Config2__CustomerPurchaseOrder__c
					  where Apttus_Config2__Status__c = 'Ready for Enrichment'];
		
		cpoMap.put(cpoNewList[0].id, cpoNewList[0]);
		cpoNewList[0].Apttus_Config2__Status__c = 'Ready for Execution';
		update cpoNewList[0];
		
		system.debug(cpoMap+' '+cpoNewList);
		CPOTriggerHandler.checkMandatoryFields(cpoNewList,cpoMap);
		CPOTriggerHelper.checkMandatoryFields(cpoNewList);
		test.stopTest();
	}   

	public static testmethod void test3_getCPOFields(){
		
		test.startTest();				
		CPOTriggerHelper.getCPOFields('Ready for Execution');
		test.stopTest();	
	}
	
	public static testmethod void test4_createEntitlementNull(){
		
		test.startTest();
		List<Product2> products = new List<Product2>();
		products = [Select Id from Product2];	   
		
		List<Commercial_Entitlement__c> comEntList = new List<Commercial_Entitlement__c>();
		comEntList = [Select Id from Commercial_Entitlement__c];
		
		List<Apttus_Config2__CustomerPurchaseOrder__c> cpoNewList=new List<Apttus_Config2__CustomerPurchaseOrder__c>();
		cpoNewList = [Select Id,Apttus_Config2__Status__c from Apttus_Config2__CustomerPurchaseOrder__c
					  where Apttus_Config2__Status__c = 'Ready for Enrichment'];		
				
		CPOTriggerHelper.createEntitlement(null);
		CPOTriggerHelper.createEntitlement(cpoNewList);
		
		comEntList[0].Product_Name__c = products[0].id;
		database.update(comEntList[0]);
		CPOTriggerHelper.createEntitlement(cpoNewList);
		test.stopTest();
	} 
	
	public static testmethod void test5_createEntitlementDate(){
						
		List<Apttus_Config2__CustomerPurchaseOrder__c> cpoNewList=new List<Apttus_Config2__CustomerPurchaseOrder__c>();
		List<Apttus_Config2__CustomerPOItem__c> cpoItems = new List<Apttus_Config2__CustomerPOItem__c>();
		
		test.startTest();
		cpoNewList = [Select Id from Apttus_Config2__CustomerPurchaseOrder__c
					  where Apttus_Config2__Status__c = 'Ready for Enrichment'];		
		cpoItems = [Select Id from Apttus_Config2__CustomerPOItem__c];
				
		cpoItems[0].Apttus_Config2__StartDate__c=system.today()-1;
		database.update(cpoItems[0]);
		CPOTriggerHelper.createEntitlement(cpoNewList);
		test.stopTest();	
	}
	
	public static testmethod void test6_createEntitlement(){
						
		List<Apttus_Config2__CustomerPurchaseOrder__c> cpoNewList=new List<Apttus_Config2__CustomerPurchaseOrder__c>();		
		
		test.startTest();
		cpoNewList = [Select Id from Apttus_Config2__CustomerPurchaseOrder__c
					  where Apttus_Config2__Status__c = 'Ready for Enrichment'];
				
		cpoNewList[0].Apttus_Config2__Status__c = 'Ready for Execution';
		database.update(cpoNewList[0]);
		CPOTriggerHelper.createEntitlement(cpoNewList);
		test.stopTest();	
	}
	
	public static testmethod void test7_createEntitlement(){
						
		List<Apttus_Config2__CustomerPurchaseOrder__c> cpoNewList=new List<Apttus_Config2__CustomerPurchaseOrder__c>();		
		
		test.startTest();
		cpoNewList = [Select Id from Apttus_Config2__CustomerPurchaseOrder__c
					  where Apttus_Config2__Status__c = 'Ready for Enrichment'];
				
		cpoNewList[0].Apttus_Config2__Status__c = 'Draft';
		database.update(cpoNewList[0]);
		CPOTriggerHelper.createEntitlement(cpoNewList);
		test.stopTest();	
	}  
	
	public static testmethod void test8_createEntitlement(){
						
		List<Apttus_Config2__CustomerPurchaseOrder__c> cpoNewList=new List<Apttus_Config2__CustomerPurchaseOrder__c>();		
		
		test.startTest();
		cpoNewList = [Select Id from Apttus_Config2__CustomerPurchaseOrder__c
					  where Apttus_Config2__Status__c = 'Ready for Enrichment'];
				
		cpoNewList[0].Apttus_Config2__Status__c = 'Commercially Enriched';
		database.update(cpoNewList[0]);
		CPOTriggerHelper.createEntitlement(cpoNewList);
		test.stopTest();	
	}	

}