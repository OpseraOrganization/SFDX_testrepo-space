@IsTest
public class CertificationTriggerHelperPRMTest {
	@testSetup static void createTestData() {
	
		NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
	}
	private static testMethod void afterUpdateCertificationSharePSMTest1(){
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		
		system.runAs(runAsUSer[0]){
		//Test.startTest();  
		Account accountCreationPRM = TestDataFactory.createAccount(1)[0];
		accountCreationPRM.AccountNumber = '1234'; 
		database.insert(accountCreationPRM);
			
		Account accountCreationPSM = TestDataFactory.createAccount(1)[0];
		accountCreationPSM.AccountNumber = '12345'; 
		database.insert(accountCreationPSM);
			
		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;
		List<User> userList = new List<User>();
		User userPSM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test', 
		lastname = 'Testing',languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = '00e41000000wIbXAAU',  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
		timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
		User userPSMNew = new User(alias = 'abcd', email = uniqueName + 'd@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test', 
	 lastname = 'Testing',languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.Nokia_Sales_Profile_Id,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
	 timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'b' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
		User userPSMNew2 = new User(alias = 'abcd2', email = uniqueName + 'd2@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test', 
			lastname = 'Testing',languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = '00e41000000wIbX',  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
			timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'d2' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
		
		database.insert(userPSM);
		database.insert(userPSMNew);
		database.insert(userPSMNew2);
		userList.add(userPSM);
		userList.add(userPSMNew);
		userList.add(userPSMNew2);
		system.debug('test userPSM'+ userPSM.profileid);
		
		Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=accountCreationPRM.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		database.insert(conPRM);
			
		User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',lastname = 'Testing',
			languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
			timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id );	
		database.insert(userPRM);  
		userList.add(userPRM);
		Contact conPSM = new Contact(lastName=PRMGlobalConstants.ContactNamePSM,AccountId=accountCreationPSM.id,Email=PRMGlobalConstants.EmailContactNamePSM,
	 OwnerId=userPSM.Id);
		database.insert(conPSM);
		Profile profile = new Profile();
		profile = [SELECT Id,Name FROM Profile WHERE Id=:system.Label.Nokia_Sales_Profile_Id Limit 1];
		List<Account_Member__c> AccountMemList = new List<Account_Member__c>();
		Account_Member__c AccountMemPRM = new Account_Member__c(Account__c = accountCreationPRM.Id, Account_Role__c = 'Partner Sales Manager', 
		Type__c = 'Internal', Name__c = userPRM.Id );
		Account_Member__c AccountMemPSMNew = new Account_Member__c(Account__c = accountCreationPRM.Id, Account_Role__c = 'Partner Sales Manager', 
		Type__c = 'Internal', Name__c = userPSMNew.Id );
		Account_Member__c AccountMemPSMNew2 = new Account_Member__c(Account__c = accountCreationPRM.Id, Account_Role__c = 'Partner Sales Manager', 
			Type__c = 'Internal', Name__c = userPSMNew2.Id );
		Account_Member__c AccountMemPSM = new Account_Member__c(Account__c = accountCreationPSM.Id, Account_Role__c = 'Partner Sales Manager', 
		Type__c = 'Internal', Name__c = userPSM.Id );
		Account_Member__c AccountMemPSM2 = new Account_Member__c(Account__c = accountCreationPSM.Id, Account_Role__c = 'Partner Sales Manager', 
		Type__c = 'Internal', Name__c = userPSM.Id );
		Database.insert(AccountMemPRM);
		Database.insert(AccountMemPSMNew);
		Database.insert(AccountMemPSMNew2);
		Database.insert(AccountMemPSM);
		//Database.insert(AccountMemPSM2);
	 
		AccountMemList.add(AccountMemPRM);
		AccountMemList.add(AccountMemPSMNew);
		AccountMemList.add(AccountMemPSMNew2);
		AccountMemList.add(AccountMemPSM);
		AccountMemList.add(AccountMemPSM2);

		Account_Member__c accmem = new Account_Member__c(); 
		accmem.Account_Role__c = 'Partner Sales Manager';
		accmem.Type__c= 'Internal';
		accmem.Name__c = userPRM.Id;
		accmem.Account__c = accountCreationPRM.Id;
		//insert accmem;
		system.debug('accmem***'+ accmem);
		AccountMemList.add(accmem);
	PermissionSetAssignment permassigned = new PermissionSetAssignment();
		permassigned.AssigneeId=userpsm.id;
		permassigned.PermissionSetId = '0PS41000001PO9s';
		insert permassigned;
		 Test.startTest();   
		Certification__c certificationPRM = new Certification__c(Name__c = conPRM.Id, Partner__c = accountCreationPRM.Id, Approvedby_Authority__c = 'No');
		Database.insert(certificationPRM); 
		Certification__c certificationPSM = new Certification__c( Name__c = conPSM.Id, Partner__c = accountCreationPSM.Id, Approvedby_Authority__c = 'No');
		Database.insert(certificationPSM);
			//List<Certification__c> CertificationListPSM = new List<Certification__c>();
		List<Certification__c> CertificationList=new List<Certification__c>();
			
			
	// CertificationList.add(certificationPSM); 
	  //  CertificationList.add(certificationPRM); 
		certificationPSM.OwnerId = userPSM.Id;
	// certificationPSM.Owner.ProfileId = userPSM.profileid;
		system.debug('test profileid'+userPSM.profileid);
		system.debug('test certificationPSM'+ certificationPSM.OwnerId);
		system.debug('userPSM user id'+ userPSM.Id);   
		certificationPRM.OwnerId = userPSM.Id;
		certificationPSM.Certification_Status__c = PRMGlobalConstants.EXPIRED;
		certificationPRM.Certification_Status__c = PRMGlobalConstants.Completed;
			
			CertificationList.add(certificationPSM); 
		CertificationList.add(certificationPRM);   
			
			System.debug('Before Database update FROM TEST CLASS::::::'+CertificationList[0].Owner.ProfileId);
	System.debug('Before Database update FROM TEST CLASS::::::'+CertificationList[0].OwnerId);
			
		Database.update(CertificationList);   system.debug('afterupdate CertificationList'+ CertificationList);
	System.debug('Cert Profile Id FROM TEST CLASS::::::'+CertificationList[0].Owner.ProfileId);
	System.debug('Cert OWNER Id FROM TEST CLASS::::::'+CertificationList[0].OwnerId);
	System.debug('userPSM.Id TEST CLASS::::::'+userPSM.profileId);	 
	//CertificationList.add(certificationPRM);
	  //  CertificationList.add(certificationPSM);
	//Database.update(CertificationList);
	 // database.insert(conUpdatePSM);
	Test.stopTest();	
	 //gopi-sfdc
			//accountMemberListtest = [SELECT Account_Role__c,Id,Name__c,Name__r.Name,Type__c FROM Account_Member__c]; 
			//insert accountMemberListtest;
			
		}
	}
	private static testMethod void afterUpdateCertificationSharePSMTest(){
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		
		system.runAs(runAsUSer[0]){
		//Test.startTest(); 
		Account accountCreationPRM = TestDataFactory.createAccount(1)[0];
		accountCreationPRM.AccountNumber = '1234'; 
		database.insert(accountCreationPRM);
			
		Account accountCreationPSM = TestDataFactory.createAccount(1)[0];
		accountCreationPSM.AccountNumber = '12345'; 
		database.insert(accountCreationPSM);
			
		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;
		List<User> userList = new List<User>();
		User userPSM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test', 
		lastname = 'Testing',languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = '00e41000000wIbXAAU',  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
		timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
		User userPSMNew = new User(alias = 'abcd', email = uniqueName + 'd@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test', 
	 lastname = 'Testing',languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.Nokia_Sales_Profile_Id,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
	 timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'b' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
		User userPSMNew2 = new User(alias = 'abcd2', email = uniqueName + 'd2@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test', 
			lastname = 'Testing',languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = '00e41000000wIbX',  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
			timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'d2' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
		
		database.insert(userPSM);
		database.insert(userPSMNew);
		database.insert(userPSMNew2);
		userList.add(userPSM);
		userList.add(userPSMNew);
		userList.add(userPSMNew2);
		system.debug('test userPSM'+ userPSM.profileid);
		
		Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=accountCreationPRM.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		database.insert(conPRM);
			
		User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',lastname = 'Testing',
			languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
			timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id );	
		database.insert(userPRM);  
		userList.add(userPRM);
		Contact conPSM = new Contact(lastName=PRMGlobalConstants.ContactNamePSM,AccountId=accountCreationPSM.id,Email=PRMGlobalConstants.EmailContactNamePSM,
	 OwnerId=userPSM.Id);
		database.insert(conPSM);
		Profile profile = new Profile();
		profile = [SELECT Id,Name FROM Profile WHERE Id=:system.Label.Nokia_Sales_Profile_Id Limit 1];
		List<Account_Member__c> AccountMemList = new List<Account_Member__c>();
		Account_Member__c AccountMemPRM = new Account_Member__c(Account__c = accountCreationPRM.Id, Account_Role__c = 'Partner Sales Manager', 
		Type__c = 'Internal', Name__c = userPRM.Id );
		Account_Member__c AccountMemPSMNew = new Account_Member__c(Account__c = accountCreationPRM.Id, Account_Role__c = 'Partner Sales Manager', 
		Type__c = 'Internal', Name__c = userPSMNew.Id );
		Account_Member__c AccountMemPSMNew2 = new Account_Member__c(Account__c = accountCreationPRM.Id, Account_Role__c = 'Partner Sales Manager', 
			Type__c = 'Internal', Name__c = userPSMNew2.Id );
		Account_Member__c AccountMemPSM = new Account_Member__c(Account__c = accountCreationPSM.Id, Account_Role__c = 'Partner Sales Manager', 
		Type__c = 'Internal', Name__c = userPSM.Id );
		Account_Member__c AccountMemPSM2 = new Account_Member__c(Account__c = accountCreationPSM.Id, Account_Role__c = 'Partner Sales Manager', 
		Type__c = 'Internal', Name__c = userPSM.Id );
		Database.insert(AccountMemPRM);
		Database.insert(AccountMemPSMNew);
		Database.insert(AccountMemPSMNew2);
		Database.insert(AccountMemPSM);
		//Database.insert(AccountMemPSM2);
	 
		AccountMemList.add(AccountMemPRM);
		AccountMemList.add(AccountMemPSMNew);
		AccountMemList.add(AccountMemPSMNew2);
		AccountMemList.add(AccountMemPSM);
		AccountMemList.add(AccountMemPSM2);

		Account_Member__c accmem = new Account_Member__c(); 
		accmem.Account_Role__c = 'Partner Sales Manager';
		accmem.Type__c= 'Internal';
		accmem.Name__c = userPRM.Id;
		accmem.Account__c = accountCreationPRM.Id;
		//insert accmem;
		system.debug('accmem***'+ accmem);
		AccountMemList.add(accmem);
	PermissionSetAssignment permassigned = new PermissionSetAssignment();
		permassigned.AssigneeId=userpsm.id;
		permassigned.PermissionSetId = '0PS41000001PO9s';
		insert permassigned;
		 Test.startTest();   
		Certification__c certificationPRM = new Certification__c(Name__c = conPRM.Id, Partner__c = accountCreationPRM.Id, Approvedby_Authority__c = 'No');
		Database.insert(certificationPRM); 
		Certification__c certificationPSM = new Certification__c( Name__c = conPSM.Id, Partner__c = accountCreationPSM.Id, Approvedby_Authority__c = 'No');
		Database.insert(certificationPSM);
			//List<Certification__c> CertificationListPSM = new List<Certification__c>();
		List<Certification__c> CertificationList=new List<Certification__c>();
			
			
	// CertificationList.add(certificationPSM); 
	  //  CertificationList.add(certificationPRM); 
		certificationPSM.OwnerId = userPSM.Id;
	// certificationPSM.Owner.ProfileId = userPSM.profileid;
		system.debug('test profileid'+userPSM.profileid);
		system.debug('test certificationPSM'+ certificationPSM.OwnerId);
		system.debug('userPSM user id'+ userPSM.Id);   
		certificationPRM.OwnerId = userPSM.Id;
		certificationPSM.Certification_Status__c = PRMGlobalConstants.EXPIRED;
		certificationPRM.Certification_Status__c = PRMGlobalConstants.Completed;
			
			CertificationList.add(certificationPSM); 
		CertificationList.add(certificationPRM);   
			
			System.debug('Before Database update FROM TEST CLASS::::::'+CertificationList[0].Owner.ProfileId);
	System.debug('Before Database update FROM TEST CLASS::::::'+CertificationList[0].OwnerId);
			
		Database.update(CertificationList);   system.debug('afterupdate CertificationList'+ CertificationList);
	System.debug('Cert Profile Id FROM TEST CLASS::::::'+CertificationList[0].Owner.ProfileId);
	System.debug('Cert OWNER Id FROM TEST CLASS::::::'+CertificationList[0].OwnerId);
	System.debug('userPSM.Id TEST CLASS::::::'+userPSM.profileId);	 
	//CertificationList.add(certificationPRM);
	  //  CertificationList.add(certificationPSM);
	//Database.update(CertificationList);
		CertificationTriggerHelper.afterUpdateCertificationSharePSM(CertificationList);
	 // database.insert(conUpdatePSM);
	Test.stopTest();	
	 //gopi-sfdc
			//accountMemberListtest = [SELECT Account_Role__c,Id,Name__c,Name__r.Name,Type__c FROM Account_Member__c]; 
			//insert accountMemberListtest;
			
		}
	}
	
	private static testMethod void updateGPPFieldsonCertTest(){
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		
		system.runAs(runAsUSer[0]){
		Account acc = new Account();
		acc = TestDataFactory.createAccount(1)[0];
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		acc.Market__c = 'Market India';
		//acc.BusinessPartnerRole__c = 'Indirect Reseller';
		acc.Name = 'STARHUB LIMITED';
		acc.Country__c='India';
		acc.BillingCountry  = 'India';
		acc.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
		acc.Partner_Program__c = 'GPP 0.0';
		acc.AccountNumber = '1234'; 
		insert acc;
		//acc.Partner_Program__c = 'GPP 1.0';
	//  update acc;
			Account acc1 = new Account();
			acc1 = TestDataFactory.createAccount(1)[0];
			acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
			acc1.Market__c = 'Market India';
			//acc1.BusinessPartnerRole__c = 'Indirect Reseller';
			acc1.Name = 'STARHUB LIMITED';
			acc1.Country__c='India';
			acc1.BillingCountry  = 'India';
			acc1.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
			acc1.Partner_Program__c = 'GPP 0.0';
			acc1.AccountNumber = '12345'; 
			insert acc1;
	 // acc1.Partner_Program__c = 'GPP 2.0';
	 
	 // update acc1;
			
			Account acc2 = new Account();
			acc2 = TestDataFactory.createAccount(1)[0];
			acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
			acc2.Market__c = 'Market India';
			//acc2.BusinessPartnerRole__c = 'Indirect Reseller';
			acc2.Name = 'STARHUB LIMITED';
			acc2.Country__c='India';
			acc2.BillingCountry  = 'India';
			acc2.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
			acc2.Partner_Program__c = 'GPP 0.0';
			acc2.AccountNumber = '123456'; 
			insert acc2;
			//acc2.Partner_Program__c = 'GPP 3.0';
	 // update acc2;
			
			Test.startTest();
			Contact con = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=acc.id,Email=PRMGlobalConstants.EmailContactNamePRM );
			database.insert(con);
			
			Contact con1 = new Contact(lastName='test1'+PRMGlobalConstants.ContactNamePRM,AccountId=acc1.id,Email='test1'+PRMGlobalConstants.EmailContactNamePRM );
			database.insert(con1);
			
			Contact con2 = new Contact(lastName='test2'+PRMGlobalConstants.ContactNamePRM,AccountId=acc2.id,Email='test2'+PRMGlobalConstants.EmailContactNamePRM );
			database.insert(con2);
			
			Certification_Matrix__c CertMatrix1 = new Certification_Matrix__c(GPP_0_0__c = 'test 10', GPP_1_0__c = 'test 11', GPP_2_0__c = 'test 12', GPP_3_0__c = 'test 13');
			Database.insert(CertMatrix1);
			CertMatrix1.GPP_0_0__c = 'PRMTEST1';
			CertMatrix1.GPP_1_0__c = 'PRMTEST1 1';
			CertMatrix1.GPP_2_0__c = 'PRMTEST1 2';
			CertMatrix1.GPP_3_0__c = 'PRMTEST1 3';
			Database.Update(CertMatrix1);
			Certification_Matrix__c CertMatrix = new Certification_Matrix__c(GPP_0_0__c = 'test 0', GPP_1_0__c = 'test 1', GPP_2_0__c = 'test 2', GPP_3_0__c = 'test 3');
			Database.insert(CertMatrix);
			CertMatrix.GPP_0_0__c = 'PRMTEST';
			CertMatrix.GPP_1_0__c = 'PRMTEST 1';
			CertMatrix.GPP_2_0__c = 'PRMTEST 2';
			CertMatrix.GPP_3_0__c = 'PRMTEST 3';
			Database.Update(CertMatrix);
			
			LIST<Certification__c> certdetailList = new LIST<Certification__c>();
			Certification__c certification1 = new Certification__c(GPP_Certification_Name__c = 'Deployment Installation test', Certification_Matrix_Number__c = CertMatrix1.ID, Name__c = con.Id, 
	Partner__c = acc.ID,  Approvedby_Authority__c = 'No');
			certdetailList.add(certification1);
			
			Certification__c certification2 = new Certification__c(GPP_Certification_Name__c = 'Deployment Installation test', Certification_Matrix_Number__c = CertMatrix1.ID, Name__c = con.Id, 
	Partner__c = acc1.ID,  Approvedby_Authority__c = 'No');
			certdetailList.add(certification2);
			
			Certification__c certification3 = new Certification__c(GPP_Certification_Name__c = 'Deployment Installation test', Certification_Matrix_Number__c = CertMatrix1.ID, Name__c = con.Id, 
	Partner__c = acc2.ID,  Approvedby_Authority__c = 'No');
			certdetailList.add(certification3);
			
			Database.insert(certdetailList);
	//Test.stopTest();
	
			certification1.Certification_Matrix_Number__c = CertMatrix.ID;
			certification2.Certification_Matrix_Number__c = CertMatrix.ID;
			certification3.Certification_Matrix_Number__c = CertMatrix.ID;
			Database.update(certdetailList);
			//acc.Partner_Program__c = 'GPP 3.0';
			//update acc;
			//Test.startTest();
			LIST<Certification__c> certdetailList1 = new LIST<Certification__c>();
			Certification__c certification = new Certification__c(GPP_Certification_Name__c = 'Deployment Installation test', Certification_Matrix_Number__c = CertMatrix1.ID, Name__c = con.Id, 
	  Partner__c = acc.ID,  Approvedby_Authority__c = 'No', Certification_Status__c = 'Completed');
			Database.insert(certification);   
			certification.Certification_Matrix_Number__c = CertMatrix.ID;
			Database.update(certification); 
			certdetailList1.add(certification);
			LIST<Accreditation__c> accreditationList1 = new LIST<Accreditation__c>();
			Accreditation__c accreditation = new Accreditation__c(Accreditation_Type__c= 'Product', Accreditation_Level__c = 'Advanced',Accreditation_Date__c=System.today(), 
	  Partner__c = acc.ID);
			//Database.insert(accreditation);	
			
			Test.stopTest();
			CertificationTriggerHelper.updateGPPFieldsonCert(null,null);
			CertificationTriggerHelper.updateGPPFieldsonCertonInsert(null);
			CertificationTriggerHelper.afterUpdateCertificationSharePSM(null);
			CertificationTriggerHelper.accreditationUpdate(certdetailList1);
			CertificationTriggerHelper.accreditationUpdate(null);
		}
	}   
	private static testMethod void updateGPPFieldsonCertTest1(){
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		
		system.runAs(runAsUSer[0]){
		Account acc = new Account();
		acc = TestDataFactory.createAccount(1)[0];
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		acc.Market__c = 'Market India';
		//acc.BusinessPartnerRole__c = 'Indirect Reseller';
		acc.Name = 'STARHUB LIMITED';
		acc.Country__c='India';
		acc.BillingCountry  = 'India';
		acc.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
		acc.Partner_Program__c = 'GPP 1.0';
		acc.AccountNumber = '123456'; 
		insert acc;
		//acc.Partner_Program__c = 'GPP 1.0';
	//  update acc;
			Account acc1 = new Account();
			acc1 = TestDataFactory.createAccount(1)[0];
			acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
			acc1.Market__c = 'Market India';
			//acc1.BusinessPartnerRole__c = 'Indirect Reseller';
			acc1.Name = 'STARHUB LIMITED';
			acc1.Country__c='India';
			acc1.BillingCountry  = 'India';
			acc1.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
			acc1.Partner_Program__c = 'GPP 1.0';
			acc1.AccountNumber = '12345'; 
			insert acc1;
	 // acc1.Partner_Program__c = 'GPP 2.0';
	 
	 // update acc1;
			
			Account acc2 = new Account();
			acc2 = TestDataFactory.createAccount(1)[0];
			acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
			acc2.Market__c = 'Market India';
			//acc2.BusinessPartnerRole__c = 'Indirect Reseller';
			acc2.Name = 'STARHUB LIMITED';
			acc2.Country__c='India';
			acc2.BillingCountry  = 'India';
			acc2.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
			acc2.Partner_Program__c = 'GPP 1.0';
			acc2.AccountNumber = '1234'; 
			insert acc2;
			//acc2.Partner_Program__c = 'GPP 3.0';
	 // update acc2;
			
	Test.startTest();
			Contact con = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=acc.id,Email=PRMGlobalConstants.EmailContactNamePRM );
			database.insert(con);
			
			Contact con1 = new Contact(lastName='test1'+PRMGlobalConstants.ContactNamePRM,AccountId=acc1.id,Email='test1'+PRMGlobalConstants.EmailContactNamePRM );
			database.insert(con1);
			
			Contact con2 = new Contact(lastName='test2'+PRMGlobalConstants.ContactNamePRM,AccountId=acc2.id,Email='test2'+PRMGlobalConstants.EmailContactNamePRM );
			database.insert(con2);
			
			Certification_Matrix__c CertMatrix1 = new Certification_Matrix__c(GPP_0_0__c = 'test 10', GPP_1_0__c = 'test 11', GPP_2_0__c = 'test 12', GPP_3_0__c = 'test 13');
			Database.insert(CertMatrix1);
			CertMatrix1.GPP_0_0__c = 'PRMTEST1';
			CertMatrix1.GPP_1_0__c = 'PRMTEST1 1';
			CertMatrix1.GPP_2_0__c = 'PRMTEST1 2';
			CertMatrix1.GPP_3_0__c = 'PRMTEST1 3';
			Database.Update(CertMatrix1);
			Certification_Matrix__c CertMatrix = new Certification_Matrix__c(GPP_0_0__c = 'test 0', GPP_1_0__c = 'test 1', GPP_2_0__c = 'test 2', GPP_3_0__c = 'test 3');
			Database.insert(CertMatrix);
			CertMatrix.GPP_0_0__c = 'PRMTEST';
			CertMatrix.GPP_1_0__c = 'PRMTEST 1';
			CertMatrix.GPP_2_0__c = 'PRMTEST 2';
			CertMatrix.GPP_3_0__c = 'PRMTEST 3';
			Database.Update(CertMatrix);
			
			LIST<Certification__c> certdetailList = new LIST<Certification__c>();
			Certification__c certification1 = new Certification__c(GPP_Certification_Name__c = 'Deployment Installation test', Certification_Matrix_Number__c = CertMatrix1.ID, Name__c = con.Id, 
	Partner__c = acc.ID,  Approvedby_Authority__c = 'No');
			certdetailList.add(certification1);
			
			Certification__c certification2 = new Certification__c(GPP_Certification_Name__c = 'Deployment Installation test', Certification_Matrix_Number__c = CertMatrix1.ID, Name__c = con.Id, 
	Partner__c = acc1.ID,  Approvedby_Authority__c = 'No');
			certdetailList.add(certification2);
			
			Certification__c certification3 = new Certification__c(GPP_Certification_Name__c = 'Deployment Installation test', Certification_Matrix_Number__c = CertMatrix1.ID, Name__c = con.Id, 
	Partner__c = acc2.ID,  Approvedby_Authority__c = 'No');
			certdetailList.add(certification3);
			
			Database.insert(certdetailList);
	//Test.stopTest();
	
			certification1.Certification_Matrix_Number__c = CertMatrix.ID;
			certification2.Certification_Matrix_Number__c = CertMatrix.ID;
			certification3.Certification_Matrix_Number__c = CertMatrix.ID;
			Database.update(certdetailList);
			//acc.Partner_Program__c = 'GPP 3.0';
			//update acc;
			//Test.startTest();
			LIST<Certification__c> certdetailList1 = new LIST<Certification__c>();
			Certification__c certification = new Certification__c(GPP_Certification_Name__c = 'Deployment Installation test', Certification_Matrix_Number__c = CertMatrix1.ID, Name__c = con.Id, 
	  Partner__c = acc.ID,  Approvedby_Authority__c = 'No');
			Database.insert(certification);   
			certification.Certification_Matrix_Number__c = CertMatrix.ID;
			Database.update(certification); 
			certdetailList1.add(certification);
			Test.stopTest();
			CertificationTriggerHelper.updateGPPFieldsonCert(null,null);
			CertificationTriggerHelper.updateGPPFieldsonCertonInsert(null);
			CertificationTriggerHelper.afterUpdateCertificationSharePSM(null);
			CertificationTriggerHelper.accreditationUpdate(certdetailList1);
			CertificationTriggerHelper.accreditationUpdate(null);
		}
	}	
	private static testMethod void updateGPPFieldsonCertTest2(){
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		
		system.runAs(runAsUSer[0]){
		Account acc = new Account();
		acc = TestDataFactory.createAccount(1)[0];
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		acc.Market__c = 'Market India';
		//acc.BusinessPartnerRole__c = 'Indirect Reseller';
		acc.Name = 'STARHUB LIMITED';
		acc.Country__c='India';
		acc.BillingCountry  = 'India';
		acc.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
		acc.Partner_Program__c = 'GPP 2.0';
		acc.AccountNumber = '123456'; 
		insert acc;
		//acc.Partner_Program__c = 'GPP 1.0';
	//  update acc;
			Account acc1 = new Account();
			acc1 = TestDataFactory.createAccount(1)[0];
			acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
			acc1.Market__c = 'Market India';
			//acc1.BusinessPartnerRole__c = 'Indirect Reseller';
			acc1.Name = 'STARHUB LIMITED';
			acc1.Country__c='India';
			acc1.BillingCountry  = 'India';
			acc1.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
			acc1.Partner_Program__c = 'GPP 2.0';
			acc1.AccountNumber = '12345'; 
			insert acc1;
	 // acc1.Partner_Program__c = 'GPP 2.0';
	 
	 // update acc1;
			
			Account acc2 = new Account();
			acc2 = TestDataFactory.createAccount(1)[0];
			acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
			acc2.Market__c = 'Market India';
			//acc2.BusinessPartnerRole__c = 'Indirect Reseller';
			acc2.Name = 'STARHUB LIMITED';
			acc2.Country__c='India';
			acc2.BillingCountry  = 'India';
			acc2.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
			acc2.Partner_Program__c = 'GPP 2.0';
			acc2.AccountNumber = '1234'; 
			insert acc2;
			//acc2.Partner_Program__c = 'GPP 3.0';
	 // update acc2;
			
	Test.startTest();
			Contact con = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=acc.id,Email=PRMGlobalConstants.EmailContactNamePRM );
			database.insert(con);
			
			Contact con1 = new Contact(lastName='test1'+PRMGlobalConstants.ContactNamePRM,AccountId=acc1.id,Email='test1'+PRMGlobalConstants.EmailContactNamePRM );
			database.insert(con1);
			
			Contact con2 = new Contact(lastName='test2'+PRMGlobalConstants.ContactNamePRM,AccountId=acc2.id,Email='test2'+PRMGlobalConstants.EmailContactNamePRM );
			database.insert(con2);
			
			Certification_Matrix__c CertMatrix1 = new Certification_Matrix__c(GPP_0_0__c = 'test 10', GPP_1_0__c = 'test 11', GPP_2_0__c = 'test 12', GPP_3_0__c = 'test 13');
			Database.insert(CertMatrix1);
			CertMatrix1.GPP_0_0__c = 'PRMTEST1';
			CertMatrix1.GPP_1_0__c = 'PRMTEST1 1';
			CertMatrix1.GPP_2_0__c = 'PRMTEST1 2';
			CertMatrix1.GPP_3_0__c = 'PRMTEST1 3';
			Database.Update(CertMatrix1);
			Certification_Matrix__c CertMatrix = new Certification_Matrix__c(GPP_0_0__c = 'test 0', GPP_1_0__c = 'test 1', GPP_2_0__c = 'test 2', GPP_3_0__c = 'test 3');
			Database.insert(CertMatrix);
			CertMatrix.GPP_0_0__c = 'PRMTEST';
			CertMatrix.GPP_1_0__c = 'PRMTEST 1';
			CertMatrix.GPP_2_0__c = 'PRMTEST 2';
			CertMatrix.GPP_3_0__c = 'PRMTEST 3';
			Database.Update(CertMatrix);
			
			LIST<Certification__c> certdetailList = new LIST<Certification__c>();
			Certification__c certification1 = new Certification__c(GPP_Certification_Name__c = 'Deployment Installation test', Certification_Matrix_Number__c = CertMatrix1.ID, Name__c = con.Id, 
	Partner__c = acc.ID,  Approvedby_Authority__c = 'No');
			certdetailList.add(certification1);
			
			Certification__c certification2 = new Certification__c(GPP_Certification_Name__c = 'Deployment Installation test', Certification_Matrix_Number__c = CertMatrix1.ID, Name__c = con.Id, 
	Partner__c = acc1.ID,  Approvedby_Authority__c = 'No');
			certdetailList.add(certification2);
			
			Certification__c certification3 = new Certification__c(GPP_Certification_Name__c = 'Deployment Installation test', Certification_Matrix_Number__c = CertMatrix1.ID, Name__c = con.Id, 
	Partner__c = acc2.ID,  Approvedby_Authority__c = 'No');
			certdetailList.add(certification3);
			
			Database.insert(certdetailList);
	//Test.stopTest();
	
			certification1.Certification_Matrix_Number__c = CertMatrix.ID;
			certification2.Certification_Matrix_Number__c = CertMatrix.ID;
			certification3.Certification_Matrix_Number__c = CertMatrix.ID;
			Database.update(certdetailList);
			//acc.Partner_Program__c = 'GPP 3.0';
			//update acc;
			//Test.startTest();
			LIST<Certification__c> certdetailList1 = new LIST<Certification__c>();
			Certification__c certification = new Certification__c(GPP_Certification_Name__c = 'Deployment Installation test', Certification_Matrix_Number__c = CertMatrix1.ID, Name__c = con.Id, 
	  Partner__c = acc.ID,  Approvedby_Authority__c = 'No');
			Database.insert(certification);   
			certification.Certification_Matrix_Number__c = CertMatrix.ID;
			Database.update(certification); 
			certdetailList1.add(certification);
			Test.stopTest();
			CertificationTriggerHelper.updateGPPFieldsonCert(null,null);
			CertificationTriggerHelper.updateGPPFieldsonCertonInsert(null);
			CertificationTriggerHelper.afterUpdateCertificationSharePSM(null);
			CertificationTriggerHelper.accreditationUpdate(certdetailList1);
			CertificationTriggerHelper.accreditationUpdate(null);
		}
	} 
	private static testMethod void updateGPPFieldsonCertTest3(){
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		
		system.runAs(runAsUSer[0]){
		Account acc = new Account();
		acc = TestDataFactory.createAccount(1)[0];
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		acc.Market__c = 'Market India';
		//acc.BusinessPartnerRole__c = 'Indirect Reseller';
		acc.Name = 'STARHUB LIMITED';
		acc.Country__c='India';
		acc.BillingCountry  = 'India';
		acc.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
		acc.Partner_Program__c = 'GPP 3.0';
		acc.AccountNumber = '1234'; 
		insert acc;
		//acc.Partner_Program__c = 'GPP 1.0';
	//  update acc;
			Account acc1 = new Account();
			acc1 = TestDataFactory.createAccount(1)[0];
			acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
			acc1.Market__c = 'Market India';
			//acc1.BusinessPartnerRole__c = 'Indirect Reseller';
			acc1.Name = 'STARHUB LIMITED';
			acc1.Country__c='India';
			acc1.BillingCountry  = 'India';
			acc1.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
			acc1.Partner_Program__c = 'GPP 3.0';
			acc1.AccountNumber = '12345'; 
			insert acc1;
	 // acc1.Partner_Program__c = 'GPP 2.0';
	 
	 // update acc1;
			
			Account acc2 = new Account();
			acc2 = TestDataFactory.createAccount(1)[0];
			acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
			acc2.Market__c = 'Market India';
			//acc2.BusinessPartnerRole__c = 'Indirect Reseller';
			acc2.Name = 'STARHUB LIMITED';
			acc2.Country__c='India';
			acc2.BillingCountry  = 'India';
			acc2.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
			acc2.Partner_Program__c = 'GPP 3.0';
			acc2.AccountNumber = '123456'; 
			insert acc2;
			
			List<Accreditation__c> accredList = new List<Accreditation__c>();
			
			Accreditation__c accrMan = new Accreditation__c();
			accrMan.RecordTypeId = '01241000000v9mE';
			accrMan.Manual_Accreditation_Level_Update__c = true;
			accrMan.Evaluated_Accreditation__c = true;
			accrMan.Partner__c = acc.Id;
			accrMan.Accreditation_Date__c = System.today();	  
			accrMan.Accreditation_Type__c='Product';
			accrMan.Accreditation_Level__c = 'Advanced';
			accrMan.Shift_Model__c='8X5';
			accrMan.Portfolio__c='Airscale Wifi';
			
			Accreditation__c accrAuto = new Accreditation__c();
			accrAuto.RecordTypeId = '01241000000v9mE';
			accrAuto.Evaluated_Accreditation__c = true;
			accrAuto.Partner__c = acc.Id;
			accrAuto.Accreditation_Level__c = 'Advanced';
			accrAuto.Accreditation_Date__c = System.today();
			accrAuto.Accreditation_Type__c='Product';	 
			accrAuto.Manual_Accreditation_Level_Update__c = false;
			accrAuto.Shift_Model__c='8X5';
			accrAuto.Portfolio__c='Airscale Wifi';
			accrAuto.Administration_Software_Only__c = 11.0;
			accrAuto.Partner_Relationship_Manager__c = 11.0;
			accrAuto.Technical_Support_Level_1__c = 11.0;
			accrAuto.Service_Desk_Clerk__c = 11.0;
			accrAuto.Administration_Software_Only__c = 11.0;
			accrAuto.Technical_Support_Level_2__c = 19.0;
			accrAuto.Partner_Marketing_Manager__c = 19.0; 
			accrAuto.Field_Technician__c = 19.0;
			accrAuto.Sales_Engineer__c = 19.0;
			accrAuto.Sales_Associate__c=19.0;
			
			Accreditation__c accrAuto2 = new Accreditation__c();
			accrAuto2.RecordTypeId = '01241000000v9mE';
			accrAuto2.Evaluated_Accreditation__c = true;
			accrAuto2.Partner__c = acc1.Id;
			accrAuto2.Accreditation_Level__c = 'Expert';
			accrAuto2.Accreditation_Date__c = System.today();
			accrAuto2.Accreditation_Type__c='Product';	 
			accrAuto2.Manual_Accreditation_Level_Update__c = false;
			accrAuto2.Shift_Model__c='8X5';
			accrAuto2.Portfolio__c='Airscale Wifi';
			accrAuto2.Administration_Software_Only__c = 11.0;
			accrAuto2.Partner_Relationship_Manager__c = 11.0;
			accrAuto2.Technical_Support_Level_1__c = 11.0;
			accrAuto2.Service_Desk_Clerk__c = 11.0;
			accrAuto2.Administration_Software_Only__c = 11.0;
			accrAuto2.Technical_Support_Level_2__c = 11.0;
			accrAuto2.Partner_Marketing_Manager__c = 11.0; 
			accrAuto2.Field_Technician__c = 11.0;
			accrAuto2.Sales_Engineer__c = 11.0;
			accrAuto2.Sales_Associate__c=11.0;
			
			Accreditation__c accrAuto1 = new Accreditation__c();
			accrAuto1.RecordTypeId = '01241000000v9mE';
			accrAuto1.Evaluated_Accreditation__c = true;
			accrAuto1.Partner__c = acc1.Id;
			accrAuto1.Accreditation_Level__c = 'Expert';
			accrAuto1.Accreditation_Date__c = System.today();
			accrAuto1.Accreditation_Type__c='Product';	 
			accrAuto1.Manual_Accreditation_Level_Update__c = false;
			accrAuto1.Shift_Model__c='8X5';
			accrAuto1.Portfolio__c='Airscale Wifi';
			accrAuto1.Administration_Software_Only__c = 10;
			
			Accreditation__c accrAuto3 = new Accreditation__c();
			accrAuto3.RecordTypeId = '01241000000v9mE';
			accrAuto3.Evaluated_Accreditation__c = true;
			accrAuto3.Partner__c = acc2.Id;
			accrAuto3.Accreditation_Level__c = 'Authorized';
			accrAuto3.Accreditation_Date__c = System.today();
			accrAuto3.Accreditation_Type__c='Product';	 
			accrAuto3.Manual_Accreditation_Level_Update__c = false;
			accrAuto3.Shift_Model__c='8X5';
			accrAuto3.Portfolio__c='Airscale Wifi';
			accrAuto3.Administration_Software_Only__c = 11.0;
			accrAuto3.Partner_Relationship_Manager__c = 11.0;
			accrAuto3.Technical_Support_Level_1__c = 11.0;
			accrAuto3.Service_Desk_Clerk__c = 11.0;
			accrAuto3.Administration_Software_Only__c = 11.0;
			accrAuto3.Technical_Support_Level_2__c = 11.0;
			accrAuto3.Partner_Marketing_Manager__c = 11.0; 
			accrAuto3.Field_Technician__c = 11.0;
			accrAuto3.Sales_Engineer__c = 11.0;
			accrAuto3.Sales_Associate__c=11.0;
			
			accredList.add(accrMan);
			accredList.add(accrAuto);
			accredList.add(accrAuto1);
			accredList.add(accrAuto2);
			accredList.add(accrAuto3);
			//insert accredList;  

			List<Accreditation_Level_Rule__c> accrLevelRule = new List<Accreditation_Level_Rule__c>();
			Accreditation_Level_Rule__c accredRule1 = new Accreditation_Level_Rule__c();
			accredRule1.Market__c = accrAuto.Market__c;
			accredRule1.Geo_Level_1_Name__c = accrAuto.Geo_Level_1_Name__c;
			accredRule1.Accreditation_Type__c = accrAuto.Accreditation_Type__c;
			accredRule1.Partner_Program__c = accrAuto.Partner_Program__c;
			accredRule1.Partner_Type__c = accrAuto.Partner_Type__c;
			accredRule1.Shift_Model__c = accrAuto.Shift_Model__c;
			accredRule1.Portfolio__c = accrAuto.Portfolio__c;
			accredRule1.Accreditation_Level__c = 'Expert';
	
			accredRule1.Administration_Software_Only__c = 10.0;
			accredRule1.Partner_Relationship_Manager__c = 10.0;
			accredRule1.Technical_Support_Level_1__c = 10.0;
			accredRule1.Service_Desk_Clerk__c = 10.0;
			accredRule1.Administration_Software_Only__c = 10.0;
			accredRule1.Technical_Support_Level_2__c = 10.0;
			accredRule1.Partner_Marketing_Manager__c = 10.0; 
			accredRule1.Field_Technician__c = 10.0;
			accredRule1.Sales_Engineer__c = 10.0;
			accredRule1.Sales_Associate__c = 10.0;
			accrLevelRule.add(accredRule1);
			insert accrLevelRule;
			
			accredRule1.Accreditation_Level__c = 'Advanced';
			update accrLevelRule;
			
			List<PRM_Accreditation_Level_Ranks__c> accRanks = new List<PRM_Accreditation_Level_Ranks__c>();
			PRM_Accreditation_Level_Ranks__c expert = new PRM_Accreditation_Level_Ranks__c();
			expert.Name = 'Expert';
			expert.Rank__c = 1;
			accRanks.add(expert);
			
			PRM_Accreditation_Level_Ranks__c advanced = new PRM_Accreditation_Level_Ranks__c();
			advanced.Name = 'Advanced';
			advanced.Rank__c = 3;
			accRanks.add(advanced);
			
			PRM_Accreditation_Level_Ranks__c authorized = new PRM_Accreditation_Level_Ranks__c();
			authorized.Name = 'Authorized';
			authorized.Rank__c = 4;
			accRanks.add(authorized);
			insert accRanks;
			
			List<PRM_CertificationToAccreditation_Mapping__c> certToAccred = new List<PRM_CertificationToAccreditation_Mapping__c>();
			PRM_CertificationToAccreditation_Mapping__c map1 = new PRM_CertificationToAccreditation_Mapping__c();
			map1.Name = 'Sales Associate';
			map1.Accreditation_Field_API_Name__c = 'Sales_Associate__c';
			certToAccred.add(map1);
			
			PRM_CertificationToAccreditation_Mapping__c map2 = new PRM_CertificationToAccreditation_Mapping__c();
			map2.Name = 'Service Desk Clerk';
			map2.Accreditation_Field_API_Name__c = 'Service_Desk_Clerk__c';
			certToAccred.add(map2);
			
			PRM_CertificationToAccreditation_Mapping__c map3 = new PRM_CertificationToAccreditation_Mapping__c();
			map3.Name = 'Technical Support Level 2';
			map3.Accreditation_Field_API_Name__c = 'Technical_Support_Level_2__c';
			certToAccred.add(map3);
			
			PRM_CertificationToAccreditation_Mapping__c map4 = new PRM_CertificationToAccreditation_Mapping__c();
			map4.Name = 'Partner Relationship Manager';
			map4.Accreditation_Field_API_Name__c = 'Partner_Relationship_Manager__c';
			certToAccred.add(map4);
			
			PRM_CertificationToAccreditation_Mapping__c map5 = new PRM_CertificationToAccreditation_Mapping__c();
			map5.Name = 'Field Technician';
			map5.Accreditation_Field_API_Name__c = 'Field_Technician__c';
			certToAccred.add(map5);
			
			PRM_CertificationToAccreditation_Mapping__c map6 = new PRM_CertificationToAccreditation_Mapping__c();
			map6.Name = 'Sales Engineer';
			map6.Accreditation_Field_API_Name__c = 'Sales_Engineer__c';
			certToAccred.add(map6);
			
			PRM_CertificationToAccreditation_Mapping__c map7 = new PRM_CertificationToAccreditation_Mapping__c();
			map7.Name = 'Network Integration Engineer';
			map7.Accreditation_Field_API_Name__c = 'Network_Integration_Engineer__c';
			certToAccred.add(map7);
			
			PRM_CertificationToAccreditation_Mapping__c map8 = new PRM_CertificationToAccreditation_Mapping__c();
			map8.Name = 'Partner Marketing Manager';
			map8.Accreditation_Field_API_Name__c = 'Partner_Marketing_Manager__c';
			certToAccred.add(map8);
			
			PRM_CertificationToAccreditation_Mapping__c map9 = new PRM_CertificationToAccreditation_Mapping__c();
			map9.Name = 'Technical Support Level 1';
			map9.Accreditation_Field_API_Name__c = 'Technical_Support_Level_1__c';
			certToAccred.add(map9);
			
			PRM_CertificationToAccreditation_Mapping__c map10 = new PRM_CertificationToAccreditation_Mapping__c();
			map10.Name = 'Administration Software Only';
			map10.Accreditation_Field_API_Name__c = 'Administration_Software_Only__c';
			certToAccred.add(map10);
			insert certToAccred;
			
			//acc2.Partner_Program__c = 'GPP 3.0';
	 // update acc2;
	 //
			
	Test.startTest();
			Contact con = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=acc.id,Email=PRMGlobalConstants.EmailContactNamePRM );
			database.insert(con);
			
			Contact con1 = new Contact(lastName='test1'+PRMGlobalConstants.ContactNamePRM,AccountId=acc1.id,Email='test1'+PRMGlobalConstants.EmailContactNamePRM );
			database.insert(con1);
			
			Contact con2 = new Contact(lastName='test2'+PRMGlobalConstants.ContactNamePRM,AccountId=acc2.id,Email='test2'+PRMGlobalConstants.EmailContactNamePRM );
			database.insert(con2);
			
			Certification_Matrix__c CertMatrix1 = new Certification_Matrix__c(GPP_0_0__c = 'test 10', GPP_1_0__c = 'test 11', GPP_2_0__c = 'test 12', GPP_3_0__c = 'test 13');
			Database.insert(CertMatrix1);
			CertMatrix1.GPP_0_0__c = 'PRMTEST1';
			CertMatrix1.GPP_1_0__c = 'PRMTEST1 1';
			CertMatrix1.GPP_2_0__c = 'PRMTEST1 2';
			CertMatrix1.GPP_3_0__c = 'PRMTEST1 3';
			Database.Update(CertMatrix1);
			Certification_Matrix__c CertMatrix = new Certification_Matrix__c(GPP_0_0__c = 'test 0', GPP_1_0__c = 'test 1', GPP_2_0__c = 'test 2', GPP_3_0__c = 'test 3');
			Database.insert(CertMatrix);
			CertMatrix.GPP_0_0__c = 'PRMTEST';
			CertMatrix.GPP_1_0__c = 'PRMTEST 1';
			CertMatrix.GPP_2_0__c = 'PRMTEST 2';
			CertMatrix.GPP_3_0__c = 'PRMTEST 3';
			Database.Update(CertMatrix);
			
			LIST<Certification__c> certdetailList = new LIST<Certification__c>();
			Certification__c certification1 = new Certification__c(GPP_Certification_Name__c = 'Deployment Installation test', Certification_Matrix_Number__c = CertMatrix1.ID, Name__c = con.Id, 
	Partner__c = acc.ID,  Approvedby_Authority__c = 'No', Certification_Status__c = PRMGlobalConstants.Completed);
			certdetailList.add(certification1);
			
			Certification__c certification2 = new Certification__c(GPP_Certification_Name__c = 'Deployment Installation test', Certification_Matrix_Number__c = CertMatrix1.ID, Name__c = con.Id, 
	Partner__c = acc1.ID,  Approvedby_Authority__c = 'No', Certification_Status__c = PRMGlobalConstants.Completed);
			certdetailList.add(certification2);
			
			Certification__c certification3 = new Certification__c(GPP_Certification_Name__c = 'Deployment Installation test', Certification_Matrix_Number__c = CertMatrix1.ID, Name__c = con.Id, 
	Partner__c = acc2.ID,  Approvedby_Authority__c = 'No', Certification_Status__c = PRMGlobalConstants.Completed);
			certdetailList.add(certification3);
			
			Database.insert(certdetailList);
	//Test.stopTest();
	
			certification1.Certification_Matrix_Number__c = CertMatrix.ID;
			certification2.Certification_Matrix_Number__c = CertMatrix.ID;
			certification3.Certification_Matrix_Number__c = CertMatrix.ID;
			Database.update(certdetailList);
			//acc.Partner_Program__c = 'GPP 3.0';
			//update acc;
			//Test.startTest();
	 
			LIST<Certification__c> certdetailList1 = new LIST<Certification__c>();
			Certification__c certification = new Certification__c(GPP_Certification_Name__c = 'Deployment Installation test', Certification_Matrix_Number__c = CertMatrix1.ID, Name__c = con.Id, 
	  Partner__c = acc.ID,  Approvedby_Authority__c = 'No');
			Database.insert(certification);   
			certification.Certification_Matrix_Number__c = CertMatrix.ID;
			Database.update(certification); 
			certdetailList1.add(certification);
			Test.stopTest();
			CertificationTriggerHelper.updateGPPFieldsonCert(null,null);
			CertificationTriggerHelper.updateGPPFieldsonCertonInsert(null);
			CertificationTriggerHelper.afterUpdateCertificationSharePSM(null);
			CertificationTriggerHelper.accreditationUpdate(certdetailList1);
			CertificationTriggerHelper.accreditationUpdate(null);
			delete certdetailList;
		}
	}	
}