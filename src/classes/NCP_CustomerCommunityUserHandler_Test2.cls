@isTest
private class NCP_CustomerCommunityUserHandler_Test2 {
	private static String COMMUNITY_ID;
		
	@testSetup static void setup() {
		User adminUser = NCP_TestFactory.createUser(true, 'AES Admin', null, 'admin@nokia.com.dev');
		Profile profileRecord = [SELECT Id FROM Profile WHERE Name = 'Integration API Only Profile'];
		adminUser.ProfileId = profileRecord.Id;
		insert adminUser;
		////
		System.runAs(adminUser) {
			NCP_CustomerCommunitySetting__c setting = NCP_TestFactory.insertCustomSetting();
			setting.Internal_User_Profile__c = 'system Administrator';
			update setting;
			ISO_Country_Codes__c countryCodes = NCP_TestFactory.insertIsoCountryCodes();
			
			Network MyCommunity = new Network();
			MyCommunity = [SELECT Id,Name From Network WHERE Name = 'Customers' Limit 1];
			COMMUNITY_ID = MyCommunity.Id; 
			
			System.assertNotEquals(null, setting);
			Profiles_to_Bypass__c profilesBypassHCS = new Profiles_to_Bypass__c(SetupOwnerId = adminUser.Id,	Bypass_Validation_Rule__c = true);
			insert profilesBypassHCS;
			
			NCP_CustomerCommunitySetting__c setting1 = NCP_CustomerCommunitySetting__c.getValues('Default');
			
			Test.startTest();
			
			List<Account> parentAccountList = new List<Account>();
			Account acc = new Account(
				Name = 'Parent 1',
				accountNumber = '1234567',
				recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			parentAccountList.add(acc);
			
			Account acc2 = new Account(
				Name = 'Parent 2',
				accountNumber = '1234568',
				recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
			);
			parentAccountList.add(acc2);
			insert parentAccountList;
			
			List<Account> accList = new List<Account>();
			Account accLE = new Account(
				Name = 'LE customer name',
				accountNumber = '1001069312',
				NCP_P20_ID__c='1000069312',
				parentId = parentAccountList[0].Id,
				recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE);
			
			Account accLE3 = new Account(
				Name = ' LE customer name 3',
				accountNumber = '1001069315',
				NCP_P20_ID__c='1001069315',
				parentId = parentAccountList[1].Id,
				recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY )
			);
			accList.add(accLE3);
			
			insert accList;
			
			String federationIdentifier = '15262723';
			
			NCP_Timezone_Mapping__c timeZ = new NCP_Timezone_Mapping__c();
			timeZ.Name = '123';
			timeZ.SF_Timezone__c = 'Europe/Amsterdam';
			timeZ.NAM_Timezone__c = '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna';
			insert timeZ;
			
			Product2 prod1 = HWS_DataFactory_TEST.insertproduct2();	 
			insert prod1;
			
			PriceBook2 pb = HWS_DataFactory_TEST.createPriceBook(); 
			insert pb;   
			
			PricebookEntry pbety = HWS_DataFactory_TEST.createPriceBookEntry(prod1.id, pb.Id);	  
			pbety.CurrencyIsoCode='EUR'; 
			pbety.UseStandardPrice = false;
			pbety.Pricebook2Id = Test.getStandardPricebookId();
			insert pbety;
			
			ServiceContract sc = HWS_DataFactory_TEST.insertServiceContract(accList[0]);
			sc.Pricebook2Id = Test.getStandardPricebookId();
			sc.NCP_External_Status__c = 'Active';
			sc.CurrencyIsoCode = 'EUR';
			insert sc;
			
			Id coveredProductRecordType = HWS_Utilty.getRecordTypeByName('Asset','CH_CoveredProduct');  
			Asset covProdAsset = new Asset();
			covProdAsset.RecordTypeId = coveredProductRecordType; 
			covProdAsset.AccountId = accList[0].Id;
			covProdAsset.Product2Id = prod1.Id;
			insert covProdAsset;
			
			Id assetRecordType = HWS_Utilty.getRecordTypeByName('Asset','HWS_Covered_Part');
			Asset ast = HWS_DataFactory_TEST.insertAsset(accList[0],prod1);	 
			ast.RecordTypeId = assetRecordType; 
			insert ast; 
			
			hws_versionitem__c hwsv = HWS_DataFactory_TEST.insertHwsversionitem();
			hwsv.HWS_Serial_Number_Traceable__c='';	 
			insert hwsv;
			
			Case parentCase = new Case();
			Id parentCaseRT = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_PARENT_CASE);
			parentCase.RecordTypeId =parentCaseRT;
			parentCase.Subject='test Parent Case';
			parentCase.Description='test';
			parentCase.HWS_Faulty_Serial_Number__c= 'test1234';
			parentCase.HWS_ShipTopartyId__c='1234566';
			parentCase.AccountId = accList[0].id;
			insert parentCase;
			
			ContractLineItem cli = HWS_DataFactory_TEST.insertContractLineItem(sc,pbety);	
			cli.PricebookEntryId = pbety.id; 
			cli.CH_ServiceClassification__c = 'HWS Service';
			insert cli;
			Test.stopTest();
		}
	}
	
	@isTest
	static void testMultipleACR1() {
		User adminUser = [SELECT Id FROM User WHERE Email = 'admin@nokia.com.dev'];
		System.runAs(adminUser) {
			Map<String, String> attributes = new Map<String, String>();
			attributes.put('Lname', 'test');
			attributes.put('displayName', '1001069312');
			attributes.put('PostalCode', '98015-3090');
			attributes.put('ApprovalStatus', 'approved');
			attributes.put('P20', '204302');
			attributes.put('Fname', 'Ut2');
			attributes.put('Country', 'United States of America');
			attributes.put('Relationship', 'Customer');
			attributes.put('ALCR', '1001069312');
			attributes.put('uid', 'Ut2 test');
			attributes.put('MyAccountId', '301000609');
			attributes.put('City', 'Bellevue');
			attributes.put('emailID', 'testmultipleacr190320211514@test.com');
			attributes.put('nokiaTimeZone', '(GMT-05:00) Eastern Time (US & Canada)');
			attributes.put('Street', 'P.O. Box 52690, BELLEVUE, US');
			attributes.put('PersonalID', 'B87374789');
			attributes.put('HorizontalFlag', '0');
			attributes.put('Phone', '+11234567');
			attributes.put('Username', 'testmultipleacr190320211514@singlecrm.test.com.icport');
			attributes.put('nsnPrimaryAccountFlag', 'true');
			attributes.put('CountryCode', 'IN');
			attributes.put('CustomerName', 'T-Mobile USA');
			attributes.put('SSOPID', '1507306444');
			attributes.put('FederationID', 'B87374789');
			attributes.put('MappingId', 'B87374789');
			
			List<Account> parentAccountList = [SELECT Id, Name FROM Account WHERE Name IN ('Parent 1')];
			
			NCP_CustomerCommunityUserHandler handler = new NCP_CustomerCommunityUserHandler();
			User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			
			Case parentCase = [SELECT Id, ContactId FROM Case WHERE Subject='test Parent Case'];
			parentCase.ContactId = myUser.ContactId;
			update parentCase;
			
			attributes.put('ALCR', '1001069315');
			handler.updateUser(myUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
			
			Test.startTest();
			List<Case> caseList = [SELECT Id, Status FROM Case WHERE recordtype.name = 'NCP SSO Account Change' AND contactId = :myUser.ContactId AND accountID = :parentAccountList[0].Id AND Status = 'New' ORDER BY CreatedDate DESC];
			System.assert(caseList?.size() > 0);
			caseList[0].Status = 'Approved';
			update caseList;
			try{
				handler.updateUser(myUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
			}
			catch(Exception e){
				System.assert(e.getMessage().contains('There is an active Open S/w or H/w Case existing against the Orgranization. Requested update cannot be executed'));
			}
			Test.stopTest();
		}
	}
	
	@isTest
	static void testMultipleACR2() {
		User adminUser = [SELECT Id FROM User WHERE Email = 'admin@nokia.com.dev'];
		System.runAs(adminUser) {
			Map<String, String> attributes = new Map<String, String>();
			attributes.put('Lname', 'test');
			attributes.put('displayName', '1001069312');
			attributes.put('PostalCode', '98015-3090');
			attributes.put('ApprovalStatus', 'approved');
			attributes.put('P20', '204302');
			attributes.put('Fname', 'Ut2');
			attributes.put('Country', 'United States of America');
			attributes.put('Relationship', 'Customer');
			attributes.put('ALCR', '1001069312');
			attributes.put('uid', 'Ut2 test');
			attributes.put('MyAccountId', '301000609');
			attributes.put('City', 'Bellevue');
			attributes.put('emailID', 'testmultipleacr190320211514@test.com');
			attributes.put('nokiaTimeZone', '(GMT-05:00) Eastern Time (US & Canada)');
			attributes.put('Street', 'P.O. Box 52690, BELLEVUE, US');
			attributes.put('PersonalID', 'B87374789');
			attributes.put('HorizontalFlag', '0');
			attributes.put('Phone', '+11234567');
			attributes.put('Username', 'testmultipleacr190320211514@singlecrm.test.com.icport');
			attributes.put('nsnPrimaryAccountFlag', 'true');
			attributes.put('CountryCode', 'IN');
			attributes.put('CustomerName', 'T-Mobile USA');
			attributes.put('SSOPID', '1507306444');
			attributes.put('FederationID', 'B87374789');
			attributes.put('MappingId', 'B87374789');
			
			List<Account> parentAccountList = [SELECT Id, Name FROM Account WHERE Name IN ('Parent 1')];
			
			NCP_CustomerCommunityUserHandler handler = new NCP_CustomerCommunityUserHandler();
			User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			
			Case parentCase = [SELECT Id, ContactId FROM Case WHERE Subject='test Parent Case'];
			parentCase.ContactId = myUser.ContactId;
			update parentCase;
			
			attributes.put('ALCR', '1001069315');
			
			handler.updateUser(myUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
			Test.startTest();
			List<Case> caseList = [SELECT Id, Status FROM Case WHERE recordtype.name = 'NCP SSO Account Change' AND contactId = :myUser.ContactId AND accountID = :parentAccountList[0].Id AND Status = 'New' ORDER BY CreatedDate DESC];
			
			caseList[0].Status = 'Approved';
			update caseList;			
			delete parentCase;
			
			handler.updateUser(myUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
			Test.stopTest();
		}
	}
	
	@isTest
	static void testMultipleACR3() {
		User adminUser = [SELECT Id FROM User WHERE Email = 'admin@nokia.com.dev'];
		System.runAs(adminUser) {
			Map<String, String> attributes = new Map<String, String>();
			attributes.put('Lname', 'test');
			attributes.put('displayName', '1001069312');
			attributes.put('PostalCode', '98015-3090');
			attributes.put('ApprovalStatus', 'approved');
			attributes.put('P20', '204302');
			attributes.put('Fname', 'Ut2');
			attributes.put('Country', 'United States of America');
			attributes.put('Relationship', 'Customer');
			attributes.put('ALCR', '1001069312');
			attributes.put('uid', 'Ut2 test');
			attributes.put('MyAccountId', '301000609');
			attributes.put('City', 'Bellevue');
			attributes.put('emailID', 'testmultipleacr190320211514@test.com');
			attributes.put('nokiaTimeZone', '(GMT-05:00) Eastern Time (US & Canada)');
			attributes.put('Street', 'P.O. Box 52690, BELLEVUE, US');
			attributes.put('PersonalID', 'B87374789');
			attributes.put('HorizontalFlag', '0');
			attributes.put('Phone', '+11234567');
			attributes.put('Username', 'testmultipleacr190320211514@singlecrm.test.com.icport');
			attributes.put('nsnPrimaryAccountFlag', 'true');
			attributes.put('CountryCode', 'IN');
			attributes.put('CustomerName', 'T-Mobile USA');
			attributes.put('SSOPID', '1507306444');
			attributes.put('FederationID', 'B87374789');
			attributes.put('MappingId', 'B87374789');
			
			Test.startTest();
			NCP_CustomerCommunityUserHandler handler = new NCP_CustomerCommunityUserHandler();
			User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			
			Case parentCase = [SELECT Id, ContactId FROM Case WHERE Subject='test Parent Case'];
			parentCase.ContactId = myUser.ContactId;
			update parentCase;
			
			attributes.put('ALCR', '1001069315');
			
			handler.updateUser(myUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
			
			Test.stopTest();
		}
	}
	
	@isTest
	static void testMultipleACR4() {
		User adminUser = [SELECT Id FROM User WHERE Email = 'admin@nokia.com.dev'];
		System.runAs(adminUser) {
			Map<String, String> attributes = new Map<String, String>();
			attributes.put('Lname', 'test');
			attributes.put('displayName', '1001069312');
			attributes.put('PostalCode', '98015-3090');
			attributes.put('ApprovalStatus', 'approved');
			attributes.put('P20', '204302');
			attributes.put('Fname', 'Ut2');
			attributes.put('Country', 'United States of America');
			attributes.put('Relationship', 'Customer');
			attributes.put('ALCR', '1001069312');
			attributes.put('uid', 'Ut2 test');
			attributes.put('MyAccountId', '301000609');
			attributes.put('City', 'Bellevue');
			attributes.put('emailID', 'testmultipleacr190320211514@test.com');
			attributes.put('nokiaTimeZone', '(GMT-05:00) Eastern Time (US & Canada)');
			attributes.put('Street', 'P.O. Box 52690, BELLEVUE, US');
			attributes.put('PersonalID', 'B87374789');
			attributes.put('HorizontalFlag', '0');
			attributes.put('Phone', '+11234567');
			attributes.put('Username', 'testmultipleacr190320211514@singlecrm.test.com.icport');
			attributes.put('nsnPrimaryAccountFlag', 'true');
			attributes.put('CountryCode', 'IN');
			attributes.put('CustomerName', 'T-Mobile USA');
			attributes.put('SSOPID', '1507306444');
			attributes.put('FederationID', 'B87374789');
			attributes.put('MappingId', 'B87374789');
			
			Test.startTest();
			NCP_CustomerCommunityUserHandler handler = new NCP_CustomerCommunityUserHandler();
			User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			
			Case parentCase = [SELECT Id, ContactId FROM Case WHERE Subject='test Parent Case'];
			parentCase.ContactId = myUser.ContactId;
			update parentCase;
			
			attributes.put('ALCR', '1001069315');
			
			List<Account> parentAccountList = [SELECT Id, Name FROM Account WHERE Name IN ('Parent 1')];
			
			handler.updateUser(myUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
			List<Case> caseList = [SELECT Id, Status FROM Case WHERE recordtype.name = 'NCP SSO Account Change' AND contactId = :myUser.ContactId AND accountID = :parentAccountList[0].Id AND Status = 'New' ORDER BY CreatedDate DESC];
			caseList[0].Status = 'Closed';
			update caseList;
			
			Test.stopTest();
			
			handler.updateUser(myUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
		}
	}
	
	@isTest
	static void testMultipleACR5() {
		User adminUser = [SELECT Id FROM User WHERE Email = 'admin@nokia.com.dev'];
		System.runAs(adminUser) {
			Map<String, String> attributes = new Map<String, String>();
			attributes.put('Lname', 'test');
			attributes.put('displayName', '1001069312');
			attributes.put('PostalCode', '98015-3090');
			attributes.put('ApprovalStatus', 'approved');
			attributes.put('P20', '204302');
			attributes.put('Fname', 'Ut2');
			attributes.put('Country', 'United States of America');
			attributes.put('Relationship', 'Customer');
			attributes.put('ALCR', '1001069312');
			attributes.put('uid', 'Ut2 test');
			attributes.put('MyAccountId', '301000609');
			attributes.put('City', 'Bellevue');
			attributes.put('emailID', 'testmultipleacr190320211514@test.com');
			attributes.put('nokiaTimeZone', '(GMT-05:00) Eastern Time (US & Canada)');
			attributes.put('Street', 'P.O. Box 52690, BELLEVUE, US');
			attributes.put('PersonalID', 'B87374789');
			attributes.put('HorizontalFlag', '0');
			attributes.put('Phone', '+11234567');
			attributes.put('Username', 'testmultipleacr190320211514@singlecrm.test.com.icport');
			attributes.put('nsnPrimaryAccountFlag', 'true');
			attributes.put('CountryCode', 'IN');
			attributes.put('CustomerName', 'T-Mobile USA');
			attributes.put('SSOPID', '1507306444');
			attributes.put('FederationID', 'B87374789');
			attributes.put('MappingId', 'B87374789');
			
			Test.startTest();
			NCP_CustomerCommunityUserHandler handler = new NCP_CustomerCommunityUserHandler();
			User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			
			myUser.IsActive = false;
			update myUser;
			
			attributes.put('ALCR', '1001069315');
			
			handler.updateUser(myUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
						
			Test.stopTest();
		}
	}
	
	@isTest
	static void testMultipleACR6() {
		User adminUser = [SELECT Id FROM User WHERE Email = 'admin@nokia.com.dev'];
		System.runAs(adminUser) {
			Entitlement entiObj = new Entitlement();
			entiObj.Name ='test Entitlement';
			entiObj.AccountId = [SELECT Id FROM Account WHERE Name = 'LE customer name'].Id;
			entiObj.CH_CDB_EntitlementId__c = '1test';
			entiObj.StartDate = System.today();
			entiObj.EndDate = System.today() + 10;
			entiObj.BusinessHoursId = [select id, name from BusinessHours where IsActive = true AND IsDefault = true].Id;
			entiObj.CH_EntitlementType__c = 'Entitled Asset';
			entiObj.CH_ServiceMappingId__c = 'Legacy Customer Support Service - No Severity 24x7';
			entiobj.ServiceContractId = [SELECT Id FROM ServiceContract WHERE Name = 'test'].id;
			insert entiObj;
			
			Map<String, String> attributes = new Map<String, String>();
			attributes.put('Lname', 'test');
			attributes.put('displayName', '1001069312');
			attributes.put('PostalCode', '98015-3090');
			attributes.put('ApprovalStatus', 'approved');
			attributes.put('P20', '204302');
			attributes.put('Fname', 'Ut2');
			attributes.put('Country', 'United States of America');
			attributes.put('Relationship', 'Customer');
			attributes.put('ALCR', '1001069312');
			attributes.put('uid', 'Ut2 test');
			attributes.put('MyAccountId', '301000609');
			attributes.put('City', 'Bellevue');
			attributes.put('emailID', 'testmultipleacr190320211514@test.com');
			attributes.put('nokiaTimeZone', '(GMT-05:00) Eastern Time (US & Canada)');
			attributes.put('Street', 'P.O. Box 52690, BELLEVUE, US');
			attributes.put('PersonalID', 'B87374789');
			attributes.put('HorizontalFlag', '0');
			attributes.put('Phone', '+11234567');
			attributes.put('Username', 'testmultipleacr190320211514@singlecrm.test.com.icport');
			attributes.put('nsnPrimaryAccountFlag', 'true');
			attributes.put('CountryCode', 'IN');
			attributes.put('CustomerName', 'T-Mobile USA');
			attributes.put('SSOPID', '1507306444');
			attributes.put('FederationID', 'B87374789');
			attributes.put('MappingId', 'B87374789');
			
			Test.startTest();
			NCP_CustomerCommunityUserHandler handler = new NCP_CustomerCommunityUserHandler();
			User myUser = handler.createUser(null, COMMUNITY_ID, null, '', attributes, '');
			
			myUser.IsActive = false;
			update myUser;
			
			attributes.put('ALCR', '1001069315');
			
			handler.updateUser(myUser.Id, null, COMMUNITY_ID, null, '', attributes, '');
						
			Test.stopTest();
		}
	}
}