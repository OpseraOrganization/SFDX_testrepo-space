@isTest
private  class CH_LegalEntitesControllerTest {
	static Map <String, RecordType> recordTypeMap = getRecordTypeByDeveloperName();
	
	static Map <String, RecordType> getRecordTypeByDeveloperName() {
		if(recordTypeMap == null) {
			recordTypeMap = new Map <String, RecordType> ();
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
		
		
		//Creating Custom Setting Data
		CH_AccountName__c accauth = new CH_AccountName__c();
		accauth.CH_InvalidName__c = 'Nokia';
		accauth.CH_ValidName__c = 'Nokia-OYJ';
		insert accauth;
		
		
		//Creating Account Data
		Account acc1 = new Account();
		acc1.Name='Account TestData';
		acc1.RecordTypeId = recordTypeMap.get('Prospect').Id;
		acc1.BillingCity= 'Lisbon';
		acc1.BillingCountry = 'Portugal';
		acc1.BillingState = null;
		acc1.BillingStreet = 'Avenida da liberdade';
		insert acc1;
		System.assertNotEquals(acc1.Id, null);
		
		Account acc2 = new Account();
		acc2.Name='Account TestData 1';
		acc2.RecordTypeId = recordTypeMap.get('Legal_Entity').Id;
		acc2.ParentId = acc1.id;
		insert acc2;
		System.assertNotEquals(acc2.Id, null);
		
		//Creating Contact Data
		Contact cont = new Contact();
		cont.AccountId = acc1.id;
		cont.FirstName = 'Test';
		cont.LastName = 'Data';
		cont.Email = 'testaccount1@coe.com';
		cont.Market__c = 'Market';
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
		serContract.Name = 'Service Contract TestData';
		serContract.CurrencyIsoCode='EUR';
		serContract.RecordTypeId=RecordTypeIdServiceContract;
		serContract.CH_CDB_ContractId__c = '000001';
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
			CH_LegalEntitesController.getContactList(null);
			CH_LegalEntitesController.getContactList(serContract.id);
			
		} catch(AuraHandledException e) {
			System.debug('The following exception has occurred: ' + e.getMessage());
		}
	}
}