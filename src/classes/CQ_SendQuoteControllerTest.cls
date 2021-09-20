@isTest
public class CQ_SendQuoteControllerTest {
	 Private static final Id Contracted_Quote_RecId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get(Label.CQ_RecordTypeId).getRecordTypeId();
	 Private static final Id CQ_Read_Only_RecId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CQ_Read_Only').getRecordTypeId();
	 private static Id oppDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	 private static  Id LERecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	 private static  Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(); 

	 public Static List<Apttus_Proposal__Proposal__c> Quotes=new List<Apttus_Proposal__Proposal__c>();
	 public Static List<Surround_document_links__c> SurroundDoclinks=new List<Surround_document_links__c>();
	 public Static List<contentDocumentLink> ContentDoclinks=new List<contentDocumentLink>();
	 public Static List<Contact> Contacts=new List<Contact>();
	 public Static List<CQ_Customer_Contact__c> CustomerContacts=new List<CQ_Customer_Contact__c>();
	 public Static List<CQ_Quote_Team__c> Quoteteams=new List<CQ_Quote_Team__c>();
	 public Static List<User> userList = new List<User>();
	public Static List<CQ_Sync_Quote_EAI__c> SyncQuotetoEAI = new List<CQ_Sync_Quote_EAI__c>();

	@testSetup 
	static void TestData() {
	
	Test.setMock(WebServiceMock.class, new QuoteOffer_SyncCalloutServiceMockTest());
		
	File_Sharing_Custom_Setting__c fscs = new File_Sharing_Custom_Setting__c();
			fscs.name= 'Opportunity_SalesPhase_FinalStage';
			fscs.Value__c = 'Completed';
	database.insert(fscs);
		
	CQ_Email_Templates__c CqEmail=new CQ_Email_Templates__c(Name='Email_CQ_TE_ST_CLASS');
		 database.insert(CqEmail); 
		
			CQ_Sync_Quote_EAI__c maxsize=new CQ_Sync_Quote_EAI__c(Name='CQ_MAX_SIZE',Size__c=25);
			CQ_Sync_Quote_EAI__c MAX_BULK_SIZE_ERROR=new CQ_Sync_Quote_EAI__c(Name='MAX_BULK_SIZE_ERROR',Message__c='max size');
			CQ_Sync_Quote_EAI__c CQ_SYNCQUOTE_INSERT=new CQ_Sync_Quote_EAI__c(Name='CQ_SYNCQUOTE_INSERT',sync__c=true);
			CQ_Sync_Quote_EAI__c CQ_SYNCQUOTE_UPDATE=new CQ_Sync_Quote_EAI__c(Name='CQ_SYNCQUOTE_UPDATE',sync__c=true);
			
			SyncQuotetoEAI.add(maxsize);
			SyncQuotetoEAI.add(MAX_BULK_SIZE_ERROR);
			SyncQuotetoEAI.add(CQ_SYNCQUOTE_INSERT);
			SyncQuotetoEAI.add(CQ_SYNCQUOTE_UPDATE);
			database.insert(SyncQuotetoEAI);
		
	Account accountNoNvzw = NF_TestDataFactory.createAccount('1TestNONVZW0000');
	Account accountVZW = NF_TestDataFactory.createAccount('1TestVZW00000');
		
	
	 accountVZW.Qtc_sold_to__c=system.Label.VzW_Number;
	 accountNoNvzw.RecordTypeId=custRecordTypeId;
	 accountVZW.RecordTypeId=custRecordTypeId;
		
	List<Account> accounts=new List<Account>();
	 accounts.add(accountNoNvzw);
	accounts.add(accountVZW);
		
	 Database.insert(accounts);
	  Account accountNoNvzw_LegalEnt = NF_TestDataFactory.createAccount('10308719999AISIS');
	  Account accountVZW_LegalEnt = NF_TestDataFactory.createAccount('103087199999KDDKD');
	  
	accountNoNvzw_LegalEnt.Accountnumber='1323242223i';
	accountNoNvzw_LegalEnt.Recordtypeid=LERecordTypeId;
	accountNoNvzw_LegalEnt.ParentId=accounts[0].Id;
	accountNoNvzw_LegalEnt.Default_Legal_Entity__c = true;
	accountNoNvzw_LegalEnt.Partner_Program__c=null;
		
   accountVZW_LegalEnt.Recordtypeid=LERecordTypeId;   
   accountVZW_LegalEnt.Accountnumber='1493593549i';
   accountVZW_LegalEnt.ParentId=accounts[1].Id;
   accountVZW_LegalEnt.Default_Legal_Entity__c = true;
   accountVZW_LegalEnt.Partner_Program__c=null; 
   accountVZW_LegalEnt.Qtc_sold_to__c=system.Label.VzW_Number;

	accounts.add(accountNoNvzw_LegalEnt);
	 accounts.add(accountVZW_LegalEnt);
	
   Database.upsert(accounts); 

	
		
		Opportunity OpportunityNonVZW = NF_TestDataFactory.createOpportunity(accounts[0].Id, 'Create offer (bid)', 'Offer in Progress', Date.today().addDays(10), 7000000);
		OpportunityNonVZW.Lead_BG__c='MN';
		OpportunityNonVZW.Lead_BU__c='MN';
		OpportunityNonVZW.RecordTypeId = oppDirectRecordTypeId;
		OpportunityNonVZW.Business_Type__c = 'Standard Opportunity';
	  
		Opportunity OpportunityVZW = NF_TestDataFactory.createOpportunity(accounts[1].Id, 'Create offer (bid)', 'Offer in Progress', Date.today().addDays(10), 7000000);
		OpportunityVZW.Lead_BG__c='MN';
		OpportunityVZW.Lead_BU__c='MN';
		OpportunityVZW.RecordTypeId = oppDirectRecordTypeId;
		OpportunityVZW.Business_Type__c = 'Standard Opportunity';
		
		List<opportunity> opportunities=new List<opportunity>();
		opportunities.add(OpportunityNonVZW);
	opportunities.add(OpportunityVZW);
		Database.insert(opportunities);
   
		Test.startTest(); 
		 Apttus_Proposal__Proposal__c Quote_ObjNoNVZW = new Apttus_Proposal__Proposal__c(
	RecordtypeId=Contracted_Quote_RecId,
	CQ_Value__c=100,
	Apttus_Proposal__Proposal_Expiration_Date__c=system.today(),
	CQ_eQuote_Status__c='failure',
			Apttus_Proposal__Proposal_Name__c = 'quote',Apttus_Proposal__Approval_Stage__c = 'Approved',
			Apttus_Proposal__Account__c = accounts[0].Id,
	 Account_Legal_Entity__c=accounts[2].Id,
	
			Apttus_Proposal__Opportunity__c = opportunities[0].Id,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
	isCQ__C=true,
	CQ_Documents_Attached__c=true,
			CQ_Due_Date__c  =system.Today()+30
			
		);
		
		 Apttus_Proposal__Proposal__c Quote_ObjVZW = new Apttus_Proposal__Proposal__c(
	RecordtypeId=Contracted_Quote_RecId,
	CQ_Value__c=100,
	Apttus_Proposal__Proposal_Expiration_Date__c=system.today(),
	Apttus_Proposal__Proposal_Name__c = 'quote',
	Apttus_Proposal__Approval_Stage__c = 'Approved',
	 Apttus_Proposal__Account__c = accounts[1].Id,
	Account_Legal_Entity__c=accounts[3].Id,
	CQ_eQuote_Status__c='failure',
			Apttus_Proposal__Opportunity__c = opportunities[1].Id,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
	 isCQ__C=true,
	cq_equote__c = true,
			CQ_Due_Date__c  =system.Today()+30  ,
	CQ_Documents_Attached__c=true,
	CQ_Customer_Organization_Segment__c='VERIZON WIRELESS INC.'
			
		);
		 
	  
		
		Quotes.add(Quote_ObjNoNVZW);
	Quotes.add(Quote_ObjVZW);
		Database.insert(Quotes);  
	  
	  Apttus_Proposal__Proposal__c Q=[select id,NokiaCPQ_Proposal_Id__c from Apttus_Proposal__Proposal__c where isCQ__C=true limit 1];  
		
		Surround_document_links__c surLinkNonvzw=new Surround_document_links__c(
		CQ_Name__c=Quotes[0].Id,
		//CQ_ID__c=Quotes[1].NokiaCPQ_Proposal_Id__c,
		CQ_ID__c=Q.NokiaCPQ_Proposal_Id__c,
		IS_latest__c=true,
		File_Name__c='Quote'+Quotes[0].Id,
		title__c = 'Special Price');
		
		Surround_document_links__c surLinkvzw=new Surround_document_links__c(
		CQ_Name__c=Quotes[1].Id,
		//CQ_ID__c=Quotes[1].NokiaCPQ_Proposal_Id__c,
		CQ_ID__c=Q.NokiaCPQ_Proposal_Id__c,
		IS_latest__c=true,
		File_Name__c='Quote'+Quotes[0].Id,
		title__c = 'Verizon Wireless Special Price');
		
		SurroundDoclinks.add(surLinkNonvzw);
		SurroundDoclinks.add(surLinkvzw);
		Database.insert(SurroundDoclinks,false); 
		
		 
		 ContentVersion  contVersion = TestDataFactory.createContentVersion_New(1,GlobalConstants.Quote_Document)[0];
	contVersion.Title='Quote'+Quotes[0].Id;
			database.insert(contVersion);
		
	ContentVersion Conversion  =  [SELECT Id,ContentDocumentId from ContentVersion where Id=:contVersion.Id limit 1];
		
   
		
		 Contact NonvZWContact = new Contact(LastName='Quote'+Quotes[0].Id,accountId =accounts[0].Id,Email=Quotes[0].Id+'@nokia.com');
		 Contact vZWContact = new Contact(LastName='Quote'+Quotes[1].Id,accountId =accounts[1].Id,Email=Quotes[1].Id+'@nokia.com');
		Contacts.add(NonvZWContact);
		Contacts.add(vZWContact);
		database.insert(Contacts);
	
		CQ_Customer_Contact__c NonvZWCustomerContact=new CQ_Customer_Contact__c(CQ_Is_Primary__c=true,CQ_Account__c=accounts[0].Id,CQ_CQ_Name__c=Quotes[0].Id,CQ_Contact__c=Contacts[0].Id);
		CQ_Customer_Contact__c vZWCustomerContact=new CQ_Customer_Contact__c(CQ_Is_Primary__c=true,CQ_Account__c=accounts[1].Id,CQ_CQ_Name__c=Quotes[1].Id,CQ_Contact__c=Contacts[1].Id);
		CustomerContacts.add(NonvZWCustomerContact);	
		CustomerContacts.add(vZWCustomerContact);
		database.insert(CustomerContacts);
		
		User testUser1 = NF_TestDataFactory.createAdminUser('System Administrator');
		User testUser2 = NF_TestDataFactory.createAdminUser('System Administrator');  
		userList.add(testUser1);
		userList.add(testUser2);
		database.insert(userList);
		
		CQ_Quote_Team__c NonVzwQuoteTeam=new CQ_Quote_Team__c(CQ_CQ_Name__c=Quotes[0].Id,CQ_Quote_Team_Member__c=userList[0].Id);
		CQ_Quote_Team__c VzwQuoteTeam=new CQ_Quote_Team__c(CQ_CQ_Name__c=Quotes[1].Id,CQ_Quote_Team_Member__c=userList[1].Id);
		Quoteteams.add(NonVzwQuoteTeam);
		Quoteteams.add(VzwQuoteTeam);
		database.insert(Quoteteams);
	
		EmailMessage NewE_Msg=new EmailMessage();
		NewE_Msg.RelatedToId=Quotes[1].Id;
		NewE_Msg.FromAddress=USerInfo.getUserEmail();
		NewE_Msg.FromName=USerInfo.getName();
		NewE_Msg.MessageDate=system.now();
		NewE_Msg.Subject='TEST';
		NewE_Msg.HtmlBody='Hi';
		NewE_Msg.ToAddress='test@nokia.com'; 
		NewE_Msg.IsExternallyVisible=false;
		NewE_Msg.Status= '3';
		NewE_Msg.IsTracked=false; 
		 database.insert(NewE_Msg);
		
	  contentDocumentLink  conDocumentLinkNonVZW = TestDataFactory.createContentDocumentLink_New(1,Quotes[0].Id,conVersion.ContentDocumentId)[0];
	  contentDocumentLink  conDocumentLinkVZW = TestDataFactory.createContentDocumentLink_New(1,Quotes[1].Id,conVersion.ContentDocumentId)[0];
	  contentDocumentLink  conDocumentLinkVZW_Emsg = TestDataFactory.createContentDocumentLink_New(1,NewE_Msg.Id,conVersion.ContentDocumentId)[0];
		conDocumentLinkNonVZW.ShareType = 'V';
		conDocumentLinkVZW.ShareType = 'V';
		conDocumentLinkVZW_Emsg.ShareType = 'V';

	  ContentDoclinks.add(conDocumentLinkNonVZW);
	  ContentDoclinks.add(conDocumentLinkVZW);
	  ContentDoclinks.add(conDocumentLinkVZW_Emsg);

	  database.insert(ContentDoclinks);
	  Test.stopTest();
		
	}
	
	static testMethod void CQ_SendQuotevalid(){
		Test.startTest();
		list<Id> DocumentIds=new list<string>();
	Map<Id,Apttus_Proposal__Proposal__c> equotemap=new map<Id,Apttus_Proposal__Proposal__c>();
		 Id EmailtemplateFolderID =[select id from folder where developerName=:'sCPQ_CQ_Email_templates'].Id;
		 Emailtemplate EmailTemp=new Emailtemplate(Name='Email CQTEST CLASS',DeveloperName='Email_CQ_TE_ST_CLASS',HTMLValue='<div>TEstclass</div>',FolderId=EmailtemplateFolderID,Templatetype='Custom');
	database.insert(EmailTemp);
		
		Apttus_Proposal__Proposal__c NonvZWQuote=[Select Id ,NokiaCPQ_Proposal_Id__c,Apttus_Proposal__Account__c,Account_Legal_Entity__r.Qtc_sold_to__c,CQ_equote__C from Apttus_Proposal__Proposal__c Where Account_Legal_Entity__r.Qtc_sold_to__c!=:system.Label.VzW_Number Limit 1];
		Apttus_Proposal__Proposal__c vZWQuote=[Select Id,NokiaCPQ_Proposal_Id__c ,Account_Legal_Entity__r.Qtc_sold_to__c,CQ_equote__C from Apttus_Proposal__Proposal__c Where Account_Legal_Entity__r.Qtc_sold_to__c=:system.Label.VzW_Number Limit 1];
		equotemap.put(vZWQuote.Id,vZWQuote);
		list<CQ_Customer_Contact__c> CustomerContacts=[Select Id,CQ_Account__c,CQ_Contact__c,CQ_Contact__r.Name,CQ_Contact__r.Email,CQ_CQ_Name__c,CQ_Is_Primary__c,CQ_Quote_Name__c from CQ_Customer_Contact__c
		WHERE CQ_CQ_Name__c =: NonvZWQuote.Id OR CQ_CQ_Name__c=:vZWQuote.Id ];
	
		for(contentDocumentLink DoclinkVZW :[select id,contentDocumentId from contentDocumentLink where LinkedentityId=:vZWQuote.id])
	DocumentIds.add(DoclinkVZW.contentDocumentId);
	 for(contentDocumentLink DoclinkNonVZW :[select id,contentDocumentId from contentDocumentLink where LinkedentityId=:NonvZWQuote.id])
	DocumentIds.add(DoclinkNonVZW.contentDocumentId);
			
		list<string> toAddresses=new list<string>{'test@nokia.com','Test1@nokia.com'};
		CQ_SendQuoteController.QuoteRelatedDetails(NonvZWQuote.Id,'Apttus_Proposal__Proposal__c');
	CQ_SendQuoteController.QuoteRelatedDetails(vZWQuote.Id,'Apttus_Proposal__Proposal__c');
	CQ_SendQuoteController.sendQuoteEmail(toAddresses,null,'Hello,this is testclass','TestClass',DocumentIds,NonvZWQuote,CustomerContacts,toAddresses);
	CQ_SendQuoteController.sendQuoteEmail(toAddresses,null,'Hello,this is testclass','TestClass',DocumentIds,vZWQuote,CustomerContacts,toAddresses);
	CQ_SendQuoteController.sendQuoteByMail(equotemap);

		Test.stopTest();
	}

}