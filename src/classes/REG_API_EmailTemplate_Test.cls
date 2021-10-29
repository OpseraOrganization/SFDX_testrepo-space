@IsTest

private class REG_API_EmailTemplate_Test{
    
    
    //code for valid developer_name
    static testMethod void testgettemplatedetails(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/EmailTemplate/CompanyValidation';  //Request URL
        request.httpMethod = 'GET';
        List<EmailTemplate> templatedetails  =[select id,DeveloperName,Subject,HtmlValue,body FROM EmailTemplate where DeveloperName='CompanyValidation'];
        system.assert(templatedetails[0] != null);
        test.startTest();
        REG_API_EmailTemplate.doGet();
        test.stopTest();
        String result = response.responseBody.toString();
        List<REG_API_EmailTemplate> tempList = (List<REG_API_EmailTemplate>)JSON.deserialize('['+result+']', List<REG_API_EmailTemplate>.class);
        System.assert(!tempList.isEmpty());
    }
    
    //code for invalid developer_name
    static testMethod void testgettemplatedetails1(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/EmailTemplate/CompanyValidation111';  //Request URL
        request.httpMethod = 'GET';
        test.startTest();
        REG_API_EmailTemplate.doGet();
        test.stopTest();
        String result = response.responseBody.toString();
        //System.assert(result!=Null);
        System.assert(result.contains('404'));

    }
    
    //code for without developer_name
    static testMethod void testgettemplatedetails2(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/EmailTemplate/';  //Request URL
        request.httpMethod = 'GET';
        test.startTest();
        REG_API_EmailTemplate.doGet();
        test.stopTest();
        String result = response.responseBody.toString();
        //System.assert(result!=Null);
        System.assert(result.contains('400'));
 
    }
}