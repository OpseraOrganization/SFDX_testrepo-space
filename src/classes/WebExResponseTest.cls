@isTest
private class WebExResponseTest {

    @isTest static void testParse() {
        // arrange
        String xml = '<?xml version="1.0" encoding="UTF-8"?><serv:message xmlns:serv="http://www.webex.com/schemas/2002/06/service" xmlns:com="http://www.webex.com/schemas/2002/06/common" xmlns:use="http://www.webex.com/schemas/2002/06/service/user"><serv:header><serv:response><serv:result>SUCCESS</serv:result><serv:gsbStatus>PRIMARY</serv:gsbStatus></serv:response></serv:header><serv:body><serv:bodyContent xsi:type="use:delUserResponse" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" /></serv:body></serv:message>';
        
        // act
        WebExResponse response = WebExResponse.parse(xml);

        // assert
        System.assertNotEquals(null, response);
        System.assertEquals('SUCCESS', response.result);
        System.assertEquals('PRIMARY', response.gsbStatus);
        System.assertEquals(null, response.exceptionId);
    }

}