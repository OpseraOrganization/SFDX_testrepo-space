/*************************************************************
@Name: APTSCU_PreviewApprovalsController
@Author:  Jigar Naik
@CreateDate: 21 Feb 2016
@Description: Controller class for custom approvals pages.
******************************************************************/
public inherited sharing class APTSCU_PreviewApprovalsController{

	public String sObjectType {get; set;}
	public ID sObjectId {get; set;}
	public String sObjectFieldSetJSON {get; set;}
	public String sObjectDataJSON {get; set;}
	public String previewApprovalsJSON{get;set;}
	public String approvalHeaderInformation{get;set;}
	public String approvalColumnsFieldSetJSON {get; set;}
	public String approvalReqWrapperListJSON {get;set;}
	public String submittionComments {get;set;}
	public Boolean onlyPreview {get;set;}
	public Boolean isCancelled {get;set;}
	private Set<String> approvalFieldSet = null;
	public String reasonsRequired{get;set;}
	@TestVisible private String currentApprovalStatus = null;
	Public static Map<String,Apttus_Approval__Approval_Process__c> approvalsStepMap = new Map<String,Apttus_Approval__Approval_Process__c>();
	Public static Map<String,List<Apttus_Approval__Approval_Process__c>> approvalsEntryMap = new Map<String,List<Apttus_Approval__Approval_Process__c>>();

	public string psrLoAlevel ;
	public Opportunity optyObjRecord{get;set;}
	public Date gate6PlannedDate{get;set;}
	public Boolean showProbability{get;set;}
	public Boolean showReasons{get;set;}
	public Boolean showGate6Fields{get;set;}
	public String previewmessage{get;set;}
	public Boolean ispreviewmessage {get;set;}
	public Boolean loaupdated {get;set;}
	public static boolean flagForUpsellOppty = true;

	public static String noApprovals = 'No approval Records available';

	public APTSCU_PreviewApprovalsController() {
		String unescappedId = ApexPages.currentPage().getParameters().get('sObjectId');
		sObjectId = unescappedId;
		sObjectType st=sObjectId.getSObjectType();
		sObjectType=String.valueOf(st);
		psrLoAlevel =	ApexPages.currentPage().getParameters().get('psrLoAlevel');
		currentApprovalStatus = '';
		approvalFieldSet = new Set<String>();
		onlyPreview = false;
		isCancelled = false;
		ispreviewmessage=false;
		loAupdated = false;
	}

	public void previewApprovals(){
		queryApprovalHeaderInformation();
		queryApprovalColumnsFieldSet();
		try{
			if(currentApprovalStatus == 'Approval Required' || currentApprovalStatus == 'Not Submitted'){
	Apttus_Approval.ApprovalsWebService.previewApprovals(sObjectType,sObjectId);
			}else if(currentApprovalStatus == 'Pending Approval'){
	onlyPreview = true;
			}else if(currentApprovalStatus == 'Cancelled'){
	onlyPreview = true;
	isCancelled = true;
			}else{
	previewApprovalsJSON = JSON.serialize(noApprovals);
	approvalReqWrapperListJSON = JSON.serialize(noApprovals);
	return;
			}
			List<ApprovalRequestWrapperClass> approvalReqWrapperList = new List<ApprovalRequestWrapperClass>();

			String soqlQuery = getAllFieldsSOQL('Apttus_Approval__Approval_Request__c','Apttus_Approval__Object_Id__c = :sObjectId And Apttus_Approval__Object_Type__c = :sObjectType AND Apttus_Approval__Assigned_To_Id__c!= null order by Name');
			System.debug('soqlQuery :'+soqlQuery);
			List<Apttus_Approval__Approval_Request__c> approvalRequestList = (List<Apttus_Approval__Approval_Request__c>)Database.query(soqlQuery);
			System.debug('approvalRequestList'+approvalRequestList);
			ApprovalRequestWrapperClass  approvalReqWrapper;
			List<string> approvalReqData;

			for(Apttus_Approval__Approval_Request__c approveReq :approvalRequestList ) {
	submittionComments = approveReq.Apttus_Approval__SubmissionComment1__c;
	approvalReqData = new List<string>();
	if(approveReq.Apttus_Approval__Approval_Process__c<>null && approveReq.Apttus_Approval__Step_Name__c<>NUll )
		approvalReqData = saveApprovalDisplayInformation(approveReq.Apttus_Approval__Approval_Process__c, approveReq.Apttus_Approval__Step_Name__c);
	System.debug('Approval Submittion Data ======>'+approvalReqData);
	if(approvalReqData.size()>0 ) {
		approvalReqWrapper = new ApprovalRequestWrapperClass (approveReq,approvalReqData[0],approvalReqData[1]);
	} else {
		approvalReqWrapper = new ApprovalRequestWrapperClass (approveReq,null,null);
	}
	approvalReqWrapperList.add(approvalReqWrapper);
			}

			System.debug('-->approvalReqWrapperList'+approvalReqWrapperList.get(0));
			previewApprovalsJSON=JSON.serialize(approvalRequestList);
			approvalReqWrapperListJSON = JSON.serialize(sortRecords(approvalReqWrapperList));

		}catch(Exception exp){
			system.debug('############# Message' + exp.getMessage());
			previewApprovalsJSON=  JSON.serialize(exp.getMessage());
			approvalReqWrapperListJSON = JSON.serialize(noApprovals);
		}
	}

	@RemoteAction
	public static String submitForApprovals(String sObjectType,String sObjectId){
		Savepoint sp = null;
		try{
			sp = Database.setSavepoint();
			Apttus_Approval.ApprovalsWebService.submitForApprovals(sObjectType, sObjectId);
			validateUpsellOppty(sObjectId);
			return 'Success';
		}catch(Exception exp){
			if(sp != null) Database.rollback(sp);
			Return exp.getMessage();
		}
	}

	@RemoteAction
	public static String addComments(String sObjectType,String sObjectId,String comments){
		try{
			updateCommentsApprovalRequests(sObjectType,sObjectId, comments);
			return 'success';
		}catch(Exception exp){
			return exp.getMessage();
		}
	}

	@future(callout=true)
	public static void updateCommentsApprovalRequests(String sObjectType,String sObjectId,String comments){
		try{
			String soqlQuery = 'Select id,Name,Apttus_Approval__SubmissionComment1__c from Apttus_Approval__Approval_Request__c where Apttus_Approval__Object_Id__c = :sObjectId And Apttus_Approval__Object_Type__c = :sObjectType AND Apttus_Approval__Assigned_To_Id__c!= null order by Name';
			List<Apttus_Approval__Approval_Request__c> approvalRequestList = (List<Apttus_Approval__Approval_Request__c>)Database.query(soqlQuery);
			System.debug('approvalRequestList'+approvalRequestList);
			for(Apttus_Approval__Approval_Request__c apprvalReq : approvalRequestList ) {
	apprvalReq.Apttus_Approval__SubmissionComment1__c = comments;
			}
			update approvalRequestList;
		}catch(Exception exp){
			System.debug(exp.getMessage());
		}
	}

	@RemoteAction
	public static String cancelApprovals(String sObjectType,String sObjectId, String comments){
		Savepoint sp = null;
		try{
			List<Apttus_Approval__Approval_Request__c> remupdate= new  List<Apttus_Approval__Approval_Request__c>();
			sp = Database.setSavepoint();
			Opportunity oppty = new Opportunity(id=sObjectId );
			oppty.Approval_Cancel_Info__c =comments;
			oppty.Is_Automated__c=True;
			update oppty;

			//update the Stakeholders Status
			for(Apttus_Approval__Approval_Request__c Appupdate:[Select id,Apttus_Approval__Notify_Only__c,Apttus_Approval__Object_Id__c,Apttus_Approval__DelegateApproverIds__c,Apttus_Approval__Assigned_To_Id__c,NF_Assignee_Type__c,Apttus_Approval__Approval_Status__c  from Apttus_Approval__Approval_Request__c where Apttus_Approval__Object_Id__c=:sObjectId and NF_Assignee_Type__c<>Null  ])
			{
	// Collecting the StakeHodler Records and updating the stakeholder status.
	if(Appupdate.NF_Assignee_Type__c<>Null&&(Appupdate.NF_Assignee_Type__c.Contains(GlobalConstants.VALIDATOR)||Appupdate.NF_Assignee_Type__c.Contains(GlobalConstants.STAKEHOLDER_INFORMATION)))
	{
		System.debug('### Inside Loop Assignee type'+Appupdate.NF_Assignee_Type__c);
		Appupdate.Apttus_Approval__Approval_Status__c =GlobalConstants.CANCEL;
		Appupdate.Apttus_Approval__Notify_Only__c = true;
		remupdate.add(Appupdate);
	}
			}

			if(!remupdate.isEmpty())
	Database.update(remupdate,False);

			Apttus_Approval.ApprovalsWebService.cancelApprovals(sObjectType, sObjectId);
			return 'success';
		}catch(Exception exp){
			System.debug('Calcel exp'+exp);
			if(sp != null) Database.rollback(sp);
			return exp.getMessage();
		}
	}

	@RemoteAction
	public static String updateOpportunity( Opportunity oppty){
		try{
			System.debug(oppty);
			update oppty;
			return GlobalConstants.RETURN_SUCCESS;
		}catch(Exception exp){
			ExceptionHandler.addException(exp,GlobalConstants.PRVIEW_APPROVAL_CONTROLLER,'updateOpportunity');
			return exp.getMessage();
		}
	}
	@RemoteAction
	public static String updateG6PlannedDate( String sObjectId , String gate6PlannedDate){
		try{
			updateG6PlannedDateFuture(sObjectId, gate6PlannedDate);
			return GlobalConstants.RETURN_SUCCESS;
		}catch(Exception exp){
			return exp.getMessage();
		}
	}
	@future(callout=true)
	public static void updateG6PlannedDateFuture( String sObjectId , String gate6PlannedDate){
		try{
			System.debug(gate6PlannedDate);
			if(gate6PlannedDate != null){
	Opportunity oppty = new Opportunity(Id=sObjectId, G6_Planned_Date__c = Date.valueOf(gate6PlannedDate) );
	update oppty;
			}
		}catch(Exception exp){
			System.debug(exp.getMessage());
		}
	}

	public void queryApprovalHeaderInformation(){
		List<Schema.FieldSetMember> fields = Schema.getGlobalDescribe().get(sObjectType).getDescribe().fieldSets.getMap().get('APTSCU_Approval_Header_Fields').getFields();

		Map<String,String> fldVsLabelMap = new Map<String,String>();
		for(Schema.FieldSetMember fld : fields){
			fldVsLabelMap.put(fld.getFieldPath(),fld.getLabel());
		}

		String soqlQuery = getAllFieldsSOQL(sObjectType,'Id = :sObjectId');
		SObject sObjectData = Database.query(soqlQuery);

		for(String approvalField : approvalFieldSet){
			if(sObjectData.get(approvalField) != null && sObjectData.get(approvalField) != ''){
	currentApprovalStatus = (String)sObjectData.get(approvalField);
			}
		}

		sObjectFieldSetJSON = JSON.serialize(fldVsLabelMap);
		sObjectDataJSON = JSON.serialize(sObjectData);

	}

	public void queryApprovalColumnsFieldSet(){
		List<Schema.FieldSetMember> fields = Schema.getGlobalDescribe().get('Apttus_Approval__Approval_Request__c').getDescribe().fieldSets.getMap().get('APTSCU_Preview_Approval_Columns').getFields();

		Map<String,String> fldVsLabelMap = new Map<String,String>();
		for(Schema.FieldSetMember fld : fields){
			System.debug('--->fld.getLabel()'+fld.getFieldPath()+fld.getLabel());
			fldVsLabelMap.put(fld.getFieldPath(),fld.getLabel());
		}
		approvalColumnsFieldSetJSON = JSON.serialize(fldVsLabelMap);

	}

	private String getAllFieldsSOQL(String objectName, String whereClause){

		String selects = '';

		if (whereClause == null || whereClause == ''){ return null; }

		// Get a map of field name and field token
		Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
		list<string> selectFields = new list<string>();

		if (fMap != null){
			for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
	Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
	selectFields.add(fd.getName());
	if(fd.getName().containsIgnoreCase('Approval_Status__c')){
		approvalFieldSet.add(fd.getName());
	}
			}
		}

		if (!selectFields.isEmpty()){
			selects = String.join(selectFields, ',');
		}

		return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;

	}

	public List<string> saveApprovalDisplayInformation(Id processId,string currentStepName){

		System.debug('processId currentStepName'+currentStepName+processId);
		Apttus_Approval__Approval_Process__c approvalStep;
		List<Apttus_Approval__Approval_Process__c> entryCriteriaList = new List<Apttus_Approval__Approval_Process__c>();

		// compare the data to approvalStep Map stop the SOQL execution into next time
		if(approvalsStepMap.get(currentStepName)<>Null)
			approvalStep=approvalsStepMap.get(currentStepName);
		else
			approvalStep = [Select Id, Apttus_Approval__StepDisplayFieldNameHeader__c, Apttus_Approval__StepDisplayFieldNames__c From Apttus_Approval__Approval_Process__c Where Apttus_Approval__Step__r.Apttus_Approval__Step_Group__c = :processId And Apttus_Approval__Step_Name__c = :currentStepName];

		// storing the data into map to reduce the SOQL execution
		if(approvalStep<>NUll)
			approvalsStepMap.put(currentStepName,approvalStep);

		// compare the data to approvalsEntryMap stop the SOQL execution into next time
		if(approvalsEntryMap.get(currentStepName)<>NUll)
			entryCriteriaList=approvalsEntryMap.get(currentStepName);
		else
			entryCriteriaList = [Select Id, Apttus_Approval__Step_Filter_Field__c, Apttus_Approval__Step_Filter_Comparison_Type__c, Apttus_Approval__Step_Filter_Field_Value__c, Apttus_Approval__Step_Filter_BoolOper__c From Apttus_Approval__Approval_Process__c Where Apttus_Approval__Step_Filter__r.Apttus_Approval__Step__r.Apttus_Approval__Step_Group__c = :processId And Apttus_Approval__Step_Filter__r.Apttus_Approval__Step_Name__c = :currentStepName];

		// storing the data into map to reduce the SOQL execution
		if(entryCriteriaList<>NUll)
			approvalsEntryMap.put(currentStepName,entryCriteriaList);

		Set<String> displayFields = new Set<String>();
		if(approvalStep.Apttus_Approval__StepDisplayFieldNameHeader__c != '' && approvalStep.Apttus_Approval__StepDisplayFieldNameHeader__c != null){
			displayFields.add(approvalStep.Apttus_Approval__StepDisplayFieldNameHeader__c.toLowerCase());
		}

		if(approvalStep.Apttus_Approval__StepDisplayFieldNames__c != '' && approvalStep.Apttus_Approval__StepDisplayFieldNames__c != null){
			String[] displayFieldsArray = approvalStep.Apttus_Approval__StepDisplayFieldNames__c.split(',');

			for(String displayField : displayFieldsArray){
	displayFields.add(displayField.toLowerCase());
			}
		}

		if(displayFields.isEmpty()){
			displayFields.add('name');
		}

		Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(sObjectType).getDescribe().fields.getMap();

		Map<String,String> fldVsLabelMap = new Map<String,String>();
		Map<String,String> fldVsLabelMapAll = new Map<String,String>();
		for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
			Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
			if(displayFields.contains(fd.getName().toLowerCase())){
	fldVsLabelMap.put(fd.getName(), fd.getLabel());
			}
			fldVsLabelMapAll.put(fd.getName(), fd.getLabel());
		}
		String stepEntryCriteria;
		for(Integer index = 0; index < entryCriteriaList.size(); index++){
			Apttus_Approval__Approval_Process__c entryCriteria = entryCriteriaList[index];
			stepEntryCriteria = '(' + fldVsLabelMapAll.get(entryCriteria.Apttus_Approval__Step_Filter_Field__c) + getOperator(entryCriteria.Apttus_Approval__Step_Filter_Comparison_Type__c) + entryCriteria.Apttus_Approval__Step_Filter_Field_Value__c + ')';
			if(index < entryCriteriaList.size() - 1){
	stepEntryCriteria += ' ' + entryCriteria.Apttus_Approval__Step_Filter_BoolOper__c + ' ';
			}
		}

		List<string> approvalStepData = new List<string>();
		approvalStepData.add(stepEntryCriteria);
		approvalStepData.add(JSON.serialize(fldVsLabelMap));
		return approvalStepData;
	}

	@TestVisible
	private String getOperator(String compareOperator){
		if (compareOperator == 'equal to') {
			return ' = ';
		} else if (compareOperator == 'not equal to') {
			return ' != ';
		} else if (compareOperator == 'less than') {
			return ' < ';
		} else if (compareOperator == 'greater than') {
			return ' > ';
		} else if (compareOperator == 'less than or equal to') {
			return ' <= ';
		} else if (compareOperator == 'greater than or equal to') {
			return ' >= ';
		} else if(compareOperator =='starts with' || compareOperator =='contains' ) {
			return ' LIKE ';
		} else if(compareOperator =='in') {
			return ' IN ';
		} else if(compareOperator =='not in') {
			return ' NOT IN ';
		}

		return '';
	}

	public class ApprovalRequestWrapperClass {
		public Apttus_Approval__Approval_Request__c approvalReq{get; set;}
		public String stepEntryCriteria{get; set;}
		public String sObjectDisplayFieldsJSON {get; set;}
		public boolean showHeaderInfo;
		public ApprovalRequestWrapperClass (Apttus_Approval__Approval_Request__c appreq, string stepCriteria, string fieldjson){
			approvalReq = appreq;
			stepEntryCriteria = stepCriteria;
			sObjectDisplayFieldsJSON = fieldjson;
			showHeaderInfo = false;
		}
	}

	/****************************************
*Method Name: getDisplayFields()
*Description:  These method used for rerendering of page
*Parameters:
*Req No:2382
*****************************************/
	public boolean getDisplayFields(){
		showProbability = false;
		showReasons = false;
		showGate6Fields = false;
		String label_Amount = System.Label.Unweighted_Amount_For_Sales_Outcome;
		Set<String> loaBypassSet = new Set<String>(System.label.LoA_Bypass_Offer_Condition.Split(GlobalConstants.COMMA));
		loaBypassSet.remove(GlobalConstants.BLANK_VALUE);

		try{
			Opportunity oppty = [ SELECT Id,Name,Phase_Status__c,StageName,RecordTypeId , Amount,
		 Gate_3_Bypass_no_offer_support__c,Probability, Unweighted_Amount_EUR__c,Likelyhood_to_Win__c,
		 Third_Reason__c, Sales_Outcome_Reason__c,Second_Reason__c, LoA_Level__c,
		 NF_LoA_Bypass__c,Blanket_Approval_Condition__c,G6_Planned_Date__c, Gate_6_Bypass_No_Execute_needed__c,
		 (SELECT Id, LOA_Bypass__c FROM Offers__r Where ActiveOffer__c = True)
		 FROM Opportunity WHERE id = :sObjectId ];

			if(oppty == null) return false;

			Offer__c offerRec = oppty.Offers__r.size() > 0 ? oppty.Offers__r[0] : null;

			if( (oppty.StageName==GlobalConstants.IDENTIFY_OPPORTUNITY && oppty.Phase_Status__c==GlobalConstants.PLANNED) ||
	  (oppty.StageName==GlobalConstants.DEVELOP_OPPORTUNITY  && oppty.Phase_Status__c==GlobalConstants.OPPORTUNITY_IN_PROGRESS && oppty.Gate_3_Bypass_no_offer_support__c ) ){
	showProbability=true;
			}

			showwarningmessage(oppty);

			if( oppty.StageName==GlobalConstants.WIN_THE_CASE_OPPORTUNITY_STAGE && oppty.Blanket_Approval_Condition__c == null &&
	  (oppty.Phase_Status__c == GlobalConstants.PENDING_WIN_LOSS_DECLARATION || oppty.NF_LoA_Bypass__c>0  ) &&
	  oppty.Amount >= Decimal.valueOf(label_Amount) && (offerRec == null || !loaBypassSet.contains(offerRec.LOA_Bypass__c) ) ){
	   showReasons = true;
	   reasonsRequired = System.Label.Three_Reasons_Required;
	  }


			if( oppty.StageName==GlobalConstants.WIN_THE_CASE_NEGOTIATE &&
			   ( ( oppty.Blanket_Approval_Condition__c == null && oppty.NF_LoA_Bypass__c==0 && oppty.Phase_Status__c == GlobalConstants.PENDING_WIN_LOSS_DECLARATION ) ||
				( oppty.NF_LoA_Bypass__c>0  && oppty.Phase_Status__c == GlobalConstants.OFFER_SUBMITTED_TO_CUSTOMER_MANUAL ) ) ){
					gate6PlannedDate = oppty.G6_Planned_Date__c;
					if( oppty.G6_Planned_Date__c < System.Today()){
						gate6PlannedDate = System.Today()+30;
						oppty.G6_Planned_Date__c = gate6PlannedDate;
					}
					if( oppty.Gate_6_Bypass_No_Execute_needed__c )
						gate6PlannedDate = System.Today();
					showGate6Fields = true;
				}

			optyObjRecord = oppty;

			return true;

		}catch(Exception ex){
			ExceptionHandler.addException(ex,GlobalConstants.PRVIEW_APPROVAL_CONTROLLER,'getDisplayFields');
			return false;
		}
	}


	@future(callout=true)
	public Static Void validateUpsellOppty(String sObjectId){
		Savepoint sp = null;
		Try{
			Opportunity oppty = [SELECT Id,ApprovalStatusTechField__c,Submission_Comments__c,LOA_Level__c,Phase_Status__c,NF_LoA_Bypass__c,Blanket_Approval_Condition__c,
		 Sales_Outcome__c,Apttus_Approval__Approval_Status__c,StageName,
		 (SELECT Id,LoA_Approval_Level__c,ActiveOffer__c FROM Offers__r WHERE ActiveOffer__c = true)
		 FROM Opportunity WHERE Id=:sObjectId];

			if(oppty == null) return;
			Offer__c offerObj = oppty.Offers__r.size()>0 ? oppty.Offers__r[0] : null;

			sp = Database.setSavepoint();

			if(flagForUpsellOppty && offerObj!= null && offerObj.LoA_Approval_Level__c =='E' && oppty.StageName.equalsignorecase(GlobalConstants.HANDOVER_OPPTY)) {
	UpsellOppUtility.toCreateUpsellOpportunity(new Set<Id>{sObjectId});
	flagForUpsellOppty = false;
			}
		}
		catch(Exception e)
		{
			if(sp != null) Database.rollback(sp);
			system.debug('Exception On validateUpsellOppty>>>>'+e.getMessage());
		}
	}


	public void showwarningmessage(Opportunity opp){
		try{
			previewmessage = JSON.serialize('Please wait until your request is completely processed. Do not close the page or interrupt the approval submission.');
			ispreviewmessage = false;
			if( opp.StageName.equalsignorecase(GlobalConstants.WIN_THE_CASE_NEGOTIATE ) && ( opp.Phase_Status__c.equalsignorecase(GlobalConstants.PENDING_WIN_LOSS_DECLARATION ) ||
			( !opp.Phase_Status__c.equalsignorecase(GlobalConstants.PENDING_WIN_LOSS_DECLARATION  ) && opp.NF_LoA_Bypass__c>0 && opp.Blanket_Approval_Condition__c==null ) ))
	ispreviewmessage=true;

			if(psrLoAlevel != null && psrLoAlevel != '')
			{
	loaupdated = true;
	previewmessage=JSON.serialize('LoA level is set to - '+psrLoAlevel+ '. Please review the gate participants before submitting for approval');
			}

		}catch(Exception ex){
			ExceptionHandler.addException(ex,GlobalConstants.PRVIEW_APPROVAL_CONTROLLER,'showwarningmessage');
		}
	}

	/****************************************
*Method Name: SortRecords
*Description:  Sort the records with the sequence i.e Approver,Validator and Stakeholder
*Parameters: List of ApprovalRequestWrapperClass and return the sort order
*****************************************/
	Public  List<ApprovalRequestWrapperClass> sortRecords(  List<ApprovalRequestWrapperClass> records) {
		List<ApprovalRequestWrapperClass> afterSort =new List<ApprovalRequestWrapperClass>();
		List<ApprovalRequestWrapperClass> approvers =new List<ApprovalRequestWrapperClass>();
		List<ApprovalRequestWrapperClass> validators =new List<ApprovalRequestWrapperClass>();
		List<ApprovalRequestWrapperClass> stakeholders =new List<ApprovalRequestWrapperClass>();
		List<ApprovalRequestWrapperClass> others  =new List<ApprovalRequestWrapperClass>();

		for(ApprovalRequestWrapperClass data:records) {
			if(GlobalConstants.APPROVER.equalsignorecase(data.approvalReq.NF_Assignee_Type__c) )
			{
	approvers.add(data);
			}
			else if( GlobalConstants.VALIDATOR.equalsignorecase(  data.approvalReq.NF_Assignee_Type__c) )
			{
	validators.add(data);
			}
			else if(  GlobalConstants.STAKEHOLDER_INFORMATION.equalsignorecase( data.approvalReq.NF_Assignee_Type__c) )
			{
	stakeholders.add(data);
			}
			else if( data.approvalReq.NF_Assignee_Type__c == NUll){
	others.add(data);
			}
		}
		afterSort.addAll(approvers);
		afterSort.addAll(validators);
		afterSort.addAll(stakeholders);
		afterSort.addAll(others);
		return afterSort ;
	}

}