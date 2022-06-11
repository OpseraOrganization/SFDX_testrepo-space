/****************************************
* Name : SWX_Offers_List
* Author : Accenture
* Description : Test class SWX_Offers_List
*****************************************/
@IsTest
private with sharing class SWX_Offers_ListTest {
	
	/******************************
	*Method Name: getProposalTest
	*Description: Test Method to cover getProposalTest
	*******************************/
	public static Id swxquoteRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal').getRecordTypeId();
	static testmethod void getProposalTest(){
			
		Account acct = TestDataFactory.createAccount(1)[0];
		database.insert(acct);
		Opportunity oppty = TestDataFactory.OpportunityCreation(1,acct)[0];
		oppty.StageName = 'Develop Opportunity';
		oppty.Phase_Status__c = 'Opportunity in Progress';
		oppty.Lead_BG__c = 'MN';
		insert new File_Sharing_Custom_Setting__c(Name = GlobalConstants.OPPORTUNITY_DOC_FREEZE_STAGE,Value__c='7');
		
		Test.startTest();
		database.insert(oppty);
		
		Apttus_Proposal__Proposal__c quoteProposal = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
		quoteProposal.NokiaCPQ_Portfolio__c = 'IP Routing';
		//quoteProposal.NokiaCPQ_SSP_Level__c = 'Unlimited';
		quoteProposal.RecordTypeId=swxquoteRecordTypeId;
		quoteProposal.Analytics_Source__c=CSWXGlobalConstant.AnalyticsSource;
	   
		List<Account> accountList = new List<Account>();
		List<Opportunity> opportunityList = new List<Opportunity>();
		List<Offer__c> offerList = new List<Offer__c>(); 
			
		quoteProposal.Apttus_Proposal__Opportunity__c=oppty.id;
		
		database.insert(quoteProposal);

		Apttus_Config2__ProductConfiguration__c prodconfig =TestDataFactory.createProductConfiguration(quoteProposal);
		prodconfig.Apttus_Config2__Status__c = CSWXGlobalConstant.statusFinalized;
		database.insert(prodconfig);
		
		Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c();
		lineItem.Apttus_Config2__ClassificationHierarchy__c = 'SWX Product Catalogue | Radio | LTE';
		lineItem.Apttus_Config2__ItemSequence__c = 10;
		lineItem.Apttus_Config2__LineNumber__c = 10;
		lineItem.Apttus_Config2__ConfigurationId__c=prodconfig.id;
		//d atabase.insert(lineItem);
	   
		
				Test.stopTest();
		
		SWX_Offers_List.getProposal('Name5',true,'Radio','LTE','Global Benchmarking','2017-10-26','Accepted'); 
		SWX_Offers_List.getProposal('Name',false,'All','All','All','2017-10-26','Published');
		SWX_Offers_List.getProposalOnLoad();
		SWX_Offers_List.getQuoteLevel3();
		SWX_Offers_List.getQuoteStages();
		
	   
		
	   
		
		ContentVersion contentVersion = new ContentVersion();
		ContentDocumentLink contentlink = new ContentDocumentLink();
		insert TestDataFactory.create_File_Sharing_Custom_Setting();
		
		contentVersion = TestDataFactory.createContentVersion(1)[0];		
		database.insert(contentVersion) ;					 
		
		Id theContentDocumentId = [select ContentDocumentId from ContentVersion where Id =: contentVersion.Id limit 1].ContentDocumentId;		
		
		contentlink = TestDataFactory.createContentDocumentLink(1,quoteProposal.Id, theContentDocumentId)[0];
		try{
		database.insert(contentlink) ; 
		}
		catch(Exception e){
		}
		
		SWX_Offers_List.getDocumentId(quoteProposal.Id,contentVersion.title);
		
		Apttus_Config2__ClassificationHierarchy__c classificationHier = TestDataFactory.CreateClassificationHierarchy(1)[0];
		classificationHier.Name='SWX Product Catalogue';
		database.insert(classificationHier) ; 
		
		SWX_Offers_List.getCategoryHierarcyDetails();
		SWX_Offers_List.getCategoryDataForSecondLevel();
	
	}
}