public with sharing class QTO_CDToCDComparisonController {
	@AuraEnabled(cacheable=true)
	public static CDDocuments retriveCdDocuments(Id cdAssociationId) {
		CD_Association_to_CD__c associationRec = [
				SELECT Id,
					Customer_Document__r.Name,
					Customer_Document__r.Id,
					Customer_Document__r.Customer_Document_ID__c,
					Customer_Document__r.Version_Nr__c,
					Customer_Document__r.Total_Value__c,
					Customer_Document__r.CurrencyIsoCode,
					Customer_Document__r.Payment_terms__c,
					Customer_Document__r.INCO_Terms__c,
					Customer_Document__r.QTO_PDF_Place_of_Delivery_Shipment__c,
					Customer_Document__r.Requested_Delivery_Date__c,
					QTO_Nokia_Customer_Document_ID__r.Name,
					QTO_Nokia_Customer_Document_ID__r.Id,
					QTO_Nokia_Customer_Document_ID__r.Customer_Document_ID__c,
					QTO_Nokia_Customer_Document_ID__r.Version_Nr__c,
					QTO_Nokia_Customer_Document_ID__r.Total_Value__c,
					QTO_Nokia_Customer_Document_ID__r.CurrencyIsoCode,
					QTO_Nokia_Customer_Document_ID__r.Payment_terms__c,
					QTO_Nokia_Customer_Document_ID__r.INCO_Terms__c,
					QTO_Nokia_Customer_Document_ID__r.QTO_PDF_Place_of_Delivery_Shipment__c,
					QTO_Nokia_Customer_Document_ID__r.Requested_Delivery_Date__c 
				FROM CD_Association_to_CD__c
				WHERE Id =:cdAssociationId];
		
		CDDocuments cdDoc = new CDDocuments();
		cdDoc.cdDoc = associationRec.Customer_Document__r;
		cdDoc.nokiaCdDoc = associationRec.QTO_Nokia_Customer_Document_ID__r;
		
		List<Customer_Document_Line_Items__c> cdLineItems =
				[SELECT Id,
				 QTO_Product_Code__c, Detailed_Product__c, High_level_Product__c,
				 QTO_Unit_of_Measure__c, QTO_PDF_Unit_Of_Measure__c,
				 Quantity__c, QTO_PDF_Quantity__c,
				 QTO_Unit_Price__c, QTO_PDF_Unit_Price__c,
				 Total_Value__c, QTO_PDF_Total_Value__c,
				 QTO_Requested_Delivery_Date__c, QTO_PDF_Requested_Delivery_Date__c,
				 Contract_Item_Number__c 
				 FROM Customer_Document_Line_Items__c
				 WHERE Customer_Document__c =:associationRec.Customer_Document__r.Id];
		List<Customer_Document_Line_Items__c> nokiaCdLineItems =
				[SELECT Id,
				 QTO_Product_Code__c, Detailed_Product__c, High_level_Product__c,
				 QTO_Unit_of_Measure__c, QTO_PDF_Unit_Of_Measure__c,
				 Contract_Item_Number__c, 
				 QTO_Unit_Price__c, QTO_PDF_Unit_Price__c,
				 Total_Value__c, QTO_PDF_Total_Value__c,
				 QTO_Requested_Delivery_Date__c, QTO_PDF_Requested_Delivery_Date__c,
				 Quantity__c, QTO_PDF_Quantity__c
				 FROM Customer_Document_Line_Items__c
				 WHERE Customer_Document__c =:associationRec.QTO_Nokia_Customer_Document_ID__r.Id];
		Map<String, Customer_Document_Line_Items__c> wasLineProductWithLine =
				new Map<String, Customer_Document_Line_Items__c>();
		Set<String> allProductCodes = new Set<String>();
		Map<String, String> productCodeToInternalCode = new Map<String, String>();
		
		List<Customer_Document_Line_Items__c> noProductCodeWasList =
				new List<Customer_Document_Line_Items__c>();
		List<Customer_Document_Line_Items__c> noProductCodeBecameList =
				new List<Customer_Document_Line_Items__c>();
		
		for (Customer_Document_Line_Items__c wasLine: cdLineItems) {
			if(wasLine.High_level_Product__c != null) {
				allProductCodes.add(wasLine.High_level_Product__c );
				productCodeToInternalCode.put(wasLine.High_level_Product__c , wasLine.QTO_Product_Code__c);
				wasLineProductWithLine.put(wasLine.High_level_Product__c, wasLine);
			} else {
			 //   noProductCodeWasList.add(wasLine);
			}
		}
		
		Map<String, Customer_Document_Line_Items__c> becameLineProductWithLine =
				new Map<String, Customer_Document_Line_Items__c>();
		for (Customer_Document_Line_Items__c becameLine: nokiaCdLineItems) {
			if (becameLine.High_level_Product__c != null) {
				allProductCodes.add(becameLine.High_level_Product__c);
				productCodeToInternalCode.put(becameLine.High_level_Product__c, becameLine.QTO_Product_Code__c);
				becameLineProductWithLine.put(becameLine.High_level_Product__c, becameLine);
			} else {
			 //   noProductCodeBecameList.add(wasLine);
			}
		}
		
		List<CDLineItems> cdLineItemObjs = new List<CDLineItems>();
		
		for (String productCode: allProductCodes) {
			CDLineItems cdLineItemObj = new CDLineItems();
			cdLineItemObj.productCode = productCode;
			cdLineItemObj.internalProductCode = productCodeToInternalCode.get(productCode);
			cdLineItemObj.wasLine = wasLineProductWithLine.get(productCode);
			cdLineItemObj.becameLine = becameLineProductWithLine.get(productCode);
			
			if (cdLineItemObj.wasLine != null && cdLineItemObj.becameLine != null) {
				cdLineItemObj.colorQCode = (cdLineItemObj.wasLine.QTO_PDF_Quantity__c != cdLineItemObj.becameLine.QTO_PDF_Quantity__c)
					? 'changeColor'
					: cdLineItemObj.colorQCode;
				
				cdLineItemObj.colorUCode = (cdLineItemObj.wasLine.QTO_PDF_Unit_Of_Measure__c != cdLineItemObj.becameLine.QTO_PDF_Unit_Of_Measure__c)
					? 'changeColor'
					: cdLineItemObj.colorUCode;
				 
				cdLineItemObj.colorPCode = (cdLineItemObj.wasLine.QTO_PDF_Unit_Price__c != cdLineItemObj.becameLine.QTO_PDF_Unit_Price__c)
					? 'changeColor'
					: cdLineItemObj.colorPCode;
				   
				cdLineItemObj.colorTCode = (cdLineItemObj.wasLine.QTO_PDF_Total_Value__c != cdLineItemObj.becameLine.QTO_PDF_Total_Value__c)
					? 'changeColor'
					: cdLineItemObj.colorTCode;
				 
				cdLineItemObj.colorDCode = (cdLineItemObj.wasLine.QTO_PDF_Requested_Delivery_Date__c != cdLineItemObj.becameLine.QTO_PDF_Requested_Delivery_Date__c)
					? 'changeColor'
					: cdLineItemObj.colorDCode;
			}
			
			cdLineItemObj.colorNoWasCode = cdLineItemObj.wasLine == null ? 'changeColorNoPre' : cdLineItemObj.colorNoWasCode;			
			cdLineItemObj.colorNoBecameCode = cdLineItemObj.becameLine == null ? 'changeColorNoNew' : cdLineItemObj.colorNoBecameCode;
			System.debug('CD Line Item Wrapper \n' + cdLineItemObj.wasLine);
			cdLineItemObjs.add(cdLineItemObj);
		}
		
		/*for (Customer_Document_Line_Items__c wasLineNoProduct :noProductCodeWasList) {
			CDLineItems cdLineItemObj = new CDLineItems();
			cdLineItemObj.wasLine = wasLineNoProduct;
			
			cdLineItemObjs.add(cdLineItemObj);
		}
		
		for (Customer_Document_Line_Items__c becameLineNoProduct :noProductCodeBecameList) {
			CDLineItems cdLineItemObj = new CDLineItems();
			cdLineItemObj.becameLine = becameLineNoProduct;
			
			cdLineItemObjs.add(cdLineItemObj);
		}*/
			
		/*for (String wasLineKey: wasLineProductWithLine.keySet()) {
			CDLineItems cdLineItemObj = new CDLineItems();
			cdLineItemObj.productCode = 
			cdLineItemObj.wasLine = wasLineProductWithLine.get(wasLineKey);
			
			Customer_Document_Line_Items__c wasLine = wasLineProductWithLine.get(wasLineKey);
			if (becameLineProductWithLine.get(wasLine.QTO_Product_Code__c) != null) {
				cdLineItemObj.becameLine = becameLineProductWithLine.get(wasLine.QTO_Product_Code__c);
				becameLineProductWithLine.remove(wasLine.QTO_Product_Code__c);
			}
			
			cdLineItemObjs.add(cdLineItemObj);
		}
		
		for (Customer_Document_Line_Items__c becameLine: becameLineProductWithLine.values()) {
			CDLineItems cdLineItemObj = new CDLineItems();
			
			cdLineItemObj.becameLine = becameLine;
		   
			cdLineItemObjs.add(cdLineItemObj);
		}*/
		
		cdDoc.lineItems = cdLineItemObjs;
		
		return cdDoc;
	}
	
	public class CDDocuments {
		@AuraEnabled
		public Customer_Document__c cdDoc { get; set; }
		@AuraEnabled
		public Customer_Document__c nokiaCdDoc { get; set; }
		@AuraEnabled
		public List<CDLineItems> lineItems { get; set; }
	}
	
	public class CDLineItems {
		@AuraEnabled
		public String productCode { get; set; }
		@AuraEnabled
		public String internalProductCode { get; set; }
		@AuraEnabled
		public String colorQCode { get; set; }
		@AuraEnabled
		public String colorUCode { get; set; }
		@AuraEnabled
		public String colorPCode { get; set; }
		@AuraEnabled
		public String colorTCode { get; set; }
		@AuraEnabled
		public String colorDCode { get; set; }
		@AuraEnabled
		public String colorNoBecameCode { get; set; }
		@AuraEnabled
		public String colorNoWasCode { get; set; }
		@AuraEnabled
		public Customer_Document_Line_Items__c wasLine { get; set; }
		@AuraEnabled
		public Customer_Document_Line_Items__c becameLine { get; set; }
	}
	
}