public class CH_CA_Product_Selection_Controller {

	static final string PRODUCT_LIMIT = '50';
	
	@AuraEnabled
	public static List<sObject> searchProductRelated(String productType, String searchValue, Id solutionId, Id productId, CH_ProductRelease__c prodRelease) {
		List<sObject> result = new List<sObject>();
		switch on productType {
			when 'product' {
	result = getProducts(solutionId, searchValue);
			}
			when 'solution' {
	result = getSolutions(productId);
			}
			when 'productRelease' {
	result = getProductReleases(productId, solutionId);
			} 
			when 'productVariant' {
	result = getProductVariants(productId);
			}
			when 'productModule' {
	result = getProductModules(productId);
			} 
		}
		return result;
	}

	// If no solution is selected, get the first 50 products.
	// This is for performance reasons as there are too many products (use onchange to find products)
	// If a solution is selected, get all products for that solution
	private static List<sObject> getProducts(string solutionId, string searchString) {
		String soqlQuery = 'SELECT Id, Name, Description, PMD_Portfolio_Classification__c ' +
			'FROM Product2 ' +
			'WHERE CH_Valid__c = true ' + 
			'AND (PMD_Portfolio_Classification__c = \'Product\' ' + 
			'OR (PMD_Portfolio_Classification__c = \'Complementary Product\' AND PMD_Additional_Classification__c != \'Product Variant\') ' +
			'OR PMD_Portfolio_Classification__c = \'Parallel Product\' ' +
			'OR PMD_Portfolio_Classification__c = \'Service Module\' ' +
			'OR PMD_Portfolio_Classification__c = \'Service Product\' ' +
			'OR PMD_Portfolio_Classification__c = \'Solution\') '; 

		if(String.isNotBlank(searchString) && searchString.length() > 3) {
			system.debug('CH_PS: Search Criteria ' + searchString);
			soqlQuery += ' AND Name LIKE \'%' + searchString + '%\' ';
		}
		
		if (String.isNotBlank(solutionId)){
			system.debug('CH_PS: SolutionId ' + solutionId);
			
			Set<String> nokiaSolutionProductIds = new Set<String>();
			for(CH_ProductRelation__c curRel : [SELECT CH_Child_Product__c 
												FROM CH_ProductRelation__c 
												WHERE 
												 CH_Parent_Product__c =: solutionId AND 
												 CH_Parent_Type__c = 'NSN Solution'AND 
												 CH_Relation_For__c = 'ProductRelation' AND 
												 CH_Relation_Type__c = 'NSN Solution Consists Of']){
				nokiaSolutionProductIds.add(curRel.CH_Child_Product__c);
			}
			
			soqlQuery += ' AND id in: nokiaSolutionProductIds ';
		} 
		soqlQuery += 'ORDER BY Name '; 
		// If no search criteria return the a limit set intially. This will 
		// improve the performance because there are to many products
		if(String.isBlank(searchString) && String.isBlank(solutionId)) {
			system.debug('CH_PS: LIMIT 50 ');
			soqlQuery += ' LIMIT 50 '; 
		}
		
		List<sObject> result = Database.query(soqlQuery);
		system.debug('CH_PS: Get Products found: ' + result.size());
		return result;
	} 
	
	// If no product is selected, get all solutions
	// If a product is selected, get all solutions for that product
	private static List<sObject> getSolutions(Id productId){

		string soqlQuery = 
			'SELECT Id, Name, Description, PMD_Portfolio_Classification__c ' +
			'FROM Product2 ' + 
			'WHERE ' +
			' PMD_Portfolio_Classification__c = \'Solution\' ' + 
			' AND CH_VALID__C = True ';

		// If the product is not blank Then get all related solutions
		Set<String> nokiaSolutionIds = new Set<String>();
		if (productId != null){			
			for(CH_ProductRelation__c curRel : [SELECT CH_Parent_Product__c, CH_Child_Product_Name__c, CH_Parent_Product_Name__c 
											  FROM CH_ProductRelation__c 
											  WHERE 
											  CH_Child_Product__c =: productId  AND 
											  CH_Parent_Type__c = 'NSN Solution'AND 
											  CH_Relation_For__c = 'ProductRelation' AND 
											  CH_Relation_Type__c = 'NSN Solution Consists Of']){
				nokiaSolutionIds.add(curRel.CH_Parent_Product__c);
			}
			soqlQuery += ' AND Id in: nokiaSolutionIds ';
		}
		
		soqlQuery += 'ORDER BY Name ';
			
		List<sObject> result = Database.query(soqlQuery);
		system.debug('CH_PS: Solutions found: ' + result.size() + ' for product: ' + productId);
		return result;		
	}
	
	// Get all variants for the selected product
	private static List<sObject> getProductVariants(Id productId){
		// Get all variants related to the product
		Set<String> nokiaVariantIds = new Set<String>();
		for(CH_ProductRelation__c curRel : [SELECT CH_Child_Product__c, CH_Child_Product_Name__c, CH_Parent_Product_Name__c  
										  FROM CH_ProductRelation__c 
										  WHERE 
											CH_Parent_Product__c =: productId  AND 
											CH_Relation_For__c = 'ProductRelation' AND 
											CH_Relation_Type__c = 'NSN Is Complemented By']) {
			nokiaVariantIds.add(curRel.CH_Child_Product__c);
		}
		
		List<sObject> result = [SELECT Id, Name, Description 
								FROM Product2 
								WHERE 
								  Id in: nokiaVariantIds  
								  AND CH_Product_Type__c = 'Complementary Item'   
								  AND PMD_Portfolio_Classification__c = 'Complementary Product'  
								  AND PMD_Additional_Classification__c = 'Product Variant'  
								  AND CH_VALID__C = True];
		system.debug('CH_PS: Variants found: ' + result.size() + ' for product: ' + productId);
		return result;		
	}
	
	// Get all product/solution releases for the selected product/solution
	private static List<sObject> getProductReleases(Id productId, id solutionId){

		string soqlQuery = 
			'SELECT Id, Name, CH_Summary__c, CH_NSNParentClassification__c ' +
			'FROM CH_ProductRelease__c ' + 
			'WHERE ' +
			' CH_VALID__C = True ';
		
		if (solutionId != null && productId != null){
			soqlQuery += ' AND (CH_ProductId__c =: productId OR ' +
						'CH_ProductId__c =: solutionId)';
		}
		else if (productId != null) {
			soqlQuery += ' AND CH_ProductId__c =: productId ';
		} 
		else if (solutionId != null) {
			soqlQuery += ' AND CH_ProductId__c =: solutionId ';
		}
		
		List<sObject> result = Database.query(soqlQuery);
		system.debug('CH_PS: Releases found: ' + result.size() + ' for product: ' + productId + ' and solution: ' + solutionId);
		return result;		
	}
	
	// Get all product/solution releases for the selected product/solution
	private static List<sObject> getProductModules(Id productId){
		Set<String> nokiaModuleIds = new Set<String>();
		for(CH_ProductRelation__c curRel : [SELECT CH_Child_Product__r.Name, CH_Child_Product__r.Description, CH_Child_Product__r.NCP_Nokia_Product_Id__c 
											FROM CH_ProductRelation__c 
											WHERE 
											 CH_Relation_Type__c = 'NSN Is Complemented By' AND 
											 CH_Child_Type__c = 'NSN Complementary Item' AND 
											 CH_Parent_Product__c =: productId]) {
			nokiaModuleIds.add(curRel.CH_Child_Product__c);
		}
		
		List<sObject> result = [SELECT Id, Name, Description 
								FROM Product2 
								WHERE
								 Id in: nokiaModuleIds  
								 AND CH_Product_Type__c = 'Complementary Item'  
								 AND PMD_Portfolio_Classification__c = 'Product Modules'  
								 AND CH_Valid__c = True];	 
		system.debug('CH_PS: Modules found: ' + result.size() + ' for product: ' + productId);
		return result;		
	}
}