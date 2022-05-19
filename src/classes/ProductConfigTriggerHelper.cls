/*******************************
Class Name: ProductConfigTriggerHelper
Created By: 
Last Modified By: 
Last Modified Date: 
Description: 
*******************************/
public without sharing class ProductConfigTriggerHelper{
	/*****************************
*Method Name: calculatePrice
*Description: 
*Parameters: 
*Created By: 
*Last Modified By: 
*Last Modified Date: 
*******************************/ 
	public static String calculatePrice(Decimal currencyField){   
		system.debug('currencyField' + currencyField);
		String adjustedField = '';
		//if(currencyField != null && currencyField.setscale(2) >= 1){
		system.debug('>=1 ' +  String.valueOf(currencyField.setscale(Nokia_CPQ_Constants.Two)));
		if(String.valueOf(currencyField.setscale(Nokia_CPQ_Constants.Two)) != null && String.valueOf(currencyField.setscale(Nokia_CPQ_Constants.Two)).indexOf(Nokia_CPQ_Constants.DOT ) == Nokia_CPQ_Constants.minusOne){
			adjustedField = String.valueOf(currencyField.setscale(Nokia_CPQ_Constants.Two)) +  Nokia_CPQ_Constants.dotZero;
		}
		else if(String.valueOf(currencyField.setscale(Nokia_CPQ_Constants.Two)) != null && String.valueOf(currencyField.setscale(Nokia_CPQ_Constants.Two)).right(Nokia_CPQ_Constants.Two).contains(Nokia_CPQ_Constants.DOT)){
			adjustedField = String.valueOf(currencyField.setscale(Nokia_CPQ_Constants.Two)) + Nokia_CPQ_Constants.ZERO ;
		}
		else if(String.valueOf(currencyField.setscale(Nokia_CPQ_Constants.Two)) != null && String.valueOf(currencyField.setscale(Nokia_CPQ_Constants.two)).right(Nokia_CPQ_Constants.Three).contains(Nokia_CPQ_Constants.DOT)){
			adjustedField = String.valueOf(currencyField.setscale(Nokia_CPQ_Constants.Two));
		}
		//}
		/*else if(currencyField != null && currencyField.setscale(2) < 1){
system.debug('<1 ' + String.valueOf(currencyField.setscale(2)));
if(String.valueOf(currencyField.setscale(2)) != null && String.valueOf(currencyField.setscale(2)).indexOf('.') == -1){
adjustedField = String.valueOf(currencyField.setscale(2)) + '.00';
}
else if(String.valueOf(currencyField.setscale(2)) != null && String.valueOf(currencyField.setscale(2)).right(2).contains('.')){
adjustedField = String.valueOf(currencyField.setscale(2)) + '0';
}
else if(String.valueOf(currencyField.setscale(2)) != null && String.valueOf(currencyField.setscale(2)).right(3).contains('.')){
adjustedField = String.valueOf(currencyField.setscale(2));
}
}*/
		return adjustedField;
	}
	
	/************************************
* Method :  updateFieldsOnProdConfig
* Paramater: List<Apttus_Config2__ProductConfiguration__c>
* Comments: Used to assign values to fields before creation of Product Configuration
* Created By: Piyush Tawari 26-09-2019 
* Nokia CPQ REQ:6624  
* ************************************/
	public static void updateFieldsOnProdConfig(List<Apttus_Config2__ProductConfiguration__c> prodConfigList)
	{
		Map<Id,Apttus_Proposal__Proposal__c> quoteMap = new Map<Id,Apttus_Proposal__Proposal__c>();
		Set<Id> quoteIdSet = new Set<Id>();
		try{
			if(!prodConfigList.isEmpty())
			{
	for(Apttus_Config2__ProductConfiguration__c config : prodConfigList)
	{
		if(String.isNotBlank(config.Apttus_QPConfig__Proposald__c))
			quoteIdSet.add(config.Apttus_QPConfig__Proposald__c);
	}
	if(quoteIdSet.size() > 0)
	{
		for(Apttus_Proposal__Proposal__c quote : [Select Id,End_Customer_Country_Code__c,NokiaCPQ_Portfolio__c,NokiaCPQ_Existing_IONMaint_Contract__c,NokiaCPQ_LEO_Discount__c,NokiaCPQPricing_Cluster__c,
				 Quote_Type__c,NokiaCPQ_Is_Maintenance_Quote__c,NokiaCPQ_Maintenance_Level__c,
				 NokiaCPQ_No_of_Years__c,NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c,
				 Warranty_credit__c
	 from Apttus_Proposal__Proposal__c 
				 where id in:quoteIdSet
				 LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
		{
			quoteMap.put(quote.Id,quote);
		}
		
		for(Apttus_Config2__ProductConfiguration__c config : prodConfigList)
		{
			if(quoteMap.containsKey(config.Apttus_QPConfig__Proposald__c)){
				if(quoteMap.get(config.Apttus_QPConfig__Proposald__c).Quote_Type__c!= Null)
		config.NokiaCPQ_Quote_Type__c = quoteMap.get(config.Apttus_QPConfig__Proposald__c).Quote_Type__c;
				if(quoteMap.get(config.Apttus_QPConfig__Proposald__c).NokiaCPQ_Portfolio__c != Null)
		config.NokiaCPQ_Portfolio__c = quoteMap.get(config.Apttus_QPConfig__Proposald__c).NokiaCPQ_Portfolio__c;
				if(quoteMap.get(config.Apttus_QPConfig__Proposald__c).NokiaCPQPricing_Cluster__c != Null)
		config.NokiaCPQ_Pricing_Cluster__c = quoteMap.get(config.Apttus_QPConfig__Proposald__c).NokiaCPQPricing_Cluster__c;
		if(quoteMap.get(config.Apttus_QPConfig__Proposald__c).  End_Customer_Country_Code__c != Null)
		config.PCcountry__c = quoteMap.get(config.Apttus_QPConfig__Proposald__c).End_Customer_Country_Code__c;
				
				
				//Heema : Re 6593
				if(/*quoteMap.get(config.Apttus_QPConfig__Proposald__c).NokiaCPQ_LEO_Discount__c ==  true && quoteMap.get(config.Apttus_QPConfig__Proposald__c).NokiaCPQ_Existing_IONMaint_Contract__c.equalsIgnoreCase('No') && */quoteMap.get(config.Apttus_QPConfig__Proposald__c).NokiaCPQ_No_of_Years__c=='1'){
		config.NokiaCPQ_IsMainSSPAdded__c = true;
				}
				//heema ITCEPP-747
				if(quoteMap.get(config.Apttus_QPConfig__Proposald__c).NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c ==  true && quoteMap.get(config.Apttus_QPConfig__Proposald__c).Quote_Type__c==Nokia_CPQ_Constants.QUOTE_TYPE_DIRECTCPQ){
		config.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c = true;
		}
 
				if(quoteMap!=null && quoteMap.get(config.Apttus_QPConfig__Proposald__c).Quote_Type__c!=Nokia_CPQ_Constants.directDS && config.Apttus_Config2__BusinessObjectType__c.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_PROPOSAL) && config.NokiaCPQ_Portfolio_From_Quote__c!=Nokia_CPQ_Constants.QTC_PORTFOLIO){
		if(quoteMap.get(config.Apttus_QPConfig__Proposald__c).NokiaCPQ_LEO_Discount__c){
			config.Search_Filter_Leo__c = true;
		}
		else{
			config.Search_Filter_Leo__c = false;
		}
				}
	//Sunidhar : Support ticket 01226506
				if(quoteMap.get(config.Apttus_QPConfig__Proposald__c).NokiaCPQ_Is_Maintenance_Quote__c
		&& quoteMap.get(config.Apttus_QPConfig__Proposald__c).Quote_Type__c == Nokia_CPQ_Constants.QUOTE_TYPE_INDIRECTCPQ 
		&& quoteMap.get(config.Apttus_QPConfig__Proposald__c).Warranty_credit__c == 'No'
		&& quoteMap.get(config.Apttus_QPConfig__Proposald__c).NokiaCPQ_No_of_Years__c=='1') {
				
			config.NokiaCPQ_IsMainSSPAdded__c = false;
				}
			}
		}
	}
			}
		}catch(Exception ex)
		{
			System.debug('ProductConfigTriggerHelper class and updateFieldsOnProdConfig Method '+ex.getCause()+ex.getLineNumber()+ex.getMessage());
			ExceptionHandler.addException(ex,Nokia_CPQ_Constants.updateFieldsOnProdConfig, Nokia_CPQ_Constants.ProductConfigTriggerHelper);
		}
	}
	/************************************
* Method :  updateFieldsOnProdConfig
* Paramater: List<Apttus_Config2__ProductConfiguration__c>
* Comments: Clear Sites on Configuration Line Item
* Created By: priyanka Agrawal 23-01-2019 
* Nokia CPQ REQ:6624  
* ************************************/
	public static void clearSiteOnConfiguration(Set<id> prodConfigSet)
	{
		List<Apttus_Config2__LineItem__c> lineItemList = new List<Apttus_Config2__LineItem__c>();
		try{
			if(!prodConfigSet.isEmpty())
			{
	for(Apttus_Config2__LineItem__c lineItem : [select id,NokiaCPQ_Opportunity_Site__c from Apttus_Config2__LineItem__c 
						where Apttus_Config2__ConfigurationId__c in: prodConfigSet
						LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
	{
		lineItem.NokiaCPQ_Opportunity_Site__c= null;
		lineItemList.add(lineItem);
	}
			}
	if(!lineItemList.isEmpty()){
		  database.update(lineItemList);  
	}
	
	}catch(Exception ex)
		{
			ExceptionHandler.addException(ex,'clearSiteOnConfiguration', Nokia_CPQ_Constants.ProductConfigTriggerHelper+ex.getLineNumber());
		}
	}

	/************************************
* Method :  updateFieldsOnProdConfig
* Paramater: List<Apttus_Config2__ProductConfiguration__c>  
* ************************************/
  
	  public static void gPPPricingToolLogic(List<Apttus_Config2__ProductConfiguration__c> prodConfig)
	{
		Integer count, temp_Quantity;
		count = Integer.valueof(prodConfig[0].Count_of_tempitems__c);
		List<Integer> primaryLines = new List<Integer>();
		//System.debug('prodConfig -->'+prodConfig);
		Apttus_Config2__ProductConfiguration__c pc = [Select id,Apttus_Config2__ContractNumbers__c,Apttus_QPConfig__Proposald__r.Project_Price_List_Number__c,NokiaCPQ_Quote_Type__c,NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c from Apttus_Config2__ProductConfiguration__c where id =:prodConfig[0].id limit 1];
		if(prodConfig[0].XAE_Flag__c == 'ADD_LineItem'){
			//System.debug('inside first if' + prodConfig[0].id);
			List <Apttus_CPQApi.CPQ.SelectedProductDO> selectedProdDOList = new List <Apttus_CPQApi.CPQ.SelectedProductDO>();	
			List<TempConfigItem__c> tempitems = [Select ID,ProductID__c, Quantity__c ,Sequence__c from TempConfigItem__c where ConfigItem_Product_Configuration__c = :prodConfig[0].id order by Sequence__c ASC];
			for(TempConfigItem__c ti: tempitems)
			{
	  
	 Apttus_CPQApi.CPQ.SelectedProductDO selProdDO = new Apttus_CPQApi.CPQ.SelectedProductDO();
	 selProdDO.ProductId = ti.ProductID__c;
	 selProdDO.Quantity = 1;
	selProdDO.Comments = 'Added by GPP Tool' + String.ValueOf(ti.Sequence__c);
	 selectedProdDOList.add(selProdDO);
	 temp_Quantity = Integer.valueof(ti.Quantity__c);  
			}   
			// Execute the addMultiProducts routine
			if(!selectedProdDOList.isEmpty() && selectedProdDOList != null && !test.isRunningTest()){
	Apttus_CPQApi.CPQ.AddMultiProductRequestDO request = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
	request.CartId = prodConfig[0].id;
	request.SelectedProducts = selectedProdDOList;
	Apttus_CPQApi.CPQ.AddMultiProductResponseDO response = Apttus_CPQApi.CPQWebService.addMultiProducts(request);
			}

			if(!tempitems.isEmpty()){
	database.delete(tempitems);
			}
	
			If((temp_Quantity == 2)/*|| (temp_Quantity == 1 && pc.NokiaCPQ_Quote_Type__c =='Direct CPQ' && pc.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c == false)*/)  //always one product will add
			{
	 ProductConfigTriggerHelper.gPPPricingToolConstRule(prodConfig[0].ID,pc.NokiaCPQ_Quote_Type__c,pc.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c);
			}
			else
			{
			Apttus_Config2__ProductConfiguration__c config = new Apttus_Config2__ProductConfiguration__c();
			config.Id = pc.id;
			//config.Apttus_Config2__ContractNumbers__c = pc.Apttus_QPConfig__Proposald__r.Project_Price_List_Number__c;
			//config.Apttus_Config2__Status__c = 'Saved';
			config.XAE_Flag__c = null;
			update config;
			}
			
		}
	 else if(prodConfig[0].XAE_Flag__c == 'sCRM')
		 {
	 
	pc.XAE_Flag__c = system.URL.getSalesforceBaseUrl().toExternalForm();
	update pc;
		 }
		 else if(prodConfig[0].XAE_Flag__c == 'sPRM'){
	Network myNetwork = [SELECT Id FROM Network WHERE Name ='Nokia Partner Portal'];
	ConnectApi.Community  myCommunity = ConnectApi.Communities.getCommunity(myNetwork.id);
	pc.XAE_Flag__c=  myCommunity.siteUrl;
	update pc;   
		 }
	}
	
	
	/************************************
* Method :  updateFieldsOnProdConfig
* Paramater: List<Apttus_Config2__ProductConfiguration__c>  
* ************************************/
   @future
	public static void gPPPricingToolConstRule(Id prodConfig,string quotetype, Boolean QWM)
	{
//	List<Integer> primaryLines = new List<Integer>();
		Id CartID = prodConfig;
		Boolean IsPricePending = true;
		List<string> errorMsgs = new List<string>();
		//List<string> warningMsgs = new List<string>();
		Integer numErrors = 0;
		//Integer numWarnings = 0;
		if((quotetype == 'Indirect CPQ' && QWM == false) || (quotetype == 'Direct CPQ' && QWM == true)){
		Apttus_CPQApi.CPQWebService.associateConstraintRules(CartID,null);
		Apttus_CPQApi.CPQWebService.applyConstraintRules(CartID, false);
		
		Apttus_CPQApi.CPQ.ConstraintResultDO constRuleResultDO = Apttus_CPQApi.CPQWebService.getConstraintRuleResult(CartID);
		List<Apttus_CPQApi.CPQ.AppliedActionDO> appliedActionDOList = constRuleResultDO.ConstraintRuleActions;
		
		for(Apttus_CPQApi.CPQ.AppliedActionDO appliedActDO:appliedActionDOList) {
	if(appliedActDO.MessageType.equals('Error') && appliedActDO.IsPending) {
			numErrors++;
			errorMsgs.add(appliedActDO.Message);
	}
		 /* else if(appliedActDO.MessageType.equals('Warning') && appliedActDO.IsPending) {
			numWarnings++;
			warningMsgs.add(appliedActDO.Message);
	}*/
		}
		}
	/*************  END of ConstraintRules   *************/
	if(numErrors < = 0 ) {
	  do{
		Apttus_CPQApi.CPQ.UpdatePriceRequestDO priceReqDO = new Apttus_CPQApi.CPQ.UpdatePriceRequestDO();
		priceReqDO.cartID = cartID;
		Apttus_CPQApi.CPQ.UpdatePriceResponseDO priceRespDO = Apttus_CPQApi.CPQWebService.updatePriceForCart(priceReqDO);   
		List<Decimal> complLineNums = priceRespDO.CompletedLineNumbers;
		IsPricePending = priceRespDO.IsPricePending;
		List<Decimal> PendingLineNumbers = priceRespDO.PendingLineNumbers;
		system.debug('IsPricePending :'+ IsPricePending);
	  }while(IsPricePending);
	}
	}


	/************************************
 * Method :  updateClusterSearchFieldsFromQuote
 * Paramater: List<Apttus_Config2__ProductConfiguration__c>
 * Comments: Used to assign values to fields before creation of Product Configuration
 * Created By: Christie 01-20-2022
 * ITCCPQ-2557
 * ************************************/
public static void updateClusterSearchFieldsFromQuote(List<Apttus_Config2__ProductConfiguration__c> prodConfigList)
{

	Map<String,List<Apttus_Config2__ProductConfiguration__c> > configProposalMap = new Map<String,List<Apttus_Config2__ProductConfiguration__c> >();


	for(Apttus_Config2__ProductConfiguration__c productConfiguration : prodConfigList) {
		String proposalId = productConfiguration.Apttus_QPConfig__Proposald__c;

		//List<Apttus_Config2__ProductConfiguration__c> prodConfigLists = new List<Apttus_Config2__ProductConfiguration__c>{productConfiguration};
		/*configProposalMap.put(proposalId,(configProposalMap.containsKey(proposalId) ? (List<Apttus_Config2__ProductConfiguration__c>)(configProposalMap.get(proposalId).addAll(prodConfigLists)) : prodConfigLists));*/

		if(!configProposalMap.containsKey(proposalId)) {
			configProposalMap.put(proposalId, new List<Apttus_Config2__ProductConfiguration__c> {productConfiguration});
		}
		else{
			configProposalMap.get(proposalId).add(productConfiguration);

		}
	}
	system.debug(configProposalMap);

	for(Apttus_Proposal__Proposal__c proposal : [SELECT CPQ_PortfolioClusterSF1__c,CPQ_PortfolioClusterSF2__c,CPQ_PortfolioClusterSF3__c,CPQ_PortfolioClusterSF4__c FROM Apttus_Proposal__Proposal__c WHERE ID IN:configProposalMap.keySet() AND Quote_Type__c =: Nokia_CPQ_Constants.QUOTE_TYPE_INDIRECTCPQ LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]) {
		for(Apttus_Config2__ProductConfiguration__c prodConfig : configProposalMap.get(proposal.Id)) {
			if(proposal.CPQ_PortfolioClusterSF1__c!=null && String.isNotBlank(proposal.CPQ_PortfolioClusterSF1__c))
	prodConfig.CPQ_PortfolioClusterSF1__c=proposal.CPQ_PortfolioClusterSF1__c;
			if(proposal.CPQ_PortfolioClusterSF2__c!=null && String.isNotBlank(proposal.CPQ_PortfolioClusterSF2__c))
	prodConfig.CPQ_PortfolioClusterSF2__c=proposal.CPQ_PortfolioClusterSF2__c;
			if(proposal.CPQ_PortfolioClusterSF3__c!=null && String.isNotBlank(proposal.CPQ_PortfolioClusterSF3__c))
	prodConfig.CPQ_PortfolioClusterSF3__c=proposal.CPQ_PortfolioClusterSF3__c;
			if(proposal.CPQ_PortfolioClusterSF4__c!=null && String.isNotBlank(proposal.CPQ_PortfolioClusterSF4__c))
	prodConfig.CPQ_PortfolioClusterSF4__c=proposal.CPQ_PortfolioClusterSF4__c;

		}

	}

}


}