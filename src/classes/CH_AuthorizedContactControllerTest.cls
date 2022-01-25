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

public class CH_AuthorizedContactControllerTest {
	public static testMethod void test() {
		integer j = 1;
		
		CH_EntitlementTestData.createCustomSettingData();
		
		List <Account> AccountListNL = new List<Account>();
		AccountListNL = CH_EntitlementTestData.createAccountRecord(j, 'Prospect', null);
		insert AccountListNL;
		
		List <Account> AccountListLE = new List<Account>();
		AccountListLE = CH_EntitlementTestData.createAccountRecord(j, 'Legal_Entity', AccountListNL);
		insert AccountListLE;

		List<ServiceContract> ServiceContractlist =new List<ServiceContract>();
		ServiceContractlist = CH_EntitlementTestData.createServiceContractRecord(j, AccountListLE, null, null);
		insert ServiceContractlist; 

	   
		//CH_EntitlementTestData.createEntitlementRecord(size, accNL, ContractLineItemList, stdBusinessHours, ServiceContractlist)
		
		List<contact> ConatctList1 = new List <Contact>();
		for(Integer z=0;z<j;z++){
			Contact contObj = new contact();
			contObj.Account = AccountListNL[z];
			contObj.AccountID = AccountListNL[z].ID;
			contObj.CH_Legal_Entity_Name__c = AccountListLE[z].Name;
			contObj.FirstName = 'Test'+ z;
			contObj.LastName = 'TCS Data'+ z;
			contObj.Email = 'testaccountzzz'+ z +'@aometh.com';
			contObj.Market__c = 'Market India';
			contObj.CH_ContactType__c = 'customer';
			contObj.CurrencyIsoCode = 'EUR';
			ConatctList1.add(contObj);
		}
		insert ConatctList1;  
		
		List<contact> ConatctList2 = new List <Contact>();
		for(Integer z=0;z<j;z++){
			Contact contObj = new contact();
			contObj.Account = AccountListNL[z];
			contObj.AccountID = AccountListNL[z].ID;
			contObj.CH_Legal_Entity_Name__c = AccountListLE[z].Name;
			contObj.FirstName = 'Testz'+ z;
			contObj.LastName = 'TCS Dataz'+ z;
			contObj.Email = 'testaccountzzzzz'+ z +'@aometh.com';
			contObj.Market__c = 'Market India';
			contObj.CH_ContactType__c = 'customer';
			contObj.CurrencyIsoCode = 'EUR';
			ConatctList2.add(contObj);
		}
		insert ConatctList2;  
		
		for(Integer i=0;i<j;i++){
			
			try{
				CH_AuthorizedContactController.getSearchContactList(ServiceContractList[i].Id, ConatctList1[i].FirstName, ConatctList1[i].LastName, ConatctList1[i].Id, ConatctList1[i].Email,AccountListLE[i].Name);
				CH_AuthorizedContactController.getSearchContactList(ServiceContractList[i].Id, null, null,ConatctList1[i].Id,  ConatctList1[i].Email,AccountListLE[i].Name);
			}
			catch(AuraHandledException  e) {
				System.debug('The following exception has occurred: ' + e.getMessage());
			}
			
			
			try {
				CH_AuthorizedContactController.addEntitlementContact(ServiceContractList[i].Id, ConatctList1[i]);
				CH_AuthorizedContactController.addEntitlementContact(ServiceContractList[i].Id, null );
				CH_AuthorizedContactController.addEntitlementContact(ServiceContractList[i].Id, ConatctList2[i]);
				CH_AuthorizedContactController.addEntitlementContact(null, null);
				
			}
			catch(AuraHandledException  e) {
				System.debug('The following exception has occurred: ' + e.getMessage());
			}

			
			try{
				CH_AuthorizedContactController.addEntitlementContact(null, ConatctList2[i]);
			}
			catch(QueryException ex) {
				System.debug('The following exception has occurred: ' + ex.getMessage());
			}
			
		}
	}
}