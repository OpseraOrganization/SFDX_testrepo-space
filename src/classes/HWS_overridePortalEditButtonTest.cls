@isTest
public class HWS_overridePortalEditButtonTest {
	
 @isTest
	public static void EditCase(){
	Test.startTest();
		Map<String, String> fieldsMap = new Map<String, String>();
		insert new Global_Control__c(ObjectTriggerByPass__c='ACCT, CNTCT, Product, Asset, Case, SVCNTRT,cli');
		
		Account legalAcc = HWS_DataFactory_TEST.insertAccount(); 
		legalAcc.Type = 'Vendor';
		insert legalAcc;
		
		List<Account> parentAccountList= HWS_TestFactoryDefaults.createAccountData(true, 1, 'Legal_Entity');
		fieldsMap.put('AccountId', parentAccountList[0].ParentId); 
		List<Contact> contactList = HWS_TestFactoryDefaults.createContact(true, 1, null, fieldsMap);
		fieldsMap.put('contactId', contactList[0].Id);
		
	
		Id rtId = Schema.SObjectType.ServiceContract.getRecordTypeInfosByDeveloperName().get('CH_VendorContract').getRecordTypeId();
		ServiceContract sc = HWS_DataFactory_TEST.insertServiceContract(legalAcc);
		sc.Pricebook2Id = Test.getStandardPricebookId();
		sc.NCP_External_Status__c = 'Active';
		sc.CurrencyIsoCode = 'EUR';
		sc.recordTypeId = rtId;
		sc.StartDate=System.today().addDays(-2);
		sc.EndDate=System.today().addDays(2);
		insert sc;
		fieldsMap.put('ServiceContractId', sc.Id);
		
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
		fieldsMap.put('caseId', ParentCase.Id);
		List<Case>  ChildCase= HWS_TestFactoryDefaults.insertChildCase(true,1,'HWS_Advance_Exchange_In_Hours', fieldsMap);
		ChildCase[0].ParentId = ParentCase.Id;
		update ChildCase[0];
		fieldsMap.put('childcaseId', ChildCase[0].Id);
		 HWS_overridePortalEditButton.customerPoHide(ParentCase.Id);
		 HWS_overridePortalEditButton.getCaseInfo(ParentCase.Id);
		 HWS_overridePortalEditButton.editCase(ChildCase[0]);
		 
		Test.stopTest(); 
	}
}