public without sharing class HWS_CreateSupportTicketportal {
	//32414
	public static Set<String> childCaseStatusesforDuplicte = HWS_Utilty.childCaseStatusesforDuplicte;
	public static Id exchangeInDays = HWS_Utilty.exchangeInDays;
	public static Id exchangeInHours = HWS_Utilty.exchangeInHours;
	public static Id childCaseReadOnly = HWS_Utilty.childCaseReadOnly;
	public static Id sPSCaseRType = HWS_Utilty.sPSCaseRType;
	public static Id spsReadOnly = HWS_Utilty.spsReadOnly;
	public static Id parentCaseRecordType = HWS_Utilty.parentCaseRecordType;
	public static Id parentCaseReadOnly = HWS_Utilty.parentCaseReadOnly;
	public static Id rfr = HWS_Utilty.rfr;
	public static Id esclationCase = HWS_Utilty.esclationCase;
	public static Id selectedSCId;
	public static String retrofitAccId;
	public static boolean isshowRetroAccount = false; // NOKIASC-37158
	public static map<id, integer> childCaseCount = new map<id, integer>(); //NOKIASC-37920 Bulk upload Optimization
	//NOKIASC-37150 -Start
	public static final Set<String> SETLESTATUS = new Set<String>{HWS_Constants.LE_APPROVAL_PICKLIST_VALUE1,HWS_Constants.LE_APPROVAL_PICKLIST_VALUE2};
	//NOKIASC-37150 -End
	//32414
	//method to findout duplicate falty unit serial for each material code  
	@auraEnabled
	public static list<Case> duplicateSerialNumberInfo(string serialNumber, string materialCode){   
		return HWS_Utilty.duplicateSerialNumberInfo(serialNumber, materialCode);
	} 
	
	@auraEnabled
	public static String getParentAccountId(string contactId)
	{ 
		Contact accs= [SELECT Id,AccountId FROM contact where Id = :contactId];  
		return accs.AccountId;
	}
	
	//32414
	@auraEnabled
	public static ContactInfoAllAcountsWrap getAllAccounts(string contactid)
	{  
		Contact con= [SELECT Id,Name,AccountId,Contact_Status__c FROM contact where Id = :contactid];
		ContactInfoAllAcountsWrap conAccWrap = new ContactInfoAllAcountsWrap();
		conAccWrap.contactId = con.Id;
		conAccWrap.Name = con.Name;
		conAccWrap.AccountId = con.AccountId;
		conAccWrap.listAccounts = HWS_Utilty.getAllAccounts(con, 'Portal');
		return conAccWrap;
	}
	/* Wrapper class to store contact info*/
	public class ContactInfoAllAcountsWrap {
		@auraEnabled
		public String contactId { get; set; }
		@auraEnabled
		public String Name { get; set; }
		@auraEnabled
		public String AccountId { get; set;}
		@auraEnabled
		public list<Account> listAccounts { get; set; }
	}   
	
	@auraEnabled
	public static List<hws_versionitem__c> getVersionItems(Asset selectedAsset,String searchValue){ 
		
		List<String> versionCodeList = new List<String>();  
		String searchCode=searchValue +'%';  
		String sourceSystem;
		Id salesProduct = HWS_Utilty.getRecordTypeByName('Product2',HWS_Constants.SALES_PRODUCT);   
		List<HWS_AlternateProductCode__c> altVersionItemsLst = [SELECT Id,HWS_VersionItem__r.HWS_Hardware_Sellable_Item__r.Id,HWS_VersionItem__r.HWS_Version_Code__c, Name, HWS_AlternateCodeType__c	
																FROM HWS_AlternateProductCode__c		
																WHERE HWS_VersionItem__r.HWS_Source__c =:sourceSystem AND HWS_VersionItem__r.HWS_Hardware_Sellable_Item__r.RecordTypeId =: salesProduct  
																AND Name LIKE:searchCode AND HWS_VersionItem__r.HWS_Hardware_Sellable_Item__c =:selectedAsset.Product2Id];  
		if(altVersionItemsLst.size()>0) {   
			for(HWS_AlternateProductCode__c pd : altVersionItemsLst){   
				versionCodeList.add(pd.HWS_VersionItem__r.HWS_Version_Code__c);
			}   
		}
		List<hws_versionitem__c> stockableItems = new List<hws_versionitem__c>();   
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
		String strQuery= 'SELECT id,Material_Code__c,CLEI__c,Comcode__c,Name,HWS_Product_Name__c,HWS_Version_Code__c,HWS_Hardware_Sellable_Item__c,HWS_Part_Code_Part_Revision__c, HWS_Serial_Number_Traceable__c FROM hws_versionitem__c WHERE HWS_Hardware_Sellable_Item__c =: sCLItmIds AND HWS_Source__c =:sourceSystem';
		if(versCodeList.size()>0){
			strQuery = strQuery+' AND HWS_Version_Code__c IN: versCodeList';			
		}
		strQuery = strQuery+' ORDER BY HWS_Version_Code__c';
		listContractLineItems = database.query(strQuery);
		return listContractLineItems;
	}
	
	@auraEnabled
	public static Contact getContactName(string contactid)
	{
		Contact con= [SELECT Id,Name,AccountId FROM contact where Id = :contactid];
		return con;
	}
	
	@auraEnabled
	public static String getContactType(string contactid)
	{ 
		Contact con= [SELECT Id,CH_ContactType__c,Contact_Status__c FROM contact where Id = :contactid];		
		return con.CH_ContactType__c;
		
	}
	/*************************
Method Name : getInternalStatus for 34638
Description : This method is getting invoked from "HWS_Submit_CaseToSOO_Portal" component 
to insert child cases 
Created By  : Gopi Krishna
Created Date: 24-02-2021
Modified By :
Modified Date: 
******************************/   
	@auraEnabled
	public static boolean getInternalStatus(string caseid)
	{   
		boolean InternalStatus = false;
		Case caseStat= [SELECT Id,CH_InternalStatus__c FROM case where Id = :caseid];
		if(casestat.CH_InternalStatus__c == 'Under Review' || casestat.CH_InternalStatus__c == 'Quotation Required' || casestat.CH_InternalStatus__c == 'Warranty Verification Required'){   
			InternalStatus = true;
		}
		return InternalStatus;
	}
	@auraEnabled
	public static boolean getWorkgroup(string caseid)
	{   
		boolean  isWorkgroup = false;
		Case caseStat= [SELECT Id,CH_Workgroup__c FROM case where Id = :caseid];
		if(casestat.CH_Workgroup__c !=null && casestat.CH_Workgroup__c !=''){   //SIT_Fix deploymet pending
			isWorkgroup = true;
		}
	return isWorkgroup;
   }
	
	@auraEnabled
	public static List<hws_versionitem__c> getVersions(list<Asset> listServiceServiceCon){  
		String sourceSystem;
		Set<Id> sCLItmIds = new Set<Id>();
		List<hws_versionitem__c> stockableItems = new List<hws_versionitem__c>();
		for(Asset cl : listServiceServiceCon){
			sCLItmIds.add(cl.Product2Id);
			sourceSystem = cl.HWS_SourceSystem__c;
		}   
		
		return stockableItems;
	}
	
	//Method to get the Service Contracts when search type is selected as Contract Number
	//3697
	@AuraEnabled 
	public Static Map<String, List<ContractLineItem>> getServiceContracts(String selectedAccount,String   searchString,String serviceType,String selectedcontractNumber, Id contactId ){
		Map<String, List<ContractLineItem>> mapContractLine = new Map<String, List<ContractLineItem>>();
		String contractNumber = searchString+'%';
		List<ContractLineItem> serviceContracts = new List<ContractLineItem>();  
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
		List<string> lststr = new List<string>();
		lststr.add(shipAccId);
		if(lststr.size()>0){
			//32414   
			HWS_Utilty.accountToShare(lststr); // To share ship to party account with portal user
		}
		List<Case> childCase = new List<Case>();		
		Id sps = sPSCaseRType;  
		
		try {
			case parentCase1 = parentCase;
			Case parentCaseId;
			parentCase1.ContactId = contactid;
			parentCase1.AccountId = accountId;  
			parentCase1.RecordTypeId=parentCaseRecordType;
			parentCase1.Country__c = contractLines[0].HWS_ContractLineItem__r.CH_CountryISOName__c;
			parentCase1.NCP_Service_Contract__c = childCaseList[0].NCP_Service_Contract__c;//NOKIASC-34876
			parentCase1.CH_CIRCount__c = childCaseList.size();//NOKIASC-31849
			
			
			//NOKIASC-31884
			if(parentCase1.CH_ReportedDate__c == null){
				parentCase1.CH_ReportedDate__c = System.now();
			}//NOKIASC-31884
			//NOKIASC- 32497 STARTS
			Account shipToPartyAddress = [SELECT Id,Name,Hws_Address_Line_1__c,Hws_Address_Line_2__c,Hws_Address_Line_3__c,BillingCity,
										  BillingPostalcode,Region__c,BillingState,BillingCountry FROM Account WHERE Id =: parentCase1.Hws_Ship_to_Party_Address__c];
			if(shipToPartyAddress != NULL){
				parentCase1.HWS_Address_Name__c  = shipToPartyAddress.Name;
				parentCase1.Street_Address_1__c  = shipToPartyAddress.Hws_Address_Line_1__c;
				parentCase1.Street_Address_2__c  = shipToPartyAddress.Hws_Address_Line_2__c;
				parentCase1.Street_Address_3__c  = shipToPartyAddress.Hws_Address_Line_3__c;
				parentCase1.City__c  = shipToPartyAddress.BillingCity;
				parentCase1.POSTAL_CODE_CHQ__c   = shipToPartyAddress.BillingPostalcode;
				parentCase1.HWS_Region__c   = shipToPartyAddress.Region__c;
				parentCase1.State__c	= shipToPartyAddress.BillingState;
				parentCase1.Country__c   = shipToPartyAddress.BillingCountry;
			}
			//NOKIASC- 32497 ENDS
			//32414   
			Database.insert(new SObject[] {parentCase1});   
			//Added for single email
			parentCaseId = [Select id,CH_GWC_SecurityGroup__c,CH_SecurityGroup__c,caseNumber,Hws_Ship_to_Party_Address__c,HWS_Delivery_TimeZone__c,Hws_Ship_to_Party_Address__r.BillingStreet,Hws_Ship_to_Party_Address__r.BillingCity,Hws_Ship_to_Party_Address__r.BillingState,Hws_Ship_to_Party_Address__r.BillingPostalCode,Hws_Ship_to_Party_Address__r.BillingCountry from case where Id = :parentCase1.Id];
			if (parentCaseId !=NULL)
			{
				for(Case caseRec : childCaseList){
					case childCase1 = caseRec;  
					childCase1.ContactId = contactid;
					childCase1.AccountId = accountId;
					childCase1.HWS_Delivery_TimeZone__c = parentCaseId.HWS_Delivery_TimeZone__c;
					childCase1.ParentId = parentCase1.Id;
					childCase1.CH_Email2__c=parentCase1.CH_Email2__c;//NokiaSc-27247
					childCase1.CH_Email3__c=parentCase1.CH_Email3__c;//NokiaSc-27247
					//Added on 30-March-2021 | NOKIASC-35143 | Start
					childCase1.CH_GWC_SecurityGroup__c = parentCaseId.CH_GWC_SecurityGroup__c;
					childCase1.CH_SecurityGroup__c   = parentCaseId.CH_SecurityGroup__c;
					//Added on 30-March-2021 | NOKIASC-35143 | End
					// Added for the Parent Case ID
					// Added for single email
					childCase1.Hws_Ship_to_Party_Address__c = parentCase1.Hws_Ship_to_Party_Address__c;
					childCase1.HWS_ShipmentRecipientEmailId__c = parentCase1.HWS_ShipmentRecipientEmailId__c;
					childCase1.HWS_Shipment_Recipient_Name__c = parentCase1.HWS_Shipment_Recipient_Name__c;  
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
					if(serviceType.containsIgnoreCase('days')){
						childCase1.RecordTypeId = exchangeInDays;   
					}else if((serviceType.containsIgnoreCase('SPS'))||(serviceType.containsIgnoreCase('SALES'))){
						childCase1.RecordTypeId = sps;
					}else if((serviceType.containsIgnoreCase('RETURN FOR REPAIR')) ||(serviceType.containsIgnoreCase(HWS_Constants.IR))){
						childCase1.RecordTypeId = rfr;
					}else{
						childCase1.RecordTypeId = exchangeInHours;
					}
					//26101--> Clear values which is added(Dummy values in Lightning Component)
					childCase1.Street_Address_1__c = null;
					childCase1.Street_Address_2__c = null;
					childCase1.Street_Address_3__c = null;
					if(childCase1.CH_EntitlementException__c == 'Warranty Status Check Failed'){
						childCase1.HWS_WarrantyStatus__c = 'Warranty Unknown';
					}
					childCase.add(childCase1);
				}
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
		return HWS_Utilty.makeSOOCallout(parentCaseId,'true');
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
			Database.insert(new SObject[] {cas});
			for(Case c1 : [Select id,casenumber from case where id = : cas.Id]){ caseList2.add(c1);}
			
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
		List<User> u = [SELECT Id, ContactId, Contact.Name,Contact.AccountId, Contact.Email1__c, Contact.CH_Email3__c,Contact.CH_ContactTimeZone__c FROM User WHERE Id =: cussrentLoggedUserId];		
		return u;
	}
	/*************************
Method Name : getContactDetailsForConsole
Description : This method fetch contact details for Console bulk upload
created for NOKIASC:37118:Get contact details for Console bulk upload
Created By  : TCS
Created Date: 07/23/2021 (MM/DD/YYYY)
Modified By :
Modified Date:
******************************/
	@auraEnabled		
	public static Contact getContactDetailsForConsole(string contactId)	
	{	  
		
		Contact con= [SELECT Id,Name,AccountId,CH_ContactType__c,Contact_Status__c,CH_ContactTimeZone__c,Email1__c,CH_Email3__c FROM contact where Id = :contactId ];	  
		return con;  
	}

	
	/*************************32414
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
	public static Map<String, List<Asset>> getContractlineItems(String accountId, String searchValue, String serviceType, String contractNumber, Id contactId, String country){   
		return HWS_Utilty.getContractlineItems(accountId, searchValue, serviceType, contractNumber, contactId, country, 'Portal');
	}
	
	@auraEnabled
	public static Id getRecordType(string serviceType){
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
		Case caseStat= [SELECT Id,Status,(select id,status from cases where status = 'Draft') FROM case where Id = :caseid and HWS_Sent_To_SOO__c = false];
		if(casestat!=null && casestat.cases.size()>0){ 
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
							if(String.isNotBlank(inputvalues[l])) // updated for NOKIASC-38815
							{
								if(da == 7 ){
									
									
									string[] st = inputvalues[l].split('/');
									Integer year = Integer.valueOf(st[2].trim());
									Integer month = Integer.valueOf(st[0].trim());
									Integer day = Integer.valueOf(st[1].trim());
									
									date dt =  date.newinstance(year, month, day);
									
									
									
									obj.put(fields.get(l),dt);
								}
								else{
									obj.put(fields.get(l),inputvalues[l].replace('�', '').replace('"', ''));
								}
							}
							else{
								if(da == 7 ){
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
			System.debug(LoggingLevel.DEBUG,'Errorrrrrr'+e);
			bulkUploadMap.put(false, bulkUploadId);
			
			return bulkUploadMap;
		}
		
		return bulkUploadMap;
	}
	
	@AuraEnabled
	public static List<HWS_BulkUpload__c> setTableData(List<Id> rmaIds){ 
		Boolean isStatusSuccess = true;
		List<HWS_BulkUpload__c> buList = new List<HWS_BulkUpload__c>();
		//NOKIASC-36274:HWS_Combined_Ordering__c field added
		List<HWS_BulkUpload__c> savedBuList = [Select id,HWS_PO_Number__c, HWS_Asset__r.HWS_ContractLineItem__r.Id,HWS_Asset__r.HWS_ContractLineItem__r.CH_CountryISOName__c, Part_Code_Part_Revision__c,HWS_Part_Code__c, HWS_Part_Revision__c,HWS_Sellable_Product__c,HWS_Product_Name__c,NCP_Service_Contract__c,HWS_Asset__c,Faulty_Serial_number__c,Fault_Detection__c,Fault_Description__c,
											   SLA_Unit__c,SLA_Value__c,SSI_Description__c,Comments__c,HWS_Asset__r.HWS_ContractLineItem__r.CH_BusinessHour__r.Id,HWS_Asset__r.HWS_ContractLeadTimeUnit__c,HWS_Asset__r.HWS_ContractLeadTimeDuration__c,HWS_Service_Contract_Number__c,Fault_Occurrence__c,HWS_Asset__r.HWS_SpecifiedDeliveryTargetTime__c,Fault_detection_Date__c,Failure_Description_Server_ID__c,Customer_Reference_Number__c,
											   Fault_Reported_by_Name__c,Status__c, Fault_Reported_by_Phone__c,Fault_Reported_by_Email__c,Site_Id__c,Validation_Message__c,HWS_Ship_to_Address__c,HWS_Ship_to_Address__r.Name,HWS_Asset__r.HWS_ContractLineItem__r.ServiceContract.CH_ERPSystem__c,HWS_Asset__r.HWS_ContractLineItem__r.ServiceContract.HWS_Combined_Ordering__c, HWS_Bulk_Version_Item__c
											   ,HWS_NEACount__c,HWS_NetworkElementAsset__c,HWS_NetworkElementAssetName__c, Warranty_Verification_Required__c,HWS_Site_Information__c from HWS_BulkUpload__c 
											   where id in:rmaIds  Order by Status__c Asc NULLS LAST]; 
		
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
				//NOKIASC-36274:HWS_Combined_Ordering__c field added
				buList = [Select id,HWS_PO_Number__c,HWS_Asset__r.HWS_ContractLineItem__r.Id, Part_Code_Part_Revision__c,HWS_Part_Code__c, HWS_Asset__r.HWS_ContractLineItem__r.CH_CountryISOName__c,HWS_Part_Revision__c,HWS_Sellable_Product__c,HWS_Product_Name__c,NCP_Service_Contract__c,HWS_Asset__c,Faulty_Serial_number__c,Fault_Detection__c,Fault_Description__c,
						  SLA_Unit__c,SLA_Value__c,SSI_Description__c,Comments__c,HWS_Asset__r.HWS_ContractLineItem__r.CH_BusinessHour__r.Id,HWS_Asset__r.HWS_ContractLeadTimeUnit__c,HWS_Asset__r.HWS_ContractLeadTimeDuration__c,HWS_Asset__r.HWS_SpecifiedDeliveryTargetTime__c,HWS_Service_Contract_Number__c,Fault_Occurrence__c,Fault_detection_Date__c,Failure_Description_Server_ID__c,Customer_Reference_Number__c,
						  Fault_Reported_by_Name__c,Status__c, Fault_Reported_by_Phone__c,Fault_Reported_by_Email__c,Site_Id__c,Validation_Message__c,HWS_Ship_to_Address__c,HWS_Ship_to_Address__r.Name,HWS_Asset__r.HWS_ContractLineItem__r.ServiceContract.CH_ERPSystem__c,HWS_Asset__r.HWS_ContractLineItem__r.ServiceContract.HWS_Combined_Ordering__c, HWS_Bulk_Version_Item__c
						  ,HWS_NEACount__c,HWS_NetworkElementAsset__c,HWS_NetworkElementAssetName__c,Warranty_Verification_Required__c,HWS_Site_Information__c from HWS_BulkUpload__c where 
						  id in:rmaIds Order by HWS_Service_Contract_Number__c Asc];	
			}
		}   
		return buList;
	} 
	@AuraEnabled
	public static List<HWS_BulkUpload__c> getInPendingData(List<Id> rmaIds) {
		List<HWS_BulkUpload__c> buList = new List<HWS_BulkUpload__c>();
		Boolean isStatusSuccess = true;
		//NOKIASC-36274:HWS_Combined_Ordering__c field added
		List<HWS_BulkUpload__c> savedBuList = [Select id,HWS_PO_Number__c, HWS_Asset__r.HWS_ContractLineItem__r.Id,HWS_Asset__r.HWS_ContractLineItem__r.CH_CountryISOName__c, Part_Code_Part_Revision__c,HWS_Part_Code__c, HWS_Part_Revision__c,HWS_Sellable_Product__c,HWS_Product_Name__c,NCP_Service_Contract__c,HWS_Asset__c,Faulty_Serial_number__c,Fault_Detection__c,Fault_Description__c,
											   SLA_Unit__c,SLA_Value__c,SSI_Description__c,Comments__c,HWS_Asset__r.HWS_ContractLineItem__r.CH_BusinessHour__r.Id,HWS_Asset__r.HWS_ContractLeadTimeUnit__c,HWS_Asset__r.HWS_ContractLeadTimeDuration__c,HWS_Service_Contract_Number__c,Fault_Occurrence__c,HWS_Asset__r.HWS_SpecifiedDeliveryTargetTime__c,Fault_detection_Date__c,Failure_Description_Server_ID__c,Customer_Reference_Number__c,
											   Fault_Reported_by_Name__c,Status__c, Fault_Reported_by_Phone__c,Fault_Reported_by_Email__c,Site_Id__c,Validation_Message__c,HWS_Ship_to_Address__c,HWS_Ship_to_Address__r.Name,HWS_Asset__r.HWS_ContractLineItem__r.ServiceContract.CH_ERPSystem__c,HWS_Asset__r.HWS_ContractLineItem__r.ServiceContract.HWS_Combined_Ordering__c, HWS_Bulk_Version_Item__c
											   ,HWS_NEACount__c,HWS_NetworkElementAsset__c,HWS_NetworkElementAssetName__c, Warranty_Verification_Required__c,HWS_Site_Information__c from HWS_BulkUpload__c 
											   where id in:rmaIds  AND Warranty_Verification_Required__c = 'Yes' Order by Status__c Asc NULLS LAST]; 
		
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
				//NOKIASC-36274:HWS_Combined_Ordering__c field added
				buList = [Select id,HWS_PO_Number__c,HWS_Asset__r.HWS_ContractLineItem__r.Id, Part_Code_Part_Revision__c,HWS_Part_Code__c, HWS_Asset__r.HWS_ContractLineItem__r.CH_CountryISOName__c,HWS_Part_Revision__c,HWS_Sellable_Product__c,HWS_Product_Name__c,NCP_Service_Contract__c,HWS_Asset__c,Faulty_Serial_number__c,Fault_Detection__c,Fault_Description__c,
						  SLA_Unit__c,SLA_Value__c,SSI_Description__c,Comments__c,HWS_Asset__r.HWS_ContractLineItem__r.CH_BusinessHour__r.Id,HWS_Asset__r.HWS_ContractLeadTimeUnit__c,HWS_Asset__r.HWS_ContractLeadTimeDuration__c,HWS_Asset__r.HWS_SpecifiedDeliveryTargetTime__c,HWS_Service_Contract_Number__c,Fault_Occurrence__c,Fault_detection_Date__c,Failure_Description_Server_ID__c,Customer_Reference_Number__c,
						  Fault_Reported_by_Name__c,Status__c, Fault_Reported_by_Phone__c,Fault_Reported_by_Email__c,Site_Id__c,Validation_Message__c,HWS_Ship_to_Address__c,HWS_Ship_to_Address__r.Name,HWS_Asset__r.HWS_ContractLineItem__r.ServiceContract.CH_ERPSystem__c,HWS_Asset__r.HWS_ContractLineItem__r.ServiceContract.HWS_Combined_Ordering__c, HWS_Bulk_Version_Item__c
						  ,HWS_NEACount__c,HWS_NetworkElementAsset__c,HWS_NetworkElementAssetName__c,Warranty_Verification_Required__c,HWS_Site_Information__c from HWS_BulkUpload__c where 
						  id in:rmaIds AND Warranty_Verification_Required__c = 'Yes' Order by HWS_Service_Contract_Number__c Asc];  
			}
		}   
		return buList;  
	}
	
	
	
	public static Map<String,List<Asset>> getContractNumbers(List<String> partCodes, Id accId,String serviceType,Id contactId){
		Map<String,List<Asset>> mapAssets = new Map<String,List<Asset>>();
		//32414  
		String externalStatus = 'Active';
		String classification='HWS Service';
		Boolean sync = true;
		Boolean enableForPortal = true;
		//2503 SPS Last Order Date validation started added HWS_Product_SPSLOD__c field
		//NOKIASC-36274:HWS_Combined_Ordering__c field added
		//NOKIASC-37150 -Added HWS_PartLEStatus__c in query and filter
		String assetQuery = 'SELECT Id,HWS_PartLEStatus__c,HWS_ContractLineItem__r.HWS_PONumber__c,HWS_ContractLineItem__r.Asset.Product2.Name,HWS_ContractLineItem__r.CH_ServiceOffering__c,HWS_SourceSystem__c,HWS_Product_SPSLOD__c,HWS_Service_Contract_Number__c,HWS_Currency__c,HWS_Price__c,Contract_Number__c,HWS_ContractLineItem__c,HWS_ContractLineItem__r.ServiceContract.HWS_Currency__c, HWS_ContractLineItem__r.CH_LineItemEntitlementScript__c,HWS_ContractLineItem__r.ServiceContract.CH_EntitlementScript__c,HWS_ContractLineItem__r.ServiceContract.CH_CountryCode__c,HWS_ContractLineItem__r.HWS_WarrantyVerificationRequired__c,HWS_ContractLineItem__r.ServiceContract.CH_CountryName__c,HWS_ContractLineItem__r.ServiceContractId,HWS_ContractLineItem__r.HWS_AdditionalSIInfo1__c,HWS_ContractLeadTimeUnit__c,AccountId,HWS_ContractLeadTimeDuration__c,Product2Id,Product2.Name,ProductCode,'+
			'HWS_ServiceItemCode__c,HWS_ContractLineItem__r.ServiceContract.CH_ERPSystem__c,HWS_ContractLineItem__r.ServiceContract.HWS_Combined_Ordering__c, HWS_Part_Code__c,HWS_Service_Type__c,HWS_Product_Name__c, HWS_ContractLineItem__r.CH_BusinessHour__r.Id,HWS_ServiceItemDescription__c,HWS_High_Level_Product_Name__c,HWS_ContractLineItem__r.CH_CoverageGroup__c,HWS_ContractLineItem__r.CH_QtyCoveredNetworkElementAssets__c FROM Asset WHERE HWS_Part_Code__c In: partCodes AND AccountId =: accId AND (HWS_ContractLineItem__r.ServiceContract.NCP_External_Status__c =: externalStatus) AND HWS_ContractLineItem__r.CH_ServiceClassification__c=: classification AND HWS_ContractLineItem__r.NCP_External_Status__c=: externalStatus AND HWS_ExternalStatus__c=: externalStatus AND HWS_IsSynced__c =:sync AND HWS_ContractLineItem__r.ServiceContract.CH_PortalCaseCreationHWS__c =: enableForPortal  AND HWS_PartLEStatus__c IN:SETLESTATUS';
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
		if(servContrMap.size()>0 && servContrMap.Containskey(accId)){
			
			contrSet = servContrMap.get(accId);
			
		}
		if(selectedSCId != null){
				assetQuery = assetQuery+' AND HWS_ContractLineItem__r.ServiceContract.Id=: selectedSCId AND HWS_ContractLineItem__r.CH_ServiceItemDescription__c LIKE \'%Retrofit%\'';
				//assetQuery = assetQuery+' AND Contract_Number__c IN: contrSet';
			}
			else{
				if(contrSet.size()>0){
					assetQuery = assetQuery+' AND Contract_Number__c IN: contrSet';
				}
			}
		//******************************End*********
		if(serviceType != null && serviceType !=''){
			assetQuery = assetQuery+' AND HWS_Service_Type__c=: serviceType';
		}
		list<Asset> listAssets = database.query(assetQuery);
		for(Asset assetRec: listAssets) {
			if(mapAssets.containsKey(assetRec.HWS_Part_Code__c)) {
				mapAssets.get(assetRec.HWS_Part_Code__c).add(assetRec); 
			}   
			else {
				mapAssets.put(assetRec.HWS_Part_Code__c, new List<Asset> {assetRec});
			}
		}
		system.debug('mapAssets========'+mapAssets);
		return mapAssets;
		
	}
	public static Map<Id,Asset> getAssetMap(set<Id> assetIds){
		//NOKIASC-36274:HWS_Combined_Ordering__c field added
		Map<Id,Asset> assetMap = new Map<Id,Asset>([SELECT Id,HWS_ContractLineItem__r.HWS_PONumber__c,HWS_ContractLineItem__r.Asset.Product2.Name,HWS_ContractLineItem__r.CH_ServiceOffering__c,HWS_SourceSystem__c,HWS_Product_SPSLOD__c,HWS_Service_Contract_Number__c,HWS_Currency__c,HWS_Price__c,Contract_Number__c,HWS_ContractLineItem__c,HWS_ContractLineItem__r.ServiceContract.HWS_Currency__c, HWS_ContractLineItem__r.CH_LineItemEntitlementScript__c,HWS_ContractLineItem__r.ServiceContract.CH_EntitlementScript__c,HWS_ContractLineItem__r.ServiceContract.CH_CountryCode__c,HWS_ContractLineItem__r.HWS_WarrantyVerificationRequired__c,HWS_ContractLineItem__r.ServiceContract.CH_CountryName__c,HWS_ContractLineItem__r.ServiceContractId,HWS_ContractLineItem__r.HWS_AdditionalSIInfo1__c,HWS_ContractLeadTimeUnit__c,AccountId,HWS_ContractLeadTimeDuration__c,Product2Id,Product2.Name,ProductCode,HWS_ServiceItemCode__c,HWS_ContractLineItem__r.ServiceContract.CH_ERPSystem__c,HWS_ContractLineItem__r.ServiceContract.HWS_Combined_Ordering__c, HWS_Part_Code__c,HWS_Service_Type__c,HWS_Product_Name__c,HWS_ContractLineItem__r.CH_BusinessHour__r.Id,HWS_ServiceItemDescription__c,HWS_High_Level_Product_Name__c,HWS_ContractLineItem__r.CH_CoverageGroup__c,HWS_ContractLineItem__r.CH_QtyCoveredNetworkElementAssets__c FROM Asset where Id =: assetIds]);
		
		return  assetMap;
	}
	@auraEnabled
	public static List<HWS_BulkUpload__c> validateFaultyRetroFit(List<SObject> recordID,Id accountID,string serviceType,Id contactId,Id shipToAddrUpdated, Id selectedSC,String retrofitAccountId,String legalAccNum  ){
		if(selectedSC != null)
		selectedSCId = selectedSC;
		//NOKIASC-36821 -start setting retrofit accountId
		if(retrofitAccountId != null && retrofitAccountId !='') {
			retrofitAccId = retrofitAccountId;
			
		}
		isshowRetroAccount = true; // NOKIASC-37158 added isshowRetroAccount as true as it is a retro request
		//NOKIASC-36821- end
		return validateFaulty(recordID, accountID, serviceType,contactId,shipToAddrUpdated,legalAccNum );
	}
	
	@auraEnabled
	public static List<HWS_BulkUpload__c> validateFaulty(List<SObject> recordID,Id accountID,string serviceType,Id contactId,Id shipToAddrUpdated,String legalAccNum ){
		List<HWS_BulkUpload__c> buList = [Select id,Part_Code_Part_Revision__c,Faulty_Serial_number__c,Fault_Detection__c,Fault_Description__c,Hws_PartCode_PartRevision__c,
										  Fault_Occurrence__c,Fault_detection_Date__c,Failure_Description_Server_ID__c,Customer_Reference_Number__c,
										  Fault_Reported_by_Name__c,Fault_Reported_by_Phone__c,Fault_Reported_by_Email__c,Site_Id__c,HWS_Part_Code__c,
										  HWS_Part_Revision__c,Validation_Message__c,HWS_Service_Contract_Number__c,status__c,HWS_ServiceType__c,HWS_Ship_to_Address__c,HWS_Asset__r.HWS_ContractLineItem__r.CH_CoverageGroup__c,Comments__c, HWS_Bulk_Version_Item__c
										  ,HWS_NEACount__c,HWS_NetworkElementAsset__c,HWS_NetworkElementAssetName__c,Warranty_Verification_Required__c ,HWS_Site_Information__c,NCP_Service_Contract__c
										  from HWS_BulkUpload__c where id in:recordID];
		system.debug('recordID*********===='+recordID);
		List<String> pcprSet = new List<String>();
		List<String> pcprSetRevision = new List<String>();
		List<Id> loopId = new List<Id>();
		List<Id> loopIdValues = new List<Id>();
		List<String> lstPartCode = new List<String>();
		List<String> lstFaultySerialNumber = new List<String>();
		List<String> lstSetRevision = new List<String>();
		Map<String,String> partCodeCmp=new Map<String,String>();
		Map<String,Id> contractShiptoAddrMap = new Map<String,Id>(); 
		Map<Id,String> bulkIdContractNumMap = new Map<Id,String>();
		Set<String> serialNumberTracebleSet = new Set<String>();
		Boolean phoneValidation;
		Boolean phoneValidationFailureCheck = true;   
		List<String> partCodes = new List<String>();
		List<Id> shipToAddrDupCheckList = new List<Id>();
		Map<Id,String> noContrNumberMap = new Map<Id,String>();
		shipToAddrDupCheckList.add(shipToAddrUpdated);
		Map<String,List<Asset>> mapPartCodeAssets = new Map<String,List<Asset>>();
		
		//added for 35931 -- START
		String servicedAccNum = '';
		Boolean isServiceAccount = false;
		HWS_GenericSettings__c record = HWS_GenericSettings__c.getValues('HWS_ServicedAccountNumber');
		servicedAccNum  = (String) record.get('HWS_Field1__c');
		if(servicedAccNum != null && servicedAccNum.contains(legalAccNum)){
			isServiceAccount = true;
		}
		//added for 35931 -- END
		//HWSDDP-144:Suspension – block creation of RES RMA||Start
		List<HWS_Suspension__c>  objsuspensionList=new List<HWS_Suspension__c>();
		List<String>  suspensionList=new List<String>();
		//HWSDDP-144:Suspension – block creation of RES RMA||End
		//NOKIASC-34942
		List<HWS_AlternateProductCode__c> altVersionItemsLst = new List<HWS_AlternateProductCode__c>();
		Id salesProduct = HWS_Utilty.getRecordTypeByName('Product2',HWS_Constants.SALES_PRODUCT);
		Set<String> stapcpartcode = new Set<String>();
		List<String> partCodesRevis = new List<String>();
		set<Id> buAssetIds = new set<Id>();
		if(!buList.isEmpty() && buList.size()>0){
			try{
				for(HWS_BulkUpload__c bu : buList){
					if(bu.HWS_Asset__c != null){
						buAssetIds.add(bu.HWS_Asset__c);
					}
					if((bu.HWS_Part_Code__c != '' && bu.HWS_Part_Code__c != null) && (bu.HWS_Service_Contract_Number__c !='' || 
																					  bu.HWS_Service_Contract_Number__c != null)){
																						  partCodes.add(bu.HWS_Part_Code__c);
																					  }
					//NOKIASC-34942
					if(bu.Part_Code_Part_Revision__c != '' && bu.Part_Code_Part_Revision__c != null){
						partCodesRevis.add(bu.Part_Code_Part_Revision__c);
					}
				}
				// NOKIASC-34942
				if(partCodesRevis.size()>0){
					altVersionItemsLst = [SELECT Id, Name, HWS_AlternateCodeType__c
										  FROM HWS_AlternateProductCode__c 
										  WHERE Name IN :partCodesRevis and HWS_AlternateCodeType__c = 'KIT'];
				}
				if(altVersionItemsLst.size()>0){
					for(HWS_AlternateProductCode__c apc: altVersionItemsLst){
						stapcpartcode.add(apc.Name);
					}
				}
				
				if(partCodes.size()>0){
					
					system.debug('partCodes----' +partCodes);
					mapPartCodeAssets= getContractNumbers(partCodes,accountID,serviceType,contactId);
					system.debug('mapPartCodeAssets----' +mapPartCodeAssets);
					String oldPartCode ='';
					Integer i =0;
					Asset assetRec;
					//HWSDDP-144:Suspension – block creation of RES RMA||Start
					List<String> serviceContractList=new List<String>();				 
					for(String key: mapPartCodeAssets.keySet()){
						assetRec=mapPartCodeAssets.get(key)[0];
						serviceContractList.add(assetRec.HWS_ContractLineItem__r.ServiceContractId);
					}
					objsuspensionList=  HWS_CaseFlow.getSuspensionStatus(contactId,serviceContractList);
					 for(HWS_Suspension__c val: objsuspensionList){
						suspensionList.add(String.valueOf(val.HWS_Service_Contract_Name__c));
					}
					//HWSDDP-144:Suspension – block creation of RES RMA||End
					Map<Id,Asset> buAssetMap = new Map<Id,Asset>();
					if(!buAssetIds.isEmpty()){
						
						buAssetMap = getAssetMap(buAssetIds);
					}		  
					for(HWS_BulkUpload__c bulkUploadRec : buList){
						
						if(mapPartCodeAssets.containsKey(bulkUploadRec.HWS_Part_Code__c) && 
						   mapPartCodeAssets.get(bulkUploadRec.HWS_Part_Code__c).size() == 1){
							   /*
							   if(bulkUploadRec.HWS_Asset__c != null && buAssetMap.containsKey(bulkUploadRec.HWS_Asset__c)){
								   assetRec = buAssetMap.get(bulkUploadRec.HWS_Asset__c);
							   }
							   else{
								   Integer j = mapPartCodeAssets.get(bulkUploadRec.HWS_Part_Code__c).size();
								   if (oldPartCode == '' && j == 1) {
									   assetRec = mapPartCodeAssets.get(bulkUploadRec.HWS_Part_Code__c)[0]; 
								   } else if((oldPartCode == '' || oldPartCode == bulkUploadRec.HWS_Part_Code__c) && j > 1){
									   assetRec = mapPartCodeAssets.get(bulkUploadRec.HWS_Part_Code__c)[i];
									   i++;
								   }
							   }	   
							   oldPartCode = bulkUploadRec.HWS_Part_Code__c;
							   */
								assetRec = mapPartCodeAssets.get(bulkUploadRec.HWS_Part_Code__c)[0];
							   if(assetRec != null) {
								   
								   
								   bulkUploadRec.NCP_Service_Contract__c = assetRec.HWS_ContractLineItem__r.ServiceContractId;
								   bulkUploadRec.Comments__c = assetRec.HWS_ContractLineItem__r.CH_CoverageGroup__c;
								   bulkUploadRec.HWS_PO_Number__c=assetRec.HWS_ContractLineItem__r.HWS_PONumber__c;
								   
								   
								   bulkUploadRec.HWS_Sellable_Product__c = assetRec.Product2Id;
								   bulkUploadRec.HWS_Product_Name__c = assetRec.Product2.Name;
								   bulkUploadRec.HWS_Contract_Line_Item__c = assetRec.HWS_ContractLineItem__c; 
								   bulkUploadRec.HWS_Asset__c = assetRec.Id;	 
								   bulkUploadRec.SLA_Unit__c = assetRec.HWS_ContractLeadTimeUnit__c;
								   bulkUploadRec.SLA_Value__c = assetRec.HWS_ContractLeadTimeDuration__c;
								   bulkUploadRec.SSI_Description__c = assetRec.HWS_ServiceItemDescription__c;
								   bulkUploadRec.HWS_Service_Contract_Number__c = assetRec.HWS_Service_Contract_Number__c;
								   bulkUploadRec.HWS_ServiceType__c=assetRec.HWS_Service_Type__c;
								   
								   
								   if (assetRec.HWS_ContractLineItem__c != null) {
									   bulkUploadRec.Warranty_Verification_Required__c = assetRec.HWS_ContractLineItem__r.HWS_WarrantyVerificationRequired__c;   
								   }
								   
								   i++;
								   
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
							   else if((!mapPartCodeAssets.containsKey(bulkUploadRec.HWS_Part_Code__c)) ||
									   (mapPartCodeAssets.containsKey(bulkUploadRec.HWS_Part_Code__c) && (mapPartCodeAssets.size() <= 1))){
										   noContrNumberMap.put(bulkUploadRec.Id,'No Contract Available ');
									   }
						   }
						
					}
					update buList; 
				}
				for(HWS_BulkUpload__c bu : buList){
					bulkIdContractNumMap.put(bu.Id,bu.HWS_Service_Contract_Number__c);  
					if(bu.HWS_Ship_to_Address__c != null && (!shipToAddrDupCheckList.contains(contractShiptoAddrMap.get(bu.HWS_Service_Contract_Number__c)) || shipToAddrUpdated == null)){   
						contractShiptoAddrMap.put(bu.HWS_Service_Contract_Number__c,bu.HWS_Ship_to_Address__c);   
					}   
				}
				mapPartCodeAssets= getContractNumbers(partCodes,accountID,serviceType,contactId);
				for(HWS_BulkUpload__c bu : buList){
					
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
						} 
					} 
					
					
					//System.debug('mapPartCodeAssets===='+mapPartCodeAssets);
					//NOKIASC-34942
					if(bu.HWS_Part_Code__c == '' || bu.HWS_Part_Code__c == null && phoneValidationFailureCheck == true){
						if(stapcpartcode.size()>0 && stapcpartcode.contains(bu.Part_Code_Part_Revision__c)){
							bu.Validation_Message__c='Bulk case creation is not supported for kit code.';
							bu.Status__c = 'Failed';
						}
						else{
							bu.Validation_Message__c='The part code you have entered is not found. ';
							bu.Status__c = 'Failed';
						}
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
						bu.Validation_Message__c='The part code you have entered is not covered under the service type you have selected .';
						bu.Status__c = 'Failed';
					}
					//HWSDDP-144:Suspension – block creation of RES RMA||Start
					else if(bu.NCP_Service_Contract__c!=null && suspensionList.contains(bu.NCP_Service_Contract__c)){
						bu.Validation_Message__c=System.Label.HWS_MSG_CaseFlow_Suspension;
						bu.Status__c = 'Failed';
					}
					//HWSDDP-144:Suspension – block creation of RES RMA||End
					//Start Changes for 25679
					else  if((bu.HWS_NetworkElementAssetName__c =='' || bu.HWS_NetworkElementAssetName__c == null) && (bu.HWS_NEACount__c > 0) && phoneValidationFailureCheck == true)
					{  
						bu.Validation_Message__c='Please select NEA.';
						bu.Status__c = 'Failed';
					}
					
					//End Changes for 25679updateStatusforMandatoryFields
					
					//Start Changes for 36628
					else if(String.isBlank(bu.Faulty_Serial_number__c) == false && bu.Faulty_Serial_number__c.contains(' ')){
									bu.Validation_Message__c='Space not allowed in the Faulty Unit Serial Number';
									bu.Status__c = 'Failed';
					}
					//End Changes for 36628  
										
					else if((bu.HWS_Service_Contract_Number__c != null || bu.HWS_Service_Contract_Number__c != '') && (bu.HWS_Ship_to_Address__c == null) && !contractShiptoAddrMap.containsKey(bu.HWS_Service_Contract_Number__c) && phoneValidationFailureCheck == true){  
						bu.Validation_Message__c = 'Missing Ship to Address';
						bu.Status__c = 'Failed';			
					} 
					//added for 35931 -- START
					else if(isServiceAccount && bu.HWS_Site_Information__c == null ){
						bu.Validation_Message__c = 'Please Enter Additional Configuration Details';
						bu.Status__c = 'Failed';
					}
					//added for NOKIASC-38963 -- START
					else if(isServiceAccount && bu.Site_Id__c == null){
						bu.Validation_Message__c = 'Please Enter Site Id';
						bu.Status__c = 'Failed';
					}//added for NOKIASC-38963 -- END
					//added for 35931 -- END
					else if((bu.HWS_Part_Code__c !='' && bu.HWS_Part_Code__c!= null) && (bu.HWS_Part_Revision__c!='' && bu.HWS_Part_Revision__c!= null) && phoneValidationFailureCheck == true)
					{
						if(bu.HWS_Part_Revision__c == 'ANY' && bu.Part_Code_Part_Revision__c.contains(bu.HWS_Part_Code__c)){
							pcprSet.add(bu.HWS_Part_Code__c.replaceAll('[^a-zA-Z0-9]', '')+'ANY');
						}
						else{
							pcprSet.add(bu.Hws_PartCode_PartRevision__c);
						}
						loopId.add(bu.id);
					}
					if(contractShiptoAddrMap.containsKey(bu.HWS_Service_Contract_Number__c) && phoneValidationFailureCheck == true){
						bu.HWS_Ship_to_Address__c = contractShiptoAddrMap.get(bu.HWS_Service_Contract_Number__c);
					}
					
				} 
				
				if(!pcprSet.isEmpty()){
					List<hws_versionitem__c> versionDetails= [SELECT Id,HWS_Name__c, HWS_Serial_Number_Traceable__c,HWS_Product_Code__c,HWS_Version_Code__c,HWS_Part_Code_Part_Revision__c FROM hws_versionitem__c WHERE  HWS_Part_Code_Part_Revision__c in :pcprSet];
					for(HWS_VersionItem__c vDet :versionDetails){	  
						if((vDet.HWS_Serial_Number_Traceable__c != null && vDet.HWS_Serial_Number_Traceable__c != '') && (vDet.HWS_Serial_Number_Traceable__c.equalsIgnoreCase('YES')||vDet.HWS_Serial_Number_Traceable__c.equalsIgnoreCase('Y'))){ 
							pcprSetRevision.add(vDet.HWS_Part_Code_Part_Revision__c.toUpperCase());
							serialNumberTracebleSet.add(vDet.HWS_Part_Code_Part_Revision__c.toUpperCase());
						}
						
					}
					for(HWS_BulkUpload__c bu : buList){
						string partVal=bu.Hws_PartCode_PartRevision__c.toUpperCase();
						if(bu.HWS_Part_Revision__c == 'ANY'){
							partVal = bu.HWS_Part_Code__c.replaceAll('[^a-zA-Z0-9]', '').toUpperCase()+'ANY';
						}
						if(loopId.size()>0 && loopId.contains(bu.id)){
							if(pcprSetRevision.Contains(partVal)) {
								If((bu.Faulty_Serial_number__c == ''  || bu.Faulty_Serial_number__c == null) ){
									bu.Validation_Message__c='Faulty Serial Number is Mandatory';
									bu.Status__c = 'Failed';
								}
								
								else {
									if(bu.Faulty_Serial_number__c !='' && bu.Faulty_Serial_number__c != null){
										loopIdValues.add(bu.id); 
										lstPartCode.add(bu.HWS_Part_Code__c);
										lstFaultySerialNumber.add(bu.Faulty_Serial_number__c);
										
									}
								}
								
							}
							else{
								if(bu.Faulty_Serial_number__c !='' && bu.Faulty_Serial_number__c != null){
									loopIdValues.add(bu.id); 
									lstPartCode.add(bu.HWS_Part_Code__c);
									lstFaultySerialNumber.add(bu.Faulty_Serial_number__c);
								}
								
							}
						}
						
						
						
					} 
					
				}
				
				if(loopIdValues.size()>0){
					//NOKIASC-36821 -start setting accId based on retrofit account present or not
					Id accId = accountID;
					if(retrofitAccId != null && retrofitAccId !='')  {
						accId = retrofitAccId;
					}
					List<Case> caselist= 
						[Select id,HWS_Faulty_Serial_Number__c,CaseNumber,Status,HWS_Stockable_Product__r.HWS_Part_Code_Part_Revision__c,HWS_ServiceType__c,Asset.HWS_Part_Code__c 
						 From Case 
						 where (status Not in:childCaseStatusesforDuplicte ) 
						 AND HWS_Faulty_Serial_Number__c in : lstFaultySerialNumber AND HWS_Faulty_Serial_Number__c !=null AND HWS_Faulty_Serial_Number__c !='UNKNOWN'  ];
					for(Case faultCode :caselist){
						if(faultCode.HWS_Faulty_Serial_Number__c !='' && faultCode.HWS_Faulty_Serial_Number__c != null){				
							lstSetRevision.add(faultCode.Asset.HWS_Part_Code__c);	  
							partCodeCmp.put(faultCode.HWS_Faulty_Serial_Number__c.toUpperCase(),faultCode.Asset.HWS_Part_Code__c);
						}
					}
					for(HWS_BulkUpload__c bu : buList){
						string partFault=bu.HWS_Part_Code__c;
						string partVal=bu.Hws_PartCode_PartRevision__c.toUpperCase();
						if(bu.HWS_Part_Revision__c == 'ANY'){
							partVal = bu.HWS_Part_Code__c.replaceAll('[^a-zA-Z0-9]', '').toUpperCase()+'ANY';
						}		  
						if(lstSetRevision.Contains(partFault) && loopIdValues.contains(bu.id) && partCodeCmp.containskey(bu.Faulty_Serial_number__c.toUpperCase())){
							bu.Validation_Message__c='The part code and serial number entered are already part of an open case';
							bu.status__c='Failed';
						}
						//NOKIASC-37158 
						else if (!isshowRetroAccount && bu.Warranty_Verification_Required__c == 'Yes' && (serialNumberTracebleSet.contains(partVal))&& (bu.HWS_ServiceType__c == 'Return for Repair or Replacement' || bu.HWS_ServiceType__c == 'Advanced Exchange in Days' || bu.HWS_ServiceType__c == 'Identical Repair' || bu.HWS_ServiceType__c == 'Spare Part Sales')) {
							
							bu.Validation_Message__c = 'Warranty Verification Required';
							bu.Status__c = 'Pending';   
						}
						else if(bu.Warranty_Verification_Required__c == 'Yes') {
							
							 bu.Warranty_Verification_Required__c = '';   
						}
						
					}
				}
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
							bu.Validation_Message__c='You have entered duplicate entries for part code and faulty serial number combination, please correct the details or remove one of these rows.';
							
						}
					}
					system.debug('bu.Validation_Message__c====='+bu.Validation_Message__c);
					if( bu.Validation_Message__c== '' || bu.Validation_Message__c==null){
						bu.status__c='Success';
					}
				} 
				update buList;
			}
			catch(Exception ex){ system.debug('===Exception=='+ ex);
							   }
		}
		
		return buList;
	}
	@auraEnabled
	public static boolean updateRMAValues(List<SObject> editedRMAList){
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
	public static List<Asset> getAllAssets(Id bulkId, Id accId,String serviceType,Id contactId, Id selectedSC){ 
		if(selectedSC != null)
		selectedSCId = selectedSC;
		return HWS_CreateSupportTicketportal.getAllAssets(bulkId, accId, serviceType, contactId);
	}
	@auraEnabled
	public static List<Asset> getAllAssets(Id bulkId, Id accId,String serviceType,Id contactId){		
		String externalStatus = 'Active';
		String classification='HWS Service';
		Boolean sync = true;
		Boolean enableForPortal = true;
		String bulkUploadPartCode = [select id,HWS_Part_Code__c from HWS_BulkUpload__c where id=:bulkId].HWS_Part_Code__c;
		 //2503 SPS Last Order Date validation started added HWS_Product_SPSLOD__c field
		 //NOKIASC-37150 -Added HWS_PartLEStatus__c in query and filter
		if(bulkUploadPartCode != null && bulkUploadPartCode != ''){
			//NOKIASC-36274:Ship to party selection for Combined Ordering(Added ServiceContract.HWS_Combined_Ordering__c field)
			String assetQuery = 'SELECT Id,HWS_PartLEStatus__c,HWS_ContractLineItem__r.HWS_PONumber__c,HWS_ContractLineItem__r.Asset.Product2.Name,HWS_ContractLineItem__r.CH_ServiceOffering__c,HWS_SourceSystem__c,HWS_Product_SPSLOD__c,HWS_Service_Contract_Number__c,HWS_Currency__c,HWS_Price__c,Contract_Number__c,HWS_ContractLineItem__c,HWS_ContractLineItem__r.ServiceContract.HWS_Currency__c, HWS_ContractLineItem__r.CH_LineItemEntitlementScript__c,HWS_ContractLineItem__r.ServiceContract.CH_EntitlementScript__c,HWS_ContractLineItem__r.ServiceContract.CH_CountryCode__c,HWS_ContractLineItem__r.ServiceContract.CH_CountryName__c,HWS_ContractLineItem__r.ServiceContractId,HWS_ContractLineItem__r.HWS_AdditionalSIInfo1__c,HWS_ContractLeadTimeUnit__c,AccountId,HWS_ContractLeadTimeDuration__c,Product2Id,Product2.Name,ProductCode,'+
				'HWS_ServiceItemCode__c,HWS_ContractLineItem__r.ServiceContract.CH_ERPSystem__c,HWS_ContractLineItem__r.ServiceContract.HWS_Combined_Ordering__c, HWS_Part_Code__c,HWS_Service_Type__c,HWS_Product_Name__c, HWS_ContractLineItem__r.CH_BusinessHour__r.Id,HWS_ServiceItemDescription__c,HWS_High_Level_Product_Name__c,HWS_ContractLineItem__r.CH_CoverageGroup__c,HWS_ContractLineItem__r.CH_QtyCoveredNetworkElementAssets__c FROM Asset WHERE HWS_Part_Code__c =: bulkUploadPartCode AND AccountId =: accId AND (HWS_ContractLineItem__r.ServiceContract.NCP_External_Status__c =: externalStatus) AND (HWS_ContractLineItem__r.ServiceContract.Status =: externalStatus) AND HWS_ContractLineItem__r.CH_ServiceClassification__c=: classification AND HWS_ContractLineItem__r.NCP_External_Status__c=: externalStatus AND HWS_ExternalStatus__c=: externalStatus AND HWS_IsSynced__c =:sync AND HWS_ContractLineItem__r.ServiceContract.CH_PortalCaseCreationHWS__c =: enableForPortal  AND HWS_PartLEStatus__c IN:SETLESTATUS';
			//getting only Authorized serviceContract Records
			//3697 - passing contactId  ****************Start*********
			Map<Id, Set<String>> servContrMap = new Map<Id, Set<String>>();
			if(contactId!=null){
				//NOKIASC-36274:HWS_Combined_Ordering__c field added
				List<EntitlementContact> servContList = [select id, Entitlement.Name, Entitlement.ServiceContract.Name, Entitlement.ServiceContract.Id,Entitlement.ServiceContract.HWS_Combined_Ordering__c, Entitlement.ServiceContract.ContractNumber, Entitlement.Account.Name, Entitlement.AccountId, contact.Name, ContactId from EntitlementContact where ContactId = :contactId];
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
			if(servContrMap.size()>0 && servContrMap.Containskey(accId)){
				
				contrSet = servContrMap.get(accId);
				
			}

			if(selectedSCId != null){
				assetQuery = assetQuery+' AND HWS_ContractLineItem__r.ServiceContract.Id=: selectedSCId AND HWS_ContractLineItem__r.CH_ServiceItemDescription__c LIKE \'%Retrofit%\'';
				//assetQuery = assetQuery+' AND Contract_Number__c IN: contrSet';
			}
			else{
				if(contrSet.size()>0){
					assetQuery = assetQuery+' AND Contract_Number__c IN: contrSet';
				}
			}
			
			//******************************End*********
			if(serviceType != null && serviceType !=''){
				assetQuery = assetQuery+' AND HWS_Service_Type__c=: serviceType';
			}
			System.debug('assetQuery--123'+assetQuery);
		   list<Asset> listAssets = database.query(assetQuery); 
			return listAssets;
		}
		else {
			return null;
		}
	}
	
	@auraEnabled
	public static void updateServiceContractValues(Asset selectedAsset, Id bulkRecId){   
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
		bulkUploadRec.HWS_PO_Number__c=selectedAsset.HWS_ContractLineItem__r.HWS_PONumber__c;
		//Start Changes for 25679
		Decimal getNEACount=selectedAsset.HWS_ContractLineItem__r.CH_QtyCoveredNetworkElementAssets__c!=Null?selectedAsset.HWS_ContractLineItem__r.CH_QtyCoveredNetworkElementAssets__c:null;
		bulkUploadRec.HWS_NEACount__c=getNEACount;
		//NOKIASC-34707 | Start
		List<Asset> lstAsset = [select id,HWS_ContractLineItem__c,HWS_ContractLineItem__r.HWS_WarrantyVerificationRequired__c FROM  Asset where id=:selectedAsset.Id ]; // Doing a query because HWS_WarrantyVerificationRequired__c is not in the selectedAsset
		if (lstAsset.size()>0 && lstAsset[0].HWS_ContractLineItem__c != null) {
			bulkUploadRec.Warranty_Verification_Required__c = lstAsset[0].HWS_ContractLineItem__r.HWS_WarrantyVerificationRequired__c;   
		}
		//NOKIASC-34707 | End
		if(getNEACount!= null && getNEACount ==1 && selectedAsset.HWS_Service_Contract_Number__c!=''){
			List<Asset> getNEAAssetRec =   getNetworkElementAsset(selectedAsset.HWS_ContractLineItem__r.Id,true);
			if(getNEAAssetRec.size()>0){
				bulkUploadRec.HWS_NetworkElementAsset__c=getNEAAssetRec[0].Id;
				bulkUploadRec.HWS_NetworkElementAssetName__c=getNEAAssetRec[0].Name;
			}
		}
		//End Changes for 25679
		update bulkUploadRec;
	}
	
	@auraEnabled
	public static List<String> bulkUploadServiceTypes(Id accountId){
		Set<String> nonDuplicateSrcTypeSet = new Set<String>();
		List<String> bulkRMAServiceTypesLst = new List<String>{'Advanced Exchange in Days', 'Return for Repair or Replacement', HWS_Constants.IR};
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
 //NOKIASC-37921 | Start
	@AuraEnabled
	  public static List<string> insertBulkRMACaseData(List<HWS_BulkUpload__c> buList, Id accountId, Id contactId, 
															Case parentCaseShipmentInfo, String serviceType, 
															String contactTimeZone, Boolean isPending, string Actiontype){
		List<string> returnMe = new List<string>();
		
		if(buList.isEmpty()){
			throw new AuraHandledException('Please add any value to insert');
		}																   
		else{

			// Add all local variables | Start
			Set<String> serviceContractSet = new Set<String>();
			Map<String, String> bulkIdCountryMap = new Map<String, String>();
			Map<String, String> contractShiptoPrtyMap = new Map<String, String>();
			Map<String, String> ContractlinePOMap =new Map<String, String>();
			Map<String, String> ContractServiceContractIdMap =new Map<String, String>();
			Map<Id, Account> ShipPrtyIdToShipPartyMap = new Map<Id, Account>();
			Map<string, id> casetoContractNumber = new Map<String, id>();
			List<Case> parentCaseToInsertLst = new List<Case>();
			List<string> lststr = new List<String>();
			Set<Id> shipToPartyIds = new Set<Id>();
			Set<String> contractIdSet = new Set<String>();
			 // Add all local variables | End
			String ReferenceNumber = '';
			for(HWS_BulkUpload__c bu : buList){
				if(bu.HWS_Service_Contract_Number__c != null && bu.HWS_Ship_to_Address__c != null && (bu.Warranty_Verification_Required__c != 'Yes' && isPending ||  (bu.Warranty_Verification_Required__c == 'Yes' && !isPending))){
					serviceContractSet.add(bu.HWS_Service_Contract_Number__c);
					bulkIdCountryMap.put(bu.HWS_Service_Contract_Number__c,bu.HWS_Asset__r.HWS_ContractLineItem__r.CH_CountryISOName__c);
					contractShiptoPrtyMap.put(bu.HWS_Service_Contract_Number__c, bu.HWS_Ship_to_Address__c+'HWS'+(bu.Customer_Reference_Number__c == null?'':bu.Customer_Reference_Number__c));
					ContractlinePOMap.put(bu.HWS_Service_Contract_Number__c,bu.HWS_PO_Number__c);
					ContractServiceContractIdMap.put(bu.HWS_Service_Contract_Number__c,bu.NCP_Service_Contract__c);
					shipToPartyIds.add(bu.HWS_Ship_to_Address__c);
					if (bu.NCP_Service_Contract__c != null) {
							contractIdSet.add(bu.NCP_Service_Contract__c);  
					} 
					bu.HWS_Job_Update__c = 'Queued';
					String chars = '0123456789';					
					while (ReferenceNumber.length() < 15) {
					Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
					ReferenceNumber += chars.substring(idx, idx+1);
					}
					bu.HWS_Bulk_Reference_Number__c = ReferenceNumber;
					if(returnMe.size()==0)
					   returnMe.add(ReferenceNumber);
				}
				else
					throw new AuraHandledException('Check the data');
			}
			if(!serviceContractSet.isEmpty() && serviceContractSet != null && accountId != null && ContactId != null){
				try{
					Map<String, String> serviceContractIdWithRetrtTypeMap = new Map<String, String>();
					for (servicecontract sc : [SELECT CH_SAP_ContractNumber__c, HWS_Retrofit_Type__c FROM servicecontract WHERE CH_SAP_ContractNumber__c IN :serviceContractSet]) {
						serviceContractIdWithRetrtTypeMap.put(String.valueof(sc.CH_SAP_ContractNumber__c), sc.HWS_Retrofit_Type__c);	
					}
					List<Account> shipToPartyAddress = [SELECT Id,Name,Hws_Address_Line_1__c,Hws_Address_Line_2__c,Hws_Address_Line_3__c,BillingCity, BillingPostalcode,Region__c,BillingState,BillingCountry FROM Account WHERE Id =:shipToPartyIds ];
					for(Account shiTo:shipToPartyAddress){
						ShipPrtyIdToShipPartyMap.put(shiTo.Id,shiTo);
					}
					for(String contractNumber : serviceContractSet){
						Case parentCase = new Case();
						parentCase.RecordTypeId = parentCaseRecordType;
						parentCase.ContactId = contactId;
						parentCase.AccountId = accountId;
						parentCase.Country__c = bulkIdCountryMap.get(contractNumber);
						parentCase.Hws_Ship_to_Party_Address__c = contractShiptoPrtyMap.get(contractNumber).substringBefore('HWS');
						lststr.add(contractShiptoPrtyMap.get(contractNumber).substringBefore('HWS'));
						parentCase.HWS_Shipment_Recipient_Name__c = parentCaseShipmentInfo.HWS_Shipment_Recipient_Name__c;
						parentCase.HWS_ShipmentRecipientEmailId__c = parentCaseShipmentInfo.HWS_ShipmentRecipientEmailId__c;
						parentCase.HWS_Shipment_Recipient_Phone__c = parentCaseShipmentInfo.HWS_Shipment_Recipient_Phone__c;
						parentCase.HWS_Contract_Number__c = contractNumber;
						parentCase.HWS_Customer_PO__c=ContractlinePOMap.get(contractNumber);
						parentCase.NCP_Service_Contract__c = ContractServiceContractIdMap.get(contractNumber);
						if(Actiontype != 'Submit') 
							parentCase.CH_InternalStatus__c = 'Under Review'; 
						boolean isValidPortalUser = HWS_WarrantyQuotation_Controller.isPortalUser();
						if(isValidPortalUser){
							parentCase.Origin = 'Web-Bulk';
						}
						else
							parentCase.Origin = 'Console-Bulk';
						if (!serviceContractIdWithRetrtTypeMap.isEmpty() && (serviceContractIdWithRetrtTypeMap.get(contractNumber) == 'Global Retrofit' || 
							serviceContractIdWithRetrtTypeMap.get(contractNumber) == 'Local Retrofit')) {
								parentCase.CH_ServiceType__c='Internal Support';
							
						}						   
						if(ShipPrtyIdToShipPartyMap.get(parentCase.Hws_Ship_to_Party_Address__c)!= null){
							Account shipToAddress = ShipPrtyIdToShipPartyMap.get(parentCase.Hws_Ship_to_Party_Address__c);
							parentCase.HWS_Address_Name__c  = shipToAddress.Name;
							parentCase.Street_Address_1__c  = shipToAddress.Hws_Address_Line_1__c;
							parentCase.Street_Address_2__c  = shipToAddress.Hws_Address_Line_2__c;
							parentCase.Street_Address_3__c  = shipToAddress.Hws_Address_Line_3__c;
							parentCase.City__c   = shipToAddress.BillingCity;
							parentCase.POSTAL_CODE_CHQ__c   = shipToAddress.BillingPostalcode;
							parentCase.HWS_Region__c	 = shipToAddress.Region__c;
							parentCase.State__c = shipToAddress.BillingState;
							parentCase.Country__c   = shipToAddress.BillingCountry;
						}
						parentCaseToInsertLst.add(parentCase);
					}
					if(lststr.size()>0){						
						 HWS_Utilty.accountToShare(lststr);
					}
					database.insert(parentCaseToInsertLst, true);
					List<HWS_BulkUpload__c>tempBU = new  List<HWS_BulkUpload__c>();
					for(Case c : parentCaseToInsertLst){
						casetoContractNumber.put(c.HWS_Contract_Number__c, c.id);
					}
					for(HWS_BulkUpload__c bu :buList){
						if(casetoContractNumber.get(bu.HWS_Service_Contract_Number__c) != null){
							bu.Support_Ticket__c = casetoContractNumber.get(bu.HWS_Service_Contract_Number__c);
							tempBU.add(bu);
						}					   
					}
					database.update(tempBU, true); 
				   
					Datetime dt = Datetime.now()+0.000344; // to add 1 sec delay
					String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
					HWS_BulkUploadScheduler run = new HWS_BulkUploadScheduler(ReferenceNumber, Actiontype, serviceType,isPending,accountId,contactId); 
					System.schedule('HWS_BulkUploadScheduler - '+timeForScheduler, timeForScheduler, run);
				   
				   
				}
				catch(Exception e){				 
					throw new AuraHandledException(e.getMessage());
				}
			}   
		}
		return returnMe;
	}
   
	//NOKIASC-37921 | End   
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
	public static accountListCaseWrapper createBulkRMACase(List<HWS_BulkUpload__c> buList, Id accountId, Id contactId, 
														   Case parentCaseShipmentInfo, String serviceType, 
														   String contactTimeZone, Boolean isPending) {
															   Set<String> serviceContractSet = new Set<String>();
															   Set<String> pcprSet = new Set<String>();
															   List<String> parentCaseNumbersLst = new List<String>();
															   List<Case> zoneCaseList = new List<Case>();
															   accountListCaseWrapper returnValueWrapper;		  
															   Map<String, String> contractShiptoPrtyMap = new Map<String, String>();
															   Map<String, String> bulkIdCountryMap = new Map<String, String>();
															   Map<String, String> ContractlinePOMap =new Map<String, String>();
															   Set<Id> getProductBulkId=new Set<Id>();
															   Set<Id> shipToPartyIds = new Set<Id>();
															   Map<Id, Account> ShipPrtyIdToShipPartyMap = new Map<Id, Account>();
															   Map<String, String> ContractServiceContractIdMap =new Map<String, String>();//NOKIASC-34876
															   Savepoint sp = Database.setSavepoint();
															   if(!buList.isEmpty()){
																   system.debug('buList==='+buList);
																   for(HWS_BulkUpload__c bu : buList){
																	   system.debug('bu.Warranty_Verification_Required__c====='+bu.Warranty_Verification_Required__c); 
																	   if(bu.HWS_Service_Contract_Number__c != null && bu.HWS_Ship_to_Address__c != null && (bu.Warranty_Verification_Required__c != 'Yes' && isPending || 
																																							 (bu.Warranty_Verification_Required__c == 'Yes' && !isPending))){
																																								 serviceContractSet.add(bu.HWS_Service_Contract_Number__c);
																																								 getProductBulkId.add(bu.HWS_Asset__r.Product2.Id);
																																								 system.debug('Product id is :  '+ bu.HWS_Asset__r.Product2.Id);
																																								 bulkIdCountryMap.put(bu.HWS_Service_Contract_Number__c,bu.HWS_Asset__r.HWS_ContractLineItem__r.CH_CountryISOName__c);
																																								 ContractlinePOMap.put(bu.HWS_Service_Contract_Number__c,bu.HWS_PO_Number__c);
																																								 system.debug('Contractline Service Contract: PO Number'+ bu.HWS_PO_Number__c);
																																								 contractShiptoPrtyMap.put(bu.HWS_Service_Contract_Number__c, bu.HWS_Ship_to_Address__c+'HWS'+(bu.Customer_Reference_Number__c == null?'':bu.Customer_Reference_Number__c));
																																								 ContractServiceContractIdMap.put(bu.HWS_Service_Contract_Number__c,bu.NCP_Service_Contract__c);
																																								 shipToPartyIds.add(bu.HWS_Ship_to_Address__c);
																																							 }
																	   pcprSet.add(bu.Part_Code_Part_Revision__c.replaceAll('[^a-zA-Z0-9]', ''));
																   }
																   if(!serviceContractSet.isEmpty() && !contractShiptoPrtyMap.isEmpty() && serviceContractSet != null && accountId != null && ContactId != null){
																	   Id parentCaseRecordTypeId = parentCaseRecordType;
																	   Map<String, String> serviceContractIdWithRetrtTypeMap = new Map<String, String>();
																	   for (servicecontract sc : [SELECT CH_SAP_ContractNumber__c, HWS_Retrofit_Type__c FROM servicecontract WHERE CH_SAP_ContractNumber__c IN :serviceContractSet]) {
																			serviceContractIdWithRetrtTypeMap.put(String.valueof(sc.CH_SAP_ContractNumber__c), sc.HWS_Retrofit_Type__c);	
																	   }
																	   List<Case> parentCaseToInsertLst = new List<Case>();
																	   List<string> lststr = new List<String>();
																	   try {
																		   //NOKIASC- 32497 STARTS
																		   List<Account> shipToPartyAddress = [SELECT Id,Name,Hws_Address_Line_1__c,Hws_Address_Line_2__c,Hws_Address_Line_3__c,BillingCity,
																											   BillingPostalcode,Region__c,BillingState,BillingCountry FROM Account WHERE Id =:shipToPartyIds ];
																		   for(Account shiTo:shipToPartyAddress){
																			   ShipPrtyIdToShipPartyMap.put(shiTo.Id,shiTo);
																		   }
																		   //NOKIASC- 32497 ENDS
																		   for(String contractNumber : serviceContractSet){
																			   Case parentCase = new Case();
																			   parentCase.RecordTypeId = parentCaseRecordTypeId;
																			   parentCase.ContactId = contactId;
																			   parentCase.AccountId = accountId;
																			   parentCase.Country__c = bulkIdCountryMap.get(contractNumber);
																			   parentCase.Hws_Ship_to_Party_Address__c = contractShiptoPrtyMap.get(contractNumber).substringBefore('HWS');
																			   lststr.add(contractShiptoPrtyMap.get(contractNumber).substringBefore('HWS'));		
																			   parentCase.HWS_Shipment_Recipient_Name__c = parentCaseShipmentInfo.HWS_Shipment_Recipient_Name__c;
																			   parentCase.HWS_ShipmentRecipientEmailId__c = parentCaseShipmentInfo.HWS_ShipmentRecipientEmailId__c;
																			   parentCase.HWS_Shipment_Recipient_Phone__c = parentCaseShipmentInfo.HWS_Shipment_Recipient_Phone__c;
																			   parentCase.HWS_Contract_Number__c = contractNumber;
																			   parentCase.HWS_Customer_PO__c=ContractlinePOMap.get(contractNumber);
																			   parentCase.NCP_Service_Contract__c = ContractServiceContractIdMap.get(contractNumber);
																			   //added for BUG NOKIASC-37188
																			   parentCase.CH_InternalStatus__c = 'Under Review'; //NOKIASC-36061
																			   parentCase.Origin = 'Web-Bulk'; //added for NOKIASC-36687
																			   if (!serviceContractIdWithRetrtTypeMap.isEmpty() && (serviceContractIdWithRetrtTypeMap.get(contractNumber) == 'Global Retrofit' || 
																				   serviceContractIdWithRetrtTypeMap.get(contractNumber) == 'Local Retrofit')) {
																					   parentCase.CH_ServiceType__c='Internal Support';
																				   
																			   }
																			   //NOKIASC- 32497 STARTS
																			   if(ShipPrtyIdToShipPartyMap.get(parentCase.Hws_Ship_to_Party_Address__c)!= null){
																				   Account shipToAddress = ShipPrtyIdToShipPartyMap.get(parentCase.Hws_Ship_to_Party_Address__c);
																				   parentCase.HWS_Address_Name__c  = shipToAddress.Name;
																				   parentCase.Street_Address_1__c  = shipToAddress.Hws_Address_Line_1__c;
																				   parentCase.Street_Address_2__c  = shipToAddress.Hws_Address_Line_2__c;
																				   parentCase.Street_Address_3__c  = shipToAddress.Hws_Address_Line_3__c;
																				   parentCase.City__c   = shipToAddress.BillingCity;
																				   parentCase.POSTAL_CODE_CHQ__c   = shipToAddress.BillingPostalcode;
																				   parentCase.HWS_Region__c  = shipToAddress.Region__c;
																				   parentCase.State__c = shipToAddress.BillingState;
																				   parentCase.Country__c	= shipToAddress.BillingCountry;
																			   }
																			   //NOKIASC- 32497 ENDS
																			   
																			   parentCaseToInsertLst.add(parentCase);
																		   }
																		   if(lststr.size()>0){
																			   //32414	
																			   HWS_Utilty.accountToShare(lststr);
																		   }
																		   try{
																			   database.insert(parentCaseToInsertLst, true);
																		   }
																		   catch (exception e){
																			   system.debug('exception' + e +'line No '+e.getLineNumber());
																		   }
																		   
																		   Map<String, Case> contractNumCaseIdMap = new Map<String, Case>();
																		   for(Case c : [SELECT Id,CaseNumber,HWS_Contract_Number__c,CH_GWC_SecurityGroup__c,CH_SecurityGroup__c,Hws_Ship_to_Party_Address__c,HWS_ShipmentRecipientEmailId__c,HWS_Shipment_Recipient_Name__c,Hws_Ship_to_Party_Address__r.BillingStreet,Hws_Ship_to_Party_Address__r.BillingCity,Hws_Ship_to_Party_Address__r.BillingState,Hws_Ship_to_Party_Address__r.BillingPostalCode,Hws_Ship_to_Party_Address__r.BillingCountry FROM Case WHERE Id IN :parentCaseToInsertLst]){
																			   //HWST-4046 
																			   c.CH_CIRCount__c = 0;
																			   contractNumCaseIdMap.put(c.HWS_Contract_Number__c, c);
																			   parentCaseNumbersLst.add(c.CaseNumber);
																			   
																		   }
																		   List<Case> childCaseToInsert = new List<Case>();
																		   Id childCaseRecordTypeId;
																		   if(serviceType == 'Advanced Exchange in Days'){ 
																			   childCaseRecordTypeId = exchangeInDays;
																		   } else if(serviceType == HWS_Constants.IR || serviceType == 'Return for Repair or Replacement'){
																			   childCaseRecordTypeId = rfr;
																		   }
																		   Set<String> contractIdSet = new Set<String>();
																		   for (HWS_BulkUpload__c bu : buList) {
																				if (bu.NCP_Service_Contract__c != null) {
																					contractIdSet.add(bu.NCP_Service_Contract__c);  
																				}   
																		   }
																		   Map<String, String> tempserviceContractIdWithRetrtTypeMap = new Map<String, String>();
																		   if (contractIdSet.size() > 0) {
																			   for (servicecontract sc : [SELECT Id, HWS_Retrofit_Type__c FROM servicecontract WHERE Id IN :contractIdSet]) {
																				   tempserviceContractIdWithRetrtTypeMap.put(String.valueof(sc.Id), sc.HWS_Retrofit_Type__c);   
																			   }	
																		   }
																		   
																		   for(HWS_BulkUpload__c bu : buList){
																			   if ((bu.Warranty_Verification_Required__c != 'Yes' && isPending || (bu.Warranty_Verification_Required__c == 'Yes' && !isPending))) {
																				   Case childCase = new Case();
																				   //vkt HWST_4187  
																				   if(bu.HWS_Part_Revision__c == 'ANY'){	 
																					   childCase.HWS_Customer_Part_Revision__c = (bu.Part_Code_Part_Revision__c.remove(bu.HWS_Part_Code__c));  
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
																				   c.CH_CIRCount__c += 1;		
																				   childCase.ParentId = c.Id;
																				   childCaseCount.put(c.Id, integer.valueof(c.CH_CIRCount__c)); // NOKIASC-37920 | Bulk Upload Optimization
																				   childCase.HWS_Parent_case_Number__c = c.CaseNumber;
																				   //Ends - HWST-4046 
																				   childCase.NCP_Service_Contract__c = bu.NCP_Service_Contract__c;
																				   childCase.AccountId = accountId;
																				   childCase.ContactId = contactId;
																				   childCase.CH_GWC_SecurityGroup__c = c.CH_GWC_SecurityGroup__c;  
																				   childCase.CH_SecurityGroup__c	= c.CH_SecurityGroup__c;
																				   //Start Changes for 25679
																				   if(bu.HWS_NetworkElementAsset__c !=null){
																					   childCase.CH_NetworkElementAsset__c=bu.HWS_NetworkElementAsset__c;
																				   }
																				   if (!tempserviceContractIdWithRetrtTypeMap.isEmpty() && (tempserviceContractIdWithRetrtTypeMap.get(bu.NCP_Service_Contract__c) == 'Global Retrofit' || 
																				   tempserviceContractIdWithRetrtTypeMap.get(bu.NCP_Service_Contract__c) == 'Local Retrofit')) {
																					   childCase.CH_ServiceType__c='Internal Support';
																				   
																					}
																				   //End Changes for 25679
																				   childCase.AssetId = bu.HWS_Asset__c;
																				   
																				   childCase.HWS_Part_Code__c = bu.HWS_Part_Code__c;
																				   //Added for single email
																				   childCase.Hws_Ship_to_Party_Address__c = c.Hws_Ship_to_Party_Address__c;
																				   childCase.HWS_ShipmentRecipientEmailId__c = c.HWS_ShipmentRecipientEmailId__c;
																				   childCase.HWS_Shipment_Recipient_Name__c = c.HWS_Shipment_Recipient_Name__c;	  
																				   childCase.Comment__c = (c.HWS_Shipment_Recipient_Name__c==null ? ' ' :c.HWS_Shipment_Recipient_Name__c+',\n')+
																					   (c.Hws_Ship_to_Party_Address__r.BillingStreet==null ? ' ' :c.Hws_Ship_to_Party_Address__r.BillingStreet+'\n')+
																					   (c.Hws_Ship_to_Party_Address__r.BillingCity==null ? ' ' :c.Hws_Ship_to_Party_Address__r.BillingCity+',\n')+
																					   (c.Hws_Ship_to_Party_Address__r.BillingState==null ? ' ' :c.Hws_Ship_to_Party_Address__r.BillingState+',\n')+
																					   (c.Hws_Ship_to_Party_Address__r.BillingCountry==null ? ' ' :c.Hws_Ship_to_Party_Address__r.BillingCountry+',\n')+
																					   (c.Hws_Ship_to_Party_Address__r.BillingPostalCode==null ? ' ' :c.Hws_Ship_to_Party_Address__r.BillingPostalCode+'.');
																				   childCase.HWS_Customer_Reference_Number__c = bu.Customer_Reference_Number__c;
																				   childCase.HWS_ServiceType__c = serviceType;
																				   childCase.HWS_Part_Code__c = bu.HWS_Part_Code__c;
																				   childCase.HWS_Stockable_Product__c = bu.HWS_Bulk_Version_Item__c;
																				   childCase.HWS_Sellable_Product__c = bu.HWS_Sellable_Product__c;	 
																				   childCase.HWS_Failure_Description__c = bu.Fault_Description__c;
																				   childCase.HWS_Failure_Detection__c = bu.Fault_Detection__c;
																				   childCase.HWS_Failure_Detection_Date__c = bu.Fault_Detection_Date__c;
																				   childCase.HWS_Failure_Occurance__c = bu.Fault_Occurrence__c;
																				   childCase.HWS_Faulty_Serial_Number__c = bu.Faulty_Serial_number__c;
																				   childCase.HWS_Fault_Reported_By_Name__c = bu.Fault_Reported_by_Name__c;
																				   childCase.HWS_Fault_Reported_By_Email__c = bu.Fault_Reported_by_Email__c;
																				   childCase.HWS_Fault_Reported_By_Phone__c = bu.Fault_Reported_by_Phone__c;
																				   childCase.HWS_Site_ID__c = bu.Site_Id__c;
																				   childCase.HWS_Site_Information__c = bu.HWS_Site_Information__c;
																				   childCase.HWS_Failure_Description_Server_ID__c = bu.Failure_Description_Server_ID__c;
																				   //HWST-4039 added HWS_Contract_Line_Item__c value
																				   childCase.HWS_Contract_Line_Item__c = bu.HWS_Asset__r.HWS_ContractLineItem__r.Id;
																				   //NOKIASC-32497 STARTS
																				   childCase.NCP_Product_Name__c = bu.HWS_Asset__r.HWS_ContractLineItem__r.Asset.Product2.Name;
																				   childCase.HWS_Part_Name__c = bu.HWS_Asset__r.Product2.Name;
																				   childCase.HWS_Service_Offering__c = bu.HWS_Asset__r.HWS_ContractLineItem__r.CH_ServiceOffering__c;
																				   //NOKIASC-34637
																				   if(childCase.CH_EntitlementException__c == 'Warranty Status Check Failed'){
																					   childCase.HWS_WarrantyStatus__c = 'Warranty Unknown';
																				   }
																				   ////NOKIASC-32497 ENDS
																				   //35978
																				   else if(isPending){
																					   childCase.HWS_WarrantyStatus__c = 'Not Applicable';
																					   childCase.CH_EntitlementException__c = 'No Exception';
																					   childCase.CH_EntitlementStatus__c = 'Entitled (Automated Verification)';
																					   
																				   }
																				   childCaseToInsert.add(childCase);	
																			   }
																			   
																		   }
																		   zoneCaseList = timeZoneUpdateCaseList(childCaseToInsert);
																		   database.insert(zoneCaseList, true);
																		  // database.update(contractNumCaseIdMap.values(), true); // NOKIASC-37920 | Commented this | Bulk Upload Optimization
																		   returnValueWrapper = new accountListCaseWrapper(zoneCaseList,parentCaseNumbersLst, 'NoError');
																	   } catch(DMLException de){	  
																		   Database.RollBack(sp);
																		   parentCaseNumbersLst.clear();
														   parentCaseNumbersLst.add(de.getMessage());
																		   returnValueWrapper = new accountListCaseWrapper(zoneCaseList, parentCaseNumbersLst,'DMLError' );
																		   System.debug(LoggingLevel.DEBUG,'Error while creating Case: '+de.getStackTraceString());
																	   } catch(Exception e) {   
																		   Database.RollBack(sp);
																		   parentCaseNumbersLst.clear();
																		   parentCaseNumbersLst.add(e.getMessage());
																		   System.debug(LoggingLevel.DEBUG,'Exception caught: ' + e.getMessage());
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
		HWS_SendServiceRequesttoSOO_SVC.processResponse pr= HWS_SendServiceRequesttoSOO_SVC.sendToSOO(parentCaseId,null);
		Case parentCase = new Case(id=parentCaseId);
		List<Case> childCases;
		List<Entitlement> entitlementLst = new List<Entitlement>();
		Set<Id> cliIdSet = new Set<Id>();
		Map<Id, Id> cliIdEntilmentIdMap = new Map<Id, Id>();
		List<Case> listNewCases = New List<Case>();
		
		if(!pr.isError){
			parentCase.HWS_Sent_To_SOO__c =true;
			parentCase.HWS_SOO_Reference_Number__c =pr.SOORequestID;
			parentCase.RecordTypeId = parentCaseReadOnlyRType;
			parentCase.HWS_Case_Ordered_Date__c=System.now();
			/* Added HWS_Case_Ordered_Date__c in the query for user story 2997*/
			childCases = [select Id, Status,HWS_Communication_Contact__c, RecordTypeId, HWS_ServiceType__c,HWS_Case_Ordered_Date__c,AssetId, HWS_FaultyUnitReceivedDate__c, HWS_Contract_Line_Item__c, HWS_Contract_Line_Item__r.CH_BusinessHour__c from Case where ParentId =: parentCaseId AND Status!='Cancelled'];
			if(!childCases.isEmpty()){
				for(Case childCase : childCases){
					cliIdSet.add(childCase.HWS_Contract_Line_Item__c);
				}
			}
			if(!cliIdSet.isEmpty()){
				entitlementLst = [SELECT Id, Name, AssetId, ContractLineItemId 
								  FROM Entitlement 
								  WHERE RecordtypeId = :hwsEntitlementRecordtypeId AND ContractLineItemId IN :cliIdSet
								  AND ContractLineItem.Status = 'Active']; 
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
					}
					if(childCase.RecordTypeId == spsCaseRecordType){
						childCase.RecordTypeId = spsReadOnlyCaseRecordType;
						if(!cliIdEntilmentIdMap.isEmpty()){
							childCase.EntitlementId = cliIdEntilmentIdMap.get(childCase.HWS_Contract_Line_Item__c);
						}
					}
					listNewCases.add(childCase);
					
				}
			}
		}
		else{
			parentCase.HWS_Is_Error__c  =true;
			
		}
		listNewCases.add(parentCase);   
		return listNewCases;
	}
	
	@auraEnabled
	public static Boolean updateStatusforMandatoryFields(List<HWS_BulkUpload__c> bulkRMAList){   
		List<HWS_BulkUpload__c> bulkList = new List<HWS_BulkUpload__c>();
		for(HWS_BulkUpload__c bu : bulkRMAList){			
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
	public static List<HWS_Lookup_Class.untitleSObject> selectShipToAddress(Id accountId, String erp, String searchKey, String countryName){
		//NOKIASC-35960
		//Added as a part of local language Search
		String NameRegex = '^[A-Za-z]+$';
		Pattern MyPattern = Pattern.compile(NameRegex);
		Matcher MyMatcher = MyPattern.matcher(searchKey.trim());
		Boolean isEnglish = MyMatcher.matches();
		string searchValue = '%' +searchKey+ '%';
		//NOKIASC-36274:Ship to party selection for Combined Ordering
		if(erp!='Both' && erp !=null && erp !='' && erp != 'P20'){
			erp = 'eSpares';
		}
		Id logisticEntityExisting = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LOGISTIC_ACCOUNT_EXISTING);
		List<Account> accList =new List<Account>();
		if (isEnglish) {
			string soql = '';
			if (String.isNotBlank(CountryName)) {
				soql = 'Select Id,Name,Hws_Address_Line_1__c,Hws_Address_Line_2__c,Hws_Address_Line_3__c,HWS_AddressLineLocal1__c, HWS_AddressLineLocal2__c, HWS_AddressLineLocal3__c, Legal_Name_Ext__c, BillingCity,BillingState,BillingCountry,BillingStreet,BillingPostalCode,ShippingCountry,ShippingCity,ShippingPostalCode,ShippingStreet,ShippingState from Account where ParentId =:accountId AND RecordTypeId =: logisticEntityExisting AND AccountSource =: erp AND (Name like :searchValue OR BillingCountry like :searchValue OR BillingCity like :searchValue OR BillingPostalCode like :searchValue OR BillingStreet like :searchValue OR BillingState like :searchValue) AND BillingCountry =:CountryName';
			}else{
				soql ='Select Id,Name,Hws_Address_Line_1__c,Hws_Address_Line_2__c,Hws_Address_Line_3__c,HWS_AddressLineLocal1__c, HWS_AddressLineLocal2__c, HWS_AddressLineLocal3__c, Legal_Name_Ext__c, BillingCity,BillingState,BillingCountry,BillingStreet,BillingPostalCode,ShippingCountry,ShippingCity,ShippingPostalCode,ShippingStreet,ShippingState from Account where ParentId =:accountId AND RecordTypeId =: logisticEntityExisting AND AccountSource =: erp AND (Name like :searchValue OR BillingCountry like :searchValue OR BillingCity like :searchValue OR BillingPostalCode like :searchValue OR BillingStreet like :searchValue OR BillingState like :searchValue)';
			}
			accList = database.query(soql);
		} else {
			string soql='';
			if (String.isNotBlank(CountryName)) {
				soql= 'Select Id,Name,Hws_Address_Line_1__c,Hws_Address_Line_2__c,Hws_Address_Line_3__c,HWS_AddressLineLocal1__c, HWS_AddressLineLocal2__c, HWS_AddressLineLocal3__c, Legal_Name_Ext__c, BillingCity,BillingState,BillingCountry,BillingStreet,BillingPostalCode,ShippingCountry,ShippingCity,ShippingPostalCode,ShippingStreet,ShippingState from Account where ParentId =:accountId AND RecordTypeId =: logisticEntityExisting AND AccountSource =: erp AND (Name like :searchValue OR ShippingCountry like :searchValue OR ShippingCity like :searchValue OR ShippingPostalCode like :searchValue OR ShippingStreet like :searchValue OR ShippingState like :searchValue) AND ShippingCountry=:CountryName';
			}
			else{
				soql= 'Select Id,Name,Hws_Address_Line_1__c,Hws_Address_Line_2__c,Hws_Address_Line_3__c,HWS_AddressLineLocal1__c, HWS_AddressLineLocal2__c, HWS_AddressLineLocal3__c, Legal_Name_Ext__c, BillingCity,BillingState,BillingCountry,BillingStreet,BillingPostalCode,ShippingCountry,ShippingCity,ShippingPostalCode,ShippingStreet,ShippingState from Account where ParentId =:accountId AND RecordTypeId =: logisticEntityExisting AND AccountSource =: erp AND (Name like :searchValue OR ShippingCountry like :searchValue OR ShippingCity like :searchValue OR ShippingPostalCode like :searchValue OR ShippingStreet like :searchValue OR ShippingState like :searchValue)';
			}
			accList = database.query(soql);
		}
		List<HWS_Lookup_Class.untitleSObject> workingList= new List<HWS_Lookup_Class.untitleSObject>();
		if(accList.size()>0){
			for (SObject so : accList) {
				HWS_Lookup_Class.untitleSObject workObj = new HWS_Lookup_Class.untitleSObject();
				/* commented by Pilot
				workObj.currentworkingTitleId = (Id)so.get('Id');
				workObj.currentworkingTitleName = (String)so.get('Name');
				workObj.addressLineLocal1 = (String)so.get('HWS_AddressLineLocal1__c');
				workObj.addressLineLocal2 = (String)so.get('HWS_AddressLineLocal2__c');
				workObj.addressLineLocal3 = (String)so.get('HWS_AddressLineLocal3__c');
				workObj.localShiptoPartyName = (String)so.get('Legal_Name_Ext__c');
				if (isEnglish) {
				workObj.addressLine1 = (String)so.get('BillingCity');
				workObj.addressLine2 = (String)so.get('BillingState');
				workObj.addressLine3 = (String)so.get('BillingStreet') + ' ' + (String)so.get('BillingPostalCode');
				} else {
				workObj.addressLine1 = (String)so.get('ShippingCity');
				workObj.addressLine2 = (String)so.get('ShippingState');
				workObj.addressLine3 = (String)so.get('ShippingStreet') + ' ' + (String)so.get('ShippingPostalCode');
				}
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
				workObj.country = (String)so.get('BillingCountry');
				if(workingList == null) {
				workingList = new List<HWS_Lookup_Class.untitleSObject>();
				}
				workingList.add(workObj); */
				//changes for NOKIASC-38438
				workObj.currentworkingTitleId = (Id)so.get('Id');
				workObj.currentworkingTitleName = (String)so.get('Name');
				workObj.addressLine1 = (String)so.get('Hws_Address_Line_1__c');
				workObj.addressLine2 = (String)so.get('Hws_Address_Line_2__c');
				workObj.addressLine3 = (String)so.get('Hws_Address_Line_3__c');
				workObj.addressLineLocal1 = (String)so.get('HWS_AddressLineLocal1__c');
				workObj.addressLineLocal2 = (String)so.get('HWS_AddressLineLocal2__c');
				workObj.addressLineLocal3 = (String)so.get('HWS_AddressLineLocal3__c');
				workObj.localShiptoPartyName = (String)so.get('Legal_Name_Ext__c');
				workObj.cityStateCountry = (String)so.get('BillingCity');
				workObj.shipToPartyAccount = so;
				if((String)so.get('BillingState')!=null){
					workObj.cityStateCountry =workObj.cityStateCountry +','+(String)so.get('BillingState');
				}
				if((String)so.get('BillingCountry')!=null){
					workObj.cityStateCountry = workObj.cityStateCountry +','+(String)so.get('BillingCountry');
				}
				if((String)so.get('BillingPostalCode')!=null){
					workObj.cityStateCountry = workObj.cityStateCountry +','+(String)so.get('BillingPostalCode');
				}
				workObj.country = (String)so.get('BillingCountry');
				//Shipping Address
				workObj.shippingcityStateCountry = (String)so.get('ShippingCity');
				if((String)so.get('ShippingState')!=null){
					workObj.shippingcityStateCountry =workObj.shippingcityStateCountry +','+(String)so.get('ShippingState');
				}
				if((String)so.get('ShippingCountry')!=null){
					workObj.shippingcityStateCountry = workObj.shippingcityStateCountry +','+(String)so.get('ShippingCountry');
				}
				if((String)so.get('ShippingPostalCode')!=null){
					workObj.shippingcityStateCountry = workObj.shippingcityStateCountry +','+(String)so.get('ShippingPostalCode');
				}
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
		HWS_BulkUpload__c bu = new HWS_BulkUpload__c();
		bu.Id = bulkRecId;
		bu.HWS_Ship_to_Address__c = shipToAddrId;
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
					System.debug(LoggingLevel.DEBUG,'Error while submitting/updating Case: '+de);
				}
			}
		}   
		return null;  
	}
	//end ******* HWST-3785  
	
	//NOKIASC-34752 - START
	@auraEnabled
	public static List<Case> makeSOOBulkCalloutForWarrantyCheck(List<String> parentCaseNumberList){  
		List<Case> caselist = [select Id, CaseNumber from Case WHERE CaseNumber IN :parentCaseNumberList];
		if(!caselist.isEmpty()){
			
			for(Case c :caselist){  
				HWS_SendServiceRequesttoSOO_SVC.sendBulkToSOO(c.Id);
			}
		}	  
		return null;  
	}
	//NOKIASC-34752 - END
	
	@auraEnabled
	public static String getPayPerUse(Id parentCaseId){
		String isValue;
		List<Case> parentCase=[select id,CH_InternalStatus__c,HWS_Customer_PO__c from case where Id =:parentCaseId LIMIT 1];
		List<Case> childCases;
		Boolean invoicingType = false;
		if(parentCase.Size()>0){
			childCases = [select Id,HWS_ServiceType__c,HWS_Contract_Line_Item__r.HWS_InvoicingType__c, HWS_Contract_Line_Item__r.CH_ServiceOffering__c,Asset.HWS_ServiceOffering__c,Asset.HWS_Price__c
						  FROM Case where ParentId =: parentCaseId AND Status!='Cancelled'];
			for(Case getChildCaseValues:childCases){
				String invoiceType = getChildCaseValues.HWS_Contract_Line_Item__r.HWS_InvoicingType__c;
				if(invoiceType == 'event based'){
					invoicingType = true;
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
			
			else if(parentCase[0].HWS_Customer_PO__c=='' || parentCase[0].HWS_Customer_PO__c== NULL){
				if(childCases.Size()>0){
					for(Case getChildCaseValues:childCases){
						string serviceItemDescription=getChildCaseValues.Asset.HWS_ServiceOffering__c;
						string servicetype =getChildCaseValues.HWS_ServiceType__c;
						if((servicetype =='Spare Part Sales') || (serviceItemDescription!='' && serviceItemDescription!=NULL) && (serviceItemDescription.contains('RES RFR PU')||serviceItemDescription.contains('RES AED PU'))){
							isValue='PO Error';
							break;
						}
						
					}
				}
			}
			
			else if(childCases.Size()>0){
				for(Case getChildCaseValues:childCases){
					string serviceItemDescription=getChildCaseValues.Asset.HWS_ServiceOffering__c;
					string getPrice=getChildCaseValues.Asset.HWS_Price__c;
					string servicetype =getChildCaseValues.HWS_ServiceType__c;
					String invoiceType = getChildCaseValues.HWS_Contract_Line_Item__r.HWS_InvoicingType__c;
					if(invoiceType == 'event based'){
						invoicingType = true;
					}
					if(((servicetype =='Spare Part Sales') || (serviceItemDescription!='' && serviceItemDescription!=NULL) && (serviceItemDescription.contains('RES RFR PU')||serviceItemDescription.contains('RES AED PU'))) &&((parentCase[0].HWS_Customer_PO__c=='' || parentCase[0].HWS_Customer_PO__c== NULL) && (getPrice == '' || getPrice == null ))){
						isValue='Quotation Error';
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
			HWS_Utilty.plannedDeliveryDateWrapper listCase = HWS_CaseFlow.accountTimeZoneplannedDeliveryDateTime(accIdListCaseMap.get(idValue),idValue,true );// NOKIASC-37920   
			List<Case> newtimeZoneCaseList = listCase.newTimeZoneCaseList;
			Case parentCase = new Case();
			if(newtimeZoneCaseList.size()>0)
			 parentCase.Id=newtimeZoneCaseList[0].ParentId;
			parentCase.HWS_Delivery_TimeZone__c = listCase.bhTimeZone;
			//NOKIASC-37920 | Bulk Upload Optimization
			if(childCaseCount.get(parentCase.Id) != null){
				parentCase.CH_CIRCount__c = childCaseCount.get(parentCase.Id);
			 parentCases.add(parentCase);
			}
			timeZoneUpdatedCaseList.addAll(newtimeZoneCaseList);
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
		HWS_Utilty.plannedDeliveryDateWrapper listCaseParentTimeZone = HWS_CaseFlow.accountTimeZoneplannedDeliveryDateTime(listChildCases, selectedAccount, false); //NOKIASC-37920
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
	public static void updateNEAValues(Id selectedAssetId,String selectedAssetName,Id bulkRecId){   
		HWS_BulkUpload__c bulkUploadRec = new HWS_BulkUpload__c();
		System.debug('NEAL:'+selectedAssetId);
		bulkUploadRec.Id = bulkRecId;
		bulkUploadRec.HWS_NetworkElementAsset__c=selectedAssetId;
		bulkUploadRec.HWS_NetworkElementAssetName__c=selectedAssetName;
		update bulkUploadRec;
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
			}
			
			
		}
		return neaAssetList;
	}
	//End Changes for 25679
	
	/*************************
Method Name : getNEA
User Story : NOKIASC-32950
Description : To solve NEA performence issue
Created By  : TCS
Created Date: 26/11/2020 (MM/DD/YYYY)
Modified By :
Modified Date:
******************************/  
	@auraEnabled
	public static HWS_NetworkElementAssetWrapper.AssetPagerWrapper getNEA(Id accId, Id cliId,List<Id> cliIdList,Integer recordLimit, Integer recordOffset,String searchText){   
		
		return HWS_Utilty.getNetworkElementAssets(accId,cliId,cliIdList,recordLimit,recordOffset,searchText);   
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
	
	
	@auraEnabled
	public Static String validateUserInputs(String caseNumber, String accountNumber) {
		String message = 'SUCCESS';
		Set<String> HWS_RecordTypeSet = new Set<String>{'CH_NokiaStandardCase','CH_NokiaInformationRequest','CH_NokiaIncidentWithRestoration'};
			List<Case> caseList = [SELECT Id, RecordTypeId, Account.AccountNumber FROM Case Where CaseNumber =:caseNumber];
		if (caseList.isEmpty()) {
			message = 'Ticket Number you provided does not exist.Please enter a valid software ticket number in the Related Software Ticket Number field';
			return message;
		} else {
			String recordTypeName = [SELECT DeveloperName FROM RecordType WHERE SobjectType='Case' AND Id =:caseList[0].RecordTypeId].DeveloperName;
			if (!HWS_RecordTypeSet.contains(recordTypeName)) {
				message = ' Please enter a valid software ticket number in the Related Software Ticket Number field';
				return message;
			} else if (caseList[0].Account.AccountNumber != accountNumber) {
				message = 'The Legal Entity listed on the software ticket, does not match. Please enter a software ticket number with matching Legal Entity';
				return message;
			}
		}
		return message; 
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
	
	/****************************************
* Name : getContactInfo
* Description : populated with Contact's Mobile number unless there is no mobile number, in which case their "Phone" number is used
* Parameters: ContactId
* Returns : ContactInfoWrapper
* written on 7th April 2021
* User Story : NOKIASC-34537
*****************************************/
	@auraEnabled
	public static ContactInfoWrapper getContactInfo(String contactId) {
		ContactInfoWrapper wrapper = new ContactInfoWrapper();
		for (Contact con : [SELECT Id, Name, Email, Phone, MobilePhone FROM Contact WHERE Id =:contactId]) {
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
	
	/****************************************
* Name : warrantyCheck
* Description : returns Warranty Status
* Parameters: Material Code, Faulty Unit Serial Number, Source System
* Returns : Warranty Status
* written on 21st Oct 2020
* User Story : NOKIASC-32213
*****************************************/
	@auraEnabled
	public static string warrantyCheck(String materialCode,String serialNumber,String sourceSystem) {
		return HWS_Utilty.warrantyCheck(materialCode,serialNumber,sourceSystem);		
	}
	/*
NOKIASC-32957
*/
	@auraEnabled
	public static List<CH_CoveredNetworkElementAsset__c> fetchAssetNetworkElementWithSearch(Integer offSetValue,Integer soqlLimit,Id bulkId,Boolean byPassValue,String searchKeyWord){  
		String neaRecordType = 'CH_NetworkElementAsset';
		String cneaStatus = 'Active';
		Integer offset=Integer.valueOf(offSetValue);  
		Integer intLimit =Integer.valueOf(soqlLimit);
		String contractLineItemId = [select id,HWS_Contract_Line_Item__r.id from HWS_BulkUpload__c where id=:bulkId].HWS_Contract_Line_Item__r.id;   
		String cneaQuery = 'Select id,CH_ContractLineItem__c, CH_NetworkElementAsset__c,CH_NetworkElementAsset__r.Name,CH_NetworkElementAsset__r.Product2Id,CH_NetworkElementAsset__r.Product2.Name,CH_NetworkElementAsset__r.CH_Solution__c,CH_NetworkElementAsset__r.CH_Solution__r.Name,CH_NetworkElementAsset__r.CH_ProductVariant__c,CH_NetworkElementAsset__r.CH_ProductVariant__r.Name,CH_NetworkElementAsset__r.CH_ProductRelease__c,CH_NetworkElementAsset__r.CH_ProductRelease__r.Name,CH_NetworkElementAsset__r.Address__c,CH_NetworkElementAsset__r.Address__r.CH_AddressDetails__c,CH_NetworkElementAsset__r.CH_NetworkElementID__c,CH_NetworkElementAsset__r.CH_LabEnvironment__c,CH_NetworkElementAsset__r.CH_CountryISOName__c from CH_CoveredNetworkElementAsset__c WHERE  ((CH_NetworkElementAsset__c != null AND CH_Status__c = :cneaStatus AND CH_ContractLineItem__c = :contractLineItemId) ';
		if(searchKeyWord !=null && searchKeyWord !=''){
			System.debug('INSIDE IF');
			cneaQuery = cneaQuery+ 'AND (CH_NetworkElementAsset__r.Name LIKE \'%' + String.escapeSingleQuotes(searchKeyWord.trim()) + '%\' ';
			cneaQuery = cneaQuery+ 'OR CH_NetworkElementAsset__r.CH_City__c LIKE \'%' + String.escapeSingleQuotes(searchKeyWord.trim()) + '%\' ';
			cneaQuery = cneaQuery+ 'OR CH_NetworkElementAsset__r.CH_State_Province__c LIKE \'%' + String.escapeSingleQuotes(searchKeyWord.trim()) + '%\' ';
			cneaQuery = cneaQuery+ 'OR CH_NetworkElementAsset__r.Address__r.Street LIKE \'%' + String.escapeSingleQuotes(searchKeyWord.trim()) + '%\' ';
			cneaQuery = cneaQuery+ 'OR CH_NetworkElementAsset__r.Address__r.postalcode LIKE \'%' + String.escapeSingleQuotes(searchKeyWord.trim()) + '%\' ';
			cneaQuery = cneaQuery+ 'OR CH_NetworkElementAsset__r.Address__r.Country LIKE \'%' + String.escapeSingleQuotes(searchKeyWord.trim()) + '%\' ';
			cneaQuery = cneaQuery+ 'OR CH_NetworkElementAsset__r.CH_NetworkElementID__c LIKE \'%' + String.escapeSingleQuotes(searchKeyWord.trim()) + '%\' ';
			cneaQuery = cneaQuery+ 'OR CH_NetworkElementAsset__r.Product2.Name LIKE \'%' + String.escapeSingleQuotes(searchKeyWord.trim()) + '%\' ' ;
			cneaQuery = cneaQuery+ 'OR CH_NetworkElementAsset__r.CH_ProductRelease__r.Name LIKE \'%' + String.escapeSingleQuotes(searchKeyWord.trim()) + '%\' ';
			cneaQuery = cneaQuery+ 'OR CH_NetworkElementAsset__r.Status LIKE \'%' + String.escapeSingleQuotes(searchKeyWord.trim()) + '%\' ';
			cneaQuery = cneaQuery+ ' OR CH_NetworkElementAsset__r.CH_Solution__r.Name LIKE \'%' + String.escapeSingleQuotes(searchKeyWord.trim()) + '%\' ';
			cneaQuery = cneaQuery+ ' OR CH_NetworkElementAsset__r.CH_ProductVariant__r.Name LIKE \'%' + String.escapeSingleQuotes(searchKeyWord.trim()) + '%\' ';   
			cneaQuery = cneaQuery+ '))';
		}   
		else{
			cneaQuery = cneaQuery+')';
		}
		cneaQuery = cneaQuery+' LIMIT:intLimit  Offset :offset';
		List<CH_CoveredNetworkElementAsset__c> cneaList = Database.query(cneaQuery);			
		
		return cneaList;
	}
	/****************************************
* Name : getCustomSettings
* Description : This method is used to get HWS Custom Settings
* By Satya Pagadala
* Created Date: 12 Feb 2021
* User story : NOKIASC-34212
*****************************************/ 
	@AuraEnabled
	public static HWS_GenericSettings__c getHWSGenericSettings(String name){
		return HWS_GenericSettings__c.getValues(name);
	}
	
	@AuraEnabled
	public static List<ContractLineItem> showRetroAccount(string contractLineItemId) {
		// NOKIASC-37617 Updated return type
		return HWS_CaseFlow.showRetroAccount(contractLineItemId);
	} 
	
	@auraEnabled 
	public static list<Account> getAccountsInfo(string accountId) {  
		Set<id> acc = new set<id>();
		acc.add(accountId);
		List<Account> lAccounts = HWS_Utilty.getAccounts(acc);
		return lAccounts;
	}
	
	 /****************************************
	* Name : fetchServiceContract
	* Description : THis method is used to return authorised contract for retrofit
	* Parameters: Contact id and Account id
	* Returns : Service Contract Details
	* written on : 06-07-2021
	* User Story : NOKIASC-37090:Bulk Case Creation : Allow user to select Service Contract
	*****************************************/
	@auraEnabled
	public static list<EntitlementContact> fetchServiceContract(String contactId,String accountId) {
		return [SELECT Entitlement.ServiceContract.Name ,Entitlement.ServiceContract.Id , Entitlement.ServiceContract.CH_SAP_ContractNumber__c,Entitlement.ServiceContract.CH_CDB_ContractNumber__c,
				Entitlement.ServiceContract.CH_CARES_ServiceAgreement__c,Entitlement.ServiceContract.HWS_Retrofit_Type__c FROM EntitlementContact 
				WHERE ContactId =:contactId AND Entitlement.ServiceContract.AccountId =:accountId 
				AND Entitlement.ServiceContract.NCP_External_Status__c ='Active' and Entitlement.ServiceContract.CH_CDB_ContractType__c ='Internal - RFT - Retrofit' ]; 
		
	}
	/****************************************   
	* Name : getServicedAccountNumbers
	* Description : method to get ServicedAccountNumbers
	* Parameters: NA
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
	
	 @AuraEnabled
	public static String returnBulkUploadBachSize()
	{ 
	 HWS_GenericSettings__c record = HWS_GenericSettings__c.getValues('HWS_BulkUploadBachSize');
		string BatchSize ;
		if(record == null)
			BatchSize = '25';
		else
			BatchSize= (string) record.get('HWS_Field1__c');
		return BatchSize;
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
		return HWS_CaseFlow.getSuspensionStatus(contactList,serviceContractList);		 
	}
	
}