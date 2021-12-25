@isTest
private class NCP_ActAs_COM_Test {
	
	@testSetup static void setup() {
		System.runAs(NCP_TestFactory.createUser(true, 'Sys Admin', null, 'testSysAdmin@nokia.com.dev')) {
			NCP_CustomerCommunitySetting__c setting = NCP_TestFactory.insertCustomSetting();
			setting.Act_As_Customer_Permission_Set__c='NCP_Act_As_Customer';
			upsert setting;
			Account acc = NCP_TestFactory.create301Account();
			Account acc2 = NCP_TestFactory.createLegalAccount(acc.Id);
			Contact cont = NCP_TestFactory.createContact(acc);
		}
	}
	@isTest
	static void testContactDetailsUrlParams(){
		Contact cont = [Select Id, AccountId from contact limit 1];
		User myUser = NCP_TestFactory.createUser(true, 'AES Admin', cont, 'test@nokia.com.dev');
		//System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) { 
		system.runAs(myUser){   
			Test.startTest();
			String params = '';
			params = NCP_ActAs_COM.setPortalSSOSession(cont.Id);
			System.assertNotEquals('',params);
			Test.stopTest();
		}
	}
	
	@isTest
	static void testUserDetailsUrlParams(){
		User myUser = NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev');
		NCP_ActAs_COM ctrl = new NCP_ActAs_COM(new ApexPages.StandardController(myUser));
		system.runAs(myUser){   
			Test.startTest();
			pagereference pageref = ctrl.redirectToIAM();
			//System.assertNotEquals(null,pageref);
			Test.stopTest();
		}
	}

	@isTest
	static void testRedirectBackToSalesforce(){
		User myUser;
		Profile p ;
		p = [select Id,name from Profile where Name ='Customers' limit 1];
		System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {	   
			myUser = NCP_TestFactory.createUser(false, 'test', [Select Id, Name from contact], 'test1@nokian.com.dev');
			myUser.profileId = p.id;
			insert myUser;
		}
		NCP_ActAs_COM ctrl = new NCP_ActAs_COM(new ApexPages.StandardController(myUser));
		system.runAs(myUser){   
			Test.startTest();
			pagereference pageRef = Page.ActAsUser;
			pageRef.getParameters().put('MyAccountId',''+[Select Id from Account where Name ='301'].id);
			pageRef.getParameters().put('CustomerAccountId','');
			pageRef.getParameters().put('setupId','');
			pageRef.getParameters().put('userId',''+myUser.Id);
			pageRef.getParameters().put('oid','4567890');
			pageRef.getParameters().put('sunetworkid','123445455545678909876');
			pageRef.getParameters().put('sunetworkuserid',''+myUser.Id);
			Test.setCurrentPage(pageRef);  
			pagereference ref = ctrl.redirectBackToSalesforce();
			//System.assertNotEquals(null,pageref);
			Test.stopTest();
		}
	}

	 @isTest
	static void testSetPortalSSOSessionTemp(){
		User myUser = NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev');
		system.runAs(myUser){   
			Test.startTest();
			String s = NCP_ActAs_COM.setPortalSSOSessionTemp([Select Id from Contact].id);
			//System.assertNotEquals(null,pageref);
			Test.stopTest();
		}
	}
	 @isTest
	static void testSetPortalSSOSessionTempUser(){
		User myUser = NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev');
		system.runAs(myUser){   
			Test.startTest();
			String s = NCP_ActAs_COM.setPortalSSOSessionTemp(myUser.id);
			//System.assertNotEquals(null,pageref);
			Test.stopTest();
		}
	}
	
}