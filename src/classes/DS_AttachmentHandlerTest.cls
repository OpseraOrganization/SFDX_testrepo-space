/***********************************************
*	Class Name : AttachmentHandler
*	Created By : Accenture IDC
*	Created Date :16/May/2019
*	Description : To restrict uploading file on DP and Quote 

*********************************************/
@isTest
Public  class DS_AttachmentHandlerTest {

static testMethod void testAttachments(){

	  Account accLegalEntity = TestDataFactory.createAccount(1)[0];
	  accLegalEntity.AccountNumber='100006843';
	  accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
	  database.insert(accLegalEntity);
		
	  Id swxRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('SWx Upsell Proposal').getRecordTypeId();
	  Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();
	  Id swxQuoteRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal').getRecordTypeId();


	  Account accountCreationDP = TestDataFactory.createAccount(1)[0];
	  accountCreationDP.L4Name__c = 'TESTTerritory'; 
	  database.insert(accountCreationDP);
		   
		  //Price List 
		Apttus_Config2__PriceList__c priceList= TestdataFactory.priceList(1)[0];
		database.insert(priceList);
		
		// PLI Record
		Apttus_Config2__PriceListItem__c PriceListItem= TestdataFactory.createPriceListItem(1,priceList)[0];
		database.insert(PriceListItem);


	  //Digital Proposal
		
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
		
		  Opportunity oppty ;
		oppty = TestDataFactory.OpportunityCreation(1,accountCreationDP)[0];
		oppty.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
		oppty.RecordTypeId=RecordTypeId;
		oppty.SWx_Upsell_Proposal__c =upsellProposal_SWX.Id;
		oppty.Lead_BG__c ='MN';
		oppty.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
	   
		database.insert(oppty);
		
		
		
		Apttus_Proposal__Proposal__c quoteProposal2 = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
		quoteProposal2.Apttus_Proposal__Opportunity__c = oppty.id; 
		quoteProposal2.Apttus_QPConfig__PriceListId__c = priceList.Id;
		quoteProposal2.NokiaCPQ_Portfolio__c = 'IP Routing';
		quoteProposal2.NokiaCPQ_SSP_Level__c = 'Unlimited';
		
		quoteProposal2.SWx_Upsell_Proposal__c=upsellProposal_SWX.Id;
		quoteProposal2.Analytics_Source__c  = CSWXGlobalConstant.AnalyticsSource;
		quoteProposal2.RecordTypeId = swxQuoteRecordTypeId;
		quoteProposal2.Prices_Aligned__c=true;
		quoteProposal2.Apttus_Proposal__Account__c=accountCreationDP.id;
		 quoteProposal2.Sold_To_Party__c = accLegalEntity.id;
		database.insert(quoteProposal2); 


		Attachment attach=new Attachment();	
		attach.Name='Unit Test Attachment';
		Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
		attach.body=bodyBlob;
		attach.parentId=upsellProposal_SWX.id;
		insert attach;

	   delete attach;
	   
	   Attachment attach2=new Attachment();	
		attach2.Name='Unit Test Attachment';
		Blob bodyBlob2=Blob.valueOf('Unit Test Attachment Body');
		attach2.body=bodyBlob2;
		attach2.parentId=quoteProposal2.id;
		insert attach2;

	   delete attach2;


	}


}