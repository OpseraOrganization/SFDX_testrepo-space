@IsTest
public class CH_CaseField_SideHighlightApexTest 
{
	private static void setuptestdata()
	{  
		//Creating Custom Setting Data
		CH_AccountName__c accauth = new CH_AccountName__c();
		accauth.CH_InvalidName__c = 'Nokia';
		accauth.CH_ValidName__c = 'Nokia-OYJ';
		insert accauth; 
		
		Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
		Account accountobj =new Account();//Create Account Object
		accountobj.Region__c='Asia and Japan';
	   // accountobj.Country__c ='United States of America';
		accountobj.name='accountName';
		accountobj.Market_Segment__c='CABLE';
		accountobj.Activity_Sector_Name__c = 'CABL-CABlE PROVIDERS';
		accountobj.Website='Nokia.com';
		accountobj.Customer_Compliance__c='unassign';
		if(accountRecordTypeId != null){
			accountobj.RecordTypeId =accountRecordTypeId;
			
			
			accountobj.BusinessPartnerRole__c='Alliance';
			//accountobj.Market__c='Market India';
			accountobj.CBT_CT_Code__c ='INDIA ID CT Idea';
			accountobj.BillingCity ='Atlanta' ;
			accountobj.BillingCountry='United States of America';
			accountobj.BillingLatitude=13.0827;
			accountobj.BillingLongitude=80.2707;
			accountobj.BillingPostalCode='600075';
			accountobj.BillingState='Georgia';
			accountobj.BillingStreet='water well street';
			insert accountobj;
			
			/*Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(); 
Account acc = new Account();
acc.Name = 'Account';
acc.AccountNumber = '301001643';
acc.recordtypeid = custRecordTypeId ;
insert acc;*/
			
			Product2 productObj =new Product2();//Create Product Object
			productObj.Name ='TestProduct';
			productObj.DataUsage__c='productObj Data Usage';
			productObj.NCP_CAREACTIVATE__c='productObj NCP AREACTIVATE c';
			productObj.PMD_Portfolio_Classification__c='Product';
			insert productObj;
			
			/*  CH_Workgroup__c WorkgroupObj = new   CH_Workgroup__c();
WorkgroupObj.Name ='testWorkgroup';
WorkgroupObj.CH_Workgroup_Instructions__c ='Test Instructions ';
insert WorkgroupObj; */
			
			List<Account> accountList = new  List<Account>();
			List<Account> accountListTemp = new  List<Account>();
			Id LERecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(); 
			accountList = TestDataFactory.createAccount(2);
			accountList[0].recordtypeid = custRecordTypeId;
			accountList[1].recordtypeid = LERecordTypeId;
			
			database.insert(accountList[0]); 
			accountList[1].parentid = accountList[0].id;
			accountList[1].Default_Legal_Entity__c = false;
			accountList[1].AccountNumber = '1000087011';
			database.insert(accountList[1]); 
			
			CaseMilestone caseMilestoneObj = new CaseMilestone();
			
			
			Contact con = new Contact();
			con.FirstName = 'Showket';
			con.LastName = 'Bhat';
			con.CurrencyIsoCode = 'EUR';
			con.Phone = '1234234534';
			con.Market__c = 'Market India';
			con.CH_PreferredMtdOfServiceCommunication__c = 'Email';
			con.CH_ContactTimeZone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
			con.Email = 'showket.bhat@accenture.com';
			con.CH_ContactType__c = 'Customer';
			con.accountId = accountobj.Id;
			Insert con; 
			
			
			
			List<Case> listCase = new List<Case>();
			Case caseObj = new Case();
			caseObj.AccountId =accountList[1].Id ;
			caseObj.ProductId = productObj.Id;
			// caseObj.CH_Workgroup__c=WorkgroupObj.Id;
			caseObj.CreatedDate=Date.today();
			caseObj.OwnerId = UserInfo.getUserId();
			caseObj.Status = 'Created';
			caseObj.Country__c = 'India';
			caseObj.CH_Outage__c = 'No';
			caseObj.CH_InitialDiagnosis__c = 'testt';
			caseObj.Severity__c = 'Minor';
			caseObj.CH_IssueOccurenceDate__c = Date.today();
			caseObj.of_Employees_to_represent_Nokia_CP__c = '0-10%';
			caseObj.Subject = 'Test call';
			caseObj.Description = 'test description';
			caseObj.CH_ProblemDisassociationReason__c='test';
			caseObj.CH_ReportedDate__c = Date.today().addDays(-1);
			caseObj.CH_IssueOccurenceDate__c = Date.today().addDays(-1);
			caseObj.RecordTypeId =Schema.SObjectType.case.getRecordTypeInfosByName().get('Nokia Standard Case').getRecordTypeId();
			caseObj.CH_Reassignment__c=true;
			caseObj.ContactId=con.Id;
			insert caseObj;
			listCase.add(caseObj);
			
			Case caseObj1 = new Case();
			caseObj1.AccountId =accountList[1].Id ;
			caseObj1.ProductId = productObj.Id;
			// caseObj.CH_Workgroup__c=WorkgroupObj.Id;
			caseObj1.CreatedDate=Date.today();
			caseObj1.OwnerId = UserInfo.getUserId();
			caseObj1.Status = 'Created';
			caseObj1.Country__c = 'India';
			caseObj1.CH_Outage__c = 'No';
			caseObj1.CH_InitialDiagnosis__c = 'testt';
			caseObj1.Severity__c = 'Minor';
			caseObj1.CH_IssueOccurenceDate__c = Date.today();
			caseObj1.of_Employees_to_represent_Nokia_CP__c = '0-10%';
			caseObj1.Subject = 'Test call';
			caseObj1.Description = 'test description';
			caseObj1.CH_ProblemDisassociationReason__c='test';
			caseObj1.CH_ReportedDate__c = Date.today().addDays(-1);
			caseObj1.CH_IssueOccurenceDate__c = Date.today().addDays(-1);
			caseObj1.RecordTypeId =Schema.SObjectType.case.getRecordTypeInfosByName().get('Nokia Incident with Restoration').getRecordTypeId();
			caseObj1.CH_Reassignment__c=true;
			caseObj1.ContactId=con.Id;
			caseObj1.CH_Workaround_Available__c = 'No';
			insert caseObj1;
			
			Case caseObj2 = new Case();
			caseObj2.AccountId =accountList[1].Id ;
			caseObj2.ProductId = productObj.Id;
			// caseObj.CH_Workgroup__c=WorkgroupObj.Id;
			caseObj2.CreatedDate=Date.today();
			caseObj2.OwnerId = UserInfo.getUserId();
			caseObj2.Status = 'Created';
			caseObj2.Country__c = 'India';
			caseObj2.CH_Outage__c = 'No';
			caseObj2.CH_InitialDiagnosis__c = 'testt';
			caseObj2.CH_ReportedDate__c = Date.today().addDays(-1);
			caseObj2.CH_IssueOccurenceDate__c = Date.today().addDays(-1);
			caseObj2.Severity__c = 'Minor';
			caseObj2.CH_IssueOccurenceDate__c = Date.today();
			caseObj2.of_Employees_to_represent_Nokia_CP__c = '0-10%';
			caseObj2.Subject = 'Test call';
			caseObj2.Description = 'test description';
			caseObj2.CH_ProblemDisassociationReason__c='test';
			caseObj2.RecordTypeId =Schema.SObjectType.case.getRecordTypeInfosByName().get('Problem').getRecordTypeId();
			caseObj2.CH_Reassignment__c=true;
			caseObj2.ContactId=con.Id;
			
			//insert caseObj2;
			test.starttest();
			CH_CaseField_SideHighlightApex.statusValue(caseObj.Id);
			CH_CaseField_SideHighlightApex.statusValueforResolve(caseObj.Id);
			CH_CaseField_SideHighlightApex.fetchODRrecords(caseObj.Id);
			CH_CaseField_SideHighlightApex.disablebuttoncheck(caseObj.Id);
			CH_CaseField_SideHighlightApex.disablebuttoncheckSIR(caseObj.Id);
			CH_CaseField_SideHighlightApex.disablebuttoncheckGenerateSDR(caseObj.Id);
			CH_CaseField_SideHighlightApex.disablebuttoncheckGenerateSDR(caseObj1.Id);
			CH_CaseField_SideHighlightApex.transferProblemDetailsQuery(caseObj1.Id);
		
			  CH_CaseField_SideHighlightApex.transfercaseornot(caseObj.Id);
		
CH_CaseField_SideHighlightApex.disablesetissueresolved(caseObj1.Id);
 CH_CaseField_SideHighlightApex.disableDistributecommentUpdate(caseObj1.Id);
			
	   // CH_CaseField_SideHighlightApex.disableSharebutton(caseObj1.Id);
		 CH_OutageDuration__c odr = new CH_OutageDuration__c();
		odr.CH_SupportTicket__c = caseObj1.Id;
	   // insert odr;
		CH_CaseField_SideHighlightApex.checkODRValidationQuery(caseObj1.Id);
	   
		
		CH_CaseField_SideHighlightApex.transferNewProblemDetailsQuery(productObj.Id);
		List<string> strlist = new List<string>();
		CH_CaseField_SideHighlightApex.invokeFromFlowsendCreateAnalysisRndInteraction(strlist);
		//CH_CaseField_SideHighlightApex.getArticaleKnownError(caseObj1.Id);
		test.stoptest();
	   /* CH_CaseField_SideHighlightApex.getArticaleKnownError(caseObj1.Id);
		Knowledge__kav kv = new Knowledge__kav();
		kv.title='test';
		kv.CH_CaseId__r.Id = caseObj1.Id;
		insert KV;*/
		
		}
	}
	@IsTest
	public  Static void setAssignmentTest()
	{
		setuptestdata();
		sObject sObj = Schema.getGlobalDescribe().get('case').newSObject() ;
		sObj =[Select Id From case  Limit 1 ];
		system.assertNotEquals(sObj, null);
	 //   Test.startTest();
		CH_CaseField_SideHighlightApex.setAssignment(sObj.Id);
	   // Test.stopTest();
	}

	@IsTest
	public  Static void setDisplayWorkgroupInstructionsTest()
	{
		setuptestdata();
		sObject sObj = Schema.getGlobalDescribe().get('case').newSObject() ;
		sObj =[Select Id From case  Limit 1 ];
		system.assertNotEquals(sObj, null);
	 //   Test.startTest();
		CH_CaseField_SideHighlightApex.displayWorkgroupInstructions(sObj.Id);
	  //  Test.stopTest();
	}
	
	@IsTest
	public  Static void checkTCAReadyTest()
	{
		setuptestdata();
		sObject sObj = Schema.getGlobalDescribe().get('case').newSObject() ;
		sObj =[Select Id From case  Limit 1 ];
		system.assertNotEquals(sObj, null);
	 //   Test.startTest();
		CH_CaseField_SideHighlightApex.checkTCAReady(sObj.Id);
	  //  Test.stopTest();
	}
	
	@IsTest
	public  Static void accessCheckTest()
	{
		setuptestdata();
		sObject sObj = Schema.getGlobalDescribe().get('case').newSObject() ;
		sObj =[Select Id From case  Limit 1 ];
		system.assertNotEquals(sObj, null);
	   // Test.startTest();
		CH_CaseField_SideHighlightApex.accessCheck(sObj.Id);
		//Test.stopTest();
	}

	@isTest
	private static void transferRndButtonValidationTest() {
		CH_AvoidRecursion.doNtExcuteCseTrggr4NotfcationBtch = false;
		CH_UTIL_TEST.setupCase();
		Case testCase = CH_UTIL_TEST.getProblem();
		insert testCase;

		testCase = [SELECT Id, CH_RDInterface__c, CH_Originating_Incident_Number__c, Subject, CH_CustomerDescription__c, CH_ProblemStatement__c, Severity__c, 
						CH_AssessedOutage__c, CH_ReportedDate__c, ProductId, CH_Product_Release__c, CH_Problem_Type__c, CH_Pronto_Group__c, CH_Discovered_in__c, 
						CH_Repeatability__c, Account.AccountNumber, Account.NCP_P20_ID__c, CH_ProductVariant__c
					FROM Case];

		Test.startTest();
		Boolean noValidationErrors = CH_CaseField_SideHighlightApex.transferRndRequiredFieldsCheck(testCase.Id);
				
		noValidationErrors = CH_CaseField_SideHighlightApex.transferRndRequiredFieldsCheck(testCase);
				
		testCase.CH_Originating_Incident_Number__c = NULL;
		testCase.Subject = 'test subject';
		testCase.CH_CustomerDescription__c = 'test customer description';
		testCase.CH_ProblemStatement__c = 'test problem statement';
		testCase.Severity__c = 'Minor';
		testCase.CH_AssessedOutage__c = 'Yes';
		testCase.CH_ReportedDate__c = Date.today().addDays(-1);
		System.assert(!String.isEmpty(testCase.ProductId));
		CH_ProductRelease__c testProductRelease = CH_UTIL_TEST.createS2SRelease('testRelease', '12354', testCase.ProductId);
		insert testProductRelease;
		testCase.CH_Product_Release__c = testProductRelease.Id;
		testCase.CH_Problem_Type__c = 'Software';
		testCase.CH_RDInterface__c = 'JIRA';
		testCase.CH_ProductVariant__c = NULL;
		noValidationErrors = CH_CaseField_SideHighlightApex.transferRndRequiredFieldsCheck(testCase);
		System.assert(noValidationErrors);
		
		testCase.CH_RDInterface__c = 'PRONTO';
		CH_Pronto_Group__c prontoGroup = new CH_Pronto_Group__c(Name = 'test pronto group');
		insert prontoGroup;
		testCase.CH_Pronto_Group__c = prontoGroup.Id;
		testCase.CH_Discovered_in__c = 'Customer Upgrade';
		testCase.CH_Repeatability__c = 'Occasional';
		System.assert(!String.isEmpty(testCase.Account.AccountNumber));
		testCase.Account.NCP_P20_ID__c = 'test p20 id';
		noValidationErrors = CH_CaseField_SideHighlightApex.transferRndRequiredFieldsCheck(testCase);
		System.assert(noValidationErrors);
		Test.stopTest();
	}
	
	@isTest
	private static void transferRndAccessCheckTest() {
		CH_AvoidRecursion.doNtExcuteCseTrggr4NotfcationBtch = false;
		CH_UTIL_TEST.setupCase();
		Case testCase = CH_UTIL_TEST.getProblem();
		insert testCase;

		testCase = [SELECT Id FROM Case];

		Test.startTest();
		testCase.CH_RDInterface__c = 'JIRA';
		testCase.CH_CustomerDescription__c = 'test123';
		testCase.CH_IssueDescription__c = 'test44';
		update testCase;
		
		String interfaceName = CH_CaseField_SideHighlightApex.transferRndAccessCheck(testCase.Id);
		System.assertEquals(interfaceName, 'JIRA');  
		
		CH_Problem_RnD_Reference__c transferToRndOutboundInteraction = new CH_Problem_RnD_Reference__c(CH_Related_Record__c = testCase.Id, 
																									   CH_RnD_Type__c = 'Transfer to R&D', 
																									   CH_RnD_Interface__c = 'PRONTO',
																									   CH_RnD_Direction__c = 'outbound');
		insert transferToRndOutboundInteraction;
		interfaceName = CH_CaseField_SideHighlightApex.transferRndAccessCheck(testCase.Id);
		System.assert(String.isEmpty(interfaceName));
		
		
	   
	  Id devRecordTypeId = Schema.SObjectType.Knowledge__kav.getRecordTypeInfosByName().get('Known Error').getRecordTypeId();
		
		CH_CaseField_SideHighlightApex.closeProblemRecord(testCase.Id,'Workaround Provided');
		CH_CaseField_SideHighlightApex.transferRndFlowFieldsQuery(testCase.Id);
		
   
	// 
	 
		CH_CaseField_SideHighlightApex.disablebuttoncheckcreateArticle(testCase.Id);
		CH_CaseField_SideHighlightApex.sendCreateAnalysisRndInteraction(transferToRndOutboundInteraction.Id);
		
		
		CH_CaseField_SideHighlightApex.disablebuttoncheckGenerateSDR(testCase.Id);
		CH_CaseField_SideHighlightApex.disableSharebutton(testCase.Id);
	   // CH_CaseField_SideHighlightApex.disablesetissueresolved(testCase.Id);
		 Test.stopTest();
				
	}
	
   /* @istest
	private static void closeProblemRecordTest(){
	
	CH_UTIL_TEST.setupCase();
		Case testCase = CH_UTIL_TEST.getProblem();
		insert testCase;

		testCase = [SELECT Id, CH_RDInterface__c, CH_Originating_Incident_Number__c, Subject, CH_CustomerDescription__c, CH_ProblemStatement__c, Severity__c, 
						CH_AssessedOutage__c, CH_ReportedDate__c, ProductId, CH_Product_Release__c, CH_Problem_Type__c, CH_Pronto_Group__c, CH_Discovered_in__c, 
						CH_Repeatability__c, Account.AccountNumber, Account.NCP_P20_ID__c, CH_ProductVariant__c
					FROM Case];
					
	CH_Problem_RnD_Reference__c transferToRndOutboundInteraction = new CH_Problem_RnD_Reference__c(CH_Related_Record__c = testCase.Id, 
																									   CH_RnD_Type__c = 'Transfer to R&D', 
																									   CH_RnD_Interface__c = 'PRONTO',
																									   CH_RnD_Direction__c = 'outbound');
		insert transferToRndOutboundInteraction;
			
		
		
	}*/
}