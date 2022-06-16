/*********************************************************************
* Class Name  : QTO_CDLineItemMatchingHelper
* Test Class  : QTO_CdLineItemAssociationHelperTest
* Created Date: 14 Jun 2021
* Created By  : Kantam, Rithvik
* Description : This class is for Line item Matching and Cd status updates
* Modified By : Shaik, Johny 
* Description : DSI-2148, DSI-2151, DSI-2153 & DSI-2159
*******************************************************************/ 
public with sharing class QTO_CDLineItemMatchingHelper {
	static List<QTO_Customer_Document_Issue_Log__c> issueLogList = new List<QTO_Customer_Document_Issue_Log__c>();
	static Map<String,QTO_Exception_Configuration__mdt> exceptionConfigMetaData = new Map<String,QTO_Exception_Configuration__mdt>();
	static QTO_Exception_Configuration__mdt exceptionMetadata = null;
	
	public static void matchCdLineItems(List<Customer_Document_Line_Items__c> cusDocLines){
		fetchExceptionConfigMetaData(); 
		System.debug('QTO_CDLineItemMatchingHelper >> matchCdLineItems');
		Id customerDocId;
		List<Id> allCusDocLineIds = new List<Id>();
		
		//retrive the customer doc ids and Cdline-item ids
		for(Customer_Document_Line_Items__c cdLine : cusDocLines) {
			customerDocId = cdLine.Customer_Document__c;
			allCusDocLineIds.add(cdLine.Id);
		}
		//Query >>  Customer Document and Customer Document Line 
		List<Customer_Document_Line_Items__c> cdLineList = findCustomerDocumentById(allCusDocLineIds);
		System.debug('cdLineList : ' +cdLineList.size());
		
		Map<Id,List<QTO_Customer_Document_Quote_Line__c>> cdQuoteLinesMap = new Map<Id,List<QTO_Customer_Document_Quote_Line__c>>();
		Map<Id,List<QTO_Customer_Document_Agreement_Line__c>> cdAgreementLinesMap = new Map<Id,List<QTO_Customer_Document_Agreement_Line__c>>();
	   
		List<Id> quoteLineIds = new List<Id>();
		List<Id> aggrementLineIds = new List<Id>();
		
		//update quantity for QuoteLineItems
		Map<Id,Apttus_Proposal__Proposal_Line_Item__c>  updateQuoteLineItems = new  Map<Id,Apttus_Proposal__Proposal_Line_Item__c>();
		//update quantity for AgreementLineItems
		Map<Id,Apttus__AgreementLineItem__c> updateAgreementLineItems = new Map<Id,Apttus__AgreementLineItem__c>();
		Id cusDocId=null;
		if(!cdLineList.isEmpty()) {
			for(Customer_Document_Line_Items__c cdline : cdLineList) {
				cusDocId = cdline.Customer_Document__c;
				List<QTO_Customer_Document_Quote_Line__c> cdQuoteLines = new List<QTO_Customer_Document_Quote_Line__c>();
				List<QTO_Customer_Document_Agreement_Line__c> cdAggrLines = new List<QTO_Customer_Document_Agreement_Line__c>();
				for(QTO_Customer_Document_Quote_Line__c lineItem :  cdline.Customer_Document_Quote_Lines__r) {
					cdQuoteLines.add(lineItem);
					quoteLineIds.add(lineItem.QTO_Proposal_Line_Item__c);
				}
				
				for(QTO_Customer_Document_Agreement_Line__c lineItem :  cdline.Customer_Document_Agreement_Line_Items__r) {
					cdAggrLines.add(lineItem);
					aggrementLineIds.add(lineItem.QTO_Agreement_Line_Item__c);
				}
				
				if(!cdQuoteLines.isEmpty()) {
					cdQuoteLinesMap.put(cdline.Id, cdquoteLines);
				}
				if(!cdAggrLines.isEmpty()){
					cdAgreementLinesMap.put(cdline.Id, cdAggrLines);
				}
			}
		}
		
		Map<Id,Apttus_Proposal__Proposal_Line_Item__c>  quoteLinesMap = getAllQuoteLineItems(quoteLineIds);
		Map<Id,Apttus__AgreementLineItem__c>  aggrementLinesMap = getAllAgreementLineItems(aggrementLineIds);
		
		System.debug('quoteLinesMap ...'+quoteLinesMap);
		System.debug('aggrementLinesMap ...'+aggrementLinesMap);
		List<Customer_Document_Line_Items__c> updatedCdLines = new List<Customer_Document_Line_Items__c>(); 
		
		//Verify the Relationship Query for Customer Document and Customer Document Line and Associated agreements
		Customer_Document__c customerDocData = findCDLineItemsByCDId(cusDocId);
		
		List<QTO_Customer_Document_Quote_Line__c>  updatedAssociateQuoteLines = new List<QTO_Customer_Document_Quote_Line__c>(); 
		List<QTO_Customer_Document_Agreement_Line__c>  updatedAssociateAgreementLines = new List<QTO_Customer_Document_Agreement_Line__c>(); 
		
		for(Customer_Document_Line_Items__c cusDocLine : cdLineList) {
			
			Apttus_Proposal__Proposal_Line_Item__c matchedQuote = null;
			Apttus__AgreementLineItem__c matchedAgreementLine = null;
			Double cdLineQuantity = Decimal.valueOf(cusDocLine.Quantity__c);
			//Double lineItemQuantity=0.0;
			System.debug('CD Line Quantity ....'+cdLineQuantity);
			if(cdQuoteLinesMap.containsKey(cusDocLine.Id)) {
				for(QTO_Customer_Document_Quote_Line__c associationToLine :cdQuoteLinesMap.get(cusDocLine.Id)) {
					//System.debug('QTO_Customer_Document_Quote_Line__c >>>> associationToLine ....'+associationToLine);
					if(quoteLinesMap.containsKey(associationToLine.QTO_Proposal_Line_Item__c)) {
						matchedQuote = quoteLinesMap.get(associationToLine.QTO_Proposal_Line_Item__c);
						System.debug('matchedQuote ....'+matchedQuote);
						QTO_CdLineItemAssociationHelper.updateMatchedQuoteQuantity(associationToLine, cusDocLine, matchedQuote, updateQuoteLineItems, issueLogList);   
			updatedAssociateQuoteLines.add(associationToLine);
					}
				}
			}
			if(cdAgreementLinesMap.containsKey(cusDocLine.Id)) {
				System.debug('cdAgreementLinesMap>>>>> '+cdAgreementLinesMap.size());
				for(QTO_Customer_Document_Agreement_Line__c associationToLine :cdAgreementLinesMap.get(cusDocLine.Id)) {
					System.debug('QTO_Customer_Document_Agreement_Line__c >>>> associationToLine ....'+associationToLine);
					if(aggrementLinesMap.containsKey(associationToLine.QTO_Agreement_Line_Item__c)) {
						matchedAgreementLine = aggrementLinesMap.get(associationToLine.QTO_Agreement_Line_Item__c);
						QTO_CdLineItemAssociationHelper.updateMatchedAgreementQuantity(associationToLine, cusDocLine, matchedAgreementLine , updateAgreementLineItems, issueLogList);
						updatedAssociateAgreementLines.add(associationToLine);
					}
				}
			}
			
			System.debug('cusDocLine.QTO_CDLI_Matching_Comment__c .....'+ cusDocLine.QTO_CDLI_Matching_Comment__c);
		
			
			if(cusDocLine.QTO_CDLI_Matching_Comment__c == 'Matching Successful')
				 cusDocLine.Status__c='Matched(Lines)';
			else if(cusDocLine.QTO_CDLI_Matching_Comment__c == 'Matching Failed')
				cusDocLine.Status__c='Exception-Matching(Lines)';
			else
				cusDocLine.Status__c='Partial Matched';
										   
			updatedCdLines.add(cusDocLine);
		}
		
		if(updatedCdLines.size()>0){
			update updatedCdLines;
		}
		
		if(!updatedAssociateQuoteLines.isEmpty()){
			update updatedAssociateQuoteLines;
		}
		if(!updatedAssociateAgreementLines.isEmpty()){
			update updatedAssociateAgreementLines;
		}
		if(issueLogList.size()>0){
		   
			exceptionMetadata = exceptionConfigMetaData.get('CDLI Match 5001');
			Task task = QTO_CustomerDocument_Helper.createTask(customerDocId, String.valueOf(exceptionMetadata.QTO_Return_Code__c) , exceptionMetadata.QTO_Tasks_Status__c, exceptionMetadata.QTO_Task_Subject__c, exceptionMetadata.QTO_Log_Details__c, exceptionMetadata.QTO_Investigating_Group__c);
		   
			insert task;
			insert issueLogList;
			
		}
		System.debug('updateQuoteLineItems...'+updateQuoteLineItems);
		if(!updatedAssociateQuoteLines.isEmpty()){
			update updateQuoteLineItems.values();
		}
		System.debug('updateAgreementLineItems...'+updateAgreementLineItems);
		if(!updateAgreementLineItems.isEmpty()){
			update updateAgreementLineItems.values();
		}		  
	 }
	
	private static Customer_Document__c findCDLineItemsByCDId(Id cusDocId) {
		
		List<Customer_Document__c> customerDocData = [Select Id,Customer__c,QTO_Line_Item_Matching_Comment__c, Status__c from Customer_Document__c where Id =: cusDocId];
		if(customerDocData.size()>0){
			return customerDocData[0];
		}
		return null;
	}
	
	//Get All Quote Line Items
	public static Map<Id,Apttus_Proposal__Proposal_Line_Item__c> getAllQuoteLineItems(List<Id> quoteLineIds) {
		Map<Id,Apttus_Proposal__Proposal_Line_Item__c> allQuoteLines = new Map<Id,Apttus_Proposal__Proposal_Line_Item__c>
			([
				Select Id,Name,NokiaCPQ_Product_Name__c,Apttus_QPConfig__PriceListItemId__c,Apttus_Proposal__Proposal__c,
				Apttus_Proposal__Proposal__r.Name, Apttus_Proposal__Proposal__r.NokiaCPQ_Proposal_Id__c,Apttus_Proposal__Proposal__r.Id, 
				Apttus_Proposal__Product__c,DS_Grouping_Name__c,Product_Code__c,Apttus_Proposal__Product__r.ProductCode,
				External_Reference__c, Apttus_Proposal__Quantity__c, Apttus_QPConfig__Quantity2__c,QTO_QLI_Matched_Risk_Quantity__c, Apttus_QPConfig__Uom__c, 
				Apttus_QPConfig__NetUnitPrice__c, Apttus_Proposal__Proposal__r.CurrencyIsoCode   
				from Apttus_Proposal__Proposal_Line_Item__c where Apttus_Proposal__Proposal__r.Apttus_Proposal__Approval_Stage__c = 'Approved'
				AND Id IN :quoteLineIds
			]); 
		return allQuoteLines;
	}
	
	//Get All Agreement Line Items
	public static Map<Id,Apttus__AgreementLineItem__c> getAllAgreementLineItems(List<Id> aggrementLineIds) {
		Map<Id,Apttus__AgreementLineItem__c> allAgreementLines = new Map<Id,Apttus__AgreementLineItem__c>
			([
				Select Id,Name, Apttus__Quantity__c, QTO_ALI_Matched_Contracted_Quantity__c, Apttus_CMConfig__Uom__c, 
				Apttus_CMConfig__NetUnitPrice__c, Apttus__NetPrice__c, Apttus__AgreementId__r.CurrencyIsoCode
				from Apttus__AgreementLineItem__c where Id IN :aggrementLineIds
			]); 
		return allAgreementLines;
	}
	
	
	/**Get customer document*/
	private static List<Customer_Document_Line_Items__c> findCustomerDocumentById(List<Id> allCusDocLineIds) {
		
		List<Customer_Document_Line_Items__c> cdLineList = 
			[
				Select Id,High_level_Product__c,High_level_Product_Description__c,Detailed_Product_Code__c,Detailed_Product_Description__c,Site__c,
				QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c,QTO_Product_Name__r.Name,Contract_Item_Number__c,Price_List_Item__c,
				Customer_Document__c, Status__c, Association_Comment__c, QTO_CDLI_Matching_Comment__c,QTO_Association__c ,Customer_Document__r.Sub_Classification__c, Customer_Document__r.Customer__c, 
				Quantity__c, QTO_CDLI_Matched_Quoted_Quantity__c, QTO_CDLI_Matched_Contracted_Quantity__c, Customer_Document__r.Status__c, QTO_Unit_Price__c, QTO_Unit_of_Measure__c,CurrencyIsoCode, 
				(select id, name, QTO_CDLIA_Match_Quoted_Comment__c,QTO_CDLIA_Matched_Quoted_Quantity__c, QTO_Proposal_Line_Item__c,QTO_CDLIA_Matching__c  from Customer_Document_Quote_Lines__r), 
				(select id, name, QTO_CDLIA_Match_Contracted_Comment__c,QTO_CDLIA_Matched_Contracted_Quantity__c,QTO_Agreement_Line_Item__c, QTO_CDLIA_Matching__c   from Customer_Document_Agreement_Line_Items__r) 
				from Customer_Document_Line_Items__c where id IN :allCusDocLineIds AND Status__c IN ('Partial Matched','Exception-Matching(Lines)','Manually-Associated(Lines)')
			];
		return cdLineList;
	}
	
	/**Get customer document*/
	public static List<Customer_Document_Line_Items__c> findAllCDLines(List<Id> allCusDocLineIds) {
		
		List<Customer_Document_Line_Items__c> cdLineList = [Select Id,High_level_Product__c,High_level_Product_Description__c,Detailed_Product_Code__c,Detailed_Product_Description__c,Site__c,
															QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c,QTO_Product_Name__r.Name,Contract_Item_Number__c,Price_List_Item__c,
															Customer_Document__c, Status__c, Association_Comment__c, QTO_CDLI_Matching_Comment__c,
															QTO_Association__c , QTO_CDLI_Association_Waiver_Comment__c, QTO_CDLI_Matching_Waiver_Comment__c, Customer_Document__r.Customer__c, Quantity__c, QTO_CDLI_Matched_Quoted_Quantity__c, 
															QTO_CDLI_Matched_Contracted_Quantity__c, Customer_Document__r.Status__c 
						from Customer_Document_Line_Items__c where id IN :allCusDocLineIds];
		return cdLineList;
	}
	
	
	//DSI-2159 :: Visualization
	//update customer document status
	public static void updateCDocStatus(List<Customer_Document_Line_Items__c> cusDocLines) {
		System.debug('QTO_CDLineItemMatchingHelper >> updateCDocStatus');
		Id customerDocId;
		List<Id> allCusDocLineIds = new List<Id>();
		Map<Id, Customer_Document_Line_Items__c>  enrichmentFailureMap = new Map<Id, Customer_Document_Line_Items__c>();
		Map<Id, Customer_Document_Line_Items__c>  associationFailureMap = new Map<Id, Customer_Document_Line_Items__c>();
		Map<Id, Customer_Document_Line_Items__c>  matchingFailureMap = new Map<Id, Customer_Document_Line_Items__c>();
		
		//retrive the customer doc ids and Cdline-item ids
		for(Customer_Document_Line_Items__c cdLine : cusDocLines) {
			customerDocId = cdLine.Customer_Document__c;
			allCusDocLineIds.add(cdLine.Id);
		}
		
		//Query >>  Customer Document and Customer Document Line 
		List<Customer_Document_Line_Items__c> cdLineList = findAllCDLines(allCusDocLineIds);
		//Verify the Relationship Query for Customer Document and Customer Document Line and Associated agreements
		Customer_Document__c customerDocData = findCDLineItemsByCDId(customerDocId);
		
		System.debug('QTO_CDLineItemMatchingHelper cdLineList>>'+cdLineList.size());
		
		for(Customer_Document_Line_Items__c cdLine : cdLineList) {
			if(cdLine.Status__c == QTO_Constants.STATUS_ENRICHMENT_FAILED) {
				enrichmentFailureMap.put(cdLine.Id, cdLine);
			}
			else if(cdLine.Status__c =='Exception-Association(Lines)'
					&& (cdLine.QTO_CDLI_Association_Waiver_Comment__c =='No' || cdLine.QTO_CDLI_Association_Waiver_Comment__c =='Not Attempted')) {
				associationFailureMap.put(cdLine.Id, cdLine);
			}
			else if((cdLine.Status__c =='Exception-Matching(Lines)' || cdLine.Status__c =='Partial Matched')
					&& (cdLine.QTO_CDLI_Matching_Waiver_Comment__c =='No' || cdLine.QTO_CDLI_Matching_Waiver_Comment__c =='Not Attempted')) {
						matchingFailureMap.put(cdLine.Id, cdLine);
			}
		}
		
		if(!enrichmentFailureMap.isEmpty()) {
			//customerDocData.QTO_Line_Iteam_Association_Comment__c =  'Failed';
			//customerDocData.QTO_Line_Item_Matching_Comment__c =  'Failed';
			//customerDocData.Status__c =  QTO_Constants.STATUS_ENRICHMENT_FAILED;
			//QTO_CustomerDocumentMaturityLevel.processMaturityLevel(new Set<Id>{customerDocData.Id }, QTO_Constants.STATUS_ENRICHMENT_FAILED);
		}
		else if(!associationFailureMap.isEmpty()) {
			//customerDocData.QTO_Line_Iteam_Association_Comment__c =  'Failed';
			//customerDocData.Status__c =  'Exception-Association(Lines)';
			//QTO_CustomerDocumentMaturityLevel.processMaturityLevel(new Set<Id>{customerDocData.Id }, QTO_Constants.STATUS_ASSOCIATION_FAILED);
		}
		else if(!matchingFailureMap.isEmpty()) {
			//customerDocData.QTO_Line_Iteam_Association_Comment__c =  'Successful';
			//customerDocData.QTO_Line_Item_Matching_Comment__c =  'Failed';
			//customerDocData.Status__c = 'Exception-Matching(Lines)';
			//QTO_CustomerDocumentMaturityLevel.processMaturityLevel(new Set<Id>{customerDocData.Id }, QTO_Constants.STATUS_MATCHING_FAILED);
		}
		else{
			customerDocData.Status__c = QTO_Constants.CD_STATUS_LEGACY;
			//customerDocData.Status__c =  'Matched(Lines)';
			customerDocData.QTO_Line_Iteam_Association_Comment__c = 'Successful';
			customerDocData.QTO_Line_Item_Matching_Comment__c = 'Successful';
		}
		
		update customerDocData;		  
	}
	
	
	private static List<Customer_Document_Line_Items__c> findAssociatedCdLines(List<Id> allCusDocLineIds) {
		
		List<Customer_Document_Line_Items__c> cdLineList = 
			[
				Select Id,High_level_Product__c,High_level_Product_Description__c,Detailed_Product_Code__c,Detailed_Product_Description__c,Site__c,
				QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c,QTO_Product_Name__r.Name,Contract_Item_Number__c,Price_List_Item__c,
				Customer_Document__c, Status__c, Association_Comment__c, QTO_CDLI_Matching_Comment__c,QTO_Association__c , Customer_Document__r.Customer__c, 
				Quantity__c, QTO_CDLI_Matched_Quoted_Quantity__c, QTO_CDLI_Matched_Contracted_Quantity__c, Customer_Document__r.Status__c, QTO_Unit_Price__c, QTO_Unit_of_Measure__c,CurrencyIsoCode, 
				(select id, name, QTO_CDLIA_Match_Quoted_Comment__c,QTO_CDLIA_Matched_Quoted_Quantity__c, QTO_Proposal_Line_Item__c,QTO_Proposal_Line_Item__r.Apttus_Proposal__Proposal__c , QTO_CDLIA_Matching__c  from Customer_Document_Quote_Lines__r), 
				(select id, name, QTO_CDLIA_Match_Contracted_Comment__c,QTO_CDLIA_Matched_Contracted_Quantity__c,QTO_Agreement_Line_Item__c, QTO_Agreement_Line_Item__r.Apttus__AgreementId__c , QTO_CDLIA_Matching__c   from Customer_Document_Agreement_Line_Items__r) 
				from Customer_Document_Line_Items__c where id IN :allCusDocLineIds AND Association_Comment__c ='Association Successful'
			];
		return cdLineList;
	}
	
	
   
	public static void updateQuoteAndAgreementAcceptance(List<Customer_Document_Line_Items__c> cusDocLines) {
		
		System.debug('QTO_CDLineItemMatchingHelper >> updateQuoteAndAgreementAcceptance');
		//Quote and Respective Items
		Map<Apttus_Proposal__Proposal__c,List<Apttus_Proposal__Proposal_Line_Item__c>> quoteAndLinesMap = new Map<Apttus_Proposal__Proposal__c,List<Apttus_Proposal__Proposal_Line_Item__c>>();
		//Agreement and Respective Items
		Map<Apttus__APTS_Agreement__c,List<Apttus__AgreementLineItem__c>> agreementAndLinesMap = new Map<Apttus__APTS_Agreement__c,List<Apttus__AgreementLineItem__c>>();
		 
		
		List<Id> allCusDocLineIds = new List<Id>();
		
		//retrive the customer doc ids and Cdline-item ids
		for(Customer_Document_Line_Items__c cdLine : cusDocLines) {
			allCusDocLineIds.add(cdLine.Id);
		}
		
		//Query >>  Customer Document and Customer Document Line 
		List<Customer_Document_Line_Items__c> cdLineList = findAssociatedCdLines(allCusDocLineIds);
		System.debug('cdLineList : ' +cdLineList.size());
		
		Set<Id> quoteIds = new Set<Id>();
		Set<Id> aggrementIds = new Set<Id>();

		if(!cdLineList.isEmpty()) {
			for(Customer_Document_Line_Items__c cdline : cdLineList) {
				for(QTO_Customer_Document_Quote_Line__c lineItem :  cdline.Customer_Document_Quote_Lines__r) {
					quoteIds.add(lineItem.QTO_Proposal_Line_Item__r.Apttus_Proposal__Proposal__c);
				}
				
				for(QTO_Customer_Document_Agreement_Line__c lineItem :  cdline.Customer_Document_Agreement_Line_Items__r) {
					aggrementIds.add(lineItem.QTO_Agreement_Line_Item__r.Apttus__AgreementId__c);
				}
			}
		}
		
		System.debug('quoteIds>>> : '+ quoteIds);
		System.debug('aggrementIds>>> : '+ aggrementIds);
		
		List<Apttus_Proposal__Proposal__c> quotes = new List<Apttus_Proposal__Proposal__c>();
		List<Apttus__APTS_Agreement__c>  agreements = new List<Apttus__APTS_Agreement__c>();
		
		if(!quoteIds.isEmpty()) {
			 quotes   = findAllQuotesBySoldToParty(quoteIds);
		}
		
		if(!aggrementIds.isEmpty()) {
			agreements = findAllAgreementsBySoldToParty(aggrementIds);
		}
		
		
		
		if(!quotes.isEmpty()) {
			for(Apttus_Proposal__Proposal__c q : quotes) { 
				List<Apttus_Proposal__Proposal_Line_Item__c> quoteLines = new List<Apttus_Proposal__Proposal_Line_Item__c>();
				for(Apttus_Proposal__Proposal_Line_Item__c lineItem:  q.Apttus_Proposal__R00N70000001yUfBEAU__r) {
					quoteLines.add(lineItem);
				}
				quoteAndLinesMap.put(q,quoteLines);
			}
		}
		
		if(!agreements.isEmpty()) {
			for(Apttus__APTS_Agreement__c apAgree : agreements) {
				List<Apttus__AgreementLineItem__c> agreeLines = new List<Apttus__AgreementLineItem__c>();
				for(Apttus__AgreementLineItem__c lineItem :  apAgree.Apttus__AgreementLineItems__r) {
					agreeLines.add(lineItem);
				}
				agreementAndLinesMap.put(apAgree,agreeLines);
			}
		}
		
		Double alMatchedQty = 0.0;
		Double qlMatchedQty =0.0;
		List<Apttus_Proposal__Proposal__c> acceptedQuotes = new List<Apttus_Proposal__Proposal__c>();
		List<Apttus__APTS_Agreement__c> acceptedAgreements = new List<Apttus__APTS_Agreement__c>();
		
		if(quoteAndLinesMap.size()> 0) {
			System.debug('quoteAndLinesMap ...' +quoteAndLinesMap.size());
			for(Apttus_Proposal__Proposal__c quote : quoteAndLinesMap.keyset()) {
				if(quoteAndLinesMap.containsKey(quote)) {
					Integer qlCount = quoteAndLinesMap.get(quote).size();
					Integer qtyClosureCount=0;
					
					System.debug('qlCount ...' +qlCount);
					
					for(Apttus_Proposal__Proposal_Line_Item__c quoteLine : quoteAndLinesMap.get(quote)) { 
						if(quoteLine.Apttus_Proposal__Quantity__c == null)
							qlMatchedQty = 0.0;
						else 
							qlMatchedQty = quoteLine.Apttus_Proposal__Quantity__c; 

						if(quoteLine.Apttus_QPConfig__Quantity2__c != null) {
							Double qLAvailableQty = quoteLine.Apttus_QPConfig__Quantity2__c - qlMatchedQty;
							if(qLAvailableQty==0)
								qtyClosureCount = qtyClosureCount + 1;
						}
					}
					System.debug('qtyClosureCount ...' +qtyClosureCount);
					if(qlCount == qtyClosureCount && (qlCount <>0 && qtyClosureCount<>0)) {
						quote.Apttus_Proposal__Approval_Stage__c = 'Accepted';
						acceptedQuotes.add(quote);
					}
				}
			}
		}
		
		
		//Agreement check
		if(agreementAndLinesMap.size()>0 ) {
			System.debug('agreementAndLinesMap ...' +agreementAndLinesMap.size());
			for(Apttus__APTS_Agreement__c agreement : agreementAndLinesMap.keyset()) {
				if(agreementAndLinesMap.containsKey(agreement)) {
					Integer alCount = agreementAndLinesMap.get(agreement).size();
					Integer qtyClosureCount=0;
					System.debug('alCount ...' +alCount);
					for(Apttus__AgreementLineItem__c agreeLineItem : agreementAndLinesMap.get(agreement)) {
						if(agreeLineItem.QTO_ALI_Matched_Contracted_Quantity__c == null)
							alMatchedQty = 0.0;
						else
							alMatchedQty = agreeLineItem.QTO_ALI_Matched_Contracted_Quantity__c; 
						
						Double aLAvailablequantity = agreeLineItem.Apttus__Quantity__c - alMatchedQty;
						if(aLAvailablequantity == 0)
							qtyClosureCount = qtyClosureCount + 1;
					}
					System.debug('qtyClosureCount ...' +qtyClosureCount);
					if(alCount == qtyClosureCount && (alCount <>0 && qtyClosureCount<>0)) {
						agreement.Apttus__Status__c = 'Accepted';
						acceptedAgreements.add(agreement);
					}
				}
			}
		}
		
		system.debug('acceptedQuotes ...'+acceptedQuotes);
		system.debug('acceptedAgreements ...'+acceptedAgreements.size());
		
		
		if(acceptedAgreements.size()>0)
			update acceptedAgreements;
		if(acceptedQuotes.size()>0)
			update acceptedQuotes;
		
		
	
	}
	
	private static List<Apttus__APTS_Agreement__c> findAllAgreementsBySoldToParty(Set<Id> aggrementIds) {
		List<Apttus__APTS_Agreement__c> allAgreements = 
			[
				Select Id, Apttus__Status__c,
				(
					Select Id,Apttus__Quantity__c, QTO_ALI_Matched_Contracted_Quantity__c, QTO_AL_Available_Quantity__c  From Apttus__AgreementLineItems__r
				) 
				from Apttus__APTS_Agreement__c where Id IN: aggrementIds  AND Apttus__Status__c = 'Activated' AND Apttus__Status_Category__c ='In Effect'
			];
		return allAgreements;
		
	}
	
	private static List<Apttus_Proposal__Proposal__c> findAllQuotesBySoldToParty(Set<Id> quoteIds) {
		List<Apttus_Proposal__Proposal__c> allQuotes = 
			[
				Select Id, Quote_Type__c ,Apttus_QPConfig__PODate__c, Contract_Type_Name__c,Apttus_Proposal__Approval_Stage__c,Apttus_QPConfig__PONumber__c,Nokia_Customer_Document_ID__c,
				(
					Select Id,Apttus_Proposal__Quantity__c, Apttus_QPConfig__Quantity2__c, QTO_QLI_Matched_Risk_Quantity__c 
		from Apttus_Proposal__R00N70000001yUfBEAU__r where Apttus_QPConfig__LineType__c ='Product/Service' 
				) from Apttus_Proposal__Proposal__c WHERE  Id IN:quoteIds  AND Apttus_Proposal__Approval_Stage__c = 'Approved'
			];
		return allQuotes;		
	}
	//fetch Exception Metadata
	private static void fetchExceptionConfigMetaData() {
		for(QTO_Exception_Configuration__mdt metadata :[select id, MasterLabel, QualifiedApiName,QTO_Return_Code__c,QTO_Return_Description__c,QTO_Return_Type__c,QTO_Task_Subject__c,QTO_Tasks_Due_Date__c,QTO_Tasks_Priority__c,QTO_Tasks_Status__c,QTO_Investigating_Group__c,QTO_Log_Details__c from QTO_Exception_Configuration__mdt]){
			exceptionConfigMetaData.put(metadata.MasterLabel, metadata);
		}
	}
}