@isTest
global class forgeCloseCalloutMock implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"error":{"errorCode":500,"errorDateTime":"2021-01-29T08:55:11.251Z","errorDescription":{"message":"An unexpected error occurred"},"errorMessage":"INTERNAL_SERVER_ERROR"}}');
        response.setStatusCode(500);
        return response; 
    }
}