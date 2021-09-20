/****************************************
* Class Name : OfferActivationHandlerTest
* Created Date: 21st October 2016
* Created By : Accenture
* Last Modified by: Accenture
* Last Modified Date: 28 Nov 2016
* Description : This is the test class to cover OfferActivationHandler
*****************************************/
@isTest(seealldata = false)
private class OfferActivationHandlerTest{
	/****************************************
* Method Name: validateOfferActivation
* Description : Test method to cover OfferActivationHandler
*****************************************/
	static testMethod void validateOfferActivation(){
		user userCreation = TestDataFactory.userCreation(1,GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		insert userCreation;
		System.RunAs(userCreation){

			List<Account> accList = TestDataFactory.createAccount(1);
			accList[0].Name = 'Test Acc';
			database.insert(accList);

			List<Opportunity> oppList = TestDataFactory.OpportunityCreation(2,accList[0]);
			database.insert(oppList);
			oppList[0].StageName = GlobalConstants.WIN_THE_CASE_NEGOTIATE;
			oppList[0].Phase_Status__c = GlobalConstants.OFFER_SUBMITTED_TO_CUSTOMER_MANUAL;
			oppList[0].Probability = 10;
			oppList[1].StageName = GlobalConstants.WIN_THE_CASE_NEGOTIATE;
			oppList[1].Phase_Status__c = GlobalConstants.OFFER_SUBMITTED_TO_CUSTOMER_MANUAL;
			oppList[1].Probability = 10;
			Test.startTest();
			List<Offer__c> offerList = TestDataFactory.OfferCreation(3,oppList[0]);
			offerList[0].Activeoffer__c = true;
			offerList[1].Activeoffer__c = false;
			offerList[2].Activeoffer__c = false;
			database.insert(offerList);
			offerList[2].Activeoffer__c = true;
			database.update(offerList);
			//Exception
			OfferActivationHelper.onBeforeInsert(NULL);
			OfferActivationHelper.validate(NULL,NULL);
			Test.stopTest();
		}
	}

	/******************************
*Method Name: cloneTeamTest
*Description: Test Method to cover CloneOfferTeam class
********************************/
	static testMethod void cloneTeamTest(){
		user userCreation = TestDataFactory.userCreation(1,GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		database.insert(userCreation);
		system.runAs(userCreation){

			Account accountCreation = TestDataFactory.createAccount(1)[0];
			database.insert(accountCreation);
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
			database.insert(optyCreation);
			optyCreation.StageName = GlobalConstants.WIN_THE_CASE_NEGOTIATE;
			optyCreation.Phase_Status__c = GlobalConstants.OFFER_SUBMITTED_TO_CUSTOMER_MANUAL;
			optyCreation.Probability = 10;
			OpportunityTeamMember optyTeamCreation = TestDataFactory.optyTeamMemberCreation(1,userCreation,optyCreation)[0];
			database.insert(optyTeamCreation);
			test.startTest();
			Offer__c offerCreation = TestDataFactory.OfferCreation(1,optyCreation)[0];
			offerCreation.ActiveOffer__c  = true;
			database.insert(offerCreation);
			List<Offer__c> offerList = new List<Offer__c>();
			offerList.add(offerCreation);

			test.stoptest();
		}
	}

	/****************************************
* Method Name: deleteOffer
* Description : Test method to cover OfferActivationHandler
*****************************************/
	static testMethod void deleteOffer(){
		Offer__c offerCreation = new Offer__c();
		user userCreation = TestDataFactory.userCreation(1,GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		database.insert(userCreation);
		user userCreationOtherProfile = TestDataFactory.userCreation(1,'Global Process Admin Profile')[0];
		database.insert(userCreationOtherProfile );

		System.runAs(userCreation){
			Account acc = TestDataFactory.createAccount(1)[0];
			database.insert(acc);
			Opportunity opp = TestDataFactory.OpportunityCreation(1,acc)[0];
			opp.StageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
			opp.Phase_Status__c = 'Planned';
			opp.Sales_Outcome__c = 'Obsolete';
			opp.Sales_Outcome_Reason__c = 'Commercial';
			database.insert(opp);
			Test.startTest();
			offerCreation = TestDataFactory.OfferCreation(1,opp)[0];
			offerCreation.ActiveOffer__c = true;
			insert offerCreation;
		}


		System.runAs(userCreationOtherProfile ){
			try{
	List<Offer__c> offerListDelete = new List<Offer__c>();
	offerListDelete=[Select id from Offer__c where id =: offerCreation.Id ];
	system.debug('offerCreation>>>>'+offerCreation);
	delete offerListDelete;
			}catch(Exception e){
	Boolean expectedExceptionThrown = e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') ? true : false;
	System.assertEquals(expectedExceptionThrown, true);
			}
		}
		Test.stopTest();
	}
		/****************************************
* Method Name: restrictManualChangingSSOTOAttachedTest
* Description : Test method to cover OfferActivationHandler
*****************************************/
	static testMethod void restrictManualChangingSSOTOAttachedTest(){
		user userCreation = TestDataFactory.userCreation(1,GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		insert userCreation;
		System.RunAs(userCreation){
			Account acc = TestDataFactory.createAccount(1)[0];
			database.insert(acc);

			Opportunity opp = TestDataFactory.OpportunityCreation(1,acc)[0];
			database.insert(opp);

			Offer__c offerCreation = TestDataFactory.OfferCreation(1,opp)[0];
			offerCreation.ActiveOffer__c = true;
			//offerCreation.Expected_LoA_G4_Approval_Level__c = 'C';//JOTATR
			insert offerCreation;

			Test.startTest();
			OfferActivationHelper.restrictManualChangingSSOTOAttached(null,null);
			Test.stopTest();
		}
	}
}