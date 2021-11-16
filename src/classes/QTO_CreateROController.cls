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
			CurrencyIsoCode, Agreement_Lookup__r.Nokia_Legal_Entity_lookup__c
			FROM Apttus_Proposal__Proposal__c 
			WHERE Id =:quoteId];
		
		
		
		List<Apttus_Proposal__Proposal_Line_Item__c> lines = [
				SELECT External_Reference__c,External_Description__c,Apttus_Proposal__Product__r.ProductCode,
					Apttus_Proposal__Product__c,Apttus_QPConfig__LineNumber__c,Apttus_QPConfig__Quantity2__c,
					Apttus_Proposal__Product__r.Apttus_Config2__Uom__c, Apttus_QPConfig__NetUnitPrice__c,
					Apttus_QPConfig__NetPrice__c, Name, Apttus_QPConfig__PriceListId__r.Name
				FROM Apttus_Proposal__Proposal_Line_Item__c 
				WHERE Apttus_Proposal__Proposal__c =: quoteId];
		
		if (!quoteRecs.isEmpty()) {
			Apttus_Proposal__Proposal__c qRec = quoteRecs[0];
			Customer_Document__c cd = new Customer_Document__c();
			cd.Customer_Document_ID__c = roNumber + '.' + qRec.Name;
			cd.QTO_Customer_Document_Date__c = String.valueof(System.today());
			cd.QTO_PDF_Customer_Name__c = qrec.Sold_To_Party__r.Name;
			cd.QTO_PDF_Total_Value__c = String.valueof(qrec.Quote_Total__c);
			cd.QTO_Currency__c = qRec.CurrencyIsoCode;
			cd.QTO_Classification__c = 'In-House Order';
			cd.QTO_Sub_Classification__c = 'Risk-Order';
			cd.QTO_PDF_Nature__c = 'Create';
			cd.QTO_Nokia_Legal_Entity_Account__c = qRec.Agreement_Lookup__r.Nokia_Legal_Entity_lookup__c;
			
			insert cd;
			
			qRec.QTO_Risk_Order_Number__c = roNumber;
			
			//update qrec;
			
			Customer_facing_Attribute__c cdCfa = new Customer_facing_Attribute__c();
			cdCfa.Attribute_Indicator__c = 'Header';
			cdCfa.Attribute_Label__c = 'PDF QUOTE REF';
			cdCfa.Attribute_Value__c = 'Quote ID (' + quoteRecs[0].Name +')';
			cdCfa.QTO_Customer_Document__c = cd.Id;
			
			cfaList.add(cdCfa);
			
			if (!lines.isEmpty()) {
				List<Customer_Document_Line_Items__c> cdLines = new List<Customer_Document_Line_Items__c>();
				
				for (Apttus_Proposal__Proposal_Line_Item__c line: lines) {
					Customer_Document_Line_Items__c cdLine = new Customer_Document_Line_Items__c();
					
					cdLine.High_level_Product__c = line.External_Reference__c;
					cdLine.High_level_Product_Description__c = line.External_Reference__c;
					cdLine.Detailed_Product__c  = line.Apttus_Proposal__Product__r.ProductCode;
					cdLine.Detailed_Product_Description__c   = line.External_Reference__c;
					cdLine.PDF_Line_Item__c = String.valueof(line.Apttus_QPConfig__LineNumber__c);
					cdLine.QTO_PDF_Quantity__c = String.valueof(line.Apttus_QPConfig__Quantity2__c);
					cdLine.QTO_Unit_of_Measure__c = line.Apttus_Proposal__Product__r.Apttus_Config2__Uom__c;
					cdLine.QTO_PDF_Unit_Price__c = String.valueof(line.Apttus_QPConfig__NetUnitPrice__c);
					cdLine.QTO_PDF_Currency_Code__c = cd.CurrencyISOCode;
					cdLine.QTO_PDF_Total_Value__c = String.valueof(line.Apttus_QPConfig__NetPrice__c);
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
					cdCfa1.Attribute_Value__c = roNumber +'.' + lines[i].Name;
					cdCfa1.QTO_Customer_Document_Line_Items__c = cdli.Id;
					cdCfa1.Quote_Line_Item__c = lines[i].Id;
					
					cfaList.add(cdCfa1);
					
					Customer_facing_Attribute__c cdCfa2 = new Customer_facing_Attribute__c();
					cdCfa2.Attribute_Indicator__c = 'Item';
					cdCfa2.Attribute_Label__c = 'PDF SITE CODE';
					cdCfa2.Attribute_Value__c = String.valueOf(Math.round((Math.random() * (900000) + 100000)));
					cdCfa2.QTO_Customer_Document_Line_Items__c = cdli.Id;
					
					cfaList.add(cdCfa2);
					
					Customer_facing_Attribute__c cdCfa3 = new Customer_facing_Attribute__c();
					cdCfa3.Attribute_Indicator__c = 'Item';
					cdCfa3.Attribute_Label__c = 'PDF SITE NAME';
					cdCfa3.Attribute_Value__c = 'ABCD';//roNumber +'.' + lines[i].Name;
					cdCfa3.QTO_Customer_Document_Line_Items__c = cdli.Id;
					
					cfaList.add(cdCfa3);
					
					
					i++;
				}
			}
			
			insert cfaList;
			
			return cd.Id;
		}
		
		return null;
	}

}