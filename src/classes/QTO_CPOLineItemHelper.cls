/*********************************************************************
* Class Name  : QTO_CPOLineItemHelper
* Test Class  : QTO_CPOLineItemHelperTest
* Updated Date: 07 Feb 2022
* Created By  : Shaik Johny Basha
* Description : CPO Line Items Creation
* Modified By : Shaik, Johny 
*******************************************************************/

public with sharing class QTO_CPOLineItemHelper {
	
	public static Boolean isFirstTime = true;
	static List<Id> cdDocIds = new List<Id>(); // All customer document ids for the given purchase orders
	static Map<Id, Id> cpoToCd = new Map<Id, Id>(); // mapping of customer document ids by purchase order id
	static List<Apttus_Config2__CustomerPurchaseOrder__c> purchaseOrdersToUpdate = new List<Apttus_Config2__CustomerPurchaseOrder__c>();
	static List<Customer_Document__c> customerDocumentsToUpdate = new List<Customer_Document__c>();
		
	
	public static void createLineItems(List<Apttus_Config2__CustomerPurchaseOrder__c> cpoList) {
		
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
			List<String> cdLineFields = new List<String>();
			List<String> proposalLineFields = new List<String>();
			List<String> agrFields = new List<String>();
			Map<Id, List<Id>> cdToLineIds = new Map<Id, List<Id>>();
			List<Id> allCdLines = new List<Id>();
			Map<Id, Id> cdLineToQuoteId = new Map<Id, Id>();
			Map<Id, Id> quoteLineAssociationtoQuoteId = new Map<Id, Id>();  
			Map<Id, List<QTO_Customer_Document_Quote_Line__c>> cdLQLIdMap = new Map<Id, List<QTO_Customer_Document_Quote_Line__c>>();
			Map<Id, List<QTO_Customer_Document_Agreement_Line__c>> cdLALIdMap = new Map<Id, List<QTO_Customer_Document_Agreement_Line__c>>();
			Set<Id> quoteSet = new Set<Id>();
			Set<Id> quoteLinesSet = new Set<Id>();
			Set<Id> agrLinesSet = new Set<Id>();
			//Map<Id, Decimal> qlItemSequenceMap = new Map<Id, Decimal>();
			
			Map<Id, Apttus__AgreementLineItem__c> agreementLinesMap = new Map<Id, Apttus__AgreementLineItem__c>();
			Map<Id, Id> agreementToQLMap = new Map<Id, Id>();
			Set<Id> agrQlQIds = new Set<Id>();
			 
			
			Map<String, CPO_Enrichment_Line_Field_Mapping__mdt> cdLineMap = new Map<String, CPO_Enrichment_Line_Field_Mapping__mdt>();
			Map<Id, List<Customer_Document_Line_Items__c>> cdIdToCdLines =new Map<Id, List<Customer_Document_Line_Items__c>>(); 
			
			// Get all field mappings for the purchase order lines, which will be mapped from customer document lines
			Map<String, CPO_Enrichment_Line_Field_Mapping__mdt> cdocLineFieldMapping = getFieldMappingMetaData('Customer_Document_Line_Items__c');
			// Get all field mappings for the purchase order lines, which will be mapped from quote/proposal line item
			Map<String, CPO_Enrichment_Line_Field_Mapping__mdt> quoteLineFieldMapping = getFieldMappingMetaData('Apttus_Proposal__Proposal_Line_Item__c');
			// Get all field mappings for the purchase order lines, which will be mapped from agreement line item
			Map<String, CPO_Enrichment_Line_Field_Mapping__mdt> agrLineFieldMapping = getFieldMappingMetaData('Apttus__AgreementLineItem__c');
			
			
			// purchase order line fields that should be mapped from cd line items
			for (String field: cdocLineFieldMapping.keySet()) {
				if (cdocLineFieldMapping.get(field).Source_Object__c == 'Customer_Document_Line_Items__c') {
					cdLineFields.add(cdocLineFieldMapping.get(field).Token_Api__c); // field from the scource object
				}
				// If the source object is proposal line items and field mappings exists, copy the fields
				if (cdocLineFieldMapping.get(field).Source_Object__c == 'Apttus_Proposal__Proposal_Line_Item__c') {
					proposalLineFields.add(cdocLineFieldMapping.get(field).Token_Api__c); 
					cdLineMap.put(field, cdocLineFieldMapping.get(field));
				}
			}
			
			for (String field: quoteLineFieldMapping.keySet()) {
				if (quoteLineFieldMapping.get(field).Source_Object__c == 'Apttus_Proposal__Proposal_Line_Item__c') {
					proposalLineFields.add(quoteLineFieldMapping.get(field).Token_Api__c); // field from the scource object
					cdLineMap.put(field, quoteLineFieldMapping.get(field));
				}
			}
			
			for (String field: agrLineFieldMapping.keySet()) {
				if (agrLineFieldMapping.get(field).Source_Object__c == 'Apttus__AgreementLineItem__c') {
					agrFields.add(agrLineFieldMapping.get(field).Token_Api__c); // field from the scource object
					cdLineMap.put(field, agrLineFieldMapping.get(field));
				}
			}
			
		   // System.debug('cdLineFields' + cdLineFields);
			
			
			
			List<Customer_Document_Line_Items__c> customerDocumentLines = QTO_CPOLineItemUtil.getCustomerDocumentLineItems(cdLineFields, cdDocIds);
			if(!customerDocumentLines.isEmpty()) {
				for (Customer_Document_Line_Items__c cdLine : customerDocumentLines) { 
					
					List<QTO_Customer_Document_Agreement_Line__c> cdlAGLList = new List<QTO_Customer_Document_Agreement_Line__c>();
					List<QTO_Customer_Document_Quote_Line__c>  cdlQTLList = new List<QTO_Customer_Document_Quote_Line__c>();
					allCdLines.add(cdline.Id);
					
					for (QTO_Customer_Document_Quote_Line__c cdlQL: cdLine.Customer_Document_Quote_Lines__r) {
						if(cdlQL != null) {
							cdlQTLList.add(cdlQL);
							quoteLinesSet.add(cdlQL.QTO_Proposal_Line_Item__c);
							quoteSet.add(cdlQL.QTO_Proposal_Line_Item__r.Apttus_Proposal__Proposal__c);
							//qlItemSequenceMap.put(cdlQL.QTO_Proposal_Line_Item__c, cdlQL.QTO_Proposal_Line_Item__r.Apttus_QPConfig__LineNumber__c);
						}
					}
					for (QTO_Customer_Document_Agreement_Line__c cdlAL: cdLine.Customer_Document_Agreement_Line_Items__r) {
						if(cdlAL !=null) {
							cdlAGLList.add(cdlAL);
							agrLinesSet.add(cdlAL.QTO_Agreement_Line_Item__c);
						}
					}
					if(!cdlQTLList.isEmpty())
						cdLQLIdMap.put(cdline.Id, cdlQTLList);
					
					if(!cdlAGLList.isEmpty())
						cdLALIdMap.put(cdline.Id, cdlAGLList);
				}
			}
			
			
			//Agreement Lines
			List<Apttus__AgreementLineItem__c> argLines = QTO_CPOLineItemUtil.getAgreementLineItems(agrFields, agrLinesSet);
			for (Apttus__AgreementLineItem__c agr: argLines) {
				agreementLinesMap.put(agr.Id, agr);
				if(!agr.AALI_Associations_to_Quote_LI__r.isEmpty()) {
					agreementToQLMap.put(agr.Id, agr.AALI_Associations_to_Quote_LI__r[0].Quote_Line_Item__c);
					agrQlQIds.add(agr.AALI_Associations_to_Quote_LI__r[0].Quote_Line_Item__r.Apttus_Proposal__Proposal__c);
				}
			}
			
			System.debug('CPO LINES ::  AL QL Quotes ...'+ agrQlQIds);
			
			//Set<Id> qlineIds = qlItemSequenceMap.KeySet();		
			//Set<Id> alTOQlSet = new Set<Id>(agreementToQLMap.values());
			
			Set<Id> finalQlList = new Set<Id>();
			//finalQlList.addall(qlItemSequenceMap.KeySet());
			finalQlList.addall(quoteLinesSet);
			finalQlList.addall(new Set<Id>(agreementToQLMap.values()));
			
			quoteSet.addall(agrQlQIds);
			
			//Proposal Line Items from CD To QL 
			Map<Id, Apttus_Proposal__Proposal_Line_Item__c> proposalIdMap = new Map<Id, Apttus_Proposal__Proposal_Line_Item__c>();
			List<Apttus_Proposal__Proposal_Line_Item__c> associatedProposalLines = QTO_CPOLineItemUtil.findAllCdAssociatedQuoteLines(proposalLineFields, finalQlList);
			for(Apttus_Proposal__Proposal_Line_Item__c proposalLine : associatedProposalLines) {
				proposalIdMap.put(proposalLine.Id, proposalLine);
			}
			
			//Find all the Proposal Line Items from Quotes
			List<Apttus_Proposal__Proposal_Line_Item__c> allProposalLines = QTO_CPOLineItemUtil.findAllQuoteLinesByQuoteIds(proposalLineFields, quoteSet);
			
			System.debug('CPO LINES :: quotePlLines :  ' + allProposalLines.size());
			
			List<Apttus_Config2__CustomerPOItem__c> cpoLineItems = new List<Apttus_Config2__CustomerPOItem__c>();
			
			// Get all customer facing attributes for cd, cd lines, quote, quote lines
			List<Customer_facing_Attribute__c> cFAList =
				[
					SELECT QTO_Customer_Document__c,Attribute_Label__c,  Attribute_Name__c, Attribute_Value__c, QTO_Customer_Document_Line_Items__c, Quote_Line_Item__c, Quote__c, CPO__c, CPO_item__c
					FROM Customer_facing_Attribute__c 
					WHERE QTO_Customer_Document__c IN:cdDocIds
					OR QTO_Customer_Document_Line_Items__c IN:allCdLines
					OR Quote_Line_Item__c IN: quoteLinesSet
					OR Quote__c IN:quoteSet
				];
			
			Map<Id, List<Customer_facing_Attribute__c>> cdDocCfa = new Map<Id, List<Customer_facing_Attribute__c>>();
			Map<Id, List<Customer_facing_Attribute__c>> cdDocLineCfa = new Map<Id, List<Customer_facing_Attribute__c>>();
			Map<Id, List<Customer_facing_Attribute__c>> cdDocQuoteCfa = new Map<Id, List<Customer_facing_Attribute__c>>();
			Map<Id, List<Customer_facing_Attribute__c>> cdDocQuoteLineCfa = new Map<Id, List<Customer_facing_Attribute__c>>();
			
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
		   
			
			//Main Logic
			for (Customer_Document_Line_Items__c cdLine : customerDocumentLines) {
				
				Apttus_Config2__CustomerPOItem__c poLineItem = QTO_CPOLineItemUtil.createCdLineMetaData(cdLine, cdocLineFieldMapping);
				
				//CD QL Start
				if(cdLQLIdMap.containsKey(cdLine.Id)) {
					
					List<QTO_Customer_Document_Quote_Line__c>  cdlQTLList  = cdLQLIdMap.get(cdLine.Id);
					
					for (QTO_Customer_Document_Quote_Line__c cdQl: cdlQTLList) {
						
						if(proposalIdMap.containsKey(cdQl.QTO_Proposal_Line_Item__c)) {
							
							//GrandParent/Parent Proposal lines
							Apttus_Proposal__Proposal_Line_Item__c proposalLine = proposalIdMap.get(cdQl.QTO_Proposal_Line_Item__c);
							Apttus_Config2__CustomerPOItem__c clonedPoItem = poLineItem.clone(true, true);
							clonedPoItem = QTO_CPOLineItemUtil.createProposalLineMetaData(proposalLine, cdLineMap, clonedPoItem);
							clonedPoItem.put('QTO_POI_CDLI_Quote_Line__c', cdQl.Id);
							clonedPoItem.put('Apttus_QPConfig__ProposalId__c', proposalLine.Apttus_Proposal__Proposal__c); 
							clonedPoItem.put('Apttus_Config2__PurchaseOrderId__c', cpoList[0].Id);
							cpoLineItems.add(clonedPoItem) ;
							
							
							//Parent/Child Proposal Lines
							for(Apttus_Proposal__Proposal_Line_Item__c parentProposalLine :  allProposalLines) {
								
								if((proposalLine.Apttus_QPConfig__PrimaryLineNumber__c  == parentProposalLine.Apttus_QPConfig__ParentBundleNumber__c
									&& proposalLine.Apttus_Proposal__Proposal__r.Id  ==  parentProposalLine.Apttus_Proposal__Proposal__r.Id)
								   && proposalLine.Id != parentProposalLine.Id) {
									   
									   Apttus_Config2__CustomerPOItem__c parentCPOItem = poLineItem.clone(true, true);
									   parentCPOItem = QTO_CPOLineItemUtil.createProposalLineMetaData(parentProposalLine, quoteLineFieldMapping, parentCPOItem);			
									   parentCPOItem.put('QTO_POI_CDLI_Quote_Line__c', cdQl.Id);
									   parentCPOItem.put('Apttus_Config2__PurchaseOrderId__c', cpoList[0].Id);
									   parentCPOItem.put('Apttus_QPConfig__ProposalId__c', parentProposalLine.Apttus_Proposal__Proposal__c); 
									   parentCPOItem.put('Line_Type__c', parentProposalLine.Apttus_QPConfig__LineType__c);
									   cpoLineItems.add(parentCPOItem) ; 
									   
									   
									   //Child Records
									   for(Apttus_Proposal__Proposal_Line_Item__c childProposalLine :  allProposalLines) {
										   
										   if((parentProposalLine.Apttus_QPConfig__PrimaryLineNumber__c  == childProposalLine.Apttus_QPConfig__ParentBundleNumber__c
											   && parentProposalLine.Apttus_Proposal__Proposal__r.Id  ==  childProposalLine.Apttus_Proposal__Proposal__r.Id)
											  && parentProposalLine.Id != childProposalLine.Id) {
												  
												  Apttus_Config2__CustomerPOItem__c childCPOItem = poLineItem.clone(true, true);
												  childCPOItem = QTO_CPOLineItemUtil.createProposalLineMetaData(childProposalLine, quoteLineFieldMapping, childCPOItem);			
												  childCPOItem.put('QTO_POI_CDLI_Quote_Line__c', cdQl.Id);
												  childCPOItem.put('Apttus_Config2__PurchaseOrderId__c', cpoList[0].Id);
												  childCPOItem.put('Apttus_QPConfig__ProposalId__c', childProposalLine.Apttus_Proposal__Proposal__c); 
												  childCPOItem.put('Line_Type__c', childProposalLine.Apttus_QPConfig__LineType__c);
												  cpoLineItems.add(childCPOItem) ; 
											  }
									   }
								   }
							}
						}  
					}	
				}
				//CD QL  END
				
				
				//Agreement Lines
				//CD AL START
				if(cdLALIdMap.containsKey(cdLine.Id)) {
					List<QTO_Customer_Document_Agreement_Line__c>  cdlALLList  = cdLALIdMap.get(cdLine.Id);
					for (QTO_Customer_Document_Agreement_Line__c cdAl: cdlALLList) {
						if(agreementLinesMap.containsKey(cdAl.QTO_Agreement_Line_Item__c)) {
							Apttus__AgreementLineItem__c agrLineRec = agreementLinesMap.get(cdAl.QTO_Agreement_Line_Item__c);
							Apttus_Config2__CustomerPOItem__c clonedAgrPoItem = poLineItem.clone(true, true); 
							System.debug('CPO LINES ::  agrLineRec::::' + agrLineRec);
							for (String fieldApi : agrLineFieldMapping.keySet()) {
								CPO_Enrichment_Line_Field_Mapping__mdt cpoMapping = agrLineFieldMapping.get(fieldApi);							   
								if (cpoMapping.Source_Object__c == 'Apttus__AgreementLineItem__c') {
									Boolean isNull = checkIsNull(agrLineRec.get(cpoMapping.Token_API__c));								   
									if (!isNull) {
										clonedAgrPoItem.put(cpoMapping.MasterLabel, agrLineRec.get(cpoMapping.Token_Api__c));
									}
								}
							}
							
							clonedAgrPoItem.put('Apttus_Config2__PurchaseOrderId__c', cpoList[0].Id);
							clonedAgrPoItem.put('Apttus_CMConfig__AgreementId__c', agrLineRec.Apttus__AgreementId__c);
							clonedAgrPoItem.put('Apttus_CMConfig__AgreementLineItemId__c', agrLineRec.Id);
							clonedAgrPoItem.put('QTO_POI_CDLI_Agreement_Line__c', cdAl.Id);
							//cpoLineItems.add(clonedAgrPoItem) ; 
							
							 
							//AL - QL
							if(agreementToQLMap.containsKey(cdAl.QTO_Agreement_Line_Item__c)) {
								//System.debug('ALQL : agreementToQLMap ......'+agreementToQLMap.get(cdAl.QTO_Agreement_Line_Item__c));
								Apttus__AgreementLineItem__c agrLineRec1 = agreementLinesMap.get(cdAl.QTO_Agreement_Line_Item__c);
								if(proposalIdMap.containsKey(agreementToQLMap.get(cdAl.QTO_Agreement_Line_Item__c))) {
									//System.debug('ALQL : productQLMap::::' + productQLMap.get(agreementToQLMap.get(cdAl.QTO_Agreement_Line_Item__c)));
									
									//GrandParent/Parent Proposal lines
									Apttus_Proposal__Proposal_Line_Item__c alQLproposalLine = proposalIdMap.get(agreementToQLMap.get(cdAl.QTO_Agreement_Line_Item__c));
									Apttus_Config2__CustomerPOItem__c clonedALQLPoItem = clonedAgrPoItem.clone(true, true);
								 
									clonedALQLPoItem = QTO_CPOLineItemUtil.createProposalLineMetaData(alQLproposalLine, cdLineMap, clonedALQLPoItem);
									clonedALQLPoItem.put('Apttus_QPConfig__ProposalId__c', alQLproposalLine.Apttus_Proposal__Proposal__c); 
									clonedALQLPoItem.put('Apttus_Config2__PurchaseOrderId__c', cpoList[0].Id);
									cpoLineItems.add(clonedALQLPoItem) ;
									
								   
									//Parent/Child Proposal Lines
									for(Apttus_Proposal__Proposal_Line_Item__c parentProposalLine :  allProposalLines) {
										
										if((alQLproposalLine.Apttus_QPConfig__PrimaryLineNumber__c  == parentProposalLine.Apttus_QPConfig__ParentBundleNumber__c
											&& alQLproposalLine.Apttus_Proposal__Proposal__r.Id  ==  parentProposalLine.Apttus_Proposal__Proposal__r.Id)
										   && alQLproposalLine.Id != parentProposalLine.Id) {
											   
											   Apttus_Config2__CustomerPOItem__c parentCPOItem = clonedAgrPoItem.clone(true, true);
											   parentCPOItem = QTO_CPOLineItemUtil.createProposalLineMetaData(parentProposalLine, quoteLineFieldMapping, parentCPOItem);			
											   parentCPOItem.put('Apttus_QPConfig__ProposalId__c', parentProposalLine.Apttus_Proposal__Proposal__c); 
											   parentCPOItem.put('Apttus_Config2__PurchaseOrderId__c', cpoList[0].Id);
											   parentCPOItem.put('Line_Type__c', parentProposalLine.Apttus_QPConfig__LineType__c);
											   cpoLineItems.add(parentCPOItem) ;
									
											   
											   //Child Records
											   for(Apttus_Proposal__Proposal_Line_Item__c childProposalLine :  allProposalLines) {
												   if((parentProposalLine.Apttus_QPConfig__PrimaryLineNumber__c  == childProposalLine.Apttus_QPConfig__ParentBundleNumber__c
													   && parentProposalLine.Apttus_Proposal__Proposal__r.Id  ==  childProposalLine.Apttus_Proposal__Proposal__r.Id)
													  && parentProposalLine.Id != childProposalLine.Id) {
														  
														  Apttus_Config2__CustomerPOItem__c childCPOItem = clonedALQLPoItem.clone(true, true);
														  childCPOItem = QTO_CPOLineItemUtil.createProposalLineMetaData(childProposalLine, quoteLineFieldMapping, childCPOItem);			
														  childCPOItem.put('Apttus_QPConfig__ProposalId__c', childProposalLine.Apttus_Proposal__Proposal__c); 
														  childCPOItem.put('Apttus_Config2__PurchaseOrderId__c', cpoList[0].Id);
														  childCPOItem.put('Line_Type__c', childProposalLine.Apttus_QPConfig__LineType__c);
														  cpoLineItems.add(childCPOItem) ;
													  }
											   }
										   }
									}
								}
							}
						}
					}
				}
				//CD AL END
				if(!cdLQLIdMap.containsKey(cdLine.Id) && !cdLALIdMap.containsKey(cdLine.Id)) {
					//System.debug('CPO : cdLine..... NO CD LINE ASSOCIATE');
					poLineItem.put('Apttus_Config2__PurchaseOrderId__c', cpoList[0].Id);
					cpoLineItems.add(poLineItem) ; 
				}
			}
			
			System.debug('cpoLineItems....'+cpoLineItems.size());
			
			if(!Test.isRunningTest()) {
				insert cpoLineItems;
			}
			
			purchaseOrdersToUpdate.add(new Apttus_Config2__CustomerPurchaseOrder__c(
				Id =  cpoList[0].Id,
				Apttus_Config2__Status__c = 'Commercially Enriched'
			));
			
			customerDocumentsToUpdate.add(new Customer_Document__c(
				Id = cpoToCd.values()[0],
				Status__c = QTO_Constants.CD_STATUS_LEGACY
			));

		
		
			 
			
			
			Map<Id, Customer_facing_Attribute__c> cfaheader = new Map<Id, Customer_facing_Attribute__c>();
			Map<Id, Customer_facing_Attribute__c> cfaToUpdate = new Map<Id, Customer_facing_Attribute__c>();
			
			//Header CFA's 
			if (cpoList[0].Nokia_Customer_Document_ID__c != null) { 
				if(cdDocCfa.get(cpoList[0].Nokia_Customer_Document_ID__c) != null) { 
					for (Customer_facing_Attribute__c c: cdDocCfa.get(cpoList[0].Nokia_Customer_Document_ID__c)) {
						Customer_facing_Attribute__c cfaToU = cfaheader.containsKey(c.Id) ? cfaheader.get(c.Id) : c;
						cfaToU.CPO__c = cpoList[0].Id;  
						cfaToU.QTO_Customer_Document__c = cpoList[0].Nokia_Customer_Document_ID__c; 
						cfaheader.put(cfaToU.Id, cfaToU);
					}
				}	
			}
			
			//Line Item CFA's
			for (Apttus_Config2__CustomerPOItem__c poi: cpoLineItems) {
				
				if ((poi.QTO_POI_Customer_Document_Line_Item__c != null && poi.Line_Type__c=='Product/Service')  
					&& (cdDocLineCfa.get(poi.QTO_POI_Customer_Document_Line_Item__c) != null)) {
					for (Customer_facing_Attribute__c c : cdDocLineCfa.get(poi.QTO_POI_Customer_Document_Line_Item__c)) {
						Customer_facing_Attribute__c cfaToU = cfaToUpdate.containsKey(c.Id)? cfaToUpdate.get(c.Id): c;
						cfaToU.CPO_item__c = poi.Id;						  
						cfaToUpdate.put(cfaToU.Id, cfaToU);
					}
				}
					
				
				if ((poi.Apttus_QPConfig__ProposalLineItemId__c != null && poi.Line_Type__c=='Product/Service') 
					&& (cdDocQuoteLineCfa.get(poi.Apttus_QPConfig__ProposalLineItemId__c) != null)) {
						for (Customer_facing_Attribute__c c: cdDocQuoteLineCfa.get(poi.Apttus_QPConfig__ProposalLineItemId__c)) {
							Customer_facing_Attribute__c cfaToU = cfaToUpdate.containsKey(c.Id) ? cfaToUpdate.get(c.Id): c;
							cfaToU.Quote_Line_Item__c = poi.Apttus_QPConfig__ProposalLineItemId__c; 
							cfaToU.CPO_item__c = poi.Id;	
							cfaToUpdate.put(cfaToU.Id, cfaToU);
						}
					}
				
			}
			
			update cfaheader.values();
			update cfaToUpdate.values();
			
			
			if(purchaseOrdersToUpdate.size() > 0)	
				update purchaseOrdersToUpdate;
			if(customerDocumentsToUpdate.size() > 0)
				update customerDocumentsToUpdate;
		   
			
			
			
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
	private static Map<String, CPO_Enrichment_Line_Field_Mapping__mdt> getFieldMappingMetaData(String objectName) {
		Map<String, CPO_Enrichment_Line_Field_Mapping__mdt> fieldMapping = new Map<String, CPO_Enrichment_Line_Field_Mapping__mdt>();
		for (CPO_Enrichment_Line_Field_Mapping__mdt metadata :[
			SELECT Id, MasterLabel, QualifiedApiName, POI_Field_Api__c, Source_Object__c, Token_API__c
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