/*********************************************************************
* Class Name : CPO_OrderEnrichmentHeaderCreation
* Test Class : CPO_OrderEnrichmentHeaderCreationTest
* Created Date: 15 Jun 2021
* Created By : Harsha Gobburi
* Description : This class is for enriching CPO header after creation
*******************************************************************/
public with sharing class CPO_OrderEnrichmentHeaderCreation {
	public static Boolean isFirstTime = true;
	
	public static void validateCpo(List<Apttus_Config2__CustomerPurchaseOrder__c> cpoList, Boolean isFromTrigger) {
		// Will it be better to check here if the cpo coming into this method has cpo line items, if no line items don't perform the validation (mandatory field check)
		List<String> mandatoryFields = getAllMandatoryFields();
		System.debug('its coming here new ' + cpoList);
		
		Map<String, String> cpoApiToLabel = getAllObjectFields('Apttus_Config2__CustomerPurchaseOrder__c');
		
		QTO_Exception_Configuration__mdt exceptionMetadata =
			[select id, MasterLabel, QualifiedApiName,QTO_Return_Code__c,QTO_Return_Description__c,
			 QTO_Return_Type__c,QTO_Task_Subject__c,QTO_Tasks_Due_Date__c,QTO_Tasks_Priority__c,
			 QTO_Tasks_Status__c,QTO_Investigating_Group__c,QTO_Log_Details__c
			 from QTO_Exception_Configuration__mdt where MasterLabel = 'Enrichment 601'];
		
		
		List<Task> taskList = new List<Task>();
		List<QTO_Customer_Document_Issue_Log__c> issueLogList = new List<QTO_Customer_Document_Issue_Log__c>();
		
		for (Apttus_Config2__CustomerPurchaseOrder__c cpo: cpoList) {
			System.debug('its coming here new::::: ' + cpo.Apttus_Config2__Status__c);
			String errorMessage = '';
			for (String fieldName: mandatoryFields) {
				if(fieldName!='Customer_Contact_Commercial__c' && fieldName!='Customer_Contact_Delivery__c') {
					if (cpo.get(fieldName) == null) {
						errorMessage += 'Missing field ' +
							getLabelByApi(cpoApiToLabel, fieldName) + ', \n';
						
					}
				}
			}
			
			if (errorMessage == '') {
				cpo.put('Apttus_Config2__Status__c', 'Fully Enriched');
			} else {
				cpo.put('Apttus_Config2__Status__c', 'Fully Enriched');
				//cpo.put('Apttus_Config2__Status__c', 'Exception Data Enrichment');
				/*
				cpo.put('Error_Message__c', exceptionMetadata.QTO_Return_Description__c);
				
				QTO_Customer_Document_Issue_Log__c issueLog =
					createIssueLog(cpo.Id, exceptionMetadata.QTO_Return_Type__c,
								   String.valueOf(exceptionMetadata.QTO_Return_Code__c),
								   errorMessage);
				Task task = createTask(cpo.Id,
									   String.valueOf(exceptionMetadata.QTO_Return_Code__c) ,
									   exceptionMetadata.QTO_Tasks_Status__c,
									   exceptionMetadata.QTO_Task_Subject__c,
									   errorMessage + ' \n Please go to log for further details',
									   exceptionMetadata.QTO_Investigating_Group__c);
				taskList.add(task);
				issueLogList.add(issueLog);
	*/
			}
		}
		
		if (!isFromTrigger) {
			update cpoList;
		}
		insert taskList;
		insert issueLogList;		
	}
	
	
	
	public static void createEnrichment(List<Customer_Document__c> documents) {
		
		Map<Id, Customer_Document__c> documentMap = new Map<Id, Customer_Document__c>();
		Set<String> agreementIds = new Set<String>();
		Set<Id> cDocIds = new Set<Id>();
		List<Id> docIds = new List<Id>();
		Map<String, CPO_Enrichment_Field_Mapping__mdt> fieldMapping = getFieldMapping();
		List<String> agreementFields = new List<String>();
		Map<Id, Apttus__APTS_Agreement__c> cdIdToAgreement = new Map<Id, Apttus__APTS_Agreement__c>();
		
		for (Customer_Document__c cDoc :documents) {
			documentMap.put(cDoc.Id, cDoc);
			cDocIds.add(cDoc.Id);
		}
		for (String field: fieldMapping.keySet()) {
			if(fieldMapping.get(field).Source_Object__c == 'Apttus__APTS_Agreement__c') {
				agreementFields.add('QTO_Agreement__r.' + fieldMapping.get(field).Token_Api__c);
			}
			if(fieldMapping.get(field).Secondary_Token_Source_Object__c  == 'Apttus__APTS_Agreement__c') {
				agreementFields.add('QTO_Agreement__r.' + fieldMapping.get(field).Secondary_Token_Api__c);
			}
		}
		
		
		String allFields = String.join(agreementFields, ',');
		String agreementQuery = 'SELECT QTO_Customer_Document__c,' +allFields +
			' FROM QTO_Customer_Document_Agreement__c ' + 
			' WHERE QTO_Customer_Document__c IN: cDocIds AND QTO_Used__c = true';
		
		List<QTO_Customer_Document_Agreement__c> agrAssociation = Database.query(agreementQuery);
		for (QTO_Customer_Document_Agreement__c agreement :agrAssociation) {
			cdIdToAgreement.put(agreement.QTO_Customer_Document__c, agreement.QTO_Agreement__r);
		}
		
		Map<String, String> documentApiToLabel = getAllObjectFields('Customer_Document__c');
		Map<String, String> agrApiToLabel = getAllObjectFields('Apttus__APTS_Agreement__c');
		
		List<Apttus_Config2__CustomerPurchaseOrder__c> cpoList = new List<Apttus_Config2__CustomerPurchaseOrder__c>();
		
		// record type on cpo will be defaulted to DS_Customer_Purchase_Order
		Id DS_CPO_RecordTypeId = Schema.SObjectType.Apttus_Config2__CustomerPurchaseOrder__c
			.getRecordTypeInfosByDeveloperName()
			.get('DS_Customer_Purchase_Order')
			.getRecordTypeId();
		docIds.addAll(cDocIds);
		List<Customer_Document__c> docs = QTOCustomerDocumentUtil.findByCustomerDocumentId(docIds);
		
		for (Customer_Document__c cDoc: docs) {
			Apttus_Config2__CustomerPurchaseOrder__c cpoRec = new Apttus_Config2__CustomerPurchaseOrder__c();
			String errorMessage = '';
			for (String fieldApi :fieldMapping.keySet()) {
				CPO_Enrichment_Field_Mapping__mdt cpoMapping = fieldMapping.get(fieldApi);
				
				if (cpoMapping.Source_Object__c == 'Customer_Document__c') 
				{
					Boolean isNull = checkIsNull(cDoc.get(cpoMapping.Token_API__c));
					if (isNull && cpoMapping.Secondary_Token_Api__c != null) 
					{
						if (cpoMapping.Secondary_Token_Source_Object__c == 'Apttus__APTS_Agreement__c') {
							Apttus__APTS_Agreement__c agrRec = cdIdToAgreement.get(cDoc.Id);
							Boolean isSecondaryNull = agrRec == null || checkIsNull(agrRec.get(cpoMapping.Secondary_Token_API__c)) ? true : false;
							if (!isSecondaryNull) {
								if(cpoMapping.Secondary_Token_API__c =='Customer_contact_commercial_name__c'){
									cpoRec.put('QTO_Customer_Contact_commercial__c', cDoc.get(cpoMapping.Secondary_Token_API__c)); 
								}
								else if(cpoMapping.Secondary_Token_API__c =='Customer_contact_delivery_name__c'){
									cpoRec.put('QTO_Customer_Contact_delivery__c', cDoc.get(cpoMapping.Secondary_Token_API__c)); 
								}
								else {
									cpoRec.put(cpoMapping.MasterLabel, agrRec.get(cpoMapping.Secondary_Token_API__c));
								}
							}
						}
						if (cpoMapping.Secondary_Token_Source_Object__c == 'Customer_Document__c') 
						{	   
								Boolean isSecondaryNull = checkIsNull(cDoc.get(cpoMapping.Secondary_Token_API__c));
								if (!isSecondaryNull) {
									cpoRec.put(cpoMapping.MasterLabel, cDoc.get(cpoMapping.Secondary_Token_API__c));
								}
						}
					} 
					else if (!isNull) 
					{
						if(cpoMapping.Token_API__c !='QTO_Customer_Contact_commercial__c' &&  cpoMapping.Token_API__c !='QTO_Customer_Contact_delivery__c') {
							if(cpoMapping.Token_API__c =='Customer_Contact_commercial__c'){
								 cpoRec.put('QTO_Customer_Contact_commercial__c', cDoc.get(cpoMapping.Token_API__c)); 
							}
							else if(cpoMapping.Token_API__c =='Customer_Contact_Delivery__c'){
								 cpoRec.put('QTO_Customer_Contact_delivery__c', cDoc.get(cpoMapping.Token_API__c)); 
							}
							else {
							   cpoRec.put(cpoMapping.MasterLabel, cDoc.get(cpoMapping.Token_API__c)); 
							}
						}
					}
				}
				
				if (cpoMapping.Source_Object__c == 'Apttus__APTS_Agreement__c') {
					Apttus__APTS_Agreement__c agrRec = cdIdToAgreement.get(cDoc.Id);
					Boolean isNull = (agrRec == null || checkIsNull(
						agrRec.get(cpoMapping.Token_API__c))) ? true : false;
					
					if (isNull && cpoMapping.Secondary_Token_Api__c != null) {
						if (cpoMapping.Secondary_Token_Source_Object__c == 'Apttus__APTS_Agreement__c') {
							Boolean isSecondaryNull = checkIsNull(agrRec.get(cpoMapping.Secondary_Token_API__c));
							
							if (!isSecondaryNull) {
								cpoRec.put(cpoMapping.MasterLabel, agrRec.get(cpoMapping.Secondary_Token_API__c));
							}
						}
						
						if (cpoMapping.Secondary_Token_Source_Object__c == 'Customer_Document__c') {
							Boolean isSecondaryNull = checkIsNull(cDoc.get(cpoMapping.Secondary_Token_API__c));
							
							if (!isSecondaryNull) {
								cpoRec.put(cpoMapping.MasterLabel, cDoc.get(cpoMapping.Secondary_Token_API__c));
							}
						}
					} else if (!isNull) {
						cpoRec.put(cpoMapping.MasterLabel, agrRec.get(cpoMapping.Token_API__c));
					}
				}
				
			}			
			
			cpoRec.Nokia_Customer_Document_ID__c = cDoc.Id;
			cpoRec.Apttus_Config2__Status__c = 'Draft';
			cpoRec.Handed_Over_to_ERP__c = true;
			cpoRec.Apttus_Config2__PODate__c = System.today();
			cpoRec.RecordTypeId = DS_CPO_RecordTypeId;
			
			cpoRec.Classification__c = cDoc.Classification__c;
			cpoRec.Sub_Classification__c = cDoc.Sub_Classification__c;
			
			
			cpoList.add(cpoRec);
			System.debug('cpRec:::' + cpoRec);
			
		}
		
		insert cpoList;
		
		QTO_CPOLineItemHelper.createLineItems(cpoList);
		// validateCpo(cpoList, false);
	}
	
	public static QTO_Customer_Document_Issue_Log__c createIssueLog(Id cdSOId, String errorType, String returnCode, String issueDetails){
		QTO_Customer_Document_Issue_Log__c issueLog = new QTO_Customer_Document_Issue_Log__c();
		issueLog.Customer_Purchase_Order__c  = cdSOId;
		issueLog.QTO_ErrorType__c = errorType; //Warning-Error
		issueLog.QTO_Return_Code__c = returnCode; //101-121
		issueLog.QTO_IssueDetails__c = issueDetails;
		return issueLog;
	}
	
	//To create Task related to issue on Customer Document.
	public static Task createTask(Id cdSOId, String errorCode, String status, String subject, String description, String investingGroup) {
		Task newTask = new Task();
		newTask.WhatId = cdSOId;
		//newTask.RecordTypeId = qtoRecordTypeId;
		newTask.QTO_Error_Code__c = errorCode;
		newTask.Status = status;
		newTask.Subject = subject;
		newTask.Description = description;
		newTask.Investigating_Groups__c = investingGroup;
		newTask.ActivityDate = Date.today();
		return newTask;
	}
	
	public static Boolean checkIsNull(Object value) {
		if (value == null) {
			return true;
		} else {
			return false;
		}
	}
	
	String type='Account';
	
	private static String getLabelByApi(Map<String, String> fieldMap, String fieldApi) {
		return fieldMap.get(fieldApi.toLowerCase());
	}
	
	private static Map<String, String> getAllObjectFields(String type) {
		Map<String, String> allFields = new Map<String, String>();
		Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
		Schema.SObjectType leadSchema = schemaMap.get(type);
		Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
		
		for (String fieldName: fieldMap.keySet()) {
			fieldMap.get(fieldName).getDescribe().getLabel();
			allFields.put(fieldName, fieldMap.get(fieldName).getDescribe().getLabel());
		}
		
		System.debug('allFields' + allFields);
		
		return allFields;
	}
	
	private static Map<String, CPO_Enrichment_Field_Mapping__mdt> getFieldMapping() {
		Map<String, CPO_Enrichment_Field_Mapping__mdt> fieldMapping =
			new Map<String, CPO_Enrichment_Field_Mapping__mdt>();
		for (CPO_Enrichment_Field_Mapping__mdt metadata :[
			SELECT id, MasterLabel, QualifiedApiName, Required__c,
			Source_Object__c, Token_API__c, Secondary_Token_Source_Object__c,
			Secondary_Token_Api__c
			FROM CPO_Enrichment_Field_Mapping__mdt
		]) {
			fieldMapping.put(metadata.MasterLabel, metadata);
		}
		
		return fieldMapping;
	}
	@TestVisible
	private static List<String> getAllMandatoryFields() {
		Map<String, CPO_Enrichment_Field_Mapping__mdt> fieldMapping = getFieldMapping();
		
		List<String> mandatoryFields = new List<String>();
		for (String fieldName: fieldMapping.keySet()) {
			if (fieldMapping.get(fieldName).Required__c) {
				mandatoryFields.add(fieldName);
			}
		}
		return mandatoryFields;
	}
	
	
}