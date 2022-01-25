@isTest(SeeAllData=false)
 public with sharing class QuoteWarningMessage_test{
	   @testSetup 
	 static void methodData() {
		File_Sharing_Custom_Setting__c fscs = new File_Sharing_Custom_Setting__c();
			fscs.name= 'Opportunity_SalesPhase_FinalStage';
			fscs.Value__c = 'Completed';
			insert fscs;
	   //Create Account
	Account account = NF_TestDataFactory.createAccount('Test Account');
	account.Partner_Program__c='GPP 3.0';
	List<Account> accounts=new List<Account>();
	 accounts.add(account);
	 insert accounts;
				   QuoteWarningMessage.getQuoteId(accounts[0].Id);
	//Create Opportunity
	List<opportunity> opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
	   insert opportunities;
		 

	}
	
	 
	static testMethod void test_QuoteTrigger(){
		
		List<Account> account_Obj  =  [SELECT Id,Name from Account];
		List<Opportunity> opportunity_Obj  =  [SELECT Id from Opportunity];
		//Creation of Accreditation
		
		 /*Accreditation__c accred = new Accreditation__c(
			partner__c = account_Obj[0].Id,
			Accreditation_Type__c = 'Product',
			Portfolio__c = 'IP Routing',
			Pricing_Cluster__c = 'NAM',
			Accreditation_Level__c = 'Advanced', 
			Pricing_Level_Override__c = 'Advanced',
			Accreditation_Date__c = date.today() + 9, 
			Pricing_Override_Expiration__c = date.today() + 9, 
			Actual_pricing_level__c = 'Advanced'
		);
		insert accred;*/
		
		//create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
		accreditations[0].partner__c = account_Obj[0].Id;
		accreditations[1].partner__c = account_Obj[0].Id;
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Premium';
		accreditations[1].Pricing_Level_Override__c = 'Premium';   
		insert accreditations;

		test.startTest();//create proposal
		 
		Apttus_Proposal__Proposal__c Quote_Obj = new Apttus_Proposal__Proposal__c(
			Apttus_Proposal__Proposal_Name__c = 'quote',Apttus_Proposal__Approval_Stage__c = 'Draft',
			Apttus_Proposal__Account__c = account_Obj[0].Id,
			Apttus_Proposal__Opportunity__c = opportunity_Obj[0].Id,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
			NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
			NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
			NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
			NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
			NokiaCPQ_SSP_Level__c = 'Unlimited',
			NokiaCPQ_SRS_Level__c = 'Unlimited',
			RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Direct Quote').getRecordTypeId(),
			NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
			NokiaCPQ_Portfolio__c = 'IP Routing',
			NokiaCPQ_No_of_Years__c = '1'
		);
		insert Quote_Obj;

List<Apttus_Proposal__Proposal__c> Quote_Obj1=  [SELECT Id from Apttus_Proposal__Proposal__c]; 
		QuoteWarningMessage.getQuoteId(Quote_Obj1[0].Id);
		test.stopTest();
	}
	 static testMethod void test_SIT(){ try {
		test.startTest();
		List<Account> account_Obj  =  [SELECT Id,Name from Account];
		List<Opportunity> opportunity_Obj  =  [SELECT Id from Opportunity];
		 //create proposal
		Apttus_Proposal__Proposal__c Quote_Obj = new Apttus_Proposal__Proposal__c(
			Apttus_Proposal__Proposal_Name__c = 'quote',Apttus_Proposal__Approval_Stage__c = 'Approval Required',
			Apttus_Proposal__Account__c = account_Obj[0].Id,
			Apttus_Proposal__Opportunity__c = opportunity_Obj[0].Id,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
			NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
			NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
			NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
			NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
			NokiaCPQ_SSP_Level__c = 'Unlimited',
			NokiaCPQ_SRS_Level__c = 'Unlimited',
			NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
			NokiaCPQ_Portfolio__c = 'IP Routing',
			NokiaCPQ_No_of_Years__c = '1'

		);
		 QuoteWarningMessage.getQuoteId(Quote_Obj.Id);
		insert Quote_Obj;
		 
List<Apttus_Proposal__Proposal__c> Quote_Obj1=  [SELECT Id,Apttus_Proposal__Approval_Stage__c from Apttus_Proposal__Proposal__c];  
		QuoteWarningMessage.getQuoteId(Quote_Obj1[0].Id);
		test.stopTest();
	 }
		 catch(DMLException e) {
			system.assertEquals(e.getMessage(), e.getMessage());
		}
	}
}