@isTest
public class CMDPack4CalloutTest{
	@testSetup static void setSRTAudit() {
		Sales_Role_Audit__c insertrecord = new Sales_Role_Audit__c(Organisation__c='CO Deactivated Accounts', Operation_Type__c='Insert',Role_Name__c='5 - BG Care Cluster Head',Role_Code__c='NSND_BGSCH',Is_Processed__c=false,Hierarchy_Id__c='500135',Role_Owner_ID__c='69105772');	
		insertrecord.Role_Start_Date__c = date.today();
		insertrecord.BG__c = 'NSW';
		insertrecord.Operation_Type__c = 'Insert';
		insert insertrecord ;	  
	}
	static testmethod void test1() {
		// startTest/stopTest block to force async processes 
		//   to run in the test.
		Test.setMock(HttpCalloutMock.class, new IpaasAuthenticationHandlerTest());
		Test.setMock(WebServiceMock.class, new SalesRoleAuditDataRetentionBatchMock());	  
		Test.startTest();
		System.enqueueJob(new CMDPack4Callout());   
		Test.stopTest();
		
	}
	
	static testmethod void test2() {
		Test.setMock(HttpCalloutMock.class, new IpaasAuthenticationHandlerTest());
		// Test.setMock(HttpCalloutMock.class, new CustomCMDPack4CalloutTest());
		Test.startTest();
		CMDPack4__mdt cmd = [select Client_Id__c,Client_Secret__c,Login_Endpoint__c,Request_Endpoint__c,Grant_Type__c,Method_Type__c,Login_Content_type__c,Content_type__c
							 from CMDPack4__mdt where DeveloperName =: 'CMDPack4'];
		system.debug(cmd);
		string accesstoken = IpaasAuthenticationHandler.authenticate(cmd);
		CMDPack4Callout.customCallout(accesstoken ,cmd);		
		Test.stopTest();
	}
}