/**
* @Name: QTO_CDParser
* @Author: Raj Kamdar
* @CreateDate: 11/02/2020
* @Description: Parser to help on auto-association flow.
---------------------------------------------------------------------------------------------
* @LastModifiedBy: <LastModifiedBy>
* @LastModifiedDate: <LastModifiedDate>
* @ChangeDescription: <ChangeDescription>
**/
public with sharing class QTO_CDParser {
	
	private static final String PDF_QUOTE_REF = 'PDF Quote Ref';
	private static final String CONTRACT_REF = 'PDF CONTRACT REF';
	// DSI-2322
	private static final String ATTRIBUTE_LABEL_PDFSITECODE = 'PDF SITE CODE';
	private static final String ATTRIBUTE_LABEL_PDFOPPORTUNITYREF = 'PDF OPPORTUNITY REF';
	
	public static Map<Id,QTO_CDParsingWrapper> parseAllAssociationData(Set<Id> setCustomerDocumentIds){
		Map<Id,QTO_CDParsingWrapper> mapReturnData = new Map<Id,QTO_CDParsingWrapper>();
		System.debug('Main parsing method');
		mapReturnData = parseAllAssociationData(QTO_QuoteLineItemAssociationController.getAllCDLIfromCD(setCustomerDocumentIds));
		return mapReturnData;
	}
	
	/**
	* @description: Parses all header and line item level quote/agreement references from a Customer Document into a wrapper.
	* @author Raj Kamdar
	* @param mapCDData: Map of line items per each customer document.
	* @return Map<String,QTO_CDParsingWrapper>: Parsed wrapper map.
	**/
	public static Map<Id,QTO_CDParsingWrapper> parseAllAssociationData(Map<Id,List<Customer_Document_Line_Items__c>> mapCDData){
		Map<Id,QTO_CDParsingWrapper> mapReturnData = new Map<Id,QTO_CDParsingWrapper>();
		System.debug('Parse Data');
		Set<Id> setCustomerDocumentIDs = mapCDData.keySet();
		System.debug('CDIDs: '+setCustomerDocumentIDs);
		Set<Id> setCDLIIDs = getAllAssociatedCDLI(mapCDData);
		System.debug('CDLIIDs: '+setCDLIIDs);
		mapReturnData = parseHeaderAssociationData(setCustomerDocumentIDs);
		mapReturnData = parseLineItemAssociationData(setCDLIIDs,mapReturnData);
		return mapReturnData;
	}
	
	/**
	* @description: Parses all header references from a Customer Document into a wrapper.
	* @author Raj Kamdar
	* @param setCustomerDocumentIDs: Set of all Customer Document IDs to be parsed.
	* @return Map<String,QTO_CDParsingWrapper>: Parsed wrapper map.
	**/
	public static Map<Id,QTO_CDParsingWrapper> parseHeaderAssociationData(Set<Id> setCustomerDocumentIDs){
		Map<Id,QTO_CDParsingWrapper> mapReturnData = new Map<Id,QTO_CDParsingWrapper>();
		System.debug('Inside Method');
		for(Id customerDocumentId: setCustomerDocumentIDs){
			System.debug('Inside Loop');
			mapReturnData.put(customerDocumentId,new QTO_CDParsingWrapper());
		}
		for(Customer_facing_Attribute__c currentAttribute:[select id,name,QTO_Customer_Document__c,Attribute_Label__c,Attribute_Value__c from Customer_facing_Attribute__c where QTO_Customer_Document__c in :setCustomerDocumentIDs]){
			   system.debug('in for');
			QTO_CDParsingWrapper currentWrapper;
			if(mapReturnData.containsKey(currentAttribute.QTO_Customer_Document__c)){
				currentWrapper = mapReturnData.get(currentAttribute.QTO_Customer_Document__c);
			}
			else{
				currentWrapper = new QTO_CDParsingWrapper();
				currentWrapper.customerDocumentId = currentAttribute.QTO_Customer_Document__c;
			}
			if(currentAttribute.Attribute_Label__c.equalsIgnoreCase(CONTRACT_REF)){
				currentWrapper.setHeaderAgreements.add(currentAttribute.Attribute_Value__c);
			}
			else if(currentAttribute.Attribute_Label__c.equalsIgnoreCase(PDF_QUOTE_REF)){
				currentWrapper.setHeaderQuotes.add(currentAttribute.Attribute_Value__c);
			}
			// DSI-2322 collect pdf site codes from cd cfas
			else if(currentAttribute.Attribute_Label__c == ATTRIBUTE_LABEL_PDFSITECODE) {
				currentWrapper.pdfSiteCodeRefs.add(currentAttribute.Attribute_Value__c);
			}
			// DSI-2322 collect pdf opportunity refs from cd cfas
			else if(currentAttribute.Attribute_Label__c == ATTRIBUTE_LABEL_PDFOPPORTUNITYREF) {
				currentWrapper.pdfOpportunityRefs.add(currentAttribute.Attribute_Value__c);
			}
			mapReturnData.put(currentAttribute.QTO_Customer_Document__c,currentWrapper);
		}
		system.debug('mapReturnDatamapReturnData'+mapReturnData);
		return mapReturnData;
	}
	
	/**
	* @description: Combines all applicable CD Line Items into a single set.
	* @author Raj Kamdar
	* @param mapCDData: Map containing Line Item data for each Customer Document.
	* @return Set<Id>: Set of all CDLI IDs inputted.
	**/
	private static Set<Id> getAllAssociatedCDLI(Map<Id,List<Customer_Document_Line_Items__c>> mapCDData){
		Set<Id> setReturnData = new Set<Id>();
		List<Customer_Document_Line_Items__c> listCDLIs = new List<Customer_Document_Line_Items__c>();
		for(Id currentId: mapCDData.keySet()){
			listCDLIs.addAll(mapCDData.get(currentId));
		}
			
		for(Customer_Document_Line_Items__c currentCDLI: listCDLIs){
			setReturnData.add(currentCDLI.Id);
		}
		return setReturnData;
	}

	/**
	* @description: Parses all line item references from a Customer Document into a wrapper.
	* @author Raj Kamdar
	* @param setCDLIs: Set of all Customer Document LI IDs to be parsed.
	* @param mapWrapperData: Map of already parsed data at header level.
	* @return Map<String,QTO_CDParsingWrapper>: Parsed wrapper map.
	**/
	private static Map<Id,QTO_CDParsingWrapper> parseLineItemAssociationData(Set<Id> setCDLIs, Map<Id,QTO_CDParsingWrapper> mapWrapperData){
		for(Id currentId: mapWrapperData.keySet()){
			QTO_CDParsingWrapper currentWrapper = mapWrapperData.get(currentId);
			currentWrapper.setCDOLineItems = setCDLIs;
			mapWrapperData.put(currentId,currentWrapper);
		}
		for(Customer_facing_Attribute__c currentAttribute:[select id,name,QTO_Customer_Document__c,Attribute_Label__c,Attribute_Value__c,QTO_Customer_Document_Line_Items__c,QTO_Customer_Document_Line_Items__r.Customer_Document__c from Customer_facing_Attribute__c where QTO_Customer_Document_Line_Items__c in :setCDLIs]){
			QTO_CDParsingWrapper currentWrapper = mapWrapperData.get(currentAttribute.QTO_Customer_Document_Line_Items__r.Customer_Document__c);
			if(currentAttribute.Attribute_Label__c!=null && currentAttribute.Attribute_Label__c.equalsIgnoreCase(PDF_QUOTE_REF)){
				currentWrapper.setLineItemQuotes.add(currentAttribute.Attribute_Value__c);
			}
			else if(currentAttribute.Attribute_Label__c!=null && currentAttribute.Attribute_Label__c.equalsIgnoreCase(CONTRACT_REF)){
				currentWrapper.setLineItemAgreements.add(currentAttribute.Attribute_Value__c);
			}
			// DSI-2322 collect pdf site codes from cd cfas
			else if(currentAttribute.Attribute_Label__c == ATTRIBUTE_LABEL_PDFSITECODE) {
				currentWrapper.pdfSiteCodeRefs.add(currentAttribute.Attribute_Value__c);
			}
			// DSI-2322 collect pdf opportunity refs from cd cfas
			else if(currentAttribute.Attribute_Label__c == ATTRIBUTE_LABEL_PDFOPPORTUNITYREF) {
				currentWrapper.pdfOpportunityRefs.add(currentAttribute.Attribute_Value__c);
			}
			mapWrapperData.put(currentAttribute.QTO_Customer_Document_Line_Items__r.Customer_Document__c,currentWrapper);
		}
		return mapWrapperData;
	}
}