@isTest
global class MockHttpResponse_MKTOEmailOptin implements HttpCalloutMock
{
  global HttpResponse respond(HttpRequest request)
  {
    HttpResponse response = new HttpResponse();
    response.setHeader('Content-Type', 'application/json');
    response.setBody('{"access_token":"d0b9f451-365d-439c-9e5c-927f35fdcfa4:ab","token_type":"bearer","expires_in":3012,"scope":"vamsikrishna.mopidevi@honeywell.com"}');
    response.setStatusCode(200);
    return response;
  }
  
  global HttpResponse respond2(HttpRequest request)
  {
    HttpResponse response = new HttpResponse();
    response.setHeader('Content-Type', 'application/json');
    response.setBody('{"requestId":"a39d#16381a0b805","result":[{"id":2996569,"leadPartitionId":1,"Email_Opt_In__c":true,"email":"maheshbabu11.kayala@nttdata.com"},{"id":3028121,"leadPartitionId":1,"Email_Opt_In__c":true,"email":"maheshbabu11.kayala@nttdata.com"}],"success":true}');
    response.setStatusCode(200);
    return response;
  }
  
  global HttpResponse respond3(HttpRequest request)
  {
    HttpResponse response = new HttpResponse();
    response.setHeader('Content-Type', 'application/json');
    response.setBody('{"requestId":"331c#16381a0bd4a","result":[{"id":2996569,"status":"updated"},{"id":3028121,"status":"updated"}],"success":true}');
    response.setStatusCode(200);
    return response;
  }


}