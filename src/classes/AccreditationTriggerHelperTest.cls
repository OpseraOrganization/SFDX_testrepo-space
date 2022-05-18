/****************************************
* Class Name : AccreditationTriggerHelperTest
* Created Date: 31st August, 2018
* Created By : Accenture
* Last Modified by: Accenture
* Description : This Test class handles CPQ functionalities in AccreditationTrigger, 
  AccreditationTriggerHelper, NeedsRepriceAccreditationInvocable and AccreditationHandler
* Test Class: 
*****************************************/
@isTest(seeAllData=false)
public class AccreditationTriggerHelperTest {
	
	
	/**********************************************
	 * Method Name : accrdTrigger
	 * return type : void
	 * description : covers Accreditation trigger & AccreditationTriggerHelper
	 ********************************************/
	
	//public static testmethod void accrdTrigger(){
	@isTest(seeAllData=false)
	public static void accrdTrigger(){
			//create user to run class
			
	  List<user> runUSer = new List<user>();
	  runUSer = TestDataFactory.userCreation(2,'System Administrator');
	  runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
	  runUSer[0].NSA_Compliant__c = true;
	  database.insert(runUSer);
		
	  system.runAs(runUSer[0]){
	//create a Account
			List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
			accounts[0].Acc_No__c = 'Test10';
	  accounts[0].Partner_Type__c='Value Added Reseller';
			accounts[0].Partner_Program__c ='GPP 3.0';
	accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
			accounts[1].Partner_Type__c = '';
			accounts[1].Partner_Program__c = '';
			insert accounts;
	system.debug('accountinserted--->'+accounts);
	
	
		
			//Create an Opportunity
			List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(1,accounts);
			opportunities[0].PSR_Pre_Sales_Risk_Opportunity_Type__c ='test';
			opportunities[0].SWx_Upsell_Proposal__c = null;
			opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	opportunities[0].End_Customer_LE__c = accounts[1].id;  
	insert opportunities; 
			system.debug('opportunities--->'+opportunities);
	  
	  
			Test.startTest();
		
			List<Contract> contractRecords = new List<Contract>();
			Contract ctr = new Contract();
			ctr.AccountId =accounts[0].Id;
			ctr.Status='Draft';
			ctr.Name='Test1';
			ctr.StartDate=date.today();
			contractRecords.add(ctr);
			insert contractRecords;
			List<Certification_Matrix__c> listmatrix = new List<Certification_Matrix__c>();
			Certification_Matrix__c  cm = new Certification_Matrix__c();
			cm.Job_Function__c='Sales Associate';
			listmatrix.add(cm);
			insert listmatrix;
			//Create Accreditations
			Certification__c createCert = new Certification__c();
			//createCert.Name__c='0032100000Tkn92';
			createCert.Partner__c= accounts[0].Id;
			createCert.ABA_Certification_Approver__c= runUSer[0].id;
			createCert.Certification_Matrix_Number__c=listmatrix[0].id;
			createCert.Approvedby_Authority__c  ='Yes';
			createCert.Certification_Status__c ='Completed';
			insert createCert;
			List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditationforProd(2);
			accreditations[0].partner__c = accounts[0].Id;  
			accreditations[0].Accreditation_Type__c = 'Maintenance';
			accreditations[0].Accreditation_Level__c = 'Authorized - Accreditation In Progress';
			accreditations[0].Sales_Associate__c=5;
			accreditations[0].Sales_Engineer__c=4;
			accreditations[0].Field_Technician__c=2;
			accreditations[1].partner__c = accounts[0].Id;
			accreditations[1].Sales_Associate__c=5;
			accreditations[1].Sales_Engineer__c=4;
			accreditations[1].Field_Technician__c=2;
			accreditations[1].Accreditation_Type__c = 'Maintenance';
			accreditations[1].Accreditation_Level__c = 'Authorized - Accreditation In Progress';
			insert accreditations;
	 
	Map<Id, Accreditation__c> mapoldAcc = new Map<Id, Accreditation__c>();
	mapoldAcc.put(accreditations[0].Id, accreditations[0]);
	
			accreditations[0].Accreditation_Level__c = 'Basic';
			accreditations[0].Reason_for_Level_Change__c = 'Change in Business Plan';
			update accreditations;
		
			AccreditationTriggerHelper.sendChatter(accreditations);
	AccreditationTriggerHelper.displayOnPartnerPortal(accreditations, mapoldAcc);
			system.debug('accreditations upsert--->'+accreditations);
			test.stopTest(); 
	  }
		
	}   
	/**********************************************
	 * Method Name : needsRepriceAccredtest
	 * return type : void
	 * description : covers Accreditation trigger, NeedsRepriceAccreditationInvocable & NeedsRepriceBatch
	 ********************************************/ 
	public static testmethod void needsRepriceAccredtest(){
		
		 //create a Account
			List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
			accounts[0].Acc_No__c = 'Test101';
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
			accounts[1].Partner_Type__c = '';
			accounts[1].Partner_Program__c = '';
			insert accounts;
			system.debug('accountinserted--->'+accounts);
		
			//Create an Opportunity
			List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(1,accounts);
			opportunities[0].PSR_Pre_Sales_Risk_Opportunity_Type__c ='test';
			opportunities[0].SWx_Upsell_Proposal__c = null;
			opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].StageName = 'Create Offer (Bid)';
		opportunities[0].Phase_Status__c = 'Offer in Progress';
		opportunities[0].End_Customer_LE__c = accounts[1].id;	
		insert opportunities; 
			system.debug('opportunities--->'+opportunities);
			
			//Create Accreditations
			List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditationforProd(2);
			accreditations[0].partner__c = accounts[0].Id;
			accreditations[1].partner__c = accounts[0].Id;
			accreditations[0].Accreditation_Type__c = 'Maintenance';
			accreditations[0].Accreditation_Level__c = 'Authorized - Accreditation In Progress';
			insert accreditations;
		
			system.debug('accreditations--->'+accreditations);
			Test.startTest();
			//create a quote
			List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
			proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
			proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
			proposals[0].NokiaCPQ_Needs_Reprice__c = false;
			proposals[0].Reprice_In_Progress__c = false;
			insert proposals;
			
			system.debug('proposals--->'+proposals);
			accreditations[0].Accreditation_Level__c = 'Basic';
			accreditations[0].Reason_for_Level_Change__c = 'Change in Business Plan';
			update accreditations;
		
			system.debug('accreditations upsert--->'+accreditations);
			test.stopTest();
	}
	
	/**********************************************
	 * Method Name : updatedquotestest
	 * return type : void
	 * description : covers Accreditation trigger, NeedsRepriceAccreditationInvocable & NeedsRepriceBatch
	 ********************************************/ 
	public static testmethod void updatedquotestest(){
		
		 //create a Account
			List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
			accounts[0].Acc_No__c = 'Test1010';
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
			accounts[1].Partner_Type__c = '';
			accounts[1].Partner_Program__c = '';
			insert accounts;
			system.debug('accountinserted--->'+accounts);
		
			//Create an Opportunity
			List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(1,accounts);
			opportunities[0].PSR_Pre_Sales_Risk_Opportunity_Type__c ='test';
			opportunities[0].SWx_Upsell_Proposal__c = null;
			opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].StageName = 'Create Offer (Bid)';
		opportunities[0].Phase_Status__c = 'Offer in Progress';
		opportunities[0].End_Customer_LE__c = accounts[1].id;	
		insert opportunities; 
			system.debug('opportunities--->'+opportunities);
			
			//Create Accreditations
			List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditationforProd(2);
			accreditations[0].partner__c = accounts[0].Id;
			accreditations[1].partner__c = accounts[0].Id;
			accreditations[0].Accreditation_Type__c = 'Maintenance';
			accreditations[0].Accreditation_Level__c = 'Authorized - Accreditation In Progress';
			insert accreditations;
		
			system.debug('accreditations--->'+accreditations);
			Test.startTest();
			//create a quote
			List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
			proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
			proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
			proposals[0].NokiaCPQ_Needs_Reprice__c = false;
			proposals[0].Reprice_In_Progress__c = false;
			insert proposals;
			
			List<String> accredtationId = new List<String>();
			accredtationId.add(accreditations[0].id);
			accredtationId.add(accreditations[1].id);
			NeedsRepriceAccreditationInvocable.updateQuotes(accredtationId);
			NeedsRepriceAccreditationInvocable.updateQuotesInBulk(accreditations);
			test.stopTest();
	}
	
	 /**********************************************
	 * Method Name : populateIncotermOnAccreditaionTest
	 * return type : void
	 * description : covers Accreditation trigger & AccreditationTriggerHelper
	 ********************************************/
	public static testmethod void populateIncotermOnAccreditaionTest(){
		 //create a Account
			List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
			accounts[0].Acc_No__c = 'Test101';
			insert accounts;
			system.debug('accountinserted--->'+accounts);
		
		//Create Accreditations
			List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditationforProd(1);
			accreditations[0].partner__c = accounts[0].Id;
			accreditations[0].Accreditation_Type__c = 'Product';
			accreditations[0].Accreditation_Level__c = 'Authorized';
			accreditations[0].Pricing_Level_Override__c ='Authorized';
		accreditations[0].Accreditation_Level__c = PRMGlobalConstants.AccredAdvanced;
			accreditations[0].RecordTypeId = Schema.SObjectType.Accreditation__c.getRecordTypeInfosByDeveloperName().get('Reseller_GPP_3_0').getRecordTypeId();
			insert accreditations;
		
		AccreditationTriggerHelper.displayOnPartnerPortal(accreditations, null);
	}
	
	public static testmethod void populateIncotermOnAccreditaionTest1(){
		 //create a Account
			List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
			accounts[0].Acc_No__c = 'Test101';
		//accounts[0].Co_Op_Account_Created__c = 'Yes';
			insert accounts;
			system.debug('accountinserted--->'+accounts);
		
		//Create Accreditations
			List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditationforProd(1);
			accreditations[0].partner__c = accounts[0].Id;
			accreditations[0].Accreditation_Type__c = 'Product';
			accreditations[0].Accreditation_Level__c = 'Authorized';
			accreditations[0].Pricing_Level_Override__c ='Authorized';
		//accreditations[0].PRM_Display_On_Partner_Locator__c = 'Yes';
		accreditations[0].Accreditation_Level__c = PRMGlobalConstants.AccredAdvanced;
			accreditations[0].RecordTypeId = Schema.SObjectType.Accreditation__c.getRecordTypeInfosByDeveloperName().get('Reseller_GPP_3_0').getRecordTypeId();
			insert accreditations;
		
		Map<Id, Accreditation__c> mapoldAcc = new Map<Id, Accreditation__c>();
	mapoldAcc.put(accreditations[0].Id, accreditations[0]);
	
			accreditations[0].Accreditation_Level__c = 'Advanced';
			accreditations[0].Reason_for_Level_Change__c = 'Change in Business Plan';
			update accreditations;
		
		AccreditationTriggerHelper.displayOnPartnerPortal(accreditations, mapoldAcc);
	}
}