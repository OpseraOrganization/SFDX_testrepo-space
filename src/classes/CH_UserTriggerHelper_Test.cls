@isTest(SeeAllData =False)
public class CH_UserTriggerHelper_Test {
	public static final String CONTTypeNokiaEmp = 'Nokia Employee'; 
	public static final String USA ='United States of America';
	public static final String LCSSCMM = 'Legacy Customer Support Service - Critical Major Minor 24x7';
	public static final String AmChicago ='America/Chicago';
	public static final String NOYJ = 'Nokia OYJ';
	@IsTest
	public static void testusertrigger(){	
		
		Test.startTest(); 
		
		System.runAs(new User(Id = UserInfo.getUserId())){
			CH_AuthorizedContactSharing.authorizedContactSharingCalculated = false;
			CH_AvoidRecursion.doNtExcuteCseTrggr4NotfcationBtch = false;
			Map<Id,User> oldusrMap = new Map<Id,User>();
			Map<Id,User> newusrMap = new Map<Id,User>();
			
			
			UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
			Profile profile1 = [Select Id from Profile where name = 'Data Loader Profile'];
			
			User portalAccountOwner1 = new User(
	UserRoleId = portalRole.Id,
	ProfileId = profile1.Id,
	Username = System.now().millisecond() + 'test2347@test.com',
	Alias = 'batman',
	Email='bruce.wayne@wayneenterpries.com',
	EmailEncodingKey='UTF-8',
	Firstname='Bruce1',
	Lastname='Wayne2',
	LanguageLocaleKey='en_US',
	LocaleSidKey='en_US',
	TimeZoneSidKey= 'GMT'
			);//CH_AuthorizedContactSharingTest.AmChicago
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
		Username = System.now().millisecond() + 'test12222345@test.com',
		ContactId = oContact.Id,
		ProfileId = portalProfile.Id,
		Alias = 'test123',
		Email = 'test12222345@test.com',
		EmailEncodingKey = 'UTF-8',
		LastName = 'McTesty',
		CommunityNickname = 'test12345',
		TimeZoneSidKey = 'America/Los_Angeles',
		LocaleSidKey = 'en_US',
		LanguageLocaleKey = 'en_US'
	);
	Database.insert(user1);
	
			}
			
			User Userrec2 = [Select id from user where Email = 'test12222345@test.com' limit 1];
			User Userrec1 = [Select id from user Where Email='bruce.wayne@wayneenterpries.com' limit 1];
			
			oldusrMap.put(Userrec1.id, Userrec1);
			newusrMap.put(Userrec2.id, Userrec2);
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
			List<recordType> rt = [select id, name from recordType where name ='CARE Service Contract'];
			ServiceContract oServiceContract = TestDataFactory.createServiceContract(1, oProspectList.get(0), false).get(0);
			oServiceContract.recordtypeId = rt[0].ID;
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
			oCase.CH_IssueOccurenceDate__c = system.today()-2;
			oCase.Entitlementid=oEntitlementList.get(0).Id;
			insert oCase;	
			
			map<Id, EntitlementContact> entitlementContactslist = new map<Id, EntitlementContact>();
			for(EntitlementContact ecs: oEntitlementContactList)
	entitlementContactslist.put(ecs.Id,ecs);
			
			User user2 =[select id, contactId from user where contactId = :oCase.contactId and IsActive = true];
			user2.IsActive = false;
			update user2;
			
			List<user>newUserList =[select id, contactId from user where contactId = :oCase.contactId];
			newUserList[0].IsActive = true;
			update  newUserList[0];
			
			Map<Id,User>oldUserMap = new Map<Id,User>();
			oldUserMap.put(user2.ID, user2);
			set<string> activatedUserID = new set<string>();
			activatedUserID.add(newUserList[0].id);
			CH_UserTriggerHelper.queryActiveUser( activatedUserID );
			CH_UserTriggerHelper.getEntitlementContact(oEntitlementContactList);
		}  
		Test.stopTest();	
	} 
}