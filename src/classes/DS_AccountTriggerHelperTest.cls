/****************************************
* Name : DS_AccountTriggerHelperTest
* Author : Accenture
*****************************************/
@isTest
private class DS_AccountTriggerHelperTest {
/****************************************
* Method Name : assignTerritoryTest
* Author : Accenture
*****************************************/  
	
	 public static Id DPRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('SWx Upsell Proposal').getRecordTypeId();
	public static Id swxRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal').getRecordTypeId();
	
	static testmethod void assignTerritoryTest(){
		
		test.startTest();
	   
		Account accLegalEntity = TestDataFactory.createAccount(1)[0];
		accLegalEntity.AccountNumber='100006843';
		accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		database.insert(accLegalEntity);
		
		 ObjectTerritory2Association legalAccterritory = new ObjectTerritory2Association();
		 legalAccterritory.ObjectId= accLegalEntity.Id;
		 legalAccterritory.Territory2Id = TestDataFactory.getL7TerritoryId();
		 legalAccterritory.AssociationCause=CSWXGlobalConstant.Territory2Manual;
		database.insert(legalAccterritory);
		
		Account accLogistic = TestDataFactory.createAccount(1)[0];
		accLogistic.AccountNumber='';
		accLogistic.P20_Logistic_ID__c= '12345';
		accLogistic.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Logistic Account').getRecordTypeId();
		accLogistic.ParentId=accLegalEntity.ID;
		database.insert(accLogistic);
		
		Account accLogistic2 = TestDataFactory.createAccount(1)[0];
		accLogistic2.AccountNumber='';
		accLogistic2.P20_Logistic_ID__c= '12345';
		accLogistic2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Logistic Account').getRecordTypeId();
		accLogistic2.ParentId=accLegalEntity.ID;
		database.insert(accLogistic2);
		
		List<Account> accList= new List<Account>();
		accList.add(accLogistic);
		accList.add(accLogistic2);
		
		
		
		DS_AccountTriggerHandler.afterInsertOperation(accList);
	   
		test.stopTest();
		
		
	} 
	
	/****************************************
* Method Name : ProcessOnlyDMPAccountTest
* Author : Accenture
*****************************************/	
	static testmethod void ProcessOnlyDMPAccountTest(){
		
		User sysAdminUser = TestDataFactory.createSystemAdminUser();
		System.runAs(sysAdminUser){
		 
		DS_User_Profile_config_for_User_Sharing__c userProfile= new DS_User_Profile_config_for_User_Sharing__c();
		userProfile.Name = 'Digital Sales Customer Profile';
		database.insert(userProfile); 
				   
		Account accCustomer1 = TestDataFactory.createAccount(1)[0];
		accCustomer1.AccountNumber='101005961';
		accCustomer1.DMP_Account__c=false;
		accCustomer1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
		database.insert(accCustomer1);
		
	   
		Map <Id, Account> oldMapAccount = new Map<Id,Account>();
		oldMapAccount.put(accCustomer1.Id, accCustomer1);
		
		accCustomer1.DMP_Account__c= True;
		database.update(accCustomer1);
		
			
		Map <Id, Account> newMapAccount = new Map<Id,Account>();
		newMapAccount.put(accCustomer1.Id, accCustomer1);
		
		
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
		Contact conDS = new Contact(lastName=CSWXGlobalConstant.ContactNameDS,AccountId=accCustomer1.Id,Email=CSWXGlobalConstant.EmailContactNameDS );
		Contact conDS2 = new Contact(lastName=CSWXGlobalConstant.ContactNameDS,AccountId=accCustomer1.Id,Email=CSWXGlobalConstant.EmailContactNameDS );
		ContactList.add(conDS);
		ContactList.add(conDS2);
		database.insert(ContactList);
			
			
		
		User userDS = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',lastname = 'Testing',
								 languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid ='00e41000001yV28'/*system.Label.PRM_Partner_Relationship_Manager_Login_ID*/,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
								 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '00',ContactId  = conDS.Id, IsActive= True );
		
		
		  system.runAs(user1){ 
			  database.insert(userDS); 
		  }
	Test.stopTest();
		DS_AccountTriggerHandler.ProcessOnlyDMPAccount(oldMapAccount,newMapAccount);
		DS_AccountTriggerHandler.ProcessOnlyDMPAccount(null,newMapAccount);
	   
		}
		
	}
	
  /****************************************
* Method Name : ProcessOnlyDMPAccountTest
* Author : Accenture
*****************************************/	
	static testmethod void ProcessOnlyDMPAccountTest1(){
		
		
		User sysAdminUser = TestDataFactory.createSystemAdminUser();
		System.runAs(sysAdminUser){
			
			DS_User_Profile_config_for_User_Sharing__c userProfile= new DS_User_Profile_config_for_User_Sharing__c();
			userProfile.Name = 'Digital Sales Customer Profile';
			database.insert(userProfile); 
			
			Account accCustomer1 = TestDataFactory.createAccount(1)[0];
			accCustomer1.AccountNumber='101005961';
			accCustomer1.DMP_Account__c=false;
			accCustomer1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
			database.insert(accCustomer1);
			
			
			Map <Id, Account> oldMapAccount = new Map<Id,Account>();
			oldMapAccount.put(accCustomer1.Id, accCustomer1);
			
			accCustomer1.DMP_Account__c= True;
			database.update(accCustomer1);
			
			
			Map <Id, Account> newMapAccount = new Map<Id,Account>();
			newMapAccount.put(accCustomer1.Id, accCustomer1);
			
			SWx_Upsell_Proposal__c DigitalProposal = TestDataFactory.upsellList(1,accCustomer1)[0];
		DigitalProposal.Account_ID__c=accCustomer1.id;
		DigitalProposal.Analytics_Source__c='CXM';
		DigitalProposal.Upsell_Status__c='Draft';
		DigitalProposal.CurrencyIsoCode='INR';
		DigitalProposal.RecordTypeId = DPRecordTypeId;
		DigitalProposal.Sold_To_Party__c=accCustomer1.id; 
		insert DigitalProposal; 
			
		Opportunity oppty = TestDataFactory.OpportunityCreation(1,accCustomer1)[0];
		oppty.StageName = 'Develop Opportunity';//
		oppty.Phase_Status__c = 'Opportunity in Progress';
		oppty.Lead_BG__c = 'MN';
	   
		database.insert(oppty);
		  
		Apttus_Proposal__Proposal__c quoteProposal = NOKIA_CPQ_TestDataFactory.createProposal(1)[0]; 
		quoteProposal.NokiaCPQ_Portfolio__c = 'IP Routing';
		quoteProposal.Apttus_Proposal__Approval_Stage__c='Draft';
		quoteProposal.Apttus_Proposal__Opportunity__c=oppty.id;
		quoteProposal.RecordTypeId = swxRecordTypeId;
		database.insert(quoteProposal); 
			
			
			Test.startTest();
			String orgId = UserInfo.getOrganizationId();
			String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
			Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
			String uniqueName =   dateString + randomInt;
			
			
			User user1 = new User(alias = 'abc', email = uniqueName + '@nokia.com' ,UserRoleId  = system.Label.DSUserRole, emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
								  languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid = UserInfo.getProfileId(),  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
								  timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
			database.insert(user1);								
			
			
			List<Contact> ContactList = new List<Contact>();
			Contact conDS = new Contact(lastName=CSWXGlobalConstant.ContactNameDS,AccountId=accCustomer1.Id,Email=CSWXGlobalConstant.EmailContactNameDS );
			Contact conDS2 = new Contact(lastName=CSWXGlobalConstant.ContactNameDS,AccountId=accCustomer1.Id,Email=CSWXGlobalConstant.EmailContactNameDS );
			ContactList.add(conDS);
			ContactList.add(conDS2);
			database.insert(ContactList);
			
			
			
			User userDS = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',lastname = 'Testing',
								   languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid ='00e41000001yV28'/*system.Label.PRM_Partner_Relationship_Manager_Login_ID*/,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
								   timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '00',ContactId  = conDS.Id, IsActive= True );
			
			
			system.runAs(user1){ 
				database.insert(userDS);  
			}
			
			accCustomer1.ownerId= user1.Id;
			database.update(accCustomer1);
			Map <Id, Account> newMapAccount1 = new Map<Id,Account>();
			newMapAccount1.put(accCustomer1.Id, accCustomer1);
			Test.stopTest();
			
			DS_AccountTriggerHandler.afterUpdateOperation(oldMapAccount,newMapAccount1);
			
			
		}
		
	}	
	
}