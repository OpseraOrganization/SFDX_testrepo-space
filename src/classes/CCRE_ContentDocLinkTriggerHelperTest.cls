/****************************************
* Name : CCRE_ContentDocLinkTriggerHelperTest
* Author : Accenture

*****************************************/
@isTest
public class CCRE_ContentDocLinkTriggerHelperTest {

	public static Id swxRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('SWx Upsell Proposal').getRecordTypeId();
	public static Id ccreRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('CCRE Upsell Proposal').getRecordTypeId();
	public static Id swxQuoteRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal').getRecordTypeId();

	static testmethod void shareDocumentTest(){
		
	  User sysAdminUser = TestDataFactory.createSystemAdminUser();
	  System.runAs(sysAdminUser){
	  Account acct = TestDataFactory.createAccount(1)[0];
	  acct.AccountNumber='8990767834';  
	  database.insert(acct);
	 
	  List <ContentDocumentLink> contentdoclist = new list<ContentDocumentLink>();
	  File_Upload__c fu = new File_Upload__c();
	  fu.Technology__c=CSWXGlobalConstant.Technology ;
	  fu.Account__c = acct.id;
	  insert fu;
	
	  
	  ContentVersion contentVersion = new ContentVersion();
	  ContentDocumentLink contentlink = new ContentDocumentLink();
	  ContentDocumentLink contentlink_DP = new ContentDocumentLink();
	  ContentDocumentLink contentlink_QP = new ContentDocumentLink();
	  contentVersion = TestDataFactory.createContentVersion(1)[0];  
		 
	  contentVersion.title = CSWXGlobalConstant.InstalledBase;
	  database.insert(contentVersion) ;		 
	  
	  Id theContentDocumentId = [select ContentDocumentId from ContentVersion where Id =: contentVersion.Id limit 1].ContentDocumentId;
		 
	  contentlink = TestDataFactory.createContentDocumentLink(1,acct.id, theContentDocumentId)[0];
	  contentlink.LinkedEntityId=fu.id;
	  contentlink.Visibility= 'InternalUsers';
	  database.insert(contentlink) ; 
	
	  contentdoclist.add(contentlink) ; 
	  Test.startTest(); 
	  CCRE_ContentDocumentLinkTriggerHandler.afterInsert(contentdoclist);
	  Test.stopTest();
		}
			
	}
	
	
public static testmethod void restrictUploadTest(){
		
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
	  DigitalProposal.RecordTypeID=swxRecordTypeId;
	  DigitalProposal.Sold_To_Party__c=acct.id;
	  
	  insert DigitalProposal;
		 
	  Test.startTest(); 
	  List <ContentDocumentLink> contentdoclinklist = new list<ContentDocumentLink>();
	  ContentVersion contentVersion = new ContentVersion();
	  ContentDocumentLink contentlink = new ContentDocumentLink();
	  contentVersion = TestDataFactory.createContentVersion(1)[0];  
		 
	  contentVersion.title = CSWXGlobalConstant.Benchmarking;
	  database.insert(contentVersion) ;		 
	  
	  Id theContentDocumentId = [select ContentDocumentId from ContentVersion where Id =: contentVersion.Id limit 1].ContentDocumentId;
	
	
	  contentlink = TestDataFactory.createContentDocumentLink(1,acct.id, theContentDocumentId)[0];
	  contentlink.LinkedEntityId=DigitalProposal.id;
	  database.insert(contentlink) ; 
	  contentdoclinklist.add(contentlink) ;
	
	 
	  CCRE_ContentDocumentLinkTriggerHandler.afterInsert(contentdoclinklist);
	  Test.stopTest();
	  
	
		}
			
	}
   
	public static testmethod void restrictUploadfor_qpTest(){
		
	 User sysAdminUser = TestDataFactory.createSystemAdminUser();
   
	 System.runAs(sysAdminUser){
			
	 Account acct = TestDataFactory.createAccount(1)[0];
	 acct.AccountNumber='8990767834';  
	 database.insert(acct);
	
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
	 quoteProposal.RecordTypeId=swxQuoteRecordTypeId ;
		 quoteProposal.Analytics_Source__c=CSWXGlobalConstant.AnalyticsSource;
	 database.insert(quoteProposal); 

	  Test.startTest();	  
	  List <ContentDocumentLink> contentdoclinklist = new list<ContentDocumentLink>();
  
	  ContentVersion contentVersion = new ContentVersion();
	  ContentDocumentLink contentlink = new ContentDocumentLink();
	  ContentDocumentLink contentlinkQP = new ContentDocumentLink();
	  contentVersion = TestDataFactory.createContentVersion(1)[0];  
		 
	  contentVersion.title = CSWXGlobalConstant.Benchmarking;
	  database.insert(contentVersion) ;		 
	  
	  Id theContentDocumentId = [select ContentDocumentId from ContentVersion where Id =: contentVersion.Id limit 1].ContentDocumentId;
	  contentlinkQP = TestDataFactory.createContentDocumentLink(2,acct.id, theContentDocumentId)[1];
	  contentlinkQP.LinkedEntityId=quoteProposal.id;
	  database.insert(contentlinkQP) ; 
	  contentdoclinklist.add(contentlinkQP);
	
	 
	  CCRE_ContentDocumentLinkTriggerHandler.afterInsert(contentdoclinklist);
	  List <ContentDocumentLink> contentdoclinklist2 = new list<ContentDocumentLink>();
	  contentdoclinklist2.add(null);
	  CCRE_ContentDocumentLinkTriggerHandler.afterInsert(contentdoclinklist2);
	  Test.stopTest();
		 
		}
			
	} 
	  

}