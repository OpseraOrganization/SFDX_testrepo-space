@isTest
public class closedAllQuotesTest{

		Public Static Id RecordTypeId=Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('Read_Only_Indirect').getRecordTypeId();
		public static Id swxRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByDeveloperName().get('SWx_Upsell_Proposal').getRecordTypeId();
		public static Id swxQuoteRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CCRE_Proposal').getRecordTypeId();
   
   private  static testmethod void validateclosedallQuote() {
	List<ID> oppIDs = new List<ID>(); 
	list<id> setid = new list<id>();
	Account accLegalEntity = TestDataFactory.createAccount(1)[0];
	  accLegalEntity.AccountNumber='100006843';
	  accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	  database.insert(accLegalEntity);
	 
	  System.debug('accLegalEntity '+accLegalEntity);
	
	  Account accountCreationDP = TestDataFactory.createAccount(1)[0];
	  accountCreationDP.L4Name__c = 'TESTTerritory'; 
	  database.insert(accountCreationDP); 
	  System.debug('accountCreationDP '+accountCreationDP);
	
	  // DP
	  SWx_Upsell_Proposal__c upsellProposal_SWX= new SWx_Upsell_Proposal__c(); //TestDataFactory.upsellList(1,accountCreationDP)[0];
	  upsellProposal_SWX.Analytics_File_Refer_ID__c='GBR-61940-82356';
	  upsellProposal_SWX.Analytics_Source__c='CXM';
	  upsellProposal_SWX.Proposal_Recommendation_Type__c='renewal';
	  upsellProposal_SWX.P20_Id__c=215616;
	  upsellProposal_SWX.Sold_To_Party__c = accLegalEntity.id;
	  upsellProposal_SWX.CurrencyIsoCode='EUR';
	  upsellProposal_SWX.Unweighted_Value__c=429052.07;
	  upsellProposal_SWX.Account_ID__c=accLegalEntity.id;
	  upsellProposal_SWX.RecordTypeID=swxRecordTypeId;
	
	  database.insert(upsellProposal_SWX);
	  System.debug('upsellProposal_SWX '+upsellProposal_SWX);
	
	  //opty Insertion
	  Opportunity oppty ;
	  oppty = TestDataFactory.OpportunityCreation(1,accountCreationDP)[0];
	  oppty.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
	  oppty.RecordTypeId=RecordTypeId;
	  oppty.SWx_Upsell_Proposal__c =upsellProposal_SWX.Id;
	  oppty.Lead_BG__c ='MN';
	  oppty.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
	  oppty.Account_Role__c='Alliance Partner';
	
	  database.insert(oppty);
	  System.debug('oppty '+oppty);
	  setid.add(oppty.id);
	  oppIDs.addAll(setid);
	  //Price List 
	  Apttus_Config2__PriceList__c priceList= TestdataFactory.priceList(1)[0];
	  database.insert(priceList);
	  System.debug('priceList '+priceList);
	
	  //Quote Insertion  
	  Apttus_Proposal__Proposal__c quoteProposal2 = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
	  quoteProposal2.Apttus_Proposal__Opportunity__c = oppty.id; 
	  quoteProposal2.Apttus_QPConfig__PriceListId__c = priceList.Id;
	  quoteProposal2.NokiaCPQ_Portfolio__c = 'IP Routing';
	  quoteProposal2.NokiaCPQ_SSP_Level__c = 'Unlimited';
	  quoteProposal2.Apttus_Proposal__Approval_Stage__c = 'In Review';
	  //quoteProposal2.Quote_Type__c = 'Indirect CPQ';
	  quoteProposal2.SWx_Upsell_Proposal__c=upsellProposal_SWX.Id;
	  quoteProposal2.Analytics_Source__c  = CSWXGlobalConstant.AnalyticsSource;
	  quoteProposal2.RecordTypeId = swxQuoteRecordTypeId;
	  quoteProposal2.Prices_Aligned__c=true;
	  quoteProposal2.LOA_Status__c='Approved';
	  quoteProposal2.Apttus_Proposal__Account__c=accountCreationDP.id;
	  quoteProposal2.Sold_To_Party__c = accLegalEntity.id;
	
	  quoteProposal2.DSPricingManager__c=null;
	  quoteProposal2.DSSolutionManager__c=null;
	 
	  database.insert(quoteProposal2); 
	  System.debug('quoteProposal2 '+quoteProposal2);
		 
	quoteProposal2.Apttus_Proposal__Approval_Stage__c = 'Closed(Not Won)';
	quoteProposal2.Quote_Status__c = 'Closed';
	database.update(quoteProposal2);
	
		quoteProposal2.Apttus_Proposal__Approval_Stage__c = 'Approved';
		quoteProposal2.Quote_Status__c = 'Closed';
		quoteProposal2.NokiaCPQ_Update_Quote_Record_Type__c= True;
		quoteProposal2.Quote_Status__c='Submit';
		database.update(quoteProposal2);
	
	  Test.startTest();
	closedAllQuotes.executeBatchMethod(oppIDs);
	updateApprovalAllQuotes.executeBatchMethod(oppIDs);
		//closedAllQuotes cQuote = new closedAllQuotes(oppIDs);
		//Database.executeBatchMethod(cQuote);
		//updateApprovalAllQuotes updateQuote = new updateApprovalAllQuotes(oppIDs);
		//Database.executeBatchMethod(updateQuote); 
	  Test.StopTest();
	  }
}