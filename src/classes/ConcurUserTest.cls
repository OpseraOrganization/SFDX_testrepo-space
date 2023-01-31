@isTest
private class ConcurUserTest {

    @isTest static void testParseJSON() {
        // arrange
        String json = '{"LoginID":"ConcurConsultant@d0005524pnbx","EmployeeID":"Concur Consultant","FirstName":"ConcurConsultant","LastName":"ConcurConsultant","MiddleName":"","PrimaryEmail":"ConcurConsultant@d0005524pnbx","Active":true,"CellPhoneNumber":"","OrganizationUnit":null,"ID":null,"URI":null}';

        // act
        ConcurUser obj = ConcurUser.parseJSON(json);

        // assert
        System.assertNotEquals(null, obj);
        System.assertEquals('Concur Consultant', obj.employeeId);
        System.assertEquals('ConcurConsultant@d0005524pnbx', obj.loginId);
    }

    @isTest static void testConstructors() {
        // arrange
        String loginId = 'user@example.org';
        String firstName = 'Jane';
        String lastName = 'Doe';
        String password = 'P@ssw0rd!';

        // act
        ConcurUser user1 = new ConcurUser(firstName, lastName, loginId, password);
        ConcurUser user2 = new ConcurUser(firstName, lastName, loginId);

        // assert
        System.assertNotEquals(null, user1);
        System.assertEquals(loginId, user1.loginId);
        System.assertEquals(loginId, user1.primaryEmail);
        System.assertEquals(password, user1.password);
        System.assertEquals(firstName, user1.firstName);

        System.assertNotEquals(null, user2);
        System.assertEquals(loginId, user2.loginId);
        System.assertEquals(loginId, user2.primaryEmail);
        System.assertEquals(null, user2.password);
        System.assertEquals(firstName, user2.firstName);
    }

    @isTest static void testSerializeXML() {
        // arrange
        String loginId = 'user@example.org';
        String firstName = 'Jane';
        String lastName = 'Doe';
        String password = 'P@ssw0rd!';
        String expectedXML1 = '<batch xmlns="http://www.concursolutions.com/api/user/2011/02"><UserProfile><FeedRecordNumber>1</FeedRecordNumber><LocaleName>en_US</LocaleName><CrnKey>USD</CrnKey><Custom21>US</Custom21><CtryCode>US</CtryCode><LedgerCode>Default</LedgerCode><EmpId>user@example.org</EmpId><LoginId>user@example.org</LoginId><EmailAddress>user@example.org</EmailAddress><Active>Y</Active><Password>P@ssw0rd!</Password><FirstName>Jane</FirstName><LastName>Doe</LastName></UserProfile></batch>';
        String expectedXML2 = '<batch xmlns="http://www.concursolutions.com/api/user/2011/02"><UserProfile><FeedRecordNumber>1</FeedRecordNumber><LocaleName>en_US</LocaleName><CrnKey>USD</CrnKey><Custom21>US</Custom21><CtryCode>US</CtryCode><LedgerCode>Default</LedgerCode><EmpId>user@example.org</EmpId><LoginId>user@example.org</LoginId><EmailAddress>user@example.org</EmailAddress><Active>Y</Active><Password> </Password><FirstName>Jane</FirstName><LastName>Doe</LastName></UserProfile></batch>';

        // act
        ConcurUser user1 = new ConcurUser(firstName, lastName, loginId, password);
        ConcurUser user2 = new ConcurUser(firstName, lastName, loginId);
        String actualXML1 = user1.serializeXML();
        String actualXML2 = user2.serializeXML();

        // assert
        System.assertEquals(expectedXML1, actualXML1);
        System.assertEquals(expectedXML2, actualXML2);
        new Dom.Document().load(actualXML1);
        new Dom.Document().load(actualXML2);
    }

    @isTest static void testXMLEscaping() {
        // arrange
        String firstName = '<&>';
        String lastName = '<&>';
        String loginId = '<&>';
        
        // act
        ConcurUser user = new ConcurUser(firstName, lastName, loginId);
        String actualXML = user.serializeXML();

        // assert
        new Dom.Document().load(actualXML);
    }

}