/****************************************
* Name : HWS_CaseFlow
* Author : TCS
* Description : This class is for HWS_CaseFlow
* ReqNo : 
****************************************/
public without sharing class HWS_CaseFlow { 
	public static Id exchangeInDays = HWS_Utilty.exchangeInDays;
	public static Id exchangeInHours = HWS_Utilty.exchangeInHours;
	public static Id childCaseReadOnly = HWS_Utilty.childCaseReadOnly;
	public static Id sPSCaseRType = HWS_Utilty.sPSCaseRType;
	public static Id spsReadOnly = HWS_Utilty.spsReadOnly;
	public static Id parentCaseRecordType = HWS_Utilty.parentCaseRecordType;
	public static Id parentCaseReadOnly = HWS_Utilty.parentCaseReadOnly;
	public static Id rfr = HWS_Utilty.rfr;
	public static Id esclationCase = HWS_Utilty.esclationCase;
	
	/****************************************
* Name : getSerialNumberInfo
* Description : returns String(YES or NO) based on version Item
* Parameters: List<hws_versionitem__c> versionItems
* Returns : String
*****************************************/
	@auraEnabled
	public static String getSerialNumberInfo(List<hws_versionitem__c> versionItems){
		set<Id> verionIds = new set<Id>();
		for(hws_versionitem__c vi: versionItems){
			verionIds.add(vi.Id);
		}
		String serialNumberValue;
		//added  for PMD Error - NOKIASC-32425
		List<hws_versionitem__c> veriosnDetails= [SELECT Id, HWS_Serial_Number_Traceable__c FROM hws_versionitem__c WHERE Id IN: verionIds];
		
		if(veriosnDetails <> null && veriosnDetails[0].HWS_Serial_Number_Traceable__c <> null 
	 && (veriosnDetails[0].HWS_Serial_Number_Traceable__c.equalsIgnoreCase('YES') || veriosnDetails[0].HWS_Serial_Number_Traceable__c.equalsIgnoreCase('Y'))){
	  serialNumberValue = 'YES';
	 }
		else{
			serialNumberValue = 'NO';
		}
		return serialNumberValue; 
	}
	
	/****************************************32414
* Name : duplicateSerialNumberInfo
* Description : method to findout duplicate falty unit serial for each material code
* Parameters: string serialNumber, string materialCode
* Returns : List<Case>
*****************************************/
	@auraEnabled
	public static list<Case> duplicateSerialNumberInfo(string serialNumber, string materialCode){
		return HWS_Utilty.duplicateSerialNumberInfo(serialNumber, materialCode);
	}   
	
	/****************************************	
* Name : getContactDetails	  
* Description : method to return Contact Details		
* Parameters: string contactId	  
* Returns : Contact	 
* Note: this is replacement of below methods		
1. getParentAccountId() 2. getContactName() 3. getContactType()	 
*****************************************/	  
	@auraEnabled		
	public static Contact getContactDetails(string contactId)	
	{	
		//added  for PMD Error - NOKIASC-32425
		Contact con= [SELECT Id,Name,AccountId,CH_ContactType__c,Contact_Status__c,CH_ContactTimeZone__c,Email1__c,CH_Email3__c FROM contact where Id = :contactId ];	
		return con;	 
	}
	
	/****************************************32414
* Name : getAllAccounts
* Description : method to findout List of Accounts based on ContactId
* Parameters: string contactid
* Returns : List<Account>
*****************************************/  
	@auraEnabled
	public static list<Account> getAllAccounts(string contactid) {  
		Contact conRec= [SELECT Id,Name,AccountId,Contact_Status__c FROM contact where Id = :contactid];
		return HWS_Utilty.getAllAccounts(conRec, 'Console');
	}
	
	/****************************************   
* Name : getCaseInitiationTime
* Description : method to get
* Parameters: string contactid
* Returns : String
*****************************************/
	
	@auraEnabled
	public static DateTime getCaseInitiationTime()
	{	
		return System.now();		
	}
		
	
	/****************************************32414
* Name : getContractlineItems
* Description : method to get List of Assets
* Parameters: List<Account> listAccounts,String searchValue,String serviceType, String contractNumber
* Returns : Map<String, List<Asset>>
*****************************************/
	//3697 - passing contactId
	@auraEnabled
	public static Map<String, List<Asset>> getContractlineItems(List<Account> listAccounts, String searchValue, String serviceType, String contractNumber, String contactId, String country){
		System.debug('HERE:'+listAccounts);
		return HWS_Utilty.getContractlineItems(listAccounts[0].Id, searchValue, serviceType, contractNumber, contactId, country, 'Console');
	}
	
	/****************************************
* Name : getVersions
* Description : method to get List of VersionItems
* Parameters: list<Asset> listServiceServiceCon
* Returns : List<hws_versionitem__c> 
*****************************************/
	@auraEnabled
	public static List<hws_versionitem__c> getVersions(list<Asset> listServiceServiceCon,String searchValue){	
		String searchCode=searchValue +'%';	 
		List<String> versionCodeList = new List<String>();	  
		Id salesProduct = HWS_Utilty.getRecordTypeByName('Product2',HWS_Constants.SALES_PRODUCT);
		String sourceSystem;
		Set<Id> sCLItmIds = new Set<Id>();
		List<hws_versionitem__c> stockableItems = new List<hws_versionitem__c>();
		for(Asset cl : listServiceServiceCon){
			sCLItmIds.add(cl.Product2Id);
			sourceSystem = cl.HWS_SourceSystem__c;
		}   
		//added  for PMD Error - NOKIASC-32425
	List<HWS_AlternateProductCode__c> altVersionItemsLst = [SELECT Id, HWS_VersionItem__r.HWS_Hardware_Sellable_Item__r.Id,HWS_VersionItem__r.HWS_Version_Code__c, Name, HWS_AlternateCodeType__c FROM HWS_AlternateProductCode__c 
	WHERE HWS_VersionItem__r.HWS_Source__c =:sourceSystem AND HWS_VersionItem__r.HWS_Hardware_Sellable_Item__r.RecordTypeId =: salesProduct AND Name LIKE:searchCode AND HWS_VersionItem__r.HWS_Hardware_Sellable_Item__c IN:sCLItmIds];
		if(altVersionItemsLst.size()>0) {   
			for(HWS_AlternateProductCode__c pd : altVersionItemsLst){   
	versionCodeList.add(pd.HWS_VersionItem__r.HWS_Version_Code__c);
			}   
		}	
		stockableItems=HWS_Utilty.getVersionItems(sCLItmIds,sourceSystem,versionCodeList);
		return stockableItems;
	}
	
	/****************************************
* Name : getServiceContracts
* Description : Method to get the Service Contracts when search type is selected as Contract Number
* Parameters: List<Account> selectedAccounts,String searchString,String serviceType
* Returns : Map<String, List<ContractLineItem>>
*****************************************/
	//3697 - passing contactId
	@AuraEnabled 
	public Static Map<String, List<ContractLineItem>> getServiceContracts(List<Account> selectedAccounts,String searchString,String serviceType,String selectedContractNumber, Id contactId ){
		Map<String, List<ContractLineItem>> mapContractLine = new Map<String, List<ContractLineItem>>();
		String contractNumber = searchString+'%';
		List<ContractLineItem> serviceContracts = new List<ContractLineItem>();
		Set<ID> accIds = new Set<ID>();
		for(Account acc:selectedAccounts){
			accIds.add(acc.Id);
		}
		//3697 - passing contactId
		serviceContracts = HWS_Utilty.getserviceContracts(contractNumber, accIds,serviceType,selectedContractNumber, contactId);
		if(selectedContractNumber != '' && !selectedContractNumber.containsIgnoreCase(searchString)){
			mapContractLine.put('Error Message3',serviceContracts);
		}
		else if(serviceContracts.size()>0){
			mapContractLine.put('No Error',serviceContracts);
		}else{
			List<ContractLineItem> serviceContractsInactive = HWS_Utilty.getserviceContractsInactive(contractNumber, accIds,serviceType);
			if(serviceContractsInactive.size()>0){
	mapContractLine.put('Error Message1',serviceContracts); 
			}else{
	mapContractLine.put('Error Message2',serviceContracts);
			}
		}
		return mapContractLine;
	}
	
	/****************************************
* Name : getCLIOfServiceContracts
* Description : Method to get the Contract line Items for the selected Service Contracts when search type is selected as Contract Number
* Parameters: List<ContractLineItem> selectedServiceContracts
* Returns : List<Asset>
*****************************************/
	@AuraEnabled
	public Static List<Asset> getCLIOfServiceContracts(List<ContractLineItem> selectedServiceContracts){
		List<Asset> serviceCLIs = new List<Asset>();
		Set<Id> servIDs = new Set<ID>();
		for(ContractLineItem sc:selectedServiceContracts){
			servIDs.add(sc.Id);
		}
		serviceCLIs = HWS_Utilty.getServiceTypes(servIDs);
		return serviceCLIs;
	}
	
	/****************************************
* Name : plannedDeliveryDateTime
* Description : Method to get PlannedDelivery Time based businesshrs and lead time
* Parameters: Id businessHrsId, String leadTimeUnit, String leadTimeDuration ,Date byPassPlannedDate
* Returns : DateTime
*****************************************/  
	@auraEnabled
	public static DateTime plannedDeliveryDateTime(Id businessHrsId, String leadTimeUnit, String leadTimeDuration ,Date byPassPlannedDate,String specifiedTime){
		DateTime plannedDt = HWS_Utilty.plannedDeliveryDateTime(businessHrsId,leadTimeUnit,leadTimeDuration,byPassPlannedDate,specifiedTime);
		
		return plannedDt;
		
	}
	
	/****************************************
* Name : getPickListValues1
* Description : Method to get the Contract line Items for the selected Service Contracts when search type is selected as Contract Number
* Parameters: List<ContractLineItem> selectedServiceContracts
* Returns : List<Asset>
*
*****************************************/
	
	@auraEnabled
	public Static List<String> getPickListValues1(String obj, String str)
	{
		List<String> options= HWS_Lookup_Class.getPickListValues(obj, str);
		return options;
	}   
	
	@auraEnabled
	public static String createHWSCase(List<Account> accountList,list<Asset> contractLines,List<hws_versionitem__c> 
			versionItems,List<Case> childCaseList,Case parentCase,String contactid,
			Boolean submitToSOO, DateTime caseInitiationTime, String deliveryTimeZone)
		
	{
		List<Case> childCase = new List<Case>();	
		Id sps = sPSCaseRType;	
		try {   
			case parentCase1 = parentCase;
			Case parentCaseId;
			
			parentCase1.ContactId = contactid;
			parentCase1.AccountId = accountList[0].Id;  
			parentCase1.CH_CaseInitiationDate__c = caseInitiationTime;
			parentCase1.RecordTypeId=parentCaseRecordType;
			parentCase1.HWS_Delivery_TimeZone__c = String.valueOf(deliveryTimeZone);
			parentCase1.NCP_Service_Contract__c = childCaseList[0].NCP_Service_Contract__c; //NOKIASC-34876
			parentCase1.CH_CIRCount__c = childCaseList.size();//NOKIASC-31849
			//NOKIASC-31884
			if(parentCase1.CH_ReportedDate__c == null){
	parentCase1.CH_ReportedDate__c = System.now();
			}
			parentCase1.Country__c = contractLines[0].HWS_ContractLineItem__r.CH_CountryISOName__c;//NOKIASC-31884	
			//32414		 
			Database.insert(new SObject[] {parentCase1});	 
			//Added for single email
			//added  for PMD Error - NOKIASC-32425
			parentCaseId = [select id, CH_GWC_SecurityGroup__c,CH_SecurityGroup__c,caseNumber,Hws_Ship_to_Party_Address__c,Hws_Ship_to_Party_Address__r.BillingStreet,Hws_Ship_to_Party_Address__r.BillingCity,Hws_Ship_to_Party_Address__r.BillingState,Hws_Ship_to_Party_Address__r.BillingPostalCode,Hws_Ship_to_Party_Address__r.BillingCountry from case where Id = :parentCase1.Id ];
			for(Case caseRec : childCaseList){
	case childCase1 = caseRec;  
	childCase1.ContactId = contactid;
	childCase1.AccountId = accountList[0].Id;
	childCase1.ParentId = parentCase1.Id; 
	childCase1.CH_Email2__c=parentCase1.CH_Email2__c;//27247
	childCase1.CH_Email3__c=parentCase1.CH_Email3__c;
	// Added on 30-March-2021 | NOKIASC-35143 | Start
	childCase1.CH_GWC_SecurityGroup__c = parentCaseId.CH_GWC_SecurityGroup__c;
	childCase1.CH_SecurityGroup__c	 = parentCaseId.CH_SecurityGroup__c;
	// Added on 30-March-2021 | NOKIASC-35143 | End
	//Added for single email
	childCase1.Hws_Ship_to_Party_Address__c = parentCase1.Hws_Ship_to_Party_Address__c;
	childCase1.HWS_ShipmentRecipientEmailId__c = parentCase1.HWS_ShipmentRecipientEmailId__c;
	childCase1.HWS_Shipment_Recipient_Name__c = parentCase1.HWS_Shipment_Recipient_Name__c; 
	childCase1.Comment__c = (parentCase1.HWS_Shipment_Recipient_Name__c==null ? ' ' :parentCase1.HWS_Shipment_Recipient_Name__c+',\n')+
		(parentCaseId.Hws_Ship_to_Party_Address__r.BillingStreet==null ? ' ' :parentCaseId.Hws_Ship_to_Party_Address__r.BillingStreet+'\n')+
		(parentCaseId.Hws_Ship_to_Party_Address__r.BillingCity==null ? ' ' :parentCaseId.Hws_Ship_to_Party_Address__r.BillingCity+',\n')+
		(parentCaseId.Hws_Ship_to_Party_Address__r.BillingState==null ? ' ' :parentCaseId.Hws_Ship_to_Party_Address__r.BillingState+',\n')+
		(parentCaseId.Hws_Ship_to_Party_Address__r.BillingCountry==null ? ' ' :parentCaseId.Hws_Ship_to_Party_Address__r.BillingCountry+',\n')+
		(parentCaseId.Hws_Ship_to_Party_Address__r.BillingPostalCode==null ? ' ' :parentCaseId.Hws_Ship_to_Party_Address__r.BillingPostalCode+'.');
	childCase1.HWS_Delivery_TimeZone__c = String.valueOf(deliveryTimeZone);
	childCase1.HWS_Parent_Case_Number__c = parentCaseId.CaseNumber;
	if(parentCase1.HWS_Communication_Contact__c!= null || parentCase1.HWS_Communication_Contact__c!=''){
		childCase1.HWS_Communication_Contact__c = parentCase1.HWS_Communication_Contact__c;
	}
	String serviceType = caseRec.HWS_ServiceType__c;
	if(serviceType.containsIgnoreCase('days')){
		childCase1.RecordTypeId = exchangeInDays;	 
	}else if((serviceType.containsIgnoreCase('SPS'))||(serviceType.containsIgnoreCase('SALES'))){
		childCase1.RecordTypeId = sps;
	}else if((serviceType.containsIgnoreCase('RETURN FOR REPAIR')) ||(serviceType.containsIgnoreCase('Identical Repair'))){
		childCase1.RecordTypeId = rfr;
	}else{
		childCase1.RecordTypeId = exchangeInHours;
	}
	//25689 --> Clear values which is added(Dummy values in Lightning Component)	
	childCase1.Street_Address_1__c = null;
	childCase1.Street_Address_2__c = null;
	childCase1.Street_Address_3__c = null;
	//NOKIASC-34637
	if(childCase1.CH_EntitlementException__c == 'Warranty Status Check Failed'){
		childCase1.HWS_WarrantyStatus__c = 'Warranty Unknown';
		}
	if(childCase1.HWS_Failure_Occurance__c == HWS_Constants.None){
		childCase1.HWS_Failure_Occurance__c='';
	}
	if(childCase1.HWS_Failure_Description__c == HWS_Constants.None){
		childCase1.HWS_Failure_Description__c='';
	}
	if(childCase1.HWS_Failure_Detection__c == HWS_Constants.None){
		childCase1.HWS_Failure_Detection__c='';
	}
	childCase.add(childCase1);
	
			}	 
			Database.insert(childCase);
			return parentCase1.id;
		}	
		catch(DmlException e) {
			throw new AuraHandledException(String.valueOf(e.getMessage()));  
		}
	}
	
	//32414
	@auraEnabled
	public static HWS_SendServiceRequesttoSOO_SVC.processResponse makeSOOCallout(Id parentCaseId){
		return HWS_Utilty.makeSOOCallout(parentCaseId,null);
	}
	
	@auraEnabled
	public static List<Case> ecsalateCase(String contactId,List<Account> accList, Case escCase){
		List<Case> caseList2 = new List<Case>();
		Id recId = esclationCase;
		Id accId;
		try{  
			
			case cas = escCase;		 
			cas.Subject='Case Escalated to CAPM';
			cas.RecordTypeId= recId;			
			if (accList!=null){
	for(Account acc : accList){accId=acc.Id;}
	cas.AccountId= accId;
			}
			cas.ContactId= contactId;
			Database.insert(new SObject[] {cas});
			//added  for PMD Error - NOKIASC-32425
			for(Case c1 : [Select id,casenumber from case where id = : cas.Id ]){ caseList2.add(c1);}
			return caseList2;
		}catch(Exception e){			
			System.debug(LoggingLevel.DEBUG,'Error***'+e.getMessage() +'on line number ' +e.getLineNumber() + ' '+ e.getCause());
			return null;
		}
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
		return HWS_Utilty.getChildCaseDetails(parentCaseId);
	}
		
	/*************************
Method Name : getNEA
User Story : NOKIASC-32950
Description : To solve NEA performence issue
Created By  : TCS
Created Date: 26/11/2020 (MM/DD/YYYY)
Modified By :
Modified Date:
******************************/  
	@AuraEnabled
	public static HWS_NetworkElementAssetWrapper.AssetPagerWrapper getNEA(Id accId, Id cliId,List<Id> cliIdList,Integer recordLimit, Integer recordOffset,String searchText){	
		return HWS_Utilty.getNetworkElementAssets(accId,cliId,cliIdList,recordLimit,recordOffset,searchText);	
	}
	
	@auraEnabled
	public static String getPayPerUse(Id parentCaseId){
		String isValue;
		 Boolean invoicingType = false;
		//added  for PMD Error - NOKIASC-32425
		List<Case> parentCase=[select id,HWS_Customer_PO__c,CH_InternalStatus__c from case where Id =:parentCaseId  LIMIT 1];
		List<Case> childCases;
		if(parentCase.Size()>0){
			//added  for PMD Error - NOKIASC-32425
			childCases = [select Id, HWS_Contract_Line_Item__r.CH_ServiceOffering__c,Asset.HWS_ServiceOffering__c,Asset.HWS_Price__c,HWS_ServiceType__c,HWS_Contract_Line_Item__r.HWS_InvoicingType__c
		FROM Case where ParentId =: parentCaseId AND Status!='Cancelled' ];
			if((parentCase[0].HWS_Customer_PO__c=='' || parentCase[0].HWS_Customer_PO__c== NULL) && childCases.Size()>0){   
		
		for(Case getChildCaseValues:childCases){	
			string serviceItemDescription=getChildCaseValues.Asset.HWS_ServiceOffering__c;  
			string servicetype =getChildCaseValues.HWS_ServiceType__c;  
			 String invoiceType = getChildCaseValues.HWS_Contract_Line_Item__r.HWS_InvoicingType__c;
			if(invoiceType == 'event based'){
		invoicingType = true;
				}
			if((servicetype =='Spare Part Sales') || (serviceItemDescription!='' && serviceItemDescription!=NULL) && (serviceItemDescription.contains('RES RFR PU')||serviceItemDescription.contains('RES AED PU'))){   
	isValue='PO Error'; 
	break;  
			}   
		}   
	
			}   
			if(childCases.Size()>0){	
	for(Case getChildCaseValues:childCases){	
		string serviceItemDescription=getChildCaseValues.Asset.HWS_ServiceOffering__c;  
		string getPrice=getChildCaseValues.Asset.HWS_Price__c;  
		string servicetype =getChildCaseValues.HWS_ServiceType__c;  
		if(((servicetype =='Spare Part Sales') || (serviceItemDescription!='' && serviceItemDescription!=NULL) && (serviceItemDescription.contains('RES RFR PU')||serviceItemDescription.contains('RES AED PU'))) && ((parentCase[0].HWS_Customer_PO__c=='' || parentCase[0].HWS_Customer_PO__c== NULL) &&  
		 (getPrice == '' || getPrice == null ))) {  
	
	isValue='Quotation Error';
	break;
		 
		}
	}
			}
			if(invoicingType && (parentCase[0].HWS_Customer_PO__c=='' || parentCase[0].HWS_Customer_PO__c== NULL) &&
	  parentCase[0].CH_InternalStatus__c == 'Warranty Verification Required'){
	   isValue='WarrantyError';
	  }
			else if(invoicingType && (parentCase[0].HWS_Customer_PO__c=='' || parentCase[0].HWS_Customer_PO__c== NULL) &&
		(parentCase[0].CH_InternalStatus__c == '' || parentCase[0].CH_InternalStatus__c == NULL)){
			isValue='WarrantyNullError';
		}
		}
		return isValue;
	}
	/*************************
Method Name : accountTimeZoneplannedDeliveryDateTime
Description : created for NOKIASC-25687 as part of sprint-2020
Created By  : Ajesh
Created Date: 25/02/2020 (MM/DD/YYYY)
Modified By :
Modified Date:
******************************/
//NOKIASC-37920 | Added isBulkUploadCall
	@auraEnabled
	public static HWS_Utilty.plannedDeliveryDateWrapper accountTimeZoneplannedDeliveryDateTime(List<Case> listChildCases, Id selectedAccount, Boolean isBulkUploadCall ){
		Map<Id,String> HWS_UpdateTimeZone = HWS_Utilty.updateTimeZone(selectedAccount);
		HWS_Utilty.plannedDeliveryDateWrapper listCase = HWS_Utilty.accountTimeZoneplannedDeliveryDateTime(listChildCases, HWS_UpdateTimeZone.get(selectedAccount),isBulkUploadCall);
		return listCase;
	}
	
	//25689
	/****************************************
* Name : getShipToTimeZone
* Description : returns Map of Map with TimezoneKey based on Country Timezone
* Parameters: AccountId (Ship to Party Address) and List of BusinessHours Ids
* Returns : Map of Map
* written on 26th Feb 2020
* By Satya Pagadala
*****************************************/
	@auraEnabled
	public static Map<String, Map<Id, String>> getShipToTimeZone(Id selectedAccount, List<Id> businessHourIdList ){
		//Map of Map --> child map contans AccountId/BusinessHourId with timezone value.
		//Parent Map says the whether the child map is from Account or BusinesHours
		Map<String, Map<Id, String>> stringTimeZonemap = new Map<String, Map<Id, String>>();
		Map<Id, String> timeZonemap = new Map<Id, String>();
		//Query Account to get HWS_TimeZone__c
		//added  for PMD Error - NOKIASC-32425
		Account acc = [select Id, HWS_TimeZone__c, Name, BillingCountry from Account where Id = :selectedAccount ];
		if(acc != null && acc.HWS_TimeZone__c != null){  
			timeZonemap.put(acc.Id, acc.HWS_TimeZone__c);
			stringTimeZonemap.put('Account', timeZonemap);
		}
		//If Account Timezone is null then query on BusinessHours
		else{
			List<BusinessHours> bhList = new List<BusinessHours>();
			//added  for PMD Error - NOKIASC-32425
			bhList = [SELECT ID, Name, TimeZoneSidKey   FROM BusinessHours where Id IN :businessHourIdList ];	 
			if(bhList.size()>0){
	for(BusinessHours bh : bhList){
		if(bh.TimeZoneSidKey != null){
			timeZonemap.put(bh.Id, bh.TimeZoneSidKey);
		}
	}
	stringTimeZonemap.put('BusinessHour', timeZonemap);
			}	 
		}	
		return stringTimeZonemap;
	}	
	/****************************************
* Name : validateSWSCase
* Description : returns Case
* Parameters: CaseNumber
* Returns : Case
* written on 17th Sep 2020
* By Satya Pagadala
* User Story : NOKIASC-31177
*****************************************/
	@auraEnabled
	public static List<Case> validateSWSCase(List<String> caseNumberLst){	 
		return HWS_Utilty.getCasesByCaseNumber(caseNumberLst);	  
	}
	/* Wrapper class to store contact info*/
	public class ContactInfoWrapper {
		@auraEnabled
		public String contactId { get; set; }
		@auraEnabled
		public String name { get; set; }
		@auraEnabled
		public String email { get; set;}
		@auraEnabled
		public String phoneNumber { get; set; }
	}
	@auraEnabled
	public static ContactInfoWrapper getContactInfo(String contactId) {
		ContactInfoWrapper wrapper = new ContactInfoWrapper();
		//added  for PMD Error - NOKIASC-32425
		for (Contact con : [SELECT Id, Name, Email, Phone, MobilePhone FROM Contact WHERE Id =:contactId ]) {
			wrapper.contactId = String.valueOf(con.Id);
			wrapper.name = String.valueOf(con.Name);
			wrapper.email = String.valueOf(con.Email);
			if(con.MobilePhone != '' && con.MobilePhone != null){
	wrapper.phoneNumber = con.MobilePhone;
			} else {
	wrapper.phoneNumber = con.Phone != null ? String.valueOf(con.Phone) : '';
			}
		}  
		return wrapper;
	}
	@auraEnabled
	public static String warrantyCheck(String materialCode,String serialNumber,String sourceSystem) {
		return HWS_Utilty.warrantyCheck(materialCode,serialNumber,sourceSystem);		
	}
	/****************************************
* Name : checkWarrantyVerification
* Description : returns boolean
* Parameters: Parent case Id
* Returns : Boolean
* written on 6th Nov 2020
* By Satya Pagadala
* User Story : NOKIASC-32645
*****************************************/
	@auraEnabled
	public static Boolean checkWarrantyVerification(Id parentCaseId){   
		Boolean verificationRequired = false;
		for(Case c: [Select Id, CH_InternalStatus__c from Case where Id =:parentCaseId ]){
			if(c.CH_InternalStatus__c !=null && c.CH_InternalStatus__c =='Warranty Verification Required'){
	verificationRequired = true;
			}	
		}
		return verificationRequired;		
	}
	
		 /****************************************32414
* Name : getAccounts
* Description : method to findout List of Accounts based on account ids
* Parameters: string accountId
* Returns : List<Account>
*****************************************/  
	@auraEnabled
	public static list<Account> getAccounts(string accountId) {  
		Set<id> acc = new set<id>();
		acc.add(accountId);
	List<Account> lAccounts = HWS_Utilty.getAccounts(acc);
		return lAccounts;
	}
	@auraEnabled
	public static List<ContractLineItem> showRetroAccount(string contractLineItemId) {
		//NOKIASC-37617 - Updated return type and query
		List<ContractLineItem> ContractLineItemList = new List<ContractLineItem>();
		ContractLineItemList = [SELECT ServiceContract.CH_CDB_ContractType__c,
				ServiceContract.HWS_SalesOrganisation__c,  
				CH_ServiceItemDescription__c,ServiceContract.HWS_Retrofit_Type__c
				From ContractLineItem WHERE Id=:contractLineItemId 
				  AND ServiceContract.CH_CDB_ContractType__c ='Internal - RFT - Retrofit' ];
	 
	return ContractLineItemList;
	} 
	/****************************************   
	* Name : getServicedAccountNumbers
	* Description : method to get ServicedAccountNumbers
	* Parameters: 
	* Returns : String
	*****************************************/   
	@AuraEnabled
	public static String getServicedAccountNumbers()
	{	
		String servicedAccNum = '';
		HWS_GenericSettings__c record = HWS_GenericSettings__c.getValues('HWS_ServicedAccountNumber');
		servicedAccNum  = (String) record.get('HWS_Field1__c');
		return servicedAccNum;	 
	}
	/****************************************   
* Name : getSuspensionStatus
* Description : method to get getSuspensionStatus
* Parameters: Contact Id,Service Contract Id
* Returns : String
*  written on 07-Dec-21
* By :TCS
* User Story : HWSDDP-144
*****************************************/   
	@AuraEnabled
	public static List<HWS_Suspension__c> getSuspensionStatus(String contactList,List<String>  serviceContractList)
	{	
		return [select HWS_Service_Contract_Name__c from HWS_Suspension__c  where HWS_Contact_Name__c=:contactList
				and HWS_Service_Contract_Name__c IN :serviceContractList and HWS_Suspension_Status__c='Suspended'];			  
	}
	
}