/****************************************
 * Name : ContentDocumentLinkHelperTest 
 * Author : Accenture
 * Description : Test class for ContentDocumentLinkHelper
 *****************************************/
@isTest
public class ContentDocumentLinkHelperTest { 
	
	public static String confidentialOffer = 'Confidential_File_to_Offer';
	public static String unrestrictedOther = 'Unrestricted_File_to_Other';
	public static String g4Material = 'G4 Material';
	
	static testMethod void checkUncheckOpportunityPTAFlagOnInsertTest()
	{	
		List<Account> accountList = new List<Account>();
		List<Opportunity> opportunityList = new List<Opportunity>();
		List<Offer__c> offerList = new List<Offer__c>();
		List<user> userList = new List<User>();
		Set<Id> conVersionIdSet = new Set<Id>();
		ContentDocumentLink conDocumentLink;
		
		//Insert an File_Sharing_Custom_Setting
		/*List<File_Sharing_Custom_Setting__c>  fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>(); 
		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		Database.insert(fileSharingCustomSettingList);*/
		
		userList = TestDataFactory.userCreation(1, GlobalConstants.SYSTEM_AdMINISTRATOR);
		database.insert(userList); 
		system.runAs(userList[0])
		{
			//Create an account
			accountList = TestDataFactory.createAccount(1);
			database.insert(accountList);
			id accountId  = accountList[0].id;
			system.assert(accountId!=null);
			
			// create an opportunity			
			opportunityList = TestDataFactory.OpportunityCreation(1, accountList[0]);
			database.insert(opportunityList);
			id opportunityId = opportunityList[0].id;
			system.assert(opportunityId!=null);
			Test.startTest();	
			
			//creating content version
			ContentVersion  conVersionVar = TestDataFactory.createContentVersion_New(1,GlobalConstants.PTAFlag)[0];
			database.insert(conVersionVar);
			
			List<ContentVersion> conVersion = [SELECT ContentDocumentId,Document_Type_POC__c FROM ContentVersion 
	 where ID =: conVersionVar.Id LIMIT 1];		 
			//creating contentDocumentLink
			conDocumentLink = TestDataFactory.createContentDocumentLink_New(1,opportunityId,conVersion[0].ContentDocumentId)[0];
			database.insert(conDocumentLink); 
			
			Test.stoptest();
		}
	}
	static testMethod void checkUncheckOfferSSOFlagOnInsertTest()
	{	
		List<Account> accountList = new List<Account>();
		List<Opportunity> opportunityList = new List<Opportunity>();
		List<Offer__c> offerList = new List<Offer__c>();
		List<user> userList = new List<User>();
		Set<Id> conVersionIdSet = new Set<Id>();
		ContentDocumentLink conDocumentLink;
		
		//Insert an File_Sharing_Custom_Setting
		/*List<File_Sharing_Custom_Setting__c>  fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>(); 
		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		Database.insert(fileSharingCustomSettingList);*/
		
		userList = TestDataFactory.userCreation(1, GlobalConstants.SYSTEM_AdMINISTRATOR);
		database.insert(userList); 
		system.runAs(userList[0])
		{
			//Create an account
			accountList = TestDataFactory.createAccount(1);
			database.insert(accountList);
			id accountId  = accountList[0].id;
			system.assert(accountId!=null);
			
			// create an opportunity			
			opportunityList = TestDataFactory.OpportunityCreation(1, accountList[0]);
			database.insert(opportunityList);
			id opportunityId = opportunityList[0].id;
			system.assert(opportunityId!=null);
			Test.startTest(); 
			
			// Create an offer
			offerList = TestDataFactory.OfferCreation(1,opportunityList[0]);
			offerList[0].ActiveOffer__c = true;
			database.insert(offerList);
			id offerId = offerList[0].id;
			system.assert(offerId!=null);	 
			
			//creating content version
			ContentVersion  conVersionVar = TestDataFactory.createContentVersion_New(1,GlobalConstants.SSOFLAG)[0];
			database.insert(conVersionVar);
			
			List<ContentVersion> conVersion = [SELECT ContentDocumentId,Document_Type_POC__c FROM ContentVersion 
	 where ID =: conVersionVar.Id LIMIT 1];		 
			//creating contentDocumentLink
			conDocumentLink = TestDataFactory.createContentDocumentLink_New(1,offerId,conVersion[0].ContentDocumentId)[0];
			database.insert(conDocumentLink); 
			
			Test.stoptest();
		}
	}
	
	static testMethod void checkUncheckOpportunityBOMFlagOnInsertTest()
	{	
		List<Account> accountList = new List<Account>();
		List<Opportunity> opportunityList = new List<Opportunity>();
		List<Offer__c> offerList = new List<Offer__c>();
		List<user> userList = new List<User>();
		Set<Id> conVersionIdSet = new Set<Id>();
		ContentDocumentLink conDocumentLink;
		
		//Insert an File_Sharing_Custom_Setting
		/*List<File_Sharing_Custom_Setting__c>  fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>(); 
		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		Database.insert(fileSharingCustomSettingList);*/
		
		userList = TestDataFactory.userCreation(1, GlobalConstants.SYSTEM_AdMINISTRATOR);
		database.insert(userList); 
		system.runAs(userList[0])
		{
			//Create an account
			accountList = TestDataFactory.createAccount(1);
			database.insert(accountList);
			id accountId  = accountList[0].id;
			system.assert(accountId!=null);
			
			// create an opportunity			
			opportunityList = TestDataFactory.OpportunityCreation(1, accountList[0]);
			database.insert(opportunityList);
			id opportunityId = opportunityList[0].id;
			system.assert(opportunityId!=null);
			Test.startTest();  
			
			//changing oppty's stage Name and phase status
			opportunityList[0].Apttus_Approval__Approval_Status__c = 'Approved';
			opportunityList[0].StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			opportunityList[0].Phase_Status__c = 'Opportunity in Progress';
			database.update(opportunityList[0]);
			system.debug('optyCreationoptyCreationoptyCreation>>>>>>>>>>>>>>>>>>>>>>>>>'+ opportunityList[0]);
			
			//Creating Presales Oppty
			Opportunity preSalesTest = TestDataFactory.preSalesOpportunityCreation(1, accountList[0], opportunityList[0])[0];	 
			preSalesTest.PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Risk Order';
			preSalesTest.PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = 'Risk Order Only';
			preSalesTest.CurrencyIsoCode = 'USD';
			database.insert(preSalesTest);
			id preSalesOppId = preSalesTest.id;		 
			system.assert(preSalesOppId!=null);
			
			//creating content version
			ContentVersion  conVersionVar = TestDataFactory.createContentVersion_New(1,GlobalConstants.BOMBOQFlag)[0];
			database.insert(conVersionVar);
			
			List<ContentVersion> conVersion = [SELECT ContentDocumentId,Document_Type_POC__c FROM ContentVersion 
	 where ID =: conVersionVar.Id LIMIT 1];		 
			//creating contentDocumentLink
			conDocumentLink = TestDataFactory.createContentDocumentLink_New(1,preSalesOppId,conVersion[0].ContentDocumentId)[0];
			database.insert(conDocumentLink); 
			
			Test.stoptest();
		}
	}
	
	static testMethod void  addOrRemovePermissionSetOnUser()
	{   
		List<user> userList = new List<User>();
	userList = TestDataFactory.userCreation(1, GlobalConstants.SYSTEM_AdMINISTRATOR);
		database.insert(userList); 
		system.runAs(userList[0])
		{
	  Test.startTest();
	  List<user> userList1 = new List<User>();
	  userList1 = TestDataFactory.userCreation(1, GlobalConstants.SYSTEM_AdMINISTRATOR);
	  database.insert(userList1); 
	  userList1[0].Restriction_Level__c='Unrestricted';
	  database.Update(userList1); 
	  userList1[0].Restriction_Level__c='Confidential';
	  database.Update(userList1); 
	  Test.stoptest();
	}
  }
  static testMethod void restrictNSASharingTest()
	{   
		List<Account> accountList = new List<Account>();
		List<Opportunity> opportunityList = new List<Opportunity>();
		List<Offer__c> offerList = new List<Offer__c>();
		List<user> userList = new List<User>();
		Set<Id> conVersionIdSet = new Set<Id>();
		
		userList = TestDataFactory.userCreation(2, GlobalConstants.SYSTEM_AdMINISTRATOR);
	userList[1].NSA_Compliant__c = false;
		database.insert(userList); 
		system.runAs(userList[0])
		{
	  //Create an account
			accountList = TestDataFactory.createAccount(1);
	  accountList[0].Customer_Compliance__c = 'US_Govern';
			database.insert(accountList);
			id accountId  = accountList[0].id;
			system.assert(accountId!=null);
			
			// create an opportunity			
			opportunityList = TestDataFactory.OpportunityCreation(1, accountList[0]);
			database.insert(opportunityList);
			id opportunityId = opportunityList[0].id;
			system.assert(opportunityId!=null);
	  
			// Create an offer
			offerList = TestDataFactory.OfferCreation(1,opportunityList[0]);
			offerList[0].ActiveOffer__c = true;
			database.insert(offerList);
			id offerId = offerList[0].id;
			system.assert(offerId!=null);

	  
	  //creating content version
			ContentVersion  conVersionVar = TestDataFactory.createContentVersion_New(1,g4Material)[0];
			database.insert(conVersionVar);
			
			
			List<ContentVersion> conVersion = [SELECT ContentDocumentId,Document_Type_POC__c FROM ContentVersion 
	 where ID =: conVersionVar.Id LIMIT 1]; 
			
			//creating confidential file
			Confidential_File__c ConfidentialFile = TestDataFactory.createConfidentialFile(conVersion[0].ContentDocumentId, offerId, accountId);
			insert ConfidentialFile;
			set<id> docIdSet = new Set<Id>(); 
			docIdSet.add(conVersion[0].ContentDocumentId);
			//creating contentDocumentLink to share file with Non NSA user
			List<ContentDocumentLink> conDocumentLink1 = TestDataFactory.createContentDocumentLink_New(1,offerId,conVersion[0].ContentDocumentId);
	  List<ContentDocumentLink> conDocumentLink2 = TestDataFactory.createContentDocumentLink_New(1,userList[1].Id,conVersion[0].ContentDocumentId);
	  conDocumentLink2[0].ShareType = 'V'; 
	  Test.startTest(); 
	  database.insert(conDocumentLink1);
			database.insert(conDocumentLink2); 
			ContentDocumentLinkHelper.restrictFileSharing(docIdSet);
	  ContentDocumentLinkHelper.createFileRecord(conDocumentLink1);
			Test.stoptest();
		}
  }
  static testMethod void confidentialFile()
	{   
		List<Account> accountList = new List<Account>();
		List<Opportunity> opportunityList = new List<Opportunity>();
		List<Offer__c> offerList = new List<Offer__c>();
		List<user> userList = new List<User>();
		Set<Id> conVersionIdSet = new Set<Id>();
	
		
		userList = TestDataFactory.userCreation(2, GlobalConstants.SYSTEM_AdMINISTRATOR);
	userList[1].NSA_Compliant__c = false;
		database.insert(userList); 
		system.runAs(userList[0])
		{
	  //Create an account
			accountList = TestDataFactory.createAccount(1);
	  accountList[0].Customer_Compliance__c = 'US_Govern';
			database.insert(accountList);
			id accountId  = accountList[0].id;
			system.assert(accountId!=null);
			
			// create an opportunity			
			opportunityList = TestDataFactory.OpportunityCreation(1, accountList[0]);
			database.insert(opportunityList);
			id opportunityId = opportunityList[0].id;
			system.assert(opportunityId!=null);
	  
			// Create an offer
			offerList = TestDataFactory.OfferCreation(1,opportunityList[0]);
			offerList[0].ActiveOffer__c = true;
			database.insert(offerList);
			id offerId = offerList[0].id;
			system.assert(offerId!=null);
	  
	  Set<Id> opptyIdset = new Set<Id>();
	  opptyIdset.add(opportunityList[0].id);
	  Set<Id> offerIdset = new Set<Id>();
	  offerIdset.add(offerList[0].id);
	  //creating content version
		ContentVersion  conVersionVar = TestDataFactory.createContentVersion_New(1,g4Material)[0];
		conVersionVar.RecordTypeId = Schema.SObjectType.ContentVersion.getRecordTypeInfosByDeveloperName().get(confidentialOffer).getRecordTypeId();
			database.insert(conVersionVar);
			Map<Id, ContentVersion> documentVersionMap = new Map<Id, ContentVersion>();
			
			List<ContentVersion> conVersion = [SELECT ContentDocumentId,Document_Type_POC__c FROM ContentVersion 
	 where ID =: conVersionVar.Id LIMIT 1]; 
			documentVersionMap.put(conVersion[0].id, conVersion[0] );
			//creating confidential file
			Confidential_File__c ConfidentialFile = TestDataFactory.createConfidentialFile(conVersion[0].ContentDocumentId, offerId, accountId);
			insert ConfidentialFile;
			set<id> docIdSet = new Set<Id>(); 
			docIdSet.add(conVersion[0].ContentDocumentId);
			//creating contentDocumentLink to share file with Non NSA user
			List<ContentDocument> contentDocumentToUpdate = new List<ContentDocument>();
	  List<ContentDocumentLink> conDocumentLink2 = TestDataFactory.createContentDocumentLink_New(1,offerList[0].Id,conVersion[0].ContentDocumentId);
	  conDocumentLink2[0].ShareType = 'V';
	  List<ContentDocumentLink> conDocumentLink3 = TestDataFactory.createContentDocumentLink_New(1,ConfidentialFile.Id,conVersion[0].ContentDocumentId);
	  conDocumentLink3[0].ShareType = 'V'; 
	  
	  Test.startTest(); 
	  conVersionVar.Title = 'Test Title';
	  update conVersionVar;
			database.insert(conDocumentLink2);
	  //database.insert(conDocumentLink3); 
	  ContentDocumentLinkHelper.shareWithAllUsers(conDocumentLink2);
			ContentDocumentLinkHelper.restrictFileSharing(docIdSet);
	  ContentDocumentLinkHelper.getOfferMasterAccounts(opptyIdset);
	  ContentDocumentLinkHelper.getOpptyMasterAccounts(offerIdset);
	  ContentDocumentLinkHelper.shareWithConfidential(conDocumentLink2, documentVersionMap, opptyIdset, offerIdset);
			ID jobID = System.enqueueJob(new ConfidentialFileOwnerChange(contentDocumentToUpdate));
			Test.stoptest();
		}
  }
  static testMethod void convertLeadTest()
	{   
		user userList = new User();	 
		userList = CustomLeadConversionTest.createSystemAdminUser();
		System.runAs(userList){
			TestDataFactory.createCollaborationGroupsAndCustomSettings();
			Schema.DescribeFieldResult dfr = Schema.sObjectType.Lead.Fields.Indirect_Reseller__c;
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
	 User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
	 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
	 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id );
	 
	database.insert(userPRM); 
		Account accountCreation1 = TestDataFactory.createAccount(1)[0];
			accountCreation1.AccountNumber = '12345612'; 
			database.insert(accountCreation1);
			//End Customer Legal Entity Account Creation
			Account accountCreationLegalEntity = TestDataFactory.createAccount(1)[0];
			accountCreationLegalEntity.AccountNumber = '1234001'; 
			accountCreationLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(GlobalConstants.LEGAL_ENTITY_RECORD_TYPE).getRecordTypeId();
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
			Test.startTest();
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
			//pc.Country_Headquarters__c = 'Albania';
			pc.Market__c = 'Market Asia Pacific & Japan';
			pc.Partner_Type__c = 'Distributor';
			Database.insert(pc);
			
			List<Lead> leadList = new  List<Lead>();
			leadList = TestDataFactory.createLead(1);
			leadList[0].RecordTypeId  = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(GlobalConstants.INDIRECT_DEAL_REGISTRATION_RECORD_TYPE).getRecordTypeId();
			leadList[0].email = 'test.junrel@lead.com';
			leadList[0].End_Customer_Legal_Entity_Account__c = accountCreationLegalEntity.Id;
			leadList[0].Rejection_Status_For_Approval__c = 'Pending';
			leadList[0].Distributor_Partner_Company__c = pc.Id;
			leadList[0].OwnerId = userPRM.id;
		leadList[0].Distributor_Account__c = accountCreation1.id;
			insert leadList; 
			//creating content version
	ContentVersion  conVersionVar = TestDataFactory.createContentVersion_New(1,'N/A')[0];
	conVersionVar.RecordTypeId = Schema.SObjectType.ContentVersion.getRecordTypeInfosByDeveloperName().get(unrestrictedOther).getRecordTypeId();
	  
	insert conVersionVar;
	
	List<ContentVersion> conVersion = [SELECT ContentDocumentId,Document_Type_POC__c FROM ContentVersion 
	  where ID =: conVersionVar.Id LIMIT 1];			
	//creating contentDocumentLink
	list<ContentDocumentLink> contentDocumentLinkList = new list<ContentDocumentLink>();
	contentDocumentLinkList = TestDataFactory.createContentDocumentLink_New(1,leadList[0].Id,conVersion[0].ContentDocumentId);
	insert contentDocumentLinkList; 
	
			product2 prod = new product2();
			prod.name = '5G';
			prod.CurrencyIsoCode = 'USD';
			//prod.Business_Group__c='NSW';
			prod.Business_Group__c='CNS'; //NEW VALUE (CNS, MN, NI)
			prod.Family= 'NSW-EB';
			prod.IsActive=True;
			prod.Partner_Visible__c=True;
			prod.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get(GlobalConstants.BUSINESS_LINE_RECORD_TYPE).getRecordTypeId();
			insert prod;
			DealProduct__c  dp = new DealProduct__c ();
			dp.BusinessLine__c = prod.id;
			dp.Deal__c = leadList[0].Id;
			dp.Value__c = 50.0;		 
			insert dp;
			Nokia_Financial_Calendar__c nokiaFinCal = TestDataFactory.nokiaFinCalCreation(1)[0];
			database.insert(nokiaFinCal);
	
	  // Test.starttest();
			List<Opportunity> oppty= TestDataFactory.OpportunityCreation(1, accountCreation);
			String OpptyName='TestOppty';
	 //String concatenatedErrorMessage= CustomLeadConversion.ConvertLead(leadList[0].Id, accountCreation.Id, OpptyName);
	
		 LeadConversionTriggerHelper.ConversionFutureMethod(leadList[0].Id);
			CustomLeadConversion.getLeadDeatils(leadList[0].Id);
			Test.stoptest();
			CustomLeadConversion.getContactDeatils(leadList[0].OwnerId);
			CustomLeadConversion.getName(oppty[0].id);
	System.assertEquals(true, OpptyName.contains('TestOppty'));
	
	
		}  
	}
	
	static testMethod void Sharecqfileto_CqReportTest(){
		List<Account> accountList = new List<Account>();
		List<Opportunity> opportunityList = new List<Opportunity>();
		List<Offer__c> offerList = new List<Offer__c>();
		List<user> userList = new List<User>();
		Set<Id> conVersionIdSet = new Set<Id>();
		

		
		userList = TestDataFactory.userCreation(2, GlobalConstants.SYSTEM_AdMINISTRATOR);
		userList[1].NSA_Compliant__c = false;
		database.insert(userList); 
		system.runAs(userList[0]){
			
			//Create an account
			accountList = TestDataFactory.createAccount(1);
			accountList[0].Customer_Compliance__c = 'US_Govern';
			database.insert(accountList);
			id accountId  = accountList[0].id;
			system.assert(accountId!=null);
			
			// create an opportunity			
			opportunityList = TestDataFactory.OpportunityCreation(1, accountList[0]);
			database.insert(opportunityList);
			id opportunityId = opportunityList[0].id;
			system.assert(opportunityId!=null);
	  
			// Create an offer
			offerList = TestDataFactory.OfferCreation(1,opportunityList[0]);
			offerList[0].ActiveOffer__c = true;
			database.insert(offerList);
			id offerId = offerList[0].id;
			system.assert(offerId!=null);

	  
		//creating content version
			ContentVersion  conVersionVar = TestDataFactory.createContentVersion_New(1,g4Material)[0];
			database.insert(conVersionVar);
			
			
			List<ContentVersion> conVersion = [SELECT ContentDocumentId,Document_Type_POC__c FROM ContentVersion 
	 where ID =: conVersionVar.Id LIMIT 1]; 
			
			//creating confidential file
			Confidential_File__c ConfidentialFile = TestDataFactory.createConfidentialFile(conVersion[0].ContentDocumentId, offerId, accountId);
			insert ConfidentialFile;
			set<id> docIdSet = new Set<Id>(); 
			docIdSet.add(conVersion[0].ContentDocumentId);
			//creating contentDocumentLink to share file with Non NSA user
			List<ContentDocumentLink> conDocumentLink1 = TestDataFactory.createContentDocumentLink_New(1,offerId,conVersion[0].ContentDocumentId);
			List<ContentDocumentLink> conDocumentLink2 = TestDataFactory.createContentDocumentLink_New(1,userList[1].Id,conVersion[0].ContentDocumentId);
			conDocumentLink2[0].ShareType = 'V'; 
			Test.startTest(); 
			database.insert(conDocumentLink1);
			database.insert(conDocumentLink2);
			ContentDocumentLinkHelper.restrictFileSharing(docIdSet);
		ContentDocumentLinkHelper.Sharecqfileto_CqReport(conDocumentLink1);
			Test.stoptest();
		}
	}
	
	@isTest
	public static void CPQReleatedTest(){
		List<Account> accLst = new List<Account>();
		List<Opportunity> opportunityList = new List<Opportunity>();
		accLst = TestDataFactory.createAccount(1);
		database.insert(accLst);
		
		// create an opportunity	  
		opportunityList = TestDataFactory.OpportunityCreation(1, accLst[0]);
		opportunityList[0].StageName ='Create Offer (Bid)';
		opportunityList[0].recordtypeid='01241000001HzdS';
		opportunityList[0].Phase_Status__c= 'Offer in Progress';
		database.insert(opportunityList);
		List<Apttus_Proposal__Proposal__c> aptPro= TestDataFactory.createCQ(1, accLst[0], opportunityList[0]);
		database.insert(aptPro);
		
		List<ContentVersion> contVer = TestDataFactory.createContentVersion(1);
		Test.startTest();
		database.insert(contVer);
		List<ContentDocumentLink> contLnk = TestDataFactory.createContentDocumentLink_New(1, aptPro[0].Id, [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contVer[0].Id][0].ContentDocumentId);
		
		database.insert(contLnk);
		Test.stopTest();
		
		
		
		PermissionSet pset=[Select Id from PermissionSet
							where PermissionSet.Name=:GlobalConstants.CQ_Business_admin];
		
		Profile p1 = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
		User u1 = new User(Alias = 'testpar1', Email='partnersupport1@supportpartner.co', 
						   EmailEncodingKey='UTF-8', LastName='PartnerSupport1', LanguageLocaleKey='en_US', 
						   LocaleSidKey='en_US', ProfileId = p1.Id, 
						   TimeZoneSidKey='America/Los_Angeles', UserName='partneruser@organization.com');
		insert u1;
		
		
		System.runAs([SELECT Id FROM User where Id=:UserInfo.getUserId()][0]){
			PermissionSetAssignment passign = new PermissionSetAssignment();
			passign.AssigneeId =u1.Id;
			passign.PermissionSetId = pset.id;
			insert passign;
		}
		
		System.runAs(u1){
			ContentDocumentLinkHelper.throwerroronCQ_FileUpload(contLnk);
		}
		
	}
	
	@isTest
	public static void PS_FileShareWithPartnersTest(){
		
		ID caseRectype = Schema.describeSObjects(new List<String> {'Case'})[0].getRecordTypeInfosByDeveloperName().get('PS_Partner_Support').getRecordTypeId();
		
		ID accRectype = Schema.describeSObjects(new List<String> {'Account'})[0].getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		
		Account acc = new Account();
		acc.Name = 'PRM Test Account';
		acc.Partner_Status__c='Active';
		acc.recordTypeId = accRectype;
		insert acc;
		
		
		Profile p1 = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
		User u1 = new User(Alias = 'testpar1', Email='partnersupport1@supportpartner.co', 
						   EmailEncodingKey='UTF-8', LastName='PartnerSupport1', LanguageLocaleKey='en_US', 
						   LocaleSidKey='en_US', ProfileId = p1.Id,
						   TimeZoneSidKey='America/Los_Angeles', UserName='partneruser@organization.com');
		insert u1;
		
		
		
		Case c = new Case();
		c.AccountId = acc.Id;
		c.RecordTypeId = caseRectype;
		c.Issue_Reported_By__c = u1.Id;
		c.Subject = 'Test Subject';
		c.Description = 'Test Description';
		c.Type = 'Compliance';
		
		insert c;
		
		List<ContentVersion> conve1 = TestDataFactory.createContentVersion(1);
		Test.startTest();
		database.insert(conve1);
		
		List<ContentDocumentLink> contLnk1 = TestDataFactory.createContentDocumentLink_New(1, c.id, [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :conve1[0].Id][0].ContentDocumentId);
		
		database.insert(contLnk1);
		Test.stopTest();
		
	}

}