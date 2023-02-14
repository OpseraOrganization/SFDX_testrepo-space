@isTest
private class Office365UsersTest {
    
    @isTest static void testParse() {
        // arrange
        String json = '{"odata.metadata":"https://graph.windows.net/my-instance.onmicrosoft.com/$metadata#directoryObjects/Microsoft.WindowsAzure.ActiveDirectory.User","value":[{"odata.type":"Microsoft.WindowsAzure.ActiveDirectory.User","objectType":"User","objectId":"35a545ad-4799-4e3f-99c5-8f1de07312dd","accountEnabled":true,"assignedLicenses":[],"assignedPlans":[],"city":null,"country":null,"department":null,"dirSyncEnabled":null,"displayName":"Daisy Jensen","facsimileTelephoneNumber":null,"givenName":"Daisy","jobTitle":null,"lastDirSyncTime":null,"mail":null,"mailNickname":"daisypop89_gmail.com#EXT#","mobile":null,"otherMails":["daisypop89@gmail.com"],"passwordPolicies":null,"passwordProfile":null,"physicalDeliveryOfficeName":null,"postalCode":null,"preferredLanguage":null,"provisionedPlans":[],"provisioningErrors":[],"proxyAddresses":[],"state":null,"streetAddress":null,"surname":"Jensen","telephoneNumber":null,"usageLocation":null,"userPrincipalName":"daisypop89_gmail.com#EXT#@my-instance.onmicrosoft.com"}],"odata.nextLink":"directoryObjects/$/Microsoft.WindowsAzure.ActiveDirectory.User?$skiptoken=X\'44537074020001000000123A6E776F6F6C6C7340676D61696C2E636F6D29557365725F33356135343561642D343739392D346533662D393963352D386631646530373331326464B900000000000000000000\'"}';
        
        // act
        Office365Users obj = Office365Users.parse(json);

        // assert
        System.assertNotEquals(null, obj);
        System.assertNotEquals(null, obj.odata_nextLink);
        System.assertEquals(1, obj.value.size());
    }
    
}