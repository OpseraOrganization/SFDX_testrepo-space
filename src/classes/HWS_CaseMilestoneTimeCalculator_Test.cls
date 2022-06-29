@isTest
public class HWS_CaseMilestoneTimeCalculator_Test {
	
	@testSetup static void testDataSetup(){
		
		Id parentCase = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_PARENT_CASE);
		
		Account customerAcc = new Account();
		Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		customerAcc.RecordTypeId = custRecordTypeId;
		customerAcc.Customer_Compliance__c = 'US_AT&T';
		customerAcc.P20_Logistic_ID__c = '1234';
		customerAcc.name='testCustomer';
		customerAcc.BillingCountry = 'India';
		customerAcc.BillingStreet = 'Test';
		customerAcc.BillingCity ='Test';
		customerAcc.BillingPostalCode = '1234';
		insert customerAcc;
		
		
		Account acc = HWS_DataFactory_TEST.insertAccount();
		acc.ParentID=customerAcc.id;
		insert acc;
		
		Account acc1 = HWS_DataFactory_TEST.createLogisticAccount();
		insert acc1;
		
		product2 prod = HWS_DataFactory_TEST.insertproduct2();
		prod.ProductCode = '3HQ14859AAAA';
		insert prod;
		
		Id pricebookId = Test.getStandardPricebookId();
		PriceBookEntry pbe = HWS_DataFactory_TEST.createPriceBookEntry(prod.id, pricebookId);			
		insert pbe;
		
		PriceBook2 pb = HWS_DataFactory_TEST.createPriceBook();	
		insert pb;   
		
		PricebookEntry pbety = HWS_DataFactory_TEST.createPriceBookEntry(prod.id, pb.Id);	
		pbety.CurrencyIsoCode='EUR';	
		insert pbety; 
		
		ServiceContract serCon = HWS_DataFactory_TEST.insertServiceContract(acc);
		serCon.Pricebook2Id = pb.Id;
		insert serCon;
		
		BusinessHours stdBusinessHours = [select id from BusinessHours where IsDefault=true];
		
		ContractLineItem cli = HWS_DataFactory_TEST.insertContractLineItem(serCon,pbety);	
		cli.PricebookEntryId = pbety.id;
		cli.CH_BusinessHour__c = stdBusinessHours.Id;
		insert cli;
		
		Asset ast = HWS_DataFactory_TEST.insertAsset(acc, prod);
		ast.HWS_ContractLeadTimeDuration__c = '5';
		ast.HWS_ContractLeadTimeUnit__c = 'Days';
		ast.HWS_ContractLineItem__c = Cli.Id;
		ast.RecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('HWS_Covered_Part').getRecordTypeId();
		insert ast;
		
		Asset ast1 = HWS_DataFactory_TEST.insertAsset(acc, prod);
		ast1.HWS_ContractLeadTimeDuration__c = '5';
		ast1.HWS_ContractLeadTimeUnit__c = 'Hours';
		ast1.HWS_ContractLineItem__c = Cli.Id;
		ast1.RecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('HWS_Covered_Part').getRecordTypeId();
		insert ast1;
		
		Case caserec = new Case();
		caserec.RecordTypeId =parentCase;
		caserec.AccountId = acc.Id;
		caserec.Status='Open';
		caserec.HWS_Faulty_Serial_Number__c= 'test1234';
		caserec.Hws_Ship_to_Party_Address__c = acc1.Id;
		insert caserec;
	}
	
	public static testmethod void calculateMilestoneTriggerTimeMethod(){
		
		Id exchangeInDays = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Advance_Exchange_In_Days);
		Id rfr = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_RETURN_FOR_REPAIR);
	
		Case caserec = [Select id from Case limit 1];
		Account acc = [Select id from Account WHERE Name='test' LIMIT 1];
		Asset ast = [Select id from Asset limit 1];
		Asset ast1 = [Select id from Asset limit 1];
		
		product2 prod = [Select id from product2 limit 1];
		ServiceContract serCon = [Select id from ServiceContract limit 1];
		
		Case childCs = new Case();
		childCs.AccountId = acc.Id;
		childCs.AssetId = ast.Id;
		childCs.RecordTypeId = exchangeInDays;
		childCs.NCP_Service_Contract__c = serCon.Id;
		childCs.HWS_ServiceType__c = 'Advanced Exchange in Days';
		childCs.HWS_Failure_Occurance__c = 'In normal use';
		childCs.HWS_Failure_Detection__c = 'Start reset loop';
		childCs.HWS_Failure_Description__c = 'Unit/module not recognized';
		childCs.HWS_Faulty_Serial_Number__c = 'Test124';
		childCs.HWS_Failure_Detection_Date__c = date.today();
		childCs.HWS_FaultyUnitReceivedDate__c = date.today();
		childCs.HWS_Sellable_Product__c = prod.Id;
		childCs.ParentId = caserec.Id;
		insert childCs;
		
		Case childCs2 = new Case();
		childCs2.AccountId = acc.Id;
		childCs2.AssetId = ast1.Id;
		childCs2.RecordTypeId = rfr;
		childCs2.NCP_Service_Contract__c = serCon.Id;
		childCs2.HWS_ServiceType__c = 'Identical Repair';
		childCs2.HWS_Failure_Occurance__c = 'In normal use';
		childCs2.HWS_Failure_Detection__c = 'Start reset loop';
		childCs2.HWS_Failure_Description__c = 'Unit/module not recognized';
		childCs2.HWS_Faulty_Serial_Number__c = 'Test124hgfh';
		childCs2.HWS_Failure_Detection_Date__c = date.today();
		childCs2.HWS_FaultyUnitReceivedDate__c = date.today();
		childCs2.HWS_Sellable_Product__c = prod.Id;
		childCs2.ParentId = caserec.Id;
		insert childCs2;
		
		test.startTest();
		HWS_CaseMilestoneTimeCalculator Calculator = new HWS_CaseMilestoneTimeCalculator();
		Integer actualTriggerTime = Calculator.calculateMilestoneTriggerTime(childCs.Id, null);
		Integer actualTriggerTime2 = Calculator.calculateMilestoneTriggerTime(childCs2.Id, null);
		system.assertNotEquals(childCs2, null);
		test.stopTest();
	}
}