/****************************************
* Name : DS_PortalDashboardTest
* Author : Accenture

*****************************************/
@IsTest
Private class DS_PortalDashboardTest{
	public static Id swxRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('SWx Upsell Proposal').getRecordTypeId();
	private static Id oppDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.CREATE_DIRECT_SALES_OPPORTUNITY).getRecordTypeId();
	public static Id swxQuoteRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal').getRecordTypeId();
   
	/******************************
*Method Name: getDPDashBoardTest
*Description: Test Method to cover DS_PortalDashboard class
********************************/
	static testmethod void getDPDashBoardTest(){
		
		User adminuser = TestDataFactory.createUser('System Administrator', 'adminlastname');
		UserRole usrRole = [Select Id From UserRole where DeveloperName =:'Nokia_Global' limit 1];
		adminuser.UserRoleId = usrRole.Id;
		insert adminuser;
		user usr = [select UserRoleId from User where Id =: adminuser.Id];
		system.debug('usr.UserRole'+usr.UserRoleId);
		String RandomId;
		Account accountCreationDP;
		Contact conDS;
		User userDS;
		System.runAs(adminuser) {
			RandomId=String.valueOf(Math.rint(Math.random()*1000000));		 
			accountCreationDP = TestDataFactory.createAccount(1)[0];
			accountCreationDP.DMP_Account__c = true;
			accountCreationDP.AccountNumber=RandomId; 
			database.insert(accountCreationDP);		
			conDS = new Contact(lastName=CSWXGlobalConstant.ContactNameDS,AccountId=accountCreationDP.id,Email=CSWXGlobalConstant.EmailContactNameDS );
			insert conDS;	 
			Account acc = new Account();
			acc.Name='Legal Entity Account For Test';
			acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			acc.ParentId = accountCreationDP.Id;
			//acc.AccountNumber = '100006843';
			RandomId=String.valueOf(Math.rint(Math.random()*1000000));
			acc.AccountNumber = RandomId ;
			database.insert(acc);
			List<Contact> ContactList = new List<Contact>();			
			Contact conDS2 = new Contact(lastName=CSWXGlobalConstant.ContactNameDS,AccountId=accountCreationDP.id,Email=CSWXGlobalConstant.EmailContactNameDS+'i' );			
			ContactList.add(conDS2);
			database.insert(ContactList); 
			//UserRole ur = [Select Id, PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
			userDS = NCP_TestFactory.createUser(false,'Testing', conDS, 'test123234@nokia.com.org');
			//userDS.UserRoleId = ur.Id;
			insert userDS;
		}
		
		System.runAs(new User(Id=UserInfo.getUserId())) {
			Set<String> customerUserTypes = new Set<String> {'PowerCustomerSuccess',   'CustomerSuccess'};
				Profile p = [select Id,name from Profile where UserType in :customerUserTypes limit 1];
			//UserRole ur = [Select Id, PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
			String orgId = UserInfo.getOrganizationId();
			String dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
			Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
			String uniqueName = /* orgId + */ dateString + randomInt;
		   /* User userDS = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' *//*, emailencodingkey = 'UTF-8', firstName = 'test',lastname = 'Testing',
								   languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid = p.Id,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
								   timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',
								   Nokia_ID__c = randomInt + '00',ContactId  = conDS.Id, isActive = true, UserRoleId = ur.Id
								  );
			insert userDS;*/
			//User userDS = NCP_TestFactory.createUser(false,'Testing', conDS, 'test123234@nokia.com.org');
			//userDS.UserRoleId = ur.Id;
			//insert userDS;
			USer user2 = [Select Id,Profile.Name,Name,ContactID,AccountId from User where  isPortalEnabled = True and isActive = True and AccountId!=null and ContactID!=null  and contact.Account.DMP_Account__c =True and (UserType = 'PowerCustomerSuccess' or UserType ='CustomerSuccess')  limit 1];
			
			User sysAdminUser = TestDataFactory.createSystemAdminUser();		
			
			System.runAs(sysAdminUser) {
				
				orgId = UserInfo.getOrganizationId();
				dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
				randomInt = Integer.valueOf(math.rint(math.random()*1000000));
				uniqueName =   dateString + randomInt;
				User user1 = new User(alias = 'abc', email = uniqueName + '@nokia.com' , emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
									  languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid = UserInfo.getProfileId(),  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
									  timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
				database.insert(user1); 
				system.runAs(user1){														
					userDS.IsPortalEnabled =  True;
					
					database.update(userDS);
				}
				// Test.stopTest();
				
				test.startTest(); 
				Id LERecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(GlobalConstants.LEGAL_ENTITY).getRecordTypeId();
				
				/*Account LegalEntityaccount = [Select id From Account Where RecordtypeId=:LERecordTypeId  AND Parentid=:user2.AccountId AND Active__c = true Limit 1];*/
				
				
				// Account LegalEntityaccount =  NF_TestDataFactory.createAccount('10308719999AIA');
				Account LegalEntityaccount = NF_TestDataFactory.createAccount('10308719999AIA');
				LegalEntityaccount.Accountnumber='1323242223i';
				LegalEntityaccount.Recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
				LegalEntityaccount.ParentId=user2.AccountId;
				LegalEntityaccount.Default_Legal_Entity__c = true;
				LegalEntityaccount.Partner_Program__c=null;
				LegalEntityaccount.Active__c = true;
				Database.insert(LegalEntityaccount);
				
				SWx_Upsell_Proposal__c upsellProposal_SWX=TestDataFactory.upsellList(1,accountCreationDP)[0];
				upsellProposal_SWX.Analytics_File_Refer_ID__c='GBR-61940-82356';
				upsellProposal_SWX.Analytics_Source__c='CXM';
				upsellProposal_SWX.Proposal_Recommendation_Type__c='renewal';
				upsellProposal_SWX.P20_Id__c=215616;
				upsellProposal_SWX.CurrencyIsoCode='EUR';
				upsellProposal_SWX.Unweighted_Value__c=429052.07;
				upsellProposal_SWX.Account_ID__c=user2.AccountId;
				upsellProposal_SWX.RecordTypeID=swxRecordTypeId;
				upsellProposal_SWX.DS_Show_In_Portal__c = true;
				upsellProposal_SWX.sold_to_party__c=LegalEntityaccount.id;
				database.insert(upsellProposal_SWX);	
				
				Test.stopTest();
				
				System.runAs(user2) {
					Map<String,String>  DPDashboardMap = new Map<String,String>();
					DPDashboardMap=DS_PortalDashboard.getDPDashboard();
					
					// DigitalProposal.Upsell_Status__c='Reject';
					//Update DigitalProposal;
					//DPDashboardMap=DS_PortalDashboard.getDPDashboard();
					
				}
				
			}
			
		}
		
	}   
	
	
	/******************************
*Method Name: getQuoteDashBoardTest
*Description: Test Method to cover DS_PortalDashboard class
********************************/
	static testmethod void getQuoteDashBoardTest(){
		
		String RandomId2=String.valueOf(Math.rint(Math.random()*1000000));
		User sysAdminUser = TestDataFactory.createSystemAdminUser();
		UserRole usrRole = [Select Id From UserRole where DeveloperName =:'Nokia_Global' limit 1];
		sysAdminUser.UserRoleId = usrRole.Id;
		insert sysAdminUser;
		String RandomId;
		Account accountCreationDP;
		Contact conDS;
		System.runAs(sysAdminUser){
			
			accountCreationDP = TestDataFactory.createAccount(1)[0];
			accountCreationDP.DMP_Account__c = true;
			database.insert(accountCreationDP);
			
			Account acc = new Account();
			acc.Name='Legal Entity Account For Test';
			acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			acc.ParentId = accountCreationDP.Id;
			acc.AccountNumber = RandomId2 ;
			database.insert(acc);
			String orgId = UserInfo.getOrganizationId();
			String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
			Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
			String uniqueName =   dateString + randomInt;
			
			/*
User user1 = new User(alias = 'abc', email = uniqueName + '@nokia.com' , emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid = UserInfo.getProfileId(),  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
database.insert(user1); 
*/ 
			
			List<Contact> ContactList = new List<Contact>();
			conDS = new Contact(lastName=CSWXGlobalConstant.ContactNameDS,AccountId=accountCreationDP.id,Email=CSWXGlobalConstant.EmailContactNameDS );
			ContactList.add(conDS);
			database.insert(ContactList); 
			/*
Profile prof=[Select Id,Name from Profile where Name='Digital Sales Customer Profile'];


User userDS = new User(alias = 'abc', email = uniqueName + '@nokia.com' , emailencodingkey = 'UTF-8', firstName = 'test',lastname = 'Testing',
languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid =prof.Id,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '00',ContactId  = conDS.Id );

*/
			Test.startTest();
			system.runAs(sysAdminUser){  
				
				Set<String> customerUserTypes = new Set<String> {'PowerCustomerSuccess',   'CustomerSuccess'};
					Profile p = [select Id,name from Profile where UserType in :customerUserTypes limit 1];
				//UserRole ur = [Select Id, PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
				orgId = UserInfo.getOrganizationId();
				dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
				randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
				uniqueName = /* orgId + */ dateString + randomInt;
			   /* User userDS = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' *//*, emailencodingkey = 'UTF-8', firstName = 'test',lastname = 'Testing',
									   languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid = p.Id,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
									   timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',
									   Nokia_ID__c = randomInt + '00',ContactId  = conDS.Id, isActive = true, UserRoleId = ur.Id);
				insert userDS;*/
				User userDS = NCP_TestFactory.createUser(false,'Testing', conDS, 'test123234@nokia.com.org');
			//userDS.UserRoleId = ur.Id;
			insert userDS;
				
				userDS.IsPortalEnabled =  True;
				database.update(userDS);								 
				
				Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();
				USer user1 = [Select Id,Profile.Name,Name,ContactID,AccountId from User where  isPortalEnabled = True and isActive = True and AccountId!=null and ContactID!=null  and contact.Account.DMP_Account__c =True and (UserType = 'PowerCustomerSuccess' or UserType ='CustomerSuccess')  limit 1];
				Id LERecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(GlobalConstants.LEGAL_ENTITY).getRecordTypeId();
				
				/*Account LegalEntityaccount = [Select id From Account Where RecordtypeId=:LERecordTypeId  AND Parentid=:user1.AccountId AND Active__c = true limit 1];*/
				
				Account LegalEntityaccount = NF_TestDataFactory.createAccount('10308719999AIA');
				LegalEntityaccount.Accountnumber='1323242223i';
				LegalEntityaccount.Recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
				LegalEntityaccount.ParentId=user1.AccountId;
				LegalEntityaccount.Default_Legal_Entity__c = true;
				LegalEntityaccount.Partner_Program__c=null;
				LegalEntityaccount.Active__c = true;
				Database.insert(LegalEntityaccount);
				
				Opportunity oppty= NF_TestDataFactory.createOpportunity(user1.AccountId, 'Execute (Start Delivery)', 'In Execution', Date.today().addDays(10), 7000000);
				oppty.Lead_BG__c='MN';
				oppty.Opportunity_ID__c='19.IN.856951';
				oppty.RecordTypeId = oppDirectRecordTypeId;
				oppty.Legal_Entity__c=LegalEntityaccount.id;
				oppty.End_Customer_LE__c=LegalEntityaccount.id;
				oppty.Business_Type__c = 'Standard Opportunity';
				
				Database.insert(oppty);
				
				List<Apttus_Proposal__Proposal__c> quoteProposalToInsert = new List<Apttus_Proposal__Proposal__c>();
				List<Apttus_Proposal__Proposal__c> quoteProposalToUpdate = new List<Apttus_Proposal__Proposal__c>();
				Apttus_Proposal__Proposal__c quoteProposal = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
				quoteProposal.Apttus_Proposal__Opportunity__c = oppty.id; 
				//quoteProposal.Apttus_QPConfig__PriceListId__c = priceList.Id;
				quoteProposal.NokiaCPQ_Portfolio__c = 'IP Routing';
				quoteProposal.NokiaCPQ_SSP_Level__c = 'Unlimited';
				quoteProposal.Analytics_Source__c  = 'CXM';
				quoteProposal.RecordTypeId=swxQuoteRecordTypeId;
				quoteProposal.Apttus_Proposal__Account__c=user1.AccountId;
				quoteProposal.Apttus_Proposal__Approval_Stage__c=CSWXGlobalConstant.Approval_stage_approved;
				quoteProposal.LOA_Status__c='Approved';
				quoteProposalToInsert.add(quoteProposal);
				
				
				Apttus_Proposal__Proposal__c quoteProposal1 = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
				quoteProposal1.Apttus_Proposal__Opportunity__c = oppty.id; 
				//quoteProposal1.Apttus_QPConfig__PriceListId__c = priceList.Id;
				quoteProposal1.NokiaCPQ_Portfolio__c = 'IP Routing';
				quoteProposal1.NokiaCPQ_SSP_Level__c = 'Unlimited';
				quoteProposal1.Analytics_Source__c  = 'CXM';
				quoteProposal1.RecordTypeId=swxQuoteRecordTypeId;
				quoteProposal1.Apttus_Proposal__Account__c=user1.AccountId;
				quoteProposalToInsert.add(quoteProposal1);
				
				
				Apttus_Proposal__Proposal__c quoteProposal2 = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
				quoteProposal2.Apttus_Proposal__Opportunity__c = oppty.id; 
				//quoteProposal2.Apttus_QPConfig__PriceListId__c = priceList.Id;
				quoteProposal2.NokiaCPQ_Portfolio__c = 'IP Routing';
				quoteProposal2.NokiaCPQ_SSP_Level__c = 'Unlimited';
				quoteProposal2.Analytics_Source__c  = 'CXM';
				quoteProposal2.RecordTypeId=swxQuoteRecordTypeId;
				quoteProposal2.Apttus_Proposal__Account__c=user1.AccountId;
				quoteProposalToInsert.add(quoteProposal2);
				Apttus_Proposal__Proposal__c quoteProposal3 = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
				quoteProposal3.Apttus_Proposal__Opportunity__c = oppty.id; 
				//quoteProposal3.Apttus_QPConfig__PriceListId__c = priceList.Id;
				quoteProposal3.NokiaCPQ_Portfolio__c = 'IP Routing';
				quoteProposal3.NokiaCPQ_SSP_Level__c = 'Unlimited';
				quoteProposal3.Analytics_Source__c  = 'CXM';
				quoteProposal3.RecordTypeId=swxQuoteRecordTypeId;
				quoteProposal3.Apttus_Proposal__Account__c=user1.AccountId;
				quoteProposalToInsert.add(quoteProposal3);
				insert quoteProposalToInsert;
				quoteProposalToInsert[1].Apttus_Proposal__Approval_Stage__c=CSWXGlobalConstant.Approval_stage_withdrawn;
				database.update(quoteProposalToInsert[1]);
				quoteProposalToInsert[2].Apttus_Proposal__Approval_Stage__c=CSWXGlobalConstant.Approval_stage_accepted;
				quoteProposalToInsert[2].LOA_Status__c='Approved';						   
				quoteProposalToInsert[2].Contract_Type_Name__c = 'Contract';
				quoteProposalToInsert[2].Apttus_QPConfig__PONumber__c = '0987654321';
				quoteProposalToInsert[2].Apttus_QPConfig__PODate__c = System.today();
				database.update(quoteProposalToInsert[2]);
				Test.stopTest();
				quoteProposalToInsert[3].Revision_Status__c='Revision'; 
				quoteProposalToInsert[3].Apttus_Proposal__Approval_Stage__c=CSWXGlobalConstant.Approval_stage_accepted;
				quoteProposalToInsert[3].Apttus_QPConfig__PONumber__c = 'test';
				quoteProposalToInsert[3].Apttus_QPConfig__PODate__c =system.today();
				database.update(quoteProposalToInsert[3]);
				
				System.runAs(user1) {
					DS_PortalDashboard.getQuoteDashboard();
				}
				
			}
		}
	}
	static testmethod void getDPDashBoardTest1(){
		 String RandomId2=String.valueOf(Math.rint(Math.random()*1000000));
		User sysAdminUser = TestDataFactory.createSystemAdminUser();
		UserRole usrRole = [Select Id From UserRole where DeveloperName =:'Nokia_Global' limit 1];
		sysAdminUser.UserRoleId = usrRole.Id;
		insert sysAdminUser;
		String RandomId;
		Account accountCreationDP;
		Contact conDS;
		System.runAs(sysAdminUser){
			
			accountCreationDP = TestDataFactory.createAccount(1)[0];
			accountCreationDP.DMP_Account__c = true;
			database.insert(accountCreationDP);
			
			Account acc = new Account();
			acc.Name='Legal Entity Account For Test';
			acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			acc.ParentId = accountCreationDP.Id;
			acc.AccountNumber = RandomId2 ;
			database.insert(acc);
			String orgId = UserInfo.getOrganizationId();
			String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
			Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
			String uniqueName =   dateString + randomInt;
			
			/*
User user1 = new User(alias = 'abc', email = uniqueName + '@nokia.com' , emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid = UserInfo.getProfileId(),  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
database.insert(user1); 
*/ 
			
			List<Contact> ContactList = new List<Contact>();
			conDS = new Contact(lastName=CSWXGlobalConstant.ContactNameDS,AccountId=accountCreationDP.id,Email=CSWXGlobalConstant.EmailContactNameDS );
			ContactList.add(conDS);
			database.insert(ContactList); 
			/*
Profile prof=[Select Id,Name from Profile where Name='Digital Sales Customer Profile'];


User userDS = new User(alias = 'abc', email = uniqueName + '@nokia.com' , emailencodingkey = 'UTF-8', firstName = 'test',lastname = 'Testing',
languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid =prof.Id,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '00',ContactId  = conDS.Id );

*/
			Test.startTest();
			system.runAs(sysAdminUser){  
				
				Set<String> customerUserTypes = new Set<String> {'PowerCustomerSuccess',   'CustomerSuccess'};
					Profile p = [select Id,name from Profile where UserType in :customerUserTypes limit 1];
				//UserRole ur = [Select Id, PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
				orgId = UserInfo.getOrganizationId();
				dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
				randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
				uniqueName = /* orgId + */ dateString + randomInt;
				/*User userDS = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' *//*, emailencodingkey = 'UTF-8', firstName = 'test',lastname = 'Testing',
									   languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid = p.Id,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
									   timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',
									   Nokia_ID__c = randomInt + '00',ContactId  = conDS.Id, isActive = true, UserRoleId = ur.Id);
				insert userDS;*/
				User userDS = NCP_TestFactory.createUser(false,'Testing', conDS, 'test123234@nokia.com.org');
			//userDS.UserRoleId = ur.Id;
			insert userDS;
				userDS.IsPortalEnabled =  True;
				database.update(userDS);								 
				
				Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();
				USer user1 = [Select Id,Profile.Name,Name,ContactID,AccountId from User where  isPortalEnabled = True and isActive = True and AccountId!=null and ContactID!=null  and contact.Account.DMP_Account__c =True and (UserType = 'PowerCustomerSuccess' or UserType ='CustomerSuccess')  limit 1];
				Id LERecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(GlobalConstants.LEGAL_ENTITY).getRecordTypeId();
				
				/*Account LegalEntityaccount = [Select id From Account Where RecordtypeId=:LERecordTypeId  AND Parentid=:user1.AccountId AND Active__c = true limit 1];*/
				
				Account LegalEntityaccount = NF_TestDataFactory.createAccount('10308719999AIA');
				LegalEntityaccount.Accountnumber='1323242223i';
				LegalEntityaccount.Recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
				LegalEntityaccount.ParentId=user1.AccountId;
				LegalEntityaccount.Default_Legal_Entity__c = true;
				LegalEntityaccount.Partner_Program__c=null;
				LegalEntityaccount.Active__c = true;
				Database.insert(LegalEntityaccount);
				
				Opportunity oppty= NF_TestDataFactory.createOpportunity(user1.AccountId, 'Execute (Start Delivery)', 'In Execution', Date.today().addDays(10), 7000000);
				oppty.Lead_BG__c='MN';
				oppty.Opportunity_ID__c='19.IN.856951';
				oppty.RecordTypeId = oppDirectRecordTypeId;
				oppty.Legal_Entity__c=LegalEntityaccount.id;
				oppty.End_Customer_LE__c=LegalEntityaccount.id;
				oppty.Business_Type__c = 'Standard Opportunity';
				
				Database.insert(oppty);
				
				List<Apttus_Proposal__Proposal__c> quoteProposalToInsert = new List<Apttus_Proposal__Proposal__c>();
				List<Apttus_Proposal__Proposal__c> quoteProposalToUpdate = new List<Apttus_Proposal__Proposal__c>();
				Apttus_Proposal__Proposal__c quoteProposal = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
				quoteProposal.Apttus_Proposal__Opportunity__c = oppty.id; 
				//quoteProposal.Apttus_QPConfig__PriceListId__c = priceList.Id;
				quoteProposal.NokiaCPQ_Portfolio__c = 'IP Routing';
				quoteProposal.NokiaCPQ_SSP_Level__c = 'Unlimited';
				quoteProposal.Analytics_Source__c  = 'CXM';
				quoteProposal.RecordTypeId=swxQuoteRecordTypeId;
				quoteProposal.Apttus_Proposal__Account__c=user1.AccountId;
				quoteProposal.Apttus_Proposal__Approval_Stage__c=CSWXGlobalConstant.Approval_stage_approved;
				quoteProposal.LOA_Status__c='Approved';
				quoteProposalToInsert.add(quoteProposal);
				
				
				Apttus_Proposal__Proposal__c quoteProposal1 = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
				quoteProposal1.Apttus_Proposal__Opportunity__c = oppty.id; 
				//quoteProposal1.Apttus_QPConfig__PriceListId__c = priceList.Id;
				quoteProposal1.NokiaCPQ_Portfolio__c = 'IP Routing';
				quoteProposal1.NokiaCPQ_SSP_Level__c = 'Unlimited';
				quoteProposal1.Analytics_Source__c  = 'CXM';
				quoteProposal1.RecordTypeId=swxQuoteRecordTypeId;
				quoteProposal1.Apttus_Proposal__Account__c=user1.AccountId;
				quoteProposalToInsert.add(quoteProposal1);
				
				
				Apttus_Proposal__Proposal__c quoteProposal2 = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
				quoteProposal2.Apttus_Proposal__Opportunity__c = oppty.id; 
				//quoteProposal2.Apttus_QPConfig__PriceListId__c = priceList.Id;
				quoteProposal2.NokiaCPQ_Portfolio__c = 'IP Routing';
				quoteProposal2.NokiaCPQ_SSP_Level__c = 'Unlimited';
				quoteProposal2.Analytics_Source__c  = 'CXM';
				quoteProposal2.RecordTypeId=swxQuoteRecordTypeId;
				quoteProposal2.Apttus_Proposal__Account__c=user1.AccountId;
				quoteProposalToInsert.add(quoteProposal2);
				Apttus_Proposal__Proposal__c quoteProposal3 = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
				quoteProposal3.Apttus_Proposal__Opportunity__c = oppty.id; 
				//quoteProposal3.Apttus_QPConfig__PriceListId__c = priceList.Id;
				quoteProposal3.NokiaCPQ_Portfolio__c = 'IP Routing';
				quoteProposal3.NokiaCPQ_SSP_Level__c = 'Unlimited';
				quoteProposal3.Analytics_Source__c  = 'CXM';
				quoteProposal3.RecordTypeId=swxQuoteRecordTypeId;
				quoteProposal3.Apttus_Proposal__Account__c=user1.AccountId;
				quoteProposalToInsert.add(quoteProposal3);
				insert quoteProposalToInsert;
				quoteProposalToInsert[1].Apttus_Proposal__Approval_Stage__c=CSWXGlobalConstant.Approval_stage_accepted;
				quoteProposalToInsert[1].Apttus_QPConfig__PONumber__c = 'test';
				quoteProposalToInsert[1].Apttus_QPConfig__PODate__c =system.today();
				database.update(quoteProposalToInsert[1]);
				quoteProposalToInsert[2].Apttus_Proposal__Approval_Stage__c=CSWXGlobalConstant.Approval_stage_accepted;
				quoteProposalToInsert[2].LOA_Status__c='Approved';						   
				quoteProposalToInsert[2].Contract_Type_Name__c = 'Contract';
				quoteProposalToInsert[2].Apttus_QPConfig__PONumber__c = '0987654321';
				quoteProposalToInsert[2].Apttus_QPConfig__PODate__c = System.today();
				database.update(quoteProposalToInsert[2]);
				Test.stopTest();
				quoteProposalToInsert[3].Revision_Status__c='Revision'; 
				quoteProposalToInsert[3].Apttus_Proposal__Approval_Stage__c=CSWXGlobalConstant.Approval_stage_accepted;
				quoteProposalToInsert[3].Apttus_QPConfig__PONumber__c = 'test';
				quoteProposalToInsert[3].Apttus_QPConfig__PODate__c =system.today();
				database.update(quoteProposalToInsert[3]);
				quoteProposalToUpdate = [SELECT Id FROM Apttus_Proposal__Proposal__c LIMIT 2];
		//Check if Accepted Quote/Proposal is also listed
		quoteProposalToUpdate[0].Apttus_Proposal__Approval_Stage__c = CSWXGlobalConstant.Approval_stage_accepted;
				quoteProposalToUpdate[0].Apttus_QPConfig__PONumber__c = 'test';
				quoteProposalToUpdate[0].Apttus_QPConfig__PODate__c = System.today();
				quoteProposalToUpdate[1].Apttus_Proposal__Approval_Stage__c = CSWXGlobalConstant.Approval_stage_withdrawn;
		Database.update(quoteProposalToUpdate);
				
				System.runAs(user1) {
					DS_PortalDashboard.getQuoteDashboard();
				}
				
			}
		}
	}
}