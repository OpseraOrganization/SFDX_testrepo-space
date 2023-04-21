@isTest
public class SCIMUsersTest {

    @isTest static void testParse() {
        // arrange
        String json = '{"totalResults":2,"schemas":["urn:scim:schemas:core:1.0"],"Resources":[{"userName":"bjensen"},{"userName":"jsmith"}]}';

        // act
        SCIMUsers obj = SCIMUsers.parse(json);

        // assert
        System.assert(obj != null);
        System.assertEquals(2, obj.totalResults);
    }
    
}