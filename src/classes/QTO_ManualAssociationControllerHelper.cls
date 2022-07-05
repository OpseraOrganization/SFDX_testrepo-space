/**
* @description	   : 
* @author			: Lovel Panchal
* @group			 : 
* @last modified on  : 12-04-2020
* @last modified by  : Raj Kamdar
* Modifications Log 
* Ver   Date		 Author		  Modification
* 1.0   11-23-2020   Lovel Panchal   Initial Version
**/
public with sharing class QTO_ManualAssociationControllerHelper {
	
	private static final String AGREEMENT = 'Agreement';
	private static final String QUOTE = 'Quote';
	private static final String CUSTOMERDOCUMENT = 'Customer_Document__c';
	//Associate Customer Document Line Items
	private static final String CUSTLINEITEMS = 'Customer_Document_Line_Items__c';
	//Customer Document Line Item Associate Quotes
	private static final String CDLIASSOQUOTE = 'QTO_Customer_Document_Quote_Line__c';
	//Customer Document Line Item Associate Agreements
	private static final String CDLIASSOAAGREEMENT = 'QTO_Customer_Document_Agreement_Line__c';
	
	
	// @ To get all Data based upon Content Document Id and Object Type which can be Quote or Agreement @
	public static dataWrapper getAllAssociationData(String inputObject,String CDId){
		List<sObject> listReturnData = new List<sObject>();
		List<sObject> objQueryResult = new List<sObject>(); 
		dataWrapper dw = new dataWrapper();
		if(inputObject.equals(null)) {
			throw new QTO_CustomException('Input Object cannot be null.');
		}
		else if(inputObject.equalsIgnoreCase(AGREEMENT)){
			objQueryResult = getAllAgreements(CDId);
			dw.selectedIdSet = new Set<Id>();			
			List<QTO_Customer_Document_Agreement__c> lstCDQ =  [Select Id,QTO_Agreement__c,QTO_Customer_Document__c
																from QTO_Customer_Document_Agreement__c where QTO_Customer_Document__c =:CDId];
			Set<Id> setCDA = new Set<Id>();
			for(QTO_Customer_Document_Agreement__c objCDQ:lstCDQ) {
				setCDA.add(objCDQ.QTO_Agreement__c);
			}
			
			dw.dataList = new List<sObject>();
			for(sObject obj :  objQueryResult){
				if(setCDA.contains((String)obj.get('Id'))){
					dw.selectedIdSet.add((Id) obj.get('Id'));					
				}
				dw.dataList.add(obj);
			}
		}
		else if(inputObject.equalsIgnoreCase(QUOTE)){
			dw.selectedIdSet = new Set<Id>(); 
			Set<Id> setCDA = new Set<Id>();
			
			Customer_Document__c objCD = 
				[
					SELECT Customer__c, Customer_Document_Id__c, Nokia_Legal_entity__c, Classification__c, Sub_Classification__c
					FROM Customer_Document__c WHERE Id = :CDId Limit 1
				];
			objQueryResult = getAllProposals(CDId);
			objQueryResult.addAll(getAllAccountProposals(CDId));
					   
			List<Customer_Document_Junction__c> lstCDQ =  [Select Id,Customer_Document__c,Customer_Document__r.Classification__c,Quote_Proposal__c from Customer_Document_Junction__c where Customer_Document__c =:CDId];
			for(Customer_Document_Junction__c objCDQ:lstCDQ) {
				setCDA.add(objCDQ.Quote_Proposal__c);
			}
			
			dw.dataList = new List<sObject>();
			Map<Id,sObject> objMap = new Map<Id,sObject>();
			for(sObject obj :  objQueryResult) {
				if(setCDA.contains((String)obj.get('Id'))) {
					dw.selectedIdSet.add((Id) obj.get('Id'));					
				}
				
				if(!objMap.containsKey((Id) obj.get('Id'))) {
					dw.dataList.add(obj);
					objMap.put((Id) obj.get('Id'), obj);
				}
			}  
			
			
			
			/*
			for(sObject obj :  objQueryResult){
				//if(obj.get('QTO_Association_Status__c') == 'Associated' && setCDA.contains((String)obj.get('Id'))){
				//@Harsha - DSI-2340 : removed '&& setCDA.contains((String)obj.get('Id'))' to make sure that all the quotes related to this customed document are shown.
				if(obj.get('QTO_Association_Status__c') == 'Associated' && setCDA.contains((String)obj.get('Id'))){
					dw.selectedIdSet.add((Id) obj.get('Id'));
					dw.dataList.add(obj);
				}else if (obj.get('QTO_Association_Status__c') == 'Associated' && !setCDA.contains((String)obj.get('Id'))){
					dw.dataList.add(obj);
				}else if(obj.get('QTO_Association_Status__c') != 'Associated'){
					dw.dataList.add(obj);
				}				
			}
			*/
		}
		else if(inputObject.equalsIgnoreCase(CUSTOMERDOCUMENT)){
			List<Customer_Document__c> allCds = getAllCds(CDId);
			dw.selectedIdSet = new Set<Id>();	
			
			List<CD_Association_to_CD__c> lstCDs = [
				SELECT Id, QTO_Nokia_Customer_Document_ID__c,
				Customer_Document__c
				FROM CD_Association_to_CD__c
				WHERE Customer_Document__c =:CDId
			];
			Set<Id> setCDA = new Set<Id>();
			for(CD_Association_to_CD__c objCD:lstCDs) {
				dw.selectedIdSet.add(objCD.QTO_Nokia_Customer_Document_ID__c);
				setCDA.add(objCD.QTO_Nokia_Customer_Document_ID__c);
			}
			dw.dataList = new List<sObject>();
			
			Customer_Document__c objCD = [
				SELECT Customer__c, Customer_Document_Id__c,
				Nokia_Legal_entity__c, Classification__c, Sub_Classification__c
				FROM Customer_Document__c
				WHERE Id = :CDId
				Limit 1];
			
			for (Customer_Document__c obj :allCds) {
				boolean isCustomerFound = false;
				boolean isNokiaLegalEntityFound = false;
				boolean isClassificationFound = false;
				boolean isSubClassificationFound = false;
				
				if(objCD.Customer__c == obj.Customer__c) {
					isCustomerFound = true;  
				}   
				if(objCD.Nokia_Legal_entity__c == obj.Nokia_Legal_entity__c) {
					isNokiaLegalEntityFound = true;  
				} 
				if(objCD.Classification__c == obj.Classification__c) {
					isClassificationFound = true;  
				} 
				if(objCD.Sub_Classification__c == obj.Sub_Classification__c) {
					isSubClassificationFound = true;  
				}	 
				
				if(isCustomerFound && isNokiaLegalEntityFound && isClassificationFound && isSubClassificationFound) {
					dw.dataList.add(obj);
				}
			} 
		}
		else if(inputObject.equalsIgnoreCase(CUSTLINEITEMS)) {
			dw.dataList = new List<sObject>();
			List<Customer_Document_Line_Items__c> cdLineItems = new List<Customer_Document_Line_Items__c>();
			for(Customer_Document_Line_Items__c line : [
				Select Id,QTO_Association__c,Association_Comment__c, Name,High_level_Product__c,High_level_Product_Description__c,
				Quantity__c,QTO_Unit_of_Measure__c,QTO_Unit_Price__c, Total_Value__c,QTO_Associated_Formula__c,
				QTO_CDLI_Association_Waiver_Comment__c,QTO_CDLI_Matching_Waiver_Comment__c, Customer_Document__r.Status__c,
				QTO_Association_Icon__c, QTO_Association_Icon_Class__c, QTO_CDLI_Waiver_Association__c,QTO_Matching_Icon__c, 
				QTO_Matching_Icon_Class__c, QTO_CDLI_Waiver_Matching__c
				from Customer_Document_Line_Items__c 
				where Customer_Document__c =:CDId  
				AND ( Association_Comment__c<>'Association Successful' 
					 	OR QTO_CDLI_Matching_Comment__c<> 'Matching Successful'
					) 
				AND (
					 QTO_CDLI_Association_Waiver_Comment__c <> 'Yes'
					 	AND QTO_CDLI_Matching_Waiver_Comment__c<> 'Yes'
					)
			]) {
				dw.dataList.add(line);
			}
		}
		else if(inputObject.equalsIgnoreCase(CDLIASSOQUOTE)){
			dw.dataList = new List<sObject>();
			dw.selectedIdSet = new Set<Id>();
			Set<Id> setCDA = new Set<Id>();
			String cdLineRecordId = CDId;
			System.debug('cdLineRecordId soldToPartyQuoteLines >>> '+cdLineRecordId);
			List<Id> lineIds= new List<Id>{cdLineRecordId};
			List<Customer_Document_Line_Items__c> cdLineList =  QTO_CDLineItemMatchingHelper.findAllCDLines(lineIds);
			
			/*
			String soldToParty = cdLineList[0].Customer_Document__r.Customer__c;
			String customerDocId = cdLineList[0].Customer_Document__c;
			List<String> headerReferences = QTOCustomerDocumentUtil.findCfasByAttributeType(customerDocId, 'PDF QUOTE REF');

			List<Apttus_Proposal__Proposal__c> proposalLines = QTOCustomerDocumentUtil.findAllAssociatedQuotes(customerDocId, headerReferences, soldToParty);
			Map<Id,Apttus_Proposal__Proposal_Line_Item__c> associateQuoteLines = new Map<Id,Apttus_Proposal__Proposal_Line_Item__c>();		
			if(!proposalLines.isEmpty()) {
				for(Apttus_Proposal__Proposal__c q : proposalLines){
					for(Apttus_Proposal__Proposal_Line_Item__c lineItem:  q.Apttus_Proposal__R00N70000001yUfBEAU__r) {
						associateQuoteLines.put(lineItem.Id, lineItem);
					}
				}
			}
			*/
			
			//Map<Id,Apttus_Proposal__Proposal_Line_Item__c>  soldToPartyQuoteLines = QTO_CdLineItemAssociationHelper.findAllQuotesBySoldToParty(cdLineList[0].Customer_Document__r.Customer__c);
			//System.debug('soldToPartyQuoteLines >>> '+soldToPartyQuoteLines.size());
			//objQueryResult = findAllAssociatedQuoteLines(cdLineList[0], soldToPartyQuoteLines);
			
			
			
			System.debug('============By Default============');
			Map<Id,Apttus_Proposal__Proposal_Line_Item__c> soldToPartyQuoteLines = QTO_CdLineItemAssociationHelper.findAllQuotesBySoldToParty(cdLineList[0].Customer_Document__r.Customer__c);			
			objQueryResult.addAll(findAllAssociatedQuoteLines(cdLineList[0], soldToPartyQuoteLines));
			objQueryResult.addAll(getQuoteLinesFromCDAssociatedQuotes(cdLineList.get(0)));
			objQueryResult.addAll(getAccountQuoteLines(cdLineList.get(0)));
			
			List<QTO_Customer_Document_Quote_Line__c> cdQLineAssocList =  
				[
					Select Id, QTO_Proposal_Line_Item__c, QTO_Customer_Document_Line_Items__c from QTO_Customer_Document_Quote_Line__c 
					where QTO_Customer_Document_Line_Items__c =:cdLineRecordId
				];
			
			for(QTO_Customer_Document_Quote_Line__c objCDQ : cdQLineAssocList) {
				setCDA.add(objCDQ.QTO_Proposal_Line_Item__c);
			}

			Map<Id,sObject> objMap = new Map<Id,sObject>();
			for(sObject obj :  objQueryResult) {
				if(setCDA.contains((String)obj.get('Id'))) {
					dw.selectedIdSet.add((Id) obj.get('Id'));					
				}
				
				if(!objMap.containsKey((Id) obj.get('Id'))) {
					dw.dataList.add(obj);
					objMap.put((Id) obj.get('Id'), obj);
				}
			} 
			
			/*
			for(sObject obj :  objQueryResult) {
				if(setCDA.contains((String)obj.get('Id'))) {
					dw.selectedIdSet.add((Id) obj.get('Id'));					
				}
				dw.dataList.add(obj);
			} 
			*/
		}
		else if((inputObject.equalsIgnoreCase(CDLIASSOAAGREEMENT))) {
			dw.dataList = new List<sObject>();
			dw.dataList = new List<sObject>();
			dw.selectedIdSet = new Set<Id>();
			Set<Id> setCDA = new Set<Id>();
			String cdLineRecordId = CDId;
			System.debug('cdLineRecordId  >>> '+cdLineRecordId);
			List<Id> lineIds= new List<Id>{cdLineRecordId};
			List<Customer_Document_Line_Items__c> cdLineList =  QTO_CDLineItemMatchingHelper.findAllCDLines(lineIds);
			
			//String soldToParty = cdLineList[0].Customer_Document__r.Customer__c;
			//String customerDocId = cdLineList[0].Customer_Document__c;
			//List<String> headerReferences = QTOCustomerDocumentUtil.findCfasByAttributeType(customerDocId, 'PDF CONTRACT REF');

			Map<Id,Apttus__AgreementLineItem__c>  soldToPartyLines = QTO_CdLineItemAssociationHelper.findAllAgreementsBySoldToParty(cdLineList[0].Customer_Document__r.Customer__c);
			System.debug('soldToParty AGRLines >>> '+soldToPartyLines.size());
			objQueryResult = findAllAssociatedAgreementLines(cdLineList[0], soldToPartyLines);
		   
			List<QTO_Customer_Document_Agreement_Line__c> cdQLineAssocList =  [Select Id, QTO_Agreement_Line_Item__c, QTO_Customer_Document_Line_Items__c from QTO_Customer_Document_Agreement_Line__c where QTO_Customer_Document_Line_Items__c =:cdLineRecordId];
			
			for(QTO_Customer_Document_Agreement_Line__c objCDQ : cdQLineAssocList) {
				setCDA.add(objCDQ.QTO_Agreement_Line_Item__c);
			}
			
			for(sObject obj :  objQueryResult) {
				if(setCDA.contains((String)obj.get('Id'))){
					dw.selectedIdSet.add((Id) obj.get('Id'));					
				}
				dw.dataList.add(obj);
			} 
		}
		else {
			throw new QTO_CustomException('Please select a valid Input Object.');
		}
		system.debug('dw.dataList--'+dw.dataList);
		return dw;
	}
	
	public static List<Customer_Document_Line_Items__c> findAllCDLines(String cusDocId) {
		
		List<Customer_Document_Line_Items__c> cdLineList = [Select Id,High_level_Product__c,High_level_Product_Description__c,Detailed_Product_Code__c,Detailed_Product_Description__c,Site__c,
															QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c,QTO_Product_Name__r.Name,Contract_Item_Number__c,Price_List_Item__c,
															Customer_Document__c, Status__c, Association_Comment__c, QTO_CDLI_Matching_Comment__c,
															QTO_Association__c , Customer_Document__r.Customer__c, Quantity__c, QTO_CDLI_Matched_Quoted_Quantity__c, 
															QTO_CDLI_Matched_Contracted_Quantity__c, QTO_CDLI_Association_Waiver_Comment__c, QTO_CDLI_Matching_Waiver_Comment__c, Customer_Document__r.Status__c 
						from Customer_Document_Line_Items__c where Customer_Document__c =:cusDocId];
		return cdLineList;
	}
	

	
	public static List<Apttus_Proposal__Proposal_Line_Item__c> findAllAssociatedQuoteLines(Customer_Document_Line_Items__c cusDocLine 
																					  , Map<Id,Apttus_Proposal__Proposal_Line_Item__c> soldToPartyApprovedQuoteLines) {
		System.debug('Quote Association from all SoldToParty lines>>>>');	 
		List<Apttus_Proposal__Proposal_Line_Item__c> associatedCdLineQuotes = new List<Apttus_Proposal__Proposal_Line_Item__c>();						
		for(Apttus_Proposal__Proposal_Line_Item__c quoLine : soldToPartyApprovedQuoteLines.values()) {
			if((cusDocLine.Contract_Item_Number__c == quoLine.External_Reference__c || cusDocLine.QTO_Product_Code__c == quoLine.Product_Code__c)
			   && cusDocLine.QTO_Product_Name__r.Name == quoLine.NokiaCPQ_Product_Name__c) {
				   associatedCdLineQuotes.add(quoLine);
			   }
		}
		return associatedCdLineQuotes;
	}
	
	// DSI-2340 get the quote lines of the quotes from cd header associations
	public static List<Apttus_Proposal__Proposal_Line_Item__c> getAccountQuoteLines(Customer_Document_Line_Items__c cusDocLine) {
		// do we need to find all cfas for the cd, then filter on pdf quote ref, and then find the quote line items under the quotes ??
		// or just get the line items from the already associated quotes -- currently implementing this one
		Set<Id> parentIds = new Set<Id>();
		for(Account Acco: [SELECT Id,name,Parentid, AccountNumber, Parent.Id, Parent.OwnerId, Parent.AccountNumber FROM Account WHERE Id=: cusDocLine.Customer_Document__r.Customer__c]) {
			parentIds.add(Acco.parentId);
		} 

		List<Apttus_Proposal__Proposal_Line_Item__c> quoteLinesFromCDAssociatedQuotes = new List<Apttus_Proposal__Proposal_Line_Item__c>();
		for(Apttus_Proposal__Proposal_Line_Item__c eachQuoteLine : [
			SELECT Id,Name,NokiaCPQ_Product_Name__c,Apttus_QPConfig__PriceListItemId__c, Apttus_Proposal__Proposal__c,
			Apttus_Proposal__Proposal__r.Name, Apttus_Proposal__Proposal__r.NokiaCPQ_Proposal_Id__c, Apttus_Proposal__Proposal__r.Id,
			Apttus_Proposal__Product__c,DS_Grouping_Name__c,Product_Code__c, Apttus_Proposal__Product__r.ProductCode,
			External_Reference__c, Apttus_Proposal__Quantity__c, Apttus_QPConfig__Quantity2__c, QTO_QLI_Matched_Risk_Quantity__c,
			Apttus_QPConfig__Uom__c, Apttus_QPConfig__NetUnitPrice__c, Apttus_Proposal__Proposal__r.CurrencyIsoCode, QTO_QL_Available_Quantity__c
			FROM Apttus_Proposal__Proposal_Line_Item__c 
			WHERE Apttus_Proposal__Proposal__r.Apttus_Proposal__Account__c IN : parentIds
			AND Apttus_Proposal__Proposal__r.Apttus_Proposal__Approval_Stage__c = 'Approved'
			AND Apttus_QPConfig__LineType__c = 'Product/Service'
		]) {
			if((cusDocLine.Contract_Item_Number__c == eachQuoteLine.External_Reference__c ||
				cusDocLine.QTO_Product_Code__c == eachQuoteLine.Product_Code__c) &&
			   cusDocLine.QTO_Product_Name__r.Name == eachQuoteLine.NokiaCPQ_Product_Name__c) {
				   quoteLinesFromCDAssociatedQuotes.add(eachQuoteLine);
			   }
		}
		return quoteLinesFromCDAssociatedQuotes;
	}
	
	// DSI-2340 get the quote lines of the quotes from cd header associations
	public static List<Apttus_Proposal__Proposal_Line_Item__c> getQuoteLinesFromCDAssociatedQuotes(Customer_Document_Line_Items__c cusDocLine) {
		// do we need to find all cfas for the cd, then filter on pdf quote ref, and then find the quote line items under the quotes ??
		// or just get the line items from the already associated quotes -- currently implementing this one
		Set<Id> cdAssociatedQuoteIds = new Set<Id>();
		for(Customer_Document_Junction__c eachQuoteAssociation : [
			SELECT Quote_Proposal__c FROM Customer_Document_Junction__c WHERE Customer_Document__c = :cusDocLine.Customer_Document__c]) {
			cdAssociatedQuoteIds.add(eachQuoteAssociation.Quote_Proposal__c);
		}
		List<Apttus_Proposal__Proposal_Line_Item__c> quoteLinesFromCDAssociatedQuotes = new List<Apttus_Proposal__Proposal_Line_Item__c>();
		for(Apttus_Proposal__Proposal_Line_Item__c eachQuoteLine : [
			SELECT Id,Name,NokiaCPQ_Product_Name__c,Apttus_QPConfig__PriceListItemId__c, Apttus_Proposal__Proposal__c,
			Apttus_Proposal__Proposal__r.Name, Apttus_Proposal__Proposal__r.NokiaCPQ_Proposal_Id__c, Apttus_Proposal__Proposal__r.Id,
			Apttus_Proposal__Product__c,DS_Grouping_Name__c,Product_Code__c, Apttus_Proposal__Product__r.ProductCode,
			External_Reference__c, Apttus_Proposal__Quantity__c, Apttus_QPConfig__Quantity2__c, QTO_QLI_Matched_Risk_Quantity__c,
			Apttus_QPConfig__Uom__c, Apttus_QPConfig__NetUnitPrice__c, Apttus_Proposal__Proposal__r.CurrencyIsoCode, QTO_QL_Available_Quantity__c
			FROM Apttus_Proposal__Proposal_Line_Item__c WHERE Apttus_Proposal__Proposal__c IN :cdAssociatedQuoteIds
			 AND Apttus_Proposal__Proposal__r.Apttus_Proposal__Approval_Stage__c = 'Approved'
			AND Apttus_QPConfig__LineType__c = 'Product/Service'
		]) {
			if((cusDocLine.Contract_Item_Number__c == eachQuoteLine.External_Reference__c ||
				cusDocLine.QTO_Product_Code__c == eachQuoteLine.Product_Code__c) &&
			   cusDocLine.QTO_Product_Name__r.Name == eachQuoteLine.NokiaCPQ_Product_Name__c) {
				   quoteLinesFromCDAssociatedQuotes.add(eachQuoteLine);
			   }
		}
		return quoteLinesFromCDAssociatedQuotes;
	}
	
	
	
	
	// DSI-2340 find all quote lines to associate
	public static DataWrapper findAllQuoteLinesToAssociate(String cdlineId, String option) {
		System.debug('cdlineId.....' + cdlineId);
		System.debug('option.....' + option);
		DataWrapper dw = new DataWrapper();
		dw.dataList = new List<SObject>();
		dw.selectedIdSet = new Set<Id>();
		Set<Id> setCDA = new Set<Id>();
		List<SObject> objQueryResult = new List<SObject>();
		// get cd line item field values
		List<Customer_Document_Line_Items__c> cdLineList =
					QTO_CDLineItemMatchingHelper.findAllCDLines(new List<Id>{Id.valueOf(cdlineId)});
		// get existing quote line to cd line associations
		/*for(QTO_Customer_Document_Quote_Line__c objCDQ : [
			Select Id, QTO_Proposal_Line_Item__c, QTO_Customer_Document_Line_Items__c
			from QTO_Customer_Document_Quote_Line__c 
			where QTO_Customer_Document_Line_Items__c IN :cdLineList
		]) {
			setCDA.add(objCDQ.QTO_Proposal_Line_Item__c);
		}*/
		
		// perform the filter based on the option
		switch on option {
			when 'sold_to_party' {							
				Map<Id,Apttus_Proposal__Proposal_Line_Item__c> soldToPartyQuoteLines =
					QTO_CdLineItemAssociationHelper.findAllQuotesBySoldToParty(cdLineList[0].Customer_Document__r.Customer__c);			
				objQueryResult.addAll(findAllAssociatedQuoteLines(cdLineList[0], soldToPartyQuoteLines));
			}
			when 'header_associations' {
				objQueryResult.addAll(getQuoteLinesFromCDAssociatedQuotes(cdLineList.get(0)));
			}
			when else {
				System.debug('====================== All=====================');
				Map<Id,Apttus_Proposal__Proposal_Line_Item__c> soldToPartyQuoteLines =
				QTO_CdLineItemAssociationHelper.findAllQuotesBySoldToParty(cdLineList[0].Customer_Document__r.Customer__c);			
				objQueryResult.addAll(findAllAssociatedQuoteLines(cdLineList[0], soldToPartyQuoteLines));
				objQueryResult.addAll(getQuoteLinesFromCDAssociatedQuotes(cdLineList.get(0)));
				objQueryResult.addAll(getAccountQuoteLines(cdLineList.get(0)));
			}
		}
		System.debug('objQueryResult . SIZE >>>>'+objQueryResult.size());
		List<QTO_Customer_Document_Quote_Line__c> cdQLineAssocList =  
			[
				Select Id, QTO_Proposal_Line_Item__c, QTO_Customer_Document_Line_Items__c from QTO_Customer_Document_Quote_Line__c 
				where QTO_Customer_Document_Line_Items__c =:cdlineId
			];
		
		for(QTO_Customer_Document_Quote_Line__c objCDQ : cdQLineAssocList) {
			setCDA.add(objCDQ.QTO_Proposal_Line_Item__c);
		}
		Map<Id,sObject> objMap = new Map<Id,sObject>();
		for(sObject obj :  objQueryResult) {
			if(setCDA.contains((String)obj.get('Id'))) {
				dw.selectedIdSet.add((Id) obj.get('Id'));					
			}
			
			if(!objMap.containsKey((Id) obj.get('Id'))) {
				dw.dataList.add(obj);
				objMap.put((Id) obj.get('Id'), obj);
			}
		}  
		System.debug('dw.dataList----'+dw.dataList.size());
		
		
		return dw;
	}
	
	
	public static List<Apttus__AgreementLineItem__c> findAllAssociatedAgreementLines(Customer_Document_Line_Items__c cusDocLine 
																					 , Map<Id,Apttus__AgreementLineItem__c > soldToPartyApprovedLines) {
		System.debug('Agreement Association from all SoldToParty lines>>>>');	 
		List<Apttus__AgreementLineItem__c> associatedCdLine = new List<Apttus__AgreementLineItem__c>();						
		for(Apttus__AgreementLineItem__c agreeLineItem : soldToPartyApprovedLines.values()) {
			if(agreeLineItem.CLM_CFE_Reference__c != null && agreeLineItem.Product_Code__c !=null) {
				if(cusDocLine.Contract_Item_Number__c == agreeLineItem.CLM_CFE_Reference__c
				   && cusDocLine.QTO_Product_Code__c == agreeLineItem.Product_Code__c
				   && cusDocLine.QTO_Product_Name__c == agreeLineItem.Apttus__ProductId__c) {
					   associatedCdLine.add(agreeLineItem);
				   }
			}
			else {
				if(cusDocLine.Contract_Item_Number__c == agreeLineItem.CLM_CFE_Reference__c
				   && cusDocLine.QTO_Product_Name__c == agreeLineItem.Apttus__ProductId__c) {
					   associatedCdLine.add(agreeLineItem);
				   }
			}   
		}
		return associatedCdLine;
	}
	
	
	
	// Main Method to save data passed from LWC component
	public static void saveAssociationData(String saveData,Id CDId, String ObjName) {
		System.debug('saveAssociationData....'+ ObjName +' : ID ...'+CDId);
		try {
			if(objName.equalsIgnoreCase(QUOTE)){
				List<Apttus_Proposal__Proposal__c> lstQuote = (List<Apttus_Proposal__Proposal__c>)System.JSON.deserialize(saveData, List<Apttus_Proposal__Proposal__c>.class);
				saveQuoteAssociationData(lstQuote,CDId);
			}
			else if(objName.equalsIgnoreCase(AGREEMENT)){
				List<Apttus__APTS_Agreement__c> lstQuote = (List<Apttus__APTS_Agreement__c>)System.JSON.deserialize(saveData, List<Apttus__APTS_Agreement__c>.class);
				saveAgreementAssociationData(lstQuote,CDId);
			}
			else if(objName.equalsIgnoreCase(CustomerDocument)){
				//List<Customer_Document__c> lstQuote = (List<Customer_Document__c>)System.JSON.deserialize(saveData, List<Customer_Document__c>.class);
				saveCustomerDocumentAssociationData(saveData, CDId);
			}
			else if(objName.equalsIgnoreCase(CDLIASSOQUOTE)){
				saveCDLineQuoteAssociationData(saveData, CDId);
			}
			else if(objName.equalsIgnoreCase(CDLIASSOAAGREEMENT)){
				saveCDLineAgreementAssociationData(saveData, CDId);
			}
			else if(objName.equalsIgnoreCase(CUSTLINEITEMS)){
				saveCDLineWaiveringData(saveData, CDId);
			}
		} catch(QTO_CustomException ce) {
			throw new QTO_CustomException('Exception while saving association Data' + ce.getMessage());
		}
	}
	
	/* Waiver Info */
	public static void saveCDLineWaiveringData(String saveData, Id recordId) {
		try {
			List<Customer_Document_Line_Items__c> cdLinesToUpdate = new List<Customer_Document_Line_Items__c>();
			for(Customer_Document_Line_Items__c eachCdLine :
				(List<Customer_Document_Line_Items__c>) JSON.deserialize(saveData, List<Customer_Document_Line_Items__c>.class)) {
				Customer_Document_Line_Items__c cdLineToUpdate = new Customer_Document_Line_Items__c();
				cdLineToUpdate.Id = eachCdLine.Id;
				if (eachCDLine.get('QTO_CDLI_Waiver_Association__c') <> null) {
					cdLineToUpdate.QTO_CDLI_Association_Waiver_Comment__c = eachCdLine.QTO_CDLI_Waiver_Association__c ? 'Yes' : 'No';
					if(eachCdLine.QTO_CDLI_Waiver_Association__c) {
						cdLineToUpdate.Association_Comment__c = 'Association Waiver';
						cdLineToUpdate.QTO_CDLI_Matching_Waiver_Comment__c ='Yes';
						cdLineToUpdate.QTO_CDLI_Matching_Comment__c = ' Matching Waiver';
					}
				}
				if (eachCDLine.get('QTO_CDLI_Waiver_Matching__c') <> null) {
					cdLineToUpdate.QTO_CDLI_Matching_Waiver_Comment__c = eachCdLine.QTO_CDLI_Waiver_Matching__c ? 'Yes' : 'No';
					if(eachCdLine.QTO_CDLI_Waiver_Matching__c) {
						cdLineToUpdate.QTO_CDLI_Matching_Comment__c = ' Matching Waiver';
					}
				}
				cdLinesToUpdate.add(cdLineToUpdate);
			}
			update cdLinesToUpdate;

			List<Customer_Document_Line_Items__c> lines = QTO_ManualAssociationControllerHelper.findAllCDLines(recordId);
			QTO_CDLineItemMatchingHelper.updateCDocStatus(lines);

		} catch(Exception exc) {
			throw new AuraHandledException(exc.getMessage());
		}
	}

	/**Get customer document*/
	private static List<Customer_Document_Line_Items__c> findCustomerDocumentLineItemById(Id recordId) {
		
		List<Customer_Document_Line_Items__c> cdLineList = 
					[
						Select Id, Quantity__c, QTO_CDLI_Matched_Quoted_Quantity__c, 
						QTO_CDLI_Matched_Contracted_Quantity__c,Status__c, Customer_Document__r.Sub_Classification__c from Customer_Document_Line_Items__c 
						where Id=: recordId AND Status__c <> 'Matched(Lines)'
					];
		return cdLineList;
	}

	//Logic to Save CDLine QuoteLine Junction Object
	public static void saveCDLineQuoteAssociationData(String saveData, Id recordId) {
		system.debug('saveData-->'+saveData);
		List<Customer_Document_Line_Items__c> cdLineList = findCustomerDocumentLineItemById(recordId);
		System.debug('cdLineList-->'+cdLineList.size());
		if(!cdLineList.isEmpty()) {
			Map<Id,QTO_Customer_Document_Quote_Line__c> cdQlAssoMap = new Map<Id,QTO_Customer_Document_Quote_Line__c>();
			List<QTO_Customer_Document_Quote_Line__c> newQlines = new List<QTO_Customer_Document_Quote_Line__c>();
			
			List<Apttus_Proposal__Proposal_Line_Item__c> deserializedQuoteList =
				(List<Apttus_Proposal__Proposal_Line_Item__c>)System.JSON.deserialize(saveData, List<Apttus_Proposal__Proposal_Line_Item__c>.class) ;
			
			List<QTO_Customer_Document_Quote_Line__c> associatedQuoteLines =  
				[	Select Id, QTO_Proposal_Line_Item__c, QTO_Customer_Document_Line_Items__c, QTO_CDLIA_Matched_Quoted_Quantity__c 
				 from QTO_Customer_Document_Quote_Line__c 
				 where QTO_Customer_Document_Line_Items__c =:recordId
				];
			
			List<QTO_Customer_Document_Agreement_Line__c> associatedAgreementLines =  
				[
					Select Id, QTO_Agreement_Line_Item__c, QTO_Customer_Document_Line_Items__c , QTO_CDLIA_Matched_Contracted_Quantity__c
					from QTO_Customer_Document_Agreement_Line__c where QTO_Customer_Document_Line_Items__c =:recordId
				];
			
			for(QTO_Customer_Document_Quote_Line__c qlObj : associatedQuoteLines) {
				cdQlAssoMap.put(qlObj.QTO_Proposal_Line_Item__c, qlObj);
			}
			Set<Id> removedQIds = cdQlAssoMap.keyset();
			Set<Id> newQIds =  new set<Id>();
			
			System.debug('cdQlAssoMap>>>>>> ' + cdQlAssoMap.size());
			
			for(Apttus_Proposal__Proposal_Line_Item__c obj : deserializedQuoteList) {
				if(cdQlAssoMap.get(obj.Id) == null) {
					QTO_Customer_Document_Quote_Line__c associationToLine = new QTO_Customer_Document_Quote_Line__c();
					associationToLine.QTO_Customer_Document_Line_Items__c = recordId;
					associationToLine.QTO_Proposal_Line_Item__c = obj.Id;
					associationToLine.QTO_CDLIA_Matched_Quoted_Quantity__c = 0;
					newQlines.add(associationToLine);
				}
				newQIds.add(obj.id);
			}
			
			
			removedQIds.removeall(newQIds);
			List<QTO_Customer_Document_Quote_Line__c> lst_QL_Del = new List<QTO_Customer_Document_Quote_Line__c>();
			for(Id Qt_Id :removedQIds){
				QTO_Customer_Document_Quote_Line__c delObj = new QTO_Customer_Document_Quote_Line__c();
				delObj.Id = cdQlAssoMap.get(Qt_Id).Id;  
				lst_QL_Del.add(delObj);
			}
			
			if(lst_QL_Del.size() >0 ) {
				reviseQuoteLineQuantity(removedQIds, recordId, cdQlAssoMap);
				Delete lst_QL_Del;
			}
			if((associatedAgreementLines.isEmpty() && associatedQuoteLines.isEmpty()) && newQlines.size()>0) {
				Customer_Document_Line_Items__c cusDocLine = cdLineList[0];
				cusDocLine.Status__c='Manually-Associated(Lines)';
				cusDocLine.Association_Comment__c ='Association Successful';
				cusDocLine.QTO_Association__c ='Association Successful';
				update cusDocLine;
			} 
			if(newQlines.size()>0) {
				Database.insert(newQlines,false);  
			}
		}
	}  
	@testVisible
	private static Map<Id,Apttus_Proposal__Proposal_Line_Item__c> findQuoteLineItemById(Set<Id> removedQIds) {
		Map<Id,Apttus_Proposal__Proposal_Line_Item__c> quoteLines = new Map<Id,Apttus_Proposal__Proposal_Line_Item__c>
			([
				Select Id,Name,NokiaCPQ_Product_Name__c,Apttus_QPConfig__PriceListItemId__c,Apttus_Proposal__Proposal__c,
				Apttus_Proposal__Proposal__r.Name, Apttus_Proposal__Proposal__r.NokiaCPQ_Proposal_Id__c,
				Apttus_Proposal__Proposal__r.Id, Apttus_Proposal__Product__c,DS_Grouping_Name__c,Product_Code__c,
				Apttus_Proposal__Product__r.ProductCode,External_Reference__c, Apttus_Proposal__Quantity__c, 	
				Apttus_QPConfig__Quantity2__c, QTO_QLI_Matched_Risk_Quantity__c 
				from Apttus_Proposal__Proposal_Line_Item__c where Id IN: removedQIds 
				AND Apttus_Proposal__Proposal__r.Apttus_Proposal__Approval_Stage__c = 'Approved'
			]);
		return quoteLines;
	}
	
	@TestVisible
	private static void reviseQuoteLineQuantity(Set<Id> removedQIds , Id cdLineItemId, Map<Id,QTO_Customer_Document_Quote_Line__c> cdQlAssoMap) {
		System.debug('Revise Quote Quantity..');
		Customer_Document_Line_Items__c cdLine;
		List<Apttus_Proposal__Proposal_Line_Item__c> updatedQLList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
		List<Customer_Document_Line_Items__c> cdLineList = findCustomerDocumentLineItemById(cdLineItemId);
		Map<Id,Apttus_Proposal__Proposal_Line_Item__c> quoteLineMap = findQuoteLineItemById(removedQIds);
		if(!cdLineList.isEmpty()) {
			cdLine = cdLineList[0];
			Double cdQuoteQty = cdLine.QTO_CDLI_Matched_Quoted_Quantity__c ;
			for(Id Qt_Id :removedQIds) {
				
				QTO_Customer_Document_Quote_Line__c obj = cdQlAssoMap.get(Qt_Id);
				Apttus_Proposal__Proposal_Line_Item__c qline =  quoteLineMap.get(Qt_Id);
				
				Double cdQlMatchedQty = cdQlAssoMap.get(Qt_Id).QTO_CDLIA_Matched_Quoted_Quantity__c;
				Double qlMatchedQty = qline.Apttus_Proposal__Quantity__c;
				Double qlMatchedRiskQty = qline.QTO_QLI_Matched_Risk_Quantity__c;
				
				if(qlMatchedRiskQty == null) qlMatchedRiskQty = 0;
				if(qlMatchedQty == null)  qlMatchedQty = 0;
				if(cdQlMatchedQty == null) cdQlMatchedQty = 0;
				
				qline.Apttus_Proposal__Quantity__c = (qlMatchedQty - cdQlMatchedQty);
				if(cdLine.Customer_Document__r.Sub_Classification__c == QTO_Constants.RISKORDER)
					qline.QTO_QLI_Matched_Risk_Quantity__c = (qlMatchedRiskQty - cdQuoteQty); 
				cdQuoteQty = (cdQuoteQty - cdQlMatchedQty );
				
				updatedQLList.add(qline);
			}
			cdLine.QTO_CDLI_Matched_Quoted_Quantity__c = cdQuoteQty ;
			update cdLine;
			update updatedQLList;
		}
	}

	
	//Logic to Save CDLine AgreementLine Junction Object
	public static void saveCDLineAgreementAssociationData(String saveData, Id recordId) {
		
		List<Customer_Document_Line_Items__c> cdLineList = findCustomerDocumentLineItemById(recordId);
		if(!cdLineList.isEmpty()) {
			
			List<Apttus__AgreementLineItem__c> deserializedAgrList =
				(List<Apttus__AgreementLineItem__c>)System.JSON.deserialize(saveData, List<Apttus__AgreementLineItem__c>.class) ;

			List<QTO_Customer_Document_Agreement_Line__c> lstCD = new List<QTO_Customer_Document_Agreement_Line__c>();
			Map<Id,QTO_Customer_Document_Agreement_Line__c> cdAlAssoMap = new Map<Id,QTO_Customer_Document_Agreement_Line__c>();
			
			List<QTO_Customer_Document_Quote_Line__c> associatedQuoteLines =  
				[	Select Id, QTO_Proposal_Line_Item__c, QTO_Customer_Document_Line_Items__c, QTO_CDLIA_Matched_Quoted_Quantity__c 
				 from QTO_Customer_Document_Quote_Line__c 
				 where QTO_Customer_Document_Line_Items__c =:recordId
				];
			List<QTO_Customer_Document_Agreement_Line__c> lstCDQ =  
				[
					Select Id, QTO_Agreement_Line_Item__c, QTO_Customer_Document_Line_Items__c , QTO_CDLIA_Matched_Contracted_Quantity__c
					from QTO_Customer_Document_Agreement_Line__c where QTO_Customer_Document_Line_Items__c =:recordId
				];	
			 
			for(QTO_Customer_Document_Agreement_Line__c objCDQ : lstCDQ) {
				cdAlAssoMap.put(objCDQ.QTO_Agreement_Line_Item__c, objCDQ);
			}
			
			Set<Id> removedQIds = cdAlAssoMap.keyset();
			Set<Id> newQIds =  new set<Id>();
			
			for(Apttus__AgreementLineItem__c obj : deserializedAgrList) {
				if(cdAlAssoMap.get(obj.Id) == null) {
					QTO_Customer_Document_Agreement_Line__c associationToLine = new QTO_Customer_Document_Agreement_Line__c();
					associationToLine.QTO_Customer_Document_Line_Items__c = recordId;
					associationToLine.QTO_Agreement_Line_Item__c = obj.Id;
					associationToLine.QTO_CDLIA_Matched_Contracted_Quantity__c = 0;
					lstCD.add(associationToLine);
				}
				newQIds.add(obj.id);
			}
			
			removedQIds.removeall(newQIds);
			
			List<QTO_Customer_Document_Agreement_Line__c> lst_AL_Del = new List<QTO_Customer_Document_Agreement_Line__c>();
			for(Id Qt_Id :removedQIds){
				QTO_Customer_Document_Agreement_Line__c delObj = new QTO_Customer_Document_Agreement_Line__c();
				delObj.Id = cdAlAssoMap.get(Qt_Id).Id;   
				lst_AL_Del.add(delObj);
			}
			
			if(lst_AL_Del.size() >0 ) {
				reviseAgreementLineQuantity(removedQIds, recordId, cdAlAssoMap);
				Delete lst_AL_Del;
			}
			if((associatedQuoteLines.isEmpty() && lstCDQ.isEmpty()) && lstCD.size()>0) {
				Customer_Document_Line_Items__c cusDocLine = cdLineList[0];
				cusDocLine.Status__c='Manually-Associated(Lines)';
				cusDocLine.Association_Comment__c ='Association Successful';
				cusDocLine.QTO_Association__c ='Association Successful';
				update cusDocLine;
			} 
			if(lstCD.size()>0) {
				Database.insert(lstCD,false);  
			}
		}
	}  
	@testVisible
	private static Map<Id,Apttus__AgreementLineItem__c> findAgreementLineItemById(Set<Id> removedIds) {
		Map<Id,Apttus__AgreementLineItem__c> agrLines = new Map<Id,Apttus__AgreementLineItem__c>
			([
				Select Id,Apttus__AgreementId__c,Name,Apttus__Description__c,CLM_CFE_Reference__c,
				Apttus__ProductId__r.Name,Product_Code__c,Apttus__NetPrice__c,Apttus__Quantity__c,Apttus__ExtendedPrice__c,
				Apttus__AgreementId__r.Apttus__Status__c, Apttus__AgreementId__r.Apttus__Status_Category__c, QTO_ALI_Matched_Contracted_Quantity__c
				From Apttus__AgreementLineItem__c  where Id IN: removedIds  
				and Apttus__AgreementId__r.Apttus__Status__c='Activated' 
				and Apttus__AgreementId__r.Apttus__Status_Category__c= 'In Effect' 
			]);
		return agrLines;
	}
	
	@TestVisible
	private static void reviseAgreementLineQuantity(Set<Id> removedAlIds , Id cdLineItemId, Map<Id,QTO_Customer_Document_Agreement_Line__c> cdAssoMap) {
		Customer_Document_Line_Items__c cdLine;
		List<Apttus__AgreementLineItem__c> updatedAlList = new List<Apttus__AgreementLineItem__c>();
		
		List<Customer_Document_Line_Items__c> cdLineList = findCustomerDocumentLineItemById(cdLineItemId);
		Map<Id,Apttus__AgreementLineItem__c> agreementLineMap = findAgreementLineItemById(removedAlIds);
		if(!cdLineList.isEmpty()) {
			cdLine = cdLineList[0];
			Double cdMatchedQty = cdLine.QTO_CDLI_Matched_Contracted_Quantity__c ;
			for(Id Qt_Id :removedAlIds) {
				QTO_Customer_Document_Agreement_Line__c obj = cdAssoMap.get(Qt_Id);
				Double cdAlmatchedQty = cdAssoMap.get(Qt_Id).QTO_CDLIA_Matched_Contracted_Quantity__c;
				Apttus__AgreementLineItem__c aline =  agreementLineMap.get(Qt_Id);
				Double qlMatchedQty = aline.QTO_ALI_Matched_Contracted_Quantity__c;
				
				if(cdAlmatchedQty != null && qlMatchedQty !=null) {
					aline.QTO_ALI_Matched_Contracted_Quantity__c = (qlMatchedQty - cdAlmatchedQty);
					cdMatchedQty = (cdMatchedQty- cdAlmatchedQty);
				}
				updatedAlList.add(aline);
			}
			cdLine.QTO_CDLI_Matched_Contracted_Quantity__c = cdMatchedQty ;
			update cdLine;
			update updatedAlList;
		}
	}
	
	public static void saveCustomerDocumentAssociationData(String saveData, Id CDId) {
		system.debug('saveData-->'+saveData);
		
		List<Customer_Document__c> cdDataList =
			(List<Customer_Document__c>)System.JSON.deserialize(saveData, List<Customer_Document__c>.class) ;
		Map<Id, CD_Association_to_CD__c> selectedCdCdIds = new Map<Id, CD_Association_to_CD__c>();
		
		List<CD_Association_to_CD__c> lstCD = [
			SELECT QTO_Nokia_Customer_Document_ID__c
			FROM CD_Association_to_CD__c
			WHERE Customer_Document__c =:CDId];
		
		for (CD_Association_to_CD__c cdRec: lstCD) {
			selectedCdCdIds.put(cdRec.QTO_Nokia_Customer_Document_ID__c, cdRec);
		}
		
		List<CD_Association_to_CD__c> customerAssociationList = new List<CD_Association_to_CD__c>();
		for(Customer_Document__c customerDocument : cdDataList) {
			CD_Association_to_CD__c cdAssociation = new CD_Association_to_CD__c();
			cdAssociation.QTO_Nokia_Customer_Document_ID__c = customerDocument.Id;
			cdAssociation.QTO_Customer_Document_Date__c = customerDocument.Customer_Document_Date__c;
			cdAssociation.QTO_Manual__c = true;
			cdAssociation.QTO_Nature__c = customerDocument.QTO_Nature__c;
			cdAssociation.QTO_Customer_Document_ID_Version__c =
				customerDocument.Version_Nr__c != null ? Decimal.valueOf(customerDocument.Version_Nr__c) : null;
			cdAssociation.Customer_Document__c = CDId;
			if (selectedCdCdIds.containsKey(customerDocument.Id)) {
				cdAssociation.Id = selectedCdCdIds.get(customerDocument.Id).Id;
				selectedCdCdIds.remove(customerDocument.Id);
			}
			customerAssociationList.add(cdAssociation);
		}
		
		upsert customerAssociationList;
		
		if (!selectedCdCdIds.isEmpty()) {
			Database.delete(selectedCdCdIds.values());
		}
	}
	
	//Logic to Save Quote Junction Object
	public static void saveQuoteAssociationData(list<Apttus_Proposal__Proposal__c> saveData,Id CDId){
		List<Customer_Document_Junction__c> lstCD = new List<Customer_Document_Junction__c>();
		List<Customer_Document_Junction__c> lstCDQ =  [Select Id,Customer_Document__c,Customer_Document__r.Customer_Document_Date__c,Customer_Document__r.Name,Customer_Document__r.Customer_Document_ID__c,Quote_Proposal__c from Customer_Document_Junction__c where Customer_Document__c =:CDId];
		Customer_Document__c obj_CD = [Select Id,Customer_Document_Date__c,Name,Customer_Document_ID__c from Customer_Document__c where Id =:CDId limit 1];
		Map<Id,Customer_Document_Junction__c> mapCDA = new Map<Id,Customer_Document_Junction__c>();
		for(Customer_Document_Junction__c objCDQ:lstCDQ) {
			mapCDA.put(objCDQ.Quote_Proposal__c,objCDQ);
		}
		system.debug('mapCDA-->'+mapCDA);
		Set<Id> setQId = mapCDA.keyset();
		Set<Id> setNewQId =  new set<Id>();
		for(Apttus_Proposal__Proposal__c obj:saveData){
			if(mapCDA.get(obj.Id) == null){
				Customer_Document_Junction__c objCD = new Customer_Document_Junction__c();
				objCD.Quote_Proposal__c = obj.Id;
				objCD.Customer_Document__c = CDId;   
				lstCD.add(objCD);
				obj.QTO_Association_Status__c = 'Associated';
				obj.Nokia_Customer_Document_ID__c = obj_CD.Id;
				obj.Apttus_QPConfig__PODate__c =  obj_CD.Customer_Document_Date__c;
				obj.Apttus_QPConfig__PONumber__c =  obj_CD.Customer_Document_ID__c;
			}
			setNewQId.add(obj.id);
		}
		System.debug('setNewQId-->'+setNewQId);
		setQId.removeall(setNewQId);
		System.debug('setQId-->'+setQId);
		List<Customer_Document_Junction__c> lst_CD_Del = new List<Customer_Document_Junction__c>();
		List<Apttus_Proposal__Proposal__c> lstDelQuote = new List<Apttus_Proposal__Proposal__c>();
		for(Id Qt_Id :setQId){
			Customer_Document_Junction__c delObj = new Customer_Document_Junction__c();
			delObj.Id = mapCDA.get(Qt_Id).Id;			
			lst_CD_Del.add(delObj);
			Apttus_Proposal__Proposal__c obj = new Apttus_Proposal__Proposal__c();
			obj.QTO_Association_Status__c = 'Not Associated';
			obj.Nokia_Customer_Document_ID__c = null;
			obj.Apttus_QPConfig__PODate__c = null;
			obj.Apttus_QPConfig__PONumber__c  = '';
			obj.Id = Qt_Id;
			lstDelQuote.add(obj);
		}
		system.debug('lst_CD_Del-->'+lst_CD_Del);
		system.debug('lstDelQuote-->'+lstDelQuote);
		Delete lst_CD_Del;
		Update lstDelQuote;
		Database.update(saveData);
		system.debug('lstCD-->'+lstCD);
		//Database.insert(lstCD,false);
		//@Harsha - DSI-2340 : commented above line as the update to Quotes, is creating duplicate records from Quote trigger
		// ASYNC CALL
		callQLIAssociation(saveData, obj_CD);
	}
	// Logic to Save Agreement junction Object
	public static void saveAgreementAssociationData(list<Apttus__APTS_Agreement__c> saveData,Id CDId){
		system.debug('saveData-->'+saveData);
		List<QTO_Customer_Document_Agreement__c> lstCD = new List<QTO_Customer_Document_Agreement__c>();
		List<QTO_Customer_Document_Agreement__c> lstCDQ =  [Select Id,QTO_Agreement__c,QTO_Customer_Document__c from QTO_Customer_Document_Agreement__c where QTO_Customer_Document__c =:CDId];
		Customer_Document__c obj_CD = [Select Id,Customer_Document_Date__c,Name,Customer_Document_ID__c, QTO_Error_Message__c  from Customer_Document__c where Id =:CDId limit 1];
		Map<Id,QTO_Customer_Document_Agreement__c> mapCDA = new Map<Id,QTO_Customer_Document_Agreement__c>();
		for(QTO_Customer_Document_Agreement__c objCDQ:lstCDQ) {
			mapCDA.put(objCDQ.QTO_Agreement__c,objCDQ);
		}
		system.debug('mapCDA-->'+mapCDA);
		Set<Id> setQId = mapCDA.keyset();
		Set<Id> setNewQId =  new set<Id>();
		Boolean hasValue = false;
		for(Apttus__APTS_Agreement__c obj:saveData){
			if(mapCDA.get(obj.Id) == null){
				QTO_Customer_Document_Agreement__c objCD = new QTO_Customer_Document_Agreement__c();
				objCD.QTO_Agreement__c = obj.Id;
				objCD.QTO_Customer_Document__c = CDId;
				objCD.QTO_Source__c = 'Manual';   
				lstCD.add(objCD);
				
				hasValue = true;
			}
			setNewQId.add(obj.id);
		}
		
		if (hasValue && (obj_CD.QTO_Error_Message__c != null && obj_CD.QTO_Error_Message__c.contains('No agreement association'))) {
			//obj_CD.QTO_Error_Message__c = '';
		}
		//update obj_CD;
		system.debug('setNewQId-->'+setNewQId);
		setQId.removeall(setNewQId);
		system.debug('setQId-->'+setQId);
		List<QTO_Customer_Document_Agreement__c> lst_CD_Del = new List<QTO_Customer_Document_Agreement__c>();
		for(Id Qt_Id :setQId){
			QTO_Customer_Document_Agreement__c delObj = new QTO_Customer_Document_Agreement__c();
			delObj.Id = mapCDA.get(Qt_Id).Id;			
			lst_CD_Del.add(delObj);
		}
		system.debug('lst_CD_Del-->'+lst_CD_Del);
		Delete lst_CD_Del;
		system.debug('lstCD-->'+lstCD);
		Database.insert(lstCD,false);   
		// ASYNC CALL
		
		// 
	}
	// Call Async Call to Associate Line Items to Customer Doc Line Items
	public static void callQLIAssociation(List<Apttus_Proposal__Proposal__c> records, Customer_Document__c cdObj){
		cdObj.QTO_InAssociationProcess__c = true;
		update cdObj;
		ID jobID = System.enqueueJob(new QTO_ManualCDItemToQuoteItemQueue(records, cdObj));
	}
	// To check if the Queue process is completed
	public static boolean getStatus(String CDId){
		Customer_Document__c objCD = [Select Customer__c,QTO_InAssociationProcess__c from Customer_Document__c where Id = :CDId Limit 1];
		return objCD.QTO_InAssociationProcess__c;
	}
	private static List<Apttus_Proposal__Proposal__c> getAllProposals(String CDId){
		List<Apttus_Proposal__Proposal__c> listProposals = new List<Apttus_Proposal__Proposal__c>();
		String query = prepareSelectQuery(QUOTE,CDId);
		try{
			Customer_Document__c objCD = [Select Customer__c from Customer_Document__c where Id = :CDId Limit 1];
			//List<Apttus_Proposal__Proposal__c> lstQuote = [Select Id from Apttus_Proposal__Proposal__c where Sold_To_Party__c =: objCD.Customer__c and Nokia_Customer_Document_ID__c  =:CDId and QTO_Association_Status__c = 'Associated' and  Nokia_Customer_Document_ID__r.Classification__c ='Risk Order' AND Apttus_Proposal__Approval_Stage__c = 'Approved'];
			//DSI-2335
			List<Apttus_Proposal__Proposal__c> lstQuote = [Select Id from Apttus_Proposal__Proposal__c where Sold_To_Party__c =: objCD.Customer__c AND Apttus_Proposal__Approval_Stage__c = 'Approved'];
			//List<QTO_Customer_Document_Association_Quote__c> lstCDAQ = [Select Id,QTO_Customer_Document__r.Classification__c,QTO_Quote_Proposal__c, QTO_Quote_Proposal__r.QTO_Association_Status__c, QTO_Quote_Proposal__r.Sold_To_Party__c from QTO_Customer_Document_Association_Quote__c where QTO_Quote_Proposal__r.Sold_To_Party__c =: objCD.Customer__c AND AND QTO_Association_Status__c = ];
			Set<Id> qId = new Set<Id>();
			for(Apttus_Proposal__Proposal__c objQuote :lstQuote){
				qId.add(objQuote.Id); 
			}
			system.debug('query--->'+query);
			listProposals = Database.query(query);
			//listProposals = [select id,name,Quote_Status__c,Nokia_Customer_Document_ID__c from Apttus_Proposal__Proposal__c order by createddate desc limit 50000];	
		}
		catch(Exception e){
			system.debug('Exception --> '+e);
			throw new QTO_CustomException(e);
			//throw new QTO_CustomException('Error occurred while fetching proposals.');
			//throw new QTO_CustomException('Error occurred while fetching proposals.');
		}
		return listProposals;
	}

	private static List<Apttus_Proposal__Proposal__c> getAllAccountProposals(String CDId){
		List<Apttus_Proposal__Proposal__c> listProposals = new List<Apttus_Proposal__Proposal__c>();
		String query = prepareSelectQuery(QUOTE,CDId);
		try{
			Customer_Document__c objCD = [Select Customer__c from Customer_Document__c where Id = :CDId Limit 1];
			Set<Id> parentIds = new Set<Id>();
			for(Account Acco: [SELECT Id,name,Parentid, AccountNumber, Parent.Id, Parent.OwnerId, Parent.AccountNumber FROM Account WHERE Id=: objCD.Customer__c]) {
				parentIds.add(Acco.parentId);
			} 
			List<Apttus_Proposal__Proposal__c> lstQuote = [Select Id from Apttus_Proposal__Proposal__c where Apttus_Proposal__Account__c IN : parentIds AND Apttus_Proposal__Approval_Stage__c = 'Approved'];
			Set<Id> qId = new Set<Id>();
			for(Apttus_Proposal__Proposal__c objQuote :lstQuote){
				qId.add(objQuote.Id); 
			}
			system.debug('query--->'+query);
			listProposals = Database.query(query);
			//listProposals = [select id,name,Quote_Status__c,Nokia_Customer_Document_ID__c from Apttus_Proposal__Proposal__c order by createddate desc limit 50000];	
		}
		catch(Exception e){
			system.debug('Exception --> '+e);
			throw new QTO_CustomException(e);
			//throw new QTO_CustomException('Error occurred while fetching proposals.');
			//throw new QTO_CustomException('Error occurred while fetching proposals.');
		}
		return listProposals;
	}
	
	
	// To Fetch all Agreement based on Content Doc Id
	private static List<Apttus__APTS_Agreement__c> getAllAgreements(String CDId){
		List<Apttus__APTS_Agreement__c> listAgreements = new List<Apttus__APTS_Agreement__c>();
		String query = prepareSelectQuery(AGREEMENT,CDId);
		try{
			listAgreements = Database.query(query);
			//listAgreements = [select id,name,Apttus__Status__c from Apttus__APTS_Agreement__c order by createddate desc limit 50000];	
		}
		catch(Exception e){
			throw new QTO_CustomException('Error occurred while fetching agreements.');
		}
		return listAgreements;
	}
	
	private static List<Customer_Document__c> getAllCds(String CdId) {
		String query = prepareSelectQuery(CUSTOMERDOCUMENT, CdId);
		List<Customer_Document__c> listCds = new List<Customer_Document__c>();
		try{
			listCds = Database.query(query);
		}
		catch(Exception e){
			throw new QTO_CustomException('Error occurred while fetching Customer Associations.');
		}
		
		return listCds;
	}
	// Logic to create Query based on Meta data provided
	private static String prepareSelectQuery(String objectName, String CDId){
		System.debug('-----PREPARE SELECT QUERY STARTED-----');
		String query = 'Select Id,';
		
		if (objectName != CUSTOMERDOCUMENT) {
			List<QTO_Manual_Association_Config__mdt> listMetadata = [Select QTO_Field_API__c,QTO_IsSearchable__c from QTO_Manual_Association_Config__mdt where QTO_Object_Name__c=:objectName and QTO_Active__c = true];
			if(listMetadata.size()==0 && !Test.isRunningTest()){
				throw new QTO_CustomException('No fields specified in the manual association query, please contact system administrator');
			}
			for(QTO_Manual_Association_Config__mdt currentMetadata:listMetadata){
				query+=currentMetadata.QTO_Field_API__c+',';
			}
			query=query.removeEnd(',');
		}
		if (objectName == CUSTOMERDOCUMENT) {
			query = 'SELECT Classification__c, QTO_Nature__c,Customer__c,' +
				'Nokia_Document_Receipt_Date__c,' +
				'Sub_Classification__c,' +
				'Total_Value__c,' +
				'Version_Nr__c,' +
				'Name,' +
				'Nokia_Legal_entity__c,' +
				'Customer_Document_ID__c FROM Customer_Document__c WHERE ';
			query = prepareCDAssociationWhereClause(query, CDId);
		}
		else if(objectName.equalsIgnoreCase(QUOTE)){
			query+=',QTO_Association_Status__c from '+getObjectAPI(objectName);
			query+=' where (Id in :qId) OR ('; 
			query = prepareQuoteWhereClause(query,CDId);
		}
		else{
			query+=' from '+getObjectAPI(objectName);
			query+=' where ';
			query = prepareAgreementWhereClause(query,CDId);
		}			
		System.debug('-----PREPARE SELECT QUERY ENDED-----');
		query = query + ' Order By Createddate Desc';
		return query;
	}
	// Adding Filters for Quote Query
	// @Harsha - DSI-2340 : changed the query to only filter Approved Quotes
	private static String prepareQuoteWhereClause(String query, String CDId){
		Customer_Document__c objCD = [Select Customer__c from Customer_Document__c where Id = :CDId Limit 1];
		system.debug('objCD--->'+CDId+'--'+objCD);
		System.debug('-----PREPARE WHERE CLAUSE STARTED-----');
		
		string customer = objCD.Customer__c;
		system.debug('objCD.CUSTOMER--->'+objCD.Customer__c);
		if(Test.isRunningTest()){
			//query+=' Apttus_Proposal__Approval_Stage__c not in ('+'\''+'Rejected'+'\',\''+'Withdrawn'+'\',\''+'Draft'+'\''+'))';
			query+=' Apttus_Proposal__Approval_Stage__c = '+'\''+'Approved'+'\''+')';
		}else{
			//query+=' Apttus_Proposal__Approval_Stage__c not in ('+'\''+'Rejected'+'\',\''+'Withdrawn'+'\',\''+'Draft'+'\''+') AND Sold_To_Party__c = \''+String.escapeSingleQuotes(customer)+'\')';
			query+=' Apttus_Proposal__Approval_Stage__c = '+'\''+'Approved'+'\''+' AND Sold_To_Party__c = \''+String.escapeSingleQuotes(customer)+'\')';
		}
		System.debug('-----PREPARE WHERE CLAUSE ENDED-----'+query);
		return query;
	}
	// Adding Filters for Agreement Query
	private static String prepareAgreementWhereClause(String query, String CDId){
		Customer_Document__c objCD = [Select Customer__c from Customer_Document__c where Id = :CDId Limit 1];
		system.debug('objCD--->'+CDId+'--'+objCD);
		System.debug('-----PREPARE WHERE CLAUSE STARTED-----');
		
		string customer = objCD.Customer__c;
		//'+'\''+'In Effect
		if(Test.isRunningTest()) {
			query+=' Apttus__Status_Category__c  in ('+'\'In Application\',\'In Effect\''+')';
		}
		else
			query+=' Apttus__Status_Category__c  in ('+'\'In Application\',\'In Effect\''+') AND Apttus__Account__c = \''+String.escapeSingleQuotes(customer)+'\'';
		
		//query+=' Apttus__Status_Category__c  in ('+'\'In Application\',\'In Effect\''+') AND Apttus__Account__c = \''+String.escapeSingleQuotes(customer)+'\'';
		System.debug('-----PREPARE WHERE CLAUSE ENDED-----'+query);
		return query;
	}
	
	private static String prepareCDAssociationWhereClause(String query, String CdId) {
		Customer_Document__c objCD = [
			SELECT Customer_Document_Id__c, QTO_Nature__c
			FROM Customer_Document__c
			WHERE Id = :CDId
			Limit 1];
		
		String customer = objCD.Customer_Document_Id__c;
		
		query +=' Customer_Document_Id__c = \''+String.escapeSingleQuotes(customer)+'\'' +
			//  ' AND Customer__c = \'' + objCD.Customer__c +'\'' +
			// ' AND Nokia_Legal_entity__c = \'' + nokiaLegal +'\'' +
			// ' AND Classification__c = \'' + objCD.Classification__c +'\'' + 
			// ' AND Sub_Classification__c = \'' + objCD.Sub_Classification__c +'\'' +
			' AND Id != \'' + CDId +'\'' +
			' AND QTO_Nature__c != \'' + objCD.QTO_Nature__c +'\'';
		
		System.debug('queryquery' + query);
		return query;
	}
	
	private static string getObjectAPI(String objectName){
		if(objectName.equals(AGREEMENT)){
			return 'Apttus__APTS_Agreement__c';
		}
		else if(objectName.equals(QUOTE)){
			return 'Apttus_Proposal__Proposal__c';
		}
		else{
			throw new QTO_CustomException('Please select a valid object.');
		}
	}
	// Logic to fetch Metadata and generate Lightning Datatable header 
	public static List<dataTableHeader> getTableHeaders(string objName){
		List<dataTableHeader> retlst = new List<dataTableHeader>();
		
		if (objName == CUSTOMERDOCUMENT) {
			dataTableHeader retObj = new dataTableHeader();
			retObj.label = 'Customer Document ID';
			retObj.fieldName = 'Customer_Document_ID__c';
			retObj.type = 'text';
			retlst.add(retObj);
			
			dataTableHeader retObj1 = new dataTableHeader();
			retObj1.label = 'Version Nr';
			retObj1.fieldName = 'Version_Nr__c';
			retObj1.type = 'text';
			retlst.add(retObj1);
			
			dataTableHeader retObj2 = new dataTableHeader();
			retObj2.label = 'Nokia Customer Document ID';
			retObj2.fieldName = 'Name';
			retObj2.type = 'text';
			retlst.add(retObj2);
			
			dataTableHeader retObj3 = new dataTableHeader();
			retObj3.label = 'Nokia Document Receipt Date';
			retObj3.fieldName = 'Nokia_Document_Receipt_Date__c';
			retObj3.type = 'date';
			retlst.add(retObj3);
			
			dataTableHeader retObj4 = new dataTableHeader();
			retObj4.label = 'Classification';
			retObj4.fieldName = 'Classification__c';
			retObj4.type = 'text';
			retlst.add(retObj4);
			
			dataTableHeader retObj5 = new dataTableHeader();
			retObj5.label = 'Sub Classification';
			retObj5.fieldName = 'Sub_Classification__c';
			retObj5.type = 'text';
			retlst.add(retObj5);
			
			dataTableHeader retObj6 = new dataTableHeader();
			retObj6.label = 'Nature';
			retObj6.fieldName = 'QTO_Nature__c';
			retObj6.type = 'text';
			retlst.add(retObj6);
			
			dataTableHeader retObj7 = new dataTableHeader();
			retObj7.label = 'Total Value';
			retObj7.fieldName = 'Total_Value__c';
			retObj7.type = 'text';
			retlst.add(retObj7);
			
			dataTableHeader retObj8 = new dataTableHeader();
			retObj8.label = 'Nokia Legal entity';
			retObj8.fieldName = 'Nokia_Legal_entity__c';
			retObj8.type = 'text';
			retlst.add(retObj8);
			
		} else if (objName == CUSTLINEITEMS) {
			dataTableHeader retObj2 = new dataTableHeader();
			retObj2.label = 'CD Line Item Name';
			retObj2.fieldName = 'Name';
			retObj2.type = 'text';
			retlst.add(retObj2);
			
			dataTableHeader retObj1 = new dataTableHeader();
			retObj1.label = 'Product';
			retObj1.fieldName = 'High_level_Product__c';
			retObj1.type = 'text';
			retlst.add(retObj1);
			
			dataTableHeader retObj = new dataTableHeader();
			retObj.label = 'Product Description';
			retObj.fieldName = 'High_level_Product_Description__c';
			retObj.type = 'text';
			retlst.add(retObj);
			
			dataTableHeader retObj3 = new dataTableHeader();
			retObj3.label = 'Quantity';
			retObj3.fieldName = 'Quantity__c';
			retObj3.type = 'text';
			retlst.add(retObj3);
			
			
			dataTableHeader retObj4 = new dataTableHeader();
			retObj4.label = 'Units of Measure';
			retObj4.fieldName = 'QTO_Unit_of_Measure__c';
			retObj4.type = 'text';
			retlst.add(retObj4);
			
			dataTableHeader retObj5 = new dataTableHeader();
			retObj5.label = 'Unit Price';
			retObj5.fieldName = 'QTO_Unit_Price__c';
			retObj5.type = 'text';
			retlst.add(retObj5);
			
			dataTableHeader retObj6 = new dataTableHeader();
			retObj6.label = 'Total Value';
			retObj6.fieldName = 'Total_Value__c';
			retObj6.type = 'text';
			retlst.add(retObj6);
			
			dataTableHeader retObj7 = new dataTableHeader();
			retObj7.label = 'Association';
			// retObj7.fieldName = 'Association_Comment__c';
			retObj7.type = 'button-icon';
			// retObj7.iconName='utility:event';
			retObj7.typeAttributes = new TypeAttributes();
			retObj7.typeAttributes.iconName = new FieldName('QTO_Association_Icon__c');
			retObj7.typeAttributes.iconClass = new FieldName('QTO_Association_Icon_Class__c');
			retlst.add(retObj7);
			
			dataTableHeader retObj72 = new dataTableHeader();
			retObj72.label = 'Matching';
			retObj72.type = 'button-icon';
			retObj72.typeAttributes = new TypeAttributes();
			retObj72.typeAttributes.iconName = new FieldName('QTO_Matching_Icon__c');
			retObj72.typeAttributes.iconClass = new FieldName('QTO_Matching_Icon_Class__c');
			retlst.add(retObj72);

			dataTableHeader retObj8 = new dataTableHeader();
			retObj8.label = 'Association Waiver Comment';
			// retObj8.fieldName = 'QTO_CDLI_Association_Waiver_Comment__c';
			// retObj8.type = 'text';
			retObj8.fieldName = 'QTO_CDLI_Waiver_Association__c';
			retObj8.type = 'boolean';
			retObj8.editable = true;
			retlst.add(retObj8);
			
			dataTableHeader retObj9 = new dataTableHeader();
			retObj9.label = 'Matching Waiver Comment';
			// retObj9.fieldName = 'QTO_CDLI_Matching_Waiver_Comment__c';
			// retObj9.type = 'text';
			retObj9.fieldName = 'QTO_CDLI_Waiver_Matching__c';
			retObj9.type = 'boolean';
			retObj9.editable = true;
			retlst.add(retObj9);
		} 
		else {
			Map<Decimal,QTO_Manual_Association_Config__mdt > mapTemp = new  Map<Decimal,QTO_Manual_Association_Config__mdt >();
			if(!Test.isRunningTest()){
				for(QTO_Manual_Association_Config__mdt obj : [Select QTO_Field_API__c,QTO_DataType__c,Label,QTO_IsSearchable__c,QTO_Sequence__c from QTO_Manual_Association_Config__mdt where QTO_Object_Name__c=:objName and QTO_Active__c = true Order by QTO_Sequence__c]){
					mapTemp.put(obj.QTO_Sequence__c,obj);
				}
				for(Decimal key :mapTemp.keySet()){
					dataTableHeader retObj = new dataTableHeader();
					retObj.label = mapTemp.get(key).Label;
					retObj.fieldName = mapTemp.get(key).QTO_Field_API__c;
					retObj.type = mapTemp.get(key).QTO_DataType__c;
					retlst.add(retObj);
				}
			}
		}
		return retlst;
	}
	// DSI - 2194
	public static Boolean updateWaiverCommentsOnCustomerDocumentLines(List<Customer_Document_Line_Items__c> cdLines, String cdId) {
		List<Customer_Document_Line_Items__c> cdLinesToUpdate = new List<Customer_Document_Line_Items__c>();
		for(Customer_Document_Line_Items__c eachCdLine : cdLines) {
			Customer_Document_Line_Items__c cdLineToUpdate = new Customer_Document_Line_Items__c();
			cdLineToUpdate.Id = eachCdLine.Id;
			if (eachCDLine.get('QTO_CDLI_Waiver_Association__c') <> null) {
				cdLineToUpdate.QTO_CDLI_Association_Waiver_Comment__c = eachCdLine.QTO_CDLI_Waiver_Association__c ? 'Yes' : 'No';
			}
			if (eachCDLine.get('QTO_CDLI_Waiver_Matching__c') <> null) {
				cdLineToUpdate.QTO_CDLI_Matching_Waiver_Comment__c = eachCdLine.QTO_CDLI_Waiver_Matching__c ? 'Yes' : 'No';
			}
			cdLinesToUpdate.add(cdLineToUpdate);
		}
		update cdLinesToUpdate;

		// update matching status
		QTO_CDLineItemMatchingHelper.updateCDocStatus(QTO_ManualAssociationControllerHelper.findAllCDLines(cdId));
		return true;
	}
	public class dataWrapper{  
		@AuraEnabled public List<sObject> dataList {get; set;}  
		@AuraEnabled public set<Id> selectedIdSet {get; set;}  
	}  
	public class dataTableHeader{  
		@AuraEnabled public string label {get; set;}  
		@AuraEnabled public string fieldName {get; set;} 
		@AuraEnabled public string type {get; set;}
		@AuraEnabled public string iconName {get; set;}
		@AuraEnabled public TypeAttributes typeAttributes;
		@AuraEnabled public Boolean editable = false;
	}  
	public class TypeAttributes {
		@AuraEnabled public FieldName iconName;
		@AuraEnabled public String variant = 'bare';
		@AuraEnabled public FieldName iconClass;
	}
	public class FieldName {
		@AuraEnabled public String fieldName;
		public FieldName(String fieldName) {
			this.fieldName = fieldName;
		}
	}
	public class cdAssociateData {
		@AuraEnabled public Id docId;
		@AuraEnabled public String customerDocumentId;
		@AuraEnabled public String version;
		@AuraEnabled public String nokiaCustomerDocumentId;
		@AuraEnabled public Date receiptId;
		@AuraEnabled public String classification;
		@AuraEnabled public String subClassification;
		@AuraEnabled public String nature;
		@AuraEnabled public String totalValue;
		@AuraEnabled public String nokiaLegalEntity;
	}
}