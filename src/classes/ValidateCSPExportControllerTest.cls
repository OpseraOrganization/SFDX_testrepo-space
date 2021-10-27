@isTest 
public class ValidateCSPExportControllerTest 
{
  static testMethod void validateProdct() 
  {
		List<User> userList = new List<User>();
		userList = TestDataFactory.userCreation(1, 'System Administrator');
		Database.insert(userList);
		
		System.runAs(userList[0]){
			List<File_Sharing_Custom_Setting__c> fileShareCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
			fileShareCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			Database.insert(fileShareCustomSettingList);	   
		}
		
		 List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		 insert accounts;
		 
		 Account LegEntity = New Account();
		 LegEntity.Name = 'Legal Entity Account';
		 LegEntity.Active__c = true;
		 LegEntity.Type = 'Prospect';
		 LegEntity.Default_Legal_Entity__c = true;
		 LegEntity.ALCR_Record_Type__c = 'End Customer';
		 LegEntity.BillingCity= 'TestCity';
		 LegEntity.BillingCountry= 'Canada';
		 LegEntity.BillingStreet= 'TestStreet';
		 LegEntity.ParentId=accounts[0].id;
		 LegEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		 insert LegEntity;
		
		//Create Opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Indirect Sales Opportunity').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = LegEntity.id;
		opportunities[0].Legal_Entity__c= LegEntity.id;
		insert opportunities;  
		
		//create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
		  accreditations[0].partner__c = accounts[0].Id;
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[0].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Type__c = 'Product';
		accreditations[0].Accreditation_Level__c = 'Premium';
		accreditations[1].Accreditation_Level__c = 'Advanced';
		accreditations[0].Pricing_Level_Override__c = 'Premium';	 
		insert accreditations;
		
		//create a quote
		List<Apttus_Proposal__Proposal__c > QuoteList = NOKIA_CPQ_TestDataFactory.createProposal(1);
		QuoteList[0].Apttus_Proposal__Account__c = accounts[0].Id;
		QuoteList[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		QuoteList[0].NokiaCPQ_Needs_Reprice__c = false;
		QuoteList[0].Reprice_In_Progress__c = false;
		QuoteList[0].Apttus_Proposal__Approval_Stage__c = 'Approved';
		Database.Insert(QuoteList);
	
	   Test.StartTest(); 
	  
	   //ApexPages.currentPage().getParameters().put('recId', String.valueOf(QuoteList.Id[0]));
	   ApexPages.currentPage().getParameters().put('appName', 'CSPExportp20');
	   //ApexPages.currentPage().getParameters().put('appName', AllianceExport);
	   ApexPages.StandardController sc = new ApexPages.StandardController(QuoteList[0]);
	   ValidateCSPExportController testCtrl = new ValidateCSPExportController(sc);
	   testCtrl.validateProducts();
	   testCtrl.redirectToApp();
	   testCtrl.cancel();

	  Test.StopTest();
	  
	 }
}