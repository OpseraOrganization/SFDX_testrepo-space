/** 
About   
-----
Description: TestDataFactory Class to be reused by all Test classes.

Created for: Nokia Customer Portal 
Created date: 12 14 2017

Details / Methods   
-----------------   
SearchDocumentTypes - Used to get the access types related to a specific user/product 

Update History  
--------------  
Created: 12 14 2017 – AES 

Issues / TODOs  
--------------
**/

@isTest
public with sharing class NCP_TestFactory {

  /*
  * @desc this method creates user
  * @param   lastName : string representing users lastName
  * @param   profileName : the profile to associate to users
  * @return  User : the created user.
  */

  public static User createUser(Boolean isAdmin, String lastName, Contact con, String username) {

	Set<String> customerUserTypes = new Set<String>();
  //  List<Profile> pro = new List<Profile>();
  //  List<PermissionSet> psList ;
	
	Profile p ;
	PermissionSet ps;	
	
	Id profileIDs ;
	
	if (isAdmin) {
	  customerUserTypes = new Set<String>{
		  'System Administrator'
	  };
	  profileIDs = [select Id,name from Profile where Name in :customerUserTypes limit 1].Id;
	} else {
	  customerUserTypes = new Set<String>{
		  'PowerCustomerSuccess'
	  };
	  profileIDs = [SELECT ProfileId, Profile.Name, Profile.UserType, Profile.UserLicense.Name FROM PermissionSet WHERE Profile.UserType = 'PowerCustomerSuccess' AND IsCustom = true AND Profile.UserLicense.Name = 'Customer Community Plus' limit 1].profileId;
	}
	String NokiaId = ('' + (math.random() * 1234567890)).substring(0, 8);
	for (User u : [Select Id from user where Nokia_ID__c = :NokiaId limit 1]) {
	  NokiaId = ('' + (math.random() * 123456789)).substring(0, 8);
	}
	User newUser = new User(
		profileId = profileIDs ,
		username = username,
		email = username,
		emailencodingkey = 'UTF-8',
		localesidkey = 'en_US',
		languagelocalekey = 'en_US',
		timezonesidkey = 'America/Los_Angeles',
		alias = 'nuser',
		lastname = 'lastname',
		Nokia_ID__c = NokiaId
	);
	if (!isAdmin) {
	  newUser.contactId = con.id;
		} else {
	  UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
	  newUser.UserRoleId = portalRole.Id;
	}
	return newUser;
  }


  public static User createUserWithFedId(Boolean isAdmin, String lastName, Contact con, String username, String NokiaId) {

	Set<String> customerUserTypes = new Set<String>();
	Profile p ;

	if (isAdmin) {
	  customerUserTypes = new Set<String>{
		  'System Administrator'
	  };
	  p = [select Id,name from Profile where Name in :customerUserTypes limit 1];
	} else {
	  customerUserTypes = new Set<String>{
		  'PowerCustomerSuccess'
	  };
	  p = [select Id,name from Profile where UserType in :customerUserTypes limit 1];
	}
	User newUser = new User(
		profileId = p.id,
		username = username,
		email = username,
		emailencodingkey = 'UTF-8',
		localesidkey = 'en_US',
		languagelocalekey = 'en_US',
		timezonesidkey = 'America/Los_Angeles',
		alias = 'nuser',
		lastname = 'lastname',
		Nokia_ID__c = NokiaId
	);
	if (!isAdmin) {
	  newUser.contactId = con.id;
	} else {
	  UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
	  newUser.UserRoleId = portalRole.Id;
	}
	return newUser;
  }
  public static User createHorizontalUser(String lastName, Contact con, String username) {

	Set<String> customerUserTypes = new Set<String>();
	Profile p ;

	customerUserTypes = new Set<String>{
		'PowerCustomerSuccess'
	};
	p = [select Id,name from Profile where UserType in :customerUserTypes limit 1];
	UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];

	String NokiaId = ('' + (math.random() * 1234567890)).substring(0, 8);
	for (User u : [Select Id from user where Nokia_ID__c = :NokiaId limit 1]) {
	  NokiaId = ('' + (math.random() * 123456789)).substring(0, 8);
	}
	User newUser = new User(
		profileId = p.id,
		username = username,
		email = username,
		emailencodingkey = 'UTF-8',
		localesidkey = 'en_US',
		languagelocalekey = 'en_US',
		timezonesidkey = 'America/Los_Angeles',
		alias = 'nuser',
		lastname = 'lastname',
		Nokia_ID__c = NokiaId,
		NCP_IsHorizontal__c = true,
		contactId = con.id
	);
	return newUser;
  }

  public static User createInternalUser(String lastName, String username) {

	Set<String> customerUserTypes = new Set<String>();
	Profile p = [select Id,name from Profile where Name = 'Standard User' limit 1];
	String NokiaId = ('' + (math.random() * 1234567890)).substring(0, 8);
	for (User u : [Select Id from user where Nokia_ID__c = :NokiaId limit 1]) {
	  NokiaId = ('' + (math.random() * 123456789)).substring(0, 8);
	}
	User newUser = new User(
		profileId = p.id,
		username = username,
		email = username,
		emailencodingkey = 'UTF-8',
		localesidkey = 'en_US',
		languagelocalekey = 'en_US',
		timezonesidkey = 'America/Los_Angeles',
		alias = 'nuser',
		lastname = 'lastname',
		Nokia_ID__c = NokiaId,
		NCP_Is_Internal__c = true
	);
	return newUser;
  }


  /*
  * @desc this method creates contact related to an account
  * @return  User : the created contact.
  */
  public static Contact createContact(Account acc) {

	CH_AccountName__c settings = CH_AccountName__c.getOrgDefaults();
	settings.CH_InvalidName__c = 'Nokia';
	settings.CH_ValidName__c = 'Nokia OYJ';
	upsert settings;

	Contact cont = new Contact();
	cont.AccountId = acc.Id;
	cont.FirstName = 'First Name';
	cont.LastName = 'Last Name';
	cont.Email = 'test@salesforceTest.com';
	cont.City__c = 'City';
	cont.Street__c = 'Street';
	cont.State__c = 'State';
	cont.Country__c = 'Country';
	cont.Phone = '0550222333';
	cont.CH_ContactTimeZone__c = '(GMT+14:00) Line Islands Time (Pacific/Kiritimati)';
	cont.CH_PreferredMtdOfServiceCommunication__c = 'Email ';

	insert cont;
	return cont;
  }

  /*
  * @desc this method creates Accounts
  * @return  the created Account list
  */
  public static Account createAccount() {
	Account acc = new Account(
		Name = 'test',
		recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
	);
	insert acc;
	return acc;
  }
  public static Account create301Account() {
	Account acc = new Account(
		Name = '301',
		recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
	);
	insert acc;
	return acc;
  }

  public static Account createLegalAccount(Id parentAccountId) {
	Account acc = new Account(
		Name = 'test',
		recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY),
		parentId = parentAccountId
	);
	insert acc;
	return acc;
  }

  public static Account createAccount(String accName) {
	Account acc = new Account(
		Name = accName,
		accountNumber = NCP_CustomerCommunitySetting__c.getValues('Default').Customer_Account_Number__c,
		Acc_No__c = '123ABC123',
		recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER)
	);
	insert acc;
	return acc;
  }


  /*
  * @desc this method creates Products
  * @return  product
  */
  public static Product2 createProduct() {
	PriceBook2 cdpPriceBook = new PriceBook2(name='CDB Price Book', isActive = true);
	PriceBook2 caresPriceBook = new PriceBook2(name='CARES Price Book', isActive = true);
	insert cdpPriceBook;
	insert caresPriceBook;
	Product2 pr = new Product2(Name = 'Laptop X200',
		Family = 'Hardware', IsActive = true, NCP_Origin__c = 'OLCS');
	insert pr;
	return pr;
  }
  /*
  * @desc   this method creates Products
  * @return  product
  */
  public static Product2 createProductWithName(String productName) {

	PriceBook2 standardPriceBook = new PriceBook2(name='Standard Price Book', isActive = true);
	PriceBook2 cdbPriceBook = new PriceBook2(name='CDB Price Book', isActive = true);
	PriceBook2 caresPriceBook = new PriceBook2(name='CARES Price Book', isActive = true);
	insert standardPriceBook;
	insert cdbPriceBook;
	insert caresPriceBook;

	Product2 pr = new Product2();
	pr.Name = productName;
	pr.Family = 'Hardware';
	pr.IsActive = true;
	pr.NCP_Origin__c = 'OLCS';
	pr.NCP_CAREACTIVATE__c = 'true';
	pr.PMD_Product_Item_Type__c = 'NSN Solution';
	pr.PMD_Portfolio_Classification__c='Product';
	pr.DataUsage__c='CARES';

	insert pr;
	return pr;
  }
  /*
  * @desc this method creates AccountContactRelations 
  * @return  AccountContactRelations
  */
  public static AccountContactRelation createAccountContactRelation(Id cId, Id aId, Boolean b) {

	AccountContactRelation cr = new AccountContactRelation(ContactId = cId,
		AccountId = aId, NCP_Entitlement_Relationship__c = b);
	insert cr;
	return cr;
  }
  /*
  * @desc this method creates Service Contract
  * @param   acc : the account related to the service contract 
  * @return  ServiceContract
  */
  public static ServiceContract createServiceContract(Account acc, String ct) {
	Id RecordTypeId = NCP_Utils.getObjectRecordTypeId('ServiceContract', NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_PARENT);
	ServiceContract sc = new ServiceContract(NCP_External_Status__c = 'Active', RecordTypeId = RecordTypeId,
		Name = 'test sc', AccountID = acc.id, Pricebook2Id = Test.getStandardPricebookId(),
		NCP_Contract_Type__c = ct, startDate = System.today(), endDate = System.today() + 5);
	insert sc;
	return sc;
  }

  public static ServiceContract createServiceContract(Account acc, String ct, Boolean isInsert) {
	Id RecordTypeId = NCP_Utils.getObjectRecordTypeId('ServiceContract', NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_PARENT);
	ServiceContract sc = new ServiceContract(NCP_External_Status__c = 'Active', RecordTypeId = RecordTypeId,
		Name = 'test sc', AccountID = acc.id, Pricebook2Id = Test.getStandardPricebookId(),
		NCP_Contract_Type__c = ct, startDate = System.today(), endDate = System.today() + 5);

	if (isInsert) {
	  insert sc;
	}
	return sc;
  }

  /*
  * @desc this method creates Service Contract
  * @param   acc : the account related to the service contract 
  * @return  ServiceContract
  */
  public static ServiceContract createChildServiceContract(Account acc, ServiceContract Contract, String access, String rs, Boolean isDef) {
	Id RecordTypeId = NCP_Utils.getObjectRecordTypeId('ServiceContract', NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_CHILD);
	ServiceContract sc = new ServiceContract(NCP_External_Status__c = 'Active', RecordTypeId = RecordTypeId,
		Name = 'test sc', AccountID = acc.id, Pricebook2Id = Test.getStandardPricebookId(),
		NCP_Entitlement_Access_Type__c = access, NCP_Entitlement_Relationship__c = rs,
		ParentServiceContractId = Contract.Id, NCP_Default__c = isDef);
	insert sc;
	return sc;
  }

  public static ServiceContract createChildServiceContract(Account acc, ServiceContract Contract, String access, String rs, Boolean isDef, Boolean isInsert) {
	Id RecordTypeId = NCP_Utils.getObjectRecordTypeId('ServiceContract', NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_CHILD);
	ServiceContract sc = new ServiceContract(NCP_External_Status__c = 'Active', RecordTypeId = RecordTypeId,
		Name = 'test sc', AccountID = acc.id, Pricebook2Id = Test.getStandardPricebookId(),
		NCP_Entitlement_Access_Type__c = access, NCP_Entitlement_Relationship__c = rs,
		ParentServiceContractId = Contract.Id, NCP_Default__c = isDef);

	if (isInsert) {
	  insert sc;
	}
	return sc;
  }
  public static ServiceContract createChildServiceContractNoRestrickValues(Account acc, ServiceContract Contract, String access, String rs, Boolean isDef, Boolean isInsert) {
	Id RecordTypeId = NCP_Utils.getObjectRecordTypeId('ServiceContract', NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_CHILD);
	ServiceContract sc = new ServiceContract(NCP_External_Status__c = 'Active', RecordTypeId = RecordTypeId,
		Name = 'test sc', AccountID = acc.id, Pricebook2Id = Test.getStandardPricebookId(),
		NCP_Entitlement_Relationship__c = rs, NCP_Entitlement_Access_Type__c = access,
		ParentServiceContractId = Contract.Id, NCP_Default__c = isDef);

	if (isInsert) {
	  insert sc;
	}
	return sc;
  }


  /*
  * @desc this method creates Other Service Child Contract
  * @param   acc : the account related to the service contract 
  * @return  ServiceContract
  */
  public static ServiceContract createOtherServicesChildContract(Account acc, ServiceContract Contract, String access, String rs) {
	Id RecordTypeId = NCP_Utils.getObjectRecordTypeId('ServiceContract', NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_OTHER);
	ServiceContract sc = new ServiceContract(NCP_External_Status__c = 'Active', RecordTypeId = RecordTypeId,
		Name = 'test sc', AccountID = acc.id, Pricebook2Id = Test.getStandardPricebookId(),
		NCP_Entitlement_Access_Type__c = access, NCP_Entitlement_Relationship__c = rs,
		ParentServiceContractId = Contract.Id);
	insert sc;
	return sc;
  }
  /*
   * @desc  this method creates Other Service Child Contract
   * @param   acc : the account related to the service contract
   * @return  ServiceContract
   */
  public static ServiceContract createOtherServicesChildContractNoRestrickValues(Account acc, ServiceContract Contract, String access, String rs) {
	Id RecordTypeId = NCP_Utils.getObjectRecordTypeId('ServiceContract', NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_OTHER);
	ServiceContract sc = new ServiceContract(NCP_External_Status__c = 'Active', RecordTypeId = RecordTypeId,
		Name = 'test sc', AccountID = acc.id, Pricebook2Id = Test.getStandardPricebookId(),
		ParentServiceContractId = Contract.Id);
	insert sc;
	return sc;
  }

  public static contractLineItem createContractLineItem(Product2 pr, ServiceContract sc) {
	PricebookEntry pbe = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = pr.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
	insert pbe;
	ContractLineItem cli = new ContractLineItem(NCP_External_Status__c = 'Active', ServiceContractId = sc.Id, PricebookEntryId = pbe.Id, Quantity = 1, UnitPrice = pbe.UnitPrice);
	insert cli;
	return cli;
  }

  public static NCP_Authorised_Entitlement__c createAuthorisedEntitlement(Contact c, ServiceContract sc) {
	NCP_Authorised_Entitlement__c contEnt = new NCP_Authorised_Entitlement__c(NCP_External_Status__c = 'Active', NCP_Contact__c = c.id, NCP_Service_Contract__c = sc.id);
	insert contEnt;
	return contEnt;
  }

  public static NCP_Authorised_Entitlement__c createAuthorisedEntitlement(Contact c, ServiceContract sc, Id lineItemId) {
	NCP_Authorised_Entitlement__c authorisedEntitlement = new NCP_Authorised_Entitlement__c(
		NCP_External_Status__c = 'Active',
		NCP_Contact__c = c.id,
		NCP_Service_Contract__c = sc.id,
		NCP_Contract_Line_Item__c = lineItemId);

	insert authorisedEntitlement;
	return authorisedEntitlement;
  }

  public static NCP_Authorised_Entitlement__c createAuthorisedEntitlement(Account acc, ServiceContract sc, Id lineItemId, Boolean isInsert) {
	NCP_Authorised_Entitlement__c authorisedEntitlement = new NCP_Authorised_Entitlement__c(
		NCP_External_Status__c = 'Active',
		NCP_Account__c = acc.id,
		NCP_Service_Contract__c = sc.id,
		NCP_Contract_Line_Item__c = lineItemId);

	if (isInsert) {
	  insert authorisedEntitlement;
	}
	return authorisedEntitlement;
  }

  public static NCP_Product_Content__c createProductService(Id prId, String access) {
	NCP_Product_Content__c prAccess = new NCP_Product_Content__c(NCP_Product__c = prId, NCP_Service__c = access);
	insert prAccess;
	return prAccess;
  }

  public static void createInternalService(Id userId, String service) {
	NCP_Internal_Users_Services__c interService = new NCP_Internal_Users_Services__c(NCP_Service__c = service, NCP_User__c = userId);
	insert interService;
  }

  /*
  * @desc this method loads Service Tiles mdt
  * @return  tiles
  */
  public static NCP_Service_Tile__mdt loadServiceTiles() {
	NCP_Service_Tile__mdt tiles = [SELECT NCP_Public_Access__c, NCP_Default_Access__c, NCP_Title__c, NCP_Description__c, NCP_Entitlement_Access_Type__c, NCP_URL__c FROM NCP_Service_Tile__mdt WHERE NCP_Entitlement_Access_Type__c = 'Order Entry' LIMIT 1];
	return tiles;
  }

  public static List<NCP_Service_Tile__mdt> loadAllServiceTiles() {
	List<NCP_Service_Tile__mdt> tiles = [SELECT NCP_Public_Access__c, NCP_Default_Access__c, NCP_Title__c, NCP_Description__c, NCP_Entitlement_Access_Type__c, NCP_URL__c FROM NCP_Service_Tile__mdt];
	return tiles;
  }

  /*
  * @desc this method loads public/private Service Tiles mdt 
  * @return  tiles
  */
  /* public static List<NCP_Service_Tile__mdt> loadPublicDefaultServiceTiles() {
	 List<NCP_Service_Tile__mdt> tiles = new list<NCP_Service_Tile__mdt>();
	 List<NCP_Service_Tile__mdt> entitledTiles = [SELECT NCP_Public_Access__c, NCP_Default_Access__c, NCP_Title__c, NCP_Description__c, NCP_Entitlement_Access_Type__c, NCP_URL__c FROM NCP_Service_Tile__mdt WHERE NCP_Entitlement_Access_Type__c = 'ClicS'];
	 List<NCP_Service_Tile__mdt> publicTiles = [SELECT NCP_Public_Access__c, NCP_Default_Access__c, NCP_Title__c, NCP_Description__c, NCP_Entitlement_Access_Type__c, NCP_URL__c FROM NCP_Service_Tile__mdt WHERE NCP_Public_Access__c = true];
	 List<NCP_Service_Tile__mdt> defaultTiles = [SELECT NCP_Public_Access__c, NCP_Default_Access__c, NCP_Title__c, NCP_Description__c, NCP_Entitlement_Access_Type__c, NCP_URL__c FROM NCP_Service_Tile__mdt WHERE NCP_Default_Access__c = true];
	 tiles.addAll(entitledTiles);
	 tiles.addAll(publicTiles);
	 tiles.addAll(defaultTiles);
	 return tiles;
   }*/


  /*
  * @desc this method loads Emergency Supports countries mdt
  * @return  countries
  */
  public static List<NCP_EmergencySupport_Setting__c> loadCountries() {
	List<NCP_EmergencySupport_Setting__c> countries = [SELECT NCP_Country__c FROM NCP_EmergencySupport_Setting__c WHERE NCP_Country__c != 'Global'];
	return countries;
  }

  /*
   * @desc  this method loads Emergency Supports Tel mdt
   * @return  telContact
   */
  public static List<NCP_EmergencySupport_Setting__c> loadTeleContact(String countryName) {
	List<NCP_EmergencySupport_Setting__c> telContact = [SELECT NCP_Contact_label__c, NCP_Contact_email_telephone__c FROM NCP_EmergencySupport_Setting__c WHERE NCP_Country__c = :countryName AND NCP_Country__c != 'Global'];
	return telContact;
  }

  /*
  * @desc this method loads Emergency Supports countries mdt
  * @return  globalEmailContact
  */

  /*public static List<NCP_EmergencySupport_Setting__c> loadEmailContact() {
	List<NCP_EmergencySupport_Setting__c> globalEmailContact = [SELECT NCP_Contact_label__c, NCP_Contact_email_telephone__c FROM NCP_EmergencySupport_Setting__c WHERE NCP_Country__c = 'Global'];
	return globalEmailContact;
  }*/

  /*public static NCP_Email_To_Company__c createEmailToCompany(String domaineString, Id accId) {
	NCP_Email_To_Company__c domaine = new NCP_Email_To_Company__c(NCP_Account__c = accId, NCP_Email_Domain__c = domaineString);
	insert domaine;
	return domaine;
  }*/

  /*
   * @desc  this method creates favorite Products
   * @return  product
   */
  public static NCP_Favorite_Product__c createFavoriteProduct(product2 product, User user) {

	NCP_Favorite_Product__c favoritePr = new NCP_Favorite_Product__c(NCP_Product_Id__c = product.Id,
		NCP_User__c = user.Id);
	insert favoritePr;
	return favoritePr;
  }

  /*
  * @desc this method creates NCP_CustomerCommunitySetting__c custom setting
  * @return  setting
  */
  public static NCP_CustomerCommunitySetting__c insertCustomSetting() {
	NCP_CustomerCommunitySetting__c setting = new NCP_CustomerCommunitySetting__c(Name = 'Default', Customer_User_Profile__c = 'Customers',
		 NCP_Customer_Login_Profile__c = 'Customers Login', Customer_Account__c = 'Customer - test',
		NCP_ATOS_User__c = 'atos@test.com', NCP_Nokia_HelpDesk_Email__c = 'email@test.com', Internal_User_Profile__c = 'DCP Internal Portal User',
		Customer_Account_Number__c = '5544332211', NokiaSSOEndPointURL__c = 'https:', SSOTargetEndPointURL__c = 'https:',
		Deactivate_Portal_User_Permission_Set__c = 'NCP_Deactivate_Portal_User_Button',License_Threshold_Limit__c='6000',Warning_System_Threshold__c='5800',
		License_Management_Group__c='SP_Licensing_Group1'
	);

	insert setting;
	return setting;
  }

  /*
  * @desc this method creates ISO_Country_Codes__c custom setting
  * @return  setting
  */
  public static ISO_Country_Codes__c insertIsoCountryCodes() {
	ISO_Country_Codes__c settings = new ISO_Country_Codes__c(
		Name = 'IN', Country_Name__c = 'India', Market__c = 'Market India'
	);
	insert settings;
	return settings;
  }

  /*
  * @desc this method creates NCP_EmergencySupport_Setting__c custom setting
  * @return  setting
  */
  public static NCP_EmergencySupport_Setting__c insertEmergencySupport() {
	NCP_EmergencySupport_Setting__c setting = new NCP_EmergencySupport_Setting__c(Name = 'USA', NCP_Contact_email_telephone__c = '+1-800-275-6654', NCP_Contact_Label__c = 'Toll Number:', NCP_Country__c = 'USA', NCP_Country_code__c = 'US');
	insert setting;
	return setting;
  }
  /*
  * @desc this method creates Global NCP_EmergencySupport_Setting__c custom setting
  * @return  setting
  */
  public static NCP_EmergencySupport_Setting__c insertGlobalEmergencySupport() {
	NCP_EmergencySupport_Setting__c setting = new NCP_EmergencySupport_Setting__c(Name = 'Global', NCP_Contact_email_telephone__c = 'repair@nokia.com', NCP_Contact_Label__c = 'Repair Requests', NCP_Country__c = 'Global', NCP_Country_code__c = 'Gl');
	insert setting;
	return setting;
  }
  public static NCP_Product_Access_Type__mdt loadProductAccess() {
	NCP_Product_Access_Type__mdt prodAccess = [SELECT MasterLabel,NCP_Type__c,NCP_My_entitlement_label__c FROM NCP_Product_Access_Type__mdt limit 1];
	return prodAccess;
  }

  public static Product2 createProduct(String name, String productCode, String businessGroup, String currencyIsoCode,
	  String portfolio, String nokiaState, Decimal configVersion, Boolean isActive) {

	PriceBook2 standardPriceBook = new PriceBook2(name='Standard Price Book', isActive = true);
	PriceBook2 cdbPriceBook = new PriceBook2(name='CDB Price Book', isActive = true);
	PriceBook2 caresPriceBook = new PriceBook2(name='CARES Price Book', isActive = true);
	insert standardPriceBook;
	insert cdbPriceBook;
	insert caresPriceBook;

	Product2 prod = new product2(
		Name = name,
		ProductCode = productCode,
		Business_Group__c = businessGroup,
		CurrencyIsoCode = currencyIsoCode,
		Portfolio__c = portfolio,
		NokiaCPQ_State__c = nokiaState,
		Apttus_Config2__Version__c = configVersion,
		IsActive = isActive);

	return prod;
  }

  /*
  * @desc this method creates AccountContactRelation
  * @return  AccountContactRelation
  */
  public static AccountContactRelation createAccountContactRelation(Account acc, Contact contact) {
	AccountContactRelation act = new AccountContactRelation(AccountId = acc.Id, ContactId = contact.Id, NCP_Entitlement_Relationship__c = true);
	insert act;
	return act;
  }

  public static AccountContactRelation getAccountContactRelation(String contactId) {
	AccountContactRelation act = [Select Id,AccountId,ContactId,NCP_Entitlement_Relationship__c from AccountContactRelation where ContactId = :contactId];
	return act;
  }
  public static NCP_Service_Contract_Team__c createServiceContractTeam(Id contractId, Id userId) {
	NCP_Service_Contract_Team__c sct = new NCP_Service_Contract_Team__c(NCP_Service_Contract_Id__c = contractId, NCP_Status__c = NCP_Constants.STATUS_ACTIVE, NCP_Team_Member__c = userId);
	insert sct;
	return sct;
  }
  public static Case createEntitlementCase(ServiceContract parent, Id childId, String conType, String available) {
	Case newCDBCase = new Case();
	newCDBCase.Issue_Reported_By__c = UserInfo.getUserId();
	newCDBCase.Status = NCP_Constants.STATUS_PENDING;
	if (parent != null) {
	  newCDBCase.NCP_Service_Contract__c = parent.Id;
	  newCDBCase.NCP_Service_Contract_team__c = parent.ContractNumber;
	}
	newCDBCase.NCP_Contract_Name__c = childId;
	newCDBCase.NCP_List_of_Requested_Available_Services__c = available;
	newCDBCase.NCP_Contract_Type__c = conType;
	newCDBCase.Subject = NCP_Constants.CASE_SUBJECT;
	newCDBCase.Description = 'test';
	newCDBCase.recordTypeId = NCP_Utils.getObjectRecordTypeId('Case', NCP_Constants.CASE_RT_DEVNAME_ENTITLEMENT);
	newCDBCase.priority = NCP_Constants.CASE_PRIORITY;
	insert newCDBCase;
	return newCDBCase;
  }
  public static void createServiceTeamMember(Id u, Id sc) {
	NCP_Service_Contract_Team__c team = new NCP_Service_Contract_Team__c(NCP_Team_Member__c = u, NCP_Service_Contract_Id__c = sc, NCP_Status__c = 'Active');
	insert team;
  }

}