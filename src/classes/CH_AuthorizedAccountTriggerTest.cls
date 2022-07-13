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
private class CH_AuthorizedAccountTriggerTest {
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
		
		List <EntitlementContact> entitlementContactTest = new List<EntitlementContact>();
		for(Integer i=0;i<j;i++){
			EntitlementContact entitlementContactObj = new EntitlementContact();
			entitlementContactObj.EntitlementId = EntitlementList[i].Id;
			entitlementContactObj.ContactId = ConatctList[i].Id;
			entitlementContactTest.add(entitlementContactObj);
		}
		insert entitlementContactTest;
		
		CH_AccountContactRelationTriggerHelper.createAH('Add', entitlementContactTest);
		
		List<CH_AuthorizedAccount__c> authacc = new List <CH_AuthorizedAccount__c>();
		for(Integer i=0;i<j;i++){
			CH_AuthorizedAccount__c authaccObj = new CH_AuthorizedAccount__c();
			authaccObj.CH_Account__c = AccountListLE[i].id;
			authaccObj.CH_ServiceContract__c = ServiceContractList[i].id;
			authacc.add(authaccObj);
		}
		test.startTest();
		insert authacc;
		
		List <Account> AccountListLE1 = new List<Account>();
		AccountListLE1 = CH_EntitlementTestData.createAccountRecord(j, 'Legal_Entity', AccountListNL);
		insert AccountListLE1;
		
		
		Map<ID, CH_AuthorizedAccount__c> authaccMap = new Map<ID, CH_AuthorizedAccount__c>([Select ID from CH_AuthorizedAccount__c where CH_Account__c=:AccountListLE AND CH_ServiceContract__c =: ServiceContractList]);
		for(CH_AuthorizedAccount__c authaccObj1 : authaccMap.values()){
			for(Integer i=0;i<j;i++){
	authaccObj1.CH_Account__c = AccountListLE1[i].id;
	authaccMap.put(authaccObj1.id, authaccObj1);
			}
		}
		update authaccMap.values();
		delete authaccMap.values();
	}

	private static testMethod void test2() {
		
		integer j = 5;
		
		CH_EntitlementTestData.createCustomSettingData();
		List<Account> AccountListNL = new List<Account>();
		AccountListNL = CH_EntitlementTestData.createAccountRecord(j, 'Prospect', null);
		insert AccountListNL;
		
		List<Account> AccountListLE = new List<Account>();
		AccountListLE = CH_EntitlementTestData.createAccountRecord(j, 'Legal_Entity', AccountListNL);
		insert AccountListLE;
		
		List<Contact> contactList = new List<Contact>();
		for(Integer count=0; count < 5; count++){
			Contact contObj = new contact();
			contObj.AccountId = AccountListNL[count].id;
			contObj.FirstName = 'Test'+count;
			contObj.LastName = 'TCS Data'+count;
			if(math.mod(count, 2) == 0){
	contObj.Email = 'testaccount' + count + '@aometh.com';
			}
			else{
	contObj.Email = 'testaccount'+ count +'@ericsson.com';
	contObj.NCP_Competitor__c = true;
			}
			contObj.Market__c = 'Market India';
			contObj.CH_ContactType__c = 'customer';
			contObj.CurrencyIsoCode = 'EUR';
			contactList.add(contObj);
		}
		insert contactList;
		
		List<Product2> productlist =new List<Product2>();
		productlist = CH_EntitlementTestData.createProductRecord(j);
		insert productlist;
		
		List<PricebookEntry> pricebook =new List<PricebookEntry>();
		pricebook = CH_EntitlementTestData.createPricebookEntryRecord(j, productlist);
		insert pricebook;
		
		
		Pricebook2 customPB1 = new Pricebook2();
		customPB1.Id = CH_EntitlementTestData.CreateCustomPriceBook();
		
		List<PricebookEntry> Custompricebook =new List<PricebookEntry>();
		Custompricebook = CH_EntitlementTestData.createCustomPricebookEntryRecord(j, productlist, customPB1.id);
		insert Custompricebook;
		
		
		List<ServiceContract> ServiceContractlist =new List<ServiceContract>();
		ServiceContractlist = CH_EntitlementTestData.createServiceContractRecord(j, AccountListNL, null, customPB1.id );
		ServiceContractlist[1].CH_Allow_Competitor_Authorized_Contacts__c = true;
		ServiceContractlist[3].CH_Allow_Competitor_Authorized_Contacts__c = true;
		insert ServiceContractlist; 
		
		List<ContractLineItem> ContractLineItemList =new List<ContractLineItem>();
		ContractLineItemList = CH_EntitlementTestData.createContractLineItemRecord(j, Custompricebook,ServiceContractlist);
		insert ContractLineItemList;
		
		List<Entitlement> entitlementlist =new List<Entitlement>();
		entitlementlist = CH_EntitlementTestData.createEntitlementRecord(j, AccountListNL, ContractLineItemList, null,ServiceContractlist);
		insert entitlementlist;
		
		
		//Creating accountcontactrelationship object
		List<AccountContactRelation> acrList = new  List<AccountContactRelation>();
		for(Integer i=0; i<j; i++){
			AccountContactRelation acrObj = new AccountContactRelation();
			acrObj.AccountId = AccountListLE[i].id;
			acrObj.ContactId = contactList[i].Id;
			acrObj.NCP_Entitlement_Relationship__c = true;
			acrList.add(acrObj);
		}
		insert acrList;
		
		List<EntitlementContact> entitlementContactTest = new List<EntitlementContact>();
		for(Integer i=0;i<j;i++){
			EntitlementContact entitlementContactObj = new EntitlementContact();
			entitlementContactObj.EntitlementId = EntitlementList[i].Id;
			entitlementContactObj.ContactId = contactList[i].Id;
			entitlementContactTest.add(entitlementContactObj);
		}
		insert entitlementContactTest;
		
		CH_AccountContactRelationTriggerHelper.createAH('Add', entitlementContactTest);
		
		List<CH_AuthorizedAccount__c> authacc = new List<CH_AuthorizedAccount__c>();
		for(Integer i=0;i<j;i++){
			CH_AuthorizedAccount__c authaccObj = new CH_AuthorizedAccount__c();
			authaccObj.CH_Account__c = AccountListLE[i].id;
			authaccObj.CH_ServiceContract__c = ServiceContractList[i].id;
			authacc.add(authaccObj);
		}
		Test.startTest();
		insert authacc;
		
		List<Account> AccountListLE1 = new List<Account>();
		AccountListLE1 = CH_EntitlementTestData.createAccountRecord(j, 'Legal_Entity', AccountListNL);
		insert AccountListLE1;
		
		
		Map<ID, CH_AuthorizedAccount__c> authaccMap = new Map<ID, CH_AuthorizedAccount__c>([Select ID from CH_AuthorizedAccount__c where CH_Account__c=:AccountListLE AND CH_ServiceContract__c =: ServiceContractList]);
		for(CH_AuthorizedAccount__c authaccObj1 : authaccMap.values()){
			for(Integer i=0;i<j;i++){
				authaccObj1.CH_Account__c = AccountListLE1[i].id;
				authaccMap.put(authaccObj1.id, authaccObj1);
			}
		}
		update authaccMap.values();
		delete authaccMap.values();

		ServiceContractlist[1].CH_Allow_Competitor_Authorized_Contacts__c = false;
		ServiceContractlist[3].CH_Allow_Competitor_Authorized_Contacts__c = false;
		update ServiceContractlist;
		
		Test.stopTest();
	}
}