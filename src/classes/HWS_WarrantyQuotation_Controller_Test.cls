/****************************************
* Class Name : HWS_WarrantyQuotation_Controller_Test
* User Story : NOKIASC-34453  
* Created Date: 01 Feb 2021 
* Created By : TCS  
* Last Modified by:  
* Last Modified Date:
* Description : Test class for Warranty and Quotation Review(HWS_WarrantyQuotation_Controller)
*****************************************/
@isTest
public class HWS_WarrantyQuotation_Controller_Test  {
	public static final string InWarranty = 'In Warranty';
	public static final string notApplicable = 'Not Applicable';
	public static final string OutofWarranty = 'Out of Warranty';
	public static final string Advance_Exchange_in_Days = 'Advance Exchange in Days';
	
	@testSetup static void testDataSetup(){
		
		Id customerAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.Customer);
		Id legalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		Id assetRecordType = HWS_Utilty.getRecordTypeByName('Asset','HWS_Covered_Part');
		Id coveredProductRecordType = HWS_Utilty.getRecordTypeByName('Asset','CH_CoveredProduct');  
		List<ISO_Country_Codes__c> countryCodeList = new List<ISO_Country_Codes__c>();
		ISO_Country_Codes__c cc = new ISO_Country_Codes__c();
		cc.Name = 'IN';
		cc.Country_Name__c = 'India';
		cc.Market__c='Market India';
		countryCodeList.add(cc);
		ISO_Country_Codes__c cc1 = new ISO_Country_Codes__c();
		cc1.Name = 'AG';
		cc1.Country_Name__c = 'Antigua And Barbuda';
		cc1.Market__c='Market Latin America';
		countryCodeList.add(cc1);
		insert countryCodeList;
		Account custAcc = HWS_DataFactory_TEST.insertAccount(); 
		custAcc.RecordTypeId =  customerAccountType;
		custAcc.Customer_Compliance__c = HWS_Constants.USATT;
		insert custAcc; 
		
		Account legalAcc = HWS_DataFactory_TEST.insertAccount(); 
		legalAcc.RecordTypeId =  legalEntityAccountType;
		legalAcc.ParentId = custAcc.Id;
		legalAcc.Name = 'TestLE';
		insert legalAcc;
		
		
		Contact con = HWS_DataFactory_TEST.insertContact();
		con.AccountId = custAcc.Id;
		con.Contact_Status__c = 'Active';
		con.CH_ContactType__c = 'Customer';
		con.email='xyz@example.com';
		insert con;
		
		Product2 prod1 = HWS_DataFactory_TEST.insertproduct2();  
		insert prod1;
		
		PriceBook2 pb = HWS_DataFactory_TEST.createPriceBook();	
		insert pb;   
		
		PricebookEntry pbety = HWS_DataFactory_TEST.createPriceBookEntry(prod1.id, pb.Id);  
		pbety.CurrencyIsoCode='EUR'; 
		pbety.UseStandardPrice = false;
		pbety.Pricebook2Id = Test.getStandardPricebookId();
		insert pbety;  
		
		ServiceContract sc = HWS_DataFactory_TEST.insertServiceContract(legalAcc);
		sc.Pricebook2Id = Test.getStandardPricebookId();
		sc.NCP_External_Status__c = 'Active';
		sc.CurrencyIsoCode = 'EUR';
		insert sc;
		
		Asset covProdAsset = new Asset();
		covProdAsset.RecordTypeId = coveredProductRecordType; 
		covProdAsset.AccountId = legalAcc.Id;
		covProdAsset.Product2Id = prod1.Id;
		insert covProdAsset;
		
		ContractLineItem cli = HWS_DataFactory_TEST.insertContractLineItem(sc,pbety);	 
		cli.PricebookEntryId = pbety.id; 
		cli.CH_CountryISOName__c = 'United States of America';
		cli.CH_ServiceClassification__c = 'HWS Service';
		insert cli;
		
		Asset ast = HWS_DataFactory_TEST.insertAsset(legalAcc,prod1);
		ast.HWS_ContractLineItem__c = cli.Id;
		ast.RecordTypeId = assetRecordType;  
		ast.HWS_ContractLeadTimeUnit__c = 'Business Days';
		ast.HWS_ContractLeadTimeDuration__c = '1';
		ast.HWS_SpecifiedDeliveryTargetTime__c = '17:00';
		insert ast; 
		
		hws_versionitem__c hwsv = HWS_DataFactory_TEST.insertHwsversionitem();
		hwsv.HWS_Serial_Number_Traceable__c='';  
		insert hwsv;
		
		Case parentCase = HWS_DataFactory_TEST.insertParentCase();
		parentCase.AccountId = legalAcc.Id;
		parentCase.ContactId=con.Id;
		parentCase.CH_InternalStatus__c='Under Review';
		insert parentCase;
		
	}	 
	public static testmethod void checkWarrantyQuotationCondition(){
		List<Account> accList = new List<Account>();
		List<Asset> astList = new List<Asset>();
		List<hws_versionitem__c> hvList = new List<hws_versionitem__c>();	 
		List<Case> childCaseList = new List<Case>();
		Id parentCaseId = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_PARENT_CASE);
		Account acc = [Select Id from Account Where Name = 'TestLE' limit 1];
		accList.add(acc);
		Contact cont = [Select Id from Contact limit 1];
		Product2 prod = [Select id from Product2 limit 1];
		Asset ast = [Select id,HWS_ContractLineItem__r.CH_CountryISOName__c from Asset where RecordType.DeveloperName='HWS_Covered_Part' limit 1];
		astList.add(ast);
		hws_versionitem__c hv = [Select id from hws_versionitem__c limit 1];
		hvList.add(hv);
		Case parentCase = HWS_DataFactory_TEST.insertParentCase();
		parentCase.AccountId = accList[0].Id;
		parentCase.ContactId = cont.Id;
		
		Case childCase = HWS_DataFactory_TEST.insertChildCase();
		childCase.AccountId = acc.Id;
		childCase.ContactId = cont.Id;
		childCase.AssetId =ast.Id;
		
		childCase.HWS_WarrantyStatus__c=InWarranty;
		childCase.HWS_ServiceType__c = Advance_Exchange_in_Days;  
		childCase.HWS_Sellable_Product__c = prod.Id;
		test.startTest();	
		childCaseList.add(childCase);
		
		try{
			String parentcaseIds = HWS_CaseFlow.createHWSCase(accList,astList,hvList,childCaseList,parentCase,string.valueOf(cont.id),true,Datetime.now(),'(GMT+05:30) India Standard Time (Asia/Kolkata)');
		}catch(Exception e){
			//This is empty block 
		}   
		HWS_WarrantyQuotation_Controller.WarrantyQuotationWrapper warrantyQuotationWrapper=new HWS_WarrantyQuotation_Controller.WarrantyQuotationWrapper();
		HWS_WarrantyQuotation_Controller.checkWarrantyQuotationCondition(parentCase.Id,false);
	}
	public static testmethod void getWarrantyStatus(){
		Account acc = HWS_DataFactory_TEST.insertAccount();
		Test.startTest();
		Id customerAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.Customer);
		Id legalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		
		acc.RecordTypeId =  customerAccountType;
		acc.Customer_Compliance__c = 'US_AT&T';
		insert acc; 
		Account acc1 = HWS_DataFactory_TEST.insertAccount();
		acc1.RecordTypeId =  legalEntityAccountType;
		acc1.ParentId = acc.Id;
		acc1.Name = 'TestLE';
		acc1.Type = 'Vendor';
		insert acc1;
		Contact con = HWS_DataFactory_TEST.insertContact();
		con.AccountId = acc.Id;
		con.Contact_Status__c = 'Active';
		con.CH_ContactType__c = 'Customer';
		con.email='xyz12122@example.com';
		insert con;
		Case parentCase = HWS_DataFactory_TEST.insertParentCase();
		parentCase.AccountId = acc1.id;
		insert parentCase;
		Product2 prod = HWS_DataFactory_TEST.insertproduct2();  
		prod.ProductCode = 'ABCDEFGH';
		insert prod;  
		HWS_WarrantyQuotation_Controller.updateCaseValues(null);
		HWS_GenericSettings__c custSetting = new HWS_GenericSettings__c();
		custSetting.Name = 'HWS_EnableWarrantyCheck';
		custSetting.HWS_Field1__c = 'true';
		insert custSetting;
		
		Case caserec = new Case();
		Id exchangeInDays = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Advance_Exchange_In_Days);
		caserec.RecordTypeId =exchangeInDays;
		caserec.Status='Draft';
		caserec.Subject='test'+1;
		caserec.Description='test' +1;
		caserec.HWS_Faulty_Serial_Number__c= 'test1ww234';
		caserec.HWS_ShipTopartyId__c='1234566';
		caserec.AccountId = acc.Id;
		caserec.ContactId = con.Id;
		caserec.ParentId = parentCase.Id;
		caserec.HWS_ServiceType__c = Advance_Exchange_in_Days;  
		caserec.HWS_Sellable_Product__c = prod.Id;
		caserec.HWS_WarrantyStatus__c  ='Failed to determine Warranty';
		caserec.HWS_Part_Code__c = 'C11';
		insert caserec;
		caserec.HWS_Faulty_Serial_Number__c = 'test1wssw234';
		
		
		
		
		
		Test.setMock(HttpCalloutMock.class, new HWS_SendWarrantyCheckRequesttoSOO_Test(true,'OutWarranty'));
		try{
			HWS_WarrantyQuotation_Controller.getWarrantyStatus(caserec);
		}
		catch(exception e){ 
			//Added empty line 
		}
		Test.stopTest();
	}
	
	public static testmethod void getWarrantyStatus1(){
		Account acc = HWS_DataFactory_TEST.insertAccount();
		Test.startTest();
		Id customerAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.Customer);
		Id legalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		
		acc.RecordTypeId =  customerAccountType;
		acc.Customer_Compliance__c = 'US_AT&T';
		insert acc; 
		Account acc1 = HWS_DataFactory_TEST.insertAccount();
		acc1.RecordTypeId =  legalEntityAccountType;
		acc1.ParentId = acc.Id;
		acc1.Name = 'TestLE';
		acc1.Type = 'Vendor';
		insert acc1;
		Contact con = HWS_DataFactory_TEST.insertContact();
		con.AccountId = acc.Id;
		con.Contact_Status__c = 'Active';
		con.CH_ContactType__c = 'Customer';
		con.email='xyz12122@example.com';
		insert con;
		Case parentCase = HWS_DataFactory_TEST.insertParentCase();
		parentCase.AccountId = acc1.id;
		insert parentCase;
		Product2 prod = HWS_DataFactory_TEST.insertproduct2();  
		prod.ProductCode = 'ABCDEFGH';
		insert prod;  
		HWS_WarrantyQuotation_Controller.updateCaseValues(null);
		HWS_GenericSettings__c custSetting = new HWS_GenericSettings__c();
		custSetting.Name = 'HWS_EnableWarrantyCheck';
		custSetting.HWS_Field1__c = 'true';
		insert custSetting;
		
		Case caserec = new Case();
		Id exchangeInDays = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Advance_Exchange_In_Days);
		caserec.RecordTypeId =exchangeInDays;
		caserec.Status='Draft';
		caserec.Subject='test'+1;
		caserec.Description='test' +1;
		caserec.HWS_ShipTopartyId__c='1234566';
		caserec.AccountId = acc.Id;
		caserec.ContactId = con.Id;
		caserec.ParentId = parentCase.Id;
		caserec.HWS_ServiceType__c = Advance_Exchange_in_Days;  
		caserec.HWS_Sellable_Product__c = prod.Id;
		caserec.HWS_Part_Code__c = 'C11';
		caserec.HWS_Faulty_Serial_Number__c = 'UNKNOWN';
		caserec.HWS_WarrantyStatus__c  ='WarrantyUnknown';	   
		insert caserec;
		
		Test.setMock(HttpCalloutMock.class, new HWS_SendWarrantyCheckRequesttoSOO_Test(true,'OutWarranty'));
		try{
			HWS_WarrantyQuotation_Controller.getWarrantyStatus(caserec);
			
		}
		catch(exception e){ 
			//Added empty line 
		}
		Test.stopTest();
	}
	public static testmethod void updateParentInternalStatusTest(){
		Id customerAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.Customer);
		Id legalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		
		HWS_GenericSettings__c custSetting = new HWS_GenericSettings__c();
		custSetting.Name = 'HWS_EnableWarrantyCheck';
		custSetting.HWS_Field1__c = 'true';
		insert custSetting;
		Test.startTest();	
		Account acc = [Select Id,Customer_Compliance__c from Account Where Name = 'TestLE' limit 1];
		
		Account acc1 = HWS_DataFactory_TEST.insertAccount();
		acc1.RecordTypeId =  legalEntityAccountType;
		acc1.ParentId = acc.Id;
		acc1.Name = 'TestLE';
		acc1.Type = 'Vendor';
		insert acc1;
		
		
		Contact cont = [Select Id from Contact limit 1];
		Product2 prod = [Select id from Product2 limit 1];
		
		Case parentCase = HWS_DataFactory_TEST.insertParentCase();
		parentCase.AccountId = acc1.id;
		insert parentCase;
		
		Case caserec = new Case();
		Id exchangeInDays = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Advance_Exchange_In_Days);
		caserec.RecordTypeId =exchangeInDays;
		caserec.Status='Draft';
		caserec.Subject='test'+1;
		caserec.Description='test' +1;
		caserec.HWS_Faulty_Serial_Number__c= 'test1234';
		caserec.HWS_ShipTopartyId__c='1234566';
		caserec.AccountId = acc.Id;
		caserec.ContactId = cont.Id;
		caserec.ParentId = parentCase.Id;
		caserec.HWS_ServiceType__c = Advance_Exchange_in_Days;  
		caserec.HWS_Sellable_Product__c = prod.Id;
		caserec.HWS_WarrantyStatus__c  ='Failed to determine Warranty';
		insert caserec;
		
		Test.setMock(HttpCalloutMock.class, new HWS_SendWarrantyCheckRequesttoSOO_Test(true,'Inwarranty'));
		HWS_WarrantyQuotation_Controller.getWarrantyStatus(caserec);
		HWS_WarrantyQuotation_Controller.getCaseInfo(parentCase.Id);
		
		HWS_WarrantyQuotation_Controller.updateParentInternalStatus(parentCase.Id);
		Test.stopTest();
	}
	
	public static testmethod void getPayPerUse(){
		Id childRecordType = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_ADVANCE_EXCHANGE_IN_DAYS);  
		Product2 prod = [Select id from Product2 limit 1];
		ContractLineItem cli = [select id from ContractLineItem limit 1]; 
		Account acc = [Select Id,AccountNumber from Account where Name = 'TestLE' limit 1 ];
		Asset ast = [Select id from Asset limit 1];
		ast.Price = null;
		upsert ast;
		test.startTest();	
		Case parentCase = [Select id,CaseNumber from Case limit 1];
		parentCase.HWS_Customer_PO__c = null;
		upsert parentCase;
		Case childCase = HWS_DataFactory_TEST.createCase(childRecordType);
		childCase.ParentId=parentCase.Id;
		childCase.AccountId=acc.id;
		childCase.AssetId = ast.Id;
		childCase.HWS_Contract_Line_Item__c = cli.Id;
		childCase.HWS_Sellable_Product__c = prod.Id;
		
		insert childCase;   
		
		HWS_WarrantyQuotation_Controller.getPayPerUse(parentCase.Id);
		test.stopTest();
	}
	public static testmethod void makeSOOCalloutTest(){  
		Id childRecordType = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_ADVANCE_EXCHANGE_IN_DAYS);  
		Product2 prod = [Select id from Product2 limit 1];
		Case parentCase = [Select id,accountId from Case limit 1];
		Case childCase = HWS_DataFactory_TEST.createCase(childRecordType);
		childCase.ParentId=parentCase.Id;
		childCase.AccountId = parentCase.AccountId;
		childCase.HWS_Sellable_Product__c = prod.Id;
		insert childCase;	 
		test.startTest();
		Test.setMock(HttpCalloutMock.class, new HWS_CreateSRHttpCalloutMock(true));
		HWS_WarrantyQuotation_Controller.makeSOOCallout(parentCase.Id);
		system.assertNotEquals(childCase, null);
		test.stopTest();
	}
	public static testmethod void updateParentCaseStatus(){  
		Id childRecordType = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_ADVANCE_EXCHANGE_IN_DAYS);  
		Product2 prod = [Select id from Product2 limit 1];
		Case parentCase = [Select id,accountId from Case limit 1];
		Case childCase = HWS_DataFactory_TEST.createCase(childRecordType);
		childCase.ParentId=parentCase.Id;
		childCase.AccountId = parentCase.AccountId;
		childCase.HWS_Sellable_Product__c = prod.Id;
		insert childCase;	 
		test.startTest();
		HWS_WarrantyQuotation_Controller.updateParentCaseStatus(parentCase.Id);
		HWS_WarrantyQuotation_Controller.updateParentCaseStatus(childCase.Id);
		
		test.stopTest();
	}
	
	public static testmethod void checkPortalUser(){
		boolean returnMe = false;
		List<User> lstusr = [SELECT ContactID from User Where ID=: userinfo.getuserid()];
		if(lstusr.size()>0 && lstusr[0].ContactID != null)
			returnMe = true;
		system.assertEquals(returnMe , HWS_WarrantyQuotation_Controller.isPortalUser());
	}
	
	public static testmethod void cloneCasesTest(){
		test.startTest();
		Id parentCaseId = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_PARENT_CASE);
		Account acc = [Select Id from Account Where Name = 'TestLE' limit 1];
		Contact cont = [Select Id from Contact limit 1];
		Product2 prod = [Select id from Product2 limit 1];
		Asset ast = [Select id,HWS_ContractLineItem__r.CH_CountryISOName__c from Asset where RecordType.DeveloperName='HWS_Covered_Part' limit 1];
		
		
		
		Case parentCase = HWS_DataFactory_TEST.insertParentCase();
		parentCase.RecordTypeId =parentCaseId;
		parentCase.Status='Open';
		parentCase.Subject='test';
		parentCase.Description='test';
		parentCase.HWS_Faulty_Serial_Number__c= 'test1234xasasdddadasdf';
		parentCase.HWS_ShipTopartyId__c='1234566';
		parentCase.AccountId = acc.Id;
		parentCase.ContactId = cont.Id;   
		parentCase.CH_InternalStatus__c='Under Review';
		
		insert parentCase;
		
		Case childCase = HWS_DataFactory_TEST.insertChildCase();
		childCase.AccountId = acc.Id;
		childCase.ContactId = cont.Id;
		childCase.AssetId =ast.Id;
		childCase.ParentId = parentCase.Id;
		childCase.Status = 'Draft';
		childCase.HWS_Faulty_Serial_Number__c= 'childFault04444addASDDQ';
		
		childCase.HWS_WarrantyStatus__c=InWarranty;
		childCase.HWS_ServiceType__c = Advance_Exchange_in_Days;  
		childCase.HWS_Sellable_Product__c = prod.Id;
		insert childCase;
		HWS_WarrantyQuotation_Controller.cloneCases(parentCase.Id,new List<Case>{childCase}, 'Test');
		HWS_WarrantyQuotation_Controller.cloneCases(parentCase.Id,new List<Case>{childCase}, 'Test');
		HWS_WarrantyQuotation_Controller.editCase(parentCase.Id,'childFault04444addASDDQ');
		
		HWS_WarrantyQuotation_Controller.updateParentInternalStatus(parentCase.Id);
		HWS_WarrantyQuotation_Controller.updateParentCaseStatusWarrantyQuote(parentCase.Id);
		test.stopTest();	  
	}
	public static testmethod void cancelChildCasesTest(){
		Id childRecordType = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_ADVANCE_EXCHANGE_IN_DAYS);  
		Product2 prod = [Select id from Product2 limit 1];
		ContractLineItem cli = [select id from ContractLineItem limit 1];
		
		cli.HWS_AutoCancelOOW__c='Yes';
		cli.HWS_WarrantyVerificationRequired__c='Yes';
		cli.HWS_QuotationRequiredFlag__c='Never';
		cli.HWS_InvoicingType__c='event based'; 
		cli.HWS_PORequiredUpfront__c='No';
		cli.HWS_PONumber__c='12345';
		cli.HWS_AutoCancelOOW__c='Yes';
		upsert cli;
		Account acc = [Select Id,AccountNumber from Account where Name = 'TestLE' limit 1 ];
		Asset ast = [Select id from Asset limit 1];
		ast.Price = null;
		upsert ast;
		Case parentCase = [Select id,CaseNumber from Case limit 1];
		test.startTest();	
		List<string> conditions=new List<string>{'HWS_W_AND_Q_UC_8','HWS_W_AND_Q_UC_2A','HWS_W_AND_Q_UC_1','HWS_W_AND_Q_UC_2B'};
			Case childCase = HWS_DataFactory_TEST.createCase(childRecordType);
		childCase.ParentId=parentCase.Id;
		childCase.AccountId=acc.id;
		childCase.AssetId = ast.Id;
		childCase.HWS_Contract_Line_Item__c = cli.Id;
		childCase.HWS_Sellable_Product__c = prod.Id;
		childCase.HWS_WarrantyStatus__c=OutofWarranty;
		insert childCase;   
		
		HWS_WarrantyQuotation_Controller.cancelChildCases(parentCase.id,conditions);
		HWS_WarrantyQuotation_Controller.updateParentCaseStatusBlank(childCase.id);
		test.stopTest();	
	}
	public static testmethod void checkWarrantyQuotationCondition2(){
		List<Account> accList = new List<Account>();
		List<Asset> astList = new List<Asset>();
		List<hws_versionitem__c> hvList = new List<hws_versionitem__c>();	 
		List<Case> childCaseList = new List<Case>();
		Id parentCaseId = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_PARENT_CASE);
		Account acc = [Select Id from Account Where Name = 'TestLE' limit 1];
		accList.add(acc);
		Contact cont = [Select Id from Contact limit 1];
		Product2 prod = [Select id from Product2 limit 1];
		Asset ast = [Select id,HWS_ContractLineItem__r.CH_CountryISOName__c from Asset where RecordType.DeveloperName='HWS_Covered_Part' limit 1];
		astList.add(ast);
		hws_versionitem__c hv = [Select id from hws_versionitem__c limit 1];
		hvList.add(hv);
		ContractLineItem cli = [select id from ContractLineItem limit 1];
		
		cli.HWS_AutoCancelOOW__c='Yes';
		cli.HWS_WarrantyVerificationRequired__c='Yes';
		cli.HWS_QuotationRequiredFlag__c='Never';
		cli.HWS_InvoicingType__c='event based'; 
		cli.HWS_PORequiredUpfront__c='No';
		cli.HWS_PONumber__c='12345';
		cli.HWS_AutoCancelOOW__c='Yes';
		upsert cli;
		Case parentCase = HWS_DataFactory_TEST.insertParentCase();
		parentCase.AccountId = accList[0].Id;
		parentCase.ContactId = cont.Id;
		parentCase.HWS_Contract_Line_Item__c = cli.Id;
		Case childCase = HWS_DataFactory_TEST.insertChildCase();
		childCase.AccountId = acc.Id;
		childCase.ContactId = cont.Id;
		childCase.AssetId =ast.Id;
		childCase.HWS_Contract_Line_Item__c = cli.Id;
		childCase.HWS_WarrantyStatus__c=InWarranty;
		childCase.HWS_ServiceType__c = Advance_Exchange_in_Days;
		childCase.HWS_Sellable_Product__c = prod.Id;
		childCase.ParentId =parentCase.id;
		childCaseList.add(childCase);
		Case childCase1 = HWS_DataFactory_TEST.insertChildCase();
		childCase1.AccountId = acc.Id;
		childCase1.ContactId = cont.Id;
		childCase1.AssetId =ast.Id;
		childCase1.ParentId =parentCase.id;
		childCase1.HWS_WarrantyStatus__c=notApplicable;
		childCase1.HWS_ServiceType__c = Advance_Exchange_in_Days;
		childCase1.HWS_Sellable_Product__c = prod.Id;
		childCase1.HWS_Contract_Line_Item__c = cli.Id;
		childCaseList.add(childCase1);
		Case childCase2 = HWS_DataFactory_TEST.insertChildCase();
		childCase2.AccountId = acc.Id;
		childCase2.ContactId = cont.Id;
		childCase2.AssetId =ast.Id;
		childCase2.ParentId =parentCase.id;
		childCase2.HWS_WarrantyStatus__c=OutofWarranty;
		childCase2.HWS_ServiceType__c = Advance_Exchange_in_Days;
		childCase2.HWS_Sellable_Product__c = prod.Id;
		childCase2.HWS_Contract_Line_Item__c = cli.Id;
		childCaseList.add(childCase2);
		
		Case childCase3 = HWS_DataFactory_TEST.insertChildCase();
		childCase3.AccountId = acc.Id;
		childCase3.ContactId = cont.Id;
		childCase3.AssetId =ast.Id;
		childCase3.ParentId =parentCase.id;
		childCase3.HWS_WarrantyStatus__c=notApplicable;
		childCase3.HWS_ServiceType__c = Advance_Exchange_in_Days;
		childCase3.HWS_Sellable_Product__c = prod.Id;
		childCase3.HWS_Contract_Line_Item__c = cli.Id;
		childCaseList.add(childCase3);
		test.startTest();
		try{
			String parentcaseIds = HWS_CaseFlow.createHWSCase(accList,astList,hvList,childCaseList,parentCase,string.valueOf(cont.id),true,Datetime.now(),'(GMT+05:30) India Standard Time (Asia/Kolkata)');
		}catch(Exception e){
			//this is empty
		}  
		HWS_WarrantyQuotation_Controller.WarrantyQuotationWrapper warrantyQuotationWrapper=new HWS_WarrantyQuotation_Controller.WarrantyQuotationWrapper();
		warrantyQuotationWrapper=HWS_WarrantyQuotation_Controller.checkWarrantyQuotationCondition(parentCase.Id,false);
		warrantyQuotationWrapper=HWS_WarrantyQuotation_Controller.checkWarrantyQuotationCondition(parentCase.Id,true);
	}
	public static testmethod void checkWarrantyQuotationCondition3(){
		List<Account> accList = new List<Account>();
		List<Asset> astList = new List<Asset>();
		List<hws_versionitem__c> hvList = new List<hws_versionitem__c>();	 
		List<Case> childCaseList = new List<Case>();
		Id parentCaseId = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_PARENT_CASE);
		Account acc = [Select Id from Account Where Name = 'TestLE' limit 1];
		accList.add(acc);
		Contact cont = [Select Id from Contact limit 1];
		Product2 prod = [Select id from Product2 limit 1];
		Asset ast = [Select id,HWS_ContractLineItem__r.CH_CountryISOName__c from Asset where RecordType.DeveloperName='HWS_Covered_Part' limit 1];
		astList.add(ast);
		hws_versionitem__c hv = [Select id from hws_versionitem__c limit 1];
		hvList.add(hv);
		Case parentCase = HWS_DataFactory_TEST.insertParentCase();
		parentCase.AccountId = accList[0].Id;
		parentCase.ContactId = cont.Id;
		
		Case childCase = HWS_DataFactory_TEST.insertChildCase();
		childCase.AccountId = acc.Id;
		childCase.ContactId = cont.Id;
		childCase.AssetId =ast.Id;
		
		childCase.HWS_WarrantyStatus__c=InWarranty;
		childCase.HWS_ServiceType__c = Advance_Exchange_in_Days;
		childCase.HWS_Sellable_Product__c = prod.Id;
		
		childCaseList.add(childCase);
		Case childCase1 = HWS_DataFactory_TEST.insertChildCase();
		childCase1.AccountId = acc.Id;
		childCase1.ContactId = cont.Id;
		childCase1.AssetId =ast.Id;
		
		childCase1.HWS_WarrantyStatus__c='notApplicable';
		childCase1.HWS_ServiceType__c = Advance_Exchange_in_Days;
		childCase1.HWS_Sellable_Product__c = prod.Id;
		childCaseList.add(childCase1);
		test.startTest();
		try{
			String parentcaseIds = HWS_CaseFlow.createHWSCase(accList,astList,hvList,childCaseList,parentCase,string.valueOf(cont.id),true,Datetime.now(),'(GMT+05:30) India Standard Time (Asia/Kolkata)');
		}catch(Exception e){
			//this is empty
		}  
		HWS_WarrantyQuotation_Controller.WarrantyQuotationWrapper warrantyQuotationWrapper=new HWS_WarrantyQuotation_Controller.WarrantyQuotationWrapper();
		warrantyQuotationWrapper=HWS_WarrantyQuotation_Controller.checkWarrantyQuotationCondition(parentCase.Id,false);
	}
	public static testmethod void checkWarrantyQuotationCondition4(){
		List<Case> childCaseList = new List<Case>();		
		Case parentCase=[Select Id from Case LIMIT 1];
		Account acc = [Select Id from Account Where Name = 'TestLE' limit 1];
		Contact cont = [Select Id from Contact limit 1];
		Product2 prod = [Select id from Product2 limit 1];
		Asset ast = [Select id,HWS_ContractLineItem__r.CH_CountryISOName__c from Asset where RecordType.DeveloperName='HWS_Covered_Part' limit 1];
		hws_versionitem__c hv = [Select id from hws_versionitem__c limit 1];				
		Case childCase = HWS_DataFactory_TEST.insertChildCase();
		childCase.AccountId = acc.Id;
		childCase.ContactId = cont.Id;
		childCase.AssetId =ast.Id;
		childCase.parentId=parentCase.Id;
		childCase.HWS_WarrantyStatus__c=OutofWarranty;
		childCase.HWS_ServiceType__c = Advance_Exchange_in_Days;
		childCase.HWS_Sellable_Product__c = prod.Id;		
		childCaseList.add(childCase);
		insert childCaseList;   
		test.startTest();   
		HWS_WarrantyQuotation_Controller.WarrantyQuotationWrapper warrantyQuotationWrapper=new HWS_WarrantyQuotation_Controller.WarrantyQuotationWrapper();
		warrantyQuotationWrapper=HWS_WarrantyQuotation_Controller.checkWarrantyQuotationCondition(parentCase.Id,false);
		test.stopTest();
	}
	public static testmethod void checkWarrantyQuotationCondition5(){
		List<Case> childCaseList = new List<Case>();		
		Case parentCase=[Select Id from Case LIMIT 1];
		Account acc = [Select Id from Account Where Name = 'TestLE' limit 1];
		Contact cont = [Select Id from Contact limit 1];
		Product2 prod = [Select id from Product2 limit 1];
		Asset ast = [Select id,HWS_ContractLineItem__r.CH_CountryISOName__c from Asset where RecordType.DeveloperName='HWS_Covered_Part' limit 1];
		hws_versionitem__c hv = [Select id from hws_versionitem__c limit 1];				
		Case childCase = HWS_DataFactory_TEST.insertChildCase();
		childCase.AccountId = acc.Id;
		childCase.ContactId = cont.Id;
		childCase.AssetId =ast.Id;
		childCase.parentId=parentCase.Id;
		childCase.HWS_WarrantyStatus__c=notApplicable;
		childCase.HWS_ServiceType__c = Advance_Exchange_in_Days;
		childCase.HWS_Sellable_Product__c = prod.Id;		
		childCaseList.add(childCase);
		Case childCase1 = HWS_DataFactory_TEST.insertChildCase();
		childCase1.AccountId = acc.Id;
		childCase1.ContactId = cont.Id;
		childCase1.AssetId =ast.Id;
		childCase1.parentId=parentCase.Id;
		childCase1.HWS_WarrantyStatus__c='Warranty Unknown';
		childCase1.HWS_ServiceType__c = Advance_Exchange_in_Days;
		childCase1.HWS_Sellable_Product__c = prod.Id;		
		childCaseList.add(childCase1);
		insert childCaseList;   
		test.startTest();   
		HWS_WarrantyQuotation_Controller.WarrantyQuotationWrapper warrantyQuotationWrapper=new HWS_WarrantyQuotation_Controller.WarrantyQuotationWrapper();
		warrantyQuotationWrapper=HWS_WarrantyQuotation_Controller.checkWarrantyQuotationCondition(parentCase.Id,false);
		test.stopTest();
	}
	public static testmethod void checkWarrantyQuotationCondition6(){
		List<Case> childCaseList = new List<Case>();		
		Case parentCase=[Select Id from Case LIMIT 1];
		Account acc = [Select Id from Account Where Name = 'TestLE' limit 1];
		Contact cont = [Select Id from Contact limit 1];
		Product2 prod = [Select id from Product2 limit 1];
		Asset ast = [Select id,HWS_ContractLineItem__r.CH_CountryISOName__c from Asset where RecordType.DeveloperName='HWS_Covered_Part' limit 1];
		hws_versionitem__c hv = [Select id from hws_versionitem__c limit 1];				
		Case childCase = HWS_DataFactory_TEST.insertChildCase();
		childCase.AccountId = acc.Id;
		childCase.ContactId = cont.Id;
		childCase.AssetId =ast.Id;
		childCase.parentId=parentCase.Id;
		childCase.HWS_WarrantyStatus__c=notApplicable;
		childCase.HWS_ServiceType__c = Advance_Exchange_in_Days;
		childCase.HWS_Sellable_Product__c = prod.Id;		
		childCaseList.add(childCase);
		Case childCase1 = HWS_DataFactory_TEST.insertChildCase();
		childCase1.AccountId = acc.Id;
		childCase1.ContactId = cont.Id;
		childCase1.AssetId =ast.Id;
		childCase1.parentId=parentCase.Id;
		childCase1.HWS_WarrantyStatus__c=InWarranty;
		childCase1.HWS_ServiceType__c = Advance_Exchange_in_Days;
		childCase1.HWS_Sellable_Product__c = prod.Id;		
		childCaseList.add(childCase1);
		insert childCaseList;   
		test.startTest();   
		HWS_WarrantyQuotation_Controller.WarrantyQuotationWrapper warrantyQuotationWrapper=new HWS_WarrantyQuotation_Controller.WarrantyQuotationWrapper();
		warrantyQuotationWrapper=HWS_WarrantyQuotation_Controller.checkWarrantyQuotationCondition(parentCase.Id,false);
		test.stopTest();
	}
	public static testmethod void checkWarrantyQuotationCondition7(){
		List<Case> childCaseList = new List<Case>();		
		Case parentCase=[Select Id from Case LIMIT 1];
		Account acc = [Select Id from Account Where Name = 'TestLE' limit 1];
		Contact cont = [Select Id from Contact limit 1];
		Product2 prod = [Select id from Product2 limit 1];
		Asset ast = [Select id,HWS_ContractLineItem__r.CH_CountryISOName__c from Asset where RecordType.DeveloperName='HWS_Covered_Part' limit 1];
		hws_versionitem__c hv = [Select id from hws_versionitem__c limit 1];				
		Case childCase = HWS_DataFactory_TEST.insertChildCase();
		childCase.AccountId = acc.Id;
		childCase.ContactId = cont.Id;
		childCase.AssetId =ast.Id;
		childCase.parentId=parentCase.Id;
		childCase.HWS_WarrantyStatus__c=notApplicable;
		childCase.HWS_ServiceType__c =Advance_Exchange_in_Days;
		childCase.HWS_Sellable_Product__c = prod.Id;		
		childCaseList.add(childCase);
		Case childCase1 = HWS_DataFactory_TEST.insertChildCase();
		childCase1.AccountId = acc.Id;
		childCase1.ContactId = cont.Id;
		childCase1.AssetId =ast.Id;
		childCase1.parentId=parentCase.Id;
		childCase1.HWS_WarrantyStatus__c=InWarranty;
		childCase1.HWS_ServiceType__c = Advance_Exchange_in_Days;
		childCase1.HWS_Sellable_Product__c = prod.Id;		
		childCaseList.add(childCase1);
		Case childCase2 = HWS_DataFactory_TEST.insertChildCase();
		childCase2.AccountId = acc.Id;
		childCase2.ContactId = cont.Id;
		childCase2.AssetId =ast.Id;
		childCase2.parentId=parentCase.Id;
		childCase2.HWS_WarrantyStatus__c=OutofWarranty;
		childCase2.HWS_ServiceType__c = Advance_Exchange_in_Days;
		childCase2.HWS_Sellable_Product__c = prod.Id;		
		childCaseList.add(childCase2);
		
		insert childCaseList;   
		test.startTest();   
		HWS_WarrantyQuotation_Controller.WarrantyQuotationWrapper warrantyQuotationWrapper=new HWS_WarrantyQuotation_Controller.WarrantyQuotationWrapper();
		warrantyQuotationWrapper=HWS_WarrantyQuotation_Controller.checkWarrantyQuotationCondition(parentCase.Id,false);
		test.stopTest();
	}
	public static testmethod void escalateButtonTest(){
		test.startTest();
		Id parentCaseId = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_PARENT_CASE);
		Account acc = [Select Id from Account Where Name = 'TestLE' limit 1];
		Contact cont = [Select Id from Contact limit 1];
		Product2 prod = [Select id from Product2 limit 1];
		Asset ast = [Select id,HWS_ContractLineItem__r.CH_CountryISOName__c from Asset where RecordType.DeveloperName='HWS_Covered_Part' limit 1];
		
		Case parentCase = HWS_DataFactory_TEST.insertParentCase();
		parentCase.RecordTypeId =parentCaseId;
		parentCase.Status='Open';
		parentCase.Subject='test';
		parentCase.Description='test';
		parentCase.HWS_Faulty_Serial_Number__c= 'test1234xasasdddadasdf';
		parentCase.HWS_ShipTopartyId__c='1234566';
		parentCase.AccountId = acc.Id;
		parentCase.ContactId = cont.Id;   
		parentCase.CH_InternalStatus__c='Under Review';
		insert parentCase;
		
		Case childCase = HWS_DataFactory_TEST.insertChildCase();
		childCase.AccountId = acc.Id;
		childCase.ContactId = cont.Id;
		childCase.AssetId =ast.Id;
		childCase.ParentId = parentCase.Id;
		childCase.Status = 'Draft';
		childCase.HWS_Faulty_Serial_Number__c= 'childFault04444addASDDQ';
		childCase.HWS_WarrantyStatus__c=InWarranty;
		childCase.HWS_ServiceType__c = Advance_Exchange_in_Days;  
		childCase.HWS_Sellable_Product__c = prod.Id;
		insert childCase;
		HWS_WarrantyQuotation_Controller.getCaseInfo(parentCase.Id); 
		HWS_WarrantyQuotation_Controller.escalateCases(parentCase.Id,new List<Case>{childCase},false,'');
		test.stopTest();	  
	}
	
	
}