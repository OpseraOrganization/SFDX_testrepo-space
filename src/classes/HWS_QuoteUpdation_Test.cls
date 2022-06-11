@isTest
public class HWS_QuoteUpdation_Test{
   @testSetup 
	Public Static void createTestData(){ 
		HWS_GenericSettings__c cs = new HWS_GenericSettings__c();
		cs.Name='OrderedProcessingSize';
		cs.HWS_Field1__c = '25';
		insert cs;
		insert new Global_Control__c(ObjectTriggerByPass__c='Asset,ACCT,CNTCT,ACC_CNTCT_REL,USER,SVCNTRT,ASSET,PRODUCT,CLI,ENT,ACCT, CNTCT, Product,cli,PROD2');
		
		Id accountRecordType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LOGISTIC_ACCOUNT_EXISTING);
		Id legalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		Id childcase = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Child_Case_Read_Only);
		Id parentCaseRecordType = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Parent_Case);
		Id CusAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.CUSTOMER);
		HWS_DataFactory_TEST.createServiceContract(HWS_DataFactory_TEST.createAccount(Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId()).Id);
		
		Account acc = HWS_DataFactory_TEST.insertAccount();
		acc.name='test1';
		acc.Customer_Compliance__c ='US_Govern';
		insert acc;
		Account legalAcc = HWS_DataFactory_TEST.insertAccount(); 
		legalAcc.RecordTypeId =  legalEntityAccountType;
		legalAcc.ParentId = Acc.Id;
		legalAcc.Type = 'Vendor';
		insert legalAcc;
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
		
		
		Account accCustomer = HWS_DataFactory_TEST.insertAccount(); 
		accCustomer.RecordTypeId =  CusAccountType; 
		insert accCustomer;
		Contact con1 = HWS_DataFactory_TEST.insertContact();
		con1.AccountId = accCustomer.Id;
		con1.LastName='TestCon';
		con1.Contact_Status__c = 'Active';
		con1.CH_ContactType__c = 'Customer';
		con1.email='testemai2@test1.com';
		con1.AssistantName = 'Portal Contact';
		con1.Phone='12232432';
		insert con1;
		//HWS_DataFactory_TEST.createPortalUsers();
		//insert parent case					 
		Case ca = new Case();
		ca.RecordTypeId = parentCaseRecordType;
		ca.AccountId = legalAcc.Id;
		ca.Hws_Ship_to_Party_Address__c= acc1.Id;
		ca.Status='Closed';
		ca.Subject='Test Subject';
		ca.Description='test Description';
		ca.HWS_ShipTopartyId__c='1234566';
		ca.Describe__c = 'Test description3';
		ca.Country__c ='United States of America';		 
		insert ca;
		
		Product2 prod = HWS_DataFactory_TEST.insertproduct2();
		prod.ProductCode = '1234';	  
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
		sc.CH_ERPSystem__c = 'P20';
		insert sc;
		
		ContractLineItem cli = HWS_DataFactory_TEST.insertContractLineItem(sc,pbety);	
		cli.PricebookEntryId = pbety.id;   
		cli.CH_CDB_EntitlementId__c= '1918159_40test';	 
		insert cli;
		//insert child case
		Case cas = new Case();
		cas.RecordTypeId = childcase;
		cas.ParentId = ca.Id;
		cas.AccountId = legalAcc.Id;
		cas.Hws_Ship_to_Party_Address__c= acc1.Id;
		cas.HWS_Faulty_Serial_Number__c = '1234'; 
		cas.HWS_FaultyUnitMaterialCode__c = '4567';
		cas.HWS_Shippeddate__c= system.today();
		cas.HWS_LSP_Courier_Name__c = 'Test123';
		cas.HWS_TotalShippedQuantity__c = 1234;
		cas.Describe__c = 'Test description';
		cas.HWS_Sellable_Product__c = prod.Id;
		cas.HWS_Bar_Code__c = 'Test data111';
		cas.HWS_Bar_Code_Ref1__c = HWS_Constants.Test123;  
		cas.HWS_Contract_Line_Item__c= cli.id;				
		insert cas;
		
		User queueUser = new User();
		queueUser.alias = 'CHQueueU';
		queueUser.email = 'testgmail1@mail.com';
		queueUser.emailencodingkey = 'UTF-8';
		queueUser.lastname = 'CH Queue';
		queueUser.languagelocalekey = 'en_US';
		queueUser.localesidkey = 'en_US';
		queueUser.profileid = UserInfo.getProfileId();
		queueUser.Country__c = 'Canada';
		queueUser.timezonesidkey = 'America/Los_Angeles';
		queueUser.Username = 'testgmail2345@randomemail.com';
		insert queueUser;
		
		HWS_DataFactory_TEST.createWGSetupServiceQuote();
		Id dpqRecordTypeId = HWS_Utilty.getRecordTypeByName('HWS_Service_Quote__c','HWS_Damaged_Part_Quote');
		Id childcse = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Child_Case_Read_Only);
		Case getCase = [SELECT Id FROM Case WHERE RecordTypeId =: childcse LIMIT 1];
		
		CH_Workgroup__c cdmWg = [SELECT Id,Name,CH_Type__c FROM CH_Workgroup__c WHERE Name='HWS_EQS-CDM_CDM_NAM_US' LIMIT 1];
		List<HWS_Service_Quote__c> damagedServiceQuoteList = HWS_DataFactory_TEST.createServiceQuote(1,dpqRecordTypeId,false,getCase.Id);
		damagedServiceQuoteList[0].HWS_Workgroup__c = cdmWg.Id;
	  
		damagedServiceQuoteList[0].HWS_Nokia_Email__c='test@gmail.com';
		damagedServiceQuoteList[0].HWS_Quotation_Contact_Email__c = 'test@test.com';
		damagedServiceQuoteList[0].HWS_Support_Ticket__c=cas.id;
		insert damagedServiceQuoteList;
		
		HWS_Service_Quote_Line_Item__c sqli = new HWS_Service_Quote_Line_Item__c();
		sqli.Service_Quote__c=damagedServiceQuoteList[0].id;		
		insert sqli;
		
		 HWS_DataFactory_TEST.createServiceFeeDetails(); 
		HWS_DataFactory_TEST.createServiceFeeDiscount();
	}
	
	  @isTest
	Static void test01() {
	// try{
		Test.startTest();
		List<id> lstdata = new  List<id>();
		List<HWS_Service_Quote__c>lstdd = [Select id from HWS_Service_Quote__c LIMIT 1];
		for(HWS_Service_Quote__c  ob : lstdd){
		lstdata.add(ob.id); 
		}
		HWS_QuoteUpdation.ProcessQuotes(lstdata);
		Test.stopTest();
	// }
	// catch(exception e){
	// system.debug(e.getMessage());
	// }
	}
	
   @isTest
	Static void test02() {
		try{
		Test.startTest();
		List<id> lstdata = new  List<id>();
		List<HWS_Service_Quote__c>lstdd = [Select id,HWS_CDB_ContractLineItemID__c from HWS_Service_Quote__c where HWS_CDB_ContractLineItemID__c !='' LIMIT 1];
		system.debug('<<<HWS_CDB_ContractLineItemID__c ????'+lstdd );
		for(HWS_Service_Quote__c  ob : lstdd){
		lstdata.add(ob.id); 
		}
		HWS_QuoteUpdation.QuoteUpdate(lstdata, true, true);
		Test.stopTest();
		}
		catch(exception e){
		system.debug(e.getMessage());
		}
	}
	
	@isTest
	Static void test03() {
		try{
		Test.startTest();
		List<id> lstdata = new  List<id>();
		List<HWS_Service_Quote__c>lstdd = [Select id,HWS_CDB_ContractLineItemID__c from HWS_Service_Quote__c where HWS_CDB_ContractLineItemID__c !='' LIMIT 1];
		system.debug('<<<HWS_CDB_ContractLineItemID__c ????'+lstdd );
		for(HWS_Service_Quote__c  ob : lstdd){
		lstdata.add(ob.id); 
		}
		HWS_QuoteUpdation.QuoteUpdate(lstdata, false, true );
		Test.stopTest();
		}
		catch(exception e){
		system.debug(e.getMessage());
		}
	}
	
   @isTest
	Static void test04() {
	try{
		Test.startTest();
		List<HWS_Service_Quote__c  > lstQuote = new  List<HWS_Service_Quote__c >();
		List<HWS_Quotation_Exclusion_Mapping__mdt> lstExclusionMeta = new List<HWS_Quotation_Exclusion_Mapping__mdt>();
		map<id, HWS_ServiceFeeDetails__c> quoteToFee = new map<id, HWS_ServiceFeeDetails__c>();
		map<id, HWS_ServiceFee_Discount__c> quoteToDiscount = new map<id, HWS_ServiceFee_Discount__c>();
		list<HWS_ServiceFeeDetails__c> quotelist = [select id,HWS_Product__c,HWS_Status__c ,HWS_SupportedQuoteTypes__c ,HWS_DamagedHWRepairFee__c,HWS_DamagedHWReplacementFee__c,HWS_RepackingHWPackingFee__c,HWS_HWAssessmentFee__c,HWS_DocumentationFee__c,HWS_HWUnreturnedPartFee__c,HWS_OrderCode__c from HWS_ServiceFeeDetails__c limit 1];
		
		for(HWS_ServiceFeeDetails__c qte : quotelist ){
		quoteToFee.put(qte.Id,qte);
		}
		
		for(HWS_ServiceFee_Discount__c dsc : [select id,HWS_Service_Contract__c,HWS_Service_Contract_Line_Item__c,HWS_Service_Assurance_Manager__c,HWS_SupportedQuoteTypes__c ,HWS_Quote_Eligilibilty_Days__c  ,HWS_Unreturned_Part_Discount__c ,HWS_Scope_of_work_Unreturned_Parts_id__c ,HWS_Email_Template__c ,HWS_UnSuspension_Email_Text__c ,HWS_Suspension_Email_Text__c from HWS_ServiceFee_Discount__c limit 1]){
		quoteToDiscount.put(dsc.Id,dsc);
		}
		for(HWS_Service_Quote__c  squot : [SELECT id,HWS_Support_Ticket__c,HWS_Return_Part_Received_Date__c,HWS_Quote_Status__c,HWS_Quote_Status_Reason__c,HWS_Part_Number_Reported__c,HWS_CDB_ContractLineItemID__c,Part_Number_Reported_Id__c,RecordTypeId,HWS_CaresAgreementUniqueId__c,OwnerId,HWS_Quote_Expiration_Days__c,HWS_Order_Code__c,HWS_Quote_Eligibility_Days__c,HWS_Escalation_Manager__c,HWS_Customer_ContactId_1__c,HWS_Quotation_Contact_Email__c,HWS_Quotation_Contact_Phone__c,HWS_Quotation_Contact__c,HWS_Minimal_Quote_Price__c,HWS_WorkGroupType__c,Recordtype.name,HWS_Is_Quotable__c,HWS_LSP_Serial_Number_Received__c,HWS_Earliest_Quotation_Send_Date__c,HWS_Nokia_Email__c,HWS_Customer_Contact_2__c,HWS_Customer_Contact_Email_2__c,  HWS_Customer_ContactId2__c, HWS_Customer_Contact_Phone_2__c from HWS_Service_Quote__c  LIMIT 1]){
		lstQuote.add(squot); 
		}
		
	  
		//public static map<id,boolean> checkForPriceSync(quoteToFee, QuoteToDiscount,lstQuote,lstExclusionMeta,map<id, List<HWS_Service_Quote_Line_Item__c>> QuoteLine ,boolean updateQuoteAndLineItem, boolean runSync)
		
		for(HWS_Quotation_Exclusion_Mapping__mdt QtMdt : [ SELECT id,HWS_Category__c,HWS_eSpares_Part_Number__c,HWS_Order_Code__c,HWS_Price_Type__c,HWS_Price_Type_Description__c,HWS_Reason_Category__c,HWS_Repairable__c,HWS_SRM_Discount_Type__c,HWS_SRM_Price_Type__c FROM HWS_Quotation_Exclusion_Mapping__mdt Limit 1]){
		lstExclusionMeta .add(QtMdt );
		}
		
		
		HWS_QuoteUpdation.checkForPriceSync(quoteToFee, null,lstQuote,lstExclusionMeta,null,  true, true);
		Test.stopTest();
		}
		catch(exception e){
		system.debug(e.getMessage());
		}
	}
	 @isTest
	Static void test05() {
	try{
		Test.startTest();
		List<HWS_Service_Quote__c  > lstQuote = new  List<HWS_Service_Quote__c >();
		List<HWS_Quotation_Exclusion_Mapping__mdt> lstExclusionMeta = new List<HWS_Quotation_Exclusion_Mapping__mdt>();
		map<id, HWS_ServiceFeeDetails__c> quoteToFee = new map<id, HWS_ServiceFeeDetails__c>();
		map<id, HWS_ServiceFee_Discount__c> quoteToDiscount = new map<id, HWS_ServiceFee_Discount__c>();
		list<HWS_ServiceFeeDetails__c> quotelist = [select id,HWS_Product__c,HWS_Status__c ,HWS_SupportedQuoteTypes__c ,HWS_DamagedHWRepairFee__c,HWS_DamagedHWReplacementFee__c,HWS_RepackingHWPackingFee__c,HWS_HWAssessmentFee__c,HWS_DocumentationFee__c,HWS_HWUnreturnedPartFee__c,HWS_OrderCode__c from HWS_ServiceFeeDetails__c limit 1];
		List<Contact> conList= new List<Contact>();
		conList=[select id from contact limit 1];
		for(HWS_ServiceFeeDetails__c qte : quotelist ){
		quoteToFee.put(qte.id,qte);
		}
		for(HWS_Service_Quote__c  squot : [SELECT id,HWS_Support_Ticket__c,HWS_Return_Part_Received_Date__c,HWS_Quote_Status__c,HWS_Quote_Status_Reason__c,HWS_Part_Number_Reported__c,HWS_CDB_ContractLineItemID__c,Part_Number_Reported_Id__c,RecordTypeId,HWS_CaresAgreementUniqueId__c,OwnerId,HWS_Quote_Expiration_Days__c,HWS_Order_Code__c,HWS_Quote_Eligibility_Days__c,HWS_Escalation_Manager__c,HWS_Customer_ContactId_1__c,HWS_Quotation_Contact_Email__c,HWS_Quotation_Contact_Phone__c,HWS_Quotation_Contact__c,HWS_Minimal_Quote_Price__c,HWS_WorkGroupType__c,Recordtype.name,HWS_Is_Quotable__c,HWS_LSP_Serial_Number_Received__c,HWS_Earliest_Quotation_Send_Date__c,HWS_Nokia_Email__c,HWS_Customer_Contact_2__c,HWS_Customer_Contact_Email_2__c,  HWS_Customer_ContactId2__c, HWS_Customer_Contact_Phone_2__c from HWS_Service_Quote__c  LIMIT 1]){
		lstQuote.add(squot); 
		}
		
		for(HWS_ServiceFee_Discount__c dsc : [select id,HWS_Minimal_Quote_Price__c,HWS_Nokia_Email__c,HWS_Customer_Contact_2_Name__c,HWS_Customer_Contact_2_Phone__c,HWS_Customer_Contact_2_Email__c,HWS_Customer_Contact_2__c,HWS_Quotation_Contact_Phone__c,HWS_QuotationContactEmail__c,HWS_Service_Contract__c,HWS_Service_Contract_Line_Item__c,HWS_Service_Assurance_Manager__c,HWS_SupportedQuoteTypes__c ,HWS_Quote_Eligilibilty_Days__c  ,HWS_Unreturned_Part_Discount__c ,HWS_Scope_of_work_Unreturned_Parts_id__c ,HWS_Email_Template__c ,HWS_UnSuspension_Email_Text__c ,HWS_Suspension_Email_Text__c from HWS_ServiceFee_Discount__c limit 1]){
		dsc.HWS_Quote_Expiration_Days__c=7;
		dsc.HWS_Quotation_Contact__c = conList[0].id;
		dsc.HWS_Minimal_Quote_Price__c=6;
		dsc.HWS_Nokia_Email__c='test@test.com';
		quoteToDiscount.put(lstQuote[0].id,dsc);
		}
		
	  
		//public static map<id,boolean> checkForPriceSync(quoteToFee, QuoteToDiscount,lstQuote,lstExclusionMeta,map<id, List<HWS_Service_Quote_Line_Item__c>> QuoteLine ,boolean updateQuoteAndLineItem, boolean runSync)
		
		for(HWS_Quotation_Exclusion_Mapping__mdt QtMdt : [ SELECT id,HWS_Category__c,HWS_eSpares_Part_Number__c,HWS_Order_Code__c,HWS_Price_Type__c,HWS_Price_Type_Description__c,HWS_Reason_Category__c,HWS_Repairable__c,HWS_SRM_Discount_Type__c,HWS_SRM_Price_Type__c FROM HWS_Quotation_Exclusion_Mapping__mdt Limit 1]){
		lstExclusionMeta .add(QtMdt );
		}
		
		
	
		HWS_QuoteUpdation.checkForPriceSync(quoteToFee, quoteToDiscount,lstQuote,lstExclusionMeta,null,  true, true);
		Test.stopTest();
		}
		catch(exception e){
		system.debug(e.getMessage());
		}
	}
	@isTest
	Static void test06() {
	try{
		Test.startTest();
		List<HWS_Service_Quote__c  > lstQuote = new  List<HWS_Service_Quote__c >();
		List<HWS_Quotation_Exclusion_Mapping__mdt> lstExclusionMeta = new List<HWS_Quotation_Exclusion_Mapping__mdt>();
		map<id, HWS_ServiceFeeDetails__c> quoteToFee = new map<id, HWS_ServiceFeeDetails__c>();
		map<id, HWS_ServiceFee_Discount__c> quoteToDiscount = new map<id, HWS_ServiceFee_Discount__c>();
		list<HWS_ServiceFeeDetails__c> quotelist = [select id,HWS_Product__c,HWS_Status__c ,HWS_SupportedQuoteTypes__c ,HWS_DamagedHWRepairFee__c,HWS_DamagedHWReplacementFee__c,HWS_RepackingHWPackingFee__c,HWS_HWAssessmentFee__c,HWS_DocumentationFee__c,HWS_HWUnreturnedPartFee__c,HWS_OrderCode__c from HWS_ServiceFeeDetails__c limit 1];
		List<Contact> conList= new List<Contact>();
		conList=[select id from contact limit 1];
		for(HWS_ServiceFeeDetails__c qte : quotelist ){
		quoteToFee.put(qte.id,qte);
		}
		for(HWS_Service_Quote__c  squot : [SELECT id,HWS_Support_Ticket__c,HWS_Return_Part_Received_Date__c,HWS_Quote_Status__c,HWS_Quote_Status_Reason__c,HWS_Part_Number_Reported__c,HWS_CDB_ContractLineItemID__c,Part_Number_Reported_Id__c,RecordTypeId,HWS_CaresAgreementUniqueId__c,OwnerId,HWS_Quote_Expiration_Days__c,HWS_Order_Code__c,HWS_Quote_Eligibility_Days__c,HWS_Escalation_Manager__c,HWS_Customer_ContactId_1__c,HWS_Quotation_Contact_Email__c,HWS_Quotation_Contact_Phone__c,HWS_Quotation_Contact__c,HWS_Minimal_Quote_Price__c,HWS_WorkGroupType__c,Recordtype.name,HWS_Is_Quotable__c,HWS_LSP_Serial_Number_Received__c,HWS_Earliest_Quotation_Send_Date__c,HWS_Nokia_Email__c,HWS_Customer_Contact_2__c,HWS_Customer_Contact_Email_2__c,  HWS_Customer_ContactId2__c, HWS_Customer_Contact_Phone_2__c from HWS_Service_Quote__c  LIMIT 1]){
		lstQuote.add(squot); 
		}
		
		for(HWS_ServiceFee_Discount__c dsc : [select id,HWS_Minimal_Quote_Price__c,HWS_Nokia_Email__c,HWS_Customer_Contact_2_Name__c,HWS_Customer_Contact_2_Phone__c,HWS_Customer_Contact_2_Email__c,HWS_Customer_Contact_2__c,HWS_Quotation_Contact_Phone__c,HWS_QuotationContactEmail__c,HWS_Service_Contract__c,HWS_Service_Contract_Line_Item__c,HWS_Service_Assurance_Manager__c,HWS_SupportedQuoteTypes__c ,HWS_Quote_Eligilibilty_Days__c  ,HWS_Unreturned_Part_Discount__c ,HWS_Scope_of_work_Unreturned_Parts_id__c ,HWS_Email_Template__c ,HWS_UnSuspension_Email_Text__c ,HWS_Suspension_Email_Text__c from HWS_ServiceFee_Discount__c limit 1]){
		dsc.HWS_Quote_Expiration_Days__c=7;
		dsc.HWS_Quotation_Contact__c = conList[0].id;
		dsc.HWS_Minimal_Quote_Price__c=6;
		dsc.HWS_Nokia_Email__c='test@test.com';
		quoteToDiscount.put(lstQuote[0].id,dsc);
		}
		
	  
		//public static map<id,boolean> checkForPriceSync(quoteToFee, QuoteToDiscount,lstQuote,lstExclusionMeta,map<id, List<HWS_Service_Quote_Line_Item__c>> QuoteLine ,boolean updateQuoteAndLineItem, boolean runSync)
		
		for(HWS_Quotation_Exclusion_Mapping__mdt QtMdt : [ SELECT id,HWS_Category__c,HWS_eSpares_Part_Number__c,HWS_Order_Code__c,HWS_Price_Type__c,HWS_Price_Type_Description__c,HWS_Reason_Category__c,HWS_Repairable__c,HWS_SRM_Discount_Type__c,HWS_SRM_Price_Type__c FROM HWS_Quotation_Exclusion_Mapping__mdt Limit 1]){
		lstExclusionMeta .add(QtMdt );
		}
		
		
	
		HWS_QuoteUpdation.checkForPriceSync(null, quoteToDiscount,lstQuote,lstExclusionMeta,null,  false, true);
		Test.stopTest();
		}
		catch(exception e){
		system.debug(e.getMessage());
		}
	}
	
	 @isTest
	Static void test07() {
	try{
		Test.startTest();
		List<HWS_Service_Quote__c  > lstQuote = new  List<HWS_Service_Quote__c >();
		List<HWS_Quotation_Exclusion_Mapping__mdt> lstExclusionMeta = new List<HWS_Quotation_Exclusion_Mapping__mdt>();
		map<id, HWS_ServiceFeeDetails__c> quoteToFee = new map<id, HWS_ServiceFeeDetails__c>();
		map<id, HWS_ServiceFee_Discount__c> quoteToDiscount = new map<id, HWS_ServiceFee_Discount__c>();
		list<HWS_ServiceFeeDetails__c> quotelist = [select id,HWS_Product__c,HWS_Status__c ,HWS_SupportedQuoteTypes__c ,HWS_DamagedHWRepairFee__c,HWS_DamagedHWReplacementFee__c,HWS_RepackingHWPackingFee__c,HWS_HWAssessmentFee__c,HWS_DocumentationFee__c,HWS_HWUnreturnedPartFee__c,HWS_OrderCode__c from HWS_ServiceFeeDetails__c limit 1];
		List<Contact> conList= new List<Contact>();
		conList=[select id from contact limit 1];
		for(HWS_ServiceFeeDetails__c qte : quotelist ){
		quoteToFee.put(qte.id,qte);
		}
		for(HWS_Service_Quote__c  squot : [SELECT id,HWS_Support_Ticket__c,HWS_Return_Part_Received_Date__c,HWS_Quote_Status__c,HWS_Quote_Status_Reason__c,HWS_Part_Number_Reported__c,HWS_CDB_ContractLineItemID__c,Part_Number_Reported_Id__c,RecordTypeId,HWS_CaresAgreementUniqueId__c,OwnerId,HWS_Quote_Expiration_Days__c,HWS_Order_Code__c,HWS_Quote_Eligibility_Days__c,HWS_Escalation_Manager__c,HWS_Customer_ContactId_1__c,HWS_Quotation_Contact_Email__c,HWS_Quotation_Contact_Phone__c,HWS_Quotation_Contact__c,HWS_Minimal_Quote_Price__c,HWS_WorkGroupType__c,Recordtype.name,HWS_Is_Quotable__c,HWS_LSP_Serial_Number_Received__c,HWS_Earliest_Quotation_Send_Date__c,HWS_Nokia_Email__c,HWS_Customer_Contact_2__c,HWS_Customer_Contact_Email_2__c,  HWS_Customer_ContactId2__c, HWS_Customer_Contact_Phone_2__c from HWS_Service_Quote__c  LIMIT 1]){
		lstQuote.add(squot); 
		}
		
		for(HWS_ServiceFee_Discount__c dsc : [select id,HWS_Minimal_Quote_Price__c,HWS_Nokia_Email__c,HWS_Customer_Contact_2_Name__c,HWS_Customer_Contact_2_Phone__c,HWS_Customer_Contact_2_Email__c,HWS_Customer_Contact_2__c,HWS_Quotation_Contact_Phone__c,HWS_QuotationContactEmail__c,HWS_Service_Contract__c,HWS_Service_Contract_Line_Item__c,HWS_Service_Assurance_Manager__c,HWS_SupportedQuoteTypes__c ,HWS_Quote_Eligilibilty_Days__c  ,HWS_Unreturned_Part_Discount__c ,HWS_Scope_of_work_Unreturned_Parts_id__c ,HWS_Email_Template__c ,HWS_UnSuspension_Email_Text__c ,HWS_Suspension_Email_Text__c from HWS_ServiceFee_Discount__c limit 1]){
		dsc.HWS_Quote_Expiration_Days__c=7;
		dsc.HWS_Quotation_Contact__c = conList[0].id;
		dsc.HWS_Minimal_Quote_Price__c=6;
		dsc.HWS_Nokia_Email__c='test@test.com';
		quoteToDiscount.put(lstQuote[0].id,dsc);
		}
		
	  
		//public static map<id,boolean> checkForPriceSync(quoteToFee, QuoteToDiscount,lstQuote,lstExclusionMeta,map<id, List<HWS_Service_Quote_Line_Item__c>> QuoteLine ,boolean updateQuoteAndLineItem, boolean runSync)
		
		for(HWS_Quotation_Exclusion_Mapping__mdt QtMdt : [ SELECT id,HWS_Category__c,HWS_eSpares_Part_Number__c,HWS_Order_Code__c,HWS_Price_Type__c,HWS_Price_Type_Description__c,HWS_Reason_Category__c,HWS_Repairable__c,HWS_SRM_Discount_Type__c,HWS_SRM_Price_Type__c FROM HWS_Quotation_Exclusion_Mapping__mdt Limit 1]){
		lstExclusionMeta .add(QtMdt );
		}
		
		
	
		HWS_QuoteUpdation.checkForPriceSync(quoteToFee, quoteToDiscount,lstQuote,lstExclusionMeta,null,  true, true);
		Test.stopTest();
		}
		catch(exception e){
		system.debug(e.getMessage());
		}
	}
	 @isTest
	Static void test08() {
	try{
		Test.startTest();
		List<HWS_Service_Quote__c  > lstQuote = new  List<HWS_Service_Quote__c >();
		List<HWS_Quotation_Exclusion_Mapping__mdt> lstExclusionMeta = new List<HWS_Quotation_Exclusion_Mapping__mdt>();
		map<id, HWS_ServiceFeeDetails__c> quoteToFee = new map<id, HWS_ServiceFeeDetails__c>();
		map<id, HWS_ServiceFee_Discount__c> quoteToDiscount = new map<id, HWS_ServiceFee_Discount__c>();
		list<HWS_ServiceFeeDetails__c> quotelist = [select id,HWS_Product__c,HWS_Status__c ,HWS_SupportedQuoteTypes__c ,HWS_DamagedHWRepairFee__c,HWS_DamagedHWReplacementFee__c,HWS_RepackingHWPackingFee__c,HWS_HWAssessmentFee__c,HWS_DocumentationFee__c,HWS_HWUnreturnedPartFee__c,HWS_OrderCode__c from HWS_ServiceFeeDetails__c limit 1];
		map<id,list<HWS_Service_Quote_Line_Item__c>> quoteLi = new map<id,List<HWS_Service_Quote_Line_Item__c>>();
		List<Contact> conList= new List<Contact>();
		conList=[select id from contact limit 1];
	
		for(HWS_Service_Quote__c  squot : [SELECT id,HWS_Support_Ticket__c,HWS_Return_Part_Received_Date__c,HWS_Quote_Status__c,HWS_Quote_Status_Reason__c,HWS_Part_Number_Reported__c,HWS_CDB_ContractLineItemID__c,Part_Number_Reported_Id__c,RecordTypeId,HWS_CaresAgreementUniqueId__c,OwnerId,HWS_Quote_Expiration_Days__c,HWS_Order_Code__c,HWS_Quote_Eligibility_Days__c,HWS_Escalation_Manager__c,HWS_Customer_ContactId_1__c,HWS_Quotation_Contact_Email__c,HWS_Quotation_Contact_Phone__c,HWS_Quotation_Contact__c,HWS_Minimal_Quote_Price__c,HWS_WorkGroupType__c,Recordtype.name,HWS_Is_Quotable__c,HWS_LSP_Serial_Number_Received__c,HWS_Earliest_Quotation_Send_Date__c,HWS_Nokia_Email__c,HWS_Customer_Contact_2__c,HWS_Customer_Contact_Email_2__c,  HWS_Customer_ContactId2__c, HWS_Customer_Contact_Phone_2__c from HWS_Service_Quote__c  LIMIT 1]){
		lstQuote.add(squot); 
		}
		 for(HWS_ServiceFeeDetails__c qte : quotelist ){
		quoteToFee.put(lstQuote[0].id,qte);
		}
		List<HWS_Service_Quote_Line_Item__c> tempSQLi =[SELECT id,HWS_Exclusion_Category__c,HWS_Repairable__c from HWS_Service_Quote_Line_Item__c  LIMIT 1]; 
		 quoteLi.put(lstQuote[0].id,tempSQLi); 
		for(HWS_ServiceFee_Discount__c dsc : [select id,HWS_QuotationContactName__c,HWS_Minimal_Quote_Price__c,HWS_Nokia_Email__c,HWS_Customer_Contact_2_Name__c,HWS_Customer_Contact_2_Phone__c,HWS_Customer_Contact_2_Email__c,HWS_Customer_Contact_2__c,HWS_Quotation_Contact_Phone__c,HWS_QuotationContactEmail__c,HWS_Service_Contract__c,HWS_Service_Contract_Line_Item__c,HWS_Service_Assurance_Manager__c,HWS_SupportedQuoteTypes__c ,HWS_Quote_Eligilibilty_Days__c  ,HWS_Unreturned_Part_Discount__c ,HWS_Scope_of_work_Unreturned_Parts_id__c ,HWS_Email_Template__c ,HWS_UnSuspension_Email_Text__c ,HWS_Suspension_Email_Text__c from HWS_ServiceFee_Discount__c limit 1]){
		dsc.HWS_Quote_Expiration_Days__c=7;
		dsc.HWS_Quotation_Contact__c = conList[0].id;
		dsc.HWS_Minimal_Quote_Price__c=6;
		dsc.HWS_Nokia_Email__c='test@test.com';
		quoteToDiscount.put(lstQuote[0].id,dsc);
		}
		
	  
		//public static map<id,boolean> checkForPriceSync(quoteToFee, QuoteToDiscount,lstQuote,lstExclusionMeta,map<id, List<HWS_Service_Quote_Line_Item__c>> QuoteLine ,boolean updateQuoteAndLineItem, boolean runSync)
		
		for(HWS_Quotation_Exclusion_Mapping__mdt QtMdt : [ SELECT id,HWS_Category__c,HWS_eSpares_Part_Number__c,HWS_Order_Code__c,HWS_Price_Type__c,HWS_Price_Type_Description__c,HWS_Reason_Category__c,HWS_Repairable__c,HWS_SRM_Discount_Type__c,HWS_SRM_Price_Type__c FROM HWS_Quotation_Exclusion_Mapping__mdt Limit 1]){
		lstExclusionMeta .add(QtMdt );
		}
		
		
	
		HWS_QuoteUpdation.checkForPriceSync(quoteToFee, quoteToDiscount,lstQuote,lstExclusionMeta,quoteLi,  true, true);
		Test.stopTest();
		}
		catch(exception e){
		system.debug('<<Error08>>'+e.getMessage());
		}
	}
}