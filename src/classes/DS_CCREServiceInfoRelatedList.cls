public class DS_CCREServiceInfoRelatedList {
	/*****************************
	 *Method Name: getCCREServiceInfoLineItem
	 *Description: This method will retrieve the CCRE Service Info Line Items
	 *Parameters: Digital Proposal ID
	*******************************/	
	
	 @AuraEnabled
		public static List<CCRE_Service_Invoice_Info_line_items__c> getCCREServiceInfoLineItem(Id currentRecordId)
		{ 
			list<CCRE_Service_Invoice_Info_line_items__c> ccreServiceInfoList= new  list<CCRE_Service_Invoice_Info_line_items__c>();
			ccreServiceInfoList=[select Id,name, Attribute_Label__c,Attribute_Type__c, Attribute_Value__c,Attribute_for_customer__c from CCRE_Service_Invoice_Info_line_items__c where Offer__c =:currentRecordId];
			return ccreServiceInfoList;
			
		}
	
	/*****************************
	 *Method Name: getCCREProductInfoLineItem
	 *Description: This method will retrieve the CCRE Product Info Line Items
	 *Parameters: Digital Proposal ID
	*******************************/  
	@AuraEnabled
		public static List<CCRE_product_info_line_items__c> getCCREProductInfoLineItem(Id currentRecordId)
		{ 
			list<CCRE_product_info_line_items__c> ccreProdInfoList= new  list<CCRE_product_info_line_items__c>();
			ccreProdInfoList=[select id, name from CCRE_product_info_line_items__c where Offer__c =:currentRecordId];
			return ccreProdInfoList;
			
		}
	

}