@RestResource(urlMapping='/api/BulkWarrantyResults/*')
global without sharing Class HWS_BulkWarrantyCheck_Result_SOO_to_SRM
{	
	/***  
Author : Eashwar
Story : NOKIASC-34753
Description : Created to receive post callout from SOO and to update Warranty Status on Child cases
*** */
	public static final String WarrantyUnknown= 'Warranty Unknown';
	public static final String OutOfWarranty  = 'Out of warranty';
	public static boolean fromBulk=false;
	@HttpPost
	global static ResponseWarrantyFailure doPost() 
	{
		String requestBody = RestContext.request.requestBody.toString();
		WBodyWrapper kList =(WBodyWrapper) System.JSON.deserialize(requestBody,WBodyWrapper.class);
		List<WarrantyWrapper> wList= kList.Requestitems; 
		String parentCaseID= wList[0].ParentRefid;
		ResponseWarrantyFailure responseObj;
		
		Savepoint sp = Database.setSavepoint();
		try{
			Map<String,String> cidWarrantyStatusMap= new Map<String,String>();
			Map<String,String> clItemIdWQConditionMap= new Map<String,String>();
			for(WarrantyWrapper wr:wList)
			{
	cidWarrantyStatusMap.put(wr.ChildRefId,wr.WarrantyStatus);
			}
			Case childCase=[Select id,parentId,HWS_WarrantyStatus__c,HWS_isQuoteRequired__c,HWS_Contract_Line_Item__c,HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c,Status,CH_EntitlementStatus__c,CH_EntitlementException__c,Cancellation_Reason__c,CH_ReasonForCancellation__c from Case where id in:cidWarrantyStatusMap.keySet() limit 1];
			if(childCase.HWS_WarrantyStatus__c !=null && !(Test.isRunningTest()))
			{
			  responseObj = new ResponseWarrantyFailure(kList.BulkReferenceid,202 ,'Success');
	 return responseObj;  
			}
			if(!cidWarrantyStatusMap.isEmpty())
			{
	List<Case> updateList = new List<Case>();
	List<Case> warrantyUnknownAndQuoteCases = new List<Case>();
	List<Case> listOfCases=[Select id,parentId,Parent.Status,HWS_WarrantyStatus__c,HWS_isQuoteRequired__c,HWS_Contract_Line_Item__c,HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c,Status,CH_EntitlementStatus__c,CH_EntitlementException__c,Cancellation_Reason__c,CH_ReasonForCancellation__c from Case where id in:cidWarrantyStatusMap.keySet()];
	Integer listSize = listOfCases.size();
	List<String> conditions = new List<String>{'HWS_W_AND_Q_UC_1', 'HWS_W_AND_Q_UC_8','HWS_W_AND_Q_UC_2A','HWS_W_AND_Q_UC_2B'};	
	   Boolean warrantyVerificationRequired = false;
	Boolean QuoteRequired = false;
	for(Case cs: listOfCases)
	{
		clItemIdWQConditionMap.put(cs.HWS_Contract_Line_Item__c,cs.HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c);
		cs.HWS_WarrantyStatus__c =  cidWarrantyStatusMap.get(cs.id);
		if(cidWarrantyStatusMap.get(cs.id) == 'Under Warranty'){
			cs.HWS_WarrantyStatus__c =  'In Warranty';
		}
		else if(cidWarrantyStatusMap.get(cs.id) == 'Unknown'){
			cs.HWS_WarrantyStatus__c =  'Warranty Unknown';
		} 
		else if(cidWarrantyStatusMap.get(cs.id) == null || cidWarrantyStatusMap.get(cs.id) ==''){
			cs.HWS_WarrantyStatus__c =  'Failed to determine Warranty';
		}
		else if(cidWarrantyStatusMap.get(cs.id) == 'Out of Warranty'){
			cs.HWS_WarrantyStatus__c =  'Out of Warranty';
		}
		if(cs.HWS_WarrantyStatus__c == 'Out of Warranty' && cs.Status != 'Cancelled' && conditions.contains(cs.HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c)){
			cs.Cancellation_Reason__c='Out of warranty';
			cs.CH_ReasonForCancellation__c = 'Auto Cancelled due to Out of warranty';
			cs.Status = 'Cancelled';
			
		}
	}
	if(!listOfCases.isEmpty())
	{
		fromBulk=true;
		//NOKIASC-38090:bypass trigger logic for bulk warranty check|Start
		HWS_CaseTriggerHelper.byPassTriggerForBulkWarranty=true;
		updateList = setEntitlementDefaultValues(clItemIdWQConditionMap,listOfCases);
		
		update updateList;
		//NOKIASC-38090:Resetting bypass trigger logic bulk warranty check|Start
		//NOKIASC-38090:Bulk Upload: SRM not receiving response (Now calling rest process from platform event)|Start
		HWS_CaseTriggerHelper.byPassTriggerForBulkWarranty=false;
					String status = [select status from case where id=:parentCaseID].status;
					if(status != 'Closed'){
		HWS_Referral_Instruction_Event__e ri = new HWS_Referral_Instruction_Event__e(HWS_ParentCase_Id__c=parentCaseID,HWS_Source__c='HWSBulkCaseUpload');
					Database.SaveResult result = EventBus.publish(ri); 
					} 
		//NOKIASC-38090:Bulk Upload: SRM not receiving response (Now calling rest process from platform event)|End
	}
	
			}
			responseObj = new ResponseWarrantyFailure(kList.BulkReferenceid,202 ,'Success');
			return responseObj;
		}
		catch(Exception e)
		{
			Database.rollback(sp);
			createInterfaceLogError(e.getMessage(),e.getLineNumber() );
			responseObj = new ResponseWarrantyFailure(kList.BulkReferenceid,400 ,''+e.getLineNumber()+e.getMessage());
			return responseObj;
		}
	}
	/********************
/*Method Name: bulkWarrantyUpdateandClone(This Method created to call from paltform events)
*Parameter: parentCaseId
*Created by :TCS
*Last updated by:
*Description: NOKIASC-38090:Bulk Upload: SRM not receiving response due to errors at Pega system moved this to invoke from flow.
****************/
	 @InvocableMethod
	public static void bulkWarrantyUpdateandClone(List<Id> parentCaseIds) {
	Id parentCaseId=parentCaseIds[0];
		List<Case> warrantyUnknownAndQuoteCases = new List<Case>();
		List<String> conditions = new List<String>{'HWS_W_AND_Q_UC_1', 'HWS_W_AND_Q_UC_8','HWS_W_AND_Q_UC_2A','HWS_W_AND_Q_UC_2B'};	
			Boolean warrantyVerificationRequired = false;
		Boolean QuoteRequired = false;
		
		List<Case> updateList=[Select id,parentId,HWS_WarrantyStatus__c,HWS_isQuoteRequired__c,HWS_Contract_Line_Item__c,HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c,Status,CH_EntitlementStatus__c,
		  CH_EntitlementException__c,Cancellation_Reason__c,CH_ReasonForCancellation__c from Case where parentId=:parentCaseId];
		Integer listSize = updateList.size();
		for(Case cs : updateList){
			if(cs.HWS_WarrantyStatus__c == WarrantyUnknown || cs.HWS_isQuoteRequired__c ||cs.CH_EntitlementException__c=='In Warranty - Quotation Required' || cs.CH_EntitlementException__c=='Out of Warranty - Quotation Required'  ){
	if(cs.HWS_WarrantyStatus__c == WarrantyUnknown){
		warrantyVerificationRequired = true;
		QuoteRequired = false;
	}else if(cs.HWS_isQuoteRequired__c || cs.CH_EntitlementException__c=='In Warranty - Quotation Required' || cs.CH_EntitlementException__c=='Out of Warranty - Quotation Required' ){
		QuoteRequired = true;
	}
	warrantyUnknownAndQuoteCases.add(cs);
			}
		}
		Case parentCaseRec = new Case();
		if(warrantyUnknownAndQuoteCases.size()==updateList.size()){
			
			parentCaseRec.Id = parentCaseID;
			if(warrantyVerificationRequired == true){
	parentCaseRec.CH_InternalStatus__c = 'Warranty Verification required';
			}else{
	parentCaseRec.CH_InternalStatus__c ='Quotation Required';
			}
			update parentCaseRec;
			//NOKIASC-35928:calling parent case assignment when data update by SOO user for bulk upload
			passiveAssignmentHWSParentCase(new Set<Id>{parentCaseRec.Id});
		}
		
		if(!warrantyUnknownAndQuoteCases.isEmpty() && warrantyUnknownAndQuoteCases.size()!=listSize){
			System.debug('before Clone');
			cloneCases(parentCaseId);
			System.debug('after Clone');	
		}
	if (parentCaseRec.CH_InternalStatus__c !='Warranty Verification Required' && parentCaseRec.CH_InternalStatus__c !='Quotation Required' )
	{
	String status = [select status from case where id=:parentCaseID].status;
		if(status != 'Closed'){
	makeSOOCallout(parentCaseId);
		}
	}	
		else{
			HWS_EmailNotifications.workgroupEmailAssignment(parentCaseId, 'Pending Order Summary Auto split',null,null);
		}
		
	}	
	/********************
/*Method Name: passiveAssignmentHWSParentCase
*Parameter: CaseList
*Created by :TCS
*Last updated by:
*Description: NOKIASC-35928:calling parent case assignment when data update by SOO user for bulk upload
*User Story: NOKIASC-35928:calling parent case assignment when data update by SOO user for bulk upload
****************/
	public static void passiveAssignmentHWSParentCase(Set<Id> caseLst) { 
		List<Case>   caseList = [SELECT Id, CH_InternalStatus__c,RecordTypeId, RecordType.developername, Status, 
		 CH_GWC_SecurityGroup__c, CH_SecurityGroup__c,CH_Rep_CDBContractType__c,OwnerId,CH_3rdPartySecurityGroup__c		 
		 FROM Case  
		 WHERE Id IN :caseLst];
		HWS_CaseTriggerHelper.passiveAssignmentHWSParentCase(null,caseList);
		
	}
	Public static void createInterfaceLogError(String errorMessage, Integer lineNumber)
	{
		Interface_Log__c ilogcallout = new Interface_Log__c();
		ilogcallout.Interface_Type__c = 'Rest Resource';
		ilogcallout.Message_Type__c = 'Inbound';
		ilogcallout.Operation_Type__c = 'Update';
		ilogcallout.Comment__c = errorMessage + ' and Line number is: '+lineNumber;
		ilogcallout.Status__c = 'Failure';
		ilogcallout.Name = 'SOO Transaction failure';
		Database.insert(ilogcallout,true);
	}
	global class ResponseWarrantyFailure
	{
		public String BulkReferenceid;
		public Integer StatusCode;
		public String FailReason;
		public ResponseWarrantyFailure(String BulkReferenceid, Integer StatusCode, String FailReason){
			this.BulkReferenceid = BulkReferenceid;
			this.StatusCode = StatusCode;
			this.FailReason = FailReason;
		}
	}
	global class WBodyWrapper
	{	@testVisible
		String BulkReferenceid{get; set;}
		@testVisible
		String RequestType{get;set;}
		List<WarrantyWrapper> Requestitems{get;set;}
	}
	global class WarrantyWrapper
	{
		String CustomerNumber {get; set;}
		String ParentRefid {get; set;}
		String ChildRefId {get; set;}
		String SerialNumber {get; set;}
		String MaterialCode {get; set;}
		String SourceSystem {get; set;}
		String WarrantyStatus {get; set;}
		String CaseID {get; set;}   
		public WarrantyWrapper(String CustomerNumber,String ParentRefid,String ChildRefId,String SerialNumber,String MaterialCode,String SourceSystem,String WarrantyStatus,String CaseID)
		{
			this.CustomerNumber=CustomerNumber;
			this.ParentRefid=ParentRefid;
			this.ChildRefId=ChildRefId;
			this.SerialNumber=SerialNumber;
			this.MaterialCode=MaterialCode;
			this.SourceSystem=SourceSystem;
			this.WarrantyStatus=WarrantyStatus;
			this.CaseID=CaseID;
		}
	}
	//NOKIASC-34757
	public static void cloneCases(Id parentCaseId){
		List<Case> warrantyUnknownAndQuoteCases = [Select  Id,CaseNumber, Subject, Status, HWS_Contract_Line_Item__r.HWS_WarrantyVerificationRequired__c,
			   HWS_Contract_Line_Item__r.HWS_QuotationRequiredFlag__c,
			   HWS_Contract_Line_Item__r.HWS_InvoicingType__c,HWS_WarrantyStatus__c, 
			   HWS_Part_Code__c, CH_EntitlementException__c, HWS_Sent_To_SOO__c ,
			   HWS_isQuoteRequired__c,HWS_Faulty_Serial_Number__c,
			   HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c  from Case where ParentId=:parentCaseId AND (HWS_WarrantyStatus__c ='Warranty Unknown' OR HWS_isQuoteRequired__c=True)];
		
		//Nokiasc-36633
		string unknownparentId = HWS_WarrantyQuotation_Controller.cloneCases(parentCaseId, warrantyUnknownAndQuoteCases, 'Pending Order Summary Auto split');
	}
	//NOKIASC-34757
	@future(callout=true)
	public static void makeSOOCallout(Id parentCaseId){
		HWS_Utilty.makeSOOCallout(parentCaseId,'true');
	}
	
	/******
Desription : TO set Default values for  Entitlement Exception and Entitlement Status for cases coming from SOO 
and while creation based on UseCase Condition
Author : Eashwar
*****/
	public static List<Case> setEntitlementDefaultValues(Map<String,String> clItemIdWQConditionMap,List<Case> updateList)
	{
		
		for(Case cs:updateList)
		{
			String contractLineItemCondition = clItemIdWQConditionMap.get(cs.HWS_Contract_Line_Item__c);
			if(cs.HWS_WarrantyStatus__c==HWS_Constants.WS_InWarranty)
			{
	
	if(contractLineItemCondition ==HWS_Constants.UC1 || contractLineItemCondition==HWS_Constants.UC2A || clItemIdWQConditionMap.get(cs.HWS_Contract_Line_Item__c)==HWS_Constants.UC67 || contractLineItemCondition==HWS_Constants.UC8 || contractLineItemCondition==HWS_Constants.UC9 || contractLineItemCondition==HWS_Constants.UC3 )
	{
		cs.CH_EntitlementException__c=HWS_Constants.WS_InWarranty;
		cs.CH_EntitlementStatus__c=HWS_Constants.Entitled_AV;
		cs.Status = HWS_Constants.caseStatusDraft;
		
	}
	else if(contractLineItemCondition==HWS_Constants.UC2B || contractLineItemCondition==HWS_Constants.UC4 || contractLineItemCondition==HWS_Constants.UC5 )
	{
		cs.CH_EntitlementException__c=HWS_Constants.IW_QuotRequired;
		cs.CH_EntitlementStatus__c=HWS_Constants.PendingQuotCreation;
		cs.Status = HWS_Constants.caseStatusOnHold;
	}
			}
			else if(cs.HWS_WarrantyStatus__c==HWS_Constants.OUT_OF_WARRANTY)
			{
	if(contractLineItemCondition==HWS_Constants.UC1 || contractLineItemCondition==HWS_Constants.UC2A ||  contractLineItemCondition==HWS_Constants.UC8 || contractLineItemCondition==HWS_Constants.UC2B )
	{
		cs.CH_EntitlementException__c=HWS_Constants.OUT_OF_WARRANTY;
		cs.CH_EntitlementStatus__c=HWS_Constants.Service_Declined;
		if(cs.Status!=HWS_Constants.caseStatusCancel)
		{
			cs.Status = HWS_Constants.caseStatusDraft;
		}
		if( fromBulk==true)
		{
			cs.Status = HWS_Constants.caseStatusCancel;
		}
		
	}
	else if(contractLineItemCondition==HWS_Constants.UC67 || contractLineItemCondition==HWS_Constants.UC9 )
	{
		cs.CH_EntitlementException__c=HWS_Constants.OUT_OF_WARRANTY;
		cs.CH_EntitlementStatus__c=HWS_Constants.Entitled_AV;
		cs.Status = HWS_Constants.caseStatusDraft;
	}
	
	else if(contractLineItemCondition==HWS_Constants.UC3 || contractLineItemCondition==HWS_Constants.UC4 || contractLineItemCondition==HWS_Constants.UC5 )
	{
		cs.CH_EntitlementException__c=HWS_Constants.OOW_QuotRequired;
		cs.CH_EntitlementStatus__c=HWS_Constants.PendingQuotCreation;
		cs.Status = HWS_Constants.caseStatusOnHold;
	}
	
			}
			else if(cs.HWS_WarrantyStatus__c==HWS_Constants.WS_UKWarranty)
			{
	cs.CH_EntitlementException__c=HWS_Constants.UWStatus;
	cs.CH_EntitlementStatus__c=HWS_Constants.PendingWarrantyVerification;
	cs.Status = HWS_Constants.caseStatusOnHold;
			}
			else if(cs.HWS_WarrantyStatus__c==HWS_Constants.WS_FailDWarranty)
			{
	cs.CH_EntitlementException__c=HWS_Constants.WStatusCheckFailed;
	cs.CH_EntitlementStatus__c=HWS_Constants.PendingWarrantyVerification;
	cs.Status = HWS_Constants.caseStatusOnHold;
			}
			//NOKIASC-34637 - Added by Ajesh
			if(cs.CH_EntitlementException__c==HWS_Constants.WStatusCheckFailed){
	cs.HWS_WarrantyStatus__c=HWS_Constants.WS_UKWarranty;
			}
			
		}
		if(!updateList.isEmpty())
		{
			return updateList;
		}
		return null;
	}
}