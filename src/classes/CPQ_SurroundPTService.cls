@RestResource(urlMapping='/v1/SurroundPricing/*')
global without sharing class CPQ_SurroundPTService {

	@HttpGet
	global static void getDynamicPricing() {
		RestResponse res = RestContext.response;
		try {
			Map<String,String> paramsMap = RestContext.request.params;

			String soldTo = paramsMap.containsKey('soldTo') ? paramsMap.get('soldTo') : null;
			String agrName = paramsMap.containsKey('agrName') ? paramsMap.get('agrName') : null;
			String productCodesString = paramsMap.containsKey('products') ? paramsMap.get('products') : null;

			if(String.isBlank(soldTo) || String.isBlank(productCodesString)) {
				res.responseBody = Blob.valueOf('Bad request params.');
				res.statusCode = 400;
			} else {
				DynamicPricingResponse pricingResponse = getDynamicPricingResponse(soldTo, agrName, productCodesString);
				res.responseBody = Blob.valueOf(JSON.serialize(pricingResponse));
				res.statusCode = 200;
			}

		} catch (Exception e) {
			res.responseBody = Blob.valueOf(e.getMessage());
			res.statusCode = 500;
		}
	}


	//helper methods - start
	private static final String STATUS_SUCCESS = 'success';
	private static final String STATUS_FAILED = 'failed';
	@TestVisible
	private static DynamicPricingResponse getDynamicPricingResponse(String soldToEntity, String agreementName, String productCodesString) {
		
		DynamicPricingResponse response = new DynamicPricingResponse();
		response.status = STATUS_FAILED;

		//find parent customer Id
		Account parentAccount = findCustomerAccountFromLegalEntity(soldToEntity);
		if(parentAccount == null) {
			response.parentAccountFound = false;
			return response;
		} else {
			response.parentAccountFound = true;
			response.parentAccountNumber = parentAccount.AccountNumber;
		}

		//find default pricing pool
		CPQ_PricingPool__c defaultPricingPool = findDefaultPricingPool(parentAccount.Id);
		if(defaultPricingPool == null) {
			response.defaultPricingPoolFound = false;
			return response;
		} else {
			response.defaultPricingPoolFound = true;
			response.defaultPricingPool = defaultPricingPool.CPQ_Pricing_Pool_Name__c;
		}

		//create map of productcode vs productId
		List<String> productCodesList = productCodesString.split(',');
		Set<String> productCodes = new Set<String>();
		for(String prdCode : productCodesList) {
			productCodes.add(prdCode);
		}
		Map<String, Product2> productByCode = getProductByProductCode(productCodes);

		//get mapped agreements in sequnce from the default pricing pool
		List<CPQ_Pricing_Pool_Agreement_Map__c> poolAgreementList = defaultPricingPool.Pricing_Pool_Agreement_Maps__r;
		//get agreement numbers in sequence
		List<String> agreementNumbers = getSequencedAgreementNumbers(poolAgreementList);

		//check if a specigic valid agreement is given in request
		CPQ_Pricing_Pool_Agreement_Map__c validPoolAgreementRecord = findIfValidAgreementSpecifiedInTheRequest(poolAgreementList, agreementName);


		//create map of agreement specific product code vs price list item, if the agreement exist in the default price pool - remove price list items that dosent fall between the dates
		Map<String, Apttus_Config2__PriceListItem__c> priceListItemByProductCodeSpecific;
		if(validPoolAgreementRecord != null) {
			priceListItemByProductCodeSpecific = getSpecificAgreementPricingMap(validPoolAgreementRecord, productCodes);
		}

		//create default pricing pool product code vs price list items map respecting the sequence - remove price list items that dosent fall between the dates
		Map<String, Apttus_Config2__PriceListItem__c> priceListItemByProductCodeDefaultPool = getDefaultPoolPricingMap(agreementNumbers, productCodes);

		//create response wrapper
		List<PricingData> productPricingData = new List<PricingData>();
		Boolean partialSuccess = false;
		for(String prdCode : productCodesList) {
			PricingData pd = new PricingData();
			pd.productCode = prdCode;
			pd.pricingStatus = STATUS_FAILED;

			Boolean validProduct = false;
			Boolean validPriceList = false;
			if(productByCode != null && productByCode.containsKey(prdCode)) {
				validProduct = true;
				Apttus_Config2__PriceListItem__c pli;
				if(priceListItemByProductCodeSpecific != null && !priceListItemByProductCodeSpecific.isEmpty()) {
					pli = priceListItemByProductCodeSpecific.containsKey(prdCode) ? priceListItemByProductCodeSpecific.get(prdCode) : null;
				}
				if(pli == null && priceListItemByProductCodeDefaultPool != null && !priceListItemByProductCodeDefaultPool.isEmpty()) {
					pli = priceListItemByProductCodeDefaultPool.containsKey(prdCode) ? priceListItemByProductCodeDefaultPool.get(prdCode) : null;
				}
				if(pli != null) {
					validPriceList = true;
					pd.pricingStatus = STATUS_SUCCESS;
					pd.agreementName = pli.CPQ_Agreement_Name__c;
					pd.unitPrice = pli.Apttus_Config2__ContractPrice__c != null ? pli.Apttus_Config2__ContractPrice__c : pli.Apttus_Config2__ListPrice__c;
				}
			}
			if(!validProduct || !validPriceList) partialSuccess = true;

			pd.productValidationInfo = new ProductValidationInfo(validProduct, validPriceList);
			productPricingData.add(pd);
		}
		response.pricingData = productPricingData;
		if(!partialSuccess) response.status = STATUS_SUCCESS;

		return response;
	}

	private static Account findCustomerAccountFromLegalEntity(String soldTo) {
		
		if(String.isBlank(soldTo)) return null;

		Account ultimateParent;

		Account level0Account = [SELECT Id, ParentId, AccountNumber FROM Account WHERE QTC_Sold_To__c =: soldTo LIMIT 1];
		if(level0Account == null) return null;
		if(level0Account.ParentId == null) {
			ultimateParent = level0Account;
		}

		Account level1Account;
		if(ultimateParent == null && level0Account.parentId != null) {
			level1Account = [SELECT Id, ParentId, AccountNumber FROM Account WHERE Id =:level0Account.ParentId][0];
			if(level1Account.ParentId == null) {
				ultimateParent = level1Account;
			}
		}

		Account level2Account;
		if(ultimateParent == null && level1Account.parentId != null) {
			level2Account = [SELECT Id, ParentId, AccountNumber FROM Account WHERE Id =:level1Account.ParentId][0];
			if(level2Account.ParentId == null) {
				ultimateParent = level2Account;
			}
		}

		Account level3Account;
		if(ultimateParent == null && level2Account.parentId != null) {
			level3Account = [SELECT Id, ParentId, AccountNumber FROM Account WHERE Id =:level2Account.ParentId][0];
			if(level3Account.ParentId == null) {
				ultimateParent = level3Account;
			}
		}

		Account level4Account;
		if(ultimateParent == null && level3Account.parentId != null) {
			level4Account = [SELECT Id, ParentId, AccountNumber FROM Account WHERE Id =:level3Account.ParentId][0];
			if(level4Account.ParentId == null) {
				ultimateParent = level4Account;
			}
		}


		return ultimateParent;
	}


	private static CPQ_PricingPool__c findDefaultPricingPool(Id accountId) {

		if(accountId == null) return null;

		List<CPQ_PricingPoolAccountMap__c> poolAccountMapList = [SELECT Id, CPQ_Pricing_Pool_ID__c FROM CPQ_PricingPoolAccountMap__c WHERE CPQ_Account__c = :accountId AND CPQ_Default__c = true ORDER BY LastModifiedDate DESC LIMIT 1];
		if(poolAccountMapList == null || poolAccountMapList.isEmpty()) return null;

		List<CPQ_PricingPool__c> poolList = [SELECT Id,CPQ_Pricing_Pool_Name__c, (SELECT Id,CPQ_Agreement_Name__c,CPQ_Agreement_Name__r.Name,CPQ_Agreement_Number__c FROM Pricing_Pool_Agreement_Maps__r WHERE CPQ_Active__c = true ORDER BY CPQ_Rank__c ASC NULLS LAST) FROM CPQ_PricingPool__c WHERE Id = :poolAccountMapList[0].CPQ_Pricing_Pool_ID__c];

		return poolList[0];
	}

	private static Map<String, Product2> getProductByProductCode(Set<String> productCodes) {

		if(productCodes == null || productCodes.isEmpty()) return null;

		Map<String, Product2> productByCode = new Map<String, Product2>();
		List<Product2> productList = [SELECT Id, ProductCode from Product2 WHERE ProductCode IN :productCodes];
		if(productList != null) {
			for(Product2 prd : productList) {
				productByCode.put(prd.ProductCode, prd);
			}
		}

		return productByCode;
	}

	private static List<String> getSequencedAgreementNumbers(List<CPQ_Pricing_Pool_Agreement_Map__c> poolAgreementList) {
		
		if(poolAgreementList == null || poolAgreementList.isEmpty()) return null;

		List<String> agreementNumbers = new List<String>();
		for(CPQ_Pricing_Pool_Agreement_Map__c poolAgrMap : poolAgreementList) {
			agreementNumbers.add(poolAgrMap.CPQ_Agreement_Number__c);
		}

		return agreementNumbers;
	}

	private static CPQ_Pricing_Pool_Agreement_Map__c findIfValidAgreementSpecifiedInTheRequest(List<CPQ_Pricing_Pool_Agreement_Map__c> poolAgreementList, String agreementName) {

		if(poolAgreementList == null || poolAgreementList.isEmpty() || String.isBlank(agreementName)) return null;

		CPQ_Pricing_Pool_Agreement_Map__c validAgreement;
		for(CPQ_Pricing_Pool_Agreement_Map__c poolAgrMap : poolAgreementList) {
			if(poolAgrMap.CPQ_Agreement_Name__r.Name.equalsIgnoreCase(agreementName)) {
				validAgreement = poolAgrMap;
				break;
			}
		}
		return validAgreement;
	}

	private static Map<String, Apttus_Config2__PriceListItem__c>  getSpecificAgreementPricingMap(CPQ_Pricing_Pool_Agreement_Map__c poolAgrMap, Set<String> productCodes) {

		if(poolAgrMap == null || productCodes == null || productCodes.isEmpty()) return null;

		Map<String, Apttus_Config2__PriceListItem__c> priceListItemByProductCode = new Map<String, Apttus_Config2__PriceListItem__c>();
		List<Apttus_Config2__PriceListItem__c> priceListItems = [
			SELECT 
				Id, CPQ_Agreement_Name__c, CPQ_Agreement_Number__c, Apttus_Config2__ListPrice__c, Apttus_Config2__ContractPrice__c, Apttus_Config2__ProductId__r.ProductCode, Apttus_Config2__EffectiveDate__c, Apttus_Config2__ExpirationDate__c
			FROM Apttus_Config2__PriceListItem__c
			WHERE Apttus_Config2__PriceListId__c = :poolAgrMap.CPQ_Agreement_Name__c AND Apttus_Config2__ProductId__r.ProductCode IN :productCodes AND Apttus_Config2__Active__c = true
		];
		DateTime currentTime = DateTime.now();
		for(Apttus_Config2__PriceListItem__c pli : priceListItems) {
			if(!priceListItemByProductCode.containsKey(pli.Apttus_Config2__ProductId__r.ProductCode)) {
				Boolean isValidPLI = true;
				if(pli.Apttus_Config2__EffectiveDate__c != null && currentTime < pli.Apttus_Config2__EffectiveDate__c) {
					isValidPLI = false;
				}
				if(pli.Apttus_Config2__ExpirationDate__c != null && currentTime > pli.Apttus_Config2__ExpirationDate__c) {
					isValidPLI = false;
				}
				if(isValidPLI) {
					priceListItemByProductCode.put(pli.Apttus_Config2__ProductId__r.ProductCode, pli);
				}
			}
		}

		return priceListItemByProductCode;
	}

	private static Map<String, Apttus_Config2__PriceListItem__c> getDefaultPoolPricingMap(List<String> agreementNumbers, Set<String> productCodes) {
		if(agreementNumbers == null || agreementNumbers.isEmpty() || productCodes == null || productCodes.isEmpty()) return null;

		Map<String, Apttus_Config2__PriceListItem__c> priceListItemByProductCode = new Map<String, Apttus_Config2__PriceListItem__c>();
		Nokia_CPQ_Constants.AGREEMENT_NUMBERS = agreementNumbers;
		List<Apttus_Config2__PriceListItem__c> priceListItems = [
			SELECT 
				Id, CPQ_Agreement_Name__c, CPQ_Agreement_Number__c, Apttus_Config2__ListPrice__c, Apttus_Config2__ContractPrice__c, Apttus_Config2__ProductId__r.ProductCode, Apttus_Config2__EffectiveDate__c, Apttus_Config2__ExpirationDate__c
			FROM Apttus_Config2__PriceListItem__c
			WHERE CPQ_Agreement_Number__c IN :agreementNumbers AND Apttus_Config2__ProductId__r.ProductCode IN :productCodes AND Apttus_Config2__Active__c = true
		];
		List<CPQ_PriceListItemWrapper> pliWrapperList = makePLIWrapperList(priceListItems);
		pliWrapperList.sort();

		DateTime currentTime = DateTime.now();
		for(CPQ_PriceListItemWrapper pliWrapper : pliWrapperList) {
			Apttus_Config2__PriceListItem__c pli = pliWrapper.priceListItem;
			if(!priceListItemByProductCode.containsKey(pli.Apttus_Config2__ProductId__r.ProductCode)) {
				Boolean isValidPLI = true;
				if(pli.Apttus_Config2__EffectiveDate__c != null && currentTime < pli.Apttus_Config2__EffectiveDate__c) {
					isValidPLI = false;
				}
				if(pli.Apttus_Config2__ExpirationDate__c != null && currentTime > pli.Apttus_Config2__ExpirationDate__c) {
					isValidPLI = false;
				}
				if(isValidPLI) {
					priceListItemByProductCode.put(pli.Apttus_Config2__ProductId__r.ProductCode, pli);
				}
			}
		}

		return priceListItemByProductCode;
	}

	private static List<CPQ_PriceListItemWrapper> makePLIWrapperList(List<Apttus_Config2__PriceListItem__c> pliList) {
		List<CPQ_PriceListItemWrapper> pliWrapperList = new List<CPQ_PriceListItemWrapper>();
		for(Apttus_Config2__PriceListItem__c pli : pliList) {
			pliWrapperList.add(new CPQ_PriceListItemWrapper(pli));
		}
		return pliWrapperList;
	}
	//helper methods - end


	//wrapper classes - start
	global class DynamicPricingResponse {
		public String status {get;set;}
		public Boolean parentAccountFound {get; set;}
		public String parentAccountNumber {get;set;}
		public Boolean defaultPricingPoolFound {get;set;}
		public String defaultPricingPool {get;set;}
		public List<PricingData> pricingData {get;set;}
		public DynamicPricingResponse(){}
	}
	
	global class PricingData {
		public String productCode {get;set;}
		public String pricingStatus {get;set;}
		public String agreementName {get;set;}
		public Decimal unitPrice {get;set;}
		public ProductValidationInfo productValidationInfo {get;set;}
		public PricingData(){}
	}

	global class ProductValidationInfo {
		public Boolean validProduct;
		public Boolean validPriceList;

		public ProductValidationInfo(Boolean validProduct, Boolean validPriceList) {
			this.validProduct = validProduct;
			this.validPriceList = validPriceList;
		}
	}
	//wrapper classes - end

}