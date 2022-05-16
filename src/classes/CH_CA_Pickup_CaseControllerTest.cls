@isTest
public class CH_CA_Pickup_CaseControllerTest {
	
	@testSetup
	public static void setup(){
		Test.startTest();
		CH_UTIL_TEST.setupCase(false);	
		Test.stopTest();
	} 
	@isTest
	public static void workgroupMemberWrapper()
	{		
		CH_CA_Pickup_CaseController.CaseWrapper caseWrapper = new CH_CA_Pickup_CaseController.CaseWrapper() ;
		caseWrapper.oCase=new Case();
		caseWrapper.targetDate=null;  
		CH_CA_Pickup_CaseController.WorkgroupMemberWrapper workgroupMemberWrapper = new CH_CA_Pickup_CaseController.WorkgroupMemberWrapper() ;
		workgroupMemberWrapper.Id=null;
		workgroupMemberWrapper.Country=null;		
		workgroupMemberWrapper.Name=null; 
		workgroupMemberWrapper.LastCaseAssigned=null; 
		workgroupMemberWrapper.TotalCaseAssigned=null; 
		workgroupMemberWrapper.TotalCaseAssignedInWorkgroup=null; 
		workgroupMemberWrapper.TotalCaseAssignedOnPendingCustomer=null; 
	}
	
	@isTest
	public static void getCasesForIncidentAndCustomerSupport()
	{
		String caseTypeIncident='Incident';
		String customerSupportServiceType='Customer Support'; 
		system.runAs(new User(Id = Userinfo.getUserId())){
			Test.startTest();
			// Get the workgroup
			CH_workgroup__c gtWorkgroup = [SELECT Id FROM CH_workgroup__c WHERE Name =:CH_UTIL_TEST.WORKGROUPNAME LIMIT 1];			
			CH_Workgroup_Member__c gtWorkgroupMember = [SELECT Id,CH_User__c FROM CH_Workgroup_Member__c WHERE Name =:CH_UTIL_TEST.TEST_QUEUE_LABEL LIMIT 1];			
			Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);			
			newCase.CH_ServiceType__c='Customer Support';
			newCase.OwnerId=gtWorkgroupMember.CH_User__c;
			newCase.CH_Workgroup__c=gtWorkgroup.Id;
			Insert newCase;			
			list<CH_CA_Pickup_CaseController.CaseWrapper> allCases = new list<CH_CA_Pickup_CaseController.CaseWrapper>();		 
			allCases = CH_CA_Pickup_CaseController.getCases(caseTypeIncident, customerSupportServiceType);	
			Test.stopTest();
			
		}
	}
	@isTest
	public static void getCasesForIncidentAndInternalSupport()
	{
		Test.startTest();
		String caseTypeInc='Incident';
		String serviceTypeInternalSprt='Internal Support';
		system.runAs(new User(Id = Userinfo.getUserId())){		
			
			Account legalAccount = [SELECT Id,ParentId FROM Account WHERE Name = 'LEGAL-ACCOUNT' LIMIT 1];
			
			// Get the workgroup
			CH_workgroup__c workgroup = [SELECT Id FROM CH_workgroup__c WHERE Name =:CH_UTIL_TEST.WORKGROUPNAME LIMIT 1];			
			CH_Workgroup_Member__c workgroupMember = [SELECT Id,CH_User__c FROM CH_Workgroup_Member__c WHERE Name =:CH_UTIL_TEST.TEST_QUEUE_LABEL LIMIT 1];
			// Create Contact 'Nokia Employee'
			Contact testContact = new Contact(
	LastName = 'test',
	FirstName = 'test',
	Email = 'test@email.com',
	AccountId = legalAccount.ParentId,
	CH_ContactType__c = 'Nokia Employee'
			);
			insert testContact;
			// Test.startTest(); 
			//Create cae
			Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);			
			newCase.CH_ServiceType__c='Internal Support';
			newCase.OwnerId=workgroupMember.CH_User__c;
			newCase.CH_Workgroup__c=workgroup.Id;
			newCase.ContactId=testContact.Id;
			Insert newCase; 
			
			//get cases for Incident and serviceType='Internal Support'
			list<CH_CA_Pickup_CaseController.CaseWrapper> allCases = CH_CA_Pickup_CaseController.getCases(caseTypeInc, serviceTypeInternalSprt);	  
			Test.stopTest();
			
		}
	}
	@isTest
	public static void getCasesForProblem()
	{
		String caseTypePblm='Problem';
		String serviceTyp='';	
		system.runAs(new User(Id = Userinfo.getUserId())){
			Test.startTest();
			// Get the workgroup
			CH_workgroup__c workgroup = [SELECT Id FROM CH_workgroup__c WHERE Name =:CH_UTIL_TEST.WORKGROUPNAME LIMIT 1];			
			CH_Workgroup_Member__c workgroupMember = [SELECT Id,CH_User__c FROM CH_Workgroup_Member__c WHERE Name =:CH_UTIL_TEST.TEST_QUEUE_LABEL LIMIT 1];
			// Create User workgroup member
			CH_Workgroup_Member__c member = new CH_Workgroup_Member__c ();
			member.CH_User__c = Userinfo.getUserId();
			member.CH_Role__c = 'Engineer'; 
			member.CH_Workgroup__c = workgroup.Id;
			member.CH_Workgroup_Member_Type__c = 'User';			
			insert member;	 
			
			Case testCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_Problem', false);
			testCase.CH_Problem__c = null;
			testCase.OwnerId=workgroupMember.CH_User__c;
			testCase.CH_Workgroup__c=workgroup.Id;
			insert testCase;		
			list<CH_CA_Pickup_CaseController.CaseWrapper> allCases = new list<CH_CA_Pickup_CaseController.CaseWrapper>();		 
			allCases = CH_CA_Pickup_CaseController.getCases(caseTypePblm, serviceTyp);
			Test.stopTest();
		}	
	}
	@isTest
	public static void saveCasesForAcceptIncident()
	{
		String caseType='Incident';
		String serviceType='Customer Support'; 
		system.runAs(new User(Id = Userinfo.getUserId())){
			// Get the workgroup
			CH_workgroup__c workgroup = [SELECT Id FROM CH_workgroup__c WHERE Name =:CH_UTIL_TEST.WORKGROUPNAME LIMIT 1];		
			CH_Workgroup_Member__c workgroupMember = [SELECT Id,CH_User__c FROM CH_Workgroup_Member__c WHERE Name =:CH_UTIL_TEST.TEST_QUEUE_LABEL LIMIT 1];	
			// Create User workgroup member
			CH_Workgroup_Member__c member = new CH_Workgroup_Member__c ();
			member.CH_User__c = Userinfo.getUserId();
			member.CH_Role__c = 'Engineer'; 
			member.CH_Workgroup__c = workgroup.Id;
			member.CH_Workgroup_Member_Type__c = 'User';		
			insert member;			
			Test.startTest(); 
			Group grp =  [SELECT Id, Name , type FROM Group where type='Regular' and name = 'SEC_GWC|ALL'];
			GroupMember grpmember = new GroupMember(UserOrGroupId=Userinfo.getUserId(),GroupId=grp.Id);
			insert grpmember;
			Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);			
			newCase.CH_ServiceType__c='Customer Support';
			newCase.OwnerId=workgroupMember.CH_User__c;
			newCase.CH_Workgroup__c=workgroup.Id;
			newCase.CH_SecurityGroup__c = grp.Name;
			Insert newCase;		 
			List<Case> selectedCases=new List<Case>();
			selectedCases.add(newCase);
			
			String returnMsg=CH_CA_Pickup_CaseController.saveCases(JSON.serialize(selectedCases), caseType, serviceType);		
			Test.stopTest(); 
	
		}
	}
	@isTest
	public static void getValidWorkgroupMembersForDashboard()
	{
		
		system.runAs(new User(Id = Userinfo.getUserId())){
			test.starttest();	
			// Get the workgroup
			CH_workgroup__c workgroup = [SELECT Id FROM CH_workgroup__c WHERE Name =:CH_UTIL_TEST.WORKGROUPNAME LIMIT 1];		
			CH_Workgroup_Member__c workgroupMember = [SELECT Id,CH_User__c FROM CH_Workgroup_Member__c WHERE Name =:CH_UTIL_TEST.TEST_QUEUE_LABEL LIMIT 1];	
			// Create User workgroup member
			CH_Workgroup_Member__c member = new CH_Workgroup_Member__c ();
			member.CH_User__c = Userinfo.getUserId();
			member.CH_Role__c = 'Engineer';
			member.Name=Userinfo.getName();
			member.CH_Workgroup__c = workgroup.Id;
			member.CH_Workgroup_Member_Type__c = 'User';		
			insert member; 
			Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);			
			newCase.OwnerId=workgroupMember.CH_User__c;
			newCase.CH_Workgroup__c=workgroup.Id;			
			Insert newCase;			
			test.stoptest();
			List<CH_CA_Pickup_CaseController.WorkgroupMemberWrapper> getWorkgroupMembers=  CH_CA_Pickup_CaseController.getValidWorkgroupMembers(newCase.Id, workgroup.Id);
			
		}
	}
	@isTest
	public static void updateSupportTicketOwnerForDispatch()
	{
		String caseType='Incident';
		String serviceType='Customer Support'; 
		
		// Get the workgroup
		CH_workgroup__c workgroup = [SELECT Id FROM CH_workgroup__c WHERE Name =:CH_UTIL_TEST.WORKGROUPNAME LIMIT 1];		
		CH_Workgroup_Member__c workgroupMember = [SELECT Id,CH_User__c FROM CH_Workgroup_Member__c WHERE Name =:CH_UTIL_TEST.TEST_QUEUE_LABEL LIMIT 1];	  
		// Create User workgroup member
		CH_Workgroup_Member__c member = new CH_Workgroup_Member__c ();
		member.CH_User__c = Userinfo.getUserId();
		member.CH_Role__c = 'Engineer';
		member.Name = Userinfo.getName();
		member.CH_Workgroup__c = workgroup.Id;
		member.CH_Workgroup_Member_Type__c = 'User';
		insert member; 
		
		try{
			Test.startTest();	  
			Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);			
			newCase.CH_ServiceType__c='Customer Support';
			newCase.OwnerId=workgroupMember.CH_User__c;
			newCase.CH_Workgroup__c=workgroup.Id;
			Insert newCase; 
			CH_CA_Pickup_CaseController.updateSupportTicketOwner(newCase.Id, member.Id,caseType,serviceType); 
			Test.stopTest(); 
		}
		catch(Exception e){
			string errorMsg=e.getMessage();
			System.assert(errorMsg != '','Expect message . Actual ' + errorMsg);
		}
		
	}
	@isTest
	public static void updateSupportTicketOwnerForDispatchIfCaseExists()
	{
		String caseType='Incident';
		String serviceType='Customer Support'; 
		try{
			// Get the workgroup
			CH_workgroup__c workgroup = [SELECT Id FROM CH_workgroup__c WHERE Name =:CH_UTIL_TEST.WORKGROUPNAME LIMIT 1];		
			CH_Workgroup_Member__c workgroupMember = [SELECT Id,CH_User__c FROM CH_Workgroup_Member__c WHERE Name =:CH_UTIL_TEST.TEST_QUEUE_LABEL LIMIT 1];		
			Test.startTest();
			Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaStandardCase', false);			
			newCase.CH_ServiceType__c='Customer Support';
			Insert newCase;		 
			CH_Workgroup_Member__c workgroupMemberToAdd = [SELECT Id FROM CH_Workgroup_Member__c WHERE CH_User__c =:workgroupMember.CH_User__c AND CH_workgroup__c=:workgroup.Id LIMIT 1];		
			CH_CA_Pickup_CaseController.updateSupportTicketOwner(newCase.Id, workgroupMemberToAdd.Id,caseType,serviceType);		
			Test.stopTest();
		}
		catch(Exception e){			
			string errorMsg=e.getMessage();
			System.assert(errorMsg != '','Expect message . Actual ' + errorMsg);
		}		
	} 
	 @isTest
	public static void myDesktopToggle(){
		string testemail = 'test2@test.com';
		integer NokiaId = 100;  
		User runAsUser = new User(Id = UserInfo.getUserId());
		Test.startTest();
		User chUser;
		System.runAs(runAsUser) {
			Profile profile = [Select Id from Profile where name = 'System Administrator' LIMIT 1];
			
			chUser = new User(
				Lastname='NONPORTAL1',
				Firstname='NONPORTAL1',
				Alias = 'TSTNP1',
				ProfileId = profile.Id,
				Username = System.now().millisecond() + 'TSTNP1@test.com',
				Email= System.now().millisecond() + testemail,
				EmailEncodingKey='UTF-8',
				LanguageLocaleKey='en_US',
				LocaleSidKey='en_US',
				TimeZoneSidKey='America/Chicago',
				Nokia_ID__c = 'CHTEST' + String.valueOf(NokiaId++)
			);
			
			
			CH_CA_Pickup_CaseController.addToDesktopView('SWS Tickets','');	
			CH_CA_Pickup_CaseController.addToDesktopView('HWS Tickets','SWS Tickets');
			CH_CA_Pickup_CaseController.removeFromDesktopView('SWS Tickets','Both');
			CH_CA_Pickup_CaseController.removeFromDesktopView('HWS Tickets','Both');
			CH_CA_Pickup_CaseController.removeFromDesktopView('HWS Tickets','HWS Tickets');
			Test.stopTest();
			
		}
	}
}