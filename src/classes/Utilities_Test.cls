//created by Reis Sónia 29/04/2019
@isTest
public class Utilities_Test {
	
	@testSetup
	public static void setup(){
		User user= new User();
		user.FirstName = 'JOHN';
		user.LastName = 'SNOW';
		user.IsActive = true;
		user.Username = 'xx489@gmail.com';
		user.Email='xx489@gmail.com';
		user.Alias='xxx0';
		user.CommunityNickname = '0000';
		user.TimeZoneSidKey = 'GMT'; 
		user.LocaleSidKey= 'en_US';
		user.EmailEncodingKey= 'ISO-8859-1';
		user.ProfileId = [select id from profile limit 1].id;
		user.LanguageLocaleKey = 'en_US';
		insert user;
		
	}
	
	@isTest
	public static void test(){
		Test.startTest();
		List<User> result = [select id, name from User limit 1];
		Utilities.GenericOrOFUsersForFlows(new List<List<String>> {new List<String>{String.ValueOf(result[0].id)}});
		Test.stopTest();
	}
	
	@isTest
	public static void testEmptyList(){
		Test.startTest();
		Utilities.GenericOrOFUsersForFlows(new List<List<String>>());
		Test.stopTest();
	}
}