/*************************************************************
@Name: APTSCU_ApprovalActionsController
@Author:  Jigar Naik
@CreateDate: 21 Feb 2016
@Description: Controller class for custom approval actions page.
******************************************************************/
public with sharing class APTSCU_ApprovalActionsController{
	public String sObjectType {get; set;}
	public String sObjectName {get; set;}
	public ID sObjectId {get; set;}
	public String approvalRequestId {get; set;}
	public String sObjectFieldSetJSON {get; set;}
	public String sObjectDataJSON {get; set;}
	public String sObjectDisplayFieldsJSON {get; set;}
	public String previewApprovalsJSON {get;set;}
	public String approvalHeaderInformation {get;set;}
	public String approvalRequestJSON {get;set;}
	public String submitterName {get;set;}
	public String approverName {get;set;}
	public String redirectURL {get;set;}
	public String pageMode {get;set;}
	public string userJSON{get; set;}
	public string endCustomerName{get; set;}
	
	public String stepName {get;set;}
    public String stepCustName {get;set;}
    public String receiverName {get;set;}
	public String stepEntryCriteria {get;set;}
	public Set<String> profilesList = new Set<String>{'Nokia Read Only','Nokia Sales Profile','Non-Sales User Profile','Sales Ops Profile','System Administrator','Global Process Admin','Nokia Admin Profile'};
		
		public APTSCU_ApprovalActionsController() {
			approvalRequestId = ApexPages.currentPage().getParameters().get('approvalRequestId');
			pageMode = ApexPages.currentPage().getParameters().get('pageMode');
			redirectURL=ApexPages.currentPage().getHeaders().get('Referer');
			
		}
	
	public void queryApprovalRequest(){
		try{
			String soqlQuery = getAllFieldsSOQL('Apttus_Approval__Approval_Request__c','Id = :approvalRequestId');
			Apttus_Approval__Approval_Request__c approvalRequest = (Apttus_Approval__Approval_Request__c)Database.query(soqlQuery);
			
			sObjectId = approvalRequest.Apttus_Approval__Object_Id__c;
			sObjectType = approvalRequest.Apttus_Approval__Object_Type__c;
			//heema start
			if('Apttus_Proposal__Proposal__c'.equalsIgnoreCase(sObjectType)){
				sObjectName = 'Quote';
			}
			else{
				sObjectName = 'opportunity';
			}
			//heema end
			set<id> userIdset = new set<id>();
			
			userIdset.add(approvalRequest.Apttus_Approval__Initial_Submitter__c);
			userIdset.add(approvalRequest.Apttus_Approval__Assigned_To_Id__c);
			
			
			queryApprovalHeaderInformation();
			saveApprovalDisplayInformation(approvalRequest.Apttus_Approval__Approval_Process__c, approvalRequest.Apttus_Approval__Step_Name__c);
			setUserInformation(approvalRequest.Apttus_Approval__Initial_Submitter__c, approvalRequest.Apttus_Approval__Assigned_To_Id__c);
			
			List<user> userlist = new List<user>();
			userlist = [select id,name from user where isactive=true and Id Not In:userIdset AND Profile.Name IN : profilesList];
			System.debug(userlist.size());
			userJSON = JSON.serialize(userlist);
			
			
			approvalRequestJSON=JSON.serialize(approvalRequest);
		}catch(Exception exp){
			//return exp.getMessage();
		}
	}
	@RemoteAction
	public static String approveRequest(String approvalRequestId,String comment){
		Savepoint sp = Database.setSavepoint();
		try{	
			Apttus_Approval.ApprovalsWebService.approveRequest(approvalRequestId,comment);
			return 'approved';
		}catch(Exception exp){
			Database.rollback(sp);
			String expMessage = exp.getMessage().replace('&quot;', '');
			expMessage = expMessage.replace('\'', '');
			String[] result = expMessage.split(',');
			String errorMsg = '';
			if(result.size() > 1 && result.size() == 2 && result[1] != null && result[1] != '') {
				errorMsg = result[1];
			}else{
				errorMsg =  expMessage;		
			}
			return errorMsg;
		}
	}
	
	@RemoteAction
	public static String rejectRequest(String approvalRequestId,String comment){
		Savepoint sp = Database.setSavepoint();
		try{
			Apttus_Approval.ApprovalsWebService.rejectRequest(approvalRequestId,comment);
			return 'rejected';
		}catch(Exception exp){
			Database.rollback(sp);
			String expMessage = exp.getMessage().replace('&quot;', '');
			expMessage = expMessage.replace('\'', '');
			String[] result = expMessage.split(',');
			String errorMsg = '';
			if(result.size() > 1 && result.size() == 2 && result[1] != null && result[1] != '') {
				errorMsg = result[1];
			}else{
				errorMsg =  expMessage;		
			}
			return errorMsg;
		}
	}
	
	@RemoteAction
	public static String addCommentsToRequest(String approvalRequestId,String comment){
		Savepoint sp = Database.setSavepoint();
		try{
			Apttus_Approval.ApprovalsWebService.addCommentsToRequest(approvalRequestId,comment);
			return 'commented';
		}catch(Exception exp){
			Database.rollback(sp);
			String expMessage = exp.getMessage().replace('&quot;', '');
			expMessage = expMessage.replace('\'', '');
			String[] result = expMessage.split(',');
			String errorMsg = '';
			if(result.size() > 1 && result.size() == 2 && result[1] != null && result[1] != '') {
				errorMsg = result[1];
			}else{
				errorMsg =  expMessage;		
			}
			return errorMsg;
		}
	}
	
	@RemoteAction
	public static String reassignRequest(String approvalRequestId,String toassignId,String comment){
		Savepoint sp = Database.setSavepoint();
		try{
			Apttus_Approval.ApprovalsWebService.reassignRequest(approvalRequestId,toassignId,comment);
			return 'reassigned';
		}catch(Exception exp){
			Database.rollback(sp);
			String expMessage = exp.getMessage().replace('&quot;', '');
			expMessage = expMessage.replace('\'', '');
			String[] result = expMessage.split(',');
			String errorMsg = '';
			if(result.size() > 1 && result.size() == 2 && result[1] != null && result[1] != '') {
				errorMsg = result[1];
			}else{
				errorMsg =  expMessage;		
			}
			return errorMsg;
		}
	}  
	
	
	private void queryApprovalHeaderInformation(){
		List<Schema.FieldSetMember> fields = Schema.getGlobalDescribe().get(sObjectType).getDescribe().fieldSets.getMap().get('APTSCU_Approval_Header_Fields').getFields(); 
		
		Map<String,String> fldVsLabelMap = new Map<String,String>();
		for(Schema.FieldSetMember fld : fields){
			fldVsLabelMap.put(fld.getFieldPath(),fld.getLabel());
		}
		
		String soqlQuery = getAllFieldsSOQL(sObjectType,'Id = :sObjectId');
		SObject sObjectData = Database.query(soqlQuery);
		System.debug('sObjectData = ' + sObjectData);
		//ft-223 Substitute LE Id for Name INI
		if(sObjectName == 'opportunity'){
			Id legalEntityId = (Id)sObjectData.get('End_Customer_LE__c');
			endCustomerName = '';
			List<Account> accountLE = [SELECT Name FROM Account where ID =:legalEntityId LIMIT 1];
			if(accountLE != null && !accountLE.isEmpty()){
				endCustomerName = accountLE[0].Name;
			}
		}
		// END
		sObjectFieldSetJSON = JSON.serialize(fldVsLabelMap);
		sObjectDataJSON = JSON.serialize(sObjectData);
	}
	@TestVisible
	private void saveApprovalDisplayInformation(Id processId, String currentStepName){
		stepName = currentStepName;
		Apttus_Approval__Approval_Process__c approvalStep = [Select Id, Apttus_Approval__StepDisplayFieldNameHeader__c, Apttus_Approval__StepDisplayFieldNames__c From Apttus_Approval__Approval_Process__c Where Apttus_Approval__Step__r.Apttus_Approval__Step_Group__c = :processId And Apttus_Approval__Step_Name__c = :currentStepName];
		List<Apttus_Approval__Approval_Process__c> entryCriteriaList = [Select Id, Apttus_Approval__Step_Filter_Field__c, Apttus_Approval__Step_Filter_Comparison_Type__c, Apttus_Approval__Step_Filter_Field_Value__c, Apttus_Approval__Step_Filter_BoolOper__c From Apttus_Approval__Approval_Process__c Where Apttus_Approval__Step_Filter__r.Apttus_Approval__Step__r.Apttus_Approval__Step_Group__c = :processId And Apttus_Approval__Step_Filter__r.Apttus_Approval__Step_Name__c = :currentStepName];
		
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
		//ft-223 New oppotunity fields to display INI
		if(sObjectType == 'opportunity'){
			displayFields.add('supporting_bgs_bus__c');
			displayFields.add('lead_bu__c');
			displayFields.add('lead_bg__c');
			displayFields.add('country__c');
			displayFields.add('end_customer_name');
			displayFields.add('account_name__c');
			displayFields.add('name');
		}
		//ft-223 END
		
		if(displayFields.isEmpty()){
			displayFields.add('name');
		}		
		Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(sObjectType).getDescribe().fields.getMap(); 
		Map<String,String> fldVsLabelMap = new Map<String,String>();
		Map<String,String> fldVsLabelMapAll = new Map<String,String>();
		for(String field : displayFields	){
			if(fMap.containsKey(field)){
				Schema.SObjectField ft= fMap.get(field);
				Schema.DescribeFieldResult fd = ft.getDescribe();
				String label = fd.getLabel();
				if(field == 'account_name__c') label = 'Customer';
				if(field == 'name') label = 'Opportunity Name';
				fldVsLabelMap.put(fd.getName(), label);
				fldVsLabelMapAll.put(fd.getName(), fd.getLabel());
			}
			if(field == 'end_customer_name') {
				fldVsLabelMap.put('End_Customer_LE_Name', 'End Customer');
			}
		}
		
		for(Integer index = 0; index < entryCriteriaList.size(); index++){
			Apttus_Approval__Approval_Process__c entryCriteria = entryCriteriaList[index];
			stepEntryCriteria = '(' + fldVsLabelMapAll.get(entryCriteria.Apttus_Approval__Step_Filter_Field__c) + getOperator(entryCriteria.Apttus_Approval__Step_Filter_Comparison_Type__c) + entryCriteria.Apttus_Approval__Step_Filter_Field_Value__c + ')';
			if(index < entryCriteriaList.size() - 1){
				stepEntryCriteria += ' ' + entryCriteria.Apttus_Approval__Step_Filter_BoolOper__c + ' ';
			}
		}
		/*
		//ft-223 Change display and sort values to display INI
		if(sObjectType == 'opportunity'){
			String tempOppName = 'Name';
			String tempCustomer = 'Account_Name__c';
			String tempEndCustomer = 'Override_Reason__c';
			String tempCountry = 'Country__c';
			String tempBG = 'Lead_BG__c';
			String tempBU = 'Lead_BU__c';
			String tempSupBGBU = 'Supporting_BGs_BUs__c';
			fldVsLabelMap.remove(tempOppName);
			fldVsLabelMap.remove(tempCustomer);
			fldVsLabelMap.remove(tempEndCustomer);
			fldVsLabelMap.remove(tempCountry);
			fldVsLabelMap.remove(tempBG);
			fldVsLabelMap.remove(tempBU);
			fldVsLabelMap.remove(tempSupBGBU);
			fldVsLabelMap.put(tempSupBGBU,'Supporting BGs/BUs');
			fldVsLabelMap.put(tempBU,'Lead BU');
			fldVsLabelMap.put(tempBG,'Lead BG');
			fldVsLabelMap.put(tempCountry,'Country');
			fldVsLabelMap.put(tempEndCustomer,'End Customer');
			fldVsLabelMap.put(tempCustomer,'Customer');
			fldVsLabelMap.put(tempOppName,'Opportunity Name');
			
		}
		//ft-223 END */
		
		sObjectDisplayFieldsJSON = JSON.serialize(fldVsLabelMap);
	}
	
	private void setUserInformation(Id submitter, Id approver){
		Map<Id, User> userMap = new Map<Id, User>([Select Id, Name From User Where Id = :submitter Or Id = :approver]);
		submitterName = userMap.get(submitter).Name;
		
		if(userMap.containsKey(approver)){
			approverName = userMap.get(approver).Name;
		}
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
	
	
}