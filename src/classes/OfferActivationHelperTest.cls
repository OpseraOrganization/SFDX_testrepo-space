/****************************************
* Name : OfferActivationHelperTest
* Author : Accenture
* Description : Test class for OfferActivationHelper
*****************************************/
@isTest
public class OfferActivationHelperTest {
	public static Offer__c offerObj;
	public static Offer__c offerObj1;
	public static Opportunity opportunityObj;
	public static Opportunity referenceOpportunityObj;
	public static Account accountObj;
	public static Offer__c updateOfferObj;
	private static Id oppDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
	private static String market = 'Market India';
	private static String roleName = '4 - BG Pricing Manager';
	private static String memberRole = 'Pricing Manager';


	@isTest
	public static void populateHigestOfferNumberOnOffer(){
		List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
		accountObj = new Account();
		accountObj = TestDataFactory.createAccount(1)[0];

		database.insert(accountObj);
		List<Opportunity> opptyList = TestDataFactory.OpportunityCreation(4, accountObj);
		opptyList[0].RecordTypeId= oppDirectRecordTypeId;
		opptyList[0].Reference_Opportunity__c = opptyList[1].id;
		opptyList[0].HighestOfferNumber__c = 12;
		opptyList[2].RecordTypeId= oppDirectRecordTypeId;
		opptyList[2].Reference_Opportunity__c = opptyList[3].id;
		opptyList[2].HighestOfferNumber__c = null;
		//one more list item added to OpptyList by Chaitanya
		insert opptyList;
		test.startTest();

		list<Offer__c> listOff=new list<Offer__c>();
		Offer__c offerObj1 = TestDataFactory.OfferCreation(1, opptyList[0])[0];
		Offer__c offerObj2 = TestDataFactory.OfferCreation(1, opptyList[2])[0];
		listOff.add(offerObj1);
		listOff.add(offerObj2);
		database.insert(listOff);
		try{
			listOff[0].Solution_Sign_Off_New__c = GlobalConstants.Required_Attached;
			database.update(listOff[0]);
		}catch(Exception e){
			Boolean expectedExceptionThrown =  e.getMessage().contains(System.Label.ManualSelectNotAllowed) ? true : false;
			System.assertEquals(expectedExceptionThrown, true);
		}
		test.stopTest();
	}
	@isTest
	public static void populateHigestOfferNumberOnOfferLow(){
		List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
		accountObj = new Account();
		accountObj = TestDataFactory.createAccount(1)[0];
		test.startTest();
		database.insert(accountObj);
		List<Opportunity> opptyList = TestDataFactory.OpportunityCreation(2, accountObj);
		opptyList[0].RecordTypeId= oppDirectRecordTypeId;
		insert opptyList;

		opptyList[0].Reference_Opportunity__c = opptyList[1].id;
		opptyList[0].HighestOfferNumber__c = 8;

		Test.stopTest();


		offerObj = new Offer__c();
		offerObj = TestDataFactory.OfferCreation(1, opptyList[0])[0];
		database.insert(offerObj);

	}
	@isTest
	public static void populateHigestOfferNumberOnOfferNULL(){
		List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
		accountObj = new Account();
		accountObj = TestDataFactory.createAccount(1)[0];
		test.startTest();
		database.insert(accountObj);
		List<Opportunity> opptyList = TestDataFactory.OpportunityCreation(2, accountObj);
		opptyList[0].RecordTypeId= oppDirectRecordTypeId;
		insert opptyList;

		opptyList[0].Reference_Opportunity__c = opptyList[1].id;
		opptyList[0].HighestOfferNumber__c = null;



		offerObj = new Offer__c();
		offerObj = TestDataFactory.OfferCreation(1, opptyList[0])[0];
		database.insert(offerObj);

	}
	@isTest
	public static void populateHigestOfferNumberOnOfferNegative(){
		OfferActivationHelper.PopulateHigestOfferNumberOnOffer(NULL);
		OfferActivationHelper.UpdateHigestOfferNumberOnOppty(NULL);


	}

	@isTest
	public static void onBeforeInsertTest(){
		accountObj = new Account();
		accountObj = TestDataFactory.createAccount(1)[0];

		database.insert(accountObj);
		opportunityObj = new Opportunity();
		opportunityObj = TestDataFactory.OpportunityCreation(1, accountObj)[0];
		opportunityObj.RecordTypeId= oppDirectRecordTypeId;
		test.startTest();
		database.insert(opportunityObj);

		System.debug('opportunityObj'+opportunityObj);
		List<Offer__c> offerList = new List<Offer__c>();
		offerList = TestDataFactory.OfferCreation(2, opportunityObj);
		offerList[0].ActiveOffer__c=true;
		offerList[1].ActiveOffer__c=false;
		database.insert(offerList);
		offerList[0].ActiveOffer__c=false;
		offerList[1].ActiveOffer__c=true;
		database.update(offerList);
		Test.stopTest();
		OfferActivationHelper.onBeforeInsert(NULL);
	}

	@isTest
	public static void marketValidationTest(){
		accountObj = new Account();
		accountObj.Market__c = 'Market Greater China';
		accountObj = TestDataFactory.createAccount(1)[0];

		test.startTest();
		database.insert(accountObj);

		List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
		opportunityObj = new Opportunity();
		opportunityObj = TestDataFactory.OpportunityCreation(1, accountObj)[0];
		opportunityObj.RecordTypeId= oppDirectRecordTypeId;
		opportunityObj.Lead_BG__c = 'MN';
		database.insert(opportunityObj);

		System.debug('opportunityObj'+opportunityObj);

		try{
			offerObj = new Offer__c();
			offerObj = TestDataFactory.OfferCreation(1, opportunityObj)[0];
			offerObj.ActiveOffer__c=true;
			offerObj.LOA_Bypass__c = 'Pre-approved Price List for Account Managers';
			database.insert(offerObj);

			List<Account_Market__c> accMarketList = new List<Account_Market__c>();
			Account_Market__c accMarket = new Account_Market__c();
			accMarket.name ='Market Greater China';
			accMarketList.add(accMarket);

			insert accMarketList;

			System.debug('accMarketList'+accMarketList);
			CustomException testingCatch = new CustomException('This is an error');
			throw testingCatch;
		}catch(Exception e){
			System.debug('Exception ' + e.getMessage())	;
		}
	}

	/****************************************
*Method Name: cloneTeamTest
*Description: Method to cover cloneTeam
*Parameters: none
*****************************************/
	@isTest
	public static void cloneTeamTest(){
		user userCreation = TestDataFactory.userCreation(1,GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		userCreation.Restriction_Level__c = 'Unrestricted';
		insert userCreation;
		List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
		accountObj = new Account();
		accountObj = TestDataFactory.createAccount(1)[0];
		database.insert(accountObj);
		Opportunity oppty = TestDataFactory.OpportunityCreation(1, accountObj)[0];
		oppty.RecordTypeId= oppDirectRecordTypeId;
		insert oppty;
		test.startTest();
		OpportunityTeamMember opptyTeamMember = TestDataFactory.optyTeamMemberCreation(1, userCreation,oppty)[0];
		insert opptyTeamMember;
		Offer__c offer = TestDataFactory.OfferCreation(1, oppty)[0];
		insert offer;
		delete offer;
		Test.stopTest();
	}


	@isTest
	public static void offerLoACurrenyConversion(){
		User sysAdminUser = TestDataFactory.userCreation(1,GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		System.runAs(sysAdminUser){
			List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			accountObj = new Account();
			accountObj = TestDataFactory.createAccount(1)[0];
			accountObj.L4Name__c = market;
			database.insert(accountObj);
			Opportunity opptyList = TestDataFactory.OpportunityCreation(1, accountObj)[0];
			opptyList.RecordTypeId= oppDirectRecordTypeId;
			insert opptyList;

			List<Nokia_Financial_Calendar__c> oNokiaCalender = TestDataFactory.nokiaFinCalCreation(1);
			insert oNokiaCalender[0];

			List<Dated_Exchange_Rates__c> oDateExchangeRate = TestDataFactory.datedExchnageRateCreation(2);
			oDateExchangeRate[0].DER_Period__c=oNokiaCalender[0].id;
			oDateExchangeRate[1].CurrencyIsoCode='EUR';
			oDateExchangeRate[1].DER_Period__c=oNokiaCalender[0].id;
			insert oDateExchangeRate;

			test.startTest();
			List<Offer__c> offerObjList = new List<Offer__c>();
			offerObjList = TestDataFactory.OfferCreation(1, opptyList);
			database.insert(offerObjList);

			offerObjList[0].LoA_Currency__c = 'USD';
			offerObjList[0].Net_Sales_LoA_Base_Case__c = 12;
			update offerObjList;

			offerObjList[0].Net_Sales_LoA_Base_Case__c = 13;
			offerObjList[0].LoA_Currency__c = 'EUR';
			update offerObjList;
			test.StopTest();
		}
	}


	@isTest
	public static void updateLoAByPassDetailsTest(){
		User testUser = NF_TestDataFactory.createAdminUser(GlobalConstants.SYSTEM_AdMINISTRATOR);
		testUser.Restriction_Level__c = 'Unrestricted';
		insert testUser;

		system.runAs(testUser){

			accountObj = new Account();
			accountObj = TestDataFactory.createAccount(1)[0];
			accountObj.L4Name__c = market;
			database.insert(accountObj);
			Opportunity oppty = TestDataFactory.OpportunityCreation(1, accountObj)[0];
			oppty.RecordTypeId= oppDirectRecordTypeId;


			insert oppty;

			Sales_Role__c SR = NF_TestDataFactory.createSalesRole(testUser,'NSNC_PrMBG',market,roleName);
			insert SR;
			test.startTest();
			Offer__c offer = TestDataFactory.OfferCreation(1, oppty)[0];
			insert offer;


			Offer_Team__c offerTeamObj = TestDataFactory.offerTeamCreation(1,offer,testUser)[0];
			offerTeamObj.Team_Member_Role__c = memberRole;
			insert offerTeamObj;

			Map<Id,Offer__c> offerOldMap = new Map<Id,Offer__c>();
			offerOldMap.put(offer.Id,offer);
			offer.LOA_Bypass__c = 'Authorized for Pricing Manager';

			List<offer__c> offerList = new List<Offer__c>();
			offerList.add(offer);
			offeractivationhelper.updateLoAByPassDetails(offerList,offerOldMap);
			test.stopTest();
		}
	}
	@isTest
	public static void PopulateHigestOfferNumberOnOfferTest(){
		User sysAdminUser = TestDataFactory.userCreation(1,'System Administrator')[0];
		System.runAs(sysAdminUser)
		{
			List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);

			accountObj = new Account();
			accountObj = TestDataFactory.createAccount(1)[0];
			accountObj.L4Name__c = market;
			database.insert(accountObj);

			List<Opportunity> opptyList = TestDataFactory.OpportunityCreation(2, accountObj);
			opptyList[0].RecordTypeId= oppDirectRecordTypeId;
			insert opptyList;

			test.startTest();
			List<Offer__c> offerObjList = new List<Offer__c>();
			offerObjList = TestDataFactory.OfferCreation(2, opptyList[0]);
			database.insert(offerObjList);

			Sales_Role__c SR = NF_TestDataFactory.createSalesRole(sysAdminUser,'NSNC_PrMBG',market,roleName);
			insert SR;

			Offer_Team__c offerTeamObj = TestDataFactory.offerTeamCreation(1,offerObjList[0],sysAdminUser)[0];
			offerTeamObj.Team_Member_Role__c = memberRole;
			insert offerTeamObj;

			OfferActivationHelper.PopulateHigestOfferNumberOnOffer(offerObjList);
			test.StopTest();
		}
	}
}