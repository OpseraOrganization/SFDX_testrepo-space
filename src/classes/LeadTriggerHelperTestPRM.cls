/*Lead Trigger Test Class*/
@IsTest
public class LeadTriggerHelperTestPRM {
  /* This is a basic test method for MakeRejectCommentsMandatory */
	
   //create Test Data
   /*
	@testSetup static void createTestData() {
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		accountCreation.AccountNumber = '1234'; 
		database.insert(accountCreation);
		List <Contact> lstCont = new List<Contact>();
		Contact con = new Contact(lastName=PRMGlobalConstants.Testtext,AccountId=accountCreation.id,Email=PRMGlobalConstants.TestEmail1 );
		lstCont.add(con);
		
		Contact con2 = new Contact(lastName=PRMGlobalConstants.Test2,AccountId=accountCreation.id,Email=PRMGlobalConstants.TestEmail2 );
		lstCont.add(con2);
		Contact con3 = new Contact(lastName=PRMGlobalConstants.Test3,AccountId=accountCreation.id,Email=PRMGlobalConstants.TestEmail3 );
		lstCont.add(con3);
		Contact con4 = new Contact(lastName=PRMGlobalConstants.Test4,AccountId=accountCreation.id,Email=PRMGlobalConstants.TestEmail4 );
		lstCont.add(con4);
		Database.insert(lstCont);
		
		List<Partner_Company__c> pcList = new List<Partner_Company__c>();
		Partner_Company__c pc1 = new Partner_Company__c();
		pc1.Partner_Name__c = accountCreation.id;
		pc1.Country_Headquarters__c = 'Albania';
		pc1.Market__c = 'Market Asia Pacific and Japan';
		pc1.Partner_Type__c = 'Distributor';
		pcList.add(pc1);
		Partner_Company__c pc2 = new Partner_Company__c();
		pc2.Partner_Name__c = accountCreation.id;
		pc2.Country_Headquarters__c = 'Albania';
		pc2.Market__c = 'Market Asia Pacific and Japan';
		pc2.Partner_Type__c = 'Indirect Reseller';
		pcList.add(pc2);
		Database.insert(pcList);
		
		List<Lead> leadList = new  List<Lead>();
		leadList = TestDataFactory.createLead(1);
		leadList[0].RecordTypeId  = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Indirect Deal Registration').getRecordTypeId();
		leadList[0].email = 'test.junrel@lead.com';
		leadList[0].Rejection_Status_For_Approval__c = 'Pending';
	   // leadList[0].Status = PRMGlobalConstants.REJECTED_STATUS;
		leadList[0].Indirect_Reseller_Company__c = pcList.get(1).Id;
		leadList[0].Distributor_Partner_Company__c  = pcList.get(0).Id;
		insert leadList; 
	}
	*/
		 @testSetup static void createTestData() {
			NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
			cs.Name = 'Default';
			cs.Customer_Account__c = 'Customer - test';
			cs.Customer_Account_Number__c = '12345';
			cs.Customer_User_Profile__c = 'Customers';
			insert cs;
		}
	private static testMethod void MakeCommentsMandatoryRejectedDeal() {
		User sysAdminUser = TestDataFactory.createSystemAdminUser();
		System.runAs(sysAdminUser){
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		accountCreation.AccountNumber = '1234'; 
		database.insert(accountCreation);
		List <Contact> lstCont = new List<Contact>();
		Contact con = new Contact(lastName=PRMGlobalConstants.Testtext,AccountId=accountCreation.id,Email=PRMGlobalConstants.TestEmail1 );
		lstCont.add(con);
		
		Contact con2 = new Contact(lastName=PRMGlobalConstants.Test2,AccountId=accountCreation.id,Email=PRMGlobalConstants.TestEmail2 );
		lstCont.add(con2);
		Contact con3 = new Contact(lastName=PRMGlobalConstants.Test3,AccountId=accountCreation.id,Email=PRMGlobalConstants.TestEmail3 );
		lstCont.add(con3);
		Contact con4 = new Contact(lastName=PRMGlobalConstants.Test4,AccountId=accountCreation.id,Email=PRMGlobalConstants.TestEmail4 );
		lstCont.add(con4);
		Database.insert(lstCont);
		
		List<Partner_Company__c> pcList = new List<Partner_Company__c>();
		Partner_Company__c pc1 = new Partner_Company__c();
		pc1.Partner_Name__c = accountCreation.id;
		pc1.Country_Headquarters__c = 'Albania';
		pc1.Market__c = 'Market Asia Pacific & Japan';
		pc1.Partner_Type__c = 'Distributor';
		pcList.add(pc1);
		Partner_Company__c pc2 = new Partner_Company__c();
		pc2.Partner_Name__c = accountCreation.id;
		pc2.Country_Headquarters__c = 'Albania';
		pc2.Market__c = 'Market Asia Pacific & Japan';
		pc2.Partner_Type__c = 'Indirect Reseller';
		pcList.add(pc2);
		Database.insert(pcList);
		
		List<Lead> leadList1 = new  List<Lead>();
		leadList1 = TestDataFactory.createLead(1);
		leadList1[0].RecordTypeId  = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Indirect Deal Registration').getRecordTypeId();
		leadList1[0].email = 'test1.junrel@lead.com';
		leadList1[0].Rejection_Status_For_Approval__c = 'Pending';
		leadList1[0].Status = PRMGlobalConstants.REJECTED_STATUS;
		leadList1[0].Indirect_Reseller_Company__c = pcList.get(1).Id;
		leadList1[0].Distributor_Partner_Company__c  = pcList.get(0).Id;
		leadList1[0].Rejection_Description__c = '';
		leadList1[0].Partner_Rejection_Reason__c = 'Rejected Please Approve';
		leadList1[0].G2_Planned_Date__c= system.today();
		leadList1[0].G3_Planned_Date__c= system.today();
		leadList1[0].G4_Approval_Date__c= system.today();
		leadList1[0].G5_Planned_Date__c= system.today();
		leadList1[0].G6_Planned_Date__c= system.today();
		leadList1[0].Rejection_Reason__c = 'Deal lost';
		insert leadList1; 
		Test.startTest();
		
		leadList1[0].Status = PRMGlobalConstants.PendingApproval;
		leadList1[0].Description = 'Please Approve';
		leadList1[0].Rejection_Reason__c = 'Deal lost';
		
		update leadList1;
		Test.stopTest();
	}

		}
		
		
		
  /* This is a basic test method for Lead share */
	
   //create Test Data
	private static testMethod void afterInsertLeadShareTest() {
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		system.runAs(runAsUSer[0]){
		Test.startTest();
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		database.insert(accountCreation);
		
		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;
		
		Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=accountCreation.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		database.insert(conPRM);
		User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',						   lastname = 'Testing',
								 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Profile_Id,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
								 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id );
		database.insert(userPRM);
	   
		Account_Member__c AccountMem = new Account_Member__c(Account__c = accountCreation.Id, Account_Role__c = 'Partner Relationship Manager', 
											Type__c = 'External', Name__c = userPRM.Id );
		 
		List <Contact> lstCont = new List<Contact>();
		Contact con = new Contact(lastName=PRMGlobalConstants.Testtext,AccountId=accountCreation.id,Email=PRMGlobalConstants.TestEmail1 );
		lstCont.add(con);
		
		Contact con2 = new Contact(lastName=PRMGlobalConstants.Test2,AccountId=accountCreation.id,Email=PRMGlobalConstants.TestEmail2 );
		lstCont.add(con2);
		Contact con3 = new Contact(lastName=PRMGlobalConstants.Test3,AccountId=accountCreation.id,Email=PRMGlobalConstants.TestEmail3 );
		lstCont.add(con3);
		Contact con4 = new Contact(lastName=PRMGlobalConstants.Test4,AccountId=accountCreation.id,Email=PRMGlobalConstants.TestEmail4 );
		lstCont.add(con4);
		Database.insert(lstCont);
		
		List<Partner_Company__c> pcList = new List<Partner_Company__c>();
		Partner_Company__c pc1 = new Partner_Company__c();
		pc1.Partner_Name__c = accountCreation.id;
		pc1.Country_Headquarters__c = 'Albania';
		pc1.Market__c = 'Market Asia Pacific & Japan';
		pc1.Partner_Type__c = 'Distributor';
		pcList.add(pc1);
		Partner_Company__c pc2 = new Partner_Company__c();
		pc2.Partner_Name__c = accountCreation.id;
		pc2.Country_Headquarters__c = 'Albania';
		pc2.Market__c = 'Market Asia Pacific & Japan';
		pc2.Partner_Type__c = 'Indirect Reseller';
		pcList.add(pc2);
		Database.insert(pcList);
		
		List<Lead> leadList = new  List<Lead>();
		leadList = TestDataFactory.createLead(1);
		leadList[0].RecordTypeId  = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Indirect Deal Registration').getRecordTypeId();
		leadList[0].email = 'test.junrel@lead.com';
		leadList[0].Rejection_Status_For_Approval__c = 'Pending';
		leadList[0].Indirect_Reseller_Company__c = pcList.get(1).Id;
		leadList[0].Distributor_Partner_Company__c  = pcList.get(0).Id;
		leadList[0].OwnerId = userPRM.Id;
		insert leadList; 
		Test.stopTest();
	}
	}
	private static testMethod void afterInsertLeadShareTest2() {
		User sysAdminUser = TestDataFactory.createSystemAdminUser();
		System.runAs(sysAdminUser){
		user user  = new user(); 
		user = TestDataFactory.userCreation(1,PRMGlobalConstants.SYSTEM_ADMINISTRATOR)[0];
		insert user;
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		accountCreation.AccountNumber = '1234'; 
		database.insert(accountCreation);
		Profile profile = new Profile();
		Account_Member__c AccountMem = new Account_Member__c(Account__c = accountCreation.Id, Account_Role__c = 'Partner Relationship Manager', Type__c = 'External', Name__c = user.Id );
		 
		List <Contact> lstCont = new List<Contact>();
		Contact con = new Contact(lastName=PRMGlobalConstants.Testtext,AccountId=accountCreation.id,Email=PRMGlobalConstants.TestEmail1 );
		lstCont.add(con);
		
		Contact con2 = new Contact(lastName=PRMGlobalConstants.Test2,AccountId=accountCreation.id,Email=PRMGlobalConstants.TestEmail2 );
		lstCont.add(con2);
		Contact con3 = new Contact(lastName=PRMGlobalConstants.Test3,AccountId=accountCreation.id,Email=PRMGlobalConstants.TestEmail3 );
		lstCont.add(con3);
		Contact con4 = new Contact(lastName=PRMGlobalConstants.Test4,AccountId=accountCreation.id,Email=PRMGlobalConstants.TestEmail4 );
		lstCont.add(con4);
		Database.insert(lstCont);
		
		List<Partner_Company__c> pcList = new List<Partner_Company__c>();
		Partner_Company__c pc1 = new Partner_Company__c();
		pc1.Partner_Name__c = accountCreation.id;
		pc1.Country_Headquarters__c = 'Albania';
		pc1.Market__c = 'Market Asia Pacific & Japan';
		pc1.Partner_Type__c = 'Distributor';
		pcList.add(pc1);
		Partner_Company__c pc2 = new Partner_Company__c();
		pc2.Partner_Name__c = accountCreation.id;
		pc2.Country_Headquarters__c = 'Albania';
		pc2.Market__c = 'Market Asia Pacific & Japan';
		pc2.Partner_Type__c = 'Indirect Reseller';
		pcList.add(pc2);
		Database.insert(pcList);
		
		List<Lead> leadList = new  List<Lead>();
		leadList = TestDataFactory.createLead(1);
		leadList[0].RecordTypeId  = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Indirect Deal Registration').getRecordTypeId();
		leadList[0].email = 'test.junrel@lead.com';
		leadList[0].Rejection_Status_For_Approval__c = 'Pending';
		leadList[0].OwnerId = user.Id;
		leadList[0].Indirect_Reseller_Company__c = pcList.get(1).Id;
		leadList[0].Distributor_Partner_Company__c  = pcList.get(0).Id;
		leadList[0].Bus_Ops_Approver__c = user.Id;
		leadList[0].Direct_Sales_Approver__c = user.Id;
		insert leadList; 
	}
	}
		private static testMethod void updateValueAssignmentForLead() {
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		system.runAs(runAsUSer[0]){
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		database.insert(accountCreation);
		
		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;
		
		Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=accountCreation.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		database.insert(conPRM);
		User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',						   lastname = 'Testing',
								 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Profile_Id,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
								 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id );
		database.insert(userPRM);
		
		user user2  = new user(); 
		user2 = TestDataFactory.userCreation(1,'Nokia Sales Profile')[0];
		insert user2;
		   
		List<Lead> leadList = new  List<Lead>();
		leadList = TestDataFactory.createLead(1);
		leadList[0].RecordTypeId  = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Direct Sales').getRecordTypeId();
		leadList[0].status = PRMGlobalConstants.OpenLead;
		leadList[0].OwnerId = user2.id;
		leadList[0].Country='India';
		insert leadList;
		leadList[0].OwnerId = userPRM.id;
		   Test.startTest();
		update leadList;
			 Test.stopTest();
	}
		}
		private static testMethod void ShareToDistributorPRMTest()
		{
			List<user> runAsUSer = new List<user>();
			runAsUSer = TestDataFactory.userCreation(1,'System Administrator');
			runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
			runAsUSer[0].NSA_Compliant__c = true;
			database.insert(runAsUSer);
			system.runAs(runAsUSer[0]){
			Test.startTest();
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			database.insert(accountCreation);
			String orgId = UserInfo.getOrganizationId();
			String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
			Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
			String uniqueName =   dateString + randomInt;
		
			Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=accountCreation.id,Email=PRMGlobalConstants.EmailContactNamePRM );
			database.insert(conPRM);
			
			
			List <Contact> lstCont = new List<Contact>();
			Contact con = new Contact(lastName=PRMGlobalConstants.Testtext,AccountId=accountCreation.id,Email=PRMGlobalConstants.TestEmail1 );
			lstCont.add(con);
			Database.insert(lstCont);
			
			Account DistributorAccount = new Account();
			DistributorAccount.Name = 'TestDistributorAccount1';
			DistributorAccount.BillingStreet = '1660 International Dr';
			DistributorAccount.BillingCity = 'McLean';
			DistributorAccount.BillingState = 'maharashtra';
			DistributorAccount.BillingPostalCode = '22102';
			DistributorAccount.BillingCountry = 'india';
			DistributorAccount.AccountStatusInCRMOM__c = 'Active';
			DistributorAccount.Industry='Enterprise';
			DistributorAccount.Market__c='Market India';
			DistributorAccount.Country__c='India';
			DistributorAccount.Involve_Distributor_in_IR_Deal_Registrat__c=True;
			DistributorAccount.Partner_Type__c='Distributor';
			DistributorAccount.Country__c = 'India';
			DistributorAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
			DistributorAccount.AccountNumber='301030491';
			Database.insert(DistributorAccount);
			
			Contact dispartner = new Contact();
			dispartner.lastname = 'dispartnerlastname';
			dispartner.AccountId = DistributorAccount.id;
			dispartner.Email = 'test@partner.com';
			Database.insert(dispartner);
			User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',						   lastname = 'Testing',
								 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Profile_Id,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
								 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = dispartner.id );
			database.insert(userPRM);
			
			Partner_Company__c pc1 = new Partner_Company__c();
			pc1.Partner_Name__c = DistributorAccount.id;
			pc1.Country_Headquarters__c = 'Albania';
			pc1.Market__c = 'Market Asia Pacific & Japan';
			pc1.Partner_Type__c = 'Distributor';
			Database.insert(pc1);
			
			Lead ShareTestLead = new Lead();
			ShareTestLead.Deal_Name__c = 'testleadshare';
			ShareTestLead.Close_Date__c = system.today() + 15;
			ShareTestLead.Distributor_Partner_Company__c = pc1.id;
			ShareTestLead.Distributor_Account__c = DistributorAccount.id;
			ShareTestLead.Customer_Type__c = 'Existing';
			ShareTestLead.Activity_Sector_Name__c = 'HEALTHCARE';
			ShareTestLead.Company = 'Justrandomcompany';
			ShareTestLead.Lastname = 'Justrandomlastname';
			ShareTestLead.Country = 'India';
			ShareTestLead.FirstName = 'JustFirstname';
			Database.insert(ShareTestLead);
			
			ShareTestLead.DistributorPRM__c = userPRM.id;
			
			Database.update(ShareTestLead);
			   Test.stopTest();  
			
			
			
			
			}
			
		}
		
		
}