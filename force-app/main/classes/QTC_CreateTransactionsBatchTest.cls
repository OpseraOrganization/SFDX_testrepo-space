/*********************************
  * Param:test class for  QTC_CreateTransactionsBatch
  * Return: NA  
  * Description:
	**********************************/
@isTest(SeeAllData=false)
public class QTC_CreateTransactionsBatchTest {
	Public String uid= UserInfo.getUserId();
	Public String Name='Test Surinder Quote';
	Public String OppId;
	Public String recordType  = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId();  
	Public String Portfolio = 'IP Routing';
	Public String Description = 'Test Shashi Description';
	Public Boolean quoteQWM = True;  
	 static testMethod void createTxnRecord(){   
			  
		//Create a Customer Account 
		Account acc=new Account();
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		acc.name='Test Account';
		acc.AccountNumber ='101234569';
		acc.Acc_No__c ='101234569';
		acc.CurrencyIsoCode ='USD';
		acc.Active__c=true;
		acc.AccountStatusInCRMOM__c = 'Active';
		acc.GEOLevel1ID__c ='RG_NAM';
		acc.AccountLifecycleStatus__c='Opportunity';
		insert acc;		
		String xmlbody = '<?xml version="1.0" encoding="utf-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:mat="http://soap.sforce.com/schemas/class/NCP_InterfaceLogFromIpaaS_WS">';
		xmlbody += '<soapenv:Body><mat:CreateInterfaceLogFromIpaaS>';
		xmlbody += '<mat:jobId>7077c00001hZVxKAAW</mat:jobId>';
		xmlbody += '</mat:CreateInterfaceLogFromIpaaS>';
		xmlbody += '</soapenv:Body></soapenv:Envelope>';
		Set<String> setIds= new Set<String>();
		//Create Quote staging Record:
		List<Quote_Staging__c> quote_staging_Rec = new List<Quote_Staging__c>();	
		Quote_Staging__c qtstg = new Quote_Staging__c();
	   
		qtstg.QTEID__c ='1912345';
		qtstg.Type__c='Header';
		qtstg.Quote_Number__c = '19.US.876785 Q 1';
		qtstg.PARTNRID__c = '1234567';
		quote_staging_Rec.add(qtstg); 
		Quote_Staging__c qtstg1 = new Quote_Staging__c();
		
		qtstg1.QTEID__c ='1912345';
		qtstg1.Type__c='LINE ITEM';
		qtstg1.Quote_Number__c = '19.US.876785 Q 1';
		qtstg1.PARTNRID__c = '1234567';
		quote_staging_Rec.add(qtstg1);   
		Database.INSERT(quote_staging_Rec);
		for(Quote_Staging__c obj:quote_staging_Rec){
			setIds.add(obj.Quote_Number__c);
		}
		test.startTest();
		QTC_CreateTransactionsBatch obj= new QTC_CreateTransactionsBatch(setIds);
		Database.executebatch(obj,10);   
		test.stoptest();	 
		
	}  
	
}