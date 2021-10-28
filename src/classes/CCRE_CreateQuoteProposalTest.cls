/*******************************
Class Name: CCRE_CreateQuoteProposalTest
Created by: Accenture
Created Date: 27th Nov 2017
Last modified by: Accenture
Description: Test class for CCRE_CreateQuoteProposal
*******************************/
@istest
public class CCRE_CreateQuoteProposalTest{
 
/*****************************
	*Method Name: getQuoteNameTest
	*Description: This method is used for test coverage of getQuoteName method
	*Parameters: 
	*******************************/	
		public static Id swxRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('SWx Upsell Proposal').getRecordTypeId();
		public static Id ccreRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('CCRE Upsell Proposal').getRecordTypeId();
		public static Id swxquoteRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal').getRecordTypeId();
		
		private static Id oppDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.CREATE_DIRECT_SALES_OPPORTUNITY).getRecordTypeId();
		public testmethod static void getQuoteNameTest(){
		Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();
   //Create Digital Proposal
		Account accObj = TestDataFactory.createAccount(1)[0]; 
		database.insert(accObj);
		
		SWx_Upsell_Proposal__c UpsellProposal=TestDataFactory.upsellList(1,accObj)[0];
		upsellProposal.Analytics_File_Refer_ID__c='GBR-61940-82356';
		upsellProposal.Analytics_Source__c='CCRE';
		upsellProposal.Proposal_Recommendation_Type__c='renewal';
		upsellProposal.P20_Id__c=215616;
		upsellProposal.CurrencyIsoCode='EUR';
		upsellProposal.RecordTypeID=ccreRecordTypeId;
		upsellProposal.Unweighted_Value__c=429052.07;
		upsellProposal.Account_ID__c=accObj.Id;
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
		upsellProposal_SWX.RecordTypeID=swxRecordTypeId;
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
		quoteProposal.RecordTypeId=swxquoteRecordTypeId;
		//quoteProposal.NokiaCPQ_SSP_Level__c = 'Unlimited';
		quoteProposal.SWx_Upsell_Proposal__c=UpsellProposal.Id;
		quoteProposal.Analytics_Source__c  = CSWXGlobalConstant.AnalyticsSource_CCRE;
		quoteProposal.RecordTypeId = swxquoteRecordTypeId ;
		database.insert(quoteProposal); 
		CCRE_CreateQuoteProposal.getQuoteName(quoteProposal.Id);
		
	}
	
/*****************************
	*Method Name: UpsertQuoteTest
	*Description: This method is used for test coverage of UpsertQuote method
	*Parameters: 
	*******************************/	 
	public testmethod static void UpsertQuoteTest(){
	 Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();
		Account accObj = TestDataFactory.createAccount(1)[0]; 
		database.insert(accObj);
		
		SWx_Upsell_Proposal__c UpsellProposal=TestDataFactory.upsellList(1,accObj)[0];
		upsellProposal.Analytics_File_Refer_ID__c='GBR-61940-82356';
		upsellProposal.Analytics_Source__c='CCRE';
		upsellProposal.Proposal_Recommendation_Type__c='renewal';
		upsellProposal.P20_Id__c=215616;
		upsellProposal.CurrencyIsoCode='EUR';
		upsellProposal.Unweighted_Value__c=429052.07;
		upsellProposal.Account_ID__c=accObj.Id;
		upsellProposal.Sold_To_Party__c=accObj.Id; 
		upsellProposal.RecordTypeID=ccreRecordTypeId;
		database.insert(UpsellProposal);
		
		set<ID> upsellproposalId= new set<Id>();
		upsellproposalId.add(upsellProposal.Id);
		
		CCRE_UpSell_LineItem__c ccrelineitems = TestDataFactory.createCCRELineItems(upsellproposalId,1)[0];
		database.insert(ccrelineitems);
		
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
		
		Apttus_Proposal__Proposal__c quoteProposal = NOKIA_CPQ_TestDataFactory.createProposal(1)[0]; 
		quoteProposal.SWx_Upsell_Proposal__c= UpsellProposal.Id;
		//quoteProposal.NokiaCPQ_SSP_Level__c = 'Unlimited';
		quoteProposal.NokiaCPQ_Portfolio__c = 'IP Routing';
		quoteProposal.RecordTypeId=swxquoteRecordTypeId;
		quoteProposal.Apttus_Proposal__Opportunity__c = oppty.id; 
		database.insert(quoteProposal); 
		
		CCRE_Service_Invoice_Info_line_items__c serviceInfoLineItems = new CCRE_Service_Invoice_Info_line_items__c();
		serviceInfoLineItems.Attribute_for_customer__c='Yes';
		serviceInfoLineItems.Attribute_Label__c='Service_level';
		serviceInfoLineItems.Attribute_Type__c='Text';
		serviceInfoLineItems.Attribute_Value__c='Bronze';
		serviceInfoLineItems.Offer__c=quoteProposal.Id;
		database.insert(serviceInfoLineItems);
	   
		CCRE_product_info_line_items__c productInfoLineItems = new CCRE_product_info_line_items__c();
		productInfoLineItems.Info_Type__c='Product';
		productInfoLineItems.Product_Family__c='Core Network';
		productInfoLineItems.Product_Group__c='IP Multimedia Products';
		productInfoLineItems.Product__c='RadiSys CMS-9000 Media Server';
		productInfoLineItems.Product_Release__c='RadiSys CMS-9000 MS R3.16';
		productInfoLineItems.Contracted_NEs_per_contract__c=2;
		productInfoLineItems.Contracted_NEs_per_customer__c=2;
		productInfoLineItems.Offer__c=quoteProposal.Id;
		database.insert(productInfoLineItems);
		
		CCRE_CreateQuoteProposal.UpsertQuote(quoteProposal.Id);
	}
	
}