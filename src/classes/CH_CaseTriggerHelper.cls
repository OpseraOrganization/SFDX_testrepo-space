/****************************************
* Class Name : CH_CaseTriggerHelper
* Created Date: 08 August 2018
* Created By : TCS
* Last Modified by: Sónia Reis
* Last Modified Date: 10 October 2019
* Description : Contains common business logic
* Test Class: CH_CaseTriggerHelperTest and CH_CaseTrigger_Helper_Test
*****************************************/
public without sharing class CH_CaseTriggerHelper {
	public static Map<String, Schema.SObjectField> caseFieldMap = Schema.SObjectType.Case.fields.getMap();
	public static list<CaseMilestone> milestones = null;
	public static final String ERROR_MESSAGE='All users in the queue dont have the right Security Group for this case.';
	public static final String UNABLE_TOASSIGN='Unable to assign';
	public static final String OMRSP ='as Owner. Missing required security permissions.';
	public static final String ERROR_MESSAGE2= 'Queue cannot be made the owner of the case.';
	public static final String EntitlementException = 'Entitlement Exception = ';
	public static final List<String> addCountries=new List<String>{'American Samoa','Guam','Northern Mariana Islands','Puerto Rico','United States of America','Virgin Islands (U.S.)','United States Minor Outlying Islands'}; //NOKIASC-36342
	/********************
	*@desc Method Name: updateCurrentQueue, update the current queue field with the value of workgroup member name if it's role = queue
	*@param : New Case List (Only Case Handling Record Type Records)
	*Last updated by: Abdallah dahjou
	*******************/
	//NOKIASC-28531 - Miguel silva changed logic
	public static void updateCurrentQueue(Map < Id, Case > oldCaseMap,List < Case > lstcase){
		List<Case> caseList = new List<Case>();
		for(Case newCase : lstCase){
			if(newCase.OwnerId != oldCaseMap.get(newCase.id).OwnerId && newCase.CH_RecordTypeCheck__c){ 
	caseList.add(newCase);
			}
		}
		
		if(caseList != null && !caseList.isEmpty()){
			set<ID> setworkgroupIds = new set<ID>();
			map<ID,ID> mapCaseIdWorkgroupIds = new map<ID,ID>();
			map<ID,List<CH_Workgroup_Member__c>> mapwrkgrpIdMembers = new  map<ID,List<CH_Workgroup_Member__c>>();
			List<CH_Workgroup_Member__c> lstWorkgroupMember = new List<CH_Workgroup_Member__c>();
			
			for(Case caseObj: caseList){
	setworkgroupIds.add(caseObj.CH_Workgroup__c );
	mapCaseIdWorkgroupIds.put(caseObj.Id,caseObj.CH_Workgroup__c);
			}   
			
			lstWorkgroupMember = [SELECT Id,CH_Workgroup__c,CH_Workgroup_Member_Type__c,CH_Role__c,CH_User__c ,CH_User__r.Name, Name
	FROM CH_Workgroup_Member__c
	WHERE CH_Workgroup__c IN:setworkgroupIds AND CH_Workgroup_Member_Type__c ='Queue'];
			
			for(CH_Workgroup_Member__c workgroupMember : lstWorkgroupMember){
	
	if ( ! mapwrkgrpIdMembers.containsKey(workgroupMember.CH_Workgroup__c )   ){
		mapwrkgrpIdMembers.put( workgroupMember.CH_Workgroup__c,new List<CH_Workgroup_Member__c>());
	}
	mapwrkgrpIdMembers.get( workgroupMember.CH_Workgroup__c).add(workgroupMember);
	
			} 
			
			
			for(Case caseObj: caseList){
	caseObj.CH_CurrentQueue__c = null;
	List<CH_Workgroup_Member__c> workgroupMembers = new  List<CH_Workgroup_Member__c>();
	if (mapwrkgrpIdMembers.get(caseObj.CH_Workgroup__c)!= null ){
		workgroupMembers = mapwrkgrpIdMembers.get(caseObj.CH_Workgroup__c);
		for(CH_Workgroup_Member__c wrkgrpMember: workgroupMembers){
			if(caseObj.OwnerId == wrkgrpMember.CH_User__c){
		caseObj.CH_CurrentQueue__c = wrkgrpMember.Name;
		}
	}
	}
			}
		}
		
	}
	/********************
	*@desc Method Name: chS2SLegalEntityCheck
	*@param : New Case List (Only Case Handling Record Type Records)
	*Created by : viond T
	*Des: When Origin is s2s and Case Originsystem is not null then validate Case LegalEntity in mapping table s2s system AccountOut
	*******************/
	public static void chS2SLegalEntityCheck(Map < Id, Case > oldCaseMap,List < Case > lstcase){
		
		Set<String> caseOriginSys = new Set<String>();
		List<Id> caseAccId = new List<Id>();
		//NOKIASC-33486
		Boolean nextValida = true;		
		Boolean chreferenceChk = false;
		for(case c : lstcase){
			if(c.origin =='S2S' && oldCaseMap.get(c.Id).CH_CaseOriginSystem__c != c.CH_CaseOriginSystem__c && c.CH_CaseOriginSystem__c !=null && c.CH_CaseOriginSystem__c !=''){
	  
	caseOriginSys.add(c.CH_CaseOriginSystem__c);
	caseAccId.add(c.AccountId);
			}
			//NOKIASC-33486
			if(c.origin =='S2S' && c.Reference_Number__c != null && oldCaseMap.get(c.Id).Reference_Number__c != c.Reference_Number__c){
	chreferenceChk = true;
			}
		}
		List<Account> lstacc = [SELECT Acc_No__c FROM Account WHERE Id IN :caseAccId];
		List<String> accNo =  new List<String>();
		for(Account acc: lstacc){
			accNo.add(acc.Acc_No__c);
		}
		List<CH_Case_PA_InterfaceMapping__c> accIdAndOrignMappingTbl = [SELECT Id, CaseOriginSystem__c,AccountOut__c FROM CH_Case_PA_InterfaceMapping__c WHERE AccountOut__c IN : accNo AND CaseOriginSystem__c IN : caseOriginSys LIMIT 1];
			if(!accNo.isEmpty()){
	for(case c : lstcase){
		if(accIdAndOrignMappingTbl.isEmpty() && c.origin =='S2S'){
			nextValida = false;
			//Ref: NOKIASC-36332 Replaced Error Message With Custom Label
			c.addError(System.Label.CH_Legal_Entity_Not_Authorised_For_Interface_Set);
		}
	}
			}
		 //NOKIASC-33486
		if(nextValida == true && chreferenceChk == true){
			List<Case> uniqueRefNumberCases = CH_ExternalInterfaceUTIL.isolateUniqueRefNumCases(lstcase);
			List<Case> caseToExternalSystem = new List<Case>();
			if(!CH_ExternalInterfaceUTIL.casesWithErrors.isEmpty()){
	for(case c : lstcase){ c.addError(System.Label.CH_Cannot_Update_Case_Reference_Number+' '+c.Reference_Number__c);
	}
			} else {
	CH_OutboundMessageSettings__c outboundMessageSettingsperOrigin = new CH_OutboundMessageSettings__c();
	Map<String, CH_OutboundMessageSettings__c> outboundMessageSettings = CH_OutboundMessageSettings__c.getAll();
	for(Case c : lstcase){
		outboundMessageSettingsperOrigin = outboundMessageSettings.get(c.CH_CaseOriginSystem__c);
		if(outboundMessageSettingsperOrigin != NULL && outboundMessageSettingsperOrigin.CaseCreation__c == TRUE){ caseToExternalSystem.add(c);
		}
	}
	if(!caseToExternalSystem.isEmpty()){ CH_ExternalInterfaceUTIL.sendCreationToExternalSystem(caseToExternalSystem);
	}
			}
		} 
	}
	
	/********************
	*Method Name: checkViolatedMilestone
	*Parameter: New Case List (Only Case Handling Record Type Records)
	*Last updated by: Aditya Jawadekar
	*Description: Complete all the milestones when case is cancelled
	*******************/
	public static void completeMilestoneOnCancellation(List < Case > caseList){
		if(caseList != null && !caseList.isEmpty()){
			for(Case caseObj: caseList){
	String recordTypeName = Schema.SObjectType.Case.getRecordTypeInfosById().get(caseObj.recordTypeId).getDeveloperName();
	
	if((caseObj.CH_RecordTypeCheck__c == true && recordTypeName != 'CH_Problem' && String.isNotBlank(caseObj.entitlementId) && caseObj.Status == 'Cancelled') || test.isRunningTest()){
		if(caseObj.CH_IsInitialResponseSLA__c == true && caseObj.CH_IsCompleteInitialResponse__c != true){
			caseObj.CH_IsCompleteInitialResponse__c = true;
			caseObj.CH_InitialResponse__c = System.now();
		}
		if(caseObj.CH_IsSystemRestoredSLA__c == true && caseObj.CH_IsCompleteRestore__c != true){
			caseObj.CH_IsCompleteRestore__c = true; caseObj.CH_SystemRestored__c = System.now();
		}
		if(caseObj.CH_IsServiceDisruptionReportSLA__c == true && caseObj.CH_IsCompleteServiceDisruptionReport__c != true){
			caseObj.CH_IsCompleteServiceDisruptionReport__c = true;
			caseObj.CH_ServiceDisruptionReportProvided__c = System.now();
		}
		if(caseObj.CH_IsTemporarySolutionProvidedSLA__c == true && caseObj.CH_IsCompleteTemporarySolution__c != true){
			caseObj.CH_IsCompleteTemporarySolution__c = true; caseObj.CH_TemporarySolutionProvided__c = System.now();
		}
		if(caseObj.CH_IsSolutionProvidedSLA__c == true && caseObj.CH_IsCompleteSolutionProvided__c != true){
			caseObj.CH_IsCompleteSolutionProvided__c = true; caseObj.CH_SolutionProvided__c = System.now();
		}   
	}
			}
		}
	}
	
	/********************
	*Method Name: checkEntitlementExceptionCases
	*Parameter: New Case List (Only Case Handling Record Type Records)
	*Last updated by: TCS 
	*Description: Method to check to filter cases where entitlement exception raised
	*User Story: NOKIASC-17177
	*******************/
	public static void checkEntitlementExceptionCases(List < Case > caseList) {
		if(caseList != null && !caseList.isEmpty()) {
			List < Case > newCaseList = new List < Case > ();
			for(Case caseObj: caseList) {
	if(caseObj.CH_EntitlementException__c == 'Account Not Listed' || 
	caseObj.CH_EntitlementException__c == 'Covered Product Asset Not Listed' || 
	caseObj.CH_EntitlementException__c == 'Entitlement Not Listed') { newCaseList.add(caseObj);
	}
			}
			if(!newCaseList.isEmpty()) { setEntitlementReport(newCaseList);
			}
		}
	}
	
	/********************
	*Method Name: checkEntitlementExceptionCases
	*Parameter: Old Case Map, New Case List (Only Case Handling Record Type Records)
	*Last updated by: TCS 
	*Description: Method to check to filter cases where entitlement exception raised
	*User Story: NOKIASC-17177
	*******************/
	public static void checkEntitlementExceptionCases(Map < Id, Case > oldCaseMap, List < Case > caseList) {
		if(caseList != null && !caseList.isEmpty()) {
			List < Case > newCaseList = new List < Case > ();
			for(Case newCaseObj: caseList) {
	if(newCaseObj.CH_EntitlementException__c == 'Account Not Listed' || 
	newCaseObj.CH_EntitlementException__c == 'Covered Product Asset Not Listed' || 
	newCaseObj.CH_EntitlementException__c == 'Entitlement Not Listed') {
		Case oldCaseObj = oldCaseMap.get(newCaseObj.Id);
		if(oldCaseObj != null && (oldCaseObj.CH_EntitlementException__c != newCaseObj.CH_EntitlementException__c ||
		 oldCaseObj.AccountId != newCaseObj.AccountId || 
		 oldCaseObj.ProductId != newCaseObj.ProductId || 
		 oldCaseObj.CH_ServiceType__c != newCaseObj.CH_ServiceType__c || 
		 oldCaseObj.Country__c != newCaseObj.Country__c)) {
	newCaseList.add(newCaseObj);
	}  
	} else { newCaseObj.CH_EntitlementReport__c = '';
	}	
			}
			if(!newCaseList.isEmpty()) {
	setEntitlementReport(newCaseList);
			}
		}
	}
	
	/********************
*Method Name: setEntitlementReport
*Parameter: New Case List (Only Case Handling Record Type Records)
*Last updated by: TCS 
*Description: Method to update entitlement report when there is entitlement exception raised
*User Story: NOKIASC-17177
*******************/
	public static void setEntitlementReport(List < Case > caseList) {
		if(caseList != null && !caseList.isEmpty()) {
			Set < Id > accountIds = new Set < Id > ();
			Set < Id > contactIds = new Set < Id > ();
			Set < Id > productIds = new Set < Id > ();
			Set < String > serviceTypes = new Set < String > ();
			Set < String > countries = new Set < String > ();
			//**Change for US22365--START
			List <Account> nokiaacc = new List <Account> ([select id, name from Account where name like '%NOKIA%' and Active__c = TRUE]);
			for(Case caseObj: caseList) {
	if (caseObj.CH_ServiceType__c == SWS_Constants.ServiceTypeIS && caseObj.ContactId != NULL){
		for(Account acc : nokiaacc){
		accountIds.add(acc.ID);}}
	else {
		accountIds.add(caseObj.AccountId);
		}
	//**Change for US22365--END
	productIds.add(caseObj.productId);
	serviceTypes.add(caseObj.CH_ServiceType__c);
	countries.add(caseObj.Country__c);   
	// List out contact Ids for preparing entitlement report content
	contactIds.add(caseObj.ContactId);
			}
			
			/****** STEP-A Started. ***************/
			Map < String, Set < Id >> caseContractMap = new Map < String, Set < Id >> ();
			for(ContractLineItem lineItemObj: [SELECT ServiceContractId, ServiceContract.AccountId, Asset.Product2Id, Asset.CH_CountryISOName__c, CH_ServiceType__c FROM ContractLineItem 
	 WHERE ServiceContract.AccountId IN :accountIds
	 AND ServiceContract.NCP_External_Status__c = 'Active' 
	 AND Asset.Product2Id IN :productIds
	 AND Asset.CH_CountryISOName__c IN :countries
	 AND CH_ServiceType__c IN :serviceTypes
	 AND NCP_External_Status__c = 'Active'
	]) {
	 String key = lineItemObj.ServiceContract.AccountId + ':' + lineItemObj.Asset.Product2Id + ':' + lineItemObj.Asset.CH_CountryISOName__c + ':' + lineItemObj.CH_ServiceType__c;
	 if(caseContractMap.containsKey(key)) { caseContractMap.get(key).add(lineItemObj.ServiceContractId);
	 } else { caseContractMap.put(key, new Set <Id> {lineItemObj.ServiceContractId});
	 }
	}			
			// Clear variables for re-use
			accountIds.clear();  productIds.clear(); serviceTypes.clear(); countries.clear();
			// Get Contact Information to form Entitlement Report Text
			Map < Id, Contact > contactMap = CH_CaseTriggerDataProvider.getContactMap(contactIds);
			// Prepare another list of cases to process again whose count is 0
			List < Case > nextStepCaseList = new List < Case > ();
			for(Case caseObj: caseList) {
	  
	String key = '';
	Integer reccount = 0;
	if(caseObj.ContactId != NULL) {
	if (caseObj.CH_ServiceType__c == SWS_Constants.ServiceTypeIS && caseObj.ContactId != NULL){
		for(Account acc : nokiaacc){
		key = acc.ID + ':' + caseObj.ProductId + ':' + caseObj.Country__c + ':' + caseObj.CH_ServiceType__c;
		
		if(caseContractMap.containsKey(key)) {
		reccount = reccount + caseContractMap.get(key).size();}
		}
		}
	else {
		key = caseObj.AccountId + ':' + caseObj.ProductId + ':' + caseObj.Country__c + ':' + caseObj.CH_ServiceType__c;
	
		if(caseContractMap.containsKey(key)) {
			reccount = caseContractMap.get(key).size();}
		}
	if(reccount > 0) {
		caseObj.CH_EntitlementReport__c = getEntitlementReportA(caseObj, contactMap.get(caseObj.ContactId), reccount);
	} else {
		//**Change for US22365--START
	if (caseObj.CH_ServiceType__c == SWS_Constants.ServiceTypeIS && caseObj.ContactId != NULL){
		for(Account acc : nokiaacc){ accountIds.add(acc.ID);}
	}
	else { accountIds.add(caseObj.AccountId);
		}
	//**Change for US22365--END
		productIds.add(caseObj.productId);
		serviceTypes.add(caseObj.CH_ServiceType__c);
		countries.add(caseObj.Country__c);
		nextStepCaseList.add(caseObj);	  
	}
			}
			}
			/****** STEP-A Completed Successfully. ***************/
			/****** STEP-B Started. ***************/
			if(!nextStepCaseList.isEmpty()) {
	caseContractMap.clear();
	for(ContractLineItem lineItemObj: [SELECT ServiceContractId, ServiceContract.AccountId, Asset.Product2Id, Asset.CH_CountryISOName__c, CH_ServiceType__c FROM ContractLineItem 
	  WHERE ServiceContract.AccountId IN :accountIds
	  AND (ServiceContract.NCP_External_Status__c != 'Active' OR NCP_External_Status__c != 'Active') 
	  AND ServiceContract.EndDate = LAST_N_DAYS:180   
	  AND Asset.Product2Id IN :productIds
	  AND Asset.CH_CountryISOName__c IN :countries	
	  AND CH_ServiceType__c IN :serviceTypes
	 ]) {
	  String key = lineItemObj.ServiceContract.AccountId + ':' + lineItemObj.Asset.Product2Id + ':' + lineItemObj.Asset.CH_CountryISOName__c + ':' + lineItemObj.CH_ServiceType__c;
	  if(caseContractMap.containsKey(key)) { caseContractMap.get(key).add(lineItemObj.ServiceContractId);
	  } else { caseContractMap.put(key, new Set <Id> {lineItemObj.ServiceContractId});
	  }
	 }
			
	
	for(Case caseObj: nextStepCaseList) {
		
		String key = '';
		Integer reccount = 0;
		if(caseObj.ContactId != NULL) {
		if (caseObj.CH_ServiceType__c == SWS_Constants.ServiceTypeIS){
		for(Account acc : nokiaacc){
		key = acc.ID + ':' + caseObj.ProductId + ':' + caseObj.Country__c + ':' + caseObj.CH_ServiceType__c;
		 if(caseContractMap.containsKey(key)) {
	reccount = reccount + caseContractMap.get(key).size();}
		}
		}
		else {
		key = caseObj.AccountId + ':' + caseObj.ProductId + ':' + caseObj.Country__c + ':' + caseObj.CH_ServiceType__c;
		if(caseContractMap.containsKey(key)) {
		 reccount = reccount + caseContractMap.get(key).size();}
		}
		if(reccount > 0) {
			caseObj.CH_EntitlementReport__c = getEntitlementReportB(caseObj, contactMap.get(caseObj.ContactId), reccount);
		} else {
			caseObj.CH_EntitlementReport__c = getEntitlementReportC(caseObj, contactMap.get(caseObj.ContactId));
		}
	}
			}
		}	  
		}
	}
	
	/********************
*Method Name: getEntitlementReportA
*Parameter: Case, Contact, Count
*Last updated by: TCS 
*Description: Method to prepare entitlement report
*User Story: NOKIASC-17177
*******************/
	public static String getEntitlementReportA(Case caseObj, Contact contactObj, Integer count) {
		//**Change for US22365--START
		if ( caseObj.CH_ServiceType__c == SWS_Constants.ServiceTypeIS && contactObj != NULL) {
			String entitlementReport = EntitlementException + caseObj.CH_EntitlementException__c + '\r\n';
		entitlementReport += 'Contact Name (First Name, Last Name) = ' + (contactObj != null ? contactObj.Name : '') + '\r\n';
		entitlementReport += 'Contact Legal Entity = ' + (contactObj != null ? contactObj.CH_Legal_Entity_Name__c : '') + '\r\n\r\n';
		entitlementReport += 'There are ' + count + ' active contract line items for accounts that start with Nokia or NOKIA for Service Type = ' + caseObj.CH_ServiceType__c + ', Product = ' + caseObj.CH_Product_Name__c + ' and Country = ' + caseObj.Country__c + '. \r\n\r\n';
		entitlementReport += 'Potential reason for entitlement exception could be related to the Contact on the Case not being listed as Authorized Contact on corresponding Service Contract.';
		return entitlementReport;
			}
		else {
			String entitlementReport = EntitlementException + caseObj.CH_EntitlementException__c + '\r\n';
		entitlementReport += 'Contact Name (First Name, Last Name) = ' + (contactObj != null ? contactObj.Name : '') + '\r\n';
		entitlementReport += 'Contact Legal Entity = ' + (contactObj != null ? contactObj.CH_Legal_Entity_Name__c : '') + '\r\n\r\n';
		entitlementReport += SWS_Constants.ACCOUNT+' ' + caseObj.CH_Account_Name__c + ' has ' + count + ' active contract line items for Service Type = ' + caseObj.CH_ServiceType__c + ', Product = ' + caseObj.CH_Product_Name__c + ' and Country = ' + caseObj.Country__c + '. \r\n\r\n';
		entitlementReport += 'Potential reason for entitlement exception could be related to the Contact on the Case not being listed as Authorized Contact on corresponding Service Contract.';
		return entitlementReport;
		}
		//**Change for US22365--END
	}
	
	/********************
*Method Name: getEntitlementReportB
*Parameter: Case, Contact, Count
*Last updated by: TCS 
*Description: Method to prepare entitlement report
*User Story: NOKIASC-17177
*******************/
	public static String getEntitlementReportB(Case caseObj, Contact contactObj, Integer count) {
		//**Change for US22365--START
		if ( caseObj.CH_ServiceType__c == SWS_Constants.ServiceTypeIS && contactObj != NULL) {
			String entitlementReport = EntitlementException + caseObj.CH_EntitlementException__c + '\r\n';
		entitlementReport += 'Contact Name (First Name, Last Name) = ' + (contactObj != null ? contactObj.Name : '') + '\r\n';
		entitlementReport += 'Contact Legal Entity = ' + (contactObj != null ? contactObj.CH_Legal_Entity_Name__c : '') + '\r\n\r\n';
		entitlementReport += 'There are ' + count + ' inactive contract line items for accounts that start with Nokia or NOKIA for Service Type = ' + caseObj.CH_ServiceType__c + ', Product = ' + caseObj.CH_Product_Name__c + ' and Country = ' + caseObj.Country__c + ' where either the Service Contract OR the Contract Line Item is not active and has expired in past six months. \r\n\r\n';
		entitlementReport += 'Potential reason for entitlement exception is the Contract or Contract Line Item has expired in past 6 months or Service Contract was terminated.';
		return entitlementReport;
		}
		else
		{
	 String entitlementReport = EntitlementException + caseObj.CH_EntitlementException__c + '\r\n';
		entitlementReport += 'Contact Name (First Name, Last Name) = ' + (contactObj != null ? contactObj.Name : '') + '\r\n';
		entitlementReport += 'Contact Legal Entity = ' + (contactObj != null ? contactObj.CH_Legal_Entity_Name__c : '') + '\r\n\r\n';
		entitlementReport += SWS_Constants.ACCOUNT+' '+ caseObj.CH_Account_Name__c + ' has ' + count + ' contract line items for Service Type = ' + caseObj.CH_ServiceType__c + ', Product = ' + caseObj.CH_Product_Name__c + ' and Country = ' + caseObj.Country__c + ' where either the Service Contract OR the Contract Line Item is not active and has expired in past six months. \r\n\r\n';
		entitlementReport += 'Potential reason for entitlement exception is the Contract or Contract Line Item has expired in past 6 months or Service Contract was terminated.';
		return entitlementReport; 
		}
		//**Change for US22365--END
	}
	
	/********************
*Method Name: getEntitlementReportC
*Parameter: Case, Contact, Count
*Last updated by: TCS 
*Description: Method to prepare entitlement report
*User Story: NOKIASC-17177
*******************/
	public static String getEntitlementReportC(Case caseObj, Contact contactObj) {
		//**Change for US22365--START
		if ( caseObj.CH_ServiceType__c == SWS_Constants.ServiceTypeIS && contactObj != NULL ) {
			String entitlementReport = EntitlementException + caseObj.CH_EntitlementException__c + '\r\n';
		entitlementReport += 'Contact Name (First Name, Last Name) = ' + (contactObj != null ? contactObj.Name : '') + '\r\n';
		entitlementReport += 'Contact Legal Entity = ' + (contactObj != null ? contactObj.CH_Legal_Entity_Name__c : '') + '\r\n\r\n';
		entitlementReport += 'There are no contract line items for accounts that start with Nokia or NOKIA for Service Type = ' + caseObj.CH_ServiceType__c + ', Product = ' + caseObj.CH_Product_Name__c + ' and Country = ' + caseObj.Country__c + ' where either the Service Contract OR the Contract Line Item is Inactive and expired in past six months. \r\n\r\n';
		entitlementReport += 'Potential reason for entitlement exception is the Service Contract or Contract Line Item has expired more than 6 months ago OR the Service Contract was terminated OR Customer has never had entitlement coverage for request service for product that is listed OR Incorrect Account is being used on CASE.';
		return entitlementReport;
		}
		else {
	 String entitlementReport = EntitlementException + caseObj.CH_EntitlementException__c + '\r\n';
		entitlementReport += 'Contact Name (First Name, Last Name) = ' + (contactObj != null ? contactObj.Name : '') + '\r\n';
		entitlementReport += 'Contact Legal Entity = ' + (contactObj != null ? contactObj.CH_Legal_Entity_Name__c : '') + '\r\n\r\n';
		entitlementReport += SWS_Constants.ACCOUNT+' ' + caseObj.CH_Account_Name__c + ' has no contract line items for Service Type = ' + caseObj.CH_ServiceType__c + ', Product = ' + caseObj.CH_Product_Name__c + ' and Country = ' + caseObj.Country__c + ' where either the Service Contract OR the Contract Line Item is Inactive and expired in past six months. \r\n\r\n';
		entitlementReport += 'Potential reason for entitlement exception is the Service Contract or Contract Line Item has expired more than 6 months ago OR the Service Contract was terminated OR Customer has never had entitlement coverage for request service for product that is listed OR Incorrect Account is being used on CASE.';
		return entitlementReport; 
		}
		//**Change for US22365--END
	}
	
	@testVisible
	private static Set<Case> casesWithErrors = new Set<Case>();
	
   
	/********************
	*Method Name: createS2SCAPSAttachmentsOnCase
	*Parameter: <oldmap of Case>, <List of Case - Trigger.new>
	*Description: Process Attachments came on case creation or update. Created as part of NOKIASC-27612
	*******************/
	public static void createS2SCAPSAttachmentsOnCase(Map<Id,Case> oldCaseMap, List<Case> caseList){
		CAPS_UpdateToCAPS4NAIPAttachment.processAttachmentOnCase(oldCaseMap,caseList);
	}
	
	/********************
	*Method Name: setFlagForCaseMilestone
	*Parameter: New Case List (Only Case Handling Record Type Records)
	*Description: Used to create/update milestone related flag on Case to start only checked flag Case Milestone.
	*******************/
	public static void setFlagForCaseMilestone(List < Case > caseList, Boolean updateSLAReference) {
		if(caseList != null && !caseList.isEmpty()) {
	Set < Id > accountIds = new Set < Id > ();
	Set < Id > entitlementIds = new Set < Id > ();
	Map < String, Case > caseMap = new Map < String, Case > ();
	Set<String> oSLAIdSet = new Set<String>();
	
	// Prepare Key to search relevant records in CustomerSpecificTargetSLA objects
	for(Case caseObj: caseList) {
		String caseKey = caseObj.EntitlementId;
		accountIds.add(caseObj.AccountId);
		entitlementIds.add(caseObj.EntitlementId);
		if(updateSLAReference) {
			// Reset SLA fields to set new value as per SLA status
			caseObj.CH_SLACritical__c = null;
			caseObj.CH_SLAMajorNonOutage__c = null;
			caseObj.CH_SLAMajorOutage__c = null;
			caseObj.CH_SLAMinor__c = null;
			caseObj.CH_SLAInformationRequest__c = null;			
		}
		else {
			oSLAIdSet.add(caseObj.CH_SLACritical__c); oSLAIdSet.add(caseObj.CH_SLAMajorNonOutage__c); oSLAIdSet.add(caseObj.CH_SLAMajorOutage__c); oSLAIdSet.add(caseObj.CH_SLAMinor__c); oSLAIdSet.add(caseObj.CH_SLAInformationRequest__c);
		}
		// Always reset milestone flags to false (to restart milestones in case of change in criteria)
		caseObj.CH_IsInitialResponseSLA__c = false;
		caseObj.CH_IsSystemRestoredSLA__c = false;
		caseObj.CH_IsServiceDisruptionReportSLA__c = false;
		caseObj.CH_IsTemporarySolutionProvidedSLA__c = false;
		caseObj.CH_IsSolutionProvidedSLA__c = false;
		// Add caseObj in map
		caseMap.put(caseKey, caseObj); 
	}
	//
	List<CH_CustomerSpecificTargetSLA__c> oTargetSLAList = new List<CH_CustomerSpecificTargetSLA__c>();
	if(updateSLAReference) {
		oTargetSLAList = [
			SELECT Id, CH_Account__c, CH_Entitlement__c, CH_LineItemNumber__r.AssetId, CH_Severity__c, CH_Outage__c, CH_IR_Unit__c, CH_IR_WorkMins__c, CH_SR_Unit__c, CH_SR_WorkMins__c, CH_SDR_Unit__c, CH_SDR_WorkMins__c, CH_TSP_Unit__c, CH_TSP_WorkMins__c, CH_SP_Unit__c, CH_SP_WorkMins__c, CH_SPD_Unit__c, CH_SPD_WorkMins__c
			FROM CH_CustomerSpecificTargetSLA__c WHERE CH_Entitlement__c IN :entitlementIds AND CH_SLARecordStatus__c = 'Active'
		];
	} 
	else { oTargetSLAList = [SELECT Id, CH_Account__c, CH_Entitlement__c, CH_LineItemNumber__r.AssetId, CH_Severity__c, CH_Outage__c, CH_IR_Unit__c, CH_IR_WorkMins__c, CH_SR_Unit__c, CH_SR_WorkMins__c, CH_SDR_Unit__c, CH_SDR_WorkMins__c, CH_TSP_Unit__c, CH_TSP_WorkMins__c, CH_SP_Unit__c, CH_SP_WorkMins__c, CH_SPD_Unit__c, CH_SPD_WorkMins__c FROM CH_CustomerSpecificTargetSLA__c WHERE CH_Entitlement__c IN :entitlementIds AND Id IN :oSLAIdSet];
	}
	//
	for(CH_CustomerSpecificTargetSLA__c slaObj: oTargetSLAList) { 
		String slaKey = slaObj.CH_Entitlement__c;
		Case caseObj = caseMap.get(slaKey);
		//Modified Line 387 for NOKIASC-21630 26/08/2019- Suniti
		if((caseObj != null))
		{
	
			if((String.isEmpty(caseObj.CH_LegacyCaseNumber__c)) && caseObj.Severity__c == slaObj.CH_Severity__c && (caseObj.Severity__c == 'Critical' || caseObj.CH_Outage__c == slaObj.CH_Outage__c)) 
			{
	// Intial Response
	if(slaObj.CH_IR_WorkMins__c != null && Integer.valueOf(slaObj.CH_IR_WorkMins__c) > 0) {
		caseObj.CH_IsInitialResponseSLA__c = true;
	}
	// System Restored
	if(slaObj.CH_SR_WorkMins__c != null && Integer.valueOf(slaObj.CH_SR_WorkMins__c) > 0) {
		caseObj.CH_IsSystemRestoredSLA__c = true;
	}
	// Service Disruption Report Provided
	if(slaObj.CH_SDR_WorkMins__c != null && Integer.valueOf(slaObj.CH_SDR_WorkMins__c) > 0) {
		caseObj.CH_IsServiceDisruptionReportSLA__c = true;
	}
	// Temporary Solution Provided	 
	if(slaObj.CH_TSP_WorkMins__c != null && Integer.valueOf(slaObj.CH_TSP_WorkMins__c) > 0) {
		caseObj.CH_IsTemporarySolutionProvidedSLA__c = true;
	}
	// Solution Provided (Non-Defect)
	if(caseObj.CH_Defect__c == false && slaObj.CH_SP_WorkMins__c != null && Integer.valueOf(slaObj.CH_SP_WorkMins__c) > 0) { caseObj.CH_IsSolutionProvidedSLA__c = true;
	} 
	// Solution Provided (Defect)
	else if(caseObj.CH_Defect__c == true && slaObj.CH_SPD_WorkMins__c != null && Integer.valueOf(slaObj.CH_SPD_WorkMins__c) > 0) {
		caseObj.CH_IsSolutionProvidedSLA__c = true;
	}
			}
			//Merged 2 if blocks as code is duplicate NOKIASC-31960
			if( updateSLAReference == true) 
			{
	// Update SLA Field on Case Object
	if(slaObj.CH_Severity__c == 'Critical') { 
		caseObj.CH_SLACritical__c = slaObj.Id;
	} else if(slaObj.CH_Severity__c == 'Major' && slaObj.CH_Outage__c == 'No') {
		caseObj.CH_SLAMajorNonOutage__c = slaObj.Id;
	} else if(slaObj.CH_Severity__c == 'Major' && slaObj.CH_Outage__c == 'Yes') {
		caseObj.CH_SLAMajorOutage__c = slaObj.Id;
	} else if(slaObj.CH_Severity__c == 'Minor') { 
		caseObj.CH_SLAMinor__c = slaObj.Id;
	} else if(slaObj.CH_Severity__c == SWS_Constants.IR && slaObj.CH_Outage__c == 'No') {
		caseObj.CH_SLAInformationRequest__c = slaObj.Id;
	}
			}
		
	}
	}	
		}
	}	
	
	/********************
	*Method Name: updateFlagForCaseMilestone
	*Parameter: Old Case Map, New Case List (Only Case Handling Record Type Records)
	*Description: Used to re-calcualte Case Milestone if either Severity or Outage changed.
	*******************/
	public static void updateFlagForCaseMilestone(Map < Id, Case > oldCaseMap, List < Case > oCaseList) {
		if(oCaseList != null && !oCaseList.isEmpty()) {
			List<Case> oCaseListSLAChange = new List<Case>();
			List<Case> oCaseListSLAReset = new List<Case>();
			for(Case oCase: oCaseList) {
	// To only process Case Handling Project Records
	Case oldCase = oldCaseMap.get(oCase.Id);
	if(oldCase != null) {
		if(oldCase.AccountId != oCase.AccountId || 
		oldCase.EntitlementId != oCase.EntitlementId) { oCaseListSLAChange.add(oCase);
		}
		else if(oldCase.Severity__c != oCase.Severity__c || 
		oldCase.CH_Outage__c != oCase.CH_Outage__c ||  
		oldCase.CH_Defect__c != oCase.CH_Defect__c) { oCaseListSLAReset.add(oCase);
		}
	}
			}
			if(!oCaseListSLAChange.isEmpty()) { setFlagForCaseMilestone(oCaseListSLAChange, true);
			}
			if(!oCaseListSLAReset.isEmpty()) { setFlagForCaseMilestone(oCaseListSLAReset, false);
			}
		}
	}
	
	/********************
*Method Name: updateMilestoneCompletionDate
*Parameter: New Case List (Only Case Handling Record Type Records)
*Description: Used to update Case Milestone Completion Date.
*******************/
	public static void updateMilestoneCompletionDate(Map < Id, Case > oldCaseMap, List < Case > caseList) {
		
		List <Case> chCaseList = new List <Case>();
		
		if(caseList != null && !caseList.isEmpty()) {			
			for(Case caseObj: caseList) {
	// To only process Case Handling Project Records
	Case oldCaseObj = oldCaseMap.get(caseObj.Id);
	if(oldCaseObj != null && (oldCaseObj.CH_InitialResponse__c != caseObj.CH_InitialResponse__c || 
		oldCaseObj.CH_SystemRestored__c != caseObj.CH_SystemRestored__c ||
		oldCaseObj.CH_ServiceDisruptionReportProvided__c != caseObj.CH_ServiceDisruptionReportProvided__c || 
		oldCaseObj.CH_TemporarySolutionProvided__c != caseObj.CH_TemporarySolutionProvided__c ||  
		oldCaseObj.CH_SolutionProvided__c != caseObj.CH_SolutionProvided__c)) {
		 chCaseList.add(caseObj);
		}
			}
		
		if(!chCaseList.isEmpty()) {
			Map < Id, Case > newCaseMap = new Map < Id, Case > (chCaseList);
			for(Case caseObj: newCaseMap.values()) {
	Boolean skipSDRMilestone = false; // Used to bypass/skip SDR Milestone (Independent)
	DateTime slaTime = null; // Declared to store temporary value
	Case oldCaseObj = oldCaseMap.get(caseObj.Id);
	//Check if case is of legacy type or not
	if(String.isNotEmpty(caseObj.CH_LegacyCaseNumber__c) && caseObj.CH_LegacyCaseStatus__c == 'Open') {
		// Solution Provided (Legacy)
		if(caseObj.CH_LegacySolutionProvidedTargetDate__c != null) {
			slaTime = caseObj.CH_SolutionProvided__c;
		}
		// Temporary Solution Provided (Legacy)
		if(caseObj.CH_LegacyTemporarySolutionTargetDate__c != null) {
			if(caseObj.CH_TemporarySolutionProvided__c != null) {
	slaTime = caseObj.CH_TemporarySolutionProvided__c;   
			} else  if(slaTime !=null && oldCaseObj.CH_TemporarySolutionProvided__c == null && caseObj.CH_TemporarySolutionProvided__c == null && caseObj.Severity__c !='Minor') {
	caseObj.CH_TemporarySolutionProvided__c = slaTime;  
	caseObj.CH_IsCompleteTemporarySolution__c = true; 
			}	
		}
		// System Restored
		if(caseObj.CH_LegacySystemRestoredTargetDate__c != null) {
			if(caseObj.CH_SystemRestored__c == null) {
	slaTime = caseObj.CH_SystemRestored__c;
			} else if(oldCaseObj.CH_SystemRestored__c == null && caseObj.CH_SystemRestored__c == null) {
	caseObj.CH_SystemRestored__c = slaTime; 
			}	
		}
		// Initial Response
		if(caseObj.CH_LegacyInitialResponseTargetDate__c != null && oldCaseObj.CH_InitialResponse__c == null && caseObj.CH_InitialResponse__c == null) {
			caseObj.CH_InitialResponse__c = slaTime;	
		}
	} else {
	if(caseObj.CH_IsSolutionProvidedSLA__c && caseObj.CH_SolutionProvided__c != null) {
		slaTime = caseObj.CH_SolutionProvided__c;
		skipSDRMilestone = true;
	}
	// Temporary Solution Provided **
	if(!caseObj.CH_TemporarySolutionNotApplicable__c && caseObj.CH_IsTemporarySolutionProvidedSLA__c) {		 
		if(caseObj.CH_TemporarySolutionProvided__c != null) { 
			slaTime = caseObj.CH_TemporarySolutionProvided__c; 
		} else if(slaTime !=null  && oldCaseObj.CH_TemporarySolutionProvided__c == null && caseObj.CH_TemporarySolutionProvided__c == null) {
			caseObj.CH_TemporarySolutionProvided__c = slaTime;  
			caseObj.CH_IsCompleteTemporarySolution__c = true; 
		}
		skipSDRMilestone = true;
	}
	// Service Disruption Report Provided
	if(caseObj.CH_IsServiceDisruptionReportSLA__c && !skipSDRMilestone) {
		if(caseObj.CH_ServiceDisruptionReportProvided__c != null) {
			slaTime = caseObj.CH_ServiceDisruptionReportProvided__c;
		} else if(oldCaseObj.CH_ServiceDisruptionReportProvided__c == null && caseObj.CH_ServiceDisruptionReportProvided__c == null) {
			caseObj.CH_ServiceDisruptionReportProvided__c = slaTime;	
		}
	} 
	// System Restored
	if(caseObj.CH_IsSystemRestoredSLA__c) {
		if(caseObj.CH_SystemRestored__c != null) {
			slaTime = caseObj.CH_SystemRestored__c;  
		} else if(oldCaseObj.CH_SystemRestored__c == null && caseObj.CH_SystemRestored__c == null) {
			caseObj.CH_SystemRestored__c = slaTime; 
		}   
	}
	// Initial Response
	if(caseObj.CH_IsInitialResponseSLA__c && oldCaseObj.CH_InitialResponse__c == null && caseObj.CH_InitialResponse__c == null) {
		caseObj.CH_InitialResponse__c = slaTime;
	}
} 
			}   
			if(milestones == null){
	milestones = new list<CaseMilestone>([SELECT Id, CompletionDate, CaseId, MilestoneTypeId, MilestoneType.Name FROM CaseMilestone WHERE CaseId IN :newCaseMap.keySet()]);
			}
			List < CaseMilestone > cmList = milestones; // Used singleton pattern to avoid querying again 
			if(cmList != null && !cmList.isEmpty()) {
	for(CaseMilestone cmObj: cmList) {
		Case caseObj = newCaseMap.get(cmObj.CaseId);
		if(caseObj != null && String.isNotBlank(cmObj.MilestoneTypeId)) {
			if(cmObj.MilestoneType.Name == System.Label.CH_InitialResponse) {
	cmObj.CompletionDate = caseObj.CH_InitialResponse__c;
			} else if(cmObj.MilestoneType.Name == System.Label.CH_SystemRestored) {
	cmObj.CompletionDate = caseObj.CH_SystemRestored__c;
			} else if(cmObj.MilestoneType.Name == System.Label.CH_ServiceDisruptionReportProvided) {
	cmObj.CompletionDate = caseObj.CH_ServiceDisruptionReportProvided__c;
			} else if(cmObj.MilestoneType.Name == System.Label.CH_TemporarySolutionProvided) {
	cmObj.CompletionDate = caseObj.CH_TemporarySolutionProvided__c;
	if(!caseObj.CH_TemporarySolutionNotApplicable__c && caseObj.CH_IsTemporarySolutionProvidedSLA__c && caseObj.CH_TemporarySolutionProvided__c == null &&  caseObj.CH_SolutionProvided__c!=null ){
		cmObj.CompletionDate = caseObj.CH_SolutionProvided__c;
	}
			} else if(cmObj.MilestoneType.Name == System.Label.CH_SolutionProvidedNonDefect) {
	cmObj.CompletionDate = caseObj.CH_SolutionProvided__c;
			} else if(cmObj.MilestoneType.Name == System.Label.CH_SolutionProvidedDefect) {
	cmObj.CompletionDate = caseObj.CH_SolutionProvided__c;
			} else if(cmObj.MilestoneType.Name == System.Label.CH_LegacyInitialResponse) {
	cmObj.CompletionDate = caseObj.CH_InitialResponse__c;
			} else if(cmObj.MilestoneType.Name == System.Label.CH_LegacySystemRestored) {
	cmObj.CompletionDate = caseObj.CH_SystemRestored__c;
			} else if(cmObj.MilestoneType.Name == System.Label.CH_LegacyTemporarySolutionProvided) {
	cmObj.CompletionDate = caseObj.CH_TemporarySolutionProvided__c;
			} else if(cmObj.MilestoneType.Name == System.Label.CH_LegacySolutionProvided) {
	cmObj.CompletionDate = caseObj.CH_SolutionProvided__c;
			} else if(cmObj.MilestoneType.Name == System.Label.CH_SolutionDeferred) {
	cmObj.CompletionDate = caseObj.CH_SolutionProvided__c;
			}
		}
	}
	try {
		update cmList;
	} catch(Exception ex) {
	//This is empty
	}
			}	
		}		
	}	 
	}
	
	/********************
*Method Name: validateServiceCaseCreation
*Parameter: New Case List (Only Case Handling Record Type Records)
*Last updated by: TSALEM (2018.08.09)
*Description: Method to validate the creation of a Case Handling Support Ticket (check for authorised contact, authorised entitlements, etc.
*	  User Story: NOKIASC-494
*******************/
	public static void validateServiceCaseCreation(List < Case > newCaseList, Map <Id,Case> oldCaseMap) {
		// Check if there are any CH type cases in the new list
		if (newCaseList != null && !newCaseList.isEmpty()) {
			List < Case > chCaseList = new List < Case > ();
			//Process the list of CH specific cases
			for (Case c: newCaseList) {
	//If Asset and Entitlement are selected - check that Contact is authorised
	if(c.AssetId != null && c.ContactId != null && c.EntitlementId != null && c.CH_ServiceType__c != SWS_Constants.ServiceTypeIS && (oldCaseMap.isEmpty() || (!oldCaseMap.isEmpty() && c.ContactId != oldCaseMap.get(c.Id).ContactId))) {
		chCaseList.add(c);
	}
			}
			if(!chCaseList.isEmpty()) {
	checkAuthorisedContact(chCaseList);	
			}	 
		}
	}
	
	/********************
*Method Name: checkAuthorisedContact
*Parameter: New Case List (Only Case Handling Record Type Records)
*Last updated by: TSALEM (2018.11.18)
*Description: Method to validate individual Case if Asset and entitlement are selected - check if contact is authorised on Contract
*	  User Story: NOKIASC-494
*******************/
	@testVisible
	private static void checkAuthorisedContact(List < Case > chCaseList) {
		Set < Id > entitlementIds = new Set < Id > ();
		Set < Id > contactIds = new Set < Id > ();	  
		for(Case caseObj: chCaseList) {
			entitlementIds.add(caseObj.EntitlementId);
			contactIds.add(caseObj.ContactId);
		}
		
		// Check if the Entitlement on the Case belongs to the Asset on the Case - raise error if incorrect
		//Using Global/Common query as part of Code Optimization -- 27618 --> By Satya Pagadala
		Map<Id, Entitlement> entitlementMap = CH_Utils.getentitlementMap(entitlementIds);		
		Map < Id, List < EntitlementContact>> contactEntMap = new Map < Id, List < EntitlementContact>> ();
		for(EntitlementContact entContactObj: [SELECT Id, EntitlementId, Entitlement.ServiceContractId, ContactId FROM EntitlementContact WHERE ContactId IN :contactIds]) {
			if(contactEntMap.get(entContactObj.ContactId) != null) {
	contactEntMap.get(entContactObj.ContactId).add(entContactObj);
			} else {
	contactEntMap.put(entContactObj.ContactId, new List < EntitlementContact >  { entContactObj });
			}	 
		}
		List < Case > notCoveredCases = new List < Case > ();
		List < Case > notAuthorizedCases = new List < Case > (); 
		for(Case caseObj: chCaseList) {
			if(entitlementMap.get(caseObj.EntitlementId) != null) {
	Entitlement entObj = entitlementMap.get(caseObj.EntitlementId);
	if(caseObj.AssetId == entObj.AssetId) {
		if(contactEntMap.get(caseObj.ContactId) != null) {
			Boolean isAuthorizedContact = false;
			for(EntitlementContact entContactObj: contactEntMap.get(caseObj.ContactId)) {
	if(entObj.ContractLineItem.ServiceContractId == entContactObj.Entitlement.ServiceContractId){
		isAuthorizedContact = true;
		break;
	}   
			} 
			if(!isAuthorizedContact) {
	notAuthorizedCases.add(caseObj);
			}
		} else {
			notAuthorizedCases.add(caseObj);
		}
	} else {
		notCoveredCases.add(caseObj);
	}
			} else {
	notCoveredCases.add(caseObj);
			}
		}	
		if(!notCoveredCases.isEmpty()) {
			for(Case cObj: notCoveredCases) {
			//Ref: NOKIASC-36332 Replaced Error Message With Custom Label
	cObj.addError(System.Label.CH_Entitlement_Do_Not_Cover_Asset);
			}	 
		} 
		if(!notAuthorizedCases.isEmpty()) {
			for(Case cObj: notAuthorizedCases) {
	if(String.isBlank(cObj.CH_LegacyCaseNumber__c)){
		//Ref: NOKIASC-36332 Replaced Error Message With Custom Label
		cObj.addError(System.Label.CH_Contact_Not_Authorised);
	}	
			}	 
		}
	}		
	
	/*****Scrambling Logic****/
	/***************************************************************** 
	Description:  Logic to fetch the Case fields and recordtype values.
	Returns: void 
	History	
	DATE	 AUTHOR		Change	 Description
	03/08/2018	 Praveenkumar	 Created 
	03/09/2018	 tiago.almeida@nokia.com	  Updated 
	24/02/2021	 Gopi Krishna	 Updated	Remove SOQL statement to retrieve the Custom Metadata for US-34697 and 
	 updated the version to 51.
	*****************************************************************/ 
	public static void fetchCaseFields(List < Case > newCaseList, Map < Id, Case > oldCaseMap) {
		List < String > fieldNameList = new List < String > ();
		Map<string,CH_CaseFieldValues__mdt> csvObjMap = CH_CaseFieldValues__mdt.getAll();
		if(!csvObjMap.isEmpty()){
		for(CH_CaseFieldValues__mdt csvObj : csvObjMap.values())//[SELECT CH_FieldNames__c FROM CH_CaseFieldValues__mdt])
		{
			fieldNameList.add(csvObj.CH_FieldNames__c);
		}
		}
		for(Case caseObj: newCaseList) {
			scramblingLogic(caseObj, oldCaseMap != null && oldCaseMap.containsKey(caseObj.Id)?oldCaseMap.get(caseObj.Id):null, fieldNameList);
		}
	}
	
	/***************************************************************** 
	Description:  Logic to check the Case fields with the pattern match and replaced with blockng characters.
	Returns: void 
	History	
	DATE	 AUTHOR		Change 
	03/08/2018	 Praveenkumar	 Created 
	03/09/2018	 tiago.almeida@nokia.com	  Updated 
	*****************************************************************/
	public static void scramblingLogic(Case newCaseObj, Case oldCaseObj, List < String > fieldsList) {
		for (String fieldName: fieldsList) {
			if(fieldName != null && caseFieldMap.containskey(fieldName)){
	String oldFieldValue = oldCaseObj != null?String.valueof(oldCaseObj.get(fieldName)):'';
	String fieldValue = newCaseObj != null?String.valueof(newCaseObj.get(fieldName)):'';
	if(fieldValue != null && fieldValue != '' && fieldValue != oldFieldValue) {
		Schema.DisplayType fieldDataType = caseFieldMap.get(fieldName).getDescribe().getType();
		if(fieldDataType == Schema.DisplayType.TextArea || fieldDataType == Schema.DisplayType.String){
			newCaseObj.put(fieldName, CH_SecurityUtils.scrambleText(fieldValue));
		}
	}
			}   
		}
	}
	/*****Scrambling Logic Ends****/
	
	/********************
	*Method Name: updateProductDetails
	*Parameter: New Case List (Only Case Handling Record Type Records)
	*Last updated by: Pratesax
	*Description: Method to populate product related details on Case as per Asset added.
	*User Story: NOKIASC- 494
	*Modified : Rajeshwari : Modified code as part of NOKIASC-22449 - Aug 8 2019
	*******************/
	public static void updateProductDetails(List<Case> caseList){ 
		if(caseList!=null && !caseList.isEmpty()){
			Set < Id > assetIds = new Set < Id > ();
			Set < Id > productID = new Set < Id > ();//NOKIASC-22449
			map<string, string> productDataUsageMap = new map<string, string> ();
			for(Case c : caseList){
	productID.add(c.ProductId);
	// If the asset id is blank (or made blank) then delete the entitlement
	if (c.AssetId == null) {
		c.EntitlementId = null;
	} else {
		assetIds.add(c.AssetId);
	}
	if (c.CH_NetworkElementAsset__c != null) { assetIds.add(c.CH_NetworkElementAsset__c);
	}
			} 
			//Raji --NOKIASC-22449
			if(!productID.isempty()){
	productDataUsageMap = CH_ProductProblemCreationController_COE.getProductDataUsage(productId);
			}
			// Get all assets -- Only if required
			if(!assetIds.isEmpty()) {   
	// Get all asset by executing 1 query
	//Using Global/Common query as part of Code Optimization --> 27616 --> By Satya Pagadala
	Map < Id, Asset > assetMap = CH_Utils.getAssetMap(assetIds);
	for(Case c: caseList){
		// Miguel Silva - Added AssetId check to fix NOKIASC-24284 and NOKIASC-24278
		if(c.AssetId != null){
			Asset oAsset = assetMap.get(c.AssetId);
			Asset oNEA = c.CH_NetworkElementAsset__c != null ? assetMap.get(c.CH_NetworkElementAsset__c) : null;
			c.ProductId = oAsset.Product2Id;
			c.CH_Solution__c = oAsset.CH_Solution__c != null ? oAsset.CH_Solution__c : (oNEA != null ? oNEA.CH_Solution__c : null);	  
			c.CH_ProductVariant__c = oAsset.CH_ProductVariant__c != null ? oAsset.CH_ProductVariant__c : (oNEA != null ? oNEA.CH_ProductVariant__c : null);
			//TSALEM: this is the suggested additional line of code from https://yoursl.atlassian.net/browse/NOKIASC-10817 (just make sure to add the new real field name)
			c.CH_ProductName__c = oAsset.Product2Id;
			c.CH_Product_Release__c  = oAsset.CH_ProductRelease__c;  
			c.Country__c = oAsset.CH_CountryISOName__c; 
			//Raji --NOKIASC-22449
			c.CH_RDInterface__c = productDataUsageMap.get(c.ProductId);
		}
	}
			}else if(!productID.isempty()){ //Raji --NOKIASC-22449
	for(Case c : caseList){
		 c.CH_RDInterface__c = productDataUsageMap.get(c.ProductId);
		 // Update the Product for Problem Record type -- NOKIASC-25795  
		 c.CH_ProductName__c = c.ProductId;
	}  
			}
	
		}
	}
	
	/****************************************
	* Method Name : CH_BlacklistCaseReportTrigger 
	* Created Date: 8/3/2018
	* Created By : TCS
	* JIRA NO.: NOKIASC-1232
	* Last Modified by: TCS
	* Description : Filtering the Case records based on the different criterias
	*****************************************/
	public static void CH_BlacklistCaseReportTrigger(List < Case > caseList){
		
		Map < Id, String > caseAccountMap = new Map < Id, String > ();		
		Map < Id, Account > accountMap = new Map < Id, Account> (); 
		Set < Id > accIds = new Set < Id > ();
	
		Set < Id > productIds = new Set < Id > ();	 
		List < String > listOfAccNames = new List < String > ();
		List < String > listOfPrdCodes = new List < String > ();	
		Map < Id, String > caseProdMap = new Map < Id, String > ();
		Map < Id, Product2 > productMap = new Map < Id, Product2> ();
		List < CH_BlacklistRecords__c > lBlockRecords = CH_BlacklistRecords__c.getAll().values();
		for(Case caseRecord: caseList){
			//String recordTypeName = Schema.SObjectType.Case.getRecordTypeInfosById().get(caseRecord.recordtypeid).getname();
			//Commenting the below code as part of code optimization where recordtype is already being checked in CH_CaseTriggerHandler
	 
	accIds.add(caseRecord.accountid);
	productIds.add(caseRecord.ProductId);	  
		}
		if(AccIds != null){
	 //Using Global/Common query as part of Code Optimization -- 27615 --> By Satya Pagadala
			accountMap = CH_Utils.getAccountMap(accIds);
		}
		if(productIds != null){
			//Using Global/Common query as part of Code Optimization -- 27616 --> By Satya Pagadala
			productMap = CH_Utils.getProductMap(productIds);
		}
		
		if(!caseList.isEmpty()){ 
			for(Case caseNewRec:caseList){  
	if(caseNewRec.Status != 'Cancelled' && caseNewRec.Status != 'Draft')
		caseNewRec.CH_BlockCases__c = false;
	if(accountMap.containsKey(caseNewRec.Accountid)){
		if((caseNewRec.accountId != null) && (accountMap.get(caseNewRec.Accountid).CountryCode__c == null 
	 ||(accountMap.get(caseNewRec.AccountId).CountryCode__c != null 
	 && accountMap.get(caseNewRec.AccountId).CountryCode__c == 'WF'))){
	  caseNewRec.CH_BlockCases__c = true;
	  
	 }		 
		if(caseNewRec.AccountId != null && accountMap.get(caseNewRec.AccountId).Name != null){	
			String accName=accountMap.get(caseNewRec.AccountId).Name;
			caseAccountMap.put(caseNewRec.Id, accName);
		} 
	}   
	  
			}
		}   
		if(!caseList.isEmpty()){ 
			for(Case caseNewRec:caseList){
	if(productMap.containsKey(caseNewRec.ProductID) && caseNewRec.ProductID != null && productMap.get(caseNewRec.ProductId).ProductCode != null){
		String prodCods=productMap.get(caseNewRec.ProductId).ProductCode;   
			caseProdMap.put(caseNewRec.Id, prodCods);
	} 
			}
		}
		if(lBlockRecords!= null) {
			for(CH_BlacklistRecords__c blockRecs : lBlockRecords){
	if(blockRecs.CH_AccountNames__c <> null){
		listOfAccNames.add(blockRecs.CH_AccountNames__c);		
	}
	if(blockRecs.CH_ProductCodes__c <> null){
		listOfPrdCodes.add(blockRecs.CH_ProductCodes__c);	
	}
			}
		}	 
		for(Case caseUpdRec:caseList){
			if((listOfAccNames != null && listOfPrdCodes != null) && (listOfAccNames.contains(caseAccountMap.get(caseUpdRec.Id)) 
		  || listOfPrdCodes.contains(caseProdMap.get(caseUpdRec.Id)))){ 
		caseUpdRec.CH_BlockCases__c = true; 
		
		  }
		}	  
		
	}
	
  
	//Changed method to handle single record , as part of US # 27622
	@future
	public static void RouteNewProblems(Id problemCaseId) {
		try{
			CH_CA_Service service = new CH_CA_Service(problemCaseId);
			//Get all passive workgroup members that can be assigned to the problem 
			Set<Id> oWorkgroupMemberIdSet = new Set<Id>();
			for(CH_CA_DTO.WorkgroupMemberDTO workgroupMember : service.getPassiveCaseAssignmentWorkgroupMembers()) {
	if (workgroupMember.type == 'Queue') {
		oWorkgroupMemberIdSet.add(workgroupMember.id);
	}	
			}
			// Assign the case to the first queue
			Map<Id, CH_Workgroup_Member__c> oAssignmentMap = new Map<Id, CH_Workgroup_Member__c>();
			for (CH_Workgroup_Member__c workgroupMember : [
	SELECT Id, CH_Workgroup__c, CH_User__c, Name, CH_Workgroup_Member_Type__c, CH_Queue_Email__c,CH_Workgroup__r.Name
	FROM CH_Workgroup_Member__c WHERE Id IN :oWorkgroupMemberIdSet
			]) {
	oAssignmentMap.put(problemCaseId, workgroupMember);
			}
			if(!oAssignmentMap.isEmpty()) {
	service.assignUser(oAssignmentMap);
			}
		}
		catch(Exception e){ /* Do Nothing */ }
	}
	
	
	 public static void AddoRemoveProblemOwnerForCases(Map < Id, Case > oldCaseMap, List < Case > newCaseList) {
	
		List < Case > processCaseList = new List < Case > ();	
		Set < Id > problemCaseIds = new Set < Id > ();
		Set<Id> problemCaseSet = new Set<Id>();
		for(Case caseObj: newCaseList) {
			if(caseObj.Id !=null && oldCaseMap !=null &&caseObj.CH_Problem__c != oldCaseMap.get(caseObj.Id).CH_Problem__c ){
	processCaseList.add(caseObj);//List to remove existing Problem Owner the Team Members 
	if(caseObj.CH_Problem__c != null){
		problemCaseIds.add(caseObj.CH_Problem__c);//Only Incident Case 
	}
			} else  if(oldCaseMap ==null && caseObj.CH_RouteCase__c && caseObj.RecordTypeId == Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CH_Problem').getRecordTypeId()) {
	
	problemCaseSet.add(caseObj.id);//Only Problem CAse during Case Creation
			}
		}
		if(!processCaseList.isEmpty()) {
			// Delete existing CaseTeamMembers
			List < CaseTeamMember > oldCaseTeamMemberList = [SELECT Id, TeamRoleId FROM CaseTeamMember WHERE ParentId IN:processCaseList and TeamRole.Name = 'Problem Owner'];
			try {
	delete oldCaseTeamMemberList;
			} catch(Exception ex) {
	//This is empty
			}
		}
		// First checking with actual data which needs processing before quering CaseTeamRole
		if(!problemCaseIds.isEmpty()) {
			// Get Problem Owner CaseTeamRole
			List < CaseTeamRole > caseTeamRoleList = [SELECT Id, Name FROM CaseTeamRole WHERE Name = 'Problem Owner'];
			if(caseTeamRoleList != null && !caseTeamRoleList.isEmpty()) {
	Map < Id, Case > problemCaseMap = new Map < Id, Case > (
		[SELECT Id, OwnerId FROM Case WHERE Id IN :problemCaseIds]
	);
	List < CaseTeamMember > caseTeamMemberList = new List < CaseTeamMember > ();
	for(Case caseObj: newCaseList) {		
		if(caseObj.CH_Problem__c != null && problemCaseMap.containsKey(caseObj.CH_Problem__c)) {
			Case problemCaseObj = problemCaseMap.get(caseObj.CH_Problem__c);
			CaseTeamMember caseTeamMemberObj = new CaseTeamMember();
			caseTeamMemberObj.ParentId = caseObj.Id;
			caseTeamMemberObj.MemberId = problemCaseObj.OwnerId;
			caseTeamMemberObj.TeamRoleId = caseTeamRoleList.get(0).Id;
			caseTeamMemberList.add(caseTeamMemberObj);
		}
	}	  
	if(!caseTeamMemberList.isEmpty()) {
		try {
			insert caseTeamMemberList;
		} catch(Exception ex) {
			//This is empty
		}
	}
			}  
		}
		
		//Adding piece of code that does not run when creating a Problem through the flow CH_CreateProblemFromIncidentnProduct (INC5).
		//Adding here to avoid filtering Problems again in a new method. Also added problemCaseList above. Fix for NOKIASC-25486
		List<Id> problemCaseList = new List<Id>(problemCaseSet);
		
		if(problemCaseList.size() > 0){
			RouteNewProblems(problemCaseList[0]);
		}
	
	} 
	/********************
	*Method Name: updateAttchmentinCAPS
	*Author: TCS
	*Parameter: New Case List, Old Case Map
	*Description: Used to handle after status updates to closed
	If Case status is closed, need to update attachments in CAPS as deleted
	* Last Modified by: TCS
	* Last Modified Date: 23 July 2018
	* Description : Delete Attachments in CAPS when Case in cancelled
	* Last Modified: 19-Aug-2018 - TCS - Update other parameters to CAPSVo n update of Case
	*Return: None
	*******************/  
	public static void updateAttchmentinCAPS(Map<Id, Case> oldCaseMap, List<Case> newCaseList) {
		try{ 
			Set<String> attachmentIdSet = new Set<String>();
			Integer combinedListSize = null;
			Map<String, String> caseIdVsCaseStatusMap = new Map<String, String>();
			Map<String, Map<String, String>> caseIdVsMapOfUpdateFieldsMap = new Map<String, Map<String, String>>();
			Map<String, String> caseParamVsUpdateFieldsMap;
			Map<String, Boolean> attahmentIdVsToBeDeletedMap = new Map<String, Boolean>();
			Map<String, Map<String, String>> attachmentIdVsUpdateFieldsMap = new Map<String, Map <String, String>>();
			/*deletion userstory*/ 
			Map<String, String> attachmentidvsdate = new Map<String, String>();
			/*deletion userstory*/ 
			//Integer calloutLimit = CAPS_ConstantHandler.CALL_OUT_LIMIT;
			Boolean statusChange = false;
	 
			for(Case csObj: newCaseList) {
	caseParamVsUpdateFieldsMap = new Map<String, String>();
	if(CH_AvoidRecursion.afterUpdateCAPSCaseStatus && !String.isBlank(csObj.Status) && (CAPS_ConstantHandler.CLOSED_STATUS.equalsignorecase(csObj.Status) || 
		 CAPS_ConstantHandler.CANCELLED_STATUS.equalsignorecase(csObj.Status)) && !(csObj.Status.equalsignorecase(oldCaseMap.get(csObj.Id).Status)))
			
		{//when Case is closed and cancelled
			caseIdVsCaseStatusMap.put(csObj.Id, csObj.Status);
			caseParamVsUpdateFieldsMap.put(CAPS_ConstantHandler.CASESTATUS, csObj.Status);
			statusChange = true;
		}

	//populate only if caseParamVsUpdateFieldsMap is not empty. reinitialized in each iteration
	if(!caseParamVsUpdateFieldsMap.isEmpty()) {
		caseIdVsMapOfUpdateFieldsMap.put(csObj.Id,caseParamVsUpdateFieldsMap);
	}
			}
			if(statusChange){
	CH_AvoidRecursion.afterUpdateCAPSCaseStatus = false;
			}

			if(!caseIdVsMapOfUpdateFieldsMap.isEmpty() && caseIdVsMapOfUpdateFieldsMap.keySet() != null && !caseIdVsMapOfUpdateFieldsMap.keySet().isEmpty()) {//get CAPS attachment ids
	combinedListSize = 0;
	for(CH_Attachment__c chAttachment : [SELECT Id, AttachmentID__c, CH_Classification__c, CH_Status__c, Case__c, CH_Uploaded__c  
	 FROM CH_Attachment__c 
	 WHERE Case__c  IN: caseIdVsMapOfUpdateFieldsMap.keySet()   
	 LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]) 
	{
		if(!string.isBlank(chAttachment.CH_Status__c) && !CAPS_ConstantHandler.DELETED_STR.equalsignorecase(chAttachment.CH_Status__c) &&
			chAttachment.AttachmentID__c != null && !attachmentIdSet.contains(chAttachment.AttachmentID__c))
		{
	//call out will be happening inside for loop as CAPS system is seeking attachment Id as end point and in signature. 
	//Check if CAPS can handle bulk update FROM API in single transaction, 
	//else to avoid exception of 100 limit in http call out, add one counter below and take max 99 in below two sets.
	// As per confirmation, need to call out inside loop i.e. invoke API for each attachment.
	if(!caseIdVsCaseStatusMap.isEmpty() && ((CAPS_ConstantHandler.CANCELLED_STATUS.equalsignorecase(caseIdVsCaseStatusMap.get(chAttachment.Case__c))) 
		|| (CAPS_ConstantHandler.CLOSED_STATUS.equalsignorecase(caseIdVsCaseStatusMap.get(chAttachment.Case__c)) 
			&& !String.isBlank(chAttachment.CH_Classification__c) && (chAttachment.CH_Classification__c == CAPS_ConstantHandler.ENDUSER_DATA || 
		  chAttachment.CH_Classification__c == CAPS_ConstantHandler.OTHERSENSITIVE_DATA))))
	{   
		attahmentIdVsToBeDeletedMap.put(chAttachment.AttachmentID__c, true);
		attachmentIdVsUpdateFieldsMap.put(chAttachment.AttachmentID__c, caseIdVsMapOfUpdateFieldsMap.get(chAttachment.Case__c));
		attachmentIdSet.add(chAttachment.AttachmentID__c);// when Case is cancelled or when Case is closed and sensitive attachment
		attachmentidvsdate.put(chAttachment.AttachmentID__c,CAPS_ConstantHandler.RETENTION_DAYS1_STR);
		combinedListSize++;//increment counter
	}
	else if(!caseIdVsCaseStatusMap.isEmpty() && CAPS_ConstantHandler.CLOSED_STATUS.equalsignorecase(caseIdVsCaseStatusMap.get(chAttachment.Case__c)) && 
			(!String.isBlank(chAttachment.CH_Classification__c) && chAttachment.CH_Classification__c == CAPS_ConstantHandler.OTHER_DATA))
	{   
		Integer expectedDeleteDays = chAttachment.CH_Uploaded__c.dateGMT().daysBetween(system.now().dateGMT());
		expectedDeleteDays = CAPS_ConstantHandler.RETENTION_DAYS_730 + expectedDeleteDays;
		attahmentIdVsToBeDeletedMap.put(chAttachment.AttachmentID__c, false);
		attachmentIdVsUpdateFieldsMap.put(chAttachment.AttachmentID__c, caseIdVsMapOfUpdateFieldsMap.get(chAttachment.Case__c));
		attachmentIdSet.add(chAttachment.AttachmentID__c);// when Case is closed and non-sensitive attachment
		attachmentidvsdate.put(chAttachment.AttachmentID__c,string.valueOf(expectedDeleteDays));
		combinedListSize++;//increment counter
	}
	else{
		//Do Nothing
	}
			}
	}   
	if(!attachmentIdSet.isEmpty()) {
		CAPS_Attachment_Delete.updateAllFieldsforTrigger(JSON.serialize(attahmentIdVsToBeDeletedMap), JSON.serialize(attachmentIdVsUpdateFieldsMap), JSON.serialize(attachmentidvsdate));
	}
			}
		} catch(Exception ex) { ExceptionHandler.addException(ex,CAPS_ConstantHandler.cHCAPSCaseTriggerHelper, CAPS_ConstantHandler.updateAttchmentinCAPS);} 
	}
		
	// When a case is assigned to a queue the status of the case will be created 
	// When then assigened to a user from the queue needs to change the status to assigned
	public static void setStatusAfterQueueAssignment(Map<Id,Case> oldCaseList,  List<Case> newCaseList){
		for (Case newCase : newCaseList) {
			Case oldCase = oldCaseList.get(newCase.Id);
			// For the sake of removing SOQL query inside loop! the following 2 lines replace the code commented below them
			// Miguel Silva - Adding Current Queue field check to fix NOKIASC-25519
			if(newCase.status == 'Created' && ((string)oldCase.OwnerId).startsWithIgnoreCase('00G') && ((string)newCase.OwnerId).startsWith('005') && newCase.CH_CurrentQueue__c == '')
	newCase.Status = 'Assigned';
		}
	}
	
	/********************
*Method Name: updateIncidentsDefect
*Author: Marwan Boutaleb (mboutaleb@salesforce.com)
*Parameter: New Case List
*Description:   When the defect checkbox is changed at the level of a problem (case record type) 
*	  the new value should be reflected on all the related incidents (cases) NOKIASC-14381 
*******************/
	public static boolean updateIndidentDefectOnlyOneTime = false;
	
	public static void updateIncidentsDefect(map<id, Case> oldCases, list<Case> newCasesList) {
		Set<Id> prbmIds = new Set<Id>();   // Set of Problem Ids
		map<id, Case> newCases = new map<id, Case>(newCasesList); 
		if(!updateIndidentDefectOnlyOneTime){
			list<Id> eligibleProblemIds = new list<Id>();
			for(Case aCase : newCases.values()){
	if(aCase.CH_RecordTypeDevName__c == 'CH_Problem' && (aCase.CH_Defect__c != oldCases.get(aCase.Id).CH_Defect__c))
		eligibleProblemIds.add(aCase.Id);
	if(aCase.CH_RecordTypeDevName__c != 'CH_Problem' && aCase.CH_Problem__c != null && (aCase.CH_Problem__c != oldCases.get(aCase.Id).CH_Problem__c))
		eligibleProblemIds.add(aCase.CH_Problem__c);
			}
			if(!eligibleProblemIds.isEmpty()){
	list<Case> incidentsToUpdate = new list<Case>();
	list<FeedItem> newChatterPosts = new list<FeedItem>();
	for(Case aCase : [SELECT Id, CaseNumber, CH_Defect__c, CH_Problem__c, CH_Problem__r.CaseNumber, CH_Problem__r.CH_Defect__c FROM Case WHERE CH_Problem__c IN :eligibleProblemIds]){
		if(newCases.containsKey(aCase.CH_Problem__c) && aCase.CH_Defect__c != newCases.get(aCase.CH_Problem__c).CH_Defect__c){
			incidentsToUpdate.add(new Case(Id = aCase.Id, CH_Defect__c = newCases.get(aCase.CH_Problem__c).CH_Defect__c));
			//NOKIASC-38647
			If(aCase.CH_Problem__r.CH_Defect__c == True && aCase.CH_Defect__c == false){
				newChatterPosts.add(new FeedItem( ParentId = aCase.Id,
				Type = 'TextPost',
				Body = 'Defect flag set in alignment with the linked problem.'));
			} else if(aCase.CH_Problem__r.CH_Defect__c == false && aCase.CH_Defect__c == true){
				newChatterPosts.add(new FeedItem( ParentId = aCase.Id,
				Type = 'TextPost',
				Body = 'Defect flag cleared in alignment with the linked problem.'));
			}
		}
			prbmIds.add(aCase.CH_Problem__c);
	}
	if(!newChatterPosts.isEmpty()){
		insert newChatterPosts;
	}
	if(!incidentsToUpdate.isEmpty()){ 
		update incidentsToUpdate; 
		CH_CaseTriggerHelper.updateDefectSolutionTargetAndPausedDate(prbmIds);
	}
			}
			updateIndidentDefectOnlyOneTime = true; 
		}
	}
	/********************
*Method Name: insertIncidentsDefect
*Author: TCS
*Parameter: newCaseList
*Description: NOKIASC-38501
*******************/
	public static void insertIncidentsDefect(list<Case> newCaseList) {
		Set<Id> incidentIds = new Set<Id>();   // Set of Originating Incident Ids
		Set<Id> prblm = new Set<Id>();   // Set of Problem Ids
		list<FeedItem> newChatterPosts = new list<FeedItem>();
		Id problemRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_Problem').getRecordTypeId();
		for (Case newCase: newCaseList) {
			//Fetch Originating Incident Number From Problem
			if (newCase.CH_Originating_Incident_Number__c != null && newCase.RecordTypeId == problemRecordTypeId) {
	incidentIds.add(newCase.CH_Originating_Incident_Number__c);
			}
		}
		//Check if incidentIds have values
		if(!incidentIds.isEmpty()){
			// Map To Retrieve CH_Defect__c from originating Incident
			Map<Id, Case> incidentMap = new Map<Id, Case>([SELECT Id, LastModifiedDate, CaseNumber, CH_AccountNameforNotifications__c, CH_Defect__c, CH_Problem__c, CH_Problem__r.CH_Defect__c, CH_Problem__r.CH_Problem_Category__c FROM Case WHERE Id IN :incidentIds]);
			system.debug(incidentMap);
			list<Case> incidentsToUpdate = new list<Case>();
			for(Case newCase : newCaseList){
	//Check If Case is Problem & compare defect on problem & originating incident
	if(newCase.RecordTypeId == problemRecordTypeId && (newCase.CH_Defect__c != incidentMap.get(newCase.CH_Originating_Incident_Number__c).CH_Defect__c)){
		//Add Originating Incident to incidentsToUpdate List With Defect Same as Problem
		incidentsToUpdate.add(new Case(Id = newCase.CH_Originating_Incident_Number__c, CH_Defect__c = newCase.CH_Defect__c));
		prblm.add(newCase.Id);
	}
	//
	if(newCase.RecordTypeId == problemRecordTypeId) {
		newChatterPosts.add(new FeedItem(ParentId = newCase.Id, 
				 Type = 'TextPost', 
				 Body = SWS_Constants.Incident + ' ' + incidentMap.get(newCase.CH_Originating_Incident_Number__c).CaseNumber + ' has been related to your Problem.'));
		if(newCase.CH_Defect__c == true){
			newChatterPosts.add(new FeedItem(ParentId = incidentMap.get(newCase.CH_Originating_Incident_Number__c).Id, 
					 Type = 'TextPost', 
					 Body = '#Problem \r\n' + 'The problem ' + newCase.CaseNumber + ' has been associated. \r\n \r\n' + 'Account Name: ' + incidentMap.get(newCase.CH_Originating_Incident_Number__c).CH_AccountNameforNotifications__c + ' \r\n' + 'Case Number: ' + incidentMap.get(newCase.CH_Originating_Incident_Number__c).CaseNumber + ' \r\n' + 'Problem Number: ' +newCase.CaseNumber + ' \r\n' + 'Date and Time: ' + incidentMap.get(newCase.CH_Originating_Incident_Number__c).LastModifiedDate + ' (in User Timezone) \r\n' + 'Defect flag value: true \r\n'));
			if(incidentMap.get(newCase.CH_Originating_Incident_Number__c).CH_Defect__c == false && newCase.CH_Defect__c == true){
				newChatterPosts.add(new FeedItem(ParentId = incidentMap.get(newCase.CH_Originating_Incident_Number__c).Id, 
				Type = 'TextPost', 
				Body = 'Defect flag set in alignment with the linked problem.'));	
			}
		} else if(newCase.CH_Defect__c == false){
			newChatterPosts.add(new FeedItem(ParentId = incidentMap.get(newCase.CH_Originating_Incident_Number__c).Id, 
					 Type = 'TextPost', 
					 Body = '#Problem \r\n' + 'The problem ' + newCase.CaseNumber + ' has been associated. \r\n \r\n' + 'Account Name: ' +  incidentMap.get(newCase.CH_Originating_Incident_Number__c).CH_AccountNameforNotifications__c + ' \r\n' + 'Case Number: ' + incidentMap.get(newCase.CH_Originating_Incident_Number__c).CaseNumber + ' \r\n' + 'Problem Number: ' + newCase.CaseNumber + ' \r\n' + 'Date and Time: ' + incidentMap.get(newCase.CH_Originating_Incident_Number__c).LastModifiedDate + ' (in User Timezone) \r\n' + 'Defect flag value: false \r\n'));
			if(incidentMap.get(newCase.CH_Originating_Incident_Number__c).CH_Defect__c == true && newCase.CH_Defect__c == false){
				newChatterPosts.add(new FeedItem(ParentId = incidentMap.get(newCase.CH_Originating_Incident_Number__c).Id, 
				Type = 'TextPost', 
				Body = 'Defect flag cleared in alignment with the linked problem.'));	
			}
		}
	}
	//
			}
			if(!newChatterPosts.isEmpty()){
	insert newChatterPosts;
			}
			//Update Incidents
			if(!incidentsToUpdate.isEmpty()){
	update incidentsToUpdate;
	CH_CaseTriggerHelper.updateDefectSolutionTargetAndPausedDate(prblm);
			}
		} 
	}
	/********************
*Method Name: updateParentIncident
*Author: Marwan Boutaleb (mboutaleb@salesforce.com)
*Parameter: New Cases List
*Description: When an incident problem lookup is updated, its value is reflected on the parentId case lookup NOKIASC-14380
*******************/
   public static void updateProblemParentIncident(Map < Id, Case > oldCaseMap, list<Case> newCasesList){
		
		for(Case aCase : newCasesList){
			if(aCase.CH_RecordTypeCheck__c && aCase.CH_RecordTypeDevName__c != 'CH_Problem' && oldCaseMap.get(aCase.id).CH_Problem__c != aCase.CH_Problem__c){
	aCase.parentId = aCase.CH_Problem__c;
			}
		}
	
	}
	
	/********************
*Method Name: addProblemChatterPost
*Author: Marwan Boutaleb (mboutaleb@salesforce.com)
*Parameter: Old cases map, New Cases List
*Description: When an incident is related/dissociated from a problem a chatter notification is created on the problem   
*******************/
	public static boolean problemChatterPostRun = false;
	public static void addProblemChatterPost(map<id, Case> oldCases, list<Case> newCasesList){
		Set<Id> caseIds = new Set<Id>();
		map<id, Case> newCases = new map<id, Case>(newCasesList);
		if(!problemChatterPostRun){
			list<Case> incidentsToUpdate = new list<Case>();
			list<FeedItem> newChatterPosts = new list<FeedItem>();
			for(Case aCase : newCases.values()){
	caseIds.add(aCase.Id);
			}
			for(Case aCase : [SELECT Id, CaseNumber, LastModifiedDate, CH_Problem__c, CH_RecordTypeDevName__c, CH_RecordTypeCheck__c, CH_AccountNameforNotifications__c, CH_Defect__c, CH_Problem__r.CaseNumber, CH_Problem__r.CH_Defect__c, CH_Problem__r.CH_Problem_Category__c FROM Case WHERE Id IN :caseIds]){
	if(aCase.CH_Problem__c != oldCases.get(aCase.Id).CH_Problem__c && aCase.CH_RecordTypeCheck__c == true && aCase.CH_RecordTypeDevName__c != 'CH_Problem'){
		if(aCase.CH_Problem__c != null) {
			newChatterPosts.add(new FeedItem(ParentId = aCase.CH_Problem__c, 
					 Type = 'TextPost', 
					 Body = SWS_Constants.Incident+' ' + aCase.CaseNumber + ' has been related to your Problem.'));
			if(aCase.CH_Problem__r.CH_Defect__c == true){
				newChatterPosts.add(new FeedItem(ParentId = aCase.Id, 
					 Type = 'TextPost', 
					 Body = '#Problem \r\n' + 'The problem ' + aCase.CH_Problem__r.CaseNumber + ' has been associated. \r\n \r\n' + 'Account Name: ' + aCase.CH_AccountNameforNotifications__c + ' \r\n' + 'Case Number: ' + aCase.CaseNumber + ' \r\n' + 'Problem Number: ' + aCase.CH_Problem__r.CaseNumber + ' \r\n' + 'Date and Time: ' + aCase.LastModifiedDate + ' (in User Timezone) \r\n' + 'Defect flag value: true \r\n'));
				if(aCase.CH_Defect__c == false && aCase.CH_Problem__r.CH_Defect__c == true){
		incidentsToUpdate.add(new Case(Id = aCase.Id, CH_Defect__c = true));
		newChatterPosts.add(new FeedItem(ParentId = aCase.Id, 
					 Type = 'TextPost', 
					 Body = 'Defect flag set in alignment with the linked problem.'));	
				}
			} else if(aCase.CH_Problem__r.CH_Defect__c == false){
				newChatterPosts.add(new FeedItem(ParentId = aCase.Id, 
					 Type = 'TextPost', 
					 Body = '#Problem \r\n' + 'The problem ' + aCase.CH_Problem__r.CaseNumber + ' has been associated. \r\n \r\n' + 'Account Name: ' +  aCase.CH_AccountNameforNotifications__c + ' \r\n' + 'Case Number: ' + aCase.CaseNumber + ' \r\n' + 'Problem Number: ' + aCase.CH_Problem__r.CaseNumber + ' \r\n' + 'Date and Time: ' + aCase.LastModifiedDate + ' (in User Timezone) \r\n' + 'Defect flag value: false \r\n'));
				if(aCase.CH_Defect__c == true && aCase.CH_Problem__r.CH_Defect__c == false){
		incidentsToUpdate.add(new Case(Id = aCase.Id, CH_Defect__c = false));
		newChatterPosts.add(new FeedItem(ParentId = aCase.Id, 
					 Type = 'TextPost', 
					 Body = 'Defect flag cleared in alignment with the linked problem.'));	
				}
			}
		}
		if(oldCases.get(aCase.Id).CH_Problem__c != null) {
			newChatterPosts.add(new FeedItem(ParentId = oldCases.get(aCase.Id).CH_Problem__c, 
					 Type = 'TextPost', 
					 Body = SWS_Constants.Incident+' '+ aCase.CaseNumber + ' has been disassociated from your Problem.'));
		}
		// Created the Chatter Post for NOKIASC-27235
		if(oldCases.get(aCase.Id).CH_Problem__c != null && aCase.CH_Problem__c == null) {
			newChatterPosts.add(new FeedItem(ParentId = aCase.Id, 
					 Type = 'TextPost', 
					 Body = SWS_Constants.Incident+' ' + aCase.CaseNumber + ' has been disassociated from your Problem.'));
		}
	}
			}
			if(!newChatterPosts.isEmpty()){
	insert newChatterPosts;
			}
			//Update Incidents
			if(!incidentsToUpdate.isEmpty()){
	update incidentsToUpdate;
			}
			problemChatterPostRun = true; 
		} 
	}
	
	public static void addCCMToCaseTeam(List <Case> updatedCasesList){
		if(!updatedCasesList.isEmpty()){
			Id problemRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CH_Problem').getRecordTypeId();
			List <Case> incidentsList = new List <Case>();
			for (Case caseObj : updatedCasesList){
	if(caseObj.RecordTypeId != problemRecordTypeId){
		incidentsList.add(caseObj);
	}
			}
			// Insert Customer Care Manager on Case Team for Incidents sync
			if(!incidentsList.isEmpty() && incidentsList != null){
	new CH_CA_CaseTeam().insertCustomerCareManager(incidentsList);
			}
		}
	}
	
	// NOKIASC-27602 Code Opt - Miguel Silva - Moving addMembersToCaseTeam logic to assync
	public static void addMembersToCaseTeamWrapper(List <Case> updatedCasesList) {
		if(!updatedCasesList.isEmpty()){
			Id problemRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CH_Problem').getRecordTypeId();
			Set<Id> incidentIds = new Set<Id>();
			List <Case> syncList = new List <Case>();
			Map<Id, String> chatterMap = new Map<Id, String>();
			String body = 'Case Team Member assignment process has started.';
			//Building list without problems for CCM sync add
			for (Case caseObj : updatedCasesList){
	if(caseObj.CH_Workgroup__c != null){
		if(caseObj.RecordTypeId != problemRecordTypeId){
			if(CH_AvoidRecursion.runAfterInsertOnce()){
	incidentIds.add(caseObj.id);
			}else{
	syncList.add(caseObj);
			}
			incidentIds.add(caseObj.id);
		}else{
			syncList.add(caseObj);
		}
		chatterMap.put(caseObj.id, body);
	}
			}
			// Run Case Team logic for Incidents async
			if(!incidentIds.isEmpty() && incidentIds != null){
	addMembersToCaseTeamAssync(incidentIds);
			}
			
			// Run Case Team logic for sync Cases
			if(!syncList.isEmpty() && syncList != null){
	addMembersToCaseTeam(syncList);
			}
			// Create chatter notifications for all CH Record Types
			if(!chatterMap.isEmpty() && chatterMap != null){
	CH_CA_Notifications.postToChatter(chatterMap);
			}
		}
	}
	
	// NOKIASC-27602 - Miguel Silva - Moving addMembersToCaseTeam logic to assync
	@future
	public static void addMembersToCaseTeamAssync(Set <Id> updatedCasesIds) {
		if(updatedCasesIds != null && !updatedCasesIds.isEmpty()){
			List<Case> updatedCases = [Select id, CH_SecurityGroup__c, CH_GWC_SecurityGroup__c,CH_Workgroup__c,
			CH_3rdPartySecurityGroup__c, RecordTypeId, EntitlementId
			from Case where id in :updatedCasesIds];
			addMembersToCaseTeam(updatedCases);
		}
	}
	
   
	// After a case is created, persons need to be added to the case team so that the agent can contact 
	// people if needed. This is before the case is assigned.
	// NOKIASC-27602 - Miguel Silva - Moving addMembersToCaseTeam logic to assync
	public static void addMembersToCaseTeam(List<Case> updatedCases) {
		if(updatedCases != null && !updatedCases.isEmpty()){
	new CH_CA_CaseTeam().addTeamMembers(updatedCases);
		}
	}
	
	public static void populateCaseEntitlement(list<Case> cases){
		if(UserInfo.getUserType() == 'PowerCustomerSuccess'){
			set<Id> assetIds = new set<Id>();
			for(Case aCase : cases){
	if(aCase.assetId != null && aCase.entitlementId == null){
		assetIds.add(aCase.assetId);
	}
			}
			if(!assetIds.isEmpty()){ 
	map<Id,Id> assetEntit = new map<Id,Id>();
	for(ContractLineItem scli : [SELECT CH_Entitlement__c, AssetId FROM ContractLineItem WHERE assetId IN :assetIds AND CH_Entitlement__r.status = 'Active']){
		assetEntit.put(scli.AssetId, scli.CH_Entitlement__c);
	}
	for(Case aCase : cases){
		if(aCase.assetId != null && aCase.entitlementId == null && assetEntit.containsKey(aCase.assetId)){
			aCase.entitlementId = assetEntit.get(aCase.assetId);
		}
	}
			}   
		}
	}
	
 
	/********************
*Method Name: populateS2SCases
*Parameter: New Case List
*Description: Used to populate S2S Cases with references
*******************/
	public static void populateS2SCases(List<Case> cases) {
		if (!cases.isEmpty()) {
			Map<Id, Account> accounts = new Map<Id, Account>();
			Map<Id, Entitlement> entitlements = new Map<Id, Entitlement>();
			Map<Id, Product2> products = new Map<Id, Product2>();
			Map<Id, CH_ProductRelease__c> releases = new Map<Id, CH_ProductRelease__c>();
			Map<Id, Asset> assets = new Map<Id, Asset>();

			List<Case> uniqueRefNumberCases = CH_ExternalInterfaceUTIL.isolateUniqueRefNumCases(cases);
			CH_ExternalInterfaceUTIL.rejectInvalidS2SCases(uniqueRefNumberCases);
			CH_ExternalInterfaceUTIL.populateCaseHandlingCases(uniqueRefNumberCases, accounts, products, releases, assets, entitlements);
			CH_ExternalInterfaceUTIL.createCaseContactIfNotExisting(uniqueRefNumberCases, accounts);
			CH_ExternalInterfaceUTIL.createEntitlementContactsIfNotExisting(uniqueRefNumberCases, accounts, entitlements);
		}
	}

	/********************
*Method Name: handleUpdatesS2SCases
*Parameter: New Case List
*Description: Used to populate S2S Cases with references
*******************/
	public static void handleUpdatesS2SCases(Map<Id, Case> oldCases, List<Case> cases) {
		if (CH_ExternalInterfaceUTIL.isExternalSoapRequest()) {
			// for notification of updates from the external system
			CH_ExternalInterfaceUTIL.updatedFromExternalInterface(oldCases, cases);
		} else {
			// send updates of some fields to external system
			List<Case> casesWithOriginSystem = CH_ExternalInterfaceUTIL.filterS2SCasesWOriginSystem(cases);
			List<Case> availableForS2SOutboundMessageCases = CH_ExternalInterfaceUTIL.isolateS2SbyStage(casesWithOriginSystem);

			CH_ExternalInterfaceUTIL.sendStatusUpdatesToExternalSystem(oldCases, availableForS2SOutboundMessageCases);
			CH_ExternalInterfaceUTIL.sendFieldUpdatesToExternalSystem(oldCases, availableForS2SOutboundMessageCases);
			CH_ExternalInterfaceUTIL.sendCancelationToExternalSystem(oldCases, availableForS2SOutboundMessageCases);
			//Commented to fix NOKIASC-28529 - Vinod C
			//CH_ExternalInterfaceUTIL.sendSeverityUpdatesToExternalSystem(oldCases, cases);
		}
	}
	

	public static boolean caseRecordtypeChanged(Map < Id, Case > oldCaseMap, List < Case > newCaseList){
		for(Case aCase : newCaseList) if(aCase.recordTypeId != oldCaseMap.get(aCase.Id).recordTypeId ) return true;
		return false;
	}
	
	public static void debuggingLimits(string message){
		System.debug(Logginglevel.ERROR,'#################################################');
		System.debug(Logginglevel.ERROR,'#' + message);
		System.debug(Logginglevel.ERROR, '#CPU:	 ' + Limits.getCpuTime() + '/' + Limits.getLimitCpuTime());
		System.debug(Logginglevel.ERROR, '#Queries: ' + Limits.getQueries() + '/' + Limits.getLimitQueries());
		System.debug(Logginglevel.ERROR, '#Rows:	' + Limits.getQueryRows() + '/' + Limits.getLimitQueryRows());
		System.debug(Logginglevel.ERROR, '#DMLRows: ' + Limits.getDMLRows() + '/' + Limits.getLimitDMLRows());
		System.debug(Logginglevel.ERROR, '#DMLStat: ' + Limits.getDMLStatements() + '/' + Limits.getLimitDMLStatements());
		System.debug(Logginglevel.ERROR,'#################################################');
	}
	
	/********************
	/*Method Name: queueSecurityGroupsCheckOwnerChange
	*Parameter: CaseList, oldCaseMap
	*Last updated by: Salesforce
	*Description: CH Cases cannot be assigned to a queue. 
		CH cases user owners must belong to a public group that its name matches the security group field on the case level
	*User Story: NOKIASC-15001
	****************/
	public static void queueSecurityGroupsCheckOwnerChange(List<Case> caseList, Map < Id, Case > oldCaseMap) {
		
		// Get only CH cases for which the owner has been changed
		List<Case> eligibleNewCaseList = new List<Case>();
		for(Case oCase: caseList)
			//NOKIASC-32495 :HWS cases user owners must belong to a public group that its name matches the security group field on the case level
			if((oCase.CH_RecordTypeCheck__c || oCase.HWS_RecordTypeCheck__c) && !oCase.OwnerId.equals(oldCaseMap.get(oCase.Id).OwnerId)){
	 eligibleNewCaseList.add(oCase);  
			}
	
			
		if(!eligibleNewCaseList.isEmpty()){
			
			List<Group> gwcRec = [select name from Group where name = 'GWC' and type = 'queue' limit 1];
			string gwcQueue = gwcRec[0].Id;
			
			// Owner check should be applied only for CH profiles
			Profile profiledet = [Select Name from Profile where Id =: userinfo.getProfileid()];
			String pname = profiledet.name;
			if(pname == 'CH_Agent' || pname == SWS_Constants.BasicCH || pname == SWS_Constants.CH || pname == SWS_Constants.SysAdmin || pname == 'Customers' || pname == SWS_Constants.CustomerLogin || pname == SWS_Constants.IntegrationAPIOnly){
	// Get a set of new case owners
	Set<Id> usrIds = new Set<Id>();
	for(Case aCase: eligibleNewCaseList){
		if(string.valueOf(aCase.OwnerId).startsWith('005'))
			usrIds.add(aCase.OwnerId);
		// Queues cannot own cases!
		if(string.valueOf(aCase.OwnerId).startsWith('00G') && aCase.OwnerId != gwcQueue)
			aCase.addError(ERROR_MESSAGE2);
	}
	
	if(!usrIds.isEmpty()){
		// Get user names and profile name to be displayed/Chekcing on the error message
		map<Id, User> users = new map<Id, User>([SELECT name , Profile.Name FROM user where id IN :usrIds]);
		// Get for each user a list of names of all the public group names that the user is memeber of
		Map<id, List<string>> userPgroups = new map<id, List<string>>();
		for(GroupMember gMember :[SELECT UserOrGroupId, group.Name FROM GroupMember WHERE UserOrGroupId IN :usrIds]){
			if(userPgroups.containsKey(gMember.UserOrGroupId)) 
	userPgroups.get(gMember.UserOrGroupId).add(gMember.group.Name);
			else 
	userPgroups.put(gMember.UserOrGroupId, new List<String>{gMember.group.Name});
		}

		for(Case aCase: eligibleNewCaseList){
			if(string.valueOf(aCase.OwnerId).startsWith('005') && !string.isBlank(aCase.CH_GWC_SecurityGroup__c) && !string.isBlank(aCase.CH_SecurityGroup__c)){

	// When the new owner is not assigned to the security group of the case
	if(userPgroups.containsKey(aCase.OwnerId) 
	&& !userPgroups.get(aCase.OwnerId).contains(aCase.CH_GWC_SecurityGroup__c) 
	&& !userPgroups.get(aCase.OwnerId).contains(aCase.CH_SecurityGroup__c)
	&& !userPgroups.get(aCase.OwnerId).contains(aCase.CH_3rdPartySecurityGroup__c)){
		aCase.addError(CH_CaseTriggerHelper.UNABLE_TOASSIGN+' '+ users.get(aCase.OwnerId).Name +' '+CH_CaseTriggerHelper.OMRSP);	
	}
	// When the new owner has no security group
	if(!userPgroups.containsKey(aCase.OwnerId))
		aCase.addError(CH_CaseTriggerHelper.UNABLE_TOASSIGN+' '+ users.get(aCase.OwnerId).Name +' '+CH_CaseTriggerHelper.OMRSP);
	
	// When the new owner has Customer Profile
	if(users.get(aCase.OwnerId).Profile.Name=='Customers'){
		aCase.addError(CH_CaseTriggerHelper.UNABLE_TOASSIGN+' '+ users.get(aCase.OwnerId).Name +' as Owner. '+ users.get(aCase.OwnerId).Name +' has a Customer profile.');
	}	
			}			
		}		
	}   
			}
		}
	}
	
	/********************
/*Method Name: queueSecurityGroupsCheck
*Parameter: CaseList, oldCaseMap
*Last updated by: TCS
*Description: Stop User from Assigning a Case Owner who does have not the appropriate Security Groups
*User Story: NOKIASC-15001
****************/
	public static void queueSecurityGroupsCheck(List<Case> CaseList, Map < Id, Case > oldCaseMap){
		List<String> userPgList = new  List<String>(); 
		Set<string> queueIds = new Set<string>();
		Set<Id> usrIds = new Set<Id>();
		Set<Id> queuelst = new Set<Id>();
		Map<id, string> userNames = new Map<id, string>();  
		Map<id, List<string>> userPgListMap = new map<id, List<string>>();
		Map<id, string> userQueueName = new Map<id, string>(); 
		Map<id, string> qNameMap = new Map<id, string>(); 
		//Get GWC Queue from Public groups
		List<Group> gwcRec = [select name from Group where name = 'GWC' and type = 'queue'];
	
		string gwcQueue = gwcRec[0].Id;
	
		
		//Get logged user profile and include only CH profile to run the code
		Profile profiledet = [Select Name from Profile where Id =: userinfo.getProfileid()];
		String pname = profiledet.name;
		
		// Get Case Record types by name
		if(CaseList.size()>0){
			for(Case casRec: CaseList){
	if(pname == 'CH_Agent' || pname == 'CH_Basic Case Handling' || pname == 'CH_Case Handler' || pname == 'System Administrator' || pname == 'Customers' || pname == 'Customers Login' || pname == 'Integration API Only Profile'){
		string recordtypename = Schema.SObjectType.case.getRecordTypeInfosById().get(casRec.recordtypeid).getname();
	  
		if((recordtypename == SWS_Constants.RTNSC) || (recordtypename == SWS_Constants.RTNIWR) || (recordtypename == 'Problem') || (recordtypename == SWS_Constants.RTNIR)){
			if(string.valueOf(casRec.OwnerId).startsWith('005')){
	usrIds.add(casRec.OwnerId);
	
			}
			if(string.valueOf(casRec.OwnerId).startsWith('00G')){
	queueIds.add(casRec.Ownerid);
	
			}
		}
	}
			}
		}
		//Get queue name by queue id for empty queue assignment.
		for(Group queuenam :[select id,name from Group where Id =: queueIds]){
			qNameMap.put(queuenam.id,queuenam.name);
	 
		}
		
		//Queue owner Update
		if(queueIds.size()>0){
			for(GroupMember usrPubg:[select id,UserOrGroupId, groupId,group.name from GroupMember where GroupId =:queueIds]){
	userQueueName.put(usrpubg.groupId,usrpubg.group.name);
	  
	if(usrpubg.GroupId == gwcQueue){
		usrIds.add(usrpubg.UserOrGroupid);
	 
	}
	//else added to check Non GWC
	else{
		for(Case casRecord: CaseList){
			string recordtypename = Schema.SObjectType.case.getRecordTypeInfosById().get(casRecord.recordtypeid).getname();
		
			if(((recordtypename == SWS_Constants.RTNSC) || (recordtypename == SWS_Constants.RTNIWR) || (recordtypename == 'Problem') || (recordtypename == SWS_Constants.RTNIR)) && ((oldCaseMap.get(casRecord.id).OwnerId != casRecord.OwnerId) &&
	((string.valueOf(casRecord.OwnerId).startsWith('00G'))&& casRecord.OwnerId != gwcQueue))){
		casRecord.addError(ERROR_MESSAGE2);
		 }
		}
	}
	//Non GWC check end
			}
		}
		
		if(usrIds.size()>0){
			// User owner update
	
			for(Group usrPubg:[SELECT DeveloperName,Name,type ,(select id,UserOrGroupId, groupId from GroupMembers where UserOrGroupId =:usrIds ) FROM Group  ]){
	
	if((usrPubg.name == 'GWC'|| usrPubg.DeveloperName == 'GWC') && usrPubg.type == 'queue'){
	
		queuelst.add(usrPubg.id);
		
	}
	for(GroupMember gm: usrPubg.GroupMembers){
		
		if(usrPubg.type != 'queue'){
		
			if(userPgListMap!=null && userPgListMap.containsKey(gm.UserOrGroupId)){
	userPgList  = userPgListMap.get(gm.UserOrGroupId);
	userPgList.add(usrPubg.name);
	userPgListMap.put(gm.UserOrGroupId, userPgList);
	
			}
			else
	userPgListMap.put(gm.UserOrGroupId, new List<String>{usrPubg.name}); 
			
		}
	}
			}
		} 
		//If queue is not having any user/members in it.One for GWC and another for Non GWC queues
		else{
			for(Case casRec: CaseList){
	string recordtypename = Schema.SObjectType.case.getRecordTypeInfosById().get(casRec.recordtypeid).getname();
	  
	if((recordtypename == SWS_Constants.RTNSC) || (recordtypename == SWS_Constants.RTNIWR) || (recordtypename == 'Problem') || (recordtypename == SWS_Constants.RTNIR)){
		if((oldCaseMap.get(casRec.id).OwnerId != casRec.OwnerId) &&
		((string.valueOf(casRec.OwnerId).startsWith('00G'))&& casRec.OwnerId != gwcQueue)){
		 casRec.addError(ERROR_MESSAGE2);
		}
		if((oldCaseMap.get(casRec.id).OwnerId != casRec.OwnerId) &&
		((string.valueOf(casRec.OwnerId).startsWith('00G')) && casRec.OwnerId == gwcQueue)){
		 casRec.addError(CH_CaseTriggerHelper.ERROR_MESSAGE);
		}
	}
			}
		}
		 
		List<User> usrlst =[select name from user where id in : usrIds];
	
		for(User us: usrlst){
			userNames.put(us.Id, us.name);
		}
		if(CaseList.size()>0){  
			for(Case casRec: CaseList){
	if(pname == 'CH_Agent' || pname == SWS_Constants.BasicCH || pname == SWS_Constants.CH || pname == SWS_Constants.SysAdmin || pname == 'Customers' || pname == SWS_Constants.CustomerLogin || pname == SWS_Constants.IntegrationAPIOnly){
		String recordTypeName = Schema.SObjectType.case.getRecordTypeInfosById().get(casRec.recordtypeid).getname();
	
		if((recordTypeName == SWS_Constants.RTNSC) || (recordTypeName == SWS_Constants.RTNIWR) || (recordTypeName == 'Problem') || (recordTypeName == SWS_Constants.RTNIR)){
			for (User usr:usrlst) {
	if(!userPgListMap.isEmpty() && userPgListMap.get(usr.id) != null){
		 
		if((oldCaseMap.get(casRec.id).OwnerId != casRec.OwnerId) && (userPgListMap.get(usr.id) != null)
	 &&  (!(userPgListMap.get(usr.id)).contains(casRec.CH_SecurityGroup__c)
	&& !(userPgListMap.get(usr.id)).contains(casRec.CH_GWC_SecurityGroup__c))
	 && casRec.CH_GWC_SecurityGroup__c != null && casRec.CH_SecurityGroup__c !=null){
			casRec.addError(CH_CaseTriggerHelper.UNABLE_TOASSIGN+' '+userNames.get(casRec.OwnerId)+' '+CH_CaseTriggerHelper.OMRSP);
			
	 }
		//Queue memebers donot have proper Security Groups
		if((oldCaseMap.get(casRec.id).OwnerId != casRec.OwnerId) && (userPgListMap.get(usr.id) != null) && (casRec.OwnerId == gwcQueue)
	 &&  (!(userPgListMap.get(usr.id)).contains(casRec.CH_SecurityGroup__c)
	&& !(userPgListMap.get(usr.id)).contains(casRec.CH_GWC_SecurityGroup__c))
	 && casRec.CH_GWC_SecurityGroup__c != null && casRec.CH_SecurityGroup__c !=null){
			casRec.addError(CH_CaseTriggerHelper.ERROR_MESSAGE);
			
	 }
		
	}
	// User not associated with any public groups
	else{
		for(id qids :queuelst){
		 
			if((oldCaseMap.get(casRec.id).OwnerId != casRec.OwnerId) &&
			(string.valueOf(casRec.OwnerId).startsWith('005'))){
	casRec.addError(CH_CaseTriggerHelper.UNABLE_TOASSIGN+' '+userNames.get(casRec.OwnerId)+' '+CH_CaseTriggerHelper.OMRSP);
			}
			
			if((oldCaseMap.get(casRec.id).OwnerId != casRec.OwnerId) &&
			((string.valueOf(casRec.OwnerId).startsWith('00G'))&& casRec.OwnerId == qids)){
	casRec.addError(CH_CaseTriggerHelper.ERROR_MESSAGE);
			}
		}
	}
			}
		}
	}	
			} 
			
		}
	}
	
	/*Method Name: setEmailType
*Parameter: caseList
*Last updated by: alan.malone@salesforce.com
*Description: Sets the a picklist value (CH_EmailTypeController__c) to determine the Email Types that will be available when using the Email Action
*User Story: NOKIASC-15636
****************/
	public static void setEmailTypes(List <Case> caseList){
		for(Case c : caseList){			
			string restoration = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId();
			string standard = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CH_NokiaStandardCase').getRecordTypeId();
			string info = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CH_NokiaInformationRequest').getRecordTypeId();			
			//reset to 'All' by default
			c.CH_EmailTypeController__c = 'All';
			//NOKIASC-15638
			if(c.Status == SWS_Constants.PENDING_CUSTOMER) {
	if(c.RecordTypeId == info){
		//Update
		c.CH_EmailTypeController__c = 'CP-1';
	}
	else if(c.RecordTypeId == restoration || c.RecordTypeId == standard) {
		//Cause Analysis Report, Update
		c.CH_EmailTypeController__c = 'CP-2';
	}
			}
			//NOKIASC-15636
			else if(c.RecordTypeId == info){
	if(c.CH_InitialResponse__c == null && c.CH_SolutionProvided__c == null)
		// show Initial Response, Customer Information Request, Solution Provided, Update
		c.CH_EmailTypeController__c = 'IR-1';
	
	else if(c.CH_InitialResponse__c != null && c.CH_SolutionProvided__c == null)
		// Customer Information Request, Solution Provided, Update
		c.CH_EmailTypeController__c = 'IR-2';
	
	else if(c.CH_InitialResponse__c == null && c.CH_SolutionProvided__c != null)
		//show Initial Response, Customer Information Request, Update
		c.CH_EmailTypeController__c = 'IR-3';
	
	else if(c.CH_InitialResponse__c != null && c.CH_SolutionProvided__c != null)
		//Customer Information Request, Update
		c.CH_EmailTypeController__c = 'IR-4';
			}
			//NOKIASC-15637
			else if(c.RecordTypeId == standard){
	if(c.CH_InitialResponse__c == null && c.CH_SolutionProvided__c == null && c.CH_TemporarySolutionProvided__c == null)
		// show Initial Response, Customer Information Request, Temporary Solution Provided, Solution Provided, Cause Analysis Report, Update
		c.CH_EmailTypeController__c = 'SC-1';
	
	else if(c.CH_InitialResponse__c != null && c.CH_SolutionProvided__c == null && c.CH_TemporarySolutionProvided__c == null)
		/// show Customer Information Request, Temporary Solution Provided, Solution Provided, Cause Analysis Report, Update
		c.CH_EmailTypeController__c = 'SC-2';
	
	else if(c.CH_InitialResponse__c != null && c.CH_SolutionProvided__c != null && c.CH_TemporarySolutionProvided__c == null)
		/// Customer Information Request, Temporary Solution Provided, Cause Analysis Report, Update
		c.CH_EmailTypeController__c = 'SC-3';
	
	else if(c.CH_InitialResponse__c != null && c.CH_SolutionProvided__c != null && c.CH_TemporarySolutionProvided__c != null)
		/// Customer Information Request, Cause Analysis Report, Update
		c.CH_EmailTypeController__c = 'SC-4';
	
	else if(c.CH_InitialResponse__c == null && c.CH_SolutionProvided__c != null && c.CH_TemporarySolutionProvided__c == null)
		// show Initial Response, Customer Information Request, Temporary Solution Provided, Cause Analysis Report, Update
		c.CH_EmailTypeController__c = 'SC-5';
	
	else if(c.CH_InitialResponse__c == null && c.CH_SolutionProvided__c != null && c.CH_TemporarySolutionProvided__c != null)
		/// show Initial Response, Customer Information Request, ause Analysis Report, Update
		c.CH_EmailTypeController__c = 'SC-6';
	
	else if(c.CH_InitialResponse__c == null && c.CH_SolutionProvided__c == null && c.CH_TemporarySolutionProvided__c != null)
		/// Initial Response, Customer Information Request, Solution Provided, Cause Analysis Report, Update
		c.CH_EmailTypeController__c = 'SC-7';
	
	else if(c.CH_InitialResponse__c != null && c.CH_SolutionProvided__c == null && c.CH_TemporarySolutionProvided__c != null)
		/// Customer Information Request, Solution Provided, Cause Analysis Report, Update
		c.CH_EmailTypeController__c = 'SC-8';
			} 
			//NOKIASC-15639
			else if(c.RecordTypeId == restoration){
	//00000
	if(c.CH_InitialResponse__c == null && c.CH_SystemRestored__c ==null &&
	c.CH_ServiceDisruptionReportProvided__c == null && c.CH_TemporarySolutionProvided__c == null && c.CH_SolutionProvided__c == null)
		c.CH_EmailTypeController__c = 'RES-1';
	//00001
	else if(c.CH_InitialResponse__c == null && c.CH_SystemRestored__c ==null &&
			c.CH_ServiceDisruptionReportProvided__c == null && c.CH_TemporarySolutionProvided__c == null && c.CH_SolutionProvided__c != null)
		c.CH_EmailTypeController__c = 'RES-2';
	//00010
	else if(c.CH_InitialResponse__c == null && c.CH_SystemRestored__c ==null &&
			c.CH_ServiceDisruptionReportProvided__c == null && c.CH_TemporarySolutionProvided__c != null && c.CH_SolutionProvided__c == null)
		c.CH_EmailTypeController__c = 'RES-3';
	//00011
	else if(c.CH_InitialResponse__c == null && c.CH_SystemRestored__c ==null &&
			c.CH_ServiceDisruptionReportProvided__c == null && c.CH_TemporarySolutionProvided__c != null && c.CH_SolutionProvided__c != null)
		c.CH_EmailTypeController__c = 'RES-4';
	//00100
	else if(c.CH_InitialResponse__c == null && c.CH_SystemRestored__c ==null &&
			c.CH_ServiceDisruptionReportProvided__c != null && c.CH_TemporarySolutionProvided__c == null && c.CH_SolutionProvided__c == null)
		c.CH_EmailTypeController__c = 'RES-5';
	//00101
	else if(c.CH_InitialResponse__c == null && c.CH_SystemRestored__c ==null &&
			c.CH_ServiceDisruptionReportProvided__c != null && c.CH_TemporarySolutionProvided__c == null && c.CH_SolutionProvided__c != null)
		c.CH_EmailTypeController__c = 'RES-6';
	//00110
	else if(c.CH_InitialResponse__c == null && c.CH_SystemRestored__c ==null &&
			c.CH_ServiceDisruptionReportProvided__c != null && c.CH_TemporarySolutionProvided__c != null && c.CH_SolutionProvided__c == null)
		c.CH_EmailTypeController__c = 'RES-7';
	//00111
	else if(c.CH_InitialResponse__c == null && c.CH_SystemRestored__c ==null &&
			c.CH_ServiceDisruptionReportProvided__c != null && c.CH_TemporarySolutionProvided__c != null && c.CH_SolutionProvided__c != null)
		c.CH_EmailTypeController__c = 'RES-8';
	//01000
	else if(c.CH_InitialResponse__c == null && c.CH_SystemRestored__c !=null &&
			c.CH_ServiceDisruptionReportProvided__c == null && c.CH_TemporarySolutionProvided__c == null && c.CH_SolutionProvided__c == null)
		c.CH_EmailTypeController__c = 'RES-9';
	//01001
	else if(c.CH_InitialResponse__c == null && c.CH_SystemRestored__c !=null &&
			c.CH_ServiceDisruptionReportProvided__c == null && c.CH_TemporarySolutionProvided__c == null && c.CH_SolutionProvided__c != null)
		c.CH_EmailTypeController__c = 'RES-10';
	//01010
	else if(c.CH_InitialResponse__c == null && c.CH_SystemRestored__c !=null &&
			c.CH_ServiceDisruptionReportProvided__c == null && c.CH_TemporarySolutionProvided__c != null && c.CH_SolutionProvided__c == null)
		c.CH_EmailTypeController__c = 'RES-11';
	//01011
	else if(c.CH_InitialResponse__c == null && c.CH_SystemRestored__c !=null &&
			c.CH_ServiceDisruptionReportProvided__c == null && c.CH_TemporarySolutionProvided__c != null && c.CH_SolutionProvided__c != null)
		c.CH_EmailTypeController__c = 'RES-12';
	//01100
	else if(c.CH_InitialResponse__c == null && c.CH_SystemRestored__c !=null &&
			c.CH_ServiceDisruptionReportProvided__c != null && c.CH_TemporarySolutionProvided__c == null && c.CH_SolutionProvided__c == null)
		c.CH_EmailTypeController__c = 'RES-13';
	//01101
	else if(c.CH_InitialResponse__c == null && c.CH_SystemRestored__c !=null &&
			c.CH_ServiceDisruptionReportProvided__c != null && c.CH_TemporarySolutionProvided__c == null && c.CH_SolutionProvided__c != null)
		c.CH_EmailTypeController__c = 'RES-14';
	//01110
	else if(c.CH_InitialResponse__c == null && c.CH_SystemRestored__c !=null &&
			c.CH_ServiceDisruptionReportProvided__c != null && c.CH_TemporarySolutionProvided__c != null && c.CH_SolutionProvided__c == null)
		c.CH_EmailTypeController__c = 'RES-15';
	//01111
	else if(c.CH_InitialResponse__c == null && c.CH_SystemRestored__c !=null &&
			c.CH_ServiceDisruptionReportProvided__c != null && c.CH_TemporarySolutionProvided__c != null && c.CH_SolutionProvided__c != null)
		c.CH_EmailTypeController__c = 'RES-16';
	//10000
	else if(c.CH_InitialResponse__c != null && c.CH_SystemRestored__c ==null &&
			c.CH_ServiceDisruptionReportProvided__c == null && c.CH_TemporarySolutionProvided__c == null && c.CH_SolutionProvided__c == null)
		c.CH_EmailTypeController__c = 'RES-17';
	//10001
	else if(c.CH_InitialResponse__c != null && c.CH_SystemRestored__c ==null &&
			c.CH_ServiceDisruptionReportProvided__c == null && c.CH_TemporarySolutionProvided__c == null && c.CH_SolutionProvided__c != null)
		c.CH_EmailTypeController__c = 'RES-18';
	//10010
	else if(c.CH_InitialResponse__c != null && c.CH_SystemRestored__c ==null &&
			c.CH_ServiceDisruptionReportProvided__c == null && c.CH_TemporarySolutionProvided__c != null && c.CH_SolutionProvided__c == null)
		c.CH_EmailTypeController__c = 'RES-19';
	//10011
	else if(c.CH_InitialResponse__c != null && c.CH_SystemRestored__c ==null &&
			c.CH_ServiceDisruptionReportProvided__c == null && c.CH_TemporarySolutionProvided__c != null && c.CH_SolutionProvided__c != null)
		c.CH_EmailTypeController__c = 'RES-20';
	//10100
	else if(c.CH_InitialResponse__c != null && c.CH_SystemRestored__c ==null &&
			c.CH_ServiceDisruptionReportProvided__c != null && c.CH_TemporarySolutionProvided__c == null && c.CH_SolutionProvided__c == null)
		c.CH_EmailTypeController__c = 'RES-21';
	//10101
	else if(c.CH_InitialResponse__c != null && c.CH_SystemRestored__c ==null &&
			c.CH_ServiceDisruptionReportProvided__c != null && c.CH_TemporarySolutionProvided__c == null && c.CH_SolutionProvided__c != null)
		c.CH_EmailTypeController__c = 'RES-22';
	//10110
	else if(c.CH_InitialResponse__c != null && c.CH_SystemRestored__c ==null &&
			c.CH_ServiceDisruptionReportProvided__c != null && c.CH_TemporarySolutionProvided__c != null && c.CH_SolutionProvided__c == null)
		c.CH_EmailTypeController__c = 'RES-23';
	//10111
	else if(c.CH_InitialResponse__c != null && c.CH_SystemRestored__c ==null &&
			c.CH_ServiceDisruptionReportProvided__c != null && c.CH_TemporarySolutionProvided__c != null && c.CH_SolutionProvided__c != null)
		c.CH_EmailTypeController__c = 'RES-24';
	//11000
	else if(c.CH_InitialResponse__c != null && c.CH_SystemRestored__c !=null &&
			c.CH_ServiceDisruptionReportProvided__c == null && c.CH_TemporarySolutionProvided__c == null && c.CH_SolutionProvided__c == null)
		c.CH_EmailTypeController__c = 'RES-25';
	//11001
	else if(c.CH_InitialResponse__c != null && c.CH_SystemRestored__c !=null &&
			c.CH_ServiceDisruptionReportProvided__c == null && c.CH_TemporarySolutionProvided__c == null && c.CH_SolutionProvided__c != null)
		c.CH_EmailTypeController__c = 'RES-26';
	//11010
	else if(c.CH_InitialResponse__c != null && c.CH_SystemRestored__c !=null &&
			c.CH_ServiceDisruptionReportProvided__c == null && c.CH_TemporarySolutionProvided__c != null && c.CH_SolutionProvided__c == null)
		c.CH_EmailTypeController__c = 'RES-27';
	//11011
	else if(c.CH_InitialResponse__c != null && c.CH_SystemRestored__c !=null &&
			c.CH_ServiceDisruptionReportProvided__c == null && c.CH_TemporarySolutionProvided__c != null && c.CH_SolutionProvided__c != null)
		c.CH_EmailTypeController__c = 'RES-28';
	//11100
	else if(c.CH_InitialResponse__c != null && c.CH_SystemRestored__c !=null &&
			c.CH_ServiceDisruptionReportProvided__c != null && c.CH_TemporarySolutionProvided__c == null && c.CH_SolutionProvided__c == null)
		c.CH_EmailTypeController__c = 'RES-29';
	//11101
	else if(c.CH_InitialResponse__c != null && c.CH_SystemRestored__c !=null &&
			c.CH_ServiceDisruptionReportProvided__c != null && c.CH_TemporarySolutionProvided__c == null && c.CH_SolutionProvided__c != null)
		c.CH_EmailTypeController__c = 'RES-30';
	//11110
	else if(c.CH_InitialResponse__c != null && c.CH_SystemRestored__c !=null &&
			c.CH_ServiceDisruptionReportProvided__c != null && c.CH_TemporarySolutionProvided__c != null && c.CH_SolutionProvided__c == null)
		c.CH_EmailTypeController__c = 'RES-31';
	//11111
	else if(c.CH_InitialResponse__c != null && c.CH_SystemRestored__c !=null &&
			c.CH_ServiceDisruptionReportProvided__c != null && c.CH_TemporarySolutionProvided__c != null && c.CH_SolutionProvided__c != null)
		c.CH_EmailTypeController__c = 'RES-32';
			}
		}
	}

	
	public static boolean caseIsEligibleForP20Details(Case supportTicket){
		if(supportTicket != null && 
	 supportTicket.CH_RecordTypeCheck__c && 
	 supportTicket.EntitlementId != null && 
	 supportTicket.CH_ServiceType__c == SWS_Constants.ServiceTypeIS && 
	 string.isBlank(supportTicket.CH_CARES_ServiceAgreement__c) && 
	 !string.isBlank(supportTicket.CH_CDB_ContractNumber__c))
			return true;
		return false;
	}
	
	public static void handleP20orderDetails(map<id,Case> oldCases, list<Case> newCases){ 
		CH_Hierarchical_Setting__c  hierSetting = CH_Hierarchical_Setting__c.getInstance();
		if(hierSetting.P20OrderDetails__c){
			for(Case aCase : newCases){
	if((((oldCases == null || oldCases.isEmpty()) && (!string.isBlank(aCase.CH_PlantCode__c) || !string.isBlank(aCase.CH_GlobalServiceOrder__c) || !string.isBlank(aCase.CH_LocalServiceOrder__c))) || 
		(oldCases != null && !oldCases.isEmpty() && (aCase.CH_PlantCode__c != oldCases.get(aCase.Id).CH_PlantCode__c || aCase.CH_GlobalServiceOrder__c != oldCases.get(aCase.Id).CH_GlobalServiceOrder__c || aCase.CH_LocalServiceOrder__c != oldCases.get(aCase.Id).CH_LocalServiceOrder__c))) && !caseIsEligibleForP20Details(aCase)){ 
		//Ref: NOKIASC-36332 Replaced Error Message With Custom Label
			aCase.addError(System.Label.CH_Cannot_Specify_Local_Service_Order_Plant_Code);
			}
			}	
		}
	}
	
		/********************   
	*Method Name: populateCaseFields	
	*Author: TCS	
	*Parameter: oldCaseMap, newCaseList 
	*Description: Moved the logic from CH Case Process Builder to this method as part of code optimization. 
	*******************/
	public static void populateCaseFields(Map<Id,Case> oldCaseMap,List<Case> newCaseList){
		Map<Id,Case> newAccountCaseList=  new Map<Id, Case>([Select Id, Account.Customer_Compliance__c, CH_LawfulInterceptCALEAConfirmed__c FROM case WHERE Id IN :newCaseList]); //NOKIASC-36514
		if(!newCaseList.isEmpty()){
			//code added as per code Opt US#27636
			Set<Id> contIds=new Set<Id>();
			Set<Id> caseIdSet=new Set<Id>();
			Set<Id> entitlementIds= new Set<Id>();
			List<ISO_Country_Codes__c> countrylist = ISO_Country_Codes__c.getAll().values();
			for(Case oCase: newCaseList){
	if(oCase.ContactId!=null)
	  contIds.add(oCase.ContactId);
	//verifyCountryChangeOnCase
	if(!oldCaseMap.isempty() && oldCaseMap.get(oCase.Id).Country__c != oCase.Country__c ) {
		caseIdSet.add(oCase.Id);	
	}
	
	//NOKIASC-32798-Populate Case Region Field based on Case Country	 
	if((!oldCaseMap.isempty() && oCase.Country__c != null ) && (!countrylist.isEmpty() && countrylist!=null))
	{	
	
		//NOKIASC-34818 removed ISOCountryCode reference,instead using Workgroup rule picklist
		ocase.CH_CaseRegion__c = CH_CA_Assignment_Criteria_DTO.getRegionByCountry(oCase.Country__C);
		caseIdSet.add(oCase.Id);
			
	}
	//populateBusinessHourIds
	if(((oldCaseMap.isempty() && String.isNotBlank(oCase.EntitlementId) && !String.isNotBlank(oCase.BusinessHoursId)) || (!oldCaseMap.isempty() && oldCaseMap.get(oCase.Id).EntitlementId != oCase.EntitlementId && !String.isNotBlank(oCase.BusinessHoursId)) || (!oldCaseMap.isempty() && oCase.Origin == 'S2S'))){
		entitlementIds.add(oCase.EntitlementId);
	}
	//Reset Case Tag on Product Change - NOKIASC-28909
	if(!oldCaseMap.isempty() && oldCaseMap.get(oCase.Id).ProductId != oCase.ProductId) {
		oCase.CH_Tag__c = null;	 
	}
			}
			
			Map<Id,Contact> contMap = new Map<Id,Contact>();
			if(contIds.size()>0){
	//Using Global/Common query as part of Code Optimization -- 27617
	contMap=CH_Utils.getContactMap(contIds);
			}
			//verifyCountryChangeOnCase
			Map<Id, List< CH_Attachment__c>> attachMap = new Map<Id, List<CH_Attachment__c>>();
			if(caseIdSet.size()>0){
	for (CH_Attachment__c attachObj: [SELECT Id, Case__c FROM CH_Attachment__c WHERE Case__c =: newCaseList AND CH_Status__c NOT IN ('Deleted','Rejected','Failed')]) {
		if(attachObj != null ){
			if(attachMap.containsKey(attachObj.Case__c)) {
	attachMap.get(attachObj.Case__c).add(attachObj);
			} else {
	attachMap.put(attachObj.Case__c, new List < CH_Attachment__c >  { attachObj });
			}
		}	
	}
			}
			//populateBusinessHourIds
			Map<Id, Entitlement> entitlementMap = new Map<Id, Entitlement>();
			if(entitlementIds.size()>0){
	//Using Global/Common query as part of Code Optimization -- 27618
	entitlementMap = CH_Utils.getentitlementMap(entitlementIds);
			}
			for(Case ca : newCaseList){ 
	String recordTypeName = Schema.SObjectType.Case.getRecordTypeInfosById().get(ca.recordTypeId).getName();
	
	/******************** Merged the method "validAsset" in this loop -- starts --> 27620 By Satya
	*Description: Method to validate individual Case If Asset is null Entitlement and country both should not be null and vice versa.
	*User Story: NOKIASC- 494   *******************/  
	if(ca.Origin != 'S2S' && ca.AssetId == null && ca.Entitlement.name == null && (ca.Country__c == null || ca.ProductId==null)&& (ca.CH_ServiceType__c == 'Customer Support' || ca.CH_ServiceType__c==null) && (recordTypeName == SWS_Constants.RTNSC || recordTypeName == SWS_Constants.RTNIWR || recordTypeName == SWS_Constants.RTNIR)){
		//Ref: NOKIASC-36332 Replaced Error Message With Custom Label
		ca.addError(System.Label.CH_Product_Country_Cannot_Be_Blank); 
	}
	//==== End method validAsset =====
	/******************** Merged the method "validateCaseCreation" in this loop -- starts--> 27620 By Satya
	*Description: Method to validate individual Case If Asset is null Entitlement and country both should not be null and vice versa.
	*User Story: NOKIASC- 494 *******************/
	if(oldCaseMap.isempty() && contMap.size()>0 && contMap.containsKey(ca.ContactId)){
		if((ca.CH_ServiceType__c == SWS_Constants.ServiceTypeIS && contMap.get(ca.contactId).CH_contactType__c != SWS_Constants.CONTTypeNokiaEmp)){
			//Ref: NOKIASC-36332 Replaced Error Message With Custom Label
			ca.addError(System.Label.CH_Internal_Support_Contact_Nokia_Employee);
		}
		if((ca.CH_ServiceType__c == SWS_Constants.ServiceTypeIS && contMap.get(ca.contactId).CH_contactType__c== SWS_Constants.CONTTypeNokiaEmp )
		&& (ca.CH_Outage__c == 'Yes' || (ca.Severity__c == 'Critical' || ca.Severity__c == SWS_Constants.IR))){
		//Ref: NOKIASC-36332 Replaced Error Message With Custom Label
		 ca.addError(System.Label.CH_Internal_Support_Cannot_Have_Severity_Critical_Info_Request_Outage_Yes);
		}   
	}	  
	//==== End method validateCaseCreation =====	
	if(!oldCaseMap.isempty()){
		Case oldCase = oldCaseMap.get(ca.Id);
		if((ca.Subject !=null && ca.CH_CustomerDescription__c !=null && newAccountCaselist.get(ca.Id).Account.Customer_Compliance__c !=null && ca.Country__c !=null) && (oldCase.CH_LawfulInterceptCALEAConfirmed__c == null && ca.CH_LawfulInterceptCALEAConfirmed__c == 'No') && (ca.Subject.containsIgnoreCase('CALEA') || ca.CH_CustomerDescription__c.containsIgnoreCase('CALEA')) &&	
		(newAccountCaselist.get(ca.Id).Account.Customer_Compliance__c == 'US_Govern' || addCountries.contains(ca.Country__c)))
		{		
			ca.CH_LawfullIntercept_CALEA__c=false;  //NOKIASC-36514	
		}
		if((oldCase.CH_LawfulInterceptCALEAConfirmed__c != null) && (oldCase.CH_LawfulInterceptCALEAConfirmed__c != ca.CH_LawfulInterceptCALEAConfirmed__c)){
			ca.addError(System.Label.CH_Caleaaction); //NOKIASC-36514
		}
		if((ca.Subject !=null && ca.CH_CustomerDescription__c !=null && newAccountCaseList.get(ca.Id).Account.Customer_Compliance__c !=null && ca.Country__c !=null) && (oldCase.CH_LawfulInterceptCALEAConfirmed__c == null) && 
		(newAccountCaseList.get(ca.Id).Account.Customer_Compliance__c != 'US_Govern') &&
		(oldCase.CH_LawfulInterceptCALEAConfirmed__c != ca.CH_LawfulInterceptCALEAConfirmed__c) &&  
		(!addCountries.contains(ca.Country__c)))
		{
		ca.addError(System.Label.CH_Caleaaction); //NOKIASC-36514
		}
		if((ca.Subject !=null && ca.CH_CustomerDescription__c !=null && newAccountCaselist.get(ca.Id).Account.Customer_Compliance__c !=null && ca.Country__c !=null) && (oldCase.CH_LawfulInterceptCALEAConfirmed__c == null && ca.CH_LawfulInterceptCALEAConfirmed__c == 'Yes') &&	
		(newAccountCaselist.get(ca.Id).Account.Customer_Compliance__c == 'US_Govern' || addCountries.contains(ca.Country__c)))
		{		
		ca.CH_LawfullIntercept_CALEA__c=true;  //NOKIASC-36514 & NOKIASC- 38124		 
		}
		/************************** Merged method "validateContactMustBeNokiaEmployee" in this loop -- starts --> 27620 By Satya
		Description: US 22292 : Non-Care - Validation rule that Contact must be Nokia Employee *******/ 
		if (contMap.size()> 0 && contMap.containsKey(ca.ContactId) && oldCase.ContactId != null && !oldCase.ContactId.equals(ca.ContactId) && ca.CH_ServiceType__c.equals('Internal Support') && !contMap.get(ca.ContactId).CH_ContactType__c.equals(SWS_Constants.CONTTypeNokiaEmp)) {
		//Ref: NOKIASC-36332 Replaced Error Message With Custom Label
			ca.addError(System.Label.CH_Service_Internal_Support_Contact_Nokia_Employee);
		}
		//==== End method validateContactMustBeNokiaEmployee =====
		/************************** Merged method "productAssetValidation" in this loop -- starts --> 27620 By Satya
		*Description: Cannot modify product details when Asset is  Set.
		*User Story: NOKIASC- 494   *******************/		
		if(recordTypeName != 'Problem' && (oldCase.AssetId !=null) && (oldCase.AssetId == ca.AssetId && oldCase.CH_NetworkElementAsset__c == ca.CH_NetworkElementAsset__c && (oldCase.ProductId!=ca.ProductId || oldCase.CH_Product_Release__c!=ca.CH_Product_Release__c || oldCase.CH_ProductVariant__c != ca.CH_ProductVariant__c || oldCase.Country__c != ca.Country__c || oldCase.CH_Solution__c!=ca.CH_Solution__c))){
	//Ref: NOKIASC-36332 Replaced Error Message With Custom Label
			ca.addError(System.Label.CH_Asset_Populated_Product_Details_Cannot_Be_Modified);
		}
		//==== End method productAssetValidation =====
		/********************Merged method "verifyCountryChangeOnCase" in this loop -- starts --> 27620 By Satya
		*Description: Used to re-calcualte Case Milestone if either Severity or Outage changed. *******************/		
		if(contIds.size()>0 && attachMap.size()>0 && oldCase.Country__c != ca.Country__c ){		 
			List <CH_Attachment__c> tempList = attachMap.get(ca.Id);
			if(tempList != null && !tempList.isEmpty()) {
	//Ref: NOKIASC-36332 Replaced Error Message With Custom Label
	ca.addError(System.Label.CH_Country_Cannot_Modified_For_One_or_More_Attachments_Associated);
			}	
		}
		
		//==== End method verifyCountryChangeOnCase =====
	}
	/******************** populateBusinessHourIds -- Starts--> 27620 By Satya
	*Description: Used to update business hours if entitlement is filled and contractlineitem on entitlement is filled then fetch businesshours from contractlineitem on case   *******************/
	//Check Entitlement Map is Empty or Not
	if(entitlementMap.size()>0 && entitlementMap.containsKey(ca.EntitlementId) && (!String.isNotBlank(ca.BusinessHoursId) || ca.Origin == 'S2S') && String.isNotBlank(ca.EntitlementId) && (oldCaseMap.isempty() || ca.Origin == 'S2S' || (!oldCaseMap.isempty() && oldCaseMap.get(ca.Id).EntitlementId != ca.EntitlementId))) {
	Entitlement oEntitlement = entitlementMap.get(ca.EntitlementId);
		if(oEntitlement != null && oEntitlement.ContractLineItem != null){
			ca.BusinessHoursId = oEntitlement.ContractLineItem.CH_BusinessHour__c;
		}
	}
	//==== End method populateBusinessHourIds =====
	
	if(ca.CH_ServiceType__c == 'Customer Support' && ca.Status == 'Created' && contMap.keyset().contains(ca.ContactId)){
		ca.CH_Email2__c = contMap.get(ca.ContactId).Email1__c ;
		ca.CH_Email3__c = contMap.get(ca.ContactId).CH_Email3__c;
	}
	if(ca.Status == 'Created' && ca.Status != 'Cancelled'){
		ca.CH_ReportedDate__c = (ca.CH_ReportedDate__c == null ? System.now() : ca.CH_ReportedDate__c);
		ca.CH_MilestoneSLA_Start__c = (ca.CH_ReportedDate__c != null ? ca.CH_ReportedDate__c : System.now()); 
	}   
	  
	if(ca.Status != 'Cancelled' && (oldCaseMap.isempty() ||
			(!oldCaseMap.isempty() && oldCaseMap.containsKey(ca.Id) && ca.CH_MilestoneSLA_Start__c != oldCaseMap.get(ca.Id).CH_MilestoneSLA_Start__c))){
	ca.SlaStartDate = ca.CH_MilestoneSLA_Start__c;
			}
	if(!oldCaseMap.isempty() && ca.Status != 'Cancelled' && ca.Status != 'Closed' && ca.Status != oldCaseMap.get(ca.Id).Status){ ca.IsStopped = (ca.Status == SWS_Constants.PENDING_CUSTOMER ? true : (ca.Status != SWS_Constants.PENDING_CUSTOMER && ca.IsStopped == true ? false: ca.IsStopped ));	  
	
	}
	if(ca.CH_Record_Type_Check_Condition__c){
		ca.CH_Stage__c = (ca.Status == 'Created' ? 'Route' : (ca.Status == 'Assigned' && String.valueof(ca.OwnerId).startsWith('005')) ? 'Assess & Respond' : ca.CH_Stage__c); 
	}
	 //Moved this code from CH_BlacklistCaseReportTrigger for Cancelled cases
	if(ca.Status == 'Cancelled' || ca.Status == 'Draft'){ ca.CH_BlockCases__c = true;
	} 
			}
		}
	}
	/********************   
	*Method Name: getCasesForSubscribers	
	* Description : returns Map with Business Group and Business Units from Product2 aggreagate results
	* Parameters: Old Case Map and New Case List
	* Returns : 
	* written on 17th Jln 2020
	* By Satya Pagadala
	* NOKIASC-29170
	*****************************************/
	public static void getCasesForSubscribers(Map<Id,Case> oldCaseMap,List<Case> newCaseList){
		if(!newCaseList.isEmpty()){
			Set<Id> subscriberCaseIdSet = new Set<Id>(); 
			Boolean isCreation = false; 
			for(Case c: newCaseList){	
	if(oldCaseMap == null){
		if((c.Severity__c =='Critical' || c.Severity__c =='Major') && (c.CH_Outage__c =='Yes' || c.CH_Outage__c =='No')){
			subscriberCaseIdSet.add(c.Id);
			isCreation = true;			
		}	
	}
	else{	
		if((c.CH_Outage__c != oldCaseMap.get(c.Id).CH_Outage__c) || (c.Severity__c != oldCaseMap.get(c.Id).Severity__c && (c.Severity__c =='Critical' || c.Severity__c =='Major')) || (c.Status != oldCaseMap.get(c.Id).Status && c.Status=='Restoration Provided') || (c.CH_Workgroup__c !=null && c.CH_Workgroup__c != oldCaseMap.get(c.Id).CH_Workgroup__c && (c.Severity__c =='Critical' || c.Severity__c =='Major' || c.Severity__c =='Minor' || c.Severity__c ==SWS_Constants.IR))){ subscriberCaseIdSet.add(c.Id);
		}
	}
			}
			if(subscriberCaseIdSet.size()>0 && !test.isRunningTest()){ Id jobId = System.enqueueJob(new CH_CN_IdentifySubscribersQueueable(subscriberCaseIdSet, oldCaseMap, isCreation, false, false,null));
			}
		}
	}
	/********************   
	*Method Name: checkCriteriaForNGNAIPMessage	
	* Description : This will be used to check the criteria to collect case information to send Auto log collection.
		Added CH_Site__c condition as part of NOKIASC-37145.
	* Parameters: Old Case Map and New Case List
	* Returns : 
	* written on 23.09.2020
	* By Gourisankar Patra
	* NOKIASC-31109
	*****************************************/
	public static void checkCriteriaForNGNAIPMessage(Map<Id,Case> oldCaseMap,List<Case> newCaseList){
		if(!newCaseList.isEmpty()){
			Set<String> caseStatusSet = new Set<String>{'Completed','Closed','Cancelled'};
			Set<Id> caseNEASet = new Set<Id>();
			Boolean isCreation = false;
			for(Case c: newCaseList)
			{
	if(oldCaseMap == null)
	{
		if((c.CH_RecordTypeDevName__c=='CH_NokiaStandardCase' || c.CH_RecordTypeDevName__c=='CH_NokiaIncidentWithRestoration') && (c.CH_NetworkElementAsset__c != null ) && 
		!caseStatusSet.contains(c.Status) && (c.CH_SecurityGroup__c =='SEC_Default') && (c.CH_AssignedDate__c!= null && c.CH_CurrentQueue__c == null)) {
		 caseNEASet.add(c.Id);
		 isCreation = true;
		}
	}else{
		if((c.CH_RecordTypeDevName__c=='CH_NokiaStandardCase' || c.CH_RecordTypeDevName__c=='CH_NokiaIncidentWithRestoration') && !caseStatusSet.contains(c.Status) && (c.OwnerId != null) &&
		((c.CH_NetworkElementAsset__c != null) || (c.CH_Site__c != NULL)) && (string.valueOf(c.OwnerId).startsWith('005')==true) &&
		(c.CH_Outage__c=='No') && ( c.CH_CurrentQueue__c == null) && (c.CH_AssignedDate__c!= null) && (oldCaseMap.get(c.Id).CH_AssignedDate__c==null)
		&& (c.CH_AssignedDate__c != oldCaseMap.get(c.Id).CH_AssignedDate__c) && (c.CH_SecurityGroup__c =='SEC_Default'))
		{
			caseNEASet.add(c.Id); 
		}
		if((c.CH_RecordTypeDevName__c=='CH_NokiaStandardCase' || c.CH_RecordTypeDevName__c=='CH_NokiaIncidentWithRestoration') && !caseStatusSet.contains(c.Status) &&
		((c.CH_NetworkElementAsset__c != null && c.CH_NetworkElementAsset__c != oldCaseMap.get(c.Id).CH_NetworkElementAsset__c) || (c.CH_Site__c != null && c.CH_Site__c != oldCaseMap.get(c.Id).CH_Site__c)) &&
		(string.valueOf(c.OwnerId).startsWith('005')==true) && (c.CH_Outage__c=='No') &&  
		(c.CH_AssignedDate__c!= null && c.CH_CurrentQueue__c == null) && (c.CH_SecurityGroup__c =='SEC_Default'))
		{
			caseNEASet.add(c.Id); 
		}
	}
			}
			if(caseNEASet.size()>0 && !test.isRunningTest()){ CH_NEAMessageDigiMop.invokeNGNAIP(caseNEASet);
			}
		}
	}
	
	// NOKIASC-31957
	public static void checkCompletedCases(List<Case> newCaseList, Map<Id,Case> oldCaseMap) {
		Set<Id> oCaseSetId = new Set<Id>();
		for(Case newCase : newCaseList) {
			if(newCase.Status.equals('Completed')) {
	Case oldCase = oldCaseMap.get(newCase.Id);
	if(oldCase != null && !oldCase.Status.equals('Completed')) { oCaseSetId.add(newCase.Id);
	}
			}
		}
		if(!oCaseSetId.isEmpty()) { removeCaseTeamMembersOnComplete(oCaseSetId);
		}
	}
	
	// NOKIASC-34615
	public static void checkCancelledCases(List<Case> newCaseList, Map<Id,Case> oldCaseMap) {
		Set<Id> oCaseSetId = new Set<Id>();
		for(Case newCase : newCaseList) {
			//NOKIASC-31958
			if(newCase.Status.equals('Cancelled')) {
	Case oldCase = oldCaseMap.get(newCase.Id);
	if(oldCase != null && !oldCase.Status.equals('Cancelled')) {
		oCaseSetId.add(newCase.Id);	newCase.OwnerID = System.Label.CH_Archived_Case_No_Owner; newCase.CH_CurrentQueue__c = '';
	}
			}
		}
		if(!oCaseSetId.isEmpty()) { removeCaseTeamMembersOnComplete(oCaseSetId);
		}
	}
	// NOKIASC-31957
	@future
	public static void removeCaseTeamMembersOnComplete(Set<Id> oCaseSetId) {
		List<CaseTeamMember> oCaseTeamMembersToRemove = [SELECT Id FROM CaseTeamMember WHERE ParentId IN :oCaseSetId];
		delete oCaseTeamMembersToRemove;
		//NOKIASC-35851
		CH_CHASettings__c executeCaseTeamHistory = CH_CHASettings__c.getValues('ExecuteCaseTeamExitDatePopulation');
		if(executeCaseTeamHistory!= NULL && executeCaseTeamHistory.SettingValue__c=='true'){
			List<CH_CaseTeamHistory__c> caseTeamHistoryUpdate = new List<CH_CaseTeamHistory__c>();
			for(CH_CaseTeamHistory__c caseTeamHistory :  [select id, CH_CaseTeamExit__c from CH_CaseTeamHistory__c WHERE Support_Ticket__c in :oCaseSetId AND CH_CaseTeamExit__c =null ]){
	caseTeamHistory.CH_CaseTeamExit__c = System.now();
	caseTeamHistoryUpdate.add(caseTeamHistory);
			}
			if(caseTeamHistoryUpdate.Size()>0){
	update caseTeamHistoryUpdate;	
			}
		}
	}
	 
	
	//Modified for NOKIASC-37554
	Public Static void probCreatedCheck(Map <Id, Case> oldCaseMap,List <Case> lstcase){
		String getWorkgroups = System.Label.CH_GWC_Workgroup;
		Set<String> getGWCWrkpgs = new Set<String>();
		if(getWorkgroups!= null){
			for(String getSetValue : getWorkgroups.split(',')) { getGWCWrkpgs.add(getSetValue);  }
		}
		if(!oldCaseMap.values().IsEmpty()){
			for(case c : lstcase){
	 if(c.CH_RecordTypeDevName__c=='CH_Problem' && c.CreatedDate!=c.LastModifiedDate  && (c.CH_Workgroup__c != oldCaseMap.get(c.Id).CH_Workgroup__c)){
		//Ref: NOKIASC-36332 Replaced Error Message With Custom Label
		string gtWorkgroup=oldCaseMap.get(c.Id).CH_Workgroup__c != null ? oldCaseMap.get(c.Id).CH_Workgroup__c:null;
		DateTime gtAssignedDate=oldCaseMap.get(c.Id).CH_AssignedDate__c != null ? oldCaseMap.get(c.Id).CH_AssignedDate__c:null;
		if(gtWorkgroup==null){ break;}
		else { if(!getGWCWrkpgs.isEmpty() && !getGWCWrkpgs.contains(gtWorkgroup) && gtAssignedDate==null){ c.addError(System.Label.CH_Assign_Problem_Before_Update);}}
	}
	 else{
		if(c.CH_RecordTypeDevName__c=='CH_Problem' && c.CreatedDate!=c.LastModifiedDate && c.CH_CurrentQueue__c!=null  && c.CH_AssignedDate__c == null ){ if((!getGWCWrkpgs.isEmpty() && getGWCWrkpgs.contains(c.CH_Workgroup__c)) ||(c.CH_PausedSinceDate__c != oldCaseMap.get(c.Id).CH_PausedSinceDate__c) || (c.CH_SolutionTargetDate__c != oldCaseMap.get(c.Id).CH_SolutionTargetDate__c)){
		 system.debug('Logic Skipped');
			}else{ c.addError(System.Label.CH_Assign_Problem_Before_Update);
			}
		}
	}
			}
		}
	}

//Changes added as a Part of NOKIASC-35322
	public static void checkDefectSolutionTargetAndPausedDate(map<id, Case> oldCases, list<Case> newCasesList){
		System.debug('## Method Entered checkDefectSolutionTargetAndPausedDate');
		Set<ID> problemCaseList = new Set<Id>();
		String  getStatus ;
		Id  incidents ;
		//Checking for RE-Entitlement and Severity and Outage Changes
		if(newCasesList != null && !newCasesList.isEmpty()) {
			for(Case oCase: newCasesList) {
	Case oldCase = oldCases.get(oCase.Id);
	 
		if(oldCase != null && oCase.CH_Problem__c !=null && (oldCase.AccountId != oCase.AccountId || oldCase.EntitlementId != oCase.EntitlementId ||
			oldCase.Severity__c != oCase.Severity__c || oldCase.CH_Outage__c != oCase.CH_Outage__c ||  
			oldCase.CH_Defect__c != oCase.CH_Defect__c || 
			((oldCase.CH_DeferralStatus__c =='Active' && oCase.CH_DeferralStatus__c !='Active') ||
	(oldCase.CH_DeferralStatus__c !='Active' && oCase.CH_DeferralStatus__c =='Active')) ||
			(oldCase.Status != oCase.Status  && ((oCase.Status =='Pending Customer' && oCase.IsStopped == TRUE) || oldCase.Status =='Pending Customer'))
			)) {
		 System.debug('## Method Entered and Problem is Captured '+oCase.CH_Problem__c);
		 problemCaseList.add(oCase.CH_Problem__c);
		 }
	
	//Disassociation the Problem to Incident 
	if(oldCase.CH_Problem__c !=null && oCase.CH_Problem__c ==null ){
		System.debug('## Method Entered and Problem is Captured for Disassociation '+oldCase.CH_Problem__c);
		problemCaseList.add(oldCase.CH_Problem__c);
	}
	// Association of  Problem to Incident
	if (oldCase.CH_Problem__c ==null && oCase.CH_Problem__c !=null){
		System.debug('## Method Entered and Problem is Captured for Association '+oCase.CH_Problem__c);
		problemCaseList.add(oCase.CH_Problem__c);
		// If we are associating the incident which is having Pending Customer Status
		// if(oCase.Status =='Pending Customer'){ getStatus='Pending Customer'; incidents=oCase.Id; }
		//Association and deassociation of incident Pending customer is not checked
		
	}
			}
			
		} 
		if(problemCaseList.size()>0){
			System.debug('## Future Method is triggered ');
			CH_CaseTriggerHelper.updateDefectSolutionTargetAndPausedDate(problemCaseList);
		}
		
		
	}
	
	@future(callout=true)
	Public static void updateDefectSolutionTargetAndPausedDate(Set<Id> problemCaseList){
		Set<Id> captureCaseIdsforCaseMilestones=new Set<Id>();
		Boolean IsReEntitlementOrProblemDisassociate=false;
		Date getProblemSolutionDate=null;
		DateTime shortestSLA = null;
		DateTime pausedSinceDate = null;
		string status = '';
		Boolean sendToRnD = false;
		String rndSubject;
		Boolean isrndSubject = false;
		//Get the list of Incidents associated for the Problem 
		List<Case> getIncidentRecords=[select Id,CH_Problem__c,CH_Problem__r.CH_SolutionTargetDate__c,CH_Problem__r.CH_PausedSinceDate__c, status ,CH_RecordTypeCheck__c 
			from case where CH_Problem__c IN : problemCaseList ];
		//Get the Problem Record
		Case[] problemCase=[SELECT Id, CaseNumber, CH_ReportedDate__c, CH_CRNumber__c, Severity__c, CH_Originating_Incident_Number__c, CH_Originating_Incident_Number__r.CaseNumber,	CH_SolutionTargetDate__c,CH_PausedSinceDate__c,CH_RDInterface__c,CH_RecordTypeCheck__c,
	(SELECT Id FROM CH_R_D_Interactions__r WHERE (CH_RnD_Interface__c = 'PRONTO'  OR CH_RnD_Interface__c = 'JIRA') AND CH_RnD_Status__c =  'Completed' AND CH_RnD_Type__c =  'Transfer to R&D')
	FROM Case WHERE RecordType.DeveloperName = 'CH_Problem' AND Id IN : problemCaseList];
		system.debug('## Method Entered and list of getIncidentRecords are : '+getIncidentRecords.size());
		//Add the list of Id's for getting CaseMilestone Records
		if(getIncidentRecords.size()>0){
			for(Case getIncRec: getIncidentRecords){
	System.debug('## Method Entered and Incident is Captured : '+getIncRec.id);
	captureCaseIdsforCaseMilestones.add(getIncRec.id);
			}
		}
		else{
			IsReEntitlementOrProblemDisassociate=True;
		}
		
		
		if(captureCaseIdsforCaseMilestones.Size()>0){
			//Get the latest Milestone Target Date 
			List<CaseMilestone> lstofMilestones=
	[SELECT TargetDate, Startdate,milestonetype.name,Case.id,Case.status,Case.CH_Time_Stamp_Customer_Pending__c,MilestoneTypeId FROM CaseMilestone 
	 WHERE milestonetype.name IN ('Solution Provided (deferred)','Solution Provided (defect)') AND Case.Id IN : captureCaseIdsforCaseMilestones
	 Order by TargetDate ASC LIMIT 1 ];
			if(lstofMilestones.Size()>0){
	List<CH_PendingTimeSuspension__c> getPendingSuspensionTime=[Select Id,CH_StartTime__c
				from CH_PendingTimeSuspension__c where CH_SupportTicket__c=:lstofMilestones[0].Case.Id
				Order by CH_StartTime__c DESC LIMIT 1 
		 ];
	shortestSLA = lstofMilestones[0].TargetDate;
	if(getPendingSuspensionTime.size()>0){
		System.debug('## Method Entered and Pending Suspension Time is : '+getPendingSuspensionTime[0].CH_StartTime__c);
		System.debug('## Method Entered and Paused date From Milestone : '+lstofMilestones[0].Case.CH_Time_Stamp_Customer_Pending__c);
		pausedSinceDate = getPendingSuspensionTime[0].CH_StartTime__c;
	}
	status = lstofMilestones[0].Case.status;
	if(problemCase.size()>0){
		System.debug('## Method Entered and SolutionTargetDate on Milestone : '+shortestSLA);
		System.debug('## Method Entered and SolutionTargetDate on Problem : '+problemCase[0].CH_SolutionTargetDate__c);
		System.debug('## Method Entered and Paused Since Date on Milestone : '+pausedSinceDate);
		System.debug('## Method Entered and pausedSinceDate on Problem : '+problemCase[0].CH_PausedSinceDate__c);
		if(problemCase[0].CH_SolutionTargetDate__c != shortestSLA){
			System.debug('## Method Entered and SolutionTargetDate is Captured : '+shortestSLA);
			problemCase[0].CH_SolutionTargetDate__c = shortestSLA;
			sendToRnD = true;
			rndSubject='Problem '+problemCase[0].CaseNumber+': SolutionTargetDate Change to '+ problemCase[0].CH_SolutionTargetDate__c;
			isrndSubject=true;
		}
		if( (status == '' && problemCase[0].CH_PausedSinceDate__c !=null  ) 
		|| (status == 'Pending Customer' && (problemCase[0].CH_PausedSinceDate__c == null || problemCase[0].CH_PausedSinceDate__c != PausedSinceDate))){
		 problemCase[0].CH_PausedSinceDate__c  = PausedSinceDate;
		 sendToRnD = true;
		 System.debug('## Method Entered and PausedSinceDate is Captured : '+PausedSinceDate);
		 if(isrndSubject){rndSubject=rndSubject+' and PausedSinceDate Change to '+problemCase[0].CH_PausedSinceDate__c;}
	else {rndSubject='Problem '+problemCase[0].CaseNumber+': PausedSinceDate Change to '+problemCase[0].CH_PausedSinceDate__c;}
		}
		else if(status != 'Pending Customer' && problemCase[0].CH_PausedSinceDate__c !=null){
			problemCase[0].CH_PausedSinceDate__c  = null;
			sendToRnD = true;
			System.debug('## Method Entered and PausedSinceDate1 is Captured : '+problemCase[0].CH_PausedSinceDate__c);
	rndSubject='Problem '+problemCase[0].CaseNumber+': SolutionTargetDate Change to '+ problemCase[0].CH_SolutionTargetDate__c+' and PausedSinceDate Change to '+problemCase[0].CH_PausedSinceDate__c;
			
		}
	}
			}
			if(lstofMilestones.size() == 0){IsReEntitlementOrProblemDisassociate=True;}
		}
		if(captureCaseIdsforCaseMilestones.Size() == 0) {IsReEntitlementOrProblemDisassociate=True;}
 
			if(IsReEntitlementOrProblemDisassociate && problemCase.size()>0 && problemCase[0].CH_SolutionTargetDate__c !=null){
	if(problemCase[0].CH_SolutionTargetDate__c !=null && problemCase[0].CH_PausedSinceDate__c == null){
	rndSubject='Problem '+problemCase[0].CaseNumber+': SolutionTargetDate Change to null';
			}else{rndSubject='Problem '+problemCase[0].CaseNumber+': SolutionTargetDate Change to null and PausedSinceDate Change to null';}
	problemCase[0].CH_PausedSinceDate__c =null;
	problemCase[0].CH_SolutionTargetDate__c =null;
	sendToRnD = true;
	}
		
		if(sendToRnD  && problemCase.size()>0){
			//Send details to R&D
	for (Case getPbm : problemCase) {
	if (!getPbm.CH_R_D_Interactions__r.isEmpty()) {
		CH_ExternalInterfaceUTIL.sendSolutionTargetDateToProntoOrJira(getPbm.Id, getPbm.CH_ReportedDate__c, getPbm.CH_PausedSinceDate__c,getPbm.CH_SolutionTargetDate__c, getPbm.CaseNumber, getPbm.CH_Originating_Incident_Number__r.CaseNumber, getPbm.CH_CRNumber__c,getPbm.CH_RDInterface__c,getPbm.Severity__c,rndSubject);	 
	}
			}
	
			CH_CA_Service.upsertOnUnableToLockRow(problemCase);
		}
		
	}
/*Method Name: populateCaleaFlag	
*Author: TCS 
*Date: 26-July-2021
*Parameter: newCaseList 
*Description:CH_LawfullIntercept_CALEA__c checking true depends on Subject, Descripton, Case Country and Customer compliance
*US - NOKIASC-36342
*****************************************/
	
	public static void populateCaleaFlag(List<Case> newCaseList){
	Set<Id> accountIds = new Set<Id>();	
	for (Case newCase: newCaseList) {
	if (newCase.AccountId != null) {
	accountIds.add(newCase.AccountId);
			}
		}
	Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id,Customer_Compliance__c FROM Account WHERE Id IN :accountIds]);
		for(Case newCase:newCaseList){
			String customerCompliance = accountMap.get(newCase.AccountId)?.Customer_Compliance__c;
	 if((newCase.Subject != null && newCase.CH_CustomerDescription__c !=null && customerCompliance != null && newCase.Country__c !=null) 
	 && (newCase.Subject.containsIgnoreCase('CALEA') || newCase.CH_CustomerDescription__c.containsIgnoreCase('CALEA')) 
	 &&  (customerCompliance == 'US_Govern' || addCountries.contains(newCase.Country__c )))   
	 {
	  newCase.CH_LawfullIntercept_CALEA__c=true; 
	 }
	}
	}
/*Method Name: updateCALEAInCAPS	
*Author: TCS
*Date: 26-July-2021
*Parameter: oldCaseMap, newCaseList 
*Description: Collects the attachmet details on Case for which CH_LawfullIntercept_CALEA__c is updated and sends update requeest.
*US - NOKIASC-37029
*****************************************/
	public static void updateCALEAInCAPS(Map<Id, Case> oldCaseMap, List<Case> newCaseList) {
		Set<String> caseStatusSet = new Set<String>{'Completed','Closed','Cancelled'};
		Map<String,Boolean> attachmentMap = new Map<String,Boolean>();
		Set<Id> caseIds = New Set<Id>();
		for(Case newCase : newCaseList){
			Case oldCase = oldCaseMap.get(newCase.Id);
			if(newCase.CH_LawfullIntercept_CALEA__c!= oldCase.CH_LawfullIntercept_CALEA__c && !caseStatusSet.contains(newCase.Status)){ caseIds.add(newCase.Id);
			}
		}
		for(CH_Attachment__c chAttachment : [SELECT Id, AttachmentID__c, CH_Classification__c, CH_Status__c, Case__c, CH_Uploaded__c, Case__r.CH_LawfullIntercept_CALEA__c
			FROM CH_Attachment__c 
			WHERE Case__c  IN: caseIds LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]){ if(!string.isBlank(chAttachment.CH_Status__c) && !CAPS_ConstantHandler.DELETED_STR.equalsignorecase(chAttachment.CH_Status__c) &&  chAttachment.AttachmentID__c != null && !attachmentMap.containsKey(chAttachment.AttachmentID__c)){ attachmentMap.put(chAttachment.AttachmentID__c, chAttachment.Case__r.CH_LawfullIntercept_CALEA__c);
			}	
	}
		if(!attachmentMap.IsEmpty()){
			try{ Decimal numberOfRecords = attachmentMap.keySet().size(); Integer recordInEachJob = CAPS_ConstantHandler.ATTACHMENT_NUMBER_DEL_MANUAL; Integer numberOfIterationofJobs = integer.valueof((numberOfRecords/recordInEachJob)+1); CAPS_AttachmentUpdateCaleaqueueable job = new CAPS_AttachmentUpdateCaleaqueueable(attachmentMap); job.maximum = numberOfIterationofJobs; System.enqueueJob(job);
			}catch(Exception ex){ExceptionHandler.addException(ex,CAPS_ConstantHandler.cAPSAttachmentDelete,CAPS_ConstantHandler.updateRetentionDaysforLightning);}
			}
	}
}