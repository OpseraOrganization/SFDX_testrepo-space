public with sharing class CPO_OrderEnrichmentLineItemCreation {
	public static Boolean isFirstTime = true;
	
	public static void createLineItems(List<Apttus_Config2__CustomerPurchaseOrder__c> cpoList) {
		List<Id> cdDocIds = new List<Id>(); // All customer document ids for the given purchase orders
		Map<Id, Id> cpoToCd = new Map<Id, Id>(); // mapping of customer document ids by purchase order id
		for (Apttus_Config2__CustomerPurchaseOrder__c cpo : cpoList) {
			System.debug('this is status' + cpo.get('Apttus_Config2__Status__c'));
			// package limitation, purchase order lines can only be created in draft or amendment status of purchase order
			if (cpo.get('Apttus_Config2__Status__c') == 'Draft') {
				cdDocIds.add(cpo.Nokia_Customer_Document_ID__c);
				cpoToCd.put(cpo.Id, cpo.Nokia_Customer_Document_ID__c);
			}
			//cpo.Apttus_Config2__Status__c = 'Commercially Enriched';
		}
		
		if (!cdDocIds.isEmpty()) {
			// Get all field mappings for the purchase order lines, which will be mapped from customer document lines
			Map<String, CPO_Enrichment_Line_Field_Mapping__mdt> fieldMapping =
				getFieldMapping('Customer_Document_Line_Items__c');
			
			List<String> cdLineFields = new List<String>();
			List<String> proposalLineFields = new List<String>();
			
			Map<String, CPO_Enrichment_Line_Field_Mapping__mdt> cdLineMap =
				new Map<String, CPO_Enrichment_Line_Field_Mapping__mdt>();
			// purchase order line fields that should be mapped from cd line items
			for (String field: fieldMapping.keySet()) {
				if (fieldMapping.get(field).Source_Object__c == 'Customer_Document_Line_Items__c') {
					cdLineFields.add(fieldMapping.get(field).Token_Api__c); // field from the scource object
				}
				// If the source object is proposal line items and field mappings exists, copy the fields
				if (fieldMapping.get(field).Source_Object__c == 'Apttus_Proposal__Proposal_Line_Item__c') {
					proposalLineFields.add(fieldMapping.get(field).Token_Api__c); 
					cdLineMap.put(field, fieldMapping.get(field));
				}
			}
			// Get all field mappings for the purchase order lines, which will be mapped from quote/proposal line item
			Map<String, CPO_Enrichment_Line_Field_Mapping__mdt> fieldMapping1 =
				getFieldMapping('Apttus_Proposal__Proposal_Line_Item__c');
			
			for (String field: fieldMapping1.keySet()) {
				if (fieldMapping1.get(field).Source_Object__c == 'Apttus_Proposal__Proposal_Line_Item__c') {
					proposalLineFields.add(fieldMapping1.get(field).Token_Api__c); // field from the scource object
					cdLineMap.put(field, fieldMapping1.get(field));
				}
			}
			// Get all field mappings for the purchase order lines, which will be mapped from agreement line item
			Map<String, CPO_Enrichment_Line_Field_Mapping__mdt> fieldMapping2 =
				getFieldMapping('Apttus__AgreementLineItem__c');
			
			List<String> agrFields = new List<String>();
			//Map<String,
			for (String field: fieldMapping2.keySet()) {
				if (fieldMapping2.get(field).Source_Object__c == 'Apttus__AgreementLineItem__c') {
					agrFields.add(fieldMapping2.get(field).Token_Api__c); // field from the scource object
				}
			}
			System.debug('cdLineFields' + cdLineFields);
			String allFields = String.join(cdLineFields, ',');
			// Get all customer doc line items for the customer docs in the purchase orders
			String agreementQuery = 'SELECT ' + allFields +
				' FROM Customer_Document_Line_Items__c ' +
				' WHERE Customer_Document__c IN: cdDocIds';
			// get all cd line items with the field values to be mapped to po lines
			List<Customer_Document_Line_Items__c> cdLines = Database.query(agreementQuery);
			
			Map<Id, List<Customer_Document_Line_Items__c>> cdIdToCdLines =
				new Map<Id, List<Customer_Document_Line_Items__c>>();   
			Map<Id, List<Id>> cdToLineIds = new Map<Id, List<Id>>();
			List<Id> allCdLines = new List<Id>();
			for (Customer_Document_Line_Items__c cdLine : cdLines) {
				allCdLines.add(cdline.Id);
				if (cdIdToCdLines.containsKey(cdLine.Customer_Document__c)) {
					cdIdToCdLines.get(cdLine.Customer_Document__c).add(cdLine);
					cdToLineIds.get(cdLine.Customer_Document__c).add(cdLine.Id);
				} else {
					cdIdToCdLines.put(cdLine.Customer_Document__c,
									  new List<Customer_Document_Line_Items__c> { cdLine });
					cdToLineIds.put(cdLine.Customer_Document__c, new List<Id> { cdLine.Id});		
				}
			}   
			System.debug('allCdLines:::::' + allCdLines);   
			
			List<QTO_Customer_Document_Quote_Line__c> cdLineQuoteAssociations = [
				SELECT QTO_Customer_Document_Line_Items__c, QTO_Proposal_Line_Item__c,
				QTO_Proposal_Line_Item__r.Apttus_Proposal__Proposal__c
				FROM QTO_Customer_Document_Quote_Line__c
				WHERE QTO_Customer_Document_Line_Items__c IN:allCdLines];
			
			// collect the quote/proposals associated with the customer document
			Map<Id, Id> cdLineToQuoteId = new Map<Id, Id>();
			Map<Id, Id> quoteLineAssociationtoQuoteId = new Map<Id, Id>();		   
			for (QTO_Customer_Document_Quote_Line__c cdlineQuote: cdLineQuoteAssociations) {
				cdLineToQuoteId.put(cdlineQuote.QTO_Customer_Document_Line_Items__c, cdlineQuote.QTO_Proposal_Line_Item__r.Apttus_Proposal__Proposal__c);
				quoteLineAssociationtoQuoteId.put(cdLineQuote.Id, cdlineQuote.QTO_Proposal_Line_Item__r.Apttus_Proposal__Proposal__c);
			}
			
			List<Id> proposalIds = quoteLineAssociationtoQuoteId.values();
			
			String proposalQuery =
				' SELECT ' + String.join(proposalLineFields, ',') +
				' FROM Apttus_Proposal__Proposal_Line_Item__c ' +
				' WHERE Apttus_Proposal__Proposal__c IN: proposalIds ' +
				' AND Apttus_QPConfig__LineType__c = \'Option\'';
			// get all quote/proposal line items with the field values to be mapped to po lines
			List<Apttus_Proposal__Proposal_Line_Item__c> proposalsLines = Database.query(proposalQuery);
			
			Map<Id, List<Apttus_Proposal__Proposal_Line_Item__c>> proposalToPl =
				new Map<Id, List<Apttus_Proposal__Proposal_Line_Item__c>>();
			for (Apttus_Proposal__Proposal_Line_Item__c pl: proposalsLines) {
				if (proposalToPl.containsKey(pl.Apttus_Proposal__Proposal__c)) {
					proposalToPl.get(pl.Apttus_Proposal__Proposal__c).add(pl);
				} else {
					proposalToPl.put(pl.Apttus_Proposal__Proposal__c,
									 new List<Apttus_Proposal__Proposal_Line_Item__c> { pl });
				}
			}
			
			system.debug('proposalToPl:::: ' + proposalToPl);
			System.debug('allCdLinesallCdLines::::' + allCdLines);
			List<QTO_Customer_Document_Agreement_Line__c> agrAssoLines = [
				SELECT QTO_Agreement_Line_Item__c, QTO_Customer_Document_Line_Items__c
				FROM QTO_Customer_Document_Agreement_Line__c
				WHERE QTO_Customer_Document_Line_Items__c IN:allCdLines];
			
			System.debug('agrAssoLinesagrAssoLines::::' + agrAssoLines);
			
			List<Id> assoAgrs = new List<Id>();
			Map<Id, List<Id>> cdLineToAgrLines = new Map<Id, List<Id>>();
			// collect all agreement line item ids from cd to agreement association
			for (QTO_Customer_Document_Agreement_Line__c agr:agrAssoLines) {
				assoAgrs.add(agr.QTO_Agreement_Line_Item__c);			   
				if (cdLineToAgrLines.containsKey(agr.QTO_Customer_Document_Line_Items__c)) {
					cdLineToAgrLines.get(agr.QTO_Customer_Document_Line_Items__c)
						.add(agr.QTO_Agreement_Line_Item__c);
				} else {
					cdLineToAgrLines.put(agr.QTO_Customer_Document_Line_Items__c,
										 new List<Id> { agr.QTO_Agreement_Line_Item__c });
				}
			}
			
			System.debug('cdLineToAgrLines::::' + cdLineToAgrLines);
			String agrQuery = ' SELECT ' + String.join(agrFields, ',') +
				' FROM Apttus__AgreementLineItem__c ' +
				' WHERE Id IN: assoAgrs';
			// get all agreement line items with the field values to be mapped to po lines
			List<Apttus__AgreementLineItem__c> argLines =
				Database.query(agrQuery);
			
			Map<Id, Apttus__AgreementLineItem__c> lineToAgrLineList =
				new Map<Id, Apttus__AgreementLineItem__c>();
			for (Apttus__AgreementLineItem__c agr: argLines) {
				lineToAgrLineList.put(agr.Id, agr);
			}
			
			List<Apttus_Config2__CustomerPOItem__c> poItems =
				new List<Apttus_Config2__CustomerPOItem__c>();
			
			List<Id> lineItemIds = allCdLines;
			Set<Id> quoteIds = cdLineToQuoteId.keySet();
			Set<Id> proposalLine = quoteLineAssociationtoQuoteId.keySet();
			// Get all customer facing attributes for cd, cd lines, quote, quote lines
			List<Customer_facing_Attribute__c> cFAList =
				[SELECT QTO_Customer_Document__c, QTO_Customer_Document_Line_Items__c,
				 Quote_Line_Item__c, Quote__c, CPO__c, CPO_item__c
				 FROM Customer_facing_Attribute__c
				 WHERE QTO_Customer_Document__c IN:cdDocIds
				 OR QTO_Customer_Document_Line_Items__c IN:lineItemIds
				 OR Quote_Line_Item__c IN: proposalLine
				 OR Quote__c IN:quoteIds];
			
			Map<Id, List<Customer_facing_Attribute__c>> cdDocCfa =
				new Map<Id, List<Customer_facing_Attribute__c>>();
			Map<Id, List<Customer_facing_Attribute__c>> cdDocLineCfa =
				new Map<Id, List<Customer_facing_Attribute__c>>();
			Map<Id, List<Customer_facing_Attribute__c>> cdDocQuoteCfa =
				new Map<Id, List<Customer_facing_Attribute__c>>();
			Map<Id, List<Customer_facing_Attribute__c>> cdDocQuoteLineCfa =
				new Map<Id, List<Customer_facing_Attribute__c>>();
			// store cfas categorized by object
			for (Customer_facing_Attribute__c cfa:cFAList) {
				if (cfa.QTO_Customer_Document__c != null) {
					if (cdDocCfa.containsKey(cfa.QTO_Customer_Document__c)) {
						cdDocCfa.get(cfa.QTO_Customer_Document__c).add(cfa);
					} else {
						cdDocCfa.put(cfa.QTO_Customer_Document__c, new List<Customer_facing_Attribute__c> { cfa });
					}
				}
				
				if (cfa.QTO_Customer_Document_Line_Items__c != null) {
					if (cdDocLineCfa.containsKey(cfa.QTO_Customer_Document_Line_Items__c)) {
						cdDocLineCfa.get(cfa.QTO_Customer_Document_Line_Items__c).add(cfa);
					} else {
						cdDocLineCfa.put(cfa.QTO_Customer_Document_Line_Items__c, new List<Customer_facing_Attribute__c> { cfa });
					}
				}
				
				if (cfa.Quote__c != null) {
					if (cdDocQuoteCfa.containsKey(cfa.Quote__c)) {
						cdDocQuoteCfa.get(cfa.Quote__c).add(cfa);
					} else {
						cdDocQuoteCfa.put(cfa.Quote__c, new List<Customer_facing_Attribute__c> { cfa });
					}
				}
				
				if (cfa.Quote_Line_Item__c != null) {
					if (cdDocQuoteLineCfa.containsKey(cfa.Quote_Line_Item__c)) {
						cdDocQuoteLineCfa.get(cfa.Quote_Line_Item__c).add(cfa);
					} else {
						cdDocQuoteLineCfa.put(cfa.Quote_Line_Item__c, new List<Customer_facing_Attribute__c> { cfa });
					}
				}
			}		   
			//System.debug('');
			
			for (Id cpoId: cpoToCd.keySet()) { // for each cpo
				Integer lineNumber = 1; // line number should be incremented by one
				Integer itemSequence = 1;
				// if cd is found and cd has cd line items
				// create cpo line items for each cd line item
				if (cpoToCd.get(cpoId) != null && cdIdToCdLines.get(cpoToCd.get(cpoId)) != null) {
					// for each cd line in the cd associated with the cpo
					for (Customer_Document_Line_Items__c cdLine : cdIdToCdLines.get(cpoToCd.get(cpoId))) {
						Apttus_Config2__CustomerPOItem__c poItem =
							new Apttus_Config2__CustomerPOItem__c();
						for (String fieldApi :fieldMapping.keySet()) {
							CPO_Enrichment_Line_Field_Mapping__mdt cpoMapping = fieldMapping.get(fieldApi);
							
							if (cpoMapping.Source_Object__c == 'Customer_Document_Line_Items__c') {
								System.debug(':::::cpoMapping.Token_API__c' + cpoMapping.Token_API__c);
								System.debug(':::::cpoMapping.Token_API__c:::::::' +
											 checkIsNull(cdLine.get(cpoMapping.Token_API__c)));
								Boolean isNull = checkIsNull(cdLine.get(cpoMapping.Token_API__c));						   
								if (!isNull) {
									poItem.put(
										!cpoMapping.MasterLabel.endsWith('__c') && cpoMapping.MasterLabel.length() >= 38
										? cpoMapping.MasterLabel + '__c' : cpoMapping.MasterLabel,
										cdLine.get(cpoMapping.Token_Api__c)
									);
								}	  
							}
						}
						System.debug(':::::cpoMapping.poItem:::::::' +poItem);
						
						poItem.put('Apttus_Config2__PurchaseOrderId__c', cpoId);
						poItem.put('Line_Type__c', 'Product/Service');
						poItem.put('QTO_POI_ItemSequence__c', itemSequence);
						poItem.put('QTO_POI_LineNumber__c', lineNumber);				  
						
						System.debug('poItem:::::::' + poItem);
						poItems.add(poItem);
						itemSequence++;
						System.debug('cdLineMap');
						// lineNumber = lineNumber + 1;
					}
					
					for(Id cdLineId : cdLineToQuoteId.keySet()) {
						Id quoteId = cdLineToQuoteId.get(cdLineId);
						// if associated proposal is found and proposal has proposal line items
						// create cpo line items for each proposal line item
						if (quoteId != null && proposalToPl.get(quoteId) != null) {							
							Integer proposalLineNumber = 2, proposalItemSequence = 1;
							for (Apttus_Proposal__Proposal_Line_Item__c pl: proposalToPl.get(quoteId)) {
								Apttus_Config2__CustomerPOItem__c poItem1 =
									new Apttus_Config2__CustomerPOItem__c();
								for (String fieldApi :cdLineMap.keySet()) {
									CPO_Enrichment_Line_Field_Mapping__mdt cpoMapping =
										cdLineMap.get(fieldApi);							   
									if (cpoMapping.Source_Object__c == 'Apttus_Proposal__Proposal_Line_Item__c') {
										Boolean isNull = checkIsNull(pl.get(cpoMapping.Token_API__c));								   
										if (!isNull) {
											poItem1.put(cpoMapping.MasterLabel, pl.get(cpoMapping.Token_Api__c));
										}
									}
								}
								
								poItem1.put('Apttus_Config2__PurchaseOrderId__c', cpoId);
								poItem1.put('QTO_POI_Customer_Document__c', cpoToCd.get(cpoId));
								poItem1.put('QTO_POI_Customer_Document_Line_Item__c', cdLineId);
								poItem1.put('QTO_POI_ItemSequence__c', proposalItemSequence);
								poItem1.put('QTO_POI_LineNumber__c', proposalLineNumber);
								
								System.debug('poItem12:::::' + poItem1);						   
								poItems.add(poItem1);
								proposalItemSequence++; // = proposalItemSequence + 1;
							}
						}
					}
					
					for (Id cdlineId : cdLineToAgrLines.keySet()) {
						// if associated agreement is found and agreement has agreement line items
						// create cpo line items for each agreement line item
						if (cdLineToAgrLines.get(cdlineId) != null) {
							System.debug('cdLine.Id:::: ' + cdlineId);
							System.debug('cdLineToAgrLines:::: ' + cdLineToAgrLines);
							System.debug('lineToAgrLineList:::: ' + lineToAgrLineList);
							Integer agreementLineNumber = 3, agreementItemSequence = 1;
							for (Id agrLineId :cdLineToAgrLines.get(cdLineId)) {
								Apttus__AgreementLineItem__c agrLineRec = lineToAgrLineList.get(agrLineId);
								System.debug('agrLineRec::::' + agrLineRec);
								Apttus_Config2__CustomerPOItem__c poItem2 =
									new Apttus_Config2__CustomerPOItem__c();
								for (String fieldApi :fieldMapping2.keySet()) {
									CPO_Enrichment_Line_Field_Mapping__mdt cpoMapping = fieldMapping2.get(fieldApi);							   
									if (cpoMapping.Source_Object__c == 'Apttus__AgreementLineItem__c') {
										Boolean isNull = checkIsNull(agrLineRec.get(cpoMapping.Token_API__c));								   
										if (!isNull) {
											poItem2.put(cpoMapping.MasterLabel, agrLineRec.get(cpoMapping.Token_Api__c));
										}
									}
								}
								
								poItem2.put('Apttus_Config2__PurchaseOrderId__c', cpoId);
								poItem2.put('Line_Type__c', 'Product/Service');
								poItem2.put('QTO_POI_Customer_Document__c', cpoToCd.get(cpoId));
								poItem2.put('QTO_POI_Customer_Document_Line_Item__c', cdlineId);
								poItem2.put('QTO_POI_ItemSequence__c', agreementItemSequence);
								poItem2.put('QTO_POI_LineNumber__c', agreementLineNumber);
								
								System.debug('poItem12:::::' + poItem2);						   
								poItems.add(poItem2);						   
								agreementItemSequence++; // = agreementItemSequence + 1;
							}
						}
					}
				}
			}
			
			// debugging the status of po when poitem is created
			/*for (Apttus_Config2__CustomerPurchaseOrder__c po : [
				SELECT Id, Name, Apttus_Config2__Status__c FROM Apttus_Config2__CustomerPurchaseOrder__c WHERE Id IN :cpoToCd.keySet()]) {
				System.debug('Status of PO while creating POItems');
				System.debug('PO Number - ' + po.Name + ' - Id - ' + po.Id + ' - Status -- ' + po.Apttus_Config2__Status__c);
			}*/
			
			if(!Test.isRunningTest()) {
				insert poItems;
			}
			// as po items will not be created when po is not in amendment/draft, moved the validate cpo to after po item creation
			CPO_OrderEnrichmentHeaderCreation.validateCpo(cpoList, false);
			
			Map<Id, Customer_facing_Attribute__c> cfaToUpdate = new Map<Id, Customer_facing_Attribute__c>();
			for (Apttus_Config2__CustomerPOItem__c poi: poItems) {
				if (poi.QTO_POI_Customer_Document__c != null) { // po item has cd
					if(cdDocCfa.get(poi.QTO_POI_Customer_Document__c) != null) { // cd has cfa records
						for (Customer_facing_Attribute__c c: cdDocCfa.get(poi.QTO_POI_Customer_Document__c)) {
							// get the cfa under the cd and update the po and po items on it
							Customer_facing_Attribute__c cfaToU =
								cfaToUpdate.containsKey(c.Id)
								? cfaToUpdate.get(c.Id)
								: c;
							cfaToU.CPO_item__c = poi.Id;
							cfaToU.CPO__c = poi.Apttus_Config2__PurchaseOrderId__c;						   
							cfaToUpdate.put(cfaToU.Id, cfaToU);
						}
					}
				}
				
				if (poi.QTO_POI_Customer_Document_Line_Item__c != null) {
					if(cdDocLineCfa.get(poi.QTO_POI_Customer_Document_Line_Item__c) != null) {
						for (Customer_facing_Attribute__c c:
							 cdDocLineCfa.get(poi.QTO_POI_Customer_Document_Line_Item__c)) {
								 Customer_facing_Attribute__c cfaToU =
									 cfaToUpdate.containsKey(c.Id)
									 ? cfaToUpdate.get(c.Id)
									 : c;
								 cfaToU.CPO_item__c = poi.Id;
								 cfaToU.CPO__c = poi.Apttus_Config2__PurchaseOrderId__c;						   
								 cfaToUpdate.put(cfaToU.Id, cfaToU);
							 }
					}
				}
				
				if (poi.Apttus_QPConfig__ProposalId__c != null) {
					if(cdDocQuoteCfa.get(poi.Apttus_QPConfig__ProposalId__c) != null) {
						for (Customer_facing_Attribute__c c:cdDocQuoteCfa.get(poi.Apttus_QPConfig__ProposalId__c)) {
							Customer_facing_Attribute__c cfaToU =
								cfaToUpdate.containsKey(c.Id)
								? cfaToUpdate.get(c.Id)
								: c;
							cfaToU.CPO_item__c = poi.Id;
							cfaToU.CPO__c = poi.Apttus_Config2__PurchaseOrderId__c;							
							cfaToUpdate.put(cfaToU.Id, cfaToU);
						}
					}
				}
				
				if (poi.Apttus_QPConfig__ProposalLineItemId__c != null) {
					if(cdDocQuoteLineCfa.get(poi.Apttus_QPConfig__ProposalLineItemId__c) != null) {
						for (Customer_facing_Attribute__c c:
							 cdDocQuoteLineCfa.get(poi.Apttus_QPConfig__ProposalLineItemId__c)) {
								 Customer_facing_Attribute__c cfaToU =
									 cfaToUpdate.containsKey(c.Id)
									 ? cfaToUpdate.get(c.Id)
									 : c;
								 cfaToU.CPO_item__c = poi.Id;
								 cfaToU.CPO__c = poi.Apttus_Config2__PurchaseOrderId__c;						   
								 cfaToUpdate.put(cfaToU.Id, cfaToU);
							 }
					}
				}
			}
			
			update cfaToUpdate.values();
			// System.enqueueJob(new CPO_QueueableCPOCDStatusChanger(new List<Id>(cpoToCd.keySet())));
		}
	}
	
	public static Boolean checkIsNull(Object value) {
		if (value == null) {
			return true;
		} else {
			return false;
		}
	}
	/*
	 * Get CPO_Enrichment_Line_Field_Mapping__mdt records for the given source object.
	 * So that, PO_Field_Api__c will have value same as Source_Object__c.Token_API__c
	 */
	private static Map<String, CPO_Enrichment_Line_Field_Mapping__mdt> getFieldMapping(String objectName) {
		Map<String, CPO_Enrichment_Line_Field_Mapping__mdt> fieldMapping =
			new Map<String, CPO_Enrichment_Line_Field_Mapping__mdt>();
		for (CPO_Enrichment_Line_Field_Mapping__mdt metadata :[
			SELECT Id, MasterLabel, QualifiedApiName,
			POI_Field_Api__c, Source_Object__c, Token_API__c
			FROM CPO_Enrichment_Line_Field_Mapping__mdt WHERE Source_Object__c =: objectName
		]) {
			fieldMapping.put(
				metadata.MasterLabel,
				metadata
			);
		}
		
		return fieldMapping;
	}
}