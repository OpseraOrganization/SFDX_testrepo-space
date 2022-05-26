@isTest
public class ContentVersionTriggerHelperPRMTest {
	 @testSetup static void createTestData() {
			NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
			cs.Name = 'Default';
			cs.Customer_Account__c = 'Customer - test';
			cs.Customer_Account_Number__c = '12345';
			cs.Customer_User_Profile__c = 'Customers';
			insert cs;
		}

		
	static testMethod void restrictFileDeleteOnClaimTest()
	{   
			
		Account acc = new Account();
		acc = TestDataFactory.createAccount(1)[0];
		acc.Enrolled_in_Co_Op__c = true;
		// acc.CurrencyIsoCode = 'EUR';
		insert acc;
		
		List<Fund__c> fundList = new List<Fund__c>();
		Fund__c fund1 = new Fund__c(Name = 'abcd', Partner_Name__c = acc.id);
		fundList.add(fund1);
		insert fundList;
		
		list<Co_Op_Activity__c> activityList = new list<Co_Op_Activity__c>();
		Co_Op_Activity__c activity1 = new Co_Op_Activity__c(Name = 'test', Partner_Account__c = acc.id, Fund_Id__c = fundList[0].id,Activity_Type__c = 'Advertising', Start_Date__c = system.today()+15, End_Date__c = system.today()+100,  Activity_Status__c = 'New',Cost_of_Activity__c = 300.00,Reimbursement_Amount_Requested__c =200.00);
		activityList.add(activity1);
		insert activityList;
		
		list<Claim__c> claimList = new list<Claim__c>();
		Claim__c claim1 = new Claim__c(Partner_Account__c = acc.id, Fund__c= fund1.id, Activity_Number__c = activity1.id, /*HFLOF_Amount__c = 10.00*/ Claim_Status__c = 'Submitted', Claim_Amount_Passed_Audit__c = 900.00, Activity_Claim_Amount__c = 30.0,I_have_uploaded_all_proof_of_performance__c = 'Yes');
		claimList.add(claim1);
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
		ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersionInsert.Id LIMIT 1];
		system.debug('contentVersionSelect'+contentVersionSelect);
		ContentDocumentLink contentDocLink = new ContentDocumentLink();
		contentDocLink.ContentDocumentId = contentVersionSelect.ContentDocumentId;
		contentDocLink.LinkedEntityId = claimList[0].id;
		contentDocLink.ShareType = 'v';
		insert contentDocLink;
		ContentVersionHandlerPRM.restrictNewVersionUploadOnClaim(contentVersionSelect);
		ContentVersionHandlerPRM.restrictNewVersionUpload(contentVersionSelect);
		ContentVersionHandlerPRM.restrictNewVersionUploadOnClaim(null);
		ContentVersionHandlerPRM.restrictNewVersionUpload(null);
		
		Test.stoptest();
			
		   
		}
}