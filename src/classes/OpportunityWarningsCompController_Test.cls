@isTest
public with sharing class OpportunityWarningsCompController_Test {

	public static Id swxRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByDeveloperName().get('SWx_Upsell_Proposal').getRecordTypeId();
	public static Id indirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.Indirect_Record_Type).getRecordTypeId();
	public static Id directRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
	private static String market = 'CABLE';
	private static String actSector = 'CABL - CABLE OPERATORS';
	private static String country = 'India';

	@isTest
	static void checkOpportunityStageParameters() {
		User sysAdminUser = TestDataFactory.createSystemAdminUser();
		System.runAs(sysAdminUser){
			Account acc = TestDataFactory.createAccount(1)[0];
			acc.AccountNumber = '1234';
			database.insert(acc);

			//Create Digital Proposal
			SWx_Upsell_Proposal__c upsellProposal_SWX = new SWx_Upsell_Proposal__c();
			upsellProposal_SWX.Unweighted_Value__c = 429052;
			upsellProposal_SWX.Account_ID__c = acc.Id;
			upsellProposal_SWX.Sold_To_Party__c = acc.Id;
			upsellProposal_SWX.RecordTypeID = swxRecordTypeId;
			database.insert(upsellProposal_SWX);

			//Create Opportunity
			Opportunity oppty = TestDataFactory.OpportunityCreation(1,acc)[0];
			oppty.SWx_Upsell_Proposal__c=upsellProposal_SWX.id;
			oppty.Lead_BG__c ='MN';
			oppty.DS_Reasons_Populated__c = true;
			database.insert(oppty);

			product2 prod = TestDataFactory.productCreation(1)[0];
			prod.Business_Group__c='CNS';
			prod.Family= 'CNSBS';
			database.insert (prod);

			Nokia_Financial_Calendar__c nokiaFinCal = TestDataFactory.nokiaFinCalCreation(1)[0];
			nokiaFinCal.Start_Date__c = System.today() - 2000;
			nokiaFinCal.End_Date__c = System.today() + 2000;
			database.insert(nokiaFinCal);
			Test.startTest();
			Order_Intake_Forecast__c orderIntake = new Order_Intake_Forecast__c();
			orderIntake.BusinessLine__c = prod.id;
			orderIntake.Opportunity__c = oppty.id;
			orderIntake.OIF_Value__c = 12000;
			orderIntake.OIF_Value_EUR__c = 12000;
			orderIntake.Forecast_Category__c = 'Upside';
			orderIntake.POPlanReceipt__c = nokiaFinCal.id;
			database.insert(orderIntake);


			oppty.StageName = GlobalConstants.EXECUTE_OPPTY;
			oppty.Phase_Status__c = GlobalConstants.IN_EXECUTION;
			oppty.Apttus_Approval__Approval_Status__c = 'Approved';
			oppty.ApprovalStatusTechField__c = 'Approved G2,Approved G3,Approved G4,Approved G5,Approved G6';
			update oppty;
			OpportunityWarningsCompController.checkOpttyStageParams(oppty.Id);
			Test.stopTest();
		}

	}

	@isTest
	static void OfferWarningMessageTest(){
		User userCreation = TestDataFactory.createSystemAdminUser();

		System.runAs(userCreation){
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			database.insert(accountCreation);

			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
			database.insert(optyCreation);

			Test.startTest();

			optyCreation.stageName = GlobalConstants.WIN_THE_CASE_NEGOTIATE;
			optyCreation.Phase_Status__c= GlobalConstants.OFFERSUBMITTEDTOCUSTOMER;
			optyCreation.Apttus_Approval__Approval_Status__c = 'Approved';
			optyCreation.ApprovalStatusTechField__c = 'Approved G2,Approved G3,Approved G4';
			update optyCreation;

			Offer__c offerCreation =  TestDataFactory.OfferCreation(1,optyCreation)[0];
			offerCreation.ActiveOffer__c = true;
			database.insert(offerCreation);

			System.assertNotEquals(OpportunityWarningsCompController.findOffer(optyCreation.Id, optyCreation.Id), GlobalConstants.BLANK_VALUE) ;
			Test.stopTest();
		}
	}

	@isTest
	static void checkMinPlanDateOIFTest(){

		User userCreation = TestDataFactory.createSystemAdminUser();

		system.runAs(userCreation){

			Account accountCreation = TestDataFactory.createAccount(1)[0];
			database.insert(accountCreation);

			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
			optyCreation.G5_Planned_Date__c = System.today() + 90;
			database.insert(optyCreation);

			Product2 prod = TestDataFactory.productCreation(1)[0];
			prod.Business_Group__c='CNS';
			prod.Family= 'CNSBS';
			database.insert (prod);

			List<Nokia_Financial_Calendar__c> nokiaFinCals = TestDataFactory.nokiaFinCalCreation(2);
			Date first = System.today() + 30;
			Date second = System.today() + 120;
			nokiaFinCals[0].Start_Date__c = first;
			nokiaFinCals[0].End_Date__c = first + 30;

			nokiaFinCals[0].Name = first.year()+' - P'+first.month();
			nokiaFinCals[0].Period_Number__c = String.valueOf(first.month());
			nokiaFinCals[0].Related_Quarter__c = findRelatedQuarter(String.valueOf(first.month()));

			nokiaFinCals[1].Start_Date__c = second;
			nokiaFinCals[1].End_Date__c = second + 30;

			nokiaFinCals[1].Name = second.year()+' - P'+second.month();
			nokiaFinCals[1].Period_Number__c = String.valueOf(second.month());
			nokiaFinCals[1].Related_Quarter__c = findRelatedQuarter(String.valueOf(second.month()));

			database.insert(nokiaFinCals);

			List<Order_Intake_Forecast__c> orderIntakes = new List<Order_Intake_Forecast__c>();
			for(integer i = 0; i < 2 ; i++){
			Order_Intake_Forecast__c orderIntake = new Order_Intake_Forecast__c();
			orderIntake.BusinessLine__c = prod.id;
			orderIntake.Opportunity__c = optyCreation.id;
			orderIntake.OIF_Value__c = 1;
			orderIntake.OIF_Value_EUR__c = 1;
			orderIntake.Forecast_Category__c = 'Upside';
			orderIntakes.add(orderIntake);
			}

			Test.startTest();
			orderIntakes.get(0).POPlanReceipt__c = nokiaFinCals[0].Id;
			database.insert(orderIntakes.get(0));

			Date newDate = OpportunityWarningsCompController.checkMinPlanDateOIF(optyCreation.Id);

			Nokia_Financial_Calendar__c monthDate = [SELECT Year__c,Period_Number__c FROM Nokia_Financial_Calendar__c WHERE Start_Date__c =: first];

			Date lastDayFirst =((Date.newInstance(Integer.valueOf(monthDate.Year__c), Integer.valueOf(monthDate.Period_Number__c), 1).addMonths(1)).toStartOfMonth()).addDays(-1);

			System.assertEquals(newDate, lastDayFirst);
			orderIntakes.get(1).POPlanReceipt__c = nokiaFinCals[1].Id;
			database.insert(orderIntakes.get(1));
			newDate = OpportunityWarningsCompController.checkMinPlanDateOIF(optyCreation.Id);
			System.assertEquals(newDate, lastDayFirst);
			OpportunityWarningsCompController.overrideDecisionPlanDate(optyCreation.Id,newDate);
			System.assertEquals([Select G5_Planned_Date__c From Opportunity Where Id = :optyCreation.Id].G5_Planned_Date__c, lastDayFirst);
			Test.stopTest();
		}
	}

	@isTest
	static void checkOpptyInfoTest(){

		User userCreation = TestDataFactory.createSystemAdminUser();

		system.runAs(userCreation){

			Account accountCreation = TestDataFactory.createAccount(1)[0];
			database.insert(accountCreation);

			Test.startTest();
			List<Opportunity> opportunities = NF_TestDataFactory.getOpportunities(2,new list<Account>{accountCreation});
			opportunities.get(0).End_Customer_Information__c = GlobalConstants.EC_INFO_MULTI;
			opportunities.get(0).Multiple_or_Unknown_EC_Market_Segment__c = market;
			opportunities.get(0).Multiple_or_Unknown_EC_Activity_Sector__c = actSector;
			opportunities.get(0).Multiple_or_Unknown_EC_Country__c = country;
			opportunities.get(0).Business_Type__c = GlobalConstants.STANDARDOPPORTUNITY;
			opportunities.get(0).recordTypeId = indirectRecordTypeId;
			opportunities.get(1).Business_Type__c = GlobalConstants.STANDARDOPPORTUNITY;
			opportunities.get(1).End_Customer_Information__c = GlobalConstants.EC_INFO_MULTI;
			opportunities.get(1).Multiple_or_Unknown_EC_Market_Segment__c = market;
			opportunities.get(1).Multiple_or_Unknown_EC_Activity_Sector__c = actSector;
			opportunities.get(1).Multiple_or_Unknown_EC_Country__c = country;
			database.insert(opportunities);

			System.assert(OpportunityWarningsCompController.getOpptyInfo(opportunities.get(0).Id));
			System.assertEquals(OpportunityWarningsCompController.getOpptyInfo(opportunities.get(1).Id), false);
			Test.stopTest();

		}
	}

	@isTest
	static void checkOpptyFields(){
		User userCreation = TestDataFactory.createSystemAdminUser();
		system.runAs(userCreation){
			Test.startTest();
			String[] fields = OpportunityWarningsCompController.validateFieldsAccessibility();
			System.assert(fields.size() > 0);
			Test.stopTest();
		}
	}

	@isTest
	static void createCareRenewalOppTest(){
		User userCreation = TestDataFactory.createSystemAdminUser();
		system.runAs(userCreation){
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			database.insert(accountCreation);
			List<Opportunity> opportunities = NF_TestDataFactory.getOpportunities(1,new list<Account>{accountCreation});
			opportunities[0].Business_Type__c = GlobalConstants.STANDARDOPPORTUNITY;
			opportunities[0].recordtypeid=directRecordTypeId;
			database.insert(opportunities);

			Test.startTest();
			OpportunityWarningsCompController.fetchCareOIFLinesApex(opportunities[0].Id);
			OpportunityWarningsCompController.createCareRenewalOpp(null, null);//Actual test logic is done in CloneOpportunityTets. Here we just want to cover class code
			Test.stopTest();
		}
	}
	static String findRelatedQuarter(String month){
		String quarter = '';
		if(String.IsNotBlank(month)){
			if(month=='1' ||month=='2' ||month=='3')
	  quarter='1';
			else if(month=='4' ||month=='5' ||month=='6')
	  quarter='2';
			else if(month=='7' ||month=='8' ||month=='9')
	  quarter='3';
			else
	  quarter='4';
		}
		return quarter;
	}
}