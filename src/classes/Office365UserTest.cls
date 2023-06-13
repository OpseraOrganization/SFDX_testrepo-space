@isTest
private class Office365UserTest {
    
    @isTest static void testParse() {
        // arrange
        String json = '{"odata.metadata":"https://graph.windows.net/my-instance.onmicrosoft.com/$metadata#directoryObjects/Microsoft.WindowsAzure.ActiveDirectory.User/@Element","odata.type":"Microsoft.WindowsAzure.ActiveDirectory.User","objectType":"User","objectId":"0b7feba6-2e4e-43f6-97fb-c2d6521f3f84","accountEnabled":true,"assignedLicenses":[],"assignedPlans":[],"city":null,"country":null,"department":null,"dirSyncEnabled":null,"displayName":"Some User","facsimileTelephoneNumber":null,"givenName":null,"jobTitle":null,"lastDirSyncTime":null,"mail":null,"mailNickname":"someuser","mobile":null,"otherMails":["daisypop89@gmail.com"],"passwordPolicies":null,"passwordProfile":null,"physicalDeliveryOfficeName":null,"postalCode":null,"preferredLanguage":null,"provisionedPlans":[],"provisioningErrors":[],"proxyAddresses":[],"state":null,"streetAddress":null,"surname":null,"telephoneNumber":null,"usageLocation":null,"userPrincipalName":"someuser@my-instance.onmicrosoft.com"}';
        
        // act
        Office365User obj = Office365User.parse(json);
        
        // assert
        System.assertNotEquals(null, obj);
        System.assertEquals('0b7feba6-2e4e-43f6-97fb-c2d6521f3f84', obj.objectId);
        System.assertEquals('someuser@my-instance.onmicrosoft.com', obj.userPrincipalName);
    }

    @isTest static void testSerializeWithNulls() {
        // arrange
        Office365User user = new Office365User();
        
        // act
        String payload = user.serialize();

        // assert
        Map<String, Object> payloadData = (Map<String, Object>)JSON.deserializeUntyped(payload);

        // test properties that exist for Office365User
        System.assert(!payloadData.containsKey('accountEnabled'));
        System.assert(!payloadData.containsKey('passwordProfile'));
    }
    
}