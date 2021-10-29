public class APIGEE_Error { 
    public Integer errorCode;    
    public DateTime errorDateTime;
    public String errorMessage;
    public String errorDescription;
    
    /** Default Constructor to hold the Error**/     
    public APIGEE_Error(Integer errorCode,DateTime errorDateTime,String errorDescription,String errorMessage){
        this.errorCode=errorCode;
        this.errorDateTime=errorDateTime;
        this.errorMessage=errorMessage;
        this.errorDescription=errorDescription;
    }
}