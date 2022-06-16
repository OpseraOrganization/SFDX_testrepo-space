@IsTest
public  class CH_TestFactoryDefaults{ 
	public static String customerProfileID = null;
	public static List<User> internalUserList = new List<User>();
	public static List<User> portalUser = new List<User>();
	public static List<Account> AccountList = new List<Account>();
	public static List<Contact> oContactList = new List<Contact>();
	public static List<PriceBookEntry> PriceBookEntryDataList = new List<PriceBookEntry>();
	public static CH_AccountName__c  setting = new CH_AccountName__c  (); 
	public static list<AccountContactRelation> accountContactRelationList = new list<AccountContactRelation> (); 
	public static map<String, List<string>> oAccountContactMap =new map<String, List<string>>();//CustomerID, List<Contact> //Only if that Contact is Authorized
	public static User runAsUser = new User(Id = UserInfo.getUserId());
	private static integer NokiaId = 100;  
	private static String orgId = UserInfo.getOrganizationId();
	private static String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
	private static Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
	private static String uniqueName = orgId + dateString + randomInt;
	
	/***************************************************************************
Purpose : Creats Internal User
Parameters   : assignDefaultPerSetAndPublicGroup - Assignes deafult permission set and  Public Group
ISInsert is true :  Inserts the Record
fieldName : Pass the Profile Id else creats System Admin EX: fieldName.put('ProfileId', 'recorID');
********************************************************************************/
	public  static list<User> createInternalUsers(Boolean assignDefaultPerSetAndPublicGroup, Boolean isInsert, Integer recordCount, map<string,String> fieldName){
		List<User> newUsers = new List<User>();
		string profileId = null;
		UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
		if(fieldNAme !=null && fieldNAme.containsKey('ProfileId') ){
			profileId = fieldNAme.get('ProfileId');
		}else{
			profileId =  [Select Id from Profile where name = 'System Administrator' LIMIT 1].id;
		}
		for(Integer i=0; i<recordCount; i++){
			User userData = new User();
			userData.UserRoleId = portalRole.Id;
			userData.Lastname='CHAdmin-'+uniqueName;
			userData.Firstname='CHAdmin';
			userData.Alias = 'CH-ADM';
			userData.Username = uniqueName+i +'CH-Admin@test.com';
			userData.Email= System.now().millisecond() + 'test22@test.com';
			userData.EmailEncodingKey='UTF-8';
			userData.LanguageLocaleKey='en_US';
			userData.LocaleSidKey='en_US';
			userData.TimeZoneSidKey='America/Chicago';
			userData.Nokia_ID__c = 'CHTEST' + String.valueOf(NokiaId++);
			userData.ProfileId = profileId;
			newUsers.add(userData);
		}
		if(isInsert){
			insert newUsers;
			internalUserList = newUsers;
			if(assignDefaultPerSetAndPublicGroup){
				//Assigning default pulic group
				List<String> groupNameList = new List<String>();
				groupNameList.add('SEC_GWC|ALL');
				List<String> permissionSet = new List<String>();
				permissionSet.add('CH_Expert');
				assignToPublicGroup( groupNameList, newUsers);
				//Assigning default permission set
				assignToPermissionSet(permissionSet, newUsers);
			}
		}
		return newUsers;
	}
	
	/***************************************************************************
Purpose : Creats Portal User
Parameters   : runAsUser - mandatory user to avaoid mixed DML error message
oContact -  Contact for which Case will be created.
********************************************************************************/
	public  static user createPortalUser(Boolean isInsert, User runAsUser, Contact oContact){
		User userData = new User();
		Profile profileIdData = new Profile();
		if(customerProfileID ==null){
			profileIdData = [Select Id,Name from Profile where name ='Customers' LIMIT 1];
		}
		customerProfileID = profileIdData.Id;
		// Create account owner
		UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
		list<User> usrlst = new list<User>();
		if(runAsUser == null){
			usrlst = CH_TestFactoryDefaults.createInternalUsers(false, false, 1, null);
			usrlst[0].UserRoleId = portalRole.Id;
			insert usrlst;
			internalUserList = usrlst;
			runAsUser = usrlst[0];
		}
		System.runAs(runAsUser) {
			userData.Lastname = 'PortalUser';
			userData.Firstname= 'PortalUser';
			userData.Alias = 'CustomP';
			userData.ProfileId = profileIdData.Id;
			if(oContact != null){
				userData.ContactId  = oContact.Id;
			}else{
				userData.ContactId  = CH_TestFactoryDefaults.createContact( true,  1,  null, null, true)[0].Id;
			}
			userData.Username = System.now().millisecond() + 'Customer'+'@test.com';
			userData.Email= System.now().millisecond() + 'test112@test.com';
			userData.EmailEncodingKey='UTF-8';
			userData.LanguageLocaleKey='en_US';
			userData.LocaleSidKey='en_US';
			userData.TimeZoneSidKey='America/Chicago';
			userData.Nokia_ID__c = 'CHTEST' + String.valueOf(NokiaId++);
			if(userData != null){  
				insert userData;
				portalUser.add(userData);
			}
		}
		return userData;
	}
	/***************************************************************************
Purpose   : Creats Public Group
Parameters: GroupName - Pass the list of Group name
userList - List of users
********************************************************************************/
	public  static void assignToPublicGroup(List<String> GroupName, List<User> userList){
		List<GroupMember> groupMembersList = new List<GroupMember>();
		List<Group> secgrouplst = new List<Group>();
		secgrouplst = [SELECT Id FROM Group WHERE Name IN :GroupName];
		for (User tempUser : userList){
			for(Group grupId: secgrouplst){
				GroupMember secGroupMember = new GroupMember();
				secGroupMember.GroupId = grupId.id;
				secGroupMember.UserOrGroupId = tempUser.Id;
				groupMembersList.add(secGroupMember);
			}
		}
		if(!groupMembersList.isEmpty()){
			System.runAs(runAsUser) {   
				insert groupMembersList;					
			}
		}
	}
	
	/***************************************************************************
Purpose   : Assigns Permission Set
Parameters: PermissionsetName - Pass the list of Permission setName
userList - List of users
********************************************************************************/
	public  static void assignToPermissionSet( List<String> permissionSetName, List<User> userList){
		List<PermissionSetAssignment> PSAList = new List<PermissionSetAssignment>();
		List<PermissionSet> perSelst = new List<PermissionSet>();
		perSelst = [SELECT Id FROM PermissionSet WHERE Name IN :permissionSetName];
		for (User tempUser : userList){
			for(PermissionSet ps: perSelst){
				if(tempUser.ProfileId != customerProfileId){
					PermissionSetAssignment PSA = new PermissionSetAssignment();
					PSA.AssigneeId = tempUser.id;
					PSA.PermissionSetId = ps.Id;
					PSAList.add(PSA);
				}
			} 
		}
		if(!PSAList.isEmpty()){
			System.runAs(runAsUser) {   
				insert PSAList;					
			}
		}
	}
	/***************************************************************************
Purpose   : 

********************************************************************************/
	public static void defaultCustomsetting(){
		CH_AccountName__c accauth = new CH_AccountName__c();
	accauth.CH_InvalidName__c = 'Nokia';
	accauth.CH_ValidName__c = 'Nokia-OYJ';
		if ([SELECT Id FROM CH_AccountName__c WHERE CH_InvalidName__c = 'Nokia'].size() == 0){
			insert accauth;
		}
		 system.assert(accauth!=null);
		
	}
	
	
	/***************************************************************************
Purpose   :Creats Account Record and also allowing feasibilty to create AccountContact Relation
Parameters: isInsert - Insert the records
recordCount - No of Records to be created
recordtypeName - Name of the recordtype Legal Entity/Account
fieldNAme - Pass Customer Account Id : ex - fieldNAme.put('ParentId',recordIdOfAccount)else creats Customer Account
accountContactRelation - If True- Creates new Contact and creats AccountContactRelation - This applicable only for Legal entity account
If False - AccountContactRelation is not created
********************************************************************************/
	public  static list<Account> createAccountData(Boolean isInsert, Integer recordCount, String recordtypeName, map<string,String> fieldNAme, Boolean accountContactRelation){
		defaultCustomsetting();
		List<Account> oAccountList = new list<Account>();
		String accountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(recordtypeName).getRecordTypeId();
		List<Account> CustomerAccount = new List<account>();
		String parentAccountId = null;
		if(fieldNAme ==null && recordtypeName =='Legal_Entity'){
			CustomerAccount = createAccountData( true,  1,  'Customer',  null, false);//Manadatory LE
			parentAccountId = CustomerAccount[0].Id;
		}else if(fieldNAme !=null && fieldNAme.containsKey('ParentId') ){
			parentAccountId = fieldNAme.get('ParentId');
		}
		
		for(Integer i=0; i<recordCount ;i++)
		{
			Account accountData = new Account();
			if(recordtypeName =='Legal_Entity' ){
				accountData.ParentId =parentAccountId;
				accountData.Name ='testLE'+ i;
			   
			}else{
				 accountData.Name ='testCL'+ i;
			}
			accountData.RecordTypeId = accountRecordType;
			accountData.BillingStreet = 'Estrada Istanbul';
			accountData.BillingCity = 'London';
			accountData.BillingPostalCode = '5067567';
			accountData.BillingCountry = 'United Kingdom';
			accountData.AccountStatusInCRMOM__c = 'Active';
			accountData.Industry = 'Enterprise';
			accountData.Market__c = 'Market Europe';
			accountData.Country__c = 'India';
			accountData.AccountNumber = '301030823';
			accountData.Acc_No__c = '10'+i+recordTypeName; 
			oAccountList.add(accountData);
		}
		
		
		if(isInsert)
		{
			insert oAccountList;
			AccountList = oAccountList;
			if(recordtypeName =='Legal_Entity' && accountContactRelation)
			{
				fieldNAme = new map<string,String> ();
				fieldNAme.put('AccountId',oAccountList[0].ParentId);
				list<Contact> oContactList1 = CH_TestFactoryDefaults.createContact(true, 1, null, fieldNAme, false);
				List<accountContactRelation> accountContactRelationInsert = new  List<accountContactRelation> ();
				List<string> cid = new List<string>();
				cid.add(oContactList1[0].id);
				oAccountContactMap.put( oAccountList[0].ParentId, cid);
				createAcccountContactRelation( true,  oAccountList[0].Id,  oContactList1[0].id);
				   
			}
		}
		return oAccountList;
	}
	/***************************************************************************
Purpose   :Creats Contact Record and also allowing feasibilty to create AccountContact Relation
Parameters: isInsert - Insert the records
recordCount - No of Records to be created
recordtypeName - NA
fieldNAme - Pass Customer Account Id : ex - fieldNAme.put('AccountId',recordIdOfAccount)else creats Customer Account
accountContactRelation - If True- creats AccountContactRelation - This applicable only for Legal entity account
If False - AccountContactRelation is not created
********************************************************************************/
	public  static list<Contact> createContact(Boolean isInsert, Integer recordCount,  String recordType, map<string,String> fieldNAme, Boolean accountContactRelation){
		list<Contact> contactList = new List<contact>();
	   
		String CustomerAccountId = null;
		if(fieldNAme ==null  ){
			CustomerAccountId = createAccountData( true,  1,  'Customer',  null, false)[0].Id;
		}else{
			CustomerAccountId =fieldNAme.get('AccountId');
		}
		for(Integer i=0; i<recordCount ; i++){
			Contact contactData = new Contact ();
			contactData.FirstName = 'Customer Contact'+i;
			contactData.Lastname = String.valueOf(System.now().millisecond());
			contactData.Email = System.now().millisecond() + 'test32@test.com';
			contactData.AssistantName = 'Customer Contact'+i;
			contactData.AccountId = CustomerAccountId;
			contactList.add(contactData);
		}
		if(isInsert){
			insert contactList;
			oContactList = contactList;
			for(Contact c : contactList){
				List<string> ContactIdList = new List<string>();
				if(!oAccountContactMap.isEmpty() && oAccountContactMap.containsKey(c.AccountId)){
					ContactIdList =  oAccountContactMap.get(c.AccountId);
				}
				ContactIdList.add(c.Id);
				oAccountContactMap.put(c.AccountId, ContactIdList);
			}
		}
		return contactList;
	}
	/***************************************************************************
Purpose   :Creats createAcccountContactRelation
Parameters: isInsert - Insert the records
recordCount - No of Records to be created
fieldNAme - Pass  Account Id and Contact Id: ex - fieldNAme.put('AccountId',recordIdOfAccount)
fieldNAme.put('Contact',recordIdOfContact)
********************************************************************************/
	public static AccountContactRelation createAcccountContactRelation(Boolean isInsert, string AccountId , String ContactId ){
		accountContactRelationList = new list<AccountContactRelation>();
		AccountContactRelation accountContactRelation = new AccountContactRelation();
		accountContactRelation.NCP_Entitlement_Relationship__c = true;
		accountContactRelation.Roles = 'Other';
		accountContactRelation.ContactId = ContactId;
		accountContactRelation.AccountId = AccountId;
		if(isInsert){
			insert accountContactRelation;
		}
		return accountContactRelation;
	}
	/***************************************************************************
Purpose   :Creats ServiceContractData
Parameters: isInsert - Insert the records
recordCount - No of Records to be created
fieldNAme - Pass  Account Id  ex - fieldNAme.put('AccountId',recordIdOfAccount)
else Creats New Account along with(New Contact and AccountContactRelation)									 
********************************************************************************/
	public static List<ServiceContract> createServiceContractData(Boolean isInsert, Integer recordCount, map<string,String> fieldNAme){
		List<ServiceContract> serviceContractDataList = new List<ServiceContract>();
		String accountId = null;
		Id chContractRecordTypeId;
		chContractRecordTypeId = Schema.SObjectType.ServiceContract.getRecordTypeInfosByDeveloperName().get('CH_ServiceContract').getRecordTypeId();
		if(fieldNAme ==null  ){
			accountId = createAccountData( true,  1,  'Legal_Entity',  null, true)[0].Id;
		}else if(fieldName.get('AccountId')!=null){
			accountId = fieldName.get('AccountId');
		}
		for(Integer i=0;i<recordCount ; i++){
			ServiceContract oServiceContract = new ServiceContract();
			oServiceContract.AccountId =accountId;
			oServiceContract.Name = 'TestServiceContract'+Utils.generateRandomInteger(2) + Utils.generateRandomString(2);
			oServiceContract.CH_CDB_ContractId__c = '12345';
			oServiceContract.NCP_External_Status__c ='Active';
			
			oServiceContract.StartDate = system.today().AddDays(-5);
			oServiceContract.EndDate = system.today().AddDays(5);
			oServiceContract.CH_EntitlementScript__c = (isInsert)?'Header Script':'';
			oServiceContract.recordtypeID = chContractRecordTypeId;
			oServiceContract.Pricebook2Id = Test.getStandardPricebookId();
			oServiceContract.CH_PortalCaseCreationSWMaintenance__c = true;
			serviceContractDataList.add(oServiceContract);
			
		}
		if(isInsert){
			insert serviceContractDataList; // PMD ERRORS 
		}
		System.debug('serviceContractDataList---------------------->'+serviceContractDataList);
		return serviceContractDataList;
	}
	/***************************************************************************
Purpose   :Creats ContractLineItem
Parameters: isInsert - Insert the records
recordCount - No of Records to be created 
fieldNAme - Either  null or pass all  Parameters ASsetID,ServiceContactId and AccountId
(AccountId should be same for serviceContract and AssetId )
- If fieldNAme == null Creates  Account,ServiceContact and Asset with default value		 
********************************************************************************/
	public static List<ContractLineItem> createContractLineItemData(Boolean isInsert, Integer recordCount, map<string,String> fieldNAme){
		List<ContractLineItem> ContractLineItemDataList = new List<ContractLineItem>();
		List<ServiceContract> ServiceContractList = new List<ServiceContract>();
		String oAssetId = null;
		String serviceContractId = null;
		String pricebookEntryId = null;
		String AccountId = null;
		map<string, string> fieldMap = new map<string, string>();
		if(fieldNAme ==null ){
			ServiceContractList =createServiceContractData( true,  1,  null);
			serviceContractId = ServiceContractList[0].ID;
			fieldMap.put('AccountId',ServiceContractList[0].AccountId);
			Asset oAsset =createAssetData( true,  1,'CH_CoveredProduct', fieldMap)[0]; 
			oAssetId = oAsset.Id; 
			fieldMap.put('Pricebook2Id',test.getStandardPricebookId());
			fieldMap.put('product2Id',oAsset.product2Id);
			pricebookEntryId = createPriceBookEntry(  true, fieldMap)[0].Id;
		} else{
			AccountId = fieldName.get('AccountId') ;
			serviceContractId = fieldName.get('ServiceContractId') ;
			oAssetId = fieldName.get('AssetId') ;
			pricebookEntryId = fieldName.get('pricebookEntryId') ;
		}
		for(Integer i=0;i<recordCount ; i++){
			ContractLineItem oContractLineItem = new ContractLineItem();
			oContractLineItem.ServiceContractId =serviceContractId;
			oContractLineItem.PricebookEntryId = pricebookEntryId;
			oContractLineItem.AssetId = oAssetId;
			oContractLineItem.UnitPrice = 0;
			oContractLineItem.StartDate = system.today().AddDays(-5);
			oContractLineItem.EndDate = system.today().AddDays(5);
			oContractLineItem.Quantity = 1;
			ocontractLineItem.NCP_External_Status__c ='Active';
			oContractLineItem.CH_LineItemEntitlementScript__c = (isInsert)?'Script':'';
			oContractLineItem.CH_CountryISOName__c = 'USA';
			oContractLineItem.CH_CDB_EntitlementId__c = 'TEST'+i;
			oContractLineItem.CH_ServiceOffering__c = 'Test Offering';
			oContractLineItem.CH_ServiceType__c = ' Customer Support';
			oContractLineItem.CH_ServiceClassification__c = 'SW Service';
			oContractLineItem.CH_ServiceMappingId__c = 'Legacy Customer Support Service - Critical 24x7';//Must be assigned Static
			ContractLineItemDataList.add(oContractLineItem);
		}
		if(isInsert){
			insert ContractLineItemDataList;// PMD ERRORS 
		}
		System.debug('ContractLineItemDataList---------------------->'+ContractLineItemDataList);
		return ContractLineItemDataList;
	}
	/***************************************************************************
Purpose   :Creats Entitlement
Parameters: isInsert - Insert the records
recordCount - No of Records to be created 
fieldNAme - Either  null or pass all  Parameters ASsetID,ServiceContactId, AccountId and LineItemId
(AccountId should be same for serviceContract and AssetId )
- If fieldNAme == null Creates  Account,ServiceContact, ContractLineItem and Asset with default value		   
***************************************************************************************************************/
	public static List<Entitlement> createEntitlement(boolean isInsert, Integer Count, Map<String,String> Fields){
		List<Entitlement> testEnt = new List<Entitlement>();
		Id recordtypeid=  Schema.SObjectType.Entitlement.getRecordTypeInfosByDeveloperName().get('CH_Entitlement').getRecordTypeId(); 
		Date Now = Date.today();
	  
		List<Product2> prodList=new List<Product2>();
		Map<String, String> defaultValuesMap = new Map<String, String>();
		String serviceContractId = null;
		String lineItemId = null;
		String assetId = null;
		String accountId = null;
		
		if(fields== null){
			accountId = createAccountData(true,1,'Legal_Entity',null,true)[0].Id;
			defaultValuesMap.put('AccountId',accountId);
			serviceContractId = createServicecontractData(true,1,defaultValuesMap)[0].Id;
			defaultValuesMap.put('ServiceContractId',serviceContractId);
			String addressId=createAddressData(true,1,defaultValuesMap)[0].id;
			defaultValuesMap.put('Address__c',addressId);
			prodList = createProductDataSetUp(true,1,null);
			System.debug('prod created is'+prodList[0].Id);
			defaultValuesMap.put('Product2Id',prodList[0].Id);
			Asset oAsset =createAssetData(true,1,'CH_CoveredProduct',defaultValuesMap)[0];
			assetId = oAsset.Id;
			defaultValuesMap.put('AssetId',assetId);
			defaultValuesMap.put('Pricebook2Id',test.getStandardPricebookId());
			defaultValuesMap.put('pricebookEntryId',createPriceBookEntry(  true, defaultValuesMap)[0].Id);
			lineItemId = createContractLineItemData(true,1,defaultValuesMap)[0].Id;
		}else{
			accountId = Fields.get('AccountId');
			serviceContractId = Fields.get('ServiceContractId');
			assetId = Fields.get('AssetId');
			lineItemId = Fields.get('ContractLineItemId');
		}
		
		for(integer i=0; i<Count; i++){
			Entitlement newEnt = new Entitlement();
			newEnt.Name = 'Test Asset'+i;
			newEnt.Startdate = Now.addDays(-7); 
			newEnt.CH_CDB_EntitlementId__c = 'Test123'+i;
			newEnt.CH_EntitlementType__c = 'Entitled Asset';
			newEnt.CH_ServiceMappingId__c = 'Legacy Customer Support Service - All Severity 24x7';
			newEnt.AccountId = accountId;
			newEnt.ServiceContractId = serviceContractId;
			newEnt.AssetId = assetId;
			newEnt.RecordTypeId = recordtypeid;
			
			newEnt.ContractLineItemId = lineItemId;
			testEnt.add(newEnt);
		}
		if(isInsert){
			insert testEnt;
		}
		return testEnt;
	}
	
	public static List<Pricebook2> CreateCustomPriceBook(String priceBookName,  Boolean isInsert ){
		List<Pricebook2> PricebookDataSetup = new List<Pricebook2>();
		if( priceBookName !=null){
			Pricebook2 objpriceBook = new Pricebook2();
			objpriceBook.Name = priceBookName;
			objpriceBook.IsActive =true;
			PricebookDataSetup.add(objpriceBook);
		}
		if(isInsert){
			upsert PricebookDataSetup;
			system.assert(PricebookDataSetup.size() >0 );
		}
		return PricebookDataSetup;
	}
	
	public static list<Product2> createProductDataSetUp(Boolean isInsert, Integer recordCount, map<string,String> fieldNAme){
		list<Product2> productDataList = new list<Product2>();
		String salesProductRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Sales_Product').getRecordTypeId();
		for(Integer i=0; i<recordCount ;i++){
			Product2 productData = new Product2();
			productData.Name = 'Product'+i;
			productData.RecordTypeId = salesProductRecordTypeId;
			productData.PMD_Portfolio_Classification__c = 'Product';
			productData.CH_Business_Unit__c = 'NSW Network Management'+i;
			productDataList.add(productData);
		}
		if(isInsert){
			insert productDataList;
		}
		return productDataList;
	}
	public static List<PriceBookEntry>  createPriceBookEntry( Boolean isInsert, map<string,String> fieldNAme){
		List<PriceBookEntry> PriceBookEntryList = new List<PriceBookEntry>();
		String productId = null;
		String pricebookId = null;
		if(fieldNAme ==null){
			productId = createProductDataSetUp( true,  1, null)[0].Id;
			priceBookID = Test.getStandardPricebookId();
		}else{
			productId=fieldNAme.get('Product2Id');
			priceBookID = Test.getStandardPricebookId(); 
		}
		system.debug('****** productId'+productId);
		PriceBookEntry tempPriceBookEntry = new PriceBookEntry();
		tempPriceBookEntry.Product2Id = productId;
		tempPriceBookEntry.UnitPrice = 0;
		tempPriceBookEntry.IsActive = true;
		tempPriceBookEntry.Pricebook2Id = Test.getStandardPricebookId();
		PriceBookEntryList.add(tempPriceBookEntry); 
		if(priceBookID !=null && priceBookID != Test.getStandardPricebookId()){
			PriceBookEntry tempPriceBookEntryStd = new PriceBookEntry();
			tempPriceBookEntryStd.Product2Id =productId;
			tempPriceBookEntryStd.UnitPrice = 10;
			tempPriceBookEntryStd.IsActive = true;
			tempPriceBookEntryStd.Pricebook2Id = priceBookID;
			PriceBookEntryList.add(tempPriceBookEntryStd); 
		}
		system.debug(PriceBookEntryList.size()+'PriceBookEntryList -->'+PriceBookEntryList);
		if(IsInsert){
			insert PriceBookEntryList;
		}
		PriceBookEntryDataList = PriceBookEntryList;
		return PriceBookEntryList;
	}
	/***************************************************************************
Purpose   : Creats Asset
Parameters: isInsert - Insert the records
recordCount - No of Records to be created 
recordTypeName - Covered Product or Network Element Asset
For Covered Product Asset -   Pass AccountId and ProductId else Creats Default Account and Product
For Newtork Element Asset - Pass AccountId and AddressId - Here Country name and Account Should match with Address Location
***************************************************************************************************************/
	public  static list<Asset> createAssetData(Boolean isInsert, Integer recordCount, string recordTypeName, map<string,String> fieldNAme){
		list<Asset> oAssetDataList = new list<Asset>();
		String assetRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();
		String accountId = null;
		String productId =null;
		string addressId =null;
		map<string,String> fieldMap = new map<string,String> ();
		if(fieldNAme ==null){
			accountId =createAccountData( true,  1,  'Legal_Entity',  null, true)[0].Id;
			productId = createProductDataSetUp( true, 1,  null)[0].Id; 
			fieldMap.put('AccountId',accountId );
			if(recordTypeName == 'CH_NetworkElementAsset') {
				addressId =createAddressData(true,1,fieldMap)[0].Id;
			}
		}
		else {
			accountId = fieldNAme.get('AccountId');
			productId = fieldNAme.get('product2Id');
			addressId = fieldNAme.get('Address__c');
			fieldMap = new map<string,String> ();
			if(addressId ==null && recordTypeName == 'CH_NetworkElementAsset'){
				fieldMap.put('AccountId',accountId );
				addressId =createAddressData(true,1,fieldMap)[0].Id;
			}
		}
	   
		for(Integer i=0; i<recordCount ;i++)
		{
			Asset oASsetData = new Asset();
			oASsetData.Name = 'TestAsset'+i;
			oASsetData.CH_CDB_ExternalAssetId__c = '12334';
			oASsetData.CH_NetworkElementID__c = '43321';
			oASsetData.recordTypeId = assetRecordTypeId;
			oASsetData.AccountId = accountId;
			oASsetData.product2Id = productId;
			oASsetData.Status='Active';
			//if(recordTypeName == 'Network Element Asset'){
			if(recordTypeName == 'CH_NetworkElementAsset'){
				oASsetData.RecordTypeId= AssetRecordTypeId;
				oASsetData.CH_NetworkElementID__c='Test99'+i;
				oASsetData.Name='Test99'+i;
				oASsetData.CH_CountryISOName__c='USA';
				oASsetData.Address__c=addressId;
			}
			oAssetDataList.add(oASsetData);
		}
		if(isInsert){
			insert oAssetDataList;
		}
		return oAssetDataList;
	}	
	/***************************************************************************
Purpose   : Creats Case
Parameters: Serverity outage - Will decides Recordtype hence no need to pass RT explicilty
contactID - Id of Contact
entitlement - Best to pass Entitlement has it has all Lookup required while creation Case
Like AccountId, assetId, Product2Id(from Asset),EntitlementId and ContatcID
Note : ContactId must be Entitlitled to Entitlement's Account via AccountContractRelation
***************************************************************************************************************/
	public static Case createCaseNotSaved(string severity, string outage, boolean isPortalCase, String contactID, Entitlement oEntitlement){
		DateTime now = DateTime.Now();
		// Create a case
		Case newCase = new Case();
		newCase.AccountId = oEntitlement.AccountId;
		newCase.AssetId = oEntitlement.assetId;
		newCase.ProductId = oEntitlement.asset.Product2Id;
		newCase.EntitlementId = oEntitlement.Id;
		newCase.ContactId = contactId;
		newCase.CH_IssueOccurenceDate__c = now;
		newCase.CH_ReportedDate__c = now;
		newCase.CH_MilestoneSLA_Start__c = now;
		newCase.Mobile_Phone__c = '123-456789';
		newCase.Country__c = 'Sweden';
		newCase.reason = 'New problem';
		newCase.Subject = 'subject';
		newCase.CH_Summary__c = 'subject';
		newCase.Type = 'Incident';
		newCase.Description = 'TEST';
		newCase.Severity__c =severity;
		newCase.CH_Outage__c = outage;
		newCase.Status = 'Created';
		newCase.CH_SecurityGroup__c = '';
		newCase.CH_GWC_SecurityGroup__c = 'SEC_GWC|ALL';
		newCase.CH_ServiceType__c ='Customer Support';
		return newCase;	
	}
	
	public  static Case createProblemCase(Boolean isInsert,  case IncidentCase){
		Case problemCase = new Case();
		problemCase.RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CH_Problem').getRecordTypeId();  
		problemCase .CH_ReportedDate__c = DateTime.Now();		
		problemCase.Country__c = IncidentCase.Country__c;
		problemCase.reason = 'New problem';
		problemCase.Subject = 'Survey Closed Case';
		problemCase.CH_Summary__c = 'TestSub';
		problemCase.Description = 'TEST';
		problemCase.Severity__c = incidentcase.Severity__c;
		problemCase.CH_Outage__c = incidentcase.CH_Outage__c;
		problemCase.Status = 'Created';
		problemCase.CH_IssueOccurenceDate__c = system.today();
		problemCase.ProductId = incidentcase.ProductId; 
		problemCase.CH_RouteCase__c = false;
		problemCase.CH_Initial_Assignment__c = false;
		problemCase.ownerId = userinfo.getUserId(); 
		problemCase.CH_Originating_Incident_Number__c=IncidentCase.id;
		if(isInsert){
			insert problemCase ;
		}
		return problemCase;
	}
	
	
	public  static list<case> createS2SCase(Boolean isInsert, Integer recordCount, map<string,String> fieldName){
		list<Case> caseS2SList = new List<Case>();
		String ContactId = null;
		if(fieldName==null){
			Contact oContact= createContact(true,1,null,null,false)[0];
			ContactId =oContact.Id;	  
		}else{
			ContactId= fieldName.get('ContactId');	  
		}
		Asset tempAsset=createAssetData( true, 1,'CH_CoveredProduct',  null)[0];
		for(Integer i=0; i<recordCount; i++){
			Case caseS2s = new Case();
			caseS2s.RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CH_NokiaStandardCase').getRecordTypeId();		  
			
			caseS2s.CH_CaseOriginSystem__c = 'orange-irma';
			caseS2s.CH_ExternalSystemAccount__c = '12345';
			caseS2s.Origin = 'S2S';
			caseS2s.CH_Outage__c = 'No';
			caseS2s.CH_Email2__c = 'test'+i+'@email.com';
			caseS2s.SEC_Last_Name__c = 'testlastname'+i;
			caseS2s.CH_Stage__c = 'Register';
			caseS2s.Type = 'Incident';
			caseS2s.Subject = 'test'+i;
			caseS2s.Severity__c = 'Minor';
			caseS2s.CH_ServiceType__c = 'Customer Support';
			caseS2s.Status = 'Created';
			caseS2s.Description = 'test'+i;
			caseS2s.CH_NetworkElementID__c = 'Net Element:DE-98134737';
			caseS2s.AssetId= tempAsset.Id;		 
			caseS2s.Country__c = 'Germany';
			caseS2s.Reference_Number__c = 'test ref'+i;
			caseS2s.CH_CustomerDescription__c = '<p>test customer description</p>';
			caseS2SList.add(caseS2s);  
		}   
		if(isInsert){
			insert caseS2SList ;
		}
		return caseS2SList;
	}
	
	public static Schema.Location createLocationData(boolean isInsert, Integer Count, Map<String,String> fieldNAme){
		Schema.Location loc = new Schema.Location();
		String AccountId = null;
		if(fieldNAme !=null && fieldNAme.containsKey('AccountId')){
			AccountId = fieldNAme.get('AccountId');
		}
		loc.Name='My location';
		loc.LocationType='Site';
		loc.CH_AccountName__c = AccountId;
		if(isInsert){
			insert loc;
		}
		return loc;
	}
	
	public static  List<Schema.Address> createAddressData(boolean isInsert, Integer Count, Map<String,String> fieldNAme){
		String locationId = null;
		List<Schema.Address> addressList = new  List<Schema.Address>();
		if(fieldNAme !=null && fieldNAme.containsKey('AccountId')){
			Map<String,String> fieldMap = new Map<String,String>();
			fieldMap.put('AccountId',fieldNAme.get('AccountId'));
			locationId = createLocationData(isInsert,1,fieldMap).Id;			
		}elsE{
			locationId = createLocationData(isInsert,1,null).Id;
		}
		Id addRecordTypeId=Schema.SObjectType.Address.getRecordTypeInfosByDeveloperName().get('CH_Address').getRecordTypeId();
		for(integer i=0; i<Count; i++){
			Schema.Address addr = new Schema.Address();
			addr.LocationType='Site';
			addr.RecordTypeId = addRecordTypeId;
			addr.ParentId= locationId;
			addressList.add(addr);
		}
		if(isInsert){
			insert addressList;
		}
		return addressList;
	}
	
	public static CH_CustomerSpecificTargetSLA__c createSLAObject(Entitlement oEntitlement, Boolean isInsert){
		CH_CustomerSpecificTargetSLA__c slaObj = new CH_CustomerSpecificTargetSLA__c();
		slaObj.CH_Account__c = oEntitlement.AccountId;
		slaObj.CH_Entitlement__c = oEntitlement.Id;
		slaObj.CH_ServiceContract__c = oEntitlement.serviceContractId;
		slaObj.CH_LineItemNumber__c = oEntitlement.ContractLineItemId;
		slaObj.CH_ServiceMappingId__c = 'Legacy Customer Support Service - No Severity 24x7';
		slaObj.CH_SLARecordStatus__c = 'Active';
		slaObj.CH_IR_WorkMins__c = 10 ;
		slaObj.CH_SR_WorkMins__c = 20 ;
		slaObj.CH_TSP_WorkMins__c = 30 ;
		slaObj.CH_SDR_WorkMins__c = 40 ;
		slaObj.CH_SP_WorkMins__c = 50;
		slaObj.CH_SPD_WorkMins__c = 60 ;
		slaObj.CH_Severity__c = 'Critical';
		slaObj.CH_Outage__c = 'Yes';
		if(isInsert){
			insert slaObj;
		}
		return slaObj;
	}
	
	public static entitlementContact createEntitlementContact(String ContactId, String EntitlementId, boolean isInsert){
		EntitlementContact entitlementContact = new EntitlementContact();
		entitlementContact.ContactId = ContactId;
		entitlementContact.EntitlementId = EntitlementId;
		iF(isInsert){
			insert entitlementContact;
		}
		return entitlementContact;
	}
	public static CH_AuthorizedAccount__c createAuthorizedAccount(String accountId, String ServiceContractId,boolean isInsert){
		CH_AuthorizedAccount__c authorizedAccount = new CH_AuthorizedAccount__c();
		authorizedAccount.CH_Account__c = accountId;
		authorizedAccount.CH_ServiceContract__c = ServiceContractId;
		iF(isInsert){
			insert authorizedAccount;
		}
		return authorizedAccount;
	}
	
	public static List<Pricebook2> getPricebookDataSetup(set<string> priceBookName,  Boolean isInsert ){
		List<Pricebook2> PricebookDataSetup = new List<Pricebook2>();
		Pricebook2 stdpriceBook = new Pricebook2();
		stdpriceBook.Id = Test.getStandardPricebookId();
		stdpriceBook.IsActive = true;
		PricebookDataSetup.add(stdpriceBook);
		for(String prBookName : priceBookName ){
			Pricebook2 objpriceBook = new Pricebook2();
			objpriceBook.Name = prBookName;
			objpriceBook.IsActive =true;
	 
		}
		if(isInsert){
			upsert PricebookDataSetup;
			system.assert(PricebookDataSetup.size() >0 );
		}
		return PricebookDataSetup;
	}
	public static Set<String> PRICEBOOKNAME = new Set<String>{ 'Nokia CARE Price Book','CDB Price Book','CARES Price Book' };
		public static List<PriceBookEntry>  createPriceBookEnttry( Boolean isInsert, Integer recordCount, map<string,String> fieldNAme){
			List<Pricebook2> priceBookList = getPricebookDataSetup(PRICEBOOKNAME,  true );
			List<PriceBookEntry> PriceBookEntryList = new List<PriceBookEntry>();
			List<Product2> productList = new List<Product2>();
			system.debug('PriceBookEntryList'+PriceBookEntryList.size());
			if(fieldNAme ==null || fieldNAme.get('Productid') ==null){
				productList = createProductDataSetUp( true,  1, null);
			}
			for(Product2 objProduct : productList){
				for(Pricebook2 pbId : priceBookList){
					PriceBookEntry tempPriceBookEntry = new PriceBookEntry();
					tempPriceBookEntry.Product2Id = objProduct.id;
					tempPriceBookEntry.UnitPrice = 0;
					tempPriceBookEntry.IsActive = true;
					tempPriceBookEntry.Pricebook2Id = pbId.Id;
					system.debug('tempPriceBookEntry1 -->'+tempPriceBookEntry);
					PriceBookEntryList.add(tempPriceBookEntry); 
				}
			}
			system.debug(PriceBookEntryList.size()+'PriceBookEntryList -->'+PriceBookEntryList);
			insert PriceBookEntryList;
			PriceBookEntryDataList = PriceBookEntryList;
			return PriceBookEntryList;
		}
	
	public static EntitlementContact createEntitlementContact(Boolean isInsert, String ContactID, String EntitlementId){
		EntitlementContact ect = new EntitlementContact();
		ect.ContactId = ContactID;
		ect.EntitlementId =EntitlementId;
		if(isInsert){
			 insert ect;
		}
		return ect;
	}
	
	  public static Entitlement createAuthorizedEntitlement(Boolean isInsert, String AccountId, String ServiceContractId){
		  Entitlement authEntitlement = new Entitlement();
		  authEntitlement.AccountId = AccountId;
		  authEntitlement.Name ='Authorized Entitlement';
		  authEntitlement.ServiceContractId = ServiceContractId;
		  authEntitlement.CH_EntitlementType__c = 'Authorized Contact';
		  authEntitlement.CH_CDB_EntitlementId__c ='1';
		  authEntitlement.StartDate = system.today();
		  authEntitlement.EndDate = system.today()+10; 
	authEntitlement.CH_ServiceMappingId__c ='Legacy Customer Support Service - All Severity 24x7';
		if(isInsert){
			 insert authEntitlement;
			 ServiceContract ObjServiceContract = new ServiceContract();
			ObjServiceContract.Id =ServiceContractId;
			ObjServiceContract.CH_Entitlement__c = authEntitlement.Id;
		}
		return authEntitlement;
	}
	
}