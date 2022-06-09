@isTest
public class DSProductNotificationEventTest  {
	Public testmethod  static void TestProcuctNotificationEventTest(){
		Test.startTest();
			List<DS_Products_Notification__e > prodNotificationEventList = new List<DS_Products_Notification__e>();
			DS_Products_Notification__e objNotEvent = new DS_Products_Notification__e();
			objNotEvent.Productcode__c = 'NCP-0091';
			objNotEvent.SoldToParty__c= '101111';
			prodNotificationEventList.add(objNotEvent);
			List<Database.SaveResult> results = EventBus.publish(prodNotificationEventList);
			List<Interface_Log__c> lstInterfaceLog = [select id from Interface_Log__c];
		   // System.assertEquals(lstInterfaceLog.size(), 1);
		Test.stopTest();
		
	}
	
	Public testmethod  static void TestProcuctNotificationWithSoldToPartyTest(){
		Test.startTest();
			List<DS_Products_Notification__e > prodNotificationEventList = new List<DS_Products_Notification__e>();
			Account accLegalEntity = TestDataFactory.createAccount(1)[0];
			accLegalEntity.AccountNumber='100006843';
			accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			database.insert(accLegalEntity);
			
			DS_Products_Notification__e objNotEvent = new DS_Products_Notification__e();
			objNotEvent.Productcode__c = 'NCP-0091';
			objNotEvent.SoldToParty__c= accLegalEntity.AccountNumber;
			prodNotificationEventList.add(objNotEvent);
			List<Database.SaveResult> results = EventBus.publish(prodNotificationEventList);
		
		Test.stopTest();
	}
}