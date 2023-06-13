@isTest
private class WebExUpdateUserRequestTest {

    @isTest static void testSerialize() {
        // arrange
        String webExId = 'jane.doe@example.org';
        String active = 'ACTIVATED';
        WebExSecurityContext securityContext = new WebExSecurityContext('example', 'john.doe@example.org', 'S3cr3t@');
        String expectedXML = '<?xml version="1.0" encoding="UTF-8"?><serv:message xmlns:serv="http://www.webex.com/schemas/2002/06/service" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><header><securityContext><siteName>example</siteName><webExID>john.doe@example.org</webExID><password>S3cr3t@</password></securityContext></header><body><bodyContent xsi:type="java:com.webex.service.binding.user.SetUser"><webExId>jane.doe@example.org</webExId><active>ACTIVATED</active></bodyContent></body></serv:message>';
        
        // act
        WebExUpdateUserRequest request = new WebExUpdateUserRequest(webExId);
        request.active = active;
        String actualXML = request.serialize(securityContext);

        // assert
        System.assertEquals(expectedXML, actualXML);
        new Dom.Document().load(actualXML);
    }

    @isTest static void testXMLEscaping() {
        // arrange
        String webExId = '<&>';
        String active = '<&>';
        WebExSecurityContext securityContext = new WebExSecurityContext('<&>', '<&>', '<&>');
        
        // act
        WebExUpdateUserRequest request = new WebExUpdateUserRequest(webExId);
        request.active = active;
        String actualXML = request.serialize(securityContext);

        // assert
        System.debug(actualXML);
        new Dom.Document().load(actualXML);
    }

}