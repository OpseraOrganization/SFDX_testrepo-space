/** * File Name: REG_ErrorLogging 

* Description  Error Logging Utility Class

* * @author : TCS 

Date 01/16/2019 

* */
public class REG_ErrorLogging {
    
    
    /**
    *Future Method used to log errors captured in catch block
    **/
    @future
    public static void logError(String API,String URI,String Method,Id userID,Integer errorCode,String errorMessage,String inputs,String transactionId,String headers){
        REG_API_Trace_Detail__c errorRecord=new REG_API_Trace_Detail__c();
        errorRecord.API_Name__c=API;
        errorRecord.user__c=userID;
        errorRecord.error_Code__c=errorCode;
         errorRecord.error_Message__c=errorMessage;
        errorRecord.inputs__c=inputs;
        errorRecord.Type__c='Error';
        errorRecord.Request_Headers__c=headers;
        errorRecord.Request_Method__c=method;
        errorRecord.Request_URI__c=URI;
        errorRecord.transaction_Id__c=transactionId;
        Database.DMLOptions dmlOptions = new  Database.DMLOptions();
        dmlOptions.allowFieldTruncation  = true;
          system.debug('errorRecord' +errorRecord);
          Database.insert(errorRecord, dmlOptions );
    }
    
    
    /**
    *Future Method used to log logTransaction before processing of request   
    **/
    @future
    public static void logTransaction(String API,String URI,String Method,Id userID,String inputs,String transactionId,String headers){
        REG_API_Trace_Detail__c debugRecord=new REG_API_Trace_Detail__c();
         debugRecord.API_Name__c=API;
        debugRecord.user__c=userID;
       // debugRecord.error_Code__c=200;
        // debugRecord.error_Message__c='N/A';
        debugRecord.inputs__c=inputs;
         debugRecord.Request_Headers__c=headers;
        debugRecord.Request_Method__c=method;
        debugRecord.Request_URI__c=URI;
        debugRecord.transaction_Id__c=transactionId;
         debugRecord.Type__c='Transaction';
         Database.DMLOptions dmlOptions = new  Database.DMLOptions();
            dmlOptions.allowFieldTruncation  = true;
          Database.insert(debugRecord, dmlOptions );
    }
    
    /**
    *Method to fecth the error details from SFDC called via API
get method is comment so service is also comment
    **/   
   /* public static REG_Result  getErrorDetails(String api){
        REG_Result result=new REG_Result();
        try{
            if(String.isNotBlank(api) && api.containsIgnoreCase('%20')) api=api.replace('%20',' ');
            List<REG_API_Trace_Detail__c> apiErrors=[SELECT Id,Name,API_Name__c,user__r.Name,error_Code__c,error_Message__c,inputs__c,createddate FROM REG_API_Trace_Detail__c where API_Name__c = :api ORDER BY Createddate desc Limit 50000];
            result.data=apiErrors; 
            
        }catch(Exception e){
            result.handleException( 500, e.getMessage(), e);
        }
        
        return result;        
    }*/
    
  
}