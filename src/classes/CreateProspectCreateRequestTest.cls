@isTest
public class CreateProspectCreateRequestTest{
	
	
	
	private static testMethod void ProspectCreationTest() {
		Test.setMock(HttpCalloutMock.class, new ProspectCreationMockResponseTest());
		List<Account> accountList = new List<Account>{};
			Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(); 
		Id ProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId(); 
		
		accountList = TestDataFactory.createAccount(1);
		
		accountList[0].recordtypeid = ProspectRecordTypeId;	  
		accountList[0].AccountNumber = '30191217';
		accountList[0].Website = 'testaudfhieuqrqgrrwkgvfrufgwejgfwekfgwufehwdfjkgwekjfgiuwefgweiugfuweigfwjekfgwkeufgwekfgwkejfgekwfjegfwkefgweuifgwefdewewfsdfdfdfgd.com';
		accountList[0].BillingPostalCode='12345678959';
		
		Insert accountList[0];
		
		CreateProspectCreateRequest ProspectCre = new CreateProspectCreateRequest(accountList[0].Id);
		//	ProspectCre = CreateProspectCreateRequest(accountList[0].Id);
		
	}
	static testMethod void createbulkProspectTest(){
		Test.setMock(HttpCalloutMock.class, new ProspectCreationMockResponseFailureTest());
		List<Account> accountList = new List<Account>{};
			Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(); 
		Id ProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId(); 
		
		accountList = TestDataFactory.createAccount(1);
		
		accountList[0].recordtypeid = ProspectRecordTypeId;	  
		accountList[0].AccountNumber = '30191217';
		accountList[0].Website = 'test.com';
		
		// accountList[0]
		Insert accountList[0];
		List<String> Sample = new List<String>{};
			//Exception Callout
			ProspectCreationCallout.createbulkProspect(Null);
		
		// ProspectCreationCallout.createProspect(Null);
		//CreateProspectCreateRequest.createRequest();
		
	}
	
	
	static testMethod void creatExceptionTest(){
		List<Account> accountList = new List<Account>{};
			Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(); 
		Id ProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId(); 
		
		accountList = TestDataFactory.createAccount(1);
		
		accountList[0].recordtypeid = ProspectRecordTypeId;	  
		accountList[0].AccountNumber = '30191217';
		accountList[0].Website = 'test.com';
		
		// accountList[0]
		Insert accountList[0];
		List<String> Sample = new List<String>{};
			//Exception Callout
			ProspectCreationCallout.createbulkProspect(Null);
		
		// ProspectCreationCallout.createProspect(Null);
		//CreateProspectCreateRequest.createRequest();
		
	}
	
	
}