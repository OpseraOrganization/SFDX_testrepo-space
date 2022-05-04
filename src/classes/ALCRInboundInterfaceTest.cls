/****************************************
 * Class Name : ALCRInboundInterfaceTest 
 * Created Date: 17 Jan 2017
 * Created By : Accenture
 * Description : This is the test class to cover ALCRInboundInterface
 *****************************************/
@isTest 
private class ALCRInboundInterfaceTest{

	/***************************************************************************************
	Purpose: This method tests create / insert account with all the required fileds.
	****************************************************************************************/

	static testMethod void alcrInboundInterfaceTestInsert(){
	
		test.startTest();
		Account acc=new Account();
		acc.Name='Test Account';
		acc.Market_Segment__c='CABLE';
		acc.Website='www.test.com';
		acc.Customer_Compliance__c='unassign';
		acc.BusinessPartnerRole__c='Alliance';
		acc.Market__c='Market Greater China';
		acc.CBT_CT_Code__c='GCHN CMCC Beijing';
		acc.Activity_Sector_Name__c='CABL - CABLE PROVIDERS';
		acc.RecordTypeId=acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(GlobalConstants.PROSPECT).getRecordTypeId();
		acc.BillingCountry='China';
		acc.BillingCity='Beijing';
		acc.BillingState='Beijing';
		//acc.BillingStateCode='11';	
		acc.BillingStreet='changanjie';
		acc.BillingPostalCode='123456';
		acc.State__c='Beijing';
		Insert acc;
		System.debug('===>');
		ALCRInboundInterface alcrinterface = New ALCRInboundInterface();
		ALCRInboundInterface.Response alcrRes = New ALCRInboundInterface.Response();
		ALCRInboundInterface.AccountWrap alcrAccWrap = New ALCRInboundInterface.AccountWrap();
		ISO_Country_Codes__c countryCodes = New ISO_Country_Codes__c();
		countryCodes.Name = 'CN';
		countryCodes.Country_Name__c = 'China';
		insert countryCodes;
		
		// providing test data to the AccountWrap class
		alcrAccWrap.salesforceRecordID= acc.Id;
		alcrAccWrap.CustomerNumber = '9868863440';
		alcrAccWrap.LegalName = 'Test Account';
		alcrAccWrap.CurrencyCode = 'ARS';	
		//alcrAccWrap.ActivitySectorCode = 'TRHW';//modified on 2018-06-15
		alcrAccWrap.ActivitySectorCode = 'DEAC';
		alcrAccWrap.Street = 'ITPL';		
		alcrAccWrap.City = 'Blr'; 
		alcrAccWrap.countryCodeISO2 = 'CN';  
		alcrAccWrap.CompanyType = 'Customer';
		alcrAccWrap.CustomerAccountCode = 'KORA3BY';
		alcrAccWrap.CustomerAccountName = 'Test Customer';
		alcrAccWrap.fcgCode = 'CXPCT' ;
		alcrAccWrap.fcgName = 'SI TRANSPORT-ARG';
	// alcrAccWrap.CAT = 'BYTEL-FR';
		alcrAccWrap.keyAccountCode = 'KEY-CODE';
		alcrAccWrap.keyAccountName = 'KEY-NAME';
		alcrAccWrap.holdingAccountCode = 'HOLDING-CODE';
		alcrAccWrap.holdingAccountName = 'HOLDING-NAME';
		alcrAccWrap.LegalNameExtension = 'Test Account Ext.';		 
		alcrAccWrap.BusinessName = 'Test Business';		
		alcrAccWrap.WebAddress = 'test@tcs.com';			
		alcrAccWrap.MarketCode = 'ENT';
		alcrAccWrap.MarketName = 'ENTERPRISE';		
		alcrAccWrap.activityName = 'TRHW-Transport - Highways, Airports & Ports';
		alcrAccWrap.buildingFloor = 'Innovator';		 
		alcrAccWrap.PostalCode = '560000';
		alcrAccWrap.stateProvinceCountyCode = 'KA';
	// alcrAccWrap.AccountManagerUPI = 'Test User';
		alcrAccWrap.CompanyEndDate = System.today();
		alcrAccWrap.ReasonForEndName = 'xxx reasons';
		alcrAccWrap.AssetQualityRatingCode = '1';
		alcrAccWrap.AssetQualityRatingName = 'Test Quality';		
		alcrAccWrap.ALUUnitCode = 'T2013';
		alcrAccWrap.qtcSoldTo = 'qtc';
		alcrAccWrap.BusinessContinuation = 'yes';		
		alcrAccWrap.regionalUnit = 'RU WSEU - Cluster FRL';
		alcrAccWrap.region = 'EMEA';
		//alcrAccWrap.catLeaderUPI = 'Test Cat Leader';
		alcrAccWrap.createdOn = System.today();
		alcrAccWrap.createdByUser = 'Test User';
		alcrAccWrap.customerUnitCode = '140';
		alcrAccWrap.customerUnitName = 'CU_CALA_IPS';
		alcrAccWrap.commercialCluster = 'MENA';
		/****added by Debin Kuriakose [IDC] on 05/11/2015 for ALCR Modernization****/
		alcrAccWrap.recordType = 'Direct';
	/*****************************************************************************/
		
			//Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
			alcrRes = ALCRInboundInterface.createAccount(alcrAccWrap);
			system.debug('alcrRes ..............'+alcrRes);
			//System.assertEquals('Account created successfully',alcrRes.message);
		test.stopTest();
	}
	
	/***************************************************************************************
	Purpose: This method tests update account with all the required fileds.
	**************************************************************************************
	
	static testMethod void alcrInboundInterfaceTestUpdate(){
		
	  test.startTest();	 
	  
		ALCRInboundInterface alcrinterface = New ALCRInboundInterface();
		ALCRInboundInterface.Response alcrRes = New ALCRInboundInterface.Response();
		ALCRInboundInterface.AccountWrap alcrAccWrap = New ALCRInboundInterface.AccountWrap();
		/*ISO_Country_Codes__c countryCodes = New ISO_Country_Codes__c();
		countryCodes.Name = 'AA';
		countryCodes.Country_Name__c = 'America';	 
		insert countryCodes;*/
 
		/**Account account = new Account( Name = 'Test Update', AccountNumber = '2');
		
		insert account;
	// providing test data to the AccountWrap class
		alcrAccWrap.CustomerNumber = '2';
		alcrAccWrap.LegalName = 'Test Account2';
		alcrAccWrap.CurrencyCode = 'EUR';	
		alcrAccWrap.ActivitySectorCode = 'TRHW';
		alcrAccWrap.Street = 'ITPB';		
		alcrAccWrap.City = 'Blr'; 
		alcrAccWrap.countryCodeISO2 = 'IN';	
		alcrAccWrap.CompanyType = 'Customer';
		alcrAccWrap.CustomerAccountCode = 'KORA3BY';
		alcrAccWrap.CustomerAccountName = 'Test Customer';
		alcrAccWrap.fcgCode = 'CXPCT' ;
		alcrAccWrap.fcgName = 'SI TRANSPORT-ARG';
		//alcrAccWrap.CAT = 'ITA';
		alcrAccWrap.keyAccountCode = 'KEY-CODE';
		alcrAccWrap.keyAccountName = 'KEY-NAME';
		alcrAccWrap.holdingAccountCode = 'HOLDING-CODE';
		alcrAccWrap.holdingAccountName = 'HOLDING-NAME';
		
			alcrRes = ALCRInboundInterface.createAccount(alcrAccWrap);
			system.debug('alcrRes ..............'+alcrRes);
			//System.assertEquals('Account updated successfully',alcrRes.message);
			
		test.stopTest();
	}**/
	
	/***************************************************************************************
	Purpose: This method tests Required Customer Number.
	****************************************************************************************/
	
	static testMethod void alcrInboundInterfaceTestRequiredCustomerNumber(){
	
		ALCRInboundInterface alcrinterface = New ALCRInboundInterface();
		ALCRInboundInterface.Response alcrRes = New ALCRInboundInterface.Response();
		ALCRInboundInterface.AccountWrap alcrAccWrap = New ALCRInboundInterface.AccountWrap();
		
		// providing test data to the AccountWrap class
		alcrAccWrap.CustomerNumber = null;
		test.startTest();
			alcrRes = ALCRInboundInterface.createAccount(alcrAccWrap);
			system.debug('alcrRes ..............'+alcrRes);
			System.assertEquals('Required Customer Number field is empty',alcrRes.message);
		test.stopTest();
	}
	
	/***************************************************************************************
	Purpose: This method tests Required Legal Name.
	****************************************************************************************/
	
	static testMethod void alcrInboundInterfaceTestRequiredLegalName(){
	
		ALCRInboundInterface alcrinterface = New ALCRInboundInterface();
		ALCRInboundInterface.Response alcrRes = New ALCRInboundInterface.Response();
		ALCRInboundInterface.AccountWrap alcrAccWrap = New ALCRInboundInterface.AccountWrap();
		
		// providing test data to the AccountWrap class
		alcrAccWrap.CustomerNumber = '1';
		alcrAccWrap.LegalName ='';
		test.startTest();
			alcrRes = ALCRInboundInterface.createAccount(alcrAccWrap);
			system.debug('alcrRes ..............'+alcrRes);
			System.assertEquals('Required Legal Name field is empty. Customer Number : 1',alcrRes.message);
		test.stopTest();
	}
	
	/***************************************************************************************
	Purpose: This method tests Required Currency Code.
	****************************************************************************************/
	
	static testMethod void alcrInboundInterfaceTestRequiredCurrencyCode(){
	
		ALCRInboundInterface alcrinterface = New ALCRInboundInterface();
		ALCRInboundInterface.Response alcrRes = New ALCRInboundInterface.Response();
		ALCRInboundInterface.AccountWrap alcrAccWrap = New ALCRInboundInterface.AccountWrap();
		
		// providing test data to the AccountWrap class
		alcrAccWrap.CustomerNumber = '1';
		alcrAccWrap.LegalName ='Test Account';
		alcrAccWrap.CurrencyCode = '';
		test.startTest();
			alcrRes = ALCRInboundInterface.createAccount(alcrAccWrap);
			system.debug('alcrRes ..............'+alcrRes);
			System.assertEquals('Required Currency Code field is empty. Customer Number : 1',alcrRes.message);
			
		test.stopTest();
	}
	
	/***************************************************************************************
	Purpose: This method tests Required Activity SectorCode.
	****************************************************************************************/
	
	static testMethod void alcrInboundInterfaceTestRequiredActivitySectorCode(){
	
		ALCRInboundInterface alcrinterface = New ALCRInboundInterface();
		ALCRInboundInterface.Response alcrRes = New ALCRInboundInterface.Response();
		ALCRInboundInterface.AccountWrap alcrAccWrap = New ALCRInboundInterface.AccountWrap();
		
		// providing test data to the AccountWrap class
		alcrAccWrap.CustomerNumber = '1';
		alcrAccWrap.LegalName ='Test Account';
		alcrAccWrap.CurrencyCode = 'ARS';
		alcrAccWrap.ActivitySectorCode = '';
		test.startTest();
			alcrRes = ALCRInboundInterface.createAccount(alcrAccWrap);
			system.debug('alcrRes ..............'+alcrRes);
			System.assertEquals('Required Activity Sector Code field is empty. Customer Number : 1',alcrRes.message);
		test.stopTest();
	}
	
	/***************************************************************************************
	Purpose: This method tests Required Street.
	****************************************************************************************/
	
	static testMethod void alcrInboundInterfaceTestRequiredStreet(){
	
		ALCRInboundInterface alcrinterface = New ALCRInboundInterface();
		ALCRInboundInterface.Response alcrRes = New ALCRInboundInterface.Response();
		ALCRInboundInterface.AccountWrap alcrAccWrap = New ALCRInboundInterface.AccountWrap();
		
		// providing test data to the AccountWrap class
		alcrAccWrap.CustomerNumber = '1';
		alcrAccWrap.LegalName ='Test Account';
		alcrAccWrap.CurrencyCode = 'ARS';
		alcrAccWrap.ActivitySectorCode = 'TRHW';
		alcrAccWrap.Street = '';
		test.startTest();
			alcrRes = ALCRInboundInterface.createAccount(alcrAccWrap);
			system.debug('alcrRes ..............'+alcrRes);
			System.assertEquals('Required Street field is empty. Customer Number : 1',alcrRes.message);
		test.stopTest();
	}
	
	/***************************************************************************************
	Purpose: This method tests Required City.
	****************************************************************************************/
	
	static testMethod void alcrInboundInterfaceTestRequiredCity(){
	
		ALCRInboundInterface alcrinterface = New ALCRInboundInterface();
		ALCRInboundInterface.Response alcrRes = New ALCRInboundInterface.Response();
		ALCRInboundInterface.AccountWrap alcrAccWrap = New ALCRInboundInterface.AccountWrap();
		
		// providing test data to the AccountWrap class
		alcrAccWrap.CustomerNumber = '1';
		alcrAccWrap.LegalName ='Test Account';
		alcrAccWrap.CurrencyCode = 'ARS';
		alcrAccWrap.ActivitySectorCode = 'TRHW';
		alcrAccWrap.Street = 'ITPL';
		alcrAccWrap.City = ''; 
		test.startTest();
			alcrRes = ALCRInboundInterface.createAccount(alcrAccWrap);
			system.debug('alcrRes ..............'+alcrRes);
			System.assertEquals('Required City field is empty. Customer Number : 1',alcrRes.message);
		test.stopTest();
	}
	
	/***************************************************************************************
	Purpose: This method tests Required country Code ISO2.
	****************************************************************************************/
	
	static testMethod void alcrInboundInterfaceTestRequiredcountryCodeISO2(){
	
		ALCRInboundInterface alcrinterface = New ALCRInboundInterface();
		ALCRInboundInterface.Response alcrRes = New ALCRInboundInterface.Response();
		ALCRInboundInterface.AccountWrap alcrAccWrap = New ALCRInboundInterface.AccountWrap();
		
		// providing test data to the AccountWrap class
		alcrAccWrap.CustomerNumber = '1';
		alcrAccWrap.LegalName ='Test Account';
		alcrAccWrap.CurrencyCode = 'ARS';
		alcrAccWrap.ActivitySectorCode = 'TRHW';
		alcrAccWrap.Street = 'ITPL';
		alcrAccWrap.City = 'Blr'; 
		alcrAccWrap.countryCodeISO2 = ''; 
		test.startTest();
			alcrRes = ALCRInboundInterface.createAccount(alcrAccWrap);
			system.debug('alcrRes ..............'+alcrRes);
			System.assertEquals('Required country Code ISO2 field is empty. Customer Number : 1',alcrRes.message);
		test.stopTest();
	}
	
	/***************************************************************************************
	Purpose: This method tests Required Company Type.
	****************************************************************************************/
	
	static testMethod void alcrInboundInterfaceTestRequiredCompanyType(){
	
		ALCRInboundInterface alcrinterface = New ALCRInboundInterface();
		ALCRInboundInterface.Response alcrRes = New ALCRInboundInterface.Response();
		ALCRInboundInterface.AccountWrap alcrAccWrap = New ALCRInboundInterface.AccountWrap();
	 
		// providing test data to the AccountWrap class
		alcrAccWrap.CustomerNumber = '1';
		alcrAccWrap.LegalName ='Test Account';
		alcrAccWrap.CurrencyCode = 'ARS';
		alcrAccWrap.ActivitySectorCode = 'TRHW';
		alcrAccWrap.Street = 'ITPL';
		alcrAccWrap.City = 'Blr'; 
		alcrAccWrap.countryCodeISO2 = 'IN'; 
		alcrAccWrap.CompanyType = '';
		test.startTest();
			alcrRes = ALCRInboundInterface.createAccount(alcrAccWrap);
			system.debug('alcrRes ..............'+alcrRes);
	 // System.assertEquals('Required Company Type field is empty. Customer Number : 1',alcrRes.message);
		test.stopTest();
	}
	
	/***************************************************************************************
	Purpose: This method tests Required customer Account Code.
	****************************************************************************************/
	
	static testMethod void alcrInboundInterfaceTestRequiredcustomerAccountCode(){
	
		ALCRInboundInterface alcrinterface = New ALCRInboundInterface();
		ALCRInboundInterface.Response alcrRes = New ALCRInboundInterface.Response();
		ALCRInboundInterface.AccountWrap alcrAccWrap = New ALCRInboundInterface.AccountWrap();
		
		// providing test data to the AccountWrap class
		alcrAccWrap.CustomerNumber = '1';
		alcrAccWrap.LegalName ='Test Account';
		alcrAccWrap.CurrencyCode = 'ARS';
		alcrAccWrap.ActivitySectorCode = 'TRHW';
		alcrAccWrap.Street = 'ITPL';
		alcrAccWrap.City = 'Blr'; 
		alcrAccWrap.countryCodeISO2 = 'IN'; 
		alcrAccWrap.CompanyType = 'Customer';
		alcrAccWrap.CustomerAccountCode = '';
		test.startTest();
			alcrRes = ALCRInboundInterface.createAccount(alcrAccWrap);
			system.debug('alcrRes ..............'+alcrRes);
			System.assertEquals('Required customer Account Code field is empty. Customer Number : 1',alcrRes.message);
		test.stopTest();
	} 
	
	/***************************************************************************************
	Purpose: This method tests Required customer Account Name.
	****************************************************************************************/
	
	static testMethod void alcrInboundInterfaceTestRequiredcustomerAccountName(){
	
		ALCRInboundInterface alcrinterface = New ALCRInboundInterface();
		ALCRInboundInterface.Response alcrRes = New ALCRInboundInterface.Response();
		ALCRInboundInterface.AccountWrap alcrAccWrap = New ALCRInboundInterface.AccountWrap();
		
		// providing test data to the AccountWrap class
		alcrAccWrap.CustomerNumber = '1';
		alcrAccWrap.LegalName ='Test Account';
		alcrAccWrap.CurrencyCode = 'ARS';
		alcrAccWrap.ActivitySectorCode = 'TRHW';
		alcrAccWrap.Street = 'ITPL';
		alcrAccWrap.City = 'Blr'; 
		alcrAccWrap.countryCodeISO2 = 'IN'; 
		alcrAccWrap.CompanyType = 'Customer';
		alcrAccWrap.CustomerAccountCode = 'KORA3BY';
		alcrAccWrap.CustomerAccountName = '';
		test.startTest();
			alcrRes = ALCRInboundInterface.createAccount(alcrAccWrap);
			system.debug('alcrRes ..............'+alcrRes);
			System.assertEquals('Required customer Account Name field is empty. Customer Number : 1',alcrRes.message);
		test.stopTest();
	} 
	
	/***************************************************************************************
	Purpose: This method tests Required FCG Code.
	****************************************************************************************/
	
	static testMethod void alcrInboundInterfaceTestRequiredFCGCode(){
	
		ALCRInboundInterface alcrinterface = New ALCRInboundInterface();
		ALCRInboundInterface.Response alcrRes = New ALCRInboundInterface.Response();
		ALCRInboundInterface.AccountWrap alcrAccWrap = New ALCRInboundInterface.AccountWrap();
		
		// providing test data to the AccountWrap class
		alcrAccWrap.CustomerNumber = '1';
		alcrAccWrap.LegalName ='Test Account';
		alcrAccWrap.CurrencyCode = 'ARS';
		alcrAccWrap.ActivitySectorCode = 'TRHW';
		alcrAccWrap.Street = 'ITPL';
		alcrAccWrap.City = 'Blr'; 
		alcrAccWrap.countryCodeISO2 = 'IN'; 
		alcrAccWrap.CompanyType = 'Customer';
		alcrAccWrap.CustomerAccountCode = 'KORA3BY';
		alcrAccWrap.CustomerAccountName = 'Test Customer';
		alcrAccWrap.fcgCode = '';
		test.startTest();
			alcrRes = ALCRInboundInterface.createAccount(alcrAccWrap);
			system.debug('alcrRes ..............'+alcrRes);
			System.assertEquals('Required FCG Code field is empty. Customer Number : 1',alcrRes.message);
		test.stopTest();
	}
	
	/***************************************************************************************
	Purpose: This method tests Required FCG Name.
	****************************************************************************************/
	
	static testMethod void alcrInboundInterfaceTestRequiredFCGName(){
	
		ALCRInboundInterface alcrinterface = New ALCRInboundInterface();
		ALCRInboundInterface.Response alcrRes = New ALCRInboundInterface.Response();
		ALCRInboundInterface.AccountWrap alcrAccWrap = New ALCRInboundInterface.AccountWrap();
		
		// providing test data to the AccountWrap class
		alcrAccWrap.CustomerNumber = '1';
		alcrAccWrap.LegalName ='Test Account';
		alcrAccWrap.CurrencyCode = 'ARS';
		alcrAccWrap.ActivitySectorCode = 'TRHW';
		alcrAccWrap.Street = 'ITPL';
		alcrAccWrap.City = 'Blr'; 
		alcrAccWrap.countryCodeISO2 = 'IN'; 
		alcrAccWrap.CompanyType = 'Customer';
		alcrAccWrap.CustomerAccountCode = 'KORA3BY';
		alcrAccWrap.CustomerAccountName = 'Test Customer';
		alcrAccWrap.fcgCode = 'CXPCT';
		alcrAccWrap.fcgName = '';
		test.startTest();
			alcrRes = ALCRInboundInterface.createAccount(alcrAccWrap);
			system.debug('alcrRes ..............'+alcrRes);
			System.assertEquals('Required FCG Name field is empty. Customer Number : 1',alcrRes.message);
		test.stopTest();
	}
	
	/***************************************************************************************
	Purpose: This method tests Required CAT.
	**************************************************************************************
	
	static testMethod void alcrInboundInterfaceTestRequiredCAT(){
	
		ALCRInboundInterface alcrinterface = New ALCRInboundInterface();
		ALCRInboundInterface.Response alcrRes = New ALCRInboundInterface.Response();
		ALCRInboundInterface.AccountWrap alcrAccWrap = New ALCRInboundInterface.AccountWrap();
		
		// providing test data to the AccountWrap class
		alcrAccWrap.CustomerNumber = '1';
		alcrAccWrap.LegalName ='Test Account';
		alcrAccWrap.CurrencyCode = 'ARS';
		alcrAccWrap.ActivitySectorCode = 'TRHW';
		alcrAccWrap.Street = 'ITPL';
		alcrAccWrap.City = 'Blr'; 
		alcrAccWrap.countryCodeISO2 = 'IN'; 
		alcrAccWrap.CompanyType = 'Customer';
		alcrAccWrap.CustomerAccountCode = 'KORA3BY';
		alcrAccWrap.CustomerAccountName = 'Test Customer';
		alcrAccWrap.fcgCode = 'CXPCT';
		alcrAccWrap.fcgName = 'SI TRANSPORT-ARG';
		//alcrAccWrap.CAT = '';
		test.startTest();
			alcrRes = ALCRInboundInterface.createAccount(alcrAccWrap);
			system.debug('alcrRes ..............'+alcrRes);
			System.assertEquals('Required CAT field is empty. Customer Number : 1',alcrRes.message);
		test.stopTest();
	}**/
	
	/***************************************************************************************
	Purpose:This method tests Required Key Account Code.
	****************************************************************************************/
	
	static testMethod void alcrInboundInterfaceTestRequiredKeyAccountCode(){
	
		ALCRInboundInterface alcrinterface = New ALCRInboundInterface();
		ALCRInboundInterface.Response alcrRes = New ALCRInboundInterface.Response();
		ALCRInboundInterface.AccountWrap alcrAccWrap = New ALCRInboundInterface.AccountWrap();
		
		// providing test data to the AccountWrap class
		alcrAccWrap.CustomerNumber = '1';
		alcrAccWrap.LegalName ='Test Account';
		alcrAccWrap.CurrencyCode = 'ARS';
		alcrAccWrap.ActivitySectorCode = 'TRHW';
		alcrAccWrap.Street = 'ITPL';
		alcrAccWrap.City = 'Blr'; 
		alcrAccWrap.countryCodeISO2 = 'IN'; 
		alcrAccWrap.CompanyType = 'Customer';
		alcrAccWrap.CustomerAccountCode = 'KORA3BY';
		alcrAccWrap.CustomerAccountName = 'Test Customer';
		alcrAccWrap.fcgCode = 'CXPCT';
		alcrAccWrap.fcgName = 'SI TRANSPORT-ARG';
		//alcrAccWrap.CAT = 'BYTEL-FR';
		alcrAccWrap.keyAccountCode = '';
		test.startTest();
			alcrRes = ALCRInboundInterface.createAccount(alcrAccWrap);
			system.debug('alcrRes ..............'+alcrRes);
			System.assertEquals('Required Key Account Code field is empty. Customer Number : 1',alcrRes.message);
		test.stopTest();
	}
	
	/***************************************************************************************
	Purpose:This method tests Required Key Account Name.
	****************************************************************************************/
	
	static testMethod void alcrInboundInterfaceTestRequiredKeyAccountName(){
	
		ALCRInboundInterface alcrinterface = New ALCRInboundInterface();
		ALCRInboundInterface.Response alcrRes = New ALCRInboundInterface.Response();
		ALCRInboundInterface.AccountWrap alcrAccWrap = New ALCRInboundInterface.AccountWrap();
		
		// providing test data to the AccountWrap class
		alcrAccWrap.CustomerNumber = '1';
		alcrAccWrap.LegalName ='Test Account';
		alcrAccWrap.CurrencyCode = 'ARS';
		alcrAccWrap.ActivitySectorCode = 'TRHW';
		alcrAccWrap.Street = 'ITPL';
		alcrAccWrap.City = 'Blr'; 
		alcrAccWrap.countryCodeISO2 = 'IN'; 
		alcrAccWrap.CompanyType = 'Customer';
		alcrAccWrap.CustomerAccountCode = 'KORA3BY';
		alcrAccWrap.CustomerAccountName = 'Test Customer';
		alcrAccWrap.fcgCode = 'CXPCT';
		alcrAccWrap.fcgName = 'SI TRANSPORT-ARG';
		//alcrAccWrap.CAT = 'BYTEL-FR';
		alcrAccWrap.keyAccountCode = 'KEY-CODE';
		alcrAccWrap.keyAccountName = '';
		test.startTest();
			alcrRes = ALCRInboundInterface.createAccount(alcrAccWrap);
			system.debug('alcrRes ..............'+alcrRes);
			System.assertEquals('Required Key Account Name field is empty. Customer Number : 1',alcrRes.message);
		test.stopTest();
	}
	
	/***************************************************************************************
	Purpose: This method tests Required Holding Account Code.
	****************************************************************************************/
	
	static testMethod void alcrInboundInterfaceTestRequiredHoldingAccountCode(){
	
		ALCRInboundInterface alcrinterface = New ALCRInboundInterface();
		ALCRInboundInterface.Response alcrRes = New ALCRInboundInterface.Response();
		ALCRInboundInterface.AccountWrap alcrAccWrap = New ALCRInboundInterface.AccountWrap();
		
		// providing test data to the AccountWrap class
		alcrAccWrap.CustomerNumber = '1';
		alcrAccWrap.LegalName ='Test Account';
		alcrAccWrap.CurrencyCode = 'ARS';
		alcrAccWrap.ActivitySectorCode = 'TRHW';
		alcrAccWrap.Street = 'ITPL';
		alcrAccWrap.City = 'Blr'; 
		alcrAccWrap.countryCodeISO2 = 'IN'; 
		alcrAccWrap.CompanyType = 'Customer';
		alcrAccWrap.CustomerAccountCode = 'KORA3BY';
		alcrAccWrap.CustomerAccountName = 'Test Customer';
		alcrAccWrap.fcgCode = 'CXPCT';
		alcrAccWrap.fcgName = 'SI TRANSPORT-ARG';
		//alcrAccWrap.CAT = 'BYTEL-FR';
		alcrAccWrap.keyAccountCode = 'KEY-CODE';
		alcrAccWrap.keyAccountName = 'KEY-NAME';
		alcrAccWrap.holdingAccountCode = '';
		test.startTest();
			alcrRes = ALCRInboundInterface.createAccount(alcrAccWrap);
			system.debug('alcrRes ..............'+alcrRes);
			System.assertEquals('Required Holding Account Code field is empty. Customer Number : 1',alcrRes.message);
		test.stopTest();
	}
	
	/***************************************************************************************
	Purpose: This method tests Required Holding Account Name.
	****************************************************************************************/
	
	static testMethod void alcrInboundInterfaceTestRequiredHoldingAccountName(){
	
		ALCRInboundInterface alcrinterface = New ALCRInboundInterface();
		ALCRInboundInterface.Response alcrRes = New ALCRInboundInterface.Response();
		ALCRInboundInterface.AccountWrap alcrAccWrap = New ALCRInboundInterface.AccountWrap();
		
		// providing test data to the AccountWrap class
		alcrAccWrap.CustomerNumber = '1';
		alcrAccWrap.LegalName ='Test Account';
		alcrAccWrap.CurrencyCode = 'ARS';
		alcrAccWrap.ActivitySectorCode = 'TRHW';
		alcrAccWrap.Street = 'ITPL';
		alcrAccWrap.City = 'Blr'; 
		alcrAccWrap.countryCodeISO2 = 'IN'; 
		alcrAccWrap.CompanyType = 'Customer';
		alcrAccWrap.CustomerAccountCode = 'KORA3BY';
		alcrAccWrap.CustomerAccountName = 'Test Customer';
		alcrAccWrap.fcgCode = 'CXPCT';
		alcrAccWrap.fcgName = 'SI TRANSPORT-ARG';
		//alcrAccWrap.CAT = 'BYTEL-FR';
		alcrAccWrap.keyAccountCode = 'KEY-CODE';
		alcrAccWrap.keyAccountName = 'KEY-NAME';
		alcrAccWrap.holdingAccountCode = 'HOLDING-CODE';
		alcrAccWrap.holdingAccountName = '';
		test.startTest();
			alcrRes = ALCRInboundInterface.createAccount(alcrAccWrap);
			system.debug('alcrRes ..............'+alcrRes);
			System.assertEquals('Required Holding Account Name field is empty. Customer Number : 1',alcrRes.message);
		test.stopTest();
	}
	
	
	/***************************************************************************************
	Purpose: This method validates value of Company Type.
	****************************************************************************************/
	
	static testMethod void alcrInboundInterfaceTestCompanyType(){
	
		ALCRInboundInterface alcrinterface = New ALCRInboundInterface();
		ALCRInboundInterface.Response alcrRes = New ALCRInboundInterface.Response();
		ALCRInboundInterface.AccountWrap alcrAccWrap = New ALCRInboundInterface.AccountWrap();
		
		// providing test data to the AccountWrap class
		alcrAccWrap.CustomerNumber = '1';
		alcrAccWrap.LegalName ='Test Account';
		alcrAccWrap.CurrencyCode = 'ARS';
		alcrAccWrap.ActivitySectorCode = 'TRHW';
		alcrAccWrap.Street = 'ITPL';
		alcrAccWrap.City = 'Blr'; 
		alcrAccWrap.countryCodeISO2 = 'IN'; 
		alcrAccWrap.CompanyType = 'CustomerProspect';
		alcrAccWrap.CustomerAccountCode = 'KORA3BY';
		alcrAccWrap.CustomerAccountName = 'Test Customer';
		alcrAccWrap.fcgCode = 'CXPCT';
		alcrAccWrap.fcgName = 'SI TRANSPORT-ARG';
		//alcrAccWrap.CAT = 'BYTEL-FR';
		alcrAccWrap.keyAccountCode = 'KEY-CODE';
		alcrAccWrap.keyAccountName = 'KEY-NAME';
		alcrAccWrap.holdingAccountCode = 'HOLDING-CODE';
		alcrAccWrap.holdingAccountName = 'HOLDING-NAME';
		test.startTest();
			alcrRes = ALCRInboundInterface.createAccount(alcrAccWrap);
			system.debug('alcrRes ..............'+alcrRes);
			//System.assertEquals('Invalid value for field Company Type. Customer Number : 1',alcrRes.message);
		test.stopTest();
	}

	/***************************************************************************************
	Purpose: This method validates value of  Country Code ISO2.
	*************************************************************************************
	
	static testMethod void alcrInboundInterfaceTestCountryCodeISO2(){
	
		ALCRInboundInterface alcrinterface = New ALCRInboundInterface();
		ALCRInboundInterface.Response alcrRes = New ALCRInboundInterface.Response();
		ALCRInboundInterface.AccountWrap alcrAccWrap = New ALCRInboundInterface.AccountWrap();
		
		// providing test data to the AccountWrap class
		alcrAccWrap.CustomerNumber = '1';
		alcrAccWrap.LegalName ='Test Account';
		alcrAccWrap.CurrencyCode = 'ARS';
		alcrAccWrap.ActivitySectorCode = 'TRHW';
		alcrAccWrap.Street = 'ITPL';
		alcrAccWrap.City = 'Blr'; 
		alcrAccWrap.countryCodeISO2 = 'IM'; 
		alcrAccWrap.CompanyType = 'Customer';
		alcrAccWrap.CustomerAccountCode = 'KORA3BY';
		alcrAccWrap.CustomerAccountName = 'Test Customer';
		alcrAccWrap.fcgCode = 'CXPCT';
		alcrAccWrap.fcgName = 'SI TRANSPORT-ARG';
		//alcrAccWrap.CAT = 'BYTEL-FR';
		alcrAccWrap.keyAccountCode = 'KEY-CODE';
		alcrAccWrap.keyAccountName = 'KEY-NAME';
		alcrAccWrap.holdingAccountCode = 'HOLDING-CODE';
		alcrAccWrap.holdingAccountName = 'HOLDING-NAME';
		test.startTest();
			alcrRes = ALCRInboundInterface.createAccount(alcrAccWrap);
			system.debug('alcrRes ..............'+alcrRes);
			System.assertEquals('Invalid value for field Country Code ISO2. Customer Number : 1',alcrRes.message);
		test.stopTest();
	}***/
	 
}