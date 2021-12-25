@IsTest
public class AccountMemberHelperPRMTest {
	@testSetup static void createTestData() {
		NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
	}
	public static testMethod void certificationShareUpadate(){
	 Test.startTest(); 
		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;
	
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		runAsUSer[0].Nokia_ID__c= '6777777666';
		//runAsUser[0].ProfileId = system.label.Nokia_Sales_Profile_Id;
		database.insert(runAsUSer);
		system.runAs(runAsUSer[0]) {
	 
		Account accountCreationPRM = TestDataFactory.createAccount(1)[0];
		accountCreationPRM.AccountNumber = '1234'; 
		Account accountCreationPSM = TestDataFactory.createAccount(1)[0];
		accountCreationPSM.AccountNumber = '12345';
		database.insert(accountCreationPRM);
		database.insert(accountCreationPSM);
	 
		Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=accountCreationPRM.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		database.insert(conPRM);
		User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',		 lastname = 'Testing',
		 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
		 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id, Nokia_ID__c= '6777777666');
		 
		database.insert(userPRM);
		List<User> userList = new List<User>();
	
		
		User userPSM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test', 
			lastname = 'Testing',
		 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.Nokia_Sales_Profile_Id,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
		 timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
		database.insert(userPSM);
		userList.add(userPRM);
		userList.add(userPSM);
		
		 Contact conPSM = new Contact(lastName=PRMGlobalConstants.ContactNamePSM,AccountId=accountCreationPSM.id,Email=PRMGlobalConstants.EmailContactNamePSM,
	OwnerId=userPSM.Id);		
		database.insert(conPSM);
		
		Certification__c certificationPSM = new Certification__c(Name__c = conPSM.Id, Partner__c = accountCreationPSM.Id, Approvedby_Authority__c = 'No',			OwnerId = userPSM.Id);
		Database.insert(certificationPSM);
		List<Account_Member__c> AccountMemList = new List<Account_Member__c>();
	
		Account_Member__c AccountMemPSM = new Account_Member__c(Account__c = accountCreationPSM.Id, Account_Role__c = 'Partner Sales Manager', 
	Type__c = 'Internal', Name__c = userPSM.Id);
		Account_Member__c AccountMemPRM = new Account_Member__c(Account__c = accountCreationPRM.Id, Account_Role__c = 'Partner User', 
	Type__c = 'External', Name__c = userPRM.Id ); 
		Account_Member__c AccountMem1 = new Account_Member__c(Account__c = accountCreationPRM.Id, Account_Role__c = 'Training Manager', 
		Type__c = 'External', Name__c = userPRM.Id );
		Account_Member__c AccountMem2 = new Account_Member__c(Account__c = accountCreationPRM.Id, Account_Role__c = 'Partner User', 
		Type__c = 'External', Name__c = userPRM.Id );
		
		AccountMemList.add(AccountMemPSM);
		AccountMemList.add(AccountMemPRM);
		AccountMemList.add(AccountMem1);
		AccountMemList.add(AccountMem2);
		Database.insert(AccountMemList);
		
		
	
		
	  
		Certification__c certificationPRM = new Certification__c(Name__c = conPRM.Id, Partner__c = accountCreationPRM.Id, Approvedby_Authority__c = 'No');
		Database.insert(certificationPRM);
		
		
		//List<Certification__c> CertificationListPSM = new List<Certification__c>();
	// CertificationListPSM.add(certificationPSM);
		
		certificationPRM.OwnerId = userPRM.Id;
		List<Certification__c> CertificationList=new List<Certification__c>();
		CertificationList.add(certificationPRM);
		
		Database.update(CertificationList);
		certificationPSM.OwnerId = userPSM.Id;
		certificationPSM.Partner__c = accountCreationPSM.Id;
		Database.update(certificationPSM);
	/* AccountMemPSM.Type__c = 'Internal';
		AccountMemPSM.Account_Role__c= 'Marketing Manager';
		AccountMemPSM.Name__c = userPRM.Id;
		AccountMemList.add(AccountMemPSM);
		AccountMemberHelperPRM.shareCertificationOnInsertPSM(AccountMemList,userList);
		
		userPSM.Nokia_ID__c = randomInt + '0';
		update userPSM;*/
		
		List <Contact> lstCont = new List<Contact>();
		Contact con = new Contact(lastName=PRMGlobalConstants.Testtext,AccountId=accountCreationPRM.id,Email=PRMGlobalConstants.TestEmail1 );
		lstCont.add(con); 
		Contact con2 = new Contact(lastName=PRMGlobalConstants.Test2,AccountId=accountCreationPRM.id,Email=PRMGlobalConstants.TestEmail2 );
		lstCont.add(con2);
		Contact con3 = new Contact(lastName=PRMGlobalConstants.Test3,AccountId=accountCreationPRM.id,Email=PRMGlobalConstants.TestEmail3 );
		lstCont.add(con3);
		Contact con4 = new Contact(lastName=PRMGlobalConstants.Test4,AccountId=accountCreationPRM.id,Email=PRMGlobalConstants.TestEmail4 );
		lstCont.add(con4);
		Database.insert(lstCont);
		
		List<Partner_Company__c> pcList = new List<Partner_Company__c>();
		Partner_Company__c pc1 = new Partner_Company__c();
		pc1.Partner_Name__c = accountCreationPRM.id;
		pc1.Country_Headquarters__c = 'Albania';
		pc1.Market__c = 'Market Asia Pacific and Japan';
		pc1.Partner_Type__c = 'Distributor';
		pcList.add(pc1);
		Partner_Company__c pc2 = new Partner_Company__c();
		pc2.Partner_Name__c = accountCreationPRM.id;
		pc2.Country_Headquarters__c = 'Albania';
		pc2.Market__c = 'Market Asia Pacific and Japan';
		pc2.Partner_Type__c = 'Indirect Reseller';
		pcList.add(pc2);
		Database.insert(pcList);
		
		List<Lead> leadList = new  List<Lead>();
		leadList = TestDataFactory.createLead(1);
		leadList[0].RecordTypeId  = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('PRMIndirect_Deal_Registration').getRecordTypeId();
		leadList[0].email = 'test.junrel@lead.com';
		leadList[0].Rejection_Status_For_Approval__c = 'Pending';
		leadList[0].Indirect_Reseller_Company__c = pcList.get(1).Id;
		leadList[0].Distributor_Partner_Company__c  = pcList.get(0).Id;
		leadList[0].OwnerId = userPRM.Id;
		insert leadList; 
	  Test.stopTest();  
		}   
	}
	
	public static testMethod void certificationShareUpadate1(){
	 Test.startTest(); 
		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;
	
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		runAsUSer[0].Nokia_ID__c= '6777777666';
		//runAsUser[0].ProfileId = system.label.Nokia_Sales_Profile_Id;
		database.insert(runAsUSer);
		system.runAs(runAsUSer[0]) {
	 
		Account accountCreationPRM = TestDataFactory.createAccount(1)[0];
		accountCreationPRM.AccountNumber = '1234'; 
		Account accountCreationPSM = TestDataFactory.createAccount(1)[0];
		accountCreationPSM.AccountNumber = '12345';
		database.insert(accountCreationPRM);
		database.insert(accountCreationPSM);
	 
		Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=accountCreationPRM.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		database.insert(conPRM);
		User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',		 lastname = 'Testing',
		 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
		 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id, Nokia_ID__c= '6777777666');
		 
		database.insert(userPRM);
		List<User> userList = new List<User>();
	
		
		User userPSM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test', 
			lastname = 'Testing',
		 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.Nokia_Sales_Profile_Id,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
		 timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
		database.insert(userPSM);
		userList.add(userPRM);
		userList.add(userPSM);
		
		 Contact conPSM = new Contact(lastName=PRMGlobalConstants.ContactNamePSM,AccountId=accountCreationPSM.id,Email=PRMGlobalConstants.EmailContactNamePSM,
	OwnerId=userPSM.Id);		
		database.insert(conPSM);
		
		Certification__c certificationPSM = new Certification__c(Name__c = conPSM.Id, Partner__c = accountCreationPSM.Id, Approvedby_Authority__c = 'No',OwnerId = userPSM.Id);
		Database.insert(certificationPSM);
		List<Account_Member__c> AccountMemList = new List<Account_Member__c>();
	
		Account_Member__c AccountMemPSM = new Account_Member__c(Account__c = accountCreationPSM.Id, Account_Role__c = 'Partner Sales Manager', 
	Type__c = 'Internal', Name__c = userPSM.Id);
		Account_Member__c AccountMemPRM = new Account_Member__c(Account__c = accountCreationPRM.Id, Account_Role__c = 'Partner User', 
	Type__c = 'External', Name__c = userPRM.Id ); 
		Account_Member__c AccountMem1 = new Account_Member__c(Account__c = accountCreationPRM.Id, Account_Role__c = 'Training Manager', 
		Type__c = 'External', Name__c = userPRM.Id );
		Account_Member__c AccountMem2 = new Account_Member__c(Account__c = accountCreationPRM.Id, Account_Role__c = 'Partner User', 
		Type__c = 'External', Name__c = userPRM.Id );
		
		AccountMemList.add(AccountMemPSM);
		AccountMemList.add(AccountMemPRM);
		AccountMemList.add(AccountMem1);
		AccountMemList.add(AccountMem2);
		Database.insert(AccountMemList);
		
		Certification__c certificationPSM1 = new Certification__c(Name__c = conPSM.Id, Partner__c = accountCreationPSM.Id, Approvedby_Authority__c = 'No',OwnerId = userPSM.Id);
		Database.insert(certificationPSM1);	
		List<Account_Member__c> newaccmemlist = new List<Account_Member__c>();
		AccountMemPSM.Type__c = 'External';
		AccountMemPSM.Account_Role__c = 'Training Manager';
	newaccmemlist.add(AccountMemPSM);
		database.update(newaccmemlist);
		List<Account_Member__c> newaccmemlist1 = new List<Account_Member__c>();
		AccountMemPSM.Type__c = 'Internal';
		AccountMemPSM.Account_Role__c = 'Partner Sales Manager';
		newaccmemlist1.add(AccountMemPSM);
		database.update(newaccmemlist1);
		List<Account_Member__c> newaccmemlist2 = [Select id,Type__c,Account_Role__c from Account_Member__c where id =:newaccmemlist1[0].id];
		List<User> userList1 = new List<User>();
		userList.add(userPSM);
		AccountMemberHelperPRM.shareCertificationOnUpdatePSM(newaccmemlist2,newaccmemlist1[0], newaccmemlist[0], userList1);
		Test.stopTest(); 
	
		
		}
	}
		/*
		*******Description : shareCertificationOnUpdateAccountRolePSM******
		*/
		public static testMethod void shareCertificationOnUpdateAccountRolePSMTest(){
		Test.startTest();
		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;
		
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		runAsUSer[0].Nokia_ID__c= '6777777666';
		database.insert(runAsUSer);
		system.runAs(runAsUSer[0]){
	
		Account accountCreationPRM = TestDataFactory.createAccount(1)[0];
		accountCreationPRM.AccountNumber = '1234'; 
		Account accountCreationPSM = TestDataFactory.createAccount(1)[0];
		accountCreationPSM.AccountNumber = '12345';
		database.insert(accountCreationPRM);
		database.insert(accountCreationPSM);
	 
		Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=accountCreationPRM.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		database.insert(conPRM);
		User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',		 lastname = 'Testing',
		 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
		 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id, Nokia_ID__c= '6777777666');
		 
		database.insert(userPRM);
		List<User> userList = new List<User>();
			
		User userPSM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test', 
			lastname = 'Testing',
		 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.Nokia_Sales_Profile_Id,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
		 timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
		database.insert(userPSM);
		userList.add(userPRM);
		userList.add(userPSM);
		List<Account_Member__c> AccountMemList1 = new List<Account_Member__c>();
		Account_Member__c AccountMemPRM1 = new Account_Member__c(Account__c = accountCreationPRM.Id, Account_Role__c = 'Partner Relationship Manager', 
	Type__c = 'External', Name__c = userPRM.Id );
		Account_Member__c AccountMemPSM1 = new Account_Member__c(Account__c = accountCreationPSM.Id, Account_Role__c = 'Partner Sales Manager', 
	Type__c = 'Internal', Name__c = userPSM.Id );
		 

		AccountMemList1.add(AccountMemPRM1);
		AccountMemList1.add(AccountMemPSM1);
		Database.insert(AccountMemList1);
		AccountMemPRM1.Account_Role__c = 'Partner User';
		AccountMemPSM1.Account_Role__c = 'Training Manager';

		Database.update(AccountMemPRM1);
		Database.update(AccountMemPSM1);
	  
		
		Certification__c certificationPRM1 = new Certification__c(Name__c = conPRM.Id, Partner__c = accountCreationPRM.Id, Approvedby_Authority__c = 'No');
		Database.insert(certificationPRM1);
		List<Certification__c> CertificationListPSM1 = new List<Certification__c>();
		
		CertificationTriggerHelper.afterUpdateCertificationSharePSM(CertificationListPSM1);
		

		List<Certification__c> CertificationList1=new List<Certification__c>();
		CertificationList1.add(certificationPRM1);

		certificationPRM1.OwnerId = userPRM.Id;
		Database.update(CertificationList1);
		Test.stopTest();
	}  
		}   
		/*
		*******Description : shareCertificationOnUpdatePSM******
		*/
		public static testMethod void shareCertificationOnUpdatePSMTest(){
		Test.startTest();
		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;
	
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		system.runAs(runAsUSer[0]){
		
		Account accountCreationPRM = TestDataFactory.createAccount(1)[0];
		accountCreationPRM.AccountNumber = '1234'; 
		Account accountCreationPSM = TestDataFactory.createAccount(1)[0];
		accountCreationPSM.AccountNumber = '12345';
		database.insert(accountCreationPRM);
		database.insert(accountCreationPSM);
	 
		Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=accountCreationPRM.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		database.insert(conPRM);
		User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',		 lastname = 'Testing',
		 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
		 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id );
		 
		database.insert(userPRM);
		List<User> userList = new List<User>();
			
		 User userPSM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test', 
			lastname = 'Testing',
		 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.Nokia_Sales_Profile_Id,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
		 timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
		database.insert(userPSM);
		userList.add(userPRM);
		userList.add(userPSM);
		List<Account_Member__c> AccountMemList3 = new List<Account_Member__c>();
		Account_Member__c AccountMemPRM3 = new Account_Member__c(Account__c = accountCreationPRM.Id, Account_Role__c = 'Partner Relationship Manager', 
	Type__c = 'External', Name__c = userPRM.Id );
		Account_Member__c AccountMemPSM3 = new Account_Member__c(Account__c = accountCreationPSM.Id, Account_Role__c = 'Training Manager', 
	Type__c = 'Internal', Name__c = userPSM.Id );
		 
		Account_Member__c AccountMem11 = new Account_Member__c(Account__c = accountCreationPRM.Id, Account_Role__c = 'Training Manager', 
		Type__c = 'External', Name__c = userPRM.Id );
		Account_Member__c AccountMem22 = new Account_Member__c(Account__c = accountCreationPRM.Id, Account_Role__c = 'Partner User', 
		Type__c = 'External', Name__c = userPRM.Id );
		
		Certification__c certificationPRM3 = new Certification__c(Name__c = conPRM.Id, Partner__c = accountCreationPRM.Id, Approvedby_Authority__c = 'No');
		Database.insert(certificationPRM3);
		certificationPRM3.OwnerID = userPRM.Id;
		Database.update(certificationPRM3);
		AccountMemList3.add(AccountMemPRM3);
		AccountMemList3.add(AccountMemPSM3);
		AccountMemList3.add(AccountMem11);
		AccountMemList3.add(AccountMem22);
		Database.insert(AccountMemList3);
		AccountMemPSM3.Account_Role__c = 'Service Manager';
		Database.update(AccountMemPSM3);
		
		//Certification__c certificationPRM3 = new Certification__c(Name__c = conPRM.Id, Partner__c = accountCreationPRM.Id, Approvedby_Authority__c = 'No');
		//Database.insert(certificationPRM3);
		List<Certification__c> CertificationListPSM3 = new List<Certification__c>();
		CertificationTriggerHelper.afterUpdateCertificationSharePSM(CertificationListPSM3);
		//AccountMemberHanlderPRM.shareUpdatePSM(AccountMemList3,AccountMemList3[0],AccountMemList3[1]);
		
		List<Certification__c> CertificationList3=new List<Certification__c>();
		CertificationList3.add(certificationPRM3);
		certificationPRM3.OwnerId = userPRM.Id;
		Database.update(CertificationList3);
		
		Test.stopTest();
		}
	}
  /*
		*******Description : shareCertificationOnUpdateAccountRolePSM******
		*/
		public static testMethod void shareFundOnInsertAccMemberTest(){
		Test.startTest();
		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;
		
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		runAsUSer[0].Nokia_ID__c= '6777777666';
		database.insert(runAsUSer);
		system.runAs(runAsUSer[0]){
	
		Account accountCreationPRM = TestDataFactory.createAccount(1)[0];
		accountCreationPRM.AccountNumber = '1234'; 
		Account accountCreationPSM = TestDataFactory.createAccount(1)[0];
		accountCreationPSM.AccountNumber = '12345';
		database.insert(accountCreationPRM);
		database.insert(accountCreationPSM);
	 
		Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=accountCreationPRM.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		database.insert(conPRM);
		User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',		 lastname = 'Testing',
		 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
		 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id, Nokia_ID__c= '6777777666');
		 
		database.insert(userPRM);
		List<User> userList = new List<User>();
			
		User userPSM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test', 
			lastname = 'Testing',
		 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.Nokia_Sales_Profile_Id,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
		 timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
		database.insert(userPSM);
		userList.add(userPRM);
		userList.add(userPSM);
		List<Account_Member__c> AccountMemList1 = new List<Account_Member__c>();
		Account_Member__c AccountMemPRM1 = new Account_Member__c(Account__c = accountCreationPRM.Id, Account_Role__c = 'Partner Relationship Manager', 
	Type__c = 'External', Name__c = userPRM.Id );
		Account_Member__c AccountMemPSM1 = new Account_Member__c(Account__c = accountCreationPSM.Id, Account_Role__c = 'Partner Sales Manager', 
	Type__c = 'Internal', Name__c = userPSM.Id );
		 

		AccountMemList1.add(AccountMemPRM1);
		AccountMemList1.add(AccountMemPSM1);
		Database.insert(AccountMemList1);
		
	  
		
		List<Fund__c> fundList = new List<Fund__c>();
			Fund__c fd = new Fund__c(Name = 'abcd', Partner_Name__c = accountCreationPRM.id);
			fundList.add(fd);
			database.insert(fundList);
			AccountMemberHelperPRM.shareFundOnInsertAccMember(AccountMemList1);
		Test.stopTest();
	}  
		} 
   
}