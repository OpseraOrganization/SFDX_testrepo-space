/*******************************************************************************************
* @Name		 CPQ_ApplyDiscountsController 
* @Author	   Jithin Sreedharan <jithin.s.ext@nokia.com>
* @Date		 02/17/2021
* @Group		Surround
* @Description  Controller class for the Custom VF Page for applying discounts in surround qtc
*******************************************************************************************/
/* MODIFICATION LOG
* Version		  Developer		  Date			   Description
*-------------------------------------------------------------------------------------------
*  1.0			  Jithin	  02/17/2021		  Initial Creation													  
*******************************************************************************************/
public with sharing class CPQ_ApplyDiscountsController {
	

	public CPQ_ApplyDiscountsController() {

	}


	@AuraEnabled
	public static InitData initializePage(String cartId) {
		String errorMessage = '';
		try {
			InitData initData = new InitData();

			List<Apttus_Config2__LineItem__c> standaloneLineItems = [
				SELECT  
					Id, Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.ProductCode, Apttus_Config2__ProductId__r.Name, Apttus_Config2__ProductId__r.CPQ_Secondary_Category__c,CPQ_Contractual_Price_Condition__c, CPQ_Conditional_Price_Code__c, CPQ_Contractual_Discounts__c,CPQ_Contractual_Discounts_Applied__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.CPQ_Contractual_Price_Condition__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.CPQ_Contractual_Price_Condition_Code__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.CPQ_Contractual_Discounts_Updated__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.CPQ_Contractual_Condition_Updated__c
				FROM Apttus_Config2__LineItem__c
				WHERE
				Apttus_Config2__ConfigurationId__c = :cartId AND Apttus_Config2__LineType__c = 'Product/Service' AND Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c = 'Standalone' AND CPQ_Contracted_Price__c != null AND Apttus_Config2__BasePriceOverride__c = null
			];

			if(standaloneLineItems == null || standaloneLineItems.isEmpty()) {
				AuraHandledException auraError = new AuraHandledException('No discounts eligible line items found.');
				errorMessage = 'No discounts eligible line items found.';
				throw auraError;
			}
			//get master quote conditions & quoteId
			Id quoteId = standaloneLineItems[0].Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c;
			KeyValue masterCondition = new KeyValue(standaloneLineItems[0].Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.CPQ_Contractual_Price_Condition_Code__c, standaloneLineItems[0].Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.CPQ_Contractual_Price_Condition__c);
			
			//get quote level contractual discounts
			List<CPQ_QuoteContractualDiscount__c> quoteConditionList = [
				SELECT  
					Id, CPQ_Contractual_Disc_Method__c, CPQ_Code__c
				FROM CPQ_QuoteContractualDiscount__c
				WHERE CPQ_Proposal__c = :quoteId ORDER BY CPQ_Sequence__c ASC NULLS LAST
			];
			String masterContractualDiscounts = '';
			String masterContractualDiscountsWithId = '';
			for(CPQ_QuoteContractualDiscount__c discountEntry : quoteConditionList) {
				masterContractualDiscounts = masterContractualDiscounts + discountEntry.CPQ_Code__c + ';';
				masterContractualDiscountsWithId = masterContractualDiscountsWithId + discountEntry.CPQ_Code__c + '::' + discountEntry.Id + ';';
			}
			masterContractualDiscounts = masterContractualDiscounts.removeEnd(';');
			masterContractualDiscountsWithId = masterContractualDiscountsWithId.removeEnd(';');
			System.debug('surround: masterContractualDiscounts: ' + masterContractualDiscounts);
			System.debug('surround: masterContractualDiscountsWithId: ' + masterContractualDiscountsWithId);
			List<KeyValue> contractualDiscountsWithId = new List<KeyValue>();
			Integer sequence = 0;
			for(String val : masterContractualDiscountsWithId.split(';')) {
				contractualDiscountsWithId.add(new KeyValue(String.valueOf(sequence), val));
				sequence++;
			}

			// store incentive lines
			//create lineItemData wrapper cascading quote level conditions and discounts
			List<LineItemWrapper> lineItemData = new List<LineItemWrapper>();
			Integer serialNumber = 1;
			Boolean isQuoteDiscountsChanged = false;
			Boolean isQuoteConditionsChanged = false;
			if(!standaloneLineItems.isEmpty()) {
				isQuoteDiscountsChanged = standaloneLineItems[0].Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.CPQ_Contractual_Discounts_Updated__c;
				isQuoteConditionsChanged = standaloneLineItems[0].Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.CPQ_Contractual_Condition_Updated__c;
			}
			for(Apttus_Config2__LineItem__c li : standaloneLineItems) {
				// String secondaryCategory = li.Apttus_Config2__ProductId__r.CPQ_Secondary_Category__c;
				LineItemWrapper liw = new LineItemWrapper();
				liw.serialNumber = serialNumber;
				liw.Id = li.Id;
				liw.productCode = li.Apttus_Config2__ProductId__r.ProductCode;
				liw.product = li.Apttus_Config2__ProductId__r.Name;

				if(li.CPQ_Contractual_Discounts_Applied__c) {
					liw.conditionCode = li.CPQ_Conditional_Price_Code__c;
					liw.conditionDescription = li.CPQ_Contractual_Price_Condition__c;
					liw.discounts = li.CPQ_Contractual_Discounts__c;
					if(isQuoteDiscountsChanged) {
					  liw.discounts = masterContractualDiscounts;
					}
					if(isQuoteConditionsChanged) {
					  liw.conditionCode = masterCondition.key;
					  liw.conditionDescription = masterCondition.value;
					}
				  } else {
					liw.conditionCode = masterCondition.key;
					liw.conditionDescription = masterCondition.value;
					liw.discounts = masterContractualDiscounts;
				  }
				lineItemData.add(liw);

				serialNumber++;
			}
			
			
			//get all eligible conditions
			List<KeyValue> eligibleConditions = new List<KeyValue>();
			List<CPQ_ContractConditionDisc__c> eligibleConditionList = getContractualConditions(quoteId);
			for(CPQ_ContractConditionDisc__c cnd : eligibleConditionList) {
				eligibleConditions.add(new KeyValue(cnd.CPQ_Code__c, cnd.CPQ_Description__c));
			}
			
			//create InitData
			if(String.isNotBlank(masterContractualDiscounts)) {
				initData.contractualDiscounts = masterContractualDiscounts.split(';');
				initData.contractualDiscountsWithId = contractualDiscountsWithId;
			}
			initData.lineItemData = lineItemData;
			initData.eligibleConditions = eligibleConditions;
			initData.masterCondition = masterCondition;

			return initData;
		} catch(Exception e) {
			System.debug('Surround: Error initializing apply discounts page : ' + e.getStackTraceString());
			if(String.isBlank(errorMessage)) {
				errorMessage = 'Some unexpected error occurred while initializing the page. Please contact the system admin.';
			}
			AuraHandledException auraError = new AuraHandledException(errorMessage);
			throw auraError; 
		}
	}


	//applydiscount method
		//set user selected line level values for ICD/QLD and conditions
		//uncheck apply_discounts flag at line level
		//get ICDs selected and create a list of ICD products
		//upsert ICD products & Line level updates
		//uncheck apply_discoiunts flag at quote level
		//update quote
		//reprice cart and redirect back to cart page
	@AuraEnabled
	public static void applyDiscounts(String quoteId, String cartId, String lineItemData) {

		if(String.isBlank(quoteId) || String.isBlank(cartId) || String.isBlank(lineItemData)) return;

		try {
			//delete existing incentive lines
			List<Apttus_Config2__LineItem__c> incentiveLineItems = [
				SELECT  
					Id
				FROM Apttus_Config2__LineItem__c
				WHERE
				Apttus_Config2__ConfigurationId__c = :cartId AND Apttus_Config2__LineType__c = 'Product/Service' AND Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c = 'Standalone' AND Apttus_Config2__ProductId__r.CPQ_Secondary_Category__c = 'Incentive' AND Apttus_Config2__AddedBy__c = 'System'
			];
			if(!incentiveLineItems.isEmpty()) {
				delete incentiveLineItems;
			}
			
			//store all applicable incentive product records
			Set<String> incentiveCodes = new Set<String>();
			List<CPQ_QuoteContractualDiscount__c> quoteConditionList = [
				SELECT  
					Id, CPQ_Contractual_Disc_Method__c, CPQ_Code__c
				FROM CPQ_QuoteContractualDiscount__c
				WHERE CPQ_Proposal__c = :quoteId ORDER BY CPQ_Sequence__c ASC NULLS LAST
			];
			for(CPQ_QuoteContractualDiscount__c discountEntry : quoteConditionList) {
				if(discountEntry.CPQ_Contractual_Disc_Method__c.equalsIgnoreCase('ICD')) {
					incentiveCodes.add(discountEntry.CPQ_Code__c);
				}
			}

			//update lineItemData
			Set<String> selectedIncentiveCodes = new Set<String>();
			List<Apttus_Config2__LineItem__c> lineItemsToUpdate = new List<Apttus_Config2__LineItem__c>();
			List<LineItemWrapper> lineItemDataDeserialized = (List<LineItemWrapper>) JSON.deserializeStrict(lineItemData, List<LineItemWrapper>.class);
			System.debug('surround: liw deserialized: ' + lineItemDataDeserialized);
			for(LineItemWrapper liw : lineItemDataDeserialized) {
				// LineItemWrapper liw = (LineItemWrapper) liwo;
				Apttus_Config2__LineItem__c li = new Apttus_Config2__LineItem__c();
				li.Id = liw.Id;
				li.CPQ_Conditional_Price_Code__c = liw.conditionCode;
				li.CPQ_Contractual_Price_Condition__c = liw.conditionDescription;
				li.CPQ_Contractual_Discounts__c = liw.discounts;
				li.Apttus_Config2__PricingStatus__c = 'Pending';
				li.CPQ_Contractual_Discounts_Applied__c = true;
				lineItemsToUpdate.add(li);

				if(String.isNotBlank(liw.discounts)) {
					for(String dis : liw.discounts.split(';')) {
						if(incentiveCodes.contains(dis)) {
							selectedIncentiveCodes.add(dis);
						}
					}
				}
			}
			if(!lineItemsToUpdate.isEmpty()) {
				update lineItemsToUpdate;
			}


			//insert incentive lines
			if(!selectedIncentiveCodes.isEmpty()) {

				//get all eligible incentive products
				Map<String, Product2> incentiveProductsByCode = new Map<String, Product2>();
				List<Product2> incentiveProducts = [
					SELECT  
						Id, Name, CPQ_ICD_Code__c
					FROM Product2 
					WHERE CPQ_ICD_Code__c IN :incentiveCodes
				];
				for(Product2 incentiveProduct : incentiveProducts) {
					incentiveProductsByCode.put(incentiveProduct.CPQ_ICD_Code__c, incentiveProduct);
				}
				
				List<Apttus_Config2__LineItem__c> incentiveLinesToInsert = new List<Apttus_Config2__LineItem__c>();
				// Create the request object
				Apttus_CPQApi.CPQ.AddMultiProductRequestDO request = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
				request.CartId = cartId;

				// Assume the quantity and selling term for the product is 1
				Integer quantity = 1;
				Integer sellingTerm = 1;

				List<String> customFields = new List<String>{'Apttus_Config2__AddedBy__c'};

				for(String icdCode : selectedIncentiveCodes) {
					Product2 prd = incentiveProductsByCode.get(icdCode);
					if(prd != null) {
						Apttus_CPQApi.CPQ.SelectedProductDO selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
						//set custom fields data
						Apttus_Config2__LineItem__c customLiDate = new Apttus_Config2__LineItem__c();
						customLiDate.Apttus_Config2__AddedBy__c = 'System';

						selectedProduct.ProductId = prd.Id;
						selectedProduct.Quantity = quantity;
						selectedProduct.SellingTerm = sellingTerm;
						selectedProduct.CustomData = customLiDate;
						selectedProduct.CustomFields = customFields;

						request.SelectedProducts.add(selectedProduct);
					}

				}
				// Execute the addMultiProducts routine
				Apttus_CPQApi.CPQ.AddMultiProductResponseDO response = Apttus_CPQApi.CPQWebService.addMultiProducts(request);
					
				System.debug('Line Numbers of added products = ' + response.LineNumbers);
			}

			//update quote flag
			Apttus_Proposal__Proposal__c quote = new Apttus_Proposal__Proposal__c();
			quote.Id = quoteId;
			quote.CPQ_Contractual_Discounts_Updated__c = false;
			quote.CPQ_Contractual_Condition_Updated__c = false;

			update quote;
		} catch(Exception e) {
			System.debug('Surround: Error applying discounts : ' + e.getStackTraceString());
			AuraHandledException auraError = new AuraHandledException('Some unexpected error occurred while applying the discount. Please contact the system admin.');
			throw auraError; 
		}
		

	}

	@AuraEnabled
	public static Boolean repriceCart(Id cartId) {
		Boolean IsPricePending = true;
		List<Apttus_Config2__ProductConfiguration__c> config =  [select Apttus_QPConfig__Proposald__r.Is_Turbo_Pricing__c from Apttus_Config2__ProductConfiguration__c where id = :cartId];
		
		if(config == null || config.isEmpty()) return false;

		if(config[0].Apttus_QPConfig__Proposald__r.Is_Turbo_Pricing__c) {
			return false;
		}

		Apttus_CPQApi.CPQ.UpdatePriceRequestDO priceReqDO = new Apttus_CPQApi.CPQ.UpdatePriceRequestDO();
		priceReqDO.cartID = cartId;
		Apttus_CPQApi.CPQ.UpdatePriceResponseDO priceRespDO = Apttus_CPQApi.CPQWebService.updatePriceForCart(priceReqDO);	
		List<Decimal> complLineNums = priceRespDO.CompletedLineNumbers;
		System.debug('completed li: ' + complLineNums);
		IsPricePending = priceRespDO.IsPricePending;
		List<Decimal> PendingLineNumbers = priceRespDO.PendingLineNumbers;
		System.debug('pending li: ' + PendingLineNumbers);
		system.debug('IsPricePending :'+ IsPricePending);
		return IsPricePending;
	}
	
	public class InitData {
		@AuraEnabled public List<LineItemWrapper> lineItemData;
		@AuraEnabled public List<String> contractualDiscounts;
		@AuraEnabled public List<KeyValue> contractualDiscountsWithId;
		@AuraEnabled public List<KeyValue> eligibleConditions;
		@AuraEnabled public KeyValue masterCondition;
	}

	public class KeyValue {
		KeyValue(String key, String value) {
			this.key = key;
			this.value = value;
		}
		@AuraEnabled public String key;
		@AuraEnabled public String value;
	}

	public class LineItemWrapper{
		@AuraEnabled public Integer serialNumber;
		@AuraEnabled public Id id;
		@AuraEnabled public String productCode;
		@AuraEnabled public String product;
		@AuraEnabled public String conditionCode;
		@AuraEnabled public String conditionDescription;
		@AuraEnabled public String discounts;
	}


	//helper methods

	private static List<CPQ_ContractConditionDisc__c> getContractualConditions(String recordId){
		
		
		Apttus_Proposal__Proposal__c quote = [SELECT Id, Apttus_Proposal__Opportunity__c, CPQ_Pricing_Pool__c, CPQ_Contractual_Price_Condition__c FROm Apttus_Proposal__Proposal__c WHERE Id = :recordId];
		List<CPQ_Pricing_Pool_Agreement_Map__c> ppAgrList = [SELECT Id, CPQ_Agreement_Number__c FROm CPQ_Pricing_Pool_Agreement_Map__c WHERE CPQ_Pricing_Pool_ID__r.CPQ_Pricing_Pool_Name__c = :quote.CPQ_Pricing_Pool__c];
		List<String> agreeNo = new List<String>();
		for(CPQ_Pricing_Pool_Agreement_Map__c ppa : ppAgrList){
			agreeNo.add(ppa.CPQ_Agreement_Number__c);
		}
		DateTime currentTime = System.now();
		List<CPQ_ContractConditionDisc__c> discList = new List<CPQ_ContractConditionDisc__c>();
		for(CPQ_ContractConditionDisc__c ccd:[SELECT Id, CPQ_Code__c,CPQ_Description__c,RecordType.name,CPQ_Start_Date__c,CPQ_End_Date__c FROM CPQ_ContractConditionDisc__c WHERE RecordType.name IN ('Conditional') AND CPQ_Agreement_Number__c IN :agreeNo AND CPQ_Active__c = true]){
			/* 
			if(ccd.CPQ_Start_Date__c != null && ccd.CPQ_End_Date__c != null && (date.today() >= ccd.CPQ_Start_Date__c && date.today() <= ccd.CPQ_End_Date__c)){ 
				discList.add(ccd);  
			}else{  
				discList.add(ccd);  
			}
			*/
			Boolean validCondition = true;
			if(ccd.CPQ_Start_Date__c != null && ccd.CPQ_Start_Date__c > currentTime) {
				validCondition = false;
			}
			if(ccd.CPQ_End_Date__c != null && ccd.CPQ_End_Date__c < currentTime) {
				validCondition = false;
			}
			if(validCondition) {
				discList.add(ccd);
			}
			
		}
		return discList;
	}
}