@isTest
/*******************************
	Created by: Accenture
	Created Date: 20 Dec 2018
	Last Modified By: Accenture 
	Last Modified Date: 29 Jan 2018
	Description: This class is used for Apex Class CCRE_AcceptClickFieldUpdate Test coverage
	*******************************/
public class CCRE_AcceptClickFieldUpdateTest {

 /*****************************
	*Method Name: getStatusDeatilsTest
	*Description: This method is used for test coverage of getStatusDeatils method
	*Parameters: 
	*******************************/ 
	public static Id swxRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal').getRecordTypeId();
	public testmethod static void getStatusDeatilsTest(){
		
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
		quoteProposal.RecordTypeId=swxRecordTypeId;
		quoteProposal.Apttus_Proposal__Opportunity__c = oppty.id;
		database.insert(quoteProposal); 
		Test.stopTest();
	   CCRE_AcceptClickFieldUpdate.getStatusDeatils(quoteProposal.Id);
		database.delete(quoteProposal);
		CCRE_AcceptClickFieldUpdate.getStatusDeatils(quoteProposal.Id); 
	}
	
	
 /*****************************
	*Method Name: getStatusUpdateTest
	*Description: This method is used for test coverage of getStatusUpdate method
	*Parameters: 
	*******************************/   
	public testmethod static void getStatusUpdateTest(){
	   
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
		quoteProposal.Apttus_Proposal__Opportunity__c = oppty.id;
		quoteProposal.NokiaCPQ_Portfolio__c = 'IP Routing';
		//quoteProposal.NokiaCPQ_SSP_Level__c = 'Unlimited'; 
		quoteProposal.RecordTypeId=swxRecordTypeId;
		database.insert(quoteProposal); 
		Test.stopTest();
		String Approval_Stage=CSWXGlobalConstant.Approval_stage_published;
		String Rejection_Reason=CSWXGlobalConstant.Rejection_Reasons;
		CCRE_AcceptClickFieldUpdate.getStatusUpdate(quoteProposal.Id, Approval_Stage, Rejection_Reason);
		database.delete(quoteProposal);
		CCRE_AcceptClickFieldUpdate.getStatusUpdate(quoteProposal.Id, Approval_Stage, Rejection_Reason);

 }

/*****************************
	*Method Name: getDocumentDeatilsTest
	*Description: This method is used for test coverage of getDocumentDeatils method
	*Parameters: 
	*******************************/
   public testmethod static void getDocumentDeatilsTest(){
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
	   quoteProposal.Apttus_Proposal__Opportunity__c = oppty.id;
	   quoteProposal.NokiaCPQ_Portfolio__c = 'IP Routing';
	   //quoteProposal.NokiaCPQ_SSP_Level__c = 'Unlimited';
	   quoteProposal.RecordTypeId=swxRecordTypeId;
	   quoteProposal.Analytics_Source__c='CCRE';
	   database.insert(quoteProposal); 
	   Test.stopTest();
	   product2 product= TestDataFactory.productCreation(1)[0];
	   product.name='Emergency Remote Support';
	   product.Business_Group__c='MN';
	   database.insert(product);
	  
	   ContentDocumentLink contentlink = new ContentDocumentLink();
	   ContentVersion contentVersion = new ContentVersion();
	   contentVersion = TestDataFactory.createContentVersion(1)[0];
	   database.insert(contentVersion) ; 
	   ContentVersion conVersion = [SELECT ContentDocumentId,Title FROM ContentVersion where ID =: contentVersion.Id LIMIT 1];  
	   contentlink = TestDataFactory.createContentDocumentLink(1,quoteProposal.Id,conVersion.contentdocumentid)[0];
	   try{
	   database.insert(contentlink);
	   CCRE_AcceptClickFieldUpdate.getDocumentDeatils(quoteProposal.Id);
	   quoteProposal.Analytics_Source__c='CXM';
	   database.update(quoteProposal);
	   CCRE_AcceptClickFieldUpdate.getDocumentDeatils(quoteProposal.Id);
	   database.delete(quoteProposal);
	   CCRE_AcceptClickFieldUpdate.getDocumentDeatils(quoteProposal.Id);
	   }
	   catch(Exception e){
		   System.debug(e);
	   }
 }
}