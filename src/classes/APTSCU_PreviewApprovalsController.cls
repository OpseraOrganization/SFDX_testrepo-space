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
	Public static Map<String,Apttus_Approval__Approval_Process__c> ApprovalsStepMap = new Map<String,Apttus_Approval__Approval_Process__c>();
	Public static Map<String,List<Apttus_Approval__Approval_Process__c>> ApprovalsEntryMap = new Map<String,List<Apttus_Approval__Approval_Process__c>>();
	public static Id directRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
	public static Id inDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.Indirect_Record_Type).getRecordTypeId();

	public string PSRLoAlevel ;
	public boolean isDisplay;
	public boolean isAmountGreater;
	public String firstReason{get;set;}
	public String secondReason{get;set;}
	public boolean isDisplayProbability;
	public Integer probabilityPercentage{get;set;}
	public Opportunity optyObj{get;set;}
	public Opportunity optyObjRecord{get;set;}
	public String Previewmessage{get;set;}
	public Boolean ispreviewmessage {get;set;}
	public Boolean loaupdated {get;set;}
	public static boolean flagForUpsellOppty = true;

	public static String noApprovals = 'No approval Records available';

	public APTSCU_PreviewApprovalsController() {
		String unescappedId = ApexPages.currentPage().getParameters().get('sObjectId');
		sObjectId = unescappedId;
		sObjectType st=sObjectId.getSObjectType();
		sObjectType=String.valueOf(st);
		PSRLoAlevel =	ApexPages.currentPage().getParameters().get('PSRLoAlevel');
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

			System.debug('#### approvalRequestList Size'+approvalRequestList.size() );

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
	public static String submitForApprovals(String sObjectType,String sObjectId,String comments){
		System.debug('Commnets ---->'+comments);
		Opportunity opptyinfo;
		Savepoint sp = null;
		try{
			sp = Database.setSavepoint();
			// Updating the Submission Comments and used in G2 Completion Template
			opptyinfo = [Select Id,RecordTypeId,Name,Gate_3_Bypass_no_offer_support__c,NF_Facilitator_Notified__c,ApprovalStatusTechField__c,Submission_Comments__c,Phase_Status__c,Sales_Outcome__c,Apttus_Approval__Approval_Status__c,StageName from Opportunity where id=:sObjectId];
			// SDC modification and added the bypass condition
			if(opptyinfo!=null && opptyinfo.RecordTypeId!=null && !opptyinfo.Gate_3_Bypass_no_offer_support__c && (opptyinfo.RecordTypeId.equals(directRecordTypeId) || opptyinfo.RecordTypeId.equals(inDirectRecordTypeId)) && !opptyinfo.NF_Facilitator_Notified__c && opptyinfo.StageName == GlobalConstants.DEVELOP_OPPORTUNITY ){
	return Label.NF_OnlyFacilitatorCanSubmit;
			}else{
	Apttus_Approval.ApprovalsWebService.submitForApprovals(sObjectType, sObjectId);
	updatePhaseStatus(sObjectId,comments);
	return 'Success';
			}
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
			for (string s:selectFields){
	selects += s + ',';
			}
			if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}
		}

		return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;

	}

	public List<string> saveApprovalDisplayInformation(Id processId,string currentStepName){

		System.debug('processId currentStepName'+currentStepName+processId);
		Apttus_Approval__Approval_Process__c approvalStep;
		List<Apttus_Approval__Approval_Process__c> entryCriteriaList = new List<Apttus_Approval__Approval_Process__c>();

		// compare the data to approvalStep Map stop the SOQL execution into next time
		if(ApprovalsStepMap.get(currentStepName)<>Null)
		approvalStep=ApprovalsStepMap.get(currentStepName);
		else
		approvalStep = [Select Id, Apttus_Approval__StepDisplayFieldNameHeader__c, Apttus_Approval__StepDisplayFieldNames__c From Apttus_Approval__Approval_Process__c Where Apttus_Approval__Step__r.Apttus_Approval__Step_Group__c = :processId And Apttus_Approval__Step_Name__c = :currentStepName];

		// storing the data into map to reduce the SOQL execution
		if(approvalStep<>NUll)
		ApprovalsStepMap.put(currentStepName,approvalStep);

		// compare the data to ApprovalsEntryMap stop the SOQL execution into next time
		if(ApprovalsEntryMap.get(currentStepName)<>NUll)
		entryCriteriaList=ApprovalsEntryMap.get(currentStepName);
		else
		entryCriteriaList = [Select Id, Apttus_Approval__Step_Filter_Field__c, Apttus_Approval__Step_Filter_Comparison_Type__c, Apttus_Approval__Step_Filter_Field_Value__c, Apttus_Approval__Step_Filter_BoolOper__c From Apttus_Approval__Approval_Process__c Where Apttus_Approval__Step_Filter__r.Apttus_Approval__Step__r.Apttus_Approval__Step_Group__c = :processId And Apttus_Approval__Step_Filter__r.Apttus_Approval__Step_Name__c = :currentStepName];

		// storing the data into map to reduce the SOQL execution
		if(entryCriteriaList<>NUll)
		ApprovalsEntryMap.put(currentStepName,entryCriteriaList);

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
	*Method Name: getDisplaySalesoutcomReason()
	*Description:  These method used for rerendering of page
	*Parameters:
	*Req No:2382
	*****************************************/
	public boolean getDisplaySalesoutcomReason(){
		Id opptyDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
		Id opptyIndirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.Indirect_Record_Type).getRecordTypeId();
		isDisplay=false;
		String label_Amount = System.Label.Unweighted_Amount_For_Sales_Outcome;
		List<String> loaBypassList=System.label.LoA_Bypass_Offer_Condition.Split(GlobalConstants.COMMA);
		set<String> loaBypassSet = new set<String>();
		loaBypassSet.addAll(loaBypassList);
		loaBypassSet.remove(GlobalConstants.BLANK_VALUE);

		try{
			Opportunity oppty = [SELECT id,Name,Description,Phase_Status__c,Third_Reason__c, Sales_Outcome_Reason__c,Second_Reason__c,LOA_Level__c,StageName,RecordTypeId,
			Amount,count_offer__c,NF_LoA_Bypass__c,Blanket_Approval_Condition__c,Apttus_Approval__Approval_Status__c FROM Opportunity WHERE id = :sObjectId];

			showwarningmessage(oppty);

			if( (oppty.RecordTypeId==opptyDirectRecordTypeId || oppty.RecordTypeId==opptyIndirectRecordTypeId) && oppty.StageName==GlobalConstants.WIN_THE_CASE_OPPORTUNITY_STAGE &&
	oppty.Blanket_Approval_Condition__c == null &&
	(oppty.Phase_Status__c == GlobalConstants.PENDING_WIN_LOSS_DECLARATION ||oppty.LOA_Level__c=='E' || oppty.NF_LoA_Bypass__c>0  ) &&
	oppty.Amount >= Decimal.valueOf(label_Amount)){

	Offer__c offerRec = [SELECT id, ActiveOffer__c, Opportunity__c, LOA_Bypass__c FROM Offer__c	WHERE Opportunity__c =:sObjectId  AND ActiveOffer__c = True LIMIT: 1];

	if( (oppty.count_offer__c > 0 && offerRec!= Null && (!loaBypassSet.contains(offerRec.LOA_Bypass__c))) || (oppty.count_offer__c == 0) ){
		isDisplay=true;
		optyObjRecord=oppty;
	}
			}
			return isDisplay;

		}catch(Exception ex){
			ExceptionHandler.addException(ex,GlobalConstants.PRVIEW_APPROVAL_CONTROLLER,GlobalConstants.DISPLAY_SALES_OUTCOMEREASON);
			return false;
		}
	}


	@RemoteAction
	/****************************************
	*Method Name: updateOpportunityReasons
	*Description: Update the sales outcome reason
	*Parameters: String sObjectType,String sObjectId,String firstReason ,String secondReason,String thirdReason
	*Req No:2382
	*****************************************/
	public static String updateOpportunityReasons(String sObjectType,String sObjectId,String firstReason ,String secondReason,String thirdReason){

		System.debug('-------->firstReason '+firstReason );
		System.debug('-------->secondReason'+secondReason);
		System.debug('-------->thirdReason'+thirdReason);
		try{

			Opportunity oppObj = new Opportunity();
			oppObj.Id = sObjectId;

			if(firstReason != GlobalConstants.NONE && String.isNotBlank(firstReason) && !firstReason.contains(GlobalConstants.Remove_Unwanted_Value)){
	oppObj.Sales_Outcome_Reason__c =firstReason;
			}
			if(secondReason != GlobalConstants.NONE && String.isNotBlank(secondReason) && !secondReason.contains(GlobalConstants.Remove_Unwanted_Value)){
	oppObj.Second_Reason__c=secondReason;
			}
			if(thirdReason != GlobalConstants.NONE && String.isNotBlank(thirdReason) && !thirdReason.contains(GlobalConstants.Remove_Unwanted_Value)){
	oppObj.Third_Reason__c=thirdReason;
			}
			oppObj.Sales_Outcome__c = GlobalConstants.WON_REQUESTED;
			update oppObj;

			return GlobalConstants.RETURN_SUCCESS;

		}catch(Exception exp){

			ExceptionHandler.addException(exp,GlobalConstants.PRVIEW_APPROVAL_CONTROLLER,GlobalConstants.UPDATE_SALES_OUTCOME_REASON);
			return exp.getMessage();
		}
	}


	/****************************************
	*Method Name: getDisplayProbability
	*Description:These method used for rerendering of page for displaying probability for G2 and G3
	*Parameters:2382
	*****************************************/
	public boolean getDisplayProbability(){
		isDisplayProbability=false;

		try{
			Opportunity oppty = [SELECT id,Name,Description,Gate_3_Bypass_no_offer_support__c,Probability,Unweighted_Amount_EUR__c,Phase_Status__c,StageName,RecordTypeId FROM Opportunity WHERE id = :sObjectId];
			optyObj = oppty;
			if( ( (oppty.StageName==GlobalConstants.IDENTIFY_OPPORTUNITY && oppty.Phase_Status__c==GlobalConstants.PLANNED) || (oppty.StageName==GlobalConstants.DEVELOP_OPPORTUNITY  && oppty.Phase_Status__c==GlobalConstants.OPPORTUNITY_IN_PROGRESS && oppty.Gate_3_Bypass_no_offer_support__c ) ) && (oppty.RecordTypeId==directRecordTypeId || oppty.RecordTypeId==indirectRecordTypeId)){
	isDisplayProbability=true;
			}
			return isDisplayProbability;

		}catch(Exception ex){

			ExceptionHandler.addException(ex,GlobalConstants.PRVIEW_APPROVAL_CONTROLLER,GlobalConstants.GET_DISPLAY_PROBABILITY);
			return false;
		}
	}

	/****************************************
	*Method Name: getProbability
	*Description: These method used displaying probability percentage for G2 and G3
	*Parameters:
	*Req No:
	*****************************************/
	public Double getProbability(){
		try{
			Opportunity oppty = [Select id,Name,Description,Probability,Phase_Status__c,StageName,RecordTypeId from Opportunity where id = :sObjectId];
			return oppty.Probability;
		}catch(Exception ex){
			ExceptionHandler.addException(ex,GlobalConstants.PRVIEW_APPROVAL_CONTROLLER,GlobalConstants.GET_PROBABILITY);
			return 0.0;
		}
	}


	/****************************************
	*Method Name: updateProbabilityPercentage
	*Description: update probability percentage
	*Parameters: String sObjectType,String sObjectId,String probabilityPer
	*Req No:2382
	*****************************************/
	@RemoteAction
	public static String updateProbabilityPercentage(String sObjectType,String sObjectId,String probabilityPer){

		try{
			Opportunity oppObj = new Opportunity();
			oppObj.Id = sObjectId;
			System.debug('probabilityPer--->'+probabilityPer);
			oppObj.Calculating_Probability__c= integer.valueof(probabilityPer);
			oppObj.Probability = integer.valueof(probabilityPer);
			System.debug('oppObj.Probability--->'+oppObj.Probability);
			update oppObj;

			return GlobalConstants.RETURN_SUCCESS;

		}catch(Exception exp){

			ExceptionHandler.addException(exp,GlobalConstants.PRVIEW_APPROVAL_CONTROLLER,GlobalConstants.UPDATE_PROBABILITY_PER);
			return exp.getMessage();
		}
	}

	/****************************************
	*Method Name: SubmissionCommentsUpdate
	*Description: update probability percentage
	*Parameters: String sObjectType,String sObjectId,String probabilityPer
	*Req No:2382
	*****************************************/
	@RemoteAction
	public static String submissionCommentsUpdate(String sObjectId,String comments){

		Savepoint sp = null;
		try{
			sp = Database.setSavepoint();
			Opportunity oppty = [Select Id,Is_Automated__c,ApprovalStatusTechField__c,Submission_Comments__c,Phase_Status__c,Sales_Outcome__c,Apttus_Approval__Approval_Status__c,StageName from Opportunity where id=:sObjectId];
			if(oppty != null) {
				if(Comments<>NUll)
					oppty.Submission_Comments__c=comments;
				else
					oppty.Submission_Comments__c='';
				oppty.Is_Automated__c=True;
				Database.update(oppty,false);
			}
			return 'success';
		}
		catch(Exception e)
		{
			if(sp != null) Database.rollback(sp);
			system.debug('Exception On SubmissionCommentsUpdate>>>>'+e.getMessage());
			return e.getMessage();
		}

	}

	@future(callout=true)
	public Static Void updatePhaseStatus(String sObjectId,String comments){
		Savepoint sp = null;
		Try{
			set<id> parentOppIdSet = new set<id>();
			parentOppIdSet.add(sObjectId);
			List<Opportunity> opptyUpdate =new List<Opportunity>();
			List<Offer__c> relOffer = [select id,LoA_Approval_Level__c,ActiveOffer__c FROM Offer__c WHERE ActiveOffer__c =: TRUE AND Opportunity__c =:sObjectId LIMIT 1];
			for(Opportunity oppty:[Select Id,ApprovalStatusTechField__c,Submission_Comments__c,LOA_Level__c,Phase_Status__c,NF_LoA_Bypass__c,Blanket_Approval_Condition__c,Sales_Outcome__c,Apttus_Approval__Approval_Status__c,StageName from Opportunity where id=:sObjectId])
			{
	if(oppty!=Null && oppty.Phase_Status__c!=NUll && oppty.StageName !=NUll  && oppty.StageName.equalsignorecase(GlobalConstants.WIN_THE_CASE_NEGOTIATE) && 
	( ( oppty.Phase_Status__c.equalsignorecase(GlobalConstants.PENDING_WIN_LOSS_DECLARATION) && oppty.Apttus_Approval__Approval_Status__c!=NUll && oppty.Apttus_Approval__Approval_Status__c.equalsignorecase(GlobalConstants.PENDING_APPROVAL) )
	|| (oppty.LOA_Level__c<>Null&&oppty.LOA_Level__c=='E') || (oppty.Apttus_Approval__Approval_Status__c<>NUll && !oppty.Phase_Status__c.equalsignorecase(GlobalConstants.PENDING_WIN_LOSS_DECLARATION  ) && oppty.Apttus_Approval__Approval_Status__c.equalsignorecase(GlobalConstants.PENDING_APPROVAL) && oppty.NF_LoA_Bypass__c>0 && oppty.Blanket_Approval_Condition__c == null ))   )
	{
		oppty.Phase_Status__c=GlobalConstants.PTA_HANDOVER;
		oppty.StageName=GlobalConstants.HANDOVER_OPPTY;
		oppty.Apttus_Approval__Approval_Status__c=GlobalConstants.APPROVED;
		oppty.ApprovalStatusTechField__c=GlobalConstants.G5_APPROVAL_TECH;
		oppty.Sales_Outcome__c=GlobalConstants.WON;
		if(comments<>Null)
			oppty.Submission_Comments__c=comments;
		opptyUpdate.add(oppty);

	}
			}
			sp = Database.setSavepoint();
			// this is only for G5 Pending Winloss Update to Next phase
			if(!opptyUpdate.isEmpty())
	Database.update(opptyUpdate,false);

			if(flagForUpsellOppty)
			{
	if(relOffer<>Null &&  relOffer.size()>0 && opptyUpdate<>Null && relOffer[0].LoA_Approval_Level__c != '' && relOffer[0].LoA_Approval_Level__c =='E' && opptyUpdate[0].StageName.equalsignorecase(GlobalConstants.HANDOVER_OPPTY))
	{
		UpsellOppUtility.toCreateUpsellOpportunity(parentOppIdSet);
	}
	flagForUpsellOppty = false;
			}

			List<Apttus_Approval__Approval_Request__c> approval_SH= new List<Apttus_Approval__Approval_Request__c>();

			//update the Stakeholders Status to notify
			for(Apttus_Approval__Approval_Request__c Appupdate:[Select id,Apttus_Approval__Related_Opportunity__r.Phase_Status__c,Apttus_Approval__Notify_Only__c,Apttus_Approval__Object_Id__c,Apttus_Approval__DelegateApproverIds__c,Apttus_Approval__Assigned_To_Id__c,NF_Assignee_Type__c,Apttus_Approval__Approval_Status__c  from Apttus_Approval__Approval_Request__c where Apttus_Approval__Object_Id__c=:sObjectId and NF_Assignee_Type__c<>Null  ])
			{
	// Collecting the StakeHodler Records and updating the stakeholder status.
	if(Appupdate.NF_Assignee_Type__c<>Null&& Appupdate.Apttus_Approval__Related_Opportunity__r.Phase_Status__c<>NUll && (Appupdate.Apttus_Approval__Related_Opportunity__r.Phase_Status__c.equalsignorecase(GlobalConstants.SUBMITTED_FOR_G3_APPROVAL) || Appupdate.Apttus_Approval__Related_Opportunity__r.Phase_Status__c.equalsignorecase(GlobalConstants.SUBMITTED_FOR_G4_APPROVAL) )&& Appupdate.Apttus_Approval__Approval_Status__c.equalsignorecase(GlobalConstants.STATUS_NOT_SUBMITTED) && Appupdate.NF_Assignee_Type__c.Contains(GlobalConstants.STAKEHOLDER_INFORMATION))
	{
		System.debug('### Inside SH Recorde'+Appupdate.NF_Assignee_Type__c);
		Appupdate.Apttus_Approval__Approval_Status__c =GlobalConstants.NOTIFIED;
		approval_SH.add(Appupdate);
	}
			}

			if(approval_SH.size()>0)
			Database.update(approval_SH,false);
		}
		catch(Exception e)
		{
			if(sp != null) Database.rollback(sp);
			system.debug('Exception On updatePhaseStatus>>>>'+e.getMessage());
		}
	}

	/****************************************
	*Method Name: getUnweightedAmount()
	*Description:  These method used for getting Unweighted Amount
	*Parameters:
	*Req No: SF00007566
	*****************************************/
	public boolean getUnweightedAmount(){
		Id opptyDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
		Id opptyIndirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.Indirect_Record_Type).getRecordTypeId();
		String label_Amount = System.Label.Unweighted_Amount_For_Sales_Outcome;
		isAmountGreater=false;
		reasonsRequired = System.Label.Three_Reasons_Required;

		try{
			Opportunity oppty = [Select
			id,RecordTypeId,
			Amount
			from Opportunity
			where id = :sObjectId
			LIMIT 1 ];

			System.debug('label_Amount'+label_Amount);
			if(oppty.Amount >= Decimal.valueOf(label_Amount) &&
			(oppty.RecordTypeId == opptyDirectRecordTypeId || oppty.RecordTypeId == opptyIndirectRecordTypeId)){
	isAmountGreater=true;
			}
			system.debug('isAmountGreater'+isAmountGreater);
			return isAmountGreater;

		}catch(Exception ex){
			ExceptionHandler.addException(ex,GlobalConstants.PRVIEW_APPROVAL_CONTROLLER,GlobalConstants.Get_Unweighted_Amount);
			return false;
		}
	}


	public void showwarningmessage(Opportunity opp){
		try{
			Previewmessage=JSON.serialize('Please wait until your request is completely processed. Do not close the page or interrupt the approval submission.');
			ispreviewmessage=false;
			if(opp.StageName.equalsignorecase(GlobalConstants.WIN_THE_CASE_NEGOTIATE )&&opp.LOA_Level__c=='E') ispreviewmessage=true;
			if(opp.StageName.equalsignorecase(GlobalConstants.WIN_THE_CASE_NEGOTIATE ) && !opp.Phase_Status__c.equalsignorecase(GlobalConstants.PENDING_WIN_LOSS_DECLARATION  ) && opp.NF_LoA_Bypass__c>0 && opp.Blanket_Approval_Condition__c==null )ispreviewmessage=true;
			if(opp.StageName.equalsignorecase(GlobalConstants.WIN_THE_CASE_NEGOTIATE ) && opp.Phase_Status__c.equalsignorecase(GlobalConstants.PENDING_WIN_LOSS_DECLARATION  )  )ispreviewmessage=true;

			if(PSRLoAlevel != null && PSRLoAlevel != '')
			{
	loaupdated = true;
	Previewmessage=JSON.serialize('LoA level is set to - '+PSRLoAlevel+ '. Please review the gate participants before submitting for approval');
			}

		}catch(Exception ex){
			ExceptionHandler.addException(ex,GlobalConstants.PRVIEW_APPROVAL_CONTROLLER,GlobalConstants.Get_Unweighted_Amount);
		}
	}

	/****************************************
	*Method Name: SortRecords
	*Description:  Sort the records with the sequence i.e Approver,Validator and Stakeholder
	*Parameters: List of ApprovalRequestWrapperClass and return the sort order
	*****************************************/
	Public  List<ApprovalRequestWrapperClass> sortRecords(  List<ApprovalRequestWrapperClass> records) {
		List<ApprovalRequestWrapperClass> afterSort =new List<ApprovalRequestWrapperClass>();
		List<Apttus_Approval__Approval_Request__c> beforeSort= new List<Apttus_Approval__Approval_Request__c>();

		for(ApprovalRequestWrapperClass Data:records)
		beforeSort.add(Data.approvalReq);

		for(ApprovalRequestWrapperClass  Rec:records)
		{
			if(Rec.approvalReq.NF_Assignee_Type__c<>Null && Rec.approvalReq.NF_Assignee_Type__c.equalsignorecase(GlobalConstants.APPROVER) )
			{
	afterSort.add(Rec);
			}
		}

		for(ApprovalRequestWrapperClass  RecValidator:records)
		{
			if(RecValidator.approvalReq.NF_Assignee_Type__c<>Null && RecValidator.approvalReq.NF_Assignee_Type__c.equalsignorecase(GlobalConstants.VALIDATOR ) )
			{
	afterSort.add(RecValidator);
			}
		}

		for(ApprovalRequestWrapperClass  RecStakeHolder: records)
		{
			if(RecStakeHolder.approvalReq.NF_Assignee_Type__c<>Null && RecStakeHolder.approvalReq.NF_Assignee_Type__c.equalsignorecase(GlobalConstants.STAKEHOLDER_INFORMATION) )
			{
	afterSort.add(RecStakeHolder);
			}
			else if(RecStakeHolder.approvalReq.NF_Assignee_Type__c==NUll){
	afterSort.add(RecStakeHolder);
			}
		}

		return afterSort ;
	}

}