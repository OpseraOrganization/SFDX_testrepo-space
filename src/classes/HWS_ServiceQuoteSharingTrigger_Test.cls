/****************************************************************
* Class Name : HWS_ServiceQuoteSharingTrigger_Test  
* Created Date: 05-11-2021   
* Created By: NOKIA
* Description : Test class for HWS_ServiceQuoteSharingTrigger,
HWS_ServiceQuoteSharingTriggerHandler,HWS_ServiceQuoteSharingTriggerHelper,
HWS_ServiceQuoteAssignmentHelper
* Modification Log:
---------------------------------------------------------
Modified By	 Modified For US#	Modified Date

******************************************************************/
@isTest
public class HWS_ServiceQuoteSharingTrigger_Test {
	@testSetup
	public static void createTestData(){
		CH_UTIL_TEST.createNokiaUsers();
		HWS_GenericSettings__c cs = new HWS_GenericSettings__c() ;
		cs.Name='OrderedProcessingSize';
		cs.HWS_Field1__c = '25';
		insert cs;
			
		Id accountRecordType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LOGISTIC_ACCOUNT_EXISTING);
		Id legalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		Id childcase = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Child_Case_Read_Only);
		Id parentCaseRecordType = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Parent_Case);
		Test.startTest();
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
		//inserting service contract
		 Date now = Date.today();
			Id chContractRecordTypeId = Schema.SObjectType.ServiceContract.getRecordTypeInfosByDeveloperName().get('CH_ServiceContract').getRecordTypeId();
		ServiceContract serviceContract = new ServiceContract(
			AccountId = legalAcc.Id, 
			Name = 'TestServiceContract',
			CurrencyIsoCode = 'EUR',
			CH_CDB_ContractId__c = '12345',
			StartDate = now.AddDays(-5),
			EndDate = now.AddDays(5),
			Pricebook2Id = Test.getStandardPricebookId()
		);
		Insert serviceContract;
		serviceContract.RecordTypeId = chContractRecordTypeId;
		update serviceContract;
		Contact conObj = HWS_DataFactory_TEST.insertContact();
		insert conObj;
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
		//insert child case
		
		Case cas = new Case();
		cas.RecordTypeId = childcase;
		cas.ParentId = ca.Id;
		cas.AccountId = legalAcc.Id;
		cas.Hws_Ship_to_Party_Address__c= acc1.Id;
		cas.HWS_Faulty_Serial_Number__c = '1234'; 
		cas.HWS_FaultyUnitMaterialCode__c = '4567';
		cas.HWS_Shippeddate__c= system.today();
		cas.HWS_LSP_Courier_Name__c = 'Test123';
		cas.HWS_TotalShippedQuantity__c = 1234;
		cas.Describe__c = 'Test description';
		cas.HWS_Bar_Code__c = 'Test data111';
		cas.HWS_Bar_Code_Ref1__c = HWS_Constants.Test123;	
		cas.NCP_Service_Contract__c=serviceContract.Id;
		insert cas;	
		Test.stopTest();
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
		HWS_DataFactory_TEST.createSuspensionRecord(2,true,serviceContract.Id,conObj.Id);
	}
	public static testmethod void testAutoAssignSME2WorkgroupsDamaged(){
		Id dpqRecordTypeId = HWS_Utilty.getRecordTypeByName('HWS_Service_Quote__c','HWS_Damaged_Part_Quote');
		Id childcase = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Child_Case_Read_Only);
		Case cas = [SELECT Id FROM Case WHERE RecordTypeId =: childcase LIMIT 1];
		HWS_Suspension__c suspensionRec = [SELECT Id FROM HWS_Suspension__c LIMIT 1];
		CH_Workgroup__c cdmWg = [SELECT Id,Name,CH_Type__c FROM CH_Workgroup__c WHERE Name='HWS_EQS-CDM_CDM_NAM_US' LIMIT 1];
		List<HWS_Service_Quote__c> damagedServiceQuoteList = HWS_DataFactory_TEST.createServiceQuote(1,dpqRecordTypeId,false,cas.Id);
		damagedServiceQuoteList[0].HWS_Workgroup__c = cdmWg.Id;
		damagedServiceQuoteList[0].HWS_Suspension__c = suspensionRec.Id;
		insert damagedServiceQuoteList;
		Test.startTest();
		damagedServiceQuoteList[0].HWS_Quote_Status__c = 'Accepted by CDM';
		update damagedServiceQuoteList;
		Test.stopTest();
		HWS_Service_Quote__c updatedServiceQuote = [SELECT Id,HWS_WorkGroupType__c FROM HWS_Service_Quote__c WHERE Id = : damagedServiceQuoteList[0].Id];
		System.assert(updatedServiceQuote.HWS_WorkGroupType__c == 'Exclusions Quotation Support-OC');
	}
	public static testmethod void testAutoAssignSME2WorkgroupsUnreturned(){
		Id unreturnedRecordTypeId = HWS_Utilty.getRecordTypeByName('HWS_Service_Quote__c','HWS_UnReturned_Part_Quote');
		Id childcase = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Child_Case_Read_Only);
		Case cas = [SELECT Id FROM Case WHERE RecordTypeId =: childcase LIMIT 1];
		CH_Workgroup__c cdmWg = [SELECT Id,Name,CH_Type__c FROM CH_Workgroup__c WHERE Name='HWS_EQS-CDM_CDM_NAM_US' LIMIT 1];
		Test.startTest();
		List<HWS_Service_Quote__c> unreturnedServiceQuoteList = HWS_DataFactory_TEST.createServiceQuote(1,unreturnedRecordTypeId,false,cas.Id);
		unreturnedServiceQuoteList[0].HWS_Workgroup__c = cdmWg.Id;
		unreturnedServiceQuoteList[0].HWS_TriggerOCWorkgroupAssignment__c = false;
		insert unreturnedServiceQuoteList;
		
		unreturnedServiceQuoteList[0].HWS_Quote_Status__c = 'Accepted by CDM';
		unreturnedServiceQuoteList[0].HWS_TriggerOCWorkgroupAssignment__c = true;
		update unreturnedServiceQuoteList;
		
		HWS_Service_Quote__c updatedServiceQuote = [SELECT Id,HWS_WorkGroupType__c FROM HWS_Service_Quote__c WHERE Id = : unreturnedServiceQuoteList[0].Id];
		System.assert(updatedServiceQuote.HWS_WorkGroupType__c == 'Exclusions Quotation Support-OC');
		try{
			unreturnedServiceQuoteList[0].HWS_TriggerOCWorkgroupAssignment__c = true;
			update unreturnedServiceQuoteList;
		}
		catch(Exception e){
			System.assert(e.getMessage().contains(System.Label.HWS_Prevent_Manual_OC_WG_Assignemnt_Warning));
		}
		Test.stopTest();
	}

	public static testmethod void testAutoAssignInitialWorkgroupsDamaged(){
		Id dpqRecordTypeId = HWS_Utilty.getRecordTypeByName('HWS_Service_Quote__c','HWS_Damaged_Part_Quote');
		Id childcase = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Child_Case_Read_Only);
		Case cas = [SELECT Id FROM Case WHERE RecordTypeId =: childcase LIMIT 1];
		List<HWS_Service_Quote__c> damagedServiceQuoteList = HWS_DataFactory_TEST.createServiceQuote(1,dpqRecordTypeId,true,cas.Id);
		Test.startTest();
		damagedServiceQuoteList[0].HWS_Quote_Status__c = 'Cancelled';
		update damagedServiceQuoteList;
		Test.stopTest();
		HWS_Service_Quote__c updatedServiceQuote = [SELECT Id,HWS_WorkGroupType__c FROM HWS_Service_Quote__c WHERE Id =: damagedServiceQuoteList[0].Id];
		System.assert(updatedServiceQuote.HWS_WorkGroupType__c == 'Exclusions Quotation Support-CDM');
	}
	
	
	public static testmethod void testSharingRuleInsert(){
		Id dpqRecordTypeId = HWS_Utilty.getRecordTypeByName('HWS_Service_Quote__c','HWS_Damaged_Part_Quote');
		Id childcase = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Child_Case_Read_Only);
		Case cas = [SELECT Id FROM Case WHERE RecordTypeId =: childcase LIMIT 1];
		List<HWS_Service_Quote__c> damagedServiceQuoteList = HWS_DataFactory_TEST.createServiceQuote(1,dpqRecordTypeId,true,cas.Id);
		Test.startTest();
		damagedServiceQuoteList[0].HWS_Quote_Sent_Date__c = system.today();
		update damagedServiceQuoteList;
		Test.stopTest();
		
		HWS_Service_Quote__Share quoteShare = [select Id, ParentId from HWS_Service_Quote__Share where ParentId =:damagedServiceQuoteList[0].Id];
		System.assert(quoteShare.ParentId == damagedServiceQuoteList[0].Id);	
	}
	
	public static testmethod void testSharingRuleUpdate(){
		Id dpqRecordTypeId = HWS_Utilty.getRecordTypeByName('HWS_Service_Quote__c','HWS_Damaged_Part_Quote');
		Id childcase = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Child_Case_Read_Only);
		Case cas = [SELECT Id FROM Case WHERE RecordTypeId =: childcase LIMIT 1];
		List<HWS_Service_Quote__c> damagedServiceQuoteList = HWS_DataFactory_TEST.createServiceQuote(1,dpqRecordTypeId,false,cas.Id);
		
		List<user> contactUsers = [select Id, Email,ContactId from User where ContactId != null and IsActive = true limit 2];
		damagedServiceQuoteList[0].HWS_Customer_ContactId_1__c = contactUsers[0].ContactId;
		insert damagedServiceQuoteList; 
		Test.startTest();
		damagedServiceQuoteList[0].HWS_Quote_Sent_Date__c = system.today();
		damagedServiceQuoteList[0].HWS_Customer_ContactId_1__c = contactUsers[1].ContactId;
		update damagedServiceQuoteList;
		System.debug('the quote' + damagedServiceQuoteList[0]);
		Test.stopTest();
		List<HWS_Service_Quote__Share> quoteShare = [select Id, ParentId, UserOrGroupId,RowCause from HWS_Service_Quote__Share where ParentId =:damagedServiceQuoteList[0].Id AND AccessLevel ='Edit'];
		System.assert(quoteShare[0].RowCause == Schema.HWS_Service_Quote__Share.RowCause.SVQ_Portal_User__C);	
	}
	
	public static testmethod void testSharingRuleUpdate2(){
		Id dpqRecordTypeId = HWS_Utilty.getRecordTypeByName('HWS_Service_Quote__c','HWS_Damaged_Part_Quote');
		Id childcase = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Child_Case_Read_Only);
		Case cas = [SELECT Id FROM Case WHERE RecordTypeId =: childcase LIMIT 1];
		List<HWS_Service_Quote__c> damagedServiceQuoteList = HWS_DataFactory_TEST.createServiceQuote(1,dpqRecordTypeId,false,cas.Id);
	  
		List<user> contactUsers = [select Id, Email,ContactId from User where ContactId != null and IsActive = true limit 4];
		damagedServiceQuoteList[0].HWS_Customer_ContactId_1__c = contactUsers[0].ContactId;
		damagedServiceQuoteList[0].HWS_Customer_ContactId2__c = contactUsers[1].ContactId;
		insert damagedServiceQuoteList; 
		Test.startTest();
		damagedServiceQuoteList[0].HWS_Customer_ContactId_1__c = contactUsers[2].ContactId;
		damagedServiceQuoteList[0].HWS_Customer_ContactId2__c = contactUsers[3].ContactId;
		update damagedServiceQuoteList;
		Test.stopTest();	
	}
	
	public static testmethod void suspensionTest(){
		Id dpqRecordTypeId = HWS_Utilty.getRecordTypeByName('HWS_Service_Quote__c','HWS_Damaged_Part_Quote');
		Id childcase = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Child_Case_Read_Only);
		Contact con = [SELECT Id FROM Contact LIMIT 1];
		Case cas = [SELECT Id,ContactId FROM Case WHERE RecordTypeId =: childcase LIMIT 1];
		cas.ContactId = con.Id;
		update cas;
		CH_Workgroup__c cdmWg = [SELECT Id,Name,CH_Type__c FROM CH_Workgroup__c WHERE Name='HWS_EQS-CDM_CDM_NAM_US' LIMIT 1];
		List<HWS_Service_Quote__c> damagedServiceQuoteList = HWS_DataFactory_TEST.createServiceQuote(1,dpqRecordTypeId,false,cas.Id);
		damagedServiceQuoteList[0].HWS_Workgroup__c = cdmWg.Id;
		damagedServiceQuoteList[0].HWS_WorkGroupType__c = 'Exclusions Quotation Support-CDM';
		damagedServiceQuoteList[0].HWS_WorkgroupName__c = cdmWg.Name;
		insert damagedServiceQuoteList;
		Test.startTest();
		damagedServiceQuoteList[0].HWS_Is_Quote_Expired__c = true;
		damagedServiceQuoteList[0].HWS_Is_Quotable__c='Yes';
		damagedServiceQuoteList[0].HWS_Quote_Status__c = 'Rejected by CDM';
		update damagedServiceQuoteList;
		Test.stopTest();
	}
	
	
}