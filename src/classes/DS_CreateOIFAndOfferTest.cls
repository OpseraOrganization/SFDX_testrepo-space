@isTest 
public class DS_CreateOIFAndOfferTest {
	  
	private static Id oppDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
	
	 /******************************
	*Method Name: createOIFandOfferTest
	*Description: Test Method to cover OpportunityTriggerHelper class
	********************************/
	public testmethod static void createOIFandOfferTest(){
		system.debug('*****createOIFandOfferTest entry*** ');
		Set<Id> accId = new Set<Id>();
		
			Map<Id,Opportunity> upsellProposalToOppty = new Map<Id,Opportunity>();
			//user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
			//insert userCreation;
			
			Id swxRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByDeveloperName().get(GlobalConstants.SWX_UPSELL_PROPOSAL_RECORD_TYPE).getRecordTypeId();
			Id ccreRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByDeveloperName().get(GlobalConstants.CCRE_UPSELL_PROPOSAL_RECORD_TYPE).getRecordTypeId();
			
			List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
			insert users;
			system.debug('*****user inserted*** ');
			
			system.debug('*****1*** ');
			
			//Order_Intake_Forecast__c
	 
			system.runAs(users[0]){
			// Test.startTest();
			
			
			List<Account> accountCreation = TestDataFactory.createAccount(2);
			accountCreation[0].AccountNumber = '3011234';
			accountCreation[1].AccountNumber = '3011235';
			database.insert(accountCreation);
			System.Debug('accountCreation---> '+accountCreation);
			system.debug('*****2*** ');
			accId.add(accountCreation[0].Id);
			accId.add(accountCreation[1].Id);
			
			Product2 prod1 = new product2(
			Name = 'Test1', 
			ProductCode = '123',
			CurrencyIsoCode = 'USD',
			Portfolio__c = 'Airscale Wifi',
			IsActive = true,
			Apttus_Config2__ConfigurationType__c = 'Bundle',
			NokiaCPQ_Item_Type__c='Software',
			RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Business_Line').getRecordTypeId(),
			NokiaCPQ_Classification2__c='Base'   
			);
			
			insert prod1;
			system.debug('*****3*** ');

			system.debug('prod1---> '+prod1);	 
			
			Test.startTest();
			system.debug('*****4*** ');
			List <SWx_Upsell_Proposal__c> upsellProposalList = TestDataFactory.upsellList(3,accountCreation[0]);
			upsellProposalList[0].Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource;
			upsellProposalList[0].RecordTypeId= swxRecordTypeId;
			upsellProposalList[0].Proposal_Recommendation_Type__c = CSWXGlobalConstant.SW_Recommendation;
			upsellProposalList[0].Account_ID__c = accountCreation[0].id;
			upsellProposalList[0].Business_Line__c =prod1.Id;
			upsellProposalList[0].Sold_To_Party__c = accountCreation[0].id;
			upsellProposalList[1].Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource;
			upsellProposalList[1].RecordTypeId= swxRecordTypeId;
			upsellProposalList[1].Proposal_Recommendation_Type__c = CSWXGlobalConstant.HW_Recommendation;
			upsellProposalList[1].Account_ID__c = accountCreation[1].id;
			upsellProposalList[1].Sold_To_Party__c =accountCreation[1].id;
			upsellProposalList[2].Analytics_Source__c = 'CXM';
			upsellProposalList[2].RecordTypeId= swxRecordTypeId; //ccreRecordTypeId;
			upsellProposalList[2].Account_ID__c = accountCreation[1].id;
			
			upsellProposalList[2].Proposal_Recommendation_Type__c = CSWXGlobalConstant.HW_Recommendation;
			upsellProposalList[2].Sold_To_Party__c =accountCreation[1].id;
	
			database.insert(upsellProposalList);
			system.debug('*****5*** ');
			system.debug('Business_Line__c]---> '+upsellProposalList);
			system.debug('Business_Line__c]--76->'+upsellProposalList[0].Business_Line__c);
			
			System.assertEquals(accountCreation[0].id, upsellProposalList[0].Account_ID__c);
			System.assertEquals(accountCreation[1].id, upsellProposalList[1].Account_ID__c);
			System.assertEquals(accountCreation[1].id, upsellProposalList[2].Account_ID__c);	
			System.assertEquals( upsellProposalList[0].Analytics_Source__c, CSWXGlobalConstant.AnalyticsSource);
			System.assertEquals( upsellProposalList[1].Analytics_Source__c, CSWXGlobalConstant.AnalyticsSource);
			
			system.debug('*****6*** ');
			//system.debug('Business_Line__c]--84->'+upsellProposalList[0].Business_Line__c);
			
			List<Opportunity> oppty ;
			//oppty = TestDataFactory.OpportunityCreation(1,accountCreation[0])[0];
			oppty = TestDataFactory.OpportunityCreation(1,accountCreation[0]);
			oppty[0].StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
			oppty[0].RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
			oppty[0].SWx_Upsell_Proposal__c =upsellProposalList[0].Id;
			oppty[0].Lead_BG__c ='MN';
			//oppty[0].SWx_Upsell_Proposal__r.Business_Line__c = upsellProposalList[0].Business_Line__c;
			oppty[0].Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
			
			
			
			//BusinessLine__c aaqqqaaqqq
			//SWx_Upsell_Proposal__c aqaazzzaqqqaaaaaaaaaaaa
			
			//Apttus_Approval.ApprovalsWebService.previewApprovals
			system.debug('*****7*** ');
			database.insert(oppty);
			//system.debug('oppty--->'+oppty[0].SWx_Upsell_Proposal__c);
			system.debug('*****8*** ');
			
			List<Opportunity> optyCreation = TestDataFactory.OpportunityCreation(2,accountCreation[0]);
			optyCreation[0].SWx_Upsell_Proposal__c = upsellProposalList[0].Id;
			optyCreation[0].Apttus_Approval__Approval_Status__c = CSWXGlobalConstant.Approval_stage_approved;
			optyCreation[0].ApprovalStatusTechField__c = CSWXGlobalConstant.Approved_G2;
			optyCreation[0].Approvals_Current_Status__c = CSWXGlobalConstant.Approved_G2;
			optyCreation[0].G2_Approval_Date__c = System.now();
			optyCreation[0].G3_Approval_Date__c = System.now();
			optyCreation[0].RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
			optyCreation[0].StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation[0].Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
			optyCreation[0].Reference_Opportunity__c= oppty[0].id;
			
			system.debug('*****9*** ');
			database.insert(optyCreation);
			system.debug('*****10*** ');
			Apttus_Approval__Approval_Request__c approvalData = new Apttus_Approval__Approval_Request__c();
			approvalData.Apttus_Approval__Related_Opportunity__c = optyCreation[0].id;   
			database.insert(approvalData);
			
			system.debug('*****11*** ');
			system.debug('optyCreation[0]--->'+optyCreation[0]);
			system.debug('oppty-SWx_Upsell_Proposal__c--> '+oppty[0].SWx_Upsell_Proposal__c);
			system.debug('oppty---> '+oppty);
			system.debug('optyCreation[0].SWx_Upsell_Proposal__c]--->'+optyCreation[0].SWx_Upsell_Proposal__c);
			system.debug('optyCreation[0].RecordType.DeveloperName--->'+optyCreation[0].RecordType.DeveloperName);
			system.debug('optyCreation[0].StageName--->'+optyCreation[0].StageName);
			
			system.debug('*****12*** ');
			optyCreation[0].SWx_Upsell_Proposal__c = upsellProposalList[2].Id;
			database.update(optyCreation);
			System.enqueueJob( new DS_CreateOIFAndOffer(optyCreation) );

			Test.stopTest();
			} 
	}
	public testmethod static void createOIFandOfferTest1(){
		system.debug('*****createOIFandOfferTest entry*** ');
		Set<Id> accId = new Set<Id>();
		
			Map<Id,Opportunity> upsellProposalToOppty = new Map<Id,Opportunity>();
			//user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
			//insert userCreation;
			
			Id swxRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByDeveloperName().get(GlobalConstants.SWX_UPSELL_PROPOSAL_RECORD_TYPE).getRecordTypeId();
			Id ccreRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByDeveloperName().get(GlobalConstants.CCRE_UPSELL_PROPOSAL_RECORD_TYPE).getRecordTypeId();
			
			List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
			insert users;
			system.debug('*****user inserted*** ');
			
			system.debug('*****1*** ');
			
			//Order_Intake_Forecast__c
	 
			system.runAs(users[0]){
			// Test.startTest();
			
			
			List<Account> accountCreation = TestDataFactory.createAccount(2);
			accountCreation[0].AccountNumber = '3011234';
			accountCreation[1].AccountNumber = '3011235';
			database.insert(accountCreation);
			System.Debug('accountCreation---> '+accountCreation);
			system.debug('*****2*** ');
			accId.add(accountCreation[0].Id);
			accId.add(accountCreation[1].Id);
			
			Product2 prod1 = new product2(
			Name = 'Test1', 
			ProductCode = '123',
			CurrencyIsoCode = 'USD',
			Portfolio__c = 'Airscale Wifi',
			IsActive = true,
			Apttus_Config2__ConfigurationType__c = 'Bundle',
			NokiaCPQ_Item_Type__c='Software',
			RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Business_Line').getRecordTypeId(),
			NokiaCPQ_Classification2__c='Base'   
			);
			
			insert prod1;
			system.debug('*****3*** ');

			system.debug('prod1---> '+prod1);	 
			
			Test.startTest();
			system.debug('*****4*** ');
			List <SWx_Upsell_Proposal__c> upsellProposalList = TestDataFactory.upsellList(3,accountCreation[0]);
			upsellProposalList[0].Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource;
			upsellProposalList[0].RecordTypeId= swxRecordTypeId;
			upsellProposalList[0].Proposal_Recommendation_Type__c = CSWXGlobalConstant.SW_Recommendation;
			upsellProposalList[0].Account_ID__c = accountCreation[0].id;
			upsellProposalList[0].Business_Line__c =prod1.Id;
			upsellProposalList[0].Sold_To_Party__c = accountCreation[0].id;
			upsellProposalList[1].Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource;
			upsellProposalList[1].RecordTypeId= swxRecordTypeId;
			upsellProposalList[1].Proposal_Recommendation_Type__c = CSWXGlobalConstant.HW_Recommendation;
			upsellProposalList[1].Account_ID__c = accountCreation[1].id;
			upsellProposalList[1].Sold_To_Party__c =accountCreation[1].id;
			upsellProposalList[2].Analytics_Source__c = 'CXM';
			upsellProposalList[2].RecordTypeId= swxRecordTypeId; //ccreRecordTypeId;
			upsellProposalList[2].Account_ID__c = accountCreation[1].id;
			
			upsellProposalList[2].Proposal_Recommendation_Type__c = CSWXGlobalConstant.HW_Recommendation;
			upsellProposalList[2].Sold_To_Party__c =accountCreation[1].id;
	
			database.insert(upsellProposalList);
			system.debug('*****5*** ');
			system.debug('Business_Line__c]---> '+upsellProposalList);
			system.debug('Business_Line__c]--76->'+upsellProposalList[0].Business_Line__c);
			
			System.assertEquals(accountCreation[0].id, upsellProposalList[0].Account_ID__c);
			System.assertEquals(accountCreation[1].id, upsellProposalList[1].Account_ID__c);
			System.assertEquals(accountCreation[1].id, upsellProposalList[2].Account_ID__c);	
			System.assertEquals( upsellProposalList[0].Analytics_Source__c, CSWXGlobalConstant.AnalyticsSource);
			System.assertEquals( upsellProposalList[1].Analytics_Source__c, CSWXGlobalConstant.AnalyticsSource);
			
			system.debug('*****6*** ');
			//system.debug('Business_Line__c]--84->'+upsellProposalList[0].Business_Line__c);
			
			List<Opportunity> oppty ;
			//oppty = TestDataFactory.OpportunityCreation(1,accountCreation[0])[0];
			oppty = TestDataFactory.OpportunityCreation(1,accountCreation[0]);
			oppty[0].StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
			oppty[0].RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
			oppty[0].SWx_Upsell_Proposal__c =null;
			oppty[0].Lead_BG__c ='MN';
			//oppty[0].SWx_Upsell_Proposal__r.Business_Line__c = upsellProposalList[0].Business_Line__c;
			oppty[0].Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
			
			
			
			//BusinessLine__c aaqqqaaqqq
			//SWx_Upsell_Proposal__c aqaazzzaqqqaaaaaaaaaaaa
			
			//Apttus_Approval.ApprovalsWebService.previewApprovals
			system.debug('*****7*** ');
			database.insert(oppty);
			//system.debug('oppty--->'+oppty[0].SWx_Upsell_Proposal__c);
			system.debug('*****8*** ');
			
			List<Opportunity> optyCreation = TestDataFactory.OpportunityCreation(2,accountCreation[0]);
			optyCreation[0].SWx_Upsell_Proposal__c = null;
			optyCreation[0].Apttus_Approval__Approval_Status__c = CSWXGlobalConstant.Approval_stage_approved;
			optyCreation[0].ApprovalStatusTechField__c = CSWXGlobalConstant.Approved_G2;
			optyCreation[0].Approvals_Current_Status__c = CSWXGlobalConstant.Approved_G2;
			optyCreation[0].G2_Approval_Date__c = System.now();
			optyCreation[0].G3_Approval_Date__c = System.now();
			optyCreation[0].RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
			optyCreation[0].StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation[0].Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
			optyCreation[0].Reference_Opportunity__c= oppty[0].id;
			
			system.debug('*****9*** ');
			database.insert(optyCreation);
			system.debug('*****10*** ');
			Apttus_Approval__Approval_Request__c approvalData = new Apttus_Approval__Approval_Request__c();
			approvalData.Apttus_Approval__Related_Opportunity__c = optyCreation[0].id;   
			database.insert(approvalData);
			system.debug('*****11*** ');
			system.debug('optyCreation[0]--->'+optyCreation[0]);
			system.debug('oppty-SWx_Upsell_Proposal__c--> '+oppty[0].SWx_Upsell_Proposal__c);
			system.debug('oppty---> '+oppty);
			system.debug('optyCreation[0].SWx_Upsell_Proposal__c]--->'+optyCreation[0].SWx_Upsell_Proposal__c);
			system.debug('optyCreation[0].RecordType.DeveloperName--->'+optyCreation[0].RecordType.DeveloperName);
			system.debug('optyCreation[0].StageName--->'+optyCreation[0].StageName);
			
			system.debug('*****12*** ');
			optyCreation[0].SWx_Upsell_Proposal__c = null;
			database.update(optyCreation);
			System.enqueueJob( new DS_CreateOIFAndOffer(optyCreation) );

			Test.stopTest();
			} 
	}
	
	public testmethod static void createOIFandOfferTest2(){
		system.debug('*****createOIFandOfferTest entry*** ');
		Set<Id> accId = new Set<Id>();
		
			Map<Id,Opportunity> upsellProposalToOppty = new Map<Id,Opportunity>();
			//user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
			//insert userCreation;
			
			Id swxRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByDeveloperName().get(GlobalConstants.SWX_UPSELL_PROPOSAL_RECORD_TYPE).getRecordTypeId();
			Id ccreRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByDeveloperName().get(GlobalConstants.CCRE_UPSELL_PROPOSAL_RECORD_TYPE).getRecordTypeId();
			
			List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
			insert users;
			system.debug('*****user inserted*** ');
			
			system.debug('*****1*** ');
			
			//Order_Intake_Forecast__c
	 
			system.runAs(users[0]){
			// Test.startTest();
			
			
			List<Account> accountCreation = TestDataFactory.createAccount(2);
			accountCreation[0].AccountNumber = '3011234';
			accountCreation[1].AccountNumber = '3011235';
			database.insert(accountCreation);
			System.Debug('accountCreation---> '+accountCreation);
			system.debug('*****2*** ');
			accId.add(accountCreation[0].Id);
			accId.add(accountCreation[1].Id);
			
			Product2 prod1 = new product2(
			Name = 'Test1', 
			ProductCode = '123',
			CurrencyIsoCode = 'USD',
			Portfolio__c = 'Airscale Wifi',
			IsActive = true,
			Apttus_Config2__ConfigurationType__c = 'Bundle',
			NokiaCPQ_Item_Type__c='Software',
			RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Business_Line').getRecordTypeId(),
			NokiaCPQ_Classification2__c='Base'   
			);
			
			insert prod1;
			system.debug('*****3*** ');

			system.debug('prod1---> '+prod1);	 
			
			Test.startTest();
			system.debug('*****4*** ');
			List <SWx_Upsell_Proposal__c> upsellProposalList = TestDataFactory.upsellList(3,accountCreation[0]);
			upsellProposalList[0].Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource;
			upsellProposalList[0].RecordTypeId= swxRecordTypeId;
			upsellProposalList[0].Proposal_Recommendation_Type__c = CSWXGlobalConstant.SW_Recommendation;
			upsellProposalList[0].Account_ID__c = accountCreation[0].id;
			upsellProposalList[0].Business_Line__c =prod1.Id;
			upsellProposalList[0].Sold_To_Party__c = accountCreation[0].id;
			upsellProposalList[1].Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource;
			upsellProposalList[1].RecordTypeId= swxRecordTypeId;
			upsellProposalList[1].Proposal_Recommendation_Type__c = CSWXGlobalConstant.SW_Recommendation;
			upsellProposalList[1].Account_ID__c = accountCreation[1].id;
			upsellProposalList[1].Sold_To_Party__c =accountCreation[1].id;
			upsellProposalList[2].Analytics_Source__c = 'CXM';
			upsellProposalList[2].RecordTypeId= swxRecordTypeId; //ccreRecordTypeId;
			upsellProposalList[2].Account_ID__c = accountCreation[1].id;
			
			upsellProposalList[2].Proposal_Recommendation_Type__c = CSWXGlobalConstant.SW_Recommendation;
			upsellProposalList[2].Sold_To_Party__c =accountCreation[1].id;
	
			database.insert(upsellProposalList);
			system.debug('*****5*** ');
			system.debug('Business_Line__c]---> '+upsellProposalList);
			system.debug('Business_Line__c]--76->'+upsellProposalList[0].Business_Line__c);
			
			System.assertEquals(accountCreation[0].id, upsellProposalList[0].Account_ID__c);
			System.assertEquals(accountCreation[1].id, upsellProposalList[1].Account_ID__c);
			System.assertEquals(accountCreation[1].id, upsellProposalList[2].Account_ID__c);	
			System.assertEquals( upsellProposalList[0].Analytics_Source__c, CSWXGlobalConstant.AnalyticsSource);
			System.assertEquals( upsellProposalList[1].Analytics_Source__c, CSWXGlobalConstant.AnalyticsSource);
			
			system.debug('*****6*** ');
			//system.debug('Business_Line__c]--84->'+upsellProposalList[0].Business_Line__c);
			
			List<Opportunity> oppty ;
			//oppty = TestDataFactory.OpportunityCreation(1,accountCreation[0])[0];
			oppty = TestDataFactory.OpportunityCreation(1,accountCreation[0]);
			oppty[0].StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
			oppty[0].RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
			oppty[0].SWx_Upsell_Proposal__c =upsellProposalList[0].Id;
			oppty[0].Lead_BG__c ='MN';
			//oppty[0].SWx_Upsell_Proposal__r.Business_Line__c = upsellProposalList[0].Business_Line__c;
			oppty[0].Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
			
			
			
			//BusinessLine__c aaqqqaaqqq
			//SWx_Upsell_Proposal__c aqaazzzaqqqaaaaaaaaaaaa
			
			//Apttus_Approval.ApprovalsWebService.previewApprovals
			system.debug('*****7*** ');
			database.insert(oppty);
			//system.debug('oppty--->'+oppty[0].SWx_Upsell_Proposal__c);
			system.debug('*****8*** ');
			
			List<Opportunity> optyCreation = TestDataFactory.OpportunityCreation(2,accountCreation[0]);
			optyCreation[0].SWx_Upsell_Proposal__c = upsellProposalList[0].Id;
			optyCreation[0].Apttus_Approval__Approval_Status__c = CSWXGlobalConstant.Approval_stage_approved;
			optyCreation[0].ApprovalStatusTechField__c = CSWXGlobalConstant.Approved_G2;
			optyCreation[0].Approvals_Current_Status__c = CSWXGlobalConstant.Approved_G2;
			optyCreation[0].G2_Approval_Date__c = System.now();
			optyCreation[0].G3_Approval_Date__c = System.now();
			optyCreation[0].RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
			optyCreation[0].StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation[0].Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
			optyCreation[0].Reference_Opportunity__c= oppty[0].id;
			
			system.debug('*****9*** ');
			database.insert(optyCreation);
			system.debug('*****10*** ');
			Apttus_Approval__Approval_Request__c approvalData = new Apttus_Approval__Approval_Request__c();
			approvalData.Apttus_Approval__Related_Opportunity__c = optyCreation[0].id;   
			database.insert(approvalData);
			system.debug('*****11*** ');
			system.debug('optyCreation[0]--->'+optyCreation[0]);
			system.debug('oppty-SWx_Upsell_Proposal__c--> '+oppty[0].SWx_Upsell_Proposal__c);
			system.debug('oppty---> '+oppty);
			system.debug('optyCreation[0].SWx_Upsell_Proposal__c]--->'+optyCreation[0].SWx_Upsell_Proposal__c);
			system.debug('optyCreation[0].RecordType.DeveloperName--->'+optyCreation[0].RecordType.DeveloperName);
			system.debug('optyCreation[0].StageName--->'+optyCreation[0].StageName);
			
	Apttus_Approval__Approval_Process__c Aprocess=new Apttus_Approval__Approval_Process__c();
			insert Aprocess;
			
			Apttus_Approval__ApprovalProcessInstance__c processinstance=new Apttus_Approval__ApprovalProcessInstance__c(name=CSWXGlobalConstant.G2_Approvals_New,Apttus_Approval__BusinessObjectId__c=optyCreation[0].id, Apttus_Approval__ApprovalProcessId__c=Aprocess.id);
			insert processinstance;
	
			system.debug('*****12*** ');
			optyCreation[0].SWx_Upsell_Proposal__c = upsellProposalList[2].Id;
			database.update(optyCreation);
			System.enqueueJob( new DS_CreateOIFAndOffer(optyCreation) );

			Test.stopTest();
			} 
	}

}