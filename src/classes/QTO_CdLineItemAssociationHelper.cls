/*********************************************************************
* Class Name  : QTO_CdLineItemAssociationHelper
* Test Class  : QTO_CdLineItemAssociationHelperTest
* Created Date: 14 Jun 2021
* Created By  : Kantam, Rithvik
* Description : This class is for Line item association
* Modified By : Shaik, Johny 
* Description : DSI-2148, DSI-2151, DSI-2153 
* ChangeDescription: Code Refactor & Removed unused methods.
*******************************************************************/
public with sharing class QTO_CdLineItemAssociationHelper {
	static Map<String,QTO_Exception_Configuration__mdt> exceptionConfigMetaData = new Map<String,QTO_Exception_Configuration__mdt>();
	static List<QTO_Customer_Document_Issue_Log__c> issueLogList = new List<QTO_Customer_Document_Issue_Log__c>();
	
	//update quantity for QuoteLineItems
	static Map<Id,Apttus_Proposal__Proposal_Line_Item__c>  updateQuoteLineItems = new  Map<Id,Apttus_Proposal__Proposal_Line_Item__c>();
	//update quantity for AgreementLineItems
	static Map<Id,Apttus__AgreementLineItem__c> updateAgreementLineItems = new Map<Id,Apttus__AgreementLineItem__c>();
	
	//Associated CDLine Quotes 
	static List<QTO_Customer_Document_Quote_Line__c>  associatedCdLineQuotes = new List<QTO_Customer_Document_Quote_Line__c>(); 
	//Associated CDLine Agreements
	static List<QTO_Customer_Document_Agreement_Line__c> associatedCdLineAgreements = new List<QTO_Customer_Document_Agreement_Line__c>();
	//associated CD Lines
	static List<Customer_Document_Line_Items__c> associatedCdLines = new List<Customer_Document_Line_Items__c>();	
	
	static QTO_Customer_Document_Issue_Log__c  issueLog=null;
	static QTO_Exception_Configuration__mdt exceptionMetadata = null;
	
	/**
	* @description: Fetch the Customer Document, If the Status = Enriched(Lines)'/'Exception-Association(Lines)
	* @param customerDocId 
	* @return Customer_Document__c 
	**/
	/*
	@TestVisible
	private static Customer_Document__c findCustomerDocumentById( Id customerDocId) {
		List<Customer_Document__c> customerDocData = 
			[
	Select Id,Name,Customer__c,QTO_Customer_Account_Number__c, Nokia_Legal_Entity_Account__c,Nokia_Legal_Entity_Account_Number__c, Classification__c,Status__c,
	(Select Id,High_level_Product__c,High_level_Product_Description__c,Detailed_Product_Code__c,Detailed_Product_Description__c,Site__c,
	 QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c,QTO_Product_Name__r.Name,Contract_Item_Number__c,
	 Price_List_Item__c,Customer_Document__c, QTO_Unit_Price__c, QTO_Unit_of_Measure__c,CurrencyIsoCode, Status__c, Association_Comment__c, QTO_CDLI_Matching_Comment__c,QTO_Association__c , Customer_Document__r.Customer__c, 
	 Quantity__c, QTO_CDLI_Matched_Quoted_Quantity__c,QTO_CDLI_Matched_Contracted_Quantity__c, Customer_Document__r.Status__c, Customer_Document__r.Sub_Classification__c
	 from Customer_Document_Line_Items__r where Status__c IN ('Enriched(Lines)','Manually-Enriched(Lines)','Exception-Association(Lines)')),
	(Select Id, QTO_Agreement__c, QTO_Agreement_Ref_in_PDF__c, QTO_Agreement_Status__c,QTO_Customer_Document__c from Customer_Document_Agreements__r),
		(Select Id,Quote__c,Attribute_Label__c,Attribute_Value__c, QTO_Customer_Document_Line_Items__c,QTO_Customer_Document__c 
	 	from Customer_Facing_Attributes__r) from Customer_Document__c where Id =:customerDocId AND Status__c IN ('Enriched(Lines)','Manually-Enriched(Lines)','Exception-Association(Lines)')
			];
		if(customerDocData.size()>0) {
			return customerDocData[0];
		}
		return null;
	}
	*/
	
	/**
	* @description: Fetch the Associated Quotes and Agreements for each CDLine
	* @param cusDocLines [List of Customer_Document_Line_Items__c]  
	**/
	public static void associateCdLineItems(List<Customer_Document_Line_Items__c> cusDocLines){
		System.debug('CDL Association  : >> ' +cusDocLines.size());
	
		Id customerDocId;
		String soldtoParty;
		String customer;
		Set<Id> allCusDocLineIds = new Set<Id>();
		
		Map<String,Apttus_Proposal__Proposal__c> quoteNameAndQuoteRecordMap = new Map<String,Apttus_Proposal__Proposal__c>();
		Map<Id,Apttus_Proposal__Proposal__c> quoteIdAndQuoteRecordMap = new Map<Id,Apttus_Proposal__Proposal__c>();
		Map<Id,List<Apttus__AgreementLineItem__c>> agreementAndLinesMap = new Map<Id,List<Apttus__AgreementLineItem__c>>();
		
		Map<Id,Id> associatedAgreementsMap = new Map<Id,Id>();
		Map<Id,Id> pdfQuoteRefQuoteIdAndAgreeIdMap = new Map<Id,Id>();
		
		Boolean hasException = false;
		Boolean hasMatchingException = false;
		Map<Id, Boolean> exceptionCDLineAssociation = new Map<Id, Boolean>();
		Map<Id, Boolean> exceptionCDLineMatching = new Map<Id, Boolean>();
	   
		//retrive the customer doc ids and Cdline-item ids
		for(Customer_Document_Line_Items__c cdLine : cusDocLines){
			customerDocId = cdLine.Customer_Document__c;
			allCusDocLineIds.add(cdLine.Id);
		}

		Customer_Document__c customerDocData = QTOCustomerDocumentUtil.findAllCDLinesByCusDocId(customerDocId, QTO_Constants.ASSOCIATION);
	
		if (customerDocData != null) {
			
			//Get soldToParty/Customer/Account for the CD
			if(customerDocData.Customer__c != Null){
	soldtoParty = customerDocData.Customer__c;
			}
			
			List<Customer_Document_Line_Items__c> cdLines = new List<Customer_Document_Line_Items__c>();
			for(Customer_Document_Line_Items__c cusDocLine : customerDocData.Customer_Document_Line_Items__r) {
	cdLines.add(cusDocLine);
			}
			
			//Approved Quote Line Items
			Map<Id,Apttus_Proposal__Proposal_Line_Item__c> soldToPartyApprovedQuoteLines = findAllQuotesBySoldToParty(soldtoParty);
			Map<Id,Apttus_Proposal__Proposal_Line_Item__c> accountApprovedQuoteLines = findAllQuotesByAccount(soldtoParty);
			System.debug('CDL Association  : >> soldToParty Quotes : ' + soldToPartyApprovedQuoteLines.size());
			System.debug('CDL Association  : >> account Quotes : ' + accountApprovedQuoteLines.size());
			
			//check whether the soldToParty has Approved quotes, if yes proceed otherwise update CD Lineitem status to Exception-Association(Lines)
			if(soldToPartyApprovedQuoteLines.isEmpty() && customerDocData.Customer_Document_Agreements__r.isEmpty()) {
	hasException = true;
	for(Customer_Document_Line_Items__c cusDocLine : cdLines) {
		cusDocLine.Status__c = QTO_Constants.STATUS_ASSOCIATION_FAILED;
		cusDocLine.QTO_Association__c = QTO_Constants.ASSOCIATION_FAILED;
		cusDocLine.Association_Comment__c = QTO_Constants.ASSOCIATION_FAILED;
		associatedCdLines.add(cusDocLine);
	}
			}
			else {
	  
	//get All Customer facing Attributes >> getAllCustomerFacingAttributes
	Map<String,List<Customer_facing_Attribute__c>> cusFacingAttributesMap = findAllCfaByCustomerDocId(customerDocId, allCusDocLineIds);
	  
	//Get All PDF QUOTE References from CFA 
	Set<String> pdfQuoteRefs = findAllCfaPdfQuoteRefs(cusFacingAttributesMap);
	//Get All PDF Contract References from CFA 
	Set<String> pdfContractRefs = findAllCfaPdfContractRefs(cusFacingAttributesMap);
	//Get All PDF SiteCode References from CFA 
	Map<Id,String> pdfSiteCodeRefs  = findAllCfaSiteCodeRefs(cusFacingAttributesMap);
	//Get All Anticipation References from CFA 
	Map<Id,String> anticipationRefs  = findAllCfaAnticipationRefs(cusFacingAttributesMap);
	
	//Get All Associated Quote/QuoteLines From Site codes  refs
	List<Customer_facing_Attribute__c> quoteSiteCodeCfaRefs = getCfaQuoteRefsByAttributeName(pdfSiteCodeRefs.values(),'SITE CODE', soldtoParty);
	
	//Get All Associated Quote/QuoteLines From Anticipation refs  
	List<Customer_facing_Attribute__c> quoteAnticipationCfaRefs = getCfaQuoteRefsByAttributeName(anticipationRefs.values(),'ANTICIPATION REF', soldtoParty);
	 
	//Get All Quotes and quoteLineItems from pdfQuoteRefs   
	if(!pdfQuoteRefs.isEmpty()) {
		List<Apttus_Proposal__Proposal__c> cusIdquotes  = findAllQuotesByCustomerDocId(customerDocData.Id, pdfQuoteRefs);
		if(!cusIdquotes.isEmpty()) {
			for(Apttus_Proposal__Proposal__c q : cusIdquotes) {
				pdfQuoteRefQuoteIdAndAgreeIdMap.put(q.Id,q.Agreement_Lookup__c);
			}
		}
	}
	
	//Get Associated Agreemets for the Customer Document 
	for(QTO_Customer_Document_Agreement__c cda : customerDocData.Customer_Document_Agreements__r) {
		associatedAgreementsMap.put(cda.QTO_Customer_Document__c,cda.QTO_Agreement__c);
	}  
	
	System.debug('CDL Association  : >> associatedAgreementsMap : ' + associatedAgreementsMap.size());

	//Get All Agreements from pdfContractRefs and associatedAgreements
	if(!pdfContractRefs.isEmpty() || !associatedAgreementsMap.isEmpty()) {
		List<Apttus__APTS_Agreement__c> allAgreements = findAllAgreementsByCustomerDocId(pdfContractRefs, associatedAgreementsMap);
		System.debug('allAgreements : '+ allAgreements);
		if(!allAgreements.isEmpty()) {
			for(Apttus__APTS_Agreement__c apAgree : allAgreements) {
				agreementAndLinesMap.put(apAgree.Id,apAgree.Apttus__AgreementLineItems__r);
			}
		}
	}
	
	System.debug('CDL Association  : >> agreementAndLinesMap : ' + agreementAndLinesMap.size());
	//Association logic
	System.debug('Association Logic');
	for(Customer_Document_Line_Items__c cusDocLine : cdLines) {
		System.debug('Association Logic >>> CDLine ' + cusDocLine.Id);
		Boolean isAssociationFound= false;
		Boolean isAgreementAssociationFound = false;
		
		if(cusFacingAttributesMap.containsKey('PDF QUOTE REF')) {
			isAssociationFound = isQuoteAssociationFound(cusDocLine, cusFacingAttributesMap.get('PDF QUOTE REF'), customerDocId, soldToPartyApprovedQuoteLines, accountApprovedQuoteLines, associatedCdLineQuotes,updateQuoteLineItems);
		}
		System.debug('Main logic - PDF QUOTE REF >> '+isAssociationFound);
		
		if(isAssociationFound == false && cusFacingAttributesMap.containsKey('PDF SITE CODE') && quoteSiteCodeCfaRefs.size() > 0) {
			isAssociationFound = isQuoteAssociationFoundByRefs(cusDocLine, quoteSiteCodeCfaRefs, customerDocId, soldToPartyApprovedQuoteLines, accountApprovedQuoteLines, associatedCdLineQuotes, pdfSiteCodeRefs, updateQuoteLineItems);
		}
		
		System.debug('Main logic - PDF SITE CODE >> '+isAssociationFound);
		
		if(isAssociationFound == false && cusFacingAttributesMap.containsKey('ANTICIPATION REF')&& quoteAnticipationCfaRefs.size() > 0) {
			isAssociationFound = isQuoteAssociationFoundByRefs(cusDocLine, quoteAnticipationCfaRefs, customerDocId, soldToPartyApprovedQuoteLines, accountApprovedQuoteLines, associatedCdLineQuotes, anticipationRefs, updateQuoteLineItems);
		}
		
		System.debug('Main logic - ANTICIPATION REF >> '+isAssociationFound);
		
		if(isAssociationFound == false) {
			isAssociationFound = isQuoteAssociationFoundByAllSoldToPartyLines(cusDocLine, customerDocId, soldToPartyApprovedQuoteLines, associatedCdLineQuotes, updateQuoteLineItems); 
			System.debug('isQuoteMatchedFromEntireLines >>>>'+isAssociationFound);
		}
		
		//Contract related refs
		if(isAssociationFound == false && pdfQuoteRefQuoteIdAndAgreeIdMap.size()> 0 ) {
			isAssociationFound = isQuoteAgreementAssociationByContRef(cusDocLine,  pdfQuoteRefQuoteIdAndAgreeIdMap, agreementAndLinesMap, associatedCdLineAgreements, updateAgreementLineItems); 
			System.debug('isQuoteAgreementAssociationByContRef >>>>'+isAssociationFound);
		}
		
		if(isAgreementAssociationFound == false && isAssociationFound == false && agreementAndLinesMap.size()> 0 ) {
			isAgreementAssociationFound = isAgreementAssociationByContractRef(cusDocLine,  agreementAndLinesMap, associatedCdLineAgreements, updateAgreementLineItems); 
			System.debug('isAgreementAssociationByContractRef >>>>'+isAgreementAssociationFound);
		}
		
		if(isAssociationFound || isAgreementAssociationFound) {
			cusDocLine.Status__c='Associated(Lines)';
			cusDocLine.Association_Comment__c ='Association Successful';
			cusDocLine.QTO_Association__c ='Association Successful';
			 
			if(cusDocLine.QTO_CDLI_Matching_Comment__c=='Matching Successful')
				cusDocLine.Status__c='Matched(Lines)';
			else if(cusDocLine.QTO_CDLI_Matching_Comment__c=='Matching Failed')
				cusDocLine.Status__c='Exception-Matching(Lines)';
			else
				cusDocLine.Status__c='Partial Matched';
			  
			associatedCdLines.add(cusDocLine);
			
		}
		else {
			cusDocLine.Status__c='Exception-Association(Lines)';
			cusDocLine.Association_Comment__c ='Association Failed';
			cusDocLine.QTO_Association__c ='Association Failed';
			associatedCdLines.add(cusDocLine);
		}
	}
			}
			
			if(associatedCdLineQuotes.size()>0) {
	insert associatedCdLineQuotes;
			}
			if(associatedCdLineAgreements.size()>0) {
	insert associatedCdLineAgreements;
			}
			if(associatedCdLines.size()>0) {
	update associatedCdLines;
			}
			if(issueLogList.size()>0) {
	exceptionMetadata = exceptionConfigMetaData.get('CDLI Match 5001');
	Task task = QTO_CustomerDocument_Helper.createTask(customerDocId, String.valueOf(exceptionMetadata.QTO_Return_Code__c) , exceptionMetadata.QTO_Tasks_Status__c, exceptionMetadata.QTO_Task_Subject__c, exceptionMetadata.QTO_Log_Details__c, exceptionMetadata.QTO_Investigating_Group__c);
	insert issueLogList;
	insert task;
			}
			
			
			System.debug('updateQuoteLineItems...'+updateQuoteLineItems);
			if(!updateQuoteLineItems.isEmpty()){
	update updateQuoteLineItems.values();
			}
			System.debug('updateAgreementLineItems...'+updateAgreementLineItems);
			if(!updateAgreementLineItems.isEmpty()){
	update updateAgreementLineItems.values();
			}
		}
	}
	
	
	//This method is to find the association by PDFQuoteRef
	@TestVisible
	private static Boolean isQuoteAssociationFound(Customer_Document_Line_Items__c cusDocLine
			   , List<Customer_facing_Attribute__c> custFacingAttributes
			   , Id customerDocId
			   , Map<Id,Apttus_Proposal__Proposal_Line_Item__c> soldToPartyApprovedQuoteLines
			   , Map<Id,Apttus_Proposal__Proposal_Line_Item__c> accountApprovedQuoteLines
			   , List<QTO_Customer_Document_Quote_Line__c> associatedCdLineQuotes
			   , Map<Id,Apttus_Proposal__Proposal_Line_Item__c>  updateQuoteLineItems) {
		System.debug('PDF Quote Association >>>> ');
		Boolean matchingQuoteFound = false;
		String matchingQuoteName;
		
		Id matchingQuoteId;
		Id matchingQuoteLIneId;
		Apttus_Proposal__Proposal_Line_Item__c matchedQuote = null;			
		Integer count = 0;
		for(Customer_facing_Attribute__c cfa : custFacingAttributes) {
			matchingQuoteName = cfa.Attribute_Value__c;
			if(soldToPartyApprovedQuoteLines.size() > 0 ) {
	for(Apttus_Proposal__Proposal_Line_Item__c quoLine : soldToPartyApprovedQuoteLines.values()) {
		if(	
			//(cusDocLine.QTO_Customer_Grouping__c == quoLine.DS_Grouping_Name__c|| 
			cusDocLine.Contract_Item_Number__c == quoLine.External_Reference__c
			&& cusDocLine.QTO_Product_Code__c == quoLine.Product_Code__c
			&& cusDocLine.QTO_Product_Name__r.Name == quoLine.NokiaCPQ_Product_Name__c
			&& (quoLine.Apttus_Proposal__Proposal__r.Name == matchingQuoteName || quoLine.Apttus_Proposal__Proposal__r.NokiaCPQ_Proposal_Id__c == matchingQuoteName)) { 
				count = count+1;
				matchedQuote = quoLine;
				matchingQuoteFound = true;
		}
	}
			}
		}
		
		if(count==0) {
			for(Customer_facing_Attribute__c cfa : custFacingAttributes) {
	matchingQuoteName = cfa.Attribute_Value__c;
	if(accountApprovedQuoteLines.size() > 0 ) {
		for(Apttus_Proposal__Proposal_Line_Item__c quoLine : accountApprovedQuoteLines.values()) {
			if(	
				//(cusDocLine.QTO_Customer_Grouping__c == quoLine.DS_Grouping_Name__c|| 
				cusDocLine.Contract_Item_Number__c == quoLine.External_Reference__c
				&& cusDocLine.QTO_Product_Code__c == quoLine.Product_Code__c
				&& cusDocLine.QTO_Product_Name__r.Name == quoLine.NokiaCPQ_Product_Name__c
				&& (quoLine.Apttus_Proposal__Proposal__r.Name == matchingQuoteName || quoLine.Apttus_Proposal__Proposal__r.NokiaCPQ_Proposal_Id__c == matchingQuoteName)) { 
		count = count+1;
		matchedQuote = quoLine;
		matchingQuoteFound = true;
				}
		}
	}
			}
		}
		
		System.debug('PDF QUOTE MATCHED COUNT....'+count);			  
		if(count==1) {
			QTO_Customer_Document_Quote_Line__c associationToLine = new QTO_Customer_Document_Quote_Line__c();
			associationToLine.QTO_Customer_Document_Line_Items__c = cusDocLine.Id;
			associationToLine.QTO_Proposal_Line_Item__c = matchedQuote.Id;
			updateMatchedQuoteQuantity(associationToLine, cusDocLine, matchedQuote, updateQuoteLineItems, issueLogList);
			associatedCdLineQuotes.add(associationToLine);
			matchingQuoteFound = true;
			
		}
		if(count == 0 || count > 1){
			matchingQuoteFound = false;
		}
		return matchingQuoteFound;
	}
	
	//This method is to find the association by all SoldToParty Quote Lines 
	@TestVisible
	private static Boolean isQuoteAssociationFoundByAllSoldToPartyLines(Customer_Document_Line_Items__c cusDocLine 
				, Id customerDocId
				, Map<Id,Apttus_Proposal__Proposal_Line_Item__c> soldToPartyApprovedQuoteLines
		, List<QTO_Customer_Document_Quote_Line__c> associatedCdLineQuotes
				, Map<Id,Apttus_Proposal__Proposal_Line_Item__c>  updateQuoteLineItems) {
		System.debug('Quote Association from all SoldToParty lines>>>>');
		Boolean matchingQuoteFound = false;	  
		Integer count = 0;
		Apttus_Proposal__Proposal_Line_Item__c matchedQuote = null;
		
		for(Apttus_Proposal__Proposal_Line_Item__c quoLine : soldToPartyApprovedQuoteLines.values()) {
			if((cusDocLine.Contract_Item_Number__c == quoLine.External_Reference__c || cusDocLine.QTO_Product_Code__c == quoLine.Product_Code__c)
	  && cusDocLine.QTO_Product_Name__r.Name == quoLine.NokiaCPQ_Product_Name__c) {
	   count = count+1;
	   matchedQuote = quoLine;
	   matchingQuoteFound = true;
	  }
		}
		
		if(count==1 && matchingQuoteFound && matchedQuote != null) {
			QTO_Customer_Document_Quote_Line__c associationToLine = new QTO_Customer_Document_Quote_Line__c();
			associationToLine.QTO_Customer_Document_Line_Items__c = cusDocLine.Id;
			associationToLine.QTO_Proposal_Line_Item__c = matchedQuote.Id;
			updateMatchedQuoteQuantity(associationToLine, cusDocLine, matchedQuote, updateQuoteLineItems, issueLogList);
			associatedCdLineQuotes.add(associationToLine);
			matchingQuoteFound = true;
		}
		if(count == 0 || count > 1){
			matchingQuoteFound = false;
		} 
		return matchingQuoteFound;
	}
	
	/**
	* @description: Update Quantity for each CDLine, QLLine and update quantity for associated Quote 
	* @param associationToLine  of type QTO_Customer_Document_Quote_Line__c
	* @param cusDocLine of type Customer_Document_Line_Items__c 
	* @param matchedQuote of type Apttus_Proposal__Proposal_Line_Item__c  
	* @param updateQuoteLineItems of type Map of Apttus_Proposal__Proposal_Line_Item__c   
	**/
	public static void updateMatchedQuoteQuantity(QTO_Customer_Document_Quote_Line__c associationToLine
				, Customer_Document_Line_Items__c cusDocLine
				, Apttus_Proposal__Proposal_Line_Item__c matchedQuote
				, Map<Id,Apttus_Proposal__Proposal_Line_Item__c>  updatedQuoteLineItems
				, List<QTO_Customer_Document_Issue_Log__c> issueLogList) {
		fetchExceptionConfigMetaData();	
		System.debug('Matching : '+ updatedQuoteLineItems.containsKey(matchedQuote.Id));
			  
		if(updatedQuoteLineItems.containsKey(matchedQuote.Id)) {
			matchedQuote = updatedQuoteLineItems.get(matchedQuote.Id);
			updateAssociatedQuoteLineQuantity(cusDocLine, associationToLine, matchedQuote, updatedQuoteLineItems, issueLogList);
		}
		else {
			updateAssociatedQuoteLineQuantity(cusDocLine, associationToLine, matchedQuote, updatedQuoteLineItems, issueLogList);
		}
	}
	
	private static Boolean validateCDLineAndQuoteLine(Customer_Document_Line_Items__c cusDocLine
				  , Apttus_Proposal__Proposal_Line_Item__c matchedQuote
				  , List<QTO_Customer_Document_Issue_Log__c> issueLogList) {
		Boolean hasException = false;
		if(cusDocLine.QTO_Unit_Price__c <> matchedQuote.Apttus_QPConfig__NetUnitPrice__c) {
			exceptionMetadata = exceptionConfigMetaData.get('CDLI Match 5001 QL UNIT PRICE');
			if(!Test.isRunningTest()){ 
	issueLog = QTO_CustomerDocumentLineItem_Helper.createIssueLog(cusDocLine.Customer_Document__c, cusDocLine.Id, exceptionMetadata.QTO_Return_Type__c, String.valueOf(exceptionMetadata.QTO_Return_Code__c), exceptionMetadata.QTO_Log_Details__c);   
	issueLogList.add(issueLog);
			}
			hasException = true;
		}
		//cusDocLine.QTO_Unit_of_Measure__c == matchedQuote.Apttus_QPConfig__Uom__c &&
		if(cusDocLine.CurrencyIsoCode <> matchedQuote.Apttus_Proposal__Proposal__r.CurrencyIsoCode) {
			exceptionMetadata = exceptionConfigMetaData.get('CDLI Match 5001 QL CURRENCY');
			if(!Test.isRunningTest()){ 
	issueLog = QTO_CustomerDocumentLineItem_Helper.createIssueLog(cusDocLine.Customer_Document__c, cusDocLine.Id, exceptionMetadata.QTO_Return_Type__c, String.valueOf(exceptionMetadata.QTO_Return_Code__c), exceptionMetadata.QTO_Log_Details__c);   
	issueLogList.add(issueLog);
			}
			hasException = true;
		}
		
		return hasException;
	}
	private static void updateAssociatedQuoteLineQuantity(Customer_Document_Line_Items__c cusDocLine
				, QTO_Customer_Document_Quote_Line__c associationToLine
				, Apttus_Proposal__Proposal_Line_Item__c matchedQuote
				, Map<Id,Apttus_Proposal__Proposal_Line_Item__c>  updatedQuoteLineItems
				, List<QTO_Customer_Document_Issue_Log__c> issueLogList)  {
		System.debug('Matching  : ========================================================');
		Double cdLineMatchedQuoteQty = 0.0;
		Double cdLineMatchedAgreQty = 0.0;
		Double agreementMatchedQty = 0.0;
		Double qlMatchedQty = 0.0;
		Double qlMatchedRiskQty = 0.0;
		
		if(cusDocLine.QTO_CDLI_Matched_Quoted_Quantity__c == null)
			cdLineMatchedQuoteQty = 0.0;
		else
			cdLineMatchedQuoteQty = cusDocLine.QTO_CDLI_Matched_Quoted_Quantity__c;
		
		if(cusDocLine.QTO_CDLI_Matched_Contracted_Quantity__c == null)
			cdLineMatchedAgreQty = 0.0;
		else
			cdLineMatchedAgreQty = cusDocLine.QTO_CDLI_Matched_Contracted_Quantity__c;
		
		if(matchedQuote.Apttus_Proposal__Quantity__c == null)
			qlMatchedQty = 0.0;
		else 
			qlMatchedQty = matchedQuote.Apttus_Proposal__Quantity__c; 
		
		if(matchedQuote.QTO_QLI_Matched_Risk_Quantity__c == null)
			qlMatchedRiskQty = 0.0;
		else 
			qlMatchedRiskQty = matchedQuote.QTO_QLI_Matched_Risk_Quantity__c;				
		
		Double cdLineActualQty = Decimal.valueOf(cusDocLine.Quantity__c);
		Double cdLineMatchedQty =  cdLineMatchedQuoteQty + cdLineMatchedAgreQty;
		
		Double cdLineAvailableQty = cdLineActualQty - cdLineMatchedQty;
		Double qLAvailableQty = matchedQuote.Apttus_QPConfig__Quantity2__c - qlMatchedQty;
		
		System.debug('Matching  : Quote :  : cdLineActualQty : '+cdLineActualQty +'  cdLineMatchedQty : '+ cdLineMatchedQty +'  cdLineAvilablQty : '+cdLineAvailableQty);
		System.debug('Matching  : Quote :  : Qty : '+matchedQuote.Apttus_QPConfig__Quantity2__c +'  MQQ : '+ qlMatchedQty +'  avilableQuotequantity : '+qLAvailableQty);
		
		Boolean hasException = validateCDLineAndQuoteLine(cusDocLine, matchedQuote, issueLogList);
		System.debug('Matching  : HasException.....'+ hasException);				  
		if( hasException || (cdLineAvailableQty == 0.0 || qLAvailableQty == 0.0)) {	 
			System.debug('Matching  : Validation Failed on CD Line and Associated quote');
			associationToLine.QTO_CDLIA_Match_Quoted_Comment__c = 'Matching Failed';
			cusDocLine.QTO_CDLI_Matching_Comment__c = 'Matching Failed';
		}				
		else { 
			if (cdLineAvailableQty < qLAvailableQty) {
	System.debug('Matching  : Quote :  : Condition 1');
	associationToLine.QTO_CDLIA_Matched_Quoted_Quantity__c = cdLineAvailableQty + cdLineMatchedQuoteQty;
	associationToLine.QTO_CDLIA_Match_Quoted_Comment__c = 'Matching Successful';
	cusDocLine.QTO_CDLI_Matched_Quoted_Quantity__c = cdLineAvailableQty + cdLineMatchedQuoteQty;
	cusDocLine.QTO_CDLI_Matching_Comment__c = 'Matching Successful';
	matchedQuote.Apttus_Proposal__Quantity__c = (cdLineAvailableQty + qlMatchedQty);
	if(cusDocLine.Customer_Document__r.Sub_Classification__c == QTO_Constants.RISKORDER)
		matchedQuote.QTO_QLI_Matched_Risk_Quantity__c = (cdLineAvailableQty + qlMatchedRiskQty); 
			}
			else if (cdLineAvailableQty == qLAvailableQty) {
	System.debug('Matching  : Quote :  : Condition 2');
	associationToLine.QTO_CDLIA_Matched_Quoted_Quantity__c = cdLineAvailableQty + cdLineMatchedQuoteQty;
	associationToLine.QTO_CDLIA_Match_Quoted_Comment__c = 'Matching Successful';
	cusDocLine.QTO_CDLI_Matched_Quoted_Quantity__c = cdLineAvailableQty + cdLineMatchedQuoteQty;
	cusDocLine.QTO_CDLI_Matching_Comment__c = 'Matching Successful';
	matchedQuote.Apttus_Proposal__Quantity__c = (cdLineAvailableQty + qlMatchedQty);
	if(cusDocLine.Customer_Document__r.Sub_Classification__c == QTO_Constants.RISKORDER)
		matchedQuote.QTO_QLI_Matched_Risk_Quantity__c = (cdLineAvailableQty + qlMatchedRiskQty); 
	  
			}
			else if(cdLineAvailableQty > qLAvailableQty) {
	System.debug('Matching  : Quote :  : Condition 3');
	associationToLine.QTO_CDLIA_Matched_Quoted_Quantity__c = qLAvailableQty + cdLineMatchedQuoteQty;
	associationToLine.QTO_CDLIA_Match_Quoted_Comment__c = 'Matching Successful';
	cusDocLine.QTO_CDLI_Matched_Quoted_Quantity__c =  qLAvailableQty + cdLineMatchedQuoteQty;
	cusDocLine.QTO_CDLI_Matching_Comment__c = 'Matching is only partial, please associate other instances';
	matchedQuote.Apttus_Proposal__Quantity__c = (qLAvailableQty + qlMatchedQty);
	if(cusDocLine.Customer_Document__r.Sub_Classification__c == QTO_Constants.RISKORDER)
		matchedQuote.QTO_QLI_Matched_Risk_Quantity__c = (qLAvailableQty + qlMatchedRiskQty); 
	  
			}
		}
		updatedQuoteLineItems.put(matchedQuote.Id, matchedQuote);
	}
	
	
	
	/**
	* @description: Update Quantity for each CDLine, ALLine and update quantity for associated Agreement 
	* @param associationToLine  of type QTO_Customer_Document_Agreement_Line__c
	* @param cusDocLine of type Customer_Document_Line_Items__c 
	* @param matchedAgreementLine of type Apttus__AgreementLineItem__c  
	* @param updateAgreementLineItems of type Map of Apttus__AgreementLineItem__c   
	**/
	public static void updateMatchedAgreementQuantity(QTO_Customer_Document_Agreement_Line__c associationToLine
				  , Customer_Document_Line_Items__c cusDocLine
				  , Apttus__AgreementLineItem__c matchedAgreementLine
				  , Map<Id,Apttus__AgreementLineItem__c>  updatedAgreementLineItems
				, List<QTO_Customer_Document_Issue_Log__c> issueLogList) {
		fetchExceptionConfigMetaData();
		System.debug('updateMatchedAgreementQuantity.....');
		if(updatedAgreementLineItems.containsKey(matchedAgreementLine.Id)) {
			matchedAgreementLine = updatedAgreementLineItems.get(matchedAgreementLine.Id);
			updateAssociatedAgreementQuantity(cusDocLine, associationToLine, matchedAgreementLine, updatedAgreementLineItems, issueLogList);
		}  
		else {
			updateAssociatedAgreementQuantity(cusDocLine, associationToLine, matchedAgreementLine, updatedAgreementLineItems,  issueLogList);
		}
	}
	
	private static Boolean validateCDLineAndAgreementLine(Customer_Document_Line_Items__c cusDocLine
				, Apttus__AgreementLineItem__c matchedAgreementLine
				, List<QTO_Customer_Document_Issue_Log__c> issueLogList) {
		Boolean hasException = false;
		//if(cusDocLine.QTO_Unit_Price__c <> matchedAgreementLine.Apttus__NetPrice__c) {
		if(cusDocLine.QTO_Unit_Price__c <> matchedAgreementLine.Apttus_CMConfig__NetUnitPrice__c) {
		exceptionMetadata = exceptionConfigMetaData.get('CDLI Match 5001 AL UNIT PRICE');
			if(!Test.isRunningTest()){ 
	issueLog = QTO_CustomerDocumentLineItem_Helper.createIssueLog(cusDocLine.Customer_Document__c, cusDocLine.Id, exceptionMetadata.QTO_Return_Type__c, String.valueOf(exceptionMetadata.QTO_Return_Code__c), exceptionMetadata.QTO_Log_Details__c);   
	issueLogList.add(issueLog);
			}
			hasException = true;
		}
		//cusDocLine.QTO_Unit_of_Measure__c == matchedQuote.Apttus_QPConfig__Uom__c &&
		if(cusDocLine.CurrencyIsoCode <> matchedAgreementLine.Apttus__AgreementId__r.CurrencyIsoCode) {
			exceptionMetadata = exceptionConfigMetaData.get('CDLI Match 5001 AL CURRENCY');
			if(!Test.isRunningTest()){ 
	issueLog = QTO_CustomerDocumentLineItem_Helper.createIssueLog(cusDocLine.Customer_Document__c, cusDocLine.Id, exceptionMetadata.QTO_Return_Type__c, String.valueOf(exceptionMetadata.QTO_Return_Code__c), exceptionMetadata.QTO_Log_Details__c);   
	issueLogList.add(issueLog);
			}
			hasException = true;
		}
		
		return hasException;
	}
	
	
	
	
	private static void updateAssociatedAgreementQuantity(Customer_Document_Line_Items__c cusDocLine
				  , QTO_Customer_Document_Agreement_Line__c associationToLine
				  , Apttus__AgreementLineItem__c matchedAgreementLine
				  , Map<Id,Apttus__AgreementLineItem__c>  updatedAgreementLineItems
				  , List<QTO_Customer_Document_Issue_Log__c> issueLogList) {
		Double cdLineMatchedQuoteQty = 0.0;
		Double cdLineMatchedAgreQty = 0.0;
		Double alMatchedQty = 0.0;
		 
		if(cusDocLine.QTO_CDLI_Matched_Quoted_Quantity__c == null)
			cdLineMatchedQuoteQty = 0.0;
		else
			cdLineMatchedQuoteQty = cusDocLine.QTO_CDLI_Matched_Quoted_Quantity__c;
		
		if(cusDocLine.QTO_CDLI_Matched_Contracted_Quantity__c == null)
			cdLineMatchedAgreQty = 0.0;
		else
			cdLineMatchedAgreQty = cusDocLine.QTO_CDLI_Matched_Contracted_Quantity__c;
		
		if(matchedAgreementLine.QTO_ALI_Matched_Contracted_Quantity__c == null)
			alMatchedQty = 0.0;
		else
			alMatchedQty = matchedAgreementLine.QTO_ALI_Matched_Contracted_Quantity__c; 
			
		Double cdLineActualQty = Decimal.valueOf(cusDocLine.Quantity__c);
		Double cdLineMatchedQty =  cdLineMatchedQuoteQty + cdLineMatchedAgreQty;
		Double cdLineAvailableQty = cdLineActualQty - cdLineMatchedQty;
		
		Double aLAvailablequantity = matchedAgreementLine.Apttus__Quantity__c - alMatchedQty;
	
		System.debug('Matching  : Agreement :  : cdLineActualQty : '+cdLineActualQty +'  cdLineMatchedQty : '+ cdLineMatchedQty +'  cdLineAvailableQty : '+cdLineAvailableQty);
		System.debug('Matching  : Agreement :  : Main Quantity--->'+ matchedAgreementLine.Apttus__Quantity__c);
		
		
		Boolean hasException = validateCDLineAndAgreementLine(cusDocLine, matchedAgreementLine, issueLogList);			
		if( hasException || (cdLineAvailableQty == 0.0 || aLAvailablequantity == 0.0)) {	 
			System.debug('Matching  : Validation Failed on CD Line and Associated quote');
			associationToLine.QTO_CDLIA_Match_Contracted_Comment__c = 'Matching Failed';
			cusDocLine.QTO_CDLI_Matching_Comment__c = 'Matching Failed';
		}								 
		else { 
			/*			
			if(cdLineAvailableQty == 0.0 || aLAvailablequantity == 0.0) {
	System.debug('Matching  : Agreement :  : Condition 0');
	associationToLine.QTO_CDLIA_Match_Contracted_Comment__c = 'Matching Failed';
	cusDocLine.QTO_CDLI_Matching_Comment__c = 'Matching Failed';
			}
			*/
			if (cdLineAvailableQty < aLAvailablequantity) {
	System.debug('Matching  : Agreement :  : Condition 1');
	associationToLine.QTO_CDLIA_Matched_Contracted_Quantity__c = cdLineAvailableQty + cdLineMatchedAgreQty;
	associationToLine.QTO_CDLIA_Match_Contracted_Comment__c = 'Matching Successful';
	cusDocLine.QTO_CDLI_Matched_Contracted_Quantity__c = cdLineAvailableQty + cdLineMatchedAgreQty;
	cusDocLine.QTO_CDLI_Matching_Comment__c = 'Matching Successful';
	matchedAgreementLine.QTO_ALI_Matched_Contracted_Quantity__c = cdLineAvailableQty + alMatchedQty; 
			}
			else if (cdLineAvailableQty == aLAvailablequantity) {
	System.debug('Matching  : Agreement :  : Condition 2');
	associationToLine.QTO_CDLIA_Matched_Contracted_Quantity__c = cdLineAvailableQty + cdLineMatchedAgreQty;
	associationToLine.QTO_CDLIA_Match_Contracted_Comment__c = 'Matching Successful';
	cusDocLine.QTO_CDLI_Matched_Contracted_Quantity__c = cdLineAvailableQty + cdLineMatchedAgreQty;
	cusDocLine.QTO_CDLI_Matching_Comment__c = 'Matching Successful';
	matchedAgreementLine.QTO_ALI_Matched_Contracted_Quantity__c = cdLineAvailableQty + alMatchedQty;
	
			}
			else if (cdLineAvailableQty > aLAvailablequantity) {
	System.debug('Matching  : Agreement :  : Condition 3');
	associationToLine.QTO_CDLIA_Matched_Contracted_Quantity__c = aLAvailablequantity + cdLineMatchedAgreQty;
	associationToLine.QTO_CDLIA_Match_Contracted_Comment__c = 'Matching Successful';
	cusDocLine.QTO_CDLI_Matched_Contracted_Quantity__c = aLAvailablequantity + cdLineMatchedAgreQty;
	cusDocLine.QTO_CDLI_Matching_Comment__c = 'Matching is only partial, please associate other instances';
	matchedAgreementLine.QTO_ALI_Matched_Contracted_Quantity__c = aLAvailablequantity + alMatchedQty;
			}
		}
		updatedAgreementLineItems.put(matchedAgreementLine.Id, matchedAgreementLine);
	}	
	
	//This method is to find the association by SITE REF / ANTICIPATION REF
	@TestVisible
	private static Boolean isQuoteAssociationFoundByRefs(Customer_Document_Line_Items__c cusDocLine
			, List<Customer_facing_Attribute__c> siteCodeCfs
			, Id customerDocId
			, Map<Id, Apttus_Proposal__Proposal_Line_Item__c> soldToPartyApprovedQuoteLines
			, Map<Id, Apttus_Proposal__Proposal_Line_Item__c> accountApprovedQuoteLines
			, List<QTO_Customer_Document_Quote_Line__c> associatedCdLineQuotes
			, Map<Id, String> refMap
			, Map<Id,Apttus_Proposal__Proposal_Line_Item__c>  updateQuoteLineItems) {
		System.debug('isQuote Association Found by  Site Ref/Anticipation Ref----');			
		Apttus_Proposal__Proposal_Line_Item__c matchedSiteQuote = null;
		Boolean matchingQuoteFound = false;
		String matchingQuoteName;
		Integer count=0;
			 
		Map<Id,String> cfaQuoteLine = new Map<Id,String>();
		for(Customer_facing_Attribute__c cfaSite : siteCodeCfs) {
			System.debug('cfaSite . '+cfaSite);
			if(cfaSite.Quote_Line_Item__c != NULL) {
	cfaQuoteLine.put(cfaSite.Quote_Line_Item__c,cfaSite.Attribute_Value__c);
			}
		}
			 
		System.debug('Site cfaQuoteLine====='+cfaQuoteLine);
			 
		if(!cfaQuoteLine.isEmpty() && !soldToPartyApprovedQuoteLines.isEmpty()){
			for(Id quoteLineId : cfaQuoteLine.keySet()) {
	if(soldToPartyApprovedQuoteLines.containsKey(quoteLineId)) {
		Apttus_Proposal__Proposal_Line_Item__c quoLine = soldToPartyApprovedQuoteLines.get(quoteLineId);
		System.debug('Site cfaQuoteLine===== pdfSiteCodesMap.get(cusDocLine.Id)...'+ cfaQuoteLine.get(quoteLineId));
		System.debug('Site cfaQuoteLine===== cfaQuoteLine.get(quoteLineId)...'+ cfaQuoteLine.get(quoteLineId));
		if(
			//cusDocLine.QTO_Customer_Grouping__c == quoLine.DS_Grouping_Name__c
		cusDocLine.Contract_Item_Number__c == quoLine.External_Reference__c
		&& cusDocLine.QTO_Product_Code__c == quoLine.Product_Code__c
		&& cusDocLine.QTO_Product_Name__r.Name == quoLine.NokiaCPQ_Product_Name__c 
		&& refMap.get(cusDocLine.Id) == cfaQuoteLine.get(quoteLineId)) {
		 count = count+1;
		 matchedSiteQuote = quoLine;
		 matchingQuoteFound = true;
		}
	}
			}				
		}
			 
		if(count==0) {
			if(!cfaQuoteLine.isEmpty() && !soldToPartyApprovedQuoteLines.isEmpty()){
	for(Id quoteLineId : cfaQuoteLine.keySet()) {
		if(accountApprovedQuoteLines.containsKey(quoteLineId)) {
			Apttus_Proposal__Proposal_Line_Item__c quoLine = accountApprovedQuoteLines.get(quoteLineId);
			System.debug('Site cfaQuoteLine===== pdfSiteCodesMap.get(cusDocLine.Id)...'+ cfaQuoteLine.get(quoteLineId));
			System.debug('Site cfaQuoteLine===== cfaQuoteLine.get(quoteLineId)...'+ cfaQuoteLine.get(quoteLineId));
			if(
				//cusDocLine.QTO_Customer_Grouping__c == quoLine.DS_Grouping_Name__c
		 cusDocLine.Contract_Item_Number__c == quoLine.External_Reference__c
		 && cusDocLine.QTO_Product_Code__c == quoLine.Product_Code__c
		 && cusDocLine.QTO_Product_Name__r.Name == quoLine.NokiaCPQ_Product_Name__c 
		 && refMap.get(cusDocLine.Id) == cfaQuoteLine.get(quoteLineId)) {
		  count = count+1;
		  matchedSiteQuote = quoLine;
		  matchingQuoteFound = true;
		 }
		}
	}				
			}
		}				 
			 
		System.debug('Site cfaQuoteLine SITE CODE MATCH COUNT....'+count);
		if(count==1 && matchingQuoteFound && matchedSiteQuote != null) {
			QTO_Customer_Document_Quote_Line__c associationToLine = new QTO_Customer_Document_Quote_Line__c();
			associationToLine.QTO_Customer_Document_Line_Items__c = cusDocLine.Id;
			associationToLine.QTO_Proposal_Line_Item__c = matchedSiteQuote.Id;
			updateMatchedQuoteQuantity(associationToLine, cusDocLine, matchedSiteQuote, updateQuoteLineItems, issueLogList);
			associatedCdLineQuotes.add(associationToLine);
			matchingQuoteFound = true;
		} else {
			matchingQuoteFound = false;
		}
		return matchingQuoteFound;		   
	} 
	
	  
	@TestVisible
	private static Boolean isQuoteAgreementAssociationByContRef(Customer_Document_Line_Items__c cusDocLine
			, Map<Id,Id> pdfQuoteRefQuoteIdAndAgreeIdMap 
			, Map<Id,List<Apttus__AgreementLineItem__c>> agreementAndLinesMap
			, List<QTO_Customer_Document_Agreement_Line__c> associatedCdLineAgreements
			, Map<Id,Apttus__AgreementLineItem__c>  updateAgreementLineItems) {
				
		Apttus__AgreementLineItem__c matchedAgreementLine = null;	 
		Integer count = 0;
		Boolean isAgreementAssociationFound = false;						
		System.debug('Search Product In [Quote > Aggrements] ');
		if(pdfQuoteRefQuoteIdAndAgreeIdMap!=null)  {					 
			for(Id agreementId : pdfQuoteRefQuoteIdAndAgreeIdMap.keyset()) {
	if(agreementAndLinesMap.containsKey(agreementId)) {
		for(Apttus__AgreementLineItem__c agreeLineItem : agreementAndLinesMap.get(agreementId))  {
			if(agreeLineItem.CLM_CFE_Reference__c != null && agreeLineItem.Product_Code__c !=null) {
				if(cusDocLine.Contract_Item_Number__c == agreeLineItem.CLM_CFE_Reference__c
		 && cusDocLine.QTO_Product_Code__c == agreeLineItem.Product_Code__c
		 && cusDocLine.QTO_Product_Name__c == agreeLineItem.Apttus__ProductId__c) {
		count = count+1;
		matchedAgreementLine = agreeLineItem;
		isAgreementAssociationFound = true;
				}
			}
			else {
				if((cusDocLine.Contract_Item_Number__c == agreeLineItem.CLM_CFE_Reference__c
		 	) 
		  && cusDocLine.QTO_Product_Name__c == agreeLineItem.Apttus__ProductId__c) {
		count = count+1;
		matchedAgreementLine = agreeLineItem;
		isAgreementAssociationFound = true;
				}
			}
				
		}
	}
			}
		}

		if(count == 1){
			QTO_Customer_Document_Agreement_Line__c cdliAgreeAssoc = new QTO_Customer_Document_Agreement_Line__c();
			cdliAgreeAssoc.QTO_Agreement_Line_Item__c = matchedAgreementLine.Id;
			cdliAgreeAssoc.QTO_Customer_Document_Line_Items__c = cusDocLine.Id;
			updateMatchedAgreementQuantity(cdliAgreeAssoc, cusDocLine, matchedAgreementLine , updateAgreementLineItems, issueLogList);
			associatedCdLineAgreements.add(cdliAgreeAssoc);
			isAgreementAssociationFound = true;
		}
		if(count == 0 || count > 1){
			isAgreementAssociationFound = false;
		}
		return isAgreementAssociationFound;
  	}

	
	@TestVisible
	private static Boolean isAgreementAssociationByContractRef(Customer_Document_Line_Items__c cusDocLine
			, Map<Id,List<Apttus__AgreementLineItem__c>> agreementAndLinesMap
			, List<QTO_Customer_Document_Agreement_Line__c> associatedCdLineAgreements
			, Map<Id,Apttus__AgreementLineItem__c>  updateAgreementLineItems) {
		System.debug('is Agreement Association By ContractRef....' +agreementAndLinesMap.size()); 
				
		Boolean isAgreementAssociationFound = false;
		Apttus__AgreementLineItem__c matchedAgreementLine = null;	 
		Integer count = 0;
		if(agreementAndLinesMap!=null) {
			for(Id agreementId : agreementAndLinesMap.keyset()) {
	for(Apttus__AgreementLineItem__c agreeLineItem : agreementAndLinesMap.get(agreementId)) {
		System.debug('Association : Agreement : is Agreement Association....' +agreeLineItem.Name); 
		System.debug('Association : Agreement : is Agreement Association....' +agreeLineItem.CLM_CFE_Reference__c); 
		System.debug('Association : Agreement : is Agreement Association By ContractRef....' +agreeLineItem.Product_Code__c); 
		System.debug('Association : Agreement : is Agreement Association By ContractRef....' + (cusDocLine.QTO_Product_Name__c == agreeLineItem.Apttus__ProductId__c)); 
		
		if(agreeLineItem.CLM_CFE_Reference__c != null && agreeLineItem.Product_Code__c !=null) {
			if(cusDocLine.Contract_Item_Number__c == agreeLineItem.CLM_CFE_Reference__c
		 && cusDocLine.QTO_Product_Code__c == agreeLineItem.Product_Code__c
		 && cusDocLine.QTO_Product_Name__c == agreeLineItem.Apttus__ProductId__c) {
		  count = count+1;
		  matchedAgreementLine = agreeLineItem;
		  isAgreementAssociationFound = true;
		 }
		}
		else {
			if(cusDocLine.Contract_Item_Number__c == agreeLineItem.CLM_CFE_Reference__c
		 && cusDocLine.QTO_Product_Name__c == agreeLineItem.Apttus__ProductId__c) {
		  count = count+1;
		  matchedAgreementLine = agreeLineItem;
		  isAgreementAssociationFound = true;
		 }
		}   
	}  
			}
		}
		System.debug('Associated Agr count : '+count);		
		if(count == 1){
			QTO_Customer_Document_Agreement_Line__c cdliAgreeAssoc = new QTO_Customer_Document_Agreement_Line__c();
			cdliAgreeAssoc.QTO_Agreement_Line_Item__c = matchedAgreementLine.Id;
			cdliAgreeAssoc.QTO_Customer_Document_Line_Items__c = cusDocLine.Id;
			updateMatchedAgreementQuantity(cdliAgreeAssoc, cusDocLine, matchedAgreementLine , updateAgreementLineItems, issueLogList);
			associatedCdLineAgreements.add(cdliAgreeAssoc);
			isAgreementAssociationFound = true;
		}
		if(count == 0 || count > 1){
			isAgreementAssociationFound = false;
		}
		return isAgreementAssociationFound;				 
	}
	
	
	
	
	/**getAllSoldPartyQuotes*/
	public static Map<Id,Apttus_Proposal__Proposal_Line_Item__c> findAllQuotesBySoldToParty(String soldtoParty){
		
		
		/* Map<Id,Apttus_Proposal__Proposal_Line_Item__c> soldToPartyLines = new Map<Id,Apttus_Proposal__Proposal_Line_Item__c>([Select Id,Name,NokiaCPQ_Product_Name__c,Apttus_QPConfig__PriceListItemId__c,
								 Apttus_Proposal__Proposal__c,Apttus_Proposal__Proposal__r.Name, Apttus_Proposal__Proposal__r.NokiaCPQ_Proposal_Id__c,
								 Apttus_Proposal__Proposal__r.Id, Apttus_Proposal__Product__c,DS_Grouping_Name__c,Product_Code__c,
								 Apttus_Proposal__Product__r.ProductCode,External_Reference__c, Apttus_Proposal__Quantity__c, 	Apttus_QPConfig__Quantity2__c 
								 from Apttus_Proposal__Proposal_Line_Item__c where Apttus_Proposal__Proposal__r.Sold_to_Party__c =: soldtoParty 
								 AND Apttus_Proposal__Proposal__r.Apttus_Proposal__Approval_Stage__c = 'Approved']); 
	 */
		Map<Id,Apttus_Proposal__Proposal_Line_Item__c> soldToPartyLines = new Map<Id,Apttus_Proposal__Proposal_Line_Item__c>
			([
	Select Id,Name,NokiaCPQ_Product_Name__c,Apttus_QPConfig__PriceListItemId__c, Apttus_Proposal__Proposal__c,
	Apttus_Proposal__Proposal__r.Name, Apttus_Proposal__Proposal__r.NokiaCPQ_Proposal_Id__c, Apttus_Proposal__Proposal__r.Id,
	Apttus_Proposal__Product__c,DS_Grouping_Name__c,Product_Code__c, Apttus_Proposal__Product__r.ProductCode,
	External_Reference__c, Apttus_Proposal__Quantity__c, Apttus_QPConfig__Quantity2__c, QTO_QLI_Matched_Risk_Quantity__c,
	Apttus_QPConfig__Uom__c, Apttus_QPConfig__NetUnitPrice__c, Apttus_Proposal__Proposal__r.CurrencyIsoCode, QTO_QL_Available_Quantity__c  
	FROM Apttus_Proposal__Proposal_Line_Item__c WHERE 
	Apttus_Proposal__Proposal__r.Sold_to_Party__c =: soldtoParty 
	AND Apttus_Proposal__Proposal__r.Apttus_Proposal__Approval_Stage__c = 'Approved'
	AND Apttus_QPConfig__LineType__c = 'Product/Service'
	//AND QTO_QL_Available_Quantity__c > 0
	ORDER BY  Apttus_Proposal__Proposal__r.CreatedDate
			]); 
		return soldToPartyLines;
	}
	
	/**findAllQuotesByAccount*/
	public static Map<Id,Apttus_Proposal__Proposal_Line_Item__c> findAllQuotesByAccount(String soldtoParty){
		Set<Id> parentIds = new Set<Id>();
		for(Account Acco: [SELECT Id,name,Parentid, AccountNumber, Parent.Id, Parent.OwnerId, Parent.AccountNumber FROM Account WHERE Id=: soldtoParty]) {
			parentIds.add(Acco.parentId);
		} 
		
		Map<Id,Apttus_Proposal__Proposal_Line_Item__c> accountQls = new Map<Id,Apttus_Proposal__Proposal_Line_Item__c>
			([
	Select Id,Name,NokiaCPQ_Product_Name__c,Apttus_QPConfig__PriceListItemId__c, Apttus_Proposal__Proposal__c,
	Apttus_Proposal__Proposal__r.Name, Apttus_Proposal__Proposal__r.NokiaCPQ_Proposal_Id__c, Apttus_Proposal__Proposal__r.Id,
	Apttus_Proposal__Product__c,DS_Grouping_Name__c,Product_Code__c, Apttus_Proposal__Product__r.ProductCode,
	External_Reference__c, Apttus_Proposal__Quantity__c, Apttus_QPConfig__Quantity2__c, QTO_QLI_Matched_Risk_Quantity__c,
	Apttus_QPConfig__Uom__c, Apttus_QPConfig__NetUnitPrice__c, Apttus_Proposal__Proposal__r.CurrencyIsoCode, QTO_QL_Available_Quantity__c  
	FROM Apttus_Proposal__Proposal_Line_Item__c 
	WHERE Apttus_Proposal__Proposal__r.Apttus_Proposal__Account__c IN : parentIds
	AND Apttus_Proposal__Proposal__r.Apttus_Proposal__Approval_Stage__c = 'Approved'
	AND Apttus_QPConfig__LineType__c = 'Product/Service'
	ORDER BY  Apttus_Proposal__Proposal__r.CreatedDate
			]); 
		return accountQls;
	}
	
	
	
	
	
	/**findAllCfaByCustomerDocId*/ // DSI-2340 access modifier changed to public
	public static Map<String,List<Customer_facing_Attribute__c>> findAllCfaByCustomerDocId( Id customerDocId, Set<Id> allCusDocLineIds) {
	
		Map<String,List<Customer_facing_Attribute__c>> custFacingAttributeMap = new  Map<String,List<Customer_facing_Attribute__c>>();
		
		List<Customer_facing_Attribute__c> custFacingAttributes = [Select Id,Quote__c,Quote_Line_Item__c,Attribute_Label__c,Attribute_Value__c,
				   QTO_Customer_Document_Line_Items__c,QTO_Customer_Document__c 
				   from Customer_facing_Attribute__c where QTO_Customer_Document__c = :customerDocId
				   OR QTO_Customer_Document_Line_Items__c IN :allCusDocLineIds];  
		
		for(Customer_facing_Attribute__c cfAttribute : custFacingAttributes) {
			if(custFacingAttributeMap.containsKey(cfAttribute.Attribute_Label__c)){
	List<Customer_facing_Attribute__c> attribList  = custFacingAttributeMap.get(cfAttribute.Attribute_Label__c);
	attribList.add(cfAttribute);
	custFacingAttributeMap.put(cfAttribute.Attribute_Label__c, attribList); 
			}
			else {
	List<Customer_facing_Attribute__c> attribList = new List<Customer_facing_Attribute__c>();
	attribList.add(cfAttribute);
	custFacingAttributeMap.put(cfAttribute.Attribute_Label__c, attribList);
			}
		}
		
		return custFacingAttributeMap;		
	}
	
	
	//findAllPDFQuoteRefs
	public static  Set<String>  findAllCfaPdfQuoteRefs(Map<String,List<Customer_facing_Attribute__c>> cusFacingAttributesMap ) {
		Set<String> pdfQuoteReferences = new Set<String>();
		if(cusFacingAttributesMap.containsKey('PDF QUOTE REF')) {
			for(Customer_facing_Attribute__c cfAttribute : cusFacingAttributesMap.get('PDF QUOTE REF')) {
	if(cfAttribute.QTO_Customer_Document__c != NULL || cfAttribute.QTO_Customer_Document_Line_Items__c != NULL ){
		pdfQuoteReferences.add(cfAttribute.Attribute_Value__c);
	}
			}
		}
		return pdfQuoteReferences;
	}
	
	//findAllPDFContractRefs
	public static  Set<String>  findAllCfaPdfContractRefs(Map<String,List<Customer_facing_Attribute__c>> cusFacingAttributesMap ) {
		Set<String> pdfContractReferences = new Set<String>();
		if(cusFacingAttributesMap.containsKey('PDF CONTRACT REF')) {
			for(Customer_facing_Attribute__c cfAttribute : cusFacingAttributesMap.get('PDF CONTRACT REF')) {
	if(cfAttribute.QTO_Customer_Document__c != NULL || cfAttribute.QTO_Customer_Document_Line_Items__c != NULL ){
		pdfContractReferences.add(cfAttribute.Attribute_Value__c);
	}
			}
		}
		return pdfContractReferences;
	}
	
	
	
	
	public static Map<Id,String> findAllCfaSiteCodeRefs( Map<String,List<Customer_facing_Attribute__c>> custFacingAttributeMap) { 
		Map<Id,String> pdfsiteCodes = new Map<Id,String>();
		if(!custFacingAttributeMap.isEmpty() && custFacingAttributeMap.containsKey('PDF SITE CODE')) {
			for(Customer_facing_Attribute__c cfAttribute : custFacingAttributeMap.get('PDF SITE CODE')) {
	if(cfAttribute.Attribute_Label__c == 'PDF SITE CODE' && cfAttribute.Attribute_Value__c != NULL) {
		
		if(cfAttribute.QTO_Customer_Document_Line_Items__c != null)
			 pdfsiteCodes.put(cfAttribute.QTO_Customer_Document_Line_Items__c, cfAttribute.Attribute_Value__c);
		
		if(cfAttribute.QTO_Customer_Document__c != null)
			pdfsiteCodes.put(cfAttribute.QTO_Customer_Document__c, cfAttribute.Attribute_Value__c);
	}
			}
		}
		return pdfsiteCodes;
	}
	
	//getCfaAnticipationRefs 
	public static Map<Id,String> findAllCfaAnticipationRefs( Map<String,List<Customer_facing_Attribute__c>> custFacingAttributeMap) {
		Map<Id,String> anticipationRefs = new Map<Id,String>();
		if(custFacingAttributeMap.containsKey('ANTICIPATION REF')) {
			for(Customer_facing_Attribute__c cfAttribute : custFacingAttributeMap.get('ANTICIPATION REF')) {
	if(cfAttribute.Attribute_Label__c == 'ANTICIPATION REF' && cfAttribute.Attribute_Value__c != NULL) {
		
		if(cfAttribute.QTO_Customer_Document_Line_Items__c != null)
			 anticipationRefs.put(cfAttribute.QTO_Customer_Document_Line_Items__c, cfAttribute.Attribute_Value__c);
		
		if(cfAttribute.QTO_Customer_Document__c != null)
			anticipationRefs.put(cfAttribute.QTO_Customer_Document__c, cfAttribute.Attribute_Value__c);
	}
			}
		}
		return anticipationRefs;
	}
	
	
	private static List<Customer_facing_Attribute__c> getCfaQuoteRefsByAttributeName(List<String> pdfsiteCodes, String attributeLabel, String soldtoParty) {
		List<Customer_facing_Attribute__c> custFacingRefs =  
			[
	Select Id,Quote__c, Quote__r.Id, Quote_Line_Item__c, Quote_Line_Item__r.Id,Quote_Line_Item__r.Name, Attribute_Label__c,
	Attribute_Value__c, QTO_Customer_Document_Line_Items__c,QTO_Customer_Document__c from Customer_facing_Attribute__c 
	where Attribute_Value__c IN:pdfsiteCodes
	AND Quote__r.Sold_to_Party__c =: soldtoParty
	AND Quote__r.Apttus_Proposal__Approval_Stage__c = 'Approved'
	AND Quote__c != null AND Quote_Line_Item__c != null
	AND (Attribute_Label__c =: attributeLabel OR Attribute_Name__c =: attributeLabel)
			];
		return custFacingRefs;
	}
	
	private static List<Apttus__APTS_Agreement__c> findAllAgreementsByCustomerDocId(Set<String> pdfContractReferences, Map<Id,Id> associatedAgreementsMap){
		List<Apttus__APTS_Agreement__c> allAgreements = 
			[
	Select Id, Apttus_CMConfig__PriceListId__c, Apttus__Account__c, Agreement_External_Contract_Number__c,Name,
	Apttus__FF_Agreement_Number__c,Nokia_Legal_Entity_lookup__c,
	(
		Select Id,Apttus__AgreementId__c,Name, Apttus__Description__c,Contract_Item_Number__c,CLM_CFE_Reference__c,Apttus__ProductId__c,
		Apttus__ProductId__r.ProductCode,Product_Code__c, Apttus__Quantity__c, QTO_ALI_Matched_Contracted_Quantity__c,
		Apttus_CMConfig__Uom__c, Apttus_CMConfig__NetUnitPrice__c, Apttus__NetPrice__c, Apttus__AgreementId__r.CurrencyIsoCode 
		FROM Apttus__AgreementLineItems__r
	) from Apttus__APTS_Agreement__c WHERE Apttus__Status__c = 'Activated' AND Apttus__Status_Category__c ='In Effect'
	AND ((Agreement_External_Contract_Number__c IN : pdfContractReferences OR NAME IN :pdfContractReferences) OR Id In:associatedAgreementsMap.values())
			];
		return allAgreements;
	}
	// DSI-2340 access modifier changed to public
	public static List<Apttus_Proposal__Proposal__c> findAllQuotesByCustomerDocId(Id cusDocId, Set<String> pdfQuoteReferences) {
		List<Apttus_Proposal__Proposal__c> allQuotes = 
			[
	Select Id,NokiaCPQ_Proposal_Id__c,Nokia_Customer_Document_ID__c,Apttus_Proposal__Account__c,Agreement_Lookup__c,
	Apttus_QPConfig__PriceListId__c,Sold_To_Party__c,
	(
		Select Id,NokiaCPQ_Product_Name__c,Apttus_QPConfig__PriceListItemId__c,
		Apttus_Proposal__Proposal__c,Apttus_Proposal__Product__c,Apttus_Proposal__Product__r.ProductCode,External_Reference__c
		from Apttus_Proposal__R00N70000001yUfBEAU__r where Apttus_QPConfig__LineType__c = 'Product/Service'
	) 
	from Apttus_Proposal__Proposal__c where (NokiaCPQ_Proposal_Id__c =: cusDocId OR NAME IN :pdfQuoteReferences)
	AND Apttus_Proposal__Approval_Stage__c = 'Approved'
			];
		return allQuotes;
	}
	
	
	/* find all agreements */
	public static Map<Id,Apttus__AgreementLineItem__c> findAllAgreementsBySoldToParty(String soldtoParty){
		Map<Id,Apttus__AgreementLineItem__c> soldToPartyLines = new Map<Id,Apttus__AgreementLineItem__c>
			([
	Select Id,Apttus__AgreementId__c,Name,Apttus__Description__c,Contract_Item_Number__c,CLM_CFE_Reference__c,
	Apttus__ProductId__r.Name,Product_Code__c,Apttus__NetPrice__c,Apttus__Quantity__c,Apttus__ExtendedPrice__c,
	Apttus__AgreementId__r.Apttus__Status__c, Apttus__AgreementId__r.Apttus__Status_Category__c,
	Apttus_CMConfig__Uom__c, Apttus_CMConfig__NetUnitPrice__c, Apttus__AgreementId__r.CurrencyIsoCode,
	QTO_ALI_Matched_Contracted_Quantity__c, QTO_AL_Available_Quantity__c
	FROM Apttus__AgreementLineItem__c WHERE Apttus__AgreementId__r.Apttus__Account__c  =: soldtoParty 
	AND Apttus__AgreementId__r.Apttus__Status__c='Activated' 
	AND Apttus__AgreementId__r.Apttus__Status_Category__c= 'In Effect'
	AND QTO_AL_Available_Quantity__c > 0
			]);
		return soldToPartyLines;
	}
	
	//fetch Exception Metadata
	private static void fetchExceptionConfigMetaData() {
		for(QTO_Exception_Configuration__mdt metadata :[select id, MasterLabel, QualifiedApiName,QTO_Return_Code__c,QTO_Return_Description__c,QTO_Return_Type__c,QTO_Task_Subject__c,QTO_Tasks_Due_Date__c,QTO_Tasks_Priority__c,QTO_Tasks_Status__c,QTO_Investigating_Group__c,QTO_Log_Details__c from QTO_Exception_Configuration__mdt]){
	exceptionConfigMetaData.put(metadata.MasterLabel, metadata);
		}
	}
	
	
	
}