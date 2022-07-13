/****************************************
* Name : OpportunityTriggerHelperTest
* Author : HCL Technologies
* Description : Test class for CloneOfferTeam and OpportunityTriggerHelper
*****************************************/
@istest
private with sharing class OpportunityTriggerHelperTest
{
	private static List<OpportunityTeamMember> opptyTeamMemberList = new List<OpportunityTeamMember>();
	private static Id oppDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
	private static Id oppReadOnlyDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.READ_ONLY_DIRECT_RECORD_TYPE).getRecordTypeId();
	private static Id oppIndirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.Indirect_record_type).getRecordTypeId();
	private static Id readOnlyIndirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.READ_ONLY_INDIRECT_RECORD_TYPE).getRecordTypeId();
	private static List<user> userList = new List<user>();
	private static List<Account> accList = new List<Account>();
	private static List<Opportunity> optyList = new List<Opportunity>();
	private static List<Competitor__c> compList = new List<Competitor__c>();
	private static final Id PSR_ReadOnlyRecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.READ_ONLY_PSR_RECORD_TYPE).getRecordTypeId();
	private static final Id PSR_EditRecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.PSR_RECORD_TYPE).getRecordTypeId();
	private static Id upsellDealRecordTypeId = Schema.SObjectType.Deal__c.getRecordTypeInfosByDeveloperName().get(GlobalConstants.UPSELL_DEAL_RECORD_TYPE).getRecordTypeId();
	private static String market = 'ENERGY AND NATURAL RESOURCES';
	private static String actSector = 'ENR - OIL & GAS';
	private static String country = 'India';
	private static Id legalEntityRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(GlobalConstants.LEGAL_ENTITY_DEVNAME).getRecordTypeId();
	private static String businessPartnerRole = GlobalConstants.DirectResellerPartner; //declare variable to be used on tests - changed for SH2022
	private static String accountRole = GlobalConstants.GPPVARpartner;//declare variable to be used on tests - changed for SH2022

	/******************************
	*Method Name: CurrenychangeTest
	*Description: Test Method to cover : Currenychange , MassupdateonOIFLines
	********************************/
	static testMethod void currenychangeTest(){
		user userCreation = TestDataFactory.userCreation(1, GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		system.runAs(userCreation){
			Nokia_Financial_Calendar__c nokiaFinCalCreation = TestdataFactory.nokiaFinCalCreation(1)[0];
			insert nokiaFinCalCreation;

			Product2 prod = TestDataFactory.productCreation(1)[0];
			prod.Business_Group__c= 'MN';
			prod.Family= null;
			database.insert(prod);

			test.startTest();
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.AccountNumber = '1234';
			database.insert(accountCreation);

			List<Opportunity> optyCreation = TestDataFactory.OpportunityCreation(3, accountCreation);
			optyCreation[0].Sales_Outcome__c='Obsolete';
			optyCreation[0].Sales_Outcome_Reason__c = 'Commercial';
			optyCreation[1].Sales_Outcome__c=GlobalConstants.OPP_LOST_TO_COMPETITOR;
			optyCreation[1].Sales_Outcome_Reason__c = 'Commercial';
			database.insert(optyCreation);

			List<Order_Intake_Forecast__c> oifs = TestDataFactory.orderIntakeCreation(3, optyCreation[0], prod, nokiaFinCalCreation);
			oifs[0].Forecast_Category__c = 'Upside';
			oifs[0].OIF_Value_EUR__c= 1092;
			oifs[1].Forecast_Category__c = 'Upside';
			oifs[1].OIF_Value_EUR__c= 1092;
			oifs[1].Opportunity__c= optyCreation[1].Id;
			oifs[2].Forecast_Category__c = 'Upside';
			oifs[2].OIF_Value_EUR__c= 4092;
			oifs[2].Opportunity__c= optyCreation[2].Id;
			insert oifs;

			OpportunityTriggerHelper.Currenychange(new Map<Id, SObject>(optyCreation).keySet());
			OpportunityTriggerHelper.MassupdateonOIFLines(new Map<Id, SObject>(optyCreation).keySet());
			OpportunityTriggerHelper.MassupdateonOIFLines(null);
			OpportunityTriggerHelper.Currenychange(NULL);
			OpportunityTriggerHelper oppTrigger = new OpportunityTriggerHelper();
			oppTrigger.DeleteAllocationLine(new Set<ID>{optyCreation[0].Id});
			test.stoptest();

		}

	}

	/******************************
	*Method Name: CurrencyUpdateTest
	*Description: Test Method to cover methods: convertionrateupdate , offerPriceChange
	********************************/
	static testMethod void currencyUpdateTest(){
		//List<Apttus_Approval__Approval_Request__c> approvalrequests=new List<Apttus_Approval__Approval_Request__c>();
		List<User> userCreation = TestDataFactory.userCreation(2, GlobalConstants.SYSTEM_AdMINISTRATOR);
		//insert userCreation;
		//userCreation[0].DelegatedApproverId = userCreation[1].id;
		//database.update(userCreation[0]);
		system.runAs(userCreation[0]){
			//List<Opportunity> optylist3 = new List<Opportunity>();
			//Map<id, Opportunity> opptyMap = new Map<id, Opportunity>();
			Nokia_Financial_Calendar__c nokiaFinCalCreation = TestdataFactory.nokiaFinCalCreation(1)[0];
			insert nokiaFinCalCreation;
			Dated_Exchange_Rates__c exchangeRate = TestDataFactory.datedExchnageRateCreation(1)[0];
			exchangeRate.CurrencyIsoCode='USD';
			exchangeRate.DER_Period__c=nokiaFinCalCreation.id;
			database.insert(exchangeRate);

			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.AccountNumber = '301301301';
			database.insert(accountCreation);
			List<Opportunity> optyCreation = TestDataFactory.OpportunityCreation(2, accountCreation);
			optyCreation.get(0).CurrencyIsoCode='USD';
			optyCreation.get(1).CurrencyIsoCode='EUR';
			database.insert(optyCreation);
			test.startTest();

			optyCreation.get(0).Amount=100;
			optyCreation.get(1).Amount=400;
			GlobalConstants.OPPORTUNITYTRIGGER_OFFER_PRICE_CHANGE = false;
			database.update(optyCreation);
/*
			optyCreation.add(optyCreation1);


			List<Opportunity> optylist1 = new List<Opportunity>();
			Opportunity optyCreation2=TestDataFactory.OpportunityCreation(2, accountCreation)[0];
			database.insert(optyCreation2);
			optylist1.add(optyCreation2);
			for(Opportunity oppty:optylist1){
	opptyMap.put(oppty.id,  oppty);
	opptyMap.get(oppty.id).Facilitator_Delegate_1__c = userCreation[0].id;
	opptyMap.get(oppty.id).Facilitator_Delegate_2__c = userCreation[1].id;
	opptyMap.get(oppty.id).Facilitator_Backup__c = userCreation[0].id;
	opptyMap.get(oppty.id).NF_Facilitator_User__c  = userCreation[0].id;
			}
			opptyTeamMemberList = TestDataFactory.optyTeamMemberCreation(1, userCreation[0], optylist1[0]);
			database.insert(opptyTeamMemberList);
			Apttus_Approval__Approval_Request__c approvalrequest =
			NF_TestDataFactory.createApprovalRequest('Not Submitted',  'User',  'Test Object', string.valueOf(optyCreation2.Id),  True,  True,  userCreation[1].Name, string.valueOf(userCreation[1].Id),  'Sub step Name Test');
			approvalrequest.Apttus_Approval__DelegateApproverIds__c=userCreation[1].id;
			approvalrequest.Apttus_Approval__Step_Name__c='G2';
			approvalrequests.add(approvalrequest);
			database.insert(approvalrequests);
			OpportunityTriggerHelper obj = new OpportunityTriggerHelper();
			obj.convertionrateupdate(optyCreation);
			obj.convertionrateupdate(optylist);
			obj.convertionrateupdate(optylist3);
			obj.convertionrateupdate(null);
			//obj.UpdateUserinformation(optylist);*/
			test.stoptest();
		}
	}

	/******************************
	*Method Name: probabilityUpdateTest
	*Description: Test Method to cover method : updateProbabilityOfPSROAsSalesOptyAfterUpdate
	********************************/
	static testMethod void probabilityUpdateTest(){
		user userCreation = TestDataFactory.userCreation(1, GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		//database.insert(userCreation);
		system.runAs(userCreation){
			insert new CRM_Account_to_Bypass_Allocation__c(Name='123');
			List<Account> accountCreation = NF_TestDataFactory.getAccounts(2);
			accountCreation[0].L4Name__c = 'Market Europe';
			accountCreation[1].L4Name__c = 'Market Europe';
			database.insert(accountCreation);
			List<Opportunity> optyCreation = TestDataFactory.OpportunityCreation(1, accountCreation[0]);
			optyCreation[0].StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation[0].Phase_Status__c = GlobalConstants.OPPORTUNITY_IN_PROGRESS;
			List<Opportunity> optyCreation1 = TestDataFactory.OpportunityCreation(1, accountCreation[1]);
			optyCreation1[0].StageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
			optyCreation1[0].Phase_Status__c = 'Planned';
			optyCreation.addAll(optyCreation1);
			database.insert(optyCreation);
			Test.startTest();
			List<Opportunity> psroList = TestDataFactory.preSalesOpportunityCreation(1, accountCreation[0], optyCreation[0]);
			psroList[0].StageName = GlobalConstants.PREPARATION;
			psroList[0].PSR_Pre_Sales_Risk_Opportunity_Type__c = GlobalConstants.RISK_ORDER;
			psroList[0].PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = GLobalConstants.RISK_ORDER_ONLY;
			psroList[0].PSR_Cost_BG_CNS__c = 10;
			psroList[0].PSR_Sales_Value_BG_CNS__c = 10;
			database.insert(psroList);
			//Changing account
			optyCreation[0].AccountId = accountCreation[1].id;
			optyCreation[0].Probability = 35;
			database.update(optyCreation);
			test.stopTest();
		}
	}

	/******************************
	*Method Name: updateOfferswhenG4approvaldateIsUpdatedTest
	*Description: Test Method to cover updateOfferswhenG4approvaldateIsUpdated method from OpportunityTriggerHelper class
	********************************/
	static testMethod void updateOfferswhenG4approvaldateIsUpdatedTest(){
		Map < ID,  Opportunity > opptyMap = new Map < ID,  Opportunity >();
		Map < ID,  List < Offer__c >> oppOfferListMap = new Map < ID,  List < Offer__c >> ();
		List<Offer__c> offerList = new List<Offer__c>();
		user userCreation = TestDataFactory.userCreation(1, GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		//database.insert(userCreation);
		system.runAs(userCreation){
			//Creating Account
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			database.insert(accountCreation);
			//Creating Opportunity
			List<Opportunity> optyCreation = TestDataFactory.OpportunityCreation(2, accountCreation);
			optyCreation[1].StageName = GLobalConstants.WIN_THE_CASE_NEGOTIATE;
			optyCreation[1].phase_status__c= GlobalConstants.OFFER_SUBMITTED_TO_CUSTOMER_MANUAL;
			optyCreation[1].G4_Approval_Date__c = system.today();
			optyCreation[1].LOA_Level__c = 'A';
			database.insert(optyCreation);
			Test.startTest();
			//Creating Offer
			//Offer__c offerCreation = TestDataFactory.OfferCreation(1, optyCreation)[0];
			//offerCreation.ActiveOffer__c = True;
			//offerList.add(offerCreation);
			//insert offerList;
			//oppOfferListMap.put(offerCreation.Opportunity__c, offerList);
			//opptyMap.put(offerCreation.Opportunity__c,  optyCreation);
			//Calling the class
			optyCreation[0].Reference_Opportunity__c = optyCreation[1].Id;
			update optyCreation[0];
			Offer__c offer = TestDataFactory.OfferCreation(1, optyCreation[0])[0];
			offer.ActiveOffer__c = True;
			offer.LOA_Bypass__c = 'No LoA';
			insert offer;
			optyCreation[0].G4_Approval_Date__c = system.today();
			update optyCreation[0];
			Test.stopTest();
		}
	}
/*
	static testMethod void afterUpdateOppnotifyHSSERiskCountryDirect(){
		Test.startTest();
		OpportunityTriggerHelper obj = new OpportunityTriggerHelper();
		obj.sendEmail(null, null, null);
		Test.stopTest();
	}

*/
/******************************
*Method Name: testNotifyHSSERiskCountry
*Description: Test Method to cover : notifyHSSERiskCountry
********************************/
	static testMethod void testNotifyHSSERiskCountry(){

		List<user> userList1 = new List<user>();
		userList1 = TestDataFactory.userCreation(1, GlobalConstants.SYSTEM_AdMINISTRATOR) ;
		database.insert(userList1);
		system.runas(userList1[0]){
			insert new Risk_Country__c(Country__c='India', ISO_Code__c='IN',Name='Test',HighRisk__c=true);
			List<Schema.Document> docList = TestDataFactory.getDocument();
			database.insert(doclist);
			List<Account> accList2 = new List<Account>();
			List<Opportunity> optyList1 = new List<Opportunity>();
			List<OpportunityTeamMember> optyTeamMember = new List<OpportunityTeamMember>();

			//Create Account
			accList2 = TestDataFactory.createAccount(1);
			accList2[0].CountryNameISO2__c ='IN';
			database.insert(accList2);

			//Create Opty
			optyList1 = TestDataFactory.OpportunityCreation(3, accList2[0]);
			optyList1[0].RecordTypeId= oppDirectRecordTypeId;
			optyList1[0].country__C = 'India';
			optyList1[0].G3_Approval_Date__c = System.today();
			optyList1[0].StageName = GlobalConstants.CREATE_OFFER;
			optyList1[0].Phase_Status__c  = GlobalConstants.OFFER_IN_PROGRESS;
			database.insert(optyList1);
			Test.startTest();
			//Create Team Member
			optyTeamMember = TestDataFactory.optyTeamMemberCreation(1, userList1[0], optyList1[0]);
			optyTeamMember[0].TeamMemberRole =  GlobalConstants.PROJECTEXECUTIONOWNER;
			database.insert(optyTeamMember);
			OpportunityTriggerHelper.notifyHSSERiskCountry(optyList1);
			Test.stopTest();
		}
	}
	/*
	static testMethod void afterUpdateOppnotifyHSSERiskCountryDirectWoCMD(){
		Test.startTest();
		List<user> userList2 = new List<user>();
		userList2 = TestDataFactory.userCreation(1, GlobalConstants.SYSTEM_AdMINISTRATOR) ;
		database.insert(userList2);
		system.runas(userList2[0]){
			List<Account> accList3 = new List<Account>();
			List<Opportunity> optyList2 = new List<Opportunity>();
			List<OpportunityTeamMember> optyTeamMember = new List<OpportunityTeamMember>();
			//Create Account
			accList3 = TestDataFactory.createAccount(1);
			database.insert(accList3);
			//Create Opty
			optyList2 = TestDataFactory.OpportunityCreation(3, accList3[0]);
			optyList2[0].RecordTypeId= oppDirectRecordTypeId ;
			optyList2[0].country__C = 'India';
			optyList2[0].StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyList2[0].Phase_Status__c = GlobalConstants.OPPORTUNITY_IN_PROGRESS;
			database.insert(optyList2);
			//Insert OptyTeamMember
			optyTeamMember = TestDataFactory.optyTeamMemberCreation(1, userList2[0], optyList2[0]);
			optyTeamMember[0].TeamMemberRole = GlobalConstants.PROJECTEXECUTIONOWNER;
			database.insert(optyTeamMember);

			optyList2[0].StageName = GlobalConstants.CREATE_OFFER;
			optyList2[0].Phase_Status__c  = GlobalConstants.OFFER_IN_PROGRESS;
			database.update(optyList2);
			OpportunityTriggerHelper.notifyHSSERiskCountry(optyList2);
			test.StopTest();
		}
	}
	static testMethod void afterUpdateOppnotifyHSSERiskCountryIndirect(){
		SendTo__c sendToCS = new SendTo__c();
		sendToCS.Name = 'test';
		database.insert(sendToCS);
		Risk_Country__c riskCountry = new Risk_Country__c();
		riskCountry.Name = 'India';
		riskCountry.ISO_Code__c = 'IN';
		riskCountry.ExtremeRisk__c = true;
		riskCountry.HighRisk__c = false;
		riskCountry.LowRisk__c = false;
		database.insert(riskCountry);
		List<user> userList3 = new List<user>();
		userList3 = TestDataFactory.userCreation(1, GlobalConstants.SYSTEM_AdMINISTRATOR) ;
		database.insert(userList3);

		system.runas(userList3[0]){
			Test.startTest();
			//Insert Account
			List<Account> accList4 = new List<Account>();
			List<Opportunity> opptyList = new List<Opportunity>();
			accList4 = TestDataFactory.createAccount(1);
			accList4[0].BusinessPartnerRole__c = GlobalConstants.Alliance;
			database.insert(accList4);
			//Insert Opty
			opptyList = TestDataFactory.OpportunityCreation(1, accList4[0]);
			opptyList[0].RecordTypeId= oppIndirectRecordTypeId ;
			opptyList[0].Country__c = 'India';
			opptyList[0].Account_Role__c = GlobalConstants.AlliancePartner;
			opptyList[0].G3_Approval_Date__c = system.now();
			opptyList[0].StageName = GlobalConstants.CREATE_OFFER;
			opptyList[0].Phase_Status__c  = GlobalConstants.OFFER_IN_PROGRESS;
			opptyList[0].Business_Type__c = GlobalConstants.STANDARDOPPORTUNITY;
			opptyList[0].End_Customer_Information__c = GlobalConstants.EC_INFO_MULTI;
			opptyList[0].Multiple_or_Unknown_EC_Activity_Sector__c = actSector;
			opptyList[0].Multiple_or_Unknown_EC_Country__c = country;
			opptyList[0].Multiple_or_Unknown_EC_Market_Segment__c = market;
			database.insert(opptyList);
			Opportunity oppty = [Select Id,  End_Customer__c from Opportunity where Id = :opptyList[0].Id];
			database.update(new Account(Id= oppty.End_Customer__c,  CountryNameISO2__c = 'IN'));
			OpportunityTriggerHelper.notifyHSSERiskCountry(opptyList);
			OpportunityTriggerHelper.notifyHSSERiskCountry(null);
			Test.stoptest();
		}
	}
*/

	/*
	static testMethod void beforeInsertUpdateRecordTypeWhenPreSaleTypeIsOtherThanRSRO(){

		List<user> userList5 = new List<user>();
		userList5 = TestDataFactory.userCreation(1, GlobalConstants.SYSTEM_AdMINISTRATOR) ;
		database.insert(userList5);
		system.runas(userList5[0]){
			test.startTest();

			List<Account> accList6 = new List<Account>();
			List<Opportunity> optyList5 = new List<Opportunity>();

			//Create Account
			accList6 = TestDataFactory.createAccount(1);
			database.insert(accList6);

			//Create Opty
			optyList5 = TestDataFactory.OpportunityCreation(3, accList6[0]);
			optyList5[0].RecordTypeId= oppDirectRecordTypeId ;
			optyList5[0].country__C = 'India';
			optyList5[0].StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyList5[0].Phase_Status__c = GlobalConstants.OPPORTUNITY_IN_PROGRESS;
			database.insert(optyList5);
			Test.stopTest();

		}
	}*/
/******************************
*Method Name: validatevalidateRefOpptyAndPTASignedTest
*Description: Test Method to cover : validateRefOpptyAndPTASigned
********************************/
/*	static testMethod void validatevalidateRefOpptyAndPTASignedTest(){
		//Creating User
		User sysAdminUser = TestDataFactory.userCreation(1, GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		System.runAs(sysAdminUser){
			//List<user> userCreation = TestDataFactory.userCreation(2, GlobalConstants.SYSTEM_AdMINISTRATOR);
			//insert userCreation;
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;
			//Creating Opportunity
			list<Opportunity> optyCreation = TestDataFactory.OpportunityCreation(2, accountCreation);
			optyCreation[1].PTA_Signed__c = true;
			//optyCreation[0].Gate_3_Bypass_no_offer_support__c = true;
			//optyCreation[0].PTA_Signed__c = false;
			//optyCreation[0].Blanket_Approval_Condition__c='Blanket Approval for T&C';
			insert optyCreation;
			//system.runAs(userCreation[0]){
	//Craeting Account
	Test.startTest();
	//Updating opportunity with PTA= False and stage to 'Handover (Prepare for Delivery)'
	//Offer__c offerCreation = TestDataFactory.OfferCreation(1, optyCreation[0])[0];
	//offerCreation.ActiveOffer__c = true;
	//offerCreation.No_LoA__c = true;
	//insert offerCreation;
			try{
	optyCreation[0].Gate_6_Bypass_No_Execute_needed__c = false;
		optyCreation[0].StageName = 'Handover (Prepare for Delivery)';
	optyCreation[0].Phase_Status__c = 'PTA (PROJECT TARGET AGREEMENT) HANDOVER TO DELIVERY/OPERATIONS';
	optyCreation[1].Gate_6_Bypass_No_Execute_needed__c = true;
	update optyCreation;
	test.stopTest();
			}catch(Exception ex){
	System.debug(ex.getMessage());
			}
	 // }
		}
	}	*/
/******************************
*Method Name: checkLEIsEmptyTest
*Description: Test Method to cover : checkLEIsEmpty
********************************/
	static testMethod void checkLEIsEmptyTest(){
		user userCreation = TestDataFactory.userCreation(1, GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		insert userCreation;
		system.runAs(userCreation){
			Test.startTest();
			list <Account> accountCreation = NF_TestDataFactory.getAccounts(2);
			accountCreation[1].RecordTypeId=legalEntityRecordType;
			insert accountCreation;
			accountCreation[1].ParentId = accountCreation[0].Id;
			update accountCreation[1];
			// Oppty Creation
			list <Opportunity> optyCreation = TestDataFactory.OpportunityCreation(2, accountCreation[0]);
			optyCreation[0].StageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
			optyCreation[0].Phase_Status__c = GlobalConstants.PLANNED;
			optyCreation[0].RecordTypeId = oppIndirectRecordTypeId;
			optyCreation[0].Account_Role__c = accountRole;
			optyCreation[0].Business_Type__c = GlobalConstants.STANDARDOPPORTUNITY;
			optyCreation[0].Legal_Entity__c = accountCreation[1].Id;
			optyCreation[0].End_Customer_Information__c = GlobalConstants.EC_INFO_MULTI;
			optyCreation[0].Multiple_or_Unknown_EC_Activity_Sector__c = actSector;
			optyCreation[0].Multiple_or_Unknown_EC_Country__c = country;
			optyCreation[0].Multiple_or_Unknown_EC_Market_Segment__c = market;
			optyCreation[1].StageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
			optyCreation[1].Phase_Status__c = GlobalConstants.PLANNED;
			optyCreation[1].RecordTypeId = oppIndirectRecordTypeId;
			optyCreation[1].Account_Role__c = accountRole;
			optyCreation[1].Business_Type__c = GlobalConstants.STANDARDOPPORTUNITY;
			optyCreation[1].Legal_Entity__c = accountCreation[1].Id;
			optyCreation[1].End_Customer_Information__c = GlobalConstants.EC_INFO_MULTI;
			optyCreation[1].Multiple_or_Unknown_EC_Activity_Sector__c = actSector;
			optyCreation[1].Multiple_or_Unknown_EC_Country__c = country;
			optyCreation[1].Multiple_or_Unknown_EC_Market_Segment__c = market;
			insert optyCreation;
			Map<Id, Opportunity> oldOptyMap = new Map<Id, Opportunity>();
			accountCreation[1].ParentId = null;
			update accountCreation[1];
			optyCreation[0].Legal_Entity__c = null;
			optyCreation[1].Legal_Entity__c = null;
			update optyCreation ;
			list <Opportunity> optyCreation1 = TestDataFactory.OpportunityCreation(2, accountCreation[0]);
			optyCreation1[0].StageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
			optyCreation1[0].Phase_Status__c = 'Planned';
			optyCreation1[0].RecordTypeId = oppIndirectRecordTypeId;
			optyCreation1[0].Business_Type__c = GlobalConstants.STANDARDOPPORTUNITY;
			optyCreation1[0].Legal_Entity__c = accountCreation[1].Id;
			optyCreation1[1].StageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
			optyCreation1[1].Phase_Status__c = 'Planned';
			optyCreation1[1].RecordTypeId = oppIndirectRecordTypeId;
			optyCreation1[1].Business_Type__c = GlobalConstants.STANDARDOPPORTUNITY;
			optyCreation1[1].Legal_Entity__c = accountCreation[1].Id;
			oldOptyMap.put(optyCreation[0].id,  optyCreation1[0]);
			oldOptyMap.put(optyCreation[1].id,  optyCreation1[1]);

			Map<Id, Opportunity> newOptyMap = new Map<Id, Opportunity>(optyCreation);

			OpportunityTriggerHelper obj = new OpportunityTriggerHelper();
			Map<Id,Account> accountsInfo = obj.getAccountsInfo(newOptyMap.values(), oldOptyMap);
			obj.checkLEIsEmpty(newOptyMap.values(), oldOptyMap,accountsInfo);
			obj.checkLEIsEmpty(Null, null, null);
			Test.stopTest();
		}
	}
/* ALREADY COVERED ON OTHER
	static testMethod void offerPriceChangeTest(){
		//Creating User
		User userCreation = TestDataFactory.userCreation(1, GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		//insert userCreation;
		System.runAs(userCreation){
			//Account Creation
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;

			//Creating Opportunity
			List<Opportunity> optyCreation = TestDataFactory.OpportunityCreation(1, accountCreation);
			optyCreation[0].RecordTypeId = oppDirectRecordTypeId;
			optyCreation[0].Amount = 1000;
			insert optyCreation;

			//Updating opportunity with PTA= False and stage to 'Handover (Prepare for Delivery)'
			//Offer__c offerCreation = TestDataFactory.OfferCreation(1, optyCreation[0])[0];
			//offerCreation.Price__c = 900;
			//offerCreation.ActiveOffer__c = true;
			//insert offerCreation;
			Test.startTest();
			/*
			Map<Id, Opportunity> oldOptyMap = new Map<Id, Opportunity>(new List<Opportunity>{optyCreation[0]});
			Opportunity clone = optyCreation[0].clone(true, true, true, true);
			clone.Id = optyCreation[0].Id;
			clone.Amount = 1111;
			Map<Id, Opportunity> newOptyMap = new Map<Id, Opportunity>(new List<Opportunity>{clone});
			GlobalConstants.OPPORTUNITYTRIGGER_OFFER_PRICE_CHANGE = false;
			OpportunityTriggerHelper obj = new OpportunityTriggerHelper();
			obj.offerPriceChange(newOptyMap.values(),  oldOptyMap);

			Test.stopTest();
		}
	}
*/
/******************************
*Method Name: decisionUpdateTest
*Description: Test Method to cover : DecisonUpdate
********************************/
	static testMethod void decisionUpdateTest(){
		//Creating User
		User userCreation = TestDataFactory.userCreation(1, GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		//insert userCreation;
		System.runAs(userCreation){
			Nokia_Financial_Calendar__c nokiaFinCalCreation = TestdataFactory.nokiaFinCalCreation(1)[0];
			insert nokiaFinCalCreation;
			//Account Creation
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;
			//Creating Opportunity
			List<Opportunity> optyCreation = TestDataFactory.OpportunityCreation(1, accountCreation);
			optyCreation[0].RecordTypeId = oppDirectRecordTypeId;
			optyCreation[0].Amount = 1000;
			insert optyCreation;
			Test.startTest();
			optyCreation[0].StageName = GlobalConstants.CANCELLED_BY_CUSTOMER;
			update optyCreation;
			/*
			OpportunityTriggerHelper obj = new OpportunityTriggerHelper();
			obj.DecisonUpdate(optyCreation);
			obj.DecisonUpdate(null);
			//FollowOpportunity
			obj.FollowOpportunity(NULL);
*/

			Test.stopTest();
		}
	}
/******************************
*Method Name: chatterPostToAccountmanagerTest
*Description: Test Method to cover : chatterPostToAccountManager
********************************/
	static testMethod void chatterPostToAccountmanagerTest(){
		//User creation
		list<user> userCreation = TestDataFactory.userCreation(2, GlobalConstants.SYSTEM_AdMINISTRATOR);
		insert userCreation;
		//Variable declaration
		Account accountCreation ;
		List<Opportunity> oppty;
		Product2 prod;
		List<Order_Intake_Forecast__c> orderIntake ;
		Nokia_Financial_Calendar__c nokiaFinCalCreation;

		system.runAs(userCreation[0]){
			//Creating Account
			accountCreation = TestDataFactory.createAccount(1)[0];
			database.insert(accountCreation);
			//inserting oppty
			oppty = TestDataFactory.OpportunityCreation(2, accountCreation);
			oppty[0].stageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
			oppty[0].RecordTypeId = oppDirectRecordTypeId;
			oppty[0].Phase_Status__c = GlobalConstants.PLANNED;
			oppty[1].stageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
			oppty[1].RecordTypeId = oppDirectRecordTypeId;
			oppty[1].Phase_Status__c = GlobalConstants.PLANNED;
			oppty[0].Lead_BG__c = 'NI';
			oppty[0].Lead_BU__c = 'NI - FN';
			oppty[1].Lead_BG__c = 'MN';
			oppty[1].Lead_BU__c = 'MN';
			oppty[0].Supporting_BGs_BUs__c = 'MN';
			oppty[1].Supporting_BGs_BUs__c = 'NI - OPTICS';
			database.insert(oppty);


			nokiaFinCalCreation = TestdataFactory.nokiaFinCalCreation(1)[0];
			insert nokiaFinCalCreation;
			//creating Order Intake Forecast
			prod = TestDataFactory.productCreation(1)[0];
			prod.Name = 'CNS - Core NS - Mobile Core - Care (PL)';
			prod.Family= 'CNSCORE';
			database.insert(prod);
			orderIntake = TestDataFactory.orderIntakeCreation(4, oppty[0], prod, nokiaFinCalCreation);
			orderIntake[0].Business_Group__c = 'CNS';
			orderIntake[0].Forecast_Category__c = 'Risk';
			orderIntake[0].OIF_Value__c= 1000;
			orderIntake[1].Forecast_Category__c = 'Secure';
			orderIntake[2].Opportunity__c = oppty[1].Id;
			orderIntake[2].Business_Group__c = 'CNS';
			orderIntake[2].Forecast_Category__c = 'Risk';
			orderIntake[2].OIF_Value__c= 1000;
			orderIntake[3].Opportunity__c = oppty[1].Id;
			orderIntake[3].Forecast_Category__c = 'Secure';
			database.insert(orderIntake);

			/*
			oppty[1].Apttus_Approval__Approval_Status__c = 'Approved';
			oppty[1].ApprovalStatusTechField__c = 'Approved G2, Approved G3';
			oppty[1].StageName = GlobalConstants.CREATE_OFFER;
			oppty[1].Phase_Status__c = GlobalConstants.OFFER_IN_PROGRESS;
			oppty[0].Apttus_Approval__Approval_Status__c = 'Approved';
			oppty[0].ApprovalStatusTechField__c = 'Approved G2, Approved G3, Approved G4';
			oppty[0].StageName = GlobalConstants.WIN_THE_CASE_OPPORTUNITY_STAGE;
			oppty[0].Phase_Status__c = GlobalConstants.OFFER_SUBMITTED_TO_CUSTOMER_MANUAL;*/
			test.startTest();
			oppty[0].Apttus_Approval__Approval_Status__c = 'Approved';
			oppty[0].ApprovalStatusTechField__c = 'Approved G2, Approved G3';
			oppty[0].StageName = GlobalConstants.CREATE_OFFER;
			oppty[0].Phase_Status__c = GlobalConstants.OFFER_IN_PROGRESS;
			database.update(oppty[0]);



			//Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>();
			//oldMap.put(oppty[0].id, oppty[1]);
			//Map<Id, Opportunity> newMap = new Map<Id, Opportunity>();
			//newMap.put(oppty[0].id, oppty[0]);


			GlobalConstants.CHATTER_POST_TO_ACCOUNT_MANAGER_FLAG = false;
			oppty[0].Apttus_Approval__Approval_Status__c = 'Approved';
			oppty[0].ApprovalStatusTechField__c = 'Approved G2, Approved G3, Approved G4';
			oppty[0].StageName = GlobalConstants.WIN_THE_CASE_OPPORTUNITY_STAGE;
			oppty[0].Phase_Status__c = GlobalConstants.OFFER_SUBMITTED_TO_CUSTOMER_MANUAL;
			database.update(oppty[0]);

			//OpportunityTriggerHelper obj = new OpportunityTriggerHelper();
			//obj.chatterPostToAccountManager(newMap, oldmap);
			//oppty[0].Winning_Competitor__c = 'ABB';
			//oppty[0].StageName = 'Closed - Lost to Competitor';
			//oppty[0].Phase_Status__c = GlobalConstants.PHASE_STATUS_CLOSED_NOT_WON;
			//oppty[0].Sales_Outcome__c=GlobalConstants.OPP_LOST_TO_COMPETITOR;

			//database.update(oppty[0]);
			//OpportunityTriggerHelper.MassupdateonOIFLines(newMap.Keyset());
			//OpportunityTriggerHelper.MassupdateonOIFLines(new Set<ID>());
			test.stopTest();
		}
	}
/******************************
*Method Name: probabilityUpdateInlineTest
*Description: Test Method to cover : probabilityUpdateInline , populateSalesOutcome , BatchCurrenychange , populateEndCustomerAndEndCustomerLegalEntityForDirectRecordType
********************************/
	static testMethod void probabilityUpdateInlineTest(){
		//User creation
		list<user> userCreation = TestDataFactory.userCreation(2, GlobalConstants.SYSTEM_AdMINISTRATOR);
		//insert userCreation;
		//Variable declaration
		Account accountCreation ;
		List<Opportunity> oppty;
		insert new Stage_Sales_Outcome__c(Stage_Type__c = GlobalConstants.ClosedLost,name = GlobalConstants.OBSOLETE,Related_Sales_Outcome__c='Obsolete',Related_Phase_Status__c=GlobalConstants.PHASE_STATUS_CLOSED_NOT_WON,Default_Main_Reason__c='Mistake/Redundant/Merged');
		insert new Stage_Sales_Outcome__c(Stage_Type__c = GlobalConstants.ClosedWon,name = GlobalConstants.HANDOVER_OPPTY,Related_Sales_Outcome__c='Won',Related_Phase_Status__c=GlobalConstants.PTA_HANDOVER);
		insert new Stage_Sales_Outcome__c(Stage_Type__c = GlobalConstants.Open,name = GlobalConstants.WIN_THE_CASE_NEGOTIATE);
		insert new Stage_Sales_Outcome__c(Stage_Type__c = GlobalConstants.Open,name = GlobalConstants.DEVELOP_OPPORTUNITY,Related_Phase_Status__c=GLobalConstants.OPPORTUNITY_IN_PROGRESS);
		insert new Stage_Sales_Outcome__c(Stage_Type__c = GlobalConstants.Open,name = GlobalConstants.IDENTIFY_OPPORTUNITY,Related_Phase_Status__c=GLobalConstants.PLANNED);
		system.runAs(userCreation[0]){
			//Creating Account
			accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.AccountNumber = '1287738289';
			database.insert(accountCreation);
			//inserting oppty
			oppty = TestDataFactory.OpportunityCreation(3, accountCreation);
			oppty[0].recordTypeId = oppDirectRecordTypeId;
			oppty[1].recordTypeId = oppDirectRecordTypeId;
			oppty[2].recordTypeId = oppDirectRecordTypeId;
			/*
			//index 0 - change Identify to Delevop
			//index 1 - closed lost to identify (as before)
			oppty[1].stageName = GlobalConstants.OBSOLETE;
			oppty[1].Phase_Status__c = GlobalConstants.PHASE_STATUS_CLOSED_NOT_WON;
			oppty[1].Opportunity_Sales_Phase_Tracking__c = GlobalConstants.IDENTIFY_OPPORTUNITY;
			//index 2 - closed lost to develop (not as before)
			oppty[2].stageName = GlobalConstants.OBSOLETE;
			oppty[2].Phase_Status__c = GlobalConstants.PHASE_STATUS_CLOSED_NOT_WON;
			oppty[2].Opportunity_Sales_Phase_Tracking__c = GlobalConstants.IDENTIFY_OPPORTUNITY;
			//index 3 - change Identify to closed
	 */

			/*
			oppty[0].stageName = GlobalConstants.CREATE_OFFER ;
			oppty[0].recordTypeId = oppDirectRecordTypeId;
			oppty[0].Phase_Status__c = GlobalConstants.OFFER_IN_PROGRESS;
			oppty[0].Lead_BG__c = 'MN';
			oppty[0].probability = 0;

			Map<Id, Opportunity> opptyOldMap = new Map<Id, Opportunity>();
			Map<Id, Opportunity> opptyNewMap = new Map<Id, Opportunity>();

			oppty[1].stageName = GlobalConstants.CREATE_OFFER ;
			oppty[1].recordTypeId = oppDirectRecordTypeId;
			oppty[1].Phase_Status__c = GlobalConstants.OFFER_IN_PROGRESS;
			oppty[1].Lead_BG__c = 'MN';
			oppty[1].probability = 10;
			oppty[1].Opportunity_Sales_Phase_Tracking__c = GlobalConstants.OBSOLETE;


			*/
			database.insert(oppty);

			/*
			oppty[1].stageName =GlobalConstants.WIN_THE_CASE_NEGOTIATE;
			oppty[1].Phase_Status__c = 'Closed(Not Won)';
			oppty[1].Sales_Outcome__c=GlobalConstants.CANCEL_BY_CUSTOMER;

*/
			test.startTest();

			List<Task> taskCreationList = TestDataFactory.TaskCreation(1);
			taskCreationList[0].WhatId = oppty[1].Id;
			insert taskCreationList;

			//moving to closed
			oppty[1].stageName = GlobalConstants.OBSOLETE;
			oppty[1].Phase_Status__c = GlobalConstants.PHASE_STATUS_CLOSED_NOT_WON;
			oppty[1].Opportunity_Sales_Phase_Tracking__c = GlobalConstants.IDENTIFY_OPPORTUNITY;
			oppty[2].stageName = GlobalConstants.OBSOLETE;
			oppty[2].Phase_Status__c = GlobalConstants.PHASE_STATUS_CLOSED_NOT_WON;
			oppty[2].Opportunity_Sales_Phase_Tracking__c = GlobalConstants.IDENTIFY_OPPORTUNITY;
			GlobalConstants.OPPORTUNITYTRIGGER_POPULATE_SALES_OUTCOME = false;
			GlobalConstants.DeleteOpenTaskFlag = false;// to test deleteOpenTasks
			update oppty;

			OpportunityTriggerHelper oppTrigger = new OpportunityTriggerHelper();
			oppTrigger.BatchCurrenychange(new Set<ID>{oppty[1].Id});

			Map<Id,Opportunity> oldOpptyProbability = new Map<Id,Opportunity>();
			oldOpptyProbability.put(oppty[0].Id, oppty[0].clone(true,true,true,true));
			oldOpptyProbability.get(oppty[0].Id).probability = 50;

			oppty[0].Apttus_Approval__Approval_Status__c = 'Approved';
			oppty[0].ApprovalStatusTechField__c = 'Approved G2';
			oppty[0].StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			oppty[0].Phase_Status__c = GlobalConstants.OPPORTUNITY_IN_PROGRESS;
			oppty[1].stageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
			oppty[1].Phase_Status__c = GlobalConstants.PLANNED;
			GlobalConstants.OPPORTUNITYTRIGGER_POPULATE_SALES_OUTCOME = false;
			update oppty;

			Map<Id,Opportunity> newOpptyProbability = new Map<Id,Opportunity>();
			newOpptyProbability.put(oppty[0].Id, oppty[0].clone(true,true,true,true));
			newOpptyProbability.get(oppty[0].Id).probability = 0;

			try{
	oppty[0].Apttus_Approval__Approval_Status__c = 'Approved';
	oppty[0].ApprovalStatusTechField__c = 'Approved G2,Approved G3,Approved G4,Approved G5,Approved G6';
	oppty[0].StageName = GlobalConstants.HANDOVER_OPPTY;
	oppty[0].Phase_Status__c = GlobalConstants.PTA_HANDOVER;
	oppty[2].stageName = GlobalConstants.DEVELOP_OPPORTUNITY;
	oppty[2].Phase_Status__c = GlobalConstants.OPPORTUNITY_IN_PROGRESS;
	GlobalConstants.OPPORTUNITYTRIGGER_POPULATE_SALES_OUTCOME = false;
	update oppty;
			} catch (Exception ex){
	System.debug(ex.getMessage());
	oppTrigger.BatchCurrenychange(new Set<ID>{oppty[0].Id});
	oppTrigger.probabilityUpdateInline(newOpptyProbability , oldOpptyProbability);
	oppTrigger.populateEndCustomerAndEndCustomerLegalEntityForDirectRecordType(null,  null);
			}

			/*
			oppty[2].stageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
			update oppty[2];
			opptyOldMap.put(oppty[0].id, oppty[1]);
			opptyNewMap.put(oppty[0].id, oppty[0]);
			OpportunityTriggerHelper obj = new OpportunityTriggerHelper();
			obj.probabilityUpdateInline(opptyNewMap, opptyOldMap);
			obj.probabilityUpdateInline(null, null);
			//populateSalesOutcome
			obj.populateSalesOutcome(oppty, opptyOldMap);
			//BatchCurrenychange coverage
			Set<Id> opptyId = new Set<Id>();
			for(opportunity opptyObj : oppty){
	opptyId.add(opptyObj.id);
			}
			obj.BatchCurrenychange(opptyId);
			OpportunityTriggerHelper.MassupdateonOIFLines(opptyId);

			//DeleteAllocationLine
			obj.DeleteAllocationLine(opptyId);
			//Exception
			obj.BatchCurrenychange(NULL);
			obj.populateSalesOutcome(NULL,  NULL);
	*/
			test.stopTest();
		}

	}

	/******************************
	*Method Name: populateReasonsTest
	*Description: Test Method to cover : populateReasons , populateG5ContractApprovalDate
	********************************/
	static testMethod void populateReasonsTest(){
		//User creation
		list<user> userCreation = TestDataFactory.userCreation(2, GlobalConstants.SYSTEM_AdMINISTRATOR);
		//insert userCreation;
		system.runAs(userCreation[0]){
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;
			List<Opportunity> optyCreation = TestDataFactory.OpportunityCreation(2, accountCreation);
			optyCreation[0].RecordTypeId = oppDirectRecordTypeId;
			optyCreation[0].Amount = 11000;

			optyCreation[1].RecordTypeId = oppDirectRecordTypeId;
			optyCreation[1].Amount = 11000;
			database.insert(optyCreation);
			Map<Id,Opportunity> oldOpptyMap = new Map<Id,Opportunity>(optyCreation);
			Test.startTest();
			//Offer__c offerCreation = TestDataFactory.OfferCreation(1, optyCreation[0])[0];
			//offerCreation.ActiveOffer__c = true;
			//insert offerCreation;

			optyCreation[0].StageName = GlobalConstants.CANCELLED_BY_CUSTOMER;
			optyCreation[0].Apttus_Approval__Approval_Status__c = GlobalConstants.STATUS_NOT_SUBMITTED;
			optyCreation[0].Sales_Outcome_Reason__c = GlobalConstants.FREASON;
			optyCreation[0].Second_Reason__c = GlobalConstants.SREASON;
			optyCreation[0].Third_Reason__c = GlobalConstants.TREASON;
			optyCreation[1].StageName = GlobalConstants.WITH_DRAW_BY_NOKIA;
			optyCreation[1].Apttus_Approval__Approval_Status__c = GlobalConstants.STATUS_NOT_SUBMITTED;
			optyCreation[1].Sales_Outcome_Reason__c = GlobalConstants.FREASON;
			optyCreation[1].Second_Reason__c = GlobalConstants.SREASON;
			optyCreation[1].Third_Reason__c = GlobalConstants.TREASON;
			database.update(optyCreation);

			OpportunityTriggerHelper obj = new OpportunityTriggerHelper();
			obj.populateReasons(null, null);
			obj.populateG5ContractApprovalDate(optyCreation,oldOpptyMap);
			obj.populateG5ContractApprovalDate(Null, Null);
			Test.stopTest();
		}
	}
/*
	static testMethod void convertionrateupdateTest(){
		Nokia_Financial_Calendar__c nokiaFinCalCreation;
		Dated_Exchange_Rates__c datedExchangeRates;
		//User creation
		list<user> userCreation = TestDataFactory.userCreation(2, GlobalConstants.SYSTEM_AdMINISTRATOR);
		insert userCreation;
		system.runAs(userCreation[0]){
			nokiaFinCalCreation = TestdataFactory.nokiaFinCalCreation(1)[0];
			insert nokiaFinCalCreation;
			datedExchangeRates = TestdataFactory.datedExchnageRateCreation(1)[0];
			datedExchangeRates.DER_Period__c = nokiaFinCalCreation.Id;
			database.insert(datedExchangeRates);

			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.AccountNumber = '1234';
			database.insert(accountCreation);
			List<Opportunity> optyCreation = TestDataFactory.OpportunityCreation(2, accountCreation);
			optyCreation[0].RecordTypeId = oppDirectRecordTypeId;
			optyCreation[0].Amount = 11000;
			optyCreation[0].CurrencyIsoCode = 'USD';
			optyCreation[1].RecordTypeId = oppDirectRecordTypeId;
			optyCreation[1].Amount = 11000;
			optyCreation[1].CurrencyIsoCode = 'USD';
			database.insert(optyCreation);
		}
	}
*//*
	static testMethod void populateEndCustomerAndEndCustomerLegalEntityForDirectRecordTypeTest(){
		//User creation
		list<user> userCreation = TestDataFactory.userCreation(2, GlobalConstants.SYSTEM_AdMINISTRATOR);
		insert userCreation;
		system.runAs(userCreation[0]){

			List<Account> accountCreation = TestDataFactory.createAccount(2);
			accountCreation[0].AccountNumber = '1234';
			accountCreation[1].AccountNumber = '301';
			database.insert(accountCreation);
			List<Opportunity> optyCreation = TestDataFactory.OpportunityCreation(2, accountCreation[0]);
			optyCreation[0].RecordTypeId = oppDirectRecordTypeId;
			optyCreation[0].Amount = 11000;
			optyCreation[0].End_Customer__c = accountCreation[0].Id;
			optyCreation[1].RecordTypeId = oppDirectRecordTypeId;
			optyCreation[1].Amount = 11000;
			optyCreation[1].End_Customer__c = accountCreation[0].Id;
			database.insert(optyCreation);
			optyCreation[0].End_Customer__c = accountCreation[1].Id;

			Map<Id, Opportunity> oldOptyMap = new Map<Id, Opportunity>();
			oldOptyMap.put(optyCreation[0].id, optyCreation[1]);
			Map<Id, Opportunity> newOptyMap = new Map<Id, Opportunity>();
			newOptyMap.put(optyCreation[0].id, optyCreation[0]);

			OpportunityTriggerHelper obj = new OpportunityTriggerHelper();
			obj.populateEndCustomerAndEndCustomerLegalEntityForDirectRecordType(newOptyMap.values(),  oldOptyMap);
			obj.populateEndCustomerAndEndCustomerLegalEntityForDirectRecordType(null,  null);
		}
	}*/

	static testMethod void populateEndCustTest()
	{
		List<Opportunity> lstOpty= new List<Opportunity>();
		List<Account> accList = new List<Account>();
		Id leRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(GlobalConstants.LEGAL_ENTITY_RECORD_TYPE).getRecordTypeId();
		Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(GlobalConstants.CUSTOMER).getRecordTypeId();

		accList = TestDataFactory.createAccount(3);

		accList[0].RecordTypeId=custRecordTypeId;
		accList[1].RecordTypeId=leRecordTypeId;
		accList[2].RecordTypeId=leRecordTypeId;
		accList[1].AccountNumber='301030872';
		accList[2].AccountNumber='301030873';
		database.insert(accList);


		lstOpty = TestDataFactory.OpportunityCreation(2, accList[0]);
		lstOpty[1].RecordTypeId= oppIndirectRecordTypeId ;
		lstOpty[1].End_Customer__c = null;
		lstOpty[1].Account_Role__c = accountRole;
		lstOpty[1].End_Customer_LE__c=accList[1].id;
		database.insert(lstOpty);

		test.startTest();
		accList[1].parentId=accList[0].id;
		database.update(accList[1]);
		test.stopTest();
	}

	/******************************
	*Method Name: populateSalesOutcomeTest
	*Description: Test Method to cover OpportunityTriggerHelper class
	********************************//*
	static testMethod void populateSalesOutcomeTest(){
		//User creation
		list<user> userCreation = TestDataFactory.userCreation(2, GlobalConstants.SYSTEM_AdMINISTRATOR);
		insert userCreation;
		//Variable declaration
		Account accountCreation ;
		List<Opportunity> oppty;
		OpportunityTriggerHelper obj = new OpportunityTriggerHelper();
		system.runAs(userCreation[0]){
			List<Stage_Sales_Outcome__c> customSettingData = new List<Stage_Sales_Outcome__c>();
			customSettingData.add(new Stage_Sales_Outcome__c(Name=GlobalConstants.IDENTIFY_OPPORTUNITY, Related_Phase_Status__c=GlobalConstants.PLANNED, Stage_Type__c='Open' ));
			customSettingData.add(new Stage_Sales_Outcome__c(Name=GlobalConstants.DEVELOP_OPPORTUNITY, Related_Phase_Status__c=GlobalConstants.OPPORTUNITY_IN_PROGRESS, Stage_Type__c='Open' ));
			customSettingData.add(new Stage_Sales_Outcome__c(Name=GlobalConstants.OBSOLETE, Related_Phase_Status__c=GlobalConstants.PHASE_STATUS_CLOSED_NOT_WON, Stage_Type__c='Closed/Lost',  Related_Sales_Outcome__c = 'Obsolete', Default_Main_Reason__c = 'Mistake/Redundant/Merged' ));
			customSettingData.add(new Stage_Sales_Outcome__c(Name=GlobalConstants.COMPLETED_OPPTY, Related_Phase_Status__c='Closed', Stage_Type__c='Closed/Won' ));
			database.insert(customSettingData);
			//Creating Account
			accountCreation = TestDataFactory.createAccount(1)[0];
			database.insert(accountCreation);
			//inserting oppty
			oppty = TestDataFactory.OpportunityCreation(1, accountCreation);
			oppty[0].StageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
			oppty[0].Phase_Status__c = 'Planned';
			oppty[0].Amount = 100;
			oppty[0].RecordTypeId= oppDirectRecordTypeId;
			oppty[0].Opportunity_Sales_Phase_Tracking__c = GlobalConstants.DEVELOP_OPPORTUNITY;
			database.insert(oppty);

			Map<Id, Opportunity> oldOptyMap = new Map<Id, Opportunity>();
			oldOptyMap.put(oppty[0].Id, oppty[0]);

			Opportunity clone1 = oppty[0].clone(true, true, true, true);
			clone1.stageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			clone1.Phase_Status__c = GlobalConstants.OPPORTUNITY_IN_PROGRESS;
			Opportunity clone2 = oppty[0].clone(true, true, true, true);
			clone2.stageName = 'Completed';
			clone2.Phase_Status__c = 'Closed';
			Opportunity clone3 = oppty[0].clone(true, true, true, true);
			clone3.stageName = GlobalConstants.OBSOLETE;
			clone3.Phase_Status__c = GlobalConstants.PHASE_STATUS_CLOSED_NOT_WON;
			clone3.Opportunity_Sales_Phase_Tracking__c = GlobalConstants.DEVELOP_OPPORTUNITY;

			List<opportunity> opptyList = new List<Opportunity>();
			opptyList.add(clone1);
			opptyList.add(clone2);
			opptyList.add(clone3);
			GlobalConstants.OPPORTUNITYTRIGGER_POPULATE_SALES_OUTCOME = false;
			obj.populateSalesOutcome(opptyList, oldOptyMap);

			oldOptyMap = new Map<Id, Opportunity>();
			oldOptyMap.put(clone3.Id, clone3);
			opptyList = new List<Opportunity>();
			opptyList.add(clone1);
			GlobalConstants.OPPORTUNITYTRIGGER_POPULATE_SALES_OUTCOME = false;
			obj.populateSalesOutcome(opptyList, oldOptyMap);
		}
	}
*/
	/**************************************************************
	*Method Name: deleteOpenTasksTest
	*Description: Test Method to cover : deleteOpenTasks
	class deleteOpenTasks method
	*************************************************************/ /*
	static testMethod void deleteOpenTasksTest(){
		//Creating User
		User userCreation = TestDataFactory.userCreation(1, GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		//insert userCreation;
		System.runAs(userCreation){
			Test.startTest();
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;

			//Creating Opportunity
			List<Opportunity> optyCreation = TestDataFactory.OpportunityCreation(2, accountCreation);
			optyCreation[0].RecordTypeId = oppDirectRecordTypeId;
			optyCreation[0].Amount = 1000;
			optyCreation[1].RecordTypeId = oppDirectRecordTypeId;
			optyCreation[1].Amount = 1000;

			optyCreation[1].StageName = GlobalConstants.WIN_THE_CASE_OPPORTUNITY_STAGE;
			optyCreation[1].Phase_Status__c = GlobalConstants.OFFER_SUBMITTED_TO_CUSTOMER_MANUAL;
			insert optyCreation;

			optyCreation[1].stageName = GlobalConstants.OBSOLETE;
			optyCreation[1].Phase_Status__c = GlobalConstants.PHASE_STATUS_CLOSED_NOT_WON;
			update optyCreation;

			List<Task> taskCreationList = TestDataFactory.TaskCreation(1);
			taskCreationList[0].WhatId = optyCreation[1].Id;
			taskCreationList[0].Status = GlobalConstants.CLOSED_NOT_COMPLETED;
			taskCreationList[0].Task_Creation_By_Pass_Check__c = GlobalConstants.VALUE_TRUE;

			Map<Id, Opportunity> opptyOldMap = new Map<Id, Opportunity>();
			opptyOldMap.put(optyCreation[1].id, optyCreation[1]);

			Map<Id, Opportunity> opptyNewMap = new Map<Id, Opportunity>();
			opptyNewMap.put(optyCreation[1].id, optyCreation[1]);

			OpportunityTriggerHelper obj = new OpportunityTriggerHelper();
			obj.deleteOpenTasks(opptyNewMap, opptyOldMap);
			obj.deleteOpenTasks(null,  null);

		}
	}*/


	/******************************
	*Method Name: G4_Planned_Date_MandatoryTest
	*Description: Test Method to cover : g4PlannedDateMandatory
	********************************/
	static testMethod void g4_Planned_Date_MandatoryTest(){
		user userCreation = TestDataFactory.userCreation(1, GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		//database.insert(userCreation);
		system.runAs(userCreation){
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;

			List<Opportunity> opptyList = TestDataFactory.OpportunityCreation(5, accountCreation);
			opptyList[0].RecordTypeId = oppDirectRecordTypeId;
			opptyList[0].G3_Planned_Date__c = System.today();
			opptyList[0].G4_Planned_Date__c = System.today();
			opptyList[0].G5_Planned_Date__c = System.today();
			opptyList[1].Gate_3_Bypass_no_offer_support__c = true;
			opptyList[3].Gate_6_Bypass_No_Execute_needed__c = true;
			database.insert(opptyList);

			Test.startTest();

			opptyList[0].G4_Planned_Date__c = null;
			opptyList[1].Gate_3_Bypass_no_offer_support__c = false;
			opptyList[2].Gate_3_Bypass_no_offer_support__c = true;
			opptyList[3].Gate_6_Bypass_No_Execute_needed__c = false;
			opptyList[4].Gate_6_Bypass_No_Execute_needed__c = true;

			try{
	update opptyList;
			}
			catch(Exception ex){
	System.debug('exception found on G4_Planned_Date_MandatoryTest');
			}
			test.stopTest();
		}
	}

	/******************************
	*Method Name: committedUpsellOptyClosureValidationTest
	*Description: Release 8: Sales Process: Req#4999 Test Method
	to cover avoidClosingCommittedUpsellByCOSalesOpMarketHead
	method from OpportunityTriggerHelper class
	********************************/
	static testMethod void committedUpsellOptyClosureValidationTest(){
		user userCreation = TestDataFactory.userCreation(1, GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		database.insert(userCreation);
		system.runAs(userCreation){
			Test.startTest();
			//insert account
			List<Account> accountCreation = NF_TestDataFactory.getAccounts(2);
			database.insert(accountCreation);
			//insert opportunity
			List<Opportunity> optyCreation1 = TestDataFactory.OpportunityCreation(1, accountCreation[1]);
			optyCreation1[0].Business_Type__c = GlobalConstants.COMMITTED_UPSELL;
			optyCreation1[0].StageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
			optyCreation1[0].Phase_Status__c = 'Planned';
			database.insert(optyCreation1);

			//closing opty
			try{
	optyCreation1[0].StageName = GlobalConstants.CANCELLED_BY_CUSTOMER;
	optyCreation1[0].Phase_Status__c = GlobalConstants.PHASE_STATUS_CLOSED_NOT_WON;
	database.update(optyCreation1);
			} catch(Exception ex){
	String message = ex.getMessage();
	system.assert(message.contains(Label.AvoidClosingCommitedUpsellByCoSalesOpMarketHead),  'message=' + message);
			}
			//cover catch block
			OpportunityTriggerHelper obj = new OpportunityTriggerHelper();
			obj.committedUpsellOptyClosureValidation(null, null);
			test.stopTest();
		}
	}
/* NOT USED
	static testMethod void updateSSOOnUnweightedValueChangeTest(){
		//Creating User
		User userCreation = TestDataFactory.userCreation(1, GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		insert userCreation;
		System.runAs(userCreation){

			//Account Creation
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;

			//Creating Opportunity
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1, accountCreation)[0];
			optyCreation.RecordTypeId = oppDirectRecordTypeId;
			optyCreation.Amount = 1000;
			insert optyCreation;

			Test.startTest();
			//creating offer
			Offer__c offerCreation = TestDataFactory.OfferCreation(1, optyCreation)[0];
			offerCreation.ActiveOffer__c = true;
			offerCreation.Opportunity__c = optyCreation.id;
			insert offerCreation;

			optyCreation.Amount = 11000000;
			optyCreation.Unweighted_Amount_EUR__c =11000000;
			update optyCreation;

			Test.stopTest();
		}
	}

	static testMethod void updateSSOOnUnweightedValueChangeTest1(){
		//Creating User
		User userCreation = TestDataFactory.userCreation(1, GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		insert userCreation;
		System.runAs(userCreation){

			//Account Creation
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;

			//Creating Opportunity
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1, accountCreation)[0];
			optyCreation.RecordTypeId = oppDirectRecordTypeId;
			optyCreation.Amount = 1000;
			insert optyCreation;

			Test.startTest();
			//creating offer
			Offer__c offerCreation = TestDataFactory.OfferCreation(1, optyCreation)[0];
			offerCreation.ActiveOffer__c = true;
			offerCreation.Opportunity__c = optyCreation.id;
			insert offerCreation;


			optyCreation.Amount = 1100;
			optyCreation.Unweighted_Amount_EUR__c =1100;
			update optyCreation;

			Test.stopTest();
		}
	}
*/
	/******************************
	*Method Name: updateUnweightedValueofOpptyGroupTest
	*Description: Test Method to cover  : updateUnweightedValueofOpptyGroup
	********************************/
	static testMethod void updateUnweightedValueofOpptyGroupTest(){
		//User creation
		list<user> userCreation = TestDataFactory.userCreation(2, GlobalConstants.SYSTEM_AdMINISTRATOR);
		//insert userCreation;
		system.runAs(userCreation[0])
		{
			Test.StartTest();
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1, accountCreation)[0];
			optyCreation.RecordTypeId = oppDirectRecordTypeId;
			optyCreation.Unweighted_Amount_EUR__c = 1000;
			database.insert(optyCreation);
			Deal__c dealCreation = TestDataFactory.createDeal(1)[0];
			database.insert(dealCreation);
			Opportunity_Group__c opptyGroup = TestDataFactory.DealOpptyGroupingCreation(1, optyCreation, dealCreation)[0];
			database.insert(opptyGroup);
			optyCreation.Unweighted_Amount_EUR__c = 2000;
			database.update(optyCreation);
			OpportunityTriggerHelper obj = new OpportunityTriggerHelper();
			obj.updateUnweightedValueofOpptyGroup(null,  null);
			test.stopTest();
		}
	}

	/******************************
	*Method Name: opportunityTypeChangeRestrictionTest
	*Description: Test Method to cover OpportunityTriggerHelper class
	********************************/
	static testMethod void opportunityTypeChangeRestrictionTest(){
		//User creation
		list<user> userCreation = TestDataFactory.userCreation(2, GlobalConstants.SYSTEM_AdMINISTRATOR);
		//insert userCreation;
		system.runAs(userCreation[0])
		{
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;
			List<Opportunity> optyCreation = TestDataFactory.OpportunityCreation(2, accountCreation);
			optyCreation[0].RecordTypeId = oppDirectRecordTypeId;
			optyCreation[1].RecordTypeId = oppDirectRecordTypeId;
			database.insert(optyCreation);

			optyCreation[0].stageName = GlobalConstants.OBSOLETE;
			optyCreation[0].Phase_Status__c = GlobalConstants.PHASE_STATUS_CLOSED_NOT_WON;
			optyCreation[1].Apttus_Approval__Approval_Status__c = 'Approved';
			optyCreation[1].ApprovalStatusTechField__c = 'Approved G2';
			optyCreation[1].StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation[1].Phase_Status__c = GlobalConstants.OPPORTUNITY_IN_PROGRESS;
			database.update(optyCreation);

			optyCreation[0].Business_Type__c = GlobalConstants.COMMITTED_UPSELL;
			optyCreation[1].Business_Type__c = GlobalConstants.COMMITTED_UPSELL;
			Test.StartTest();
			try{
	database.update(optyCreation);
			}
			catch(Exception ex){
	String message = ex.getMessage();
			}
			OpportunityTriggerHelper obj = new OpportunityTriggerHelper();
			obj.opportunityTypeChangeRestriction(null,  null);
			test.stopTest();
		}
	}

	/******************************
	*Method Name: opportunityTypeChangeRestrictionCoverErrorTest
	*Description: Test Method to cover OpportunityTriggerHelper class
	********************************//*
	 static testMethod void opportunityTypeChangeRestrictionCoverErrorTest(){
		//User creation
		list<user> userCreation = TestDataFactory.userCreation(2, GlobalConstants.SYSTEM_AdMINISTRATOR);
		insert userCreation;
		system.runAs(userCreation[0])
		{
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1, accountCreation)[0];
			optyCreation.RecordTypeId = oppDirectRecordTypeId;
			optyCreation.StageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
			optyCreation.Phase_Status__c = GlobalConstants.SUBMITTED_FOR_G2_APPROVAL;
			database.insert(optyCreation);

			Apttus_Approval__Approval_Request__c approvalrequest =
			NF_TestDataFactory.createApprovalRequest('Approved',  'User',  'Test Object', string.valueOf(optyCreation.Id),  True,  True,  userCreation[1].Name, string.valueOf(userCreation[1].Id),  'Sub step Name Test');
			approvalrequest.Apttus_Approval__DelegateApproverIds__c=userCreation[1].id;
			approvalrequest.Apttus_Approval__Step_Name__c='G2';
			database.insert(approvalrequest);

			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = GlobalConstants.OPPORTUNITY_IN_PROGRESS ;
			optyCreation.Apttus_Approval__Approval_Status__c = 'Approved';
			optyCreation.ApprovalStatusTechField__c = 'Approved G2';
			database.update(optyCreation);
			Test.StartTest();
			optyCreation.Business_Type__c = GlobalConstants.COMMITTED_UPSELL;
			try{
	database.update(optyCreation);
			}
			catch(Exception ex){
	String message = ex.getMessage();
	system.assert(message.contains('The opportunity type cannot be changed after G2.'),  'message=' + message);
			}

			OpportunityTriggerHelper obj = new OpportunityTriggerHelper();
			obj.opportunityTypeChangeRestriction(null,  null);
			test.stopTest();
		}
	}*/

	static testMethod void testupsellDeltaDifference(){
		user userCreation = TestDataFactory.userCreation(1, GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		//database.insert(userCreation);
		system.runAs(userCreation)
		{

			//insert account
			List<Account> accountCreation = NF_TestDataFactory.getAccounts(2);
			database.insert(accountCreation);

			//insert opportunity
			List<Opportunity> optyCreation1 = TestDataFactory.OpportunityCreation(1, accountCreation[1]);
			optyCreation1[0].Business_Type__c = GlobalConstants.COMMITTED_UPSELL;
			optyCreation1[0].StageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
			optyCreation1[0].Phase_Status__c = 'Planned';
			optyCreation1[0].Unweighted_Amount_EUR__c= 10;
			optyCreation1[0].Committed_Unweighted_Value_in_EUR__c =10 ;
			optyCreation1[0].Lead_BG__c = 'CNS';
			optyCreation1[0].Lead_BU__c = null ;

			database.insert(optyCreation1);
			Test.startTest();
			optyCreation1[0].Unweighted_Amount_EUR__c= 20;
			try{
	database.update(optyCreation1);
			} catch (Exception ex){
	System.debug(ex.getMessage());
			}

			test.stopTest();
		}
	}

	static testMethod void testcommittedUnweightedValue()
	{
		user userCreation = TestDataFactory.userCreation(1, GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		//database.insert(userCreation);
		system.runAs(userCreation){

			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;

			Sales_Role__c objsalesrole = new Sales_Role__c();
			objsalesrole.Organisation__c = 'APJ ANO CBT Myanmar';
			objsalesrole.Role_Code__c = 'BG Commercial Manage';
			objsalesrole.Role_Name__c = 'BG Commercial Management, OC Level C Validator';
			objsalesrole.User__c = UserInfo.getUserId();

			insert objsalesrole;

			List<Opportunity> optyCreationList = TestDataFactory.OpportunityCreation(2, accountCreation);
			optyCreationList[0].Business_Type__c = GlobalConstants.COMMITTED_UPSELL;
			optyCreationList[1].Unweighted_Amount_EUR__c = 20;
			database.insert(optyCreationList);

			List<Deal__c> dealCreationList = TestDataFactory.createDeal(1);

			dealCreationList[0].RecordTypeId = upsellDealRecordTypeId;
			database.insert(dealCreationList);

			List<Opportunity_Group__c> opptyGroupList = TestDataFactory.DealOpptyGroupingCreation(2, optyCreationList[0],  dealCreationList[0]);
			Test.startTest();
			opptyGroupList[1].Opportunity_Relation__c = 'Master';
			opptyGroupList[1].Opportunity__c= optyCreationList[1].id;
			database.insert(opptyGroupList);


			optyCreationList[1].stagename= 'Create Offer (Bid)';
			optyCreationList[1].phase_status__c= GlobalConstants.OFFER_IN_PROGRESS;

			update optyCreationList;

			optyCreationList[1].stagename= GlobalConstants.WIN_THE_CASE_NEGOTIATE;
			optyCreationList[1].phase_status__c= GlobalConstants.OFFER_SUBMITTED_TO_CUSTOMER_MANUAL;

			update optyCreationList;
			test.stopTest();
		}
	}
/******************************
	*Method Name: opportunityTypeChangeRestrictionCoverErrorTest
	*Description: Test Method to cover : associateUpsellOpptyWithUpsellDeal , upsellChangeAccepted
	********************************/
	static testMethod void testupsellChangeAccepted()
	{
		user userCreation = TestDataFactory.userCreation(1, GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
	// database.insert(userCreation);
		system.runAs(userCreation){
			Test.startTest();
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;

			Sales_Role__c objsalesrole = new Sales_Role__c();
			objsalesrole.Organisation__c = 'APJ ANO CBT Myanmar';
			objsalesrole.Role_Code__c = 'BG Commercial Manage';
			objsalesrole.Role_Name__c = 'BG Commercial Management, OC Level C Validator';
			objsalesrole.User__c = UserInfo.getUserId();

			insert objsalesrole;
			OpportunityTriggerHelper triggerHelper = new OpportunityTriggerHelper();
			List<Opportunity> optyCreationList = TestDataFactory.OpportunityCreation(1, accountCreation);
			optyCreationList[0].recordtypeid=oppDirectRecordTypeId;
			optyCreationList[0].Business_Type__c = GlobalConstants.COMMITTED_UPSELL;
			optyCreationList[0].Upsell_Change_Accepted__c=false;
			database.insert(optyCreationList);
			Map<Id,Opportunity> opptyOldMap = new Map<Id,Opportunity>(optyCreationList);
			triggerHelper.associateUpsellOpptyWithUpsellDeal(opptyOldMap, opptyOldMap);
			try
			{
	Opportunity oppty = optyCreationList[0].clone(true,true,true,true);
	oppty.Upsell_Change_Accepted__c=true;
	triggerHelper.upsellChangeAccepted(new List<Opportunity>{oppty}, opptyOldMap);

			}
			catch(Exception ex){
	System.debug('exception in testupsellChangeAccepted');
			}

			test.stopTest();
		}
	}

	/******************************
	*Method Name: ClosedOpptyStatustoTeamTest
	*Description: Test Method to cover OpportunityTriggerHelper class
	********************************/
	static testMethod void closedOpptyStatustoTeamTest(){
		//User creation
		list<user> userCreation = TestDataFactory.userCreation(2, GlobalConstants.SYSTEM_AdMINISTRATOR);
		insert userCreation;
		Set <Id> opptyId = new Set<Id>();
		Sales_Role__c salesRole = new Sales_Role__c();
		salesRole.Role_Name__c = 'CT Head';
		salesRole.Role_Code__c=Label.NF_NSNG_HCT;
		salesRole.User__c=userCreation[1].id;
		salesRole.Process_SRT_Audit__c=true;
		salesRole.Organisation__c='Market Europe';
		insert salesRole;
		Apttus_Approval__Backup_Approver__c approvalRec = new Apttus_Approval__Backup_Approver__c();
		approvalRec.Apttus_Approval__Current_User__c = userCreation[1].id;
		approvalRec.Apttus_Approval__InEffect__c=True;
		approvalRec.Apttus_Approval__IsActive__c=True;
		approvalRec.Apttus_Approval__IsDelegate__c=true;
		approvalRec.Apttus_Approval__DelegateUserIds__c= userCreation[0].id;
		approvalRec.Delegate_Approver1__c = userCreation[0].id;
		insert approvalRec;
		system.runAs(userCreation[0])
		{
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.L7Name__c = 'Market Europe';
			insert accountCreation;
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1, accountCreation)[0];
			optyCreation.RecordTypeId = oppDirectRecordTypeId;
			optyCreation.Lead_BG__c = 'MN';
			optyCreation.Lead_BU__c = 'MN';

			database.insert(optyCreation);
			Test.StartTest();
			//Oppty Team
			OpportunityTeamMember team = TestDataFactory.optyTeamMemberCreation(1, userCreation[0], optyCreation)[0];
			database.insert(team);


			//Creating Offer
			Offer__c offerCreation = TestDataFactory.OfferCreation(1, optyCreation)[0];
		offerCreation.ActiveOffer__c = True;
		offerCreation.LoA_Approval_Level__c = 'E';
		offerCreation.LoA_Level_Before_Trigger_Approval__c = 'E';
			insert offerCreation;
			List<Offer_Team__c> offerTeamObj = TestDataFactory.offerTeamCreation(1, offerCreation, userCreation[0]);
			insert offerTeamObj;

			optyCreation.StageName = GlobalConstants.OBSOLETE;
			optyCreation.Sales_Outcome__c = GlobalConstants.OPP_OBSOLETE;
			optyCreation.Second_Reason__c = GlobalConstants.TREASON;
			optyCreation.Third_Reason__c = GlobalConstants.SREASON;
			opptyId.add(optyCreation.id);
			OpportunityTriggerHelper.ClosedOpptyStatustoTeam(opptyId);
			test.stopTest();
		}
	}

	/******************************
	*Method Name: validateSubstituteOptyWithSameUpsellDealTest
	*Description: Test Method to cover validateSubstituteOptyWithSameUpsellDeal method from OpportunityTriggerHelper class
	********************************/
	static testMethod void validateSubstituteOptyWithSameUpsellDealTest(){
		user userCreation = TestDataFactory.userCreation(1, GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		database.insert(userCreation);
		system.runAs(userCreation){
			Test.startTest();

			//insert account
			List<Account> accountCreation = NF_TestDataFactory.getAccounts(2);
			database.insert(accountCreation);

			//insert opportunity
			List<Opportunity> optyCreation1 = TestDataFactory.OpportunityCreation(2, accountCreation[1]);
			optyCreation1[0].StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation1[0].Phase_Status__c = GlobalConstants.OPPORTUNITY_IN_PROGRESS;
			optyCreation1[0].Business_Type__c = GlobalConstants.COMMITTED_UPSELL;
			database.insert(optyCreation1);

			//insert upsell deal
			List<Deal__c> dealCreationList = TestDataFactory.createDeal(2);
			dealCreationList[0].RecordTypeId = upsellDealRecordTypeId;
			dealCreationList[1].RecordTypeId = upsellDealRecordTypeId;
			database.insert(dealCreationList);

			List<Opportunity_Group__c > opportunityGroupList = TestDataFactory.DealOpptyGroupingCreation(2, optyCreation1[0],  dealCreationList[0]);
			opportunityGroupList[1].Opportunity__c = optyCreation1[1].Id;
			opportunityGroupList[1].Deal__c = dealCreationList[1].Id;
			database.insert(opportunityGroupList);
			optyCreation1[0].Substitute_Opportunity__c = optyCreation1[1].Id;

			try{
	Database.update(optyCreation1);
			} catch(Exception ex){
	String message = ex.getMessage();
	system.assert(message.contains(Label.UpsellOpportunityDealErrorMessage),  'message=' + message);
			}
			OpportunityTriggerHelper obj = new OpportunityTriggerHelper();
			obj.validateSubstituteOptyWithSameUpsellDeal(null,  null);
			Test.stopTest();
		}
	}

	/******************************
	*Method Name: populate_G4ApprovalCycleTimeOnOfferTest
	*Description: Test Method to cover populate_G4ApprovalCycleTimeOnOffer method from OpportunityTriggerHelper class
	********************************/
	static testMethod void populate_G4ApprovalCycleTimeOnOfferTest(){
		user userCreation = TestDataFactory.userCreation(1, GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		database.insert(userCreation);
		system.runAs(userCreation)
		{

			//Creating Account
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			database.insert(accountCreation);
			//Creating Opportunity
			List<Opportunity> optyCreationList = TestDataFactory.OpportunityCreation(2, accountCreation);
			database.insert(optyCreationList);
			Test.startTest();
			//Creating Offer
			List<Offer__c> offerCreationList = TestDataFactory.OfferCreation(2, optyCreationList[0]);
			offerCreationList[0].ActiveOffer__c = True;
			offerCreationList[0].LOA_Bypass__c = 'No LoA';
			offerCreationList[1].Opportunity__c = optyCreationList[1].id;
			offerCreationList[1].LOA_Bypass__c = 'No LoA';
			offerCreationList[1].ActiveOffer__c = True;
			database.insert(offerCreationList);

			optyCreationList[0].G4_Submission_Date__c = system.today();
			optyCreationList[1].G4_Submission_Date__c = system.today();
			optyCreationList[1].G4_Approval_Date__c = system.today();
			database.update(optyCreationList);

			OpportunityTriggerHelper obj = new OpportunityTriggerHelper();
			obj.populate_G4ApprovalCycleTimeOnOffer(null, null);
			Test.stopTest();
		}
	}

	/******************************
	*Method Name: createCompetitorWhenOpportunityClosedNegativelyTest
	*Description: Test Method to cover createCompetitorWhenOpportunityClosedNegatively method from OpportunityTriggerHelper class
	********************************/
	static testMethod void createCompetitorWhenOpportunityClosedNegativelyTest()
	{
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		accountCreation.BusinessPartnerRole__c = businessPartnerRole;
		database.insert(accountCreation);

		List<Opportunity> optyCreationList = TestDataFactory.OpportunityCreation(1, accountCreation);
		optyCreationList[0].recordTypeId = oppDirectRecordTypeId;
		database.insert(optyCreationList);
		Map<Id,  Opportunity> opptyMap = new Map<Id,  Opportunity>();
		opptyMap.put(optyCreationList[0].id,  optyCreationList[0]);

		compList = TestDataFactory.CompetitorCreation(2, optyCreationList[0]);
		compList[0].Competitor_New__c = 'Accenture';
		compList[1].Competitor_New__c = 'Autodesk';
		database.insert(compList);

		Opportunity clone = optyCreationList[0].clone(true, true, true, true);
		clone.StageName = GlobalConstants.LOST_TO_COMPETITOR;
		clone.Phase_Status__c = 'Closed not(Won)';
		clone.Winning_Competitor__c = 'Accenture;Autodesk';

		OpportunityTriggerHandler.flagForCompetitor = false;
		OpportunityTriggerHelper obj = new OpportunityTriggerHelper();
		obj.createCompetitorWhenOpportunityClosedNegatively(new List<Opportunity>{clone}, opptyMap);
		obj.createCompetitorWhenOpportunityClosedNegatively(null, null);
	}

	/******************************
	*Method Name: updateOwnerInOpptyTeamTest
	*Description: Test Method to cover updateOwnerInOpptyTeam method from OpportunityTriggerHelper class
	********************************/
	static testMethod void updateOwnerInOpptyTeamTest(){
		List<User> userCreationList = TestDataFactory.userCreation(2, GlobalConstants.SYSTEM_AdMINISTRATOR);
		database.insert(userCreationList);
		system.runAs(userCreationList[0])
		{
			//Creating Account
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			database.insert(accountCreation);
			//Creating Opportunity
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1, accountCreation)[0];
			database.insert(optyCreation);
			Test.startTest();
			optyCreation.OwnerId = userCreationList[1].Id;
			Database.update(optyCreation);
			Test.stopTest();
		}
	}

	/******************************
	*Method Name: insertOwnerInTeamOnReopeningTest
	*Description: Test Method to cover insertOwnerInTeamOnReopening method from OpportunityTriggerHelper class
	********************************/
	static testMethod void insertOwnerInTeamOnReopeningTest(){
		List<User> userCreationList = TestDataFactory.userCreation(2, GlobalConstants.SYSTEM_AdMINISTRATOR);
		database.insert(userCreationList);
		system.runAs(userCreationList[0])
		{
			//Creating Account
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			database.insert(accountCreation);
			//Creating Opportunity
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1, accountCreation)[0];
			database.insert(optyCreation);
			optyCreation.StageName = Globalconstants.OBSOLETE ;
			Database.update(optyCreation);
			Test.startTest();
			OpportunityTeamMember oppTeam= [Select Id from OpportunityTeamMember where UserId =: userCreationList[0].Id
			and OpportunityId =: optyCreation.Id limit 1];
			if(oppTeam!= Null){
	Database.Delete(oppTeam);
			}
			optyCreation.StageName = Globalconstants.IDENTIFY_OPPORTUNITY;
			Database.update(optyCreation);
			Test.stopTest();
		}
	}

	/******************************
	*Method Name: createUnknownCompetitorRecordTest
	*Description: Test Method to cover createCompetitorWhenOpportunityClosedNegatively method from OpportunityTriggerHelper class
	********************************/
	static testMethod void createUnknownCompetitorRecordTest()
	{
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		accountCreation.BusinessPartnerRole__c = businessPartnerRole;
		database.insert(accountCreation);

		List<Opportunity> optyCreationList = TestDataFactory.OpportunityCreation(2, accountCreation);
		optyCreationList[1].RecordTypeId = oppIndirectRecordTypeId;
		optyCreationList[1].Account_Role__c = accountRole;
		optyCreationList[1].End_Customer_Information__c = GlobalConstants.EC_INFO_MULTI;
		optyCreationList[1].Multiple_or_Unknown_EC_Activity_Sector__c = actSector;
		optyCreationList[1].Multiple_or_Unknown_EC_Country__c = country;
		optyCreationList[1].Multiple_or_Unknown_EC_Market_Segment__c = market;
		database.insert(optyCreationList);
		test.startTest();
		optyCreationList[0].StageName = GlobalConstants.LOST_TO_COMPETITOR;
		optyCreationList[0].RecordTypeId = oppReadOnlyDirectRecordTypeId;
		optyCreationList[0].G4_planned_date__c = System.today();
		optyCreationList[0].Winning_Competitor__c = 'ABB';

		optyCreationList[1].StageName = GlobalConstants.LOST_TO_COMPETITOR;
		optyCreationList[1].RecordTypeId = readOnlyIndirectRecordTypeId;
		optyCreationList[1].G4_planned_date__c = System.today();
		optyCreationList[1].Winning_Competitor__c = 'ABB';
		database.update(optyCreationList);
		test.stopTest();
		OpportunityTriggerHelper obj = new OpportunityTriggerHelper();
		obj.createUnknownCompetitorRecord(null, null);
	}

	/******************************
	*Method Name: UpdateOffer
	*Description: Test Method to cover createCompetitorWhenOpportunityClosedNegatively method from OpportunityTriggerHelper class
	********************************/
	static testMethod void updateOffer()
	{
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		database.insert(accountCreation);

		Opportunity optyCreation = TestDataFactory.OpportunityCreation(1, accountCreation)[0];
		database.insert(optyCreation);

		test.startTest();
		optyCreation.StageName = GlobalConstants.CREATE_OFFER;
		optyCreation.RecordTypeId = oppReadOnlyDirectRecordTypeId;
		optyCreation.G4_planned_date__c = System.today();
		database.update(optyCreation);

		optyCreation.StageName = GlobalConstants.WIN_THE_CASE_OPPORTUNITY_STAGE;
		optyCreation.RecordTypeId = oppReadOnlyDirectRecordTypeId;
		optyCreation.G4_planned_date__c = System.today();
		database.update(optyCreation);

		test.stopTest();
		OpportunityTriggerHelper obj = new OpportunityTriggerHelper();
		obj.UpdateOffer(null, null);
	}

	/******************************
	*Method Name: updateCustomerOfferDueDatetest
	*Description: Test Method to cover updateCustomerOfferDueDate method from OpportunityTriggerHelper class
	********************************/
	public static testmethod void updateCustomerOfferDueDatetest()
	{
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		accountCreation.BusinessPartnerRole__c = businessPartnerRole;
		insert accountCreation;
		Opportunity optyCreation = TestDataFactory.OpportunityCreation(1, accountCreation)[0];
		optyCreation.RecordTypeId = oppIndirectRecordTypeId;
		optyCreation.Account_Role__c = accountRole;
		optyCreation.End_Customer_Information__c = GlobalConstants.EC_INFO_MULTI;
		optyCreation.Multiple_or_Unknown_EC_Activity_Sector__c = actSector;
		optyCreation.Multiple_or_Unknown_EC_Country__c = country;
		optyCreation.Multiple_or_Unknown_EC_Market_Segment__c = market;
		insert optyCreation;
		//Offer__c offerCreation = TestDataFactory.OfferCreation(1, optyCreation)[0];
		//offerCreation.Opportunity__c = optyCreation.id;
		//insert offerCreation;
		optyCreation.G2_Planned_Date__c = system.today()+1;
		optyCreation.G3_Planned_Date__c = system.today()+2;
		optyCreation.G4_Planned_Date__c = system.today()+3;
		optyCreation.G5_Planned_Date__c = system.today()+4;
		Test.startTest();
		update optyCreation;
		Test.stopTest();
	}

	/******************************
	*Method Name: validateWonShareAllocationSumTest
	*Description: Test Method to cover validateWonShareAllocationSum method from OpportunityTriggerHelper class
	********************************/
	static testMethod void validateWonShareAllocationSumTest()
	{
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		accountCreation.BusinessPartnerRole__c = businessPartnerRole;
		database.insert(accountCreation);
		Opportunity optyCreation = TestDataFactory.OpportunityCreation(1, accountCreation)[0];
		optyCreation.RecordTypeId = oppIndirectRecordTypeId;
		optyCreation.End_Customer_Information__c = GlobalConstants.EC_INFO_MULTI;
		optyCreation.Multiple_or_Unknown_EC_Activity_Sector__c = actSector;
		optyCreation.Multiple_or_Unknown_EC_Country__c = country;
		optyCreation.Multiple_or_Unknown_EC_Market_Segment__c = market;
		optyCreation.Account_Role__c = accountRole;
		database.insert(optyCreation);
		test.startTest();
		compList = TestDataFactory.CompetitorCreation(2, optyCreation);
		compList[0].Competitor_New__c = 'ABB';
		compList[0].Opportunity_Won__c = true;
		compList[0].Won_Share_Allocation_in__c = 70;
		compList[1].Competitor_New__c = 'Accenture';
		compList[1].Opportunity_Won__c = false;
		compList[1].Won_Share_Allocation_in__c = 50;
		compList[1].Opportunity__c = optyCreation.id;
		database.insert(compList);
		optyCreation.StageName = GlobalConstants.LOST_TO_COMPETITOR;
		optyCreation.RecordTypeId = oppReadOnlyDirectRecordTypeId;
		optyCreation.Winning_Competitor__c = 'Accenture';
		try{
			database.update(optyCreation);
		}
		catch(Exception e)
		{
			Boolean expectedExceptionThrown = e.getMessage().contains(System.Label.Won_Share_Sum_Validation);
			System.assertEquals(expectedExceptionThrown,  true);
		}
		test.stopTest();
		OpportunityTriggerHelper obj = new OpportunityTriggerHelper();
		obj.validateWonShareAllocationSum(null, null);
	}
}