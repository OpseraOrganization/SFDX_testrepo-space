/*******************************
Class Name: DS_CPOHelperTest
Created by: Accenture
Created Date: 4 Jan 2019
Last modified by: Accenture
Description: Test class for DS_CPOHelper
*******************************/

@isTest
private with sharing class DS_CPOHelperTest{

	@testSetup static void setup() {
	
	EmailTemplate e = new EmailTemplate (developerName = 'test', FolderId = UserInfo.getUserId(), TemplateType= 'Text', Name = 'test'); 
	insert e;
			 
	}


	public static Id swxRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('SWx Upsell Proposal').getRecordTypeId();
	public static Id ccreRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('CCRE Upsell Proposal').getRecordTypeId();
	public static Id swxQuoteRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal').getRecordTypeId();


	 static testmethod void DS_CPOTest(){
	
	 EmailTemplate e =[SELECT Id,Body FROM EmailTemplate where developerName = 'test' Limit 1];
	   
		 
		//Account Insertion
		Account accLegalEntity = TestDataFactory.createAccount(1)[0];
		accLegalEntity.AccountNumber='100006843';
		accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		database.insert(accLegalEntity);
		
		Account accountCreationDP = TestDataFactory.createAccount(1)[0];
		accountCreationDP.L4Name__c = 'TESTTerritory'; 
		database.insert(accountCreationDP);
		
		// Agreement Insertion
		Apttus__APTS_Agreement__c agree = new Apttus__APTS_Agreement__c();
		agree.Apttus__Account__c = accLegalEntity.id;
		agree.Sold_to_party_number__c =accLegalEntity.id;
		insert agree;
		
	 
		Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();
		
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
		
		 //DP Item insertion
		
		set<ID> upsellproposalId_SWX= new set<Id>();
		upsellproposalId_SWX.add(upsellProposal_SWX.Id);
		
		List<SWx_Upsell_Items__c> lstSWXUpsellItems = TestDataFactory.createSWXLineItems(upsellproposalId_SWX,1);
		database.insert(lstSWXUpsellItems);
		
		//opty Insertion
		Opportunity oppty ;
		oppty = TestDataFactory.OpportunityCreation(1,accountCreationDP)[0];
		oppty.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
		oppty.RecordTypeId=RecordTypeId;
		oppty.SWx_Upsell_Proposal__c =upsellProposal_SWX.Id;
		oppty.Lead_BG__c ='MN';
		oppty.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
	   
		database.insert(oppty);
		
		Test.startTest();
		 String orgId = UserInfo.getOrganizationId();
				String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
				Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
				String uniqueName =   dateString + randomInt;
				
			   List<user> userlist = new List<user>();
				User user1 = new User(alias = 'abc', email = uniqueName + '@nokia.com' , emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
									  languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid = UserInfo.getProfileId(),  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
									  timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
				userlist.add(user1); 
		User user2 = new User(alias = 'abc1', email = uniqueName + '1@nokia.com' , emailencodingkey = 'UTF-8', firstName = 'test1', lastname = 'Testing1',
									  languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid = UserInfo.getProfileId(),  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
									  timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a1' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '1');
				userlist.add(user2); 
		database.insert(userlist); 
		
		
		ObjectTerritory2Association objterr = TestDataFactory.assigningAccountToTerritory(1,accLegalEntity,TestDataFactory.getTerritoryId())[0];
		insert objterr;
		
		
		ObjectTerritory2Association territoryIdList1 = [select id, Territory2Id, Territory2.name, SobjectType, ObjectId, AssociationCause from ObjectTerritory2Association 
									   where ObjectId = :accLegalEntity.Id];
		
		List<Sales_Role__c> srList = new List<Sales_Role__c>();
		Sales_Role__c sr = new Sales_Role__c();
		sr.Organisation__c = 'TESTTerritory';
		sr.User__c = user1.id;
		sr.Role_Name__c = Label.DS_CSM_Role_Name;
		sr.BG__c = 'MN';
		sr.Role_Code__c = 'COCO';
		srList.add(sr);
		Sales_Role__c sr1 = new Sales_Role__c();
		sr1.Organisation__c = 'TESTTerritory';
		sr1.User__c = user1.id;
		sr1.Role_Name__c = Label.DS_CDM_Role_Name;
		sr1.BG__c = 'MN';
		Sales_Role__c sr2 = new Sales_Role__c();
		sr2.Organisation__c = 'TESTTerritory';
		sr2.User__c = user2.id;
		sr2.Role_Name__c = Label.DS_CDM_Role_Name;
		sr2.BG__c = 'FN';
		sr2.Role_Code__c = 'COCO';
		srList.add(sr2);
		insert srList;
		
		
  
		//Quote Insertion	
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
		 
	  /*   ContentVersion contentVersion = new ContentVersion();
		ContentDocumentLink contentlink = new ContentDocumentLink();			
		contentVersion = TestDataFactory.createContentVersion(1)[0]; 
		contentVersion.title = 'Executive Summary';
		database.insert(contentVersion) ;							
		Id theContentDocumentId = [select ContentDocumentId from ContentVersion where Id =: contentVersion.Id limit 1].ContentDocumentId;		
		
		contentlink = TestDataFactory.createContentDocumentLink(1,quoteProposal2.Id, theContentDocumentId)[0];
		database.insert(contentlink) ; */
		 
		 Apttus_Config2__CustomerPurchaseOrder__c cpoRecord = new Apttus_Config2__CustomerPurchaseOrder__c();
		cpoRecord.Sold_to_party__c = accLegalEntity.id;
		cpoRecord.Opportunity__c =oppty.id;
		cpoRecord.Contract_start_date__c = system.today();
		cpoRecord.Contract_end_date__c=system.today()+365;
		cpoRecord.Terms__c = 12;
		cpoRecord.WBS__c='Test_WBS';
		cpoRecord.Legacy_CPO__c=true;
		cpoRecord.Apttus_QPConfig__ProposalId__c =quoteProposal2.id;
		
		database.insert(cpoRecord);
	  
		Apttus_Proposal__Proposal_Line_Item__c QuoteLI = new Apttus_Proposal__Proposal_Line_Item__c();
		QuoteLI.Apttus_Proposal__Proposal__c = quoteProposal2.id;
		QuoteLI.Apttus_QPConfig__ItemSequence__c = 1;
		QuoteLI.Apttus_QPConfig__LineNumber__c =1;
		insert QuoteLI;
		
	   Set<Id> AccRecIdSet = new Set<Id>();
		
	   AccRecIdSet.add(accountCreationDP.id);
		
	  // Apttus_Proposal__Proposal__c  quoteRec = [SELECT id,SWx_Upsell_Proposal__c,Apttus_Proposal__Opportunity__c ,Apttus_Proposal__Approval_Stage__c,Quote_Type__c FROM Apttus_Proposal__Proposal__c WHERE Id = :quoteProposal2.Id];
	   
	   quoteProposal2.Apttus_Proposal__Approval_Stage__c='For Configure';
	  update quoteProposal2;
	   
	  
	  // Apttus_Proposal__Proposal__c  quoteRec2 = [SELECT id,Apttus_Proposal__Account__c,SWx_Upsell_Proposal__c,Apttus_Proposal__Opportunity__c ,Apttus_Proposal__Approval_Stage__c,Quote_Type__c FROM Apttus_Proposal__Proposal__c WHERE Id = :quoteProposal2.Id];
	   quoteProposal2.Apttus_Proposal__Approval_Stage__c='For Pricing';
	   update quoteProposal2;
	   //Apttus_Proposal__Proposal__c  quoteRec3 = [SELECT id,Contract_Start_Date__c,Apttus_Proposal__Account__c,SWx_Upsell_Proposal__c,Apttus_Proposal__Opportunity__c ,Apttus_Proposal__Approval_Stage__c,Quote_Type__c FROM Apttus_Proposal__Proposal__c WHERE Id = :quoteRec2.Id];
	   quoteProposal2.LOA_Status__c='G4 Submission';
	   quoteProposal2.Apttus_Proposal__Approval_Stage__c='In Review';
	   quoteProposal2.Contract_Start_Date__c = Date.newInstance(2016, 12, 9);
	   update quoteProposal2;
	  // Apttus_Proposal__Proposal__c  quoteRec4 = [SELECT id,Apttus_Proposal__Account__c,SWx_Upsell_Proposal__c,Apttus_Proposal__Opportunity__c ,Apttus_Proposal__Approval_Stage__c,Quote_Type__c FROM Apttus_Proposal__Proposal__c WHERE Id = :quoteRec3.Id];
	   
	   quoteProposal2.LOA_Status__c='Approved';
	   quoteProposal2.Apttus_Proposal__Approval_Stage__c='Approved';
	   update quoteProposal2;
	   
	   //Map<Id,Apttus_Proposal__Proposal__c> quotemap =new Map<Id,Apttus_Proposal__Proposal__c>([SELECT id,Apttus_Proposal__Account__c,SWx_Upsell_Proposal__c,Apttus_Proposal__Opportunity__c ,Apttus_Proposal__Approval_Stage__c,Quote_Type__c FROM Apttus_Proposal__Proposal__c WHERE Id = :quoteRec4.Id]);
	   
	   
	   //Apttus_Proposal__Proposal__c  quoteRec5 = [SELECT id,Apttus_Proposal__Account__c,SWx_Upsell_Proposal__c,Apttus_Proposal__Opportunity__c ,Apttus_Proposal__Approval_Stage__c,Quote_Type__c FROM Apttus_Proposal__Proposal__c WHERE Id = :quoteRec4.Id];
	   
	   quoteProposal2.Agreement_Lookup__c = agree.id;
	   quoteProposal2.Apttus_Proposal__Approval_Stage__c ='Accepted';
	   update quoteProposal2;
	  
		List<Apttus_Proposal__Proposal__c> quoteList = new List<Apttus_Proposal__Proposal__c>();
		quoteList.add(quoteProposal2);
		
		//cpo Custom Setting data
		
		DS_CPOMapping__c CPOCS = new DS_CPOMapping__c();
		
		CPOCS.Object__c ='Apttus_Proposal__Proposal__c';
		CPOCS.Source__c ='Id';
		CPOCS.Name = 'Apttus_QPConfig__ProposalId__c';
		insert CPOCS;
		
		
		DS_CPOMapping__c CPOCS4 = new DS_CPOMapping__c();
		
		CPOCS4.Object__c ='Apttus_Proposal__Proposal__c';
		CPOCS4.Source__c ='Agreement_Lookup__c';
		CPOCS4.Name = 'Apttus_CMConfig__AgreementId__c';
		insert CPOCS4;
		
		
		
		DS_CPOMapping__c CPOCS5 = new DS_CPOMapping__c();
		
		CPOCS5.Object__c ='Apttus__APTS_Agreement__c';
		CPOCS5.Source__c ='Sold_to_party_number__c';
		CPOCS5.Name = 'Sold_to_party__c';
		insert CPOCS5;
		
		
		
		 DS_CPOMapping__c CPOCS2 = new DS_CPOMapping__c();
		
		CPOCS2.Object__c ='Apttus_Proposal__Proposal_Line_Item__c';
		CPOCS2.Source__c ='Id';
		CPOCS2.Name = 'Apttus_QPConfig__ProposalLineItemId__c';
		insert CPOCS2;
		
		
		DS_CPOMapping__c CPOCS3 = new DS_CPOMapping__c();
		
		CPOCS3.Object__c ='Apttus__APTS_Agreement__c';
		CPOCS3.Source__c ='Apttus_CMConfig__BillToAccountId__c';
		CPOCS3.Name = 'Apttus_Config2__BillToAccountId__c';
		insert CPOCS3;
		
		DS_CPOMapping__c CPOAcc = new DS_CPOMapping__c();
		
		CPOAcc.Object__c ='Apttus_Proposal__Proposal__c';
		CPOAcc.Source__c ='Apttus_Proposal__Account__c';
		CPOAcc.Name = 'Apttus_Config2__AccountId__c';
		insert CPOAcc;
		 
		
		
		DS_CPOHelper.getQuoteFields();
		DS_CPOHelper.getAgreementFields();
		DS_CPOHelper.getQuoteLIFields();
		 DS_CPOHelper.DS_CreateCPO(quoteList);
		//DS_CPOHandler.DS_CreateCPO(quoteList,quotemap);
		
		
		DS_CPOHelper.CPO_CSMCDM  wrap = new  DS_CPOHelper.CPO_CSMCDM();
		wrap.accountIDTOCSM =null;
		wrap.accountIDTOCDM =null;
		
		 List<Apttus_Proposal__Proposal__c> updatedQuoteList;
		 Map<Id, Apttus_Proposal__Proposal__c> oldQuoteList;
		// DS_CPOHandler.DS_CreateCPO(updatedQuoteList,oldQuoteList);		 
		 DS_CPOHelper.getCSMandCDM(null);
		
	   Test.stopTest();
	  
	}
	
	
	
	
	 
  
	
}