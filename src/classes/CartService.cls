@RestResource(urlMapping='/cartService/*')
global with sharing class CartService{
	public static String mainBundleLineItemId = '';
	public static List<Apttus_CPQApi.CPQ.SelectedOptionDO> selectedOptDOList = new List<Apttus_CPQApi.CPQ.SelectedOptionDO>();
	public static List<CurrencyType> defaultExchangeRate = new List<CurrencyType>();
	public static Map<String,Apttus_Config2__LineItem__c> existingLineItemMap = new Map<String,Apttus_Config2__LineItem__c>();
	public static List<String> arcadiaBundleList = new List<String>();
	public static List<String> allOptionsList = new List<String>();
	public static String errorMessage= 'Success';
	
	@HttpPost
	global static String UpsertData(){
		String prodConfidId = '';
		String configString = '';
		String payload = '';
		String configData = '';
		Apttus_Config2__ProductConfiguration__c prodConfig = new Apttus_Config2__ProductConfiguration__c();
		List<CARTServiceData.bom_data> firstLineItem = new List<CARTServiceData.bom_data>();
		List<CARTServiceData.bom_data> secondLevelItemsList = new List<CARTServiceData.bom_data>();
		Apttus_Config2__LineItem__c mainBundle = new Apttus_Config2__LineItem__c();
		List<Attachment> existingAttch = new List<Attachment>();
		Boolean isNewConfiguration = true;
		RestRequest req = RestContext.request;
		RestResponse res = Restcontext.response;
		
		
		try{
			String JSONbody = req.requestBody.toString();
			
			//Parsing the received response
			CARTServiceData csd = CARTServiceData.parse(JSONbody);
			
			system.debug('csd**' + csd);
			
			//return error if any of the required attribute is missing
			if(csd.header == null || csd.cfg_data == null || csd.bom_data == null){
				errorMessage = 'Required Data Missing';
			}
			else{
				prodConfidId = csd.header.cart_id;
				if(String.isNotBlank(prodConfidId)){
					prodConfig = [SELECT Id, Name, Apttus_Config2__PriceListId__c,Apttus_QPConfig__Proposald__c, Apttus_QPConfig__Proposald__r.CurrencyIsoCode FROM Apttus_Config2__ProductConfiguration__c WHERE Id =:prodConfidId LIMIT 1];
					
					defaultExchangeRate = [SELECT ConversionRate FROM CurrencyType WHERE IsoCode =: prodConfig.Apttus_QPConfig__Proposald__r.CurrencyIsoCode Limit 1];
					
					mainBundleLineItemId = csd.header.config_id;
					
					if(String.isNotBlank(mainBundleLineItemId)){
						
						List<Apttus_Config2__LineItem__c> mainBundleLineItem = [Select Id, Apttus_Config2__Quantity__c, Apttus_Config2__LineNumber__c,Apttus_Config2__ProductId__c, Item_Type_From_CAT__c, PCI_Code__c, NokiaCPQ_CAT_Config_Data__c From Apttus_Config2__LineItem__c Where id=: mainBundleLineItemId];
						
						//Query any existing attachment in case of existing configuration
						existingAttch = [SELECT Id FROM Attachment WHERE parentId =: mainBundleLineItemId LIMIT 1]; 
						
						if(!existingAttch.isEmpty()){
							isNewConfiguration = false;
						}
						
						//retrieve base64 encoded string which would be stored as an attahment to the main bundle line item
						configString = csd.cfg_data;
						
						system.debug('Config String length**' + configString.length());
						if(String.isNotBlank(configString)){
							Blob payloadBlob = EncodingUtil.base64Decode(configString);
							payload = payloadBlob.toString();
							system.debug('Config String payload**' + payload);
							
							//parse config string
							configData = parseConfigString(payload);
		
							//insert the attachment to Main Bundle
							insertAttachment(mainBundleLineItemId,existingAttch,payloadBlob);
						}
						else{
							errorMessage = 'Missing configuration data';
						}
						
						//Fetch BOM Information
						firstLineItem = csd.bom_data;
						system.debug('BOM**' + firstLineItem);
						Boolean isUpdate = false;
						if(!firstLineItem.isEmpty()){
							if(!firstLineItem.isEmpty() && String.isNotBlank(firstLineItem[0].item_type) && firstLineItem[0].item_type.equalsIgnoreCase('Product')){
								if(!mainBundleLineItem.isEmpty() && (mainBundleLineItem[0].Apttus_Config2__Quantity__c != Integer.valueOf(firstLineItem[0].quantity) || mainBundleLineItem[0].Item_Type_From_CAT__c != firstLineItem[0].item_type || mainBundleLineItem[0].PCI_Code__c != firstLineItem[0].pci_code)){
									mainBundleLineItem[0].Apttus_Config2__Quantity__c = Integer.valueOf(firstLineItem[0].quantity);
									mainBundleLineItem[0].Item_Type_From_CAT__c = firstLineItem[0].item_type;
									mainBundleLineItem[0].PCI_Code__c = firstLineItem[0].pci_code;
									isUpdate = true;
								}
								if(String.isNotBlank(configData)){
									mainBundleLineItem[0].NokiaCPQ_CAT_Config_Data__c = configData;
									isUpdate = true;
								}
								
								if(isUpdate){
									Database.update(mainBundleLineItem[0],false);
								}
							}
							system.debug('isNewConfiguration**' + isNewConfiguration);
							//Add Arcadia Options for New Configuration
							if(isNewConfiguration){
								addArcadiaItems(mainBundleLineItem[0].Apttus_Config2__ProductId__c,mainBundleLineItem[0].Apttus_Config2__LineNumber__c, prodConfig,firstLineItem[0].children,isNewConfiguration);
							}
							else{
								//Logic to be implemented for existing configuration
								
								for(Apttus_Config2__LineItem__c existingLineItem : [Select Id, Apttus_Config2__OptionId__c, Apttus_Config2__OptionId__r.ProductCode, Apttus_Config2__Quantity__c, Apttus_Config2__LineNumber__c,Apttus_Config2__ProductId__c, Item_Type_From_CAT__c, PCI_Code__c, NokiaCPQ_Unitary_Cost__c From Apttus_Config2__LineItem__c Where Apttus_Config2__ProductId__c =: mainBundleLineItem[0].Apttus_Config2__ProductId__c AND Apttus_Config2__LineType__c = 'Option' AND Apttus_Config2__LineNumber__c =: mainBundleLineItem[0].Apttus_Config2__LineNumber__c AND Apttus_Config2__ConfigurationId__c =: prodConfig.Id]){
									if(existingLineItem.Apttus_Config2__OptionId__c != null){
										existingLineItemMap.put(existingLineItem.Apttus_Config2__OptionId__r.ProductCode, existingLineItem);
									}
								}
								
								system.debug('existingLineItemMap***' + existingLineItemMap);
								if(!existingLineItemMap.keySet().isEmpty()){
									checkArcadiaItems(existingLineItemMap,mainBundleLineItem[0].Apttus_Config2__ProductId__c,mainBundleLineItem[0].Apttus_Config2__LineNumber__c, prodConfig, firstLineItem[0].children, isNewConfiguration);
								}
								else{
									addArcadiaItems(mainBundleLineItem[0].Apttus_Config2__ProductId__c,mainBundleLineItem[0].Apttus_Config2__LineNumber__c, prodConfig,firstLineItem[0].children,!isNewConfiguration);
								}
							}
						}
						else{
							errorMessage = 'Missing BOM Data';
						}
					}
					else{
						errorMessage = 'Missing Main Bundle Line Item Id';
					}
				}
				else{
					errorMessage = 'Missing Cart Id';
				}
			}
		}
		catch(Exception e){
			errorMessage = e.getMessage();
		}
		system.debug('return message' + errorMessage);
		createInterfaceLog(errorMessage,prodConfidId,mainBundleLineItemId);
		return errorMessage;
	}
	
	public static String parseConfigString(String payload){
		String parsedConfigData = '';
		String separator = ' ; ';
		payload = payload.replaceAll('-ZID','ZID');
		payload = payload.replaceAll('-ZNAME','ZNAME');
		payload = payload.replaceAll('-CHARC','CHARC');
		payload = payload.replaceAll('-CHARC_TXT','CHARC_TXT');
		payload = payload.replaceAll('-VALUE','VALUE');
		payload = payload.replaceAll('-VALUE_TXT','VALUE_TXT');
		system.debug('Modified payload**' + payload);
		CARTServiceConfigData configData = CARTServiceConfigData.parse(payload);
		system.debug('configData**' + configData);
		
		if(configData.data != null && configData.data.INST != null && configData.data.INST.data != null){
			CARTServiceConfigData.InstData insData = configData.data.INST.data;
			if(insData.CSTICS != null){
				CARTServiceConfigData.Characteristics ChrsData = insData.CSTICS;
				system.debug('CARTServiceConfigData ChrsData** ' + ChrsData);
				if(ChrsData != null){
					List<CARTServiceConfigData.Cstic> cstic = ChrsData.CSTIC;
					system.debug('CARTServiceConfigData cstic** ' + cstic + cstic[0]);
					if(!cstic.IsEmpty()){
						for(CARTServiceConfigData.Cstic csticRec : cstic){
							if(csticRec.data != null && csticRec.data.CHARC_TXT != null && csticRec.data.VALUE_TXT != null){
								parsedConfigData = parsedConfigData + csticRec.data.CHARC_TXT.unescapeHtml4() + ':' + csticRec.data.VALUE_TXT.unescapeHtml4() + separator.unescapeHtml4();
							}
						}
					}
				}
				
			}
		}
		parsedConfigData = parsedConfigData.replaceAll('&#124;','-');
		system.debug('parsedConfigData** ' + parsedConfigData + parsedConfigData.length());
		return parsedConfigData;
	}
	
	public static void addArcadiaItems(String mainBundleId, Decimal lineNumber, Apttus_Config2__ProductConfiguration__c cartRecord, List<CARTServiceData.bom_data> secondLevelList, Boolean isNewConfiguration){
		
		Set<String> productNumberSet = new Set<String>();
		Map<String,String> prodIdAndCodeMap = new Map<String,String>();
		Map<String,Integer> productAndQuantityMap = new Map<String,Integer>();
		Set<String> arcadiaProductList = new Set<String>();
		List<String> deliverySalesItemList = new List<String>();
		Set<String> salesItemCodeSet = new Set<String>();
		Map<String,Map<String,Integer>> arcadiaAndSIMap = new Map<String,Map<String,Integer>>();
		List<String> sIProductList = new List<String>();
		Map<String,Decimal> salesItemCostMap = new Map<String,Decimal>();
		Map<String,Decimal> arcadiaAndCostMap = new Map<String,Decimal>();
		Map<String,CARTServiceData.bom_data> arcadiaProductsMap = new Map<String,CARTServiceData.bom_data>();
		List<Apttus_Config2__LineItem__c> lineItemsToUpdateList = new List<Apttus_Config2__LineItem__c>();
		
		//Fetch Arcadia Product Codes	
		for(CARTServiceData.bom_data secondLineItem : secondLevelList){
			Boolean isBundle = false;
			Map<String,Integer> salesItemQuantityMap = new Map<String,Integer>();
			productNumberSet.add(secondLineItem.product_code);
			productAndQuantityMap.put(secondLineItem.product_code,secondLineItem.quantity);
			arcadiaProductsMap.put(secondLineItem.product_code,secondLineItem);
			//Retrieve Delivery items and costs
			Integer i=1;
			for(CARTServiceData.bom_data thirdlineItem : secondLineItem.children){
				isBundle = true;
				if(String.isNotBlank(thirdLineItem.item_type) && thirdLineItem.item_type.equalsIgnoreCase('Order')){
					DeliverySalesItems newSalesItem = new DeliverySalesItems();
					newSalesItem.name = lineNumber + '-' + secondLineItem.product_code + '-' + i;
					newSalesItem.quoteId = cartRecord.Apttus_QPConfig__Proposald__c;
					newSalesItem.product_code = thirdlineItem.product_code;
					newSalesItem.pci_code = thirdlineItem.pci_code;
					newSalesItem.quantity = thirdlineItem.quantity;
					newSalesItem.arcadiaProductCode = secondLineItem.product_code;
					newSalesItem.item_type = thirdLineItem.item_type;
					newSalesItem.parentLineItem = mainBundleLineItemId;
					i++;
					deliverySalesItemList.add(JSON.serialize(newSalesItem));
					
					salesItemCodeSet.add(thirdLineItem.product_code);
					
					salesItemQuantityMap.put(thirdlineItem.product_code,thirdlineItem.quantity);
				}
			}
			
			arcadiaAndSIMap.put(secondLineItem.product_code,salesItemQuantityMap);
			
			if(!isBundle){
				salesItemCodeSet.add(secondLineItem.product_code);
			}
			
			if(isBundle){
				arcadiaBundleList.add(secondLineItem.product_code);
			}
		}
		
		//Start new thread to handle delivery items
		system.debug('deliverySalesItemList**' + deliverySalesItemList);
		system.debug('arcadiaAndSIMap**' + arcadiaAndSIMap);
		system.debug('arcadiaBundleList**' + arcadiaBundleList);
		createDeliveryItems(deliverySalesItemList);
		
		//changes on behalf of reqs #6580, Portfolio__c != null
		for(Product2 prod : [SELECT Id, ProductCode FROM Product2 WHERE ProductCode IN: salesItemCodeSet AND Portfolio__c != null]){
			sIProductList.add(prod.Id);
		}
		
		for(Apttus_Config2__PriceListItem__c pli : [Select Id, Apttus_Config2__Cost__c, Apttus_Config2__ProductId__r.ProductCode From Apttus_Config2__PriceListItem__c where Apttus_Config2__PriceListId__r.Name=: Label.NokiaCPQ_GlobalPriceList_Eur AND Apttus_Config2__ProductId__c IN: sIProductList]){
			salesItemCostMap.put(pli.Apttus_Config2__ProductId__r.ProductCode,pli.Apttus_Config2__Cost__c);
		}
		system.debug('salesItemCostMap**' + salesItemCostMap);
		system.debug('productNumberSet**' + productNumberSet);
		
		//changes on behalf of reqs #6580, Portfolio__c != null
		//Map of product external ids and salesforce ids
		for(Product2 prod : [SELECT Id, ProductCode FROM Product2 WHERE ProductCode IN: productNumberSet AND Portfolio__c != null]){
			prodIdAndCodeMap.put(prod.Id,prod.ProductCode);
			arcadiaProductList.add(prod.Id);
			
			Decimal arcadiaCost = 0.0;
			system.debug('arcadiaAndSIMap values'+arcadiaAndSIMap.get(prod.ProductCode));
			if(arcadiaAndSIMap != null && arcadiaAndSIMap.containsKey(prod.ProductCode) && arcadiaAndSIMap.get(prod.ProductCode) != null && !arcadiaAndSIMap.get(prod.ProductCode).isEmpty()){
				for(String salesItem : arcadiaAndSIMap.get(prod.ProductCode).keySet()){ 
					if(salesItemCostMap.get(salesItem) != null && arcadiaAndSIMap.get(prod.ProductCode).get(salesItem) != null){
						arcadiaCost = arcadiaCost + (salesItemCostMap.get(salesItem) * defaultExchangeRate[0].ConversionRate * (arcadiaAndSIMap.get(prod.ProductCode).get(salesItem)));
					}
					else if(salesItemCostMap.get(salesItem) != null){
						arcadiaCost = arcadiaCost + (salesItemCostMap.get(salesItem) * defaultExchangeRate[0].ConversionRate);
					}
				}
			}
			else if(salesItemCodeSet.contains(prod.ProductCode)){
				if(salesItemCostMap.get(prod.ProductCode) != null /*&& productAndQuantityMap != null && productAndQuantityMap.get(prod.ProductCode) != null*/){
					arcadiaCost = salesItemCostMap.get(prod.ProductCode) * defaultExchangeRate[0].ConversionRate;
				}
			   /* else if(salesItemCostMap.get(prod.ProductCode) != null){
					arcadiaCost = salesItemCostMap.get(prod.ProductCode) * defaultExchangeRate[0].ConversionRate;
				}*/
			}
			
			arcadiaAndCostMap.put(prod.Id,arcadiaCost.setScale(2, RoundingMode.HALF_UP));
		}
		
		system.debug('arcadiaAndCostMap**' + arcadiaAndCostMap);
		
		if(!arcadiaProductList.isEmpty() && isNewConfiguration){
			//Add options to main bundle
			
			Apttus_CPQApi.CPQ.ProductOptionGroupSearchResultDO result = Apttus_CPQApi.CPQWebService.getOptionGroupsForPriceListProduct(cartRecord.Apttus_Config2__PriceListId__c,mainBundleId);
			
			if(result.HasOptionGroups){
				List<Apttus_CPQApi.CPQ.ProductOptionGroupDO> prodOptGrpDOList = result.OptionGroups;
				system.debug('prodOptGrpDOList**' + prodOptGrpDOList);
				selectedOptDOList = addSelectedOptions(prodOptGrpDOList,arcadiaProductList,productAndQuantityMap,prodIdAndCodeMap,arcadiaAndCostMap,arcadiaProductsMap);
			}
			
			if(!selectedOptDOList.isEmpty()){
				//Invoke the addOptions API and pass the cartID, selected product line number, and the Option List
				Apttus_CPQApi.CPQ.AddOptionsResponseDO addOptRespDO = Apttus_CPQApi.CPQWebService.addOptions(cartRecord.Id, Integer.valueOf(lineNumber), selectedOptDOList);
			}
		}
		else if(!isNewConfiguration){
			//Set<String> arcadiaToBeInsertedSet = new Set<String>();
			//arcadiaToBeInsertedSet.addAll(arcadiaProductList);
			system.debug(' In Existing Config **' + existingLineItemMap);
			system.debug(' arcadiaProductsMap **' + arcadiaProductsMap);
			for(String secondLineItem : arcadiaProductsMap.keySet()){
				//Update to existing line item
				if(existingLineItemMap.containsKey(secondLineItem)){
					Decimal arcadiaCost = arcadiaAndCostMap.get(existingLineItemMap.get(secondLineItem).Apttus_Config2__OptionId__c);
					system.debug('Option ID**' + existingLineItemMap.get(secondLineItem).Apttus_Config2__OptionId__c + '**arcadiaCost** ' + arcadiaCost);
					if(arcadiaProductsMap.get(secondLineItem).quantity != existingLineItemMap.get(secondLineItem).Apttus_Config2__Quantity__c || arcadiaProductsMap.get(secondLineItem).pci_code != existingLineItemMap.get(secondLineItem).PCI_Code__c || arcadiaProductsMap.get(secondLineItem).item_type != existingLineItemMap.get(secondLineItem).Item_Type_From_CAT__c || existingLineItemMap.get(secondLineItem).NokiaCPQ_Unitary_Cost__c != arcadiaCost){
						
						Apttus_Config2__LineItem__c updateLineItem = new Apttus_Config2__LineItem__c(Id = existingLineItemMap.get(secondLineItem).Id);
						updateLineItem.Apttus_Config2__Quantity__c = arcadiaProductsMap.get(secondLineItem).quantity;
						updateLineItem.PCI_Code__c = arcadiaProductsMap.get(secondLineItem).pci_code;
						updateLineItem.Item_Type_From_CAT__c = arcadiaProductsMap.get(secondLineItem).item_type;
						updateLineItem.NokiaCPQ_Unitary_Cost__c = arcadiaCost;
						updateLineItem.NokiaCPQ_Unitary_Cost_Initial__c = arcadiaCost;
						updateLineItem.Apttus_Config2__PricingStatus__c = 'Pending';
						lineItemsToUpdateList.add(updateLineItem);
					}
					arcadiaProductList.remove(existingLineItemMap.get(secondLineItem).Apttus_Config2__OptionId__c);
				}
			}
			
			if(!lineItemsToUpdateList.isEmpty()){
				system.debug('lineItemsToUpdateList**' + lineItemsToUpdateList);
				update lineItemsToUpdateList;
			}
			
			system.debug('arcadiaProductList**' + arcadiaProductList);
			if(!arcadiaProductList.isEmpty()){
				//Add options to main bundle
			
				Apttus_CPQApi.CPQ.ProductOptionGroupSearchResultDO result = Apttus_CPQApi.CPQWebService.getOptionGroupsForPriceListProduct(cartRecord.Apttus_Config2__PriceListId__c,mainBundleId);
			
				if(result.HasOptionGroups){
					List<Apttus_CPQApi.CPQ.ProductOptionGroupDO> prodOptGrpDOList = result.OptionGroups;
					system.debug('prodOptGrpDOList**' + prodOptGrpDOList);
					selectedOptDOList = addSelectedOptions(prodOptGrpDOList,arcadiaProductList,productAndQuantityMap,prodIdAndCodeMap,arcadiaAndCostMap,arcadiaProductsMap);
				}
			
				if(!selectedOptDOList.isEmpty()){
					Boolean IsPricePending = false;
					//Invoke the addOptions API and pass the cartID, selected product line number, and the Option List
					Apttus_CPQApi.CPQ.AddOptionsResponseDO addOptRespDO = Apttus_CPQApi.CPQWebService.addOptions(cartRecord.Id, Integer.valueOf(lineNumber), selectedOptDOList);
					
				   /* do{
						Apttus_CPQApi.CPQ.UpdatePriceRequestDO priceReqDO = new Apttus_CPQApi.CPQ.UpdatePriceRequestDO();
						priceReqDO.cartID = cartRecord.Id;
						Apttus_CPQApi.CPQ.UpdatePriceResponseDO priceRespDO = Apttus_CPQApi.CPQWebService.updatePriceForCart(priceReqDO); 
						IsPricePending = priceRespDO.IsPricePending;
						system.debug('IsPricePending :'+ IsPricePending);
				
					}while(IsPricePending);*/
				}
			}
		}
	}
	
	public static List<Apttus_CPQApi.CPQ.SelectedOptionDO> addSelectedOptions(List<Apttus_CPQApi.CPQ.ProductOptionGroupDO> prodOptGrpDOList, Set<String> arcadiaProductList, Map<String,Integer> productAndQuantityMap, Map<String,String> prodIdAndCodeMap, Map<String,Decimal> arcadiaAndCostMap, Map<String,CARTServiceData.bom_data> arcadiaProductsMap){
		for(Apttus_CPQApi.CPQ.ProductOptionGroupDO prodOptGrpDO : prodOptGrpDOList){
			//For an option group if a product has option components such as quantity execute the loop below
			system.debug('prodOptGrpDO**' + prodOptGrpDO);
			if(prodOptGrpDO.HasOptionComponents){
				List<Apttus_CPQApi.CPQ.ProductOptionComponentDO> prodOptCompDOList = new List<Apttus_CPQApi.CPQ.ProductOptionComponentDO>();
				prodOptCompDOList = prodOptGrpDO.OptionComponents;
				
				//Fetch all the option components for a particular option group.
				for(Apttus_CPQApi.CPQ.ProductOptionComponentDO prodOptCompDO :prodOptCompDOList ){
					system.debug('prodOptCompDO**' + prodOptCompDO);
					allOptionsList.add(prodOptCompDO.ComponentProductId);
					if(arcadiaProductList.contains(prodOptCompDO.ComponentProductId)){
						Apttus_CPQApi.CPQ.SelectedOptionDO selectedOptDO = new Apttus_CPQApi.CPQ.SelectedOptionDO();
						selectedOptDO.ComponentId = prodOptCompDO.ComponentId;
						selectedOptDO.ComponentProductId = prodOptCompDO.ComponentProductId;
						selectedOptDO.Quantity = productAndQuantityMap.get(prodIdAndCodeMap.get(prodOptCompDO.ComponentProductId));
						
						List<String> customFields = new List<String>();
						customFields.add('NokiaCPQ_Unitary_Cost__c');
						customFields.add('Item_Type_From_CAT__c');
						customFields.add('PCI_Code__c');
						customFields.add('NokiaCPQ_IsArcadiaBundle__c');
						customFields.add('NokiaCPQ_Unitary_Cost_Initial__c');
						selectedOptDO.CustomFields = customFields;
						
						Apttus_Config2__LineItem__c lineItemSo = new Apttus_Config2__LineItem__c();
						lineItemSo.NokiaCPQ_Unitary_Cost__c = arcadiaAndCostMap.get(prodOptCompDO.ComponentProductId);
						lineItemSo.NokiaCPQ_Unitary_Cost_Initial__c = arcadiaAndCostMap.get(prodOptCompDO.ComponentProductId);
						if(arcadiaProductsMap.get(prodIdAndCodeMap.get(prodOptCompDO.ComponentProductId)) != null){
							lineItemSo.Item_Type_From_CAT__c = arcadiaProductsMap.get(prodIdAndCodeMap.get(prodOptCompDO.ComponentProductId)).item_type;
							lineItemSo.PCI_Code__c = arcadiaProductsMap.get(prodIdAndCodeMap.get(prodOptCompDO.ComponentProductId)).pci_code;
						}
						if(!arcadiaBundleList.isEmpty() && arcadiaBundleList.contains(prodIdAndCodeMap.get(prodOptCompDO.ComponentProductId))){
							lineItemSo.NokiaCPQ_IsArcadiaBundle__c = true;
						}
						
						selectedOptDO.CustomData = lineItemSo;
						
						system.debug('selectedOptDO***' + selectedOptDOList);
						selectedOptDOList.add(selectedOptDO);
					}
				}
			}
			else if(prodOptGrpDO.HasChildOptionGroups){
				system.debug('prodOptGrpDO.ChildOptionGroups**' + prodOptGrpDO.ChildOptionGroups);
				return addSelectedOptions(prodOptGrpDO.ChildOptionGroups,arcadiaProductList,productAndQuantityMap,prodIdAndCodeMap,arcadiaAndCostMap,arcadiaProductsMap); 
			}
		}
		String missingProdIds = '';
		if(!allOptionsList.isEmpty()){
			for(String prodId : arcadiaProductList){
				if(!allOptionsList.contains(prodId)){
					missingProdIds = missingProdIds + prodIdAndCodeMap.get(prodId) + ',';
				}
			}
			system.debug('missingProdIds** ' + missingProdIds);
			if(String.isNotBlank(missingProdIds)){
				errorMessage = 'These Products are selected in CAT but not available in Apttus CPQ- ' + missingProdIds;
			}
		}
		
		system.debug('selectedOptDOList***' + selectedOptDOList);
		return selectedOptDOList;
	}
	
	public static void checkArcadiaItems(Map<String,Apttus_Config2__LineItem__c> existingLineItemMap, String mainBundleId, Decimal lineNumber, Apttus_Config2__ProductConfiguration__c cartRecord,List<CARTServiceData.bom_data> secondLevelList, Boolean isNewConfiguration){
		List<String> arcadiaProductList = new List<String>();
		List<Apttus_Config2__LineItem__c> itemsToDeleteList = new List<Apttus_Config2__LineItem__c>();
		
		//Logic for new and modified Arcadia & Delivery Items
		addArcadiaItems(mainBundleId,lineNumber, cartRecord,secondLevelList,isNewConfiguration);
		
		//Logic for Deleted Arcadia Items
		for(CARTServiceData.bom_data secondLineItem : secondLevelList){
			arcadiaProductList.add(secondLineItem.product_code);	
		}
		
		system.debug('arcadiaProductList**' + arcadiaProductList);
		//Check if any Arcadia has been deleted in this Configuration
		for(String lineItem : existingLineItemMap.keySet()){
			if(!arcadiaProductList.contains(lineItem)){
				itemsToDeleteList.add(existingLineItemMap.get(lineItem));
			}
		}
		system.debug('itemsToDeleteList**' + itemsToDeleteList);
		if(!itemsToDeleteList.isEmpty()){
			delete itemsToDeleteList;
		}
	}
	
	
	public static void insertAttachment(String parentId, List<Attachment> existingAttch, Blob payload){
		
		Attachment attach = new Attachment();
		attach.contentType = 'text/plain';
		attach.name = 'cfg_data.txt';
		attach.parentId = parentId;
		attach.body = payload;
		
		if(!existingAttch.isEmpty()){
			//First delete existing attachment/configuration
			Database.deleteResult[] delRes = Database.delete(existingAttch,false);
			for(Database.deleteResult dr : delRes){
				if(dr.isSuccess()){
					Database.insert(attach,false);
				}
			}
		}
		else{
			Database.insert(attach,false);
		}
		
	}
	
	@future
	public static void createDeliveryItems(List<String> bomDataList){
		List<Quote_Delivery_Sales_Item__c> insertSIList = new List<Quote_Delivery_Sales_Item__c>();
		List<Quote_Delivery_Sales_Item__c> existingDeliveryItems = new List<Quote_Delivery_Sales_Item__c>();
		String mainBundleLineItemId = '';
		String quoteId = '';
		if(!bomDataList.isEmpty()){
			for(String bomLine : bomDataList){
				DeliverySalesItems deliveryLineItem = (DeliverySalesItems) System.JSON.deserialize(bomLine, DeliverySalesItems.class);
				system.debug('deserialized data **' + deliveryLineItem);
				
				Quote_Delivery_Sales_Item__c salesItem = new Quote_Delivery_Sales_Item__c();
				salesItem.Name = deliveryLineItem.name;
				salesItem.Proposal__c = deliveryLineItem.quoteId;
				salesItem.Product_Code__c = deliveryLineItem.product_code;
				salesItem.PCI_Code__c = deliveryLineItem.pci_code;
				salesItem.Quantity__c = deliveryLineItem.quantity;
				salesItem.Arcadia_Product_Code__c = deliveryLineItem.arcadiaProductCode;
				salesItem.Item_Type__c = deliveryLineItem.item_type;
				salesItem.Parent_Line_Item__c = deliveryLineItem.parentLineItem;
				insertSIList.add(salesItem);
				mainBundleLineItemId = deliveryLineItem.parentLineItem;
				quoteId = deliveryLineItem.quoteId;
			}
			
			existingDeliveryItems = [Select Id From Quote_Delivery_Sales_Item__c Where Parent_Line_Item__c =: mainBundleLineItemId AND Proposal__c =:quoteId];
			system.debug('existingDeliveryItems**' + existingDeliveryItems);
			try{
				if(!existingDeliveryItems.isEmpty()){
					delete existingDeliveryItems;
				}
				
				if(!insertSIList.isEmpty()){
					insert insertSIList;					
				}
			}
			catch(Exception e){
				ExceptionHandler.addException(e,CartService.class.getName(),'Insert Delivery Sales Items');
			}
		}
	}
	
/*******************************
Method Name: createInterfaceLog
Description:  
Parameters: Quote/Proposal record id
*******************************/
public static void createInterfaceLog(String message, String productId, String bundleId){
		try{
			Interface_Log__c iLog = new Interface_Log__c(Interface_Type__c='CART Interface', //create interface type
														 Message_Type__c=GlobalConstants.INBOUND,
														 Number_of_Record_Processed__c=1,
														 Operation_type__c = 'Upsert',
														 Comment__c= message,
														 Name='CART Service Interface - CartId: '+productId +' ConfigId: '+bundleId);
			if(message.contains('Success')){
				iLog.status__c=GlobalConstants.SUCCESS;
				iLog.Number_of_Records_Success__c = 1;
				iLog.Number_of_Records_Errored__c= 0;
			}
			else{
				iLog.status__c=GlobalConstants.FAILURE;
				iLog.Number_of_Records_Success__c = 0;
				iLog.Number_of_Records_Errored__c= 1;
			}
			
			Database.SaveResult result = Database.insert(iLog,false);
			
		}Catch(Exception ex){
			ExceptionHandler.addException(ex,'CARTService','createInterfaceLog');
		}
	}
	
	public class DeliverySalesItems{
		public String product_code;
		public Integer quantity;
		public String pci_code;
		public String name;
		public String quoteId;
		public String arcadiaProductCode;
		public String item_type;
		public String parentLineItem;
	}
	
}