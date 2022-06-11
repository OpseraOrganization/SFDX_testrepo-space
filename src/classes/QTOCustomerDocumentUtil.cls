/**
* @description	   : Utility Class for Customer document line items processing
* @author			: Shaik, Johny 
* @Created on	 : 09-19-2021
**/
public with sharing class  QTOCustomerDocumentUtil {
	
	public static Customer_Document__c findAllCDLinesByCusDocId(Id cusDocId, String type) {
		
		System.debug('QTOCustomerDocumentUtil >>> ' + cusDocId);
		List<String> CD_STATUS ;
		List<String> CD_LINE_STATUS;
		
		if(type == QTO_Constants.ENRICHMENT) {
			CD_STATUS = new List<String> {QTO_Constants.CD_STATUS_LINES_HANDOFF, QTO_Constants.STATUS_ENRICHMENT_FAILED };
			CD_LINE_STATUS = new List<String> {NULL, QTO_Constants.STATUS_ENRICHMENT_FAILED};
		}
		
		if(type == QTO_Constants.ASSOCIATION) {
			CD_STATUS = new List<String> {QTO_Constants.STATUS_ENRICHED , QTO_Constants.STATUS_MANUAL_ENRICHED, QTO_Constants.STATUS_ASSOCIATION_FAILED };
			CD_LINE_STATUS = new List<String> {QTO_Constants.STATUS_ENRICHED , QTO_Constants.STATUS_MANUAL_ENRICHED, QTO_Constants.STATUS_ASSOCIATION_FAILED};
		}
		
		List<Customer_Document__c> customerDocData =   
			[
				Select Id, Name, QTO_Nature__c, Customer__c, QTO_Customer_Account_Number__c, Nokia_Legal_Entity_Account__c, Nokia_Legal_Entity_Account_Number__c, Classification__c, Status__c,
				(
					Select Id,  High_level_Product__c, High_level_Product_Description__c, Detailed_Product_Code__c, Detailed_Product__c, Detailed_Product_Description__c, 
					Site__c, QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c, QTO_Product_Name__r.Name, Contract_Item_Number__c, Price_List_Item__c, Customer_Document__c, 
					QTO_PDF_Unit_Price__c, QTO_Unit_Price__c,  QTO_PDF_Unit_Of_Measure__c, QTO_Unit_of_Measure__c, QTO_PDF_Quantity__c, Quantity__c, QTO_PDF_Currency_Code__c, CurrencyIsoCode, 
					QTO_PDF_Total_Value__c, Total_Value__c,QTO_PDF_Requested_Delivery_Date__c, QTO_Requested_Delivery_Date__c, 
					QTO_CDLI_Matched_Quoted_Quantity__c,QTO_CDLI_Matched_Contracted_Quantity__c, Association_Comment__c, QTO_Association__c, 
					QTO_CDLI_Matching_Comment__c, Status__c,Customer_Document__r.Status__c, Customer_Document__r.Sub_Classification__c, 
					Customer_Document__r.Customer__c, Customer_Document__r.QTO_Currency__c 
					from Customer_Document_Line_Items__r WHERE Status__c IN:  CD_LINE_STATUS
				),
				(
					Select Id, Quote_Proposal__c, QTO_Quote_Ref_in_PDF__c, Quote_Proposal_Name__c,Matches_Quote__c, Customer_Document__c 
					from Customer_Document_Junctions__r order by Quote_Proposal__r.CreatedDate 
				),
				(
					Select Id, QTO_Agreement__c, QTO_Agreement_Ref_in_PDF__c,QTO_Agreement_Status__c,QTO_Customer_Document__c 
					from Customer_Document_Agreements__r
				),
				(
					Select Id,Quote__c,Attribute_Label__c,Attribute_Value__c, QTO_Customer_Document_Line_Items__c,QTO_Customer_Document__c 
					from Customer_Facing_Attributes__r
				) 
				from Customer_Document__c where Id =: cusDocId  AND  Status__c IN: CD_STATUS
			];
		
		System.debug('customerDocData.size()  >>>> '+customerDocData.size() );
		if(customerDocData.size() >0 ) {
			return customerDocData[0];
		}
		return null;
	}
	
	public static List<Customer_Document__c> findAllCdLinesByStatus(Set<Id> customerDocIds, String cdStatus) {
		List<Customer_Document__c> customerDocData =   
			[
				Select Id,Name,QTO_Nature__c, Customer__c,Classification__c, Sub_Classification__c,
				(
					Select Id,High_level_Product__c,High_level_Product_Description__c,QTO_PDF_Unit_Of_Measure__c,QTO_PDF_Quantity__c,QTO_PDF_Unit_Price__c,
					QTO_PDF_Currency_Code__c,Detailed_Product__c,Detailed_Product_Description__c, Quantity__c, QTO_Unit_of_Measure__c, QTO_Unit_Price__c, CurrencyIsoCode,
					QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c,Contract_Item_Number__c,QTO_PDF_Total_Value__c,QTO_PDF_Requested_Delivery_Date__c,
					Price_List_Item__c,Customer_Document__c,Customer_Document__r.Customer__c, Customer_Document__r.QTO_Currency__c
					from Customer_Document_Line_Items__r
				)
				from Customer_Document__c where Id =: customerDocIds  AND Status__c =: cdStatus
			];
		
		return customerDocData;
	}
	
	public static List<Apttus_Proposal__Proposal__c> findAllAssociatedQuotes(Id cusDocId, List<String> pdfQuoteReferences, String soldToParty) {
		List<Apttus_Proposal__Proposal__c> allQuotes = 
			[
				Select Id,NokiaCPQ_Proposal_Id__c,Nokia_Customer_Document_ID__c,Apttus_Proposal__Account__c,
				Agreement_Lookup__c,Apttus_QPConfig__PriceListId__c,Sold_To_Party__c,
				(
					Select Id,Name,NokiaCPQ_Product_Name__c,Apttus_QPConfig__PriceListItemId__c, Apttus_Proposal__Proposal__c, Apttus_QPConfig__PriceListItemId__r.DS_Grouping_Name__c,
					Apttus_Proposal__Proposal__r.Name, Apttus_Proposal__Proposal__r.NokiaCPQ_Proposal_Id__c, Apttus_Proposal__Proposal__r.Id,
					Apttus_Proposal__Product__c,DS_Grouping_Name__c,Product_Code__c, Apttus_Proposal__Product__r.ProductCode,
					External_Reference__c, Apttus_Proposal__Quantity__c, Apttus_QPConfig__Quantity2__c, QTO_QLI_Matched_Risk_Quantity__c,
					Apttus_QPConfig__Uom__c, Apttus_QPConfig__NetUnitPrice__c, Apttus_Proposal__Proposal__r.CurrencyIsoCode, QTO_QL_Available_Quantity__c
					FROM Apttus_Proposal__R00N70000001yUfBEAU__r WHERE Apttus_QPConfig__LineType__c = 'Product/Service'
				)	
				FROM Apttus_Proposal__Proposal__c WHERE  (Nokia_Customer_Document_ID__c =: cusDocId 
				OR (NokiaCPQ_Proposal_Id__c =: pdfQuoteReferences OR NAME IN :pdfQuoteReferences))
				AND Apttus_Proposal__Approval_Stage__c = 'Approved' 
				AND (Sold_to_Party__c =: soldToParty  OR Account_Legal_Entity__c =: soldToParty)
				ORDER BY CreatedDate
			];
		return allQuotes;
	}
	
	public static List<String> findCfasByAttributeType(Id cusDocId, String type) {
		List<String> references = new List<String>();
		List<Customer_facing_Attribute__c> allCusfacingAttributes = 
			[
				Select Id,Attribute_Label__c,Attribute_Value__c,QTO_Customer_Document_Line_Items__c, QTO_Customer_Document__c 
				from Customer_facing_Attribute__c 
				 where  Attribute_Label__c IN ('PDF QUOTE REF','PDF CONTRACT REF')
				AND QTO_Customer_Document__c =: cusDocId
			];
		for(Customer_facing_Attribute__c cfa : allCusfacingAttributes) {
			if(cfa.Attribute_Label__c == type) {
				if(cfa.QTO_Customer_Document__c != NULL ) {
					references.add(cfa.Attribute_Value__c);
				}
			}
		}
		return references;
	}
	
	/**findAllQuoteLinesBySoldToParty*/
	public static Map<Id,Apttus_Proposal__Proposal_Line_Item__c> findAllQuoteLinesBySoldToParty(String soldtoParty) {
		
		Map<Id,Apttus_Proposal__Proposal_Line_Item__c> soldToPartyLines = new Map<Id,Apttus_Proposal__Proposal_Line_Item__c>
			(
				[
					Select Id,Name,NokiaCPQ_Product_Name__c,Apttus_QPConfig__PriceListItemId__c, Apttus_Proposal__Proposal__c, Apttus_QPConfig__PriceListItemId__r.DS_Grouping_Name__c,
					Apttus_Proposal__Proposal__r.Name, Apttus_Proposal__Proposal__r.NokiaCPQ_Proposal_Id__c, Apttus_Proposal__Proposal__r.Id,
					Apttus_Proposal__Product__c,DS_Grouping_Name__c,Product_Code__c, Apttus_Proposal__Product__r.ProductCode,
					External_Reference__c, Apttus_Proposal__Quantity__c, Apttus_QPConfig__Quantity2__c, QTO_QLI_Matched_Risk_Quantity__c,
					Apttus_QPConfig__Uom__c, Apttus_QPConfig__NetUnitPrice__c, Apttus_Proposal__Proposal__r.CurrencyIsoCode, QTO_QL_Available_Quantity__c  
					FROM Apttus_Proposal__Proposal_Line_Item__c
					WHERE (Apttus_Proposal__Proposal__r.Sold_to_Party__c =: soldtoParty OR Apttus_Proposal__Proposal__r.Account_Legal_Entity__c =: soldtoParty)
					AND Apttus_Proposal__Proposal__r.Apttus_Proposal__Approval_Stage__c = 'Approved'
					AND Apttus_QPConfig__LineType__c = 'Product/Service'
					ORDER BY  Apttus_Proposal__Proposal__r.CreatedDate
				]
			); 
		return soldToPartyLines;
	}
	
	public static List<Customer_Document__c> findByCustomerDocumentId(List<Id> cdocIds) {
		List<Customer_Document__c> customerDocs = 
			[
	Select Id,Name, Case__c, Case__r.CH_Status__c, QTO_Classification__c,Classification__c, QTO_Sub_Classification__c, Sub_Classification__c,
	QTO_PDF_Nature__c,QTO_Nature__c, QTO_PDF_Customer_Name__c, QTO_Customer_Postal_Code__c,Customer__c,QTO_Customer_Document_Date__c,QTO_Payment_Terms__c,Payment_terms__c,
	QTO_Nokia_Legal_Entity_Account__c, Nokia_Legal_entity__c,Nokia_Legal_Entity_Account__c,Nokia_Legal_Entity_Postal_Code__c, QTO_Nokia_Legal_Entity_Postal_Code__c,
	QTO_Customer_Contact_Commercial__c,QTO_Customer_Contact_Delivery__c,QTO_Currency__c,QTO_PDF_Total_Value__c,Total_Value__c,Status__c,QTO_Error_Message__c,
	QTO_Inco_Terms__c,Inco_Terms__c,QTO_T_C_Match__c,isDuplicate__c, Comment__c, Customer_Document_ID__c,Requested_Delivery_Date__c,QTO_PDF_Requested_Delivery_Date__c,
				QTO_Line_Iteam_Association_Comment__c,QTO_Line_Item_Matching_Comment__c, QTO_Line_Item_Association__c, QTO_Line_Item_Matching__c,Version_Nr__c,
				QTO_PDF_Place_of_Delivery_Shipment__c,Customer_Invoicing_Address__c,QTO_File_Reference__c,QTO_External_Contract_reference__c, CurrencyIsoCode,
				Customer_Contact_delivery__c,Customer_Contact_commercial__c,QTO_Line_Item_Match__c, QTO_Association_comment__c,QTO_Match_comment__c,
				QTO_OfferingType__c,QTO_External_Contractquoteoffer_ref__c,QTO_Document_Link__c,
				Customer_Delivery_Address__c, QTO_Nokia_Legal_Entity_Info__c, QTO_Customer_Reference__c, Customer_Document_Date__c,Nokia_Document_Receipt_Date__c,
	(
		Select Id,High_level_Product__c,High_level_Product_Description__c,QTO_PDF_Unit_Of_Measure__c,QTO_PDF_Quantity__c,QTO_PDF_Unit_Price__c,
		QTO_PDF_Currency_Code__c,Detailed_Product__c,Detailed_Product_Description__c, QTO_Unit_of_Measure__c, QTO_Unit_Price__c, CurrencyIsoCode,
		QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c,Contract_Item_Number__c,Net_Value__c,Quantity__c,Total_Value__c,
		QTO_PDF_Total_Value__c,QTO_Requested_Delivery_Date__c,QTO_PDF_Requested_Delivery_Date__c,
					
		Price_List_Item__c,Customer_Document__c,Customer_Document__r.Customer__c
		from Customer_Document_Line_Items__r
	)
	from Customer_Document__c where Id In:cdocIds
			];
		
		return customerDocs;
	}
	
	public static List<Customer_Document_Line_Items__c> findAllCDLines(List<Id> allCusDocLineIds) {
		
		List<Customer_Document_Line_Items__c> cdLineList = [Select Id,High_level_Product__c,High_level_Product_Description__c,Detailed_Product_Code__c,Detailed_Product_Description__c,Site__c,
															QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c,QTO_Product_Name__r.Name,Contract_Item_Number__c,Price_List_Item__c,
															Customer_Document__c, Status__c, Association_Comment__c, QTO_CDLI_Matching_Comment__c,
															QTO_Association__c , QTO_CDLI_Association_Waiver_Comment__c, QTO_CDLI_Matching_Waiver_Comment__c, Customer_Document__r.Customer__c, Quantity__c, QTO_CDLI_Matched_Quoted_Quantity__c, 
															QTO_CDLI_Matched_Contracted_Quantity__c, Customer_Document__r.Status__c 
						from Customer_Document_Line_Items__c where id IN :allCusDocLineIds];
		return cdLineList;
	}
	
	public static Map<Id, List<Customer_Document_Line_Items__c>> findAllCDocAndCDocLinesByCdIdsAndStatus(Set<Id> cdocIds, String cdStatus) {
		Map<Id,List<Customer_Document_Line_Items__c>> customerDocLineMap = new Map<Id,List<Customer_Document_Line_Items__c>>();
		List<Customer_Document__c> customerDocs = 
			[
	Select Id,Name, Case__c, Case__r.CH_Status__c, QTO_Classification__c,Classification__c, QTO_Sub_Classification__c, Sub_Classification__c,
	QTO_PDF_Nature__c,QTO_Nature__c, QTO_PDF_Customer_Name__c, QTO_Customer_Postal_Code__c,Customer__c,QTO_Customer_Document_Date__c,QTO_Payment_Terms__c,Payment_terms__c,
	QTO_Nokia_Legal_Entity_Account__c, Nokia_Legal_entity__c,Nokia_Legal_Entity_Account__c,Nokia_Legal_Entity_Postal_Code__c, QTO_Nokia_Legal_Entity_Postal_Code__c,
	QTO_Customer_Contact_Commercial__c,QTO_Customer_Contact_Delivery__c,QTO_Currency__c,QTO_PDF_Total_Value__c,Total_Value__c,Status__c,QTO_Error_Message__c,
	QTO_Inco_Terms__c,Inco_Terms__c,QTO_T_C_Match__c,isDuplicate__c, Comment__c, Customer_Document_ID__c,Requested_Delivery_Date__c,QTO_PDF_Requested_Delivery_Date__c,
				QTO_Line_Iteam_Association_Comment__c,QTO_Line_Item_Matching_Comment__c, QTO_Line_Item_Association__c, QTO_Line_Item_Matching__c,Version_Nr__c,
				QTO_PDF_Place_of_Delivery_Shipment__c,Customer_Invoicing_Address__c,QTO_File_Reference__c,QTO_External_Contract_reference__c, CurrencyIsoCode,
				Customer_Contact_delivery__c,Customer_Contact_commercial__c,QTO_Line_Item_Match__c, QTO_Association_comment__c,QTO_Match_comment__c,
				QTO_OfferingType__c,QTO_External_Contractquoteoffer_ref__c,QTO_Document_Link__c,
				Customer_Delivery_Address__c, QTO_Nokia_Legal_Entity_Info__c, QTO_Customer_Reference__c, Customer_Document_Date__c,Nokia_Document_Receipt_Date__c,
	(
		Select Id,High_level_Product__c,High_level_Product_Description__c,QTO_PDF_Unit_Of_Measure__c,QTO_PDF_Quantity__c,QTO_PDF_Unit_Price__c,
		QTO_PDF_Currency_Code__c,Detailed_Product__c,Detailed_Product_Description__c, QTO_Unit_of_Measure__c, QTO_Unit_Price__c, CurrencyIsoCode,
		QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c,Contract_Item_Number__c,Net_Value__c,Quantity__c,Total_Value__c,
		QTO_PDF_Total_Value__c,QTO_Requested_Delivery_Date__c,QTO_PDF_Requested_Delivery_Date__c,Status__c,
					Association_Comment__c, QTO_CDLI_Matching_Comment__c, QTO_Association__c , QTO_CDLI_Association_Waiver_Comment__c, 
					QTO_CDLI_Matching_Waiver_Comment__c, QTO_CDLI_Matched_Quoted_Quantity__c, 
					QTO_CDLI_Matched_Contracted_Quantity__c,
		Price_List_Item__c
		from Customer_Document_Line_Items__r 
	)
	from Customer_Document__c where Id In:cdocIds AND Status__c =: cdStatus
			];
		
		if(!customerDocs.isEmpty()) {
			for(Customer_Document__c cDoc : customerDocs) {
				List<Customer_Document_Line_Items__c> cdLines = new List<Customer_Document_Line_Items__c>();
				for(Customer_Document_Line_Items__c lineItem:  cDoc.Customer_Document_Line_Items__r) {
					cdLines.add(lineItem);
				}
				customerDocLineMap.put(cDoc.Id,cdLines);
			}
		}
		return customerDocLineMap;
	}
	
	
	public static Map<Id, List<Customer_Document_Line_Items__c>> findAllCDocAndCDocLinesByCdIds(Set<Id> cdocIds) {
		Map<Id,List<Customer_Document_Line_Items__c>> customerDocLineMap = new Map<Id,List<Customer_Document_Line_Items__c>>();
		List<Customer_Document__c> customerDocs = 
			[
	Select Id,Name, Case__c, Case__r.CH_Status__c, QTO_Classification__c,Classification__c, QTO_Sub_Classification__c, Sub_Classification__c,
	QTO_PDF_Nature__c,QTO_Nature__c, QTO_PDF_Customer_Name__c, QTO_Customer_Postal_Code__c,Customer__c,QTO_Customer_Document_Date__c,QTO_Payment_Terms__c,Payment_terms__c,
	QTO_Nokia_Legal_Entity_Account__c, Nokia_Legal_entity__c,Nokia_Legal_Entity_Account__c,Nokia_Legal_Entity_Postal_Code__c, QTO_Nokia_Legal_Entity_Postal_Code__c,
	QTO_Customer_Contact_Commercial__c,QTO_Customer_Contact_Delivery__c,QTO_Currency__c,QTO_PDF_Total_Value__c,Total_Value__c,Status__c,QTO_Error_Message__c,
	QTO_Inco_Terms__c,Inco_Terms__c,QTO_T_C_Match__c,isDuplicate__c, Comment__c, Customer_Document_ID__c,Requested_Delivery_Date__c,QTO_PDF_Requested_Delivery_Date__c,
				QTO_Line_Iteam_Association_Comment__c,QTO_Line_Item_Matching_Comment__c, QTO_Line_Item_Association__c, QTO_Line_Item_Matching__c,Version_Nr__c,
				QTO_PDF_Place_of_Delivery_Shipment__c,Customer_Invoicing_Address__c,QTO_File_Reference__c,QTO_External_Contract_reference__c, CurrencyIsoCode,
				Customer_Contact_delivery__c,Customer_Contact_commercial__c,QTO_Line_Item_Match__c, QTO_Association_comment__c,QTO_Match_comment__c,
				QTO_OfferingType__c,QTO_External_Contractquoteoffer_ref__c,QTO_Document_Link__c,
				Customer_Delivery_Address__c, QTO_Nokia_Legal_Entity_Info__c, QTO_Customer_Reference__c, Customer_Document_Date__c,Nokia_Document_Receipt_Date__c,
	(
		Select Id,High_level_Product__c,High_level_Product_Description__c,QTO_PDF_Unit_Of_Measure__c,QTO_PDF_Quantity__c,QTO_PDF_Unit_Price__c,
		QTO_PDF_Currency_Code__c,Detailed_Product__c,Detailed_Product_Description__c, QTO_Unit_of_Measure__c, QTO_Unit_Price__c, CurrencyIsoCode,
		QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c,Contract_Item_Number__c,Net_Value__c,Quantity__c,Total_Value__c,
		QTO_PDF_Total_Value__c,QTO_Requested_Delivery_Date__c,QTO_PDF_Requested_Delivery_Date__c,Status__c,
					Association_Comment__c, QTO_CDLI_Matching_Comment__c, QTO_Association__c , QTO_CDLI_Association_Waiver_Comment__c, 
					QTO_CDLI_Matching_Waiver_Comment__c, QTO_CDLI_Matched_Quoted_Quantity__c, 
					QTO_CDLI_Matched_Contracted_Quantity__c,
		Price_List_Item__c
		from Customer_Document_Line_Items__r 
	)
	from Customer_Document__c where Id In:cdocIds
			];
		
		if(!customerDocs.isEmpty()) {
			for(Customer_Document__c cDoc : customerDocs) {
				List<Customer_Document_Line_Items__c> cdLines = new List<Customer_Document_Line_Items__c>();
				for(Customer_Document_Line_Items__c lineItem:  cDoc.Customer_Document_Line_Items__r) {
					cdLines.add(lineItem);
				}
				customerDocLineMap.put(cDoc.Id,cdLines);
			}
		}
		return customerDocLineMap;
	}
	
	public static Map<Id,Customer_Document__c> findAllCustomerDocumentsById(Set<Id> cdIds) {
		
		Map<Id,Customer_Document__c> customerDocumenttMap = new Map<Id,Customer_Document__c>
			(
				[
					Select Id, Name, Status__c,Customer__c, QTO_Line_Iteam_Association_Comment__c
					, QTO_Line_Item_Matching_Comment__c, QTO_Customer_Name__c from Customer_Document__c where Id In : cdIds
				]
			); 
		return customerDocumenttMap;
	}
	
	

	/**
	* @description: Update customer document status in different stages
	* @param cusDocIds : Set of all  Customer Documents.
	* @param statusType: Define the document type (HEADER/LINE).
	* @return 
	**/  
	public static void updateCustomerDocumentStatus(Set<Id> cusDocIds, String statusType) {
		System.debug('QTOCustomerDocumentUtil  >> updateCustomerDocumentStatus >>>> ' + statusType);
		
		Map<Id, List<Customer_Document_Line_Items__c>> cdLinesMap = new Map<Id, List<Customer_Document_Line_Items__c>>();
		Map<Id, Customer_Document__c> cusdocsMap = new Map<Id, Customer_Document__c>();
		List<Customer_Document__c> updatedList = new List<Customer_Document__c>();
		if(!cusDocIds.isEmpty()) {
			cdLinesMap =  findAllCDocAndCDocLinesByCdIds(cusDocIds);
			cusdocsMap =  findAllCustomerDocumentsById(cusDocIds);
			if(statusType == 'HEADER') {
				System.debug('HEADER level processing ');
				for(Customer_Document__c customerDocData : cusdocsMap.values()) {
					String cdStatus = customerDocData.Status__c;
					System.debug('HEADER level processing ' + customerDocData.Status__c);
					if(customerDocData.Status__c == QTO_Constants.EXCEPTION_ASSOCIATION) {
						customerDocData = QTO_CustomerDocumentMaturityLevel.processMaturityLevel(customerDocData, QTO_Constants.EXCEPTION_ASSOCIATION);
					}
					else if(customerDocData.Status__c == QTO_Constants.EXCEPTION_HEADER_MISMATCH) {
						customerDocData = QTO_CustomerDocumentMaturityLevel.processMaturityLevel(customerDocData, QTO_Constants.EXCEPTION_HEADER_MISMATCH);
					}
					if(cdStatus != customerDocData.Status__c){
						updatedList.add(customerDocData);
					}
				}
			}
			else {
				for(Id cdId : cdLinesMap.keySet()) {
					Customer_Document__c customerDocData = cusdocsMap.get(cdId);
					Map<Id, Customer_Document_Line_Items__c>  enrichmentFailureMap = new Map<Id, Customer_Document_Line_Items__c>();
					Map<Id, Customer_Document_Line_Items__c>  enrichmentSuccessMap = new Map<Id, Customer_Document_Line_Items__c>();
					Map<Id, Customer_Document_Line_Items__c>  associationFailureMap = new Map<Id, Customer_Document_Line_Items__c>();
					Map<Id, Customer_Document_Line_Items__c>  matchingFailureMap = new Map<Id, Customer_Document_Line_Items__c>();
					
					for(Customer_Document_Line_Items__c cdLine : cdLinesMap.get(cdId)) {
						if(cdLine.Status__c == QTO_Constants.STATUS_ENRICHED) {
							enrichmentSuccessMap.put(cdLine.Id, cdLine);
						}
						if(cdLine.Status__c == QTO_Constants.STATUS_ENRICHMENT_FAILED) {
							enrichmentFailureMap.put(cdLine.Id, cdLine);
						}
						else if(cdLine.Status__c == QTO_Constants.STATUS_ASSOCIATION_FAILED
								&& (cdLine.QTO_CDLI_Association_Waiver_Comment__c =='No' || cdLine.QTO_CDLI_Association_Waiver_Comment__c =='Not Attempted')) 
						{
							associationFailureMap.put(cdLine.Id, cdLine);
						}
						else if((cdLine.Status__c == QTO_Constants.STATUS_MATCHING_FAILED || cdLine.Status__c =='Partial Matched')
								&& (cdLine.QTO_CDLI_Matching_Waiver_Comment__c =='No' || cdLine.QTO_CDLI_Matching_Waiver_Comment__c =='Not Attempted')) 
						{
							matchingFailureMap.put(cdLine.Id, cdLine);
						}					
					}
					if(!enrichmentFailureMap.isEmpty()) {
						customerDocData = QTO_CustomerDocumentMaturityLevel.processMaturityLevel(customerDocData, QTO_Constants.STATUS_ENRICHMENT_FAILED);
					}
					else if(!associationFailureMap.isEmpty()) {
						customerDocData = QTO_CustomerDocumentMaturityLevel.processMaturityLevel(customerDocData, QTO_Constants.STATUS_ASSOCIATION_FAILED);
					}
					else if(!matchingFailureMap.isEmpty()) {
						customerDocData = QTO_CustomerDocumentMaturityLevel.processMaturityLevel(customerDocData, QTO_Constants.STATUS_MATCHING_FAILED);
					}
					else {
						if(!enrichmentSuccessMap.isEmpty() && cdLinesMap.get(cdId).size() == enrichmentSuccessMap.size()) {
							customerDocData.Status__c = QTO_Constants.STATUS_ENRICHED;
						}
						else {
							// customerDocData.Status__c = QTO_Constants.CD_STATUS_LEGACY;
							customerDocData.Status__c = QTO_Constants.CD_STATUS_CPO_CREATION;
							customerDocData.QTO_Line_Iteam_Association_Comment__c = QTO_Constants.SUCCESSFUL;
							customerDocData.QTO_Line_Item_Matching_Comment__c = QTO_Constants.SUCCESSFUL;
						}
					}
					updatedList.add(customerDocData);
				}
			}
			
			if(!updatedList.isEmpty()) {
				update updatedList;  
			}
		}
	}
}