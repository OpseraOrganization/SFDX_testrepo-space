@isTest
global with sharing class LeapContractCreationServiceMockCallout implements HttpCalloutMock  {
    Boolean accessToken =true;
    Boolean createSuccess = false;
    Boolean searchSuccess = false;
    Boolean searchSuccess2 = false;
    public LeapContractCreationServiceMockCallout( Boolean accessToken, Boolean createSuccess, Boolean searchSuccess, Boolean searchSuccess2){
        this.accessToken = accessToken;
        this.createSuccess = createSuccess;
        this.searchSuccess = searchSuccess;
        this.searchSuccess2 = searchSuccess2;
    }
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        Map<String,String> JsonMap = new Map<String,String>();
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        String endPoint = request.getEndpoint();
        response.setStatusCode(200);
        if(endPoint.contains('auth/accesstoken?grant_type=client_credentials') && accessToken){
            response.setBody('{"refresh_token_expires_in":"0","api_product_list":"[AGILOFT-LEAP-PRODUCT]","api_product_list_json":["AGILOFT-LEAP-PRODUCT"],"organization_name":"honeywell-qa","developer.email":"admin@honeywell.com","token_type":"BearerToken","issued_at":"1585911648568","client_id":"2ifSjk6Aw5mbRO6LUgdZVn5KYN1cPJ93","access_token":"0xSfeFx68y8A5agkS8oqJbvVXS1S","application_name":"e88027ca-8a03-4b07-866f-493a1ffe0d46","scope":"","expires_in":"3599","refresh_count":"0","status":"approved"}');
        }
        else if(endPoint.contains('auth/accesstoken?grant_type=client_credentials') && !accessToken){
            response.setBody('Error Sir!!');
            response.setStatusCode(401);
        }
        else if(endPoint.contains('/contract/create?$KB') && createSuccess){
            response.setBody('{"success":true,"message":"","result":56293}');
            
        }
        else if(endPoint.contains('/contract/create?$KB') && !createSuccess){
            response.setBody('Error Sir!!');
            response.setStatusCode(401);
        }
        else if(endPoint.contains('/search?$KB=') && searchSuccess){
            response.setBody('{"success":true,"message":"","result":[{"DAOcontract_to_location2":{},"DAOcontract_to_managing_unit":{},"requester_id":"106376","DAOcontract_to_print_template":{},"DAOcontract_to_managing_unit0":{},"DAOcontract_to_workflows":{},"DAOcontract_to_workflows0":{},"DAOcontract_to_contract_type":{},"DAOcontract_to_company1":{},"type":"contract","DAOcontract_to_email_text":{},"id":56278}]}');
        }
        else if(endPoint.contains('/search?$KB=') && searchSuccess2){
            response.setBody('{"success":true,"message":"","result":[{"DAOcontract_to_location2":{},"DAOcontract_to_managing_unit":{},"requester_id":"106376","DAOcontract_to_print_template":{},"DAOcontract_to_managing_unit0":{},"DAOcontract_to_workflows":{},"DAOcontract_to_workflows0":{},"DAOcontract_to_contract_type":{},"DAOcontract_to_company1":{},"type":"contract","DAOcontract_to_email_text":{}}]}');
        }
        else if(endPoint.contains('/search?$KB=') && !searchSuccess){
            response.setBody('Error Sir!!');
            response.setStatusCode(401);
        }
        
        return response; 
    }
}