@isTest
Private class DS_SWMPExecSummaryTest{

   /******************************
	*Method Name: getAccountAttchmentTest
	*Description: Test Method to cover DS_ExecSummaryTest class
	********************************/
static testmethod void getAccountAttchmentTest(){
try{
	  User sysAdminUser = TestDataFactory.createSystemAdminUser();
		System.runAs(sysAdminUser){
	  
		Account accountCreationDP = TestDataFactory.createAccount(1)[0];
		database.insert(accountCreationDP);
		Test.startTest();
		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;
		
		
		User user1 = new User(alias = 'abc', email = uniqueName + '@nokia.com' , emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
								 languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid = UserInfo.getProfileId(),  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
								 timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
		database.insert(user1); 
		
	   
		List<Contact> ContactList = new List<Contact>();
		Contact conDS = new Contact(lastName=CSWXGlobalConstant.ContactNameDS,AccountId=accountCreationDP.id,Email=CSWXGlobalConstant.EmailContactNameDS );
		Contact conDS2 = new Contact(lastName=CSWXGlobalConstant.ContactNameDS,AccountId=accountCreationDP.id,Email=CSWXGlobalConstant.EmailContactNameDS );
		ContactList.add(conDS);
		ContactList.add(conDS2);
		database.insert(ContactList); 
		
		User userDS = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',lastname = 'Testing',
								 languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid = '00e410000022ds8'/*system.Label.PRM_Partner_Relationship_Manager_Login_ID*/,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
								 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '00',ContactId  = conDS.Id );
		
		
		  system.runAs(user1){						
		database.insert(userDS); 
		
		userDS.IsPortalEnabled =  True;
		
		database.update(userDS);
		}
	Test.stopTest();
	   
	 
		
	   ContentVersion contentVersion = new ContentVersion();
		ContentDocumentLink contentlink = new ContentDocumentLink();
	 
		
		contentVersion = TestDataFactory.createContentVersion(1)[0]; 
		contentVersion.title = 'Catalogue Executive Summary';
		database.insert(contentVersion) ;					 
		
		Id theContentDocumentId = [select ContentDocumentId from ContentVersion where Id =: contentVersion.Id limit 1].ContentDocumentId;		
		
		contentlink = TestDataFactory.createContentDocumentLink(1,accountCreationDP.Id, theContentDocumentId)[0];
		database.insert(contentlink) ;  
	 
	  System.runAs(userDS) {
	  
			DS_SWMPExecSummary.getCurrentUserData();
			DS_SWMPExecSummary.getAccountAttachment(); 
		}
		 }
		 
	  }catch (Exception ex) { ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_TabRenderingTest,CSWXGlobalConstant.createTestDP);
			
	   }   
	}
	
	/******************************
	*Method Name: getAccountAttchmentNegativeTest
	*Description: Test Method to cover DS_ExecSummaryTest getAccountAttchment methods' catch block
	********************************/	
   static testmethod void getAccountAttchmentNegativeTest(){
			   
		Account accObj = TestDataFactory.createAccount(1)[0]; 
		accObj.AccountNumber = '30100596190';
		database.insert(accObj);

  
		Contact contact_1 = new Contact(AccountId = accObj.Id, LastName = 'xgeek');
		insert contact_1;
		  
		User user = TestDataFactory.userCreation(1,'System Administrator')[0]; 
		
		insert user;	   
		system.runAs(user){
		DS_SWMPExecSummary.getCurrentUserData();
		DS_SWMPExecSummary.getAccountAttachment(); 
			
		   }
		   }   
}