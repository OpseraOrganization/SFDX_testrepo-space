/*****************************************************************
Description: It is related to the HWS_CancelcaseSendSRtoSOO_SVC class

DATE			AUTHOR	CHANGE
12/04/2019	  Vinod T		 Created
*****************************************************************/
@isTest
Public class HWS_CancelServiceRequesttoSOO_SVC_TEST{
	//As per sonarcube fixes removed unused local variables

	@testSetup static void testDataSetup(){

		Id customerAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.CUSTOMER);
		Id legalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		
		Account acc = HWS_DataFactory_TEST.insertAccount(); 
		acc.RecordTypeId =  customerAccountType; 
		acc.Customer_Compliance__c = 'US_AT&T';		
		insert acc;
		System.assertEquals(acc.Customer_Compliance__c, 'US_AT&T');
		
		Account acc1 = HWS_DataFactory_TEST.insertAccount(); 
		acc1.RecordTypeId =  legalEntityAccountType;
		acc1.ParentId = acc.Id;		
		insert acc1;
		
		Contact con = HWS_DataFactory_TEST.insertContact();
		con.AccountId = acc.Id;
		con.Contact_Status__c = 'Active';
		con.CH_ContactType__c = 'Customer';
		con.email='xyz@example.com';
		insert con;
		
		Product2 prod = HWS_DataFactory_TEST.insertproduct2();
		prod.ProductCode = '1234';
		insert prod;
		
		Id pricebookId = Test.getStandardPricebookId();
		PriceBookEntry pbe = new PriceBookEntry();
		pbe.IsActive=true;
		pbe.Product2Id=prod.id;
		pbe.PriceBook2Id = pricebookId;
		pbe.UnitPrice = 100;	  
		insert pbe;
		
		PriceBook2 pb = HWS_DataFactory_TEST.createPriceBook();	
		insert pb;   
		
		PricebookEntry pbety = new PricebookEntry();
		pbety.CurrencyIsoCode='EUR';
		pbety.IsActive=true;
		pbety.Product2Id=prod.id;
		pbety.PriceBook2Id = pb.Id;
		pbety.UnitPrice = 100;
		insert pbety;  
		
		ServiceContract sc = HWS_DataFactory_TEST.insertServiceContract(acc1);		
		sc.Pricebook2Id = pb.Id;
		insert sc;
		
		ContractLineItem cli=new ContractLineItem();
		cli.UnitPrice=1.00;
		cli.Quantity=1.00;
		cli.ServiceContractId= sc.id;
		cli.PricebookEntryId = pbety.id;
		cli.StartDate = date.valueOf('2019-04-09T12:00:00.000+0000');
		cli.EndDate = date.valueOf('2020-04-09T12:00:00.000+0000');
		cli.CH_ServiceType__c = 'Spare Part Sales';
		insert cli;
		
		Asset ast = new Asset();
		Id assetRecordType = HWS_Utilty.getRecordTypeByName('Asset','HWS_Covered_Part');
		ast.RecordTypeId = assetRecordType;
		ast.Name = 'Test Asset';
		ast.AccountId = acc1.id; 
		ast.Product2Id = prod.Id;
		ast.HWS_SourceSystem__c = 'Puma1';
		insert ast;   
		
		hws_versionitem__c hwsv = HWS_DataFactory_TEST.insertHwsversionitem();
		hwsv.HWS_Serial_Number_Traceable__c='';		
		insert hwsv;
		
		Entitlement ent = new Entitlement();
		ent.Name = 'Return for Repair';
		ent.AccountId = acc1.id;		
		ent.ContractLineItemId = cli.id;
		ent.CH_CDB_EntitlementId__c = '1234';
		ent.CH_ServiceMappingId__c = 'Advanced Exchange in Days';
		ent.RecordTypeId = HWS_Utilty.getRecordTypeByName('Entitlement','HWS_Entitlement');
		insert ent;
		
		Case parentCase = HWS_DataFactory_TEST.insertParentCase();
		parentCase.AccountId = acc1.id;
		parentCase.HWS_Sellable_Product__c = prod.Id;
		parentCase.status = 'Open'; 
		insert parentCase;					 
	
	}
	Public Static testMethod void hwsCancelcaseSendSRtoSOOSVCTestMethod(){
		Id legalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		List<Case> parntLst = new List<Case>();
		List<Case> chldLst = new List<Case>();
		Account acc1 = [Select id from Account where RecordTypeId = :legalEntityAccountType limit 1];
		Product2 prod = [Select id from Product2 limit 1];
		ContractLineItem cli = [Select id from ContractLineItem limit 1];
		Case parentCase = [Select id from Case where status = 'Open' limit 1];
		Asset ast = [Select id from Asset limit 1];
		parntLst.add(parentCase);
		Case caseRecOrdered = HWS_DataFactory_TEST.insertChildCase();
		caseRecOrdered.Status ='Ordered';
		caseRecOrdered.AccountId = acc1.id;
		caseRecOrdered.AssetId = ast.Id;
		caseRecOrdered.HWS_Faulty_Serial_Number__c = '12345';		
		caseRecOrdered.ParentId = parntLst[0].Id;
		caseRecOrdered.HWS_Sellable_Product__c = prod.Id;
		caseRecOrdered.HWS_Contract_Line_Item__c = cli.id;
		insert caseRecOrdered;
		chldLst.add(caseRecOrdered);
		Test.startTest(); 
		Test.setMock(HttpCalloutMock.class, new HWS_CancelSRHttpCalloutMock());
		HWS_CancelCase.cancelChildCases(parntLst[0].Id,HWS_Constants.REQUESTED_BY_CUSTOMER,'Test');
		HWS_CancelCase.cancelChildCases(chldLst[0].Id,HWS_Constants.REQUESTED_BY_CUSTOMER,'Test');
		HWS_CancelCase_Portal.cancelChildCases(parntLst[0].Id);
		HWS_CancelCase_Portal.cancelChildCases(chldLst[0].Id);		
		Test.stopTest();  
	}
	
	Public Static testMethod void hwsSendServiceRequesttoSOOSVCTestMethod1(){ 
	//As per sonarcube fixes removed unused local variables in this method
		Id legalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		List<Case> parntLst = new List<Case>();
		
		Account acc1 = [Select id from Account where RecordTypeId = :legalEntityAccountType limit 1];
		Product2 prod = [Select id from Product2 limit 1];
		ContractLineItem cli = [Select id from ContractLineItem limit 1];
		Asset ast = [Select id from Asset limit 1];
		Case parentCase = [Select id from Case where status = 'Open' limit 1];
		parntLst.add(parentCase);
		Case caseRecOrdered = HWS_DataFactory_TEST.insertChildCase();
		caseRecOrdered.Status =HWS_Constants.On_Hold;
		caseRecOrdered.AccountId = acc1.id;
		caseRecOrdered.AssetId = ast.Id;
		caseRecOrdered.HWS_Faulty_Serial_Number__c = '12345';		
		caseRecOrdered.ParentId = parentCase.Id;
		caseRecOrdered.HWS_Sellable_Product__c = prod.Id;
		caseRecOrdered.HWS_Contract_Line_Item__c = cli.id;
		insert caseRecOrdered ;
		
		Test.startTest(); 
		Test.setMock(HttpCalloutMock.class, new HWS_CancelSRHttpCalloutMock());
		HWS_CancelCase.cancelChildCases(parentCase.id,HWS_Constants.REQUESTED_BY_CUSTOMER,'Test');
		HWS_CancelCase.cancelChildCases(caseRecOrdered.id,HWS_Constants.REQUESTED_BY_CUSTOMER,'Test');
		HWS_CancelCase_Portal.cancelChildCases(parentCase.id);
		HWS_CancelCase_Portal.cancelChildCases(caseRecOrdered.id);		
		Test.stopTest();  
	}
	
	Public Static testMethod void hwsSendServiceRequesttoSOOSVCTestMethod2(){
		Id legalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		List<Case> parntLst = new List<Case>();
	
		Account acc1 = [Select id from Account where RecordTypeId = :legalEntityAccountType limit 1];
		Product2 prod = [Select id from Product2 limit 1];
		ContractLineItem cli = [Select id from ContractLineItem limit 1];
		Asset ast = [Select id from Asset limit 1];
		Case parentCase = [Select id from Case where status = 'Open' limit 1];
		parntLst.add(parentCase);
		Case caseRecOrdered = HWS_DataFactory_TEST.insertChildCase();
		caseRecOrdered.Status =HWS_Constants.On_Hold;
		caseRecOrdered.AccountId = acc1.id;
		caseRecOrdered.AssetId = ast.Id;
		caseRecOrdered.HWS_Faulty_Serial_Number__c = '12345';		
		caseRecOrdered.ParentId = parentCase.Id;
		caseRecOrdered.HWS_Sellable_Product__c = prod.Id;
		caseRecOrdered.HWS_Contract_Line_Item__c = cli.id;		
		insert caseRecOrdered ;		
		Test.startTest(); 
		Test.setMock(HttpCalloutMock.class, new HWS_CancelSRHttpCalloutMock());
		HWS_CancelCase.cancelChildCases(caseRecOrdered.id,HWS_Constants.REQUESTED_BY_CUSTOMER,'Test');
		HWS_CancelCase_Portal.cancelChildCases(caseRecOrdered.id);		
		Test.stopTest();  
	} 
	
	Public Static testMethod void hwsSendServiceRequesttoSOOSVCTestMethod3(){
		Id legalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		List<Case> parntLst = new List<Case>();
		
		Account acc1 = [Select id from Account where RecordTypeId = :legalEntityAccountType limit 1];
		Product2 prod = [Select id from Product2 limit 1];
		ContractLineItem cli = [Select id from ContractLineItem limit 1];
		Asset ast = [Select id from Asset limit 1];
		Case parentCase = [Select id from Case where status = 'Open' limit 1];
		parntLst.add(parentCase);
		Case caseRecOrdered = HWS_DataFactory_TEST.insertChildCase();
		caseRecOrdered.Status =HWS_Constants.On_Hold;
		caseRecOrdered.AccountId = acc1.id;
		caseRecOrdered.AssetId = ast.Id;
		caseRecOrdered.HWS_Faulty_Serial_Number__c = '12345';		
		caseRecOrdered.ParentId = parentCase.Id;
		caseRecOrdered.HWS_Sellable_Product__c = prod.Id;
		caseRecOrdered.HWS_Contract_Line_Item__c = cli.id;
		insert caseRecOrdered ;		
		Test.startTest(); 
		Test.setMock(HttpCalloutMock.class, new HWS_CancelSRHttpCalloutMock());		
		HWS_CancelCase_Portal.cancelChildCases(caseRecOrdered.id);
		caseRecOrdered.Status ='Shipped';
		update caseRecOrdered;
		HWS_CancelCase.cancelChildCases(caseRecOrdered.id,HWS_Constants.REQUESTED_BY_CUSTOMER,'Test');
		HWS_CancelCase_Portal.cancelChildCases(caseRecOrdered.id);
		Test.stopTest();  
	} 
	
	Public Static testMethod void hwsSendServiceRequesttoSOOSVCTestMethod4(){
		Id legalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		List<Case> parntLst = new List<Case>();
		
		Account acc1 = [Select id from Account where RecordTypeId = :legalEntityAccountType limit 1];
		Product2 prod = [Select id from Product2 limit 1];
		ContractLineItem cli = [Select id from ContractLineItem limit 1];
		Asset ast = [Select id from Asset limit 1];		
		Case parentCase = [Select id from Case where status = 'Open' limit 1];
		parntLst.add(parentCase);	  
		Case caseRecOrdered = HWS_DataFactory_TEST.insertChildCase();
		caseRecOrdered.Status ='Request to Cancel';
		caseRecOrdered.AccountId = acc1.id;
		caseRecOrdered.AssetId = ast.Id;
		caseRecOrdered.HWS_Faulty_Serial_Number__c = '12345';		
		caseRecOrdered.ParentId = parentCase.Id;
		caseRecOrdered.HWS_Sellable_Product__c = prod.Id;
		caseRecOrdered.HWS_Contract_Line_Item__c = cli.id;
		insert caseRecOrdered ;
		Test.startTest(); 
		Test.setMock(HttpCalloutMock.class, new HWS_CancelSRHttpCalloutMock());
		HWS_CancelCase.cancelChildCases(caseRecOrdered.id,HWS_Constants.REQUESTED_BY_CUSTOMER,'Test');
		HWS_CancelCase_Portal.cancelChildCases(caseRecOrdered.id);
		HWS_CancelCase_Portal.getCancellationStatus(caseRecOrdered.id);
		Test.stopTest();  
	}
	
	Public Static testMethod void hwsCancelcaseSendSRtoSOOSVCTestMethod5(){
		Id legalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		List<Case> parntLst = new List<Case>();
		List<Case> chldLst = new List<Case>();
		Account acc1 = [Select id from Account where RecordTypeId = :legalEntityAccountType limit 1];
		Product2 prod = [Select id from Product2 limit 1];
		ContractLineItem cli = [Select id from ContractLineItem limit 1];
		Asset ast = [Select id from Asset limit 1];
		Case parentCase = [Select id from Case where status = 'Open' limit 1];
		parntLst.add(parentCase);
		Case caseRecOrdered = HWS_DataFactory_TEST.insertChildCase();
		caseRecOrdered.Status ='Ordered';
		caseRecOrdered.AccountId = acc1.id;
		caseRecOrdered.AssetId = ast.Id;
		caseRecOrdered.HWS_Faulty_Serial_Number__c = '12345';		
		caseRecOrdered.ParentId = parntLst[0].Id;
		caseRecOrdered.HWS_Sellable_Product__c = prod.Id;
		caseRecOrdered.HWS_Contract_Line_Item__c = cli.id;
		chldLst.add(caseRecOrdered);	
		insert chldLst;
		Test.startTest(); 
		Test.setMock(HttpCalloutMock.class, new HWS_CancelSRHttpCalloutMock());		
		HWS_CancelCase.cancelChildCases(chldLst[0].Id,HWS_Constants.REQUESTED_BY_CUSTOMER,'Test');	
		Test.stopTest();  
	}
	
	Public Static testMethod void hwsCancelcaseSendSRtoSOOSVCTestMethod6(){		
		Id legalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		List<Case> parntLst = new List<Case>();
		List<Case> chldLst = new List<Case>();
		Account acc1 = [Select id from Account where RecordTypeId = :legalEntityAccountType limit 1];
		Product2 prod = [Select id from Product2 limit 1];		
		ContractLineItem cli = [Select id from ContractLineItem limit 1];
		Asset ast = [Select id from Asset limit 1];
		Case parentCase = [Select id from Case where status = 'Open' limit 1];
		parntLst.add(parentCase);	  
		Case caseRecOrdered = HWS_DataFactory_TEST.insertChildCase();
		caseRecOrdered.Status ='Draft';
		caseRecOrdered.AccountId = acc1.id;
		caseRecOrdered.AssetId = ast.Id;
		caseRecOrdered.HWS_Faulty_Serial_Number__c = '12345';		
		caseRecOrdered.ParentId = parntLst[0].Id;
		caseRecOrdered.HWS_Sellable_Product__c = prod.Id;
		caseRecOrdered.HWS_Contract_Line_Item__c = cli.id;
		chldLst.add(caseRecOrdered);		
		insert chldLst;
		Test.startTest(); 
		Test.setMock(HttpCalloutMock.class, new HWS_CancelSRHttpCalloutMock());		
		HWS_CancelCase_Portal.cancelChildCases(parntLst[0].Id);
		HWS_CancelCase_Portal.cancelChildCases(chldLst[0].Id);
		chldLst[0].Status ='Ordered';
		update chldLst;
		HWS_CancelCase_Portal.cancelChildCases(parntLst[0].Id);
		HWS_CancelCase_Portal.cancelChildCases(chldLst[0].Id);
		HWS_CancelCase.cancelChildCases(parntLst[0].Id,HWS_Constants.REQUESTED_BY_CUSTOMER,'Test');
		HWS_CancelCase.cancelChildCases(chldLst[0].Id,HWS_Constants.REQUESTED_BY_CUSTOMER,'Test');
		Test.stopTest();  
	}
	
	Public Static testMethod void hwsCancelcaseSendSRtoSOOSVCTestMethod7(){
		Id legalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		List<Case> parntLst = new List<Case>();
		List<Case> chldLst = new List<Case>();
		Account acc1 = [Select id from Account where RecordTypeId = :legalEntityAccountType limit 1];
		Product2 prod = [Select id from Product2 limit 1];
		ContractLineItem cli = [Select id from ContractLineItem limit 1];
		Asset ast = [Select id from Asset limit 1];
		Case parentCase = [Select id from Case where status = 'Open' limit 1];
		parntLst.add(parentCase);
		Case caseRecOrdered = HWS_DataFactory_TEST.insertChildCase();
		caseRecOrdered.Status ='Ordered';
		caseRecOrdered.AccountId = acc1.id;
		caseRecOrdered.AssetId = ast.Id;
		caseRecOrdered.HWS_Faulty_Serial_Number__c = '12345';		
		caseRecOrdered.ParentId = parntLst[0].Id;
		caseRecOrdered.HWS_Sellable_Product__c = prod.Id;
		caseRecOrdered.HWS_Contract_Line_Item__c = cli.id;
		chldLst.add(caseRecOrdered);	
		insert chldLst;
		Test.startTest(); 
		Test.setMock(HttpCalloutMock.class, new HWS_CancelSRHttpCalloutMock());		
		HWS_CancelCase_Portal.cancelChildCases(chldLst[0].Id);	
		Test.stopTest();  
	}
}