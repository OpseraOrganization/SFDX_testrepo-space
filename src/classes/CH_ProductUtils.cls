/** 
 * About
 * ----- 
 * @Description	: Case Handling Product Object Utility Class. 
 * @TestClass	: None.
 * @Project  : Case Handling.
 * @Modification Log : 
 *  Created  : 2019 10 30 – tiago.almeida@nokia.com
 * -----
**/
public with sharing class CH_ProductUtils {
  public final static Set<String> PRODUCT_NOT_NOKIACPQ_STATE = new Set<String>{ 'Obsolete','Rejected' };
  public final static Set<String> PRODUCT_NOT_PORTFOLIO_CLASS = new Set<String>{
	'SW','Complementary Cluster','Documentation Modules','Generic Modules','HW Modules','NE Modules','Parallel Product','Product Family','Product Modules','Service Work Items','SW Modules','System Modules'
  };
  public final static Set<String> PRODUCT_NOT_ADDITIONAL_CLASS = new Set<String>{ 'Multivendor Product','Pilot','Product Variant','Replacing Product' };
  //
  private final static String QUERY_SELECT = 'SELECT Child_Name__c, Child_Type__c, Parent_Name__c, Parent_Type__c, RelationType__c FROM Product_Relation__c WHERE';
  private final static String BASE_FILTER = 'Parent_Product__r.NokiaCPQ_State__c NOT IN ' + DML_SObject.setToString(PRODUCT_NOT_NOKIACPQ_STATE) + ' AND ' +
	'Child_Product__r.NokiaCPQ_State__c NOT IN ' + DML_SObject.setToString(PRODUCT_NOT_NOKIACPQ_STATE) + ' AND ' +
	'EDPActiveStatus__c = true';
  private final static Map<String, String> PRODUCT_RELATION_TO_FILTER = new Map<String, String>{
	'product'	=>  'Parent_Type__c IN ("Design Item","NSN Service Design Item","NSN Solution","Complementary Item") AND ' +
  'Parent_Product__r.CH_Valid__c = true AND ' +
  'Parent_Product__r.PMD_Portfolio_Classification__c NOT IN ' + DML_SObject.setToString(PRODUCT_NOT_PORTFOLIO_CLASS) + ' AND ' +
  'Parent_Product__r.PMD_Additional_Classification__c NOT IN ' + DML_SObject.setToString(PRODUCT_NOT_ADDITIONAL_CLASS),
	//
	'product->productRelease'  =>  'Parent_Type__c IN ("Design Item","NSN Service Design Item","NSN Solution","Complementary Item") AND ' +
  'Parent_Product__r.PMD_Portfolio_Classification__c NOT IN ("SW") AND ' +
  'RelationType__c IN ("NSN Main Product","Products") AND ' +
  'Child_Type__c IN ("NSN Release","NSN Solution Release", "NSN Complementary Release")' ,
	//
	'product->productModule'   =>  'Parent_Type__c IN ("Design Item","NSN Service Design Item","NSN Solution","Complementary Item") AND ' +
  'Parent_Product__r.PMD_Portfolio_Classification__c NOT IN ("SW") AND ' +
  'RelationType__c IN ("NSN Is Complemented By") AND ' +
  'Child_Type__c IN ("NSN Complementary Item") AND ' +
  'Child_Product__r.PMD_Portfolio_Classification__c IN ("Product Modules","HW Modules","Generic Modules","Documentation Modules") AND '+
  'Child_Product__r.PMD_Additional_Classification__c NOT IN ("Product Variant")',
	//
	'product->productVariant'  =>  'Parent_Type__c IN ("Design Item","NSN Service Design Item","NSN Solution","Complementary Item") AND ' +
  'Parent_Product__r.PMD_Portfolio_Classification__c NOT IN ("SW") AND ' +
  'RelationType__c IN ("NSN Is Complemented By") AND ' +
  'Child_Type__c IN ("NSN Complementary Item") AND ' +
  'Child_Product__r.PMD_Portfolio_Classification__c IN ("Complementary Product","Parallel Product","Product Modules") AND '+
  'Child_Product__r.PMD_Additional_Classification__c IN ("Product Variant")',
	//
	'product->solution'	 =>  'Parent_Type__c IN ("NSN Solution","NSN Solution Design Element") AND ' +
  'RelationType__c IN ("NSN Solution Consists Of") AND ' +
  'Child_Type__c IN ("NSN Design Item","NSN Service Design Item")' ,
	//
	'product->swComponent'	 =>  'Parent_Type__c IN ("Design Item","NSN Service Design Item") AND ' +
  'Parent_Product__r.PMD_Portfolio_Classification__c NOT IN ("SW") AND ' +
  'RelationType__c IN ("NSN Logically Consists Of") AND ' +
  'Child_Type__c IN ("NSN Design Item") AND ' +
  'Child_Product__r.PMD_Portfolio_Classification__c IN ("SW")',
	//
	'productRelease->swRelease' =>  'Parent_Type__c IN ("NSN Release","NSN Solution Release", "NSN Complementary Release") AND ' +
  'RelationType__c IN ("NSN Logically Consists Of") AND ' +
  'Child_Type__c IN ("NSN Release")',
	//
	'swComponent->swRelease'   =>  'Parent_Type__c IN ("Design Item") AND ' +
  'Parent_Product__r.PMD_Portfolio_Classification__c IN ("SW") AND ' +
  'RelationType__c IN ("NSN Main Product","Products") AND ' +
  'Child_Type__c IN ("NSN Release")',
	//
	'product->swModule'	 =>  'Parent_Type__c IN ("Design Item","NSN Service Design Item","NSN Solution", "Complementary Item") AND ' +
  'Parent_Product__r.PMD_Portfolio_Classification__c NOT IN ("SW") AND ' +
  'RelationType__c IN ("NSN Is Complemented By") AND ' +
  'Child_Type__c IN ("NSN Complementary Item") AND ' +
  'Child_Product__r.PMD_Portfolio_Classification__c IN ("SW Modules")',
	//
	'productVariant->swModule'  =>  'Parent_Type__c IN ("Complementary Item") AND ' +
  'Parent_Product__r.PMD_Portfolio_Classification__c IN ("Complementary Product","Parallel Product","Product Modules") AND ' +
  'Parent_Product__r.PMD_Additional_Classification__c IN ("Product Variant") AND ' +
  'RelationType__c IN ("NSN Is Complemented By") AND ' +
  'Child_Type__c IN ("NSN Complementary Item") AND ' +
  'Child_Product__r.PMD_Portfolio_Classification__c IN ("SW Modules") AND ' +
  'Child_Product__r.PMD_Additional_Classification__c NOT IN ("Product Variant")',
	//
	'swComponent->swModule'   =>  'Parent_Type__c IN ("Design Item") AND ' +
  'Parent_Product__r.PMD_Portfolio_Classification__c IN ("SW") AND ' +
  'RelationType__c IN ("NSN Is Complemented By") AND ' +
  'Child_Type__c IN ("NSN Complementary Item") AND ' +
  'Child_Product__r.PMD_Portfolio_Classification__c IN ("SW Modules") AND ' +
  'Child_Product__r.PMD_Additional_Classification__c NOT IN ("Product Variant")',
	//
	'productRelease->swBuild'   =>  'Parent_Type__c IN ("NSN Release","NSN Solution Release", "NSN Complementary Release") AND ' +
  '(NOT Parent_Product__r.PMD_Portfolio_Classification__c LIKE "%SW") AND ' +
  'RelationType__c IN ("NSN Provides Design Element") AND ' +
  'Child_Type__c IN ("NSN Design Element","NSN Solution Design Element","NSN NE Design Element")',
	//
	'swRelease->swBuild'	 =>  'Parent_Type__c IN ("NSN Release","NSN Solution Release", "NSN Complementary Release") AND ' +
  'RelationType__c IN ("NSN Provides Design Element") AND ' +
  'Child_Type__c IN ("NSN Design Element","NSN Solution Design Element","NSN NE Design Element")',
	//
	'swModule->swBuild'	 =>  'Parent_Type__c IN ("Complementary Item") AND ' +
  'Parent_Product__r.PMD_Portfolio_Classification__c IN ("SW Modules") AND ' +
  'RelationType__c IN ("NSN Has Design Element") AND ' +
  'Child_Type__c IN ("NSN Design Element","NSN Solution Design Element")',
	//
	'product->hwComponent'	 =>  'Parent_Type__c IN ("Design Item","NSN Service Design Item","NSN Solution", "Complementary Item") AND ' +
  'Parent_Product__r.PMD_Portfolio_Classification__c NOT IN ("SW") AND ' +
  'RelationType__c IN ("NSN Is Complemented By", "NSN Solution Consists Of") AND ' +
  'Child_Type__c IN ("NSN Design Item") AND ' +
  'Child_Product__r.PMD_Portfolio_Classification__c IN ("HW")'
  };
  
  /**
   * @description : Search for a specific Product in the Product Relation table.
   * @param	 : String searchString
   * @return	 : List<Product2>
  **/
  public static List<SObject> searchProducts(String searchString) {
	List<SObject> oProductList = new List<SObject>();
	if(String.isNotBlank(searchString)) {
	  searchString = String.escapeSingleQuotes(searchString.trim());
	  String query = QUERY_SELECT + ' ' + BASE_FILTER + ' AND ' + PRODUCT_RELATION_TO_FILTER.get('product');
	  query += ' AND (Parent_Product__r.Name LIKE \'%'+searchString+'%\' OR Parent_Product__r.Description LIKE \'%'+searchString+'%\' OR Parent_Product__r.NCP_Nokia_Product_Id__c LIKE \'%'+searchString+'%\')';
	  oProductList = convertFromProductRelation(DML_SObject.doQuery(query), 'Parent', 'Product2');
	}
	return oProductList;
  }
  
  /**
   * @description : Gets valid Products from an Id Set.
   * @param	 : Set<String> oProductIdSet
   * @return	 : Map<String, Product2>
  **/
  public static Map<String, Product2> getValidProductsFromIds(Set<String> oProductIdSet) {
	Map<String, Product2> oProductMap = new Map<String, Product2>();
	if(!oProductIdSet.isEmpty()) {
	  String query = QUERY_SELECT + ' ' + BASE_FILTER + ' AND ' + PRODUCT_RELATION_TO_FILTER.get('product');
	  query += ' AND Parent_Product__r.Id IN ' + DML_SObject.setToString(oProductIdSet);
	  oProductMap = new Map<String, Product2>((List<Product2>) convertFromProductRelation(DML_SObject.doQuery(query), 'Parent', 'Product2'));
	}
	return oProductMap;
  }
  
  /**
   * @description : Search for a specific child Product related to a parent Product or Product Release.
   * @param	 : String target
   * @param	 : String source
   * @param	 : String Nokia Product Id
   * @return	 : List<SObject>
  **/
  public static List<SObject> searchProductRelated(String target, Map<String,String> source) {
	String query = '';
	for(String parent : source.keySet()) {
	  String productRelationQuery = PRODUCT_RELATION_TO_FILTER.get(parent+'->'+target);
	  productRelationQuery += (productRelationQuery == '' ? '' : ' AND ') + (target == 'solution'?'Child':'Parent')+'_Name__c = "'+source.get(parent)+'"';
	  query += (query == '' ? '' : 'OR') + ' ( ' + productRelationQuery + ' ) ';
	}
	return String.isEmpty(query) ? new List<SObject>() : convertFromProductRelation(
	  DML_SObject.doQuery(QUERY_SELECT + ' ' + BASE_FILTER + ' AND ( ' + query + ' )'),
	  target == 'solution'?'Parent':'Child',
	  target.equals('swBuild')?'CH_Design_Element__c':(target.contains('Release')?'CH_ProductRelease__c':'Product2')
	);
  }
  
  /**
   * @description : Get all related products for a specific Product.
   * @param	 : String objectName
   * @param	 : String recordId
   * @param	 : String type
   * @return	 : List<Map<String, Object>>
  **/
  public static List<Map<String, Object>> getProductRelated(String objectName, String recordId, String type) {
	List<Map<String, Object>> result = new List<Map<String, Object>>();
	//Get Nokia Id
	String targetField = objectName.equals('Product2') ? 'NCP_Nokia_Product_Id__c' : 'CH_NSNLegacyCode__c';
	List<SObject> relatedProductList = DML_SObject.doQuery('SELECT Id, {0} FROM {1} WHERE Id = "{2}" LIMIT 1', new List<Object> {targetField, objectName, recordId});
	if(!relatedProductList.isEmpty()) {
	  String nokiaId = (String) relatedProductList.get(0).get(targetField);
	  String sourceType = type.equals('Parent')?'Child':'Parent';
	  String targetType = type;
	  //
	  List<SObject> oRelationList = DML_SObject.doQuery(
		'{0} {1}_Name__c = "{2}"', new List<Object> { QUERY_SELECT, sourceType, nokiaId }
	  );
	  Map<String, SObject> oNokiaIdtoRelationMap = new Map<String, SObject>();
	  for(SObject oRelation : oRelationList) { oNokiaIdtoRelationMap.put((String) oRelation.get(targetType + '_Name__c'), oRelation); }
	  //
	  List<String> objectTypes = new List<String>{'Product2', 'CH_ProductRelease__c', 'CH_Design_Element__c'};
	  for(Integer i = 0, size = objectTypes.size(); i < size; i++) {
		String targetObject = objectTypes.get(i);
		for(SObject oTarget : convertFromProductRelation(oRelationList, targetType, targetObject)) {
		  String targetNokiaId = (String) (targetObject.equals('Product2')?oTarget.get('NCP_Nokia_Product_Id__c'):oTarget.get('CH_NSNLegacyCode__c'));
		  result.add(new Map<String, Object>{
			'Id' => oTarget.get('Id'),
			'Name' => oTarget.get('Name'),
			'ProductCode' => targetNokiaId,
			'RelationType' => oNokiaIdtoRelationMap.get(targetNokiaId).get('RelationType__c'),
			'Type' => oNokiaIdtoRelationMap.get(targetNokiaId).get(targetType+'_Type__c'),
			'C10Scheduled' => targetObject.equals('CH_ProductRelease__c')?oTarget.get('CH_Obsolete__c'):'',
			'State' => targetObject.equals('Product2')?oTarget.get('NokiaCPQ_State__c'):oTarget.get('CH_Lifecyclestatus__c'),
			'NSNCode' => targetObject.equals('Product2')?oTarget.get('NCP_NSNCode__c'):oTarget.get('CH_NSN_Code__c'),
			'PortfolioClassification' => targetObject.equals('Product2')?oTarget.get('PMD_Portfolio_Classification__c'):'',
			'AdditionalClassification' => targetObject.equals('Product2')?oTarget.get('PMD_Additional_Classification__c'):''
		  });
		}
	  }
	}
	return result;
  }
	
  /**
   * @description : Get the Product from the Product Relation.
   * @param	 : List<Product_Relation__c> oProductRelationList
   * @param	 : String target
   * @return	 : List<SObject>
  **/
  private static List<SObject> convertFromProductRelation(List<Product_Relation__c> oProductRelationList, String target, String objectTable) {
	List<SObject> result = new List<SObject>();
	if(!oProductRelationList.isEmpty()) {
	  Set<String> sProductIdSet = new Set<String>();
	  Map<String, String> sProductIdtoTypeMap = new Map<String, String>();
	  for(Product_Relation__c oProductRelation : oProductRelationList) {
  sProductIdtoTypeMap.put((String) oProductRelation.get(target+'_Name__c'), (String) oProductRelation.get(target+'_Type__c'));
	  }
	  if(objectTable.equals('Product2')) {
  for(Product2 oProduct : (List<Product2>) DML_SObject.doQuery(
	'SELECT Id, Name, CH_Business_Group__c, NokiaCPQ_State__c, Description, NCP_Nokia_Product_Id__c, CH_Product_Type__c, PMD_Portfolio_Classification__c, PMD_Additional_Classification__c, NCP_NSNCode__c FROM {0} WHERE NCP_Nokia_Product_Id__c IN {1}',
	new List<Object> {objectTable, DML_SObject.setToString(sProductIdtoTypeMap.keySet())}
  )) {
	oProduct.CH_Product_Type__c = sProductIdtoTypeMap.get(oProduct.NCP_Nokia_Product_Id__c);
	result.add(oProduct);
  }
	  }
	  else {
  result = DML_SObject.doQuery(
	'SELECT Id, Name, CH_NSNLegacyCode__c, CH_Lifecyclestatus__c, CH_NSN_Code__c{2} FROM {0} WHERE CH_NSNLegacyCode__c IN {1}',
	new List<Object> {
	  objectTable,
	  DML_SObject.setToString(sProductIdtoTypeMap.keySet()),
	  objectTable.equals('CH_ProductRelease__c') ? ', CH_Obsolete__c' : ''
	}
  );
	  } 
	}
	return result;
  }
}