@isTest
global class PegaEmailServiceMock implements HttpCalloutMock  {
    
    global HTTPResponse respond(HTTPRequest request) {
        
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(200);
        return response;
        
    }

}