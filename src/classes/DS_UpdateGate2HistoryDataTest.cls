/****************************************
* Name : DS_TabRenderingTest
* Author : Accenture

*****************************************/
@isTest
Private class DS_UpdateGate2HistoryDataTest{
	
	private static Id oppDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
	
	/******************************
*Method Name: executeTest
*Description: Test Method to cover DS_UpdateGate2HstoryData class
********************************/
	static testMethod void executeTest(){
		Set<Id> accId = new Set<Id>();
		Map<Id,Opportunity> upsellProposalToOppty = new Map<Id,Opportunity>();
		User userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		userCreation.FirstName='Danabalan';
		userCreation.LastName='Amirthalingam';
		userCreation.Nokia_ID__c = '8896';
		userCreation.IsActive=true;
		insert userCreation;
		
		User userCreation1 = TestDataFactory.userCreation(1,'System Administrator')[0];
		userCreation1.FirstName='Danabalan1';
		userCreation1.LastName='Amirthalingam1';
		userCreation1.Nokia_ID__c = '8895566';
		userCreation1.IsActive=true;
		insert userCreation1;
		
		system.runAs(userCreation){
			//Test.startTest();
			
			List<Account> accountCreation = TestDataFactory.createAccount(2);
			accountCreation[0].AccountNumber = '3011234';
			accountCreation[0].L7Name__c = 'APJ ANO CT Ooredoo Myanmar';
			accountCreation[1].AccountNumber = '3011235';
			database.insert(accountCreation);
			accId.add(accountCreation[0].Id);
			accId.add(accountCreation[1].Id);
			
			Id swxRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByDeveloperName().get('SWx_Upsell_Proposal').getRecordTypeId();
			Id ccreRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByDeveloperName().get('CCRE_Upsell_Proposal').getRecordTypeId();
			
			List <SWx_Upsell_Proposal__c> upsellProposalList = TestDataFactory.upsellList(3,accountCreation[0]);
			upsellProposalList[0].Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource;
			upsellProposalList[0].RecordTypeId= swxRecordTypeId;
			upsellProposalList[0].Proposal_Recommendation_Type__c = CSWXGlobalConstant.SW_Recommendation;
			upsellProposalList[0].Account_ID__c = accountCreation[0].id;
			upsellProposalList[0].Sold_To_Party__c= accountCreation[0].id;
			upsellProposalList[1].Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource;
			
			upsellProposalList[1].RecordTypeId= swxRecordTypeId;
			
			upsellProposalList[1].Proposal_Recommendation_Type__c = CSWXGlobalConstant.HW_Recommendation;
			upsellProposalList[1].Account_ID__c = accountCreation[1].id;
			upsellProposalList[1].Sold_To_Party__c= accountCreation[1].id;
			upsellProposalList[2].Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource_CCRE;
			upsellProposalList[2].RecordTypeId= ccreRecordTypeId;
			upsellProposalList[2].Account_ID__c = accountCreation[1].id;
			upsellProposalList[2].Sold_To_Party__c= accountCreation[1].id;
			
			database.insert(upsellProposalList);
			System.assertEquals(accountCreation[0].id, upsellProposalList[0].Account_ID__c);
			System.assertEquals(accountCreation[1].id, upsellProposalList[1].Account_ID__c);
			System.assertEquals( upsellProposalList[0].Analytics_Source__c, CSWXGlobalConstant.AnalyticsSource);
			System.assertEquals( upsellProposalList[1].Analytics_Source__c, CSWXGlobalConstant.AnalyticsSource);
			
			List<Opportunity> optyCreation = TestDataFactory.OpportunityCreation(2,accountCreation[0]);
			optyCreation[0].SWx_Upsell_Proposal__c = upsellProposalList[0].Id;
			optyCreation[0].Apttus_Approval__Approval_Status__c = CSWXGlobalConstant.Approval_stage_approved;
			optyCreation[0].ApprovalStatusTechField__c = CSWXGlobalConstant.Approved_G2;
			optyCreation[0].Approvals_Current_Status__c = CSWXGlobalConstant.Approved_G2;
			optyCreation[0].G2_Approval_Date__c = System.now();
			optyCreation[0].G3_Approval_Date__c = System.now();
			
			optyCreation[0].RecordTypeId=oppDirectRecordTypeId;
			
			optyCreation[1].SWx_Upsell_Proposal__c = upsellProposalList[2].Id;
			optyCreation[1].Apttus_Approval__Approval_Status__c = CSWXGlobalConstant.Approval_stage_approved;
			optyCreation[1].ApprovalStatusTechField__c = CSWXGlobalConstant.Approved_G2;
			optyCreation[1].Approvals_Current_Status__c = CSWXGlobalConstant.Approved_G2;
			optyCreation[1].G2_Approval_Date__c = System.now();
			optyCreation[1].G3_Approval_Date__c = System.now();
			
			optyCreation[1].RecordTypeId=oppDirectRecordTypeId;
			database.insert(optyCreation);
			
			Sales_Role__c sales=new Sales_Role__c(); 
			sales.Organisation__c='APJ ANO CT Ooredoo Myanmar';
			sales.Role_Code__c=CSWXGlobalConstant.NSNG_COCT;
			sales.Role_Name__c='Amirthalingam';
			sales.User__c=userCreation.id;
			insert sales;
			
			
			
			Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
			Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
			
			User u = new User(
				Alias = 'testu',
				Email = 'test@nokia.com',
				EmailEncodingKey = 'UTF-8',
				LastName = 'Test',
				LanguageLocaleKey = 'en_US',
				LocaleSidKey = 'en_US',
				TimeZoneSidKey='America/Los_Angeles',
				ProfileId = p.Id,
				UserName='test@nokia.com4567',
				Nokia_ID__c=randomInt +'0',
				NSA_Compliant__c=True
			);
			
			INSERT u;
			
			User u1 = new User(
				Alias = 'testu',
				Email = 'test1@nokia.com',
				EmailEncodingKey = 'UTF-8',
				LastName = 'Test',
				LanguageLocaleKey = 'en_US',
				LocaleSidKey = 'en_US',
				TimeZoneSidKey='America/Los_Angeles',
				ProfileId = p.Id,
				UserName='test1@nokia.com',
				Nokia_ID__c=randomInt +'01',
				NSA_Compliant__c=True
			);
			
			INSERT u1;
			System.debug(u1.id + '@@@@@@@' + u.id);
			
			// Apttus_Approval__ApprovalProcessInstance__c appInstance=[SELECT Id, Name, Apttus_Approval__ApprovalProcessId__c FROM Apttus_Approval__ApprovalProcessInstance__c where Name=:CSWXGlobalConstant.G2_Approvals_New Limit 1 ];
			
			
			Apttus_Approval__Backup_Approver__c objBA = new Apttus_Approval__Backup_Approver__c();
			
			objBA.Apttus_Approval__Current_User__c =UserInfo.getUserId();
			//objBA.Delegate_Approver1__c = u.Id;
			//objBA.Apttus_Approval__Backup_User__c = u1.Id;		
			//objBA.Delegate_Approver2__c = u1.Id;
			objBA.Apttus_Approval__IsActive__c = true;
			objBA.Apttus_Approval__InEffect__c = true;
			objBA.Apttus_Approval__IsDelegate__c = true;
			objBA.Apttus_Approval__DelegateUserIds__c = u.Id + ',' + u1.ID;
			
			
			insert objBA;
			/*
			Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
			app.setObjectId(optyCreation[0].id);
			Approval.ProcessResult result = Approval.process(app);
			
			Apttus_Approval__ApprovalProcessInstance__c appInstance = new Apttus_Approval__ApprovalProcessInstance__c(Name = 'G2 Approvals New', Apttus_Approval__ApprovalProcessId__c =result.instanceid );
			insert appInstance;
			*/
			system.debug('objBA-----@@@@@@'+objBA);
			system.debug('sales-----@@@@@@'+sales);
			system.debug('optyCreation[0]--->'+optyCreation[0]);
			system.debug('optyCreation[0].SWx_Upsell_Proposal__c]--->'+optyCreation[0].SWx_Upsell_Proposal__c);
			system.debug('optyCreation[0].RecordType.DeveloperName--->'+optyCreation[0].RecordType.DeveloperName);
			system.debug('optyCreation[0].StageName--->'+optyCreation[0].StageName);
			/*optyCreation[0].SWx_Upsell_Proposal__c = upsellProposalList[0].Id;
upsellProposalToOppty.put(upsellProposalList[0].Id, optyCreation[0]);
upsellProposalToOppty.put(upsellProposalList[1].Id, optyCreation[0]);
upsellProposalToOppty.put(upsellProposalList[2].Id, optyCreation[0]);
Apttus_Proposal__Proposal__c quoteProposal = TestDataFactory.createProposal(1)[0];
Apttus_Config2__PriceList__c priceList = TestDataFactory.priceList(1)[0];
priceList.Type__c  = CSWXGlobalConstant.AnalyticsSource;
priceList.Apttus_Config2__AccountId__c = accountCreation[0].id;
database.insert(priceList);
*/
			Id oppInDirectRecordTypePartnerId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Sales_Opportunity_For_Partner').getRecordTypeId();
		Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.Indirect_Record_Type).getRecordTypeId();
		
			
			Account accCustomer = TestDataFactory.createAccount(1)[0];
			accCustomer.AccountNumber='100006843';
		   // accCustomer.BusinessPartnerRole__c= GlobalConstants.Alliance; // changed for SH2022: Alliance Deactivated
			accCustomer.BusinessPartnerRole__c = 'Direct Customer'; // changed for SH2022: Alliance Deactivated
			accCustomer.Market__c = 'Market India';
			accCustomer.L7Name__c = 'APJ ANO CT Ooredoo Myanmar'; 
			accCustomer.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
			database.insert(accCustomer);
			
			Account accLegalEntity = TestDataFactory.createAccount(1)[0];
			accLegalEntity.AccountNumber='1000068431';
			accLegalEntity.ParentId=accCustomer.ID;
			accLegalEntity.Default_Legal_Entity__c = True ;
			accLegalEntity.Active__c = true;
			accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
			database.insert(accLegalEntity);
			Test.startTest();
			Opportunity refOppty;
			refOppty = new Opportunity();
			refOppty.Name = 'test-ref oppty';
			refOppty.Lead_BG__c = 'MN';
			//refOppty.Lead_BU__c = 'MN';
			refOppty.AccountId = accCustomer.Id;
			refOppty.Business_Type__c = GlobalConstants.STANDARDOPPORTUNITY;
			refOppty.Unweighted_Amount_EUR__c =0;
			refOppty.Contract_Signing_Entity__c = 'fALU';
			refOppty.G3_Planned_Date__c = System.today();
			refOppty.G4_Planned_Date__c = System.today();
			refOppty.G5_Planned_Date__c = System.today().addMonths(3);
			refOppty.G6_Planned_Date__c = System.today().addMonths(4);
			refOppty.CloseDate = System.today().addMonths(3);
			refOppty.StageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
			refOppty.Phase_Status__c = GlobalConstants.PLANNED;
			refOppty.RecordTypeId = RecordTypeId;
			refOppty.End_Customer_LE__c =accLegalEntity.Id;
			refOppty.Account_Role__c = 'Other PSA';
			database.insert(refOppty);
			
			opportunity opty = new Opportunity();
			opty.Name = 'test';
			opty.Lead_BG__c = 'MN';
			//opty.Lead_BU__c = 'MN';
			opty.AccountId = accCustomer.Id;
			opty.CloseDate = System.today().addMonths(3);
			opty.StageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
			opty.RecordTypeId= oppInDirectRecordTypePartnerId;
			
			database.insert(opty);
			
			Apttus_Approval__Approval_Process__c Aprocess=new Apttus_Approval__Approval_Process__c();
			insert Aprocess;
			
			Apttus_Approval__ApprovalProcessInstance__c processinstance=new Apttus_Approval__ApprovalProcessInstance__c(name=CSWXGlobalConstant.G2_Approvals_New,Apttus_Approval__BusinessObjectId__c=opty.id, Apttus_Approval__ApprovalProcessId__c=Aprocess.id);
			insert processinstance;
			
			DS_UpdateGate2HistoryData job = new DS_UpdateGate2HistoryData(optyCreation,optyCreation[1].Id);
			ID jobID = System.enqueueJob(job);
			
			Test.stopTest();
			
		}
		
	}  
	
	
	
}