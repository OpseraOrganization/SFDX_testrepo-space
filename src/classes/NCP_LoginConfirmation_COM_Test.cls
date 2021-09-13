@isTest
private class NCP_LoginConfirmation_COM_Test {
   
	/*@isTest
	static void testMethod1() {
		Test.startTest();
			Account acc = NCP_TestFactory.createAccount();
			Contact cont = NCP_TestFactory.createContact(acc);	
			Map<String,String> accs = NCP_LoginConfirmation_COM.getAccounts();
			//User u = NCP_TestFactory.createUser(true,'AES Admin',null, 'test@nokia.com.dev');
			User portalUser = NCP_TestFactory.createUser(false,'test',cont, 'test2@nokian.com.dev');
			insert portalUser; 
			//NCP_LoginConfirmation_COM.saveUser('test', portalUser);
			List <String> opts =  NCP_LoginConfirmation_COM.getselectOptions();
			List<Boolean> validBool = NCP_LoginConfirmation_COM.validateHorizontalUser('test');
				
	}*/
	
	@isTest
	static void TestgetAccounts() { 
		User portalUser;
		System.runAs(NCP_TestFactory.createUser(true,'AES Admin',null, 'test@nokia.com.dev')){
			Account acc = NCP_TestFactory.createAccount();
			Contact cont = NCP_TestFactory.createContact(acc); 
			portalUser = NCP_TestFactory.createUser(false,'test',cont, 'test2@nokian.com.dev');
			insert portalUser; 
			//NCP_Email_To_Company__c emailDomaine = NCP_TestFactory.createEmailToCompany('nokian.com.dev',acc.Id);
		}				
		System.runAs(portalUser){
			Test.startTest();
	 	Map<String,String> mapAcc = NCP_LoginConfirmation_COM.getAccounts();
			System.assertNotEquals(null,mapAcc);
	 	Test.stopTest();
	 }
	}
		
	@isTest
	static void TestValidateHorizontalUser() { 
		User portalUser;
	  	System.runAs(NCP_TestFactory.createUser(true,'AES Admin',null, 'test@nokia.com.dev')){
			Account acc = NCP_TestFactory.createAccount();
			Contact cont = NCP_TestFactory.createContact(acc); 
			portalUser = NCP_TestFactory.createHorizontalUser('test',cont, 'test2@nokian.com.dev');
			insert portalUser; 
		}				
		System.runAs(portalUser){
			Test.startTest();
	 	List<boolean> b = NCP_LoginConfirmation_COM.ValidateHorizontalUser('test');
	 	Test.stopTest();
	 }
	}
	
	@isTest
	static void TestSelectOptions() { 
		User portalUser;
		System.runAs(NCP_TestFactory.createUser(true,'AES Admin',null, 'test@nokia.com.dev')){
			Account acc = NCP_TestFactory.createAccount();
			Contact cont = NCP_TestFactory.createContact(acc); 
			portalUser = NCP_TestFactory.createUser(false,'test',cont, 'test2@nokian.com.dev');
			insert portalUser; 
		}				
		System.runAs(portalUser){
			Test.startTest();
	 	List <String> options = NCP_LoginConfirmation_COM.getselectOptions();
			System.assertNotEquals(null,options);
	 	Test.stopTest();
	 }
	}

	/*@isTest
	static void TestsaveUser() {
		User portalUser;
		Account acc;
		Contact cont;
		System.runAs(NCP_TestFactory.createUser(true,'AES Admin',null, 'test@nokia.com.dev')){
			acc = NCP_TestFactory.createAccount();
			cont = NCP_TestFactory.createContact(acc);							  
			portalUser = NCP_TestFactory.createUser(false,'test',cont, 'test2@nokian.com.dev');
			insert portalUser;
		}
		System.runAs(portalUser){
			System.assert([select isPortalEnabled from user where id = :portalUser.id].isPortalEnabled, 'User was not flagged as portal enabled.');  
			Test.startTest();
			NCP_LoginConfirmation_COM.saveUser(acc.Name,portalUser);
			Test.stopTest();
		}			
	}*/

}