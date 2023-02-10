@isTest
private class WebExCollectUsersRequestTest {

    @isTest static void testSerialize() {
        // arrange
        Integer startFrom = 12;
        INteger maximumNum = 1234;
        WebExSecurityContext securityContext = new WebExSecurityContext('example', 'john.doe@example.org', 'S3cr3t@');
        String expectedXML = '<?xml version="1.0" encoding="UTF-8"?><serv:message xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:serv="http://www.webex.com/schemas/2002/06/service"><header><securityContext><siteName>example</siteName><webExID>john.doe@example.org</webExID><password>S3cr3t@</password></securityContext></header><body><bodyContent xsi:type="java:com.webex.service.binding.user.LstsummaryUser"><listControl><serv:startFrom>12</serv:startFrom><serv:maximumNum>1234</serv:maximumNum></listControl></bodyContent></body></serv:message>';
        
        // act
        WebExCollectUsersRequest request = new WebExCollectUsersRequest();
        request.startFrom = startFrom;
        request.maximumNum = maximumNum;
        String actualXML = request.serialize(securityContext);

        // assert
        System.assertEquals(expectedXML, actualXML);
        new Dom.Document().load(actualXML);
    }

}