/**
* This class contains unit tests for validating the behavior of Apex classes
* and triggers.
*
* Unit tests are class methods that verify whether a particular piece
* of code is working properly. Unit test methods take no arguments,
* commit no data to the database, and are flagged with the testMethod
* keyword in the method definition.
*
* All test methods in an organization are executed whenever Apex code is deployed
* to a production organization to confirm correctness, ensure code
* coverage, and prevent regressions. All Apex classes are
* required to have at least 75% code coverage in order to be deployed
* 
* to a production organization. In addition, all triggers must have some code coverage.
* 
* The @isTest class annotation indicates this class only contains test
* methods. Classes defined with the @isTest annotation do not count against
* the organization size limit for all Apex scripts.
*
* See the Apex Language Reference for more information about Testing and Code Coverage.
*/


@isTest
public class CH_ContractLineItemTriggerTest {
	private static testMethod void test() {
		
		integer j = 5;
		
		CH_EntitlementTestData.createCustomSettingData();
		
		List <Account> AccountListNL = new List<Account>();
		AccountListNL = CH_EntitlementTestData.createAccountRecord(j, 'Prospect', null);
		insert AccountListNL;
	
		List <Account> AccountListLE = new List<Account>();
		AccountListLE = CH_EntitlementTestData.createAccountRecord(j, 'Legal_Entity', AccountListNL);
		insert AccountListLE;
		
		BusinessHours stdBusinessHours = [SELECT Id, Name FROM BusinessHours WHERE IsActive = true AND IsDefault = true];
	
		List<Product2> productlist =new List<Product2>();
		productlist = CH_EntitlementTestData.createProductRecord(j);
		insert productlist;
		
		List<PricebookEntry> pricebook =new List <PricebookEntry>();
		pricebook = CH_EntitlementTestData.createPricebookEntryRecord(j, productlist);
		insert pricebook;
		
		Pricebook2 customPB1 = new Pricebook2();
		customPB1.Id = CH_EntitlementTestData.CreateCustomPriceBook();
		
		List<PricebookEntry> Custompricebook =new List <PricebookEntry>();
		Custompricebook = CH_EntitlementTestData.createCustomPricebookEntryRecord(j, productlist, customPB1.id);
		insert Custompricebook;
		
		List<ServiceContract> ServiceContractlist =new List<ServiceContract>();
		ServiceContractlist = CH_EntitlementTestData.createServiceContractRecord(j, AccountListLE, stdBusinessHours.id, customPB1.id );
		insert ServiceContractlist; 
		
		List<ContractLineItem> ContractLineItemList =new List<ContractLineItem>();
		ContractLineItemList = CH_EntitlementTestData.createContractLineItemRecord(j, Custompricebook,ServiceContractlist);
		ContractLineItemList[0].CH_CountryISO2__c = 'BG';
		ContractLineItemList[0].CH_PreviousCDBEntitlementId__c = 'CDB12345';
		ContractLineItemList[0].CH_CDB_EntitlementId__c = 'CurrCDB12345';
		
		insert ContractLineItemList;  
		
		List<Entitlement> entitlementlist =new List<Entitlement>();
		entitlementlist = CH_EntitlementTestData.createEntitlementRecord(j, AccountListLE, ContractLineItemList, stdBusinessHours.id,ServiceContractlist);
		insert entitlementlist;

		Map<ID, Entitlement> entMap = new Map<ID, Entitlement>([Select ID from Entitlement where id IN : entitlementlist]);
		List<Entitlement> Entitlementlist1 = [Select ID from Entitlement where id IN : entitlementlist];
		For(Entitlement entObj1: Entitlementlist1){
			for(Integer i=0;i<j;i++){
	entObj1.CH_CDB_EntitlementId__c='123';
	entMap.put(entObj1.id, entObj1);
			}	
		}
		update entMap.values();
		
		Map<ID, ContractLineItem> contLineMap = new Map<ID, ContractLineItem>([Select ID from ContractLineItem where id IN : ContractLineItemList]);
		List<ContractLineItem> ContractLineItemList1 = [Select ID from ContractLineItem where id IN : ContractLineItemList];
		For(ContractLineItem contLine: ContractLineItemList1){
			for(Integer i=0;i<j;i++){
	contLine.CH_CDB_EntitlementId__c = Entitlementlist1[i].CH_CDB_EntitlementId__c;
	contLineMap.put(contLine.id, contLine);
			}	
		}
		update contLineMap.values();
		
		test.startTest();
		CH_ContractLineItemTriggerHelper.linkToVendorContract(contLineMap, ContractLineItemList);
		CH_ContractLineItemTriggerHelper.getListCHAndSupportServiceContracts(ContractLineItemList,'Cares');
		CH_ContractLineItemTriggerHelper.getListCHAndSupportServiceContracts(ContractLineItemList,'Support Portal');
		CH_ContractLineItemTriggerHelper.updateLookupIds(contLineMap, ContractLineItemList);
		CH_ContractLineItemTriggerHelper.populateLookupIds(ContractLineItemList);
		CH_ContractLineItemTriggerHelper.populateCountryName(ContractLineItemList);
		
		test.stopTest();
	}
	
}