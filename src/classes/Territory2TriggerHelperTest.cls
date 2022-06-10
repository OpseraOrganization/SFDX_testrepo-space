@isTest
public class Territory2TriggerHelperTest {
	
	private static User testUser = NF_TestDataFactory.createAdminUser('System Administrator');
	
	static testmethod void deleteTerritoryTest(){
		User userObj = [Select Id from User where Id = :UserInfo.getUserId()];
		insert testUser;
		System.runAs(testUser){
			List<Territory2Model> model = [select Id, DeveloperName from Territory2Model where DeveloperName = 'Nokia_Sales_Hierarchy'];
			List<Territory2Type> type = [Select Id, DeveloperName from Territory2Type limit 1];
			Territory2 newTerritory = NF_TestDataFactory.CreateTerritory2('Territory Testing', 'L7', model[0].Id, type[0].Id);
			insert newTerritory;
			
			Sales_Role__c newSalesRole = NF_TestDataFactory.createSalesRole(userObj, 'NSNG_BGDCT', newTerritory.Name, 'BG Delivery Manager');
			insert newSalesRole;
			Test.startTest();
			//cannot perform delete of the territory record - to cover it's called the method
			Territory2TriggerHandler handler = new Territory2TriggerHandler();
			handler.oldList = null;
			handler.afterDelete();
			handler.oldList = new List<Territory2>{newTerritory};
			handler.afterDelete();
			Test.stopTest();
			List<Sales_Role__c> salesRoles = [Select Id from Sales_Role__c];
			System.assert(salesRoles.isEmpty());
		}
		
		
	}
	
}