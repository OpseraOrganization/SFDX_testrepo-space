/**
 * @description	   : 
 * @author			: Raj Kamdar
 * @group			 : 
 * @last modified on  : 12-15-2020
 * @last modified by  : Raj Kamdar
 * Modifications Log 
 * Ver   Date		 Author	   Modification
 * 1.0   12-15-2020   Raj Kamdar   Initial Version
**/
@isTest
private  class QTO_ManualCDToQLIAssociationTest {

	 private static Apttus__APTS_Agreement__c agreement;
	private static List<Apttus__APTS_Agreement__c> agreements;
	private static string agreementName = 'SLB_upsertAgreementsQueuebaleTest_1';
	private static string agreementNameRevised = 'Revised_SLB_upsertAgreementsQueuebaleTest_1';
   
	
	@TestSetup
	static void setup(){
	   List<Account> accList = QTO_TestDataFactory.createAccount(1);
	   insert accList; 
	   Opportunity opp = QTO_TestDataFactory.OpportunityCreation(accList[0]);
	   insert opp;
	   Apttus__APTS_Agreement__c agr = QTO_TestDataFactory.createAgreement(accList[0]);
	   insert agr; 
		
	   Customer_Document__c cd = QTO_TestDataFactory.createCustomerDocument();
	   insert cd; 
	   Customer_Document_Line_Items__c cdLine = QTO_TestDataFactory.createCustomerDocumentLineItem(cd);
	   insert cdLine; 
	   Apttus_Config2__PriceList__c pl = QTO_TestDataFactory.priceList(); 
	   insert pl;  
	   Apttus_Config2__PriceListItem__c plLines = QTO_TestDataFactory.createPriceListItem(pl); 
	   insert plLines;	
	   List<Apttus_Proposal__Proposal__c> quotes = QTO_TestDataFactory.createProposal(1,opp.id); 
	   insert quotes;
	   Apttus_Proposal__Proposal_Line_Item__c quoteLines = QTO_TestDataFactory.proposalLineItemCreation(quotes[0].id,plLines); 
	   insert quoteLines;  
	  
	   Customer_facing_Attribute__c cfa = QTO_TestDataFactory.createCFA(quotes[0].id,quoteLines.id); 
	   insert cfa;  
	}


	@isTest private static void testCase1()
	{
		Customer_Document__c cd = [SELECT Id,Name, Customer__c from Customer_Document__c];
		List<Apttus_Proposal__Proposal__c>  quotes = [SELECT Id,Name  from Apttus_Proposal__Proposal__c];
		System.debug('SIZE OF QUOTES: '+quotes.size());
		Test.startTest();
		 
		System.enqueueJob(new QTO_ManualCDItemToQuoteItemQueue( quotes, cd));

		Test.stopTest();
	}
	
	 @isTest private static void testCase2()
	{
		Customer_Document__c cd = [SELECT Id,Name, Customer__c from Customer_Document__c];
		Apttus_Proposal__Proposal__c quote = [SELECT Id,Name  from Apttus_Proposal__Proposal__c];
		List<Apttus_Proposal__Proposal__c>  quotes = new List<Apttus_Proposal__Proposal__c>();
		Customer_Document_Line_Items__c cdLI = [SELECT Id,Name, Site__c,High_level_Product__c from Customer_Document_Line_Items__c];
		cdLI.Site__c ='916872';
		update cdLI;
		quotes.add(quote);
		Test.startTest();
		 
		System.enqueueJob(new QTO_ManualCDItemToQuoteItemQueue( quotes, cd));

		Test.stopTest();
		// Assert that the Name was updated Successfully.
		System.assertEquals('916872', cdLI.Site__c);
	  
	}
	
	@isTest private static void getAllCDLIfromCDTest()
	{
		Customer_Document__c cd = [SELECT Id,Name, Customer__c from Customer_Document__c];
	   
		Customer_Document_Line_Items__c cdLI = [SELECT Id,Name, Site__c,High_level_Product__c from Customer_Document_Line_Items__c];
	   
		Test.startTest();
		Set<Id> cdSet = new Set<Id>{cd.id}; 
		QTO_QuoteLineItemAssociationHelper helper = new QTO_QuoteLineItemAssociationHelper();	
		Map<Id,List<Customer_Document_Line_Items__c>> cdMap = QTO_QuoteLineItemAssociationHelper.getAllCDLIfromCD(cdSet);
		Test.stopTest();
		// Assert that the Name was updated Successfully.
		System.assertEquals(1, cdMap.size());
	}
	
	 @isTest private static void associateQuoteWithCDTest()
	{
		Customer_Document__c cd = [SELECT Id,Name, Customer__c from Customer_Document__c];
		Apttus_Proposal__Proposal__c quote = [SELECT Id,Name  from Apttus_Proposal__Proposal__c];
		Set<Id>  quotes = new Set<Id>();
		Map<Id,String> m = new Map<id,String>();
	  
		quotes.add(quote.id);
		Test.startTest();
		//List<QTO_Customer_Document_Association_Quote__c> jnObj = QTO_CustomerDocumentAssociationHelper.associateQuoteWithCD(cd.id,quotes,m);
		Test.stopTest();
	}
	
	  @isTest private static void associateAgreementWithCDTest()
	{
		Customer_Document__c cd = [SELECT Id,Name, Customer__c from Customer_Document__c];
		Apttus__APTS_Agreement__c agr = [SELECT Id,Name from Apttus__APTS_Agreement__c];
		Apttus_Proposal__Proposal__c quote = [SELECT Id,Name  from Apttus_Proposal__Proposal__c];
		Set<Id>  agrId = new Set<Id>();
		Map<Id,QTO_AssociationOutputWrapper.AgreementAssociationWrapper> m = new Map<Id,QTO_AssociationOutputWrapper.AgreementAssociationWrapper>();
		agrId.add(agr.id);
		Test.startTest();
		List<QTO_Customer_Document_Agreement__c> jnObj = QTO_QuoteLineItemAssociationHelper.associateAgreementWithCD(cd.id,agrId,m);
		Test.stopTest();
	}

}