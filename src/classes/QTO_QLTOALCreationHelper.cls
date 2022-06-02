/*********************************************************************
* Class Name  : QTO_QLTOALCreationHelper
* Test Class  : QTO_QLTOALCreationHelperTest
* Created Date: 02 Nov 2021
* Created By  : Shaik, Johny
* Description : This class is for creating Agreement Lines from QuoteLines
* Description : DSI-2166
*******************************************************************/

public with sharing class QTO_QLTOALCreationHelper {
	
	static Set<Id> updatedQuotes = new Set<Id>();
	static List<Apttus_Proposal__Proposal__c> acceptedQuotes = new List<Apttus_Proposal__Proposal__c>();
	static List<Customer_Document_Junction__c> quoteCdAsso = new List<Customer_Document_Junction__c>();
	
	/**
* createAgreementLines
*/ 
	public static void createAgreementLines(Id agreementId, Id quoteId, Id cusDocId) {
		System.debug('QTO_QLTOALCreationHelper : createAgreementLines >> '+agreementId +': '+quoteId);
		List<Apttus__AgreementLineItem__c> agrLines = new List<Apttus__AgreementLineItem__c> ();
		List<QTO_AALI_Associations_to_Quote_LI__c> qlAlJunctionList = new List<QTO_AALI_Associations_to_Quote_LI__c> ();
		Customer_Document__c customerDocument = [Select Id,Status__c from Customer_Document__c WHERE Id=: cusDocId];
		try {
			if(!String.isBlank(agreementId) && !String.isBlank(quoteId)) {
				Apttus__APTS_Agreement__c agreement = findAgreementById(agreementId);
				List<Apttus_Proposal__Proposal_Line_Item__c> quoteLines = findAllQuoteLinesById(quoteId);
				
				
				//System.debug('agreement-----'+agreement);
				//System.debug('quoteLines-----'+quoteLines.size());
				if(agreement != null && !quoteLines.isEmpty()) {
					updatedQuotes.add(quoteLines[0].Apttus_Proposal__Proposal__c);
					List<Apttus_Proposal__Proposal__c> quoteList = findAllQuotesById(updatedQuotes);
					
					for(Apttus_Proposal__Proposal_Line_Item__c qlLine : quoteLines) {
						if(qlLine.External_Reference__c!=null) {
							//System.debug('Line creation...');
							Apttus__AgreementLineItem__c agrLine = new Apttus__AgreementLineItem__c();
							agrLine.Apttus__AgreementId__c = agreement.Id;
							agrLine.Apttus__Description__c = qlLine.External_Description__c;
							agrLine.Apttus__NetPrice__c = qlLine.Apttus_QPConfig__NetPrice__c;
							agrLine.Apttus_CMConfig__NetUnitPrice__c= qlLine.Apttus_QPConfig__NetUnitPrice__c;
							//agrLine.Product_Code__c = qlLine.Product_Code__c;
							agrLine.Apttus__ProductId__c= qlLine.Apttus_Proposal__Product__c;
							agrLine.Apttus__Quantity__c = qlLine.Apttus_QPConfig__Quantity2__c;
							agrLine.Apttus_CMConfig__LineType__c = qlLine.Apttus_QPConfig__LineType__c;
							agrLine.Apttus_CMConfig__ItemSequence__c = qlLine.Apttus_QPConfig__ItemSequence__c;
							agrLine.Apttus_CMConfig__LineNumber__c = qlLine.Apttus_QPConfig__LineNumber__c;
							agrLine.CLM_CFE_Reference__c = qlLine.External_Reference__c;
							agrLine.Contract_Item_Number__c =qlLine.External_Reference__c;
							agrLine.CurrencyIsoCode = qlLine.Apttus_Proposal__Proposal__r.CurrencyIsoCode;
							agrLines.add(agrLine);	
						}
					}
					System.debug('agrLines >> '+agrLines.size());
					if(agrLines.size()>0) {
						Insert agrLines;
						System.debug('agrLines >> Success');
					}
					
					Integer i = 0;
					for(Apttus_Proposal__Proposal_Line_Item__c qlLine : quoteLines) {
						if(qlLine.External_Reference__c!=null) {
							QTO_AALI_Associations_to_Quote_LI__c qlAlJunction = new QTO_AALI_Associations_to_Quote_LI__c(); 
							qlAlJunction.Agreement_Line_Item__c = agrLines[i].Id;
							qlAlJunction.Quote_Line_Item__c = qlLine.Id;
							qlAlJunctionList.add(qlAlJunction);
							i++;
						}
					}
					System.debug('agrLines >> '+qlAlJunctionList.size());
					if(qlAlJunctionList.size()>0) {
						Insert qlAlJunctionList;
						System.debug('qlAlJunctionList >> Success');
					}
					
					for(Apttus_Proposal__Proposal__c quote : quoteList) {
						quote.Apttus_Proposal__Approval_Stage__c = 'Accepted';
						acceptedQuotes.add(quote);
						
						Customer_Document_Junction__c cdQuoteAssociation = new Customer_Document_Junction__c();
						cdQuoteAssociation.Quote_Proposal__c = quoteId;
						cdQuoteAssociation.Customer_Document__c = cusDocId;
						quoteCdAsso.add(cdQuoteAssociation);	 
					}
					
					if(!quoteCdAsso.isEmpty()) {		
						insert quoteCdAsso;			   
					} 
					
					if(!acceptedQuotes.isEmpty()) {
						update acceptedQuotes;
					}
					
					if(customerDocument !=null){
						customerDocument.Status__c = QTO_Constants.CLOSED_VALIDATED;
						update customerDocument;
					}
					System.debug('AL has been created successfully...!'); 
				}
			}	
		}
		catch(Exception e) {
			System.debug('Exception Inserting the AL Items' + e.getStackTraceString());
		}
	}
	
	private static List<Apttus_Proposal__Proposal__c> findAllQuotesById(Set<Id> quoteIds) {
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
	
	
	
	private static Apttus__APTS_Agreement__c findAgreementById(Id agreementId){
		Apttus__APTS_Agreement__c agreement = 
			[
				Select Id, Apttus_CMConfig__PriceListId__c, Apttus__Account__c, Agreement_External_Contract_Number__c,Name,
				Apttus__FF_Agreement_Number__c, Nokia_Legal_Entity_lookup__c
				from Apttus__APTS_Agreement__c where  Apttus__Status__c = 'Activated' AND Apttus__Status_Category__c ='In Effect'
				AND Id =:agreementId
			];
		return agreement;
	}
	
	private static List<Apttus_Proposal__Proposal_Line_Item__c> findAllQuoteLinesById(id quoteId) {
		
		List<Apttus_Proposal__Proposal_Line_Item__c> quoteLines =
			[
				Select Id, External_Reference__c, External_Description__c, Apttus_QPConfig__NetPrice__c, Apttus_QPConfig__NetUnitPrice__c, 
				Name, Apttus_QPConfig__LineType__c, Apttus_QPConfig__ItemSequence__c, Apttus_QPConfig__LineNumber__c,
				NokiaCPQ_Product_Name__c,Apttus_QPConfig__PriceListItemId__c, Apttus_Proposal__Proposal__c, Apttus_QPConfig__PriceListItemId__r.DS_Grouping_Name__c,
				Apttus_Proposal__Proposal__r.Name, Apttus_Proposal__Proposal__r.NokiaCPQ_Proposal_Id__c, Apttus_Proposal__Proposal__r.Id,
				Apttus_Proposal__Product__c,DS_Grouping_Name__c,Product_Code__c, Apttus_Proposal__Product__r.ProductCode,
				Apttus_Proposal__Quantity__c, Apttus_QPConfig__Quantity2__c, QTO_QLI_Matched_Risk_Quantity__c,
				Apttus_QPConfig__Uom__c, Apttus_Proposal__Proposal__r.CurrencyIsoCode, QTO_QL_Available_Quantity__c  
				FROM Apttus_Proposal__Proposal_Line_Item__c
				WHERE Apttus_Proposal__Proposal__r.Id =: quoteId
				AND Apttus_Proposal__Proposal__r.Apttus_Proposal__Approval_Stage__c = 'Approved'
				//AND External_Reference__c <> NULL
				AND Apttus_QPConfig__LineType__c = 'Product/Service'
				ORDER BY  Apttus_Proposal__Proposal__r.CreatedDate
			];
		
		return quoteLines;
	}
	
	
	
}