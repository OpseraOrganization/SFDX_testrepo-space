public with sharing class NokiaCPQSendBOMNPTController{
	public static NPT_Custom_Setting__c cs; 
	public NokiaCPQSendBOMNPTController(){
	}
	public void NokiaCPQSendBOMNPTControllerAction(string cartId) {
		system.debug('cartId '+ cartId );
		 // cartID = 'a683K000000NfVFQA0';
		string token = getNPTtoken();
		String reqestBody;
		//Modified by Elakkiya for MW 
		List<Apttus_Config2__ProductConfiguration__c> configRec = [Select Id,NokiaCPQ_Portfolio_From_Quote__c  from Apttus_Config2__ProductConfiguration__c where ID = :cartID Limit 1];
		If(configRec[0].NokiaCPQ_Portfolio_From_Quote__c == Nokia_CPQ_Constants.MICROWAVE_PORTFOLIO)
		{
			reqestBody = getNPTBomRequestBody_MW(cartId);
		}
		else
		{
			reqestBody = getNPTBomRequestBody(cartId);
		}
		system.debug('token in main class : --'+token);
		system.debug('body in main class :  --'+ reqestBody );
		string jsonID = sendBOMtoNPT(reqestBody, token, cartId);
		system.debug('JSON Id in main class :   --'+ jsonID );
	}
	/*  Method to create JSOn string for BOM request to NPT */	
	public static string getNPTtoken(){
		cs = [SELECT id, clientId__c,clientSecreat__c,resource__c, setEndpointURL__c, setEndpointJsonStatus__c FROM NPT_Custom_Setting__c ];
		Http httptoken = new Http();
		HttpRequest requesttoken = new HttpRequest();
		
		requesttoken.setMethod('GET');
		requesttoken.setHeader('Content-Type', 'application/x-www-form-urlencoded');
		string clientId = cs.clientId__c;		
		string clientSecreat = cs.clientSecreat__c;   
		string resource = cs.resource__c;		
		system.debug('custom setting data '+clientId+'--'+clientSecreat+ '--'+resource+'--'+cs.setEndpointURL__c);
		requesttoken.setEndpoint('callout:NPT_Login');
		requesttoken.setBody('grant_type=password' +
							 '&client_id=' + EncodingUtil.urlEncode(clientId, 'UTF-8') +
							 '&client_secret=' + EncodingUtil.urlEncode(clientSecreat, 'UTF-8') +
							 '&username={!HTMLENCODE($Credential.Username)}' +
							 '&password={!HTMLENCODE($Credential.Password)}' +
							 '&resource=' + EncodingUtil.urlEncode(resource, 'UTF-8')); 
		system.debug('requesttoken : '+ requesttoken);
		system.debug('requesttoken : '+ requesttoken);
		HttpResponse responsetoken = httptoken.send(requesttoken);
		System.debug('responsetoken :: '+responsetoken.getBody());
		Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(responsetoken.getBody());
		object token = results.get('access_token');
		string tokenString = (String)token;
		System.debug('token :'+tokenString);
		return(tokenString);
	}
	public string getNPTBomRequestBody(string CartID ) {
		
		/*new variable */
		map<string, Decimal> mapCurrencyToRate = new map<string, Decimal>();
		map<string, map<string, list<CPQ_MPW_Bundle__c>>> staticBundleTogroupToSILines = new map<string, map<string, list<CPQ_MPW_Bundle__c>>>();
		map<string, list<CPQ_MPW_Bundle__c>> portfoliopackageToStaticLines = new map<string, list<CPQ_MPW_Bundle__c>>();
		map<string, list<string>> portfoliopackageToStaticGroup = new map<string, list<string>>();
		map<string, list<string>> portfoliopackageToStaticBundle = new map<string, list<string>>();
		map<string, map<string, integer>> mapPortfoliostaticGroupToSICount = new map<string, map<string, integer>>();
		list<string> groupProductId = new list<string>();
		list<string> dynamicgroupProductId = new list<string>();
		list<string> staticGroupId = new list<string>();
		list<Decimal> groupProductNum = new list<Decimal>();
		list<Decimal> dynamicgroupProductNum = new list<Decimal>();
		list<Decimal> staticGroupNum = new list<Decimal>();
		list<string> portfolioPackageCodeStatic = new list<string>();
		list<string> finalportfolioPackageCode = new list<string>();
		map<string, integer> groupNumToBundlecode = new map<string, integer> ();
		map<string, integer> mapdisStoreTodisId = new map<string, integer>();
		map<Decimal, Decimal> mapgrouplineToQuantity = new map<Decimal, Decimal>();
		map<string, Decimal> mapgroupCodeToQuantity = new map<string, Decimal>();
		/*****/
		Map<Decimal, map<Decimal, list<Apttus_Config2__LineItem__c>>> bundleTogroupToSILines = new Map<Decimal, map<Decimal, list<Apttus_Config2__LineItem__c>>>();
		map<decimal, list<decimal>> mapBundleToGroup = new map<decimal, list<Decimal>>();
		map<string, map<decimal, integer>> mapPortfolioGroupToSICount = new map<string, map<decimal, integer>>();
		list<Decimal> bundleproductLineNum = new list<Decimal>();
		map<Decimal, Apttus_Config2__LineItem__c> primaryLineNum = new map<Decimal, Apttus_Config2__LineItem__c>();
		map<Decimal, Decimal> optionToParent = new map<Decimal, Decimal>();
		map<Decimal, string> lineToCapacityUnit = new map<Decimal, string>();
		list<string> staticLinesProdCode = new list<string>();
		map<string, Decimal> mapStaticProductCodeToPrice = new map<string, Decimal>();
		
		map<Decimal, integer> standalonToCUID = new map<Decimal, integer>();
		
		Apttus_Proposal__Proposal__c quoteRec = new Apttus_Proposal__Proposal__c();
		list<string> portfolioPackageCode = new list<string>();
		list<Apttus_Config2__LineItem__c> siLineList = new list<Apttus_Config2__LineItem__c>();
		list<Apttus_Config2__LineItem__c> groupLineList = new list<Apttus_Config2__LineItem__c>();
		map<string, list<Apttus_Config2__LineItem__c>> portfoliopackageToLines = new map<string, list<Apttus_Config2__LineItem__c>>();
		map<string, list<Apttus_Config2__LineItem__c>> PortfoliopackageTogroup = new map<string, list<Apttus_Config2__LineItem__c>> ();
		map<string, list<Apttus_Config2__LineItem__c>> PortfoliopackageToBundle = new map<string, list<Apttus_Config2__LineItem__c>> ();
		map<string, list<Apttus_Config2__LineItem__c>> portfolioPackageToStandalone = new map<string, list<Apttus_Config2__LineItem__c>> ();
		
		map<string, integer> portfolioToSheetID = new map<string, integer> ();
		map<Decimal, integer> groupNumToBundleID = new map<Decimal, integer> ();
		map<string, integer> confUnitToLineNumber = new map<string, integer> ();
		map<String, integer> confUnitIdStaticMap = new map<String, integer> (); 
		CurrencyType exchangeRateRec = new CurrencyType();
		decimal exchangeRate = 1;
		Decimal qty = 0;
		string userName = UserInfo.getName();
		list <Apttus_Config2__LineItem__c> allLineItems = [Select id, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ProductId__c, 
														   Apttus_Config2__OptionId__c, Apttus_Config2__LineNumber__c, 
														   Apttus_Config2__PrimaryLineNumber__c, Apttus_Config2__ParentBundleNumber__c, 
														   Apttus_Config2__LineType__c, NokiaCPQ_Configuration_Type__c,
														   NokiaCPQ_Part_Number__c, NokiaCPQ_Product_Description__c,
														   NokiaCPQ_Unitary_Cost__c, NokiaCPQ_Alias__c,
														   Apttus_Config2__Quantity__c,Item_Type__c, CurrencyIsoCode,
														   Apttus_Config2__ProductId__r.NokiaCPQ_Portfolio_Package_Code__c,
														   Apttus_Config2__OptionId__r.NokiaCPQ_Portfolio_Package_Code__c,
														   Apttus_Config2__OptionId__r.ProductCode,
														   Apttus_Config2__ProductId__r.Capacity__c, Apttus_Config2__OptionId__r.Capacity__c,
														   Apttus_Config2__ProductId__r.Business_Group__c, Apttus_Config2__OptionId__r.Business_Group__c,
														   Apttus_Config2__ProductId__r.NokiaCPQ_Business_Line__r.name, Apttus_Config2__OptionId__r.NokiaCPQ_Business_Line__r.name,
														   NokiaCPQ_Opportunity_Name__c, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Opportunity_ID__c,
														   Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.NokiaCPQ_Proposal_Id__c,
														   NokiaCPQ_Accreditation_Discount__c,NokiaCPQ_IncotermNew__c,
														   NokiaCPQ_Unitary_IRPrice__c, NokiaCPQ_MPW_Pricing__c, NokiaCPQ_IRP_Discount__c, CPQ_NPT_S_I_Type__c, NokiaCPQ_Partner_Price__c,NokiaCPQ_Spare__c, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Offer__c 
														   from Apttus_Config2__LineItem__c
														   where Apttus_Config2__ConfigurationId__c =: CartID AND Apttus_Config2__ChargeType__c = 'Standard Price'];
		system.debug('debug query: '+allLineItems[0].CPQ_NPT_S_I_Type__c);
	   //added
		double incoterm = allLineItems[0].NokiaCPQ_IncotermNew__c;
		double accrediDisc = allLineItems[0].NokiaCPQ_Accreditation_Discount__c;
	  /*  double irpPrice = 0.00;
		double partPrice = 0.00;
		for(Apttus_Config2__LineItem__c lit : allLineItems ){
			 irpPrice = lit.NokiaCPQ_Unitary_IRPrice__c;
			 partPrice = lit.NokiaCPQ_Partner_Price__c;
		}*/
		
		string oppty = allLineItems[0].Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Opportunity_ID__c;
		system.debug('oppty Id: '+oppty);  
		List<Offer__C> offer = [ select id, name,ActiveOffer__c, Offer_Number__c from offer__c where ActiveOffer__c = true AND Opportunity__c =: allLineItems[0].Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__c limit 1 ];
		string offerId;   
		system.debug('Offer details: '+offer[0].Offer_Number__c+ ' : '+offer[0].ActiveOffer__c+ ' : '+offer[0].id);
		If(!offer.isEmpty())
		{
			offerId = offer[0].Offer_Number__c;
		}
		
		string Quote = allLineItems[0].Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.NokiaCPQ_Proposal_Id__c;
		Id quoteId = allLineItems[0].Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c;
		quoteRec = [select id, name, CurrencyIsoCode, NokiaCPQ_No_of_Years__c, 
					NokiaCPQ_Quote_CAD__c, NokiaCPQ_Quote_DOD__c, NokiaCPQ_Quote_DPD__c, Apttus_QPConfig__PriceListId__c 
					from Apttus_Proposal__Proposal__c where id =: quoteId]; 
		//added as per new changes   

		string quoteCurrency = quoteRec.CurrencyIsoCode;
		exchangeRateRec = [select id, ConversionRate, IsoCode from CurrencyType where IsoCode =: quoteRec.CurrencyIsoCode AND IsActive = true limit 1];
		if(exchangeRateRec != Null){
		exchangeRate = exchangeRateRec.ConversionRate;}
		
		
		for(Apttus_Config2__LineItem__c lineitem : allLineItems ){
			if(lineitem.Apttus_Config2__OptionId__c != null &&  lineitem.Apttus_Config2__OptionId__r.Capacity__c != null){
				lineToCapacityUnit.put(lineitem.Apttus_Config2__PrimaryLineNumber__c, lineitem.Apttus_Config2__OptionId__r.Capacity__c);
			}else if(lineitem.Apttus_Config2__OptionId__c == null &&  lineitem.Apttus_Config2__ProductId__r.Capacity__c != null){
				lineToCapacityUnit.put(lineitem.Apttus_Config2__PrimaryLineNumber__c, lineitem.Apttus_Config2__ProductId__r.Capacity__c);
			}
			list<Apttus_Config2__LineItem__c> linelist = new list<Apttus_Config2__LineItem__c>();
			primaryLineNum.put(lineitem.Apttus_Config2__PrimaryLineNumber__c, lineitem);
			optionToParent.put(lineitem.Apttus_Config2__PrimaryLineNumber__c, lineitem.Apttus_Config2__ParentBundleNumber__c);
			if(lineitem.Apttus_Config2__ParentBundleNumber__c == null){
				bundleproductLineNum.add(lineitem.Apttus_Config2__PrimaryLineNumber__c);	
			}
			if(lineitem.Apttus_Config2__OptionId__c != null && 
			   lineitem.Apttus_Config2__OptionId__r.NokiaCPQ_Portfolio_Package_Code__c != Null){
				   system.debug(' In option loop ');
				   if(!lineitem.NokiaCPQ_Spare__c){
					   system.debug(' In option non spare loop ');
					   if(!portfoliopackageToLines.isempty() && portfoliopackageToLines.containsKey(lineitem.Apttus_Config2__OptionId__r.NokiaCPQ_Portfolio_Package_Code__c)){
						   linelist = portfoliopackageToLines.get(lineitem.Apttus_Config2__OptionId__r.NokiaCPQ_Portfolio_Package_Code__c);
					   }
					   linelist.add(lineitem);
					   portfoliopackageToLines.put(lineitem.Apttus_Config2__OptionId__r.NokiaCPQ_Portfolio_Package_Code__c, linelist);
					   if(!portfolioPackageCode.contains(lineitem.Apttus_Config2__OptionId__r.NokiaCPQ_Portfolio_Package_Code__c)){
						   portfolioPackageCode.add(lineitem.Apttus_Config2__OptionId__r.NokiaCPQ_Portfolio_Package_Code__c);
					   }
				   }
			   }
			else if((lineitem.Apttus_Config2__ProductId__r.NokiaCPQ_Portfolio_Package_Code__c) != null){
				system.debug(' In parent/standalone loop ');
				if(!portfoliopackageToLines.isempty() && portfoliopackageToLines.containsKey(lineitem.Apttus_Config2__ProductId__r.NokiaCPQ_Portfolio_Package_Code__c)){
					linelist = portfoliopackageToLines.get(lineitem.Apttus_Config2__ProductId__r.NokiaCPQ_Portfolio_Package_Code__c);
				}
				linelist.add(lineitem);
				portfoliopackageToLines.put(lineitem.Apttus_Config2__ProductId__r.NokiaCPQ_Portfolio_Package_Code__c, linelist);
				if(!portfolioPackageCode.contains(lineitem.Apttus_Config2__ProductId__r.NokiaCPQ_Portfolio_Package_Code__c)){
					portfolioPackageCode.add(lineitem.Apttus_Config2__ProductId__r.NokiaCPQ_Portfolio_Package_Code__c);
				}
			}
		}
			system.debug('portfolio package code set : ' + portfolioPackageCode);
			system.debug(' PortfoliopackageToLines : ' + PortfoliopackageToLines);
		for(Apttus_Config2__LineItem__c lineitem : allLineItems ){
			system.debug(lineitem.Apttus_Config2__LineNumber__c  + ' -- ' + lineitem.Apttus_Config2__PrimaryLineNumber__c  + ' -- ' + lineitem.Apttus_Config2__ParentBundleNumber__c);
			if(lineitem.Apttus_Config2__ParentBundleNumber__c != null){
				system.debug('not parent line loop');
				list<Apttus_Config2__LineItem__c> sILines = new list<Apttus_Config2__LineItem__c>();
				map<Decimal, list<Apttus_Config2__LineItem__c>> grouptoSI = new map<Decimal, list<Apttus_Config2__LineItem__c>>();
				list<Decimal> groupPrimaryLineNum = new list<Decimal>();
				if(mapBundleToGroup.containskey(lineitem.Apttus_Config2__ParentBundleNumber__c)){
					groupPrimaryLineNum = mapBundleToGroup.get(lineitem.Apttus_Config2__ParentBundleNumber__c);
				}   
				groupPrimaryLineNum.add(lineitem.Apttus_Config2__PrimaryLineNumber__c);
				mapBundleToGroup.put(lineitem.Apttus_Config2__ParentBundleNumber__c, groupPrimaryLineNum);
				system.debug('mapBundleToGroup : '+ mapBundleToGroup);
				if(bundleproductLineNum.Contains(lineitem.Apttus_Config2__ParentBundleNumber__c)){
					system.debug('in arcadia loop');
					if(bundleTogroupToSILines.containskey(lineitem.Apttus_Config2__ParentBundleNumber__c)){
						grouptoSI = bundleTogroupToSILines.get(lineitem.Apttus_Config2__ParentBundleNumber__c);
						if(grouptoSI.containskey(lineitem.Apttus_Config2__LineNumber__c)){
							sILines = grouptoSI.get(lineitem.Apttus_Config2__LineNumber__c);
						}
					}
					grouptoSI.put(lineitem.Apttus_Config2__PrimaryLineNumber__c, sILines);
					groupLineList.add(lineitem);
					groupProductId.add(lineitem.Apttus_Config2__OptionId__r.ProductCode);
					groupProductNum.add(lineitem.Apttus_Config2__PrimaryLineNumber__c);
					mapgrouplineToQuantity.put(lineitem.Apttus_Config2__PrimaryLineNumber__c, lineitem.Apttus_Config2__Quantity__c);
					mapgroupCodeToQuantity.put(lineitem.Apttus_Config2__OptionId__r.ProductCode, lineitem.Apttus_Config2__Quantity__c);
					bundleTogroupToSILines.put(lineitem.Apttus_Config2__ParentBundleNumber__c, grouptoSI);
					//system.debug(BundleTogroupToSILines.get(lineitem.Apttus_Config2__ParentBundleNumber__c));
						//system.debug(grouptoSI.get(lineitem.Apttus_Config2__PrimaryLineNumber__c));
				   
				}
				else{
					system.debug('in SI group');
					Decimal parenttoParentbundlenumber = optionToParent.get(lineitem.Apttus_Config2__ParentBundleNumber__c);
					if(bundleTogroupToSILines.containskey(parenttoParentbundlenumber)){
						grouptoSI = bundleTogroupToSILines.get(parenttoParentbundlenumber);
						if(grouptoSI.containskey(lineitem.Apttus_Config2__ParentBundleNumber__c)){
							sILines = grouptoSI.get(lineitem.Apttus_Config2__ParentBundleNumber__c);
						}			  
					}
					sILines.add(lineitem);
					siLineList.add(lineitem);
					grouptoSI.put(lineitem.Apttus_Config2__ParentBundleNumber__c, sILines);
					bundleTogroupToSILines.put(parenttoParentbundlenumber, grouptoSI);  
 // system.debug(grouptoSI.get(lineitem.Apttus_Config2__ParentBundleNumber__c));
					   //system.debug('BundleTogroupToSILines : '+BundleTogroupToSILines.get(lineitem.Apttus_Config2__LineNumber__c));
					  
					
				}
			}
			else{
				map<Decimal, list<Apttus_Config2__LineItem__c>> grouptoSI = new map<Decimal, list<Apttus_Config2__LineItem__c>>();
				bundleTogroupToSILines.put(lineitem.Apttus_Config2__LineNumber__c, grouptoSI);
				   // system.debug('BundleTogroupToSILines : '+ BundleTogroupToSILines.get(lineitem.Apttus_Config2__LineNumber__c));
				}   
		}
		for (string portfolioPackgae : portfoliopackageToLines.keyset()){
			list<Apttus_Config2__LineItem__c> grouplines = new list<Apttus_Config2__LineItem__c>();
			for(Apttus_Config2__LineItem__c packageLines : portfoliopackageToLines.get(portfolioPackgae)){
				Apttus_Config2__LineItem__c groupline =  new Apttus_Config2__LineItem__c();
				system.debug('packageLines : ' + packageLines.Apttus_Config2__PrimaryLineNumber__c + '  '+ optionToParent.get(packageLines.Apttus_Config2__PrimaryLineNumber__c));
				if(optionToParent.get(packageLines.Apttus_Config2__PrimaryLineNumber__c)!= null){
					groupline  = primaryLineNum.get(optionToParent.get(packageLines.Apttus_Config2__PrimaryLineNumber__c));
					if(!grouplines.contains(groupline) && groupline != null ){
						grouplines.add(groupline);
						dynamicgroupProductId.add(groupline.Apttus_Config2__OptionId__r.ProductCode);
						dynamicgroupProductNum.add(groupline.Apttus_Config2__PrimaryLineNumber__c);
					}
					integer count = 0;
					map<decimal, integer> grouptoSICOunt = new map<decimal, integer>();
					if(!mapPortfolioGroupToSICount.containskey(portfolioPackgae)){
						system.debug('portfolio not present in map');
						grouptoSICOunt.put(optionToParent.get(packageLines.Apttus_Config2__PrimaryLineNumber__c), 1);
						mapPortfolioGroupToSICount.put(portfolioPackgae,grouptoSICOunt);
					}else{
						grouptoSICOunt = mapPortfolioGroupToSICount.get(portfolioPackgae);
						if(!grouptoSICOunt.containskey(optionToParent.get(packageLines.Apttus_Config2__PrimaryLineNumber__c))){
							count = 1;
							system.debug('group not present in map');
						}
						else{
							count = grouptoSICOunt.get(optionToParent.get(packageLines.Apttus_Config2__PrimaryLineNumber__c));
							system.debug('group present in map'+ count);
							Count = count + 1;
						}
						grouptoSICOunt.put(optionToParent.get(packageLines.Apttus_Config2__PrimaryLineNumber__c), Count);
						mapPortfolioGroupToSICount.put(portfolioPackgae,grouptoSICOunt);
					}
				}else{
					system.debug('in stand alone loop');
					list<Apttus_Config2__LineItem__c> standalonLI = new list<Apttus_Config2__LineItem__c>();
					if(portfolioPackageToStandalone.containskey(portfolioPackgae)){
						standalonLI= portfolioPackageToStandalone.get(portfolioPackgae);
					}
					standalonLI.add(packageLines);
					portfolioPackageToStandalone.put(portfolioPackgae, standalonLI);
				}
			}
			system.debug('grouplines' + grouplines);
			system.debug('dynamicgroupProductId' + dynamicgroupProductId);
			system.debug('mapPortfolioGroupToSICount' + mapPortfolioGroupToSICount);
			PortfoliopackageTogroup.put(portfolioPackgae, grouplines);
		}
		system.debug('PortfoliopackageTogroup : ' + PortfoliopackageTogroup);
		system.debug('portfolioPackageToStandalone : ' + portfolioPackageToStandalone);
		for (string portfolioPackgae : portfoliopackageToLines.keyset()){
			list<Apttus_Config2__LineItem__c> bundlelines = new list<Apttus_Config2__LineItem__c>();
			if(PortfoliopackageTogroup.containskey(portfolioPackgae)){
				for(Apttus_Config2__LineItem__c packageLines : PortfoliopackageTogroup.get(portfolioPackgae)){
					Apttus_Config2__LineItem__c bundleLine = primaryLineNum.get(optionToParent.get(packageLines.Apttus_Config2__PrimaryLineNumber__c));
					if(!bundlelines.contains(bundleLine)){
						bundlelines.add(bundleLine);
					}
				}
			}
			PortfoliopackageToBundle.put(portfolioPackgae, bundlelines);
		}
		for(string groupproductCode : groupProductId){
			if(!dynamicgroupProductId.contains(groupproductCode)){
				staticGroupId.add(groupproductCode);
			}
		}
		 for(Decimal groupLineNum : groupProductNum){
			if(!dynamicgroupProductNum.contains(groupLineNum)){
				staticGroupNum.add(groupLineNum);
			}
		}
		system.debug('staticGroupId : ' + staticGroupId);
		//get Static bundles
		for(CPQ_MPW_Bundle__c staticBundleline : [select id, name, CPQ_Bundle__c, CPQ_Bundle__r.ProductCode, CPQ_Entry_Type__c, CPQ_Main_Bundle__c, CPQ_Main_Bundle__r.ProductCode,
												  Price_Reserve__c, CPQ_Quantity__c, CPQ_Sales_Item__c, CPQ_Sales_Item__r.productcode, 
												  CPQ_Sales_Item__r.NokiaCPQ_Portfolio_Package_Code__c, CPQ_Sales_Item__r.name, CPQ_Sales_Item_Reserve__c,
												  CPQ_Sales_Item__r.NokiaCPQ_Item_Type__c, CPQ_Sales_Item__r.CPQ_NPT_SI_TYPE__c
												  from CPQ_MPW_Bundle__c 
												  where CPQ_Main_Bundle__r.ProductCode = 'MPW' AND CPQ_Bundle__r.ProductCode in: staticGroupId AND CPQ_Entry_Type__c = 'Static']){
													  system.debug('query212: '+staticBundleline.CPQ_Sales_Item__r.CPQ_NPT_SI_TYPE__c);
													  
													  staticLinesProdCode.add(staticBundleline.CPQ_Sales_Item__r.productcode);
													  if(!portfolioPackageCodeStatic.contains(staticBundleline.CPQ_Sales_Item__r.NokiaCPQ_Portfolio_Package_Code__c) && staticBundleline.CPQ_Sales_Item__r.NokiaCPQ_Portfolio_Package_Code__c != null){
														  portfolioPackageCodeStatic.add(staticBundleline.CPQ_Sales_Item__r.NokiaCPQ_Portfolio_Package_Code__c);
													  }
													  map<string, list<CPQ_MPW_Bundle__c>> staticGroupToSI = new map<string, list<CPQ_MPW_Bundle__c>> ();
													  list<CPQ_MPW_Bundle__c> staticSI = new list<CPQ_MPW_Bundle__c>();
													  if(staticBundleTogroupToSILines.containsKey(staticBundleline.CPQ_Main_Bundle__r.ProductCode)){
														  staticGroupToSI = staticBundleTogroupToSILines.get(staticBundleline.CPQ_Main_Bundle__r.ProductCode);
														  if(staticGroupToSI.containsKey(staticBundleline.CPQ_Bundle__r.ProductCode)){
															  staticSI = staticGroupToSI.get(staticBundleline.CPQ_Bundle__r.ProductCode);
														  }
													  }
													  staticSI.add(staticBundleline);
													  staticGroupToSI.put(staticBundleline.CPQ_Bundle__r.ProductCode, staticSI);
													  staticBundleTogroupToSILines.put(staticBundleline.CPQ_Main_Bundle__r.ProductCode, staticGroupToSI);
													  if(staticBundleline.CPQ_Sales_Item__r.NokiaCPQ_Portfolio_Package_Code__c != Null){
														  list<CPQ_MPW_Bundle__c> staticSIList = new list<CPQ_MPW_Bundle__c>();
														  if(portfoliopackageToStaticLines.containsKey(staticBundleline.CPQ_Sales_Item__r.NokiaCPQ_Portfolio_Package_Code__c)){
															  staticSIList= portfoliopackageToStaticLines.get(staticBundleline.CPQ_Sales_Item__r.NokiaCPQ_Portfolio_Package_Code__c);
														  }
														  staticSIList.add(staticBundleline);
														  portfoliopackageToStaticLines.put(staticBundleline.CPQ_Sales_Item__r.NokiaCPQ_Portfolio_Package_Code__c, staticSIList);
														  
														  list<string> staticgroupList = new list<String>();
														  if(portfoliopackageToStaticGroup.containskey(staticBundleline.CPQ_Sales_Item__r.NokiaCPQ_Portfolio_Package_Code__c)){
															  staticgroupList = portfoliopackageToStaticGroup.get(staticBundleline.CPQ_Sales_Item__r.NokiaCPQ_Portfolio_Package_Code__c);
														  }
														  if(!staticgroupList.contains(staticBundleline.CPQ_Bundle__r.ProductCode)){
															  staticgroupList.add(staticBundleline.CPQ_Bundle__r.ProductCode);}
														  portfoliopackageToStaticGroup.put(staticBundleline.CPQ_Sales_Item__r.NokiaCPQ_Portfolio_Package_Code__c, staticgroupList);
														  list<string> staticbundleList = new list<String>();
														  if(portfoliopackageToStaticBundle.containsKey(staticBundleline.CPQ_Sales_Item__r.NokiaCPQ_Portfolio_Package_Code__c)){
															  staticbundleList = portfoliopackageToStaticBundle.get(staticBundleline.CPQ_Sales_Item__r.NokiaCPQ_Portfolio_Package_Code__c);
														  }
														  if(!staticbundleList.contains(staticBundleline.CPQ_Main_Bundle__r.ProductCode)){
															  staticbundleList.add(staticBundleline.CPQ_Main_Bundle__r.ProductCode);}
														  portfoliopackageToStaticBundle.put(staticBundleline.CPQ_Sales_Item__r.NokiaCPQ_Portfolio_Package_Code__c, staticbundleList);
														  map<string, integer> staticGroupToSiCount = new map<string, integer>();
														  integer i = 0;
														  if(mapPortfoliostaticGroupToSICount.containskey(staticBundleline.CPQ_Sales_Item__r.NokiaCPQ_Portfolio_Package_Code__c)){
															  staticGroupToSiCount = mapPortfoliostaticGroupToSICount.get(staticBundleline.CPQ_Sales_Item__r.NokiaCPQ_Portfolio_Package_Code__c);
															  if(staticGroupToSiCount.containskey(staticBundleline.CPQ_Bundle__r.ProductCode)){
																  i = staticGroupToSiCount.get(staticBundleline.CPQ_Bundle__r.ProductCode);
															  }
														  }
														  i++;
														  staticGroupToSiCount.put(staticBundleline.CPQ_Bundle__r.ProductCode, i);
														  mapPortfoliostaticGroupToSICount.put(staticBundleline.CPQ_Sales_Item__r.NokiaCPQ_Portfolio_Package_Code__c, staticGroupToSiCount);
													  }
												  }
												  
			system.debug('staticLinesProdCode : ' + staticLinesProdCode);
			system.debug('Static portfolio package code set : ' + portfolioPackageCodeStatic);
			system.debug('Static PortfoliopackageToStaticBundle : ' + PortfoliopackageToStaticBundle);
			system.debug('Static PortfoliopackageToStaticGroup : ' + PortfoliopackageToStaticGroup);
			system.debug('Static PortfoliopackageToStaticLines : ' + PortfoliopackageToStaticLines);
			system.debug('Static staticBundleTogroupToSILines : ' + staticBundleTogroupToSILines);
			system.debug('Static mapPortfoliostaticGroupToSICount : ' + mapPortfoliostaticGroupToSICount);
			
			system.debug('portfolio package code set : ' + portfolioPackageCode);
			system.debug('PortfoliopackageToBundle : ' + PortfoliopackageToBundle);
			system.debug('PortfoliopackageTogroup : ' + PortfoliopackageTogroup);
			system.debug('PortfoliopackageToLines : ' + PortfoliopackageToLines);
			system.debug('CART BundleTogroupToSILines : '+ BundleTogroupToSILines);
			system.debug('mapPortfolioGroupToSICount' + mapPortfolioGroupToSICount);
			
			for(Apttus_Config2__PriceListItem__c pLIRec : [select id, name, Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.productCode, Apttus_Config2__ListPrice__c from Apttus_Config2__PriceListItem__c
														where Apttus_Config2__PriceListId__c =: quoteRec.Apttus_QPConfig__PriceListId__c and Apttus_Config2__ProductId__r.productCode in: staticLinesProdCode]){
															
			if(pLIRec.Apttus_Config2__ProductId__r.productCode != null && pLIRec.Apttus_Config2__ListPrice__c != Null){
				
				mapStaticProductCodeToPrice.put(pLIRec.Apttus_Config2__ProductId__r.productCode, pLIRec.Apttus_Config2__ListPrice__c);
			}
			
			}
		
		
		finalportfolioPackageCode.addall(portfolioPackageCode);
		for(string staticPD : portfolioPackageCodeStatic){
			if(!finalportfolioPackageCode.contains(staticPD)){
				finalportfolioPackageCode.add(staticPD);
			}
		}
		
		/***** ----------JSON Build ------------ *******/
		JSONGenerator gen = JSON.createGenerator(true);
		gen.writeStartObject();
		gen.writeFieldName('Data');
		gen.writeStartArray();
		//Header
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_HEADERS_STORE');
		gen.writeFieldName('Entities');
		gen.writeStartArray();
		gen.writeStartObject();
		gen.writeFieldName('Parameters');
		gen.writeStartObject();
		gen.writeStringField('NPTR_H_OpportunityId', oppty );	
		gen.writeStringField('NPTR_H_OfferId', offerId );   
	   // gen.writeStringField('NPTR_H_OpportunityId', '20.DE.901799');  
	   // gen.writeStringField('NPTR_H_OfferId', '20.DE.901799.01');	
		gen.writeStringField('NPTR_H_Author', userName);									  
		gen.writeStringField('NPTR_H_Year1Indicator', '2020');
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeEndArray();
		gen.writeEndObject();
		//Scenario
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_SCENARIOS_STORE');
		gen.writeFieldName('References');
		gen.writeStartObject();
		gen.writeFieldName('RecordID');
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_HEADERS_STORE');
		gen.writeStringField('OutputName', 'RecordID');
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeFieldName('Entities');
		gen.writeStartArray();
		gen.writeStartObject();
		gen.writeFieldName('Parameters');
		gen.writeStartObject();
		gen.writeStringField('NPTR_SC_ScenarioId', '1');
		gen.writeStringField('NPTR_SC_Name', Nokia_CPQ_Constants.NPT_Region);
		gen.writeStringField('NPTR_SC_ScenarioDescription', Nokia_CPQ_Constants.NPT_Region);
		gen.writeBooleanField('NPTR_SC_SCActive', true);
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeEndArray();
		gen.writeEndObject();
		//Phase
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_PHASES_STORE');
		gen.writeFieldName('References');
		gen.writeStartObject();
		gen.writeFieldName('RecordID');
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_HEADERS_STORE');
		gen.writeStringField('OutputName', 'RecordID');
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeFieldName('Entities');
		gen.writeStartArray();

				gen.writeStartObject();
				gen.writeFieldName('Parameters');
				gen.writeStartObject();
				gen.writeStringField('NPTR_PH_Id', '1');
				gen.writeStringField('NPTR_PH_Name', Nokia_CPQ_Constants.NPT_Phase);
				gen.writeDateField('NPTR_PH_StartDate', System.today());
				gen.writeStringField('NPTR_PH_Description', Nokia_CPQ_Constants.NPT_Phase);
				gen.writeBooleanField('NPTR_PH_Active', true);
				gen.writeBooleanField('NPTR_PH_SelectedForLoA', true); 
				gen.writeEndObject();
				gen.writeEndObject();

		gen.writeEndArray();
		gen.writeEndObject();
		//sheet
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_SHEETS_STORE');
		gen.writeFieldName('References');
		gen.writeStartObject();
		gen.writeFieldName('RecordID');
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_HEADERS_STORE');
		gen.writeStringField('OutputName', 'RecordID');
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeFieldName('Entities');
		gen.writeStartArray();
		integer i = 1;
		for(string portfolio : finalportfolioPackageCode){
			gen.writeStartObject();
			gen.writeFieldName('Parameters');
			gen.writeStartObject();
			gen.writeNumberField('NPTR_SH_Id', i);
			gen.writeStringField('NPTR_SH_Name', portfolio);
			gen.writeStringField('NPTR_SH_PortfolioPackage', portfolio);
			gen.writeBooleanField('NPTR_SH_Active', true);
			gen.writeNullField('NPTR_SH_SolutionAreaId'); //???
			gen.writeStringField('NPTR_SH_ScenarioId', '1');
			gen.writeStringField('NPTR_SH_Contract_Currency', quotecurrency);	 
			gen.writeNumberField('NPTR_SH_Contract_ExchangeRate', exchangeRate); 
			gen.writeStringField('NPTR_SH_Internal_Currency', quotecurrency); 
			gen.writeNumberField('NPTR_SH_Internal_ExchangeRate', exchangeRate); 
			gen.writeStringField('NPTR_SH_Local_Currency', quotecurrency); 
			gen.writeNumberField('NPTR_SH_Local_ExchangeRate', exchangeRate); 
			gen.writeStringField('NPTR_SH_IRP_Currency', quotecurrency); 
			gen.writeNumberField('NPTR_SH_IRP_ExchangeRate', exchangeRate); 
			gen.writeStringField('NPTR_SH_ELP_Currency', quotecurrency); 
			gen.writeNumberField('NPTR_SH_ELP_ExchangeRate', exchangeRate); 
			gen.writeStringField('NPTR_SH_NLP_Currency', quotecurrency); 
			gen.writeNumberField('NPTR_SH_NLP_ExchangeRate', exchangeRate); 
			gen.writeStringField('NPTR_SH_CLP_Currency', quotecurrency); 
			gen.writeNumberField('NPTR_SH_CLP_ExchangeRate', exchangeRate); 
			gen.writeStringField('NPTR_SH_Eost_Currency', quotecurrency); 
			gen.writeNumberField('NPTR_SH_Eost_ExchangeRate', exchangeRate); 
			gen.writeStringField('NPTR_SH_Cost_Currency', quotecurrency); 
			gen.writeNumberField('NPTR_SH_Cost_ExchangeRate', exchangeRate);
			gen.writeStringField('NPTR_SH_IRP_Incoterm', 'FCA'); 
			gen.writeStringField('NPTR_SH_ELP_Incoterm', 'FCA'); 
			gen.writeStringField('NPTR_SH_Eost_Incoterm', 'FCA'); 
			gen.writeStringField('NPTR_SH_NLP_Incoterm', 'FCA'); 
			gen.writeStringField('NPTR_SH_BenchmarkCategory', '>>> Please Select');
			gen.writeNumberField('NPTR_SH_CInternal2ContractExRate', exchangeRate); 
			gen.writeNumberField('NPTR_SH_CInternal2LocalExRate', exchangeRate); 
			gen.writeNumberField('NPTR_SH_PInternal2ContractExRate', exchangeRate); 
			gen.writeNumberField('NPTR_SH_PInternal2LocalExRate', exchangeRate); 
			gen.writeStringField('NPTR_SH_ShowOverrides', '0'); 
			gen.writeStringField('NPTR_SH_PPSelection', '7'); 
			gen.writeStringField('NPTR_SH_LoAScenario', 'New Installation'); 
			gen.writeStringField('NPTR_SH_ScenarioId', '1'); 
			gen.writeEndObject();
			gen.writeEndObject();
			portfolioToSheetID.put(portfolio, i);
			i++;
		}
		gen.writeEndArray();
		gen.writeEndObject();
		//Discount Activity Store
		 gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_DISCOUNTSACTIVITY_STORE');
		gen.writeFieldName('References');
		gen.writeStartObject();
		gen.writeFieldName('RecordID');
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_HEADERS_STORE');
		gen.writeStringField('OutputName', 'RecordID');
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeFieldName('Entities');
		gen.writeStartArray();
		setDiscountActivityStore(gen,'1', Nokia_CPQ_Constants.NPT_discountFoC, false);
		 if((quoteRec.NokiaCPQ_Quote_DOD__c != Null && quoteRec.NokiaCPQ_Quote_DOD__c != 0) || (quoteRec.NokiaCPQ_Quote_DPD__c != Null && quoteRec.NokiaCPQ_Quote_DPD__c != 0))
		 {
		 setDiscountActivityStore(gen,'2', Nokia_CPQ_Constants.NPT_discountVol, true);
		 }
		 else
		{
		setDiscountActivityStore(gen,'2', Nokia_CPQ_Constants.NPT_discountVol, false);
		}
		setDiscountActivityStore(gen,'3', Nokia_CPQ_Constants.NPT_discountPE, false);
		if(quoteRec.NokiaCPQ_Quote_CAD__c != Null && quoteRec.NokiaCPQ_Quote_CAD__c != 0)
		{   
		setDiscountActivityStore(gen,'4', Nokia_CPQ_Constants.NPT_discountLSD, true);
		}
		else
		{
		setDiscountActivityStore(gen,'4', Nokia_CPQ_Constants.NPT_discountLSD, false);
		}	   
		setDiscountActivityStore(gen,'5', Nokia_CPQ_Constants.NPT_discountPSD, false);
		setDiscountActivityStore(gen,'6', Nokia_CPQ_Constants.NPT_discountRfS, false);
		setDiscountActivityStore(gen,'7', Nokia_CPQ_Constants.NPT_discountFL, false);
		setDiscountActivityStore(gen,'8', Nokia_CPQ_Constants.NPT_discountCE, false);
		setDiscountActivityStore(gen,'9', Nokia_CPQ_Constants.NPT_discountRfC, false);
		setDiscountActivityStore(gen,'10', Nokia_CPQ_Constants.NPT_discountTCD, false);
		setDiscountActivityStore(gen,'11', Nokia_CPQ_Constants.NPT_discountSF, false);
		setDiscountActivityStore(gen,'12', Nokia_CPQ_Constants.NPT_discountTFC, false);
		setDiscountActivityStore(gen,'13', Nokia_CPQ_Constants.NPT_discountVA, false);
		setDiscountActivityStore(gen,'14', Nokia_CPQ_Constants.NPT_discountCA, false);
		
		gen.writeEndArray();
		gen.writeEndObject();
		//Discountstore
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_DISCOUNTS_STORE');
		gen.writeFieldName('References');
		gen.writeStartObject();
		gen.writeFieldName('RecordID');
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_HEADERS_STORE');
		gen.writeStringField('OutputName', 'RecordID');
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeFieldName('Entities');
		gen.writeStartArray();
		integer disId = 1;
		//CAD
		if(quoteRec.NokiaCPQ_Quote_CAD__c != Null && quoteRec.NokiaCPQ_Quote_CAD__c != 0){
			gen.writeStartObject();
			gen.writeFieldName('Parameters');
			gen.writeStartObject();
			gen.writeNumberField('NPTR_DS_Id', disId);
			gen.writeStringField('NPTR_DS_Name', 'CAD(Competitive Additional Discount)');
			gen.writeStringField('NPTR_DS_Group', 'C');
			gen.writeStringField('NPTR_DS_GroupName', 'C. One-Off Discounts (CUP -> CNP)');
			gen.writeStringField('NPTR_DS_Subgroup', 'C.1');
			gen.writeStringField('NPTR_DS_SubgroupName', 'C.1. Lump Sum Discounts');
			gen.writeStringField('NPTR_DS_LevelId', '2');
			gen.writeStringField('NPTR_DS_LevelName', 'CNP');
			gen.writeStringField('NPTR_DS_BusinessGroup', 'All');
			gen.writeStringField('NPTR_DS_BusinessLine', 'All');
			gen.writeStringField('NPTR_DS_PortfolioPackage', 'All');
			gen.writeStringField('NPTR_DS_CategoryId', '-1');
			gen.writeStringField('NPTR_DS_CategoryName', 'All');
			gen.writeStringField('NPTR_DS_ClassId', '-1');
			gen.writeStringField('NPTR_DS_ClassName', 'All');
			gen.writeStringField('NPTR_DS_Behaviour', 'one-off');
			gen.writeStringField('NPTR_DS_DiscountNumberOfRows', '5');
			gen.writeStringField('NPTR_DS_Position', '107');
			gen.writeEndObject();
			gen.writeEndObject();
			mapdisStoreTodisId.put('CAD', disId);
			disId++;
		}
		//DOD
		if(quoteRec.NokiaCPQ_Quote_DOD__c != Null && quoteRec.NokiaCPQ_Quote_DOD__c != 0){
			gen.writeStartObject();
			gen.writeFieldName('Parameters');
			gen.writeStartObject();
			gen.writeNumberField('NPTR_DS_Id', disId);
			gen.writeStringField('NPTR_DS_Name', 'DOD(Deal Origination Discount)');
			gen.writeStringField('NPTR_DS_Group', 'B');
			gen.writeStringField('NPTR_DS_GroupName', Nokia_CPQ_Constants.NPT_Discount);
			gen.writeStringField('NPTR_DS_Subgroup', 'B.1');
			gen.writeStringField('NPTR_DS_SubgroupName', Nokia_CPQ_Constants.NPT_VDiscount);
			gen.writeStringField('NPTR_DS_LevelId', '2');
			gen.writeStringField('NPTR_DS_LevelName', 'CUP');
			gen.writeStringField('NPTR_DS_BusinessGroup', 'All');
			gen.writeStringField('NPTR_DS_BusinessLine', 'All');
			gen.writeStringField('NPTR_DS_PortfolioPackage', 'All');
			gen.writeStringField('NPTR_DS_CategoryId', '-1');
			gen.writeStringField('NPTR_DS_CategoryName', 'All');
			gen.writeStringField('NPTR_DS_ClassId', '-1');
			gen.writeStringField('NPTR_DS_ClassName', 'All');
			gen.writeStringField('NPTR_DS_Behaviour', 'recurring');
			gen.writeStringField('NPTR_DS_DiscountNumberOfRows', '5');
			gen.writeStringField('NPTR_DS_Position', '57');
			gen.writeEndObject();
			gen.writeEndObject();
			mapdisStoreTodisId.put('DOD', disId);
			disId++;
		}
		//DPD
		if(quoteRec.NokiaCPQ_Quote_DPD__c != Null && quoteRec.NokiaCPQ_Quote_DPD__c != 0){
			gen.writeStartObject();
			gen.writeFieldName('Parameters');
			gen.writeStartObject();
			gen.writeNumberField('NPTR_DS_Id', disId);
			gen.writeStringField('NPTR_DS_Name', 'DPD(Distributor Price Deviation)');
			gen.writeStringField('NPTR_DS_Group', 'B');
			gen.writeStringField('NPTR_DS_GroupName', Nokia_CPQ_Constants.NPT_Discount);
			gen.writeStringField('NPTR_DS_Subgroup', 'B.1');
			gen.writeStringField('NPTR_DS_SubgroupName', Nokia_CPQ_Constants.NPT_VDiscount);
			gen.writeStringField('NPTR_DS_LevelId', '2');
			gen.writeStringField('NPTR_DS_LevelName', 'CUP');
			gen.writeStringField('NPTR_DS_BusinessGroup', 'All');
			gen.writeStringField('NPTR_DS_BusinessLine', 'All');
			gen.writeStringField('NPTR_DS_PortfolioPackage', 'All');
			gen.writeStringField('NPTR_DS_CategoryId', '-1');
			gen.writeStringField('NPTR_DS_CategoryName', 'All');
			gen.writeStringField('NPTR_DS_ClassId', '-1');
			gen.writeStringField('NPTR_DS_ClassName', 'All');
			gen.writeStringField('NPTR_DS_Behaviour', 'recurring');
			gen.writeStringField('NPTR_DS_DiscountNumberOfRows', '5');
			gen.writeStringField('NPTR_DS_Position', '63');
			gen.writeEndObject();
			gen.writeEndObject();
			mapdisStoreTodisId.put('DPD', disId);
		}	 
		gen.writeEndArray();
		gen.writeEndObject();
		//DiscuntValues
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_DISCOUNTVALUES_STORE');
		gen.writeFieldName('References');
		gen.writeStartObject();
		gen.writeFieldName('RecordID');
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_HEADERS_STORE');
		gen.writeStringField('OutputName', 'RecordID');
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeFieldName('Entities');
		gen.writeStartArray();
		//CAD
		if(quoteRec.NokiaCPQ_Quote_CAD__c != Null && quoteRec.NokiaCPQ_Quote_CAD__c != 0){
			gen.writeStartObject();
			gen.writeFieldName('Parameters');
			gen.writeStartObject();
			gen.writeNumberField('NPTR_DV_DiscountId', mapdisStoreTodisId.get('CAD'));
			gen.writeNumberField('NPTR_DV_PhaseId', 1);
			gen.writeStringField('NPTR_DV_Percentage', '0');
			gen.writeStringField('NPTR_DV_Factor', '1');
			gen.writeNumberField('NPTR_DV_DiscountAmount', quoteRec.NokiaCPQ_Quote_CAD__c);
			gen.writeStringField('NPTR_DV_DiscountPercentage', '0');
			gen.writeEndObject();
			gen.writeEndObject();   
		}
		//DOD
		if(quoteRec.NokiaCPQ_Quote_DOD__c != Null && quoteRec.NokiaCPQ_Quote_DOD__c != 0){
			gen.writeStartObject();
			gen.writeFieldName('Parameters');
			gen.writeStartObject();
			gen.writeNumberField('NPTR_DV_DiscountId', mapdisStoreTodisId.get('DOD'));
			gen.writeNumberField('NPTR_DV_PhaseId', 1);
			gen.writeStringField('NPTR_DV_Percentage', '0');
			gen.writeStringField('NPTR_DV_Factor', '1');
			gen.writeNumberField('NPTR_DV_DiscountAmount', quoteRec.NokiaCPQ_Quote_DOD__c);
			gen.writeStringField('NPTR_DV_DiscountPercentage', '0');
			gen.writeEndObject();
			gen.writeEndObject();
		}
		//DPD
		if(quoteRec.NokiaCPQ_Quote_DPD__c != Null && quoteRec.NokiaCPQ_Quote_DPD__c != 0){
			gen.writeStartObject();
			gen.writeFieldName('Parameters');
			gen.writeStartObject();
			gen.writeNumberField('NPTR_DV_DiscountId', mapdisStoreTodisId.get('DPD'));
			gen.writeNumberField('NPTR_DV_PhaseId', 1);
			gen.writeStringField('NPTR_DV_Percentage', '0');
			gen.writeStringField('NPTR_DV_Factor', '1');
			gen.writeNumberField('NPTR_DV_DiscountAmount', quoteRec.NokiaCPQ_Quote_DPD__c);
			gen.writeStringField('NPTR_DV_DiscountPercentage', '0');
			gen.writeEndObject();
			gen.writeEndObject();
		}
		gen.writeEndArray();
		gen.writeEndObject();
		//Bundle
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_SALESITEMSBUNDLES_STORE');
		gen.writeFieldName('References');
		gen.writeStartObject();
		gen.writeFieldName('RecordID');
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_HEADERS_STORE');
		gen.writeStringField('OutputName', 'RecordID');
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeFieldName('Entities');
		gen.writeStartArray();/*
		integer j = 1;
		
		for(string portfolio : finalportfolioPackageCode){
		   
			integer position = 1;
			if(PortfoliopackageTogroup.containskey(portfolio)){
				for(Apttus_Config2__LineItem__c groupLi : PortfoliopackageTogroup.get(portfolio)){
					gen.writeStartObject();
					gen.writeFieldName('Parameters');
					gen.writeStartObject();
					gen.writeNumberField('NPTR_SIB_Id', j);
					gen.writeNumberField('NPTR_SIB_SheetId', portfoliotoSheetID.get(portfolio));
					gen.writeNumberField('NPTR_SIB_Position', position);
					gen.writeStringField('NPTR_SIB_Code', groupLi.NokiaCPQ_Part_Number__c); 
					gen.writeStringField('NPTR_SIB_Description', groupLi.NokiaCPQ_Product_Description__c);
					gen.writeEndObject();
					gen.writeEndObject();
					groupNumToBundleID.put(groupLi.Apttus_Config2__PrimaryLineNumber__c, j);
					j++;
					position = position + mapPortfolioGroupToSICount.get(portfolio).get(groupLi.Apttus_Config2__PrimaryLineNumber__c)+ 1;
					system.debug('position : ' + position);
				}
			}
			if(portfoliopackageToStaticGroup.containskey(portfolio)){
				for(string groupLi : portfoliopackageToStaticGroup.get(portfolio)){
					gen.writeStartObject();
					gen.writeFieldName('Parameters');
					gen.writeStartObject();
					gen.writeNumberField('NPTR_SIB_Id', j);
					gen.writeNumberField('NPTR_SIB_SheetId', portfoliotoSheetID.get(portfolio));
					gen.writeNumberField('NPTR_SIB_Position', position);
					If(groupLi != null)
					{
						gen.writeStringField('NPTR_SIB_Code', groupLi);
					}
					else
					{
						gen.writeNullField('NPTR_SIB_Code');
					}
					
					gen.writeEndObject();
					gen.writeEndObject();
					groupNumToBundlecode.put(groupLi, j);
					j++;
					position = position + mapPortfoliostaticGroupToSICount.get(portfolio).get(groupLi)+ 1;
					system.debug('position : ' + position);
				}
			}
		}
		*/
		gen.writeEndArray();
		gen.writeEndObject();
		//SalesItems
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_SALESITEMS_STORE');
		gen.writeFieldName('References');
		gen.writeStartObject();
		gen.writeFieldName('RecordID');
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_HEADERS_STORE');
		gen.writeStringField('OutputName', 'RecordID');
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeFieldName('Entities');
		gen.writeStartArray();
		integer m = 1;
		for(string portfolio : finalportfolioPackageCode){
			integer siPosition = 1;
			list<decimal> groupPositionCounted = new list<decimal>();
			list<string> staticgroupPositionCounted = new list<string>();
			if(portfoliopackageToLines.containskey(portfolio)){
				for(Apttus_Config2__LineItem__c salesLi : portfoliopackageToLines.get(portfolio)){
				   /* if(mapPortfolioGroupToSICount.containskey(portfolio)){
						map<decimal, integer> grouptoSICOunt = mapPortfolioGroupToSICount.get(portfolio);
						if(grouptoSICOunt.containskey(optionToParent.get(salesLi.Apttus_Config2__PrimaryLineNumber__c)) && 
						   !groupPositionCounted.contains(optionToParent.get(salesLi.Apttus_Config2__PrimaryLineNumber__c))){
							   siPosition = siPosition + 2;
							   groupPositionCounted.add(optionToParent.get(salesLi.Apttus_Config2__PrimaryLineNumber__c));
						   }else{
							   siPosition = siPosition + 1;
						   }
					}else{
						siPosition = siPosition + 1;}*/
					gen.writeStartObject();
					gen.writeFieldName('Parameters');
					gen.writeStartObject();
					gen.writeNumberField('NPTR_SI_Id', m);
					gen.writeNumberField('NPTR_SI_SheetId', portfoliotoSheetID.get(portfolio));
					gen.writeNumberField('NPTR_SI_Position', siPosition);
					
					gen.writeStringField('NPTR_SI_Code', salesLi.NokiaCPQ_Part_Number__c); 
					gen.writeStringField('NPTR_SI_Description', salesLi.NokiaCPQ_Product_Description__c);
					if(groupNumToBundleID.containskey(salesLi.Apttus_Config2__ParentBundleNumber__c) && groupNumToBundleID.get(salesLi.Apttus_Config2__ParentBundleNumber__c) != Null ){
						gen.writeNumberField('NPTR_SI_BundleId',groupNumToBundleID.get(salesLi.Apttus_Config2__ParentBundleNumber__c));
					}
				  
					If(salesLi.CPQ_NPT_S_I_Type__c != null ) 
					{
						gen.writeStringField('NPTR_SI_Type', salesLi.CPQ_NPT_S_I_Type__c);  
					}
					else
					{
						gen.writenullField('NPTR_SI_Type');
					} 
					if(lineToCapacityUnit.containsKey(salesLi.Apttus_Config2__PrimaryLineNumber__c)){
						gen.writeStringField('NPTR_SI_PerUnit',lineToCapacityUnit.get(salesLi.Apttus_Config2__PrimaryLineNumber__c));
					} else{
						gen.writeNullField('NPTR_SI_PerUnit');
					}
		  
					  if(salesLi.CPQ_NPT_S_I_Type__c == 'HW' || salesLi.CPQ_NPT_S_I_Type__c == Nokia_CPQ_Constants.NPT_HW3) 
					  {
						gen.writeNumberField('NPTR_SI_CategoryId', 1);
					  }
					  else if(salesLi.CPQ_NPT_S_I_Type__c == 'SW' || salesLi.CPQ_NPT_S_I_Type__c == Nokia_CPQ_Constants.NPT_SW3) 
					  {
						gen.writeNumberField('NPTR_SI_CategoryId', 2);
					  }
					  else{
						gen.writeNumberField('NPTR_SI_CategoryId', 3);
						}
				   
					gen.writeStringField('NPTR_SI_CategoryName', salesLi.Item_Type__c); 
		
					gen.writeStringField('NPTR_SI_NLP', '1'); //to be updated , no change
					Decimal clpValue = 0;
					if(salesLi.NokiaCPQ_Accreditation_Discount__c==null){
							  salesLi.NokiaCPQ_Accreditation_Discount__c=0;
							
						}
					if(salesLi.NokiaCPQ_IncotermNew__c==null){
							salesLi.NokiaCPQ_IncotermNew__c=0;
							}
					clpValue = salesLi.NokiaCPQ_MPW_Pricing__c - (salesLi.NokiaCPQ_MPW_Pricing__c * (salesLi.NokiaCPQ_Accreditation_Discount__c/100));
					clpValue =  clpValue + (clpValue * (salesLi.NokiaCPQ_IncotermNew__c/100));
					gen.writeNumberField('NPTR_SI_CLP', clpValue.setScale(2));
					
					gen.writeNullField('NPTR_SI_NLP_Discount'); //to be updated , no change
					gen.writeStringField('NPTR_SI_NLP_SalesMargin', '1'); //to be updated , no change
					gen.writeStringField('NPTR_SI_Info',salesLi.ID);
					gen.writeNumberField('NPTR_SI_IRP',salesLi.NokiaCPQ_MPW_Pricing__c);
					gen.writeNumberField('NPTR_SI_ELP',clpValue.setScale(2));
					gen.writeStringField('NPTR_SI_IRP_Discount','0');
					gen.writeEndObject();
					gen.writeEndObject();
					m++;
					siPosition++;
				}
			}
			if(portfoliopackageToStaticLines.containskey(portfolio)){
				for(CPQ_MPW_Bundle__c salesLi : portfoliopackageToStaticLines.get(portfolio)){
					/*if(mapPortfoliostaticGroupToSICount.containskey(portfolio)){
						map<string, integer> grouptoSICOunt = mapPortfoliostaticGroupToSICount.get(portfolio);
						if(grouptoSICOunt.containskey(salesLi.CPQ_Bundle__r.ProductCode) && 
						   !staticgroupPositionCounted.contains(salesLi.CPQ_Bundle__r.ProductCode)){
							   siPosition = siPosition + 2;
							   staticgroupPositionCounted.add(salesLi.CPQ_Bundle__r.ProductCode);
						   }else{ 
							   siPosition = siPosition + 1;
						   }
					}else{ 
						siPosition = siPosition + 1; } */
					gen.writeStartObject();
					gen.writeFieldName('Parameters');
					gen.writeStartObject();
					gen.writeNumberField('NPTR_SI_Id', m);
					gen.writeNumberField('NPTR_SI_SheetId', portfoliotoSheetID.get(portfolio));
					gen.writeNumberField('NPTR_SI_Position', siPosition);
					gen.writeStringField('NPTR_SI_Code', salesLi.CPQ_Sales_Item__r.productCode);
					gen.writeStringField('NPTR_SI_Description', salesLi.CPQ_Sales_Item__r.name);
					if(groupNumToBundlecode.containskey(salesLi.CPQ_Bundle__r.ProductCode) && groupNumToBundlecode.get(salesLi.CPQ_Bundle__r.ProductCode) != Null ){
						gen.writeNumberField('NPTR_SI_BundleId',groupNumToBundlecode.get(salesLi.CPQ_Bundle__r.ProductCode));
					}
					 If(salesLi.CPQ_Sales_Item__r.CPQ_NPT_SI_TYPE__c != null)
					{
						gen.writeStringField('NPTR_SI_Type', salesLi.CPQ_Sales_Item__r.CPQ_NPT_SI_TYPE__c);  
					}
					else
					{
						gen.writenullField('NPTR_SI_Type');
					} 
				   gen.writeNullField('NPTR_SI_PerUnit');
						 
				  if(salesLi.CPQ_Sales_Item__r.CPQ_NPT_SI_TYPE__c == 'HW' || salesLi.CPQ_Sales_Item__r.CPQ_NPT_SI_TYPE__c == Nokia_CPQ_Constants.NPT_HW3)
				  {
					gen.writeNumberField('NPTR_SI_CategoryId', 1);
				  }
				  else if(salesLi.CPQ_Sales_Item__r.CPQ_NPT_SI_TYPE__c == 'SW' || salesLi.CPQ_Sales_Item__r.CPQ_NPT_SI_TYPE__c == Nokia_CPQ_Constants.NPT_SW3) 
				  {
					gen.writeNumberField('NPTR_SI_CategoryId', 2);
				  }
				  else{
					gen.writeNumberField('NPTR_SI_CategoryId', 3);
					}
						
				  
					gen.writeStringField('NPTR_SI_CategoryName', salesLi.CPQ_Sales_Item__r.NokiaCPQ_Item_Type__c); 
					//ended here
		  gen.writeStringField('NPTR_SI_NLP', '1'); 
					//gen.writeStringField('NPTR_SI_CLP', '1');

					
					gen.writeNullField('NPTR_SI_NLP_Discount'); 
					gen.writeStringField('NPTR_SI_NLP_SalesMargin', '1'); 
					gen.writeStringField('NPTR_SI_Info',salesLi.ID);
					//gen.writeNumberField('NPTR_SI_IRP',irpPrice); //added,  removed 0 
					gen.writeNumberField('NPTR_SI_IRP',0);
					
					if(mapStaticProductCodeToPrice.containskey(salesLi.CPQ_Sales_Item__r.productCode) && mapStaticProductCodeToPrice.get(salesLi.CPQ_Sales_Item__r.productCode) != null ){
					   
						 decimal cplVlaueSttaic = 0;
						 cplVlaueSttaic  =mapStaticProductCodeToPrice.get(salesLi.CPQ_Sales_Item__r.productCode) - (mapStaticProductCodeToPrice.get(salesLi.CPQ_Sales_Item__r.productCode) * (accrediDisc/100));
						 if(incoterm == null)
						{
							incoterm = 0.0;
						} 
			 cplVlaueSttaic = cplVlaueSttaic + (cplVlaueSttaic* (incoterm/100));
						gen.writeNumberField('NPTR_SI_CLP',cplVlaueSttaic.setScale(2));
						gen.writeNumberField('NPTR_SI_ELP',cplVlaueSttaic.setScale(2));
						}
					else
					{
						gen.writeNumberField('NPTR_SI_CLP',0);
						gen.writeNumberField('NPTR_SI_ELP',0);
					}
				   // gen.writeNumberField('NPTR_SI_ELP',0);   //added, not working same as above 
					gen.writeStringField('NPTR_SI_IRP_Discount','0');
					gen.writeEndObject();
					gen.writeEndObject();
					m++;
					siPosition++;
				}
			}
		}
		gen.writeEndArray();
		gen.writeEndObject();
		//ConfUnit
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_CONFUNITS_STORE');
		gen.writeFieldName('References');
		gen.writeStartObject();
		gen.writeFieldName('RecordID');
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_HEADERS_STORE');
		gen.writeStringField('OutputName', 'RecordID');
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeFieldName('Entities');
		gen.writeStartArray();
		integer n = 1;
		integer o = 1;
		string cuDescription = 'CU Description';
		for(string portfolio : finalportfolioPackageCode){
			o = 1;
			if(PortfoliopackageTogroup.containskey(portfolio)){
				for(Apttus_Config2__LineItem__c groupLi : PortfoliopackageTogroup.get(portfolio)){
					/*if(PortfoliopackageToBundle.containskey(portfolio)){
					for(Apttus_Config2__LineItem__c bundleLi : PortfoliopackageToBundle.get(portfolio)){*/
					if(groupLi.NokiaCPQ_Alias__c != null){
						cuDescription = groupLi.NokiaCPQ_Product_Description__c + ' ' + groupLi.NokiaCPQ_Alias__c;
					}
					else{
						cuDescription = groupLi.NokiaCPQ_Product_Description__c;
					}
					gen.writeStartObject();
					gen.writeFieldName('Parameters');
					gen.writeStartObject();
					gen.writeNumberField('NPTR_CU_Id', n);
					gen.writeNumberField('NPTR_CU_SheetId', portfoliotoSheetID.get(portfolio));
					gen.writeNumberField('NPTR_CU_Position', o);
					gen.writeStringField('NPTR_CU_Name', cuDescription);
					gen.writeStringField('NPTR_CU_Description', cuDescription);
					gen.writeEndObject();
					gen.writeEndObject();
					system.debug('n->'+n);
					system.debug('PortfoliopackageToDynamicBundle: '+groupLi+ ' n= ' +n);
					confUnitToLineNumber.put(portfolio + '_'+ groupLi.Apttus_Config2__PrimaryLineNumber__c, n); 
					o++;
					n++;
				}
			}
			system.debug('confUnitToLineNumber : '+ confUnitToLineNumber);
			if(PortfoliopackageToStaticGroup.containskey(portfolio)){
				for(string groupLi : PortfoliopackageToStaticGroup.get(portfolio)){
			
			/*if(portfoliopackageToStaticBundle.containskey(portfolio)){
				for(string bundleLi : portfoliopackageToStaticBundle.get(portfolio)){*/
					cuDescription = groupLi;
					gen.writeStartObject();
					gen.writeFieldName('Parameters');
					gen.writeStartObject();
					gen.writeNumberField('NPTR_CU_Id', n);
					gen.writeNumberField('NPTR_CU_SheetId', portfoliotoSheetID.get(portfolio));
					gen.writeNumberField('NPTR_CU_Position', o);
					gen.writeStringField('NPTR_CU_Name', cuDescription);
					gen.writeStringField('NPTR_CU_Description', cuDescription);
					gen.writeEndObject();
					gen.writeEndObject();
					system.debug('portfoliopackageToStaticBundle: '+groupLi+ '-' +n+ '-' +portfolio);
					confUnitIdStaticMap.put(portfolio+'_'+groupLi, n);   
					o++;
					n++;
				}
			}
		}
		gen.writeEndArray();
		gen.writeEndObject();
		// Incoterm Source
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_ICSRC_STORE');
		gen.writeFieldName('References');
		gen.writeStartObject();
		gen.writeFieldName('RecordID');
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_HEADERS_STORE');
		gen.writeStringField('OutputName', 'RecordID');
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeFieldName('Entities');
		gen.writeStartArray();	
		gen.writeEndArray();
		gen.writeEndObject();
		// Sheet Discount
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_SHEETDISCOUNTS_STORE');
		gen.writeFieldName('References');
		gen.writeStartObject();
		gen.writeFieldName('RecordID');
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_HEADERS_STORE');
		gen.writeStringField('OutputName', 'RecordID');
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeFieldName('Entities');
		gen.writeStartArray();	
		// details to be added  later
		gen.writeEndArray();
		gen.writeEndObject();
		// Sheet setting
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_SHEETSETTINGS_STORE');
		gen.writeFieldName('References');
		gen.writeStartObject();
		gen.writeFieldName('RecordID');
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_HEADERS_STORE');
		gen.writeStringField('OutputName', 'RecordID');
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeFieldName('Entities');
		gen.writeStartArray();	
		// details to be added  later
		gen.writeEndArray();
		gen.writeEndObject();
		//SALESITEM PHASES
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_SALESITEMPHASES_STORE');
		gen.writeFieldName('References');
		gen.writeStartObject();
		gen.writeFieldName('RecordID');
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_HEADERS_STORE');
		gen.writeStringField('OutputName', 'RecordID');
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeFieldName('Entities');
		gen.writeStartArray();	
		// details to be added  later
		gen.writeEndArray();
		gen.writeEndObject();
		// DELIVERY PHASES
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_DELIVERYPHASES_STORE');
		gen.writeFieldName('References');
		gen.writeStartObject();
		gen.writeFieldName('RecordID');
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_HEADERS_STORE');
		gen.writeStringField('OutputName', 'RecordID');
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeFieldName('Entities');
		gen.writeStartArray();	
		// details to be added  later
		gen.writeEndArray();
		gen.writeEndObject();
		//Conf Phase
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_CONFPHASES_STORE');
		gen.writeFieldName('References');
		gen.writeStartObject();
		gen.writeFieldName('RecordID');
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_HEADERS_STORE');
		gen.writeStringField('OutputName', 'RecordID');
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeFieldName('Entities');
		gen.writeStartArray();
		for(string portfolio : finalportfolioPackageCode){
			
			if(PortfoliopackageTogroup.containskey(portfolio)){
				for(Apttus_Config2__LineItem__c groupLi : PortfoliopackageTogroup.get(portfolio)){
		   /* if(PortfoliopackageToBundle.containskey(portfolio)){  
				for(Apttus_Config2__LineItem__c bundleLi : PortfoliopackageToBundle.get(portfolio)){*/
					gen.writeStartObject();
					gen.writeFieldName('Parameters');
					gen.writeStartObject();
					if(confUnitToLineNumber.containskey(portfolio+'_'+groupLi.Apttus_Config2__PrimaryLineNumber__c)){
						system.debug('confUnitToLineNumber : '+ confUnitToLineNumber);
						system.debug('Condigr id :'+ confUnitToLineNumber.get(portfolio+'_'+groupLi.Apttus_Config2__PrimaryLineNumber__c));
						gen.writeNumberField('NPTR_CP_ConfUnitId', confUnitToLineNumber.get(portfolio+'_'+groupLi.Apttus_Config2__PrimaryLineNumber__c));
					
					}
					gen.writeNumberField('NPTR_CP_PhaseId', 1);
					gen.writeNumberField('NPTR_CP_QTY', groupLi.Apttus_Config2__Quantity__c);
					gen.writeEndObject();
					gen.writeEndObject();
					
				}
			}
			
			if(PortfoliopackageToStaticGroup.containskey(portfolio)){
				for(string groupLi : PortfoliopackageToStaticGroup.get(portfolio)){
			
			/*if(portfoliopackageToStaticBundle.containskey(portfolio)){	
				for(string bundleLi : portfoliopackageToStaticBundle.get(portfolio)){*/
					gen.writeStartObject();
					gen.writeFieldName('Parameters');
					gen.writeStartObject();
					
					gen.writeNumberField('NPTR_CP_ConfUnitId', confUnitIdStaticMap.get(portfolio+'_'+groupLi)); 
					gen.writeNumberField('NPTR_CP_PhaseId', 1);
					if(mapgroupCodeToQuantity.containsKey(groupLi) && mapgroupCodeToQuantity.get(groupLi) != null){  
						gen.writeNumberField('NPTR_CP_QTY', mapgroupCodeToQuantity.get(groupLi));}
					else{
						gen.writeNumberField('NPTR_CP_QTY', 1);
					}
					gen.writeEndObject();
					gen.writeEndObject();
				}
			}
		}

		gen.writeEndArray();
		gen.writeEndObject();
		//Config SalesItems
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_CONFITEMS_STORE');
		gen.writeFieldName('References');
		gen.writeStartObject();
		gen.writeFieldName('RecordID');
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_HEADERS_STORE');
		gen.writeStringField('OutputName', 'RecordID');
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeFieldName('Entities');
		gen.writeStartArray();
		Integer l = 1;
		m = 1;
		decimal groupQnt =1;
		for(string portfolio : finalportfolioPackageCode){
			if(portfoliopackageToLines.containskey(portfolio)){
				for(Apttus_Config2__LineItem__c salesLi : portfoliopackageToLines.get(portfolio)){
					gen.writeStartObject();
					gen.writeFieldName('Parameters');
					gen.writeStartObject();
					gen.writeNumberField('NPTR_CI_SalesItemId', m);
					/*if(standalonToCUID.containskey(salesLi.Apttus_Config2__PrimaryLineNumber__c)){
						gen.writeNumberField('NPTR_CI_ConfUnitId', standalonToCUID.get(salesLi.Apttus_Config2__PrimaryLineNumber__c));
					}
					else{
						gen.writeNumberField('NPTR_CI_ConfUnitId', l);
					}*/
					//to be update
					
					if(confUnitToLineNumber.containskey(portfolio+'_'+salesLi.Apttus_Config2__ParentBundleNumber__c) && confUnitToLineNumber.get(portfolio+'_'+salesLi.Apttus_Config2__ParentBundleNumber__c) != Null)
					{
					gen.writeNumberField('NPTR_CI_ConfUnitId', confUnitToLineNumber.get(portfolio+'_'+salesLi.Apttus_Config2__ParentBundleNumber__c));
					}
					//gen.writeNumberField('NPTR_CI_ConfUnitId', l);
					if(PortfoliopackageTogroup.get(portfolio).contains(primaryLineNum.get(salesLi.Apttus_Config2__ParentBundleNumber__c))){
						groupQnt = primaryLineNum.get(salesLi.Apttus_Config2__ParentBundleNumber__c).Apttus_Config2__Quantity__c;
					}
					gen.writeStringField('NPTR_CI_QTY', string.valueof(salesLi.Apttus_Config2__Quantity__c));
					gen.writeEndObject();
					gen.writeEndObject();
					m++;
				}
			}
			l++;
			if(portfoliopackageToStaticLines.containskey(portfolio)){
				for(CPQ_MPW_Bundle__c salesLi : portfoliopackageToStaticLines.get(portfolio)){
					gen.writeStartObject();
					gen.writeFieldName('Parameters');
					gen.writeStartObject();
					gen.writeNumberField('NPTR_CI_SalesItemId', m);
					
					gen.writeNumberField('NPTR_CI_ConfUnitId', confUnitIdStaticMap.get(portfolio+'_'+salesLi.CPQ_Bundle__r.ProductCode));
					//gen.writeNumberField('NPTR_CI_ConfUnitId', l);
					groupQnt = 1;
					gen.writeStringField('NPTR_CI_QTY', string.valueof(salesLi.CPQ_Quantity__c));
					gen.writeEndObject();
					gen.writeEndObject();
					m++;
				}
			}
			l++;
		}
		gen.writeEndArray();
		gen.writeEndObject();
		gen.writeEndArray();
		gen.writeEndObject();
		String jsonString = gen.getAsString();
		system.debug('JSON String : '+ jsonString);
		return jsonString;
	}
	/****************************************
	
	***********************************************/

	public string getNPTBomRequestBody_MW(string CartID) {
		map<Decimal, Apttus_Config2__LineItem__c> primaryLineNum = new map<Decimal, Apttus_Config2__LineItem__c>();

		map<Decimal, integer> spareToCUID = new map<Decimal, integer>();
		list<string> portfolioPackageCode = new list<string>();
		list<string> finalportfolioPackageCode = new list<string>();

		map<string, list<Apttus_Config2__LineItem__c>> portfoliopackageToLines = new map<string, list<Apttus_Config2__LineItem__c>>();
		map<string, list<Apttus_Config2__LineItem__c>> portfolioPackageToStandalone = new map<string, list<Apttus_Config2__LineItem__c>>();
		map<string, list<Apttus_Config2__LineItem__c>> portfolioPackageToSpare = new map<string, list<Apttus_Config2__LineItem__c>>();
		map<string, integer> portfolioToSheetID = new map<string, integer>();
		map<Decimal, integer> confUnitToLineNumber = new map<Decimal, integer>();
		map<Decimal, Decimal> confUnitToQty = new map<Decimal, Decimal>();
		map<Decimal,string> lineToCapacityUnit = new map<Decimal,string>();

		map<string,string> mapSiteqty = new map<string,string>();
		map<id, list<string>> mapLineSite = new map<id, list<string>>();
		map<string, set <string>> portfoliopackageToSite = new map<string, set <string>>();
		map<string, Integer> mapConfUnitToSiteLine = new map<string, Integer>();
		map<Id, Integer> mapSLIToSIID = new map<Id, Integer>();
		map<Id, Integer> mapspareLIToSIID = new map<Id, Integer>();
		map<string, Integer> portfolioPackageToSiteQty = new map<string, Integer>();
		map<string, integer> mapdisStoreTodisId = new map<string, integer>();
		CurrencyType exchangeRateRec = new CurrencyType();
		decimal exchangeRate = 1;

		//7346  - added by Standav
		Map<String,Apttus_Config2__LineItem__c> mapMaintenanceLine = new Map<String,Apttus_Config2__LineItem__c>();
		
		Set<String> maintenanceLineSet = new set<String>{Nokia_CPQ_Constants.MAINTY1CODE,Nokia_CPQ_Constants.MAINTY2CODE};
		
	   string userName = UserInfo.getName();
		//7346 - added Apttus_Config2__BasePrice__c,NokiaCPQ_Product_Name__c fields by Standav
		list<Apttus_Config2__LineItem__c> allLineItems = [Select id, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ProductId__c,
			Apttus_Config2__OptionId__c, Apttus_Config2__LineNumber__c,
			Apttus_Config2__PrimaryLineNumber__c, Apttus_Config2__ParentBundleNumber__c,
			Apttus_Config2__LineType__c, NokiaCPQ_Configuration_Type__c,
			NokiaCPQ_Part_Number__c, NokiaCPQ_Product_Description__c,
			NokiaCPQ_Unitary_Cost__c, NokiaCPQ_Alias__c,
			Apttus_Config2__Quantity__c, Item_Type__c, CurrencyIsoCode,
			Apttus_Config2__ProductId__r.NokiaCPQ_Portfolio_Package_Code__c,
			Apttus_Config2__OptionId__r.NokiaCPQ_Portfolio_Package_Code__c,
			Apttus_Config2__OptionId__r.ProductCode,
			Apttus_Config2__ProductId__r.CPQ_NPT_SI_TYPE__c, Apttus_Config2__ProductId__r.GIC__c,
			Apttus_Config2__ProductId__r.Capacity__c, Apttus_Config2__OptionId__r.Capacity__c,
			Apttus_Config2__ProductId__r.Business_Group__c, Apttus_Config2__OptionId__r.Business_Group__c, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__c,
			Apttus_Config2__ProductId__r.NokiaCPQ_Business_Line__r.name, Apttus_Config2__OptionId__r.NokiaCPQ_Business_Line__r.name,
			NokiaCPQ_Opportunity_Name__c, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Opportunity_ID__c,
			Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.NokiaCPQ_Proposal_Id__c, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Offer__c,
			NokiaCPQ_Unitary_IRPrice__c, NokiaCPQ_IRP_Discount__c, NokiaCPQ_Partner_Price__c, NokiaCPQ_Spare__c, EPT_Sites__c, EPT_Site_Quantity__c,Apttus_Config2__BasePrice__c,NokiaCPQ_Product_Name__c,
			Apttus_Config2__ProductId__r.ProductCode 
			from Apttus_Config2__LineItem__c
			where Apttus_Config2__ConfigurationId__c =: CartID and NokiaCPQ_Configuration_Type__c != 'Bundle'
		];
		System.debug(allLineItems[0].NokiaCPQ_Part_Number__c+'allLineItems--:'+allLineItems.size());
	   string oppty = allLineItems[0].Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Opportunity_ID__c;
		system.debug('oppty Id: ' + oppty);
		list<Offer__C> offer = [select id, name, Offer_Number__c from offer__c where Opportunity__c =: allLineItems[0].Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__c and ActiveOffer__c = true limit 1];

	   string offerId;
		If(!offer.isEmpty()) {
			offerId = offer[0].Offer_Number__c;
		}
		system.debug('Offer Id: ' + offerId);

		Id quoteId = allLineItems[0].Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c;
		//7346 - few fields added by Standav
		Apttus_Proposal__Proposal__c quoteRec = [select id, name, NokiaCPQ_Quote_CAD__c, NokiaCPQ_Quote_DOD__c, NokiaCPQ_Quote_DPD__c, NokiaCPQ_No_of_Years__c,
												 CurrencyIsoCode,NokiaCPQ_Maintenance_Type__c,NokiaCPQ_Maintenance_Pricing_Cluster__c 
												 from Apttus_Proposal__Proposal__c where id =: quoteId];

		// Currency conversion
	   string quotecurrency = quoteRec.CurrencyIsoCode;
		exchangeRateRec = [select id, ConversionRate, IsoCode from CurrencyType where IsoCode =: quoteRec.CurrencyIsoCode AND IsActive = true limit 1];
		if (exchangeRateRec != Null) {
			exchangeRate = exchangeRateRec.ConversionRate;
		}
		//7346 - added by Standav - START
		List<Maintenance_SSP_Product__c> lstMasterRecords;
		if (string.isNotBlank(quoteRec.NokiaCPQ_Maintenance_Pricing_Cluster__c)){
			string PRICINGCLUSTER = (quoteRec.NokiaCPQ_Maintenance_Pricing_Cluster__c == 'NAM') ? 'NAM': 'ROW';			
		
			lstMasterRecords = [Select Id,Product_Code__c,Package_Code__c,NokiaCPQ_Pricing_Cluster__c,NokiaCPQ_Description__c,NokiaCPQ_Split_Ratio__c 
															  from Maintenance_SSP_Product__c 
															  where NokiaCPQ_Portfolio__c =: Nokia_CPQ_Constants.MICROWAVE_PORTFOLIO 
															  AND NokiaCPQ_Maintenance_Type__c =:quoteRec.NokiaCPQ_Maintenance_Type__c 
															  AND NokiaCPQ_Pricing_Cluster__c =: PRICINGCLUSTER];
		}
		system.debug('lstMasterRecords---->'+lstMasterRecords);
		//7346 - added by Standav - END
			
		
		for (Apttus_Config2__LineItem__c lineitem: allLineItems) {
			system.debug('LineItem:' + lineitem);
			if (lineitem.Apttus_Config2__OptionId__c == null && lineitem.Apttus_Config2__ProductId__r.Capacity__c != null) {
				lineToCapacityUnit.put(lineitem.Apttus_Config2__PrimaryLineNumber__c, lineitem.Apttus_Config2__ProductId__r.Capacity__c);
			}
			list<Apttus_Config2__LineItem__c> linelist = new list<Apttus_Config2__LineItem__c>();
			primaryLineNum.put(lineitem.Apttus_Config2__PrimaryLineNumber__c, lineitem);
			system.debug('NokiaCPQ_Portfolio_Package_Code__c:' + lineitem.Apttus_Config2__ProductId__r.NokiaCPQ_Portfolio_Package_Code__c);
			if ((lineitem.Apttus_Config2__ProductId__r.NokiaCPQ_Portfolio_Package_Code__c) != null) {
				system.debug(' In parent/standalone loop ');
				if (!lineitem.NokiaCPQ_Spare__c) {
					system.debug(' In parent/standalon non spare loop ');
					if (!portfoliopackageToLines.isempty() && portfoliopackageToLines.containsKey(lineitem.Apttus_Config2__ProductId__r.NokiaCPQ_Portfolio_Package_Code__c)) {
						linelist = portfoliopackageToLines.get(lineitem.Apttus_Config2__ProductId__r.NokiaCPQ_Portfolio_Package_Code__c);
					}
					linelist.add(lineitem);
					portfoliopackageToLines.put(lineitem.Apttus_Config2__ProductId__r.NokiaCPQ_Portfolio_Package_Code__c, linelist);
					if (!portfolioPackageCode.contains(lineitem.Apttus_Config2__ProductId__r.NokiaCPQ_Portfolio_Package_Code__c)) {
						portfolioPackageCode.add(lineitem.Apttus_Config2__ProductId__r.NokiaCPQ_Portfolio_Package_Code__c);
					}
				} else {
					system.debug(' In option arent/standalon  spare loop ');
					if (!portfolioPackageToSpare.isempty() && portfolioPackageToSpare.containsKey(lineitem.Apttus_Config2__ProductId__r.NokiaCPQ_Portfolio_Package_Code__c)) {
						linelist = portfolioPackageToSpare.get(lineitem.Apttus_Config2__ProductId__r.NokiaCPQ_Portfolio_Package_Code__c);
					}
					linelist.add(lineitem);
					portfolioPackageToSpare.put(lineitem.Apttus_Config2__ProductId__r.NokiaCPQ_Portfolio_Package_Code__c, linelist);
					if (!portfolioPackageCode.contains(lineitem.Apttus_Config2__ProductId__r.NokiaCPQ_Portfolio_Package_Code__c)) {
						portfolioPackageCode.add(lineitem.Apttus_Config2__ProductId__r.NokiaCPQ_Portfolio_Package_Code__c);
					}
				}
			}else if(maintenanceLineSet.contains(lineitem.Apttus_Config2__ProductId__r.ProductCode)){				
				
				mapMaintenanceLine.put(lineitem.Apttus_Config2__ProductId__r.ProductCode,lineitem);				
				
			}
			//MW
			set <string> siteSet = new set <string>();
			list<string> site_list;
			list<string> site_qty;
			If(lineitem.EPT_Sites__c != null && lineitem.EPT_Site_Quantity__c != null) {
				site_List = lineitem.EPT_Sites__c.split(GlobalConstants.COMMAS);
				site_qty = lineitem.EPT_Site_Quantity__c.split(GlobalConstants.COMMAS);
			}
			if (site_List != null && site_List.size()> 0) {
				for (integer i = 0; i < site_list.size(); i++) {
					system.debug('In Site Loop');
					mapSiteqty.put(lineitem.Id + '_' + site_List[i], site_qty[i]);
					if (!portfolioPackageToSiteQty.isEmpty() && portfolioPackageToSiteQty.containskey(lineitem.Apttus_Config2__ProductId__r.NokiaCPQ_Portfolio_Package_Code__c + '_' + site_List[i])) {
						Integer getqty = portfolioPackageToSiteQty.get(lineitem.Apttus_Config2__ProductId__r.NokiaCPQ_Portfolio_Package_Code__c + '_' + site_List[i]);
						portfolioPackageToSiteQty.put(lineitem.Apttus_Config2__ProductId__r.NokiaCPQ_Portfolio_Package_Code__c + '_' + site_List[i], getqty + Integer.valueOf(site_qty[i]));
					} else {
						portfolioPackageToSiteQty.put(lineitem.Apttus_Config2__ProductId__r.NokiaCPQ_Portfolio_Package_Code__c + '_' + site_List[i], Integer.valueOf(site_qty[i]));
					}
				}
				mapLineSite.put(lineitem.Id, Site_List);
				if (!portfoliopackageToSite.isEmpty() && lineitem.Apttus_Config2__ProductId__r.NokiaCPQ_Portfolio_Package_Code__c != null && portfoliopackageToSite.containskey(lineitem.Apttus_Config2__ProductId__r.NokiaCPQ_Portfolio_Package_Code__c)) {
					set <string> getSite = portfoliopackageToSite.get(lineitem.Apttus_Config2__ProductId__r.NokiaCPQ_Portfolio_Package_Code__c);
					for (string addsite: site_list) {
						getsite.add(addsite);
					}
					portfoliopackageToSite.put(lineitem.Apttus_Config2__ProductId__r.NokiaCPQ_Portfolio_Package_Code__c, getSite);
				} else if (lineitem.Apttus_Config2__ProductId__r.NokiaCPQ_Portfolio_Package_Code__c != null) {
					siteSet.addall(site_List);
					portfoliopackageToSite.put(lineitem.Apttus_Config2__ProductId__r.NokiaCPQ_Portfolio_Package_Code__c, siteSet);
				}
			}

		}
		
		finalportfolioPackageCode.addall(portfolioPackageCode);
		system.debug('finalportfolioPackageCode:' + finalportfolioPackageCode);
		system.debug('portfolio package code set : ' + portfolioPackageCode);
		system.debug(' portfoliopackageToLines : ' + portfoliopackageToLines);
		system.debug('portfolioPackageToSiteQty:' + portfolioPackageToSiteQty);
		system.debug('portfolioPackageToSite:' + portfolioPackageToSite);
		for (string portfolioPackgae: portfoliopackageToLines.keyset()) {

			for (Apttus_Config2__LineItem__c packageLines: portfoliopackageToLines.get(portfolioPackgae)) {
				list<Apttus_Config2__LineItem__c> standalonLI = new list<Apttus_Config2__LineItem__c>();
				if (portfolioPackageToStandalone.containskey(portfolioPackgae)) {
					standalonLI = portfolioPackageToStandalone.get(portfolioPackgae);
				}
				standalonLI.add(packageLines);
				portfolioPackageToStandalone.put(portfolioPackgae, standalonLI);
			}
		}
		/***** ----------JSON Build ------------ *******/
		JSONGenerator gen = JSON.createGenerator(true);
		gen.writeStartObject();
		gen.writeFieldName('Data');
		gen.writeStartArray();
		//Header
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_HEADERS_STORE');
		gen.writeFieldName('Entities');
		gen.writeStartArray();
		gen.writeStartObject();
		gen.writeFieldName('Parameters');
		gen.writeStartObject();
		gen.writeStringField('NPTR_H_OpportunityId', oppty);
		gen.writeStringField('NPTR_H_OfferId', offerId);
		gen.writeStringField('NPTR_H_Author', userName);
		gen.writeStringField('NPTR_H_Year1Indicator', '2020');

		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeEndArray();
		gen.writeEndObject();
		//Scenario
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_SCENARIOS_STORE');
		gen.writeFieldName('References');
		gen.writeStartObject();
		gen.writeFieldName('RecordID');
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_HEADERS_STORE');
		gen.writeStringField('OutputName', 'RecordID');
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeFieldName('Entities');
		gen.writeStartArray();
		gen.writeStartObject();
		gen.writeFieldName('Parameters');
		gen.writeStartObject();
		gen.writeStringField('NPTR_SC_ScenarioId', '1');
		gen.writeStringField('NPTR_SC_Name', Nokia_CPQ_Constants.NPT_Region);
		gen.writeStringField('NPTR_SC_ScenarioDescription', Nokia_CPQ_Constants.NPT_Region);
		gen.writeBooleanField('NPTR_SC_SCActive', true);
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeEndArray();
		gen.writeEndObject();
		//Phase
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_PHASES_STORE');
		gen.writeFieldName('References');
		gen.writeStartObject();
		gen.writeFieldName('RecordID');
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_HEADERS_STORE');
		gen.writeStringField('OutputName', 'RecordID');
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeFieldName('Entities');
		gen.writeStartArray();
		//7346 - added by Standav Part 5_START

		if(quoteRec.NokiaCPQ_No_of_Years__c != null){	   
			for(Integer k=1;k<=integer.valueof(quoteRec.NokiaCPQ_No_of_Years__c);k++){
				gen.writeStartObject();
				gen.writeFieldName('Parameters');
				gen.writeStartObject();
				gen.writeStringField('NPTR_PH_Id', string.valueof(k));
				gen.writeStringField('NPTR_PH_Name', 'Phase '+k);
				if(k==1){
					gen.writeDateField('NPTR_PH_StartDate', System.today());
				}
				else{				   
					
					Integer currYear = Integer.valueof(System.today().year());
					Date nextYear = Date.newInstance(currYear,1,1).addYears(k-1);
					gen.writeDateField('NPTR_PH_StartDate', nextYear);
					
				}				
				gen.writeStringField('NPTR_PH_Description', 'Phase '+k);
				gen.writeBooleanField('NPTR_PH_Active', true);
				gen.writeBooleanField('NPTR_PH_SelectedForLoA', true);
				gen.writeEndObject();
				
				gen.writeEndObject();
			}
		}
		//7346 - added by Standav Part 5_END
		gen.writeEndArray();
		gen.writeEndObject();
		//sheet
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_SHEETS_STORE');
		gen.writeFieldName('References');
		gen.writeStartObject();
		gen.writeFieldName('RecordID');
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_HEADERS_STORE');
		gen.writeStringField('OutputName', 'RecordID');
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeFieldName('Entities');
		gen.writeStartArray();
		integer i = 1;
		for (string portfolio: finalportfolioPackageCode) {
			gen.writeStartObject();
			gen.writeFieldName('Parameters');
			gen.writeStartObject();
			gen.writeNumberField('NPTR_SH_Id', i);
			gen.writeStringField('NPTR_SH_Name', portfolio);

			gen.writeStringField('NPTR_SH_PortfolioPackage', portfolio);
			gen.writeBooleanField('NPTR_SH_Active', true);
			gen.writeNullField('NPTR_SH_SolutionAreaId');
			gen.writeStringField('NPTR_SH_ScenarioId', '1');
			gen.writeStringField('NPTR_SH_Contract_Currency', quotecurrency);
			gen.writeNumberField('NPTR_SH_Contract_ExchangeRate', exchangeRate);
			gen.writeStringField('NPTR_SH_Internal_Currency', quotecurrency);
			gen.writeNumberField('NPTR_SH_Internal_ExchangeRate', exchangeRate);
			gen.writeStringField('NPTR_SH_Local_Currency', quotecurrency);
			gen.writeNumberField('NPTR_SH_Local_ExchangeRate', exchangeRate);
			gen.writeStringField('NPTR_SH_IRP_Currency', quotecurrency);
			gen.writeNumberField('NPTR_SH_IRP_ExchangeRate', exchangeRate);
			gen.writeStringField('NPTR_SH_ELP_Currency', quotecurrency);
			gen.writeNumberField('NPTR_SH_ELP_ExchangeRate', exchangeRate);
			gen.writeStringField('NPTR_SH_NLP_Currency', quotecurrency);
			gen.writeNumberField('NPTR_SH_NLP_ExchangeRate', exchangeRate);
			gen.writeStringField('NPTR_SH_CLP_Currency', quotecurrency);
			gen.writeNumberField('NPTR_SH_CLP_ExchangeRate', exchangeRate);
			gen.writeStringField('NPTR_SH_Eost_Currency', quotecurrency);
			gen.writeNumberField('NPTR_SH_Eost_ExchangeRate', exchangeRate);
			gen.writeStringField('NPTR_SH_Cost_Currency', quotecurrency);
			gen.writeNumberField('NPTR_SH_Cost_ExchangeRate', exchangeRate);
			gen.writeStringField('NPTR_SH_IRP_Incoterm', 'FCA');
			gen.writeStringField('NPTR_SH_ELP_Incoterm', 'FCA');
			gen.writeStringField('NPTR_SH_Eost_Incoterm', 'FCA');
			gen.writeStringField('NPTR_SH_NLP_Incoterm', 'FCA');
			gen.writeStringField('NPTR_SH_BenchmarkCategory', '>>> Please Select');
			gen.writeNumberField('NPTR_SH_CInternal2ContractExRate', exchangeRate);
			gen.writeNumberField('NPTR_SH_CInternal2LocalExRate', exchangeRate);
			gen.writeNumberField('NPTR_SH_PInternal2ContractExRate', exchangeRate);
			gen.writeNumberField('NPTR_SH_PInternal2LocalExRate', exchangeRate);
			gen.writeStringField('NPTR_SH_ShowOverrides', '0');
			gen.writeStringField('NPTR_SH_PPSelection', '7');
			gen.writeStringField('NPTR_SH_LoAScenario', 'New Installation');
			gen.writeStringField('NPTR_SH_ScenarioId', '1');
			gen.writeEndObject();
			gen.writeEndObject();
			portfolioToSheetID.put(portfolio, i);
			i++;
		}
		gen.writeEndArray();
		gen.writeEndObject();
		//Discount Activity Store
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_DISCOUNTSACTIVITY_STORE');
		gen.writeFieldName('References');
		gen.writeStartObject();
		gen.writeFieldName('RecordID');
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_HEADERS_STORE');
		gen.writeStringField('OutputName', 'RecordID');
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeFieldName('Entities');
		gen.writeStartArray();
		setDiscountActivityStore(gen, '1', Nokia_CPQ_Constants.NPT_discountFoC, false);
		if ((quoteRec.NokiaCPQ_Quote_DOD__c != Null && quoteRec.NokiaCPQ_Quote_DOD__c != 0) || (quoteRec.NokiaCPQ_Quote_DPD__c != Null && quoteRec.NokiaCPQ_Quote_DPD__c != 0)) {
			setDiscountActivityStore(gen, '2', Nokia_CPQ_Constants.NPT_discountVol, true);
		} else {
			setDiscountActivityStore(gen, '2', Nokia_CPQ_Constants.NPT_discountVol, false);
		}
		setDiscountActivityStore(gen, '3', Nokia_CPQ_Constants.NPT_discountPE, false);
		if (quoteRec.NokiaCPQ_Quote_CAD__c != Null && quoteRec.NokiaCPQ_Quote_CAD__c != 0) {
			setDiscountActivityStore(gen, '4', Nokia_CPQ_Constants.NPT_discountLSD, true);
		} else {
			setDiscountActivityStore(gen, '4', Nokia_CPQ_Constants.NPT_discountLSD, false);
		}
		setDiscountActivityStore(gen, '5', Nokia_CPQ_Constants.NPT_discountPSD, false);
		setDiscountActivityStore(gen, '6', Nokia_CPQ_Constants.NPT_discountRfS, false);
		setDiscountActivityStore(gen, '7', Nokia_CPQ_Constants.NPT_discountFL, false);
		setDiscountActivityStore(gen, '8', Nokia_CPQ_Constants.NPT_discountCE, false);
		setDiscountActivityStore(gen, '9', Nokia_CPQ_Constants.NPT_discountRfC, false);
		setDiscountActivityStore(gen, '10', Nokia_CPQ_Constants.NPT_discountTCD, false);
		setDiscountActivityStore(gen, '11', Nokia_CPQ_Constants.NPT_discountSF, false);
		setDiscountActivityStore(gen, '12', Nokia_CPQ_Constants.NPT_discountTFC, false);
		setDiscountActivityStore(gen, '13', Nokia_CPQ_Constants.NPT_discountVA, false);
		setDiscountActivityStore(gen, '14', Nokia_CPQ_Constants.NPT_discountCA, false);

		gen.writeEndArray();
		gen.writeEndObject();

		//Discountstore
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_DISCOUNTS_STORE');
		gen.writeFieldName('References');
		gen.writeStartObject();
		gen.writeFieldName('RecordID');
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_HEADERS_STORE');
		gen.writeStringField('OutputName', 'RecordID');
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeFieldName('Entities');
		gen.writeStartArray();
		integer disId = 1;
		//CAD
		if (quoteRec.NokiaCPQ_Quote_CAD__c != Null && quoteRec.NokiaCPQ_Quote_CAD__c != 0) {
			gen.writeStartObject();
			gen.writeFieldName('Parameters');
			gen.writeStartObject();
			gen.writeNumberField('NPTR_DS_Id', disId);
			gen.writeStringField('NPTR_DS_Name', 'CAD(Competitive Additional Discount)');
			gen.writeStringField('NPTR_DS_Group', 'C');
			gen.writeStringField('NPTR_DS_GroupName', 'C. One-Off Discounts (CUP -> CNP)');
			gen.writeStringField('NPTR_DS_Subgroup', 'C.1');
			gen.writeStringField('NPTR_DS_SubgroupName', 'C.1. Lump Sum Discounts');
			gen.writeStringField('NPTR_DS_LevelId', '2');
			gen.writeStringField('NPTR_DS_LevelName', 'CNP');
			gen.writeStringField('NPTR_DS_BusinessGroup', 'All');
			gen.writeStringField('NPTR_DS_BusinessLine', 'All');
			gen.writeStringField('NPTR_DS_PortfolioPackage', 'All');
			gen.writeStringField('NPTR_DS_CategoryId', '1');
			gen.writeStringField('NPTR_DS_CategoryName', 'All');
			gen.writeStringField('NPTR_DS_ClassId', '1');
			gen.writeStringField('NPTR_DS_ClassName', 'All');
			gen.writeStringField('NPTR_DS_Behaviour', 'one-off');
			gen.writeStringField('NPTR_DS_DiscountNumberOfRows', '5');
			gen.writeStringField('NPTR_DS_Position', '107');
			gen.writeEndObject();
			gen.writeEndObject();
			mapdisStoreTodisId.put('CAD', disId);
			disId++;
		}
		//DOD
		if (quoteRec.NokiaCPQ_Quote_DOD__c != Null && quoteRec.NokiaCPQ_Quote_DOD__c != 0) {
			gen.writeStartObject();
			gen.writeFieldName('Parameters');
			gen.writeStartObject();
			gen.writeNumberField('NPTR_DS_Id', disId);
			gen.writeStringField('NPTR_DS_Name', 'DOD(Deal Origination Discount)');
			gen.writeStringField('NPTR_DS_Group', 'B');
			gen.writeStringField('NPTR_DS_GroupName', Nokia_CPQ_Constants.NPT_Discount);
			gen.writeStringField('NPTR_DS_Subgroup', 'B.1');
			gen.writeStringField('NPTR_DS_SubgroupName', Nokia_CPQ_Constants.NPT_VDiscount);
			gen.writeStringField('NPTR_DS_LevelId', '2');
			gen.writeStringField('NPTR_DS_LevelName', 'CUP');
			gen.writeStringField('NPTR_DS_BusinessGroup', 'All');
			gen.writeStringField('NPTR_DS_BusinessLine', 'All');
			gen.writeStringField('NPTR_DS_PortfolioPackage', 'All');
			gen.writeStringField('NPTR_DS_CategoryId', '1');
			gen.writeStringField('NPTR_DS_CategoryName', 'All');
			gen.writeStringField('NPTR_DS_ClassId', '1');
			gen.writeStringField('NPTR_DS_ClassName', 'All');
			gen.writeStringField('NPTR_DS_Behaviour', 'recurring');
			gen.writeStringField('NPTR_DS_DiscountNumberOfRows', '5');
			gen.writeStringField('NPTR_DS_Position', '57');
			gen.writeEndObject();
			gen.writeEndObject();
			mapdisStoreTodisId.put('DOD', disId);
			disId++;
		}
		//DPD
		if (quoteRec.NokiaCPQ_Quote_DPD__c != Null && quoteRec.NokiaCPQ_Quote_DPD__c != 0) {
			gen.writeStartObject();
			gen.writeFieldName('Parameters');
			gen.writeStartObject();
			gen.writeNumberField('NPTR_DS_Id', disId);
			gen.writeStringField('NPTR_DS_Name', 'DPD(Distributor Price Deviation)');
			gen.writeStringField('NPTR_DS_Group', 'B');
			gen.writeStringField('NPTR_DS_GroupName', Nokia_CPQ_Constants.NPT_Discount);
			gen.writeStringField('NPTR_DS_Subgroup', 'B.1');
			gen.writeStringField('NPTR_DS_SubgroupName', Nokia_CPQ_Constants.NPT_VDiscount);
			gen.writeStringField('NPTR_DS_LevelId', '2');
			gen.writeStringField('NPTR_DS_LevelName', 'CUP');
			gen.writeStringField('NPTR_DS_BusinessGroup', 'All');
			gen.writeStringField('NPTR_DS_BusinessLine', 'All');
			gen.writeStringField('NPTR_DS_PortfolioPackage', 'All');
			gen.writeStringField('NPTR_DS_CategoryId', '1');
			gen.writeStringField('NPTR_DS_CategoryName', 'All');
			gen.writeStringField('NPTR_DS_ClassId', '1');
			gen.writeStringField('NPTR_DS_ClassName', 'All');
			gen.writeStringField('NPTR_DS_Behaviour', 'recurring');
			gen.writeStringField('NPTR_DS_DiscountNumberOfRows', '5');
			gen.writeStringField('NPTR_DS_Position', '63');
			gen.writeEndObject();
			gen.writeEndObject();
			mapdisStoreTodisId.put('DPD', disId);
		}
		gen.writeEndArray();
		gen.writeEndObject();
		//DiscuntValues
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_DISCOUNTVALUES_STORE');
		gen.writeFieldName('References');
		gen.writeStartObject();
		gen.writeFieldName('RecordID');
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_HEADERS_STORE');
		gen.writeStringField('OutputName', 'RecordID');
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeFieldName('Entities');
		gen.writeStartArray();
		//CAD
		if (quoteRec.NokiaCPQ_Quote_CAD__c != Null && quoteRec.NokiaCPQ_Quote_CAD__c != 0) {
			gen.writeStartObject();
			gen.writeFieldName('Parameters');
			gen.writeStartObject();
			gen.writeNumberField('NPTR_DV_DiscountId', mapdisStoreTodisId.get('CAD'));
			gen.writeNumberField('NPTR_DV_PhaseId', 1);
			gen.writeStringField('NPTR_DV_Percentage', '0');
			gen.writeStringField('NPTR_DV_Factor', '1');
			//Modified by sunidhar, Converting discounts to EUR value
			if(exchangeRate != null && exchangeRate != 0) {
	gen.writeNumberField('NPTR_DV_DiscountAmount', quoteRec.NokiaCPQ_Quote_CAD__c/exchangeRate);
			}
			else {
	gen.writeNumberField('NPTR_DV_DiscountAmount', quoteRec.NokiaCPQ_Quote_CAD__c);
			}
			gen.writeStringField('NPTR_DV_DiscountPercentage', '0');
			gen.writeEndObject();
			gen.writeEndObject();
		}
		//DOD
		if (quoteRec.NokiaCPQ_Quote_DOD__c != Null && quoteRec.NokiaCPQ_Quote_DOD__c != 0) {
			gen.writeStartObject();
			gen.writeFieldName('Parameters');
			gen.writeStartObject();
			gen.writeNumberField('NPTR_DV_DiscountId', mapdisStoreTodisId.get('DOD'));
			gen.writeNumberField('NPTR_DV_PhaseId', 1);
			gen.writeStringField('NPTR_DV_Percentage', '0');
			gen.writeStringField('NPTR_DV_Factor', '1');
			//Modified by sunidhar, Converting discounts to EUR value
			if(exchangeRate != null && exchangeRate != 0) {
	gen.writeNumberField('NPTR_DV_DiscountAmount', quoteRec.NokiaCPQ_Quote_DOD__c/exchangeRate);
			}
			else {
	gen.writeNumberField('NPTR_DV_DiscountAmount', quoteRec.NokiaCPQ_Quote_DOD__c);
			}
			gen.writeStringField('NPTR_DV_DiscountPercentage', '0');
			gen.writeEndObject();
			gen.writeEndObject();
		}
		//DPD
		if (quoteRec.NokiaCPQ_Quote_DPD__c != Null && quoteRec.NokiaCPQ_Quote_DPD__c != 0) {
			gen.writeStartObject();
			gen.writeFieldName('Parameters');
			gen.writeStartObject();
			gen.writeNumberField('NPTR_DV_DiscountId', mapdisStoreTodisId.get('DPD'));
			gen.writeNumberField('NPTR_DV_PhaseId', 1);
			gen.writeStringField('NPTR_DV_Percentage', '0');
			gen.writeStringField('NPTR_DV_Factor', '1');
			//Modified by sunidhar, Converting discounts to EUR value
			if(exchangeRate != null && exchangeRate != 0) {
	gen.writeNumberField('NPTR_DV_DiscountAmount', quoteRec.NokiaCPQ_Quote_DPD__c/exchangeRate);
			}
			else {
	gen.writeNumberField('NPTR_DV_DiscountAmount', quoteRec.NokiaCPQ_Quote_DPD__c);
			}
			gen.writeStringField('NPTR_DV_DiscountPercentage', '0');
			gen.writeEndObject();
			gen.writeEndObject();
		}
		gen.writeEndArray();
		gen.writeEndObject();
		//SalesItems
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_SALESITEMS_STORE');
		gen.writeFieldName('References');
		gen.writeStartObject();
		gen.writeFieldName('RecordID');
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_HEADERS_STORE');
		gen.writeStringField('OutputName', 'RecordID');
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeFieldName('Entities');
		gen.writeStartArray();
		integer m = 1;
		for (string portfolio: finalportfolioPackageCode) {
			integer siPosition = 0;
			if (portfoliopackageToLines.containskey(portfolio)) {
				for (Apttus_Config2__LineItem__c salesLi: portfoliopackageToLines.get(portfolio)) {
					system.debug('salesLi:' + salesLi);
					if (!salesLi.NokiaCPQ_Spare__c) {
						siPosition = siPosition + 1;
						gen.writeStartObject();
						gen.writeFieldName('Parameters');
						gen.writeStartObject();
						gen.writeNumberField('NPTR_SI_Id', m);
						gen.writeNumberField('NPTR_SI_SheetId', portfoliotoSheetID.get(portfolio));
						gen.writeNumberField('NPTR_SI_Position', siPosition);
						gen.writeStringField('NPTR_SI_Code', salesLi.NokiaCPQ_Part_Number__c); //??
						gen.writeStringField('NPTR_SI_Description', salesLi.NokiaCPQ_Product_Description__c);
						If(salesLi.Apttus_Config2__ProductId__r.CPQ_NPT_SI_TYPE__c != null) {
							gen.writeStringField('NPTR_SI_Type', salesLi.Apttus_Config2__ProductId__r.CPQ_NPT_SI_TYPE__c);
						}
						else {
							gen.writenullField('NPTR_SI_Type');
						}
						if (lineToCapacityUnit.containsKey(salesLi.Apttus_Config2__PrimaryLineNumber__c)) {
							gen.writeStringField('NPTR_SI_PerUnit', lineToCapacityUnit.get(salesLi.Apttus_Config2__PrimaryLineNumber__c));
						} else {
							gen.writeNullField('NPTR_SI_PerUnit');
						}
						if (salesLi.Apttus_Config2__ProductId__r.CPQ_NPT_SI_TYPE__c == 'HW' || salesLi.Apttus_Config2__ProductId__r.CPQ_NPT_SI_TYPE__c == Nokia_CPQ_Constants.NPT_HW3) {
							gen.writeNumberField('NPTR_SI_CategoryId', 1);
						} else if (salesLi.Apttus_Config2__ProductId__r.CPQ_NPT_SI_TYPE__c == 'SW' || salesLi.Apttus_Config2__ProductId__r.CPQ_NPT_SI_TYPE__c == Nokia_CPQ_Constants.NPT_SW3) {
							gen.writeNumberField('NPTR_SI_CategoryId', 2);
						} else {
							gen.writeNumberField('NPTR_SI_CategoryId', 3);
						}
						// gen.writeNumberField('NPTR_SI_Eost',salesLi.NokiaCPQ_Unitary_Cost__c); 
						// gen.writeNumberField('NPTR_SI_Cost',salesLi.NokiaCPQ_Unitary_Cost__c); 
						gen.writeStringField('NPTR_SI_CategoryName', salesLi.NokiaCPQ_Part_Number__c); //to be updated
						gen.writeNumberField('NPTR_SI_ClassId', 11); //to be updated
						gen.writeStringField('NPTR_SI_ClassName', 'HW'); //to be updated
						gen.writeStringField('NPTR_SI_NLP', '1'); //to be updated
						gen.writeStringField('NPTR_SI_CLP', '1'); //to be updated												  
						gen.writeNullField('NPTR_SI_NLP_Discount'); //to be updated
						gen.writeStringField('NPTR_SI_NLP_SalesMargin', '1'); //to be updated
						If(SalesLi.Apttus_Config2__ProductId__r.GIC__c != null) {
							gen.writeStringField('NPTR_SI_Info', SalesLi.Apttus_Config2__ProductId__r.GIC__c);
						}
						else {
							gen.writeNullField('NPTR_SI_Info');
						}
						gen.writeNumberField('NPTR_SI_IRP', salesLi.NokiaCPQ_Unitary_IRPrice__c);
						gen.writeNumberField('NPTR_SI_ELP', salesLi.NokiaCPQ_Partner_Price__c);
						gen.writeStringField('NPTR_SI_IRP_Discount', '0');
						gen.writeEndObject();
						gen.writeEndObject();
						mapSLIToSIID.put(salesLi.Id, m);
						m++;
					}
				}
			}
			// SalesItem - Spares
			if (portfolioPackageToSpare.containskey(portfolio)) {
				for (Apttus_Config2__LineItem__c spareLI: portfolioPackageToSpare.get(portfolio)) {
					if (spareLI.NokiaCPQ_Spare__c) {
						siPosition++;
						gen.writeStartObject();
						gen.writeFieldName('Parameters');
						gen.writeStartObject();
						gen.writeNumberField('NPTR_SI_Id', m);
						gen.writeNumberField('NPTR_SI_SheetId', portfoliotoSheetID.get(portfolio));
						gen.writeNumberField('NPTR_SI_Position', siPosition);
						gen.writeStringField('NPTR_SI_Code', spareLI.NokiaCPQ_Part_Number__c);
						gen.writeStringField('NPTR_SI_Description', spareLI.NokiaCPQ_Product_Description__c);
						If(spareLI.Apttus_Config2__ProductId__r.CPQ_NPT_SI_TYPE__c != null) {
							gen.writeStringField('NPTR_SI_Type', spareLI.Apttus_Config2__ProductId__r.CPQ_NPT_SI_TYPE__c);
						}
						else {
							gen.writenullField('NPTR_SI_Type');
						}
						if (lineToCapacityUnit.containsKey(spareLI.Apttus_Config2__PrimaryLineNumber__c)) {
							gen.writeStringField('NPTR_SI_PerUnit', lineToCapacityUnit.get(spareLI.Apttus_Config2__PrimaryLineNumber__c));
						} else {
							gen.writeNullField('NPTR_SI_PerUnit');
						}
						if (spareLI.Apttus_Config2__ProductId__r.CPQ_NPT_SI_TYPE__c == 'HW' || spareLI.Apttus_Config2__ProductId__r.CPQ_NPT_SI_TYPE__c == Nokia_CPQ_Constants.NPT_HW3) {
							gen.writeNumberField('NPTR_SI_CategoryId', 1);
						} else if (spareLI.Apttus_Config2__ProductId__r.CPQ_NPT_SI_TYPE__c == 'SW' || spareLI.Apttus_Config2__ProductId__r.CPQ_NPT_SI_TYPE__c == Nokia_CPQ_Constants.NPT_SW3) {
							gen.writeNumberField('NPTR_SI_CategoryId', 2);
						} else {
							gen.writeNumberField('NPTR_SI_CategoryId', 3);
						}
						gen.writeStringField('NPTR_SI_CategoryName', spareLI.NokiaCPQ_Part_Number__c); //to be updated
						gen.writeNumberField('NPTR_SI_ClassId', 11); //to be updated
						gen.writeStringField('NPTR_SI_ClassName', 'HW'); //to be updated
						gen.writeStringField('NPTR_SI_NLP', '1'); //to be updated
						gen.writeStringField('NPTR_SI_CLP', '1'); //to be updated												  
						gen.writeNullField('NPTR_SI_NLP_Discount'); //to be updated
						gen.writeStringField('NPTR_SI_NLP_SalesMargin', '1'); //to be updated					   
						If(spareLI.Apttus_Config2__ProductId__r.GIC__c != null) {
							gen.writeStringField('NPTR_SI_Info', spareLI.Apttus_Config2__ProductId__r.GIC__c);
						}
						else {
							gen.writeNullField('NPTR_SI_Info');
						}
						gen.writeNumberField('NPTR_SI_IRP', spareLI.NokiaCPQ_Unitary_IRPrice__c);
						gen.writeNumberField('NPTR_SI_ELP', spareLI.NokiaCPQ_Partner_Price__c);
						gen.writeStringField('NPTR_SI_IRP_Discount', '0');
						gen.writeEndObject();
						gen.writeEndObject();
						mapspareLIToSIID.put(spareLI.Id, m);
						m++;
					}
				}
			}
		}
		//7346 - added by Standav _START
		/** Adding JSON for Maintenance lines on cart**/
		//Part 1
		Integer maintenanceSIID = 0;
		if(!lstMasterRecords.isEmpty() && quoteRec.NokiaCPQ_No_of_Years__c != null){
			for(i=1;i<=integer.valueof(quoteRec.NokiaCPQ_No_of_Years__c);i++){

				for(Maintenance_SSP_Product__c  objMaster : lstMasterRecords){
					system.debug(' in loop lstMasterRecords');
					gen.writeStartObject();
					gen.writeFieldName('Parameters');
					gen.writeStartObject();
					gen.writeNumberField('NPTR_SI_Id', m);
					gen.writeNumberField('NPTR_SI_SheetId', 1);//portfoliotoSheetID.get(portfolio)
					gen.writeNumberField('NPTR_SI_Position', m);
					gen.writeStringField('NPTR_SI_Code', objMaster.Product_Code__c);
					//Added by Siva for defect-870 & 906
					if(objMaster.NokiaCPQ_Pricing_Cluster__c == 'NAM')
					gen.writeStringField('NPTR_SI_Description', objMaster.NokiaCPQ_Description__c+' - ['+objMaster.Package_Code__c+']');	
					else
					gen.writeStringField('NPTR_SI_Description', objMaster.NokiaCPQ_Description__c);
					
					gen.writeStringField('NPTR_SI_Type', 'Service');//hardcoded based on expected json
					//not applicable as product is blank in master data
					gen.writeNullField('NPTR_SI_PerUnit');
					
					
					gen.writeNumberField('NPTR_SI_CategoryId', 3);//hardcoded to 3 based on expected json
					
					gen.writeStringField('NPTR_SI_CategoryName', objMaster.Product_Code__c);
					gen.writeNumberField('NPTR_SI_ClassId', 11); 
					gen.writeStringField('NPTR_SI_ClassName', 'Service'); 
					gen.writeStringField('NPTR_SI_NLP', '1'); 
					gen.writeStringField('NPTR_SI_CLP', '1');												  
					gen.writeNullField('NPTR_SI_NLP_Discount');
					gen.writeStringField('NPTR_SI_NLP_SalesMargin', '1'); 
					
					gen.writeNullField('NPTR_SI_Info');
					gen.writeNumberField('NPTR_SI_IRP',0);
					//process Year 1 Maintenance line
					if(i == 1 && mapMaintenanceLine.containsKey(Nokia_CPQ_Constants.MAINTY1CODE)){
						
						Decimal year_1_Partnerprice = mapMaintenanceLine.get(Nokia_CPQ_Constants.MAINTY1CODE).NokiaCPQ_Partner_Price__c;

						Decimal splitPrice = objMaster.NokiaCPQ_Split_Ratio__c * year_1_Partnerprice/100;
						gen.writeNumberField('NPTR_SI_ELP', splitPrice.setScale(2));
					}
					
					//process Year 2 and beyond Maintenance line
					else if(Integer.valueOf(quoteRec.NokiaCPQ_No_of_Years__c) >1 && mapMaintenanceLine.containsKey(Nokia_CPQ_Constants.MAINTY2CODE)){
						//Integer year2LineQuantity = Integer.valueOf(quoteRec.NokiaCPQ_No_of_Years__c) - 1;
						//Decimal year_2_Partnerprice = (mapMaintenanceLine.get(Nokia_CPQ_Constants.MAINTY2CODE).NokiaCPQ_Partner_Price__c)/(year2LineQuantity);					  
						Decimal year_2_Partnerprice = mapMaintenanceLine.get(Nokia_CPQ_Constants.MAINTY2CODE).NokiaCPQ_Partner_Price__c;
						Decimal year2SsplitPrice = objMaster.NokiaCPQ_Split_Ratio__c * year_2_Partnerprice/100;
						gen.writeNumberField('NPTR_SI_ELP', year2SsplitPrice.setScale(2));
					}
					gen.writeStringField('NPTR_SI_IRP_Discount', '0');
					
					gen.writeEndObject();
					gen.writeEndObject();

					

					//fetch Maintenanceline SalesItem ID to populate Config in the same Sales Item ID(i.e in the same row no. in excel)  
					if(maintenanceSIID == 0){maintenanceSIID = m;}
						 
					m++;
				}
			}
		}
		 //7346 - added by Standav _END

		gen.writeEndArray();
		gen.writeEndObject();
		//ConfUnit
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_CONFUNITS_STORE');
		gen.writeFieldName('References');
		gen.writeStartObject();
		gen.writeFieldName('RecordID');
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_HEADERS_STORE');
		gen.writeStringField('OutputName', 'RecordID');
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeFieldName('Entities');
		gen.writeStartArray();
		integer n = 1;
		for (string portfolio: finalportfolioPackageCode) {
			if (portfoliopackageToSite.containskey(portfolio)) {
				for (string sitename: portfoliopackageToSite.get(portfolio)) {
					gen.writeStartObject();
					gen.writeFieldName('Parameters');
					gen.writeStartObject();
					gen.writeNumberField('NPTR_CU_Id', n);
					gen.writeNumberField('NPTR_CU_SheetId', portfoliotoSheetID.get(portfolio));
					gen.writeNumberField('NPTR_CU_Position', n);
					gen.writeStringField('NPTR_CU_Name', sitename);
					gen.writeStringField('NPTR_CU_Description', sitename);
					gen.writeEndObject();
					gen.writeEndObject();
					mapConfUnitToSiteLine.put(portfolio + '_' + sitename, n);
					n++;
				}
			}
			if (portfolioPackageToSpare.containskey(portfolio)) {
				Decimal spareqty = 0;
				for (Apttus_Config2__LineItem__c standLi: portfolioPackageToSpare.get(portfolio)) {
					if (standLi.NokiaCPQ_Spare__c) {
						spareToCUID.put(standLi.Apttus_Config2__PrimaryLineNumber__c, n);
						spareqty = spareqty + standLi.Apttus_Config2__Quantity__c;
					}
				}
				confUnitToLineNumber.put(20000, n);
				confUnitToQty.put(20000, spareqty);
				gen.writeStartObject();
				gen.writeFieldName('Parameters');
				gen.writeStartObject();
				gen.writeNumberField('NPTR_CU_Id', n);
				gen.writeNumberField('NPTR_CU_SheetId', portfoliotoSheetID.get(portfolio));
				gen.writeNumberField('NPTR_CU_Id', n);
				gen.writeNumberField('NPTR_CU_Position', n);
				gen.writeStringField('NPTR_CU_Description', portfolio + ' - Spare');
				gen.writeEndObject();
				gen.writeEndObject();
				n++;
			}
		}
		
		//4376 - Added by Standav Part 3 _START 


		if(quoteRec.NokiaCPQ_No_of_Years__c != null){
			for(i=1;i<=Integer.valueof(quoteRec.NokiaCPQ_No_of_Years__c);i++){
				gen.writeStartObject();
				gen.writeFieldName('Parameters');
				gen.writeStartObject();
				gen.writeNumberField('NPTR_CU_Id', n);
				gen.writeNumberField('NPTR_CU_SheetId', 1);
				gen.writeNumberField('NPTR_CU_Position', n);
				gen.writeStringField('NPTR_CU_Name', 'Year '+i);
				gen.writeStringField('NPTR_CU_Description', 'Year '+i);
				
				gen.writeEndObject();
				gen.writeEndObject();
				
				n++;
			}
		}
			
			
		gen.writeEndArray();
		gen.writeEndObject();
		// Incoterm Source
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_ICSRC_STORE');
		gen.writeFieldName('References');
		gen.writeStartObject();
		gen.writeFieldName('RecordID');
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_HEADERS_STORE');
		gen.writeStringField('OutputName', 'RecordID');
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeFieldName('Entities');
		gen.writeStartArray();

		gen.writeEndArray();
		gen.writeEndObject();
		// Sheet Discount
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_SHEETDISCOUNTS_STORE');
		gen.writeFieldName('References');
		gen.writeStartObject();
		gen.writeFieldName('RecordID');
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_HEADERS_STORE');
		gen.writeStringField('OutputName', 'RecordID');
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeFieldName('Entities');
		gen.writeStartArray();
		// details to be added  later
		gen.writeEndArray();
		gen.writeEndObject();
		// Sheet setting
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_SHEETSETTINGS_STORE');
		gen.writeFieldName('References');
		gen.writeStartObject();
		gen.writeFieldName('RecordID');
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_HEADERS_STORE');
		gen.writeStringField('OutputName', 'RecordID');
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeFieldName('Entities');
		gen.writeStartArray();
		// details to be added  later
		gen.writeEndArray();
		gen.writeEndObject();
		//SALESITEM PHASES
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_SALESITEMPHASES_STORE');
		gen.writeFieldName('References');
		gen.writeStartObject();
		gen.writeFieldName('RecordID');
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_HEADERS_STORE');
		gen.writeStringField('OutputName', 'RecordID');
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeFieldName('Entities');
		gen.writeStartArray();
		// details to be added  later
		gen.writeEndArray();
		gen.writeEndObject();
		// DELIVERY PHASES
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_DELIVERYPHASES_STORE');
		gen.writeFieldName('References');
		gen.writeStartObject();
		gen.writeFieldName('RecordID');
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_HEADERS_STORE');
		gen.writeStringField('OutputName', 'RecordID');
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeFieldName('Entities');
		gen.writeStartArray();
		// details to be added  later
		gen.writeEndArray();
		gen.writeEndObject();
		//Conf Phase
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_CONFPHASES_STORE');
		gen.writeFieldName('References');
		gen.writeStartObject();
		gen.writeFieldName('RecordID');
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_HEADERS_STORE');
		gen.writeStringField('OutputName', 'RecordID');
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeFieldName('Entities');
		gen.writeStartArray();
		Integer nextConfigunitId =  0;
		for (string portfolio: finalportfolioPackageCode) {
			
			if (portfoliopackageToSite.containskey(portfolio)) {
				for (String sitename: portfoliopackageToSite.get(portfolio)) {
					gen.writeStartObject();
					gen.writeFieldName('Parameters');
					gen.writeStartObject();
					If(!mapConfUnitToSiteLine.isEmpty() && mapConfUnitToSiteLine.get(portfolio + '_' + sitename) != null) {
						gen.writeNumberField('NPTR_CP_ConfUnitId', mapConfUnitToSiteLine.get(portfolio + '_' + sitename));
					}
					gen.writeNumberField('NPTR_CP_PhaseId', 1);
					gen.writeNumberField('NPTR_CP_QTY', 1);
					/*   if(!portfolioPackageToSiteQty.isEmpty() && portfolioPackageToSiteQty.get(portfolio+'_'+sitename) != null)
					   {
						   gen.writeNumberField('NPTR_CP_QTY', portfolioPackageToSiteQty.get(portfolio+'_'+sitename));
					   } */
					gen.writeEndObject();
					gen.writeEndObject();
					nextConfigunitId++;
				}
			}
			if (portfolioPackageToSpare.containskey(portfolio)) {
				gen.writeStartObject();
				gen.writeFieldName('Parameters');
				gen.writeStartObject();
				gen.writeNumberField('NPTR_CP_ConfUnitId', confUnitToLineNumber.get(20000));
				
				gen.writeNumberField('NPTR_CP_PhaseId', 1);
				gen.writeNumberField('NPTR_CP_QTY', 1); 
				gen.writeEndObject();
				gen.writeEndObject();
				nextConfigunitId++;
			}
		}
		//4376 - Added by Standav Part 4 _START 
		
		if(quoteRec.NokiaCPQ_No_of_Years__c != null){	   
			for(Integer x=1;x<=integer.valueof(quoteRec.NokiaCPQ_No_of_Years__c);x++){
				nextConfigunitId++;
				
				gen.writeStartObject();
				gen.writeFieldName('Parameters');
				gen.writeStartObject();
				
				
				 gen.writeNumberField('NPTR_CP_ConfUnitId',nextConfigunitId);

				gen.writeNumberField('NPTR_CP_PhaseId', x);
				gen.writeNumberField('NPTR_CP_QTY', 1); 
				
				gen.writeEndObject();
				gen.writeEndObject();
				
			}
		}
		//4376 - Added by Standav Part 4 _END
		gen.writeEndArray();
		gen.writeEndObject();
		//Config SalesItems
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_CONFITEMS_STORE');
		gen.writeFieldName('References');
		gen.writeStartObject();
		gen.writeFieldName('RecordID');
		gen.writeStartObject();
		gen.writeStringField('Contract', 'SCPQ_REC_HEADERS_STORE');
		gen.writeStringField('OutputName', 'RecordID');
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeFieldName('Entities');
		gen.writeStartArray();
		Integer l = 1;
		Integer spareLineConfigId  = 0;
		for (string portfolio: finalportfolioPackageCode) {
			if (portfoliopackageToLines.containskey(portfolio)) {
				for (Apttus_Config2__LineItem__c salesLi: portfoliopackageToLines.get(portfolio)) {
					system.debug('mapSLIToSIID---->'+mapSLIToSIID.get(salesLi.Id));
					if (!salesLi.NokiaCPQ_Spare__c) {
						if (mapLineSite.containskey(salesLi.Id)) {
							for (string sitename: mapLineSite.get(salesLi.Id)) {
								gen.writeStartObject();
								gen.writeFieldName('Parameters');
								gen.writeStartObject();
								gen.writeNumberField('NPTR_CI_SalesItemId', mapSLIToSIID.get(salesLi.Id));
								gen.writeNumberField('NPTR_CI_ConfUnitId', mapConfUnitToSiteLine.get(portfolio + '_' + sitename));
								if (mapSiteqty.containskey(salesLi.Id + '_' + sitename)) {
									gen.writeStringField('NPTR_CI_QTY',string.valueof(mapSiteqty.get(salesLi.Id + '_' + sitename)));
								} else {
									gen.writeStringField('NPTR_CI_QTY',string.valueof(salesLi.Apttus_Config2__Quantity__c));
								}
								
								gen.writeEndObject();
								gen.writeEndObject();
								
							}
						}
					}
					
				}
			}
			l++;
			if (portfolioPackageToSpare.containskey(portfolio)) {
				for (Apttus_Config2__LineItem__c salesLi: portfolioPackageToSpare.get(portfolio)) {
					if (salesLi.NokiaCPQ_Spare__c) {
						gen.writeStartObject();
						gen.writeFieldName('Parameters');
						gen.writeStartObject();
						gen.writeNumberField('NPTR_CI_SalesItemId', mapspareLIToSIID.get(salesLi.Id));
						if (spareToCUID.containskey(salesLi.Apttus_Config2__PrimaryLineNumber__c)) {
							gen.writeNumberField('NPTR_CI_ConfUnitId', spareToCUID.get(salesLi.Apttus_Config2__PrimaryLineNumber__c));
							spareLineConfigId = spareToCUID.get(salesLi.Apttus_Config2__PrimaryLineNumber__c);
						} else {
							gen.writeNumberField('NPTR_CI_ConfUnitId', l);
						}
						gen.writeStringField('NPTR_CI_QTY',string.valueof((salesLi.Apttus_Config2__Quantity__c)));
						gen.writeEndObject();
						gen.writeEndObject();
					}
				}
			}
			l++;
		}

		//7346 - added by Standav Part 2_START
		/** Adding JSON for Maintenance lines on quote **/

		
		if(!lstMasterRecords.isEmpty() && quoteRec.NokiaCPQ_No_of_Years__c != null){			
			for(Integer j=1;j<=integer.valueof(quoteRec.NokiaCPQ_No_of_Years__c);j++){
				if(spareLineConfigId != 0)
				spareLineConfigId++;
				else
				l++;				
				for(Maintenance_SSP_Product__c  objMaster : lstMasterRecords){
									   

					gen.writeStartObject();
					gen.writeFieldName('Parameters');
					gen.writeStartObject();
					gen.writeNumberField('NPTR_CI_SalesItemId', maintenanceSIID);
					if(spareLineConfigId != 0)
					gen.writeNumberField('NPTR_CI_ConfUnitId',spareLineConfigId);
					else
					gen.writeNumberField('NPTR_CI_ConfUnitId',l); 
					
				   
					gen.writeStringField('NPTR_CI_QTY','1');
					
					gen.writeEndObject();
					gen.writeEndObject();

					maintenanceSIID++;	
				}			 
			}
		}
		//7346 - added by Standav _END
		

		gen.writeEndArray();
		gen.writeEndObject();
		gen.writeEndArray();
		gen.writeEndObject();
		string jsonString = gen.getAsString();
		system.debug('JSONstring : ' + jsonString);
		return jsonString;
	}
  
  
  
  public JSONGenerator setDiscountActivityStore(JSONGenerator gen, String sno, string description, Boolean active)
  {
		gen.writeStartObject();
		gen.writeFieldName('Parameters');
		gen.writeStartObject();
		gen.writeStringField('NPTR_DA_Id', sno);
		gen.writeStringField('NPTR_DA_SubgroupDescription', description);
		gen.writeBooleanField('NPTR_DA_SubgroupActive', active);
		gen.writeNullField('NPTR_DA_Subgroup');
		gen.writeEndObject();
		gen.writeEndObject();
	  return gen;
  }
	/*  Method to create JSOn string for BOM request to NPT */	
	public String sendBOMtoNPT(string reqBody, string token, string configID){
	   
		Interface_Log__c interfaceLog = new Interface_Log__c();
		Http httpBOMReq = new Http();
		HttpRequest sendBOMRequest = new HttpRequest();
	   
		sendBOMRequest.setEndpoint(cs.setEndpointURL__c); 
		system.debug('bottom setEndpointURL__c '+cs.setEndpointURL__c);
		sendBOMRequest.setMethod('POST');
		sendBOMRequest.setHeader('Content-Type', 'application/json');
		sendBOMRequest.setHeader('Authorization', 'Bearer '+ token);
		sendBOMRequest.setHeader('source', 'sCPQ');
		sendBOMRequest.setBody(reqBody);
		sendBOMRequest.setTimeout(120000);
		HttpResponse responseBOM = httpBOMReq.send(sendBOMRequest);
		System.debug('responseBOM :: '+responseBOM.getBody());
		system.debug('ResponcecodeBOMreq : '+ responseBOM.getstatusCode());
		
		string jsonID = responseBOM.getBody();
		System.debug('jsonID :'+jsonID );
		interfaceLog.Interface_Type__c = 'NPT Outbound';
		interfaceLog.Message_Type__c = 'Outbound';
		interfaceLog.DS_Payload__c = reqBody.length() > 131072 ? reqBody.subString(0, 131072) : reqBody;
		interfaceLog.Product_Configuration__c = configID;
		if(responseBOM.getstatusCode()== 200){
			interfaceLog.Status__c = 'Success';
			interfaceLog.JSON_ID_NPT__c = jsonID;
		}
		else{
			interfaceLog.Status__c = 'Failure';
			interfaceLog.Comment__c = jsonID;
		}
		system.debug('InterfaceLog : '+ InterfaceLog);
		database.insert(InterfaceLog);
		
		return(jsonID);
	}
	/*  Method to create JSOn string for BOM request to NPT */ 
	@future (callout=true)
	public static void getJsonStatus(string interfacelogID){
		
		string jsonProcessingCompleted = 'Not Completed';
		
		Interface_Log__c interfaceL = [select id,  Comment__c from Interface_Log__c where id =: interfacelogID];
		string jsonID = interfaceL.Comment__c;
		string token = getNPTtoken(); 
		Http httpGetJsonStatus = new Http();
		HttpRequest httpGetJsonStatusReq = new HttpRequest();
		//httpGetJsonStatusReq.setEndpoint('https://heracles-dev-euw-apps-datastoring.all-dev-euw-ase.p.azurewebsites.net/api/v1/status/'+jsonID);
		httpGetJsonStatusReq.setEndpoint(cs.setEndpointURL__c+jsonID);
		httpGetJsonStatusReq.setMethod('GET');
		httpGetJsonStatusReq.setHeader('Authorization', 'Bearer '+ token);
		httpGetJsonStatusReq.setTimeout(120000);
		HttpResponse responseJsonStatus = httpGetJsonStatus.send(httpGetJsonStatusReq);
		System.debug('responseJsonStatus :: '+responseJsonStatus.getBody());
		list<Object> statusresults =   (list<Object>) JSON.deserializeUntyped(responseJsonStatus.getBody());
		System.debug('statusresults :: '+ statusresults);
		for(Object obj : statusresults) { 
			Map<String,Object> map1 = (Map<String,Object>)obj; 
			for(String key : map1.keyset()) { 
				System.debug('Key -->> ' + key); 
				System.debug('Value -->> ' + (String)map1.get(key)); 
				if(key == 'Status' && (String)map1.get(key) == 'Processed'){
					jsonProcessingCompleted = 'Processed';
					break;
				}
				else if(key == 'Status' && (String)map1.get(key) == 'Failed'){
					jsonProcessingCompleted = 'Failed';
					break;  
				}
			} 
		}
		system.debug('jsonProcessingCompleted : '+ jsonProcessingCompleted);
		if(jsonProcessingCompleted == 'Processed'){
			interfaceL.Comment__c = 'Json processing is completed sucessfully.';
			system.debug('Json processing is completed sucessfully.');
		}
		else if(jsonProcessingCompleted == 'Failed'){
			interfaceL.Comment__c = 'Json processing is completed and its failed.';
			system.debug('Json processing is completed and its failed with below details.' + '/n' + '-- detail;;');
		}
		else if(jsonProcessingCompleted == 'Not Completed'){
			interfaceL.Comment__c = 'Not Completed';
			system.debug('Json processing is still in progress.');
		} 
		database.update(interfaceL);
	}
}