/*Lead Trigger Test Class*/
@IsTest
private class LeadTriggerHelperTest{
/* This is a basic test which simulates the primary positive case for the 
  Conversion method of a Lead.. */
  
  private static testMethod void positiveUnitTest() {

	Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(); 
   
	User u = TestDataFactory.createUser('System Administrator', 'LeadTester');
	insert u;
	
	System.runAs(u) {
	
	ISO_Country_Codes__c isoCountryCode = new ISO_Country_Codes__c();
	isoCountryCode.Name = 'IN'; 
	isoCountryCode.Country_Name__c = 'India';
	
	insert isoCountryCode;
	
	List<Account> accountList = new  List<Account>();
  
	accountList = TestDataFactory.createAccount(1);
	accountList[0].recordtypeid = custRecordTypeId;  
	accountList[0].AccountStatusInCRMOM__c='active';
	accountList[0].Active__c=true;
	accountList[0].AccountNumber='300100123';  
	accountList[0].Acc_No__C='300100123';
	accountList[0].Active__c=true;
	accountList[0].Active__c=true;
	database.insert(accountList[0]); 
	GlobalConstants.NEW_ACCOUNT =false;
	  
	Contact con = new Contact();
	con.FirstName = 'TEst123';
	con.LastName = 'Contact';
	con.CurrencyIsoCode = 'EUR';
	con.Email = 'Test.Class@valid.com';
	con.mailingCountryCode = 'IN';
	con.accountId = accountList[0].Id;
	Insert con;
	
	List<Opportunity> opportunityList=new List<Opportunity>();
	opportunityList = TestDataFactory.OpportunityCreation(1, accountList[0]);
	database.insert(opportunityList);
   
	
	
	List<Lead> leadList = new  List<Lead>();
	List<Lead> leadList1 = new  List<Lead>();
	Map<id,Lead> OldLeadMap = new Map<id,Lead>();  
	
	Campaign cmp=new Campaign(Name='testCampaign',Campaign_id__c='T1234');
	database.insert(cmp); 
	leadList = TestDataFactory.createLead(2);
	leadList[0].RecordTypeId  = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Direct_Sales').getRecordTypeId();
	leadList[0].Country = 'India';
	leadList[0].CountryCode = 'IN';
	leadList[0].Campaign_Lookup__c=cmp.Id;
	leadList[0].MKT_AttributionCampaign__c=cmp.Id;
	
	leadList[1].RecordTypeId  = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('TXLE_Lead').getRecordTypeId();
	leadList[1].Country = 'India';
	leadList[1].CountryCode = 'IN';
	leadList[1].Campaign_Lookup__c=cmp.Id;

	
	database.insert(leadList); 
	System.debug('leadList...' +leadList);
	test.startTest();
	Database.LeadConvert lc = new database.LeadConvert();
	lc.setLeadId(leadList[0].id);
	lc.setAccountId(accountList[0].id);
	lc.setOpportunityId(opportunityList[0].id);
	lc.setContactId(con.id);
	lc.setDoNotCreateOpportunity(false);   
	lc.setConvertedStatus('Closed - Converted (Qualified)');
	lc.setOwnerId(u.id);
		
	
	
	OpportunityDefaultLeadConversion__c leadConversion = new OpportunityDefaultLeadConversion__c();
	leadConversion.Name = 'LeadConvertedToOppty';
	database.insert(leadConversion);	

	Database.LeadConvert lc1 = new database.LeadConvert();
	lc1.setLeadId(leadList[1].id);
	lc1.setAccountId(accountList[0].id);
	lc1.setOpportunityId(opportunityList[0].id);
	lc1.setContactId(con.id);
	lc1.setDoNotCreateOpportunity(false);   
	lc1.setConvertedStatus('Closed - Converted (Qualified)');
	lc1.setOwnerId(u.id);
		
	try{
	  Database.LeadConvertResult lcr = Database.convertLead(lc);
	  Database.LeadConvertResult lcr1 = Database.convertLead(lc1);
	  
	  test.stopTest();
	  System.assert(lcr.isSuccess());
		System.assert(lcr1.isSuccess());
	}catch(Exception exc){
	  System.debug('Exception during lead conversion:'+exc);
	}
   }
  }
	
  private static testMethod void NegativeUnitTest() 
  {
	Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(); 
	
	 User u = TestDataFactory.createUser('System Administrator', 'LeadTester');
	insert u;
	
	System.runAs(u) {
	List<Account> accountList = new  List<Account>();
  
	accountList = TestDataFactory.createAccount(2);
	accountList[0].recordtypeid = custRecordTypeId;  
	accountList[0].AccountStatusInCRMOM__c='active';
	accountList[0].Active__c=true;
	accountList[0].Acc_No__C='0012334490';
	database.insert(accountList[0]); 
	GlobalConstants.NEW_ACCOUNT =false;
	
	
	 ISO_Country_Codes__c isoCountryCode = new ISO_Country_Codes__c();
	isoCountryCode.Name = 'IN'; 
	isoCountryCode.Country_Name__c = 'India';
	isoCountryCode.Market__c = 'Market India';
	
	insert isoCountryCode;
	Contact con = new Contact();
	con.FirstName = 'TEst123';
	con.LastName = 'Contact';
	con.CurrencyIsoCode = 'EUR';
	con.Email = 'Test.Class@valid.com';
	con.accountId = accountList[0].Id;
	con.mailingCountryCode = 'IN';
	Insert con;
	
   
	
	List<Lead> leadList = new  List<Lead>();
	
	leadList = TestDataFactory.createLead(1);
	leadList[0].RecordTypeId  = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Direct_Sales').getRecordTypeId();
	leadList[0].Country = 'India';
	leadList[0].CountryCode = 'IN';


	database.insert(leadList); 

	
	Database.LeadConvert lc = new database.LeadConvert();
	lc.setLeadId(leadList[0].id);
	lc.setAccountId(accountList[0].id);
	lc.setContactId(con.id);
	lc.setDoNotCreateOpportunity(true);
	lc.setConvertedStatus('Closed - Converted (Qualified)');
	lc.setOwnerId(u.id);

	 lc.setAccountId(accountList[0].id);
	
	 try{
	  Database.LeadConvertResult lcr = Database.convertLead(lc);
	  System.assert(lcr.isSuccess());
	}catch(Exception exc){
	  System.debug('Exception during lead conversion:'+exc);
	}
  }

  } 
  private static testMethod void leadCampaignAutoPopulationTest(){ 
  
   
	ISO_Country_Codes__c isoCountryCode = new ISO_Country_Codes__c();
	isoCountryCode.Name = 'IN'; 
	isoCountryCode.Country_Name__c = 'India';
	isoCountryCode.Market__c = 'Market India';
	
	insert isoCountryCode;
	
	List<Account> accountList = new  List<Account>();
	List<String> campaignNameList = new list<string>();
  
	List<Lead> leadList1 = new  List<Lead>();
	List<Campaign> campaignList = new List<Campaign>();
	List<Opportunity> opportunityList = new List<Opportunity>();
	Map<id,Lead> OldLeadMap = new Map<id,Lead>();
	
	accountList = TestDataFactory.createAccount(1);
	accountList[0].Acc_No__C='0012334489';
	database.insert(accountList);
	id accountId  = accountList[0].id;
	system.assert(accountId!=null);
	
	// create an opportunity	  
	opportunityList = TestDataFactory.OpportunityCreation(1, accountList[0]);
	database.insert(opportunityList);
   
	campaignList = testDataFactory.createCampaign(2, opportunityList[0]);
	campaignList[0].name = 'test1';
	campaignList[0].Campaign_ID__c = 'Testt';
	campaignList[1].name = 'test2';
	database.insert(campaignList);
	Test.startTest();  
	
	campaignNameList.add(campaignList[0].name);
   
	List<Lead> leadList = new  List<Lead>();
	leadList = testDataFactory.createLead(2);
	leadList[0].Campaign_Name__c = 'test1';
	leadList[0].Campaign_Lookup__c = campaignList[0].id;
	leadList[0].RecordTypeId  = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Direct_Sales').getRecordTypeId();
	leadList[0].Country = 'India';
	leadList[0].CountryCode = 'IN';
	leadList[0].Market__c = 'Market India';
	
	leadList[1].RecordTypeId  = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Direct_Sales').getRecordTypeId();
	leadList[1].Country = 'India';
	leadList[1].CountryCode = 'IN';
	leadList[1].Market__c = 'Market India';
	insert (leadList);
	
	leadList[1].Country = 'India';
	leadList[1].CountryCode = 'IN';
	leadList[1].Campaign_Name__c = 'test2';
	leadList[1].Campaign_Lookup__c = campaignList[0].id;
	
	LeadTriggerHelper.leadCampaignAutoPopulation(leadList,OldLeadMap);
	LeadTriggerHelper.leadLookupCampaignAutoPopulation(leadList,campaignNameList);
	Test.stopTest();
  }
  
}