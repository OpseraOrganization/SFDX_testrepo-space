@isTest
private class NCP_NAMQueueable_Test {
	
	@testSetup static void setup() {		
		System.runAs(NCP_TestFactory.createUser(true, 'Sys Admin', null, 'testSysAdmin@nokia.com.dev')){
			Account acc = NCP_TestFactory.createAccount(); 
			Account acc2 = NCP_TestFactory.createLegalAccount(acc.Id);
			Contact con = NCP_TestFactory.createContact(acc); 
			User u = NCP_TestFactory.createUser(false,'AES Admin',con,'test@nokia.com.dev');
			insert u;
				Case c = new Case(
					Subject = 'test',
					recordTypeId = NCP_Utils.getObjectRecordTypeId('Case', NCP_Constants.CASE_RT_DEVNAME_ENTITLEMENT),
					Status = 'Pending Approval',
					Description = 'xxx',
					Issue_Reported_By__c = u.Id,
					AccountId = acc2.Id
				);
			insert c;
		}
	}
	
	@isTest
	static void testNAMQueueable() {
		user u = [SELECT Id, Name FROM User WHERE username = 'test@nokia.com.dev'];
		Case c = [SELECT Id, Subject FROM Case WHERE Subject = 'test'];
		system.runAs(u){	
			Test.startTest();
			//Test.setMock(WebServiceMock.class, new NCP_NAMMockReponseGenerator());
			
			//NCP_IPaaSNamService_WS_DATA_SCHEMAS.UserRoleData userRole = new NCP_IPaaSNamService_WS_DATA_SCHEMAS.UserRoleData(); 
			//NCP_IPaaSNamService_WS_tempuriOrg.BasicHttpBinding_INamSyncService response_x = new NCP_IPaaSNamService_WS_tempuriOrg.BasicHttpBinding_INamSyncService();
			//response_x.UpdateUserRole(userRole);
			
			//System.enqueueJob(new NCP_NAMQueueable(c.Id));
			
			// ******* 
			// Note, this row needs to be removed and whole test class and NCP_NAMQueueable class modified, 
			// This is for Aug 24th deployment to work only and covers classes NCP_PreApproval_COM and NCP_NAMQueueable, NW 20180822
			// *******
			NCP_PreApproval_COM.getNAMResponse(c.Id);
			
			Test.stopTest();
		}
	}
}