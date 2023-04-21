@isTest
private class GoToMeetingShortUserTest {

    @isTest static void testParse() {
        // arrange
        String json = '[{"key":"3460848458210132485","email":"daisypop89@gmail.com"}]';

        // act
        List<GoToMeetingShortUser> objs = GoToMeetingShortUser.parseUsers(json);

        // assert
        System.assertNotEquals(null, objs);
        System.assertEquals(1, objs.size());
        System.assertEquals('3460848458210132485', objs[0].key);
    }

}