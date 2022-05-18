@istest 
Private class CloneOpportunityTest
{
	private static final Id directRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
	private static final Id inDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.Indirect_Record_Type).getRecordTypeId();
	private static final Id preOppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.PREOPPTY_RECORD_TYPE).getRecordTypeId();
	private static final String renewalOppName = 'Renewal Opp';
	private static List<Opportunity> optyCreation = new list<Opportunity>();
	private static List<OpportunityTeamMember> optyTeamList= new List<OpportunityTeamMember>();

	public static CloneObject__c createCloneRecordSetting(String fieldAPI, String name, String objectName, String recordType){
		CloneObject__c cloneField = new CloneObject__c();
		cloneField.Field_API__c = fieldAPI;
		cloneField.Name = name;
		cloneField.Object__c = objectName;
		cloneField.Record_Type__c = recordType;
		return cloneField;
	}
	//@testSetup
	static void renewalSetup() {
		Account acc = TestDataFactory.createAccount(1)[0];
		acc.AccountNumber = '12345';
		database.insert(acc);
		
		//Create OPPortunity
		Opportunity oppty = TestDataFactory.OpportunityCreation(1,acc)[0];
		oppty.Name = renewalOppName;
		oppty.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
		database.insert(oppty);
		Test.startTest();
		product2 prod = TestDataFactory.productCreation(1)[0];
		prod.Family = 'CNSCORE';
		database.insert (prod);

		Nokia_Financial_Calendar__c nokiaFinCal = TestDataFactory.nokiaFinCalCreation(1)[0];
		nokiaFinCal.Start_Date__c = System.today() - 2000;
		nokiaFinCal.End_Date__c = System.today() + 2000;
		database.insert(nokiaFinCal);

		Order_Intake_Forecast__c orderIntake = new Order_Intake_Forecast__c();
		orderIntake.BusinessLine__c = prod.id;
		orderIntake.Opportunity__c = oppty.id;
		orderIntake.OIF_Value__c = 12000;
		orderIntake.OIF_Value_EUR__c = 12000;
		orderIntake.Forecast_Category__c = 'Secure';
		orderIntake.POPlanReceipt__c = nokiaFinCal.id;
		database.insert(orderIntake);

		Competitor__c competitor = new Competitor__c();
		competitor.Competitor_New__c = 'Accenture';
		competitor.Primary_Competitor__c = true;
		competitor.Opportunity__c = oppty.Id;
		insert competitor;


		List<Contact> contactList = TestDataFactory.createContact(1, acc);
		contactList[0].LastName = 'last name';
		insert contactList;

		OpportunityContactRole contactRole = new OpportunityContactRole();
		contactRole.ContactId = contactList[0].Id;
		contactRole.OpportunityId = oppty.Id;
	}


	static testMethod void cloneOptyForDirectTest()
	{
		List<user> userCreation = TestDataFactory.userCreation(2,GlobalConstants.SYSTEM_AdMINISTRATOR);
		insert userCreation;
		System.runAs(userCreation[0])
		{
			populateDirOppFieldsToClone();
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;
			optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation);
			optyCreation[0].recordTypeId = directRecordTypeId;
			insert optyCreation;
			test.startTest();
			optyTeamList = TestDataFactory.optyTeamMemberCreation(2,userCreation[1],optyCreation[0]);
			optyTeamList[0].UserId = userCreation[0].Id;
			optyTeamList[0].Additional_Team_Role__c = 'Account Manager (TRICORN Sales Case Owner (SCO))' +GlobalConstants.Semicolon+'Solution Manager';
			optyTeamList[0].TeamMemberRole = GlobalConstants.BID_MANAGER_OFFER_TEAM_ROLE;
			insert(optyTeamList);
			CloneOpportunity.getCloneOpp(optyCreation[0].id);
			test.stopTest();
		}

	}

	static testMethod void cloneOptyForIndirectTest()
	{
		user userCreation = TestDataFactory.userCreation(1,GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		insert userCreation;
		System.runAs(userCreation)
		{
			populateIndOppFieldsToClone();
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;
			Account endCustomerLE = TestDataFactory.createAccount('Legal_Entity', 1,accountCreation.Id)[0];
			insert endCustomerLE;
			optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation);
			optyCreation[0].recordTypeId = inDirectRecordTypeId;
			optyCreation[0].End_Customer_LE__c = endCustomerLE.Id;
			optyCreation[0].Account_Role__c = GlobalConstants.GPPVARpartner;
			insert optyCreation;
			test.startTest();
			optyTeamList = TestDataFactory.optyTeamMemberCreation(1,userCreation,optyCreation[0]);
			insert(optyTeamList);

			CloneOpportunity.getCloneOpp(optyCreation[0].id);
			test.stopTest();
		}

	}


	static testMethod void cloneClosedOppty()
	{
		user userCreation = TestDataFactory.userCreation(1,GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		insert userCreation;
		System.runAs(userCreation)
		{
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;
			optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation);
			optyCreation[0].recordTypeId = directRecordTypeId;
			optyCreation[0].Amount = 0;
			insert optyCreation;

			optyCreation[0].stageName = GlobalConstants.CANCELLED_BY_CUSTOMER;
			update optyCreation[0];

			test.startTest();
			CloneOpportunity.getCloneOpp(optyCreation[0].id);
			test.stopTest();
		}

	}


	static testMethod void cloneOptyTestNegative()
	{
		User userCreation = TestDataFactory.userCreation(1,GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		insert userCreation;
		system.runAs(userCreation)
		{
			Test.startTest();
			CloneOpportunity.getCloneOpp(null);
			CloneOpportunity.cloneOpportunityTeam(null,null, null);
			Test.stopTest();
		}
	}

	static testMethod void cloneOptyForPreOppTest()
	{
		user userCreation = TestDataFactory.userCreation(1,GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		insert userCreation;
		System.runAs(userCreation)
		{
			populatePreOppFieldsToClone();
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;
			optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation);
			optyCreation[0].recordTypeId = preOppRecordTypeId;
			optyCreation[0].Description = 'bla bla';
			optyCreation[0].StageName = GlobalConstants.BUSINESS_DEVELOPMENT;
			optyCreation[0].Phase_Status__c = null;
			optyCreation[0].High_level_Solution_Installed_base__c = 'bla bla';
			insert optyCreation;
			test.startTest();
			optyTeamList = TestDataFactory.optyTeamMemberCreation(1,userCreation,optyCreation[0]);
			insert(optyTeamList);

			Program_Flag__c pf = new Program_Flag__c();
			pf.Name = 'Test';
			insert pf;

			OptyProgramFlagJunction__c opfj = new OptyProgramFlagJunction__c();
			opfj.Program_Flag__c = pf.Id;
			opfj.Opportunity__c = optyCreation[0].id;
			insert opfj;
			test.stopTest();
			CloneOpportunity.getCloneOpp(optyCreation[0].id);

		}
	}

	@isTest
	static void careRenewalCloneTest(){
		User userCreation = TestDataFactory.createSystemAdminUser();
		system.runAs(userCreation){
			renewalSetup();
			populateDirOppFieldsToClone();
			Opportunity oppToRenew = [SELECT id FROM Opportunity WHERE name = :renewalOppName];
			String returnMessage = OpportunityWarningsCompController.createCareRenewalOpp(oppToRenew.Id, 3);
			oppToRenew.Care_Contract_End_Date__c = System.today();
			update oppToRenew;
			returnMessage = OpportunityWarningsCompController.createCareRenewalOpp(oppToRenew.Id, 3);
			Test.stopTest();
		}
	}

	static private void populatePreOppFieldsToClone()
	{
		List<CloneObject__c> fieldsToClone = new List<CloneObject__c>();
		fieldsToClone.add(createCloneRecordSetting('CloseDate','CloseDate',GlobalConstants.OBJECT_OPPORTUNITY,GlobalConstants.PREOPPORTUNITY));
		fieldsToClone.add(createCloneRecordSetting('Name','Name',GlobalConstants.OBJECT_OPPORTUNITY,GlobalConstants.PREOPPORTUNITY));
		fieldsToClone.add(createCloneRecordSetting('Amount','Amount',GlobalConstants.OBJECT_OPPORTUNITY,GlobalConstants.PREOPPORTUNITY));
		fieldsToClone.add(createCloneRecordSetting('AccountId','AccountId',GlobalConstants.OBJECT_OPPORTUNITY,GlobalConstants.PREOPPORTUNITY));
		fieldsToClone.add(createCloneRecordSetting('RecordTypeId','RecordTypeId',GlobalConstants.OBJECT_OPPORTUNITY,GlobalConstants.PREOPPORTUNITY));
		fieldsToClone.add(createCloneRecordSetting('Lead_BG__c','Lead_BG__c',GlobalConstants.OBJECT_OPPORTUNITY,GlobalConstants.PREOPPORTUNITY));
		fieldsToClone.add(createCloneRecordSetting('Lead_BU__c','Lead_BU__c',GlobalConstants.OBJECT_OPPORTUNITY,GlobalConstants.PREOPPORTUNITY));
		fieldsToClone.add(createCloneRecordSetting('StageName','StageName',GlobalConstants.OBJECT_OPPORTUNITY,GlobalConstants.PREOPPORTUNITY));
		fieldsToClone.add(createCloneRecordSetting('Phase_Status__c','Phase_Status__c',GlobalConstants.OBJECT_OPPORTUNITY,GlobalConstants.PREOPPORTUNITY));
		fieldsToClone.add(createCloneRecordSetting('Account_Role__c','Account_Role__c',GlobalConstants.OBJECT_OPPORTUNITY,GlobalConstants.PREOPPORTUNITY));
		fieldsToClone.add(createCloneRecordSetting('End_Customer__c','End_Customer__c',GlobalConstants.OBJECT_OPPORTUNITY,GlobalConstants.PREOPPORTUNITY));
		fieldsToClone.add(createCloneRecordSetting('Description','Description',GlobalConstants.OBJECT_OPPORTUNITY,GlobalConstants.PREOPPORTUNITY));
		fieldsToClone.add(createCloneRecordSetting('High_level_Solution_Installed_base__c','High_level_Solution_Installed_base__c',GlobalConstants.OBJECT_OPPORTUNITY,GlobalConstants.PREOPPORTUNITY));
		insert fieldsToClone;
	}

	static private void populateDirOppFieldsToClone()
	{
		List<CloneObject__c> fieldsToClone = new List<CloneObject__c>();
		fieldsToClone.add(createCloneRecordSetting('CloseDate','CloseDate',GlobalConstants.OBJECT_OPPORTUNITY,GlobalConstants.Direct));
		fieldsToClone.add(createCloneRecordSetting('Name','Name',GlobalConstants.OBJECT_OPPORTUNITY,GlobalConstants.Direct));
		fieldsToClone.add(createCloneRecordSetting('G3_Planned_Date__c','G3_Planned_Date__c',GlobalConstants.OBJECT_OPPORTUNITY,GlobalConstants.Direct));
		fieldsToClone.add(createCloneRecordSetting('G4_Planned_Date__c','G4_Planned_Date__c',GlobalConstants.OBJECT_OPPORTUNITY,GlobalConstants.Direct));
		fieldsToClone.add(createCloneRecordSetting('G5_Planned_Date__c','G5_Planned_Date__c',GlobalConstants.OBJECT_OPPORTUNITY,GlobalConstants.Direct));
		fieldsToClone.add(createCloneRecordSetting('G6_Planned_Date__c','G6_Planned_Date__c',GlobalConstants.OBJECT_OPPORTUNITY,GlobalConstants.Direct));
		fieldsToClone.add(createCloneRecordSetting('Amount','Amount',GlobalConstants.OBJECT_OPPORTUNITY,GlobalConstants.Direct));
		fieldsToClone.add(createCloneRecordSetting('AccountId','AccountId',GlobalConstants.OBJECT_OPPORTUNITY,GlobalConstants.Direct));
		fieldsToClone.add(createCloneRecordSetting('Contract_Signing_Entity__c','Contract_Signing_Entity__c',GlobalConstants.OBJECT_OPPORTUNITY,GlobalConstants.Direct));
		fieldsToClone.add(createCloneRecordSetting('Business_Type__c','Business_Type__c',GlobalConstants.OBJECT_OPPORTUNITY,GlobalConstants.Direct));
		fieldsToClone.add(createCloneRecordSetting('RecordTypeId','RecordTypeId',GlobalConstants.OBJECT_OPPORTUNITY,GlobalConstants.Direct));
		fieldsToClone.add(createCloneRecordSetting('Lead_BG__c','Lead_BG__c',GlobalConstants.OBJECT_OPPORTUNITY,GlobalConstants.Direct));
		fieldsToClone.add(createCloneRecordSetting('Lead_BU__c','Lead_BU__c',GlobalConstants.OBJECT_OPPORTUNITY,GlobalConstants.Direct));
		fieldsToClone.add(createCloneRecordSetting('StageName','StageName',GlobalConstants.OBJECT_OPPORTUNITY,GlobalConstants.Direct));
		fieldsToClone.add(createCloneRecordSetting('Phase_Status__c','Phase_Status__c',GlobalConstants.OBJECT_OPPORTUNITY,GlobalConstants.Direct));
		insert fieldsToClone;
	}
	static private void populateIndOppFieldsToClone()
	{
		List<CloneObject__c> fieldsToClone = new List<CloneObject__c>();
		fieldsToClone.add(createCloneRecordSetting('CloseDate','CloseDate',GlobalConstants.OBJECT_OPPORTUNITY, GlobalConstants.Indirect));
		fieldsToClone.add(createCloneRecordSetting('Name','Name',GlobalConstants.OBJECT_OPPORTUNITY, GlobalConstants.Indirect));
		fieldsToClone.add(createCloneRecordSetting('G3_Planned_Date__c','G3_Planned_Date__c',GlobalConstants.OBJECT_OPPORTUNITY, GlobalConstants.Indirect));
		fieldsToClone.add(createCloneRecordSetting('G4_Planned_Date__c','G4_Planned_Date__c',GlobalConstants.OBJECT_OPPORTUNITY, GlobalConstants.Indirect));
		fieldsToClone.add(createCloneRecordSetting('G5_Planned_Date__c','G5_Planned_Date__c',GlobalConstants.OBJECT_OPPORTUNITY, GlobalConstants.Indirect));
		fieldsToClone.add(createCloneRecordSetting('G6_Planned_Date__c','G6_Planned_Date__c',GlobalConstants.OBJECT_OPPORTUNITY, GlobalConstants.Indirect));
		fieldsToClone.add(createCloneRecordSetting('Amount','Amount',GlobalConstants.OBJECT_OPPORTUNITY, GlobalConstants.Indirect));
		fieldsToClone.add(createCloneRecordSetting('AccountId','AccountId',GlobalConstants.OBJECT_OPPORTUNITY, GlobalConstants.Indirect));
		fieldsToClone.add(createCloneRecordSetting('Contract_Signing_Entity__c','Contract_Signing_Entity__c',GlobalConstants.OBJECT_OPPORTUNITY, GlobalConstants.Indirect));
		fieldsToClone.add(createCloneRecordSetting('Business_Type__c','Business_Type__c',GlobalConstants.OBJECT_OPPORTUNITY, GlobalConstants.Indirect));
		fieldsToClone.add(createCloneRecordSetting('RecordTypeId','RecordTypeId',GlobalConstants.OBJECT_OPPORTUNITY, GlobalConstants.Indirect));
		fieldsToClone.add(createCloneRecordSetting('Lead_BG__c','Lead_BG__c',GlobalConstants.OBJECT_OPPORTUNITY, GlobalConstants.Indirect));
		fieldsToClone.add(createCloneRecordSetting('Lead_BU__c','Lead_BU__c',GlobalConstants.OBJECT_OPPORTUNITY, GlobalConstants.Indirect));
		fieldsToClone.add(createCloneRecordSetting('StageName','StageName',GlobalConstants.OBJECT_OPPORTUNITY, GlobalConstants.Indirect));
		fieldsToClone.add(createCloneRecordSetting('Phase_Status__c','Phase_Status__c',GlobalConstants.OBJECT_OPPORTUNITY, GlobalConstants.Indirect));
		fieldsToClone.add(createCloneRecordSetting('Account_Role__c','Account_Role__c',GlobalConstants.OBJECT_OPPORTUNITY, GlobalConstants.Indirect));
		fieldsToClone.add(createCloneRecordSetting('End_Customer__c','End_Customer__c',GlobalConstants.OBJECT_OPPORTUNITY, GlobalConstants.Indirect));
		insert fieldsToClone;
	}
}