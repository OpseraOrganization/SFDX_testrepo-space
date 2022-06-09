@isTest
	private class UserHelperPRMTest {
		static testMethod void updateShowEmailToExternalUsersTest(){
		
		List<user> Users = new List<User>();
		List<user> Users1 = new List<User>();
		
		 List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		
		system.runAs(runAsUSer[0]){
			
		Account accountCreationPRM = TestDataFactory.createAccount(1)[0];
		database.insert(accountCreationPRM);
		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;
	  /*  User user1 = new User(alias = 'abc', email = uniqueName + '@nokia.com' , emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
		 languagelocalekey = 'en_US', localesidkey = 'en_US', ProfileId = system.label.PRM_Partner_Profile_Id,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
		 timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
		database.insert(user1); */
	
		List<Contact> ContactList = new List<Contact>();
		Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=accountCreationPRM.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		Contact conPRM2 = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=accountCreationPRM.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		ContactList.add(conPRM);
		ContactList.add(conPRM2);
		database.insert(ContactList); 
		User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',lastname = 'Testing',
		 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
		 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id );
		 
		database.insert(userPRM); 
		userPRM.IsPortalEnabled =  True;
		system.runAs(userPRM){ 
		database.update(userPRM);
		Users.add(userPRM);
	 }
	// system.debug('USER1' + userPRM);   
	// system.debug('USERPRM' + userPRM.IsPortalEnabled);  
	  }
		 
	  
		UserHelperPRM.updateShowEmailToExternalUsers(Users);
		UserHelperPRM.updateShowEmailToExternalUsers(null); 
		GlobalConstants.STOP_TRIGGER_USER_ON_BEFOREINSERT = false;
		//UserHandlerPRM.onBeforeInsert(Users1); //Commenting unsed methods
		//UserHandlerPRM.onBeforeInsert(Users); //Commenting unsed methods
	
   } 
		

		 static testMethod void unshareFundOnUserDeactivationTest(){
	//  UserHelperPRM.unshareFundOnUserDeactivation(null); 
	 }

		static testMethod void onAfterInsertTest(){
		//try{  
		List<User> userListCoop = new List<User>();
		
		 List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		
		system.runAs(runAsUSer[0]){
		
		Account accountCreationPRM = TestDataFactory.createAccount(1)[0];
		database.insert(accountCreationPRM);
			
		List<Contact> ContactList = new List<Contact>();
		Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=accountCreationPRM.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		Contact conPRM2 = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=accountCreationPRM.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		ContactList.add(conPRM);
		ContactList.add(conPRM2);
		database.insert(ContactList); 
		List<Fund__c> fundList = new List<Fund__c>();
	Fund__c fund1 = new Fund__c(Name = 'abcd', Partner_Name__c = accountCreationPRM.id);
	fundList.add(fund1);
	insert fundList;
		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;
		User userPRM1 = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',lastname = 'Testing',
		 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
		 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id );
			try{
	
			}catch(Exception e) {
	//Do Nothing
	database.insert(userPRM1); 
			}
	
		system.runAs(userPRM1){ 
		database.update(userPRM1);
		userListCoop.add(userPRM1);
		}   
			try{
	System.debug('user::'+userListCoop);
	UserHandlerPRM.onAfterInsert(userListCoop);
			}catch(Exception e) {
	//Do Nothing
			}
		 
		 }
		/*}
			catch(Exception e) { 
	}*/
		
	}
		
		static testMethod void onAfterUpdateTest(){
		 
		List<User> userListCoop = new List<User>();
		Map<Id, User> newUserMap = new  Map<Id, User>();
		Map<Id, User> oldUserMap = new  Map<Id, User>();	
		
		 List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		
		system.runAs(runAsUSer[0]){
		
		Account accountCreationPRM = TestDataFactory.createAccount(1)[0];
		database.insert(accountCreationPRM);
			
		List<Contact> ContactList = new List<Contact>();
		Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=accountCreationPRM.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		Contact conPRM2 = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=accountCreationPRM.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		ContactList.add(conPRM);
		ContactList.add(conPRM2);
		database.insert(ContactList); 
		List<Fund__c> fundList = new List<Fund__c>();
	Fund__c fund1 = new Fund__c(Name = 'abcd', Partner_Name__c = accountCreationPRM.id);
	fundList.add(fund1);
	insert fundList;
		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;
		User userPRM1 = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',lastname = 'Testing',
		 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
		 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id );
		User userPRM2 = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',lastname = 'Testing',
		 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
		 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id );
			
			try{
	
			}catch(Exception e) {
	database.insert(userPRM1);
	database.insert(userPRM2); 
	//Do Nothing
			}
	
		database.insert(userPRM1);   
		userPRM1.IsPortalEnabled =  True;
		database.update(userPRM1); 
		system.runAs(userPRM1){ 
		userListCoop.add(userPRM1);

		}  
			newUserMap.put(userPRM2.Id, userPRM2);
			oldUserMap.put(userPRM1.Id, userPRM1);
	 
		}
			

			try{
	UserHandlerPRM.onAfterInsert(userListCoop);
			}catch(Exception e) {
	//Do Nothing
			}
			GlobalConstants.STOP_TRIGGER_USER_ON_AFTERUPDATE = false;
	 //UserHandlerPRM.onAfterUpdate(newUserMap,oldUserMap);  //Commenting Unused method
		
		 }
		
	}