@isTest
/*************************
Description : This is related to  "HWS_CreateSupportTicketportal" class 
Created By  : Vinod T
Created Date: 08-07-2019
Modified By :
Modified Date: 
******************************/
private class HWS_CreateSupportTicketportal_Test {
	
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
		
		PriceBook2 pb = HWS_DataFactory_TEST.createPriceBook();	
		insert pb;   
		
		PriceBookEntry pbety = new PriceBookEntry(
			Pricebook2Id = Test.getStandardPricebookId(),
			Product2Id = prod.id,
			UnitPrice = 0,
			CurrencyIsoCode = 'EUR',
			IsActive = true
		);
		Insert pbety;
		
		ServiceContract sc = HWS_DataFactory_TEST.insertServiceContract(acc1);		
		sc.Pricebook2Id = Test.getStandardPricebookId();
		sc.CurrencyIsoCode = pbety.CurrencyIsoCode;
		insert sc;
		
		ContractLineItem cli = HWS_DataFactory_TEST.insertContractLineItem(sc,pbety);		
		cli.PricebookEntryId = pbety.id;		
		insert cli;
		
		Asset ast = HWS_DataFactory_TEST.insertAsset(acc1,prod);		
		ast.RecordTypeId = assetRecordType;	
		insert ast; 
		
		hws_versionitem__c hwsv = HWS_DataFactory_TEST.insertHwsversionitem();
		hwsv.HWS_Hardware_Sellable_Item__c = prod.Id;
		hwsv.HWS_Serial_Number_Traceable__c='';		
		insert hwsv;
		
		HWS_AlternateProductCode__c apc = new HWS_AlternateProductCode__c();
		apc.Name = 'TEST';
		apc.HWS_VersionItem__c = hwsv.Id;
		insert apc;
		
		Case parentCase = HWS_DataFactory_TEST.insertParentCase();
		parentCase.AccountId = acc1.id;
		insert parentCase;
	}
	
	/*************************
Method Name: ProcessdataMethod
Description : This is related to  "Processdata" method in HWS_CreateSupportTicketportal" class 
Created By  : Vinod T
Created Date: 08-07-2019
Modified By :
Modified Date: 
******************************/
	static testMethod void ProcessdataMethod(){
		string filedata='Part Code/Part Revision,Faulty Serial number,Failure Detection,Failure Description,Failure Occurrence ,Failure Detection Date ,Failure Description/ Server ID,Customer Reference Number,Fault Reported by Name,Fault Reported by Phone,Fault Reported by Email,Site Id'+'\r\n'+'1ABA196350026V1,,Fails on diagnostics�,LED indicates alarm�,During preventive maintenance�,06/24/2019,,,,,,'+'\r\n';
		string objectName ='HWS_BulkUpload__c';
		List<String> fields=new List<String>{'Part_Code_Part_Revision__c','Faulty_Serial_number__c','Fault_Detection__c','Fault_Description__c','Fault_Occurrence__c','Fault_Detection_Date__c','Failure_Description_Server_ID__c','Customer_Reference_Number__c','Fault_Reported_by_Name__c','Fault_Reported_by_Phone__c','Fault_Reported_by_Email__c','Site_Id__c'};
			Account acc = [Select Id from Account where Name = 'TestLE' limit 1 ];		
		HWS_CreateSupportTicketportal.processData(filedata,objectName,fields,acc.Id,'Identical Repair');
	}
	static testMethod void ProcessdataMethodException(){
		string filedata  = 'Part Code/Part Revision,Faulty Serial number,Failure Detection,Failure Description,Failure Occurrence ,Failure Detection Date ,Failure Description/ Server ID,Customer Reference Number,Fault Reported by Name,Fault Reported by Phone,Fault Reported by Email,Site Id\n1ABA196350026V1,,Fails on diagnostics�,LED indicates alarm�,During preventive maintenance�,06/24/2019,,,,,,\n1ABA196350026V1,,Other�,Unit alarm�,During installation / commissioning / Dead On Arrival�,06/22/2019,,,,,,\n1ABA196350026V1,,Reboot module�,SW download failure�,Permanent�,06/23/2019,,,,,,\n1ABA196350026V1,,Non-reproducible�,Feature Activation effect�,During or after lightning / severe weather conditions�,06/21/2019,,,,,,\n1ABA196350026V1,,Reboot module�,Advise for exchange from others�,During high traffic load,06/20/2019,,,,,,\n,,,,,,,,,,,\n,,,,,,,,,,,';
		string objectName ='HWS_BulkUpload__c';
		List<String> fields=new List<String>{'Part_Code_Part_Revision__c','Faulty_Serial_number__c','Fault_Detection__c','Fault_Description__c','Fault_Occurrence__c','Fault_Detection_Date__c','Failure_Description_Server_ID__c','Customer_Reference_Number__c','Fault_Reported_by_Name__c','Fault_Reported_by_Phone__c','Fault_Reported_by_Email__c','Site_Id__c'};
			Account acc = [Select Id from Account where Name = 'TestLE' limit 1 ];		
		HWS_CreateSupportTicketportal.processData(filedata,objectName,fields,acc.Id,'Identical Repair');	
	}
	static testMethod void ProcessdataMethodSemicolon(){
		string filedata  = 'Part Code/Part Revision;Faulty Serial number;Failure Detection;Failure Description;Failure Occurrence;Failure Detection Date;Failure Description/ Server ID;Customer Reference Number;Fault Reported by Name;Fault Reported by Phone;Fault Reported by Email;Site Id\n1ABA196350026V1;;Fails on diagnostics�;LED indicates alarm�;During preventive maintenance�;06/24/2019;;;;;;\n1ABA196350026V1;;Other�;Unit alarm�;During installation / commissioning / Dead On Arrival�;06/22/2019;;;;;;\n1ABA196350026V1,,Reboot module�,SW download failure�,Permanent�,06/23/2019,,,,,,\n1ABA196350026V1,,Non-reproducible�,Feature Activation effect�,During or after lightning / severe weather conditions�,06/21/2019;;;;;;\n1ABA196350026V1;;Reboot module�;Advise for exchange from others�;During high traffic load;06/20/2019,,,,,,\n,,,,,,,,,,,\n,,,,,,,,,,,';
		string objectName ='HWS_BulkUpload__c';
		List<String> fields=new List<String>{'Part_Code_Part_Revision__c','Faulty_Serial_number__c','Fault_Detection__c','Fault_Description__c','Fault_Occurrence__c','Fault_Detection_Date__c','Failure_Description_Server_ID__c','Customer_Reference_Number__c','Fault_Reported_by_Name__c','Fault_Reported_by_Phone__c','Fault_Reported_by_Email__c','Site_Id__c'};
			Account acc = [Select Id from Account where Name = 'TestLE' limit 1 ];		
		HWS_CreateSupportTicketportal.processData(filedata,objectName,fields,acc.Id,'Identical Repair');
	}
	static testMethod void ProcessdataMethodSemicolonNoRows(){
		string filedata  = 'Part Code/Part Revision;Faulty Serial number;Failure Detection;Failure Description;Failure Occurrence;Failure Detection Date;Failure Description/ Server ID;Customer Reference Number;Fault Reported by Name;Fault Reported by Phone;Fault Reported by Email;Site Id';
		string objectName ='HWS_BulkUpload__c';
		List<String> fields=new List<String>{'Part_Code_Part_Revision__c','Faulty_Serial_number__c','Fault_Detection__c','Fault_Description__c','Fault_Occurrence__c','Fault_Detection_Date__c','Failure_Description_Server_ID__c','Customer_Reference_Number__c','Fault_Reported_by_Name__c','Fault_Reported_by_Phone__c','Fault_Reported_by_Email__c','Site_Id__c'};
			Account acc = [Select Id from Account where Name = 'TestLE' limit 1 ];		
		HWS_CreateSupportTicketportal.processData(filedata,objectName,fields,acc.Id,'Identical Repair');
	}
	static testMethod void ProcessdataMethodCama(){
		string filedata='Part Code/Part Revision,Faulty Serial number,Failure Detection,Failure Description,Failure Occurrence ,Failure Detection Date ,Failure Description/ Server ID,Customer Reference Number,Fault Reported by Name,Fault Reported by Phone,Fault Reported by Email,Site Id'+'\r\n'+',,Fails on diagnostics�,LED indicates alarm�,During preventive maintenance�,06/24/2019,,,,,,'+'\r\n';
		string objectName ='HWS_BulkUpload__c';
		List<String> fields=new List<String>{'Part_Code_Part_Revision__c','Faulty_Serial_number__c','Fault_Detection__c','Fault_Description__c','Fault_Occurrence__c','Fault_Detection_Date__c','Failure_Description_Server_ID__c','Customer_Reference_Number__c','Fault_Reported_by_Name__c','Fault_Reported_by_Phone__c','Fault_Reported_by_Email__c','Site_Id__c'};
			Account acc = [Select Id from Account where Name = 'TestLE' limit 1 ];		
		HWS_CreateSupportTicketportal.processData(filedata,objectName,fields,acc.Id,'Identical Repair');
	}
	static testMethod void deleteBulkUploadMethod(){
		string filedata='Part Code/Part Revision,Faulty Serial number,Failure Detection,Failure Description,Failure Occurrence ,Failure Detection Date ,Failure Description/ Server ID,Customer Reference Number,Fault Reported by Name,Fault Reported by Phone,Fault Reported by Email,Site Id'+'\r\n'+'1ABA196350026V1,,Fails on diagnostics�,LED indicates alarm�,During preventive maintenance�,06/24/2019,,,,,,'+'\r\n';
		string objectName ='HWS_BulkUpload__c';
		List<String> fields=new List<String>{'Part_Code_Part_Revision__c','Faulty_Serial_number__c','Fault_Detection__c','Fault_Description__c','Fault_Occurrence__c','Fault_Detection_Date__c','Failure_Description_Server_ID__c','Customer_Reference_Number__c','Fault_Reported_by_Name__c','Fault_Reported_by_Phone__c','Fault_Reported_by_Email__c','Site_Id__c'};
			Account acc = [Select Id from Account where Name = 'TestLE' limit 1 ];
		Map<Boolean, List<Id>> mp = HWS_CreateSupportTicketportal.processData(filedata,objectName,fields,acc.Id,'Identical Repair');
		HWS_CreateSupportTicketportal.deleteBulkUpload(mp.get(true));
	}
	public static testmethod void getSerialNumberInfoTest(){
		List<hws_versionitem__c> hwsvList = new List<hws_versionitem__c>();
		hws_versionitem__c hvs = [Select id from hws_versionitem__c limit 1];
		hwsvList.add(hvs);
		test.startTest();
		//HWS_CreateSupportTicketportal.getSerialNumberInfo(hwsvList);
		HWS_CreateSupportTicketportal.duplicateSerialNumberInfo('test1234','1234');
		test.stopTest();
	}
	
	public static testmethod void getParentAccountIdTest(){
		Contact cont = [Select id from Contact limit 1];
		test.startTest();
		HWS_CreateSupportTicketportal.getParentAccountId(cont.Id);		
		test.stopTest();
	}
	public static testmethod void getAllAccountsTest(){
		Contact cont = [Select id from Contact limit 1];
		test.startTest();
		HWS_CreateSupportTicketportal.getAllAccounts(cont.Id);
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
		HWS_CreateSupportTicketportal.getVersionItems(ast,'abc');
		test.stopTest();
	}
	
	public static testmethod void getVersionsTest1(){
		List<Asset> astList = new List<Asset>();
		Product2 prod = [Select id from Product2 limit 1];
		Asset ast = [Select id from Asset limit 1];
		ast.Product2Id = prod.Id;
		ast.HWS_SourceSystem__c = 'PUMA1';
		update ast;
		astList.add(ast);
		test.startTest();
		HWS_CreateSupportTicketportal.getVersions(astList);
		test.stopTest();
	}
	
	public static testmethod void getContactNameTest(){
		Contact cont = [Select id from Contact limit 1];
		test.startTest();
		HWS_CreateSupportTicketportal.getContactName(cont.Id);
		HWS_CreateSupportTicketportal.getContactType(cont.Id);
		test.stopTest();
	}
	
	public static testmethod void getServiceContractsTest(){
		Id LegalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		Contact cont = [Select id from Contact limit 1];
		List<Account> accList = new List<Account>();
		Account acnt = [Select id from Account limit 1];
		acnt.RecordTypeId =  LegalEntityAccountType;
		acnt.Customer_Compliance__c = 'US_AT&T';
		update acnt;
		accList.add(acnt);
		test.startTest();
		string acctId=string.valueof(acnt.id);
		HWS_CreateSupportTicketportal.getServiceContracts(acctId,'abcd','Advance Exchange in Hours','1234',cont.Id); 
		test.stopTest();
	}
	
	public static testmethod void getCLIOfServiceContractsTest(){
		List<Id> cliIds = new List<Id>();
		List<ContractLineItem> cliList = new List<ContractLineItem>();
		ContractLineItem cli = [Select id from ContractLineItem limit 1];
		Account acc = [Select Id from Account where Name = 'TestLE' limit 1 ];
		cliList.add(cli);
		cliIds.add(cli.Id);
		test.startTest();
		string cliId=string.valueof(cli.id);
		HWS_CreateSupportTicketportal.getCLIOfServiceContracts(cliId);
		HWS_CreateSupportTicketportal.getNEA(acc.Id,cliId,cliIds);
		test.stopTest();
	}
	public static testmethod void plannedDeliveryDateTimeTest(){
		BusinessHours bhs=[select Id from BusinessHours where IsDefault=true];
		test.startTest();
		Date arrivalDate = Date.newInstance(1,1,1);
		Time myTime = Time.newInstance(1, 2, 3, 4);
		string specDate=string.valueOf(myTime);
		HWS_CreateSupportTicketportal.plannedDeliveryDateTime(bhs.Id,'Days','2',arrivalDate,'10');
		HWS_CreateSupportTicketportal.getPickListValues1('Account','Type');
		test.stopTest();
	} 
	
	public static testmethod void createHWSCaseTest(){
		List<Account> accList = new List<Account>();
		List<Asset> astList = new List<Asset>();
		List<hws_versionitem__c> hvList = new List<hws_versionitem__c>();		
		List<Case> childCaseList = new List<Case>();
		Id PARENTCASEID = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_PARENT_CASE);
		Id logisticRecord = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LOGISTIC_ACCOUNT_EXISTING);
		
		Account acc = [Select Id from Account where Name = 'TestLE' limit 1 ];
		accList.add(acc);
		
		Account acc1 = HWS_DataFactory_TEST.insertAccount(); 
		acc1.RecordTypeId =  logisticRecord;
		acc1.Name = 'TestLogistic acc';
		acc1.ParentId = acc.Id;
		acc1.BillingCountry='India';
		acc1.BillingStreet='Test Street';
		acc1.BillingCity='Test City';
		acc1.BillingPostalCode='12345';
		insert acc1;
		
		ContractLineItem cli = [Select Id from ContractLineItem limit 1];
		Contact cont = [Select Id from Contact limit 1]; 
		Product2 prod = [Select id from Product2 limit 1];
		Asset ast = [Select id from Asset limit 1];
		astList.add(ast);
		hws_versionitem__c hv = [Select id from hws_versionitem__c limit 1];
		hvList.add(hv);
		Case parentCase = HWS_DataFactory_TEST.insertParentCase();
		parentCase.AccountId = accList[0].Id;
		parentCase.ContactId = cont.Id;
		parentCase.Hws_Ship_to_Party_Address__c=acc1.Id;
		List<Case> allServTypecase = new List<case>();
		Case childCase = HWS_DataFactory_TEST.insertChildCase();
		childCase.AccountId = acc.Id;
		childCase.ContactId = cont.Id;
		childCase.ParentId = parentCase.Id;
		childCase.HWS_ServiceType__c = 'Advance Exchange in Days';  
		childCase.HWS_Sellable_Product__c = prod.Id;
		childCase.HWS_Communication_Contact__c = cont.id;
		childCase.Subject =cli.id;
		allServTypecase.add(childCase);
		Case childCase1 = HWS_DataFactory_TEST.insertChildCase();
		childCase1.AccountId = acc.Id;
		childCase1.ContactId = cont.Id;
		childCase1.ParentId = parentCase.Id;
		childCase1.HWS_ServiceType__c = 'Identical Repair';  
		childCase1.HWS_Sellable_Product__c = prod.Id;
		childCase1.HWS_Communication_Contact__c = cont.id;
		childCase1.Subject =cli.id;
		allServTypecase.add(childCase1);
		Case childCase2 = HWS_DataFactory_TEST.insertChildCase();
		childCase2.AccountId = acc.Id;
		childCase2.ContactId = cont.Id;
		childCase2.ParentId = parentCase.Id;
		childCase2.HWS_ServiceType__c = 'Spare Part Sales';  
		childCase2.HWS_Sellable_Product__c = prod.Id;
		childCase2.HWS_Communication_Contact__c = cont.id;
		childCase2.Subject =cli.id;
		test.startTest();
		allServTypecase.add(childCase2);  
		
		//childCaseList.add(childCase);
		try{
			//   Datetime caseintitation = system.now();
			HWS_CreateSupportTicketportal.createHWSCasePortal(acc.id,acc1.Id,astList,hvList,allServTypecase,parentCase,cont.id,true,'(GMT+05:30) India Standard Time (Asia/Kolkata)');
		}catch(Exception e){
			String testException = e.getMessage();
		}		
		test.stopTest();
	}
	public static testmethod void ecsalateCaseTest(){ 
		List<Case> childCaseList = new List<Case>();
		List<Id> bussinessHoursId = new List<Id>();
		List<Account> accList = new List<Account>();
		Account acc = [Select id,name from Account limit 1];
		accList.add(acc);
		Contact cont = [Select id from Contact limit 1];
		String escalatestring = 'On Hold:No Contract:Case Escalated to CAPM:'+cont.id; 
		test.startTest();		
		HWS_CreateSupportTicketportal.ecsalateCase(escalatestring,accList);   
		HWS_CreateSupportTicketportal.accountTimeZoneplannedDeliveryDateTime(childCaseList,acc.Id); 
		test.stopTest();		
	}	 
	
	public static testmethod void getContractlineItemsTest(){
		Id LegalAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		Contact cont = [Select id from Contact limit 1];
		List<Id> bussinessHoursId = new List<Id>();
		List<Account> accList = new List<Account>();
		Account acnt = [Select id from Account limit 1];
		acnt.RecordTypeId =  LegalAccountType;
		acnt.Customer_Compliance__c = 'US_AT&T';
		update acnt;
		accList.add(acnt);
		test.startTest();
		HWS_CreateSupportTicketportal.getShipToTimeZone(acnt.Id,bussinessHoursId);
		HWS_CreateSupportTicketportal.getContractlineItems(acnt.id,'TEST','Advance Exchange in Hours','1234',cont.Id,'India');
		test.stopTest();
	}
	
	public static testmethod void getChildCaseDetailsTest(){		
		Case testCase = [Select id from Case limit 1];
		test.startTest();		
		HWS_CreateSupportTicketportal.getChildCaseDetails(testCase.id);		
		test.stopTest();		
	}
	
	public static testmethod void getContactDetailsTest(){		
		test.startTest();		
		HWS_CreateSupportTicketportal.getContactDetails();		
		test.stopTest();		
	} 
	public static testmethod void getRecordTypeTest(){		
		test.startTest();		
		HWS_CreateSupportTicketportal.getRecordType('Advanced Exchange in Hours');		
		test.stopTest();		
	} 
	public static testmethod void getUIThemeDescriptionTest(){		
		test.startTest();		
		HWS_CreateSupportTicketportal.getUIThemeDescription();		
		test.stopTest();		
	} 
	public static testmethod void getCaseStatusTest() {
		Case parentCase = [Select id from Case limit 1];
		test.startTest();
		HWS_CreateSupportTicketportal.getCasStatus(parentCase.Id);		
		test.stopTest();
	}
	public static testmethod void makeSOOCalloutTest(){
		//Id PARENTCASEID = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_PARENT_CASE);		
		Id childRecordType = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_ADVANCE_EXCHANGE_IN_DAYS);		
		Product2 prod = [Select id from Product2 limit 1];
		Account acc = [Select Id from Account where Name = 'TestLE' limit 1 ];
		ContractLineItem cli = [Select Id from ContractLineItem limit 1];
		Asset ast = [Select id from Asset limit 1];
		Case parentCase = [Select id from Case limit 1];
		Case childCase = HWS_DataFactory_TEST.createCase(childRecordType);
		childCase.ParentId=parentCase.Id;
		childCase.AccountId=acc.id;
		childCase.AssetId = ast.Id;
		childCase.HWS_Sellable_Product__c = prod.Id;
		childCase.Subject =cli.id;		
		insert childCase;		
		test.startTest();
		Test.setMock(HttpCalloutMock.class, new HWS_CreateSRHttpCalloutMock(true));
		HWS_CreateSupportTicketportal.makeSOOCalloutBulkRMA(parentCase.Id);
		test.stopTest();
	}
	
	public static testmethod void makeSOOCalloutTestNegative(){
		//Id PARENTCASEID = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_PARENT_CASE);		
		Id childRecordType = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_SPS_PART_SALES);		
		Product2 prod = [Select id from Product2 limit 1];
		Account acc = [Select Id from Account where Name = 'TestLE' limit 1 ];
		ContractLineItem cli = [Select Id from ContractLineItem limit 1];
		Asset ast = [Select id from Asset limit 1];
		Case parentCase = [Select id from Case limit 1];
		Case childCasecreate = HWS_DataFactory_TEST.createCase(childRecordType);
		childCasecreate.ParentId=parentCase.Id;
		childCasecreate.AccountId=acc.id;
		childCasecreate.AssetId = ast.Id;
		childCasecreate.HWS_Sellable_Product__c = prod.Id;
		childCasecreate.Subject =cli.id;		
		insert childCasecreate;		
		test.startTest();
		Test.setMock(HttpCalloutMock.class, new HWS_CreateSRHttpCalloutMock(true));
		HWS_CreateSupportTicketportal.makeSOOCalloutBulkRMA(parentCase.Id);
		test.stopTest();
	}
	
	public static testmethod void makeSOOCalloutTest1(){
		//Id PARENTCASEID = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_PARENT_CASE);		
		Id childRecordType = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_ADVANCE_EXCHANGE_IN_DAYS);		
		Product2 prod = [Select id from Product2 limit 1];
		Account acc = [Select Id from Account where Name = 'TestLE' limit 1 ];
		Contact con = [Select Id from contact limit 1 ];
		ContractLineItem cli = [Select Id from ContractLineItem limit 1];
		Asset ast = [Select id from Asset limit 1];
		Case parentCase = [Select id from Case limit 1];
		Case childCasecrt = HWS_DataFactory_TEST.createCase(childRecordType);
		childCasecrt.ParentId=parentCase.Id;
		childCasecrt.AccountId=acc.id;
		childCasecrt.AssetId = ast.Id;
		childCasecrt.HWS_Sellable_Product__c = prod.Id;
		childCasecrt.Subject =cli.id;
		childCasecrt.HWS_Communication_Contact__c = con.id;
		insert childCasecrt;		
		test.startTest();
		Test.setMock(HttpCalloutMock.class, new HWS_CreateSRHttpCalloutMock(true));
		HWS_CreateSupportTicketportal.makeSOOCalloutBulkRMA(parentCase.Id);
		test.stopTest();
	}
	public static testmethod void makeSOOCalloutPortalTest(){
		//Id PARENTCASEID = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_PARENT_CASE);		
		Id childRecordType = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_ADVANCE_EXCHANGE_IN_DAYS);		
		Product2 prod = [Select id from Product2 limit 1];
		ContractLineItem cli = [select id from ContractLineItem limit 1]; 
		cli.CH_ServiceOffering__c = 'RES RFR PU';
		upsert cli;
		Account acc = [Select Id from Account where Name = 'TestLE' limit 1 ];
		Asset ast = [Select id from Asset limit 1];
		Case parentCase = [Select id,CaseNumber from Case limit 1];
		Case childCse = HWS_DataFactory_TEST.createCase(childRecordType);
		childCse.ParentId=parentCase.Id;
		childCse.AccountId=acc.id;
		childCse.AssetId = ast.Id;
		childCse.HWS_Contract_Line_Item__c = cli.Id;
		childCse.HWS_Sellable_Product__c = prod.Id;
		insert childCse;	 
		List<String> casNumberList = new List<String>();
		casNumberList.add(parentCase.CaseNumber);
		List<Case> childCaseList = new List<Case>();
		childCaseList.add(childCse);
		test.startTest();
		Test.setMock(HttpCalloutMock.class, new HWS_CreateSRHttpCalloutMock(true));
		HWS_CreateSupportTicketportal.makeSOOCallout(parentCase.Id);
		HWS_CreateSupportTicketportal.makeSOOCalloutBulkRMAUpdate(casNumberList,childCaseList);
		HWS_CreateSupportTicketportal.getPayPerUse(parentCase.Id);
		test.stopTest();
	}
	static testMethod void validateFaultyMethod(){
		List<Product2> prodsToInsertLst = new List<Product2>();		
		Product2 prod = HWS_DataFactory_TEST.insertproduct2();
		prod.ProductCode='3HQ14903AAAA';
		prodsToInsertLst.add(prod);
		
		Product2 prodPuma2 = HWS_DataFactory_TEST.insertproduct2();
		prodPuma2.CARE_PartCode__c='5ABTEST';
		prodsToInsertLst.add(prodPuma2);
		
		insert prodsToInsertLst;
		
		List<HWS_versionitem__c> viToInsertLst = new List<HWS_versionitem__c>();
		HWS_versionitem__c hwsv = HWS_DataFactory_TEST.insertHwsversionitem();
		hwsv.HWS_Hardware_Sellable_Item__c = prod.Id;
		hwsv.HWS_Source__c = 'PUMA1';
		hwsv.HWS_Version_Code__c='V1232019';
		viToInsertLst.add(hwsv);
		
		HWS_versionitem__c hwsvPuma2 = HWS_DataFactory_TEST.insertHwsversionitem();
		hwsvPuma2.HWS_Hardware_Sellable_Item__c = prodPuma2.Id;
		hwsvPuma2.HWS_Source__c = 'PUMA2';
		hwsvPuma2.HWS_Version_Code__c='V1232019';
		viToInsertLst.add(hwsvPuma2);
		
		insert viToInsertLst;
		
		List<HWS_BulkUpload__c> bulkToInsertLst = new List<HWS_BulkUpload__c>();
		HWS_BulkUpload__c bu = new HWS_BulkUpload__c();
		bu.Part_Code_Part_Revision__c = '3HQ14903AAAAV1232019';
		bulkToInsertLst.add(bu);
		
		Account acc2=HWS_DataFactory_TEST.createLogisticAccount();
		insert acc2;
		
		HWS_BulkUpload__c bulkupl = new HWS_BulkUpload__c();
		bulkupl.Part_Code_Part_Revision__c = '5ABTEST#V1232019';
		bulkupl.Faulty_Serial_number__c='12345';
		bulkupl.Fault_Detection__c='Reboot Module';
		bulkupl.Fault_Description__c='No TX Power';
		bulkupl.Fault_Occurrence__c='Permanent';
		Date startDate = date.newInstance(2015, 12, 15);
		bulkupl.Fault_Detection_Date__c=startDate;
		bulkupl.HWS_Part_Code__c='5ABTEST';
		bulkupl.HWS_Part_Revision__c='V1232019';
		bulkupl.HWS_Ship_to_Address__c=acc2.id;
		bulkupl.Fault_Reported_by_Email__c='testemai@gmail.com';
		bulkupl.Fault_Reported_by_Phone__c='85698958';
		bulkupl.HWS_ServiceType__c='Identical Repair';
		bulkupl.HWS_Service_Contract_Number__c ='';
		bulkToInsertLst.add(bulkupl);
		
		HWS_BulkUpload__c bu2 = new HWS_BulkUpload__c();
		bu2.Part_Code_Part_Revision__c = '5ABTEST#V1232019';
		bu2.Faulty_Serial_number__c='12345';
		bu2.Fault_Detection__c='Reboot Module';
		bu2.Fault_Description__c='No TX Power';
		bu2.Fault_Occurrence__c='Permanent';
		Date startDate1 = date.newInstance(2015, 12, 15);
		bu2.Fault_Detection_Date__c=startDate1;
		bu2.HWS_Part_Code__c='5ABTEST';
		bu2.HWS_Part_Revision__c='V1232019';
		bu2.HWS_Ship_to_Address__c=acc2.id;
		bu2.Fault_Reported_by_Email__c='testemai@gmail.com';
		bu2.Fault_Reported_by_Phone__c='85698958';
		bu2.HWS_ServiceType__c='Identical Repair';
		bu2.HWS_Service_Contract_Number__c ='test123';
		bulkToInsertLst.add(bu2);
		
		insert bulkToInsertLst;
		HWS_BulkUpload__c buToInstLst=[select id from HWS_BulkUpload__c limit 1];
		List<Id> buLitId = new List<Id>();
		buLitId.add(buToInstLst.id);
		
		Account acnt = [Select id from Account limit 1];
		Contact cont = [Select id from Contact limit 1];
		test.startTest();
		HWS_CreateSupportTicketportal.validateFaulty(bulkToInsertLst,acnt.id,'Identical Repair',cont.id,acc2.Id);
		HWS_CreateSupportTicketportal.setTableData(buLitId);
		//HWS_CreateSupportTicketportal.setFailureDesp(buLitId);
		HWS_CreateSupportTicketportal.updateRMAValues(bulkToInsertLst);
		test.stopTest();
	} 
	
	
	public static testmethod void getResourceURLTest(){
		test.startTest();
		HWS_CreateSupportTicketportal.getResourceURL('BulkRMATemplate');
		test.stopTest();		
	}
	public static testmethod void bulkUploadServiceTypesTest(){
		Id LegalEntityType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		Account legalAcc = [Select id from Account where RecordTypeId =:LegalEntityType limit 1];
		test.startTest();
		HWS_CreateSupportTicketportal.bulkUploadServiceTypes(legalAcc.Id);
		test.stopTest();
	}
	
	public static testmethod void updateStatusforMandatoryFieldsTest(){
		List<HWS_BulkUpload__c> buList = new List<HWS_BulkUpload__c>();
		HWS_BulkUpload__c bukUpload = HWS_DataFactory_TEST.createBulkUpload();
		bukUpload.Fault_Detection__c = '';  
		insert bukUpload;
		buList.add(bukUpload);
		test.startTest();
		HWS_CreateSupportTicketportal.updateStatusforMandatoryFields(buList);
		test.stopTest();		
	}
	public static testmethod void selectShipToAddressTest(){
		Account acc = HWS_DataFactory_TEST.insertAccount();
		insert acc;
		Account logisticAcc = HWS_DataFactory_TEST.createLogisticAccount();
		logisticAcc.ParentId = acc.Id;
		logisticAcc.AccountSource = 'eSpares';
		insert logisticAcc;
		HWS_BulkUpload__c upd = HWS_DataFactory_TEST.createBulkUpload();
		insert upd;
		test.startTest();
		HWS_CreateSupportTicketportal.selectShipToAddress(acc.Id,'eSpares','Test');
		HWS_CreateSupportTicketportal.updateShipToAddress(upd.Id, logisticAcc.Id);
		test.stopTest();	
	}
	public static testmethod void getContractwithPartCodeTest(){
		
		test.startTest();
		Id CusAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.CUSTOMER);
		Id LegalEntityAccount = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		Id AssetRecordType = HWS_Utilty.getRecordTypeByName('Asset','HWS_Covered_Part');
		
		List<String> partcodes = new List<String>{'3hq','123455','5ABTEST'};
			
			Account acc = HWS_DataFactory_TEST.insertAccount(); 
		acc.RecordTypeId =  CusAccountType;	
		insert acc;
		
		Account acc1 = HWS_DataFactory_TEST.insertAccount(); 
		acc1.RecordTypeId =  LegalEntityAccount;
		acc1.Customer_Compliance__c = 'US_AT&T';
		insert acc1;
		
		Contact con1 = HWS_DataFactory_TEST.insertContact();
		con1.AccountId = acc.Id;
		con1.Contact_Status__c = 'Active';
		con1.CH_ContactType__c = 'Customer';
		con1.email='xyz1@example.com';
		insert con1;
		
		BusinessHours stdBusinessHours = [select id, name from BusinessHours where IsDefault=true];
		
		ServiceContract sc = [select id, name from ServiceContract limit 1];		
		
		ContractLineItem cli = [select id from ContractLineItem limit 1];		
		
		Entitlement entiObject = new Entitlement();
		
		entiObject.Name ='test';
		entiObject.AccountId = acc.id;
		entiObject.StartDate = System.today();
		entiObject.EndDate = System.today() + 10;
		entiObject.ContractLineItemId = cli.id;
		entiObject.BusinessHoursId = stdBusinessHours.id;
		entiObject.CH_CDB_EntitlementId__c = 'Test';
		entiObject.ServiceContractId = sc.id;
		
		insert entiObject;
		
		EntitlementContact entitlementContactObj = new EntitlementContact();
		
		entitlementContactObj.EntitlementId = entiObject.Id;
		entitlementContactObj.ContactId = con1.Id;
		
		insert entitlementContactObj;
		
		Account acc2=HWS_DataFactory_TEST.createLogisticAccount();
		insert acc2;
		
		Product2 prod = HWS_DataFactory_TEST.insertproduct2();  
		prod.ProductCode ='5ABTEST';
		insert prod;
		
		Asset ast = HWS_DataFactory_TEST.insertAsset(acc1,prod);  
		ast.HWS_SourceSystem__c = 'Puma1';
		ast.RecordTypeId = AssetRecordType;	
		insert ast; 
		
		List<HWS_BulkUpload__c> bulkupdToInsertLst = new List<HWS_BulkUpload__c>();
		HWS_BulkUpload__c bul = new HWS_BulkUpload__c();
		bul.Part_Code_Part_Revision__c = '123455';
		bulkupdToInsertLst.add(bul);
		
		HWS_BulkUpload__c bkupld = new HWS_BulkUpload__c();
		bkupld.Part_Code_Part_Revision__c = '5ABTEST';
		bkupld.Faulty_Serial_number__c='12345';
		bkupld.Fault_Detection__c='Reboot Module';
		bkupld.Fault_Description__c='No TX Power';
		bkupld.Fault_Occurrence__c='Permanent';
		Date startDate = date.newInstance(2015, 12, 15);
		bkupld.Fault_Detection_Date__c=startDate;
		bkupld.HWS_Part_Code__c='5ABTEST';
		bkupld.HWS_Part_Revision__c='V1232019';
		bkupld.HWS_Ship_to_Address__c=acc2.id;
		bkupld.Fault_Reported_by_Email__c='testemai@gmail.com';
		bkupld.Fault_Reported_by_Phone__c='85698958';
		bkupld.HWS_ServiceType__c='Identical Repair';
		
		bulkupdToInsertLst.add(bkupld);
		
		insert bulkupdToInsertLst;
		
		HWS_CreateSupportTicketportal.validateFaulty(bulkupdToInsertLst,acc.id,'Identical Repair',con1.id,acc2.Id);
		test.stopTest();	
		
	}
	public static testmethod void getContractwithallassetsTest(){
		
		test.startTest();
		Id CustAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.CUSTOMER);
		Id LegalAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		Id AstRecordType = HWS_Utilty.getRecordTypeByName('Asset','HWS_Covered_Part');
		
		List<String> partcodes = new List<String>{'3hq','123455','5ABTEST'};
			
			Account acc = HWS_DataFactory_TEST.insertAccount(); 
		acc.RecordTypeId =  CustAccountType;	
		insert acc;
		
		Account acc1 = HWS_DataFactory_TEST.insertAccount(); 
		acc1.RecordTypeId =  LegalAccountType;
		acc1.Customer_Compliance__c = 'US_AT&T';
		insert acc1;
		
		Contact con1 = HWS_DataFactory_TEST.insertContact();
		con1.AccountId = acc.Id;
		con1.Contact_Status__c = 'Active';
		con1.CH_ContactType__c = 'Customer';
		con1.email='xyz1@example.com';
		insert con1;
		
		BusinessHours stdBusinessHours = [select id, name from BusinessHours where IsDefault=true];
		
		ServiceContract sc = [select id,ContractNumber, name from ServiceContract limit 1];		
		
		ContractLineItem cli = [select id from ContractLineItem limit 1];		
		
		Entitlement entiltObj = new Entitlement();
		
		entiltObj.Name ='test';
		entiltObj.AccountId = acc.id;
		entiltObj.StartDate = System.today();
		entiltObj.EndDate = System.today() + 10;
		entiltObj.ContractLineItemId = cli.id;
		entiltObj.BusinessHoursId = stdBusinessHours.id;
		entiltObj.CH_CDB_EntitlementId__c = 'Test';
		entiltObj.ServiceContractId = sc.id;
		
		insert entiltObj;
		
		EntitlementContact entitlementContactObj = new EntitlementContact();
		
		entitlementContactObj.EntitlementId = entiltObj.Id;
		entitlementContactObj.ContactId = con1.Id;
		
		insert entitlementContactObj;
		
		Account acc2=HWS_DataFactory_TEST.createLogisticAccount();
		insert acc2;
		
		Product2 prod = HWS_DataFactory_TEST.insertproduct2();  
		prod.ProductCode ='5ABTEST';
		insert prod;
		
		Asset asst = HWS_DataFactory_TEST.insertAsset(acc1,prod);  
		asst.HWS_SourceSystem__c = 'Puma1';
		asst.RecordTypeId = AstRecordType;  
		asst.AccountId = acc.Id;
		asst.HWS_ExternalStatus__c='Active';
		asst.product2Id = prod.id;
		//ast.HWS_IsSynced__c =true;
		//ast.Contract_Number__c =sc.ContractNumber;
		//ast.HWS_Service_Type__c ='Identical Repair';
		insert asst; 
		
		List<HWS_BulkUpload__c> bulkToInsrtLst = new List<HWS_BulkUpload__c>();
		HWS_BulkUpload__c bulupld = new HWS_BulkUpload__c();
		bulupld.Part_Code_Part_Revision__c = '123455';
		bulupld.HWS_Part_Code__c='5ABTEST';
		bulkToInsrtLst.add(bulupld);
		
		HWS_BulkUpload__c bu1kup = new HWS_BulkUpload__c();
		bu1kup.Part_Code_Part_Revision__c = '5ABTEST';
		bu1kup.Faulty_Serial_number__c='12345';
		bu1kup.Fault_Detection__c='Reboot Module';
		bu1kup.Fault_Description__c='No TX Power';
		bu1kup.Fault_Occurrence__c='Permanent';
		Date startDate = date.newInstance(2015, 12, 15);
		bu1kup.Fault_Detection_Date__c=startDate;
		bu1kup.HWS_Part_Code__c='5ABTEST';
		bu1kup.HWS_Part_Revision__c='V1232019';
		bu1kup.HWS_Ship_to_Address__c=acc2.id;
		bu1kup.Fault_Reported_by_Email__c='testemai@gmail.com';
		bu1kup.Fault_Reported_by_Phone__c='85698958';
		bu1kup.HWS_ServiceType__c='Identical Repair';
		
		bulkToInsrtLst.add(bu1kup);
		
		insert bulkToInsrtLst;
		
		HWS_CreateSupportTicketportal.validateFaulty(bulkToInsrtLst,acc.id,'Identical Repair',con1.id,acc2.Id);
		test.stopTest();	
		
	}
	public static testmethod void getallassetesTest(){
		
		test.startTest();
		Id CustomrAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.CUSTOMER);
		Id LegAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		Id AsstRecordType = HWS_Utilty.getRecordTypeByName('Asset','HWS_Covered_Part');
		
		List<String> partcodes = new List<String>{'3hq','123455','5ABTEST'};
			
			Account acc = HWS_DataFactory_TEST.insertAccount(); 
		acc.RecordTypeId =  CustomrAccountType;	
		insert acc;
		
		Account acc1 = HWS_DataFactory_TEST.insertAccount(); 
		acc1.RecordTypeId =  LegAccountType;
		acc1.Customer_Compliance__c = 'US_AT&T';
		insert acc1;
		
		Contact con1 = HWS_DataFactory_TEST.insertContact();
		con1.AccountId = acc.Id;
		con1.Contact_Status__c = 'Active';
		con1.CH_ContactType__c = 'Customer';
		con1.email='xyz1@example.com';
		insert con1;
		
		BusinessHours stdBusinessHours = [select id, name from BusinessHours where IsDefault=true];
		
		ServiceContract sc = [select id, name from ServiceContract limit 1];		
		
		ContractLineItem cli = [select id from ContractLineItem limit 1];		
		
		Entitlement entiObj = new Entitlement();
		
		entiObj.Name ='test';
		entiObj.AccountId = acc.id;
		entiObj.StartDate = System.today();
		entiObj.EndDate = System.today() + 10;
		entiObj.ContractLineItemId = cli.id;
		entiObj.BusinessHoursId = stdBusinessHours.id;
		entiObj.CH_CDB_EntitlementId__c = 'Test';
		entiobj.ServiceContractId = sc.id;
		
		insert entiObj;
		
		EntitlementContact entitlementContactObj = new EntitlementContact();
		
		entitlementContactObj.EntitlementId = entiObj.Id;
		entitlementContactObj.ContactId = con1.Id;
		
		insert entitlementContactObj;
		
		Account acc2=HWS_DataFactory_TEST.createLogisticAccount();
		insert acc2;
		
		Product2 prod = HWS_DataFactory_TEST.insertproduct2();  
		prod.ProductCode ='5ABTEST';
		insert prod;
		
		Asset ast1 = HWS_DataFactory_TEST.insertAsset(acc1,prod);  
		ast1.HWS_SourceSystem__c = 'Puma1';
		ast1.RecordTypeId = AsstRecordType;  
		
		insert ast1; 
		
		
		List<HWS_BulkUpload__c> InsertLst = new List<HWS_BulkUpload__c>();
		HWS_BulkUpload__c bu = new HWS_BulkUpload__c();
		bu.Part_Code_Part_Revision__c = '123455';
		bu.HWS_Part_Code__c='123';
		bu.HWS_Contract_Line_Item__c= cli.Id;
		InsertLst.add(bu);
		
		HWS_BulkUpload__c blkupld = new HWS_BulkUpload__c();
		blkupld.Part_Code_Part_Revision__c = '5ABTEST';
		blkupld.Faulty_Serial_number__c='12345';
		blkupld.Fault_Detection__c='Reboot Module';
		blkupld.Fault_Description__c='No TX Power';
		blkupld.Fault_Occurrence__c='Permanent';
		blkupld.HWS_Contract_Line_Item__c= cli.Id;
		Date startDate = date.newInstance(2015, 12, 15);
		blkupld.Fault_Detection_Date__c=startDate;
		blkupld.HWS_Part_Code__c='5ABTEST';
		blkupld.HWS_Part_Revision__c='V1232019';
		blkupld.HWS_Ship_to_Address__c=acc2.id;
		blkupld.Fault_Reported_by_Email__c='testemai@gmail.com';
		blkupld.Fault_Reported_by_Phone__c='85698958';
		blkupld.HWS_ServiceType__c='Identical Repair';
		
		InsertLst.add(blkupld);
		
		insert InsertLst;
		HWS_CreateSupportTicketportal.getAllAssets(InsertLst[0].id,acc.id,'Identical Repair',con1.id);
		HWS_CreateSupportTicketportal.getNetworkElementAsset(InsertLst[0].id,false);
		 HWS_CreateSupportTicketportal.updateNEAValues(ast1,InsertLst[0].id);
		test.stopTest();	
		
	}
	public static testmethod void updateSCValuesTest(){
		
		test.startTest();
		Id CustoAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.CUSTOMER);
		Id EntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		Id RecordType = HWS_Utilty.getRecordTypeByName('Asset','HWS_Covered_Part');
		
		List<String> partcodes = new List<String>{'3hq','123455','5ABTEST'};
			
			Account acc = HWS_DataFactory_TEST.insertAccount(); 
		acc.RecordTypeId =  CustoAccountType;	
		insert acc;
		
		Account acc1 = HWS_DataFactory_TEST.insertAccount(); 
		acc1.RecordTypeId =  EntityAccountType;
		acc1.Customer_Compliance__c = 'US_AT&T';
		insert acc1;
		
		Contact con1 = HWS_DataFactory_TEST.insertContact();
		con1.AccountId = acc.Id;
		con1.Contact_Status__c = 'Active';
		con1.CH_ContactType__c = 'Customer';
		con1.email='xyz1@example.com';
		insert con1;
		
		BusinessHours stdBusinessHours = [select id, name from BusinessHours where IsDefault=true];
		
		ServiceContract sc = [select id, name from ServiceContract limit 1];		
		
		ContractLineItem cli = [select id from ContractLineItem limit 1];		
		
		Entitlement entiObj = new Entitlement();
		
		entiObj.Name ='test';
		entiObj.AccountId = acc.id;
		entiObj.StartDate = System.today();
		entiObj.EndDate = System.today() + 10;
		entiObj.ContractLineItemId = cli.id;
		entiObj.BusinessHoursId = stdBusinessHours.id;
		entiObj.CH_CDB_EntitlementId__c = 'Test';
		entiobj.ServiceContractId = sc.id;
		
		insert entiObj;
		
		EntitlementContact entitlementContactObj = new EntitlementContact();
		
		entitlementContactObj.EntitlementId = entiObj.Id;
		entitlementContactObj.ContactId = con1.Id;
		
		insert entitlementContactObj;
		
		Account acc2=HWS_DataFactory_TEST.createLogisticAccount();
		insert acc2;
		
		Product2 prod = HWS_DataFactory_TEST.insertproduct2();  
		prod.ProductCode ='5ABTEST';
		insert prod;
		
		Asset ast = HWS_DataFactory_TEST.insertAsset(acc1,prod);  
		ast.HWS_SourceSystem__c = 'Puma1';
		ast.RecordTypeId = RecordType;  
		
		insert ast; 
		
		List<HWS_BulkUpload__c> buToInsertLst = new List<HWS_BulkUpload__c>();
		HWS_BulkUpload__c bu = new HWS_BulkUpload__c();
		bu.Part_Code_Part_Revision__c = '123455';
		buToInsertLst.add(bu);
		
		HWS_BulkUpload__c bu1 = new HWS_BulkUpload__c();
		bu1.Part_Code_Part_Revision__c = '5ABTEST';
		bu1.Faulty_Serial_number__c='12345';
		bu1.Fault_Detection__c='Reboot Module';
		bu1.Fault_Description__c='No TX Power';
		bu1.Fault_Occurrence__c='Permanent';
		Date startDate = date.newInstance(2015, 12, 15);
		bu1.Fault_Detection_Date__c=startDate;
		bu1.HWS_Part_Code__c='5ABTEST';
		bu1.HWS_Part_Revision__c='V1232019';
		bu1.HWS_Ship_to_Address__c=acc2.id;
		bu1.Fault_Reported_by_Email__c='testemai@gmail.com';
		bu1.Fault_Reported_by_Phone__c='85698958';
		bu1.HWS_ServiceType__c='Identical Repair';
		
		buToInsertLst.add(bu1);
		
		insert buToInsertLst;
		
		HWS_CreateSupportTicketportal.updateServiceContractValues(ast,buToInsertLst[0].id);
		test.stopTest();	
		
	}
	public static testmethod void createBulkRMACaseTest(){
		Id LegalEntyAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		Id parentCaseRecordType = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_PARENT_CASE_READ_ONLY);		
		Account legalAcc = [Select id from Account where RecordTypeId =:LegalEntyAccountType limit 1];
		Account logAcc=HWS_DataFactory_TEST.createLogisticAccount();
		insert logAcc;
		Contact cont = [Select id from Contact limit 1];
		List<HWS_BulkUpload__c> bulkList = new List<HWS_BulkUpload__c>();
		HWS_BulkUpload__c bu = HWS_DataFactory_TEST.createBulkUpload();
		bu.HWS_Ship_to_Address__c = logAcc.Id;
		bu.Site_Id__c ='test';
		bu.Failure_Description_Server_ID__c ='FSDes';
		bu.HWS_Part_Revision__c = 'ANY';
		bulkList.add(bu);
		insert bulkList;  
		Case parentCase = HWS_DataFactory_TEST.createCase(parentCaseRecordType);
		parentCase.AccountId = legalAcc.Id;
		insert parentCase;
		test.startTest();
		HWS_CreateSupportTicketportal.createBulkRMACase(bulkList,legalAcc.Id,cont.Id,parentCase,'Identical Repair','(GMT+05:30) India Standard Time (Asia/Kolkata)');
		test.stopTest();
	}	
	public static testmethod void getShipToTimeZoneTest(){
		List<Id> businessHourIdList =  new  List<Id>();
		Id customerAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.Customer);
		Account acc = HWS_DataFactory_TEST.insertAccount(); 
		acc.RecordTypeId =  customerAccountType;
		acc.Customer_Compliance__c = 'US_AT&T';
		acc.HWS_TimeZone__c = 'Asia/Kolkata';
		insert acc;
		
		HWS_CaseFlow.getShipToTimeZone(acc.Id,businessHourIdList);
		system.assertNotEquals(acc, null);
	} 
}