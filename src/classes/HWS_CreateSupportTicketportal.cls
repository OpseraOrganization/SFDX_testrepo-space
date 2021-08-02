public without sharing class HWS_CreateSupportTicketportal {
	
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
	
	//method to findout duplicate falty unit serial for each material code  
	@auraEnabled
	public static list<Case> duplicateSerialNumberInfo(string serialNumber, string materialCode){			   
		System.debug('serial Number and mt code ' +serialNumber +' ' +materialCode);
		List<Case> caselist = new List<Case>();
		try{
			caselist = [Select id,HWS_Faulty_Serial_Number__c,CaseNumber,Status From Case 
			where (status Not in:childCaseStatusesforDuplicte ) AND Asset.HWS_Part_Code__c =: materialCode 
			AND HWS_Faulty_Serial_Number__c =: serialNumber AND HWS_Faulty_Serial_Number__c !=null limit 1];
			System.debug('caselist'+caselist.size());
		} catch(queryException qe){
			System.debug('query exception qe ' +qe.getStackTraceString());
			throw new AuraHandledException(String.valueOf(qe.getMessage()));
		}	  
		return caselist ;
	} 
		
	@auraEnabled
	public static String getParentAccountId(string contactId)
	{ 
		Contact accs= [SELECT Id,AccountId FROM contact where Id = :contactId];	 
		return accs.AccountId;
	}
	
	@auraEnabled
	public static list<Account> getAllAccounts(string contactid)
	{  
		Id cussrentLoggedUserId = System.UserInfo.getUserId();	  
		User u = [SELECT Id, ContactId FROM User WHERE Id =: cussrentLoggedUserId];	 
		system.debug('ccccccccc'+u);
		if(u.ContactId != null){			
			contactId = u.ContactId;
		}
		Contact con= [SELECT Id,Contact_Status__c FROM contact where Id = :contactid];
		if(con.Contact_Status__c=='Active'){
			Id legalAccount = HWS_Utilty.getRecordTypeByName('ACCOUNT',HWS_Constants.Legal_Entity);
			list<EntitlementContact> accEntitlementContact= HWS_Utilty.getEntitlementContact(contactid, legalAccount);
			system.debug('===accEntitlementContact=='+accEntitlementContact);
			set<Id> accountIds = new set<Id>();
			for(EntitlementContact ac: accEntitlementContact){
				accountIds.add(ac.Entitlement.AccountId);
			}
			system.debug('===accountIds=='+accountIds);	   
			List<Account> lAccounts = HWS_Utilty.getAccounts(accountIds);
			system.debug('==74=lAccounts=='+lAccounts);		 
			return lAccounts;
		}
		else{		   
			return null;
		}
	}
	
	@auraEnabled
	public static List<hws_versionitem__c> getVersionItems(Asset selectedAsset,String searchValue){ 
	   
		List<String> versionCodeList = new List<String>();	  
		String searchCode=searchValue +'%';	 
		Id salesProduct = HWS_Utilty.getRecordTypeByName('Product2',HWS_Constants.SALES_PRODUCT);	   
		List<HWS_AlternateProductCode__c> altVersionItemsLst = [SELECT Id, HWS_VersionItem__r.HWS_Hardware_Sellable_Item__r.Id,HWS_VersionItem__r.HWS_Version_Code__c, Name, HWS_AlternateCodeType__c	   
		FROM HWS_AlternateProductCode__c		
		WHERE HWS_VersionItem__r.HWS_Hardware_Sellable_Item__r.RecordTypeId =: salesProduct	 
		AND Name LIKE:searchCode AND HWS_VersionItem__r.HWS_Hardware_Sellable_Item__c =:selectedAsset.Product2Id];	  
		if(altVersionItemsLst.size()>0) {	   
			for(HWS_AlternateProductCode__c pd : altVersionItemsLst){	   
	versionCodeList.add(pd.HWS_VersionItem__r.HWS_Version_Code__c);
			}	   
		}
		List<hws_versionitem__c> stockableItems = new List<hws_versionitem__c>();	   //stockableItems=gethwsVersionItems(selectedAsset.Product2Id,selectedAsset.HWS_SourceSystem__c);
		stockableItems=gethwsVersionItems(selectedAsset.Product2Id,selectedAsset.HWS_SourceSystem__c,versionCodeList);	 
		return stockableItems;
	}
	
	/****************************************
	* Name : gethwsVersionItems
	* Description : This returns the Version Items based on the selected Products
	* Parameters: Selected Product Ids, Search Value 
	* Returns : List of Version Items
	*****************************************/
	public static List<hws_versionitem__c> gethwsVersionItems(Id sCLItmIds,String sourceSystem,List<String> versCodeList){	  
		list<hws_versionitem__c> listContractLineItems= new List<hws_versionitem__c>();
		String strQuery= 'SELECT id,Material_Code__c,CLEI__c,Comcode__c,Name,HWS_Product_Name__c,HWS_Version_Code__c,HWS_Hardware_Sellable_Item__c,HWS_Part_Code_Part_Revision__c, HWS_Serial_Number_Traceable__c FROM hws_versionitem__c '+
							'WHERE HWS_Hardware_Sellable_Item__c =: sCLItmIds AND HWS_Source__c =:sourceSystem';
		if(versCodeList.size()>0){
			strQuery = strQuery+' AND HWS_Version_Code__c IN: versCodeList';			
		}
		strQuery = strQuery+' ORDER BY HWS_Version_Code__c';
		listContractLineItems = database.query(strQuery);
		return listContractLineItems;
	}
	
	@auraEnabled
	public static String getContactName(string contactid)
	{  
		System.debug('Contact Id'+contactid);
		Contact con= [SELECT Id,Name FROM contact where Id = :contactid];
		
		return con.Name;

	}
	
	@auraEnabled
	public static String getContactType(string contactid)
	{ 
		Contact con= [SELECT Id,CH_ContactType__c,Contact_Status__c FROM contact where Id = :contactid];
		
		return con.CH_ContactType__c;
		
	}
	
	@auraEnabled
	public static List<hws_versionitem__c> getVersions(list<Asset> listServiceServiceCon){	 
		//String searchCode=searchValue +'%';
		String sourceSystem;
		Set<Id> sCLItmIds = new Set<Id>();
		List<hws_versionitem__c> stockableItems = new List<hws_versionitem__c>();
		for(Asset cl : listServiceServiceCon){
			sCLItmIds.add(cl.Product2Id);
			sourceSystem = cl.HWS_SourceSystem__c;
		}
		System.debug('Source System 1 ###### '+sourceSystem);
		//stockableItems=HWS_Utilty.getVersionItems(sCLItmIds,sourceSystem);
	  
		return stockableItems;
	}
	
	//Method to get the Service Contracts when search type is selected as Contract Number
	//3697
	@AuraEnabled 
	public Static Map<String, List<ContractLineItem>> getServiceContracts(String selectedAccount,String	  searchString,String serviceType,String selectedcontractNumber, Id contactId ){
		Map<String, List<ContractLineItem>> mapContractLine = new Map<String, List<ContractLineItem>>();
		String contractNumber = searchString+'%';
		List<ContractLineItem> serviceContracts = new List<ContractLineItem>();
		/*Set<ID> accIds = new Set<ID>();
		for(Account acc:selectedAccounts){
		accIds.add(acc.Id);
		}*/
		System.debug('contractNumber '+contractNumber+' selectedAccount '+selectedAccount+' serviceType '+serviceType+' selectedcontractNumber:'+selectedcontractNumber);
		//3697
		serviceContracts = HWS_Utilty.getserviceContractsPortal(contractNumber,selectedAccount,serviceType,selectedcontractNumber, contactId);
		if(selectedcontractNumber != null && !selectedcontractNumber.containsIgnoreCase(searchString)){
			mapContractLine.put('Error Message3',serviceContracts);
		}
		else if(serviceContracts.size()>0){
			mapContractLine.put('No Error',serviceContracts);
		}else{
			List<ContractLineItem> serviceContractsInactive = HWS_Utilty.getserviceContractsInactivePortal(contractNumber, selectedAccount,serviceType);
			if(serviceContractsInactive.size()>0){
				mapContractLine.put('Error Message1',serviceContracts); 
			}else{
				mapContractLine.put('Error Message2',serviceContracts);
			}
		}
	   
		return mapContractLine;
	}
	
	//Method to get the Contract line Items for the selected Service Contracts when search type is selected as Contract Number
	@AuraEnabled
	public Static List<Asset> getCLIOfServiceContracts(String selectedServiceContracts){
		System.debug('selectedServiceContracts '+selectedServiceContracts);
		List<Asset> serviceCLIs = new List<Asset>();
		Set<Id> servIDs = new Set<ID>();
		servIDs.add(selectedServiceContracts);
		serviceCLIs = HWS_Utilty.getServiceTypes(servIDs);
	   
		return serviceCLIs;
	} 
	
	@auraEnabled
	public static DateTime plannedDeliveryDateTime(Id businessHrsId, String leadTimeUnit, String leadTimeDuration ,Date byPassPlannedDate,String specifiedTime){	   
		DateTime plannedDt = HWS_Utilty.plannedDeliveryDateTime(businessHrsId,leadTimeUnit,leadTimeDuration,byPassPlannedDate,specifiedTime);
	   
		return plannedDt;
	}
	
	@auraEnabled
	public Static List<String> getPickListValues1(String obj, String str)
	{
		List<String> options= HWS_Lookup_Class.getPickListValues(obj, str);
		
		return options;
	}   
	
	@auraEnabled
	public static String createHWSCasePortal(Id accountId,String shipAccId,list<Asset> contractLines,
											 List<hws_versionitem__c> versionItems,
											 List<Case> childCaseList, Case parentCase,
											 String contactid, Boolean submitToSOO, String contactTimeZone)
		
	{	  
		System.debug('accountId '+accountId+
					 ' contractLines '+contractLines+' versionItems '+versionItems+
					 ' childCaseList '+childCaseList+' parentCase '+parentCase
					 +' contactid '+contactid+' submitToSOO '+submitToSOO);
		system.debug('-----shipAccId-----'+shipAccId);
		List<string> lststr = new List<string>();
		lststr.add(shipAccId);
		if(lststr.size()>0){
			Boolean b = HWS_Utilty.accountToShare(lststr); // To share ship to party account with portal user
		}
		List<Case> childCase = new List<Case>();		
		Id sps = sPSCaseRType;	  
		//Map<String,Id> ChildCaseRecTypes = HWS_Utilty.ChildCaseRecordTypes();
											 
		try {
			case parentCase1 = parentCase;
			Case parentCaseId;
			parentCase1.ContactId = contactid;
			//parentCase1.HWS_Delivery_TimeZone__c = contactTimeZone;
			parentCase1.AccountId = accountId;  
		   parentCase1.RecordTypeId=parentCaseRecordType;
			Database.SaveResult[] results = Database.insert(new SObject[] {parentCase1});
			//parentCaseId = [select id, caseNumber from case where Id = :parentCase1.Id];
			//Added for single email
			parentCaseId = [Select id,caseNumber,Hws_Ship_to_Party_Address__c,Hws_Ship_to_Party_Address__r.BillingStreet,Hws_Ship_to_Party_Address__r.BillingCity,Hws_Ship_to_Party_Address__r.BillingState,Hws_Ship_to_Party_Address__r.BillingPostalCode,Hws_Ship_to_Party_Address__r.BillingCountry from case where Id = :parentCase1.Id];
	  if (parentCaseId !=NULL)
	  {
			for(Case caseRec : childCaseList){
				case childCase1 = caseRec;
				childCase1.ContactId = contactid;
				childCase1.AccountId = accountId;
	//childCase1.HWS_Delivery_TimeZone__c = contactTimeZone;
				childCase1.ParentId = parentCase1.Id;
	childCase1.CH_Email2__c=parentCase1.CH_Email2__c;//NokiaSc-27247
				childCase1.CH_Email3__c=parentCase1.CH_Email3__c;//NokiaSc-27247
				// Added for the Parent Case ID
				system.debug('numbeeeeeee'+parentCaseId.CaseNumber);
	// Added for single email
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
				childCase1.HWS_Parent_Case_Number__c = parentCaseId.CaseNumber;
				//Assigning ContractLine Item value by using subject, as portal user doesnot have access for Contract line items. Subject field will be populated with RMA number again while inserting.		
				childCase1.HWS_Contract_Line_Item__c = childCase1.Subject;
				childCase1.Subject = null;

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
	//26101--> Clear values which is added(Dummy values in Lightning Component)
	childCase1.Street_Address_1__c = null;
	childCase1.Street_Address_2__c = null;
	childCase1.Street_Address_3__c = null;
	
				childCase.add(childCase1);
			}
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
					if(childCase.RecordTypeId == childCaseAEDaysRecordType || childCase.RecordTypeId == childCaseAEHoursRecordType || childCase.RecordTypeId == childCaseReturnForRepairRecordType ){
						//start changes for user story 2997
						if(childCase.status == 'Ordered' && childcase.HWS_Case_Ordered_Date__c==null){
							childcase.HWS_Case_Ordered_Date__c=System.now();
						}
						//End changes for user story 2997
						childCase.RecordTypeId = childsCaseReadOnlyRType;
						childCase.EntitlementId = cliIdEntilmentIdMap.get(childCase.HWS_Contract_Line_Item__c);
						System.debug('makeSOOCallout:entitlementLst: inside for' +childCases);
					}
					if(childCase.RecordTypeId == spsCaseRecordType){
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
	public static List<Case> ecsalateCase(String caseString,List<Account> accList){	
		List<Case> caseList2 = new List<Case>();
		Id recId = esclationCase;
		Id accId;
		try{  
			
			case cas = new Case();
			cas.Status = caseString.split(':')[0];
			cas.HWS_On_Hold_Reason__c = caseString.split(':')[1];
			cas.Subject='Case Escalated to CAPM';
			cas.RecordTypeId= recId;
			cas.Comments= null != caseString.split(':')[2] ? caseString.split(':')[2] : '';
			if (accList!=null){
				for(Account acc : accList){accId=acc.Id;}
				cas.AccountId= accId;
			}
			cas.ContactId= caseString.split(':')[3];
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
	Method Name : getContactDetails
	Description : This method is getting invoked from "HWS_CaseFlow_Portal" component 
	created for HWST-xxxx as part of sprint-1917
	Created By  : Satya
	Created Date: 04/29/2019 (MM/DD/YYYY)
	Modified By :
	Modified Date:
	******************************/
	@auraEnabled
	public static List<User> getContactDetails(){
		Id cussrentLoggedUserId = System.UserInfo.getUserId();
		//Id contactId = '0035600000J7Zkq';
		Id contactId;
		List<User> u = [SELECT Id, ContactId, Contact.Name,Contact.AccountId, Contact.Email1__c, Contact.CH_Email3__c,Contact.CH_ContactTimeZone__c FROM User WHERE Id =: cussrentLoggedUserId];		
		system.debug('ccccccccc'+u);
		/*if(u.ContactId != null){		  
		contactId = u.ContactId;
		}*/
	   
		return u;
	}
	
	/*************************
	Method Name : 
	Description : This method is getting invoked from "HWS_CaseFlowAssetSectionPortal" component 
	to get the Asset details
	Created By  : Bharathi
	Created Date: 
	Modified By :
	Modified Date: 
	******************************/
	//3697
	@auraEnabled
	public static Map<String, List<Asset>> getContractlineItems(String accountId,String searchValue,String serviceType, String contractNumber, Id contactId, String country){	  
		String searchCode = searchValue +'%';
		String itemDesc = '%'+searchValue +'%';
		List<Asset> lCli = new List<Asset>();
		Map<String, List<Asset>> mapContractLine = new Map<String, List<Asset>>();  
		System.debug('search Code####'+searchValue);
		Id salesProduct = HWS_Utilty.getRecordTypeByName('Product2',HWS_Constants.SALES_PRODUCT);
		
		List<HWS_AlternateProductCode__c> altVersionItemsLst = [SELECT Id, HWS_VersionItem__r.HWS_Hardware_Sellable_Item__r.Id, Name, HWS_AlternateCodeType__c
																FROM HWS_AlternateProductCode__c 
																WHERE HWS_VersionItem__r.HWS_Hardware_Sellable_Item__r.RecordTypeId =: salesProduct 
																AND Name LIKE:searchCode ];  
		
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
		if(!(prodIds.isEmpty() && (AccountId == null || AccountId == ''))){ 
			List<Asset> accRelatedAssetProduct = [SELECT Id, ProductCode, Product2Id, Product2.Name
												  FROM Asset 
												  WHERE (AccountId=:AccountId AND Product2Id =:prodIds)];
			
			if(accRelatedAssetProduct.size()<=0)
			{
				mapContractLine.put('Error Message3',lCli);  
				System.debug('errormessage 3 ###'+accRelatedAssetProduct.size());
			}	   
			else {			
				//3697 - passing contactId
				lCli = HWS_Utilty.getAllServiceTypesPortal(prodIds, AccountId,serviceType,contractNumber,contactId , country);
				
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
			List<Account> listAccounts = new List<Account>{new Account(Id = AccountId)};		
				lCli = HWS_Utilty.getContractlineItemsPartCodeRevision(listAccounts, searchValue, serviceType, contractNumber, contactId, 'Portal', country);	  
			if(lCli.size()>0){	
				mapContractLine.put('No Error',lCli);	  
			}	  
		}
		return mapContractLine;
	}
	
	@auraEnabled
	public static Id getRecordType(string serviceType){
		System.debug('service type **** '+serviceType);
		Id recTypeId = HWS_Utilty.Childrecordtypes(serviceType);
		
		return recTypeId;
	}
	
	@AuraEnabled
	public static String getUIThemeDescription() {	
		String theme = UserInfo.getUiThemeDisplayed();
		
		return theme;
	}
	
	@auraEnabled
	public static String getCasStatus(string caseid)
	{		  
		//System.debug('Contact Id'+contactid);
		Case caseStat= [SELECT Id,Status,(select id,status from cases where status = 'Draft') FROM case where Id = :caseid];
		if(casestat.cases.size()>0){		   
			return caseStat.Status;
		}
	   
		return null;
		
	}
	
	/*************************
	Method Name : 
	Description : This method is getting invoked from "HWS_ChildCaseBulkUplad" component 
	to insert child cases 
	Created By  : Vinod
	Created Date: 13-06-2019
	Modified By :
	Modified Date: 
	******************************/
	@AuraEnabled
	public static Map<Boolean, List<Id>> processData(String fileData,String sobjectName,List<String> fields,String selectedAccount, String selectedServiceType) {
		Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sobjectName);
		Map<Boolean, List<Id>> bulkUploadMap = new Map<Boolean, List<Id>>();
		List<Id> bulkUploadId = new List<Id>();
		Database.SaveResult[] srList;
		try{
			if(fileData!=null){ 
				String[] fileLines = new String[]{};
				//to get the number of rows inculding Hearders
				fileLines = fileData.split('\n');
				List<sObject> myList = new List<sObject>();
				//to get the number of rows to remove header we are using i=1
				for(Integer i=1,j=fileLines.size();i<j;i++){
					String[] inputvalues = new String[]{};
					//get Number of columns for each row
					if(fileLines[i].contains(';')){
						inputvalues = fileLines[i].split(';'); 
					}
					else{					   
						inputvalues =fileLines[i].split(',(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)');
					}
					sObject obj = targetType.newSObject();
					// rowsize Containes each column in arow 
					integer rowsize=inputvalues.size();
					integer da = 0;
					if(String.isNotBlank(inputvalues[0])){
						for(integer l=0;l<=rowsize-1;l++){
							if(da == 0)
							da = rowsize;
							da = da-1;
							if(String.isNotBlank(inputvalues[l]))
							{
								if(da == 6 ){
									
									
									string[] st = inputvalues[l].split('/');
									system.debug('-----st---'+st[2]+st[1]+st[0]);
									Integer year = Integer.valueOf(st[2].trim());
									Integer month = Integer.valueOf(st[0].trim());
									Integer day = Integer.valueOf(st[1].trim());

									date dt =  date.newinstance(year, month, day);
									
									//Date dt = Date.ValueOf(todate);
									
									obj.put(fields.get(l),dt);
								}
								else{
									obj.put(fields.get(l),inputvalues[l].replace('�', '').replace('"', ''));
								}
							}
							else{
								if(da == 6 ){
									obj.put(fields.get(l),null);					
								}
								else{
									obj.put(fields.get(l),'');
								}
							}
				obj.put('HWS_AccountId__c',selectedAccount);		
				obj.put('HWS_ServiceType__c',selectedServiceType);
						}
						myList.add(obj);
					}
		}
				srList = Database.insert(myList, false);
		// Iterate through each returned result
				for (Database.SaveResult sr : srList) {
					if (sr.isSuccess()) {
					  bulkUploadId.add(sr.getId());
					}
					else {
					   for(Database.Error err : sr.getErrors()) {
						   System.debug(err.getStatusCode() + ': ' + err.getMessage());
						}
					}
				}
			}
			if(srList.size()>0){
				if(bulkUploadId.size()>0){
				  bulkUploadMap.put(true, bulkUploadId);
				}
				else{
					bulkUploadMap.put(false, bulkUploadId);
				}
				return bulkUploadMap;
			}
			else{
				bulkUploadMap.put(false, bulkUploadId);
			}
		}
		catch(Exception e){
			System.debug('Errorrrrrr'+e);
			bulkUploadMap.put(false, bulkUploadId);
			
			return bulkUploadMap;
		}
	  
		return bulkUploadMap;
	}
	
	@AuraEnabled
	public static List<HWS_BulkUpload__c> setTableData(List<Id> rmaIds){	   
		Boolean isStatusSuccess = true;
		List<HWS_BulkUpload__c> buList = new List<HWS_BulkUpload__c>();
		List<HWS_BulkUpload__c> savedBuList = [Select id,HWS_Asset__r.HWS_ContractLineItem__r.Id, Part_Code_Part_Revision__c,HWS_Part_Code__c, HWS_Part_Revision__c,HWS_Sellable_Product__c,HWS_Product_Name__c,NCP_Service_Contract__c,HWS_Asset__c,Faulty_Serial_number__c,Fault_Detection__c,Fault_Description__c,
										  SLA_Unit__c,SLA_Value__c,SSI_Description__c,Comments__c,HWS_Asset__r.HWS_ContractLineItem__r.CH_BusinessHour__r.Id,HWS_Asset__r.HWS_ContractLeadTimeUnit__c,HWS_Asset__r.HWS_ContractLeadTimeDuration__c,HWS_Service_Contract_Number__c,Fault_Occurrence__c,HWS_Asset__r.HWS_SpecifiedDeliveryTargetTime__c,Fault_detection_Date__c,Failure_Description_Server_ID__c,Customer_Reference_Number__c,
										  Fault_Reported_by_Name__c,Status__c, Fault_Reported_by_Phone__c,Fault_Reported_by_Email__c,Site_Id__c,Validation_Message__c,HWS_Ship_to_Address__c,HWS_Ship_to_Address__r.Name,HWS_Asset__r.HWS_ContractLineItem__r.ServiceContract.CH_ERPSystem__c, HWS_Bulk_Version_Item__c
			,HWS_NEACount__c,HWS_NetworkElementAsset__c,HWS_NetworkElementAssetName__c from HWS_BulkUpload__c where id in:rmaIds Order by Status__c Asc NULLS LAST]; 
	   
	if(savedBuList.size()>0){
	  for(HWS_BulkUpload__c bu :savedBuList){
		if(bu.Status__c != 'Success'){
		  isStatusSuccess = false;
		}
	  }
	  
	  if(!isStatusSuccess){
		buList = savedBuList;
	  } 
	  else{
		buList = [Select id,HWS_Asset__r.HWS_ContractLineItem__r.Id, Part_Code_Part_Revision__c,HWS_Part_Code__c, HWS_Part_Revision__c,HWS_Sellable_Product__c,HWS_Product_Name__c,NCP_Service_Contract__c,HWS_Asset__c,Faulty_Serial_number__c,Fault_Detection__c,Fault_Description__c,
						SLA_Unit__c,SLA_Value__c,SSI_Description__c,Comments__c,HWS_Asset__r.HWS_ContractLineItem__r.CH_BusinessHour__r.Id,HWS_Asset__r.HWS_ContractLeadTimeUnit__c,HWS_Asset__r.HWS_ContractLeadTimeDuration__c,HWS_Asset__r.HWS_SpecifiedDeliveryTargetTime__c,HWS_Service_Contract_Number__c,Fault_Occurrence__c,Fault_detection_Date__c,Failure_Description_Server_ID__c,Customer_Reference_Number__c,
						Fault_Reported_by_Name__c,Status__c, Fault_Reported_by_Phone__c,Fault_Reported_by_Email__c,Site_Id__c,Validation_Message__c,HWS_Ship_to_Address__c,HWS_Ship_to_Address__r.Name,HWS_Asset__r.HWS_ContractLineItem__r.ServiceContract.CH_ERPSystem__c, HWS_Bulk_Version_Item__c
			,HWS_NEACount__c,HWS_NetworkElementAsset__c,HWS_NetworkElementAssetName__c from HWS_BulkUpload__c where id in:rmaIds Order by HWS_Service_Contract_Number__c Asc];			 
	  }
	}	  
			return buList;
	}  
	
  public static Map<String,List<Asset>> getContractNumbers(List<String> partCodes, Id accId,String serviceType,Id contactId){
		Map<String,List<Asset>> mapAssets = new Map<String,List<Asset>>();
		String expired = 'Expired';
		String inactive = 'Inactive';
		String externalStatus = 'Active';
		String classification='HWS Service';
		Boolean sync = true;
		Boolean enableForPortal = true;
		//2503 SPS Last Order Date validation started added HWS_Product_SPSLOD__c field
		String assetQuery = 'SELECT Id,HWS_SourceSystem__c,HWS_Product_SPSLOD__c,HWS_Service_Contract_Number__c,HWS_Currency__c,HWS_Price__c,Contract_Number__c,HWS_ContractLineItem__c,HWS_ContractLineItem__r.ServiceContract.HWS_Currency__c, HWS_ContractLineItem__r.CH_LineItemEntitlementScript__c,HWS_ContractLineItem__r.ServiceContract.CH_EntitlementScript__c,HWS_ContractLineItem__r.ServiceContract.CH_CountryCode__c,HWS_ContractLineItem__r.ServiceContract.CH_CountryName__c,HWS_ContractLineItem__r.ServiceContractId,HWS_ContractLineItem__r.HWS_AdditionalSIInfo1__c,HWS_ContractLeadTimeUnit__c,AccountId,HWS_ContractLeadTimeDuration__c,Product2Id,Product2.Name,ProductCode,'+
			'HWS_ServiceItemCode__c,HWS_ContractLineItem__r.ServiceContract.CH_ERPSystem__c, HWS_Part_Code__c,HWS_Service_Type__c,HWS_Product_Name__c, HWS_ContractLineItem__r.CH_BusinessHour__r.Id,HWS_ServiceItemDescription__c,HWS_High_Level_Product_Name__c,HWS_ContractLineItem__r.CH_CoverageGroup__c,HWS_ContractLineItem__r.CH_QtyCoveredNetworkElementAssets__c FROM Asset WHERE HWS_Part_Code__c In: partCodes AND AccountId =: accId AND (HWS_ContractLineItem__r.ServiceContract.NCP_External_Status__c =: externalStatus) AND HWS_ContractLineItem__r.CH_ServiceClassification__c=: classification AND HWS_ContractLineItem__r.NCP_External_Status__c=: externalStatus AND HWS_ExternalStatus__c=: externalStatus AND HWS_IsSynced__c =:sync AND HWS_ContractLineItem__r.ServiceContract.CH_PortalCaseCreationHWS__c =: enableForPortal';
		//getting only Authorized serviceContract Records
		//3697 - passing contactId  ****************Start*********
		Map<Id, Set<String>> servContrMap = new Map<Id, Set<String>>();
		if(contactId!=null){
			List<EntitlementContact> servContList = [select id, Entitlement.Name, Entitlement.ServiceContract.Name, Entitlement.ServiceContract.Id, Entitlement.ServiceContract.ContractNumber, Entitlement.Account.Name, Entitlement.AccountId, contact.Name, ContactId from EntitlementContact where ContactId = :contactId];
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
		}
		Set<String> contrSet = new Set<String>();
		if(servContrMap.size()>0){
			if(servContrMap.Containskey(accId)){
				contrSet = servContrMap.get(accId);
			}
		}
		if(contrSet.size()>0){
			assetQuery = assetQuery+' AND Contract_Number__c IN: contrSet';
		}
		//******************************End*********
		if(serviceType != null && serviceType !=''){
			assetQuery = assetQuery+' AND HWS_Service_Type__c=: serviceType';
		}
		System.debug('assetQuery'+assetQuery);
		list<Asset> listAssets = database.query(assetQuery);
		System.debug('listAssets**'+listAssets);
		for(Asset assetRec: listAssets) {
			if(mapAssets.containsKey(assetRec.HWS_Part_Code__c)) {
				mapAssets.get(assetRec.HWS_Part_Code__c).add(assetRec); 
			}   
			else {
				mapAssets.put(assetRec.HWS_Part_Code__c, new List<Asset> {assetRec});
			}
		}
		System.debug('mapAssets'+mapAssets);
	   
		return mapAssets;
		
	}
	
	//public static Set<Id> shipToAddrDupCheckSet = new Set<Id>();
	@auraEnabled
	public static List<HWS_BulkUpload__c> validateFaulty(List<SObject> recordID,Id accountID,string serviceType,Id contactId,Id shipToAddrUpdated){
		List<HWS_BulkUpload__c> buList = [Select id,Part_Code_Part_Revision__c,Faulty_Serial_number__c,Fault_Detection__c,Fault_Description__c,Hws_PartCode_PartRevision__c,
										  Fault_Occurrence__c,Fault_detection_Date__c,Failure_Description_Server_ID__c,Customer_Reference_Number__c,
										  Fault_Reported_by_Name__c,Fault_Reported_by_Phone__c,Fault_Reported_by_Email__c,Site_Id__c,HWS_Part_Code__c,
										  HWS_Part_Revision__c,Validation_Message__c,HWS_Service_Contract_Number__c,status__c,HWS_ServiceType__c,HWS_Ship_to_Address__c,HWS_Asset__r.HWS_ContractLineItem__r.CH_CoverageGroup__c,Comments__c, HWS_Bulk_Version_Item__c
			,HWS_NEACount__c,HWS_NetworkElementAsset__c,HWS_NetworkElementAssetName__c from HWS_BulkUpload__c where id in:recordID];
		system.debug('buList Values are'+buList);
		system.debug('buList Values are'+buList.size());
		System.debug('accId:'+accountID+'serviceType:'+serviceType+'-contactId:'+contactId); 
		List<String> pcprSet = new List<String>();
		List<String> pcprSetRevision = new List<String>();
		List<String> pcprSetRevision1=new List<String>();
		List<Id> loopId = new List<Id>();
		 List<Id> loopIdValues = new List<Id>();
		List<String> lstPartCode = new List<String>();
		List<String> lstFaultySerialNumber = new List<String>();
		List<String> lstSetRevision = new List<String>();
		Map<String,String> partCodeCmp=new Map<String,String>();
		Map<String,Id> contractShiptoAddrMap = new Map<String,Id>(); 
		Map<Id,String> bulkIdContractNumMap = new Map<Id,String>();
		Boolean phoneValidation;
		Boolean phoneValidationFailureCheck = true; 
		List<HWS_BulkUpload__c> bulkListRecs = new List<HWS_BulkUpload__c>();
		List<HWS_BulkUpload__c> bulkListRecscontract = new List<HWS_BulkUpload__c>();
		List<String> partCodes = new List<String>();
		List<Id> shipToAddrDupCheckList = new List<Id>();
		Map<Id,String> noContrNumberMap = new Map<Id,String>();
		shipToAddrDupCheckList.add(shipToAddrUpdated);
		if(!buList.isEmpty() && buList.size()>0){
			try{
				for(HWS_BulkUpload__c bu : buList){
					if((bu.HWS_Part_Code__c != '' && bu.HWS_Part_Code__c != null) && (bu.HWS_Service_Contract_Number__c =='' || bu.HWS_Service_Contract_Number__c == null)){
					  partCodes.add(bu.HWS_Part_Code__c);
					}
				}
				if(partCodes.size()>0){
					System.debug('partCodes'+partCodes);
					Map<String,List<Asset>> mapPartCodeAssets= getContractNumbers(partCodes,accountID,serviceType,contactId);
					for(HWS_BulkUpload__c bulkUploadRec : buList){
						if(mapPartCodeAssets.containsKey(bulkUploadRec.HWS_Part_Code__c) && mapPartCodeAssets.get(bulkUploadRec.HWS_Part_Code__c).size() == 1){
							Asset assetRec = mapPartCodeAssets.get(bulkUploadRec.HWS_Part_Code__c)[0];
							bulkUploadRec.NCP_Service_Contract__c = assetRec.HWS_ContractLineItem__r.ServiceContractId;
							bulkUploadRec.HWS_Sellable_Product__c = assetRec.Product2Id;
				bulkUploadRec.HWS_Product_Name__c = assetRec.Product2.Name;
							bulkUploadRec.HWS_Contract_Line_Item__c = assetRec.HWS_ContractLineItem__c; 
							bulkUploadRec.HWS_Asset__c = assetRec.Id;			   
							bulkUploadRec.SLA_Unit__c = assetRec.HWS_ContractLeadTimeUnit__c;
							bulkUploadRec.SLA_Value__c = assetRec.HWS_ContractLeadTimeDuration__c;
							bulkUploadRec.SSI_Description__c = assetRec.HWS_ServiceItemDescription__c;
							bulkUploadRec.HWS_Service_Contract_Number__c = assetRec.HWS_Service_Contract_Number__c;
							bulkUploadRec.HWS_ServiceType__c=assetRec.HWS_Service_Type__c;
							bulkUploadRec.Comments__c = assetRec.HWS_ContractLineItem__r.CH_CoverageGroup__c;
		//Start Changes for 25679
							Decimal getNEACount=assetRec.HWS_ContractLineItem__r.CH_QtyCoveredNetworkElementAssets__c!=Null?assetRec.HWS_ContractLineItem__r.CH_QtyCoveredNetworkElementAssets__c:null;
							bulkUploadRec.HWS_NEACount__c=getNEACount;
							if(getNEACount!= null && getNEACount ==1 && assetRec.HWS_Service_Contract_Number__c!=''){
							   List<Asset> getNEAAssetRec =   getNetworkElementAsset(assetRec.HWS_ContractLineItem__r.Id,true);
								if(getNEAAssetRec.size()>0){
									bulkUploadRec.HWS_NetworkElementAsset__c=getNEAAssetRec[0].Id;
									bulkUploadRec.HWS_NetworkElementAssetName__c=getNEAAssetRec[0].Name;
							   }
							}
							//End Changes for 25679
						}
						else if(mapPartCodeAssets.containsKey(bulkUploadRec.HWS_Part_Code__c)){
							System.debug('Contracts available');							
						}
						else if((!mapPartCodeAssets.containsKey(bulkUploadRec.HWS_Part_Code__c)) ||
							   (mapPartCodeAssets.containsKey(bulkUploadRec.HWS_Part_Code__c) && !(mapPartCodeAssets.size() > 1))){
							noContrNumberMap.put(bulkUploadRec.Id,'No Contract Available ');
						}
					}
					update buList; 
				}
				System.debug('bulist size 740:'+buList.size()); 
				for(HWS_BulkUpload__c bu : buList){
					bulkIdContractNumMap.put(bu.Id,bu.HWS_Service_Contract_Number__c);				  
					if(bu.HWS_Ship_to_Address__c != null && (!shipToAddrDupCheckList.contains(contractShiptoAddrMap.get(bu.HWS_Service_Contract_Number__c)) || shipToAddrUpdated == null)){					 
						contractShiptoAddrMap.put(bu.HWS_Service_Contract_Number__c,bu.HWS_Ship_to_Address__c);					 
					}		   
				}
				for(HWS_BulkUpload__c bu : buList){
					System.debug('bulist in 748:'+buList);
					 System.debug('bulist in 749:'+ phoneValidationFailureCheck);
					  phoneValidation = false;
					phoneValidationFailureCheck = true;
					bu.Validation_Message__c='';
					if(bu.Fault_Reported_by_Phone__c != '' && bu.Fault_Reported_by_Phone__c != null && bu.Fault_Reported_by_Phone__c.length() <= 40 ){
						bu.Validation_Message__c='';
						String phone;
						phone=string.valueOf(bu.Fault_Reported_by_Phone__c);
						String phoneRegex='^([0-9\\(\\)\\/\\+ \\.]*)$';
						phoneValidation =Pattern.compile(phoneRegex).matcher(phone).matches();
						if(phoneValidation == false){
							bu.Validation_Message__c='Phone format that you have entered is incorrect.';
							bu.Status__c = 'Failed';
							phoneValidationFailureCheck = false;
						} else if(phoneValidation == true){
							bu.Validation_Message__c='';
							phoneValidationFailureCheck = true;
							//bu.Status__c = 'Success';  
						} 
					} 

					System.debug('bulist in 767:'+buList);
					 if(bu.HWS_Part_Code__c == '' || bu.HWS_Part_Code__c == null && phoneValidationFailureCheck == true){
						bu.Validation_Message__c='The part code you have entered is not found. ';
						bu.Status__c = 'Failed';
					} 
					else if((bu.HWS_Part_Code__c != '' && bu.HWS_Part_Code__c != null) && (noContrNumberMap.containsKey(bu.Id)) && (bu.HWS_Service_Contract_Number__c =='' || bu.HWS_Service_Contract_Number__c == null) && phoneValidationFailureCheck == true){					   
						bu.Validation_Message__c= 'No contract exists for the specified part code.';
						bu.Status__c = 'Failed';
					}
					 else  if(bu.HWS_Service_Contract_Number__c =='' || bu.HWS_Service_Contract_Number__c == null && phoneValidationFailureCheck == true)
					{  
						bu.Validation_Message__c='Please select Contract Number .';
						bu.Status__c = 'Failed';
					}
					else  if(bu.HWS_ServiceType__c !='' && bu.HWS_ServiceType__c != null && bu.HWS_ServiceType__c != serviceType && (bu.HWS_Service_Contract_Number__c !='' && bu.HWS_Service_Contract_Number__c != null) && phoneValidationFailureCheck == true)
					{  
						system.debug('717: '+serviceType);
						bu.Validation_Message__c='The part code you have entered is not covered under the service type you have selected .';
						bu.Status__c = 'Failed';
					}
		//Start Changes for 25679
					else  if((bu.HWS_NetworkElementAssetName__c =='' || bu.HWS_NetworkElementAssetName__c == null) && (bu.HWS_NEACount__c > 0) && phoneValidationFailureCheck == true)
					{  
						bu.Validation_Message__c='Please select NEA.';
						bu.Status__c = 'Failed';
					}
					//End Changes for 25679
					else if((bu.HWS_Service_Contract_Number__c != null || bu.HWS_Service_Contract_Number__c != '') && (bu.HWS_Ship_to_Address__c == null || bu.HWS_Ship_to_Address__c == null) && !contractShiptoAddrMap.containsKey(bu.HWS_Service_Contract_Number__c) && phoneValidationFailureCheck == true){					   
							bu.Validation_Message__c = 'Missing Ship to Address';
							bu.Status__c = 'Failed';																																				
					}
					else if((bu.HWS_Part_Code__c !='' && bu.HWS_Part_Code__c!= null) && (bu.HWS_Part_Revision__c!='' && bu.HWS_Part_Revision__c!= null) && phoneValidationFailureCheck == true)
					{
						if(bu.HWS_Part_Revision__c == 'ANY' && bu.Part_Code_Part_Revision__c.contains(bu.HWS_Part_Code__c)){
							pcprSet.add(bu.HWS_Part_Code__c.replaceAll('[^a-zA-Z0-9]', '')+'ANY');
							System.debug('part revision!!'+bu.HWS_Part_Revision__c);
							System.debug(' pcprSet!!'+pcprSet);
						}
						else{
					pcprSet.add(bu.Hws_PartCode_PartRevision__c);
						}
						loopId.add(bu.id);
					}
		if(contractShiptoAddrMap.containsKey(bu.HWS_Service_Contract_Number__c) && phoneValidationFailureCheck == true){
						bu.HWS_Ship_to_Address__c = contractShiptoAddrMap.get(bu.HWS_Service_Contract_Number__c);
					}
					system.debug('--680--buList--'+buList); 
	}
				
				if(!pcprSet.isEmpty()){
					system.debug('buList Values are'+pcprSet+' REvision:'+pcprSetRevision);
					List<hws_versionitem__c> versionDetails= [SELECT Id,HWS_Name__c, HWS_Serial_Number_Traceable__c,HWS_Product_Code__c,HWS_Version_Code__c,HWS_Part_Code_Part_Revision__c FROM hws_versionitem__c WHERE  HWS_Part_Code_Part_Revision__c in :pcprSet];
					system.debug('buList1 Values are'+versionDetails);
					system.debug('buListw Values are'+versionDetails.size());
					for(HWS_VersionItem__c vDet :versionDetails){
					   // if(vDet.HWS_Serial_Number_Traceable__c=='YES'||vDet.HWS_Serial_Number_Traceable__c=='Y'){
			 //if(vDet.HWS_Serial_Number_Traceable__c.equalsIgnoreCase('YES')||vDet.HWS_Serial_Number_Traceable__c.equalsIgnoreCase('Y')){
			 if((vDet.HWS_Serial_Number_Traceable__c != null && vDet.HWS_Serial_Number_Traceable__c != '') && (vDet.HWS_Serial_Number_Traceable__c.equalsIgnoreCase('YES')||vDet.HWS_Serial_Number_Traceable__c.equalsIgnoreCase('Y'))){							
							pcprSetRevision.add(vDet.HWS_Part_Code_Part_Revision__c.toUpperCase());
						}
						
					}
					for(HWS_BulkUpload__c bu : buList){
						//string partVal=bu.HWS_Part_Code__c+bu.HWS_Part_Revision__c;
						string partVal=bu.Hws_PartCode_PartRevision__c.toUpperCase();
			if(bu.HWS_Part_Revision__c == 'ANY'){
							partVal = bu.HWS_Part_Code__c.replaceAll('[^a-zA-Z0-9]', '').toUpperCase()+'ANY';
						}
						system.debug('----loopId size--'+loopId.size()+'---loopId--'+loopId);
						system.debug('----pcprSetRevision--'+pcprSetRevision+'----size---'+pcprSetRevision.size());
						if(loopId.size()>0 && loopId.contains(bu.id)){
							if(pcprSetRevision.Contains(partVal)) {
								If((bu.Faulty_Serial_number__c == ''  || bu.Faulty_Serial_number__c == null) ){
									bu.Validation_Message__c='Faulty Serial Number is Mandatory';
									system.debug('buList3 Values are'+bu.Validation_Message__c);
									bu.Status__c = 'Failed';
								}
								
								else {
									if(bu.Faulty_Serial_number__c !='' && bu.Faulty_Serial_number__c != null){
										loopIdValues.add(bu.id); 
										lstPartCode.add(bu.HWS_Part_Code__c);
										lstFaultySerialNumber.add(bu.Faulty_Serial_number__c);
										system.debug('I am there count 1 entered in else'+bu.Faulty_Serial_number__c);
										
									}
								}

							}
							else{
									if(bu.Faulty_Serial_number__c !='' && bu.Faulty_Serial_number__c != null){
										loopIdValues.add(bu.id); 
										lstPartCode.add(bu.HWS_Part_Code__c);
										lstFaultySerialNumber.add(bu.Faulty_Serial_number__c);
										system.debug('I am there count 1 entered in else'+bu.Faulty_Serial_number__c);
										
									}
								/*
								else{  
									if(bu.Faulty_Serial_number__c =='' || bu.Faulty_Serial_number__c == null){
										system.debug('Line 851:');
										bu.Status__c = 'Success';
									}
								}
*/
							}
						}
							
							/*
							else {
								if(bu.Faulty_Serial_number__c =='' && bu.Faulty_Serial_number__c == null){
									bu.Status__c = 'Success';
								}
							}
*/
							
						} 
						
					}
				//}
				if(loopIdValues.size()>0){
					system.debug('I am there count 2 Id Values'+loopIdValues.size());
					system.debug('part code in count2'+lstPartCode);
					system.debug('lstFaultySerialNumber in count2'+lstFaultySerialNumber);
					system.debug('I am there count 2');
					List<Case> caselist= 
						[Select id,HWS_Faulty_Serial_Number__c,CaseNumber,Status,HWS_Stockable_Product__r.HWS_Part_Code_Part_Revision__c,HWS_ServiceType__c,Asset.HWS_Part_Code__c 
						 From Case 
						 where (status Not in:childCaseStatusesforDuplicte ) AND Asset.HWS_Part_Code__c  in : lstPartCode 
						 AND HWS_Faulty_Serial_Number__c in : lstFaultySerialNumber AND HWS_Faulty_Serial_Number__c !=null 
						 AND HWS_ServiceType__c=:serviceType AND AccountID=:accountID
						];
					system.debug('I am there count 746: '+caselist.size());
					for(Case faultCode :caselist){
						if(faultCode.HWS_Faulty_Serial_Number__c !='' && faultCode.HWS_Faulty_Serial_Number__c != null){
							system.debug('I am there count 749 : '+faultCode.HWS_Stockable_Product__r.HWS_Part_Code_Part_Revision__c);
						   // lstSetRevision.add(faultCode.HWS_Stockable_Product__r.HWS_Part_Code_Part_Revision__c);
						   // partCodeCmp.put(faultCode.HWS_Faulty_Serial_Number__c,faultCode.HWS_Stockable_Product__r.HWS_Part_Code_Part_Revision__c);
						lstSetRevision.add(faultCode.Asset.HWS_Part_Code__c);						   
							partCodeCmp.put(faultCode.HWS_Faulty_Serial_Number__c.toUpperCase(),faultCode.Asset.HWS_Part_Code__c);
						}
					}
					for(HWS_BulkUpload__c bu : buList){
						//string partFault=bu.HWS_Part_Code__c+bu.HWS_Part_Revision__c;
			string partFault=bu.HWS_Part_Code__c;
						system.debug('I am there count 755 : '+partFault);
						system.debug('I am there count 756 : '+lstSetRevision);
						system.debug('I am there count 757 : '+loopIdValues);
						if(lstSetRevision.Contains(partFault) && loopIdValues.contains(bu.id) && partCodeCmp.containskey(bu.Faulty_Serial_number__c.toUpperCase())){
							system.debug('I am there count 759');
							bu.Validation_Message__c='The part code and serial number entered are already part of an open case';
							bu.status__c='Failed';
						}
						else{
							if( bu.Validation_Message__c== '' || bu.Validation_Message__c==null){
							   // bu.status__c='Success';
							}
							
						}
						
					}
				}
				system.debug('--705--buList--'+buList);
				//Check Duplicate
				Integer i=0;
				for(HWS_BulkUpload__c bu : buList){   
					i++;
					Integer j=0;
					String partCodeSerialNumber;
					if((bu.Faulty_Serial_number__c!='' && bu.Faulty_Serial_number__c!=null) &&(bu.HWS_Part_Code__c!='' && bu.HWS_Part_Code__c!=null)){
						 partCodeSerialNumber=bu.HWS_Part_Code__c+bu.Faulty_Serial_number__c;
					}
					
					for(HWS_BulkUpload__c bu1 : buList){
						j++;
						String strcompare=bu1.HWS_Part_Code__c+bu1.Faulty_Serial_number__c;
						if ((partCodeSerialNumber==strcompare) && (i!=j)){
							bu.status__c='Failed';
						  //  bu.Validation_Message__c=bu.Validation_Message__c+'You have entered duplicate entries for part code and faulty serial number combination, Please remove one these rows.';
		//Changes for US-26953(Modified the Error Message)
						   // bu.Validation_Message__c='You have entered duplicate entries for part code and faulty serial number combination, Please remove one of these rows.';
		bu.Validation_Message__c='You have entered duplicate entries for part code and faulty serial number combination, please correct the details or remove one of these rows.';
 
						}
					}
					if( bu.Validation_Message__c== '' || bu.Validation_Message__c==null){
						 system.debug('I am there count 930');
						bu.status__c='Success';
					}
				} 
				update buList;
			}
			catch(Exception ex){}
		}
	   
		return buList;
	}
	
	@auraEnabled
	public static boolean updateRMAValues(List<SObject> editedRMAList){
		System.debug('editedRMAList '+editedRMAList);
		try{
			update editedRMAList;		   
			return true;
		} catch(Exception e){		   
			return false;
		}
	}
	
	@AuraEnabled
	public static void deleteBulkUpload(List<Id> lstBulkUploadId){ List<HWS_BulkUpload__c> bulkUploadList=[Select id from HWS_BulkUpload__c where Id in :lstBulkUploadId];
		if(bulkUploadList.size()>0){
			Delete  bulkUploadList;
		}	 
	}
	
	@AuraEnabled
	public static String getResourceURL(String resourceName)
	{	  
		system.debug('resource name####'+resourceName);
		//Fetching the resource
		List<StaticResource> resourceList = [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :resourceName];
							
		//Checking if the result is returned or not
		if(resourceList.size() == 1)
		{
		   //Getting namespace
		   String namespace = resourceList[0].NamespacePrefix;
		   //Resource URL		 
		   return '/resource/' + resourceList[0].SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') + resourceName; 
		}
	else {		 
			return '';
		}
	}
  
	@auraEnabled
	public static List<Asset> getAllAssets(Id bulkId, Id accId,String serviceType,Id contactId){
		String expired = 'Expired';
		String inactive = 'Inactive';
		String externalStatus = 'Active';
		String classification='HWS Service';
		Boolean sync = true;
		Boolean enableForPortal = true;
		System.debug('bulkId:'+bulkId+'-accId:'+accId+'serviceType:'+serviceType+'-contactId:'+contactId); 
		String bulkUploadPartCode = [select id,HWS_Part_Code__c from HWS_BulkUpload__c where id=:bulkId].HWS_Part_Code__c;
		System.debug('bulkUploadPartCode:'+bulkUploadPartCode);
		//2503 SPS Last Order Date validation started added HWS_Product_SPSLOD__c field
		if(bulkUploadPartCode != null && bulkUploadPartCode != ''){
		String assetQuery = 'SELECT Id,HWS_SourceSystem__c,HWS_Product_SPSLOD__c,HWS_Service_Contract_Number__c,HWS_Currency__c,HWS_Price__c,Contract_Number__c,HWS_ContractLineItem__c,HWS_ContractLineItem__r.ServiceContract.HWS_Currency__c, HWS_ContractLineItem__r.CH_LineItemEntitlementScript__c,HWS_ContractLineItem__r.ServiceContract.CH_EntitlementScript__c,HWS_ContractLineItem__r.ServiceContract.CH_CountryCode__c,HWS_ContractLineItem__r.ServiceContract.CH_CountryName__c,HWS_ContractLineItem__r.ServiceContractId,HWS_ContractLineItem__r.HWS_AdditionalSIInfo1__c,HWS_ContractLeadTimeUnit__c,AccountId,HWS_ContractLeadTimeDuration__c,Product2Id,Product2.Name,ProductCode,'+
			'HWS_ServiceItemCode__c,HWS_ContractLineItem__r.ServiceContract.CH_ERPSystem__c, HWS_Part_Code__c,HWS_Service_Type__c,HWS_Product_Name__c, HWS_ContractLineItem__r.CH_BusinessHour__r.Id,HWS_ServiceItemDescription__c,HWS_High_Level_Product_Name__c,HWS_ContractLineItem__r.CH_CoverageGroup__c,HWS_ContractLineItem__r.CH_QtyCoveredNetworkElementAssets__c FROM Asset WHERE HWS_Part_Code__c =: bulkUploadPartCode AND AccountId =: accId AND (HWS_ContractLineItem__r.ServiceContract.NCP_External_Status__c =: externalStatus) AND HWS_ContractLineItem__r.CH_ServiceClassification__c=: classification AND HWS_ContractLineItem__r.NCP_External_Status__c=: externalStatus AND HWS_ExternalStatus__c=: externalStatus AND HWS_IsSynced__c =:sync AND HWS_ContractLineItem__r.ServiceContract.CH_PortalCaseCreationHWS__c =: enableForPortal';
		//getting only Authorized serviceContract Records
		//3697 - passing contactId  ****************Start*********
		Map<Id, Set<String>> servContrMap = new Map<Id, Set<String>>();
		if(contactId!=null){
			List<EntitlementContact> servContList = [select id, Entitlement.Name, Entitlement.ServiceContract.Name, Entitlement.ServiceContract.Id, Entitlement.ServiceContract.ContractNumber, Entitlement.Account.Name, Entitlement.AccountId, contact.Name, ContactId from EntitlementContact where ContactId = :contactId];
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
		}
		Set<String> contrSet = new Set<String>();
		if(servContrMap.size()>0){
			if(servContrMap.Containskey(accId)){
				contrSet = servContrMap.get(accId);
			}
		}
		if(contrSet.size()>0){
			assetQuery = assetQuery+' AND Contract_Number__c IN: contrSet';
		}
		//******************************End*********
		if(serviceType != null && serviceType !=''){
			assetQuery = assetQuery+' AND HWS_Service_Type__c=: serviceType';
		}
		System.debug('assetQuery'+assetQuery);
		list<Asset> listAssets = database.query(assetQuery);
		System.debug('listAssets**'+listAssets);
		for(Asset aset: listAssets){
			System.debug('aset**'+aset.HWS_ContractLineItem__r.Id);
		}	   
		return listAssets;
		}
		else {
			return null;
		}
	}
	
	@auraEnabled
	public static void updateServiceContractValues(Asset selectedAsset, Id bulkRecId){	 
		System.debug('bulkRecId:'+bulkRecId+'--selectedAsset:'+selectedAsset);
		HWS_BulkUpload__c bulkUploadRec = new HWS_BulkUpload__c();
		bulkUploadRec.Id = bulkRecId;
		bulkUploadRec.NCP_Service_Contract__c = selectedAsset.HWS_ContractLineItem__r.ServiceContractId;
		bulkUploadRec.HWS_Sellable_Product__c = selectedAsset.Product2Id;
		bulkUploadRec.HWS_Product_Name__c = selectedAsset.Product2.Name;
		bulkUploadRec.HWS_Contract_Line_Item__c  = selectedAsset.HWS_ContractLineItem__r.Id; 
		bulkUploadRec.HWS_Asset__c = selectedAsset.Id; 
		bulkUploadRec.HWS_Part_Code__c = selectedAsset.HWS_Part_Code__c;
		bulkUploadRec.SLA_Unit__c = selectedAsset.HWS_ContractLeadTimeUnit__c;
		bulkUploadRec.SLA_Value__c = selectedAsset.HWS_ContractLeadTimeDuration__c;
		bulkUploadRec.Comments__c = selectedAsset.HWS_ContractLineItem__r.CH_CoverageGroup__c;
		bulkUploadRec.SSI_Description__c = selectedAsset.HWS_ServiceItemDescription__c;
		bulkUploadRec.HWS_Service_Contract_Number__c = selectedAsset.HWS_Service_Contract_Number__c;
		bulkUploadRec.HWS_ServiceType__c=selectedAsset.HWS_Service_Type__c;
		//Start Changes for 25679
		Decimal getNEACount=selectedAsset.HWS_ContractLineItem__r.CH_QtyCoveredNetworkElementAssets__c!=Null?selectedAsset.HWS_ContractLineItem__r.CH_QtyCoveredNetworkElementAssets__c:null;
		bulkUploadRec.HWS_NEACount__c=getNEACount;
		if(getNEACount!= null && getNEACount ==1 && selectedAsset.HWS_Service_Contract_Number__c!=''){
			system.debug('getNEAAssetRec Entered');
			List<Asset> getNEAAssetRec =   getNetworkElementAsset(selectedAsset.HWS_ContractLineItem__r.Id,true);
			system.debug('getNEAAssetRec'+getNEAAssetRec.size());
			if(getNEAAssetRec.size()>0){
				bulkUploadRec.HWS_NetworkElementAsset__c=getNEAAssetRec[0].Id;
				bulkUploadRec.HWS_NetworkElementAssetName__c=getNEAAssetRec[0].Name;
				}
		}
		//End Changes for 25679
		update bulkUploadRec;
		System.debug('bulkUploadRec:'+bulkUploadRec);	 
	}
  
	@auraEnabled
	public static List<String> bulkUploadServiceTypes(Id accountId){
		Set<String> nonDuplicateSrcTypeSet = new Set<String>();
		List<String> bulkRMAServiceTypesLst = new List<String>{'Advanced Exchange in Days', 'Return for Repair or Replacement','Identical Repair'};
			List<ServiceContract> scLst = [SELECT Id, (SELECT Id, CH_ServiceType__c FROM ContractLineItems WHERE NCP_External_Status__c = 'Active') 
										   FROM ServiceContract 
										   WHERE AccountId = :accountId 
										   AND NCP_External_Status__c = 'Active'];
		if(!scLst.isEmpty()){
			for(ServiceContract sc : scLst){
				for(ContractLineItem cli : sc.ContractLineItems){
					if(bulkRMAServiceTypesLst.contains(cli.CH_ServiceType__c)){
						nonDuplicateSrcTypeSet.add(cli.CH_ServiceType__c);
					}
				}
			}
		}
		List<String> serviceTypeslst = new List<String>(nonDuplicateSrcTypeSet);
		serviceTypeslst.sort();	
		return serviceTypeslst;
	}
  
	/******************************************************************
Method Name: createBulkRMACase
Parameters : Bulkupload records(new list), accountId, ContactId
Description: Method is to create BulkRMA cases to the related contract numbers and added functionality to populate planned delivery date timezone functionality
for sprint 1926 - HWST-3681
CreatedBy : TCS HWS Team
CreatedDate : 07/03/2019 (MM/DD/YYYY)
ModifiedBy : Ajesh Juluru (NOKIASC-27269)
ModifiedDate : 18/03/2020
*********************************************************************/
	@AuraEnabled
	public static accountListCaseWrapper createBulkRMACase(List<HWS_BulkUpload__c> buList, Id accountId, Id contactId, Case parentCaseShipmentInfo, String serviceType, String contactTimeZone) {
		Set<String> serviceContractSet = new Set<String>();
		Set<String> pcprSet = new Set<String>();
		List<String> parentCaseNumbersLst = new List<String>();
		List<Case> zoneCaseList = new List<Case>();
		accountListCaseWrapper returnValueWrapper;
		System.debug('HWS_CreateSupportTicketportal:createBulkRMACase: Bulk RMA values: ' +buList +'and'+accountId +'and'+contactId+'and'+parentCaseShipmentInfo.HWS_Shipment_Recipient_Name__c+'and'+parentCaseShipmentInfo.HWS_ShipmentRecipientEmailId__c+'and'+parentCaseShipmentInfo.HWS_Shipment_Recipient_Phone__c+'and'+serviceType);	   
		Map<String, String> contractShiptoPrtyMap = new Map<String, String>();
		
		Savepoint sp = Database.setSavepoint();
		if(!buList.isEmpty()){
			for(HWS_BulkUpload__c bu : buList){
				if(bu.HWS_Service_Contract_Number__c != null && bu.HWS_Ship_to_Address__c != null){
					serviceContractSet.add(bu.HWS_Service_Contract_Number__c);
					contractShiptoPrtyMap.put(bu.HWS_Service_Contract_Number__c, bu.HWS_Ship_to_Address__c+'HWS'+(bu.Customer_Reference_Number__c == null?'':bu.Customer_Reference_Number__c));
				}
				pcprSet.add(bu.Part_Code_Part_Revision__c.replaceAll('[^a-zA-Z0-9]', ''));
			}
			System.debug('createBulkRMACase: serviceContractSet: ' +serviceContractSet +contractShiptoPrtyMap);
			if(!serviceContractSet.isEmpty() && !contractShiptoPrtyMap.isEmpty() && serviceContractSet != null && accountId != null && ContactId != null){
				System.debug('createBulkRMACase: serviceContractSet: ' +serviceContractSet +contractShiptoPrtyMap);
				Id parentCaseRecordTypeId = parentCaseRecordType;
				List<Case> parentCaseToInsertLst = new List<Case>();
				List<string> lststr = new List<String>();
				try {
					for(String contractNumber : serviceContractSet){
						Case parentCase = new Case();
						parentCase.RecordTypeId = parentCaseRecordTypeId;
						parentCase.ContactId = contactId;
						parentCase.AccountId = accountId;
						//Timezone	
						//parentCase.HWS_Delivery_TimeZone__c = contactTimeZone;
						parentCase.Hws_Ship_to_Party_Address__c = contractShiptoPrtyMap.get(contractNumber).substringBefore('HWS');
						lststr.add(contractShiptoPrtyMap.get(contractNumber).substringBefore('HWS'));
						//parentCase.HWS_Customer_Reference_Number__c = contractShiptoPrtyMap.get(contractNumber).substringAfter('HWS');
						parentCase.HWS_Shipment_Recipient_Name__c = parentCaseShipmentInfo.HWS_Shipment_Recipient_Name__c;
						parentCase.HWS_ShipmentRecipientEmailId__c = parentCaseShipmentInfo.HWS_ShipmentRecipientEmailId__c;
						parentCase.HWS_Shipment_Recipient_Phone__c = parentCaseShipmentInfo.HWS_Shipment_Recipient_Phone__c;
						parentCase.HWS_Contract_Number__c = contractNumber;
						parentCaseToInsertLst.add(parentCase);
					}
					if(lststr.size()>0){
						Boolean b = HWS_Utilty.accountToShare(lststr);
					}
					database.insert(parentCaseToInsertLst, true);
					//HWST-4046 changes --> Changed the Map<String, Id> to Map<String, Case>
					//Map<String, Id> contractNumCaseIdMap = new Map<String, Id>();
					Map<String, Case> contractNumCaseIdMap = new Map<String, Case>();
					for(Case c : [SELECT Id,CaseNumber,HWS_Contract_Number__c,Hws_Ship_to_Party_Address__c,HWS_ShipmentRecipientEmailId__c,HWS_Shipment_Recipient_Name__c,Hws_Ship_to_Party_Address__r.BillingStreet,Hws_Ship_to_Party_Address__r.BillingCity,Hws_Ship_to_Party_Address__r.BillingState,Hws_Ship_to_Party_Address__r.BillingPostalCode,Hws_Ship_to_Party_Address__r.BillingCountry FROM Case WHERE Id IN :parentCaseToInsertLst]){
						//HWST-4046 
						contractNumCaseIdMap.put(c.HWS_Contract_Number__c, c);
						parentCaseNumbersLst.add(c.CaseNumber);
											   
					}
					System.debug('HWS_CreateSupportTicketportal:createBulkRMACase: contractNumCaseIdMap' +contractNumCaseIdMap);
					List<Case> childCaseToInsert = new List<Case>();
					Id childCaseRecordTypeId;
					if(serviceType == 'Advanced Exchange in Days'){ 
						childCaseRecordTypeId = exchangeInDays;
					} else if(serviceType == 'Identical Repair' || serviceType == 'Return for Repair or Replacement'){
						childCaseRecordTypeId = rfr;
					}
					
					//Map<Id, DateTime> plannedDeliveryDateTimeBulkMap = HWS_Utilty.plannedDeliveryDateTimeBulk(buList);	  
					
					for(HWS_BulkUpload__c bu : buList){
						Case childCase = new Case();
						//vkt HWST_4187  
						if(bu.HWS_Part_Revision__c == 'ANY'){	  
							childCase.HWS_Customer_Part_Revision__c = (bu.Part_Code_Part_Revision__c.remove(bu.HWS_Part_Code__c));	
							system.debug('======'+childCase.HWS_Customer_Part_Revision__c);  
							if(childCase.HWS_Customer_Part_Revision__c.startsWith('-') || childCase.HWS_Customer_Part_Revision__c.startsWith('.') || childCase.HWS_Customer_Part_Revision__c.startsWith(':') || childCase.HWS_Customer_Part_Revision__c.startsWith('/') || childCase.HWS_Customer_Part_Revision__c.startsWith(',')){		
								childCase.HWS_Customer_Part_Revision__c = childCase.HWS_Customer_Part_Revision__c.substring(1, childCase.HWS_Customer_Part_Revision__c.length());	  
								if(childCase.HWS_Customer_Part_Revision__c.startsWith('-')){
									childCase.HWS_Customer_Part_Revision__c = childCase.HWS_Customer_Part_Revision__c.substring(1, childCase.HWS_Customer_Part_Revision__c.length());	  
								}	  
							}	  
						}
						
						childCase.RecordTypeId = childCaseRecordTypeId;
						//Startas - HWST-4046 
						Case c = contractNumCaseIdMap.get(bu.HWS_Service_Contract_Number__c);
						//childCase.ParentId = contractNumCaseIdMap.get(bu.HWS_Service_Contract_Number__c);
						childCase.ParentId = c.Id;
						childCase.HWS_Parent_case_Number__c = c.CaseNumber;
						//Ends - HWST-4046 
						childCase.NCP_Service_Contract__c = bu.NCP_Service_Contract__c;
						childCase.AccountId = accountId;
						childCase.ContactId = contactId;
						//Start Changes for 25679
						if(bu.HWS_NetworkElementAsset__c !=null){
							childCase.CH_NetworkElementAsset__c=bu.HWS_NetworkElementAsset__c;
						}
						//End Changes for 25679
						childCase.AssetId = bu.HWS_Asset__c;
						childCase.HWS_Part_Code__c = bu.HWS_Part_Code__c;
						//Added for single email
						childCase.Hws_Ship_to_Party_Address__c = c.Hws_Ship_to_Party_Address__c;
						childCase.HWS_ShipmentRecipientEmailId__c = c.HWS_ShipmentRecipientEmailId__c;
						childCase.HWS_Shipment_Recipient_Name__c = c.HWS_Shipment_Recipient_Name__c;
						//childCase.Comment__c = c.HWS_Shipment_Recipient_Name__c+'\n'+c.Hws_Ship_to_Party_Address__r.BillingStreet+',\n'+c.Hws_Ship_to_Party_Address__r.BillingCity+',\n'+c.Hws_Ship_to_Party_Address__r.BillingState+',\n'+c.Hws_Ship_to_Party_Address__r.BillingPostalCode;
						childCase.Comment__c = (c.HWS_Shipment_Recipient_Name__c==null ? ' ' :c.HWS_Shipment_Recipient_Name__c+',\n')+
							(c.Hws_Ship_to_Party_Address__r.BillingStreet==null ? ' ' :c.Hws_Ship_to_Party_Address__r.BillingStreet+'\n')+
							(c.Hws_Ship_to_Party_Address__r.BillingCity==null ? ' ' :c.Hws_Ship_to_Party_Address__r.BillingCity+',\n')+
							(c.Hws_Ship_to_Party_Address__r.BillingState==null ? ' ' :c.Hws_Ship_to_Party_Address__r.BillingState+',\n')+
							(c.Hws_Ship_to_Party_Address__r.BillingCountry==null ? ' ' :c.Hws_Ship_to_Party_Address__r.BillingCountry+',\n')+
							(c.Hws_Ship_to_Party_Address__r.BillingPostalCode==null ? ' ' :c.Hws_Ship_to_Party_Address__r.BillingPostalCode+'.');
						//Timezone	
						//childCase.HWS_Delivery_TimeZone__c = contactTimeZone;
						//childCase.HWS_Customer_Reference_Number__c = contractShiptoPrtyMap.get(bu.HWS_Service_Contract_Number__c).substringAfter('HWS');
						childCase.HWS_Customer_Reference_Number__c = bu.Customer_Reference_Number__c;
						childCase.HWS_ServiceType__c = serviceType;
						childCase.HWS_Part_Code__c = bu.HWS_Part_Code__c;
						//childCase.HWS_Stockable_Product__c = pcprMap.get(bu.Part_Code_Part_Revision__c.replaceAll('[^a-zA-Z0-9]', '').toUpperCase());
						childCase.HWS_Stockable_Product__c = bu.HWS_Bulk_Version_Item__c;
						childCase.HWS_Sellable_Product__c = bu.HWS_Sellable_Product__c;
						childCase.NCP_Product_Name__c = bu.HWS_Product_Name__c;
						childCase.HWS_Failure_Description__c = bu.Fault_Description__c;
						childCase.HWS_Failure_Detection__c = bu.Fault_Detection__c;
						childCase.HWS_Failure_Detection_Date__c = bu.Fault_Detection_Date__c;
						childCase.HWS_Failure_Occurance__c = bu.Fault_Occurrence__c;
						childCase.HWS_Faulty_Serial_Number__c = bu.Faulty_Serial_number__c;
						childCase.HWS_Fault_Reported_By_Name__c = bu.Fault_Reported_by_Name__c;
						childCase.HWS_Fault_Reported_By_Email__c = bu.Fault_Reported_by_Email__c;
						childCase.HWS_Fault_Reported_By_Phone__c = bu.Fault_Reported_by_Phone__c;
						childCase.HWS_Site_ID__c = bu.Site_Id__c;
						childCase.HWS_Failure_Description_Server_ID__c = bu.Failure_Description_Server_ID__c;
						//HWST-4039 added HWS_Contract_Line_Item__c value
						childCase.HWS_Contract_Line_Item__c = bu.HWS_Asset__r.HWS_ContractLineItem__r.Id;
						/*if(plannedDeliveryDateTimeBulkMap.containskey(bu.id)){						  
							childCase.HWS_Planned_Delivery_Date__c = plannedDeliveryDateTimeBulkMap.get(bu.Id);  
						}*/
						//childCase.HWS_Planned_Delivery_Date__c = HWS_Utilty.plannedDeliveryDateTime(bu.HWS_Asset__r.HWS_ContractLineItem__r.CH_BusinessHour__r.Id, bu.HWS_Asset__r.HWS_ContractLeadTimeUnit__c, bu.HWS_Asset__r.HWS_ContractLeadTimeDuration__c,null,bu.HWS_Asset__r.HWS_SpecifiedDeliveryTargetTime__c);		 
						childCaseToInsert.add(childCase);
					}
					zoneCaseList = timeZoneUpdateCaseList(childCaseToInsert);
					System.debug('***zoneCaseList****:'+zoneCaseList);
					database.insert(zoneCaseList, true);
					 returnValueWrapper = new accountListCaseWrapper(zoneCaseList,parentCaseNumbersLst, 'NoError');
				} catch(DMLException de){				   
					Database.RollBack(sp);
					parentCaseNumbersLst.clear();
					parentCaseNumbersLst.add(de.getStackTraceString());
					returnValueWrapper = new accountListCaseWrapper(zoneCaseList, parentCaseNumbersLst,'DMLError' );
					System.debug('Error while creating Case: '+de.getStackTraceString());
				} catch(Exception e) {				  
					Database.RollBack(sp);
					parentCaseNumbersLst.clear();
					parentCaseNumbersLst.add(e.getMessage());
					System.debug('Exception caught: ' + e.getMessage());
					returnValueWrapper = new accountListCaseWrapper(zoneCaseList, parentCaseNumbersLst,'DMLError');
				}	
			}
		}	
		if(!parentCaseNumbersLst.isEmpty()){		   
			return returnValueWrapper;
		} else {
			parentCaseNumbersLst.clear();
			parentCaseNumbersLst.add('');
			zoneCaseList.clear();
			returnValueWrapper = new accountListCaseWrapper(zoneCaseList,parentCaseNumbersLst,'error');		 
			return returnValueWrapper;
		}
	}
	// Added by Ajesh - NOKIASC-27269
	public class accountListCaseWrapper {
		@AuraEnabled
		public String sucessError {get; set;}
		@AuraEnabled
		public List<Case> newTimeZoneCaseList {get; set;}
		@AuraEnabled
		public List<String> parentAccIds {get; set;}   
		public accountListCaseWrapper(List<Case> newTimeZoneCaseList,List<String> parentAccIds, String sucessError){
			this.newTimeZoneCaseList = newTimeZoneCaseList;
			this.parentAccIds = parentAccIds;
			this.sucessError = sucessError;
		}
	}
	// End- NOKIASC-27269
	/****************************************
	*HWST-3785
	* Name : makeSOOCalloutBulkRMA
	* Description : returns List<Case> based on status to be updated from SOO response
	* Parameters: Parent Case Id
	* Returns : List<Case> 
	*****************************************/
	@auraEnabled
	public static List<Case> makeSOOCalloutBulkRMA(Id parentCaseId){
		Id childsCaseReadOnlyRType = childCaseReadOnly;
		Id parentCaseReadOnlyRType = parentCaseReadOnly;	   
		Id spsReadOnlyCaseRecordType = spsReadOnly;
		Id spsCaseRecordType = sPSCaseRType;
		Id childCaseAEDaysRecordType = exchangeInDays;
		Id childCaseAEHoursRecordType = exchangeInHours;
		Id childCaseReturnForRepairRecordType = rfr;
		Id hwsEntitlementRecordtypeId = Schema.getGlobalDescribe().get('Entitlement').getDescribe().getRecordTypeInfosByDeveloperName().get('HWS_Entitlement').getRecordTypeId();
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
			childCases = [select Id, Status,HWS_Communication_Contact__c, RecordTypeId, HWS_ServiceType__c,HWS_Case_Ordered_Date__c,AssetId, HWS_FaultyUnitReceivedDate__c, HWS_Contract_Line_Item__c, HWS_Contract_Line_Item__r.CH_BusinessHour__c from Case where ParentId =: parentCaseId AND Status!='Cancelled'];
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
								  WHERE RecordtypeId = :hwsEntitlementRecordtypeId AND ContractLineItemId IN :cliIdSet
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

					if(childCase.RecordTypeId == childCaseAEDaysRecordType || childCase.RecordTypeId == childCaseAEHoursRecordType || childCase.RecordTypeId == childCaseReturnForRepairRecordType ){
						//start changes for user story 2997
						if(childCase.status == 'Ordered' && childcase.HWS_Case_Ordered_Date__c==null && childCase.RecordTypeId == childCaseReturnForRepairRecordType){
							childcase.HWS_Case_Ordered_Date__c=System.now();
						}
						//End changes for user story 2997
						childCase.RecordTypeId = childsCaseReadOnlyRType;
						if(!cliIdEntilmentIdMap.isEmpty()){
							childCase.EntitlementId = cliIdEntilmentIdMap.get(childCase.HWS_Contract_Line_Item__c);
						}
						System.debug('makeSOOCallout:entitlementLst: inside for' +childCases);
					}
					if(childCase.RecordTypeId == spsCaseRecordType){
						childCase.RecordTypeId = spsReadOnlyCaseRecordType;
						if(!cliIdEntilmentIdMap.isEmpty()){
							childCase.EntitlementId = cliIdEntilmentIdMap.get(childCase.HWS_Contract_Line_Item__c);
						}
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
	   /* if (listNewCases.size()>0)
			update listNewCases;*/
		System.debug('return value to caseFLow after submittoSOO' +pr);	
		return listNewCases;
	}
  
	@auraEnabled
	public static Boolean updateStatusforMandatoryFields(List<HWS_BulkUpload__c> bulkRMAList){	 
	   //List<HWS_BulkUpload__c> buList = [Select id,Part_Code_Part_Revision__c,Fault_Detection__c,Fault_Description__c,
		 //							  Fault_Occurrence__c,Fault_detection_Date__c,Status__c from HWS_BulkUpload__c where id in:bulkUploadIds];			  
		List<HWS_BulkUpload__c> bulkList = new List<HWS_BulkUpload__c>();
			for(HWS_BulkUpload__c bu : bulkRMAList){
			System.debug('Fault_Description__c:'+bu.Fault_Description__c+' Fault_Detection__c:'+bu.Fault_Detection__c+
						'Fault_Occurrence__c:'+bu.Fault_Occurrence__c+' Fault_Detection_Date__c:'+bu.Fault_Detection_Date__c);
			if(bu.Fault_Description__c == null || bu.Fault_Detection__c == null || bu.Fault_Occurrence__c == null
			   || bu.Fault_Detection_Date__c == null || bu.Part_Code_Part_Revision__c == null){
				   bu.Status__c = 'Failed';
			   }
			else{
				bu.Status__c = '';
			}
				bulkList.add(bu);
		}
		update bulkList;
	   
		return true;
	}
  
	@auraEnabled
	public static List<HWS_Lookup_Class.untitleSObject> selectShipToAddress(Id accountId, String erp, String searchKey){		
		string searchValue = '%' +searchKey+ '%';
		if(erp !=null && erp !='' && erp != 'P20'){
			erp = 'eSpares';
		}
		Id logisticEntityExisting = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LOGISTIC_ACCOUNT_EXISTING);
		List<Account> accList = [Select Id,Name,Hws_Address_Line_1__c,Hws_Address_Line_2__c,Hws_Address_Line_3__c,BillingCity,BillingState,BillingCountry,BillingPostalCode from Account where ParentId =:accountId AND RecordTypeId =: logisticEntityExisting
								AND AccountSource =: erp AND (BillingCountry like :searchValue OR BillingCity like :searchValue OR BillingPostalCode like :searchValue OR BillingStreet like :searchValue OR BillingState like :searchValue)];
		List<HWS_Lookup_Class.untitleSObject> workingList= new List<HWS_Lookup_Class.untitleSObject>();
	if(accList.size()>0){
		for (SObject so : accList) {
			HWS_Lookup_Class.untitleSObject workObj = new HWS_Lookup_Class.untitleSObject();
			workObj.currentworkingTitleId = (Id)so.get('Id');
			workObj.currentworkingTitleName = (String)so.get('Name');
			workObj.addressLine1 = (String)so.get('Hws_Address_Line_1__c');
			workObj.addressLine2 = (String)so.get('Hws_Address_Line_2__c');
			workObj.addressLine3 = (String)so.get('Hws_Address_Line_3__c');
			workObj.cityStateCountry = (String)so.get('BillingCity');
			if((String)so.get('BillingState')!=null){
			workObj.cityStateCountry =workObj.cityStateCountry +','+(String)so.get('BillingState');
	  }
			if((String)so.get('BillingCountry')!=null){
			workObj.cityStateCountry = workObj.cityStateCountry +','+(String)so.get('BillingCountry');
	  }
			if((String)so.get('BillingPostalCode')!=null){
			workObj.cityStateCountry = workObj.cityStateCountry +','+(String)so.get('BillingPostalCode');
	  }
			//workObj.currentworkingTitleName = (String)so.get('Name');
			workObj.country = (String)so.get('BillingCountry');
			if(workingList == null) {
				workingList = new List<HWS_Lookup_Class.untitleSObject>();
			}
			workingList.add(workObj);
		}
	}   
		return workingList;
	}  
  
	@auraEnabled
	public static void updateShipToAddress(Id bulkRecId,Id shipToAddrId){ 
		//shipToAddrDupCheckSet = new Set<Id>();
		HWS_BulkUpload__c bu = new HWS_BulkUpload__c();
		bu.Id = bulkRecId;
		bu.HWS_Ship_to_Address__c = shipToAddrId;
		//shipToAddrDupCheckSet.add(shipToAddrId);
		update bu;	 
	}
  
	//start *****HWST-3785
	/****************************************
	*HWST-3785
	* Name : makeSOOCalloutBulkRMAUpdate
	* Description : Update List<Case> based on status to be updated from SOO response
	* Parameters: Parent CaseNumber list 
	* Returns : List<Case> 
	*****************************************/   
	@auraEnabled
	public static List<Case> makeSOOCalloutBulkRMAUpdate(List<String> parentCaseNumberList, List<Case> listChildCasetimeZone){ 
		//Calling batch class if multiple Parents created
		//if(parentCaseNumberList.size()>1){
		//Id batchJobId = Database.executeBatch(new HWS_MakeSOOCalloutBulkRMABatch (parentCaseNumberList), 100);		  
		//  }
		//else calling normal flow
		// else{
		// Added by Ajesh - NOKIASC-27269
		//if(!listChildCasetimeZone.isEmpty()){
		 //   update listChildCasetimeZone;
		//}
		//NOKIASC-27269 - End
		List<Case> caselist = [select id, CaseNumber from Case where CaseNumber in :parentCaseNumberList];
		if(caselist.size()>0){
			List<Case> caseListToUpdate = new List<Case>();
			for(Case c :caselist){				
				List<Case> caseLst = makeSOOCalloutBulkRMA(c.Id);
				caseListToUpdate.addAll(caseLst);
			}
			
			if(caseListToUpdate.size()>0){
				try{
					update caseListToUpdate;
				}
				catch(DMLException de){
					System.debug('Error while submitting/updating Case: '+de);
				}
			}
		}
		//}
		return null;  
	}
	//end ******* HWST-3785  
	
	 @auraEnabled
	public static Boolean getPayPerUse(Id parentCaseId){
		boolean isValue=false;
		List<Case> parentCase=[select id,HWS_Customer_PO__c from case where Id =:parentCaseId LIMIT 1];
		List<Case> childCases;
		if(parentCase[0].HWS_Customer_PO__c=='' || parentCase[0].HWS_Customer_PO__c== NULL){
			childCases = [select Id, HWS_Contract_Line_Item__r.CH_ServiceOffering__c from Case where ParentId =: parentCaseId AND Status!='Cancelled'];
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
		
		return isValue;
	}
	/****************************************
	* Name : timeZoneUpdateCaseList
	* Description : returns List of Cases with Upadted Planned Delivery Date and Account Timezone As Part of NOKIASC-27269,NOKIASC-27270
	* Returns : List<Case>
	* written on 6th Mar 2020
	* By Ajesh
	*****************************************/
	public static List<Case> timeZoneUpdateCaseList(List<Case> listCases){
		Map<Id,List<Case>> accIdListCaseMap = new Map<Id,List<Case>>();
		List<Case> timeZoneUpdatedCaseList= new List<Case>();
		List<Case> parentCases = new List<Case>();
		for(Case caseRec : listCases) {
			if(accIdListCaseMap.containsKey(caseRec.Hws_Ship_to_Party_Address__c)) {
				List<Case> listCase = accIdListCaseMap.get(caseRec.Hws_Ship_to_Party_Address__c);
				listCase.add(caseRec);
				accIdListCaseMap.put(caseRec.Hws_Ship_to_Party_Address__c, listCase);
			} else {
				accIdListCaseMap.put(caseRec.Hws_Ship_to_Party_Address__c, new List<Case> { caseRec });
			}
		}
		for(Id idValue : accIdListCaseMap.keyset())
		{
			HWS_Utilty.plannedDeliveryDateWrapper listCase = HWS_CaseFlow.accountTimeZoneplannedDeliveryDateTime(accIdListCaseMap.get(idValue),idValue);	
			List<Case> newtimeZoneCaseList = listCase.newTimeZoneCaseList;
			Case parentCase = new Case();
			parentCase.Id=newtimeZoneCaseList[0].ParentId;
			parentCase.HWS_Delivery_TimeZone__c = listCase.bhTimeZone;
			timeZoneUpdatedCaseList.addAll(newtimeZoneCaseList);
			parentCases.add(parentCase);
		}
		update parentCases;
		return timeZoneUpdatedCaseList;
	}
	
	 //26101
	/****************************************
	* Name : getShipToTimeZone
	* Description : returns Map of Map with TimezoneKey based on Country Timezone
	* Parameters: AccountId (Ship to Party Address) and List of BusinessHours Ids
	* Returns : Map of Map
	* written on 6th Mar 2020
	* By Satya Pagadala
	*****************************************/
	@auraEnabled
	public static Map<String, Map<Id, String>> getShipToTimeZone(Id selectedAccount, List<Id> businessHourIdList ){
		//Calling HWS_Caseflow.getShipToTimeZone --> Same code was there
		Map<String, Map<Id, String>> stringTimeZonemap = HWS_Caseflow.getShipToTimeZone(selectedAccount, businessHourIdList);
		return stringTimeZonemap;
	}  
	/*************************
	Method Name : accountTimeZoneplannedDeliveryDateTime
	Description : created for NOKIASC-26305 as part of sprint-2020
	Created By  : Ajesh
	Created Date: 25/02/2020 (MM/DD/YYYY)
	Modified By :
	Modified Date:
	******************************/
	@auraEnabled
	public static HWS_Utilty.plannedDeliveryDateWrapper accountTimeZoneplannedDeliveryDateTime(List<Case> listChildCases, Id selectedAccount ){
		HWS_Utilty.plannedDeliveryDateWrapper listCaseParentTimeZone = HWS_CaseFlow.accountTimeZoneplannedDeliveryDateTime(listChildCases, selectedAccount);
		system.debug('****listCaseParentTimeZone:'+listCaseParentTimeZone);
		return listCaseParentTimeZone;
	}
	
	 //Start Changes for 25679
	/*************************
Method Name : updateNEAValues
Description : created for NOKIASC-25679 as part of sprint-2021
Created By  : Pavan
Created Date: 03/11/2020 (MM/DD/YYYY)
Modified By :
Modified Date:
******************************/
	
	@auraEnabled
	public static void updateNEAValues(Asset selectedAsset, Id bulkRecId){   
	   System.debug('bulkRecId:'+bulkRecId+'--selectedAsset:'+selectedAsset);
		HWS_BulkUpload__c bulkUploadRec = new HWS_BulkUpload__c();
		bulkUploadRec.Id = bulkRecId;
		bulkUploadRec.HWS_NetworkElementAsset__c=selectedAsset.Id;
		bulkUploadRec.HWS_NetworkElementAssetName__c=selectedAsset.Name;
		update bulkUploadRec;
		System.debug('bulkUploadRec updateNEAValues:'+bulkUploadRec); 
		
	}
	
	
	/*************************
Method Name : getNetworkElementAsset
Description : created for NOKIASC-25679 as part of sprint-2021
Created By  : Pavan
Created Date: 03/11/2020 (MM/DD/YYYY)
Modified By :
Modified Date:
******************************/
	@auraEnabled
	public static List<Asset> getNetworkElementAsset(Id bulkId,Boolean byPassValue){
		List<Asset> neaAssetList;
		Id contractLineItemId;
		if(bulkId!=null){
			if(!byPassValue){
				contractLineItemId = [select id,HWS_Contract_Line_Item__r.id from HWS_BulkUpload__c where id=:bulkId].HWS_Contract_Line_Item__r.id;
			}
			else{
				contractLineItemId=bulkId;
			}
			System.debug('contractLineItemId:'+contractLineItemId);
			If(contractLineItemId != null){
				String neaRecordType = 'CH_NetworkElementAsset';
				String cneaStatus = 'Active';
				String cneaQuery = 'Select id,CH_ContractLineItem__c, CH_NetworkElementAsset__c from CH_CoveredNetworkElementAsset__c WHERE CH_NetworkElementAsset__c != null AND CH_Status__c = :cneaStatus AND CH_ContractLineItem__c = :contractLineItemId';
				List<CH_CoveredNetworkElementAsset__c> cneaList = Database.query(cneaQuery);		
				List<Id> astList = new List<Id>();
				for(CH_CoveredNetworkElementAsset__c cne : cneaList){
					astList.add(cne.CH_NetworkElementAsset__c); 
				}
				String neaAssetQuery = 'Select Id,Name,Product2Id,Product2.Name,CH_Solution__c,CH_Solution__r.Name,CH_ProductVariant__c,CH_ProductVariant__r.Name,CH_ProductRelease__c,CH_ProductRelease__r.Name,Address__c,Address__r.CH_AddressDetails__c,CH_NetworkElementID__c,CH_LabEnvironment__c,CH_CountryISOName__c,(Select id,Name,CH_ContractLineItem__c from Network_Element_Assets__r)  from Asset where RecordType.DeveloperName = :neaRecordType AND Id in :astList';		
				neaAssetList = Database.query(neaAssetQuery);
				System.debug('NEAs:'+neaAssetList);
			}
			
			
		}
		return neaAssetList;
	}
	//End Changes for 25679
	
/*************************
Method Name : getNEA
Description : created for NOKIASC-26091 as part of sprint-21
Created By  : Bharathi Nutakki
Created Date: 03/19/2020 (MM/DD/YYYY)
Modified By :
Modified Date:
******************************/
	@auraEnabled
	public static List<Asset> getNEA(Id accId, Id cliId,List<Id> cliIdList){		
		List<Asset> neaAssetList = HWS_Utilty.getNetworkElementAssets(accId,cliId,cliIdList);
		System.debug('NEAs:'+neaAssetList);
		return neaAssetList;
	}
/*************************
Method Name : listChildCasetimeZone
Description : created for NOKIASC-29371 as part of UAT
Created By  : Lokanadh Reddy
Created Date: 06/30/2020 (MM/DD/YYYY)
Modified By :
Modified Date:
******************************/
	 @auraEnabled
	public static List<Case> listChildCasetimeZone(List<Case> listChildCasetimeZone){
		if(listChildCasetimeZone.size()>1){
			update listChildCasetimeZone;
		}
		return listChildCasetimeZone;
	}
}