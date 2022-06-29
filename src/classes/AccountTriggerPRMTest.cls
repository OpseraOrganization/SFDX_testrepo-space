/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
Name:			AccountTriggerPRMTest 
Description:	 AccountTriggerHelperPRM Test class to test the class
Date	Version		 Author		Summary of Changes 
-----------	  ----------	  -----------------	---------------------------------------------------------------------------------------------------
07/27/2017		 1.0			Prateek Prasoon	  Code coverage for AccountTriggerHelperPRM class

----------------------------------------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class AccountTriggerPRMTest {
	
	@testSetup static void createTestData() {
		NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
	}
	static testMethod void partnerCompanyInsert(){
	
		Account acc = new Account();
		acc = TestDataFactory.createAccount(1)[0];
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		acc.Market__c = 'Market India';
		acc.Partner_Type__c = 'Alliance Partner';
		acc.Name = 'STARHUB LIMITED';
		acc.Country__c='India';
		acc.BillingCountry  = 'India';
		acc.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
		acc.Active__c = false ;
		acc.Partner_Disable__c = false;
		acc.Enrolled_in_Co_Op__c = True;
	
		insert acc;
		acc.IsPartner = true ;
		acc.Active__c = true ;
		acc.Partner_Type__c = 'Distributor';
		acc.Partner_Disable__c = true;
	
		Test.startTest();
		update acc;
		Test.stopTest();
		
	}
	static testMethod void partnerCompanyUpdate(){
	 String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(PRMGlobalConstants.COLON,'').replace(PRMGlobalConstants.HYPHEN,'');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;   
		user user  = new user();
	List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		runAsUSer[0].Nokia_ID__c = randomInt + '0';
		runAsUSer[1].Nokia_ID__c = randomInt + '0';
		database.insert(runAsUSer);
		system.runAs(runAsUSer[0]){
			Account acc = new Account();
			acc = TestDataFactory.createAccount(1)[0];
			acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
			acc.Market__c = 'Market India';
			acc.Partner_Type__c = 'Indirect Reseller';
			acc.Name = 'STARHUB LIMITED';
			acc.Country__c='India';
			acc.BillingCountry  = 'India';
			acc.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
			insert acc;
			acc.Enrolled_in_Co_Op__c = True;
			update acc;
			Contact con = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=acc.id,Email=PRMGlobalConstants.EmailContactNamePRM);
			database.insert(con);
			User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',		 lastname = 'Testing',
	languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
	timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = con.Id );
	
			database.insert(userPRM); 
			acc.Active__c = true ;
			acc.Partner_Type__c = 'Distributor';
			update acc;
			acc.Active__c = false ;
			update acc;
			}
		}
	
	 static testMethod void updateCertValueONPaertnerProgramTest(){
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		List<user> runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].Nokia_ID__c = randomInt + '0';
		insert runAsUSer;
		system.runAs(runAsUSer[0]){
		Test.startTest();
		Account acc = new Account();
		acc = TestDataFactory.createAccount(1)[0];
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		acc.Market__c = 'Market India';
		acc.Partner_Type__c = 'Indirect Reseller';
		acc.Name = 'STARHUB LIMITED';
		acc.Country__c='India';
		acc.BillingCountry  = 'India';
		acc.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
		acc.Partner_Program__c = 'GPP 0.0';
		insert acc;
	
		Contact con = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=acc.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		database.insert(con);
		
		Certification_Matrix__c CertMatrix1 = new Certification_Matrix__c(GPP_0_0__c = 'test 10', GPP_1_0__c = 'test 11', GPP_2_0__c = 'test 12', GPP_3_0__c = 'test 13');
		Database.insert(CertMatrix1);
		CertMatrix1.GPP_0_0__c = 'PRMTEST1';
		CertMatrix1.GPP_1_0__c = 'PRMTEST1 1';
		CertMatrix1.GPP_2_0__c = 'PRMTEST1 2';
		CertMatrix1.GPP_3_0__c = 'PRMTEST1 3';
		Database.Update(CertMatrix1);
		
		LIST<Certification__c> certdetailList = new LIST<Certification__c>();
		Certification__c certification1 = new Certification__c(GPP_Certification_Name__c = 'Deployment Installation test', Certification_Matrix_Number__c = CertMatrix1.ID, Name__c = con.Id, 
		Partner__c = acc.ID,  Approvedby_Authority__c = 'No');
		certdetailList.add(certification1);
		Certification__c certification2 = new Certification__c(GPP_Certification_Name__c = 'Deployment Installation test', Certification_Matrix_Number__c = CertMatrix1.ID, Name__c = con.Id, 
		Partner__c = acc.ID,  Approvedby_Authority__c = 'No');
		certdetailList.add(certification2);
		Database.insert(certdetailList);
		Test.stopTest();
		}  
	}
	static testMethod void updateARRtoolstest(){
	 
		Account acc = new Account();
		acc = TestDataFactory.createAccount(1)[0];
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		acc.Market__c = 'Market India';
		acc.Partner_Type__c = 'Indirect Reseller';
		acc.Name = 'STARHUB LIMITED';
		acc.Country__c='India';
		acc.BillingCountry  = 'India';
		acc.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
		acc.Active__c = true ;
		acc.Shift_Model__c = 'None';

		insert acc;
		
		Contact con1 = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=acc.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		database.insert(con1);
		Contact con2 = new Contact(lastName=PRMGlobalConstants.ContactNamePSM,AccountId=acc.id,Email=PRMGlobalConstants.EmailContactNamePSM );
		database.insert(con2);
		
		ARR_Tools__c arrt1 = new ARR_Tools__c(Partner_Type__c='Indirect Reseller',Tool_Name__c='Co-op;Deal Registration');
		database.insert(arrt1);
		ARR_Tools__c arrt2 = new ARR_Tools__c(Partner_Type__c='Distributor',Tool_Name__c='Co-op;Invoice Tracking;USA Pricing');
		database.insert(arrt2);
		
		Additional_Resource_Request__c arr1 = new Additional_Resource_Request__c(Request_Status__c='Request',Partner_Contact__c=con1.id,Additional_Resource__c='Order Tracking',Partner_Account__c=acc.id);
		database.insert(arr1);
		Additional_Resource_Request__c arr2 = new Additional_Resource_Request__c(Request_Status__c='Remove',Partner_Contact__c=con1.id,Additional_Resource__c='Invoice Tracking',Partner_Account__c=acc.id);
		database.insert(arr2);
	
		acc.Partner_Type__c = 'Distributor';
		acc.Shift_Model__c = '8X5';
		update acc;
		
	}
	static testMethod void accountOwnerUpdateTest(){
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		runAsUSer[0].Nokia_ID__c = randomInt + '0';
		runAsUSer[1].Nokia_ID__c = randomInt + '0';
		database.insert(runAsUSer);
		system.runAs(runAsUSer[0]){
			Account acc = new Account();
			acc = TestDataFactory.createAccount(1)[0];
			acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
			Database.Insert(acc);
			Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=acc.id,Email=PRMGlobalConstants.EmailContactNamePRM );
			database.insert(conPRM);
			Certification__c certificationPRM = new Certification__c(Name__c = conPRM.Id, Partner__c = acc.Id, Approvedby_Authority__c = 'No');
			
			List<Certification__c> CertificationListPRM = new List<Certification__c>();
			CertificationListPRM.add(certificationPRM);
			Database.insert(CertificationListPRM);
			
			List<Lead> leadList = new  List<Lead>();
			leadList = TestDataFactory.createLead(1);
			leadList[0].RecordTypeId  = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.INDIRECT_DEAL_REGISTRATION_DEV).getRecordTypeId();
			leadList[0].email = 'test.junrel@lead.com';
			
			List<Account_Member__c> AccountMemList1 = new List<Account_Member__c>();
			Account_Member__c AccountMemPSM1 = new Account_Member__c(Account__c = acc.Id, Account_Role__c = 'Partner Sales Manager', Type__c = 'Internal', Name__c = runAsUSer[0].Id );
			AccountMemList1.add(AccountMemPSM1);
			Database.insert(AccountMemList1);
	}
	}
static testMethod void accountOnwerChange(){
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		Account acc = new Account();
		acc = TestDataFactory.createAccount(1)[0];
		insert acc;
		List<user> runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].Nokia_ID__c = randomInt + '0';
		insert runAsUSer[0];
		List<Id> userIds = new List<Id>();
		userIds.add(runAsUSer[0].Id);
		Test.startTest();
		acc.ownerId = runAsUSer[0].Id;
		system.runAs(runAsUSer[0]) {
			update acc;
		}
		AccountTriggerHelperPRM.createPartnerLibraryAfterInsert(new List<Account>{acc});
		Test.stopTest();
	}
	
	static testMethod void coopEligibleAccountAccrualandFundCreationTest(){
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		Map<Id, Account> accountOldMap = new Map<Id, Account>();
		Map<Id, Account> accountNewMap = new Map<Id, Account>();
		List<Account> accList = new List<Account>();
		Account acc = new Account();
		acc = TestDataFactory.createAccount(1)[0];
		acc.Partner_Type__c = null;
		insert acc;
		accList.add(acc);
		List<user> runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].Nokia_ID__c = randomInt + '0';
		insert runAsUSer[0];
		List<Id> userIds = new List<Id>();
		userIds.add(runAsUSer[0].Id);
		Test.startTest();
			Account acc1 = [select id,Partner_Type__c from Account where id=: acc.Id];
			accountOldMap.put(acc1.Id, acc1);
			acc.Partner_Type__c = 'Distributor';
			update acc;
			Account acc2 = [select id,Partner_Type__c from Account where id=: acc.Id];
			accountNewMap.put(acc2.id,acc2);
			AccountTriggerHelperPRM.createPartnerLibrary(accountOldMap, accountNewMap);
			AccountTriggerHelperPRM.coopEligibleAccountAccrualandFundCreation(accList);
		
		AccountTriggerHelperPRM.createPartnerLibraryAfterInsert(accList);
		AccountTriggerHelperPRM.createPartnerCompany(null,null);
		AccountTriggerHelperPRM.updatePartnerCompanyOnChange(null,null);
		AccountTriggerHelperPRM.deletePartnerCompany(null,null);
		AccountTriggerHelperPRM.updateCertValueONPaertnerProgram(null,null);
		AccountTriggerHelperPRM.createPartnerLibrary(null,null);
		AccountTriggerHelperPRM.createPartnerLibraryAfterInsert(null);
		Test.stopTest();
	}
   
static testMethod void partnerCompanyInsert1(){
	
		Account acc = new Account();
		acc = TestDataFactory.createAccount(1)[0];
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		acc.Market__c = 'Market India';
		acc.Partner_Type__c = 'Alliance Partner';
		acc.Name = 'STARHUB LIMITED';
		acc.Country__c='India';
		acc.BillingCountry  = 'India';
		acc.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
		acc.Active__c = false ;
		acc.Partner_Disable__c = false;
		acc.Enrolled_in_Co_Op__c = True;
	
		insert acc;
		acc.IsPartner = true ;
		acc.Active__c = true ;
		acc.Partner_Type__c = 'Distributor';
		acc.Partner_Disable__c = true;
	
		Test.startTest();
		update acc;
		Test.stopTest();
		
	}
	static testMethod void partnerCompanyUpdate1(){
	 String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(PRMGlobalConstants.COLON,'').replace(PRMGlobalConstants.HYPHEN,'');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;   
		user user  = new user();
	List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		runAsUSer[0].Nokia_ID__c = randomInt + '0';
		runAsUSer[1].Nokia_ID__c = randomInt + '0';
		database.insert(runAsUSer);
		system.runAs(runAsUSer[0]){
			Account acc = new Account();
			acc = TestDataFactory.createAccount(1)[0];
			acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
			acc.Market__c = 'Market India';
			acc.Partner_Type__c = 'Indirect Reseller';
			acc.Name = 'STARHUB LIMITED';
			acc.Country__c='India';
			acc.BillingCountry  = 'India';
			acc.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';

			insert acc;
			acc.Enrolled_in_Co_Op__c = True;
			update acc;
			Contact con = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=acc.id,Email=PRMGlobalConstants.EmailContactNamePRM);
			database.insert(con);
			User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',		lastname = 'Testing',
	languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
	timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = con.Id );
	
			database.insert(userPRM); 
			acc.Active__c = true ;
			acc.Partner_Type__c = 'Distributor';
			acc.Partner_Disable__c=false;
			acc.Co_op_Account_Created__c = 'No';
			update acc;
			
			acc.Active__c = false ;
			acc.Partner_Disable__c=true;
			update acc;
			}
		}
	}