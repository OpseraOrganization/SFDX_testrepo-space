@isTest
public class SCIMCreateUserResponseTest {

    @isTest static void testParse() {
        // arrange
        String json = '{"id":"some-id","userName":"some-username"}';

        // act
        SCIMCreateUserResponse obj = SCIMCreateUserResponse.parse(json);

        // assert
        System.assert(obj != null);
        System.assertEquals('some-id', obj.id);
        System.assertEquals('some-username', obj.userName);
    }
    
}