/** 
About   
-----
Description: Class to manage entitlements fOR the Nokia customer protal

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
Updated: 11 01 2020 – Updated to return ProductCode fOR NDA BOT Demand.
Issues / TODOs  
--------------
**/

public with sharing class NCP_Entitlements {
	
	public static Final Id contactId = [SELECT contact.AccountId FROM User WHERE id = :UserInfo.getUserId()].contactId;
	public static Final User connectedUser =  [SELECT contact.AccountId,NCP_IsHorizontal__c,contactId, CountryCode FROM User WHERE id =: UserInfo.getUserId()];
	public static Final Boolean horizontalUser = connectedUser.NCP_IsHorizontal__c;
	
	public static List<String> getMyEntitlementLabel() {
		
		List<String> options = new List<String>();
		Schema.DescribeFieldResult fieldResult = NCP_Product_Access_Type__mdt.NCP_My_entitlement_label__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for(Schema.PicklistEntry f : ple) {
			options.add(f.getLabel());
		}
		return options;
	}
	
	@AuraEnabled
	public static Boolean isAuthenticated() {
		return NCP_Utils.isUserAuthenticated();
	}
	
	/*
	* @description   Entitlment V2 : CDB app : Identify which Documentations are unlocked in the Salesforce Community fOR the connected customer 
	* @param		 userId: the connected user
	* @param		 objectId: the object that needs access, it can be product OR service
	* @param		 appName: specify if t's CDB OR Cares
	* @return	list of access type	 
	*/
	public static Map<Id, Set<String>> SearchEntitlementsCDB(Set<Id> objectSetId, Id contractId) {
		Set<String> accessTypeSet = new Set<String>();
		Set<Id> childscIdSet = new Set<Id>();
		Set<Id> cliIdSet = new Set<Id>();
		Map<Id, Set<String>> productTypeMap = new Map<Id, Set<String>>();
		Map<Id, ServiceContract> productServiceContractMap = new Map<Id, ServiceContract>();
		User connectedUser = [SELECT contact.AccountId,NCP_IsHorizontal__c,contactId FROM User WHERE id = :UserInfo.getUserId()];
		Boolean HorizontalUser = connectedUser.NCP_IsHorizontal__c;
		// get the existing access FROM contact entitlement objet 
		for(NCP_Authorised_Entitlement__c ce : getAuthorisedEntitlements(contractId, NCP_Constants.TYPE_CDB)) {
			if (String.isNotBlank(ce.NCP_Service_Contract__c) && ce.NCP_Service_Contract__r.NCP_External_Status__c == NCP_Constants.STATUS_ACTIVE && 
				ce.NCP_Service_Contract__r.ParentServiceContract.Status == NCP_Constants.STATUS_ACTIVE && ce.NCP_Service_Contract__r.ParentServiceContract.NCP_External_Status__c == NCP_Constants.STATUS_ACTIVE) {
					accessTypeSet.add(ce.NCP_Service_Contract__r.NCP_Entitlement_Access_Type__c);
					childscIdSet.add(ce.NCP_Service_Contract__c);
				}
			if (String.isNotBlank(ce.NCP_Contract_Line_Item__c)) {
				cliIdSet.add(ce.NCP_Contract_Line_Item__c);
			}
		}
		// get access granted at the Account level fOR service & products
		// Access fOR services 
		for(ServiceContract sc : getChildServiceContracts(NCP_Constants.TYPE_CDB, contractId)) {
			if (objectSetId != null && (sc.NCP_Entitlement_Relationship__c == NCP_Constants.RELATIONSHIP_P || sc.NCP_Entitlement_Relationship__c == NCP_Constants.RELATIONSHIP_PS) && sc.NCP_Default__c == true) {
				childscIdSet.add(sc.Id);
			}
			if (objectSetId == null && 
				(sc.NCP_Entitlement_Relationship__c == NCP_Constants.RELATIONSHIP_S || sc.NCP_Entitlement_Relationship__c == NCP_Constants.RELATIONSHIP_PS) && 
				sc.NCP_Default__c == true && 
				(sc.NCP_Entitlement_Access_Type__c == NCP_Constants.PIC_VALUE || horizontalUser == false)) {
					accessTypeSet.add(sc.NCP_Entitlement_Access_Type__c);
				}
		}
		// Access fOR each product
		if (objectSetId != null) {
			for(contractLineItem li : [SELECT Id,Product2Id,ServiceContract.NCP_Entitlement_Access_Type__c FROM contractLineItem WHERE (ServiceContractId IN :childscIdSet OR Id IN :cliIdSet) AND Product2Id IN :objectSetId AND NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE]) {
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
		return productTypeMap;
	}
	
	/*
	* @description   Entitlment V2 : Cares app : Identify which Documentations are unlocked in the Salesforce Community fOR the connected customer
	* @param		 userId: the connected user
	* @param		 objectId: the object that needs access, it can be product OR service
	* @param		 appName: specify if t's CDB OR Cares
	* @return	list of access type	 
	*/
	public static Map<Id, Set<String>> SearchEntitlementsCares(Set<Id> objectSetId, Id contractId) {
		Set<String> accessTypeSet = new Set<String>();
		Set<Id> cServiceContractIdSet = new Set<Id>();
		Set<Id> childscIdSet = new Set<Id>();
		Set<Id> serviceIdSet = new Set<Id>();
		Set<Id> prServicesIds = new Set<Id>();
		Set<Id> cliIds = new Set<Id>();
		Map<Id, Set<String>> productTypeMap = new Map<Id, Set<String>>();
		Map<Id, List<contractLineItem>> mapContractLineItem = new Map<Id, List<contractLineItem>>();
		Map<Id, Id> mapCESCC = new Map<Id, Id>();
		//get CIL access if SC is empty
		for(NCP_Authorised_Entitlement__c ce : getAuthorisedEntitlements(contractId, NCP_Constants.TYPE_CARES)) {
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
		// get access FROM SC child 
		for(ServiceContract ce : [SELECT Id,NCP_Entitlement_Relationship__c,NCP_Entitlement_Access_Type__c
								  FROM ServiceContract
								  WHERE (ParentServiceContract.Status =:NCP_Constants.STATUS_ACTIVE AND ParentServiceContract.NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE and
										 ParentServiceContractId IN :serviceIdSet) OR (NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE AND Id IN :serviceIdSet AND 
																					   ParentServiceContract.Status =:NCP_Constants.STATUS_ACTIVE)]) {
																						   if (ce.NCP_Entitlement_Relationship__c == NCP_Constants.RELATIONSHIP_S || ce.NCP_Entitlement_Relationship__c == NCP_Constants.RELATIONSHIP_PS) {
																							   accessTypeSet.add(ce.NCP_Entitlement_Access_Type__c);
																						   }
																					   }
		// Access fOR each product
		if (objectSetId != null) {
			for(contractLineItem cli : [SELECT Id,Product2Id,ServiceContractId,ServiceContract.NCP_Entitlement_Access_Type__c
										FROM contractLineItem 
										WHERE (ServiceContractId IN :prServicesIds OR ServiceContract.ParentServiceContractId IN :prServicesIds OR ID IN :cliIds) AND Product2Id IN :objectSetId AND 
										NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE AND ServiceContract.ParentServiceContract.Status = :NCP_Constants.STATUS_ACTIVE]) {
											if (!productTypeMap.containsKey(cli.Product2Id)) {
												productTypeMap.put(cli.Product2Id, new Set<String>());
												productTypeMap.get(cli.Product2Id).add(cli.ServiceContract.NCP_Entitlement_Access_Type__c);
											} else {
												productTypeMap.get(cli.Product2Id).add(cli.ServiceContract.NCP_Entitlement_Access_Type__c);
											}
										}
		}
		
		if (objectSetId != null) {
			for(Id pr : objectSetId) {
				if (!productTypeMap.containsKey(pr)) {
					productTypeMap.put(pr, new Set<String>());
				}
			}
		} else {
			productTypeMap.put(null, accessTypeSet);
		}
		return productTypeMap;
	}
	
	/*
	* @description  Allow a User to be registered with no Care Contracted
	* @param		 objectId: the object that needs access, it can be product OR service
	* @param		 contractId : the contract Id
	* @return	list of access type 
	*/
	public static Map<Id, Set<String>> SearchEntitlementsOtherServices(Id contractId) {
		Set<String> accessTypeSet = new Set<String>();
		Map<Id, Set<String>> productTypeMap = new Map<Id, Set<String>>();
		
		for(NCP_Authorised_Entitlement__c ce : getAuthorisedEntitlements(contractId, NCP_Constants.TYPE_OTHER)) {
			// if it's service access
			if ((ce.NCP_Service_Contract__r.NCP_Entitlement_Relationship__c == NCP_Constants.RELATIONSHIP_S || ce.NCP_Service_Contract__r.NCP_Entitlement_Relationship__c == NCP_Constants.RELATIONSHIP_PS) && ce.NCP_Service_Contract__r.NCP_External_Status__c == NCP_Constants.STATUS_ACTIVE) {
				accessTypeSet.add(ce.NCP_Service_Contract__r.NCP_Entitlement_Access_Type__c);
			}
		}
		productTypeMap.put(null, accessTypeSet);
		return productTypeMap;
	}
	
	public static Map<Id, Set<String>> SearchAllEntitlementsOtherServices() {
		
		Set<String> accessTypeSet = new Set<String>();
		Map<Id, Set<String>> productTypeMap = new Map<Id, Set<String>>();
		for(ServiceContract sc : getChildServiceContracts(NCP_Constants.TYPE_OTHER, null)) {
			if (String.isNotBlank(sc.NCP_Entitlement_Access_Type__c) && (sc.NCP_Entitlement_Relationship__c == NCP_Constants.RELATIONSHIP_S || sc.NCP_Entitlement_Relationship__c == NCP_Constants.RELATIONSHIP_PS)) {
				accessTypeSet.add(sc.NCP_Entitlement_Access_Type__c);
			}
		}
		productTypeMap.put(null, accessTypeSet);
		return productTypeMap;
	}
	
	/*
	* @description   get the list of child service contract 
	* @param		 userId: the connected user
	* @param		 appName: Cares OR CDB
	* @return	list of ServiceContract  
	*/
	public static List<ServiceContract> getChildServiceContracts(String appName, Id contractId) {
		
		List<ServiceContract> sContractList;
		Set<Id> parentServiceContractIdSet = new Set<Id>();
		Set<Id> accountIdSet = getAccountIds();
		// get all parent service contract related to the user
		if (String.isBlank(contractId)) {
			if (!String.isBlank(appName)) {
				sContractList = [SELECT Id,StartDate,EndDate,Status,NCP_External_Status__c FROM ServiceContract WHERE AccountId IN :accountIdSet AND RecordType.DeveloperName = :NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_PARENT AND NCP_Contract_Type__c = :appName AND NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE AND Status =:NCP_Constants.STATUS_ACTIVE];
			} else {
				sContractList = [SELECT Id,StartDate,EndDate,Status,NCP_External_Status__c FROM ServiceContract WHERE AccountId IN :accountIdSet AND RecordType.DeveloperName = :NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_PARENT AND NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE AND Status =:NCP_Constants.STATUS_ACTIVE];
			}
			for(ServiceContract sContract : sContractList) {
				parentServiceContractIdSet.add(sContract.Id);
			}
		} else {
			parentServiceContractIdSet.add(contractId);
		}
		
		//SELECT child elements 
		return [SELECT Id,NCP_Default__c,ParentServiceContractId,ParentServiceContract.NCP_Contract_Type__c,NCP_Entitlement_Relationship__c,NCP_Entitlement_Access_Type__c FROM ServiceContract WHERE ParentServiceContractId IN :parentServiceContractIdSet AND NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE];
	}
	/*
	* @description get entitled products fOR a connected user. 
	* @param userId: the connected user, appName: the application name  
	* @return: wrapper fOR list products
	*/
	
	public static Set<Id> getMyEntitledProduct(Id contractId) {
		
		Set<Id> productIdSet = new Set<Id>();
		Set<Id> childscIdSet = new Set<Id>();
		Set<Id> caresServiceContractIdSet = new Set<Id>();
		
		//CDB Child SC
		for(NCP_Authorised_Entitlement__c ce : getAuthorisedEntitlements(contractId, NCP_Constants.TYPE_CDB)) {
			if (String.isNotBlank(ce.NCP_Service_Contract__c) && ce.NCP_Service_Contract__r.NCP_External_Status__c == NCP_Constants.STATUS_ACTIVE && ce.NCP_Service_Contract__r.Status == NCP_Constants.STATUS_ACTIVE) {
				childscIdSet.add(ce.NCP_Service_Contract__c);
			}
		}
		for(ServiceContract sc : getChildServiceContracts('',contractId)){
			//childscIdSet.add(sc.Id);
			if (sc.ParentServiceContract.NCP_Contract_Type__c == NCP_Constants.TYPE_CDB &&(sc.NCP_Entitlement_Relationship__c == NCP_Constants.RELATIONSHIP_S || sc.NCP_Entitlement_Relationship__c == NCP_Constants.RELATIONSHIP_PS) && sc.NCP_Default__c == true && (sc.NCP_Entitlement_Access_Type__c == NCP_Constants.PIC_VALUE || horizontalUser == false)) {
				childscIdSet.add(sc.Id);
			}
		}
		//CARES Child SC	
		List<NCP_Authorised_Entitlement__c> contactEntitlementList = getAuthorisedEntitlements(contractId, NCP_Constants.TYPE_CARES);
		for(NCP_Authorised_Entitlement__c ce : contactEntitlementList) {
			if (String.isNotBlank(ce.NCP_Service_Contract__c) && ce.NCP_Service_Contract__r.NCP_External_Status__c == NCP_Constants.STATUS_ACTIVE && ce.NCP_Service_Contract__r.Status == NCP_Constants.STATUS_ACTIVE) {
				caresServiceContractIdSet.add(ce.NCP_Service_Contract__c);
			}
		}
		// get SC child 
		for(ServiceContract ce : [SELECT Id,NCP_Entitlement_Relationship__c,NCP_Entitlement_Access_Type__c, name FROM ServiceContract WHERE (ParentServiceContract.NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE AND ParentServiceContractId IN :caresServiceContractIdSet) OR (NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE AND Id IN :caresServiceContractIdSet)]) {
			if (ce.NCP_Entitlement_Relationship__c == NCP_Constants.RELATIONSHIP_S || ce.NCP_Entitlement_Relationship__c == NCP_Constants.RELATIONSHIP_PS) {
				childscIdSet.add(ce.Id);
			}
		}
		
		//added by vladimir - END
		for(contractLineItem li:[SELECT Id,Product2Id FROM contractLineItem WHERE ServiceContractId IN :childscIdSet AND NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE]){
			productIdSet.add(li.Product2Id);
		}
		return productIdSet;  
	}
	
	public static Set<Id> getAccountIds() {
		Set<Id> accountIdSet = new Set<Id>();
		//Id contactId = [SELECT contact.AccountId FROM User WHERE id =: UserInfo.getUserId()].contactId;
		//get all AccountContactRelation related to this User 
		for(AccountContactRelation accountContactRs : [SELECT Id,AccountId,ContactId FROM AccountContactRelation WHERE NCP_Entitlement_Relationship__c = true AND ContactId = :contactId]) {
			// get the Account Id related to this User 
			accountIdSet.add(accountContactRs.AccountId);
		}
		return accountIdSet;
	}
	
	public static list<NCP_MyEntitledProducts_Wrapper> searchMyEntitledProduct() {
		
		//String contactId = [SELECT ContactId FROM User WHERE Id=:UserInfo.getUserId()].ContactId;
		Set<Id> productIdSet = getMyEntitledProduct(null);
		Set<Id> favoriteProductIdSet = new Set<Id>();
		List<NCP_MyEntitledProducts_Wrapper> products = new List<NCP_MyEntitledProducts_Wrapper>();
		for(NCP_Favorite_Product__c favoriteProduct : [SELECT NCP_Product_Id__c FROM NCP_Favorite_Product__c WHERE NCP_User__c = :UserInfo.getUserId() AND NCP_Product_Id__c IN :productIdSet AND NCP_Removed_Record__c != True]) {
			favoriteProductIdSet.add(favoriteProduct.NCP_Product_Id__c);
		}
		for(Product2 pr : [SELECT Id,Name FROM Product2 WHERE Id IN :productIdSet]) {
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
		
		//String contactId = [SELECT ContactId FROM User WHERE Id=:UserInfo.getUserId()].ContactId;
		Set<Id> productIdSet = getMyEntitledProduct(null);
		Set<Id> favoriteProductIdSet = new Set<Id>();
		Integer pSize = (Integer) pageSize;
		Integer offset = ((Integer) pageNumber - 1) * pSize;
		NCP_ListViewPagedResult_Wrapper result = new NCP_ListViewPagedResult_Wrapper();
		List<NCP_MyEntitledProducts_Wrapper> resultProducts = new List<NCP_MyEntitledProducts_Wrapper>();
		
		for(NCP_Favorite_Product__c favoriteProduct : [SELECT NCP_Product_Id__c FROM NCP_Favorite_Product__c WHERE NCP_User__c = :UserInfo.getUserId() AND NCP_Product_Id__c IN :productIdSet AND NCP_Removed_Record__c != True]) {
			favoriteProductIdSet.add(favoriteProduct.NCP_Product_Id__c);
		}
		
		for(Product2 pr : [SELECT Id,Name FROM Product2 WHERE Id IN :productIdSet ORDER BY Name LIMIT :pSize OFFSET :offset]) {
			NCP_MyEntitledProducts_Wrapper entitledPr = new NCP_MyEntitledProducts_Wrapper();
			entitledPr.product = pr;
			if (favoriteProductIdSet.contains(pr.Id)) {
				entitledPr.checked = true;
			} else {
				entitledPr.checked = false;
			}
			resultProducts.add(entitledPr);
		}
		
		result.pageSize = pSize;
		result.page = (Integer) pageNumber;
		result.total = productIdSet.size();
		result.products = resultProducts;
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
		result.total = [SELECT count() FROM product2 WHERE PMD_Additional_Classification__c != 'Product Variant' AND NokiaCPQ_State__c Not IN ('Obsolete', 'Rejected') AND 
						PMD_Product_Item_Type__c IN ('Design item', 'Service Design Item', 'Complementary Item', 'NSN Solution') AND 
						(PMD_Portfolio_Classification__c IN ('Product', 'Service Product', 'Complementary Product', 'Solution')) AND 
						IsActive = true];
		
		for(NCP_Favorite_Product__c favoriteProduct : [SELECT NCP_Product_Id__c FROM NCP_Favorite_Product__c WHERE ID IN :getActiveFavoriteProductsIds()]) {
			favoriteProductIdSet.add(favoriteProduct.NCP_Product_Id__c);
		}
		
		for(Product2 pr : [SELECT Id,Name FROM product2 WHERE PMD_Additional_Classification__c != 'Product Variant' AND NokiaCPQ_State__c Not IN ('Obsolete', 'Rejected') AND 
						   PMD_Product_Item_Type__c IN ('Design item', 'Service Design Item', 'Complementary Item', 'NSN Solution') AND 
						   (PMD_Portfolio_Classification__c IN ('Product', 'Service Product', 'Complementary Product', 'Solution')) AND 
						   IsActive = true
						   ORDER BY Name LIMIT :pSize OFFSET :offset]) {
							   NCP_MyEntitledProducts_Wrapper entitledPr = new NCP_MyEntitledProducts_Wrapper();
							   entitledPr.product = pr;
							   if (NCP_Utils.isInternalUser() && favoriteProductIdSet.contains(pr.Id)) {
								   entitledPr.checked = true;
							   }
							   resultProducts.add(entitledPr);
						   }
		result.products = resultProducts;
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
		//String contactId = [SELECT ContactId FROM User WHERE Id=:UserInfo.getUserId()].ContactId; 
		for(NCP_Favorite_Product__c pr : [SELECT NCP_Product_Id__c,NCP_Product_Id__r.Name FROM NCP_Favorite_Product__c WHERE Id IN :getActiveFavoriteProductsIds() ORDER BY Name LIMIT :pSize OFFSET :offset]) {
			Product2 product = new Product2();
			NCP_MyEntitledProducts_Wrapper entitledPr = new NCP_MyEntitledProducts_Wrapper();
			product.Id = pr.NCP_Product_Id__c;
			product.Name = pr.NCP_Product_Id__r.Name;
			entitledPr.product = product;
			resultProducts.add(entitledPr);
		}
		result.pageSize = pSize;
		result.page = (Integer) pageNumber;
		result.total = [SELECT count() FROM NCP_Favorite_Product__c WHERE Id IN :getActiveFavoriteProductsIds()];
		result.products = resultProducts;
		return result;
	}
	
	/*
	* @description list of the additional access fOR the connected User FROM the contact AND the account 
	* @param User id 
	* @return list OR contact entitlement   
	*/
	public static List<NCP_Authorised_Entitlement__c> getAuthorisedEntitlements(Id contractId, String appName) {		
		// get the authorised entitlemnt related to this User FROM the account AND the contact related
		// accounts are all the account WHERE there is a contact account relationship with entitlmnt checkbox
		Set<Id> accountIdSet = new Set<Id>();
		List<NCP_Authorised_Entitlement__c> ceList = new List<NCP_Authorised_Entitlement__c>();
		//get all AccountContactRelation related to this User 
		if (string.isNotBlank(contactId)) {
			if (appName == NCP_Constants.TYPE_CARES) {
				for(AccountContactRelation acr : [SELECT Id,AccountId,ContactId FROM AccountContactRelation WHERE NCP_Entitlement_Relationship__c = true AND ContactId = :contactId]) {
					// get the Account Id related to this User 
					accountIdSet.add(acr.AccountId);
				}
			} else {
				Id accountId = [SELECT contact.AccountId FROM User WHERE id = :UserInfo.getUserId()].contact.AccountId;
				accountIdSet.add(accountId);
			}
			if (String.isNotBlank(contractId)) {
				ceList = [SELECT NCP_Contract_Line_Item__c, NCP_Contract_Line_Item__r.NCP_External_Status__c, NCP_Service_Contract__r.NCP_External_Status__c, NCP_Service_Contract__r.Status,
						  NCP_Service_Contract__r.RecordType.Name, NCP_Service_Contract__r.NCP_Entitlement_Relationship__c, NCP_Service_Contract__r.NCP_Entitlement_Access_Type__c,
						  NCP_Service_Contract__r.ParentServiceContractId, NCP_Service_Contract__c, NCP_Service_Contract__r.ParentServiceContract.NCP_Entitlement_Access_Type__c,
						  NCP_Service_Contract__r.ParentServiceContract.Status, NCP_Service_Contract__r.ParentServiceContract.NCP_External_Status__c
						  FROM NCP_Authorised_Entitlement__c
						  WHERE (NCP_Contact__c = :contactId OR NCP_Account__c IN :accountIdSet) AND 
						  (NCP_Service_Contract__r.ParentServiceContractId = :contractId OR NCP_Service_Contract__c = :contractId) AND 
						  NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE];
			} else if (!String.isBlank(appName)) {
				ceList = [SELECT NCP_Contract_Line_Item__c, NCP_Contract_Line_Item__r.NCP_External_Status__c, NCP_Service_Contract__r.NCP_External_Status__c, NCP_Service_Contract__r.Status,
						  NCP_Service_Contract__r.RecordType.Name, NCP_Service_Contract__r.NCP_Entitlement_Relationship__c, NCP_Service_Contract__r.NCP_Entitlement_Access_Type__c, 
						  NCP_Service_Contract__r.ParentServiceContractId, NCP_Service_Contract__c, NCP_Service_Contract__r.ParentServiceContract.NCP_Entitlement_Access_Type__c, 
						  NCP_Service_Contract__r.ParentServiceContract.Status, NCP_Service_Contract__r.ParentServiceContract.NCP_External_Status__c
						  FROM NCP_Authorised_Entitlement__c
						  WHERE (NCP_Contact__c = :contactId OR NCP_Account__c IN :accountIdSet) AND 
						  (NCP_Service_Contract__r.ParentServiceContract.NCP_Contract_Type__c = :appName OR 
						   NCP_Service_Contract__r.NCP_Contract_Type__c = :appName OR 
						   NCP_Contract_Line_Item__r.ServiceContract.ParentServiceContract.NCP_Contract_Type__c = :appName
						  ) AND NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE];
			} else {
				ceList = [SELECT NCP_Contract_Line_Item__c, NCP_Contract_Line_Item__r.NCP_External_Status__c, NCP_Service_Contract__r.NCP_External_Status__c, NCP_Service_Contract__r.RecordType.Name,
						  NCP_Service_Contract__r.NCP_Entitlement_Relationship__c, NCP_Service_Contract__r.NCP_Entitlement_Access_Type__c, NCP_Service_Contract__r.ParentServiceContractId, 
						  NCP_Service_Contract__c, NCP_Service_Contract__r.ParentServiceContract.NCP_Entitlement_Access_Type__c, NCP_Service_Contract__r.Status,
						  NCP_Service_Contract__r.ParentServiceContract.Status, NCP_Service_Contract__r.ParentServiceContract.NCP_External_Status__c
						  FROM NCP_Authorised_Entitlement__c
						  WHERE (NCP_Contact__c = :contactId OR NCP_Account__c IN :accountIdSet) AND 
						  NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE ];
			}
		}
		return ceList;
	}
	
	public static List<ServiceContract> getMyParentServiceContract() {
		Set<Id> accountIdSet = getAccountIds();
		//Id contactId = [SELECT contact.AccountId FROM User WHERE id =: UserInfo.getUserId()].contactId;
		Set<Id> serviceIdSet = new Set<Id>();
		if (string.isNotBlank(contactId)) {
			for(NCP_Authorised_Entitlement__c ce : [SELECT Id,NCP_Service_Contract__r.RecordType.DeveloperName,NCP_Service_Contract__c,NCP_Service_Contract__r.ParentServiceContractId FROM NCP_Authorised_Entitlement__c WHERE (NCP_Contact__c = :contactId OR NCP_Account__c IN :accountIdSet) AND NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE]) {
				if (String.isNotBlank(ce.NCP_Service_Contract__c)) {
					if (ce.NCP_Service_Contract__r.RecordType.DeveloperName == NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_PARENT) {
						serviceIdSet.add(ce.NCP_Service_Contract__c);
					} else {
						serviceIdSet.add(ce.NCP_Service_Contract__r.ParentServiceContractId);
					}
				}
			}
		}
		// get CARES/OTHER parent Service contract 
		List<ServiceContract> authList = [SELECT Id,Name,status,NCP_External_Status__c,EndDate,StartDate,ContractNumber,Account.Name,NCP_Contract_Type__c FROM ServiceContract WHERE Id IN :serviceIdSet AND RecordType.DeveloperName = :NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_PARENT AND NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE AND Status = :NCP_Constants.STATUS_ACTIVE ORDER BY Name];
		// get CDB parent Service contract 
		List<ServiceContract> scList = [SELECT Id,Name,status,NCP_External_Status__c,EndDate,StartDate,ContractNumber,Account.Name,NCP_Contract_Type__c FROM ServiceContract WHERE AccountId IN :accountIdSet AND RecordType.DeveloperName = :NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_PARENT AND NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE AND NCP_contract_type__c = :NCP_Constants.TYPE_CDB AND Status = :NCP_Constants.STATUS_ACTIVE ORDER BY Name];
		if (!authList.isEmpty()) {
			scList.addAll(authList);
		}
		return scList;
	}
	/*
	* @description  get the list of product FROM the favorite product object 
	* @return	 
	*/
	public static List<Object> getFavoriteProducts() {
		
		List<Object> resultProducts = new List<Object>();
		
		for(NCP_Favorite_Product__c products : [SELECT NCP_Product_Id__c,NCP_Product_Id__r.Name FROM NCP_Favorite_Product__c WHERE Id IN :getActiveFavoriteProductsIds() limit 10000]) {
			Product2 product = new Product2();
			product.Id = products.NCP_Product_Id__c;
			product.Name = products.NCP_Product_Id__r.Name;
			resultProducts.add(product);
		}
		return resultProducts;
	}
	
	/*
	* @description  get my entitlment fOR all product services fOR a specific service contract used in the my entitlmenet controller 
	* @return   List Access 
	*/
	
	public static List<NCP_MyEntitlementProductAccess_Wrapper> getMyEntitlmentProducts(Id contractId) {
		Set<Id> productIdSet = getMyEntitledProduct(contractId);
		Map<Id, Set<String>> productTypeMap = new Map<Id, Set<String>>();
		//Map<Id,Set<String>> cARESproductTypeMap = new Map<Id,Set<String>>();
		List<NCP_MyEntitlementProductAccess_Wrapper> myEntitlementProdList = new List<NCP_MyEntitlementProductAccess_Wrapper>();
		List<ServiceContract> scList = [SELECT NCP_Contract_Type__c FROM ServiceContract WHERE Id = :contractId];
		
		if (!scList.isEmpty()) {
			if (scList[0].NCP_Contract_Type__c == NCP_Constants.TYPE_CDB) {
				productTypeMap = SearchEntitlementsCDB(productIdSet, contractId);
			} else if (scList[0].NCP_Contract_Type__c == NCP_Constants.TYPE_CARES) {
				productTypeMap = SearchEntitlementsCares(productIdSet, contractId);
			}
			Map<Id, Product2> productMap = new Map<Id, Product2>();
			Map<Id, Set<String>> mapProductEntitlmenetLabel = new Map<Id, Set<String>>();
			Map<String, String> entitlementMap = new Map<String, String>();
			List<String> myEntitlmentLabelList = getMyEntitlementLabel();
			
			for(NCP_Product_Access_Type__mdt pa : [SELECT Id,MasterLabel,NCP_My_entitlement_label__c,NCP_Link__c,NCP_Order__c,NCP_Type__c,NCP_docType__c FROM NCP_Product_Access_Type__mdt]) {
				entitlementMap.put(pa.NCP_Type__c, pa.NCP_My_entitlement_label__c);
			}
			for(Id prId : productTypeMap.keySet()) {
				mapProductEntitlmenetLabel.put(prId, new set<String>());
				for(String access : productTypeMap.get(prId)) {
					mapProductEntitlmenetLabel.get(prId).add(entitlementMap.get(access));
				}
			}
			for(Product2 pr : [SELECT Id,Name FROM Product2 WHERE Id IN :productTypeMap.keySet()]) {
				productMap.put(pr.Id, pr);
			}
			for(Id prId : productTypeMap.keySet()) {
				boolean accessExists = false;
				List<NCP_MyEntitlementAccessGroup_Wrapper> accessGroupList = new List<NCP_MyEntitlementAccessGroup_Wrapper>();
				for(String s : myEntitlmentLabelList) {
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
					NCP_MyEntitlementProductAccess_Wrapper myEntitlementProd = new NCP_MyEntitlementProductAccess_Wrapper(productMap.get(prId), accessGroupList);
					myEntitlementProdList.add(myEntitlementProd);
				}
			}
		}
		return myEntitlementProdList;
	}
	/*
	* @description  get my entitlment fOR all product services fOR a all service contracts used in the my entitlment controller 
	*	 This function is created to avoid Too many queries when we try to return access fOR all SC in the my entitlment page
	* @return   Map access by Parent service contract	 
	*/
	public static Map<Id, List<NCP_MyEntitlementProductAccess_Wrapper>> getEntitledProductMap(Set<Id> accountIdSet, Id contactIds) {
		Map<Id, Set<Id>> mapSCProduct = new Map<Id, Set<Id>>();
		Map<String, Set<String>> productTypeMap = new Map<String, Set<String>>();
		Map<Id, List<NCP_MyEntitlementProductAccess_Wrapper>> mapSCProductEntitlment = new Map<Id, List<NCP_MyEntitlementProductAccess_Wrapper>>();
		Map<Id, Product2> productMap = new Map<Id, Product2>();
		Map<String, Set<String>> mapProductEntitlmenetLabel = new Map<String, Set<String>>();
		Map<String, String> entitlementMap = new Map<String, String>();
		List<String> myEntitlmentLabelList = getMyEntitlementLabel();
		Set<Id> childscIdSet = new Set<Id>();
		Set<Id> authscIdSet = new Set<Id>();
		Set<Id> cliIds = new Set<Id>();
		Set<Id> setSCIds = new Set<Id>();
		Set<Id> prIds = new Set<Id>();
		//Id contactId = [SELECT contact.AccountId FROM User WHERE id =: UserInfo.getUserId()].contactId;
		if(contactIds==null)
		{
			contactIds = [SELECT contact.AccountId FROM User WHERE id =: UserInfo.getUserId()].contactId;  
		}
		
		// get child service contract 
		for(ServiceContract sc : [SELECT Id FROM ServiceContract WHERE AccountId IN :accountIdSet AND RecordType.DeveloperName = :NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_CHILD AND NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE AND ParentServiceContract.NCP_Contract_Type__c = :NCP_Constants.TYPE_CDB AND NCP_Default__c = True AND (NCP_Entitlement_Relationship__c = :NCP_Constants.RELATIONSHIP_P OR NCP_Entitlement_Relationship__c = :NCP_Constants.RELATIONSHIP_PS) AND ParentServiceContract.Status =:NCP_Constants.STATUS_ACTIVE ]) {
			childscIdSet.add(sc.Id);
		}
		// check if child then add access else get child entitlmnt 
		// we will get only Autho assigned to active SC OR CLI 
		if (string.isNotBlank(contactIds)) {
			for(NCP_Authorised_Entitlement__c ce : [SELECT Id,NCP_Contract_Line_Item__c,NCP_Service_Contract__c FROM NCP_Authorised_Entitlement__c WHERE (NCP_Contact__c = :contactIds OR NCP_Account__c IN :accountIdSet) AND NCP_Service_Contract__r.Status =:NCP_Constants.STATUS_ACTIVE ]) {
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
		
		for(ServiceContract sc : [SELECT Id,NCP_Entitlement_Relationship__c,NCP_Entitlement_Access_Type__c FROM ServiceContract WHERE RecordType.DeveloperName = :NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_CHILD AND (Id IN :authscIdSet OR ParentServiceContractId IN :authscIdSet) AND NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE AND ParentServiceContract.Status =:NCP_Constants.STATUS_ACTIVE]) {
			childscIdSet.add(sc.Id);
		}
		
		for(contractLineItem cli : [SELECT Id,Product2Id,ServiceContractId,ServiceContract.NCP_Entitlement_Access_Type__c,serviceContract.ParentServiceContractId FROM contractLineItem WHERE NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE AND (ServiceContractId IN :childscIdSet OR ID IN :cliIds)]) {
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
		
		for(NCP_Product_Access_Type__mdt pa : [SELECT Id,MasterLabel,NCP_My_entitlement_label__c,NCP_Link__c,NCP_Order__c,NCP_Type__c FROM NCP_Product_Access_Type__mdt]) {
			entitlementMap.put(pa.NCP_Type__c, pa.NCP_My_entitlement_label__c);
		}
		for(Id scId : mapSCProduct.keySet()) {
			for(Id prId : mapSCProduct.get(scId)) {
				mapProductEntitlmenetLabel.put(prId + '_' + scId, new set<String>());
				for(String access : productTypeMap.get(prId + '_' + scId)) {
					if (entitlementMap.get(access) != null) {
						mapProductEntitlmenetLabel.get(prId + '_' + scId).add(entitlementMap.get(access));
					}
				}
			}
		}
		for(Product2 pr : [SELECT Id,Name,ProductCode FROM Product2 WHERE Id IN :prIds]) {
			productMap.put(pr.Id, pr);
		}
		for(Id scId : setSCIds) {
			List<NCP_MyEntitlementProductAccess_Wrapper> myEntitlementProdList = new List<NCP_MyEntitlementProductAccess_Wrapper>();
			for(Id prId : mapSCProduct.get(scId)) {
				boolean accessExists = false;
				List<NCP_MyEntitlementAccessGroup_Wrapper> accessGroupList = new List<NCP_MyEntitlementAccessGroup_Wrapper>();
				for(String s : myEntitlmentLabelList) {
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
					NCP_MyEntitlementProductAccess_Wrapper myEntitlementProd = new NCP_MyEntitlementProductAccess_Wrapper(productMap.get(prId), accessGroupList);
					myEntitlementProdList.add(myEntitlementProd);
				}
			}
			mapSCProductEntitlment.put(scId, myEntitlementProdList);
		}
		return mapSCProductEntitlment;
		
	}
	
	public static Map<Id, Set<String>> getEntitledServices(Set<Id> accountIdSet,User customerUser) {
		Map<Id, Set<String>> accessTypeMap = new Map<Id, Set<String>>();
		Set<String> authscIdSet = new Set<String>();
		User connectedUser;
		List<String> horizontalUserServices = new List<String>();
		Set<String> allowedServicesForEmbargoCountryUser = new Set<String>();
		for(NCP_Service_Tile__mdt serviceTile : [SELECT NCP_Public_Access__c, NCP_Default_Access__c, NCP_Horizontal_User__c, NCP_Title__c, NCP_Description__c,
												 NCP_Entitlement_Access_Type__c, NCP_URL__c, NCP_QA_URL__c, NCP_Image_Name__c, NCP_Image_URL__c, NCP_Priority__c,
			 NCP_Show_for_Embargo_Countries__c
												 FROM NCP_Service_Tile__mdt]){
			if(serviceTile.NCP_Horizontal_User__c){
	horizontalUserServices.add(serviceTile.NCP_Entitlement_Access_Type__c);
			}
			if(serviceTile.NCP_Show_for_Embargo_Countries__c){
	allowedServicesForEmbargoCountryUser.add(serviceTile.NCP_Entitlement_Access_Type__c);
			}
		}
		if(customerUser!=null)
		{
			connectedUser=customerUser;  
		}
		else
		{
			connectedUser = [SELECT contact.AccountId,NCP_IsHorizontal__c,contactId, CountryCode FROM User WHERE id = :UserInfo.getUserId()];
		}
	Boolean horizontalUser = connectedUser.NCP_IsHorizontal__c;
		Id contactId = connectedUser.contactId;
		// check if child then add access else get child entitlmnt 
		if (string.isNotBlank(contactId)) {
			for(NCP_Authorised_Entitlement__c ce : [SELECT NCP_Service_Contract__c,NCP_Service_Contract__r.NCP_Entitlement_Relationship__c,NCP_Service_Contract__r.RecordType.DeveloperName,NCP_Service_Contract__r.ParentServiceContractId,NCP_Service_Contract__r.NCP_Entitlement_Access_Type__c FROM NCP_Authorised_Entitlement__c WHERE (NCP_Contact__c = :contactId OR NCP_Account__c IN :accountIdSet) AND NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE AND NCP_Service_Contract__r.NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE AND NCP_Service_Contract__r.Status =:NCP_Constants.STATUS_ACTIVE]) {
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
			// get child service contract 
			for(ServiceContract sc : [
				SELECT NCP_Entitlement_Access_Type__c,ParentServiceContract.NCP_contract_type__c,ParentServiceContractId,NCP_Default__c
				FROM ServiceContract
				WHERE NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE AND ParentServiceContract.Status =:NCP_Constants.STATUS_ACTIVE AND 
				ParentServiceContract.NCP_External_Status__c =:NCP_Constants.STATUS_ACTIVE AND RecordType.DeveloperName = :NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_CHILD AND
				(ParentServiceContractId IN :authscIdSet OR 
				 (
					 AccountId IN :accountIdSet AND 
					 (NCP_Entitlement_Relationship__c = :NCP_Constants.RELATIONSHIP_S OR NCP_Entitlement_Relationship__c = :NCP_Constants.RELATIONSHIP_PS) AND 
					 ((NCP_Default__c = true AND ParentServiceContract.NCP_contract_type__c = :NCP_Constants.TYPE_CDB) OR ParentServiceContractId IN :authscIdSet)
				 )
				)
			]) {
		if (!(horizontalUser && horizontalUserServices.contains(sc.NCP_Entitlement_Access_Type__c)) &&
		(String.isNotBlank(Label.NCP_EmbargoCountriesForTiles) && (
			((Label.NCP_EmbargoCountriesForTiles.containsIgnoreCase(connectedUser.CountryCode)) && 
			allowedServicesForEmbargoCountryUser.contains(sc.NCP_Entitlement_Access_Type__c)) || 
			!(Label.NCP_EmbargoCountriesForTiles.containsIgnoreCase(connectedUser.CountryCode))
		))) {
					if (!accessTypeMap.containsKey(sc.ParentServiceContractId)) {
						accessTypeMap.put(sc.ParentServiceContractId, new Set<String>());
						accessTypeMap.get(sc.ParentServiceContractId).add(sc.NCP_Entitlement_Access_Type__c);
					} else {
						accessTypeMap.get(sc.ParentServiceContractId).add(sc.NCP_Entitlement_Access_Type__c);
					}
				}
			}
		}
		
		return accessTypeMap;
	}
	
	public static Set<String> searchAllServices(Id contractId) {
		
		Set<String> accessList = new Set<String>();
		Set<String> CARESaccess = new Set<String>();
		Set<String> CDBaccess = new Set<String>();
		Set<String> OtherServices = new Set<String>();
		
		if (NCP_Utils.isUserAuthenticated()) {
			List<ServiceContract> scList = [SELECT NCP_Contract_Type__c FROM ServiceContract WHERE Id = :contractId AND NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE];
			if (!scList.isEmpty()) {
				if (scList[0].NCP_Contract_Type__c == NCP_Constants.TYPE_CDB) {
					CDBaccess = SearchEntitlementsCDB(null, contractId).get(null);
				} else if (scList[0].NCP_Contract_Type__c == NCP_Constants.TYPE_CARES) {
					CARESaccess = SearchEntitlementsCares(null, contractId).get(null);
				} else {
					OtherServices = SearchEntitlementsOtherServices(contractId).get(null);
				}
			} else {
				CDBaccess = SearchEntitlementsCDB(null, null).get(null);
				CARESaccess = SearchEntitlementsCares(null, null).get(null);
				OtherServices = SearchEntitlementsOtherServices(null).get(null);
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
			CDBaccess = SearchEntitlementsCDB(null, null).get(null);
			CARESaccess = SearchEntitlementsCares(null, null).get(null);
			if (CDBaccess != null) accessList.addAll(CDBaccess);
			if (CARESaccess != null) accessList.addAll(CARESaccess);
		}
		return accessList;
	}
	
	/*
	* @description  get the list of favorite AND remove favorite products when the product is not entitled (Contract line item is deactivated)
	* @return   list of favorites
	*/
	
	public static Set<Id> getActiveFavoriteProductsIds() {
		
		Set<Id> favoriteSet = new Set<Id>();
		Set<Id> productIdSet = new Set<Id>();
		
		if (NCP_Utils.isInternalUser()) {
			for(NCP_Favorite_Product__c favoriteProduct : [SELECT Id,NCP_Product_Id__c FROM NCP_Favorite_Product__c WHERE NCP_User__c = :UserInfo.getUserId() AND NCP_Removed_Record__c != True]) {
				favoriteSet.add(favoriteProduct.Id);
			}
		} else {
			productIdSet = getMyEntitledProduct(null);
			
			for(NCP_Favorite_Product__c favoriteProduct : [SELECT Id,NCP_Product_Id__c FROM NCP_Favorite_Product__c WHERE NCP_User__c = :UserInfo.getUserId() AND NCP_Product_Id__c IN :productIdSet AND NCP_Removed_Record__c != True]) {
				favoriteSet.add(favoriteProduct.Id);
			}
		}
		return favoriteSet;
	}
	
}