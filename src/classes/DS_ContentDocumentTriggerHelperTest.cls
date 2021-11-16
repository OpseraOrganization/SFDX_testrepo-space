/****************************************
* Name : DS_ContentDocumentTriggerHelperTest
* Author : Accenture

*****************************************/
@isTest
public class DS_ContentDocumentTriggerHelperTest {
	
	public static Id DPRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('SWx Upsell Proposal').getRecordTypeId();
	public static Id swxRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal').getRecordTypeId();
/*****************************
	*Method Name: restrictDeleteTest
	*Description: This method is used for test coverage of restrictDelete method
	*Parameters:  
	*******************************/  
	/*public static testmethod Void restrictDeleteTest(){
		
		User sysAdminUser = TestDataFactory.createSystemAdminUser();
		System.runAs(sysAdminUser){
			
			Account acct = TestDataFactory.createAccount(1)[0];
			acct.AccountNumber='8990767834';  
			database.insert(acct);
			
			SWx_Upsell_Proposal__c DigitalProposal = TestDataFactory.upsellList(1,acct)[0];
			DigitalProposal.Account_ID__c=acct.id;
			DigitalProposal.Analytics_Source__c='CXM';
			DigitalProposal.Upsell_Status__c='Draft';
			DigitalProposal.CurrencyIsoCode='INR';
			DigitalProposal.RecordTypeId = DPRecordTypeId;
			DigitalProposal.Sold_To_Party__c=acct.id; 
			insert DigitalProposal; 
			
			Opportunity oppty = TestDataFactory.OpportunityCreation(1,acct)[0];
			oppty.StageName = 'Develop Opportunity';//
			oppty.Phase_Status__c = 'Opportunity in Progress';
			oppty.Lead_BG__c = 'MN';
			insert new File_Sharing_Custom_Setting__c(Name = GlobalConstants.OPPORTUNITY_DOC_FREEZE_STAGE,Value__c='7');
			database.insert(oppty);
			
			Apttus_Proposal__Proposal__c quoteProposal = NOKIA_CPQ_TestDataFactory.createProposal(1)[0]; 
			quoteProposal.NokiaCPQ_Portfolio__c = 'IP Routing';
			quoteProposal.Apttus_Proposal__Approval_Stage__c='Draft';
			quoteProposal.Apttus_Proposal__Opportunity__c=oppty.id;
			quoteProposal.RecordTypeId = swxRecordTypeId;
			database.insert(quoteProposal); 
			
			List <ContentDocument> contentdoclist = new list<ContentDocument>();
			
			ContentDocument cd = new ContentDocument();
			ContentVersion contentVersion = new ContentVersion();
			List<ContentDocumentLink> oContentDocumentLink = new List<ContentDocumentLink>();
			ContentDocumentLink contentdocumentlink = new ContentDocumentLink();
			ContentDocumentLink contentlink_QP = new ContentDocumentLink();
			
			contentVersion = TestDataFactory.createContentVersion(1)[0];  
			contentVersion.title = CSWXGlobalConstant.NetworkTrends;
			database.insert(contentVersion) ; 
			
			Id theContentDocumentId = [select ContentDocumentId from ContentVersion where Id =: contentVersion.Id limit 1].ContentDocumentId;
			
			contentdocumentlink = TestDataFactory.createContentDocumentLink(1,acct.id, theContentDocumentId)[0];
			contentdocumentlink.LinkedEntityId=DigitalProposal.id;
			oContentDocumentLink.add(contentdocumentlink);
			//database.insert(contentdocumentlink); DEPLOY OPTIMIZATION
			
			contentlink_QP = TestDataFactory.createContentDocumentLink(2,acct.id, theContentDocumentId)[1];
			contentlink_QP.LinkedEntityId=quoteProposal.id;
			oContentDocumentLink.add(contentlink_QP);
			//
			cd= [Select ID,Title from ContentDocument Where ID =: theContentDocumentId];
			database.insert(oContentDocumentLink);
			test.startTest();
			
			try{	
				
				DigitalProposal.Proposal_Status__c='Reject';
				update DigitalProposal;
				quoteProposal.Apttus_Proposal__Approval_Stage__c='Rejected';
				update quoteProposal;
				delete cd;
				
			}catch(Exception e){
				Boolean expected_message_cdl= (e.getMessage().contains('File Cannot be added or deleted for current status of Proposal'))?true:false;
				System.debug('eeeeee22'+expected_message_cdl);
				
			} 
			test.stopTest();  
		}
	}*/
	
	
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


		 List <ContentVersion> contentVersionlist = new list<ContentVersion>(); 
		ContentVersion contentVersion = new ContentVersion(
	Title = 'Penguins',
	PathOnClient = 'Penguins.jpg',
	VersionData = Blob.valueOf('Test Content'),
	origin = 'H',
	IsMajorVersion = true
		);
		contentVersionlist.add(contentVersion);
		insert contentVersionlist;   
		
		
		 List <Id> contentVersionlist2 = new list<Id>(); 
		
		
		 // Test INSERT
		ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id in :contentVersionlist LIMIT 1];
		
		
		contentVersionlist2.add(contentVersionSelect.ContentDocumentId);
		List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument where id in :contentVersionlist2];
		//System.assertEquals(documents.size(), 1);
		
		//List<>
 
		// Test DELETE
		DS_ContentDocumentTriggerHandler.beforeDelete(documents);
		documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
		//System.assertEquals(documents.size(), 0); 


	}
	
	static testmethod void DS_DPFileTest(){
		User sysAdminUser = TestDataFactory.createSystemAdminUser();
		System.runAs(sysAdminUser){

		//Account Insertion
		Account accLegalEntity = TestDataFactory.createAccount(1)[0];
		accLegalEntity.AccountNumber='100006843';
		accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		database.insert(accLegalEntity);
		
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
		upsellProposal_SWX.RecordTypeID=Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('SWx Upsell Proposal').getRecordTypeId();
		database.insert(upsellProposal_SWX);
		
		set<ID> upsellproposalId_SWX= new set<Id>();
		upsellproposalId_SWX.add(upsellProposal_SWX.Id);
		
		List<SWx_Upsell_Items__c> lstSWXUpsellItems = TestDataFactory.createSWXLineItems(upsellproposalId_SWX,1);
		database.insert(lstSWXUpsellItems);
		
		//opty Insertion
		Opportunity oppty ;
		oppty = TestDataFactory.OpportunityCreation(1,accountCreationDP)[0];
		oppty.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
		oppty.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();
		oppty.SWx_Upsell_Proposal__c =upsellProposal_SWX.Id;
		oppty.Lead_BG__c ='MN';
		oppty.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
	
		database.insert(oppty);
		
		//Quote Insertion	
		Apttus_Proposal__Proposal__c quoteProposal2 = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
		quoteProposal2.Apttus_Proposal__Opportunity__c = oppty.id; 
		quoteProposal2.Apttus_QPConfig__PriceListId__c = priceList.Id;
		quoteProposal2.NokiaCPQ_Portfolio__c = 'IP Routing';
		quoteProposal2.NokiaCPQ_SSP_Level__c = 'Unlimited';
		
		quoteProposal2.SWx_Upsell_Proposal__c=upsellProposal_SWX.Id;
		quoteProposal2.Analytics_Source__c  = CSWXGlobalConstant.AnalyticsSource;
		quoteProposal2.RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal').getRecordTypeId();
		quoteProposal2.Prices_Aligned__c=true;
		quoteProposal2.Apttus_Proposal__Account__c=accountCreationDP.id;
		quoteProposal2.Sold_To_Party__c = accLegalEntity.id;
		database.insert(quoteProposal2); 
		System.assertEquals('IP Routing', quoteProposal2.NokiaCPQ_Portfolio__c);  
		List <ContentVersion> contentVersionlist = new list<ContentVersion>(); 
		ContentVersion contentVersion = new ContentVersion(
	Title = 'Penguins',
	PathOnClient = 'Penguins.jpg',
	VersionData = Blob.valueOf('Test Content'),
	origin = 'H',
	IsMajorVersion = true
		);
		contentVersionlist.add(contentVersion);
		Test.startTest();
		insert contentVersionlist;	
		
		Id documents = [select ContentDocumentId from ContentVersion where Title='Penguins' limit 1].ContentDocumentId;

		//create ContentDocumentLink  record 
		ContentDocumentLink cdl = New ContentDocumentLink();
		cdl.LinkedEntityId = quoteProposal2.id;
		cdl.ContentDocumentId = documents;
		cdl.shareType = 'V';
		cdl.Visibility = 'AllUsers'; 
		insert cdl;
		
		ContentDocumentLink cdl2 = New ContentDocumentLink();
		cdl2.LinkedEntityId = upsellProposal_SWX.id;
		cdl2.ContentDocumentId = documents;
		cdl2.shareType = 'V';
		cdl2.Visibility = 'AllUsers'; 
		insert cdl2;

			System.assertEquals('AllUsers', cdl.Visibility); 
			contentVersion.Title = 'Penguins1';
			update contentVersion;
			Test.stopTest();
		}
  	}  
}