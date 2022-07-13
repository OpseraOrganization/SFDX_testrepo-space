/*******************************
   Class Name: SearchProduct
   Created by: Accenture
   Created Date: 10th June 2019
   Last modified by: Accenture
   Last modified date: 10th June 2019
   Description: This class will handle the logic implemented on Custom product entry for Indirect CPQ
*******************************/
public with sharing class SearchProduct {

// will set the line item number values
@AuraEnabled
public static void setLineItemsNumber(ID idConfig,SearchProductWrapper objWrapper) {
	objWrapper.isLEO= false;
	Decimal iLineNumber=0,iPrimaryNumber = 0, iItemSequence = 0;
	try {
		for( Apttus_Config2__LineItem__c objLineItem : [select id,NokiaCPQ_Alias__c, Name,Apttus_Config2__LineNumber__c,Apttus_Config2__PrimaryLineNumber__c,Apttus_Config2__ItemSequence__c
			  from Apttus_Config2__LineItem__c
			  where
			  Apttus_Config2__ConfigurationId__c=:idConfig ])

		{
			if(iLineNumber < objLineItem.Apttus_Config2__LineNumber__c)
	iLineNumber = objLineItem.Apttus_Config2__LineNumber__c;
			if(iPrimaryNumber < objLineItem.Apttus_Config2__PrimaryLineNumber__c)
	iPrimaryNumber = objLineItem.Apttus_Config2__PrimaryLineNumber__c;
			if(iItemSequence < objLineItem.Apttus_Config2__ItemSequence__c)
	iItemSequence = objLineItem.Apttus_Config2__ItemSequence__c;
		}

		objwrapper.iLineNumber = integer.valueof(iLineNumber);
		objwrapper.iItemSequence = integer.valueof(iItemSequence);
		objwrapper.iPrimaryLineNumber = integer.valueof(iPrimaryNumber);
	}
	catch(Exception ex) {
		ExceptionHandler.addException(ex,SearchProduct.class.getName(),'setLineItemsNumber');
	}

}

// get the product detials to create line item
@AuraEnabled
public static SearchProductWrapper getDetailsProduct(ID strProductId,ID strConfigId) {
	System.debug('strProductId-->'+strProductId);
	try
	{
		SearchProductWrapper objwrapper = new SearchProductWrapper();//<---FN-->
		Apttus_Config2__ProductConfiguration__c ObjProdConfig;//<---FN-->

		for(Product2 objProd : [select id, Name, ProductCode,Description,NokiaCPQ_Product_Discount_Category__c from product2
		where id=:strProductId OR ProductCode='CUSTPROD001'])
		{

			if(objProd.ProductCode == Nokia_CPQ_Constants.CUSTPROD001)
	objwrapper.strProductID = objProd.id;

			if(string.isBlank(strProductId) && objProd.ProductCode == Nokia_CPQ_Constants.CUSTPROD001)
			{

	objwrapper.strProductCode = objProd.ProductCode;
	objwrapper.strProductName = objProd.Name;
			}else if(!(string.isBlank(strProductId)) && objProd.ProductCode != Nokia_CPQ_Constants.CUSTPROD001)
			{
	objwrapper.strProductCode = objProd.ProductCode;
	objwrapper.strProductName = objProd.Name;
	if(!string.isBlank(objProd.NokiaCPQ_Product_Discount_Category__c))
		objwrapper.strPdc = objProd.NokiaCPQ_Product_Discount_Category__c;
			}
		}

		ObjProdConfig =   getProductConfig(strConfigId);//<---FN-->
		objwrapper.strPortfolio = ObjProdConfig.NokiaCPQ_Portfolio_From_Quote__c;//<---FN-->
		setLineItemsNumber(strConfigId,objwrapper);//<---FN-->
		System.debug('objwrapper-->'+objwrapper);
		return objwrapper;
	}
	catch(Exception ex) {
		ExceptionHandler.addException(ex,SearchProduct.class.getName(),'getDetailsProduct');
	}
	return null;

}

// get the product configuration details
@AuraEnabled
public static Apttus_Config2__ProductConfiguration__c getProductConfig(ID strConfigId) {
	try
	{	
		return CPQ_CustomProductUploadHelper.getProductConfig(strConfigId);
		//return [SELECT Apttus_Config2__AccountId__r.Partner_Program__c,Apttus_QPConfig__Proposald__r.NokiaCPQPricing_Cluster__c,Apttus_QPConfig__Proposald__r.CPQ_SubPortfolio__c, Apttus_QPConfig__Proposald__r.NokiaCPQ_Is_Maintenance_Quote__c,/*Apttus_QPConfig__Proposald__r.NokiaProductAccreditation__c,*/Quote_Type__c,NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c,NokiaCPQ_Portfolio_From_Quote__c,Apttus_QPConfig__Proposald__r.NokiaCPQ_LEO_Discount__c,Apttus_Config2__PriceListId__c,Apttus_QPConfig__Proposald__r.NokiaCPQ_Existing_IONMaint_Contract__c,Apttus_QPConfig__Proposald__r.NokiaCPQ_No_of_Years__c,Apttus_QPConfig__Proposald__r.Warranty_credit__c,Pricing_Cluster_Search_Filter__c,Apttus_Config2__AccountId__c,Apttus_QPConfig__Proposald__r.NokiaCPQ_Maintenance_Type__c,Apttus_QPConfig__Proposald__r.NokiaCPQ_Portfolio__c FROM Apttus_Config2__ProductConfiguration__c WHERE id=: strConfigId Limit 1];
		 //ITCEPP:789:Bibhu:Added field
	}
	catch(Exception ex) {
		ExceptionHandler.addException(ex,SearchProduct.class.getName(),'getProductConfig');
	}
	return null;
}

// set the values to wrapper class used to create the Line Item
@AuraEnabled
public static SearchProductWrapper getLineItemValue(ID strProductId,ID strConfigId,String subportfolio) {
	System.debug('subportfolio-->'+subportfolio);
	SearchProductWrapper objwrapper = new SearchProductWrapper();
	try
	{
		
		Apttus_Config2__ProductConfiguration__c ObjProdConfig;

		//getDetailsProduct(strProductId,objwrapper);//FN-commented

		ObjProdConfig =   getProductConfig(strConfigId);
		Boolean flag = false;

		if(string.isBlank(strProductId))
		{
			objwrapper.strGlobalPriceListItemID = createPriceLineItems(objwrapper.strProductID,ObjProdConfig.Apttus_Config2__PriceListId__c);
		}
		else if(!string.isBlank(strProductId))
		{
			Apttus_Config2__PriceListItem__c[] objtest =  [select id
			  from
			  Apttus_Config2__PriceListItem__c
			  where
			  Apttus_Config2__PriceListId__c=:ObjProdConfig.Apttus_Config2__PriceListId__c and Apttus_Config2__ProductId__c =:strProductId and Apttus_Config2__Active__c = true LIMIT 1];
			if(objtest.size() == 0)
	objwrapper.strGlobalPriceListItemID = createPriceLineItems(strProductId,ObjProdConfig.Apttus_Config2__PriceListId__c);
			else
	objwrapper.strGlobalPriceListItemID = objtest[0].id;
		}
		objwrapper.str1Year = ObjProdConfig.Apttus_QPConfig__Proposald__r.NokiaCPQ_No_of_Years__c;
		objwrapper.strGlobalPriceListID = ObjProdConfig.Apttus_Config2__PriceListId__c;
		List<Nokia_CPQ_SSP_SRS_Default_Values__mdt> mdt = [Select Portfolio__c, SSP_Visible__c, SRS_Visible__c, SRS_Percentage__c, Tier_Discount_Applicable__c, AccountLevel_Discount_Applicable__c, Multi_Year_Discount_Applicable__c
				 From
				 Nokia_CPQ_SSP_SRS_Default_Values__mdt
				 where Portfolio__c=: ObjProdConfig.NokiaCPQ_Portfolio_From_Quote__c LIMIT 1];
		if(!mdt.isEmpty()){
			objwrapper.dSRSPercentage = mdt[0].SRS_Percentage__c; 
		}
		objwrapper.strPortfolio = subportfolio; //ObjProdConfig.NokiaCPQ_Portfolio_From_Quote__c; FN-Change
		/*objwrapper.dSRSPercentage =  [Select Portfolio__c, SSP_Visible__c, SRS_Visible__c, SRS_Percentage__c, Tier_Discount_Applicable__c, AccountLevel_Discount_Applicable__c, Multi_Year_Discount_Applicable__c
		From
		Nokia_CPQ_SSP_SRS_Default_Values__mdt
		where
		Portfolio__c=: ObjProdConfig.NokiaCPQ_Portfolio_From_Quote__c LIMIT 1].SRS_Percentage__c;*/
		//defect 13889 Heema/13944
		if(ObjProdConfig.Apttus_QPConfig__Proposald__r.NokiaCPQ_LEO_Discount__c==true && ObjProdConfig.Apttus_QPConfig__Proposald__r.NokiaCPQ_No_of_Years__c.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_1YEAR)) {
			objwrapper.dSRSPercentage = 0.0;
			objwrapper.isLEO = true;
		}
		if(Nokia_CPQ_Constants.QUOTE_TYPE_INDIRECTCPQ.equalsIgnoreCase(ObjProdConfig.Quote_Type__c)) {
			/*FN-Commented-START
			objwrapper.strPricingAccred = [select Pricing_Accreditation__c from Accreditation__c where id =:ObjProdConfig.Apttus_QPConfig__Proposald__r.NokiaProductAccreditation__c].Pricing_Accreditation__c;
			string strGPPversion = [select Partner_Program__c from Accreditation__c where id =:ObjProdConfig.Apttus_QPConfig__Proposald__r.NokiaProductAccreditation__c].Partner_Program__c;
			objwrapper.iIncotermPercentage = [select NokiaCPQ_Incoterm_Percentage__c from Accreditation__c where id =:ObjProdConfig.Apttus_QPConfig__Proposald__r.NokiaProductAccreditation__c].NokiaCPQ_Incoterm_Percentage__c;
			FN-Commented-END */
			
			/**FN START*******/			
			string strGPPversion = ObjProdConfig.Apttus_Config2__AccountId__r.Partner_Program__c;
			List<Accreditation__c> validAccred= [select Id,name,Pricing_Level_Override__c,Portfolio__c,Accreditation_Type__c,Pricing_Accreditation__c,NokiaCPQ_Incoterm_Percentage__c 
		 	FROM Accreditation__c WHERE Partner__c =:ObjProdConfig.Apttus_Config2__AccountId__c and Accreditation_Type__c= 'Product' 
		AND Portfolio__c =:  subPortfolio];
	
			system.debug('validAccred>>'+validAccred);
			if(!validAccred.isEmpty()){
	objwrapper.strPricingAccred = validAccred[0].Pricing_Accreditation__c;
	objwrapper.iIncotermPercentage = validAccred[0].NokiaCPQ_Incoterm_Percentage__c;
			}	
			/**FN END*******/
			//Added by RG for LOE check Start
			if(ObjProdConfig.Apttus_QPConfig__Proposald__r.NokiaCPQ_LEO_Discount__c) {
	/*FN-Commented-START
	string str = 'NokiaCPQ LEO Discount IPR NUA OPT ' +strGPPversion;
	string strruleSetID = [select id,NokiaCPQ_Partner_Program__c from Apttus_Config2__PriceRuleset__c where NokiaCPQ_Partner_Program__c=:strGPPversion and NokiaCPQ_Cluster_Tiers__c = 'LEO' and name = :str ].id;
	objwrapper.strAccredDiscount = [select Apttus_Config2__AdjustmentAmount__c from Apttus_Config2__PriceRuleEntry__c where Apttus_Config2__Dimension1Value__c=:ObjProdConfig.NokiaCPQ_Portfolio_From_Quote__c and Apttus_Config2__PriceRuleId__r.Apttus_Config2__RulesetId__c=:strruleSetID].Apttus_Config2__AdjustmentAmount__c;
	System.debug('strruleSetID>>>'+strruleSetID);
	System.debug('objwrapper.strAccredDiscount>>>'+objwrapper.strAccredDiscount);
	FN-Commented-END */
	
	/**FN START*******/
	string pricingCluster = ObjProdConfig.Apttus_QPConfig__Proposald__r.NokiaCPQPricing_Cluster__c;
	
	List<CPQ_ProductDiscountRules__c> validPDR = [select CPQ_ProductDiscountPer__c,CPQ_PricingCluster__c 
				 FROM CPQ_ProductDiscountRules__c 
				 WHERE CPQ_PartnerProgram__c =: strGPPversion AND CPQ_ProductDiscountCategory__c = null AND CPQ_DiscountType__c = 'LEO' AND CPQ_Portfolio__c =: subPortfolio];
	if(!validPDR.isEmpty() && validPDR[0].CPQ_PricingCluster__c.contains(pricingCluster)){
		objwrapper.strAccredDiscount = validPDR[0].CPQ_ProductDiscountPer__c;
	}
	system.debug('validPDR>>'+validPDR);
	/**FN END*******/
			}
			else if(!mdt.isEmpty() && mdt[0].Tier_Discount_Applicable__c){//ITCCPQ-3045,3048
	/*FN-Commented-START
	//Added by RG for LOE check End
	string strruleSetID = [select id,NokiaCPQ_Partner_Program__c from Apttus_Config2__PriceRuleset__c where NokiaCPQ_Partner_Program__c=:strGPPversion and name='NokiaCPQ Accreditation Level Discount GPP 3.0'].id;
	objwrapper.strAccredDiscount = [select Apttus_Config2__AdjustmentAmount__c
			from
			Apttus_Config2__PriceRuleEntry__c where Apttus_Config2__Dimension1Value__c=:objwrapper.strPricingAccred and Apttus_Config2__PriceRuleId__r.Apttus_Config2__RulesetId__c=:strruleSetID].Apttus_Config2__AdjustmentAmount__c;

	FN-Commented-END */
	
	/**FN START*******/
	list<Tier_Discount_Detail__c > tierDisc = [select id,NokiaCPQ_Pricing_Tier__c ,Nokia_CPQ_Partner_Program__c,NokiaCPQ_Tier_Discount__c FROM Tier_Discount_Detail__c
	where NokiaCPQ_Tier_Type__c  = 'Product'
	AND NokiaCPQ_Pricing_Tier__c  =: objwrapper.strPricingAccred 
	 AND Nokia_CPQ_Partner_Program__c  =: strGPPversion
	 ]; //taking firs record - to be confirmed as it can have 4 records  with diff partner types
			
	if(!tierDisc.isEmpty()){
		objwrapper.strAccredDiscount= tierDisc[0].NokiaCPQ_Tier_Discount__c;
	}
	system.debug('tierDisc>>'+tierDisc);
	/**FN END*******/ 
			}
		}
		setLineItemsNumber(strConfigId,objwrapper);
	}
	catch(Exception ex) {
		ExceptionHandler.addException(ex,SearchProduct.class.getName(),'getLineItemValue');
	}
	return objwrapper;
}


// return the search result of the product
@AuraEnabled
public static List < Map<string,string> > fetchProduct(string searchKeyWord,ID ProductConfigId) {
	Id cartId;
	try
	{
		List<Map<string,string> > prodData = new List<Map<string,string> >();
		Apttus_Config2__ProductConfiguration__c ObjProdConfig;
		String searchKey;
		if(ProductConfigId != null)
			ObjProdConfig =  getProductConfig(ProductConfigId);
		String productState = Label.Product_State;
		List<String> prodStateList = new List<String>();
		List<String> finalProdStateList = new List<String>();
		if(String.isNotBlank(productState)) {
			finalProdStateList.addAll(productState.split(';'));
		}
		for(String prodState : finalProdStateList) {
			prodStateList.add('\'' +prodState+'\'');
		}
		Boolean leoDiscount = ObjProdConfig.Apttus_QPConfig__Proposald__r.NokiaCPQ_LEO_Discount__c;
		if(searchKeyWord==null || String.isBlank(searchKeyWord))
			searchKey = '\'%\'';
		else{
			searchKey = '\'' + searchKeyWord  + '%\'';
		}
		String query = '';
		//Integer remainingRows = 5000;
		Integer remainingRows = Limits.getLimitQueryRows() - Limits.getQueryRows();
		if(leoDiscount) {
			query = 'AND NokiaCPQ_State__c IN '+prodStateList;
		}
		String accountId = ObjProdConfig.Apttus_Config2__AccountId__c;
		String maintenanceType = ObjProdConfig.Apttus_QPConfig__Proposald__r.NokiaCPQ_Maintenance_Type__c;
		String portfolio = ObjProdConfig.NokiaCPQ_Portfolio_From_Quote__c;
		String portfolioContains = '%'+ObjProdConfig.NokiaCPQ_Portfolio_From_Quote__c+'%';

		//ITCCPQ-2542 - START
		//fetch maintenance and sps/srs prod codes
		List<string> codes = Nokia_CPQ_Utility.getMaintAndSSPSRSProdCodes();
		//ITCCPQ-2542 - End
		String finalQuery = 'select id, Name,Portfolio__c,Direct_Portfolio__c, ProductCode,Description,NokiaCPQ_State__c,IsActive,Pricing_Clusters_Search_Filter__c,Valid_Search_Filter__c,isInvalidProductCatalog__c,NokiaCPQ_Valid_for__c  from product2 where ProductCode like ' + searchKey+ ' ' + query+ ' AND (Portfolio__c LIKE:portfolioContains OR Portfolio__c=\'' +Nokia_CPQ_Constants.NOKIA_EMPTY+'\' OR Direct_Portfolio__c =\'' +portfolio+'\') AND ProductCode NOT IN :codes LIMIT '+remainingRows;
		List < product2 > returnList = new List < product2 > ();
		List < product2 > lstOfproduct = Database.query(finalQuery);

		for (product2 prod: lstOfproduct) {
			if(!prod.IsActive && string.isNotBlank(prod.ProductCode) && prod.ProductCode.endsWithIgnoreCase('_TBD')) {
	continue;
			}
			returnList.add(prod);
			Map<string,string> pData = new Map<string,string>();
			pData.put('Id', prod.Id);
			pData.put('Name', prod.Name);
			pData.put('ProductCode', prod.ProductCode);
			pData.put('NokiaCPQ_State__c', prod.NokiaCPQ_State__c);
			pData.put('Description', prod.Description);
			pData.put('Availability', Nokia_CPQ_Utility.isProductAvailableInCatalog(ObjProdConfig, prod) ? 'Available in Catalog' : '');
			prodData.add(pData);
		}
		remainingRows = Limits.getLimitQueryRows() - Limits.getQueryRows();

		List<String> validPortfolios = Nokia_CPQ_Utility.getPortfolio(ObjProdConfig.Apttus_QPConfig__Proposald__r);

		query = 'SELECT Id,Name,Product_Code__c FROM Pre_Approved_Custom_Products__c WHERE Account__c = :accountId AND Product_Code__c LIKE ' + searchKey+ ' and Expiration_Date__c > TODAY AND (Portfolio__c =:portfolio OR Portfolio__c IN:validPortfolios)';
		if(ObjProdConfig.Quote_Type__c == Nokia_CPQ_Constants.QUOTE_TYPE_INDIRECTCPQ || (ObjProdConfig.Quote_Type__c == Nokia_CPQ_Constants.QUOTE_TYPE_DIRECTCPQ && ObjProdConfig.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c)) {
			query += ' AND Maintenance_Type__c =:maintenanceType';
		}
		query += ' LIMIT :remainingRows';
		List<Pre_Approved_Custom_Products__c> papList = Database.query(query);
		for (Pre_Approved_Custom_Products__c pac : papList) {
			Map<string,string> pData = new Map<string,string>();
			pData.put('Id', pac.Id);
			pData.put('Name', pac.Name);
			pData.put('ProductCode', pac.Product_Code__c);
			pData.put('Availability','Available as Pre-Approved' );
			prodData.add(pData);
		}
		return prodData;
	}
	catch(Exception ex) {
		ExceptionHandler.addException(ex,SearchProduct.class.getName(),'fetchProduct');
	}
	return null;
}

/**
 * @description Check if Roduct codes are availabl in Catalog or as Pre-Approved
 * @author Yashdeep Prajapati | 10-04-2021
 * @param prodCodes
 * @param productConfigId
 * @return Map<string, string>
 **/
@AuraEnabled
public static Map<string,string> prodAvailabilityCheck(List<string> prodCodes,ID productConfigId) {
	try
	{
		Map<string,string> prodData = new Map<string,string>();
		Apttus_Config2__ProductConfiguration__c objProdConfig = getProductConfig(ProductConfigId);
		return Nokia_CPQ_Utility.prodAvailabilityCheck(prodCodes, objProdConfig);
	}
	catch(Exception ex) {
		ExceptionHandler.addException(ex,SearchProduct.class.getName(),'prodAvailabilityCheck');
	}
	return null;
}

// create Price list line item if no PLI is present.
@AuraEnabled
public static string createPriceLineItems(ID strProductId,ID idGlobalPl)
{
	// Id idExitingPli;
	try
	{
		Apttus_Config2__PriceListItem__c[] idExitingPli = [select id from Apttus_Config2__PriceListItem__c where Apttus_Config2__ProductId__c=:strProductId Limit 1];
		if(idExitingPli.size() == 0)
		{
			Apttus_Config2__PriceListItem__c objPLI = new  Apttus_Config2__PriceListItem__c();
			objPLI.Apttus_Config2__PriceType__c ='One Time';
			objPLI.Apttus_Config2__PriceMethod__c = 'Per Unit';
			objPLI.Apttus_Config2__ChargeType__c = 'Product Price';
			objPLI.Apttus_Config2__ProductId__c = strProductId;
			objPLI.Apttus_Config2__PriceListId__c = idGlobalPl;
			objPLI.Apttus_Config2__Active__c= true;
			insert objPLI;

			return objPLI.id;
		}else
			return idExitingPli[0].id;

	}
	catch(Exception ex) {
		ExceptionHandler.addException(ex,SearchProduct.class.getName(),'createPriceLineItems');
	}
	return null;
}

/*  @AuraEnabled
	  public static string createMaint(ID ProductConfigId, Boolean blIsNetwork)
	  {
	 map<string,ID> mapCodeId= new map<string,ID>();
	 try
	 {
		  Apttus_Config2__ProductConfiguration__c ObjProdConfig;

		  if(ProductConfigId != null)
	  ObjProdConfig =  getProductConfig(ProductConfigId);

		  Boolean flag = false;

		  if(ObjProdConfig.Apttus_QPConfig__Proposald__r.NokiaCPQ_LEO_Discount__c == true &&  ObjProdConfig.Apttus_QPConfig__Proposald__r.NokiaCPQ_Existing_IONMaint_Contract__c.equalsIgnoreCase('No') && ObjProdConfig.Apttus_QPConfig__Proposald__r.NokiaCPQ_No_of_Years__c=='1')
		  {
	  flag = true;
		  }
		  list<Apttus_Config2__LineItem__c> lstLineItem = [select id
	  from Apttus_Config2__LineItem__c
	  where
	  Apttus_Config2__ConfigurationId__c=:ProductConfigId ];
		  system.debug('lstLineItem'+lstLineItem.size());

		  if(lstLineItem.size() == 1)
		  {
	  mapCodeId=  getProductID();
	  if(ObjProdConfig.NokiaCPQ_Portfolio_From_Quote__c =='IP Routing' && flag == false)
	  {
	 if(blIsNetwork == false)
		  createSSPRecord(ProductConfigId,mapCodeId);
	 else
		  createSRSRecord(ProductConfigId,mapCodeId);
	  }
	  createmaint1(ProductConfigId,mapCodeId);
	  if(flag == false)
	  createmaint2(ProductConfigId,mapCodeId);
		  }
		  return null;


	 }
	 catch(Exception ex) {
		  ExceptionHandler.addException(ex,SearchProduct.class.getName(),'createMaint');
	 }
	 return null;
	  }*/

@AuraEnabled
public static map<string,ID> getProductID()
{
	try
	{
		map<string,ID> mapCodeId= new map<string,ID>();
		for(product2 objproduct : [select id,ProductCode,name from product2 where ProductCode in ('SRS001','SSP002','MT001','MT002')])
		{
			mapCodeId.put(objproduct.ProductCode, objproduct.id);

		}
		return mapCodeId;
	}
	catch(Exception ex) {
		ExceptionHandler.addException(ex,SearchProduct.class.getName(),'createMaint');
		return null;
	}
}

/* @AuraEnabled
	 public static string createSRSRecord(ID ProductConfigId, map<string,ID> mapCodeId)
	 {
	try
	{
		 Apttus_Config2__LineItem__c oLineItem = new Apttus_Config2__LineItem__c();

		 oLineItem.Apttus_Config2__Quantity__c = 1;
		 oLineItem.Apttus_Config2__ProductId__c = mapCodeId.get('SRS001');
		 oLineItem.Apttus_Config2__Description__c =  'SRS';
		 oLineItem.Apttus_Config2__LineNumber__c = 4;
		 oLineItem.Apttus_Config2__PrimaryLineNumber__c = 4;
		 oLineItem.Apttus_Config2__ItemSequence__c = 4;
		 oLineItem.Apttus_Config2__ConfigurationId__c = ProductConfigId;
		 oLineItem.Apttus_Config2__LineType__c = 'Product/Service';
		 oLineItem.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
		 oLineItem.Apttus_Config2__PriceUom__c ='Each';
		 oLineItem.Apttus_Config2__Frequency__c = 'One Time';
		 oLineItem.Apttus_Config2__Frequency__c = 'One Time';
		 oLineItem.Apttus_Config2__PricingStatus__c = 'Pending';
		 oLineItem.Apttus_Config2__ConfigStatus__c = 'NA';
		 oLineItem.Apttus_Config2__IsPrimaryLine__c = true;
		 oLineItem.Apttus_Config2__ChargeType__c = 'SRS';
		 oLineItem.Apttus_Config2__ProductVersion__c = 1.0;

		 insert oLineItem;
		 return oLineItem.id;
	}
	catch(Exception ex) {
		 ExceptionHandler.addException(ex,SearchProduct.class.getName(),'createSRSRecord');
		 return null;
	}
	 }

	 @AuraEnabled
	 public static string createSSPRecord(ID ProductConfigId, map<string,ID> mapCodeId)
	 {
	try
	{
		 Apttus_Config2__LineItem__c oLineItem = new Apttus_Config2__LineItem__c();

		 oLineItem.Apttus_Config2__Quantity__c = 1;
		 oLineItem.Apttus_Config2__ProductId__c = mapCodeId.get('SSP002');
		 oLineItem.Apttus_Config2__Description__c =  'SSP';
		 oLineItem.Apttus_Config2__LineNumber__c = 4;
		 oLineItem.Apttus_Config2__PrimaryLineNumber__c = 4;
		 oLineItem.Apttus_Config2__ItemSequence__c = 4;
		 oLineItem.Apttus_Config2__ConfigurationId__c = ProductConfigId;
		 oLineItem.Apttus_Config2__LineType__c = 'Product/Service';
		 oLineItem.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
		 oLineItem.Apttus_Config2__PriceUom__c ='Each';
		 oLineItem.Apttus_Config2__Frequency__c = 'One Time';
		 oLineItem.Apttus_Config2__Frequency__c = 'One Time';
		 oLineItem.Apttus_Config2__PricingStatus__c = 'Pending';
		 oLineItem.Apttus_Config2__ConfigStatus__c = 'NA';
		 oLineItem.Apttus_Config2__IsPrimaryLine__c = true;
		 oLineItem.Apttus_Config2__ChargeType__c = 'SSP';
		 oLineItem.Apttus_Config2__ProductVersion__c = 1.0;

		 insert oLineItem;
		 return oLineItem.id;
	}
	catch(Exception ex) {
		 ExceptionHandler.addException(ex,SearchProduct.class.getName(),'createSSPRecord');
		 return null;
	}
	 }

	 @AuraEnabled
	 public static string createmaint1(ID ProductConfigId, map<string,ID> mapCodeId)
	 {
	try
	{
		 Apttus_Config2__LineItem__c oLineItem = new Apttus_Config2__LineItem__c();

		 oLineItem.Apttus_Config2__Quantity__c = 1;
		 oLineItem.Apttus_Config2__ProductId__c = mapCodeId.get('MT001');
		 oLineItem.Apttus_Config2__Description__c =  'Year 1 Maintenance';
		 oLineItem.Apttus_Config2__LineNumber__c = 2;
		 oLineItem.Apttus_Config2__PrimaryLineNumber__c = 2;
		 oLineItem.Apttus_Config2__ItemSequence__c = 2;
		 oLineItem.Apttus_Config2__ConfigurationId__c = ProductConfigId;
		 oLineItem.Apttus_Config2__LineType__c = 'Product/Service';
		 oLineItem.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
		 oLineItem.Apttus_Config2__PriceUom__c ='Each';
		 oLineItem.Apttus_Config2__Frequency__c = 'One Time';
		 oLineItem.Apttus_Config2__Frequency__c = 'One Time';
		 oLineItem.Apttus_Config2__PricingStatus__c = 'Pending';
		 oLineItem.Apttus_Config2__ConfigStatus__c = 'NA';
		 oLineItem.Apttus_Config2__IsPrimaryLine__c = true;
		 oLineItem.Apttus_Config2__ChargeType__c = 'Year 1 Maintenance';
		 oLineItem.Apttus_Config2__ProductVersion__c = 1.0;

		 insert oLineItem;
		 return oLineItem.id;
	}
	catch(Exception ex) {
		 ExceptionHandler.addException(ex,SearchProduct.class.getName(),'createMaint1');
		 return null;
	}
	 }

	 @AuraEnabled
	 public static string createmaint2(ID ProductConfigId, map<string,ID> mapCodeId)
	 {
	try
	{
		 Apttus_Config2__LineItem__c oLineItem = new Apttus_Config2__LineItem__c();

		 oLineItem.Apttus_Config2__Quantity__c = 1;
		 oLineItem.Apttus_Config2__ProductId__c = mapCodeId.get('MT002');
		 oLineItem.Apttus_Config2__Description__c =  'Year 2 Maintenance';
		 oLineItem.Apttus_Config2__LineNumber__c = 3;
		 oLineItem.Apttus_Config2__PrimaryLineNumber__c = 3;
		 oLineItem.Apttus_Config2__ItemSequence__c = 3;
		 oLineItem.Apttus_Config2__ConfigurationId__c = ProductConfigId;
		 oLineItem.Apttus_Config2__LineType__c = 'Product/Service';
		 oLineItem.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
		 oLineItem.Apttus_Config2__PriceUom__c ='Each';
		 oLineItem.Apttus_Config2__Frequency__c = 'One Time';
		 oLineItem.Apttus_Config2__Frequency__c = 'One Time';
		 oLineItem.Apttus_Config2__PricingStatus__c = 'Pending';
		 oLineItem.Apttus_Config2__ConfigStatus__c = 'NA';
		 oLineItem.Apttus_Config2__IsPrimaryLine__c = true;
		 oLineItem.Apttus_Config2__ChargeType__c = 'Maintenance for Y2 and Beyond';
		 oLineItem.Apttus_Config2__ProductVersion__c = 1.0;

		 insert oLineItem;
		 return oLineItem.id;
	}
	catch(Exception ex) {
		 ExceptionHandler.addException(ex,SearchProduct.class.getName(),'createmaint2');
		 return null;
	}
	 }*/
	@AuraEnabled
	public static string executeAdditionalOperation(ID productConfigId)
	{
		// Id idExitingPli;
		try
		{
			List < Integer > primaryLines = new List < Integer > ();
			Apttus_CPQApi.CPQWebService.associateConstraintRules(productConfigId, primaryLines);
			Apttus_CPQApi.CPQWebService.applyConstraintRules(productConfigId, false);

		}
		catch(Exception ex) {
			ExceptionHandler.addException(ex,SearchProduct.class.getName(),'createPriceLineItems');
		}
		return null;
	}

	// get the Quote subportfolio picklist value -if Indirect Quote
	@AuraEnabled
	public static Map<String, String> getSubPortfolioPicklistEntry(String strConfigId) {//<---FN_Start-->
		try
		{
			string picklistlabels;
			//method will return either subportfolio or Porfolio values
			List<String> validPortfolios;
			
			string soqlconfi = 'SELECT Id,Apttus_QPConfig__Proposald__c,Apttus_QPConfig__Proposald__r.NokiaCPQ_Portfolio__c, toLabel(Apttus_QPConfig__Proposald__r.CPQ_SubPortfolio__c)pickval  FROM Apttus_Config2__ProductConfiguration__c WHERE ID=:strConfigId Limit 1';
			
			for (Apttus_Config2__ProductConfiguration__c conf : Database.query(soqlconfi)){
	picklistlabels = (string)conf.Apttus_QPConfig__Proposald__r.get('pickval');
	validPortfolios = picklistlabels != null ? picklistlabels.split(';') : conf.Apttus_QPConfig__Proposald__r.NokiaCPQ_Portfolio__c.split(';');
			}

			Map<String, String> mapPickListValues2 = new Map<String, String> ();
			if(string.isNotBlank(picklistlabels)){
	mapPickListValues2 = Nokia_CPQ_Utility.getPicklistValuesByLabel('Apttus_Proposal__Proposal__c','CPQ_SubPortfolio__c',validPortfolios);
			}
			else if(!validPortfolios.isEmpty()){
	mapPickListValues2.put(validPortfolios[0],validPortfolios[0]);
			}

			return mapPickListValues2;
		}
		catch(Exception ex) {
			ExceptionHandler.addException(ex,SearchProduct.class.getName(),'getSubPortfolioPicklistEntry');
		}
		return null;
	}//<---FN_End-->
}