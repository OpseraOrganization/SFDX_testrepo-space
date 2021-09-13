@isTest
Private class custom_LookUpControllerTest{
	static testMethod void Lookuptest(){
		 List<User> testUser = NF_TestDataFactory.getUsers(3,'System Administrator');
		insert testUSer;
		System.runAs(testUSer[0]){ 
		 Test.startTest();
	   custom_LookUpController.fetchLookUpValues('BG','NF_RoleCode__c','Market Europe','IWA',true);
	   custom_LookUpController.fetchLookUpValues('BG','NF_RoleCode__c','Market Europe','Non-IWA',false);
	   custom_LookUpController.fetchLookUpValues('BG','NF_RoleCode__c','Market Europe','',true);
	   custom_LookUpController.fetchUserValues('dur','User','Market EuropeNSA');
	   custom_LookUpController.fetchUserValues('dur','User','Market Europe');
		Test.StopTest();
		}
	}
}