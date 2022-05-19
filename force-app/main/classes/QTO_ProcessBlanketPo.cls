/*********************************************************************
* Class Name : QTO_ProcessBlanketPo
* Test Class : QTO_ProcessBlanketPoTest
* Created Date: 16 Feb 2022
* Created By : Shaik Johny Basha
* Description : DSI-2410 Blanket PO chnages
*******************************************************************/
public with sharing class QTO_ProcessBlanketPo {
	static Map<String,QTO_Exception_Configuration__mdt> exceptionConfigMetaData = new Map<String,QTO_Exception_Configuration__mdt>();
	static List<QTO_Customer_Document_Issue_Log__c> issueLogList = new List<QTO_Customer_Document_Issue_Log__c>();
	static List<Customer_Document__c> updatedCDList = new List<Customer_Document__c>(); 
	static Map<Id,Customer_Document_Line_Items__c> sanityFailureMap = new Map<Id,Customer_Document_Line_Items__c>();
	static QTO_Customer_Document_Issue_Log__c  issueLog = null;
	static QTO_Exception_Configuration__mdt exceptionMetadata = null;
	
	
	public static void procesBlanketPO(Set<Id> cdIds) {
		System.debug('Process Blanket PO ....');
		List<Customer_Document_Line_Items__c> updatedCdLines = new List<Customer_Document_Line_Items__c>();
		List<Customer_Document__c> updatedList  = new List<Customer_Document__c>();
		Boolean sanityCheck=false;
		if(!cdIds.isEmpty()) {
			fetchExceptionConfigMetaData();
			//Customer Documents
			 Map<Id, Customer_Document__c> customerDocMap  =  findAllCustomerDocumentsById(cdIds);
			
			//Customer Document Lines
			Map<Id,List<Customer_Document_Line_Items__c>> customerDocumentLineMap  = findAllCDLinesByCusDocId(cdIds);
			for (Id customerDocId : customerDocumentLineMap.keySet())
			{
				for (Customer_Document_Line_Items__c  cdLineItem: customerDocumentLineMap.get(customerDocId))
				{
					//1001 Error Code
		exceptionMetadata = exceptionConfigMetaData.get('CDLI Registration 1001');
	  	//Basic Sanity Check
		sanityCheck = cdLineSanityCheck(customerDocMap.get(customerDocId), cdLineItem, customerDocMap.get(customerDocId).Id, exceptionMetadata);
		System.debug('Sanity Result...'+sanityCheck);
		if(!sanityCheck) {
						cdLineItem.QTO_CDLI_Matched_Quoted_Quantity__c = 0;
						cdLineItem.QTO_CDLI_Matched_Contracted_Quantity__c = 0;
						cdLineItem.Contract_Item_Number__c = cdLineItem.High_level_Product__c;
						cdLineItem.Status__c = QTO_Constants.STATUS_MANUAL_ENRICHED;
						cdLineItem.Association_Comment__c = 'Association Waiver';
						cdLineItem.QTO_CDLI_Matching_Comment__c = 'Matching Waiver';
						cdLineItem.QTO_CDLI_Association_Waiver_Comment__c = 'Yes';
						cdLineItem.QTO_CDLI_Association_Waiver_Comment__c = 'Yes';
						updateLineItemsFields(cdLineItem);
						updatedCdLines.add(cdLineItem);
					}
					else{
			updatedCdLines.add(cdLineItem);
		}
				}
				System.debug('sanityFailureMap....'+ sanityFailureMap);
	if(sanityFailureMap.size() > 0 && sanityFailureMap != NULL) {
		createTask(customerDocMap.get(customerDocId).Id);   
	}
			}
			
			if(updatedCdLines.size()>0){
				update updatedCdLines;
			}
			
			if(issueLogList.size()>0){
				upsert issueLogList;
			}
		}
	}
	  
	public static Boolean cdLineSanityCheck(Customer_Document__c cdoc, Customer_Document_Line_Items__c cdLineItem , Id  cdId, QTO_Exception_Configuration__mdt exceptionMetadata) {
		System.debug('cdLineSanityCheck>>>>>>>');
		
		if(String.isBlank(cdLineItem.QTO_PDF_Currency_Code__c)) {
			cdLineItem.QTO_PDF_Currency_Code__c = cdLineItem.Customer_Document__r.QTO_Currency__c;
		}
		
		if(String.isBlank(cdLineItem.QTO_PDF_Unit_Of_Measure__c)) {
			cdLineItem.QTO_PDF_Unit_Of_Measure__c = 'Each';
		}
		//DSI-2148 - Point -3
		if(cdoc.QTO_Nature__c == QTO_Constants.CANCEL) {
			if(cdLineItem.High_level_Product__c == null && cdLineItem.High_level_Product_Description__c == null 
	  && cdLineItem.Detailed_Product__c == null  && cdLineItem.Detailed_Product_Description__c == null ) {
	   cdLineItem.Status__c =  QTO_Constants.STATUS_ENRICHMENT_FAILED;
	   issueLog = createIssueLog(cdId, cdLineItem.Id, exceptionMetadata.QTO_Return_Type__c, String.valueOf(exceptionMetadata.QTO_Return_Code__c), exceptionMetadata.QTO_Log_Details__c);   
	   issueLogList.add(issueLog);
	   sanityFailureMap.put(cdLineItem.Id, cdLineItem);
	   return true;		 
	  } 
		}
		else {
			if(cdLineItem.High_level_Product__c == null || cdLineItem.QTO_PDF_Unit_Of_Measure__c == null || cdLineItem.QTO_PDF_Unit_Price__c == null
	  ||cdLineItem.QTO_PDF_Quantity__c ==null || cdLineItem.QTO_PDF_Currency_Code__c == null) {
	   cdLineItem.Status__c =  QTO_Constants.STATUS_ENRICHMENT_FAILED;
	   issueLog = createIssueLog(cdId, cdLineItem.Id, exceptionMetadata.QTO_Return_Type__c, String.valueOf(exceptionMetadata.QTO_Return_Code__c), exceptionMetadata.QTO_Log_Details__c);   
	   issueLogList.add(issueLog);
	   sanityFailureMap.put(cdLineItem.Id, cdLineItem);
	   return true;		 
	  }
		}
		return false;
	}
	
	
	
	
	@TestVisible
	private static void createTask(Id cusDocId) {
		QTO_Exception_Configuration__mdt exceptionMetadata = exceptionConfigMetaData.get('CDLI Registration 1001');
		
		Task task = QTO_CustomerDocument_Helper.createTask(cusDocId, String.valueOf(exceptionMetadata.QTO_Return_Code__c) , exceptionMetadata.QTO_Tasks_Status__c, exceptionMetadata.QTO_Task_Subject__c, exceptionMetadata.QTO_Log_Details__c, exceptionMetadata.QTO_Investigating_Group__c);
		insert task ;
	}
	
	public static Map<Id,Customer_Document__c> findAllCustomerDocumentsById(Set<Id> cdIds) {
		
		Map<Id,Customer_Document__c> customerDocumenttMap = new Map<Id,Customer_Document__c>
			(
				[
					Select Id, Name, Status__c, QTO_Nature__c, Classification__c from Customer_Document__c where Id In : cdIds
				]
			); 
		return customerDocumenttMap;
	}
	
	
	@TestVisible
	private static void updateLineItemsFields(Customer_Document_Line_Items__c cdLineItem) {
		cdLineItem.CurrencyIsoCode = cdLineItem.QTO_PDF_Currency_Code__c;
		System.debug('cdLineItem.CurrencyIsoCode>>>>'+cdLineItem.CurrencyIsoCode);
		cdLineItem.QTO_Unit_of_Measure__c = cdLineItem.QTO_PDF_Unit_Of_Measure__c;
		cdLineItem.Quantity__c = cdLineItem.QTO_PDF_Quantity__c;
		
		try{
			cdLineItem.Total_Value__c = Decimal.valueOf(QTO_CustomerDocument_Helper.formatCurrency(cdLineItem.QTO_PDF_Total_Value__c));
		} catch (Exception e){
			System.debug('*****error updating Total_Value__c on Customer_Document_Line_Items__c: '+e.getMessage());
		}
		
		try{
			cdLineItem.QTO_Unit_Price__c = Decimal.valueOf(QTO_CustomerDocument_Helper.formatCurrency(cdLineItem.QTO_PDF_Unit_Price__c));
		} catch (Exception e){
			System.debug('*****error updating QTO_Unit_Price__c on Customer_Document_Line_Items__c: '+e.getMessage());
		}
		
		try{
			cdLineItem.QTO_Requested_Delivery_Date__c = QTO_CustomerDocument_Helper.getDocumentDate(cdLineItem.QTO_PDF_Requested_Delivery_Date__c);
		} catch (Exception e){
			System.debug('*****error updating QTO_Requested_Delivery_Date__c on Customer_Document_Line_Items__c: '+e.getMessage());
		}
		
		try{
			cdLineItem.Net_Value__c = cdLineItem.QTO_Unit_Price__c != null ? cdLineItem.QTO_Unit_Price__c : null;
		} catch (Exception e){
			System.debug('*****error updating Net_Value__c on Customer_Document_Line_Items__c: '+e.getMessage());
		}
		
	}
	
	
	//To create Customer Document Issue log related to the Customer Document
	public static QTO_Customer_Document_Issue_Log__c createIssueLog(Id cdId,  Id cdLineId, String errorType, String returnCode, String issueDetails) {
		QTO_Customer_Document_Issue_Log__c issueLog = new QTO_Customer_Document_Issue_Log__c();
		issueLog.QTO_CustomerDocumentId__c = cdId;
		issueLog.QTO_CustomerDocumentItemId__c = cdLineId;
		issueLog.QTO_ErrorType__c = errorType; 
		issueLog.QTO_Return_Code__c = returnCode;
		issueLog.QTO_IssueDetails__c = issueDetails;
		return issueLog;
	}
	//fetch Exception Metadata
	private static void fetchExceptionConfigMetaData() {
		for(QTO_Exception_Configuration__mdt metadata :[select id, MasterLabel, QualifiedApiName,QTO_Return_Code__c,QTO_Return_Description__c,QTO_Return_Type__c,QTO_Task_Subject__c,QTO_Tasks_Due_Date__c,QTO_Tasks_Priority__c,QTO_Tasks_Status__c,QTO_Investigating_Group__c,QTO_Log_Details__c from QTO_Exception_Configuration__mdt]){
			exceptionConfigMetaData.put(metadata.MasterLabel, metadata);
		}
	}
	
	/**
	* @description: Find all customer document lines by customer document ids.
	* @param Set of customer document ids
	* @return Map<Id,List<Customer_Document_Line_Items__c>>
	**/
	public static Map<Id,List<Customer_Document_Line_Items__c>> findAllCDLinesByCusDocId(Set<Id> customerDocIds) {
		
		Map<Id,List<Customer_Document_Line_Items__c>> custDocLineItemMap = new Map<Id,List<Customer_Document_Line_Items__c>>();
		
		for(Id customerDocumentId: customerDocIds){
			custDocLineItemMap.put(customerDocumentId,new List<Customer_Document_Line_Items__c>());
		}
		
		List<Customer_Document_Line_Items__c> customerDocLines =   
			[
				Select Id,  High_level_Product__c, High_level_Product_Description__c, Detailed_Product_Code__c, Detailed_Product__c, Detailed_Product_Description__c, 
				Site__c, QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c, QTO_Product_Name__r.Name, Contract_Item_Number__c, Price_List_Item__c, 
				Customer_Document__c, QTO_PDF_Unit_Price__c, QTO_Unit_Price__c,  QTO_PDF_Unit_Of_Measure__c, QTO_Unit_of_Measure__c, QTO_PDF_Quantity__c, 
				Quantity__c, QTO_PDF_Currency_Code__c, CurrencyIsoCode, QTO_PDF_Total_Value__c, Total_Value__c,QTO_PDF_Requested_Delivery_Date__c,
				QTO_Requested_Delivery_Date__c, QTO_CDLI_Matched_Quoted_Quantity__c,QTO_CDLI_Matched_Contracted_Quantity__c, Association_Comment__c, 
				QTO_Association__c, QTO_CDLI_Matching_Comment__c, Status__c,Customer_Document__r.Status__c, Customer_Document__r.Sub_Classification__c, 
				Customer_Document__r.Customer__c, Customer_Document__r.QTO_Currency__c
				from Customer_Document_Line_Items__c where Customer_Document__c IN :customerDocIds 
			];
		
		if(!customerDocLines.isEmpty()){
			for (Customer_Document_Line_Items__c custDoclineItem: customerDocLines){  
				if(custDocLineItemMap.containsKey(custDoclineItem.Customer_Document__c)){
					custDocLineItemMap.get(custDoclineItem.Customer_Document__c).add(custDoclineItem);
				}else{
					custDocLineItemMap.put(custDoclineItem.Customer_Document__c ,new list<Customer_Document_Line_Items__c>{custDoclineItem}); 
				}
			}	
		}				
		system.debug('custDocLineItemMap'+custDocLineItemMap);
		return custDocLineItemMap;
	}
	
	
   
}