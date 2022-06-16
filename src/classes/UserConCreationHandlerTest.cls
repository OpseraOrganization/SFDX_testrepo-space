@isTest
public class UserConCreationHandlerTest{
	
	@testSetup static void setup() {
		List<Profile> profileList = [Select id, name FROM Profile where name=: 'System Administrator' Limit 1];
		if(!profileList.isEmpty()){
			User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
			System.runAs(thisUser){
			User usr1=new User(firstname = 'ABC', 
		  lastName = 'XYZ', 
		  email = 'abcav@nokia.com', 
		  Username = 'ABCAv@test.com.nokia', 
		  EmailEncodingKey = 'ISO-8859-1', 
		  Alias = 'testa', 
		  TimeZoneSidKey = 'America/Los_Angeles', 
		  LocaleSidKey = 'en_US', 
		  LanguageLocaleKey = 'en_US', 
		  CH_Case_Handling_Internal_Contact__c = true,
		  Active_Nokia_Employee__c = true,
		  Nokia_ID__c = '79797979',
		  MobilePhone = '2021233456',
		  ProfileId = profileList[0].Id
		 ); 
			insert usr1; 
			}
		
			
			User usr2=new User(firstname = 'ABC1', 
		  lastName = 'XYZ1', 
		  email = 'abc1av@nokia.com', 
		  Username = 'ABC1Av@test.com.nokia', 
		  EmailEncodingKey = 'ISO-8859-1', 
		  Alias = 'testa', 
		  TimeZoneSidKey = 'America/Los_Angeles', 
		  LocaleSidKey = 'en_US', 
		  LanguageLocaleKey = 'en_US', 
		  CH_Case_Handling_Internal_Contact__c = false,
		  Active_Nokia_Employee__c = true,
		  Nokia_ID__c = '89898989',
		  MobilePhone = '2021233456',
		  ProfileId = profileList[0].Id
		 ); 
			insert usr2; 
			
			
			User usr3=new User(firstname = 'ABC2', 
		  lastName = 'XYZ2', 
		  email = 'abc2av@nokia.com', 
		  Username = 'ABC2Av@test.com.nokia', 
		  EmailEncodingKey = 'ISO-8859-1', 
		  Alias = 'testb', 
		  TimeZoneSidKey = 'America/Los_Angeles', 
		  LocaleSidKey = 'en_US', 
		  LanguageLocaleKey = 'en_US', 
		  CH_Case_Handling_Internal_Contact__c = true,
		  Active_Nokia_Employee__c = true,
		  Nokia_ID__c = '1230987654',
		  MobilePhone = '7676134879',
		  ProfileId = profileList[0].Id
		 ); 
			
			insert usr3;
			
			
		}
	}
	
	//Create Record type Map
	static Map < String, RecordType > recordTypeMap = getRecordTypeByDeveloperName();
	static Map < String, RecordType > getRecordTypeByDeveloperName() {
		if(recordTypeMap == null) {
			recordTypeMap = new Map < String, RecordType > ();
			for(RecordType recordTypeObj: [SELECT Id, Name, DeveloperName FROM RecordType]) {
	recordTypeMap.put(recordTypeObj.DeveloperName, recordTypeObj);
			}
		}
		return recordTypeMap;
	}
	
	//This method is checking that a user created with CH_Case_Handling_Internal_Contact__c and Active employee flags set to true creates a contact
	@isTest static void testMethod1() {
		
		//Use start and stop because the user trigger has a future method
		Test.startTest();
		User usr = [Select id , firstName,MobilePhone, lastName, Nokia_ID__c, email FROM User Where Username = 'ABCAv@test.com.nokia'];  
		
		Test.stopTest();
		
		Contact con = [select id, name, email from contact where email = :usr.email];
		system.assertNotEquals(null, con);
	}
	
	
	//This method tests that a user is updated with the CH_Case_Handling_Internal_Contact__c flag to true and check that a contact is created
	@isTest static void testMethod2() {
		
		//Use start and stop because the user trigger has a future method
		Test.startTest(); 
		User usr = [Select id , firstName,MobilePhone, email, lastName, Nokia_ID__c,CH_Case_Handling_Internal_Contact__c, Active_Nokia_Employee__c  FROM User Where Username = 'ABC1Av@test.com.nokia' Limit 1 ];  
		usr.CH_Case_Handling_Internal_Contact__c = true;
		usr.Active_Nokia_Employee__c  = true;
		update usr;
		
		
		Test.stopTest();
		
		Contact con = [select id, name, email from contact where email = :usr.email];
		system.assertNotEquals(null, con);
	}
	
	//This method is to test making the user flag CH_Case_Handling_Internal_Contact__c false and checking that the contact is set to Inactive
	@isTest static void testMethod3() {
		User usr = [Select id ,email, firstName,MobilePhone,CH_Case_Handling_Internal_Contact__c, Active_Nokia_Employee__c,  lastName, Nokia_ID__c FROM User Where Username = 'ABCAv@test.com.nokia' Limit 1 ];  
		usr.CH_Case_Handling_Internal_Contact__c = false;
		
		//Use start and stop because the user trigger has a future method
		
		Test.startTest();
		update usr;
		Test.stopTest();
		
		
		Contact con = [select id, name, email, Contact_Status__c from Contact where email = :usr.Email];
		
		System.assertEquals(con.Contact_Status__c,'Inactive');
		
		
		
	} 
	
	//This method tests that a inactive user and inactive contact already exist - and the User record is activeted - that should update the Contact record
	@isTest static void testMethod4()
	{
		User usr = [Select id ,email, firstName,MobilePhone,CH_Case_Handling_Internal_Contact__c, Active_Nokia_Employee__c,  lastName, Nokia_ID__c FROM User Where Username = 'ABC2Av@test.com.nokia' Limit 1 ];	

		usr.CH_Case_Handling_Internal_Contact__c = false;
		usr.Active_Nokia_Employee__c  = true;
		
		Test.startTest();
		update usr;
		
		usr.CH_Case_Handling_Internal_Contact__c = true;
		update usr;

		Test.stopTest();
		
		Contact con1 = [select id, name, email, Contact_Status__c from contact where email = :usr.email];
		system.assertEquals(con1.Contact_Status__c, 'Active');

	}
	
	
	@isTest static void testMethod5()
	{
	
	 	user user  = new user();
		Set<Id> userIdSet = new Set<Id>();
	
		//userIdSet.Id = runUSer.Id;
		Set<Id> caseIdSet = new Set<Id>();
		
		UserConCreationHandler.sendMailTOQueueMembers(userIdSet, caseIdSet);
		
	}
	
}