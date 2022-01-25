/***********************************
Class Name:ExceptionHandler 
Author: Accenture
Reason: This is created to log all the exceptions generated into exception object.
Created Date:02/Dec/2016 
******************************************/
public class ExceptionHandler {
   
   /***********************
  * Method Name: logException
  * Description: To create Exception logs when an exception is catched
  * Parameters: Exception Object Record 
  ************************/	
  public static Exception__c logException(Exception__c ex) {
	try {
		Integer getQueriesAvailable = Limits.getLimitQueryRows() - Limits.getQueryRows();
		database.insert(ex);
		if(!test.isrunningtest())
		ex = [select id, Name, Message__c from Exception__c where id =: ex.id LIMIT: getQueriesAvailable];
	} catch(Exception e) {
	  String exc = e.getMessage();
	  System.debug(GlobalConstants.ERROR+ exc);
	  System.debug('Exception occured while inserting record into Exception__c');
	}
	return ex;  
  }
  
  /**
  * Method Name: logExceptions
  * Description: This method has been created to address bulk exception creation. 
  * Parameters: List of Exception Object records.
  */
  public static void logExceptions(List<Exception__c> ex){
	try {
		System.debug('Exception list -> ' + ex);
		database.insert(ex);
	} catch(Exception e) {
	  String exc = e.getMessage();
	  System.debug(GlobalConstants.ERROR+ exc);
	  System.debug('Exception occured while inserting record into Exception__c');
	}  
  }
  
  /**
  * Method Name: addException
  * Description: This method has been created to catch the exception and display the error message  
  * Parameters: Exception, Method Name, class name.
  */
  public static void addException(Exception ex, String className, String methodName){
	Exception__c excLog = new Exception__c(
	  Class__c = className,
	  Message__c = ex.getMessage(),
	  Method__c = methodName
	  );
	  try{
		if(ex.getMessage().contains(GlobalConstants.VALIDATION)){
	//catching error in error field due to Validation
	excLog.Error__c = ex.getMessage().Split(GlobalConstants.VALIDATION_EXCEPTION)[1];
		}
		if(ex.getMessage().contains(GlobalConstants.MIXED_DML)){
	//catching error in error field due to Mixed DML Exception
	excLog.Error__c = ex.getMessage().Split(GlobalConstants.MIXED_DML + GlobalConstants.COMMA)[1];
		}
		if(ex.getMessage().contains(GlobalConstants.DMLEXCEPTION)){
	//catching error in error field due to DML Exception
	excLog.Error__c = ex.getMessage().Split(GlobalConstants.SYSTEM_DML)[1];
		}
		if(ex.getMessage().contains(GlobalConstants.REQUIRED_FILED_MISSING)){
	//catching error in error field due to Required  Exception
	excLog.Error__c = ex.getMessage().Split(GlobalConstants.REQUIRED_FILED_MISSING + GlobalConstants.COMMA)[1];
		}
	  }catch(Exception e) {
	  String exc = e.getMessage();
	  System.debug(GlobalConstants.ERROR+ exc);
	}   
	  

	System.debug('MyController() stackTrace: ' + ex.getStackTraceString());
	  logException(excLog);
  }
  
  public static void addExceptionForOIFBtach(List<SObject> objs, List<Database.SaveResult> srs){
	List<Exception__c> excList = new List<Exception__c>();
	for(Integer i = 0; i < srs.size(); i++) {
		Database.SaveResult sr = srs[i];
		if (sr.isSuccess()){
	continue;
		} 
		Exception__c ec = new Exception__c();
		SObject obj = objs[i];
		Schema.sObjectType objType = obj.getSObjectType();		 
		ec.Class__c = GlobalConstants.BATCH_OIF_CURRENCY_UPDATE;
		for(Database.Error err : sr.getErrors()){ 
	ec.Message__c = obj.Id + ',' + err.getFields() + ',' + err.getStatusCode()+ ',' + err.getMessage();
		}
	if(ec != NULL){
			excList.add(ec);
	}
	  }
	logExceptions(excList);
  }
  
  public static void addExceptionForPSROBatch(List<SObject> objs, List<Database.SaveResult> srs){
		List<Exception__c> excList = new List<Exception__c>();
		for(Integer i = 0; i < srs.size(); i++) {
	Database.SaveResult sr = srs[i];
	if (sr.isSuccess()){
		continue;
	} 
	Exception__c ec = new Exception__c();
	SObject obj = objs[i];
	Schema.sObjectType objType = obj.getSObjectType();	  
	ec.Class__c = GlobalConstants.BATCH_PSRO_CURRENCY_UPDATE;
	for(Database.Error err : sr.getErrors()){ 
		ec.Message__c = obj.Id + ',' + err.getFields() + ',' + err.getStatusCode()+ ',' + err.getMessage();
	}
		if(ec != NULL){
			excList.add(ec);
		}
			}
		logExceptions(excList);
	}
	public static void addExceptionForPSROEURBatch(List<SObject> objs, List<Database.SaveResult> srs){
		List<Exception__c> excList = new List<Exception__c>();
		for(Integer i = 0; i < srs.size(); i++) {
	Database.SaveResult sr = srs[i];
	if (sr.isSuccess()){
		continue;
	} 
	Exception__c ec = new Exception__c();
	SObject obj = objs[i];
	Schema.sObjectType objType = obj.getSObjectType();	  
	ec.Class__c = GlobalConstants.BATCH_PSRO_EUR_CURRENCY_UPDATE;
	for(Database.Error err : sr.getErrors()){ 
		ec.Message__c = obj.Id + ',' + err.getFields() + ',' + err.getStatusCode()+ ',' + err.getMessage();
	}
		if(ec != NULL){
			excList.add(ec);
		}
			}
		logExceptions(excList);
	}
  
  public static void generateExceptionRecordFromSaveResult(List<Database.SaveResult> dmlOutputResultList, String methodName, String className){
	List<Exception__c> excLogList = new List<Exception__c>();
	for(Integer i = 0; i < dmlOutputResultList.size(); i++) 
	{
	  If(!dmlOutputResultList[i].isSuccess()){
		for(Database.Error err : dmlOutputResultList[i].getErrors()) 
		{
	System.debug('Error occured : '+err.getStatusCode() + ' : ' + err.getMessage());
	System.debug('CollaborationGroupMember fields that affected this error : ' + err.getFields());
	Exception__c excLog = new Exception__c(); 
	excLog.Class__c = className;
	excLog.Message__c = 'Error occured : ' + err.getStatusCode()+' ; Error::: '+ err.getMessage() +' ; field(s) that affected this error : ' +err.getFields();
	excLog.Method__c = methodName;
	excLog.Error__c = err.getMessage();
	excLogList.add(excLog);
		}
	  }
	}
	logExceptions(excLogList);
  }

}