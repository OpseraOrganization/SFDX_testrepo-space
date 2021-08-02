@IsTest
public class CH_AuthorizedContactSharingTest {
	
	//test start for NOKIASC-26448
	@IsTest
	public static void testUnShareAuthorizedEntitlementContact(){
		
		System.runAs(new User(Id = UserInfo.getUserId())){
			CH_AuthorizedContactSharing.authorizedContactSharingCalculated = false;
			CH_AvoidRecursion.doNtExcuteCseTrggr4NotfcationBtch = false;
			
			Account accObj = new Account();
			accObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
			accObj.Name ='test5';
			accObj.AccountNumber ='76521';
			insert accObj;
			
			Contact contact = new Contact(lastName= 'ctt last Name', AccountId=accObj.id, Email= 'test12356@nokia.com', CH_ContactType__c = 'Nokia Employee');
			insert contact;
			
			Contact contact1 = new Contact(lastName= 'ctt last Name1', AccountId=accObj.id, Email= 'test123567@nokia.com', CH_ContactType__c = 'Nokia Employee');
			insert contact1;
			
			Account accObj1 = new Account();
			accObj1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			accObj1.Name ='test5';
			accObj1.AccountNumber ='76521';
			accObj1.ParentId =accObj.Id;
			insert accObj1;
			
			List<Product2> prdlist =CAPS_TestDataUtil.createProductRecord(1);
			insert prdlist;
			
			Case caseObj = new Case();
			caseObj.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Nokia Standard Case').getRecordTypeId();
			caseObj.Description = 'test2';
			caseObj.Subject = 'test2';
			caseObj.Severity__c = 'Minor';
			caseObj.Status = 'Assigned';
			caseObj.Priority='Low';
			caseObj.Type='Incident';
			caseObj.CH_InitialDiagnosis__c = 'testt';
			//caseobj.CH_SolutionType__c='Other';
			caseobj.CH_Outage__c = 'No';
			caseobj.CH_SecurityGroup__c ='Test12345';
			caseobj.CH_IssueOccurenceDate__c =system.now().addMinutes(-1440);
			caseobj.CH_AssignedDate__c= system.today().addDays(-1);
			caseobj.Country__c = 'United States of America';
			caseobj.ProductId=prdlist[0].id;
			caseobj.ContactId=contact.Id;
			caseobj.AccountId=accObj1.id;
			System.debug('caseobj.ProductId'+caseobj.ProductId+'caseobj.Country__c'+caseobj.Country__c);
			caseobj.CH_OutageStartDate__c =System.now().addMinutes(-1440);
			caseobj.CH_OutageEndDate__c  = System.now().addMinutes(-1439);
			insert caseObj;
			
			Asset AstObj = new Asset();
			AstObj.RecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Covered Product').getRecordTypeId();
			AstObj.CH_CDB_ExternalAssetId__c = '41445';
			AstObj.Name ='Test5';
			AstObj.AccountId =accObj1.id;
			AstObj.CH_CDB_ExternalAssetId__c = '123123';
			insert AstObj;
			
			ServiceContract scObj = new ServiceContract();
			scObj.Name ='test5';
			scobj.CH_CDB_ContractId__c ='12345';
			scObj.CH_CDB_CustomerId__c ='76521';
			scObj.AccountId =accObj1.id;
			insert scobj;
			
			Entitlement entiObj = new Entitlement();
			entiObj.Name ='test123';		
			entiObj.CH_ServiceMappingId__c ='Legacy Customer Support Service - Critical Major Minor 24x7';
			entiObj.AccountId =accObj1.id;
			entiObj.CH_CDB_EntitlementId__c ='54321';
			entiObj.ServiceContractId= scObj.id;
			entiObj.AssetId =AstObj.id; 
			insert entiObj;		
			
			EntitlementContact ec = new EntitlementContact();
			ec.contactId = contact1.Id;
			ec.entitlementId = entiObj.Id; 
			insert ec;
			Test.startTest();
			list<Case> aCases = new list<Case>([SELECT Id FROM Case limit 1]);
			system.assertEquals(aCases.size(), 1);
			
			if(aCases[0].Id == caseObj.Id)
				aCases[0].EntitlementId = entiObj.Id;
			aCases[0].AssetId = AstObj.Id;
			update aCases[0];
			
			UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
			Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
			
			//User userPRM = new User(alias = 'abc', email = 'Test2342421@nokia.com', emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing', 
			//languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
			//timezonesidkey = 'America/Los_Angeles', Username = 'Test2342421@nokia.com'  + '.org',Restriction_Level__c = 'Confidential', ContactId  = contact.Id, Nokia_ID__c= '6777777666', 
			//UserRoleId = portalRole.Id);
			
			//insert userPRM;
			
			
			//CaseShare cShares = new CaseShare();
			//cShares.caseId = aCases[0].Id;
			//cShares.UserOrGroupId = userPRM.Id;
			//cShares.RowCause = 'Manual';
			//insert cShares;
			
			User portalAccountOwner1 = new User(
				UserRoleId = portalRole.Id,
				ProfileId = profile1.Id,
				Username = System.now().millisecond() + 'test234@test.com',
				Alias = 'batman',
				Email='bruce.wayne@wayneenterprises.com',
				EmailEncodingKey='UTF-8',
				Firstname='Bruce1',
				Lastname='Wayne2',
				LanguageLocaleKey='en_US',
				LocaleSidKey='en_US',
				TimeZoneSidKey='America/Chicago'
				//ContactId  = contact.Id
			);
			Database.insert(portalAccountOwner1);
			
			list<CaseShare> cShares = new list<CaseShare>([SELECT Id FROM CaseShare WHERE caseId = :aCases[0].Id AND UserOrGroupId = :portalAccountOwner1.Id AND RowCause = 'Manual' limit 1]);
			system.assert(cShares.isEmpty());
			
			
			delete ec;
			delete cShares;
			update aCases[0];
			Test.stopTest();
			
		}   
	} //test end for NOKIASC-26448
	
	//test start for NOKIASC-26448
	@IsTest
	public static void testUnShareAuthorizedContacts1(){
		
		System.runAs(new User(Id = UserInfo.getUserId())){
			CH_AuthorizedContactSharing.authorizedContactSharingCalculated = false;
			CH_AvoidRecursion.doNtExcuteCseTrggr4NotfcationBtch = false;
			
			//Test.startTest();
			
			UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
			Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
			
			User portalAccountOwner1 = new User(
				UserRoleId = portalRole.Id,
				ProfileId = profile1.Id,
				Username = System.now().millisecond() + 'test234@test.com',
				Alias = 'batman',
				Email='bruce.wayne@wayneenterprises.com',
				EmailEncodingKey='UTF-8',
				Firstname='Bruce1',
				Lastname='Wayne2',
				LanguageLocaleKey='en_US',
				LocaleSidKey='en_US',
				TimeZoneSidKey='America/Chicago'
			);
			Database.insert(portalAccountOwner1);
			
			Account accObj;
			Contact contact;
			Account accObj1;
			
			System.runAs ( portalAccountOwner1 ) {
				
				accObj = new Account();
				accObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
				accObj.Name ='Nokia OYJ';
				accObj.AccountNumber ='76521';
				insert accObj;
				
				contact = new Contact(lastName= 'ctt last Name', AccountId=accObj.id, Email= 'test12356@nokia.com', CH_ContactType__c = 'Nokia Employee');
				insert contact;
				
				accObj1 = new Account();
				accObj1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
				accObj1.Name ='Nokia OYJ';
				accObj1.AccountNumber ='76521';
				accObj1.ParentId =accObj.Id;
				insert accObj1;
				
				//Create user
				Profile portalProfile = [SELECT Id FROM Profile where name ='Customers' Limit 1];
				User user1 = new User(
					Username = System.now().millisecond() + 'test12345@test.com',
					ContactId = contact.Id,
					ProfileId = portalProfile.Id,
					Alias = 'test123',
					Email = 'test12345@test.com',
					EmailEncodingKey = 'UTF-8',
					LastName = 'McTesty',
					CommunityNickname = 'test12345',
					TimeZoneSidKey = 'America/Los_Angeles',
					LocaleSidKey = 'en_US',
					LanguageLocaleKey = 'en_US'
				);
				Database.insert(user1);
			}
			
			AccountContactRelation accountContactRelation = new AccountContactRelation();
			accountContactRelation.AccountId = accObj1.Id;
			accountContactRelation.ContactId = contact.id;
			accountContactRelation.NCP_Entitlement_Relationship__c = true;
			accountContactRelation.Roles = 'Other';
			insert accountContactRelation;
			
			
			List<Product2> prdlist =CAPS_TestDataUtil.createProductRecord(1);
			insert prdlist;
			
			Asset AstObj = new Asset();
			AstObj.RecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Covered Product').getRecordTypeId();
			AstObj.CH_CDB_ExternalAssetId__c = '41445';
			AstObj.Name ='Test5';
			AstObj.AccountId =accObj1.id;
			AstObj.CH_CDB_ExternalAssetId__c = '123123';
			insert AstObj;
			
			
			PricebookEntry standardPrice = new PricebookEntry();
			standardPrice.Pricebook2Id= Test.getStandardPricebookId();
			standardPrice.Product2Id= prdlist[0].id;
			standardPrice.UnitPrice = 10000;
			standardPrice.IsActive = true;
			insert standardPrice;
			
			ServiceContract scObj = new ServiceContract();
			scObj.Name ='test5';
			scobj.CH_CDB_ContractId__c ='12345';
			scObj.CH_CDB_CustomerId__c ='76521';
			scObj.AccountId =accObj1.id;
			scObj.Pricebook2Id =Test.getStandardPricebookId();
			insert scobj;
			
			ContractLineItem CLIObj = new ContractLineItem();
			CLIObj.ServiceContractId = scobj.Id;
			CLIObj.AssetId = AstObj.Id;
			CLIObj.UnitPrice = 0;
			CLIObj.Quantity = 1;
			CLIObj.PricebookEntryId = standardPrice.Id;
			CLIObj.CH_ServiceOffering__c = 'test123';
			CLIObj.CH_ServiceType__c = 'Customer Support'; 
			CLIObj.CH_ServiceMappingId__c = 'Legacy Customer Support Service - Critical Major Minor 24x7';	
			//CLIObj.CH_Entitlement__c = entiObj.Id;
			Insert CLIObj;
			
			Entitlement entiObj = new Entitlement();
			entiObj.Name ='test123';		
			entiObj.CH_ServiceMappingId__c ='Legacy Customer Support Service - Critical Major Minor 24x7';
			entiObj.AccountId =accObj1.id;
			entiObj.CH_CDB_EntitlementId__c ='54321';
			entiObj.ServiceContractId= scObj.id;
			entiObj.ContractLineItemId=CLIObj.Id;
			entiObj.AssetId =AstObj.id;			
			insert entiObj;	
			
			scObj.CH_Entitlement__c = entiObj.Id;
			update scObj;
			
			CLIObj.CH_Entitlement__c = entiObj.Id;
			Update CLIObj;
			
			EntitlementContact ec = new EntitlementContact();
			ec.contactId = contact.Id;
			ec.entitlementId = entiObj.Id; 
			insert ec;
			
			Test.startTest();
			Case caseObj = new Case();
			caseObj.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Nokia Standard Case').getRecordTypeId();
			caseObj.Description = 'test2';
			caseObj.Subject = 'test2';
			caseObj.Severity__c = 'Minor';
			caseObj.Status = 'Assigned';
			caseObj.Priority='Low';
			caseObj.Type='Incident';
			caseObj.CH_InitialDiagnosis__c = 'testt';
			//caseobj.CH_SolutionType__c='Other';
			caseobj.CH_Outage__c = 'No';
			caseobj.CH_SecurityGroup__c ='Test12345';
			caseobj.CH_IssueOccurenceDate__c =system.now().addMinutes(-1440);
			caseobj.CH_AssignedDate__c= system.today().addDays(-1);
			caseobj.Country__c = 'United States of America';
			caseobj.ProductId=prdlist[0].id;
			caseobj.ContactId=contact.Id;
			caseobj.AccountId=accObj1.id;
			caseObj.EntitlementId = entiObj.Id;			
			caseObj.AssetId = AstObj.Id;
			//System.debug('caseobj.ProductId'+caseobj.ProductId+'caseobj.Country__c'+caseobj.Country__c);
			//caseobj.CH_OutageStartDate__c =System.now().addMinutes(-1440);
			//caseobj.CH_OutageEndDate__c  = System.now().addMinutes(-1439);
			insert caseObj;
			
			ContractLineItem CLI= [SELECT Id, ServiceContract.CH_Entitlement__c FROM ContractLineItem limit 1];
			
			Entitlement Ent= [SELECT Id, ContractLineItem.ServiceContract.CH_Entitlement__c FROM Entitlement limit 1];
			if (Ent.ContractLineItem.ServiceContract.CH_Entitlement__c == null)
				Ent.ContractLineItem.ServiceContract.CH_Entitlement__c = CLI.ServiceContract.CH_Entitlement__c;   
			
			Case caseObj1= [SELECT Id,EntitlementId, Entitlement.ContractLineItem.ServiceContract.CH_Entitlement__c FROM Case limit 1];
			if(caseObj1.Entitlement.ContractLineItem.ServiceContract.CH_Entitlement__c==null)
				caseObj1.Entitlement.ContractLineItem.ServiceContract.CH_Entitlement__c=Ent.ContractLineItem.ServiceContract.CH_Entitlement__c;
			update caseObj1;
			
			Test.stopTest();
			
			
			
			list<Case> aCases = new list<Case>([SELECT Id,EntitlementId, Entitlement.ContractLineItem.ServiceContract.CH_Entitlement__c FROM Case limit 1]);
			system.assertEquals(aCases.size(), 1);
			System.assert(aCases[0].Entitlement.ContractLineItem.ServiceContract.CH_Entitlement__c != null);
			
			
			map<Id, Case> cases = new map<Id, Case>();
			for(Case carec: aCases)
				cases.put(carec.Id,carec);	  

			CH_AuthorizedContactSharing obj=new CH_AuthorizedContactSharing();
			obj.unshareAuthorizedContacts(cases);
			
		}   
	} //test end for NOKIASC-26448
	
	@IsTest
	public static void testShareAuthorizedContactsWithCaseList(){
		
		System.runAs(new User(Id = UserInfo.getUserId())){
			CH_AuthorizedContactSharing.authorizedContactSharingCalculated = false;
			CH_AvoidRecursion.doNtExcuteCseTrggr4NotfcationBtch = true;
			Account accObj = new Account();
			accObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
			accObj.Name ='Nokia OYJ';
			accObj.AccountNumber ='76521';
			insert accObj;
			
			Contact contact = new Contact(lastName= 'ctt last Name', AccountId=accObj.id, Email= 'test12356@nokia.com', CH_ContactType__c = 'Nokia Employee');
			insert contact;
			
			Account accObj1 = new Account();
			accObj1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			accObj1.Name ='Nokia OYJ';
			accObj1.AccountNumber ='76521';
			accObj1.ParentId =accObj.Id;
			insert accObj1;
			
			AccountContactRelation accountContactRelation = new AccountContactRelation();
			accountContactRelation.AccountId = accObj1.Id;
			accountContactRelation.ContactId = contact.id;
			accountContactRelation.NCP_Entitlement_Relationship__c = true;
			accountContactRelation.Roles = 'Other';
			insert accountContactRelation;
			
			
			List<Product2> prdlist =CAPS_TestDataUtil.createProductRecord(1);
			insert prdlist;
			
			Asset AstObj = new Asset();
			AstObj.RecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Covered Product').getRecordTypeId();
			AstObj.CH_CDB_ExternalAssetId__c = '41445';
			AstObj.Name ='Test5';
			AstObj.AccountId =accObj1.id;
			AstObj.CH_CDB_ExternalAssetId__c = '123123';
			insert AstObj;
			
			
			PricebookEntry standardPrice = new PricebookEntry();
			standardPrice.Pricebook2Id= Test.getStandardPricebookId();
			standardPrice.Product2Id= prdlist[0].id;
			standardPrice.UnitPrice = 10000;
			standardPrice.IsActive = true;
			insert standardPrice;
			
			ServiceContract scObj = new ServiceContract();
			scObj.Name ='test5';
			scobj.CH_CDB_ContractId__c ='12345';
			scObj.CH_CDB_CustomerId__c ='76521';
			scObj.AccountId =accObj1.id;
			scObj.Pricebook2Id =Test.getStandardPricebookId();
			insert scobj;
			
			ContractLineItem CLIObj = new ContractLineItem();
			CLIObj.ServiceContractId = scobj.Id;
			CLIObj.AssetId = AstObj.Id;
			CLIObj.UnitPrice = 0;
			CLIObj.Quantity = 1;
			CLIObj.PricebookEntryId = standardPrice.Id;
			CLIObj.CH_ServiceOffering__c = 'test123';
			CLIObj.CH_ServiceType__c = 'Customer Support'; 
			CLIObj.CH_ServiceMappingId__c = 'Legacy Customer Support Service - Critical Major Minor 24x7';	
			Insert CLIObj;
			
			Entitlement entiObj = new Entitlement();
			entiObj.Name ='test123';		
			entiObj.CH_ServiceMappingId__c ='Legacy Customer Support Service - Critical Major Minor 24x7';
			entiObj.AccountId =accObj1.id;
			entiObj.CH_CDB_EntitlementId__c ='54321';
			entiObj.ServiceContractId= scObj.id;
			entiObj.ContractLineItemId=CLIObj.Id;
			entiObj.AssetId =AstObj.id;			
			insert entiObj;	
			
			scObj.CH_Entitlement__c = entiObj.Id;
			update scObj;
			
			CLIObj.CH_Entitlement__c = entiObj.Id;
			Update CLIObj;
			
			Test.startTest();
			EntitlementContact ec = new EntitlementContact();
			ec.contactId = contact.Id;
			ec.entitlementId = entiObj.Id; 
			insert ec;
			
			
			Case caseObj = new Case();
			caseObj.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Nokia Standard Case').getRecordTypeId();
			caseObj.Description = 'test2';
			caseObj.Subject = 'test2';
			caseObj.Severity__c = 'Minor';
			caseObj.Status = 'Assigned';
			caseObj.Priority='Low';
			caseObj.Type='Incident';
			caseObj.CH_InitialDiagnosis__c = 'testt';
			//caseobj.CH_SolutionType__c='Other';
			caseobj.CH_Outage__c = 'No';
			caseobj.CH_SecurityGroup__c ='Test12345';
			caseobj.CH_IssueOccurenceDate__c =system.now().addMinutes(-1440);
			caseobj.CH_AssignedDate__c= system.today().addDays(-1);
			caseobj.Country__c = 'United States of America';
			caseobj.ProductId=prdlist[0].id;
			caseobj.ContactId=contact.Id;
			caseobj.AccountId=accObj1.id;
			caseObj.EntitlementId = entiObj.Id;			
			caseObj.AssetId = AstObj.Id;
			insert caseObj;
			
			ContractLineItem CLI= [SELECT Id, ServiceContract.CH_Entitlement__c FROM ContractLineItem limit 1];
			
			Entitlement Ent= [SELECT Id, ContractLineItem.ServiceContract.CH_Entitlement__c FROM Entitlement limit 1];
			if (Ent.ContractLineItem.ServiceContract.CH_Entitlement__c == null)
				Ent.ContractLineItem.ServiceContract.CH_Entitlement__c = CLI.ServiceContract.CH_Entitlement__c;   
			
			Case caseObj1= [SELECT Id,EntitlementId, Entitlement.ContractLineItem.ServiceContract.CH_Entitlement__c FROM Case limit 1];
			if(caseObj1.Entitlement.ContractLineItem.ServiceContract.CH_Entitlement__c==null)
				caseObj1.Entitlement.ContractLineItem.ServiceContract.CH_Entitlement__c=Ent.ContractLineItem.ServiceContract.CH_Entitlement__c;
			update caseObj1;
			
			Test.stopTest();
			
			
			
			list<Case> aCases = new list<Case>([SELECT Id,EntitlementId, Entitlement.ContractLineItem.ServiceContract.CH_Entitlement__c FROM Case limit 1]);
			system.assertEquals(aCases.size(), 1);
			System.assert(aCases[0].Entitlement.ContractLineItem.ServiceContract.CH_Entitlement__c != null);
			
			
			map<Id, Case> cases = new map<Id, Case>();
			for(Case carec: aCases)
				cases.put(carec.Id,carec);	  
			
			CH_AuthorizedContactSharing obj=new CH_AuthorizedContactSharing();
			obj.shareAuthorizedContacts(cases);
			
		}   
	} 
	
	@IsTest
	public static void testUnshareAuthorizedContactsWithMapEntitlementsContacts(){
		
		
		Test.startTest();
		
		System.runAs(new User(Id = UserInfo.getUserId())){
			CH_AuthorizedContactSharing.authorizedContactSharingCalculated = false;
			CH_AvoidRecursion.doNtExcuteCseTrggr4NotfcationBtch = false;
			
			UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
			Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
			
			User portalAccountOwner1 = new User(
				UserRoleId = portalRole.Id,
				ProfileId = profile1.Id,
				Username = System.now().millisecond() + 'test234@test.com',
				Alias = 'batman',
				Email='bruce.wayne@wayneenterprises.com',
				EmailEncodingKey='UTF-8',
				Firstname='Bruce1',
				Lastname='Wayne2',
				LanguageLocaleKey='en_US',
				LocaleSidKey='en_US',
				TimeZoneSidKey='America/Chicago'
			);
			Database.insert(portalAccountOwner1);
			
			List<Account> oProspectList;
			Account oLegalEntity;
			Contact oContact;
			
			System.runAs ( portalAccountOwner1 ) {
				
				oProspectList = TestDataFactory.createAccount('Prospect', 1, null);
				oProspectList.get(0).OwnerId = portalAccountOwner1.Id;
				insert oProspectList;
				
				oLegalEntity = TestDataFactory.createAccount('Legal_Entity', 1, oProspectList.get(0).Id).get(0);
				insert oLegalEntity;
				
				oContact = TestDataFactory.createContact(1, oProspectList.get(0)).get(0);
				oContact.LastName = 'Test LastName';
				oContact.CH_ContactType__c = 'customer';
				insert oContact;
				
				//Create user
				Profile portalProfile = [SELECT Id FROM Profile where name ='Customers' Limit 1];
				User user1 = new User(
					Username = System.now().millisecond() + 'test12345@test.com',
					ContactId = oContact.Id,
					ProfileId = portalProfile.Id,
					Alias = 'test123',
					Email = 'test12345@test.com',
					EmailEncodingKey = 'UTF-8',
					LastName = 'McTesty',
					CommunityNickname = 'test12345',
					TimeZoneSidKey = 'America/Los_Angeles',
					LocaleSidKey = 'en_US',
					LanguageLocaleKey = 'en_US'
				);
				Database.insert(user1);
			}
			
			List<Product2> oProduct2List = TestDataFactory.createProduct(1);
			insert oProduct2List;
			
			Asset oAsset = TestDataFactory.createAsset('CH_CoveredProduct', 1, oLegalEntity, oProduct2List.get(0)).get(0);
			insert oAsset;
			
			
			
			PriceBookEntry tempPriceBookEntry = new PriceBookEntry(
				Pricebook2Id = Test.getStandardPricebookId(),
				Product2Id = oProduct2List.get(0).id,
				UnitPrice = 0,
				IsActive = true
			);
			Insert tempPriceBookEntry;
			
			ServiceContract oServiceContract = TestDataFactory.createServiceContract(1, oProspectList.get(0), false).get(0);
			insert oServiceContract;
			
			ContractLineItem oContractLineItem = TestDataFactory.createContractLineItem(1, oServiceContract, oAsset,tempPriceBookEntry , false).get(0);
			insert oContractLineItem;	
			
			List<Entitlement> oEntitlementList = TestDataFactory.createEntitlement(1, oProspectList.get(0), oAsset);
			oEntitlementList.get(0).ContractLineItemId=oContractLineItem.Id;
			insert oEntitlementList; 
			
			List<EntitlementContact> oEntitlementContactList = TestDataFactory.createEntitlementContact(1, oEntitlementList.get(0), oContact);
			insert oEntitlementContactList;
			
			oServiceContract.CH_Entitlement__c = oEntitlementList.get(0).Id;
			update oServiceContract;
			
			system.debug('zzz enttitlementContactID '+oEntitlementContactList.get(0));
			Case oCase = TestDataFactory.createCase('CH_NokiaIncidentWithRestoration', 1, oLegalEntity, oContact, oProduct2List.get(0)).get(0);
			oCase.Entitlementid=oEntitlementList.get(0).Id;
			insert oCase;	
			
			system.debug('zzz '+[SELECT id, Entitlement.ContractLineItem.ServiceContract.CH_Entitlement__c FROM Case ]);
			
			map<Id, EntitlementContact> entitlementContactslist = new map<Id, EntitlementContact>();
			for(EntitlementContact ecs: oEntitlementContactList)
				entitlementContactslist.put(ecs.Id,ecs);
			
			system.debug('zzz '+entitlementContactslist );
			
			
			CH_AuthorizedContactSharing.unshareAuthorizedContacts(entitlementContactslist);
		}  
		Test.stopTest();	   
	} 
}