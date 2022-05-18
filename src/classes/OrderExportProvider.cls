public without sharing class OrderExportProvider{
		// map to get Category of PCI items (associated Options of Arcadia Products From Mapping object)
		public static Map<String, String> mapArcadiaProductOptionsAndPCICategory = new Map<String, String>();   
		public static String globalQuoteId;
		public static String strExternalSystemName;
		
		public static integer upfrontKeyIdCount = 1; 
		Public Static Map<Id,Product2> prodIdAndItemType = new Map<Id,Product2>();
		/*****************************
		*Class Name: OrderExportWrapper
		*Description: This Wrapper class is used to populate Alliance File. Using this wrapper, we creating the rcord for Object: Order_Export_Result_For_External_System__c
		*Parameters: 
		*******************************/	
		private class OrderExportWrapper{
			public Apttus_Proposal__Proposal_Line_Item__c objProposalLineItemRecord;
			public String strMainBundleCode;
			Public Quote_Delivery_Sales_Item__c objQDSIRecord;
			public String strArcadiaBundleCode;
			public Boolean validForConversion;
			public Boolean isArcadiaOption;
			public String productLevelCOorSLI;
			public OrderExportWrapper (Apttus_Proposal__Proposal_Line_Item__c currentRecord, String masterBundleCode, String arcadiaBundleCode, Boolean isValid, String coORsliLevel, Boolean arcadiaOption, Quote_Delivery_Sales_Item__c QDSIRecId){
				objProposalLineItemRecord = currentRecord;
				strMainBundleCode = masterBundleCode;
				strArcadiaBundleCode = arcadiaBundleCode;
				validForConversion = isValid;
				productLevelCOorSLI = coORsliLevel;
				isArcadiaOption = arcadiaOption;
				objQDSIRecord = QDSIRecId;
				
			}
		}
		
		/*****************************
		*Method Name: intiateExportForAllianceSystem
		*Description: Method is the intial step to start Alliance file generation process. This file is get called from the lightning component apex controller class.
		*Parameters: String: External System Name and Id: current quote Id
		*******************************/
		public static String intiateExportForAllianceSystem(String strExternalSystemName, Id quoteId){
			String finalresult;
			globalQuoteId = quoteId;
			// strExternalSystemName = strExternalSystemName;
			Boolean isEnovia = false;
			
			system.debug('External system-before'+strExternalSystemName);
			List<Apttus_Proposal__Proposal_Line_Item__c> listFinalizedLineItems = new List<Apttus_Proposal__Proposal_Line_Item__c>([SELECT Id,CMN__c,OEM__c,Apttus_QPConfig__ItemSequence__c, Name, NokiaCPQ_IsArcadiaBundle__c,Apttus_Proposal__Proposal__r.NokiaCPQ_Portfolio__c, PCI_Code__c, Apttus_Proposal__Proposal__r.CurrencyIsoCode, Apttus_QPConfig__OptionId__r.Arcadia_Replacement_Code__c, Total_Option_Quantity__c,Custom_Product_Code__c,NokiaCPQ_Quantity__c, Apttus_Proposal__Proposal__c, Apttus_QPConfig__BasePrice__c, NokiaCPQ_Product_Name__c, Apttus_QPConfig__ChargeType__c, NokiaCPQ_Item_Type__c, Product_Code__c, Apttus_Proposal__Unit_Price__c, Apttus_Proposal__Sales_Discount__c, Apttus_Proposal__Unit_Net_Price__c, Apttus_Proposal__Ext_Price__c, Apttus_Proposal__Ext_Net_Price__c, Apttus_Proposal__Service_Date__c, Apttus_QPConfig__LineType__c, Apttus_QPConfig__PrimaryLineNumber__c, Apttus_QPConfig__ParentBundleNumber__c, NokiaCPQ_Extended_IRP__c, NokiaCPQ_Unitary_IRP__c,  NokiaCPQ_Extended_CLP__c,  NokiaCPQ_Configuration_Type__c, Apttus_Proposal__Description__c, NokiaCPQ_ExtendedPrice_CNP__c, Apttus_QPConfig__Quantity2__c, Apttus_QPConfig__OptionId__r.NokiaCPQ_Item_Type__c, Apttus_QPConfig__LineNumber__c, Apttus_Proposal__Proposal__r.NokiaCPQ_Proposal_Id__c, Apttus_Proposal__Proposal__r.Name, Is_Dummy_Product__c, Apttus_Proposal__Product__r.NokiaCPQ_Source_System__c,Apttus_QPConfig__OptionId__r.NokiaCPQ_Source_System__c,ISP_Per_Unit__c,Product_Classification__c, NokiaCPQ_Product_Description__c,NokiaCPQ_Is_Direct_Option__c,Apttus_QPConfig__OptionId__r.Is_P20_Based_Product__c,Apttus_Proposal__Product__r.Is_P20_Based_Product__c,Sequence_Site_Id__c,NokiaCPQ_Opportunity_Site__r.Name,Alias_for_Exports__c,Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c,NokiaCPQ_Alias__c,Apttus_QPConfig__OptionId__c FROM Apttus_Proposal__Proposal_Line_Item__c WHERE Apttus_Proposal__Proposal__c =:quoteId ORDER BY Apttus_QPConfig__LineNumber__c ASC]);
					
	
			//system.debug('listFinalizedLineItems >>>>>'+listFinalizedLineItems);
			if(!listFinalizedLineItems.IsEmpty()){
				// Filter all Proposal Line Items based on Line Number. List<PLI> contains all the PLI belongs to same Line Number
				Map<Decimal, List<Apttus_Proposal__Proposal_Line_Item__c>> mapLineNumberListProposalLineItems = new Map<Decimal, List<Apttus_Proposal__Proposal_Line_Item__c>>();
				for(Apttus_Proposal__Proposal_Line_Item__c objProposalLineItem: listFinalizedLineItems){
					if(mapLineNumberListProposalLineItems.containsKey(objProposalLineItem.Apttus_QPConfig__LineNumber__c))
						mapLineNumberListProposalLineItems.get(objProposalLineItem.Apttus_QPConfig__LineNumber__c).Add(objProposalLineItem);
					else
						mapLineNumberListProposalLineItems.put(objProposalLineItem.Apttus_QPConfig__LineNumber__c, new List<Apttus_Proposal__Proposal_Line_Item__c> {objProposalLineItem});
				}
				// check and collect List<Apttus_Proposal__Proposal_Line_Item__c> for any Enovia item of main bundle configuration.
				List<Apttus_Proposal__Proposal_Line_Item__c> listEnoviaPLIs = new List<Apttus_Proposal__Proposal_Line_Item__c>();
				List<Apttus_Proposal__Proposal_Line_Item__c> listNonEnoviaPLIs = new List<Apttus_Proposal__Proposal_Line_Item__c>();
				if(!mapLineNumberListProposalLineItems.isEmpty()){
					
				  
					   for(Apttus_Proposal__Proposal_Line_Item__c objProposalLineItem: listFinalizedLineItems){
						   if((objProposalLineItem.Apttus_QPConfig__ChargeType__c.equalsIgnoreCase(Nokia_CPQ_Constants.STANDARD) && objProposalLineItem.NokiaCPQ_Configuration_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.BUNDLE) && objProposalLineItem.Apttus_QPConfig__ParentBundleNumber__c == Null 
						   && objProposalLineItem.Apttus_Proposal__Product__r.Is_P20_Based_Product__c==true) || (objProposalLineItem.Apttus_QPConfig__ChargeType__c.equalsIgnoreCase(Nokia_CPQ_Constants.STANDARD) 
							&& objProposalLineItem.NokiaCPQ_Configuration_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_STANDALONE) 
							 && objProposalLineItem.Apttus_QPConfig__ParentBundleNumber__c == Null &&
							   objProposalLineItem.Apttus_QPConfig__LineType__c.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_PRODUCT_SERVICES)
							  && objProposalLineItem.NokiaCPQ_Item_Type__c == Nokia_CPQ_Constants.SERVICE_STRING &&
							  objProposalLineItem.Product_Classification__c.equalsIgnoreCase('Deploy Services')) ){
							  listEnoviaPLIs.addAll(mapLineNumberListProposalLineItems.get(objProposalLineItem.Apttus_QPConfig__LineNumber__c));
							}
							else if(objProposalLineItem.Apttus_QPConfig__ChargeType__c.equalsIgnoreCase(Nokia_CPQ_Constants.STANDARD) && objProposalLineItem.NokiaCPQ_Configuration_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.BUNDLE) && objProposalLineItem.Apttus_QPConfig__ParentBundleNumber__c == Null && objProposalLineItem.Apttus_Proposal__Product__r.Is_P20_Based_Product__c== false){
							   
								listNonEnoviaPLIs.addAll(mapLineNumberListProposalLineItems.get(objProposalLineItem.Apttus_QPConfig__LineNumber__c));
								
							}
					   
					}
				}
			   
				Map<string,string> mapSiteCode= new Map<string,string>();
				set<string> setSiteCode = new set<string>();
				integer isitecount=0;
				// If PLI belongs to Enovia system
				if(!listEnoviaPLIs.isEmpty()){
					//  Generate CSP mapping for all PLI belongs to Enovia
					NokiaCPQ_CSP_Export_Generator.gernateExportCSP(listEnoviaPLIs,quoteId);
					// add code to generate Alliance code.
					Map<string, Map<NokiaCPQ_output_CSP_mapping__c, List<NokiaCPQ_output_CSP_mapping__c>>> mapAllianceExportRecords = new Map<string, Map<NokiaCPQ_output_CSP_mapping__c, List<NokiaCPQ_output_CSP_mapping__c>>>();
					Map<Id, NokiaCPQ_output_CSP_mapping__c> mapOutpoutCSPMappingobj = new Map<Id, NokiaCPQ_output_CSP_mapping__c>([Select Id, Name, NokiaCPQ_Proposal_Line_Item__c, Item_Level__c,Item_Type__c,NokiaCPQ_Customer_Material_Number__c,NokiaCPQ_Parent_PCI__c,QuoteId__c,PCI_Type__c,NokiaCPQ_Parent_Proposal_Line_Item__c,Position__c,ProductID__c,NokiaCPQ_code__c,NokiaCPQ_Serial_Number__c, QuoteId__r.Name,NokiaCPQ_Parent_PCI__r.NokiaCPQ_code__c, Quantity__c, NokiaCPQ_Proposal_Line_Item__r.NokiaCPQ_Opportunity_Site__r.Name, NokiaCPQ_Proposal_Line_Item__r.Apttus_Proposal__Description__c, ISP_per_unit__c, Parent_Position__c, QuoteId__r.NokiaCPQ_Proposal_Id__c, FOC_flag__c, NokiaCPQ_Parent_Proposal_Line_Item__r.Apttus_Proposal__Product__r.Name, NokiaCPQ_Parent_Proposal_Line_Item__r.Apttus_Proposal__Product__r.ProductCode, NokiaCPQ_Parent_PCI__r.NokiaCPQ_Customer_Material_Number__c,NokiaCPQ_Proposal_Line_Item__r.Sequence_Site_Id__c,NokiaCPQ_Parent_Proposal_Line_Item__r.Sequence_Site_Id__c,NokiaCPQ_Proposal_Line_Item__r.Product_Classification__c,NokiaCPQ_Parent_PCI__r.Quantity__c from NokiaCPQ_output_CSP_mapping__c where QuoteId__c=:quoteId  ORDER BY NokiaCPQ_Serial_Number__c ASC LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]);
					
					// Generate Map from CSP Output object to process results for Alliance export.
					// Map contains: Map<CustMaterialNumber, Map<Parent_CSPOutput, List<CSP_OutputRec>>>
					// Map<CustMaterialNumber, Map<Parent_CSPOutput_Level1, List<CSP_OutputRec_Level2>>>
					mapAllianceExportRecords = getCPSOutputForAllianceProcess(quoteId, mapOutpoutCSPMappingobj);
					
					//Collect Site informations from CSP Output records level 2
					// use this list to query Product2 and collect Description field value to populate in Alliance file for Quote Delivery Sales Items product codes.
					List<String> listProductCode = new List<String>();
					List<String> listPCICode = new List<String>();
				   // System.debug('mapOutpoutCSPMappingobj--->'+mapOutpoutCSPMappingobj.values);
					for(NokiaCPQ_output_CSP_mapping__c objMapping : mapOutpoutCSPMappingobj.values()){
					  setSiteCode.add(objMapping.NokiaCPQ_Proposal_Line_Item__r.NokiaCPQ_Opportunity_Site__r.Name);
					// if(objMapping.NokiaCPQ_Proposal_Line_Item__c == null){
					 if(objMapping.Item_Level__c == 2){
						  listProductCode.add(objMapping.NokiaCPQ_code__c);
					  }
					  if(objMapping.Item_Level__c == 1){
						  listPCICode.add(objMapping.NokiaCPQ_code__c);
					  }
					}
					listProductCode.addAll(listPCICode);
					for(string strSiteCode : setSiteCode)
					{
						isitecount++;
						mapSiteCode.put(strSiteCode,string.valueof(isitecount));
					}
					isitecount++;
					mapSiteCode.put(Nokia_CPQ_Constants.DUMMY,string.valueof(isitecount));
					
					// collect Additional Mapping values for Alliance export
					Map<String, Additional_Mapping_For_Alliance__c> mapAdditionalMappingAlliance = new Map<String, Additional_Mapping_For_Alliance__c>();
					for(Additional_Mapping_For_Alliance__c objAddMapping: [SELECT Id, Main_Product_Code__c, Business_Unit__c, Product_acronym__c, Product_Line_Profit_Center__c, Product_release_acronym__c, Sourcing_Unit__c, What_Group_1__c FROM Additional_Mapping_For_Alliance__c]){
						mapAdditionalMappingAlliance.put(objAddMapping.Main_Product_Code__c, objAddMapping);
						
					}
					
					//collect product description from product2 object.
					Map<String, String> mapProductCodeProdName = new Map<String, String>();
					Map<String, String> mapProductCodeANDItemType = new Map<String, String>();
					if(!listProductCode.isEmpty() && listProductCode !=null){
						for(Product2 objProd : [SELECT Id, ProductCode,NokiaCPQ_Item_Type__c, Name FROM Product2 WHERE ProductCode =: listProductCode]){
							if(objProd.ProductCode != null){
								mapProductCodeProdName.put(objProd.ProductCode, objProd.Name);
								
								mapProductCodeANDItemType.put(objProd.ProductCode, objProd.NokiaCPQ_Item_Type__c);
							}
						}
					}
					// send data to generate Alliance Output object records.
					generateAllianceRecordWithPCIMapping(mapAllianceExportRecords,mapSiteCode, mapAdditionalMappingAlliance, mapProductCodeProdName,mapProductCodeANDItemType);
					finalresult = Nokia_CPQ_Constants.ALLIANCE_EXPORT_SUCCESS_STRING;
					
				}
				if(!listNonEnoviaPLIs.isEmpty()){
					gernateAllianceOrder(listNonEnoviaPLIs, strExternalSystemName,globalQuoteId);		  
					finalresult = Nokia_CPQ_Constants.ALLIANCE_EXPORT_SUCCESS_STRING;
				}
			}
			else
				finalresult = Nokia_CPQ_Constants.ALLIANCE_EXPORT_ERROR_MESSAGE_STRING ;
			
			
			return finalresult ;
		}
		
		
		
		/*****************************
		*Method Name: generateAllianceRecordWithPCIMapping
		*Description: 
		*			
		*Parameters: 
		*******************************/
		public static void generateAllianceRecordWithPCIMapping(Map<string, Map<NokiaCPQ_output_CSP_mapping__c, List<NokiaCPQ_output_CSP_mapping__c>>> mapAllianceExportRecords,Map<string,string> mapSiteCode, Map<String, Additional_Mapping_For_Alliance__c> mapAdditionalMappingAlliance, Map<String, String> mapProductCodeProdName,Map<String,String> mapProductCodeANDItemType){
			List<Order_Export_Result_For_External_System__c> listFinalAllianceOutput = new List<Order_Export_Result_For_External_System__c>();
			Integer siteCode = 0;
			
			//Iterate on CUstomer Material Number of CSP Output rec as Key.
			for(String mainCoProd: mapAllianceExportRecords.keySet()){
				Map<NokiaCPQ_output_CSP_mapping__c, List<NokiaCPQ_output_CSP_mapping__c>> mapPCIAndSIList = new Map<NokiaCPQ_output_CSP_mapping__c, List<NokiaCPQ_output_CSP_mapping__c>>();
				mapPCIAndSIList = mapAllianceExportRecords.get(mainCoProd);  
							
				// Iterate on CSP Output object level 1 records
				for(NokiaCPQ_output_CSP_mapping__c objPCIRecs : mapPCIAndSIList.keyset()){
					// add this list at the end of 2nd loop so, CO line will come first and SLI after that.
					List<Order_Export_Result_For_External_System__c> listOutPutForSIs = new List<Order_Export_Result_For_External_System__c>();
					Decimal priceForCO=0;
					String strSiteCode;
					String siteDescription;
					String strItemType;
					Decimal priceForFOCCSPOutputRec = 0;
					String strFOCFlag;
					// Check main bundle product of CSP Output rec. having and Addinal mapping or not for Alliance.
				   // Additional_Mapping_For_Alliance__c objAddMapping = new Additional_Mapping_For_Alliance__c();
					Additional_Mapping_For_Alliance__c objAddMapping ;
					if(mapAdditionalMappingAlliance.containsKey(objPCIRecs.NokiaCPQ_Parent_Proposal_Line_Item__r.Apttus_Proposal__Product__r.ProductCode))
						
						objAddMapping = new Additional_Mapping_For_Alliance__c();
						objAddMapping = mapAdditionalMappingAlliance.get(objPCIRecs.NokiaCPQ_Parent_Proposal_Line_Item__r.Apttus_Proposal__Product__r.ProductCode);
					
					// Iterate on CSP Output rec level 2.
					for(NokiaCPQ_output_CSP_mapping__c objSIs : mapPCIAndSIList.get(objPCIRecs)){
						// collecting sum of all CSP Output rec level2 price for Total Price at CO level record in Alliance file.					
						// Added condition FOC condition : D-12880
						 
						if(objSIs.NokiaCPQ_Proposal_Line_Item__r.Product_Classification__c == 'Deploy Services' &&  objAddMapping == null  ){
						
							//for gs deploy service to collect addition mapping for airscal bundle
							 objAddMapping = mapAdditionalMappingAlliance.get('AirScaleWiFi');
						}   
						
						if(objSIs.ISP_per_unit__c!= NULL && String.isBlank(objSIs.FOC_flag__c) && objSIs.Quantity__c!=null  && 
				objSIs.NokiaCPQ_Parent_PCI__r.Quantity__c != null){
							//priceForCO += objSIs.ISP_per_unit__c;
				priceForCO += (objSIs.Quantity__c/objSIs.NokiaCPQ_Parent_PCI__r.Quantity__c)*objSIs.ISP_per_unit__c;
						}
						
						
						/******* logic to fill site id and description from quote LI for cross odering products ************/
						
						if(objSIs.NokiaCPQ_Proposal_Line_Item__r.Sequence_Site_Id__c != Null){
							strSiteCode = String.valueOf(objSIs.NokiaCPQ_Proposal_Line_Item__r.Sequence_Site_Id__c);
						}
						if(objSIs.NokiaCPQ_Proposal_Line_Item__r.NokiaCPQ_Opportunity_Site__r.Name != Null){
							siteDescription = objSIs.NokiaCPQ_Proposal_Line_Item__r.NokiaCPQ_Opportunity_Site__r.Name;
						}
						else{
							siteDescription = 'Site'+' '+strSiteCode;
						}
						//Nokia_CPQ_Constants.DUMMY
					
						
						//strItemType = objSIs.Item_Type__c;
						if(mapProductCodeANDItemType.get(objSIs.NokiaCPQ_code__c) != null){
							strItemType = mapProductCodeANDItemType.get(objSIs.NokiaCPQ_code__c);
							
						}
						
						// Collecting Alliance output record for SLI level
						listOutPutForSIs.add(recordPreprationForAllianceWithCSP(objSIs,objSIs.Item_Type__c, Nokia_CPQ_Constants.ALLIANCE_EXPORT_PRODUCT_TYPE_SLI, strSiteCode, null,mapSiteCode, objAddMapping, Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE, mapProductCodeProdName,siteDescription));
						upfrontKeyIdCount++ ;
					}
					// required 
					priceForCO = priceForCO.setScale(2, RoundingMode.HALF_UP);
					// Add co Line 
					// check if CSP Output record with FOC flag price is same as total price for CO line.
					if(priceForCO == 0 || priceForCO == 0.00)
						strFOCFlag = Nokia_CPQ_Constants.ENGLISH_ALPHABET_Y;
					else
						strFOCFlag = Nokia_CPQ_Constants.ENGLISH_ALPHABET_N ;
					System.debug('objPCIRecs--->'+objPCIRecs);
					// collect data for CO level record.
					
					String itemTypeOfPCI;
					system.debug('--PCI Code---'+ objPCIRecs.NokiaCPQ_code__c + '--Item Type --'+ mapProductCodeANDItemType.get(objPCIRecs.NokiaCPQ_code__c));
					if(mapProductCodeANDItemType.get(objPCIRecs.NokiaCPQ_code__c) !=null){
						 itemTypeOfPCI =  mapProductCodeANDItemType.get(objPCIRecs.NokiaCPQ_code__c);
					}
					
					listFinalAllianceOutput.add(recordPreprationForAllianceWithCSP(objPCIRecs,itemTypeOfPCI, Nokia_CPQ_Constants.ALLIANCE_EXPORT_PRODUCT_TYPE_CO, strSiteCode, priceForCO,mapSiteCode, objAddMapping, strFOCFlag, mapProductCodeProdName,siteDescription));
					// Add SLI line now
					listFinalAllianceOutput.addAll(listOutPutForSIs);
					upfrontKeyIdCount++ ;
					
				}
			}
			
			if(listFinalAllianceOutput!=null){
				database.insert(listFinalAllianceOutput, false);
			}
		}
		
		/*****************************
		*Method Name: recordPreprationForAllianceWithCSP
		*Description: . 
		*Parameters: 
		*******************************/ 
		public static Order_Export_Result_For_External_System__c recordPreprationForAllianceWithCSP(NokiaCPQ_output_CSP_mapping__c objSIsPCIs,string strItemType, String strCOTypeOrSLIType, string siteCode, Decimal priceForCO,map<string,string> mapSiteCode, Additional_Mapping_For_Alliance__c objAddMapping, String strFOCFlag, Map<String, String> mapProductCodeProdName,String siteDescription){
			Order_Export_Result_For_External_System__c objExport = new Order_Export_Result_For_External_System__c();
			// generate record based on condition
			if(strCOTypeOrSLIType == Nokia_CPQ_Constants.ALLIANCE_EXPORT_PRODUCT_TYPE_CO){
				objExport.Item_type__c = Nokia_CPQ_Constants.ALLIANCE_EXPORT_PRODUCT_TYPE_CO;
				objExport.Product_Level__c = Nokia_CPQ_Constants.ALLIANCE_EXPORT_PRODUCT_LEVEL_ONE;
				objExport.Item_description__c = objSIsPCIs.NokiaCPQ_Customer_Material_Number__c;
			   
				//Nik 
			   /* if(mapProductCodeProdName.get(objSIsPCIs.NokiaCPQ_code__c) !=null){
					objExport.Item_description__c = mapProductCodeProdName.get(objSIsPCIs.NokiaCPQ_code__c);
				}*/
				objExport.Customer_Item_Code__c = objSIsPCIs.NokiaCPQ_Customer_Material_Number__c;
			   // objExport.Customer_Item_Code__c = objSIsPCIs.NokiaCPQ_code__c;
				objExport.Quantity__c = objSIsPCIs.Quantity__c;
				objExport.Price_per_unit__c = priceForCO;
				objExport.FOC_flag__c = strFOCFlag;
				
				String whtConfigId = objSIsPCIs.QuoteId__r.Name.right(objSIsPCIs.QuoteId__r.Name.length()-2)+'.'+objSIsPCIs.NokiaCPQ_Parent_Proposal_Line_Item__r.Sequence_Site_Id__c;
				
				String finalconfigId;
				
					if(!String.isBlank(whtConfigId) && whtConfigId.length()>10){
						integer i= whtConfigId.length()-10;
						finalconfigId  = whtConfigId.left(0)+whtConfigId.right(whtConfigId.length()-0-i);
					}else{
						finalconfigId = objSIsPCIs.QuoteId__r.Name.right(objSIsPCIs.QuoteId__r.Name.length()-2)+'.'+objSIsPCIs.NokiaCPQ_Parent_Proposal_Line_Item__r.Sequence_Site_Id__c;
					}
				 
				
				if(strItemType == Nokia_CPQ_Constants.SOFTWARE_STRING){
					objExport.Item_code__c = Nokia_CPQ_Constants.ALLIANCE_EXPORT_ITEM_CODE_FOR_SW ;
				   // objExport.What_Configuration_ID__c = objSIsPCIs.QuoteId__r.Name.right(objSIsPCIs.QuoteId__r.Name.length()-2)+'.'+objSIsPCIs.NokiaCPQ_Parent_Proposal_Line_Item__r.Sequence_Site_Id__c+'.'+3;
				   
					objExport.What_Configuration_ID__c = finalconfigId+'.'+3;
				   
				}
				else if(strItemType == Nokia_CPQ_Constants.HARDWARE_STRING ){
					objExport.Item_code__c = Nokia_CPQ_Constants.ALLIANCE_EXPORT_ITEM_CODE_FOR_HW;
				   // objExport.What_Configuration_ID__c = objSIsPCIs.QuoteId__r.Name.right(objSIsPCIs.QuoteId__r.Name.length()-2)+'.'+objSIsPCIs.NokiaCPQ_Parent_Proposal_Line_Item__r.Sequence_Site_Id__c+'.'+1;
					objExport.What_Configuration_ID__c = finalconfigId+'.'+1;
				}
				else if(strItemType == Nokia_CPQ_Constants.SERVICE_STRING ){
					objExport.Item_code__c = Nokia_CPQ_Constants.ALLIANCE_EXPORT_ITEM_CODE_FOR_OHER_SERVICES;
					if(objSIsPCIs.NokiaCPQ_Parent_Proposal_Line_Item__r.Sequence_Site_Id__c !=null){
						   // objExport.What_Configuration_ID__c = objSIsPCIs.QuoteId__r.Name.right(objSIsPCIs.QuoteId__r.Name.length()-2)+'.'+objSIsPCIs.NokiaCPQ_Parent_Proposal_Line_Item__r.Sequence_Site_Id__c+'.'+2;
						
						objExport.What_Configuration_ID__c = finalconfigId+'.'+2;
						
					}
					else{
						 String configId = objSIsPCIs.QuoteId__r.Name.right(objSIsPCIs.QuoteId__r.Name.length()-2)+'.'+siteCode+'.'+2;
						
						if(!String.isBlank(configId) && configId.length()>12){
						integer i= configId.length()-12;
						objExport.What_Configuration_ID__c = configId.left(0)+configId.right(configId.length()-0-i);
						}
						else{
						objExport.What_Configuration_ID__c = objSIsPCIs.QuoteId__r.Name.right(objSIsPCIs.QuoteId__r.Name.length()-2)+'.'+siteCode+'.'+2;
						}
						
					
					
					   // objExport.What_Configuration_ID__c = objSIsPCIs.QuoteId__r.Name.right(objSIsPCIs.QuoteId__r.Name.length()-2)+'.'+siteCode+'.'+2;
					}
					
				}
				else {
					objExport.Item_code__c = Nokia_CPQ_Constants.ALLIANCE_EXPORT_ITEM_CODE_FOR_HW;
					//objExport.What_Configuration_ID__c = objSIsPCIs.QuoteId__r.Name.right(objSIsPCIs.QuoteId__r.Name.length()-2)+'.'+objSIsPCIs.NokiaCPQ_Parent_Proposal_Line_Item__r.Sequence_Site_Id__c+'.'+4;		   
					objExport.What_Configuration_ID__c = finalconfigId+'.'+4;			
				}
				//objExport.PO_Item_text__c = 'PCI;'+objSIsPCIs.NokiaCPQ_Parent_PCI__r.NokiaCPQ_code__c+';'+ objSIsPCIs.Parent_Position__c +';'+objSIsPCIs.Quantity__c;
				objExport.Quote_Id__c = globalQuoteId;
				objExport.External_System_Name__c = Nokia_CPQ_Constants.QUOTE_EXTERNAL_TARGET_SYSTEM_ALLIANCE ;
				/*objExport.Site_code__c =  mapSiteCode.get(siteCode);
				objExport.Site_description__c = siteCode;*/ 
				objExport.Site_code__c =  siteCode;
				objExport.Site_description__c = siteDescription;				
				
				
				objExport.Upfront_name__c = Nokia_CPQ_Constants.NOKIA_SCPQ;
				objExport.Upfront_reference_ID__c = objSIsPCIs.QuoteId__r.NokiaCPQ_Proposal_Id__c;
				objExport.Upfront_reference_edition__c =Nokia_CPQ_Constants.ALLIANCE_EXPORT_PRODUCT_LEVEL_ONE;
				objExport.Upfront_line_key_ID__c = gernerateUpFrontLineKey(objSIsPCIs.id, Nokia_CPQ_Constants.ALLIANCE_EXPORT_PRODUCT_TYPE_CO, upfrontKeyIdCount);
				//objExport.Product_acronym__c = 'AIRSCALE WIFI';
				
				if(objAddMapping != null){
					objExport.What_Group_1__c = objAddMapping.What_Group_1__c ; 
					objExport.Sourcing_Unit__c = objAddMapping.Sourcing_Unit__c;
					objExport.Product_Line_Profit_Center__c = objAddMapping.Product_Line_Profit_Center__c;
					objExport.Product_acronym__c = objAddMapping.Product_acronym__c;
					objExport.Product_release_acronym__c= objAddMapping.Product_release_acronym__c;
					objExport.Business_Unit__c = objAddMapping.Business_Unit__c;
				}
				else {
					objExport.Product_acronym__c = objSIsPCIs.NokiaCPQ_Parent_Proposal_Line_Item__r.Apttus_Proposal__Product__r.Name.toUpperCase();
					objExport.Product_release_acronym__c = Nokia_CPQ_Constants.ALL;
				}
				
			}// for SLI level
			else {
				objExport.Item_type__c = Nokia_CPQ_Constants.ALLIANCE_EXPORT_PRODUCT_TYPE_SLI;
				objExport.Product_Level__c = Nokia_CPQ_Constants.TWO_YEAR_STRING;
				if(String.IsBlank(objSIsPCIs.NokiaCPQ_Proposal_Line_Item__r.Apttus_Proposal__Description__c))
					objExport.Item_description__c = mapProductCodeProdName.get(objSIsPCIs.NokiaCPQ_code__c);
				else
					objExport.Item_description__c = objSIsPCIs.NokiaCPQ_Proposal_Line_Item__r.Apttus_Proposal__Description__c;
				//objExport.Customer_Item_Code__c = custItemCode;
				objExport.Quantity__c = objSIsPCIs.Quantity__c;
				//objExport.Price_per_unit__c = perUnitPrice;
				//objExport.FOC_flag__c = objSIsPCIs.FOC_flag__c
				objExport.Item_code__c = objSIsPCIs.NokiaCPQ_code__c;
				objExport.PO_Item_text__c = Nokia_CPQ_Constants.PCI_SEMICOLON+objSIsPCIs.NokiaCPQ_Parent_PCI__r.NokiaCPQ_code__c+Nokia_CPQ_Constants.SEMICOLON_STRING+ objSIsPCIs.Parent_Position__c +Nokia_CPQ_Constants.SEMICOLON_STRING+objSIsPCIs.Quantity__c;
				objExport.Quote_Id__c = globalQuoteId;
				objExport.External_System_Name__c = Nokia_CPQ_Constants.QUOTE_EXTERNAL_TARGET_SYSTEM_ALLIANCE ;
				/*objExport.Site_code__c = mapSiteCode.get(siteCode);
				objExport.Site_description__c = siteCode;*/
				objExport.Site_code__c =  siteCode;
				objExport.Site_description__c = siteDescription;  
				
				
				String whtConfigId = objSIsPCIs.QuoteId__r.Name.right(objSIsPCIs.QuoteId__r.Name.length()-2)+'.'+objSIsPCIs.NokiaCPQ_Parent_Proposal_Line_Item__r.Sequence_Site_Id__c;
				
				String finalconfigId;
				
					if(!String.isBlank(whtConfigId) && whtConfigId.length()>10){
						integer i= whtConfigId.length()-10;
						finalconfigId  = whtConfigId.left(0)+whtConfigId.right(whtConfigId.length()-0-i);
					}
					else{
						finalconfigId = objSIsPCIs.QuoteId__r.Name.right(objSIsPCIs.QuoteId__r.Name.length()-2)+'.'+objSIsPCIs.NokiaCPQ_Parent_Proposal_Line_Item__r.Sequence_Site_Id__c;
					}
				
				
				//objExport.What_Configuration_ID__c = objSIsPCIs.QuoteId__r.Name.right(objSIsPCIs.QuoteId__r.Name.length()-2);
				
				if(strItemType == Nokia_CPQ_Constants.SOFTWARE_STRING){
				   // objExport.What_Configuration_ID__c = objSIsPCIs.QuoteId__r.Name.right(objSIsPCIs.QuoteId__r.Name.length()-2)+'.'+objSIsPCIs.NokiaCPQ_Parent_Proposal_Line_Item__r.Sequence_Site_Id__c+'.'+3;
				   objExport.What_Configuration_ID__c = finalconfigId+'.'+3;
				}
				else if(strItemType == Nokia_CPQ_Constants.HARDWARE_STRING ){
				   // objExport.What_Configuration_ID__c = objSIsPCIs.QuoteId__r.Name.right(objSIsPCIs.QuoteId__r.Name.length()-2)+'.'+objSIsPCIs.NokiaCPQ_Parent_Proposal_Line_Item__r.Sequence_Site_Id__c+'.'+1;
					objExport.What_Configuration_ID__c = finalconfigId+'.'+1;
				}
				else if(strItemType == Nokia_CPQ_Constants.SERVICE_STRING ){
					if(objSIsPCIs.NokiaCPQ_Parent_Proposal_Line_Item__r.Sequence_Site_Id__c != null){
						
						//objExport.What_Configuration_ID__c = objSIsPCIs.QuoteId__r.Name.right(objSIsPCIs.QuoteId__r.Name.length()-2)+'.'+objSIsPCIs.NokiaCPQ_Parent_Proposal_Line_Item__r.Sequence_Site_Id__c+'.'+2;
						
						objExport.What_Configuration_ID__c = finalconfigId+'.'+2;
					}
					else{
						String configId = objSIsPCIs.QuoteId__r.Name.right(objSIsPCIs.QuoteId__r.Name.length()-2)+'.'+siteCode+'.'+2;
						
						if(!String.isBlank(configId) && configId.length()>12){
						integer i= configId.length()-12;
						objExport.What_Configuration_ID__c =  configId.left(0)+configId.right(configId.length()-0-i);
						}
						else{
						objExport.What_Configuration_ID__c = objSIsPCIs.QuoteId__r.Name.right(objSIsPCIs.QuoteId__r.Name.length()-2)+'.'+siteCode+'.'+2;
						}
						
						
					   // objExport.What_Configuration_ID__c = objSIsPCIs.QuoteId__r.Name.right(objSIsPCIs.QuoteId__r.Name.length()-2)+'.'+siteCode+'.'+2;
					}
				}
				else
					//objExport.What_Configuration_ID__c = objSIsPCIs.QuoteId__r.Name.right(objSIsPCIs.QuoteId__r.Name.length()-2)+'.'+objSIsPCIs.NokiaCPQ_Parent_Proposal_Line_Item__r.Sequence_Site_Id__c+'.'+4;
				
				objExport.What_Configuration_ID__c = finalconfigId+'.'+4;
				
				objExport.Upfront_name__c = Nokia_CPQ_Constants.NOKIA_SCPQ;
				objExport.Upfront_reference_ID__c = objSIsPCIs.QuoteId__r.NokiaCPQ_Proposal_Id__c;
				objExport.Upfront_reference_edition__c =Nokia_CPQ_Constants.ALLIANCE_EXPORT_PRODUCT_LEVEL_ONE;
				objExport.Upfront_line_key_ID__c = gernerateUpFrontLineKey(objSIsPCIs.id, Nokia_CPQ_Constants.ALLIANCE_EXPORT_PRODUCT_TYPE_SLI, upfrontKeyIdCount);
				//objExport.Product_acronym__c = 'AIRSCALE WIFI';
				if(objAddMapping != null){
					objExport.What_Group_1__c = objAddMapping.What_Group_1__c ; 
					objExport.Sourcing_Unit__c = objAddMapping.Sourcing_Unit__c;
					objExport.Product_Line_Profit_Center__c = objAddMapping.Product_Line_Profit_Center__c;
					objExport.Product_acronym__c = objAddMapping.Product_acronym__c;
					objExport.Product_release_acronym__c= objAddMapping.Product_release_acronym__c;
					objExport.Business_Unit__c = objAddMapping.Business_Unit__c;
				}
				else {
					objExport.Product_acronym__c = objSIsPCIs.NokiaCPQ_Parent_Proposal_Line_Item__r.Apttus_Proposal__Product__r.Name.toUpperCase();
					objExport.Product_release_acronym__c = Nokia_CPQ_Constants.ALL;
				}
			}
			return objExport;
		}
		
		
		
		
		/*****************************
		*Method Name: getCPSOutputForAllianceProcess
		*Description: Method is used to collect all CSP output in Map for further process
		*			
		*Parameters: Quote Id, Map<Id, NokiaCPQ_output_CSP_mapping__c>
		*******************************/
		public static Map<string, Map<NokiaCPQ_output_CSP_mapping__c, List<NokiaCPQ_output_CSP_mapping__c>>> getCPSOutputForAllianceProcess(Id quoteId, Map<Id, NokiaCPQ_output_CSP_mapping__c> mapOutpoutCSPMappingobj){	  
			
			system.debug('mapOutpoutCSPMappingobj.size()>>>>'+mapOutpoutCSPMappingobj.size());			
			Map<Id, List<NokiaCPQ_output_CSP_mapping__c>> mapGroupPCIslist = new Map<Id, List<NokiaCPQ_output_CSP_mapping__c>>();			  
			Map<string, Map<NokiaCPQ_output_CSP_mapping__c, List<NokiaCPQ_output_CSP_mapping__c>>> mapAllianceExportRecords = new Map<string, Map<NokiaCPQ_output_CSP_mapping__c, List<NokiaCPQ_output_CSP_mapping__c>>>();
			
			for(NokiaCPQ_output_CSP_mapping__c mapCSPOutputObject: mapOutpoutCSPMappingobj.values())
			{
				system.debug('mapCSPOutputObject.NokiaCPQ_Parent_PCI__c>>>>'+mapCSPOutputObject.ISP_per_unit__c);
				// collect only level 2 records from output object..
				if(mapCSPOutputObject.NokiaCPQ_Parent_PCI__c != NULL && mapCSPOutputObject.Item_Level__c == 2){
					
					if(mapGroupPCIslist.containsKey(mapCSPOutputObject.NokiaCPQ_Parent_PCI__c))
						mapGroupPCIslist.get(mapCSPOutputObject.NokiaCPQ_Parent_PCI__c).Add(mapCSPOutputObject);
					else
						mapGroupPCIslist.put(mapCSPOutputObject.NokiaCPQ_Parent_PCI__c, new List<NokiaCPQ_output_CSP_mapping__c>{mapCSPOutputObject});
					
				}
				
			}	  
			
			
			system.debug('mapGroupPCIslist>>>>'+mapGroupPCIslist);
			for(NokiaCPQ_output_CSP_mapping__c mapCSPOutputObject: mapOutpoutCSPMappingobj.values())
			{   
				// filter level 0 record from output object
				if(mapCSPOutputObject.NokiaCPQ_Parent_PCI__c == NULL && mapCSPOutputObject.Item_Level__c !=0){
					if(mapAllianceExportRecords.containsKey(mapCSPOutputObject.NokiaCPQ_Customer_Material_Number__c)){						
						Map<NokiaCPQ_output_CSP_mapping__c, List<NokiaCPQ_output_CSP_mapping__c>> innerMap = new Map<NokiaCPQ_output_CSP_mapping__c, List<NokiaCPQ_output_CSP_mapping__c>>();
						
						innerMap = mapAllianceExportRecords.get(mapCSPOutputObject.NokiaCPQ_Customer_Material_Number__c);
						system.debug('1.....innerMap>>>'+innerMap);
						system.debug('2.....mapGroupPCIslist.get(mapCSPOutputObject.Id)>>>'+mapGroupPCIslist.get(mapCSPOutputObject.Id));
						innerMap.put(mapOutpoutCSPMappingobj.get(mapCSPOutputObject.Id), mapGroupPCIslist.get(mapCSPOutputObject.Id));
						
						mapAllianceExportRecords.put(mapCSPOutputObject.NokiaCPQ_Customer_Material_Number__c, innerMap);
					}
					else{
						Map<NokiaCPQ_output_CSP_mapping__c, List<NokiaCPQ_output_CSP_mapping__c>> innerMap = new Map<NokiaCPQ_output_CSP_mapping__c, List<NokiaCPQ_output_CSP_mapping__c>>();
						system.debug('3.....mapGroupPCIslist.get(mapCSPOutputObject.Id)>>>'+mapGroupPCIslist.get(mapCSPOutputObject.Id));
						innerMap.put(mapOutpoutCSPMappingobj.get(mapCSPOutputObject.Id), mapGroupPCIslist.get(mapCSPOutputObject.Id));
						
						mapAllianceExportRecords.put(mapCSPOutputObject.NokiaCPQ_Customer_Material_Number__c, innerMap);	
						
					}
				}
			}
					
			system.debug('mapAllianceExportRecords>>>>>'+mapAllianceExportRecords);
			return mapAllianceExportRecords;		
		}
		
		
		
		/*****************************
		*Method Name: gernateAllianceOrder
		*Description: Method Accept different parameters and perform the operations/logic, to identify the nested Map of Parent Bundles and its related Option.
		*			Collect existing mapping and created nested Map based on main bundle, Arcadia bundle & its options.
		*			Perform data creation of Order_Export_Result_For_External_System__c object and perform DML as final output for file body.
		*Parameters: List<Apttus_Proposal__Proposal_Line_Item__c>: list of perposal line items AND String: External System Name
		*******************************/
		public static void gernateAllianceOrder(List<Apttus_Proposal__Proposal_Line_Item__c> listFinalizedLineItems, String strExternalSystemName, Id quoteId ){
			System.debug('inside gernateAllianceOrder');
			// Map Arcadia Prod Code & Subordinate Options..
			Map<Decimal, Map<String, List<OrderExportWrapper>>> mapFinalOrderExportRecords = new Map<Decimal, Map<String, List<OrderExportWrapper>>>();
			
			// collect the Main Bundle and its primary line no. map
			Map<Decimal, Apttus_Proposal__Proposal_Line_Item__c> mapParentBundleLineNoAndItsRecord = new Map<Decimal, Apttus_Proposal__Proposal_Line_Item__c>();
			
			Map<String, Map<String, Map<String, List<String>>>> finalMapMainBundleAndItsSuboridinateTillMappingOptions = new Map<String, Map<String, Map<String, List<String>>>>(); 
			List<Order_Export_Result_For_External_System__c> listFinalOrderExportToInsert = new List<Order_Export_Result_For_External_System__c>();
			
		  
			
			try{
				   Map<id,Quote_Delivery_Sales_Item__c> mapQuoteIdAndQDSIRec = new Map<id,Quote_Delivery_Sales_Item__c>([SELECT Id,  Parent_Line_Item__r.Apttus_Config2__LineNumber__c ,Quantity__c,Item_Type__c,PCI_Code__c,Parent_Line_Item__c,Proposal__c,Proposal__r.Name,Proposal__r.NokiaCPQ_Proposal_Id__c,Product_Code__c,Arcadia_Product_Code__c,Parent_Line_Item__r.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c FROM Quote_Delivery_Sales_Item__c where Proposal__c =: quoteId LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]);
				   
				   Set<String>  setArcadiaBundle = new Set<String>();
				   Set<String>  setOptProdCode = new Set<String>();
				   for(Quote_Delivery_Sales_Item__c qdsiRec: mapQuoteIdAndQDSIRec.values()){
					   
					   setArcadiaBundle.add(qdsiRec.Arcadia_Product_Code__c);
					   setOptProdCode.add(qdsiRec.Product_Code__c);
				   }
				   setOptProdCode.addAll(setArcadiaBundle);
				   System.debug('setArcadiaBundle-->'+setArcadiaBundle);
				   
				   Map<String,String> mapProdcodeANDDescription = new Map<String,String>();
				   Map<String,Product2> mapProdcodeANDId = new Map<String,Product2>();
				   for(Product2 prod: [select Id,NokiaCPQ_Item_Type__c,ProductCode,Name,Description from Product2 where ProductCode in:setOptProdCode and ProductCode!= null LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]){
					   
					   mapProdcodeANDDescription.put(prod.ProductCode,prod.Name);
				
						mapProdcodeANDId.put(prod.ProductCode,prod);
						prodIdAndItemType.put(prod.Id,prod);
				
					}
				 
				 //RID :6582 Added setArcadiaBundle.contains(objLineItem.Product_Code__c) to include bundle of NWS
				// filter main Bundel & Arcadia Bundle records.
				for(Apttus_Proposal__Proposal_Line_Item__c objLineItem : listFinalizedLineItems){
					
						if((objLineItem.Apttus_QPConfig__ChargeType__c.equalsIgnoreCase(Nokia_CPQ_Constants.STANDARD) &&  objLineItem.NokiaCPQ_Configuration_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.BUNDLE) && objLineItem.Apttus_Proposal__Product__r.Is_P20_Based_Product__c==false) ||
						(objLineItem.Apttus_QPConfig__ChargeType__c.equalsIgnoreCase(Nokia_CPQ_Constants.STANDARD) &&  objLineItem.NokiaCPQ_Configuration_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.BUNDLE)
					  && setArcadiaBundle.contains(objLineItem.Product_Code__c))){
							mapParentBundleLineNoAndItsRecord.put(objLineItem.Apttus_QPConfig__PrimaryLineNumber__c, objLineItem);
						}
				 }
				
			  // Collect additional mapping
				Map<String, Additional_Mapping_For_Alliance__c> additionalMapping = new Map<String, Additional_Mapping_For_Alliance__c>();
				for(Additional_Mapping_For_Alliance__c objAdditionalMap: [SELECT Business_Unit__c, Main_Product_Code__c, Product_acronym__c, Product_Line_Profit_Center__c, Product_release_acronym__c, Sourcing_Unit__c, What_Group_1__c FROM Additional_Mapping_For_Alliance__c LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]){
					additionalMapping.put(objAdditionalMap.Main_Product_Code__c, objAdditionalMap);
				}
				
				// Collect mapping for Alliance order export			   
				finalMapMainBundleAndItsSuboridinateTillMappingOptions = getMappingStructureForAlliance();
				
				mapFinalOrderExportRecords = identifyAllianceExportProductLineItems(mapParentBundleLineNoAndItsRecord, finalMapMainBundleAndItsSuboridinateTillMappingOptions, listFinalizedLineItems,quoteId,mapQuoteIdAndQDSIRec,mapProdcodeANDId);
				
				system.debug('>>>>>>>mapFinalOrderExportRecords>>>>'+mapFinalOrderExportRecords.size());
				
				
				If(!mapFinalOrderExportRecords.IsEmpty()){
					System.debug('Main Bundle---->'+mapFinalOrderExportRecords.keySet());
					for(Decimal lineNum : mapFinalOrderExportRecords.keySet()){
						Map<String, List<OrderExportWrapper>> arcadiaBundleListWrapper = new Map<String, List<OrderExportWrapper>>();
						arcadiaBundleListWrapper= mapFinalOrderExportRecords.get(lineNum);
					   
						for(String strArcadia : arcadiaBundleListWrapper.keySet()){
							List<OrderExportWrapper> listOrderWrapper = new List<OrderExportWrapper>();
							listOrderWrapper = arcadiaBundleListWrapper.get(strArcadia);
							System.debug('listOrderWrapper--->'+listOrderWrapper);
							for(OrderExportWrapper objOrderExportWrapper : listOrderWrapper){
								// All Arcadia's Options							
								if(objOrderExportWrapper.isArcadiaOption){
									
								  
									//RID :6582 : setting value of description for arcadia bundle
									String ProdDescription;
									if(mapProdcodeANDDescription.get(objOrderExportWrapper.objQDSIRecord.Product_Code__c) != null){
									   ProdDescription = mapProdcodeANDDescription.get(objOrderExportWrapper.objQDSIRecord.Product_Code__c);
									}
								   listFinalOrderExportToInsert.addAll(gernerateRecForSLILevel(finalMapMainBundleAndItsSuboridinateTillMappingOptions, objOrderExportWrapper, additionalMapping,ProdDescription));
									
									system.debug('Inside Arcadia Option Final rec >>>>>>'+listFinalOrderExportToInsert);
								}
								// All Arcadia and Direct Options
								else{
									
									// need to check the record is Arcadia or direct option.
									// if direct option, create a SLI record too.
									//RID :6582: setArcadiaBundle.contains(objOrderExportWrapper.objProposalLineItemRecord.Product_Code__c) for Arcadia Bundle 
									if(objOrderExportWrapper.objProposalLineItemRecord.NokiaCPQ_Configuration_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.BUNDLE) || setArcadiaBundle.contains(objOrderExportWrapper.objProposalLineItemRecord.Product_Code__c)){
										// inside Arcadia bundle condition.
										// inside generateRecForCOLevel method, sps & non-sps check is present
										listFinalOrderExportToInsert.add(generateRecForCOLevel(objOrderExportWrapper, additionalMapping));
										system.debug('Inside Arcadia Bundle Final rec >>>>>>'+listFinalOrderExportToInsert);
									}
									// Direct Options of main bundle
									else {
										// generate CO level record for Direct Optionsi
										listFinalOrderExportToInsert.add(generateRecForCOLevel(objOrderExportWrapper, additionalMapping));
										system.debug('Inside Direct Option Final rec CO >>>>>>'+listFinalOrderExportToInsert);
										// Generate SLI level record
										System.debug('SLI Check->'+objOrderExportWrapper.objProposalLineItemRecord.Product_Code__c);
										
										String ProdDescription = mapProdcodeANDDescription.get(objOrderExportWrapper.objQDSIRecord.Product_Code__c);
										
										listFinalOrderExportToInsert.addAll(gernerateRecForSLILevel(finalMapMainBundleAndItsSuboridinateTillMappingOptions, objOrderExportWrapper, additionalMapping,ProdDescription));
								   
										system.debug('Inside Direct Option Final rec SLI >>>>>>'+listFinalOrderExportToInsert);
									}							  
							}						  
							}
						}
					}
					
					system.debug('>>Final List to Insert>>>'+listFinalOrderExportToInsert);
					if(!listFinalOrderExportToInsert.IsEmpty())
						Database.insert(listFinalOrderExportToInsert);
				}
				
			}
			catch(Exception e){
				ExceptionHandler.addException(e,OrderExportProvider.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
			}
		}
		
		/*****************************
		*Method Name: gernerateRecForSLILevel
		*Description: Used to get the Order_Export_Result_For_External_System__c object record instance. This function is only used to generate record for the SLI level. 
		*Parameters: OrderExportWrapper:
		RID:6582 :  Added Parameter- ProdDescription
		*******************************/ 
		public static List<Order_Export_Result_For_External_System__c> gernerateRecForSLILevel(Map<String, Map<String, Map<String, List<String>>>> finalMapMainBundleAndItsSuboridinateTillMappingOptions,OrderExportWrapper objOrderExportWrapper, Map<String, Additional_Mapping_For_Alliance__c> additionalMapping, String ProdDescription){
			List<Order_Export_Result_For_External_System__c> finalExportResult = new List<Order_Export_Result_For_External_System__c>();
			
			Map<String, Map<String, List<String>>> arcadiaMapping = new Map<String, Map<String, List<String>>>();						  
			Map<String, List<String>> arcadiaOptionsMapping = new Map<String, List<String>>();
			List<String> listConvertedOptions = new List<String>();
			String itemCode;
			System.debug('Main Bundle--->'+objOrderExportWrapper.strMainBundleCode);
			
			if(finalMapMainBundleAndItsSuboridinateTillMappingOptions.containsKey(objOrderExportWrapper.strMainBundleCode)){			
				arcadiaMapping = finalMapMainBundleAndItsSuboridinateTillMappingOptions.get(objOrderExportWrapper.strMainBundleCode);   
				
				System.debug('arcadiaMapping--->'+arcadiaMapping);
				if(arcadiaMapping.containsKey(objOrderExportWrapper.strArcadiaBundleCode)){			   
					arcadiaOptionsMapping = arcadiaMapping.get(objOrderExportWrapper.strArcadiaBundleCode); 
  
					if(arcadiaOptionsMapping.containsKey(objOrderExportWrapper.objProposalLineItemRecord.Product_Code__c)){
						system.debug('>>>> Option of Arcadia in Cart ::::'+objOrderExportWrapper.objProposalLineItemRecord.Product_Code__c);
						listConvertedOptions = arcadiaOptionsMapping.get(objOrderExportWrapper.objProposalLineItemRecord.Product_Code__c);
						system.debug('>>>> Option mapping of Arcadia option from mapping::::'+listConvertedOptions);
					}
					// add same product code if mapping do not exists
					else
						listConvertedOptions.add(objOrderExportWrapper.objProposalLineItemRecord.Product_Code__c);
				}
				else if(arcadiaMapping.containsKey(objOrderExportWrapper.objProposalLineItemRecord.Product_Code__c)){
					// Mapping having same mapping at each level (level 1 & level 2)
					listConvertedOptions = (arcadiaMapping.get(objOrderExportWrapper.objProposalLineItemRecord.Product_Code__c)).get(objOrderExportWrapper.objProposalLineItemRecord.Product_Code__c);
				}
				// add same product code if mapping do not exists
				else
					listConvertedOptions.add(objOrderExportWrapper.objProposalLineItemRecord.Product_Code__c);
			}
			System.debug('Inside SLI record generate function>>>>'+listConvertedOptions);
					
			if(!listConvertedOptions.IsEmpty()){
				// itterate over the mapped value and generate records.
				Integer sizeOfMappedProducts = listConvertedOptions.size();
				for(String strConvertedOptions : listConvertedOptions){		  
					itemCode = strConvertedOptions;			 
					finalExportResult.add(recordPreprationForSLI(itemCode, objOrderExportWrapper, additionalMapping, sizeOfMappedProducts,ProdDescription));
					sizeOfMappedProducts = sizeOfMappedProducts -1 ;
				}
			}
			// for non converted SLI (Direct & Arcaida options
			else {
				//RID:6582 to poulate item code for arcadia options.
				
				if(objOrderExportWrapper.objProposalLineItemRecord.Product_Code__c != null){
					
					itemCode= objOrderExportWrapper.objProposalLineItemRecord.Product_Code__c;
				}
				else{
				   
					itemCode =objOrderExportWrapper.objQDSIRecord.Product_Code__c;
				}
				
				
				finalExportResult.add(recordPreprationForSLI(itemCode, objOrderExportWrapper, additionalMapping, 1,ProdDescription));
			} 
			
			return finalExportResult;
		}
		
		/*****************************
		*Method Name: recordPreprationForSLI
		*Description: Used to get the Order_Export_Result_For_External_System__c object record instance. This function is only used to generate record for the SLI level. 
		*Parameters: itemCode, OrderExportWrapper, additionalMapping
		*******************************/ 
		public static Order_Export_Result_For_External_System__c recordPreprationForSLI(String itemCode, OrderExportWrapper objOrderExportWrapper, Map<String, Additional_Mapping_For_Alliance__c> additionalMapping, Integer sizeOfMappedProducts,String prodDescription){
			// Variables
			String businessUnit;
			String productAcronym;
			String profitCenter;
			String prodReleaseAcronym;
			String siteCode;
			String siteDescription;
			String sourcingUnit;
			String upfrontLineKey;
			String upfrontName;
			String UpfrontReferenceID;
			String UpfrontReferenceEdition;
			String whatConfigId;
			String whatId;
			Decimal unitaryCNP;
			Decimal unitaryCNPAfterRounding;
			
			
			//generate WhatConfig ID based on the Item Type add numeric suffix (for HW = 1; Service = 2; SW=3)
			String tempWhatConfigId;
		   if(!String.isBlank(objOrderExportWrapper.objProposalLineItemRecord.Apttus_Proposal__Proposal__r.Name)){
			 tempWhatConfigId = (objOrderExportWrapper.objProposalLineItemRecord.Apttus_Proposal__Proposal__r.Name).substringAfter('-');
			}
			else{
				tempWhatConfigId = (objOrderExportWrapper.objQDSIRecord.Proposal__r.Name).substringAfter('-');
				
			}
		   
	   
			if((!String.isBlank(objOrderExportWrapper.objProposalLineItemRecord.Apttus_QPConfig__OptionId__r.NokiaCPQ_Item_Type__c) &&( objOrderExportWrapper.objProposalLineItemRecord.Apttus_QPConfig__OptionId__r.NokiaCPQ_Item_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.SOFTWARE_STRING)) )||( prodIdAndItemType.containsKey(objOrderExportWrapper.objProposalLineItemRecord.Apttus_QPConfig__OptionId__c) &&   prodIdAndItemType.get(objOrderExportWrapper.objProposalLineItemRecord.Apttus_QPConfig__OptionId__c).NokiaCPQ_Item_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.SOFTWARE_STRING)) ){
				
			 tempWhatConfigId = tempWhatConfigId+'.'+objOrderExportWrapper.objProposalLineItemRecord.Sequence_Site_Id__c+'.'+Nokia_CPQ_Constants.THREE_YEAR_STRING;
			}
			else if((!String.isBlank(objOrderExportWrapper.objProposalLineItemRecord.Apttus_QPConfig__OptionId__r.NokiaCPQ_Item_Type__c) &&( objOrderExportWrapper.objProposalLineItemRecord.Apttus_QPConfig__OptionId__r.NokiaCPQ_Item_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.HARDWARE_STRING))) ||( prodIdAndItemType.containsKey(objOrderExportWrapper.objProposalLineItemRecord.Apttus_QPConfig__OptionId__c)&& prodIdAndItemType.get(objOrderExportWrapper.objProposalLineItemRecord.Apttus_QPConfig__OptionId__c).NokiaCPQ_Item_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.HARDWARE_STRING)) ){
				 
			 tempWhatConfigId = tempWhatConfigId+'.'+objOrderExportWrapper.objProposalLineItemRecord.Sequence_Site_Id__c+'.'+Nokia_CPQ_Constants.ONE_YEAR_STRING ;
			 }
			 
			 else if((!String.isBlank(objOrderExportWrapper.objProposalLineItemRecord.Apttus_QPConfig__OptionId__r.NokiaCPQ_Item_Type__c) &&( objOrderExportWrapper.objProposalLineItemRecord.Apttus_QPConfig__OptionId__r.NokiaCPQ_Item_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.SERVICE_STRING))) || (prodIdAndItemType.containsKey(objOrderExportWrapper.objProposalLineItemRecord.Apttus_QPConfig__OptionId__c)&&  prodIdAndItemType.get(objOrderExportWrapper.objProposalLineItemRecord.Apttus_QPConfig__OptionId__c).NokiaCPQ_Item_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.SERVICE_STRING)) ){
				  
					tempWhatConfigId = tempWhatConfigId+'.'+objOrderExportWrapper.objProposalLineItemRecord.Sequence_Site_Id__c+'.'+Nokia_CPQ_Constants.TWO_YEAR_STRING;
				  
			 }
			   else{
				tempWhatConfigId = tempWhatConfigId+'.'+objOrderExportWrapper.objProposalLineItemRecord.Sequence_Site_Id__c+'.'+4;
			   }
			
			// Add secondray mapping for SLIs
			if(additionalMapping.containsKey(objOrderExportWrapper.strMainBundleCode)){   
				profitCenter= additionalMapping.get(objOrderExportWrapper.strMainBundleCode).Product_Line_Profit_Center__c; 
				businessUnit = additionalMapping.get(objOrderExportWrapper.strMainBundleCode).Business_Unit__c; 
				sourcingUnit= additionalMapping.get(objOrderExportWrapper.strMainBundleCode).Sourcing_Unit__c;
				whatId= additionalMapping.get(objOrderExportWrapper.strMainBundleCode).What_Group_1__c;	  
				productAcronym = additionalMapping.get(objOrderExportWrapper.strMainBundleCode).Product_acronym__c;
				prodReleaseAcronym = additionalMapping.get(objOrderExportWrapper.strMainBundleCode).Product_release_acronym__c;
			}
			
			// Set these columns for all SLIs
			/*siteCode = Nokia_CPQ_Constants.ALLIANCE_EXPORT_PRODUCT_LEVEL_ONE;
			siteDescription = Nokia_CPQ_Constants.NOKIA_SCPQ; */ 
			 
			/* **************** logic for Non Crossing SiteId and Description from quote LI ************/ 
			
			if(objOrderExportWrapper.objProposalLineItemRecord.Sequence_Site_Id__c!=null){
				 siteCode = String.valueOf(objOrderExportWrapper.objProposalLineItemRecord.Sequence_Site_Id__c);
				
			}
			if(objOrderExportWrapper.objProposalLineItemRecord.NokiaCPQ_Opportunity_Site__r.Name !=null){
				siteDescription = objOrderExportWrapper.objProposalLineItemRecord.NokiaCPQ_Opportunity_Site__r.Name ;
			 }
			else{
				 System.debug('siteCode-inside else-->'+siteCode);
				 siteDescription= 'Site'+' '+siteCode;
			 }
			
			if(objOrderExportWrapper.objProposalLineItemRecord.id !=null)   {	  
				upfrontLineKey=gernerateUpFrontLineKey(objOrderExportWrapper.objProposalLineItemRecord.id, Nokia_CPQ_Constants.ALLIANCE_EXPORT_PRODUCT_TYPE_SLI,sizeOfMappedProducts);
			 }
			 else{
				 upfrontLineKey=gernerateUpFrontLineKey(objOrderExportWrapper.objQDSIRecord.id, Nokia_CPQ_Constants.ALLIANCE_EXPORT_PRODUCT_TYPE_SLI,sizeOfMappedProducts);
			}
			upfrontName= Nokia_CPQ_Constants.NOKIA_SCPQ; 
			if(objOrderExportWrapper.objProposalLineItemRecord.Apttus_Proposal__Proposal__r.NokiaCPQ_Proposal_Id__c != null){
				UpfrontReferenceID = objOrderExportWrapper.objProposalLineItemRecord.Apttus_Proposal__Proposal__r.NokiaCPQ_Proposal_Id__c;
			}
			else{
				
				UpfrontReferenceID = objOrderExportWrapper.objQDSIRecord.Proposal__r.NokiaCPQ_Proposal_Id__c;
			}
			UpfrontReferenceEdition = Nokia_CPQ_Constants.ALLIANCE_EXPORT_PRODUCT_LEVEL_ONE;   
			//whatConfigId = tempWhatConfigId;
			
			
			if(!String.isBlank(tempWhatConfigId) && tempWhatConfigId.length()>12){
				
				integer i= tempWhatConfigId.length()-12;
				whatConfigId = tempWhatConfigId.left(0)+tempWhatConfigId.right(tempWhatConfigId.length()-0-i);
				
			}
			else{
				whatConfigId = tempWhatConfigId;
				
				
			}
			
			
			//RID: 6582 : to populate description for arcadia bundle
			String Description;
			if(objOrderExportWrapper.objProposalLineItemRecord.Apttus_Proposal__Description__c != null){
				Description = objOrderExportWrapper.objProposalLineItemRecord.Apttus_Proposal__Description__c;
				
			}
			else{
				Description =  prodDescription;
			}
		   
			return generateAllianceOrderExportRecord(Nokia_CPQ_Constants.ALLIANCE_EXPORT_PRODUCT_TYPE_SLI, Nokia_CPQ_Constants.ALLIANCE_EXPORT_PRODUCT_LEVEL_TWO, Description, NULL, objOrderExportWrapper.objProposalLineItemRecord.Total_Option_Quantity__c, NULL, itemCode, NULL, businessUnit, productAcronym, profitCenter, prodReleaseAcronym, siteCode, siteDescription, sourcingUnit, upfrontLineKey, upfrontName, whatConfigId, whatId, UpfrontReferenceID, UpfrontReferenceEdition);
		}
		
		public static String gernerateUpFrontLineKey (string sfdcId, String level, Integer sizeOfMapping){
			return sfdcId + '-'+level+'-'+sizeOfMapping;
		}
		
		/*****************************
		*Method Name: generateRecForCOLevel
		*Description: Used to get the Order_Export_Result_For_External_System__c object record instance. This function is only used to generate record for the Arcadia & Direct options at 'CO' level. 
		*Parameters: OrderExportWrapper: object instance of OrderExportWrapper, Map<String, Additional_Mapping_For_Alliance__c> additionalMapping
		*******************************/	
		public static Order_Export_Result_For_External_System__c generateRecForCOLevel(OrderExportWrapper objOrderExportWrapper, Map<String, Additional_Mapping_For_Alliance__c> additionalMapping){
			String businessUnit;
			String productAcronym;
			String profitCenter;
			String prodReleaseAcronym;
			String siteCode;
			String siteDescription;
			String sourcingUnit;
			String upfrontLineKey;
			String upfrontName;
			String UpfrontReferenceID;
			String UpfrontReferenceEdition;
			String whatConfigId;
			String whatId;
			String itemCode;
			Decimal unitaryCNP;
			Decimal unitaryCNPAfterRounding;
		   
			// Calculate price per unit for Arcadia & Direct Option.
			if(objOrderExportWrapper.objProposalLineItemRecord.Apttus_QPConfig__Quantity2__c != NULL && objOrderExportWrapper.objProposalLineItemRecord.Apttus_QPConfig__Quantity2__c != 0){
				unitaryCNP = objOrderExportWrapper.objProposalLineItemRecord.NokiaCPQ_ExtendedPrice_CNP__c / objOrderExportWrapper.objProposalLineItemRecord.Apttus_QPConfig__Quantity2__c ;			 
				unitaryCNPAfterRounding = unitaryCNP.setScale(2, RoundingMode.HALF_UP);
			}
			else
				unitaryCNPAfterRounding = 0.00;
				
			  
			String tempWhatConfigId = (objOrderExportWrapper.objProposalLineItemRecord.Apttus_Proposal__Proposal__r.Name).substringAfter('-');
			// generate Item Code for Arcadia & Direct Option. based on the Item Type field value from Product2.
			// Generate WHAT Config Id based on the Item Type field value from Product2
		   
			
			if(!String.isBlank(objOrderExportWrapper.objProposalLineItemRecord.Apttus_QPConfig__OptionId__r.NokiaCPQ_Item_Type__c) && objOrderExportWrapper.objProposalLineItemRecord.Apttus_QPConfig__OptionId__r.NokiaCPQ_Item_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.SOFTWARE_STRING)){
				
				itemCode = Nokia_CPQ_Constants.ALLIANCE_EXPORT_ITEM_CODE_FOR_SW ;
				tempWhatConfigId = tempWhatConfigId+'.'+objOrderExportWrapper.objProposalLineItemRecord.Sequence_Site_Id__c+'.'+3;
			}
			else if(!String.isBlank(objOrderExportWrapper.objProposalLineItemRecord.Apttus_QPConfig__OptionId__r.NokiaCPQ_Item_Type__c) && objOrderExportWrapper.objProposalLineItemRecord.Apttus_QPConfig__OptionId__r.NokiaCPQ_Item_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.HARDWARE_STRING)){
				itemCode = Nokia_CPQ_Constants.ALLIANCE_EXPORT_ITEM_CODE_FOR_HW ;
				tempWhatConfigId = tempWhatConfigId+'.'+objOrderExportWrapper.objProposalLineItemRecord.Sequence_Site_Id__c+'.'+1;
			}
			else if(!String.isBlank(objOrderExportWrapper.objProposalLineItemRecord.Apttus_QPConfig__OptionId__r.NokiaCPQ_Item_Type__c) && objOrderExportWrapper.objProposalLineItemRecord.Apttus_QPConfig__OptionId__r.NokiaCPQ_Item_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.SERVICE_STRING)){
				itemCode = Nokia_CPQ_Constants.ALLIANCE_EXPORT_ITEM_CODE_FOR_OHER_SERVICES;
				tempWhatConfigId = tempWhatConfigId+'.'+objOrderExportWrapper.objProposalLineItemRecord.Sequence_Site_Id__c+'.'+2;
			}
			else{
				itemCode = Nokia_CPQ_Constants.ALLIANCE_EXPORT_ITEM_CODE_FOR_HW ;
				tempWhatConfigId = tempWhatConfigId+'.'+objOrderExportWrapper.objProposalLineItemRecord.Sequence_Site_Id__c+'.'+4;
			}
			
			
			if(String.isBlank(itemCode)){
				
				itemCode = objOrderExportWrapper.objProposalLineItemRecord.Apttus_QPConfig__OptionId__r.NokiaCPQ_Item_Type__c;
						
				
			}
			
			// populate below columns if 2nd mapping exists.
			if(additionalMapping.containsKey(objOrderExportWrapper.strMainBundleCode)){
				profitCenter= additionalMapping.get(objOrderExportWrapper.strMainBundleCode).Product_Line_Profit_Center__c; 
				businessUnit = additionalMapping.get(objOrderExportWrapper.strMainBundleCode).Business_Unit__c; 
				sourcingUnit= additionalMapping.get(objOrderExportWrapper.strMainBundleCode).Sourcing_Unit__c;
				whatId= additionalMapping.get(objOrderExportWrapper.strMainBundleCode).What_Group_1__c;	  
				productAcronym = additionalMapping.get(objOrderExportWrapper.strMainBundleCode).Product_acronym__c;
				prodReleaseAcronym = additionalMapping.get(objOrderExportWrapper.strMainBundleCode).Product_release_acronym__c;		 
			}
			
			// Set these columns for all SLIs
			
			if(objOrderExportWrapper.objProposalLineItemRecord.Sequence_Site_Id__c!=null){
				 siteCode = String.valueOf(objOrderExportWrapper.objProposalLineItemRecord.Sequence_Site_Id__c);
				
			}
			
			 if(objOrderExportWrapper.objProposalLineItemRecord.NokiaCPQ_Opportunity_Site__r.Name !=null){
				siteDescription = objOrderExportWrapper.objProposalLineItemRecord.NokiaCPQ_Opportunity_Site__r.Name ;
			 }
			 else{
			   
				 siteDescription= 'Site'+' '+siteCode;
			 }
			
			upfrontLineKey=gernerateUpFrontLineKey(objOrderExportWrapper.objProposalLineItemRecord.id, Nokia_CPQ_Constants.ALLIANCE_EXPORT_PRODUCT_TYPE_CO, 1);
			upfrontName= Nokia_CPQ_Constants.NOKIA_SCPQ; 
			UpfrontReferenceID = objOrderExportWrapper.objProposalLineItemRecord.Apttus_Proposal__Proposal__r.NokiaCPQ_Proposal_Id__c;
			UpfrontReferenceEdition = Nokia_CPQ_Constants.ALLIANCE_EXPORT_PRODUCT_LEVEL_ONE;   
			if(!String.isBlank(tempWhatConfigId) && tempWhatConfigId.length()>12){
				
				integer i= tempWhatConfigId.length()-12;
				whatConfigId = tempWhatConfigId.left(0)+tempWhatConfigId.right(tempWhatConfigId.length()-0-i);
				
			}
			else{
				whatConfigId = tempWhatConfigId;
			}
			 return generateAllianceOrderExportRecord(objOrderExportWrapper.productLevelCOorSLI, Nokia_CPQ_Constants.ALLIANCE_EXPORT_PRODUCT_LEVEL_ONE, objOrderExportWrapper.objProposalLineItemRecord.Apttus_Proposal__Description__c, objOrderExportWrapper.objProposalLineItemRecord.Product_Code__c, objOrderExportWrapper.objProposalLineItemRecord.Total_Option_Quantity__c, unitaryCNPAfterRounding, itemCode, NULL, businessUnit, productAcronym, profitCenter, prodReleaseAcronym, siteCode, siteDescription, sourcingUnit, upfrontLineKey, upfrontName, whatConfigId, whatId, UpfrontReferenceID, UpfrontReferenceEdition);
		   
		}
		
		/*****************************
		*Method Name: generateAllianceOrderExportRecord
		*Description: Used to get the Order_Export_Result_For_External_System__c object record instance. It is used for Non-SPS & SPS both type products.
		*		  for SPS product, we pass parameters to this method after performing operation on data .
		*Parameters: 
		*******************************/
		public static Order_Export_Result_For_External_System__c generateAllianceOrderExportRecord(String itemType, String level, String itemDescrption, String custItemCode, Decimal quantity, Decimal perUnitPrice, String itemCode, String poItemText, String businessUnit, String productAcronym, String profitCenter, String prodReleaseAcronym, String siteCode, String siteDescription, String sourcingUnit, String upfrontLineKey, String upfrontName, String whatConfigId, String whatId, String UpfrontReferenceID, String UpfrontReferenceEdition){
			
			Order_Export_Result_For_External_System__c objExport = new Order_Export_Result_For_External_System__c();
			
			objExport.Item_type__c = itemType;
			objExport.Product_Level__c = level;
			//objExport.Item_description__c = itemDescrption;
		   // objExport.Customer_Item_Code__c = custItemCode;
		   objExport.Item_description__c = itemDescrption;
			objExport.Customer_Item_Code__c = custItemCode;
			objExport.Quantity__c = quantity;
			objExport.Price_per_unit__c = perUnitPrice;
			if(itemType == Nokia_CPQ_Constants.ALLIANCE_EXPORT_PRODUCT_TYPE_CO){
				if(perUnitPrice <= 0)
					objExport.FOC_flag__c = 'Y';
				else
					objExport.FOC_flag__c = 'N';
			}
			objExport.Item_code__c = itemCode;
			objExport.PO_Item_text__c = poItemText;
			objExport.Quote_Id__c = globalQuoteId;
			objExport.External_System_Name__c = Nokia_CPQ_Constants.QUOTE_EXTERNAL_TARGET_SYSTEM_ALLIANCE ;
			objExport.Business_Unit__c = businessUnit;
			objExport.Product_acronym__c = productAcronym;
			objExport.Product_Line_Profit_Center__c = profitCenter;
			objExport.Product_release_acronym__c = prodReleaseAcronym;
			objExport.Site_code__c = siteCode;
			objExport.Site_description__c = siteDescription;
			objExport.Sourcing_Unit__c = sourcingUnit;
			objExport.Upfront_line_key_ID__c = upfrontLineKey;
			objExport.Upfront_name__c = upfrontName;
			objExport.What_Configuration_ID__c = whatConfigId;
			objExport.What_Group_1__c = whatId;
			objExport.Upfront_reference_ID__c = UpfrontReferenceID;
			objExport.Upfront_reference_edition__c = UpfrontReferenceEdition;
			return objExport;
		}
		
		/*****************************
		*Method Name: identifyAllianceExportProductLineItems
		*Description: function to collect the Proposal Line items which will get included for Alliance export file. Inside this method we creating a Map
		*		  with Arcadia Prod Code and list of wrapper class instance (which we will use at CO and SLI level in our export file).
		*		  the return value we using to populate the final record for 'Order_Export_Result_For_External_System__c' with the serial order of Arcadia & its subordinate SIs.
		*Parameters: 
		*******************************/
		public static Map<Decimal, Map<String, List<OrderExportWrapper>>> identifyAllianceExportProductLineItems(Map<Decimal, Apttus_Proposal__Proposal_Line_Item__c> mapParentBundleAndProdLineItem, Map<String, Map<String, Map<String, List<String>>>> finalMapMainBundleAndItsSuboridinateMappingOptions, List<Apttus_Proposal__Proposal_Line_Item__c> listFinalizedLineItems,Id quoteId,Map<id,Quote_Delivery_Sales_Item__c> mapQuoteIdAndQDSIRec,Map<String,Product2> mapProdcodeANDId){
		
		System.debug('mapProdcodeANDId--->'+mapProdcodeANDId);
			
			// Map Line number, Arcadia Prod Code/direct SI & Subordinate Options..
			// for direct option of SPS & non SPS products add additional SLI line with same direct option's product code
			Map<Decimal, Map<String, List<OrderExportWrapper>>> mapFinalOrderExportRecords = new Map<Decimal, Map<String, List<OrderExportWrapper>>>();
			System.debug('mapQuoteIdAndQDSIRec--->'+mapQuoteIdAndQDSIRec);
			
			try{
				String strMainBundelProdCode;
				String arcadiaBundleCode;
				Decimal lineNumber;
				Map<String,List<Quote_Delivery_Sales_Item__c>>  mapQDSIArcadiaBundleAndOptions= new Map<String,List<Quote_Delivery_Sales_Item__c>>();
			  
				Map<String,String> mapArcadiaANDOptionCOde = new Map<String,String>();
				
				/********** map of arcadia bundle and options ***********/
			for(Quote_Delivery_Sales_Item__c  qdsiRec : mapQuoteIdAndQDSIRec.values()){
				if(qdsiRec.Parent_Line_Item__r.Apttus_Config2__LineNumber__c !=null){
					if(mapQDSIArcadiaBundleAndOptions.containskey(qdsiRec.Arcadia_Product_Code__c+'-'+qdsiRec.Parent_Line_Item__r.Apttus_Config2__LineNumber__c )){
						
						mapQDSIArcadiaBundleAndOptions.get(qdsiRec.Arcadia_Product_Code__c+'-'+qdsiRec.Parent_Line_Item__r.Apttus_Config2__LineNumber__c).add(qdsiRec);
						
					}
					else{
						
						mapQDSIArcadiaBundleAndOptions.put(qdsiRec.Arcadia_Product_Code__c+'-'+qdsiRec.Parent_Line_Item__r.Apttus_Config2__LineNumber__c , new List<Quote_Delivery_Sales_Item__c>{qdsiRec});
						
					}
			   }
			   
			}
			
			 Map<Decimal,List<Apttus_Proposal__Proposal_Line_Item__c>> MapBundleANDArcadia = new Map<Decimal,List<Apttus_Proposal__Proposal_Line_Item__c>>();
			
				// Filter the Proposal Line Item which need to include in Alliance export file
				for(Apttus_Proposal__Proposal_Line_Item__c objLineItem : listFinalizedLineItems){
					// filter Arcadia bundle, Direct Option & Arcadia Options for process							   
					// filter main bundle of the proposal line item. Do not include in processing
					// filter dummy products from configuration
					if(objLineItem.Apttus_QPConfig__ParentBundleNumber__c != NULL && objLineItem.Is_Dummy_Product__c ==false){
						
						
						//Check the main bundle of proposal line item having mapping in our mapping object.
						//this check will help to apply mapping rule on proposal line items.
						if(mapParentBundleAndProdLineItem.containsKey(objLineItem.Apttus_QPConfig__ParentBundleNumber__c) && mapParentBundleAndProdLineItem.get(objLineItem.Apttus_QPConfig__ParentBundleNumber__c).Apttus_QPConfig__ParentBundleNumber__c == NULL){
							// Inside condition for Arcadia Bundle & Direct Options
							strMainBundelProdCode = mapParentBundleAndProdLineItem.get(objLineItem.Apttus_QPConfig__ParentBundleNumber__c).Product_Code__c;
							arcadiaBundleCode = objLineItem.Product_Code__c;
							lineNumber = objLineItem.Apttus_QPConfig__LineNumber__c;
							
							// Check Valid for Converstion in Alliance or not
							if(finalMapMainBundleAndItsSuboridinateMappingOptions.containsKey(strMainBundelProdCode)){
								// valid for conversion.
								OrderExportWrapper newInstanceWrapper = new OrderExportWrapper(objLineItem, strMainBundelProdCode, arcadiaBundleCode, true, Nokia_CPQ_Constants.ALLIANCE_EXPORT_PRODUCT_TYPE_CO, false,null);
															
								if(mapFinalOrderExportRecords.containsKey(lineNumber)){
									Map<String, List<OrderExportWrapper>> innerMapOfExport = mapFinalOrderExportRecords.get(lineNumber);
									if(innerMapOfExport.containsKey(arcadiaBundleCode)){
										List<OrderExportWrapper> newOrder = innerMapOfExport.get(arcadiaBundleCode);
										newOrder.add(newInstanceWrapper);
										innerMapOfExport.put(arcadiaBundleCode, newOrder);
										mapFinalOrderExportRecords.put(lineNumber, innerMapOfExport); 
									}
									else {
										//Map<String, List<OrderExportWrapper>> innerMapOfOrderExport = new Map<String, List<OrderExportWrapper>>();
										innerMapOfExport.put(arcadiaBundleCode, new List<OrderExportWrapper>{newInstanceWrapper});
										mapFinalOrderExportRecords.put(lineNumber, innerMapOfExport);
									}
								}
								else {
									Map<String, List<OrderExportWrapper>> innerMapOfExport = new Map<String, List<OrderExportWrapper>>();
									innerMapOfExport.put(arcadiaBundleCode, new List<OrderExportWrapper>{newInstanceWrapper});
									mapFinalOrderExportRecords.put(lineNumber, innerMapOfExport); 
								}
								
							}
							else {
								// for non mapped products and not valid for conversion.
								OrderExportWrapper newInstanceWrapper = new OrderExportWrapper(objLineItem, strMainBundelProdCode, arcadiaBundleCode, false, Nokia_CPQ_Constants.ALLIANCE_EXPORT_PRODUCT_TYPE_CO , false,null);
								
								if(mapFinalOrderExportRecords.containsKey(lineNumber)){
									Map<String, List<OrderExportWrapper>> innerMapOfExport = mapFinalOrderExportRecords.get(lineNumber);
									if(innerMapOfExport.containsKey(arcadiaBundleCode)){
										List<OrderExportWrapper> newOrder = innerMapOfExport.get(arcadiaBundleCode);
										newOrder.add(newInstanceWrapper);
										innerMapOfExport.put(arcadiaBundleCode, newOrder);
										mapFinalOrderExportRecords.put(lineNumber, innerMapOfExport); 
									}
									else {
										//Map<String, List<OrderExportWrapper>> innerMapOfExport = new Map<String, List<OrderExportWrapper>>();
										innerMapOfExport.put(arcadiaBundleCode, new List<OrderExportWrapper>{newInstanceWrapper});
										mapFinalOrderExportRecords.put(lineNumber, innerMapOfExport);
									}
								}
								else {
									Map<String, List<OrderExportWrapper>> innerMapOfExport = new Map<String, List<OrderExportWrapper>>();
									innerMapOfExport.put(arcadiaBundleCode, new List<OrderExportWrapper>{newInstanceWrapper});
									mapFinalOrderExportRecords.put(lineNumber, innerMapOfExport); 
								}
							}						   
						}
					}
				}
			Map<Decimal, Apttus_Proposal__Proposal_Line_Item__c> mapLineNumberANDProposalLineItems = new Map<Decimal, Apttus_Proposal__Proposal_Line_Item__c>();				
				// Add Arcadia Options in order to bring them after the Arcadia
				for(Apttus_Proposal__Proposal_Line_Item__c objLineItem : listFinalizedLineItems){					 
					// filter main bundle of the proposal line item. Do not include in processing 
					// filter dummy products from configuration
					
					
					 if(objLineItem.Apttus_QPConfig__ChargeType__c.equalsIgnoreCase(Nokia_CPQ_Constants.STANDARD) && objLineItem.NokiaCPQ_Configuration_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.BUNDLE) && objLineItem.Apttus_QPConfig__ParentBundleNumber__c == Null){
						 
						 mapLineNumberANDProposalLineItems.put(objLineItem.Apttus_QPConfig__LineNumber__c,objLineItem);
					 }
					System.debug('mapLineNumberANDProposalLineItems---->'+mapLineNumberANDProposalLineItems);
					
					if(objLineItem.Apttus_QPConfig__ParentBundleNumber__c != NULL && objLineItem.Is_Dummy_Product__c ==false){
						// For Arcadia Options
						
						//NSWOptions
						 if(mapQDSIArcadiaBundleAndOptions.containsKey(objLineItem.Product_Code__c+'-'+objLineItem.Apttus_QPConfig__LineNumber__c)){
							 
							 for(Quote_Delivery_Sales_Item__c QDSIArcadiaOptions : mapQDSIArcadiaBundleAndOptions.get(objLineItem.Product_Code__c+'-'+objLineItem.Apttus_QPConfig__LineNumber__c)){
								 
								 strMainBundelProdCode =  mapParentBundleAndProdLineItem.get(objLineItem.Apttus_QPConfig__ParentBundleNumber__c).Product_Code__c;
								 arcadiaBundleCode = QDSIArcadiaOptions.Arcadia_Product_Code__c;
								 lineNumber = QDSIArcadiaOptions.Parent_Line_Item__r.Apttus_Config2__LineNumber__c;
						
									// Check Valid for Converstion in Alliance or not
								if(finalMapMainBundleAndItsSuboridinateMappingOptions.containsKey(strMainBundelProdCode)){
									System.debug('valid for conversion');
									// valid for conversion.
								   
									OrderExportWrapper newInstanceWrapper = new OrderExportWrapper(new Apttus_Proposal__Proposal_Line_Item__c(
									Apttus_Proposal__Proposal__c =QDSIArcadiaOptions.Proposal__c,
									Total_Option_Quantity__c = (QDSIArcadiaOptions.Quantity__c * mapLineNumberANDProposalLineItems.get(objLineItem.Apttus_QPConfig__LineNumber__c).NokiaCPQ_Quantity__c),
									Apttus_QPConfig__Quantity2__c=objLineItem.Total_Option_Quantity__c,is_Custom_Product__c=false,Apttus_QPConfig__LineType__c='option',
									Item_Type_From_CAT__c =QDSIArcadiaOptions.Item_Type__c,
									Apttus_QPConfig__OptionId__c = mapProdcodeANDId.get(QDSIArcadiaOptions.Product_Code__c).Id,Apttus_QPConfig__LineNumber__c = QDSIArcadiaOptions.Parent_Line_Item__r.Apttus_Config2__LineNumber__c,Sequence_Site_Id__c = objLineItem.Sequence_Site_Id__c)
									, strMainBundelProdCode, arcadiaBundleCode, true, Nokia_CPQ_Constants.ALLIANCE_EXPORT_PRODUCT_TYPE_SLI, true,QDSIArcadiaOptions );
									   
			
			
									if(mapFinalOrderExportRecords.containsKey(lineNumber)){
										System.debug('inside valid if');
										Map<String, List<OrderExportWrapper>> innerMapOfExport = mapFinalOrderExportRecords.get(lineNumber);
										if(innerMapOfExport.containsKey(arcadiaBundleCode)){
											List<OrderExportWrapper> newOrder = innerMapOfExport.get(arcadiaBundleCode);
											newOrder.add(newInstanceWrapper);
											innerMapOfExport.put(arcadiaBundleCode, newOrder);
											mapFinalOrderExportRecords.put(lineNumber, innerMapOfExport); 
										}
										else {
											//Map<String, List<OrderExportWrapper>> innerMapOfExport = new Map<String, List<OrderExportWrapper>>();
											innerMapOfExport.put(arcadiaBundleCode, new List<OrderExportWrapper>{newInstanceWrapper});
											mapFinalOrderExportRecords.put(lineNumber, innerMapOfExport);
										}
									}
									else {
										 System.debug('inside valid else');
										Map<String, List<OrderExportWrapper>> innerMapOfExport = new Map<String, List<OrderExportWrapper>>();
										innerMapOfExport.put(arcadiaBundleCode, new List<OrderExportWrapper>{newInstanceWrapper});
										mapFinalOrderExportRecords.put(lineNumber, innerMapOfExport); 
									}
									
								 
									
								}
								else {  
								
								   // for non mapped products and not valid for conversion.
									OrderExportWrapper newInstanceWrapper = new OrderExportWrapper(new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Proposal__c =objLineItem.Apttus_Proposal__Proposal__c,is_Custom_Product__c=false,Apttus_QPConfig__Quantity2__c=objLineItem.Total_Option_Quantity__c, Total_Option_Quantity__c = (QDSIArcadiaOptions.Quantity__c * mapLineNumberANDProposalLineItems.get(objLineItem.Apttus_QPConfig__LineNumber__c).NokiaCPQ_Quantity__c),Apttus_QPConfig__LineType__c='option',Item_Type_From_CAT__c =QDSIArcadiaOptions.Item_Type__c,Apttus_QPConfig__LineNumber__c=QDSIArcadiaOptions.Parent_Line_Item__r.Apttus_Config2__LineNumber__c,Sequence_Site_Id__c = objLineItem.Sequence_Site_Id__c,Apttus_QPConfig__OptionId__c = mapProdcodeANDId.get(QDSIArcadiaOptions.Product_Code__c).Id), strMainBundelProdCode, arcadiaBundleCode, false, Nokia_CPQ_Constants.ALLIANCE_EXPORT_PRODUCT_TYPE_SLI, true,QDSIArcadiaOptions);
									
									if(mapFinalOrderExportRecords.containsKey(lineNumber)){
										Map<String, List<OrderExportWrapper>> innerMapOfExport = mapFinalOrderExportRecords.get(lineNumber);
										
										
										if(innerMapOfExport.containsKey(arcadiaBundleCode)){
											List<OrderExportWrapper> newOrder = innerMapOfExport.get(arcadiaBundleCode);
											newOrder.add(newInstanceWrapper);
											
											innerMapOfExport.put(arcadiaBundleCode, newOrder);
											mapFinalOrderExportRecords.put(lineNumber, innerMapOfExport); 
										}
										else {
											//Map<String, List<OrderExportWrapper>> innerMapOfExport = new Map<String, List<OrderExportWrapper>>();
										   
											innerMapOfExport.put(arcadiaBundleCode, new List<OrderExportWrapper>{newInstanceWrapper});
											mapFinalOrderExportRecords.put(lineNumber, innerMapOfExport);
										}
									}
									else {
										Map<String, List<OrderExportWrapper>> innerMapOfExport = new Map<String, List<OrderExportWrapper>>();
										
										innerMapOfExport.put(arcadiaBundleCode, new List<OrderExportWrapper>{newInstanceWrapper});
										mapFinalOrderExportRecords.put(lineNumber, innerMapOfExport); 
									}
									
								}
							 }
						
						 }
						 else if(mapParentBundleAndProdLineItem.containsKey(objLineItem.Apttus_QPConfig__ParentBundleNumber__c) && mapParentBundleAndProdLineItem.get(objLineItem.Apttus_QPConfig__ParentBundleNumber__c).Apttus_QPConfig__ParentBundleNumber__c != NULL){
							
							strMainBundelProdCode = mapParentBundleAndProdLineItem.get(mapParentBundleAndProdLineItem.get(objLineItem.Apttus_QPConfig__ParentBundleNumber__c).Apttus_QPConfig__ParentBundleNumber__c).Product_Code__c;
							
							arcadiaBundleCode = mapParentBundleAndProdLineItem.get(objLineItem.Apttus_QPConfig__ParentBundleNumber__c).Product_Code__c;
							
							lineNumber = objLineItem.Apttus_QPConfig__LineNumber__c;
							
							// Check Valid for Converstion in Alliance or not
							if(finalMapMainBundleAndItsSuboridinateMappingOptions.containsKey(strMainBundelProdCode)){
								// valid for conversion.
								OrderExportWrapper newInstanceWrapper = new OrderExportWrapper(objLineItem, strMainBundelProdCode, arcadiaBundleCode, true, Nokia_CPQ_Constants.ALLIANCE_EXPORT_PRODUCT_TYPE_SLI, true,null);
															
								if(mapFinalOrderExportRecords.containsKey(lineNumber)){
									Map<String, List<OrderExportWrapper>> innerMapOfExport = mapFinalOrderExportRecords.get(lineNumber);
									if(innerMapOfExport.containsKey(arcadiaBundleCode)){
										List<OrderExportWrapper> newOrder = innerMapOfExport.get(arcadiaBundleCode);
										newOrder.add(newInstanceWrapper);
										innerMapOfExport.put(arcadiaBundleCode, newOrder);
										mapFinalOrderExportRecords.put(lineNumber, innerMapOfExport); 
									}
									else {
										//Map<String, List<OrderExportWrapper>> innerMapOfExport = new Map<String, List<OrderExportWrapper>>();
										innerMapOfExport.put(arcadiaBundleCode, new List<OrderExportWrapper>{newInstanceWrapper});
										mapFinalOrderExportRecords.put(lineNumber, innerMapOfExport);
									}
								}
								else {
									Map<String, List<OrderExportWrapper>> innerMapOfExport = new Map<String, List<OrderExportWrapper>>();
									innerMapOfExport.put(arcadiaBundleCode, new List<OrderExportWrapper>{newInstanceWrapper});
									mapFinalOrderExportRecords.put(lineNumber, innerMapOfExport); 
								}
								
							}
							else {
								// for non mapped products and not valid for conversion.
								OrderExportWrapper newInstanceWrapper = new OrderExportWrapper(objLineItem, strMainBundelProdCode, arcadiaBundleCode, false, Nokia_CPQ_Constants.ALLIANCE_EXPORT_PRODUCT_TYPE_SLI, true,null);
								
								
								if(mapFinalOrderExportRecords.containsKey(lineNumber)){
									Map<String, List<OrderExportWrapper>> innerMapOfExport = mapFinalOrderExportRecords.get(lineNumber);
									if(innerMapOfExport.containsKey(arcadiaBundleCode)){
										List<OrderExportWrapper> newOrder = innerMapOfExport.get(arcadiaBundleCode);
										newOrder.add(newInstanceWrapper);
										innerMapOfExport.put(arcadiaBundleCode, newOrder);
										mapFinalOrderExportRecords.put(lineNumber, innerMapOfExport); 
									}
									else {
										//Map<String, List<OrderExportWrapper>> innerMapOfExport = new Map<String, List<OrderExportWrapper>>();
										innerMapOfExport.put(arcadiaBundleCode, new List<OrderExportWrapper>{newInstanceWrapper});
										mapFinalOrderExportRecords.put(lineNumber, innerMapOfExport);
									}
								}
								else {
									Map<String, List<OrderExportWrapper>> innerMapOfExport = new Map<String, List<OrderExportWrapper>>();
									innerMapOfExport.put(arcadiaBundleCode, new List<OrderExportWrapper>{newInstanceWrapper});
									mapFinalOrderExportRecords.put(lineNumber, innerMapOfExport); 
								}
							}
							
						}
					}
				}
			}
			catch(Exception e){
				System.debug('e-->'+e);
				ExceptionHandler.addException(e,OrderExportProvider.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
			}
			
			return mapFinalOrderExportRecords;
		}
		
		
		/*****************************
		*Method Name: getMappingStructureForAlliance
		*Description: // method to get the mapping from mapping object of Alliance system
		*		  Map is build for : Main bundle then Map for Arcadia code then Map for Arcadia Options & its related maping code.
		*Parameters: 
		*******************************/	
		public static Map<String, Map<String, Map<String, List<String>>>> getMappingStructureForAlliance(){	 
			Map<String, Map<String, Map<String, List<String>>>> mapMainBundleAndItsSuboridinateTillMappingOptions = new Map<String, Map<String, Map<String, List<String>>>>();
			
			for(Alliance_Order_Export_Mapping__c objMapping : [SELECT Id, PCI_Category__c, Main_Bundle_Product_Code__c, Arcadia_Product_Code__c, Arcadia_Options_Product_Code__c, Product_Code_For_Alliance_Export_File__c FROM Alliance_Order_Export_Mapping__c Limit 1000]){
				// Arcadia product and its type.
				mapArcadiaProductOptionsAndPCICategory.put(objMapping.Arcadia_Options_Product_Code__c, objMapping.PCI_Category__c);
				
				if(mapMainBundleAndItsSuboridinateTillMappingOptions.containsKey(objMapping.Main_Bundle_Product_Code__c)){
					Map<String, Map<String, List<String>>> mapSFDCArcadiaAndMappingOptions = new Map<String, Map<String, List<String>>>();
					mapSFDCArcadiaAndMappingOptions = mapMainBundleAndItsSuboridinateTillMappingOptions.get(objMapping.Main_Bundle_Product_Code__c);
					if(mapSFDCArcadiaAndMappingOptions.containsKey(objMapping.Arcadia_Product_Code__c)){
						Map<String, List<String>> mapSFDCOptionsAllianceOptionCode1 = new Map<String, List<String>>();
						mapSFDCOptionsAllianceOptionCode1 = mapSFDCArcadiaAndMappingOptions.get(objMapping.Arcadia_Product_Code__c);
						
						if(mapSFDCOptionsAllianceOptionCode1.containsKey(objMapping.Arcadia_Options_Product_Code__c)){
							List<String> listAllianceOptionsCode = mapSFDCOptionsAllianceOptionCode1.get(objMapping.Arcadia_Options_Product_Code__c);
							
							listAllianceOptionsCode.add(objMapping.Product_Code_For_Alliance_Export_File__c);
							
							mapSFDCOptionsAllianceOptionCode1.put(objMapping.Arcadia_Options_Product_Code__c, listAllianceOptionsCode);
							
							mapSFDCArcadiaAndMappingOptions.put(objMapping.Arcadia_Product_Code__c, mapSFDCOptionsAllianceOptionCode1);
							
							mapMainBundleAndItsSuboridinateTillMappingOptions.put(objMapping.Main_Bundle_Product_Code__c, mapSFDCArcadiaAndMappingOptions);
						}
						else {
							Map<String, List<String>> mapSFDCOptionsAllianceOptionCode2 = new Map<String, List<String>>();
							
							mapSFDCOptionsAllianceOptionCode1.put(objMapping.Arcadia_Options_Product_Code__c, new List<String>{objMapping.Product_Code_For_Alliance_Export_File__c});
							
							mapSFDCArcadiaAndMappingOptions.put(objMapping.Arcadia_Product_Code__c, mapSFDCOptionsAllianceOptionCode1);
							
							mapMainBundleAndItsSuboridinateTillMappingOptions.put(objMapping.Main_Bundle_Product_Code__c, mapSFDCArcadiaAndMappingOptions);
						}
					}
					else {
						Map<String, List<String>> mapSFDCOptionsAllianceOptionCode = new Map<String, List<String>>();
						
						mapSFDCOptionsAllianceOptionCode.put(objMapping.Arcadia_Options_Product_Code__c, new List<String>{objMapping.Product_Code_For_Alliance_Export_File__c});
						
						mapSFDCArcadiaAndMappingOptions.put(objMapping.Arcadia_Product_Code__c, mapSFDCOptionsAllianceOptionCode);
						
						mapMainBundleAndItsSuboridinateTillMappingOptions.put(objMapping.Main_Bundle_Product_Code__c, mapSFDCArcadiaAndMappingOptions);
					}
				}
				else {
					Map<String, List<String>> mapSFDCOptionsAllianceOptionCode = new Map<String, List<String>>();
					Map<String, Map<String, List<String>>> mapSFDCArcadiaAndMappingOptions = new Map<String, Map<String, List<String>>>();
					
					mapSFDCOptionsAllianceOptionCode.put(objMapping.Arcadia_Options_Product_Code__c, new List<String>{objMapping.Product_Code_For_Alliance_Export_File__c});
					
					mapSFDCArcadiaAndMappingOptions.put(objMapping.Arcadia_Product_Code__c, mapSFDCOptionsAllianceOptionCode);
					
					mapMainBundleAndItsSuboridinateTillMappingOptions.put(objMapping.Main_Bundle_Product_Code__c, mapSFDCArcadiaAndMappingOptions);
				}
			}
			System.debug('>>>>>>'+ mapMainBundleAndItsSuboridinateTillMappingOptions);
			
			return mapMainBundleAndItsSuboridinateTillMappingOptions;
		}
		
		/*****************************
		*Method Name: deleteExistingAllianceOrderData
		*Description: methos to delete existing Alliance data from export object
		*Parameters: 
		*******************************/	
		public static String deleteExistingAllianceOrderData(List<Order_Export_Result_For_External_System__c> existingAllianceDataList){
			String recordDeletedStatus; 
			try{
				database.delete(existingAllianceDataList);
				recordDeletedStatus = Nokia_CPQ_Constants.ALLIANCE_EXPORT_SUCCESS_STRING ;
			}
			catch(Exception e){
				ExceptionHandler.addException(e,OrderExportProvider.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
				recordDeletedStatus = Nokia_CPQ_Constants.ALLIANCE_EXPORT_ERROR_STRING +e.getMessage();
			}
			
			return recordDeletedStatus;
		}
		
		 
		/* ------------------------------ QTC Export -------------------- */
		/*****************************
		*Method Name: intiateExportForQTCSystem
		*Description: this method is called from Lightning apex controller class. this method intiate the QTC file generation.
		*		  this method filtter the Proposal Line item with conditions: 
		*		  Line Type IN (Option, Product/Service)
		*		  Config. Type = Standalone.
		*Parameters: 
		*******************************/
		public static String intiateExportForQTCSystem(Id quoteId, String nokiaQuoteId){
			String finalresult;
			// collect the Main Bundle and its primary line no. map
			Map<Decimal, Apttus_Proposal__Proposal_Line_Item__c> mapParentBundleLineNoAndPLIRecord = new Map<Decimal, Apttus_Proposal__Proposal_Line_Item__c>();
			
			// Line Items which valid for QTC
			List<Apttus_Proposal__Proposal_Line_Item__c> listFinalizedLineItemsForQTC = new List<Apttus_Proposal__Proposal_Line_Item__c>();
			
			List<Apttus_Proposal__Proposal_Line_Item__c> listFinalizedLineItems = new List<Apttus_Proposal__Proposal_Line_Item__c>([SELECT Id, Name, NokiaCPQ_Quantity__c, Apttus_Proposal__Proposal__c, Apttus_QPConfig__BasePrice__c, NokiaCPQ_Product_Name__c, Apttus_QPConfig__ChargeType__c, Product_Code__c, Apttus_Proposal__Unit_Price__c, Apttus_Proposal__Sales_Discount__c, Apttus_Proposal__Unit_Net_Price__c, Apttus_Proposal__Ext_Price__c, Apttus_Proposal__Ext_Net_Price__c, Apttus_Proposal__Service_Date__c, Apttus_QPConfig__LineType__c, Apttus_QPConfig__PrimaryLineNumber__c, Apttus_QPConfig__ParentBundleNumber__c, NokiaCPQ_Extended_IRP__c, NokiaCPQ_Unitary_IRP__c,  NokiaCPQ_Extended_CLP__c,  NokiaCPQ_Configuration_Type__c, Apttus_Proposal__Description__c, NokiaCPQ_ExtendedPrice_CNP__c, Apttus_QPConfig__LineNumber__c, Total_Option_Quantity__c,Apttus_QPConfig__Quantity2__c , NokiaCPQ_Is_Direct_Option__c FROM Apttus_Proposal__Proposal_Line_Item__c WHERE Apttus_Proposal__Proposal__c =:quoteId ORDER BY Apttus_QPConfig__LineNumber__c ASC]);
			system.debug('listFinalizedLineItems >>>>>'+listFinalizedLineItems);
			
			
			for(Apttus_Proposal__Proposal_Line_Item__c objLineItem : listFinalizedLineItems){		  
				// collect only main bundle and its record in map Useing line no. of main bundle as key
				for(Apttus_Proposal__Proposal_Line_Item__c objP : listFinalizedLineItems){
					if(objP.NokiaCPQ_Configuration_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.BUNDLE) && objP.Apttus_QPConfig__ChargeType__c.equalsIgnoreCase(Nokia_CPQ_Constants.STANDARD) && objP.Apttus_QPConfig__LineType__c.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_PRODUCT_SERVICES) && objP.Apttus_QPConfig__ParentBundleNumber__c == NULL){
						mapParentBundleLineNoAndPLIRecord.put(objP.Apttus_QPConfig__LineNumber__c, objP);
						system.debug('>>>>>>>'+mapParentBundleLineNoAndPLIRecord);
						
					} 
				}
				// Collect only Options from proposal line items
				if(objLineItem.Apttus_QPConfig__LineType__c.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_OPTION) && objLineItem.NokiaCPQ_Is_Direct_Option__c == true)
					listFinalizedLineItemsForQTC.add(objLineItem);
			}
			
			
			if(!listFinalizedLineItemsForQTC.IsEmpty()){
				// send to extract mapping for proposal line items
				
				finalresult = generateQTCFile(listFinalizedLineItemsForQTC, mapParentBundleLineNoAndPLIRecord, quoteId, nokiaQuoteId);
				
			}
			else
				finalresult = Nokia_CPQ_Constants.ALLIANCE_EXPORT_ERROR_MESSAGE_STRING;
			
			system.debug('>>>finalresult >>>>'+finalresult );
			return finalresult ;
		}
		
		/*****************************
		*Method Name: generateQTCFile
		*Description: this method generate the File's Body in String and calls other method to generate ContentVersion record in Salesforce.
		*******************************/
		public static String generateQTCFile(List<Apttus_Proposal__Proposal_Line_Item__c> listFinalizedLineItemsForQTC, Map<Decimal, Apttus_Proposal__Proposal_Line_Item__c> mapParentBundleLineNoAndPLIRecord, Id quoteId, String nokiaQuoteId){
			String outPutStatus;
			String outPutStringForQTCFile;
			Integer quantityOfSLI;
			try{
				outPutStringForQTCFile = Nokia_CPQ_Constants.QTC_FILE_LINE_1 + Nokia_CPQ_Constants.QTC_FILE_NEW_LINE + Nokia_CPQ_Constants.QTC_FILE_LINE_2 + Nokia_CPQ_Constants.QTC_FILE_NEW_LINE;
				outPutStringForQTCFile = outPutStringForQTCFile + Nokia_CPQ_Constants.QTC_FILE_COLUMN_HEADER + Nokia_CPQ_Constants.QTC_FILE_NEW_LINE;
				System.debug('>>main Bundles>>>>'+mapParentBundleLineNoAndPLIRecord.values());
				for(Apttus_Proposal__Proposal_Line_Item__c objProposalLineItem : listFinalizedLineItemsForQTC){
					// quantity is retrive using 'Total Options No.'	
					Decimal finalQuantity = objProposalLineItem.Total_Option_Quantity__c.round(System.RoundingMode.FLOOR);
					Decimal finalPriceValue=0;
					// Price is calculated based on the Parent bundle no. * Extended CLP of options.
					if(mapParentBundleLineNoAndPLIRecord.ContainsKey(objProposalLineItem.Apttus_QPConfig__LineNumber__c)){
						finalPriceValue = objProposalLineItem.NokiaCPQ_ExtendedPrice_CNP__c * mapParentBundleLineNoAndPLIRecord.get(objProposalLineItem.Apttus_QPConfig__LineNumber__c).Apttus_QPConfig__Quantity2__c ;
						finalPriceValue = finalPriceValue.setScale(2, RoundingMode.HALF_UP);
					}				  
					
					system.debug('finalPriceValue >>>>>'+finalPriceValue );
									
					outPutStringForQTCFile = outPutStringForQTCFile + Nokia_CPQ_Constants.QTC_FILE_WORD_SERVICE + Nokia_CPQ_Constants.QTC_FILE_COLUMN_SEPERATOR+ objProposalLineItem.Product_Code__c+ Nokia_CPQ_Constants.QTC_FILE_COLUMN_SEPERATOR + finalQuantity + Nokia_CPQ_Constants.QTC_FILE_COLUMN_SEPERATOR + Nokia_CPQ_Constants.ENGLISH_ALPHABET_V +Nokia_CPQ_Constants.QTC_FILE_COLUMN_SEPERATOR + Nokia_CPQ_Constants.QTC_FILE_COLUMN_SEPERATOR + finalPriceValue + Nokia_CPQ_Constants.QTC_FILE_NEW_LINE;
				}		   
				system.debug('>>>>Final String'+outPutStringForQTCFile);
				
				ContentVersion newQTCFileInstance = generateQTCFileContentVersion(outPutStringForQTCFile, nokiaQuoteId, false);
				system.debug('>ContentDocumentId>>'+ newQTCFileInstance.ContentDocumentId);
				
				// generate ContentDocumentLink to bind with quote
				if(newQTCFileInstance != NULL)
					outPutStatus = generateContDocLinkForQTC(newQTCFileInstance, quoteId);
				else
					outPutStatus = Nokia_CPQ_Constants.ALLIANCE_EXPORT_ERROR_STRING;
			}
			catch(Exception e){
				ExceptionHandler.addException(e,OrderExportProvider.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
				outPutStatus = Nokia_CPQ_Constants.ALLIANCE_EXPORT_ERROR_STRING +e.getMessage();
			}
			return outPutStatus;
		}
		
		/*****************************
		*Method Name: generateQTCFileContentVersion
		*Description: this method generate ContentVersion record in Salesforce.
		*******************************/
		public static ContentVersion generateQTCFileContentVersion(String outPutStringForQTCFile, String nokiaQuoteId, Boolean isQTCSITE){	  
			String fileName;
			if(isQTCSITE)
				fileName = Nokia_CPQ_Constants.QTC_SITE_FILE_NAME_PREFIX +nokiaQuoteId+ Nokia_CPQ_Constants.LESS_THAN_SYMBOL;
			else
				fileName = Nokia_CPQ_Constants.QTC_FILE_NAME_PREFIX +nokiaQuoteId+ Nokia_CPQ_Constants.LESS_THAN_SYMBOL;
				
			ContentVersion objContVersion = new ContentVersion(); 
			//Blob beforeblob = Blob.valueOf(outPutStringForQTCFile);
			//string paramvalue = EncodingUtil.base64Encode(Blob.valueOf(outPutStringForQTCFile));
			try{	   
				objContVersion.VersionData = EncodingUtil.base64Decode(EncodingUtil.base64Encode(Blob.valueOf(outPutStringForQTCFile)));
				objContVersion.ContentLocation = Nokia_CPQ_Constants.ENGLISH_ALPHABET_S;
				objContVersion.PathOnClient = fileName+Nokia_CPQ_Constants.TXT_FILE_EXTENSION;
				objContVersion.Title = fileName;
				
				database.insert(objContVersion);
			}
			catch(Exception e){
				ExceptionHandler.addException(e,OrderExportProvider.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);		 
			}
			return objContVersion;	  
		}
		
		/*****************************
		*Method Name: generateContDocLinkForQTC
		*Description: this method generate ContentDocumentLink record in Salesforce. Using this method, we are binding QTC file to Quote.
		*******************************/
		public static String generateContDocLinkForQTC(ContentVersion newQTCFileInstance, Id quoteId){
			String outPutString;
			try{
				ContentDocumentLink docLink = new ContentDocumentLink ();
				docLink.ContentDocumentId = [Select Id, ContentDocumentId from ContentVersion WHERE Id =: newQTCFileInstance.Id].ContentDocumentId;
				docLink.ShareType = Nokia_CPQ_Constants.ENGLISH_ALPHABET_V;
				docLink.LinkedEntityId = quoteId;
				
				database.insert(docLink);
				outPutString = Nokia_CPQ_Constants.ALLIANCE_EXPORT_SUCCESS_STRING;
			}
			catch(Exception e){
				ExceptionHandler.addException(e,OrderExportProvider.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
				outPutString = Nokia_CPQ_Constants.ALLIANCE_EXPORT_ERROR_STRING +e.getMessage();
			}
			return outPutString;
		}   
	}