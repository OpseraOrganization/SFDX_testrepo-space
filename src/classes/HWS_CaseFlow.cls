/****************************************
* Name : HWS_CaseFlow
* Author : TCS
* Description : This class is for HWS_CaseFlow
* ReqNo : 
****************************************/
public without sharing class HWS_CaseFlow {
	//Method to get the Serial Number Tracked information based on the selected version item at the time of Case creation
	//@auraEnabled
	//public Date byPassDate=null;
	//
	public static Set<String> childCaseStatusesforDuplicte = new Set<String>{'Closed','Cancelled','Delivered'};
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
		
		List<hws_versionitem__c> veriosnDetails= [SELECT Id, HWS_Serial_Number_Traceable__c FROM hws_versionitem__c WHERE Id IN: verionIds];
		
		if(veriosnDetails <> null && veriosnDetails[0].HWS_Serial_Number_Traceable__c <> null 
		   && (veriosnDetails[0].HWS_Serial_Number_Traceable__c.equalsIgnoreCase('YES') || veriosnDetails[0].HWS_Serial_Number_Traceable__c.equalsIgnoreCase('Y'))){
			   serialNumberValue = 'YES';
		   }
		else{
			serialNumberValue = 'NO';
		}
		System.debug('childCaseStatusesforDuplicte: getSerialNumberInfo' +veriosnDetails[0].HWS_Serial_Number_Traceable__c);
		return serialNumberValue; 
	}
	
	/****************************************
	* Name : duplicateSerialNumberInfo
	* Description : method to findout duplicate falty unit serial for each material code
	* Parameters: string serialNumber, string materialCode
	* Returns : List<Case>
	*****************************************/
	@auraEnabled
	public static list<Case> duplicateSerialNumberInfo(string serialNumber, string materialCode){
		List<Case> caselist =[Select id,HWS_Faulty_Serial_Number__c,CaseNumber,Status From Case 
							  where (status Not in:childCaseStatusesforDuplicte ) AND Asset.HWS_Part_Code__c =: materialCode 
							  AND HWS_Faulty_Serial_Number__c =: serialNumber AND HWS_Faulty_Serial_Number__c !=null];
		Return caselist ;
	}
	
	/****************************************
	* Merged with the method getContactDetails()
	* Name : getParentAccountId
	* Description : method to return Account Id
	* Parameters: string contactId
	* Returns : String
	*****************************************
	@auraEnabled
	public static String getParentAccountId(string contactId)
	{   
		Contact accs= [SELECT Id,AccountId FROM contact where Id = :contactId];
		return accs.AccountId;
	} */
	
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
		Contact con= [SELECT Id,Name,AccountId,CH_ContactType__c,Contact_Status__c,CH_ContactTimeZone__c,Email1__c,CH_Email3__c FROM contact where Id = :contactId];		
		return con;		
	}
	
	/****************************************
	* Name : getAllAccounts
	* Description : method to findout List of Accounts based on ContactId
	* Parameters: string contactid
	* Returns : List<Account>
	*****************************************/
	
	@auraEnabled
	public static list<Account> getAllAccounts(string contactid)
	{   
		Contact con= [SELECT Id,Contact_Status__c FROM contact where Id = :contactid];
		if(con.Contact_Status__c=='Active'){
			Id legalAccount = HWS_Utilty.getRecordTypeByName('ACCOUNT',HWS_Constants.Legal_Entity);
			list<EntitlementContact> accEntitlementContact= HWS_Utilty.getEntitlementContact(contactid, legalAccount);
			set<Id> accountIds = new set<Id>();
			for(EntitlementContact ac: accEntitlementContact){
				accountIds.add(ac.Entitlement.AccountId);
			}
		   /* list<AccountContactRelation> accAccountContactRelation= HWS_Utilty.getAccountContactsRelation(contactid, legalAccount);
			
			for(AccountContactRelation ac: accAccountContactRelation){
				accountIds.add(ac.AccountId);
			}*/
			List<Account> lAccounts = HWS_Utilty.getAccounts(accountIds);
			return lAccounts;
		}
		else{
			return null;
		}
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
	
	/****************************************
	* Merged with the method getContactDetails()
	* Name : getContactName
	* Description : method to get Contact Name
	* Parameters: string contactid
	* Returns : String
	*****************************************
	@auraEnabled
	public static String getContactName(string contactid)
	{   
		System.debug('Contact Id'+contactid);
		Contact con= [SELECT Id,Name FROM contact where Id = :contactid];
		return con.Name;
		
	} */
	
	/****************************************
	* Merged with the method getContactDetails()
	* Name : getContactType
	* Description : method to get Contact Type
	* Parameters: string contactid
	* Returns : String
	*****************************************
	@auraEnabled
	public static String getContactType(string contactid)
	{   
		Contact con= [SELECT Id,CH_ContactType__c,Contact_Status__c FROM contact where Id = :contactid];
		return con.CH_ContactType__c;
		
	}*/
	
	/****************************************
	* Name : getContractlineItems
	* Description : method to get List of Assets
	* Parameters: List<Account> listAccounts,String searchValue,String serviceType, String contractNumber
	* Returns : Map<String, List<Asset>>
	*****************************************/
	 //3697 - passing contactId
	@auraEnabled
	public static Map<String, List<Asset>> getContractlineItems(List<Account> listAccounts,String searchValue,String serviceType, String contractNumber, String contactId, String country){
		String searchCode = searchValue +'%';
		String itemDesc = '%'+searchValue +'%';
		List<Asset> lCli = new List<Asset>();
		Map<String, List<Asset>> mapContractLine = new Map<String, List<Asset>>();		
		Id salesProduct = HWS_Utilty.getRecordTypeByName('Product2',HWS_Constants.SALES_PRODUCT);		
		List<HWS_AlternateProductCode__c> altVersionItemsLst = [SELECT Id, HWS_VersionItem__r.HWS_Hardware_Sellable_Item__r.Id, Name, HWS_AlternateCodeType__c
																FROM HWS_AlternateProductCode__c 
																WHERE HWS_VersionItem__r.HWS_Hardware_Sellable_Item__r.RecordTypeId =: salesProduct 
																AND Name LIKE:searchCode];	 
		
		//HWST-2965 checked HWS_OEM_manufacturer_part_code__c field 
		List<Product2> relatedProds = [SELECT Id, ProductCode 
									   FROM Product2 
									   WHERE RecordTypeId =: salesProduct 
									   AND HWS_DoNotConsider__c = false AND (ProductCode LIKE:searchCode OR Name LIKE:itemDesc OR HWS_OEM_manufacturer_part_code__c LIKE : searchCode OR CARE_PartCode__c LIKE:searchCode)];
		
		Set<Id> prodIds = new Set<Id>();
		if(altVersionItemsLst.size()<=0 && relatedProds.size()<=0){
			mapContractLine.put('Error Message1',lCli);
		}else{
			if(!altVersionItemsLst.isEmpty()){
				for(HWS_AlternateProductCode__c pd : altVersionItemsLst){
					prodIds.add(pd.HWS_VersionItem__r.HWS_Hardware_Sellable_Item__r.Id);
				}
			} 
			if(!relatedProds.isEmpty()){
				for(Product2 prod : relatedProds){
					prodIds.add(prod.Id);
				}
			}
		} 
		Set<Id> accIds = new Set<Id>();
		for(Account a : listAccounts){
			accIds.add(a.id);
		}
		 
		if(!(prodIds.isEmpty() && accIds.isEmpty())){ 
			List<Asset> accRelatedAssetProduct = [SELECT Id, ProductCode, Product2Id 
												  FROM Asset 
												  WHERE (AccountId=:accIds AND Product2Id =:prodIds)];
			
			if(accRelatedAssetProduct.size()<=0)
			{
				mapContractLine.put('Error Message3',lCli);  
				System.debug('errormessage 3 ###'+accRelatedAssetProduct.size());
			}		
			else {			  
				//3697 - passing contactId
				lCli = HWS_Utilty.getAllServiceTypes(prodIds, accIds,serviceType,contractNumber,contactId, country);
			
	if(lCli.size()<=0){
		mapContractLine.put('Error Message2',lCli);
	}
		
	else{
		mapContractLine.put('No Error',lCli); 
	}
			}
		}
		//HWST- HWST-4182		
		if(lCli.size()<=0 && searchValue.length()>6){		
			lCli = HWS_Utilty.getContractlineItemsPartCodeRevision(listAccounts, searchValue, serviceType, contractNumber, contactId, 'Console',country);		
			if(lCli.size()>0){		
	mapContractLine.put('No Error',lCli);		
			}		
		}
		return mapContractLine;
	}
	
	/****************************************
	* Name : getVersions
	* Description : method to get List of VersionItems
	* Parameters: list<Asset> listServiceServiceCon
	* Returns : List<hws_versionitem__c> 
	*****************************************/
	@auraEnabled
	public static List<hws_versionitem__c> getVersions(list<Asset> listServiceServiceCon,String searchValue){		
		String searchCode=searchValue +'%';		//String searchCode=searchValue +'%';
		List<String> versionCodeList = new List<String>();		
		Id salesProduct = HWS_Utilty.getRecordTypeByName('Product2',HWS_Constants.SALES_PRODUCT);
		String sourceSystem;
		Set<Id> sCLItmIds = new Set<Id>();
		List<hws_versionitem__c> stockableItems = new List<hws_versionitem__c>();
		for(Asset cl : listServiceServiceCon){
			sCLItmIds.add(cl.Product2Id);
			sourceSystem = cl.HWS_SourceSystem__c;
		}	   
		List<HWS_AlternateProductCode__c> altVersionItemsLst = [SELECT Id, HWS_VersionItem__r.HWS_Hardware_Sellable_Item__r.Id,HWS_VersionItem__r.HWS_Version_Code__c, Name, HWS_AlternateCodeType__c FROM HWS_AlternateProductCode__c 
																WHERE HWS_VersionItem__r.HWS_Hardware_Sellable_Item__r.RecordTypeId =: salesProduct AND Name LIKE:searchCode AND HWS_VersionItem__r.HWS_Hardware_Sellable_Item__c IN:sCLItmIds];  
		
		if(altVersionItemsLst.size()>0) {	
	for(HWS_AlternateProductCode__c pd : altVersionItemsLst){	
			versionCodeList.add(pd.HWS_VersionItem__r.HWS_Version_Code__c);
	}	
		}
		//stockableItems=HWS_Utilty.getVersionItems(sCLItmIds,sourceSystem);
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
			System.debug('searchString'+searchString);
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
		//Integer offset = UserInfo.getTimezone().getOffset(plannedDt);
		//Datetime userLocalPlannedDt = plannedDT.addSeconds(offset/1000);
		 //System.debug('userLocalPlannedDt *****'+userLocalPlannedDt);
		//List<DateTime> plannedDateTimeList = new List<DateTime>();
		//plannedDateTimeList.add(PlannedDt);
		//plannedDateTimeList.add(userLocalPlannedDt);
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
		//Map<String,Id> ChildCaseRecTypes = HWS_Utilty.ChildCaseRecordTypes();
										   
		try {	
			case parentCase1 = parentCase;
			Case parentCaseId;
			
			parentCase1.ContactId = contactid;
			parentCase1.AccountId = accountList[0].Id;  
			parentCase1.CH_CaseInitiationDate__c = caseInitiationTime;
			parentCase1.RecordTypeId=parentCaseRecordType;
			parentCase1.HWS_Delivery_TimeZone__c = String.valueOf(deliveryTimeZone);
			Database.SaveResult[] results = Database.insert(new SObject[] {parentCase1});
			system.debug('Caseeeeee'+parentCase1);			
			//parentCaseId = [select id, caseNumber from case where Id = :parentCase1.Id];		   
			//Added for single email
			parentCaseId = [select id, caseNumber,Hws_Ship_to_Party_Address__c,Hws_Ship_to_Party_Address__r.BillingStreet,Hws_Ship_to_Party_Address__r.BillingCity,Hws_Ship_to_Party_Address__r.BillingState,Hws_Ship_to_Party_Address__r.BillingPostalCode,Hws_Ship_to_Party_Address__r.BillingCountry from case where Id = :parentCase1.Id];
			for(Case caseRec : childCaseList){
				case childCase1 = caseRec;
				childCase1.ContactId = contactid;
				childCase1.AccountId = accountList[0].Id;
				childCase1.ParentId = parentCase1.Id; 
	childCase1.CH_Email2__c=parentCase1.CH_Email2__c;//27247
				childCase1.CH_Email3__c=parentCase1.CH_Email3__c;
	//Added for single email
	childCase1.Hws_Ship_to_Party_Address__c = parentCase1.Hws_Ship_to_Party_Address__c;
	childCase1.HWS_ShipmentRecipientEmailId__c = parentCase1.HWS_ShipmentRecipientEmailId__c;
	childCase1.HWS_Shipment_Recipient_Name__c = parentCase1.HWS_Shipment_Recipient_Name__c;
	//childCase1.Comment__c = parentCase1.HWS_Shipment_Recipient_Name__c+'\n'+parentCaseId.Hws_Ship_to_Party_Address__r.BillingStreet+',\n'+parentCaseId.Hws_Ship_to_Party_Address__r.BillingCity+',\n'+parentCaseId.Hws_Ship_to_Party_Address__r.BillingState+',\n'+parentCaseId.Hws_Ship_to_Party_Address__r.BillingPostalCode;
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
				System.debug('serviceType ' +serviceType);
				if(serviceType.containsIgnoreCase('days')){
					childCase1.RecordTypeId = exchangeInDays;	  
				}else if((serviceType.containsIgnoreCase('SPS'))||(serviceType.containsIgnoreCase('SALES'))){
					childCase1.RecordTypeId = sps;
				}else if((serviceType.containsIgnoreCase('RETURN FOR REPAIR')) ||(serviceType.containsIgnoreCase('Identical Repair'))){
					childCase1.RecordTypeId = rfr;
				}else{
					System.debug('I am in exchangein hours');
					childCase1.RecordTypeId = exchangeInHours;
				}
				//25689 --> Clear values which is added(Dummy values in Lightning Component)	
	childCase1.Street_Address_1__c = null;
	childCase1.Street_Address_2__c = null;
	childCase1.Street_Address_3__c = null;
	
				childCase.add(childCase1);
				
			}
			Database.SaveResult[] results1 = Database.insert(childCase);
			return parentCase1.id;
		}						  
		catch(DmlException e) {
			throw new AuraHandledException(String.valueOf(e.getMessage()));  
		}
	}
	
	@auraEnabled
	public static HWS_SendServiceRequesttoSOO_SVC.processResponse makeSOOCallout(Id parentCaseId){
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
		
		System.debug('**ISError **');
		HWS_SendServiceRequesttoSOO_SVC.processResponse pr= HWS_SendServiceRequesttoSOO_SVC.sendToSOO(parentCaseId);
		Case parentCase = new Case(id=parentCaseId);
		List<Case> childCases;
		List<Entitlement> entitlementLst = new List<Entitlement>();
		List<ContractLineItem> businessHoursLst = new List<ContractLineItem>();
		Set<Id> cliIdSet = new Set<Id>();
		Map<Id, Id> cliIdEntilmentIdMap = new Map<Id, Id>();
		List<Case> listNewCases = New List<Case>();
		System.debug('ISError '+pr.isError);
		
		if(!pr.isError){
			parentCase.HWS_Sent_To_SOO__c =true;
			parentCase.HWS_SOO_Reference_Number__c =pr.SOORequestID;
			parentCase.RecordTypeId = parentCaseReadOnlyRType;
			parentCase.HWS_Case_Ordered_Date__c=System.now();
			/* Added HWS_Case_Ordered_Date__c in the query for user story 2997*/
			childCases = [select Id, Status,HWS_Communication_Contact__c, RecordTypeId, HWS_ServiceType__c,HWS_Case_Ordered_Date__c,AssetId, HWS_FaultyUnitReceivedDate__c, HWS_Contract_Line_Item__c, HWS_Contract_Line_Item__r.CH_BusinessHour__c, HWS_StartMilestone__c from Case where ParentId =: parentCaseId AND Status!='Cancelled'];
			//childCases = [select Id, Status, RecordTypeId, HWS_ServiceType__c,AssetId, HWS_FaultyUnitReceivedDate__c, HWS_Contract_Line_Item__c from Case where ParentId =: parentCaseId];
			System.debug('makeSOOCallout:childCases: ' +childCases);
			if(!childCases.isEmpty()){
				for(Case childCase : childCases){
					cliIdSet.add(childCase.HWS_Contract_Line_Item__c);
					// cliBHSet.add(childCase.HWS_Contract_Line_Item__r.CH_BusinessHour__c);
				}
			}
			if(!cliIdSet.isEmpty()){
				entitlementLst = [SELECT Id, Name, AssetId, ContractLineItemId 
								  FROM Entitlement 
								  WHERE ContractLineItemId IN :cliIdSet
								  AND ContractLineItem.Status = 'Active']; 
				System.debug('makeSOOCallout:entitlementLst:' +entitlementLst);
			}
			
			if(!entitlementLst.isEmpty()){
				for(Entitlement ent : entitlementLst){
					cliIdEntilmentIdMap.put(ent.ContractLineItemId, ent.Id);
				}
			}
			
			if(childCases.size()!=0){
				for(Case childCase : childCases){
					childCase.status = 'Ordered';
		//Milestone CPU Time Limit Fix		
		serviceType = childCase.HWS_ServiceType__c;		
		if(childCases.size() <= 15){		
			childCase.HWS_StartMilestone__c = true;		
			runBatchForMilestone = false;		
		}
					/*
					if(parentCase.HWS_Communication_Contact__c!= null || parentCase.HWS_Communication_Contact__c!=''){
					system.debug('Child entered:'+ childCase.HWS_Communication_Contact__c);
					system.debug('parent entered:'+parentCase.HWS_Communication_Contact__c);
					childCase.HWS_Communication_Contact__c = parentCase.HWS_Communication_Contact__c;
					}
					*/
					if(childCase.RecordTypeId == childCaseAEDaysRecordType || childCase.RecordTypeId == childCaseAEHoursRecordType || childCase.RecordTypeId == childCaseReturnForRepairRecordType ){
						//start changes for user story 2997
						if(childCase.status == 'Ordered' && childcase.HWS_Case_Ordered_Date__c==null && (childCase.RecordTypeId == childCaseAEDaysRecordType || childCase.RecordTypeId == childCaseAEHoursRecordType || childCase.RecordTypeId == childCaseReturnForRepairRecordType )){
							childcase.HWS_Case_Ordered_Date__c=System.now();
						}
						//End changes for user story 2997
						childCase.RecordTypeId = childsCaseReadOnlyRType;
						childCase.EntitlementId = cliIdEntilmentIdMap.get(childCase.HWS_Contract_Line_Item__c);
						System.debug('makeSOOCallout:entitlementLst: inside for' +childCases);
					}
					if(childCase.RecordTypeId == spsCaseRecordType){
						if(childCase.status == 'Ordered' && childcase.HWS_Case_Ordered_Date__c==null){
							childcase.HWS_Case_Ordered_Date__c=System.now();
						}
					   childCase.RecordTypeId = spsReadOnlyCaseRecordType;
						childCase.EntitlementId = cliIdEntilmentIdMap.get(childCase.HWS_Contract_Line_Item__c);
						System.debug('makeSOOCallout:entitlementLst: inside for SPS' +childCases);
					}
					listNewCases.add(childCase);
					
				}
			}
		}
		else{
			parentCase.HWS_Is_Error__c  =true;
			
		}
		listNewCases.add(parentCase);
		if (listNewCases.size()>0){
			update listNewCases;
			//Milestone CPU Time Limit Fix		
			List<String> parentCaseList = new List<String>();		
			parentCaseList.add(parentCaseId);		
			if(runBatchForMilestone && (serviceType == 'Advanced Exchange in Days'|| serviceType =='Advanced Exchange in Hours' || serviceType =='Spare Part Sales')){		
	Id batchJobId = Database.executeBatch(new HWS_StartMilestoneCalculationBatch (parentCaseList), 50);		
			}		
		}
		System.debug('return value to caseFLow after submittoSOO' +pr);
		return pr;
	}
	
	@auraEnabled
	public static List<Case> ecsalateCase(String contactId,List<Account> accList, Case escCase){
		List<Case> caseList2 = new List<Case>();
		Id recId = esclationCase;
		Id accId;
		try{  
			
			case cas = escCase;
			//cas.Status = caseString.split(':')[0];
			//cas.HWS_On_Hold_Reason__c = caseString.split(':')[1];
			cas.Subject='Case Escalated to CAPM';
			cas.RecordTypeId= recId;
			//cas.Comments= null != caseString.split(':')[2] ? caseString.split(':')[2] : '';
			if (accList!=null){
				for(Account acc : accList){accId=acc.Id;}
				cas.AccountId= accId;
			}
			cas.ContactId= contactId;
			Database.SaveResult[] childResult = Database.insert(new SObject[] {cas});
			for(Case c1 : [Select id,casenumber from case where id = : cas.Id]){ caseList2.add(c1);}
			return caseList2;
		}catch(Exception e){
			//throw new AuraHandledException('Unable to Escalate Case due to an Internal Problem. Please try after some time.');
			System.debug('Error***'+e.getMessage() +'on line number ' +e.getLineNumber() + ' '+ e.getCause());
			return null;
		}
	}
	
	/*************************
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
	
	 /*************************
Method Name : getNEA
Description : created for NOKIASC-25662 as part of sprint-20
Created By  : Bharathi Nutakki
Created Date: 12/02/2020 (MM/DD/YYYY)
Modified By :
Modified Date:
******************************/
	@auraEnabled
	public static List<Asset> getNEA(Id accId, Id cliId,List<Id> cliIdList){		
		List<Asset> neaAssetList = HWS_Utilty.getNetworkElementAssets(accId,cliId,cliIdList);
		System.debug('NEAs:'+neaAssetList);
		return neaAssetList;
	}
	
	 @auraEnabled
	public static Boolean getPayPerUse(Id parentCaseId){
		boolean isValue=false;
		List<Case> parentCase=[select id,HWS_Customer_PO__c from case where Id =:parentCaseId LIMIT 1];
		List<Case> childCases;
		if(parentCase.Size()>0){
		if(parentCase[0].HWS_Customer_PO__c=='' || parentCase[0].HWS_Customer_PO__c== NULL){
			childCases = [select Id, HWS_Contract_Line_Item__r.CH_ServiceOffering__c from Case where ParentId =: parentCaseId AND Status!='Cancelled'];
			if(childCases.Size()>0){
			for(Case getChildCaseValues:childCases){
				string serviceItemDescription=getChildCaseValues.HWS_Contract_Line_Item__r.CH_ServiceOffering__c;
				System.debug('serviceItemDescription : '+serviceItemDescription);
				System.debug('Customer Purchase Order Number : '+parentCase[0].HWS_Customer_PO__c);
				if(serviceItemDescription!='' && serviceItemDescription!=NULL){
				   // if((serviceItemDescription.contains('RES RFR PU')||serviceItemDescription.contains('RES AED PU'))&& (parentCase[0].HWS_Customer_PO__c=='' || parentCase[0].HWS_Customer_PO__c== NULL)){
					 if(serviceItemDescription.contains('RES RFR PU')||serviceItemDescription.contains('RES AED PU')){
						isValue=true;
						break;
					}
				}
			}
			}
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
	@auraEnabled
	public static HWS_Utilty.plannedDeliveryDateWrapper accountTimeZoneplannedDeliveryDateTime(List<Case> listChildCases, Id selectedAccount ){
		Map<Id,String> HWS_UpdateTimeZone = HWS_Utilty.updateTimeZone(selectedAccount);
		HWS_Utilty.plannedDeliveryDateWrapper listCase = HWS_Utilty.accountTimeZoneplannedDeliveryDateTime(listChildCases, HWS_UpdateTimeZone.get(selectedAccount));
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
		Account acc = [select Id, HWS_TimeZone__c, Name, BillingCountry from Account where Id = :selectedAccount];
		if(acc != null && acc.HWS_TimeZone__c != null){		   
			timeZonemap.put(acc.Id, acc.HWS_TimeZone__c);
			stringTimeZonemap.put('Account', timeZonemap);
		}
		//If Account Timezone is null then query on BusinessHours
		else{
			List<BusinessHours> bhList = new List<BusinessHours>();
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
}