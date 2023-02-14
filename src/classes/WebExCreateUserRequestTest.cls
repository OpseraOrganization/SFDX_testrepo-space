@isTest
private class WebExCreateUserRequestTest {

    @isTest static void testSerialize() {
        // arrange
        String firstName = 'Jane';
        String lastName = 'Doe';
        String email = 'jane.doe@example.org';
        String password = 'P@ssw0rd!';
        WebExSecurityContext securityContext = new WebExSecurityContext('example', 'john.doe@example.org', 'S3cr3t@');
        String expectedXML = '<?xml version="1.0" encoding="UTF-8"?><serv:message xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:serv="http://www.webex.com/schemas/2002/06/service"><header><securityContext><siteName>example</siteName><webExID>john.doe@example.org</webExID><password>S3cr3t@</password></securityContext></header><body><bodyContent xsi:type="java:com.webex.service.binding.user.CreateUser"><firstName>Jane</firstName><lastName>Doe</lastName><webExId>jane.doe@example.org</webExId><email>jane.doe@example.org</email><password>P@ssw0rd!</password><privilege><host>true</host><isEnablePMR>FALSE</isEnablePMR></privilege><active>ACTIVATED</active></bodyContent></body></serv:message>';
        
        // act
        WebExCreateUserRequest request = new WebExCreateUserRequest(firstName, lastName, email, password);
        String actualXML = request.serialize(securityContext);

        // assert
        System.assertEquals(expectedXML, actualXML);
        new Dom.Document().load(actualXML);
    }

    @isTest static void testXMLEscaping() {
        // arrange
        String firstName = '<&>';
        String lastName = '<&>';
        String email = '<&>';
        String password = '<&>';
        WebExSecurityContext securityContext = new WebExSecurityContext('<&>', '<&>', '<&>');
        
        // act
        WebExCreateUserRequest request = new WebExCreateUserRequest(firstName, lastName, email, password);
        String actualXML = request.serialize(securityContext);

        // assert
        new Dom.Document().load(actualXML);
    }

}