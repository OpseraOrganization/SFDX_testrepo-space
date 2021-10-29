public class AERO_Result {
    public integer StatusCode;
    public string StatusMessage;
    public String status;
    public object Data;
    public string resourceId;
    public string Description;
    
    public AERO_Result(){
        StatusCode=200;
        Data=null;
    }
    
    public void handleError(Integer statusCode , String statusMessage, String Description){
        this.StatusCode = statusCode;
        this.StatusMessage = statusMessage;
        this.Description = Description;
    }
}