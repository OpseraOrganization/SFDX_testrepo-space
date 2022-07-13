/****************************************
 * Name : OfferWarningMessageTest
 * Author : Accenture
 * Description : Test class for OfferWarningMessageTest
 *****************************************/
 @istest
 private class OfferWarningMessageTest{

	/******************************
	*Method Name: OfferWarningMessageTest
	*Description: Test Method to cover OfferWarningMessage class
	********************************/
	static testMethod void offerWarningMessageTest(){
		//User creation
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		//insert userCreation;
		system.runAs(userCreation){
			//Creating Accouont
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			database.insert(accountCreation);
			//Creating Opportunity
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
			optyCreation.stageName = 'Win the Case (Negotiate)';
			optyCreation.Phase_Status__c= 'Offer Submitted to Customer (Manual)';
			database.insert(optyCreation);
			test.startTest();
			//creating Offer
			Offer__c offerCreation =  TestDataFactory.OfferCreation(1,optyCreation)[0];
			offerCreation.ActiveOffer__c = true;
			database.insert(offerCreation);
			//calling the class
			OfferWarningMessage.getOfferId(offerCreation.id,offerCreation.id);
			OfferWarningMessage.getOfferId(optyCreation.id,optyCreation.id);
			//Covering Exception
			OfferWarningMessage.getOfferId(NULL,null);
			test.stopTest();
		}
	 }

	 /******************************
	Test method for verifyOfferTeamTricornRoles
	********************************/
	static testMethod void verifyOfferTeamTricornRolesTest(){
		//User creation
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		system.runAs(userCreation){
			//Creating Accouont
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			database.insert(accountCreation);
			//Creating Opportunity
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
			database.insert(optyCreation);
			//creating Offer
			test.startTest();
			Offer__c offerCreation =  TestDataFactory.OfferCreation(1,optyCreation)[0];
			offerCreation.ActiveOffer__c = true;
			database.insert(offerCreation);
			String message = OfferWarningMessage.verifyOfferTeamTricornRoles(offerCreation.Id);
			System.assert(message == GlobalConstants.OFFER_TEAM_INCOMPLETE_WARNING);
			test.stopTest();
			Offer_Team__c teamMember = TestDataFactory.offerTeamCreation(1, offerCreation, userCreation)[0];
			teamMember.Team_Member_Role__c = 'Account Manager (TRICORN Sales Case Owner (SCO))';
			database.insert(teamMember);
			//calling the class
			OfferWarningMessage.verifyOfferTeamTricornRoles(accountCreation.Id);
			message = OfferWarningMessage.verifyOfferTeamTricornRoles(offerCreation.Id);
			System.assert(message == GlobalConstants.OFFER_TEAM_INCOMPLETE_WARNING);

		}
	 }
}