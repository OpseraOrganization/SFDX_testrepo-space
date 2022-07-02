@istest
Public Class HWS_CancelCase_TEST{
	Public Static testmethod void cancelChildCasesTest(){
	   Map<String, String> fieldsMap = new Map<String, String>();
		insert new Global_Control__c(ObjectTriggerByPass__c='ACCT, CNTCT, Product, Asset');
	   
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
		fieldsMap.put('AssetId',astList[0].id);
		List<HWS_VersionItem__c> version = HWS_TestFactoryDefaults.createVerionsItems(true, 1, fieldsMap);
		fieldsMap.put('versionItemId',version[0].id);
		Case ParentCase= HWS_TestFactoryDefaults.insertParentCase(true, fieldsMap);
		fieldsMap.put('ParentCase', ParentCase.Id);
		List<Case>  ChildCase= HWS_TestFactoryDefaults.insertChildCase(true,1,'HWS_Advance_Exchange_In_Hours', fieldsMap);
		ChildCase[0].HWS_ServiceType__c = 'Advanced Exchange in Hours';
		ChildCase[0].HWS_RequestHWRCAFMA__c = false;
		ChildCase[0].HWS_RelatedSoftwareTicketNumber__c = '';
		ChildCase[0].status = 'Ordered';
		update ChildCase;
		fieldsMap.put('childcaseId', ChildCase[0].Id);
		test.startTest();
		Test.setMock(HttpCalloutMock.class, new HWS_CancelSRHttpCalloutMock()); 
		HWS_CancelCase.cancelChildCases(ParentCase.Id,'Requested by customer','Test');
		HWS_CancelCase_Portal.getCancellationStatus(ParentCase.Id);
		HWS_CancelCase_Portal.getCancellationStatus('');
		HWS_CancelCase_Portal.cancelChildCases(ParentCase.Id);
		test.stopTest();
	}  
}