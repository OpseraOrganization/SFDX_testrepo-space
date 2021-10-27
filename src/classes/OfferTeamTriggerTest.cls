/****************************************
* Name : OfferTeamTriggerTest 
* Author : Accenture
* Description : Test class for OfferTeamTrigger, OfferTeamHandler and OfferTeamHelper
*****************************************/
@istest
public class OfferTeamTriggerTest {
	/******************************
*Method Name: offerTeamFileShareTest
*Description: Test Method to cover offerTeamFileShare and offerTeamFileDelete method
********************************/
	static testMethod void offerTeamFileShareTest(){
		List<User> userList = new List<User>();
		List<Offer_Team__c> offerTeamMemberList = new List<Offer_Team__c>();
		List<Offer__c> offerList = new List<Offer__c>();
		List<OpportunityTeamMember> opportunityTeamMemberList1 = new List<OpportunityTeamMember>();
		List<Account> accountList = new List<Account>();
		List<ContentDocumentLink>contentDocumentId = new List<ContentDocumentLink>();
		List< ContentDocumentLink>emptyContentDocumentId = new List<ContentDocumentLink>();
		Id userId;
		Id linkedEntityId;
		Set<Id> opportunityId = new Set<Id>();
		List<Opportunity> opportunityList = new List<Opportunity>();

		userList = TestDataFactory.userCreation(1, 'System Administrator');
		userList[0].Restriction_Level__c = 'Unrestricted';
		database.insert(userList);
		system.runAS(userList[0]){
			userId = userList[0].Id;
			accountList = TestDataFactory.createAccount(1);
			database.insert(accountList);
			opportunityList = TestDataFactory.OpportunityCreation(1,accountList[0]);
			database.insert(opportunityList[0]);
			opportunityList[0].StageName = 'Win the Case (Negotiate)';
			opportunityList[0].Phase_Status__c = 'Offer Submitted to Customer (Manual)';
			//database.update(opportunityList[0]);
			
			offerList = TestDataFactory.OfferCreation(1, opportunityList[0]);
			database.insert(offerList);
			Test.startTest();
			ContentVersion  conVersionVar = TestDataFactory.createContentVersion_New(1,'Bid Directive')[0];
			database.insert(conVersionVar);			
			ContentVersion conVersion = [SELECT ContentDocumentId,Document_Type_POC__c FROM ContentVersion 
											   where ID =: conVersionVar.Id  LIMIT 1];			
			//creating contentDocumentLink
			ContentDocumentLink conDocumentLink = TestDataFactory.createContentDocumentLink_New(1,offerList[0].Id,conVersion.ContentDocumentId)[0];
			conDocumentLink.ContentDocumentId = conVersion.ContentDocumentId;
			database.insert(conDocumentLink);			  
			contentDocumentId = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: userId];
			//System.assertEquals(contentDocumentId,emptyContentDocumentId);
			
			offerTeamMemberList = TestDataFactory.offerTeamCreation(1, offerList[0],userList[0]);
			database.insert(offerTeamMemberList);
			database.update(offerTeamMemberList);
			contentDocumentId = [SELECT LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId =: userId];   
			database.delete(offerTeamMemberList);
			offerTeamMemberList = TestDataFactory.offerTeamCreation(2, offerList[0], userList[0]); 
			Test.stopTest();
		}
	}
	
	static testMethod void offerTeamPrMValidationTest(){
		Offer_Team__c offerTeam = new Offer_Team__c();
		//List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		userCreation.Restriction_Level__c = 'Unrestricted';
		insert userCreation;
		system.runAs(userCreation)
		{
			//fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			//database.insert(fileSharingCustomSettingList);
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.L4Name__c = 'Market India';
			insert accountCreation;
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
			insert optyCreation;
			
			test.startTest();
			Sales_Role__c SR = NF_TestDataFactory.createSalesRole(userCreation,'NSNC_PrMBG','Market India','4 - BG Pricing Manager');
			insert SR;
			Offer__c offer = TestDataFactory.OfferCreation(1, optyCreation)[0];
			insert offer;
			
			offerTeam = TestDataFactory.offerTeamCreation(1,offer,userCreation)[0];
			offerTeam.Team_Member_Role__c = 'Pricing Manager';
			
			insert(offerTeam);
			test.stopTest();
		}
	}
}