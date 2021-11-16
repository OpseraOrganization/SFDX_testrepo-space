/****************************************
* Name : CartCreationTest
* Author : Accenture
* Description : Test class CartCreation
*****************************************/
@isTest
Private class CartCreationTest{
/******************************
*Method Name: createQuoteTest
*Description: Test Method to cover createQuoteTest
********************************/
	public static Id swxRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('SWx Upsell Proposal').getRecordTypeId();
	public static Id ccreRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('CCRE Upsell Proposal').getRecordTypeId();
	public static Id swxQuoteRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal').getRecordTypeId();
		
   static testmethod void createQuoteTest(){
	  
	   
		Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();
   //Create Digital Proposal
		Account accObj = TestDataFactory.createAccount(1)[0]; 
		database.insert(accObj);
		
		SWx_Upsell_Proposal__c UpsellProposal=TestDataFactory.upsellList(1,accObj)[0];
		upsellProposal.Analytics_File_Refer_ID__c='GBR-61940-82356';
		upsellProposal.Analytics_Source__c='CXM';
		upsellProposal.Proposal_Recommendation_Type__c='renewal';
		upsellProposal.P20_Id__c=215616;
		upsellProposal.CurrencyIsoCode='EUR';
		upsellProposal.Unweighted_Value__c=429052.07;
		upsellProposal.Account_ID__c=accObj.Id;
		upsellProposal.RecordTypeID=swxRecordTypeId  ;
		upsellProposal.Sold_To_Party__c=accObj.Id;
		
		database.insert(UpsellProposal);
		
		SWx_Upsell_Proposal__c upsellProposal_SWX=TestDataFactory.upsellList(1,accObj)[0];
		upsellProposal_SWX.Analytics_File_Refer_ID__c='GBR-61940-82356';
		upsellProposal_SWX.Analytics_Source__c='CXM';
		upsellProposal_SWX.Proposal_Recommendation_Type__c='renewal';
		upsellProposal_SWX.P20_Id__c=215616;
		upsellProposal_SWX.CurrencyIsoCode='EUR';
		upsellProposal_SWX.Unweighted_Value__c=429052.07;
		upsellProposal_SWX.Account_ID__c=accObj.Id;
		upsellProposal_SWX.Sold_To_Party__c=accObj.Id;
		upsellProposal_SWX.RecordTypeID=swxRecordTypeId ;
		database.insert(upsellProposal_SWX);
		
		set<ID> upsellproposalId= new set<Id>();
		upsellproposalId.add(upsellProposal.Id);
		
		set<ID> upsellproposalId_SWX= new set<Id>();
		upsellproposalId_SWX.add(upsellProposal_SWX.Id);
		
		CCRE_UpSell_LineItem__c ccrelineitems = TestDataFactory.createCCRELineItems(upsellproposalId,1)[0];
		database.insert(ccrelineitems);
		
		CCRE_UpSell_LineItem__c ccre_Product_and_Service_infolineitems = TestDataFactory.createCCRELineItem(1,UpsellProposal)[0];
		database.insert(ccre_Product_and_Service_infolineitems);
		
		List<SWx_Upsell_Items__c> lstSWXUpsellItems = TestDataFactory.createSWXLineItems(upsellproposalId_SWX,1);
		database.insert(lstSWXUpsellItems);
		
   //creating user
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		Opportunity oppty;
		insert userCreation;
		system.runAs(userCreation){
		oppty = TestDataFactory.OpportunityCreation(1,accObj)[0];
		oppty.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
		oppty.RecordTypeId=RecordTypeId;
		oppty.Lead_BG__c ='MN';
		oppty.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
		insert new File_Sharing_Custom_Setting__c(Name = GlobalConstants.OPPORTUNITY_DOC_FREEZE_STAGE,Value__c='7');
		database.insert(oppty);
			}
		
		Apttus_Config2__PriceList__c priceList= TestdataFactory.priceList(1)[0];
		database.insert(priceList);
		
		Apttus_Config2__PriceListItem__c PriceListItem= TestdataFactory.createPriceListItem(1,priceList)[0];
		database.insert(PriceListItem);
	   
		Apttus_Proposal__Proposal__c quoteProposal = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
		quoteProposal.Apttus_Proposal__Opportunity__c = oppty.id; 
		quoteProposal.Apttus_QPConfig__PriceListId__c = priceList.Id;
		quoteProposal.NokiaCPQ_Portfolio__c = 'IP Routing';
		quoteProposal.NokiaCPQ_SSP_Level__c = 'Unlimited';
		quoteProposal.SWx_Upsell_Proposal__c=UpsellProposal.Id;
		quoteProposal.RecordTypeId = swxQuoteRecordTypeId;
		quoteProposal.Analytics_Source__c  = CSWXGlobalConstant.AnalyticsSource_CCRE;
		database.insert(quoteProposal); 
		
		
		
		Apttus_Proposal__Proposal__c swxquoteProposal = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
		swxquoteProposal.Apttus_Proposal__Opportunity__c = oppty.id; 
		swxquoteProposal.Apttus_QPConfig__PriceListId__c = priceList.Id;
		swxquoteProposal.NokiaCPQ_Portfolio__c = 'IP Routing';
		swxquoteProposal.NokiaCPQ_SSP_Level__c = 'Unlimited';
		swxquoteProposal.SWx_Upsell_Proposal__c=upsellProposal_SWX.Id;
		swxquoteProposal.RecordTypeId = swxQuoteRecordTypeId;
		swxquoteProposal.Analytics_Source__c  = CSWXGlobalConstant.AnalyticsSource;
		database.insert(swxquoteProposal); 
		
		
		
		List<Apttus_Proposal__Proposal__c> idList = new List<Apttus_Proposal__Proposal__c>();
		List<Apttus_Proposal__Proposal__c> idList2 = new List<Apttus_Proposal__Proposal__c>();
		idList.add(quoteProposal);
		idList2.add(swxquoteProposal);
		Test.StartTest();
		CartCreation.createCart(idList2);
		CartCreation.createCart(null);

		 
		
		Map<Id, Apttus_Config2__ProductConfiguration__c> mapUpsellToConfiguration = new Map<Id,Apttus_Config2__ProductConfiguration__c>();
		Apttus_Config2__ProductConfiguration__c cart= TestDataFactory.createProductConfiguration(quoteProposal);
		database.insert(cart);
		mapUpsellToConfiguration.put(quoteProposal.SWx_Upsell_Proposal__c,cart);
		
	   product2 productObj = TestDataFactory.productCreation(1)[0];
		productObj.ProductCode = '151421';
		database.insert(productObj);
		
		Apttus_Config2__ProductOptionComponent__c productOptionComponentObj = TestDataFactory.CreateproductOptionComponent(productObj.id,1)[0];
		productOptionComponentObj.Apttus_Config2__ParentProductId__c = productObj.id;
		productOptionComponentObj.Apttus_Config2__Sequence__c = 46511;
		database.insert(productOptionComponentObj);
	   //
		CartCreation.createCart(idList);
		ccrelineitems.Service_PCI__c='';
		update ccrelineitems;
		CartCreation.createCart(idList);
	   CartCreation.createCart(null);
		
		quoteProposal.Analytics_Source__c  = CSWXGlobalConstant.AnalyticsSource;
	   quoteProposal.SWx_Upsell_Proposal__c=upsellProposal_SWX.Id;
	   update quoteProposal;
		idList.add(quoteProposal);
		
		lstSWXUpsellItems[0].Feature_ID__c='';
		update lstSWXUpsellItems;
		 CartCreation.createCart(idList2);
	   CartCreation.createCart(null);
		Test.stopTest();
	}
}