/** 
 * About 
 * ----- 
 * @Description : DML_SObject_Helper - Data Manager Helper with generic DML operations.
 * @testClass	: None.
 * @project		: All. 
 * @changeLog 	: 
 *  Created  : 2018 05 12 – flavio.toscano@nokia.com
 *  Modified : 2019 09 25 – tiago.almeida@nokia.com
 * ----- 
**/
public without sharing class DML_SObject_Helper {
	private static final String CLASS_NAME = DM_SObject.class.getName();
	
	/**
	 * @description DatabaseOperation - All supported dml operations.
	**/
	public enum DatabaseOperation {
		DBO_INSERT, DBO_UPDATE, DBO_DELETE, DBO_UPSERT
	}

	/**
	 * @description : Constructor
	 * @param 		:  objectType
	**/
	public DML_SObject_Helper() {
	}
	
	/**
	 * @description : Method used to do SObject Database Query (Bulk Query)
	 * @param 		: String query
	 * @return	: Database.QueryLocator
	**/
	public Database.QueryLocator getQueryLocator(String query) {
		return Database.getQueryLocator(query);
	}
		   
	/**
	 * @description : Method used to do SObject Database Query
	 * @param 		: String query
	 * @return	  : List<SObject>
	**/
	public List<SObject> doQuery(String query) {
		return Database.query(query);
	}
		   
	/**
	 * @description : Method used to do SObject Database Search
	 * @param 		: String query
	 * @return	  : List<List<sObject>>
	**/
	public List<List<sObject>> doSearch(String query) {
		return search.query(query);
	}

	/**
	 * @description : Method operates on passed collection of sobjects.
	 * @param 		: items Collection of objects, which have to be inserted.
	 * @param 		: operationType Selected DML operation.
	 * @param 		: allMustSucceed Flag, which means that all or none records must be inserted.
	 * @return 		: List<Id> Collection of inserted object's ids.
	**/
	public List<DMLOperationResult_DTO> doOperation(List<SObject> items, DatabaseOperation operationType, Boolean allMustSucceed, Schema.SObjectType OBJECT_TYPE) {
		Savepoint sp = null;
		if (allMustSucceed) {
			sp = Database.setSavepoint();
		}
		if(items != null) {
			items = removeDuplicates(items, OBJECT_TYPE);
			items.sort();
		}
		List<DMLOperationResult_DTO> operationResults = null;
		try {
			if (operationType == DatabaseOperation.DBO_INSERT) {
				operationResults = adaptOperationResults(Database.insert(items, allMustSucceed));
			}
			else if (operationType == DatabaseOperation.DBO_UPDATE) {
				operationResults = adaptOperationResults(Database.update(items, allMustSucceed));
			}
			else if (operationType == DatabaseOperation.DBO_DELETE) {
				operationResults = adaptOperationResults(Database.delete(items, allMustSucceed));
			}
			else if (operationType == DatabaseOperation.DBO_UPSERT) {
				operationResults = adaptOperationResults(Database.upsert(items, allMustSucceed));
			}
		}
		catch (Exception e) {
			if (sp != null) Database.rollback(sp);
			system.debug('###Exception from DM_SObject : '+e.getMessage() + 'Stack Trace : '+e.getStackTraceString());
			throw e;
		}
		return operationResults;
	}
	
	/**
	 * @description : Method clean passed collection from duplicates.
	 * @param 		: items Collection of objects to check.
	 * @return 		: List<SObject> Collection cleaned from duplicates.
	**/
	public List<SObject> removeDuplicates(List<SObject> items, Schema.SObjectType OBJECT_TYPE) {
		List<SObject> uniqElements = new List<SObject>(new Set<SObject>(items));
		//Used to avoid Apex exception : DML on generic List<SObject> only allowed for insert, update or delete
		if (OBJECT_TYPE != null) {
			String listType = 'List<' + OBJECT_TYPE + '>';
			List<SObject> castRecords = (List<SObject>)Type.forName(listType).newInstance();
			castRecords.addAll(uniqElements);
			return castRecords;
		}
		return uniqElements;
	}
	
	/**
	 * @description : Method convers passed collection to the type of adapter.
	 * @param	   : results Collection of objects, which have to be adapted.
	 * @return	  : List<DMLOperationResult_DTO> Collection of addapters.
	**/
	public List<DMLOperationResult_DTO> adaptOperationResults(List<Object> results) {
		List<DMLOperationResult_DTO> adaptedResults = null;
		if (results != null) {
			adaptedResults = new List<DMLOperationResult_DTO>();
			for (Object result: results) {
				if (result instanceof Database.SaveResult) {
					adaptedResults.add(new DMLOperationResult_DTO((Database.SaveResult) result));
				}
				else if (result instanceof Database.DeleteResult) {
					adaptedResults.add(new DMLOperationResult_DTO((Database.DeleteResult) result));
				}
				else if (result instanceof Database.UpsertResult) {
					adaptedResults.add(new DMLOperationResult_DTO((Database.UpsertResult) result));
				}
			}
		}
		return adaptedResults;
	}
}