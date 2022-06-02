/****************************************
* Name : ProposalDetailTest
* Author : Accenture
* Description : Test class for ProposalDetail
*****************************************/
@istest
public class ProposalDetailTest{
/*
public static Id swxQuoteRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal').getRecordTypeId();
/*****************************
	*Method Name: getStatusDeatilsTest
	*Description: This method is used for test coverage of getStatusDeatils method
	*Parameters:  
	*******************************	
	public testmethod static void getStatusDeatilsTest(){
		Account acct = TestDataFactory.createAccount(1)[0];
		database.insert(acct);
		Opportunity oppty = TestDataFactory.OpportunityCreation(1,acct)[0];
		oppty.StageName = 'Develop Opportunity';
		oppty.Phase_Status__c = 'Opportunity in Progress';
		oppty.Lead_BG__c = 'MN';
		insert new File_Sharing_Custom_Setting__c(Name = GlobalConstants.OPPORTUNITY_DOC_FREEZE_STAGE,Value__c='7');

		 database.insert(oppty);
		
		
		Apttus_Proposal__Proposal__c quoteProposal = NOKIA_CPQ_TestDataFactory.createProposal(1)[0]; 
		quoteProposal.NokiaCPQ_Portfolio__c = 'IP Routing';
		quoteProposal.NokiaCPQ_SSP_Level__c = 'Unlimited'; 
		quoteProposal.Apttus_Proposal__Opportunity__c=oppty.id;
		quoteProposal.RecordTypeId=swxQuoteRecordTypeId;
		database.insert(quoteProposal); 
		ProposalDetail.getStatusDeatils(quoteProposal.Id);
		 
		delete quoteProposal;
		ProposalDetail.getStatusDeatils(quoteProposal.Id);
		
	}
 
/*****************************
	*Method Name: getProposalLineItemTest
	*Description: This method is used for test coverage of getProposalLineItem method
	*Parameters: 
	*******************************	
	public testmethod static void getProposalLineItemTest(){
		Account acct = TestDataFactory.createAccount(1)[0];
		 database.insert(acct);
		Opportunity oppty = TestDataFactory.OpportunityCreation(1,acct)[0];
		 oppty.StageName = 'Develop Opportunity';
		 oppty.Phase_Status__c = 'Opportunity in Progress';
		oppty.Lead_BG__c = 'MN';
		insert new File_Sharing_Custom_Setting__c(Name = GlobalConstants.OPPORTUNITY_DOC_FREEZE_STAGE,Value__c='7');
		 database.insert(oppty);
		
		Apttus_Proposal__Proposal__c quoteProposal = NOKIA_CPQ_TestDataFactory.createProposal(1)[0]; 
		quoteProposal.NokiaCPQ_Portfolio__c = 'IP Routing';
		quoteProposal.NokiaCPQ_SSP_Level__c = 'Unlimited'; 
		quoteProposal.Analytics_Source__c='CCRE';
		quoteProposal.Apttus_Proposal__Opportunity__c=oppty.id;
		quoteProposal.RecordTypeId=swxQuoteRecordTypeId;
		database.insert(quoteProposal); 
		ProposalDetail.getProposalLineItem(quoteProposal.Id);
		quoteProposal.Analytics_Source__c='CXM';
		 
		database.update(quoteProposal);
		ProposalDetail.getProposalLineItem(quoteProposal.Id);
	   }
	
/*****************************
	*Method Name: getProductInfoLineItemTest
	*Description: This method is used for test coverage of getProductInfoLineItem method
	*Parameters: 
	*******************************	
	public testmethod static void getProductInfoLineItemTest(){
		Account acct = TestDataFactory.createAccount(1)[0];
		 database.insert(acct);
		Opportunity oppty = TestDataFactory.OpportunityCreation(1,acct)[0];
		 oppty.StageName = 'Develop Opportunity';
		 oppty.Phase_Status__c = 'Opportunity in Progress';
		oppty.Lead_BG__c = 'MN';
		insert new File_Sharing_Custom_Setting__c(Name = GlobalConstants.OPPORTUNITY_DOC_FREEZE_STAGE,Value__c='7');
		 database.insert(oppty);
		
		Apttus_Proposal__Proposal__c quoteProposal = NOKIA_CPQ_TestDataFactory.createProposal(1)[0]; 
		quoteProposal.NokiaCPQ_Portfolio__c = 'IP Routing';
		quoteProposal.NokiaCPQ_SSP_Level__c = 'Unlimited'; 
		quoteProposal.Apttus_Proposal__Opportunity__c=oppty.id;
		quoteProposal.RecordTypeId=swxQuoteRecordTypeId;
		database.insert(quoteProposal); 
		ProposalDetail.getProductInfoLineItem(quoteProposal.Id);
	}
  
/*****************************
	*Method Name: getServiceInfoLineItemTest
	*Description: This method is used for test coverage of getServiceInfoLineItem method
	*Parameters: 
	*******************************	
	 public testmethod static void getServiceInfoLineItemTest(){
		 Account acct = TestDataFactory.createAccount(1)[0];
		 database.insert(acct);
		Opportunity oppty = TestDataFactory.OpportunityCreation(1,acct)[0];
		 oppty.StageName = 'Develop Opportunity';
		 oppty.Phase_Status__c = 'Opportunity in Progress';
		 oppty.Lead_BG__c = 'MN';
		 insert new File_Sharing_Custom_Setting__c(Name = GlobalConstants.OPPORTUNITY_DOC_FREEZE_STAGE,Value__c='7');
		 database.insert(oppty);
		 
		Apttus_Proposal__Proposal__c quoteProposal = NOKIA_CPQ_TestDataFactory.createProposal(1)[0]; 
		quoteProposal.NokiaCPQ_Portfolio__c = 'IP Routing';
		quoteProposal.NokiaCPQ_SSP_Level__c = 'Unlimited'; 
		quoteProposal.Apttus_Proposal__Opportunity__c=oppty.id;
		quoteProposal.RecordTypeId=swxQuoteRecordTypeId;
		database.insert(quoteProposal); 
		ProposalDetail.getServiceInfoLineItem(quoteProposal.Id);
	}
	
/*****************************
	*Method Name: getDocumentIdforLineTest
	*Description: This method is used for test coverage of getDocumentIdforLineTest method
	*Parameters: 
	*******************************	
	 public testmethod static void getDocumentIdforLineTest(){
		 Account acct = TestDataFactory.createAccount(1)[0];
		 database.insert(acct);
		Opportunity oppty = TestDataFactory.OpportunityCreation(1,acct)[0];
		 oppty.StageName = 'Develop Opportunity';
		 oppty.Phase_Status__c = 'Opportunity in Progress';
		 oppty.Lead_BG__c = 'MN';
		 insert new File_Sharing_Custom_Setting__c(Name = GlobalConstants.OPPORTUNITY_DOC_FREEZE_STAGE,Value__c='7');
		 database.insert(oppty);
		 
		Apttus_Proposal__Proposal__c quoteProposal = NOKIA_CPQ_TestDataFactory.createProposal(1)[0]; 
		quoteProposal.NokiaCPQ_Portfolio__c = 'IP Routing';
		quoteProposal.NokiaCPQ_SSP_Level__c = 'Unlimited'; 
		quoteProposal.RecordTypeId=swxQuoteRecordTypeId;
		quoteProposal.Apttus_Proposal__Opportunity__c=oppty.id;
		database.insert(quoteProposal); 
	   
		
		
		Apttus_Proposal__Proposal_Line_Item__c QuoteLineItem= TestDataFactory.proposalLineItemCreation(quoteProposal.Id);
		product2 product= TestDataFactory.productCreation(1)[0];
		product.name='Emergency Remote Support';
		product.Business_Group__c='MN';
		database.insert(product);
		QuoteLineItem.Apttus_Proposal__Product__c=product.Id;
		QuoteLineItem.DS_Grouping_Name__c='AYCE';
		QuoteLineItem.DS_Product_TechnicalInfo__c='Level1';
		QuoteLineItem.DS_Product_Technical_Info_Level2__c='Level2,Level3';
		QuoteLineItem.Apttus_QPConfig__LineNumber__c=1;
		database.insert(QuoteLineItem);
		 
		Test.StartTest();
		string Title=CSWXGlobalConstant.VBA_and_Interdependency;
		 
		ContentDocumentLink contentlink = new ContentDocumentLink();
		ContentVersion contentVersion = new ContentVersion();
		contentVersion = TestDataFactory.createContentVersion(1)[0];
		contentVersion.Title=CSWXGlobalConstant.VBA_and_Interdependency;
		database.insert(contentVersion) ; 
		ContentVersion conVersion = [SELECT ContentDocumentId,Title FROM ContentVersion where ID =: contentVersion.Id LIMIT 1];  
		contentlink = TestDataFactory.createContentDocumentLink(1, QuoteLineItem.Apttus_Proposal__Product__c,conVersion.contentdocumentid)[0];
		database.insert(contentlink);
	   
		ProposalDetail.getDocumentIdforLine(QuoteLineItem.Id, Title);
		 
		 ProposalDetail.getProposalLineItemMapping(quoteProposal.Id);
		 List<String> Grouping=new List<String>();
		 Grouping.add('AYCE');
		ProposalDetail.getProposalLineItemGrouping(quoteProposal.Id,Grouping);
		Test.StopTest();
	}
 /*****************************
	*Method Name: getDocumentIdTest
	*Description: This method is used for test coverage of getDocumentId method
	*Parameters: 
	*******************************	
	 public testmethod static void getDocumentIdTest(){
		 Account acct = TestDataFactory.createAccount(1)[0];
		 database.insert(acct);
		Opportunity oppty = TestDataFactory.OpportunityCreation(1,acct)[0];
		 oppty.StageName = 'Develop Opportunity';
		 oppty.Phase_Status__c = 'Opportunity in Progress';
		 oppty.Lead_BG__c = 'MN';
		 insert new File_Sharing_Custom_Setting__c(Name = GlobalConstants.OPPORTUNITY_DOC_FREEZE_STAGE,Value__c='7');
		 database.insert(oppty);
		
		Test.StartTest(); 
		Apttus_Proposal__Proposal__c quoteProposal = NOKIA_CPQ_TestDataFactory.createProposal(1)[0]; 
		quoteProposal.NokiaCPQ_Portfolio__c = 'IP Routing';
		quoteProposal.NokiaCPQ_SSP_Level__c = 'Unlimited';
		quoteProposal.Apttus_Proposal__Opportunity__c=oppty.id;
		quoteProposal.RecordTypeId=swxQuoteRecordTypeId;
		database.insert(quoteProposal);
		product2 product= TestDataFactory.productCreation(1)[0];
		product.name='Emergency Remote Support';
		product.Business_Group__c='MN';
		database.insert(product);
		
		string Title=CSWXGlobalConstant.VBA_and_Interdependency;
		ContentDocumentLink contentlink = new ContentDocumentLink();
		ContentVersion contentVersion = new ContentVersion();
		contentVersion = TestDataFactory.createContentVersion(1)[0];
		contentVersion.Title=CSWXGlobalConstant.VBA_and_Interdependency;
		database.insert(contentVersion) ; 
		ContentVersion conVersion = [SELECT ContentDocumentId,Title FROM ContentVersion where ID =: contentVersion.Id LIMIT 1];  
		contentlink = TestDataFactory.createContentDocumentLink(1, quoteProposal.Id,conVersion.contentdocumentid)[0];
		database.insert(contentlink);
	   
		
		ProposalDetail.getDocumentId(quoteProposal.Id,Title);
		Test.StopTest();
		
	   } 
	*/
	
}