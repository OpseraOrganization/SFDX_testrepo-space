/*
 * Last Modified Date : 03/04/2021
 * User Story  : NOKIASC-34960
 * 
 */
public without sharing class CH_Import_Mapping_UTIL {

	public string sourceObjectName; 
	public string targetObjectName;
	public Map<string, string> mapping = new Map<string, string>();
	private List<string> sourceFields = new List<string>();
	private List<string> targetFields = new List<string>();
	
	/*****************************************************************
	Description:  
	Constructor that gets the mapping parameters.

	Parameters: parameterSectionName is the name of the grouping of parameters to get 
	from NokiaCPQ_PMDI_Parameter__c.
	Returns: NA
	Throws [Exceptions]: [optional]				
	
	History						
	DATE	 AUTHOR	 Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/
	public CH_Import_Mapping_UTIL(string parameterSectionName){
		List<NokiaCPQ_PMDI_Parameter__c> mappingParameters = new List<NokiaCPQ_PMDI_Parameter__c>();

		// Get the mapping data
		mappingParameters = [SELECT Name, NokiaCPQ_ObjNameSrc__c, NokiaCPQ_ObjNameTrg__c, NokiaCPQ_ParaFrom__c, NokiaCPQ_ParaTo__c, NokiaCPQ_ParaType__c, NokiaCPQ_ReqMap__c FROM NokiaCPQ_PMDI_Parameter__c WHERE NokiaCPQ_Active__c = TRUE AND NokiaCPQ_ParaType__c IN ('MAPPING RULE') AND Name = :parameterSectionName ORDER BY NokiaCPQ_ObjNameSrc__c];
		system.debug('mappingParameters:' +mappingParameters);		
		// Get all source and target fields
		for (NokiaCPQ_PMDI_Parameter__c mappingParameter : mappingParameters){
			sourceFields.add(mappingParameter.NokiaCPQ_ParaFrom__c);
			targetFields.add(mappingParameter.NokiaCPQ_ParaTo__c);
			mapping.put(mappingParameter.NokiaCPQ_ParaFrom__c, mappingParameter.NokiaCPQ_ParaTo__c);
		}
		
		if (mappingParameters.size() > 0){
			// Assumption that all parameters with the same sectionname
			// have the same source and target sObjects
			sourceObjectName = mappingParameters[0].NokiaCPQ_ObjNameSrc__c;
			targetObjectName = mappingParameters[0].NokiaCPQ_ObjNameTrg__c;
			system.debug('sourceObjectName:' +sourceObjectName);
			system.debug('targetObjectName:' +targetObjectName);
			system.debug('sourceFields:' +sourceFields);
			system.debug('targetFields:' +targetFields);
		}
	}
	
	/*****************************************************************
	Description:  
	Get all records from the staging table that needs processing.
	With the constructor all mapping parameters are retrieved.
	Based on these mapping parameters the source fields and source object (staging table)
	are known.

	Parameters: whereClause is a string that specifies extra filter criteria.
	The format needs to be ' where <criteria> '
	additionalfields is a string with fields to retrieve but that will not be used 
	in the mapping from source to target. The format is ', <fields> '
	Returns: List of objects that needs processing
	Throws [Exceptions]: [optional]				
	
	History						
	DATE	 AUTHOR	 Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/
	public List<sObject> getSourceRecords(string whereClause, string additionalFields){
		// Get the source record
		String sourceQuery = 'SELECT Id,' + String.join(sourceFields, ',' ) + additionalFields + ' FROM ' + sourceObjectName + ' ' + whereClause;	
		System.debug('source query: ' + sourceQuery);
		return Database.query(sourceQuery);
	}
 
	/*****************************************************************
	Description:  
	Based on the external id, get the id of the Product2 record.

	Parameters: externalId is the NSN Legacy Code that is an external id on Product2
	Returns: Id of the found record
	Throws [Exceptions]: [optional]				
	
	History						
	DATE	 AUTHOR	 Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/   
	public Id getProduct2Id(String externalId){
		String productIdQuery = 'SELECT Id FROM Product2 WHERE NCP_NOKIA_PRODUCT_ID__C = \'' + externalId + '\'' + ' LIMIT 1';
		System.debug('parent query: ' + productIdQuery);
		List<SObject> productRecords = Database.query(productIdQuery);	
		System.debug('parent records found: ' + productRecords.size());
		if (productRecords.size()>0){
			return productRecords[0].Id;
		}
		return null;
	}	 

	/*****************************************************************
	Description:  
	Based on the found relationship records (for a product/product release record), 
	get the parent product records.

	Parameters: relatedProductsFromStaging, list of relationship records
	Returns: Map with the parent product record and the NSN Legecay code as key
	Throws [Exceptions]: [optional]				
	
	History						
	DATE	 AUTHOR	 Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/
	public Map<String, Product2> getProduct2Records(List<Product_Relation__c> relatedProductsFromStaging){
		
		// Get all parent NSN Legacy codes 
		List<String> parentProductNames = new List<String>();
		for (Product_Relation__c parentProduct2Record : relatedProductsFromStaging){
			parentProductNames.add(parentProduct2Record.Parent_Name__c);
		}
		
		// If no related products found exit
		if(parentProductNames.size() == 0){
			return null;
		}
		
		// Get all product2 records for the parents that relate to the found relationships		
		String productIdQuery = 'SELECT Id, NCP_NOKIA_PRODUCT_ID__C FROM Product2 WHERE NCP_NOKIA_PRODUCT_ID__C IN (\'' + String.join( parentProductNames, '\',\'' ) + '\')';
		System.debug('parent query: ' + productIdQuery);
		List<Product2> foundProduct2Records = Database.query(productIdQuery);
		
		// Create an easy searchable list of products
		Map<String, Product2> product2Records = new Map<String, Product2>();
		for (Product2 foundProduct2 : foundProduct2Records){
			product2Records.put(foundProduct2.NCP_Nokia_Product_Id__c ,foundProduct2);
		}
		return product2Records;
	}
	
	/*****************************************************************
	Description:  
	Based on the found relationship records (for a release record), 
	get the parent release records.

	Parameters: relatedProductsFromStaging, list of relationship records
	Returns: Map with the parent release record and the NSN Legecay code as key
	Throws [Exceptions]: [optional]				
	
	History						
	DATE	 AUTHOR	 Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/ 
	public Map<String, CH_ProductRelease__c> getProductReleaseRecords(List<Product_Relation__c> relatedProductsFromStaging){
		// Get all parent NSN Legacy codes 
		List<String> parentProductNames = new List<String>();
		for (Product_Relation__c parentProduct2Record : relatedProductsFromStaging){
			parentProductNames.add(parentProduct2Record.Parent_Name__c);
		}
		// Get all product2 records for the parents that relate to the found relationships		
		String releaseIdQuery = 'SELECT Id, CH_NSNLegacyCode__c FROM CH_ProductRelease__c WHERE CH_NSNLegacyCode__c IN (\'' + String.join( parentProductNames, '\',\'' ) + '\')';
		System.debug('parent query: ' + releaseIdQuery);
		List<CH_ProductRelease__c> foundProductReleaseRecords = Database.query(releaseIdQuery);
		
		// Create an easy searchable list of products
		Map<String, CH_ProductRelease__c> productReleaseRecords = new Map<String, CH_ProductRelease__c>();
		for (CH_ProductRelease__c foundProductRelease : foundProductReleaseRecords){
			productReleaseRecords.put(foundProductRelease.CH_NSNLegacyCode__c ,foundProductRelease);
		}
		return productReleaseRecords;
	} 

	/*****************************************************************
	Description:  
	Based on the found relationship records (for a DE record), 
	get the parent DE records.

	Parameters: relatedProductsFromStaging, list of relationship records
	Returns: Map with the parent release record and the NSN Legecay code as key
	Throws [Exceptions]: [optional]				
	
	History						
	DATE	 AUTHOR	 Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/ 
	public Map<String, CH_Design_Element__c> getDesignElementRecords(List<Product_Relation__c> relatedProductsFromStaging){
		// Get all parent NSN Legacy codes 
		List<String> parentProductNames = new List<String>();
		for (Product_Relation__c parentProduct2Record : relatedProductsFromStaging){
			parentProductNames.add(parentProduct2Record.Parent_Name__c);
		}
		// Get all product2 records for the parents that relate to the found relationships		
		String releaseIdQuery = 'SELECT Id, CH_NSNLegacyCode__c FROM CH_Design_Element__c WHERE CH_NSNLegacyCode__c IN (\'' + String.join(parentProductNames, '\',\'' ) + '\')';
		System.debug('parent query: ' + releaseIdQuery);
		List<CH_Design_Element__c> foundDesignElementRecords = Database.query(releaseIdQuery);
		
		// Create an easy searchable list of products
		Map<String, CH_Design_Element__c> designElementRecords = new Map<String, CH_Design_Element__c>();
		for (CH_Design_Element__c foundDesignElement : foundDesignElementRecords){
			designElementRecords.put(foundDesignElement.CH_NSNLegacyCode__c ,foundDesignElement);
		}
		return designElementRecords;
	}
	
	/*****************************************************************
	Description:  
	Based on the external id, get the parent records

	Parameters: externalId is the NSN Legacy Code that is an external id
	inClause is a string in the format ('xxx','yyy') to create an in part of the where clause
	on the Parent_Type__c field
	Returns: Id of the found record
	Throws [Exceptions]: [optional]				
	
	History						
	DATE	 AUTHOR	 Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/ 
	public List<Product_Relation__c> getParentRecords(String childNsnLegacyProductCode, string inClause){
		String parentQuery = 'SELECT Id, Parent_Name__c, Parent_Type__c, Child_Name__c, Child_Type__c, RelationFor__c, RelationType__c FROM Product_Relation__c WHERE Child_Name__c  = \'' + childNsnLegacyProductCode + '\' AND Parent_Type__c IN ' + inClause;
		List<Product_Relation__c> parentRecords = Database.query(parentQuery);
	 	System.debug('parent query: ' + parentQuery);
		System.debug('parent records found: ' + parentRecords.size());
		
		return parentRecords;
	}
	
	/*****************************************************************
	Description:  
	Based on the external id, get the BG BU and BL records
	For BU and BL, the product is the parent.
	BL is the child of the BG

	Parameters: externalId is the NSN Legacy Code that is an external id
	inClause is a string in the format ('xxx','yyy') to create an in part of the where clause
	on the Parent_Type__c field
	Returns: Id of the found record
	Throws [Exceptions]: [optional]				
	
	History						
	DATE	 AUTHOR	 Change
	01/08/2018	 Jeroen de Vries  Created  
	03/04/2021   NOKIASC-34960	Added condition :  NSNClassType__c   And EDP_ActiveStatus__c = true
	*****************************************************************/	 
	public List<ProductClassification__c> getProductHierarchyRecords(String childNsnLegacyProductCode){
		List<ProductClassification__c> productClassificationRecords = new List<ProductClassification__c>();
		
		// Get the BL
		String parentQuery = ' SELECT Id, Parent_Name__c, Parent_Type__c, Child_Name__c, RelationType__c, RelationFor__c FROM Product_Relation__c WHERE Parent_Name__c  = \'' + childNsnLegacyProductCode + '\' AND RelationType__c = \'NSN Owner Organization Class\' AND EDPActiveStatus__c = TRUE';
		List<Product_Relation__c> productHierachyRecords = Database.query(parentQuery);
		System.debug('BL hierarchy relationships records found: ' + productHierachyRecords.size());
		
		// Create a list of a all the found BLs to use in a query
		List<string> childBLNames = new List<string>();
		for (Product_Relation__c productRelation : productHierachyRecords){
			childBLNames.add(productRelation.Child_Name__c);
		}
		
		List<ProductClassification__c> tempProductClassificationRecords = new List<ProductClassification__c>();
		string childBLName;
		if (productHierachyRecords.size() > 0){
			// Get the BU BL classifactions for the product
			String classificationQuery = System.Label.CH_EDP_Product_BL;
			tempProductClassificationRecords = Database.query(classificationQuery);
			if (tempProductClassificationRecords.size() > 0) {
	childBLName = tempProductClassificationRecords[0].NSNClassnumber__c;
	productClassificationRecords.add(tempProductClassificationRecords[0]);
			}
		}   

		// Get the BU
		parentQuery = ' SELECT Id, Parent_Name__c, Parent_Type__c, Child_Name__c, RelationType__c, RelationFor__c FROM Product_Relation__c WHERE Child_Name__c  = \'' + childBLName + '\' AND RelationType__c  = \'SubClass\' AND EDPActiveStatus__c = TRUE';
		productHierachyRecords = Database.query(parentQuery);
		System.debug('BU hierarchy relationships records found: ' + productHierachyRecords.size());

		string childBUName;
		if (productHierachyRecords.size() > 0){
			childBUName = productHierachyRecords[0].Parent_Name__c;
			// Get the BU BL classifactions for the product
			String classificationQuery = System.Label.CH_EDP_Product_BU;
			tempProductClassificationRecords = Database.query(classificationQuery);
			productClassificationRecords.addAll(tempProductClassificationRecords);
		}
		// Get the BG
		parentQuery = 'SELECT Id, Parent_Name__c, Parent_Type__c, Child_Name__c, RelationType__c, RelationFor__c FROM Product_Relation__c WHERE Child_Name__c  = \'' + childBUName + '\' AND RelationType__c  = \'SubClass\' AND EDPActiveStatus__c = TRUE';
		productHierachyRecords = Database.query(parentQuery);
		System.debug('BG hierarchy relationships records found: ' + productHierachyRecords.size());
		string childBGName;
		if (productHierachyRecords.size() > 0){
			childBGName = productHierachyRecords[0].Parent_Name__c;
			// Get the BU BL classifactions for the product
			String classificationQuery = System.Label.CH_EDP_Product_BG;
			tempProductClassificationRecords = Database.query(classificationQuery);
			productClassificationRecords.addAll(tempProductClassificationRecords);
		}			
		return productClassificationRecords;
	}

	/*****************************************************************
	Description:  
	Based on the external id, get the parent release records.
	This is a seperate method because of the complicated where clause because the parent of
	the release can be products or other releases

	Parameters: externalId is the NSN Legacy Code that is an external id
	Returns: Id of the found record
	Throws [Exceptions]: [optional]				
	
	History						
	DATE	 AUTHOR	 Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/ 
	public List<Product_Relation__c> getReleaseParentRecords(String childNsnLegacyProductCode){
		String parentQuery = 'SELECT Id, Parent_Name__c, Parent_Type__c, RelationType__c, Child_Name__c, Child_Type__c, RelationFor__c FROM Product_Relation__c WHERE Child_Name__c  = \'' + childNsnLegacyProductCode + '\' AND ((Parent_Type__c  = \'NSN Release\' AND RelationType__c = \'NSN Logically Consists Of\') OR (Parent_Type__c  IN (\'Design Item\',\'Complementary Item\',\'Solution\')))';
		List<Product_Relation__c> parentRecords = Database.query(parentQuery);
	 	System.debug('Get parents for a release query: ' + parentQuery);
		System.debug('Parents for the release records found: ' + parentRecords.size());
		return parentRecords;		
	}
	
	/*****************************************************************
	Description:  
	Map the fields from the source record to the fields of the target record.
	The mapping comes from NokiaCPQ_PMDI_Parameter__c

	Parameters: 
	sourceRecord record from the staging table
 		- Product_Portfolio_Item__c
 		- ProductRelease__c
 		- DesignElement_Items__c
		- Product_Relation__c
	targetRecord record from the product table
		- Product2
		- CH_ProductRelease__c
		- CH_ProductRelation__c
		- CH_DesignElement__c
	Returns: List of Product_Relation__c records
	Throws [Exceptions]: [optional]				
	
	History						
	DATE	 AUTHOR	 Change
	01/08/2018	 Jeroen de Vries  Created  
	*****************************************************************/
	public sObject mapDataFromSourceToTarget(sObject sourceRecord, sObject targetRecord){
		// Loop through all the mapping parameters
		for (String sourceFieldName : mapping.keySet()){
			// Update the target with the source field
			string targetFieldName = mapping.get(sourceFieldName);
			object sourcFieldValue = sourceRecord.get(sourceFieldName);
			
			Schema.SObjectType objectDescription = Schema.getGlobalDescribe().get(targetObjectName);
			Schema.DescribeSObjectResult r = objectDescription.getDescribe();
			Schema.DescribeFieldResult targetFieldType = r.fields.getMap().get(targetFieldName).getDescribe();

			if ((targetFieldType.getType() == Schema.DisplayType.STRING && sourcFieldValue != null) && (((String)sourcFieldValue).length() > targetFieldType.length)){
	
	sourcFieldValue = ((String)sourcFieldValue).subString(0, targetFieldType.length);
	
			}
			if (targetFieldType.getType() == Schema.DisplayType.BOOLEAN){
	if (sourcFieldValue == null){
		sourcFieldValue = '';
	}
	sourcFieldValue = Boolean.valueOf(sourcFieldValue);
			}
			if (String.valueOf(sourcFieldValue) == 'RampDown'){
	sourcFieldValue = 'Ramp Down';
			}
			System.debug('map ' + sourceObjectName + '.' + sourceFieldName + ' value: ' + sourcFieldValue + ' to: ' + targetObjectName + '.' + targetFieldName);
			targetRecord.put(targetFieldName, sourcFieldValue);
		}
		return targetRecord;
	}
	
	/*****************************************************************
	Description:  
	Get the parent NSN Legeacy code for a child NSN Legacy code

	Parameters: 
	childRelationShipProductCode child NSN Legacy Product Code
	parentRelationshipType the type of relationship to get the parent for
	Returns: The NSN Legacy code of the parent record
	Throws [Exceptions]: [optional]				
	
	History						
	DATE	 AUTHOR	 Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/	
	public String getParentRecordName(String childRelationShipProductCode, String parentRelationshipType){
		// Get the target records
		String parentQuery = 'SELECT Parent_Name__c FROM Product_Relation__c WHERE Child_Name__c  = \'' + childRelationShipProductCode + '\' AND Parent_Type__c  = \'' + parentRelationshipType + '\' LIMIT 1';
		System.debug('parent query: ' + parentQuery);
		List<Product_Relation__c> parentRecords = Database.query(parentQuery);
		System.debug('parent records found: ' + parentRecords.size());
		if (parentRecords.size()>0){
			return parentRecords[0].Parent_Name__c;
		}
		return null;
	}
}