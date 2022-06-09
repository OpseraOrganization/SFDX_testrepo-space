/*******************************
Class Name: CartCreation
Created By: Accenture
Created Date: 31th Dec 2017
Last Modified By: Accenture
Description: This class will create quote configuration and configuration Line item
*******************************/
Public with sharing class CartCreation{
/*****************************
 *Method Name : createCart
 *Description: This method will create product cofiguration   
 *Parameters: List Of quote Proposals
 *Test coverage from: 
 *******************************/ 
	public static void createCart(list<Apttus_Proposal__Proposal__c> quoteProposalIdList){
	 
	  Apttus_Config2__ProductConfiguration__c cart = new Apttus_Config2__ProductConfiguration__c();
		Map<Id, Apttus_Config2__ProductConfiguration__c> mapUpsellToConfiguration = new Map<Id,Apttus_Config2__ProductConfiguration__c>();
		list<Apttus_Config2__ProductConfiguration__c> cartList = new list<Apttus_Config2__ProductConfiguration__c>(); 
		Set<Id> priceListId = new Set<Id>();		
		if(quoteProposalIdList != NULL && quoteProposalIdList.size() > 0){
			  for(Apttus_Proposal__Proposal__c proposal : quoteProposalIdList){
				  cart.Apttus_Config2__BusinessObjectRefId__c = proposal.Id;
				  cart.Apttus_QPConfig__Proposald__c = proposal.Id;
				  cart.Apttus_Config2__PriceListId__c = proposal.Apttus_QPConfig__PriceListId__c;
				  cart.Apttus_Config2__AccountId__c = proposal.Apttus_Proposal__Account__c;
				  cart.OwnerID = userinfo.getuserid(); 
				  cart.Apttus_Config2__EffectivePriceListId__c = proposal.Apttus_QPConfig__PriceListId__c;
				  cart.Apttus_Config2__VersionNumber__c = 1;
				  cart.Apttus_Config2__Status__c = CSWXGlobalConstant.cartStatus;
				  cart.name = proposal.Apttus_Proposal__Proposal_Name__c ;
				  cart.createdById = userinfo.getuserid();
				  cart.Apttus_Config2__BusinessObjectType__c =CSWXGlobalConstant.BusinessObjectType;
				  
				  if(proposal.SWx_Upsell_Proposal__c != null ){
					  cartList.add(cart);
				  }
				  
				  mapUpsellToConfiguration.put(proposal.SWx_Upsell_Proposal__c,cart);
				  priceListId.add(proposal.Apttus_QPConfig__PriceListId__c);
				  cart=NULL;
				}
			}
			
			Map<String,Id> productCodeToPLIId = new Map<String,Id>();
			
			for(Apttus_Config2__PriceListItem__c pliRec :[SELECT Id,Apttus_Config2__ProductId__r.ProductCode, Name FROM Apttus_Config2__PriceListItem__c WHERE Apttus_Config2__PriceListItem__c.Apttus_Config2__PriceListId__c IN :priceListId]){
					productCodeToPLIId.put(pliRec.Apttus_Config2__ProductId__r.Id,pliRec.id);
			}
			
			 
			if(cartList != NULL && cartList.size() > 0){ 
				try{	 
					
					Database.insert(cartList);
					
					if(mapUpsellToConfiguration !=null){
						createConfigurationLineItem(mapUpsellToConfiguration,productCodeToPLIId);
						ConfigLIforStandaloneProd.createConfigurationLineItem(mapUpsellToConfiguration,cartList,priceListId);
					}
					
						
					}catch(Exception e){
					ExceptionHandler.addException(e,CSWXGlobalConstant.CartCreation,CSWXGlobalConstant.createCart);
					}
			}
		
	 } 
 
	
/*****************************
 *Method Name : createConfigurationLineItem
 *Description: This method will data to be passed to Api for creation of Product Configuration Line Items   
 *Parameters: Map of Upsell Proposal Ids to configurations
 *Test coverage from: 
 *******************************/	
	public static void createConfigurationLineItem( Map<Id, Apttus_Config2__ProductConfiguration__c> mapUpsellToConfiguration,Map<String,Id> productCodeToPLIId){
	 
   try{
		Set<String> ccreOptionSet = new Set<String>();
		Set<String> swxOptionSet = new Set<String>();
		Set<String> setProductCodes = new Set<String>();
		Map<String,Id> productCodeToId = new Map<String,Id>();
		Map<Id,Id> mapComponentToId = new Map<Id,Id>();
		Map<Id,Id> mapOpIdToComponent = new Map<Id,Id>();
		Map<Id,CCRE_UpSell_LineItem__c> mapIdToUpsellItem_ccre = new Map<Id,CCRE_UpSell_LineItem__c>();
		Map<Id,SWx_Upsell_Items__c> mapIdToUpsellItem_swx = new Map<Id,SWx_Upsell_Items__c>();
		Map<Apttus_Config2__ProductConfiguration__c,Map<Id,CCRE_UpSell_LineItem__c>> mapCartToUpsellItems_ccre = new Map<Apttus_Config2__ProductConfiguration__c,Map<Id,CCRE_UpSell_LineItem__c>>();
		Map<Id,Map<Id,SWx_Upsell_Items__c>> mapCartToUpsellItems_swx = new Map<Id,Map<Id,SWx_Upsell_Items__c>>();		
		Map<Id,List<CCRE_UpSell_LineItem__c>> mapProposalToLineItems_ccre = new Map<Id,List<CCRE_UpSell_LineItem__c>>();
		Map<Id,List<SWx_Upsell_Items__c>> mapProposalToLineItems_swx = new Map<Id,List<SWx_Upsell_Items__c>>();
		Map<Id, List<Id>> mapBundIdOptionList = new Map<Id, List<Id>>();
		Map<Id, List<Id>> mapBundIdOptionProductList = new Map<Id, List<Id>>();
		Map<Id,Map<Id, List<Id>>> mapCartToConfigOption = new Map<Id,Map<Id, List<Id>>>();
		List<Product2> ccreoptionProdIdList = new List<Product2>();
		List<Product2> swxoptionProdIdList = new List<Product2>();
		
		if(!mapUpsellToConfiguration.isEmpty()){
			for(CCRE_UpSell_LineItem__c ccreLineitemRec : [SELECT id,Service_PCI__c,Sales_Item_Code__c,Optiongroup__c, Upsell_Proposal__c FROM CCRE_UpSell_LineItem__c  where (Upsell_Proposal__c in : mapUpsellToConfiguration.keyset() and Line_Item_Type__c = :CSWXGlobalConstant.Sales_line_items and Service_PCI__c !=null and Sales_Item_Code__c !=null) Limit : Limits.getLimitQueryRows()- Limits.getQueryRows()]){
				
				if(!mapProposalToLineItems_ccre.containsKey(ccreLineitemRec.Upsell_Proposal__c)){
					mapProposalToLineItems_ccre.put(ccreLineitemRec.Upsell_Proposal__c, new List<CCRE_UpSell_LineItem__c>());	 
				}
				mapProposalToLineItems_ccre.get(ccreLineitemRec.Upsell_Proposal__c).add(ccreLineitemRec);
				setProductCodes.add(ccreLineitemRec.Service_PCI__c);
				setProductCodes.add(ccreLineitemRec.Sales_Item_Code__c);
				ccreOptionSet.add(ccreLineitemRec.Sales_Item_Code__c);
			}
		
			for(SWx_Upsell_Items__c  swxLineitemRec : [SELECT id,Quantity__c,Feature_ID__c,Sales_Item_Code_SWx__c,SWx_Upsell_Proposal__c FROM SWx_Upsell_Items__c  where (Feature_ID__c!=null and Sales_Item_Code_SWx__c!=null and SWx_Upsell_Proposal__c in :  mapUpsellToConfiguration.keyset()) Limit : Limits.getLimitQueryRows()- Limits.getQueryRows() ]){
				if(!mapProposalToLineItems_swx.containsKey(swxLineitemRec.SWx_Upsell_Proposal__c)){
					mapProposalToLineItems_swx.put(swxLineitemRec.SWx_Upsell_Proposal__c, new List<SWx_Upsell_Items__c  >());	 
				}
				mapProposalToLineItems_swx.get(swxLineitemRec.SWx_Upsell_Proposal__c).add(swxLineitemRec);
				setProductCodes.add(swxLineitemRec.Feature_ID__c);
				setProductCodes.add(swxLineitemRec.Sales_Item_Code_SWx__c);
				swxOptionSet.add(swxLineitemRec.Sales_Item_Code_SWx__c);
			}
		}
		
		if(!setProductCodes.isEmpty() ){
			for(Product2 productObj : [select id,ProductCode from Product2 where ProductCode in :setProductCodes Limit : Limits.getLimitQueryRows()- Limits.getQueryRows()] ){
				productCodeToId.put(productObj.ProductCode,productObj.Id);
			} 
		}
		
		if(!ccreOptionSet.isEmpty()){
	  ccreoptionProdIdList = [select id from Product2 where productcode in : ccreOptionSet Limit : Limits.getLimitQueryRows()- Limits.getQueryRows()]; 
		}
		
		if(!ccreoptionProdIdList.isEmpty()){
			for(Apttus_Config2__ProductOptionComponent__c optionComp:[Select id,Apttus_Config2__ComponentProductId__c from Apttus_Config2__ProductOptionComponent__c where Apttus_Config2__ComponentProductId__c  in : ccreoptionProdIdList Limit : Limits.getLimitQueryRows()- Limits.getQueryRows()]){
				 mapComponentToId.put(optionComp.Apttus_Config2__ComponentProductId__c, optionComp.id);
				 mapOpIdToComponent.put(optionComp.id, optionComp.Apttus_Config2__ComponentProductId__c);
			 }
		}
	
		if(!swxOptionSet.isEmpty()){
	  swxoptionProdIdList = [select id from Product2 where productcode in : swxOptionSet Limit : Limits.getLimitQueryRows()- Limits.getQueryRows()]; 
		}
		  
		if(!swxoptionProdIdList.isEmpty()){
			 for(Apttus_Config2__ProductOptionComponent__c optionComp:[Select id,Apttus_Config2__ComponentProductId__c from Apttus_Config2__ProductOptionComponent__c where Apttus_Config2__ComponentProductId__c  in : swxoptionProdIdList Limit : Limits.getLimitQueryRows()- Limits.getQueryRows()]){
				 mapComponentToId.put(optionComp.Apttus_Config2__ComponentProductId__c, optionComp.id);
				 mapOpIdToComponent.put(optionComp.id, optionComp.Apttus_Config2__ComponentProductId__c);
			 }
		}
	
	
	  if(!mapUpsellToConfiguration.isEmpty()){
			
		for(SWx_Upsell_Proposal__c upsell : [select id,Analytics_Source__c from SWx_Upsell_Proposal__c where id in :mapUpsellToConfiguration.keyset() Limit : Limits.getLimitQueryRows()- Limits.getQueryRows()]){
		  
		  //CCRE Code commented in Sprint 21,DSI-1252
		  
		   /*  if(upsell.Analytics_Source__c.equals(CSWXGlobalConstant.AnalyticsSource_CCRE)){
				 
				 mapIdToUpsellItem_ccre = new Map<Id,CCRE_UpSell_LineItem__c>();
				for(CCRE_UpSell_LineItem__c ccreupsellLineItem :mapProposalToLineItems_ccre.get(upsell.id)){
					if(ccreupsellLineItem!=null){
						ccreOptionSet.add(ccreupsellLineItem.Sales_Item_Code__c);
						mapIdToUpsellItem_ccre.put(ccreupsellLineItem.Id,ccreupsellLineItem);
					}
				 }
			   mapCartToUpsellItems_ccre.put(mapUpsellToConfiguration.get(upsell.id),mapIdToUpsellItem_ccre);
		
			   for(Apttus_Config2__ProductConfiguration__c configRecord:mapCartToUpsellItems_ccre.keyset())
			   {
					mapidToUpsellItem_ccre = mapCartToUpsellItems_ccre.get(configRecord);
					if(!mapidToUpsellItem_ccre.isEmpty()) 
					{
						mapBundIdOptionList = new Map<Id, List<Id>>();
						for(Id id : mapidToUpsellItem_ccre.keySet()){
							CCRE_UpSell_LineItem__c ui = mapidToUpsellItem_ccre.get(id);
							//Map Bundle to Options
							if(!mapBundIdOptionList.containsKey(productCodeToId.get(ui.Service_PCI__c)) ) {
								mapBundIdOptionList.put(productCodeToId.get(ui.Service_PCI__c), new List<Id>());
							}
							
						   
			   mapBundIdOptionList.get(productCodeToId.get(ui.Service_PCI__c)).add(mapComponentToId.get(productCodeToId.get(ui.Sales_Item_Code__c)));
			  
									
						}
					}
				
					mapCartToConfigOption.put(configRecord.id,mapBundIdOptionList);
					mapBundIdOptionList = new Map<Id, List<Id>>();
				 
			}
			 }*/
	   
			// if(upsell.Analytics_Source__c.equals(CSWXGlobalConstant.AnalyticsSource)){  
			// DSI-1252,Sprint 21 - Removed the analytic resource dependency 
			if(upsell.Analytics_Source__c !=null){
			  
			if(!mapProposalToLineItems_swx.isEmpty()){
					mapIdToUpsellItem_swx = new Map<Id,SWx_Upsell_Items__c>();
					for(SWx_Upsell_Items__c SWXupsellLineItem :mapProposalToLineItems_swx.get(upsell.id) ){
						if(SWXupsellLineItem !=null){
							swxOptionSet.add(SWXupsellLineItem.Sales_Item_Code_SWx__c);
							
							mapIdToUpsellItem_swx.put(SWXupsellLineItem.Id,SWXupsellLineItem);
						}
					}
				}
			
		  mapCartToUpsellItems_swx.put(mapUpsellToConfiguration.get(upsell.id).Id,mapIdToUpsellItem_swx);
			
		 for(Id configRecordId :mapCartToUpsellItems_swx.keyset()){
		  mapIdToUpsellItem_swx = new Map<Id,SWx_Upsell_Items__c>();
					mapIdToUpsellItem_swx = mapCartToUpsellItems_swx.get(configRecordId);
					if(mapIdToUpsellItem_swx.size()!=0){
						for(Id id : mapIdToUpsellItem_swx.keySet()){
							SWx_Upsell_Items__c ui = mapIdToUpsellItem_swx.get(id);
							//Map Bundle to Options
							if(!mapBundIdOptionList.containsKey(productCodeToId.get(ui.Feature_ID__c)) ) {
								mapBundIdOptionList.put(productCodeToId.get(ui.Feature_ID__c), new List<Id>());
							}
							
							mapBundIdOptionList.get(productCodeToId.get(ui.Feature_ID__c)).add(mapComponentToId.get(productCodeToId.get(ui.Sales_Item_Code_SWx__c)));
									
						}
					}
					
					mapCartToConfigOption.put(configRecordId,mapBundIdOptionList);
					mapBundIdOptionList = new Map<Id, List<Id>>();
				 }
		   }
		
		 
	  }
	 }
	 
	 
  
	
	creatConfigurationItem( mapCartToConfigOption, mapOpIdToComponent, productCodeToId, mapCartToUpsellItems_swx,productCodeToPLIId);
   
	 }Catch(Exception ex){
		 ExceptionHandler.addException(ex,CSWXGlobalConstant.CartCreation,CSWXGlobalConstant.createConfigurationLineItemMethod);
	} 
	
} 

 /*****************************
 *Method Name : creatConfigurationItem
 *Description: This method will create Product Configuration Line Items by calling APttus API's
 *Parameters: Maps of data required
 *Test coverage from: 
 *******************************/
	Public  Static void  creatConfigurationItem(Map<Id,Map<Id, List<Id>>> mapCartToConfigOption, Map<Id,Id> mapOpIdToComponent, Map<String,Id> productCodeToId, Map<Id,Map<Id,SWx_Upsell_Items__c>> mapCartToUpsellItems_swx,Map<String,id> productCodeToPLIId){
		 
		
		try{
		
		List<String> customFields = new List<String>();
		Apttus_CPQApi.CPQ.SelectedOptionDO objSelectedOptionDO;
		Apttus_Config2__LineItem__c customData; 
		List<Apttus_CPQApi.CPQ.SelectedOptionDO> options;
		Apttus_CPQApi.CPQ.AddBundleRequestDO request;
		for(Id configRecordId :mapCartToConfigOption.keyset()){
			
		  
			for(Id bprod :mapCartToConfigOption.get(configRecordId).keyset()){
					   
				
				request = new Apttus_CPQApi.CPQ.AddBundleRequestDO();
				request.CartId = configRecordId;
				request.SelectedBundle = new Apttus_CPQApi.CPQ.SelectedBundleDO();
				request.SelectedBundle.SelectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
				request.SelectedBundle.SelectedProduct.ProductId = bprod;
				request.SelectedBundle.SelectedProduct.Quantity = CSWXGlobalConstant.BundleQuantity;
			   
			   options = new List<Apttus_CPQApi.CPQ.SelectedOptionDO>();

				for(id boId :mapCartToConfigOption.get(configRecordId).get(bprod)){
					
					 
					String quant;
					if(mapCartToUpsellItems_swx.get(configRecordId) != null){
						for(Id upsellItemId :mapCartToUpsellItems_swx.get(configRecordId).keyset()){
							SWx_Upsell_Items__c  ui = mapCartToUpsellItems_swx.get(configRecordId).get(upsellItemId);
							if((productCodeToId.get(ui.Feature_ID__c)== bprod) && (productCodeToId.get(ui.Sales_Item_Code_SWx__c) == mapOpIdToComponent.get(boId))){
								quant = String.valueOf(ui.Quantity__c);
							 
							} 
						}
					}
					
					objSelectedOptionDO = new Apttus_CPQApi.CPQ.SelectedOptionDO();
					if(boId!=null){
						objSelectedOptionDO.ComponentId =boId ;
					}
					if(boId !=null){
						objSelectedOptionDO.ComponentProductId =mapOpIdToComponent.get(boId);
					}
				   
					if(quant == null){
									   
					objSelectedOptionDO.Quantity = CSWXGlobalConstant.ccredefaultQuantity;
					
					}
					else{
						objSelectedOptionDO.Quantity = Integer.valueOf(quant);
					}
					options.Add(objSelectedOptionDO);
					
					
				}
			 
			   
					
					customFields.add(CSWXGlobalConstant.priceListItem);
					request.SelectedBundle.SelectedProduct.CustomFields = customFields;
					customData = new Apttus_Config2__LineItem__c();
					customData.Apttus_Config2__PriceListItemId__c = productCodeToPLIId.get(bprod);
				   
					request.SelectedBundle.SelectedProduct.CustomData = customData;
				
				if(options.size()>0){
					request.SelectedBundle.SelectedOptions = options ;
				}
				Apttus_CPQApi.CPQ.AddBundleResponseDO response = Apttus_CPQApi.CPQWebService.addBundle(request);
				
				customFields.clear();
			   
			}
			
		}
		}Catch(Exception ex){
		
	
		 ExceptionHandler.addException(ex,CSWXGlobalConstant.CartCreation,CSWXGlobalConstant.creatConfigurationItemMethod);
	} 
	}
	   
}