@istest
public with sharing class NokiaCPQ_CreateQuote_Controller_Test{
  
	
		@isTest static void testGetOrgUrl(){
		  
			Test.startTest();
			String orgUrl = NokiaCPQ_CreateQuote_Controller.getOrgUrl();
			Test.stopTest();
		}
		@isTest static void testGetOpportunityFields(){
		  List<User> userList = new List<User>();
  userList = TestDataFactory.userCreation(1,'Data Loader Profile');

  System.runAs(userList[0]){
		
						List <Account> account3 = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	   account3[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	   account3[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	  account3[1].Partner_Type__c = '';
	   account3[1].Partner_Program__c = '';
	   insert account3;

	   Test.startTest();
	   List<Opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,account3);
	   opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	   opportunities1[0].StageName = 'Create Offer (Bid)';
	   opportunities1[0].Phase_Status__c = 'Offer in Progress';
	  opportunities1[0].End_Customer_LE__c = account3[1].id;
	  opportunities1[0].StageName='Create Offer (Bid)';
   opportunities1[0].Phase_Status__c='Submitted for G4 Approval';
   opportunities1[0].LOA_Level__c = '';
   opportunities1[0].No_Loa__c = false;
   opportunities1[0].Apttus_Approval__Approval_Status__c = 'Approved';
   opportunities1[0].Account_Role__c = 'GPP Distributor Partner';
   opportunities1[0].Business_Type__c = 'Standard Opportunity';
	  insert opportunities1;
	
	opportunities1[0].StageName = 'Create Offer (Bid)';
	   opportunities1[0].Phase_Status__c = 'Offer in Progress';
	  opportunities1[0].End_Customer_LE__c = account3[1].id;
	  opportunities1[0].StageName='Create Offer (Bid)';
   opportunities1[0].Phase_Status__c='Submitted for G4 Approval';
   opportunities1[0].LOA_Level__c = '';
   opportunities1[0].No_Loa__c = false;
   opportunities1[0].Apttus_Approval__Approval_Status__c = 'Approved';
   opportunities1[0].G2_Approval_Date__c = Date.Today();
   //opportunities1[0].G3_Approval_Date__c =  Date.Today();
   opportunities1[0].G3_Planned_Date__c =  Date.Today();
   //opportunities1[0].G4_Approval_Date__c =  Date.Today();
   opportunities1[0].G4_Planned_Date__c =  Date.Today();
   //opportunities1[0].G5_Submission_Date__c =  Date.Today();
   //opportunities1[0].G4_Planned_Date__c =  Date.Today();
   
   update opportunities1[0];
	List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
   accreditations[0].partner__c = account3[0].Id;
   accreditations[1].partner__c = account3[0].Id;
   accreditations[1].Accreditation_Type__c = 'Maintenance';
   accreditations[1].Accreditation_Level__c = 'Premium';
   accreditations[1].Pricing_Level_Override__c = 'Premium';   
   insert accreditations;

   Opportunity opportunityRecord = NokiaCPQ_CreateQuote_Controller.getOpportunityFields(opportunities1[0].ID);
   
   Opportunity opportunityRecord2 = NokiaCPQ_CreateQuote_Controller.getOpportunityFields('');
   Test.stopTest();
		}
}
		@isTest//(SeeAllData=true) 
		static void testCheckExistingContracts(){
		  List<User> userList = new List<User>();
  userList = TestDataFactory.userCreation(1,'Data Loader Profile');

  System.runAs(userList[0]){
			Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(),IsActive = true);
			update standardPricebook;

			List <Account> account3 = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	   account3[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	   account3[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	  account3[1].Partner_Type__c = '';
	   account3[1].Partner_Program__c = '';
	   insert account3;

	   Test.startTest();
	   List<Opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,account3);
	   opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	   opportunities1[0].StageName = 'Create Offer (Bid)';
	   opportunities1[0].Phase_Status__c = 'Offer in Progress';
	  opportunities1[0].End_Customer_LE__c = account3[1].id;
	  opportunities1[0].StageName='Create Offer (Bid)';
   opportunities1[0].Phase_Status__c='Submitted for G4 Approval';
   opportunities1[0].LOA_Level__c = '';
   opportunities1[0].No_Loa__c = false;
   opportunities1[0].Apttus_Approval__Approval_Status__c = 'Approved';
   opportunities1[0].Account_Role__c = 'GPP Distributor Partner';
	  opportunities1[0].Business_Type__c = 'Standard Opportunity';

	  insert opportunities1;
	
	opportunities1[0].StageName = 'Create Offer (Bid)';
	   opportunities1[0].Phase_Status__c = 'Offer in Progress';
	  opportunities1[0].End_Customer_LE__c = account3[1].id;
	  opportunities1[0].StageName='Create Offer (Bid)';
   opportunities1[0].Phase_Status__c='Submitted for G4 Approval';
   opportunities1[0].LOA_Level__c = '';
   opportunities1[0].No_Loa__c = false;
   opportunities1[0].Apttus_Approval__Approval_Status__c = 'Approved';
   opportunities1[0].G2_Approval_Date__c = Date.Today();
   //opportunities1[0].G3_Approval_Date__c =  Date.Today();
   opportunities1[0].G3_Planned_Date__c =  Date.Today();
   //opportunities1[0].G4_Approval_Date__c =  Date.Today();
   opportunities1[0].G4_Planned_Date__c =  Date.Today();
   //opportunities1[0].G5_Submission_Date__c =  Date.Today();
   //opportunities1[0].G4_Planned_Date__c =  Date.Today();
   opportunities1[0].pricebook2Id = standardPricebook.Id;
   update opportunities1[0];
	
  


   product2 prod = new product2();
	   prod.name = '5G';
	   prod.CurrencyIsoCode = 'USD';
	   prod.Business_Group__c = 'MN';
	   prod.Family = 'A&A-CEM';
	   prod.IsActive = True;
	   prod.Partner_Visible__c = True;
	   prod.ProductCode = 'FC11011';
	   prod.Apttus_Config2__Version__c = 1;
	   prod.Portfolio__c = 'Airscale Wifi';
	   prod.Created_by_PMDI__c = False;
	   prod.Pricing_Clusters__c = 'NAM';
	   prod.IsActive = True;
	   prod.CH_Business_Unit__c = 'MN SRAN';
	   insert prod;

	   PricebookEntry priceBookEntry = new PricebookEntry(Pricebook2Id=standardPricebook.Id,Product2Id=prod.Id,UnitPrice=3.0,IsActive=true);
	   insert priceBookEntry;
   Id recId = Schema.SObjectType.ServiceContract.getRecordTypeInfosByDeveloperName().get('CH_ServiceContract').getRecordTypeId();
   ServiceContract contractRecord = new ServiceContract(Name='TestServiceContract',Pricebook2Id=standardPricebook.Id,RecordTypeId=recId,AccountId=opportunities1[0].End_Customer_LE__c,NCP_External_Status__c = 'Active');
   insert contractRecord;
   ContractLineItem contractLineRecord = new ContractLineItem(ServiceContractId=contractRecord.Id,PricebookEntryId=priceBookEntry.Id,Quantity=1,UnitPrice=3.0);
   insert contractLineRecord;
			NokiaCPQ_CreateQuote_Controller.checkExistingContracts(opportunities1[0].End_Customer_LE__c,new List<String>{'IP Routing'});
			Test.stopTest();

		}
}
		@isTest static void testCreateQuoteRecord(){
  List<User> userList = new List<User>();
  userList = TestDataFactory.userCreation(1,'Data Loader Profile');

  System.runAs(userList[0]){

			List <Account> account3 = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	   account3[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	   account3[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	  account3[1].Partner_Type__c = '';
	   account3[1].Partner_Program__c = '';
	   insert account3;
	   List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
   accreditations[0].partner__c = account3[0].Id;
   accreditations[1].partner__c = account3[0].Id;
   accreditations[1].Accreditation_Type__c = 'Maintenance';
   accreditations[1].Portfolio__c = 'IP Routing';
   accreditations[1].Accreditation_Level__c = 'Premium';
   accreditations[1].Pricing_Level_Override__c = 'Premium';   
   insert accreditations;

	   
	   List<Opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,account3);
	   opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	   opportunities1[0].StageName = 'Create Offer (Bid)';
	   opportunities1[0].Phase_Status__c = 'Offer in Progress';
	  opportunities1[0].End_Customer_LE__c = account3[1].id;
	  opportunities1[0].StageName='Create Offer (Bid)';
   opportunities1[0].Phase_Status__c='Submitted for G4 Approval';
   opportunities1[0].LOA_Level__c = '';
   opportunities1[0].No_Loa__c = false;
   opportunities1[0].Apttus_Approval__Approval_Status__c = 'Approved';
   opportunities1[0].Account_Role__c = 'GPP Distributor Partner';
	  opportunities1[0].Business_Type__c = 'Standard Opportunity';

	  insert opportunities1;
	  Test.startTest();
	opportunities1[0].StageName = 'Create Offer (Bid)';
	   opportunities1[0].Phase_Status__c = 'Offer in Progress';
	  opportunities1[0].End_Customer_LE__c = account3[1].id;
	  opportunities1[0].StageName='Create Offer (Bid)';
   opportunities1[0].Phase_Status__c='Submitted for G4 Approval';
   opportunities1[0].LOA_Level__c = '';
   opportunities1[0].No_Loa__c = false;
   opportunities1[0].Apttus_Approval__Approval_Status__c = 'Approved';
   opportunities1[0].G2_Approval_Date__c = Date.Today();
   //opportunities1[0].G3_Approval_Date__c =  Date.Today();
   opportunities1[0].G3_Planned_Date__c =  Date.Today();
   //opportunities1[0].G4_Approval_Date__c =  Date.Today();
   opportunities1[0].G4_Planned_Date__c =  Date.Today();
   //opportunities1[0].G5_Submission_Date__c =  Date.Today();
   //opportunities1[0].G4_Planned_Date__c =  Date.Today();
   //opportunities1[0].pricebook2Id = standardPricebook.Id;
   update opportunities1[0];
   //Modify createQuoteRecord params to pass in JSON serialized string here.

   List<String> subportfolios = NokiaCPQ_CreateQuote_Controller.getSubPortfolios('IP Routing',account3[0].Id);

   NokiaCPQ_CreateQuote_Controller.ProposalDataContainer serializedObject = new NokiaCPQ_CreateQuote_Controller.ProposalDataContainer();
   
   serializedObject.Name='Test Quote';
   serializedObject.OppId=opportunities1[0].Id;
   serializedObject.warrantyCredit='';
   serializedObject.contractDate='';
   serializedObject.sysContract=false;
   serializedObject.AccId=account3[0].Id;
   serializedObject.Description='Test Description';
   serializedObject.isMaintenance=false;
   serializedObject.leo=false;
   serializedObject.Portfolio='IP Routing';
   serializedObject.subportfolios=String.join(subportfolios, ';');
   serializedObject.quoteEMT='No';
   serializedObject.currencyCode='USD';

   String serializedString = System.JSON.serialize(serializedObject);
   

   Apttus_Proposal__Proposal__c testProposalRecord = NokiaCPQ_CreateQuote_Controller.createQuoteRecord(serializedString);

   serializedObject.warrantyCredit='Yes';
   serializedObject.contractDate=String.valueOf(Date.today());
   serializedObject.isMaintenance=true;

   serializedString = System.JSON.serialize(serializedObject);
   
   Apttus_Proposal__Proposal__c testProposalRecord2 = NokiaCPQ_CreateQuote_Controller.createQuoteRecord(serializedString);
   String recordTypes = NokiaCPQ_CreateQuote_Controller.getRecordType();
   
   
   Test.stopTest();

		}}

	}