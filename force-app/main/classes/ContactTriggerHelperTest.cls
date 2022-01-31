@isTest
private class ContactTriggerHelperTest{   
	@testSetup static void methodName(){		
		Test.startTest();		
			Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
			FALU_VZW_Sync__c faluSetting = new FALU_VZW_Sync__c();
			faluSetting.Name = 'fALU';
			faluSetting.ClientSecret__c= '7414142230715732933';
			faluSetting.fALU_Account_SFDC_ID__c= '0016300000MJCcj';
			faluSetting.Password__c= 'castlereagh#1';
			faluSetting.SCRM_Customer_Number__c= '301001643';
			faluSetting.Username__c= 'vishal.d.taware@prodfix.com';
			faluSetting.SecurityToken__c= 'GnLqVBxTIClISkJaH9To2QOsI';
			faluSetting.ClientId__c= '3MVG9GnaLrwG9TQQ98zA8VMw2JAXVPDZ11tYXB0WFiVhW8A35CN_QvcZ_KQu4e8RPBxF3q5Z5hoo4K60cX1FU';
			insert faluSetting ;
			
			InvalidEmailDomain__c invalidDomain = new InvalidEmailDomain__c();
			invalidDomain.Domain__c = 'nokia,invalid';
			insert invalidDomain;
			
			Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(); 
			Account acc = new Account();
			acc.Name = 'Test Account';
			acc.AccountNumber = '301001643';
			acc.recordtypeid = custRecordTypeId ;
			insert acc;
			
			Contact con = new Contact();
			con.FirstName = 'Showket';
			con.LastName = 'Bhat';
			con.CurrencyIsoCode = 'EUR';
			con.Phone = '1234234534';
			con.Market__c = 'Market India';
			con.CH_PreferredMtdOfServiceCommunication__c = 'Email';
			con.CH_ContactTimeZone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
			con.Email = 'showket.bhat@accenture.com';
			con.CH_ContactType__c = 'Customer';
			con.accountId = acc.Id;
			Insert con;		
		Test.stopTest();
	}
	
	static testMethod void UnitTest1(){
		// Set mock callout class 
		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());		
		Test.startTest();
	SendContactUsingRESTAPI.callUpdateContact('https://alcatel-lucent--ALUProdFix.cs43.my.salesforce.com','0036300000I8xPlAAJ','Vishal','Taware','vishal.d.taware@asd.com','0016300000MJCcj','00D630000009Cym!AQwAQEQVeApaNxQkTsxPqliYux5Ur.8qxPX94GkOo2tf2Z4Brz4AikJ2qbJG.iqNtF8ZUaQdZKyzuXpvWRgwAqtfnCWgUR6Z');
		Test.stopTest();		
	}
	
	static testMethod void UnitTest2(){
		Test.startTest();
		List<Contact> contactList = [SELECT Id, FirstName, LastName, Email from Contact];
		
		// Set mock callout class 
		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		
		ContactTriggerHelper.validateAndSendContact(contactList); 
		// Call method to test.
		// This causes a fake response to be sent
		// from the class that implements HttpCalloutMock. 
		Map<Id, Contact> conIdVsContactMap = new Map<Id, Contact>();
		for(Integer i = 0; i< contactList.size(); i++){
			conIdVsContactMap.put(contactList[i].Id, contactList[i]);
		}		
		ContactTriggerHelper.validateAndSendContactforUpdate(contactList, conIdVsContactMap);
		
		// Set mock callout class 
		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		ContactTriggerHelper.validateAndSendContact(contactList); 
		ContactTriggerHelper.validateAndSendContactforUpdate(contactList, conIdVsContactMap);
		
		Test.stopTest();
	}
	
	static testMethod void UnitTest3(){
		List<Contact> contactList = [SELECT Id, FirstName, LastName, Email from Contact];		
		contactList[0].FirstName = 'Jon';
		database.update(contactList[0]);
		// Set mock callout class 
		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		
		ContactTriggerHelper.validateAndSendContact(contactList);  
		Map<Id, Contact> conIdVsContactMap = new Map<Id, Contact>();
		for(Integer i = 0; i< contactList.size(); i++){
			conIdVsContactMap.put(contactList[i].Id, contactList[i]);
		}		
		ContactTriggerHelper.validateAndSendContactforUpdate(contactList, conIdVsContactMap);
	}
		
	static testMethod void UnitTest4(){	
		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		Contact updateContact = [select id, Email from contact limit 1 ];
		updateContact.CH_ContactType__c = 'Customer';
		updateContact.Email = 'showket.bhat@invalid.com';
		Test.startTest();
		Try{
			update updateContact;
		}catch(Exception e){
			Boolean expectedExceptionThrown =  e.getMessage().contains('The Email field contains invalid domain') ? true : false;
			//System.AssertEquals(expectedExceptionThrown, true);
		} 
		Test.stopTest();
	}
	
	static testMethod void NegativeTest(){
		ContactTriggerHelper.validateAndSendContact(NULL);  
		ContactTriggerHelper.validateAndSendContactforUpdate(NULL, NULL);
		// ContactTriggerHelper.validateBlacklistedMailDomains(NULL);		
	}
	
	static testMethod void UnitTest5(){		
		ISO_Country_Codes__c iso = new ISO_Country_Codes__c();
		iso.Name='IN';   
		iso.Market__c='Market India';
		iso.Country_Name__c='India';
		insert iso;
		
		List<Account> accountList = new  List<Account>();
		accountList = TestDataFactory.createAccount(2);
		
		List<Contact> ConList = new  List<Contact>();
		Contact con = new Contact();
		con.FirstName = 'John';
		con.LastName = 'Doe';
		con.CurrencyIsoCode = 'EUR';
		con.Phone = '1234234534';
		con.Market__c = 'Market India';
		con.CH_PreferredMtdOfServiceCommunication__c = 'Email';
		con.CH_ContactTimeZone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
		con.Email = 'abc@accenture.com';
		con.MailingCountryCode=NULL;
		con.MailingCountry='India';
		con.MailingState='Maharashtra';
		con.CH_ContactType__c = 'Customer';
		con.accountId = accountList[0].Id;
		ConList.add(con);
		database.insert(ConList);
		
		Test.startTest();		 
	//ContactTriggerHandler.beforeOperation(ConList);	
		Test.stopTest();
		//database.update(ConList);
	}
	static testMethod void UnitTest6(){		
		ISO_Country_Codes__c iso = new ISO_Country_Codes__c();
		iso.Name='IN';   
		iso.Market__c='Market India';		
		insert iso;
		
		List<Account> accountList = new  List<Account>();
		accountList = TestDataFactory.createAccount(2);
		
		List<Contact> ConList = new  List<Contact>();
		Contact con = new Contact();
		con.FirstName = 'John';
		con.LastName = 'Doe';	  
		con.CurrencyIsoCode = 'EUR';  
		con.Email = 'abc@accenture.com';
		con.accountId = accountList[0].Id;
		con.MailingCountryCode=NULL;
		con.MailingCountry='India';
		con.MailingState='Maharashtra';
		con.Market__c='Market Europe';
		con.CH_ContactType__c = 'Customer';
		ConList.add(con);
		try{
			database.insert(ConList);
		}catch(exception exc){
			system.debug('exception exc.....'+exc);
		}		
		Test.startTest();		
	//ContactTriggerHandler.beforeOperation(ConList);		
		Test.stopTest();
		//database.update(ConList);
	}
  
  private static testMethod void contactCampaignAutoPopulation(){
		
		List<String> campaignNameList = new list<string>();	 
		List<Account> accountList = new  List<Account>();
		List<Contact> contactList = new List<Contact>();
		List<Contact> contactList1 = new List<Contact>();
		List<Campaign> campaignList = new List<Campaign>();
		List<Opportunity> opportunityList = new List<Opportunity>();
		Map<id,Contact> OldContactMap = new Map<id,Contact>();
		
		Account acc = [select id ,Name from account];
	
		accountList = TestDataFactory.createAccount(1);   
		database.insert(accountList);	
		id accountId  = accountList[0].id;	 
		system.assert(accountId!=null);
		
		opportunityList = TestDataFactory.OpportunityCreation(1, accountList[0]);			
		database.insert(opportunityList);
		
		campaignList = testDataFactory.createCampaign(2, opportunityList[0]);
		campaignList[0].name = 'test1';	
		campaignList[0].campaign_Id__c = 'T101';	
		campaignList[1].campaign_Id__c = 'T102';		
		campaignList[1].name = 'test2';
		database.insert(campaignList);  
		Test.startTest();   
		campaignNameList.add(campaignList[0].name);
		
		Contact con = new Contact();			
		con.FirstName = 'John';			
		con.LastName = 'Doe';
		con.Campaign_Name__c = 'test1';
		con.Marketing_Campaign__c = campaignList[0].id;
		insert(con);
		
		
		ContactTriggerHelper.contactCampaignAutoPopulation(contactList,OldContactMap);
		ContactTriggerHelper.contactLookupCampaignAutoPopulation(contactList,campaignNameList);
		Test.stopTest();
	} 
		static testMethod void testBypassDuplicateRuleValidation(){
			Test.startTest();
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		accountCreation.AccountNumber = '1234'; 
		database.insert(accountCreation);

		Contact c = new Contact();
		c.AccountId=accountCreation.ID;
		c.LastName='testcontact';
		c.Email='testcontact@test.com';
		c.CH_ContactType__c='Customer';
		insert c;
			List<Contact> contactList = new List<Contact>();
			contactList.add(c);
			ContactTriggerHelper.validateBlacklistedMailDomains(contactList);
			Test.stopTest();
		/*
		Lead le= new Lead();
		le.FirstName = 'test 1235';
		le.lastName= '123r512';
		le.Phone='12321244';
		le.Email='test123221@123.com';
		le.RecordTypeId=Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Direct Sales').getRecordTypeId();
		le.Market__c='Market North America';
		le.Country='Canada';
		le.Company='letd';
		le.Status='Working - Contacted';
		insert le;
		List<Account> accountList = new  List<Account>();
		accountList = TestDataFactory.createAccount(1);   
		database.insert(accountList);	
		id accountId  = accountList[0].id; 
		Test.startTest();
		Database.LeadConvert lc = new Database.LeadConvert(); 
		lc.setLeadId(le.id); 
		
		lc.setAccountId(accountId);
		lc.setConvertedStatus('Closed - Converted (Qualified)'); 
		Database.LeadConvertResult lcr = Database.convertLead(lc); 
		Test.stopTest();
		*/
	} 
	static testMethod void contactMatchIndustryWithLeadTest(){
		Test.startTest();   
		List<Contact> contactList = new List<Contact>();
		List<Lead> leadList = new List<Lead>();
		List<Account> accountList = new List<Account>();
		accountList = TestDataFactory.createAccount(1);
		insert accountList;

		leadList = TestDataFactory.createLead(10);
		for(Lead tempLead:leadList){
			tempLead.Country = 'China';
			tempLead.Market__c = 'Market Greater China';
			tempLead.Industry = 'Education';
			tempLead.Business_Type__C = 'Enterprise';
		}
		insert leadList;
		contactList = TestDataFactory.createContact(10,accountList[0]);

		for(Integer i=0;i<10;i++){
			contactList[i].Lead_ID__c = leadList[i].Lead_ID__C;
			contactList[i].LastName = 'test'+i;
		}
		insert contactList;
		ContactTriggerHelper.contactMatchIndustryWithLead(NULL);
		Test.stopTest();
	}
}