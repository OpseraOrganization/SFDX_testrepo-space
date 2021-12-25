@IsTest
public class CheckNSASecurityTest {
	@testSetup static void createTestData() {
		NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
	}
	public static testMethod void NSASecurityTest1(){   
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
	   // runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
	   // runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		
		system.runAs(runAsUSer[0]){
			
		  	List<NSA_Exception_Profile__c> profilesNameList = new List<NSA_Exception_Profile__c>();
			List<NSA_Alert_Sent_To_EmailAddess__c> emailList = new List<NSA_Alert_Sent_To_EmailAddess__c>();
			List<NSA_Object__c> objectValueList = new List<NSA_Object__c>();
			/* Map <String, NSA_Exception_Profile__c> profilesNameList = NSA_Exception_Profile__c.getAll();
			Map <String, NSA_Alert_Sent_To_EmailAddess__c> emailList = NSA_Alert_Sent_To_EmailAddess__c.getAll();
			Map <String, NSA_Object__c> objectValueList = NSA_Object__c.getAll();*/
			
			NSA_Exception_Profile__c profilesName1 = new NSA_Exception_Profile__c(Name = 'Analytics Cloud Integration User');
			NSA_Exception_Profile__c profilesName2 = new NSA_Exception_Profile__c(Name = 'Nokia Read Only');
			profilesNameList.add(profilesName1);
			profilesNameList.add(profilesName2);
			database.Insert(profilesNameList);
			
			NSA_Alert_Sent_To_EmailAddess__c email1 = new NSA_Alert_Sent_To_EmailAddess__c(Name = 'Sonali', Emailid__c = 'sonali.j.kothavale@accenture.com');
			emailList.add(email1);
			database.insert(emailList);
			
			NSA_Object__c obj1 = new NSA_Object__c(Name = 'Account');
			objectValueList.add(obj1);
			database.insert(objectValueList);
			
			Test.startTest();
			List<user> adminuser = new List<user>();
			adminuser = TestDataFactory.userCreation(2,'Analytics Cloud Integration User');	
			adminuser[0].UserRoleId  = system.Label.Global_Role_ID;
			adminuser[0].NSA_Compliant__c = true;
			Database.Insert(adminuser);
			
			List<user> nonAdminuser = new List<user>();
			nonAdminuser = TestDataFactory.userCreation(2,'Nokia Read Only');	
			nonAdminuser[0].UserRoleId  = system.Label.Global_Role_ID;
			nonAdminuser[0].NSA_Compliant__c = true;
			Database.Insert(nonAdminuser);
			NSACheckScheduler sh = new NSACheckScheduler();
			sh.execute(null);
			Test.stopTest();
			
		}	
	}
	
}