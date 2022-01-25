/*******************************
Class Name: ConfigLIforStandaloneProd
Created By: Accenture
Created Date: 16-April-2018
Last Modified By: Accenture
Description: This class will create configuration Line item for standalone product
*******************************/
Public with sharing class ConfigLIforStandaloneProd{
/*******************************
Class Name: createConfigurationLineItem
Created By: Accenture
Description: This methodusec to create configuration Line item for standalone product
*******************************/  
public static void createConfigurationLineItem( Map<Id, Apttus_Config2__ProductConfiguration__c> mapUpsellToConfiguration ,list<Apttus_Config2__ProductConfiguration__c> cartList,Set<Id> priceListId){
	try{
		List <Apttus_CPQApi.CPQ.SelectedProductDO> selectedProdDOList = new List <Apttus_CPQApi.CPQ.SelectedProductDO>();
		Map<id,List <Apttus_CPQApi.CPQ.SelectedProductDO>>  mapcarttoStandalone = new Map<id,List <Apttus_CPQApi.CPQ.SelectedProductDO>>();
		Map<Id,List<CCRE_UpSell_LineItem__c>> mapProposalToLineItems_ccre = new Map<Id,List<CCRE_UpSell_LineItem__c>>();
		Map<Id,List<SWx_Upsell_Items__c>> mapProposalToLineItems_swx = new Map<Id,List<SWx_Upsell_Items__c>>();
		Set<String> setProductCodes = new Set<String>();
		Set<String> ccreStandalone = new Set<String>();
		Set<String> swxStandalone = new Set<String>();
		Map<String,Id> productCodeToId = new Map<String,Id>();
		Map<String,Decimal> prodCodeToQuantity = new Map<String,Decimal>();
		Map<id,Set<String>> mapCartToUpsellItems = new Map<id,Set<String>>();  
		
		Map<String,Id> productCodeToPLIId= new Map<String,Id>();
  
	  
		// Map between Proposal & ccrelineitemRec and proposal & swxlineitem
		if(!mapUpsellToConfiguration.isEmpty()){
		  
		  //**** Commented CCRE Code in Sprint 21, DSI-1252 ***/
		 /* for(CCRE_UpSell_LineItem__c ccreLineitemRec : [SELECT id,Service_PCI__c,Sales_Item_Code__c,Optiongroup__c, Upsell_Proposal__c FROM CCRE_UpSell_LineItem__c  where (Upsell_Proposal__c in : mapUpsellToConfiguration.keyset() and Line_Item_Type__c = :CSWXGlobalConstant.Sales_line_items and Service_PCI__c=null) Limit : Limits.getLimitQueryRows()- Limits.getQueryRows()]){
	   
				if(!mapProposalToLineItems_ccre.containsKey(ccreLineitemRec.Upsell_Proposal__c)){
					mapProposalToLineItems_ccre.put(ccreLineitemRec.Upsell_Proposal__c, new List<CCRE_UpSell_LineItem__c>());	 
				 }
				mapProposalToLineItems_ccre.get(ccreLineitemRec.Upsell_Proposal__c).add(ccreLineitemRec);
				setProductCodes.add(ccreLineitemRec.Sales_Item_Code__c);
			 }*/
		
			 for(SWx_Upsell_Items__c  swxLineitemRec : [SELECT id,Quantity__c,Bundle_ID__r.ProductCode,Sales_Item_Code__r.ProductCode,SWx_Upsell_Proposal__c FROM SWx_Upsell_Items__c  where (SWx_Upsell_Proposal__c in :  mapUpsellToConfiguration.keyset() and Bundle_ID__r.ProductCode =null) Limit : Limits.getLimitQueryRows()- Limits.getQueryRows() ]){
				 if(!mapProposalToLineItems_swx.containsKey(swxLineitemRec.SWx_Upsell_Proposal__c)){
					mapProposalToLineItems_swx.put(swxLineitemRec.SWx_Upsell_Proposal__c, new List<SWx_Upsell_Items__c  >());	 
				  }
				  mapProposalToLineItems_swx.get(swxLineitemRec.SWx_Upsell_Proposal__c).add(swxLineitemRec);
				  setProductCodes.add(swxLineitemRec.Sales_Item_Code__r.ProductCode);
				  prodCodeToQuantity.put(swxLineitemRec.Sales_Item_Code__r.ProductCode,swxLineitemRec.Quantity__c);
			 }
		 }
		
		  // Map between productcode & productobject 
		   if(!setProductCodes.isEmpty() ){
			   for(Product2 productObj : [select id,ProductCode from Product2 where ProductCode in :setProductCodes Limit : Limits.getLimitQueryRows()- Limits.getQueryRows()] ){
				   productCodeToId.put(productObj.ProductCode,productObj.Id);
				   
				   
				}
			}
		
		//Map between configurationId and Standalone product.
		  if(!mapUpsellToConfiguration.isEmpty()){
			  for(SWx_Upsell_Proposal__c upsell : [select id,Analytics_Source__c from SWx_Upsell_Proposal__c where id in :mapUpsellToConfiguration.keyset() Limit : Limits.getLimitQueryRows()- Limits.getQueryRows()]){
				  
				  //*** Commented CCRE Code in Sprint 21,DSI-1252 ***/
				/*  if(upsell.Analytics_Source__c.equals(CSWXGlobalConstant.AnalyticsSource_CCRE)){
					  for(CCRE_UpSell_LineItem__c ccreupsellLineItem :mapProposalToLineItems_ccre.get(upsell.id)){
						  if(ccreupsellLineItem!=null){
							  ccreStandalone.add(ccreupsellLineItem.Sales_Item_Code__c); 
						}
					 }
					mapCartToUpsellItems.put(mapUpsellToConfiguration.get(upsell.id).id,ccreStandalone);
				   
				   }*/
		  
				 // if(upsell.Analytics_Source__c.equals(CSWXGlobalConstant.AnalyticsSource)){
				 // DSI-1252,Sprint 21 - Removed the analytic resource  dependency
					  if(upsell.Analytics_Source__c !=null){
					  if(!mapProposalToLineItems_swx.isEmpty()){
						  for(SWx_Upsell_Items__c SWXupsellLineItem :mapProposalToLineItems_swx.get(upsell.id) ){
							  if(SWXupsellLineItem !=null){
							   swxStandalone.add(SWXupsellLineItem.Sales_Item_Code__r.ProductCode);
						   }
						}
					}
				
				  mapCartToUpsellItems.put(mapUpsellToConfiguration.get(upsell.id).id,swxStandalone);
			  
				   }
			   }
		   }
	   List<Apttus_Config2__PriceListItem__c> pliListRec;
		   
	   if(!priceListId.isEmpty()){
		   pliListRec = [SELECT Id,Apttus_Config2__ProductId__r.ProductCode,DS_Grouping_Name__c, Name FROM Apttus_Config2__PriceListItem__c WHERE Apttus_Config2__PriceListItem__c.Apttus_Config2__PriceListId__c IN :priceListId Limit : Limits.getLimitQueryRows()- Limits.getQueryRows()];
	   }
	   
	  
	   
	   if(!pliListRec.isEmpty()){
		   for(Apttus_Config2__PriceListItem__c pliRec :pliListRec){
			   
			   productCodeToPLIId.put(pliRec.Apttus_Config2__ProductId__r.ProductCode,pliRec.id);
		   }
	   }
	   
		Apttus_CPQApi.CPQ.SelectedProductDO SelectedProductDOInstance;
		List<String> customFields;
		
		Apttus_Config2__LineItem__c customData;
		String quant;
		if(!cartList.isEmpty()){  
			for(Apttus_Config2__ProductConfiguration__c  cartId : cartList){
				for(String prodCode : mapCartToUpsellItems.get(cartId.id)){
					SelectedProductDOInstance  = new Apttus_CPQApi.CPQ.SelectedProductDO();
					SelectedProductDOInstance.ProductId = productCodeToId.get(prodCode);
					customFields = new List<String>();
					customFields.add(CSWXGlobalConstant.priceListItem );
					customFields.add(CSWXGlobalConstant.quantityField);
					SelectedProductDOInstance.CustomFields = customFields;
					customData = new Apttus_Config2__LineItem__c();
					customData.Apttus_Config2__PriceListItemId__c= productCodeToPLIId.get(prodCode);
					quant = String.valueOf(prodCodeToQuantity.get(prodCode));
					
					if(quant !=null){
						customData.Apttus_Config2__Quantity__c  = prodCodeToQuantity.get(prodCode); 
					}
					else{
						customData.Apttus_Config2__Quantity__c =CSWXGlobalConstant.ccredefaultQuantity;
					}
					
					SelectedProductDOInstance.CustomData = customData;
					selectedProdDOList.add(SelectedProductDOInstance);
				}
			  
			  mapcarttoStandalone.put(cartId.id,selectedProdDOList);
			}
		}
		  Apttus_CPQApi.CPQ.AddMultiProductResponseDO lineItemRecordsResponse;
		  Apttus_CPQApi.CPQ.AddMultiProductRequestDO lineItemRecords;
		  if(!mapcarttoStandalone.isEmpty()){
			  for(Apttus_Config2__ProductConfiguration__c  cartId : cartList){
				 
				 lineItemRecords = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
				 lineItemRecords.cartID = cartId.id;
				 lineItemRecords.SelectedProducts = mapcarttoStandalone.get(cartId.id);
				 lineItemRecordsResponse = Apttus_CPQApi.CPQWebService.addMultiProducts(lineItemRecords);
			   }
		  }
		 
	 }Catch(Exception e){
			   ExceptionHandler.addException(e,CSWXGlobalConstant.ConfigLIforStandaloneProdclass,CSWXGlobalConstant.createConfigurationLineItem );
		}
	}
}