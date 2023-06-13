@isTest
private class ConcurUpdateUserResponseTest {
    
    @isTest static void testParse() {
        // arrange
        String json = '{"records-succeeded":2,"records-failed":1,"errors":null,"UsersDetails":[]}';
        
        // act
        ConcurUpdateUserResponse obj = ConcurUpdateUserResponse.parse(json);
        
        // assert
        System.assertNotEquals(null, obj);
        System.assertEquals(2, obj.records_succeeded);
        System.assertEquals(1, obj.records_failed);
    }
    
}