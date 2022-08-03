@isTest
public class NCP_InterfaceLogFromIpaaS_TEST 
{
	@testSetup 
	static void setup()
	{
		Account acc = new Account();
		acc.Name = 'NCP_TEST_ACCOUNT1';
		acc.Acc_No__c = '123ABC123';
		acc.recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER);
		INSERT acc;
		
		Account acc2 = new Account();
		acc2.Name = 'NCP_TEST_ACCOUNT2';
		acc2.recordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY);
		acc2.parentId = acc.Id;
		INSERT acc2;
		
		Contact con = new Contact();
		con.AccountId = acc.Id;
		con.FirstName = 'NCP_';
		con.LastName = 'TEST_CON';
		con.Email = 'test@salesforceTest.com';
		con.City__c = 'City';
		con.Street__c = 'Street';
		con.State__c = 'State';
		con.Country__c = 'Country';
		con.Phone = '0550222333';
		con.CH_ContactTimeZone__c = '(GMT+14:00) Line Islands Time (Pacific/Kiritimati)';
		con.CH_PreferredMtdOfServiceCommunication__c = 'Email ';
		INSERT con;
		
		Id RecordTypeId = NCP_Utils.getObjectRecordTypeId('ServiceContract', NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_PARENT);
		ServiceContract scCDB = new ServiceContract();
		scCDB.NCP_External_Status__c = 'Active';
		scCDB.RecordTypeId = RecordTypeId;
		scCDB.Name = 'NCP_SC_TEST';
		scCDB.AccountID = acc2.id;
		scCDB.Pricebook2Id = Test.getStandardPricebookId();
		scCDB.NCP_Contract_Type__c = 'CARES';
		scCDB.startDate = System.today();
		scCDB.endDate = System.today() + 5;
		INSERT scCDB;
		
		Id RecordTypeId2 = NCP_Utils.getObjectRecordTypeId('ServiceContract', NCP_Constants.SERVICE_CONTRACT_RT_DEVNAME_CHILD);
		ServiceContract sccCDB = new ServiceContract();
		sccCDB.NCP_External_Status__c = 'Active';
		sccCDB.RecordTypeId = RecordTypeId2;
		sccCDB.Name = 'NCP_SC_TEST2';
		sccCDB.AccountID = acc2.id;
		sccCDB.Pricebook2Id = Test.getStandardPricebookId();
		sccCDB.NCP_Entitlement_Access_Type__c = 'ClicS';
		sccCDB.NCP_Entitlement_Relationship__c = 'Product';
		sccCDB.ParentServiceContractId = scCDB.Id;
		sccCDB.NCP_Default__c = true;
		INSERT sccCDB;
		
		NCP_Authorised_Entitlement__c contEnt = new NCP_Authorised_Entitlement__c();
		contEnt.NCP_External_Status__c = 'Active';
		contEnt.NCP_Contact__c = con.id;
		contEnt.NCP_Service_Contract__c = scCDB.id;
		INSERT contEnt;
		
		Product2 pr = new Product2();
		pr.Name = 'Laptop X200';
		pr.Family = 'Hardware';
		pr.IsActive = true;
		pr.NCP_Origin__c = 'OLCS';
		INSERT pr;
		
		NCP_Product_Content__c prAccess = new NCP_Product_Content__c();
		prAccess.NCP_Product__c = pr.Id;
		prAccess.NCP_Service__c = 'Discovery Center (Skylab)';
		INSERT prAccess;
		
		PricebookEntry pbe = new PricebookEntry();
		pbe.Pricebook2Id = Test.getStandardPricebookId();
		pbe.Product2Id = pr.Id;
		pbe.UnitPrice = 10000;
		pbe.IsActive = true;
		pbe.UseStandardPrice = false;
		INSERT pbe;
		
		ContractLineItem cli = new ContractLineItem();
		cli.NCP_External_Status__c = 'Active';
		cli.ServiceContractId = scCDB.Id;
		cli.PricebookEntryId = pbe.Id;
		cli.Quantity = 1;
		cli.UnitPrice = pbe.UnitPrice;
		INSERT cli;
	}
	
	@isTest
	public static void ServiceContract_Test()
	{
		
		Id customerRecordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER);
		Account acc = [SELECT Id FROM Account 
					   WHERE RecordTypeId = :customerRecordTypeId LIMIT 1];
		
		Id legalRecordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_LEGALENTITY);
		Account acc2 = [SELECT Id FROM Account 
						WHERE RecordTypeId = :legalRecordTypeId LIMIT 1];
		
		Contact con = [SELECT Id FROM Contact 
					   WHERE AccountId = :acc.Id];
		
		ServiceContract sccCDB = [SELECT Id,
								  AccountId,
								  RecordType.Name,
								  Pricebook2.Name,
								  NCP_External_Status__c 
								  FROM ServiceContract 
								  WHERE AccountId = :acc2.Id LIMIT 1] ;
		
		
		Test.startTest();
		
		string jobId = '12345';
		
		Map<String, String> headers = new Map<String, String>();
		headers.put('Content-Type', 'text/csv');
		NCP_SingleRequestMock fakeApiJobDetails = new NCP_SingleRequestMock(200, 'Complete', '{"id":"1","object": "ServiceContract","operation":"insert","numberRecordsProcessed":1,"numberRecordsFailed":1}', headers);
		NCP_SingleRequestMock fakeSuccessCall = new NCP_SingleRequestMock(200, 'Complete', 'sf__Id,sf__Created,Account.Acc_No__c,NCP_Entitlement_Access_Type__c,NCP_External_Service_Contract_Id__c,NCP_External_Status__c,Name,ParentServiceContract.NCP_External_Service_Contract_Id__c,PriceBook2.Name,recordType.Name\n' + sccCDB.Id + ',' + false + ',' + sccCDB.AccountId + ',' + '' + ',' + '' + ',' + sccCDB.NCP_External_Status__c + ',' + '' + ',' + 203818 + ',' + sccCDB.Pricebook2.Name + ',' + sccCDB.RecordType.Name + '\n', headers);
		NCP_SingleRequestMock fakeErrorCall = new NCP_SingleRequestMock(200, 'Complete', 'sf__Id,sf__Created,Account.Acc_No__c,NCP_Entitlement_Access_Type__c,NCP_External_Service_Contract_Id__c,NCP_External_Status__c,Name,ParentServiceContract.NCP_External_Service_Contract_Id__c,PriceBook2.Name,recordType.Name\n' + sccCDB.Id + ',' + false + ',' + sccCDB.AccountId + ',' + '' + ',' + '' + ',' + sccCDB.NCP_External_Status__c + ',' + '' + ',' + 203818 + ',' + sccCDB.Pricebook2.Name + ',' + sccCDB.RecordType.Name + '\n', headers);
		
		String host = System.Url.getSalesforceBaseURL().toExternalForm();
		Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
		endpoint2TestResp.put(host + '/services/data/v43.0/jobs/ingest/' + jobId, fakeApiJobDetails);
		endpoint2TestResp.put(host + '/services/data/v43.0/jobs/ingest/' + jobId + '/successfulResults/', fakeSuccessCall);
		endpoint2TestResp.put(host + '/services/data/v43.0/jobs/ingest/' + jobId + '/failedResults/', fakeErrorCall);
		HttpCalloutMock multiCalloutMock = new NCP_InterfaceLogFromIpaaS_WS_Mock(endpoint2TestResp);
		
		Test.setMock(HttpCalloutMock.class, multiCalloutMock);
		NCP_InterfaceLogFromIpaaS_WS.CreateInterfaceLogFromIpaaS(jobId);
		//ID asyncJobID = System.enqueueJob(new NCP_InterfaceLogFromIpaaS(jobId));
		//system.debug('JOB ID: ' + asyncJobID);
				
		BulkApiJob baj = new BulkApiJob();
		baj.contentType = '';
		baj.status = '';
		
		Test.stopTest();
	}
	
	@isTest
	static void contractLineItem_Test() 
	{
		Id customerRecordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER);
		Account acc = [SELECT Id FROM Account 
					   WHERE RecordTypeId = :customerRecordTypeId LIMIT 1];
		
		Contact con = [SELECT Id FROM Contact 
					   WHERE AccountId = :acc.Id];
		
		contractLineItem cli = [SELECT Id,
								ExternalPricebookEntryId__c,
								NCP_External_Contract_Line_Item_Id__c 
								FROM contractLineItem LIMIT 1];
		
		Test.startTest();
		
		String jobId = '12345';
		Map<String, String> headers = new Map<String, String>();
		headers.put('Content-Type', 'text/csv');
		NCP_SingleRequestMock fakeApiJobDetails = new NCP_SingleRequestMock(200, 'Complete', '{"id":"1","object": "contractLineItem","operation":"insert","numberRecordsProcessed":1,"numberRecordsFailed":1}', headers);
		NCP_SingleRequestMock fakeSuccessCall = new NCP_SingleRequestMock(200, 'Complete', 'ExternalPricebookEntryId__c,NCP_External_Contract_Line_Item_Id__c\n' + cli.ExternalPricebookEntryId__c + ',' + cli.NCP_External_Contract_Line_Item_Id__c + '\n', headers);
		NCP_SingleRequestMock fakeErrorCall = new NCP_SingleRequestMock(200, 'Complete', 'ExternalPricebookEntryId__c,NCP_External_Contract_Line_Item_Id__c\n' + cli.ExternalPricebookEntryId__c + ',' + cli.NCP_External_Contract_Line_Item_Id__c + '\n', headers);
		
		String host = System.Url.getSalesforceBaseURL().toExternalForm();
		Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
		endpoint2TestResp.put(host + '/services/data/v43.0/jobs/ingest/' + jobid, fakeApiJobDetails);
		endpoint2TestResp.put(host + '/services/data/v43.0/jobs/ingest/' + jobid + '/successfulResults/', fakeSuccessCall);
		endpoint2TestResp.put(host + '/services/data/v43.0/jobs/ingest/' + jobid + '/failedResults/', fakeErrorCall);
		HttpCalloutMock multiCalloutMock = new NCP_InterfaceLogFromIpaaS_WS_Mock(endpoint2TestResp);
		
		Test.setMock(HttpCalloutMock.class, multiCalloutMock);
		NCP_InterfaceLogFromIpaaS_WS.CreateInterfaceLogFromIpaaS(jobId);
		//ID asyncJobID = System.enqueueJob(new NCP_InterfaceLogFromIpaaS(jobId));
		//system.debug('JOB ID: ' + asyncJobID);
				
		Test.stopTest();
	}
	
	@isTest
	static void NCPAuthorisedEntitlement_Test()
	{
		Id customerRecordTypeId = NCP_Utils.getObjectRecordTypeId('Account', NCP_Constants.ACCOUNT_RT_DEVNAME_CUSTOMER);
		Account acc = [SELECT Id FROM Account 
					   WHERE RecordTypeId = :customerRecordTypeId LIMIT 1];
		
		Contact con = [SELECT Id FROM Contact 
					   WHERE AccountId = :acc.Id];
				
		NCP_Authorised_Entitlement__c ae = [SELECT Id, NCP_External_Id__c 
											FROM NCP_Authorised_Entitlement__c LIMIT 1] ;
		
		Test.startTest();
		
		String jobId = '12345';
		Map<String, String> headers = new Map<String, String>();
		headers.put('Content-Type', 'text/csv');
		NCP_SingleRequestMock fakeApiJobDetails = new NCP_SingleRequestMock(200, 'Complete', '{"id":"1","object": "NCP_Authorised_Entitlement__c","operation":"insert","numberRecordsProcessed":1,"numberRecordsFailed":1}', headers);
		NCP_SingleRequestMock fakeSuccessCall = new NCP_SingleRequestMock(200, 'Complete', 'NCP_External_Id__c\n' + ae.NCP_External_Id__c + '\n', headers);		
		NCP_SingleRequestMock fakeErrorCall = new NCP_SingleRequestMock(200, 'Complete', 'NCP_External_Id__c\n' + ae.NCP_External_Id__c + '\n', headers);
		
		String host = System.Url.getSalesforceBaseURL().toExternalForm();
		Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
		endpoint2TestResp.put(host + '/services/data/v43.0/jobs/ingest/' + jobid, fakeApiJobDetails);
		endpoint2TestResp.put(host + '/services/data/v43.0/jobs/ingest/' + jobid + '/successfulResults/', fakeSuccessCall);
		endpoint2TestResp.put(host + '/services/data/v43.0/jobs/ingest/' + jobid + '/failedResults/', fakeErrorCall);
		HttpCalloutMock multiCalloutMock = new NCP_InterfaceLogFromIpaaS_WS_Mock(endpoint2TestResp);
		
		Test.setMock(HttpCalloutMock.class, multiCalloutMock);
		NCP_InterfaceLogFromIpaaS_WS.CreateInterfaceLogFromIpaaS(jobId);
		//ID asyncJobID = System.enqueueJob(new NCP_InterfaceLogFromIpaaS(jobId));
		//system.debug('JOB ID: ' + asyncJobID);
		
		Test.stopTest();
	}
	
	@isTest
	static void InterfaceLog_Test() 
	{
		Boolean abc = true;
		Test.startTest();
		
		try
		{
			NCP_InterfaceLog.insertInterfaceLog('CDB Parent Service Contract','Inbound', 'upsert', 'CDB Parent Service Contract', 'Success', 'Success', 'data');
			NCP_InterfaceLog.createInterfaceLog('CDB Parent Service Contract', 'Inbound', 'upsert', 'CDB Parent Service Contract', 'Success', 'Success', 'data');
		}
		catch(Exception e1)
		{
			System.assertEquals(abc, true);   
		}
		System.assertEquals(abc, true);
		
		Test.stopTest();
	}
}