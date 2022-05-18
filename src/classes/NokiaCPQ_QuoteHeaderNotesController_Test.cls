/*************************************************************
@Name: NokiaCPQ_QuoteHeaderNotesController_Test 
@Author: Christie JJ
@CreateDate: 5 February 2021
@Description: This class acts as the test class for NokiaCPQ_QuoteHeaderNotesController (rqmt 7357)
@UsedBy: VF Page

* Modification Log  :
* Developer	Date	 Description
* -----------------------------------------------------------------------------------------------------------
* Christie JJ   10 March 2021	Removed testmethods for modified scenarios

******************************************************************/

@isTest
public class NokiaCPQ_QuoteHeaderNotesController_Test {
	
	
	@isTest static void TestNA1(){

	
		
		List<User> sysAdminUser = new List<User>();
		User u = NOKIA_CPQ_TestDataFactory.createSystemAdminUser();
		sysAdminUser.add(u);
		User portalUser ;
		Apttus_Proposal__Proposal__c testProposal1;

		System.runAs(sysAdminUser[0]){
		List<Apttus_Proposal__Proposal__c> proposals=new List<Apttus_Proposal__Proposal__c>();
		List <Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		accounts[0].Partner_Type__c = '';
		accounts[0].Partner_Program__c = 'GPP 3.0';
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].AccountNumber='';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;

		
		
		
	

		Accreditation__c accreditation1 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_PRODUCT,
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Authorized',
	Partner__c=accounts[0].Id,
	Portfolio__c='Optics',
	Pricing_Cluster__c='NAM'	
	);
		Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_MAINTENANCE,
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Authorized',
	Partner__c=accounts[0].Id,
	Portfolio__c='Optics',
	Pricing_Cluster__c='NAM'	
	);
	
		insert accreditation1;
		insert accreditation2;

		 //create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].StageName = 'Create Offer (Bid)';
		
		opportunities[0].AccountID = accounts[0].id;
		opportunities[0].Phase_Status__c = 'Submitted for G4 Approval';
		 opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = accounts[1].id;
		insert opportunities; 
		
		opportunities[0].StageName = 'Create Offer (Bid)';
		opportunities[0].Phase_Status__c = 'Offer in Progress';
		opportunities[0].StageName='Create Offer (Bid)';
		opportunities[0].LOA_Level__c = '';
		opportunities[0].No_Loa__c = false;
		opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
		opportunities[0].G2_Approval_Date__c = Date.Today();
   
		opportunities[0].G3_Planned_Date__c =  Date.Today();
		opportunities[0].Account_Role__c = 'Alliance Partner';
   
		opportunities[0].G4_Planned_Date__c =  Date.Today();
   
		update opportunities[0];
		
		

		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(Name ='Commercial Price List', Apttus_Config2__Active__c = True);
		insert ApttusTestPriceList;

		
		
		
		Offer__c offer1 = new Offer__c(Name = 'Offer1',Opportunity__c = opportunities[0].Id,LoA_Approval_Level__c = Nokia_CPQ_Constants.LOABYPASS,LOA_Bypass__c = '',ActiveOffer__c=true);
		insert offer1;
		Test.StartTest();
		testProposal1 = new Apttus_Proposal__Proposal__c(
			RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Proposal').getRecordTypeId(),
			Apttus_Proposal__Account__c = accounts[0].Id,
			Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
			Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
			NokiaCPQ_Approval_Required_Flag__c=false,
			Apttus_Proposal__Approval_Stage__c=Nokia_CPQ_Constants.QUOTEDRAFT,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
			NokiaCPQ_FN_Maintenance_Type__c='',
			NokiaCPQ_SRS_Level__c='',
			NokiaCPQ_Existing_IONMaint_Contract__c='',
			NokiaCPQ_Needs_Reprice__c = false,
			Reprice_In_Progress__c = false,
			NokiaCPQ_Existing_FN_Maint_Contract__c='',
			NokiaCPQ_No_of_Years__c = '',
			NokiaCPQ_ION_Maintenance_Type__c='',
			NokiaCPQ_SSP_Level__c='',
			NokiaCPQ_Portfolio__c = 'Optics',
			NokiaCPQ_Maintenance_Type__c =''
		 
		 ); 
		insert testProposal1;
		Contact con = new Contact(firstname = 'kamlesh', lastname = 'jobseeker', accountId = accounts[0].Id);
		insert con;
		Id profileId = [SELECT Id FROM profile WHERE name ='PRM Partner Community User Login' limit 1].Id;
		//Id roleId = [SELECT Id,PortalType FROM userrole WHERE PortalType='Partner' AND PortalRole = 'Manager' LIMIT 1].Id;
		//Id roleId = [SELECT Id,PortalType FROM userrole WHERE PortalType='Partner' AND PortalRole = 'Worker' LIMIT 1].Id;
		
	
		
		
		//sysAdminUser[0].UserRoleId = roleId;
		//System.runAs(sysAdminUser[0]){
		
		
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		NokiaCPQ_QuoteHeaderNotesController puc = new  NokiaCPQ_QuoteHeaderNotesController(new ApexPages.StandardController(testProposal1));
		portalUser = new User( email='test.fdsfves4@gmail.com',
	profileid = profileId, 
	//UserRoleId = roleId,
	UserName='Test.partnerfsds@gmail.com', 
	Alias = 'GDS',
	TimeZoneSidKey='America/New_York',
	EmailEncodingKey='ISO-8859-1',
	LocaleSidKey='en_US', 
	LanguageLocaleKey='en_US',
	ContactId = con.Id,
	PortalRole = 'Manager',
	FirstName = 'Test',
	LastName = 'partner2323');
	
		insert portalUser;
		PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Nokia_CPQ_Partner_User'];
		insert new PermissionSetAssignment(AssigneeId = portalUser.id, PermissionSetId = ps.Id);
		
		
		}
		
		System.runAs(portalUser){
		
		
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		NokiaCPQ_QuoteHeaderNotesController puc = new  NokiaCPQ_QuoteHeaderNotesController(new ApexPages.StandardController(testProposal1));
		System.debug('[+] '+puc.warning);
		
		
		}

		

		Test.StopTest();
		
	}


		@isTest static void TestNA3(){

	
		 List<User> sysAdminUser = new List<User>();
		User u = NOKIA_CPQ_TestDataFactory.createSystemAdminUser();
		sysAdminUser.add(u);

		User portalUser ;
		Apttus_Proposal__Proposal__c testProposal1;

		System.runAs(sysAdminUser[0]){
		

		Account_Market__c setting = new Account_Market__c();
		setting.Name = 'Market Greater China';
		
		insert setting;
		List<Apttus_Proposal__Proposal__c> proposals=new List<Apttus_Proposal__Proposal__c>();
		List <Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		accounts[0].Partner_Type__c = '';
		accounts[0].Partner_Program__c = 'GPP 3.0';
		accounts[0].Market__c = 'Market Greater China';
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].AccountNumber='';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;

		Accreditation__c accreditation1 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_PRODUCT,
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Authorized',
	Partner__c=accounts[0].Id,
	Portfolio__c='Optics',
	Pricing_Cluster__c='NAM'	
	);
		Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_MAINTENANCE,
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Authorized',
	Partner__c=accounts[0].Id,
	Portfolio__c='Optics',
	Pricing_Cluster__c='NAM'	
	);
	
		insert accreditation1;
		insert accreditation2;

		 //create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].Lead_BG__c = 'MN';
		opportunities[0].StageName = 'Create Offer (Bid)';
		
		opportunities[0].AccountID = accounts[0].id;
		opportunities[0].Phase_Status__c = 'Submitted for G4 Approval';
		 opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = accounts[1].id;
		insert opportunities; 
		
		opportunities[0].StageName = 'Create Offer (Bid)';
		opportunities[0].Phase_Status__c = 'Offer in Progress';
		opportunities[0].StageName='Create Offer (Bid)';
		opportunities[0].LOA_Level__c = '';
		opportunities[0].No_Loa__c = false;
		opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
		opportunities[0].G2_Approval_Date__c = Date.Today();
   
		opportunities[0].G3_Planned_Date__c =  Date.Today();
		opportunities[0].Account_Role__c = 'Alliance Partner';
   
		opportunities[0].G4_Planned_Date__c =  Date.Today();
   
		update opportunities[0];
		
		

		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(Name ='Commercial Price List', Apttus_Config2__Active__c = True);
		insert ApttusTestPriceList;

		
		
		
		Offer__c offer1 = new Offer__c(Name = 'Offer1',Opportunity__c = opportunities[0].Id,LoA_Approval_Level__c = Nokia_CPQ_Constants.LOABYPASS,LOA_Bypass__c = GlobalConstants.LOA_BYPASS,ActiveOffer__c=true);
		insert offer1;
		Test.StartTest();
		testProposal1 = new Apttus_Proposal__Proposal__c(
			RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Proposal').getRecordTypeId(),
			Apttus_Proposal__Account__c = accounts[0].Id,
			Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
			Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
			NokiaCPQ_Approval_Required_Flag__c=false,
			Apttus_Proposal__Approval_Stage__c=Nokia_CPQ_Constants.QUOTEDRAFT,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
			NokiaCPQ_FN_Maintenance_Type__c='',
			NokiaCPQ_SRS_Level__c='',
			NokiaCPQ_Existing_IONMaint_Contract__c='',
			NokiaCPQ_Needs_Reprice__c = false,
			Reprice_In_Progress__c = false,
			NokiaCPQ_Existing_FN_Maint_Contract__c='',
			NokiaCPQ_No_of_Years__c = '',
			NokiaCPQ_ION_Maintenance_Type__c='',
			NokiaCPQ_SSP_Level__c='',
			NokiaCPQ_Portfolio__c = 'Optics',
			NokiaCPQ_Maintenance_Type__c =''
		 
		 ); 
		insert testProposal1;
		Contact con = new Contact(firstname = 'kamlesh', lastname = 'jobseeker', accountId = accounts[0].Id);
		insert con;
		Id profileId = [SELECT Id FROM profile WHERE name ='PRM Partner Community User Login' limit 1].Id;
		
		
		
		
		
		
		
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		NokiaCPQ_QuoteHeaderNotesController puc = new  NokiaCPQ_QuoteHeaderNotesController(new ApexPages.StandardController(testProposal1));
		portalUser = new User( email='test.fdsfves4@gmail.com',
	profileid = profileId, 
	//UserRoleId = roleId,
	UserName='Test.partnerfsds@gmail.com', 
	Alias = 'GDS',
	TimeZoneSidKey='America/New_York',
	EmailEncodingKey='ISO-8859-1',
	LocaleSidKey='en_US', 
	LanguageLocaleKey='en_US',
	ContactId = con.Id,
	PortalRole = 'Manager',
	FirstName = 'Test',
	LastName = 'partner2323');
	
		insert portalUser;
		PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Nokia_CPQ_Partner_User'];
		insert new PermissionSetAssignment(AssigneeId = portalUser.id, PermissionSetId = ps.Id);
		
		
		}

		System.runAs(portalUser){
		
		
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		NokiaCPQ_QuoteHeaderNotesController puc = new  NokiaCPQ_QuoteHeaderNotesController(new ApexPages.StandardController(testProposal1));
		System.debug('[+] '+puc.warning);
		
		
		}

		Test.StopTest();
		
	}

	/*
	@isTest static void TestNA4(){

	
		List<User> sysAdminUser = NOKIA_CPQ_TestDataFactory.userCreation(1,'System Administrator');
		insert sysAdminUser;
		

		
		List<Apttus_Proposal__Proposal__c> proposals=new List<Apttus_Proposal__Proposal__c>();
		List <Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		accounts[0].Partner_Type__c = '';
		accounts[0].Partner_Program__c = 'GPP 3.0';
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].AccountNumber='';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;

		Accreditation__c accreditation1 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_PRODUCT,
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Authorized',
	Partner__c=accounts[0].Id,
	Portfolio__c='Optics',
	Pricing_Cluster__c='NAM'	
	);
		Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_MAINTENANCE,
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Authorized',
	Partner__c=accounts[0].Id,
	Portfolio__c='Optics',
	Pricing_Cluster__c='NAM'	
	);
	
		insert accreditation1;
		insert accreditation2;

		 //create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].StageName = 'Create Offer (Bid)';
		
		opportunities[0].AccountID = accounts[0].id;
		opportunities[0].Phase_Status__c = 'Submitted for G4 Approval';
		 opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = accounts[1].id;
		insert opportunities; 
		
		opportunities[0].StageName = 'Create Offer (Bid)';
		opportunities[0].Phase_Status__c = 'Offer in Progress';
		opportunities[0].StageName='Create Offer (Bid)';
		opportunities[0].LOA_Level__c = '';
		opportunities[0].No_Loa__c = false;
		opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
		opportunities[0].G2_Approval_Date__c = Date.Today();
   
		opportunities[0].G3_Planned_Date__c =  Date.Today();
		opportunities[0].Account_Role__c = 'Alliance Partner';
   
		opportunities[0].G4_Planned_Date__c =  Date.Today();
   
		update opportunities[0];
		List<OpportunityTeamMember> opportunityTeamMemberList = new List<OpportunityTeamMember>();
		opportunityTeamMemberList = TestDataFactory.optyTeamMemberCreation(2, sysAdminUser[0],opportunities[0]);
		opportunityTeamMemberList[0].TeamMemberRole = 'Pricing Manager';
		opportunityTeamMemberList[1].TeamMemberRole  = 'Pricing Manager';
		insert opportunityTeamMemberList;
		
		

		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(Name ='Commercial Price List', Apttus_Config2__Active__c = True);
		insert ApttusTestPriceList;

		
		
		
		Offer__c offer1 = new Offer__c(Name = 'Offer1',Expected_LoA_G4_Approval_Level__c=Nokia_CPQ_Constants.LOABYPASS,Opportunity__c = opportunities[0].Id,LoA_Approval_Level__c = Nokia_CPQ_Constants.LOABYPASS,LOA_Bypass__c = GlobalConstants.PICKLIST_VALUE_AUTHORIZED_FOR_PRICING_MANAGER,ActiveOffer__c=true);
		insert offer1;
		Test.StartTest();
		Apttus_Proposal__Proposal__c testProposal1 = new Apttus_Proposal__Proposal__c(
			RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Proposal').getRecordTypeId(),
			Apttus_Proposal__Account__c = accounts[0].Id,
			Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
			Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
			NokiaCPQ_Approval_Required_Flag__c=false,
			Apttus_Proposal__Approval_Stage__c=Nokia_CPQ_Constants.QUOTEDRAFT,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
			NokiaCPQ_FN_Maintenance_Type__c='',
			NokiaCPQ_SRS_Level__c='',
			NokiaCPQ_Existing_IONMaint_Contract__c='',
			NokiaCPQ_Needs_Reprice__c = false,
			Reprice_In_Progress__c = false,
			NokiaCPQ_Existing_FN_Maint_Contract__c='',
			NokiaCPQ_No_of_Years__c = '',
			NokiaCPQ_ION_Maintenance_Type__c='',
			NokiaCPQ_SSP_Level__c='',
			NokiaCPQ_Portfolio__c = 'Optics',
			NokiaCPQ_Maintenance_Type__c =''
		 
		 ); 
		insert testProposal1;
		Contact con = new Contact(firstname = 'kamlesh', lastname = 'jobseeker', accountId = accounts[0].Id);
		insert con;
		Id profileId = [SELECT Id FROM profile WHERE name ='PRM Partner Community User Login' limit 1].Id;
		Id roleId = [SELECT Id,PortalType FROM userrole WHERE PortalType='Partner' AND PortalRole = 'Manager' LIMIT 1].Id;
		
		
		sysAdminUser[0].UserRoleId = roleId;
		System.runAs(sysAdminUser[0]){
		
		
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		NokiaCPQ_QuoteHeaderNotesController puc = new  NokiaCPQ_QuoteHeaderNotesController(new ApexPages.StandardController(testProposal1));
		portalUser = new User( email='test.fdsfves4@gmail.com',
	profileid = profileId, 
	UserRoleId = roleId,
	UserName='Test.partnerfsds@gmail.com', 
	Alias = 'GDS',
	TimeZoneSidKey='America/New_York',
	EmailEncodingKey='ISO-8859-1',
	LocaleSidKey='en_US', 
	LanguageLocaleKey='en_US',
	ContactId = con.Id,
	PortalRole = 'Manager',
	FirstName = 'Test',
	LastName = 'partner2323');
	
		insert portalUser;
		PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Nokia_CPQ_Partner_User'];
		insert new PermissionSetAssignment(AssigneeId = portalUser.id, PermissionSetId = ps.Id);
		
		
		}

		System.runAs(portalUser){
		
		
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		NokiaCPQ_QuoteHeaderNotesController puc = new  NokiaCPQ_QuoteHeaderNotesController(new ApexPages.StandardController(testProposal1));
		System.debug('[+] '+puc.warning);
		
		
		}

		Test.StopTest();
		
	}*/



	@isTest static void TestNA6(){

	
		 List<User> sysAdminUser = new List<User>();
		User u = NOKIA_CPQ_TestDataFactory.createSystemAdminUser();
		sysAdminUser.add(u);
		User portalUser ;
		Apttus_Proposal__Proposal__c testProposal1;

		System.runAs(sysAdminUser[0]){
		

		
		List<Apttus_Proposal__Proposal__c> proposals=new List<Apttus_Proposal__Proposal__c>();
		List <Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		accounts[0].Partner_Type__c = '';
		accounts[0].Partner_Program__c = 'GPP 3.0';
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].AccountNumber='';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;

		Accreditation__c accreditation1 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_PRODUCT,
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Authorized',
	Partner__c=accounts[0].Id,
	Portfolio__c='Optics',
	Pricing_Cluster__c='NAM'	
	);
		Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_MAINTENANCE,
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Authorized',
	Partner__c=accounts[0].Id,
	Portfolio__c='Optics',
	Pricing_Cluster__c='NAM'	
	);
	
		insert accreditation1;
		insert accreditation2;

		 //create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].StageName = 'Create Offer (Bid)';
		
		opportunities[0].AccountID = accounts[0].id;
		opportunities[0].Phase_Status__c = 'Submitted for G4 Approval';
		 opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = accounts[1].id;
		insert opportunities; 
		
		opportunities[0].StageName = 'Create Offer (Bid)';
		opportunities[0].Phase_Status__c = 'Offer in Progress';
		opportunities[0].StageName='Create Offer (Bid)';
		opportunities[0].LOA_Level__c = '';
		opportunities[0].No_Loa__c = false;
		opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
		opportunities[0].G2_Approval_Date__c = Date.Today();
   
		opportunities[0].G3_Planned_Date__c =  Date.Today();
		opportunities[0].Account_Role__c = 'Alliance Partner';
   
		opportunities[0].G4_Planned_Date__c =  Date.Today();
   
		update opportunities[0];
		
		

		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(Name ='Commercial Price List', Apttus_Config2__Active__c = True);
		insert ApttusTestPriceList;

		
		
		
		Offer__c offer1 = new Offer__c(Name = 'Offer1',Opportunity__c = opportunities[0].Id,LoA_Approval_Level__c = GlobalConstants.LOA_Level_A_Plus,LOA_Bypass__c = GlobalConstants.NO_LOA,ActiveOffer__c=true);
		insert offer1;
		Test.StartTest();
		testProposal1 = new Apttus_Proposal__Proposal__c(
			RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Proposal').getRecordTypeId(),
			Apttus_Proposal__Account__c = accounts[0].Id,
			Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
			Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
			NokiaCPQ_Approval_Required_Flag__c=false,
			Apttus_Proposal__Approval_Stage__c=Nokia_CPQ_Constants.QUOTEDRAFT,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
			NokiaCPQ_FN_Maintenance_Type__c='',
			NokiaCPQ_SRS_Level__c='',
			NokiaCPQ_Existing_IONMaint_Contract__c='',
			NokiaCPQ_Needs_Reprice__c = false,
			Reprice_In_Progress__c = false,
			NokiaCPQ_Existing_FN_Maint_Contract__c='',
			NokiaCPQ_No_of_Years__c = '',
			NokiaCPQ_ION_Maintenance_Type__c='',
			NokiaCPQ_SSP_Level__c='',
			NokiaCPQ_Portfolio__c = 'Optics',
			NokiaCPQ_Maintenance_Type__c =''
		 
		 ); 
		insert testProposal1;
		Contact con = new Contact(firstname = 'kamlesh', lastname = 'jobseeker', accountId = accounts[0].Id);
		insert con;
		Id profileId = [SELECT Id FROM profile WHERE name ='PRM Partner Community User Login' limit 1].Id;
		
		
		
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		NokiaCPQ_QuoteHeaderNotesController puc = new  NokiaCPQ_QuoteHeaderNotesController(new ApexPages.StandardController(testProposal1));
		portalUser = new User( email='test.fdsfves4@gmail.com',
	profileid = profileId, 
	//UserRoleId = roleId,
	UserName='Test.partnerfsds@gmail.com', 
	Alias = 'GDS',
	TimeZoneSidKey='America/New_York',
	EmailEncodingKey='ISO-8859-1',
	LocaleSidKey='en_US', 
	LanguageLocaleKey='en_US',
	ContactId = con.Id,
	PortalRole = 'Manager',
	FirstName = 'Test',
	LastName = 'partner2323');
	
		insert portalUser;
		PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Nokia_CPQ_Partner_User'];
		insert new PermissionSetAssignment(AssigneeId = portalUser.id, PermissionSetId = ps.Id);
		
		
		}

		System.runAs(portalUser){
		
		
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		NokiaCPQ_QuoteHeaderNotesController puc = new  NokiaCPQ_QuoteHeaderNotesController(new ApexPages.StandardController(testProposal1));
		System.debug('[+] '+puc.warning);
		
		
		}

		Test.StopTest();
		
	}


/*
	@isTest static void TestAR2(){

	
		
		List<User> sysAdminUser = new List<User>();
		User u = NOKIA_CPQ_TestDataFactory.createSystemAdminUser();
		sysAdminUser.add(u);
		User portalUser ;
		Apttus_Proposal__Proposal__c testProposal1;

		System.runAs(sysAdminUser[0]){
		

		
		List<Apttus_Proposal__Proposal__c> proposals=new List<Apttus_Proposal__Proposal__c>();
		List <Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		accounts[0].Partner_Type__c = '';
		accounts[0].Partner_Program__c = 'GPP 3.0';
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].AccountNumber='';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;

		Accreditation__c accreditation1 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_PRODUCT,
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Authorized',
	Partner__c=accounts[0].Id,
	Portfolio__c='Optics',
	Pricing_Cluster__c='NAM'	
	);
		Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_MAINTENANCE,
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Authorized',
	Partner__c=accounts[0].Id,
	Portfolio__c='Optics',
	Pricing_Cluster__c='NAM'	
	);
	
		insert accreditation1;
		insert accreditation2;

		 //create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].StageName = 'Create Offer (Bid)';
		
		opportunities[0].AccountID = accounts[0].id;
		opportunities[0].Phase_Status__c = 'Submitted for G4 Approval';
		 opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = accounts[1].id;
		insert opportunities; 
		
		opportunities[0].StageName = 'Create Offer (Bid)';
		opportunities[0].Phase_Status__c = 'Offer in Progress';
		opportunities[0].StageName='Create Offer (Bid)';
		opportunities[0].LOA_Level__c = '';
		opportunities[0].No_Loa__c = false;
		opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
		opportunities[0].G2_Approval_Date__c = Date.Today();
   
		opportunities[0].G3_Planned_Date__c =  Date.Today();
		opportunities[0].Account_Role__c = 'Alliance Partner';
   
		opportunities[0].G4_Planned_Date__c =  Date.Today();
   
		update opportunities[0];
		
		

		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(Name ='Commercial Price List', Apttus_Config2__Active__c = True);
		insert ApttusTestPriceList;

		
		
		
		Offer__c offer1 = new Offer__c(Name = 'Offer1',Expected_LoA_G4_Approval_Level__c=Nokia_CPQ_Constants.LOABYPASS,Opportunity__c = opportunities[0].Id,LoA_Approval_Level__c = '',LOA_Bypass__c = GlobalConstants.NO_LOA,ActiveOffer__c=true);
		insert offer1;
		Test.StartTest();
		testProposal1 = new Apttus_Proposal__Proposal__c(
			RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Proposal').getRecordTypeId(),
			Apttus_Proposal__Account__c = accounts[0].Id,
			Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
			Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
			NokiaCPQ_Approval_Required_Flag__c=false,
			Apttus_Proposal__Approval_Stage__c=Nokia_CPQ_Constants.QUOTEDRAFT,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
			NokiaCPQ_FN_Maintenance_Type__c='',
			NokiaCPQ_SRS_Level__c='',
			NokiaCPQ_Existing_IONMaint_Contract__c='',
			NokiaCPQ_Needs_Reprice__c = false,
			Reprice_In_Progress__c = false,
			NokiaCPQ_Existing_FN_Maint_Contract__c='',
			NokiaCPQ_No_of_Years__c = '',
			NokiaCPQ_ION_Maintenance_Type__c='',
			NokiaCPQ_SSP_Level__c='',
			NokiaCPQ_Portfolio__c = 'Optics',
			NokiaCPQ_Maintenance_Type__c =''
		 
		 ); 
		insert testProposal1;
		Contact con = new Contact(firstname = 'kamlesh', lastname = 'jobseeker', accountId = accounts[0].Id);
		insert con;
		Id profileId = [SELECT Id FROM profile WHERE name ='PRM Partner Community User Login' limit 1].Id;
		
		
		
	
		
		
		
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		NokiaCPQ_QuoteHeaderNotesController puc = new  NokiaCPQ_QuoteHeaderNotesController(new ApexPages.StandardController(testProposal1));
		portalUser = new User( email='test.fdsfves4@gmail.com',
	profileid = profileId, 
	//UserRoleId = roleId,
	UserName='Test.partnerfsds@gmail.com', 
	Alias = 'GDS',
	TimeZoneSidKey='America/New_York',
	EmailEncodingKey='ISO-8859-1',
	LocaleSidKey='en_US', 
	LanguageLocaleKey='en_US',
	ContactId = con.Id,
	PortalRole = 'Manager',
	FirstName = 'Test',
	LastName = 'partner2323');
	
		insert portalUser;
		PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Nokia_CPQ_Partner_User'];
		insert new PermissionSetAssignment(AssigneeId = portalUser.id, PermissionSetId = ps.Id);
		
		
		}

		System.runAs(portalUser){
		
		
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		NokiaCPQ_QuoteHeaderNotesController puc = new  NokiaCPQ_QuoteHeaderNotesController(new ApexPages.StandardController(testProposal1));
		System.debug('[+] '+puc.warning);
		
		
		}

		Test.StopTest();
		
	}
	*/



	/*
	@isTest static void TestAR3(){

	
		
		List<User> sysAdminUser = new List<User>();
		User u = NOKIA_CPQ_TestDataFactory.createSystemAdminUser();
		sysAdminUser.add(u);
		User portalUser ;
		Apttus_Proposal__Proposal__c testProposal1;

		System.runAs(sysAdminUser[0]){
		

		Account_Market__c setting = new Account_Market__c();
		setting.Name = 'Market Greater China';
		
		insert setting;
		List<Apttus_Proposal__Proposal__c> proposals=new List<Apttus_Proposal__Proposal__c>();
		List <Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		accounts[0].Partner_Type__c = '';
		accounts[0].Partner_Program__c = 'GPP 3.0';
		accounts[0].Market__c = 'Market Greater China';
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].AccountNumber='';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;

		Accreditation__c accreditation1 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_PRODUCT,
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Authorized',
	Partner__c=accounts[0].Id,
	Portfolio__c='Optics',
	Pricing_Cluster__c='NAM'	
	);
		Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_MAINTENANCE,
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Authorized',
	Partner__c=accounts[0].Id,
	Portfolio__c='Optics',
	Pricing_Cluster__c='NAM'	
	);
	
		insert accreditation1;
		insert accreditation2;

		 //create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].Lead_BG__c = 'MN';
		opportunities[0].StageName = 'Create Offer (Bid)';
		
		opportunities[0].AccountID = accounts[0].id;
		opportunities[0].Phase_Status__c = 'Submitted for G4 Approval';
		 opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = accounts[1].id;
		insert opportunities; 
		
		opportunities[0].StageName = 'Create Offer (Bid)';
		opportunities[0].Phase_Status__c = 'Offer in Progress';
		opportunities[0].StageName='Create Offer (Bid)';
		opportunities[0].LOA_Level__c = '';
		opportunities[0].No_Loa__c = false;
		opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
		opportunities[0].G2_Approval_Date__c = Date.Today();
   
		opportunities[0].G3_Planned_Date__c =  Date.Today();
		opportunities[0].Account_Role__c = 'Alliance Partner';
   
		opportunities[0].G4_Planned_Date__c =  Date.Today();
   
		update opportunities[0];
		
		

		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(Name ='Commercial Price List', Apttus_Config2__Active__c = True);
		insert ApttusTestPriceList;

		
		
		
		Offer__c offer1 = new Offer__c(Name = 'Offer1',Expected_LoA_G4_Approval_Level__c=Nokia_CPQ_Constants.LOABYPASS,Opportunity__c = opportunities[0].Id,LoA_Approval_Level__c = '',LOA_Bypass__c = GlobalConstants.LOA_BYPASS,ActiveOffer__c=true);
		insert offer1;
		Test.StartTest();
		testProposal1 = new Apttus_Proposal__Proposal__c(
			RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Proposal').getRecordTypeId(),
			Apttus_Proposal__Account__c = accounts[0].Id,
			Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
			Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
			NokiaCPQ_Approval_Required_Flag__c=false,
			Apttus_Proposal__Approval_Stage__c=Nokia_CPQ_Constants.QUOTEDRAFT,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
			NokiaCPQ_FN_Maintenance_Type__c='',
			NokiaCPQ_SRS_Level__c='',
			NokiaCPQ_Existing_IONMaint_Contract__c='',
			NokiaCPQ_Needs_Reprice__c = false,
			Reprice_In_Progress__c = false,
			NokiaCPQ_Existing_FN_Maint_Contract__c='',
			NokiaCPQ_No_of_Years__c = '',
			NokiaCPQ_ION_Maintenance_Type__c='',
			NokiaCPQ_SSP_Level__c='',
			NokiaCPQ_Portfolio__c = 'Optics',
			NokiaCPQ_Maintenance_Type__c =''
		 
		 ); 
		insert testProposal1;
		Contact con = new Contact(firstname = 'kamlesh', lastname = 'jobseeker', accountId = accounts[0].Id);
		insert con;
		Id profileId = [SELECT Id FROM profile WHERE name ='PRM Partner Community User Login' limit 1].Id;
		
		
		
		
		
		
		
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		NokiaCPQ_QuoteHeaderNotesController puc = new  NokiaCPQ_QuoteHeaderNotesController(new ApexPages.StandardController(testProposal1));
		portalUser = new User( email='test.fdsfves4@gmail.com',
	profileid = profileId, 
	//UserRoleId = roleId,
	UserName='Test.partnerfsds@gmail.com', 
	Alias = 'GDS',
	TimeZoneSidKey='America/New_York',
	EmailEncodingKey='ISO-8859-1',
	LocaleSidKey='en_US', 
	LanguageLocaleKey='en_US',
	ContactId = con.Id,
	PortalRole = 'Manager',
	FirstName = 'Test',
	LastName = 'partner2323');
	
		insert portalUser;
		PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Nokia_CPQ_Partner_User'];
		insert new PermissionSetAssignment(AssigneeId = portalUser.id, PermissionSetId = ps.Id);
		
		
		}

		System.runAs(portalUser){
		
		
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		NokiaCPQ_QuoteHeaderNotesController puc = new  NokiaCPQ_QuoteHeaderNotesController(new ApexPages.StandardController(testProposal1));
		System.debug('[+] '+puc.warning);
		
		
		}

		Test.StopTest();
		
	}
	*/


	/*
	@isTest static void TestAR4(){

	
		
		List<User> sysAdminUser = NOKIA_CPQ_TestDataFactory.userCreation(1,'System Administrator');
		insert sysAdminUser;
		
		

		
		List<Apttus_Proposal__Proposal__c> proposals=new List<Apttus_Proposal__Proposal__c>();
		List <Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		accounts[0].Partner_Type__c = '';
		accounts[0].Partner_Program__c = 'GPP 3.0';
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].AccountNumber='';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;

		Accreditation__c accreditation1 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_PRODUCT,
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Authorized',
	Partner__c=accounts[0].Id,
	Portfolio__c='Optics',
	Pricing_Cluster__c='NAM'	
	);
		Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_MAINTENANCE,
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Authorized',
	Partner__c=accounts[0].Id,
	Portfolio__c='Optics',
	Pricing_Cluster__c='NAM'	
	);
	
		insert accreditation1;
		insert accreditation2;

		 //create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].StageName = 'Create Offer (Bid)';
		
		opportunities[0].AccountID = accounts[0].id;
		opportunities[0].Phase_Status__c = 'Submitted for G4 Approval';
		 opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = accounts[1].id;
		insert opportunities; 
		
		opportunities[0].StageName = 'Create Offer (Bid)';
		opportunities[0].Phase_Status__c = 'Offer in Progress';
		opportunities[0].StageName='Create Offer (Bid)';
		opportunities[0].LOA_Level__c = '';
		opportunities[0].No_Loa__c = false;
		opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
		opportunities[0].G2_Approval_Date__c = Date.Today();
   
		opportunities[0].G3_Planned_Date__c =  Date.Today();
		opportunities[0].Account_Role__c = 'Alliance Partner';
   
		opportunities[0].G4_Planned_Date__c =  Date.Today();
   
		update opportunities[0];
		List<OpportunityTeamMember> opportunityTeamMemberList = new List<OpportunityTeamMember>();
		opportunityTeamMemberList = TestDataFactory.optyTeamMemberCreation(2, sysAdminUser[0],opportunities[0]);
		opportunityTeamMemberList[0].TeamMemberRole = 'Pricing Manager';
		opportunityTeamMemberList[1].TeamMemberRole  = 'Pricing Manager';
		insert opportunityTeamMemberList;
		

		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(Name ='Commercial Price List', Apttus_Config2__Active__c = True);
		insert ApttusTestPriceList;

		
		
		
		Offer__c offer1 = new Offer__c(Name = 'Offer1',Expected_LoA_G4_Approval_Level__c=Nokia_CPQ_Constants.LOABYPASS,Opportunity__c = opportunities[0].Id,LoA_Approval_Level__c = '',LOA_Bypass__c = GlobalConstants.PICKLIST_VALUE_AUTHORIZED_FOR_PRICING_MANAGER,ActiveOffer__c=true);
		insert offer1;
		Test.StartTest();
		Apttus_Proposal__Proposal__c testProposal1 = new Apttus_Proposal__Proposal__c(
			RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Proposal').getRecordTypeId(),
			Apttus_Proposal__Account__c = accounts[0].Id,
			Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
			Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
			NokiaCPQ_Approval_Required_Flag__c=false,
			Apttus_Proposal__Approval_Stage__c=Nokia_CPQ_Constants.QUOTEDRAFT,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
			NokiaCPQ_FN_Maintenance_Type__c='',
			NokiaCPQ_SRS_Level__c='',
			NokiaCPQ_Existing_IONMaint_Contract__c='',
			NokiaCPQ_Needs_Reprice__c = false,
			Reprice_In_Progress__c = false,
			NokiaCPQ_Existing_FN_Maint_Contract__c='',
			NokiaCPQ_No_of_Years__c = '',
			NokiaCPQ_ION_Maintenance_Type__c='',
			NokiaCPQ_SSP_Level__c='',
			NokiaCPQ_Portfolio__c = 'Optics',
			NokiaCPQ_Maintenance_Type__c =''
		 
		 ); 
		insert testProposal1;
		Contact con = new Contact(firstname = 'kamlesh', lastname = 'jobseeker', accountId = accounts[0].Id);
		insert con;
		Id profileId = [SELECT Id FROM profile WHERE name ='PRM Partner Community User Login' limit 1].Id;
		Id roleId = [SELECT Id,PortalType FROM userrole WHERE PortalType='Partner' AND PortalRole = 'Manager' LIMIT 1].Id;
		
		
		sysAdminUser[0].UserRoleId = roleId;
		System.runAs(sysAdminUser[0]){
		
		
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		NokiaCPQ_QuoteHeaderNotesController puc = new  NokiaCPQ_QuoteHeaderNotesController(new ApexPages.StandardController(testProposal1));
		portalUser = new User( email='test.fdsfves4@gmail.com',
	profileid = profileId, 
	UserRoleId = roleId,
	UserName='Test.partnerfsds@gmail.com', 
	Alias = 'GDS',
	TimeZoneSidKey='America/New_York',
	EmailEncodingKey='ISO-8859-1',
	LocaleSidKey='en_US', 
	LanguageLocaleKey='en_US',
	ContactId = con.Id,
	PortalRole = 'Manager',
	FirstName = 'Test',
	LastName = 'partner2323');
	
		insert portalUser;
		PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Nokia_CPQ_Partner_User'];
		insert new PermissionSetAssignment(AssigneeId = portalUser.id, PermissionSetId = ps.Id);
		
		
		}

		System.runAs(portalUser){
		
		
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		NokiaCPQ_QuoteHeaderNotesController puc = new  NokiaCPQ_QuoteHeaderNotesController(new ApexPages.StandardController(testProposal1));
		System.debug('[+] '+puc.warning);
		
		
		}

		Test.StopTest();
		
	}*/


	/*
	@isTest static void TestAR5(){

	
		
		List<User> sysAdminUser = new List<User>();
		User u = NOKIA_CPQ_TestDataFactory.createSystemAdminUser();
		sysAdminUser.add(u);
		User portalUser ;
		Apttus_Proposal__Proposal__c testProposal1;

		System.runAs(sysAdminUser[0]){
		

		
		List<Apttus_Proposal__Proposal__c> proposals=new List<Apttus_Proposal__Proposal__c>();
		List <Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		accounts[0].Partner_Type__c = '';
		accounts[0].Partner_Program__c = 'GPP 3.0';
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].AccountNumber='';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;

		Accreditation__c accreditation1 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_PRODUCT,
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Authorized',
	Partner__c=accounts[0].Id,
	Portfolio__c='Optics',
	Pricing_Cluster__c='NAM'	
	);
		Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_MAINTENANCE,
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Authorized',
	Partner__c=accounts[0].Id,
	Portfolio__c='Optics',
	Pricing_Cluster__c='NAM'	
	);
	
		insert accreditation1;
		insert accreditation2;

		 //create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].StageName = 'Create Offer (Bid)';
		
		opportunities[0].AccountID = accounts[0].id;
		opportunities[0].Phase_Status__c = 'Submitted for G4 Approval';
		 opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = accounts[1].id;
		insert opportunities; 
		
		opportunities[0].StageName = 'Create Offer (Bid)';
		opportunities[0].Phase_Status__c = 'Offer in Progress';
		opportunities[0].StageName='Create Offer (Bid)';
		opportunities[0].LOA_Level__c = '';
		opportunities[0].No_Loa__c = false;
		opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
		opportunities[0].G2_Approval_Date__c = Date.Today();
   
		opportunities[0].G3_Planned_Date__c =  Date.Today();
		opportunities[0].Account_Role__c = 'Alliance Partner';
   
		opportunities[0].G4_Planned_Date__c =  Date.Today();
   
		update opportunities[0];
		
		

		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(Name ='Commercial Price List', Apttus_Config2__Active__c = True);
		insert ApttusTestPriceList;

		
		
		
		Offer__c offer1 = new Offer__c(Name = 'Offer1',Expected_LoA_G4_Approval_Level__c=Nokia_CPQ_Constants.LOABYPASS,Opportunity__c = opportunities[0].Id,LoA_Approval_Level__c = Nokia_CPQ_Constants.LOABYPASS,LOA_Bypass__c = '',ActiveOffer__c=true);
		insert offer1;
		Test.StartTest();
		testProposal1 = new Apttus_Proposal__Proposal__c(
			RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Proposal').getRecordTypeId(),
			Apttus_Proposal__Account__c = accounts[0].Id,
			Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
			Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
			NokiaCPQ_Approval_Required_Flag__c=false,
			Apttus_Proposal__Approval_Stage__c=Nokia_CPQ_Constants.QUOTEDRAFT,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
			NokiaCPQ_FN_Maintenance_Type__c='',
			NokiaCPQ_SRS_Level__c='',
			NokiaCPQ_Existing_IONMaint_Contract__c='',
			NokiaCPQ_Needs_Reprice__c = false,
			Reprice_In_Progress__c = false,
			NokiaCPQ_Existing_FN_Maint_Contract__c='',
			NokiaCPQ_No_of_Years__c = '',
			NokiaCPQ_ION_Maintenance_Type__c='',
			NokiaCPQ_SSP_Level__c='',
			NokiaCPQ_Portfolio__c = 'Optics',
			NokiaCPQ_Maintenance_Type__c =''
		 
		 ); 
		insert testProposal1;
		Contact con = new Contact(firstname = 'kamlesh', lastname = 'jobseeker', accountId = accounts[0].Id);
		insert con;
		Id profileId = [SELECT Id FROM profile WHERE name ='PRM Partner Community User Login' limit 1].Id;
		
		
		
		
		
		
		
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		NokiaCPQ_QuoteHeaderNotesController puc = new  NokiaCPQ_QuoteHeaderNotesController(new ApexPages.StandardController(testProposal1));
		portalUser = new User( email='test.fdsfves4@gmail.com',
	profileid = profileId, 
	//UserRoleId = roleId,
	UserName='Test.partnerfsds@gmail.com', 
	Alias = 'GDS',
	TimeZoneSidKey='America/New_York',
	EmailEncodingKey='ISO-8859-1',
	LocaleSidKey='en_US', 
	LanguageLocaleKey='en_US',
	ContactId = con.Id,
	PortalRole = 'Manager',
	FirstName = 'Test',
	LastName = 'partner2323');
	
		insert portalUser;
		PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Nokia_CPQ_Partner_User'];
		insert new PermissionSetAssignment(AssigneeId = portalUser.id, PermissionSetId = ps.Id);
		
		
		}

		System.runAs(portalUser){
		
		
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		NokiaCPQ_QuoteHeaderNotesController puc = new  NokiaCPQ_QuoteHeaderNotesController(new ApexPages.StandardController(testProposal1));
		System.debug('[+] '+puc.warning);
		
		
		}

		Test.StopTest();
		
	}
	*/


	/*
	@isTest static void TestAR6(){

	
		
		List<User> sysAdminUser = new List<User>();
		User u = NOKIA_CPQ_TestDataFactory.createSystemAdminUser();
		sysAdminUser.add(u);
		User portalUser ;
		Apttus_Proposal__Proposal__c testProposal1;

		System.runAs(sysAdminUser[0]){
		

		
		List<Apttus_Proposal__Proposal__c> proposals=new List<Apttus_Proposal__Proposal__c>();
		List <Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		accounts[0].Partner_Type__c = '';
		accounts[0].Partner_Program__c = 'GPP 3.0';
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].AccountNumber='';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;

		Accreditation__c accreditation1 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_PRODUCT,
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Authorized',
	Partner__c=accounts[0].Id,
	Portfolio__c='Optics',
	Pricing_Cluster__c='NAM'	
	);
		Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_MAINTENANCE,
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Authorized',
	Partner__c=accounts[0].Id,
	Portfolio__c='Optics',
	Pricing_Cluster__c='NAM'	
	);
	
		insert accreditation1;
		insert accreditation2;

		 //create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].StageName = 'Create Offer (Bid)';
		
		opportunities[0].AccountID = accounts[0].id;
		opportunities[0].Phase_Status__c = 'Submitted for G4 Approval';
		 opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = accounts[1].id;
		insert opportunities; 
		
		opportunities[0].StageName = 'Create Offer (Bid)';
		opportunities[0].Phase_Status__c = 'Offer in Progress';
		opportunities[0].StageName='Create Offer (Bid)';
		opportunities[0].LOA_Level__c = '';
		opportunities[0].No_Loa__c = false;
		opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
		opportunities[0].G2_Approval_Date__c = Date.Today();
   
		opportunities[0].G3_Planned_Date__c =  Date.Today();
		opportunities[0].Account_Role__c = 'Alliance Partner';
   
		opportunities[0].G4_Planned_Date__c =  Date.Today();
   
		update opportunities[0];
		
		
		

		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(Name ='Commercial Price List', Apttus_Config2__Active__c = True);
		insert ApttusTestPriceList;

		
		
		
		Offer__c offer1 = new Offer__c(Name = 'Offer1',Expected_LoA_G4_Approval_Level__c=Nokia_CPQ_Constants.LOABYPASS,Opportunity__c = opportunities[0].Id,LoA_Approval_Level__c = Nokia_CPQ_Constants.LOABYPASS,LOA_Bypass__c = GlobalConstants.NO_LOA,ActiveOffer__c=true);
		insert offer1;
		Test.StartTest();
		testProposal1 = new Apttus_Proposal__Proposal__c(
			RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Proposal').getRecordTypeId(),
			Apttus_Proposal__Account__c = accounts[0].Id,
			Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
			Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
			NokiaCPQ_Approval_Required_Flag__c=false,
			Apttus_Proposal__Approval_Stage__c=Nokia_CPQ_Constants.QUOTEDRAFT,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
			NokiaCPQ_FN_Maintenance_Type__c='',
			NokiaCPQ_SRS_Level__c='',
			NokiaCPQ_Existing_IONMaint_Contract__c='',
			NokiaCPQ_Needs_Reprice__c = false,
			Reprice_In_Progress__c = false,
			NokiaCPQ_Existing_FN_Maint_Contract__c='',
			NokiaCPQ_No_of_Years__c = '',
			NokiaCPQ_ION_Maintenance_Type__c='',
			NokiaCPQ_SSP_Level__c='',
			NokiaCPQ_Portfolio__c = 'Optics',
			NokiaCPQ_Maintenance_Type__c =''
		 
		 ); 
		insert testProposal1;
		Contact con = new Contact(firstname = 'kamlesh', lastname = 'jobseeker', accountId = accounts[0].Id);
		insert con;
		Id profileId = [SELECT Id FROM profile WHERE name ='PRM Partner Community User Login' limit 1].Id;
		
		
		
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		NokiaCPQ_QuoteHeaderNotesController puc = new  NokiaCPQ_QuoteHeaderNotesController(new ApexPages.StandardController(testProposal1));
		portalUser = new User( email='test.fdsfves4@gmail.com',
	profileid = profileId, 
	//UserRoleId = roleId,
	UserName='Test.partnerfsds@gmail.com', 
	Alias = 'GDS',
	TimeZoneSidKey='America/New_York',
	EmailEncodingKey='ISO-8859-1',
	LocaleSidKey='en_US', 
	LanguageLocaleKey='en_US',
	ContactId = con.Id,
	PortalRole = 'Manager',
	FirstName = 'Test',
	LastName = 'partner2323');
	
		insert portalUser;
		PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Nokia_CPQ_Partner_User'];
		insert new PermissionSetAssignment(AssigneeId = portalUser.id, PermissionSetId = ps.Id);
		
		
		}

		System.runAs(portalUser){
		
		
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		NokiaCPQ_QuoteHeaderNotesController puc = new  NokiaCPQ_QuoteHeaderNotesController(new ApexPages.StandardController(testProposal1));
		System.debug('[+] '+puc.warning);
		
		
		}

		Test.StopTest();
		
	}
	*/



	@isTest static void TestNA8(){

	
		
		List<User> sysAdminUser = new List<User>();
		User u = NOKIA_CPQ_TestDataFactory.createSystemAdminUser();
		sysAdminUser.add(u);
		User portalUser ;
		Apttus_Proposal__Proposal__c testProposal1;

		System.runAs(sysAdminUser[0]){
		

		
		List<Apttus_Proposal__Proposal__c> proposals=new List<Apttus_Proposal__Proposal__c>();
		List <Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		accounts[0].Partner_Type__c = '';
		accounts[0].Partner_Program__c = 'GPP 3.0';
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].AccountNumber='';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;

		Accreditation__c accreditation1 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_PRODUCT,
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Authorized',
	Partner__c=accounts[0].Id,
	Portfolio__c='Optics',
	Pricing_Cluster__c='NAM'	
	);
		Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_MAINTENANCE,
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Authorized',
	Partner__c=accounts[0].Id,
	Portfolio__c='Optics',
	Pricing_Cluster__c='NAM'	
	);
	
		insert accreditation1;
		insert accreditation2;

		 //create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].StageName = 'Create Offer (Bid)';
		
		opportunities[0].AccountID = accounts[0].id;
		opportunities[0].Phase_Status__c = 'Submitted for G4 Approval';
		 opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = accounts[1].id;
		insert opportunities; 
		
		opportunities[0].StageName = 'Create Offer (Bid)';
		opportunities[0].Phase_Status__c = 'Offer in Progress';
		opportunities[0].LOA_Level__c = '';
		opportunities[0].No_Loa__c = false;
		opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
		opportunities[0].G2_Approval_Date__c = Date.Today();
   
		opportunities[0].G3_Planned_Date__c =  Date.Today();
		opportunities[0].Account_Role__c = 'Alliance Partner';
   
		opportunities[0].G4_Planned_Date__c =  Date.Today();
   
		update opportunities[0];
		opportunities[0].StageName = Nokia_CPQ_Constants.WINTHECASESTAGE;
		opportunities[0].Phase_Status__c = 'Offer Submitted to Customer (Manual)';
		update opportunities[0];
		
		

		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(Name ='Commercial Price List', Apttus_Config2__Active__c = True);
		insert ApttusTestPriceList;

		
		
		Test.StartTest();
		Offer__c offer1 = new Offer__c(Name = 'Offer1',Opportunity__c = opportunities[0].Id,LoA_Approval_Level__c = GlobalConstants.LOA_Level_A_Plus,LOA_Bypass__c = '',ActiveOffer__c=true);
		insert offer1;
		//Test.StartTest();
		testProposal1 = new Apttus_Proposal__Proposal__c(
			RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Proposal').getRecordTypeId(),
			Apttus_Proposal__Account__c = accounts[0].Id,
			Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
			Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
			NokiaCPQ_Approval_Required_Flag__c=false,
			Apttus_Proposal__Approval_Stage__c=Nokia_CPQ_Constants.QUOTEDRAFT,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
			NokiaCPQ_FN_Maintenance_Type__c='',
			NokiaCPQ_SRS_Level__c='',
			NokiaCPQ_Existing_IONMaint_Contract__c='',
			NokiaCPQ_Needs_Reprice__c = false,
			Reprice_In_Progress__c = false,
			NokiaCPQ_Existing_FN_Maint_Contract__c='',
			NokiaCPQ_No_of_Years__c = '',
			NokiaCPQ_ION_Maintenance_Type__c='',
			NokiaCPQ_SSP_Level__c='',
			NokiaCPQ_Portfolio__c = 'Optics',
			NokiaCPQ_Maintenance_Type__c =''
		 
		 ); 
		insert testProposal1;
		Contact con = new Contact(firstname = 'kamlesh', lastname = 'jobseeker', accountId = accounts[0].Id);
		insert con;
		Id profileId = [SELECT Id FROM profile WHERE name ='PRM Partner Community User Login' limit 1].Id;
		
		
		
		
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		NokiaCPQ_QuoteHeaderNotesController puc = new  NokiaCPQ_QuoteHeaderNotesController(new ApexPages.StandardController(testProposal1));
		portalUser = new User( email='test.fdsfves4@gmail.com',
	profileid = profileId, 
	//UserRoleId = roleId,
	UserName='Test.partnerfsds@gmail.com', 
	Alias = 'GDS',
	TimeZoneSidKey='America/New_York',
	EmailEncodingKey='ISO-8859-1',
	LocaleSidKey='en_US', 
	LanguageLocaleKey='en_US',
	ContactId = con.Id,
	PortalRole = 'Manager',
	FirstName = 'Test',
	LastName = 'partner2323');
	
		insert portalUser;
		PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Nokia_CPQ_Partner_User'];
		insert new PermissionSetAssignment(AssigneeId = portalUser.id, PermissionSetId = ps.Id);
		
		
		}

		System.runAs(portalUser){
		
		
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		NokiaCPQ_QuoteHeaderNotesController puc = new  NokiaCPQ_QuoteHeaderNotesController(new ApexPages.StandardController(testProposal1));
		System.debug('[+] '+puc.warning);
		
		
		}

		Test.StopTest();
		
	}




	@isTest static void TestNA9(){

	
		
		List<User> sysAdminUser = new List<User>();
		User u = NOKIA_CPQ_TestDataFactory.createSystemAdminUser();
		sysAdminUser.add(u);
		User portalUser ;
		Apttus_Proposal__Proposal__c testProposal1;

		System.runAs(sysAdminUser[0]){
		

		Account_Market__c setting = new Account_Market__c();
		setting.Name = 'Market Greater China';
		
		insert setting;
		List<Apttus_Proposal__Proposal__c> proposals=new List<Apttus_Proposal__Proposal__c>();
		List <Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		accounts[0].Partner_Type__c = '';
		accounts[0].Partner_Program__c = 'GPP 3.0';
		accounts[0].Market__c = 'Market Greater China';
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].AccountNumber='';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;

		Accreditation__c accreditation1 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_PRODUCT,
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Authorized',
	Partner__c=accounts[0].Id,
	Portfolio__c='Optics',
	Pricing_Cluster__c='NAM'	
	);
		Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_MAINTENANCE,
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Authorized',
	Partner__c=accounts[0].Id,
	Portfolio__c='Optics',
	Pricing_Cluster__c='NAM'	
	);
	
		insert accreditation1;
		insert accreditation2;

		 //create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].Lead_BG__c = 'MN';
		opportunities[0].StageName = 'Create Offer (Bid)';
		
		opportunities[0].AccountID = accounts[0].id;
		opportunities[0].Phase_Status__c = 'Submitted for G4 Approval';
		 opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = accounts[1].id;
		insert opportunities; 
		
		opportunities[0].StageName = 'Create Offer (Bid)';
		opportunities[0].Phase_Status__c = 'Offer in Progress';
		opportunities[0].LOA_Level__c = '';
		opportunities[0].No_Loa__c = false;
		opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
		opportunities[0].G2_Approval_Date__c = Date.Today();
   
		opportunities[0].G3_Planned_Date__c =  Date.Today();
		opportunities[0].Account_Role__c = 'Alliance Partner';
   
		opportunities[0].G4_Planned_Date__c =  Date.Today();
   
		update opportunities[0];
		opportunities[0].StageName = Nokia_CPQ_Constants.WINTHECASESTAGE;
		opportunities[0].Phase_Status__c = 'Offer Submitted to Customer (Manual)';
		update opportunities[0];
		
		

		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(Name ='Commercial Price List', Apttus_Config2__Active__c = True);
		insert ApttusTestPriceList;

		
		
		Test.StartTest();
		Offer__c offer1 = new Offer__c(Name = 'Offer1',Opportunity__c = opportunities[0].Id,LoA_Approval_Level__c = '',LOA_Bypass__c = GlobalConstants.LOA_BYPASS,ActiveOffer__c=true);
		insert offer1;
		//Test.StartTest();
		testProposal1 = new Apttus_Proposal__Proposal__c(
			RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Proposal').getRecordTypeId(),
			Apttus_Proposal__Account__c = accounts[0].Id,
			Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
			Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
			NokiaCPQ_Approval_Required_Flag__c=false,
			Apttus_Proposal__Approval_Stage__c=Nokia_CPQ_Constants.QUOTEDRAFT,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
			NokiaCPQ_FN_Maintenance_Type__c='',
			NokiaCPQ_SRS_Level__c='',
			NokiaCPQ_Existing_IONMaint_Contract__c='',
			NokiaCPQ_Needs_Reprice__c = false,
			Reprice_In_Progress__c = false,
			NokiaCPQ_Existing_FN_Maint_Contract__c='',
			NokiaCPQ_No_of_Years__c = '',
			NokiaCPQ_ION_Maintenance_Type__c='',
			NokiaCPQ_SSP_Level__c='',
			NokiaCPQ_Portfolio__c = 'Optics',
			NokiaCPQ_Maintenance_Type__c =''
		 
		 ); 
		insert testProposal1;
		Contact con = new Contact(firstname = 'kamlesh', lastname = 'jobseeker', accountId = accounts[0].Id);
		insert con;
		Id profileId = [SELECT Id FROM profile WHERE name ='PRM Partner Community User Login' limit 1].Id;
		
		
		
		
		
		
		
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		NokiaCPQ_QuoteHeaderNotesController puc = new  NokiaCPQ_QuoteHeaderNotesController(new ApexPages.StandardController(testProposal1));
		portalUser = new User( email='test.fdsfves4@gmail.com',
	profileid = profileId, 
	//UserRoleId = roleId,
	UserName='Test.partnerfsds@gmail.com', 
	Alias = 'GDS',
	TimeZoneSidKey='America/New_York',
	EmailEncodingKey='ISO-8859-1',
	LocaleSidKey='en_US', 
	LanguageLocaleKey='en_US',
	ContactId = con.Id,
	PortalRole = 'Manager',
	FirstName = 'Test',
	LastName = 'partner2323');
	
		insert portalUser;
		PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Nokia_CPQ_Partner_User'];
		insert new PermissionSetAssignment(AssigneeId = portalUser.id, PermissionSetId = ps.Id);
		
		
		}

		System.runAs(portalUser){
		
		
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		NokiaCPQ_QuoteHeaderNotesController puc = new  NokiaCPQ_QuoteHeaderNotesController(new ApexPages.StandardController(testProposal1));
		System.debug('[+] '+puc.warning);
		
		
		}

		Test.StopTest();
		
	}



	/*
	@isTest static void TestNA10(){

	
		
		List<User> sysAdminUser = NOKIA_CPQ_TestDataFactory.userCreation(1,'System Administrator');
		insert sysAdminUser;
		

		
		List<Apttus_Proposal__Proposal__c> proposals=new List<Apttus_Proposal__Proposal__c>();
		List <Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		accounts[0].Partner_Type__c = '';
		accounts[0].Partner_Program__c = 'GPP 3.0';
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].AccountNumber='';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;

		Accreditation__c accreditation1 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_PRODUCT,
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Authorized',
	Partner__c=accounts[0].Id,
	Portfolio__c='Optics',
	Pricing_Cluster__c='NAM'	
	);
		Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_MAINTENANCE,
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Authorized',
	Partner__c=accounts[0].Id,
	Portfolio__c='Optics',
	Pricing_Cluster__c='NAM'	
	);
	
		insert accreditation1;
		insert accreditation2;

		 //create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].StageName = 'Create Offer (Bid)';
		
		opportunities[0].AccountID = accounts[0].id;
		opportunities[0].Phase_Status__c = 'Submitted for G4 Approval';
		 opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = accounts[1].id;
		insert opportunities; 
		
		opportunities[0].StageName = 'Create Offer (Bid)';
		opportunities[0].Phase_Status__c = 'Offer in Progress';
		opportunities[0].StageName='Create Offer (Bid)';
		opportunities[0].LOA_Level__c = '';
		opportunities[0].No_Loa__c = false;
		opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
		opportunities[0].G2_Approval_Date__c = Date.Today();
   
		opportunities[0].G3_Planned_Date__c =  Date.Today();
		opportunities[0].Account_Role__c = 'Alliance Partner';
   
		opportunities[0].G4_Planned_Date__c =  Date.Today();
   
		update opportunities[0];
		opportunities[0].StageName = Nokia_CPQ_Constants.WINTHECASESTAGE;
		update opportunities[0];
		List<OpportunityTeamMember> opportunityTeamMemberList = new List<OpportunityTeamMember>();
		opportunityTeamMemberList = TestDataFactory.optyTeamMemberCreation(2, sysAdminUser[0],opportunities[0]);
		opportunityTeamMemberList[0].TeamMemberRole = 'Pricing Manager';
		opportunityTeamMemberList[1].TeamMemberRole  = 'Pricing Manager';
		insert opportunityTeamMemberList;
		

		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(Name ='Commercial Price List', Apttus_Config2__Active__c = True);
		insert ApttusTestPriceList;

		
		
		
		Offer__c offer1 = new Offer__c(Name = 'Offer1',Expected_LoA_G4_Approval_Level__c=Nokia_CPQ_Constants.LOABYPASS,Opportunity__c = opportunities[0].Id,LoA_Approval_Level__c = '',LOA_Bypass__c = GlobalConstants.PICKLIST_VALUE_AUTHORIZED_FOR_PRICING_MANAGER,ActiveOffer__c=true);
		insert offer1;
		Test.StartTest();
		Apttus_Proposal__Proposal__c testProposal1 = new Apttus_Proposal__Proposal__c(
			RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Proposal').getRecordTypeId(),
			Apttus_Proposal__Account__c = accounts[0].Id,
			Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
			Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
			NokiaCPQ_Approval_Required_Flag__c=false,
			Apttus_Proposal__Approval_Stage__c=Nokia_CPQ_Constants.QUOTEDRAFT,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
			NokiaCPQ_FN_Maintenance_Type__c='',
			NokiaCPQ_SRS_Level__c='',
			NokiaCPQ_Existing_IONMaint_Contract__c='',
			NokiaCPQ_Needs_Reprice__c = false,
			Reprice_In_Progress__c = false,
			NokiaCPQ_Existing_FN_Maint_Contract__c='',
			NokiaCPQ_No_of_Years__c = '',
			NokiaCPQ_ION_Maintenance_Type__c='',
			NokiaCPQ_SSP_Level__c='',
			NokiaCPQ_Portfolio__c = 'Optics',
			NokiaCPQ_Maintenance_Type__c =''
		 
		 ); 
		insert testProposal1;
		Contact con = new Contact(firstname = 'kamlesh', lastname = 'jobseeker', accountId = accounts[0].Id);
		insert con;
		Id profileId = [SELECT Id FROM profile WHERE name ='PRM Partner Community User Login' limit 1].Id;
		Id roleId = [SELECT Id,PortalType FROM userrole WHERE PortalType='Partner' AND PortalRole = 'Manager' LIMIT 1].Id;
		
		
		sysAdminUser[0].UserRoleId = roleId;
		System.runAs(sysAdminUser[0]){
		
		
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		NokiaCPQ_QuoteHeaderNotesController puc = new  NokiaCPQ_QuoteHeaderNotesController(new ApexPages.StandardController(testProposal1));
		portalUser = new User( email='test.fdsfves4@gmail.com',
	profileid = profileId, 
	UserRoleId = roleId,
	UserName='Test.partnerfsds@gmail.com', 
	Alias = 'GDS',
	TimeZoneSidKey='America/New_York',
	EmailEncodingKey='ISO-8859-1',
	LocaleSidKey='en_US', 
	LanguageLocaleKey='en_US',
	ContactId = con.Id,
	PortalRole = 'Manager',
	FirstName = 'Test',
	LastName = 'partner2323');
	
		insert portalUser;
		PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Nokia_CPQ_Partner_User'];
		insert new PermissionSetAssignment(AssigneeId = portalUser.id, PermissionSetId = ps.Id);
		
		
		}

		System.runAs(portalUser){
		
		
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		NokiaCPQ_QuoteHeaderNotesController puc = new  NokiaCPQ_QuoteHeaderNotesController(new ApexPages.StandardController(testProposal1));
		System.debug('[+] '+puc.warning);
		
		
		}

		Test.StopTest();
		
	}*/




	@isTest static void TestAR7(){

	
		
		List<User> sysAdminUser = new List<User>();
		User u = NOKIA_CPQ_TestDataFactory.createSystemAdminUser();
		sysAdminUser.add(u);
		User portalUser ;
		Apttus_Proposal__Proposal__c testProposal1;

		System.runAs(sysAdminUser[0]){
		

		
		List<Apttus_Proposal__Proposal__c> proposals=new List<Apttus_Proposal__Proposal__c>();
		List <Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		accounts[0].Partner_Type__c = '';
		accounts[0].Partner_Program__c = 'GPP 3.0';
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].AccountNumber='';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;

		Accreditation__c accreditation1 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_PRODUCT,
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Authorized',
	Partner__c=accounts[0].Id,
	Portfolio__c='Optics',
	Pricing_Cluster__c='NAM'	
	);
		Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_MAINTENANCE,
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Authorized',
	Partner__c=accounts[0].Id,
	Portfolio__c='Optics',
	Pricing_Cluster__c='NAM'	
	);
	
		insert accreditation1;
		insert accreditation2;

		 //create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].StageName = 'Create Offer (Bid)';
		
		opportunities[0].AccountID = accounts[0].id;
		opportunities[0].Phase_Status__c = 'Submitted for G4 Approval';
		 opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = accounts[1].id;
		insert opportunities; 
		
		opportunities[0].StageName = 'Create Offer (Bid)';
		opportunities[0].Phase_Status__c = 'Offer in Progress';
		opportunities[0].LOA_Level__c = '';
		opportunities[0].No_Loa__c = false;
		opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
		opportunities[0].G2_Approval_Date__c = Date.Today();
   
		opportunities[0].G3_Planned_Date__c =  Date.Today();
		opportunities[0].Account_Role__c = 'Alliance Partner';
   
		opportunities[0].G4_Planned_Date__c =  Date.Today();
   
		update opportunities[0];
		opportunities[0].StageName = Nokia_CPQ_Constants.WINTHECASESTAGE;
		opportunities[0].Phase_Status__c = 'Offer Submitted to Customer (Manual)';
		update opportunities[0];
		
		

		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(Name ='Commercial Price List', Apttus_Config2__Active__c = True);
		insert ApttusTestPriceList;

		
		
		Test.StartTest();
		Offer__c offer1 = new Offer__c(Name = 'Offer1',Opportunity__c = opportunities[0].Id,LoA_Approval_Level__c = '',LOA_Bypass__c = GlobalConstants.NO_LOA,ActiveOffer__c=true);
		insert offer1;
		//Test.StartTest();
		testProposal1 = new Apttus_Proposal__Proposal__c(
			RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Proposal').getRecordTypeId(),
			Apttus_Proposal__Account__c = accounts[0].Id,
			Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
			Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
			NokiaCPQ_Approval_Required_Flag__c=false,
			Apttus_Proposal__Approval_Stage__c=Nokia_CPQ_Constants.QUOTEDRAFT,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
			NokiaCPQ_FN_Maintenance_Type__c='',
			NokiaCPQ_SRS_Level__c='',
			NokiaCPQ_Existing_IONMaint_Contract__c='',
			NokiaCPQ_Needs_Reprice__c = false,
			Reprice_In_Progress__c = false,
			NokiaCPQ_Existing_FN_Maint_Contract__c='',
			NokiaCPQ_No_of_Years__c = '',
			NokiaCPQ_ION_Maintenance_Type__c='',
			NokiaCPQ_SSP_Level__c='',
			NokiaCPQ_Portfolio__c = 'Optics',
			NokiaCPQ_Maintenance_Type__c =''
		 
		 ); 
		insert testProposal1;
		Contact con = new Contact(firstname = 'kamlesh', lastname = 'jobseeker', accountId = accounts[0].Id);
		insert con;
		Id profileId = [SELECT Id FROM profile WHERE name ='PRM Partner Community User Login' limit 1].Id;
		
		
		
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		NokiaCPQ_QuoteHeaderNotesController puc = new  NokiaCPQ_QuoteHeaderNotesController(new ApexPages.StandardController(testProposal1));
		portalUser = new User( email='test.fdsfves4@gmail.com',
	profileid = profileId, 
	//UserRoleId = roleId,
	UserName='Test.partnerfsds@gmail.com', 
	Alias = 'GDS',
	TimeZoneSidKey='America/New_York',
	EmailEncodingKey='ISO-8859-1',
	LocaleSidKey='en_US', 
	LanguageLocaleKey='en_US',
	ContactId = con.Id,
	PortalRole = 'Manager',
	FirstName = 'Test',
	LastName = 'partner2323');
	
		insert portalUser;
		PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Nokia_CPQ_Partner_User'];
		insert new PermissionSetAssignment(AssigneeId = portalUser.id, PermissionSetId = ps.Id);
		
		
		}

		System.runAs(portalUser){
		
		
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		NokiaCPQ_QuoteHeaderNotesController puc = new  NokiaCPQ_QuoteHeaderNotesController(new ApexPages.StandardController(testProposal1));
		System.debug('[+] '+puc.warning);
		
		
		}

		Test.StopTest();
		
	}



	/*
	@isTest static void TestAR8(){

	
		
		List<User> sysAdminUser = new List<User>();
		User u = NOKIA_CPQ_TestDataFactory.createSystemAdminUser();
		sysAdminUser.add(u);
		User portalUser ;
		Apttus_Proposal__Proposal__c testProposal1;

		System.runAs(sysAdminUser[0]){
		

		
		List<Apttus_Proposal__Proposal__c> proposals=new List<Apttus_Proposal__Proposal__c>();
		List <Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		accounts[0].Partner_Type__c = '';
		accounts[0].Partner_Program__c = 'GPP 3.0';
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].AccountNumber='';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;

		Accreditation__c accreditation1 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_PRODUCT,
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Authorized',
	Partner__c=accounts[0].Id,
	Portfolio__c='Optics',
	Pricing_Cluster__c='NAM'	
	);
		Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_MAINTENANCE,
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Authorized',
	Partner__c=accounts[0].Id,
	Portfolio__c='Optics',
	Pricing_Cluster__c='NAM'	
	);
	
		insert accreditation1;
		insert accreditation2;

		 //create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].StageName = 'Create Offer (Bid)';
		
		opportunities[0].AccountID = accounts[0].id;
		opportunities[0].Phase_Status__c = 'Submitted for G4 Approval';
		 opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = accounts[1].id;
		insert opportunities; 
		
		opportunities[0].StageName = 'Create Offer (Bid)';
		opportunities[0].Phase_Status__c = 'Offer in Progress';
		opportunities[0].LOA_Level__c = '';
		opportunities[0].No_Loa__c = false;
		opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
		opportunities[0].G2_Approval_Date__c = Date.Today();
   
		opportunities[0].G3_Planned_Date__c =  Date.Today();
		opportunities[0].Account_Role__c = 'Alliance Partner';
   
		opportunities[0].G4_Planned_Date__c =  Date.Today();
   
		update opportunities[0];
		opportunities[0].StageName = Nokia_CPQ_Constants.WINTHECASESTAGE;
		opportunities[0].Phase_Status__c = 'Offer Submitted to Customer (Manual)';
		update opportunities[0];
		

		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(Name ='Commercial Price List', Apttus_Config2__Active__c = True);
		insert ApttusTestPriceList;

		
		
		Test.StartTest();
		Offer__c offer1 = new Offer__c(Name = 'Offer1',Expected_LoA_G4_Approval_Level__c=Nokia_CPQ_Constants.LOABYPASS,Opportunity__c = opportunities[0].Id,LoA_Approval_Level__c = GlobalConstants.LOA_Level_A_Plus,LOA_Bypass__c = '',ActiveOffer__c=true);
		insert offer1;
		//Test.StartTest();
		testProposal1 = new Apttus_Proposal__Proposal__c(
			RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Proposal').getRecordTypeId(),
			Apttus_Proposal__Account__c = accounts[0].Id,
			Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
			Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
			NokiaCPQ_Approval_Required_Flag__c=false,
			Apttus_Proposal__Approval_Stage__c=Nokia_CPQ_Constants.QUOTEDRAFT,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
			NokiaCPQ_FN_Maintenance_Type__c='',
			NokiaCPQ_SRS_Level__c='',
			NokiaCPQ_Existing_IONMaint_Contract__c='',
			NokiaCPQ_Needs_Reprice__c = false,
			Reprice_In_Progress__c = false,
			NokiaCPQ_Existing_FN_Maint_Contract__c='',
			NokiaCPQ_No_of_Years__c = '',
			NokiaCPQ_ION_Maintenance_Type__c='',
			NokiaCPQ_SSP_Level__c='',
			NokiaCPQ_Portfolio__c = 'Optics',
			NokiaCPQ_Maintenance_Type__c =''
		 
		 ); 
		insert testProposal1;
		Contact con = new Contact(firstname = 'kamlesh', lastname = 'jobseeker', accountId = accounts[0].Id);
		insert con;
		Id profileId = [SELECT Id FROM profile WHERE name ='PRM Partner Community User Login' limit 1].Id;
		
		
		
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		NokiaCPQ_QuoteHeaderNotesController puc = new  NokiaCPQ_QuoteHeaderNotesController(new ApexPages.StandardController(testProposal1));
		portalUser = new User( email='test.fdsfves4@gmail.com',
	profileid = profileId, 
	//UserRoleId = roleId,
	UserName='Test.partnerfsds@gmail.com', 
	Alias = 'GDS',
	TimeZoneSidKey='America/New_York',
	EmailEncodingKey='ISO-8859-1',
	LocaleSidKey='en_US', 
	LanguageLocaleKey='en_US',
	ContactId = con.Id,
	PortalRole = 'Manager',
	FirstName = 'Test',
	LastName = 'partner2323');
	
		insert portalUser;
		PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Nokia_CPQ_Partner_User'];
		insert new PermissionSetAssignment(AssigneeId = portalUser.id, PermissionSetId = ps.Id);
		
		
		}

		System.runAs(portalUser){
		
		
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		NokiaCPQ_QuoteHeaderNotesController puc = new  NokiaCPQ_QuoteHeaderNotesController(new ApexPages.StandardController(testProposal1));
		System.debug('[+] '+puc.warning);
		
		
		}

		Test.StopTest();
		
	}
	*/

	@isTest static void TestNullOffer(){

	
		
		List<User> sysAdminUser = new List<User>();
		User u = NOKIA_CPQ_TestDataFactory.createSystemAdminUser();
		sysAdminUser.add(u);
		User portalUser ;
		Apttus_Proposal__Proposal__c testProposal1;

		System.runAs(sysAdminUser[0]){
		

		
		List<Apttus_Proposal__Proposal__c> proposals=new List<Apttus_Proposal__Proposal__c>();
		List <Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		accounts[0].Partner_Type__c = '';
		accounts[0].Partner_Program__c = 'GPP 3.0';
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].AccountNumber='';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;

		Accreditation__c accreditation1 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_PRODUCT,
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Authorized',
	Partner__c=accounts[0].Id,
	Portfolio__c='Optics',
	Pricing_Cluster__c='NAM'	
	);
		Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c=Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_MAINTENANCE,
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Authorized',
	Partner__c=accounts[0].Id,
	Portfolio__c='Optics',
	Pricing_Cluster__c='NAM'	
	);
	
		insert accreditation1;
		insert accreditation2;

		 //create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].StageName = 'Create Offer (Bid)';
		
		opportunities[0].AccountID = accounts[0].id;
		opportunities[0].Phase_Status__c = 'Submitted for G4 Approval';
		 opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = accounts[1].id;
		insert opportunities; 
		
		opportunities[0].StageName = 'Create Offer (Bid)';
		opportunities[0].LOA_Level__c = '';
		opportunities[0].No_Loa__c = false;
		opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
		opportunities[0].G2_Approval_Date__c = Date.Today();
   
		opportunities[0].G3_Planned_Date__c =  Date.Today();
		opportunities[0].Account_Role__c = 'Alliance Partner';
   
		opportunities[0].G4_Planned_Date__c =  Date.Today();
   
		update opportunities[0];
		opportunities[0].StageName = Nokia_CPQ_Constants.WINTHECASESTAGE;
		update opportunities[0];
		

		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(Name ='Commercial Price List', Apttus_Config2__Active__c = True);
		insert ApttusTestPriceList;

		
		
		
		Test.StartTest();
		testProposal1 = new Apttus_Proposal__Proposal__c(
			RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Proposal').getRecordTypeId(),
			Apttus_Proposal__Account__c = accounts[0].Id,
			Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
			Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
			NokiaCPQ_Approval_Required_Flag__c=false,
			Apttus_Proposal__Approval_Stage__c=Nokia_CPQ_Constants.QUOTEDRAFT,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
			NokiaCPQ_FN_Maintenance_Type__c='',
			NokiaCPQ_SRS_Level__c='',
			NokiaCPQ_Existing_IONMaint_Contract__c='',
			NokiaCPQ_Needs_Reprice__c = false,
			Reprice_In_Progress__c = false,
			NokiaCPQ_Existing_FN_Maint_Contract__c='',
			NokiaCPQ_No_of_Years__c = '',
			NokiaCPQ_ION_Maintenance_Type__c='',
			NokiaCPQ_SSP_Level__c='',
			NokiaCPQ_Portfolio__c = 'Optics',
			NokiaCPQ_Maintenance_Type__c =''
		 
		 ); 
		insert testProposal1;
		Contact con = new Contact(firstname = 'kamlesh', lastname = 'jobseeker', accountId = accounts[0].Id);
		insert con;
		Id profileId = [SELECT Id FROM profile WHERE name ='PRM Partner Community User Login' limit 1].Id;
		
		
		
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		NokiaCPQ_QuoteHeaderNotesController puc = new  NokiaCPQ_QuoteHeaderNotesController(new ApexPages.StandardController(testProposal1));
		portalUser = new User( email='test.fdsfves4@gmail.com',
	profileid = profileId, 
	//UserRoleId = roleId,
	UserName='Test.partnerfsds@gmail.com', 
	Alias = 'GDS',
	TimeZoneSidKey='America/New_York',
	EmailEncodingKey='ISO-8859-1',
	LocaleSidKey='en_US', 
	LanguageLocaleKey='en_US',
	ContactId = con.Id,
	PortalRole = 'Manager',
	FirstName = 'Test',
	LastName = 'partner2323');
	
		insert portalUser;
		PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Nokia_CPQ_Partner_User'];
		insert new PermissionSetAssignment(AssigneeId = portalUser.id, PermissionSetId = ps.Id);
		
		
		}

		System.runAs(portalUser){
		
		
		ApexPages.currentPage().getParameters().put('id',testProposal1.id);
		NokiaCPQ_QuoteHeaderNotesController puc = new  NokiaCPQ_QuoteHeaderNotesController(new ApexPages.StandardController(testProposal1));
		System.debug('[+] '+puc.warning);
		
		
		}

		Test.StopTest();
		
	}

}