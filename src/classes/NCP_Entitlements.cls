/**	
	About   
	-----
	Description: Class to manage entitlements for the Nokia customer protal
	
	Created for: Nokia Customer Portal 
	Created date: 12 14 2017
	
	Details / Methods   
	-----------------	
	SearchDocumentTypes - Used to get the access types related to a specific user/product/service
	
	Update History	
	--------------	
	Created: 12 14 2017 – AES 
	Updated: 02 07 2017 – AES 
	Updated: 02 09 2018 – aboukrim@salesforce.com, getFavoriteProducts method added.
	Updated: 02 13 2018 - AES update the logic to include cares & CDB app 
	Updated: 03 07 2018 – aboukrim@salesforce.com, include other Services app.
	Updated: 04 01 2018 – AES update the logic to meet NOKIA-217/NOKIA-292 requirements.
	Updated: 11 01 2020 – Updated to return ProductCode for NDA BOT Demand.
	Issues / TODOs  
	--------------
**/

public with sharing class NCP_Entitlements {

	public static Final Id contactId = [Select contact.AccountId from user where id = :UserInfo.getUserId()].contactId;
	public static Final User connectedUser =  [Select contact.AccountId,NCP_IsHorizontal__c,contactId from user where id =: UserInfo.getUserId()];
	public static Final Boolean horizontalUser = connectedUser.NCP_IsHorizontal__c;

	public static List<String> getMyEntitlementLabel() {

		List<String> options = new List<String>();
		Schema.DescribeFieldResult fieldResult = NCP_Product_Access_Type__mdt.NCP_My_entitlement_label__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for (Schema.PicklistEntry f : ple) {
			options.add(f.getLabel());
		}
		return options;
	}

	@AuraEnabled
	public static Boolean isAuthenticated() {
		return NCP_Utils.isUserAuthenticated();
	}

	/*
	* @description   Entitlment V2 : CDB app : Identify which Documentations are unlocked in the Salesforce Community for the connected customer 
	* @param		 userId: the connected user
	* @param		 objectId: the object that needs access, it can be product or service
	* @param		 appName: specify if t's CDB or Cares
	* @return		list of access type		
	*/
	public static Map<Id, Set<String>> SearchEntitlementsCDB(Set<Id> objectSetId, Id contractId) {

		//system.debug('### AES *********SearchEntitlementsCDB*********');
		Set<String> accessTypeSet = new Set<String>();
		Set<Id> childscIdSet = new Set<Id>();
		Set<Id> cliIdSet = new Set<Id>();
		Map<Id, Set<String>> productTypeMap = new Map<Id, Set<String>>();
		Map<Id, ServiceContract> productServiceContractMap = new Map<Id, ServiceContract>();
		User connectedUser = [Select contact.AccountId,NCP_IsHorizontal__c,contactId from user where id = :UserInfo.getUserId()];
		Boolean HorizontalUser = connectedUser.NCP_IsHorizontal__c;
		//Set<String> prAccessSet = NCP_Entitlements.productAccess();		 
		//system.debug('### AES CDB objectSetId '+objectSetId);
		// get the existing access from contact entitlement objet 
		for (NCP_Authorised_Entitlement__c ce : NCP_Entitlements.getAuthorisedEntitlements(contractId, NCP_Constants.TYPE_CDB)) {
			if (String.isNotBlank(ce.NCP_Service_Contract__c) && ce.NCP_Service_Contract__r.NCP_External_Status__c == NCP_Constants.STATUS_ACTIVE) {
	accessTypeSet.add(ce.NCP_Service_Contract__r.NCP_Entitlement_Access_Type__c);
	childscIdSet.add(ce.NCP_Service_Contract__c);
			}
			if (String.isNotBlank(ce.NCP_Contract_Line_Item__c)) {
	cliIdSet.add(ce.NCP_Contract_Line_Item__c);
			}
		}
		//system.debug('### AES CDB service accessTypeSet '+accessTypeSet);		
		//system.debug('### AES CDB access from contact entitlement '+accessTypeSet);
		// get access granted at the Account level for service & products
		// Access for services 
		for (ServiceContract sc : NCP_Entitlements.getChildServiceContracts(NCP_Constants.TYPE_CDB, contractId)) {
			if (objectSetId != null && (sc.NCP_Entitlement_Relationship__c == NCP_Constants.RELATIONSHIP_P || sc.NCP_Entitlement_Relationship__c == NCP_Constants.RELATIONSHIP_PS) && sc.NCP_Default__c == true) {
	childscIdSet.add(sc.Id);
			}
			if (objectSetId == null && (sc.NCP_Entitlement_Relationship__c == NCP_Constants.RELATIONSHIP_S || sc.NCP_Entitlement_Relationship__c == NCP_Constants.RELATIONSHIP_PS) && sc.NCP_Default__c == true && (sc.NCP_Entitlement_Access_Type__c == NCP_Constants.PIC_VALUE || horizontalUser == false)) {
	accessTypeSet.add(sc.NCP_Entitlement_Access_Type__c);
			}
		}
		//system.debug('### AES CDB accessTypeSet '+accessTypeSet);
		// Access for each product
		if (objectSetId != null) {
			for (contractLineItem li : [Select Id,Product2Id,ServiceContract.NCP_Entitlement_Access_Type__c from contractLineItem where (ServiceContractId IN:childscIdSet OR Id IN:cliIdSet) And Product2Id IN:objectSetId And NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE]) {
	String access = li.ServiceContract.NCP_Entitlement_Access_Type__c;
	if (!productTypeMap.containsKey(li.Product2Id)) {
		productTypeMap.put(li.Product2Id, new Set<String>());
		productTypeMap.get(li.Product2Id).add(access);
	} else {
		productTypeMap.get(li.Product2Id).add(access);
	}
			}
		} else {
			productTypeMap.put(null, accessTypeSet);
		}
		//system.debug('### AES CDB productTypeMap '+productTypeMap);
		return productTypeMap;
	}

	/*
	* @description   Entitlment V2 : Cares app : Identify which Documentations are unlocked in the Salesforce Community for the connected customer
	* @param		 userId: the connected user
	* @param		 objectId: the object that needs access, it can be product or service
	* @param		 appName: specify if t's CDB or Cares
	* @return		list of access type		
	*/
	public static Map<Id, Set<String>> SearchEntitlementsCares(Set<Id> objectSetId, Id contractId) {

		//system.debug('### AES *********SearchEntitlements2Cares*********');
		Set<String> accessTypeSet = new Set<String>();
		Set<Id> cServiceContractIdSet = new Set<Id>();
		Set<Id> childscIdSet = new Set<Id>();
		Set<Id> serviceIdSet = new Set<Id>();
		Set<Id> prServicesIds = new Set<Id>();
		Set<Id> cliIds = new Set<Id>();
		Map<Id, Set<String>> productTypeMap = new Map<Id, Set<String>>();
		Map<Id, List<contractLineItem>> mapContractLineItem = new Map<Id, List<contractLineItem>>();
		Map<Id, Id> mapCESCC = new Map<Id, Id>();
		List<NCP_Authorised_Entitlement__c> contactEntitlementList = NCP_Entitlements.getAuthorisedEntitlements(contractId, NCP_Constants.TYPE_CARES);
		//get CIL access if SC is empty
		for (NCP_Authorised_Entitlement__c ce : contactEntitlementList) {
			if (String.isNotBlank(ce.NCP_Contract_Line_Item__c)) {
	cliIds.add(ce.NCP_Contract_Line_Item__c);
	if (String.isNotBlank(ce.NCP_Service_Contract__c)) {
		serviceIdSet.add(ce.NCP_Service_Contract__c);
	}
			}
			if (String.isNotBlank(ce.NCP_Service_Contract__c)) {
	serviceIdSet.add(ce.NCP_Service_Contract__c);
	if (String.isBlank(ce.NCP_Contract_Line_Item__c)) {
		prServicesIds.add(ce.NCP_Service_Contract__c);
	}
			}
		}
		// get access from SC child 
		for (ServiceContract ce : [Select Id,NCP_Entitlement_Relationship__c,NCP_Entitlement_Access_Type__c From ServiceContract Where (ParentServiceContract.NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE and ParentServiceContractId IN:serviceIdSet) or (NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE and Id IN:serviceIdSet)]) {
			if (ce.NCP_Entitlement_Relationship__c == NCP_Constants.RELATIONSHIP_S || ce.NCP_Entitlement_Relationship__c == NCP_Constants.RELATIONSHIP_PS) {
	accessTypeSet.add(ce.NCP_Entitlement_Access_Type__c);
			}
		}
		// Access for each product
		if (objectSetId != null) {
			for (contractLineItem cli : [Select Id,Product2Id,ServiceContractId,ServiceContract.NCP_Entitlement_Access_Type__c from contractLineItem where (ServiceContractId IN:prServicesIds or ServiceContract.ParentServiceContractId IN:prServicesIds or ID IN:cliIds) and Product2Id IN:objectSetId and NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE]) {
	if (!productTypeMap.containsKey(cli.Product2Id)) {
		productTypeMap.put(cli.Product2Id, new Set<String>());
		productTypeMap.get(cli.Product2Id).add(cli.ServiceContract.NCP_Entitlement_Access_Type__c);
	} else {
		productTypeMap.get(cli.Product2Id).add(cli.ServiceContract.NCP_Entitlement_Access_Type__c);
	}
			}
		}

		if (objectSetId != null) {
			for (Id pr : objectSetId) {
	if (!productTypeMap.containsKey(pr)) {
		productTypeMap.put(pr, new Set<String>());
	}
			}
		} else {
			productTypeMap.put(null, accessTypeSet);
		}
		//system.debug('### AES Cares accessTypeSet '+accessTypeSet);
		//system.debug('### AES Cares productTypeMap '+productTypeMap);
		return productTypeMap;
	}

	/*
	* @description	Allow a user to be registered with no Care Contracted
	* @param		 objectId: the object that needs access, it can be product or service
	* @param		 contractId : the contract Id
	* @return		list of access type 
	*/
	public static Map<Id, Set<String>> SearchEntitlementsOtherServices(Id contractId) {

		//system.debug('### ABO *********SearchEntitlements2OtherServices*********');
		Set<String> accessTypeSet = new Set<String>();
		Map<Id, Set<String>> productTypeMap = new Map<Id, Set<String>>();

		for (NCP_Authorised_Entitlement__c ce : NCP_Entitlements.getAuthorisedEntitlements(contractId, NCP_Constants.TYPE_OTHER)) {
			// if it's service access
			if ((ce.NCP_Service_Contract__r.NCP_Entitlement_Relationship__c == NCP_Constants.RELATIONSHIP_S || ce.NCP_Service_Contract__r.NCP_Entitlement_Relationship__c == NCP_Constants.RELATIONSHIP_PS) && ce.NCP_Service_Contract__r.NCP_External_Status__c == NCP_Constants.STATUS_ACTIVE) {
	accessTypeSet.add(ce.NCP_Service_Contract__r.NCP_Entitlement_Access_Type__c);
			}
		}
		productTypeMap.put(null, accessTypeSet);
		//system.debug('### ABO SearchEntitlementsOtherServices productTypeMap '+productTypeMap);
		return productTypeMap;
	}

	public static Map<Id, Set<String>> SearchAllEntitlementsOtherServices() {

		Set<String> accessTypeSet = new Set<String>();
		Map<Id, Set<String>> productTypeMap = new Map<Id, Set<String>>();
		for (ServiceContract sc : NCP_Entitlements.getChildServiceContracts(NCP_Constants.TYPE_OTHER, null)) {
			//System.debug('### ABO All other Services '+sc.NCP_Entitlement_Access_Type__c);
			if (String.isNotBlank(sc.NCP_Entitlement_Access_Type__c) && (sc.NCP_Entitlement_Relationship__c == NCP_Constants.RELATIONSHIP_S || sc.NCP_Entitlement_Relationship__c == NCP_Constants.RELATIONSHIP_PS)) {
	accessTypeSet.add(sc.NCP_Entitlement_Access_Type__c);
			}
		}
		productTypeMap.put(null, accessTypeSet);
		//System.debug('### AES SearchAllEntitlementsOtherServices productTypeMap '+productTypeMap);
		return productTypeMap;
	}

	/*
	* @description   get the list of child service contract 
	* @param		 userId: the connected user
	* @param		 appName: Cares or CDB
	* @return		list of ServiceContract  
	*/
	public static List<ServiceContract> getChildServiceContracts(String appName, Id contractId) {

		List<ServiceContract> sContactList;
		Set<Id> parentServiceContractIdSet = new Set<Id>();
		Set<Id> accountIdSet = NCP_Entitlements.getAccountIds();

		// get all parent service contract related to the user
		if (String.isBlank(contractId)) {
			if (!String.isBlank(appName)) {
	sContactList = [Select Id,StartDate,EndDate,Status,NCP_External_Status__c From ServiceContract where AccountId IN:accountIdSet and RecordType.DeveloperName = :NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_PARENT and NCP_Contract_Type__c = :appName and NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE];
			} else {
	sContactList = [Select Id,StartDate,EndDate,Status,NCP_External_Status__c From ServiceContract where AccountId IN:accountIdSet and RecordType.DeveloperName = :NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_PARENT and NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE];
			}
			//System.debug('### AES sContactList '+sContactList); 
			for (ServiceContract sContract : sContactList) {
	//system.debug('### ABO getChildServiceContracts sContract : '+sContract);
	parentServiceContractIdSet.add(sContract.Id);
			}
		} else {
			parentServiceContractIdSet.add(contractId);
		}
		//System.debug('### AES parentServiceContractIdSet '+parentServiceContractIdSet); 
		//select child elements 
		return [Select Id,NCP_Default__c,ParentServiceContractId,ParentServiceContract.NCP_Contract_Type__c,NCP_Entitlement_Relationship__c,NCP_Entitlement_Access_Type__c From ServiceContract Where ParentServiceContractId IN:parentServiceContractIdSet and NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE];
	}
	/*
	* @description get entitled products for a connected user. 
	* @param userId: the connected user, appName: the application name	
	* @return: wrapper for list products
	*/

	public static Set<Id> getMyEntitledProduct(Id contractId) {

		Set<Id> productIdSet = new Set<Id>();
		Set<Id> childscIdSet = new Set<Id>();
		Set<Id> caresServiceContractIdSet = new Set<Id>();
	
		//added by vladimir - START
		//CDB Child SC
		for (NCP_Authorised_Entitlement__c ce : NCP_Entitlements.getAuthorisedEntitlements(contractId, NCP_Constants.TYPE_CDB)) {
			if (String.isNotBlank(ce.NCP_Service_Contract__c) && ce.NCP_Service_Contract__r.NCP_External_Status__c == NCP_Constants.STATUS_ACTIVE) {
	childscIdSet.add(ce.NCP_Service_Contract__c);
			}
		}
		for(ServiceContract sc:NCP_Entitlements.getChildServiceContracts('',contractId)){
			//childscIdSet.add(sc.Id);
			if (sc.ParentServiceContract.NCP_Contract_Type__c == NCP_Constants.TYPE_CDB &&(sc.NCP_Entitlement_Relationship__c == NCP_Constants.RELATIONSHIP_S || sc.NCP_Entitlement_Relationship__c == NCP_Constants.RELATIONSHIP_PS) && sc.NCP_Default__c == true && (sc.NCP_Entitlement_Access_Type__c == NCP_Constants.PIC_VALUE || horizontalUser == false)) {
	childscIdSet.add(sc.Id);
			}
		}
		//CARES Child SC	
		List<NCP_Authorised_Entitlement__c> contactEntitlementList = NCP_Entitlements.getAuthorisedEntitlements(contractId, NCP_Constants.TYPE_CARES);
		System.debug('contactEntitlementList.size(): '+contactEntitlementList.size());
		for (NCP_Authorised_Entitlement__c ce : contactEntitlementList) {
			if (String.isNotBlank(ce.NCP_Service_Contract__c) && ce.NCP_Service_Contract__r.NCP_External_Status__c == NCP_Constants.STATUS_ACTIVE) {
	caresServiceContractIdSet.add(ce.NCP_Service_Contract__c);
			}
		}
		System.debug('caresServiceContractIdSet.size(): '+caresServiceContractIdSet.size());
		// get SC child 
		for (ServiceContract ce : [Select Id,NCP_Entitlement_Relationship__c,NCP_Entitlement_Access_Type__c, name From ServiceContract Where (ParentServiceContract.NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE and ParentServiceContractId IN:caresServiceContractIdSet) or (NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE and Id IN:caresServiceContractIdSet)]) {
			System.debug('ce.name: '+ce.name);
			System.debug('ce.NCP_Entitlement_Relationship__c: '+ce.NCP_Entitlement_Relationship__c);
			if (ce.NCP_Entitlement_Relationship__c == NCP_Constants.RELATIONSHIP_S || ce.NCP_Entitlement_Relationship__c == NCP_Constants.RELATIONSHIP_PS) {
	childscIdSet.add(ce.Id);
			}
		}
		System.debug('childscIdSet.size(): '+childscIdSet.size());
		
		//added by vladimir - END
		for(contractLineItem li:[Select Id,Product2Id from contractLineItem where ServiceContractId IN:childscIdSet and NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE]){
			productIdSet.add(li.Product2Id);
		}
		return productIdSet;  
	}

	public static Set<Id> getAccountIds() {
		Set<Id> accountIdSet = new Set<Id>();
		//Id contactId = [Select contact.AccountId from user where id =: UserInfo.getUserId()].contactId;
		//get all AccountContactRelation related to this user 
		for (AccountContactRelation accountContactRs : [Select Id,AccountId,ContactId from AccountContactRelation where NCP_Entitlement_Relationship__c = true and ContactId = :contactId]) {
			// get the Account Id related to this user 
			accountIdSet.add(accountContactRs.AccountId);
		}
		//system.debug('### AES AccountContactRelations '+[Select Id,AccountId,ContactId from AccountContactRelation where NCP_Entitlement_Relationship__c = true and ContactId =:contactId]);
		//system.debug('### AES accountIdSet'+accountIdSet);
		return accountIdSet;
	}

	public static list<NCP_MyEntitledProducts_Wrapper> searchMyEntitledProduct() {

		//String contactId = [Select ContactId from User WHERE Id=:UserInfo.getUserId()].ContactId;
		Set<Id> productIdSet = getMyEntitledProduct(null);
		Set<Id> favoriteProductIdSet = new Set<Id>();
		List<NCP_MyEntitledProducts_Wrapper> products = new List<NCP_MyEntitledProducts_Wrapper>();
		for (NCP_Favorite_Product__c favoriteProduct : [SELECT NCP_Product_Id__c from NCP_Favorite_Product__c where NCP_User__c = :UserInfo.getUserId() and NCP_Product_Id__c IN:productIdSet and NCP_Removed_Record__c != True]) {
			favoriteProductIdSet.add(favoriteProduct.NCP_Product_Id__c);
		}
		for (Product2 pr : [Select Id,Name from Product2 Where Id IN:productIdSet]) {
			NCP_MyEntitledProducts_Wrapper entitledPr = new NCP_MyEntitledProducts_Wrapper();
			entitledPr.product = pr;
			if (favoriteProductIdSet.contains(pr.Id)) {
	entitledPr.checked = true;
			} else {
	entitledPr.checked = false;
			}
			products.add(entitledPr);
		}
		return products;
	}

	public static NCP_ListViewPagedResult_Wrapper searchMyEntitledProducts(Decimal pageSize, Decimal pageNumber) {

		//String contactId = [Select ContactId from User WHERE Id=:UserInfo.getUserId()].ContactId;
		//System.debug('### ABO searchMyEntitledProducts : contact ID'+contactId);
		Set<Id> productIdSet = getMyEntitledProduct(null);
		Set<Id> favoriteProductIdSet = new Set<Id>();
		Integer pSize = (Integer) pageSize;
		Integer offset = ((Integer) pageNumber - 1) * pSize;
		NCP_ListViewPagedResult_Wrapper result = new NCP_ListViewPagedResult_Wrapper();
		List<NCP_MyEntitledProducts_Wrapper> resultProducts = new List<NCP_MyEntitledProducts_Wrapper>();

		for (NCP_Favorite_Product__c favoriteProduct : [SELECT NCP_Product_Id__c from NCP_Favorite_Product__c where NCP_User__c = :UserInfo.getUserId() and NCP_Product_Id__c IN:productIdSet and NCP_Removed_Record__c != True]) {
			favoriteProductIdSet.add(favoriteProduct.NCP_Product_Id__c);
		}

		System.debug('favoriteProductIdSet ::: ' + favoriteProductIdSet);

		for (Product2 pr : [Select Id,Name from Product2 Where Id IN:productIdSet ORDER BY Name LIMIT :pSize OFFSET :offset]) {
			NCP_MyEntitledProducts_Wrapper entitledPr = new NCP_MyEntitledProducts_Wrapper();
			entitledPr.product = pr;
			if (favoriteProductIdSet.contains(pr.Id)) {
	entitledPr.checked = true;
			} else {
	entitledPr.checked = false;
			}
			resultProducts.add(entitledPr);
		}

		System.debug('resultProducts ::: ' + resultProducts);

		result.pageSize = pSize;
		result.page = (Integer) pageNumber;
		result.total = productIdSet.size();
		result.products = resultProducts;
		//System.debug(result);
		return result;
	}


	public static NCP_ListViewPagedResult_Wrapper searchAllServiceProducts(Decimal pageSize, Decimal pageNumber) {

		Integer pSize = (Integer) pageSize;
		Integer offset = ((Integer) pageNumber - 1) * pSize;
		NCP_ListViewPagedResult_Wrapper result = new NCP_ListViewPagedResult_Wrapper();
		List<NCP_MyEntitledProducts_Wrapper> resultProducts = new List<NCP_MyEntitledProducts_Wrapper>();
		Set<Id> favoriteProductIdSet = new Set<Id>();
		result.pageSize = pSize;
		result.page = (Integer) pageNumber;
		result.total = [SELECT count() FROM product2 Where NCP_CAREACTIVATE__c != null And NokiaCPQ_State__c Not IN ('Obsolete', 'Rejected') AND PMD_Product_Item_Type__c IN ('Design item', 'Service Design Item', 'Complementary Item', 'Solution', 'NSN Solution', 'NSN Service Design Item')];

		for (NCP_Favorite_Product__c favoriteProduct : [SELECT NCP_Product_Id__c From NCP_Favorite_Product__c Where ID IN:getActiveFavoriteProductsIds()]) {
			favoriteProductIdSet.add(favoriteProduct.NCP_Product_Id__c);
		}

		for (Product2 pr : [SELECT Id,Name FROM product2 where NCP_CAREACTIVATE__c != null And NokiaCPQ_State__c Not IN ('Obsolete', 'Rejected') AND PMD_Product_Item_Type__c IN ('Design item', 'Service Design Item', 'Complementary Item', 'Solution', 'NSN Solution', 'NSN Service Design Item') ORDER BY Name LIMIT :pSize OFFSET :offset]) {
			NCP_MyEntitledProducts_Wrapper entitledPr = new NCP_MyEntitledProducts_Wrapper();
			entitledPr.product = pr;
			if (NCP_Utils.isInternalUser() && favoriteProductIdSet.contains(pr.Id)) {
	entitledPr.checked = true;
			}
			resultProducts.add(entitledPr);
		}
		result.products = resultProducts;
		//System.debug(result);
		return result;
	}

	/*
	* @description	
	* @return	  
	*/

	public static NCP_ListViewPagedResult_Wrapper getFavoriteProducts(Decimal pageSize, Decimal pageNumber) {

		NCP_ListViewPagedResult_Wrapper result = new NCP_ListViewPagedResult_Wrapper();
		List<NCP_MyEntitledProducts_Wrapper> resultProducts = new List<NCP_MyEntitledProducts_Wrapper>();
		Integer pSize = (Integer) pageSize;
		Integer offset = ((Integer) pageNumber - 1) * pSize;
		//String contactId = [Select ContactId from User WHERE Id=:UserInfo.getUserId()].ContactId;	
		for (NCP_Favorite_Product__c pr : [SELECT NCP_Product_Id__c,NCP_Product_Id__r.Name from NCP_Favorite_Product__c WHERE Id IN:getActiveFavoriteProductsIds() ORDER BY Name LIMIT :pSize OFFSET :offset]) {
			Product2 product = new Product2();
			NCP_MyEntitledProducts_Wrapper entitledPr = new NCP_MyEntitledProducts_Wrapper();
			product.Id = pr.NCP_Product_Id__c;
			product.Name = pr.NCP_Product_Id__r.Name;
			entitledPr.product = product;
			resultProducts.add(entitledPr);
		}
		result.pageSize = pSize;
		result.page = (Integer) pageNumber;
		result.total = [SELECT count() from NCP_Favorite_Product__c WHERE Id IN:getActiveFavoriteProductsIds()];
		result.products = resultProducts;
		System.debug(result);
		return result;
	}

	/*
	* @description list of the additional access for the connected user from the contact and the account 
	* @param user id 
	* @return list or contact entitlement   
	*/
	public static List<NCP_Authorised_Entitlement__c> getAuthorisedEntitlements(Id contractId, String appName) {

		// get the autorised entitlemnt related to this user from the account and the contact related
		// accounts are all the account where there is a contact account relationship with entitlmnt checkbox
		Set<Id> accountIdSet = new Set<Id>();
		List<NCP_Authorised_Entitlement__c> ceList = new List<NCP_Authorised_Entitlement__c>();
		//Id accountId = [Select contact.AccountId from user where id =: UserInfo.getUserId()].contact.AccountId;
		//Id contactId = [Select contact.AccountId from user where id =: UserInfo.getUserId()].contactId;
		//system.debug('### contactId '+contactId);
		//get all AccountContactRelation related to this user 
		if (string.isNotBlank(contactId)) {
			if (appName == NCP_Constants.TYPE_CARES) {
	for (AccountContactRelation accountContactRs : [Select Id,AccountId,ContactId from AccountContactRelation where NCP_Entitlement_Relationship__c = true and ContactId = :contactId]) {
		// get the Account Id related to this user 
		accountIdSet.add(accountContactRs.AccountId);
	}
			} else {
	Id accountId = [Select contact.AccountId from user where id = :UserInfo.getUserId()].contact.AccountId;
	accountIdSet.add(accountId);
			}
			//system.debug('### AES AccountContactRelation '+[Select Id,AccountId,ContactId from AccountContactRelation where NCP_Entitlement_Relationship__c = true and ContactId =:contactId]);			
			//system.debug('### AES contractId '+contractId);
			//system.debug('### AES accountIdSet '+accountIdSet);
			if (String.isNotBlank(contractId)) {
	ceList = [select NCP_Contract_Line_Item__c,NCP_Contract_Line_Item__r.NCP_External_Status__c,NCP_Service_Contract__r.NCP_External_Status__c,NCP_Service_Contract__r.RecordType.Name,NCP_Service_Contract__r.NCP_Entitlement_Relationship__c,NCP_Service_Contract__r.NCP_Entitlement_Access_Type__c,NCP_Service_Contract__r.ParentServiceContractId,NCP_Service_Contract__c,NCP_Service_Contract__r.ParentServiceContract.NCP_Entitlement_Access_Type__c from NCP_Authorised_Entitlement__c where (NCP_Contact__c = :contactId or NCP_Account__c IN:accountIdSet) and (NCP_Service_Contract__r.ParentServiceContractId = :contractId or NCP_Service_Contract__c = :contractId) and NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE];
			} else if (!String.isBlank(appName)) {
	ceList = [select NCP_Contract_Line_Item__c,NCP_Contract_Line_Item__r.NCP_External_Status__c,NCP_Service_Contract__r.NCP_External_Status__c,NCP_Service_Contract__r.RecordType.Name,NCP_Service_Contract__r.NCP_Entitlement_Relationship__c,NCP_Service_Contract__r.NCP_Entitlement_Access_Type__c,NCP_Service_Contract__r.ParentServiceContractId,NCP_Service_Contract__c,NCP_Service_Contract__r.ParentServiceContract.NCP_Entitlement_Access_Type__c from NCP_Authorised_Entitlement__c where (NCP_Contact__c = :contactId or NCP_Account__c IN:accountIdSet) and (NCP_Service_Contract__r.ParentServiceContract.NCP_Contract_Type__c = :appName or NCP_Service_Contract__r.NCP_Contract_Type__c = :appName or NCP_Contract_Line_Item__r.ServiceContract.ParentServiceContract.NCP_Contract_Type__c = :appName) and NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE];
			} else {
	ceList = [select NCP_Contract_Line_Item__c,NCP_Contract_Line_Item__r.NCP_External_Status__c,NCP_Service_Contract__r.NCP_External_Status__c,NCP_Service_Contract__r.RecordType.Name,NCP_Service_Contract__r.NCP_Entitlement_Relationship__c,NCP_Service_Contract__r.NCP_Entitlement_Access_Type__c,NCP_Service_Contract__r.ParentServiceContractId,NCP_Service_Contract__c,NCP_Service_Contract__r.ParentServiceContract.NCP_Entitlement_Access_Type__c from NCP_Authorised_Entitlement__c where (NCP_Contact__c = :contactId or NCP_Account__c IN:accountIdSet) and NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE];
			}
			//system.debug('### AES ceList '+ceList);
		}
		return ceList;
	}

	public static List<ServiceContract> getMyParentServiceContract() {
		Set<Id> accountIdSet = NCP_Entitlements.getAccountIds();
		//Id contactId = [Select contact.AccountId from user where id =: UserInfo.getUserId()].contactId;
		Set<Id> serviceIdSet = new Set<Id>();
		if (string.isNotBlank(contactId)) {
			for (NCP_Authorised_Entitlement__c ce : [select Id,NCP_Service_Contract__r.RecordType.DeveloperName,NCP_Service_Contract__c,NCP_Service_Contract__r.ParentServiceContractId from NCP_Authorised_Entitlement__c where (NCP_Contact__c = :contactId or NCP_Account__c IN:accountIdSet) and NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE]) {
	if (String.isNotBlank(ce.NCP_Service_Contract__c)) {
		if (ce.NCP_Service_Contract__r.RecordType.DeveloperName == NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_PARENT) {
			serviceIdSet.add(ce.NCP_Service_Contract__c);
		} else {
			serviceIdSet.add(ce.NCP_Service_Contract__r.ParentServiceContractId);
		}
	}
			}
		}
		//System.debug('### AES serviceIdSet '+serviceIdSet);
		//System.debug('### AES accountIdSet '+accountIdSet);
		// get CARES/OTHER parent Service contract 
		List<ServiceContract> authList = [Select Id,Name,status,NCP_External_Status__c,EndDate,StartDate,ContractNumber,Account.Name,NCP_Contract_Type__c From ServiceContract Where Id IN:serviceIdSet AND RecordType.DeveloperName = :NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_PARENT and NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE order by Name];
		// get CDB parent Service contract 
		List<ServiceContract> scList = [Select Id,Name,status,NCP_External_Status__c,EndDate,StartDate,ContractNumber,Account.Name,NCP_Contract_Type__c From ServiceContract Where AccountId IN:accountIdSet and RecordType.DeveloperName = :NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_PARENT and NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE and NCP_contract_type__c = :NCP_Constants.TYPE_CDB order by Name];
		if (!authList.isEmpty()) {
			scList.addAll(authList);
		}
		return scList;
	}
	/*
	* @description  get the list of product from the favorite product object 
	* @return	  
	*/
	public static List<Object> getFavoriteProducts() {

		List<Object> resultProducts = new List<Object>();

		for (NCP_Favorite_Product__c products : [SELECT NCP_Product_Id__c,NCP_Product_Id__r.Name from NCP_Favorite_Product__c WHERE Id IN:getActiveFavoriteProductsIds() limit 10000]) {
			Product2 product = new Product2();
			product.Id = products.NCP_Product_Id__c;
			product.Name = products.NCP_Product_Id__r.Name;
			resultProducts.add(product);
		}
		return resultProducts;
	}

	/*
	* @description  get my entitlment for all product services for a specific service contract used in the my entitlmenet controller 
	* @return	List Access 
	*/

	public static List<NCP_MyEntitlementProductAccess_Wrapper> getMyEntitlmentProducts(Id contractId) {

		//system.debug('### AES getMyEntitlmentProducts *********');
		Set<Id> productIdSet = NCP_Entitlements.getMyEntitledProduct(contractId);
		Map<Id, Set<String>> productTypeMap = new Map<Id, Set<String>>();
		//Map<Id,Set<String>> cARESproductTypeMap = new Map<Id,Set<String>>();
		List<NCP_MyEntitlementProductAccess_Wrapper> myEntitlementProdList = new List<NCP_MyEntitlementProductAccess_Wrapper>();
		List<ServiceContract> scList = [Select NCP_Contract_Type__c From ServiceContract Where Id = :contractId];

		if (!scList.isEmpty()) {
			if (scList[0].NCP_Contract_Type__c == NCP_Constants.TYPE_CDB) {
	productTypeMap = NCP_Entitlements.SearchEntitlementsCDB(productIdSet, contractId);
			} else if (scList[0].NCP_Contract_Type__c == NCP_Constants.TYPE_CARES) {
	productTypeMap = NCP_Entitlements.SearchEntitlementsCares(productIdSet, contractId);
			}
			Map<Id, Product2> productMap = new Map<Id, Product2>();
			Map<Id, Set<String>> mapProductEntitlmenetLabel = new Map<Id, Set<String>>();
			Map<String, String> entitlementMap = new Map<String, String>();
			List<String> myEntitlmentLabelList = NCP_Entitlements.getMyEntitlementLabel();

			for (NCP_Product_Access_Type__mdt pa : [Select Id,MasterLabel,NCP_My_entitlement_label__c,NCP_Link__c,NCP_Order__c,NCP_Type__c,NCP_docType__c from NCP_Product_Access_Type__mdt]) {
	entitlementMap.put(pa.NCP_Type__c, pa.NCP_My_entitlement_label__c);
			}
			for (Id prId : productTypeMap.keySet()) {
	mapProductEntitlmenetLabel.put(prId, new set<String>());
	for (String access : productTypeMap.get(prId)) {
		mapProductEntitlmenetLabel.get(prId).add(entitlementMap.get(access));
	}
			}
			//System.debug('### AES productTypeMap '+productTypeMap);
			//System.debug('### AES mapProductEntitlmenetLabel '+mapProductEntitlmenetLabel);
			for (Product2 pr : [Select Id,Name from Product2 where Id IN:productTypeMap.keySet()]) {
	productMap.put(pr.Id, pr);
			}
			for (Id prId : productTypeMap.keySet()) {
	boolean accessExists = false;
	List<NCP_MyEntitlementAccessGroup_Wrapper> accessGroupList = new List<NCP_MyEntitlementAccessGroup_Wrapper>();
	for (String s : myEntitlmentLabelList) {
		NCP_MyEntitlementAccessGroup_Wrapper accessGroup;
		if ((mapProductEntitlmenetLabel.get(prId)).contains(s)) {
			accessGroup = new NCP_MyEntitlementAccessGroup_Wrapper(s, true);
			accessExists = true;
		} else {
			accessGroup = new NCP_MyEntitlementAccessGroup_Wrapper(s, false);
		}
		accessGroupList.Add(accessGroup);
	}
	if (accessExists == true) {
		//System.debug('### AES accessGroupList '+accessGroupList);
		NCP_MyEntitlementProductAccess_Wrapper myEntitlementProd = new NCP_MyEntitlementProductAccess_Wrapper(productMap.get(prId), accessGroupList);
		//System.debug('### AES myEntitlementProd '+myEntitlementProd);
		myEntitlementProdList.add(myEntitlementProd);
	}
			}
			//System.debug('### AES myEntitlementProdList '+myEntitlementProdList);
		}
		return myEntitlementProdList;
	}
	/*
	* @description  get my entitlment for all product services for a all service contracts used in the my entitlment controller 
	*	  This function is created to avoid Too many queries when we try to return access for all SC in the my entitlment page
	* @return	Map access by Parent service contract	  
	*/
	public static Map<Id, List<NCP_MyEntitlementProductAccess_Wrapper>> getEntitledProductMap(Set<Id> accountIdSet, Id contactIds) {

		//System.debug('### AES Product Access **************');
		Map<Id, Set<Id>> mapSCProduct = new Map<Id, Set<Id>>();
		Map<String, Set<String>> productTypeMap = new Map<String, Set<String>>();
		Map<Id, List<NCP_MyEntitlementProductAccess_Wrapper>> mapSCProductEntitlment = new Map<Id, List<NCP_MyEntitlementProductAccess_Wrapper>>();
		Map<Id, Product2> productMap = new Map<Id, Product2>();
		Map<String, Set<String>> mapProductEntitlmenetLabel = new Map<String, Set<String>>();
		Map<String, String> entitlementMap = new Map<String, String>();
		List<String> myEntitlmentLabelList = NCP_Entitlements.getMyEntitlementLabel();
		Set<Id> childscIdSet = new Set<Id>();
		Set<Id> authscIdSet = new Set<Id>();
		Set<Id> cliIds = new Set<Id>();
		Set<Id> setSCIds = new Set<Id>();
		Set<Id> prIds = new Set<Id>();
		//Id contactId = [Select contact.AccountId from user where id =: UserInfo.getUserId()].contactId;
		if(contactIds==null)
		{
		  contactIds = [Select contact.AccountId from user where id =: UserInfo.getUserId()].contactId;  
		}

		// get child service contract 
		for (ServiceContract sc : [Select Id From ServiceContract where AccountId IN:accountIdSet and RecordType.DeveloperName = :NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_CHILD and NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE and ParentServiceContract.NCP_Contract_Type__c = :NCP_Constants.TYPE_CDB and NCP_Default__c = True and (NCP_Entitlement_Relationship__c = :NCP_Constants.RELATIONSHIP_P or NCP_Entitlement_Relationship__c = :NCP_Constants.RELATIONSHIP_PS)]) {
			childscIdSet.add(sc.Id);
		}
		// check if child then add access else get child entitlmnt 
		// we will get only Autho assigned to active SC or CLI 
		if (string.isNotBlank(contactIds)) {
			for (NCP_Authorised_Entitlement__c ce : [select Id,NCP_Contract_Line_Item__c,NCP_Service_Contract__c from NCP_Authorised_Entitlement__c where (NCP_Contact__c = :contactIds or NCP_Account__c IN:accountIdSet)]) {
	// check if child then add access else get child entitlmnt 
	if (String.isBlank(ce.NCP_Contract_Line_Item__c)) {
		if (String.isNotBlank(ce.NCP_Service_Contract__c)) {
			authscIdSet.add(ce.NCP_Service_Contract__c);
		}
	} else {
		cliIds.add(ce.NCP_Contract_Line_Item__c);
	}
			}
		}
		//System.debug('### AES authscIdSet '+authscIdSet);
		//System.debug('### AES cliIds '+cliIds);
		for (ServiceContract sc : [Select Id,NCP_Entitlement_Relationship__c,NCP_Entitlement_Access_Type__c From ServiceContract Where RecordType.DeveloperName = :NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_CHILD and (Id IN:authscIdSet OR ParentServiceContractId IN:authscIdSet) and NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE]) {
			childscIdSet.add(sc.Id);
		}
		//System.debug('### AES childscIdSet '+childscIdSet);
		for (contractLineItem cli : [Select Id,Product2Id,ServiceContractId,ServiceContract.NCP_Entitlement_Access_Type__c,serviceContract.ParentServiceContractId from contractLineItem where NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE and (ServiceContractId IN:childscIdSet or ID IN:cliIds)]) {
			setSCIds.add(cli.serviceContract.ParentServiceContractId);
			prIds.add(cli.Product2Id);
			if (!productTypeMap.containsKey(cli.Product2Id + '_' + cli.serviceContract.ParentServiceContractId)) {
	productTypeMap.put(cli.Product2Id + '_' + cli.serviceContract.ParentServiceContractId, new Set<String>());
	productTypeMap.get(cli.Product2Id + '_' + cli.serviceContract.ParentServiceContractId).add(cli.ServiceContract.NCP_Entitlement_Access_Type__c);
			} else {
	productTypeMap.get(cli.Product2Id + '_' + cli.serviceContract.ParentServiceContractId).add(cli.ServiceContract.NCP_Entitlement_Access_Type__c);
			}
			if (!mapSCProduct.containsKey(cli.serviceContract.ParentServiceContractId)) {
	mapSCProduct.put(cli.serviceContract.ParentServiceContractId, new Set<Id>());
	mapSCProduct.get(cli.serviceContract.ParentServiceContractId).add(cli.Product2Id);
			} else {
	mapSCProduct.get(cli.serviceContract.ParentServiceContractId).add(cli.Product2Id);
			}
		}

		for (NCP_Product_Access_Type__mdt pa : [Select Id,MasterLabel,NCP_My_entitlement_label__c,NCP_Link__c,NCP_Order__c,NCP_Type__c from NCP_Product_Access_Type__mdt]) {
			entitlementMap.put(pa.NCP_Type__c, pa.NCP_My_entitlement_label__c);
		}
		for (Id scId : mapSCProduct.keySet()) {
			for (Id prId : mapSCProduct.get(scId)) {
	mapProductEntitlmenetLabel.put(prId + '_' + scId, new set<String>());
	for (String access : productTypeMap.get(prId + '_' + scId)) {
		if (entitlementMap.get(access) != null) {
			mapProductEntitlmenetLabel.get(prId + '_' + scId).add(entitlementMap.get(access));
		}
	}
			}
		}
		/*for(Id prId:productTypeMap.get(sc.Id)){
			mapProductEntitlmenetLabel.put(prId, new set<String>());
			for(String access:productTypeMap.get(prId)){
	mapProductEntitlmenetLabel.get(prId).add(entitlementMap.get(access));
			}
		}*/
		//System.debug('### AES productTypeMap '+productTypeMap);
		//System.debug('### AES mapSCProduct '+mapSCProduct);
		//System.debug('### AES mapProductEntitlmenetLabel '+mapProductEntitlmenetLabel);
		//System.debug('### AES setSCIds '+setSCIds);
		for (Product2 pr : [Select Id,Name,ProductCode from Product2 where Id IN:prIds]) {
			productMap.put(pr.Id, pr);
		}
		for (Id scId : setSCIds) {
			List<NCP_MyEntitlementProductAccess_Wrapper> myEntitlementProdList = new List<NCP_MyEntitlementProductAccess_Wrapper>();
			for (Id prId : mapSCProduct.get(scId)) {
	boolean accessExists = false;
	List<NCP_MyEntitlementAccessGroup_Wrapper> accessGroupList = new List<NCP_MyEntitlementAccessGroup_Wrapper>();
	for (String s : myEntitlmentLabelList) {
		NCP_MyEntitlementAccessGroup_Wrapper accessGroup;
		if ((mapProductEntitlmenetLabel.get(prId + '_' + scId)).contains(s)) {
			accessGroup = new NCP_MyEntitlementAccessGroup_Wrapper(s, true);
			accessExists = true;
		} else {
			accessGroup = new NCP_MyEntitlementAccessGroup_Wrapper(s, false);
		}
		accessGroupList.Add(accessGroup);
	}
	if (accessExists == true) {
		//System.debug('### AES accessGroupList '+accessGroupList);
		NCP_MyEntitlementProductAccess_Wrapper myEntitlementProd = new NCP_MyEntitlementProductAccess_Wrapper(productMap.get(prId), accessGroupList);
		//System.debug('### AES myEntitlementProd '+myEntitlementProd);
		myEntitlementProdList.add(myEntitlementProd);
	}
			}
			mapSCProductEntitlment.put(scId, myEntitlementProdList);
		}
		//System.debug('### AES mapSCProductEntitlment '+mapSCProductEntitlment);
		return mapSCProductEntitlment;

	}

	public static Map<Id, Set<String>> getEntitledServices(Set<Id> accountIdSet,User customerUser) {

		//System.debug('### AES Service Access **************');
		Map<Id, Set<String>> accessTypeMap = new Map<Id, Set<String>>();
		Set<String> authscIdSet = new Set<String>();
		User connectedUser;
		if(customerUser!=null)
		{
		 connectedUser=customerUser;  
		}
		else
		{
		connectedUser = [Select contact.AccountId,NCP_IsHorizontal__c,contactId from user where id = :UserInfo.getUserId()];
		}
		Boolean horizontalUser = connectedUser.NCP_IsHorizontal__c;
		Id contactId = connectedUser.contactId;
		// check if child then add access else get child entitlmnt 
		if (string.isNotBlank(contactId)) {
			for (NCP_Authorised_Entitlement__c ce : [select NCP_Service_Contract__c,NCP_Service_Contract__r.NCP_Entitlement_Relationship__c,NCP_Service_Contract__r.RecordType.DeveloperName,NCP_Service_Contract__r.ParentServiceContractId,NCP_Service_Contract__r.NCP_Entitlement_Access_Type__c From NCP_Authorised_Entitlement__c where (NCP_Contact__c = :contactId or NCP_Account__c IN:accountIdSet) and NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE and NCP_Service_Contract__r.NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE]) {
	// check if child then add access else get child entitlmnt 
	if (String.isNotBlank(ce.NCP_Service_Contract__c)) {
		if (ce.NCP_Service_Contract__r.RecordType.DeveloperName == NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_PARENT) {
			authscIdSet.add(ce.NCP_Service_Contract__c);
			accessTypeMap.put(ce.NCP_Service_Contract__c, new Set<String>());
		} else if (ce.NCP_Service_Contract__r.NCP_Entitlement_Relationship__c == NCP_Constants.RELATIONSHIP_S || ce.NCP_Service_Contract__r.NCP_Entitlement_Relationship__c == NCP_Constants.RELATIONSHIP_PS) {
			if (!accessTypeMap.containsKey(ce.NCP_Service_Contract__r.ParentServiceContractId)) {
				accessTypeMap.put(ce.NCP_Service_Contract__r.ParentServiceContractId, new Set<String>());
				accessTypeMap.get(ce.NCP_Service_Contract__r.ParentServiceContractId).add(ce.NCP_Service_Contract__r.NCP_Entitlement_Access_Type__c);
			} else {
				accessTypeMap.get(ce.NCP_Service_Contract__r.ParentServiceContractId).add(ce.NCP_Service_Contract__r.NCP_Entitlement_Access_Type__c);
			}
		}

	}
			}
			//System.debug('### AES getEntitledServices authscIdSet '+authscIdSet);
			// get child service contract 
			for (ServiceContract sc : [
		Select NCP_Entitlement_Access_Type__c,ParentServiceContract.NCP_contract_type__c,ParentServiceContractId,NCP_Default__c
		From ServiceContract
		where AccountId IN:accountIdSet and RecordType.DeveloperName = :NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_CHILD
		and (NCP_Entitlement_Relationship__c = :NCP_Constants.RELATIONSHIP_S or NCP_Entitlement_Relationship__c = :NCP_Constants.RELATIONSHIP_PS)
		and ((NCP_Default__c = true and ParentServiceContract.NCP_contract_type__c = :NCP_Constants.TYPE_CDB) or ParentServiceContractId IN:authscIdSet)
		and NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE
			]) {
	if ((sc.ParentServiceContract.NCP_contract_type__c == NCP_Constants.TYPE_CDB && (sc.NCP_Entitlement_Access_Type__c == NCP_Constants.PIC_VALUE || horizontalUser == false)) || sc.ParentServiceContract.NCP_contract_type__c != NCP_Constants.TYPE_CDB) {
		if (!accessTypeMap.containsKey(sc.ParentServiceContractId)) {
			accessTypeMap.put(sc.ParentServiceContractId, new Set<String>());
			accessTypeMap.get(sc.ParentServiceContractId).add(sc.NCP_Entitlement_Access_Type__c);
		} else {
			accessTypeMap.get(sc.ParentServiceContractId).add(sc.NCP_Entitlement_Access_Type__c);
		}
	}
			}
		}
		//System.debug('### AES accessTypeMap '+accessTypeMap);
		return accessTypeMap;
	}

	public static Set<String> searchAllServices(Id contractId) {

		Set<String> accessList = new Set<String>();
		Set<String> CARESaccess = new Set<String>();
		Set<String> CDBaccess = new Set<String>();
		Set<String> OtherServices = new Set<String>();

		if (NCP_Utils.isUserAuthenticated()) {
			List<ServiceContract> scList = [Select NCP_Contract_Type__c From ServiceContract Where Id = :contractId and NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE];
			if (!scList.isEmpty()) {
	if (scList[0].NCP_Contract_Type__c == NCP_Constants.TYPE_CDB) {
		CDBaccess = NCP_Entitlements.SearchEntitlementsCDB(null, contractId).get(null);
	} else if (scList[0].NCP_Contract_Type__c == NCP_Constants.TYPE_CARES) {
		CARESaccess = NCP_Entitlements.SearchEntitlementsCares(null, contractId).get(null);
	} else {
		OtherServices = NCP_Entitlements.SearchEntitlementsOtherServices(contractId).get(null);
	}
			} else {
	CDBaccess = NCP_Entitlements.SearchEntitlementsCDB(null, null).get(null);
	CARESaccess = NCP_Entitlements.SearchEntitlementsCares(null, null).get(null);
	OtherServices = NCP_Entitlements.SearchEntitlementsOtherServices(null).get(null);
			}

			if (CDBaccess != null) accessList.addAll(CDBaccess);
			if (CARESaccess != null) accessList.addAll(CARESaccess);
			if (OtherServices != null) accessList.addAll(OtherServices);
		}
		return accessList;
	}


	public static Set<String> searchSelectedServices() {

		Set<String> accessList = new Set<String>();
		Set<String> CARESaccess = new Set<String>();
		Set<String> CDBaccess = new Set<String>();

		if (NCP_Utils.isUserAuthenticated()) {
			CDBaccess = NCP_Entitlements.SearchEntitlementsCDB(null, null).get(null);
			CARESaccess = NCP_Entitlements.SearchEntitlementsCares(null, null).get(null);
			if (CDBaccess != null) accessList.addAll(CDBaccess);
			if (CARESaccess != null) accessList.addAll(CARESaccess);
		}
		return accessList;
	}

	/*
	* @description  get the list of favorite and remove favorite products when the product is not entitled (Contract line item is deactivated)
	* @return	list of favorites
	*/

	public static Set<Id> getActiveFavoriteProductsIds() {

		Set<Id> favoriteSet = new Set<Id>();
		Set<Id> productIdSet = new Set<Id>();

		if (NCP_Utils.isInternalUser()) {
			for (NCP_Favorite_Product__c favoriteProduct : [SELECT Id,NCP_Product_Id__c from NCP_Favorite_Product__c where NCP_User__c = :UserInfo.getUserId() and NCP_Removed_Record__c != True]) {
	favoriteSet.add(favoriteProduct.Id);
			}
		} else {
			/*Set<Id> accountIdSet = NCP_Entitlements.getAccountIds();
			for (contractLineItem li : [Select Id,Product2Id from contractLineItem where ServiceContract.AccountId IN:accountIdSet and ServiceContract.NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE and NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE]) {
	productIdSet.add(li.Product2Id);
			}*/
			productIdSet = getMyEntitledProduct(null);

			//system.debug('### AES contractLineItems '+productIdSet);
			for (NCP_Favorite_Product__c favoriteProduct : [SELECT Id,NCP_Product_Id__c from NCP_Favorite_Product__c where NCP_User__c = :UserInfo.getUserId() and NCP_Product_Id__c IN:productIdSet and NCP_Removed_Record__c != True]) {
	favoriteSet.add(favoriteProduct.Id);
			}
		}
		//system.debug('### AES favoriteSet '+favoriteSet);
		return favoriteSet;
	}

}