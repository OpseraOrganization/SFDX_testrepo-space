/**
 * Created by tweinberger on 2019-05-07.
 */
@isTest
public with sharing class NCP_ExistingContactTrigger_Test {

	@isTest static void TestCaseCreation() {
		Test.startTest();

		List<Lead> newLeadList = TestDataFactory.createLead(1);
		newLeadList[0].country = 'Argentina';
		insert newLeadList;

		Id recTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SF Support').getRecordTypeId();
		NCP_ExistingContact__e event = new NCP_ExistingContact__e(
				Lead_ID__c = newLeadList[0].Id,
				Reported_User_ID__c = UserInfo.getUserId(),
				Lead_Email__c = newLeadList[0].Email,
				Record_Type_ID__c = recTypeId+'',
				Full_Name__c = newLeadList[0].firstname +' '+newLeadList[0].lastname);
		Database.SaveResult sr = EventBus.publish(event);
		// Deliver the initial event message.
		// This will fire the associated event trigger.
		Test.getEventBus().deliver();

		// Trigger retries event twice, so loop twice
		for(Integer i=0;i<2;i++) {
			// Get info about all subscribers to the event
			EventBusSubscriber[] subscribers =
			[SELECT Name, Type, Position, Retries, LastError
			FROM EventBusSubscriber WHERE Topic='NCP_ExistingContact__e'];

			for (EventBusSubscriber sub : subscribers) {
				System.debug('sub.Retries=' + sub.Retries);
				System.debug('sub.lastError=' + sub.lastError);
				if (sub.Name == 'OrderTriggerRetry') {
					System.assertEquals(i+1, sub.Retries);
				}
			}
			// Deliver the retried event
			Test.getEventBus().deliver();
		}
		Test.stopTest();
	}
}