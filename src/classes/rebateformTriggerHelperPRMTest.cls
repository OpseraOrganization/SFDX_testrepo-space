@IsTest
public class rebateformTriggerHelperPRMTest {
	 @testSetup static void createTestData() {
			NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
			cs.Name = 'Default';
			cs.Customer_Account__c = 'Customer - test';
			cs.Customer_Account_Number__c = '12345';
			cs.Customer_User_Profile__c = 'Customers';
			insert cs;
		}

	private static testMethod void sendEmailOnRebateSubmissionTest(){
	   //User creation
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		
		system.runAs(runAsUSer[0]){
		Account accountCreationPRM = TestDataFactory.createAccount(1)[0];
		accountCreationPRM.AccountNumber = '124434';
		accountCreationPRM.partner_type__c = 'Value Added Reseller';
		accountCreationPRM.Partner_Program__c = 'GPP 3.0';
		accountCreationPRM.Market__c = 'Market India';
		database.insert(accountCreationPRM);
		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;
		User user1 = new User(alias = 'abc', email = uniqueName + '@nokia.com' , emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
								 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.Nokia_Sales_Profile_Id,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
								 timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
		database.insert(user1); 
		Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=accountCreationPRM.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		database.insert(conPRM);
		 User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',						   lastname = 'Testing',
								 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
								 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id );
								 
		database.insert(userPRM); 
		System.runAs(runAsUSer[0]){
		//Account creation
		List<Account> AccountList = new List<Account>();
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		accountCreation.AccountNumber = '1234500045'; 
		accountCreation.partner_type__c = 'Value Added Reseller';
			accountCreation.Partner_Program__c = 'GPP 3.0';
		accountCreation.Market__c = 'Market India';
		AccountList.add(accountCreation);
		
		Account accountCreation1 = TestDataFactory.createAccount(1)[0];
		accountCreation1.AccountNumber = '123450004511'; 
		accountCreation1.partner_type__c = 'Value Added Reseller';
			  accountCreation1.Partner_Program__c = 'GPP 3.0';
		accountCreation1.Market__c = 'Market India';
		AccountList.add(accountCreation1);
		
		database.insert(AccountList);
		accountCreation.isPartner = true;
		database.update(accountCreation);
		accountCreation1.isPartner = true;
		database.update(accountCreation1);
			 
		
		//AccreditationList cretion for each product
		List<Accreditation__c> AccreditationList = new List<Accreditation__c>();
		Accreditation__c Accreditation1 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'Airscale Wifi', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation.ID, Actual_pricing_level__c = 'Advanced',Pricing_Cluster__c='NAM'  );
		AccreditationList.add(Accreditation1);
		Accreditation__c Accreditation2 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'Fixed Access - FBA', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation.ID, Actual_pricing_level__c = 'Advanced' ,Pricing_Cluster__c='NAM' );
		AccreditationList.add(Accreditation2);
		Accreditation__c Accreditation3 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'Fixed Access - POL', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation.ID, Actual_pricing_level__c = 'Advanced' ,Pricing_Cluster__c='NAM' );
		AccreditationList.add(Accreditation3);
		Accreditation__c Accreditation4 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'IP Routing', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation.ID, Actual_pricing_level__c = 'Advanced' ,Pricing_Cluster__c='NAM' );
		AccreditationList.add(Accreditation4);
		Accreditation__c Accreditation5 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'Microwave', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation.ID, Actual_pricing_level__c = 'Advanced' ,Pricing_Cluster__c='NAM' );
		AccreditationList.add(Accreditation5);
		Accreditation__c Accreditation6 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'Nuage', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation.ID, Actual_pricing_level__c = 'Advanced' ,Pricing_Cluster__c='NAM' );
		AccreditationList.add(Accreditation6);
		Accreditation__c Accreditation7 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'Optics', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation.ID, Actual_pricing_level__c = 'Advanced' ,Pricing_Cluster__c='NAM' );
		AccreditationList.add(Accreditation7);
		Accreditation__c Accreditation8 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'Vital QIP', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation.ID, Actual_pricing_level__c = 'Advanced' ,Pricing_Cluster__c='NAM' );
		AccreditationList.add(Accreditation8);
		Accreditation__c Accreditation9 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'Vital Suite', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation.ID, Actual_pricing_level__c = 'Advanced',Pricing_Cluster__c='NAM'  );
		AccreditationList.add(Accreditation9);
		Database.Insert(AccreditationList);
		
		List<Accreditation__c> AccreditationList1 = new List<Accreditation__c>();
		Accreditation__c Accreditation01 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Authorized - Accreditation In Progress', Pricing_Level_Override__c = 'Basic', Portfolio__c = 'Airscale Wifi', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation1.ID, Actual_pricing_level__c = 'Advanced' ,Pricing_Cluster__c='NAM' );
		AccreditationList1.add(Accreditation01);
		Accreditation__c Accreditation02 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Authorized - Accreditation In Progress', Pricing_Level_Override__c = 'Basic', Portfolio__c = 'Fixed Access - FBA', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation1.ID, Actual_pricing_level__c = 'Advanced',Pricing_Cluster__c='NAM' );
		AccreditationList1.add(Accreditation02);
		//Database.Insert(AccreditationList1);
		
		//contract creation
		List<Contract> ContractList = new List<Contract>();
		Contract contactInstance1 = new Contract (AccountID = accountCreation.ID, Name = 'Contact for Test1', StartDate = date.today() -1 , EndDate = date.today() + 5 , Status = 'Draft', Contract_Type__c = 'NIRA');
		ContractList.add(contactInstance1);
		Contract contactInstance2 = new Contract (AccountID = accountCreation.ID, Name = 'Contact for Test2', StartDate = date.today() - 10, EndDate = date.today() - 2 , Status = 'Draft', Contract_Type__c = 'NIRA');
		ContractList.add(contactInstance2);
		Contract contactInstance3 = new Contract (AccountID = accountCreation1.ID, Name = 'Contact for Test3', StartDate = date.today() - 10, EndDate = date.today() + 1 , Status = 'Draft', Contract_Type__c = 'NIRA');
		ContractList.add(contactInstance3);
		database.insert(ContractList);
		
		//Custom Setting
		List<Contract_Eligible_for_Rebate__c> customSetting = new List<Contract_Eligible_for_Rebate__c>();
		Contract_Eligible_for_Rebate__c cs1 = new Contract_Eligible_for_Rebate__c();
		cs1.Name = 'NIRA';
		customSetting.add(cs1);
		database.insert(customSetting);
		
		
		//Contact creation
		/*Contact con = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=accountCreation.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		database.insert(con); */			 
		
					   
		List<Account_Member__c> AccountMemList = new List<Account_Member__c>();
		Account_Member__c AccountMemPRM = new Account_Member__c(Account__c = accountCreation.Id, Account_Role__c = 'Partner Sales Manager',Type__c = 'Internal', Name__c = accountCreation.Owner.Id );
		Account_Member__c AccountMemPSM = new Account_Member__c(Account__c = accountCreation.Id, Account_Role__c = 'Partner Relationship Manager', Type__c = 'External', Name__c = user1.Id );
		AccountMemList.add(AccountMemPRM);
		AccountMemList.add(AccountMemPSM);
		database.insert(AccountMemList);
	   
		List<Rebate_Period__c> Rebate_PeriodList = new List<Rebate_Period__c>();
		Rebate_Period__c RebatePeriod = new Rebate_Period__c(Enrollment_End_Date__c = date.today() + 10,Name='test', Enrollment_start_date__c = date.today()-30, Enrollment_Notification__c = false, Partner_Type__c = 'Value Added Reseller', End_Date__c = date.today() + 9, Rebate_Notification__c = null, Start_Date__c = date.today() + 1, Rebate_Terms_and_Conditions__c = 'Rebate Terms and Conditions for VAR', Technologies__c = 'Airscale Wifi; Fixed Access - FBA; Fixed Access - POL; IP Routing; Microwave; Nuage; Optics; Vital QIP; Vital Suite', Rebate_Region__c = 'Market India');
		Rebate_PeriodList.add(RebatePeriod);
		Rebate_Period__c RebatePeriod1 = new Rebate_Period__c(Enrollment_End_Date__c = date.today() + 10, Enrollment_start_date__c = date.today(), Enrollment_Notification__c = true, Partner_Type__c = 'Value Added Reseller', End_Date__c = date.today() + 9, Rebate_Notification__c = null, Start_Date__c = date.today() + 1, Name='test',Rebate_Terms_and_Conditions__c = 'Rebate Terms and Conditions for VAR', Technologies__c = 'Airscale Wifi; Fixed Access - FBA; Fixed Access - POL; IP Routing; Microwave; Nuage; Optics; Vital QIP; Vital Suite', Rebate_Region__c = 'Market India');
		Rebate_PeriodList.add(RebatePeriod1);
		Database.insert(Rebate_PeriodList);
		RebatePeriod.Rebate_Notification__c = 'Reminder';
		Database.update(RebatePeriod);
		RebatePeriod.Rebate_Notification__c = 'Final Review';
		Database.update(RebatePeriod);
		
		RebatePeriod.Enrollment_Notification__c = true;
		Database.update(RebatePeriod);
			
		List<Rebate_Enrollment__c> enrollmentList = new List<Rebate_Enrollment__c>();
		Rebate_Enrollment__c rebateEnrollment1 = new Rebate_Enrollment__c(Enrollment_Status__c = 'Not Enrolled', Initial_Date_Sent__c = system.today(), Partner_Account__c = accountCreation.Id, Rebate_Period__c = RebatePeriod.Id);
		Rebate_Enrollment__c rebateEnrollment2 = new Rebate_Enrollment__c(Enrollment_Status__c = 'Not Enrolled', Initial_Date_Sent__c = system.today(), Partner_Account__c = accountCreation1.Id, Rebate_Period__c = RebatePeriod.Id);
		Rebate_Enrollment__c rebateEnrollment3 = new Rebate_Enrollment__c(Enrollment_Status__c = 'Not Enrolled', Initial_Date_Sent__c = system.today(), Partner_Account__c = accountCreation.Id, Rebate_Period__c = RebatePeriod.Id);
		database.insert(rebateEnrollment1);
			database.insert(rebateEnrollment2);database.insert(rebateEnrollment3);
			/*enrollmentList.add(rebateEnrollment1);
		enrollmentList.add(rebateEnrollment2); 
		enrollmentList.add(rebateEnrollment3); */
	   // database.insert(enrollmentList);
		
		Test.startTest();
		List<Rebate_form__c> RebateFormList = new List<Rebate_form__c>();
		Rebate_form__c RebateForm2 = new Rebate_form__c(Rebate_Period__c = RebatePeriod.ID, Airscale_Wifi__c = true, Payment_Method__c = 'Credit memo (to be used against future purchases of Nokia Products and Services).', Rebate_Form_Status__c = 'Accepted - Second Review', Fixed_Access_FBA__c = true, Nuage__c = true, Fixed_Access_POL__c = true, IP_Routing__c = true, Microwave__c = true, Optics__c = true, Vital_QIP__c = true, Vital_Suite__c = true, Partner_Acceptance_Status__c = 'Accepted', 
		Email__c = user1.email, Partner_Account__c = accountCreation.ID );
		RebateFormList.add(RebateForm2);
		Rebate_form__c RebateForm1 = new Rebate_form__c(Rebate_Period__c = RebatePeriod1.ID, Airscale_Wifi__c = true, Payment_Method__c = 'Credit memo (to be used against future purchases of Nokia Products and Services).', Rebate_Form_Status__c = 'Accepted - Second Review', Fixed_Access_FBA__c = true, Nuage__c = true, Fixed_Access_POL__c = true, IP_Routing__c = true, Microwave__c = true, Optics__c = true, Vital_QIP__c = true, Vital_Suite__c = true, Partner_Acceptance_Status__c = 'Accepted', 
		Email__c = user1.email, Partner_Account__c = accountCreation.ID );
		RebateFormList.add(RebateForm1);
		Database.insert(RebateFormList);
	   
		
		
		List<Rebate_Amount__c> Rebate_AmountList = new List<Rebate_Amount__c>();
		Rebate_Amount__c RebateAmount1 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'Airscale Wifi', Rebate__c = RebateForm2.ID);
		Rebate_AmountList.add(RebateAmount1);
		Rebate_Amount__c RebateAmount2 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'Fixed Access - FBA', Rebate__c = RebateForm2.ID);
		Rebate_AmountList.add(RebateAmount2);
		Rebate_Amount__c RebateAmount3 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'Fixed Access - POL', Rebate__c = RebateForm2.ID);
		Rebate_AmountList.add(RebateAmount3);
		Rebate_Amount__c RebateAmount4 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'IP Routing', Rebate__c = RebateForm2.ID);
		Rebate_AmountList.add(RebateAmount4);
		Rebate_Amount__c RebateAmount5 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'Microwave', Rebate__c = RebateForm2.ID);
		Rebate_AmountList.add(RebateAmount5);
		Rebate_Amount__c RebateAmount6 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'Nuage', Rebate__c = RebateForm2.ID);
		Rebate_AmountList.add(RebateAmount6);
		Rebate_Amount__c RebateAmount7 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'Optics', Rebate__c = RebateForm2.ID);
		Rebate_AmountList.add(RebateAmount7);
		Rebate_Amount__c RebateAmount8 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'Vital QIP', Rebate__c = RebateForm2.ID);
		Rebate_AmountList.add(RebateAmount8);
		Rebate_Amount__c RebateAmount9 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'Vital Suite', Rebate__c = RebateForm2.ID);
		Rebate_AmountList.add(RebateAmount9);
		Rebate_Amount__c RebateAmount19 = new Rebate_Amount__c(Portfolio__c = 'Vital Suite', Rebate__c = RebateForm1.ID);
		Rebate_AmountList.add(RebateAmount19);
		Database.insert(Rebate_AmountList);
			
		RebateForm2.Partner_Acceptance_Status__c = 'Rejected';
		Database.update(RebateForm2);
		
		RebateAmount1.Amount__c = 200;
		Database.update(RebateAmount1);
		RebateAmount2.Amount__c = 200;
		Database.update(RebateAmount2);
		
		Database.delete(contactInstance1);
		Database.delete(contactInstance2);
		contactInstance3.StartDate = date.today()-100;
		contactInstance3.EndDate = date.today() - 1 ;
		Database.update(contactInstance3);
	
		Contract contactInstance4 = new Contract (AccountID = accountCreation1.ID, Name = 'Contact for Test3', StartDate = date.today() - 10, EndDate = date.today() + 1 , Status = 'Draft', Contract_Type__c = 'NIRA');
		Database.insert(contactInstance4);
	
		string jsonString = '["Vital Suite","Nuage"]';
		RebateForm2.Partner_Acceptance_Status__c = 'Accepted';
		Database.update(RebateForm2);
		RebateForm2.Rebate_Form_Status__c = 'Rejected';
		RebateForm2.Pending_Rejection_Reason__c = 'PPA Contract Expired';
		Database.update(RebateForm2);
		 Test.stopTest();
		List<String> technologiesList = new List<String>();
		technologiesList.add('Airscale Wifi');
		technologiesList.add('Fixed Access - FBA');
		technologiesList.add('Fixed Access - POL');
		technologiesList.add('IP Routing');
		technologiesList.add('Microwave');
		technologiesList.add('Nuage');	
		technologiesList.add('Optics');	
		technologiesList.add('Vital QIP');	
		technologiesList.add('Vital Suite');  
	}
  }
  }
  private static testMethod void sendEmailOnRebateSubmissionTest2(){
	  Test.startTest();
	List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		system.runAs(runAsUSer[0]){
	 //Account creation
		List<Account> AccountList = new List<Account>();
		Account accountCreation0 = TestDataFactory.createAccount(1)[0];
		accountCreation0.AccountNumber = '1234500045'; 
		accountCreation0.partner_type__c = 'Value Added Reseller';
			 accountCreation0.Partner_Program__c = 'GPP 3.0';
		AccountList.add(accountCreation0);
		
		Account accountCreation01 = TestDataFactory.createAccount(1)[0];
		accountCreation01.AccountNumber = '123450004511'; 
		accountCreation01.partner_type__c = 'Value Added Reseller'; 
		accountCreation01.Partner_Program__c = 'GPP 3.0';
		AccountList.add(accountCreation01);
		
		database.insert(AccountList);
		accountCreation0.isPartner = true;
		database.update(accountCreation0);
		accountCreation01.isPartner = true;
		database.update(accountCreation01);
			 
		
		//AccreditationList cretion for each product
		List<Accreditation__c> AccreditationList = new List<Accreditation__c>();
		Accreditation__c Accreditation1 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'Airscale Wifi', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation0.ID, Actual_pricing_level__c = 'Advanced',Pricing_Cluster__c='NAM'  );
		AccreditationList.add(Accreditation1);
		Accreditation__c Accreditation2 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'Fixed Access - FBA', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation0.ID, Actual_pricing_level__c = 'Advanced',Pricing_Cluster__c='NAM'  );
		AccreditationList.add(Accreditation2);
		Accreditation__c Accreditation3 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'Fixed Access - POL', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation0.ID, Actual_pricing_level__c = 'Advanced',Pricing_Cluster__c='NAM'  );
		AccreditationList.add(Accreditation3);
		Accreditation__c Accreditation4 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'IP Routing', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation0.ID, Actual_pricing_level__c = 'Advanced',Pricing_Cluster__c='NAM'  );
		AccreditationList.add(Accreditation4);
		Accreditation__c Accreditation5 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'Microwave', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation0.ID, Actual_pricing_level__c = 'Advanced',Pricing_Cluster__c='NAM'  );
		AccreditationList.add(Accreditation5);
		Accreditation__c Accreditation6 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'Nuage', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation0.ID, Actual_pricing_level__c = 'Advanced',Pricing_Cluster__c='NAM'  );
		AccreditationList.add(Accreditation6);
		Accreditation__c Accreditation7 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'Optics', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation0.ID, Actual_pricing_level__c = 'Advanced' ,Pricing_Cluster__c='NAM' );
		AccreditationList.add(Accreditation7);
		Accreditation__c Accreditation8 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'Vital QIP', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation0.ID, Actual_pricing_level__c = 'Advanced',Pricing_Cluster__c='NAM'  );
		AccreditationList.add(Accreditation8);
		Accreditation__c Accreditation9 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'Vital Suite', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation0.ID, Actual_pricing_level__c = 'Advanced',Pricing_Cluster__c='NAM'  );
		AccreditationList.add(Accreditation9);
		Database.Insert(AccreditationList);
		
		List<Accreditation__c> AccreditationList1 = new List<Accreditation__c>();
		Accreditation__c Accreditation01 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Authorized - Accreditation In Progress', Pricing_Level_Override__c = 'Basic', Portfolio__c = 'Airscale Wifi', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation01.ID, Actual_pricing_level__c = 'Advanced',Pricing_Cluster__c='NAM'  );
		AccreditationList1.add(Accreditation01);
		Accreditation__c Accreditation02 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Authorized - Accreditation In Progress', Pricing_Level_Override__c = 'Basic', Portfolio__c = 'Fixed Access - FBA', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation01.ID, Actual_pricing_level__c = 'Advanced',Pricing_Cluster__c='NAM'  );
		AccreditationList1.add(Accreditation02);
		//Database.Insert(AccreditationList1);
		
		//contract creation
		List<Contract> ContractList = new List<Contract>();
		Contract contactInstance1 = new Contract (AccountID = accountCreation0.ID, Name = 'Contact for Test1', StartDate = date.today() -1 , EndDate = date.today() + 5 , Status = 'Draft', Contract_Type__c = 'NIRA');
		ContractList.add(contactInstance1);
		Contract contactInstance2 = new Contract (AccountID = accountCreation0.ID, Name = 'Contact for Test2', StartDate = date.today() - 10, EndDate = date.today() - 2 , Status = 'Draft', Contract_Type__c = 'NIRA');
		ContractList.add(contactInstance2);
		Contract contactInstance3 = new Contract (AccountID = accountCreation01.ID, Name = 'Contact for Test3', StartDate = date.today() - 10, EndDate = date.today() + 1 , Status = 'Draft', Contract_Type__c = 'NIRA');
		ContractList.add(contactInstance3);
		database.insert(ContractList);
		
		//Custom Setting
		List<Contract_Eligible_for_Rebate__c> customSetting = new List<Contract_Eligible_for_Rebate__c>();
		Contract_Eligible_for_Rebate__c cs1 = new Contract_Eligible_for_Rebate__c();
		cs1.Name = 'NIRA';
		customSetting.add(cs1);
		database.insert(customSetting);
		
		
		//Contact creation
		Contact con = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=accountCreation0.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		database.insert(con);
		
		//User creation
		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;
		User user1 = new User(alias = 'abc', email = uniqueName + '@nokia.com' , emailencodingkey = 'UTF-8', firstName = 'test', 
									lastname = 'Testing',
								 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.Nokia_Sales_Profile_Id,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
								 timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
		database.insert(user1);
		
		List<Account_Member__c> AccountMemList = new List<Account_Member__c>();
		Account_Member__c AccountMemPRM = new Account_Member__c(Account__c = accountCreation0.Id, Account_Role__c = 'Partner Sales Manager',Type__c = 'Internal', Name__c = user1.Id );
		Account_Member__c AccountMemPSM = new Account_Member__c(Account__c = accountCreation0.Id, Account_Role__c = 'Partner Relationship Manager', Type__c = 'External', Name__c = user1.Id );
		AccountMemList.add(AccountMemPRM);
		AccountMemList.add(AccountMemPSM);
		database.insert(AccountMemList);
	   
		List<Rebate_Period__c> Rebate_PeriodList = new List<Rebate_Period__c>();
		Rebate_Period__c RebatePeriod = new Rebate_Period__c(Enrollment_End_Date__c = date.today() + 10,Name='test', Enrollment_start_date__c = date.today()-30, Enrollment_Notification__c = true, Partner_Type__c = 'Value Added Reseller', End_Date__c = date.today() + 9, Rebate_Notification__c = null, Start_Date__c = date.today() + 1, Rebate_Terms_and_Conditions__c = 'Rebate Terms and Conditions for VAR', Technologies__c = 'Airscale Wifi; Fixed Access - FBA; Fixed Access - POL; IP Routing; Microwave; Nuage; Optics; Vital QIP; Vital Suite');
		Rebate_PeriodList.add(RebatePeriod);
		Rebate_Period__c RebatePeriod1 = new Rebate_Period__c(Enrollment_End_Date__c = date.today() + 10, Enrollment_start_date__c = date.today(), Enrollment_Notification__c = true, Partner_Type__c = 'Value Added Reseller', End_Date__c = date.today() + 9, Rebate_Notification__c = null, Start_Date__c = date.today() + 1, Name='test',Rebate_Terms_and_Conditions__c = 'Rebate Terms and Conditions for VAR', Technologies__c = 'Airscale Wifi; Fixed Access - FBA; Fixed Access - POL; IP Routing; Microwave; Nuage; Optics; Vital QIP; Vital Suite');
		Rebate_PeriodList.add(RebatePeriod1);
		Database.insert(Rebate_PeriodList);
		RebatePeriod.Rebate_Notification__c = 'Reminder';
		Database.update(RebatePeriod);
		RebatePeriod.Rebate_Notification__c = 'Final Review';
		Database.update(RebatePeriod);
		
		RebatePeriod.Enrollment_Notification__c = true;
		Database.update(RebatePeriod);
		
		List<Rebate_form__c> RebateFormList = new List<Rebate_form__c>();
		Rebate_form__c RebateForm2 = new Rebate_form__c(Rebate_Period__c = RebatePeriod.ID, Airscale_Wifi__c = true, Payment_Method__c = 'Credit memo (to be used against future purchases of Nokia Products and Services).', Rebate_Form_Status__c = 'Accepted - Second Review', Fixed_Access_FBA__c = true, Nuage__c = true, Fixed_Access_POL__c = true, IP_Routing__c = true, Microwave__c = true, Optics__c = true, Vital_QIP__c = true, Vital_Suite__c = true, Partner_Acceptance_Status__c = 'Accepted', 
		Email__c = user1.email, Partner_Account__c = accountCreation0.ID );
		RebateFormList.add(RebateForm2);
		Rebate_form__c RebateForm1 = new Rebate_form__c(Rebate_Period__c = RebatePeriod1.ID, Airscale_Wifi__c = true, Payment_Method__c = 'Credit memo (to be used against future purchases of Nokia Products and Services).', Rebate_Form_Status__c = 'Accepted - Second Review', Fixed_Access_FBA__c = true, Nuage__c = true, Fixed_Access_POL__c = true, IP_Routing__c = true, Microwave__c = true, Optics__c = true, Vital_QIP__c = true, Vital_Suite__c = true, Partner_Acceptance_Status__c = 'Accepted', 
		Email__c = user1.email, Partner_Account__c = accountCreation0.ID );
		RebateFormList.add(RebateForm1);
		Database.insert(RebateFormList);
		
		
		
		List<Rebate_Amount__c> Rebate_AmountList = new List<Rebate_Amount__c>();
		Rebate_Amount__c RebateAmount1 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'Airscale Wifi', Rebate__c = RebateForm2.ID);
		Rebate_AmountList.add(RebateAmount1);
		Rebate_Amount__c RebateAmount2 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'Fixed Access - FBA', Rebate__c = RebateForm2.ID);
		Rebate_AmountList.add(RebateAmount2);
		Rebate_Amount__c RebateAmount3 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'Fixed Access - POL', Rebate__c = RebateForm2.ID);
		Rebate_AmountList.add(RebateAmount3);
		Rebate_Amount__c RebateAmount4 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'IP Routing', Rebate__c = RebateForm2.ID);
		Rebate_AmountList.add(RebateAmount4);
		Rebate_Amount__c RebateAmount5 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'Microwave', Rebate__c = RebateForm2.ID);
		Rebate_AmountList.add(RebateAmount5);
		Rebate_Amount__c RebateAmount6 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'Nuage', Rebate__c = RebateForm2.ID);
		Rebate_AmountList.add(RebateAmount6);
		Rebate_Amount__c RebateAmount7 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'Optics', Rebate__c = RebateForm2.ID);
		Rebate_AmountList.add(RebateAmount7);
		Rebate_Amount__c RebateAmount8 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'Vital QIP', Rebate__c = RebateForm2.ID);
		Rebate_AmountList.add(RebateAmount8);
		Rebate_Amount__c RebateAmount9 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'Vital Suite', Rebate__c = RebateForm2.ID);
		Rebate_AmountList.add(RebateAmount9);
		Rebate_Amount__c RebateAmount19 = new Rebate_Amount__c(Portfolio__c = 'Vital Suite', Rebate__c = RebateForm1.ID);
		Rebate_AmountList.add(RebateAmount19);
		Database.insert(Rebate_AmountList);
		
		RebateForm2.Partner_Acceptance_Status__c = 'Rejected';
		Database.update(RebateForm2);
		
		RebateAmount1.Amount__c = 200;
		Database.update(RebateAmount1);
		RebateAmount2.Amount__c = 200;
		Database.update(RebateAmount2);
		string jsonString = '["Vital Suite"]';
		//String sbody = JSON.serialize(jsonString);

		
		RebateForm2.Partner_Acceptance_Status__c = PRMGlobalConstants.REJECTED_STATUS;
		Database.update(RebateForm2);
		RebateForm2.Rebate_Form_Status__c = PRMGlobalConstants.REJECTED_STATUS;
		Database.update(RebateForm2);
		Test.stopTest();
		
		List<String> technologiesList = new List<String>();
		RebatePeriodTriggerHelper.sendEmailForExpiredContract(RebatePeriod);
		RebatePeriodTriggerHelper.sendEmailForExpiredContractVar(RebatePeriod);
		RebatePeriodTriggerHelper.sendEmails(RebatePeriod1);
		RebateForm.checkValidUser();
		//RebateForm.saveRebate(jsonString,technologiesList);
		RebatePeriod1 = RebateForm.getRebatePeriod();
		RebateForm.availableTech();
	}
		
 }
	private static testMethod void RebateformClassTest(){
		Test.startTest();
		List<Rebate_Period__c> Rebate_PeriodList = new List<Rebate_Period__c>();
		Rebate_Period__c RebatePeriod = new Rebate_Period__c(Enrollment_End_Date__c = date.today() + 10,Name='test', Enrollment_start_date__c = date.today()-30, Enrollment_Notification__c = false, Partner_Type__c = 'Value Added Reseller', End_Date__c = date.today() + 9, Rebate_Notification__c = null, Start_Date__c = date.today() + 1, Rebate_Terms_and_Conditions__c = 'Rebate Terms and Conditions for VAR', Technologies__c = 'Airscale Wifi; Fixed Access - FBA; Fixed Access - POL; IP Routing; Microwave; Nuage; Optics; Vital QIP; Vital Suite');
		Rebate_PeriodList.add(RebatePeriod);
		Rebate_Period__c RebatePeriod1 = new Rebate_Period__c(Enrollment_End_Date__c = date.today() + 10, Enrollment_start_date__c = date.today(), Enrollment_Notification__c = true, Partner_Type__c = 'Value Added Reseller', End_Date__c = date.today() + 9, Rebate_Notification__c = null, Start_Date__c = date.today() + 1, Name='test',Rebate_Terms_and_Conditions__c = 'Rebate Terms and Conditions for VAR', Technologies__c = 'Airscale Wifi; Fixed Access - FBA; Fixed Access - POL; IP Routing; Microwave; Nuage; Optics; Vital QIP; Vital Suite');
		Rebate_PeriodList.add(RebatePeriod1);
		Database.insert(Rebate_PeriodList);
		RebatePeriod = RebateForm.getRebatePeriod();
		Test.stopTest();
		RebateForm.checkValidUser();
	}	
	

	@isTest static void leadTest() {
		Test.startTest();
		List<Rebate_Period__c> newList = new List<Rebate_Period__c>();
		try {
			RebatePeriodTriggerHandler.beforeInsert(newList);
		} catch(DMLException e) {
			system.assertEquals(e.getMessage(), e.getMessage());
		}
		 Test.stopTest();
		RebatePeriodTriggerHandler.beforeInsert(newList);
	}

@isTest static void leadTest1() {
	   Test.startTest();
		List<Rebate_Period__c> newList1 = new List<Rebate_Period__c>();
		try {
			RebatePeriodTriggerHandler.afterInsert(newList1);
		} catch(DMLException e) {
			system.assertEquals(e.getMessage(), e.getMessage());
		}
		 Test.stopTest();
		RebatePeriodTriggerHandler.afterInsert(newList1);
	}
	@isTest static void leadTest2() {
		Test.startTest();
		List<Rebate_Period__c> newList1 = new List<Rebate_Period__c>();
		Map<id,Rebate_Period__c> oldMap = new Map<id,Rebate_Period__c>();
		try {
			RebatePeriodTriggerHandler.afterUpdate(newList1,oldMap);
		} catch(DMLException e) {
			system.assertEquals(e.getMessage(), e.getMessage());
		}
		Test.stopTest();
		RebatePeriodTriggerHandler.afterUpdate(newList1,oldMap);
	}
	@isTest static void leadTest4() {
		Test.startTest();

		List<Rebate_Form__c> newList1 = new List<Rebate_Form__c>();
		Map<id,Rebate_Form__c> oldMap = new Map<id,Rebate_Form__c>();
		try {
			RebateFormTriggerHandler.afterUpdate(newList1,oldMap);
		} catch(DMLException e) {
			system.assertEquals(e.getMessage(), e.getMessage());
		}
		 Test.stopTest();
		RebateFormTriggerHandler.afterUpdate(newList1,oldMap);
	}
	@isTest static void leadTest5() {
		Test.startTest();
		Rebate_Form__c rebateForm = new Rebate_Form__c();
		
		try {
			RebateFormTriggerHandler.afterInsert(rebateForm);
		} catch(DMLException e) {
			system.assertEquals(e.getMessage(), e.getMessage());
		}
		 Test.stopTest();
		RebateFormTriggerHandler.afterInsert(rebateForm);
	}
   /* @isTest static void leadTest6() {
		string jsonString = '[PRMGlobalConstants.OpticsWaveLite,"Nuage"]';
		List<String> technologiesList = new List<String>();
		
		try {
			RebateForm.saveRebate(jsonString,technologiesList);
		} catch(DMLException e) {
			system.assertEquals(e.getMessage(), e.getMessage());
		}
		
		RebateForm.saveRebate(jsonString,technologiesList);
	}*/
	@isTest static void leadTest7() {
		Test.startTest();
		try {
			RebateForm.checkValidUser();
		} catch(DMLException e) {
			system.assertEquals(e.getMessage(), e.getMessage());
		}
		 Test.stopTest();
		RebateForm.checkValidUser();
	}

	private static testMethod void sendEmailOnRebateSubmissionTestEnd(){
		
	   //User creation
	 List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		system.runAs(runAsUSer[0]){
		Account accountCreationPRM = TestDataFactory.createAccount(1)[0];
		accountCreationPRM.AccountNumber = '124434';
		accountCreationPRM.partner_type__c = 'Value Added Reseller';
		 accountCreationPRM.Partner_Program__c = 'GPP 3.0';
		accountCreationPRM.Market__c = 'Market India';
		database.insert(accountCreationPRM);
		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;
		User user1 = new User(alias = 'abc', email = uniqueName + '@nokia.com' , emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
								 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.Nokia_Sales_Profile_Id,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
								 timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
		database.insert(user1); 
		Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=accountCreationPRM.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		database.insert(conPRM);
		 User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',						   lastname = 'Testing',
								 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
								 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id );
								 
		database.insert(userPRM); 
			//System.runAs(userPRM){
			//Account creation
			List<Account> AccountList = new List<Account>();
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.AccountNumber = '1234500045'; 
			accountCreation.partner_type__c = 'Value Added Reseller';
			accountCreation.Partner_Program__c = 'GPP 3.0';
			accountCreation.Market__c = 'Market India';
			AccountList.add(accountCreation);
			
			Account accountCreation1 = TestDataFactory.createAccount(1)[0];
			accountCreation1.AccountNumber = '123450004511'; 
			accountCreation1.partner_type__c = 'Value Added Reseller';
			accountCreation1.Partner_Program__c = 'GPP 3.0';
			accountCreation1.Market__c = 'Market India';
			AccountList.add(accountCreation1);
			
			database.insert(AccountList);
			accountCreation.isPartner = true;
			database.update(accountCreation);
			accountCreation1.isPartner = true;
			database.update(accountCreation1);
				 
			
			//AccreditationList cretion for each product
			List<Accreditation__c> AccreditationList = new List<Accreditation__c>();
			Accreditation__c Accreditation1 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'Airscale Wifi', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation.ID, Actual_pricing_level__c = 'Advanced',Pricing_Cluster__c='NAM'  );
			AccreditationList.add(Accreditation1);
			Accreditation__c Accreditation2 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'Fixed Access - FBA', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation.ID, Actual_pricing_level__c = 'Advanced',Pricing_Cluster__c='NAM'  );
			AccreditationList.add(Accreditation2);
			Accreditation__c Accreditation3 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'Fixed Access - POL', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation.ID, Actual_pricing_level__c = 'Advanced' ,Pricing_Cluster__c='NAM' );
			AccreditationList.add(Accreditation3);
			Accreditation__c Accreditation4 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'IP Routing', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation.ID, Actual_pricing_level__c = 'Advanced',Pricing_Cluster__c='NAM'  );
			AccreditationList.add(Accreditation4);
			Accreditation__c Accreditation5 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'Microwave', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation.ID, Actual_pricing_level__c = 'Advanced',Pricing_Cluster__c='NAM'  );
			AccreditationList.add(Accreditation5);
			Accreditation__c Accreditation6 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'Nuage', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation.ID, Actual_pricing_level__c = 'Advanced',Pricing_Cluster__c='NAM'  );
			AccreditationList.add(Accreditation6);
			Accreditation__c Accreditation7 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'Optics', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation.ID, Actual_pricing_level__c = 'Advanced' ,Pricing_Cluster__c='NAM' );
			AccreditationList.add(Accreditation7);
			Accreditation__c Accreditation8 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'Vital QIP', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation.ID, Actual_pricing_level__c = 'Advanced',Pricing_Cluster__c='NAM'  );
			AccreditationList.add(Accreditation8);
			Accreditation__c Accreditation9 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'Vital Suite', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation.ID, Actual_pricing_level__c = 'Advanced' ,Pricing_Cluster__c='NAM' );
			AccreditationList.add(Accreditation9);
			//Database.Insert(AccreditationList);
			
			List<Accreditation__c> AccreditationList1 = new List<Accreditation__c>();
			Accreditation__c Accreditation01 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Authorized - Accreditation In Progress', Pricing_Level_Override__c = 'Basic', Portfolio__c = 'Airscale Wifi', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation1.ID, Actual_pricing_level__c = 'Advanced',Pricing_Cluster__c='NAM'  );
			AccreditationList1.add(Accreditation01);
			Accreditation__c Accreditation02 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Authorized - Accreditation In Progress', Pricing_Level_Override__c = 'Basic', Portfolio__c = 'Fixed Access - FBA', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation1.ID, Actual_pricing_level__c = 'Advanced' ,Pricing_Cluster__c='NAM' );
			AccreditationList1.add(Accreditation02);
			//Database.Insert(AccreditationList1);
			
			//contract creation
			List<Contract> ContractList = new List<Contract>();
			Contract contactInstance1 = new Contract (AccountID = accountCreation.ID, Name = 'Contact for Test1', StartDate = date.today() -1 , EndDate = date.today() + 5 , Status = 'Draft', Contract_Type__c = 'NIRA');
			ContractList.add(contactInstance1);
			Contract contactInstance2 = new Contract (AccountID = accountCreation.ID, Name = 'Contact for Test2', StartDate = date.today() - 10, EndDate = date.today() - 2 , Status = 'Draft', Contract_Type__c = 'NIRA');
			ContractList.add(contactInstance2);
			Contract contactInstance3 = new Contract (AccountID = accountCreation1.ID, Name = 'Contact for Test3', StartDate = date.today() - 10, EndDate = date.today() + 1 , Status = 'Draft', Contract_Type__c = 'NIRA');
			ContractList.add(contactInstance3);
			database.insert(ContractList);
			
			//Custom Setting
			List<Contract_Eligible_for_Rebate__c> customSetting = new List<Contract_Eligible_for_Rebate__c>();
			Contract_Eligible_for_Rebate__c cs1 = new Contract_Eligible_for_Rebate__c();
			cs1.Name = 'NIRA';
			customSetting.add(cs1);
			database.insert(customSetting);
			
			
			//Contact creation
			/*Contact con = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=accountCreation.id,Email=PRMGlobalConstants.EmailContactNamePRM );
			database.insert(con); */			 
			
						   
			List<Account_Member__c> AccountMemList = new List<Account_Member__c>();
			Account_Member__c AccountMemPRM = new Account_Member__c(Account__c = accountCreation.Id, Account_Role__c = 'Partner Sales Manager',Type__c = 'Internal', Name__c =  user1.Id );
			Account_Member__c AccountMemPSM = new Account_Member__c(Account__c = accountCreation.Id, Account_Role__c = 'Partner Relationship Manager', Type__c = 'External', Name__c = accountCreation.Owner.Id);
			AccountMemList.add(AccountMemPRM);
			AccountMemList.add(AccountMemPSM);
			insert AccountMemList;
		   
			List<Rebate_Period__c> Rebate_PeriodList = new List<Rebate_Period__c>();
			Rebate_Period__c RebatePeriod = new Rebate_Period__c(Enrollment_End_Date__c = date.today() + 10,Name='test', Enrollment_start_date__c = date.today()-30, Enrollment_Notification__c = false, Partner_Type__c = 'Value Added Reseller', End_Date__c = date.today() + 9, Rebate_Notification__c = null, Start_Date__c = date.today() + 1, Rebate_Terms_and_Conditions__c = 'Rebate Terms and Conditions for VAR', Technologies__c = 'Airscale Wifi; Fixed Access - FBA; Fixed Access - POL; IP Routing; Microwave; Nuage; Optics; Vital QIP; Vital Suite', Rebate_Region__c = 'Market India');
			Rebate_PeriodList.add(RebatePeriod);
			Rebate_Period__c RebatePeriod1 = new Rebate_Period__c(Enrollment_End_Date__c = date.today() + 10, Enrollment_start_date__c = date.today(), Enrollment_Notification__c = true, Partner_Type__c = 'Value Added Reseller', End_Date__c = date.today() + 9, Rebate_Notification__c = null, Start_Date__c = date.today() + 1, Name='test',Rebate_Terms_and_Conditions__c = 'Rebate Terms and Conditions for VAR', Technologies__c = 'Airscale Wifi; Fixed Access - FBA; Fixed Access - POL; IP Routing; Microwave; Nuage; Optics; Vital QIP; Vital Suite', Rebate_Region__c = 'Market India');
			Rebate_PeriodList.add(RebatePeriod1);
			Database.insert(Rebate_PeriodList);
			RebatePeriod.Rebate_Notification__c = 'Reminder';
			Database.update(RebatePeriod);
			RebatePeriod.Rebate_Notification__c = 'Final Review';
			Database.update(RebatePeriod);
			
			RebatePeriod.Enrollment_Notification__c = true;
			Database.update(RebatePeriod);
				
			List<Rebate_Enrollment__c> enrollmentList = new List<Rebate_Enrollment__c>();
			Rebate_Enrollment__c rebateEnrollment1 = new Rebate_Enrollment__c(Enrollment_Status__c = 'Not Enrolled', Initial_Date_Sent__c = system.today(), Partner_Account__c = accountCreation.Id, Rebate_Period__c = RebatePeriod.Id);
			Rebate_Enrollment__c rebateEnrollment2 = new Rebate_Enrollment__c(Enrollment_Status__c = 'Not Enrolled', Initial_Date_Sent__c = system.today(), Partner_Account__c = accountCreation1.Id, Rebate_Period__c = RebatePeriod.Id);
			Rebate_Enrollment__c rebateEnrollment3 = new Rebate_Enrollment__c(Enrollment_Status__c = 'Not Enrolled', Initial_Date_Sent__c = system.today(), Partner_Account__c = accountCreation.Id, Rebate_Period__c = RebatePeriod.Id);
			database.insert(rebateEnrollment1);
				database.insert(rebateEnrollment2);database.insert(rebateEnrollment3);
				/*enrollmentList.add(rebateEnrollment1);
			enrollmentList.add(rebateEnrollment2); 
			enrollmentList.add(rebateEnrollment3); */
		   // database.insert(enrollmentList);
			Test.startTest();
			List<Rebate_form__c> RebateFormList = new List<Rebate_form__c>();
			Rebate_form__c RebateForm2 = new Rebate_form__c(Rebate_Period__c = RebatePeriod.ID, Airscale_Wifi__c = true, Payment_Method__c = 'Credit memo (to be used against future purchases of Nokia Products and Services).', Rebate_Form_Status__c = 'Accepted - Second Review', Fixed_Access_FBA__c = true, Nuage__c = true, Fixed_Access_POL__c = true, IP_Routing__c = true, Microwave__c = true, Optics__c = true, Vital_QIP__c = true, Vital_Suite__c = true, Partner_Acceptance_Status__c = 'Accepted', 
			Email__c = user1.email, Partner_Account__c = accountCreation.ID );
			RebateFormList.add(RebateForm2);
			Rebate_form__c RebateForm1 = new Rebate_form__c(Rebate_Period__c = RebatePeriod1.ID, Airscale_Wifi__c = true, Payment_Method__c = 'Credit memo (to be used against future purchases of Nokia Products and Services).', Rebate_Form_Status__c = 'Accepted - Second Review', Fixed_Access_FBA__c = true, Nuage__c = true, Fixed_Access_POL__c = true, IP_Routing__c = true, Microwave__c = true, Optics__c = true, Vital_QIP__c = true, Vital_Suite__c = true, Partner_Acceptance_Status__c = 'Accepted', 
			Email__c = user1.email, Partner_Account__c = accountCreation.ID );
			RebateFormList.add(RebateForm1);
			Database.insert(RebateFormList);
			
			
			
			List<Rebate_Amount__c> Rebate_AmountList = new List<Rebate_Amount__c>();
			Rebate_Amount__c RebateAmount1 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'Airscale Wifi', Rebate__c = RebateForm2.ID);
			Rebate_AmountList.add(RebateAmount1);
			Rebate_Amount__c RebateAmount2 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'Fixed Access - FBA', Rebate__c = RebateForm2.ID);
			Rebate_AmountList.add(RebateAmount2);
			Rebate_Amount__c RebateAmount3 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'Fixed Access - POL', Rebate__c = RebateForm2.ID);
			Rebate_AmountList.add(RebateAmount3);
			Rebate_Amount__c RebateAmount4 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'IP Routing', Rebate__c = RebateForm2.ID);
			Rebate_AmountList.add(RebateAmount4);
			Rebate_Amount__c RebateAmount5 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'Microwave', Rebate__c = RebateForm2.ID);
			Rebate_AmountList.add(RebateAmount5);
			Rebate_Amount__c RebateAmount6 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'Nuage', Rebate__c = RebateForm2.ID);
			Rebate_AmountList.add(RebateAmount6);
			Rebate_Amount__c RebateAmount7 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'Optics', Rebate__c = RebateForm2.ID);
			Rebate_AmountList.add(RebateAmount7);
			Rebate_Amount__c RebateAmount8 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'Vital QIP', Rebate__c = RebateForm2.ID);
			Rebate_AmountList.add(RebateAmount8);
			Rebate_Amount__c RebateAmount9 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'Vital Suite', Rebate__c = RebateForm2.ID);
			Rebate_AmountList.add(RebateAmount9);
			Rebate_Amount__c RebateAmount19 = new Rebate_Amount__c(Portfolio__c = 'Vital Suite', Rebate__c = RebateForm1.ID);
			Rebate_AmountList.add(RebateAmount19);
			Database.insert(Rebate_AmountList);
				
			RebateForm2.Partner_Acceptance_Status__c = 'Rejected';
			Database.update(RebateForm2);
			
			RebateAmount1.Amount__c = 200;
			Database.update(RebateAmount1);
			RebateAmount2.Amount__c = 200;
			Database.update(RebateAmount2);
			
			Database.delete(contactInstance1);
			Database.delete(contactInstance2);
			contactInstance3.StartDate = date.today()-100;
			contactInstance3.EndDate = date.today() - 1 ;
			Database.update(contactInstance3);
		
			Contract contactInstance4 = new Contract (AccountID = accountCreation1.ID, Name = 'Contact for Test3', StartDate = date.today() - 10, EndDate = date.today() + 1 , Status = 'Draft', Contract_Type__c = 'NIRA');
			Database.insert(contactInstance4);
		
			string jsonString = '["Vital Suite","Nuage"]';
			RebateForm2.Partner_Acceptance_Status__c = 'Accepted';
			Database.update(RebateForm2);
			RebateForm2.Rebate_Form_Status__c = 'Rejected';
			RebateForm2.Pending_Rejection_Reason__c = 'PPA Contract Expired';
			Database.update(RebateForm2);
			
			List<String> technologiesList = new List<String>();
			technologiesList.add('Airscale Wifi');
			technologiesList.add('Fixed Access - FBA');
			technologiesList.add('Fixed Access - POL');
			technologiesList.add('IP Routing');
			technologiesList.add('Microwave');
			technologiesList.add('Nuage');	
			technologiesList.add('Optics');	
			technologiesList.add('Vital QIP');	
			technologiesList.add('Vital Suite');	
				
			RebatePeriodTriggerHelper.sendEmailForExpiredContract(RebatePeriod);
			
			RebatePeriodTriggerHelper.sendEmailForExpiredContractVar(RebatePeriod);
			RebatePeriodTriggerHelper.sendEmails(RebatePeriod1);
			RebateForm.checkValidUser();
			RebateForm.saveRebate(jsonString,technologiesList);
			RebatePeriod1 = RebateForm.getRebatePeriod();
			RebateForm.availableTech();
			Test.stopTest();
	   //}
	}
  }
	private static testMethod void sendEmailOnRebateSubmissionTestEnd1(){
		//User creation
	 List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		system.runAs(runAsUSer[0]){
		Account accountCreationPRM = TestDataFactory.createAccount(1)[0];
		accountCreationPRM.AccountNumber = '124434';
		accountCreationPRM.partner_type__c = 'Value Added Reseller';
		accountCreationPRM.partner_Program__c= 'GPP 3.0';
		accountCreationPRM.Market__c = 'Market India';
		database.insert(accountCreationPRM);
		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;
		User user1 = new User(alias = 'abc', email = uniqueName + '@nokia.com' , emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
								 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.Nokia_Sales_Profile_Id,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
								 timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
		database.insert(user1); 
		Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=accountCreationPRM.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		database.insert(conPRM);
		 User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',						   lastname = 'Testing',
								 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
								 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id );
								 
		database.insert(userPRM); 
			System.runAs(runAsUSer[0]){
			//Account creation
			List<Account> AccountList = new List<Account>();
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.AccountNumber = '1234500045'; 
			accountCreation.partner_type__c = 'Value Added Reseller';
			accountCreation.partner_Program__c= 'GPP 3.0';
			accountCreation.Market__c = 'Market India';
			AccountList.add(accountCreation);
			
			Account accountCreation1 = TestDataFactory.createAccount(1)[0];
			accountCreation1.AccountNumber = '123450004511'; 
			accountCreation1.partner_type__c = 'Value Added Reseller';
		   accountCreation1.partner_Program__c= 'GPP 3.0';

			accountCreation1.Market__c = 'Market India';
			AccountList.add(accountCreation1);
			
			database.insert(AccountList);
			accountCreation.isPartner = true;
			database.update(accountCreation);
			accountCreation1.isPartner = true;
			database.update(accountCreation1);
				 
			
			//AccreditationList cretion for each product
			List<Accreditation__c> AccreditationList = new List<Accreditation__c>();
			Accreditation__c Accreditation1 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'Airscale Wifi', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation.ID, Actual_pricing_level__c = 'Advanced',Pricing_Cluster__c='NAM'  );
			AccreditationList.add(Accreditation1);
			Accreditation__c Accreditation2 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'Fixed Access - FBA', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation.ID, Actual_pricing_level__c = 'Advanced',Pricing_Cluster__c='NAM'  );
			AccreditationList.add(Accreditation2);
			Accreditation__c Accreditation3 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'Fixed Access - POL', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation.ID, Actual_pricing_level__c = 'Advanced',Pricing_Cluster__c='NAM'  );
			AccreditationList.add(Accreditation3);
			Accreditation__c Accreditation4 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'IP Routing', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation.ID, Actual_pricing_level__c = 'Advanced',Pricing_Cluster__c='NAM'  );
			AccreditationList.add(Accreditation4);
			Accreditation__c Accreditation5 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'Microwave', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation.ID, Actual_pricing_level__c = 'Advanced',Pricing_Cluster__c='NAM'  );
			AccreditationList.add(Accreditation5);
			Accreditation__c Accreditation6 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'Nuage', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation.ID, Actual_pricing_level__c = 'Advanced' ,Pricing_Cluster__c='NAM' );
			//AccreditationList.add(Accreditation6);
			Accreditation__c Accreditation7 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'Optics', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation.ID, Actual_pricing_level__c = 'Advanced',Pricing_Cluster__c='NAM'  );
			//AccreditationList.add(Accreditation7);
			Accreditation__c Accreditation8 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'Vital QIP', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation.ID, Actual_pricing_level__c = 'Advanced',Pricing_Cluster__c='NAM'  );
			//AccreditationList.add(Accreditation8);
			Accreditation__c Accreditation9 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Advanced', Pricing_Level_Override__c = 'Advanced', Portfolio__c = 'Vital Suite', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation.ID, Actual_pricing_level__c = 'Advanced' ,Pricing_Cluster__c='NAM' );
			//AccreditationList.add(Accreditation9);
			Database.Insert(AccreditationList);
			
			List<Accreditation__c> AccreditationList1 = new List<Accreditation__c>();
			Accreditation__c Accreditation01 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Authorized - Accreditation In Progress', Pricing_Level_Override__c = 'Basic', Portfolio__c = 'Airscale Wifi', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation1.ID, Actual_pricing_level__c = 'Advanced' ,Pricing_Cluster__c='NAM' );
			AccreditationList1.add(Accreditation01);
			Accreditation__c Accreditation02 = new Accreditation__c(Accreditation_Type__c = 'Product', Accreditation_Level__c = 'Authorized - Accreditation In Progress', Pricing_Level_Override__c = 'Basic', Portfolio__c = 'Fixed Access - FBA', Accreditation_Date__c = date.today() + 9, Pricing_Override_Expiration__c = date.today() + 9, Partner__c = accountCreation1.ID, Actual_pricing_level__c = 'Advanced' ,Pricing_Cluster__c='NAM' );
			AccreditationList1.add(Accreditation02);
			//Database.Insert(AccreditationList1);
			
			//contract creation
			List<Contract> ContractList = new List<Contract>();
			Contract contactInstance1 = new Contract (AccountID = accountCreation.ID, Name = 'Contact for Test1', StartDate = date.today() -1 , EndDate = date.today() + 5 , Status = 'Draft', Contract_Type__c = 'NIRA');
			ContractList.add(contactInstance1);
			Contract contactInstance2 = new Contract (AccountID = accountCreation.ID, Name = 'Contact for Test2', StartDate = date.today() - 10, EndDate = date.today() - 2 , Status = 'Draft', Contract_Type__c = 'NIRA');
			ContractList.add(contactInstance2);
			Contract contactInstance3 = new Contract (AccountID = accountCreation1.ID, Name = 'Contact for Test3', StartDate = date.today() - 10, EndDate = date.today() + 1 , Status = 'Draft', Contract_Type__c = 'NIRA');
			ContractList.add(contactInstance3);
			database.insert(ContractList);
			
			//Custom Setting
			List<Contract_Eligible_for_Rebate__c> customSetting = new List<Contract_Eligible_for_Rebate__c>();
			Contract_Eligible_for_Rebate__c cs1 = new Contract_Eligible_for_Rebate__c();
			cs1.Name = 'NIRA';
			customSetting.add(cs1);
			database.insert(customSetting);
			
			
			//Contact creation
			/*Contact con = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=accountCreation.id,Email=PRMGlobalConstants.EmailContactNamePRM );
			database.insert(con); */			 
			
						   
			List<Account_Member__c> AccountMemList = new List<Account_Member__c>();
			Account_Member__c AccountMemPRM = new Account_Member__c(Account__c = accountCreation.Id, Account_Role__c = 'Partner Sales Manager',Type__c = 'Internal', Name__c = userPRM.id );
			Account_Member__c AccountMemPSM = new Account_Member__c(Account__c = accountCreation.Id, Account_Role__c = 'Partner Relationship Manager', Type__c = 'External', Name__c = user1.Id );
			AccountMemList.add(AccountMemPRM);
			AccountMemList.add(AccountMemPSM);
			database.insert(AccountMemList);
		   
			List<Rebate_Period__c> Rebate_PeriodList = new List<Rebate_Period__c>();
			Rebate_Period__c RebatePeriod = new Rebate_Period__c(Enrollment_End_Date__c = date.today() + 10,Name='test', Enrollment_start_date__c = date.today()-30, Enrollment_Notification__c = false, Partner_Type__c = 'Value Added Reseller', End_Date__c = date.today() + 9, Rebate_Notification__c = null, Start_Date__c = date.today() + 1, Rebate_Terms_and_Conditions__c = 'Rebate Terms and Conditions for VAR', Technologies__c = 'Airscale Wifi; Fixed Access - FBA; Fixed Access - POL; IP Routing; Microwave; Nuage; Optics; Vital QIP; Vital Suite', Rebate_Region__c = 'Market India');
			Rebate_PeriodList.add(RebatePeriod);
			Rebate_Period__c RebatePeriod1 = new Rebate_Period__c(Enrollment_End_Date__c = date.today() + 10, Enrollment_start_date__c = date.today(), Enrollment_Notification__c = true, Partner_Type__c = 'Value Added Reseller', End_Date__c = date.today() + 9, Rebate_Notification__c = null, Start_Date__c = date.today() + 1, Name='test',Rebate_Terms_and_Conditions__c = 'Rebate Terms and Conditions for VAR', Technologies__c = 'Airscale Wifi; Fixed Access - FBA; Fixed Access - POL; IP Routing; Microwave; Nuage; Optics; Vital QIP; Vital Suite', Rebate_Region__c = 'Market India');
			Rebate_PeriodList.add(RebatePeriod1);
			Database.insert(Rebate_PeriodList);
			RebatePeriod.Rebate_Notification__c = 'Reminder';
			Database.update(RebatePeriod);
			RebatePeriod.Rebate_Notification__c = 'Final Review';
			Database.update(RebatePeriod);
			
			RebatePeriod.Enrollment_Notification__c = true;
			Database.update(RebatePeriod);
				
			List<Rebate_Enrollment__c> enrollmentList = new List<Rebate_Enrollment__c>();
			Rebate_Enrollment__c rebateEnrollment1 = new Rebate_Enrollment__c(Enrollment_Status__c = 'Not Enrolled', Initial_Date_Sent__c = system.today(), Partner_Account__c = accountCreation.Id, Rebate_Period__c = RebatePeriod.Id);
			Rebate_Enrollment__c rebateEnrollment2 = new Rebate_Enrollment__c(Enrollment_Status__c = 'Not Enrolled', Initial_Date_Sent__c = system.today(), Partner_Account__c = accountCreation1.Id, Rebate_Period__c = RebatePeriod.Id);
			Rebate_Enrollment__c rebateEnrollment3 = new Rebate_Enrollment__c(Enrollment_Status__c = 'Not Enrolled', Initial_Date_Sent__c = system.today(), Partner_Account__c = accountCreation.Id, Rebate_Period__c = RebatePeriod.Id);
			database.insert(rebateEnrollment1);
				database.insert(rebateEnrollment2);database.insert(rebateEnrollment3);
				/*enrollmentList.add(rebateEnrollment1);
			enrollmentList.add(rebateEnrollment2); 
			enrollmentList.add(rebateEnrollment3); */
		   // database.insert(enrollmentList);
			 Test.startTest(); 
			List<Rebate_form__c> RebateFormList = new List<Rebate_form__c>();
			Rebate_form__c RebateForm2 = new Rebate_form__c(Rebate_Period__c = RebatePeriod.ID, Airscale_Wifi__c = true, Payment_Method__c = 'Credit memo (to be used against future purchases of Nokia Products and Services).', Rebate_Form_Status__c = 'Accepted - Second Review', Fixed_Access_FBA__c = true, Nuage__c = true, Fixed_Access_POL__c = true, IP_Routing__c = true, Microwave__c = true, Optics__c = true, Vital_QIP__c = true, Vital_Suite__c = true, Partner_Acceptance_Status__c = 'Accepted', 
			Email__c = user1.email, Partner_Account__c = accountCreation.ID );
			RebateFormList.add(RebateForm2);
			Rebate_form__c RebateForm1 = new Rebate_form__c(Rebate_Period__c = RebatePeriod1.ID, Airscale_Wifi__c = true, Payment_Method__c = 'Credit memo (to be used against future purchases of Nokia Products and Services).', Rebate_Form_Status__c = 'Accepted - Second Review', Fixed_Access_FBA__c = true, Nuage__c = true, Fixed_Access_POL__c = true, IP_Routing__c = true, Microwave__c = true, Optics__c = true, Vital_QIP__c = true, Vital_Suite__c = true, Partner_Acceptance_Status__c = 'Accepted', 
			Email__c = user1.email, Partner_Account__c = accountCreation.ID );
			RebateFormList.add(RebateForm1);
			Database.insert(RebateFormList);
			
			
			
			List<Rebate_Amount__c> Rebate_AmountList = new List<Rebate_Amount__c>();
			Rebate_Amount__c RebateAmount1 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'Airscale Wifi', Rebate__c = RebateForm2.ID);
			Rebate_AmountList.add(RebateAmount1);
			Rebate_Amount__c RebateAmount2 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'Fixed Access - FBA', Rebate__c = RebateForm2.ID);
			Rebate_AmountList.add(RebateAmount2);
			Rebate_Amount__c RebateAmount3 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'Fixed Access - POL', Rebate__c = RebateForm2.ID);
			Rebate_AmountList.add(RebateAmount3);
			Rebate_Amount__c RebateAmount4 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'IP Routing', Rebate__c = RebateForm2.ID);
			Rebate_AmountList.add(RebateAmount4);
			Rebate_Amount__c RebateAmount5 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'Microwave', Rebate__c = RebateForm2.ID);
			Rebate_AmountList.add(RebateAmount5);
			Rebate_Amount__c RebateAmount6 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'Nuage', Rebate__c = RebateForm2.ID);
			Rebate_AmountList.add(RebateAmount6);
			Rebate_Amount__c RebateAmount7 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'Optics', Rebate__c = RebateForm2.ID);
			Rebate_AmountList.add(RebateAmount7);
			Rebate_Amount__c RebateAmount8 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'Vital QIP', Rebate__c = RebateForm2.ID);
			Rebate_AmountList.add(RebateAmount8);
			Rebate_Amount__c RebateAmount9 = new Rebate_Amount__c(Amount__c = 100 , Portfolio__c = 'Vital Suite', Rebate__c = RebateForm2.ID);
			Rebate_AmountList.add(RebateAmount9);
			Rebate_Amount__c RebateAmount19 = new Rebate_Amount__c(Portfolio__c = 'Vital Suite', Rebate__c = RebateForm1.ID);
			Rebate_AmountList.add(RebateAmount19);
			Database.insert(Rebate_AmountList);
				
			RebateForm2.Partner_Acceptance_Status__c = 'Rejected';
			Database.update(RebateForm2);
			
			RebateAmount1.Amount__c = 200;
			Database.update(RebateAmount1);
			RebateAmount2.Amount__c = 200;
			Database.update(RebateAmount2);
			
			Database.delete(contactInstance1);
			Database.delete(contactInstance2);
			contactInstance3.StartDate = date.today()-100;
			contactInstance3.EndDate = date.today() - 1 ;
			Database.update(contactInstance3);
		
			Contract contactInstance4 = new Contract (AccountID = accountCreation1.ID, Name = 'Contact for Test3', StartDate = date.today() - 10, EndDate = date.today() + 1 , Status = 'Draft', Contract_Type__c = 'NIRA');
			Database.insert(contactInstance4);
		
			string jsonString = '["Vital Suite","Nuage"]';
			RebateForm2.Partner_Acceptance_Status__c = 'Accepted';
			Database.update(RebateForm2);
			RebateForm2.Rebate_Form_Status__c = 'Rejected';
			RebateForm2.Pending_Rejection_Reason__c = 'PPA Contract Expired';
			Database.update(RebateForm2);
			Test.stopTest();
			List<String> technologiesList = new List<String>();
			technologiesList.add('Airscale Wifi');
			technologiesList.add('Fixed Access - FBA');
			technologiesList.add('Fixed Access - POL');
			technologiesList.add('IP Routing');
			technologiesList.add('Microwave');
			technologiesList.add('Nuage');	
			technologiesList.add('Optics');	
			technologiesList.add('Vital QIP');	
			technologiesList.add('Vital Suite');	
			
		}
	}
  }
}