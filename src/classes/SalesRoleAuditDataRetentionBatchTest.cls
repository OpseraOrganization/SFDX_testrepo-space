@isTest
private class SalesRoleAuditDataRetentionBatchTest {
	
	static testmethod void test() { 
		
		//system.test.startTest();
		Test.setMock(WebServiceMock.class, new SalesRoleAuditDataRetentionBatchMock()); 
		insert new Data_Retention_for_SRT__c(No_of_Days__c = '1',Name='First');
		Sales_Role_Audit__c insertrecord = new Sales_Role_Audit__c(Organisation__c='CO Deactivated Accounts', Operation_Type__c='Insert',Role_Name__c='5 - BG Care Cluster Head',Role_Code__c='NSND_BGSCH',Is_Processed__c=true,Hierarchy_Id__c='500135', Role_Owner_ID__c='69105772');	
		insert insertrecord ;		
		date d = date.today()-2;
		test.setCreatedDate(insertrecord.Id,d);	
		system.test.startTest();		  
		SalesRoleAuditDataRetentionBatch uca = new SalesRoleAuditDataRetentionBatch();		
		Id batchId = Database.executeBatch(uca);	  
		system.test.stopTest();	
	}
	
}