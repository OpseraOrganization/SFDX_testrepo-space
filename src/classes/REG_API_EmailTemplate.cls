/** * File Name: REG_API_EmailTemplate 

* Description  Rest Webservice class to get the status of tools for particular contact

* * @author : TCS 

Date 06/27/2019 

* */ 
@RestResource(urlMapping='/EmailTemplate/*')
global with sharing class REG_API_EmailTemplate {  
    
    @httpGet
    global static void doGet(){
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        response.addHeader('Content-Type' , 'application/json');
        REG_Result result=new REG_Result();
        REG_Result.requestURI=request.requestURI;
        REG_Result.requestInputs=JSON.serialize(request.params);
        REG_Result.headers=JSON.serialize(request.headers);
        REG_Result.requestMethod='GET';
        response.statusCode = result.statusCode;
        String templateName= '';
        
        try{
            REG_Result.api='Get EmailTemplate Details';
            String strURI=request.requestURI;
            List<String> uriParts = strURI.split('/');
            Integer arrCount = uriParts.size();
            
            if(arrCount == 3) {
                templateName= uriParts[2];
                if(!string.isBlank(templateName)){    
                    result = REG_RegistrationUtility.getEmailTemplate(templateName);
                }
            }else{
                result.handleError(400, 'Please provide valid URI', 'URI should be /EmailTemplate/{templateName}');
            }
        }
        catch(exception e){
            result.handleException(500, e.getMessage(), e);    
        }  
        
        
        if(result.statusCode == 200){
            result.statusCode = null;
            result.statusMessage = null;           
            response.responseBody = Blob.valueOf(JSON.serialize( result.Data,True));
            
        }
        else{
            response.statusCode = result.StatusCode;
            response.responseBody = Blob.valueOf(JSON.serialize(result.error));
            
        }  
    }//end of get
    
    
    //Wrapper
    public REG_API_EmailTemplate(List<EmailTemplate> template){
        
        this.id = template[0].Id;
        this.templateName = template[0].DeveloperName;
        this.Subject = template[0].Subject;
        this.Body = template[0].Body;         
        
        template[0].HtmlValue = template[0].HtmlValue.replace('\t', '');
        template[0].HtmlValue = template[0].HtmlValue.replace('\r\n', '');
        this.HtmlValue = template[0].HtmlValue;
        
    }
    String id = '';
    String templateName = '';
    String Subject = '';
    String HtmlValue = '';
    String Body = '';
    
}