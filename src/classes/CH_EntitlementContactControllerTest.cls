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
private  class CH_EntitlementContactControllerTest {
	static Map < String, RecordType > recordTypeMap = getRecordTypeByDeveloperName();
	
	static Map < String, RecordType > getRecordTypeByDeveloperName() {
		if(recordTypeMap == null) {
			recordTypeMap = new Map < String, RecordType > ();
			for(RecordType recordTypeObj: [SELECT Id, Name, DeveloperName FROM RecordType]) {
				recordTypeMap.put(recordTypeObj.DeveloperName, recordTypeObj);
			}
		}
		return recordTypeMap;
	}
	
	public static testMethod void test() {
		try{
			CH_EntitlementContactController.checkUserPermission();
		}
		catch(AuraHandledException e) {
			System.debug('The following exception has occurred: ' + e.getMessage());
		}
		
		Profile p = [SELECT Id FROM Profile WHERE Name='CH_Agent'];
		UserRole r = [SELECT Id FROM UserRole WHERE Name='GWC'];
		User u = new User();
		u.Nokia_ID__c='987123';
		u.Alias = 'chdvt';
		u.Email = 'chdvtuser123@testorg.com';
		u.EmailEncodingKey = 'UTF-8';
		u.LastName = 'DVTTesting';
		u.FirstName = 'CHLogin';
		u.LanguageLocaleKey='en_US';
		u.localeSidKey='en_US';
		u.ProfileId = p.Id;
		u.UserRoleId = r.id;
		u.TimeZoneSidKey='America/Los_Angeles';  
		u.UserName='testpermissionsetusers@testorg.com';
		insert u;
		
		// Query your permission set name from Organization that your want to test.
		PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'CH_DVT_Adminstration'];
		
		// Assign the above inserted user for the above Permission Set.
		PermissionSetAssignment psa = new PermissionSetAssignment();
		psa.AssigneeId = u.Id;
		psa.PermissionSetId = ps.Id;
		insert psa;
		
		// Run your code with inserted user.
		System.runAs(u){			
			
			//Creating Custom Setting Data
			CH_AccountName__c accauth = new CH_AccountName__c();
			accauth.CH_InvalidName__c = 'Nokia';
			accauth.CH_ValidName__c = 'Nokia-OYJ';
			insert accauth;
			
			
			//Creating Account Data
			Account acc1 = new Account();
			acc1.Name='TCS Account TestData';
			acc1.RecordTypeId = recordTypeMap.get('Prospect').Id;
			acc1.BillingCity= 'Grapevine';
			acc1.BillingCountry = 'United States of America';
			acc1.BillingState = 'Texas';
			acc1.BillingStreet = '239 Overlook St.';
			acc1.BillingPostalCode = '76051';
			insert acc1;
			System.assertNotEquals(acc1.Id, null);
			
			Account acc2 = new Account();
			acc2.Name='TCS Account TestData 1';
			acc2.RecordTypeId = recordTypeMap.get('Legal_Entity').Id;
			acc2.ParentId = acc1.id;
			insert acc2;
			System.assertNotEquals(acc2.Id, null);
			
			//Creating Contact Data
			Contact cont = new Contact();
			cont.AccountId = acc1.id;
			cont.FirstName = 'Test';
			cont.LastName = 'TCS Data';
			cont.Email = 'testaccount@aometh.com';
			cont.Market__c = 'Market India';
			cont.CH_ContactType__c = 'customer';
			cont.CurrencyIsoCode = 'EUR';
			insert cont;
			System.assertNotEquals(cont.Id, null);   
			
			Entitlement entObjTest = new Entitlement();
			Id RecordTypeIdEntitlement = Schema.SObjectType.Entitlement.getRecordTypeInfosByName().get('CH Entitlement').getRecordTypeId();
			entObjTest.RecordTypeId = RecordTypeIdEntitlement;
			entObjTest.Name = 'Test Entitlement';
			entObjTest.AccountId = acc1.Id;
			entObjTest.CH_CDB_EntitlementId__c = '1';
			entObjTest.StartDate = System.today();
			entObjTest.EndDate = System.today() + 10;
			entObjTest.CH_EntitlementType__c = 'Authorized Contact';
			entObjTest.CH_ServiceMappingId__c = 'Legacy Customer Support Service - No Severity 24x7';
			insert entObjTest;
			
			//Creating Service Contract Data
			Id RecordTypeIdServiceContract = Schema.SObjectType.ServiceContract.getRecordTypeInfosByName().get('Parent Service Contract').getRecordTypeId();
			ServiceContract serContract =new ServiceContract();
			serContract.RecordTypeId = RecordTypeIdServiceContract;
			serContract.AccountId = acc1.Id;
			serContract.Name = 'TCS Service Contract TestData';
			serContract.CurrencyIsoCode='EUR';
			serContract.RecordTypeId=RecordTypeIdServiceContract;
			serContract.CH_CDB_ContractId__c = '123456';
			serContract.CH_Entitlement__c = entObjTest.Id;
			insert serContract;
			System.assertNotEquals(serContract.Id, null);
			
			//Creating accountcontactrelationship object
			AccountContactRelation acr = new AccountContactRelation();
			acr.AccountId = acc2.Id;
			acr.ContactId = cont.Id;
			acr.NCP_Entitlement_Relationship__c = true;
			insert acr;   
			
			try {
				CH_EntitlementContactController.getContactList(null);
				CH_EntitlementContactController.getContactList(serContract.id);
				CH_EntitlementContactController.getContactList(entObjTest.id);
				CH_EntitlementContactController.getContactList(acc2.id);   
				CH_EntitlementContactController.getContactList(cont.id);
				CH_EntitlementContactController.checkUserPermission();
				
			} catch(AuraHandledException e) {
				//System.debug('The following exception has occurred: ' + e.getMessage());
			}
			try {
				CH_EntitlementContactController.deleteRecord(serContract.id, cont.id,acc2.id);
				CH_EntitlementContactController.deleteRecord(null, cont.id,acc2.id);
				CH_EntitlementContactController.deleteRecord(serContract.id, null,acc2.id);
				CH_EntitlementContactController.deleteRecord(serContract.id, cont.id,null);
				CH_EntitlementContactController.deleteRecord(null, null,null);
				
			} catch(AuraHandledException  e) {
				//System.debug('The following exception has occurred: ' + e.getMessage());
			}  
			
			try {
				CH_EntitlementContactController.deleteRecord(serContract.id, cont.Id, acc1.id);
			} catch(AuraHandledException e) {
				//System.debug('The following exception has occurred: ' + e.getMessage());
			}
			
		}
	}
}