/*********************************************************************
* Class Name  : QTO_CPOLineItemUtil
* Created Date: 07 Feb 2022
* Created By  : Shaik Johny Basha
* Description : Utility class for CPO Line Items
* Modified By : Shaik, Johny 
*******************************************************************/

public with sharing class QTO_CPOLineItemUtil {
	
	public static List<Customer_Document_Line_Items__c> getCustomerDocumentLineItems ( List<String> cdLineFields, List<Id> cdDocIds ) {
		try {
			String allFields = String.join(cdLineFields, ',');
			String cdLineQuery = 'SELECT name,' + allFields + ','
				+ '(SELECT QTO_Customer_Document_Line_Items__c, QTO_Proposal_Line_Item__c, QTO_Proposal_Line_Item__r.Apttus_Proposal__Proposal__c, QTO_Proposal_Line_Item__r.Apttus_QPConfig__ItemSequence__c, QTO_Proposal_Line_Item__r.Apttus_QPConfig__LineNumber__c FROM Customer_Document_Quote_Lines__r),'
				+ '(SELECT QTO_Agreement_Line_Item__c, QTO_Agreement_Line_Item__r.Apttus__AgreementId__c, QTO_Customer_Document_Line_Items__c FROM Customer_Document_Agreement_Line_Items__r)'
				+ '  FROM Customer_Document_Line_Items__c  WHERE Customer_Document__c IN: cdDocIds';
			
			return Database.query(cdLineQuery);
		}
		catch (Exception e){
			System.debug('*****Error when quering the Customer_Document_Line_Items__c: '+e.getMessage());
		}
		return new List<Customer_Document_Line_Items__c>();
	}
	
	
	public static List<Apttus_Proposal__Proposal_Line_Item__c> findAllCdAssociatedQuoteLines(List<String> proposalLineFields
																							 , Set<Id> finalQlList) {
		try {
			String proposalQuery = 	' SELECT ' + String.join(proposalLineFields, ',') +' , Apttus_Proposal__Proposal__r.Id, Apttus_QPConfig__ItemSequence__c, '
				+' Apttus_QPConfig__PrimaryLineNumber__c, Apttus_QPConfig__ParentBundleNumber__c '
				+' FROM Apttus_Proposal__Proposal_Line_Item__c  WHERE Id IN: finalQlList ';
			
			return Database.query(proposalQuery);
		}
		catch (Exception e){
			System.debug('*****Error when quering the Apttus_Proposal__Proposal_Line_Item__c: '+e.getMessage());
		}
		return new List<Apttus_Proposal__Proposal_Line_Item__c>();																						   
	}

	public static List<Apttus_Proposal__Proposal_Line_Item__c> findAllQuoteLinesByQuoteIds(List<String> proposalLineFields
																							 , Set<Id> quoteSet) {
		try {
			String plQueryByQuoteSet = ' SELECT ' + String.join(proposalLineFields, ',') +', Apttus_QPConfig__ItemSequence__c,'
				+' Apttus_QPConfig__PrimaryLineNumber__c, Apttus_QPConfig__ParentBundleNumber__c, Apttus_Proposal__Proposal__r.Id'
				+' FROM Apttus_Proposal__Proposal_Line_Item__c'
				+' WHERE Apttus_Proposal__Proposal__c IN: quoteSet';
			
			return Database.query(plQueryByQuoteSet);
		}
		catch (Exception e){
			System.debug('*****Error when quering the Apttus_Proposal__Proposal_Line_Item__c: '+e.getMessage());
		}
		return new List<Apttus_Proposal__Proposal_Line_Item__c>();																						   
	}
	
	public static List<Apttus__AgreementLineItem__c> getAgreementLineItems ( List<String> agrFields, Set<Id> agrLinesSet ) {
		try {
			String agrQuery = ' SELECT ' + String.join(agrFields, ',') +
				', (select Id, Agreement_Line_Item__c, Quote_Line_Item__c, Quote_Line_Item__r.Apttus_Proposal__Proposal__c from AALI_Associations_to_Quote_LI__r) '+
				' FROM Apttus__AgreementLineItem__c WHERE Id IN: agrLinesSet';
			return Database.query(agrQuery);
		}
		catch (Exception e){
			System.debug('*****Error when quering the Customer_Document_Line_Items__c: '+e.getMessage());
		}
		return new List<Apttus__AgreementLineItem__c>();
	}
	
	
	public static Apttus_Config2__CustomerPOItem__c createCdLineMetaData (Customer_Document_Line_Items__c cdLine , Map<String, CPO_Enrichment_Line_Field_Mapping__mdt> cdocLineFieldMapping ) {
		Apttus_Config2__CustomerPOItem__c poItem = new Apttus_Config2__CustomerPOItem__c();
		
		try {
			for (String fieldApi :cdocLineFieldMapping.keySet()) {
				CPO_Enrichment_Line_Field_Mapping__mdt cpoMapping = cdocLineFieldMapping.get(fieldApi);
				if (cpoMapping.Source_Object__c == 'Customer_Document_Line_Items__c') {
					Boolean isNull = checkIsNull(cdLine.get(cpoMapping.Token_API__c));						   
					if (!isNull) {
						poItem.put(!cpoMapping.MasterLabel.endsWith('__c') && cpoMapping.MasterLabel.length() >= 38 
								   ? cpoMapping.MasterLabel + '__c' : cpoMapping.MasterLabel, cdLine.get(cpoMapping.Token_Api__c)
								  );
					}	  
				}
			}
		}
		catch (Exception e){
			System.debug('*****Error when quering the Customer_Document_Line_Items__c: '+e.getMessage());
		}
		return poItem;
	}
	
	public static Apttus_Config2__CustomerPOItem__c createProposalLineMetaData (Apttus_Proposal__Proposal_Line_Item__c proposalLine , 
																				Map<String, CPO_Enrichment_Line_Field_Mapping__mdt> cpoEnrichmentFieldMapping,
																			   Apttus_Config2__CustomerPOItem__c clonedPoItem) {
		try {
			for (String fieldApi :cpoEnrichmentFieldMapping.keySet()) {
				CPO_Enrichment_Line_Field_Mapping__mdt cpoMapping = cpoEnrichmentFieldMapping.get(fieldApi);							   
				if (cpoMapping.Source_Object__c == 'Apttus_Proposal__Proposal_Line_Item__c') {
					Boolean isNull = checkIsNull(proposalLine.get(cpoMapping.Token_API__c));								   
					if (!isNull) {
						clonedPoItem.put(cpoMapping.MasterLabel, proposalLine.get(cpoMapping.Token_Api__c));
					}
				}
			}
		}
		catch (Exception e){
			System.debug('*****Error when quering the Customer_Document_Line_Items__c: '+e.getMessage());
		}
		return clonedPoItem;
	}
	
	
	
	
	public static Boolean checkIsNull(Object value) {
		if (value == null) {
			return true;
		} else {
			return false;
		}
	}
}