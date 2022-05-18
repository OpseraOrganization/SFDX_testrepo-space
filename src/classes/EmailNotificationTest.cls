/**
* @description: Test Class to Test Batch and OfferTeamTrigger
* @author:	Accenture IDC.
*
* ============================================================================
* History:
* -------
* * VERSION AUTHOR	DATE		DETAIL			FEATURES/CSR/TTP
* 1.0	26/01/2017   Sprint 4 Doc Stretegy & LoA requirements.
* ============================================================================ 
*/
@isTest
private class EmailNotificationTest {
/**********************************************************************************************************************
* author: Accenture
* Date: 06-July-2017
* Param: 
* Return: 
* Description: Test Method To Send Notification about Support Accept/Decline(Indirect Lead Type)
* High Level Process : 
**********************************************************************************************************************/ 
	 @testSetup static void createTestData() { 
			NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
			cs.Name = 'Default';
			cs.Customer_Account__c = 'Customer - test';
			cs.Customer_Account_Number__c = '12345';
			cs.Customer_User_Profile__c = 'Customers';
			insert cs;
		}
	public static testMethod void sendNotificationTest(){   
	
		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;		
		Contact con = new Contact();
		OpportunityTeamMember otm = new OpportunityTeamMember();
		user user  = new user();
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		system.runAs(runAsUSer[0]){
			//createCustomSetting();
		List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
		Account acc = new Account();
		acc = TestDataFactory.createAccount(1)[0];
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
		acc.Market__c = 'Market India';
		acc.Name = 'STARHUB LIMITED';
		acc.Country__c='India';
		acc.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
		//acc.BillingCountryCode = 'IN';
		insert acc;
		con.LastName  = 'Camilo Vidal';
		//con.Account = acc.Id;
		con.Email = PRMGlobalConstants.TestEmail ;
		//con.CurrencyIsoCode = 'EUR - Euro';
		insert con;
		
		Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=acc.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		database.insert(conPRM);
		User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',		 lastname = 'Testing',
		 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
		 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id );
		database.insert(userPRM);	  
		List<Opportunity> oppty= TestDataFactory.OpportunityCreation(1, acc);
		oppty[0].Lead_Type__c = PRMGlobalConstants.INDIRECT_DEAL_REGISTRATION;
		oppty[0].recordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		oppty[0].PRMSales_Support_Requested__c =true;
		oppty[0].PRMOther_Support_Requested__c  =true;
		oppty[0].PRMPricing_Support_Requested__c  =true;
		oppty[0].PRMTechnical_Support_Requested__c = true;
		oppty[0]. Account_Role__c = 'NFS-SPaaP';
		oppty[0]. End_Customer_Information__c = 'Multiple End Customer';
		oppty[0].Multiple_or_Unknown_EC_Activity_Sector__c = 'CABL - CABLE OPERATORS';
		oppty[0].Multiple_or_Unknown_EC_Country__c = 'Test';
		oppty[0].Multiple_or_Unknown_EC_Market_Segment__c = 'CABLE';
		oppty[0].PRMPartner_User_Name__c = userPRM.Id;
		Test.StartTest();
		insert oppty;
		user = TestDataFactory.userCreation(1,PRMGlobalConstants.SYSTEM_ADMINISTRATOR)[0];
		insert user;
		otm = TestDataFactory.optyTeamMemberCreation(1,user,oppty[0])[0];
		insert otm;
		List<OpportunityTeamMember> otmlist =  new List<OpportunityTeamMember>();
		otmlist.add(otm);
		EmailNotification.sendMailsOnOtherSupportRequestDeclined(new List<Id>(),oppty[0],otmlist);
		test.StopTest();		
	}
	}
	public static testMethod void sendNotificationOnOtherSupportTest(){   
	 
		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;
		Contact con = new Contact();
		OpportunityTeamMember otm = new OpportunityTeamMember();
		user user  = new user();
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		system.runAs(runAsUSer[0]){
	//createCustomSetting();
		List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
			Account acc = new Account();
		acc = TestDataFactory.createAccount(1)[0];
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
		acc.Market__c = 'Market India';
		acc.Name = 'STARHUB LIMITED';
		acc.Country__c='India';
		acc.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
		//acc.BillingCountryCode = 'IN';
		insert acc;
		con.LastName  = 'Camilo Vidal';
		//con.Account = acc.Id;
		con.Email = PRMGlobalConstants.TestEmail ;
		//con.CurrencyIsoCode = 'EUR - Euro';
		insert con;
		Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=acc.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		database.insert(conPRM);
		User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',		 lastname = 'Testing',
		 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
		 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id );
		 
		
		database.insert(userPRM);
		List<User> userList = new List<User>();
		userList.add(userPRM);
		//addded om 09/08 to support scrm enhancement related to file func on oppty
		List<Opportunity> oppty= TestDataFactory.OpportunityCreation(1, acc);
		oppty[0].Lead_Type__c = PRMGlobalConstants.INDIRECT_DEAL_REGISTRATION;
		oppty[0].recordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		oppty[0].PRMSales_Support_Requested__c =true;
		oppty[0].PRMOther_Support_Requested__c  =true;
		oppty[0].PRMPricing_Support_Requested__c  =true;
		oppty[0].PRMTechnical_Support_Requested__c = true;
		oppty[0]. Account_Role__c = 'NFS-SPaaP';
		oppty[0]. End_Customer_Information__c = 'Multiple End Customer';
		oppty[0].Multiple_or_Unknown_EC_Activity_Sector__c = 'CABL - CABLE OPERATORS';
		oppty[0].Multiple_or_Unknown_EC_Country__c = 'Test';
		oppty[0].Multiple_or_Unknown_EC_Market_Segment__c = 'CABLE';
		oppty[0].PRMPartner_User_Name__c = userPRM.Id;
		 test.startTest();
		insert oppty;
		user = TestDataFactory.userCreation(1,PRMGlobalConstants.SYSTEM_ADMINISTRATOR)[0];
		insert user;
		otm = TestDataFactory.optyTeamMemberCreation(1,user,oppty[0])[0];
		insert otm;
		 List<OpportunityTeamMember> otmList = new List<OpportunityTeamMember>();
	otmList.add(otm);
		EmailNotification.sendMailsOnOtherSupportRequestApproved(new List<Id>(),oppty[0],otmList);
		EmailNotification.sendMailsOnSupportRequestApproved(new List<Id>(),oppty[0],otmList);
		EmailNotification.sendMailsOnPricingSupportRequestApproved(new List<Id>(),oppty[0],otmList);
		EmailNotification.sendMailsOnPricingSupportRequestDeclined(new List<Id>(),oppty[0],otmList);
		EmailNotification.sendMailsOnTechnicalSupportRequestDeclined(new List<Id>(),oppty[0],otmList);
		test.StopTest();
	}
	}
	public static testMethod void sendNotificationOnPricingSupportTest(){   
		
		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;
		Contact con = new Contact();
		OpportunityTeamMember otm = new OpportunityTeamMember();
		
		user user  = new user();
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		system.runAs(runAsUSer[0]){
	//createCustomSetting();
		List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
			Account acc = new Account();
		acc = TestDataFactory.createAccount(1)[0];
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
		acc.Market__c = 'Market India';
		acc.Name = 'STARHUB LIMITED';
		acc.Country__c='India';
		acc.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
		//acc.BillingCountryCode = 'IN';
		insert acc;
		con.LastName  = 'Camilo Vidal';
		//con.Account = acc.Id;
		con.Email = PRMGlobalConstants.TestEmail ;
		//con.CurrencyIsoCode = 'EUR - Euro';
		insert con;
		Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=acc.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		database.insert(conPRM);
		User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',		 lastname = 'Testing',
		 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
		 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id );
		database.insert(userPRM);
		List<User> userList = new List<User>();
		userList.add(userPRM);
		List<Opportunity> oppty= TestDataFactory.OpportunityCreation(1, acc);
		oppty[0].Lead_Type__c = PRMGlobalConstants.INDIRECT_DEAL_REGISTRATION;
		oppty[0].recordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		oppty[0].PRMSales_Support_Requested__c =true;
		oppty[0].PRMOther_Support_Requested__c  =true;
		oppty[0].PRMPricing_Support_Requested__c  =true;
		oppty[0].PRMTechnical_Support_Requested__c = true;
		oppty[0]. Account_Role__c = 'NFS-SPaaP';
		oppty[0]. End_Customer_Information__c = 'Multiple End Customer';
		oppty[0].Multiple_or_Unknown_EC_Activity_Sector__c = 'CABL - CABLE OPERATORS';
		oppty[0].Multiple_or_Unknown_EC_Country__c = 'Test';
		oppty[0].Multiple_or_Unknown_EC_Market_Segment__c = 'CABLE';
		oppty[0].PRMPartner_User_Name__c = userPRM.Id;
		Test.StartTest();
		insert oppty;
	
		user = TestDataFactory.userCreation(1,PRMGlobalConstants.SYSTEM_ADMINISTRATOR)[0];
		insert user;
		otm = TestDataFactory.optyTeamMemberCreation(1,user,oppty[0])[0];
		
		insert otm;
		List<OpportunityTeamMember> otmlist = new List<OpportunityTeamMember>();
		otmlist.add(otm);
		

		
		EmailNotification.sendMailsOnSupportRequestDeclined(new List<Id>(),oppty[0],otmlist);
		EmailNotification.sendMailsOnOtherSupportRequestDeclined(new List<Id>(),oppty[0],otmlist);
		Test.StopTest();
	}
	}
   /* public static testMethod void sendNotificationTechnicalSupportTest(){   
		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;
		Contact con = new Contact();
		OpportunityTeamMember otm = new OpportunityTeamMember();
		user user  = new user();
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		system.runAs(runAsUSer[0]){
	//createCustomSetting();
		List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
			Account acc = new Account();
		acc = TestDataFactory.createAccount(1)[0];
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
		acc.Market__c = 'Market India';
		acc.Name = 'STARHUB LIMITED';
		acc.Country__c='India';
		acc.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
		//acc.BillingCountryCode = 'IN';
		insert acc;
		con.LastName  = 'Camilo Vidal';
		//con.Account = acc.Id;
		con.Email = PRMGlobalConstants.TestEmail ;
		//con.CurrencyIsoCode = 'EUR - Euro';
		insert con;
		Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=acc.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		database.insert(conPRM);
		User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' *//*, emailencodingkey = 'UTF-8', firstName = 'test',		 lastname = 'Testing',
		languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
		 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id );
		database.insert(userPRM);
		List<User> userList = new List<User>();
		userList.add(userPRM);
		List<Opportunity> oppty= TestDataFactory.OpportunityCreation(1, acc);
		oppty[0].Lead_Type__c = PRMGlobalConstants.INDIRECT_DEAL_REGISTRATION;
		oppty[0].recordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		oppty[0].PRMSales_Support_Requested__c =true;
		oppty[0].PRMOther_Support_Requested__c  =true;
		oppty[0].PRMPricing_Support_Requested__c  =true;
		oppty[0].PRMTechnical_Support_Requested__c = true;
		oppty[0].PRMPartner_User_Name__c = userPRM.Id;
		insert oppty;
		user = TestDataFactory.userCreation(1,PRMGlobalConstants.SYSTEM_ADMINISTRATOR)[0];
		insert user;
		otm = TestDataFactory.optyTeamMemberCreation(1,user,oppty[0])[0];
		
		insert otm;

		oppty[0].PRMSales_Support_Status__c   =PRMGlobalConstants.Declined;
		oppty[0].PRMTechnical_Support_Status__c	=PRMGlobalConstants.Accepted;
		Test.startTest();
		update oppty;
		Test.StopTest();
	}
	} */
	 static testMethod void sendMailsTest(){
		
	String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;
		Contact con = new Contact();
		 List<Id> listid = new List<Id> ();
		OpportunityTeamMember otm = new OpportunityTeamMember();
		 List <OpportunityTeamMember> otmlist = new List<OpportunityTeamMember>();
		Map<id,String> userIdToNameMap = New Map<id,String>();
		user user  = new user();
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		system.runAs(runAsUSer[0]){
	//createCustomSetting();
		List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
			Account acc = new Account();
		acc = TestDataFactory.createAccount(1)[0];
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
		acc.Market__c = 'Market India';
		acc.Name = 'STARHUB LIMITED';
		acc.Country__c='India';
		acc.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
		//acc.BillingCountryCode = 'IN';
		insert acc;
		con.LastName  = 'Camilo Vidal';
		//con.Account = acc.Id;
		con.Email = PRMGlobalConstants.TestEmail ;
		//con.CurrencyIsoCode = 'EUR - Euro';
		insert con;
		Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=acc.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		database.insert(conPRM);
		User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',		 lastname = 'Testing',
		 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
		 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id );
		database.insert(userPRM);
		List<User> userList = new List<User>();
		userList.add(userPRM);
		userIdToNameMap.put(userPRM.id, userPRM.firstName);
		List<Opportunity> oppty= TestDataFactory.OpportunityCreation(1, acc);
		oppty[0].Lead_Type__c = PRMGlobalConstants.INDIRECT_DEAL_REGISTRATION;
		oppty[0].recordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		oppty[0].PRMSales_Support_Requested__c =true;
		oppty[0].PRMOther_Support_Requested__c  =true;
		oppty[0].PRMPricing_Support_Requested__c  =true;
		oppty[0].PRMTechnical_Support_Requested__c = true;
		oppty[0]. Account_Role__c = 'NFS-SPaaP';
		oppty[0]. End_Customer_Information__c = 'Multiple End Customer';
		oppty[0].Multiple_or_Unknown_EC_Activity_Sector__c = 'CABL - CABLE OPERATORS';
		oppty[0].Multiple_or_Unknown_EC_Country__c = 'Test';
		oppty[0].Multiple_or_Unknown_EC_Market_Segment__c = 'CABLE';
		oppty[0].PRMPartner_User_Name__c = userPRM.Id;
		test.startTest();
		insert oppty;
		user = TestDataFactory.userCreation(1,PRMGlobalConstants.SYSTEM_ADMINISTRATOR)[0];
		insert user;
			
		otm = TestDataFactory.optyTeamMemberCreation(1,user,oppty[0])[0];
		insert otm;
		//oppty[0].PRMSales_Support_Status__c   =PRMGlobalConstants.Declined;
		//oppty[0].PRMTechnical_Support_Status__c	=PRMGlobalConstants.Accepted;
		
		 
		//update oppty;
	
		listid.add(userPRM.id);
		otmlist.add(otm);
		EmailNotification.sendMails(listid, oppty[0], otmlist, userIdToNameMap);
		test.StopTest();
	}
	 }  
		 static testMethod void sendMailsToPRMTest(){
		
	String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;
		Contact con = new Contact();
		List<Id> listid = new List<Id> ();
		OpportunityTeamMember otm = new OpportunityTeamMember();
		rebate_period__c rebateper = new rebate_period__c();
		 rebateper.Name = 'Test1';
		 rebateper.Start_Date__c = system.today();
		 rebateper.End_Date__c = system.today() + 90;
		 rebateper.Enrollment_start_date__c = system.today();
		 rebateper.Enrollment_End_Date__c = system.today() + 90;
		 rebateper.Rebate_Terms_and_Conditions__c = 'test123';
		 rebateper.Technologies__c = 'Fixed Access - FBA';
		 rebateper.Partner_Type__c = 'Indirect Reseller';
		List <OpportunityTeamMember> otmlist = new List<OpportunityTeamMember>();
		Map<id,String> userIdToNameMap = New Map<id,String>();
		user user  = new user();
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'Data Loader Profile');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		system.runAs(runAsUSer[0]){
	//createCustomSetting();
		List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
			Account acc = new Account();
		acc = TestDataFactory.createAccount(1)[0];
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
		acc.Market__c = 'Market India';
		acc.Name = 'STARHUB LIMITED';
		acc.Country__c='India';
		acc.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
		//acc.BillingCountryCode = 'IN';
		insert acc;
		List<Account_Member__c> accountMemberList = new List<Account_Member__c>();
		Account_Member__c accmem = new Account_Member__c();
		accmem.Account__c = acc.id;
		insert accmem;
		
		con.LastName  = 'Camilo Vidal';
		//con.Account = acc.Id;
		con.Email = PRMGlobalConstants.TestEmail ;
		//con.CurrencyIsoCode = 'EUR - Euro';
		insert con;
		Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=acc.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		database.insert(conPRM);
		User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',		 lastname = 'Testing',
		 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
		 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id );
		database.insert(userPRM);
		List<User> userList = new List<User>();
		userList.add(userPRM);
		userIdToNameMap.put(userPRM.id, userPRM.firstName);
		List<Opportunity> oppty= TestDataFactory.OpportunityCreation(1, acc);
		oppty[0].Lead_Type__c = PRMGlobalConstants.INDIRECT_DEAL_REGISTRATION;
		oppty[0].recordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		oppty[0].PRMSales_Support_Requested__c =true;
		oppty[0].PRMOther_Support_Requested__c  =true;
		oppty[0].PRMPricing_Support_Requested__c  =true;
		oppty[0].PRMTechnical_Support_Requested__c = true;
		oppty[0].PRMPartner_User_Name__c = userPRM.Id;
		insert oppty;
		user = TestDataFactory.userCreation(1,PRMGlobalConstants.SYSTEM_ADMINISTRATOR)[0];
		insert user;
		otm = TestDataFactory.optyTeamMemberCreation(1,user,oppty[0])[0];
		insert otm;
		oppty[0].PRMSales_Support_Status__c   =PRMGlobalConstants.Declined;
		oppty[0].PRMTechnical_Support_Status__c	=PRMGlobalConstants.Accepted;
		test.startTest();
		update oppty;
		
		listid.add(userPRM.id);
		otmlist.add(otm);
		accountMemberList.add(accmem);
		EmailNotification.sendMailsToPRM(accountMemberList, rebateper);
		EmailNotification.sendMailReminders(accountMemberList, rebateper);
			test.StopTest();
	}
   
   
	}
	
		static testMethod void sendMailsOnRebateSubmissionTest(){
		
	String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;
		Contact con = new Contact();
		List<Id> listid = new List<Id> ();
		OpportunityTeamMember otm = new OpportunityTeamMember();
	
		List <OpportunityTeamMember> otmlist = new List<OpportunityTeamMember>();
		Map<id,String> userIdToNameMap = New Map<id,String>();
		user user  = new user();
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'Data Loader Profile');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		system.runAs(runAsUSer[0]){
	//createCustomSetting();
		List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
			Account acc = new Account();
		acc = TestDataFactory.createAccount(1)[0];
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
		acc.Market__c = 'Market India';
		acc.Name = 'STARHUB LIMITED';
		acc.Country__c='India';
		acc.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
		//acc.BillingCountryCode = 'IN';
		insert acc;
		List<Account_Member__c> accountMemberList = new List<Account_Member__c>();
		Account_Member__c accmem = new Account_Member__c();
		accmem.Account__c = acc.id;
		insert accmem;
		rebate_form__c rebateform = new rebate_form__c();
		rebateform.Partner_Account__c = acc.id;
		insert rebateform;
		con.LastName  = 'Camilo Vidal';
		//con.Account = acc.Id;
		con.Email = PRMGlobalConstants.TestEmail ;
		//con.CurrencyIsoCode = 'EUR - Euro';
		insert con;
		Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=acc.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		database.insert(conPRM);
		User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',		 lastname = 'Testing',
		 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
		 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id );
		database.insert(userPRM);
		List<User> userList = new List<User>();
		userList.add(userPRM);
		userIdToNameMap.put(userPRM.id, userPRM.firstName);
		List<Opportunity> oppty= TestDataFactory.OpportunityCreation(1, acc);
		oppty[0].Lead_Type__c = PRMGlobalConstants.INDIRECT_DEAL_REGISTRATION;
		oppty[0].recordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		oppty[0].PRMSales_Support_Requested__c =true;
		oppty[0].PRMOther_Support_Requested__c  =true;
		oppty[0].PRMPricing_Support_Requested__c  =true;
		oppty[0].PRMTechnical_Support_Requested__c = true;
		oppty[0].PRMPartner_User_Name__c = userPRM.Id;
		insert oppty;
		user = TestDataFactory.userCreation(1,PRMGlobalConstants.SYSTEM_ADMINISTRATOR)[0];
		insert user;
		otm = TestDataFactory.optyTeamMemberCreation(1,user,oppty[0])[0];
		insert otm;
		oppty[0].PRMSales_Support_Status__c   =PRMGlobalConstants.Declined;
		oppty[0].PRMTechnical_Support_Status__c	=PRMGlobalConstants.Accepted;
		test.startTest();
		update oppty;
		
		listid.add(userPRM.id);
		otmlist.add(otm);
		accountMemberList.add(accmem);
		EmailNotification.sendMailsOnRebateSubmission(accountMemberList, rebateform);
			test.StopTest();
	}
  }
	
	static testMethod void sendMailsOnRejectionTest(){
		
	String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;
		Contact con = new Contact();
		List<Id> listid = new List<Id> ();
		OpportunityTeamMember otm = new OpportunityTeamMember();
	
		List <OpportunityTeamMember> otmlist = new List<OpportunityTeamMember>();
		Map<id,String> userIdToNameMap = New Map<id,String>();
		user user  = new user();
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'Data Loader Profile');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		system.runAs(runAsUSer[0]){
	//createCustomSetting();
		List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
			Account acc = new Account();
		acc = TestDataFactory.createAccount(1)[0];
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
		acc.Market__c = 'Market India';
		acc.Name = 'STARHUB LIMITED';
		acc.Country__c='India';
		acc.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
		//acc.BillingCountryCode = 'IN';
		insert acc;
		List<Account_Member__c> accountMemberList = new List<Account_Member__c>();
		Account_Member__c accmem = new Account_Member__c();
		accmem.Account__c = acc.id;
		insert accmem;
		rebate_form__c rebateform = new rebate_form__c();
		rebateform.Partner_Account__c = acc.id;
		insert rebateform;
		con.LastName  = 'Camilo Vidal';
		//con.Account = acc.Id;
		con.Email = PRMGlobalConstants.TestEmail ;
		//con.CurrencyIsoCode = 'EUR - Euro';
		insert con;
		Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=acc.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		database.insert(conPRM);
		User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',		 lastname = 'Testing',
		 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
		 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id );
		database.insert(userPRM);
		List<User> userList = new List<User>();
		userList.add(userPRM);
		userIdToNameMap.put(userPRM.id, userPRM.firstName);
		List<Opportunity> oppty= TestDataFactory.OpportunityCreation(1, acc);
		oppty[0].Lead_Type__c = PRMGlobalConstants.INDIRECT_DEAL_REGISTRATION;
		oppty[0].recordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		oppty[0].PRMSales_Support_Requested__c =true;
		oppty[0].PRMOther_Support_Requested__c  =true;
		oppty[0].PRMPricing_Support_Requested__c  =true;
		oppty[0].PRMTechnical_Support_Requested__c = true;
		oppty[0].PRMPartner_User_Name__c = userPRM.Id;
		insert oppty;
		user = TestDataFactory.userCreation(1,PRMGlobalConstants.SYSTEM_ADMINISTRATOR)[0];
		insert user;
		otm = TestDataFactory.optyTeamMemberCreation(1,user,oppty[0])[0];
		insert otm;
		oppty[0].PRMSales_Support_Status__c   =PRMGlobalConstants.Declined;
		oppty[0].PRMTechnical_Support_Status__c	=PRMGlobalConstants.Accepted;
		test.startTest();
		update oppty;
		
		listid.add(userPRM.id);
		otmlist.add(otm);
		accountMemberList.add(accmem);
		EmailNotification.sendMailsOnRejection(accountMemberList, rebateform);
		EmailNotification.sendEmailOnRejectionRebate(accountMemberList, rebateform);
		EmailNotification.sendMailsForAmountFilling(accountMemberList, rebateform);
			test.StopTest();
	}
  }  
	  static testMethod void sendMailforMissingAccreditationTest(){
		
	String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;
		Contact con = new Contact();
		List<Id> listid = new List<Id> ();
		OpportunityTeamMember otm = new OpportunityTeamMember();
	
		List <OpportunityTeamMember> otmlist = new List<OpportunityTeamMember>();
		Map<id,String> userIdToNameMap = New Map<id,String>();
		map<id,Rebate_form__c> accToRebateMap = new Map<id,Rebate_form__c>();
		user user  = new user();
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		system.runAs(runAsUSer[0]){
	//createCustomSetting();
		List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
			List<Account> Acclist = new List<Account> ();
			Account acc = new Account();
		acc = TestDataFactory.createAccount(1)[0];
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
		acc.Market__c = 'Market India';
		acc.Name = 'STARHUB LIMITED';
		acc.Country__c='India';
		acc.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
		//acc.BillingCountryCode = 'IN';
		insert acc;
		List<Account_Member__c> accountMemberList = new List<Account_Member__c>();
		Account_Member__c accmem = new Account_Member__c();
		accmem.Account__c = acc.id;
		insert accmem;
		rebate_form__c rebateform = new rebate_form__c();
		rebateform.Partner_Account__c = acc.id;
		insert rebateform;
		con.LastName  = 'Camilo Vidal';
		//con.Account = acc.Id;
		con.Email = PRMGlobalConstants.TestEmail ;
		//con.CurrencyIsoCode = 'EUR - Euro';
		test.startTest();
			insert con;
		Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=acc.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		database.insert(conPRM);
		User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',		 lastname = 'Testing',
		 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
		 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id );
		database.insert(userPRM);
		List<User> userList = new List<User>();
		userList.add(userPRM);
		userIdToNameMap.put(userPRM.id, userPRM.firstName);
		accToRebateMap.put(acc.id, rebateform );
	
		test.StopTest();
		accountMemberList.add(accmem);
		Acclist.add(acc); 
		EmailNotification.sendMailforMissingAccreditation(Acclist, accToRebateMap);
		EmailNotification.sendMailforNoAccreditation(Acclist, accToRebateMap);
		EmailNotification.sendMailsForExpiredContract(accountMemberList, accToRebateMap);
	}
  }
	  static testMethod void sendMailsForBusinessPlanningTest(){
		
	String orgId = UserInfo.getOrganizationId();
		String subject = ('test1');
		String emailBody = ('abcd');
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;
		Contact con = new Contact();
		List<Id> listid = new List<Id> ();
		OpportunityTeamMember otm = new OpportunityTeamMember();
		List <OpportunityTeamMember> otmlist = new List<OpportunityTeamMember>();
		Map<id,String> userIdToNameMap = New Map<id,String>();
		user user  = new user();
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'Data Loader Profile');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		system.runAs(runAsUSer[0]){
	//createCustomSetting();
		List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
			Account acc = new Account();
		acc = TestDataFactory.createAccount(1)[0];
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
		acc.Market__c = 'Market India';
		acc.Name = 'STARHUB LIMITED';
		acc.Country__c='India';
		acc.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
		//acc.BillingCountryCode = 'IN';
		insert acc;
		List<Account_Member__c> accountMemberList = new List<Account_Member__c>();
		Account_Member__c accmem = new Account_Member__c();
		accmem.Account__c = acc.id;
		insert accmem;
		
		con.LastName  = 'Camilo Vidal';
		//con.Account = acc.Id;
		con.Email = PRMGlobalConstants.TestEmail ;
		//con.CurrencyIsoCode = 'EUR - Euro';
		insert con;
		Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=acc.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		database.insert(conPRM);
		User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',		 lastname = 'Testing',
		 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
		 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id );
		database.insert(userPRM);
		List<User> userList = new List<User>();
		userList.add(userPRM);
		userIdToNameMap.put(userPRM.id, userPRM.firstName);
		List<Opportunity> oppty= TestDataFactory.OpportunityCreation(1, acc);
		oppty[0].Lead_Type__c = PRMGlobalConstants.INDIRECT_DEAL_REGISTRATION;
		oppty[0].recordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		oppty[0].PRMSales_Support_Requested__c =true;
		oppty[0].PRMOther_Support_Requested__c  =true;
		oppty[0].PRMPricing_Support_Requested__c  =true;
		oppty[0].PRMTechnical_Support_Requested__c = true;
		oppty[0].PRMPartner_User_Name__c = userPRM.Id;
		insert oppty;
		user = TestDataFactory.userCreation(1,PRMGlobalConstants.SYSTEM_ADMINISTRATOR)[0];
		insert user;
		otm = TestDataFactory.optyTeamMemberCreation(1,user,oppty[0])[0];
		insert otm;
		oppty[0].PRMSales_Support_Status__c   =PRMGlobalConstants.Declined;
		oppty[0].PRMTechnical_Support_Status__c	=PRMGlobalConstants.Accepted;
		test.startTest();
		update oppty;
	
		listid.add(userPRM.id);
		otmlist.add(otm);
		accountMemberList.add(accmem);
		EmailNotification.sendMailsForBusinessPlanning(accountMemberList,subject,emailBody);
		test.StopTest();
	}
  }
	
	  static testMethod void sendMailforUploadAllocationTest(){
		
	String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;
		Contact con = new Contact();
		List<Id> listid = new List<Id> ();
		Co_Op_Allocation__c alloc = new Co_Op_Allocation__c();
		List<Co_Op_Allocation__c> allocationList = new List<Co_Op_Allocation__c>();
		Map<id,List<String>> acctoUserMap = new Map<id,List<String>>();
		Map<id,String> userIdToNameMap = New Map<id,String>();
		user user  = new user();
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		system.runAs(runAsUSer[0]){
	//createCustomSetting();
		List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
			Account acc = new Account();
		acc = TestDataFactory.createAccount(1)[0];
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
		acc.Market__c = 'Market India';
		acc.Name = 'STARHUB LIMITED';
		acc.Country__c='India';
		acc.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
		//acc.BillingCountryCode = 'IN';
		
		insert acc;
		List<Account_Member__c> accountMemberList = new List<Account_Member__c>();
		Account_Member__c accmem = new Account_Member__c();
		accmem.Account__c = acc.id;
		insert accmem;
		
		con.LastName  = 'Camilo Vidal';
		//con.Account = acc.Id;
		con.Email = PRMGlobalConstants.TestEmail ;
		//con.CurrencyIsoCode = 'EUR - Euro';
		
		insert con;
		Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=acc.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		
		database.insert(conPRM);
		User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',		 lastname = 'Testing',
		 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
		 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id );
		database.insert(userPRM);
		List<User> userList = new List<User>();
		 
		userList.add(userPRM);
		userIdToNameMap.put(userPRM.id, userPRM.firstName);
		user = TestDataFactory.userCreation(1,PRMGlobalConstants.SYSTEM_ADMINISTRATOR)[0];
		 test.startTest();
		insert user;
			List<Fund__c> fundList = new List<Fund__c>();
			Fund__c fund1 = new Fund__c(Name = 'abcd', Partner_Name__c = acc.id);
			fundList.add(fund1);
			insert fundList;
			Co_Op_Allocation__c allocation1 = new Co_Op_Allocation__c(Fund_Id__c = fund1.id,Co_Op_Allocation_Amount__c = 400.00,Transfers_in_Amount__c = 100.00,Transfers_out_Amount__c = 50.00, Status__c = 'Active',CurrencyIsoCode='EUR',Allocation_Month__c='May',Allocation_Year__c='2015',Days_to_expire__c = '30 DAY');
			Co_Op_Allocation__c allocation3 = new Co_Op_Allocation__c(Fund_Id__c = fund1.id,Co_Op_Allocation_Amount__c = 400.00,Transfers_in_Amount__c = 100.00,Transfers_out_Amount__c = 50.00, Status__c = 'Active',CurrencyIsoCode='EUR',Allocation_Month__c='May',Allocation_Year__c='',Days_to_expire__c = '15 DAY');
			Co_Op_Allocation__c allocation4 = new Co_Op_Allocation__c(Fund_Id__c = fund1.id,Co_Op_Allocation_Amount__c = 400.00,Transfers_in_Amount__c = 100.00,Transfers_out_Amount__c = 50.00, Status__c = 'Active',CurrencyIsoCode='EUR',Allocation_Month__c='May',Allocation_Year__c='2016',Days_to_expire__c = '30 DAY');
			Co_Op_Allocation__c allocation5 = new Co_Op_Allocation__c(Fund_Id__c = fund1.id,Co_Op_Allocation_Amount__c = 400.00,Transfers_in_Amount__c = 100.00,Transfers_out_Amount__c = 50.00, Status__c = 'Expired',CurrencyIsoCode='EUR',Allocation_Month__c='May',Allocation_Year__c='',Days_to_expire__c = '30 DAY');
			allocationList.add(allocation1);
			allocationList.add(allocation3);
			allocationList.add(allocation4);
			allocationList.add(allocation5);
			insert allocationList;
	
		
		EmailNotification.sendMailforUploadAllocation(allocationList,acctoUserMap);
		EmailNotification.sendMailforexpirenotification(allocationList,acctoUserMap);
	test.StopTest();
	}
 }
	
	
	
	
	
	/*public static void createCustomSetting()
	{
		ISO_Country_Codes__c isoCode = new ISO_Country_Codes__c();
		isoCode.Name = 'IN';
		isoCode.Country_Name__c='India';
		isoCode.Market__c='Market India';
		insert isoCode;
	}*/
	 
}