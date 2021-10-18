@isTest(SeeAllData=False)
public class CH_CaseField_ProblemController_Test {
	public static testmethod void RelatedQuestionResponsesList() {
		Test.StartTest(); 
		List<Case> caseUpdatedList = [SELECT Id, RecordType.Name,CH_Problem__c,CH_Problem__r.OwnerId FROM Case];
		List<Case> caseList = [SELECT Id, CaseNumber, CH_Problem__c FROM Case WHERE RecordType.Name ='Problem' LIMIT 1];
		List<Case> caseListinc = [SELECT Id, CaseNumber,CH_Problem__c FROM Case WHERE RecordType.Name ='Nokia Incident with Restoration' LIMIT 1];
		CH_CaseField_ProblemController.accessCheck(caseList[0].id);
		CH_CaseField_ProblemController.getCaseDetails(caseList[0].id);
		CH_CaseField_ProblemController.disassociateNewProblem(caseList[0].id);
		caseUpdatedList[1].CH_Problem__r.OwnerId = userinfo.getUserId();
		update caseUpdatedList;
		
		try {
			CH_CaseField_ProblemController.newPostToProblem(caseUpdatedList[1].id);
		} catch(Exception e) {
			system.debug('Test Class'+e);
		}
		Test.StopTest(); 
	} 
	
	public static testmethod void checkfornewProblem() {
		 List<Case> problemUpdatedList = [SELECT Id, RecordType.Name,CH_Problem__c,CH_Problem__r.OwnerId FROM Case];
		 try {
			 CH_CaseField_ProblemController.createNewProblem(problemUpdatedList [0], string.valueof(problemUpdatedList [0].Id));
		 } catch(exception e) {
			 System.debug('Test class'+e);
		 }
		 
	} 
	@testSetUp
	public static void setupData() {
		Boolean hasEntitlementScript = true;
		Account accCustomerParentAccount = new Account();
		Id accountRecordType1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
		accCustomerParentAccount.Name = 'Customer Parent Account';
		accCustomerParentAccount.RecordTypeId = accountRecordType1;
		accCustomerParentAccount.Customer_Compliance__c = 'US_Company';
		insert accCustomerParentAccount; 
		
		// Creation of Account
		Account acc = new Account();
		Id accountCustomerRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		acc.Name = 'Parent Account';
		acc.RecordTypeId = accountCustomerRecordType;
		acc.ParentId = accCustomerParentAccount.id;
		insert acc; 
		
		Account accCustomer = new Account();
		Id accountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
		accCustomer.Name = 'Customer Account';
		accCustomer.RecordTypeId = accountRecordType;
		insert accCustomer; 
		
		// Creation of Contact
		Contact con = new Contact();
		con.FirstName = 'TestFirstName';
		con.Lastname = 'TestLastName';
		con.Email = 'Test@test.com';
		con.AssistantName ='TestAssistanceName';
		con.Email1__c = 'TestCaseEmail@test.com';
		con.CH_Email3__c = 'TestCaseEmail3@test.com';
		con.AccountId = accCustomer.Id;
		insert con;
		
		
		List<Product2> productList = CH_UTIL_TEST.createS2SProducts('testSolution', '12348', 'testProduct', '12350', 'testVariant', '12352');
		insert productList;
		
		Asset assetTest = CH_UTIL_TEST.createS2SAsset('12346|234|testSolution|testProduct|testVariant|testRelease', acc.Id);
		insert assetTest;
		
		PriceBookEntry tempPriceBookEntry = new PriceBookEntry(
			Pricebook2Id = Test.getStandardPricebookId(),
			Product2Id = productList[0].id,
			UnitPrice = 0,
			CurrencyIsoCode = 'EUR',
			IsActive = true
		);
		Insert tempPriceBookEntry;
		
		// Create contract
		ServiceContract serviceContract = new ServiceContract(
			AccountId = acc.Id, 
			Name = 'TestServiceContract',
			CH_CDB_ContractId__c = 'Test',
			CH_EntitlementScript__c = (hasEntitlementScript)?'Header Script':'',
			Pricebook2Id = Test.getStandardPricebookId()
		);
		Insert serviceContract;
		
		// Create Contract Line Item 
		ContractLineItem contractLineItem = new ContractLineItem(
			ServiceContractId = serviceContract.Id,
			AssetId = assetTest.Id,
			UnitPrice = 0,
			Quantity = 1,
			PricebookEntryId = tempPriceBookEntry.Id, 
			CH_LineItemEntitlementScript__c = (hasEntitlementScript)?'Script':'',
			CH_CDB_EntitlementId__c = 'TEST', 
			CH_ServiceMappingId__c = 'Legacy Customer Support Service - Critical Major Minor 24x7'
		);
		Insert contractLineItem;
		
		// Create entitlement
		Entitlement entitlement = new Entitlement(
			AccountId = acc.Id,
			AssetId = assetTest.Id,
			Startdate = Date.Today().addDays(-1), // To get an Active entitlement
			CH_CDB_EntitlementId__c = '12345',
			ContractLineItemId = contractLineItem.Id,
			ServiceContractId = serviceContract.Id,
			CH_EntitlementType__c = 'Entitled Asset',
			Name = 'TestEntitlement',
			CH_ServiceMappingId__c = 'Legacy Customer Support Service - Critical Major Minor 24x7'
		);
		Insert entitlement;
		
		EntitlementContact oEntitlementContact = new EntitlementContact(
			EntitlementId = entitlement.Id,
			ContactId = con.Id
		);
		insert oEntitlementContact;
		
		Product2 oProduct = new Product2();
		oProduct.Name = 'test';
		oProduct.ProductCode ='A123';
		insert oProduct;
		
 /*	   Group testGroup = new Group(Name='test group', Type='Queue');
insert testGroup;

System.runAs(new User(Id=UserInfo.getUserId()))
{
	QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
	insert testQueue;
}
*/

		
		// Creation of Case
		Case newCase = new Case();
		newCase.AccountId = acc.Id;
		newCase.ContactId = con.Id;
		newCase.AssetId = assetTest.Id;
		newCase.CH_ReportedDate__c = DateTime.Now();
		newCase.Mobile_Phone__c = '123-456789';
		newCase.Country__c = 'Bahrain';
		newCase.reason = 'New problem';
		newCase.Subject = 'Survey Closed Case';
		newCase.CH_Summary__c = 'TestSub';
		newCase.Type = 'Incident';
		newCase.Description = 'TEST';
		newCase.Severity__c = 'Minor';
		newCase.CH_Outage__c = 'No';
		newCase.Status = 'Created';
		newCase.CH_IssueOccurenceDate__c = system.today();
		newCase.ProductId = productList[0].id;
		newCase.CH_Initial_Assignment__c = true;
		newCase.CH_SystemRestoredTargetDate__c = system.now();
		newCase.CH_Reassignment__c = true;
		newCase.recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get('Problem').getRecordTypeId();
		newCase.EntitlementId = entitlement.Id;
		newCase.NCP_Service_Contract__c = serviceContract.Id;
		newCase.BusinessHoursId = [SELECT Id FROM BusinessHours Limit 1].Id;
		newCase.ProductId = oProduct.id;
	   
		Test.StartTest(); 
		insert newCase;
		Test.StopTest(); 
		
		
		// Creation of Case
		Case newCase1 = new Case();
		newCase1.AccountId = acc.Id;
		newCase1.ContactId = con.Id;
		newCase1.AssetId = assetTest.Id;
		newCase1.CH_ReportedDate__c = DateTime.Now();
		newCase1.Mobile_Phone__c = '123-456789';
		newCase1.Country__c = 'Bahrain';
		newCase1.reason = 'New problem';
		newCase1.Subject = 'Survey Closed Case';
		newCase1.CH_Summary__c = 'TestSub';
		newCase1.Type = 'Incident';
		newCase1.Description = 'TEST';
		newCase1.Severity__c = 'Minor';
		newCase1.CH_Outage__c = 'No';
		newCase1.Status = 'Created';
		newCase1.CH_IssueOccurenceDate__c = system.today();
		newCase1.ProductId = productList[0].id;
		newCase1.CH_Initial_Assignment__c = true;
		newCase1.CH_SystemRestoredTargetDate__c = system.now();
		newCase1.CH_Reassignment__c = true;
		newCase1.recordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get('Nokia Incident with Restoration').getRecordTypeId();
		newCase1.EntitlementId = entitlement.Id;
		newCase1.NCP_Service_Contract__c = serviceContract.Id;
		newCase1.BusinessHoursId = [SELECT Id FROM BusinessHours Limit 1].Id;
		newCase1.ProductId = oProduct.id;
	  //  newCase1.ownerid = testGroup.Id;
		newCase1.CH_Problem__c=newCase.id;
	   // Test.StartTest(); 
		insert newCase1;
		//Test.StopTest();
		
		
	 
	}
}