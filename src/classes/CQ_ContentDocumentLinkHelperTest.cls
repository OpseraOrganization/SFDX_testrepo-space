@isTest
public class CQ_ContentDocumentLinkHelperTest {


	Private static final Id Contracted_Quote_RecId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get(Label.CQ_RecordTypeId).getRecordTypeId();
	Private static final Id CQ_Read_Only_RecId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CQ_Read_Only').getRecordTypeId();
	private static Id oppDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
	private static  Id LERecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(GlobalConstants.LEGAL_ENTITY_DEVNAME).getRecordTypeId();
	private static Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(GlobalConstants.CUSTOMER_DEVNAME).getRecordTypeId(); 
	public Static List<Account> accounts=new List<Account>(); 
	public Static List<opportunity> opportunities=new List<opportunity>();
	public Static List<contentDocumentLink> contentDocumentLink_list=new List<contentDocumentLink>();
	public Static List<contentDocumentLink> contentDocumentLink_list_2=new List<contentDocumentLink>();
	
	public Static list<Apttus_Proposal__Proposal__c> quotes =new list<Apttus_Proposal__Proposal__c>(); 
	public Static list<Surround_CQ_Reporting__c> reports =new list<Surround_CQ_Reporting__c>(); 
	public Static map<string,string> rep_map = new map<string,string>();
	public static map<String,string> QuoteReporting_mapTest=new map<String,string>();
	public static list<ContentVersion> contendDocId_list = new list<ContentVersion>();
	public static set<contentDocumentLink> contentDocumentLink_set = new set<contentDocumentLink>();
	public Static string CQ_Number='19.12.A00A';
	
	@testSetup
	static void TestData(){
		
		Account accountVZW = NF_TestDataFactory.createAccount('1TestVZW00000');		
		accountVZW.Qtc_sold_to__c=system.Label.VzW_Number;
		accountVZW.RecordTypeId=custRecordTypeId;
		accounts.add(accountVZW);	  
		Database.insert(accounts);
		system.debug('accounts_--->>'+accounts);
		
		Account accountVZW_LegalEnt = NF_TestDataFactory.createAccount('103087199999KDDKD');		
		accountVZW_LegalEnt.Recordtypeid=LERecordTypeId;   
		accountVZW_LegalEnt.Accountnumber='1493593549i';
		accountVZW_LegalEnt.ParentId=accounts[0].Id;
		accountVZW_LegalEnt.Default_Legal_Entity__c = true;
		accountVZW_LegalEnt.Partner_Program__c=null;	
		accountVZW_LegalEnt.Qtc_sold_to__c=system.Label.VzW_Number;	
		accounts.add(accountVZW_LegalEnt);		
		Database.upsert(accounts); 
		system.debug('accounts_upsert--->>'+accounts);
		
		GlobalConstants.OPPORTUNITYTRIGGER_RESTRICT_OPPTY_CREATION = True;
		Opportunity OpportunityVZW = NF_TestDataFactory.createOpportunity(accounts[0].Id, 'Create offer (bid)', 'Offer in Progress', Date.today().addDays(10), 7000000);
		OpportunityVZW.Lead_BG__c='MN';
		OpportunityVZW.RecordTypeId = oppDirectRecordTypeId;
		OpportunityVZW.Business_Type__c = 'Standard Opportunity';	
		opportunities.add(OpportunityVZW);
		Database.insert(opportunities);
		system.debug('OpportunityVZW--->>##'+OpportunityVZW);
		
		id cqadmingroupTest;
		collaborationgroup collabTest = new collaborationgroup();
		collabTest.Name='CQ Business Admin';
		collabTest.CollaborationType='Private';			
		database.insert(collabTest);
		list<collaborationgroup> admingroup = [select id from collaborationgroup where name = 'CQ Business Admin' limit 1];
		cqadmingroupTest = admingroup[0].id;
		
		test.startTest();
		
		Apttus_Proposal__Proposal__c Quote = new Apttus_Proposal__Proposal__c(
			RecordtypeId=Contracted_Quote_RecId,
			NokiaCPQ_Proposal_Id__c=CQ_Number,
			CQ_Value__c=100,
			Apttus_Proposal__Proposal_Expiration_Date__c=system.today(),
			Apttus_Proposal__Proposal_Name__c = 'quote',
			Apttus_Proposal__Approval_Stage__c = 'Approved',
			Apttus_Proposal__Account__c = accounts[0].Id,
			Account_Legal_Entity__c=accounts[1].Id,
			CQ_eQuote_Status__c='failure',
			Apttus_Proposal__Opportunity__c = opportunities[0].Id,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
			isCQ__C=true,
			CQ_Due_Date__c  =system.Today()+30  ,
			CQ_Documents_Attached__c=true,
			CQ_Customer_Organization_Segment__c='VERIZON WIRELESS INC.'
		);
		quotes.add(Quote);
		Database.insert(quotes);
		system.debug('quotes####--->>'+quotes);
		
		
		Surround_CQ_Reporting__c cq_report = new Surround_CQ_Reporting__c(CQ_Number__c=quotes[0].NokiaCPQ_Proposal_Id__c,
						 CQ_Status__c='Approved',
						 CQ_Value__c=100,
						 CQ_Due_Date__c=system.today()+30,
						 Opportunity__c=opportunities[0].Id,
						 Account_Name__c=accounts[0].Id,
						 Customer_Organization_Segment__c='VERIZON WIRELESS INC.');		
		
		system.debug('cq_report before insert--->>'+cq_report);
		reports.add(cq_report);
		database.insert(reports);
		
		
		QuoteReporting_mapTest.put(quotes[0].ID,quotes[0].NokiaCPQ_Proposal_Id__c);
		system.debug('QuoteReporting_mapTest_id-->>'+quotes[0].ID);
		system.debug('QuoteReporting_mapTest_number-->>'+quotes[0].NokiaCPQ_Proposal_Id__c);
		
		system.debug('reports--->'+reports);
		rep_map.put(reports[0].CQ_Number__c, reports[0].Id);
		system.debug('rep_map_number'+reports[0].CQ_Number__c);
		system.debug('rep_map_id'+reports[0].Id);
		
		
		ContentVersion contVersion = TestDataFactory.createContentVersion_New(1,GlobalConstants.Quote_Document)[0];
		contVersion.Title='Quote'+quotes[0].id;
		contVersion.Document_Type_POC__c=GlobalConstants.Quote_Document;  
		database.insert(contVersion);
		system.debug('contVersion'+contVersion);
		
		ContentVersion Conversion  =  [SELECT Id,ContentDocumentId from ContentVersion where Id=:contVersion.Id limit 1];
		contendDocId_list.add(Conversion);
		
		contentDocumentLink  conDocumentLinkVZW = TestDataFactory.createContentDocumentLink_New(1,quotes[0].id,contendDocId_list[0].ContentDocumentId)[0];			
		contentDocumentLink_list.add(conDocumentLinkVZW);
		database.insert(contentDocumentLink_list);
		system.debug('contentDocumentLink_list--->>'+contentDocumentLink_list);
		
		contentDocumentLink filenew = TestDataFactory.createContentDocumentLink_New(2,cqadmingroupTest,contendDocId_list[0].ContentDocumentId)[1];
		filenew.ShareType='C';
		contentDocumentLink_list.add(filenew);
		database.upsert(contentDocumentLink_list);
		system.debug('contentDocumentLink_list--->>'+contentDocumentLink_list);
		
		contentDocumentLink filenew_2 = TestDataFactory.createContentDocumentLink_New(3,reports[0].id,contendDocId_list[0].ContentDocumentId)[2];
		filenew_2.ShareType='V';
		filenew_2.Visibility='AllUsers';
		contentDocumentLink_list.add(filenew_2);
		database.upsert(contentDocumentLink_list);
		system.debug('contentDocumentLink_list--->>'+contentDocumentLink_list);
		
		contentDocumentLink_set.add(filenew_2);
		
		
		system.assertEquals(quotes[0].id, conDocumentLinkVZW.LinkedEntityId);
		system.assertEquals(cqadmingroupTest, filenew.LinkedEntityId);
		system.assertEquals(reports[0].id, filenew_2.LinkedEntityId);
		
		
		test.stopTest();	
	}
	
	static testmethod void Sharecqfileto_CqReportTest(){
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		System.RunAs(userCreation){
			
			//id contentdoc_id='06956000000IMkbAAG';			
			test.startTest(); 
			CQ_ContentDocumentLinkHelper.Sharecqfileto_CqReport(contentDocumentLink_list);
			//CQ_ContentDocumentLinkHelper.FileShareFromCqToReport(contentDocumentLink_set, rep_map);	 
			test.stopTest();
		}
		
	}
	
	/* static testmethod void fileShare(){

user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
insert userCreation;
System.RunAs(userCreation){



test.startTest();	 

contentDocumentLink filenew_2 = TestDataFactory.createContentDocumentLink_New(1,reports[0].id,contendDocId_list[0].ContentDocumentId)[2];
filenew_2.ShareType='V';
contentDocumentLink_list_2.add(filenew_2);
database.insert(contentDocumentLink_list_2);
system.debug('contentDocumentLink_list_2--->>'+contentDocumentLink_list_2);
set<contentDocumentLink> contentDocumentLink_set = new set<contentDocumentLink>();
contentDocumentLink_set.add(filenew_2);	  
CQ_ContentDocumentLinkHelper.FileShareFromCqToReport(contentDocumentLink_set,rep_map);

test.stopTest();


}

} */
}