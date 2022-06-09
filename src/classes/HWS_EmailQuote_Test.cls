/********************************************************************************
* Name : HWS_EmailQuote_Test 
* Description : Test class for HWS_EmailQuote

********************************************************************************/
@isTest
Public class HWS_EmailQuote_Test {
	
	@testSetup
	Public Static void createTestData(){ 
		HWS_GenericSettings__c cs = new HWS_GenericSettings__c();
		cs.Name='OrderedProcessingSize';
		cs.HWS_Field1__c = '25' ;
		insert cs;
		insert new Global_Control__c(ObjectTriggerByPass__c='Asset,ACCT,CNTCT,ACC_CNTCT_REL,USER,SVCNTRT,ASSET,PRODUCT,CLI,ENT,ACCT, CNTCT, Product,cli,PROD2');
		
		Id accountRecordType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LOGISTIC_ACCOUNT_EXISTING);
		Id legalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		Id childcase = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Child_Case_Read_Only);
		Id parentCaseRecordType = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Parent_Case);
		Id CusAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.CUSTOMER);
		
		Account acc = HWS_DataFactory_TEST.insertAccount();
		acc.name='test1';
		acc.Customer_Compliance__c ='US_Govern';
		insert acc;
		Account legalAcc = HWS_DataFactory_TEST.insertAccount(); 
		legalAcc.RecordTypeId =  legalEntityAccountType;
		legalAcc.ParentId = Acc.Id;
		legalAcc.Type = 'Vendor';
		insert legalAcc;
		Account accCustomer = HWS_DataFactory_TEST.insertAccount(); 
		accCustomer.RecordTypeId =  CusAccountType; 
		insert accCustomer;
		Account acc1 = new Account();
		acc1.Name = 'Testing RMANUMBER FIELD';
		acc1.ParentId = Acc.Id;
		acc1.Logistic_Account_Type__c = 'Bill-To';
		acc1.ngERP__c = '1';
		acc1.BillingCountry = 'India';
		acc1.BillingStreet = 'Gachibowli, Gachibowli';
		acc1.BillingCity = 'Hyderabad';
		acc1.BillingPostalCode = '500071';
		acc1.BillingState = 'TELANGANA';
		acc1.Market__c = 'Market India';
		acc1.RecordTypeId = accountRecordType;
		insert acc1;
		
		Contact con1 = HWS_DataFactory_TEST.insertContact();
		con1.AccountId = accCustomer.Id;
		con1.Contact_Status__c = 'Active';
		con1.CH_ContactType__c = 'Customer';
		con1.email='testemai2@test1.com';
		con1.AssistantName = 'Portal Contact';
		insert con1;
		HWS_DataFactory_TEST.createPortalUsers();
		//insert parent case																		   
		Case parentCase = new Case();
		parentCase.RecordTypeId = parentCaseRecordType;
		parentCase.AccountId = legalAcc.Id;
		parentCase.Hws_Ship_to_Party_Address__c= acc1.Id;
		parentCase.Status='Closed';
		parentCase.Subject='Test Subject';
		parentCase.Description='test Description';
		parentCase.HWS_ShipTopartyId__c='1234566';
		parentCase.Describe__c = 'Test description3';
		parentCase.Country__c ='United States of America';						   
		insert parentCase;
		//insert child case
		Case chldCase = new Case();
		chldCase.RecordTypeId = childcase;
		chldCase.ParentId = parentCase.Id;
		chldCase.AccountId = legalAcc.Id;
		chldCase.Hws_Ship_to_Party_Address__c= acc1.Id;
		chldCase.HWS_Faulty_Serial_Number__c = '1234'; 
		chldCase.HWS_FaultyUnitMaterialCode__c = '4567';
		chldCase.HWS_Shippeddate__c= system.today();
		chldCase.HWS_LSP_Courier_Name__c = 'Test123';
		chldCase.HWS_TotalShippedQuantity__c = 1234;
		chldCase.Describe__c = 'Test description';
		chldCase.HWS_Bar_Code__c = 'Test data111';
		chldCase.HWS_Bar_Code_Ref1__c = HWS_Constants.Test123;							   
		insert chldCase;
		
		User queueUser = new User();
		queueUser.alias = 'CHQueueU';
		queueUser.email = 'testgmail1@mail.com';
		queueUser.emailencodingkey = 'UTF-8';
		queueUser.lastname = 'CH Queue';
		queueUser.languagelocalekey = 'en_US';
		queueUser.localesidkey = 'en_US';
		queueUser.profileid = UserInfo.getProfileId();
		queueUser.Country__c = 'Canada';
		queueUser.timezonesidkey = 'America/Los_Angeles';
		queueUser.Username = 'testgmail2345@randomemail.com';
		insert queueUser;
		
		HWS_DataFactory_TEST.createWGSetupServiceQuote();
		Id dpqRecordTypeId = HWS_Utilty.getRecordTypeByName('HWS_Service_Quote__c','HWS_Damaged_Part_Quote');
		Id childcse = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Child_Case_Read_Only);
		Case getCase = [SELECT Id FROM Case WHERE RecordTypeId =: childcse LIMIT 1];
		User accUsr = [SELECT contactId FROM User WHERE LastName = 'PORTL2' LIMIT 1];
		CH_Workgroup__c cdmWg = [SELECT Id,Name,CH_Type__c FROM CH_Workgroup__c WHERE Name='HWS_EQS-CDM_CDM_NAM_US' LIMIT 1];
		List<HWS_Service_Quote__c> damagedServiceQuoteList = HWS_DataFactory_TEST.createServiceQuote(1,dpqRecordTypeId,false,getCase.Id);
		damagedServiceQuoteList[0].HWS_Workgroup__c = cdmWg.Id;
		damagedServiceQuoteList[0].HWS_Customer_ContactId_1__c=accUsr.contactId;
		damagedServiceQuoteList[0].HWS_Customer_ContactId2__c=accUsr.contactId;
		damagedServiceQuoteList[0].HWS_Nokia_Email__c='test@gmail.com';
		damagedServiceQuoteList[0].HWS_Quotation_Contact_Email__c = 'test@test.com';
		insert damagedServiceQuoteList;
	}
	
	
	@isTest
	Static void testEmailQuote() {
		Test.startTest();
		List<Id> quoteId = new list<Id>();
		List <HWS_Service_Quote__c> damagedServiceQuoteList =[Select Id From HWS_Service_Quote__c LIMIT 1];
		try{
			ApexPages.StandardController  stdController = new ApexPages.standardController(damagedServiceQuoteList[0]);
			HWS_EmailQuote emailQuote=new HWS_EmailQuote(stdController);
			String getValue= HWS_EmailQuote.emailQuote(damagedServiceQuoteList[0].Id,false);
			quoteId.add(damagedServiceQuoteList[0].Id);
			HWS_EmailQuote.emailQuoteforStatus(quoteId);
		}
		catch(Exception e){
			System.debug(e.getMessage());
		} 
		Test.stopTest();
	}
	
	@isTest
	Static void testemailQuoteforStatus() {
		Test.startTest();
		List<Id> quoteId = new list<Id>();
		List <HWS_Service_Quote__c> damagedServiceQuoteList =[Select Id From HWS_Service_Quote__c LIMIT 1];
		try{
			ApexPages.StandardController  stdController = new ApexPages.standardController(damagedServiceQuoteList[0]);
			HWS_EmailQuote emailQuote=new HWS_EmailQuote(stdController);
			String getValue= HWS_EmailQuote.emailQuote(damagedServiceQuoteList[0].id,false);
			quoteId.add(damagedServiceQuoteList[0].id);
			HWS_EmailQuoteHelper.emailQuoteforStatus(quoteId);
		}
		catch(Exception e){
			System.debug(e.getMessage());
		}
		Test.stopTest();
	}
	
}