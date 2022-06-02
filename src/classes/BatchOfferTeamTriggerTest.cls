/**
* @description: Test Class to Test Batch and OfferTeamTrigger
* @author:	Accenture IDC.
*
* ============================================================================
* History:
* -------
* 
* VERSION AUTHOR		  DATE		DETAIL										  FEATURES/CSR/TTP
* 1.0				   26/01/2017   Sprint 4 Doc Stretegy & LoA requirements.
* ============================================================================ 
*/
@isTest
private class BatchOfferTeamTriggerTest {/*
	
	@testsetup
	static void setUpFucnction(){
		CreateCustomSetting();
	}
	/**********************************************************************************************************************
* author: Accenture
* Date: Jan-2017
* Param: 
* Return: 
* Description: Test Method To Create and  offer Team and other Required data
* High Level Process : 
**********************************************************************************************************************/ 
 /*   private static testMethod void dataInsertTest(){
		
		User user = createUser();
		createUserTerritory2Association();
		List<Account> accList = TestDataFactory.createAccount(1);
		Database.insert(accList);
		List<Opportunity> opp = TestDataFactory.OpportunityCreation(1,accList[0]);
		Database.insert(opp);
		opp[0].StageName = 'Create Offer (Bid)';
		Database.update (opp); 
		List<Offer__c> offer = TestDataFactory.OfferCreation(1,opp[0]);
		Database.insert(offer);
		Offer_Team__c offerTeam = new Offer_Team__c();
		offerTeam.Offer__c = offer[0].id;
		offerTeam.Name__c = user.Id;
		offerTeam.Offer_Access__c = 'Read Only';
		offerTeam.Team_Member_Role__c = 'Bid Manager';
		List<Document__c> doc =  TestDataFactory.documentCreation(2, offer[0].id,'Offer__c','Restricted','G6 Material');
		Database.insert(doc);
		List<ObjectTerritory2Association> Ota = TestDataFactory.assigningAccountToTerritory(1,accList[0],territoryCreate());
		Database.insert(Ota);
		Test.StartTest();
		Database.insert(offerTeam);
		Test.StopTest();
	}
	
		/**********************************************************************************************************************
* author: Accenture
* Date: Jan-2017
* Param: 
* Return: 
* Description: Test Trigger
* High Level Process : 
**********************************************************************************************************************/ 
  /*  private static testMethod void testTrigger(){
		//CreateCustomSetting();
		User user = createUser();
		createUserTerritory2Association();
		List<Account> accList = TestDataFactory.createAccount(1);
		Database.insert(accList);
		List<Opportunity> opp = TestDataFactory.OpportunityCreation(1,accList[0]);
		Database.insert(opp);
		opp[0].StageName = 'Create Offer (Bid)';
		Database.update (opp); 
		List<Offer__c> offer = TestDataFactory.OfferCreation(1,opp[0]);
		Database.insert(offer);
		List<User> userList = new List<User>();
		List<Offer_Team__c> offerTeamList = new List<Offer_Team__c>();
		userList = TestDataFactory.userCreation(2, 'Nokia Sales Profile');
		Database.insert(userList);
		list<Offer_Team__c> offTeam = new list<Offer_Team__c>();
		offTeam = TestDataFactory.offerTeamCreation(1, offer[0], userList[0]);	
		offerTeamList.addAll(offTeam);
		offTeam = TestDataFactory.offerTeamCreation(1, offer[0], userList[1]);	  
		offerTeamList.addAll(offTeam);
		//Database.insert(offerTeamList);
		List<Document__c> doc =  TestDataFactory.documentCreation(2, offer[0].id,'Offer__c','Restricted','G6 Material');
		Database.insert(doc);
		List<ObjectTerritory2Association> Ota = TestDataFactory.assigningAccountToTerritory(1,accList[0],territoryCreate());
		Database.insert(Ota);					
		Test.StartTest();
		Database.insert(offerTeamList);
		offerTeamList[0].Offer_Access__c = 'Read Only';		
		Database.update(offerTeamList);
		offerTeamList[0].Offer_Access__c = 'Read Only';		
		Database.update(offerTeamList);
		OfferTeamHelper.offerTeamRecordShare(Null);			   
		Test.StopTest();
	}

/**********************************************************************************************************************
* author: Accenture
* Date: Jan-2017
* Param:
* Return: 
* Description: Test Method To delete offer Team
* High Level Process : 
**********************************************************************************************************************/ 
   /* private static testMethod void deleteOfferTeamTest(){		
		User user = createUser();
		createUserTerritory2Association();
		List<Account> accList = TestDataFactory.createAccount(1);
		Database.insert(accList);
		List<Opportunity> opp = TestDataFactory.OpportunityCreation(2,accList[0]);
		Database.insert(opp);
		opp[0].StageName = 'Create Offer (Bid)';
		opp[1].StageName = 'Create Offer (Bid)';
		Database.update (opp); 
		List<Offer__c> offer = TestDataFactory.OfferCreation(2,opp[0]);
		Database.insert(offer);
		Offer_Team__c offerTeam = new Offer_Team__c();
		offerTeam.Offer__c = offer[0].id;
		offerTeam.Name__c = user.Id;
		offerTeam.Offer_Access__c = 'Read Only';
		offerTeam.Team_Member_Role__c = 'Bid Manager';
		Database.insert(offerTeam);
		List<Document__c> doc =  TestDataFactory.documentCreation(2, offer[0].id,'Offer__c','Restricted','G6 Material');
		Database.insert(doc);
		Test.StartTest();
		Database.delete (offerTeam);
		Test.StopTest();
	}
/**********************************************************************************************************************
* author: Accenture
* Date: Jan-2017
* Param: List<Offer_Team__c>
* Return: 
* Description: Test Method To delete Two offer Team
* High Level Process : 
**********************************************************************************************************************/ 
	
 /*   private static testMethod void deleteTwoOfferTeamTest(){		
		User user = createUser();
		createUserTerritory2Association();
		List<Offer_Team__c> offerTeamList = new List<Offer_Team__c>();
		List<Account> accList = TestDataFactory.createAccount(1);
		Database.insert(accList);
		List<Opportunity> opp = TestDataFactory.OpportunityCreation(2,accList[0]);
		Database.insert(opp);
		opp[0].StageName = 'Create Offer (Bid)';
		Database.update (opp);
		List<Offer__c> offer = TestDataFactory.OfferCreation(2,opp[0]);
		Database.insert(offer);
		Offer_Team__c offerTeam = new Offer_Team__c();
		Offer_Team__c offerTeam2 = new Offer_Team__c();
		offerTeam.Offer__c = offer[0].id;
		offerTeam.Name__c = user.Id;
		offerTeam.Offer_Access__c = 'Read Only';
		offerTeam.Team_Member_Role__c = 'Bid Manager';
		offerTeam2.Offer__c = offer[1].id;
		offerTeam2.Name__c = user.Id;
		offerTeam2.Offer_Access__c = 'Read Only';
		offerTeam2.Team_Member_Role__c = 'Bid Manager';
		offerTeamList.add(offerTeam);
		offerTeamList.add(offerTeam2);
		List<ObjectTerritory2Association> Ota = TestDataFactory.assigningAccountToTerritory(1,accList[0],territoryCreate());
		Database.insert(Ota);
		List<Document__c> doc =  TestDataFactory.documentCreation(2, offer[0].id,'Offer__c','Restricted','G6 Material');
		Database.insert(doc);
		Test.StartTest();
		Database.insert(offerTeamList);
		Database.delete (offerTeamList);
		Test.StopTest();
	}
/**********************************************************************************************************************
* author: Accenture
* Date: Jan-2017
* Param: 
* Return: 
* Description: Method To Create UserTerritory2Association
* High Level Process : 
**********************************************************************************************************************/ 
  /*  private static  void  createUserTerritory2Association(){
		Id territoryId_1 = TestDataFactory.getL7TerritoryId();
		
		User user = createUser();
		List<UserTerritory2Association> userTerritory2AssociationList = TestDataFactory.assigningUserToTerritory(1,user,territoryId_1 );
		System.runAs(user){
			Database.insert(userTerritory2AssociationList);
		}
		
		
	}
/**********************************************************************************************************************
* author: Accenture
* Date: Jan-2017
* Param: 
* Return: 
* Description: Method To Create territory2
* High Level Process : 
**********************************************************************************************************************/ 
	/*public static  id  territoryCreate(){
		List<Territory2> territoryIdList = [SELECT Id,ParentTerritory2Id,Name,Territory2ModelId,DeveloperName,Territory2TypeId,Hierarchy_Level__c FROM Territory2 where Hierarchy_Level__c = 'L7' and territory2Model.state = : GlobalConstants.TERRITORY2MODEL_STATE_ACTIVE limit 1] ;
		
		return territoryIdList[0].Id;
	}
/**********************************************************************************************************************
* author: Accenture
* Date: Jan-2017
* Param: 
* Return: 
* Description: Method To Create user
* High Level Process : 
**********************************************************************************************************************/ 
/*	private static user createUser(){		
		List<User> userList = new List<User>();
		userList = TestDataFactory.userCreation(1, 'Nokia Sales Profile');
		Database.insert(userList);
		return userList[0];
	}

/**********************************************************************************************************************
* author: Accenture
* Date: Jan-2017
* Param: 
* Return: 
* Description: Test Method To insert offerTeam with duplicate user
* High Level Process : 
**********************************************************************************************************************/	 
 /*   private static testMethod void duplicateUserTest(){
	   // CreateCustomSetting();
		User user = createUser();
		createUserTerritory2Association();
		List<Account> accList = TestDataFactory.createAccount(1);
		Database.insert(accList);
		List<Opportunity> opp = TestDataFactory.OpportunityCreation(2,accList[0]);
		Database.insert(opp);
		opp[1].StageName = 'Create Offer (Bid)';
		Database.update (opp);
		List<Offer__c> offer = TestDataFactory.OfferCreation(2,opp[0]);
		Database.insert(offer);
		List<Offer_Team__c> offerTeamList = new List<Offer_Team__c>();
		Offer_Team__c offerTeam = new Offer_Team__c();
		Offer_Team__c offerTeam2 = new Offer_Team__c();
		offerTeam.Offer__c = offer[0].id;
		offerTeam.Name__c = user.Id;
		offerTeam.Offer_Access__c = 'Read/Write';
		offerTeam.Team_Member_Role__c = 'Bid Manager';
		offerTeam2.Offer__c = offer[1].id;
		offerTeam2.Name__c = user.Id;
		offerTeam2.Offer_Access__c = 'Read Only';
		offerTeam2.Team_Member_Role__c = 'Bid Manager';
		offerTeamList.add(offerTeam);
		offerTeamList.add(offerTeam2);
		List<ObjectTerritory2Association> Ota = TestDataFactory.assigningAccountToTerritory(1,accList[0],territoryCreate());
		Database.insert(Ota);
		List<Document__c> doc =  TestDataFactory.documentCreation(2, offer[0].id,'Offer__c','Restricted','G6 Material');
		Database.insert(doc);
		Test.StartTest();
		Database.insert(offerTeamList);
		Test.StopTest();
	}
/**********************************************************************************************************************
* author: Accenture
* Date: Jan-2017
* Param: 
* Return: 
* Description: Method To Create  customSetting 
* High Level Process : 
**********************************************************************************************************************/	 
   /*  public static void CreateCustomSetting(){
		List<File_Sharing_Custom_Setting__c> customSettingList = new List<File_Sharing_Custom_Setting__c> ();
		customSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		Database.insert(customSettingList);
		
	}
*/}