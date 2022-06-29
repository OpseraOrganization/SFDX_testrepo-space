/****************************************
* Class Name : HWS_SupplierInstructions_Controller_Test
* User Story :NOKIASC-31226
* Created Date:24 Sept 2020
* Created By : TCS
* Last Modified by: 
* Last Modified Date:
* Description : Test Class for HWS_SupplierInstructions_Controller
*****************************************/
@isTest
public class HWS_SupplierInstructions_Controller_Test {
	@testSetup static void testDataSetup(){
	   
		Map<String, String> fieldsMap = new Map<String, String>();	
		List<ISO_Country_Codes__c> countryCodeList = new List<ISO_Country_Codes__c>();
		ISO_Country_Codes__c cc = new ISO_Country_Codes__c();
		cc.Name = 'IN';
		cc.Country_Name__c = 'India';
		cc.Market__c='Market India';
		countryCodeList.add(cc);
		ISO_Country_Codes__c cc1 = new ISO_Country_Codes__c();
		cc1.Name = 'AG';
		cc1.Country_Name__c = 'Antigua And Barbuda';
		cc1.Market__c='Market Latin America';
		countryCodeList.add(cc1);
		insert countryCodeList;

		List<Account> custAcc = HWS_TestFactoryDefaults.createAccountData(false, 1, HWS_Constants.Customer);
		custAcc[0].Customer_Compliance__c = 'US_AT&T';
		insert custAcc;
		fieldsMap.put('AccountId', custAcc[0].id); 
		
		List<Account> legalAcc = HWS_TestFactoryDefaults.createAccountData(false, 1, 'Legal_Entity');
		legalAcc[0].ParentId = custAcc[0].Id;
		legalAcc[0].Name = 'TestLE';
		insert legalAcc;
		fieldsMap.put('AccountId', legalAcc[0].Id); 
		
		List<Contact> contactList = HWS_TestFactoryDefaults.createContact(false, 1, null, fieldsMap);
		contactList[0].AccountId = custAcc[0].Id;
		fieldsMap.put('contactId', contactList[0].Id);

		String productId = HWS_TestFactoryDefaults.createProductDataSetUp( true,  1, fieldsMap)[0].Id;
		fieldsMap.put('Product2Id',productId);

		PricebookEntry pbety = HWS_TestFactoryDefaults.createPriceBookEntry(false, fieldsMap)[0];
		pbety.CurrencyIsoCode='EUR'; 
		pbety.UseStandardPrice = false;
		insert pbety;
		fieldsMap.put('pricebookEntryId',pbety.Id);
		
		List<ServiceContract> sc = HWS_TestFactoryDefaults.createServiceContractData(false, 1, fieldsMap);
		sc[0].Pricebook2Id = Test.getStandardPricebookId();
		sc[0].NCP_External_Status__c = 'Active';
		sc[0].CurrencyIsoCode = 'EUR';
		insert sc;
		fieldsMap.put('ServiceContractId', sc[0].Id);

		List<Asset> covProdAsset =  HWS_TestFactoryDefaults.createAssetData(true, 2,'HWS_Covered_Part', fieldsMap);
		fieldsMap.put('AssetId',covProdAsset[0].id);

		List<ContractLineItem> cli = HWS_TestFactoryDefaults.createContractLineItemData(false,1,fieldsMap );
		cli[0].CH_ServiceClassification__c = 'HWS Service';
		insert cli;
		fieldsMap.put('ContractLineItemid',cli[0].Id);
		
		List<HWS_VersionItem__c> version = HWS_TestFactoryDefaults.createVerionsItems(true, 1, fieldsMap);
		fieldsMap.put('versionItemId',version[0].id);
		
		Case ParentCase= HWS_TestFactoryDefaults.insertParentCase(false, fieldsMap);
		ParentCase.CH_InternalStatus__c = HWS_Constants.PENDING_REFERRAL_INSTRUCTION;
		insert ParentCase;
		fieldsMap.put('caseId', ParentCase.Id);
		
	}		
	static testMethod void getReferralInstructions(){
		Map<String, String> fieldsMap = new Map<String, String>();
	  	Case ParentCase= HWS_TestFactoryDefaults.insertParentCase(true, fieldsMap);
		List<Case> getReferralInstructions= HWS_SupplierInstructions_Controller.getReferralInstructions(parentCase.Id);
	}
	public static testmethod void createHWSCaseTest(){
	 
		
	   
		List<Case> childCaseList = new List<Case>();
		Id childRecordType = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_ADVANCE_EXCHANGE_IN_DAYS);		
		Product2 prod = [Select id from Product2 limit 1];
		Case parentCase = [Select id,accountId from Case limit 1];
		Case childCase = HWS_TestFactoryDefaults.createCase(childRecordType);
		childCase.ParentId=parentCase.Id;
		childCase.AccountId = parentCase.AccountId;
		childCase.HWS_Sellable_Product__c = prod.Id;
		childCase.CH_InternalStatus__c=HWS_Constants.PENDING_REFERRAL_INSTRUCTION;
		insert childCase;
		childCaseList.add(childCase);
		test.startTest();
		String msg=HWS_SupplierInstructions_Controller.changeInternalStatus(JSON.serialize(childCaseList));
		
		if (String.isBlank(msg)){
			msg=HWS_SupplierInstructions_Controller.updateParentCase(parentCase.Id);
		}
		try{
			msg=HWS_SupplierInstructions_Controller.changeInternalStatus('');
		}
		catch(Exception e){
			//Added empty line to fix sonar cube issue
		}
		try{
			msg=HWS_SupplierInstructions_Controller.updateParentCase('');
		}
		catch(Exception e){
			//Added empty line to fix sonar cube issue
		}
		test.stopTest();
	}
	
	public static testmethod void GetEscalationInstruction(){
	   
	   
			
	  
		Id childRecordType = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_ADVANCE_EXCHANGE_IN_DAYS);		
		Product2 prod = [Select id from Product2 limit 1];
		Case parentCase = [Select id,accountId from Case limit 1];
		 Case childCase = HWS_TestFactoryDefaults.createCase(childRecordType);
		childCase.ParentId=parentCase.Id;
		childCase.AccountId = parentCase.AccountId;
		childCase.HWS_Sellable_Product__c = prod.Id;
		childCase.CH_InternalStatus__c= HWS_Constants.PENDING_REFERRAL_INSTRUCTION;
		insert childCase;		
		test.startTest();
		Test.setMock(HttpCalloutMock.class, new HWS_CancelSRHttpCalloutMock());	
		String msg=HWS_SupplierInstructions_Controller.GetEscalationInstruction(parentCase.Id,childCase.Id);
		test.stopTest();
	}
}