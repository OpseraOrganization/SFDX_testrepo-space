@istest()
public class GlobalLookupClassTest {
	 @testSetup static void createTestData() {
			NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
			cs.Name = 'Default';
			cs.Customer_Account__c = 'Customer - test';
			cs.Customer_Account_Number__c = '12345';
			cs.Customer_User_Profile__c = 'Customers';
			insert cs;
		}
	private static testmethod void TestGlobalLookupClass(){
		String objectName='User';
		String fld_API_Text='Email';
		String fld_API_Val='Id';
		Integer lim=10;
		String fld_API_Search='Email';
		String searchText=PRMGlobalConstants.TestEmail;
		String orgId = userInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(PRMGlobalConstants.COLON,'').replace(PRMGlobalConstants.HYPHEN,'');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName = orgId + dateString + randomInt;
		Profile p = [SELECT Id FROM Profile WHERE Name =:PRMGlobalConstants.SysAdmin limit 1];
		User u = new User(Alias = PRMGlobalConstants.Aliass, Email=PRMGlobalConstants.TestEmail,
						  EmailEncodingKey = PRMGlobalConstants.FileUTF, LastName=PRMGlobalConstants.TestLName, LanguageLocaleKey=PRMGlobalConstants.TestLanguageLocaleKey,
						  LocaleSidKey=PRMGlobalConstants.TestLanguageLocaleKey, ProfileId = p.Id,TimeZoneSidKey=PRMGlobalConstants.TestTimeZone, 
						  Username = uniqueName + PRMGlobalConstants.Testt + orgId + PRMGlobalConstants.TestOrg,IsActive=true,Nokia_ID__c = randomInt + '0'); 
		Database.insert(u);
		Test.StartTest();
		String dataString=GlobalLookupClass.searchDB(objectName, fld_API_Text, fld_API_Val, lim, fld_API_Search, searchText);
		Test.stopTest();
		
	}
}