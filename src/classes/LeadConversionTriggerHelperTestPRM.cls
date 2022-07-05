@IsTest
public class LeadConversionTriggerHelperTestPRM{
	static testMethod void ConversionFutureMethodtest()
	{ 
	User sysAdminUser = CustomLeadConversionTest.createSystemAdminUser();
		System.runAs(sysAdminUser){
	  CustomLeadConversionTest.insertcustomSetting();
	List<File_Sharing_Custom_Setting__c> fileList = TestDataFactory.create_File_Sharing_Custom_Setting();
			insert(fileList);
			
		
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		accountCreation.AccountNumber = '1234'; 
		accountCreation.Partner_Type__c = PRMGlobalConstants.ServiceProvider;
			accountCreation.L7Name__c = 'test';
		database.insert(accountCreation);
	String orgId = UserInfo.getOrganizationId();
			String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
			Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
			String uniqueName =   dateString + randomInt;
	Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId= accountCreation.id,Email=PRMGlobalConstants.EmailContactNamePRM );
			
			database.insert(conPRM);
	User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' , emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
	languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
	timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id );
	
			database.insert(userPRM); 
	Account accountCreation1 = TestDataFactory.createAccount(1)[0];
		accountCreation1.AccountNumber = '12345612'; 
			accountCreation1.Involve_Distributor_in_IR_Deal_Registrat__c = true;
		database.insert(accountCreation1);
		//End Customer Legal Entity Account Creation
		Account accountCreationLegalEntity = TestDataFactory.createAccount(1)[0];
		accountCreationLegalEntity.AccountNumber = '1234001'; 
		accountCreationLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.LEGAL_ENTITY_DEV).getRecordTypeId();
		accountCreationLegalEntity.ParentId = accountCreation1.Id;
		accountCreationLegalEntity.Default_Legal_Entity__c = true;
		accountCreationLegalEntity.Name = 'End Customer Legal Entity Account';
		Test.startTest();
		database.insert(accountCreationLegalEntity);
		
		List <Contact> lstCont = new List<Contact>();
		Contact con = new Contact(lastName=PRMGlobalConstants.Testtext,AccountId=accountCreation.id,Email=PRMGlobalConstants.TestEmail1);
		lstCont.add(con);
		
		Contact con2 = new Contact(lastName=PRMGlobalConstants.Test2,AccountId=accountCreation.id,Email=PRMGlobalConstants.TestEmail2);
		lstCont.add(con2);
		Contact con3 = new Contact(lastName=PRMGlobalConstants.Test3,AccountId=accountCreation.id,Email=PRMGlobalConstants.TestEmail3);
		lstCont.add(con3);
		Contact con4 = new Contact(lastName=PRMGlobalConstants.Test4,AccountId=accountCreation.id,Email=PRMGlobalConstants.TestEmail4);
		lstCont.add(con4);
		Database.insert(lstCont);
		List<Account_Member__c> accountMemberList =  new List<Account_Member__c>();
			Account_Member__c am = new Account_Member__c();
			am.Account__c = accountCreation1.Id;
			am.Account_Role__c = 'Partner Relationship Manager';
			am.Name__c = userPRM.Id;
			am.Type__c = 'External';
			accountMemberList.add(am);
			database.Insert(accountMemberList);	
		Partner_Company__c pc = new Partner_Company__c();
		pc.Partner_Name__c = accountCreation1.id;
		pc.Country_Headquarters__c = 'Albania';
		pc.Market__c = 'Market Asia Pacific & Japan';
		pc.Partner_Type__c = 'Distributor';
		Database.insert(pc);
		List<Opportunity> oppty= TestDataFactory.OpportunityCreation(1, accountCreation);
			oppty[0].Gate_3_Bypass_no_offer_support__c = true;
		insert oppty;
			
			/*Sales_Role__c sr = new Sales_Role__c();
			sr.User__c = sysAdminUser.id;
			sr.Role_Name__c = PRMGlobalConstants.NSNG_COCT;
			sr.Organisation__c = 'test';
			sr.Role_Code__c = 'test';
			insert sr;
			
			Apttus_Approval__Backup_Approver__c bckp = new Apttus_Approval__Backup_Approver__c();
			bckp.Apttus_Approval__Current_User__c = sysAdminUser.id;
			bckp.Delegate_Approver1__c = sysAdminUser.id;
			bckp.Delegate_Approver2__c = sysAdminUser.id;
			bckp.Delegate_Approver3__c = sysAdminUser.id;
			bckp.Apttus_Approval__Backup_User__c = sysAdminUser.id;
			bckp.Apttus_Approval__IsActive__c = true;
			bckp.Apttus_Approval__InEffect__c = true;
			insert bckp;*/
			
			
		List<Lead> leadList = new  List<Lead>();
		leadList = TestDataFactory.createLead(1);
		leadList[0].RecordTypeId  = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.INDIRECT_DEAL_REGISTRATION_DEV).getRecordTypeId();
		leadList[0].email = 'test.junrel@lead.com';
		leadList[0].status = 'Rejected'; 
		leadList[0].End_Customer_Legal_Entity_Account__c = accountCreationLegalEntity.Id;
		leadList[0].Rejection_Status_For_Approval__c = 'Pending';
		leadList[0].Distributor_Partner_Company__c = pc.Id;
		leadList[0].OwnerId = userPRM.id;
	leadList[0].Distributor_Account__c = accountCreation1.id;
	leadList[0].IsConverted=true;
			leadList[0].ConvertedAccountId=accountCreation.Id;
			leadList[0].convertedOpportunityId=oppty[0].id;
		insert leadList; 
		
		product2 prod = new product2();
		prod.name = 'FN';
		prod.CurrencyIsoCode = 'USD';
		prod.Business_Group__c='MN';
		prod.Family= 'FN';
		prod.IsActive=True;
		prod.Partner_Visible__c=True;
		prod.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Business_Line').getRecordTypeId();
		insert prod;
		DealProduct__c  dp = new DealProduct__c ();
		dp.BusinessLine__c = prod.id;
		dp.Deal__c = leadList[0].Id;
		dp.Value__c = 50.0;			
		insert dp;
			
			
			Nokia_Financial_Calendar__c nokiaFinCal = TestDataFactory.nokiaFinCalCreation(1)[0];
	 nokiaFinCal.Start_Date__c = system.today();
			nokiaFinCal.End_Date__c = system.today();
	nokiaFinCal.Name = 'TestCalander';
		database.insert(nokiaFinCal);
			
			LeadConversionTriggerHelper.ConversionFutureMethod(leadList[0].Id);
		Test.stopTest();	
			
		}
	}
	
	static testMethod void ConversionFutureMethodtest2()
	{ 
	User sysAdminUser = CustomLeadConversionTest.createSystemAdminUser();
		System.runAs(sysAdminUser){
	  CustomLeadConversionTest.insertcustomSetting();
	List<File_Sharing_Custom_Setting__c> fileList = TestDataFactory.create_File_Sharing_Custom_Setting();
			insert(fileList);
			
		
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		accountCreation.AccountNumber = '1234'; 
		accountCreation.Partner_Type__c = PRMGlobalConstants.ServiceProvider;
			accountCreation.L7Name__c = 'test';
		database.insert(accountCreation);
	String orgId = UserInfo.getOrganizationId();
			String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
			Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
			String uniqueName =   dateString + randomInt;
	Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId= accountCreation.id,Email=PRMGlobalConstants.EmailContactNamePRM );
			
			database.insert(conPRM);
	User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' , emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
	languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
	timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id );
	
			database.insert(userPRM); 
	Account accountCreation1 = TestDataFactory.createAccount(1)[0];
		accountCreation1.AccountNumber = '12345612'; 
			accountCreation1.Involve_Distributor_in_IR_Deal_Registrat__c = true;
		database.insert(accountCreation1);
		//End Customer Legal Entity Account Creation
		Account accountCreationLegalEntity = TestDataFactory.createAccount(1)[0];
		accountCreationLegalEntity.AccountNumber = '1234001'; 
		accountCreationLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.LEGAL_ENTITY_DEV).getRecordTypeId();
		accountCreationLegalEntity.ParentId = accountCreation1.Id;
		accountCreationLegalEntity.Default_Legal_Entity__c = true;
		accountCreationLegalEntity.Name = 'End Customer Legal Entity Account';
		Test.startTest();
		database.insert(accountCreationLegalEntity);
		
		List <Contact> lstCont = new List<Contact>();
		Contact con = new Contact(lastName=PRMGlobalConstants.Testtext,AccountId=accountCreation.id,Email=PRMGlobalConstants.TestEmail1);
		lstCont.add(con);
		
		Contact con2 = new Contact(lastName=PRMGlobalConstants.Test2,AccountId=accountCreation.id,Email=PRMGlobalConstants.TestEmail2);
		lstCont.add(con2);
		Contact con3 = new Contact(lastName=PRMGlobalConstants.Test3,AccountId=accountCreation.id,Email=PRMGlobalConstants.TestEmail3);
		lstCont.add(con3);
		Contact con4 = new Contact(lastName=PRMGlobalConstants.Test4,AccountId=accountCreation.id,Email=PRMGlobalConstants.TestEmail4);
		lstCont.add(con4);
		Database.insert(lstCont);
		List<Account_Member__c> accountMemberList =  new List<Account_Member__c>();
			Account_Member__c am = new Account_Member__c();
			am.Account__c = accountCreation1.Id;
			am.Account_Role__c = 'Partner Relationship Manager';
			am.Name__c = userPRM.Id;
			am.Type__c = 'External';
			accountMemberList.add(am);
			database.Insert(accountMemberList);	
		Partner_Company__c pc = new Partner_Company__c();
		pc.Partner_Name__c = accountCreation1.id;
		pc.Country_Headquarters__c = 'Albania';
		pc.Market__c = 'Market Asia Pacific & Japan';
		pc.Partner_Type__c = 'Distributor';
		Database.insert(pc);
		List<Opportunity> oppty= TestDataFactory.OpportunityCreation(1, accountCreation);
			oppty[0].Gate_3_Bypass_no_offer_support__c = true;
		insert oppty;
			
			
		List<Lead> leadList = new  List<Lead>();
		leadList = TestDataFactory.createLead(1);
		leadList[0].RecordTypeId  = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.INDIRECT_DEAL_REGISTRATION_DEV).getRecordTypeId();
		leadList[0].email = 'test.junrel@lead.com';
		leadList[0].status = 'Rejected'; 
		leadList[0].End_Customer_Legal_Entity_Account__c = accountCreationLegalEntity.Id;
		leadList[0].Rejection_Status_For_Approval__c = 'Pending';
		leadList[0].Distributor_Partner_Company__c = pc.Id;
		leadList[0].OwnerId = userPRM.id;
	leadList[0].Distributor_Account__c = accountCreation1.id;
	leadList[0].IsConverted=true;
			leadList[0].ConvertedAccountId=accountCreation.Id;
			leadList[0].convertedOpportunityId=oppty[0].id;
		insert leadList; 
		
			Apttus_Approval__Approval_Process__c Aprocess=new Apttus_Approval__Approval_Process__c();
			insert Aprocess;
			
			Apttus_Approval__ApprovalProcessInstance__c processinstance=new Apttus_Approval__ApprovalProcessInstance__c(name=PRMGlobalConstants.G2_Approvals_New,Apttus_Approval__BusinessObjectId__c=oppty[0].id, Apttus_Approval__ApprovalProcessId__c=Aprocess.id);
			insert processinstance;
			
			Sales_Role__c sr = new Sales_Role__c();
			sr.User__c = sysAdminUser.id;
			sr.Role_Name__c = PRMGlobalConstants.NSNG_COCT;
			sr.Organisation__c = 'test';
			sr.Role_Code__c = 'test';
			insert sr;
			
			Nokia_Financial_Calendar__c nokiaFinCal = TestDataFactory.nokiaFinCalCreation(1)[0];
	 nokiaFinCal.Start_Date__c = system.today();
			nokiaFinCal.End_Date__c = system.today();
	nokiaFinCal.Name = 'TestCalander';
		database.insert(nokiaFinCal);
			
			LeadConversionTriggerHelper.ConversionFutureMethod(leadList[0].Id);
		Test.stopTest();	
			
		}
	}
	static testMethod void ConversionFutureMethodtestNoDisti()
	{ 
	User sysAdminUser = CustomLeadConversionTest.createSystemAdminUser();
		System.runAs(sysAdminUser){
	  CustomLeadConversionTest.insertcustomSetting();
	List<File_Sharing_Custom_Setting__c> fileList = TestDataFactory.create_File_Sharing_Custom_Setting();
			insert(fileList);
			
		
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		accountCreation.AccountNumber = '1234'; 
		accountCreation.Partner_Type__c = PRMGlobalConstants.ServiceProvider;
		database.insert(accountCreation);
	String orgId = UserInfo.getOrganizationId();
			String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
			Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
			String uniqueName =   dateString + randomInt;
	Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId= accountCreation.id,Email=PRMGlobalConstants.EmailContactNamePRM );
			
			database.insert(conPRM);
	User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' , emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
	languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
	timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id );
	
			database.insert(userPRM); 
	Account accountCreation1 = TestDataFactory.createAccount(1)[0];
		accountCreation1.AccountNumber = '12345612'; 
			accountCreation1.Involve_Distributor_in_IR_Deal_Registrat__c = true;
		database.insert(accountCreation1);
		//End Customer Legal Entity Account Creation
		Account accountCreationLegalEntity = TestDataFactory.createAccount(1)[0];
		accountCreationLegalEntity.AccountNumber = '1234001'; 
		accountCreationLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.LEGAL_ENTITY_DEV).getRecordTypeId();
		accountCreationLegalEntity.ParentId = accountCreation1.Id;
		accountCreationLegalEntity.Default_Legal_Entity__c = true;
		accountCreationLegalEntity.Name = 'End Customer Legal Entity Account';
		database.insert(accountCreationLegalEntity);
		
			List<Partner_Company__c> pcList = new List<Partner_Company__c>();
		Partner_Company__c pc = new Partner_Company__c();
		pc.Partner_Name__c = accountCreation1.id;
		pc.Country_Headquarters__c = 'Albania';
		pc.Market__c = 'Market Asia Pacific & Japan';
		pc.Partner_Type__c = 'Distributor';
			pcList.add(pc);
			
		Partner_Company__c pc2 = new Partner_Company__c();
		pc2.Partner_Name__c = accountCreation1.id;
		pc2.Country_Headquarters__c = 'Albania';
		pc2.Market__c = 'Market Asia Pacific & Japan';
		pc2.Partner_Type__c = 'Distributor';
			pcList.add(pc2);
			
			Partner_Company__c pc3 = new Partner_Company__c();
		pc3.Partner_Name__c = accountCreation1.id;
		pc3.Country_Headquarters__c = 'Albania';
		pc3.Market__c = 'Market Asia Pacific & Japan';
		pc3.Partner_Type__c = 'Indirect Reseller';
			pcList.add(pc3);
		Database.insert(pcList);
			
			Test.startTest();
			
		List<Opportunity> oppty= TestDataFactory.OpportunityCreation(1, accountCreation);
		insert oppty;
		List<Lead> leadList = new  List<Lead>();
		leadList = TestDataFactory.createLead(1);
		leadList[0].RecordTypeId  = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.INDIRECT_DEAL_REGISTRATION_DEV).getRecordTypeId();
		leadList[0].email = 'test.junrel@lead.com';
		leadList[0].status = 'Rejected'; 
		leadList[0].End_Customer_Legal_Entity_Account__c = accountCreationLegalEntity.Id;
		leadList[0].Rejection_Status_For_Approval__c = 'Pending';
		leadList[0].Distributor_Partner_Company__c = pc.Id;
		leadList[0].OwnerId = userPRM.id;
	leadList[0].IsConverted=true;
			leadList[0].ConvertedAccountId=accountCreation.Id;
			leadList[0].convertedOpportunityId=oppty[0].id;
		insert leadList; 
			
			leadList[0].Distributor_Partner_Company__c = pc2.Id;
			leadList[0].Indirect_Reseller_Company__c = pc3.id;
			update leadList[0];
		Test.stopTest();	
			
		}
	}
}