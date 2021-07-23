@isTest
public without sharing class CreateOfferApexCtlrTest {
	
	static testmethod void getOpptyTest()
	{
		User userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		system.runas(userCreation){
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
			insert optyCreation;
			Opportunity oppty = CreateOfferApexCtlr.getOppty(optyCreation.Id);
			Opportunity oppty1 = CreateOfferApexCtlr.getOppty(Null);
			List<OpportunityTeamMember> opptyTeamMemberList = TestDataFactory.optyTeamMemberCreation(2,userCreation,optyCreation);
			opptyTeamMemberList[0].OpportunityAccessLevel = GlobalConstants.READ;
			database.insert(opptyTeamMemberList);
			Test.startTest();
			List<OfferTeamWrapper> wrapperList1 = CreateOfferApexCtlr.getOpptyTeam(optyCreation.Id);
			
			opptyTeamMemberList[0].TeamMemberRole = GlobalConstants.PRICING_MANAGER_OFFER_TEAM_ROLE;
			opptyTeamMemberList[1].TeamMemberRole = GlobalConstants.PRICING_MANAGER_OFFER_TEAM_ROLE;
			opptyTeamMemberList[1].Additional_Team_Role__c = GlobalConstants.BID_MANAGER_OFFER_TEAM_ROLE;
			List<OfferTeamWrapper> wrapperList2 = CreateOfferApexCtlr.getOpptyTeam(optyCreation.Id);
			
			Offer__c offerCreation = TestDataFactory.OfferCreation(1,optyCreation)[0];
			String offerId = CreateOfferApexCtlr.saveOffer(offerCreation);
			String offerId1 = CreateOfferApexCtlr.saveOffer(Null);
			Test.stopTest();
		}
	}
	
	static testmethod void saveOpptyTest()
	{
		User userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		system.runas(userCreation){
			Test.startTest();
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
			optyCreation.G2_Planned_Date__c = system.today();
			optyCreation.G3_Planned_Date__c = system.today()+1;
			optyCreation.G4_Planned_Date__c = system.today()+2;
			optyCreation.G5_Planned_Date__c = system.today()+3;
			insert optyCreation;
			Test.stopTest();
			optyCreation.G4_Planned_Date__c = system.today()+3;
			String returnMessage = CreateOfferApexCtlr.saveOppty(optyCreation );
			try{
	String returnMessage1 = CreateOfferApexCtlr.saveOppty(null);
				optyCreation.G4_Planned_Date__c = system.today();
	String returnMessage2 = CreateOfferApexCtlr.saveOppty(optyCreation);
			}catch(Exception ex){
	String message = ex.getMessage();
	system.assert(message.contains('The Gate Planned Date entered is either blank, in the past, precedes the date entered for the previous gate or exceeds the date entered for the following gate.'), 'message=' + message);
			}
		}
	}
	
	static testmethod void getUserTest()
	{
		User userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		system.runas(userCreation){
			User usr = CreateOfferApexCtlr.getUser(userCreation.Id);
			List<User> usrList = CreateOfferApexCtlr.getAllUserList(userCreation.Name);
			Test.startTest();
			User usr1 = CreateOfferApexCtlr.getUser(Null);
			List<User> usrList1 = CreateOfferApexCtlr.getAllUserList(Null);
			Test.stopTest();
		}
	}
	
	static testmethod void saveOfferandOfferTeamTest()
	{
		User userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		system.runAs(userCreation){
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
			insert optyCreation;
			Opportunity oppty = CreateOfferApexCtlr.getOppty(optyCreation.Id);
			Opportunity oppty1 = CreateOfferApexCtlr.getOppty(Null);
			Offer__c offerCreation = TestDataFactory.OfferCreation(1,optyCreation)[0];
			Test.startTest();
			String offerId = CreateOfferApexCtlr.saveOffer(offerCreation);
			OfferTeamWrapper wrapper= new OfferTeamWrapper();
			wrapper.userId = userCreation.Id;
			wrapper.offerAccess = 'Read/Write';
			wrapper.teamRole = 'Account Manager';
			wrapper.additionalTeamRole = 'Bid Manager';
			wrapper.userName = 'Piyush';
			List<OfferTeamWrapper> wrapperList = new List<OfferTeamWrapper>();
			wrapperList.add(wrapper);
			String wrpLst = JSON.serialize(wrapperList);
			CreateOfferApexCtlr.getAllLeadBGOfOfferTeam();
			CreateOfferApexCtlr.saveOfferTeam(wrpLst,offerId);
			List<OfferTeamWrapper> wrap = CreateOfferApexCtlr.offerTeamPrMValidation(wrpLst,optyCreation.Id);
			Test.stopTest();
		}
	}
	
	static testmethod void coverAllPicklistValuesTest()
	{
		User userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		system.runas(userCreation){
			Test.startTest();
			map<String, String> loALevelMap = CreateOfferApexCtlr.getAllExpectedLoALevel();
			map<String, String> teamMemberMap = CreateOfferApexCtlr.getAllTeamMemberRole();
			map<String, String> addTeamMemberMap = CreateOfferApexCtlr.getAllAdditionalTeamMemberRole();
			map<String, String> accessLevelMap = CreateOfferApexCtlr.getAllAccessLevel();
			map<String, String> teamRoleMap = CreateOfferApexCtlr.getAllTeamMemberRoleMap();
			List<OfferTeamWrapper> wrapperList1 = CreateOfferApexCtlr.getOpptyTeam(null);
			Test.StopTest();
		}
	}
}