@istest
public class HWS_Utilty_TEST { 
	public static final String  AED = 'Advanced Exchange in Days';  
	public static final String  BD = 'Business Days' ;
	@testSetup static void testDataSetup(){
		Id customerAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.Customer);
		Id legalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		Id assetRecordType = HWS_Utilty.getRecordTypeByName('Asset','HWS_Covered_Part');
		List<ISO_Country_Codes__c> listISO = new List<ISO_Country_Codes__c>();
		ISO_Country_Codes__c setting = new ISO_Country_Codes__c();
		setting.Name = 'IN';
		setting.Country_Name__c = 'India';
		setting.Market__c='Market India' ; 
		listISO.add(setting);
		ISO_Country_Codes__c setting1 = new ISO_Country_Codes__c();
		setting1.Name = 'AG';
		setting1.Country_Name__c = 'Antigua And Barbuda';
		setting1.Market__c='Market Latin America';
		listISO.add(setting1);
		insert listISO;
		Account acc = HWS_DataFactory_TEST.insertAccount() ; 
		acc.RecordTypeId =  customerAccountType;
		acc.Customer_Compliance__c = 'US_AT&T';
		insert acc;
		
		Account acc1 = HWS_DataFactory_TEST.insertAccount(); 
		acc1.RecordTypeId =  legalEntityAccountType;
		acc1.ParentId = acc.Id;
		acc1.Name = 'TestLE';
		acc1.AccountNumber='123456';
		acc1.NCP_P20_ID__c = '123456';
		insert acc1;
		
		Account logisticAcc = HWS_DataFactory_TEST.createLogisticAccount();
		logisticAcc.Name = 'Test Logistic Account';
		logisticAcc.ParentId = acc.Id;
		logisticAcc.AccountSource = 'eSpares';
		logisticAcc.Market__c = 'Market India';
		logisticAcc.BillingStreet='2788 Nieman St,,';
		logisticAcc.BillingCity='San Jose';
		logisticAcc.BillingPostalCode='94404';
		logisticAcc.BillingState='BADEN-WUERTTEMBERG';
		logisticAcc.BillingCountry='Germany';
		insert logisticAcc;
		Contact con = HWS_DataFactory_TEST.insertContact();
		con.AccountId = acc.Id;
		con.Contact_Status__c = 'Active';
		con.CH_ContactType__c = 'Customer';
		con.email='xyz@example.com';
		insert con;
		
		BusinessHours bhs1=[select Id from BusinessHours where IsDefault=false limit 1];
		Product2 prod = HWS_DataFactory_TEST.insertproduct2();   
		prod.ProductCode = 'ABCDEFGH';
		insert prod;			   
		
		PriceBook2 pb = HWS_DataFactory_TEST.createPriceBook(); 
		pb.IsActive = true;
		insert pb;   
		PricebookEntry pbety = HWS_DataFactory_TEST.createPriceBookEntry(prod.id, pb.Id);	   
		pbety.CurrencyIsoCode='EUR'; 
		pbety.UseStandardPrice = false;
		pbety.Pricebook2Id = Test.getStandardPricebookId();
		insert pbety;  
		
		ServiceContract sc = HWS_DataFactory_TEST.insertServiceContract(acc1);	  
		sc.Pricebook2Id = Test.getStandardPricebookId();
		sc.NCP_External_Status__c = 'Active';
		sc.CurrencyIsoCode = 'EUR';
		insert sc;
		
		ContractLineItem cli = HWS_DataFactory_TEST.insertContractLineItem(sc,pbety);	   
		cli.PricebookEntryId = pbety.id;  
		cli.CH_ServiceType__c = AED;
		cli.NCP_External_Status__c='Active';
		cli.CH_ServiceClassification__c='HWS Service';
		cli.CH_BusinessHour__c = bhs1.Id;
		insert cli;
		
		Asset ast = HWS_DataFactory_TEST.insertAsset(acc1,prod);		
		ast.RecordTypeId = assetRecordType;  
		ast.Product2Id = prod.Id;
		ast.HWS_SourceSystem__c = 'Puma1';
		ast.HWS_ContractLineItem__c = cli.Id;
		ast.HWS_ExternalStatus__c = 'Active';
		ast.HWS_ContractLeadTimeUnit__c = BD;
		ast.HWS_ContractLeadTimeDuration__c = '1';
		insert ast; 
		
		HWS_VersionItem__c hwsv = HWS_DataFactory_TEST.insertHwsversionitem();
		hwsv.HWS_Serial_Number_Traceable__c='';  
		hwsv.HWS_Hardware_Sellable_Item__c = prod.Id;
		hwsv.HWS_Source__c = 'PUMA1';
		hwsv.HWS_Version_Code__c = 'ABCDEFGH';
		insert hwsv;
		
		Entitlement ent = new Entitlement();
		ent.Name = 'HWS Advance Exchange in Hours';
		ent.AccountId = acc1.id;
		ent.AssetId = ast.Id;
		ent.CH_CDB_EntitlementId__c = '1234';
		ent.CH_ServiceMappingId__c = 'Advanced Exchange in Hours';
		ent.RecordTypeId = HWS_Utilty.getRecordTypeByName('Entitlement','HWS_Entitlement');
		insert ent;
		
		List<Entitlement> entitlementlist =new List<Entitlement>();
		Entitlement entiObj = new Entitlement();
		entiObj.Name ='test';
		entiObj.CH_ServiceMappingId__c ='Legacy Customer Support Service - Critical Major Minor 24x7';
		entiObj.AccountId =acc1.id;
		entiObj.CH_CDB_EntitlementId__c ='54321';
		entiObj.ServiceContractId= sc.id;
		entiObj.AssetId =ast.id;
		entitlementlist.add(entiObj);
		insert entitlementlist;
		
		Case parentCase = HWS_DataFactory_TEST.insertParentCase();
		parentCase.AccountId = acc1.id;
		insert parentCase;
		
		Case parentCase2= HWS_DataFactory_TEST.insertParentCase();
		parentCase2.AccountId = acc1.id;
		parentCase2.HWS_Sellable_Product__c = prod.Id;
		parentCase2.status = 'Open'; 
		insert parentCase2; 
		
		
	}
	
	public static testmethod void getTestMethods(){
		Account acc = [Select Id from Account where Name = 'TestLE'];
		Account logisticAcc = [Select Id from Account where Name = 'Test Logistic Account'];
		Contact cont = [Select Id from Contact limit 1];
		
		Set<Id> accIdSet = new Set<Id>();
		accIdSet.add(acc.Id);
		List<String> shiptoAddrList = new List<String>();
		shiptoAddrList.add(logisticAcc.Id);
		List<Profile> p= [SELECT Id FROM Profile WHERE Name='Nokia Sales Profile'];
		test.startTest();
		HWS_Utilty.getAccounts(accIdSet);
		HWS_Utilty.getAccountContactsRelation(cont.Id,acc.Id);
		
		if(p.size()>0){
			User u = new User(Alias = 'standt', Email='standdarduser@testorgg.com',
			EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
			LocaleSidKey='en_US', ProfileId = p[0].Id,
			TimeZoneSidKey='America/Los_Angeles',
			 UserName='82948393@user.com');
			if(u != null){
				System.runAs(u) {
					HWS_Utilty.accountToShare(shiptoAddrList);
				}
			}
		}
		else{
			HWS_Utilty.accountToShare(shiptoAddrList);
		}
		
		HWS_Utilty.accountToShare(shiptoAddrList);
		HWS_Utilty.getEntitlementContact(cont.Id,acc.Id);
		HWS_Utilty.getCasesByCaseNumber(new List<String>{'123456'});
		test.stopTest();
	} 

	public static testmethod void getAllServiceTypesTest(){
		Account acc = [Select Id from Account where Name = 'TestLE'];
		Contact cont = [Select Id from Contact limit 1];
		Product2 prod = [Select Id from Product2 limit 1];
		Set<Id> accIdSet = new Set<Id>();
		accIdSet.add(acc.Id);
		Set<Id> prodIdSet = new Set<Id>();
		prodIdSet.add(prod.Id);
		Set<String> authServContrNumSet = new Set<String>();
		authServContrNumSet.add('abcd');
		test.startTest();
		HWS_Utilty.getAllServiceTypes(prodIdSet,accIdSet);
		HWS_Utilty.getAllServiceTypes(prodIdSet,accIdSet,AED,'00000052',cont.Id, 'Slovakia');
		HWS_Utilty.getAllServiceTypesAuthLegalEntity(prodIdSet,accIdSet,AED,'00000052',authServContrNumSet);
		test.stopTest();
	}
	
	public static testmethod void plannedDeliveryDateTimeTest(){
		BusinessHours bhs=[select Id from BusinessHours where IsDefault=true];
		
		Date dTest=Date.valueof(system.today());
		test.startTest();
		HWS_Utilty.plannedDeliveryDateTime(bhs.ID,BD,'10',dTest,null);
		HWS_Utilty.plannedDeliveryDateTime(bhs.ID,'Hours','10',dTest,null);
		HWS_Utilty.plannedDeliveryDateTime(bhs.ID,'Minutes','10',dTest,null);
		HWS_Utilty.plannedDeliveryDateTime(bhs.ID,BD,'10',dTest,'2:10');
		HWS_Utilty.plannedDeliveryDateTime(bhs.ID,'Calendar Days','10',dTest,'2:10');
		HWS_Utilty.plannedDeliveryDateTime(bhs.ID,'Calendar Days','10',dTest,null);
		test.stopTest();
	}
	
	public static testmethod void getVersionItemsTest(){
		
		Product2 prod = [Select Id from Product2 limit 1];
		Set<Id> sellableItemIdSet = new Set<Id>();
		List<String> versionCodeList = new List<String>();
		sellableItemIdSet.add(prod.Id); 
		versionCodeList.add('test');
		test.startTest();
		HWS_Utilty.getVersionItems(sellableItemIdSet,'PUMA1',versionCodeList);
		HWS_Utilty.childRecordTypes('Advanced Exchange In Hours');
		HWS_Utilty.getGmtValue(6);
		test.stopTest();
	}
	
	public static testmethod void getserviceContractsTest(){
		Account acc = [Select Id from Account where Name = 'TestLE'];
		Contact cont = [Select Id from Contact limit 1];
		ContractLineItem cli = [Select Id from ContractLineItem limit 1];
		Product2 prod = [Select Id from Product2 limit 1];
		Set<Id> accIdSet = new Set<Id>();
		accIdSet.add(acc.Id);
		Set<Id> cliIdSet = new Set<Id>();
		cliIdSet.add(cli.Id);
		Set<Id> prodIdSet = new Set<Id>();
		prodIdSet.add(prod.Id);
		test.startTest();
		HWS_Utilty.getserviceContracts('00000052',accIdSet,AED,'00000052',cont.Id);
		HWS_Utilty.getserviceContractsInactive('00000052',accIdSet,AED);
		HWS_Utilty.getserviceContractsPortal('00000052',acc.Id,AED,'00000052',cont.Id);
		HWS_Utilty.getserviceContractsInactivePortal('00000052',acc.Id, AED);
		HWS_Utilty.getServiceTypes(cliIdSet);
		HWS_Utilty.getAllServiceTypesPortal(prodIdSet,acc.Id,AED,'00000052',cont.Id, 'Slovakia');
		HWS_Utilty.getDependentMap(acc,'BillingCountryCode','BillingStateCode','Slovakia');
		test.stopTest();
	}
	
	public static testmethod void getContractlineItemsPartCodeRevisionTest(){
		Account acc = [Select Id from Account where Name = 'TestLE'];
		Contact cont = [Select Id from Contact limit 1];
		HWS_VersionItem__c hvi = [Select Id,HWS_Version_Code__c from HWS_VersionItem__c limit 1];
		List<Account> accList = new List<Account>();
		accList.add(acc);
		test.startTest();
		HWS_Utilty.getContractlineItemsPartCodeRevision(accList,'ABCDEFGH', AED,'00000052',cont.Id,'Portal', 'Slovakia');
		hvi.HWS_Version_Code__c = 'ANY';
		update hvi;
		HWS_Utilty.getContractlineItemsPartCodeRevision(accList,'ABCDEFGH', AED,'00000052',cont.Id,'Portal', 'Slovakia' );
		test.stopTest();
	}
	public static testmethod void accountTimeZoneplannedDeliveryDateTimeTest(){
		
		
		Account acc = [Select Id from Account where Name = 'Test Logistic Account'];
		Asset assetRec = [Select Id,HWS_ContractLineItem__r.CH_BusinessHour__c from Asset];
		Case childCasetoInsert = HWS_DataFactory_TEST.insertChildCase();
		childCasetoInsert.AssetId= assetRec.Id;
		List<Case>  listCase = new List<Case>();
		listCase.add(childCasetoInsert);
		test.startTest();

		HWS_Utilty.accountTimeZoneplannedDeliveryDateTime(listCase,'Asia/Kolkata');
		HWS_Utilty.accountTimeZoneplannedDeliveryDateTime(listCase,'America/Puerto_Rico');
		HWS_Utilty.updateTimeZone(acc.Id);
		HWS_Utilty.HWS_postGoogleErrorToChatter('Google Api Error!!!');
		test.stopTest();
	}
	
	 public static testmethod void getCLIOfServiceContractsTest(){
		List<Id> cliIds = new List<Id>();
		List<ContractLineItem> cliList = new List<ContractLineItem>();
		ContractLineItem cli = [Select id from ContractLineItem limit 1];
		Account acc = [Select Id from Account where Name = 'TestLE' limit 1 ];
		cliList.add(cli);
		cliIds.add(cli.Id);
		Integer recordLimit=100;
		Integer recordOffset=0;
		String searchText='test';
		test.startTest();
		string cliId=string.valueof(cli.id);
		HWS_CreateSupportTicketportal.getCLIOfServiceContracts(cliId);
		HWS_CreateSupportTicketportal.getNEA(acc.Id,cliId,cliIds,recordLimit,recordOffset,searchText);
		test.stopTest();
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
		Test.startTest(); 
		insert caseRecOrdered;
		chldLst.add(caseRecOrdered);
		
		Test.setMock(HttpCalloutMock.class, new HWS_CancelSRHttpCalloutMock());
		HWS_Utilty.cancelChildCases(parntLst[0].Id,HWS_Constants.REQUESTED_BY_CUSTOMER,'Test','console');
		HWS_Utilty.cancelChildCases(chldLst[0].Id,HWS_Constants.REQUESTED_BY_CUSTOMER,'Test','portal');
			  
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
		 Test.startTest();
		insert caseRecOrdered ;
		
		
		Test.setMock(HttpCalloutMock.class, new HWS_CancelSRHttpCalloutMock());
		HWS_Utilty.cancelChildCases(parentCase.id,HWS_Constants.REQUESTED_BY_CUSTOMER,'Test','console');
		HWS_Utilty.cancelChildCases(caseRecOrdered.id,HWS_Constants.REQUESTED_BY_CUSTOMER,'Test','portal');
		  
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
		 Test.startTest();
		insert caseRecOrdered ;	 
		
		Test.setMock(HttpCalloutMock.class, new HWS_CancelSRHttpCalloutMock());
		HWS_Utilty.cancelChildCases(caseRecOrdered.id,HWS_Constants.REQUESTED_BY_CUSTOMER,'Test','console');
		 
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
		 Test.startTest(); 
		insert caseRecOrdered ;	 
	   
		Test.setMock(HttpCalloutMock.class, new HWS_CancelSRHttpCalloutMock());	 
		
		caseRecOrdered.Status ='Shipped';
		update caseRecOrdered;
		HWS_Utilty.cancelChildCases(caseRecOrdered.id,HWS_Constants.REQUESTED_BY_CUSTOMER,'Test','console');
	
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
		 Test.startTest(); 
		insert caseRecOrdered ;
	   
		Test.setMock(HttpCalloutMock.class, new HWS_CancelSRHttpCalloutMock());
		HWS_Utilty.cancelChildCases(caseRecOrdered.id,HWS_Constants.REQUESTED_BY_CUSTOMER,'Test','console');
	 
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
		 Test.startTest(); 
		insert chldLst;
	   
		Test.setMock(HttpCalloutMock.class, new HWS_CancelSRHttpCalloutMock());	 
		HWS_Utilty.cancelChildCases(chldLst[0].Id,HWS_Constants.REQUESTED_BY_CUSTOMER,'Test','console');		  
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
		 Test.startTest(); 
		insert chldLst;
	   
		Test.setMock(HttpCalloutMock.class, new HWS_CancelSRHttpCalloutMock());	 
	  
		chldLst[0].Status ='Ordered';
		update chldLst;

		HWS_Utilty.cancelChildCases(parntLst[0].Id,HWS_Constants.REQUESTED_BY_CUSTOMER,'Test','console');
		HWS_Utilty.cancelChildCases(chldLst[0].Id,HWS_Constants.REQUESTED_BY_CUSTOMER,'Test','portal');
		HWS_Utilty.getChildCaseDetails(parntLst[0].Id);
		Test.stopTest();  
	}
	
	
	public static testmethod void testgetContractlineItems(){
		Account acc = [Select Id from Account where Name = 'TestLE' limit 1 ];
		Contact cont = [Select Id,name from Contact limit 1];
		cont.Contact_Status__c='Active';
		Test.startTest(); 
		HWS_Utilty.getContractlineItems(acc.Id, 'test', 'test', cont.name, (string)cont.Id, 'test', 'Console');
		HWS_Utilty.getAllAccounts(cont,'Portal');
		Test.stopTest(); 
	}
	
	 public static testmethod void getSerialNumberInfoTest(){
		List<hws_versionitem__c> hwsvList = new List<hws_versionitem__c>();
		hws_versionitem__c hvs = [Select id from hws_versionitem__c limit 1];
		hwsvList.add(hvs);
		test.startTest();
		HWS_Utilty.duplicateSerialNumberInfo('test1234','1234');
		test.stopTest();
	}
	public static testmethod void updateParentInternalStatusTest(){
		Case parentCase = [Select id from Case where status = 'Open' limit 1];
	 
		Test.startTest();	   
		Set<id> lstst = new set<id>();
		lstst.add(parentCase.Id);
		HWS_Utilty.updateParentInternalStatus(lstst);
		HWS_Utilty.getCreatableFieldsSOQL('case');
		
	   Test.stopTest();
	}
	
	public static testmethod void makeSOOCalloutTest(){	 
		Id childRecordType = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_ADVANCE_EXCHANGE_IN_DAYS);	 
		Product2 prod = [Select id from Product2 limit 1];
		Account acc = [Select Id,AccountNumber from Account where Name = 'TestLE' limit 1 ];
		System.debug('AccountNumber-'+acc);
		ContractLineItem cli = [Select Id from ContractLineItem limit 1];
		Asset ast = [Select id from Asset limit 1];
		Case parentCase = [Select id from Case limit 1];
		Case childCase = HWS_DataFactory_TEST.createCase(childRecordType);
		childCase.ParentId=parentCase.Id;
		childCase.AccountId=acc.id;
		childCase.AssetId = ast.Id;
		childCase.HWS_Sellable_Product__c = prod.Id;
		childCase.Subject =cli.id; 
		 test.startTest();
		insert childCase;	   
	   
		Test.setMock(HttpCalloutMock.class, new HWS_SendWarrantyCheckRequesttoSOO_Test(true,''));
		HWS_Utilty.makeSOOCallout(parentCase.Id,null);
		Date myDate = Date.newInstance(1960, 2, 17);
		HWS_ParentCase_WRAPPER.convetDate(myDate);
		Time myTime = Time.newInstance( 3, 3, 3, 0 );
		DateTime objDT = DateTime.newInstance( myDate, myTime );
		HWS_ParentCase_WRAPPER.convetDateTime(objDT);
		HWS_ParentCase_WRAPPER wrapObj = new HWS_ParentCase_WRAPPER(childCase,'P20','Advanced Exchange in Hours','Customer via', '123456', true, '123456');
		HWS_ParentCase_WRAPPER wrapObj1 = new HWS_ParentCase_WRAPPER(childCase,'eSpares','Advanced Exchange in Hours','Customer', '123456', true, '123456');
	HWS_ParentCase_WRAPPER wrapObj2 = new HWS_ParentCase_WRAPPER(childCase,'eSpares','Advanced Exchange in Hours','Customer via Partner', '123456', true, '123456');
	HWS_ParentCase_WRAPPER wrapObj3 = new HWS_ParentCase_WRAPPER(childCase,'P20','Advanced Exchange in Hours','Customer via Partner', '123456', true, '123456');
		test.stopTest();
	}
	
}