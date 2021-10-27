@isTest
public class BatchConUserEmailUpdateTest {
   
	public static TestMethod void testMethod1() {
		List<Profile> profileList = [Select id, name FROM Profile where name=: 'System Administrator' Limit 1];
		if(!profileList.isEmpty()){
			User usr1=new User(firstname = 'John', 
							   lastName = 'Deo', 
							   email = 'CHJohntest@nokia.com', 
							   Username = 'Prateekchtesttestch@test.com.nokia', 
							   EmailEncodingKey = 'ISO-8859-1', 
							   Alias = 'testa', 
							   TimeZoneSidKey = 'America/Los_Angeles', 
							   LocaleSidKey = 'en_US', 
							   LanguageLocaleKey = 'en_US', 
							   CH_Case_Handling_Internal_Contact__c = true,
							   Active_Nokia_Employee__c = true,
							   Nokia_ID__c = '9876543',
							   MobilePhone = '2021233456',
							   CH_OldEmail__c = 'test12@test.com',
							   ProfileId = profileList[0].Id
							  ); 
			
			
			insert usr1; 
			List<User> usrList = [Select id , firstName,MobilePhone, lastName, Nokia_ID__c,email, CH_OldEmail__c ,  Active_Nokia_Employee__c FROM User where id =: usr1.id ];  
			system.runAs(new User(Id = Userinfo.getUserId())){
	Test.startTest();
	Contact con = new Contact();
	con.firstname = usrList[0].FirstName;
	con.LastName = usrList[0].LastName;
	con.MobilePhone = usrList[0].MobilePhone;
	con.CH_LegacyContactId__c = usrList[0].Nokia_ID__c;
	con.Contact_Status__c = 'Active';
	con.Email  = usrList[0].email;
	con.CH_ContactType__c = 'Nokia Employee';
	insert con;
	system.assertNotEquals(null, con);
	
	BatchConUserEmailUpdate  conUsrEmailBatch = new BatchConUserEmailUpdate ();
	ID batchprocessid = Database.executeBatch(conUsrEmailBatch);
	system.assertNotEquals(conUsrEmailBatch ,null);
	//Database.QueryLocator ql = conUsrEmailBatch.start(null);
	//conUsrEmailBatch.execute(null,usrList);
	//conUsrEmailBatch.Finish(null);
	Test.stopTest();
			}
		}
	}
}