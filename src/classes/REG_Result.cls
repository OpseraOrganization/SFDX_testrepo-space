/*
    @author : TCS
    File Name: JAERO_Result 
    Description  Result wrapper class to hold result of API.
    Date 01/16/2019 
*/ 
public class REG_Result {

    public boolean isInternal;
	public String honId;
	public String contactId;
   
    public integer StatusCode{get;set;}
    public string StatusMessage{get;set;}
    public string resourceId{get;set;}
    public String status{get;set;}
    public object Data{get;set;}
    public object error{get;set;}
    public object resource{get;set;}
    public static string requestURI{get;set;}
    public static string requestInputs{get;set;}
    public static string api{get;set;}
    public static string requestMethod{get;set;}
    public static string transactionId{get;set;}
    public static string headers{get;set;}    
    /** Default Constructor to hold the result**/ 
    public REG_Result(){
        StatusCode=200;
        StatusMessage='OK';
        Data=null;
        error=null;
    }
    
    /**
     * Handle Exception method is used to handle SFDC Exception thrown
    **/
    public void handleException(Integer statusCode , String statusMessage, Exception e){
        this.handleError(statusCode,statusMessage,e.getStackTraceString());
     /* this.StatusCode = statusCode ;            
            this.StatusMessage = statusMessage;
            this.error=new Map<String,Object>{'error'=>new REG_Error( this.StatusCode,System.now(),e.getStackTraceString(),this.StatusMessage)}; */
         
          }
          
    /**
     * Handle Error method is used to handle custom Messages which are needed to be sent to client
    **/          
    public void handleError(Integer statusCode , String statusMessage, String Description){
        this.StatusCode = statusCode;
        this.StatusMessage = statusMessage;
        this.error=new Map<String,Object>{'error'=>new REG_Error( statusCode,System.now(),Description,statusMessage)};    
        REG_ErrorLogging.logError(api,requestURI, requestMethod,UserInfo.getUserId(), this.statusCode, (String.isBlank(statusMessage)?' ':statusMessage)+' '+(String.isBlank(Description)?' ':Description),requestInputs,transactionId,headers);
       
    }
    
    public static void  logTransaction(){         
          REG_ErrorLogging.logTransaction(api,requestURI, requestMethod,UserInfo.getUserId(),requestInputs,transactionId,headers);
        
    }

 
}