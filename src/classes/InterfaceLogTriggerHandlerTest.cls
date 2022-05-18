@isTest
public class InterfaceLogTriggerHandlerTest {
	private static testMethod void test() {
  test.startTest();
	Test.setMock(HttpCalloutMock.class, new ProspectCreationMockResponse500Test());
	List<Account> accountList = new List<Account>{};
	Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	Id ProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();   
	accountList = TestDataFactory.createAccount(1);
	accountList[0].recordtypeid = ProspectRecordTypeId;   
	accountList[0].AccountNumber = '30191217';
	accountList[0].Website = 'testaudfhieuqrqgrrwkgvfrufgwejgfwekfgwufehwdfjkgwekjfgiuwefgweiugfuweigfwjekfgwkeufgwekfgwkejfgekwfjegfwkefgweuifgwefdewewfsdfdfdfgd.com';
	accountList[0].BillingPostalCode='12345678959';
	Insert accountList[0];
	Account acc=[Select Id,Name from Account where Id=:accountList[0].Id Limit 1];
	Interface_Log__c interfaceLog = New Interface_Log__c();
		interfaceLog.Name = GlobalConstants.ACCOUNT_NUMBER +acc.Name+GlobalConstants.HASH_SYMBOL+acc.Id;
		/***************************************************************/
		interfaceLog.Message_Type__c = GlobalConstants.OUTBOUND;
		interfaceLog.Operation_type__c = GlobalConstants.INSERT_VALUE; 
		interfaceLog.Interface_Request_Sent__c = 'Test';
		interfaceLog.Interface_Type__c = GlobalConstants.PROSPECT_CREATION_INTERFACE;
		interfaceLog.Status__c='Failure'; 
		insert interfaceLog;
	  List<Interface_Log__c> iLogList=[Select id,resend__c from Interface_Log__c];
		if(iLogList.size()>0){
			System.debug('====>iLogList'+ iLogList);
	  iLogList[0].resend__c=true;
			update iLogList[0];
		}else{
			System.debug('====>Did not find any');
		}
		
	}
}