/****************************************
 * Class Name : CH_EntitlementTriggerHelper 
 * Created Date: 25 September 2018
 * Created By : TCS
 * Last Modified by: TCS
 * Last Modified Date: 25 September 2018
 * Description : Handle the sequence of the CH_EntitlementTriggerHelper
 * Test Class: CH_EntitlementTriggerHelperTest 
 ************/
public without sharing class CH_EntitlementTriggerHelper {
	public static Boolean recursive=false;

	/********************
	* Method Name: updateCustomerSpecificTargetSLA
	* Parameter: Map<Id, Entitlement>, List <Entitlement>
	* Description: Deactivated SLAs that are linked to deactivated entitlements
	* Reference: NOKIASC-38521
	*******************/
	public static void updateCustomerSpecificTargetSLA(Map<Id, Entitlement> oldEntitlementMap, List<Entitlement> newEntitlementList){
		if(!newEntitlementList.isEmpty()){
			Set<Id> entitlementIds = new Set<Id>();
			Set<Id> slaIds = new Set<Id>();
			for(Entitlement ent: newEntitlementList) {
	if(ent.Status == 'Expired' && oldEntitlementMap.get(ent.Id).Status == 'Active'){
		entitlementIds.add(ent.Id);
	}
			}
			if(!entitlementIds.isEmpty()){
	for(CH_CustomerSpecificTargetSLA__c sla : [SELECT Id, CH_SLARecordStatus__c, CH_Entitlement__c FROM CH_CustomerSpecificTargetSLA__c WHERE CH_Entitlement__c IN :entitlementIds]){
		if(sla.CH_SLARecordStatus__c == 'Active'){
			slaIds.add(sla.Id);
		}
	}
	if(!slaIds.isEmpty()){
		inactivateSLAs(slaIds);
	}
			}
		}
	}
	
	@future
	private static void inactivateSLAs(Set<Id> slaIds){
		if(!slaIds.isEmpty()){
			List<CH_CustomerSpecificTargetSLA__c> oSLAtoUpdate = new List<CH_CustomerSpecificTargetSLA__c>();
			for(CH_CustomerSpecificTargetSLA__c sla : [SELECT Id, CH_SLARecordStatus__c FROM CH_CustomerSpecificTargetSLA__c WHERE Id IN :slaIds]){
	sla.CH_SLARecordStatus__c = 'Inactive';
	oSLAtoUpdate.add(sla);
			}
			if(!oSLAtoUpdate.isEmpty()){
	update oSLAtoUpdate;
			}
		}
	}
	
	/********************
	* Method Name: populateSLAProcessId
	* Parameter: List < Entitlement >
	* Description: Used to populate SLA Id based on Service Mapping Id
	* Reference: NOKIASC-13109
	*******************/
	public static void populateSLAProcessIds(List < Entitlement > newEntitlementList) {
		if(newEntitlementList != null && !newEntitlementList.isEmpty()) {
			Set < String > slaProcessNames = new Set < String > ();
			Set < String > contractLineItemExtIds = new Set < String > ();
			for(Entitlement entObj: newEntitlementList) {
	slaProcessNames.add(entObj.CH_ServiceMappingId__c);
	contractLineItemExtIds.add(entObj.CH_CDB_EntitlementId__c);
			}
			
			// Query to get relevant EntitlementProcess as per provided CH_ServiceMappingId__c
			Map < String, Id > slaProcessNameMap = new Map < String, Id > ();
			if(!slaProcessNames.isEmpty()) {
	List < SLAProcess > slaProcessList = [SELECT Id, Name FROM SLAProcess WHERE Name IN :slaProcessNames AND SobjectType = 'Case' AND IsVersionDefault = true AND IsActive = true];
	if(slaProcessList != null && !slaProcessList.isEmpty()) {
		for(SLAProcess slaObj: slaProcessList) {
			slaProcessNameMap.put(slaObj.Name, slaObj.Id);
		}
	}   
			}
			
			// Query to get relevant ContractLineItem records as per provided CH_CDB_EntitlementId__c
			Map < String, ContractLineItem > contractLineItemExtMap = new Map < String, ContractLineItem > ();
			if(!contractLineItemExtIds.isEmpty()) {
	List < ContractLineItem > cliList = [SELECT Id, CH_ServiceOffering__c, CH_CDB_EntitlementId__c FROM ContractLineItem WHERE CH_CDB_EntitlementId__c IN :contractLineItemExtIds];
	if(cliList != null && !cliList.isEmpty()) {
		for(ContractLineItem cliObj: cliList) {
			contractLineItemExtMap.put(cliObj.CH_CDB_EntitlementId__c, cliObj);
		}
	}
			}
			
			if(!slaProcessNameMap.isEmpty() || !contractLineItemExtMap.isEmpty()) {
	for(Entitlement entObj: newEntitlementList) {
		// Set EntitlementProcess 
		if(slaProcessNameMap.containsKey(entObj.CH_ServiceMappingId__c)) {
			entObj.SLAProcessId = slaProcessNameMap.get(entObj.CH_ServiceMappingId__c);
		}
		// Set CLI Reference and CH_ServiceOffering__c from ContractLineItem
		if(contractLineItemExtMap.containsKey(entObj.CH_CDB_EntitlementId__c)) {
			ContractLineItem tempObj = contractLineItemExtMap.get(entObj.CH_CDB_EntitlementId__c);
			entObj.ContractLineItemId = tempObj.Id;
			if(entObj.CH_EntitlementType__c == 'Entitled Asset' && String.isNotBlank(tempObj.CH_ServiceOffering__c)) {
				entObj.Name = tempObj.CH_ServiceOffering__c;
			}
		}
	}
			}
		}
	}
	
	
	/********************
	* Method Name: updateSLAProcessId
	* Parameter: Map < Id, Entitlement >, List < Entitlement >
	* Description: Used to populate SLA Id based on Service Mapping Id
	* Reference: NOKIASC-13109
	* Last Modified by: Gopi Krishna for US 34705
	* Description: Update the CDB ID as Old and Insert the new Entitlement with Old values 
	*******************/
	public static void updateSLAProcessIds(Map<Id, Entitlement> oldEntitlementMap, Map<Id, Entitlement> newEntitlementMap, List <Entitlement> newEntitlementList) {
	  if(!recursive){
	recursive = true;	  
		set<Id> entIds = new set<Id>();   
		List<Entitlement> cloneEntList = new List<Entitlement>();	
		if(newEntitlementList != null && !newEntitlementList.isEmpty()) {
			List < Entitlement > entList = new List < Entitlement > ();
			for(Entitlement entObj: newEntitlementList) {
	
	if(oldEntitlementMap.get(entObj.Id) != null) {
		Entitlement oldEntObj = oldEntitlementMap.get(entObj.Id);
		
		if(oldEntObj.CH_ServiceMappingId__c != entObj.CH_ServiceMappingId__c || 
			oldEntObj.CH_CDB_EntitlementId__c != entObj.CH_CDB_EntitlementId__c) {
			entList.add(entObj);
		}
		 // 34705 
		if(oldEntObj.CH_ServiceMappingId__c != entObj.CH_ServiceMappingId__c) {
		  entIds.add(entObj.Id);}		
	  } 
	}
		 // 34705 changes Start   
			String entQuery = getCreatableFieldsSOQL('Entitlement','id =: entIds');
			if(!entIds.isEmpty()){ 
	 for(Entitlement ent: Database.query(entQuery)){   
	 Entitlement entClone = ent.clone(false,false,false,false);
	 entClone.CH_ServiceMappingId__c = newEntitlementMap.get(ent.Id).CH_ServiceMappingId__c;
	 cloneEntList.add(entClone);
			}
	}
	  
		 if(!cloneEntList.isEmpty())	
	  insert cloneEntList;
	 
	 // To Update the CDB and EndDate
		if(!newEntitlementMap.isEmpty() && !entIds.isEmpty()){	
	for(Entitlement entMap : newEntitlementMap.values()){
	  if(entIds.contains(entMap.Id)){
	 entMap.CH_CDB_EntitlementId__c = entMap.CH_CDB_EntitlementId__c+'_old';
	 entMap.CH_ServiceMappingId__c = oldEntitlementMap.get(entMap.id).CH_ServiceMappingId__c;
	 entMap.EndDate = system.today()-1;
			}
		} 
	 } 
	// 34705 changes End 
			// Check if entList has any records or not to process
			if(!entList.isEmpty()) {
	populateSLAProcessIds(entList);
			}
		 }	 
	}
   } 
	
	/********************
	* Method Name: updateContractLineItemRecordsOnInsert
	* Parameter: List < Entitlement >
	* Description: Used to update contract line records with CH_Entitlement__c reference
	* Reference: NOKIASC-13231
	*******************/
	public static void updateContractLineItemRecordsOnInsert(List<Entitlement> newEntitlementList) {
		if(newEntitlementList != null && !newEntitlementList.isEmpty()) {
			Map < String, Id > entitlementExtMap = new Map < String, Id > ();
			Map<Id, Entitlement> entitlementConMap = new Map<Id, Entitlement>();
			for(Entitlement entObj: newEntitlementList) {
	if(String.isNotBlank(entObj.CH_CDB_EntitlementId__c)) {
		entitlementExtMap.put(entObj.CH_CDB_EntitlementId__c, entObj.Id);
		entitlementConMap.put(entObj.Id,entObj);   
	}
			}
	 List<ContractLineItem> conLineItemList = new list<ContractLineItem>(); 
			if(!entitlementExtMap.isEmpty()) {
	List < ContractLineItem > cliList = [SELECT Id, CH_Entitlement__c, CH_CDB_EntitlementId__c,CH_ServiceMappingId__c FROM ContractLineItem WHERE CH_CDB_EntitlementId__c IN :entitlementExtMap.keySet()];
	
	if(cliList != null && !cliList.isEmpty()) {
		for(ContractLineItem cliObj: cliList) {
			if(entitlementExtMap.containsKey(cliObj.CH_CDB_EntitlementId__c)) {
				cliObj.CH_Entitlement__c = entitlementExtMap.get(cliObj.CH_CDB_EntitlementId__c);
		}
		
		}
		// Update ContractLineItem List
		try {
			update cliList;
		} catch(Exception ex) {
			System.debug('#### ' + ex.getMessage());
		}
	}
			}
			if(!entitlementConMap.isEmpty()) {
			List < ContractLineItem > cliList = [SELECT Id, CH_Entitlement__c, CH_CDB_EntitlementId__c,CH_ServiceMappingId__c FROM ContractLineItem WHERE CH_Entitlement__c IN :entitlementConMap.keySet()];
	  if(cliList != null && !cliList.isEmpty()) {
		for(ContractLineItem cliObj: cliList) {
		
			if(entitlementConMap.containsKey(cliObj.CH_Entitlement__c)){
				cliObj.CH_ServiceMappingId__c = entitlementConMap.get(cliObj.CH_Entitlement__c).CH_ServiceMappingId__c;
				conLineItemList.add(cliObj);
			}
		}
	  try {
			update conLineItemList;
		} catch(Exception ex) {
			System.debug('#### ' + ex.getMessage());
		}
	}
			}
		}
	} 
	
	/********************
	* Method Name: updateContractLineItemRecordsOnUpdate
	* Parameter: Map < Id, Entitlement >, List < Entitlement >
	* Description: Used to update contract line records with CH_Entitlement__c reference
	* Reference: NOKIASC-13231
	*******************/
	public static void updateContractLineItemRecordsOnUpdate(Map < Id, Entitlement > oldEntitlementMap, List < Entitlement > newEntitlementList) {
		if(newEntitlementList != null && !newEntitlementList.isEmpty()) {
			List < Entitlement > entList = new List < Entitlement > ();
			for(Entitlement entObj: newEntitlementList) {
	if(oldEntitlementMap.get(entObj.Id) != null) {
		Entitlement oldEntObj = oldEntitlementMap.get(entObj.Id);
		if(oldEntObj.CH_CDB_EntitlementId__c != entObj.CH_CDB_EntitlementId__c) {
			entList.add(entObj);
		}
	}
			}
			// Check if entList has any records or not to process
			if(!entList.isEmpty()) {
	updateContractLineItemRecordsOnInsert(entList);
			}
		}   
	}
	
	/********************
	*Method Name: getCreatableFieldsSOQL
	*Description: Used to get all the creatable fields of Entitlement and return to UpsertEntitlement for US-34017
	*******************/
	public static string getCreatableFieldsSOQL(String objectName, String whereClause){
		String fields = '';
		 
		if (whereClause== null || whereClause == '' ){ 
			return null; 
		}
		 
		// Get a map of field name and field token
		Map<String, Schema.SObjectField> fieldsMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
		list<string> selectFields = new list<string>();
		 
		if (!fieldsMap.isEmpty()){
			for (Schema.SObjectField ft : fieldsMap.values()){ // loop through all field tokens (ft)
	Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
	if (fd.isCreateable()){ // field is creatable
		selectFields.add(fd.getName());
	}
			}
		}
		 
		if (!selectFields.isEmpty()){
			for (string s:selectFields){
	fields += s + ',';
			}
			if (fields.endsWith(',')){fields = fields.substring(0,fields.lastIndexOf(','));} 
		}
		return 'SELECT ' + fields + ' FROM ' + objectName + ' WHERE ' + whereClause; 
	}
}