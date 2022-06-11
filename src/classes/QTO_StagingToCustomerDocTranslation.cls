/******************************************************************************************************
Name : QTO_StagingToCustomerDocTranslation
Created Date: 2 September 2020
Created by: Bogdan Botcharov
Test class : QTO_StagingToCustomerDocTranslationTest
Description : Translate PEGA JSON response in DS_Staging__c object into Customer_Document__c and related records
*********************************************************************************************************/
public with sharing class QTO_StagingToCustomerDocTranslation {
	@future
	public static void translatePayloadToDocument(Set<Id> newDSStagingIds){  
		System.debug('<<<<<<<<<<<<<<<<<translatePayloadToDocument>>>>>>>>');
		List<Customer_Document__c> listCustomerDocuments = new List<Customer_Document__c>();
		Map<String,Case> mapStagingToCase = new Map<String,Case>();
		
		Map<Id,DocumentWrapperSO> mapDSStagingToWrapper = new Map<Id,DocumentWrapperSO>();
		
		Map<Id,DS_Staging__c> mapDSStagingSO = new Map<Id,DS_Staging__c>([SELECT Id, Name, DS_Payload__c, QTO_Received_From_PEGA__c FROM DS_Staging__c WHERE Id IN: newDSStagingIds]);
		for(DS_Staging__c dSStagingSO : mapDSStagingSO.values()){
			DocumentWrapperSO docWrapperSO = (DocumentWrapperSO)System.JSON.deserialize(dSStagingSO.DS_Payload__c, DocumentWrapperSO.class);				 
			mapDSStagingToWrapper.put(dSStagingSO.Id, docWrapperSO);
		}
		
		mapStagingToCase = getCase(mapDSStagingToWrapper); 
		System.debug('mapStagingToCase...'+mapStagingToCase);
		if(!mapStagingToCase.isEmpty()){
			for(Id dsStagingId : mapDSStagingToWrapper.keySet()){
				DocumentWrapperSO docWrapperSO = mapDSStagingToWrapper.get(dsStagingId);
				
				Customer_Document__c customerDocumentSO = new Customer_Document__c();
				customerDocumentSO.DS_Staging__c = dsStagingId;			
				customerDocumentSO.CurrencyIsoCode = docWrapperSO.Header.OCR_CURRENCY_INFO;
				customerDocumentSO.QTO_Currency__c = docWrapperSO.Header.OCR_CURRENCY_INFO;
				customerDocumentSO.QTO_Customer_Postal_Code__c = docWrapperSO.Header.OCR_CUSTOMER_POSTAL_CODE;
				customerDocumentSO.QTO_PDF_Customer_Name__c = docWrapperSO.Header.OCR_CUSTOMER_NAME;
				customerDocumentSO.QTO_Nokia_Legal_Entity_Postal_Code__c = docWrapperSO.Header.OCR_NOKIA_LEGAL_ENTITY_POSTAL_CODE;			
				customerDocumentSO.QTO_Classification__c = docWrapperSO.Header.OCR_CUSTOMER_DOCUMENT_CLASSIFICATION;
				customerDocumentSO.QTO_Sub_Classification__c = docWrapperSO.Header.OCR_CUSTOMER_DOCUMENT_SUB_CLASSIFICATION;
				customerDocumentSO.QTO_PDF_Nature__c = docWrapperSO.Header.OCR_CUSTOMER_DOCUMENT_NATURE;
				customerDocumentSO.QTO_Nokia_Legal_Entity_Info__c = docWrapperSO.Header.OCR_NOKIA_LEGAL_ENTITY_INFO;
				customerDocumentSO.QTO_Customer_Document_Date__c = docWrapperSO.Header.OCR_CUSTOMER_DOCUMENT_DATE;
				customerDocumentSO.QTO_Customer_Contact_Commercial__c = docWrapperSO.Header.OCR_CUSTOMER_CONTACT_COMMERCIAL;
				customerDocumentSO.QTO_Customer_Contact_Delivery__c = docWrapperSO.Header.OCR_CUSTOMER_CONTACT_DELIVERY;
				customerDocumentSO.QTO_Customer_Reference__c = docWrapperSO.Header.OCR_CUSTOMER_REFERENCE;
				customerDocumentSO.Customer_Delivery_Address__c = docWrapperSO.Header.OCR_CUSTOMER_DELIVERY_ADDRESS_INFO;
				customerDocumentSO.Customer_Document_ID__c = docWrapperSO.Header.OCR_CUSTOMER_DOCUMENT_ID;
				customerDocumentSO.Customer_Invoicing_Address__c = docWrapperSO.Header.OCR_CUSTOMER_INVOICING_ADDRESS_INFO;
				customerDocumentSO.QTO_INCO_Terms__c = docWrapperSO.Header.OCR_INCO_TERM_INFO;
				customerDocumentSO.QTO_File_Reference__c = docWrapperSO.Header.PDF_FILE_REFERENCE_c;
				customerDocumentSO.Nokia_Document_Receipt_Date__c = Date.today();
				customerDocumentSO.QTO_Payment_Terms__c = docWrapperSO.Header.OCR_PAYMENT_TERM_INFO;
				customerDocumentSO.QTO_Nokia_Legal_Entity_Account__c = docWrapperSO.Header.OCR_NOKIA_LEGAL_ENTITY_NAME;
				customerDocumentSO.Comment__c = docWrapperSO.Header.Comment != null ? docWrapperSO.Header.Comment : null;
				customerDocumentSO.QTO_PDF_Place_of_Delivery_Shipment__c = docWrapperSO.Header.OCR_PLACE_OF_DELIVERY_SHIPMENT;
				customerDocumentSO.QTO_PDF_Total_Value__c = docWrapperSO.Header.OCR_TOTAL_VALUE != null ? docWrapperSO.Header.OCR_TOTAL_VALUE : null;
				customerDocumentSO.Status__c = 'Draft';
				
				customerDocumentSO.Case__c = mapStagingToCase.get(docWrapperSO.Header.SF_CASE_ID) != null ? mapStagingToCase.get(docWrapperSO.Header.SF_CASE_ID).Id : null;			
				customerDocumentSO.QTO_OfferingType__c = docWrapperSO.Header.PEGA_CUSTOMER_DOCUMENT_OFFERING_TYPE; 
				listCustomerDocuments.add(customerDocumentSO);
			}
			try { 
				System.debug('<<<<<<<<<<<<<<<<Before Insert into CD>>>>>>>>>>>>>>>>>');
				insert listCustomerDocuments;
			} catch (Exception e){
				System.debug('*****error inserting Customer_Document__c: '+e.getMessage());
			}
			
			//Insert List Customer_facing_Attribute__c
			List<Customer_facing_Attribute__c> listHeaderAttributes = new List<Customer_facing_Attribute__c>();
			
			for(Customer_Document__c cdSO : listCustomerDocuments){
				if(mapDSStagingToWrapper.get(cdSO.DS_Staging__c) != null){
					
					DocumentWrapperSO docWrapperSO = mapDSStagingToWrapper.get(cdSO.DS_Staging__c);
					
					if(docWrapperSO.Header.Header_attribute != null){
						for(headerAttributes hA : docWrapperSO.Header.Header_attribute){
							Customer_facing_Attribute__c cfaSO = new Customer_facing_Attribute__c();
							cfaSO.QTO_Customer_Document__c = cdSO.Id;
							cfaSO.Attribute_Label__c = hA.OCR_HDS_ATTRIBUTE_LABEL;
							cfaSO.Attribute_Value__c = ha.OCR_HDS_ATTRIBUTE_VALUE;
							listHeaderAttributes.add(cfaSO);
						}
					}
				}
			}
			
			if(!listHeaderAttributes.isEmpty()){
				try{
					insert listHeaderAttributes;
				} catch (Exception e){
					System.debug('*****error inserting Customer_facing_Attribute__c: '+e.getMessage());
				}
			}
			
			//Insert List Customer_Document_Line_Items__c
			List<Customer_Document_Line_Items__c> listCustDocLineItemSO = new List<Customer_Document_Line_Items__c>();
			Map<Integer,List<Line_item_attribute>> mapLineItemAttributes = new Map<Integer,List<Line_item_attribute>>();
			Map<Integer,Line_items> mapLineItems = new Map<Integer,Line_items>();
			Integer liTempId = 0;
			
			for(Customer_Document__c cdSO : listCustomerDocuments){
				if(mapDSStagingToWrapper.get(cdSO.DS_Staging__c) != null){
					for(Line_items docLISO : mapDSStagingToWrapper.get(cdSO.DS_Staging__c).Line_items){
						liTempId += 1;
						Customer_Document_Line_Items__c docLineItemSO = new Customer_Document_Line_Items__c();
						docLineItemSO.Customer_Document__c = cdSO.Id;
						docLineItemSO.QTO_System_Temp_Id__c = liTempId;
						docLineItemSO.High_level_Product__c = docLISO.OCR_CUSTOMER_PRODUCT_CODE;
						docLineItemSO.High_level_Product_Description__c = docLISO.OCR_CUSTOMER_PRODUCT_DESCRIPTION;
						docLineItemSO.Detailed_Product__c = docLISO.OCR_INTERNAL_PRODUCT_CODE; // HCL added for SF 01771107
						//docLineItemSO.QTO_Unit_of_Measure__c = docLISO.OCR_ITEM_UNIT_OF_MEASURE;
						docLineItemSO.QTO_PDF_Unit_Of_Measure__c = docLISO.OCR_ITEM_UNIT_OF_MEASURE;
						docLineItemSO.QTO_PDF_Total_Value__c = docLISO.OCR_ITEM_TOTAL_VALUE;
						docLineItemSO.QTO_PDF_Quantity__c = docLISO.OCR_ITEM_QUANTITY;
						// docLineItemSO.Quantity__c = docLISO.OCR_ITEM_QUANTITY;
						docLineItemSO.QTO_PDF_Unit_Price__c = docLISO.OCR_ITEM_PRICE_UNIT;
						docLineItemSO.QTO_PDF_Requested_Delivery_Date__c = docLISO.OCR_REQUESTED_DELIVERY_DATE;
						//docLineItemSO.CurrencyIsoCode = cdSO.CurrencyIsoCode;
						docLineItemSO.QTO_PDF_Currency_Code__c = cdSO.CurrencyIsoCode;
						listCustDocLineItemSO.add(docLineItemSO);
						mapLineItems.put(liTempId,docLISO);
						if(docLISO.Line_item_attribute != null)
							mapLineItemAttributes.put(liTempId,docLISO.Line_item_attribute);
					}
				}
			}
			if(!listCustDocLineItemSO.isEmpty()){
				try{
					insert listCustDocLineItemSO;
				} catch (Exception e){
					System.debug('*****error inserting Customer_Document__c: '+e.getMessage());
				}
			}
			
			List<Customer_facing_Attribute__c> listLineItemAttributes = new List<Customer_facing_Attribute__c>();
			
			for(Customer_Document_Line_Items__c cdLISO : listCustDocLineItemSO){
				if(mapLineItems != null && mapLineItems.get(Integer.valueOf(cdLISO.QTO_System_Temp_Id__c)) != null){
					
					try{
						if(mapLineItemAttributes != null && mapLineItemAttributes.get(Integer.valueOf(cdLISO.QTO_System_Temp_Id__c)) != null){
							for(Line_item_attribute liaSO : mapLineItemAttributes.get(Integer.valueOf(cdLISO.QTO_System_Temp_Id__c))){
								Customer_facing_Attribute__c cfaLISO = new Customer_facing_Attribute__c();
								cfaLISO.Attribute_Label__c = liaSO.OCR_ITS_ATTRIBUTE_LABEL;
								cfaLISO.Attribute_Value__c = liaSO.OCR_ITS_ATTRIBUTE_VALUE;
								cfaLISO.QTO_Customer_Document_Line_Items__c = cdLISO.Id;
								listLineItemAttributes.add(cfaLISO);
								
								if(liaSO.OCR_ITS_ATTRIBUTE_LABEL == 'Site' && liaSO.OCR_ITS_ATTRIBUTE_VALUE != null)
									cdLISO.Site__c = liaSO.OCR_ITS_ATTRIBUTE_VALUE;
							}
						}
					} catch (Exception e){
						System.debug('*****error assigning scanned values to Customer_facing_Attribute__c: '+e.getMessage());
					}
				}
			}
			
			try {
				update listCustDocLineItemSO;
			} catch(Exception e){
				System.debug('*****error updating Customer_Document_Line_Items__c: '+e.getMessage());
			}
			
			if(!listLineItemAttributes.isEmpty()){
				try{
					insert listLineItemAttributes;
				} catch(Exception e){
					System.debug('****error inserting Customer_facing_Attribute__c: '+e.getMessage());
				}
			}
		}
	}
	
	public static Map<String,Case> getCase(Map<Id,DocumentWrapperSO> mapWrapperSO){
		
		Set<String> caseNumbers = new Set<String>();
		for(DocumentWrapperSO docWrapSO : mapWrapperSO.values()){
			if(docWrapSO.Header.SF_CASE_ID != null)
				caseNumbers.add(docWrapSO.Header.SF_CASE_ID);
		}
		
		Map<String,Case> mapCases = new Map<String,Case>();
		for(Case caseSO : [SElECT Id, CaseNumber FROM Case WHERE CaseNumber IN: caseNumbers]){
			mapCases.put(caseSO.CaseNumber,caseSO);
		}
		
		return mapCases;
	}
	
	public class DocumentWrapperSO {
		public Header Header;
		public List<Line_items> Line_items;
	}
	
	public class Header {
		public String OCR_CUSTOMER_DOCUMENT_NATURE;// DSI-2200
		public String PEGA_CUSTOMER_DOCUMENT_OFFERING_TYPE; // DSI-2210
		public String OCR_CURRENCY_INFO;
		public String OCR_CUSTOMER_CONTACT_COMMERCIAL;
		public String OCR_CUSTOMER_CONTACT_DELIVERY;
		public String OCR_CUSTOMER_DELIVERY_ADDRESS_INFO;
		public String OCR_CUSTOMER_DOCUMENT_CLASSIFICATION;
		public String OCR_CUSTOMER_DOCUMENT_SUB_CLASSIFICATION;//DSI-2195
		public String OCR_CUSTOMER_DOCUMENT_DATE;
		public String OCR_CUSTOMER_DOCUMENT_ID;
		public String OCR_CUSTOMER_INVOICING_ADDRESS_INFO;
		public String OCR_CUSTOMER_INVOICING_ADDRESS_NAME;
		public String OCR_CUSTOMER_POSTAL_CODE;
		public String OCR_NOKIA_LEGAL_ENTITY_POSTAL_CODE;
		public String OCR_CUSTOMER_NAME;
		public String OCR_CUSTOMER_REFERENCE;
		public String OCR_INCO_TERM_INFO;
		public String OCR_NOKIA_LEGAL_ENTITY_INFO;
		public String OCR_NOKIA_LEGAL_ENTITY_NAME;
		public String OCR_NOKIA_REFERENCE;
		public String OCR_PAYMENT_TERM_INFO;
		public String OCR_PLACE_OF_DELIVERY_SHIPMENT;
		public String OCR_TOTAL_VALUE;
		public String PEGA_CASE_CREATED_BY;
		public String PEGA_CASE_ID;
		public String PEGA_OMC_MANAGER_EMAIL;
		public String SF_CASE_CREATED_BY;
		public String SF_CASE_ID;
		public String SF_CASE_WEB_MAIL;
		public String PDF_FILE_REFERENCE_c;
		public String TAX_ID_COUNTRY;		 
		public String Comment;
		public List<headerAttributes> Header_attribute;
	}
	
	public class Line_items {
		public String OCR_CUSTOMER_DOCUMENT_LINE_ITEM;
		public String OCR_ITEM_TOTAL_VALUE;
		public String OCR_ITEM_UNIT_OF_MEASURE;
		public String OCR_REQUESTED_DELIVERY_DATE;
		public String OCR_CUSTOMER_PRODUCT_CODE;
		public String OCR_CUSTOMER_PRODUCT_DESCRIPTION;
		public String OCR_ITEM_PRICE_UNIT;
		public String OCR_ITEM_QUANTITY;
		public String Result;
		//public Integer lineItemIdentifier = 0;
		public string OCR_INTERNAL_PRODUCT_CODE; // HCL added for sf 01771107
		public List<Line_item_attribute> Line_item_attribute;
	}
	
	public class Line_item_attribute {
		public String OCR_ITS_ATTRIBUTE_LABEL;
		public String OCR_ITS_ATTRIBUTE_VALUE;
		public String pxObjClass;
	}
	
	public class headerAttributes {
		public String OCR_HDS_ATTRIBUTE_LABEL;
		public String OCR_HDS_ATTRIBUTE_VALUE;
		public String pxObjClass;
	}
}