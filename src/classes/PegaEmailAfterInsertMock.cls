@isTest
global class PegaEmailAfterInsertMock implements HttpCalloutMock {
    
     global HTTPResponse respond(HTTPRequest request) {

        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        //response.setBody('{"Indicator":"Success","ErrorMessage":"NA","Pega ID":"O-1234"}');
        response.setStatusCode(500);
        return response;

}
}