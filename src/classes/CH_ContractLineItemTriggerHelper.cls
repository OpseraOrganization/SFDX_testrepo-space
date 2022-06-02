/****************************************
* Class Name : CH_ContractLineItemTriggerHelper 
* Created Date: 02 September 2018
* Created By : TCS
* Last Modified by: Sónia Reis
* Last Modified Date: 09 October 2019
* Description : Contains common business logic
* Test Class: CH_ContractLineItemTriggerTest
*****************************************/
public without sharing class CH_ContractLineItemTriggerHelper {
	/********************
* Method Name: updateLookupIds
* Parameter: ContractLineItem
* Description: Used to update lookup fields Id coming from Interface/CDB/CARES
* Reference: NOKIASC-10907
*******************/
	public static void updateLookupIds(Map < Id, ContractLineItem > oldLineItemMap, List < ContractLineItem > newLineItemList) {
		if(newLineItemList != null && !newLineItemList.isEmpty()) {
			List < ContractLineItem > lineItemList = new List < ContractLineItem > ();
			for(ContractLineItem lineItemObj: newLineItemList) {
				if(oldLineItemMap.get(lineItemObj.Id) != null) {
					ContractLineItem oldLineItemObj = oldLineItemMap.get(lineItemObj.Id);
					if(oldLineItemObj.CH_BusinessHourName__c != lineItemObj.CH_BusinessHourName__c || 
					   oldLineItemObj.CH_CDB_EntitlementId__c != lineItemObj.CH_CDB_EntitlementId__c) {
						   lineItemList.add(lineItemObj);
					   }
				}
			}
			
			if(!lineItemList.isEmpty()) {
				populateLookupIds(lineItemList);
			}
		}
	}
	
	/********************
* Method Name: populateLookupIds
* Parameter: ContractLineItem
* Description: Used to set lookup fields Id coming from Interface/CDB/CARES
* Reference: NOKIASC-10907
*******************/
	public static void populateLookupIds(List < ContractLineItem > newLineItemList) {
		if(newLineItemList != null && !newLineItemList.isEmpty()) {
			Set < String > businessHourNames = new Set < String > ();
			Set < String > pricebookEntryNames = new Set < String > ();
			Set < String > entitlementNames = new Set < String > ();
			for(ContractLineItem lineItemObj: newLineItemList) {
				businessHourNames.add(lineItemObj.CH_BusinessHourName__c);
				pricebookEntryNames.add(lineItemObj.CH_PriceBookEntry__c);
				if(lineItemObj.CH_CDB_EntitlementId__c!=null)
					entitlementNames.add(lineItemObj.CH_CDB_EntitlementId__c);
			}
			// Get all BusinessHours by its Name
			Map < String, Id > businessHourMap = new Map < String, Id > (); 
			if(!businessHourNames.isEmpty()) {
				for(BusinessHours businessHourObj: [SELECT Id, Name FROM BusinessHours WHERE Name IN :businessHourNames]) {
					businessHourMap.put(businessHourObj.Name, businessHourObj.Id);
				}   
			}
			// Get all PricebookEntry by its Name
			Map < String, Id > pricebookEntryMap = new Map < String, Id > (); 
			if(!pricebookEntryNames.isEmpty()) {
				for(PricebookEntry pricebookEntryObj: [SELECT Id, NCP_External_ID__c FROM PricebookEntry WHERE Name IN :pricebookEntryNames]) {
					pricebookEntryMap.put(pricebookEntryObj.NCP_External_ID__c, pricebookEntryObj.Id);
				}   
			}
			// Get all Entitlement by its External Id
			Map < String, Id > entitlementMap = new Map < String, Id > (); 
			if(!entitlementNames.isEmpty()) {
				for(Entitlement entObj: [SELECT Id, CH_CDB_EntitlementId__c FROM Entitlement WHERE CH_CDB_EntitlementId__c IN :entitlementNames]) {
					entitlementMap.put(entObj.CH_CDB_EntitlementId__c, entObj.Id);
				}   
			}
			// Iterate newLineItemList againt to set lookup fields Id
			for(ContractLineItem lineItemObj: newLineItemList) {
				if(businessHourMap.containsKey(lineItemObj.CH_BusinessHourName__c)) {
					lineItemObj.CH_BusinessHour__c = businessHourMap.get(lineItemObj.CH_BusinessHourName__c);
				} 
				if(pricebookEntryMap.containsKey(lineItemObj.CH_PriceBookEntry__c)) {
					lineItemObj.PricebookEntryId = pricebookEntryMap.get(lineItemObj.CH_PriceBookEntry__c);
				}
				if(entitlementMap.containsKey(lineItemObj.CH_CDB_EntitlementId__c)) {
					lineItemObj.CH_Entitlement__c = entitlementMap.get(lineItemObj.CH_CDB_EntitlementId__c);
				} 
			}
		}
	}
	
	/********************
* Method Name: matchCountryName
* Parameter: ContractLineItem
* Description: Used to to populate Country Name by Country Code
* Reference: NOKIASC-23472
*******************/
	public static void populateCountryName(List <ContractLineItem> newLineItemList){
		if(!newLineItemList.isEmpty()){   
			List<ISO_Country_Codes__c> isoCodes =  [select id, name, country_name__c from ISO_Country_Codes__c]; 
			Map<String, String> codeToNameMap = new Map<String, String>();
			for(ISO_Country_Codes__c code :isoCodes){
				codeToNameMap.put(code.name, code.country_name__c);
			}
			
			for(ContractLineItem cli : newLineItemList){
				String countryCode = cli.CH_CountryISO2__c;
				if(!String.isBlank(countryCode)){
					String countryCodeUpperCase = countryCode.toUpperCase();
					if(codeToNameMap.containsKey(countryCodeUpperCase)){
						cli.CH_CountryISOName__c=codeToNameMap.get(countryCodeUpperCase);
						cli.CH_CountryISO2__c=countryCodeUpperCase; 
					}
				}
			}
		}	 
	}
	
	public static void linkToVendorContract(Map < Id, ContractLineItem > oldLineItemMap, List <ContractLineItem> newLineItemList) {
		map<string, set<String>> mappreviousEntCLI = new map<string,  set<String>>();
		List<CH_CoveredVendorContract__c> insertCoveredVendorContract = new List<CH_CoveredVendorContract__c> ();
		for(ContractLineItem lineItemId:newLineItemList)
		{
			set<String> cliId = new set<string>();
			If(lineItemId.CH_PreviousCDBEntitlementId__c!= NULL  ){
				
				if(mappreviousEntCLI!=null && mappreviousEntCLI.containsKey(lineItemId.CH_PreviousCDBEntitlementId__c)){
					cliId = mappreviousEntCLI.get(lineItemId.CH_PreviousCDBEntitlementId__c);
				}
				cliId.add(lineItemId.Id);
				mappreviousEntCLI.put(lineItemId.CH_PreviousCDBEntitlementId__c,cliId);
			}
		}
		
		if(!mappreviousEntCLI.isEmpty()){
			List<CH_CoveredVendorContract__c> objCoveredVendorContractList =[select id,CH_ContractLineItem__c,CH_VendorContract__c, CH_ContractLineItem__r.CH_CDB_EntitlementId__c  from CH_CoveredVendorContract__c where CH_ContractLineItem__r.CH_CDB_EntitlementId__c in :mappreviousEntCLI.keySet() ];
			if(!objCoveredVendorContractList.isemPty()){
				for(CH_CoveredVendorContract__c objVendor : objCoveredVendorContractList){
					
					for(String cli  : mappreviousEntCLI.get(objVendor.CH_ContractLineItem__r.CH_CDB_EntitlementId__c)){
						CH_CoveredVendorContract__c objCoveredVendorContract = new CH_CoveredVendorContract__c();
						objCoveredVendorContract.CH_ContractLineItem__c = cli;
						objCoveredVendorContract.CH_VendorContract__c = objVendor.CH_VendorContract__c;
						insertCoveredVendorContract.add(objCoveredVendorContract);
					}
				}
				
			}
			if(!objCoveredVendorContractList.isEmpty()){
				
				insert insertCoveredVendorContract;
			}
		}
		
	}
	
	/********************
* Method Name: getListCHAndSupportServiceContracts
* Parameter: ContractLineItem
* Description: Used to get Map of Contract Line Items based on CDB and CARES
* Reference: NOKIASC-35064
* Created By: Gopi Krishna
*******************/
	public static List<ContractLineItem> getListCHAndSupportServiceContracts(List<ContractLineItem> listCLI, String cliType){
		List<ContractLineItem> cliList = new List<ContractLineItem>();
		Set<Id> serviceContractIds = new Set<Id>();
		Set<Id> serviceContractIdsForSP = new Set<Id>();
		
		if(cliType == 'Support Portal'){
			for(ContractLineItem cli : listCLI){
				serviceContractIds.add(cli.ServiceContractId);
			}
			for(ServiceContract sc  : [SELECT Id, RecordType.DeveloperName FROM ServiceContract WHERE Id IN :serviceContractIds AND (RecordType.DeveloperName = 'NCP_Parent_Service_Contract' OR RecordType.DeveloperName = 'NCP_Child_Service_Contract')]){
				serviceContractIdsForSP.add(sc.Id);
			}
		}
		
		if(!listCLI.isEmpty()){
			
			for(ContractLineItem conLineItem : listCLI){	 
				if(cliType == 'Cares' && conLineItem.CH_CDB_EntitlementId__c != null && conLineItem.CH_CDB_EntitlementId__c != ''){
					cliList.add(conLineItem);
				}
				if(cliType == 'Support Portal' && serviceContractIdsForSP.contains(conLineItem.ServiceContractId)){//for Support Portal
					cliList.add(conLineItem);
				}
			}
		}
		return cliList;
	}
	
	
	
}