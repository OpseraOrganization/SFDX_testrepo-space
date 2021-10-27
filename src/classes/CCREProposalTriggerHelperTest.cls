/*******************************
Class Name: CCREProposalTriggerHelperTest
Created by: Accenture
Created Date: 11 Jan 2018
Last modified by: Accenture
Description: Test class for CCREProposalTriggerHelper
*******************************/
@istest
private with sharing class CCREProposalTriggerHelperTest{
	private static User testUser = NF_TestDataFactory.createAdminUser('System Administrator');
	private static User testUser1 = NF_TestDataFactory.createAdminUser('System Administrator');
	private static User testUser2 = NF_TestDataFactory.createAdminUser('System Administrator');
	private static User testUser3 = NF_TestDataFactory.createAdminUser('System Administrator');
	private static User testUser4 = NF_TestDataFactory.createAdminUser('System Administrator');
	private static Account currentAccount;
	private static Opportunity currentOpportunity;
	public static Opportunity currentOpportunityC1;
	public static Id upsellDealId = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Upsell Deal').getRecordTypeId();
	public static Deal__c upsellDeal;
	public static List<Offer__c> offerList = new List<Offer__c>();
	public static Offer__c optyOffer ;
	public static Apttus_Approval__Backup_Approver__c BackupApprover;
	private static Apttus_Approval__Approval_Request__c currentApprovalRequest;
	private static Apttus_Approval__Approval_Request__c currentApprovalRequest1;
	private static Apttus_Approval__Approval_Request__c currentApprovalRequest2;
	private static Apttus_Approval__Approval_Request__c currentApprovalRequest3;
	private static Apttus_Approval__Approval_Request__c currentApprovalRequest4;
	private static Sales_Role__c currentSalesOrg;
	private static Apttus_Approval__ApprovalRuleAssignee__c ruleAssignee;
	private static Apttus_Approval__ApprovalRuleAssignee__c ruleAssignee1;
	private static Apttus_Approval__ApprovalRuleAssignee__c ruleAssignee2;
	private static Apttus_Approval__ApprovalRuleAssignee__c ruleAssignee3;
	private static Apttus_Approval__ApprovalRuleAssignee__c ruleAssignee4;
	Private Static List<Apttus_Approval__Approval_Request__c> CurrentRequest=new  List<Apttus_Approval__Approval_Request__c>();
	Private Static List<user> userList = new List<user>();
	public static Id swxRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('SWx Upsell Proposal').getRecordTypeId();
	public static Id ccreRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('CCRE Upsell Proposal').getRecordTypeId();
	public static Id swxQuoteRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal').getRecordTypeId();

/******************************
*Method Name: createCCRELineItemForProposalTest
*Description: Test Method to cover createCCRELineItemForProposal method
********************************/
	static testmethod void createCCRELineItemForProposalTest(){
		 Account soldtopartyAcc =  TestDataFactory.createAccount(1)[0];
		//soldtopartyAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		database.insert(soldtopartyAcc);
		
		Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();
		//creating user
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		Opportunity oppty;
		insert userCreation;
		system.runAs(userCreation){
		oppty = TestDataFactory.OpportunityCreation(1,soldtopartyAcc)[0];
		oppty.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
		oppty.RecordTypeId=RecordTypeId;
		oppty.Lead_BG__c ='MN';
		oppty.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
		//insert new File_Sharing_Custom_Setting__c(Name = GlobalConstants.OPPORTUNITY_DOC_FREEZE_STAGE,Value__c='7');
		database.insert(oppty);
		}
		/*
		Apttus_Config2__PriceList__c priceList= TestdataFactory.priceList(1)[0];
		database.insert(priceList);
		
		Apttus_Config2__PriceListItem__c PriceListItem= TestdataFactory.createPriceListItem(1,priceList)[0];
		database.insert(PriceListItem);
		*/
		SWx_Upsell_Proposal__c upsellProposal_SWX=TestDataFactory.upsellList(1,soldtopartyAcc)[0];
		upsellProposal_SWX.Analytics_File_Refer_ID__c='GBR-61940-82356';
		upsellProposal_SWX.Analytics_Source__c='CXM';
		upsellProposal_SWX.Proposal_Recommendation_Type__c='renewal';
		upsellProposal_SWX.P20_Id__c=215616;
		upsellProposal_SWX.CurrencyIsoCode='EUR';
		upsellProposal_SWX.Unweighted_Value__c=429052.07;
		upsellProposal_SWX.Account_ID__c=soldtopartyAcc.Id;
		upsellProposal_SWX.Sold_To_Party__c = soldtopartyAcc.Id;
		upsellProposal_SWX.RecordTypeID=swxRecordTypeId;
		//upsellProposal_SWX.Sold_To_Party__c = accountCreationDP.Id;
		database.insert(upsellProposal_SWX);
		
		/*set<ID> upsellproposalId_SWX= new set<Id>();
		upsellproposalId_SWX.add(upsellProposal_SWX.Id);
		
		List<SWx_Upsell_Items__c> lstSWXUpsellItems = TestDataFactory.createSWXLineItems(upsellproposalId_SWX,1);
		database.insert(lstSWXUpsellItems);
		
		
		Apttus_Proposal__Proposal__c quoteProposal1 = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
		quoteProposal1.Apttus_Proposal__Opportunity__c = oppty.id; 
		quoteProposal1.Apttus_QPConfig__PriceListId__c = priceList.Id;
		quoteProposal1.NokiaCPQ_Portfolio__c = 'IP Routing';
		quoteProposal1.NokiaCPQ_SSP_Level__c = 'Unlimited';
		quoteProposal1.SWx_Upsell_Proposal__c=upsellProposal_SWX.Id;
		quoteProposal1.Analytics_Source__c  = CSWXGlobalConstant.AnalyticsSource;
		quoteProposal1.RecordTypeId = swxQuoteRecordTypeId;
		quoteProposal1.Apttus_Proposal__Account__c=accountCreationDP.id;
		
		database.insert(quoteProposal1); 
		quoteProposal1.Apttus_Proposal__Approval_Stage__c='In Review';
		update quoteProposal1;
		 */   
		Apttus_Proposal__Proposal__c quoteProposal2 = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
		quoteProposal2.Apttus_Proposal__Opportunity__c = oppty.id; 
		//quoteProposal2.Apttus_QPConfig__PriceListId__c = priceList.Id;
		quoteProposal2.NokiaCPQ_Portfolio__c = 'IP Routing';
		quoteProposal2.NokiaCPQ_SSP_Level__c = 'Unlimited';
		quoteProposal2.SWx_Upsell_Proposal__c=upsellProposal_SWX.Id;
		quoteProposal2.Analytics_Source__c  = CSWXGlobalConstant.AnalyticsSource_CCRE;
		quoteProposal2.RecordTypeId = swxQuoteRecordTypeId;
		quoteProposal2.Prices_Aligned__c=true;
		quoteProposal2.Apttus_Proposal__Account__c=soldtopartyAcc.id;
		database.insert(quoteProposal2); 
		quoteProposal2.Apttus_Proposal__Approval_Stage__c='Accepted';
		update quoteProposal2;  
		List<Apttus_Proposal__Proposal__c> quoList = [Select ID, Quote_type__c, NokiaCPQ_Existing_IONMaint_Contract__c, NokiaCPQ_Portfolio__c,  
		NokiaCPQ_ION_Maintenance_Type__c, NokiaCPQ_Existing_FN_Maint_Contract__c, Apttus_QPConfig__PriceListId__c, Apttus_Proposal__Opportunity__c, NokiaCPQ_FN_Maintenance_Type__c, NokiaCPQ_SSP_Level__c, RecordTypeId, Prices_Aligned__c, Apttus_Proposal__Account__c,
		NokiaCPQ_SRS_Level__c, SWx_Upsell_Proposal__c, Analytics_Source__c, NokiaCPQ_Maintenance_Type__c, Apttus_Proposal__Approval_Stage__c, Apttus_Proposal__Proposal_Name__c from Apttus_Proposal__Proposal__c where ID = :quoteProposal2.Id];
		
		set<ID> upsellproposalId= new set<Id>();
		upsellproposalId.add(upsellProposal_SWX.Id);
		
		CCRE_UpSell_LineItem__c ccrelineitems = TestDataFactory.createCCRELineItems(upsellproposalId,1)[0];
		ccrelineitems.Line_Item_Type__c=CSWXGlobalConstant.Product_Info_line_items;
		database.insert(ccrelineitems);
		Apttus_Proposal__Proposal__c quotype = [SELECT quote_type__c FROM Apttus_Proposal__Proposal__c where ID = :quoteproposal2.Id];
		system.debug('quotype:'+quotype); 
		
		Test.startTest();		   
		CCREProposalTriggerHandler.afterInsert(quoList);
		CCREProposalTriggerHandler.createConfiguration(quoList);
		CCREProposalTriggerHandler.createConfiguration(null);
		CCREProposalTriggerHelper.createCCRELineItemForProposal(quoList);
		ccrelineitems.Line_Item_Type__c=CSWXGlobalConstant.Service_Invoice_Info_line_items;
		database.update(ccrelineitems);
		CCREProposalTriggerHelper.createCCRELineItemForProposal(quoList);
		CCREProposalTriggerHelper.createCCRELineItemForProposal(null);
		Test.stopTest();				   
	}
	
	/******************************
	*Method Name: updateQuoteShareTest
	*Description: Test Method to cover updateQuoteShare method
	********************************/
	static testmethod void updateQuoteShareTest(){
		User sysAdminUser = TestDataFactory.createSystemAdminUser();
		System.runAs(sysAdminUser){
		Account soldtopartyAcc =  TestDataFactory.createAccount(1)[0];
		soldtopartyAcc.DMP_Account__c = True;
		database.insert(soldtopartyAcc);
		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;
		
		
		User user1 = new User(alias = 'abc', email = uniqueName + '@nokia.com' , emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
								 languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid = UserInfo.getProfileId(),  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
								 timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
		database.insert(user1); 
		
		//Creating Custom Setting Data
		// CH_AccountName__c accauth = new CH_AccountName__c();
		//accauth.CH_InvalidName__c = 'Nokia';
		//accauth.CH_ValidName__c = 'Nokia-OYJ';
		//insert accauth;
			  
		List<Contact> ContactList = new List<Contact>();
		Contact conDS = new Contact(lastName=CSWXGlobalConstant.ContactNameDS,AccountId=soldtopartyAcc.id,Email=CSWXGlobalConstant.EmailContactNameDS );
		Contact conDS2 = new Contact(lastName=CSWXGlobalConstant.ContactNameDS,AccountId=soldtopartyAcc.id,Email=CSWXGlobalConstant.EmailContactNameDS );
		ContactList.add(conDS);
		ContactList.add(conDS2);
		database.insert(ContactList); 
		
		Profile prof=[Select Id,Name from Profile where Name =:CSWXGlobalConstant.dsCustomerProfile];
	
		User userDS = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',lastname = 'Testing',
								 languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid =prof.id,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
								 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '00',ContactId  = conDS.Id,FederationIdentifier = randomInt+'9567654156177' );
		
		
		system.runAs(user1){						
		database.insert(userDS);		 
		userDS.IsPortalEnabled =  True;
		database.update(userDS);
	   }
	  
		Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();
		//creating user
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		Opportunity oppty;
		insert userCreation;
		system.runAs(userCreation){
		oppty = TestDataFactory.OpportunityCreation(1,soldtopartyAcc)[0];
		oppty.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
		oppty.RecordTypeId=RecordTypeId;
		oppty.Lead_BG__c ='MN';
		oppty.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
		//insert new File_Sharing_Custom_Setting__c(Name = GlobalConstants.OPPORTUNITY_DOC_FREEZE_STAGE,Value__c='7');
		database.insert(oppty);
		  
		}
		/*
		Apttus_Config2__PriceList__c priceList= TestdataFactory.priceList(1)[0];
		database.insert(priceList);
		
		Apttus_Config2__PriceListItem__c PriceListItem= TestdataFactory.createPriceListItem(1,priceList)[0];
		database.insert(PriceListItem);
		*/
		SWx_Upsell_Proposal__c upsellProposal_SWX=TestDataFactory.upsellList(1,soldtopartyAcc)[0];
		upsellProposal_SWX.Analytics_File_Refer_ID__c='GBR-61940-82356';
		upsellProposal_SWX.Analytics_Source__c='CXM';
		upsellProposal_SWX.Proposal_Recommendation_Type__c='renewal';
		upsellProposal_SWX.P20_Id__c=215616;
		upsellProposal_SWX.CurrencyIsoCode='EUR';
		upsellProposal_SWX.Unweighted_Value__c=429052.07;
		upsellProposal_SWX.Account_ID__c=soldtopartyAcc.Id;
		upsellProposal_SWX.Technology__c=CSWXGlobalConstant.Technology ;
		upsellProposal_SWX.Use_Case__c=CSWXGlobalConstant.Usecase ;
		upsellProposal_SWX.Sold_To_Party__c = soldtopartyAcc.Id;
		upsellProposal_SWX.RecordTypeID=swxRecordTypeId;
		// upsellProposal_SWX.Sold_To_Party__c = accountCreationDP.Id;
		database.insert(upsellProposal_SWX);
		 
		Test.startTest(); 
			 
		oppty.SWx_Upsell_Proposal__c =upsellProposal_SWX.id;
		Database.update(oppty);
		List<Id> OpportunityList = new List<Id>();
		OpportunityList.add(oppty.id);
			  
		Apttus_Proposal__Proposal__c quoteProposal1 = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
		quoteProposal1.Apttus_Proposal__Opportunity__c = oppty.id; 
		//quoteProposal1.Apttus_QPConfig__PriceListId__c = priceList.Id;
		quoteProposal1.NokiaCPQ_Portfolio__c = 'IP Routing';
		quoteProposal1.NokiaCPQ_SSP_Level__c = 'Unlimited';
		quoteProposal1.SWx_Upsell_Proposal__c=upsellProposal_SWX.Id; 
		quoteProposal1.LOA_Status__c='G4 Submission';
		quoteProposal1.Apttus_Proposal__Approval_Stage__c=CSWXGlobalConstant.quoteShareApproved;
		quoteProposal1.Analytics_Source__c  = CSWXGlobalConstant.AnalyticsSource;
		quoteProposal1.RecordTypeId = swxQuoteRecordTypeId;
		quoteProposal1.Apttus_Proposal__Account__c=soldtopartyAcc.id;
		
		database.insert(quoteProposal1); 
		quoteProposal1.Apttus_Proposal__Approval_Stage__c='In Review';
			  
		update quoteProposal1;
		  
		Apttus_Proposal__Proposal__c quoteProposal2 = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
		quoteProposal2.Apttus_Proposal__Opportunity__c = oppty.id; 
		//quoteProposal2.Apttus_QPConfig__PriceListId__c = priceList.Id;
		quoteProposal2.NokiaCPQ_Portfolio__c = 'IP Routing';
		quoteProposal2.NokiaCPQ_SSP_Level__c = 'Unlimited';
		quoteProposal2.SWx_Upsell_Proposal__c=upsellProposal_SWX.Id;
		quoteProposal2.Analytics_Source__c  = CSWXGlobalConstant.AnalyticsSource;
		quoteProposal2.RecordTypeId = swxQuoteRecordTypeId;
		quoteProposal2.Prices_Aligned__c=true;
		quoteProposal2.Apttus_Proposal__Account__c=soldtopartyAcc.id;
		database.insert(quoteProposal2); 
		quoteProposal2.LOA_Status__c='G4 Submission';
		quoteProposal2.Apttus_Proposal__Approval_Stage__c='In Review';
		quoteProposal2.Contract_Start_Date__c = system.today();	  
		update quoteProposal2;
		quoteProposal2.Apttus_Proposal__Approval_Stage__c='Approved';
		quoteProposal2.LOA_Status__c='Approved';
		update quoteProposal2;  
		 
		Map<Id,Apttus_Proposal__Proposal__c> oldRecords = new Map<Id,Apttus_Proposal__Proposal__c>();
		oldRecords.put(quoteProposal2.id, quoteProposal1); 
		List<Apttus_Proposal__Proposal__c> quoList=new List<Apttus_Proposal__Proposal__c>();
		quoList.add(quoteProposal2);  
		Apttus_Proposal__Proposal__c quorec = [Select ID, Quote_type__c, NokiaCPQ_Existing_IONMaint_Contract__c, NokiaCPQ_Portfolio__c,	 NokiaCPQ_ION_Maintenance_Type__c, NokiaCPQ_Existing_FN_Maint_Contract__c, Apttus_QPConfig__PriceListId__c, Apttus_Proposal__Opportunity__c, NokiaCPQ_FN_Maintenance_Type__c, NokiaCPQ_SSP_Level__c, RecordTypeId, Prices_Aligned__c, Apttus_Proposal__Account__c,
		NokiaCPQ_SRS_Level__c,LOA_Status__c,Contract_Start_Date__c, SWx_Upsell_Proposal__c, Analytics_Source__c, NokiaCPQ_Maintenance_Type__c, Apttus_Proposal__Approval_Stage__c, Apttus_Proposal__Proposal_Name__c
		from Apttus_Proposal__Proposal__c where ID = :quoteProposal1.Id];
		Map<Id,Apttus_Proposal__Proposal__c> records = new Map<Id,Apttus_Proposal__Proposal__c>();
		records.put(quorec.id, quorec);	  
		CCREProposalTriggerHandler.updateQuoteShare(quoList,oldRecords);
		CCREProposalTriggerHandler.updateQuoteShare(null,null);
		CCREProposalTriggerHelper.checkQuoteApprovalStage(null,null);
		CCREProposalTriggerHelper.byPassG4(null);
		CCREProposalTriggerHelper.byPassG4(OpportunityList);
	   //CCREProposalTriggerHandler.updateOpportunity(null);
		CCREProposalTriggerHandler.updateOpportunity(records);
		//CCREProposalTriggerHandler.checkQuoteApprovalStage(null,null);
		//CCREProposalTriggerHelper.updateQuoteShare(quoList, oldrecords)
		Test.stopTest();   
	   }
	}

	 public static testMethod void updateQuoteShareTest1(){
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		list<user> userCreationval = TestDataFactory.userCreation(4,'System Administrator');
		insert userCreation;
		insert userCreationval;
		List<User> userList = new List<User>();
		 
		userList.add(testUser1);
		userList.add(testUser2);
		userList.add(testUser3);
		userList.add(testUser4);
		userList.add(testUser);
		insert userList;
		system.runAs(userCreation){
		currentAccount = NF_TestDataFactory.createAccount('132456783');
		currentAccount.L5Name__c = 'LAT GCBT CARSO';
		currentAccount.L4Name__c = 'Market Latin America';
		insert currentAccount;
		 
		upsellDeal = TestDataFactory.createDeal(1)[0];
		upsellDeal.RecordTypeId = upsellDealId;
		insert upsellDeal;
		Sales_Role__c currentSalesOrg;
		Sales_Role__c currentSalesOrg1;
		//Apttus_Approval__Backup_Approver__c Apttus_BAckup;
		CurrentSalesOrg = NF_TestDataFactory.createSalesRole(userCreationval[0],'NSNB_BGCM','Customer Operations','3 - BG Trial Demo Validator');
		CurrentSalesOrg1 = NF_TestDataFactory.createSalesRole(userCreationval[0],'NSNC_BGCMH','Market Latin America','4 - BG Trial Demo Validator');
		CurrentSalesOrg.BG__c='MN';
		CurrentSalesOrg1.BG__c='MN';
		insert CurrentSalesOrg;
		insert CurrentSalesOrg1;
		
		BackupApprover =new Apttus_Approval__Backup_Approver__c (
							 Apttus_Approval__DelegateUserIds__c=userCreationval[1].id+','+userCreationval[2].id+','+userCreationval[3].id,
							 Apttus_Approval__Backup_User__c = userCreation.id, 
							 Apttus_Approval__IsDelegate__c=true,
							 Apttus_Approval__IsActive__c=true,
							 Apttus_Approval__InEffect__c=true);
		
		BackupApprover.Apttus_Approval__Current_User__c=userCreationval[0].id;
		insert BackupApprover;
		
		currentOpportunity = NF_TestDataFactory.createOpportunity(currentAccount.Id, 'Develop Opportunity', 'Opportunity in Progress',Date.today().addDays(10), 700);
		currentOpportunity.NF_Facilitator_Notified__c=false;
		currentOpportunity.Business_Type__c='Committed Upsell';
		currentOpportunity.Apttus_Approval__Approval_Status__c='Not Submitted';
		currentOpportunity.Unweighted_Amount_EUR__c=10000000;
		currentOpportunity.Committed_Unweighted_Value_in_EUR__c= 10000000; 
		currentOpportunity.Lead_BG__c='MN';
		insert currentOpportunity;
		Test.startTest();
		currentOpportunityC1 = NF_TestDataFactory.createOpportunity(currentAccount.Id, 'Win the Case (Negotiate)', 'Pending Win/Loss Declaration', Date.today().addDays(10), 700);
		currentOpportunityC1.NF_Facilitator_Notified__c=false;
		currentOpportunityC1.Business_Type__c='Standard Opportunity';
		currentOpportunityC1.Unweighted_Amount_EUR__c=10000000;
		currentOpportunityC1.Lead_BG__c='MN';
		insert currentOpportunityC1;
		 
		Apttus_Approval__Approval_Process__c Aprocess=new Apttus_Approval__Approval_Process__c();
		insert Aprocess;
			
		Apttus_Approval__ApprovalProcessInstance__c processinstance=new Apttus_Approval__ApprovalProcessInstance__c(name=CSWXGlobalConstant.G3ProcessId,Apttus_Approval__BusinessObjectId__c=currentOpportunity.id, Apttus_Approval__ApprovalProcessId__c=Aprocess.id);
		insert processinstance;
			
		Opportunity_Group__c oppsubordinateGRP=new Opportunity_Group__c(Deal__c=upsellDeal.id,Opportunity__c=currentOpportunity.id,Opportunity_Relation__c='subordinate');  
		insert oppsubordinateGRP;
			
		Opportunity_Group__c oppMAsterGRP=new Opportunity_Group__c(Deal__c=upsellDeal.id,Opportunity__c=currentOpportunityC1.id,Opportunity_Relation__c='Master');  
		insert oppMAsterGRP;
			
		Apttus_Approval__ApprovalRule__c appRule = NF_TestDataFactory.createApprovalRule('rule class C1', true, 'Opportunity', 'Condition', 1);
		insert appRule;

		Apttus_Approval__ApprovalRuleEntry__c ruleEntry = NF_TestDataFactory.createRuleEntry(appRule.Id, 1);
		insert ruleEntry;
		   
		String assigneeValue2 = 'Sales_Role__c (Role_Code__c =\'NMS%D_BM \' AND O__c =\':Org_L4__c\' AND Active__c=true).User__c';

		String assigneeValue1 = 'Sales_Role__c (Role_Code__c =\'NSN%C_BM\' AND O__c =\':Org_L4__c\' AND Active__c=true).User__c';
		String assigneeValue ='Sales_Role__c(Role_Code__c=\'NSN%C_BM\' AND ( O__c =\':Org_L4__c\' OR __c =\':Org_L5__c\' OR O__c =\':Org_L6__c\' OR O__c =\':Org_L7__c\') AND Active__c=true).User__c';
		String assigneeValue3 ='Sales_Role__c(Role_Code__c=\'NSN%C_BM\' AND ( O__c =\':Org_L4__c\' OR __c =\':Org_L5__c\' OR O__c =\':Org_L6__c\' OR O__c =\':Org_L7__c\') AND Active__c=true and BG__c=\'NSW\').User__c';
		
		List<Apttus_Approval__ApprovalRuleAssignee__c> AssigneeList = new List<Apttus_Approval__ApprovalRuleAssignee__c>();
		ruleAssignee = NF_TestDataFactory.createArAssignee(ruleEntry.Id, 1, true, false, assigneeValue);
		ruleAssignee.Apttus_Approval__AssigneeDescription__c = 'NSNC_BM, Validator';
		AssigneeList.add(ruleAssignee);
		
		ruleAssignee1 = NF_TestDataFactory.createArAssignee(ruleEntry.Id, 1, true, false, assigneeValue1);
		ruleAssignee1.Apttus_Approval__AssigneeDescription__c = 'NSNC_BM, Validator';
		AssigneeList.add(ruleAssignee1);
		
		
		ruleAssignee2 = NF_TestDataFactory.createArAssignee(ruleEntry.Id, 1, true, false, assigneeValue2);
		ruleAssignee2.Apttus_Approval__AssigneeDescription__c = 'NMSD_BM, Validator';
		AssigneeList.add(ruleAssignee2);
		
		ruleAssignee3 = NF_TestDataFactory.createArAssignee(ruleEntry.Id, 1, true, false, assigneeValue2);
		ruleAssignee3.Apttus_Approval__AssigneeDescription__c = 'NMSE_BM, Approver';
		AssigneeList.add(ruleAssignee3);
		
		ruleAssignee4 = NF_TestDataFactory.createArAssignee(ruleEntry.Id, 1, true, false, assigneeValue3);
		ruleAssignee4.Apttus_Approval__AssigneeDescription__c = 'NMSG_BM, Validator';
		AssigneeList.add(ruleAssignee4);
		insert AssigneeList;
		
		ruleAssignee = [Select Id, Name, Apttus_Approval__AssigneeDescription__c from Apttus_Approval__ApprovalRuleAssignee__c where Id = :ruleAssignee.Id];
		ruleAssignee1 = [Select Id, Name, Apttus_Approval__AssigneeDescription__c from Apttus_Approval__ApprovalRuleAssignee__c where Id = :ruleAssignee1.Id];
		ruleAssignee2 = [Select Id, Name, Apttus_Approval__AssigneeDescription__c from Apttus_Approval__ApprovalRuleAssignee__c where Id = :ruleAssignee2.Id];
		ruleAssignee3 = [Select Id, Name, Apttus_Approval__AssigneeDescription__c from Apttus_Approval__ApprovalRuleAssignee__c where Id = :ruleAssignee3.Id];
		ruleAssignee4 = [Select Id, Name, Apttus_Approval__AssigneeDescription__c from Apttus_Approval__ApprovalRuleAssignee__c where Id = :ruleAssignee4.Id];

		
		currentApprovalRequest1 = NF_TestDataFactory.createApprovalRequest('Notified', 'User', 'Opportunity', currentOpportunity.Id, true, false, testUser.FirstName+''+testUser.LastName, userList[0].Id, AssigneeList[1].Name);
		currentApprovalRequest1 .NF_Assignee_Type__c='Approver';
		currentApprovalRequest1 .Apttus_Approval__Approval_Status__c='Approved';
		currentApprovalRequest1.Apttus_Approval__DelegateApproverIds__c=testUser.Id+','+userList[1].Id;
		CurrentRequest.add(currentApprovalRequest1);
	  
		 
		currentApprovalRequest2 = NF_TestDataFactory.createApprovalRequest('Assigned', 'User', 'Opportunity', currentOpportunity.Id, true, false, testUser.FirstName+''+testUser.LastName, userList[1].Id, AssigneeList[2].Name);
		currentApprovalRequest2.NF_Assignee_Type__c='Approver';
		currentApprovalRequest2.Apttus_Approval__Approval_Status__c='Approved';
		currentApprovalRequest2.Apttus_Approval__DelegateApproverIds__c=testUser.Id+','+userList[2].Id;
		CurrentRequest.add(currentApprovalRequest2);
	 
		Database.insert(CurrentRequest);
 
		CCREProposalTriggerHelper.updateOpportunityApprovalHistory(currentOpportunity.id);
		CCREProposalTriggerHelper.updateOpportunityApprovalHistory(null);
		Test.stopTest();   
		}
	}
}