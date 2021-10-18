/*******************************************************************************************
* Class Name : CH_HWSHistoricalCase_OwnerUpdate_Test
* Created By : TCS
* Last Modified by: TCS
* Description : Test Class for CH_HWSHistoricalCase_OwnerUpdate
* User Story : https://jiradc2.ext.net.nokia.com/browse/NOKIASC-33494 
********************************************************************************************/
@isTest
public class CH_HWSHistoricalCase_OwnerUpdate_Test {
	private static Set<String> childCaseStatuses = new Set<String>{'Closed','Cancelled'};
		private static Id parentCaseId;
	@testSetup static void testDataSetup(){
		Id accountRecordType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LOGISTIC_ACCOUNT_EXISTING);
		Id childcase = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Child_Case_Read_Only);
		Id exchangeInDays = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Advance_Exchange_In_Days);
		Id exchangeInHours = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_ADVANCE_EXCHANGE_IN_HOURS);
		Id parentCaseRecordType = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Parent_Case);
		Id sparePartSales = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_SPS_PART_SALES);
		Id legalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		List<Case>listCase= new List<Case>();
		Account acc = HWS_DataFactory_TEST.insertAccount();
		acc.name='test1';
		acc.Customer_Compliance__c ='US_Govern';
		insert acc;
		
		Account acc2 = HWS_DataFactory_TEST.insertAccount(); 
		acc2.RecordTypeId =  legalEntityAccountType;
		acc2.ParentId = Acc.Id;
		insert acc2;
		
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
		//ACC1.RecordTypeId =  LegalEntityAccountType;
		insert acc1;
		Product2 prod = HWS_DataFactory_TEST.insertproduct2();
		prod.ProductCode = '1234';
		insert prod;
		hws_versionitem__c vItem = HWS_DataFactory_TEST.insertHwsversionitem();
		insert vItem;
		ServiceContract sc = HWS_DataFactory_TEST.insertServiceContract(Acc);
		insert sc;
		Asset ast = new Asset();
		Id assetRecordType = HWS_Utilty.getRecordTypeByName('Asset','HWS_Covered_Part');
		ast.RecordTypeId = assetRecordType;
		ast.Name = 'Test Asset';
		ast.AccountId = acc2.id;
		ast.Product2Id = prod.Id;	
		ast.HWS_SourceSystem__c  = 'Puma1';
		ast.HWS_Price__c = '20';
		ast.HWS_ContractLeadTimeDuration__c = '60';
		insert ast;   
		
		Case ca = new Case();
		ca.RecordTypeId = parentCaseRecordType;
		ca.AccountId = acc2.Id;
		ca.Hws_Ship_to_Party_Address__c= acc1.Id;
		ca.AssetId=ast.Id;
		ca.Status='Closed';
		ca.Subject='Test Subject';
		ca.Description='test Description';
		//ca.HWS_Faulty_Serial_Number__c= 'test1234';
		ca.HWS_ShipTopartyId__c='1234566';
		ca.Describe__c = 'Test description3';
		insert ca;
		//parentCaseId = ca.Id;
		Case cas = new Case();
		cas.RecordTypeId = childcase;
		cas.ParentId = ca.Id;
		cas.AccountId = acc2.Id;
		cas.AssetId=ast.Id;
		//cas.Status ='Cancelled';
		cas.Hws_Ship_to_Party_Address__c= acc1.Id;
		cas.HWS_Sellable_Product__c = prod.Id;
		cas.HWS_Faulty_Serial_Number__c = '1234'; 
		cas.HWS_FaultyUnitMaterialCode__c = '4567';
		cas.HWS_Shippeddate__c= system.today();
		//cas.HWS_AWBNumber__c = '122';
		cas.HWS_LSP_Courier_Name__c = 'Test123';
		cas.HWS_TotalShippedQuantity__c = 1234;
		cas.Describe__c = 'Test description';
		cas.HWS_Bar_Code__c = 'Test data111';
		cas.HWS_Bar_Code_Ref1__c = 'Test data123';
		insert cas;
		
		Case cas1 = new Case();
		cas1.RecordTypeId = sparePartSales;
		cas1.ParentId = ca.Id;
		cas1.AccountId = acc2.Id;
		//cas.Status ='Cancelled';
		cas1.Hws_Ship_to_Party_Address__c= acc1.Id;
		cas1.HWS_Sellable_Product__c = prod.Id;
		cas1.AssetId=ast.Id;
		cas1.HWS_Faulty_Serial_Number__c = '123434233'; 
		cas1.HWS_FaultyUnitMaterialCode__c = '456755667';
		cas1.HWS_ServiceType__c ='Spare Part Sales';
		cas1.HWS_TotalShippedQuantity__c = 12344455;
		cas1.HWS_Shippeddate__c= system.today();
		//cas1.HWS_AWBNumber__c = '12277';
		cas1.HWS_LSP_Courier_Name__c = 'Test1232334';
		cas1.Describe__c = 'Test description';
		cas1.HWS_Address_Name__c='test';
		cas1.City__c = 'hyderabad';
		cas1.State__c = 'Telangana';
		cas1.Country__c = 'India';
		cas1.POSTAL_CODE_CHQ__c = '500090';
		cas1.HWS_Bar_Code__c = 'Test data2222';
		cas1.HWS_Bar_Code_Ref1__c = 'Test data123';
		cas1.HWS_Quantity__c = 5;
		insert cas1;
		HWS_BypassStatusChangeValidation__c cussett = new HWS_BypassStatusChangeValidation__c();
		cussett.HWS_BypassCaseStatusValidation__c = true;
		insert cussett;
	}
	
	@isTest  public static void testmethod1()
	{
		test.startTest();		 
		CH_HWSHistoricalCase_OwnerUpdate obj = new CH_HWSHistoricalCase_OwnerUpdate();
		DataBase.executeBatch(obj);
		test.stopTest();
	}
	
	
}