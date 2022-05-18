/*******************************************************************************************
* @Name		 CPQ_QTC_CartServices 
* @Author	Jithin Sreedharan <jithin.s.ext@nokia.com>
* @Date		 02/17/2021
* @Group		CPQ Services 
* @Description  This class contains all service methods related to adding different types products to congo/apttus cpq cart.
*******************************************************************************************/
/* MODIFICATION LOG
* Version	Developer	Date	  Description
*-------------------------------------------------------------------------------------------
*  1.0	 Jithin	  02/17/2021	Initial Creation				  
*******************************************************************************************/
public with sharing class CPQ_QTC_CartServices {

	
	/**************************************************************************************
	* @Description  This method inserts the line items for each product data
	* @Param		Id - cart/config Id, List<ProductData> - list of productdata wrapper
	* @Return	
	* @Example	 
	* CPQ_QTC_CartServices.addProductsToCart(Id, List<ProductData>)
	**************************************************************************************/
	public static List<Apttus_Config2__LineItem__c> addProductsToCart(Id configId, List<ProductData> productsToAdd) {
			List<Apttus_Config2__LineItem__c> lineItemsToInsert = new List<Apttus_Config2__LineItem__c>();
		Set<String> groupNames = new Set<String>();
		for(ProductData data : productsToAdd) {
			if(String.isNotBlank(data.flexibleGroup)) {
	data.flexibleGroup = data.flexibleGroup.trim();
	groupNames.add(data.flexibleGroup);
			}
		}
		Map<String, String> groupSeqByGroupName = new Map<String, String>();
		if(!groupNames.isEmpty()) {
			groupSeqByGroupName = getGroupCodeMap(configId, groupNames);
		}
		for(ProductData data : productsToAdd) {
			Apttus_Config2__LineItem__c li = new Apttus_Config2__LineItem__c();
			
			li.Apttus_Config2__ConfigurationId__c = configId;
			if(String.isNotBlank(data.type) && (data.type.equalsIgnoreCase('Solution Model') || data.type.equalsIgnoreCase('Site Model'))) {
	li.Apttus_Config2__HasOptions__c = true;
			}
			if(String.isNotBlank(data.type) && data.type.equalsIgnoreCase('Option')) {
	li.Apttus_Config2__LineType__c = 'Option';
	li.Apttus_Config2__ProductId__c = data.parentProductId;
	li.Apttus_Config2__OptionId__c = data.productId;
	li.Apttus_Config2__ParentBundleNumber__c = data.parentLineNumber;
	if(String.isNotBlank(data.productOptionId)) {
		li.Apttus_Config2__ProductOptionId__c = data.productOptionId;
		li.Apttus_Config2__Quantity__c = 1;
	} else {
		li.Apttus_Config2__Quantity__c = data.quantity;
		li.CPQ_BOM_Quantity__c  = data.quantity;
	}
	li.Apttus_Config2__HasOptions__c = false;
			} else {
	li.Apttus_Config2__LineType__c = 'Product/Service';
	li.Apttus_Config2__ProductId__c = data.productId;

	if(data.proposedPrice != null) {
		li.Apttus_Config2__BasePriceOverride__c = data.proposedPrice;
		li.CPQ_Original_Proposed_Price__c = data.proposedPrice;
	}
	if(String.isNotBlank(data.productDescription)) {
		li.CPQ_Product_Description__c = data.productDescription;
	}
	if(String.isNotBlank(data.subHeading)) {
		li.CPQ_Sub_Heading__c = data.subHeading;
	}
	if(String.isNotBlank(data.flexibleGroup) && groupSeqByGroupName.containsKey(data.flexibleGroup)) {
		li.CPQ_Market_Model__c = data.flexibleGroup;
		li.Flexible_group_code__c = groupSeqByGroupName.get(data.flexibleGroup);
	}
	li.Apttus_Config2__Quantity__c = data.quantity;
			}

			//error fixing fields
			li.Apttus_Config2__Customizable__c = false;
			li.Apttus_Config2__PriceListId__c = data.priceListId;
			li.Apttus_Config2__ConfigStatus__c = 'NA';
			li.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
			li.Apttus_Config2__ProductVersion__c = data.productVersion;
			//error fixing fields


			li.Apttus_Config2__LineNumber__c = data.lineNumber;
			li.Apttus_Config2__IsPrimaryLine__c = true;
			li.Apttus_Config2__PrimaryLineNumber__c = data.primaryLineNumber;
			li.Apttus_Config2__ItemSequence__c = data.primaryLineNumber;
			
			li.Apttus_Config2__SellingTerm__c = 1;
			li.Apttus_Config2__SellingFrequency__c = 'One Time';
			li.Apttus_Config2__Uom__c = 'Each';

			li.Apttus_Config2__PricingStatus__c = 'Pending';
			//item sequence if option lineNumber + 1 && // find the logic if you add a second bundle

			lineItemsToInsert.add(li);
		}

		if(!Test.isRunningTest()) {
			insert lineItemsToInsert;
		}

		return lineItemsToInsert;
	}

	/**************************************************************************************
	* @Description  This method update the quote
	* @Param		Id - cart/config Id, Quotedata wrapper
	* @Return	
	**************************************************************************************/

	public static void updateQuote(Id cartId, CPQ_QTC_CartServices.QuoteData quoteData){
		Apttus_Proposal__Proposal__c objQuote = new Apttus_Proposal__Proposal__c();
		objQuote.Id = [SELECT Id, Apttus_QPConfig__Proposald__c from Apttus_Config2__ProductConfiguration__c WHERE Id =:cartId limit 1].Apttus_QPConfig__Proposald__c;
		system.debug('========quoteData====='+quoteData);
		if(String.isNotBlank(quoteData.resellername)){
			objQuote.CPQ_Reseller_Name__c = quoteData.resellername;
		}
		if(String.isNotBlank(quoteData.transtype)){
			objQuote.CPQ_Transaction_Type__c = quoteData.transtype;
		}
		if(String.isNotBlank(quoteData.custtype)){
			objQuote.CPQ_Customer_Type__c = quoteData.custtype;
		}
		if(String.isNotBlank(quoteData.purchaseorder)){
			objQuote.CPQ_Purchase_Order_Number__c = quoteData.purchaseorder;
		}
		update objQuote;
	}

	/**************************************************************************************
	* @Description  This method inserts the line items for each product data
	* @Param		Id - cart/config Id, List<ProductData> - list of productdata wrapper
	* @Return	
	* @Example	 
	* CPQ_QTC_CartServices.addProductsToCart(Id, List<ProductData>)
	**************************************************************************************/
	public static List<Apttus_Config2__LineItem__c> addProductsToCartSSF(Id configId, List<ProductData> productsToAdd) {
		List<Apttus_Config2__LineItem__c> existingLineItems = [select id, Apttus_Config2__PrimaryLineNumber__c, Apttus_Config2__LineNumber__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c = :configId order by Apttus_Config2__PrimaryLineNumber__c desc LIMIT 1];
		Integer lineNumber = 0;
		Integer primaryLineNumber = 0;
		if(!existingLineItems.isEmpty()) {
			lineNumber = Integer.valueOf(existingLineItems[0].Apttus_Config2__LineNumber__c);
			primaryLineNumber = Integer.valueOf(existingLineItems[0].Apttus_Config2__PrimaryLineNumber__c);
		}
		
		List<Apttus_Config2__LineItem__c> lineItemsToInsert = new List<Apttus_Config2__LineItem__c>();
		
		Id quoteId = [SELECT Id, Apttus_QPConfig__Proposald__c from Apttus_Config2__ProductConfiguration__c WHERE Id =:configId limit 1].Apttus_QPConfig__Proposald__c;
		Apttus_Proposal__Proposal__c objQuote = [SELECT Id, CPQ_SSF_Billing_Rule_ID__c,CPQ_SSF_Billing_Rule_Code__c, CPQ_SSF_Billing_Rule_Description__c
				  from Apttus_Proposal__Proposal__c WHERE Id =: quoteId];
		
		System.debug('=====productsToAdd============'+productsToAdd);
		for(ProductData data : productsToAdd) {
			Apttus_Config2__LineItem__c li = new Apttus_Config2__LineItem__c();
			li.Apttus_Config2__ProductVersion__c = data.productVersion;

			li.Apttus_Config2__ConfigurationId__c = configId;
			if(String.isNotBlank(data.groupid)){
	li.CPQ_SSF_Group_ID__c = data.groupid;
			}
			li.Apttus_Config2__Quantity__c =  data.quantity != null ? data.quantity: 1;
			li.CPQ_SSF_Quantity__c = li.Apttus_Config2__Quantity__c;
			
			li.Apttus_Config2__ProductId__c = data.productId;
			if(String.isNotBlank(data.tss_productoi)){
	li.CPQ_SSF_Product_OI__c = data.tss_productoi;
			}
			if(String.isNotBlank(data.tss_productname)){
	li.CPQ_SSF_Product_Name__c = data.tss_productname;
			}
			if(String.isNotBlank(data.servicedesc)){
	li.CPQ_Product_Description__c = data.servicedesc;
			}
			if(String.isNotBlank(data.tss_productOIDescription)){
	li.CPQ_SSF_Product_OI_Desc__c = data.tss_productOIDescription;
			}
			if(String.isNotBlank(data.tss_productManufacturer)){
	li.CPQ_SSF_Product_Manufacturer__c = data.tss_productManufacturer;
			}
			if(String.isNotBlank(data.StartDate)){
	li.Apttus_Config2__StartDate__c = date.valueOf(data.StartDate);
			}
			if(String.isNotBlank(data.EndDate)){
	li.Apttus_Config2__EndDate__c = date.valueOf(data.EndDate);
			}
			if(String.isNotBlank(data.term)){
	li.Apttus_Config2__SellingTerm__c = Decimal.valueOf(data.term);
	li.CPQ_SSF_Term__c = li.Apttus_Config2__SellingTerm__c;
			}
			if(li.Apttus_Config2__SellingTerm__c != null){
	if(String.isNotBlank(data.tss_unitRate)){
		li.Apttus_Config2__BasePrice__c = Decimal.valueOf(data.tss_unitRate);
	}
	if(String.isNotBlank(data.extunitrate)){
		li.Apttus_Config2__ExtendedPrice__c = Decimal.valueOf(data.extunitrate);
	}
	if(String.isNotBlank(data.unitdisc)){
		li.CPQ_SSF_Discount_Percent__c = Decimal.valueOf(data.unitdisc);
	}
	if(String.isNotBlank(data.tss_discUnitRate)){
		li.CPQ_SSF_Discounted_Base_Price__c = Decimal.valueOf(data.tss_discUnitRate);
	}
	if(String.isNotBlank(data.extdiscunitrate)){
		li.Apttus_Config2__NetPrice__c = Decimal.valueOf(data.extdiscunitrate);
	}
			}else{
	if(String.isNotBlank(data.tss_oneTimeCharge)){
		li.Apttus_Config2__BasePrice__c = Decimal.valueOf(data.tss_oneTimeCharge);
	}
	if(String.isNotBlank(data.extonetimecharge)){
		li.Apttus_Config2__ExtendedPrice__c = Decimal.valueOf(data.extonetimecharge);
	}
	if(String.isNotBlank(data.onetimedisc)){
		li.CPQ_SSF_Discount_Percent__c = Decimal.valueOf(data.onetimedisc);
	}
	if(String.isNotBlank(data.disconetimecharge)){
		li.CPQ_SSF_Discounted_Base_Price__c = Decimal.valueOf(data.disconetimecharge);
	}
	if(String.isNotBlank(data.extdisconetimecharge)){
		li.Apttus_Config2__NetPrice__c = Decimal.valueOf(data.extdisconetimecharge);
	}
			}
			if(String.isNotBlank(data.adjusttype)){
	li.CPQ_SSF_Adjust_Type_Class__c = data.adjusttype;
			}
			if(String.isNotBlank(data.priceclass)){
	li.CPQ_SSF_Price_Class__c = data.priceclass;
			}

			//to make use of apttus functionalities
			if(li.CPQ_SSF_Discount_Percent__c != null) {
	Decimal discountPercent = (1-li.Apttus_Config2__NetPrice__c/li.Apttus_Config2__ExtendedPrice__c)*100;
	li.Apttus_Config2__AdjustmentAmount__c = discountPercent;
	li.Apttus_Config2__AdjustmentType__c = '% Discount';
			}
			li.CPQ_Uploaded_via_SSF__c = true;  
			li.CPQ_SSF_Billing_Rule_ID__c = objQuote.CPQ_SSF_Billing_Rule_ID__c;
			li.CPQ_SSF_Billing_Rule_Code__c	= objQuote.CPQ_SSF_Billing_Rule_Code__c;
			li.CPQ_SSF_Billing_Rule_Description__c = objQuote.CPQ_SSF_Billing_Rule_Description__c;

			li.Apttus_Config2__PricingStatus__c = 'Completed';

			lineNumber++;
			primaryLineNumber++;
			/*
			li.Apttus_Config2__LineNumber__c = lineItemsToInsert.size()+1;
			li.Apttus_Config2__IsPrimaryLine__c = true;
			li.Apttus_Config2__PrimaryLineNumber__c = lineItemsToInsert.size()+1;
			li.Apttus_Config2__ItemSequence__c = lineItemsToInsert.size()+1;
			*/
			li.Apttus_Config2__LineNumber__c = lineNumber;
			li.Apttus_Config2__IsPrimaryLine__c = true;
			li.Apttus_Config2__PrimaryLineNumber__c = primaryLineNumber;
			li.Apttus_Config2__ItemSequence__c = primaryLineNumber;

			System.debug('=====li============'+li);
			lineItemsToInsert.add(li);
		}

		if(!Test.isRunningTest()) {
			insert lineItemsToInsert;
		}
		System.debug('=====success============');
		return lineItemsToInsert;
	}


	/**************************************************************************************
	* @Description  This methods validates uploaded BOM
	* @Return		
	* @Example	 
	* CPQ_QTC_CartServices.addSequencingAndOptions(cartconfigId, bomdata)
	**************************************************************************************/
	public static List<ProductData> addSequencingAndOptions(Id configId, List<ProductData> productsToAdd) {
		//List<Apttus_Config2__ProductConfiguration__c> cart = [SELECT Apttus_Config2__PriceListId__c,Id FROM Apttus_Config2__ProductConfiguration__c WHERE Id = :configId LIMIT 1];
		Set<Id> optionIds = new Set<Id>();
		List<ProductData> sequencedProductData = new List<ProductData>();
		Map<Integer, ProductData> bomDataByNumber = new Map<Integer, ProductData>();
		for(ProductData bom : productsToAdd) {
			bomDataByNumber.put(bom.bomLineNumber, bom);
		}

		List<Apttus_Config2__LineItem__c> existingLineItems = [select id, Apttus_Config2__PrimaryLineNumber__c, Apttus_Config2__LineNumber__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c = :configId order by Apttus_Config2__PrimaryLineNumber__c desc LIMIT 1];
		Integer lineNumber = 0;//get this value from existing li data
		Integer primaryLineNumber = 0;//get this value from existing li data
		if(!existingLineItems.isEmpty()) {
			lineNumber = Integer.valueOf(existingLineItems[0].Apttus_Config2__LineNumber__c);
			primaryLineNumber = Integer.valueOf(existingLineItems[0].Apttus_Config2__PrimaryLineNumber__c);
		}
		for(ProductData bom : productsToAdd) {
			if(bom.type.equalsIgnoreCase('Standalone')) {//add standalones product code
		lineNumber++;
		primaryLineNumber++;
		bom.lineNumber = lineNumber;
		bom.primaryLineNumber = primaryLineNumber;
		sequencedProductData.add(bom);
			} else if(bom.type.equalsIgnoreCase('Solution Model')) {//add solution models product codes
	lineNumber++;
	primaryLineNumber++;
	bom.lineNumber = lineNumber;
	bom.primaryLineNumber = primaryLineNumber;
	sequencedProductData.add(bom);

	//set children productData values
	List<ProductData> optionList = new List<ProductData>();
	//Apttus_CPQApi.CPQ.ProductOptionGroupSearchResultDO productOptionGroupResult = Apttus_CPQApi.CPQWebService.getOptionGroupsForPriceListProduct(cart.get(0).Apttus_Config2__PriceListId__c, bom.productId);
	Apttus_CPQApi.CPQ.ProductOptionGroupSearchResultDO productOptionGroupResult = Apttus_CPQApi.CPQWebService.getOptionGroupsForPriceListProduct(bom.priceListId, bom.productId);
	System.debug('ks productOptionGroupResult--' + productOptionGroupResult);
	if(productOptionGroupResult.HasOptionGroups) {
		for(Apttus_CPQApi.CPQ.ProductOptionGroupDO productOptionGroup : productOptionGroupResult.OptionGroups) {
			if(productOptionGroup.HasOptionComponents) {
				for(Apttus_CPQApi.CPQ.ProductOptionComponentDO productOptionComponent : productOptionGroup.OptionComponents) {
		ProductData option = new ProductData();

		primaryLineNumber++;
		
		option.lineNumber = lineNumber;
		option.primaryLineNumber = primaryLineNumber;
		option.type = 'Option';
		option.productId = productOptionComponent.ComponentProductId;
		option.parentLineNumber = bom.primaryLineNumber;
		option.parentProductId = bom.productId;
		option.productGroupId = productOptionGroup.ProductOptionGroupId;
		option.productOptionId = productOptionComponent.ComponentId;

		optionList.add(option);

		optionIds.add(option.productId);
				}
			}
		}
	}
	sequencedProductData.addAll(optionList);
			} else if(bom.type.equalsIgnoreCase('Site Model')){//add site models product codes
	lineNumber++;
	primaryLineNumber++;
	bom.lineNumber = lineNumber;
	bom.primaryLineNumber = primaryLineNumber;
	sequencedProductData.add(bom);
			} else if(bom.type.equalsIgnoreCase('Option')) {//add options under site models
		//ProductData parentProductData = getParentProductData(validatedProductData);//get the immediately previous site model parent bundle

		ProductData parentProductData = bomDataByNumber.get(bom.parentLineNumber);
		primaryLineNumber++;
		if(parentProductData != null) {
			bom.lineNumber = parentProductData.lineNumber;
			bom.primaryLineNumber = primaryLineNumber;
			bom.parentLineNumber = parentProductData.primaryLineNumber;
			bom.parentProductId = parentProductData.productId;
			//option.productGroupId = parentProductData.ProductOptionGroupId;
			//option.productOptionId = parentProductData.ComponentId;

			sequencedProductData.add(bom);
		}	
			}
		}
		if(!optionIds.isEmpty()) {
			Map<Id, Product2> productMap = new Map<Id, Product2>([SELECT Id, Apttus_Config2__Version__c FROM Product2 WHERE Id IN :optionIds]);
			for(ProductData data : sequencedProductData) {
				if(productMap != null && productMap.containsKey(data.productId)) {
					data.productVersion = productMap.get(data.productId).Apttus_Config2__Version__c;
				}
			}
		}
		return sequencedProductData;
	}

	/**************************************************************************************
	* @Description  This methods validates uploaded product codes and populates various the ProductWrapper values
	* @Param		Id - configuration ID, List<ProductData>  - list of uploaded bom
	* @Return	Boolean - isValidBOM
	* @Example	 
	* CPQ_QTC_CartServices.validateBOM(configId, productsToValidate, isValidBOM)
	**************************************************************************************/
	public static Boolean validateBOM(Id configId, List<CPQ_QTC_CartServices.ProductData> productsToValidate) {
		Boolean isValidationSuccess = true;
		Set<String> productCodes = new Set<String>();
		for(ProductData bom : productsToValidate) {
			productCodes.add(bom.productCode);
		}
		List<Product2> products = [SELECT Id, CPQ_Secondary_Category__c, Apttus_Config2__Version__c, NokiaCPQ_Item_Type__c, ProductCode, CPQ_Stream__c, Apttus_Config2__ConfigurationType__c, IsActive, CPQ_SSF_Permission__c FROM Product2 WHERE ProductCode IN :productCodes AND CPQ_Stream__c IN ('QTC') AND IsActive = true];
		Set<Id> productIds = new Set<Id>();
		Map<String, Product2> productByCode = new Map<String, Product2>();
		for(Product2 prod : products) {
			productIds.add(prod.Id);
			productByCode.put(prod.ProductCode, prod);
		}

		Map<Integer, List<String>> errMsgMap = new Map<Integer, List<String>>();
		List<String> msgList;
		
		//validate product codes - start
		for(ProductData bom : productsToValidate) {
			if(productByCode.containsKey(bom.productCode)) {
	bom.productId = productByCode.get(bom.productCode).Id;
	bom.productVersion = productByCode.get(bom.productCode).Apttus_Config2__Version__c;
			} else {
	bom.status = 'Failed: Product doesn\'t exist or is not active in the system.';
	
	msgList = errMsgMap.containskey(bom.bomLineNumber) ? errMsgMap.get(bom.bomLineNumber) : new List<String>();
	msgList.add('Product doesn\'t exist or is not active in the system.');
	errMsgMap.put(bom.bomLineNumber, msgList);
			}
		}
		//validate product codes - end

		List<Apttus_Config2__ProductConfiguration__c> cart = [SELECT Id, Apttus_Config2__PriceListId__c FROM Apttus_Config2__ProductConfiguration__c WHERE Id = :configId LIMIT 1];
		if(cart.isEmpty()) return false;

		Id cartPriceListId = cart[0].Apttus_Config2__PriceListId__c;
		List<Apttus_Config2__PriceListItem__c> pliList = [SELECT Id, Apttus_Config2__PriceListId__c, Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.ProductCode from Apttus_Config2__PriceListItem__c WHERE Apttus_Config2__PriceListId__c = :cartPriceListId AND Apttus_Config2__ProductId__r.ProductCode in:productCodes AND Apttus_Config2__Active__c = true];//todo - verify & confirm the conditions
		Map<String, Apttus_Config2__PriceListItem__c> priceListEntryByProductCode = new Map<String, Apttus_Config2__PriceListItem__c>();
		for(Apttus_Config2__PriceListItem__c pli : pliList) {
			priceListEntryByProductCode.put(pli.Apttus_Config2__ProductId__r.ProductCode, pli);
		}

		//validate price list entry - start
		for(ProductData bom : productsToValidate) {
			if(priceListEntryByProductCode.containsKey(bom.productCode)) {
	bom.priceListId = priceListEntryByProductCode.get(bom.productCode).Apttus_Config2__PriceListId__c;
			} else {
	bom.status = 'Failed: Price list entry not found.';
	
	msgList = errMsgMap.containskey(bom.bomLineNumber) ? errMsgMap.get(bom.bomLineNumber) : new List<String>();
	msgList.add('Price list entry not found.');
	errMsgMap.put(bom.bomLineNumber, msgList);
			}
		}
		//validate price list entry - end

		//validate product type - bundles(solution models/site models), standalones - start
		Map<Integer, ProductData> bomDataByNumber = new Map<Integer, ProductData>();
		for(ProductData bom : productsToValidate) {
			bomDataByNumber.put(bom.bomLineNumber, bom);

			Boolean isTypeValidationSuccess = true;
			Product2 prod = productByCode.get(bom.productCode);
			bom.type = 'N/A';
			if(prod != null) {
	bom.itemType = prod.NokiaCPQ_Item_Type__c;
	if(prod != null && prod.Apttus_Config2__ConfigurationType__c.equalsIgnoreCase('Bundle')) {
		if(String.isNotBlank(prod.CPQ_Secondary_Category__c) && prod.CPQ_Secondary_Category__c.containsIgnoreCase('Solution Model')) {
			bom.type = 'Solution Model';
		} else if(String.isNotBlank(prod.CPQ_Secondary_Category__c) && prod.CPQ_Secondary_Category__c.containsIgnoreCase('Site Model')) {
			bom.type = 'Site Model';
		} else {
			isTypeValidationSuccess = false;
		}
	} else if(prod != null && prod.Apttus_Config2__ConfigurationType__c.equalsIgnoreCase('Standalone')) {
		if(bom.parentLineNumber != null) {
			bom.type = 'Option';
		} else {
			bom.type = 'Standalone';
		}
	} else {
		isTypeValidationSuccess = false;
	}
			}
			
			if(!isTypeValidationSuccess) {
	bom.status = 'Failed: Could not identify the product type.';
	
	msgList = errMsgMap.containskey(bom.bomLineNumber) ? errMsgMap.get(bom.bomLineNumber) : new List<String>();
	msgList.add('Could not identify the product type.');
	errMsgMap.put(bom.bomLineNumber, msgList);
			}
		}
		//validate product type - bundles(solution models/site models), standalones - end

		//Validate parent line number - start
		for(ProductData bom : productsToValidate) {
			if(bom.parentLineNumber != null) {
	ProductData parentProductBOM = bomDataByNumber.get(bom.parentLineNumber);
	if(parentProductBOM == null || !parentProductBOM.type.equalsIgnoreCase('Site Model')) {
		bom.status = 'Failed: Parent does not exist or is not a Site Model.';
		
		msgList = errMsgMap.containskey(bom.bomLineNumber) ? errMsgMap.get(bom.bomLineNumber) : new List<String>();
		msgList.add('Parent does not exist or is not a Site Model.');
		errMsgMap.put(bom.bomLineNumber, msgList);
	}else{
		parentProductBOM.noOfChilds = parentProductBOM.noOfChilds == null ? 1 : parentProductBOM.noOfChilds+1;
		bomDataByNumber.put(bom.parentLineNumber, parentProductBOM);
	}
			}
		}
		//Validate parent line number - end
		
		
		for(ProductData bom : productsToValidate) {
			Product2 prod = productByCode.get(bom.productCode);
			//validate Proposed Price
			if(bom.proposedPrice != null && !isProposedPriceAllowed(bom)) {
	msgList = errMsgMap.containskey(bom.bomLineNumber) ? errMsgMap.get(bom.bomLineNumber) : new List<String>();
	msgList.add('Proposed Price is not allowed.');
	errMsgMap.put(bom.bomLineNumber, msgList);
			}
			//validate Product Description
			if(String.isNotBlank(bom.productDescription) && !isProductDescriptionAllowed(bom)) {
	msgList = errMsgMap.containskey(bom.bomLineNumber) ? errMsgMap.get(bom.bomLineNumber) : new List<String>();
	msgList.add('Product Description is not allowed.');
	errMsgMap.put(bom.bomLineNumber, msgList);
			}
			//validate flexible group
			if(String.isNotBlank(bom.flexibleGroup) && !isFlexibleGroupAllowed(bom, prod)) {
	msgList = errMsgMap.containskey(bom.bomLineNumber) ? errMsgMap.get(bom.bomLineNumber) : new List<String>();
	msgList.add('Flexible Group is not allowed.');
	errMsgMap.put(bom.bomLineNumber, msgList);
			}
		}
		
		//validate Product Stream - start
		for(ProductData bom : productsToValidate) {
			Product2 prod = productByCode.get(bom.productCode);
			if(prod != null
	&& (String.isBlank(prod.CPQ_Stream__c) || !prod.CPQ_Stream__c.contains('QTC'))){
	bom.status = 'Failed: Can not add a non QTC product.';
	
	msgList = errMsgMap.containskey(bom.bomLineNumber) ? errMsgMap.get(bom.bomLineNumber) : new List<String>();
	msgList.add('Can not add a non QTC product.');
	errMsgMap.put(bom.bomLineNumber, msgList);
			}
			
		}
		//validate Product Stream - end
		
		//Validate no of childs for bundle products - start
		for(ProductData bom : productsToValidate) {
			Product2 prod = productByCode.get(bom.productCode);
			ProductData pbom = bomDataByNumber.get(bom.bomLineNumber);
			if(prod != null
	&& bom.type.equalsIgnoreCase('Site Model') && prod.Apttus_Config2__ConfigurationType__c.equalsIgnoreCase('Bundle') && pbom.noOfChilds == null){
	bom.status = 'Failed: Can not insert Site model Products without childs.';
	
	msgList = errMsgMap.containskey(bom.bomLineNumber) ? errMsgMap.get(bom.bomLineNumber) : new List<String>();
	msgList.add('Can not insert Site model Products without childs.');
	errMsgMap.put(bom.bomLineNumber, msgList);	
			}
			
		}
		//Validate no of childs for bundle products - end
		
		/*
		//Validate roll up group and parent - start
		Map<Integer, Integer> grpParentMap = new Map<Integer, Integer>();
		for(ProductData bom : productsToValidate) {
			System.debug('RRR bom.rollupGrpParent :: '+bom.rollupGrpParent);
			Integer count = grpParentMap.containskey(bom.rollupGrpNo) ? grpParentMap.get(bom.rollupGrpNo) : 0;
			System.debug('RRR count :: '+count);
			if(bom.rollupGrpNo != null && String.isNotBlank(bom.rollupGrpParent)){
	grpParentMap.put(bom.rollupGrpNo, count++);
			}else if(bom.rollupGrpNo != null){
	grpParentMap.put(bom.rollupGrpNo, count);
			}
		}
		
		System.debug('RRR grpParentMap :: '+grpParentMap);
		
		for(ProductData bom : productsToValidate) {
			Integer count = grpParentMap.get(bom.rollupGrpNo);
			System.debug('bom.bomLineNumber :: '+bom.bomLineNumber);
			System.debug('count2 :: '+count);
			if(count != null && count != 1){
	bom.status = 'Failed: Group Parent is mandatory for every unique value of roll up group and Max one group parent = True for every unique value of roll up group.';
	
	msgList = errMsgMap.containskey(bom.bomLineNumber) ? errMsgMap.get(bom.bomLineNumber) : new List<String>();
	msgList.add('Group Parent is mandatory for every unique value of roll up group. </br>proposMax one group parent = True for every unique value of roll up group.');
	errMsgMap.put(bom.bomLineNumber, msgList);
			}
		}
		//Validate roll up group and parent - end
		*/

		//Assigning failed status with error msg - start
		for(ProductData bom : productsToValidate) {
			if(errMsgMap.get(bom.bomLineNumber) != null){
	isValidationSuccess = false;
	bom.status = String.join(errMsgMap.get(bom.bomLineNumber), '</br>');
			}
		}
		//Assigning failed status with error msg - end

		return isValidationSuccess;
	}


	/**************************************************************************************
	* @Description  This methods validates uploaded product codes and populates various the ProductWrapper values
	* @Param		Id - configuration ID, List<ProductData>  - list of uploaded bom
	* @Return	Boolean - validateSSF
	* @Example	 
	* CPQ_QTC_CartServices.validateSSF(configId, productsToValidate, isValidBOM)
	**************************************************************************************/
	public static Boolean validateSSF(Id configId, List<CPQ_QTC_CartServices.ProductData> productsToValidate) {
		Boolean isValidationSuccess = true;
		Set<String> productCodes = new Set<String>();
		for(ProductData prod : productsToValidate) {
			productCodes.add(prod.serviceoi);
		}
		List<Product2> products = [SELECT Id, Apttus_Config2__Version__c, CPQ_Secondary_Category__c, NokiaCPQ_Item_Type__c, ProductCode, CPQ_Stream__c, Apttus_Config2__ConfigurationType__c,
			 IsActive FROM Product2 WHERE ProductCode IN :productCodes AND CPQ_SSF_Permission__c IN ('M', 'O') AND IsActive = true
			 AND Apttus_Config2__ConfigurationType__c = 'Standalone'];
		
		Map<String, Product2> productByCode = new Map<String, Product2>();
		for(Product2 prod : products) {
			productByCode.put(prod.ProductCode, prod);
		}

		Map<Integer, List<String>> errMsgMap = new Map<Integer, List<String>>();
		
		//validate product codes - start
		for(ProductData ssf : productsToValidate) {
			if(productByCode.containsKey(ssf.serviceoi)) {
	ssf.productId = productByCode.get(ssf.serviceoi).Id;
	ssf.productVersion = productByCode.get(ssf.serviceoi).Apttus_Config2__Version__c;
			} else {
	ssf.status = 'Failed: Product doesn\'t exist or is not active in the system.';
	isValidationSuccess = false;
			}
		}

		return isValidationSuccess;
	}


	/*****************Helper Methods - Start********************/
	private static Boolean isProposedPriceAllowed(ProductData bom) {
		Boolean isProposedPriceAllowed = true;
		if(String.isNotBlank(bom.type) && (bom.type.equalsIgnoreCase('Site Model') || bom.type.equalsIgnoreCase('Solution Model') || bom.type.equalsIgnoreCase('Option'))) {
			isProposedPriceAllowed = false;
		} 
		return isProposedPriceAllowed;
	}

	private static Boolean isProductDescriptionAllowed(ProductData bom) {
		Boolean isProductDescriptionAllowed = true;
		if(bom.itemType != 'Service') {
			isProductDescriptionAllowed = false;
		} 
		return isProductDescriptionAllowed;
	}

	private static Boolean isFlexibleGroupAllowed(ProductData bom, Product2 prod) {
		Boolean isFlexibleGroupAllowed = true;
		if(isSSFBillingProduct(bom, prod) || (String.isNotBlank(bom.type) && (bom.type.equalsIgnoreCase('Site Model') || bom.type.equalsIgnoreCase('Solution Model') || bom.type.equalsIgnoreCase('Option')))) {
			isFlexibleGroupAllowed = false;
		} 
		return isFlexibleGroupAllowed;
	}

	private static Boolean isSSFBillingProduct(ProductData bom, Product2 prod) {
		Boolean isSSFBillingProduct = false;
		if(prod != null && prod.CPQ_SSF_Permission__c != null) {
			isSSFBillingProduct = true;
		} 
		return isSSFBillingProduct;
	}
	
	private static Map<String, String> getGroupCodeMap(Id configId, Set<String> groupNames) {
		Map<String, String> groupSeqByGroupName = new Map<String, String>();
		
		List<Apttus_Config2__LineItem__c> liList = [select Id, Flexible_group_code__c, CPQ_Market_Model__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c = :configId];
		Integer counter = 0;
		for(Apttus_Config2__LineItem__c li : liList) {
			if(!groupSeqByGroupName.containsKey(li.CPQ_Market_Model__c)) {
	groupSeqByGroupName.put(li.CPQ_Market_Model__c, li.Flexible_group_code__c);
	counter++;
			}
		}

		for(String groupName : groupNames) {
			if(!groupSeqByGroupName.containsKey(groupName)) {
	counter++;
	groupSeqByGroupName.put(groupName, 'SOLUTION00' + counter);
			}
		}
		
		return groupSeqByGroupName;
	}
	/*****************Helper Methods - End********************/


	/**************************************************************************************
	* @Name		 ProductData 
	* @Description  Wrapper class to store product data to be mapped into line items
	**************************************************************************************/
	public class ProductData {
		@AuraEnabled public Integer bomLineNumber {get;set;}
		@AuraEnabled public Integer lineNumber {get;set;}//collapsed line sequence
		@AuraEnabled public Integer primaryLineNumber {get;set;}//expanded line sequence
		@AuraEnabled public String type {get;set;}
		@AuraEnabled public String productCode {get;set;}
		@AuraEnabled public Decimal productVersion {get;set;}
		@AuraEnabled public Id productId {get;set;}
		@AuraEnabled public Integer parentLineNumber {get;set;}//mapped to primary line number
		@AuraEnabled public Id parentProductId {get;set;}
		@AuraEnabled public Id productGroupId {get;set;}
		@AuraEnabled public Id productOptionId {get;set;}
		@AuraEnabled public Integer quantity {get;set;}
		@AuraEnabled public Id priceListId {get;set;}
		@AuraEnabled public Decimal proposedPrice {get;set;}
		@AuraEnabled public String productDescription {get;set;}
		@AuraEnabled public String subHeading {get;set;}
		@AuraEnabled public String flexibleGroup {get;set;}
		@AuraEnabled public String status {get;set;}
		@AuraEnabled public String itemType {get;set;}
		@AuraEnabled public Integer noOfChilds {get;set;}
		@AuraEnabled public Integer rollupGrpNo {get;set;}
		@AuraEnabled public String rollupGrpParent {get;set;}


		//SSf CSV fields 
		@AuraEnabled public String groupid;
		@AuraEnabled public String serviceoi;
		@AuraEnabled public String tss_productoi;
		@AuraEnabled public String tss_productname;
		@AuraEnabled public String servicedesc;
		@AuraEnabled public String tss_productOIDescription;
		@AuraEnabled public String tss_productManufacturer;
		@AuraEnabled public String startDate;
		@AuraEnabled public String endDate;
		@AuraEnabled public String term;
		@AuraEnabled public String tss_unitRate;
		@AuraEnabled public String extunitrate;
		@AuraEnabled public String tss_oneTimeCharge;
		@AuraEnabled public String extonetimecharge;
		@AuraEnabled public String unitdisc;
		@AuraEnabled public String tss_discUnitRate;
		@AuraEnabled public String extdiscunitrate;
		@AuraEnabled public String onetimedisc;
		@AuraEnabled public String disconetimecharge;
		@AuraEnabled public String extdisconetimecharge;
		@AuraEnabled public String adjusttype;
		@AuraEnabled public String priceclass;	

		public ProductData() {}
	}

	public class QuoteData{
		@AuraEnabled public String resellername{get;set;}
		@AuraEnabled public String transtype {get;set;}
		@AuraEnabled public String custtype {get;set;}
		@AuraEnabled public String purchaseorder {get;set;}

	}
	public class QuoteAndProductData{
		@AuraEnabled public QuoteData objQuoteData = new QuoteData();
		@AuraEnabled public List<ProductData> lstProductData = new List<ProductData>();
	}
}