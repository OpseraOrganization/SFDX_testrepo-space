/*Lead Trigger Test Class*/
@IsTest (SeeAllData=true)
private class LeadTriggerHelperTest{
/* This is a basic test which simulates the primary positive case for the 
	   Conversion method of a Lead.. */
	
	private static testMethod void positiveUnitTest() {
		
		Contact cont = [select id,accountId from Contact where Accountid <> NULL and account.Active__c=true and account.AccountStatusInCRMOM__c ='Active' limit 1];
		
		//for(Account newAccount : [select Id,name,active__c,recordtype.name,AccountStatusInCRMOM__c from account 
		//where Id IN : convertedAccountIdVsLeadMap.keySet() LIMIT: convertedAccountIdVsLeadMap.keySet().size()])
		
		Account acc = [select id from account where Id =: cont.accountId limit 1];

		Opportunity opty = [select id from opportunity limit 1];
		
		User usr = [Select Id, profile.name,ProfileId from User where IsActive=True  and profileId IN (select Id from Profile where name='System Administrator') limit 1];
		
	   // Campaign cmp = [select Id,name from campaign where name =: leadToCampaignNameMap.Values()];
		
		ISO_Country_Codes__c isoCountryCode = new ISO_Country_Codes__c();
		isoCountryCode.Name = 'IN'; 
		isoCountryCode.Country_Name__c = 'India';
		//isoCountryCode.Market__c = 'Market India';
		// database.insert(isoCountryCode); 
		
		
		List<Lead> leadList = new  List<Lead>();
		List<Lead> leadList1 = new  List<Lead>();
		Map<id,Lead> OldLeadMap = new Map<id,Lead>();  
		
		leadList = TestDataFactory.createLead(1);
		leadList[0].RecordTypeId  = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Direct Sales').getRecordTypeId();
		leadList[0].Country = 'India';
		leadList[0].CountryCode = 'IN';
		leadList[0].IsConverted = true;
		leadList[0].ConvertedAccountId = acc.id;
		leadList[0].convertedContactId = cont.id;
		leadList[0].convertedOpportunityId = opty.id;
		
		
		database.insert(leadList); 
		System.debug('leadList...' +leadList);
		Database.LeadConvert lc = new database.LeadConvert();
		lc.setLeadId(leadList[0].id);
		lc.setDoNotCreateOpportunity(false);
		
		lc.setConvertedStatus('Closed - Converted (Qualified)');
		lc.setOwnerId(usr.Id);
		
		OpportunityDefaultLeadConversion__c leadConversion = new OpportunityDefaultLeadConversion__c();
		leadConversion.Name = 'LeadConvertedToOppty';
		database.insert(leadConversion);	  
				
		lc.setAccountId(acc.id);
			
		System.debug('Lead Convert : '+lc);
		System.debug('Lead Convert Lead: '+leadList);
		System.debug('Lead Convert account: '+acc );
		try{
			Database.LeadConvertResult lcr = Database.convertLead(lc);
			System.assert(lcr.isSuccess());
		}catch(Exception exc){
			System.debug('Exception during lead conversion:'+exc);
		}
		//Exception Creation
		
		
		//List<String> mynames = new List<String>();
		//mynames.add(acc.Name);
		

		
		LeadTriggerHelper.leadConversionValidations(leadList);
		LeadTriggerHelper.addOppDefaultValues(leadList);
		LeadTriggerHelper.OverrideContactFields(leadList );
		LeadTriggerHelper.OverrideContactFields(leadList );
		LeadTriggerHelper.leadConversionValidations(leadList);
		//LeadTriggerHelper.leadLookupCampaignAutoPopulation(leadList);
	}
	private static testMethod void NegativeUnitTest() 
	{
		Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(); 
		User usr = [Select Id, profile.name,ProfileId from User where IsActive=True  and profileId IN (select Id from Profile where name='System Administrator') limit 1];
		List<Account> accountList = new  List<Account>();
				
		accountList = TestDataFactory.createAccount(2);
		accountList[0].recordtypeid = custRecordTypeId;  
		accountList[0].AccountStatusInCRMOM__c='active';
		accountList[0].Active__c=true;
		database.insert(accountList[0]); 
		GlobalConstants.NEW_ACCOUNT =false;
		
		Contact con = new Contact();
		con.FirstName = 'TEst123';
		con.LastName = 'Contact';
		con.CurrencyIsoCode = 'EUR';
		con.Email = 'Test.Class@valid.com';
		con.accountId = accountList[0].Id;
		Insert con;
		
		ISO_Country_Codes__c isoCountryCode = new ISO_Country_Codes__c();
		isoCountryCode.Name = 'IN'; 
		isoCountryCode.Country_Name__c = 'India';
		isoCountryCode.Market__c = 'Market India';
		
		List<Lead> leadList = new  List<Lead>();
		
		leadList = TestDataFactory.createLead(1);
		leadList[0].RecordTypeId  = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Direct Sales').getRecordTypeId();
		leadList[0].Country = 'India';
		leadList[0].CountryCode = 'IN';
		leadList[0].IsConverted = true;
		leadList[0].ConvertedAccountId = accountList[0].id;
		leadList[0].convertedContactId = con.id;
		//leadList[0].convertedOpportunityId = lstOpty[0].id;

		database.insert(leadList); 
		System.debug('leadList...' +leadList);
		
		Database.LeadConvert lc = new database.LeadConvert();
		lc.setLeadId(leadList[0].id);
		lc.setDoNotCreateOpportunity(true);
		lc.setConvertedStatus('Closed - Converted (Qualified)');
		lc.setOwnerId(usr.Id);

		 lc.setAccountId(accountList[0].id);
		
		 try{
			Database.LeadConvertResult lcr = Database.convertLead(lc);
			System.assert(lcr.isSuccess());
		}catch(Exception exc){
			System.debug('Exception during lead conversion:'+exc);
		}
		  LeadTriggerHelper.leadConversionValidations(null);
		  LeadTriggerHelper.leadConversionValidations(leadList);


	}
	
	private static testMethod void leadCampaignAutoPopulationTest(){ 
		List<Account> accountList = new  List<Account>();
		List<String> campaignNameList = new list<string>();
	   
		List<Lead> leadList1 = new  List<Lead>();
		List<Campaign> campaignList = new List<Campaign>();
		List<Opportunity> opportunityList = new List<Opportunity>();
		Map<id,Lead> OldLeadMap = new Map<id,Lead>();
		
		accountList = TestDataFactory.createAccount(1);
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
		
		ISO_Country_Codes__c isoCountryCode = new ISO_Country_Codes__c();
		isoCountryCode.Name = 'IN'; 
		isoCountryCode.Country_Name__c = 'India';
		isoCountryCode.Market__c = 'Market India';
		
		List<Lead> leadList = new  List<Lead>();
		leadList = testDataFactory.createLead(2);
		leadList[0].Campaign_Name__c = 'test1';
		leadList[0].Campaign_Lookup__c = campaignList[0].id;
		leadList[0].RecordTypeId  = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Direct Sales').getRecordTypeId();
		leadList[0].Country = 'India';
		leadList[0].CountryCode = 'IN';
		leadList[0].Market__c = 'Market India';
		
		leadList[1].RecordTypeId  = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Direct Sales').getRecordTypeId();
		leadList[1].Country = 'India';
		leadList[1].CountryCode = 'IN';
		leadList[1].Market__c = 'Market India';
		insert (leadList);
		
		leadList[1].Country = 'India';
		leadList[1].CountryCode = 'IN';
		leadList[1].Campaign_Name__c = 'test2';
		leadList[1].Campaign_Lookup__c = campaignList[0].id;
		//update (leadList);
		
		LeadTriggerHelper.leadCampaignAutoPopulation(leadList,OldLeadMap);
		LeadTriggerHelper.leadLookupCampaignAutoPopulation(leadList,campaignNameList);
		Test.stopTest();
	}
	
}