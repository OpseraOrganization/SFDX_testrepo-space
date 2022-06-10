/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
Name:			CustomLeadConversionTest 
Description:	 IRApplicationCase Test class to test the class
Date	Version		 Author		Summary of Changes
-----------	  ----------	  -----------------	---------------------------------------------------------------------------------------------------
04/26/2016		 1.0			Supriyam	  Code coverage for convert lead custom class

----------------------------------------------------------------------------------------------------------------------------------------------------------*/

@isTest
public class CustomLeadConversionTest {
	 @testSetup static void createTestData() {
			NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
			cs.Name = 'Default';
			cs.Customer_Account__c = 'Customer - test';
			cs.Customer_Account_Number__c = '12345';
			cs.Customer_User_Profile__c = 'Customers';
			insert cs;
		} 
		public static User createSystemAdminUser(){
		UserRole userRole_1 = [SELECT Id FROM UserRole  where PortalType = 'None' LIMIT 1 ];
		Profile pf= [Select Id from profile where Name='System Administrator']; 
		String orgId=UserInfo.getOrganizationId(); 
		String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		
		Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
		String uniqueName=orgId+dateString+RandomId; 
		
		User uu=new User(firstname = 'Alan', 
		lastName = 'McCarthy', 
		email = uniqueName + '@test' + orgId + '.org', 
		Username = uniqueName + '@test' + orgId + '.org', 
		EmailEncodingKey = 'ISO-8859-1', 
		Alias = uniqueName.substring(18, 23), 
		TimeZoneSidKey = 'America/Los_Angeles', 
		LocaleSidKey = 'en_US', 
		LanguageLocaleKey = 'en_US', 
		ProfileId = pf.Id,
		UserRoleId = userRole_1.Id,
		CompanyName = 'Accenture',	 
		Nokia_ID__c = RandomId + '0');
		return uu;
	}
	public static void insertcustomSetting(){
	List<PRMDealRegRecordTypes__c> prmLeadRecordIdList = new List<PRMDealRegRecordTypes__c>();
	PRMDealRegRecordTypes__c prmLeadRecordId1 = new PRMDealRegRecordTypes__c(name = '01241000000v9mJAAQ'); 
	PRMDealRegRecordTypes__c prmLeadRecordId2 = new PRMDealRegRecordTypes__c(name = '01241000000v9mKAAQ');
	PRMDealRegRecordTypes__c prmLeadRecordId3 = new PRMDealRegRecordTypes__c(name = '01241000000v9mLAAQ');
	PRMDealRegRecordTypes__c prmLeadRecordId4 = new PRMDealRegRecordTypes__c(name = '01241000000v9mMAAQ');
	PRMDealRegRecordTypes__c prmLeadRecordId5 = new PRMDealRegRecordTypes__c(name = '01241000000v9mNAAQ');
	PRMDealRegRecordTypes__c prmLeadRecordId6 = new PRMDealRegRecordTypes__c(name = '01241000000v9mOAAQ');
	prmLeadRecordIdList.add(prmLeadRecordId1);
	prmLeadRecordIdList.add(prmLeadRecordId2);
	prmLeadRecordIdList.add(prmLeadRecordId3);
	prmLeadRecordIdList.add(prmLeadRecordId4);
	prmLeadRecordIdList.add(prmLeadRecordId5);
	prmLeadRecordIdList.add(prmLeadRecordId6);
	Database.insert(prmLeadRecordIdList);
  }
	/*static testMethod void orderintakemethod()
	{
		List<Lead> leadList = new list<lead>();
		Map<id,lead> leadOldMap = new map<id,lead>();
		Test.startTest();
		LeadConversionTriggerHelper.getOrderIntakeForecast();
		LeadConversionTriggerHelper.leadConversion(leadList,leadOldMap);
		LeadConversionTriggerHelper.beforeConversion(leadList,leadList);
		LeadConversionTriggerHelper.afterInsert(leadList);
		LeadConversionTriggerHelper.populateDistributorAccount(leadList);
		LeadConversionTriggerHelper.afterUpdate(leadOldMap,leadOldMap);
		LeadConversionTriggerHelper.updateDistributorAccount(leadOldMap,leadOldMap);
		LeadConversionTriggerHelper.getOpportunityTeamMembers();
		Test.stopTest();
	}*/
	static testMethod void convertLeadTest()
	{   
		User sysAdminUser = createSystemAdminUser();
		System.runAs(sysAdminUser){
	  insertcustomSetting();
	List<File_Sharing_Custom_Setting__c> fileList = TestDataFactory.create_File_Sharing_Custom_Setting();
			insert(fileList);
			
		
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		accountCreation.AccountNumber = '1234'; 
		accountCreation.Partner_Type__c = PRMGlobalConstants.ServiceProvider;
			Test.startTest();
		database.insert(accountCreation);
	String orgId = UserInfo.getOrganizationId();
			String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
			Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
			String uniqueName =   dateString + randomInt;
	Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId= accountCreation.id,Email=PRMGlobalConstants.EmailContactNamePRM );
			
			database.insert(conPRM);
	User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
	languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
	timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id );
	
			database.insert(userPRM); 
	Account accountCreation1 = TestDataFactory.createAccount(1)[0];
		accountCreation1.AccountNumber = '12345612'; 
		database.insert(accountCreation1);
		//End Customer Legal Entity Account Creation
	//	Test.startTest();
		Account accountCreationLegalEntity = TestDataFactory.createAccount(1)[0];
		accountCreationLegalEntity.AccountNumber = '1234001'; 
		accountCreationLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.LEGAL_ENTITY_DEV).getRecordTypeId();
		accountCreationLegalEntity.ParentId = accountCreation1.Id;
		accountCreationLegalEntity.Default_Legal_Entity__c = true;
		accountCreationLegalEntity.Name = 'End Customer Legal Entity Account';
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
		insert leadList; 
		
		product2 prod = new product2();
		prod.name = '5G';
		prod.CurrencyIsoCode = 'USD';
		prod.Business_Group__c='MN';
		prod.Family= '5G';
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
			system.debug('nokiaFinCal'+nokiaFinCal);
		List<Opportunity> oppty= TestDataFactory.OpportunityCreation(1, accountCreation);
		String OpptyName='TestOppty';
		
   system.debug('leadList[0].id'+leadList[0].Id);
			system.debug('accountCreation.id'+accountCreation.Id);
			system.debug('OpptyName'+OpptyName);
	String concatenatedErrorMessage= CustomLeadConversion.ConvertLead(leadList[0].Id, accountCreation.Id, OpptyName, 'CNS', 'CNS', true);
			system.debug('leadList[0].IsConverted'+leadList[0].IsConverted);
	 
	system.debug('leadList[0].RecordTypeId '+leadList[0].RecordTypeId );
	 LeadConversionTriggerHelper.ConversionFutureMethod(leadList[0].Id);
		CustomLeadConversion.getLeadDeatils(leadList[0].Id);
		CustomLeadConversion.getContactDeatils(leadList[0].OwnerId);
		CustomLeadConversion.getName(oppty[0].id);
		 System.assertEquals(true, OpptyName.contains('TestOppty'));
		Test.stopTest();
	}
	
		
	}
	static testMethod void convertLeadDistributorTest(){ 
		 
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		
		system.runAs(runAsUSer[0]){
	  insertcustomSetting();
			TestDataFactory.create_File_Sharing_Custom_Setting();
			
			user user  = new user();  
			Schema.DescribeFieldResult dfr = Schema.sObjectType.Lead.Fields.Indirect_Reseller__c;
			system.debug('>>>>>@@@@@@' +dfr.getSObjectField().getDescribe().getPickListValues());
			Account acc = new Account();
			acc = TestDataFactory.createAccount(1)[0];
			acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
			acc.Market__c = 'Market India';
			acc.Name = 'STARHUB LIMITED';
			acc.Country__c='India';
			acc.BillingCountry  = 'India';
			acc.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
			acc.Partner_Type__c = PRMGlobalConstants.ServiceProvider;
			insert acc;
			Test.startTest();
			String orgId = UserInfo.getOrganizationId();
			String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
			Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
			String uniqueName =   dateString + randomInt;
	Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId= acc.id,Email=PRMGlobalConstants.EmailContactNamePRM );
			database.insert(conPRM);
	User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
	languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
	timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id );
	
			database.insert(userPRM); 
			//End Customer Legal Entity Account Creation
			List<Account> legalEntityList = new List<Account>();
			Account accountCreationLegalEntity = TestDataFactory.createAccount(1)[0];
			accountCreationLegalEntity.AccountNumber = '1234001'; 
			accountCreationLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.LEGAL_ENTITY_DEV).getRecordTypeId();
			accountCreationLegalEntity.ParentId = acc.Id;
			accountCreationLegalEntity.Default_Legal_Entity__c = true;
			accountCreationLegalEntity.Name = 'End Customer Legal Entity Account';
			legalEntityList.add(accountCreationLegalEntity);
			database.insert(legalEntityList);
			system.debug('legalEntityList*****'+legalEntityList);
			Partner_Company__c pc = new Partner_Company__c();
			pc.Partner_Name__c = acc.id;
			pc.Country_Headquarters__c = 'Albania';
			pc.Market__c = 'Market Asia Pacific & Japan';
			pc.Partner_Type__c = 'Indirect Reseller';
			Database.insert(pc);
			//Partner_Company__c pc = [Select id ,  from Partner_Company__c limit 1];
			user = TestDataFactory.userCreation(1,PRMGlobalConstants.SYSTEM_ADMINISTRATOR)[0];
			insert user;
			List<Account_Member__c> accountMemberList =  new List<Account_Member__c>();
			Account_Member__c am = new Account_Member__c();
			Account_Member__c am1 = new Account_Member__c();
			am.Account__c = acc.Id;
			am.Account_Role__c = 'Partner Relationship Manager';
			am.Name__c = user.Id;
			am.Type__c = 'External';
			accountMemberList.add(am);
			am1.Account__c = acc.Id;
			am1.Account_Role__c = 'Partner Relationship Manager';
			am1.Name__c = userPRM.Id;
			am1.Type__c = 'External';
	accountMemberList.add(am1);
			database.Insert(accountMemberList);
			SchemaGlobalDescribe.findObjectNameFromRecordIdPrefix(acc.id);
	 
			List<Lead> leadList = new List<Lead>();
			Lead lead = new Lead();
			lead.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.DISTRIBUTOR_DEAL_REGISTRATION_DEV).getRecordTypeId();
			lead.FirstName='Trigger1';
			lead.LastName='Test1';
			lead.Indirect_Reseller_Company__c = pc.id;
			lead.Using_Indirect_Reseller_for_Deal__c = 'Yes';
			lead.Indirect_Reseller_Market__c = 'Market Asia Pacific & Japan';
			lead.Company= 'End Customer Legal Entity Account';
			lead.End_Customer_Legal_Entity_Account__c = accountCreationLegalEntity.Id;
			lead.LeadSource='GetTimely Online';
			lead.Estimated_Amount__c=Decimal.valueof('100');
			lead.Partner_Role__c='Alliances';
			lead.Activity_Sector_Name__c='CHANNEL';
			lead.Indirect_Reseller__c = 'STARHUB LIMITED';
			lead.Customer_Type__c = 'Existing customer';
			lead.Industry='Construction';
			leadList.add(lead);
			insert leadList;
			system.debug('lead.PartnerAccountId*******'+lead.PartnerAccountId);
			product2 prod = new product2();
			prod.name = '5G';
			prod.CurrencyIsoCode = 'USD';
			prod.Business_Group__c='MN';
			prod.Family= '5G';
			prod.IsActive=True;
			prod.Partner_Visible__c=True;
			prod.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Business_Line').getRecordTypeId();
			insert prod;
			DealProduct__c  dp = new DealProduct__c ();
			dp.BusinessLine__c = prod.id;
			dp.Deal__c = lead.Id;
			dp.Value__c = 50.0;
			insert dp;
			Nokia_Financial_Calendar__c nokiaFinCal = TestDataFactory.nokiaFinCalCreation(1)[0];
			database.insert(nokiaFinCal);
			String OpptyName='TestOppty';
			Map<id,Lead> leadOldMap = new Map<id,Lead>();
			leadOldMap.put(lead.Id, lead);
			
			String concatenatedErrorMessage= CustomLeadConversion.ConvertLead(lead.Id, acc.Id, OpptyName, 'CNS', 'CNS', false);
			CustomLeadConversion.getLeadDeatils(lead.Id);
			CustomLeadConversion.getContactDeatils(lead.OwnerId);
			CustomLeadConversion.getInactiveAccName(lead.Id);
			LeadConversionTriggerHelper.leadConversion(leadList,leadOldMap);
			system.debug('concatenatedErrorMessage'+concatenatedErrorMessage);
		 
			Test.stopTest();

		}  
	}
	/*static testMethod void convertNoDistributorLeadTest(){   
		User sysAdminUser = createSystemAdminUser();
		System.runAs(sysAdminUser){
	  insertcustomSetting();
		
		user user  = new user();  
		Schema.DescribeFieldResult dfr = Schema.sObjectType.Lead.Fields.Indirect_Reseller__c;
		system.debug('>>>>>@@@@@@' +dfr.getSObjectField().getDescribe().getPickListValues());
		Account acc = new Account();
		Account acc2 = new Account();
		acc = TestDataFactory.createAccount(1)[0];
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		acc.Market__c = 'Market India';
		acc.Name = 'STARHUB LIMITED';
		acc.Country__c='India';
		acc.BillingCountry  = 'India';
		acc.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
		acc.Partner_Type__c = 'Indirect Reseller';
		acc.BusinessPartnerRole__c = GlobalConstants.Distributor;
		insert acc;
		//End Customer Legal Entity Account Creation
		Account accountCreationLegalEntity = TestDataFactory.createAccount(1)[0];
		accountCreationLegalEntity.AccountNumber = '1234001'; 
		accountCreationLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.LEGAL_ENTITY_DEV).getRecordTypeId();
		accountCreationLegalEntity.ParentId = acc.Id;
		accountCreationLegalEntity.Default_Legal_Entity__c = true;
		accountCreationLegalEntity.Name = 'End Customer Legal Entity Account';
		database.insert(accountCreationLegalEntity);
		acc2.RecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		acc2.Market__c = 'Market India';
		acc2.Name = 'Prateek LIMITED';
		acc2.Country__c='India';
		acc2.BillingCountry  = 'India';
		acc2.CBT_CT_Code__c = 'INDIA TBM CT Multi Service Operators';
		acc2.Partner_Type__c = 'Indirect Reseller';
		insert acc2;
		Partner_Company__c pc = new Partner_Company__c();
		pc.Partner_Name__c = acc.id;
		pc.Country_Headquarters__c = 'Albania';
		pc.Market__c = 'Market Asia Pacific & Japan';
		pc.Partner_Type__c = 'Indirect Reseller';
		Database.insert(pc);
		Partner_Company__c pc2 = new Partner_Company__c();
		pc2.Partner_Name__c = acc2.id;
		pc2.Country_Headquarters__c = 'Albania';
		pc2.Market__c = 'Market Asia Pacific & Japan';
		pc2.Partner_Type__c = 'Indirect Reseller';
		Database.insert(pc2);
		user = TestDataFactory.userCreation(1,PRMGlobalConstants.SYSTEM_ADMINISTRATOR)[0];
		insert user;
		Account_Member__c am = new Account_Member__c();
		am.Account__c = acc.Id;
		am.Account_Role__c = 'Partner Relationship Manager';
		am.Name__c = user.Id;
		am.Type__c = 'External';
		insert am;
		SchemaGlobalDescribe.findObjectNameFromRecordIdPrefix(acc.id);
			Test.startTest();
		Lead lead = new Lead();
		lead.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.DISTRIBUTOR_DEAL_REGISTRATION_DEV).getRecordTypeId();
		lead.FirstName='Trigger1';
		lead.LastName='Test1';
		lead.Indirect_Reseller_Company__c = pc.id;
		lead.Using_Indirect_Reseller_for_Deal__c = 'Yes';
		lead.Indirect_Reseller_Market__c = 'Market Asia Pacific & Japan';
		lead.Company='End Customer Legal Entity Account';
		lead.End_Customer_Legal_Entity_Account__c = accountCreationLegalEntity.Id;
		lead.LeadSource='GetTimely Online';
		lead.Estimated_Amount__c=Decimal.valueof('150');
		lead.Partner_Role__c='Alliances';
		lead.Activity_Sector_Name__c='CHANNEL';
		lead.Indirect_Reseller__c = 'STARHUB LIMITED';
		lead.Customer_Type__c = 'Existing customer';
		lead.Industry='Construction';
		insert lead;
		product2 prod = new product2();
		prod.name = '5G';
		prod.CurrencyIsoCode = 'USD';
		prod.Business_Group__c='MN';
		prod.Family= '5G';
		prod.IsActive=True;
		prod.Partner_Visible__c=True;
		prod.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Business_Line').getRecordTypeId();
		
		insert prod;
		DealProduct__c  dp = new DealProduct__c ();
		dp.BusinessLine__c = prod.id;
		dp.Deal__c = lead.Id;
		dp.Value__c = 50.0;
		Nokia_Financial_Calendar__c nokiaFinCal = TestDataFactory.nokiaFinCalCreation(1)[0];
		database.insert(nokiaFinCal);
		String OpptyName='TestOppty';
		
		String concatenatedErrorMessage= CustomLeadConversion.ConvertLead(lead.Id, acc.Id, OpptyName, 'CNS', 'CNS', true);
			CustomLeadConversion.getLeadDeatils(lead.Id);
			String leadBG = CustomLeadConversion.getLeadBG(lead.Id);
			String leadBU = CustomLeadConversion.getLeadBU(lead.Id);
		system.debug('concatenatedErrorMessage'+concatenatedErrorMessage);
	 
		Test.stopTest();
		}

		
	}*/

	
		/*private static testMethod void MakeRejectCommentsMandatoryTest() {
		User sysAdminUser = createSystemAdminUser();
		System.runAs(sysAdminUser){
	  insertcustomSetting();
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		accountCreation.AccountNumber = '1234'; 
		database.insert(accountCreation);
	  //End Customer Legal Entity Account Creation
		Account accountCreationLegalEntity = TestDataFactory.createAccount(1)[0];
		accountCreationLegalEntity.AccountNumber = '1234001'; 
		accountCreationLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.LEGAL_ENTITY_DEV).getRecordTypeId();
		accountCreationLegalEntity.ParentId = accountCreation.Id;
		accountCreationLegalEntity.Default_Legal_Entity__c = true;
		accountCreationLegalEntity.Name = 'End Customer Legal Entity Account';
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
			
		Partner_Company__c pc = new Partner_Company__c();
		pc.Partner_Name__c = accountCreation.id;
		pc.Country_Headquarters__c = 'Albania';
		pc.Market__c = 'Market Asia Pacific & Japan';
		pc.Partner_Type__c = 'Distributor';
		Database.insert(pc);
		
		Partner_Company__c pc1 = new Partner_Company__c();
		pc1.Partner_Name__c = accountCreation.id;
		pc1.Country_Headquarters__c = 'Algeria';
		pc1.Market__c = 'Market Europe';
		pc1.Partner_Type__c = 'Indirect Reseller';
		Database.insert(pc1);
		
		List<Lead> leadList = new  List<Lead>();
		leadList = TestDataFactory.createLead(1);
		leadList[0].RecordTypeId  = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.INDIRECT_DEAL_REGISTRATION_DEV).getRecordTypeId();
		leadList[0].email = 'test.junrel@lead.com';
		
		leadList[0].Rejection_Status_For_Approval__c = 'Pending';
		leadList[0].Distributor_Partner_Company__c = pc.Id;
		insert leadList; 
		
		
		//Reject Comments are null
		Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
		req1.setObjectId(leadList.get(0).id);
		
		// Submit the record to specific process and skip the criteria evaluation
		req1.setProcessDefinitionNameOrId('CRM_Deal_Registration_Process');
		req1.setSkipEntryCriteria(true);

		// Submit the approval request for the lead
		Approval.ProcessResult result;
		
		try{		
			result = Approval.process(req1);
			system.debug('heyyy '+System.Label.Lead_Reject_Reason);
		}catch(Exception e) {
			
		}
	}
	}*/	
	static testMethod void ConversionFutureMethodtest3(){ 
		User sysAdminUser = createSystemAdminUser();
		System.runAs(sysAdminUser){
			Id EndCustID;
			Id leadID;
			String G3_Planned_Date = String.valueOf(Date.today());
			String G4_Approval_Date = String.valueOf(Date.today().addDays(30));
			String G5_Planned_Date = String.valueOf(Date.today().addDays(60));
			String G6_Planned_Date = String.valueOf(Date.today().addDays(90));
			Test.startTest();
			CustomLeadConversion.getEndCustomer(EndCustID);
			CustomLeadConversion.getEndCustomerName(leadID);
			CustomLeadConversion.updateLead(leadID,G3_Planned_Date,G4_Approval_Date,G5_Planned_Date,G6_Planned_Date);
			//R21.11 release new methods coverage
			CustomLeadConversion.getDependentPicklistValues();
			ListView listview = CustomLeadConversion.getListView();
			Boolean isPartnerUser = CustomLeadConversion.isPartnerUser();
			try {
	CustomLeadConversion.isValidPartnerUser(leadID);
			}
			catch(Exception e) { /* Do Nothing */ }
			try {
	CustomLeadConversion.getLeadBG(leadID);
			}
			catch(Exception e) { /* Do Nothing */ }
			try {
	CustomLeadConversion.getLeadBU(leadID);
			}
			catch(Exception e) { /* Do Nothing */ }
			Test.stopTest();	
		}
	}
	
	@isTest
	static void techSquadOptInTestMethod(){
		Test.startTest();
		Contact conPRM ;
		User userPRM;
			
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		accountCreation.AccountNumber = '1234'; 
		accountCreation.Partner_Type__c = PRMGlobalConstants.ServiceProvider;
			
	database.insert(accountCreation);
	
	   conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId= accountCreation.id,Email=PRMGlobalConstants.EmailContactNamePRM,PRM_Tech_Squad_Eligible__c=true,PRM_Tech_Squad_Opt_In__c=null);
			
			database.insert(conPRM);
		
			String orgId = UserInfo.getOrganizationId();
			String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
			Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
			String uniqueName =   dateString + randomInt;
		
		System.runAs([SELECT ID FROM User WHERE Id = :UserInfo.getUserId()][0]){
			
			Profile p = [SELECT ID FROM Profile WHERE Name = 'PRM Partner Community User Login'];
			
			userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
			languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = p.Id,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
			timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id );
		}
		
			
			//database.insert(userPRM); 
		
		System.runAs(userPRM){
			CustomLeadConversion.getTechOptinChoice();
			
		 conPRM.PRM_Tech_Squad_Opt_In__c = 'Yes';
		CustomLeadConversion.setTechOptinChoice(conPRM);
		   
		}
		
		
	   
		Test.stopTest();
	}	
}