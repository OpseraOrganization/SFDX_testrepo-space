/*
 * Purpose : This class handles the functionality of CUSTOM REPRICE
 * Explain the CPQ PRICING FLOW.
 * Created Date : MAY-15-2018
 * Created By : Shubham Bhatt
 */
 
public with sharing class CPQ_CustomReprice_Controller {
	
	//public String productConfigId;
	public String quoteId;
	public String configRequestId;
	public string currentFlow;
	public String productConfigId {get; set;}
	public static Boolean isNokiaSoftware {get; set;}
	
	public CPQ_CustomReprice_Controller(){
		productConfigId = Apexpages.currentPage().getParameters().get('id');
		quoteId = Apexpages.currentPage().getParameters().get('retId');
		configRequestId = Apexpages.currentPage().getParameters().get('configRequestId');
		currentFlow = Apexpages.currentPage().getParameters().get('flow');
		isNokiaSoftware = false;

	}
	
	@RemoteAction
	public static boolean isNokiaSoftware(String cardID) { 
		return isNokiaSoftware;
	}
	
	public void ChangeStatus(){
		System.debug('********************** In ChangeStatus method : Product Config Ids ' + productConfigId);
	   
		 if (!String.isEmpty(productConfigId)){
		 
		 List <Apttus_Config2__ProductConfiguration__c> prodConfigList = [Select id,Apttus_QPConfig__Proposald__r.NokiaCPQ_Portfolio__c 
																		 FROM Apttus_Config2__ProductConfiguration__c 
																		 WHERE id =: productConfigId limit 1];
			if(prodConfigList != null && prodConfigList.size() > 0){
				
				String portfolio = prodConfigList.get(0).Apttus_QPConfig__Proposald__r.NokiaCPQ_Portfolio__c;
				if(portfolio.equalsIgnoreCase('Nokia Software')){
					isNokiaSoftware = true;
				}else {
					isNokiaSoftware = false;
				}
			}
		}
	  }
	
	

	@RemoteAction
	public static Integer doReprice(String cartId) {
		system.debug('@@## doReprice cartID==> '+cartId); 
		Integer response = 2; 
		try {
			//FALSE == 0
			//TRUE == 1
			//FAILED == 2
			final Apttus_CpqApi.CPQ.UpdatePriceRequestDO upreqDO1 = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
			upreqDO1.CartId = cartId;
			Apttus_CpqApi.CPQ.UpdatePriceResponseDO uprespDO1 = Apttus_CpqApi.CPQWebService.updatePriceForCart(upreqDO1);
			if(uprespDO1.IsPricePending && !uprespDO1.PendingLineNumbers.isEmpty()){
				//DO Rec
				response = 1;
			}else{
				//NOT DO Rec
				response = 0;
			}
			system.debug('@@##$$%% doReprice response==> '+response);
			//SendEmail_Utility.SendEmail('Do Reprice', null, 'response : ' +response);
			return response;
			
		} catch (exception e) {
			system.debug('@@##$$%% doReprice exception response==> '+response);
			system.debug('***' + e.getMessage() + '**' + e.getLineNumber());
			return response;
		}
	}   
	

	@RemoteAction
	public static boolean changePricingStatus(String cartId) {
		
		system.debug('@@## changePricingStatus cartID==> '+cartId); 
		List<Apttus_Config2__LineItem__c> cartLineItems = new List<Apttus_Config2__LineItem__c>();
		try {
			if (!String.isEmpty(cartId)){
				cartLineItems = [select ID,Apttus_Config2__PricingStatus__c,Apttus_Config2__IsOptionRollupLine__c 
								 from Apttus_Config2__LineItem__c
								 where  
								 Apttus_Config2__ConfigurationId__c = :cartId];
				System.debug('*************************** Total Cart Line Items :  ' + cartLineItems.size());
				if (!cartLineItems.isEmpty()){
					for (Apttus_Config2__LineItem__c objVar : cartLineItems){
						 
						 objVar.Apttus_Config2__PricingStatus__c = 'Pending';
						//objVar.Apttus_Config2__ConfigStatus__c = 'Pending';
						//objVar.Apttus_Config2__ConstraintCheckStatus__c = 'Pending';  
						
					}
					Update cartLineItems; // Updating Status IN Line Item Ext Obj
				}										   
				
			}
			return true;
		} catch (exception e) {
			system.debug('***' + e.getMessage() + '**' + e.getLineNumber());
			return false;
		}
	}

		
	
	public Pagereference redirectToCart(){
	
		PageReference cartDetailPage;
		if (currentFlow  == 'Default'){
			cartDetailPage = System.Page.Apttus_Config2__CartDetailView; 
		}
		else{
			cartDetailPage = System.Page.Apttus_Config2__Cart;		
		}
		cartDetailPage.getParameters().put('Id', productConfigId);
		cartDetailPage.getParameters().put('configRequestId', configRequestId);
		return cartDetailPage;
	}
	
	
	@RemoteAction
	public static boolean calculateRollups(String cartId){
	   
		try{
		String debugTest = '';
		List<Apttus_Config2__LineItem__c> allItems = null;
																
		List<Apttus_Config2__ProductConfiguration__c> prodConfig = [Select id,Apttus_Config2__BusinessObjectId__c FROM 
																	Apttus_Config2__ProductConfiguration__c WHERE id = :cartId limit 1] ;													  
		
		Apttus_Proposal__Proposal__c proposalSO  = [SELECT Id, CurrencyIsoCode, Name, Apttus_Proposal__Opportunity__c, Apttus_Proposal__Account__c,
				NokiaCPQ_Existing_FN_Maint_Contract__c, NokiaCPQ_Existing_IONMaint_Contract__c, NokiaCPQ_FN_Maintenance_Type__c, NokiaCPQ_ION_Maintenance_Type__c,
				NokiaCPQ_SSP_Level__c, NokiaCPQ_SRS_Level__c, NokiaCPQ_Maintenance_Accreditation__r.Portfolio__c, NokiaCPQ_Maintenance_Accreditation__r.Pricing_Cluster__c,
				NokiaCPQ_Portfolio__c, NokiaCPQ_Maintenance_Type__c, NokiaCPQ_No_of_Years__c, NokiaProductAccreditation__r.Portfolio__c, NokiaProductAccreditation__r.Pricing_Cluster__c,
				NokiaCPQ_IsPMA__c, NokiaProductAccreditation__r.Pricing_Accreditation__c, NokiaCPQ_Maintenance_Accreditation__r.Pricing_Accreditation__c, Quote_Type__c,
				exchange_rate__c, Apttus_Proposal__Account__r.Name, Apttus_Proposal__Account__r.Id, Apttus_Proposal__Account__r.Partner_Program__c,
				Apttus_Proposal__Account__r.Partner_Type__c, Apttus_Proposal__Account__r.SFCCLtngPtr__Partner_Type__c, Apttus_Proposal__Account__r.SFCCLtngPtr__Partner_Program_Level__c,
				Apttus_Proposal__Account__r.NokiaCPQ_Renewal__c, Apttus_Proposal__Account__r.NokiaCPQ_Performance__c, Apttus_Proposal__Account__r.NokiaCPQ_Attachment__c,
				NokiaCPQ_SRS_Per__c FROM Apttus_Proposal__Proposal__c WHERE Id =: prodConfig.get(0).Apttus_Config2__BusinessObjectId__c ];
		 
		
		Integer numberOfYears = Integer.ValueOf(proposalSO.NokiaCPQ_No_of_Years__c);
		Decimal dExchangeRate = proposalSO.Exchange_Rate__c;
		List < Apttus_Config2__LineItem__c > listBundleLineItem = new List < Apttus_Config2__LineItem__c > ();
		List < Apttus_Config2__LineItem__c > listOptionLineItem = new List < Apttus_Config2__LineItem__c > ();
		Map < String, Apttus_Config2__LineItem__c > mapSRSOptions = new Map < String, Apttus_Config2__LineItem__c > ();
		   
				
		if (proposalSO.NokiaCPQ_Portfolio__c != null && proposalSO.NokiaCPQ_Portfolio__c.equals('Nokia Software')) {
			
			 Set < String > nokiaSoftwareProductCodes = new Set <String> ();
			// Fetch the Product-Codes from Custom-Meta Data Type for Data-Refinery and FasterMind Products
			List < Nokia_Software__mdt > listData = [Select id, MasterLabel, Product_Codes__c from Nokia_Software__mdt];
			String sProductcodes = null;
			If(listData != null && listData.size() > 0) {
				for (Nokia_Software__mdt oNokiaSoftware: listData) {
					sProductcodes = oNokiaSoftware.Product_Codes__c;
					List < String > productCodeList = sProductcodes.split(',');

					if (oNokiaSoftware.MasterLabel.equals('Data Refinery')) {
						nokiaSoftwareProductCodes.addall(productCodeList);
					}
					if (oNokiaSoftware.MasterLabel.equals('Fastermind')) {
						nokiaSoftwareProductCodes.addAll(productCodeList);
					}

				} // end of for loop 
				debugTest = '';
				debugTest = debugTest + nokiaSoftwareProductCodes.size();
				//SendEmail_Utility.SendEmail('Controller NokiaSoftwareProductCodes : - ', null, debugTest); 
			} // 
		
		   allItems = [SELECT Id,Apttus_Config2__LineType__c,Apttus_Config2__IsOptionRollupLine__c,Apttus_Config2__ProductId__c,Apttus_Config2__LineNumber__c,Apttus_Config2__PrimaryLineNumber__c,
																NokiaCPQ_Part_Number__c,Apttus_Config2__ProductId__r.Name,
																Apttus_Config2__Quantity__c,Apttus_Config2__ExtendedQuantity__c,Apttus_Config2__TotalQuantity__c,Nokia_Total_Quantity_SRS__c,Apttus_Config2__PricingStatus__c,
																Apttus_Config2__OptionId__r.Name,Apttus_Config2__NetPrice__c,Apttus_Config2__AttributeValueId__r.How_is_the_licence_pricing_done__c
																FROM Apttus_Config2__LineItem__c WHERE  Apttus_Config2__ConfigurationId__c = :cartId];
		 
		 
		
		 Decimal dTotalNetPrice = 0.0;
		 boolean isDataRefinerySRSExists = false;
		 boolean isFasterMindSRSExists = false;
		
		 // Iterate over Line-Items to create a list of Bundle & List of Options 
				for (Apttus_Config2__LineItem__c item : AllItems) {
					
					if (item != null) {
						
						if (item.Apttus_Config2__LineType__c.equalsIgnoreCase('Product/Service') && !item.Apttus_Config2__IsOptionRollupLine__c) {
							listBundleLineItem.add(item);
							
						} else if (item.Apttus_Config2__LineType__c.equalsIgnoreCase('Option')) {
							listOptionLineItem.add(item);

							if (item.Apttus_Config2__OptionId__r.Name.equalsIgnoreCase(Nokia_CPQ_Constants.DATA_REFINERY_SRS)) {
								isDataRefinerySRSExists = true;
							}

							if (item.Apttus_Config2__OptionId__r.Name.equalsIgnoreCase(Nokia_CPQ_Constants.FASTER_MIND_SRS)) {
								isFasterMindSRSExists = true;
							}

						}
					}
				} // End of For Loop

				// If SRS options doesn't exists for Data-Ref & Fastermind, exit the flow. 
				if (!(isFasterMindSRSExists || isDataRefinerySRSExists)) {
					system.debug('SRS doesnot exists');
					return true;
				}
				
				debugTest = '';
				debugTest = debugTest + 'option:Size :' + listOptionLineItem.size() + 'Bundle : Size ' + listBundleLineItem.size() + ':Data-Ref : exists' + isDataRefinerySRSExists + 'fasterMind:exists' + isFasterMindSRSExists;
				//SendEmail_Utility.SendEmail('Controller ', null, debugTest);
				
				// Iterate over Bundle
				for (Apttus_Config2__LineItem__c bItem: listBundleLineItem) {
				   
					dTotalNetPrice = 0.0;

					for (Apttus_Config2__LineItem__c oItem: listOptionLineItem) {

						if (oItem.Apttus_Config2__ProductId__c == bItem.Apttus_Config2__ProductId__c && oItem.Apttus_Config2__LineNumber__c == bItem.Apttus_Config2__LineNumber__c) {

							// find the corresponding line-Item for Data-Refinery
							if (oItem.Apttus_Config2__PrimaryLineNumber__c > bItem.Apttus_Config2__PrimaryLineNumber__c && nokiaSoftwareProductCodes.contains(oItem.NokiaCPQ_Part_Number__c)) {
								dTotalNetPrice = dTotalNetPrice + oItem.Apttus_Config2__NetPrice__c;
							}
							// Store the SRS option for Data-Refinery.
							if (oItem.Apttus_Config2__OptionId__r.Name.equalsIgnoreCase(Nokia_CPQ_Constants.DATA_REFINERY_SRS) ||
								oItem.Apttus_Config2__OptionId__r.Name.equalsIgnoreCase(Nokia_CPQ_Constants.FASTER_MIND_SRS)) {
								mapSRSOptions.put(bItem.Apttus_Config2__ProductId__r.Name, oItem);

							}
						}

					} // End of for loop for option
					debugTest = '';
					debugTest = debugTest + ' Product-Name :  ' + bItem.Apttus_Config2__ProductId__r.Name + 'total Net Price : ' + dTotalNetPrice;
					//SendEmail_Utility.SendEmail('Controller ', null, debugTest);

					
					// Fetch the Optiona Item and calcuate the rest of Quantity.
					Apttus_Config2__LineItem__c oSRSLineItem = mapSRSOptions.get(bItem.Apttus_Config2__ProductId__r.Name);
					// update the quantity of SRS
					if (oSRSLineItem != null) {
						oSRSLineItem.Nokia_Total_Quantity_SRS__c = calculateTotalQuantityForSRSDataRef(dTotalNetPrice, bItem, numberOfYears, dExchangeRate,proposalSO);
						mapSRSOptions.put(bItem.Apttus_Config2__ProductId__r.Name, oSRSLineItem);
						
						debugTest = '';
						debugTest = debugTest + ' Product-Name :  ' + bItem.Apttus_Config2__ProductId__r.Name + 'total Net Price : ' + oSRSLineItem.Nokia_Total_Quantity_SRS__c;
						//SendEmail_Utility.SendEmail('Controller ', null, debugTest);

					}

				} //End of For loop for Bundle
				
				List<Apttus_Config2__LineItem__c> listtoUpdated = new List<Apttus_Config2__LineItem__c>();

				// Iterate over the options and set the Quantity
				for (String fieldName: mapSRSOptions.keySet()) {

					if (fieldName.equalsIgnoreCase(Nokia_CPQ_Constants.DATA_REFINERY)) {
						Apttus_Config2__LineItem__c oDataRefSRSLineItem = mapSRSOptions.get(Nokia_CPQ_Constants.DATA_REFINERY);
						Apttus_Config2__LineItem__c oBundle = null;
						
						if (oDataRefSRSLineItem != null && oDataRefSRSLineItem.Apttus_Config2__Quantity__c != oDataRefSRSLineItem.Nokia_Total_Quantity_SRS__c) {
							oDataRefSRSLineItem.Apttus_Config2__Quantity__c = oDataRefSRSLineItem.Nokia_Total_Quantity_SRS__c;
							oDataRefSRSLineItem.Apttus_Config2__ExtendedQuantity__c = oDataRefSRSLineItem.Apttus_Config2__Quantity__c;
							oDataRefSRSLineItem.Apttus_Config2__TotalQuantity__c = oDataRefSRSLineItem.Apttus_Config2__Quantity__c;
							oDataRefSRSLineItem.Apttus_Config2__PricingStatus__c = 'Pending';
							listtoUpdated.add(oDataRefSRSLineItem);
						}

					}

					if (fieldName.equalsIgnoreCase(Nokia_CPQ_Constants.FASTER_MIND)) {

						Apttus_Config2__LineItem__c oSRSLineItem = mapSRSOptions.get(Nokia_CPQ_Constants.FASTER_MIND);
						Apttus_Config2__LineItem__c oBundle = null;
						
						if (oSRSLineItem != null && oSRSLineItem.Apttus_Config2__Quantity__c != oSRSLineItem.Nokia_Total_Quantity_SRS__c) {
							oSRSLineItem.Apttus_Config2__Quantity__c = oSRSLineItem.Nokia_Total_Quantity_SRS__c;
							oSRSLineItem.Apttus_Config2__ExtendedQuantity__c = oSRSLineItem.Apttus_Config2__Quantity__c;
							oSRSLineItem.Apttus_Config2__TotalQuantity__c = oSRSLineItem.Apttus_Config2__Quantity__c;
							
							oSRSLineItem.Apttus_Config2__PricingStatus__c = 'Pending';
							listtoUpdated.add(oSRSLineItem);
						
						}
					}
				} // End of For-Loop.
				
				
			if(!listtoUpdated.isEmpty()){
				update listtoUpdated;
				debugTest = 'Complete';
			}
		} // End of outer-if
		
			//SendEmail_Utility.SendEmail('Controller ', null, debugTest);
			return true;
		
		}catch(Exception ex){
		   // SendEmail_Utility.SendEmail('Controller ', null, 'Excpetion');
			return false;
		} 
		
	}
	
	
	/** 
	 
	 * This code has written to Fix Quantiy & Pricing Issue for Data-Refinery & FasterMind Products of Nokia Software division
	  Support Ticket : 12088
	  The code will only execute for Portfolio__c 'Nokia Sotware'  
	  This method further calculates quantity based on Attribute Value selected by user 
	  
	  */

	
	private static Decimal calculateTotalQuantityForSRSDataRef(Decimal dTotalNetPrice, Apttus_Config2__LineItem__c oMainBundle, Integer oNumberOfYears, Decimal dExchangeRate,Apttus_Proposal__Proposal__c proposalSO) {
		try {

			if (proposalSO.NokiaCPQ_Maintenance_Type__c.equalsIgnoreCase('Basic (8x5)')) {

				if (oMainBundle.Apttus_Config2__AttributeValueId__r.How_is_the_licence_pricing_done__c.equalsIgnoreCase('Subscription')) {
					dTotalNetPrice = dTotalNetPrice * 3 * .001 * .09 * oNumberOfYears;
				} else {
					dTotalNetPrice = dTotalNetPrice * .001 * .09 * oNumberOfYears;
				}
			} else if (proposalSO.NokiaCPQ_Maintenance_Type__c.equalsIgnoreCase('Gold (24x7)')) {

				if (oMainBundle.Apttus_Config2__AttributeValueId__r.How_is_the_licence_pricing_done__c.equalsIgnoreCase('Subscription')) {
					dTotalNetPrice = dTotalNetPrice * 3 * .001 * .125 * oNumberOfYears;
				} else {
					dTotalNetPrice = dTotalNetPrice * .001 * .125 * oNumberOfYears;
				}
			} else if (proposalSO.NokiaCPQ_Maintenance_Type__c.equalsIgnoreCase('Platinum (higher SLA)')) {

				if (oMainBundle.Apttus_Config2__AttributeValueId__r.How_is_the_licence_pricing_done__c.equalsIgnoreCase('Subscription')) {
					dTotalNetPrice = dTotalNetPrice * 3 * .001 * .155 * oNumberOfYears;
				} else {
					dTotalNetPrice = dTotalNetPrice * .001 * .155 * oNumberOfYears;
				}
			}

			dTotalNetPrice = dTotalNetPrice / dExchangeRate;
			dTotalNetPrice = Math.ceil(dTotalNetPrice);
		} catch (Exception Ex) {
			System.debug('Exception calculateTotalQuantityForSRSDataRef' + ex.getMessage());
		}
		return dTotalNetPrice;

	}
	
}


		 /*	  //getting all cart line items
		List<Apttus_Config2__LineItem__c> cartLineItems = new List<Apttus_Config2__LineItem__c>();
		try {
			if (!String.isEmpty(productConfigId)){
				cartLineItems = [select ID,Apttus_Config2__PricingStatus__c 
								from Apttus_Config2__LineItem__c
								where  
								Apttus_Config2__ConfigurationId__c = :productConfigId];
				System.debug('*************************** Total Cart Line Items :  ' + cartLineItems.size());
				if (!cartLineItems.isEmpty()){
					  for (Apttus_Config2__LineItem__c objVar : cartLineItems){
						  objVar.Apttus_Config2__PricingStatus__c = 'Pending';
						//objVar.Apttus_Config2__ConfigStatus__c = 'Pending';
					   // objVar.Apttus_Config2__ConstraintCheckStatus__c = 'Pending';  
						  
					  }
						Update cartLineItems; // Updating Status IN Line Item Ext Obj
					}										   

				}

		}
		catch(Exception ex){
			 
		} */