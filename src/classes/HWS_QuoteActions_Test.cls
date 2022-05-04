/****************************************************************
* Class Name : HWS_QuoteActions_Test 
* Created Date: 02-11-2021
* Created By: TCS
* Description : Test class for HWS_QuoteActions
* Modification Log:
---------------------------------------------------------
Modified By	 Modified For US#	Modified Date

******************************************************************/
@isTest
private class HWS_QuoteActions_Test {
	@testSetup static void testDataSetup(){
		HWS_GenericSettings__c cs = new HWS_GenericSettings__c();
		cs.Name='OrderedProcessingSize';
		cs.HWS_Field1__c = '25';
		insert cs ;
		insert new Global_Control__c(ObjectTriggerByPass__c='Asset,ACCT,CNTCT,ACC_CNTCT_REL,USER,SVCNTRT,ASSET,PRODUCT,CLI,ENT,ACCT, CNTCT, Product,cli,PROD2');
			
		Id accountRecordType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LOGISTIC_ACCOUNT_EXISTING);
		Id legalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		Id childcase = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Child_Case_Read_Only);
		Id parentCaseRecordType = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Parent_Case);
		
		Account acc = HWS_DataFactory_TEST.insertAccount();
		acc.name='test1';
		acc.Customer_Compliance__c ='US_Govern';
		insert acc;
		Account legalAcc = HWS_DataFactory_TEST.insertAccount(); 
		legalAcc.RecordTypeId =  legalEntityAccountType;
		legalAcc.ParentId = Acc.Id;
		legalAcc.Type = 'Vendor';
		insert legalAcc;
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
		//insert parent case																		   
		Case ca = new Case();
		ca.RecordTypeId = parentCaseRecordType;
		ca.AccountId = legalAcc.Id;
		ca.Hws_Ship_to_Party_Address__c= acc1.Id;
		ca.Status='Closed';
		ca.Subject='Test Subject';
		ca.Description='test Description';
		ca.HWS_ShipTopartyId__c='1234566';
		ca.Describe__c = 'Test description3';
		ca.Country__c ='United States of America';						   
		insert ca;
		Product2 prod = HWS_DataFactory_TEST.insertproduct2();
		prod.ProductCode = '1234';
		insert prod;
		//insert child case
		Case cas = new Case();
		cas.RecordTypeId = childcase;
		cas.ParentId = ca.Id;
		cas.AccountId = legalAcc.Id;
		cas.Hws_Ship_to_Party_Address__c= acc1.Id;
		cas.HWS_Faulty_Serial_Number__c = '1234'; 
		cas.HWS_Sellable_Product__c = prod.Id;
		cas.HWS_FaultyUnitMaterialCode__c = '4567';
		cas.HWS_Shippeddate__c= system.today();
		cas.HWS_LSP_Courier_Name__c = 'Test123';
		cas.HWS_TotalShippedQuantity__c = 1234;
		cas.Describe__c = 'Test description';
		cas.HWS_Bar_Code__c = 'Test data111';
		cas.HWS_Bar_Code_Ref1__c = HWS_Constants.Test123;							   
		insert cas;
		List<User> userList = new List<User>();

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
		userList.add(queueUser);
		User newUser = new User();
		newUser.alias = 'AccOwner';
		newUser.email = 'testgmail1@mail.com';
		newUser.emailencodingkey = 'UTF-8';
		newUser.lastname = 'ACCOUNTOWNER';
		newUser.languagelocalekey = 'en_US';
		newUser.localesidkey = 'en_US';
		newUser.profileid = UserInfo.getProfileId();
		newUser.Country__c = 'Canada';
		newUser.timezonesidkey = 'America/Los_Angeles';
		newUser.Username = 'testgmail2345@randomemail.com1234';
		userList.add(newUser);
		insert userList;

		HWS_DataFactory_TEST.createWGSetupServiceQuote();
	}
	@isTest
	static void TestsyncPriceAction() {
		Id dpqRecordTypeId = HWS_Utilty.getRecordTypeByName('HWS_Service_Quote__c','HWS_Damaged_Part_Quote');
		Id childcase = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Child_Case_Read_Only);
		Case cas = [SELECT Id FROM Case WHERE RecordTypeId =: childcase LIMIT 1];
		CH_Workgroup__c cdmWg = [SELECT Id,Name,CH_Type__c FROM CH_Workgroup__c WHERE Name='HWS_EQS-CDM_CDM_NAM_US' LIMIT 1];
		List<HWS_Service_Quote__c> damagedServiceQuoteList = HWS_DataFactory_TEST.createServiceQuote(1,dpqRecordTypeId,false,cas.Id);
		damagedServiceQuoteList[0].HWS_Workgroup__c = cdmWg.Id;
		insert damagedServiceQuoteList;
		Test.startTest();
		try{
			HWS_QuoteActions.syncPriceAction(damagedServiceQuoteList[0].id);
		}
		catch(Exception e){
			System.debug(e.getMessage());
		}
		Test.stopTest();
	}
	@isTest
	static void testAcceptOwnerShipNoWGFound() {
		Id dpqRecordTypeId = HWS_Utilty.getRecordTypeByName('HWS_Service_Quote__c','HWS_Damaged_Part_Quote');
		Id childcase = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Child_Case_Read_Only);
		Case cas = [SELECT Id FROM Case WHERE RecordTypeId =: childcase LIMIT 1];
		List<HWS_Service_Quote__c> damagedServiceQuoteList = HWS_DataFactory_TEST.createServiceQuote(1,dpqRecordTypeId,true,cas.Id);
		Test.startTest();
		try{
			HWS_QuoteActions.acceptOwnerShip(damagedServiceQuoteList[0].Id);
		}
		catch(Exception e){
			System.debug(e.getMessage());
		}
		Test.stopTest();
	}
	@isTest
	static void testAcceptOwnerShipNotWGMember() {
		Id dpqRecordTypeId = HWS_Utilty.getRecordTypeByName('HWS_Service_Quote__c','HWS_Damaged_Part_Quote');
		Id childcase = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Child_Case_Read_Only);
		Case cas = [SELECT Id FROM Case WHERE RecordTypeId =: childcase LIMIT 1];
		CH_Workgroup__c cdmWg = [SELECT Id,Name,CH_Type__c FROM CH_Workgroup__c WHERE Name='HWS_EQS-CDM_CDM_NAM_US' LIMIT 1];
		List<HWS_Service_Quote__c> damagedServiceQuoteList = HWS_DataFactory_TEST.createServiceQuote(1,dpqRecordTypeId,false,cas.Id);
		damagedServiceQuoteList[0].HWS_Workgroup__c = cdmWg.Id;
		insert damagedServiceQuoteList;
		User unknownUser = [SELECT Id FROM User WHERE LastName = 'CH Queue' LIMIT 1];
		Test.startTest();
		try{
			System.runAs(unknownUser){
				HWS_QuoteActions.acceptOwnerShip(damagedServiceQuoteList[0].Id);
			}
		}
		catch(Exception e){
			System.debug(e.getMessage());
		}
		Test.stopTest();
	}
	@isTest
	static void testAcceptOwnerShipUpdate() {
		Id dpqRecordTypeId = HWS_Utilty.getRecordTypeByName('HWS_Service_Quote__c','HWS_Damaged_Part_Quote');
		Id childcase = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Child_Case_Read_Only);
		Case cas = [SELECT Id FROM Case WHERE RecordTypeId =: childcase LIMIT 1];
		CH_Workgroup__c cdmWg = [SELECT Id,Name,CH_Type__c FROM CH_Workgroup__c WHERE Name='HWS_EQS-CDM_CDM_NAM_US' LIMIT 1];
		Id CH_CA_Workgroup_Member = Schema.SObjectType.CH_Workgroup_Member__c.getRecordTypeInfosByDeveloperName().get('CH_CA_WorkgroupMember').getRecordTypeId();
		List<CH_Workgroup_Member__c> newWorkgroupMembers = new List<CH_Workgroup_Member__c>();
		CH_Workgroup_Member__c member = new CH_Workgroup_Member__c ();
		member.Name = 'Quotation Manager';
		member.CH_User__c = UserInfo.getUserId();
		member.CH_Role__c = 'WG Manager-Quotation Manager';
		member.CH_Workgroup_Member_Type__c = 'User';
		member.CH_Workgroup__c = cdmWg.Id;
		member.RecordTypeId = CH_CA_Workgroup_Member;
		newWorkgroupMembers.add(member);
		insert newWorkgroupMembers;

		User chQueueUsr = [SELECT Id FROM User WHERE alias='CHQueueU' LIMIT 1];
		List<HWS_Service_Quote__c> damagedServiceQuoteList = HWS_DataFactory_TEST.createServiceQuote(1,dpqRecordTypeId,false,cas.Id);
		damagedServiceQuoteList[0].HWS_Workgroup__c = cdmWg.Id;
		damagedServiceQuoteList[0].OwnerId = chQueueUsr.Id;
		insert damagedServiceQuoteList;
		
		Test.startTest();
		try{
			HWS_QuoteActions.acceptOwnerShip(damagedServiceQuoteList[0].Id);
			HWS_QuoteActions.updateOwnership(UserInfo.getName(),'WG Manager-Quotation Manager',damagedServiceQuoteList[0].Id,cdmWg.Id);
			HWS_QuoteActions.acceptOwnerShip(damagedServiceQuoteList[0].Id);
		}
		catch(Exception e){
			System.debug(e.getMessage());
		}
		Test.stopTest();
	}
	@isTest
	static void testAcceptOwnerShipUpdateWarning() {
		Id dpqRecordTypeId = HWS_Utilty.getRecordTypeByName('HWS_Service_Quote__c','HWS_Damaged_Part_Quote');
		Id childcase = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Child_Case_Read_Only);
		Case cas = [SELECT Id FROM Case WHERE RecordTypeId =: childcase LIMIT 1];
		CH_Workgroup__c cdmWg = [SELECT Id,Name,CH_Type__c FROM CH_Workgroup__c WHERE Name='HWS_EQS-CDM_CDM_NAM_US' LIMIT 1];
		Id CH_CA_Workgroup_Member = Schema.SObjectType.CH_Workgroup_Member__c.getRecordTypeInfosByDeveloperName().get('CH_CA_WorkgroupMember').getRecordTypeId();
		List<CH_Workgroup_Member__c> newWorkgroupMembers = new List<CH_Workgroup_Member__c>();
		User accUsr = [SELECT Id FROM User WHERE LastName = 'ACCOUNTOWNER' LIMIT 1];
		CH_Workgroup_Member__c member = new CH_Workgroup_Member__c ();
		member.Name = 'Quotation Manager';
		member.CH_User__c = accUsr.Id;
		member.CH_Role__c = 'Engineer';
		member.CH_Workgroup_Member_Type__c = 'User';
		member.CH_Workgroup__c = cdmWg.Id;
		member.RecordTypeId = CH_CA_Workgroup_Member;
		newWorkgroupMembers.add(member);
		insert newWorkgroupMembers;
		List<HWS_Service_Quote__c> damagedServiceQuoteList = HWS_DataFactory_TEST.createServiceQuote(1,dpqRecordTypeId,false,cas.Id);
		damagedServiceQuoteList[0].HWS_Workgroup__c = cdmWg.Id;
		damagedServiceQuoteList[0].OwnerId = UserInfo.getUserId();
		insert damagedServiceQuoteList;
		Test.startTest();
		try{
			System.runAs(accUsr){
				HWS_QuoteActions.acceptOwnerShip(damagedServiceQuoteList[0].Id);
			}
		}
		catch(Exception e){
			System.debug(e.getMessage());
		}
		Test.stopTest();
	}
	@isTest
	static void testgetValidUser() {
		Id dpqRecordTypeId = HWS_Utilty.getRecordTypeByName('HWS_Service_Quote__c','HWS_Damaged_Part_Quote');
		Id childcase = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Child_Case_Read_Only);
		Case cas = [SELECT Id FROM Case WHERE RecordTypeId =: childcase LIMIT 1];
		CH_Workgroup__c cdmWg = [SELECT Id,Name,CH_Type__c FROM CH_Workgroup__c WHERE Name='HWS_EQS-CDM_CDM_NAM_US' LIMIT 1];
		List<HWS_Service_Quote__c> damagedServiceQuoteList = HWS_DataFactory_TEST.createServiceQuote(1,dpqRecordTypeId,false,cas.Id);
		damagedServiceQuoteList[0].HWS_Workgroup__c = cdmWg.Id;
		insert damagedServiceQuoteList;
		Test.startTest();
		try{
			HWS_QuoteActions.getValidUser(damagedServiceQuoteList[0].Id);
		}
		catch(Exception e){
			System.debug(e.getMessage());
		}
		
		Test.stopTest();
	}
	@isTest
	static void testGetWgMemberDetails(){
		CH_Workgroup__c wgObj = [SELECT Id FROM CH_Workgroup__c WHERE CH_Type__c = 'Exclusions Quotation Support-CDM' LIMIT 1];
		Test.startTest();
		try{
			HWS_QuoteActions.getWgMemberDetails(wgObj.Id);
		}
		catch(Exception e){
			System.debug(e.getMessage());
		}
		Test.stopTest();
	}
}