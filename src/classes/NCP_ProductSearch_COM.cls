/**
About
-----
Description: Controller for the product search component

Created for: Nokia Customer Portal
Created date: 03 19 2018

Update History
--------------
Created: 03 19 2018 – DOM

Issues / TODOs
--------------
**/
public with sharing class NCP_ProductSearch_COM {
	/*
	* @description   generic method to search for objects
	* @param		 searchKeyWord: the string searched
	* @param		 objectName: the name of the object
	* @return		list of sobject
	*/
	@AuraEnabled
	public static List <sObject> searchProducts(String searchKeyWord, String objectName) {
		return NCP_Utils.searchRecords(searchKeyWord,objectName);
	}

	/*
	* @description   generic method to search for objects - Returning Json as String,
	*	No param is needed because we return all products ~ 3500 products
	* @return		Json as a string
	* Modified By	Nokia - SB
	* Modified Date	27 July 2021
	* Changes:		As part of Demand# SP-63
	*	1. Dynamic Query changed to Static Query
	*	2. Portfolio Classification now restricted to Product, Service Product, Complementary Product, Solution
	*/
	@AuraEnabled
	public static String searchProductsJson() {
		List<ResultWrapper> lstRet = new List<ResultWrapper>();
		for(Product2 productRecord : [SELECT Id, Name
			 FROM Product2
			  WHERE PMD_Additional_Classification__c != 'Product Variant' AND
				NokiaCPQ_State__c NOT IN ('Obsolete', 'Rejected') AND
					(PMD_Product_Item_Type__c IN ('Design item', 'Service Design Item', 'Complementary Item', 'NSN Solution')) AND 
					(PMD_Portfolio_Classification__c IN ('Product', 'Service Product', 'Complementary Product', 'Solution')) AND
					IsActive = true
			  ORDER BY NAME ASC]){
			ResultWrapper obj = new ResultWrapper();
			obj.Id = String.valueOf(productRecord.Id) ;
			obj.Name = productRecord.name;
			lstRet.add(obj);
		}
		return JSON.serialize(lstRet);
	}

	public class ResultWrapper{
		//public String objName {get;set;}
		public String Id{get;set;}
		public String Name{get;set;}
	}

}