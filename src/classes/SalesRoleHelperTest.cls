@isTest
private class SalesRoleHelperTest {
	
	static testMethod void testCreateOpperationType()
	{
		List<user> userList = new List<User>();
		userList = TestDataFactory.userCreation(3, 'System Administrator');
		userList[1].NSA_Compliant__c=true;
		database.insert(userList);
		system.runAs(userList[0])
		{
			
			system.Test.setMock(WebServiceMock.class, new SalesRoleAuditDataRetentionBatchMock());		
			//List<Sales_Role__c> listOfSalesRoleToInsert = new List<Sales_Role__c>();
			Sales_Role__c salesRole = new Sales_Role__c();
			salesRole.Role_Code__c='NSNC_AM';
			salesRole.Role_Name__c='4 - CO Account Manager';		
			salesRole.BG__c='MN';
			salesRole.User__c=userList[1].id;
			salesRole.Process_SRT_Audit__c=true;
			salesRole.Approval_Type__c='A&S';
			//salesRole.External_ID__c='a2S41001541Lv0JEjf';
			salesRole.Organisation__c='Market Europe';			 
			//listOfSalesRoleToInsert.add(salesRole);z
			
			
			test.startTest();
			insert salesRole;
			salesRole.Process_SRT_Audit__c=true;
			salesRole.User__c=userList[2].id;
			update salesRole;
			salesRole.Process_SRT_Audit__c=false;
			salesRole.User__c=userList[1].id;
			update salesRole;
			
			List<Sales_Role__c> salesRoleList = new List<Sales_Role__c>();
			salesRoleList.add(salesRole);
			List<Sales_Role__c> salesRoleListNew = new List<Sales_Role__c>();
			Sales_Role__c salesRoleNew = salesRole.clone(true,true,true,true);
			salesRoleNew.Process_SRT_Audit__c=true;
			salesRoleNew.User__c = userList[2].id;
			salesRoleListNew.add(salesRoleNew);
			
			SalesRoleHelper.createSalesHisoryRecord(salesRoleList); 
			SalesRoleHelper.deleteSalesHisoryRecord(salesRoleList);
			Salesrolehelper.modifySalesHisoryRecord(salesRoleList, createMap(salesRoleListNew));
			Salesrolehelper.modifySalesHisoryRecord(salesRoleListNew, createMap(salesRoleList));
			delete salesRole;
			test.stopTest();	
		}
	}
	
	private static Map<Id, Sales_Role__c> createMap(List<Sales_Role__c> salesRoleList)
	{
		Map<Id, Sales_Role__c> salesRoleMap = new Map<Id, Sales_Role__c>();
		for(Sales_role__c salesRole : salesRoleList)
		{
			salesRoleMap.put(salesRole.Id, salesRole);
		}
		return salesRoleMap;
	}
}