/**********************************************************************************************************************
* Class Name - NCP_GetUserEntitleMentsAndProductsForNDA 
* author: Avishek Hazra
* Date: September-2020
* Description: Apex Rest Web Service Class For Sending Data To NDA With User Entitlements And Products
* UpdatedBy: Karan Monga
* Update: Product Code and Sorting 
********************************************************************************************************************* */
@RestResource(urlMapping='/GetEntitleMentsAndProducts/*')
global with sharing class NCP_GetUserEntitleMentsAndProductsForNDA {
	@HttpGet
	global static void getEntitlementsAndProducts() {
		RestRequest request = RestContext.request;
		RestResponse res = RestContext.response;
		String fedId = request.params.get('fedKey');
		String jsonData = '';
		List<User> userList = [select id,Email,FederationIdentifier,NCP_SSOPID__c,NCP_Relationship__c,contact.AccountId,NCP_IsHorizontal__c,contactId, CountryCode from User where FederationIdentifier=:fedId];		
		if(userList.isEmpty())
		{
			jsonData = 'User Does Not Exist With The Fed Key: ' + fedId; res.addHeader('Content-Type', 'application/json'); res.responseBody = Blob.valueOf(jsonData); res.statusCode = 400;
		}
		else{
			Set<Id> accountIdSet = new Set<Id>();
			for (AccountContactRelation accountContactRs : [Select Id,AccountId,ContactId from AccountContactRelation where NCP_Entitlement_Relationship__c = true and ContactId = :userList[0].contactId]) {
				// get the Account Id related to this user 
				accountIdSet.add(accountContactRs.AccountId);
			}		
			if(!accountIdSet.isEmpty()){
				Map<Id,List<NCP_MyEntitlementProductAccess_Wrapper>> mapSCProductAccess = NCP_Entitlements.getEntitledProductMap(accountIdSet,userList[0].contactId);
				Map<Id,Set<String>> mapSCServiceAccess = NCP_Entitlements.getEntitledServices(accountIdSet,userList[0]);
				Set<Id> scIds = new Set<Id>();
				List<String>entitlementList=new List<String>();
				List<Product2>productNameList=new List<Product2>();
				Map<String,String> mapServiceTitle = new Map<String,String>();
				for(NCP_Service_Tile__mdt tile : [SELECT NCP_Entitlement_Access_Type__c,NCP_Title__c FROM NCP_Service_Tile__mdt]){
					mapServiceTitle.put(tile.NCP_Entitlement_Access_Type__c,tile.NCP_Title__c);
				} 
				List<ServiceContract> serviceContractList = getMyParentServiceContract(userList[0].contactId,accountIdSet);
				for(ServiceContract contract:serviceContractList){
					scIds.add(contract.Id);	
				}
				List<NCP_MyEntitlementProductAccess_Wrapper> productEntitlementsList = new List<NCP_MyEntitlementProductAccess_Wrapper>();
				for(Id contractId:scIds){
					List<NCP_MyEntitlementProductAccess_Wrapper> prEntitlements = mapSCProductAccess.get(contractId);
					if(prEntitlements!=null&& !prEntitlements.isEmpty()){
						productEntitlementsList.addAll(prEntitlements);
					}
					List<String> srEntitlements = new List<String>();
					if(mapSCServiceAccess.get(contractId) != null){
						for(String service:mapSCServiceAccess.get(contractId)){
							srEntitlements.add(mapServiceTitle.get(service));
							entitlementList.addAll(srEntitlements);
						}
					}
				}
				List<List<EntitlementContact>> entitledCntCHList = NCP_CaseCreationOnSP.checkforCHTileDisplay(userList[0]);	
				if(entitledCntCHList[0].size()>0 && mapServiceTitle.containsKey(NCP_Constants.NCP_chACCESS_TYPE)){
					entitlementList.add(mapServiceTitle.get(NCP_Constants.NCP_chACCESS_TYPE));
				}
				if(entitledCntCHList[1].size()>0 && mapServiceTitle.containsKey(NCP_Constants.NCP_chhwsACCESS_TYPE)){
					entitlementList.add(mapServiceTitle.get(NCP_Constants.NCP_chhwsACCESS_TYPE));
				}
				//CH Secondary Contact Entitlement
				List<ServiceContract> SecondaryContactContract = getCHSecondaryContactEntitledServices(accountIdSet);
				if(SecondaryContactContract?.size() > 0){
					for(ServiceContract ct:SecondaryContactContract){
						if(ct.CH_PortalCaseCreationSWMaintenance__c == true){
							entitlementList.add(mapServiceTitle.get(NCP_Constants.NCP_chACCESS_TYPE));
						}
						if(ct.CH_PortalCaseCreationHWS__c == true){
							entitlementList.add(mapServiceTitle.get(NCP_Constants.NCP_chhwsACCESS_TYPE));
						}
					}
				}
				for(NCP_MyEntitlementProductAccess_Wrapper wrapper:productEntitlementsList){	  
					productNameList.add((Product2)wrapper.myProduct);  
				}
				Map<String,List<Object>> ProductAndEntitlementMap = new Map<String,List<Object>>();
				//Cares
				Set<String> oServiceContractIdSet = new Set<String>();
				for(EntitlementContact oEntitlementContact : (List<EntitlementContact>) DML_SObject.doQuery('SELECT Entitlement.ServiceContractId FROM EntitlementContact WHERE ContactId = "' + userList[0].contactId + '"')) {
					oServiceContractIdSet.add(oEntitlementContact.Entitlement.ServiceContractId);	
				}
				if(!oServiceContractIdSet.isEmpty()) {
					String sQuery = 'SELECT Id, Account.Name, ServiceContract.Name, Asset.Product2.Name, Asset.CH_Solution__r.Name, Asset.CH_ProductVariant__r.Name, Asset.CH_ProductRelease__r.Name, ContractLineItem.CH_ServiceType__c, ';
					sQuery += 'ContractLineItem.CH_ServiceOffering__c, ContractLineItem.LineItemNumber, ContractLineItem.CH_CountryISO2__c, ContractLineItem.CH_QtyCoveredNetworkElementAssets__c, ContractLineItem.CH_EquipmentLocationBasedTZCoverage__c ';
					sQuery += 'FROM Entitlement WHERE Status = "Active" AND Name != "Authorized Contact" AND CH_RecordTypeCheck__c = true AND ContractLineItem.CH_ServiceType__c = "Customer Support" AND ServiceContract.NCP_External_Status__c = "Active" AND ';
					sQuery += 'ServiceContract.Status = "Active" AND ContractLineItem.NCP_External_Status__c = "Active" AND ContractLineItem.Status = "Active" AND ServiceContract.CH_PortalCaseCreationSWMaintenance__c = true AND ServiceContractId IN ' + DML_SObject.setToString(oServiceContractIdSet);
					ProductAndEntitlementMap.put('Cares Entitlements',DML_SObject.doQuery(sQuery));
				}
				Map<String,List<Product2>> ProductMap = new Map<String,List<Product2>>();
				//To remove the duplicates from list and sort
				if (!entitlementList.isEmpty()){ set<string>strSetEntitlement = new set<string>(entitlementList); entitlementList = new List<String>(strSetEntitlement); entitlementList.sort();
											   }
				if(!productNameList.isEmpty()){ set<Product2>strSetProduct = new set<Product2>(productNameList); productNameList = new List<Product2>(strSetProduct); productNameList.sort();
											  }
				///////	
				ProductAndEntitlementMap.put('Entitlements',entitlementList);
				ProductMap.put('Products',productNameList);
				
				//SP-60 Colloboration Changes
				Map<String,List<CollaborationGroupMember>> ColloborationGrpMemberMap=new Map<String,List<CollaborationGroupMember>>();
				List<CollaborationGroupMember> ColloborationGrpMember = NCP_GetChatterGroupsForNDA.getCollaborationGroupMember(userList[0].Id);
				if(ColloborationGrpMember?.size() > 0){
					ColloborationGrpMemberMap.put('Communities',ColloborationGrpMember);
				}
				
				DataWrapper wrapper = new DataWrapper(userList[0].Id,userList[0].FederationIdentifier,userList[0].Email, userList[0].NCP_SSOPID__c,userList[0].NCP_Relationship__c,ProductAndEntitlementMap,ProductMap,ColloborationGrpMemberMap);
				jsonData = JSON.serialize(wrapper);
				res.addHeader('Content-Type', 'application/json');
				res.responseBody = Blob.valueOf(jsonData);
				res.statusCode = 200;
			}
		}
	}	
	public static List<ServiceContract> getMyParentServiceContract(Id contactId,Set<id>accountIdSet) {	  
		Set<Id> serviceIdSet = new Set<Id>();
		if (string.isNotBlank(contactId)) {
			for (NCP_Authorised_Entitlement__c ce : [select Id,NCP_Service_Contract__r.RecordType.DeveloperName,NCP_Service_Contract__c,NCP_Service_Contract__r.ParentServiceContractId from NCP_Authorised_Entitlement__c where (NCP_Contact__c = :contactId or NCP_Account__c IN:accountIdSet) and NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE]) {
				if (String.isNotBlank(ce.NCP_Service_Contract__c)) {
					if (ce.NCP_Service_Contract__r.RecordType.DeveloperName == NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_PARENT) {
						serviceIdSet.add(ce.NCP_Service_Contract__c);
					} else { serviceIdSet.add(ce.NCP_Service_Contract__r.ParentServiceContractId);
						   }
				}
			}
		}
		// get CARES/OTHER parent Service contract 
		List<ServiceContract> authList = [Select Id,Name,status,NCP_External_Status__c,EndDate,StartDate,ContractNumber,Account.Name,NCP_Contract_Type__c From ServiceContract Where Id IN:serviceIdSet AND RecordType.DeveloperName = :NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_PARENT and NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE order by Name];
		// get CDB parent Service contract 
		List<ServiceContract> scList = [Select Id,Name,status,NCP_External_Status__c,EndDate,StartDate,ContractNumber,Account.Name,NCP_Contract_Type__c From ServiceContract Where AccountId IN:accountIdSet and RecordType.DeveloperName = :NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_PARENT and NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE and NCP_contract_type__c = :NCP_Constants.TYPE_CDB order by Name];
		if (!authList.isEmpty()) {
			scList.addAll(authList);
		}
		return scList;
	}
	//DataWrapper Wrappaer holds the List of Entilements Or Products In A Map
	public class DataWrapper {
		private String fedKey;
		private String email;
		private String ssopId;
		private String relationshipType;
		private String userId;
		private Map<String,List<Object>> ProductAndEntitlementMap = New Map<String,List<Object>>();
		Map<String,List<Product2>> ProductMap = new Map<String,List<Product2>>();
		Map<String,List<CollaborationGroupMember>> CommunitiesMap=new Map<String,List<CollaborationGroupMember>>();
		public DataWrapper(String Id,String fedId,String mail,String customerSSOPId,String relationshipTypeWithNokia,Map<String,List<Object>> ProdAndEntilementMap,Map<String,List<Product2>> ProductMap, Map<String,List<CollaborationGroupMember>> ColloborationGrpMemberMap){	  
			this.fedKey = fedId;
			this.email = mail;
			this.ssopId = customerSSOPId;
			this.userId = Id;
			this.relationshipType = relationshipTypeWithNokia;
			this.ProductAndEntitlementMap = ProdAndEntilementMap ;
			this.ProductMap = ProductMap;
			this.CommunitiesMap = ColloborationGrpMemberMap; 
		} 
	}  
	
	public static List<ServiceContract>  getCHSecondaryContactEntitledServices(Set<id>accountIdSet){ 
		List<ServiceContract> chServiceContract = [Select CH_CDB_ContractType__c,Name,RecordType.Name,CH_PortalCaseCreationSWMaintenance__c,CH_PortalCaseCreationHWS__c From ServiceContract where AccountId IN:accountIdSet and NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE and RecordType.DeveloperName = 'CH_ServiceContract' and Status = :NCP_Constants.STATUS_ACTIVE];
		return chServiceContract;
	}
}