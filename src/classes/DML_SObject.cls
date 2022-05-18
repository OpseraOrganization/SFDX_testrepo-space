/** 
 * About 
 * ----- 
 * @Description : DML_SObject - Data Manager with generic DML operations.
 * @testClass	: DML_SObject_Test.
 * @project		: All. 
 * @changeLog 	: 
 *  Created  : 2018 05 12 – flavio.toscano@nokia.com
 *  Modified : 2019 09 25 – tiago.almeida@nokia.com
 * -----
**/
public with sharing class DML_SObject {
	private static final DML_SObject_Helper helper = new DML_SObject_Helper();
	private Schema.SObjectType OBJECT_TYPE = null;

	/**
	 * @description : Constructor
	 * @param 		: Schema.SObjectType objectType
	 */
	public DML_SObject(Schema.SObjectType objectType) {
		OBJECT_TYPE = objectType;
	}
	
	/**
	 * @description : Method used to do SObject Database Query (Bulk Query)
	 * @param 		: String query
	 * @return	: Database.QueryLocator
	**/
	public static Database.QueryLocator getQueryLocator(String query) {
		return Database.getQueryLocator(query.replaceAll('"', '\''));
	}
	
	/**
	 * @description : Method used to do SObject Database Query (Bulk Query)
	 * @param 		: String query
	 * @param		: withoutSharing Flag, which means that the query follows or not the sharing rules conditions.
	 * @return	: Database.QueryLocator
	**/
	public static Database.QueryLocator getQueryLocator(String query, Boolean withoutSharing) {
		query = query.replaceAll('"', '\'');
		return withoutSharing ? helper.getQueryLocator(query) : Database.getQueryLocator(query);
	}
	 
	/**
	 * @description : Method used to do SObject Database Query
	 * @param 		: String query
	 * @return	  : List<SObject>
	**/
	public static List<SObject> doQuery(String query) {
		return Database.query(query.replaceAll('"', '\''));
	}
	 
	/**
	 * @description : Method used to do SObject Database Query
	 * @param 		: String query
	 * @param 		: String parameters
	 * @return	  : List<SObject>
	**/
	public static List<SObject> doQuery(String query, List<Object> parameters) {
		return Database.query(String.format(query, parameters).replaceAll('"', '\''));
	}
	 
	/**
	 * @description : Method used to do SObject Database Query
	 * @param 		: String query
	 * @param		: withoutSharing Flag, which means that the query follows or not the sharing rules conditions.
	 * @return	  : List<SObject>
	**/
	public static List<SObject> doQuery(String query, Boolean withoutSharing) {
		query = query.replaceAll('"', '\'');
		return withoutSharing ? helper.query(query) :  Database.query(query);
	}
	 
	/**
	 * @description : Method used to do SObject Database Query
	 * @param 		: String query
	 * @param 		: String parameters
	 * @param		: withoutSharing Flag, which means that the query follows or not the sharing rules conditions.
	 * @return	  : List<SObject>
	**/
	public static List<SObject> doQuery(String query, List<Object> parameters, Boolean withoutSharing) {
		query = String.format(query, parameters).replaceAll('"', '\'');
		return withoutSharing ? helper.query(query) :  Database.query(query);
	}
	
	/**
	 * @description : Method used to do SObject Database Search
	 * @param 		: String query
	 * @return	  : List<List<sObject>>
	**/
	public static List<List<sObject>> doSearch(String query) {
		return search.query(query.replaceAll('"', '\''));
	}
	
	/**
	 * @description : Method used to do SObject Database Search
	 * @param 		: String query
	 * @return	  : List<List<sObject>>
	**/
	public static List<List<sObject>> doSearch(String query, Boolean withoutSharing) {
		query = query.replaceAll('"', '\'');
		return withoutSharing ? helper.searchQuery(query) : search.query(query);
	}
	
	/**
	 * @description : Method upsert passed collection of sobjects.
	 * @param	 : item, which have to be deleted.
	 * @return	 : Id of deleted object's ids.
	**/
	public static DMLOperationResult_DTO doDelete(SObject item) {
		return doOperation(new List<SObject>{item}, DML_SObject_Helper.DatabaseOperation.DBO_DELETE, false, false, false).get(0);
	}
	
	/**
	 * @description : Method upsert passed collection of sobjects.
	 * @param	 : item, which have to be deleted.
	 * @param	 : withoutSharing Flag, which means that the delete follows or not the sharing rules conditions.
	 * @return	 : Id of deleted object's ids.
	**/
	public static DMLOperationResult_DTO doDelete(SObject item, Boolean withoutSharing) {
		return doOperation(new List<SObject>{item}, DML_SObject_Helper.DatabaseOperation.DBO_DELETE, false, withoutSharing, false).get(0);
	}
	
	/**
	 * @description : Method upsert passed collection of sobjects.
	 * @param	 : item, which have to be deleted.
	 * @param	 : withoutSharing Flag, which means that the delete follows or not the sharing rules conditions.
	 * @param	 : retryAttempt Flag, which means if the operation fails, a retry attempt will be made.
	 * @return	 : Id of deleted object's ids.
	**/
	public static DMLOperationResult_DTO doDelete(SObject item, Boolean withoutSharing, Boolean retryAttempt) {
		return doOperation(new List<SObject>{item}, DML_SObject_Helper.DatabaseOperation.DBO_DELETE, false, withoutSharing, retryAttempt).get(0);
	}
	
	/**
	 * @description : Method upsert passed collection of sobjects.
	 * @param	 : items Collection of objects, which have to be deleted.
	 * @return	 : List<Id> Collection of deleted object's ids.
	**/
	public static List<DMLOperationResult_DTO> doDelete(List<SObject> items) {
		return doOperation(items, DML_SObject_Helper.DatabaseOperation.DBO_DELETE, true, false, false);
	}
	
	/**
	 * @description : Method upsert passed collection of sobjects.
	 * @param	 : items Collection of objects, which have to be deleted.
	 * @param	 : allMustSucceed Flag, which means that all or none records must be deleted.
	 * @return	 : List<Id> Collection of deleted object's ids.
	**/
	public static List<DMLOperationResult_DTO> doDelete(List<SObject> items, Boolean allMustSucceed) {
		return doOperation(items, DML_SObject_Helper.DatabaseOperation.DBO_DELETE, allMustSucceed, false, false);
	}
	
	/**
	 * @description : Method upsert passed collection of sobjects.
	 * @param	 : items Collection of objects, which have to be deleted.
	 * @param	 : allMustSucceed Flag, which means that all or none records must be deleted.
	 * @param		: withoutSharing Flag, which means that the delete follows or not the sharing rules conditions.
	 * @return	 : List<Id> Collection of deleted object's ids.
	**/
	public static List<DMLOperationResult_DTO> doDelete(List<SObject> items, Boolean allMustSucceed, Boolean withoutSharing) {
		return doOperation(items, DML_SObject_Helper.DatabaseOperation.DBO_DELETE, allMustSucceed, withoutSharing, false);
	}
	
	/**
	 * @description : Method upsert passed collection of sobjects.
	 * @param	 : items Collection of objects, which have to be deleted.
	 * @param	 : allMustSucceed Flag, which means that all or none records must be deleted.
	 * @param	 : withoutSharing Flag, which means that the delete follows or not the sharing rules conditions.
	 * @param	 : retryAttempt Flag, which means if the operation fails, a retry attempt will be made (Default : 5).
	 * @return	 : Id of deleted object's ids.
	**/
	public static List<DMLOperationResult_DTO> doDelete(List<SObject> items, Boolean allMustSucceed, Boolean withoutSharing, Boolean retryAttempt) {
		return doOperation(items, DML_SObject_Helper.DatabaseOperation.DBO_DELETE, allMustSucceed, withoutSharing, retryAttempt);
	}
	
	/**
	 * @description : Method upsert passed collection of sobjects.
	 * @param	 : item, which have to be inserted.
	 * @return	 : Id of inserted object's ids.
	**/
	public static DMLOperationResult_DTO doInsert(SObject item) {
		return doOperation(new List<SObject>{item}, DML_SObject_Helper.DatabaseOperation.DBO_INSERT, false, false, false).get(0);
	}
	
	/**
	 * @description : Method upsert passed collection of sobjects.
	 * @param	 : item, which have to be inserted.
	 * @param	 : withoutSharing Flag, which means that the insert follows or not the sharing rules conditions.
	 * @return	 : Id of inserted object's ids.
	**/
	public static DMLOperationResult_DTO doInsert(SObject item, Boolean withoutSharing) {
		return doOperation(new List<SObject>{item}, DML_SObject_Helper.DatabaseOperation.DBO_INSERT, false, withoutSharing, false).get(0);
	}
	
	/**
	 * @description : Method upsert passed collection of sobjects.
	 * @param	 : item, which have to be inserted.
	 * @param	 : withoutSharing Flag, which means that the insert follows or not the sharing rules conditions.
	 * @param	 : retryAttempt Flag, which means if the operation fails, a retry attempt will be made.
	 * @return	 : Id of inserted object's ids.
	**/
	public static DMLOperationResult_DTO doInsert(SObject item, Boolean withoutSharing, Boolean retryAttempt) {
		return doOperation(new List<SObject>{item}, DML_SObject_Helper.DatabaseOperation.DBO_INSERT, false, withoutSharing, retryAttempt).get(0);
	}
	
	/**
	 * @description : Method upsert passed collection of sobjects.
	 * @param	 : items Collection of objects, which have to be inserted.
	 * @return	 : List<Id> Collection of inserted object's ids.
	**/
	public static List<DMLOperationResult_DTO> doInsert(List<SObject> items) {
		return doOperation(items, DML_SObject_Helper.DatabaseOperation.DBO_INSERT, true, false, false);
	}
	
	/**
	 * @description : Method upsert passed collection of sobjects.
	 * @param	 : items Collection of objects, which have to be inserted.
	 * @param	 : allMustSucceed Flag, which means that all or none records must be inserted.
	 * @return	 : List<Id> Collection of inserted object's ids.
	**/
	public static List<DMLOperationResult_DTO> doInsert(List<SObject> items, Boolean allMustSucceed) {
		return doOperation(items, DML_SObject_Helper.DatabaseOperation.DBO_INSERT, allMustSucceed, false, false);
	}
	
	/**
	 * @description : Method upsert passed collection of sobjects.
	 * @param	 : items Collection of objects, which have to be inserted.
	 * @param	 : allMustSucceed Flag, which means that all or none records must be inserted.
	 * @param		: withoutSharing Flag, which means that the insert follows or not the sharing rules conditions.
	 * @return	 : List<Id> Collection of inserted object's ids.
	**/
	public static List<DMLOperationResult_DTO> doInsert(List<SObject> items, Boolean allMustSucceed, Boolean withoutSharing) {
		return doOperation(items, DML_SObject_Helper.DatabaseOperation.DBO_INSERT, allMustSucceed, withoutSharing, false);
	}
	
	/**
	 * @description : Method upsert passed collection of sobjects.
	 * @param	 : items Collection of objects, which have to be inserted.
	 * @param	 : allMustSucceed Flag, which means that all or none records must be inserted.
	 * @param	 : withoutSharing Flag, which means that the insert follows or not the sharing rules conditions.
	 * @param	 : retryAttempt Flag, which means if the operation fails, a retry attempt will be made.
	 * @return	 : List<Id> Collection of inserted object's ids.
	**/
	public static List<DMLOperationResult_DTO> doInsert(List<SObject> items, Boolean allMustSucceed, Boolean withoutSharing, Boolean retryAttempt) {
		return doOperation(items, DML_SObject_Helper.DatabaseOperation.DBO_INSERT, allMustSucceed, withoutSharing, retryAttempt);
	}

	/**
	 * @description : Method upsert passed collection of sobjects.
	 * @param	 : item, which have to be upserted.
	 * @return	 : Id of upserted object's ids.
	**/
	public DMLOperationResult_DTO doUpsert(SObject item) {
		return doUpsert(new List<SObject>{item}).get(0);
	}

	/**
	 * @description : Method upsert passed collection of sobjects.
	 * @param	 : item, which have to be upserted.
	 * @param	 : withoutSharing Flag, which means that the upsert follows or not the sharing rules conditions.
	 * @return	 : Id of upserted object's ids.
	**/
	public DMLOperationResult_DTO doUpsert(SObject item, Boolean withoutSharing) {
		return doUpsert(new List<SObject>{item}, false, withoutSharing).get(0);
	}

	/**
	 * @description : Method upsert passed collection of sobjects.
	 * @param	 : item, which have to be upserted.
	 * @param	 : withoutSharing Flag, which means that the upsert follows or not the sharing rules conditions.
	 * @param	 : retryAttempt Flag, which means if the operation fails, a retry attempt will be made.
	 * @return	 : Id of upserted object's ids.
	**/
	public DMLOperationResult_DTO doUpsert(SObject item, Boolean withoutSharing, Boolean retryAttempt) {
		return doUpsert(new List<SObject>{item}, false, withoutSharing, retryAttempt).get(0);
	}

	/**
	 * @description : Method upsert passed collection of sobjects.
	 * @param	 : items Collection of objects, which have to be upserted.
	 * @return	 : List<Id> Collection of upserted object's ids.
	**/
	public List<DMLOperationResult_DTO> doUpsert(List<SObject> items) {
		if(OBJECT_TYPE != null) { items = helper.castSObject(items, OBJECT_TYPE); }
		return doOperation(items, DML_SObject_Helper.DatabaseOperation.DBO_UPSERT, true, false, false);
	}

	/**
	 * @description : Method upsert passed collection of sobjects.
	 * @param	 : items Collection of objects, which have to be upserted.
	 * @param	 : allMustSucceed Flag, which means that all or none records must be upserted.
	 * @return	 : List<Id> Collection of upserted object's ids.
	**/
	public List<DMLOperationResult_DTO> doUpsert(List<SObject> items, Boolean allMustSucceed) {
		if(OBJECT_TYPE != null) { items = helper.castSObject(items, OBJECT_TYPE); }
		return doOperation(items, DML_SObject_Helper.DatabaseOperation.DBO_UPSERT, allMustSucceed, false, false);
	}

	/**
	 * @description : Method upsert passed collection of sobjects.
	 * @param	 : items Collection of objects, which have to be upserted.
	 * @param	 : allMustSucceed Flag, which means that all or none records must be upserted.
	 * @param		: withoutSharing Flag, which means that the upsert follows or not the sharing rules conditions.
	 * @return	 : List<Id> Collection of upserted object's ids.
	**/
	public List<DMLOperationResult_DTO> doUpsert(List<SObject> items, Boolean allMustSucceed, Boolean withoutSharing) {
		if(OBJECT_TYPE != null) { items = helper.castSObject(items, OBJECT_TYPE); }
		return doOperation(items, DML_SObject_Helper.DatabaseOperation.DBO_UPSERT, allMustSucceed, withoutSharing, false);
	}

	/**
	 * @description : Method upsert passed collection of sobjects.
	 * @param	 : items Collection of objects, which have to be upserted.
	 * @param	 : allMustSucceed Flag, which means that all or none records must be upserted.
	 * @param	 : withoutSharing Flag, which means that the upsert follows or not the sharing rules conditions.
	 * @param	 : retryAttempt Flag, which means if the operation fails, a retry attempt will be made.
	 * @return	 : List<Id> Collection of upserted object's ids.
	**/
	public List<DMLOperationResult_DTO> doUpsert(List<SObject> items, Boolean allMustSucceed, Boolean withoutSharing, Boolean retryAttempt) {
		if(OBJECT_TYPE != null) { items = helper.castSObject(items, OBJECT_TYPE); }
		return doOperation(items, DML_SObject_Helper.DatabaseOperation.DBO_UPSERT, allMustSucceed, withoutSharing, retryAttempt);
	}

	/**
	 * @description : Method updates passed collection of sobjects.
	 * @param		: item, which have to be updated.
	 * @return  	: Id of updated object's ids.
	**/
	public static DMLOperationResult_DTO doUpdate(SObject item) {
		return doOperation(new List<SObject>{item}, DML_SObject_Helper.DatabaseOperation.DBO_UPDATE, false, false, false).get(0);
	}

	/**
	 * @description : Method updates passed collection of sobjects.
	 * @param		: item, which have to be updated.
	 * @param		: withoutSharing Flag, which means that the update follows or not the sharing rules conditions.
	 * @return  	: Id of updated object's ids.
	**/
	public static DMLOperationResult_DTO doUpdate(SObject item, Boolean withoutSharing) {
		return doOperation(new List<SObject>{item}, DML_SObject_Helper.DatabaseOperation.DBO_UPDATE, false, withoutSharing, false).get(0);
	}

	/**
	 * @description : Method updates passed collection of sobjects.
	 * @param		: item, which have to be updated.
	 * @param		: withoutSharing Flag, which means that the update follows or not the sharing rules conditions.
	 * @param	 : retryAttempt Flag, which means if the operation fails, a retry attempt will be made.
	 * @return  	: Id of updated object's ids.
	**/
	public static DMLOperationResult_DTO doUpdate(SObject item, Boolean withoutSharing, Boolean retryAttempt) {
		return doOperation(new List<SObject>{item}, DML_SObject_Helper.DatabaseOperation.DBO_UPDATE, false, withoutSharing, retryAttempt).get(0);
	}

	/**
	 * @description : Method updates passed collection of sobjects.
	 * @param		: items Collection of objects, which have to be updated.
	 * @return  	: List<Id> Collection of updated object's ids.
	**/
	public static List<DMLOperationResult_DTO> doUpdate(List<SObject> items) {
		return doOperation(items, DML_SObject_Helper.DatabaseOperation.DBO_UPDATE, true, false, false);
	}

	/**
	 * @description : Method updates passed collection of sobjects.
	 * @param		: items Collection of objects, which have to be updated.
	 * @param		: allMustSucceed Flag, which means that all or none records must be updated.
	 * @return  	: List<Id> Collection of updated object's ids.
	**/
	public static List<DMLOperationResult_DTO> doUpdate(List<SObject> items, Boolean allMustSucceed) {
		return doOperation(items, DML_SObject_Helper.DatabaseOperation.DBO_UPDATE, allMustSucceed, false, false);
	}

	/**
	 * @description : Method updates passed collection of sobjects.
	 * @param		: items Collection of objects, which have to be updated.
	 * @param		: allMustSucceed Flag, which means that all or none records must be updated.
	 * @param		: withoutSharing Flag, which means that the update follows or not the sharing rules conditions.
	 * @return  	: List<Id> Collection of updated object's ids.
	**/
	public static List<DMLOperationResult_DTO> doUpdate(List<SObject> items, Boolean allMustSucceed, Boolean withoutSharing) {
		return doOperation(items, DML_SObject_Helper.DatabaseOperation.DBO_UPDATE, allMustSucceed, withoutSharing, false);
	}

	/**
	 * @description : Method updates passed collection of sobjects.
	 * @param		: items Collection of objects, which have to be updated.
	 * @param		: allMustSucceed Flag, which means that all or none records must be updated.
	 * @param		: withoutSharing Flag, which means that the update follows or not the sharing rules conditions.
	 * @param	 : retryAttempt Flag, which means if the operation fails, a retry attempt will be made.
	 * @return  	: List<Id> Collection of updated object's ids.
	**/
	public static List<DMLOperationResult_DTO> doUpdate(List<SObject> items, Boolean allMustSucceed, Boolean withoutSharing, Boolean retryAttempt) {
		return doOperation(items, DML_SObject_Helper.DatabaseOperation.DBO_UPDATE, allMustSucceed, false, retryAttempt);
	}
	
	/**
	 * @description : Method operates on passed collection of sobjects.
	 * @param		: items Collection of objects, which have to be inserted.
	 * @param		: operationType Selected DML operation.
	 * @param		: allMustSucceed Flag, which means that all or none records must be inserted.
	 * @param		: withoutSharing Flag, which means that the operation follows or not the sharing rules conditions.
	 * @param	 : retryAttempt Flag, which means if the operation fails, a retry attempt will be made.
	 * @return  	: List<Id> Collection of inserted object's ids.
	**/
	public static List<DMLOperationResult_DTO> doOperation(List<SObject> items, DML_SObject_Helper.DatabaseOperation operationType, Boolean allMustSucceed, Boolean withoutSharing, Boolean retryAttempt) {
		List<DMLOperationResult_DTO> operationResults = null;
		if(items != null || items.size() > 0) {
			items = helper.removeDuplicates(items);
			items.sort();
			if(!withoutSharing) {
				Savepoint sp = null;
				if (allMustSucceed) {
					sp = Database.setSavepoint();
				}
				try {
					if(Limits.getDmlRows() + items.size() >= Limits.getLimitDmlRows()) {
						throw new DmlException('LimitException: Too many DML rows: 10001');
					}
					if (operationType == DML_SObject_Helper.DatabaseOperation.DBO_INSERT) {
						operationResults = helper.adaptOperationResults(Database.insert(items, allMustSucceed));
					}
					else if (operationType == DML_SObject_Helper.DatabaseOperation.DBO_UPDATE) {
						operationResults = helper.adaptOperationResults(Database.update(items, allMustSucceed));
					}
					else if (operationType == DML_SObject_Helper.DatabaseOperation.DBO_DELETE) {
						operationResults = helper.adaptOperationResults(Database.delete(items, allMustSucceed));
					}
					else if (operationType == DML_SObject_Helper.DatabaseOperation.DBO_UPSERT) {
						operationResults = helper.adaptOperationResults(Database.upsert(items, allMustSucceed));
					}
					for(DMLOperationResult_DTO oOperationResult : operationResults) {
						if(!oOperationResult.isSuccess()) {
							throw new DmlException( oOperationResult.getErrors().get(0).getMessage());
						}
					}
				}
				catch (Exception e) {
					if (sp != null) Database.rollback(sp);
					if(retryAttempt && helper.checkIfCritical(e)) {
						System.debug('###Exception submited for retry from DML_SObject : '+e.getMessage() + 'Stack Trace : '+e.getStackTraceString());
						Database.executeBatch(new DML_SObject_Batch(helper.getFailedItems(operationResults, items), operationType, false));
					}
					else new DML_CriticalErrorHandler(e, DML_SObject_Helper.operationName(operationType), items);
				}
			}
			else operationResults = helper.doOperation(items, operationType, allMustSucceed, retryAttempt);
		}
		return operationResults;
	}
	
	public static SOQuery get(String sObjectType, String fields) {
		return new SOQuery(sObjectType, fields);
	}
	
	public static SOQuery getCount(String sObjectType) {
		return new SOQuery(sObjectType);
	}
	
	public SOQuery get(String fields) {
		return new SOQuery(OBJECT_TYPE, fields);
	}
	
	public SOQuery getCount() {
		return new SOQuery(OBJECT_TYPE);
	}

	public class SOQuery {
		private String objectType;
		private Schema.SObjectType sObjectType;
		private String fields;
		private String whereClause;
		private String options;
		
		public SOQuery(Schema.SObjectType sObjectType, String fields) {
			this(String.valueOf(sObjectType), fields);
			this.sObjectType = sObjectType;
		}
		
		public SOQuery(String sObjectType, String fields) {
			this(sObjectType);
			if(String.isBlank(fields)) { throw new CustomException('Invalid Second Parameter: Object Fields.'); }
			if(fields.equals('*')) { fields = fields.replaceAll('\\*',getAllCreatableFields()); }
			this.fields = fields;
		}
		
		public SOQuery(Schema.SObjectType sObjectType) {
			this(String.valueOf(sObjectType));
			this.sObjectType = sObjectType;
		}
		
		public SOQuery(String sObjectType) {
			if(sObjectType == null) { throw new CustomException('Invalid First Parameter: Salesforce Object Type.'); }
			this.objectType = sObjectType;
		}
		
		public SOQuery filteredBy(String whereClause){
			if(String.isBlank(whereClause)) { throw new CustomException('Empty values are not allowed.'); }
			this.whereClause = whereClause.replaceAll('"', '\'');
			return this;
		}
		
		public SOQuery filteredBy(String whereClause, List<Object> parameters) { return filteredBy(String.format(whereClause, parameters)); }
		public SOQuery filteredBy(String whereClause, Object param1) { return filteredBy(String.format(whereClause, new List<Object> { param1 })); }
		public SOQuery filteredBy(String whereClause, Object param1, Object param2) { return filteredBy(String.format(whereClause, new List<Object> { param1, param2 })); }
		public SOQuery filteredBy(String whereClause, Object param1, Object param2, Object param3) { return filteredBy(String.format(whereClause, new List<Object> { param1, param2, param3 })); }
		
		public SOQuery setOptions(String options){
			if(String.isBlank(options)) { throw new CustomException('Empty values are not allowed.'); }
			this.options = options;
			return this;
		}
		
		public List<SObject> run() { return run(false); }
		public List<SObject> run(Boolean withoutSharing) {
			if(String.isBlank(fields)) { throw new CustomException('Invalid method for count query.'); }
			String sQuery = 'SELECT ' + fields  + ' FROM ' + objectType;
			if(String.isNotBlank(whereClause)) { sQuery += ' WHERE ' + whereClause; }
			if(String.isNotBlank(options)) { sQuery += ' ' + options; }
			return withoutSharing ? helper.query(sQuery) : Database.query(sQuery);
		}
		
		public SObject run(Integer index) { return run(false, index); }
		public SObject run(Boolean withoutSharing, Integer index) {
			List<SObject> result = run(withoutSharing);
			return result.size() > index ? result.get(index) : null;
		}
		
		public Object run(String field) { return run(false, field); }
		public Object run(Boolean withoutSharing, String field) {
			SObject result = run(withoutSharing, 0);
			return result != null ? result.get(field) : null;
		}
		
		public Integer count() { return count(false); }
		public Integer count(Boolean withoutSharing) {
			String sQuery = 'SELECT count() FROM ' + objectType;
			if(String.isNotBlank(whereClause)) { sQuery += ' WHERE ' + whereClause; }
			if(String.isNotBlank(options)) { sQuery += ' ' + options; }
			return withoutSharing ? helper.countQuery(sQuery) : Database.countQuery(sQuery);
		}
		
		private String getAllCreatableFields() {
			if(this.sObjectType == null) { this.sObjectType = ((SObject) Type.forName(this.objectType).newInstance()).getSObjectType(); }
			List<Schema.SObjectField> fields = this.sObjectType.getDescribe().fields.getMap().values();
			Integer length = fields.size();
			String result = '';
			for(Integer index = 0; index < length; index++) {
	result += FIELDS.get(index) + (index == (length - 1) ? '' : ', ');
			}
			return result;
		}
	}
	
	/**
	 * @description : Method used to convert List to String
	 * @param 		: List<String> objectList
	 * @return	  : String
	**/
	public static String toString(List<String> objectList) {
		Integer size = objectList.size();
		if(size == 0) { return 'null'; }
		String result = '';
		for(Integer i = 0; i < size; i++) { result += '"' + objectList.get(i) + '",'; }
		return '('+result.removeEnd(',')+')';
	}
	
	/**
	 * @description : Method used to convert Set to String
	 * @param 		: Set<String> objectSet
	 * @return	  : String
	**/
	public static String toString(Set<String> objectSet) {
		return toString(new List<String>(objectSet));
	}
	
	/**
	 * @description : Method used to convert a SObject List to Set of a given field
	 * @param 		: List<SObject> sObjectList
	 * @param 		: String fieldName
	 * @return	  : Set<Object>
	**/
	public static Set<String> toSet(List<SObject> sObjectList, String fieldName) {
		return toSet(sObjectList, fieldName, true);
	}
	
	/**
	 * @description : Method used to convert a SObject List to Set of a given field
	 * @param 		: List<SObject> sObjectList
	 * @param 		: String fieldName
	 * @param 		: Boolean ingoreNull
	 * @return	  : Set<Object>
	**/
	public static Set<String> toSet(List<SObject> sObjectList, String fieldName, Boolean ingoreNull) {
		Set<String> result = new Set<String>();
		Integer size = sObjectList.size();
		for(Integer i = 0; i < size; i++) {
			Object field = sObjectList.get(i).get(fieldName);
			if(field != null || ingoreNull == false) { result.add('' + field); }
		}
		return result;
	}
	
	/**
	 * @description : Method used to convert a SObject List to Map of a given unique field
	 * @param 		: List<SObject> sObjectList
	 * @param 		: String fieldName
	 * @return	 : Map<String, SObject>
	**/
	public static Map<String, SObject> toMap(List<SObject> sObjectList, String fieldName) {
		Map<String, SObject> result = new Map<String, SObject>();
		Integer size = sObjectList.size();
		for(Integer i = 0; i < size; i++) {
			SObject record = sObjectList.get(i);
			Object field = record.get(fieldName);
			if(field != null) { result.put('' + field, record); }
		}
		return result;
	}
	
	/**
	 * @description : Method used to convert a SObject List to Map of Lists f a given unique field
	 * @param 		: List<SObject> sObjectList
	 * @param 		: String fieldName
	 * @return	 : Map<String, List<SObject>>
	**/
	public static Map<String, List<SObject>> groupBy(List<SObject> sObjectList, String fieldName) {
		Map<String, List<SObject>> result = new Map<String, List<SObject>>();
		Integer size = sObjectList.size();
		for(Integer i = 0; i < size; i++) {
			SObject record = sObjectList.get(i);
			Object field = record.get(fieldName);
			if(field != null) {
				List<SObject> cur = result.containsKey(''+field) ? result.get(''+field) : new List<SObject>();
				cur.add(record);
				result.put(''+field, cur);
			}
		}
		return result;
	}
	
	/** Old Version / Deprecated **/
		
	/**
	 * @description : Method used to set the select of a query
	 * @param 		: String Query Select Value
	**/
	public SO_Query doSelect(String querySelect) {
		return new SO_Query(querySelect, OBJECT_TYPE);
	}
	
	public class SO_Query {
		private string sQuerySelect = '';
		private string sQueryWhere = '';
		private string sQueryOptions = '';
		private Schema.SObjectType OBJECT_TYPE = null;
		private List<Schema.SObjectField> FIELDS = null;
		
		public SO_Query(String querySelect, Schema.SObjectType objectType) {
			OBJECT_TYPE = objectType;
			FIELDS = OBJECT_TYPE.getDescribe().fields.getMap().values();
			if(querySelect.length() > 0) {
	sQuerySelect = 'SELECT '+processQuery(querySelect);
			}			
			else throw new CustomException('Empty values are not allowed.');
		}
		
		/**
		 * @description : Method used to set the where of a query
		 * @param 		: String Query Where Value
		**/
		public SO_Query doWhere(String queryWhere){
			if(queryWhere.length() > 0) {
	queryWhere = queryWhere.replaceAll('"', '\'');
	sQueryWhere = ' WHERE '+queryWhere;
	return this;
			}			
			else throw new CustomException('Empty values are not allowed.');
		}
		
		/**
		 * @description : Method used to set the further options to the query 
		 * @param 		: String Query Where Value
		**/
		public SO_Query setOptions(String queryOptions){
			if(queryOptions.length() > 0) {
	sQueryOptions = ' '+queryOptions;
	return this;
			}			
			else throw new CustomException('Empty values are not allowed.');
		}
		
		/**
		 * @description : Method used to query
		 * @return 		: Resulting List of the Query
		**/
		public List<SObject> doQuery() {
			return doQuery(false);
		}
		
		/**
		 * @description : Method used to query
		 * @param 		: Boolean Without Sharing option
		 * @return 		: Resulting List of the Query
		**/
		public List<SObject> doQuery(Boolean withoutSharing) {
			if(sQuerySelect.length() > 0) {
	String sQuery = sQuerySelect+' FROM '+this.OBJECT_TYPE+sQueryWhere+sQueryOptions;
	sQuerySelect = '';
	sQueryWhere = '';
	sQueryOptions = '';
	return withoutSharing ? helper.query(sQuery) : Database.query(sQuery);
			}			
			else throw new CustomException('Query has to be initialized by doSelect.');
		}
		
		/**
		 * @description : Method used to get all the creatable fields for a particular sObject type
		 * @return	  : String query
		**/
		private String getAllCreatableFields() {
			String result = '';
			for(Integer index = 0; index < FIELDS.size(); index++) {
	result += FIELDS.get(index)+(index==(FIELDS.size()-1)?'':', ');
			}
			return result;
		}
		
		/**
		 * @description : Method used to set all the creatable fields in a query that contains the selector '*'
		 * @param	: String query
		 * @return	  : String query
		**/
		private String processQuery(String query) {
			if(query.contains('*')) {
	query = query.replaceAll('\\*',getAllCreatableFields());
			}
			return query;
		}
	}
	
	/**
	 * @description : Method used to convert List to String
	 * @param 		: List<String> objectList
	 * @return	  : String
	**/
	public static String listToString(List<String> objectList) {
		String result = 'null';
		if(!objectList.isEmpty()) {
			result = '';
			for(Integer i = 0; i < objectList.size(); i++) {
	result += '"'+objectList.get(i)+'",'; 
			}
		}
		return '('+result.removeEnd(',')+')';
	}
	
	/**
	 * @description : Method used to convert Set to String
	 * @param 		: Set<String> objectSet
	 * @return	  : String
	**/
	public static String setToString(Set<String> objectSet) {
		return listToString(new List<String>(objectSet));
	}
}