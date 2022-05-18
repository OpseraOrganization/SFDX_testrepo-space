/********************************************************************************
* Name : HWS_EmailNotifications_Test 
* Description : Test class for HWS_EmailNotifications

********************************************************************************/
@isTest
public class HWS_EmailNotifications_Test { 
	public static testmethod void pendingReferralFMARCAEmailTest(){		
	   Test.startTest();
		Map<String, String> fieldsMap = new Map<String, String>();
		insert new Global_Control__c(ObjectTriggerByPass__c='ACCT, CNTCT, Product, Asset, Case, SVCNTRT,cli');
		Set<Id> parentCaseIdSet = new Set<Id>();
		Set<Id> childCaseIdSet = new Set<Id>();
		 
		List<Account> parentAccountList= HWS_TestFactoryDefaults.createAccountData(true, 1, 'Legal_Entity');
		fieldsMap.put('AccountId', parentAccountList[0].ParentId); 
		List<Contact> contactList = HWS_TestFactoryDefaults.createContact(true, 1, null, fieldsMap);
		fieldsMap.put('contactId', contactList[0].Id);
		List<Servicecontract>  newServiceContract = HWS_TestFactoryDefaults.createServiceContractData(true, 1, fieldsMap);
		fieldsMap.put('ServiceContractId', newServiceContract[0].Id);
		String productId = HWS_TestFactoryDefaults.createProductDataSetUp( true,  1, fieldsMap)[0].Id;
		fieldsMap.put('Product2Id',productId);
		string pricebookEntryId = HWS_TestFactoryDefaults.createPriceBookEntry(  true, fieldsMap)[0].Id;
		fieldsMap.put('pricebookEntryId',pricebookEntryId);
		List<ContractLineItem> cli = HWS_TestFactoryDefaults.createContractLineItemData(true,1,fieldsMap );
		fieldsMap.put('ContractLineItemid',cli[0].Id);
		List<Asset> astList =  HWS_TestFactoryDefaults.createAssetData(true, 1,'HWS_Covered_Part', fieldsMap);
		  
		astList[0].HWS_ContractLeadTimeDuration__c = 'test';
		fieldsMap.put('AssetId',astList[0].id);
		List<HWS_VersionItem__c> version = HWS_TestFactoryDefaults.createVerionsItems(true, 1, fieldsMap);
		fieldsMap.put('versionItemId',version[0].id);
		Case ParentCase= HWS_TestFactoryDefaults.insertParentCase(true, fieldsMap);
		ParentCase.CH_InternalStatus__c = 'Pending Referral Instruction';
		update ParentCase;
		fieldsMap.put('ParentCase', ParentCase.Id);
		parentCaseIdSet.add(ParentCase.Id);
		List<Case>  ChildCase= HWS_TestFactoryDefaults.insertChildCase(true,1,'HWS_Advance_Exchange_In_Hours', fieldsMap);
		ChildCase[0].Status='Ordered';
		ChildCase[0].HWS_Faulty_Serial_Number__c='';
		ChildCase[0].HWS_RequestHWRCAFMA__c=true;
		ChildCase[0].HWS_RelatedSoftwareTicketNumber__c='12345';
		ChildCase[0].HWS_Sponsor__c = 'Test Sponsor';
		update ChildCase;
		fieldsMap.put('childcaseId', ChildCase[0].Id);
		childCaseIdSet.add(ChildCase[0].Id);	   
		HWS_EmailNotifications.pendingReferralInstructionsEmail(parentCaseIdSet,'Waiting for Referral Instruction');
		HWS_EmailNotifications.RequestHWFMARCA(childCaseIdSet);
		HWS_EmailNotifications.workgroupEmailAssignment(ChildCase[0].ParentId, 'Test',null,null);
		HWS_EmailNotifications emailNots = new HWS_EmailNotifications();
		emailNots.parentCaseRecId = ChildCase[0].ParentId;
		emailNots.getCases();
		HWS_EmailNotifications.workgroupEmailAssignment(ChildCase[0].ParentId, 'HWS Pending Order Summary Manual Split',null,null);
		emailNots.entExceptionCheck = true;
		emailNots.getCases();
		HWS_EmailNotifications.workgroupEmailAssignment(ChildCase[0].ParentId, 'HWS Order Acknowledgement Escalated Case',null,null);
		emailNots.entExceptionCheck = true;
		emailNots.alertType = 'HWS Order Acknowledgement Escalated Case';
		emailNots.getCases();
		Test.stopTest(); 
		HWS_DataFactory_TEST.createWGSetupServiceQuote();
		CH_Workgroup__c cdmWg = [SELECT Id,Name,CH_Type__c FROM CH_Workgroup__c WHERE Name='HWS_EQS-CDM_CDM_NAM_US' LIMIT 1];
		Id dpqRecordTypeId = HWS_Utilty.getRecordTypeByName('HWS_Service_Quote__c','HWS_Damaged_Part_Quote');
		List<HWS_Service_Quote__c> damagedServiceQuoteList = HWS_DataFactory_TEST.createServiceQuote(1,dpqRecordTypeId,false,ChildCase[0].Id);
		damagedServiceQuoteList[0].HWS_Workgroup__c = cdmWg.Id;
		insert damagedServiceQuoteList;
		HWS_EmailNotifications.serviceQuoteWGAssignmentEmail(damagedServiceQuoteList);
		HWS_EmailNotifications.ownerReAssignmentEmail(new List<Id>{damagedServiceQuoteList[0].Id});
		HWS_EmailNotifications clsObj= new HWS_EmailNotifications();
		clsObj.quotationId = damagedServiceQuoteList[0].Id;
		clsObj.getQuotation();
	}	
}