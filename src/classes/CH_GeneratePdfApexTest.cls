@IsTest
public class CH_GeneratePdfApexTest {
	@testSetup   
	static void setuptestdata()
	{  //Creating Custom Setting Data
		CH_AccountName__c accauth = new CH_AccountName__c();
		accauth.CH_InvalidName__c = 'Nokia';
		accauth.CH_ValidName__c = 'Nokia-OYJ';
		insert accauth;
		
		Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
		Account accountobj =new Account();//Create Account Object
		accountobj.Region__c='Asia and Japan';
		accountobj.Country__c ='Albania';
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
			accountobj.BillingCity ='Chennai' ;
			accountobj.BillingCountry='india';
			accountobj.BillingLatitude=13.0827;
			accountobj.BillingLongitude=80.2707;
			accountobj.BillingPostalCode='600075';
			accountobj.BillingState='tamil nadu';
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
			caseObj.RecordTypeId =Schema.SObjectType.case.getRecordTypeInfosByName().get('Nokia Standard Case').getRecordTypeId();
			caseObj.CH_Reassignment__c=true;
			caseObj.ContactId=con.Id;
			caseObj.CH_ReportedDate__c = date.today();
			caseObj.CH_IssueDescription__c = 'test';
			caseObj.CH_SequenceOfEvents__c = 'test';
			caseObj.CH_RestorationMethod__c = 'test';
			caseObj.CH_TechnicalAnalysis__c = 'test';
			caseObj.CH_TemporarySolution__c = 'test';
			caseObj.CH_SolutionDetails__c = 'test';
			insert caseObj;
			listCase.add(caseObj);
		  
	}
	}
	
	@IsTest
		public  Static void CH_GeneratePdfApexTest()
		{   
		 Test.startTest();
		 
		 Case caseObj =[Select Id ,caseNumber From case  Limit 1 ];
		  system.debug('caseObj===='+caseObj);  
		 PageReference pageRef = Page.CH_GeneratePdf;
		 Test.setCurrentPage(pageRef);
		  ApexPages.currentPage().getParameters().put('id', String.valueOf(caseObj.Id));
		 ApexPages.StandardController sc = new ApexPages.standardController(caseObj);
		 CH_GeneratePdfApex testController = new CH_GeneratePdfApex(sc);
		  User abc = CH_GeneratePdfApex.userDetails;
		  string RootCauseDescription;
		  string StepsToReproduceIssue;
		  string SummaryOfAnalysis;
		  string ActionTaken;
		  string PreventiveActions;
		  string CorrectiveActions;
		  string IssueDescription;
		  string RestorationMethod;
		  string TechnicalAnalysis;
		  string TemporarySolution;
		  string SolutionDetails;
		  string SequenceOfEvents;
		  
		  testController.RootCauseDescription = 'testtest';
		  testController.StepsToReproduceIssue = 'testtesttesttesttesttesttesttesttesttesttesttest testtesttesttesttesttesttesttesttesttesttesttest';
		  testController.SummaryOfAnalysis = 'testest';
		  
		  testController.ActionTaken = 'testtest';
		  testController.PreventiveActions = 'testtesttesttesttesttesttesttesttesttesttesttest testtesttesttesttesttesttesttesttesttesttesttest';
		  testController.CorrectiveActions = 'testest';
		  testController.IssueDescription = 'testtest';
		  testController.SequenceOfEvents = 'testtesttesttesttesttesttesttesttesttesttesttest testtesttesttesttesttesttesttesttesttesttesttest';
		  testController.RestorationMethod = 'testest';
		  testController.TechnicalAnalysis = 'testtest';
		  testController.TemporarySolution = 'testtesttesttesttesttesttesttesttesttesttesttest testtesttesttesttesttesttesttesttesttesttesttest';
		  testController.SolutionDetails = 'testest';
		  
		  testController.process();
		  testController.getFormattedString('test test');
			List<CaseTeamMember> caseMemberList = new List<CaseTeamMember>();
			CaseTeamMember memberObj = new CaseTeamMember();
			memberObj.ParentId = caseObj.id;
			memberObj.MemberId = UserInfo.getUserId();
			memberObj.TeamRoleId = [SELECT Id , Name FROM CaseTeamRole WHERE Name='Customer Care Manager' LIMIT 1].Id;
			caseMemberList.add(memberObj);
			if(!caseMemberList.isEmpty()){
				insert caseMemberList;
			}
			
		 
			CH_GeneratePdfApex.careManager();
		 Test.stopTest();
		}
   

}