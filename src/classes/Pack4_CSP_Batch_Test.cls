@isTest 
public class Pack4_CSP_Batch_Test {
	static testMethod void testMethodProcessPack4_CSP() {
		
		List<User> userList = new List<User>();
		List<UserTerritory2Association> userAssignedToTerritoryList = new List<UserTerritory2Association>();
		userList = TestDataFactory.userCreation(2,'System Administrator') ;
		userList[0].NSA_Compliant__c = false ;
		database.insert(userList);	 
		
		system.runAs(userList[0]){
			
			Sales_Role_Audit__c insertrecord = new Sales_Role_Audit__c(Organisation__c = 'CO Deactivated Accounts', Operation_Type__c = 'Insert', Role_Name__c = '5 - BG Care Cluster Head', Role_Code__c = 'NSND_BGSCH', Is_Processed__c = false, Hierarchy_Id__c = '500135', Role_Owner_ID__c = '69105772');	
			insertrecord.Role_Start_Date__c = date.today();
			insertrecord.BG__c = 'NSW';
			insertrecord.User__c = userList[0].Id;
			insertrecord.Operation_Type__c = 'Insert';
			database.insert (insertrecord);
			
			Id territoryId = TestDataFactory.getL3TerritoryId();
			userAssignedToTerritoryList = TestDataFactory.assigningUserToTerritory(1,userList[0], territoryId) ;
			database.insert(userAssignedToTerritoryList);
		}
		
		Test.startTest();
		
		Pack4_CSP_Batch pack4csp_batch = new Pack4_CSP_Batch();
		Database.executeBatch(pack4csp_batch);
		
		Test.stopTest();
	}

	static testmethod void scheduleTest(){
		Test.startTest();
		
		String sch = '0 0 23 * * ?';
		Scheduler_Pack4_CSP_Batch schedul = new Scheduler_Pack4_CSP_Batch();
		system.schedule('Pack4_CSP', sch, schedul);
		
		Test.stopTest();
	}
}