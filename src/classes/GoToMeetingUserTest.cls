@isTest
private class GoToMeetingUserTest {

    @isTest static void testParse() {
        // arrange
        String json = '[{"groupId":0,"lastName":"Doe","groupName":"NA","status":"active","email":"john.doe@example.com","organizerKey":3460848458210132485,"firstName":"John","products":["G2M"],"maxNumAttendeesAllowed":26},{"groupId":0,"lastName":"Doe","groupName":"NA","status":"active","email":"jane.doe@example.com","organizerKey":3004124522171115525,"firstName":"Jane","products":["G2M"],"maxNumAttendeesAllowed":26}]';

        // act
        List<GoToMeetingUser> objs = GoToMeetingUser.parseUsers(json);

        // assert
        System.assertNotEquals(null, objs);
        System.assertEquals(2, objs.size());
        System.assertEquals(3460848458210132485L, objs[0].organizerKey);
    }

}