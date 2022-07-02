/**
About
-----
Description: DM_WS_SObject - Data Manager with generic DML operations with User Permissions Override.

Created for: Nokia Portugal COE
Created: 28 04 2019

Update History
--------------
Created: 28 04 2019 – flavio.toscano@nokia.com
-------------
**/
public abstract without sharing class DM_WS_SObject {
	private static final String CLASS_NAME = DM_SObject.class.getName();
	private static final Map <String, Schema.SObjectType> schemaMap;
	static {
		schemaMap = Schema.getGlobalDescribe();
	}

	/**
	 * @description DatabaseOperation - All supported dml operations.
	 */
	private enum DatabaseOperation
	{
		DBO_INSERT, DBO_UPDATE, DBO_DELETE, DBO_UPSERT
	}

	public Database.QueryLocator getQueryLocator(String query){
		return Database.getQueryLocator(query);
	}

	/**
	 * @description Method delete passed collection of sobjects.
	 * @param items Collection of objects, which have to be deleted.
	 * @param allMustSucceed Flag, which means that all or none records must be deleted.
	 * @return List<Id> Collection of deelted object's ids.
	 */
	public List<DMLOperationResult_DTO> doDelete(List<SObject> items, Boolean allMustSucceed)
	{
		List<DMLOperationResult_DTO> operationResults = doOperation(items, DatabaseOperation.DBO_DELETE, allMustSucceed, null);
		system.debug('cenasDM_WS'+operationResults);
		return operationResults;
	}

	/**
	 * @description Method inserts passed collection of sobjects.
	 * @param items Collection of objects, which have to be inserted.
	 * @param allMustSucceed Flag, which means that all or none records must be inserted.
	 * @return List<Id> Collection of inserted object's ids.
	 */
	public List<DMLOperationResult_DTO> doInsert(List<SObject> items, Boolean allMustSucceed)
	{
		List<DMLOperationResult_DTO> operationResults = doOperation(items, DatabaseOperation.DBO_INSERT, allMustSucceed, null);
		return operationResults;
	}

	/**
	* @description Method upsert passed collection of sobjects.
	* @param items Collection of objects, which have to be upserted.
	* @param allMustSucceed Flag, which means that all or none records must be upserted.
	* @return List<Id> Collection of upserted object's ids.
	*/
	public List<DMLOperationResult_DTO> doUpsert(List<SObject> items, Boolean allMustSucceed, sObjectType sObjectTypevar)
	{
		List<DMLOperationResult_DTO> operationResults = doOperation(items, DatabaseOperation.DBO_UPSERT, allMustSucceed, sObjectTypevar);
		return operationResults;
	}

	/**
	 * @description Method updates passed collection of sobjects.
	 * @param items Collection of objects, which have to be updated.
	 * @param allMustSucceed Flag, which means that all or none records must be updated.
	 * @return List<Id> Collection of updated object's ids.
	 */
	public List<DMLOperationResult_DTO> doUpdate(List<SObject> items, Boolean allMustSucceed)
	{
		List<DMLOperationResult_DTO> operationResults = doOperation(items, DatabaseOperation.DBO_UPDATE, allMustSucceed, null);
		return operationResults;
	}

	/**
	 * @description Method operates on passed collection of sobjects.
	 * @param items Collection of objects, which have to be inserted.
	 * @param operationType Selected DML operation.
	 * @param allMustSucceed Flag, which means that all or none records must be inserted.
	 * @return List<Id> Collection of inserted object's ids.
	 */
	private static List<DMLOperationResult_DTO> doOperation(List<SObject> items, DatabaseOperation operationType, Boolean allMustSucceed, SObjectType sObjectTypeLoc)
	{
		Savepoint sp = null;
		if (allMustSucceed){
			sp = Database.setSavepoint();
		}
		List<SObject> itemsToOperate = removeDuplicates(items, sObjectTypeLoc);
		itemsToOperate.sort();

		List<DMLOperationResult_DTO> operationResults = null;
		try {
			if (operationType == DatabaseOperation.DBO_INSERT){
				operationResults = adaptOperationResults(Database.insert(items, allMustSucceed));
			}
			else if (operationType == DatabaseOperation.DBO_UPDATE){
				operationResults = adaptOperationResults(Database.update(items, allMustSucceed));
			}
			else if (operationType == DatabaseOperation.DBO_DELETE){
				operationResults = adaptOperationResults(Database.delete(items, allMustSucceed));
			}
			else if (operationType == DatabaseOperation.DBO_UPSERT){
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
	 * @description Method clean passed collection from duplicates.
	 * @param items Collection of objects to check.
	 * @return List<SObject> Collection cleaned from duplicates.
	 */
	private static List<SObject> removeDuplicates(List<SObject> items, sObjectType sObjectTypeLoc)
	{
		List<SObject> uniqElements = new List<SObject>(new Set<SObject>(items));
		//Used to avoid Apex exception : DML on generic List<SObject> only allowed for insert, update or delete
		if (sObjectTypeLoc != null){
			String listType = 'List<' + sObjectTypeLoc + '>';
			List<SObject> castRecords = (List<SObject>)Type.forName(listType).newInstance();
			castRecords.addAll(uniqElements);
			return castRecords;
		}
		return uniqElements;
	}

	/**
	 * @description Method convers passed collection to the type of adapter.
	 * @param results Collection of objects, which have to be adapted.
	 * @return List<DMLOperationResult_DTO> Collection of addapters.
	 */
	private static List<DMLOperationResult_DTO> adaptOperationResults(List<Object> results)
	{
		if (results == null){
			return null;
		}
		List<DMLOperationResult_DTO> adaptedResults = new List<DMLOperationResult_DTO>();
		for (Object result: results) {
			if (result instanceof Database.SaveResult){
				adaptedResults.add(new DMLOperationResult_DTO((Database.SaveResult) result));
			}
			else if (result instanceof Database.DeleteResult){
				adaptedResults.add(new DMLOperationResult_DTO((Database.DeleteResult) result));
			}
			else if (result instanceof Database.UpsertResult){
				adaptedResults.add(new DMLOperationResult_DTO((Database.UpsertResult) result));
			}
		}
		return adaptedResults;
	}
}