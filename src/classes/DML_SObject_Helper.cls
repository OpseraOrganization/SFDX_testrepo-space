/** 
 * About 
 * ----- 
 * @Description : DML_SObject_Helper - Data Manager Helper with generic DML operations.
 * @testClass	: DML_SObject_Test.
 * @project		: All. 
 * @changeLog 	: 
 *  Created  : 2018 05 12 – flavio.toscano@nokia.com
 *  Modified : 2019 09 25 – tiago.almeida@nokia.com
 * -----
**/
public without sharing class DML_SObject_Helper {
	private static Set<String> sRetryKeySet = null;
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
	public DML_SObject_Helper() {}
	
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
	public List<SObject> query(String query) {
		return Database.query(query);
	}
	 
	/**
	 * @description : Method used to do SObject Database Search
	 * @param 		: String query
	 * @return	  : List<List<sObject>>
	**/
	public List<List<sObject>> searchQuery(String query) {
		return search.query(query);
	}
	 
	/**
	 * @description : Method used to do SObject Database Query and return the count
	 * @param 		: String query
	 * @return	  : Integer
	**/
	public Integer countQuery(String query) {
		return Database.countQuery(query);
	}

	/**
	 * @description : Method operates on passed collection of sobjects.
	 * @param 		: items Collection of objects, which have to be inserted.
	 * @param 		: operationType Selected DML operation.
	 * @param 		: allMustSucceed Flag, which means that all or none records must be inserted.
	 * @param	 : retryAttempt Flag, which means if the operation fails, a retry attempt will be made.
	 * @return 		: List<Id> Collection of inserted object's ids.
	**/
	public List<DMLOperationResult_DTO> doOperation(List<SObject> items, DatabaseOperation operationType, Boolean allMustSucceed, Boolean retryAttempt) {
		Savepoint sp = null;
		if (allMustSucceed) {
			sp = Database.setSavepoint();
		}
		List<DMLOperationResult_DTO> operationResults = null;
		try {
			if(Limits.getDmlRows() + items.size() >= Limits.getLimitDmlRows()) {
	throw new DmlException('System.LimitException: Too many DML rows: 10001');
			}
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
			for(DMLOperationResult_DTO oOperationResult : operationResults) {
	if(!oOperationResult.isSuccess()) {
		throw new DmlException(oOperationResult.getErrors().get(0).getMessage());
	}
			}
		}
		catch (Exception e) {
			if (sp != null) Database.rollback(sp);
			if(retryAttempt && checkIfCritical(e)) {
	System.debug('###Exception submited for retry from DML_SObject_Helper : '+e.getMessage() + 'Stack Trace : '+e.getStackTraceString());
	Database.executeBatch(new DML_SObject_Batch(getFailedItems(operationResults, items), operationType, true));
			}
			else new DML_CriticalErrorHandler(e, operationName(operationType), items);
		}
		return operationResults;
	}
	
	/**
	 * @description : Method that check if Exception is acceptable for retry.
	 * @param 		: Error Message.
	 * @return 		: Boolean.
	**/
	public Boolean checkIfCritical(Exception error) {
		String errorMessage = error.getMessage();
		Boolean result = false;
		if(sRetryKeySet == null) { sRetryKeySet = smartSplit(DML_Controller__c.getInstance().DML_RetryKeys__c); }
		for(String retryKey : sRetryKeySet) {
			result = errorMessage.contains(retryKey);
			if((String.isNotBlank(retryKey) && errorMessage.indexOf(retryKey) != -1) || result == true) {
	return true;
			}
		}
		return false;
	}
	
	/**
	 * @description : Method clean passed collection from duplicates.
	 * @param 		: items Collection of objects to check.
	 * @return 		: List<SObject> Collection cleaned from duplicates.
	**/
	public List<SObject> getFailedItems(List<DMLOperationResult_DTO> operationResults, List<SObject> items) {
		if(operationResults == null) { return items; }
		List<SObject> failedItems = new List<SObject>();
		Integer len = operationResults.size();
		for(Integer i = 0; i < len; i++) {
			if(!operationResults.get(i).isSuccess()) {
	failedItems.add(items.get(i));
			}
		}
		return failedItems;
	}
	
	/**
	 * @description : Method clean passed collection from duplicates.
	 * @param 		: items Collection of objects to check.
	 * @return 		: List<SObject> Collection cleaned from duplicates.
	**/
	public List<SObject> removeDuplicates(List<SObject> items) {
		return items.isEmpty() ? items : new List<SObject>(new Set<SObject>(items));
	}
	
	/**
	 * @description : Method used to avoid Apex exception : DML on generic List<SObject> only allowed for insert, update or delete
	 * @param 		: items Collection of objects to check.
	 * @return 		: List<SObject> Collection cast as the original SObject.
	**/
	public List<SObject> castSObject(List<SObject> items, Schema.SObjectType objectType) {
		if (objectType != null) {
			String listType = 'List<' + objectType + '>';
			List<SObject> castRecords = (List<SObject>)Type.forName(listType).newInstance();
			castRecords.addAll(items);
			return castRecords;
		}
		return items;
	}
	
	/**
	 * @description : Method convers passed collection to the type of adapter.
	 * @param	: results Collection of objects, which have to be adapted.
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
	
	public static String operationName(DatabaseOperation operationType) {
		if (operationType == DatabaseOperation.DBO_INSERT) {
			return 'Insert Operation';
		}
		else if (operationType == DatabaseOperation.DBO_UPDATE) {
			return 'Update Operation';
		}
		else if (operationType == DatabaseOperation.DBO_DELETE) {
			return 'Delete Operation';
		}
		else if (operationType == DatabaseOperation.DBO_UPSERT) {
			return 'Upsert Operation';
		}
		return 'Unkown Operation';
	}
	
	private Set<String> smartSplit(String input) {
		if(String.isBlank(input)){ return new Set<String>(); }
		input = input.replaceAll(',',';').replaceAll('\\r?\\n|\\r','').replaceAll(';\\s',';');
		return (input.indexOf(';') != -1 ? new Set<String>(input.split(';')) : new Set<String>{input});
	}
}