@isTest
private with sharing class CCREProposalG4HelperTest {
	public static Id swxRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('SWx Upsell Proposal').getRecordTypeId();
	public static Id ccreRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('CCRE Upsell Proposal').getRecordTypeId();
	public static Id swxQuoteRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal').getRecordTypeId();
	
	static testmethod void byPassG4Test(){
		User userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		userCreation.Nokia_ID__c = '8896';
		Set<Id> accId = new Set<Id>();
		List<Id> oppId = new List<Id>();
		
		List<Account> accountCreation = TestDataFactory.createAccount(2);
		accountCreation[0].AccountNumber = '3011234';
		accountCreation[1].AccountNumber = '3011235';
		database.insert(accountCreation);
		accId.add(accountCreation[0].Id);
		accId.add(accountCreation[1].Id);
		
	  
		Map<Id,Opportunity> upsellProposalToOppty = new Map<Id,Opportunity>(); 
		
		Account acc = new Account();
		acc.Name='Legal Entinty Account For';
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		acc.ParentId = accountCreation[0].Id;
		acc.AccountNumber = '100006843';
		database.insert(acc);
		
		List<Opportunity> opp = TestDataFactory.OpportunityCreation(1,accountCreation[0]);
		//opp.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
		//oppty.RecordTypeId=RecordTypeId;
		//opp.Lead_BG__c ='MN';
		//opp.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
		//insert new File_Sharing_Custom_Setting__c(Name = GlobalConstants.OPPORTUNITY_DOC_FREEZE_STAGE,Value__c='7');
		database.insert(opp);
		oppId.add(opp[0].Id);
		List<SWx_Upsell_Proposal__c> upsellObjList = new List<SWx_Upsell_Proposal__c>();
		List<SWx_Upsell_Proposal__c> upsellObj = TestDataFactory.upsellList(2,accountCreation[0]);
		
		upsellObj[0].Upsell_Status__c = CSWXGlobalConstant.readyForConversion;
		//upsellObj[0].Apttus_Approval__Approval_Status__c = CSWXGlobalConstant.Approval_stage_approved;
		upsellObj[1].Upsell_Status__c = CSWXGlobalConstant.readyForConversion;
		upsellObj[0].Ready_to_Convert__c = true;
		upsellObj[1].Ready_to_Convert__c = true;
		upsellObj[0].Account_ID__c = accountCreation[0].id;
		upsellObj[0].Sold_To_Party__c = accountCreation[0].id;
		upsellObj[1].Account_ID__c = accountCreation[0].id;
		upsellObj[1].Sold_To_Party__c  = accountCreation[0].id;
		upsellObj[0].Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource;
		upsellObj[1].Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource_CCRE;
		upsellObj[1].Expected_LoA_Level__c = 'LoA Bypass'; 
		upsellObj[1].Business_Rules_Check__c = 'Green';
		upsellObj[0].RecordTypeId = swxRecordTypeId ; 
		upsellObj[1].RecordTypeId = ccreRecordTypeId ; 
		upsellObjList.add(upsellObj[0]);
		upsellObjList.add(upsellObj[1]);
		database.insert(upsellObjList);
		
	   /* List<CCRE_UpSell_LineItem__c> ccreLineItemList = TestDataFactory.createCCRELineItem(2,upsellObj[1]);
		ccreLineItemList[0].Line_Item_Type__c='product_info_line_items';
		ccreLineItemList[0].Upsell_Proposal__c=upsellObj[1].id;
		ccreLineItemList[1].Line_Item_Type__c='Service_Invoice_Info_line_items';
		ccreLineItemList[2].Upsell_Proposal__c=upsellObj[1].id;
		database.insert(ccreLineItemList);*/
		
		//upsellObj[1].Upsell_Status__c = 'Convert';
		opp[0].SWx_Upsell_Proposal__c=upsellObjList[0].Id;
		update opp[0];
		//update upsellObj[1];
		
		Apttus_Approval__Approval_Process__c mainProcess = new Apttus_Approval__Approval_Process__c();
		mainProcess.Apttus_Approval__Process_Name__c = 'G3 Approvals (Bypass)';
		mainProcess.Apttus_Approval__Active__c = true;
		mainProcess.Apttus_Approval__Object_Name__c = 'Opportunity';
		mainProcess.Apttus_Approval__Object_Label__c = 'Opportunity';
		mainProcess.Apttus_Approval__ContextType__c = 'Single';
		insert mainProcess;
		
	  	Apttus_Approval__Approval_Request__c apprequest = new Apttus_Approval__Approval_Request__c();
		apprequest.Apttus_Approval__Step_Name__c = 'Gate 2';
		apprequest.Apttus_Approval__Related_Opportunity__c= opp[0].id;
		apprequest.Apttus_Approval__Active__c = True;
		apprequest.Apttus_Approval__Object_Id__c = '1233';
		apprequest.Apttus_Approval__Notify_Only__c = True; 
		apprequest.Apttus_Approval__RequestType__c = 'STANDARD';
		apprequest.Apttus_Approval__Object_Name__c = 'Forecasting_30Aug2018';
		insert apprequest;
	  	
			
	  /*Apttus_Proposal__Proposal__c quoteProposal1 = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
		quoteProposal1.Apttus_Proposal__Opportunity__c = opp[0].id; 
		//quoteProposal1.Apttus_QPConfig__PriceListId__c = priceList.Id;
		quoteProposal1.NokiaCPQ_Portfolio__c = 'IP Routing';
		quoteProposal1.NokiaCPQ_SSP_Level__c = 'Unlimited';
		quoteProposal1.SWx_Upsell_Proposal__c=upsellObj[1].Id;
		quoteProposal1.Analytics_Source__c  = CSWXGlobalConstant.AnalyticsSource_CCRE;
		quoteProposal1.RecordTypeId = swxQuoteRecordTypeId;
		quoteProposal1.Apttus_Proposal__Account__c=accountCreation[0].id;
		
		database.insert(quoteProposal1); 
		List<Apttus_Proposal__Proposal__c> quoList = new List<Apttus_Proposal__Proposal__c>();
		quoList.add(quoteProposal1);*/

		Test.startTest();   
		   CCREProposalG4Helper c1 = new CCREProposalG4Helper(oppId);
		CCREProposalG4Helper.byPassG4(oppId);
		CCREProposalG4Helper.byPassG4(null);
		CCREProposalG4Helper.updateOpportunityApprovalHistory(oppId,'G3 Approvals (Bypass)'); 
		CCREProposalG4Helper.updateOpportunityApprovalHistory(oppId,CSWXGlobalConstant.G4_APPROVAL_BYPASS);	 
		Test.stopTest();
		
		
	}
	
}