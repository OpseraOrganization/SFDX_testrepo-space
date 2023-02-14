@isTest
private class ConcurUsersTest {

    @isTest static void testParse() {
        // arrange
        String json = '{"Items":[{"LoginID":"ConcurAdmin@d0005524pnbx","EmployeeID":"Concur Administrator","FirstName":"Concur","LastName":"Administrator","MiddleName":"","PrimaryEmail":"ConcurAdmin@d0005524pnbx","Active":true,"CellPhoneNumber":"","OrganizationUnit":null,"ID":null,"URI":null}],"NextPage":"https://www.concursolutions.com/api/v3.0/common/users?offset=gWuh$so$pTIuR2SawWw8XIVcNxh&limit=1"}';

        // act
        ConcurUsers obj = ConcurUsers.parse(json);

        // assert
        System.assertNotEquals(null, obj);
        System.assertNotEquals(null, obj.nextPage);
        System.assertEquals(1, obj.items.size());
    }

}