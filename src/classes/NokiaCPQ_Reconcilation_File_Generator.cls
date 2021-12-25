/***************************************
* Class Name : NokiaCPQ_Reconcilation_File_Generator
* Author : Accenture
* Developer : Ankit Maheshwari
* Description : The class is used to create Output CSP Reconcilation Export records used in CSP Export including GS Service SI REQ: 6238, 6232
**********************************/ 
public without sharing class NokiaCPQ_Reconcilation_File_Generator{
	public Static Map<String, NokiaCPQ_CSP_Map_Control__c> productNameAndNokiaCSPMapControl = new Map<String, NokiaCPQ_CSP_Map_Control__c>();
	public static map<Decimal,Decimal> mapPrimaryLineToParentline = new map<Decimal,Decimal>();
	public Static map<decimal,Apttus_Proposal__Proposal_Line_Item__c> mapOfMainAndStandaloneProductsWithSequenceNumber = new map<decimal,Apttus_Proposal__Proposal_Line_Item__c>();
	public static String PLIbundleOptionMapping(String quoteId){
		map<decimal,Apttus_Proposal__Proposal_Line_Item__c> mapOfMainAndStandaloneProducts = new map<Decimal,Apttus_Proposal__Proposal_Line_Item__c>();
		map<String, Decimal> mapOfLineNumAndArcProdCodeWithPrimaryLine = new map<String, Decimal>();
		map<decimal,list<Apttus_Proposal__Proposal_Line_Item__c>> mapParentbundlenumberwithListOptions = new map<Decimal,list<Apttus_Proposal__Proposal_Line_Item__c>>();
		map<decimal,list<Apttus_Proposal__Proposal_Line_Item__c>> mapParentbundlenumberWithListOptionsDummyFiltered = new map<Decimal,list<Apttus_Proposal__Proposal_Line_Item__c>>();
		map<Decimal,Apttus_Proposal__Proposal_Line_Item__c> mapDummyBundles = new map<Decimal,Apttus_Proposal__Proposal_Line_Item__c>();
		map<Decimal,List<Apttus_Proposal__Proposal_Line_Item__c>> mapParentLineToOptions = new map<Decimal,List<Apttus_Proposal__Proposal_Line_Item__c>>();
		list<Reconciliation_Output_Staging__c> listReconciliation = new list<Reconciliation_Output_Staging__c>();
		String fileGenerated;
		String levelOneReconciliationGenerated;
		String levelTwoReconciliationGenerated;
		
		map<Decimal, String> mapPrimaryLineProductCode = new map<Decimal, String> ();
		try{
			String QuoteRecord = quoteId; 
			
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
			list<Reconciliation_Output_Staging__c> listOldROS = new list<Reconciliation_Output_Staging__c>([Select id from Reconciliation_Output_Staging__c where Quote_Proposal__c =: quoteId]);
			if(!listOldROS.isEmpty()){
				database.delete(listOldROS);
			}
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
				 OEM__c,Apttus_QPConfig__ItemSequence__c,Sequence_Site_Id__c,Is_Dummy_Product__c,Is_Dummy_Bundle__c, 
				 Apttus_QPConfig__OptionId__r.Apttus_Config2__ConfigurationType__c, NokiaCPQ_Rationale_Of_Adjustment__c,NokiaCPQ_Net_Price__c,
				 Apttus_QPConfig__ExtendedCost__c,NokiaCPQ_Extended_CUP_2__c,NokiaCPQ_Extended_IRP2__c,Apttus_Proposal__Quantity__c,
				 NokiaCPQ_Partner_Price__c, NokiaCPQ_Alias__c,Apttus_QPConfig__AdjustmentType__c,NokiaCPQ_Extended_Cost__c,NokiaCPQ_Extended_CLP_2__c,NokiaCPQ_Spare__c,
				 NokiaCPQ_ExtendedAdvance_NP__c, Apttus_QPConfig__IsPrimaryLine__c,Total_Option_Quantity__c, Apttus_QPConfig__Quantity2__c,NokiaCPQ_Unitary_IRPrice__c,Alias_for_Exports__c,CMN__c,Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c
				 FROM Apttus_Proposal__Proposal_Line_Item__c  WHERE Apttus_Proposal__Proposal__c =:quoteId and Apttus_QPConfig__IsPrimaryLine__c = true ORDER BY Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c ASC 
				 LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]);
			// Filter Main bundle and Standalone Products
			for(Apttus_Proposal__Proposal_Line_Item__c PLI : listFinalizedLineItems){
				if(PLI.Apttus_QPConfig__IsPrimaryLine__c)
					mapPrimaryLineProductCode.put(PLI.Apttus_QPConfig__PrimaryLineNumber__c, PLI.Product_Code__c);
				
				if(PLI.Apttus_QPConfig__ParentBundleNumber__c == null){
					mapOfMainAndStandaloneProducts.put(PLI.Apttus_QPConfig__PrimaryLineNumber__c,PLI);
		  mapOfMainAndStandaloneProductsWithSequenceNumber.put(PLI.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c,PLI);
					system.debug('Standalone & main bundle>>Primary Line>>>'+PLI.Apttus_QPConfig__PrimaryLineNumber__c);
				}
				//Filter record of Arcadia/dummy bundles/DirectOptions/Arcadia Options
				else if(PLI.Apttus_QPConfig__ParentBundleNumber__c != null){
					If(mapParentbundlenumberwithListOptions.containskey(PLI.Apttus_QPConfig__ParentBundleNumber__c)){
						mapParentbundlenumberwithListOptions.get(PLI.Apttus_QPConfig__ParentBundleNumber__c).add(PLI);
					}
					else{
						mapParentbundlenumberwithListOptions.put(PLI.Apttus_QPConfig__ParentBundleNumber__c,new list<Apttus_Proposal__Proposal_Line_Item__c>{PLI});
					}
					
					// map Primary Line & Parent Line number 1:1
					mapPrimaryLineToParentline.put(PLI.Apttus_QPConfig__PrimaryLineNumber__c,PLI.Apttus_QPConfig__ParentBundleNumber__c);
					
					// Collect Only Arcadia Bundles.
					//system.debug('Arcadia - >>>'+PLI.Product_Code__c + '<<<<Is Arcadia>>>'+PLI.NokiaCPQ_IsArcadiaBundle__c);
					if(PLI.NokiaCPQ_IsArcadiaBundle__c){
						String Key = PLI.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c+'_'+PLI.Product_Code__c;
						mapOfLineNumAndArcProdCodeWithPrimaryLine.put(Key, PLI.Apttus_QPConfig__PrimaryLineNumber__c);
					}
					
				}
				
				if(PLI.Is_Dummy_Bundle__c=='Yes'){
					mapDummyBundles.put(PLI.Apttus_QPConfig__PrimaryLineNumber__c,PLI);
				}
			}
			
			for(Decimal parentNumber : mapParentbundlenumberwithListOptions.keyset()){
				for(Apttus_Proposal__Proposal_Line_Item__c objChild : mapParentbundlenumberwithListOptions.get(parentNumber)){
					System.debug('beforeFilter>>> Top Bundle Primary Line::'+parentnumber+'::::Parent ProductCode:::'+mapPrimaryLineProductCode.get(parentnumber)+':::Child PrimayLine:::'+objChild.Apttus_QPConfig__PrimaryLineNumber__c+':: Child ProdCode:::'+objChild.Product_Code__c);
				}
			}
			
			system.debug('Dummy P´rimaryLine>>>>'+mapDummyBundles.keyset());
			
			// collect ParentBundleLineNumber and List of Options after dummy bundle filter.
			// Map contains, Main bundle & list of Direct/Arcadia/cust gr. and Arcadia or custom gr. & its option.
			mapParentbundlenumberWithListOptionsDummyFiltered = generateParentToChildOptionsHierarchy(mapPrimaryLineToParentline, mapDummyBundles, mapParentbundlenumberwithListOptions);
			
			//Method to create Level one records in Reconciliation object
			//insertLevelOneRecords(mapParentbundlenumberwithListOptions,mapOfMainAndStandaloneProducts);
			
			for(Decimal parentnumber : mapParentbundlenumberWithListOptionsDummyFiltered.keyset()){
				for(Apttus_Proposal__Proposal_Line_Item__c PLI : mapParentbundlenumberWithListOptionsDummyFiltered.get(parentnumber)){
					System.debug('After Filter>>>>Parent Bundle Primary Line::'+ parentnumber+'::::Parent ProductCode:::'+mapPrimaryLineProductCode.get(parentnumber)+':::Child PrimayLine:::'+PLI.Apttus_QPConfig__PrimaryLineNumber__c+':: Child ProdCode:::'+PLI.Product_Code__c);
				}			
			}
			//map of Arcadia Primary number List of QDSI
			Map<Decimal, List<Quote_Delivery_Sales_Item__c>> mapArcPrimayNumListQDSIs = new Map<Decimal, List<Quote_Delivery_Sales_Item__c>>();
			
			// manage Qoute Delivery SalesItems for Arcadia Bundle in case of CAT configuration.
			Map<String, List<Quote_Delivery_Sales_Item__c>> mapArcadiaChildQDSIs = new Map<String, List<Quote_Delivery_Sales_Item__c>>();
			mapArcadiaChildQDSIs= getQuoteDeliverySalesItemsForArcadia(quoteId);
			
			for(String keyOfQDSI : mapArcadiaChildQDSIs.keySet()){
				//system.debug('keyOfQDSI:::' + keyOfQDSI +'>>>>>'+mapOfLineNumAndArcProdCodeWithPrimaryLine.containskey(keyOfQDSI));
				if(mapOfLineNumAndArcProdCodeWithPrimaryLine.containskey(keyOfQDSI)){
					mapArcPrimayNumListQDSIs.put(mapOfLineNumAndArcProdCodeWithPrimaryLine.get(keyOfQDSI), mapArcadiaChildQDSIs.get(keyOfQDSI));
				}
			}
			
			//system.debug('mapArcPrimayNumListQDSIs.keyset()>>>>>>>'+mapArcPrimayNumListQDSIs.keyset());
			
			// Generate Data for All Stand Alone Items without Parent Main Bundle
			// logic to generate(serial no.) for Options for Arcadia/Cust Gr. level
			// create map of Line Number & Primary Line List. to serialize configuration.
			// sort Line Number and then process for Level 1 record egeneration.
			// Use QDSI & PLI options against Arcadia to count total serial no. for next Arcadia/DirectOption/Standalone level 1 record
			Map<Decimal, List<Decimal>> mapLineNumWithListPrimLineNumOfMainBundleStandalone = new Map<Decimal, List<Decimal>>();
			for(Apttus_Proposal__Proposal_Line_Item__c objMainBundleAndStandaloneItems : mapOfMainAndStandaloneProducts.Values()){
				if(mapLineNumWithListPrimLineNumOfMainBundleStandalone.containskey(objMainBundleAndStandaloneItems.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c))
					mapLineNumWithListPrimLineNumOfMainBundleStandalone.get(objMainBundleAndStandaloneItems.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c).Add(objMainBundleAndStandaloneItems.Apttus_QPConfig__PrimaryLineNumber__c);
				else
					mapLineNumWithListPrimLineNumOfMainBundleStandalone.put(objMainBundleAndStandaloneItems.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c, new List<Decimal> {objMainBundleAndStandaloneItems.Apttus_QPConfig__PrimaryLineNumber__c});
			}
			
			List<Decimal> sortedLineNum = new List<Decimal>(mapLineNumWithListPrimLineNumOfMainBundleStandalone.keySet());
			sortedLineNum.sort();
			
			decimal serialNumber=0;
			
			for(Decimal pliLineNum : sortedLineNum){
				system.debug('Line Number :::'+ pliLineNum);
				for(Decimal pliPrimaryLineNum : mapLineNumWithListPrimLineNumOfMainBundleStandalone.get(pliLineNum)){
					// generate level 1 record for output object..
					System.debug('>>Line Number of Main Bundle/Standalone Item>>'+pliLineNum+ ' ::: Primary Line :::'+ pliPrimaryLineNum +' >>> Main Bundle/Standalone ProdCode ::::'+mapOfMainAndStandaloneProducts.get(pliPrimaryLineNum).Product_Code__c + '::'+mapOfMainAndStandaloneProducts.get(pliPrimaryLineNum).NokiaCPQ_Configuration_Type__c);
					if(mapOfMainAndStandaloneProducts.containskey(pliPrimaryLineNum) && mapOfMainAndStandaloneProducts.get(pliPrimaryLineNum).NokiaCPQ_Configuration_Type__c == 'Bundle')
					{
						// Inside Main Bundle Configuration   
						system.debug('>>>>Is present in mapParentbundlenumberWithListOptionsDummyFiltered? :pliPrimaryLineNum::'+pliPrimaryLineNum+ ':::'+ mapParentbundlenumberWithListOptionsDummyFiltered.containskey(pliPrimaryLineNum));
						if(mapParentbundlenumberWithListOptionsDummyFiltered.containskey(pliPrimaryLineNum)){
							// Collect Child of main bundle (DirectOption/Arcadia/CustGr.)							
							for(Apttus_Proposal__Proposal_Line_Item__c objPLI : mapParentbundlenumberWithListOptionsDummyFiltered.get(pliPrimaryLineNum)){
								// Collect Level 1 Record....				
								serialNumber ++;
								// Calling method to Collect Proposal Line Item for level 1 and pass to create Reconciliation record
								//system.debug('parent main bundle primaryLine::'+pliPrimaryLineNum+':::level 1 Primary Line::'+objPLI.Apttus_QPConfig__PrimaryLineNumber__c+'::level 1 productcode::'+ objPLI.Product_Code__c);
								
								//Apttus_Proposal__Proposal_Line_Item__c objParentPLI = mapOfMainAndStandaloneProducts.get(objPLI.Apttus_QPConfig__ParentBundleNumber__c);
								Apttus_Proposal__Proposal_Line_Item__c objParentPLI = mapOfMainAndStandaloneProducts.get(pliPrimaryLineNum);
								
								system.debug('parent main bundle primaryLine::'+pliPrimaryLineNum+'>>>>>Parent PLI Code>>>'+objParentPLI+':: Child PLI>>>'+objPLI.Product_Code__c);
								
								listReconciliation.add(initiateReconciliationOutputRecord(objPLI,null,mapOfMainAndStandaloneProducts,serialNumber,1,null,objParentPLI, null));
								if(mapParentbundlenumberWithListOptionsDummyFiltered.containskey(objPLI.Apttus_QPConfig__PrimaryLineNumber__c)){
									system.debug('2nd Level Child in PLI>>>'+mapParentbundlenumberWithListOptionsDummyFiltered.get(objPLI.Apttus_QPConfig__PrimaryLineNumber__c));
									// increase serial number if child exists
									serialNumber = serialNumber + mapParentbundlenumberWithListOptionsDummyFiltered.get(objPLI.Apttus_QPConfig__PrimaryLineNumber__c).size() ;
								}
								if(mapArcPrimayNumListQDSIs.containskey(objPLI.Apttus_QPConfig__PrimaryLineNumber__c)){
									system.debug('2nd Level Child in QDSI>>>'+mapArcPrimayNumListQDSIs.get(objPLI.Apttus_QPConfig__PrimaryLineNumber__c).size());
									// increase serial number if child exists
									serialNumber = serialNumber + mapArcPrimayNumListQDSIs.get(objPLI.Apttus_QPConfig__PrimaryLineNumber__c).size();
								}
							}
						}
					}
					else 
					{
						// Level 1 record for StandAlone.			
						serialNumber ++;
						system.debug('>>Level 1 Standalone serialNumber>>'+serialNumber);
						// Calling method to Collect Proposal Line Item for level 1 and pass to create Reconciliation record
						listReconciliation.add(initiateReconciliationOutputRecord(mapOfMainAndStandaloneProducts.get(pliPrimaryLineNum), null, mapOfMainAndStandaloneProducts,serialNumber,1,null,null,null));
						
						// 
					}
				}
			}
			
			if(listReconciliation != null){
				database.insert(listReconciliation);
				levelOneReconciliationGenerated = 'SUCCESS';
			}
			
			// Insert Level 2 PLIs and QDSIs
			list<Reconciliation_Output_Staging__c> listParentReconciliation = new list<Reconciliation_Output_Staging__c>([Select id,Alias__c, CMN__c, Item_Level__c, Product_Code__c, Sales_Item_Code__c,Serial_Number__c,Primary_Line_Number__c from Reconciliation_Output_Staging__c where Quote_Proposal__c =: quoteId]);
			
			map<Decimal,Reconciliation_Output_Staging__c> mapReconciliation = new map<Decimal,Reconciliation_Output_Staging__c>();
			
			list<Reconciliation_Output_Staging__c> listChildReconciliation = new list<Reconciliation_Output_Staging__c>();
			
			for(Reconciliation_Output_Staging__c ROS : listParentReconciliation){
				system.debug('ROS level::'+ROS.Item_Level__c + '::sq..No.---'+ROS.Serial_Number__c+'::PrimaryLine::'+ROS.Primary_Line_Number__c+'::PrdCode::'+ROS.Product_Code__c);
				mapReconciliation.put(ROS.Primary_Line_Number__c,ROS);
			}
			
			for(Decimal pliLineNum : sortedLineNum){
				for(Decimal pliPrimaryLineNum : mapLineNumWithListPrimLineNumOfMainBundleStandalone.get(pliLineNum)){
					if(mapOfMainAndStandaloneProducts.containskey(pliPrimaryLineNum) && mapOfMainAndStandaloneProducts.get(pliPrimaryLineNum).NokiaCPQ_Configuration_Type__c == 'Bundle')
					{
						// Inside Main Bundle Configuration 
						if(mapParentbundlenumberWithListOptionsDummyFiltered.containskey(pliPrimaryLineNum)){
							// Collect Child of main bundle (DirectOption/Arcadia/CustGr.)							
							for(Apttus_Proposal__Proposal_Line_Item__c objPLI : mapParentbundlenumberWithListOptionsDummyFiltered.get(pliPrimaryLineNum)){
								// Collect Level 1 Record....  
								if(!mapReconciliation.isEmpty() && mapReconciliation.containskey(objPLI.Apttus_QPConfig__PrimaryLineNumber__c)){				
									serialNumber = mapReconciliation.get(objPLI.Apttus_QPConfig__PrimaryLineNumber__c).Serial_Number__c;
								}
								system.debug('>>level 1..serialNumber>>'+serialNumber);
								if(mapParentbundlenumberWithListOptionsDummyFiltered.containskey(objPLI.Apttus_QPConfig__PrimaryLineNumber__c)){
									
									// increase serial number if child exists
									for(Apttus_Proposal__Proposal_Line_Item__c childPLI : mapParentbundlenumberWithListOptionsDummyFiltered.get(objPLI.Apttus_QPConfig__PrimaryLineNumber__c)){
										serialNumber++;
										System.debug('in Level 2>>>Parent Bundle PrimaryLine>>>'+objPLI.Apttus_QPConfig__PrimaryLineNumber__c+'::parent Bundle PrdCode:::'+objPLI.Product_Code__c+'::@Child PrimaryLine::'+childPLI.Apttus_QPConfig__PrimaryLineNumber__c+ '::@Child ProdCode:: '+childPLI.Product_Code__c);
										if(!mapReconciliation.isEmpty() && mapReconciliation.containskey(objPLI.Apttus_QPConfig__PrimaryLineNumber__c)){
											listChildReconciliation.add(initiateReconciliationOutputRecord(childPLI,null,mapOfMainAndStandaloneProducts,serialNumber,2,mapReconciliation.get(objPLI.Apttus_QPConfig__PrimaryLineNumber__c).Id,objPLI,mapReconciliation.get(objPLI.Apttus_QPConfig__PrimaryLineNumber__c)));
										}
									}
								}
								if(mapArcPrimayNumListQDSIs.containskey(objPLI.Apttus_QPConfig__PrimaryLineNumber__c)){
									system.debug('2nd Level Child in QDSI>>>'+mapArcPrimayNumListQDSIs.get(objPLI.Apttus_QPConfig__PrimaryLineNumber__c).size());
									for(Quote_Delivery_Sales_Item__c objQDSI : mapArcPrimayNumListQDSIs.get(objPLI.Apttus_QPConfig__PrimaryLineNumber__c)){
										serialNumber++;
										if(!mapReconciliation.isEmpty() && mapReconciliation.containskey(objPLI.Apttus_QPConfig__PrimaryLineNumber__c)){
										listChildReconciliation.add(initiateReconciliationOutputRecord(null,objQDSI,mapOfMainAndStandaloneProducts,serialNumber,2,mapReconciliation.get(objPLI.Apttus_QPConfig__PrimaryLineNumber__c).Id,objPLI, mapReconciliation.get(objPLI.Apttus_QPConfig__PrimaryLineNumber__c)));
									  }
									}
								}
							}
						}
					}
				}
			}
			if(listChildReconciliation != null){
				database.insert(listChildReconciliation);
			  levelTwoReconciliationGenerated = 'SUCCESS';
			}
			If(levelOneReconciliationGenerated == 'SUCCESS' && levelTwoReconciliationGenerated =='SUCCESS'){
				fileGenerated = 'SUCCESS';
			}
			else
				fileGenerated = 'Fail';
		}
		catch(exception e){
			System.debug('exception'+e);
			fileGenerated = 'Error'+ e.getMessage();
		}
		return fileGenerated;
	}
	
	// method to filter Dummy bundles and return:
	// map Main Bundle & Its Direct Options/Arcadia/CustGr. AND Arcadia/Cust gr. & its Options list.
	public static map<decimal,list<Apttus_Proposal__Proposal_Line_Item__c>> generateParentToChildOptionsHierarchy(map<Decimal,Decimal> mapPrimaryLineToParentline, map<Decimal,Apttus_Proposal__Proposal_Line_Item__c> mapDummyBundles, map<decimal,list<Apttus_Proposal__Proposal_Line_Item__c>> mapParentbundlenumberwithListOptions){		
		decimal count=0;
		for(Decimal primaryLineNum: mapPrimaryLineToParentline.keyset()){
			system.debug('---count--'+count+'>>>primaryLineNum>>>'+primaryLineNum);
			Decimal varParentBundle = primaryLineNum;   
			count++;
			if(mapDummyBundles.containskey(primaryLineNum)){
				system.debug('---count--'+count+'::before Dummy While loop:varParentBundle:::'+varParentBundle);
				while(mapDummyBundles.containskey(varParentBundle)){
					
					varParentBundle = mapPrimaryLineToParentline.get(varParentBundle);
					system.debug('---count--'+count+'::After Dummy While loop:varParentBundle:::'+varParentBundle);
				}
			
			list<Apttus_Proposal__Proposal_Line_Item__c> mainBundleOptionList = new list<Apttus_Proposal__Proposal_Line_Item__c>();
			list<Apttus_Proposal__Proposal_Line_Item__c> addline = new list<Apttus_Proposal__Proposal_Line_Item__c>();
			
			// collect Main Bundles/ Valid parent Child list & remove dummy child from valid parent list
			if(mapParentbundlenumberwithListOptions.containskey(varParentBundle)){
				system.debug('---count--'+count+'varParentBundle>>>>'+varParentBundle+'Child of main bundle--size()::'+mapParentbundlenumberwithListOptions.get(varParentBundle).size());
				for(Apttus_Proposal__Proposal_Line_Item__c objPLI : mapParentbundlenumberwithListOptions.get(varParentBundle)){
					if(objPLI.Apttus_QPConfig__PrimaryLineNumber__c != primaryLineNum){
						mainBundleOptionList.add(objPLI);
						system.debug('---count--'+count+'>>>varParentBundle::'+varParentBundle+'::TopLevelParent\'s Child PLI ProdCode::'+objPLI.Product_Code__c);
					}
				}
			}
			
			list<Apttus_Proposal__Proposal_Line_Item__c> listDummyBundlesOptions = new list<Apttus_Proposal__Proposal_Line_Item__c>();
			if(mapParentbundlenumberwithListOptions.containskey(primaryLineNum)){
				system.debug('---count--'+count+'::Current PLI PrimayLine::'+primaryLineNum );
				listDummyBundlesOptions = mapParentbundlenumberwithListOptions.get(primaryLineNum);
			}
			
			system.debug('::---count--'+count);
			System.debug('@@listDummyBundlesOptions>>>'+listDummyBundlesOptions+'---count--'+count);
			System.debug('@@mainBundleOptionList>>>>'+mainBundleOptionList+'---count--'+count);
			mapParentbundlenumberwithListOptions.remove(primaryLineNum);  
			/*
			for(Apttus_Proposal__Proposal_Line_Item__c linenum : listDummyBundlesOptions){
				if(!mapDummyBundles.containskey(linenum.Apttus_QPConfig__PrimaryLineNumber__c)){
					addline.add(linenum);
				}
			}
			*/
			if(listDummyBundlesOptions.size() > 0){
				mainBundleOptionList.addall(listDummyBundlesOptions);
			}
			
			for(Apttus_Proposal__Proposal_Line_Item__c  oblChildPLI : mainBundleOptionList){
				 system.debug('---count--'+count+'>>>primaryLineNum>>>'+primaryLineNum+':::Filtered Top Parent Line >>'+varParentBundle +'::ChildPLIProductCode>>'+oblChildPLI.Product_Code__c+'::: Primary Line::'+oblChildPLI.Apttus_QPConfig__PrimaryLineNumber__c);   
			}
			
			mapParentbundlenumberwithListOptions.put(varParentBundle,mainBundleOptionList);
			
			}
			
		}
		
		system.debug('Final ParentLine :::'+mapParentbundlenumberwithListOptions.keySet());
		return mapParentbundlenumberwithListOptions;
		
	}
	
	// return Discount % or amount String Based on Discount Type, Decimal 
	public static String collectDiscount(Decimal basePrice, Decimal discountedAmount, String discountType){
		String discountValue;
		
		if(discountType == 'Discount Amount')
		{
			discountValue = String.ValueOf(basePrice - discountedAmount);
		}
		else {
			Decimal dicountCalculatedValue = ((basePrice - discountedAmount)/basePrice)*100;
			discountValue = ((basePrice - discountedAmount)/basePrice)*100 + '%';
		}
		return discountValue;
	}
	
	public Static Reconciliation_Output_Staging__c initiateReconciliationOutputRecord(Apttus_Proposal__Proposal_Line_Item__c objPLI,Quote_Delivery_Sales_Item__c objQDSI, map<decimal,Apttus_Proposal__Proposal_Line_Item__c> mapOfMainAndStandaloneProducts, decimal serialNumber, Decimal item_level, Id parentROS,Apttus_Proposal__Proposal_Line_Item__c parentPLI, Reconciliation_Output_Staging__c parentReconOutLevel1){
		Reconciliation_Output_Staging__c recOutput = new Reconciliation_Output_Staging__c();
		String alias;
		String strCMN;
		if(item_level == 1){			
			strCMN = objPLI.CMN__c;
		}
		else{		   
		  strCMN = parentReconOutLevel1.CMN__c; 
		}
		String strIrp_to_clp_discount_type;
		String strClp_to_cup_discount_type;
		String strCup_to_cnp_discount_type; 
		String strDiscount_irp_to_clp;
		String strDiscount_clp_to_cup;
		String strDiscount_cup_to_cnp;
		String strReserves_cnp_to_np;   
		
		
		if(objPLI != null && objPLI.NokiaCPQ_Extended_IRP2__c > 0.00){
			//strDiscount_irp_to_clp = collectDiscount(objPLI.NokiaCPQ_Extended_IRP2__c, objPLI.NokiaCPQ_Net_Price__c, strIrp_to_clp_discount_type); // need to correct
			strDiscount_irp_to_clp = String.valueof((((objPLI.NokiaCPQ_Extended_IRP2__c - objPLI.NokiaCPQ_Extended_CLP_2__c)/objPLI.NokiaCPQ_Extended_IRP2__c)*100).setScale(2, RoundingMode.HALF_UP))+ '%';
		}
		else
			strDiscount_irp_to_clp = '0.00%';
		if(objPLI != null){
			strClp_to_cup_discount_type = objPLI.Apttus_QPConfig__AdjustmentType__c; // need clarity
			strIrp_to_clp_discount_type = objPLI.Apttus_QPConfig__AdjustmentType__c;
		}
		else{
			strClp_to_cup_discount_type = '';
		}
		if(objPLI != null && objPLI.NokiaCPQ_Extended_CLP_2__c > 0.00){
			//strDiscount_clp_to_cup = collectDiscount(objPLI.NokiaCPQ_Net_Price__c, objPLI.NokiaCPQ_Extended_CUP_2__c, strClp_to_cup_discount_type); // need to correct
			strDiscount_clp_to_cup = String.valueOf((((objPLI.NokiaCPQ_Extended_CLP_2__c - objPLI.NokiaCPQ_Extended_CUP_2__c)/objPLI.NokiaCPQ_Extended_CLP_2__c)*100).setScale(2, RoundingMode.HALF_UP))+ '%';
		}
		else
			strDiscount_clp_to_cup = '0.00%';
		if(objPLI != null && mapOfMainAndStandaloneProducts.containskey(objPLI.Apttus_QPConfig__ParentBundleNumber__c) && mapOfMainAndStandaloneProducts.get(objPLI.Apttus_QPConfig__ParentBundleNumber__c)!=null && mapOfMainAndStandaloneProducts.get(objPLI.Apttus_QPConfig__ParentBundleNumber__c).Apttus_QPConfig__AdjustmentType__c!=null){
			strCup_to_cnp_discount_type = mapOfMainAndStandaloneProducts.get(objPLI.Apttus_QPConfig__ParentBundleNumber__c).Apttus_QPConfig__AdjustmentType__c;
		}
		else{
			strCup_to_cnp_discount_type = '';
		}
		if(objPLI != null && objPLI.NokiaCPQ_Extended_CUP_2__c > 0.00){
			//strDiscount_cup_to_cnp = collectDiscount(objPLI.NokiaCPQ_Extended_CUP_2__c, objPLI.NokiaCPQ_ExtendedPrice_CNP__c, ''); // need to correct
			strDiscount_cup_to_cnp = String.valueOf((((objPLI.NokiaCPQ_Extended_CUP_2__c - objPLI.NokiaCPQ_ExtendedPrice_CNP__c)/objPLI.NokiaCPQ_Extended_CUP_2__c)*100).setScale(2, RoundingMode.HALF_UP))+ '%';
		}
		else
			strDiscount_cup_to_cnp = '0.00%';
		
		/* // check Extended NP field API
		if(objPLI.NokiaCPQ_ExtendedPrice_CNP__c > 0)
		strReserves_cnp_to_np = collectDiscount(objPLI.NokiaCPQ_ExtendedPrice_CNP__c, extended_np, ''); // need to correct
		else
		strReserves_cnp_to_np = '0.00';
		*/
		
		
		// Generate Wrapper Class
		ReconciliationOutputWrapper insReconciliationOutputWrapper;
		if(item_level == 1){
			insReconciliationOutputWrapper = new ReconciliationOutputWrapper(objPLI, objQDSI, strCMN, serialNumber, strIrp_to_clp_discount_type, strClp_to_cup_discount_type, strCup_to_cnp_discount_type, strDiscount_irp_to_clp, strDiscount_clp_to_cup, strDiscount_cup_to_cnp, strReserves_cnp_to_np, item_level, parentROS,parentPLI, parentReconOutLevel1);
		}
		if(item_level == 2){
			insReconciliationOutputWrapper = new ReconciliationOutputWrapper(objPLI, objQDSI, strCMN, serialNumber, strIrp_to_clp_discount_type, strClp_to_cup_discount_type, strCup_to_cnp_discount_type, strDiscount_irp_to_clp, strDiscount_clp_to_cup, strDiscount_cup_to_cnp, strReserves_cnp_to_np, item_level, parentROS,parentPLI, parentReconOutLevel1);
		}
		
		return recOutput = generateReconciliationOutputRecord(insReconciliationOutputWrapper);
	}
	
	
	public Static Reconciliation_Output_Staging__c generateReconciliationOutputRecord(ReconciliationOutputWrapper objWrapper){
		Reconciliation_Output_Staging__c recOutput = new Reconciliation_Output_Staging__c();
		recOutput.Quote_Proposal__c = objWrapper.quote_proposal;
		recOutput.Proposal_Line_Item__c = objWrapper.proposal_line_item;
		recOutput.Item_Level__c = objWrapper.item_level;
		recOutput.CMN__c = objWrapper.cmn;
		recOutput.Alias__c = objWrapper.alias;
		recOutput.IRP_To_CLP_Discount_Type__c = objWrapper.irp_to_clp_discount_type;
		recOutput.CLP_To_CUP_Discount_Type__c = objWrapper.clp_to_cup_discount_type;
		recOutput.CUP_To_CNP_Discount_Type__c = objWrapper.cup_to_cnp_discount_type;
		recOutput.Extended_CLP__c = objWrapper.extended_clp;
		recOutput.Extended_CNP__c = objWrapper.extended_cnp;
		recOutput.Extended_Cost__c = objWrapper.extended_cost;
		recOutput.Extended_CUP__c = objWrapper.extended_cup;
		recOutput.Extended_IRP__c = objWrapper.extended_irp;
		recOutput.Extended_NP__c = objWrapper.extended_np;
		//recOutput.Margin__c = margin;
		recOutput.PCI_Code__c = objWrapper.pci_code;
		recOutput.Product_Code__c = objWrapper.product_code;
		recOutput.Product_Name__c = objWrapper.product_name;
		recOutput.Quantity__c = objWrapper.quantity;
		recOutput.Primary_Line_Number__c = objWrapper.primary_line_number;
		recOutput.Parent_Bundle_Lookup__c = objWrapper.parent_bundle_lookup;
		recOutput.Reserves_CNP_To_NP__c = objWrapper.reserves_cnp_to_np;
		recOutput.Sales_Item_Code__c = objWrapper.sales_item_code;
		recOutput.Unitary_CLP__c = objWrapper.unitary_clp;
		recOutput.Unitary_CNP__c = objWrapper.unitary_cnp;
		recOutput.Unitary_CUP__c = objWrapper.unitary_cup;
		recOutput.Unitary_IRP__c = objWrapper.unitary_irp;
		recOutput.Unitary_NP__c = objWrapper.unitary_np;
		recOutput.Serial_Number__c = objWrapper.serial_number;
		recOutput.Discount_IRP_To_CLP__c = objWrapper.discount_irp_to_clp;
		recOutput.Discount_CLP_To_CUP__c = objWrapper.discount_clp_to_cup;
		recOutput.Discount_CUP_To_CNP__c = objWrapper.discount_cup_to_cnp;
		recOutput.Sequence_Site_Id__c=objWrapper.siteId;
		
		return recOutput;
		
	}
	
	
	public static Map<String, List<Quote_Delivery_Sales_Item__c>> getQuoteDeliverySalesItemsForArcadia(Id quoteId) {		
		List<Quote_Delivery_Sales_Item__c> listQDSIs = new List<Quote_Delivery_Sales_Item__c>([SELECT Id,Arcadia_Product_Code__c, Item_Type__c, Parent_Line_Item__c, PCI_Code__c, Product_Code__c, Quantity__c, Proposal__c, Parent_Line_Item__r.Apttus_Config2__LineNumber__c,Parent_Line_Item__r.Apttus_Config2__PrimaryLineNumber__c, Sequence_Site_Id__c,Alias_for_Exports__c,CMN__c,Parent_Line_Item__r.Apttus_Config2__LineSequence__c  FROM Quote_Delivery_Sales_Item__c WHERE Proposal__c =:quoteId AND Parent_Line_Item__c != null]);
		
		Map<String, List<Quote_Delivery_Sales_Item__c>> mapArcadiaChildQDSIs = new Map<String, List<Quote_Delivery_Sales_Item__c>>();
		if(!listQDSIs.IsEmpty())
		{
			for(Quote_Delivery_Sales_Item__c objQDSI : listQDSIs)
			{
				String key = objQDSI.Parent_Line_Item__r.Apttus_Config2__LineSequence__c +'_'+ objQDSI.Arcadia_Product_Code__c;
				if(mapArcadiaChildQDSIs.containskey(key))
					mapArcadiaChildQDSIs.get(key).add(objQDSI);
				else
					mapArcadiaChildQDSIs.put(key, new List<Quote_Delivery_Sales_Item__c>{objQDSI});
				
			}		   
		}
		
		return mapArcadiaChildQDSIs;
	}
	
	public class ReconciliationOutputWrapper{
		String alias;
		String cmn;
		String siteId;
		Decimal serial_number;
		Decimal unitary_irp;
		Decimal unitary_clp;
		Decimal unitary_cnp;
		Decimal unitary_cup;
		Decimal unitary_np;
		String irp_to_clp_discount_type;
		String clp_to_cup_discount_type;
		String cup_to_cnp_discount_type;
		String discount_irp_to_clp;
		String discount_clp_to_cup;
		String discount_cup_to_cnp;
		String reserves_cnp_to_np;
		Decimal extended_irp;
		Decimal extended_clp;
		Decimal extended_cnp;
		Decimal extended_cup;
		Decimal extended_np;
		Decimal extended_cost;
		Decimal item_level;
		//String margin; as mentioned in template not required.
		String pci_code;
		String sales_item_code;
		String product_code;
		String product_name;
		Decimal primary_line_number;
		Decimal quantity;
		Id proposal_line_item;
		Id parent_bundle_lookup;
		Id quote_proposal;
		
		public ReconciliationOutputWrapper(Apttus_Proposal__Proposal_Line_Item__c objPLI, Quote_Delivery_Sales_Item__c objQDSI, String strCMN, Decimal strSerial_number, String strIrp_to_clp_discount_type, String strClp_to_cup_discount_type, String strCup_to_cnp_discount_type, String strDiscount_irp_to_clp, String strDiscount_clp_to_cup, String strDiscount_cup_to_cnp, String strReserves_cnp_to_np, Decimal strItem_level, Id idParent_bundle_lookup,Apttus_Proposal__Proposal_Line_Item__c parentPLI, Reconciliation_Output_Staging__c parentReconOutLevel1){	  
			//if(objPLI!=null){
			String strSequenceSiteId;
			if(objPLI != null)
				strSequenceSiteId = objPLI.Sequence_Site_Id__c;
			else if(objQDSI != null )
				strSequenceSiteId = objQDSI.Sequence_Site_Id__c;
			
			siteId = strSequenceSiteId;
			if(objPLI!=null){
				alias=objPLI.Alias_for_Exports__c;
			}
			else if(strItem_level == 2 && parentReconOutLevel1 != null){				
				alias = parentReconOutLevel1.Alias__c;
			}
			system.debug('>>>strItem_level>>'+strItem_level+':::strSerial_number:::'+strSerial_number+'::alias>>>'+alias);
			
			cmn = strCMN;
			serial_number = strSerial_number;
			if(objPLI!=null){
				if(objPLI.NokiaCPQ_Unitary_IRPrice__c!=null)
				  unitary_irp = objPLI.NokiaCPQ_Unitary_IRPrice__c;
				else
					unitary_irp = 0.00;
				if(objPLI.NokiaCPQ_Partner_Price__c!=null)
				  unitary_clp = objPLI.NokiaCPQ_Partner_Price__c;
				else
					unitary_clp = 0.00;
				if(objPLI.NokiaCPQ_ExtendedPrice_CNP__c!=null && objPLI.NokiaCPQ_ExtendedPrice_CNP__c>0.00 && objPLI.NokiaCPQ_Quantity__c!=null)
				  unitary_cnp = (objPLI.NokiaCPQ_ExtendedPrice_CNP__c/ objPLI.NokiaCPQ_Quantity__c).setScale(2, RoundingMode.HALF_UP);
				else
					unitary_cnp = 0.00;
				if(objPLI.NokiaCPQ_Extended_CUP_2__c!=null && objPLI.NokiaCPQ_Extended_CUP_2__c>0.00 && objPLI.NokiaCPQ_Quantity__c!=null)
				  unitary_cup = (objPLI.NokiaCPQ_Extended_CUP_2__c/ objPLI.NokiaCPQ_Quantity__c).setScale(2, RoundingMode.HALF_UP);
				else
					unitary_cup = 0.00;
				if(objPLI.NokiaCPQ_ExtendedAdvance_NP__c!=null && objPLI.NokiaCPQ_ExtendedAdvance_NP__c>0.00 && objPLI.NokiaCPQ_Quantity__c!=null)
				  unitary_np = objPLI.NokiaCPQ_ExtendedAdvance_NP__c/objPLI.NokiaCPQ_Quantity__c;
				else	
				  unitary_np = 0.00;
			}
			else{
				unitary_irp = 0.00;
				unitary_clp = 0.00;
				unitary_cnp = 0.00;
				unitary_cup = 0.00;
				unitary_np = 0.00; 
			}
			irp_to_clp_discount_type = strIrp_to_clp_discount_type;
			clp_to_cup_discount_type = strClp_to_cup_discount_type;
			cup_to_cnp_discount_type = strCup_to_cnp_discount_type;
			discount_irp_to_clp = strDiscount_irp_to_clp;
			discount_clp_to_cup = strDiscount_clp_to_cup;
			discount_cup_to_cnp = strDiscount_cup_to_cnp;
			reserves_cnp_to_np = strReserves_cnp_to_np;
			//system.debug('>>objPLI.Total_Option_Quantity__c'+objPLI.Total_Option_Quantity__c+'>>unitary_irp'+unitary_irp+'>>unitary_clp'+unitary_clp+'>>unitary_cnp'+unitary_cnp+'>>unitary_cup'+unitary_cup+'>>unitary_np'+unitary_np);
			if(objPLI!=null){
				Decimal ExtendedQuantity;
				if(objPLI.Total_Option_Quantity__c != null){
					ExtendedQuantity = objPLI.Total_Option_Quantity__c;
				}
				else{
					ExtendedQuantity = objPLI.Apttus_QPConfig__Quantity2__c;
				}
				if(ExtendedQuantity != null && unitary_irp!=null && unitary_irp!=0.00)
				  extended_irp = ExtendedQuantity*unitary_irp;
				else
					extended_irp = 0.00;
				if(ExtendedQuantity != null && unitary_clp!=null && unitary_clp!=0.00)
				  extended_clp = ExtendedQuantity*unitary_clp;
				else
					extended_clp = 0.00;
				if(ExtendedQuantity != null && unitary_cnp!=null && unitary_cnp!=0.00)
				  extended_cnp = ExtendedQuantity*unitary_cnp;
				else
					extended_cnp = 0.00;
				if(ExtendedQuantity != null && unitary_cup!=null && unitary_cup!=0.00)
				  extended_cup = ExtendedQuantity*unitary_cup;
				else
					extended_cup = 0.00;
				if(ExtendedQuantity != null && unitary_np!=null && unitary_np!=0.00)
				  extended_np = ExtendedQuantity*unitary_np;
				else
					extended_np = 0.00;
				extended_cost = objPLI.NokiaCPQ_Extended_Cost__c;
			}
			else{
				extended_irp = 0.00;
				extended_clp = 0.00;
				extended_cnp = 0.00;
				extended_cup = 0.00;
				extended_np = 0.00; //check with pricing team
				extended_cost = 0.00;
			}
			item_level = strItem_level;
			if(objPLI!=null){
				pci_code = objPLI.PCI_Code__c;
				if(strItem_level == 2)
					sales_item_code = objPLI.Product_Code__c;
				else{
					product_code = objPLI.Product_Code__c;
					sales_item_code = objPLI.Product_Code__c;
				}
			}
			else{
				pci_code= objQDSI.PCI_Code__c;
				sales_item_code = objQDSI.Product_Code__c;
			}
			if(objPLI!=null){
				product_name = objPLI.NokiaCPQ_Product_Name__c;
				primary_line_number =objPLI.Apttus_QPConfig__PrimaryLineNumber__c;
				if(objPLI.Total_Option_Quantity__c != null)
					quantity = objPLI.Total_Option_Quantity__c ;
				else  //for GS Deploy & maintenance items as standalone in Airscale wifi
					quantity = objPLI.Apttus_QPConfig__Quantity2__c;
				
				proposal_line_item = objPLI.Id;
				if(parentReconOutLevel1 != null)
					parent_bundle_lookup = parentReconOutLevel1.Id;
				
				quote_proposal = objPLI.Apttus_Proposal__Proposal__c;
			}
			else{
				product_name = '';
				primary_line_number =objQDSI.Parent_Line_Item__r.Apttus_Config2__PrimaryLineNumber__c;
		if(!mapOfMainAndStandaloneProductsWithSequenceNumber.isEmpty() && mapOfMainAndStandaloneProductsWithSequenceNumber.containsKey(objQDSI.Parent_Line_Item__r.Apttus_Config2__LineSequence__c) && mapOfMainAndStandaloneProductsWithSequenceNumber.get(objQDSI.Parent_Line_Item__r.Apttus_Config2__LineSequence__c).NokiaCPQ_Quantity__c!=null){
				  quantity = objQDSI.Quantity__c*mapOfMainAndStandaloneProductsWithSequenceNumber.get(objQDSI.Parent_Line_Item__r.Apttus_Config2__LineSequence__c).NokiaCPQ_Quantity__c;
				}
				else{
					quantity = objQDSI.Quantity__c;
				}
				proposal_line_item = null;
				if(parentReconOutLevel1 != null)
					parent_bundle_lookup = parentReconOutLevel1.Id;
				
				quote_proposal = objQDSI.Proposal__c;
			}
		}
	}   
}