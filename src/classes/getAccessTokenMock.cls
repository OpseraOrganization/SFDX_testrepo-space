@isTest
global class getAccessTokenMock implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest request) {
        
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"organization_name":"honeywell-qa","developer.email":"priyanka.smruty@honeywell.com","token_type":"Bearer","issued_at":"1611819743320","client_id":"e9WMCdWnIzFV8nRLl1ywWXqASsSjfWDw","access_token":"MW8Qi6uMdwMs9IE6B2GDWUmUdheD"}');
        response.setStatusCode(200);
        return response; 
        
    }
}