/****************************************
* Name : HWS_Utilty
* Author : TCS
* Description : This class is for utlility
* ReqNo : 
****************************************/
public without sharing class HWS_Utilty {
	//Added by Ajesh
	public static Map<Id, BusinessHours> busMap = new Map<Id, BusinessHours>();
	public static Map<String, Id> bhNameIdMap = new Map<String, Id>();
	public static Map<String, String> bhTimezoneIdMap = new Map<String, String>();
	public static List<BusinessHours> listBusinessHours = new List<BusinessHours>();
	//Added by Eashwar for NOKIASC-37193
	public static Integer retryCount=0;//NOKIASC-37193
	public static Boolean fromSOOUser=false;
	//Added by Kunal
	public static String latitude   {get; set;}
	public static String longitude  {get; set;}
	public static final String classification = 'HWS Service';
	public static boolean isCallFromBulkRequest = false; // NOKIASC-37920  | true if called from bulk request
	//NOKIASC-37150-start
	public static final Set<String> SETLESTATUS = new Set<String>{HWS_Constants.LE_APPROVAL_PICKLIST_VALUE1,HWS_Constants.LE_APPROVAL_PICKLIST_VALUE2,HWS_Constants.LE_APPROVAL_PICKLIST_VALUE3};
	//NOKIASC-37150-end
	//32414
	public static Set<String> childCaseStatusesforDuplicte = new Set<String>{'Closed','Cancelled','Delivered'};
		//32414
		public static Id exchangeInDays {
			get {
				if(exchangeInDays == null){
					exchangeInDays = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Advance_Exchange_In_Days);
				}
				return exchangeInDays;
			}
			set;
		}
	public static Id exchangeInHours {
		get {
			if(exchangeInHours == null){
				exchangeInHours = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_ADVANCE_EXCHANGE_IN_HOURS);
			}
			return exchangeInHours;
		}
		set;
	}
	public static Id childCaseReadOnly {
		get {
			if(childCaseReadOnly == null){		  
				childCaseReadOnly = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_CHILD_CASE_READ_ONLY);
			}
			return childCaseReadOnly;
		}
		set;
	}
	public static Id sPSCaseRType {
		get {
			if(sPSCaseRType == null){
				sPSCaseRType = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_SPS_PART_SALES);
			}
			return sPSCaseRType;
		}
		set;
	}
	public static Id spsReadOnly {
		get {
			if(spsReadOnly == null){
				spsReadOnly = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_SPS_PART_SALES_READ_ONLY);
			}
			return spsReadOnly;
		}
		set;
	}
	public static Id parentCaseRecordType {
		get {
			if(parentCaseRecordType == null){
				parentCaseRecordType = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_PARENT_CASE);
			}
			return parentCaseRecordType;
		}
		set;
	}
	public static Id parentCaseReadOnly {
		get {
			if(parentCaseReadOnly == null){
				parentCaseReadOnly = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_PARENT_CASE_READ_ONLY);
			}
			return parentCaseReadOnly;
		}
		set;
	}
	public static Id rfr {
		get {
			if(rfr == null){
				rfr = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_RETURN_FOR_REPAIR);
			}
			return rfr;
		}
		set;
	}   
	public static Id esclationCase {
		get { 
			if(esclationCase == null){
				esclationCase = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_ESCALATION_CASE);
				
			}
			return esclationCase;
		}
		set;
	}   
	
	/****************************************
* Name : getRecordTypeByName
* Description : This returns the recordtype id based on the object name and record type from which it is getting
* Parameters: Object Name and Recordtype Name
* Returns : recordtype id based on the Object Name and RecordTypename.
*****************************************/
	
	public static Map<Id, BusinessHours> getBusinessHourMap {   
		get {   
			if(getBusinessHourMap == null){  
				getBusinessHourMap = getBusinessHouDetails();   
			}   
			return getBusinessHourMap;  
		}   
		set; 
	}
	public static Id getRecordTypeByName(String objectName, String recordTypeName){  
		Id recordTypeId= Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();
		
		return recordTypeId;
	}
	
	/****************************************
* Name : getAccounts
* Description : This returns the list of Accounts based on the Account Ids in AccountContactRelation - NOKIASC-29400
* Parameters: Account Id
* Returns : List of Accounts 
*****************************************/
	//HWST_4125 added CH_Account_Name_Alias__c field for Account alias for portal
	public static List<Account> getAccounts(Set<Id> listAccIds){
		return [
			SELECT Id, Name, AccountNumber, Acc_No__c, Country__c, BillingCity, BillingStreet,
			CH_Account_Name_Alias__c,CH_ParentAccountName__c,OperationalCustomerName__c,type
			FROM Account WHERE Id IN :listAccIds
		];
	}
	
	/****************************************
* Name : getAccountContactsRelation
* Description : This returns the list of Accounts based on the Account Ids in AccountContactRelation
* Parameters: Contact Id and Legal Account Id
* Returns : List of AccountContactRelations 
*****************************************/
	public static List<AccountContactRelation> getAccountContactsRelation(Id contactid, Id legalAccount){   
	   
		//added  for PMD Error - NOKIASC-32425
		list<AccountContactRelation> listAccounsContacts = [SELECT Id,accountId FROM AccountContactRelation where Contact.id = :contactid 
															AND Account.RecordTypeId = :legalAccount ];
		return listAccounsContacts;
	}
	
	/****************************************
* Name : getEntitlementContact
* Description : This returns the list of EntitlementContacts based on the Contact Ids - NOKIASC-29400
* Parameters: Contact Id and Legal Account Id
* Returns : List of EntitlementContact 
*****************************************/
	public static List<EntitlementContact> getEntitlementContact(Id contactid, Id legalAccount){	
		//added  for PMD Error - NOKIASC-32425
		return [
			SELECT Id, EntitlementId, Entitlement.AccountId, Entitlement.Account.Name, Entitlement.Name, ContactId
			FROM EntitlementContact
			WHERE ContactId = :contactId AND Entitlement.Account.RecordTypeId = :legalAccount 
		];
	}
	
	/****************************************
* Name : getAllServiceTypes
* Description : This returns the list of Assets based on the Product Id and Account Id where service contract status is neither expired nor inactive
* Parameters: Product Id and Account Id
* Returns : List of Assets 
*****************************************/
	public static List<Asset> getAllServiceTypes(Set<Id> prodIds, Set<Id> accIds){
		//added  for PMD Error - NOKIASC-32425
		//NOKIASC-32212:Added HWS_ContractLineItem__r.HWS_InvoicingType__c,HWS_ContractLineItem__r.HWS_WarrantyVerificationRequired__c,HWS_ContractLineItem__r.HWS_QuotationRequiredFlag__c
		List<Asset> serviceTypes = [SELECT Id,HWS_ContractLineItem__r.HWS_PONumber__c,HWS_Service_Contract_Number__c,HWS_Currency__c,HWS_Price__c,Contract_Number__c,HWS_ContractLineItem__c,HWS_ContractLineItem__r.CH_LineItemEntitlementScript__c,HWS_ContractLineItem__r.ServiceContract.CH_EntitlementScript__c,HWS_ContractLineItem__r.ServiceContractId,HWS_ContractLineItem__r.ServiceContract.HWS_Currency__c, HWS_ContractLeadTimeUnit__c,AccountId,HWS_ContractLeadTimeDuration__c,Product2Id,Product2.Name,ProductCode,
									HWS_Service_Type__c,HWS_Product_Name__c,HWS_ContractLineItem__r.ServiceContract.CH_CountryCode__c,HWS_ContractLineItem__r.ServiceContract.CH_CountryName__c,HWS_SpecifiedDeliveryTargetTime__c,HWS_High_Level_Product_Name__c, HWS_ContractLineItem__r.CH_CountryISOName__c,HWS_ContractLineItem__r.HWS_InvoicingType__c,HWS_ContractLineItem__r.HWS_WarrantyVerificationRequired__c,HWS_ContractLineItem__r.HWS_QuotationRequiredFlag__c FROM Asset WHERE Product2Id IN: prodIds AND AccountId IN: accIds AND HWS_ContractLineItem__r.ServiceContract.NCP_External_Status__c = 'Active' ];
		
		return serviceTypes;
	}
	
	/****************************************
* Name : plannedDeliveryDateTime
* Description : This returns the planned delivery date based on the Business Hours, Contract Lead Time Unit and Contract Lead Time Duration
* Parameters: Business Hours Id, Contract Lead Time Unit, Contract Lead Time Duration
* Returns : Planned Delivery Date
*****************************************/
	public static DateTime plannedDeliveryDateTime(Id businessHrsId, String leadTimeUnit, String leadTimeDuration,Date faultyUnitDate,String specifiedTime){
		 // Get the default business hours
		BusinessHours bh;
		DateTime plannedDT;
		plannedDT = Datetime.now();
		Date now;
		now= Date.Today();
		if(getBusinessHourMap.size()>0 && getBusinessHourMap.containskey(businessHrsId)){
			bh = getBusinessHourMap.get(businessHrsId);  
		}   
		else{   
			//added  for PMD Error - NOKIASC-32425
			bh = [SELECT Id,TimeZoneSidKey FROM BusinessHours WHERE Name =: '24x7' ];	   
		}

		if(specifiedTime!='' && specifiedTime!=null){
			List<String> minuts = specifiedTime.split(':');
			if(leadTimeUnit == 'Business Days'){
			  
				if(faultyUnitDate!=null){
					plannedDT=faultyUnitDate;
				}
				DateTime businessDays = addDays(plannedDT,Integer.valueOf(leadTimeDuration),bh.Id);
			 
			   
				Datetime businessDate = datetime.newInstanceGMT(businessDays.year(), businessDays.month(),businessDays.day());
				Datetime businessDateaddhourOnly = businessDate.addHours(Integer.valueOf(minuts[0]));
				Datetime businessDateaddhours = businessDateaddhourOnly.addMinutes(Integer.valueOf(minuts[1]));
			   
				plannedDT = businessDateaddhours; 
				
			}
			else if(leadTimeUnit == 'Calendar Days'){
				//HWST-3982
				if(faultyUnitDate!=null){
					plannedDT=faultyUnitDate;
				}else{
					plannedDT = DateTime.now();
				}
			   
				Datetime nextStart = BusinessHours.nextStartDate(bh.Id, plannedDT);
				Datetime businessDate = datetime.newInstanceGMT(nextStart.year(), nextStart.month(),nextStart.day());
				nextStart = businessDate.addDays(Integer.valueOf(leadTimeDuration));
				nextStart = nextStart.addHours(Integer.valueOf(minuts[0]));
				nextStart = nextStart.addMinutes(Integer.valueOf(minuts[1]));
				
				plannedDT = nextStart; 
			}
			string dateTimeInString = plannedDT.format('yyyy/MM/dd HH:mm:ss', bh.TimeZoneSidKey);
			DateTime PlannedDate = DateTime.valueOfGmt(dateTimeInString.replaceAll('/','-'));
		   
			Long milliseconds = PlannedDate.getTime() - plannedDT.getTime();
			Long seconds = milliseconds / 1000;
			Long minutes = seconds / 60;
		  
			plannedDT = plannedDT.addMinutes(-Integer.valueOf(minutes));
		   
		}
		else{
			Long interval;
			if(faultyUnitDate!=null ){
				plannedDT = faultyUnitDate;
			}
		  
			if(leadTimeUnit.containsIgnoreCase('Business Days')){
				if(faultyUnitDate!=null){
					plannedDT=faultyUnitDate;
				}
				DateTime businessDays = addDays(plannedDT,Integer.valueOf(leadTimeDuration),bh.Id);
				plannedDT = businessDays;
			}else if(leadTimeUnit.containsIgnoreCase('Hours')){
				interval = Integer.valueOf(leadTimeDuration) * 60 * 60 * 1000;
				plannedDT = BusinessHours.add(bh.id, plannedDT,interval);
			  
			}else if(leadTimeUnit.containsIgnoreCase('Minutes')){
				interval = Integer.valueOf(leadTimeDuration) * 60 * 1000;
				plannedDT = BusinessHours.add(bh.id, plannedDT,interval);
			}else if(leadTimeUnit == 'Calendar Days'){
				if(faultyUnitDate!=null){
					plannedDT=faultyUnitDate;
				}if(faultyUnitDate!=null){
					plannedDT=faultyUnitDate;
				}else{
					plannedDT = DateTime.now();
				}
				
				Datetime nextStart = plannedDT;
				nextStart = nextStart.addDays(Integer.valueOf(leadTimeDuration));
			   
				plannedDT = nextStart; 
			}
			
		}
	   
		
		return plannedDT;
	}
	
	/****************************************
* Name : addDays
* Description : This returns the date in numberOfDays business days 
* Parameters: Start Date, Contract Lead Time Duration, Business Hours
* Returns : Returns back date in numberOfDays business days 
**************************************************************/ 
	public static Datetime addDays(Datetime startDate, Integer days, Id businessHourId)
	{
		
		//If startdate is not within working days, take next working day
		startDate = BusinessHours.nextStartDate(businessHourId, startDate);
		for (Integer elapsed = 0; elapsed < days; elapsed++)
		{
			//Add 1 day
			startDate = startDate.addDays(1);
			//Check if new date is within working days
			if (!BusinessHours.isWithin(businessHourId, startDate))
			{ 
				//If new date is not within working days, get new working day
				startDate = BusinessHours.nextStartDate(businessHourId, startDate);
			}
		}
	   
		
		return startDate;
	}
	

	

	
	/****************************************
* Name : getAllServiceTypes
* Description : This returns list of Assets based on the Service Type and Service Contract Number
* Parameters: Product Id, Account Id, Service Type, Service Contract Number
* Returns : List of Assets
*****************************************/
	//3697 - passing contactId
	public static List<Asset> getAllServiceTypes(Set<Id> prodIds, Set<Id> accIds,String serviceType, String contractNumber, Id contactId, String country ){  
		String expired = 'Expired';
		String inactive = 'Inactive';
		String externalStatus = 'Active';
		Boolean sync = true;
		//2503 SPS Last Order Date validation started added HWS_Product_SPSLOD__c field
		//NOKIASC-25659 for NEA count  added CH_QtyCoveredNetworkElementAssets__c field
		//NOKIASC-32212:Added HWS_ContractLineItem__r.HWS_InvoicingType__c,HWS_ContractLineItem__r.HWS_WarrantyVerificationRequired__c,HWS_ContractLineItem__r.HWS_QuotationRequiredFlag__c
		//NOKIASC-36280 HWS_ContractLineItem__r.ServiceContract.HWS_PurchaserType__c
		//NOKIASC-36275:New ship to party creation for Combined Ordering(Added ServiceContract.HWS_Combined_Ordering__c field)
		//NOKIASC-37150 Added HWS_PartLEStatus__c in query and filter criteria
		String assetQuery1 = 'SELECT Id,HWS_PartLEStatus__c,HWS_ContractLineItem__r.ServiceContract.HWS_PurchaserType__c,HWS_ContractLineItem__r.HWS_PONumber__c,HWS_SourceSystem__c,HWS_Product_SPSLOD__c,HWS_SpecifiedDeliveryTargetTime__c,HWS_Service_Contract_Number__c,HWS_Currency__c,HWS_Price__c,Contract_Number__c,HWS_ContractLineItem__r.Asset.Product2.Name,HWS_ContractLineItem__r.CH_ServiceOffering__c,HWS_ContractLineItem__c,HWS_ContractLineItem__r.ServiceContract.HWS_Currency__c, HWS_ContractLineItem__r.CH_LineItemEntitlementScript__c,HWS_ContractLineItem__r.ServiceContract.CH_EntitlementScript__c,HWS_ContractLineItem__r.ServiceContract.CH_CountryCode__c,HWS_ContractLineItem__r.ServiceContract.CH_CountryName__c,HWS_ContractLineItem__r.ServiceContract.HWS_Combined_Ordering__c,HWS_ContractLineItem__r.ServiceContractId,HWS_ContractLineItem__r.CH_CoverageGroup__c,HWS_ContractLineItem__r.HWS_AdditionalSIInfo1__c,HWS_ContractLeadTimeUnit__c,AccountId,HWS_ContractLeadTimeDuration__c,Product2Id,Product2.Name,ProductCode,'+
			'HWS_ServiceItemCode__c,HWS_ContractLineItem__r.ServiceContract.CH_ERPSystem__c, HWS_Part_Code__c,HWS_Service_Type__c,HWS_Product_Name__c, HWS_ContractLineItem__r.CH_BusinessHour__r.Id,HWS_ServiceItemDescription__c,HWS_ServiceOffering__c,HWS_High_Level_Product_Name__c, HWS_ContractLineItem__r.CH_QtyCoveredNetworkElementAssets__c,  HWS_ContractLineItem__r.CH_CountryISOName__c,HWS_ContractLineItem__r.HWS_InvoicingType__c,HWS_ContractLineItem__r.HWS_WarrantyVerificationRequired__c,HWS_ContractLineItem__r.HWS_QuotationRequiredFlag__c FROM Asset WHERE Product2Id IN: prodIds AND AccountId IN: accIds AND (HWS_ContractLineItem__r.ServiceContract.NCP_External_Status__c =: externalStatus) AND (HWS_ContractLineItem__r.ServiceContract.Status =: externalStatus) AND HWS_ContractLineItem__r.CH_ServiceClassification__c=: classification AND HWS_ContractLineItem__r.NCP_External_Status__c=: externalStatus AND HWS_ExternalStatus__c=: externalStatus AND HWS_IsSynced__c =:sync AND HWS_PartLEStatus__c IN:SETLESTATUS';
		//getting only Authorized serviceContract Records
		//3697 - passing contactId  ****************Start*********
		List<EntitlementContact> servContList1 = [select id, Entitlement.Name, Entitlement.ServiceContract.Name, Entitlement.ServiceContract.Id, Entitlement.ServiceContract.ContractNumber, Entitlement.Account.Name, Entitlement.AccountId, contact.Name, ContactId from EntitlementContact where ContactId = :contactId];
		Map<Id, Set<String>> servContrMap1 = new Map<Id, Set<String>>();
		if(servContList1.size()>0){
			for(EntitlementContact ent:servContList1){	
				if(servContrMap1.containskey(ent.Entitlement.AccountId)){
					servContrMap1.get(ent.Entitlement.AccountId).add(ent.Entitlement.ServiceContract.ContractNumber);
				}
				else{
					servContrMap1.put(ent.Entitlement.AccountId, new Set<String>{ent.Entitlement.ServiceContract.ContractNumber});
				}
			}
		}
		Set<String> contrSet1 = new Set<String>();
		List<String> actLst = new List<String>();
		for(Id i :accIds){
			actLst.add(i);
		}
		if(servContrMap1.Containskey(actLst[0])){
			contrSet1 = servContrMap1.get(actLst[0]);
		}
		if(contrSet1.size()>0){
			assetQuery1 = assetQuery1+' AND Contract_Number__c IN: contrSet1';
		}
		//******************************End*********
		if(contractNumber != null && contractNumber!=''){
			assetQuery1 = assetQuery1+' AND HWS_Service_Contract_Number__c=: contractNumber';
		}
		if(serviceType != null && serviceType !=''){
			assetQuery1 = assetQuery1+' AND HWS_Service_Type__c=: serviceType';
		}
		if(country != null && country !=''){
			assetQuery1 = assetQuery1+' AND HWS_ContractLineItem__r.CH_CountryISOName__c=: country';
		}
		
		list<Asset> listAssets = database.query(assetQuery1);
	  
		
		return listAssets;
	}
	
	/****************************************
* Name : getAllServiceTypes
* Description : This returns list of Assets based on the Service Type and Service Contract Number
* Parameters: Product Id, Account Id, Service Type, Service Contract Number
* Returns : List of Assets
*****************************************/
	public static List<Asset> getAllServiceTypesAuthLegalEntity(Set<Id> prodIds, Set<Id> accIds,String serviceType,String contractNumber, Set<String> authServContrNum){		
		String expired = 'Expired';
		String inactive = 'Inactive';
		String externalStatus = 'Active';
		Boolean sync = true;
		//2503 SPS Last Order Date validation started added HWS_Product_SPSLOD__c field
		String assetQuery = 'SELECT Id,HWS_ContractLineItem__r.HWS_PONumber__c,HWS_SourceSystem__c,HWS_Product_SPSLOD__c,HWS_Service_Contract_Number__c,HWS_Currency__c,HWS_Price__c,Contract_Number__c,HWS_ContractLineItem__c,HWS_ContractLineItem__r.ServiceContract.HWS_Currency__c, HWS_ContractLineItem__r.CH_LineItemEntitlementScript__c,HWS_ContractLineItem__r.ServiceContract.CH_EntitlementScript__c,HWS_ContractLineItem__r.ServiceContract.CH_CountryCode__c,HWS_ContractLineItem__r.ServiceContract.CH_CountryName__c,HWS_ContractLineItem__r.CH_CountryISOName__c,HWS_ContractLineItem__r.ServiceContractId,HWS_ContractLineItem__r.HWS_AdditionalSIInfo1__c,HWS_ContractLeadTimeUnit__c,AccountId,HWS_ContractLeadTimeDuration__c,Product2Id,ProductCode,'+
			'HWS_ServiceItemCode__c,HWS_ContractLineItem__r.ServiceContract.CH_ERPSystem__c, HWS_Part_Code__c,HWS_Service_Type__c,HWS_Product_Name__c, HWS_ContractLineItem__r.CH_BusinessHour__r.Id,HWS_ServiceItemDescription__c,HWS_ServiceOffering__c,HWS_SpecifiedDeliveryTargetTime__c,HWS_High_Level_Product_Name__c FROM Asset WHERE Product2Id IN: prodIds AND AccountId IN: accIds AND (HWS_ContractLineItem__r.ServiceContract.NCP_External_Status__c =: externalStatus) AND (HWS_ContractLineItem__r.ServiceContract.Status =: externalStatus) AND HWS_ContractLineItem__r.CH_ServiceClassification__c=: classification AND HWS_ContractLineItem__r.NCP_External_Status__c=: externalStatus AND HWS_ExternalStatus__c=: externalStatus AND HWS_IsSynced__c =:sync';

		if(contractNumber != null && contractNumber!=''){
			assetQuery = assetQuery+' AND HWS_Service_Contract_Number__c=: contractNumber';
		}
		if(serviceType != null && serviceType !=''){
			assetQuery = assetQuery+' AND HWS_Service_Type__c=: serviceType';
		}
	  
		list<Asset> listAssets = database.query(assetQuery);
	   
		
		return listAssets;
	}
	
	/****************************************
* Name : getVersionItems
* Description : This returns the Version Items based on the selected Products
* Parameters: Selected Product Ids, Search Value 
* Returns : List of Version Items
*****************************************/
	public static List<hws_versionitem__c> getVersionItems(Set<Id> sCLItmIds,String sourceSystem,List<String> versCodeList){	  
		list<hws_versionitem__c> listContractLineItems= new List<hws_versionitem__c>();
		//NOKIASC-32212:Added HWS_Serial_Number_Traceable__c in select query
		String strQuery= 'SELECT id,Material_Code__c,CLEI__c,Comcode__c,Name,HWS_Product_Name__c,HWS_Version_Code__c,HWS_Hardware_Sellable_Item__c,HWS_Part_Code_Part_Revision__c,HWS_Serial_Number_Traceable__c  FROM hws_versionitem__c '+
			'WHERE HWS_Hardware_Sellable_Item__c IN: sCLItmIds AND HWS_Source__c =:sourceSystem';
		if(versCodeList.size()>0){
			strQuery = strQuery+' AND HWS_Version_Code__c IN: versCodeList';			
		}
		strQuery = strQuery+' ORDER BY HWS_Version_Code__c';
		listContractLineItems = database.query(strQuery);
		return listContractLineItems;
	}
	
	/****************************************
* Name : getserviceContracts
* Description : This method returns List of hws_versionitem based on List of Account Ids
* Parameters: Contract Number, Selected Account Ids, Service type
* Returns : List of Contract line item
*****************************************/
	//3697 - passing contactId
	public static List<ContractLineItem> getserviceContracts(String contractNumber, set<Id> accIds,String serviceType,String selectedContractNumber,Id contactId){  
		
		list<ContractLineItem> listserviceContracts;
		String expired = 'Expired';
		String inactive = 'Inactive';
		String externalStatus = 'Active';
		//2503
		//NOKIASC-25659 for NEA count  added CH_QtyCoveredNetworkElementAssets__c field
		//NOKIASC-36275:New ship to party creation for Combined Ordering(Added ServiceContract.HWS_Combined_Ordering__c field)
		String strQuery2='SELECT Id, CH_ServiceClassification__c,CH_QtyCoveredNetworkElementAssets__c,PricebookEntry.Product2.HWS_SPS_Last_Order_Date__c,HWS_AdditionalSIInfo1__c,CH_ServiceType__c,ServiceContract.CH_ERPSystem__c,HWS_ServiceContractName__c,HWS_ServiceContractNumber__c,ServiceContract.CH_EntitlementScript__c,CH_LineItemEntitlementScript__c,ServiceContract.CH_CountryCode__c,ServiceContract.CH_CountryName__c,ServiceContract.HWS_Combined_Ordering__c,CH_CoverageGroup__c, CH_CountryISOName__c FROM ContractLineItem '+
			'WHERE (ServiceContract.CH_CARES_ServiceAgreement__c LIKE :contractNumber OR ServiceContract.CH_SAP_ContractNumber__c LIKE :contractNumber) AND ServiceContract.AccountId IN: accIds AND (ServiceContract.NCP_External_Status__c =: externalStatus) AND (ServiceContract.Status =: externalStatus) AND NCP_External_Status__c=: externalStatus AND CH_ServiceClassification__c=:classification';
		//getting only Authorized serviceContract Records
		//3697 - passing contactId *************Start*********
		//Id contactId;
		//added  for PMD Error - NOKIASC-32425
		List<EntitlementContact> servContList2 = [select id, Entitlement.Name, Entitlement.ServiceContract.Name, Entitlement.ServiceContract.Id, Entitlement.ServiceContract.ContractNumber, Entitlement.Account.Name, Entitlement.AccountId, contact.Name, ContactId from EntitlementContact where ContactId = :contactId ];
		Map<Id, Set<String>> servContrMap2 = new Map<Id, Set<String>>();
		if(servContList2.size()>0){
			for(EntitlementContact ent:servContList2){	
				if(servContrMap2.containskey(ent.Entitlement.AccountId)){
					servContrMap2.get(ent.Entitlement.AccountId).add(ent.Entitlement.ServiceContract.ContractNumber);
				}
				else{
					servContrMap2.put(ent.Entitlement.AccountId, new Set<String>{ent.Entitlement.ServiceContract.ContractNumber});
				}
			}
		}
		Set<String> contrSet2 = new Set<String>();
		List<String> actLst = new List<String>();
		for(Id i :accIds){
			actLst.add(i);
		}
		if(servContrMap2.Containskey(actLst[0])){
			contrSet2 = servContrMap2.get(actLst[0]);
		}
		//******************************End*********
		if(contrSet2.size()>0){
			strQuery2 = strQuery2+' AND ServiceContract.ContractNumber IN: contrSet2';
		}
		
		if(serviceType != null && serviceType !=''){
			strQuery2 = strQuery2+' AND CH_ServiceType__c=: serviceType';
		}
		if(selectedContractNumber != null && selectedContractNumber !=''){
			strQuery2 = strQuery2+' AND (ServiceContract.CH_CARES_ServiceAgreement__c=: selectedContractNumber OR ServiceContract.CH_SAP_ContractNumber__c=: selectedContractNumber)' ;
		}
		listserviceContracts = database.query(strQuery2);
   
		
		return listserviceContracts;
	}
	
	/****************************************
* Name : getserviceContracts
* Description : This method returns List of Inactive hws_versionitem based on List of Account Ids
* Parameters: Contract Number, Selected Account Ids, Service type
* Returns : List of Contract line item
*****************************************/
	public static List<ContractLineItem> getserviceContractsInactive(String contractNumber, set<Id> accIds,String serviceType){  
		list<ContractLineItem> listserviceContracts;
		String expired = 'Expired';
		String inactive = 'Inactive';
		String strQuery='SELECT Id, CH_ServiceType__c,HWS_ServiceContractName__c,HWS_ServiceContractNumber__c,ServiceContract.CH_EntitlementScript__c,CH_LineItemEntitlementScript__c,CH_CoverageGroup__c FROM ContractLineItem '+
			'WHERE (ServiceContract.CH_CARES_ServiceAgreement__c LIKE :contractNumber OR ServiceContract.CH_SAP_ContractNumber__c LIKE :contractNumber) AND ServiceContract.AccountId IN: accIds';
		if(serviceType != null && serviceType !=''){
			strQuery = strQuery+' AND CH_ServiceType__c=: serviceType';
		}
		listserviceContracts = database.query(strQuery);
		
		return listserviceContracts;
	}
	
	/****************************************
* Name : getServiceTypes
* Description : This method returns List of Assets based on selected Contract Line Items
* Parameters: ContractLineItem Ids
* Returns : List of Assets
*****************************************/
	public static List<Asset> getServiceTypes(set<Id> servIDs){ 
		
		String ExternalStatus = 'Active';
		Boolean sync = true;
		//2503
		//added  for PMD Error - NOKIASC-32425
		//NOKIASC-36275:New ship to party creation for Combined Ordering(Added ServiceContract.HWS_Combined_Ordering__c field)
		//NOKIASC-37150 Added HWS_PartLEStatus__c in query and filter criteria
		list<Asset> listAssets = [SELECT Id,HWS_PartLEStatus__c,HWS_ContractLineItem__r.HWS_PONumber__c,HWS_ContractLineItem__r.Asset.Product2.Name,HWS_SourceSystem__c,HWS_Service_Contract_Number__c,HWS_Product_SPSLOD__c,Contract_Number__c,HWS_ContractLineItem__r.CH_LineItemEntitlementScript__c,HWS_ContractLineItem__r.ServiceContract.CH_EntitlementScript__c,HWS_ContractLeadTimeDuration__c,AccountId,HWS_ContractLeadTimeUnit__c,Product2Id,Product2.Name,ProductCode,HWS_Currency__c,HWS_Price__c,
								  HWS_ServiceItemCode__c,HWS_ServiceItemDescription__c,HWS_ServiceOffering__c,HWS_ContractLineItem__r.ServiceContract.CH_ERPSystem__c,HWS_Service_Type__c,HWS_Part_Code__c,HWS_Product_Name__c,HWS_ContractLineItem__r.HWS_AdditionalSIInfo1__c,HWS_ContractLineItem__r.CH_BusinessHour__r.Id,HWS_ContractLineItem__r.ServiceContract.CH_CountryCode__c,HWS_ContractLineItem__r.ServiceContract.CH_CountryName__c,HWS_ContractLineItem__r.ServiceContract.HWS_Combined_Ordering__c,
								  HWS_ContractLineItem__r.CH_CountryISOName__c,HWS_SpecifiedDeliveryTargetTime__c,HWS_High_Level_Product_Name__c,HWS_ContractLineItem__r.HWS_WarrantyVerificationRequired__c 
								  FROM Asset WHERE HWS_ContractLineItem__c IN: servIDs AND HWS_ExternalStatus__c=: ExternalStatus AND HWS_IsSynced__c =:sync 
		  AND HWS_PartLEStatus__c IN:SETLESTATUS];
		
		return listAssets;
	}
	
	/**************************************** 
* Name : getDependentMap
* Description : 
* Parameters: Object Name, Billing Country, Billing State 
* Returns : 
*****************************************/
	@AuraEnabled 
	public static Map<String, List<String>> getDependentMap(sObject objDetail, string contrfieldApiName,string depfieldApiName, String countryName) {   
		String controllingField = contrfieldApiName.toLowerCase();
		String dependentField = depfieldApiName.toLowerCase();
		
		Map<String,List<String>> objResults = new Map<String,List<String>>();
		
		Schema.sObjectType objType = objDetail.getSObjectType();
		if (objType==null){
			return objResults;
		}
		
		Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
		
		if (!objFieldMap.containsKey(controllingField) || !objFieldMap.containsKey(dependentField)){
			return objResults;   
		}
		
		Schema.SObjectField theField = objFieldMap.get(dependentField);
		Schema.SObjectField ctrlField = objFieldMap.get(controllingField);
		
		List<Schema.PicklistEntry> contrEntries = ctrlField.getDescribe().getPicklistValues();
		List<PicklistEntryWrapper> depEntries = wrapPicklistEntries(theField.getDescribe().getPicklistValues());
		List<String> controllingValues = new List<String>();
		
		for (Schema.PicklistEntry ple : contrEntries) {
			String label = ple.getLabel();
			objResults.put(label, new List<String>());
			controllingValues.add(label);
		}
		
		for (PicklistEntryWrapper plew : depEntries) {
			String label = plew.label;
			String validForBits = base64ToBits(plew.validFor);
			for (Integer i = 0; i < validForBits.length(); i++) {
				String bit = validForBits.mid(i, 1);
				if (bit == '1') {
					objResults.get(controllingValues.get(i)).add(label);
				}
			}
		}
		
		return objResults;
	}
	
	/****************************************
* Name : decimalToBinary
* Description : 
* Parameters: val 
* Returns : bits
*****************************************/
	public static String decimalToBinary(Integer val) { 
		String bits = '';
		while (val > 0) {
			Integer remainder = Math.mod(val, 2);
			val = Integer.valueOf(Math.floor(val / 2));
			bits = String.valueOf(remainder) + bits;
		}
		
		return bits;
	}
	
	/****************************************
* Name : base64ToBits
* Description : 
* Parameters: validFor 
* Returns : 
*****************************************/
	public static String base64ToBits(String validFor) {
		final String base64Chars =  '' +
			'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
			'abcdefghijklmnopqrstuvwxyz' +
			'0123456789+/';
		if (String.isEmpty(validFor)) return '';
		
		String validForBits = '';
		
		for (Integer i = 0; i < validFor.length(); i++) {
			String thisChar = validFor.mid(i, 1);
			Integer val = base64Chars.indexOf(thisChar);
			String bits = decimalToBinary(val).leftPad(6, '0');
			validForBits += bits;
		}
		
		return validForBits;
	}
	
	private static List<PicklistEntryWrapper> wrapPicklistEntries(List<Schema.PicklistEntry> ple) { 
		return (List<PicklistEntryWrapper>)
			JSON.deserialize(JSON.serialize(ple), List<PicklistEntryWrapper>.class);
	}
	
	public class PicklistEntryWrapper{
		public String active {get;set;}
		public String defaultValue {get;set;}
		public String label {get;set;}
		public String value {get;set;}
		public String validFor {get;set;}
		public PicklistEntryWrapper(){  
		}
		
	}
	
	/****************************************
* Name : getserviceContractsPortal
* Description : This method returns List of hws_versionitem based on List of Account Ids
* Parameters: Contract Number, Selected Account Ids, Service type
* Returns : List of Contract line item
*****************************************/
	//3697
	public static List<ContractLineItem> getserviceContractsPortal(String contractNumber, String accId,String serviceType,String selectedcontractNumber, Id contactId){ 
		list<ContractLineItem> listserviceContracts;
		String expired = 'Expired';
		String inactive = 'Inactive';
		String externalStatus = 'Active';
		Boolean enableForPortal = true;
		//2503
		String strQuery3='SELECT Id, CH_ServiceClassification__c,PricebookEntry.Product2.HWS_SPS_Last_Order_Date__c,HWS_AdditionalSIInfo1__c,CH_ServiceType__c,HWS_ServiceContractName__c,HWS_ServiceContractNumber__c,ServiceContract.CH_EntitlementScript__c,CH_LineItemEntitlementScript__c,ServiceContract.CH_CountryCode__c,ServiceContract.CH_CountryName__c, CH_QtyCoveredNetworkElementAssets__c  FROM ContractLineItem '+
			'WHERE (ServiceContract.CH_CARES_ServiceAgreement__c LIKE :contractNumber OR ServiceContract.CH_SAP_ContractNumber__c LIKE :contractNumber) AND ServiceContract.AccountId =: accId AND (ServiceContract.NCP_External_Status__c =: externalStatus) AND (ServiceContract.Status =: externalStatus) AND NCP_External_Status__c=: externalStatus AND CH_ServiceClassification__c=:classification AND ServiceContract.CH_PortalCaseCreationHWS__c =: enableForPortal';
		//getting only Authorized serviceContract Records
		//3697 - passing contactId  ****************Start*********
		//added  for PMD Error - NOKIASC-32425
		List<EntitlementContact> servContList3 = [select id, Entitlement.Name, Entitlement.ServiceContract.Name, Entitlement.ServiceContract.Id, Entitlement.ServiceContract.ContractNumber, Entitlement.Account.Name, Entitlement.AccountId, contact.Name, ContactId from EntitlementContact where ContactId = :contactId ];
		Map<Id, Set<String>> servContrMap3 = new Map<Id, Set<String>>();
		if(servContList3.size()>0){
			for(EntitlementContact ent:servContList3){	
				if(servContrMap3.containskey(ent.Entitlement.AccountId)){
					servContrMap3.get(ent.Entitlement.AccountId).add(ent.Entitlement.ServiceContract.ContractNumber);
				}
				else{
					servContrMap3.put(ent.Entitlement.AccountId, new Set<String>{ent.Entitlement.ServiceContract.ContractNumber});
				}
			}
		}
		Set<String> contrSet = new Set<String>();
		if(servContrMap3.Containskey(accId)){
			contrSet = servContrMap3.get(accId);
		}
		if(contrSet.size()>0){
			strQuery3 = strQuery3+' AND ServiceContract.ContractNumber IN: contrSet';
		}
		//******************************End*********
		if(serviceType != null && serviceType !=''){
			strQuery3 = strQuery3+' AND CH_ServiceType__c=: serviceType';
		}
		if(selectedcontractNumber != null && selectedcontractNumber !=''){
			strQuery3 = strQuery3+' AND (ServiceContract.CH_CARES_ServiceAgreement__c = :selectedcontractNumber OR ServiceContract.CH_SAP_ContractNumber__c =:selectedcontractNumber)';
		}
		listserviceContracts = database.query(strQuery3);
		
		return listserviceContracts;
	}
	
	/****************************************
* Name : getserviceContractsInactivePortal
* Description : This method returns List of Inactive hws_versionitem based on List of Account Ids
* Parameters: Contract Number, Selected Account Ids, Service type
* Returns : List of Contract line item
*****************************************/
	public static List<ContractLineItem> getserviceContractsInactivePortal(String contractNumber, String accId,String serviceType){
		list<ContractLineItem> listserviceContracts;
		String expired = 'Expired';
		String inactive = 'Inactive';
		String strQuery='SELECT Id, CH_ServiceType__c,HWS_ServiceContractName__c,HWS_ServiceContractNumber__c,ServiceContract.CH_EntitlementScript__c,CH_LineItemEntitlementScript__c, CH_QtyCoveredNetworkElementAssets__c FROM ContractLineItem '+
			'WHERE (ServiceContract.CH_CARES_ServiceAgreement__c LIKE :contractNumber OR ServiceContract.CH_SAP_ContractNumber__c LIKE :contractNumber) AND ServiceContract.AccountId =: accId';
		if(serviceType != null && serviceType !=''){
			strQuery = strQuery+' AND CH_ServiceType__c=: serviceType';
		}
		listserviceContracts = database.query(strQuery);
		
		return listserviceContracts;
	}
	
	/****************************************
* Name : getAllServiceTypes
* Description : This returns list of Assets based on the Service Type and Service Contract Number
* Parameters: Product Id, Account Id, Service Type, Service Contract Number
* Returns : List of Assets
*****************************************/
	//3697
	public static List<Asset> getAllServiceTypesPortal(Set<Id> prodIds, String accId,String serviceType, String contractNumber, Id contactId, String country){  
		String expired = 'Expired';
		String inactive = 'Inactive';
		String externalStatus = 'Active';
	   
		Boolean sync = true;
		Boolean enableForPortal = true;
		//2503 SPS Last Order Date validation started added HWS_Product_SPSLOD__c field
		// NOKIASC-25677 added CH_CountryISOName__c field for country name capturing
		//NOKIASC-36280 HWS_ContractLineItem__r.ServiceContract.HWS_PurchaserType__c
		//NOKIASC-36275:New ship to party creation for Combined Ordering(Added ServiceContract.HWS_Combined_Ordering__c field)
		//NOKIASC-37150 Added HWS_PartLEStatus__c in query and filter criteria
		String assetQuery4 = 'SELECT Id,HWS_PartLEStatus__c,HWS_ContractLineItem__r.ServiceContract.HWS_PurchaserType__c,HWS_ContractLineItem__r.HWS_PONumber__c,HWS_ContractLineItem__r.Asset.Product2.Name,HWS_ContractLineItem__r.CH_ServiceOffering__c,HWS_SourceSystem__c,HWS_Product_SPSLOD__c,HWS_SpecifiedDeliveryTargetTime__c,HWS_Service_Contract_Number__c,HWS_Currency__c,HWS_Price__c,Contract_Number__c,HWS_ContractLineItem__c,HWS_ContractLineItem__r.CH_LineItemEntitlementScript__c,HWS_ContractLineItem__r.ServiceContract.CH_EntitlementScript__c,HWS_ContractLineItem__r.ServiceContract.CH_CountryCode__c,HWS_ContractLineItem__r.ServiceContract.CH_CountryName__c,HWS_ContractLineItem__r.ServiceContract.HWS_Combined_Ordering__c,HWS_ContractLineItem__r.ServiceContractId,HWS_ContractLineItem__r.HWS_AdditionalSIInfo1__c,HWS_ContractLeadTimeUnit__c,AccountId,HWS_ContractLeadTimeDuration__c,Product2Id,Product2.Name,ProductCode,'+
			'HWS_ServiceItemCode__c,HWS_ContractLineItem__r.ServiceContract.HWS_Currency__c,HWS_ContractLineItem__r.ServiceContract.CH_ERPSystem__c,HWS_Part_Code__c,HWS_Service_Type__c,HWS_Product_Name__c, HWS_ContractLineItem__r.CH_BusinessHour__r.Id,HWS_ServiceItemDescription__c,HWS_ServiceOffering__c,HWS_High_Level_Product_Name__c, HWS_ContractLineItem__r.CH_QtyCoveredNetworkElementAssets__c, HWS_ContractLineItem__r.CH_CountryISOName__c,HWS_ContractLineItem__r.HWS_InvoicingType__c,HWS_ContractLineItem__r.HWS_WarrantyVerificationRequired__c,HWS_ContractLineItem__r.HWS_QuotationRequiredFlag__c,Product2.NokiaCPQ_State__c FROM Asset WHERE  Product2Id IN: prodIds AND AccountId =: accId AND (HWS_ContractLineItem__r.ServiceContract.NCP_External_Status__c =: externalStatus) AND (HWS_ContractLineItem__r.ServiceContract.Status =: externalStatus) AND HWS_ContractLineItem__r.CH_ServiceClassification__c=: classification AND HWS_ContractLineItem__r.NCP_External_Status__c=: externalStatus AND  HWS_ExternalStatus__c=: externalStatus AND HWS_IsSynced__c =:sync AND HWS_ContractLineItem__r.ServiceContract.CH_PortalCaseCreationHWS__c =: enableForPortal'+
			' AND HWS_PartLEStatus__c IN: SETLESTATUS'; 
		//getting only Authorized serviceContract Records
		//3697 - passing contactId  ****************Start*********
		//added  for PMD Error - NOKIASC-32425
		List<EntitlementContact> servContList4 = [select id, Entitlement.Name, Entitlement.ServiceContract.Name, Entitlement.ServiceContract.Id, Entitlement.ServiceContract.ContractNumber, Entitlement.Account.Name, Entitlement.AccountId, contact.Name, ContactId from EntitlementContact where ContactId = :contactId ];
		Map<Id, Set<String>> servContrMap = new Map<Id, Set<String>>();
		if(servContList4.size()>0){
			for(EntitlementContact ent:servContList4){	
				if(servContrMap.containskey(ent.Entitlement.AccountId)){
					servContrMap.get(ent.Entitlement.AccountId).add(ent.Entitlement.ServiceContract.ContractNumber);
				}
				else{
					servContrMap.put(ent.Entitlement.AccountId, new Set<String>{ent.Entitlement.ServiceContract.ContractNumber});
				}
			}
		}
		Set<String> contrSet4 = new Set<String>();

		if(servContrMap.Containskey(accId)){
			contrSet4 = servContrMap.get(accId);
		}
		if(contrSet4.size()>0){
			assetQuery4 = assetQuery4+' AND Contract_Number__c IN: contrSet4';
		}
	  
		//******************************End*********
		if(contractNumber != null && contractNumber!=''){
			assetQuery4 = assetQuery4+' AND HWS_Service_Contract_Number__c=: contractNumber';
		}
		if(serviceType != null && serviceType !=''){
			assetQuery4 = assetQuery4+' AND HWS_Service_Type__c=: serviceType';
		}
		// NOKIASC-25669 
		if(country != null && country !=''){
			assetQuery4 = assetQuery4+' AND HWS_ContractLineItem__r.CH_CountryISOName__c=: country';
		}
	   
		list<Asset> listAssets = database.query(assetQuery4);
	 
		
		return listAssets;
	}
	
	public static Id childRecordTypes(String serviceType){	
		Id caseRecTypeId;
		//added  for PMD Error - NOKIASC-32425
		HWS_ChildCase_Record_Types__mdt caseRecTypes = [SELECT MasterLabel,HWS_Service_Type__c,HWS_Rercord_Type__c FROM HWS_ChildCase_Record_Types__mdt where HWS_Service_Type__c=:serviceType ]; 
		caseRecTypeId = getRecordTypeByName('Case',caseRecTypes.HWS_Rercord_Type__c);
		
		return caseRecTypeId;
	}
	
	/****************************************
* Name : accountToShare
* Description : It is used to share Ship to Party account record to the portal user
* Parameters: Account Id
* Returns : boolean
* Date : 18-09-2019
*****************************************/
	public static boolean accountToShare(List<string> shipAccId){
		List<Id> chkUserAcc = new List<Id>();
		for(string st : shipAccId){
			chkUserAcc.add(Id.valueOf(st));
			
		}
		//added  for PMD Error - NOKIASC-32425
		List<UserRecordAccess> lstUserRA = [SELECT RecordId FROM UserRecordAccess WHERE UserId=:UserInfo.getUserId() AND HasReadAccess = true AND RecordId IN :chkUserAcc ];
	   
		Set<Id> accid = new Set<Id>();
		for(UserRecordAccess ura : lstUserRA){
			accid.add(ura.RecordId);
		}
	   
		// Create a new AccountShare object
		List<AccountShare> shares = new List<AccountShare>();
		//commenting unused variable - NOKIASC-32425
	   
		for (string rec : shipAccId) {  
			AccountShare accShr  = new AccountShare();
		 
			
			if(!accid.contains(Id.valueOf(rec))){
				
				accShr.AccountId = Id.valueOf(rec);
				//Set the portal user Id to share the account
				accShr.UserOrGroupId =UserInfo.getUserId();
				accShr.AccountAccessLevel  = 'Read';
				accShr.OpportunityAccessLevel = 'Read';
				accShr.RowCause = Schema.AccountShare.RowCause.Manual;
				shares.add(accShr);
			   
			}
		} 
		if(shares.size()>0){
			List<Database.SaveResult> sr = Database.insert(shares,false);
		   
			for (Integer i = 0; i < shares.size(); i++) {
				Database.SaveResult s = sr[i];
				
				
				if (!s.isSuccess()) {
				
					Database.Error err = s.getErrors()[i];
					return false;
				} 
				else{
					
					return true;
				}   
			}
		}
		return true;
	}
	
	/*************************  
Method Name : getContractlineItemsPartCodeRevision  
Description : method to get List of Assets  
Parameters: Set<Account> listAccounts,String searchValue,String serviceType, String contractNumber  
Returns : Map<String, List<Asset>>  
created for HWST-4182 as part of i4  
Created By  : Satya  
Created Date: 09/27/2019 (MM/DD/YYYY)   
Modified By :   
Modified Date:  
******************************/  
	@auraEnabled		
	public static List<Asset> getContractlineItemsPartCodeRevision(List<Account> listAccounts,String searchValue,String serviceType, String contractNumber, String contactId, String fromType, String  country ){   
		List<Asset> lCli = new List<Asset>();   
		Set<Id> prodIds = new Set<Id>();		
		Set<Id> accIds = new Set<Id>();  
		for(Account a : listAccounts){  
			accIds.add(a.Id);   
		}   
		String searchCode = searchValue.replaceAll('[^a-zA-Z0-9]', '').toUpperCase();
		//added  for PMD Error - NOKIASC-32425
		List<HWS_VersionItem__c> verItemList = [Select Id, HWS_Part_Code_Part_Revision__c, HWS_Version_Code__c, HWS_Hardware_Sellable_Item__c, HWS_Hardware_Sellable_Item__r.CARE_PartCode__c from HWS_VersionItem__c where HWS_Part_Code_Part_Revision__c =:searchCode ];  
		
		if(verItemList .size()>0){  
			for(HWS_VersionItem__c vi: verItemList ){   
				if(vi.HWS_Hardware_Sellable_Item__c != null ){  
					prodIds.add(vi.HWS_Hardware_Sellable_Item__c);  
				}   
			}   
			if(!(prodIds.isEmpty() && accIds.isEmpty())){   
				if(fromType == 'Console'){  
					lCli = getAllServiceTypes(prodIds, accIds,serviceType,contractNumber,contactId, country);   
				}   
				if(fromType == 'Portal'){   
					lCli = getAllServiceTypesPortal(prodIds, listAccounts[0].Id,serviceType,contractNumber,contactId, country);  
				}   
			}   
		}   
		else{   
			Set<String> partCodeSet = new Set<String>();	  
			//added  for PMD Error - NOKIASC-32425
			String searchString = searchValue.substring(0,4).toUpperCase();
			searchString = searchString+'%';
			List<Asset> astList = [select id, HWS_Part_Code__c, HWS_Service_Type__c, Product2Id from Asset where AccountId =:accIds and HWS_Part_Code__c like: searchString and HWS_ContractLineItem__r.ServiceContract.NCP_External_Status__c = 'Active' AND HWS_ContractLineItem__r.CH_ServiceClassification__c='HWS Service' AND HWS_ContractLineItem__r.NCP_External_Status__c='Active' AND HWS_ExternalStatus__c='Active' AND HWS_IsSynced__c =true ];  
			Set<String> assetPaerCodeSet = new Set<String>();   
			if(astList.size()>0){   
				for(Asset ast :astList){		
					assetPaerCodeSet.add(ast.HWS_Part_Code__c);  
				}   
				for(integer i =0;i<searchValue.length();i++){   
					String sc = searchValue.substring(0, searchValue.length()-i).toUpperCase();  
					if(sc.length() >=4 && assetPaerCodeSet.contains(sc)){   
						
						partCodeSet.add(sc);		
								
						continue;   
					}   
				}   
				if(partCodeSet.size()>0){   
					for(Asset ast :astList){		
						if(partCodeSet.contains(ast.HWS_Part_Code__c)){  
							prodIds.add(ast.Product2Id);		
						}   
					}   
				}   
			}   
			Set<Id> prodIdSetwithANYvi = new Set<Id>();  
			//added  for PMD Error - NOKIASC-32425
			List<HWS_VersionItem__c> viList = [SELECT HWS_Version_Code__c, HWS_Hardware_Sellable_Item__c FROM HWS_VersionItem__c where HWS_Hardware_Sellable_Item__c IN :prodIds And HWS_Version_Code__c = 'ANY' ]; 
			if(viList.size()>0){		
				for(HWS_VersionItem__c vi:viList){  
					prodIdSetwithANYvi.add(vi.HWS_Hardware_Sellable_Item__c);   
				}   
			}   
			if(!(prodIdSetwithANYvi.isEmpty() && accIds.isEmpty())){		
				if(fromType == 'Console'){  
					lCli = getAllServiceTypes(prodIdSetwithANYvi, accIds,serviceType,contractNumber,contactId, country);		
				}   
				if(fromType == 'Portal'){   
					lCli = getAllServiceTypesPortal(prodIdSetwithANYvi, listAccounts[0].Id,serviceType,contractNumber,contactId, country);  
				}   
			}   
		}   
		return lCli;		
	}
	// NOKIASC-37920 | This method will only called from bulk | Start
	public static plannedDeliveryDateWrapper accountTimeZoneplannedDeliveryDateTime(List<Case> listChildCases, String selectedAccountTimeZone, Boolean isCallFromBulk ){
		HWS_Utilty.isCallFromBulkRequest = isCallFromBulk;
		return accountTimeZoneplannedDeliveryDateTime(listChildCases, selectedAccountTimeZone);

	}
	// NOKIASC-37920 | This method will only called from bulk | End
	//Added by Ajesh - Start
	public static plannedDeliveryDateWrapper accountTimeZoneplannedDeliveryDateTime(List<Case> listChildCases, String selectedAccountTimeZone ){
		plannedDeliveryDateWrapper pdw;
		List<PicklistEntry> bhTimeZoneList = Schema.SObjectType.BusinessHours.fields.TimeZoneSidKey.picklistvalues; 
	   
		
		
		List<Case> timeZoneupdatedCaseList = new List<Case>();
		List<Id> assetIds = new List<Id>();
		//commenting unused variable - NOKIASC-32425
		
		Map<Id,BusinessHours> assetIdBusiness = new Map<Id, BusinessHours>();
		List<String> notListedBH = new List<String>();
		Map<Id,Asset> IdAssetMap = new Map<Id, Asset>();
		Map<String,String> bhTimeZoneSidKeyMap = new Map<String,String>();
		String bhTimeZoneSidKey;
		String bhTimeZone;
		if(listChildCases.size()>0){
			for(Case caseRec : listChildCases){
				assetIds.add(caseRec.AssetId); 
			}
			//added  for PMD Error - NOKIASC-32425
			List<Asset> listAssets = [Select Id, HWS_ContractLineItem__r.CH_BusinessHour__c, HWS_ContractLeadTimeUnit__c, HWS_ContractLeadTimeDuration__c, HWS_SpecifiedDeliveryTargetTime__c from Asset where Id In:assetIds ];
			for(Asset assetRec: listAssets){
				
				assetIdBusiness.put(assetRec.Id,getBusinessHourMap.get(assetRec.HWS_ContractLineItem__r.CH_BusinessHour__c));
			   
				IdAssetMap.put(assetRec.Id,assetRec);
			}
			for(PicklistEntry p : bhTimeZoneList){
				bhTimeZoneSidKeyMap.put(p.getValue(),p.getLabel()); 
			}
			for(Case caseRec : listChildCases){
				string bussinessHourName = '';
				if(assetIdBusiness.get(caseRec.AssetId) !=null){
					bussinessHourName = assetIdBusiness.get(caseRec.AssetId).Name;
				}
			   
			   
				if(bussinessHourName != '24x7' && selectedAccountTimeZone != '24x7' && selectedAccountTimeZone != null){
					String st1 = bussinessHourName.substringAfter('|');
					String st2 = st1.substringBetween('| ',' |');
					String bussinessHourNameAccTimeZone = '';
					if(bussinessHourName != '' && bussinessHourName != null && st2 != '' && st2!= null){
					  bussinessHourNameAccTimeZone = bussinessHourName.replace(st2, selectedAccountTimeZone);
					}
					
					if(bhNameIdMap.get(bussinessHourNameAccTimeZone) != Null){
						caseRec.HWS_Delivery_TimeZone__c = selectedAccountTimeZone;
						caseRec.BusinessHoursId = bhNameIdMap.get(bussinessHourNameAccTimeZone);
					}else{
						String s1 = bussinessHourName.substringAfter('|');
						String s2 = s1.substringBetween('| ',' |');
						caseRec.HWS_Delivery_TimeZone__c = s2;
						caseRec.BusinessHoursId = bhNameIdMap.get(bussinessHourName);
						notListedBH.add(bussinessHourNameAccTimeZone);
					}
					bhTimeZoneSidKey = bhTimezoneIdMap.get(bussinessHourName);
					bhTimeZone = bhTimeZoneSidKeyMap.get(bhTimeZoneSidKey);
				}else if(bussinessHourName == '24x7'){
					
					caseRec.HWS_Delivery_TimeZone__c = 'GMT';
					if(selectedAccountTimeZone!=null && selectedAccountTimeZone !=''){
						caseRec.HWS_Delivery_TimeZone__c =selectedAccountTimeZone;
						
					}
					caseRec.BusinessHoursId = bhNameIdMap.get(bussinessHourName);
					bhTimeZoneSidKey = bhTimezoneIdMap.get(bussinessHourName);
					bhTimeZone = bhTimeZoneSidKeyMap.get(bhTimeZoneSidKey);
				}else{  
					String str1 = bussinessHourName.substringAfter('|');	
					String str2 = str1.substringBetween('| ',' |'); 
					caseRec.HWS_Delivery_TimeZone__c = str2;	
					caseRec.BusinessHoursId = bhNameIdMap.get(bussinessHourName);   
					bhTimeZoneSidKey = bhTimezoneIdMap.get(bussinessHourName);  
					bhTimeZone = bhTimeZoneSidKeyMap.get(bhTimeZoneSidKey); 
				}
			   
				timeZoneupdatedCaseList.add(caseRec); 
			}
			
			
			pdw = plannedDeliveryDateTimeCalculation(timeZoneupdatedCaseList,IdAssetMap,bhTimeZone);
		}
		
		if (!notListedBH.isEmpty()){
			HWS_postToChatterForBH(notListedBH);
		}
		return pdw;
		
	}
	//Added by Ajesh - END
	public static Map<Id, BusinessHours> getBusinessHouDetails() {
		//added  for PMD Error - NOKIASC-32425
		listBusinessHours = [SELECT Id,TimeZoneSidKey,Name FROM BusinessHours ];
	  
		for(BusinessHours bs : listBusinessHours){
			busMap.put(bs.Id, bs);
			bhNameIdMap.put(bs.Name, bs.Id);
			bhTimezoneIdMap.put(bs.Name, bs.TimeZoneSidKey);
		}
		return busMap;  
	}
	//Added by Ajesh - Start
	public static plannedDeliveryDateWrapper plannedDeliveryDateTimeCalculation(List<Case> timeZoneupdatedCaseList, Map<Id,Asset> IdAssetMap, String bhTimeZone){
		List<Case> newTimeZoneCaseList = new List<Case>();  
		String delTimeZone = bhTimeZone;
		for(Case caseRec : timeZoneupdatedCaseList){
			if(IdAssetMap.get(caseRec.AssetId) != null){ // NOKIASC-37921
	DateTime plannedDatetime = plannedDeliveryDateTime(caseRec.BusinessHoursId, IdAssetMap.get(caseRec.AssetId).HWS_ContractLeadTimeUnit__c, IdAssetMap.get(caseRec.AssetId).HWS_ContractLeadTimeDuration__c, null, IdAssetMap.get(caseRec.AssetId).HWS_SpecifiedDeliveryTargetTime__c);
	caseRec.HWS_Planned_Delivery_Date__c = plannedDatetime; 
	  
	if(bhTimeZone!='24x7' && bhTimeZone!=null){ //commenting unused variable - NOKIASC-32425
		
		delTimeZone = bhTimeZone.substring(0,12);
		string strTimeZone = caseRec.HWS_Delivery_TimeZone__c;
	   
		//NOKIASC-37920 | ByPassing user formatted locale value in HWS_PlannedDeliveryDateShipment__c field for bulk request| isCallFromBulkRequest is true if it is a bulk request | Start
		string strCurrentTime = '';				
		if(HWS_Utilty.isCallFromBulkRequest){
			strCurrentTime = plannedDatetime.format('dd MMM YYYY HH:mm:ss a', strTimeZone);  
			caseRec.HWS_PlannedDeliveryDateShipment__c= strCurrentTime+' ( '+caseRec.HWS_Delivery_TimeZone__c+' )';   
		}
		else{
			strCurrentTime = plannedDatetime.format('YYYY-MM-dd HH:mm:ss', strTimeZone);
			caseRec.HWS_PlannedDeliveryDateShipment__c= strCurrentTime;
		}
		//NOKIASC-37920 | ByPassing user formatted locale value in HWS_PlannedDeliveryDateShipment__c field | End
	}
	Id businessHourId = caseRec.BusinessHoursId;
	String bsName = '';
	if(busMap.get(businessHourId) !=null){
		bsName = busMap.get(businessHourId).Name;
	}
	  
	if(bsName == '24x7'){
		string strTimeZone = caseRec.HWS_Delivery_TimeZone__c;
		
		string strCurrentTime = plannedDatetime.format('YYYY-MM-dd HH:mm:ss', strTimeZone);
		DateTime customerDateTime = DateTime.valueofGmt(strCurrentTime);
		TimeZone customerTimeZone = TimeZone.getTimeZone(strTimeZone);
		Integer offsetToCustomersTimeZone = customerTimeZone.getOffset(customerDateTime);
		Double gmtOffset = offsetToCustomersTimeZone / (1000 * 60 *60);
	  
		delTimeZone = getGmtValue(gmtOffset);
	}
	newTimeZoneCaseList.add(caseRec); 
			} //NOKIASC-37921
		}
		plannedDeliveryDateWrapper pw = new plannedDeliveryDateWrapper(newTimeZoneCaseList,delTimeZone);
		return pw;
	}
	//Added by Ajesh - End
	public class plannedDeliveryDateWrapper {
		@AuraEnabled
		public List<Case> newTimeZoneCaseList {get; set;}
		@AuraEnabled
		public String bhTimeZone {get; set;}   
		public plannedDeliveryDateWrapper(List<Case> newTimeZoneCaseList,String bhTimeZone){
			this.newTimeZoneCaseList = newTimeZoneCaseList;
			this.bhTimeZone = bhTimeZone;
		}
	}
	//Added by Kunal-Start
	//@future(callout = true)
	public static Map<Id,String> updateTimeZone(ID accID){
		Map<Id,String> accIDTimeZone = new Map<Id, String>();
		if(accID != null ) {
			//added  for PMD Error - NOKIASC-32425
			List < Account > accList = [SELECT Id, AccountNumber, BillingStreet, BillingCity, BillingPostalCode, BillingState, BillingCountry, HWS_TimeZone__c, CH_AccountRecordTypeName__c FROM Account WHERE ID = :accID AND CH_AccountRecordTypeName__c = 'Logistic_Account' ];
			if(!accList.isEmpty()){
				accIDTimeZone.put(accID,accList[0].HWS_TimeZone__c);
			}
			List < Account > newAccList = new List < Account > ();
			if(accList.size() > 0 && (accList[0].HWS_TimeZone__c == null || accList[0].HWS_TimeZone__c == '')) {
				
				try {
					Map<String, Object> result = CH_LocationUtils.getCoordinates(accList[0].BillingStreet,accList[0].BillingCity,accList[0].BillingPostalCode,accList[0].BillingState,accList[0].BillingCountry);
					Map<String, Object> coordinates = (Map<String, Object>) ((Map<String, Object>) result.get('geometry')).get('location');
					string HWS_TZ = CH_LocationUtils.getTimeZone(coordinates);
				   
					Account AccObj = (accList[0]).clone(true, true, false, true);
					AccObj.HWS_TimeZone__c = HWS_TZ;
					newAccList.add(AccObj);
					accIDTimeZone.put(accID,HWS_TZ);
					if(!newAccList.isEmpty()) {
						Database.SaveResult[] srList = Database.update(newAccList, false);
						// Iterate through each returned result
						for (Database.SaveResult sr : srList) {
							if (!sr.isSuccess()) {
								// Operation failed, so get all errors  
								for(Database.Error err : sr.getErrors()) {
									System.debug('#### Exception occurred at HWS_ShipToAddressTimeZone.HWS_UpdateTimeZone ### ' + err.getMessage());
								}
							}
						}
					}
				}   
				catch(Exception ex) {
					
					//NOKIASC-31158 -- Add more details to chatter feed message like Address and Account if the google API unable to identify a particular ship to party
					if(accList.size() > 0 && (accList[0].HWS_TimeZone__c == null || accList[0].HWS_TimeZone__c == '')) {
						HWS_postGoogleErrorToChatter('Failed to identify the below ShipToParty address correctly:'+'\nShip-to-Party Account Number : '+accList[0].AccountNumber+'\nBilling Street : '+accList[0].BillingStreet+'\nBilling City : '+accList[0].BillingCity+'\nBilling PostalCode : '+accList[0].BillingPostalCode+'\nBilling State : '+accList[0].BillingState+'\nBilling Country : '+accList[0].BillingCountry);
					}
					
				}
			   
			}
		}
		return accIDTimeZone;
	}
	//Added by Kunal- End
	
	//Prateek
	public static void HWS_postToChatterForBH(List<String> businessHourNameList){
		try{
			//added  for PMD Error - NOKIASC-32425
			List<CollaborationGroup> oCollaborationGroupList = [SELECT Id FROM CollaborationGroup WHERE Name = 'Error - BH Conversion'  LIMIT 1];
			List<FeedItem> posts = new List<FeedItem>();
			for(String s : businessHourNameList){
				FeedItem post = new FeedItem();
				if(!oCollaborationGroupList.isEmpty()){
					post.ParentId = oCollaborationGroupList.get(0).Id;
				}
				post.Body = 'Failed to identify a singe Business Hours with the name : '+s+'. ';  
				posts.add(post);  
			}
			if(!oCollaborationGroupList.isEmpty()){
				insert posts;
			}
		}
		catch(Exception e) { 
			System.debug(LoggingLevel.DEBUG,e.getMessage());
		   
		}
			
	}
	
	//post any error from Google API to chatter
	//NOKIASC-25684
	//Prateek
	public static void HWS_postGoogleErrorToChatter(String errorMsg){
		try{
			//added  for PMD Error - NOKIASC-32425
			List<CollaborationGroup> oCollaborationGroupList = [SELECT Id FROM CollaborationGroup WHERE Name = 'Error - BH Conversion'  LIMIT 1];
			FeedItem post = new FeedItem();
			post.Body = errorMsg;
			if(!oCollaborationGroupList.isEmpty()){
				post.ParentId = oCollaborationGroupList.get(0).Id;
				insert post;
			}
		}
		catch(Exception e) { 
			System.debug(LoggingLevel.DEBUG,e.getMessage());
			
		}
	}
	
	
	/*************************
Method Name : getNetworkElementAssets
User Story : NOKIASC-32950
Description : This method created for NEA Performance issue.
Created By  : TCS
Created Date: 26/11/2020 (MM/DD/YYYY)
Modified By :
Modified Date:
******************************/  
	public static HWS_NetworkElementAssetWrapper.AssetPagerWrapper getNetworkElementAssets(Id accId, Id cliId,List<Id> cliIdList,Integer recordLimit, Integer recordOffset,String searchText){	  
		HWS_NetworkElementAssetWrapper.AssetPagerWrapper assetPagerWrapper =  new HWS_NetworkElementAssetWrapper.AssetPagerWrapper();	   
		   
		String neaRectypeId = Schema.getGlobalDescribe().get('Asset').getDescribe().getRecordTypeInfosByDeveloperName().get('CH_NetworkElementAsset').getRecordTypeId();
		String cneaStatus = 'Active';		  
		String neaAssetQuery = 'Select Id,Name, CH_LabEnvironment__c,CH_NetworkElementID__c, ';
		neaAssetQuery = neaAssetQuery+ ' Product2.Name, Product2Id,CH_Solution__c,CH_ProductVariant__c, CH_ProductRelease__c, ';
		neaAssetQuery = neaAssetQuery+ ' Address__r.CH_AddressDetails__c,CH_CountryISOName__c,CH_ContractLineItem__c, ';
		neaAssetQuery = neaAssetQuery+ ' CH_ProductVariant__r.Name, CH_Solution__r.Name, CH_ProductRelease__r.Name,(Select id,CH_ContractLineItem__c from Network_Element_Assets__r)  ';
		neaAssetQuery = neaAssetQuery+ ' FROM Asset where recordTypeId=:neaRectypeId ' ;
		neaAssetQuery = neaAssetQuery+ ' AND Id IN (SELECT CH_NetworkElementAsset__c from CH_CoveredNetworkElementAsset__c WHERE' ;
		if(!cliIdList.isEmpty() && cliId == null){
			neaAssetQuery = neaAssetQuery+' CH_ContractLineItem__c IN :cliIdList ';
		}
		else if(cliId != null){
			neaAssetQuery = neaAssetQuery+' CH_ContractLineItem__c = :cliId ';
		}
		neaAssetQuery = neaAssetQuery+' AND CH_Status__c = :cneaStatus)';
		if(!String.isBlank(SearchText)){
			SearchText = '%'+SearchText+'%';
			neaAssetQuery = neaAssetQuery+ ' AND ( CH_NetworkElementID__c LIKE  \''+SearchText+'\' ';
			neaAssetQuery = neaAssetQuery+ ' OR Name LIKE \''+SearchText+'\' ';					 
			neaAssetQuery = neaAssetQuery+ ' OR Address__r.Street LIKE \''+SearchText+'\' ';
			neaAssetQuery = neaAssetQuery+ ' OR Address__r.postalcode LIKE \''+SearchText+'\' ';
			neaAssetQuery = neaAssetQuery+ ' OR Address__r.Country LIKE \''+SearchText+'\' ';
			neaAssetQuery = neaAssetQuery+ ' OR CH_Solution__r.Name LIKE \''+SearchText+'\' ';
			neaAssetQuery = neaAssetQuery+ ' OR CH_ProductVariant__r.Name LIKE \''+SearchText+'\' ';
			neaAssetQuery = neaAssetQuery+ ' OR CH_ProductRelease__r.Name LIKE \''+SearchText+'\' ';  
			neaAssetQuery = neaAssetQuery+ ' OR CH_CountryISOName__c LIKE \''+SearchText+'\' ';  
			neaAssetQuery = neaAssetQuery+  ' ) ';
		} 
		neaAssetQuery = neaAssetQuery+ '  ORDER BY Id  ';
	 
		System.debug('neaAssetQuery : ' + neaAssetQuery);
		System.debug('neaRectypeId : ' + neaRectypeId);
		System.debug('cliId : ' + cliId);
		assetPagerWrapper.networkEleAssests = database.query(neaAssetQuery);
		return assetPagerWrapper;
	}
	public static String getGmtValue(Double offsetvalue){
		String gmtValue = '';
		if(offsetvalue!=null){
			if(offsetvalue == 0){gmtValue='(GMT+00:00)';}
			if(offsetvalue == 1){gmtValue='(GMT+01:00)';}
			if(offsetvalue == 2){gmtValue='(GMT+02:00)';}
			if(offsetvalue == 3){gmtValue='(GMT+03:00)';}
			if(offsetvalue == 4){gmtValue='(GMT+04:00)';}
			if(offsetvalue == 5){gmtValue='(GMT+05:00)';}
			if(offsetvalue == 6){gmtValue='(GMT+06:00)';}
			if(offsetvalue == 7){gmtValue='(GMT+07:00)';}
			if(offsetvalue == 8){gmtValue='(GMT+08:00)';}
			if(offsetvalue == 9){gmtValue='(GMT+09:00)';}
			if(offsetvalue == 10){gmtValue='(GMT+10:00)';}
			if(offsetvalue == 11){gmtValue='(GMT+11:00)';}
			if(offsetvalue == 12){gmtValue='(GMT+12:00)';}
			if(offsetvalue == -0){gmtValue='(GMT+00:00)';}
			if(offsetvalue == -1){gmtValue='(GMT-01:00)';}
			if(offsetvalue == -2){gmtValue='(GMT-02:00)';}
			if(offsetvalue == -3){gmtValue='(GMT-03:00)';}
			if(offsetvalue == -4){gmtValue='(GMT-04:00)';}
			if(offsetvalue == -5){gmtValue='(GMT-05:00)';}
			if(offsetvalue == -6){gmtValue='(GMT-06:00)';}
			if(offsetvalue == -7){gmtValue='(GMT-07:00)';}
			if(offsetvalue == -8){gmtValue='(GMT-08:00)';}
			if(offsetvalue == -9){gmtValue='(GMT-09:00)';}
			if(offsetvalue == -10){gmtValue='(GMT-10:00)';}
			if(offsetvalue == -11){gmtValue='(GMT-11:00)';}
			if(offsetvalue == -12){gmtValue='(GMT-12:00)';}
			if(offsetvalue > 0 && offsetvalue < 1 ){gmtValue='(GMT+00:30)';}
			if(offsetvalue > 1 && offsetvalue < 2 ){gmtValue='(GMT+01:30)';}
			if(offsetvalue > 2 && offsetvalue < 3 ){gmtValue='(GMT+02:30)';}
			if(offsetvalue > 3 && offsetvalue < 4 ){gmtValue='(GMT+03:30)';}
			if(offsetvalue > 4 && offsetvalue < 5 ){gmtValue='(GMT+04:30)';}
			if(offsetvalue > 5 && offsetvalue < 6 ){gmtValue='(GMT+05:30)';}
			if(offsetvalue > 6 && offsetvalue < 7 ){gmtValue='(GMT+06:30)';}
			if(offsetvalue > 7 && offsetvalue < 8 ){gmtValue='(GMT+07:30)';}
			if(offsetvalue > 8 && offsetvalue < 9 ){gmtValue='(GMT+08:30)';}
			if(offsetvalue > 9 && offsetvalue < 10 ){gmtValue='(GMT+09:30)';}
			if(offsetvalue > 10 && offsetvalue < 11 ){gmtValue='(GMT+10:30)';}
			if(offsetvalue > 11 && offsetvalue < 12 ){gmtValue='(GMT+11:30)';}
			if(offsetvalue > -1 && offsetvalue < 0 ){gmtValue='(GMT-00:30)';}
			if(offsetvalue > -2 && offsetvalue < -1 ){gmtValue='(GMT-01:30)';}
			if(offsetvalue > -3 && offsetvalue < -2 ){gmtValue='(GMT-02:30)';}
			if(offsetvalue > -4 && offsetvalue < -3 ){gmtValue='(GMT-03:30)';}
			if(offsetvalue > -5 && offsetvalue < -4 ){gmtValue='(GMT-04:30)';}
			if(offsetvalue > -6 && offsetvalue < -5 ){gmtValue='(GMT-05:30)';}
			if(offsetvalue > -7 && offsetvalue < -6 ){gmtValue='(GMT-06:30)';}
			if(offsetvalue > -8 && offsetvalue < -7 ){gmtValue='(GMT-07:30)';}
			if(offsetvalue > -9 && offsetvalue < -8 ){gmtValue='(GMT-08:30)';}
			if(offsetvalue > -10 && offsetvalue < -9 ){gmtValue='(GMT-09:30)';}
			if(offsetvalue > -11 && offsetvalue < -10 ){gmtValue='(GMT-10:30)';}
			if(offsetvalue > -12 && offsetvalue < -11 ){gmtValue='(GMT-11:30)';}
		}
		return gmtValue;
	}
	/****************************************
* Name : getCasesByCaseNumber
* Description : returns List of Cases
* Parameters: List of CaseNumbers
* Returns : List Of Cases
* written on 17th Sep 2020
* By Satya Pagadala
* User Story : NOKIASC-31177
*****************************************/
	@auraEnabled
	public static List<Case> getCasesByCaseNumber(List<String> caseNumberLst){
		List<Case> caseLst = [Select Id,CaseNumber,RecordType.DeveloperName,RecordTypeId, AccountId, CH_ServiceType__c, CH_RecordTypeCheck__c from Case where CaseNumber IN :caseNumberLst];		
		return caseLst;	 
	}
	/****************************************
* Name : warrantyCheck
* Description : returns Warranty Status
* Parameters: Material Code, Faulty Unit Serial Number, Source System
* Returns : Warranty Status
* written on 21st Oct 2020
* User Story : NOKIASC-32212 & NOKIASC-32213
*****************************************/
	public static string warrantyCheck(String materialCode,String serialNumber,String sourceSystem) {	   
		return HWS_CheckWarranty_SVC.getWarrentStatus(materialCode,serialNumber,sourceSystem);
	}
	/****************************************
* Name : cancelChildCases
* Description : This is a generic class used for cancelChildCases for Console and portal
* Created by:Afif
* Returns : List of String
* written on 04 Nov 2020
* User Story : NOKIASC-32416
*****************************************/
	
	@auraEnabled
	public static List<String> cancelChildCases(String casId,String cancelReason,String reasonForCancel,String platform){	
		List<String> caseList = new List<String>(); 
		List<Case> caseList2 = new List<Case>();
		List<Case> orderChildCases = new List<Case>();
		try{
			//US-1409 Used to capture parentcaseId when user clicks "Cancel" button on parent
			id parentCaseIdToSend;
			HWS_BypassStatusChangeValidation__c custSetting= HWS_BypassStatusChangeValidation__c.getInstance(); 
			Id getParentCasId=Id.valueOf(casId);  
			if(custSetting == null){
				custSetting = new HWS_BypassStatusChangeValidation__c();
			}
			//added  for PMD Error - NOKIASC-32425
			List<case> lstCase = [Select id,parentId,Status,HWS_CancelConfirm__c,Cancellation_Reason__c from Case where Status != 'Cancelled' AND (parentId=:getParentCasId OR id=:getParentCasId) ];
			Id orderedPraentId;
			if(!lstCase.isEmpty()){
				
				if(lstCase.size()>1){
					// result will come parent and child records
					for(Case c : lstCase){
						
						//get the parent Id
						if(c.parentId != null && c.status == 'Ordered'){
							orderedPraentId = c.parentId;
							orderChildCases.add(c);
						   
						}
						else if(c.Status == 'On Hold' || c.Status == 'Draft' || c.Status == 'New'){
							custSetting.HWS_BypassCaseStatusValidation__c = true;
							
							caseList.add(c.status);
							c.Status= 'Cancelled';
							if(platform=='console'){
								c.Cancellation_Reason__c = cancelReason;
								c.CH_ReasonForCancellation__c = reasonForCancel; 
							}
							else if (platform=='portal'){
								
								c.Cancellation_Reason__c=HWS_Constants.REQUESTED_BY_CUSTOMER;//NOKIASC-31917
							}
							
							caseList2.add(c); 
						}
						else if(c.Status == 'Shipped' || c.Status == 'Delivered' || c.Status == HWS_Constants.PARTIALLY_SHIPPED) {
							caseList.add(c.status);
						}
						else if(c.Status == HWS_Constants.REQUEST_TO_CANCEL ){caseList.add('child'+c.status);}
					}
					if(orderedPraentId != null)
					{
						custSetting.HWS_BypassCaseStatusValidation__c = true;
						// Passing Other method to make callout
						HWS_CancelcaseSendSRtoSOO_SVC.processResponse pr= HWS_CancelcaseSendSRtoSOO_SVC.sendToSOO(orderedPraentId,null);
						
						if(!pr.isError){
							for(case c : orderChildCases){
								if(c.HWS_CancelConfirm__c == 'No')
								{
									c.HWS_CancelConfirm__c =  HWS_Constants.RETRIED_TO_CANCEL;
								}
								if(platform=='console'){
									c.Cancellation_Reason__c = cancelReason;
									c.CH_ReasonForCancellation__c = reasonForCancel; 
								}
								else if (platform=='portal'){		   
									c.Cancellation_Reason__c=HWS_Constants.REQUESTED_BY_CUSTOMER;//NOKIASC-31917
								}
								
								c.Status = HWS_Constants.REQUEST_TO_CANCEL;
								caseList.add(c.status);
								caseList2.add(c); 
								parentCaseIdToSend = c.parentId;
								
								
							}
						}
						else{
							for(case c : orderChildCases){
								if(c.HWS_CancelConfirm__c == 'No')
								{
									c.HWS_CancelConfirm__c =  HWS_Constants.RETRIED_TO_CANCEL;
								}
								c.Status = 'Ordered';
								caseList.add(c.status);
								caseList2.add(c); 
								
								
							}
						}
					}
				}
				else{
					if(lstCase[0].status == 'Ordered'){
						HWS_CancelcaseSendSRtoSOO_SVC.processResponse pr = HWS_CancelcaseSendSRtoSOO_SVC.sendToSOO(lstCase[0].parentId,lstCase[0].Id);
						custSetting.HWS_BypassCaseStatusValidation__c = true;
						if(lstCase[0].HWS_CancelConfirm__c == 'No')
						{
							lstCase[0].HWS_CancelConfirm__c =  HWS_Constants.RETRIED_TO_CANCEL;
						}
						if(!pr.isError){
							
							lstCase[0].Status = HWS_Constants.REQUEST_TO_CANCEL;
							if(platform=='console'){
								lstCase[0].Cancellation_Reason__c = cancelReason;
								lstCase[0].CH_ReasonForCancellation__c = reasonForCancel;
							}
							else if (platform=='portal'){
								lstCase[0].Cancellation_Reason__c=HWS_Constants.REQUESTED_BY_CUSTOMER;//NOKIASC-31917
							}
							caseList.add(lstCase[0].status);
							caseList2.add(lstCase[0]); 
							parentCaseIdToSend = lstCase[0].parentId;
						}
						else{
							lstCase[0].Status = 'Ordered';
							caseList.add(lstCase[0].status);
							caseList2.add(lstCase[0]); 
						}
						
					}
					else if(lstCase[0].Status == 'On Hold' || lstCase[0].Status == 'Draft' || lstCase[0].Status == 'New'){
						custSetting.HWS_BypassCaseStatusValidation__c = true;
						
						caseList.add(lstCase[0].status);
						if(platform=='console'){
							lstCase[0].Cancellation_Reason__c = cancelReason;
							lstCase[0].CH_ReasonForCancellation__c = reasonForCancel;
						}
						else if (platform=='portal'){
							lstCase[0].Cancellation_Reason__c=HWS_Constants.REQUESTED_BY_CUSTOMER;//NOKIASC-31917
						}
						lstCase[0].Status= 'Cancelled';
						caseList2.add(lstCase[0]); 
					}
					else if((lstCase[0].Status == 'Shipped' || lstCase[0].Status == 'Delivered' || lstCase[0].Status == HWS_Constants.PARTIALLY_SHIPPED) && platform=='console'){
						caseList.add('child'+lstCase[0].status);
					}
					else if((lstCase[0].Status == 'Shipped' || lstCase[0].Status == 'Delivered' || lstCase[0].Status == HWS_Constants.PARTIALLY_SHIPPED || lstCase[0].Status == 'Closed' || lstCase[0].Status == 'Cancelled') && platform=='portal'){
						caseList.add('child'+lstCase[0].status);
					}
					else if(lstCase[0].Status == HWS_Constants.REQUEST_TO_CANCEL ){
						caseList.add('child'+lstCase[0].status);
					}
				}
			}
			if(custSetting != null ) {
				upsert custSetting;
			}
			if(!caseList2.isEmpty()){
				
				Database.update(caseList2);
				custSetting.HWS_BypassCaseStatusValidation__c = false;
			}
			if(custSetting!=null){
				update custSetting;
			}
			return caseList;
		}
		
		Catch(Exception e){
			System.debug(LoggingLevel.DEBUG,'Error in CancelCase***'+e.getMessage() +'on line number ' +e.getLineNumber() + ' '+ e.getCause());
			return null;
		}
	}
	//32414
	//method to findout duplicate falty unit serial for each material code  
	@auraEnabled
	public static list<Case> duplicateSerialNumberInfo(string serialNumber, string materialCode){	 
		List<Case> caselist = new List<Case>();
		try{
			caselist = [Select id,HWS_Faulty_Serial_Number__c,CaseNumber,Status From Case 
						where (status Not in:childCaseStatusesforDuplicte ) AND Asset.HWS_Part_Code__c =: materialCode 
						AND HWS_Faulty_Serial_Number__c =: serialNumber AND HWS_Faulty_Serial_Number__c !=null AND HWS_Faulty_Serial_Number__c !='UNKNOWN' limit 1];
		} catch(queryException qe){
		   
			throw new AuraHandledException(String.valueOf(qe.getMessage()));
		}	 
		return caselist ;
	}
	
	/****************************************32414
* Name : getContractlineItems
* Description : method to get List of Assets
* Parameters: List<Account> listAccounts,String searchValue,String serviceType, String contractNumber
* Returns : Map<String, List<Asset>>
*****************************************/
	//3697 - passing contactId
	@auraEnabled
	public static Map<String, List<Asset>> getContractlineItems(String accountId, String searchValue, String serviceType, String contractNumber, Id contactId, String country, String consolePortal){   
		String searchCode = searchValue +'%';
		String itemDesc = '%'+searchValue +'%';
		List<Asset> lCli = new List<Asset>();
		Map<String, List<Asset>> mapContractLine = new Map<String, List<Asset>>();  
	   
		Id salesProduct = HWS_Utilty.getRecordTypeByName('Product2',HWS_Constants.SALES_PRODUCT);
		//34072 & 34073
		
		List<HWS_AlternateProductCode__c> altVersionItemsLst = [SELECT Id,HWS_Part__c,HWS_VersionItem__r.HWS_Hardware_Sellable_Item__r.Id, Name, HWS_AlternateCodeType__c, HWS_EDP_DeletedAtSource__c
																FROM HWS_AlternateProductCode__c 
																WHERE Name LIKE:searchCode AND HWS_AlternateCodeType__c !='CARESID'];  
						  
		//HWST-2965 checked HWS_OEM_manufacturer_part_code__c field 
		List<Product2> relatedProds = [SELECT Id, ProductCode 
									   FROM Product2 
									   WHERE RecordTypeId =: salesProduct 
									   AND HWS_DoNotConsider__c = false AND (ProductCode LIKE:searchCode OR Name LIKE:itemDesc OR HWS_OEM_manufacturer_part_code__c LIKE : searchCode OR CARE_PartCode__c LIKE:searchCode)];
			
		Set<Id> prodIds = new Set<Id>();
		Boolean kitCodesearch = false;
		//NOKIASC-35560
		Set<Id> kitProdIds = new Set<Id>();
		Boolean allkitRelProd =false;
		if(altVersionItemsLst.size()<=0 && relatedProds.size()<=0){
			mapContractLine.put('Error Message1',lCli);
		}else{
			if(!altVersionItemsLst.isEmpty()){
				for(HWS_AlternateProductCode__c pd : altVersionItemsLst){
		if(pd.HWS_Part__c !=null && pd.HWS_EDP_DeletedAtSource__c == false){
			kitCodesearch = true;
			prodIds.add(pd.HWS_Part__c);
			
			kitProdIds.add(pd.HWS_Part__c);
		}
		else if(pd.HWS_VersionItem__r.HWS_Hardware_Sellable_Item__r.Id 
		!=null){
			prodIds.add(pd.HWS_VersionItem__r.HWS_Hardware_Sellable_Item__r.Id);
		}
				}
			} 
			if(!relatedProds.isEmpty()){
				for(Product2 prod : relatedProds){
		prodIds.add(prod.Id);
				}
			}
		}	  
		
		if(!(prodIds.isEmpty() && (AccountId == null || AccountId == ''))){ 
			List<Asset> accRelatedAssetProduct = [SELECT Id, ProductCode, Product2Id, Product2.Name
												  FROM Asset 
												  WHERE (AccountId=:AccountId AND Product2Id =:prodIds)];
			
			
			if(accRelatedAssetProduct.size()<=0)
			{
				mapContractLine.put('Error Message3',lCli);  
				
			}	
			else {	
				//3697 - passing contactId
				if(consolePortal == 'Portal'){
					lCli = HWS_Utilty.getAllServiceTypesPortal(prodIds, AccountId,serviceType,contractNumber,contactId , country);
				}
				else{
					lCli = HWS_Utilty.getAllServiceTypes(prodIds, new Set<Id>{AccountId}, serviceType,contractNumber,contactId, country);
				}
	
	Set<Id> assetProd = new Set<Id>();
	if(!lCli.isEmpty()){
		for(Asset finassets : lCli){
			assetProd.add(finassets.Product2Id);
		}
		
	}
	
	if(assetProd.size()>0 && kitProdIds.size()>0 && ((assetProd.size() == kitProdIds.size() && assetProd.equals(kitProdIds)) || (assetProd.size() < kitProdIds.size() && kitProdIds.containsAll(assetProd)))){
		allkitRelProd = true;
	}
				if(lCli.size()<=0){
					mapContractLine.put('Error Message2',lCli);
				}
				else if(kitCodesearch && allkitRelProd){
					
					mapContractLine.put('Kit code search',lCli); 
				}
				else{
					mapContractLine.put('No Error',lCli); 
				}
			}
		}
		//HWST- HWST-4182   
		if(lCli.size()<=0 && searchValue.length()>6){   
			List<Account> listAccounts = new List<Account>{new Account(Id = AccountId)};	
				lCli = HWS_Utilty.getContractlineItemsPartCodeRevision(listAccounts, searchValue, serviceType, contractNumber, contactId, consolePortal, country);  
			if(lCli.size()>0){  
				mapContractLine.put('No Error',lCli);   
			}   
		}
		return mapContractLine;
	}   
	
	/*************************32414
Method Name : getChildCaseDetails
Description : This method is getting invoked from "HWS_ChildCaseButton" component 
created for HWST-2793 as part of sprint-1914
Created By  : Ganesh
Created Date: 04/03/2019 (MM/DD/YYYY)
Modified By :
Modified Date:
******************************/
	@auraEnabled
	public static List<Case> getChildCaseDetails(Id parentCaseId){
		List<Case> childCaseLst = [SELECT Id, Status, RecordTypeId, HWS_ServiceType__c, AssetId, HWS_Contract_Line_Item__c 
								   FROM Case 
								   WHERE ParentId =: parentCaseId];
		return childCaseLst;
	}
	
	/*************************32414
Method Name : makeSOOCallout
Description : This method is getting invoked from "HWS_ChildCaseButton" component 
created for NOKIASC-32414
Created By  : Satya
Created Date: 11-11-2020
Modified By :
Modified Date:
******************************/
	public static HWS_SendServiceRequesttoSOO_SVC.processResponse makeSOOCallout(Id parentCaseId,String condition){
		Id childsCaseReadOnlyRType = childCaseReadOnly;
		Id parentCaseReadOnlyRType = parentCaseReadOnly;		
		Id spsReadOnlyCaseRecordType = spsReadOnly;
		Id spsCaseRecordType = sPSCaseRType;
		Id childCaseAEDaysRecordType = exchangeInDays;
		Id childCaseAEHoursRecordType = exchangeInHours;
		Id childCaseReturnForRepairRecordType = rfr;
		//Milestone CPU Time Limit Fix	  
		Boolean runBatchForMilestone = true;		
		String serviceType = null;
		
		
		HWS_SendServiceRequesttoSOO_SVC.processResponse pr= HWS_SendServiceRequesttoSOO_SVC.sendToSOO(parentCaseId,condition);
		Case parentCase = new Case(id=parentCaseId);
		List<Case> childCases = new List<Case>();
		//NOKIASC-32212:Declare List case variable to store final child case list
		//List<Case> tempChildCasesList = new List<Case>();
		//End
		List<Entitlement> entitlementLst = new List<Entitlement>();
		
		Set<Id> cliIdSet = new Set<Id>();
		Map<Id, Id> cliIdEntilmentIdMap = new Map<Id, Id>();
		List<Case> listNewCases = New List<Case>();
		
		if(!pr.isError){
			parentCase.HWS_Sent_To_SOO__c =true;
			parentCase.HWS_SOO_Reference_Number__c =pr.SOORequestID;
			parentCase.RecordTypeId = parentCaseReadOnlyRType;
			parentCase.HWS_Case_Ordered_Date__c=System.now();
			parentCase.HWS_Is_Error__c  =false;
			/* Added HWS_Case_Ordered_Date__c in the query for user story 2997*/
			//NOKIASC-32212:Added HWS_WarrantyStatus__c and variable name changed from childCases to tempChildCasesList
			if(condition!=null)
			{
	  // childCases = [select Id, Status,HWS_Communication_Contact__c, RecordTypeId, HWS_ServiceType__c,HWS_Case_Ordered_Date__c,AssetId, HWS_FaultyUnitReceivedDate__c, HWS_Contract_Line_Item__c, HWS_Contract_Line_Item__r.CH_BusinessHour__c, HWS_StartMilestone__c,HWS_WarrantyStatus__c from Case where ParentId =: parentCaseId AND Status!='Cancelled' AND HWS_isQuoteRequired__c=false AND ((HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c= 'HWS_W_AND_Q_UC_4' and HWS_WarrantyStatus__c = 'In Warranty') OR(HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c= 'HWS_W_AND_Q_UC_4' and HWS_WarrantyStatus__c = 'Out of Warranty') OR (HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c= 'HWS_W_AND_Q_UC_5' and HWS_WarrantyStatus__c = 'In Warranty') OR (HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c= 'HWS_W_AND_Q_UC_5' and HWS_WarrantyStatus__c = 'Out of Warranty') OR (HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c='HWS_W_AND_Q_UC_9' and HWS_WarrantyStatus__c = 'Out of Warranty' ) OR(HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c='HWS_W_AND_Q_UC_8' and HWS_WarrantyStatus__c = 'In Warranty' )  OR (HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c='HWS_W_AND_Q_UC_9' and HWS_WarrantyStatus__c = 'In Warranty' ) OR (HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c='HWS_W_AND_Q_UC_3' and HWS_WarrantyStatus__c = 'In Warranty' ) OR(HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c='HWS_W_AND_Q_UC_3' and HWS_WarrantyStatus__c = 'Out of Warranty' )OR (HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c='HWS_W_AND_Q_UC_6_7' and HWS_WarrantyStatus__c = 'Out of Warranty' ) OR (HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c='HWS_W_AND_Q_UC_2A' and HWS_WarrantyStatus__c = 'In Warranty') OR (HWS_WarrantyStatus__c = 'Not Applicable') OR (HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c='HWS_W_AND_Q_UC_6_7' and HWS_WarrantyStatus__c = 'In Warranty') OR(HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c='HWS_W_AND_Q_UC_1' and HWS_WarrantyStatus__c = 'In Warranty') OR (HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c= 'HWS_W_AND_Q_UC_2B' and HWS_WarrantyStatus__c = 'In Warranty'))];   
		childCases = [select Id, Status,HWS_Communication_Contact__c, RecordTypeId, HWS_ServiceType__c,HWS_Case_Ordered_Date__c,AssetId, HWS_FaultyUnitReceivedDate__c, HWS_Contract_Line_Item__c, HWS_Contract_Line_Item__r.CH_BusinessHour__c, HWS_StartMilestone__c,HWS_WarrantyStatus__c from Case where ParentId =: parentCaseId AND Status!='Cancelled' AND Status!='On Hold' AND Status='Draft'];	 
			}
			else
			{
		  childCases = [select Id, Status,HWS_Communication_Contact__c, RecordTypeId, HWS_ServiceType__c,HWS_Case_Ordered_Date__c,AssetId, HWS_FaultyUnitReceivedDate__c, HWS_Contract_Line_Item__c, HWS_Contract_Line_Item__r.CH_BusinessHour__c, HWS_StartMilestone__c,HWS_WarrantyStatus__c from Case where ParentId =: parentCaseId AND Status!='Cancelled'];
			}
			PopulateEntitlementIdOnParentChildList parentChildList = populateEntitlementIdAndStatusOrderForCases(childCases,parentCase);
			parentCase = parentChildList.parentCase;
			HWS_CasetriggerHandler.isNewCase = true;
			//parentCase.HWS_ErrorReason__c='false';
		}
		else{
			parentCase.HWS_Is_Error__c  =true;
			
		}
		try{
		update parentCase;
		}
		catch(Exception ex)//added try and catch block to retry whenever parent update fails
		{
			if(retryCount<2 && ( ex.getMessage().containsIgnoreCase('UNABLE_TO_LOCK_ROW') || ex.getMessage().containsIgnoreCase('Read timed out') && ex.getMessage().containsIgnoreCase('Bad Gateway')) )
			{
				Interface_Log__c ilog=new Interface_Log__c(Name='HWS Make SOO call',Message_Type__c='Outbound',Operation_Type__c='Insert',Status__c='Post Processing Error',Comment__c=ex.getMessage());
				insert ilog;
				retryCount++;
				makeSOOCallout(parentCaseId,'true');
			}
			Interface_Log__c ilog=new Interface_Log__c(Name='HWS Make SOO call',Message_Type__c='Outbound',Operation_Type__c='Insert',Status__c='Post Processing Error',Comment__c=ex.getMessage());
			insert ilog;
		}
		if(!parentCase.HWS_Is_Error__c){
		Set<Id> childIds = new Set<Id>();
		Integer processingSize = 20;
		
		if(!Test.isRunningTest() && HWS_GenericSettings__c.getValues('OrderedProcessingSize').HWS_Field1__c!=null){
			processingSize = Integer.valueOf(HWS_GenericSettings__c.getValues('OrderedProcessingSize').HWS_Field1__c);
		}
		System.debug('user is'+UserInfo.getFirstName()+''+UserInfo.getLastName());
		if(!System.isFuture() && !System.isBatch()  ){ //NOKIASC-37921
			for(Case caseRec : childCases){
				if(childIds.size()<processingSize){
					childIds.add(caseRec.Id);
				}
				else{
				   
					makeOrderedOnChildCases(childIds);  
					childIds.clear(); 
					childIds.add(caseRec.Id);
				}
				
			}
			if(childIds.size()>0){
				makeOrderedOnChildCases(childIds);   
			}
		}
		else if(UserInfo.getFirstName()+''+UserInfo.getLastName()=='SOOUser')	
		{		
			for(Case caseRec : childCases){
			 caseRec.status = 'Ordered';
				caseRec.HWS_Case_Ordered_Date__c=System.now();
			}		  
			update childCases;	  
		}
		List<Case> parentCaseList = new List<Case>();
		parentCaseList.add(parentCase);
		CH_AuthorizedContactSharing.handleSharing(new Map<Id, Case>(parentCaseList), new Map<Id, Case>(), true, false);
		
		}
		return pr;
	}
	public static PopulateEntitlementIdOnParentChildList populateEntitlementIdAndStatusOrderForCases(List<Case> childList, Case parentCase){
		Id childsCaseReadOnlyRType = childCaseReadOnly;
		Id spsReadOnlyCaseRecordType = spsReadOnly;
		Id spsCaseRecordType = sPSCaseRType;
		PopulateEntitlementIdOnParentChildList parentChildList;
		Set<Id> cliIdSet = new Set<Id>();
		Map<Id, Id> cliIdEntilmentIdMap = new Map<Id, Id>();
		List<Entitlement> entitlementLst = new List<Entitlement>();
		List<Case> populatedCaseList = new List<Case>();
		if(!childList.isEmpty()){
			for(Case childCase : childList){
				cliIdSet.add(childCase.HWS_Contract_Line_Item__c);
				
			}
		}
		if(!cliIdSet.isEmpty()){
			entitlementLst = [SELECT Id, Name, AssetId, ContractLineItemId FROM Entitlement WHERE ContractLineItemId IN :cliIdSet AND ContractLineItem.Status = 'Active']; 
		}
		
		if(!entitlementLst.isEmpty()){
			for(Entitlement ent : entitlementLst){
				cliIdEntilmentIdMap.put(ent.ContractLineItemId, ent.Id);
			}
		}
		
		if(childList.size()!=0){
			for(Case childCase : childList){
				childcase.EntitlementId =cliIdEntilmentIdMap.get(childCase.HWS_Contract_Line_Item__c);
				if(parentCase != null){
					childcase.HWS_Case_Ordered_Date__c = parentCase.HWS_Case_Ordered_Date__c;
					if(parentCase.EntitlementId == null){
						parentCase.EntitlementId = cliIdEntilmentIdMap.get(childCase.HWS_Contract_Line_Item__c); 
					}
				}
				if(childCase.RecordTypeId == spsCaseRecordType){
					childCase.RecordTypeId = spsReadOnlyCaseRecordType; 
				}
				else{
					childCase.RecordTypeId = childsCaseReadOnlyRType;
				}
				populatedCaseList.add(childCase);   
			}
		}
		parentChildList = new PopulateEntitlementIdOnParentChildList(parentCase,populatedCaseList); 
		return parentChildList;
	}
	public class PopulateEntitlementIdOnParentChildList{
		public Case parentCase;
		public List<Case> childCaseList;
		public PopulateEntitlementIdOnParentChildList(Case parentCase, List<Case> childCaseList){
			this.parentCase = parentCase;
			this.childCaseList = childCaseList;
		}
	}
	@future(callout=true)
	public static void makeOrderedOnChildCases(Set<Id> caseIds){
		Id childsCaseReadOnlyRType = childCaseReadOnly;
		Id spsReadOnlyCaseRecordType = spsReadOnly;
		Id spsCaseRecordType = sPSCaseRType;

		if(!caseIds.isEmpty()){
			List<Case> newChildList = new List<Case>();
			List<Case> childCaseList = [Select Id,RecordTypeId from Case where Id IN: CaseIds];
			for(Case caseRec : childCaseList){
				caseRec.Status = 'Ordered';
				caseRec.HWS_Case_Ordered_Date__c=System.now();//added newly 
				if(caseRec.RecordTypeId == spsCaseRecordType){
		caseRec.RecordTypeId = spsReadOnlyCaseRecordType; 
	}
	else{
		caseRec.RecordTypeId = childsCaseReadOnlyRType;
	}

				newChildList.add(caseRec);
			}
			update newChildList;
		}
		
	}
	//32414
	@auraEnabled
	public static list<Account> getAllAccounts(Contact contactRec, String consolePortal){  
		
		if(contactRec.Contact_Status__c=='Active'){
			Id legalAccount = HWS_Utilty.getRecordTypeByName('ACCOUNT',HWS_Constants.Legal_Entity);
			list<EntitlementContact> accEntitlementContact= HWS_Utilty.getEntitlementContact(contactRec.Id, legalAccount);
			set<Id> accountIds = new set<Id>();
			for(EntitlementContact ac: accEntitlementContact){
				accountIds.add(ac.Entitlement.AccountId);
			}
			List<Account> lAccounts = HWS_Utilty.getAccounts(accountIds);
			return lAccounts;
		}
		else{
			return null;
		}
	}
	/****************************************
	* Name : updateParentInternalStatus
	* Description : This method is used to check and Update Parent Internal Status if child case status is either Draft or Cancel
	* By Satya Pagadala
	* Created Date: 06 Nov 2020
	* User story : NOKIASC-32645
	*****************************************/ 
	public static void updateParentInternalStatus(Set<Id> parentCaseIdSet){	 
		List<Case> parentCaseToUpdate = new List<Case>();
		for(Case parentCase: [Select Id, CH_InternalStatus__c, (SELECT Id, CaseNumber, Subject, Status, HWS_WarrantyStatus__c, HWS_Part_Code__c, HWS_Faulty_Serial_Number__c, CH_EntitlementException__c, CH_EntitlementStatus__c, Parent.HWS_Sent_To_SOO__c FROM Cases) from Case where Id = :parentCaseIdSet]){
			Boolean parentToUpdate = true;
			if(!(parentCase.Cases).isEmpty()){
				for(Case c :parentCase.Cases){
	//removed condition || (c.Status =='Draft' && c.CH_EntitlementStatus__c =='Service Declined') part of NOKIASC-34880
					if(c.Status !='Draft' && c.Status !='Cancelled'){
						parentToUpdate = false;
					}
				}
			}	   
			if(parentToUpdate && parentCase.CH_InternalStatus__c !=null){
				parentCase.CH_InternalStatus__c=null; 
				parentCaseToUpdate.add(parentCase); 
			}
		}	   
		if(!parentCaseToUpdate.isEmpty()){
			update parentCaseToUpdate; 
		}
	}
	/****************************************
	* Name : getCreatableFieldsSOQL
	* Description : This method is used to get the all fields from an object
	* By Satya Pagadala
	* Created Date: 12 Feb 2021
	* User story : NOKIASC-34093
	*****************************************/ 
	public static string getCreatableFieldsSOQL(String objectName){
		
		String selects = '';
		
		
		
		// Get a map of field name and field token
		Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
		list<string> selectFields = new list<string>();
		
		if (fMap != null){
			for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
				Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
				//if (fd.isCreateable()){ // field is creatable
					selectFields.add(fd.getName());
				//}
			}
		}
		
		if (!selectFields.isEmpty()){
			for (string s:selectFields){
				selects += s + ',';
			}
			if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}
			
		}
	   

		return 'SELECT ' + selects + ' FROM ' + objectName;
	}
	
	 /****************************************
	* Name : updateEntitlementDefaults
	* Description : This method is used to setup default Entitlement values on case before insert based on HWS_WarrantyStatus__c
	* By Ajesh Juluru
	* Created Date: 8 March 2021
	* User story : NOKIASC-34637
	*****************************************/
	public static void updateEntitlementDefaults(List<Case> childCaseList){
		Map<String, String> clItemWQCondition = new Map<String, String>();
		List<ContractLineItem> clItemList = new List<ContractLineItem>();
		List<Id> clIds = new List<Id>();
		for(Case caseRec : childCaseList){
			if(caseRec.HWS_Contract_Line_Item__c != null && caseRec.HWS_WarrantyStatus__c != null && caseRec.HWS_WarrantyStatus__c != ''){
				clIds.add(caseRec.HWS_Contract_Line_Item__c);
			}
		}
		if(!clIds.isEmpty()){
			clItemList = [Select Id,HWS_W_AND_Q_CONDITION__c from ContractLineItem where Id IN: clIds];
			for(ContractLineItem clItem : clItemList){
				clItemWQCondition.put(clItem.Id, clItem.HWS_W_AND_Q_CONDITION__c);
			}
			childCaseList = HWS_BulkWarrantyCheck_Result_SOO_to_SRM.setEntitlementDefaultValues(clItemWQCondition,childCaseList);
		}
	}
	
	
	/****************************************
* Name : updateEntitlementExceptionDefaults
* Description : This method is used to setup default Entitlement values on case before insert based on HWS_WarrantyStatus__c
* Story : NOKIASC-34591 
* Author : Eashwar
*****************************************/
	public static void updateEntitlementExceptionDefaults(Map <Id, Case> oldCaseMap,List<Case> childCaseList){
		Map<String, String> clItemWQCondition = new Map<String, String>();
		List<Id> caseIds=new List<Id>();
		
		for(Case caseRec : childCaseList){
			caseIds.add(caseRec.id);
		}
		List<Case> newChilds=[select id,HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c from Case where id in :caseIds];
		for(Case caseRec : newChilds){
			clItemWQCondition.put(caseRec.id,caseRec.HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c);
		}
		for(Case caseRec : childCaseList){
			String condition = clItemWQCondition.get(caseRec.id);
			if(oldCaseMap.get(caseRec.id).CH_EntitlementStatus__c !=caseRec.CH_EntitlementStatus__c && oldCaseMap.get(caseRec.id).CH_EntitlementException__c ==caseRec.CH_EntitlementException__c)
			{
				HWS_EntitlementReset.resetEntitlementException(oldCaseMap.get(caseRec.id).CH_EntitlementException__c,condition,caseRec);
			}
		}
	}
	//From Lightning Component 
	public static void resetEntitlementExceptionFromLightning(Case caseRec)
	{
		Case cs=[select id,CH_EntitlementException__c,HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c from Case where id = :caseRec.id];
		HWS_EntitlementReset.resetEntitlementException(cs.CH_EntitlementException__c,cs.HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c,caseRec);
	}
	
}