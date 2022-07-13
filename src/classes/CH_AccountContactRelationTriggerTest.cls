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
public class CH_AccountContactRelationTriggerTest {
	
	private static testMethod void test() {
		integer j = 5;
		CH_EntitlementTestData.createCustomSettingData();
		List <Account> AccountListNL = new List<Account>();
		AccountListNL = CH_EntitlementTestData.createAccountRecord(j, 'Prospect', null);
		insert AccountListNL;
		
		List <Account> AccountListLE = new List<Account>();
		AccountListLE = CH_EntitlementTestData.createAccountRecord(j, 'Legal_Entity', AccountListNL);
		insert AccountListLE;
		
		List <Contact> ConatctList = new List<Contact>();
		ConatctList = CH_EntitlementTestData.createContactRecord(j,AccountListNL);
		insert ConatctList;
		
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
		ServiceContractlist = CH_EntitlementTestData.createServiceContractRecord(j, AccountListNL, null, customPB1.id );
		insert ServiceContractlist; 
		
		List<ContractLineItem> ContractLineItemList =new List<ContractLineItem>();
		ContractLineItemList = CH_EntitlementTestData.createContractLineItemRecord(j, Custompricebook,ServiceContractlist);
		insert ContractLineItemList;
		
		List<Entitlement> entitlementlist =new List<Entitlement>();
		entitlementlist = CH_EntitlementTestData.createEntitlementRecord(j, AccountListNL, ContractLineItemList, null,ServiceContractlist);
		insert entitlementlist;
		
		List<CH_AuthorizedAccount__c> authacc = new List <CH_AuthorizedAccount__c>();
		for(Integer i=0;i<j;i++){
			CH_AuthorizedAccount__c authaccObj = new CH_AuthorizedAccount__c();
			authaccObj.CH_Account__c = AccountListLE[i].id;
			authaccObj.CH_ServiceContract__c = ServiceContractList[i].id;
			authacc.add(authaccObj);
		}
		test.startTest();
		insert authacc;
		
		
		List <EntitlementContact> entitlementContactTest = new List<EntitlementContact>();
		for(Integer i=0;i<j;i++){
			EntitlementContact entitlementContactObj = new EntitlementContact();
			entitlementContactObj.EntitlementId = EntitlementList[i].Id;
			entitlementContactObj.ContactId = ConatctList[i].Id;
			entitlementContactTest.add(entitlementContactObj);
		}
		
		insert entitlementContactTest;
		
		
		//Creating accountcontactrelationship object
		List <AccountContactRelation> acrList = new  List <AccountContactRelation>();
		for(Integer i=0;i<j;i++){
			AccountContactRelation acrObj = new AccountContactRelation();
			acrObj.AccountId = AccountListLE[i].id;
			acrObj.ContactId = ConatctList[i].Id;
			acrObj.NCP_Entitlement_Relationship__c = true;
			acrList.add(acrObj);
		}
		insert acrList;
		system.assertNotEquals(acrList[0].id, null);
		
		Map<ID, AccountContactRelation> acrMap = new Map<ID, AccountContactRelation>([Select id from AccountContactRelation where AccountId =:AccountListLE And ContactId =:ConatctList And NCP_Entitlement_Relationship__c = true ]);
		For(AccountContactRelation acrObj1: acrMap.values()){
			acrObj1.NCP_Entitlement_Relationship__c = false;
			acrMap.put(acrObj1.ID,acrObj1);
		}
		update acrMap.values();
		
		For(AccountContactRelation acrObj1: acrMap.values()){
			acrObj1.NCP_Entitlement_Relationship__c = true;
			acrMap.put(acrObj1.ID,acrObj1);
		}
		update acrMap.values();
		
		delete acrList;
	 
		test.stopTest();
	}
}