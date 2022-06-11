/********************************************************************************
* Name : HWS_RetrofitAccountTrigger_Test
* Author : deeksha.1.gupta@nokia.com
* Description : Test class for HWS_RetrofitAccountTrigger,HWS_RetrofitAccountHandler,
HWS_RetrofitAccountHelper 
********************************************************************************/

@isTest
public class HWS_RetrofitAccountTrigger_Test {
	@testSetup
	public static void createTestData(){
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
		acc.Country__c = 'India';
	  	
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

		List<ContractLineItem> cliList = new List<ContractLineItem>();
		cliList.add(cli);
		
		HWS_RetrofitAccount__c retroacc = new HWS_RetrofitAccount__c(
			HWS_Account__c = acc.id,
			HWS_ServiceContract__c = sc.id,
			HWS_ShipToCountry__c = 'Canada',
			HWS_Status__c = 'Active'
		);
		insert retroacc;
	}
	public static testmethod void testDuplicateRecordInsert(){
		Account legalAcc = [SELECT Id FROM Account WHERE Country__c = 'India' LIMIT 1];
		ServiceContract sc = [SELECT Id FROM ServiceContract LIMIT 1];
		HWS_RetrofitAccount__c retroacc = new HWS_RetrofitAccount__c(
			HWS_Account__c = legalAcc.id,
			HWS_ServiceContract__c = sc.id,
			HWS_ShipToCountry__c = 'Canada',
			HWS_Status__c = 'Active'
		);
		Test.startTest();
		try{
			insert retroacc;
		}
		catch(Exception e){
			System.assert(e.getMessage().contains(System.Label.HWS_Duplicate_Retrofit_Record_Error));
		}
		Test.stopTest();
	}
	public static testmethod void testUpdateShipToCountry(){
		Account legalAcc = [SELECT Id FROM Account WHERE Country__c = 'India' LIMIT 1];
		ServiceContract scExisting = [SELECT Id FROM ServiceContract LIMIT 1];
		ServiceContract sc = HWS_DataFactory_TEST.insertServiceContract(legalAcc);
		insert sc;
		HWS_RetrofitAccount__c retroacc = new HWS_RetrofitAccount__c(
			HWS_Account__c = legalAcc.id,
			HWS_ServiceContract__c = sc.id,
			HWS_Status__c = 'Active'
		);
		Test.startTest();
		insert retroacc;
		retroacc.HWS_ServiceContract__c = scExisting.Id;
		retroacc.HWS_ShipToCountry__c ='Japan';
		try{
			update retroacc;
		}
		catch(Exception e){
			System.assert(e.getMessage().contains(System.Label.HWS_Duplicate_Retrofit_Record_Error));
		}
		HWS_RetrofitAccount__c retacc = [SELECT HWS_ShipToCountry__c FROM HWS_RetrofitAccount__c WHERE HWS_ServiceContract__c =: sc.Id LIMIT 1 ];
		System.assert(retacc.HWS_ShipToCountry__c.contains('India'));
		retacc.HWS_ShipToCountry__c = 'China;India';
		update retacc;
		Test.stopTest();
	}
}