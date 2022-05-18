/*********************************************************************
* Class Name  : QTO_CustomerDocumentLineItem_Helper
* Test Class  : QTO_CustomerDocumentLineItemHelperTest
* Created Date: 04 Jun 2021
* Created By  : Kantam, Rithvik
* Description : This class is for Line item enrichment
* Modified By : Shaik, Johny 
* Description : DSI-2148, DSI-2151, DSI-2153 
*******************************************************************/
public with sharing class QTO_CustomerDocumentLineItem_Helper {
	
	static Map<String,QTO_Exception_Configuration__mdt> exceptionConfigMetaData = new Map<String,QTO_Exception_Configuration__mdt>();
	static List<QTO_Customer_Document_Issue_Log__c> issueLogList = new List<QTO_Customer_Document_Issue_Log__c>();
	static List<Customer_Document__c> updatedCDList = new List<Customer_Document__c>(); 
	static Map<Id,Customer_Document_Line_Items__c> sanityFailureMap = new Map<Id,Customer_Document_Line_Items__c>();
	static QTO_Customer_Document_Issue_Log__c  issueLog=null;
	static QTO_Exception_Configuration__mdt exceptionMetadata = null;
	
	public static void lineItemEnrichment(List<Customer_Document_Line_Items__c> customerDocumentLineItems) {
		fetchExceptionConfigMetaData();
		List<String> productCodes = new List<String>();
		List<String> productDescriptions = new List<String>();
		Map<String,Id> productCodesMap = new  Map<String,Id>();
		Map<String,Id> productDescriptionsMap = new  Map<String,Id>();
		List<Id> allCusDocLineIds = new List<Id>();
		List<String> pdfQuoteReferences = new List<String>();
		List<String> pdfContractReferences = new List<String>();
		
		//Customer Document and Respective Items
		Map<Id,List<Customer_Document_Line_Items__c>> cdLinesMap = new Map<Id,List<Customer_Document_Line_Items__c>>();
		
		Map<Id,Id> associatedQuotesMap = new Map<Id,Id>();
		Map<Id,Id> associatedAgreementsMap = new Map<Id,Id>();
		
		Map<Id,Id> pdfQuoteRefQuoteIdAndAgreeIdMap = new Map<Id,Id>();
		Map<Id,Id> pdfQuoteRefQuoteIdAndPriceListIdMap = new Map<Id,Id>();
		
		//Quote and Respective Items
		Map<Id,List<Apttus_Proposal__Proposal_Line_Item__c>> quoteAndLinesMap = new Map<Id,List<Apttus_Proposal__Proposal_Line_Item__c>>();
		
		//Agreement and Respective Items
		Map<Id,List<Apttus__AgreementLineItem__c>> agreementAndLinesMap = new Map<Id,List<Apttus__AgreementLineItem__c>>();
		
		//Price List and Respective Items
		Map<Id,List<Apttus_Config2__PriceListItem__c>> priceListItemsMap = new Map<Id,List<Apttus_Config2__PriceListItem__c>>();
		List<Apttus_Config2__PriceListItem__c> priceListLineItems = new List<Apttus_Config2__PriceListItem__c>();
		List<Customer_Document_Line_Items__c> cdLineUpdateList = new List<Customer_Document_Line_Items__c>();
		
		Id customerDocumentId;
		String customer;
		Boolean sanityCheck=false;
		List<Customer_Document_Line_Items__c> cdLines= new List<Customer_Document_Line_Items__c>();
		
		if(customerDocumentLineItems.size()>0) {
			customerDocumentId = customerDocumentLineItems[0].Customer_Document__c;
			
			for(Customer_Document_Line_Items__c cdLine : customerDocumentLineItems) {
	allCusDocLineIds.add(cdLine.Id);
	if(cdLine.Detailed_Product__c != null) {
		productCodes.add(cdLine.Detailed_Product__c); 
	}
	if(cdLine.Detailed_Product_Description__c != null){
		productDescriptions.add(cdLine.Detailed_Product_Description__c);
	}
			}
			
			//Fetch CD and CDLines
			Customer_Document__c customerDocument = QTOCustomerDocumentUtil.findAllCDLinesByCusDocId(customerDocumentId, QTO_Constants.ENRICHMENT);
			if(customerDocument != null) {
	customer = customerDocument.Customer__c;
	for(Customer_Document_Line_Items__c lineItem:  customerDocument.Customer_Document_Line_Items__r) {
		cdLines.add(lineItem);
	}
	cdLinesMap.put(customerDocument.Id, cdLines );
	
	for(Customer_Document_Junction__c cda : customerDocument.Customer_Document_Junctions__r) {
		associatedQuotesMap.put(cda.Id, cda.Quote_Proposal__c);
	}
	
	for(QTO_Customer_Document_Agreement__c cda : customerDocument.Customer_Document_Agreements__r) {
		associatedAgreementsMap.put(cda.Id, cda.QTO_Agreement__c);
	}
	
	//Find Header and Line Item level CFAs
	List<Customer_facing_Attribute__c> cusFacingAttributes = findAllCusFacingAttributes(customerDocumentId, allCusDocLineIds);
	for(Customer_facing_Attribute__c cfa : cusFacingAttributes) {
		if(cfa.Attribute_Label__c == 'PDF QUOTE REF') {
			if(cfa.QTO_Customer_Document__c != NULL || cfa.QTO_Customer_Document_Line_Items__c != NULL ) {
	pdfQuoteReferences.add(cfa.Attribute_Value__c);
			}
		}
		if(cfa.Attribute_Label__c == 'PDF CONTRACT REF') {
			if(cfa.QTO_Customer_Document__c != NULL || cfa.QTO_Customer_Document_Line_Items__c != NULL ) {
	pdfContractReferences.add(cfa.Attribute_Value__c);
			}
		} 
	}
	//Find the Quotes based on the Header and LineItem CFA
	List<Apttus_Proposal__Proposal__c> allQuotes  = QTOCustomerDocumentUtil.findAllAssociatedQuotes(customerDocumentId, pdfQuoteReferences, customer);
	
	//Find the Quotes based on the Header and LineItem CFA
	Map<Id,Apttus_Proposal__Proposal_Line_Item__c> soldToPatyQuoteLines = QTOCustomerDocumentUtil.findAllQuoteLinesBySoldToParty(customer);
	
	 Map<Id,Apttus_Proposal__Proposal_Line_Item__c> accountApprovedQuoteLines = findAllQuotesByAccount(customer);
	
	//Find the Agrements based on the associated Agrement and the Header and LineItem CFA
	List<Apttus__APTS_Agreement__c> allAgreements = findAllAgreements(pdfContractReferences, associatedAgreementsMap);
	//If Quote and Agreement not found then find the pricelsit belongs to the customer/SoldToParty
	List<Apttus_Config2__PriceList__c> allPriceLists = findAllPriceList(customer);
	//If Only customer product code provided 
	Map<Id,Product2> mapOfProducts =  finaByProductCodeAndDescription(productCodes,productDescriptions);
	
	if(!allQuotes.isEmpty()) {
		for(Apttus_Proposal__Proposal__c q : allQuotes){
			pdfQuoteRefQuoteIdAndAgreeIdMap.put(q.Id,q.Agreement_Lookup__c);
			pdfQuoteRefQuoteIdAndPriceListIdMap.put(q.Id,q.Apttus_QPConfig__PriceListId__c); 
			List<Apttus_Proposal__Proposal_Line_Item__c> quoteLines = new List<Apttus_Proposal__Proposal_Line_Item__c>();
			for(Apttus_Proposal__Proposal_Line_Item__c lineItem:  q.Apttus_Proposal__R00N70000001yUfBEAU__r) {
	quoteLines.add(lineItem);
			}
			quoteAndLinesMap.put(q.Id,quoteLines);
		}
	}
	
	System.debug('allAgreements : '+ allAgreements);
	if(!allAgreements.isEmpty()) {
		for(Apttus__APTS_Agreement__c apAgree : allAgreements) {
			List<Apttus__AgreementLineItem__c> agreeLines = new List<Apttus__AgreementLineItem__c>();
			for(Apttus__AgreementLineItem__c lineItem :  apAgree.Apttus__AgreementLineItems__r) {
	agreeLines.add(lineItem);
			}
			agreementAndLinesMap.put(apAgree.Id,agreeLines);
		}
	}
	
	System.debug('allPriceLists : '+ allPriceLists);
	if(!allPriceLists.isEmpty()) {
		for(Apttus_Config2__PriceList__c pl : allPriceLists) { 
			List<Apttus_Config2__PriceListItem__c> priceListItems = new List<Apttus_Config2__PriceListItem__c>();
			for(Apttus_Config2__PriceListItem__c priceListItem:  pl.Apttus_Config2__Items__r) {
	priceListItems.add(priceListItem);
			}
			priceListItemsMap.put(pl.Id,priceListItems);
		}
	}
	
	//Get Product information form Product table 
	System.debug('mapOfProducts : '+ mapOfProducts);
	if(!mapOfProducts.isEmpty()) {
		for(Product2 p : mapOfProducts.values()){
			if(p.ProductCode != null){
	productCodesMap.put(p.ProductCode,p.Id); 
			}
			if(p.Name != null){
	productDescriptionsMap.put(p.Name,p.Id); 
			}
		}
	}
	
	//Main Logic Starts 
	Map<Id, Boolean> hasCDLineEnrichmentIssue = new Map<Id, Boolean>();
	for(Customer_Document_Line_Items__c cdLineItem : cdLinesMap.get(customerDocument.Id)) {
	//1001 Error Code
		exceptionMetadata = exceptionConfigMetaData.get('CDLI Registration 1001');
	//Basic Sanity Check
		sanityCheck = cdLineSanityCheck(customerDocument, cdLineItem, customerDocument.Id, exceptionMetadata);
		System.debug('Sanity Result...'+sanityCheck);
		if(!sanityCheck) {
			issueLog=null;
			exceptionMetadata = null;
			Boolean isLineFound = false;
			
			//Enrichment Based on Associated Quotes
			if(quoteAndLinesMap.size()> 0) {
	System.debug('Search Product In [Quote] ');
	for(Id quoteId : quoteAndLinesMap.keyset()){
		if(quoteAndLinesMap.containsKey(quoteId)){
			for(Apttus_Proposal__Proposal_Line_Item__c qouteLine : quoteAndLinesMap.get(quoteId)) {
	isLineFound = findEnrichmentByQuoteLine(cdLineItem, qouteLine);
	if(isLineFound) break;
			}
		}
	}
	System.debug('[Quote] > isLineFound' + isLineFound);
			}
			//Enrichment Based on soldToParty
			if(soldToPatyQuoteLines.size()> 0 && isLineFound == false) {
	System.debug('Search Product In [soldToPatyQuoteLines] ');
	for(Apttus_Proposal__Proposal_Line_Item__c qouteLine : soldToPatyQuoteLines.values()) {
		isLineFound = findEnrichmentByQuoteLine(cdLineItem, qouteLine);
		if(isLineFound) break;
	}
	System.debug('[SoldToParty Quote] > isLineFound' + isLineFound);
			}
			
			//Enrichment Based on Account
			if(accountApprovedQuoteLines.size()> 0 && isLineFound == false) {
	System.debug('Search Product In [accountApprovedQuoteLines] ');
	for(Apttus_Proposal__Proposal_Line_Item__c qouteLine : accountApprovedQuoteLines.values()) {
		isLineFound = findEnrichmentByQuoteLine(cdLineItem, qouteLine);
		if(isLineFound) break;
	}
	System.debug('[accountApprovedQuoteLines Quote] > isLineFound' + isLineFound);
			}
			
			//Enrichment Based on Associated Agrrement
			if(pdfQuoteRefQuoteIdAndAgreeIdMap.size()>0 && isLineFound == false) {
	System.debug('Search Product In [Quote > Aggrements] ');
	isLineFound = searchProductInQuoteAndAgreement(pdfQuoteRefQuoteIdAndAgreeIdMap, cdLineItem, agreementAndLinesMap);
	System.debug('[Quote > Aggrements] > isLineFound] ' + isLineFound);
			}
			
			//Agreement check
			if(agreementAndLinesMap.size()>0 && isLineFound == false) {
	System.debug('Search Product In [Agreement] ');
	for(Id agreementId : agreementAndLinesMap.keyset()){
		for(Apttus__AgreementLineItem__c agreeLineItem : agreementAndLinesMap.get(agreementId)){
			if(cdLineItem.High_level_Product__c == agreeLineItem.CLM_CFE_Reference__c){
	cdLineItem.Contract_Item_Number__c = agreeLineItem.CLM_CFE_Reference__c;
	cdLineItem.QTO_Product_Code__c = agreeLineItem.Product_Code__c;
	cdLineItem.QTO_Product_Name__c = agreeLineItem.Apttus__ProductId__c;
	isLineFound = true;
	break;
			}
			else {
	if(cdLineItem.High_level_Product__c == agreeLineItem.Product_Code__c){
		cdLineItem.Contract_Item_Number__c = agreeLineItem.Product_Code__c;
		cdLineItem.QTO_Product_Code__c = agreeLineItem.Product_Code__c;
		cdLineItem.QTO_Product_Name__c = agreeLineItem.Apttus__ProductId__c;
		isLineFound = true;
		break;
	
	}
			}
		}  
	}
	System.debug('[Agreement] isLineFound : '+isLineFound);
			}
			
			//Price List Check
			if(priceListItemsMap.size() > 0 && isLineFound == false){
	Integer count = 0;
	System.debug('Search Product In [priceList] ');
	for(Id priceListId : priceListItemsMap.keyset()) {
		if(priceListItemsMap.containsKey(priceListId)) {
			for(Apttus_Config2__PriceListItem__c priceListLineItem : priceListItemsMap.get(priceListId)) {
	if(cdLineItem.High_level_Product__c == priceListLineItem.Apttus_Config2__ContractItemNumber__c) {
		cdLineItem.Contract_Item_Number__c = priceListLineItem.Apttus_Config2__ContractItemNumber__c;
		cdLineItem.QTO_Product_Code__c = priceListLineItem.Apttus_Config2__ProductCode__c;
		cdLineItem.QTO_Product_Name__c = priceListLineItem.Apttus_Config2__ProductId__c;
		cdLineItem.Price_List_Item__c = priceListLineItem.Id;
		cdLineItem.QTO_Customer_Grouping__c = priceListLineItem.DS_Grouping_Name__c;
		isLineFound = true;
		count= count + 1;
	}
			}
		}
	}
	if(count >1) {
		exceptionMetadata = exceptionConfigMetaData.get('CDLI Registration 1127');
		//Issue Log - 1127
		issueLog = createIssueLog(customerDocumentId, cdLineItem.Id, exceptionMetadata.QTO_Return_Type__c, String.valueOf(exceptionMetadata.QTO_Return_Code__c), exceptionMetadata.QTO_Log_Details__c);
		issueLogList.add(issueLog);
	}
	System.debug('[priceList] isLineFound : '+isLineFound);
			}
			
			
			//Product  Check
			if ((productCodesMap.size() > 0 || productDescriptionsMap.size()> 0) && isLineFound == false) {
	if(cdLineItem.Detailed_Product__c == null || cdLineItem.Detailed_Product__c == ''){
		exceptionMetadata = exceptionConfigMetaData.get('CDLI Registration 1121');
		//Issue Log - 1121
		issueLog = createIssueLog(customerDocumentId, cdLineItem.Id, exceptionMetadata.QTO_Return_Type__c, String.valueOf(exceptionMetadata.QTO_Return_Code__c), exceptionMetadata.QTO_Log_Details__c);
		issueLogList.add(issueLog);
	}
	if(cdLineItem.Detailed_Product_Description__c == null || cdLineItem.Detailed_Product_Description__c == ''){
		exceptionMetadata = exceptionConfigMetaData.get('CDLI Registration 1122');
		//Issue Log - 1122
		issueLog = createIssueLog(customerDocumentId, cdLineItem.Id, exceptionMetadata.QTO_Return_Type__c, String.valueOf(exceptionMetadata.QTO_Return_Code__c), exceptionMetadata.QTO_Log_Details__c);
		issueLogList.add(issueLog);
	}	
	System.debug('Search Product In [Product] ');
	for(Product2 prod : mapOfProducts.values()) {
		if(cdLineItem.Detailed_Product__c == prod.ProductCode || cdLineItem.Detailed_Product_Description__c == prod.Name){
			//cdLineItem.Contract_Item_Number__c = cdLineItem.High_level_Product__c;
			cdLineItem.QTO_Product_Code__c = prod.ProductCode;
			cdLineItem.QTO_Product_Name__c = prod.Id;
			isLineFound = true;
			break;
		}
	}
	System.debug('[Product] >> isLineFound : '+ isLineFound);
			}
			
			updateLineItemsFields(cdLineItem);
			
			if(isLineFound && cdLineItem.Quantity__c != null && cdLineItem.QTO_Unit_of_Measure__c!=null 
		 && cdLineItem.QTO_Unit_Price__c !=null && cdLineItem.CurrencyIsoCode!=null) {
	cdLineItem.Status__c = QTO_Constants.STATUS_ENRICHED;
	cdLineItem.QTO_CDLI_Matched_Quoted_Quantity__c = 0;
	cdLineItem.QTO_CDLI_Matched_Contracted_Quantity__c = 0;
		 }
			else {
	cdLineItem.Status__c = QTO_Constants.STATUS_ENRICHMENT_FAILED;
	exceptionMetadata = exceptionConfigMetaData.get('CDLI Registration 1002');
	//Issue Log - 1002 
	issueLog = createIssueLog(customerDocumentId, cdLineItem.Id, exceptionMetadata.QTO_Return_Type__c, String.valueOf(exceptionMetadata.QTO_Return_Code__c), exceptionMetadata.QTO_Log_Details__c);   
	issueLogList.add(issueLog);
	hasCDLineEnrichmentIssue.put(cdLineItem.Id, true);
	
			}
			cdLineUpdateList.add(cdLineItem);
		}
		else{
			cdLineUpdateList.add(cdLineItem);
		}
	}
	
	System.debug('sanityFailureMap....'+ sanityFailureMap);
	if(sanityFailureMap.size() > 0 && sanityFailureMap != NULL) {
		createTask(customerDocumentId);   
	}
	
	if(cdLineUpdateList.size()>0){
		update cdLineUpdateList;
	} 
	System.debug('Issue Log.....'+issueLogList.size());
	System.debug('Issue Log.....'+issueLogList);
	
	if(issueLogList.size()>0){
		upsert issueLogList;
	}
				/*
	if(!sanityFailureMap.isEmpty() || (customerDocumentLineItems.size() == hasCDLineEnrichmentIssue.size())) {
		customerDocument.Status__c =  QTO_Constants.STATUS_ENRICHMENT_FAILED;
		update customerDocument;
	}
	else {
		customerDocument.Status__c =  QTO_Constants.STATUS_ENRICHED;
		update customerDocument;
	}
*/
	
	
			}
		}
	}
	
	@TestVisible
	private static Boolean searchProductInQuoteAndAgreement(Map<Id,Id> pdfQuoteRefQuoteIdAndAgreeIdMap, Customer_Document_Line_Items__c cdLineItem, Map<Id,List<Apttus__AgreementLineItem__c>> agreementAndLinesMap){
		Boolean isLineFound = false;
		for(Id agreementId : pdfQuoteRefQuoteIdAndAgreeIdMap.keyset()) {
			if(agreementAndLinesMap.containsKey(agreementId)){
	for(Apttus__AgreementLineItem__c agreeLineItem : agreementAndLinesMap.get(agreementId)) {
		if(cdLineItem.High_level_Product__c == agreeLineItem.CLM_CFE_Reference__c) {
			cdLineItem.Contract_Item_Number__c = agreeLineItem.CLM_CFE_Reference__c;
			cdLineItem.QTO_Product_Code__c = agreeLineItem.Product_Code__c;
			cdLineItem.QTO_Product_Name__c = agreeLineItem.Apttus__ProductId__c;
			isLineFound = true;
			break;
		}
		else {
			if(cdLineItem.High_level_Product__c == agreeLineItem.Product_Code__c) {
	cdLineItem.Contract_Item_Number__c = agreeLineItem.Product_Code__c;
	cdLineItem.QTO_Product_Code__c = agreeLineItem.Product_Code__c;
	cdLineItem.QTO_Product_Name__c = agreeLineItem.Apttus__ProductId__c;
	isLineFound = true;
	break;
			} 
		}
	}
			}  
		}
		return isLineFound;
	}
	
	
	
	//Sanity Check on the Customer Line Item 
	private static Boolean cdLineSanityCheck(Customer_Document__c cdoc, Customer_Document_Line_Items__c cdLineItem , Id  cdId, QTO_Exception_Configuration__mdt exceptionMetadata) {
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
	
	
	private static List<Customer_facing_Attribute__c> findAllCusFacingAttributes(Id cusDocId, List<Id> allCusDocLineIds){
		List<Customer_facing_Attribute__c> allCusfacingAttributes = 
			[
	Select Id,Attribute_Label__c,Attribute_Value__c,QTO_Customer_Document_Line_Items__c, QTO_Customer_Document__c 
	from Customer_facing_Attribute__c 
	where  Attribute_Label__c IN ('PDF QUOTE REF','PDF CONTRACT REF')
	AND (QTO_Customer_Document__c =: cusDocId OR QTO_Customer_Document_Line_Items__c IN :allCusDocLineIds)
			];
		return allCusfacingAttributes;
	}
	
	
	private static List<Apttus__APTS_Agreement__c> findAllAgreements(List<String> pdfContractReferences, Map<Id,Id> associatedAgreementsMap){
		List<Apttus__APTS_Agreement__c> allAgreements = 
			[
	Select Id, Apttus_CMConfig__PriceListId__c, Apttus__Account__c, Agreement_External_Contract_Number__c,Name,
	Apttus__FF_Agreement_Number__c, Nokia_Legal_Entity_lookup__c,
	(
		Select Id,Apttus__AgreementId__c,Name,Apttus__Description__c,Contract_Item_Number__c,CLM_CFE_Reference__c,
		Apttus__ProductId__c,Apttus__ProductId__r.ProductCode, Product_Code__c 
		From Apttus__AgreementLineItems__r
	) from Apttus__APTS_Agreement__c where  Apttus__Status__c = 'Activated' AND Apttus__Status_Category__c ='In Effect'
	AND ((Agreement_External_Contract_Number__c IN : pdfContractReferences OR NAME IN :pdfContractReferences) OR Id In:associatedAgreementsMap.values())
			];
		return allAgreements;
	}
	private static List<Apttus_Config2__PriceList__c> findAllPriceList(String customer){
		List<Apttus_Config2__PriceList__c> allPriceLists = 
			[
	Select Id,Apttus_Config2__ContractNumber__c, Project_Price_List_Number__c, Name,Apttus_Config2__Description__c, 
	(
		Select Id,Apttus_Config2__ProductId__c,DS_Grouping_Name__c,Apttus_Config2__ProductCode__c,
		Apttus_Config2__ContractItemNumber__c from Apttus_Config2__Items__r 
	) 
	from Apttus_Config2__PriceList__c where Apttus_Config2__AccountId__c =: customer AND Apttus_Config2__Active__c = true
			];
		return allPriceLists;
	}
	
	@TestVisible
	private static Map<Id,Product2> finaByProductCodeAndDescription(List<String> productCodes, List<String> productDescriptions) {
		Map<Id,Product2> mapOfProducts = new Map<Id,Product2>([Select Id, ProductCode, Name,Description 
	  from Product2 where ProductCode IN : ProductCodes OR Name IN : ProductDescriptions]);
		return mapOfProducts;		 
	}
	
	
	@TestVisible
	private static void createTask(Id cusDocId) {
		QTO_Exception_Configuration__mdt exceptionMetadata = exceptionConfigMetaData.get('CDLI Registration 1001');
		
		Task task = QTO_CustomerDocument_Helper.createTask(cusDocId, String.valueOf(exceptionMetadata.QTO_Return_Code__c) , exceptionMetadata.QTO_Tasks_Status__c, exceptionMetadata.QTO_Task_Subject__c, exceptionMetadata.QTO_Log_Details__c, exceptionMetadata.QTO_Investigating_Group__c);
		insert task ;
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
	
	private static Boolean findEnrichmentByQuoteLine(Customer_Document_Line_Items__c cdLineItem, Apttus_Proposal__Proposal_Line_Item__c qouteLine) {
		Boolean isEnriched = false;
		if(cdLineItem.High_level_Product__c == qouteLine.External_Reference__c) {
			cdLineItem.Contract_Item_Number__c = qouteLine.External_Reference__c;
			cdLineItem.QTO_Product_Code__c = qouteLine.Apttus_Proposal__Product__r.ProductCode;
			cdLineItem.QTO_Product_Name__c = qouteLine.Apttus_Proposal__Product__c;
			cdLineItem.Price_List_Item__c = qouteLine.Apttus_QPConfig__PriceListItemId__c;
			cdLineItem.QTO_Customer_Grouping__c = qouteLine.Apttus_QPConfig__PriceListItemId__r.DS_Grouping_Name__c;
			isEnriched = true;
		}
		else {
			if(cdLineItem.High_level_Product__c == qouteLine.Product_Code__c) {
	cdLineItem.Contract_Item_Number__c = qouteLine.Product_Code__c;
	cdLineItem.QTO_Product_Code__c = qouteLine.Apttus_Proposal__Product__r.ProductCode;
	cdLineItem.QTO_Product_Name__c = qouteLine.Apttus_Proposal__Product__c;
	cdLineItem.Price_List_Item__c = qouteLine.Apttus_QPConfig__PriceListItemId__c;
	cdLineItem.QTO_Customer_Grouping__c = qouteLine.Apttus_QPConfig__PriceListItemId__r.DS_Grouping_Name__c;
	isEnriched = true;
			}  
		}
		return isEnriched;
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
	Apttus_QPConfig__Uom__c, Apttus_QPConfig__PriceListItemId__r.DS_Grouping_Name__c, Apttus_QPConfig__NetUnitPrice__c, Apttus_Proposal__Proposal__r.CurrencyIsoCode, QTO_QL_Available_Quantity__c  
	FROM Apttus_Proposal__Proposal_Line_Item__c 
	WHERE Apttus_Proposal__Proposal__r.Apttus_Proposal__Account__c IN : parentIds
	AND Apttus_Proposal__Proposal__r.Apttus_Proposal__Approval_Stage__c = 'Approved'
	AND Apttus_QPConfig__LineType__c = 'Product/Service'
	ORDER BY  Apttus_Proposal__Proposal__r.CreatedDate
			]); 
		return accountQls;
	}
	/*
private static Customer_Document__c findCDLineItemsByCDId(Id cusDocId) {
List<Customer_Document__c> customerDocData =   [Select Id,Name,QTO_Nature__c, Customer__c,(Select Id,High_level_Product__c,High_level_Product_Description__c,QTO_PDF_Unit_Of_Measure__c,QTO_PDF_Quantity__c,QTO_PDF_Unit_Price__c,
QTO_PDF_Currency_Code__c,Detailed_Product__c,Detailed_Product_Description__c, Quantity__c, QTO_Unit_of_Measure__c, QTO_Unit_Price__c, CurrencyIsoCode,
QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c,Contract_Item_Number__c,QTO_PDF_Total_Value__c,QTO_PDF_Requested_Delivery_Date__c,
Price_List_Item__c,Customer_Document__c,Customer_Document__r.Customer__c, Customer_Document__r.QTO_Currency__c
from Customer_Document_Line_Items__r WHERE (Status__c=NULL OR Status__c=:QTO_Constants.STATUS_ENRICHMENT_FAILED)),(Select Id, QTO_Agreement__c, QTO_Agreement_Ref_in_PDF__c,
QTO_Agreement_Status__c,QTO_Customer_Document__c from Customer_Document_Agreements__r)
from Customer_Document__c where Id =: cusDocId  AND (Status__c =: QTO_Constants.CD_STATUS_LINES_HANDOFF OR Status__c=:QTO_Constants.STATUS_ENRICHMENT_FAILED)];


if(customerDocData.size() >0 ) {
return customerDocData[0];
}
return null;
}
*/

}