@istest
public class HWS_Utilty_TEST {
	@testSetup static void testDataSetup(){
		Id customerAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.Customer);
		Id legalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		Id assetRecordType = HWS_Utilty.getRecordTypeByName('Asset','HWS_Covered_Part');
		List<ISO_Country_Codes__c> listISO = new List<ISO_Country_Codes__c>();
		ISO_Country_Codes__c setting = new ISO_Country_Codes__c();
		setting.Name = 'IN';
		setting.Country_Name__c = 'India';
		setting.Market__c='Market India';
		listISO.add(setting);
		ISO_Country_Codes__c setting1 = new ISO_Country_Codes__c();
		setting1.Name = 'AG';
		setting1.Country_Name__c = 'Antigua And Barbuda';
		setting1.Market__c='Market Latin America';
		listISO.add(setting1);
		insert listISO;
		Account acc = HWS_DataFactory_TEST.insertAccount(); 
		acc.RecordTypeId =  customerAccountType;
		acc.Customer_Compliance__c = 'US_AT&T';
		insert acc;
		
		Account acc1 = HWS_DataFactory_TEST.insertAccount(); 
		acc1.RecordTypeId =  legalEntityAccountType;
		acc1.ParentId = acc.Id;
		acc1.Name = 'TestLE';
		insert acc1;
		
		Account logisticAcc = HWS_DataFactory_TEST.createLogisticAccount();
		logisticAcc.Name = 'Test Logistic Account';
		logisticAcc.ParentId = acc.Id;
		logisticAcc.AccountSource = 'eSpares';
		logisticAcc.Market__c = 'Market India';
		insert logisticAcc;
		Contact con = HWS_DataFactory_TEST.insertContact();
		con.AccountId = acc.Id;
		con.Contact_Status__c = 'Active';
		con.CH_ContactType__c = 'Customer';
		con.email='xyz@example.com';
		insert con;
		
		BusinessHours bhs=[select Id from BusinessHours where IsDefault=true];
		BusinessHours bhs1=[select Id from BusinessHours where IsDefault=false limit 1];
		Product2 prod = HWS_DataFactory_TEST.insertproduct2();   
		prod.ProductCode = 'ABCDEFGH';
		insert prod;			   
		
		PriceBook2 pb = HWS_DataFactory_TEST.createPriceBook(); 
		pb.IsActive = true;
		insert pb;   
		//Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true];		
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
		cli.CH_ServiceType__c = 'Advanced Exchange in Days';
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
		ast.HWS_ContractLeadTimeUnit__c = 'Business Days';
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
		insert ent;
		
		EntitlementContact entContact = new EntitlementContact();
		entContact.EntitlementId = ent.Id;
		entContact.ContactId = con.Id;
		insert entContact;
		
		Case parentCase = HWS_DataFactory_TEST.insertParentCase();
		parentCase.AccountId = acc1.id;
		insert parentCase;
	}
	
	public static testmethod void getTestMethods(){
		Account acc = [Select Id from Account where Name = 'TestLE'];
		Account logisticAcc = [Select Id from Account where Name = 'Test Logistic Account'];
		Contact cont = [Select Id from Contact limit 1];
		Set<Id> accIdSet = new Set<Id>();
		accIdSet.add(acc.Id);
		List<String> shiptoAddrList = new List<String>();
		shiptoAddrList.add(logisticAcc.Id);
		test.startTest();
		HWS_Utilty.getAccounts(accIdSet);
		HWS_Utilty.getAccountContactsRelation(cont.Id,acc.Id);
		HWS_Utilty.accountToShare(shiptoAddrList);
		HWS_Utilty.getEntitlementContact(cont.Id,acc.Id);
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
		HWS_Utilty.getAllServiceTypes(prodIdSet,accIdSet,'Advanced Exchange in Days','00000052',cont.Id, 'Slovakia');
		HWS_Utilty.getAllServiceTypesAuthLegalEntity(prodIdSet,accIdSet,'Advanced Exchange in Days','00000052',authServContrNumSet);
		test.stopTest();
	}
	
	public static testmethod void plannedDeliveryDateTimeTest(){
		BusinessHours bhs=[select Id from BusinessHours where IsDefault=true];
		List<BusinessHours> bHours=new List<BusinessHours>();
		Date dTest=Date.valueof(system.today());
		test.startTest();
		HWS_Utilty.plannedDeliveryDateTime(bhs.ID,'Business Days','10',dTest,null);
		HWS_Utilty.plannedDeliveryDateTime(bhs.ID,'Hours','10',dTest,null);
		HWS_Utilty.plannedDeliveryDateTime(bhs.ID,'Minutes','10',dTest,null);
		HWS_Utilty.plannedDeliveryDateTime(bhs.ID,'Business Days','10',dTest,'2:10');
		HWS_Utilty.plannedDeliveryDateTime(bhs.ID,'Calendar Days','10',dTest,'2:10');
		HWS_Utilty.plannedDeliveryDateTime(bhs.ID,'Calendar Days','10',dTest,null);
		test.stopTest();
	}
	
	public static testmethod void getVersionItemsTest(){
		HWS_VersionItem__c hvi = [Select Id from HWS_VersionItem__c limit 1];
		Product2 prod = [Select Id from Product2 limit 1];
		Set<Id> sellableItemIdSet = new Set<Id>();
		List<String> versionCodeList = new List<String>();
		sellableItemIdSet.add(prod.Id); 
		versionCodeList.add('test');
		test.startTest();
		HWS_Utilty.getVersionItems(sellableItemIdSet,'PUMA1',versionCodeList);
		HWS_Utilty.childRecordTypes('Advanced Exchange In Hours');
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
		HWS_Utilty.getserviceContracts('00000052',accIdSet,'Advanced Exchange in Days','00000052',cont.Id);
		HWS_Utilty.getserviceContractsInactive('00000052',accIdSet,'Advanced Exchange in Days');
		HWS_Utilty.getserviceContractsPortal('00000052',acc.Id,'Advanced Exchange in Days','00000052',cont.Id);
		HWS_Utilty.getserviceContractsInactivePortal('00000052',acc.Id,'Advanced Exchange in Days');
		HWS_Utilty.getServiceTypes(cliIdSet);
		HWS_Utilty.getAllServiceTypesPortal(prodIdSet,acc.Id,'Advanced Exchange in Days','00000052',cont.Id, 'Slovakia');
		HWS_Utilty.getDependentMap(acc,'BillingCountryCode','BillingStateCode');
		test.stopTest();
	}
	
	public static testmethod void getContractlineItemsPartCodeRevisionTest(){
		Account acc = [Select Id from Account where Name = 'TestLE'];
		Contact cont = [Select Id from Contact limit 1];
		HWS_VersionItem__c hvi = [Select Id,HWS_Version_Code__c from HWS_VersionItem__c limit 1];
		List<Account> accList = new List<Account>();
		accList.add(acc);
		test.startTest();
		HWS_Utilty.getContractlineItemsPartCodeRevision(accList,'ABCDEFGH','Advanced Exchange in Days','00000052',cont.Id,'Portal', 'Slovakia');
		hvi.HWS_Version_Code__c = 'ANY';
		update hvi;
		HWS_Utilty.getContractlineItemsPartCodeRevision(accList,'ABCDEFGH','Advanced Exchange in Days','00000052',cont.Id,'Portal', 'Slovakia' );
		test.stopTest();
	}
	 /*@isTest
		public static void plannedDeliveryDateTimeBulkTest(){
		 
		 BusinessHours bhs=[select Id from BusinessHours where IsDefault=true];
			
		List<HWS_BulkUpload__c> buToInsertLst = new List<HWS_BulkUpload__c>();
		HWS_BulkUpload__c bu = new HWS_BulkUpload__c();
		bu.Part_Code_Part_Revision__c = '3HQ14903AAAAV1232019';
		bu.HWS_ServiceType__c = 'Advanced Exchange in Days';
		buToInsertLst.add(bu);
		Date dTest=Date.valueof(system.today());
			
		List<BusinessHours> brToInsertLst = new List<BusinessHours>();
	   BusinessHours br = new BusinessHours();
		  br.Name='VI | Mon-Fri 0800-1800 | America/Puerto_Rico | H';
		  br.TimeZoneSidKey='(GMT-04:00) Atlantic Standard Time (America/Puerto_Rico)';
		  brToInsertLst.add(br);
	   
			
		bu.Part_Code_Part_Revision__c = 'aDM5C00000000W8WAI';
		bu.HWS_ServiceType__c = 'Return for Repair or Replacement';
		bu.HWS_Asset__c	='02i5C000001rR6EQAU';
		bu.HWS_Contract_Line_Item__c  ='8115C000000LVU2QAO';
		buToInsertLst.add(bu);
		test.startTest();
			
		HWS_Utilty.plannedDeliveryDateTimeBulk(buToInsertLst);
	   
		test.stopTest();
	}*/
	public static testmethod void accountTimeZoneplannedDeliveryDateTimeTest(){
		List<BusinessHours> listBusinessHours = [SELECT Id,TimeZoneSidKey,Name FROM BusinessHours];
		Account acc1 = [Select Id from Account where Name = 'TestLE'];
		
		Account acc = [Select Id from Account where Name = 'Test Logistic Account'];
		Asset assetRec = [Select Id,HWS_ContractLineItem__r.CH_BusinessHour__c from Asset];
		Case childCasetoInsert = HWS_DataFactory_TEST.insertChildCase();
		childCasetoInsert.AssetId= assetRec.Id;
		List<Case>  listCase = new List<Case>();
		listCase.add(childCasetoInsert);
		test.startTest();
		//CollaborationGroup BHConversion = new CollaborationGroup(Name = 'Error - BH Conversion', CollaborationType = 'Private', CanHaveGuests = false, IsArchived = false, IsAutoArchiveDisabled = true );
		//insert BHConversion;
		HWS_Utilty.accountTimeZoneplannedDeliveryDateTime(listCase,'Asia/Kolkata');
		HWS_Utilty.accountTimeZoneplannedDeliveryDateTime(listCase,'America/Puerto_Rico');
		HWS_Utilty.updateTimeZone(acc.Id);
		HWS_Utilty.HWS_postGoogleErrorToChatter('Google Api Error!!!');
		test.stopTest();
	}
}