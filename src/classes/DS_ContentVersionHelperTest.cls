@isTest
public class DS_ContentVersionHelperTest {
	
	public static Id swxDPRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('SWx Upsell Proposal').getRecordTypeId();
	public static Id ccreRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('CCRE Upsell Proposal').getRecordTypeId();
	public static Id swxRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal').getRecordTypeId();
	
   public static testmethod void restrictNewVersionTest(){
	 Id swxRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('SWx Upsell Proposal').getRecordTypeId();
	
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
			DigitalProposal.Proposal_Status__c='Active';
			DigitalProposal.RecordTypeId=swxRecordTypeId ;
			DigitalProposal.Sold_To_Party__c=acct.id;
			database.insert(DigitalProposal);
			system.debug('DigitalProposal--->>'+DigitalProposal);
	  
			List <ContentVersion> contentVersionlist = new list<ContentVersion>();  
		 Test.startTest();
			ContentDocumentLink contentlink_dp = new ContentDocumentLink();
			
			ContentVersion cv=new Contentversion();
			cv.title='ABC';
			cv.PathOnClient ='test';
			Blob b=Blob.valueOf('Unit Test Attachment Body');
			cv.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
			insert cv;  
		
			contentVersionlist.add(cv) ;
			
			
			Id theContentDocumentId = [select ContentDocumentId from ContentVersion where Id =: cv.Id limit 1].ContentDocumentId;
		 
			system.debug('theContentDocumentId--->>'+theContentDocumentId);
		 
			contentlink_dp = TestDataFactory.createContentDocumentLink(1,DigitalProposal.id, theContentDocumentId)[0];
			contentlink_dp.LinkedEntityId=DigitalProposal.id;
	
			
			
			database.insert(contentlink_dp) ; 
	 
	
			test.stoptest();
		 
	 
		}
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
		 Test.startTest();
		
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
		insert contentVersionlist;	
		

		Id documents = [select ContentDocumentId from ContentVersion where Title='Penguins' limit 1].ContentDocumentId;

		//create ContentDocumentLink  record 
		ContentDocumentLink cdl = New ContentDocumentLink();
		cdl.LinkedEntityId = quoteProposal2.id;
		cdl.ContentDocumentId = documents;
		cdl.shareType = 'V';
		cdl.Visibility = 'AllUsers'; 
		insert cdl;

		 System.assertEquals('AllUsers', cdl.Visibility); 
		 
		 
		 
		 contentVersion.Title = 'Penguins1';
		 update contentVersion;
		 Test.stopTest();
		}
 }
}