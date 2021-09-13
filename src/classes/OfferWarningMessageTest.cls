/****************************************
 * Name : OfferWarningMessageTest
 * Author : Accenture
 * Description : Test class for OfferWarningMessageTest
 *****************************************/
 @istest
 private class OfferWarningMessageTest{

	 Private static List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();

	/******************************
	*Method Name: OfferWarningMessageTest
	*Description: Test Method to cover OfferWarningMessage class
	********************************/
	static testMethod void OfferWarningMessageTest(){
		//User creation
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		system.runAs(userCreation){
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
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
			//offerCreation.LoA_Bypass__c = 'No LoA';
			offerCreation.Expected_LoA_G4_Approval_Level__c = 'C';//JOTATR
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
			Offer__c offerCreation =  TestDataFactory.OfferCreation(1,optyCreation)[0];
			offerCreation.ActiveOffer__c = true;
			database.insert(offerCreation);
			//calling the class
			test.startTest();
			String message = OfferWarningMessage.verifyOfferTeamTricornRoles(offerCreation.Id);
			System.assert(message == GlobalConstants.OFFER_TEAM_INCOMPLETE_WARNING);
			test.stopTest();
		}
	 }
}