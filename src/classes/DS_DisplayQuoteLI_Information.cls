/******************************************************************************************************
Name : DS_DisplayQuoteLI_Information
Created Date: 23rd Jan 2019
Created by: Accenture
Description : This class contains the logic for reading the Features associated with the bundle , Option and
			  standalone product.
*********************************************************************************************************/
public class DS_DisplayQuoteLI_Information {

   /******************************************************************************************************
	Name : getQuoteDetails
	Created Date: 23rd Jan 2019
	Created by: Accenture
	Description : This Method takes QuoteId as parameter and returns the Option Bundle and Standalone Product
				  details.
*********************************************************************************************************/

	@AuraEnabled
	public static List<CustomerGrouping> getQuoteDetails(String currentRecordId) {
		System.debug('currentRecordId--->'+currentRecordId);
		List<CustomerGrouping> customerGroupingList = new List<CustomerGrouping>();

		try {
			Map<Decimal, List<Apttus_Proposal__Proposal_Line_Item__c>> BLNQLMap = new Map<Decimal, List<Apttus_Proposal__Proposal_Line_Item__c>>();
			Map<Decimal, List<Apttus_Proposal__Proposal_Line_Item__c>> OLNQLMap = new Map<Decimal, List<Apttus_Proposal__Proposal_Line_Item__c>>();
			Map<Decimal, Apttus_Proposal__Proposal_Line_Item__c> standAloneQuoteLineMap = new Map<Decimal, Apttus_Proposal__Proposal_Line_Item__c>();

			Set<String> prodCodeSet = new Set<String>();

			Map<String, List<Product_Feature_Junction__c>> productFeatureMap = new Map<String, List<Product_Feature_Junction__c>>();

			//Querying the Quote/Proposal to get the associated currency.
			Apttus_Proposal__Proposal__c objProposal = [SELECT Id, CurrencyIsoCode FROM Apttus_Proposal__Proposal__c WHERE Id = :currentRecordId];

			//Below set of code will Map the Option Line item and Stand alone Product Line item.
			for (Apttus_Proposal__Proposal_Line_Item__c qLI : [SELECT Id, Apttus_QPConfig__Quantity2__c, Total_Option_Quantity__c, Apttus_Proposal__Proposal__c, Apttus_QPConfig__LineType__c, Apttus_QPConfig__LineNumber__c, NokiaCPQ_Configuration_Type__c, Apttus_Proposal__Product__c, Product_Code__c, NokiaCPQ_Product_Name__c, Apttus_QPConfig__NetPrice__c, NokiaCPQ_Quantity__c, Apttus_QPConfig__PriceListItemId__r.Hide_Bundle_Options__c, External_Reference__c, External_Description__c FROM Apttus_Proposal__Proposal_Line_Item__c WHERE Apttus_Proposal__Proposal__c = :currentRecordId ]) {
				prodCodeSet.add(qLI.Product_Code__c);

				if (qLI.NokiaCPQ_Configuration_Type__c == 'Bundle') {
					/*** BUNDLES ***/
					if (BLNQLMap.containsKey(qLI.Apttus_QPConfig__LineNumber__c)) {
						BLNQLMap.get(qLI.Apttus_QPConfig__LineNumber__c).add(qLI);
					} else {
						BLNQLMap.put(qLI.Apttus_QPConfig__LineNumber__c,new List<Apttus_Proposal__Proposal_Line_Item__c >{qLI});
					}
				} else if (qLI.Apttus_QPConfig__LineType__c =='Option') {
					/*** BUNDLE OPTIONS ***/
					if(OLNQLMap.containsKey(qLI.Apttus_QPConfig__LineNumber__c)){
						OLNQLMap.get(qLI.Apttus_QPConfig__LineNumber__c).add(qLI);
					} else {
						OLNQLMap.put(qLI.Apttus_QPConfig__LineNumber__c,new List<Apttus_Proposal__Proposal_Line_Item__c >{qLI});
					}
				} else if(qLI.Apttus_QPConfig__LineType__c =='Product/Service' && qLI.NokiaCPQ_Configuration_Type__c == 'Standalone') {
					/*** STANDALONE ITEMS ***/
					if (!standAloneQuoteLineMap.containsKey(qLI.Apttus_QPConfig__LineNumber__c)) {
						standAloneQuoteLineMap.put(qLI.Apttus_QPConfig__LineNumber__c,qLI);
					}
				}
			}

			//Forming FeatureMap associated to a product
			for (Product_Feature_Junction__c objProdFeatureJun : [SELECT Release_NSN_Code__c, Product__r.ProductCode, Product_Feature__r.Feature_Commercial_Number__c, Product__c, Product_Feature__r.Description__c, Release__r.Description__c, Product_Feature__c, Is_New__c, Release__c
																  FROM Product_Feature_Junction__c
																  WHERE Product__r.ProductCode  IN :prodCodeSet
																  AND GBOM_type__c = :CSWXGlobalConstant.DS_FeatureComponent
																  LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]) {
				if (!productFeatureMap.containsKey(objProdFeatureJun.Product__r.ProductCode)) {
					List<Product_Feature_Junction__c> featureJunction = new List<Product_Feature_Junction__c>();
					featureJunction.add(objProdFeatureJun);
					productFeatureMap.put(objProdFeatureJun.Product__r.ProductCode,featureJunction);
				} else {
					List<Product_Feature_Junction__c> featureJunction = productFeatureMap.get(objProdFeatureJun.Product__r.ProductCode);
					featureJunction.add(objProdFeatureJun);
					productFeatureMap.put(objProdFeatureJun.Product__r.ProductCode,featureJunction);
				}
			}

			//Below logic will Group the Products on Customer Grouping
			Map<String, CustomerGrouping> customerGroupingMap = new Map<String, CustomerGrouping>();
			for (Apttus_Proposal__Proposal_Line_Item__c qLI : [SELECT Id, Apttus_QPConfig__Quantity2__c, Total_Option_Quantity__c, DS_Grouping_Name__c, Apttus_Proposal__Proposal__c, Apttus_QPConfig__LineType__c, Apttus_QPConfig__LineNumber__c, NokiaCPQ_Configuration_Type__c, Apttus_Proposal__Product__c, Product_Code__c, NokiaCPQ_Product_Name__c, Apttus_QPConfig__NetPrice__c, NokiaCPQ_Quantity__c, Apttus_QPConfig__PriceListItemId__r.Hide_Bundle_Options__c, External_Description__c, External_Reference__c
															   FROM Apttus_Proposal__Proposal_Line_Item__c
															   WHERE Apttus_Proposal__Proposal__c = :currentRecordId
															   AND Apttus_QPConfig__LineType__c != 'Option']) {
				System.debug('qLI--->'+qLI);
				if (!String.isEmpty(qLI.DS_Grouping_Name__c)) {
					if (customerGroupingMap.containsKey(qLI.DS_Grouping_Name__c)) {
						//Reads the existing customer grouping.
						CustomerGrouping objCustomerGroup = customerGroupingMap.get(qLI.DS_Grouping_Name__c);
						//Below code associates bundle and its option products and its associated features.
						if (qLI.NokiaCPQ_Configuration_Type__c == 'Bundle' && qLI.Apttus_QPConfig__LineType__c == 'Product/Service') {
							BundleInfo objBundleInfo = new BundleInfo();
							objBundleInfo.objProd = qLI;
							objBundleInfo.optionsBundleList = new List<ProductFeatureWrapper>();
							objBundleInfo.isBundleOptionOpened = false;

							//Calculate the sum of new Price for Grouping
							if (qLI.Apttus_QPConfig__NetPrice__c != null) {
								objCustomerGroup.totalSum = objCustomerGroup.totalSum + qLI.Apttus_QPConfig__NetPrice__c;
							}

							//Gets All the Option item associated to the Bundle.
							if (OLNQLMap.containsKey(qLI.Apttus_QPConfig__LineNumber__c)) {
								List<Apttus_Proposal__Proposal_Line_Item__c> propLineItemList = OLNQLMap.get(qLI.Apttus_QPConfig__LineNumber__c);
								for (Apttus_Proposal__Proposal_Line_Item__c objPropLineItem : propLineItemList) {
									ProductFeatureWrapper objProdFeature = new ProductFeatureWrapper();
									objProdFeature.objProd = objPropLineItem;
									if (productFeatureMap.containsKey(objPropLineItem.Product_Code__c)) {
										objProdFeature.isFeatureExist = true;
										objProdFeature.isFeatureOpen = false;
										objProdFeature.proFeatureList = new List<Product_Feature_Junction__c>();
										objProdFeature.proFeatureList.addAll(productFeatureMap.get(objPropLineItem.Product_Code__c));
									} else {
										objProdFeature.isFeatureExist = false;
										objProdFeature.proFeatureList = new List<Product_Feature_Junction__c>();
										objProdFeature.isFeatureOpen = false;
									}
									objBundleInfo.optionsBundleList.add(objProdFeature);
								}
							}
							objCustomerGroup.objProdInformation.isBundleExist = True;
							objCustomerGroup.objProdInformation.lstBundle.add(objBundleInfo);
						} else if(qLI.NokiaCPQ_Configuration_Type__c == 'Standalone' && qLI.Apttus_QPConfig__LineType__c == 'Product/Service') {
							//List features associated with the standAlone product.
							standAloneInfo objStandAlone = new standAloneInfo();

							objStandAlone.standAloneObj = new ProductFeatureWrapper();
							objStandAlone.standAloneObj.objProd = qLI;
							objCustomerGroup.totalSum  = objCustomerGroup.totalSum + qLI.Apttus_QPConfig__NetPrice__c;
							if (productFeatureMap.containsKey(qLI.Product_Code__c)) {
								objStandAlone.standAloneObj.proFeatureList = new List<Product_Feature_Junction__c>();
								objStandAlone.standAloneObj.proFeatureList.addAll(productFeatureMap.get(qLI.Product_Code__c));
								objStandAlone.standAloneObj.isFeatureExist = true;
								objStandAlone.standAloneObj.isFeatureOpen = false;
							} else {
								objStandAlone.standAloneObj.isFeatureExist= false;
								objStandAlone.standAloneObj.isFeatureOpen = false;
							}
							objCustomerGroup.objProdInformation.isStandaloneExist = True;
							objCustomerGroup.objProdInformation.lstStandAlone.add(objStandAlone);
						}
						customerGroupingMap.put(qLI.DS_Grouping_Name__c,objCustomerGroup);
						System.debug('customerGroupingMap--->'+customerGroupingMap);
					} else {
						CustomerGrouping objCustomerGroup = new CustomerGrouping();
						objCustomerGroup.objProdInformation = new ProductInformation();
						objCustomerGroup.objProdInformation.lstBundle = new List<BundleInfo>();
						objCustomerGroup.objProdInformation.lstStandAlone = new List<standAloneInfo> ();
						objCustomerGroup.Name = qLI.DS_Grouping_Name__c;
						objCustomerGroup.currencyType = objProposal.CurrencyIsoCode;

						//If it is bundle products then adds all the options associated with bundle and associates all the
						// features associated with the option product.
						if (qLI.NokiaCPQ_Configuration_Type__c == 'Bundle' && qLI.Apttus_QPConfig__LineType__c == 'Product/Service') {
							BundleInfo objBundleInfo = new BundleInfo();
							objBundleInfo.objProd = qLI;
							if (qLI.Apttus_QPConfig__NetPrice__c != null) {
								objCustomerGroup.totalSum  = objCustomerGroup.totalSum + qLI.Apttus_QPConfig__NetPrice__c;
							}
							objBundleInfo.optionsBundleList = new List<ProductFeatureWrapper>();
							objBundleInfo.isBundleOptionOpened = false;

							//Gets All the Option item associated to the Bundle.
							if (OLNQLMap.containsKey(qLI.Apttus_QPConfig__LineNumber__c)) {
								List<Apttus_Proposal__Proposal_Line_Item__c> propLineItemList = OLNQLMap.get(qLI.Apttus_QPConfig__LineNumber__c);
								for (Apttus_Proposal__Proposal_Line_Item__c objPropLineItem : propLineItemList) {
									ProductFeatureWrapper objProdFeature = new ProductFeatureWrapper();
									objProdFeature.objProd = objPropLineItem;
									if (productFeatureMap.containsKey(objPropLineItem.Product_Code__c)) {
										objProdFeature.isFeatureExist = true;
										objProdFeature.isFeatureOpen = false;
										objProdFeature.proFeatureList = new List<Product_Feature_Junction__c>();
										objProdFeature.proFeatureList.addAll(productFeatureMap.get(objPropLineItem.Product_Code__c));
									} else {
										objProdFeature.isFeatureExist = false;
										objProdFeature.isFeatureOpen = false;
									}
									objBundleInfo.optionsBundleList.add(objProdFeature);
								}
							}
							objCustomerGroup.objProdInformation.isBundleExist = True;
							objCustomerGroup.objProdInformation.lstBundle.add(objBundleInfo);
						} else if (qLI.NokiaCPQ_Configuration_Type__c == 'Standalone' && qLI.Apttus_QPConfig__LineType__c == 'Product/Service') {
							//If the Product is Standalone then gets all features of the associated product.
							standAloneInfo objStandAlone = new standAloneInfo();
							objStandAlone.standAloneObj = new ProductFeatureWrapper();
							objStandAlone.standAloneObj.objProd = qLI;
							if (qLI.Apttus_QPConfig__NetPrice__c != null) {
								objCustomerGroup.totalSum  = objCustomerGroup.totalSum + qLI.Apttus_QPConfig__NetPrice__c;
							}
							if (productFeatureMap.containsKey(qLI.Product_Code__c)) {
								objStandAlone.standAloneObj.proFeatureList = new List<Product_Feature_Junction__c>();
								objStandAlone.standAloneObj.proFeatureList.addAll(productFeatureMap.get(qLI.Product_Code__c));
								objStandAlone.standAloneObj.isFeatureExist = true;
								objStandAlone.standAloneObj.isFeatureOpen = false;
							} else {
								objStandAlone.standAloneObj.isFeatureExist = false;
								objStandAlone.standAloneObj.isFeatureOpen = false;
							}
							objCustomerGroup.objProdInformation.isStandaloneExist = True;
							objCustomerGroup.objProdInformation.lstStandAlone.add(objStandAlone);
						}
						customerGroupingMap.put(qLI.DS_Grouping_Name__c,objCustomerGroup);
						System.debug('customerGroupingMap--->'+customerGroupingMap);
					}
				}
			}

			if (!customerGroupingMap.isEmpty()) {
				for (String key : customerGroupingMap.keySet()) {
					customerGroupingList.add(customerGroupingMap.get(key));
				}
			}
			System.debug('********customerGroupingMap***************'+customerGroupingMap);
		} catch (Exception e) {
			ExceptionHandler.addException(e, 'DS_DisplayQuoteLI_Information', '');
		}
		System.debug('customerGroupingList--->'+customerGroupingList);
		return customerGroupingList;
	}

	@AuraEnabled
	public static List<String> getAttributeLabelListForQuote(String recordId) {
		Set<String> labels = new Set<String>();
		//Collection of all visible Item level Labels where Attribute Label is populated
		for (Customer_facing_Attribute__c cfa : [SELECT Id, Attribute_Label__c
												 FROM Customer_facing_Attribute__c
												 WHERE Quote__c = :recordId AND Attribute_Visibility__c = 'Yes' AND Attribute_Indicator__c = 'Item' AND Attribute_Label__c != null AND Attribute_Value__c != null AND Quote_Line_Item__c != null
												 ORDER BY Attribute_Label__c ASC]) {
			labels.add(cfa.Attribute_Label__c);
		}
		List<String> labelList = new List<String>();
		for (String label : labels) {
			labelList.add(label);
		}
		return labelList;
	}

	@AuraEnabled
	public static Map<String, Map<String,String>> getAttributeMapForQuote(String recordId) {
		List<String> labelList = getAttributeLabelListForQuote(recordId);
		// Map of Line Item Id and List of Attributes to the Quote
		Map<String, Map<String,String>> attributeMap = new Map<String, Map<String,String>>();
		//Collection of all visible Item level Label-Value-Quote Line Item triplets where Attribute Label is populated
		for (Customer_facing_Attribute__c a : [SELECT Id, Attribute_Label__c, Attribute_Value__c, Quote_Line_Item__c
											   FROM Customer_facing_Attribute__c
											   WHERE Quote__c = :recordId AND Attribute_Visibility__c = 'Yes' AND Attribute_Indicator__c = 'Item' AND Attribute_Label__c != null AND Attribute_Value__c != null  AND Quote_Line_Item__c != null]) {
			if (attributeMap.containsKey(a.Quote_Line_Item__c)) {
				attributeMap.get(a.Quote_Line_Item__c).put(a.Attribute_Label__c, a.Attribute_Value__c);
			} else {
				Map<String, String> labelMap = new Map<String, String>();
				for (String label : labelList) {
					if(label == a.Attribute_Label__c) {
						labelMap.put(label, a.Attribute_Value__c);
					} else {
						labelMap.put(label, '');
					}
				}
				attributeMap.put(a.Quote_Line_Item__c, labelMap);
			}
		}
		return attributeMap;
	}

	public class CustomerGrouping {
	   @AuraEnabled public String Name;
	   @AuraEnabled public String currencyType;
	   @AuraEnabled public decimal totalSum =0 ;
	   @AuraEnabled public ProductInformation objProdInformation;
	}

	public class ProductInformation {
		@AuraEnabled public Boolean isBundleExist;
		@AuraEnabled public Boolean isStandaloneExist;
		@AuraEnabled public List<BundleInfo> lstBundle;
		@AuraEnabled public List<standAloneInfo> lstStandAlone;
	}

	public class standAloneInfo {
		@AuraEnabled public ProductFeatureWrapper standAloneObj;
	}

	public class BundleInfo {
		@AuraEnabled public Apttus_Proposal__Proposal_Line_Item__c objProd;
		@AuraEnabled public Boolean isBundleOptionOpened = false;
		@AuraEnabled public List<ProductFeatureWrapper> optionsBundleList;
	}

	public class OptionInfo {
		@AuraEnabled public ProductFeatureWrapper OptionWithFeature;
	}

	public class ProductFeatureWrapper {

		@AuraEnabled public Apttus_Proposal__Proposal_Line_Item__c objProd;
		@AuraEnabled public Boolean isFeatureExist ;
		@AuraEnabled public Boolean isFeatureOpen = false;
		@AuraEnabled public List<Product_Feature_Junction__c> proFeatureList;
	}
}