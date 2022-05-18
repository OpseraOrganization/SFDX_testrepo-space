/*********************************************************************
* Class Name : QTO_CreateROController
* Test Class : QTO_CreateROControllerTest
* Created Date: 14 Dec 2020
* Created By : Shaik, Johny Basha
* Description : This class is used to create Riskorder PO  from quote and quotelines 
* Description : DSI-2155 
*******************************************************************/
public with sharing class QTO_CreateROController {
	
	@AuraEnabled
	public static Boolean retriveStatus(Id quoteId) {
		Apttus_Proposal__Proposal__c proposal = [
			SELECT Apttus_Proposal__Approval_Stage__c 
			FROM Apttus_Proposal__Proposal__c
			WHERE Id=: quoteId];
		
		Boolean isApproved = proposal.Apttus_Proposal__Approval_Stage__c == 'Approved' ? true : false;
		return isApproved;
	}
	
	@AuraEnabled
	public static Id createRO(String roNumber, Id quoteId) {	   
		List<Customer_facing_Attribute__c> cfaList = new List<Customer_facing_Attribute__c>();		
		List<Apttus_Proposal__Proposal__c> quoteRecs = [
			SELECT Sold_To_Party__r.Name, Quote_Total__c, Name,QTO_Risk_Order_Number__c,
			CurrencyIsoCode, Agreement_Lookup__r.Nokia_Legal_Entity_lookup__c,Agreement_Lookup__r.Nokia_Legal_Entity_lookup__r.Name,
			Agreement_Lookup__c,Agreement_Name__c,Agreement_Lookup__r.Nokia_Legal_Entity_lookup__r.BillingPostalCode,
			Agreement_Lookup__r.Inco_Term_Description__c,Agreement_Lookup__r.Apttus_CMConfig__PaymentTermId__r.Name,
			Apttus_Proposal__Account__r.Name, Apttus_Proposal__Account__r.BillingAddress
			FROM Apttus_Proposal__Proposal__c 
			WHERE Id =:quoteId];
		// DSI - 2315, get Site Name and Site Code cfa
		Map<Id, Map<String,String>> quoteSiteCfaValuesByAttributeName = getSiteCfaValuesByName(quoteId);
		Map<String, Map<String, String>> pdfFieldValueMappingsByType =
			getPDFFieldValueMappingsByType(
				quoteRecs.get(0)?.Sold_To_Party__r.Name,
				new List<String>{
					quoteRecs.get(0)?.Agreement_Lookup__r.Inco_Term_Description__c, 
						quoteRecs.get(0)?.Agreement_Lookup__r.Apttus_CMConfig__PaymentTermId__r.Name
						}
			);
		
		List<Apttus_Proposal__Proposal_Line_Item__c> lines = [
				SELECT External_Reference__c,External_Description__c,Apttus_Proposal__Product__r.ProductCode,
					Apttus_Proposal__Product__c,Apttus_Proposal__Product__r.Name,Apttus_QPConfig__LineNumber__c,
					Apttus_QPConfig__Quantity2__c,Apttus_Proposal__Product__r.Apttus_Config2__Uom__c,
					Apttus_QPConfig__NetUnitPrice__c,
					Apttus_QPConfig__NetPrice__c, Name, Apttus_QPConfig__PriceListId__r.Name,
					Apttus_Proposal__Quantity__c
				FROM Apttus_Proposal__Proposal_Line_Item__c 
				WHERE Apttus_Proposal__Proposal__c =: quoteId AND Apttus_QPConfig__LineType__c = 'Product/Service'];
		
		if (!quoteRecs.isEmpty()) {
			Apttus_Proposal__Proposal__c qRec = quoteRecs[0];
			Customer_Document__c cd = new Customer_Document__c();
			cd.Customer_Document_ID__c = roNumber + '.' + qRec.Name;
			cd.QTO_Customer_Document_Date__c = String.valueof(System.today());
			cd.QTO_PDF_Customer_Name__c = qrec.Sold_To_Party__r.Name;
			cd.Comment__c='RISK ORDER';
			cd.QTO_PDF_Total_Value__c = String.valueof(qrec.Quote_Total__c.setScale(2)); // .substring(0,18);
			cd.QTO_Currency__c = qRec.CurrencyIsoCode;
			cd.QTO_Classification__c = 'In-House Order';
			cd.QTO_Sub_Classification__c = 'Risk-Order';
			cd.QTO_PDF_Nature__c = 'Create';
			cd.QTO_Nokia_Legal_Entity_Account__c = qRec.Agreement_Lookup__r.Nokia_Legal_Entity_lookup__r.Name;	
			cd.QTO_Nokia_Legal_Entity_Postal_Code__c = qRec.Agreement_Lookup__r.Nokia_Legal_Entity_lookup__r.BillingPostalCode; // 07-09-2021 bug fix on risk order
			cd.QTO_Nokia_Legal_Entity_Info__c = qRec.Agreement_Lookup__r.Nokia_Legal_Entity_lookup__r.Name; // 07-09-2021 bug fix on risk order
			cd.QTO_INCO_Terms__c = pdfFieldValueMappingsByType.containsKey('Inco Terms') &&
				pdfFieldValueMappingsByType.get('Inco Terms').containsKey(qRec.Agreement_Lookup__r.Inco_Term_Description__c) ?
				pdfFieldValueMappingsByType.get('Inco Terms').get(qRec.Agreement_Lookup__r.Inco_Term_Description__c) :
				qRec.Agreement_Lookup__r.Inco_Term_Description__c; // 09-09-2021 new requirement on risk order
			cd.QTO_Payment_Terms__c = pdfFieldValueMappingsByType.containsKey('Payment Terms') &&
				pdfFieldValueMappingsByType.get('Payment Terms').containsKey(qRec.Agreement_Lookup__r.Apttus_CMConfig__PaymentTermId__r.Name) ?
				pdfFieldValueMappingsByType.get('Payment Terms').get(qRec.Agreement_Lookup__r.Apttus_CMConfig__PaymentTermId__r.Name) :
				qRec.Agreement_Lookup__r.Apttus_CMConfig__PaymentTermId__r.Name; // 09-09-2021 new requirement on risk order
			
			Address addr = qRec.Apttus_Proposal__Account__r.BillingAddress;
			cd.QTO_Customer_Postal_Code__c = addr.getPostalCode();
			
			insert cd;
			
			qRec.QTO_Risk_Order_Number__c = roNumber;			
			// update qrec;

			Customer_facing_Attribute__c cdCfa = new Customer_facing_Attribute__c();
			cdCfa.Attribute_Indicator__c = 'Header';
			cdCfa.Attribute_Label__c = 'PDF QUOTE REF';
			cdCfa.Attribute_Value__c = quoteRecs[0].Name; // DSI - 2315
			cdCfa.QTO_Customer_Document__c = cd.Id;
			
			cfaList.add(cdCfa);
			// DSI - 2315, if quote has a link to an agreement, need to create PDF CONTRACT REF cfa
			if (qRec.Agreement_Lookup__c <> null) { cfaList.add(createContractRefCFA(cd.Id, qRec.Agreement_Name__c)); }
			
			if (!lines.isEmpty()) {
				List<Customer_Document_Line_Items__c> cdLines = new List<Customer_Document_Line_Items__c>();				
				for (Apttus_Proposal__Proposal_Line_Item__c line: lines) {
					Customer_Document_Line_Items__c cdLine = new Customer_Document_Line_Items__c();
					
					cdLine.High_level_Product__c = line.External_Reference__c;
					cdLine.High_level_Product_Description__c = line.External_Description__c; // DSI - 2315, line.External_Description__c, pdf customer product description
					cdLine.Detailed_Product__c  = line.Apttus_Proposal__Product__r.ProductCode;
					cdLine.Detailed_Product_Description__c   = line.Apttus_Proposal__Product__r.Name; // DSI - 2315, line.Apttus_Proposal__Product__c, same as Id
					cdLine.PDF_Line_Item__c = String.valueOf(line.Apttus_QPConfig__LineNumber__c);
					cdLine.QTO_PDF_Quantity__c = String.valueOf(
						line.Apttus_QPConfig__Quantity2__c - (line.Apttus_Proposal__Quantity__c <> null ? line.Apttus_Proposal__Quantity__c : 0)
					); // 09-09-2021 new requirement on risk order
					cdLine.QTO_PDF_Unit_Of_Measure__c = line.Apttus_Proposal__Product__r.Apttus_Config2__Uom__c;
					cdLine.QTO_PDF_Unit_Price__c = String.valueOf(line.Apttus_QPConfig__NetUnitPrice__c.setScale(2));
					cdLine.QTO_PDF_Currency_Code__c = qRec.CurrencyIsoCode;
					cdLine.CurrencyIsoCode = qRec.CurrencyIsoCode; // DSI - 2315
					cdLine.QTO_PDF_Total_Value__c = String.valueOf(line.Apttus_QPConfig__NetPrice__c.setScale(2));
					cdLine.Customer_Document__c = cd.id;
					cdLine.QTO_Customer_Grouping__c = line.Apttus_QPConfig__PriceListId__r.Name;
					
					cdLines.add(cdLine);
				}				
			   insert cdLines;
				
				Integer i=0;
				for (Customer_Document_Line_Items__c cdli: cdLines) {
					Customer_facing_Attribute__c cdCfa1 = new Customer_facing_Attribute__c();
					cdCfa1.Attribute_Indicator__c = 'Item';
					cdCfa1.Attribute_Label__c = 'ANTICIPATION REF';
					cdCfa1.Attribute_Value__c = roNumber + '.' + lines[i].Name;
					cdCfa1.QTO_Customer_Document_Line_Items__c = cdli.Id;
					cdCfa1.Quote_Line_Item__c = lines[i].Id;					
					cfaList.add(cdCfa1);
					// DSI - 2315, get the pdf site name and code from quote cfa
					if(quoteSiteCfaValuesByAttributeName.containsKey(lines[i].Id) &&
					   quoteSiteCfaValuesByAttributeName.get(lines[i].Id).containsKey('Site Code')) {					
						Customer_facing_Attribute__c cdCfa2 = new Customer_facing_Attribute__c();
						cdCfa2.Attribute_Indicator__c = 'Item';
						cdCfa2.Attribute_Label__c = 'PDF SITE CODE';
						cdCfa2.Attribute_Value__c = quoteSiteCfaValuesByAttributeName.get(lines[i].Id).get('Site Code');
						cdCfa2.QTO_Customer_Document_Line_Items__c = cdli.Id;						
						cfaList.add(cdCfa2);
					}
					
					if(quoteSiteCfaValuesByAttributeName.containsKey(lines[i].Id) &&
					   quoteSiteCfaValuesByAttributeName.get(lines[i].Id).containsKey('Site Name')) {					
						Customer_facing_Attribute__c cdCfa3 = new Customer_facing_Attribute__c();
						cdCfa3.Attribute_Indicator__c = 'Item';
						cdCfa3.Attribute_Label__c = 'PDF SITE NAME';
						cdCfa3.Attribute_Value__c = quoteSiteCfaValuesByAttributeName.get(lines[i].Id).get('Site Name');
						cdCfa3.QTO_Customer_Document_Line_Items__c = cdli.Id;						
						cfaList.add(cdCfa3);				   
					}
					i++;
				}
			}			
			insert cfaList;			
			return cd.Id;
		}		
		return null;
	}

	private static Customer_facing_Attribute__c createContractRefCFA(Id customerDocumentId, String agreementName) {
		return new Customer_facing_Attribute__c(
			Attribute_Indicator__c = 'Header',
			Attribute_Label__c = 'PDF CONTRACT REF',
			Attribute_Value__c = agreementName,
			QTO_Customer_Document__c = customerDocumentId
		);
	}

	private static Map<Id, Map<String,String>> getSiteCfaValuesByName(Id quoteId) {
		Map<Id, Map<String,String>> quoteSiteCfaValueByAttributeName = new Map<Id, Map<String,String>>();
		for (Customer_facing_Attribute__c quoteSiteCfas : 
		[SELECT Attribute_Value__c,Attribute_Label__c,Attribute_Name__c,Quote_Line_Item__c 
		FROM Customer_facing_Attribute__c
		WHERE Quote__c = :quoteId 
		AND Attribute_Name__c IN ('Site Name','Site Code','Site code','Site name','site name','site code')]) {
			if(quoteSiteCfas.Attribute_Name__c == 'Site Name'){
				quoteSiteCfaValueByAttributeName.put(
					quoteSiteCfas.Quote_Line_Item__c,
					new Map<String, String>{ 'Site Name' => quoteSiteCfas.Attribute_Value__c }
				);				
			}
			if(quoteSiteCfas.Attribute_Name__c == 'Site Code'){
				quoteSiteCfaValueByAttributeName.put(
					quoteSiteCfas.Quote_Line_Item__c,
					new Map<String, String>{ 'Site Code' => quoteSiteCfas.Attribute_Value__c }
				); 
			}
		}
		return quoteSiteCfaValueByAttributeName;
	}
	
	@TestVisible
	private static Map<String, Map<String, String>> getPDFFieldValueMappingsByType(
		String customerName, List<String> values
	) {		
		Map<String, Map<String, String>> pdfFieldValueMappingsByType = new Map<String, Map<String, String>>();
		if (String.isNotBlank(customerName) && !values.isEmpty()) {
			for (QTO_CPO_Field_Mapping__c mapping :
				 [SELECT Type__c, PDF_Value__c, Mapping__c
				  FROM QTO_CPO_Field_Mapping__c
				  WHERE Customer_Name__c = :customerName
				  AND Type__c IN ('Inco Terms','Payment Terms')
				  AND Mapping__c IN :values]
				) {
					if (pdfFieldValueMappingsByType.containsKey(mapping.Type__c)) {
						pdfFieldValueMappingsByType.get(mapping.Type__c).put(mapping.Mapping__c, mapping.PDF_Value__c);
					} else {
						pdfFieldValueMappingsByType.put(mapping.Type__c, new Map<String, String>{mapping.Mapping__c => mapping.PDF_Value__c});   
					}
				}
		}
		return pdfFieldValueMappingsByType;
	}
}