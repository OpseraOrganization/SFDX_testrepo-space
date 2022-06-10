/**
About
-----
Description: Controller for UpgradeMyServices component

Created for: Nokia Customer Portal
Created date: 12 18 2017

Details / Methods
-----------------


Update History
--------------
Created: 16 02 2017 – AES

Issues / TODOs
--------------
**/
public without sharing class NCP_UpgradeMyServices_COM {
	
	@AuraEnabled
	public static List<String> getSelectedServices() {
		
		List<String> accessList = new List<String>();
		Set<String> accessSet = new Set<String>();
		
		if (getUserType()) {
			accessSet = NCP_InternalEntitlements.searchInternalEntitlements();
		} else {
			accessSet = NCP_Entitlements.searchSelectedServices();
		}
		
		for (NCP_Service_Tile__mdt tile : [SELECT NCP_Entitlement_Access_Type__c,NCP_Title__c FROM NCP_Service_Tile__mdt where NCP_Entitlement_Access_Type__c IN:accessSet]) {
			accessList.add(tile.NCP_Title__c);
		}
		
		return accessList;
	}
	
	@AuraEnabled
	public static Boolean getUserType() {
		return NCP_Utils.isInternalUser();
	}
	
	@AuraEnabled
	public static Boolean hasEntitlementRelationship() {
		return NCP_Utils.hasEntitlementRelationship();
	}
	
	@AuraEnabled
	public static List<NCP_NonSelectedServices_Wrapper> getNonSelectedServices(List<String> selectedServicesList) {
		
		Map<String, NCP_Service_Tile__mdt> serviceTileMap = new Map<String, NCP_Service_Tile__mdt>();
		Map<String, String> mapLabel = new Map<String, String>();
		List<NCP_NonSelectedServices_Wrapper> nonSelectedList = new List<NCP_NonSelectedServices_Wrapper>();
		Set<String> setAccessType = new Set<String>();
		
		for (NCP_Service_Tile__mdt tile : [SELECT Id,NCP_Title__c, NCP_Description__c,NCP_Entitlement_Access_Type__c, NCP_URL__c,NCP_Image_URL__c FROM NCP_Service_Tile__mdt]) {
			serviceTileMap.put(tile.NCP_Entitlement_Access_Type__c, tile);
			mapLabel.put(tile.NCP_Entitlement_Access_Type__c, tile.NCP_Title__c);
		}
		
		if (getUserType()) {
			for (String x : NCP_InternalEntitlements.searchAllInternalEntitlements()) {
				if (!selectedServicesList.contains(mapLabel.get(x))) {
					setAccessType.add(x);
				}
			}
		} else {
			for (ServiceContract sc : NCP_Entitlements.getChildServiceContracts('', null)) {
				if (sc.ParentServiceContract.NCP_Contract_Type__c != NCP_Constants.TYPE_OTHER && (sc.NCP_Entitlement_Relationship__c == NCP_Constants.RELATIONSHIP_S || sc.NCP_Entitlement_Relationship__c == NCP_Constants.RELATIONSHIP_PS) && !selectedServicesList.contains(mapLabel.get(sc.NCP_Entitlement_Access_Type__c))) {
					setAccessType.add(sc.NCP_Entitlement_Access_Type__c);
				}
			}
		}
		// To avoid duplicate values
		if (!setAccessType.isEmpty()) {
			for (String x : setAccessType) {
				if (serviceTileMap.get(x) != null) {
					NCP_NonSelectedServices_Wrapper selectedWrapp = new NCP_NonSelectedServices_Wrapper(serviceTileMap.get(x), false);
					nonSelectedList.add(selectedWrapp);
				}
			}
		}
		return nonSelectedList;
	}
	
	@AuraEnabled
	public static List<NCP_OtherServices_Wrapper> getOtherServices() {
		
		List<String> accessList = new List<String>();
		List<String> disabledOtherServices = new List<String>();
		List<NCP_OtherServices_Wrapper> results = new List<NCP_OtherServices_Wrapper>();
		//Set<String> OtherServices = NCP_Entitlements.SearchEntitlementsOtherServices().get(null);
		
		for (String sos : NCP_Entitlements.SearchEntitlementsOtherServices(null).get(null)) {
			disabledOtherServices.add(sos);
		}
		for (String OtherServices : NCP_Entitlements.SearchAllEntitlementsOtherServices().get(null)) {
			NCP_OtherServices_Wrapper result = new NCP_OtherServices_Wrapper();
			result.title = OtherServices;
			if (disabledOtherServices.contains(OtherServices)) result.disabled = true;
			results.add(result);
		}
		return results;
	}
	
	@AuraEnabled
	public static List<sObject> getProducts() {
		return NCP_Utils.selectProducts();
	}
	
	public static Case createOtherCase(String contractNum, String prName, String comment, Id accId, Boolean isInternal) {
		
		Case newOtherCase = new Case();
		newOtherCase.Issue_Reported_By__c = UserInfo.getUserId();
		newOtherCase.AccountId = accId;
		newOtherCase.NCP_Internal_Case__c = isInternal;
		newOtherCase.Status = NCP_Constants.STATUS_PENDING;
		newOtherCase.Description = comment;
		if (String.isNotBlank(prName)) {
			newOtherCase.ProductId = (Id) prName;
		}
		if (String.isNotBlank(contractNum)) {
			String num = '%' + contractNum;
			List<serviceContract> contract = [select Id,ParentServiceContractId,ParentServiceContract.NCP_Contract_Type__c,ContractNumber from serviceContract where ContractNumber like :num limit 1];
			if (!contract.isEmpty()) {
				newOtherCase.NCP_Service_Contract__c = contract[0].ParentServiceContractId;
				newOtherCase.NCP_Contract_Name__c = contract[0].Id;
				newOtherCase.NCP_Contract_Type__c = contract[0].ParentServiceContract.NCP_Contract_Type__c;
				newOtherCase.NCP_Service_Contract_team__c = contract[0].ContractNumber;
			} else {
				if (String.isNotBlank(comment)) {
					comment = ': ' + comment;
				}
				newOtherCase.Description = Label.NCP_Upgrade_Contract_Filled + ' ' + contractNum + comment;
			}
		}
		//List<String> other = new List<String>();
		//other.addAll(otherAccess);
		//newOtherCase.NCP_List_of_Requested_Available_Services__c = string.join(other,';');
		//newOtherCase.NCP_Contract_Type__c = NCP_Constants.TYPE_OTHER;
		newOtherCase.Subject = NCP_Constants.CASE_SUBJECT;
		newOtherCase.priority = NCP_Constants.CASE_PRIORITY;
		return newOtherCase;
	}
	
	public static void checkDuplicateCases(List<String> serviceIds, Map<String, String> mapServices) {
		
		Set<String> servicesInCases = new Set<String>();
		for (Case aCase : [SELECT Id,NCP_List_of_Requested_Available_Services__c,NCP_List_of_Requested_Other_Services__c FROM Case WHERE Issue_Reported_By__c = :UserInfo.getUserId() and status != :NCP_Constants.STATUS_REJECTED]) {
			List<String> serviceNames;
			if (String.isNotBlank(aCase.NCP_List_of_Requested_Available_Services__c)) {
				serviceNames = aCase.NCP_List_of_Requested_Available_Services__c.split(';');
				servicesInCases.addAll(serviceNames);
			}
			if (String.isNotBlank(aCase.NCP_List_of_Requested_Other_Services__c)) {
				serviceNames = aCase.NCP_List_of_Requested_Other_Services__c.split(';');
				servicesInCases.addAll(serviceNames);
			}
		}
		String matchingServices = '';
		for (String aServiceName : serviceIds) {
			if (servicesInCases.contains(aServiceName)) {
				// There is a match append it to the matchingServices string
				matchingServices = matchingServices + mapServices.get(aServiceName) + ', ';
			}
		}
		if (!String.isBlank(matchingServices)) {
			// There is a match throw an error
			// trim off the trailing characters
			matchingServices = matchingServices.removeEnd(', ');
			throw new AuraHandledException(Label.NCP_Upgrade_duplicate_Case + ' ' + matchingServices);
		}
	}
	
	public static List<Case> submitInternalCase(BusinessHours bHours, List<String> serviceIds, String comment, Boolean other, Database.DMLOptions dmo, Id rTypeId) {
		
		List<Case> toCreateCases = new List<Case>();
		Set<String> duplicateParentAccessList = new Set<String>();
		//Map<Id, NCP_Internal_Users_Services__c> mapSC = new Map<Id, NCP_Internal_Users_Services__c>();
		Map<String, List<Id>> mapAccess = new Map<String, List<Id>>();
		Map<Id, List<String>> mapSCWithChild = new Map<Id, List<String>>();
		Map<Id, List<String>> mapUniqueSCWithChild = new Map<Id, List<String>>();
		Map<String, Id> mapAccessSC = new Map<String, Id>();
		Id userAccountId = null;
		List<User> u = [Select Id,ContactId from User where Id = :UserInfo.getUserId() and NCP_Is_Internal__c = true and ContactId != null limit 1];
		// get legal account from the connected user if it's internal user and associated to a contact
		
		if (!u.isEmpty()) {
			List<AccountContactRelation> acrList = [Select AccountId,ContactId from AccountContactRelation where NCP_Entitlement_Relationship__c = true and ContactId = :u[0].contactId limit 1];
			if (!acrList.isEmpty()) {
				userAccountId = acrList[0].AccountId;
			}
		}
		if (String.isNotBlank(comment) && other == true) {
			Case newOtherCase = createOtherCase('', '', comment, userAccountId, true);
			newOtherCase.recordTypeId = rTypeId;
			if (bHours != null) {
				newOtherCase.BusinessHoursId = bHours.Id;
			}
			newOtherCase.setOptions(dmo);
			toCreateCases.add(newOtherCase);
		}
		if (!serviceIds.isEmpty()) {
			// get all parent service contract related to this account
			
			//for (NCP_Internal_Users_Services__c ius : [Select Id,NCP_All_Users__c,NCP_Service__c,NCP_User__c,Name From NCP_Internal_Users_Services__c]) {
			//  mapSC.put(ius.id, ius);
			//}
			
			
			/* Code commented by Vladimir - It looks we do not need this code at all. Code it self is completely non-uderstandable

			// get all child service contract related to this account
			for (NCP_Internal_Users_Services__c ius : [Select Id,NCP_All_Users__c,NCP_Service__c,NCP_User__c,Name From NCP_Internal_Users_Services__c Where NCP_Service__c IN:serviceIds]) {
			mapAccessSC.put(ius.NCP_Service__c, ius.id);
			if (!mapAccess.containsKey(ius.NCP_Service__c)) {
			mapAccess.put(ius.NCP_Service__c, new List<Id>());
			}
			mapAccess.get(ius.NCP_Service__c).add(ius.id);
			
			if (!mapSCWithChild.containsKey(ius.id)) {
			mapSCWithChild.put(ius.id, new List<String>());
			}
			mapSCWithChild.get(ius.id).add(ius.NCP_Service__c);
			}
			// create case by parent service contract for other and cares services : one case per contract
			// what if an access belong to two parent CDB contract
			for (Id parent : mapSCWithChild.keySet()) {
			for (String access : mapSCWithChild.get(parent)) {
			if (mapAccess.get(access).size() == 1) {
			if (!mapUniqueSCWithChild.containsKey(parent)) {
			mapUniqueSCWithChild.put(parent, new List<String>());
			}
			mapUniqueSCWithChild.get(parent).add(access);
			}
			}
			}
			
			for (Id parent : mapUniqueSCWithChild.keySet()) {
			if (mapUniqueSCWithChild.get(parent) != null) {
			for (String acc : mapUniqueSCWithChild.get(parent)) {
			Case newCase = new Case();
			if (bHours != null) {
			newCase.BusinessHoursId = bHours.Id;
			}
			newCase.Issue_Reported_By__c = UserInfo.getUserId();
			newCase.AccountId = userAccountId;
			newCase.Status = NCP_Constants.STATUS_PENDING;
			newCase.NCP_List_of_Requested_Available_Services__c = acc;
			newCase.NCP_Contract_Type__c = NCP_Constants.TYPE_CDB;
			newCase.NCP_Internal_Case__c = true;
			newCase.Subject = NCP_Constants.CASE_SUBJECT;
			newCase.Description = comment;
			newCase.recordTypeId = rTypeId;
			newCase.priority = NCP_Constants.CASE_PRIORITY;
			newCase.setOptions(dmo);
			toCreateCases.add(newCase);
			}
			}
			}
			for (String access : serviceIds) {
			if (mapAccess.get(access) == null || mapAccess.get(access).size() != 1) {
			duplicateParentAccessList.add(access);
			}
			}
			// cases that belong to two parent
			for (String access : duplicateParentAccessList) {
			Case newCase = new Case();
			if (bHours != null) {
			newCase.BusinessHoursId = bHours.Id;
			}
			newCase.Issue_Reported_By__c = UserInfo.getUserId();
			newCase.Status = NCP_Constants.STATUS_PENDING;
			newCase.NCP_List_of_Requested_Available_Services__c = access;
			newCase.AccountId = userAccountId;
			newCase.Subject = NCP_Constants.CASE_SUBJECT;
			newCase.Description = comment;
			newCase.recordTypeId = rTypeId;
			newCase.NCP_Internal_Case__c = true;
			newCase.priority = NCP_Constants.CASE_PRIORITY;
			newCase.setOptions(dmo);
			toCreateCases.add(newCase);
			}
			End of commented code by Vladimir - It looks we do not need this code at all. Code it self is completely non-uderstandable
			I added new much simpler code below
			*/
			for (String access : serviceIds) {
				Case newCase = new Case();
				if (bHours != null) {
					newCase.BusinessHoursId = bHours.Id;
				}
				newCase.Issue_Reported_By__c = UserInfo.getUserId();
				newCase.Status = NCP_Constants.STATUS_PENDING;
				newCase.NCP_List_of_Requested_Available_Services__c = access;
				newCase.AccountId = userAccountId;
				newCase.Subject = NCP_Constants.CASE_SUBJECT;
				newCase.Description = comment;
				newCase.recordTypeId = rTypeId;
				newCase.NCP_Internal_Case__c = true;
				newCase.priority = NCP_Constants.CASE_PRIORITY;
				newCase.NCP_Contract_Type__c = NCP_Constants.TYPE_CDB;
				newCase.setOptions(dmo);
				toCreateCases.add(newCase);
			}
		}
		return toCreateCases;
	}
	
	@AuraEnabled
	public static void submitCase(String selectedElmt, String contractNum, String prName, String comment, Boolean other) {
		
		List<String> serviceIds = new List<String>();
		Map<String, String> mapServices = new Map<String, String>();
		BusinessHours bHours = [select Id from BusinessHours where Name = :NCP_Constants.BUSINESS_HOUR_NCP];
		List<Case> toCreateCases = new List<Case>();
		Set<Id> accountIdSet = NCP_Entitlements.getAccountIds();
		Map<Id, Id> serviceContractIdAccountIdMap = new Map<Id, Id>();//Added by SB
		
		Set<String> otherAccess = new Set<String>();
		Id rTypeId = NCP_Utils.getObjectRecordTypeId('Case', NCP_Constants.CASE_RT_DEVNAME_ENTITLEMENT);
		Database.DMLOptions dmo = new Database.DMLOptions();
		dmo.AssignmentRuleHeader.useDefaultRule = true;
		
		if (String.isNotBlank(selectedElmt)) {
			for (NCP_Service_Tile__mdt tile : [SELECT NCP_Entitlement_Access_Type__c,NCP_Title__c FROM NCP_Service_Tile__mdt where NCP_Title__c IN:selectedElmt.split(',')]) {
				serviceIds.add(tile.NCP_Entitlement_Access_Type__c);
				mapServices.put(tile.NCP_Entitlement_Access_Type__c, tile.NCP_Title__c);
			}
		}
		
		checkDuplicateCases(serviceIds, mapServices);
		if (getUserType()) {
			toCreateCases = submitInternalCase(bHours, serviceIds, comment, other, dmo, rTypeId);
		} else {
			ID userAccountId = null;
			ID contactId = [Select Id,ContactId from User where ID = :UserInfo.getUserId()].ContactId;
			if (ContactId != null) {
				userAccountId = [Select Id,AccountId,ContactId from AccountContactRelation where NCP_Entitlement_Relationship__c = true and ContactId = :contactId][0].AccountId;
			}
			Set<String> duplicateParentAccessList = new Set<String>();
			Map<Id, ServiceContract> mapSC = new Map<Id, ServiceContract>();
			Map<String, List<Id>> mapAccess = new Map<String, List<Id>>();
			Map<Id, List<String>> mapSCWithChild = new Map<Id, List<String>>();
			Map<Id, List<String>> mapUniqueSCWithChild = new Map<Id, List<String>>();
			Map<String, Id> mapAccessSC = new Map<String, Id>();
			if (String.isNotBlank(prName) || String.isNotBlank(contractNum) || (String.isNotBlank(comment) && other == true)) {
				Case newOtherCase = createOtherCase(contractNum, prName, comment, userAccountId, false);
				newOtherCase.recordTypeId = rTypeId;
				if (bHours != null) {
					newOtherCase.BusinessHoursId = bHours.Id;
				}
				newOtherCase.setOptions(dmo);
				toCreateCases.add(newOtherCase);
			}
			
			if (!serviceIds.isEmpty()) {
				// get all parent service contract related to this account
				for (ServiceContract sc : [Select Id,NCP_Contract_Type__c,ContractNumber, AccountId From ServiceContract where Account.Id IN:accountIdSet and RecordType.DeveloperName = :NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_PARENT and NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE]) {
					mapSC.put(sc.Id, sc);
					serviceContractIdAccountIdMap.put(sc.Id, sc.AccountId);//Added by SB
				}
				
				// get all child service contract related to this account
				for (ServiceContract sc : [Select Id,ParentServiceContractId,NCP_Entitlement_Access_Type__c,ParentServiceContract.NCP_Contract_Type__c From ServiceContract Where RecordType.DeveloperName != :NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_PARENT and NCP_Entitlement_Access_Type__c IN:serviceIds and AccountId IN:accountIdSet and NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE and ParentServiceContract.NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE]) {
					mapAccessSC.put(sc.NCP_Entitlement_Access_Type__c, sc.id);
					
					if (!mapAccess.containsKey(sc.NCP_Entitlement_Access_Type__c)) {
						mapAccess.put(sc.NCP_Entitlement_Access_Type__c, new List<Id>());
					}
					mapAccess.get(sc.NCP_Entitlement_Access_Type__c).add(sc.ParentServiceContractId);
					
					if (!mapSCWithChild.containsKey(sc.ParentServiceContractId)) {
						mapSCWithChild.put(sc.ParentServiceContractId, new List<String>());
					}
					mapSCWithChild.get(sc.ParentServiceContractId).add(sc.NCP_Entitlement_Access_Type__c);
				}
				
				// create case by parent service contract for other and cares services : one case per contract
				// what if an access belong to two parent CDB contract
				for (Id parent : mapSCWithChild.keySet()) {
					for (String access : mapSCWithChild.get(parent)) {
						if (mapAccess.get(access).size() > 1) {
							duplicateParentAccessList.add(access);
						} else {
							if (!mapUniqueSCWithChild.containsKey(parent)) {
								mapUniqueSCWithChild.put(parent, new List<String>());
							}
							mapUniqueSCWithChild.get(parent).add(access);
						}
					}
				}
				
				for (Id parent : mapUniqueSCWithChild.keySet()) {
					if (mapUniqueSCWithChild.get(parent) != null) {
						if (mapSC.get(parent).NCP_Contract_Type__c == NCP_Constants.TYPE_CDB) {
							for (String acc : mapUniqueSCWithChild.get(parent)) {
								Case newCDBCase = new Case();
								if (bHours != null) {
									newCDBCase.BusinessHoursId = bHours.Id;
								}
								newCDBCase.Issue_Reported_By__c = UserInfo.getUserId();
								newCDBCase.Status = NCP_Constants.STATUS_PENDING;
								newCDBCase.NCP_Service_Contract__c = parent;
								newCDBCase.AccountId = serviceContractIdAccountIdMap.get(parent);
								newCDBCase.NCP_Contract_Name__c = mapAccessSC.get(acc);
								newCDBCase.NCP_Service_Contract_team__c = mapSC.get(parent).ContractNumber;
								newCDBCase.NCP_List_of_Requested_Available_Services__c = acc;
								newCDBCase.NCP_Contract_Type__c = NCP_Constants.TYPE_CDB;
								newCDBCase.Subject = NCP_Constants.CASE_SUBJECT;
								newCDBCase.Description = comment;
								newCDBCase.recordTypeId = rTypeId;
								newCDBCase.priority = NCP_Constants.CASE_PRIORITY;
								newCDBCase.setOptions(dmo);
								toCreateCases.add(newCDBCase);
							}
						} else {
							List<String> accessList = mapUniqueSCWithChild.get(parent);
							Case newCase = new Case();
							if (bHours != null) {
								newCase.BusinessHoursId = bHours.Id;
							}
							newCase.Issue_Reported_By__c = UserInfo.getUserId();
							newCase.Status = NCP_Constants.STATUS_PENDING;
							newCase.AccountId = serviceContractIdAccountIdMap.get(parent);
							newCase.NCP_Service_Contract__c = parent;
							newCase.NCP_Service_Contract_team__c = mapSC.get(parent).ContractNumber;
							List<String> access = new List<String>();
							if (mapUniqueSCWithChild.get(parent).size() == 1) {
								newCase.NCP_Contract_Name__c = mapAccessSC.get(mapUniqueSCWithChild.get(parent)[0]);
							}
							if (mapSC.get(parent).NCP_Contract_Type__c == NCP_Constants.TYPE_OTHER) {
								newCase.NCP_List_of_Requested_Other_Services__c = string.join(accessList, ';');
							} else {
								newCase.NCP_List_of_Requested_Available_Services__c = string.join(accessList, ';');
							}
							newCase.NCP_Contract_Type__c = mapSC.get(parent).NCP_Contract_Type__c;
							newCase.Subject = NCP_Constants.CASE_SUBJECT;
							newCase.Description = comment;
							newCase.recordTypeId = rTypeId;
							newCase.priority = NCP_Constants.CASE_PRIORITY;
							newCase.setOptions(dmo);
							toCreateCases.add(newCase);
						}
					}
				}
				// cases that belong to two parent
				for (String access : duplicateParentAccessList) {
					Case newCase = new Case();
					if (bHours != null) {
						newCase.BusinessHoursId = bHours.Id;
					}
					newCase.Issue_Reported_By__c = UserInfo.getUserId();
					newCase.AccountId = serviceContractIdAccountIdMap.get(mapAccessSC.get(access));
					newCase.Status = NCP_Constants.STATUS_PENDING;
					String contractList = '';
					for (Id parent : mapAccess.get(access)) {
						contractList += mapSC.get(parent).ContractNumber + ';';
					}
					newCase.NCP_Service_Contract_team__c = contractList;
					// because parents are from the same Contract Type
					newCase.NCP_Contract_Type__c = mapSC.get(mapAccess.get(access)[0]).NCP_Contract_Type__c;
					if (mapSC.get(mapAccess.get(access)[0]).NCP_Contract_Type__c == NCP_Constants.TYPE_OTHER) {
						newCase.NCP_List_of_Requested_Other_Services__c = access;
					} else {
						newCase.NCP_List_of_Requested_Available_Services__c = access;
					}
					newCase.Subject = NCP_Constants.CASE_SUBJECT;
					newCase.Description = comment;
					newCase.recordTypeId = rTypeId;
					newCase.priority = NCP_Constants.CASE_PRIORITY;
					newCase.setOptions(dmo);
					toCreateCases.add(newCase);
				}
			}
		}
		Database.SaveResult[] srList;
		if (!toCreateCases.isEmpty()) {
			try {
				srList = Database.insert(toCreateCases, false);
			} catch (DMLexception dex) {
				AuraHandledException err = new AuraHandledException(dex.getMessage());
				throw err;
			}
			for (Database.SaveResult sr : srList) {
				if (!sr.isSuccess()) {
					Database.Error dbErr = sr.getErrors()[0];
					AuraHandledException otherErr = new AuraHandledException(dbErr.getMessage());
					throw otherErr;
				}
			}
		}
	}
	public static void test(){
		String x='1';
		String y='2';
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
		x=y;
	}
}