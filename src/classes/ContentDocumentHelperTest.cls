/****************************************
 * Name : ContentDocumentHandlerTest
 * Author : Accenture
 * Description : Test class for ContentDocumentHandler
 *****************************************/
@istest
private class ContentDocumentHelperTest {
  static testMethod void checkUncheckOpportunityPTAFLagOnDeleteTest()
  {	
	List<Account> accountList = new List<Account>();
	List<Opportunity> opportunityList = new List<Opportunity>();
	List<user> userList = new List<User>();
	
	userList = TestDataFactory.userCreation(1, 'System Administrator');
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
	  List<ContentVersion>  conVersionVar = TestDataFactory.createContentVersion_New(2,GlobalConstants.PTAFlag);
	  database.insert(conVersionVar);
	  
	  List<ContentVersion> conVersion = [SELECT ContentDocumentId,Document_Type_POC__c FROM ContentVersion 
	where ID =: conVersionVar[0].Id or ID =: conVersionVar[1].Id  LIMIT 2];	  
	  //creating contentDocumentLink
	  List<ContentDocumentLink> conDocumentLink = TestDataFactory.createContentDocumentLink_New(2,opportunityId,conVersion[0].ContentDocumentId);
	conDocumentLink[0].ContentDocumentId = conVersion[0].ContentDocumentId;
	conDocumentLink[1].ContentDocumentId = conVersion[1].ContentDocumentId;
	  database.insert(conDocumentLink); 
	  
	  List<ContentDocument> conDoc = [SELECT Id,IsDeleted FROM ContentDocument 
	where ID =: conVersion[0].ContentDocumentId LIMIT 1];
	  Database.delete(conDoc, False); 
	  
	  Test.stoptest();
	}
  }
  
  static testMethod void checkUncheckOfferSSOFlagOnDeleteTest()
  {	
	List<Account> accountList = new List<Account>();
	List<Opportunity> opportunityList = new List<Opportunity>();
	List<Offer__c> offerList = new List<Offer__c>();
	List<user> userList = new List<User>();
	
	userList = TestDataFactory.userCreation(1, 'System Administrator');
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
	  
	  
	  // Create an offer
	  offerList = TestDataFactory.OfferCreation(1,opportunityList[0]);
	  offerList[0].ActiveOffer__c = true;
	  database.insert(offerList);
	  id offerId = offerList[0].id;
	  system.assert(offerId!=null);
  
	  Test.startTest(); 
	//creating content version
	  List<ContentVersion>  conVersionVar = TestDataFactory.createContentVersion_New(2,GlobalConstants.SSOFlag);
	  database.insert(conVersionVar);
	  
	  List<ContentVersion> conVersion = [SELECT ContentDocumentId,Document_Type_POC__c FROM ContentVersion 
	where ID =: conVersionVar[0].Id or ID =: conVersionVar[1].Id LIMIT 2];	  
	  //creating contentDocumentLink
	  List<ContentDocumentLink> conDocumentLink = TestDataFactory.createContentDocumentLink_New(2,offerId,conVersion[0].ContentDocumentId);
	conDocumentLink[0].ContentDocumentId = conVersion[0].ContentDocumentId;
	conDocumentLink[1].ContentDocumentId = conVersion[1].ContentDocumentId;
	  database.insert(conDocumentLink); 
	  
	  ContentDocument conDoc = new ContentDocument(Id=conVersion[0].ContentDocumentId);
	  Database.delete(conDoc, False);
	  
	  Test.stoptest();
	}
  }
  
  static testMethod void  checkUncheckOpportunityBOMFlagOnDeleteTest()
  {	
	List<Account> accountList = new List<Account>();
	List<Opportunity> opportunityList = new List<Opportunity>();
	List<user> userList = new List<User>();
	
	userList = TestDataFactory.userCreation(1, 'System Administrator');
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
	  
	  Test.startTest();
	  //creating content version
	  List<ContentVersion>  conVersionVar = TestDataFactory.createContentVersion_New(2,GlobalConstants.BOMBOQFlag);
	  database.insert(conVersionVar);
	  
	  List<ContentVersion> conVersion = [SELECT ContentDocumentId,Document_Type_POC__c FROM ContentVersion 
	where ID =: conVersionVar[0].Id or ID =: conVersionVar[1].Id  LIMIT 2];	  
	  //creating contentDocumentLink
	  List<ContentDocumentLink> conDocumentLink = TestDataFactory.createContentDocumentLink_New(2,preSalesOppId,conVersion[0].ContentDocumentId);
	conDocumentLink[0].ContentDocumentId = conVersion[0].ContentDocumentId;
	conDocumentLink[1].ContentDocumentId = conVersion[1].ContentDocumentId;
	  database.insert(conDocumentLink); 

	  ContentDocument conDoc = new ContentDocument(Id=conVersion[0].ContentDocumentId);
	  Database.delete(conDoc, False);
	  
	  Test.stoptest();
	}
  }
  
  
  static testMethod void coveringElseAndExceptionTest()
  {   

  List<ContentDocumentLink> contentDoclist = new List<ContentDocumentLink>();
	List<user> userList = new List<User>();	
	userList = TestDataFactory.userCreation(1, 'System Administrator');
	database.insert(userList); 
  
	system.runAs(userList[0])
	{
	  Test.startTest();
	  ContentDocumentLinkHelper.determineObjectType(contentDoclist);
	ContentDocumentLinkHelper.determineObjectType(Null);
	ContentDocumentLinkHelper.checkUncheckOpportunityBOMFlagOnInsert(Null);
	ContentDocumentLinkHelper.checkUncheckOpportunityPTAFlagOnInsert(Null,Null);
	  Test.stoptest();
	}
  }
  
  static testMethod void checkUncheckOpportunityPTAFLagOnDeleteSingleDocTest()
  {	
	List<Account> accountList = new List<Account>();
	List<Opportunity> opportunityList = new List<Opportunity>();
	List<Offer__c> offerList = new List<Offer__c>();
	List<user> userList = new List<User>();
	Set<Id> conVersionIdSet = new Set<Id>();
	
	userList = TestDataFactory.userCreation(1, 'System Administrator');
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
	  List<ContentDocumentLink> conDocumentLink = TestDataFactory.createContentDocumentLink_New(1,opportunityId,conVersion[0].ContentDocumentId);
	  database.insert(conDocumentLink); 
	  
	  List<ContentDocument> conDoc = [SELECT Id,IsDeleted FROM ContentDocument 
	where ID =: conVersion[0].ContentDocumentId LIMIT 1];
	  Database.delete(conDoc, False); 
	  Database.Undelete(conDoc, False);
	  
	  Test.stoptest();
	}
  }
  
  static testMethod void checkUncheckOfferSSOFlagOnDeleteSingleDocTest()
  {	
	List<Account> accountList = new List<Account>();
	List<Opportunity> opportunityList = new List<Opportunity>();
	List<Offer__c> offerList = new List<Offer__c>();
	
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
	  
	  // Create an offer
	  offerList = TestDataFactory.OfferCreation(1,opportunityList[0]);
	  offerList[0].ActiveOffer__c = true;
	  database.insert(offerList);
	  id offerId = offerList[0].id;
	  system.assert(offerId!=null);
	  Test.startTest(); 
	
	//creating content version
	  ContentVersion  conVersionVar = TestDataFactory.createContentVersion_New(1,GlobalConstants.SSOFlag)[0];
	  database.insert(conVersionVar);
	  
	  List<ContentVersion> conVersion = [SELECT ContentDocumentId,Document_Type_POC__c FROM ContentVersion 
	where ID =: conVersionVar.Id LIMIT 1];	  
	  //creating contentDocumentLink
	  List<ContentDocumentLink> conDocumentLink = TestDataFactory.createContentDocumentLink_New(1,offerId,conVersion[0].ContentDocumentId);
	  database.insert(conDocumentLink); 
	  List<ContentDocument> conDoc = [SELECT Id,IsDeleted FROM ContentDocument 
	where ID =: conVersion[0].ContentDocumentId LIMIT 1];
	  Database.delete(conDoc, False);
	  Database.Undelete(conDoc, False);
	  Test.stoptest();
  }
  
  static testMethod void  checkUncheckOpportunityBOMFlagOnDeleteSingleDocTest()
  {	
	List<Account> accountList = new List<Account>();
	List<Opportunity> opportunityList = new List<Opportunity>();
	List<user> userList = new List<User>();
	Set<Id> conVersionIdSet = new Set<Id>();
	
	userList = TestDataFactory.userCreation(1, 'System Administrator');
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
		
	  
	  //changing oppty's stage Name and phase status
	  opportunityList[0].Apttus_Approval__Approval_Status__c = 'Approved';
	  opportunityList[0].StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
	  opportunityList[0].Phase_Status__c = 'Opportunity in Progress';
	  database.update(opportunityList[0]);
	  system.debug('optyCreationoptyCreationoptyCreation>>>>>>>>>>>>>>>>>>>>>>>>>'+ opportunityList[0]);
	  Test.startTest();
	  
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
	  List<ContentDocumentLink> conDocumentLink = TestDataFactory.createContentDocumentLink_New(1,preSalesOppId,conVersion[0].ContentDocumentId);
	  database.insert(conDocumentLink);
	  
	  List<ContentDocument> conDoc = [SELECT Id,IsDeleted FROM ContentDocument 
	where ID =: conVersion[0].ContentDocumentId LIMIT 1];
	  Database.delete(conDoc, False);
	  Test.stoptest();
	}
  }
  
  
  static testMethod void  addOrRemovePermissionSetOnUser()
  {	 
	List<user> userList = new List<User>();
  	userList = TestDataFactory.userCreation(1, 'System Administrator');
	database.insert(userList); 
	system.runAs(userList[0])
	{
		Test.startTest();
		List<user> userList1 = new List<User>();
		userList1 = TestDataFactory.userCreation(1, 'System Administrator');
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
	
	//Insert an File_Sharing_Custom_Setting
	List<File_Sharing_Custom_Setting__c>  fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>(); 
	fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
	Database.insert(fileSharingCustomSettingList);
	
	userList = TestDataFactory.userCreation(2, 'System Administrator');
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
		Test.startTest();
		// Create an offer
		offerList = TestDataFactory.OfferCreation(1,opportunityList[0]);
		offerList[0].ActiveOffer__c = true;
		database.insert(offerList);
		id offerId = offerList[0].id;
		system.assert(offerId!=null);


		//creating content version
		ContentVersion  conVersionVar = TestDataFactory.createContentVersion_New(1,'G4 Material')[0];
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
		List<ContentDocumentLink> conDocumentLink3 = TestDataFactory.createContentDocumentLink_New(1,ConfidentialFile.Id,conVersion[0].ContentDocumentId);
		conDocumentLink3[0].ShareType = 'V'; 
		database.insert(conDocumentLink1);
		database.insert(conDocumentLink2); 
		ContentDocumentLinkHelper.restrictFileSharing(docIdSet);
		Test.stoptest();
	}
  }
  static testMethod void confidentialFile()
  {	 
	List<Account> accountList = new List<Account>();
	List<Opportunity> opportunityList = new List<Opportunity>();
	List<Offer__c> offerList = new List<Offer__c>();
	List<user> userList = new List<User>();
	
	//Insert an File_Sharing_Custom_Setting
	List<File_Sharing_Custom_Setting__c>  fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>(); 
	fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
	Database.insert(fileSharingCustomSettingList);
	
	userList = TestDataFactory.userCreation(2, 'System Administrator');
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
		Test.startTest();
		// Create an offer
		offerList = TestDataFactory.OfferCreation(1,opportunityList[0]);
		offerList[0].ActiveOffer__c = true;
		database.insert(offerList);
		id offerId = offerList[0].id;
		system.assert(offerId!=null);


		//creating content version
		ContentVersion  conVersionVar = TestDataFactory.createContentVersion_New(1,'G4 Material')[0];
		database.insert(conVersionVar);


		List<ContentVersion> conVersion = [SELECT ContentDocumentId,Document_Type_POC__c FROM ContentVersion 
	where ID =: conVersionVar.Id LIMIT 1];	 

		//creating confidential file
		Confidential_File__c ConfidentialFile = TestDataFactory.createConfidentialFile(conVersion[0].ContentDocumentId, offerId, accountId);
		insert ConfidentialFile;
		set<id> docIdSet = new Set<Id>(); 
		docIdSet.add(conVersion[0].ContentDocumentId);
		//creating contentDocumentLink to share file with Non NSA user
		List<ContentDocument> contentDocumentToUpdate = new List<ContentDocument>();
		List<ContentDocumentLink> conDocumentLink2 = TestDataFactory.createContentDocumentLink_New(1,userList[1].Id,conVersion[0].ContentDocumentId);
		conDocumentLink2[0].ShareType = 'V';
		List<ContentDocumentLink> conDocumentLink3 = TestDataFactory.createContentDocumentLink_New(1,ConfidentialFile.Id,conVersion[0].ContentDocumentId);
		conDocumentLink3[0].ShareType = 'V'; 

		database.insert(conDocumentLink2); 
		ContentDocumentLinkHelper.restrictFileSharing(docIdSet);
		ID jobID = System.enqueueJob(new ConfidentialFileOwnerChange(contentDocumentToUpdate));
		Test.stoptest();
	}
  }
  /* static testMethod void restrictFileDeleteOnClaimTest()
  {   
	  
	Account acc = new Account();
	  acc = TestDataFactory.createAccount(1)[0];
	  acc.Enrolled_in_Co_Op__c = true;
	  insert acc;
	  
	  Fund__c fund1 = [Select Id from Fund__c where Partner_Name__c = :acc.id and PRM_Main_Fund__c = true limit 1];
	  
	  list<Co_Op_Activity__c> activityList = new list<Co_Op_Activity__c>();
	  Co_Op_Activity__c activity1 = new Co_Op_Activity__c(Name = 'test', Partner_Account__c = acc.id, Fund_Id__c = fund1.id,Activity_Type__c = 'Advertising', Start_Date__c = system.today()+15, End_Date__c = system.today()+100,  Activity_Status__c = 'New',Cost_of_Activity__c = 300.00,Reimbursement_Amount_Requested__c =200.00);
	  activityList.add(activity1);
	  insert activityList;
	  
	  list<Claim__c> claimList = new list<Claim__c>();
	 // Claim__c claim1 = new Claim__c(Partner_Account__c = acc.id, Fund__c= fund1.id, Activity_Number__c = activity1.id, /*HFLOF_Amount__c = 10.00*/ // Claim_Status__c = 'Submitted', Claim_Amount_Passed_Audit__c = 900.00, Activity_Claim_Amount__c = 30.0,I_have_uploaded_all_proof_of_performance__c='Yes');
	  /*claimList.add(claim1);
	  insert claimList;
	  Test.startTest();	
	  //creating content version
	  ContentVersion contentVersionInsert = new ContentVersion(
	  Title = 'Test',
	  PathOnClient = 'Test.jpg',
	  VersionData = Blob.valueOf('Test Content Data'),
	  IsMajorVersion = true
	);
	insert contentVersionInsert;

	List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
	ContentDocumentLink contentDocLink = new ContentDocumentLink();
	contentDocLink.ContentDocumentId = documents[0].id;
	 contentDocLink.LinkedEntityId = claimList[0].id;
	contentDocLink.ShareType = 'v';
	 insert contentDocLink;
	ContentDocumentHandlerPRM.restrictFileDeleteOnClaim(documents);
	  ContentDocumentHandlerPRM.restrictDeletion(documents);
	ContentDocumentHandlerPRM.restrictFileDeleteOnClaim(null);
	ContentDocumentHandlerPRM.restrictDeletion(null);
	  Test.stoptest();
	}*/
}