/****************************************
* Class Name : CH_AssetTriggerHelper 
* Created Date: 25 September 2018
* Created By : TCS
* Last Modified by: Sónia Reis
* Last Modified Date: 09 October 2019
* Description : Handle the sequence of the CH_AssetTriggerHelper
* Test Class: CH_AssetTriggerHelperTest 
************/
public without sharing class CH_AssetTriggerHelper {
	/********************
* Method Name: populateSLAProcessId
* Parameter: List < Asset >
* Description: Used to populate Asset Name
* Reference: NOKIASC-
*******************/
	public static void populateAssetName(List < Asset > newAssetList) {
		if(newAssetList != null && !newAssetList.isEmpty()) {
			Map < ID, Schema.RecordTypeInfo > rtMap = Schema.SObjectType.Asset.getRecordTypeInfosById();
			Set < Id > productIds = new Set < Id > ();
			Set < Id > productReleaseIds = new Set < Id > ();
			for(Asset assetObj: newAssetList) {
	if(rtMap.get(assetObj.RecordTypeId).getName()!= 'Network Element Asset'){
		productIds.add(assetObj.Product2Id);
		productIds.add(assetObj.CH_ProductVariant__c);
		productIds.add(assetObj.CH_Solution__c);
		productReleaseIds.add(assetObj.CH_ProductRelease__c);	
	}
			}
			
			Map < Id, Product2 > productMap = new Map < Id, Product2 > ( [SELECT Id, Name FROM Product2 WHERE Id IN :productIds] );
			Map < Id, CH_ProductRelease__c > productReleaseMap = new Map < Id, CH_ProductRelease__c > ([SELECT Id, Name FROM CH_ProductRelease__c WHERE Id IN :productReleaseIds]);
		
			for(Asset assetObj: newAssetList) {
	If ( rtMap.get(assetObj.RecordTypeId).getName() == 'Network Element Asset')
	{
		//assetObjRecType.Name = assetObjRecType.CH_NetworkElementID__c;
		// ** Will not perform any action as of now *****	
	}
	else{
		String assetName = ''; 
		// Product Name
		if(productMap.containsKey(assetObj.Product2Id)) {
			assetName = assetName + productMap.get(assetObj.Product2Id).Name + ' | '; 
		} else {
			assetName = assetName + '' + ' | '; 
		}
		// Solution Name
		if(productMap.containsKey(assetObj.CH_Solution__c)) {
			assetName = assetName + productMap.get(assetObj.CH_Solution__c).Name + ' | ';
		} else {
			assetName = assetName + '' + ' | '; 
		}  
		// Product Variant Name
		if(productMap.containsKey(assetObj.CH_ProductVariant__c)) {
			assetName = assetName + productMap.get(assetObj.CH_ProductVariant__c).Name + ' | ';
		} else {
			assetName = assetName + '' + ' | '; 
		} 
		// Product Release Name
		if(productReleaseMap.containsKey(assetObj.CH_ProductRelease__c)) {
			assetName = assetName + productReleaseMap.get(assetObj.CH_ProductRelease__c).Name + ' | ';	
		} else {
			assetName = assetName + '' + ' | '; 
		}	
		// County Code (ISO 2)
		if(String.isNotBlank(assetObj.CH_CountryISOName__c)) {
			assetName = assetName + assetObj.CH_CountryISOName__c;
		} else {
			assetName = assetName + ''; 
		}	
		// Check for assetName lenght to avoid exceeding maximum characater limit 
		if(assetName.length() > 255) {
			assetName = assetName.abbreviate(255);
		}
		// Set Asset Name
		assetObj.Name = assetName;		
	}	
			}
		}
	}
   
/************	
/*Suniti-24960 & 24961 //method before insert*/
/* Method Name: CheckDuplicateBeforeInsert
* Description: Used to check duplicate before insert in Asset and display error
* Reference: NOKIASC-24960 & 24961
*******************/
/* Commenting below code for breaking uniqueness of existing functinality as per NOKIASC-36188
 public static void CheckDuplicateBeforeInsert(List < Asset > newAssetList,String action) {
		Id neaRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Network Element Asset').getRecordTypeId();
		if(newAssetList != null && !newAssetList.isEmpty() && newAssetList.size() > 1){
			for(Asset objNEA: newAssetList){
	system.debug(' newAssetList -->'+ objNEA.CH_NetworkElementID__c);
	string NEID = objNEA.CH_NetworkElementID__c;
	if(NEID ==null){
		system.debug(' NewAssetList Null');
		NEID = objNEA.Name;
	}
	 if (neaRecordTypeId == objNEA.RecordTypeId   && objNEA.Status=='Active'){
		 String assetUniqueName =objNEA.Product2Id+'-'+objNEA.AccountId+'-'+objNEA.Name+'-'+objNEA.Status;
		 String neaUniqueName = NEID+'-'+objNEA.Product2Id+'-'+objNEA.CH_ProductVariant__c+'-'+objNEA.Status;
		 objNEA.CH_AssetNameUniqueKey__c= assetUniqueName;
		 objNEA.CH_NetworkElementIDUniqueKey__c=neaUniqueName;
		 
	 }else  if (neaRecordTypeId == objNEA.RecordTypeId   && objNEA.Status=='Inactive'){
		 String assetUniqueName =objNEA.Product2Id+'-'+objNEA.AccountId+'-'+objNEA.Name+'-'+objNEA.Status+'-'+objNEA.Id;
		 String neaUniqueName = NEID+'-'+objNEA.Product2Id+'-'+objNEA.CH_ProductVariant__c+'-'+objNEA.Status+'-'+objNEA.Id;
		 objNEA.CH_AssetNameUniqueKey__c= null;
		 objNEA.CH_NetworkElementIDUniqueKey__c=null;
	 }
	  
			}
			
		}
		else if(newAssetList != null && !newAssetList.isEmpty() ) {
			System.debug('Size is one UI -->');
			set<String> assetName_UniqueKey = new set<string>();
			set<String> networkID_UniqueKey = new set<string>();
			set<string> existingAssetName = new set<string>();
			set<string> existingNEId = new set<string>();
			set<string> existingNEId2 = new set<string>();
			set<String>assetId = new set<String>();
			
			for(Asset objNEA: newAssetList){
	string NEID = objNEA.CH_NetworkElementID__c;
	if(NEID ==null){
		NEID = objNEA.Name; 
	}
	if (neaRecordTypeId == objNEA.RecordTypeId  && objNEA.Status =='Active'){ 
		assetName_UniqueKey.add(objNEA.Product2Id+'-'+objNEA.AccountId+'-'+objNEA.Name+'-'+objNEA.Status);
		networkID_UniqueKey.add(NEID+'-'+objNEA.Product2Id+'-'+objNEA.CH_ProductVariant__c+'-'+objNEA.Status);
		
		if(action == 'update'){
			assetId.add(objNEA.Id);
			//system.debug(assetId);
		}	
	} 
			}
			for(Asset oASset : [SELECT Id,Product2Id,AccountId,Name,CH_NetworkElementID__c,CH_ProductVariant__c,Status  FROM Asset 
		Where  RecordTypeId= :neaRecordTypeId
		and (CH_AssetNameUniqueKey__c IN :assetName_UniqueKey  OR CH_NetworkElementIDUniqueKey__c in:  networkID_UniqueKey) ]){
			
			if(assetID ==null || !assetID.contains(oASset.Id) ){
	existingAssetName.add((oASset.Product2Id+'-'+oASset.AccountId+'-'+oASset.Name+'-'+oASset.Status).toLowerCase());
	
	existingNEId.add((oASset.CH_NetworkElementID__c+'-'+oASset.Product2Id+'-'+oASset.CH_ProductVariant__c+'-'+oASset.Status).toLowerCase()); 
	
	existingNEId2.add((oASset.Name+'-'+oASset.Product2Id+'-'+oASset.CH_ProductVariant__c+'-'+oASset.Status).toLowerCase()); 
			}
		}
			
			for(Asset objNEA: newAssetList){
	string NEID = objNEA.CH_NetworkElementID__c;
	system.debug('SunitiInitialError');
	if(NEID ==null){
		NEID = objNEA.Name;
	}
	String assetUniqueName =objNEA.Product2Id+'-'+objNEA.AccountId+'-'+objNEA.Name+'-'+objNEA.Status;
	String neaUniqueName = NEID+'-'+objNEA.Product2Id+'-'+objNEA.CH_ProductVariant__c+'-'+objNEA.Status;
	string neaUniqueName2 = objNEA.Name+'-'+objNEA.Product2Id+'-'+objNEA.CH_ProductVariant__c+'-'+objNEA.Status;
	Boolean isError = false;
	String ErrorMessgae ='';
	
	if(neaRecordTypeId == objNEA.RecordTypeId){
		if(objNEA.Status =='Inactive'){
			assetUniqueName = null;//assetUniqueName+'-'+objNEA.Id;
			neaUniqueName = null;//neaUniqueName+'-'+objNEA.Id;
			objNEA.CH_AssetNameUniqueKey__c= null;
	objNEA.CH_NetworkElementIDUniqueKey__c=null;
		}
		if( assetUniqueName !=null && (existingAssetName ==null || !existingAssetName.contains(assetUniqueName.toLowerCase())) ){
			system.debug(existingAssetName +'---'+assetUniqueName+'@@@@'+existingAssetName);
			String getTheLength=objNEA.CH_NetworkElementID__c+objNEA.CH_NetworkManagementSystemID__c;
						if(getTheLength.length()>=233 || neaUniqueName.length()>=254){
							objNEA.addError(System.Label.CH_Validate_NEID_NEMID_FieldLengths);
			}
			objNEA.CH_AssetNameUniqueKey__c= assetUniqueName;
		}else if(assetUniqueName !=null ){
			isError = true;
			ErrorMessgae = 'The Asset Name of Network Element Asset must be unique for a given Account and Product';
			
		}
		if(neaUniqueName !=null && ( existingNEId ==null || !existingNEId.contains(neaUniqueName.toLowerCase())) ){
			system.debug(existingNEId +'---'+neaUniqueName+'@@@@'+existingNEId);
			objNEA.CH_NetworkElementIDUniqueKey__c=neaUniqueName;
		}else if(neaUniqueName !=null){
			if(isError){
	ErrorMessgae = ErrorMessgae+' & The Network Element ID for a Network Element Asset must be unique for a given Product ';
			}else{
	isError = true;
	ErrorMessgae =  'The Network Element ID for a Network Element Asset must be unique for a given Product';
			}
		}
		if(isError){
			objNEA.addError(ErrorMessgae);
		}
		
	}
	 
			}
		}
	}
	*/
	
	
	
	/* Method Name: CheckDuplicateBeforeUpdate
* Description: Used to check duplicate before update in Asset and display error
* Reference: NOKIASC-24960 & 24961
*******************/
/* Commenting below code for breaking uniqueness of existing functinality as per NOKIASC-36188
	public static void CheckDuplicateBeforeUpdate(Map < Id, Asset > oldAssetMap, List < Asset > newAssetList) {
		List<ASset> newAssetListToUpdate = new List<Asset>();
		Id neaRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Network Element Asset').getRecordTypeId();
		for(Asset objNEA: newAssetList){
			if (neaRecordTypeId == objNEA.RecordTypeId){
	if((objNEA.CH_NetworkElementID__c != oldAssetMap.get(objNEA.ID).CH_NetworkElementID__c ) || (objNEA.Name != oldAssetMap.get(objNEA.ID).Name ) || (objNEA.Status !=oldAssetMap.get(objNEA.ID).Status)  ){
		newAssetListToUpdate.add(objNEA);
	}
			}
		}
		if(newAssetListToUpdate!=null && !newAssetListToUpdate.isempty()){
			system.debug('error5');
			CheckDuplicateBeforeInsert(newAssetList,'update'); 
		}
	} */
	/********************/  
	/*Part of NOKIASC-24960 and NOKIASC-24961:Suniti/ To check for unique key fields with inactive-null value
and replace the last null value with Asset record Id  */
	/* Commenting below code for breaking uniqueness of existing functinality as per NOKIASC-36188
	public static void UpdateNEA(List<Asset> newAssetList)
	{	  
		Id neaRecordType = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Network Element Asset').getRecordTypeId();
		set<string> existingNEAId = new set<string>();
		for(Asset newAsset: newAssetList){
			if(newAsset.RecordTypeId == neaRecordType && newAsset.Status== 'Inactive' && newAsset.CH_AssetNameUniqueKey__c !=null && newAsset.CH_NetworkElementIDUniqueKey__c !=null){
	system.debug('error6');
	if(newAsset.id != null)
		existingNEAId.add(newAsset.id);
	//System.debug(existingNEAId);
			} 
		}
		List<Asset> NEAList =  [SELECT Id, CH_AssetNameUniqueKey__c , CH_NetworkElementIDUniqueKey__c,Status FROM Asset where Id in : existingNEAId];
		//String NEAAllRecords =NEAList;
		if(NEAList != null && !NEAList.isEmpty() && NEAList.size() > 0){	
			for(Asset oAsset : NEAList) {
	oAsset.CH_ContractLineItem__c=null;
	if(oAsset.Status== 'Inactive' && oAsset.CH_AssetNameUniqueKey__c !=null && oAsset.CH_NetworkElementIDUniqueKey__c !=null) {
		system.debug('error7');
		String AssetUK = oAsset.CH_AssetNameUniqueKey__c;
		String NEUK = oAsset.CH_NetworkElementIDUniqueKey__c;
		System.debug('record3 '+oAsset.CH_AssetNameUniqueKey__c);
		System.debug('record4 '+oAsset.CH_NetworkElementIDUniqueKey__c);
		oAsset.CH_AssetNameUniqueKey__c=AssetUK.substring(0,AssetUK.length()-4)+oAsset.Id;
		oAsset.CH_NetworkElementIDUniqueKey__c=NEUK.substring(0,NEUK.length()-4)+oAsset.Id;
		System.debug('record1 '+oAsset.CH_AssetNameUniqueKey__c);
		System.debug('record2 '+oAsset.CH_NetworkElementIDUniqueKey__c);
	}}
			update NEAList;
		}} */
	
	
	
	/********************
* Method Name: updateSLAProcessId
* Parameter: List < Asset >
* Description: Used to update Asset Name
* Reference: NOKIASC-
*******************/
	public static void updateAssetName(Map < Id, Asset > oldAssetMap, List < Asset > newAssetList) {
	if(newAssetList != null && !newAssetList.isEmpty()) {
		Map < ID, Schema.RecordTypeInfo > rtMap = Schema.SObjectType.Asset.getRecordTypeInfosById();
		List < Asset > assetList = new List < Asset > ();
		for(Asset assetObj: newAssetList) {
			if(oldAssetMap.get(assetObj.Id) != null) {
	String type = rtMap.get(assetObj.RecordTypeId).getName();	 
	If ( type == 'Network Element Asset')
	{ 
		// ** Will not perform any action as of now *****	 
		
	}
	else {
		Asset oldAssetObj = oldAssetMap.get(assetObj.Id);
		if(oldAssetObj.Name != assetObj.Name || 
		oldAssetObj.Product2Id != assetObj.Product2Id || 
		oldAssetObj.CH_Solution__c != assetObj.CH_Solution__c || 
		oldAssetObj.CH_ProductVariant__c != assetObj.CH_ProductVariant__c || 
		oldAssetObj.CH_ProductRelease__c != assetObj.CH_ProductRelease__c || 
		oldAssetObj.CH_CountryISOName__c != assetObj.CH_CountryISOName__c
	) {
		assetList.add(assetObj);
	}
		
	}
			}			
		}
		// Check if assetList has any records or not to process
		if(!assetList.isEmpty()) {
			populateAssetName(assetList);
		}
	} 
}
	
	/********************
* Method Name: matchCountryName
* Parameter: ContractLineItem
* Description: Used to to populate Country Name by Country Code
* Reference: NOKIASC-23471
*******************/
	public static void populateCountryName(List <Asset> newAssetList)
	{
		List<ISO_Country_Codes__c> isoCodes =  [select id, name, country_name__c from ISO_Country_Codes__c]; 
		Map<String, String> codeToNameMap = new Map<String, String>();
		for(ISO_Country_Codes__c code :isoCodes){
			codeToNameMap.put(code.name, code.country_name__c);
		}
		for(Asset a : newAssetList){
			String countryCode = a.CH_CountryISO2__c;
			if(!String.isBlank(countryCode)){
	String countryCodeUpperCase = countryCode.toUpperCase();
	if(codeToNameMap.containsKey(countryCodeUpperCase)){
		a.CH_CountryISOName__c=codeToNameMap.get(countryCodeUpperCase);
		a.CH_CountryISO2__c=countryCodeUpperCase; //to pass all the codes to uppercase
	}
			}
		}
	}
	
	/********************
* Method Name: validationRules
* Parameter: Map < Id, Asset >,List <Asset>
* Description: Validation rules for country code and status cannot be changed if NEA admin permission set is not assigned.
* Reference: NOKIASC-24491
*******************/
	
	public static void validationRules(Map < Id, Asset > oldAssetMap, List < Asset > newAssetList){
		Map<Id,CH_CoveredNetworkElementAsset__c> cNEMap= new  Map<Id,CH_CoveredNetworkElementAsset__c>();
		List<CH_CoveredNetworkElementAsset__c> cNE = [SELECT Id,Name,CH_NetworkElementAsset__c,CH_ContractLineItem__c,CH_ContractLineItem__r.Status,CH_Status__c 
	  FROM CH_CoveredNetworkElementAsset__c 
	  WHERE CH_NetworkElementAsset__c=:oldAssetMap.Keyset()];
		List<PermissionSetAssignment> permissionSetList = [SELECT Id  FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId() AND PermissionSet.Name = 'CH_NEAssetAdmin'];
		for(CH_CoveredNetworkElementAsset__c cNErec:cNE){
			cNEMap.put(cNErec.CH_NetworkElementAsset__c,cNErec);
		}
		for(Asset assetObj: newAssetList) {
			System.debug('Permission set size:'+permissionSetList.size());
			if(cNEMap.get(assetObj.Id) != NULL && cNEMap.get(assetObj.Id).CH_ContractLineItem__c != NULL){
	system.debug('cNEMap.get(assetObj.Id)'+cNEMap.get(assetObj.Id)+'cNEMap.get(assetObj.Id).CH_ContractLineItem__c'+cNEMap.get(assetObj.Id).CH_ContractLineItem__c);
	if(oldAssetMap.get(assetObj.Id).CH_CountryISO2__c != assetObj.CH_CountryISO2__c) {
		assetObj.CH_CountryISO2__c.addError('Country Code cannot be changed');
		
	}
	if(oldAssetMap.get(assetObj.Id).Address__r.Country != assetObj.Address__r.Country) {
	assetObj.CH_CountryISO2__c.addError('Country cannot be modified if Address is already linked to a Network Element Asset');
	}
	if(oldAssetMap.get(assetObj.Id).Status == 'Active' && assetObj.Status=='InActive' && cNEMap.get(assetObj.Id).CH_Status__c!='InActive') {
		assetObj.Status.addError('Status cannot be changed'); 
	
	}			
	if(oldAssetMap.get(assetObj.Id).CH_ProductRelease__c != assetObj.CH_ProductRelease__c) {
		assetObj.CH_ProductRelease__c.addError('ProductRelease cannot be changed');
		
	}
	if(oldAssetMap.get(assetObj.Id).CH_ProductVariant__c != assetObj.CH_ProductVariant__c) {
		assetObj.CH_ProductVariant__c.addError('ProductVariant cannot be changed');
		
	}
	if(oldAssetMap.get(assetObj.Id).CH_Solution__c != assetObj.CH_Solution__c) {
		assetObj.CH_Solution__c.addError('Solution cannot be changed');
		
	}
	if(oldAssetMap.get(assetObj.Id).RecordTypeId != assetObj.RecordTypeId) {
		assetObj.RecordTypeId.addError('Asset Record type cannot be changed');	  
	}
			}
			if((cNEMap.get(assetObj.Id) != NULL && cNEMap.get(assetObj.Id).CH_ContractLineItem__c == NULL) && (oldAssetMap.get(assetObj.Id).RecordTypeId != assetObj.RecordTypeId)){
		assetObj.RecordTypeId.addError('Asset Record type cannot be changed');	  
	
			}
			if(permissionSetList.size() == 0){
	if(oldAssetMap.get(assetObj.Id).CH_CountryISO2__c != assetObj.CH_CountryISO2__c && (oldAssetMap.get(assetObj.Id).Status == 'Active' && assetObj.Status=='InActive')) {
		assetObj.CH_CountryISO2__c.addError('Country Code cannot be changed');
		assetObj.Status.addError('Status cannot be changed');
	}
	if(oldAssetMap.get(assetObj.Id).CH_CountryISO2__c != assetObj.CH_CountryISO2__c) {
		assetObj.CH_CountryISO2__c.addError('Country Code cannot be changed');
		
	}
	if(oldAssetMap.get(assetObj.Id).Status == 'Active' && assetObj.Status=='InActive') {
		assetObj.Status.addError('Status cannot be changed');
		
	}
			}
		}
	}
	/********************
* Method Name: createCoveredNEA
* Parameter: List <Asset>
* Description: Used to create Covered NEA record from Asset that got created from the CLI record page.
* Reference: NOKIASC-23995
*******************/
	public static void createCoveredNEA(List<Asset> newAssetList){
		List<CH_CoveredNetworkElementAsset__c> coveredNEAList = new List<CH_CoveredNetworkElementAsset__c>();	
		Id neaRecordType = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('CH_NetworkElementAsset').getRecordTypeId();
		try{
			for (Asset newAsset: newAssetList){
	if(newAsset.RecordTypeId == neaRecordType && newAsset.CH_ContractLineItem__c!= null){
		CH_CoveredNetworkElementAsset__c coveredNEA = new CH_CoveredNetworkElementAsset__c(CH_Status__c='Active', CH_NetworkElementAsset__c = newAsset.Id, CH_ContractLineItem__c = newAsset.CH_ContractLineItem__c);
		coveredNEAList.add(coveredNEA);
	}
			}
			//CH_CoveredNEAssetTriggerHelper.preventCNEAduplicates = false;
			// DML statement
			Database.SaveResult[] srList = Database.insert(coveredNEAList, false);
			
			// Iterate through each returned result
			for (Database.SaveResult sr : srList) {
	if (sr.isSuccess()) {
		// Operation was successful, so get the ID of the record that was processed
		System.debug('Successfully inserted Covered Network asset. ID: ' + sr.getId());
		System.debug(coveredNEAList);
	}
	else {
		// Operation failed, so get all errors	
		for(Database.Error err : sr.getErrors()) {
			System.debug('The following error has occurred.');		
			System.debug(err.getStatusCode() + ': ' + err.getMessage());
		}
	}
			}
		}
		catch(Exception e){
			System.debug(e.getMessage());
		}
	}
	
	
	
	//US 25132 Sónia Reis
public static void populateCountryCode(List <Asset> newAssetList){
	system.debug('populateCountryCode BEGINS');
	Set<ID> addressIDs = new Set<ID>();
	Set<ID> CLIIDs = new Set<ID>();
	Set<Id> accountIdSet = new Set<Id>();
	for(Asset ass:  newAssetList){
		addressIDs.add(ass.Address__C);
		CLIIDs.add(ass.CH_ContractLineItem__c);
		accountIdSet.add(ass.AccountId);
	}
	Map<Id, Schema.Address> addresses = new Map<Id, Schema.Address>([select id, countrycode from Address where id in : addressIDs]);
	Map<Id, Contractlineitem> clis = new Map<Id, Contractlineitem>([select id, CH_CountryISO2__c from Contractlineitem where id in : CLIIDs]);
	Map<Id, Account> custComplianceAccounts = new Map<Id, Account>([Select Id,Customer_Compliance__c from Account where Id IN: accountIdSet]);
	
	if(newAssetList != null && !newAssetList.isEmpty()) {
		Map < ID, Schema.RecordTypeInfo > rtMap = Schema.SObjectType.Asset.getRecordTypeInfosById();
		for(Asset a: newAssetList){
			String type = rtMap.get(a.RecordTypeId).getName();
			if( type == 'Network Element Asset'){
	system.debug('is NEA and a.CH_ContractLineItem__r '+a.CH_ContractLineItem__c);	
	if(a.CH_ContractLineItem__c!=null && clis.containsKey(a.CH_ContractLineItem__c)){
		a.CH_CountryISO2__c=clis.get(a.CH_ContractLineItem__c).CH_CountryISO2__c;
		system.debug('CLI a.CH_CountryISO2__c='+a.CH_CountryISO2__c);
	}
	else{
		if(a.Address__c!=null && addresses.containsKey(a.Address__c)){
			a.CH_CountryISO2__c=addresses.get(a.Address__c).CountryCode;
			system.debug('Address a.CH_CountryISO2__c= '+ a.Address__c + a.CH_CountryISO2__c);
		}
	}
			}
			//NOKIASC-25553 Added to populate Account Customer Compliance on Asset
			if(a.AccountId != null && custComplianceAccounts.containsKey(a.AccountId)){
	a.CH_AccountCustomerCompliance__c = custComplianceAccounts.get(a.AccountId).Customer_Compliance__c;
			}
		}
	}
	system.debug('populateCountryCode ENDS');
}

//US 25132 Sónia Reis
public static void populateCountryCodeOnUpdate(Map < Id, Asset > oldAssetMap, List <Asset> newAssetList){
	system.debug('populateCountryCodeOnUpdate BEGINS');
	Set<ID> addressIDs = new Set<ID>();
	Set<Id> accountIdSet = new Set<Id>();
	for(Asset ass:  newAssetList){
		addressIDs.add(ass.Address__C);  
		accountIdSet.add(ass.AccountId);
	}
	Map<Id, Schema.Address> addresses = new Map<Id, Schema.Address>([select id, countrycode from Address where id in : addressIDs]);
	Map<Id, Account> custComplianceAccounts = new Map<Id, Account>([Select Id,Customer_Compliance__c from Account where Id IN: accountIdSet]);
	if(newAssetList != null && !newAssetList.isEmpty()) {
		Map < ID, Schema.RecordTypeInfo > rtMap = Schema.SObjectType.Asset.getRecordTypeInfosById();
		for(Asset a: newAssetList){
			String type = rtMap.get(a.RecordTypeId).getName();
		
	//NOKIASC-36208 Added Address not null condition inorder to update record without address
	if( type == 'Network Element Asset' && a.Address__c!=null && a.CH_ContractLineItem__c==null && oldAssetMap.containsKey(a.ID) && a.Address__c!=oldAssetMap.get(a.ID).Address__c){
		a.CH_CountryISO2__c=addresses.get(a.Address__c).CountryCode;
		system.debug('Address a.CH_CountryISO2__c= '+ a.Address__c + a.CH_CountryISO2__c);
	}			
		}
	}
	system.debug('populateCountryCodeOnUpdate ENDS');
}
	
	/********************
* Method Name: assetStatusCheck
* Parameter: Map < Id, Asset >,List <Asset>
* Description: Do not allow inactivation of Network Element Assets if they have an active covered network element asset related to the contract line item.  
* Reference: NOKIASC-24491
*******************/
	public static void assetStatusCheck(Map < Id, Asset > oldAssetMap, List < Asset > newAssetList){
		
		Id neaRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('CH_NetworkElementAsset').getRecordTypeId();
		list<Asset> neAssets = new list<Asset>();
		for(Asset anAsset : newAssetList){
			// Get only deactivated network element assets that are linked to a contract line item
			if(anAsset.recordTypeId == neaRecordTypeId && anAsset.CH_ContractLineItem__c != null && anAsset.Status =='InActive' && oldAssetMap.get(anAsset.Id).Status == 'Active'){
	neAssets.add(anAsset);
			}
		}
		if(!neAssets.isEmpty()){
			list<string> cneaKey = new list<string>();
			// The field CH_CNEA_ID__c on CH_CoveredNetworkElementAsset__c object is populated through a Process Builder
			// It is containing a concatenation of the fields CH_NetworkElementAsset__c + CH_ContractLineItem__c   
			for(Asset anAsset : neAssets){
	cneaKey.add(string.valueOf(anAsset.Id) + string.valueOf(anAsset.CH_ContractLineItem__c));
			}
			set<string> activeCNEAKey = new set<string>();
			for(CH_CoveredNetworkElementAsset__c cnea : [SELECT CH_NetworkElementAsset__c, CH_ContractLineItem__c FROM CH_CoveredNetworkElementAsset__c WHERE CH_CNEA_ID__c IN :cneaKey AND CH_Status__c = 'Active'])
	activeCNEAKey.add(string.valueOf(cnea.CH_NetworkElementAsset__c) + string.valueOf(cnea.CH_ContractLineItem__c));
			
			for(Asset anAsset : neAssets)
	if(activeCNEAKey.contains(string.valueOf(anAsset.Id) + string.valueOf(anAsset.CH_ContractLineItem__c)))
	anAsset.addError('You cannot deactivate a Network Element Asset that is having an active link to a contract line item');
			
		}
	}
	
}