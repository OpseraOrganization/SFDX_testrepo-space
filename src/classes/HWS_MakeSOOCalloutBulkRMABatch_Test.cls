@isTest
public class HWS_MakeSOOCalloutBulkRMABatch_Test {
	@testSetup static void testDataSetup(){
		Id customerAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.Customer);
		Id legalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		Id assetRecordType = HWS_Utilty.getRecordTypeByName('Asset','HWS_Covered_Part');
		
		Account acc = HWS_DataFactory_TEST.insertAccount(); 
		acc.RecordTypeId =  customerAccountType;
		acc.Customer_Compliance__c = 'US_AT&T';
		insert acc;
		
		Account acc1 = HWS_DataFactory_TEST.insertAccount(); 
		acc1.RecordTypeId =  legalEntityAccountType;
		acc1.ParentId = acc.Id;
		acc1.Name = 'TestLE';
		insert acc1;
		
		Contact con = HWS_DataFactory_TEST.insertContact();
		con.AccountId = acc.Id;
		con.Contact_Status__c = 'Active';
		con.CH_ContactType__c = 'Customer';
		con.email='xyz@example.com';
		insert con;
				
		Product2 prod = HWS_DataFactory_TEST.insertproduct2();		
		insert prod;
		
		Id pricebookId = Test.getStandardPricebookId();
		PriceBookEntry pbe = HWS_DataFactory_TEST.createPriceBookEntry(prod.id, pricebookId);			 
		insert pbe;
		
		PriceBook2 pb = HWS_DataFactory_TEST.createPriceBook();			 
		insert pb;   
		
		PricebookEntry pbety = HWS_DataFactory_TEST.createPriceBookEntry(prod.id, pb.Id);		
		pbety.CurrencyIsoCode='EUR';	   
		insert pbety;  
		
		ServiceContract sc = HWS_DataFactory_TEST.insertServiceContract(acc1);		
		sc.Pricebook2Id = pb.Id;
		insert sc;
		
		ContractLineItem cli = HWS_DataFactory_TEST.insertContractLineItem(sc,pbety);		
		cli.PricebookEntryId = pbety.id;		
		insert cli;
		
		Asset ast = HWS_DataFactory_TEST.insertAsset(acc1,prod);		
		ast.RecordTypeId = assetRecordType;				
		insert ast; 
		
		hws_versionitem__c hwsv = HWS_DataFactory_TEST.insertHwsversionitem();
		hwsv.HWS_Serial_Number_Traceable__c='';		
		insert hwsv;
		
		Case parentCase = HWS_DataFactory_TEST.insertParentCase();
		parentCase.AccountId = acc1.id;
		insert parentCase;
	}
	
	public static testmethod void makeSOOCalloutBulkRMABatchTest(){
		Case parentCase = [Select id, CaseNumber from Case limit 1];
		List<String> casNumberList = new List<String>();
		casNumberList.add(parentCase.CaseNumber);
		HWS_MakeSOOCalloutBulkRMABatch bulkSOOCalloutBatch = new HWS_MakeSOOCalloutBulkRMABatch(casNumberList);
		Database.BatchableContext bc;
		Database.executeBatch(bulkSOOCalloutBatch,20);
	}
}