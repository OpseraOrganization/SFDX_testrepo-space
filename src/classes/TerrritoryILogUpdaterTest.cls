@isTest
public class TerrritoryILogUpdaterTest {
	 static testmethod void testQueueable()  {
		Interface_Log__c interfaceLog = New Interface_Log__c();
		interfaceLog.Name = 'SRT2TerritoryAssociation';
		/***************************************************************/
		interfaceLog.Message_Type__c = GlobalConstants.INBOUND;
		interfaceLog.Status__c = GlobalConstants.FAILURE;
		interfaceLog.Comment__c = 'Failure' ;
		interfaceLog.Operation_type__c = GlobalConstants.INSERT_VALUE; 
		interfaceLog.Interface_Request_Sent__c =  'testing';
		interfaceLog.Interface_Type__c = 'SRT2TerritoryAssociation';
		interfaceLog.Message_Type__c = GlobalConstants.INBOUND;  
		insert interfaceLog;
		 
		Id  territoryId = TestDataFactory.getL7TerritoryId();
		List<User>userList = TestDataFactory.userCreation(2,'System Administrator');
		List<UserTerritory2Association>userAssociList = TestDataFactory.assigningUserToTerritory(1, userList[1], territoryId);
		TerrritoryILogUpdater tiLog = new TerrritoryILogUpdater();
		tiLog.failureId = interfaceLog.Id ;
		tiLog.insertLockedRecords = userAssociList ;
		//tiLog.deleteLockedRecords = deleteLockedRecords ;
		Test.startTest();
		 System.enqueueJob(tiLog);
		Test.stopTest();
	}
}