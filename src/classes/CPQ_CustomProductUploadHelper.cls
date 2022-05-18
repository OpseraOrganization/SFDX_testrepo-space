/*************************************************************
   @Name: CPQ_CustomProductUploadHelper
   @Author: Siva
   @CreateDate: 01/26/2022
   @Description: This class contains common methods used in Uploads related  PreapprovedCustomProduct,CSV BulkUpload classes
 ******************************************************************/
public inherited sharing class CPQ_CustomProductUploadHelper {
public static Map<String,SearchProductWrapper> getLineItemValue(Apttus_Config2__ProductConfiguration__c prodConfigRecord,ID strConfigId, List<String> subPortfolioList) {		//FN-Added
	Map<String,SearchProductWrapper> mapsubPortfolioWithWrapper = new Map<String,SearchProductWrapper>();//FN-Added
	try {

		SearchProductWrapper objwrapper = new SearchProductWrapper();

		Map<String,String> mapsubPortfolioWithPricingAccred = new Map<String,String>();//FN-Added
		Map<String,Decimal> mapsubPortfolioWithiIncotermPercentage = new Map<String,Decimal>();//FN-Added
		Map<String,Decimal> mapsubPortfolioWithAccredDiscount = new Map<String,Decimal>();//FN-Added
		Set<String> subPortfolioSet = new Set<String>(subPortfolioList);//FN-Added
		objwrapper = getDetailsProduct(objwrapper);

		objwrapper.strGlobalPriceListItemID = createPriceLineItems(objwrapper.strProductID, prodConfigRecord.Apttus_Config2__PriceListId__c);
		objwrapper.str1Year = prodConfigRecord.Apttus_QPConfig__Proposald__r.NokiaCPQ_No_of_Years__c;
		objwrapper.strGlobalPriceListID = prodConfigRecord.Apttus_Config2__PriceListId__c;
		// strPortfolio Not used anywhere so not setting this as per CSV row wise
		objwrapper.strPortfolio = prodConfigRecord.NokiaCPQ_Portfolio_From_Quote__c;
		List<Nokia_CPQ_SSP_SRS_Default_Values__mdt> mdt = [Select Portfolio__c, SSP_Visible__c, SRS_Visible__c, SRS_Percentage__c,
													 Tier_Discount_Applicable__c, AccountLevel_Discount_Applicable__c, Multi_Year_Discount_Applicable__c
													 From Nokia_CPQ_SSP_SRS_Default_Values__mdt where Portfolio__c = :prodConfigRecord.NokiaCPQ_Portfolio_From_Quote__c LIMIT 1];
		if(!mdt.isEmpty()) {
			objwrapper.dSRSPercentage = mdt[0].SRS_Percentage__c;
		}
		/*objwrapper.dSRSPercentage = [Select Portfolio__c, SSP_Visible__c, SRS_Visible__c, SRS_Percentage__c,
							  Tier_Discount_Applicable__c, AccountLevel_Discount_Applicable__c, Multi_Year_Discount_Applicable__c
							  From Nokia_CPQ_SSP_SRS_Default_Values__mdt where Portfolio__c = :prodConfigRecord.NokiaCPQ_Portfolio_From_Quote__c LIMIT 1].SRS_Percentage__c;*///to confirm with Koen

		//defect 13889 Heema/13944
		if (prodConfigRecord.Apttus_QPConfig__Proposald__r.NokiaCPQ_LEO_Discount__c == true && prodConfigRecord.Apttus_QPConfig__Proposald__r.NokiaCPQ_No_of_Years__c.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_1YEAR)) {
			objwrapper.dSRSPercentage = 0.0;
			objwrapper.isLEO = true;
		}

		if (Nokia_CPQ_Constants.QUOTE_TYPE_INDIRECTCPQ.equalsIgnoreCase(prodConfigRecord.Quote_Type__c)) {

			/*objwrapper.strPricingAccred = [select Pricing_Accreditation__c from Accreditation__c where id = :prodConfigRecord.Apttus_QPConfig__Proposald__r.NokiaProductAccreditation__c].Pricing_Accreditation__c;
	  objwrapper.iIncotermPercentage = [select NokiaCPQ_Incoterm_Percentage__c from Accreditation__c where id = :prodConfigRecord.Apttus_QPConfig__Proposald__r.NokiaProductAccreditation__c].NokiaCPQ_Incoterm_Percentage__c;
	  string strGPPversion = [select Partner_Program__c from Accreditation__c where id = :prodConfigRecord.Apttus_QPConfig__Proposald__r.NokiaProductAccreditation__c].Partner_Program__c;
	  System.debug('[+] strGPPversion = '+strGPPversion);
	  System.debug('[+] objwrapper.strPricingAccred ='+objwrapper.strPricingAccred);
	  System.debug('[+] Partner Program = '+strGPPversion);*/

			/**FN START*******/
			string strGPPversion = prodConfigRecord.Apttus_Config2__AccountId__r.Partner_Program__c;
			List<Accreditation__c> validAccred= [select Id,name,Pricing_Level_Override__c,Portfolio__c,Accreditation_Type__c,Pricing_Accreditation__c,NokiaCPQ_Incoterm_Percentage__c
										FROM Accreditation__c WHERE Partner__c =:prodConfigRecord.Apttus_Config2__AccountId__c and Accreditation_Type__c= 'Product' AND Portfolio__c IN: subPortfolioSet];
			System.debug('validAccred>>'+validAccred);
			for(Accreditation__c accred:validAccred) {
	mapsubPortfolioWithPricingAccred.put(accred.Portfolio__c,accred.Pricing_Accreditation__c);
	mapsubPortfolioWithiIncotermPercentage.put(accred.Portfolio__c,accred.NokiaCPQ_Incoterm_Percentage__c);
			}


			/**FN END*******/

			//Added by RG for LOE check Start
			if (prodConfigRecord.Apttus_QPConfig__Proposald__r.NokiaCPQ_LEO_Discount__c) {
	/*string str = 'NokiaCPQ LEO Discount IPR NUA OPT ' + strGPPversion;
	   string strruleSetID = [select id, NokiaCPQ_Partner_Program__c from Apttus_Config2__PriceRuleset__c
						where NokiaCPQ_Partner_Program__c = :strGPPversion and
															NokiaCPQ_Cluster_Tiers__c = 'LEO' and name = :str].id;
	   objwrapper.strAccredDiscount = [select Apttus_Config2__AdjustmentAmount__c from Apttus_Config2__PriceRuleEntry__c where Apttus_Config2__Dimension1Value__c = :prodConfigRecord.NokiaCPQ_Portfolio_From_Quote__c and Apttus_Config2__PriceRuleId__r.Apttus_Config2__RulesetId__c = :strruleSetID].Apttus_Config2__AdjustmentAmount__c;
	   System.debug('strruleSetID>>>' + strruleSetID);
	   System.debug('objwrapper.strAccredDiscount>>>' + objwrapper.strAccredDiscount);

	   /**FN START*******/
	string pricingCluster = prodConfigRecord.Apttus_QPConfig__Proposald__r.NokiaCPQPricing_Cluster__c;

	List<CPQ_ProductDiscountRules__c> validPDR = [select CPQ_ProductDiscountPer__c, CPQ_PricingCluster__c,CPQ_Portfolio__c
												  FROM CPQ_ProductDiscountRules__c WHERE CPQ_PartnerProgram__c =: strGPPversion
																												 AND CPQ_ProductDiscountCategory__c = null AND CPQ_DiscountType__c = 'LEO' AND CPQ_Portfolio__c IN: subPortfolioSet];


	for(CPQ_ProductDiscountRules__c priceDiscRule:validPDR) {
		mapsubPortfolioWithAccredDiscount.put(priceDiscRule.CPQ_Portfolio__c,priceDiscRule.CPQ_ProductDiscountPer__c);
	}


	/**FN END*******/
			}
			else if(!mdt.isEmpty() && mdt[0].Tier_Discount_Applicable__c) { //added No tier discount for Nuage Quote ITCCPQ-3045-3048
	//Added by RG for LOE check End
	/*string strruleSetID = [select id, NokiaCPQ_Partner_Program__c from Apttus_Config2__PriceRuleset__c where NokiaCPQ_Partner_Program__c = :strGPPversion and name = 'NokiaCPQ Accreditation Level Discount GPP 3.0'].id;
	   System.debug('[+] strruleSetID = '+strruleSetID);
	   Apttus_Config2__PriceRuleEntry__c p = [select Apttus_Config2__AdjustmentAmount__c from Apttus_Config2__PriceRuleEntry__c
										where Apttus_Config2__Dimension1Value__c = :objwrapper.strPricingAccred and
																					Apttus_Config2__PriceRuleId__r.Apttus_Config2__RulesetId__c = :strruleSetID];
	   System.debug('[+] PriceRuleEntry id = '+p.Id);
	   System.debug('[+] PriceRuleEntry Apttus_Config2__AdjustmentAmount__c = '+p.Apttus_Config2__AdjustmentAmount__c);
	   objwrapper.strAccredDiscount = [select Apttus_Config2__AdjustmentAmount__c from Apttus_Config2__PriceRuleEntry__c
									where Apttus_Config2__Dimension1Value__c = :objwrapper.strPricingAccred and
																			Apttus_Config2__PriceRuleId__r.Apttus_Config2__RulesetId__c = :strruleSetID].Apttus_Config2__AdjustmentAmount__c;*/

	/**FN START*******/
	list<Tier_Discount_Detail__c > tierDiscList = [select id,NokiaCPQ_Pricing_Tier__c,Nokia_CPQ_Partner_Program__c,NokiaCPQ_Tier_Discount__c FROM Tier_Discount_Detail__c where
												   NokiaCPQ_Tier_Type__c  = 'Product' AND NokiaCPQ_Pricing_Tier__c IN: mapsubPortfolioWithPricingAccred.values()
																			AND Nokia_CPQ_Partner_Program__c  =: strGPPversion];//taking firs record - to be confirmed as it can have 4 records  with diff partner types

	for(Tier_Discount_Detail__c tierDisc:tierDiscList) {
		mapsubPortfolioWithAccredDiscount.put(tierDisc.NokiaCPQ_Pricing_Tier__c,tierDisc.NokiaCPQ_Tier_Discount__c);
	}
	System.debug(mapsubPortfolioWithAccredDiscount.size()+'-->mapsubPortfolioWithAccredDiscount-->'+mapsubPortfolioWithAccredDiscount);

	/**FN END*******/
			}
		}

		setLineItemsNumber(strConfigId, objwrapper);

		/**FN START*******/
		for(String subportfolio:subPortfolioSet) {

			SearchProductWrapper objwrapperNew = new SearchProductWrapper();
			objwrapperNew = objwrapper.clone();
			objwrapperNew.strPricingAccred = mapsubPortfolioWithPricingAccred.get(subportfolio);

			objwrapperNew.iIncotermPercentage = mapsubPortfolioWithiIncotermPercentage.get(subportfolio);

	objwrapperNew.strAccredDiscount = mapsubPortfolioWithAccredDiscount.get(objwrapperNew.strPricingAccred);

			mapsubPortfolioWithWrapper.put(subportfolio,objwrapperNew);

		}
		System.debug(mapsubPortfolioWithWrapper.size()+'-->mapsubPortfolioWithWrapper-->'+mapsubPortfolioWithWrapper);
		/**FN END*******/

	}


	catch(Exception e) {
		System.debug(e.getStackTraceString());
		ExceptionHandler.addException(e,CPQ_CustomProductUploadHelper.class.getName(),'getLineItemValue');
	}

	return mapsubPortfolioWithWrapper;
}
public static string createPriceLineItems(ID strProductId,ID idGlobalPl){
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
		}
		else
			return idExitingPli[0].id;

	}
	catch(Exception e) {
		System.debug(e.getStackTraceString());
	}
	return null;
}
// get the product detials to create line item
public static SearchProductWrapper getDetailsProduct(SearchProductWrapper objWrapper) {
	try{
		Product2 objProd = [select id, Name,ProductCode,Description,NokiaCPQ_Product_Discount_Category__c from product2 where ProductCode=:Nokia_CPQ_Constants.CUSTPROD001 LIMIT 1][0];

		objwrapper.strProductID = objProd.id;
		objwrapper.strProductCode = objProd.ProductCode;
		objwrapper.strProductName = objProd.Name;
		return objWrapper;
	}
	catch(Exception e) {
		System.debug(e.getStackTraceString());
	}
	return null;
}
// will set the line item number values
public static void setLineItemsNumber(ID idConfig,SearchProductWrapper objWrapper) {

	objWrapper.isLEO= false;
	Decimal iLineNumber = 0,iPrimaryNumber = 0, iItemSequence = 0;

	try {

		for( Apttus_Config2__LineItem__c objLineItem : [select id,Apttus_Config2__LineNumber__c,Apttus_Config2__PrimaryLineNumber__c,
												  Apttus_Config2__ItemSequence__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c=:idConfig ])

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
	catch(Exception e) {
		System.debug(e.getStackTraceString());
	}

}
public static Apttus_Config2__ProductConfiguration__c getProductConfig(ID strConfigId) {
	try
	{
		return [SELECT Id,Apttus_QPConfig__Proposald__r.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c,Apttus_QPConfig__Proposald__r.NokiaCPQ_Is_Maintenance_Quote__c,Quote_Type__c,NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c,NokiaCPQ_Portfolio_From_Quote__c,Apttus_QPConfig__Proposald__r.NokiaCPQ_LEO_Discount__c,Apttus_Config2__PriceListId__c,Apttus_QPConfig__Proposald__r.NokiaCPQ_Existing_IONMaint_Contract__c,Apttus_QPConfig__Proposald__r.NokiaCPQ_No_of_Years__c,Apttus_QPConfig__Proposald__c, Apttus_QPConfig__Proposald__r.Warranty_credit__c,Apttus_QPConfig__Proposald__r.NokiaCPQ_Maintenance_Type__c,Apttus_Config2__AccountId__c,Pricing_Cluster_Search_Filter__c,Apttus_QPConfig__Proposald__r.CPQ_SubPortfolio__c,Apttus_QPConfig__Proposald__r.NokiaCPQPricing_Cluster__c,Apttus_Config2__AccountId__r.Partner_Program__c,Apttus_QPConfig__Proposald__r.NokiaCPQ_Portfolio__c,CPQ_PortfolioClusterSF1__c,CPQ_PortfolioClusterSF2__c,CPQ_PortfolioClusterSF3__c,CPQ_PortfolioClusterSF4__c FROM Apttus_Config2__ProductConfiguration__c WHERE Id=: strConfigId LIMIT 1][0];
	}
	catch(Exception ex) {
		ExceptionHandler.addException(ex,CPQ_CustomProductUploadHelper.class.getName(),'getProductConfig');
	}
	return null;
}
//method will return either subportfolio or Porfolio values
public static List<string> getSubportfolioLabels(String strConfigId){

	string picklistlabels;
	List<String> validPortfolios;
	string soqlconfi = 'SELECT Id,Apttus_QPConfig__Proposald__c,Apttus_QPConfig__Proposald__r.NokiaCPQ_Portfolio__c, toLabel(Apttus_QPConfig__Proposald__r.CPQ_SubPortfolio__c)pickval  FROM Apttus_Config2__ProductConfiguration__c WHERE ID=:strConfigId Limit 1';
	List<Apttus_Config2__ProductConfiguration__c> configs = Database.query(soqlconfi);
	for (Apttus_Config2__ProductConfiguration__c conf : configs) {
		picklistlabels = (string)conf.Apttus_QPConfig__Proposald__r.get('pickval');
		validPortfolios = picklistlabels != null ? picklistlabels.split(';') : conf.Apttus_QPConfig__Proposald__r.NokiaCPQ_Portfolio__c.split(';');
		return validPortfolios;
	}
	return validPortfolios;
}



}