public with sharing class CPQLineItemTriggerHandler{
	
	public static void afterInsert(Map<Id,Apttus_Config2__LineItem__c> newLineItemMap){
		Map<String,String> oldAndNewLIMap = new Map<String,String>();
		
		for(Apttus_Config2__LineItem__c lineItem : newLineItemMap.values()){
			system.debug('lineItem.isClone()');
			
			set<String> setofPortfolio  = new set<String>();
			List<String> portfolio = System.label.CPQ_Portfolio_Check.Split(',');
			setofPortfolio.addAll(portfolio);

			
			if(lineItem.isClone() && setofPortfolio.contains(lineItem.Portfolio_from_Quote_Line_Item__c) && lineItem.Apttus_Config2__LineType__c == Nokia_CPQ_Constants.NOKIA_PRODUCT_SERVICES && lineItem.Apttus_Config2__ChargeType__c != null && lineItem.Apttus_Config2__ChargeType__c == Nokia_CPQ_Constants.STANDARD_PRICE){
				system.debug(lineItem.getCloneSourceId());
				//  system.debug('oldAndNewQuoteMap--'+oldAndNewQuoteMap); 
				oldAndNewLIMap.put(lineItem.getCloneSourceId(),lineItem.Id);
				// oldAndNewQuoteMap.put(lineItem.Id,lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c);
				//system.debug('oldAndNewQuoteMap after inserting--'+oldAndNewQuoteMap); 
				//system.debug('oldAndNewLIMap after inserting--'+oldAndNewLIMap);			
			}
		}
		
		if(!oldAndNewLIMap.keySet().isEmpty()){
			List<Attachment> attachlist = new List<Attachment>();
			List<Attachment> newAttachmentList = new List<Attachment>();
			attachlist = [Select Id, Body, ParentId, contentType, Name 
						  From Attachment where ParentId In: oldAndNewLIMap.keySet()
						 LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			system.debug('attachlist--'+attachlist);
			if(!attachlist.isEmpty()){
				for(Attachment attach : attachlist){
					Attachment newAttach = attach.clone();
					newAttach.ParentId = oldAndNewLIMap.get(attach.ParentId);
					newAttachmentList.add(newAttach);
				}
				
				if(!newAttachmentList.isEmpty()){
					Database.insert(newAttachmentList);
					system.debug('newAttachmentList--'+newAttachmentList);				   
				}
			}
			//Calling future method to clone Delivery sales item
			InsertDeliverySalesItem(oldAndNewLIMap);		 
		}
	}
	@future   
	public static void InsertDeliverySalesItem(Map<String,String>oldAndNewLIMap) {
		//added by priyanka
		
		String quoteID = [Select Id, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c 
														from Apttus_Config2__LineItem__c where Id in : oldAndNewLIMap.values()
													   LIMIT 1].Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c;
	   // Map<Id,Id> lineItemIdQuoteIdMap = new Map<Id,Id>();
			/*for(Apttus_Config2__LineItem__c lineItem : [Select Id, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c 
														from Apttus_Config2__LineItem__c where Id in : lineItemIdSet
													   LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])
			{
				if(lineItem != Null)
					lineItemIdQuoteIdMap.put(lineItem.Id, lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c);
			}*/
			
		   // system.debug('lineItemIdQuoteIdMap--'+lineItemIdQuoteIdMap);
			List<Quote_Delivery_Sales_Item__c> deliverySalesItem = new List<Quote_Delivery_Sales_Item__c>();
			List<Quote_Delivery_Sales_Item__c> newSalesItemList = new List<Quote_Delivery_Sales_Item__c>();
			deliverySalesItem = [Select Id,Parent_Line_Item__c ,Arcadia_Product_Code__c ,Item_Type__c,PCI_Code__c,Product_Code__c,Quantity__c,Proposal__c From Quote_Delivery_Sales_Item__c where Parent_Line_Item__c In: oldAndNewLIMap.keySet()];
			system.debug('test insert--'); 
			
			if(!deliverySalesItem.isEmpty()){
				for(Quote_Delivery_Sales_Item__c salesItem : deliverySalesItem){				
					Quote_Delivery_Sales_Item__c newItem = salesItem.clone(false,true,false,false);
					newItem.Parent_Line_Item__c = oldAndNewLIMap.get(salesItem.Parent_Line_Item__c);
					system.debug('quote number--'+salesItem.Parent_Line_Item__c);
					if(oldAndNewLIMap.containsKey(salesItem.Parent_Line_Item__c) && (!String.isBlank(quoteID)))
						newItem.Proposal__c = quoteID; 
					newSalesItemList.add(newItem);
				}
				
				if(!newSalesItemList.isEmpty()){
					Database.insert(newSalesItemList);
				}
			}
		
	}
}