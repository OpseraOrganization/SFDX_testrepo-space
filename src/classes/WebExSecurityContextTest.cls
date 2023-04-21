@isTest
private class WebExSecurityContextTest {

    @isTest static void testSerialize() {
        // arrange
        String siteName = 'example';
        String webExId = 'jane.doe@example.org';
        String password = 'P@ssw0rd!';
        String expectedXML = '<securityContext><siteName>example</siteName><webExID>jane.doe@example.org</webExID><password>P@ssw0rd!</password></securityContext>';
        
        // act
        WebExSecurityContext securityContext = new WebExSecurityContext(siteName, webExId, password);
        String actualXML = securityContext.serialize();

        // assert
        System.assertEquals(expectedXML, actualXML);
        new Dom.Document().load(actualXML);
    }

    @isTest static void testXMLEscaping() {
        // arrange
        String siteName = '<&>';
        String webExId = '<&>';
        String password = '<&>';
        
        // act
        WebExSecurityContext securityContext = new WebExSecurityContext(siteName, webExId, password);
        String actualXML = securityContext.serialize();

        // assert
        new Dom.Document().load(actualXML);
    }

}