trigger CustomerFacingAttributeTrigger on Customer_facing_Attribute__c (After insert) {
	if(Trigger.isAfter && Trigger.isInsert) {
		Set<Id> cDocIdList = new Set<Id>();
		Id cdDocLineId;
		for(Customer_facing_Attribute__c cfa : Trigger.New) {
			System.debug(cfa.QTO_Customer_Document__c +'.....'+cfa.Attribute_Label__c+'.......'+cfa.Attribute_Value__c+'....'+cfa.QTO_Customer_Document_Line_Items__c);
			if(cfa.QTO_Customer_Document__c == null && cfa.QTO_Customer_Document_Line_Items__c!=null) {
				
				cDocIdList.add(cfa.QTO_Customer_Document_Line_Items__c);
				cdDocLineId = cfa.QTO_Customer_Document_Line_Items__c;
				
			}
		}
		
		System.debug('cDocIdList.....'+cDocIdList.size());
		/*
		if(cDocIdList.size()>0 && cdDocLineId!=null) {
			Customer_Document_Line_Items__c cdLine = [Select Id,Customer_Document__c, Customer_Document__r.Status__c  from  Customer_Document_Line_Items__c where Id=: cdDocLineId ];
			System.debug('CDDOC STATUS.....'+cdLine.Customer_Document__r.Status__c);
						 
			if(cdLine.Customer_Document__r.Status__c == 'Registered') {
					  
					System.debug('Batch Process Started...');
					Id cdId = cdLine.Customer_Document__c;
					Set<String> docIdSet = new Set<String>{cdId};
					QTO_CustomerDocumentAssociationBatch cda = new QTO_CustomerDocumentAssociationBatch(docIdSet);
					Id batchId = Database.executeBatch(cda,1);
					System.debug('Batch Process Finished...');
					
					
					/*
					List<Customer_Document_Line_Items__c> cdlineList = [Select Id,High_level_Product__c,High_level_Product_Description__c,QTO_PDF_Unit_Of_Measure__c,QTO_PDF_Quantity__c,QTO_PDF_Unit_Price__c,
					QTO_PDF_Currency_Code__c,Detailed_Product__c,Detailed_Product_Description__c, Quantity__c, QTO_Unit_of_Measure__c, QTO_Unit_Price__c, CurrencyIsoCode,
					QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c,Contract_Item_Number__c,QTO_PDF_Total_Value__c,QTO_PDF_Requested_Delivery_Date__c,
					Price_List_Item__c,Customer_Document__c,Customer_Document__r.Customer__c from Customer_Document_Line_Items__c where Customer_Document__c =:cdLine.Customer_Document__c];
					
					System.debug('cdlineList...'+cdlineList.size());
					if(cdlineList.size()>0)  {
					QTO_CustomerDocumentLineItem_Helper.lineItemEnrichment(cdlineList); 
					}
					cdLine = [Select Id,Customer_Document__c, Customer_Document__r.Status__c  from  Customer_Document_Line_Items__c where Id=: cdDocLineId ];
					System.debug('CDDOC STATUS.....'+cdLine.Customer_Document__r.Status__c);
					if(cdLine.Customer_Document__r.Status__c == 'Enriched(Lines)') {
					QTO_CdLineItemAssociationHelper.associateCdLineItems(cdlineList);
					}
					
				}
			}*/
		
	}
	
}