@isTest
global class PegaCreateCaseMock implements HttpCalloutMock {
    
     global HTTPResponse respond(HTTPRequest request) {

        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"Indicator":"Success","ErrorMessage":"NA","Pega ID":"O-4328"}');
        response.setStatusCode(200);
        return response;

}


}