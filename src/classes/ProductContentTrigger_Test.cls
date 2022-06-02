@isTest
private class ProductContentTrigger_Test 
{
	static testMethod void updateProductContentCountTest(){
		List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
		users[0].Nokia_ID__c = '234597';
		insert users;
		
		System.runAs(users[0]) {
			Product2 prod = TestDataSetup.createCPQTestproduct(1)[0];
			prod.Apttus_Config2__ConfigurationType__c = 'Bundle';
			insert prod;
			
			NCP_Product_Content__c pc = new NCP_Product_Content__c();
			pc.NCP_External_Id__c = '833-010735-Product Alerts';
			pc.CurrencyIsoCode = 'EUR';
			pc.NCP_Service__c = 'Product Alerts';
			pc.NCP_Product__c = prod.Id;
			insert pc;
			
			pc.NCP_External_Id__c = '833-010735-Product';
			update pc;
			
			NCP_Product_Content__c pcToDelete = [Select Id FROM NCP_Product_Content__c WHERE Id =: pc.Id];
			Delete pcToDelete;
		}
	}   
}