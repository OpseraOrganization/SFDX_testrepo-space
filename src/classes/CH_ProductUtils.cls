/** 
 * About 
 * ----- 
 * @Description	  : Case Handling Product Object Utility Class. 
 * @TestClass		: None.
 * @Project	: Case Handling.
 * @Modification Log : 
 *  Created  : 2019 10 30 – tiago.almeida@nokia.com
 * ----- 
**/
public with sharing class CH_ProductUtils {
	private final static Map<String, String> BASE_QUERY = new Map<String, String>{
		'Select' => 'SELECT Child_Name__c, Parent_Name__c FROM Product_Relation__c WHERE',
		'ParentType' 	=> 'Parent_Type__c IN (\'Design Item\',\'NSN Service Design Item\',\'NSN Solution\',\'Complementary Item\')',
		'ParentState' 	=> 'Parent_Product__r.NokiaCPQ_State__c NOT IN (\'Obsolete\',\'Rejected\')',
		'ChildState' 	=> 'Child_Product__r.NokiaCPQ_State__c NOT IN (\'Obsolete\',\'Rejected\')'
	};
	private final static Map<String, String> TARGET_QUERY_FILTER = new Map<String, String>{
		'product'	=> 	' AND RelationFor__c IN (\'ProductRelation\',null) AND Parent_Product__r.CH_Valid__c = true'+
					' AND Parent_Product__r.PMD_Portfolio_Classification__c NOT IN (\'SW\',\'Complementary Cluster\',\'Documentation Modules\',\'Generic Modules\',\'HW Modules\','+
					'\'NE Modules\',\'Parallel Product\',\'Product Family\',\'Product Modules\',\'Service Work Items\',\'SW Modules\',\'System Modules\')'+
					' AND Parent_Product__r.PMD_Additional_Classification__c NOT IN (\'Multivendor Product\',\'Pilot\',\'Product Variant\',\'Replacing Product\')',
		//
		'solution'			=> 	' AND Parent_Type__c IN (\'NSN Solution\',\'NSN Solution Design Element\')',
		//  
		'productVariant'	=> 	' AND Child_Product__r.PMD_Portfolio_Classification__c IN (\'Complementary Product\', \'Parallel Product\', \'Product\', \'Solution\')'+
		' AND Child_Product__r.PMD_Additional_Classification__c IN (\'Product Variant\', \'Life Extender Product\', null)'+
		' AND Child_Type__c IN (\'NSN Design Item\', \'NSN Complementary Item\', \'NSN Solution\')'+
		' AND RelationType__c IN (\'NSN Is Complemented By\', \'NSN Solution Consists Of\')',
		//  
		'productModule'		=> 	' AND Parent_Type__c IN (\'Complementary Item\',\'Design Item\',\'NSN Service Design Item\',\'NSN Solution\')'+
		' AND Child_Product__r.PMD_Portfolio_Classification__c IN (\'HW Modules\',\'Product Modules\',\'Service Module\',\'System Modules\',\'Documentation Modules\',\'Generic Modules\',null)'+
		' AND Child_Type__c = \'NSN Complementary Item\' AND RelationType__c = \'NSN Is Complemented By\'',
		//  
		'productRelease'	=> 	' AND Child_Type__c IN (\'NSN Release\',\'NSN Solution Release\',\'NSN Complementary Release\')'+
		' AND RelationType__c IN (\'NSN Main Product\',\'Products\')',
		//	 
		'swComponent'		=> 	' AND Parent_Type__c IN (\'Complementary Item\',\'Design Item\',\'NSN Service Design Item\')'+
		' AND RelationType__c IN (\'NSN is Complemented By\',\'NSN Logically Consists Of\')'+
		' AND Child_Product__r.PMD_Portfolio_Classification__c IN (\'SW\',null)'+
		' AND Child_Type__c  = \'NSN Design Item\'',
		//  
		'swModule'			=> 	' AND RelationType__c = \'NSN is Complemented By\''+
		' AND Child_Product__r.PMD_Portfolio_Classification__c IN (\'SW Modules\', null)'+
		' AND Child_Type__c = \'NSN Complementary Item\'',
		//  
		'hwComponent'		=> 	' AND Parent_Type__c  IN (\'Complementary Item\',\'Design Item\',\'NSN Service Design Item\')'+
		' AND RelationType__c IN (\'NSN is Complemented By\',\'NSN Logically Consists Of\')'+
		' AND Child_Product__r.PMD_Portfolio_Classification__c = \'HW \''+
		' AND Child_Type__c = \'NSN Design Item\'',
		//  
		'swRelease'			=> 	'',
		'swBuild'			=> 	''
	};
	
	/**
	 * @description : Search for a specific Product in the Product Relation table.
	 * @param 		: String searchString
	 * @return 		: List<Product2>
	**/
	public static List<SObject> searchProducts(String searchString) {
		List<SObject> oProductList = new List<SObject>();
		if(String.isNotBlank(searchString)) {
			searchString = String.escapeSingleQuotes(searchString.trim());
			String query = BASE_QUERY.get('Select')+' '+BASE_QUERY.get('ParentType')+' AND '+BASE_QUERY.get('ParentState')+' AND '+BASE_QUERY.get('ChildState');
			query += TARGET_QUERY_FILTER.get('product');
			query += ' AND (Parent_Product__r.Name LIKE \'%'+searchString+'%\' OR Parent_Product__r.Description LIKE \'%'+searchString+'%\' OR Parent_Product__r.NCP_Nokia_Product_Id__c LIKE \'%'+searchString+'%\')';
			oProductList = convertFromProductRelation(Database.query(query), 'Parent', 'Product');
		}
		return oProductList;
	}
	
	/**
	 * @description : Search for a specific child Product related to a parent Product or Product Release.
	 * @param 		: String target
	 * @param 		: String source
	 * @param 		: String Nokia Product Id
	 * @return 		: List<SObject>
	**/
	public static List<SObject> searchProductRelated(String target, String source, String nokiaProductId) {
		List<SObject> oResultList = new List<SObject>();
		//
		String query = BASE_QUERY.get('Select')+' '+BASE_QUERY.get('ChildState');
		if(target != 'prodRelease' && target != 'swModule' && target != 'swRelease' && target != 'swBuild') {
			query += ' AND '+BASE_QUERY.get('ParentState');
		}
		if(target == 'swModule' && source == 'product'){
			query += ' AND Parent_Type__c IN (\'Complementary Item\',\'Design Item\',\'NSN Service Design Item\',\'NSN Solution\')';
		}
		query += TARGET_QUERY_FILTER.get(target);
		query += ' AND '+(target == 'solution'?'Child':'Parent')+'_Name__c = \''+nokiaProductId+'\'';
		oResultList = convertFromProductRelation(Database.query(query), target == 'solution'?'Parent':'Child', target == 'swBuild'?'DesignElement':(target.contains('Release')?'ProductRelease':'Product'));
		return oResultList;
	}
		
	/**
	 * @description : Get the Product from the Product Relation.
	 * @param 		: List<Product_Relation__c> oProductRelationList
	 * @param 		: String target
	 * @return 		: List<SObject>
	**/
	private static List<SObject> convertFromProductRelation(List<Product_Relation__c> oProductRelationList, String target, String objectTable) {
		List<SObject> result = new List<SObject>();
		Set<String> sProductIdSet = new Set<String>();
		for(Product_Relation__c oProductRelation : oProductRelationList) {
			sProductIdSet.add((String) oProductRelation.get(target+'_Name__c'));
		}
		switch on objectTable {
			when 'Product' {
	result = [SELECT Id, Name, Description, NCP_Nokia_Product_Id__c, CH_Product_Type__c FROM Product2 WHERE NCP_Nokia_Product_Id__c IN :sProductIdSet];
			}
			when 'ProductRelease' {
	result = [SELECT Id, Name, CH_NSNLegacyCode__c FROM CH_ProductRelease__c WHERE CH_NSNLegacyCode__c IN :sProductIdSet];
			}
			when 'DesignElement' {
	result = [SELECT Id, Name, CH_NSNLegacyCode__c FROM CH_Design_Element__c WHERE CH_NSNLegacyCode__c IN :sProductIdSet];
			}			
		}
		return result;
	}
}