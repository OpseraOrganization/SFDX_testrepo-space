/*************************************************************
@Name: NokiaCPQ_QuoteCreationCtrlExtnTest
@Author: Wipro
@Description: Test class for NokiaCPQ_QuoteCreationCtrlExtn

******************************************************************/
@isTest(SeeAllData=false)

private class NokiaCPQ_QuoteCreationCtrlExtnTest {
	
	@isTest static void TestQuoteCreation() {
	
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].AccountNumber='301030872';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;
		
		List<Account> acclist = new List<Account>();
		acclist.add(accounts[0]);
		
		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,acclist);
		//opportunities[0].StageName = 'Handover (Prepare for Delivery)';
		//opportunities[0].Phase_Status__c = 'Pending Win/Loss Declaration';
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = accounts[1].id;
		insert opportunities;
		
		test.startTest();
		
		PageReference pageRef = Page.NokiaCPQ_newQuoteVF;
	Test.setCurrentPage(pageRef);
	pageRef.getParameters().put('Id', opportunities[0].id);
	ApexPages.StandardController sc = new ApexPages.StandardController(opportunities[0]);
	NokiaCPQ_QuoteCreationCtrlExtn testNewQuoteCExt = new NokiaCPQ_QuoteCreationCtrlExtn(sc);
		
		//List<SelectOption> selOpts= testNewQuoteCExt.getRTOptionsItems();
		
		//testNewQuoteCExt.setRecordTypeSelection('QTC CQ Quote');
		//PageReference pr = testNewQuoteCExt.recordTypeChange();
		testNewQuoteCExt.setRecordTypeSelection('Contracted_Quote');
		PageReference pr = testNewQuoteCExt.recordTypeChange();
		testNewQuoteCExt.setRecordTypeSelection('CPQ_QTC_NCQ_Quote');
		 pr = testNewQuoteCExt.recordTypeChange();
		testNewQuoteCExt.setRecordTypeSelection('Direct_Quote');
		pr = testNewQuoteCExt.recordTypeChange();
		
		
		Apttus_Proposal__Proposal__c quote = testNewQuoteCExt.getQuote();
	
	//String quoteSuccessURL = testNewQuoteCExt.getQuoteSuccessURL();
	  //Boolean displayOnQuote = testNewQuoteCExt.getDisplayOnQuote();
	//Boolean displayOnQTCQuote = testNewQuoteCExt.getDisplayOnQTCQuote();
		//Boolean displayOnQTCQuotePT = testNewQuoteCExt.getDisplayOnQTCQuotePT();
		//Boolean displayNewQuotePB = testNewQuoteCExt.getDisplayNewQuotePB();
	  //Boolean displayRecordTypeSelectionPB = testNewQuoteCExt.getDisplayRecordTypeSelectionPB();
	  //Boolean displaySuccessMessagePB = testNewQuoteCExt.getDisplaySuccessMessagePB();
		 //String recordTypeSelection = testNewQuoteCExt.getRecordTypeSelection();
		
		 //List<Schema.FieldSetMember> fsm = testNewQuoteCExt.getFields();
	
		quote.Apttus_Proposal__Proposal_Name__c = 'Test Class Quote 1';
		quote.NokiaCPQ_Portfolio__c = 'IP Routing';
		pr = testNewQuoteCExt.save();
		
		quote.Apttus_Proposal__Proposal_Name__c = 'Test Class Quote 2';
		quote.NokiaCPQ_Portfolio__c = 'IP Routing';
		pr = testNewQuoteCExt.saveAndSuccessMessage();
		pr = testNewQuoteCExt.goToOpportunity();
		
		 test.stopTest(); 
	 }

}