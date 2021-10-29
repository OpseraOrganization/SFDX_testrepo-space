public class APIGEE_Result { 
    public integer StatusCode{get;set;}
    public string StatusMessage{get;set;}
    public string resourceId{get;set;}
    public String status{get;set;}
    public object Data{get;set;}
    public object error{get;set;}
    public object resource{get;set;}

    public APIGEE_Result(){
        StatusCode=200;
        status = 'SUCCESS';
    }
}