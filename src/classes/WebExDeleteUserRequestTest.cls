@isTest
private class WebExDeleteUserRequestTest {

    @isTest static void testSerialize() {
        // arrange
        String webExId = 'jane.doe@example.org';
        WebExSecurityContext securityContext = new WebExSecurityContext('example', 'john.doe@example.org', 'S3cr3t@');
        String expectedXML = '<?xml version="1.0" encoding="UTF-8"?><serv:message xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:serv="http://www.webex.com/schemas/2002/06/service"><header><securityContext><siteName>example</siteName><webExID>john.doe@example.org</webExID><password>S3cr3t@</password></securityContext></header><body><bodyContent xsi:type="java:com.webex.service.binding.user.DelUser"><webExId>jane.doe@example.org</webExId></bodyContent></body></serv:message>';
        
        // act
        WebExDeleteUserRequest request = new WebExDeleteUserRequest(webExId);
        String actualXML = request.serialize(securityContext);

        // assert
        System.assertEquals(expectedXML, actualXML);
        new Dom.Document().load(actualXML);
    }

    @isTest static void testXMLEscaping() {
        // arrange
        String webExId = '<&>';
        WebExSecurityContext securityContext = new WebExSecurityContext('<&>', '<&>', '<&>');
        
        // act
        WebExDeleteUserRequest request = new WebExDeleteUserRequest(webExId);
        String actualXML = request.serialize(securityContext);

        // assert
        new Dom.Document().load(actualXML);
    }

}