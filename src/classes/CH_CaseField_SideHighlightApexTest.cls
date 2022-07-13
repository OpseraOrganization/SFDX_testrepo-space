@IsTest 
public class CH_CaseField_SideHighlightApexTest
{
	public static final String casesubject = 'Test call';
	public static final String casedecription = 'test description';
	private static void setuptestdata()
	{  
		//Creating Custom Setting Data
		CH_AccountName__c accauth = new CH_AccountName__c();
		accauth.CH_InvalidName__c = 'Nokia';
		accauth.CH_ValidName__c = 'Nokia-OYJ';
		insert accauth; 
		
		Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
		Account CreateAccountObj =new Account();//Create Account Object
		CreateAccountObj.Region__c='Asia and Japan';
		CreateAccountObj.name='accountName';
		CreateAccountObj.Market_Segment__c='CABLE';
		CreateAccountObj.Activity_Sector_Name__c = 'CABL-CABlE PROVIDERS';
		CreateAccountObj.Website='Nokia.com';
		CreateAccountObj.Customer_Compliance__c='unassign';
		if(accountRecordTypeId != null){
			CreateAccountObj.RecordTypeId =accountRecordTypeId;
			CreateAccountObj.BusinessPartnerRole__c='Alliance';
			CreateAccountObj.CBT_CT_Code__c ='INDIA ID CT Idea';
			CreateAccountObj.BillingCity ='Atlanta' ;
			CreateAccountObj.BillingCountry='United States of America';
			CreateAccountObj.BillingLatitude=13.0827;
			CreateAccountObj.BillingLongitude=80.2707;
			CreateAccountObj.BillingPostalCode='600075';
			CreateAccountObj.BillingState='Georgia';
			CreateAccountObj.BillingStreet='water well street';
			insert CreateAccountObj;
			
			Product2 CreateProductObj =new Product2();//Create Product Object
			CreateProductObj.Name ='TestProduct';
			CreateProductObj.DataUsage__c='productObj Data Usage';
			CreateProductObj.NCP_CAREACTIVATE__c='productObj NCP AREACTIVATE c';
			CreateProductObj.PMD_Portfolio_Classification__c='Product';
			insert CreateProductObj;
			
			List<Account> accountLst = new  List<Account>();
			
			Id LERecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
			Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(); 
			accountLst = TestDataFactory.createAccount(2);
			accountLst[0].recordtypeid = custRecordTypeId;
			accountLst[1].recordtypeid = LERecordTypeId;
			
			database.insert(accountLst[0]); 
			accountLst[1].parentid = accountLst[0].id;
			accountLst[1].Default_Legal_Entity__c = false;
			accountLst[1].AccountNumber = '1000087011';
			database.insert(accountLst[1]); 
			
			Contact createContactRecrd = new Contact();
			createContactRecrd.FirstName = 'Showket';
			createContactRecrd.LastName = 'Bhat';
			createContactRecrd.CurrencyIsoCode = 'EUR';
			createContactRecrd.Phone = '1234234534';
			createContactRecrd.Market__c = 'Market India';
			createContactRecrd.CH_PreferredMtdOfServiceCommunication__c = 'Email';
			createContactRecrd.CH_ContactTimeZone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
			createContactRecrd.Email = 'showket.bhat@accenture.com';
			createContactRecrd.CH_ContactType__c = 'Customer';
			createContactRecrd.accountId = CreateAccountObj.Id;
			Insert createContactRecrd; 
			
			List<Case> listOfCases = new List<Case>();
			Case caseObj = new Case();
			caseObj.AccountId =accountLst[1].Id ;
			caseObj.ProductId = CreateProductObj.Id;
			caseObj.CreatedDate=Date.today();
			caseObj.OwnerId = UserInfo.getUserId();
			caseObj.Status = 'Created';
			caseObj.Country__c = 'India';
			caseObj.CH_Outage__c = 'No';
			caseObj.CH_InitialDiagnosis__c = 'testt';
			caseObj.Severity__c = 'Minor';
			caseObj.CH_IssueOccurenceDate__c = Date.today();
			caseObj.of_Employees_to_represent_Nokia_CP__c = '0-10%';
			caseObj.Subject = casesubject;
			caseObj.Description = casedecription;
			caseObj.CH_ProblemDisassociationReason__c='test';
			caseObj.CH_ReportedDate__c = Date.today().addDays(-1);
			caseObj.CH_IssueOccurenceDate__c = Date.today().addDays(-1);
			caseObj.RecordTypeId =Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaStandardCase').getRecordTypeId();
			caseObj.CH_Reassignment__c=true;
			caseObj.ContactId=createContactRecrd.Id;
			insert caseObj;
			listOfCases.add(caseObj);
			
			Case caseObj1 = new Case();
			caseObj1.AccountId =accountLst[1].Id ;
			caseObj1.ProductId = CreateProductObj.Id;
			caseObj1.CreatedDate=Date.today();
			caseObj1.OwnerId = UserInfo.getUserId();
			caseObj1.Status = 'Created';
			caseObj1.Country__c = 'India';
			caseObj1.CH_Outage__c = 'No';
			caseObj1.CH_InitialDiagnosis__c = 'testt';
			caseObj1.Severity__c = 'Minor';
			caseObj1.CH_IssueOccurenceDate__c = Date.today();
			caseObj1.of_Employees_to_represent_Nokia_CP__c = '0-10%';
			caseObj1.Subject = casesubject;
			caseObj1.Description = casedecription;
			caseObj1.CH_ProblemDisassociationReason__c='test';
			caseObj1.CH_ReportedDate__c = Date.today().addDays(-1);
			caseObj1.CH_IssueOccurenceDate__c = Date.today().addDays(-1);
			caseObj1.RecordTypeId =Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
			caseObj1.CH_Reassignment__c=true;
			caseObj1.ContactId=createContactRecrd.Id;
			caseObj1.CH_Workaround_Available__c = 'No';
			insert caseObj1;
			
			Case caseObj2 = new Case();
			caseObj2.AccountId =accountLst[1].Id ;
			caseObj2.ProductId = CreateProductObj.Id;
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
			caseObj2.Subject = casesubject;
			caseObj2.Description = casedecription;
			caseObj2.CH_ProblemDisassociationReason__c='test';
			caseObj2.RecordTypeId =Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_Problem').getRecordTypeId();
			caseObj2.CH_Reassignment__c=true;
			caseObj2.ContactId=createContactRecrd.Id;
			
			Test.StartTest();
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
			CH_OutageDuration__c odr = new CH_OutageDuration__c();
			odr.CH_SupportTicket__c = caseObj1.Id;
			CH_CaseField_SideHighlightApex.checkODRValidationQuery(caseObj1.Id);
			CH_CaseField_SideHighlightApex.transferNewProblemDetailsQuery(CreateProductObj.Id);
			List<string> strlist = new List<string>();
			CH_CaseField_SideHighlightApex.invokeFromFlowsendCreateAnalysisRndInteraction(strlist);
			CH_CaseField_SideHighlightApex.hasCaseEditAcess(caseObj.Id,new list<String>());
			Test.StopTest();
		}
	}
	@IsTest
	public  Static void setAssignmentTest()
	{
		setuptestdata();
		sObject sObj = Schema.getGlobalDescribe().get('case').newSObject() ;
		sObj =[Select Id From case  Limit 1 ];
		system.assertNotEquals(sObj, null);
		CH_CaseField_SideHighlightApex.setAssignment(sObj.Id);
		
	}
	
	@IsTest
	public  Static void setDisplayWorkgroupInstructionsTest()
	{
		setuptestdata();
		sObject sObj = Schema.getGlobalDescribe().get('case').newSObject() ;
		sObj =[Select Id From case  Limit 1 ];
		system.assertNotEquals(sObj, null);
		CH_CaseField_SideHighlightApex.displayWorkgroupInstructions(sObj.Id);
		
	}
	
	@IsTest
	public  Static void checkTCAReadyTest()
	{
		setuptestdata();
		sObject sObj = Schema.getGlobalDescribe().get('case').newSObject() ;
		sObj =[Select Id From case  Limit 1 ];
		system.assertNotEquals(sObj, null);
		CH_CaseField_SideHighlightApex.checkTCAReady(sObj.Id);
	}
	
	@IsTest
	public  Static void accessCheckTest()
	{
		setuptestdata();
		sObject sObj = Schema.getGlobalDescribe().get('case').newSObject() ;
		sObj =[Select Id From case  Limit 1 ];
		system.assertNotEquals(sObj, null);
		CH_CaseField_SideHighlightApex.accessCheck(sObj.Id);
		sObject sObj2 = Schema.getGlobalDescribe().get('case').newSObject() ;
		sObj2 =[Select Id,Country__c From case where Country__c!=null  Limit 1 ];
		ISO_Country_Codes__c is=new ISO_Country_Codes__c();
		is.NCIBURL__c = 'https://www.test.com' ;
		is.Name = 'IN';
		is.Country_Name__c = 'India';
		insert is;
		CH_CaseField_SideHighlightApex.fetchCaseDetails(sObj2.Id);
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
		CH_ProductRelease__c testProductRelease = CH_UTIL_TEST.createS2SRelease('testRelease', '12364', testCase.ProductId);
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
	
		CH_CaseField_SideHighlightApex.closeProblemRecord(testCase.Id,'Workaround Provided');
		CH_CaseField_SideHighlightApex.transferRndFlowFieldsQuery(testCase.Id);
		CH_CaseField_SideHighlightApex.disablebuttoncheckcreateArticle(testCase.Id);
		CH_CaseField_SideHighlightApex.sendCreateAnalysisRndInteraction(transferToRndOutboundInteraction.Id);
		CH_CaseField_SideHighlightApex.disablebuttoncheckGenerateSDR(testCase.Id);
		CH_CaseField_SideHighlightApex.disableSharebutton(testCase.Id);
		CH_CaseField_SideHighlightApex.getCaseTag(testCase.Id);
		CH_CaseField_SideHighlightApex.getCaseDetails(testCase.Id);
		CH_CaseField_SideHighlightApex.validUser(testCase.Id);
		CH_CaseField_SideHighlightApex.caseOwnerUpdate(testCase.Id);
		CH_CaseField_SideHighlightApex.isPausedDate(testCase.Id);//Changes added for NOKIASC-35322
		CH_CaseField_SideHighlightApex.getPrivateFeedRecord(testCase.Id);//Changes added for NOKIASC-24257
		try{
		CH_CaseField_SideHighlightApex.updateComment(testCase.Id,'comment');
		}
		catch(Exception e){
			System.assert(e.getMessage()!=null);
		}
		string values=CH_CaseField_SideHighlightApex.getArticaleKnownError(testCase.Id);
		System.assertEquals(values,values);
		Test.stopTest();
	}
	
	//Changes added for NOKIASC-24257
	@isTest
	private static void isAccessEnabledTest() {
		System.runAs ( new User(Id = UserInfo.getUserId()) ) {
			setuptestdata();
			sObject sObj = Schema.getGlobalDescribe().get('case').newSObject() ;
			sObj =[Select Id From case  Limit 1 ];
			system.assertNotEquals(sObj, null);
			CollaborationGroup insertGroupRec = new CollaborationGroup(Name = 'Test1', CollaborationType = 'Private');
			insert insertGroupRec;
			
			Profile prof = [select id from profile where name LIKE '%System%'];
			
			User createUserRecord = new User(Alias = 'sd', Email='testmail@testorg.com', 
			EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
			LocaleSidKey='en_US', ProfileId = prof.Id, 
			TimeZoneSidKey='America/Los_Angeles', UserName='testmail@testorg.com');
			insert createUserRecord;
			
			collaborationgroupmember createGroupMemRec = new collaborationgroupmember();
			createGroupMemRec.CollaborationGroupId = insertGroupRec.Id;
			createGroupMemRec.MemberId = createUserRecord.Id;
			createGroupMemRec.CollaborationRole = 'Standard';
			createGroupMemRec.NotificationFrequency='P';
			insert createGroupMemRec;
			CH_PrivateFeed__c createFeedRecord =  new CH_PrivateFeed__c(ch_problem__c=sObj.Id);
			insert createFeedRecord;
			//Create Related Feed Item Record
			FeedItem feedItem = new FeedItem(ParentId = createFeedRecord.Id, Body = 'Test Body');
			insert feedItem;
			CH_CaseField_SideHighlightApex.getPrivateFeedRecord(sObj.Id);
			CH_CaseField_SideHighlightApex.savePrivateFeed(createFeedRecord.Id,'testNotes','testdate',null);//NOKIASC-35878
			CH_CaseField_SideHighlightApex.createorUpdatePrivateFeedRecord(sObj.Id,'testdates',null);//NOKIASC-35878
			CH_CaseField_SideHighlightApex.updateProblemRecord(sObj.Id,'testPb',null);//NOKIASC-35878
			Boolean isAccessEnabled= CH_CaseField_SideHighlightApex.isAccessEnabled(sObj.Id);
			
		}
	}
}