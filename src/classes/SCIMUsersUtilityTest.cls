@isTest
private class SCIMUsersUtilityTest {

    // Tests
    @isTest static void testGetAllUsers() {
        // arrange
        ConnectorUtil.HttpResponseGenerator generator = new ConnectorUtil.HttpResponseGenerator();
        ConnectorUtil.UserProvisioningTestUtils.setMock(generator);
        SCIMUsersUtility.endPoint = 'http://example.org';

        // act
        Map<String, Object> response = SCIMUsersUtility.getAllUsers(null, null);

        // assert
        System.assertEquals(true, response.get('isSuccess'));
        String endpoint = generator.firstRequest.getEndpoint();
        System.assertEquals(0, endpoint.countMatches('&filter'));
    }

    @isTest static void testGetAllUsersWithOffset() {
        // arrange
        ConnectorUtil.HttpResponseGenerator generator = new ConnectorUtil.HttpResponseGenerator();
        ConnectorUtil.UserProvisioningTestUtils.setMock(generator);
        SCIMUsersUtility.endPoint = 'http://example.org';
        String offset = 'some-offset';

        // act
        Map<String, Object> response = SCIMUsersUtility.getAllUsers(offset, null);

        // assert
        System.assertEquals(true, response.get('isSuccess'));
        String endpoint = generator.firstRequest.getEndpoint();
        System.assertEquals(1, endpoint.countMatches('&filter'));
    }

    @isTest static void testGetAllUsersWithFilter() {
        // arrange
        ConnectorUtil.HttpResponseGenerator generator = new ConnectorUtil.HttpResponseGenerator();
        ConnectorUtil.UserProvisioningTestUtils.setMock(generator);
        SCIMUsersUtility.endPoint = 'http://example.org';
        String filter = 'some-filter';

        // act
        Map<String, Object> response = SCIMUsersUtility.getAllUsers(null, filter);

        // assert
        System.assertEquals(true, response.get('isSuccess'));
        String endpoint = generator.firstRequest.getEndpoint();
        System.assertEquals(1, endpoint.countMatches('&filter'));
    }

    @isTest static void testGetAllUsersWithOffsetAndFilter() {
        // arrange
        ConnectorUtil.HttpResponseGenerator generator = new ConnectorUtil.HttpResponseGenerator();
        ConnectorUtil.UserProvisioningTestUtils.setMock(generator);
        SCIMUsersUtility.endPoint = 'http://example.org';
        String offset = 'some-offset';
        String filter = 'some-filter';

        // act
        Map<String, Object> response = SCIMUsersUtility.getAllUsers(offset, filter);

        // assert
        System.assertEquals(true, response.get('isSuccess'));
        String endpoint = generator.firstRequest.getEndpoint();
        System.assertEquals(1, endpoint.countMatches('&filter'));
    }

}