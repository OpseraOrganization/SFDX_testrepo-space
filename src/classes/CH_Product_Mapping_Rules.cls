/*****************************************************************
Description:														  
Get the mapping rules for a specfic name from NokiaCPQ_PMDI_Parameter__c.

History																													 
DATE		 AUTHOR		Change
01/08/2018   Jeroen de Vries  Created
*****************************************************************/
public without sharing class CH_Product_Mapping_Rules {

	public Map<string, string> mapping = new Map<string, string>();
	private List<string> sourceFields = new List<string>();
	private List<string> targetFields = new List<string>();
	public string sourceObjectName;
	public string targetObjectName;
	
	/*****************************************************************
	Description:  
	Constructor that gets the mapping parameters.

	Parameters: parameterSectionName is the name of the grouping of parameters to get 
	from NokiaCPQ_PMDI_Parameter__c.
	Returns: NA
	Throws [Exceptions]: [optional]													   
	
	History														 
	DATE		   AUTHOR		  Change
	01/08/2018   Jeroen de Vries  Created
	*****************************************************************/
	public CH_Product_Mapping_Rules(string parameterSectionName){
		List<NokiaCPQ_PMDI_Parameter__c> mappingParameters = new List<NokiaCPQ_PMDI_Parameter__c>();

		// Get the mapping data
		mappingParameters = [SELECT 
								Name, 
						NokiaCPQ_ObjNameSrc__c, 
						NokiaCPQ_ObjNameTrg__c, 
						NokiaCPQ_ParaFrom__c, 
						NokiaCPQ_ParaTo__c, 
						NokiaCPQ_ParaType__c, 
						NokiaCPQ_ReqMap__c 
					  FROM 
						NokiaCPQ_PMDI_Parameter__c 
					  WHERE 
						NokiaCPQ_Active__c=true AND 
						NokiaCPQ_ParaType__c IN ('MAPPING RULE') AND
								Name = :parameterSectionName
					 ORDER BY 
						NokiaCPQ_ObjNameSrc__c];
		
		System.debug('parameters found: ' + mappingParameters.size());
		
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
		}
		
		System.debug('sourceObjectName: ' + sourceObjectName);
		System.debug('targetObjectName: ' + targetObjectName);
	}
	
	public sObject getSourceRecord(Id recordId){
		// Get the source record
		String sourceQuery = ' SELECT ' +
					String.join( sourceFields, ',' ) +
					' FROM ' + sourceObjectName + 
				 ' WHERE Id = \'' + recordId + '\'' +
					' LIMIT 1';
		System.debug('source query: ' + sourceQuery);
		SObject sourceRecord = Database.query(sourceQuery);
		System.debug('source record: ' + sourceRecord.get('Id'));
		return sourceRecord;
	}
	
	public Id getParentRecord(String childRelationShipProductCode, String childRelationshipType){
		// Get the target records
		String parentQuery = ' SELECT Parent_Product__c ' +
					' FROM Product_Relation__c ' + 
				 ' WHERE Child_Name__c  = \'' + childRelationShipProductCode + '\' AND ' + 
				 '	 Child_Type__c  = \'' + childRelationshipType + '\'' +
					' LIMIT 1';
		System.debug('parent query: ' + parentQuery);
		List<SObject> parentRecords = Database.query(parentQuery);
			
		System.debug('parent records found: ' + parentRecords.size());
		if (parentRecords.size()>0){
			return parentRecords[0].Id;
		}
		return null;
	}
	
	public List<CH_ProductRelation__c> getParentRecords(String childRelationShipProductCode){
		// Get the target records
		String parentQuery = ' SELECT Parent_Name__c, Parent_Product__c ,Parent_Type__c,Child_Name__c,Child_Product__c,Child_Type__c ,RelationFor__c, RelationType__c ' +
					' FROM Product_Relation__c ' + 
				 ' WHERE Child_Name__c  = \'' + childRelationShipProductCode + '\' AND ' + 
				 '	 Parent_Type__c  in (\'NSN Solution\',\'NSN Solution Release\',\'NSN Release\',\'Design Item\')';
		
		List<Product_Relation__c> parentRecords = Database.query(parentQuery);
		System.debug('parent query: ' + parentQuery);
		System.debug('parent records found: ' + parentRecords.size());
		
		List<CH_ProductRelation__c> caseHandlingProductRelations = new List<CH_ProductRelation__c>();
		for(Product_Relation__c productRelationShip : parentRecords){
			CH_ProductRelation__c caseHandlingProductRelation = new CH_ProductRelation__c();
			caseHandlingProductRelation.CH_Parent_Product_Name__c = productRelationShip.Parent_Name__c;
			caseHandlingProductRelation.CH_Parent_Product__c = productRelationShip.Parent_Product__c;
			caseHandlingProductRelation.CH_Parent_Type__c  = productRelationShip.Parent_Type__c;
			caseHandlingProductRelation.CH_Child_Product_Name__c = productRelationShip.Child_Name__c;
			caseHandlingProductRelation.CH_Child_Product__c = productRelationShip.Child_Product__c;
			caseHandlingProductRelation.CH_Child_Type__c = productRelationShip.Child_Type__c ;
			caseHandlingProductRelation.CH_Relation_For__c = productRelationShip.RelationFor__c;
			caseHandlingProductRelation.CH_Relation_Type__c = productRelationShip.RelationType__c;
			caseHandlingProductRelation.CH_ExternalId__c = productRelationShip.Parent_Name__c + ' ' + productRelationShip.Child_Name__c;
			caseHandlingProductRelations.add(caseHandlingProductRelation);
		}
			
		return caseHandlingProductRelations;
	}
		
	public sObject mapDataFromSourceToTarget(sObject sourceRecord, sObject targetRecord){
		// Loop through all the mapping parameters
		for (String sourceFieldName : mapping.keySet()){
			// Update the target with the source field
			string targetFieldName = mapping.get(sourceFieldName);
			System.debug('sourceFieldName: ' + sourceFieldName);
			System.debug('targetFieldName: ' + targetFieldName);
			
			object sourcFieldValue = (String)sourceRecord.get(sourceFieldName);
			System.debug('map ' + sourceObjectName + '.' + sourceFieldName + ' to: ' + targetObjectName + '.' + targetFieldName);

			Schema.SObjectType objectDescription = Schema.getGlobalDescribe().get(targetObjectName);
			Schema.DescribeSObjectResult r = objectDescription.getDescribe();
			Schema.DescribeFieldResult targetFieldType = r.fields.getMap().get(targetFieldName).getDescribe();

			if (targetFieldType.getType() == Schema.DisplayType.BOOLEAN){
				if (sourcFieldValue == null){
					sourcFieldValue = '';
				}
				sourcFieldValue = Boolean.valueOf(sourcFieldValue);
			}
			if (String.valueOf(sourcFieldValue) == 'RampDown'){
				sourcFieldValue = 'Ramp Down';
			}
			
			targetRecord.put(targetFieldName, sourcFieldValue);
		}
		
		return targetRecord;
	}
}