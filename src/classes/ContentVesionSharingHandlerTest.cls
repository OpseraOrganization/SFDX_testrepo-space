@IsTest

//Test Class for Account Trigger
private class ContentVesionSharingHandlerTest {

   static testMethod void shareWithAllUsersTest() {
		List<Account> accountList = TestDataFactory.createAccount(1);
		database.insert(accountList);
		id accountId  = accountList[0].id;
		system.assert(accountId!=null);
		
		// create an opportunity			
		List<Opportunity> opportunityList = TestDataFactory.OpportunityCreation(1, accountList[0]);
		database.insert(opportunityList);
		id opportunityId = opportunityList[0].id;
		system.assert(opportunityId!=null);
		Test.startTest();		   
		
		ContentVersion  conVersionVar =  TestDataFactory.createContentVersion_New(1,'N/A')[0];
		conVersionVar.Share_with_External_Users__c  = true;
		database.insert(conVersionVar);  
		
		List<ContentVersion> conVersion = [SELECT ContentDocumentId,Document_Type_POC__c FROM ContentVersion 
										   where ID =: conVersionVar.Id LIMIT 1];			
		//creating contentDocumentLink
		ContentDocumentLink conDocumentLink = TestDataFactory.createContentDocumentLink_New(1,opportunityId,conVersion[0].ContentDocumentId)[0];
		database.insert(conDocumentLink);
		
		conVersionVar.Share_with_External_Users__c  = false; 
		database.update(conVersionVar); 
	}
	
	 static testMethod void ConfiFileTriggerTest(){
		 List<Account> accountList = TestDataFactory.createAccount(1);
		accountList[0].Customer_Compliance__c = 'US_Govern';
		database.insert(accountList);
		id accountId  = accountList[0].id;
		system.assert(accountId!=null);
		
		// create an opportunity			
		List<Opportunity> opportunityList = TestDataFactory.OpportunityCreation(1, accountList[0]);
		database.insert(opportunityList);
		id opportunityId = opportunityList[0].id;
		system.assert(opportunityId!=null);
		
		// Create an offer
		List<Offer__c> offerList = TestDataFactory.OfferCreation(1,opportunityList[0]);
		offerList[0].ActiveOffer__c = true;
		database.insert(offerList);
		id offerId = offerList[0].id;
		system.assert(offerId!=null);
		
		
		//creating content version
		ContentVersion  conVersionVar2 = TestDataFactory.createContentVersion_New(1,'G4 Material')[0];
		database.insert(conVersionVar2);
		
		Test.startTest();	
		
		List<ContentVersion> conVersion = [SELECT ContentDocumentId,Document_Type_POC__c FROM ContentVersion 
							   where ID =: conVersionVar2.Id LIMIT 1];	   
		
		//creating confidential file
		Confidential_File__c ConfidentialFile = TestDataFactory.createConfidentialFile(conVersion[0].ContentDocumentId, offerId, accountId);
		insert ConfidentialFile;		 
		 try{
			 delete ConfidentialFile;
		 }catch(Exception exc){
		 
		 }
		  Test.stoptest();
	 }
}