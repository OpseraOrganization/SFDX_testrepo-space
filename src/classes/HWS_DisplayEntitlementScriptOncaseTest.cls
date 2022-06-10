@isTest
public class HWS_DisplayEntitlementScriptOncaseTest {
	@istest
	public static void gettestmethods(){
		
		product2 pr2 = new product2();
		Id rtId = Schema.SObjectType.product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Sales_Product').getRecordTypeId();
		pr2.RecordTypeId =rtId;
		pr2.Name ='test';
		pr2.IsActive = true;
		pr2.Description='test';
		insert pr2;
		
		// Create standard pricebook
	Id pricebookId = Test.getStandardPricebookId();
		
		PricebookEntry standardprice = new PricebookEntry();
		standardprice.CurrencyIsoCode='EUR';
		standardprice.IsActive=true;
		standardprice.Product2Id=pr2.id;
		standardprice.PriceBook2Id = pricebookId;
		standardprice.UnitPrice = 100;
		insert standardprice;
		
		 //create custom pricebook
		Pricebook2 custom = new Pricebook2();
		custom.Name = 'Nokia CARE Price Book';
		custom.IsActive = true;
		insert custom;
		
		PricebookEntry pbety = new PricebookEntry();
		pbety.CurrencyIsoCode='EUR';
		pbety.IsActive=true;
		pbety.Product2Id=pr2.id;
		pbety.PriceBook2Id = custom.Id;
		pbety.UnitPrice = 100;
		insert pbety;
	Id legalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		
		Account acc = HWS_DataFactory_TEST.insertAccount();
		acc.Customer_Compliance__c ='US_Govern';
		insert acc;
		
		Account acc2 = HWS_DataFactory_TEST.insertAccount(); 
		acc2.RecordTypeId =  legalEntityAccountType;
		acc2.ParentId = acc.Id;
		insert acc2;
		
		ServiceContract sContrct = new ServiceContract();
		sContrct.name='test';
		sContrct.PriceBook2Id= custom.Id;
		sContrct.AccountId= acc.Id;
		sContrct.CH_EntitlementScript__c='Testing';
		insert sContrct;
		
		ContractLineItem cli=new ContractLineItem();
		cli.UnitPrice=1.00;
		cli.Quantity=1.00;
		cli.ServiceContractId= sContrct.id;
		cli.CH_LineItemEntitlementScript__c = 'lakshman testing';
		cli.PricebookEntryId = pbety.Id;
		insert cli;
		
		
		Id accountRecordType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LOGISTIC_ACCOUNT_EXISTING);
		Id parentCaseRecordType = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_PARENT_CASE);
		Id customerAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.Customer);
		Account acc1 = new Account();
		acc1.Name = 'Testing RMANUMBER FIELD';
		acc1.ParentId = Acc.Id;
		acc1.Logistic_Account_Type__c = 'Bill-To';
		acc1.ngERP__c = '1';
		acc1.BillingCountry = 'India';
		acc1.BillingStreet = 'Gachibowli, Gachibowli';
		acc1.BillingCity = 'Hyderabad';
		acc1.BillingPostalCode = '500071';
		acc1.BillingState = 'TELANGANA';
		acc1.Market__c = 'Market India';
		acc1.RecordTypeId = accountRecordType;
		insert acc1;
		
		Asset ast = new Asset();
		Id assetRecordType = HWS_Utilty.getRecordTypeByName('Asset','HWS_Covered_Part');
		ast.RecordTypeId = assetRecordType;
		ast.Name = 'Test Asset';
		ast.AccountId = acc1.id;	
		insert ast;   
		Entitlement ent = new Entitlement();
		ent.Name = 'HWS Advance Exchange in Hours';
		ent.AccountId = acc1.id;
		ent.AssetId = ast.Id;
		ent.CH_CDB_EntitlementId__c = '1234';
		ent.CH_ServiceMappingId__c = 'Advanced Exchange in Hours';
		Case ca = new Case();
		ca.RecordTypeId = parentCaseRecordType;
		ca.AccountId = acc2.Id;
		ca.Hws_Ship_to_Party_Address__c= acc1.Id;
		ca.HWS_ShipTopartyId__c = 'True';
		ca.Status='Closed';
		ca.Subject='Test Subject';
		ca.Description='test Description';
		ca.HWS_Faulty_Serial_Number__c= 'test1234';
		ca.HWS_ShipTopartyId__c='1234566';
		ca.HWS_FaultyUnitReceivedDate__c = Date.newInstance(2019, 6, 9);
		ca.HWS_Contract_Line_Item__c = cli.Id;
		insert ca;
		
		Test.startTest();
		Map<String,String> scriptreturned = HWS_DisplayEntitlementScriptOncase.getEntitlementscript(ca.Id);
		system.assertEquals('lakshman testing', scriptreturned.get('ContractLineItemEntitlementScript'), 'No Contract line Entitlement script');
		Test.stopTest();
		
	}
}