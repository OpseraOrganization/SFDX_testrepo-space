public class SPoG_TestMockServiceError implements HttpCalloutMock{
    public static String body;
    public HttpResponse respond(HttpRequest objRequest) {
        HttpResponse objResponse = new HttpResponse(); 
        String testEndPoint = (String) objRequest.getEndpoint(); // get the end point 
        objResponse.setStatusCode(404); 
        objResponse.setStatus('ERROR');
        objResponse.setBody(body);
        return objResponse;
    }
}