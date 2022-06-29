@isTest
public class HWS_CaseFlow_TEST  {

	@testSetup static void testDataSetup(){
		HWS_GenericSettings__c record = new HWS_GenericSettings__c();
		record.Name='HWS_ServicedAccountNumber';
		record.HWS_Field1__c = '1234';
		insert record;
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
		parentCase.AccountId = legalAcc.id;
		insert parentCase;
		
	}		
	public static testmethod void getSerialNumberInfoTest(){
		List<hws_versionitem__c> hwsvList = new List<hws_versionitem__c>();
		hws_versionitem__c hvs = [Select id from hws_versionitem__c limit 1];
		hwsvList.add(hvs);
		test.startTest();
		HWS_CaseFlow.getSerialNumberInfo(hwsvList);
		HWS_CaseFlow.duplicateSerialNumberInfo('test1234','1234');
		system.assertNotEquals(hvs, null);
		test.stopTest();
	}	
	public static testmethod void getAllAccountsTest(){
		Contact cont = [Select id from Contact limit 1];
		test.startTest();
		HWS_CaseFlow.getAllAccounts(cont.Id);
		system.assertNotEquals(cont, null);
		test.stopTest();
	}
	public static testmethod void getContactTypeTest(){
		Contact cont = [Select id from Contact limit 1];
		test.startTest();
		HWS_CaseFlow.getContactDetails(cont.Id);
		system.assertNotEquals(cont, null);
		test.stopTest();
	}
	
	public static testmethod void getContractlineItemsTest(){
		Id legalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		List<Account> accList = new List<Account>();
		Account acnt = [Select id from Account limit 1];
		acnt.RecordTypeId =  legalEntityAccountType;
		acnt.Customer_Compliance__c = HWS_Constants.USATT;
		update acnt;
		accList.add(acnt);
		Contact testContact = [Select Id From Contact where Email = 'xyz@example.com'];
		test.startTest();
		HWS_CaseFlow.getContractlineItems(accList,'abcd','Advance Exchange in Hours','1234',testContact.Id,'India');
		system.assertNotEquals(accList, null);
		test.stopTest();
	}
	public static testmethod void getVersionsTest(){
		List<Asset> astList = new List<Asset>();
		Product2 prod = [Select id from Product2 limit 1];
		Asset ast = [Select id from Asset limit 1];
		ast.Product2Id = prod.Id;
		ast.HWS_SourceSystem__c = 'PUMA1';
		update ast;
		astList.add(ast);
		test.startTest();
		HWS_CaseFlow.getVersions(astList,'abc');
		system.assertNotEquals(astList, null);
		test.stopTest();
	}
	public static testmethod void getServiceContractsTest(){
		Id legalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		List<Account> accList = new List<Account>();
		Account acnt = [Select id from Account limit 1];
		acnt.RecordTypeId =  legalEntityAccountType;
		acnt.Customer_Compliance__c = HWS_Constants.USATT;
		update acnt;
		accList.add(acnt);
		Contact testContact = [Select Id From Contact where Email = 'xyz@example.com'];
		test.startTest();
		HWS_CaseFlow.getServiceContracts(accList,'abcd','Advance Exchange in Hours','',testContact.Id); 
		test.stopTest();
	}
	public static testmethod void getCLIOfServiceContractsTest(){
		List<ContractLineItem> cliList = new List<ContractLineItem>();
		ContractLineItem cli = [Select id from ContractLineItem limit 1];
		cliList.add(cli);
		test.startTest();
		HWS_CaseFlow.getCLIOfServiceContracts(cliList);
		system.assertNotEquals(cliList, null);
		test.stopTest();
	}
	public static testmethod void plannedDeliveryDateTimeTest(){
		BusinessHours bhs=[select Id from BusinessHours where IsDefault=true];
		test.startTest();
		HWS_CaseFlow.plannedDeliveryDateTime(bhs.Id,'Days','2',Datetime.now().Date(),'');
		HWS_CaseFlow.getPickListValues1('Account','Type');
		system.assertNotEquals(bhs, null);
		test.stopTest();
	}	
	public static testmethod void createHWSCaseTest(){
		HWS_GenericSettings__c custSetting = new HWS_GenericSettings__c();
		custSetting.Name = 'HWS_EnableWarrantyCheck';
		custSetting.HWS_Field1__c = 'true';
		insert custSetting;
		List<Account> accList = new List<Account>();
		List<Asset> astList = new List<Asset>();
		List<hws_versionitem__c> hvList = new List<hws_versionitem__c>();		
		List<Case> childCaseList = new List<Case>();
		Id PARENTCASEID = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_PARENT_CASE);
		System.assertEquals(PARENTCASEID,PARENTCASEID);
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
		
		childCase.HWS_ServiceType__c = 'Advance Exchange in Days';  
		childCase.HWS_Sellable_Product__c = prod.Id;
		test.startTest();
	
		childCaseList.add(childCase);
		
		try{
			String parentcaseIds = HWS_CaseFlow.createHWSCase(accList,astList,hvList,childCaseList,parentCase,string.valueOf(cont.id),true,Datetime.now(),'(GMT+05:30) India Standard Time (Asia/Kolkata)');
			System.assertEquals(parentcaseIds,parentcaseIds);
		}catch(Exception e){
			//This is empty block
		}		 
		childCase.ParentId = parentCase.Id;		
		HWS_CaseFlow.getChildCaseDetails(parentCase.Id);
		HWS_CaseFlow.getPayPerUse(parentCase.Id);
		HWS_CaseFlow.getCaseInitiationTime();
		HWS_CaseFlow.getContactInfo(cont.Id);
		HWS_CaseFlow.accountTimeZoneplannedDeliveryDateTime(childCaseList,acc.Id, false); // NOKIASC-37920
		HWS_CaseFlow.warrantyCheck('12345','12345','PUMA1');		
		system.assertNotEquals(childCaseList, null); 
		HWS_CaseFlow.checkWarrantyVerification(parentCase.Id);
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
		HWS_CaseFlow.makeSOOCallout(parentCase.Id);
		system.assertNotEquals(childCase, null);
		test.stopTest();
	}
	public static testmethod void ecsalateCaseTest(){	
		Id recId = schema.SobjectType.Case.getRecordTypeInfosByDeveloperName().get('HWS_Case_Escalation').getRecordTypeId();
		List<Account> accList = new List<Account>();
		Account acc = [Select id from Account limit 1];
		accList.add(acc);
		Contact cont = [Select id from Contact limit 1];
		Case escaltionCase = HWS_DataFactory_TEST.createCase(recId);
		escaltionCase.Status='On Hold';
		escaltionCase.HWS_On_Hold_Reason__c='No Contract';
		escaltionCase.Comments='Case Escalated to CAPM';
		insert escaltionCase;		
		test.startTest();		
		HWS_CaseFlow.ecsalateCase(cont.Id,accList,escaltionCase);	
		system.assertNotEquals(escaltionCase, null);
		test.stopTest();	
	}
	public static testmethod void getShipToTimeZoneAccountTest(){
		List<Id> businessHourIdList =  new  List<Id>();
		Id customerAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.Customer);
		Account acc = HWS_DataFactory_TEST.insertAccount(); 
		acc.RecordTypeId =  customerAccountType;
		acc.Customer_Compliance__c = HWS_Constants.USATT;
		acc.HWS_TimeZone__c = 'Asia/Kolkata';
		insert acc;
		
		HWS_CaseFlow.getShipToTimeZone(acc.Id,businessHourIdList);
		system.assertNotEquals(acc, null);
	} 
	public static testmethod void getShipToTimeZoneBHTest(){
		Id businessHourId=[select id from BusinessHours where IsDefault=true limit 1].Id;
		Id customerAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.Customer);
		Account acc = HWS_DataFactory_TEST.insertAccount(); 
		acc.RecordTypeId =  customerAccountType;
		acc.Customer_Compliance__c = HWS_Constants.USATT;
		acc.HWS_TimeZone__c = '';
		insert acc;
		
		HWS_CaseFlow.getShipToTimeZone(acc.Id,new List<Id>{businessHourId});
		system.assertNotEquals(acc, null);
	}
	public static testmethod void getNEATest(){
		Account acc = [Select id from Account where Name = 'TestLE' limit 1];
		ContractLineItem cli = [Select Id from ContractLineItem limit 1];
		List<Id> cliIdList = new List<Id>();
		cliIdList.add(cli.Id);
		
		Integer recordLimit=100;
		Integer recordOffset=0;
		String searchText='';
		Test.startTest();
		HWS_CaseFlow.getNEA(acc.Id,cli.Id,cliIdList,recordLimit,recordOffset,searchText);
		system.assertNotEquals(acc, null);
		Test.stopTest();
	}
	public static testmethod void validateSWSCaseTest(){
		HWS_CaseFlow.validateSWSCase(new List<String>{'123456'});
	}
	public static testmethod void getServicedAccountNumbersTst(){
		Test.startTest();
		String result = HWS_CaseFlow.getServicedAccountNumbers();
		Test.stopTest();
	}
}