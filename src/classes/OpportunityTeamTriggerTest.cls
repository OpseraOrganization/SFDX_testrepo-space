/****************************************
 * Name : OpportunityTeamTriggerTest 
 * Author : Accenture
 * Description : Test class for OpportunityTeamTrigger, OpportunityTeamHandler and OpportunityTeamTriggerHelper
 *****************************************/
@istest
Private class OpportunityTeamTriggerTest {
	public static List<User> userList = new List<User>();	
	public static List<OpportunityTeamMember> opportunityTeamMemberList = new List<OpportunityTeamMember>();	
	public static List<Account> accountList = new List<Account>();
	public static Id userId;		
	public static List<Opportunity> opportunityList = new List<Opportunity>();
	Private static List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
	Private static Map<Id, OpportunityTeamMember> opptyTeamNewMap;
	Private static Map<Id, OpportunityTeamMember> opptyTeamOldMap;
	/******************************
	*Method Name: changeOnOTMsTest
	*Description: Test Method to cover change on Opportunity Team 
	********************************/
	static testMethod void changeOnOTMsTest(){
		GlobalConstants.RUN_CONTENTDOCUMENTLINK_TRIGGER_ON_FILESHARING = false;			
		GlobalConstants.RUN_CONTENTDOCUMENT_TRIGGER_ON_FILESHARING = false;		
		GlobalConstants.RUN_OPPORTUNITYTEAM_TRIGGER_ON_FILESHARING = false;
		GlobalConstants.RUN_OFFERTEAM_TRIGGER_ON_FILESHARING = false;
		GlobalConstants.RUN_USERTERRITORY2ASSOCIATION_TRIGGER_ON_FILESHARING = false;
		userList = TestDataFactory.userCreation(3, 'System Administrator');
		Test.startTest();
		userList[0].NSA_Compliant__c = True;
		userList[0].Restriction_Level__c = 'Unrestricted';
		userList[1].Restriction_Level__c = 'Unrestricted';
		userList[2].Restriction_Level__c = 'Unrestricted';
		Database.insert(userList);						
		System.runAs(userList[0]){
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			userId = userList[0].Id;
			accountList = TestDataFactory.createAccount(1);
			accountList[0].Customer_Compliance__c = 'US_Govern';
			database.insert(accountList);
			opportunityList = TestDataFactory.OpportunityCreation(1,accountList[0]);
			database.insert(opportunityList);								   
			opportunityTeamMemberList = TestDataFactory.optyTeamMemberCreation(1, userList[0], opportunityList[0]);
			database.insert(opportunityTeamMemberList); 
			opptyTeamOldMap = new Map<Id, OpportunityTeamMember>();
			opptyTeamOldMap.put(opportunityTeamMemberList[0].Id, opportunityTeamMemberList[0]);
			OpportunityTeamMember opptyTeamObj = new OpportunityTeamMember();
			opptyTeamObj = [SELECT OpportunityAccessLevel,OpportunityId,UserId FROM OpportunityTeamMember WHERE Id IN:opportunityTeamMemberList limit 1];
			opptyTeamObj.OpportunityAccessLevel = 'Read';
			database.update(opptyTeamObj);
			opptyTeamNewMap = new Map<Id, OpportunityTeamMember>();
			opptyTeamNewMap.put(opptyTeamObj.Id, opptyTeamObj);
			database.delete(opportunityTeamMemberList);
			opportunityTeamMemberList = TestDataFactory.optyTeamMemberCreation(2, userList[0], opportunityList[0]);
			OpportunityTeamHelper.restrictOTM(opportunityTeamMemberList);
			OpportunityTeamHelper.changeOnOTMs(null);
			OpportunityTeamHelper.restrictOTM(null);
			OpportunityTeamHelper.insertIntoDeleted_OTM(opportunityTeamMemberList); 
			OpportunityTeamHelper.CheckNSACompliantAccount(null); 
			Test.stopTest();
		}
	}  
	static testMethod void restrictSameTeamandAdditionalTeamRoleTest(){
		OpportunityTeamMember optyTeam= new OpportunityTeamMember();
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		userCreation.Restriction_Level__c = 'Unrestricted';
		insert userCreation;
		test.startTest();
		system.runAs(userCreation)
		{
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
			insert optyCreation;
			optyTeam = TestDataFactory.optyTeamMemberCreation(1,userCreation,optyCreation)[0];
			optyTeam.TeamMemberRole = 'Account Manager';
			optyTeam.Additional_Team_Role__c= 'Bid Manager';
			insert(optyTeam);
			test.stopTest();
		}
	}
	static testMethod void oppTeamPrMValidationTest(){
		OpportunityTeamMember optyTeam= new OpportunityTeamMember();
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		userCreation.Restriction_Level__c = 'Unrestricted';
		insert userCreation;
		system.runAs(userCreation)
		{
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.L4Name__c = 'Market India';
			insert accountCreation;
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
			insert optyCreation;
			test.startTest();
			
			Sales_Role__c SR = NF_TestDataFactory.createSalesRole(userCreation,'NSNC_PrMBG','Market India','4 - BG Pricing Manager');
			insert SR;
			optyTeam = TestDataFactory.optyTeamMemberCreation(1,userCreation,optyCreation)[0];
			optyTeam.TeamMemberRole = 'Pricing Manager';
			insert(optyTeam);
			test.stopTest();
		}
		
	}
	static testMethod void QuoteShareTest(){
		list<OpportunityTeamMember> optyTeam= new list<OpportunityTeamMember>();
		list<user> userCreation = NOKIA_CPQ_TestDataFactory.userCreation(2,'System Administrator');
		insert userCreation;
		system.runAs(userCreation[0])
		{
			list<Account> accountRec = NOKIA_CPQ_TestDataFactory.getAccounts(1);
			insert accountRec;
			list<Opportunity> optyRec = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accountRec);
			optyRec[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Direct Sales Opportunity').getRecordTypeId(); 
			insert optyRec;
			list<Apttus_Proposal__Proposal__c> proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(2);
			for(Apttus_Proposal__Proposal__c proposal : proposals){
				proposal.Apttus_Proposal__Account__c = accountRec[0].Id;
				proposal.Apttus_Proposal__Opportunity__c = optyRec[0].Id;
				proposal.NokiaCPQ_Needs_Reprice__c = false;
				proposal.Reprice_In_Progress__c = false;
				proposal.RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Direct Quote').getRecordTypeId(); //direct quote
				proposal.NokiaCPQ_Portfolio__c='Nokia Software';
			}
			insert proposals;  
			optyTeam = TestDataFactory.optyTeamMemberCreation(1,userCreation[1],optyRec[0]);
			insert optyTeam;
		}
	}
}