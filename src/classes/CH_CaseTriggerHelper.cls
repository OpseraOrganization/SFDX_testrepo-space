/****************************************
* Class Name : CH_CaseTriggerHelper
* Created Date: 08 August 2018
* Created By : TCS
* Last Modified by: Sónia Reis
* Last Modified Date: 10 October 2019
* Description : Contains common business logic
* Test Class: CH_CaseTriggerHelperTest
*****************************************/
public class CH_CaseTriggerHelper {
	public static Map<String, Schema.SObjectField> caseFieldMap = Schema.SObjectType.Case.fields.getMap();
	public static list<CaseMilestone> milestones = null;
	
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
			//String recordTypeName = Schema.SObjectType.Case.getRecordTypeInfosById().get(caseObj.recordTypeId).getDeveloperName();
			
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
	*Method Name: verifyCountryChangeOnCase
	*Parameter: Old Case Map, New Case List (Only Case Handling Record Type Records)
	*Description: Used to re-calcualte Case Milestone if either Severity or Outage changed.
	*******************/
	//Merged below method in populateCaseFields method as part of code optimizatio --> 27620 -- By Satya
	/*public static void verifyCountryChangeOnCase (Map < Id, Case > oldCaseMap, List < Case > caseList) { 
		if ( caseList != null && !caseList.isEmpty() ) {
			List < Case > newCaseList = new List < Case > ();
			for(Case newCaseObj: caseList) {			   
				Case oldCaseObj = oldCaseMap.get(newCaseObj.Id);				
				if ( oldCaseObj.Country__c != newCaseObj.Country__c ) {
					newCaseList.add(newCaseObj);
				}			 
			}
			Map < Id, List < CH_Attachment__c > > attachMap = new Map < Id, List < CH_Attachment__c > > ();
			for ( CH_Attachment__c attachObj: [SELECT Id, Case__c FROM CH_Attachment__c WHERE Case__c =: newCaseList AND CH_Status__c NOT IN ('Deleted','Rejected','Failed') ] ) {
				if(attachObj != null ){
					if(attachMap.containsKey(attachObj.Case__c)) {
						attachMap.get(attachObj.Case__c).add(attachObj);
					} else {
						attachMap.put(attachObj.Case__c, new List < CH_Attachment__c >  { attachObj });
					}
				}				
			}
			
			for( Case caseObj: newCaseList ) {
				List < CH_Attachment__c > tempList = attachMap.get(caseObj.Id);
				if( tempList != null && !tempList.isEmpty() ) {
					caseObj.addError('Country on Case cannot be modified when there is one or more attachments associated with the case.');
				} 
			}   
		}
	}  */	 
	
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
				//String recordTypeName = caseObj.RecordType.DeveloperName;
				if((caseObj.CH_RecordTypeCheck__c == true && recordTypeName != 'CH_Problem' && String.isNotBlank(caseObj.entitlementId) && caseObj.Status == 'Cancelled') || test.isRunningTest()){
					if(caseObj.CH_IsInitialResponseSLA__c == true && caseObj.CH_IsCompleteInitialResponse__c != true){
						caseObj.CH_IsCompleteInitialResponse__c = true;
						caseObj.CH_InitialResponse__c = System.now();
					}
					if(caseObj.CH_IsSystemRestoredSLA__c == true && caseObj.CH_IsCompleteRestore__c != true){
						caseObj.CH_IsCompleteRestore__c = true;
						caseObj.CH_SystemRestored__c = System.now();
					}
					if(caseObj.CH_IsServiceDisruptionReportSLA__c == true && caseObj.CH_IsCompleteServiceDisruptionReport__c != true){
						caseObj.CH_IsCompleteServiceDisruptionReport__c = true;
						caseObj.CH_ServiceDisruptionReportProvided__c = System.now();
					}
					if(caseObj.CH_IsTemporarySolutionProvidedSLA__c == true && caseObj.CH_IsCompleteTemporarySolution__c != true){
						caseObj.CH_IsCompleteTemporarySolution__c = true;
						caseObj.CH_TemporarySolutionProvided__c = System.now();
					}
					if(caseObj.CH_IsSolutionProvidedSLA__c == true && caseObj.CH_IsCompleteSolutionProvided__c != true){
						caseObj.CH_IsCompleteSolutionProvided__c = true;
						caseObj.CH_SolutionProvided__c = System.now();
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
				   caseObj.CH_EntitlementException__c == 'Entitlement Not Listed') {
					   newCaseList.add(caseObj);
				   }
			}
			if(!newCaseList.isEmpty()) {
				setEntitlementReport(newCaseList);
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
					   if(oldCaseObj != null) {
						   if(oldCaseObj.CH_EntitlementException__c != newCaseObj.CH_EntitlementException__c ||
							  oldCaseObj.AccountId != newCaseObj.AccountId || 
							  oldCaseObj.ProductId != newCaseObj.ProductId || 
							  oldCaseObj.CH_ServiceType__c != newCaseObj.CH_ServiceType__c || 
							  oldCaseObj.Country__c != newCaseObj.Country__c) {
								  newCaseList.add(newCaseObj);
							  }
					   }  
				   } else {
					   newCaseObj.CH_EntitlementReport__c = '';
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
				if (caseObj.CH_ServiceType__c == 'Internal Support' && caseObj.ContactId != NULL){
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
												  if(caseContractMap.containsKey(key)) {
													  caseContractMap.get(key).add(lineItemObj.ServiceContractId);
												  } else {	
													  caseContractMap.put(key, new Set <Id> {lineItemObj.ServiceContractId});
												  }
											  }			
			// Clear variables for re-use
			accountIds.clear();  productIds.clear(); serviceTypes.clear(); countries.clear();
			// Get Contact Information to form Entitlement Report Text
			Map < Id, Contact > contactMap = CH_CaseTriggerDataProvider.getContactMap(contactIds);
			// Prepare another list of cases to process again whose count is 0
			List < Case > nextStepCaseList = new List < Case > ();
			for(Case caseObj: caseList) {
				//String key = caseObj.AccountId + ':' + caseObj.ProductId + ':' + caseObj.Country__c + ':' + caseObj.CH_ServiceType__c;
				String key = '';
				Integer reccount = 0;
				if(caseObj.ContactId != NULL) {
				if (caseObj.CH_ServiceType__c == 'Internal Support' && caseObj.ContactId != NULL){
					for(Account acc : nokiaacc){
					   key = acc.ID + ':' + caseObj.ProductId + ':' + caseObj.Country__c + ':' + caseObj.CH_ServiceType__c;
					   //Integer contsize = caseContractMap.get(key).size();
					   if(caseContractMap.containsKey(key)) {
					   reccount = reccount + caseContractMap.get(key).size();}
					}
					}
				else {
					key = caseObj.AccountId + ':' + caseObj.ProductId + ':' + caseObj.Country__c + ':' + caseObj.CH_ServiceType__c;
					//Integer contsize = caseContractMap.get(key).size();
					if(caseContractMap.containsKey(key)) {
						reccount = caseContractMap.get(key).size();}
					}
				if(reccount > 0) {
					caseObj.CH_EntitlementReport__c = getEntitlementReportA(caseObj, contactMap.get(caseObj.ContactId), reccount);
				} else {
					//**Change for US22365--START
				if (caseObj.CH_ServiceType__c == 'Internal Support' && caseObj.ContactId != NULL){
					for(Account acc : nokiaacc){
						  accountIds.add(acc.ID);}
					//accountIds.add(LEMap.get(contactLE).ID);
					}
				else {
					accountIds.add(caseObj.AccountId);
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
													  if(caseContractMap.containsKey(key)) {
														  caseContractMap.get(key).add(lineItemObj.ServiceContractId);
													  } else {	
														  caseContractMap.put(key, new Set <Id> {lineItemObj.ServiceContractId});
													  }
												  }
			
				
				for(Case caseObj: nextStepCaseList) {
					//String key = caseObj.AccountId + ':' + caseObj.ProductId + ':' + caseObj.Country__c + ':' + caseObj.CH_ServiceType__c;
					String key = '';
					Integer reccount = 0;
					if(caseObj.ContactId != NULL) {
					   if (caseObj.CH_ServiceType__c == 'Internal Support'){
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
		if ( caseObj.CH_ServiceType__c == 'Internal Support' && contactObj != NULL) {
			String entitlementReport = 'Entitlement Exception = ' + caseObj.CH_EntitlementException__c + '\r\n';
		entitlementReport += 'Contact Name (First Name, Last Name) = ' + (contactObj != null ? contactObj.Name : '') + '\r\n';
		entitlementReport += 'Contact Legal Entity = ' + (contactObj != null ? contactObj.CH_Legal_Entity_Name__c : '') + '\r\n\r\n';
		entitlementReport += 'There are ' + count + ' active contract line items for accounts that start with Nokia or NOKIA for Service Type = ' + caseObj.CH_ServiceType__c + ', Product = ' + caseObj.CH_Product_Name__c + ' and Country = ' + caseObj.Country__c + '. \r\n\r\n';
		entitlementReport += 'Potential reason for entitlement exception could be related to the Contact on the Case not being listed as Authorized Contact on corresponding Service Contract.';
		return entitlementReport;
			}
		else {
			String entitlementReport = 'Entitlement Exception = ' + caseObj.CH_EntitlementException__c + '\r\n';
		entitlementReport += 'Contact Name (First Name, Last Name) = ' + (contactObj != null ? contactObj.Name : '') + '\r\n';
		entitlementReport += 'Contact Legal Entity = ' + (contactObj != null ? contactObj.CH_Legal_Entity_Name__c : '') + '\r\n\r\n';
		entitlementReport += 'Account ' + caseObj.CH_Account_Name__c + ' has ' + count + ' active contract line items for Service Type = ' + caseObj.CH_ServiceType__c + ', Product = ' + caseObj.CH_Product_Name__c + ' and Country = ' + caseObj.Country__c + '. \r\n\r\n';
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
		if ( caseObj.CH_ServiceType__c == 'Internal Support' && contactObj != NULL) {
			String entitlementReport = 'Entitlement Exception = ' + caseObj.CH_EntitlementException__c + '\r\n';
		entitlementReport += 'Contact Name (First Name, Last Name) = ' + (contactObj != null ? contactObj.Name : '') + '\r\n';
		entitlementReport += 'Contact Legal Entity = ' + (contactObj != null ? contactObj.CH_Legal_Entity_Name__c : '') + '\r\n\r\n';
		entitlementReport += 'There are ' + count + ' inactive contract line items for accounts that start with Nokia or NOKIA for Service Type = ' + caseObj.CH_ServiceType__c + ', Product = ' + caseObj.CH_Product_Name__c + ' and Country = ' + caseObj.Country__c + ' where either the Service Contract OR the Contract Line Item is not active and has expired in past six months. \r\n\r\n';
		entitlementReport += 'Potential reason for entitlement exception is the Contract or Contract Line Item has expired in past 6 months or Service Contract was terminated.';
		return entitlementReport;
		}
		else
		{
		   String entitlementReport = 'Entitlement Exception = ' + caseObj.CH_EntitlementException__c + '\r\n';
		entitlementReport += 'Contact Name (First Name, Last Name) = ' + (contactObj != null ? contactObj.Name : '') + '\r\n';
		entitlementReport += 'Contact Legal Entity = ' + (contactObj != null ? contactObj.CH_Legal_Entity_Name__c : '') + '\r\n\r\n';
		entitlementReport += 'Account ' + caseObj.CH_Account_Name__c + ' has ' + count + ' contract line items for Service Type = ' + caseObj.CH_ServiceType__c + ', Product = ' + caseObj.CH_Product_Name__c + ' and Country = ' + caseObj.Country__c + ' where either the Service Contract OR the Contract Line Item is not active and has expired in past six months. \r\n\r\n';
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
		if ( caseObj.CH_ServiceType__c == 'Internal Support' && contactObj != NULL ) {
			String entitlementReport = 'Entitlement Exception = ' + caseObj.CH_EntitlementException__c + '\r\n';
		entitlementReport += 'Contact Name (First Name, Last Name) = ' + (contactObj != null ? contactObj.Name : '') + '\r\n';
		entitlementReport += 'Contact Legal Entity = ' + (contactObj != null ? contactObj.CH_Legal_Entity_Name__c : '') + '\r\n\r\n';
		entitlementReport += 'There are no contract line items for accounts that start with Nokia or NOKIA for Service Type = ' + caseObj.CH_ServiceType__c + ', Product = ' + caseObj.CH_Product_Name__c + ' and Country = ' + caseObj.Country__c + ' where either the Service Contract OR the Contract Line Item is Inactive and expired in past six months. \r\n\r\n';
		entitlementReport += 'Potential reason for entitlement exception is the Service Contract or Contract Line Item has expired more than 6 months ago OR the Service Contract was terminated OR Customer has never had entitlement coverage for request service for product that is listed OR Incorrect Account is being used on CASE.';
		return entitlementReport;
		}
		else {
		   String entitlementReport = 'Entitlement Exception = ' + caseObj.CH_EntitlementException__c + '\r\n';
		entitlementReport += 'Contact Name (First Name, Last Name) = ' + (contactObj != null ? contactObj.Name : '') + '\r\n';
		entitlementReport += 'Contact Legal Entity = ' + (contactObj != null ? contactObj.CH_Legal_Entity_Name__c : '') + '\r\n\r\n';
		entitlementReport += 'Account ' + caseObj.CH_Account_Name__c + ' has no contract line items for Service Type = ' + caseObj.CH_ServiceType__c + ', Product = ' + caseObj.CH_Product_Name__c + ' and Country = ' + caseObj.Country__c + ' where either the Service Contract OR the Contract Line Item is Inactive and expired in past six months. \r\n\r\n';
		entitlementReport += 'Potential reason for entitlement exception is the Service Contract or Contract Line Item has expired more than 6 months ago OR the Service Contract was terminated OR Customer has never had entitlement coverage for request service for product that is listed OR Incorrect Account is being used on CASE.';
		return entitlementReport; 
		}
		//**Change for US22365--END
	}
	
	@testVisible
	private static Set<Case> casesWithErrors = new Set<Case>();
	
	/****** Commented as part of NOKIASC-27612
	public static void createS2SCAPSAttachmentsOnInsert(List<Case> newCaseList){
		CAPS_UpdateToCAPS4NAIPAttachment.processAttachmentOnCaseCreation(newCaseList);
	}
	public static void createS2SCAPSAttachmentsOnUpdate(Map<Id,Case> oldCaseMap, List<Case> caseList){
		CAPS_UpdateToCAPS4NAIPAttachment.processAttachmentOnCaseUpdate(oldCaseMap,caseList);
	}*/
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
			// Check caseList is not empty
			if(!caseList.isEmpty()) {
				Set < Id > accountIds = new Set < Id > ();
				Set < Id > entitlementIds = new Set < Id > ();
				Map < String, Case > caseMap = new Map < String, Case > ();
				
				// Prepare Key to search relevant records in CustomerSpecificTargetSLA objects
				for(Case caseObj: caseList) {
					String caseKey = caseObj.EntitlementId;
					accountIds.add(caseObj.AccountId);
					entitlementIds.add(caseObj.EntitlementId);
					if(updateSLAReference == true) {
						// Reset SLA fields to set new value as per SLA status
						caseObj.CH_SLACritical__c = null;
						caseObj.CH_SLAMajorNonOutage__c = null;
						caseObj.CH_SLAMajorOutage__c = null;
						caseObj.CH_SLAMinor__c = null;
						caseObj.CH_SLAInformationRequest__c = null;						
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
				
				// Removed Entitlement Parameter - CH_Entitlement__c IN :entitlementIds AND 
				for(CH_CustomerSpecificTargetSLA__c slaObj: [SELECT Id, CH_Account__c, CH_Entitlement__c, CH_LineItemNumber__r.AssetId, CH_Severity__c, CH_Outage__c, CH_IR_Unit__c, CH_IR_WorkMins__c, CH_SR_Unit__c, CH_SR_WorkMins__c, CH_SDR_Unit__c, CH_SDR_WorkMins__c, CH_TSP_Unit__c, CH_TSP_WorkMins__c, CH_SP_Unit__c, CH_SP_WorkMins__c, CH_SPD_Unit__c, CH_SPD_WorkMins__c FROM CH_CustomerSpecificTargetSLA__c WHERE CH_Entitlement__c IN :entitlementIds AND CH_SLARecordStatus__c = 'Active']) { 
					String slaKey = slaObj.CH_Entitlement__c;
					Case caseObj = caseMap.get(slaKey);
					//Modified Line 387 for NOKIASC-21630 26/08/2019- Suniti
					if((caseObj != null) && (String.isEmpty(caseObj.CH_LegacyCaseNumber__c))){
						if(caseObj.Severity__c == slaObj.CH_Severity__c && (caseObj.Severity__c == 'Critical' || caseObj.CH_Outage__c == slaObj.CH_Outage__c)) {
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
							if(caseObj.CH_Defect__c == false && slaObj.CH_SP_WorkMins__c != null && Integer.valueOf(slaObj.CH_SP_WorkMins__c) > 0) {
								caseObj.CH_IsSolutionProvidedSLA__c = true;
							} 
							// Solution Provided (Defect)
							else if(caseObj.CH_Defect__c == true && slaObj.CH_SPD_WorkMins__c != null && Integer.valueOf(slaObj.CH_SPD_WorkMins__c) > 0) {
								caseObj.CH_IsSolutionProvidedSLA__c = true;
							}
						}
						if(updateSLAReference == true) {
							// Update SLA Field on Case Object
							if(slaObj.CH_Severity__c == 'Critical') { 
								caseObj.CH_SLACritical__c = slaObj.Id;
							} else if(slaObj.CH_Severity__c == 'Major' && slaObj.CH_Outage__c == 'No') {
								caseObj.CH_SLAMajorNonOutage__c = slaObj.Id;
							} else if(slaObj.CH_Severity__c == 'Major' && slaObj.CH_Outage__c == 'Yes') {
								caseObj.CH_SLAMajorOutage__c = slaObj.Id;
							} else if(slaObj.CH_Severity__c == 'Minor') { 
								caseObj.CH_SLAMinor__c = slaObj.Id;
							} else if(slaObj.CH_Severity__c == 'Information Request' && slaObj.CH_Outage__c == 'No') {
								caseObj.CH_SLAInformationRequest__c = slaObj.Id;
							}
						}
						
					}
					
					//Added this part of code for NOKIASC-21630 28/08/2019- Suniti
					if((caseObj != null) && (String.isNotEmpty(caseObj.CH_LegacyCaseNumber__c)) && (updateSLAReference == true)){
				// Update SLA Field on Case Object
						if(slaObj.CH_Severity__c == 'Critical') { 
							caseObj.CH_SLACritical__c = slaObj.Id;
						} else if(slaObj.CH_Severity__c == 'Major' && slaObj.CH_Outage__c == 'No') {
							caseObj.CH_SLAMajorNonOutage__c = slaObj.Id;
						} else if(slaObj.CH_Severity__c == 'Major' && slaObj.CH_Outage__c == 'Yes') {
							caseObj.CH_SLAMajorOutage__c = slaObj.Id;
						} else if(slaObj.CH_Severity__c == 'Minor') { 
							caseObj.CH_SLAMinor__c = slaObj.Id;
						} else if(slaObj.CH_Severity__c == 'Information Request' && slaObj.CH_Outage__c == 'No') {
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
					oldCase.EntitlementId != oCase.EntitlementId) {
						oCaseListSLAChange.add(oCase);
					}
					else if(oldCase.Severity__c != oCase.Severity__c || 
					oldCase.CH_Outage__c != oCase.CH_Outage__c ||  
					oldCase.CH_Defect__c != oCase.CH_Defect__c) {
						oCaseListSLAReset.add(oCase);
					}
				}
			}
			if(!oCaseListSLAChange.isEmpty()) {
				setFlagForCaseMilestone(oCaseListSLAChange, true);
			}
			if(!oCaseListSLAReset.isEmpty()) {
				setFlagForCaseMilestone(oCaseListSLAReset, false);
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
				if(oldCaseObj != null) {
					if(oldCaseObj.CH_InitialResponse__c != caseObj.CH_InitialResponse__c || 
					   oldCaseObj.CH_SystemRestored__c != caseObj.CH_SystemRestored__c ||
					   oldCaseObj.CH_ServiceDisruptionReportProvided__c != caseObj.CH_ServiceDisruptionReportProvided__c || 
					   oldCaseObj.CH_TemporarySolutionProvided__c != caseObj.CH_TemporarySolutionProvided__c ||  
					   oldCaseObj.CH_SolutionProvided__c != caseObj.CH_SolutionProvided__c) {
						   chCaseList.add(caseObj);
					   }
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
						} else if(oldCaseObj.CH_TemporarySolutionProvided__c == null && caseObj.CH_TemporarySolutionProvided__c == null) {
							caseObj.CH_TemporarySolutionProvided__c = slaTime;  
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
					if(caseObj.CH_LegacyInitialResponseTargetDate__c != null) {
						if(oldCaseObj.CH_InitialResponse__c == null && caseObj.CH_InitialResponse__c == null) {
							caseObj.CH_InitialResponse__c = slaTime;	
						}
					}
				} /* else if (caseObj.CH_DeferralStatus__c =='Active' ) {
if(caseObj.CH_DeferredSolutionProvidedTarget__c != null) {
slaTime = caseObj.CH_SolutionProvided__c;							
}
} */else {
	if(caseObj.CH_IsSolutionProvidedSLA__c && caseObj.CH_SolutionProvided__c != null) {
		slaTime = caseObj.CH_SolutionProvided__c;
		skipSDRMilestone = true;
	}
	// Temporary Solution Provided
	if(!caseObj.CH_TemporarySolutionNotApplicable__c && caseObj.CH_IsTemporarySolutionProvidedSLA__c) {		 
		if(caseObj.CH_TemporarySolutionProvided__c != null) { 
			slaTime = caseObj.CH_TemporarySolutionProvided__c; 
		} else if(oldCaseObj.CH_TemporarySolutionProvided__c == null && caseObj.CH_TemporarySolutionProvided__c == null) {
			caseObj.CH_TemporarySolutionProvided__c = slaTime;  
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
	if(caseObj.CH_IsInitialResponseSLA__c) {
		if(oldCaseObj.CH_InitialResponse__c == null && caseObj.CH_InitialResponse__c == null) {
			caseObj.CH_InitialResponse__c = slaTime;	
		}
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
					System.debug('### Exception has raised : ' + ex.getMessage());
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
*			   User Story: NOKIASC-494
*******************/
	public static void validateServiceCaseCreation(List < Case > newCaseList, Map <Id,Case> oldCaseMap) {
		// Check if there are any CH type cases in the new list
		if (newCaseList != null && !newCaseList.isEmpty()) {
			List < Case > chCaseList = new List < Case > ();
			//Process the list of CH specific cases
			for (Case c: newCaseList) {
				//If Asset and Entitlement are selected - check that Contact is authorised
				if(c.AssetId != null && c.ContactId != null && c.EntitlementId != null && c.CH_ServiceType__c != 'Internal Support' && (oldCaseMap.isEmpty() || (!oldCaseMap.isEmpty() && c.ContactId != oldCaseMap.get(c.Id).ContactId))) {
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
*			   User Story: NOKIASC-494
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
				cObj.addError('This Entitlement does not cover this Asset');
			}		   
		} 
		if(!notAuthorizedCases.isEmpty()) {
			for(Case cObj: notAuthorizedCases) {
				if(String.isBlank(cObj.CH_LegacyCaseNumber__c)){
					cObj.addError('This Contact is not Authorised');
				}	
			}		   
		}
	}		
	
	/********************
	*Method Name: validAsset
	*Parameter: New Case List (Only Case Handling Record Type Records)
	*Last updated by: Pratesax
	*Description: Method to validate individual Case If Asset is null Entitlement and country both should not be null and vice versa.
	*User Story: NOKIASC- 494
	*******************/
	//Merged below method in populateCaseFields method as part of code optimizatio --> 27620 -- By Satya
   /* public static void validAsset(List < Case > newCaseList) {
		for (Case caseObj: newCaseList) {
			//String recordTypeName = Schema.SObjectType.Case.getRecordTypeInfosById().get(caseObj.recordTypeId).getName();
			String recordTypeName = caseObj.RecordType.DeveloperName;
			// If Asset is null Entitlement and country both should not be null
			if(caseObj.AssetId == null && caseObj.Entitlement.name == null && (caseObj.Country__c == null || caseObj.ProductId==null)&& 
			   (caseObj.CH_ServiceType__c=='Customer Support' || caseObj.CH_ServiceType__c==null) && 
			   (recordTypeName == 'Nokia Standard Case' || recordTypeName == 'Nokia Incident with Restoration' || recordTypeName == 'Nokia Information Request')) {
				   caseObj.addError('If Asset and Entitlement are blank then Country and Product cannot be blank'); 
			   }
		}
	}*/
	
	/*****Scrambling Logic****/
	/***************************************************************** 
	Description:  Logic to fetch the Case fields and recordtype values.
	Returns: void 
	History															 
	DATE		   AUTHOR					Change 
	03/08/2018	 Praveenkumar		 		Created 
	03/09/2018	 tiago.almeida@nokia.com		Updated 
	*****************************************************************/ 
	public static void fetchCaseFields(List < Case > newCaseList, Map < Id, Case > oldCaseMap) {
		List < String > fieldNameList = new List < String > ();
		for(CH_CaseFieldValues__mdt csvObj : [SELECT CH_FieldNames__c FROM CH_CaseFieldValues__mdt]){
			fieldNameList.add(csvObj.CH_FieldNames__c);
		}
		for(Case caseObj: newCaseList) {
			scramblingLogic(caseObj, oldCaseMap != null && oldCaseMap.containsKey(caseObj.Id)?oldCaseMap.get(caseObj.Id):null, fieldNameList);
		}
	}
	
	/***************************************************************** 
	Description:  Logic to check the Case fields with the pattern match and replaced with blockng characters.
	Returns: void 
	History															 
	DATE		   AUTHOR					Change 
	03/08/2018	 Praveenkumar		 		Created 
	03/09/2018	 tiago.almeida@nokia.com		Updated 
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
	*Method Name: validateCaseCreation
	*Parameter: New Case List (Only Case Handling Record Type Records)
	*Last updated by: Pratesax
	*Description: Method to validate individual Case If Asset is null Entitlement and country both should not be null and vice versa.
	*User Story: NOKIASC- 494
	*******************/
	//Merged below method in populateCaseFields method as part of code optimizatio --> 27620 -- By Satya
   /* public static void validateCaseCreation(List < Case > caseList) {
		if (caseList != null ) {
			Set < Id > contactIds = new Set < Id > ();
			for(Case caseObj: caseList){
				if(caseObj.contactId != null)
					contactIds.add(caseObj.ContactId);
			}
			 //Using Global/Common query as part of Code Optimization -- 27617 --> By Satya Pagadala
			Map < Id, Contact > contactMap = CH_Utils.getContactMap(contactIds);
			for (Case caseObj: caseList) {
				if(contactMap.containsKey(caseObj.ContactId)){   
					if((caseObj.CH_ServiceType__c == 'Internal Support' && contactMap.get(caseObj.contactId).CH_contactType__c != 'Nokia Employee')){
						caseObj.addError('With Service Type as Internal Support Contact Type should be Nokia Employee');
					}
					if((caseObj.CH_ServiceType__c == 'Internal Support' && contactMap.get(caseObj.contactId).CH_contactType__c== 'Nokia Employee' )
					   && (caseObj.CH_Outage__c == 'Yes' || (caseObj.Severity__c == 'Critical' || caseObj.Severity__c == 'Information Request' ))){
						   caseObj.addError('If the ticket is type internal support you are not allowed severity Critical or Information Request, and cannot set outage to yes');
					   }   
				}
			}
		}
	}*/
	
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
						c.CH_Solution__c = assetMap.get(c.AssetId).CH_Solution__c;
						c.ProductId = assetMap.get(c.AssetId).Product2Id;  
						//TSALEM: this is the suggested additional line of code from https://yoursl.atlassian.net/browse/NOKIASC-10817 (just make sure to add the new real field name)
						c.CH_ProductName__c = assetMap.get(c.AssetId).Product2Id;
						c.CH_Product_Release__c  = assetMap.get(c.AssetId).CH_ProductRelease__c;					
						c.CH_ProductVariant__c = assetMap.get(c.AssetId).CH_ProductVariant__c;
						c.Country__c = assetMap.get(c.AssetId).CH_CountryISOName__c; 
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
		List <String> recordTyps = new List <String> ();		
		Set < Id > productIds = new Set < Id > ();	 
		List < String > listOfAccNames = new List < String > ();
		List < String > listOfPrdCodes = new List < String > ();	
		Map < Id, String > caseProdMap = new Map < Id, String > ();
		Map < Id, Product2 > productMap = new Map < Id, Product2> ();
		List < CH_BlacklistRecords__c > lBlockRecords = CH_BlacklistRecords__c.getAll().values();
		for(Case caseRecord: caseList){
			//String recordTypeName = Schema.SObjectType.Case.getRecordTypeInfosById().get(caseRecord.recordtypeid).getname();
			//Commenting the below code as part of code optimization where recordtype is already being checked in CH_CaseTriggerHandler
			/*String recordTypeName = caseRecord.RecordType.DeveloperName;
			if((recordTypeName == 'Nokia Standard Case') || (recordTypeName == 'Nokia Incident with Restoration') 
			   || (recordTypeName == 'Problem') || (recordTypeName == 'Nokia Information Request')){*/ 
				   //recordTyps.add(recordTypeName);
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
					if((caseNewRec.accountId != null) && ((accountMap.get(caseNewRec.Accountid).CountryCode__c == null 
														   ||(accountMap.get(caseNewRec.AccountId).CountryCode__c != null 
															  && accountMap.get(caseNewRec.AccountId).CountryCode__c == 'WF')))){
																  caseNewRec.CH_BlockCases__c = true;
																  system.debug('Sri Test@1111'+accountMap.get(caseNewRec.Accountid).CountryCode__c);
															  }					 
					if(caseNewRec.AccountId != null && accountMap.get(caseNewRec.AccountId).Name != null){				
						String accName=accountMap.get(caseNewRec.AccountId).Name;
						caseAccountMap.put(caseNewRec.Id, accName);
					} 
				}   
	//Commented code and moved to CH_PopulateCaseFields method
				/*if(caseNewRec.Status == 'Cancelled' || caseNewRec.Status == 'Draft'){ 
					||(caseNewRec.CH_ServiceType__c != 'Customer Support' &&
caseNewRec.CH_ServiceType__c != 'Internal Support')
					caseNewRec.CH_BlockCases__c = true;
					system.debug('Sri Test@2222'+caseNewRec.CH_BlockCases__c);
				} else{
					
					caseNewRec.CH_BlockCases__c = false;					
					system.debug('Sri Test@3333'+caseNewRec.CH_BlockCases__c);
				}*/  
			}
		}   
		if(!caseList.isEmpty()){ 
			for(Case caseNewRec:caseList){
				if(productMap.containsKey(caseNewRec.ProductID)){
					if(caseNewRec.ProductID != null && productMap.get(caseNewRec.ProductId).ProductCode != null){
						String prodCods=productMap.get(caseNewRec.ProductId).ProductCode;   
						caseProdMap.put(caseNewRec.Id, prodCods);
						system.debug('Sri Test@3333'+caseNewRec.CH_BlockCases__c);
					}	
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
																		  system.debug('Sri Test'+caseUpdRec.CH_BlockCases__c);
																	  }
		}	  
		
	}
	
  
	
	//Changed method to handle single record , as part of US # 27622
	@future
	public static void RouteNewProblems(Id problemCaseId) {
		try{
		Case problemRecord = [Select id, OwnerId, CH_SecurityGroup__c from Case where id = :problemCaseId];
		// Get all passive workgroup members that can be assigned to the problem 
			CH_CA_Service service = new CH_CA_Service(problemRecord.Id);
			List<CH_CA_DTO.WorkgroupMemberDTO> foundWorkgroupMembers = service.getPassiveCaseAssignmentWorkgroupMembers();
			Id oldOwnerId = problemRecord.OwnerId;
	 Set<Id> WMDIds = new Set<Id>();
		   Map<id ,CH_Workgroup_Member__c> assignments = new Map<id,CH_Workgroup_Member__c>();
			for(CH_CA_DTO.WorkgroupMemberDTO workgroupMember : foundWorkgroupMembers)
			{
	if (workgroupMember.type == 'Queue')
	{
		WMDIds.add(workgroupMember.id);
	}		  
			}
			// Assign the case to the first queue
			for (CH_Workgroup_Member__c workgroupMember : ([SELECT Id, CH_Workgroup__c, CH_User__c, Name, 
		 CH_Workgroup_Member_Type__c, CH_Queue_Email__c,CH_Workgroup__r.Name
	 FROM CH_Workgroup_Member__c WHERE Id IN :WMDIds]))
			{
		CH_Workgroup_Member__c validWorkgroupMember = workgroupMember;
		assignments.put(problemRecord.Id,validWorkgroupMember);
			}
			if(!assignments.isEmpty())
			{
	service.assignUser(assignments);
			} 		
		   // Code to log a message when no queue was found. 
			Id newOwnerId = problemRecord.OwnerId;
			if (oldOwnerId == newOwnerId){
	system.debug('CH_CA: No Queue found to Assign the problem to. Problem with Id ' + problemRecord.id + ' assigned to creator: ' + problemRecord.OwnerId);			
			}
		}
		catch(Exception e){}
		
	}
	
	
	 public static void AddoRemoveProblemOwnerForCases(Map < Id, Case > oldCaseMap, List < Case > newCaseList) {
		system.debug('AddoRemoveProblemOwnerForIncidentCase Method Starts Here >>');
		List < Case > processCaseList = new List < Case > ();	
		Set < Id > problemCaseIds = new Set < Id > ();
		Set<Id> problemCaseSet = new Set<Id>();
		for(Case caseObj: newCaseList) {
			if(caseObj.Id !=null && oldCaseMap !=null &&caseObj.CH_Problem__c != oldCaseMap.get(caseObj.Id).CH_Problem__c ){
				processCaseList.add(caseObj);//List to remove existing Problem Owner the Team Members 
				if(caseObj.CH_Problem__c != null){
					problemCaseIds.add(caseObj.CH_Problem__c);//Only Incident Case 
				}
			} else  if(oldCaseMap ==null && caseObj.CH_RouteCase__c && caseObj.RecordTypeId == Schema.SObjectType.Case.getRecordTypeInfosByName().get('Problem').getRecordTypeId()) {
				system.debug('  AddoRemoveProblemOwnerForIncidentCase Assigning Problem Id');
				problemCaseSet.add(caseObj.id);//Only Problem CAse during Case Creation
			}
		}
		if(!processCaseList.isEmpty()) {
			// Delete existing CaseTeamMembers
			List < CaseTeamMember > oldCaseTeamMemberList = [SELECT Id, TeamRoleId FROM CaseTeamMember WHERE ParentId IN:processCaseList and TeamRole.Name = 'Problem Owner'];
			try {
				delete oldCaseTeamMemberList;
			} catch(Exception ex) {
				System.debug('### AddProblemOwnerForUpdatedCases # ' + ex.getMessage());
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
						System.debug('### AddProblemOwnerForNewCases # ' + ex.getMessage());
					}
				}
			}  
		}
		
		//Adding piece of code that does not run when creating a Problem through the flow CH_CreateProblemFromIncidentnProduct (INC5).
		//Adding here to avoid filtering Problems again in a new method. Also added problemCaseList above. Fix for NOKIASC-25486
	List<Id> problemCaseList = new List<Id>(problemCaseSet);
		System.debug('### AddProblemOwnerForNewCases ###  problemCaseList ### START ### ' + problemCaseList);
		if(problemCaseList.size() > 0){
			RouteNewProblems(problemCaseList[0]);
		}
		system.debug('AddoRemoveProblemOwnerForIncidentCase Method eNDS Here >>');
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
			/*Uncomment when Changes in CAPS for other field update ready
			Boolean productChange = false;
			Boolean entitlementChange = false;
			Boolean accountChange = false;
			Boolean securityGroupChange = false;
			Boolean productReleaseChange = false;
			Uncomment when Changes in CAPS for other field update ready*/
			for(Case csObj: newCaseList) {
				caseParamVsUpdateFieldsMap = new Map<String, String>();
				if(CH_AvoidRecursion.afterUpdateCAPSCaseStatus){
					if(!String.isBlank(csObj.Status) && (CAPS_ConstantHandler.CLOSED_STATUS.equalsignorecase(csObj.Status) || 
														 CAPS_ConstantHandler.CANCELLED_STATUS.equalsignorecase(csObj.Status)) && !(csObj.Status.equalsignorecase(oldCaseMap.get(csObj.Id).Status)))
						
					{//when Case is closed and cancelled
						caseIdVsCaseStatusMap.put(csObj.Id, csObj.Status);
						caseParamVsUpdateFieldsMap.put(CAPS_ConstantHandler.CASESTATUS, csObj.Status);
						statusChange = true;
					}
				}
				/*commenting as CAPS does not support - Uncomment when Changes in CAPS for other field update ready
if(CH_AvoidRecursion.afterUpdateCAPSCaseProduct && csObj.ProductId != null && !String.isBlank(csObj.CH_Product_Code_CAPS__c) && (csObj.ProductId)  != (oldCaseMap.get(csObj.Id).ProductId))
{
caseParamVsUpdateFieldsMap.put(CAPS_ConstantHandler.PRODUCTID, csObj.CH_Product_Code_CAPS__c);
productChange = true;
}
if(CH_AvoidRecursion.afterUpdateCAPSCaseEntitlement && csObj.EntitlementId!=null && !String.isBlank(csObj.CH_Customer_CDB_for_Caps__c) && (csObj.EntitlementId) != (oldCaseMap.get(csObj.Id).EntitlementId))
{
caseParamVsUpdateFieldsMap.put(CAPS_ConstantHandler.CDBCUSTOMERID, csObj.CH_Customer_CDB_for_Caps__c);
entitlementChange = true;

}
if(CH_AvoidRecursion.afterUpdateCAPSCaseAccount && csobj.AccountId!=null && !String.isBlank(csObj.CH_Referential_Id_for_CAPS__c) && (csObj.AccountId) != (oldCaseMap.get(csObj.Id).AccountId))
{
caseParamVsUpdateFieldsMap.put(CAPS_ConstantHandler.REFERENTIALID, csObj.CH_Referential_Id_for_CAPS__c);
accountChange = true;

}
if(CH_AvoidRecursion.afterUpdateCAPSCaseSG && !String.isBlank(csObj.CH_SecurityGroup__c) && (csObj.CH_SecurityGroup__c != oldCaseMap.get(csObj.Id).CH_SecurityGroup__c))
{
caseParamVsUpdateFieldsMap.put(CAPS_ConstantHandler.SECURITYGROUP, csObj.CH_SecurityGroup__c);
securityGroupChange =true;

}
if(CH_AvoidRecursion.afterUpdateCAPSCaseProductRelease && csObj.CH_Product_Release__c!=null && !String.isBlank(csObj.CH_Product_Version_Id_for_CAPS__c) && (csObj.CH_Product_Release__c) != (oldCaseMap.get(csObj.Id).CH_Product_Release__c))
{
caseParamVsUpdateFieldsMap.put(CAPS_ConstantHandler.PRODUCTVERSIONID, csObj.CH_Product_Version_Id_for_CAPS__c);
productReleaseChange = true;

}commenting as CAPS does not support - Uncomment when Changes in CAPS for other field update ready*/
				//populate only if caseParamVsUpdateFieldsMap is not empty. reinitialized in each iteration
				if(!caseParamVsUpdateFieldsMap.isEmpty()) {
					caseIdVsMapOfUpdateFieldsMap.put(csObj.Id,caseParamVsUpdateFieldsMap);
				}
			}
			if(statusChange){
				CH_AvoidRecursion.afterUpdateCAPSCaseStatus = false;
			}
			/* Uncomment when Changes in CAPS for other field update ready
if(productChange){
CH_AvoidRecursion.afterUpdateCAPSCaseProduct = false;
}
if(entitlementChange){
CH_AvoidRecursion.afterUpdateCAPSCaseEntitlement = false;
}
if(accountChange){
CH_AvoidRecursion.afterUpdateCAPSCaseAccount = false;
}
if(securityGroupChange){
CH_AvoidRecursion.afterUpdateCAPSCaseSG = false;
}
if(productReleaseChange){
CH_AvoidRecursion.afterUpdateCAPSCaseProductRelease = false;
}
Uncomment when Changes in CAPS for other field update ready*/
			if(!caseIdVsMapOfUpdateFieldsMap.isEmpty() && caseIdVsMapOfUpdateFieldsMap.keySet() != null && !caseIdVsMapOfUpdateFieldsMap.keySet().isEmpty()) {//get CAPS attachment ids
				combinedListSize = 0;
				for(CH_Attachment__c chAttachment : [SELECT Id, AttachmentID__c, CH_Classification__c, CH_Status__c, Case__c, CH_Uploaded__c  
													 FROM CH_Attachment__c 
													 WHERE Case__c  IN: caseIdVsMapOfUpdateFieldsMap.keySet()   
													 LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]) 
				{
					if(!string.isBlank(chAttachment.CH_Status__c) && !CAPS_ConstantHandler.DELETED_STR.equalsignorecase(chAttachment.CH_Status__c))
					{
						if(chAttachment.AttachmentID__c != null && !attachmentIdSet.contains(chAttachment.AttachmentID__c))
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
								/*commenting as CAPS does not support - Uncomment when Changes in CAPS for other field update ready
attachmentIdVsUpdateFieldsMap.put(chAttachment.AttachmentID__c, caseIdVsMapOfUpdateFieldsMap.get(chAttachment.Case__c));
attachmentIdSet.add(chAttachment.AttachmentID__c);// when Case is closed and non-sensitive attachment
combinedListSize++;
commenting as CAPS does not support - Uncomment when Changes in CAPS for other field update ready*///increment counter
							}
						}
						/*if(combinedListSize > calloutLimit) {// break FROM loop if list has more than call out limit in single transaction
							break;
						}*/
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
*			   the new value should be reflected on all the related incidents (cases) NOKIASC-14381 
*******************/
	public static boolean updateIndidentDefectOnlyOneTime = false;
	
	public static void updateIncidentsDefect(map<id, Case> oldCases, list<Case> newCasesList) {
		system.debug(Logginglevel.ERROR, '###CH_CaseTriggerHelper:updateIncidentsDefect:START:');
		map<id, Case> newCases = new map<id, Case>(newCasesList); 
		if(!updateIndidentDefectOnlyOneTime){
			list<Id> eligibleProblemIds = new list<Id>();
			for(Case aCase : newCases.values()){
				if(aCase.CH_RecordTypeDevName__c == 'CH_Problem' && (aCase.CH_Defect__c != oldCases.get(aCase.Id).CH_Defect__c))
					eligibleProblemIds.add(aCase.Id);
				if(aCase.CH_RecordTypeDevName__c != 'CH_Problem' && aCase.CH_Problem__c != null && (aCase.CH_Problem__c != oldCases.get(aCase.Id).CH_Problem__c))
					eligibleProblemIds.add(aCase.CH_Problem__c);
			}
			system.debug(Logginglevel.ERROR, '###CH_CaseTriggerHelper:updateIncidentsDefect:eligibleProblemIds:' + eligibleProblemIds); 
			if(!eligibleProblemIds.isEmpty()){
				list<Case> incidentsToUpdate = new list<Case>();
				for(Case aCase : [SELECT CH_Defect__c, CH_Problem__c FROM Case WHERE CH_Problem__c IN :eligibleProblemIds])
					if(newCases.containsKey(aCase.CH_Problem__c) && aCase.CH_Defect__c != newCases.get(aCase.CH_Problem__c).CH_Defect__c)
					incidentsToUpdate.add(new Case(Id = aCase.Id, CH_Defect__c = newCases.get(aCase.CH_Problem__c).CH_Defect__c));
				system.debug(Logginglevel.ERROR, '###CH_CaseTriggerHelper:updateIncidentsDefect:incidentsToUpdate:' + incidentsToUpdate);
				if(!incidentsToUpdate.isEmpty())
					update incidentsToUpdate;
			}
			updateIndidentDefectOnlyOneTime = true; 
		}
		system.debug(Logginglevel.ERROR, '###CH_CaseTriggerHelper:updateIncidentsDefect:END:');
	}
	
	/********************
*Method Name: updateParentIncident
*Author: Marwan Boutaleb (mboutaleb@salesforce.com)
*Parameter: New Cases List
*Description: When an incident problem lookup is updated, its value is reflected on the parentId case lookup NOKIASC-14380
*******************/
   public static void updateProblemParentIncident(Map < Id, Case > oldCaseMap, list<Case> newCasesList){
		system.debug(Logginglevel.ERROR, '###CH_CaseTriggerHelper:updateParentIncident:START:');
		for(Case aCase : newCasesList){
			system.debug(aCase.CH_RecordTypeCheck__c+aCase.CH_RecordTypeDevName__c+'@@@@@ ####updateParentIncidentOneRun CH_RecordTypeCheck__c'+aCase.CH_Problem__c+'@@@'+oldCaseMap.get(aCase.id).CH_Problem__c);
			if(aCase.CH_RecordTypeCheck__c && aCase.CH_RecordTypeDevName__c != 'CH_Problem' && oldCaseMap.get(aCase.id).CH_Problem__c != aCase.CH_Problem__c){
				aCase.parentId = aCase.CH_Problem__c;
			}
		}
		system.debug(Logginglevel.ERROR, '###CH_CaseTriggerHelper:updateParentIncident:END:');
	}
	
	/********************
*Method Name: addProblemChatterPost
*Author: Marwan Boutaleb (mboutaleb@salesforce.com)
*Parameter: Old cases map, New Cases List
*Description: When an incident is related/dissociated from a problem a chatter notification is created on the problem   
*******************/
	public static boolean problemChatterPostRun = false;
	public static void addProblemChatterPost(map<id, Case> oldCases, list<Case> newCasesList){
		map<id, Case> newCases = new map<id, Case>(newCasesList);
		if(!problemChatterPostRun){
			list<FeedItem> newChatterPosts = new list<FeedItem>();
			for(Case aCase : newCases.values())
				if( aCase.CH_Problem__c != oldCases.get(aCase.Id).CH_Problem__c &&
				   aCase.CH_RecordTypeCheck__c == true && 
				   aCase.CH_RecordTypeDevName__c != 'CH_Problem'){
					   if(aCase.CH_Problem__c != null) 
						   newChatterPosts.add(new FeedItem(   ParentId = aCase.CH_Problem__c, 
															Type = 'TextPost', 
															Body = 'Incident ' + aCase.CaseNumber + ' has been related to your Problem'));
					   if(oldCases.get(aCase.Id).CH_Problem__c != null) 
						   newChatterPosts.add(new FeedItem(   ParentId = oldCases.get(aCase.Id).CH_Problem__c, 
															Type = 'TextPost', 
															Body = 'Incident ' + aCase.CaseNumber + ' has been disassociated from your Problem'));
				// Created the Chatter Post for NOKIASC-27235 
						   newChatterPosts.add(new FeedItem(ParentId = aCase.Id, 
															Type = 'TextPost', 
															Body = 'Incident ' + aCase.CaseNumber + ' has been disassociated from your Problem'));
				   }
			if(!newChatterPosts.isEmpty())
				insert newChatterPosts;
			problemChatterPostRun = true; 
		} 
	}
	
	public static void addCCMToCaseTeam(List <Case> updatedCasesList){
		if(!updatedCasesList.isEmpty()){
			Id problemRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Problem').getRecordTypeId();
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
			Id problemRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Problem').getRecordTypeId();
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
	
	/********************
	*Method Name: productAssetValidation
	*Parameter: New Case List (Only Case Handling Record Type Records)
	*Last updated by: Pratesax
	*Description: Cannot modify product details when Asset is  Set.
	*User Story: NOKIASC- 494
	*******************/
	//Merged below method in populateCaseFields method as part of code optimizatio --> 27620 -- By Satya
	/*public static void productAssetValidation(map<id, Case> oldCases,List < Case > caseList){
		if(!caseList.isEmpty() && !oldCases.isEmpty()){
			for(Case newCase: caseList){
				//String recordTypeName = Schema.SObjectType.Case.getRecordTypeInfosById().get(newCase.recordTypeId).getName();
				String recordTypeName = newCase.RecordType.DeveloperName;
				if(recordTypeName != 'Problem' && (oldCases.get(newCase.Id).AssetId !=null)){
					if((oldCases.get(newCase.Id).AssetId == newCase.AssetId) &&
					   (oldCases.get(newCase.Id).ProductId!=newCase.ProductId ||
						oldCases.get(newCase.Id).CH_Product_Release__c!=newCase.CH_Product_Release__c ||
						oldCases.get(newCase.Id).CH_ProductVariant__c!=newCase.CH_ProductVariant__c ||
						oldCases.get(newCase.Id).Country__c!=newCase.Country__c||
						oldCases.get(newCase.Id).CH_Solution__c!=newCase.CH_Solution__c)){
							newCase.addError('If Asset is populated, Product, Product Release, Product Variant, Solution and Country cannot be modified.');
						}
				}
			}
		}
	}*/
	
	/********************
	*Method Name: restrictOtherUser
	*Parameter: List of Case
	*Last updated by: Aelhitary
	*Description: replace images in richtext with message
	*User Story: NOKIASC- 13620
	****************/
	/* IMPORTANT: remove due to porta US feature
	public static void replaceImgWithMessage(List <Case> caseList){
		String temp;
		for( Case myCase : caseList ){ 
			// Valid only for CH record types
			if(myCase.CH_RecordTypeCheck__c){
				temp = myCase.CH_CustomerDescription__c ;
				myCase.CH_CustomerDescription__c =removeIMGs(temp);	
			}
		}
	}
	private Static String removeIMGs(String temp){
		List <String> myList ; 
		if(!string.isBlank(temp)){
			if (temp.contains('<img')){
				myList = temp.split('<img', 2);
				if (myList[1].contains('img>') ){
					temp = myList[0];   
					myList = myList[1].split('img>', 2) ;	
					temp += label.RTFimageMessage ; 
					temp += myList[1];
					return removeIMGs(temp);
				}else return temp;
			}else return temp;
		}return null ;
	}*/
	
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
*Method Name: isolateUniqueRefNumCases
*Parameter: New Case List
*Description: Used to prevent case creation if reference number is not unique for one origin across not closed cases
*******************/
	@testVisible
	private static List<Case> isolateUniqueRefNumCases(List<Case> cases) {
		Set<String> refNumbers = new Set<String>();
		Set<String> origins = new Set<String>();
		List<Case> casesWithoutErrors = new List<Case>();
		for(Case c : cases) {
			refNumbers.add(c.Reference_Number__c);
			origins.add(c.CH_CaseOriginSystem__c);
		}
		List<Case> refNumExistingCases = [
			SELECT Id, Reference_Number__c, CH_CaseOriginSystem__c
			FROM Case
			WHERE Reference_Number__c
			IN : refNumbers
			AND CH_CaseOriginSystem__c
			IN : origins
			AND Status != 'Closed'
		];
		Map<String, Set<String>> refNumExistingCaseMap = new Map<String, Set<String>>();
		for(Case c : refNumExistingCases) {
			if(refNumExistingCaseMap.get(c.CH_CaseOriginSystem__c) == null) {
				refNumExistingCaseMap.put(c.CH_CaseOriginSystem__c, new Set<String>());
			}
			refNumExistingCaseMap.get(c.CH_CaseOriginSystem__c).add(c.Reference_Number__c);
		}
		for(Case c : cases) {
			if(refNumExistingCaseMap.get(c.CH_CaseOriginSystem__c) != null && refNumExistingCaseMap.get(c.CH_CaseOriginSystem__c).contains(c.Reference_Number__c)) {
				c.addError('Case cannot be created with this Reference Number');
				casesWithErrors.add(c);
			} else {
				casesWithoutErrors.add(c);
			}
		}
		return casesWithoutErrors;
	}
	
	/****************************************
* Value Name : TMOBILE_ORIGIN_CODE
* Description : Constant to store text code (system name) for TMobile external system
****************************************/
	@testVisible
	private static final String TMOBILE_ORIGIN_CODE = 'tmobile-tim';
	
	/****************************************
* Class Name : ComplexMappingKey
* Description : Inner class to represent mapping range to use in getTMobileMappings helper method.
****************************************/
	private class ComplexMappingKey {
		public String prefix = null;
		public Integer numericValue = null;
		public String mappingCode = null;
		public String rawExternalSystemAccount = null;
		public ComplexMappingKey(String rawExternalSystemAccount){
			this.rawExternalSystemAccount = rawExternalSystemAccount;
			if (rawExternalSystemAccount.contains('|')) {
				String interfaceString = rawExternalSystemAccount.replace(' ', '').substringBefore('|');
				this.prefix = interfaceString.replaceAll('[0-9]', '');
				this.mappingCode = rawExternalSystemAccount.substringAfter('|').trim();
				if (interfaceString.containsAny('0123456789')) {
					this.numericValue = integer.valueof(interfaceString.replaceAll('[a-zA-Z]', ''));
				}
			}
		}
	}
	
	/********************
*Method Name: getTMobileMappings
*Parameter: Case List
*Description: Used to query InterfaceMapping record for TMobile.
* TMobile is using ranges fields (RangePrefix__c, RangeStart__c, RangeEnd__c) to define range of values for
* mapiing entrys so should be queried in a different way.
*******************/
	@testVisible
	private static List<CH_Case_PA_InterfaceMapping__c> getTMobileMappings(List<Case> specialCases) {
		List<ComplexMappingKey> complexMappingKeys = new List<CH_CaseTriggerHelper.ComplexMappingKey>();
		for(Case c : specialCases) {
			if (c.CH_CaseOriginSystem__c == TMOBILE_ORIGIN_CODE) {
				ComplexMappingKey aComplexMappingKey = new ComplexMappingKey(c.CH_ExternalSystemAccount__c);
				if (aComplexMappingKey.numericValue != null) {
					complexMappingKeys.add(aComplexMappingKey);
				} else {
					c.addError('Can not extract mapping range from CH_ExternalSystemAccount__c field');
					casesWithErrors.add(c);
				}
			}
		}
		
		if (complexMappingKeys.size() == 0) {
			return new List<CH_Case_PA_InterfaceMapping__c>();
		}
		
		// select mappings for TMobile
		String queryTemplateStringForTMobile =
			'SELECT Id, CaseOriginSystem__c, AccountIn__c, AccountOut__c, SolutionOut__c, ProductOut__c, VariantOut__c, ' +
			'ProductReleaseOut__c, EntitlementOut__c, RangePrefix__c, RangeStart__c, RangeEnd__c ' +
			'FROM CH_Case_PA_InterfaceMapping__c ' +
			'WHERE CaseOriginSystem__c = :TMOBILE_ORIGIN_CODE AND ({0})';
		
		String mappingRanges = '';
		
		for (Integer i = 0; i < complexMappingKeys.size(); i++) {
			mappingRanges += '(RangePrefix__c = \'' + complexMappingKeys[i].prefix + '\' ';
			mappingRanges += 'AND RangeStart__c <= ' + complexMappingKeys[i].numericValue + ' ';
			mappingRanges += 'AND RangeEnd__c >= ' + complexMappingKeys[i].numericValue + ' ';
			mappingRanges += 'AND AccountIn__c = \'' + complexMappingKeys[i].mappingCode + '\' )';
			if (i != complexMappingKeys.size() - 1) {
				mappingRanges += ' OR ';
			}
		}
		
		String queryStringForTMobile = String.format(queryTemplateStringForTMobile, new List<Object>{mappingRanges});
		
		List<CH_Case_PA_InterfaceMapping__c> iMappingListForTMobile = Database.query(queryStringForTMobile);
		List<CH_Case_PA_InterfaceMapping__c> iMappingRecordsToAdd = new List<CH_Case_PA_InterfaceMapping__c>();
		
		// add TMobile mappings to iMapping list
		for (CH_Case_PA_InterfaceMapping__c interfaceMappingRecord: iMappingListForTMobile) {
			for (ComplexMappingKey complexMappingKeyItem: complexMappingKeys) {
				if (complexMappingKeyItem.prefix == interfaceMappingRecord.RangePrefix__c
					&& complexMappingKeyItem.numericValue >= interfaceMappingRecord.RangeStart__c
					&& complexMappingKeyItem.numericValue <= interfaceMappingRecord.RangeEnd__c
					&& complexMappingKeyItem.mappingCode == interfaceMappingRecord.AccountIn__c) {
						// change AccountIn__c from mapping to ExternalSystemAccount from Case
						interfaceMappingRecord.AccountIn__c = complexMappingKeyItem.rawExternalSystemAccount;
						iMappingRecordsToAdd.add(interfaceMappingRecord);
						break;
					}
			}
		}
		
		return iMappingRecordsToAdd;
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
	
	/********************
*Method Name: checkViolatedMilestone
*Parameter: New Case List (Only Case Handling Record Type Records)
*Last updated by: Aditya Jawadekar
*Description: Update Case when milestones are violated.
*			   User Story: NOKIASC-15404
*******************/	
	/* public static void checkViolatedMilestone(List < Case > caseList){
List < Case > newCaseList = new List< Case >(caseList);
if(!caseList.isEmpty()){
list<CaseMilestone> fetchedMilestones = [SELECT CaseId, CompletionDate, CreatedDate, ElapsedTimeInMins,Id,
IsCompleted, IsDeleted, IsViolated, MilestoneTypeId, 
MilestoneType.Name, StartDate 
FROM CaseMilestone];
for(Case eachCase: newCaseList){
String recordTypeName = Schema.SObjectType.Case.getRecordTypeInfosById().get(eachCase.recordTypeId).getName();
if(recordTypeName != 'Problem' && String.isNotBlank(eachCase.entitlementId)){
for(CaseMilestone eachCaseMilestone : fetchedMilestones){
if(eachCaseMilestone.MilestoneType.Name == 'Initial Response' && eachCaseMilestone.CaseId == eachCase.Id && eachCaseMilestone.IsViolated == true){
eachCase.CH_IsViolateInitialResponse__c = true;
}
else if(eachCaseMilestone.MilestoneType.Name == 'System Restored' && eachCaseMilestone.CaseId == eachCase.Id && eachCaseMilestone.IsViolated == true){
eachCase.CH_IsViolateRestore__c = true;
}
else if(eachCaseMilestone.MilestoneType.Name == 'Service Disruption Report Provided' && eachCaseMilestone.CaseId == eachCase.Id && eachCaseMilestone.IsViolated == true){
eachCase.CH_IsViolateServiceDisruptionReport__c = true;
}
else if(eachCaseMilestone.MilestoneType.Name == 'Temporary Solution Provided' && eachCaseMilestone.CaseId == eachCase.Id && eachCaseMilestone.IsViolated == true){
eachCase.CH_IsViolateTemporarySolution__c = true;
}
else if((eachCaseMilestone.MilestoneType.Name == 'Solution Provided (defect)' || eachCaseMilestone.MilestoneType.Name == 'Solution Provided (non-defect)') && eachCaseMilestone.CaseId == eachCase.Id && eachCaseMilestone.IsViolated == true){
eachCase.CH_IsViolateSolutionProvided__c = true;
}   
}
}
}
}   
} */
	
	/********************
/*Method Name: setKnownErrorArticleUpdates
*Parameter: List of Case, Map of old values before update
*Last updated by: Mathias Miemiec
*Description: Method incorporating the logic for rich field updates on article known error record related to problem
*User Story: NOKIASC-1525
****************/
// Miguel Silva on 02/10/2019 - Commented this method as per NOKIASC-24181 requirement
	/*public static void setKnownErrorArticleUpdates(List<Case> CaseList, Map<ID, Case> caseOldMap){
		
		if(CaseList.size() > 0){
			
			// Part of the code improvement: the following lines will replace(BUT DOING THE SAME AS) the commented section after it
			map<Id, Case> eligibleCasesForArticleUpdates = new map<Id, Case>();
			for(Case aCase : CaseList){
				Case oCase = caseOldMap.get(aCase.Id);
				if(aCase.CH_RecordTypeDevName__c == 'CH_Problem'){
					if( aCase.CH_TemporarySolution__c		   != oCase.CH_TemporarySolution__c		|| 
					   aCase.Subject						   != oCase.Subject						||
					   aCase.CH_ProblemStatement__c			!= oCase.CH_ProblemStatement__c		 || 
					   aCase.CH_SolutionDetails__c			 != oCase.CH_SolutionDetails__c		  || 
					   aCase.CH_SummaryofAnalysis__c		   != oCase.CH_SummaryofAnalysis__c		|| 
					   aCase.CH_ListofContributingCauses__c	!= oCase.CH_ListofContributingCauses__c || 
					   aCase.CH_ProductRelease__c			  != oCase.CH_ProductRelease__c		   || 
					   aCase.ProductId						 != oCase.ProductId)
						
						eligibleCasesForArticleUpdates.put(aCase.Id, aCase);
				}
			}
			
			System.debug(Logginglevel.ERROR,'#setKnownErrorArticleUpdates:eligibleCasesForArticleUpdates:size:' + eligibleCasesForArticleUpdates.size());
			if(!eligibleCasesForArticleUpdates.isEmpty()){
				
				map<Id, list<Id>> caseArticles = new map<Id, list<Id>>();
				set<Id> knowledgeArticleIds = new set<Id>();
				for(CaseArticle caseArt : [SELECT KnowledgeArticleId, CaseId From CaseArticle WHERE CaseId IN : eligibleCasesForArticleUpdates.keySet()]){
					knowledgeArticleIds.add(caseArt.KnowledgeArticleId);
					if(caseArticles.containsKey(caseArt.CaseId)) caseArticles.get(caseArt.CaseId).add(caseArt.KnowledgeArticleId);
					else caseArticles.put(caseArt.CaseId, new list<Id>{caseArt.KnowledgeArticleId});
				}   
				map<Id, Knowledge__kav> articles = new map<Id, Knowledge__kav>(); 
				for(Knowledge__kav know : [SELECT KnowledgeArticleId FROM Knowledge__kav WHERE KnowledgeArticleId IN :knowledgeArticleIds AND PublishStatus = 'Draft' AND RecordType.DeveloperName='CH_KnownError']){ 
					articles.put(know.KnowledgeArticleId, know);
				}
				System.debug(Logginglevel.ERROR,'#setKnownErrorArticleUpdates:Knowledge__kav:size:' + articles.size());
				list<Knowledge__kav> articles4update = new list<Knowledge__kav>(); 
				for(Case aCase : eligibleCasesForArticleUpdates.values()){
					if(caseArticles.containsKey(aCase.Id)){
						for(Id knowArtId : caseArticles.get(aCase.Id)){
							if(articles.containsKey(knowArtId)){
								Knowledge__kav arty = articles.get(knowArtId);
								arty.CH_WorkAround__c				   = aCase.CH_TemporarySolution__c;
								 arty.Title							 = aCase.Subject;
								// Miguel Silva 04/10/2019 - Changed this line as per NOKIASC-24181 requirement
								arty.CH_ProblemDescriptionRequired__c   = (aCase.CH_IssueDescription__c != '' ?aCase.CH_IssueDescription__c : 'tbd');
								arty.CH_Solution__c					 = aCase.CH_SolutionDetails__c;
								arty.CH_DiagnosticSteps__c			  = aCase.Steps_to_Reproduce_Issue__c;
								arty.CH_Cause__c						= aCase.CH_Root_Cause_Description__c;
								arty.CH_ProductId__c					= aCase.ProductId;
								// arty.CH_Product_Release_1_1__c		  = aCase.CH_Product_Release__c;
								articles4update.add(arty);
							}
						}
					}
				}
				System.debug(Logginglevel.ERROR,'#setKnownErrorArticleUpdates:articles4update:size:' + articles4update.size());
				if(!articles4update.isEmpty()) update articles4update;
			}
			
			/*
Map<Id,RecordType> caseRecordTypes = new Map<Id,RecordType>();
Map<Id, CaseArticle> caseArticles = new Map<Id, CaseArticle>();
Map<Id, Knowledge__kav> knownErrorArticles = new Map<Id, Knowledge__kav>();
List<RecordType> recordTypesList = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType='Case'];
List<CaseArticle> caseArticlesList = [SELECT KnowledgeArticleId, CaseId From CaseArticle];
List<Knowledge__kav> articlesList =[SELECT Id FROM Knowledge__kav]; //WHERE RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName='CH_KnownError')]; 

for(RecordType recordType : recordTypesList){
caseRecordTypes.put(recordType.Id, recordType);
}

for(CaseArticle caseArticle : caseArticlesList){
caseArticles.put(caseArticle.caseId, caseArticle);
}

for(Knowledge__kav article : articlesList){
knownErrorArticles.put(article.id, article);
}
System.debug(Logginglevel.ERROR,'#SLMJ#knownErrorArticles:' + knownErrorArticles.keySet());	
//List<RecordType> recordTypesList = [SELECT Id FROM RecordType];
//List<CaseArticle> caseArticleList = [SELECT Id from CaseArticle];

//caseRecordTypes.put(recordTypeList);
//caseArticles.put(caseArticleList);


for(Case caseObj : CaseList){

//check for article record type
//List<RecordType> recordTypeList = [SELECT Id,DeveloperName FROM RecordType WHERE  Id=:caseObj.RecordTypeId];

RecordType recordType = caseRecordTypes.get(caseObj.RecordTypeId);
String recordTypeName = recordType.DeveloperName;

if(recordTypeName == 'CH_Problem'){

//get junction object for related articles on case
//CaseArticle[] relatedArticleConnectorArray = [SELECT KnowledgeArticleId FROM CaseArticle WHERE CaseId =:caseObj.Id LIMIT 1];
CaseArticle[] relatedArticleConnectorArray;
List<CaseArticle> caseArticleHelper = new List<CaseArticle>();
caseArticleHelper.add(caseArticles.get(caseObj.Id));
//System.debug(Logginglevel.ERROR,'#caseArticleHelper:' + caseArticleHelper);
System.debug('*******************CaseArticle Objec: ' + caseArticles.get(caseObj.Id));

relatedArticleConnectorArray = caseArticleHelper;

CaseArticle relatedArticleConnector;
if(relatedArticleConnectorArray.size() > 0){
relatedArticleConnector = relatedArticleConnectorArray[0];
}
System.debug(Logginglevel.ERROR,'#SLMJ#relatedArticleConnector:' + relatedArticleConnector);
//get related article if existing
if(relatedArticleConnector != null){
System.debug(Logginglevel.ERROR,'#' + relatedArticleConnector);
boolean changed = false;
//Knowledge__kav[] relatedArticleArray = [SELECT Id FROM Knowledge__kav WHERE KnowledgeArticleId = :relatedArticleConnector.KnowledgeArticleId AND PublishStatus = 'Draft'];
Knowledge__kav[] relatedArticleArray;
List<Knowledge__kav> relatedArticleHelper = new List<Knowledge__kav>();
relatedArticleHelper.add(knownErrorArticles.get(relatedArticleConnector.KnowledgeArticleId));
relatedArticleArray = relatedArticleHelper;
Knowledge__kav relatedArticle;

if(relatedArticleArray.size() > 0){
relatedArticle = relatedArticleArray[0];

//map old Case values
Case oldCase = caseOldMap.get(caseObj.Id);

//Check field changes
if(oldCase.CH_TemporarySolution__c != caseObj.CH_TemporarySolution__c){
System.debug('************* Old Value: '+ oldCase.CH_TemporarySolution__c);
System.debug('************* New Value: '+ caseObj.CH_TemporarySolution__c);
relatedArticle.CH_WorkAround__c = caseObj.CH_TemporarySolution__c;
changed = true;
}
if(oldCase.Subject != caseObj.Subject){

relatedArticle.Title = caseObj.Subject;
changed = true;
}
if(oldCase.CH_ProblemStatement__c  != caseObj.CH_ProblemStatement__c ){

relatedArticle.CH_ProblemDescriptionRequired__c = caseObj.CH_ProblemStatement__c;
changed = true;
}
if(oldCase.CH_SolutionDetails__c != caseObj.CH_SolutionDetails__c){

relatedArticle.CH_Solution__c = caseObj.CH_SolutionDetails__c;
changed = true;
}
if(oldCase.CH_SummaryofAnalysis__c != caseObj.CH_SummaryofAnalysis__c){

relatedArticle.CH_DiagnosticSteps__c = caseObj.CH_SummaryofAnalysis__c;
changed = true;
}
if(oldCase.CH_ListofContributingCauses__c != caseObj.CH_ListofContributingCauses__c){

relatedArticle.CH_Cause__c = caseObj.CH_ListofContributingCauses__c;
changed = true;
}
if(oldCase.ProductId != caseObj.ProductId){

relatedArticle.CH_ProductId__c = caseObj.ProductId;
changed = true;
}
if(oldCase.CH_ProductRelease__c != caseObj.CH_Product_Release__c ){

relatedArticle.CH_Product_Release_1_1__c  = caseObj.CH_Product_Release__c;
changed = true;
} 
if(changed == true){
update relatedArticle;
} 
}  
}
}
}
	
		   
		}
	} */
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
			if(oCase.CH_RecordTypeCheck__c && !oCase.OwnerId.equals(oldCaseMap.get(oCase.Id).OwnerId))
				eligibleNewCaseList.add(oCase);
			
		if(!eligibleNewCaseList.isEmpty()){
			
			List<Group> gwcRec = [select name from Group where name = 'GWC' and type = 'queue' limit 1];
			string gwcQueue = gwcRec[0].Id;
			
			// Owner check should be applied only for CH profiles
			Profile profiledet = [Select Name from Profile where Id =: userinfo.getProfileid()];
			String pname = profiledet.name;
			if(pname == 'CH_Agent' || pname == 'CH_Basic Case Handling' || pname == 'CH_Case Handler' || pname == 'System Administrator' || pname == 'Customers' || pname == 'Customers Login' || pname == 'Integration API Only Profile'){
				// Get a set of new case owners
				Set<Id> usrIds = new Set<Id>();
				for(Case aCase: eligibleNewCaseList){
					if(string.valueOf(aCase.OwnerId).startsWith('005'))
						usrIds.add(aCase.OwnerId);
					// Queues cannot own cases!
					if(string.valueOf(aCase.OwnerId).startsWith('00G') && aCase.OwnerId != gwcQueue)
						aCase.addError('Queue cannot be made the owner of the case.');
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
								aCase.addError('Unable to assign '+ users.get(aCase.OwnerId).Name +' as Owner. Missing required security permissions.');	   
							}
							// When the new owner has no security group
							if(!userPgroups.containsKey(aCase.OwnerId))
								aCase.addError('Unable to assign '+ users.get(aCase.OwnerId).Name +' as Owner. Missing required security permissions.');
							
							// When the new owner has Customer Profile
							if(users.get(aCase.OwnerId).Profile.Name=='Customers'){
								aCase.addError('Unable to assign '+ users.get(aCase.OwnerId).Name +' as Owner. '+ users.get(aCase.OwnerId).Name +' has a Customer profile.');
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
		System.debug('GWC id val'+gwcRec[0].Id);
		string gwcQueue = gwcRec[0].Id;
		System.debug('gwcQueue val'+gwcQueue);
		
		//Get logged user profile and include only CH profile to run the code
		Profile profiledet = [Select Name from Profile where Id =: userinfo.getProfileid()];
		String pname = profiledet.name;
		
		// Get Case Record types by name
		if(CaseList.size()>0){
			for(Case casRec: CaseList){
				if(pname == 'CH_Agent' || pname == 'CH_Basic Case Handling' || pname == 'CH_Case Handler' || pname == 'System Administrator' || pname == 'Customers' || pname == 'Customers Login' || pname == 'Integration API Only Profile'){
					string recordtypename = Schema.SObjectType.case.getRecordTypeInfosById().get(casRec.recordtypeid).getname();
					system.debug('entered into for loop :'+recordtypename);
					if((recordtypename == 'Nokia Standard Case') || (recordtypename == 'Nokia Incident with Restoration') || (recordtypename == 'Problem') || (recordtypename == 'Nokia Information Request')){
						if(string.valueOf(casRec.OwnerId).startsWith('005')){
							usrIds.add(casRec.OwnerId);
							System.debug('owner is User');
						}
						if(string.valueOf(casRec.OwnerId).startsWith('00G')){
							queueIds.add(casRec.Ownerid);
							System.debug('owner is Queue'+queueIds);
						}
					}
				}
			}
		}
		//Get queue name by queue id for empty queue assignment.
		for(Group queuenam :[select id,name from Group where Id =: queueIds]){
			qNameMap.put(queuenam.id,queuenam.name);
			System.debug('M into queue' + queuenam);
		}
		
		//Queue owner Update
		if(queueIds.size()>0){
			for(GroupMember usrPubg:[select id,UserOrGroupId, groupId,group.name from GroupMember where GroupId =:queueIds]){
				userQueueName.put(usrpubg.groupId,usrpubg.group.name);
				system.debug('userQueueName det'+ userQueueName);
				if(usrpubg.GroupId == gwcQueue){
					usrIds.add(usrpubg.UserOrGroupid);
					system.debug('queue usrlst det'+ usrIds);
				}
				//else added to check Non GWC
				else{
					for(Case casRec: CaseList){
						string recordtypename = Schema.SObjectType.case.getRecordTypeInfosById().get(casRec.recordtypeid).getname();
						system.debug('entered into for loop :'+recordtypename);
						if((recordtypename == 'Nokia Standard Case') || (recordtypename == 'Nokia Incident with Restoration') || (recordtypename == 'Problem') || (recordtypename == 'Nokia Information Request')){
							if((oldCaseMap.get(casRec.id).OwnerId != casRec.OwnerId) &&
							   ((string.valueOf(casRec.OwnerId).startsWith('00G'))&& casRec.OwnerId != gwcQueue)){
								   casRec.addError('Queue cannot be made the owner of the case.');
							   }
						}
					}
				}
				//Non GWC check end
			}
		}
		
		if(usrIds.size()>0){
			// User owner update
			system.debug('user id exsists');
			for(Group usrPubg:[SELECT DeveloperName,Name,type ,(select id,UserOrGroupId, groupId from GroupMembers where UserOrGroupId =:usrIds ) FROM Group  ]){
				//system.debug('userpublic group list' + usrPubg);
				//system.debug('userpublic group list of Group  members' + usrPubg.GroupMembers);
				if((usrPubg.name == 'GWC'|| usrPubg.DeveloperName == 'GWC') && usrPubg.type == 'queue'){
					system.debug('usrPubg lst :'+ usrPubg.name);
					system.debug('usrPubg lst :'+ usrPubg.id);
					queuelst.add(usrPubg.id);
					system.debug('queuelst :'+queuelst);
				}
				for(GroupMember gm: usrPubg.GroupMembers){
					system.debug('only gm values'+gm);
					system.debug('gm.UserOrGroupId values'+gm.UserOrGroupId);
					if(usrPubg.type != 'queue'){
						system.debug('usrpublic group type'+usrPubg.type);
						if(userPgListMap!=null && userPgListMap.containsKey(gm.UserOrGroupId)){
							userPgList  = userPgListMap.get(gm.UserOrGroupId);
							userPgList.add(usrPubg.name);
							userPgListMap.put(gm.UserOrGroupId, userPgList);
							system.debug('usrpublic group list map in if condition '+userPgListMap);
						}
						else
							userPgListMap.put(gm.UserOrGroupId, new List<String>{usrPubg.name}); 
						system.debug('usrpublic group list map in else condition'+userPgListMap);
					}
				}
			}
		} 
		//If queue is not having any user/members in it.One for GWC and another for Non GWC queues
		else{
			for(Case casRec: CaseList){
				string recordtypename = Schema.SObjectType.case.getRecordTypeInfosById().get(casRec.recordtypeid).getname();
				system.debug('entered into for loop :'+recordtypename);
				if((recordtypename == 'Nokia Standard Case') || (recordtypename == 'Nokia Incident with Restoration') || (recordtypename == 'Problem') || (recordtypename == 'Nokia Information Request')){
					if((oldCaseMap.get(casRec.id).OwnerId != casRec.OwnerId) &&
					   ((string.valueOf(casRec.OwnerId).startsWith('00G'))&& casRec.OwnerId != gwcQueue)){
						   casRec.addError('Queue cannot be made the owner of the case.');
					   }
					if((oldCaseMap.get(casRec.id).OwnerId != casRec.OwnerId) &&
					   ((string.valueOf(casRec.OwnerId).startsWith('00G')) && casRec.OwnerId == gwcQueue)){
						   casRec.addError('All users in the queue don’t have the right Security Group for this case.');
					   }
				}
			}
		}
		System.debug('userPgListMap data'+userPgListMap); 
		List<User> usrlst =[select name from user where id in : usrIds];
		system.debug('usrlst details'+usrlst);
		for(User us: usrlst){
			userNames.put(us.Id, us.name);
		}
		if(CaseList.size()>0){  
			for(Case casRec: CaseList){
				if(pname == 'CH_Agent' || pname == 'CH_Basic Case Handling' || pname == 'CH_Case Handler' || pname == 'System Administrator' || pname == 'Customers' || pname == 'Customers Login' || pname == 'Integration API Only Profile'){
					String recordTypeName = Schema.SObjectType.case.getRecordTypeInfosById().get(casRec.recordtypeid).getname();
					//String recordTypeName = casRec.RecordType.DeveloperName;
					system.debug('entered into for loop :'+recordtypename);
					if((recordTypeName == 'Nokia Standard Case') || (recordTypeName == 'Nokia Incident with Restoration') || (recordTypeName == 'Problem') || (recordTypeName == 'Nokia Information Request')){
						for (User usr:usrlst) {
							if(!userPgListMap.isEmpty() && userPgListMap.get(usr.id) != null){
								System.debug('userPgListMap'+userPgListMap);
								System.debug('User details '+ usr.name);
								System.debug('User details by PG map '+userPgListMap.get(usr.id));
								//User donot have proper Security Groups
								System.debug('old case values' + oldCaseMap.get(casRec.id).OwnerId );
								System.debug('Case Rec owner id details '+casRec.OwnerId);
								if((oldCaseMap.get(casRec.id).OwnerId != casRec.OwnerId) && (userPgListMap.get(usr.id) != null)
								   &&  (!(userPgListMap.get(usr.id)).contains(casRec.CH_SecurityGroup__c)
										&& !(userPgListMap.get(usr.id)).contains(casRec.CH_GWC_SecurityGroup__c))
								   && casRec.CH_GWC_SecurityGroup__c != null && casRec.CH_SecurityGroup__c !=null){
									   casRec.addError('Unable to assign '+userNames.get(casRec.OwnerId)+' as Owner. Missing required security permissions.');
									   System.debug('userPgListMap.get(usr.id)'+userPgListMap.get(usr.id));
								   }
								//Queue memebers donot have proper Security Groups
								if((oldCaseMap.get(casRec.id).OwnerId != casRec.OwnerId) && (userPgListMap.get(usr.id) != null) && (casRec.OwnerId == gwcQueue)
								   &&  (!(userPgListMap.get(usr.id)).contains(casRec.CH_SecurityGroup__c)
										&& !(userPgListMap.get(usr.id)).contains(casRec.CH_GWC_SecurityGroup__c))
								   && casRec.CH_GWC_SecurityGroup__c != null && casRec.CH_SecurityGroup__c !=null){
									   casRec.addError('All users in the queue don’t have the right Security Group for this case.');
									   System.debug('userPgListMap.get(usr.id) 2'+userPgListMap.get(usr.id));
								   }
								
							}
							// User not associated with any public groups
							else{
								for(id qids :queuelst){
									
									system.debug('Case owner queue'+casRec.OwnerId);
									system.debug('Case owner queue frm lst'+qids);
									
									if((oldCaseMap.get(casRec.id).OwnerId != casRec.OwnerId) &&
									   ((string.valueOf(casRec.OwnerId).startsWith('005')))){
										   casRec.addError('Unable to assign '+userNames.get(casRec.OwnerId)+' as Owner. Missing required security permissions.');
									   }
									
									if((oldCaseMap.get(casRec.id).OwnerId != casRec.OwnerId) &&
									   ((string.valueOf(casRec.OwnerId).startsWith('00G'))&& casRec.OwnerId == qids)){
										   casRec.addError('All users in the queue don’t have the right Security Group for this case.');
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
			string restoration = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Nokia Incident with Restoration').getRecordTypeId();
			string standard = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Nokia Standard Case').getRecordTypeId();
			string info = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Nokia Information Request').getRecordTypeId();		   
			//reset to 'All' by default
			c.CH_EmailTypeController__c = 'All';
			//NOKIASC-15638
			if(c.Status == 'Pending Customer') {
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
		   supportTicket.CH_ServiceType__c == 'Internal Support' && 
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
					(oldCases != null && !oldCases.isEmpty() && (aCase.CH_PlantCode__c != oldCases.get(aCase.Id).CH_PlantCode__c || aCase.CH_GlobalServiceOrder__c != oldCases.get(aCase.Id).CH_GlobalServiceOrder__c || aCase.CH_LocalServiceOrder__c != oldCases.get(aCase.Id).CH_LocalServiceOrder__c)))){ 
						if(!caseIsEligibleForP20Details(aCase)){
							aCase.addError('Local Service Order, Global Service Order and Plant Code cannot be specified on this case!');
						}
					}
			}	
		}
	}
	
	/********************
	*Method Name: populateBusinessHourIds
	*Author: TCS
	*Parameter: New Case List
	*Description: Used to update business hours if entitlement is filled and contractlineitem on entitlement is filled then fetch businesshours from contractlineitem on case
	*******************/
	//Merged below method in populateCaseFields method as part of code optimizatio --> 27620 -- By Satya
	/*public static void populateBusinessHourIds(List<Case> newCaseList) {
		if(newCaseList != null && !newCaseList.isEmpty()) {
			Set<Id> entitlementIds= new Set<Id>();
			List<Case> noBHCaseList = new List<Case>();
			for(Case oCase: newCaseList) {
				if(String.isNotBlank(oCase.EntitlementId) && !String.isNotBlank(oCase.BusinessHoursId)) {
					noBHCaseList.add(oCase);
					entitlementIds.add(oCase.EntitlementId);
				}
			}
			// Check EntitlementIds is Empty or Not
			if(!entitlementIds.isEmpty() && !noBHCaseList.isEmpty()) {
	 //Using Global/Common query as part Code of Optimization -- 27618 --> By Satya Pagadala
	Map<Id, Entitlement> oEntitlementMap = CH_Utils.getentitlementMap(entitlementIds);
				if(oEntitlementMap != null && !oEntitlementMap.isEmpty()) {
					for(Case oCase: noBHCaseList) {
						if(oEntitlementMap.containsKey(oCase.EntitlementId)) {
							Entitlement oEntitlement = oEntitlementMap.get(oCase.EntitlementId);
							oCase.BusinessHoursId = oEntitlement.ContractLineItem.CH_BusinessHour__c;
						}
					}
				}
			}
		}
	}*/
	
	/********************
	*Method Name: updateBusinessHourIds
	*Author: TCS
	*Parameter: New Case List, Old Case Map
	*Description: Used to update business hours if entitlement is filled and contractlineitem on entitlement is filled then fetch businesshours from contractlineitem on case
	*******************/
	//Merged below method in populateCaseFields method as part of code optimizatio --> 27620 -- By Satya
   /* public static void updateBusinessHourIds(Map<Id,Case> oldCaseMap, List<Case> newCaseList) {
		if(newCaseList != null && !newCaseList.isEmpty()) {
			List<Case> caseList = new List<Case>();
			for(Case oCase: newCaseList) {
				if(oldCaseMap.get(oCase.Id) != null) {
					Case oldCaseObj = oldCaseMap.get(oCase.Id);
					if(oldCaseObj.EntitlementId != oCase.EntitlementId && !String.isNotBlank(oCase.BusinessHoursId)) {
						caseList.add(oCase);
					}
				}
			}
			// Check if caseList has any records or not to process
			if(!caseList.isEmpty()) {
				populateBusinessHourIds(caseList);
			}
		}	
	}*/

	
	/***************************************************************** 
	Description: US 22292 : Non-Care - Validation rule that Contact must be Nokia Employee
	Returns: void 
	History															 
	DATE		   AUTHOR				Change 
	26/08/2019	 Tiago Almeida		 Created 
	*****************************************************************/ 
	//Merged below method in populateCaseFields method as part of code optimizatio --> 27620 -- By Satya
   /*public static void validateContactMustBeNokiaEmployee(List<Case> newCaseList, Map<Id, Case> oldCaseMap) {
		if(!newCaseList.isEmpty()){
			//create the contact set for the cases
			Set<Id> contacts = new Set<Id>();
			for(Case newCase : newCaseList){
				if(newCase != null && newCase.ContactId != null) {
					contacts.add(newCase.ContactId);
				}
			}
			if(!contacts.isEmpty()){
				Map<Id, String> contactToContactType = new Map<Id, String>();
				//get type for each contact in the set
				//Using Global/Common query as part of Code Optimization -- 27617 --> By Satya Pagadala
	Map<Id, Contact> contactMapGlobal = CH_Utils.getContactMap(contacts);
				if(contactMapGlobal.size()>0){
					for(Contact curContact : contactMapGlobal.values()){
						contactToContactType.put(curContact.Id, curContact.CH_ContactType__c);
					}
				}
				//validate if contact is diferent it must be Nokia Employee
				for(Case newCase : newCaseList){
					Case oldCase = oldCaseMap.get(newCase.Id);
					if(oldCase != null && oldCase.ContactId != null && newCase != null && newCase.ContactId != null && !oldCase.ContactId.equals(newCase.ContactId)) {
						if(newCase.CH_ServiceType__c.equals('Internal Support') && !contactToContactType.get(newCase.ContactId).equals('Nokia Employee')) {
							newCase.addError('When Service Type is Internal Support, contact on case must be a Nokia Employee.');
						}
					}
				}
			}
		}
	}*/
		/********************   
	*Method Name: populateCaseFields	
	*Author: TCS	
	*Parameter: oldCaseMap, newCaseList 
	*Description: Moved the logic from CH Case Process Builder to this method as part of code optimization. 
	*******************/
	public static void populateCaseFields(Map<Id,Case> oldCaseMap,List<Case> newCaseList){
		if(!newCaseList.isEmpty()){
			//code added as per code Opt US#27636
			Set<Id> contIds=new Set<Id>();
			Set<Id> caseIdSet=new Set<Id>();
			Set<Id> entitlementIds= new Set<Id>();
			for(Case cs:newCaseList){
				if(cs.ContactId!=null)
				  contIds.add(cs.ContactId);
				//verifyCountryChangeOnCase
				if(!oldCaseMap.isempty() && oldCaseMap.get(cs.Id).Country__c != cs.Country__c ) {
					caseIdSet.add(cs.Id);				   
				}			   
				//populateBusinessHourIds
				if((oldCaseMap.isempty() && String.isNotBlank(cs.EntitlementId)) || (!oldCaseMap.isempty() && oldCaseMap.get(cs.Id).EntitlementId != cs.EntitlementId) && !String.isNotBlank(cs.BusinessHoursId)){
					entitlementIds.add(cs.EntitlementId);
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
				if(ca.Origin != 'S2S' && ca.AssetId == null && ca.Entitlement.name == null && (ca.Country__c == null || ca.ProductId==null)&& (ca.CH_ServiceType__c == 'Customer Support' || ca.CH_ServiceType__c==null) && (recordTypeName == 'Nokia Standard Case' || recordTypeName == 'Nokia Incident with Restoration' || recordTypeName == 'Nokia Information Request')){
					ca.addError('If Asset and Entitlement are blank then Country and Product cannot be blank'); 
				}
				//==== End method validAsset =====
				/******************** Merged the method "validateCaseCreation" in this loop -- starts--> 27620 By Satya
				*Description: Method to validate individual Case If Asset is null Entitlement and country both should not be null and vice versa.
				*User Story: NOKIASC- 494 *******************/
				if(oldCaseMap.isempty() && contMap.size()>0 && contMap.containsKey(ca.ContactId)){
					if((ca.CH_ServiceType__c == 'Internal Support' && contMap.get(ca.contactId).CH_contactType__c != 'Nokia Employee')){
						ca.addError('With Service Type as Internal Support Contact Type should be Nokia Employee');
					}
					if((ca.CH_ServiceType__c == 'Internal Support' && contMap.get(ca.contactId).CH_contactType__c== 'Nokia Employee' )
					   && (ca.CH_Outage__c == 'Yes' || (ca.Severity__c == 'Critical' || ca.Severity__c == 'Information Request' ))){
					   ca.addError('If the ticket is type internal support you are not allowed severity Critical or Information Request, and cannot set outage to yes');
					}   
				}			   
				//==== End method validateCaseCreation =====	
				if(!oldCaseMap.isempty()){
					Case oldCase = oldCaseMap.get(ca.Id);
					/************************** Merged method "validateContactMustBeNokiaEmployee" in this loop -- starts --> 27620 By Satya
					Description: US 22292 : Non-Care - Validation rule that Contact must be Nokia Employee *******/ 
					if (contMap.size()> 0 && contMap.containsKey(ca.ContactId) && oldCase.ContactId != null && !oldCase.ContactId.equals(ca.ContactId) && ca.CH_ServiceType__c.equals('Internal Support') && !contMap.get(ca.ContactId).CH_ContactType__c.equals('Nokia Employee')) {
						ca.addError('When Service Type is Internal Support, contact on case must be a Nokia Employee.');
					}
					//==== End method validateContactMustBeNokiaEmployee =====
					/************************** Merged method "productAssetValidation" in this loop -- starts --> 27620 By Satya
					*Description: Cannot modify product details when Asset is  Set.
					*User Story: NOKIASC- 494   *******************/					
					if(recordTypeName != 'Problem' && (oldCase.AssetId !=null)){
						if(oldCase.AssetId == ca.AssetId && (oldCase.ProductId!=ca.ProductId || oldCase.CH_Product_Release__c!=ca.CH_Product_Release__c || oldCase.CH_ProductVariant__c != ca.CH_ProductVariant__c || oldCase.Country__c != ca.Country__c || oldCase.CH_Solution__c!=ca.CH_Solution__c)){
							ca.addError('If Asset is populated, Product, Product Release, Product Variant, Solution and Country cannot be modified.');
						}
					}
					//==== End method productAssetValidation =====
					/********************Merged method "verifyCountryChangeOnCase" in this loop -- starts --> 27620 By Satya
					*Description: Used to re-calcualte Case Milestone if either Severity or Outage changed. *******************/					
					if(contIds.size()>0 && attachMap.size()>0 && oldCase.Country__c != ca.Country__c ){					 
						List <CH_Attachment__c> tempList = attachMap.get(ca.Id);
						if(tempList != null && !tempList.isEmpty()) {
							ca.addError('Country on Case cannot be modified when there is one or more attachments associated with the case.');
						}				   
					}
					//==== End method verifyCountryChangeOnCase =====
				}
				/******************** populateBusinessHourIds -- Starts--> 27620 By Satya
				*Description: Used to update business hours if entitlement is filled and contractlineitem on entitlement is filled then fetch businesshours from contractlineitem on case   *******************/
				//Check Entitlement Map is Empty or Not
				if(entitlementMap.size()>0 && entitlementMap.containsKey(ca.EntitlementId) && !String.isNotBlank(ca.BusinessHoursId) && String.isNotBlank(ca.EntitlementId) && (oldCaseMap.isempty() || (!oldCaseMap.isempty() && oldCaseMap.get(ca.Id).EntitlementId != ca.EntitlementId))) {
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
				/*if(!oldCaseMap.isempty() && oldCaseMap.containsKey(ca.Id) && oldCaseMap.get(ca.Id).Status == 'Draft' && ca.Status == 'Created' && ca.Status != 'Cancelled'){
					ca.CH_MilestoneSLA_Start__c = System.now();
				}*/
				if(ca.Status != 'Cancelled' && (oldCaseMap.isempty() ||
												(!oldCaseMap.isempty() && oldCaseMap.containsKey(ca.Id) && ca.CH_MilestoneSLA_Start__c != oldCaseMap.get(ca.Id).CH_MilestoneSLA_Start__c))){
													ca.SlaStartDate = ca.CH_MilestoneSLA_Start__c;
												}
				if(!oldCaseMap.isempty() && ca.Status != 'Cancelled' && ca.Status != 'Closed' && ca.Status != oldCaseMap.get(ca.Id).Status){
					ca.IsStopped = (ca.Status == 'Pending Customer' ? true : (ca.Status != 'Pending Customer' && ca.IsStopped == true ? false: ca.IsStopped ));				  
					//if(ca.Status == 'Assigned')
						//ca.CH_AssignedDate__c = System.now();
				}
				if(ca.CH_Record_Type_Check_Condition__c){
					ca.CH_Stage__c = (ca.Status == 'Created' ? 'Route' : (ca.Status == 'Assigned' && String.valueof(ca.OwnerId).startsWith('005')) ? 'Assess & Respond' : ca.CH_Stage__c); 
				}
	 //Moved this code from CH_BlacklistCaseReportTrigger for Cancelled cases
				if(ca.Status == 'Cancelled' || ca.Status == 'Draft'){					 
					ca.CH_BlockCases__c = true;
				} /*if(ca.Status != 'Cancelled' && ca.Status != 'Draft' && ca.CH_BlockCases__c != true){
					ca.CH_BlockCases__c = false;					
				} */
			}
		}
	}
}