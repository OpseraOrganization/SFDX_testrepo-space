/****************************************
* Class Name : Hws_CaseTriggerHelper
* Created Date: 22 Nov 2018
* Created By : TCS
* Last Modified by: TCS
* Last Modified Date: 
* @description : Contains common business logic
* Test Class: CH_CaseTriggerHelperTest
*****************************************/
public without sharing class HWS_CaseTriggerHelper {
	public static Set<String> childCaseStatuses = new Set<String>{'Closed','Cancelled'};
		public static Set<String> childCaseSOOStatuses = new Set<String>{'Open-ReceivedAndDelivered','Resolved-Cancelled'};
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
	public static Id returnForRepairCaseRType {
		get {
			if(returnForRepairCaseRType == null){
	returnForRepairCaseRType = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_RETURN_FOR_REPAIR);
			}
			return returnForRepairCaseRType;
		}
		set;
	}
	public static Id parentCaseRTypeId {
		get {
			if(parentCaseRTypeId == null){
	parentCaseRTypeId = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_PARENT_CASE);
			}
			return parentCaseRTypeId;
		}
		set;
	}
	public static Id parentCaseReadOnlyRTypeId {
		get {
			if(parentCaseReadOnlyRTypeId == null){
	parentCaseReadOnlyRTypeId = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_PARENT_CASE_READ_ONLY);
			}
			return parentCaseReadOnlyRTypeId;
		}
		set;
	}
	public static Set<ID> recordTypeIds = new Set<ID> {exchangeInDays,exchangeInHours}; 
		// To ensure field tracking is performed only once per transaction
		public static boolean fieldTrackingChecked = false; 
	public static boolean fieldChecked = false;
	public static boolean updateCheck = true;   
	public static boolean updateStatCheck = true; 
	//NOKIASC-38090:bypass trigger logic for bulk warranty check|Start
	public static boolean byPassTriggerForBulkWarranty = false;
	//NOKIASC-38090:bypass trigger logic for bulk warranty check|Start
	static final list<string> CASEFIELDS = new list<string>{'HWS_FaultyUnitMaterialCode__c','HWS_Faulty_Serial_Number__c','HWS_Shippeddate__c','HWS_AWBNumber__c','HWS_LSP_Courier_Name__c','CH_InternalStatus__c','HWS_RequestHWRCAFMA__c','CH_EntitlementStatus__c','CH_EntitlementException__c','HWS_WarrantyStatus__c'};  
		//Please add all child record types whenever new child case record type is created
		public static Set<ID> hwsRecordTypeIds = new Set<ID> {exchangeInDays,exchangeInHours,childCaseReadOnly,sPSCaseRType,returnForRepairCaseRType,spsReadOnly};
			public static Set<ID> parentConsoleRecordTypeIds = new Set<ID> {parentCaseRTypeId,parentCaseReadOnlyRTypeId};   
	/********************
*Method Name: changeParentCaseStatus
*Parameter: oldmap and new list of cases
*Description:to update the parent case status to closed when all child cases are closed or cancelled.
*******************/  
	public static void changeParentCaseStatus(List<case> newCaseList){	
		List<Case> parentCasesToUpdate = new List<Case>();
		set<Id> parentCaseIds = new set<Id>();
		String parentStatus = 'Open';
		set<Id> cancelledChildIds = new Set<Id>();
		for(Case caseRec : newCaseList){			
			if(hwsRecordTypeIds.contains(caseRec.RecordTypeId) && (caseRec.Status=='Closed' || caseRec.Status=='Cancelled')){   
				parentCaseIds.add(caseRec.ParentId);
				cancelledChildIds.add(caseRec.Id);
			}
		}	
		if(parentCaseIds.size() > 0){
			//added  for PMD Error - NOKIASC-32425
			List<Case> toIdentifycasesToClose =[SELECT id ,status,HWS_CancelConfirm__c,OwnerID,
						(SELECT id,status FROM Cases WHERE status Not in:childCaseStatuses) 
						FROM case WHERE id in :parentCaseIds FOR UPDATE ];//ft-NOKIASC-36954	
			if(toIdentifycasesToClose.size() > 0)
			{
				for(case caserec : toIdentifycasesToClose){
		
		if(caserec.cases.size() == 0){
			parentStatus = 'Closed';
			caserec.CH_InternalStatus__c = '';
		}
		//Update Parent cases if changes exists
		if(caserec.status != parentStatus){
			caserec.status = parentStatus;
			//NOKIASC-37015: QCRM: Support Ticket Owner is not updated to "Archived Case no owner" for closed cases
			if(parentStatus == 'Closed'){
				caserec.OwnerID = System.Label.HWS_Archived_Case_No_Owner;
			}
			caserec.HWS_CancelConfirm__c = 'AllowCancellation';
			parentCasesToUpdate.add(caserec);
		}
				}
			}
		}
		if(parentCasesToUpdate.size() > 0 ){
			update parentCasesToUpdate ;
			if(cancelledChildIds.size()>0 && parentStatus == 'Closed'){ HWS_OrderConfirmationNotification.sendEmailNotificationForPDF(cancelledChildIds);
					  }
		}	 
	}
	
	/********************
*Method Name: validationsOnCase
*Parameter: New Case List (Only HWS Handling child Record Type Records)
*Last updated by: TCS
*Description: Method to validate HWS Faulty Serial Number field. If the case product related version item "Serial number traced field" is checked
then we need to make "HWS Faulty Serial Number field" as Required, if its blank it should display error.
*	 
*******************/
	public static void validationsOnCase(List < Case > caseList) {
		Set<Id> caseVerItmIdSet = new Set<Id>();
		for(case caseRec: caseList) {
			if((caseRec.RecordTypeId == exchangeInDays || caseRec.RecordTypeId == exchangeInHours || caseRec.RecordTypeId == returnForRepairCaseRType || caseRec.RecordTypeId == childCaseReadOnly) && caseRec.HWS_Stockable_Product__c <> null && caseRec.HWS_ServiceType__c!=HWS_Constants.AEH){
	caseVerItmIdSet.add(caseRec.HWS_Stockable_Product__c);
			}
		}
		if(caseVerItmIdSet.size()>0){
			Map<Id, Hws_Versionitem__C> verItmMap = new Map<Id, Hws_Versionitem__C>([SELECT HWS_Serial_Number_Traceable__c FROM Hws_Versionitem__c WHERE Id in : caseVerItmIdSet]);
			
			for(case caseRec: caseList)  {
	if(caseRec.HWS_Stockable_Product__c != null && verItmMap.containskey(caseRec.HWS_Stockable_Product__c)){
		Hws_Versionitem__C versionItem = verItmMap.get(caseRec.HWS_Stockable_Product__c);
		if(versionItem.HWS_Serial_Number_Traceable__c != null && (versionItem.HWS_Serial_Number_Traceable__c.equalsIgnoreCase('YES') || versionItem.HWS_Serial_Number_Traceable__c.equalsIgnoreCase('Y')) && (caseRec.HWS_Faulty_Serial_Number__c == ''  || caseRec.HWS_Faulty_Serial_Number__c == null)){
			caseRec.HWS_Faulty_Serial_Number__c.addError(System.Label.HWS_Faulty_Unit_Serial_Number);
		}	
	}
			}
		} 
	}
	
	/********************
*Method Name: duplicateSerialNumberCheck
*Parameter: New Case List (Only HWS Handling child Record Type Records)
*Last updated by: TCS
*Description: Method to validate HWS Faulty Serial Number field and product Material code. If the Faulty Unity serial number and material code is part of an existing case pending for closure
(Status not equals to Closed, cancelled,Delivered) then it should display error.
*	 
*******************/	
	public static void duplicateSerialNumberCheck(Map<Id,Case> oldCaseMap, List < Case > caseList) {		 
		Set<Id> caseProductId = new Set<Id>();
		String caseFaultyUSnum ;
		String errorMessage = System.Label.HWS_Duplicate_SNumber_ErrorMsg;
		set<String> prcodeset = new set<String>();
		if(caseList.size()> 0){
			for(case caseRec: caseList)  {
	if((caseRec.RecordTypeId== exchangeInDays || caseRec.RecordTypeId == exchangeInHours || caseRec.RecordTypeId == childCaseReadOnly
		|| caseRec.RecordTypeId == returnForRepairCaseRType) 
	   && (caseRec.Status !='Closed' || caseRec.Status !='Cancelled' || caseRec.Status !='Delivered') &&
	   (oldCaseMap == null ||  caseRec.HWS_Faulty_Serial_Number__c != oldCaseMap.get(caseRec.Id).HWS_Faulty_Serial_Number__c)  )
	{
		caseProductId.add(caseRec.HWS_Sellable_Product__c);
		caseFaultyUSnum =  caseRec.HWS_Faulty_Serial_Number__c ;
	}
			}
		}
		
		if(caseProductId <> null){
			//added  for PMD Error - NOKIASC-32425
			list<product2> productsList = [select id,name, Productcode from product2 where ID IN :caseProductId AND HWS_DoNotConsider__c = false ];
			if(productsList.size() > 0){
	for(Product2 prod:productsList){
		prcodeset.add(prod.ProductCode) ;
	}
	//added  for PMD Error - NOKIASC-32425
	List<Case> cRecdup =[Select id,HWS_Faulty_Serial_Number__c,CaseNumber,Status From Case
			 where (status Not in:childCaseStatusesforDuplicte ) AND HWS_Sellable_Product__r.ProductCode In : prcodeset 
			 AND HWS_Faulty_Serial_Number__c =: caseFaultyUSnum AND HWS_Faulty_Serial_Number__c !=null AND HWS_Faulty_Serial_Number__c !='UNKNOWN'];	
	if(cRecdup.size() > 0){
		for(case caseRec: caseList)  {
			caseRec.HWS_Faulty_Serial_Number__c.addError(errorMessage +' :Case Number is '+cRecdup[0].CaseNumber);
		}
	}
			}
		}
	}
	
	/*********
*Method Name: sendCaPMEmailAccOwner
*Parameter: Old Case Map, New Case List
*Events: BeforeUpdate,BeforeInsert
*Description: Used to send an Email to Account owner if CaPM email is missing on service contract
**********/
	public static void sendCaPMEmailAccOwner(Map<Id,Case> oldCaseMap,List<Case> newCaseList) {
		Set<Id> servContIdSet= new Set<Id>();
		Map<Id,ServiceContract> servContMap= new Map<Id,ServiceContract>();
		
		for(Case ce : newCaseList){servContIdSet.add(ce.NCP_Service_Contract__c);}
		//added  for PMD Error - NOKIASC-32425
		for(ServiceContract sc: [select id,name,CH_CAPM_EmailAddress__c from ServiceContract where Id IN : servContIdSet ]){servContMap.put(sc.Id,sc);}
		try{  
			for(Case cs : newCaseList){
	if(trigger.isUpdate && (cs.Parentid <> null && (oldCaseMap.get(cs.Id).Status <> cs.Status && cs.Status == 'On Hold') && !servContMap.isEmpty())){ 
		
		cs.HWS_Capm_Email__c = servContMap.get(cs.NCP_Service_Contract__c).CH_CAPM_EmailAddress__c;
		
	}
	if(trigger.isInsert && (cs.Parentid <> null && cs.Status == 'On Hold' && !servContMap.isEmpty())){
		cs.HWS_Capm_Email__c = servContMap.get(cs.NCP_Service_Contract__c).CH_CAPM_EmailAddress__c;
		
	}
			}
		}catch(Exception e){system.debug('===Exception=='+ e);} 
	}
	
	/*********
*Method Name: RMANumberPopulate
*Last updated by: TCS
*Parameter: New Case List
*Events: BeforeInsert
*Description: Used to populate the Parent Case number in RMA Number and Subject fields of related Child cases.
RMA Number Format: <Parent CaseNumber-001>
Subject Format: <RMA : Parent CaseNumber-001> 
**********/   
	// Updated on NOKIASC-36077 | 03/06/2021
	public static void RMANumberPopulate(Map<Id,Case> oldCaseMap, List<Case> newCaseList){
		
		Map<Id,String> caseMapNumber = new Map<Id,String>();
		Map<Id,Integer> childSize = new Map<Id, Integer>();
		map<id, List<case>>mpchild = new map<id, List<case>>();
		List<Case> allChildCases = new List<Case>();
		if(newCaseList != null){
			Set<Id> parentIds = new Set<Id>();
			for(Case caserec : newCaseList) {
	parentIds.add(caserec.ParentId);
	if(caserec.ParentId != null){
		allChildCases.add(caserec);	 
		
	}
	
			}
			
			//added  for PMD Error - NOKIASC-32425
			List<Case> parentCase1=[Select id,CaseNumber,HWS_RMA_Number__c,Subject,(SELECT ID FROM cases) from Case where id In: parentIds ];
			
			map<id, Integer>mpchildCount = new map<id, Integer>();
			if(parentcase1.size() > 0) {
	
	
	for(Case ce : parentCase1){
		caseMapNumber.put(ce.Id,ce.CaseNumber);
		childSize.put(ce.Id, ce.Cases.Size());
	}
	for(Case ce:allChildCases){
		if(!mpchild.containsKey(ce.ParentId)) {
			mpchild.put(ce.ParentId, new List<case>());			
			mpchildCount.put(ce.ParentId,1);			 
		}
		else{		
			Integer iChildCount = mpchildCount.get(ce.ParentId);
			iChildCount = iChildCount+1;
			mpchildCount.put(ce.ParentId,iChildCount);
		}
		if((ce.ParentId) != null){
			if(ce.RecordTypeId==exchangeInHours || ce.RecordTypeId==exchangeInDays || ce.RecordTypeId == returnForRepairCaseRType){
				if(((mpchildCount.get(ce.ParentId)+(childSize.get(ce.ParentId)))<10)){
		
		ce.HWS_RMA_Number__c=caseMapNumber.get(ce.ParentId)+'-00'+(mpchildCount.get(ce.ParentId)+(childSize.get(ce.ParentId)));
				}
				else if(((mpchildCount.get(ce.ParentId)+(childSize.get(ce.ParentId)))>=10)&&((mpchildCount.get(ce.ParentId)+(childSize.get(ce.ParentId)))<100)){		
		ce.HWS_RMA_Number__c=caseMapNumber.get(ce.ParentId)+'-0'+(mpchildCount.get(ce.ParentId)+(childSize.get(ce.ParentId)));
				}
				else if((mpchildCount.get(ce.ParentId)+(childSize.get(ce.ParentId)))>=100){
		  ce.HWS_RMA_Number__c=caseMapNumber.get(ce.ParentId)+'-'+(mpchildCount.get(ce.ParentId)+(childSize.get(ce.ParentId)));
				}
				ce.Subject=('RMA'+' : '+ce.HWS_RMA_Number__c);
			}		
			//Adding below Logic For SPS cases
			if((ce.RecordTypeId== sPSCaseRType)){		 
				if(((mpchildCount.get(ce.ParentId)+(childSize.get(ce.ParentId)))<10)){
		ce.HWS_SPS_Order_No__c =caseMapNumber.get(ce.ParentId)+'-00'+(mpchildCount.get(ce.ParentId)+(childSize.get(ce.ParentId)));
				}
				else if(((mpchildCount.get(ce.ParentId)+(childSize.get(ce.ParentId)))>=10)&&((mpchildCount.get(ce.ParentId)+(childSize.get(ce.ParentId)))<100)){
		ce.HWS_SPS_Order_No__c=caseMapNumber.get(ce.ParentId)+'-0'+(mpchildCount.get(ce.ParentId)+(childSize.get(ce.ParentId)));
				}
				else if((mpchildCount.get(ce.ParentId)+(childSize.get(ce.ParentId)))>=100){
		ce.HWS_SPS_Order_No__c=caseMapNumber.get(ce.ParentId)+'-'+(mpchildCount.get(ce.ParentId)+(childSize.get(ce.ParentId)));
				}
				if(ce.HWS_SPS_Order_No__c != null){
		ce.Subject=('SPS'+' : '+ce.HWS_SPS_Order_No__c);
				} 
			}			
		}
		mpchild.get(ce.ParentId).add(ce);	   
	}   
	
			}
			for(id parentid : parentIds){
	mpchild.get(parentid);
			}
		}
	}
	
	/*********
*Method Name: calculatingTotalShippedQuantity
*Last updated by: TCS
*Parameter: old Case Map, New Case Map
*Events: Beforeupdate
*Description: Used to Calculate Total Shipped Quantity.
**********/ 
	public static void calculatingTotalShippedQuantity(map<id, Case> oldCases, List <Case> newCaseList){		
		for(Case caseRec: newCaseList){		 
			if(caseRec.HWS_TotalShippedQuantity__c == null){
	caseRec.HWS_TotalShippedQuantity__c = 0;
			}	 
			if(caseRec.HWS_TotalShippedQuantity__c < caseRec.HWS_Quantity__c && caseRec.HWS_ShippedQuantity__c < caseRec.HWS_Quantity__c ){
	caseRec.HWS_TotalShippedQuantity__c = caseRec.HWS_TotalShippedQuantity__c + caseRec.HWS_ShippedQuantity__c; 
			}
		}
	}
	
	/*********
*Method Name: handleCaseFieldChanges
*Last updated by: TCS
*Parameter: old Case Map, New Case Map
*Events: Beforeupdate
*Description: Used to Track changes on HWS Case record Type Fields
**********/   
	public static void handleCaseFieldChanges(map<id, Case> oldCases, List<Case> newCaseList ){  
		CH_CustomFieldTracking_beta.trackFieldChanges(oldCases,newCaseList);	
	}
	
	/*********
*Method Name: updateRetunDeliveryOnParent
*Parameter: Case List
*Events: AfterUpdate
*Description: updates the retundelivery received flag on parent after receiving return delivery address for all the child cases.
**********/
	// Updated on NOKIASC-36077 | 03/06/2021
	public Static void updateRetunDeliveryOnParent(List<Case> caseList){
		Set<ID> parentIds = new Set<Id>();
		Set<ID> childIdsets = new Set<Id>();
		List<Case> parentCases = new List<Case>();
		Set<Case> parentsToBeUpdated = new Set<Case>();
		for(Case cs: caseList){
			if(cs.ParentId !=null){
	parentIds.add(cs.ParentId);
			}
			else{
	parentIds.add(cs.Id);
			}
		}
		//added  for PMD Error - NOKIASC-32425
		parentCases=[SELECT Id,HWS_ReturnAddressReceivedFromSOO__c,CH_InternalStatus__c		 
		 FROM Case
		 WHERE Id IN: parentIds ];
		Map<Id, Id> parentIdAttIdMap = new Map<Id, Id>();
		for(Attachment att : [select Id,parentId from Attachment where parentId IN: parentIds]){
			parentIdAttIdMap.put(att.parentId, att.Id);
		}
		List<Case> allChildCases = new List<Case>();
		allChildCases = [SELECT Id,parent.CH_InternalStatus__c,parent.HWS_ReturnAddressReceivedFromSOO__c,Status,HWS_Address_Name__c,City__c,State__c,Country__c,POSTAL_CODE_CHQ__c,HWS_Bar_Code__c,HWS_Bar_Code_Ref1__c
			 FROM Case where parent.id IN:parentIds];	
		Map < Id, boolean > isdeliveryAddrSent = new Map<Id, boolean >();
		if(parentCases.Size()>0){
			for(Case child:allChildCases){	 
	if(!isdeliveryAddrSent.containsKey(child.parent.Id)) {
		isdeliveryAddrSent.put(child.parent.Id, true);
		childIdsets.add(child.id);
	}
	
	String parentBarcode = child.HWS_Bar_Code__c;
	String rmaBarcode = child.HWS_Bar_Code_Ref1__c;
	if(parentBarcode == null || rmaBarcode == null ){ //modified for NOKIASC-37193
		//|| child.parent.CH_InternalStatus__c =='Waiting for Referral Instruction' || child.parent.CH_InternalStatus__c ==null || //child.parent.HWS_ReturnAddressReceivedFromSOO__c == false){
		isdeliveryAddrSent.put(child.parent.Id, false);
	}
	
			}
			for(Case parent:parentCases){
	//new check
	if(parentIdAttIdMap != null && parentIdAttIdMap.get(parent.Id) == null){
		Boolean deliveryAddrSent=true;
		if(allChildCases.Size()>0){
			deliveryAddrSent = isdeliveryAddrSent.get(parent.id);
			if(!System.IsBatch() && !System.isFuture() && deliveryAddrSent ){ // &&  !parent.HWS_ReturnAddressReceivedFromSOO__c ){ //NOKIASC-38081
				HWS_OrderConfirmationNotification.sendEmailNotificationForPDF(childIdsets);
				parent.HWS_ReturnAddressReceivedFromSOO__c=True;
				parentsToBeUpdated.add(parent);
				Set<Id> childIds = new Set<Id>();
				Integer processingSize = 20;
				if(HWS_GenericSettings__c.getValues('OrderedProcessingSize').HWS_Field1__c!=null){
		processingSize = Integer.valueOf(HWS_GenericSettings__c.getValues('OrderedProcessingSize').HWS_Field1__c);
				}
				for(Case caseRec : allChildCases){
				if(caseRec.HWS_Address_Name__c == null){
		if(childIds.size()<processingSize){
			childIds.add(caseRec.Id);
		}
		else{
			HWS_UpdateReturnDeliveryAddress.updateReturnDeliveryAddressOnChildCase(childIds,parent.Id);  
			childIds.clear(); 
			childIds.add(caseRec.Id);
		}
		}
				}
				if(childIds.size()>0){
		HWS_UpdateReturnDeliveryAddress.updateReturnDeliveryAddressOnChildCase(childIds,parent.Id);  
				}
			}
		}
	}
			}
		} 
	}
	/*****************************************************************************************
* Name : updateChildCaseEntitlementStatus
* Description : Update the Child Case Entitlement Status when Quotation sent date is changed
* Parameters: CaseList
* Returns: Void
*****************************************************************************************/
	public static void updateChildCaseEntitlementStatus(List<Case> caseList,Map < Id, Case > oldCaseMap) {  
		if(caseList.Size()>0){
			Set<Id> quoteDateParentCases = new Set<Id>();
			List<Case> childCaseList = new List<Case>();
			for(Case cas : caseList){
	Case oldCase = oldCaseMap.get(cas.Id);
	if(parentConsoleRecordTypeIds.contains(cas.RecordTypeId) && oldCase.HWS_QuotationSentDate__c != cas.HWS_QuotationSentDate__c){
		quoteDateParentCases.add(cas.Id);
	}
			}
			if(quoteDateParentCases.size()>0){
	for(Case caseRec : [select Id,CH_EntitlementStatus__c from Case Where CH_EntitlementStatus__c='Pending Quotation Creation' AND ParentId in: quoteDateParentCases]){
		caseRec.CH_EntitlementStatus__c = 'Pending Customer Acceptance of Quote';
		childCaseList.add(caseRec);
	}
	if(childCaseList.size()>0){
		update childCaseList;
	}
			}
		}   
	}
	/*****************************************************************************************
* Name : validationsOnCaseForDate
* Description : Validation rule for the requested and planned delivery dates on case
* Parameters: CaseList
* Returns: Void
*****************************************************************************************/
	public static void validationsOnCaseForDate(List<Case> caseList) {  
		if(caseList.Size()>0){
			for(Case cas : caseList){
	if((cas.RecordTypeId== exchangeInDays || cas.RecordTypeId == exchangeInHours || cas.RecordTypeId == childCaseReadOnly
		|| cas.RecordTypeId ==sPSCaseRType || cas.RecordTypeId == returnForRepairCaseRType || cas.RecordTypeId == spsReadOnly) && 
	   ((cas.HWS_Planned_Delivery_Date__c != null) && (cas.HWS_Requested_Delivery_Date_Time__c != null))
	   && (cas.HWS_Requested_Delivery_Date_Time__c < cas.HWS_Planned_Delivery_Date__c && (cas.HWS_ServiceType__c!=HWS_Constants.IR && cas.HWS_ServiceType__c != HWS_Constants.RFR))){		 
		cas.HWS_Requested_Delivery_Date_Time__c.addError(System.Label.HWS_Planned_Delivery_date);
		
		
	   }
			}
		}   
	}
	
	/********************
*Method Name: Recalculating Planned delivery date
*Parameter: New Case List , Old case map
*Last updated by: TCS
*Description: Method to validate HWS service type field . If the service type field is "Identical Repair" and Hws faulty unit receive date is changed 
then  SLA needs to recalculate for the Identical repair Service type.
*	 
*******************/	
	public static void reCalculatePlannedDeliveryDate(Map <Id,Case> oldCaseMap,List<Case> caseList){	
		Set<Id> countId=new Set<Id>();
		if(caseList.Size()>0){
			for(Case casCalculate: caseList){   
	If((casCalculate.HWS_ServiceType__c==HWS_Constants.IR || casCalculate.HWS_ServiceType__c == HWS_Constants.RFR) && casCalculate.HWS_FaultyUnitReceivedDate__c!=oldCaseMap.get(casCalculate.Id).HWS_FaultyUnitReceivedDate__c)
	{
		countId.add(casCalculate.ID);
		
	}
			}
		}	
		if(countId.Size()>0 ){
			//added  for PMD Error - NOKIASC-32425
			Map<ID,Case> caseLvale=new Map<ID,Case>([Select Id,HWS_Planned_Delivery_Date__c,HWS_FaultyUnitReceivedDate__c,Asset.HWS_ContractLineItem__r.CH_BusinessHour__c,Asset.HWS_ContractLeadTimeUnit__c,Asset.HWS_ContractLeadTimeDuration__c,Asset.HWS_SpecifiedDeliveryTargetTime__c from case where Id in :countId ]);
			for(Case casCalculate: caseList){	
	if(caseLvale.get(casCalculate.id).Id == casCalculate.id && caseLvale.get(casCalculate.id).Asset.HWS_ContractLineItem__r.CH_BusinessHour__c != null ){	
		DateTime  dateUpdat=HWS_Utilty.plannedDeliveryDateTime(caseLvale.get(casCalculate.id).Asset.HWS_ContractLineItem__r.CH_BusinessHour__c,caseLvale.get(casCalculate.id).Asset.HWS_ContractLeadTimeUnit__c,caseLvale.get(casCalculate.id).Asset.HWS_ContractLeadTimeDuration__c,casCalculate.HWS_FaultyUnitReceivedDate__c,caseLvale.get(casCalculate.id).Asset.HWS_SpecifiedDeliveryTargetTime__c);	
		casCalculate.HWS_Planned_Delivery_Date__c=dateUpdat;
		
	}
			}
		}  
	}   
	
	/*****************************************************************************************
* Name : entitlementNamePopulate
* Description : enable milestone tracker on Child Case for RFR
* Parameters: CaseList
* Returns: Void
*****************************************************************************************/
	public static void entitlementNamePopulate(List<Case> caseList) {	 
		Set<Id> cliIdSet = new Set<Id>();
		Map<Id, Id> cliIdEntilmentIdMap = new Map<Id, Id>();
		List<Entitlement> entitlementLst = new List<Entitlement>();
		
		if(!caseList.isEmpty()){
			for(Case childCase : caseList){
	if(childCase.HWS_Contract_Line_Item__c!=null){
		cliIdSet.add(childCase.HWS_Contract_Line_Item__c);
	}
			}
		}	
		if(!cliIdSet.isEmpty()){
			//added  for PMD Error - NOKIASC-32425
			entitlementLst = [SELECT Id, Name, AssetId, ContractLineItemId 
		 FROM Entitlement 
		 WHERE ContractLineItemId IN :cliIdSet
		 AND ContractLineItem.NCP_External_Status__c = 'Active' ];
		}	
		if(!entitlementLst.isEmpty()){
			for(Entitlement ent : entitlementLst){
	cliIdEntilmentIdMap.put(ent.ContractLineItemId, ent.Id);
			}
		}
		for(Case cas : caseList){
			if(((cas.HWS_ServiceType__c == HWS_Constants.RFR) || (cas.HWS_ServiceType__c == HWS_Constants.IR)) && (cas.HWS_FaultyUnitReceivedDate__c != null) && cas.Status == 'Ordered'){
	cas.EntitlementId = cliIdEntilmentIdMap.get(cas.HWS_Contract_Line_Item__c);
			}
		}  
	}  
	/*****************************************************************************************
* Name : completeMilestone
* Description : Complete Milestone when case is closed
* Parameters: CaseList
* Returns: Void
*****************************************************************************************/
	public static void completeMilestone(List<Case> caseList) {
		DateTime complDate = System.now(); 
		List<Id> caseIdLst = new List<Id>();
		if(caseList.Size()>0){
			for(Case c : caseList){
	if ((c.SlaExitDate == null) && (c.SlaStartDate <= complDate)){
		if((c.HWS_ServiceType__c == 'Advanced Exchange in Days' 
			|| c.HWS_ServiceType__c == HWS_Constants.RFR 
			|| c.HWS_ServiceType__c == HWS_Constants.IR 
			|| c.HWS_ServiceType__c == HWS_Constants.SPS) && (c.HWS_Shippeddate__c != null)){
				caseIdLst.add(c.Id);
			} 
		else if ((c.HWS_ServiceType__c == HWS_Constants.AEH) && (c.HWS_ProofDeliveryDate__c != null)){
			caseIdLst.add(c.Id);
		}
	}
			}
		}
		if(!caseIdLst.isEmpty()){
			//added  for PMD Error - NOKIASC-32425
			List<CaseMilestone> cmsToUpdate = [SELECT Id, CompletionDate FROM CaseMilestone WHERE caseId in :caseIdLst AND MilestoneType.Name = 'HWS Milestone Tracker' AND completionDate = null  limit 1];
			if (!cmsToUpdate.isEmpty()){
	for (CaseMilestone cm : cmsToUpdate){
		cm.completionDate = complDate;
	}
	try{
		update cmsToUpdate;
	}catch(System.DmlException de){
		System.debug(LoggingLevel.DEBUG,'Cannot Update Case ' +de.getMessage() +de.getStackTraceString());
	}
			}
		}   
	}
	/*****************************************************************************************
* Name : updateMilestoneChecbox
* Description : Update HWS_StartMilestone__c to true from batch class for RFR & IR records when we received HWS_FaultyUnitReceivedDate__c 
* Parameters: CaseList
* Returns: Satya
* Milestone CPU Time Limit Fix
*****************************************************************************************/
	public static void updateMilestoneChecbox(List<Case> caseList) {
		
		List<Id> parentCaseIdSet = new List<Id>();
		List<Id> parentCaseIdLst = new List<Id>();
		for(Case c :caseList){
			if(c.ParentId != null && c.HWS_FaultyUnitReceivedDate__c != null && c.HWS_StartMilestone__c != true && (c.HWS_ServiceType__c ==HWS_Constants.RFR || c.HWS_ServiceType__c ==HWS_Constants.IR)){
	parentCaseIdSet.add(c.ParentId);
			}
			if(c.ParentId != null && c.Status == 'Ordered' && c.HWS_StartMilestone__c != true && (c.HWS_ServiceType__c == 'Advanced Exchange in Days'|| c.HWS_ServiceType__c ==HWS_Constants.AEH || c.HWS_ServiceType__c ==HWS_Constants.SPS)){
	parentCaseIdSet.add(c.ParentId);
			}
		}
		if(parentCaseIdSet.size()>0){
			parentCaseIdLst.addAll(parentCaseIdSet);
			Database.executeBatch(new HWS_StartMilestoneCalculationBatch (parentCaseIdLst), 50);
		}
	}
	/*****************************************************************************************
* Name : totalNetValueCalculateOnChild
* Description : Calculate Total Net Value for SPS Child Cases
* Parameters: CaseList
* Returns: Bharathi N   
*****************************************************************************************/
	public static void totalNetValueCalculateOnChild(List<Case> newCaseList){ 
		Set<Id> assetIdSet = new Set<Id>();
		Set<Id> contractIdSet = new Set<Id>();  
		Decimal i = 0;
		if(newCaseList != null){
			for(Case caserec : newCaseList) {
	if((caserec.RecordTypeId == sPSCaseRType || caserec.RecordTypeId == spsReadOnly) && (caserec.AssetId != null)){
		
		assetIdSet.add(caserec.AssetId);
		contractIdSet.add(caserec.NCP_Service_Contract__c); //NOKIASC-36283	 
		
	}
			}  
			if(!assetIdSet.isEmpty()){
	Map<Id,Asset> assetIdPriceMap = new Map<Id,Asset>([Select Id,HWS_Price__c from Asset where Id IN:assetIdSet]);
	Map<Id,ServiceContract> serviceContractIdMap = new Map<Id,ServiceContract>([Select Id,HWS_PurchaserType__c from ServiceContract where Id IN:contractIdSet]);
	
	for(Case cas : newCaseList){
		if(assetIdPriceMap.containsKey(cas.AssetId)){
			String price;
			if(assetIdPriceMap.get(cas.AssetId).HWS_Price__c != null && assetIdPriceMap.get(cas.AssetId).HWS_Price__c != ''){
				price = assetIdPriceMap.get(cas.AssetId).HWS_Price__c;
				
				i = Decimal.valueof(price) * cas.HWS_Quantity__c; // Modified the logic to accept Decimal values for defect# 4342
				cas.HWS_Net_Quantity__c = String.valueOf(i);
			}
		}
		//NOKIASC-36283
		if(serviceContractIdMap != null && cas.NCP_Service_Contract__c != null && serviceContractIdMap.get(cas.NCP_Service_Contract__c).HWS_PurchaserType__c == 'Customer Via Partner'){
			cas.HWS_Net_Quantity__c = '0';
		}
	}
			}
			
		}
	}
	/*****************************************************************************************
* Name : totalNetValueCalculateOnParent
* Description : Calculate Total Net Value for SPS Parent Case
* Parameters: CaseList
* Returns: Bharathi N   
*****************************************************************************************/
	public static void totalNetValueCalculateOnParent(List<Case> caseList){ 
		Set<Id> parentCaseIdSet = new Set<Id>();
		List<Case> caseListToUpdate = new List<Case>();
		for(Case c : caseList){
			if((c.RecordTypeId == sPSCaseRType || c.RecordTypeId == spsReadOnly) && (c.ParentId != null)){
	
	parentCaseIdSet.add(c.ParentId);
	
			}
		}
		if(!parentCaseIdSet.isEmpty()){
			//added  for PMD Error - NOKIASC-32425
			List<Case> parentCaseList =[Select Id,HWS_Net_Quantity__c,(Select Id,HWS_Net_Quantity__c from Cases) from Case where Id IN:parentCaseIdSet ];	 
			for(Case cas : parentCaseList){
	Decimal s = 0;// Modified the logic to accept Decimal values for defect# 4342
	if(cas.Cases.size() > 0){
		for(Case c:cas.Cases){
			if(c.HWS_Net_Quantity__c != null){
				s = s+Decimal.valueOf(c.HWS_Net_Quantity__c);// Modified the logic to accept Decimal values for defect# 4342
			}
		}   
	}
	cas.HWS_Net_Quantity__c = String.valueOf(s);
	caseListToUpdate.add(cas);
			}
		}
		update caseListToUpdate;
	}
	
	public static void relatedSupportTicketNumCheck(Map<Id,Case> oldCaseMap, List < Case > caseList){
		List<String> caseNumbers = new List<String>();
		Map<String,Case> caseNumbervsCseMap = new Map<String,Case>();
		for(Case cs:caseList) {
			caseNumbers.add(cs.HWS_RelatedSoftwareTicketNumber__c);
		}
		List<Case> swsCases = HWS_Utilty.getCasesByCaseNumber(caseNumbers);
		if(swsCases.size()>0){
			for(Case cs:swsCases) {
	caseNumbervsCseMap.put(cs.CaseNumber,cs);
			}
		}
		for(Case cs:caseList) {
			if(cs.HWS_RequestHWRCAFMA__c==true && (cs.HWS_RelatedSoftwareTicketNumber__c==null || cs.HWS_Sponsor__c == null)){
	cs.addError(System.Label.HWS_RMA_Sponsor_mandatory);
			}
			else if(oldCaseMap.get(cs.Id).HWS_RequestHWRCAFMA__c == true && cs.HWS_RequestHWRCAFMA__c == false){
	cs.HWS_RelatedSoftwareTicketNumber__c = '';
	cs.HWS_Sponsor__c = '';
			}
			else if(caseNumbervsCseMap.get(cs.HWS_RelatedSoftwareTicketNumber__c) != null){
	case swscase = caseNumbervsCseMap.get(cs.HWS_RelatedSoftwareTicketNumber__c);
	if (!swscase.CH_RecordTypeCheck__c) {
		cs.addError(System.Label.HWS_RedTagFMAInvalidServiceTypeError);
	} 
	if(cs.AccountId != swscase.AccountId){
		cs.addError(System.Label.HWS_RedTagFMALegalEnityMismatchError);
	}
			}
			else if(cs.HWS_RelatedSoftwareTicketNumber__c != null && caseNumbervsCseMap.get(cs.HWS_RelatedSoftwareTicketNumber__c) == null){
	cs.addError(System.Label.HWS_RedTagFMACaseNumberNotExistsError);
			}
			else if (oldCaseMap.get(cs.Id).HWS_RequestHWRCAFMA__c != cs.HWS_RequestHWRCAFMA__c && (cs.HWS_FaultyUnitReceivedDate__c != null || System.today() > cs.CreatedDate + 90 )){
	cs.addError(System.Label.HWS_Request_HW_RCA_FMA);
			}
		}
	}
	
	
	
	/****************************************
* Name : referralInstructionNotification
* Description : publishes HWS Referral Instruction Event Platoform Event
* Parameters: Case List
* Returns : NA
* written on 11th Nov 2020
* User Story : NOKIASC-31233
*****************************************/
	public static void referralInstructionNotification(List<Case> caseList) {
		String refInstr;
		for(Case ca : caseList){
			if(ca.CH_InternalStatus__c != '' && ca.CH_InternalStatus__c != null && ca.CH_InternalStatus__c != 'Warranty Verification Required'){
	refInstr = ca.CH_InternalStatus__c+'#'+ca.CaseNumber+'#'+ca.CreatedById;	
			}
		}
		if(refInstr != null && refInstr != ''){	 
	 HWS_Referral_Instruction_Event__e ri = new HWS_Referral_Instruction_Event__e(HWS_Referral_Instruction_Status__c=refInstr);
		}
	}
   
	
	/********************
/*Method Name: updateOwnerForClosedAndCancelledParentCases
*Parameter: CaseList, oldCaseMap
*Created by :TCS
*Last updated by:
*Description: When Parent Case is Closed or Canceled then change the Support Ticket Owner to the user with the name “Archived Case No Owner” 
*User Story: NOKIASC-32139
****************/
	public static void updateOwnerForClosedAndCancelledCases(List<Case> newCaseList, Map<Id,Case> oldCaseMap) {
		for(Case newCase : newCaseList) {	 
			if(newCase.Status.equals('Cancelled') || newCase.Status.equals('Closed')) {
	Case oldCase = oldCaseMap.get(newCase.Id);
	if(oldCase != null && !oldCase.Status.equals('Closed') && !oldCase.Status.equals('Cancelled')) {		
		newCase.OwnerID = System.Label.HWS_Archived_Case_No_Owner;  
	}
			}
		}
	}
	/********************
/*Method Name: passiveAssignmentHWSParentCase
*Parameter: CaseList, oldCaseMap
*Created by :TCS
*Last updated by:
*Description: When Parent Case internalstatus changed do passive assignment on HWS Case  
*User Story: NOKIASC-34641,34642,34643
****************/
	public static void passiveAssignmentHWSParentCase(Map < Id, Case > oldCaseMap, List < Case > newCaseList) {
		Set<Id> hwsParentCaseSet = new Set<Id>();
		for(Case c: newCaseList)
		{
			if(oldCaseMap !=null){
	if((c.CH_InternalStatus__c != oldCaseMap.get(c.Id).CH_InternalStatus__c) && 
	   (c.CH_InternalStatus__c=='Warranty Verification Required' || c.CH_InternalStatus__c=='Quotation Required' )){
		hwsParentCaseSet.add(c.id);	 
	   }  
			}
			else{
	if((c.CH_InternalStatus__c=='Warranty Verification Required' || c.CH_InternalStatus__c=='Quotation Required' )){
		hwsParentCaseSet.add(c.id);	
	}  
			}
			
		}
		//NOKIASC-38090:refactoring trigger|Start
		if(hwsParentCaseSet.size()>0){
			//START-NOKIASC-34747-Adding Case team members to Parant case when CH_InternalStatus__c Warranty Verification Required/Quotation Required
			List<case> childcaseList=new List<case>([SELECT Id,ParentId,NCP_Service_Contract__r.OwnerId from case Where NCP_Service_Contract__r.OwnerId != :Label.CH_IPaas_User_Id AND  ParentId IN : hwsParentCaseSet]);
			
			Map < Id, List<case> > parentIdchildcasesMap = new Map<Id, List<case> >();
			List < CaseTeamRole > caseTeamRoleList = [SELECT Id, Name FROM CaseTeamRole WHERE Name = 'Customer Care Manager'];
			List < CaseTeamMember > caseTeamMemberList = new List < CaseTeamMember > ();
			
			for(case caseobj : childcaseList) {
	if(String.isNotBlank(caseobj.ParentId)){
		if(!parentIdchildcasesMap.containsKey(caseobj.ParentId)) {
			parentIdchildcasesMap.put(caseobj.ParentId, new List<case>());
		}
		parentIdchildcasesMap.get(caseobj.ParentId).add(caseobj);
	}
			}
			
			for(Id parentcaseId:parentIdchildcasesMap.KeySet()){
	
	CaseTeamMember caseTeamMemberObj = new CaseTeamMember();
	caseTeamMemberObj.ParentId = parentcaseId;
	caseTeamMemberObj.MemberId = parentIdchildcasesMap.get(parentcaseId)[0].NCP_Service_Contract__r.OwnerId;
	caseTeamMemberObj.TeamRoleId = caseTeamRoleList.get(0).Id;
	caseTeamMemberList.add(caseTeamMemberObj);
			}
			
			
			if(!caseTeamMemberList.isEmpty()) {
	try {
		insert caseTeamMemberList;
	} catch(Exception ex) {
		//This is empty
	}
			}//END-NOKIASC-34747
			List<Id> hwsParentCaseList = new List<Id>(hwsParentCaseSet);		
			if(hwsParentCaseList.size() > 0){
	routeHWSParentCase(hwsParentCaseList[0]);
			}	 
		}
		//NOKIASC-38090:refactoring trigger|End
	} 
	/********************
/*Method Name: routeHWSParentCase
*Parameter: caseId
*Created by :TCS
*Last updated by:
*Description: When Parent Case internalstatus changed do passive assignment on HWS Case  
*User Story: NOKIASC-34641,34642,34643-Get the passive workgroup members for first workgroup found against HWS parent Case   
****************/   
	public static void routeHWSParentCase(Id caseId) {
		try{
			CH_CA_Service service = new CH_CA_Service(caseId);
			//Get all passive workgroup members that can be assigned to the HWS parent Case 
			Set<Id> oWorkgroupMemberIdSet = new Set<Id>();
			for(CH_CA_DTO.WorkgroupMemberDTO workgroupMember : service.getPassiveCaseAssignmentForHWSWorkgroupMembers()) {
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
	oAssignmentMap.put(caseId, workgroupMember);
			}
			if(!oAssignmentMap.isEmpty()) {
	service.assignUser(oAssignmentMap);
	if(!HWS_CasetriggerHandler.isNewCase){//added to prevent duplicate Workgroup assignment email from escalatecases NOKIASC-37185
		HWS_EmailNotifications.workgroupEmailAssignment(caseId,'Workgroup Assign Emails',oAssignmentMap.get(caseId).CH_Queue_Email__c,oAssignmentMap.get(caseId).CH_Workgroup__r.Name);
	}
			}
		}
		catch(Exception e){ /* Do Nothing */ }
	}
	// To update default values for Entitlement Status and Entitlement Exception when serial number changes and warranty status gets updated
	public static void setDefaultValuesToEntitlement(Map < Id, Case > oldCaseMap, List < Case > newCaseList)
	{
		
		Map<String, String> clItemWQCondition = new Map<String, String>();
		List<ContractLineItem> clItemList = new List<ContractLineItem>();
		List<Case> updateList=new List<Case>();
		List<Id> clIds = new List<Id>();
		for(Case caseRec : newCaseList)
		{
			if(caseRec.HWS_Contract_Line_Item__c != null && caseRec.HWS_WarrantyStatus__c != null && caseRec.HWS_WarrantyStatus__c != '' && oldCaseMap.get(caseRec.id).HWS_WarrantyStatus__c!=caseRec.HWS_WarrantyStatus__c)
			{
	
	clIds.add(caseRec.HWS_Contract_Line_Item__c);
	updateList.add(caseRec);
			}
		}
		if(!clIds.isEmpty())
		{
			clItemList = [Select Id,HWS_W_AND_Q_CONDITION__c from ContractLineItem where Id IN: clIds];
			for(ContractLineItem clItem : clItemList)
			{
	clItemWQCondition.put(clItem.Id, clItem.HWS_W_AND_Q_CONDITION__c);
			}   
			newCaseList = HWS_BulkWarrantyCheck_Result_SOO_to_SRM.setEntitlementDefaultValues(clItemWQCondition,updateList);
		}
	}
	//NOKIASC-34963
	public static void updateFaultySerialNumberReceived(Map<Id,Case> oldCaseMap,List<Case> newCaseList){
		//to be executed only when user is iPaas User
		if(UserInfo.getFirstName() == 'iPAAS' && UserInfo.getLastName() == 'User' ){
			for(Case cas:newCaseList){//
	//NOKIASC-38279:update should happen whenever serial number change from downstream
	// if(oldCaseMap.get(cas.Id).HWS_Faulty_Serial_Number__c!=cas.HWS_Faulty_Serial_Number__c){
	cas.HWS_FaultyUnitSerialNumberReceived__c = cas.HWS_Faulty_Serial_Number__c;
	cas.HWS_Faulty_Serial_Number__c = oldCaseMap.get(cas.Id).HWS_Faulty_Serial_Number__c;
	//  }
			}			
		}
		
	}
}