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
	*				No param is needed because we return all products ~ 3500 products
	* @return		Json as a string
	*/
	@AuraEnabled
	public static String searchProductsJson() {
		//String searchKey = '%' + searchKeyWord + '%';
		List <sObject> returnList = new List <sObject>();
		// Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5
		/*String sQuery = 'SELECT Id, Name FROM Product2' +
				' WHERE  NCP_CAREACTIVATE__c != null AND (NokiaCPQ_State__c != \'Obsolete\' AND NokiaCPQ_State__c !=\'Rejected\' AND NCP_Product_Content_Count__c >0) '+
				'AND (PMD_Product_Item_Type__c = \'Design item\' OR PMD_Product_Item_Type__c = \'Service Design Item\' '+
				'OR PMD_Product_Item_Type__c = \'Complementary Item\' OR PMD_Product_Item_Type__c = \'Solution\' '+
				'OR PMD_Product_Item_Type__c = \'NSN Solution\' OR PMD_Product_Item_Type__c = \'NSN Service Design Item\') '+
				'ORDER BY NAME ASC';*/
	   String sQuery = 'SELECT Id, Name FROM Product2' +
				' WHERE DataUsage__c!=null AND PMD_Additional_Classification__c!=\'Product Variant\' AND (NokiaCPQ_State__c != \'Obsolete\' AND NokiaCPQ_State__c !=\'Rejected\' AND NCP_Product_Content_Count__c >0)'+
				'AND (PMD_Product_Item_Type__c = \'Design item\' OR PMD_Product_Item_Type__c = \'Service Design Item\' '+
				'OR PMD_Product_Item_Type__c = \'Complementary Item\'OR PMD_Product_Item_Type__c = \'NSN Solution\') '+
				'AND (PMD_Portfolio_Classification__c = \'Product\' OR PMD_Portfolio_Classification__c = \'Service Product\' '+
				'OR PMD_Portfolio_Classification__c = \'System\' OR PMD_Portfolio_Classification__c = \'System Module\' '+
				'OR PMD_Portfolio_Classification__c = \'Complementary Product\' OR PMD_Portfolio_Classification__c = \'Product Family\' '+
				'OR PMD_Portfolio_Classification__c = \'Complementary Cluster\' OR PMD_Portfolio_Classification__c = \'Parallel Product\' '+
				'OR PMD_Portfolio_Classification__c = \'Service Module\'OR PMD_Portfolio_Classification__c = \'Solution\') '+
				'ORDER BY NAME ASC';
		List<Product2> sobjList = Database.query(sQuery);
		System.debug('sobjList'+sobjList);
		List<ResultWrapper> lstRet = new List<ResultWrapper>();

		for(Product2 s : sobjList){
			ResultWrapper obj = new ResultWrapper();
			obj.Id = String.valueOf(s.Id) ;
			obj.Name = s.name;
			lstRet.add(obj);
		}
		return JSON.serialize(lstRet) ;

	}

	public class ResultWrapper{
		//public String objName {get;set;}
		public String Id{get;set;}
		public String Name{get;set;}
	}

}