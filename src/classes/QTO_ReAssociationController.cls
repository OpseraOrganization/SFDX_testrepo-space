public with sharing class QTO_ReAssociationController {

	@AuraEnabled
	public static string getBatchStatus(String clsName,String batchId){
		String jobStatus ='Completed';
		List<String> JOB_STATUS_LIST = new List<String>{'Completed','Failed','Aborted'};
		string JOB_TYPE = 'BatchApex';
		String query = 'SELECT Id,status FROM AsyncApexJob WHERE ApexClass.Name =:clsName AND Status NOT IN:JOB_STATUS_LIST AND JobType=:JOB_TYPE';
		if(batchId !=''){
			query += ' AND Id =: batchId';
		}
		List<AsyncApexJob> jobInfo = Database.Query(query);
		if(jobInfo !=NULL && jobInfo.size()>0){
			jobStatus = jobInfo[0].status;
		}
		return jobStatus;
	} 

	@AuraEnabled
	public static void reAssociateCustomerDocumentLineItems(String cdId) {
		system.debug('cdId...'+cdId);
		List<Customer_Document_Line_Items__c> associationFailedList = 
			[
	Select Id,High_level_Product__c,High_level_Product_Description__c,QTO_PDF_Unit_Of_Measure__c,QTO_PDF_Quantity__c,QTO_PDF_Unit_Price__c,
	QTO_PDF_Currency_Code__c,Detailed_Product__c,Detailed_Product_Description__c, Quantity__c, QTO_Unit_of_Measure__c, QTO_Unit_Price__c, CurrencyIsoCode,
	QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c,Contract_Item_Number__c,QTO_PDF_Total_Value__c,QTO_PDF_Requested_Delivery_Date__c,
	Price_List_Item__c,Customer_Document__c,Customer_Document__r.Customer__c, QTO_CDLI_Matched_Quoted_Quantity__c, QTO_CDLI_Matched_Contracted_Quantity__c 
	from Customer_Document_Line_Items__c where Customer_Document__c =:cdId AND Status__c IN ('Exception-Association(Lines)')  AND Association_Comment__c IN ('Association Failed')];
		
		List<Customer_Document_Line_Items__c> manualAssociationList = 
			[
	Select Id,High_level_Product__c,High_level_Product_Description__c,QTO_PDF_Unit_Of_Measure__c,QTO_PDF_Quantity__c,QTO_PDF_Unit_Price__c,
	QTO_PDF_Currency_Code__c,Detailed_Product__c,Detailed_Product_Description__c, Quantity__c, QTO_Unit_of_Measure__c, QTO_Unit_Price__c, CurrencyIsoCode,
	QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c,Contract_Item_Number__c,QTO_PDF_Total_Value__c,QTO_PDF_Requested_Delivery_Date__c,
	Price_List_Item__c,Customer_Document__c,Customer_Document__r.Customer__c, QTO_CDLI_Matched_Quoted_Quantity__c, QTO_CDLI_Matched_Contracted_Quantity__c 
	from Customer_Document_Line_Items__c where Customer_Document__c =:cdId AND Status__c IN ('Manually-Associated(Lines)')  AND Association_Comment__c IN ('Association Successful')
			];
		
		System.debug('associationFailedList...'+associationFailedList.size());
		System.debug('manualAssociationList...'+manualAssociationList.size());
		if(associationFailedList.size()>0)  {
			QTO_CdLineItemAssociationHelper.associateCdLineItems(associationFailedList);
			List<Customer_Document_Line_Items__c> lines = findAllCDLines(cdId);
			QTO_CDLineItemMatchingHelper.matchCdLineItems(lines);
			//QTO_CDLineItemMatchingHelper.updateCDocStatus(lines);
			QTOCustomerDocumentUtil.updateCustomerDocumentStatus(new Set<Id>{cdId}, 'LINEITEM');
			QTO_CDLineItemMatchingHelper.updateQuoteAndAgreementAcceptance(lines) ;
		}
		
		if(manualAssociationList.size()>0)  {
			QTO_CDLineItemMatchingHelper.matchCdLineItems(manualAssociationList);
			List<Customer_Document_Line_Items__c> lines = findAllCDLines(cdId);
			//QTO_CDLineItemMatchingHelper.updateCDocStatus(lines);
			QTOCustomerDocumentUtil.updateCustomerDocumentStatus(new Set<Id>{cdId}, 'LINEITEM');
			QTO_CDLineItemMatchingHelper.updateQuoteAndAgreementAcceptance(lines) ;
		}
	}

	@AuraEnabled
	public static void reMatchingCustomerDocumentLineItems(String cdId) {
		system.debug('cdId...'+cdId);
		List<Customer_Document_Line_Items__c> cdlineList = [Select Id , Customer_Document__c, Customer_Document__r.Customer__c, Quantity__c, QTO_CDLI_Matched_Quoted_Quantity__c,
				QTO_CDLI_Matched_Contracted_Quantity__c, Customer_Document__r.Status__c from 
				Customer_Document_Line_Items__c where Customer_Document__c =:cdId and Status__c IN('Exception-Matching(Lines)', 'Partial Matched')];
	
		System.debug('cdlineList...'+cdlineList.size());
		if(cdlineList.size()>0)  {
			QTO_CDLineItemMatchingHelper.matchCdLineItems(cdlineList);
			List<Customer_Document_Line_Items__c> lines = findAllCDLines(cdId);
			//QTO_CDLineItemMatchingHelper.updateCDocStatus(lines);
			QTOCustomerDocumentUtil.updateCustomerDocumentStatus(new Set<Id>{cdId}, 'LINEITEM');
			QTO_CDLineItemMatchingHelper.updateQuoteAndAgreementAcceptance(lines) ;
		}
	}

	@AuraEnabled
	public static void reEnrichmentCustomerDocumentLineItems(String cdId) {
		system.debug('cdId...'+cdId);
		List<Customer_Document_Line_Items__c> cdlineList = [Select Id,High_level_Product__c,High_level_Product_Description__c,QTO_PDF_Unit_Of_Measure__c,QTO_PDF_Quantity__c,QTO_PDF_Unit_Price__c,
					QTO_PDF_Currency_Code__c,Detailed_Product__c,Detailed_Product_Description__c, Quantity__c, QTO_Unit_of_Measure__c, QTO_Unit_Price__c, CurrencyIsoCode,
					QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c,Contract_Item_Number__c,QTO_PDF_Total_Value__c,QTO_PDF_Requested_Delivery_Date__c,
					Price_List_Item__c,Customer_Document__c,Customer_Document__r.Customer__c from Customer_Document_Line_Items__c where Customer_Document__c =:cdId AND Status__c IN ('Exception-Enrichment(Lines)','Draft with Exceptions')];
	
		System.debug('cdlineList...'+cdlineList.size());
		if(cdlineList.size()>0)  {
			//QTO_CustomerDocumentLineItem_Helper.lineItemEnrichment(cdlineList); 
			QTO_CdLineItemAssociationHelper.associateCdLineItems(cdlineList);
			List<Customer_Document_Line_Items__c> lines = findAllCDLines(cdId);
			//QTO_CDLineItemMatchingHelper.updateCDocStatus(lines);
			QTOCustomerDocumentUtil.updateCustomerDocumentStatus(new Set<Id>{cdId}, 'LINEITEM');
			QTO_CDLineItemMatchingHelper.updateQuoteAndAgreementAcceptance(lines) ;
		}
	}
	// DSI - 2150
	@AuraEnabled
	public static void reProcessManuallyEnrichedCustomerDocumentLineItems(String cdId) {
		system.debug('Calling reprocess manual enrichment for cdId...'+cdId);
		List<Customer_Document_Line_Items__c> manuallyEnrichedLines =  
		[SELECT Id,High_level_Product__c,High_level_Product_Description__c,
		QTO_PDF_Unit_Of_Measure__c,QTO_PDF_Quantity__c,QTO_PDF_Unit_Price__c, 
		QTO_PDF_Currency_Code__c,Detailed_Product__c,Detailed_Product_Description__c,
		Quantity__c, QTO_Unit_of_Measure__c, QTO_Unit_Price__c, CurrencyIsoCode, 
		QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c,
		Contract_Item_Number__c,QTO_PDF_Total_Value__c,QTO_PDF_Requested_Delivery_Date__c,
		Price_List_Item__c,Customer_Document__c,Customer_Document__r.Customer__c 
		FROM Customer_Document_Line_Items__c 
		WHERE Customer_Document__c = :cdId AND
		Status__c = 'Manually-Enriched(Lines)'];
	
		System.debug('found manuallyEnrichedLines...'+manuallyEnrichedLines.size());
		if(manuallyEnrichedLines.size()>0)  {
			//  QTO_CustomerDocumentLineItem_Helper.lineItemEnrichment(manuallyEnrichedLines); 
			QTO_CdLineItemAssociationHelper.associateCdLineItems(manuallyEnrichedLines);
			List<Customer_Document_Line_Items__c> lines = findAllCDLines(cdId);
			//QTO_CDLineItemMatchingHelper.updateCDocStatus(lines);
			QTOCustomerDocumentUtil.updateCustomerDocumentStatus(new Set<Id>{cdId}, 'LINEITEM');
			QTO_CDLineItemMatchingHelper.updateQuoteAndAgreementAcceptance(lines) ;
			System.debug('Updating manually enriched cd lines...');
		}
	}   

	private static List<Customer_Document_Line_Items__c> findAllCDLines(String cusDocId) {
		
		List<Customer_Document_Line_Items__c> cdLineList = [Select Id,High_level_Product__c,High_level_Product_Description__c,Detailed_Product_Code__c,Detailed_Product_Description__c,Site__c,
						QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c,QTO_Product_Name__r.Name,Contract_Item_Number__c,Price_List_Item__c,
						Customer_Document__c, Status__c, Association_Comment__c, QTO_CDLI_Matching_Comment__c,
						QTO_Association__c , Customer_Document__r.Customer__c, Quantity__c, QTO_CDLI_Matched_Quoted_Quantity__c, 
						QTO_CDLI_Matched_Contracted_Quantity__c, Customer_Document__r.Status__c 
						from Customer_Document_Line_Items__c where Customer_Document__c =:cusDocId];
		return cdLineList;
	}



	/*
	@AuraEnabled
	public static string getBatchStatus_V1(String clsName,String batchId, String cdId) {
		system.debug('clsName...'+clsName);
		system.debug('batchId...'+batchId);
		system.debug('cdId...'+cdId);
		List<Customer_Document_Line_Items__c> cdlineList = [Select Id,High_level_Product__c,High_level_Product_Description__c,QTO_PDF_Unit_Of_Measure__c,QTO_PDF_Quantity__c,QTO_PDF_Unit_Price__c,
					QTO_PDF_Currency_Code__c,Detailed_Product__c,Detailed_Product_Description__c, Quantity__c, QTO_Unit_of_Measure__c, QTO_Unit_Price__c, CurrencyIsoCode,
					QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c,Contract_Item_Number__c,QTO_PDF_Total_Value__c,QTO_PDF_Requested_Delivery_Date__c,
					Price_List_Item__c,Customer_Document__c,Customer_Document__r.Customer__c from Customer_Document_Line_Items__c where Customer_Document__c =:cdId AND Association_Comment__c='Association Failed'];
	
		System.debug('cdlineList...'+cdlineList.size());
		if(cdlineList.size()>0)  {
			QTO_CdLineItemAssociationHelper.associateCdLineItems(cdlineList);
		}

		//CustomerFacingAttributeTrigger
		String jobStatus ='Completed';
		List<String> JOB_STATUS_LIST = new List<String>{'Completed','Failed','Aborted'};
		string JOB_TYPE = 'BatchApex';
		String query = 'SELECT Id,status FROM AsyncApexJob WHERE ApexClass.Name =:clsName AND Status NOT IN:JOB_STATUS_LIST AND JobType=:JOB_TYPE';
		if(batchId !=''){
			query += ' AND Id =: batchId';
		}
		List<AsyncApexJob> jobInfo = Database.Query(query);
		if(jobInfo !=NULL && jobInfo.size()>0){
			jobStatus = jobInfo[0].status;
		}
		return jobStatus;
	}
	*/

	@AuraEnabled
	public static Id submitBatchJob(String cdId){
		Set<String> docIdSet = new Set<String>{cdId};
		QTO_CustomerDocumentAssociationBatch cda = new QTO_CustomerDocumentAssociationBatch(docIdSet);
		Id batchId = Database.executeBatch(cda,1);
		system.debug('batch Id :'+batchId);
		return batchId;
	}
	 
	// DSI-2331
	@AuraEnabled
	public static void reProcessDraftWithExceptionsCustomerDocument(String recordId) {
		if (String.isBlank(recordId)) { throw new AuraHandledException('Invalid recordId'); }
		
		List<Customer_Document__c> customerDocuments =
			[SELECT Id, QTO_PDF_Customer_Name__c, Customer__c FROM Customer_Document__c WHERE Id = :Id.valueOf(recordId)];
		for (Customer_Document__c customerDocument : customerDocuments) {
			customerDocument.Status__c = QTO_Constants.CUSTOMER_DOCUMENT_REGISTRATION_STATUS;
		}
		try { QTO_CustomerDocument_Helper.updateCustomerDocument(customerDocuments); }
		catch(Exception exc) { throw new AuraHandledException(exc.getMessage()); }
		
	}
}