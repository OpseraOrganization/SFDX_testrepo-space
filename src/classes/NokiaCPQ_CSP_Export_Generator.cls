/***************************************
* Class Name : NokiaCPQ_CSP_Export_Generator
* Author : Accenture
* Developer : Piyush Potdar
* Description : The class is used to create Output CSP Export records used in CSP Export including GS Service SI REQ: 6238, 6232
**********************************/ 
public without sharing class NokiaCPQ_CSP_Export_Generator {
    public static Map<Id,Id> groupToParentMap = new Map<Id,Id>();
    public static Map<Id,Apttus_Proposal__Proposal_Line_Item__c> groupToParentPLIMap = new Map<Id,Apttus_Proposal__Proposal_Line_Item__c>();
    public static Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>> parentToSImap = new Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>>();
    public static Boolean mapModeMainFlag = false;   
    public static String GSStandaloneLineNum ;
    public static double level2serialnum=0;
    public Static Map<String, NokiaCPQ_CSP_Map_Control__c> productNameAndNokiaCSPMapControl = new Map<String, NokiaCPQ_CSP_Map_Control__c>();
    /***************************************
* Method Name : PLIbundleOptionMapping
* Parameters : Quote Id
* Return Type : Void
* Description : Method extracts list of all Proposal Line Items related to a Quote and pass on to next method.
*********************************/
    public static void PLIbundleOptionMapping(String quoteId){
        try{
            String QuoteRecord = quoteId; 
            List<Apttus_Proposal__Proposal_Line_Item__c> listFinalizedLineItems = new List<Apttus_Proposal__Proposal_Line_Item__c>(
                [SELECT Id,NokiaCPQ_IsArcadiaBundle__c, Name, PCI_Code__c,ISP_Per_Unit__c,NokiaCPQ_Quantity__c,NokiaCPQ_Item_Type__c, 
                 Apttus_Proposal__Proposal__c, Apttus_Proposal__Proposal__r.CurrencyIsoCode, Apttus_QPConfig__BasePrice__c, 
                 NokiaCPQ_Product_Name__c, Apttus_QPConfig__LineNumber__c,Apttus_QPConfig__ChargeType__c, 
                 Product_Code__c, Apttus_Proposal__Unit_Price__c, Apttus_Proposal__Sales_Discount__c, Apttus_Proposal__Unit_Net_Price__c, 
                 Apttus_Proposal__Ext_Price__c, Apttus_Proposal__Ext_Net_Price__c, Apttus_Proposal__Service_Date__c, 
                 Apttus_QPConfig__LineType__c, Apttus_QPConfig__PrimaryLineNumber__c, Apttus_QPConfig__ParentBundleNumber__c, 
                 NokiaCPQ_Extended_IRP__c, NokiaCPQ_Unitary_IRP__c,  NokiaCPQ_Extended_CLP__c,  NokiaCPQ_Configuration_Type__c, 
                 Apttus_Proposal__Description__c, NokiaCPQ_ExtendedPrice_CNP__c, NokiaCPQ_Product_Description__c,Custom_Product_Code__c, 
                 Apttus_QPConfig__OptionId__r.Arcadia_Replacement_Code__c, Apttus_Proposal__Proposal__r.Name,Product_Classification__c,
                 OEM__c,Apttus_QPConfig__ItemSequence__c,Sequence_Site_Id__c, Total_Option_Quantity__c,
                 Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c,Alias_for_Exports__c,CMN__c,NokiaCPQ_Alias__c
                 FROM Apttus_Proposal__Proposal_Line_Item__c  WHERE Apttus_Proposal__Proposal__c =:quoteId 
                 and NokiaCPQ_Spare__c =false ORDER BY Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c ASC 
                 LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]);
            
            If(!listFinalizedLineItems.isEmpty()){
                gernateExportCSP(listFinalizedLineItems,QuoteRecord);
            }
        }catch(Exception e){
            ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);            
        }
        
    }
    
    /***************************************
* Method Name : gernateExportCSP
* Parameters : Quote Id, List of Apttus_Proposal__Proposal_Line_Item__c
* Return Type : Void
* Description : Method creates Parent Proposal Line Item to Options Map and Parent Proposal Line item to Attribute value object Map and pass it to next method.
*********************************/
    public static void gernateExportCSP(List<Apttus_Proposal__Proposal_Line_Item__c> listFinalizedLineItems, String quoteId){
        Map<Decimal, List<Apttus_Proposal__Proposal_Line_Item__c>> mapParentBundleLineNoAndItsRecord = new Map<Decimal, List<Apttus_Proposal__Proposal_Line_Item__c>>();
        Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>> parentToSImap = new Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>>();
        //map for external system
        Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>> parentToSIExternalMap = new Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>>();
        
        Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c> PLIandAttributeMap = new Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c>();
        String QuoteRecord = quoteId;
        //Map<String, NokiaCPQ_CSP_Map_Control__c> productNameAndNokiaCSPMapControl = new Map<String, NokiaCPQ_CSP_Map_Control__c>();
        Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>> parentToSIFinalMap = new Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>>();
        
        Map<Decimal, String> mapLineNoMainbundleProductCode = new Map<Decimal, String> ();
        List<Apttus_Proposal__Proposal_Line_Item__c> GSDeployItemsList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        //Apttus_Proposal__Proposal_Line_Item__c servicesLineItem = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Description__c=System.Label.CSP_Export_Installation_Services ,Custom_Product_Code__c = System.Label.CSP_Export_Custom_Code);
        try{
            
            // Delete existing CSP Output
            deleteExistingCSPOutput(quoteId);
            
            List<Apttus_Proposal__Proposal__c> quoteRec = new List<Apttus_Proposal__Proposal__c>([Select NokiaCPQ_Portfolio__c 
                                                                                                  from Apttus_Proposal__Proposal__c
                                                                                                  where id =: quoteId
                                                                                                  limit 1]);
            system.debug('quoteRec'+quoteRec);
            for (NokiaCPQ_CSP_Map_Control__c nokiaCspMap : [SELECT Id, Name, Product_Code__c,
                                                            Source__c,Splitlevel__c,
                                                            Map_Mode__c,Portfolio__c
                                                            FROM NokiaCPQ_CSP_Map_Control__c 
                                                            where Portfolio__c =: quoteRec[0].NokiaCPQ_Portfolio__c
                                                            LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])
            {
                productNameAndNokiaCSPMapControl.put(nokiaCspMap.Product_Code__c, nokiaCspMap);
            }
            
            //product Attribute Value records mapped with Proposal line item product code
            for(Apttus_QPConfig__ProposalProductAttributeValue__c attrObj : [Select Id, Name, How_is_the_software_to_be_delivered__c, Apttus_QPConfig__LineItemId__c from Apttus_QPConfig__ProposalProductAttributeValue__c where Apttus_QPConfig__LineItemId__c in: listFinalizedLineItems LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]){                
                PLIandAttributeMap.put(attrObj.Apttus_QPConfig__LineItemId__c,attrObj);                
            }
            
            // filter all SIs with there primary line number.
            for(Apttus_Proposal__Proposal_Line_Item__c objLineItem : listFinalizedLineItems){
                if(objLineItem.Apttus_QPConfig__ChargeType__c.equalsIgnoreCase(Nokia_CPQ_Constants.STANDARD) 
                   && objLineItem.NokiaCPQ_Configuration_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.BUNDLE) 
                   && objLineItem.Apttus_QPConfig__ParentBundleNumber__c == Null &&
                   objLineItem.Apttus_QPConfig__LineType__c.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_PRODUCT_SERVICES)){  
                       mapLineNoMainbundleProductCode.put(objLineItem.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c ,objLineItem.Product_Code__c);
                   }
                // collect GS Items for Airscale wifi
                if(objLineItem.Apttus_QPConfig__ChargeType__c.equalsIgnoreCase(Nokia_CPQ_Constants.STANDARD) 
                   && objLineItem.NokiaCPQ_Configuration_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_STANDALONE) 
                   && objLineItem.Apttus_QPConfig__ParentBundleNumber__c == Null &&
                   objLineItem.Apttus_QPConfig__LineType__c.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_PRODUCT_SERVICES)
                   && objLineItem.NokiaCPQ_Item_Type__c == Nokia_CPQ_Constants.SERVICE_STRING &&
                   objLineItem.Product_Classification__c.equalsIgnoreCase('Deploy Services')){
                       if(String.isBlank(GSStandaloneLineNum)){                          
                           GSStandaloneLineNum = String.valueOf(objLineItem.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c );
                       }else if(GSStandaloneLineNum> String.valueOf(objLineItem.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c )){
                           GSStandaloneLineNum = String.valueOf(objLineItem.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c );
                       }
                       GSDeployItemsList.add(objLineItem);
                   }
                if(mapParentBundleLineNoAndItsRecord.containsKey(objLineItem.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c )){
                    mapParentBundleLineNoAndItsRecord.get(objLineItem.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c ).add(objLineItem);
                }                
                else{
                    mapParentBundleLineNoAndItsRecord.put(objLineItem.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c , new List<Apttus_Proposal__Proposal_Line_Item__c>{objLineItem});
                }                
            }
            system.debug('mapParentBundleLineNoAndItsRecord>>'+mapParentBundleLineNoAndItsRecord);
            //create map of Bundle product to options in proposal Line item obj
            // Generate List<Apttus_Proposal__Proposal_Line_Item__c> listIsExternalSourcePLI & //List<Apttus_Proposal__Proposal_Line_Item__c> listIsInternalSourcePLI
            List<Apttus_Proposal__Proposal_Line_Item__c> listIsExternalSourcePLI = new List<Apttus_Proposal__Proposal_Line_Item__c>();
            List<Apttus_Proposal__Proposal_Line_Item__c> listIsInternalSourcePLI = new List<Apttus_Proposal__Proposal_Line_Item__c>();
            boolean IsExternal= false;
            boolean IsInternal =  false;
            for(Decimal primaryLineNumbers : mapLineNoMainbundleProductCode.keySet()){  
                
                if(productNameAndNokiaCSPMapControl.get(mapLineNoMainbundleProductCode.get(primaryLineNumbers)).Source__c == Nokia_CPQ_Constants.EXTERNAL){
                    listIsExternalSourcePLI.AddAll(mapParentBundleLineNoAndItsRecord.get(primaryLineNumbers));
                    IsExternal = true;
                }// existing Airscalewifi (in direct)
                else if (productNameAndNokiaCSPMapControl.get(mapLineNoMainbundleProductCode.get(primaryLineNumbers)).Source__c == Nokia_CPQ_Constants.Table){                    
                    listIsInternalSourcePLI.AddAll(mapParentBundleLineNoAndItsRecord.get(primaryLineNumbers));
                    IsInternal = true;
                }                
            }
            system.debug('listIsInternalSourcePLI>>'+listIsInternalSourcePLI);
            // Process differently based on IsInternal = true;or IsExternal = true;
            if(IsInternal && !listIsInternalSourcePLI.IsEmpty()){
                // existing Airscalewifi logic
                parentToSImap = generateMainBundleToSIsMap(listIsInternalSourcePLI);
                system.debug('parentToSImap >>'+parentToSImap );
                parentToSIFinalMap = generateParentToSIFinalMap(parentToSImap, productNameAndNokiaCSPMapControl);
                system.debug('parentToSIFinalMap >>'+parentToSIFinalMap );
                if(!GSDeployItemsList.IsEmpty() && !mapSSETOSI(GSDeployItemsList).isEmpty()){
                    parentToSIFinalMap.putAll(mapSSETOSI(GSDeployItemsList));
                    system.debug('mapSSETOSI(GSDeployItemsList)>>>'+mapSSETOSI(GSDeployItemsList));                            
                }    
                mapPLIwithCSPexportMap(parentToSIFinalMap,PLIandAttributeMap,QuoteRecord);
                
            }
            
            if(IsExternal && !listIsExternalSourcePLI.IsEmpty()){
                
                List<Apttus_Proposal__Proposal_Line_Item__c> listArcProdPLI = new List<Apttus_Proposal__Proposal_Line_Item__c>();
                
                Map<Decimal, Apttus_Proposal__Proposal_Line_Item__c> mapLineNumberAndMainBundlePLIObj = new Map<Decimal, Apttus_Proposal__Proposal_Line_Item__c>();
                
                // It contain Main Bundle and List Of All PLI including main bundle. And key is Main bundle Proposal Line Item.
                parentToSImap = generateMainBundleToSIsMap(listIsExternalSourcePLI);
                
                // Collect MainBundle, PCI & List QDSI map.
                for(Apttus_Proposal__Proposal_Line_Item__c objMainBundle : parentToSImap.keySet()){     
                    for(Apttus_Proposal__Proposal_Line_Item__c objAllPLI: parentToSImap.get(objMainBundle)){   
                        
                        if(objAllPLI.NokiaCPQ_IsArcadiaBundle__c){                    
                            // collect Arcadia PLIs list to quoery QDSIs.
                            listArcProdPLI.add(objAllPLI);                            
                        }
                    }
                    mapLineNumberAndMainBundlePLIObj.put(objMainBundle.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c , objMainBundle);
                }
                system.debug('>>>>listArcProdPLI>>>>'+listArcProdPLI);
                // get Map<mainBundle,Map<PCICode,List<QDSIs>>>
                // collect from Quote Delivery Sales Items.
                Map<Apttus_Proposal__Proposal_Line_Item__c, Map<String, List<Quote_Delivery_Sales_Item__c>>> mapMainBundlePCICodeAndListQDSI = new Map<Apttus_Proposal__Proposal_Line_Item__c, Map<String, List<Quote_Delivery_Sales_Item__c>>>();
                
                mapMainBundlePCICodeAndListQDSI = getPCICodeAndDeliverySalesItem(quoteId, listArcProdPLI, mapLineNumberAndMainBundlePLIObj);
                
                // return PCI list list PLI map for all PLIs including Arcadia bundle
                Map<Apttus_Proposal__Proposal_Line_Item__c, Map<String, List<Apttus_Proposal__Proposal_Line_Item__c>>> mapMainBundlePCICodeListPLIS = new Map<Apttus_Proposal__Proposal_Line_Item__c, Map<String, List<Apttus_Proposal__Proposal_Line_Item__c>>>();
                
                mapMainBundlePCICodeListPLIS = gernerateMapPCICodeAndListPLIs(parentToSImap);
                
                Map<String, String> mapPCICodeAndPCIType = new Map<String, String>();
                // collect PCI code for External Source during CSP logic
                List<String> listPCICodeOfLevel1 = new List<String>();
                list<String> pciList = new list<String>();
                for(Apttus_Proposal__Proposal_Line_Item__c objMainBundle : mapMainBundlePCICodeListPLIS.keySet()){
                    listPCICodeOfLevel1.AddAll(mapMainBundlePCICodeListPLIS.get(objMainBundle).keySet());
                    if(mapMainBundlePCICodeAndListQDSI.ContainsKey(objMainBundle))
                        listPCICodeOfLevel1.AddAll(mapMainBundlePCICodeAndListQDSI.get(objMainBundle).keySet());
                    
                    // Adding Product Codes from QDSI to collect Item Type
                    if(mapMainBundlePCICodeAndListQDSI.containskey(objMainBundle) && !mapMainBundlePCICodeAndListQDSI.get(objMainBundle).isEmpty()){                        
                        for(String pciCode : mapMainBundlePCICodeAndListQDSI.get(objMainBundle).keyset()){
                            if(pciCode !=null && pciCode!= '' && mapMainBundlePCICodeAndListQDSI.get(objMainBundle).containskey(pciCode)){
                                for(Quote_Delivery_Sales_Item__c qdsi : mapMainBundlePCICodeAndListQDSI.get(objMainBundle).get(pciCode)){
                                    listPCICodeOfLevel1.add(qdsi.Product_Code__c);
                                }   
                            }
                        }
                    }
                }
                
                system.debug('>>listPCICodeOfLevel1>>>>'+listPCICodeOfLevel1);
                // collect map for PCI Type 
                for(Product2 objProd: [SELECT Id, ProductCode, NokiaCPQ_Item_Type__c FROM Product2 WHERE ProductCode =: listPCICodeOfLevel1]){
                    mapPCICodeAndPCIType.put(objProd.ProductCode, objProd.NokiaCPQ_Item_Type__c);
                }
                
                // Send for Final Processing and create CSP Output records
                generateCSPOutputObjectRecord(mapMainBundlePCICodeAndListQDSI, mapMainBundlePCICodeListPLIS, mapPCICodeAndPCIType);
            }
            
        }catch(Exception e){
            system.debug('');
            ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD+''+e.getLineNumber()+''+e.getMessage());            
        }
    }
    
    // generate level 0 & 1 records
    public static void generateCSPOutputObjectRecord(Map<Apttus_Proposal__Proposal_Line_Item__c, Map<String, List<Quote_Delivery_Sales_Item__c>>> mapMainBundlePCICodeAndListQDSI, Map<Apttus_Proposal__Proposal_Line_Item__c, Map<String, List<Apttus_Proposal__Proposal_Line_Item__c>>> mapMainBundlePCICodeListPLIS, Map<String, String> mapPCICodeAndPCIType){
        // iterate main bundle and csp code and generate level 0 & 1
        // merge QDSI list PCI too.
        List<NokiaCPQ_output_CSP_mapping__c> listOutputCspObjForLevel0And1 = new List<NokiaCPQ_output_CSP_mapping__c>();
        List<NokiaCPQ_output_CSP_mapping__c> listOutputCspObjForLeve2 = new List<NokiaCPQ_output_CSP_mapping__c>();
        Integer position = 0;
        Integer serialNumber = 0;
        try{
            system.debug('mapMainBundlePCICodeListPLIS.keySet() >>>'+mapMainBundlePCICodeListPLIS.keySet().size());
            for(Apttus_Proposal__Proposal_Line_Item__c objMainBundlePLI: mapMainBundlePCICodeListPLIS.keySet()){
                // generate Level 0 records
                ++position;
                ++serialNumber;
                // Collect All processed PCI code 
                List<String> listPCIAlreadyProccessed = new List<String> ();
                
                NokiaCPQ_output_CSP_mapping__c objOutput = generateCSPOutpurRec(objMainBundlePLI, null, 0, String.valueOf(objMainBundlePLI.Sequence_Site_Id__c), String.valueOf(objMainBundlePLI.Apttus_Proposal__Proposal__c), position, objMainBundlePLI.Apttus_Proposal__Proposal__r.CurrencyIsoCode, null, null, Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE, Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE, serialNumber,null);
                listOutputCspObjForLevel0And1.add(objOutput);
                
                for(String strPCICode : mapMainBundlePCICodeListPLIS.get(objMainBundlePLI).keySet()){               
                    // generate level 1 record..
                    
                    ++position;
                    ++serialNumber;
                    // Collect PCI Type for PCI Code at level 1
                    String strPCITypeForPCICode = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
                    if(mapPCICodeAndPCIType.containsKey(strPCICode)){
                        if(!String.isBlank(mapPCICodeAndPCIType.get(strPCICode)) && mapPCICodeAndPCIType.get(strPCICode) == Nokia_CPQ_Constants.SERVICE_STRING)
                            strPCITypeForPCICode = Nokia_CPQ_Constants.SERVICE_PCI;
                        else
                            strPCITypeForPCICode = Nokia_CPQ_Constants.EQUIPMENT_PCI;                     
                    }
                    // collect CSP Output object record instance.
                    listOutputCspObjForLevel0And1.add(generateCSPOutpurRec(null , null, 1, String.valueOf(objMainBundlePLI.Sequence_Site_Id__c), objMainBundlePLI.Apttus_Proposal__Proposal__c, position, objMainBundlePLI.Apttus_Proposal__Proposal__r.CurrencyIsoCode, null, objMainBundlePLI, strPCICode, strPCITypeForPCICode, serialNumber,null)); 
                    
                    // increase serialNumber with size of List of this PCI Code. And use Incremental serialNumber for next PCI in Output object.
                    serialNumber = serialNumber + mapMainBundlePCICodeListPLIS.get(objMainBundlePLI).get(strPCICode).size();
                    
                    // add serial number if same PCI exists in Quote Delivery Sales Item object.
                    if(mapMainBundlePCICodeAndListQDSI.containsKey(objMainBundlePLI)){
                        for(String strPCICodeOfQDSI : mapMainBundlePCICodeAndListQDSI.get(objMainBundlePLI).keySet()){                
                            // Check PCI exists then add serial number
                            if(strPCICodeOfQDSI.equals(strPCICode)){
                                serialNumber = serialNumber + mapMainBundlePCICodeAndListQDSI.get(objMainBundlePLI).get(strPCICode).size();
                                break;
                            }
                        }
                    }
                    
                    // use to compare with QDSI object's PCI. in that way we will not create duplicate PCI level 1 record.
                    listPCIAlreadyProccessed.add(strPCICode);
                    
                }           
                
                // collect level 1 output record for QDSI PCI code
                
                if(mapMainBundlePCICodeAndListQDSI.containsKey(objMainBundlePLI)){
                    for(String strPCICode : mapMainBundlePCICodeAndListQDSI.get(objMainBundlePLI).keySet()){                
                        // generate level 1 record..                            
                        // removed PCI if already processed in mapMainBundlePCICodeListPLIS.get(objMainBundlePLI).keySet()
                        if(!listPCIAlreadyProccessed.contains(strPCICode)){
                            ++position;
                            ++serialNumber;
                            // Collect PCI Type for PCI Code at level 1
                            String strPCITypeForPCICode = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
                            if(mapPCICodeAndPCIType.containsKey(strPCICode)){
                                if(!String.isBlank(mapPCICodeAndPCIType.get(strPCICode)) && mapPCICodeAndPCIType.get(strPCICode) == Nokia_CPQ_Constants.SERVICE_STRING)
                                    strPCITypeForPCICode = Nokia_CPQ_Constants.SERVICE_PCI;
                                else
                                    strPCITypeForPCICode = Nokia_CPQ_Constants.EQUIPMENT_PCI;                     
                            }
                            
                            // collect CSP Output object record instance.
                            listOutputCspObjForLevel0And1.add(generateCSPOutpurRec(null , null, 1, String.valueOf(objMainBundlePLI.Sequence_Site_Id__c), objMainBundlePLI.Apttus_Proposal__Proposal__c, position, objMainBundlePLI.Apttus_Proposal__Proposal__r.CurrencyIsoCode, null, objMainBundlePLI, strPCICode, strPCITypeForPCICode, serialNumber,null)); 
                            
                            serialNumber = serialNumber + mapMainBundlePCICodeAndListQDSI.get(objMainBundlePLI).get(strPCICode).size();                                
                        }
                    }
                } 
                
            }
            
            if(!listOutputCspObjForLevel0And1.IsEmpty())
                database.insert(listOutputCspObjForLevel0And1, false);
            
            
            // Iterate listOutputCspObjForLevel0And1 and create Map for level 1 PCI Code
            Map<String, NokiaCPQ_output_CSP_mapping__c> mapLineNumberAndPCICodeCSPOutputObjRec = new Map<String, NokiaCPQ_output_CSP_mapping__c>();
            for(NokiaCPQ_output_CSP_mapping__c objOutputLevel0And1 : listOutputCspObjForLevel0And1){            
                if(objOutputLevel0And1.Item_Level__c == 1){             
                    String uniquePCICodeKey = objOutputLevel0And1.NokiaCPQ_Parent_Proposal_Line_Item__c + Nokia_CPQ_Constants.NOKIA_UNDERSCORE + objOutputLevel0And1.ProductID__c;
                    
                    mapLineNumberAndPCICodeCSPOutputObjRec.put(uniquePCICodeKey, objOutputLevel0And1);
                }           
            }
            
            // generate level 2 records
            // Map to store PCI code and its last Serial number of level 2
            Map<String, Integer> mapPCIAndInnerSerialNumber = new Map<String, Integer>();
            
            for(Apttus_Proposal__Proposal_Line_Item__c objMainBundlePLI: mapMainBundlePCICodeListPLIS.keySet()){
                // generate Level 2 for ProposalLineItems associated with PCI code  
                
                for(String strPCICode : mapMainBundlePCICodeListPLIS.get(objMainBundlePLI).keySet()){
                    String uniquePCICodeKey = objMainBundlePLI.Id+Nokia_CPQ_Constants.NOKIA_UNDERSCORE+strPCICode;
                    
                    NokiaCPQ_output_CSP_mapping__c objParentPCICSPOutput = mapLineNumberAndPCICodeCSPOutputObjRec.get(uniquePCICodeKey);
                    
                    Integer innerSerialNumber = Integer.ValueOf(objParentPCICSPOutput.NokiaCPQ_Serial_Number__c);
                    
                    for(Apttus_Proposal__Proposal_Line_Item__c objAllOptionsPLI : mapMainBundlePCICodeListPLIS.get(objMainBundlePLI).get(strPCICode)){
                        ++position;  
                        ++ innerSerialNumber;
                        // collect level 2 CSP output obj rec 
                        listOutputCspObjForLeve2.add(generateCSPOutpurRec(objAllOptionsPLI , null, 2, String.valueOf(objMainBundlePLI.Sequence_Site_Id__c), objMainBundlePLI.Apttus_Proposal__Proposal__c, position, objMainBundlePLI.Apttus_Proposal__Proposal__r.CurrencyIsoCode, objParentPCICSPOutput, objMainBundlePLI, strPCICode, Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE, innerSerialNumber,null));
                    }              
                    // use it with Items from Quote Delivery Sales Item object.
                    mapPCIAndInnerSerialNumber.put(strPCICode, innerSerialNumber);
                }  
                
                // iterate on QDSIs List
                if(mapMainBundlePCICodeAndListQDSI.containsKey(objMainBundlePLI)){
                    for(String strPCICode : mapMainBundlePCICodeAndListQDSI.get(objMainBundlePLI).keySet()){                    
                        
                        if(mapMainBundlePCICodeAndListQDSI.get(objMainBundlePLI).containsKey(strPCICode)){
                            
                            String uniquePCICodeKey = objMainBundlePLI.Id+Nokia_CPQ_Constants.NOKIA_UNDERSCORE+strPCICode;                        
                            NokiaCPQ_output_CSP_mapping__c objParentPCICSPOutput = mapLineNumberAndPCICodeCSPOutputObjRec.get(uniquePCICodeKey);
                            system.debug('>>mapMainBundlePCICodeAndListQDSI.get(objMainBundlePLI).get(strPCICode)>>'+mapMainBundlePCICodeAndListQDSI.get(objMainBundlePLI));
                            Integer innerSerialNumber;
                            if(mapPCIAndInnerSerialNumber.containsKey(strPCICode))
                                innerSerialNumber = Integer.ValueOf(mapPCIAndInnerSerialNumber.get(strPCICode));
                            else
                                innerSerialNumber = Integer.ValueOf(objParentPCICSPOutput.NokiaCPQ_Serial_Number__c);
                            
                            for(Quote_Delivery_Sales_Item__c objQDSI : mapMainBundlePCICodeAndListQDSI.get(objMainBundlePLI).get(strPCICode)){
                                ++position; 
                                ++ innerSerialNumber;
                                // collect level 2 CSP output obj rec 
                                String strQdsiItemType;
                                if(!mapPCICodeAndPCIType.isEmpty() && mapPCICodeAndPCIType.containskey(objQDSI.Product_Code__c) && mapPCICodeAndPCIType.get(objQDSI.Product_Code__c) !=null && mapPCICodeAndPCIType.get(objQDSI.Product_Code__c)!=''){
                                    strQdsiItemType = mapPCICodeAndPCIType.get(objQDSI.Product_Code__c);
                                }
                                listOutputCspObjForLeve2.add(generateCSPOutpurRec(null , objQDSI, 2, String.valueOf(objMainBundlePLI.Sequence_Site_Id__c), objMainBundlePLI.Apttus_Proposal__Proposal__c, position, objMainBundlePLI.Apttus_Proposal__Proposal__r.CurrencyIsoCode, objParentPCICSPOutput, objMainBundlePLI, strPCICode, Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE, innerSerialNumber,strQdsiItemType));            
                            }
                        }
                    }
                }
            }
            
            if(!listOutputCspObjForLeve2.IsEmpty())
                database.insert(listOutputCspObjForLeve2, false);
            
        }catch(Exception e){
            system.debug('exception'+e);
            ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD+''+e.getLineNumber()+''+e.getMessage());            
        }
        
        
    }
    
    //for External generate cspOutput object Data
    public static NokiaCPQ_output_CSP_mapping__c generateCSPOutpurRec(Apttus_Proposal__Proposal_Line_Item__c objPLI, Quote_Delivery_Sales_Item__c objQDSI, Integer itemLevel, String lineNumber, String quoteId, Integer position, String currencyISOCode, NokiaCPQ_output_CSP_mapping__c parentPCI, Apttus_Proposal__Proposal_Line_Item__c objParentPLI, String PCICode, String strPCIType, Integer intSerialNumber, String strQdsiItemType){
        
        NokiaCPQ_output_CSP_mapping__c objOutputCsp = new NokiaCPQ_output_CSP_mapping__c();
        
        objOutputCsp.Item_Level__c = itemLevel;
        objOutputCsp.QuoteId__c = quoteId;       
        objOutputCsp.NokiaCPQ_Serial_Number__c = intSerialNumber;
        objOutputCsp.Position__c = position;
        
        If(itemLevel == 0){
            
            
            if(objPLI != null){
                objOutputCsp.NokiaCPQ_Customer_Material_Number__c = objPLI.CMN__c; 
            }
            else if(objQDSI != null){
                objOutputCsp.NokiaCPQ_Customer_Material_Number__c = objQDSI.CMN__c;
            }
            else{
                objOutputCsp.NokiaCPQ_Customer_Material_Number__c = objParentPLI.CMN__c;
                
            }
            objOutputCsp.NokiaCPQ_Descpription__c = objPLI.NokiaCPQ_Product_Name__c;
          //  objOutputCsp.Quantity__c = objPLI.NokiaCPQ_Quantity__c;
         //   objOutputCsp.ISP_per_unit__c = objPLI.ISP_Per_Unit__c.setScale(2, RoundingMode.HALF_UP);
            objOutputCsp.NokiaCPQ_Proposal_Line_Item__c = objPLI.Id;
        }       
        
        else If(itemLevel == 1){
            
            if(objPLI != null){
                objOutputCsp.NokiaCPQ_Customer_Material_Number__c = objPLI.CMN__c; //newlineNumber+'_'+objParentPLI.Apttus_Proposal__Proposal__r.Name;
            }
            else if(objQDSI != null){
                objOutputCsp.NokiaCPQ_Customer_Material_Number__c = objQDSI.CMN__c;
            }
            else{
                objOutputCsp.NokiaCPQ_Customer_Material_Number__c = objParentPLI.CMN__c;
                
            }
            objOutputCsp.Quantity__c = objParentPLI.NokiaCPQ_Quantity__c;
            objOutputCsp.NokiaCPQ_code__c = PCICode;
            objOutputCsp.ProductID__c = PCICode;
            objOutputCsp.NokiaCPQ_Parent_Proposal_Line_Item__c = objParentPLI.Id;
            objOutputCsp.PCI_Type__c = strPCIType;
        }
        
        
        else if(itemLevel == 2){
            
            if(objPLI != null){
                system.debug('objPLI.NokiaCPQ_IsArcadiaBundle__c>>>>'+objPLI.NokiaCPQ_IsArcadiaBundle__c);
                system.debug('objPLI.Apttus_QPConfig__OptionId__r.Arcadia_Replacement_Code__c>>>>'+objPLI.Apttus_QPConfig__OptionId__r.Arcadia_Replacement_Code__c);
                if(!objPLI.NokiaCPQ_IsArcadiaBundle__c){
                    objOutputCsp.NokiaCPQ_code__c = objPLI.Product_Code__c;
                    objOutputCsp.ProductID__c = objPLI.Product_Code__c;                 
                }
                else {
                    objOutputCsp.NokiaCPQ_code__c = objPLI.Apttus_QPConfig__OptionId__r.Arcadia_Replacement_Code__c;
                    objOutputCsp.ProductID__c = objPLI.Apttus_QPConfig__OptionId__r.Arcadia_Replacement_Code__c;
                }
                //objOutputCsp.Quantity__c = objPLI.NokiaCPQ_Quantity__c;
                objOutputCsp.Quantity__c = objPLI.Total_Option_Quantity__c;
                
                if(objPLI.ISP_Per_Unit__c > 0){
                    
                    objOutputCsp.ISP_per_unit__c = objPLI.ISP_Per_Unit__c.setScale(2, RoundingMode.HALF_UP);
                }
                else{ //#D-12880
                    objOutputCsp.ISP_per_unit__c = 0.01;
                    
                    objOutputCsp.FOC_flag__c = Nokia_CPQ_Constants.ENGLISH_ALPHABET_X ;
                }
                
                objOutputCsp.NokiaCPQ_Proposal_Line_Item__c = objPLI.Id;
                if(objPLI.NokiaCPQ_Item_Type__c == Nokia_CPQ_Constants.SERVICE_STRING)
                    objOutputCsp.PCI_Type__c = Nokia_CPQ_Constants.SERVICE_PCI;
                else
                    objOutputCsp.PCI_Type__c = Nokia_CPQ_Constants.EQUIPMENT_PCI;
            }
            else if(objQDSI != null){
                objOutputCsp.NokiaCPQ_code__c = objQDSI.Product_Code__c;
                objOutputCsp.ProductID__c = objQDSI.Product_Code__c;
               // objOutputCsp.Quantity__c = objQDSI.Quantity__c;
                objOutputCsp.Quantity__c =(objParentPLI.NokiaCPQ_Quantity__c*objQDSI.Quantity__c);
                objOutputCsp.ISP_per_unit__c = 0.01;
                objOutputCsp.FOC_flag__c = Nokia_CPQ_Constants.ENGLISH_ALPHABET_X;
                if(strQdsiItemType!=null && strQdsiItemType!=''){
                    objOutputCsp.Item_Type_Custom__c = strQdsiItemType;
                }
                else{
                    objOutputCsp.Item_Type_Custom__c = objQDSI.Item_Type__c;
                }
                objOutputCsp.PCI_Type__c = Nokia_CPQ_Constants.EQUIPMENT_PCI;
            }
            
            objOutputCsp.ISP_Currency__c = currencyISOCode;
            
            if(parentPCI!= null){
                objOutputCsp.NokiaCPQ_Parent_PCI__c = parentPCI.Id;
                objOutputCsp.Parent_Position__c = parentPCI.Position__c;
            }
            objOutputCsp.NokiaCPQ_Parent_Proposal_Line_Item__c = objParentPLI.Id;
            
        }
        
        return objOutputCsp;
    }
    
    /***************************************
* Method Name : generateMainBundleToSIsMap
* Parameters : List<Apttus_Proposal__Proposal_Line_Item__c> listMainBundleAndItsLineItem
* Return Type : Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>> parentToSImap
* Description : Methods provide Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>> map of Parent Main Bundle & all PLI under main Bundle including main bundle PLI in List...
// return the nested Map with Main Bundle including Direct Options
*********************************/
    
    public static Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>> generateMainBundleToSIsMap(List<Apttus_Proposal__Proposal_Line_Item__c> listMainBundleAndItsLineItem){
        
        Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>> parentToSImap = new Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>>();
        
        Apttus_Proposal__Proposal_Line_Item__c servicesLineItem = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Description__c='GS Deploy Services Items' ,Custom_Product_Code__c = 'GS Deploy Services Items');
        
        Map<Decimal, List<Apttus_Proposal__Proposal_Line_Item__c>> mapLineNumberListOfPLI = new Map<Decimal, List<Apttus_Proposal__Proposal_Line_Item__c>>();
        // collect Line Number and List of PLI for same Line number
        for(Apttus_Proposal__Proposal_Line_Item__c proposalLineItem : listMainBundleAndItsLineItem) {
            if(mapLineNumberListOfPLI.containsKey(proposalLineItem.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c ))
                mapLineNumberListOfPLI.get(proposalLineItem.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c ).add(proposalLineItem);
            else
                mapLineNumberListOfPLI.put(proposalLineItem.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c , new List<Apttus_Proposal__Proposal_Line_Item__c> {proposalLineItem});
            
        }
        
        for(Apttus_Proposal__Proposal_Line_Item__c proposalLineItem : listMainBundleAndItsLineItem) { 
            
            if(proposalLineItem != Null && proposalLineItem.Apttus_QPConfig__ChargeType__c.equalsIgnoreCase(Nokia_CPQ_Constants.STANDARD) 
               && proposalLineItem.NokiaCPQ_Configuration_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.BUNDLE) 
               && proposalLineItem.Apttus_QPConfig__ParentBundleNumber__c == Null){
                   parentToSImap.put(proposalLineItem, mapLineNumberListOfPLI.get(proposalLineItem.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c ));
                   
               }
            else{ 
                if(proposalLineItem != Null && proposalLineItem.Apttus_QPConfig__ChargeType__c.equalsIgnoreCase(Nokia_CPQ_Constants.STANDARD) 
                   && proposalLineItem.NokiaCPQ_Configuration_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_STANDALONE) 
                   && proposalLineItem.Apttus_QPConfig__ParentBundleNumber__c == Null)
                {
                    if(parentToSImap.containsKey(servicesLineItem)){                        
                        parentToSImap.get(servicesLineItem).add(proposalLineItem);
                    }
                    else{                           
                        parentToSImap.put(servicesLineItem, new List<Apttus_Proposal__Proposal_Line_Item__c>{proposalLineItem});
                        system.debug('parentToSImap'+parentToSImap);                        
                    }
                }
            }
        }
        
        return parentToSImap;
    }
    
    /***************************************
* Method Name : deleteExistingCSPOutput
* Parameters : quoteId
* Return Type : void
* Description : Delete existing records from NokiaCPQ_output_CSP_mapping__c object for an Quote Id.
*********************************/
    public static void deleteExistingCSPOutput(id quoteId) {
        List<NokiaCPQ_output_CSP_mapping__c> outputCspMapObjListforPLItoDelete = new List<NokiaCPQ_output_CSP_mapping__c>();
        outputCspMapObjListforPLItoDelete = [Select Id, Name from NokiaCPQ_output_CSP_mapping__c where QuoteId__c =:quoteId LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()];
        
        if(!outputCspMapObjListforPLItoDelete.isEmpty())
            database.delete(outputCspMapObjListforPLItoDelete);
        
    }
    
    
    // Proceed CSP Logic for External Source sytem main bundle...
    /***************************************
* Method Name : gernerateMapPCICodeAndListPLIs
* Parameters : Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>> parentToSImap
* Return Type : Map<Apttus_Proposal__Proposal_Line_Item__c, Map<String, List<Apttus_Proposal__Proposal_Line_Item__c>>> map of Map<MainBundle , Map<PCICode, List<PLIS>>>
* Description : External Source sytem::generate and return Map of Main Bundle with Map of PCI code and List of Proposal Line Item (PLI)
*********************************/
    public static Map<Apttus_Proposal__Proposal_Line_Item__c, Map<String, List<Apttus_Proposal__Proposal_Line_Item__c>>> gernerateMapPCICodeAndListPLIs(Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>> parentToSImap){
        Map<Apttus_Proposal__Proposal_Line_Item__c, Map<String, List<Apttus_Proposal__Proposal_Line_Item__c>>> finalProcessingPLIsforCSP = new Map<Apttus_Proposal__Proposal_Line_Item__c, Map<String, List<Apttus_Proposal__Proposal_Line_Item__c>>> ();
        
        
        for(Apttus_Proposal__Proposal_Line_Item__c objMainBundle : parentToSImap.keySet()){
            Map<String, List<Apttus_Proposal__Proposal_Line_Item__c>> mapFilteredArcAndAllOptionsPCI = new Map<String, List<Apttus_Proposal__Proposal_Line_Item__c>>();
            for(Apttus_Proposal__Proposal_Line_Item__c objLineItem: parentToSImap.get(objMainBundle)){                
                // excluded all SRS, Maintenance & CAREs proposal Line Item
                // generate PCI Code, List of all Options including Arcadia PLI
                if(objLineItem.Apttus_QPConfig__ChargeType__c.equalsIgnoreCase(Nokia_CPQ_Constants.STANDARD)
                   && objLineItem.Apttus_QPConfig__LineType__c.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_OPTION )){
                       if(mapFilteredArcAndAllOptionsPCI.containsKey(objLineItem.PCI_Code__c))
                           mapFilteredArcAndAllOptionsPCI.get(objLineItem.PCI_Code__c).add(objLineItem);
                       else
                           mapFilteredArcAndAllOptionsPCI.put(objLineItem.PCI_Code__c, new List<Apttus_Proposal__Proposal_Line_Item__c> {objLineItem});
                   }
            }   
            finalProcessingPLIsforCSP.put(objMainBundle, mapFilteredArcAndAllOptionsPCI);   
        }         
        
        return finalProcessingPLIsforCSP;         
    }
    
    
    //fetch PCICode and its related Delivery Items 
    public static Map<Apttus_Proposal__Proposal_Line_Item__c, Map<String, List<Quote_Delivery_Sales_Item__c>>> getPCICodeAndDeliverySalesItem(Id quoteId, List<Apttus_Proposal__Proposal_Line_Item__c> ArcBundlePLIs, Map<Decimal, Apttus_Proposal__Proposal_Line_Item__c> mapLineNumberAndMainBundlePLIObj){        
        
        Map<String, List<Quote_Delivery_Sales_Item__c>> mapOfQDSIs = new Map<String, List<Quote_Delivery_Sales_Item__c>>();
        Map<Apttus_Proposal__Proposal_Line_Item__c, Map<String, List<Quote_Delivery_Sales_Item__c>>> propLineAndpciCodeSalesDeliveryItemMap = new Map<Apttus_Proposal__Proposal_Line_Item__c, Map<String, List<Quote_Delivery_Sales_Item__c>>>();
        // create linenumber+ArcProdCode as key and list of QDSIs
        for( Quote_Delivery_Sales_Item__c salesItem : [SELECT Id,Arcadia_Product_Code__c,Item_Type__c,Name,Parent_Line_Item__c,PCI_Code__c,Product_Code__c,Proposal__c,Quantity__c, Parent_Line_Item__r.Apttus_Config2__LineNumber__c,Parent_Line_Item__r.Apttus_Config2__PrimaryLineNumber__c,Sequence_Site_Id__c,Alias_for_Exports__c,Parent_Line_Item__r.NokiaCPQ_Alias__c,Parent_Line_Item__r.NokiaCPQ_Product_Name__c,Parent_Line_Item__r.Apttus_Config2__ParentBundleNumber__c,Parent_Line_Item__r.Apttus_Config2__LineSequence__c,CMN__c FROM Quote_Delivery_Sales_Item__c where Proposal__c=: quoteId AND Parent_Line_Item__c != null]){
            String keyStr = salesItem.Parent_Line_Item__r.Apttus_Config2__LineSequence__c + Nokia_CPQ_Constants.HYPHEN+salesItem.Arcadia_Product_Code__c;
            if(mapOfQDSIs.containsKey(keyStr))
                mapOfQDSIs.get(keyStr).add(salesItem);
            else
                mapOfQDSIs.put(keyStr, new List<Quote_Delivery_Sales_Item__c> {salesItem});
        }
        
        system.debug('>>>mapOfQDSIs.keySet()>>>>>'+mapOfQDSIs.keySet());
        for(Apttus_Proposal__Proposal_Line_Item__c objPLI : ArcBundlePLIs){
            String keyStr = objPLI.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c +Nokia_CPQ_Constants.HYPHEN+objPLI.Product_Code__c;
            system.debug('>>>Arc Key>>>>>'+keyStr);
            Map<String, List<Quote_Delivery_Sales_Item__c>> pciCodeSalesDeliveryItemMap = new Map<String, List<Quote_Delivery_Sales_Item__c>>();
            if(mapOfQDSIs.containsKey(keyStr)){
                for(Quote_Delivery_Sales_Item__c objQDSIs : mapOfQDSIs.get(keyStr)){
                    if(pciCodeSalesDeliveryItemMap.containsKey(objQDSIs.PCI_Code__c))
                        pciCodeSalesDeliveryItemMap.get(objQDSIs.PCI_Code__c).add(objQDSIs);
                    else
                        pciCodeSalesDeliveryItemMap.put(objQDSIs.PCI_Code__c, new List<Quote_Delivery_Sales_Item__c>{objQDSIs});
                }
                propLineAndpciCodeSalesDeliveryItemMap.put(mapLineNumberAndMainBundlePLIObj.get(objPLI.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c ), pciCodeSalesDeliveryItemMap);
            }
            
        }
        return propLineAndpciCodeSalesDeliveryItemMap;    
    }
    
    
    //logic specific to Airscale 
    public static Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>> generateParentToSIFinalMap(Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>>  parentToSImap , Map<String, NokiaCPQ_CSP_Map_Control__c> productNameAndNokiaCSPMapControl){
        Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>> parentToSIFinalMap = new Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>>();
        try{
            for(Apttus_Proposal__Proposal_Line_Item__c pli : parentToSImap.keySet())
            {
                if(productNameAndNokiaCSPMapControl.containsKey(pli.Product_Code__c) || productNameAndNokiaCSPMapControl.containsKey(pli.Custom_Product_Code__c))
                {                    
                    if(productNameAndNokiaCSPMapControl.containsKey(pli.Product_Code__c) && productNameAndNokiaCSPMapControl.get(pli.Product_Code__c).Map_mode__c == Nokia_CPQ_Constants.Split                                           
                      )
                    {
                        if(!mapSSETOSI(parentToSImap.get(pli)).isEmpty()){
                            parentToSIFinalMap.putAll(mapSSETOSI(parentToSImap.get(pli)));                          
                        }                        
                    }else if(productNameAndNokiaCSPMapControl.containsKey(pli.Custom_Product_Code__c) && productNameAndNokiaCSPMapControl.get(pli.Custom_Product_Code__c).Map_mode__c == Nokia_CPQ_Constants.Split                                                   
                            )
                    {
                        
                        if(!mapSSETOSI(parentToSImap.get(pli)).isEmpty()){
                            parentToSIFinalMap.putAll(mapSSETOSI(parentToSImap.get(pli)));                          
                        }else{
                            system.debug('its empty');
                        }
                    }else if(productNameAndNokiaCSPMapControl.containsKey(pli.Product_Code__c) && (productNameAndNokiaCSPMapControl.get(pli.Product_Code__c).Map_mode__c == Nokia_CPQ_Constants.Main || productNameAndNokiaCSPMapControl.get(pli.Product_Code__c).Map_mode__c == null || productNameAndNokiaCSPMapControl.get(pli.Product_Code__c).Map_mode__c == '')){
                        parentToSIFinalMap.put(pli,parentToSImap.get(pli));
                        mapModeMainFlag = true;
                    }
                }                
            }
        }catch(Exception e){
            ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD+''+e.getLineNumber()+''+e.getMessage());            
        }
        
        return parentToSIFinalMap;      
    }
    
    /***************************************
* Method Name : mapPLIwithCSPexportMap
* Parameters : Quote Id, Map of Parent to Option Proposal Line Item, Map of Parent PLI to Attribute Value
* Return Type : Void
* Description : Methods creates Map<Apttus_Proposal__Proposal_Line_Item__c,Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c>>> and pass on to other method.
*********************************/
    public static void mapPLIwithCSPexportMap(Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>> finalPLImap, Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c> finalAttributePLImap, String quoteId){
        
        try{
            List<NokiaCPQ_CSP_ordering_export_mapping__c> cspOrderingExportmapListAttribute = new List<NokiaCPQ_CSP_ordering_export_mapping__c>();
            cspOrderingExportmapListAttribute = [Select Id, Name, Parent_Product__c, PCI_Type__c,PCI_Code__c, PCI_Description__c, PName1__c, Pvalue1__c, Rule__c, Rule_Type__c from NokiaCPQ_CSP_ordering_export_mapping__c where Rule_Type__c = 'ATTRIBUTE' ];
            List<NokiaCPQ_CSP_ordering_export_mapping__c> cspOrderingExportmapListOption = new List<NokiaCPQ_CSP_ordering_export_mapping__c>();
            cspOrderingExportmapListOption = [Select Id, Name, Parent_Product__c,PCI_Type__c, PCI_Code__c, PCI_Description__c, 
                                              PName1__c, Pvalue1__c, Rule__c, Rule_Type__c from NokiaCPQ_CSP_ordering_export_mapping__c 
                                              where Rule_Type__c in ('OPTION','SERVICES') LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()];
            String QuoteRecord = quoteId;
            
            //Create Item Type Map of PLIs
            Map<Apttus_Proposal__Proposal_Line_Item__c, Map<String,List<Apttus_Proposal__Proposal_Line_Item__c>>> pliItemTypeMap = new Map<Apttus_Proposal__Proposal_Line_Item__c, Map<String,List<Apttus_Proposal__Proposal_Line_Item__c>>>();
            system.debug('finalPLImap>>'+finalPLImap);
            //RMJ Comments for testing will be deleted  
            System.debug('finalPLImap.keySet() : '+finalPLImap.keySet());
            for(Apttus_Proposal__Proposal_Line_Item__c bundleObj :finalPLImap.keySet()){
                Map<String,List<Apttus_Proposal__Proposal_Line_Item__c>> ItemTypeOptionMap = new Map<String,List<Apttus_Proposal__Proposal_Line_Item__c>>();
                List<Apttus_Proposal__Proposal_Line_Item__c> swList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
                List<Apttus_Proposal__Proposal_Line_Item__c> hwList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
                List<Apttus_Proposal__Proposal_Line_Item__c> serviceList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
                List<Apttus_Proposal__Proposal_Line_Item__c> GSDeployList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
                if(finalPLImap != null && finalPLImap.get(bundleObj)!=null){
                    for(Apttus_Proposal__Proposal_Line_Item__c optionObj : finalPLImap.get(bundleObj)){
                        
                        //RMJ Comments for testing will be deleted 
                        System.debug('optionObj : '+optionObj);
                        if(String.isNotBlank(optionObj.NokiaCPQ_Item_Type__c) && optionObj.NokiaCPQ_Item_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.SOFTWARE_STRING)){
                            swList.add(optionObj);
                        }
                        else if(String.isNotBlank(optionObj.NokiaCPQ_Item_Type__c) && optionObj.NokiaCPQ_Item_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.HARDWARE_STRING)){
                            hwList.add(optionObj);
                        }
                        else if( optionObj.NokiaCPQ_Configuration_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_PRODUCT_SERVICES) &&
                                optionObj.Apttus_QPConfig__LineType__c.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_STANDALONE) &&
                                String.isNotBlank(optionObj.NokiaCPQ_Item_Type__c) && optionObj.NokiaCPQ_Item_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.SERVICE_STRING) 
                                && !optionObj.OEM__c)
                        {
                            GSDeployList.add(optionObj);
                        }
                        else if(optionObj.Product_Classification__c!= Null && optionObj.Product_Classification__c.equalsIgnoreCase('Deploy Services') && !optionObj.OEM__c &&
                                String.isNotBlank(optionObj.NokiaCPQ_Item_Type__c) && optionObj.NokiaCPQ_Item_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.SERVICE_STRING))
                        {
                            GSDeployList.add(optionObj);
                        }
                        else if(String.isNotBlank(optionObj.NokiaCPQ_Item_Type__c) && optionObj.NokiaCPQ_Item_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.SERVICE_STRING)){
                            serviceList.add(optionObj);
                        }
                    }
                }
                if(!swList.isEmpty())
                    ItemTypeOptionMap.put(Nokia_CPQ_Constants.SOFTWARE_STRING,swList);
                
                if(!hwList.isEmpty())
                    ItemTypeOptionMap.put(Nokia_CPQ_Constants.HARDWARE_STRING,hwList);
               
                if(!serviceList.isEmpty())
                    ItemTypeOptionMap.put(Nokia_CPQ_Constants.SERVICE_STRING,serviceList);
                
                if(!GSDeployList.isEmpty())
                    ItemTypeOptionMap.put(Nokia_CPQ_Constants.GS_DEPLOY,GSDeployList);
               
                if(ItemTypeOptionMap.size() > 0)
                    pliItemTypeMap.put(bundleObj,ItemTypeOptionMap);
            }
            
           
            
            Map<Apttus_Proposal__Proposal_Line_Item__c,Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c>>> bundleToPciCodeVsPliMap = new Map<Apttus_Proposal__Proposal_Line_Item__c,Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c>>>();
            
            for(Apttus_Proposal__Proposal_Line_Item__c bundleObj : pliItemTypeMap.keySet()){
                
                if(pliItemTypeMap.get(bundleObj).keySet()!=null){
                    
                    Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c>> pciCodeProposalLineItemMap = new Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c>>();
                    for(String itemTypeStr : pliItemTypeMap.get(bundleObj).keySet()){
                        
                        if(itemTypeStr.equals(Nokia_CPQ_Constants.HARDWARE_STRING) || itemTypeStr.equals(Nokia_CPQ_Constants.GS_DEPLOY)){
                            for(NokiaCPQ_CSP_ordering_export_mapping__c cspExportMapObj : cspOrderingExportmapListOption){
                                
                                List<Apttus_Proposal__Proposal_Line_Item__c> pliObjWithPliList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
                                if(pliItemTypeMap.get(bundleObj).get(itemTypeStr)!=null){
                                    for(Apttus_Proposal__Proposal_Line_Item__c pliobj : pliItemTypeMap.get(bundleObj).get(itemTypeStr)){
                                        
                                        if(cspExportMapObj.Rule__c.contains(pliobj.Product_Code__c)){
                                            pliObjWithPliList.add(pliobj);
                                        }
                                    }
                                    if(!pliObjWithPliList.isEmpty()){
                                        if(pciCodeProposalLineItemMap.containsKey(cspExportMapObj)){
                                            pciCodeProposalLineItemMap.get(cspExportMapObj).addAll(pliObjWithPliList);
                                        }
                                        else{
                                            pciCodeProposalLineItemMap.put(cspExportMapObj,pliObjWithPliList);  
                                        }   
                                        
                                    }
                                }
                                
                            }
                            
                        }
                        else{
                            system.debug('cspOrderingExportmapListAttribute>>'+cspOrderingExportmapListAttribute);
                            system.debug('bundleObj>>'+bundleObj);
                            for(NokiaCPQ_CSP_ordering_export_mapping__c cspExportMapObj : cspOrderingExportmapListAttribute){
                                
                                List<Apttus_Proposal__Proposal_Line_Item__c> pliObjWithPliList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
                               
                                if(!String.isBlank(cspExportMapObj.Pvalue1__c) && bundleObj.id != null && cspExportMapObj.Pvalue1__c == finalAttributePLImap.get(groupToParentMap.get(bundleObj.id)).How_is_the_software_to_be_delivered__c){
                                    system.debug('inside attribute check>>');   
                                    for(Apttus_Proposal__Proposal_Line_Item__c pliobj : pliItemTypeMap.get(bundleObj).get(itemTypeStr)){
                                        
                                        if(cspExportMapObj.Rule__c.contains(pliobj.Product_Code__c)){
                                            pliObjWithPliList.add(pliobj);
                                        }
                                    }
                                    
                                    if(!pliObjWithPliList.isEmpty()){
                                        if(pciCodeProposalLineItemMap.containsKey(cspExportMapObj)){
                                            pciCodeProposalLineItemMap.get(cspExportMapObj).addAll(pliObjWithPliList);
                                        }
                                        else{
                                            pciCodeProposalLineItemMap.put(cspExportMapObj,pliObjWithPliList);  
                                        }
                                    }
                                }
                                
                                /* else if(cspExportMapObj.PCI_Code__c.contains('OEMWSW0000') || cspExportMapObj.PCI_Code__c.contains('OEMDELLFCSW')){

for(Apttus_Proposal__Proposal_Line_Item__c pliobj : pliItemTypeMap.get(bundleObj).get(itemTypeStr)){

if(cspExportMapObj.Rule__c.contains(pliobj.Product_Code__c)){
pliObjWithPliList.add(pliobj);
}
}

if(!pliObjWithPliList.isEmpty()){
if(pciCodeProposalLineItemMap.containsKey(cspExportMapObj)){
pciCodeProposalLineItemMap.get(cspExportMapObj).addAll(pliObjWithPliList);
}
else{
pciCodeProposalLineItemMap.put(cspExportMapObj,pliObjWithPliList);  
}
}
} */  
                            }
                        }
                    }
                    system.debug('pciCodeProposalLineItemMap'+pciCodeProposalLineItemMap);
                    bundleToPciCodeVsPliMap.put(bundleObj,pciCodeProposalLineItemMap);
                }
            }  
            
            system.debug('bundleToPciCodeVsPliMap'+bundleToPciCodeVsPliMap);
            createOutputObjRecords(bundleToPciCodeVsPliMap,QuoteRecord);
        }
        
        catch(Exception e){
            ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName()+e.getLineNumber()+e.getMessage(),Nokia_CPQ_Constants.ERROR_MSD);
            
        }
    }
    
    /***************************************
* Method Name : createOutputObjRecords
* Parameters : Quote Id, Map<Apttus_Proposal__Proposal_Line_Item__c,Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c>>>
* Return Type : Void
* Description : Methods creates Output CSP Mapping Object records to be used in CSP Export.
*********************************/
    public static void createOutputObjRecords(Map<Apttus_Proposal__Proposal_Line_Item__c,Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c>>> cspOderAndPliMap, String quoteId){
        
        try{
            List<NokiaCPQ_output_CSP_mapping__c> outputCspMapObjList = new List<NokiaCPQ_output_CSP_mapping__c>();
            List<NokiaCPQ_output_CSP_mapping__c> outputCspMapObjListforPLI = new List<NokiaCPQ_output_CSP_mapping__c>();
            //List<NokiaCPQ_output_CSP_mapping__c> outputCspMapObjListforPLItoDelete = new List<NokiaCPQ_output_CSP_mapping__c>();
            Map<String, NokiaCPQ_output_CSP_mapping__c> cspOrderAndOutputCspMap = new Map<String, NokiaCPQ_output_CSP_mapping__c>();
            List<NokiaCPQ_Validity_Range_Mapping__c> ValidityRangeList = new List<NokiaCPQ_Validity_Range_Mapping__c>();
            List<Apttus_Proposal__Proposal_Line_Item__c> GSDeployList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
            Apttus_Proposal__Proposal__c quoteObj = new Apttus_Proposal__Proposal__c();
            double position = 0;
            double serialNumber = 0;
            double standaloneSerialNumber;
            Integer configNumber = 0; 
            
            quoteObj = [Select Id, Name, CurrencyIsoCode from Apttus_Proposal__Proposal__c where Id=: quoteId Limit 1];
            
            /*outputCspMapObjListforPLItoDelete = [Select Id, Name from NokiaCPQ_output_CSP_mapping__c where QuoteId__c =:quoteId LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()];
if(!outputCspMapObjListforPLItoDelete.isEmpty())
database.delete(outputCspMapObjListforPLItoDelete);

*/
            system.debug('cspOderAndPliMap'+cspOderAndPliMap);
            for(Apttus_Proposal__Proposal_Line_Item__c propLineItemObj : cspOderAndPliMap.keySet()){
                system.debug('serialNumber--->'+serialNumber);
                system.debug('propLineItemObj.Apttus_Proposal__Description__c'+propLineItemObj.Apttus_Proposal__Description__c);
                if(propLineItemObj.Apttus_Proposal__Description__c.contains('GS Deploy Services Items') )
                {
                    system.debug('In if of standalone');
                    GSDeployList.add(propLineItemObj);
                    //createOutputObjRecordsForStandalone(cspOderAndPliMap,quoteObj,propLineItemObj);
                }else if(propLineItemObj.Product_Classification__c!= Null &&
                         propLineItemObj.Product_Classification__c.equalsIgnoreCase('Deploy Services') )
                {
                    system.debug('In if of GS bundle');
                    GSDeployList.add(propLineItemObj);
                    //createOutputObjRecordsForStandalone(cspOderAndPliMap,quoteObj,propLineItemObj);
                }else{
                    system.debug('propLineItemObj'+propLineItemObj);
                    
                    ++position;
                    ++serialNumber;
                    ++configNumber;
                    NokiaCPQ_output_CSP_mapping__c outputCspObjNew = new NokiaCPQ_output_CSP_mapping__c();
                    outputCspObjNew.Item_Level__c = 0;
                    outputCspObjNew.NokiaCPQ_Descpription__c = propLineItemObj.NokiaCPQ_Product_Name__c;
                    outputCspObjNew.NokiaCPQ_Customer_Material_Number__c = propLineItemObj.CMN__c;
                    outputCspObjNew.QuoteId__c = quoteId;
                    outputCspObjNew.NokiaCPQ_Serial_Number__c = serialNumber;
                    //outputCspObjNew.Quantity__c = propLineItemObj.NokiaCPQ_Quantity__c;
					//commented :11 Dec to align with gs deploy
                   // outputCspObjNew.Quantity__c = propLineItemObj.Total_Option_Quantity__c;
                    
                    outputCspObjNew.Position__c = position;
                    outputCspMapObjList.add(outputCspObjNew);
                    
                    for(NokiaCPQ_CSP_ordering_export_mapping__c cspOrderObj : cspOderAndPliMap.get(propLineItemObj).keySet()){
                        system.debug('serialNumber2--->'+serialNumber);
                        
                        if(cspOderAndPliMap.get(propLineItemObj).get(cspOrderObj).size()>0){
                            
                            ++serialNumber;
                            ++position;
                            NokiaCPQ_output_CSP_mapping__c outputCspObj = new NokiaCPQ_output_CSP_mapping__c();
                            outputCspObj.NokiaCPQ_code__c = cspOrderObj.PCI_Code__c;
                            outputCspObj.QuoteId__c = quoteId;
                            outputCspObj.ISP_Currency__c = quoteObj.CurrencyIsoCode;
                            outputCspObj.Position__c = position;
                            outputCspObj.Item_Level__c = 1;
                            
                            if(mapModeMainFlag == true){
                                //outputCspObj.Quantity__c = propLineItemObj.NokiaCPQ_Quantity__c;
                                outputCspObj.Quantity__c = propLineItemObj.Total_Option_Quantity__c;
                            }
                            else
                                outputCspObj.Quantity__c = propLineItemObj.NokiaCPQ_Quantity__c*groupToParentPLIMap.get(propLineItemObj.Id).NokiaCPQ_Quantity__c;
                            
                            outputCspObj.NokiaCPQ_Parent_Proposal_Line_Item__c = propLineItemObj.id;
                            outputCspObj.PCI_Type__c = cspOrderObj.PCI_Type__c;
                            outputCspObj.NokiaCPQ_Serial_Number__c = serialNumber;
                            outputCspObj.NokiaCPQ_Customer_Material_Number__c = propLineItemObj.CMN__c;   
                            system.debug('outputCspObj>>'+outputCspObj);
                            outputCspMapObjList.add(outputCspObj);
                            serialNumber = serialNumber + cspOderAndPliMap.get(propLineItemObj).get(cspOrderObj).size();
                        }
                    }
                }
            }
            system.debug('outputCspMapObjList>>'+outputCspMapObjList);
            Database.insert(outputCspMapObjList);
            
            for(NokiaCPQ_output_CSP_mapping__c outputObj : outputCspMapObjList){                
                if(!String.isBlank(outputObj.PCI_Type__c)){                    
                    cspOrderAndOutputCspMap.put(outputObj.NokiaCPQ_code__c+outputObj.NokiaCPQ_Parent_Proposal_Line_Item__c+outputObj.PCI_Type__c, outputObj);
                }
            }
            
            for(Apttus_Proposal__Proposal_Line_Item__c propLineObj : cspOderAndPliMap.keySet()){
                system.debug('serialNumber3--->'+serialNumber);
                if(propLineObj.Apttus_Proposal__Description__c.contains('GS Deploy Services Items'))
                {
                    system.debug('In if');
                    //createOutputObjRecordsForStandalone(cspOderAndPliMap,quoteObj,propLineItemObj);
                }else if(propLineObj.Product_Classification__c!= Null &&
                         propLineObj.Product_Classification__c.equalsIgnoreCase('Deploy Services') ){
                         }else{
                             for(NokiaCPQ_CSP_ordering_export_mapping__c cspOrderObj : cspOderAndPliMap.get(propLineObj).keySet()){                    
                                 double serialNumberInnerSI = cspOrderAndOutputCspMap.get(cspOrderObj.PCI_Code__c+propLineObj.id+cspOrderObj.PCI_Type__c).NokiaCPQ_Serial_Number__c;
                                 for(Apttus_Proposal__Proposal_Line_Item__c propLineItemObj : cspOderAndPliMap.get(propLineObj).get(cspOrderObj)){
                                     ++position;
                                     ++serialNumberInnerSI; 
                                     NokiaCPQ_output_CSP_mapping__c outputCspObjInner = new NokiaCPQ_output_CSP_mapping__c();
                                     outputCspObjInner.NokiaCPQ_Parent_PCI__c = cspOrderAndOutputCspMap.get(cspOrderObj.PCI_Code__c+propLineObj.id+cspOrderObj.PCI_Type__c).id;
                                     outputCspObjInner.Parent_Position__c = cspOrderAndOutputCspMap.get(cspOrderObj.PCI_Code__c+propLineObj.id+cspOrderObj.PCI_Type__c).Position__c;
                                     System.debug('SI serialNumberInnerSI-->'+serialNumberInnerSI);
                                     standaloneSerialNumber = serialNumberInnerSI;
                                     outputCspObjInner.NokiaCPQ_Serial_Number__c = serialNumberInnerSI;
                                     outputCspObjInner.NokiaCPQ_Descpription__c = propLineItemObj.NokiaCPQ_Product_Description__c;
                                     outputCspObjInner.NokiaCPQ_code__c = propLineItemObj.Product_Code__c;
                                     outputCspObjInner.NokiaCPQ_Proposal_Line_Item__c = propLineItemObj.Id;
                                     outputCspObjInner.QuoteId__c = propLineItemObj.Apttus_Proposal__Proposal__c;
                                     outputCspObjInner.PCI_Type__c = cspOrderAndOutputCspMap.get(cspOrderObj.PCI_Code__c+propLineObj.id+cspOrderObj.PCI_Type__c).PCI_Type__c;
                                     
                                     if(mapModeMainFlag == true){
                                         //outputCspObjInner.Quantity__c = propLineItemObj.NokiaCPQ_Quantity__c*cspOrderAndOutputCspMap.get(cspOrderObj.PCI_Code__c+propLineObj.id+cspOrderObj.PCI_Type__c).Quantity__c;   
                                         
                                         outputCspObjInner.Quantity__c = propLineItemObj.Total_Option_Quantity__c;
                                         
                                     }else{
                                         //outputCspObjInner.Quantity__c = propLineItemObj.NokiaCPQ_Quantity__c*groupToParentPLIMap.get(propLineObj.Id).NokiaCPQ_Quantity__c;   
                                         outputCspObjInner.Quantity__c = propLineItemObj.Total_Option_Quantity__c;
                                         
                                     }
                                     if(propLineItemObj.ISP_Per_Unit__c!=null && propLineItemObj.ISP_Per_Unit__c>0){
                                         outputCspObjInner.ISP_per_unit__c = propLineItemObj.ISP_Per_Unit__c.setScale(2, RoundingMode.HALF_UP);
                                     }
                                     else{
                                         outputCspObjInner.ISP_per_unit__c = 0.01;
                                         outputCspObjInner.FOC_flag__c = Nokia_CPQ_Constants.ENGLISH_ALPHABET_X ; 
                                     }
                                     //  outputCspObjInner.ISP_per_unit__c = propLineItemObj.ISP_Per_Unit__c.setScale(2, RoundingMode.HALF_UP);                        
                                     outputCspObjInner.ISP_Currency__c = quoteObj.CurrencyIsoCode;
                                     outputCspObjInner.Position__c = position;
                                     outputCspObjInner.Item_Level__c = 2;
                                     outputCspObjInner.NokiaCPQ_Parent_Proposal_Line_Item__c = propLineObj.Id;
                                     outputCspMapObjListforPLI.add(outputCspObjInner);
                                 } 
                             }
                         }
            }
            
            for(NokiaCPQ_Validity_Range_Mapping__c valRange : [Select Id, Name, NokiaCPQ_Product_Number__c, NokiaCPQ_Validity_Range__c from NokiaCPQ_Validity_Range_Mapping__c Limit 100]){                
                for(NokiaCPQ_output_CSP_mapping__c outputObj : outputCspMapObjListforPLI){
                    if(outputObj.NokiaCPQ_code__c.equalsIgnoreCase(valRange.NokiaCPQ_Product_Number__c)){
                        outputObj.NokiaCPQ_Validity_Range__c = valRange.NokiaCPQ_Validity_Range__c;
                    }
                }          
            }  
            system.debug('outputCspMapObjListforPLI>>'+outputCspMapObjListforPLI);
            if(!outputCspMapObjListforPLI.isEmpty()){
                database.insert(outputCspMapObjListforPLI); 
            }
            createOutputObjRecordsForStandalone(cspOderAndPliMap,quoteObj,GSDeployList,standaloneSerialNumber);
        }catch(Exception e){
            ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName()+e.getLineNumber()+e.getMessage(),Nokia_CPQ_Constants.ERROR_MSD);  
        }
    }
    
    /***************************************
* Method Name : gernateExportCSP
* Parameters : Quote Id, List of Apttus_Proposal__Proposal_Line_Item__c
* Return Type : Void
* Description : Method creates Parent Proposal Line Item to Options Map and Parent Proposal Line item to Attribute value object Map and pass it to next method.
*********************************/
    public static Map<Apttus_Proposal__Proposal_Line_Item__c,List<Apttus_Proposal__Proposal_Line_Item__c>> mapSSETOSI(List<Apttus_Proposal__Proposal_Line_Item__c> listFinalizedLineItems){
        
        Map<Decimal, List<Apttus_Proposal__Proposal_Line_Item__c>> mapParentBundleLineNoAndItsRecord1 = new Map<Decimal, List<Apttus_Proposal__Proposal_Line_Item__c>>();
        Map<Decimal, List<Apttus_Proposal__Proposal_Line_Item__c>> groupNumToSIMap = new Map<Decimal, List<Apttus_Proposal__Proposal_Line_Item__c>>();
        parentToSImap = new Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>>();
        Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>> parentToSImap1 = new Map<Apttus_Proposal__Proposal_Line_Item__c, List<Apttus_Proposal__Proposal_Line_Item__c>>();
        Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c> PLIandAttributeMap = new Map<String, Apttus_QPConfig__ProposalProductAttributeValue__c>();
        Map<Decimal,Apttus_Proposal__Proposal_Line_Item__c> allGroupProdNumber = new Map<Decimal,Apttus_Proposal__Proposal_Line_Item__c>();
        Map<Decimal,Apttus_Proposal__Proposal_Line_Item__c> primaryLineNumToParentMap = new Map<Decimal,Apttus_Proposal__Proposal_Line_Item__c>();
        Map<Decimal,Decimal> groupToParentNumMap = new Map<Decimal,Decimal>();
        Apttus_Proposal__Proposal_Line_Item__c servicesLineItem = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Description__c='GS Deploy Services Items');
        try{
            system.debug('listFinalizedLineItems>>>'+listFinalizedLineItems);
            system.debug('listFinalizedLineItems size>>>'+listFinalizedLineItems.size());
            // filter all SIs with there primary line number.
            for(Apttus_Proposal__Proposal_Line_Item__c objLineItem : listFinalizedLineItems){             
                //  system.debug('objLineItem.Apttus_QPConfig__LineNumber__c>>'+objLineItem.Apttus_QPConfig__LineNumber__c);
                system.debug('mapParentBundleLineNoAndItsRecord1.keySet'+mapParentBundleLineNoAndItsRecord1.keySet());
                //As per New Airscale Wifi Product Design filter all Groups with SI's
                
                // if(mapParentBundleLineNoAndItsRecord1.containsKey(objLineItem.Apttus_QPConfig__LineNumber__c) || 
                //     mapParentBundleLineNoAndItsRecord1.containsKey(9999))
                
                if(mapParentBundleLineNoAndItsRecord1.containsKey(objLineItem.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c) || 
                   mapParentBundleLineNoAndItsRecord1.containsKey(9999))
                    
                {                       
                    if(objLineItem.NokiaCPQ_Configuration_Type__c == 'Standalone' && objLineItem.Apttus_QPConfig__LineType__c == 'Product/Service'
                       && objLineItem.NokiaCPQ_Item_Type__c == 'Service' )
                    {
                        if(mapParentBundleLineNoAndItsRecord1.containsKey(9999))
                            mapParentBundleLineNoAndItsRecord1.get(9999).add(objLineItem);
                    }else{
                        if(mapParentBundleLineNoAndItsRecord1.containsKey(objLineItem.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c))
                            mapParentBundleLineNoAndItsRecord1.get(objLineItem.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c).add(objLineItem);
                    }
                }                
                else{
                    system.debug('mapParentBundleLineNoAndItsRecord1.containsKey(9999)>>'+mapParentBundleLineNoAndItsRecord1.containsKey(9999));
                    List<Apttus_Proposal__Proposal_Line_Item__c> newPropLineItemList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
                    newPropLineItemList.add(objLineItem);
                    system.debug('newPropLineItemList>>'+newPropLineItemList);
                    if(objLineItem.NokiaCPQ_Configuration_Type__c == 'Standalone' && objLineItem.Apttus_QPConfig__LineType__c == 'Product/Service' && objLineItem.NokiaCPQ_Item_Type__c == 'Service')                 
                        mapParentBundleLineNoAndItsRecord1.put(9999, newPropLineItemList);
                    else
                        mapParentBundleLineNoAndItsRecord1.put(objLineItem.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c, newPropLineItemList);                    
                }
                system.debug('mapParentBundleLineNoAndItsRecord1.keySet'+mapParentBundleLineNoAndItsRecord1.keySet());
                if(objLineItem.Apttus_QPConfig__ChargeType__c.equalsIgnoreCase(Nokia_CPQ_Constants.STANDARD) && objLineItem.NokiaCPQ_Configuration_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.BUNDLE) && objLineItem.Apttus_QPConfig__ParentBundleNumber__c == Null)
                {
                    primaryLineNumToParentMap.put(objLineItem.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c,objLineItem);
                }
                /**End Here**/
                
            }
            system.debug('mapParentBundleLineNoAndItsRecord1.keySet>>'+mapParentBundleLineNoAndItsRecord1.keySet());
            
            for(Decimal primaryLineNumbers : mapParentBundleLineNoAndItsRecord1.keySet()){
                //Piyush 10.5.19                
                for(Apttus_Proposal__Proposal_Line_Item__c proposalLineItem : mapParentBundleLineNoAndItsRecord1.get(primaryLineNumbers)){
                    
                    if(proposalLineItem.Apttus_QPConfig__ChargeType__c.equalsIgnoreCase(Nokia_CPQ_Constants.STANDARD) && proposalLineItem.NokiaCPQ_Configuration_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.BUNDLE) && proposalLineItem.Apttus_QPConfig__LineType__c=='Option'){
                        allGroupProdNumber.put(proposalLineItem.Apttus_QPConfig__PrimaryLineNumber__c,proposalLineItem);
                        groupToParentNumMap.put(proposalLineItem.Apttus_QPConfig__PrimaryLineNumber__c,proposalLineItem.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c );
                    }else if(proposalLineItem.Apttus_QPConfig__ChargeType__c.equalsIgnoreCase(Nokia_CPQ_Constants.STANDARD) && proposalLineItem.NokiaCPQ_Configuration_Type__c.equalsIgnoreCase('Standalone') && proposalLineItem.Apttus_QPConfig__LineType__c=='Product/Service')
                    {
                        if(!allGroupProdNumber.containsKey(9999))
                            allGroupProdNumber.put(9999,servicesLineItem);
                    }
                }
                system.debug('allGroupProdNumber'+allGroupProdNumber.keySet());
                //child Group to SI maping
                for(Apttus_Proposal__Proposal_Line_Item__c proposalLineItem : mapParentBundleLineNoAndItsRecord1.get(primaryLineNumbers)){
                    system.debug('in for******************proposalLineItem>>>>>>>>>>>>>>>>>>>>>>'+proposalLineItem);
                    if(proposalLineItem.Apttus_QPConfig__ChargeType__c.equalsIgnoreCase(Nokia_CPQ_Constants.STANDARD) && proposalLineItem.NokiaCPQ_Configuration_Type__c.equalsIgnoreCase('Standalone') && proposalLineItem.Apttus_QPConfig__LineType__c=='Product/Service'){
                        system.debug('in if******************proposalLineItem>>>>>>>>>>>'+proposalLineItem);
                        if(groupNumToSIMap.containskey(9999))
                        {
                            groupNumToSIMap.get(9999).add(proposalLineItem);
                        }else{
                            List<Apttus_Proposal__Proposal_Line_Item__c> plItem = new List<Apttus_Proposal__Proposal_Line_Item__c>();
                            plItem.add(proposalLineItem);
                            groupNumToSIMap.put(9999,plItem);
                        }
                        system.debug('groupNumToSIMap'+groupNumToSIMap);
                    }else if(proposalLineItem.Apttus_QPConfig__ChargeType__c.equalsIgnoreCase(Nokia_CPQ_Constants.STANDARD) && proposalLineItem.NokiaCPQ_Configuration_Type__c.equalsIgnoreCase('Standalone') && proposalLineItem.Apttus_QPConfig__LineType__c=='Option'){
                        system.debug('in else******************proposalLineItem>>>>>>>>>>>'+proposalLineItem);
                        if(groupNumToSIMap.containsKey(proposalLineItem.Apttus_QPConfig__ParentBundleNumber__c))
                        {
                            groupNumToSIMap.get(proposalLineItem.Apttus_QPConfig__ParentBundleNumber__c).add(proposalLineItem);
                        }
                        else{
                            List<Apttus_Proposal__Proposal_Line_Item__c> plItem = new List<Apttus_Proposal__Proposal_Line_Item__c>();
                            plItem.add(proposalLineItem);
                            groupNumToSIMap.put(proposalLineItem.Apttus_QPConfig__ParentBundleNumber__c,plItem);
                        }
                    }
                }
                
                
                //for(Decimal num : groupNumToSIMap.keySet()){
                for(Decimal num : allGroupProdNumber.keySet()){
                    system.debug('num>>>'+num);
                    if(allGroupProdNumber.containsKey(num)){
                        parentToSImap1.put(allGroupProdNumber.get(num),groupNumToSIMap.get(num));
                    }
                }                
                /*End Here*/
            }
            for(Decimal num : groupToParentNumMap.keySet())
            {
                if(allGroupProdNumber.containskey(num) && primaryLineNumToParentMap.containsKey(groupToParentNumMap.get(num))){
                    groupToParentMap.put(allGroupProdNumber.get(num).Id,primaryLineNumToParentMap.get(groupToParentNumMap.get(num)).Id);
                    groupToParentPLIMap.put(allGroupProdNumber.get(num).Id,primaryLineNumToParentMap.get(groupToParentNumMap.get(num)));
                }                    
                
            }
                       
        }
        
        catch(Exception e){
            ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName()+e.getLineNumber()+e.getMessage(),Nokia_CPQ_Constants.ERROR_MSD);
            system.debug('exc'+e.getMessage()+'sp'+e.getCause());
            system.debug('exc'+e.getLineNumber());
        }
        return parentToSImap1;
    }
    
    /***************************************
* Method Name : createOutputObjRecordsForStandalone
* Parameters : Quote Id, Map<Apttus_Proposal__Proposal_Line_Item__c,Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c>>>
* Return Type : Void
* Description : Methods creates Output CSP Mapping Object records to be used in CSP Export.
*********************************/
    // pass serial number from calling method  and check for null and if this method serial number is null then assign value of parent serial number
    public static void createOutputObjRecordsForStandalone(Map<Apttus_Proposal__Proposal_Line_Item__c,Map<NokiaCPQ_CSP_ordering_export_mapping__c,List<Apttus_Proposal__Proposal_Line_Item__c>>> cspOderAndPliMap, Apttus_Proposal__Proposal__c quoteObj,List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList,decimal serialNumberUptoBundle){
        
        try{
            List<NokiaCPQ_output_CSP_mapping__c> outputCspMapObjList = new List<NokiaCPQ_output_CSP_mapping__c>();
            List<NokiaCPQ_output_CSP_mapping__c> outputCspMapObjListforPLI = new List<NokiaCPQ_output_CSP_mapping__c>();
            List<NokiaCPQ_output_CSP_mapping__c> outputCspMapObjListforPLItoDelete = new List<NokiaCPQ_output_CSP_mapping__c>();
            Map<String, NokiaCPQ_output_CSP_mapping__c> cspOrderAndOutputCspMap = new Map<String, NokiaCPQ_output_CSP_mapping__c>();
            List<NokiaCPQ_Validity_Range_Mapping__c> ValidityRangeList = new List<NokiaCPQ_Validity_Range_Mapping__c>();
            double position = 0;
            boolean checkserialnum =false;
           
            double serialNumber = serialNumberUptoBundle;//0;
            Integer configNumber = 0;
           
            
            decimal serialnumberatlevel0;
            for(Apttus_Proposal__Proposal_Line_Item__c proposalLineItem : proposalLineItemList){
                
                if(proposalLineItem.Apttus_Proposal__Description__c.contains('GS Deploy Services Items')){
                    
                    for(NokiaCPQ_CSP_ordering_export_mapping__c cspOrderObj : cspOderAndPliMap.get(proposalLineItem).keySet()){
                        
                        
                        for(Apttus_Proposal__Proposal_Line_Item__c propLineItemObj : cspOderAndPliMap.get(proposalLineItem).get(cspOrderObj)){
                            
                           
                            // level -0 
                            if(checkserialnum ==false){
                                position++;
                                serialNumber++;
                                
                            }
                            else{
                                
                                position=position+2;
                                serialNumber=serialNumber+2;
                                
                                
                            }
                            //serialnumberatlevel0 =serialNumber;
                            NokiaCPQ_output_CSP_mapping__c outputCspObjNew = new NokiaCPQ_output_CSP_mapping__c();
                            outputCspObjNew.Item_Level__c = 0;
                            outputCspObjNew.QuoteId__c = quoteObj.Id;
                            outputCspObjNew.NokiaCPQ_Serial_Number__c = serialNumber;
                            outputCspObjNew.NokiaCPQ_Customer_Material_Number__c = propLineItemObj.CMN__c;                            
                            
                            
                            if(proposalLineItem.Apttus_Proposal__Description__c.contains('GS Deploy Services Items')  || proposalLineItem.Product_Classification__c.contains('Deploy Services'))
                            {
                                system.debug('Level 0>>>'+proposalLineItem.NokiaCPQ_Product_Name__c+'>>inside GS :: PLI sequence no.>>>'+ proposalLineItem.Sequence_Site_Id__c);
                                outputCspObjNew.NokiaCPQ_Descpription__c = System.Label.Nokia_Deploy_Services;
                                
                            }else
                            {
                                outputCspObjNew.NokiaCPQ_Descpription__c = proposalLineItem.NokiaCPQ_Product_Name__c;
                                
                            }
                           // outputCspObjNew.Quantity__c = 1;
                            outputCspObjNew.Position__c = position;
                            outputCspObjNew.PCI_Type__c = 'Service PCI';
                            outputCspMapObjList.add(outputCspObjNew);
                            
                            
                            
                            // level- 1
                            NokiaCPQ_output_CSP_mapping__c outputCspObj = new NokiaCPQ_output_CSP_mapping__c();
                           
                            position++;
                            serialNumber++;
                            outputCspObj.NokiaCPQ_code__c = cspOrderObj.PCI_Code__c;
                            outputCspObj.QuoteId__c = quoteObj.Id;
                            outputCspObj.ISP_Currency__c = quoteObj.CurrencyIsoCode;
                            outputCspObj.Position__c = position;
                            outputCspObj.Item_Level__c = 1;
                            outputCspObj.NokiaCPQ_Customer_Material_Number__c = propLineItemObj.CMN__c; 
                            outputCspObj.Quantity__c = propLineItemObj.NokiaCPQ_Quantity__c;            
                            System.debug('code--->'+propLineItemObj.Product_Code__c);
                            System.debug('id--->'+propLineItemObj.id);
                            outputCspObj.NokiaCPQ_Proposal_Line_Item__c = propLineItemObj.id;              
                            outputCspObj.PCI_Type__c = cspOrderObj.PCI_Type__c;
                            outputCspObj.NokiaCPQ_Serial_Number__c = serialNumber;
                            outputCspMapObjList.add(outputCspObj);
                            checkserialnum = true;  
                        }
                    }  
                    
                }
                else{
                    
                    position++;
                    serialNumber++;
                    
                    
                    NokiaCPQ_output_CSP_mapping__c outputCspObjNew = new NokiaCPQ_output_CSP_mapping__c();
                    outputCspObjNew.Item_Level__c = 0;
                    //outputCspObjNew.NokiaCPQ_Descpription__c = proposalLineItem.Apttus_Proposal__Description__c;
                    
                    outputCspObjNew.QuoteId__c = quoteObj.Id;
                    outputCspObjNew.NokiaCPQ_Serial_Number__c = serialNumber;
                    if((proposalLineItem.Apttus_Proposal__Description__c.contains('GS Deploy Services Items')  || proposalLineItem.Product_Classification__c.contains('Deploy Services')) && proposalLineItem.CMN__c!= null){
                        outputCspObjNew.NokiaCPQ_Customer_Material_Number__c = proposalLineItem.CMN__c;                            
                        
                    }
                    /*else if((proposalLineItem.Apttus_Proposal__Description__c.contains('GS Deploy Services Items')  || proposalLineItem.Product_Classification__c.contains('Deploy Services'))&& proposalLineItem.CMN__c == null){
for(NokiaCPQ_CSP_ordering_export_mapping__c cspOrderObj : cspOderAndPliMap.get(proposalLineItem).keySet()){     
if(proposalLineItem.Apttus_Proposal__Description__c.contains('GS Deploy Services Items'))
{
system.debug('In if');
for(Apttus_Proposal__Proposal_Line_Item__c propLineItemVar : cspOderAndPliMap.get(proposalLineItem).get(cspOrderObj)){
System.debug('inside for CMN-->'+propLineItemVar.CMN__c);
outputCspObjNew.NokiaCPQ_Customer_Material_Number__c = propLineItemVar.CMN__c; 
break;
}

}
}
}*/
                    
                    
                    if(proposalLineItem.Apttus_Proposal__Description__c.contains('GS Deploy Services Items')  || proposalLineItem.Product_Classification__c.contains('Deploy Services'))
                    {
                        system.debug('Level 0>>>'+proposalLineItem.NokiaCPQ_Product_Name__c+'>>inside GS :: PLI sequence no.>>>'+ proposalLineItem.Sequence_Site_Id__c);
                        outputCspObjNew.NokiaCPQ_Descpription__c = System.Label.Nokia_Deploy_Services;
                       // outputCspObjNew.Quantity__c = 1;
                    }else
                    {
                        outputCspObjNew.NokiaCPQ_Descpription__c = proposalLineItem.NokiaCPQ_Product_Name__c;
                       // outputCspObjNew.Quantity__c = proposalLineItem.NokiaCPQ_Quantity__c;
                    }
                    //outputCspObjNew.Quantity__c = 1;
                    outputCspObjNew.Position__c = position;
                    outputCspObjNew.PCI_Type__c = 'Service PCI';
                    outputCspMapObjList.add(outputCspObjNew);
                    
                    for(NokiaCPQ_CSP_ordering_export_mapping__c cspOrderObj : cspOderAndPliMap.get(proposalLineItem).keySet()){
                        
                        if(cspOderAndPliMap.get(proposalLineItem).get(cspOrderObj).size()>0){
                            ++serialNumber;
                            ++position;
                            NokiaCPQ_output_CSP_mapping__c outputCspObj = new NokiaCPQ_output_CSP_mapping__c();
                            outputCspObj.NokiaCPQ_code__c = cspOrderObj.PCI_Code__c;
                            outputCspObj.QuoteId__c = quoteObj.Id;
                            outputCspObj.ISP_Currency__c = quoteObj.CurrencyIsoCode;
                            outputCspObj.Position__c = position;
                            outputCspObj.Item_Level__c = 1;
                            if((proposalLineItem.Apttus_Proposal__Description__c.contains('GS Deploy Services Items')  || proposalLineItem.Product_Classification__c.contains('Deploy Services')) && proposalLineItem.CMN__c == null)
                            {
                                outputCspObj.NokiaCPQ_Customer_Material_Number__c = outputCspObjNew.NokiaCPQ_Customer_Material_Number__c;  
                            }
                            else{
                                outputCspObj.NokiaCPQ_Customer_Material_Number__c = proposalLineItem.CMN__c;
                                
                            }
                            if(proposalLineItem.Apttus_Proposal__Description__c.contains('GS Deploy Services Items'))
                            {
                                
                                outputCspObj.Quantity__c = 1; 
                                
                            }else
                            {
                                if(mapModeMainFlag == true){
                                    outputCspObj.Quantity__c = proposalLineItem.NokiaCPQ_Quantity__c;
                                    
                                }
                                else{
                                    outputCspObj.Quantity__c =    proposalLineItem.NokiaCPQ_Quantity__c*groupToParentPLIMap.get(proposalLineItem.Id).NokiaCPQ_Quantity__c;
                                    
                                }
                                outputCspObj.NokiaCPQ_Parent_Proposal_Line_Item__c = proposalLineItem.id;              
                            }
                            //outputCspObj.Quantity__c = 1;                       
                            //outputCspObj.NokiaCPQ_Parent_Proposal_Line_Item__c = proposalLineItem.id;
                            outputCspObj.PCI_Type__c = cspOrderObj.PCI_Type__c;
                            outputCspObj.NokiaCPQ_Serial_Number__c = serialNumber;
                            outputCspMapObjList.add(outputCspObj);
                            serialNumber = serialNumber + cspOderAndPliMap.get(proposalLineItem).get(cspOrderObj).size();
                        }
                        
                    }
                }
            }
            system.debug('outputCspMapObjList>>'+outputCspMapObjList);
            if(!outputCspMapObjList.isEmpty()){
                Database.insert(outputCspMapObjList);
            }            
            Map<String,NokiaCPQ_output_CSP_mapping__c> pcodeMap = new Map<String,NokiaCPQ_output_CSP_mapping__c>();
            for(NokiaCPQ_output_CSP_mapping__c outputObj : outputCspMapObjList){ 
                
                if(!String.isBlank(outputObj.PCI_Type__c)){
                    if(outputObj.NokiaCPQ_Parent_Proposal_Line_Item__c != Null)
                        cspOrderAndOutputCspMap.put(outputObj.NokiaCPQ_code__c+outputObj.NokiaCPQ_Parent_Proposal_Line_Item__c+outputObj.PCI_Type__c, outputObj); 
                    else  
                        cspOrderAndOutputCspMap.put(outputObj.NokiaCPQ_code__c+outputObj.NokiaCPQ_Proposal_Line_Item__c  +outputObj.PCI_Type__c, outputObj);
                    //cspOrderAndOutputCspMap.put(outputObj.NokiaCPQ_code__c+'9999'+outputObj.PCI_Type__c, outputObj);
                }
                
            }
            
           for(Apttus_Proposal__Proposal_Line_Item__c proposalLineItem : proposalLineItemList ){
                for(NokiaCPQ_CSP_ordering_export_mapping__c cspOrderObj : cspOderAndPliMap.get(proposalLineItem).keySet()){     
                    if(proposalLineItem.Apttus_Proposal__Description__c.contains('GS Deploy Services Items'))
                    {
                        system.debug('In if');
                        //cspOrderAndOutputCspMap.get(cspOrderObj.PCI_Code__c++cspOrderObj.PCI_Type__c).NokiaCPQ_Serial_Number__c;
                        for(Apttus_Proposal__Proposal_Line_Item__c propLineItemVar : cspOderAndPliMap.get(proposalLineItem).get(cspOrderObj)){
                            double serialNumberInnerSI;
                            if(cspOrderObj.PCI_Code__c != null){
                                serialNumberInnerSI  =cspOrderAndOutputCspMap.get(cspOrderObj.PCI_Code__c+propLineItemVar.id+cspOrderObj.PCI_Type__c).NokiaCPQ_Serial_Number__c; 
                            }
                            
                          
                            level2serialnum = serialNumberInnerSI;
                            position++;
                            serialNumberInnerSI++; 
                            
                            NokiaCPQ_output_CSP_mapping__c outputCspObjInner = new NokiaCPQ_output_CSP_mapping__c();
                            outputCspObjInner.NokiaCPQ_Parent_PCI__c = cspOrderAndOutputCspMap.get(cspOrderObj.PCI_Code__c+propLineItemVar.id+cspOrderObj.PCI_Type__c).id;
                            outputCspObjInner.Parent_Position__c = cspOrderAndOutputCspMap.get(cspOrderObj.PCI_Code__c+propLineItemVar.id+cspOrderObj.PCI_Type__c).Position__c;
                            outputCspObjInner.NokiaCPQ_Serial_Number__c = serialNumberInnerSI;
                            outputCspObjInner.NokiaCPQ_Descpription__c = propLineItemVar.NokiaCPQ_Product_Description__c;
                            outputCspObjInner.NokiaCPQ_code__c = propLineItemVar.Product_Code__c;
                            outputCspObjInner.NokiaCPQ_Proposal_Line_Item__c = propLineItemVar.Id;
                            outputCspObjInner.QuoteId__c = propLineItemVar.Apttus_Proposal__Proposal__c;
                            outputCspObjInner.PCI_Type__c = cspOrderAndOutputCspMap.get(cspOrderObj.PCI_Code__c+propLineItemVar.id+cspOrderObj.PCI_Type__c).PCI_Type__c;
                            outputCspObjInner.Quantity__c = propLineItemVar.NokiaCPQ_Quantity__c;                                                                     
                            outputCspObjInner.ISP_per_unit__c = propLineItemVar.ISP_Per_Unit__c.setScale(2, RoundingMode.HALF_UP);                        
                            outputCspObjInner.ISP_Currency__c = quoteObj.CurrencyIsoCode;
                            outputCspObjInner.Position__c = position;
                            outputCspObjInner.Item_Level__c = 2;
                            //outputCspObjInner.NokiaCPQ_Parent_Proposal_Line_Item__c = proposalLineItem.Id;
                            outputCspMapObjListforPLI.add(outputCspObjInner);
                            serialNumber =serialNumberInnerSI;
                            
                        }
                    }else{ 
                        double serialNumberInnerSI = cspOrderAndOutputCspMap.get(cspOrderObj.PCI_Code__c+proposalLineItem.id+cspOrderObj.PCI_Type__c).NokiaCPQ_Serial_Number__c;
                        for(Apttus_Proposal__Proposal_Line_Item__c propLineItemObj : cspOderAndPliMap.get(proposalLineItem).get(cspOrderObj)){
                            ++position;
                            ++serialNumberInnerSI; 
                            NokiaCPQ_output_CSP_mapping__c outputCspObjInner = new NokiaCPQ_output_CSP_mapping__c();
                            outputCspObjInner.NokiaCPQ_Parent_PCI__c = cspOrderAndOutputCspMap.get(cspOrderObj.PCI_Code__c+proposalLineItem.id+cspOrderObj.PCI_Type__c).id;
                            outputCspObjInner.Parent_Position__c = cspOrderAndOutputCspMap.get(cspOrderObj.PCI_Code__c+proposalLineItem.id+cspOrderObj.PCI_Type__c).Position__c;
                            outputCspObjInner.NokiaCPQ_Serial_Number__c = serialNumberInnerSI;
                            outputCspObjInner.NokiaCPQ_Descpription__c = propLineItemObj.NokiaCPQ_Product_Description__c;
                            outputCspObjInner.NokiaCPQ_code__c = propLineItemObj.Product_Code__c;
                            outputCspObjInner.NokiaCPQ_Proposal_Line_Item__c = propLineItemObj.Id;
                            outputCspObjInner.QuoteId__c = propLineItemObj.Apttus_Proposal__Proposal__c;
                            outputCspObjInner.PCI_Type__c = cspOrderAndOutputCspMap.get(cspOrderObj.PCI_Code__c+proposalLineItem.id+cspOrderObj.PCI_Type__c).PCI_Type__c;
                            
                            if(mapModeMainFlag == true){
                                outputCspObjInner.Quantity__c = propLineItemObj.NokiaCPQ_Quantity__c*cspOrderAndOutputCspMap.get(cspOrderObj.PCI_Code__c+proposalLineItem.id+cspOrderObj.PCI_Type__c).Quantity__c;                      
                            }else{
                                outputCspObjInner.Quantity__c = propLineItemObj.NokiaCPQ_Quantity__c*groupToParentPLIMap.get(proposalLineItem.Id).NokiaCPQ_Quantity__c;                                              
                            }                        
                            outputCspObjInner.ISP_per_unit__c = propLineItemObj.ISP_Per_Unit__c.setScale(2, RoundingMode.HALF_UP);                        
                            outputCspObjInner.ISP_Currency__c = quoteObj.CurrencyIsoCode;
                            outputCspObjInner.Position__c = position;
                            outputCspObjInner.Item_Level__c = 2;
                            outputCspObjInner.NokiaCPQ_Parent_Proposal_Line_Item__c = proposalLineItem.Id;
                            outputCspMapObjListforPLI.add(outputCspObjInner);
                            serialNumber =serialNumberInnerSI;
                        } 
                    }                                          
                }
            }
            for(NokiaCPQ_Validity_Range_Mapping__c valRange : [Select Id, Name, NokiaCPQ_Product_Number__c, NokiaCPQ_Validity_Range__c from NokiaCPQ_Validity_Range_Mapping__c Limit 100]){                
                for(NokiaCPQ_output_CSP_mapping__c outputObj : outputCspMapObjListforPLI){
                    if(outputObj.NokiaCPQ_code__c.equalsIgnoreCase(valRange.NokiaCPQ_Product_Number__c)){
                        outputObj.NokiaCPQ_Validity_Range__c = valRange.NokiaCPQ_Validity_Range__c;
                    }
                }          
            }
            
            system.debug('outputCspMapObjListforPLI>>'+outputCspMapObjListforPLI);
            if(!outputCspMapObjListforPLI.isEmpty()){
                database.insert(outputCspMapObjListforPLI); 
            }
            
        }catch(Exception e){
            ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName()+e.getLineNumber()+e.getMessage(),Nokia_CPQ_Constants.ERROR_MSD);            
        }
    }
}