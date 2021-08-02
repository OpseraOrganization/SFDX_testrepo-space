/****************************************
* Name : HWS_Utilty
* Author : TCS
* Description : This class is for utlility
* ReqNo : 
****************************************/
public without sharing class HWS_Utilty {
	//Added by Ajesh
	public static Map<String, Id> bhNameIdMap = new Map<String, Id>();
	public static Map<String, String> bhTimezoneIdMap = new Map<String, String>();
	public static List<BusinessHours> listBusinessHours = new List<BusinessHours>();
	public static Map<Id, BusinessHours> busMap = new Map<Id, BusinessHours>();
	//Added by Kunal
	public static String Latitude	{get; set;}
	public static String Longitude	  {get; set;}
	//public static String TimeZone	{get; set;}
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
* Description : This returns the list of Accounts based on the Account Ids in AccountContactRelation
* Parameters: Account Id
* Returns : List of Accounts 
*****************************************/
	//HWST_4125 added CH_Account_Name_Alias__c field for Account alias for portal
	public static List<Account> getAccounts(Set<Id> listAccIds){
		System.debug('listAccIds'+listAccIds);
		List<Account> listAccounts = [select id,Acc_No__c,AccountNumber,Name,CH_Account_Name_Alias__c,CH_ParentAccountName__c,OperationalCustomerName__c from Account where id in:listAccIds];
		
		return listAccounts;
	}
	
	/****************************************
* Name : getAccountContactsRelation
* Description : This returns the list of Accounts based on the Account Ids in AccountContactRelation
* Parameters: Contact Id and Legal Account Id
* Returns : List of AccountContactRelations 
*****************************************/
	public static List<AccountContactRelation> getAccountContactsRelation(Id contactid, Id legalAccount){	
		system.debug('contactid' +contactid +'legalAccount' +legalAccount);
		list<AccountContactRelation> listAccounsContacts = [SELECT Id,accountId FROM AccountContactRelation where Contact.id = :contactid 
						AND Account.RecordTypeId = :legalAccount];
		return listAccounsContacts;
	}
	
	/****************************************
* Name : getEntitlementContact
* Description : This returns the list of EntitlementContacts based on the Contact Ids 
* Parameters: Contact Id and Legal Account Id
* Returns : List of EntitlementContact 
*****************************************/
	public static List<EntitlementContact> getEntitlementContact(Id contactid, Id legalAccount){	
		
		system.debug('contactid' +contactid +'legalAccount' +legalAccount);
		list<EntitlementContact> listEntitlementContacts = [SELECT Id,EntitlementId,Entitlement.AccountId,Entitlement.Account.Name,Entitlement.Name,ContactId FROM EntitlementContact where ContactId = :contactId AND Entitlement.Account.RecordTypeId = :legalAccount ];
		
		return listEntitlementContacts;
	}
	
	/****************************************
* Name : getAllServiceTypes
* Description : This returns the list of Assets based on the Product Id and Account Id where service contract status is neither expired nor inactive
* Parameters: Product Id and Account Id
* Returns : List of Assets 
*****************************************/
	public static List<Asset> getAllServiceTypes(Set<Id> prodIds, Set<Id> accIds){
		
		List<Asset> serviceTypes = [SELECT Id,HWS_Service_Contract_Number__c,HWS_Currency__c,HWS_Price__c,Contract_Number__c,HWS_ContractLineItem__c,HWS_ContractLineItem__r.CH_LineItemEntitlementScript__c,HWS_ContractLineItem__r.ServiceContract.CH_EntitlementScript__c,HWS_ContractLineItem__r.ServiceContractId,HWS_ContractLineItem__r.ServiceContract.HWS_Currency__c, HWS_ContractLeadTimeUnit__c,AccountId,HWS_ContractLeadTimeDuration__c,Product2Id,Product2.Name,ProductCode,
			HWS_Service_Type__c,HWS_Product_Name__c,HWS_ContractLineItem__r.ServiceContract.CH_CountryCode__c,HWS_ContractLineItem__r.ServiceContract.CH_CountryName__c,HWS_SpecifiedDeliveryTargetTime__c,HWS_High_Level_Product_Name__c, HWS_ContractLineItem__r.CH_CountryISOName__c FROM Asset WHERE Product2Id IN: prodIds AND AccountId IN: accIds AND HWS_ContractLineItem__r.ServiceContract.NCP_External_Status__c = 'Active'];
		
		return serviceTypes;
	}
	
	/****************************************
* Name : plannedDeliveryDateTime
* Description : This returns the planned delivery date based on the Business Hours, Contract Lead Time Unit and Contract Lead Time Duration
* Parameters: Business Hours Id, Contract Lead Time Unit, Contract Lead Time Duration
* Returns : Planned Delivery Date
*****************************************/
	public static DateTime plannedDeliveryDateTime(Id businessHrsId, String leadTimeUnit, String leadTimeDuration,Date faultyUnitDate,String specifiedTime){
		System.debug('businessHrsId:'+businessHrsId+'-leadTimeUnit:'+leadTimeUnit+'-leadTimeDuration:'+leadTimeDuration+'specifiedTime:'+specifiedTime);
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
			bh = [SELECT Id,TimeZoneSidKey FROM BusinessHours WHERE Name =: '24x7'];		
		}
		/*
if( businessHrsId == null){
bh = [SELECT Id,TimeZoneSidKey FROM BusinessHours WHERE Name =: '24x7'];  
}else{
bh = [SELECT Id,TimeZoneSidKey FROM BusinessHours WHERE Id=:businessHrsId];
}*/
		if(specifiedTime!='' && specifiedTime!=null){
			List<String> minuts = specifiedTime.split(':');
			if(leadTimeUnit == 'Business Days'){
	//system.debug('date time now###'+plannedDT);
	if(faultyUnitDate!=null){
		plannedDT=faultyUnitDate;
	}
	DateTime businessDays = addDays(plannedDT,Integer.valueOf(leadTimeDuration),bh.Id);
	//System.debug('businessDays:'+businessDays+'-- '+businessDays.date());
	// (businessDays.date() + 17 hrs ) -
	Datetime businessDate = datetime.newInstanceGMT(businessDays.year(), businessDays.month(),businessDays.day());
	Datetime businessDateaddhourOnly = businessDate.addHours(Integer.valueOf(minuts[0]));
	Datetime businessDateaddhours = businessDateaddhourOnly.addMinutes(Integer.valueOf(minuts[1]));
	System.debug('businessDays add hours:'+businessDateaddhours);
	plannedDT = businessDateaddhours; 
	System.debug('plannedDT***:'+plannedDT);
			}
			else if(leadTimeUnit == 'Calendar Days'){
	//HWST-3982
	if(faultyUnitDate!=null){
		plannedDT=faultyUnitDate;
	}else{
		plannedDT = DateTime.now();
	}
	//Datetime nextStart = BusinessHours.nextStartDate(bh.Id, plannedDT);
	Datetime nextStart = BusinessHours.nextStartDate(bh.Id, plannedDT);
	Datetime businessDate = datetime.newInstanceGMT(nextStart.year(), nextStart.month(),nextStart.day());
	nextStart = businessDate.addDays(Integer.valueOf(leadTimeDuration));
	nextStart = nextStart.addHours(Integer.valueOf(minuts[0]));
	nextStart = nextStart.addMinutes(Integer.valueOf(minuts[1]));
	System.debug('nextStart after addHours:'+nextStart);
	plannedDT = nextStart; 
			}
			string dateTimeInString = plannedDT.format('yyyy/MM/dd HH:mm:ss', bh.TimeZoneSidKey);
			DateTime PlannedDate = DateTime.valueOfGmt(dateTimeInString.replaceAll('/','-'));
			System.debug('PlannedDate:***'+PlannedDate);
			Long milliseconds = PlannedDate.getTime() - plannedDT.getTime();
			Long seconds = milliseconds / 1000;
			Long minutes = seconds / 60;
			decimal hours = minutes / 60;
			plannedDT = plannedDT.addMinutes(-Integer.valueOf(minutes));
			System.debug('plannedDT:**'+plannedDT);
		}
		else{
			Long interval;
			if(faultyUnitDate!=null ){
	plannedDT = faultyUnitDate;
			}
			System.debug('plannedDT***'+plannedDT+'**'+bh.Id);
			if(leadTimeUnit.containsIgnoreCase('Business Days')){
	if(faultyUnitDate!=null){
		plannedDT=faultyUnitDate;
	}
	DateTime businessDays = addDays(plannedDT,Integer.valueOf(leadTimeDuration),bh.Id);
	plannedDT = businessDays;//DateTime.newInstance(yr, mo, d);
			}else if(leadTimeUnit.containsIgnoreCase('Hours')){
	interval = Integer.valueOf(leadTimeDuration) * 60 * 60 * 1000;
	plannedDT = BusinessHours.add(bh.id, plannedDT,interval);
	System.debug('plannedDT**'+plannedDT);
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
	//Datetime nextStart = BusinessHours.nextStartDate(bh.Id, DateTime.now());
	Datetime nextStart = plannedDT;
	nextStart = nextStart.addDays(Integer.valueOf(leadTimeDuration));
	System.debug('nextStart after addDays:'+nextStart);
	plannedDT = nextStart; 
			}
			
		}
		//System.debug('plannedDT *****'+plannedDT);
		
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
		//system.debug('Return next business working day###'+startDate);
		
		return startDate;
	}
	
	/****************************************
* Name : plannedDeliveryDateTimeBulk
* Description : This returns the planned delivery date based on the Business Hours, Contract Lead Time Unit and Contract Lead Time Duration
* Parameters: Business Hours Id, Contract Lead Time Unit, Contract Lead Time Duration
* Returns : Planned Delivery Date
*****************************************/
	/*public static Map<Id, DateTime> plannedDeliveryDateTimeBulk(List<HWS_BulkUpload__c> buList){

//(Id businessHrsId, String leadTimeUnit, String leadTimeDuration,Date faultyUnitDate,String specifiedTime){
Map<Id, DateTime> plannedDTBUIdMap = new Map<Id, DateTime>();
if(buList.size()>0){
Set<Id> bhIdSet = new Set<Id>();
for(HWS_BulkUpload__c bu : buList){
bhIdSet.add(bu.HWS_Asset__r.HWS_ContractLineItem__r.CH_BusinessHour__r.Id);
}

Map<Id,BusinessHours> bhMap = new Map<Id,BusinessHours>([SELECT Id, TimeZoneSidKey FROM BusinessHours WHERE Id IN :bhIdSet]);
BusinessHours bh24 = [SELECT Id,TimeZoneSidKey FROM BusinessHours WHERE Name =: '24x7'];

BusinessHours bh;
Date now= Date.Today(); 
String specifiedTime;	 
Date faultyUnitDate = null;		 
for(HWS_BulkUpload__c bu : buList){
if(bhMap.size()>0){
if(bhMap.containsKey(bu.HWS_Asset__r.HWS_ContractLineItem__r.CH_BusinessHour__r.Id)){
bh = bhMap.get(bu.HWS_Asset__r.HWS_ContractLineItem__r.CH_BusinessHour__r.Id);
}
else{
bh = bh24;
}
}
else{
bh = bh24;
}
specifiedTime = bu.HWS_Asset__r.HWS_SpecifiedDeliveryTargetTime__c;
String leadTimeUnit = bu.HWS_Asset__r.HWS_ContractLeadTimeUnit__c;
faultyUnitDate = null;
String leadTimeDuration = bu.HWS_Asset__r.HWS_ContractLeadTimeDuration__c;
DateTime plannedDT = Datetime.now();

if(specifiedTime!='' && specifiedTime!=null){
List<String> minuts = specifiedTime.split(':');
if(leadTimeUnit == 'Business Days'){
DateTime businessDays = addDays(plannedDT,Integer.valueOf(leadTimeDuration),bh.Id);
//System.debug('businessDays:'+businessDays+'-- '+businessDays.date());
// (businessDays.date() + 17 hrs ) -
Datetime businessDate = datetime.newInstanceGMT(businessDays.year(), businessDays.month(),businessDays.day());
Datetime businessDateaddhourOnly = businessDate.addHours(Integer.valueOf(minuts[0]));
Datetime businessDateaddhours = businessDateaddhourOnly.addMinutes(Integer.valueOf(minuts[1]));
System.debug('businessDays add hours:'+businessDateaddhours);
plannedDT = businessDateaddhours; 
System.debug('plannedDT***:'+plannedDT);
}
else if(leadTimeUnit == 'Calendar Days'){
//HWST-3982			
//Datetime nextStart = BusinessHours.nextStartDate(bh.Id, plannedDT);
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
decimal hours = minutes / 60;
plannedDT = plannedDT.addMinutes(-Integer.valueOf(minutes));		
}	  
else{
Long interval;	 
if(leadTimeUnit.containsIgnoreCase('Business Days')){		
DateTime businessDays = addDaysBulk(plannedDT,Integer.valueOf(leadTimeDuration),bh.Id);
plannedDT = businessDays;//DateTime.newInstance(yr, mo, d);
}else if(leadTimeUnit.containsIgnoreCase('Hours')){
interval = Integer.valueOf(leadTimeDuration) * 60 * 60 * 1000;
plannedDT = BusinessHours.add(bh.id, plannedDT,interval);		
}else if(leadTimeUnit.containsIgnoreCase('Minutes')){
interval = Integer.valueOf(leadTimeDuration) * 60 * 1000;
plannedDT = BusinessHours.add(bh.id, plannedDT,interval);
}else if(leadTimeUnit == 'Calendar Days'){	
plannedDT = DateTime.now();

//Datetime nextStart = BusinessHours.nextStartDate(bh.Id, DateTime.now());
Datetime nextStart = plannedDT;
nextStart = nextStart.addDays(Integer.valueOf(leadTimeDuration));		
plannedDT = nextStart; 
}

}
plannedDTBUIdMap.put(bu.Id, plannedDT);
}
}
return plannedDTBUIdMap;

}*/
	
	/****************************************
* Name : addDaysBulk
* Description : This returns the date in numberOfDays business days 
* Parameters: Start Date, Contract Lead Time Duration, Business Hours
* Returns : Returns back date in numberOfDays business days 
**************************************************************/	
	/*public static Datetime addDaysBulk(Datetime startDate, Integer days, Id businessHourId)
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
//system.debug('Return next business working day###'+startDate);

return startDate;
}*/
	
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
		String classification='HWS Service';
		Boolean sync = true;
		//2503 SPS Last Order Date validation started added HWS_Product_SPSLOD__c field
		//NOKIASC-25659 for NEA count  added CH_QtyCoveredNetworkElementAssets__c field
		String assetQuery = 'SELECT Id,HWS_SourceSystem__c,HWS_Product_SPSLOD__c,HWS_SpecifiedDeliveryTargetTime__c,HWS_Service_Contract_Number__c,HWS_Currency__c,HWS_Price__c,Contract_Number__c,HWS_ContractLineItem__c,HWS_ContractLineItem__r.ServiceContract.HWS_Currency__c, HWS_ContractLineItem__r.CH_LineItemEntitlementScript__c,HWS_ContractLineItem__r.ServiceContract.CH_EntitlementScript__c,HWS_ContractLineItem__r.ServiceContract.CH_CountryCode__c,HWS_ContractLineItem__r.ServiceContract.CH_CountryName__c,HWS_ContractLineItem__r.ServiceContractId,HWS_ContractLineItem__r.CH_CoverageGroup__c,HWS_ContractLineItem__r.HWS_AdditionalSIInfo1__c,HWS_ContractLeadTimeUnit__c,AccountId,HWS_ContractLeadTimeDuration__c,Product2Id,Product2.Name,ProductCode,'+
			'HWS_ServiceItemCode__c,HWS_ContractLineItem__r.ServiceContract.CH_ERPSystem__c, HWS_Part_Code__c,HWS_Service_Type__c,HWS_Product_Name__c, HWS_ContractLineItem__r.CH_BusinessHour__r.Id,HWS_ServiceItemDescription__c,HWS_ServiceOffering__c,HWS_High_Level_Product_Name__c, HWS_ContractLineItem__r.CH_QtyCoveredNetworkElementAssets__c,  HWS_ContractLineItem__r.CH_CountryISOName__c FROM Asset WHERE Product2Id IN: prodIds AND AccountId IN: accIds AND (HWS_ContractLineItem__r.ServiceContract.NCP_External_Status__c =: externalStatus) AND HWS_ContractLineItem__r.CH_ServiceClassification__c=: classification AND HWS_ContractLineItem__r.NCP_External_Status__c=: externalStatus AND HWS_ExternalStatus__c=: externalStatus AND HWS_IsSynced__c =:sync';
		//getting only Authorized serviceContract Records
		//3697 - passing contactId  ****************Start*********
		List<EntitlementContact> servContList = [select id, Entitlement.Name, Entitlement.ServiceContract.Name, Entitlement.ServiceContract.Id, Entitlement.ServiceContract.ContractNumber, Entitlement.Account.Name, Entitlement.AccountId, contact.Name, ContactId from EntitlementContact where ContactId = :contactId];
		Map<Id, Set<String>> servContrMap = new Map<Id, Set<String>>();
		if(servContList.size()>0){
			for(EntitlementContact ent:servContList){		
	if(servContrMap.containskey(ent.Entitlement.AccountId)){
		servContrMap.get(ent.Entitlement.AccountId).add(ent.Entitlement.ServiceContract.ContractNumber);
	}
	else{
		servContrMap.put(ent.Entitlement.AccountId, new Set<String>{ent.Entitlement.ServiceContract.ContractNumber});
	}
			}
		}
		Set<String> contrSet = new Set<String>();
		List<String> actLst = new List<String>();
		for(Id i :accIds){
			actLst.add(i);
		}
		if(servContrMap.Containskey(actLst[0])){
			contrSet = servContrMap.get(actLst[0]);
		}
		if(contrSet.size()>0){
			assetQuery = assetQuery+' AND Contract_Number__c IN: contrSet';
		}
		//******************************End*********
		if(contractNumber != null && contractNumber!=''){
			assetQuery = assetQuery+' AND HWS_Service_Contract_Number__c=: contractNumber';
		}
		if(serviceType != null && serviceType !=''){
			assetQuery = assetQuery+' AND HWS_Service_Type__c=: serviceType';
		}
		if(country != null && country !=''){
			assetQuery = assetQuery+' AND HWS_ContractLineItem__r.CH_CountryISOName__c=: country';
		}
		System.debug('assetQuery'+assetQuery);
		list<Asset> listAssets = database.query(assetQuery);
		System.debug('listAssets**'+listAssets);
		
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
		String classification='HWS Service';
		Boolean sync = true;
		//2503 SPS Last Order Date validation started added HWS_Product_SPSLOD__c field
		String assetQuery = 'SELECT Id,HWS_SourceSystem__c,HWS_Product_SPSLOD__c,HWS_Service_Contract_Number__c,HWS_Currency__c,HWS_Price__c,Contract_Number__c,HWS_ContractLineItem__c,HWS_ContractLineItem__r.ServiceContract.HWS_Currency__c, HWS_ContractLineItem__r.CH_LineItemEntitlementScript__c,HWS_ContractLineItem__r.ServiceContract.CH_EntitlementScript__c,HWS_ContractLineItem__r.ServiceContract.CH_CountryCode__c,HWS_ContractLineItem__r.ServiceContract.CH_CountryName__c,HWS_ContractLineItem__r.CH_CountryISOName__c,HWS_ContractLineItem__r.ServiceContractId,HWS_ContractLineItem__r.HWS_AdditionalSIInfo1__c,HWS_ContractLeadTimeUnit__c,AccountId,HWS_ContractLeadTimeDuration__c,Product2Id,ProductCode,'+
			'HWS_ServiceItemCode__c,HWS_ContractLineItem__r.ServiceContract.CH_ERPSystem__c, HWS_Part_Code__c,HWS_Service_Type__c,HWS_Product_Name__c, HWS_ContractLineItem__r.CH_BusinessHour__r.Id,HWS_ServiceItemDescription__c,HWS_ServiceOffering__c,HWS_SpecifiedDeliveryTargetTime__c,HWS_High_Level_Product_Name__c FROM Asset WHERE Product2Id IN: prodIds AND AccountId IN: accIds AND (HWS_ContractLineItem__r.ServiceContract.NCP_External_Status__c =: externalStatus) AND HWS_ContractLineItem__r.CH_ServiceClassification__c=: classification AND HWS_ContractLineItem__r.NCP_External_Status__c=: externalStatus AND HWS_ExternalStatus__c=: externalStatus AND HWS_IsSynced__c =:sync';
		/* if(authServContrNum.size()>0){
assetQuery = assetQuery+' AND Contract_Number__c IN: authServContrNum';
}*/
		if(contractNumber != null && contractNumber!=''){
			assetQuery = assetQuery+' AND HWS_Service_Contract_Number__c=: contractNumber';
		}
		if(serviceType != null && serviceType !=''){
			assetQuery = assetQuery+' AND HWS_Service_Type__c=: serviceType';
		}
		System.debug('assetQuery'+assetQuery);
		list<Asset> listAssets = database.query(assetQuery);
		System.debug('listAssets**'+listAssets);
		
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
		String strQuery= 'SELECT id,Material_Code__c,CLEI__c,Comcode__c,Name,HWS_Product_Name__c,HWS_Version_Code__c,HWS_Hardware_Sellable_Item__c,HWS_Part_Code_Part_Revision__c FROM hws_versionitem__c '+
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
		String classification='HWS Service';
		String externalStatus = 'Active';
		//2503
		//NOKIASC-25659 for NEA count  added CH_QtyCoveredNetworkElementAssets__c field
		String strQuery='SELECT Id, CH_ServiceClassification__c,CH_QtyCoveredNetworkElementAssets__c,PricebookEntry.Product2.HWS_SPS_Last_Order_Date__c,HWS_AdditionalSIInfo1__c,CH_ServiceType__c,ServiceContract.CH_ERPSystem__c,HWS_ServiceContractName__c,HWS_ServiceContractNumber__c,ServiceContract.CH_EntitlementScript__c,CH_LineItemEntitlementScript__c,ServiceContract.CH_CountryCode__c,ServiceContract.CH_CountryName__c,CH_CoverageGroup__c, CH_CountryISOName__c FROM ContractLineItem '+
			'WHERE (ServiceContract.CH_CARES_ServiceAgreement__c LIKE :contractNumber OR ServiceContract.CH_SAP_ContractNumber__c LIKE :contractNumber) AND ServiceContract.AccountId IN: accIds AND (ServiceContract.NCP_External_Status__c =: externalStatus) AND NCP_External_Status__c=: externalStatus AND CH_ServiceClassification__c=:classification';
		//getting only Authorized serviceContract Records
		//3697 - passing contactId *************Start*********
		//Id contactId;
		List<EntitlementContact> servContList = [select id, Entitlement.Name, Entitlement.ServiceContract.Name, Entitlement.ServiceContract.Id, Entitlement.ServiceContract.ContractNumber, Entitlement.Account.Name, Entitlement.AccountId, contact.Name, ContactId from EntitlementContact where ContactId = :contactId];
		Map<Id, Set<String>> servContrMap = new Map<Id, Set<String>>();
		if(servContList.size()>0){
			for(EntitlementContact ent:servContList){		
	if(servContrMap.containskey(ent.Entitlement.AccountId)){
		servContrMap.get(ent.Entitlement.AccountId).add(ent.Entitlement.ServiceContract.ContractNumber);
	}
	else{
		servContrMap.put(ent.Entitlement.AccountId, new Set<String>{ent.Entitlement.ServiceContract.ContractNumber});
	}
			}
		}
		Set<String> contrSet = new Set<String>();
		List<String> actLst = new List<String>();
		for(Id i :accIds){
			actLst.add(i);
		}
		if(servContrMap.Containskey(actLst[0])){
			contrSet = servContrMap.get(actLst[0]);
		}
		//******************************End*********
		if(contrSet.size()>0){
			strQuery = strQuery+' AND ServiceContract.ContractNumber IN: contrSet';
		}
		
		if(serviceType != null && serviceType !=''){
			strQuery = strQuery+' AND CH_ServiceType__c=: serviceType';
		}
		if(selectedContractNumber != null && selectedContractNumber !=''){
			strQuery = strQuery+' AND (ServiceContract.CH_CARES_ServiceAgreement__c=: selectedContractNumber OR ServiceContract.CH_SAP_ContractNumber__c=: selectedContractNumber)' ;
		}
		listserviceContracts = database.query(strQuery);
		System.debug('listserviceContracts'+listserviceContracts);
		
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
		System.debug('servIDs'+servIDs);
		String ExternalStatus = 'Active';
		Boolean sync = true;
		//2503
		list<Asset> listAssets = [SELECT Id,HWS_SourceSystem__c,HWS_Service_Contract_Number__c,HWS_Product_SPSLOD__c,Contract_Number__c,HWS_ContractLineItem__r.CH_LineItemEntitlementScript__c,HWS_ContractLineItem__r.ServiceContract.CH_EntitlementScript__c,HWS_ContractLeadTimeDuration__c,AccountId,HWS_ContractLeadTimeUnit__c,Product2Id,Product2.Name,ProductCode,HWS_Currency__c,HWS_Price__c,
		  HWS_ServiceItemCode__c,HWS_ServiceItemDescription__c,HWS_ServiceOffering__c,HWS_ContractLineItem__r.ServiceContract.CH_ERPSystem__c,HWS_Service_Type__c,HWS_Part_Code__c,HWS_Product_Name__c,HWS_ContractLineItem__r.HWS_AdditionalSIInfo1__c,HWS_ContractLineItem__r.CH_BusinessHour__r.Id,HWS_ContractLineItem__r.ServiceContract.CH_CountryCode__c,HWS_ContractLineItem__r.ServiceContract.CH_CountryName__c,HWS_ContractLineItem__r.CH_CountryISOName__c,HWS_SpecifiedDeliveryTargetTime__c,HWS_High_Level_Product_Name__c FROM Asset WHERE HWS_ContractLineItem__c IN: servIDs AND HWS_ExternalStatus__c=: ExternalStatus AND HWS_IsSynced__c =:sync];
		
		return listAssets;
	}
	
	/**************************************** 
* Name : getDependentMap
* Description : 
* Parameters: Object Name, Billing Country, Billing State 
* Returns : 
*****************************************/
	@AuraEnabled 
	public static Map<String, List<String>> getDependentMap(sObject objDetail, string contrfieldApiName,string depfieldApiName) {	
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
		String classification='HWS Service';
		String externalStatus = 'Active';
		Boolean enableForPortal = true;
		//2503
		String strQuery='SELECT Id, CH_ServiceClassification__c,PricebookEntry.Product2.HWS_SPS_Last_Order_Date__c,HWS_AdditionalSIInfo1__c,CH_ServiceType__c,HWS_ServiceContractName__c,HWS_ServiceContractNumber__c,ServiceContract.CH_EntitlementScript__c,CH_LineItemEntitlementScript__c,ServiceContract.CH_CountryCode__c,ServiceContract.CH_CountryName__c, CH_QtyCoveredNetworkElementAssets__c  FROM ContractLineItem '+
			'WHERE (ServiceContract.CH_CARES_ServiceAgreement__c LIKE :contractNumber OR ServiceContract.CH_SAP_ContractNumber__c LIKE :contractNumber) AND ServiceContract.AccountId =: accId AND (ServiceContract.NCP_External_Status__c =: externalStatus) AND NCP_External_Status__c=: externalStatus AND CH_ServiceClassification__c=:classification AND ServiceContract.CH_PortalCaseCreationHWS__c =: enableForPortal';
		//getting only Authorized serviceContract Records
		//3697 - passing contactId  ****************Start*********
		List<EntitlementContact> servContList = [select id, Entitlement.Name, Entitlement.ServiceContract.Name, Entitlement.ServiceContract.Id, Entitlement.ServiceContract.ContractNumber, Entitlement.Account.Name, Entitlement.AccountId, contact.Name, ContactId from EntitlementContact where ContactId = :contactId];
		Map<Id, Set<String>> servContrMap = new Map<Id, Set<String>>();
		if(servContList.size()>0){
			for(EntitlementContact ent:servContList){		
	if(servContrMap.containskey(ent.Entitlement.AccountId)){
		servContrMap.get(ent.Entitlement.AccountId).add(ent.Entitlement.ServiceContract.ContractNumber);
	}
	else{
		servContrMap.put(ent.Entitlement.AccountId, new Set<String>{ent.Entitlement.ServiceContract.ContractNumber});
	}
			}
		}
		Set<String> contrSet = new Set<String>();
		if(servContrMap.Containskey(accId)){
			contrSet = servContrMap.get(accId);
		}
		if(contrSet.size()>0){
			strQuery = strQuery+' AND ServiceContract.ContractNumber IN: contrSet';
		}
		//******************************End*********
		if(serviceType != null && serviceType !=''){
			strQuery = strQuery+' AND CH_ServiceType__c=: serviceType';
		}
		if(selectedcontractNumber != null && selectedcontractNumber !=''){
			strQuery = strQuery+' AND (ServiceContract.CH_CARES_ServiceAgreement__c = :selectedcontractNumber OR ServiceContract.CH_SAP_ContractNumber__c =:selectedcontractNumber)';
		}
		listserviceContracts = database.query(strQuery);
		
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
		String classification='HWS Service';
		String externalStatus = 'Active';
		String serviceItemCode = System.Label.HWS_EnableComSparesPortal;
		Boolean sync = true;
		Boolean enableForPortal = true;
		//2503 SPS Last Order Date validation started added HWS_Product_SPSLOD__c field
		// NOKIASC-25677 added CH_CountryISOName__c field for country name capturing
		String assetQuery = 'SELECT Id,HWS_SourceSystem__c,HWS_Product_SPSLOD__c,HWS_SpecifiedDeliveryTargetTime__c,HWS_Service_Contract_Number__c,HWS_Currency__c,HWS_Price__c,Contract_Number__c,HWS_ContractLineItem__c,HWS_ContractLineItem__r.CH_LineItemEntitlementScript__c,HWS_ContractLineItem__r.ServiceContract.CH_EntitlementScript__c,HWS_ContractLineItem__r.ServiceContract.CH_CountryCode__c,HWS_ContractLineItem__r.ServiceContract.CH_CountryName__c,HWS_ContractLineItem__r.ServiceContractId,HWS_ContractLineItem__r.HWS_AdditionalSIInfo1__c,HWS_ContractLeadTimeUnit__c,AccountId,HWS_ContractLeadTimeDuration__c,Product2Id,Product2.Name,ProductCode,'+
			'HWS_ServiceItemCode__c,HWS_ContractLineItem__r.ServiceContract.HWS_Currency__c,HWS_ContractLineItem__r.ServiceContract.CH_ERPSystem__c,HWS_Part_Code__c,HWS_Service_Type__c,HWS_Product_Name__c, HWS_ContractLineItem__r.CH_BusinessHour__r.Id,HWS_ServiceItemDescription__c,HWS_ServiceOffering__c,HWS_High_Level_Product_Name__c, HWS_ContractLineItem__r.CH_QtyCoveredNetworkElementAssets__c, HWS_ContractLineItem__r.CH_CountryISOName__c FROM Asset WHERE  HWS_ServiceItemCode__c !=: serviceItemCode AND Product2Id IN: prodIds AND AccountId =: accId AND (HWS_ContractLineItem__r.ServiceContract.NCP_External_Status__c =: externalStatus) AND HWS_ContractLineItem__r.CH_ServiceClassification__c=: classification AND HWS_ContractLineItem__r.NCP_External_Status__c=: externalStatus AND HWS_ExternalStatus__c=: externalStatus AND HWS_IsSynced__c =:sync AND HWS_ContractLineItem__r.ServiceContract.CH_PortalCaseCreationHWS__c =: enableForPortal'; 
		//getting only Authorized serviceContract Records
		//3697 - passing contactId  ****************Start*********
		List<EntitlementContact> servContList = [select id, Entitlement.Name, Entitlement.ServiceContract.Name, Entitlement.ServiceContract.Id, Entitlement.ServiceContract.ContractNumber, Entitlement.Account.Name, Entitlement.AccountId, contact.Name, ContactId from EntitlementContact where ContactId = :contactId];
		Map<Id, Set<String>> servContrMap = new Map<Id, Set<String>>();
		if(servContList.size()>0){
			for(EntitlementContact ent:servContList){		
	if(servContrMap.containskey(ent.Entitlement.AccountId)){
		servContrMap.get(ent.Entitlement.AccountId).add(ent.Entitlement.ServiceContract.ContractNumber);
	}
	else{
		servContrMap.put(ent.Entitlement.AccountId, new Set<String>{ent.Entitlement.ServiceContract.ContractNumber});
	}
			}
		}
		Set<String> contrSet = new Set<String>();
		/*List<String> actLst = new List<String>();
for(Id i :accIds){
actLst.add(i);
}*/
		if(servContrMap.Containskey(accId)){
			contrSet = servContrMap.get(accId);
		}
		if(contrSet.size()>0){
			assetQuery = assetQuery+' AND Contract_Number__c IN: contrSet';
		}
		System.debug('contractNumber:'+contractNumber); 
		//******************************End*********
		if(contractNumber != null && contractNumber!=''){
			assetQuery = assetQuery+' AND HWS_Service_Contract_Number__c=: contractNumber';
		}
		if(serviceType != null && serviceType !=''){
			assetQuery = assetQuery+' AND HWS_Service_Type__c=: serviceType';
		}
		// NOKIASC-25669 
		if(country != null && country !=''){
			assetQuery = assetQuery+' AND HWS_ContractLineItem__r.CH_CountryISOName__c=: country';
		}
		System.debug('assetQuery'+assetQuery);
		list<Asset> listAssets = database.query(assetQuery);
		System.debug('listAssets**'+listAssets);
		
		return listAssets;
	}
	
	public static Id childRecordTypes(String serviceType){		
		Id caseRecTypeId;
		HWS_ChildCase_Record_Types__mdt caseRecTypes = [SELECT MasterLabel,HWS_Service_Type__c,HWS_Rercord_Type__c FROM HWS_ChildCase_Record_Types__mdt where HWS_Service_Type__c=:serviceType]; 
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
			system.debug('-----'+chkUserAcc);
		}
		List<UserRecordAccess> lstUserRA = [SELECT RecordId FROM UserRecordAccess WHERE UserId=:UserInfo.getUserId() AND HasReadAccess = true AND RecordId IN :chkUserAcc];
		system.debug('------lstUserRA----'+lstUserRA);
		Set<Id> accid = new Set<Id>();
		for(UserRecordAccess ura : lstUserRA){
			accid.add(ura.RecordId);
		}
		system.debug('---accid--'+accid);
		// Create a new AccountShare object
		List<AccountShare> shares = new List<AccountShare>();
		Id getUseRId  = UserInfo.getUserId();
		for (string rec : shipAccId) {	
			AccountShare accShr  = new AccountShare();
			system.debug('--shipaccId-----'+Id.valueOf(rec));
			system.debug('--accid----643-'+accid);
			
			if(!accid.contains(Id.valueOf(rec))){
	system.debug('-Enter shared method-');
	accShr.AccountId = Id.valueOf(rec);
	//Set the portal user Id to share the account
	accShr.UserOrGroupId =UserInfo.getUserId();
	accShr.AccountAccessLevel  = 'Read';
	accShr.OpportunityAccessLevel = 'Read';
	accShr.RowCause = Schema.AccountShare.RowCause.Manual;
	shares.add(accShr);
	system.debug('--shares----'+shares);
			}
		} 
		if(shares.size()>0){
			List<Database.SaveResult> sr = Database.insert(shares,false);
			system.debug('------sr-----'+sr);
			for (Integer i = 0; i < shares.size(); i++) {
	Database.SaveResult s = sr[i];
	system.debug('------s-----'+s);
	AccountShare origRecord = shares[i];
	if (!s.isSuccess()) {
		system.debug(s.getId()); // I get null here
		system.debug(origRecord.Id); //This should be the Id you're looking for
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
		List<HWS_VersionItem__c> verItemList = [Select Id, HWS_Part_Code_Part_Revision__c, HWS_Version_Code__c, HWS_Hardware_Sellable_Item__c, HWS_Hardware_Sellable_Item__r.CARE_PartCode__c from HWS_VersionItem__c where HWS_Part_Code_Part_Revision__c =:searchCode ];	  
		system.debug('verItemListvvvv'+verItemList);		
		if(verItemList.size()>0){	  
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
			List<Asset> astList = [select id, HWS_Part_Code__c, HWS_Service_Type__c, Product2Id from Asset where AccountId =:accIds and HWS_ContractLineItem__r.ServiceContract.NCP_External_Status__c = 'Active' AND HWS_ContractLineItem__r.CH_ServiceClassification__c='HWS Service' AND HWS_ContractLineItem__r.NCP_External_Status__c='Active' AND HWS_ExternalStatus__c='Active' AND HWS_IsSynced__c =true ];	 
			Set<String> assetPaerCodeSet = new Set<String>();	
			if(astList.size()>0){	
	for(Asset ast :astList){		
		assetPaerCodeSet.add(ast.HWS_Part_Code__c);	 
	}	
	for(integer i =0;i<searchValue.length();i++){	
		String sc = searchValue.substring(0, searchValue.length()-i).toUpperCase();	 
		if(sc.length() >=4 && assetPaerCodeSet.contains(sc)){	
			//system.debug('Successs111'+sc);	
			partCodeSet.add(sc);		
			system.debug('settt Values'+sc);		
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
			List<HWS_VersionItem__c> viList = [SELECT HWS_Version_Code__c, HWS_Hardware_Sellable_Item__c FROM HWS_VersionItem__c where HWS_Hardware_Sellable_Item__c IN :prodIds And HWS_Version_Code__c = 'ANY'];	  
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
	//Added by Ajesh - Start
	public static plannedDeliveryDateWrapper accountTimeZoneplannedDeliveryDateTime(List<Case> listChildCases, String selectedAccountTimeZone ){
		plannedDeliveryDateWrapper pdw;
		List<PicklistEntry> bhTimeZoneList = Schema.SObjectType.BusinessHours.fields.TimeZoneSidKey.picklistvalues; 
		System.debug('caseList**'+listChildCases);
		System.debug('**selectedAccountTimeZone**'+selectedAccountTimeZone);
		//List < Account > accList = [SELECT Id,CH_TimeZone__c, CH_AccountRecordTypeName__c FROM Account WHERE ID = :selectedAccount AND CH_TimeZone__c != '' AND CH_AccountRecordTypeName__c = 'Logistic_Account'];
		List<Case> timeZoneupdatedCaseList = new List<Case>();
		List<Id> assetIds = new List<Id>();
		Map<String,Id> caseAssetIds = new Map<String, Id>();
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
			List<Asset> listAssets = [Select Id, HWS_ContractLineItem__r.CH_BusinessHour__c, HWS_ContractLeadTimeUnit__c, HWS_ContractLeadTimeDuration__c, HWS_SpecifiedDeliveryTargetTime__c from Asset where Id In:assetIds];
			for(Asset assetRec: listAssets){
	System.debug('contractLineItem:'+assetRec.HWS_ContractLineItem__c);
	assetIdBusiness.put(assetRec.Id,getBusinessHourMap.get(assetRec.HWS_ContractLineItem__r.CH_BusinessHour__c));
	System.debug('assetIdBusiness Map:'+assetRec.HWS_ContractLineItem__r.CH_BusinessHour__c);
	IdAssetMap.put(assetRec.Id,assetRec);
			}
			for(PicklistEntry p : bhTimeZoneList){
	bhTimeZoneSidKeyMap.put(p.getValue(),p.getLabel());	
			}
			for(Case caseRec : listChildCases){
	string bussinessHourName = assetIdBusiness.get(caseRec.AssetId).Name;
	System.debug('assetId'+caseRec.AssetId);
	System.debug('bussinessHourName:'+bussinessHourName);
	if(bussinessHourName != '24x7' && selectedAccountTimeZone != '24x7' && selectedAccountTimeZone != null){
		String st1 = bussinessHourName.substringAfter('|');
		String st2 = st1.substringBetween('| ',' |');
		String bussinessHourNameAccTimeZone = bussinessHourName.replace(st2, selectedAccountTimeZone);
		System.debug('bussinessHourName:'+bussinessHourName);
		if(bhNameIdMap.get(bussinessHourNameAccTimeZone) != Null){
			caseRec.HWS_Delivery_TimeZone__c = selectedAccountTimeZone;
			caseRec.BusinessHoursId = bhNameIdMap.get(bussinessHourNameAccTimeZone);
		}else{
			String s1 = bussinessHourName.substringAfter('|');
			String s2 = s1.substringBetween('| ',' |');
			caseRec.HWS_Delivery_TimeZone__c = s2;
			caseRec.BusinessHoursId = bhNameIdMap.get(bussinessHourName);
			notListedBH.add(bussinessHourName);
		}
		bhTimeZoneSidKey = bhTimezoneIdMap.get(bussinessHourName);
		bhTimeZone = bhTimeZoneSidKeyMap.get(bhTimeZoneSidKey);
	}else if(bussinessHourName == '24x7'){
		System.debug('Here11'+selectedAccountTimeZone);
					caseRec.HWS_Delivery_TimeZone__c = 'GMT';
					if(selectedAccountTimeZone!=null && selectedAccountTimeZone !=''){
			caseRec.HWS_Delivery_TimeZone__c =selectedAccountTimeZone;System.debug('caseRec.HWS_Delivery_TimeZone__c**:'+caseRec.HWS_Delivery_TimeZone__c);
					}
					caseRec.BusinessHoursId = bhNameIdMap.get(bussinessHourName);
		bhTimeZoneSidKey = bhTimezoneIdMap.get(bussinessHourName);
		bhTimeZone = bhTimeZoneSidKeyMap.get(bhTimeZoneSidKey);
		
	}else{	
		String str1 = bussinessHourName.substringAfter('|');	
		String str2 = str1.substringBetween('| ',' |');	
		caseRec.HWS_Delivery_TimeZone__c = str2;	
		caseRec.BusinessHoursId = bhNameIdMap.get(bussinessHourName);	
		notListedBH.add(bussinessHourName);	
		bhTimeZoneSidKey = bhTimezoneIdMap.get(bussinessHourName);	
		bhTimeZone = bhTimeZoneSidKeyMap.get(bhTimeZoneSidKey);	
	}
	System.debug('timeZoneupdatedCaseList:'+bhTimeZone);
	timeZoneupdatedCaseList.add(caseRec); 
			}
			
			System.debug('bhTimeZone:'+bhTimeZone);
			pdw = plannedDeliveryDateTimeCalculation(timeZoneupdatedCaseList,IdAssetMap,bhTimeZone);
		}
		System.debug('NOT LISTED BH:'+notListedBH);
		if (!notListedBH.isEmpty()){
			HWS_postToChatterForBH(notListedBH);
		}
		return pdw;
		
	}
	//Added by Ajesh - END
	public static Map<Id, BusinessHours> getBusinessHouDetails() {
		listBusinessHours = [SELECT Id,TimeZoneSidKey,Name FROM BusinessHours];
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
			DateTime plannedDatetime = plannedDeliveryDateTime(caseRec.BusinessHoursId, IdAssetMap.get(caseRec.AssetId).HWS_ContractLeadTimeUnit__c, IdAssetMap.get(caseRec.AssetId).HWS_ContractLeadTimeDuration__c, null, IdAssetMap.get(caseRec.AssetId).HWS_SpecifiedDeliveryTargetTime__c);
			caseRec.HWS_Planned_Delivery_Date__c = plannedDatetime; 
			System.debug('PlannedDate:***'+plannedDatetime);
			System.debug('bhTimeZone:***'+bhTimeZone);
			if(bhTimeZone!='24x7' && bhTimeZone!=null){
	List<String> lststrsplit = bhTimeZone.substring(12,bhTimeZone.length()).split('\\(',2);
	delTimeZone = bhTimeZone.substring(0,12);
	string strTimeZone = caseRec.HWS_Delivery_TimeZone__c;
	System.debug('strTimeZone**:'+strTimeZone);
	string strCurrentTime = plannedDatetime.format('YYYY-MM-dd HH:mm:ss', strTimeZone);
	System.debug('PlannedDate user:***'+plannedDatetime);
	System.debug('PlannedDate shipment:***'+strCurrentTime);
	caseRec.HWS_PlannedDeliveryDateShipment__c= strCurrentTime;//Datetime.valueof(strCurrentTime);
	Id businessHourId = caseRec.BusinessHoursId;
	String bsName = busMap.get(businessHourId).Name;
	if(bsName == '24x7'){
		DateTime customerDateTime = DateTime.valueofGmt(strCurrentTime);
		TimeZone customerTimeZone = TimeZone.getTimeZone(strTimeZone);
		Integer offsetToCustomersTimeZone = customerTimeZone.getOffset(customerDateTime);
		Double gmtOffset = offsetToCustomersTimeZone / (1000 * 60 *60);
		delTimeZone = getGmtValue(gmtOffset);
	}
			}
			newTimeZoneCaseList.add(caseRec);			
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
			List < Account > accList = [SELECT Id, BillingStreet, BillingCity, BillingPostalCode, BillingState, BillingCountry, HWS_TimeZone__c, CH_AccountRecordTypeName__c FROM Account WHERE ID = :accID AND CH_AccountRecordTypeName__c = 'Logistic_Account'];
			if(!accList.isEmpty()){
	accIDTimeZone.put(accID,accList[0].HWS_TimeZone__c);
			}
			List < Account > newAccList = new List < Account > ();
			if(accList.size() > 0 && (accList[0].HWS_TimeZone__c == null || accList[0].HWS_TimeZone__c == '')) {
	System.debug('**** BillingCountry: ' + accList[0].BillingCountry);
	System.debug('**** CH_AccountRecordTypeName__c: ' + accList[0].CH_AccountRecordTypeName__c);
	SYstem.debug('**multitimeZone'+CH_LocationUtils.countryIsMultiTimezone(accList[0].BillingCountry));
	//if (CH_LocationUtils.countryIsMultiTimezone(accList[0].BillingCountry)){
	try {
		Map<String, Object> result = CH_LocationUtils.getCoordinates(accList[0].BillingStreet,accList[0].BillingCity,accList[0].BillingPostalCode,accList[0].BillingState,accList[0].BillingCountry);
		Map<String, Object> coordinates = (Map<String, Object>) ((Map<String, Object>) result.get('geometry')).get('location');
		string HWS_TZ = CH_LocationUtils.getTimeZone(coordinates);
		System.debug('**** TimeZone: ' + HWS_TZ);
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
		System.debug('******* ' + ex.getMessage());
		HWS_postGoogleErrorToChatter('Failed to identify the ShipToParty address correctly');
	}
	//}
			}
		}
		return accIDTimeZone;
	}
	//Added by Kunal- End
	
	//Prateek
	public static void HWS_postToChatterForBH(List<String> businessHourNameList){
		try{
			List<CollaborationGroup> oCollaborationGroupList = [SELECT Id FROM CollaborationGroup WHERE Name = 'Error - BH Conversion' LIMIT 1];
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
			System.debug(e.getMessage());
			System.debug('Error while Posting to Chatter Groups'); 
		}
		//CH_LightningController.postToBHChatterGroup('Failed to identify a singe Business Hours with the names : \'' + errorBHList + '\'');	
	}
	
	//post any error from Google API to chatter
	//NOKIASC-25684
	//Prateek
	public static void HWS_postGoogleErrorToChatter(String errorMsg){
		try{
			List<CollaborationGroup> oCollaborationGroupList = [SELECT Id FROM CollaborationGroup WHERE Name = 'Error - BH Conversion' LIMIT 1];
			FeedItem post = new FeedItem();
			post.Body = errorMsg;
			if(!oCollaborationGroupList.isEmpty()){
	post.ParentId = oCollaborationGroupList.get(0).Id;
	insert post;
			}
		}
		catch(Exception e) { 
			System.debug(e.getMessage());
			System.debug('Error while Posting to Chatter Groups'); 
		}
	}
	
	/*************************
Method Name : getNetworkElementAssets
Description : created for NOKIASC-25662 as part of sprint-20
Created By  : Bharathi Nutakki
Created Date: 12/02/2020 (MM/DD/YYYY)
Modified By :
Modified Date:
******************************/
	public static List<Asset> getNetworkElementAssets(Id accId, Id cliId,List<Id> cliIdList){
		System.debug('CLIID:'+cliId+' CLI LIST:'+cliIdList);
		String neaRecordType = 'CH_NetworkElementAsset';
		String cneaStatus = 'Active';
		String cneaQuery = 'Select id,CH_ContractLineItem__c, CH_NetworkElementAsset__c from CH_CoveredNetworkElementAsset__c WHERE CH_NetworkElementAsset__c != null AND CH_Status__c = :cneaStatus';
		if(!cliIdList.isEmpty() && cliId == null){
			cneaQuery = cneaQuery+' AND CH_ContractLineItem__c IN :cliIdList';
		}
		else if(cliId != null){
			cneaQuery = cneaQuery+' AND CH_ContractLineItem__c = :cliId';
		}
		List<CH_CoveredNetworkElementAsset__c> cneaList = database.query(cneaQuery);		
		List<Id> astList = new List<Id>();
		for(CH_CoveredNetworkElementAsset__c cne : cneaList){
			astList.add(cne.CH_NetworkElementAsset__c);	
		}
		String neaAssetQuery = 'Select Id,Name,Product2Id,Product2.Name,CH_Solution__c,CH_Solution__r.Name,CH_ProductVariant__c,CH_ProductVariant__r.Name,CH_ProductRelease__c,CH_ProductRelease__r.Name,Address__r.CH_AddressDetails__c,CH_NetworkElementID__c,CH_LabEnvironment__c,CH_CountryISOName__c,(Select id,CH_ContractLineItem__c from Network_Element_Assets__r)  from Asset where RecordType.DeveloperName = :neaRecordType AND Id in :astList';		
		List<Asset> neaAssetList = database.query(neaAssetQuery);
		System.debug('NEAs:'+neaAssetList);
		return neaAssetList;
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
}