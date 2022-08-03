/**	
About   
-----
Description: Controller for My entitlements component

Created for: Nokia Customer Portal 
Created date: 02 07 2018

Details / Methods   
-----------------	

Update History	
--------------	
Created: 02 07 2018 – ABO 
Updated: 04 20 2018 - Oprimizations & bug fixing by AES

Issues / TODOs  
--------------
**/
public with sharing class NCP_MyEntitlements_COM {
   
	
	/*
	* @description   gets entitlements for a specific contract Id 
	* @return		wrapper list for service contract and it's related products and services	
	*/
	@AuraEnabled
	public static List<NCP_MyEntitlements_Wrapper> getMyEntitlements(Id contractId){
		
		List<NCP_MyEntitlements_Wrapper> listMyEntitlements = new List<NCP_MyEntitlements_Wrapper>();
		List<ServiceContract> scontractList = getContractsInfo(contractId); 
		Map<String,String> mapServiceTitle = new Map<String,String>();
		
		for(NCP_Service_Tile__mdt tile : [SELECT NCP_Entitlement_Access_Type__c,NCP_Title__c FROM NCP_Service_Tile__mdt]){
			mapServiceTitle.put(tile.NCP_Entitlement_Access_Type__c,tile.NCP_Title__c);
		} 
		for(ServiceContract sContract:scontractList){
			List<NCP_MyEntitlementProductAccess_Wrapper> prEntitlements = NCP_Entitlements.getMyEntitlmentProducts(contractId);  
			List<String> srEntitlements = new List<String>();//getServiceDetails(contractId);
			for(String service:getServiceDetails(contractId)){
	if(!srEntitlements.contains(mapServiceTitle.get(service))){
		srEntitlements.add(mapServiceTitle.get(service));
	}
			}
			NCP_MyEntitlements_Wrapper myEntitlements = new NCP_MyEntitlements_Wrapper(sContract,prEntitlements,srEntitlements);	
			listMyEntitlements.add(myEntitlements);
		}
		return listMyEntitlements;
	}
	/*
	* @description   gets all entitlements to avoid soql queries  
	* @return		wrapper list for service contract and it's related products and services	
	*/
	@AuraEnabled
	public static List<NCP_MyEntitlements_Wrapper> getAllMyEntitlements(){		
		
		Map<String,String> mapServiceTitle = new Map<String,String>();
		List<NCP_MyEntitlements_Wrapper> listMyEntitlements = new List<NCP_MyEntitlements_Wrapper>();
		
		for(NCP_Service_Tile__mdt tile : [SELECT NCP_Entitlement_Access_Type__c,NCP_Title__c FROM NCP_Service_Tile__mdt]){
			mapServiceTitle.put(tile.NCP_Entitlement_Access_Type__c,tile.NCP_Title__c);
		} 
		//system.debug('### AES mapServiceTitle '+mapServiceTitle); 
  
		if(NCP_Utils.isUserAuthenticated() && !NCP_Utils.isInternalUser()){
			Set<Id> accountIdSet = NCP_Entitlements.getAccountIds(); 
			//system.debug('### AES accountIdSet '+accountIdSet);  
			Map<Id,ServiceContract> mapSC = new Map<Id,ServiceContract>();
			Map<Id,List<NCP_MyEntitlementProductAccess_Wrapper>> mapSCProductAccess = NCP_Entitlements.getEntitledProductMap(accountIdSet, null);
			Map<Id,Set<String>> mapSCServiceAccess = NCP_Entitlements.getEntitledServices(accountIdSet,null);
			Set<Id> scIds = new Set<Id>();
			//Set<ServiceContract> scListView = new Set<ServiceContract>();
			for(ServiceContract sc:getContractsInfo(null)){
	mapSC.put(sc.Id,sc);
	scIds.add(sc.Id);
			}
			//system.debug('### AES scIds '+scIds);	
			for(Id contractId:scIds){
	List<NCP_MyEntitlementProductAccess_Wrapper> prEntitlements = mapSCProductAccess.get(contractId);
	List<String> srEntitlements = new List<String>();
	if(mapSCServiceAccess.get(contractId) != null){
			for(String service:mapSCServiceAccess.get(contractId)){
	srEntitlements.add(mapServiceTitle.get(service));
			}
	}
	if(prEntitlements != null || !srEntitlements.isEmpty()){ 
		//scListView.add(mapSC.get(contractId));	
		NCP_MyEntitlements_Wrapper myEntitlements = new NCP_MyEntitlements_Wrapper(mapSC.get(contractId),prEntitlements,srEntitlements);	
		listMyEntitlements.add(myEntitlements);
	}
			}
		}
		system.debug('### AES listMyEntitlements '+listMyEntitlements);
		return listMyEntitlements;
	}
	/*
	* @description   gets the list views list	 
	* @return		list of the list view		 
	*/
	@AuraEnabled
	public static List<NCP_MyListView_Wrapper> getListViews(List<String> scIds){

		//system.debug('### AES scIds '+scIds);
		// get all service contract related to the user	  
		List<NCP_MyListView_Wrapper> records = new List<NCP_MyListView_Wrapper>();
		if(NCP_Utils.isUserAuthenticated()){
			NCP_MyListView_Wrapper defaultView = new NCP_MyListView_Wrapper();
			defaultView.Name = 'All Contracts';
			records.add(defaultView);
			for(ServiceContract sc : [Select Id,Name,Account.Name From ServiceContract Where Id =:scIds and NCP_External_Status__c = :NCP_Constants.STATUS_ACTIVE]){
	NCP_MyListView_Wrapper view = new NCP_MyListView_Wrapper();
	view.Id = sc.Id;
	view.Name = sc.Name;
	view.AccountName = sc.Account.Name;
	records.add(view);
			}   
		} 
		//system.debug('### AES ABO records '+records);
		return records;
	}
	/*
	* @description   gets  Parent contract fields	 
	* @return		Object  of Parent contract fields	
	*/
	public static List<ServiceContract> getContractsInfo(Id contractId){
		
		List<ServiceContract> sc = new List<ServiceContract>();
		Set<Id> contractIds = new Set<Id>();

		if(!String.isBlank(contractId)){
			sc = [Select Id,Name,NCP_External_Status__c,EndDate,StartDate,ContractNumber,Account.Name,NCP_Contract_Type__c from ServiceContract Where Id =: contractId];		
		}else{
			/*for(ServiceContract sContract : NCP_Entitlements.getMyParentServiceContract()){
	contractIds.add(sContract.Id);
			}*/
			sc = NCP_Entitlements.getMyParentServiceContract();
			//sc = [Select Id,Name,NCP_External_Status__c,EndDate,StartDate,ContractNumber,Account.Name,NCP_Contract_Type__c from ServiceContract Where Id IN:contractIds and NCP_External_Status__c = 'Active']; 
		}
		return sc;
	} 

	/*
	* @description   gets service details	 
	* @return		Object of service details		 
	*/
	@AuraEnabled
	public static List<String> getServiceDetails(Id contractId){
		system.debug('### AES get service detail *********');
		List<String> accessList  = new List<String>();
		Set<String> selectedServices = NCP_Entitlements.searchAllServices(contractId);
		
		if(selectedServices != null) accessList.addAll(selectedServices);
		/*Set<String> CDBaccess = NCP_Entitlements.SearchEntitlementsCDB(null,contractId).get(null);
		Set<String> CARESaccess = NCP_Entitlements.SearchEntitlementsCares(null,contractId).get(null);		
		if(CDBaccess != null) accessList.add(CDBaccess);
		if(CARESaccess != null) accessList.add(CARESaccess);*/
		return accessList;
	}
	
	/*
	* @description   load Favorite products	 
	* @return		Object of Favorite products		 
	*/
	@AuraEnabled
	public static List<Object> loadFavoriteProducts(){
		return NCP_Entitlements.getFavoriteProducts(); 
	}  
}