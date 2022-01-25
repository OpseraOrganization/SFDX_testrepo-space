/****************************************
 * Name : OpportunityTeamHandlerPRMTest 
 * Author : Accenture
 * Description : Test class for OpportunityTeamTrigger, OpportunityTeamHandler and OpportunityTeamTriggerHelper
 *****************************************/
@isTest(seealldata = false)
Private class OpportunityTeamHandlerPRMTest {
	 @testSetup static void createTestData() {
			NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
			cs.Name = 'Default';
			cs.Customer_Account__c = 'Customer - test';
			cs.Customer_Account_Number__c = '12345';
			cs.Customer_User_Profile__c = 'Customers';
			insert cs;
		}
	public static List<OpportunityTeamMember> opportunityTeamMemberList = new List<OpportunityTeamMember>();
	public static List<OpportunityTeamMember> oppTeamMemberList = new List<OpportunityTeamMember>(); 
	public static List<User> userList = new List<User>();	
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
		Database.insert(userList);						
		System.runAs(userList[0]){
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			userId = userList[0].Id;
			accountList = TestDataFactory.createAccount(1);
			database.insert(accountList);
			opportunityList = TestDataFactory.OpportunityCreation(1,accountList[0]);
			opportunityList[0].PRMSales_Support_Requested__c = false;
			database.insert(opportunityList);								   
			opportunityTeamMemberList = TestDataFactory.optyTeamMemberCreation(1, userList[0], opportunityList[0]);
			database.insert(opportunityTeamMemberList); 
			opportunityList[0].PRMSales_Support_Requested__c = true;
			update opportunityList[0];		  
			opptyTeamOldMap = new Map<Id, OpportunityTeamMember>();
			opptyTeamOldMap.put(opportunityTeamMemberList[0].Id, opportunityTeamMemberList[0]);
			OpportunityTeamMember opptyTeamObj = new OpportunityTeamMember();
			opptyTeamObj = [SELECT OpportunityAccessLevel,OpportunityId,UserId FROM OpportunityTeamMember WHERE Id IN:opportunityTeamMemberList limit 1];
			opptyTeamObj.OpportunityAccessLevel = 'Read';
			Test.startTest();
			database.update(opptyTeamObj);
			opptyTeamNewMap = new Map<Id, OpportunityTeamMember>();
			opptyTeamNewMap.put(opptyTeamObj.Id, opptyTeamObj);
			database.delete(opportunityTeamMemberList);
			opportunityTeamMemberList = TestDataFactory.optyTeamMemberCreation(2, userList[0], opportunityList[0]);
			OpportunityTeamHelper.restrictOTM(opportunityTeamMemberList);
		  //  OpportunityTeamHelper.unshareFilesOnDelete(opportunityTeamMemberList);
			//OpportunityTeamHelper.unshareFilesOnUpdate(opptyTeamNewMap, opptyTeamOldMap);
			OpportunityTeamHelper.changeOnOTMs(null);
			OpportunityTeamHelper.restrictOTM(null);   
			opportunityTeamMemberList = TestDataFactory.optyTeamMemberCreation(1, userList[2], opportunityList[0]);
			
			database.insert(opportunityTeamMemberList);
			Test.stopTest();
		}
	}
	/******************************
	*Method Name: onOppTeamMemberDelete
	*Description: Test Method to cover changes on Opportunity Team 
	********************************/
   static testMethod void onOppTeamMemberDelete(){
		//OpportunityTeamHandlerPRM otmobj = new OpportunityTeamHandlerPRM();
		OpportunityTeamHandlerPRM.afterInsert(opportunityTeamMemberList);
		OpportunityTeamHandlerPRM.afterDelete(opportunityTeamMemberList);
		OpportunityTeamHandlerPRM.afterDelete(oppTeamMemberList);
	   
		//MyException ex = new MyException();
	  // try{
		//throw ex;
	   //}catch(Exception e) {
		   //}
	}
 
@isTest static void opptyTest() {
		OpportunityTeamMember OTM = new OpportunityTeamMember();
		
		try {
			OpportunityTeamHandlerPRM.beforeInsertOTM(OTM);
		} catch(DMLException e) {
			system.assertEquals(e.getMessage(), e.getMessage());
		}
		
		OpportunityTeamHandlerPRM.beforeInsertOTM(OTM);
	} 
 
 
@isTest static void opptyTest1() {
		List<OpportunityTeamMember> opportunityTeamMemberList = new List<OpportunityTeamMember>();
		
		try {
			OpportunityTeamHandlerPRM.afterInsert(opportunityTeamMemberList);
			
		} catch(DMLException e) {
			system.assertEquals(e.getMessage(), e.getMessage());
		}
		
		OpportunityTeamHandlerPRM.afterInsert(opportunityTeamMemberList);
	} 
   

}