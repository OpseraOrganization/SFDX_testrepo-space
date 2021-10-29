/*
    @author : TCS
    File Name: REG_Error 
    Description  Error wrapper class to hold result of Error Details.
    Date 01/16/2019 
*/ 
public class REG_Error {
    
    public Integer errorCode;    
    public DateTime errorDateTime;
    public String errorMessage;
    public String errorDescription;
    
    /** Default Constructor to hold the Error**/     
    public REG_Error(Integer errorCode,DateTime errorDateTime,String errorDescription,String errorMessage){
        this.errorCode=errorCode;
        this.errorDateTime=errorDateTime;
        this.errorMessage=errorMessage;
        this.errorDescription=errorDescription;
    }
    
    
    
}