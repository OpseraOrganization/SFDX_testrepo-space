@isTest
public without sharing class CreateOfferApexCtlrTest {

	static testmethod void getOpptyTest()
	{
		User userCreation = TestDataFactory.userCreation(1,GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		insert userCreation;
		system.runas(userCreation){
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
			Test.startTest();
			insert optyCreation;
			CreateOfferApexCtlr.getOppty(optyCreation.Id);
			CreateOfferApexCtlr.getOppty(Null);
			List<OpportunityTeamMember> opptyTeamMemberList = TestDataFactory.optyTeamMemberCreation(2,userCreation,optyCreation);
			opptyTeamMemberList[0].OpportunityAccessLevel = GlobalConstants.READ;
			database.insert(opptyTeamMemberList);
			CreateOfferApexCtlr.getOpptyTeam(optyCreation.Id);

			opptyTeamMemberList[0].TeamMemberRole = GlobalConstants.PRICING_MANAGER_OFFER_TEAM_ROLE;
			opptyTeamMemberList[1].TeamMemberRole = GlobalConstants.PRICING_MANAGER_OFFER_TEAM_ROLE;
			opptyTeamMemberList[1].Additional_Team_Role__c = GlobalConstants.BID_MANAGER_OFFER_TEAM_ROLE;
			CreateOfferApexCtlr.getOpptyTeam(optyCreation.Id);
			Test.stopTest();
			Offer__c offerCreation = TestDataFactory.OfferCreation(1,optyCreation)[0];
			CreateOfferApexCtlr.saveOffer(offerCreation);
			//CreateOfferApexCtlr.saveOffer(Null);

		}
	}

	static testmethod void saveOpptyTest()
	{
		User userCreation = TestDataFactory.userCreation(1,GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
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
			CreateOfferApexCtlr.saveOppty(optyCreation );
			try{
	CreateOfferApexCtlr.saveOppty(null);
	optyCreation.G4_Planned_Date__c = system.today();
	CreateOfferApexCtlr.saveOppty(optyCreation);
			}catch(Exception ex){
	String message = ex.getMessage();
	system.assert(message.contains('The Gate Planned Date entered is either blank, in the past, precedes the date entered for the previous gate or exceeds the date entered for the following gate.'), 'message=' + message);
			}
		}
	}

	static testmethod void getUserTest()
	{
		User userCreation = TestDataFactory.userCreation(1,GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		insert userCreation;
		system.runas(userCreation){
			CreateOfferApexCtlr.getUser(userCreation.Id);
			CreateOfferApexCtlr.getAllUserList(userCreation.Name);
			Test.startTest();
			CreateOfferApexCtlr.getUser(Null);
			CreateOfferApexCtlr.getAllUserList(Null);
			Test.stopTest();
		}
	}

	static testmethod void saveOfferandOfferTeamTest()
	{
		User userCreation = TestDataFactory.userCreation(1,GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		insert userCreation;
		system.runAs(userCreation){
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
			insert optyCreation;
			CreateOfferApexCtlr.getOppty(optyCreation.Id);
			CreateOfferApexCtlr.getOppty(Null);
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
			CreateOfferApexCtlr.offerTeamPrMValidation(wrpLst,optyCreation.Id, offerId);
			CreateOfferApexCtlr.getOfferTeam(offerCreation.id);
			Test.stopTest();
		}
	}

	static testmethod void coverAllPicklistValuesTest()
	{
		User userCreation = TestDataFactory.userCreation(1,GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		insert userCreation;
		system.runas(userCreation){
			Test.startTest();
			CreateOfferApexCtlr.getAllTeamMemberRole();
			CreateOfferApexCtlr.getAllAdditionalTeamMemberRole();
			CreateOfferApexCtlr.getAllAccessLevel();
			CreateOfferApexCtlr.getAllTeamMemberRoleMap();
			CreateOfferApexCtlr.getOpptyTeam(null);
			Test.StopTest();


		}
	}
}