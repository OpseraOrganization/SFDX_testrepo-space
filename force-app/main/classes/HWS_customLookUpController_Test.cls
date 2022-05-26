@isTest
public class HWS_customLookUpController_Test{

	public testmethod static void getCountryListMethod(){
		Id legalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		Id customerAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.CUSTOMER);
		Id logisticEntity_Existing = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LOGISTIC_ACCOUNT_EXISTING);
		list<Account> accList= new  list<Account>();
		System.assertEquals(legalEntityAccountType,legalEntityAccountType);
		System.assertEquals(logisticEntity_Existing,logisticEntity_Existing);
		Account custAcc = HWS_DataFactory_TEST.insertAccount(); 
		custAcc.RecordTypeId =  customerAccountType;
		custAcc.Customer_Compliance__c = 'US_AT&T';
		insert custAcc;		
		
		Account acc = HWS_DataFactory_TEST.insertAccount();
		acc.ParentId = custAcc.Id;
		acc.Country__c='Canada';
		insert acc;
		
		
		accList.add(acc);	
		
		Contact con = HWS_DataFactory_TEST.insertContact();
		con.AccountId = custAcc.Id;
		con.Contact_Status__c = 'Active';
		con.CH_ContactType__c = 'Customer';
		con.email='xyz@example.com';
		insert con;
		
		Product2 prod = HWS_DataFactory_TEST.insertproduct2();		
		insert prod;
		
		PriceBookEntry tempPriceBookEntry = new PriceBookEntry(
			Pricebook2Id = Test.getStandardPricebookId(),
			Product2Id = prod.id,
			UnitPrice = 0,
			CurrencyIsoCode = 'EUR',
			IsActive = true
		);
		Insert tempPriceBookEntry;
		
		ServiceContract sc = HWS_DataFactory_TEST.insertServiceContract(acc);		
		sc.Pricebook2Id = Test.getStandardPricebookId();
		sc.CurrencyIsoCode = tempPriceBookEntry.CurrencyIsoCode;
		sc.CH_ERPSystem__c = 'SAP-Blue Planet';
		insert sc;
		
		ContractLineItem cli = HWS_DataFactory_TEST.createContractLineItems(sc.Id,tempPriceBookEntry.Id);		
		insert cli;
		
		Id assetRecordType = HWS_Utilty.getRecordTypeByName('Asset','HWS_Covered_Part');
		List<Asset> lstasst = new List<Asset>();
		
		Asset ast = HWS_DataFactory_TEST.insertAsset(acc,prod);		
		ast.RecordTypeId = assetRecordType;   
		ast.HWS_ContractLineItem__c = cli.id;  
		lstasst.add(ast);
		insert lstasst;
		System.debug('lstasst:'+lstasst[0].HWS_ContractLineItem__r.ServiceContractId);
		system.assertequals(accList.size(),1);
		List<ContractLineItem> cliList = new List<ContractLineItem>();
		cliList.add(cli);
		
		HWS_RetrofitAccount__c retroacc = new HWS_RetrofitAccount__c(
			HWS_Account__c = acc.id,
			HWS_ServiceContract__c = sc.id,
			HWS_ShipToCountry__c = 'Canada',
			HWS_Status__c = 'Active'
		);
		Insert retroacc;
		// List<sObject> sobjList = Database.query('SELECT Id, HWS_Account__c, HWS_ServiceContract__c, HWS_ShipToCountry__c FROM HWS_RetrofitAccount__c');
		Test.startTest();
		HWS_customLookUpController.getCountryList(retroacc.id);
		HWS_customLookUpController.fetchLookUpValues('Test','HWS_RetrofitAccount__c',cli.id);
		Test.stopTest();
	}
}