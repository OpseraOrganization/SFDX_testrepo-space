@isTest
public class HWS_DataFactory_TEST{
	Public Static User runAsUser = new User(Id = UserInfo.getUserId());
	public static final string testemail = 'test001@test.com';
	public static integer NokiaId = 100;
	// Method  is used to insert Account record @Govardhan
	public static Account insertAccount ( )
	{
		Account acc = new Account();
		Id legalEntity = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		acc.RecordTypeId = legalEntity;
		acc.name='test';
		acc.P20_Logistic_ID__c= 'test11';
		acc.HWS_Address_Status__c = HWS_Constants.Permanent_Address;
		return acc;
	} 
	// Method  is used to insert Contact record @Govardhan
	public static Contact insertContact (){
		Contact con = new Contact(); 
		con.LastName='test';
		con.Contact_Status__c='Active';
		con.CH_ContactType__c='Customer';
		con.email='abc@example.com';
		return con;
	}
	// Method  is used to insert Contact record  @Govardhan
	public static AccountContactRelation insertAccountContactRelation (Account acc, Contact con){
		
		AccountContactRelation accCon= new AccountContactRelation();
		accCon.AccountId= acc.id;
		accCon.ContactId=con.id;
		return accCon;
		
	}
	
	// Method  is used to insert Asset record   
	public static Asset insertAsset (Account acc, Product2 prod){
		Asset ast = new Asset();
		ast.name='Test Asset';
		ast.AccountId= acc.Id;
		ast.Product2Id = prod.Id;		
		return ast;		
	}
	
	// Method  is used to insert ServiceContract record   @Govardhan
	public static ServiceContract insertServiceContract (Account acc1){
		ServiceContract sContrct = new ServiceContract();
		sContrct.name='test';
		sContrct.AccountId= acc1.Id;
		return sContrct;
		
	}
	
	// Method  is used to insert product2 record	@Govardhan
	public static product2 insertproduct2 (){
		product2 pr2 = new product2();
		Id rtId = Schema.SObjectType.product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Sales_Product').getRecordTypeId();
		pr2.RecordTypeId =rtId;
		pr2.Name ='test';
		pr2.IsActive = true;
		pr2.Description='test';
		
		return pr2;
	}
	
	// Method  is used to insert PricebookEntry record   @Govardhan
	public static PricebookEntry insertPricebookEntry(product2 pr2){   
		
		List<PricebookEntry> pbEntryList = new List<PricebookEntry>();
		PricebookEntry pbety = new PricebookEntry();
		pbety.Pricebook2Id=pbety.Id;
		pbety.CurrencyIsoCode='EUR';
		pbety.IsActive=true;
		pbety.Product2Id=pr2.id;
		pbety.UseStandardPrice=false;
		pbety.UnitPrice = 100;
		pbEntryList.add(pbety);  
		return null; 
	}
	
	// Method  is used to insert ContractLineItem record   @Govardhan
	
	public static ContractLineItem insertContractLineItem (ServiceContract sContrct, PricebookEntry pbety){
		
		ContractLineItem cli=new ContractLineItem();
		cli.UnitPrice=1.00;
		cli.Quantity=1.00;
		cli.ServiceContractId= sContrct.id;
		return cli;
	}
	
	// Method  is used to insert Hws Versionitem record
	public static hws_versionitem__c insertHwsversionitem (){
		hws_versionitem__c hwvitem =new  hws_versionitem__c();
		hwvitem.Name='test';
		hwvitem.HWS_Serial_Number_Traceable__c='Yes';
		hwvitem.HWS_Material_Type__c ='123';
		hwvitem.Material_Code__c= '1234';
		hwvitem.HWS_Version_Code__c='test';
		return hwvitem;
	}
	
	// Method  is used to insert ParentCase record	@Govardhan
	public static Case insertParentCase (){
		Case caserec = new Case();
		Id parentCase = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_PARENT_CASE);
		system.debug('PARENTCASE*'+parentCase);
		for(integer i=1;i<100;i++){
			caserec.RecordTypeId =parentCase;
			caserec.Status='Closed';
			caserec.Subject='test'+i;
			caserec.Description='test' +i;
			caserec.HWS_Faulty_Serial_Number__c= 'test1234';
			caserec.HWS_ShipTopartyId__c='1234566';
		}
		return caserec;
	}
	
	// Method  is used to insert ChildCase record Account acc, HWS_VersionItem__c hwvitem	@Govardhan
	public static Case insertChildCase (){
		Case caserec = new Case();
		Id exchangeInDays = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Advance_Exchange_In_Days);
		system.debug('exchangeInDays*'+exchangeInDays);
		for(integer i=1;i<100;i++){
			caserec.RecordTypeId =exchangeInDays;
			caserec.Status='Closed';
			caserec.Subject='test'+i;
			caserec.Description='test' +i;
			caserec.HWS_Faulty_Serial_Number__c= 'test1234';
			caserec.HWS_ShipTopartyId__c='1234566';
		}
		return caserec;
	}
	// Method  is used to insert ChildCase record Account acc, HWS_VersionItem__c hwvitem	@Govardhan
	public static Case insertSPSChildCase (){
		Case caserec = new Case();
		Id spsCase = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_SPS_PART_SALES);
		
		for(integer i=1;i<100;i++){
			caserec.RecordTypeId =spsCase;
			caserec.Status='Ordered';
			caserec.Subject='test'+i;
			caserec.Description='test' +i;
			caserec.HWS_Faulty_Serial_Number__c= 'test1234';
			caserec.HWS_ShipTopartyId__c='1234566';
			
		}
		return caserec;
	}
	//Inserting Product Serviceble Vertion Item object @Govardhan Feb 17nth
	public static HWS_Product_Serviceable_Version_Item__c prodctServiceVitem (){
		
		HWS_Product_Serviceable_Version_Item__c prdSerVitem = new HWS_Product_Serviceable_Version_Item__c();
		
		prdSerVitem.HWS_EDP_ActiveStatus__c = true ;
		prdSerVitem.HWS_EDP_DeletedAtSource__c = true ;
		// prdSerVitem.LastModifiedDate = System.TODAY();  HWS_NSNCode__c
		prdSerVitem.HWS_FITRate__c = 'test';
		prdSerVitem.HWS_MaterialType__c = 'test';
		prdSerVitem.HWS_PartRevision__c = 'test';
		prdSerVitem.HWS_NSNCode__c = '13242';
		return prdSerVitem;
	}
	
	//Inserting Product Serviceble Vertion Item object @Govardhan Feb 17nth
	/*public static Product_Serviceable_Relations__c prodctServiceRelation (){

Product_Serviceable_Relations__c PrdSerRel = new Product_Serviceable_Relations__c();
PrdSerRel.HWS_EDPActiveStatus__c = true;
PrdSerRel.HWS_EDPActiveStatus__c = true;
PrdSerRel.HWS_EDPDeletedAtSource__c = true;
PrdSerRel.HWS_HWSSIPartNumber__c = 'test';
PrdSerRel.Name = 'test';

return PrdSerRel;
}*/
	
	//Ajesh Methods starts
	// Method  is used to insert Account record
	public static Account createAccountRec ( )
	{
		Account acc = new Account();
		Id customer = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.CUSTOMER);
		acc.RecordTypeId = customer;
		acc.name='test';
		acc.P20_Logistic_ID__c= 'test11';
		acc.HWS_Address_Status__c = HWS_Constants.Permanent_Address;
		return acc;
	} 
	
	// Method  is used to insert Contact record
	public static Contact createContactRec (Account acc){
		Contact con = new Contact(); 
		con.LastName='test';
		con.Contact_Status__c='Active';
		con.CH_ContactType__c='Communication Contact';
		con.email='abc@example.com';
		con.AccountId=acc.id;
		return con;
	}
	
	//Ends
	// Vinod Methods start
	Public Static Account createAccount(Id recordType){
		Account acc = new Account();
		acc.RecordTypeId=recordType;
		acc.Name='Test Account';
		return acc;
	}
	Public Static Contact createContact(Id accountId){
		Contact con = new Contact();
		con.AccountId=accountId;
		con.FirstName='Test';
		con.LastName='Contact';
		return con;
	}
	Public Static AccountContactRelation createRelatedAccount(Id contactID, Id accountId){
		AccountContactRelation accCon = new AccountContactRelation();
		accCon.AccountId=accountId;
		accCon.ContactId=contactID;
		return accCon;
	}
	Public Static Product2 creteProduct(Id recordType){
		Product2 prod = new Product2();
		prod.RecordTypeId=recordType;
		prod.Name='Test Product';
		prod.ProductCode='833-022515_00';
		return prod;
	}
	Public Static PriceBook2 createPriceBook(){
		PriceBook2 pb = new PriceBook2();
		pb.Name='HWS Price Book';
		return pb;
	}
	Public Static PriceBookEntry createPriceBookEntry(Id product, Id priceBook){
		PriceBookEntry pbe = new PriceBookEntry();
		pbe.Product2Id=product;
		pbe.Pricebook2Id=priceBook;
		pbe.UnitPrice=100;
		pbe.IsActive=true;
		return pbe;
	}
	Public Static ServiceContract createServiceContract(Id accountId){
		ServiceContract sc = new ServiceContract();
		sc.AccountId=accountId;
		sc.Name='Exchange in Days';
		sc.HWS_SalesOrganisation__c='AWB';
		return sc;
	}
	Public Static ContractLineItem createContractLineItems(Id contract, Id priceBookEntry){
		ContractLineItem cl = new ContractLineItem();
		cl.priceBookEntryId=priceBookEntry;
		cl.ServiceContractId=contract;
		cl.Quantity=1;
		cl.UnitPrice=100;
		return cl;
	}
	Public Static HWS_VersionItem__c createVerionsItems(Id sellableProd){
		HWS_VersionItem__c vi = new HWS_VersionItem__c();
		vi.Name='Test Verion Item';
		vi.HWS_Serial_Number_Traceable__c ='No';
		vi.HWS_Hardware_Sellable_Item__c=sellableProd;
		return vi;
	}
	Public Static Case createCase(Id recordType){
		Case newCase = new Case();
		newCase.RecordTypeId=recordType;
		newCase.Subject='Test Subject';
		newCase.Description='Test desc';
		return newCase;
	}
	// Vinod Methods end
	// Start changes by Pavan
	public static Account createLogisticAccount  ( )
	{
		Account acc = new Account();
		Id logisticAccount = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LOGISTIC_ACCOUNT_EXISTING);
		acc.RecordTypeId = logisticAccount;
		acc.Acc_No__c = '2345';
		acc.P20_Logistic_ID__c = '1234';
		acc.name='test';
		acc.P20_Logistic_ID__c= 'test11';
		acc.HWS_Address_Status__c = HWS_Constants.Permanent_Address;
		acc.BillingCountry = 'India';
		acc.BillingStreet = 'Test';
		acc.BillingCity ='Test';
		acc.BillingPostalCode = '1234';
		return acc;
	} 
	// Ends changes by Pavan
	public static HWS_BulkUpload__c createBulkUpload (){
		HWS_BulkUpload__c bu1 = new HWS_BulkUpload__c();
		bu1.Part_Code_Part_Revision__c = '5ABTEST#V1232019';
		bu1.Faulty_Serial_number__c='12345';
		bu1.Fault_Detection__c='Reboot Module';
		bu1.Fault_Description__c='No TX Power';
		bu1.Fault_Occurrence__c='Permanent';
		Date startDate = date.newInstance(2015, 12, 15);
		bu1.Fault_Detection_Date__c=startDate;
		bu1.HWS_Part_Code__c='5ABTEST';
		bu1.HWS_Part_Revision__c='V1232019';
		bu1.Fault_Reported_by_Email__c='testemai@gmail.com';
		bu1.Fault_Reported_by_Phone__c='85698958';
		bu1.HWS_ServiceType__c='Identical Repair';
		bu1.HWS_Service_Contract_Number__c ='test123';
		return bu1;
	}
	Static Public Void CreateWorkgroups(){
		CH_Settings__c settingForROTASchedule = new CH_Settings__c ();
		settingForROTASchedule.Name = 'Switch Between ROTA and Schedule';
		settingForROTASchedule.Description__c = 'This setting determines whether we need to get workgroup members from ROTA or Schedule.';
		settingForROTASchedule.SettingValue__c = 'CH_CA_WorkgroupMemberSchedule';
		if ([SELECT Id FROM CH_Settings__c WHERE Name = 'Switch Between ROTA and Schedule'].size() == 0){
			insert settingForROTASchedule;
		}
		// Create workgroup
		Id workgroupRecordTypeId = Schema.SObjectType.CH_Workgroup__c.getRecordTypeInfosByDeveloperName().get('CH_CA_Workgroup').getRecordTypeId();
		CH_Workgroup__c workgroup = new CH_Workgroup__c();
		workgroup.name = 'HWS_WG';
		workgroup.RecordTypeId = workgroupRecordTypeId;
		workgroup.CH_Workgroup_Instructions__c = 'This is a workgroup instruction';
		workgroup.CH_Type__c = 'Warranty Support;Quotation Support';
		insert workgroup;
		// Create workgroup Member
		id CH_CA_Workgroup = Schema.SObjectType.CH_Workgroup_Member__c.getRecordTypeInfosByDeveloperName().get('CH_CA_WorkgroupMember').getRecordTypeId();
		List<CH_Workgroup_Member__c> newWorkgroupMembers = new List<CH_Workgroup_Member__c>();
		// Create queue workgroup member
		CH_Workgroup_Member__c member = new CH_Workgroup_Member__c ();
		
		member.Name = 'HWS_Queue';
		member.CH_User__c = UserInfo.getUserId();
		member.CH_Role__c = 'Queue';
		member.CH_Workgroup_Member_Type__c = 'Queue';
		member.CH_Workgroup__c = workgroup.Id;
		member.RecordTypeId = CH_CA_Workgroup;
		newWorkgroupMembers.add(member);
		insert newWorkgroupMembers;
		
		// Create an rule
		id ruleRecordTypeId = Schema.SObjectType.CH_Workgroup_Rule__c.getRecordTypeInfosByDeveloperName().get('CH_CA_WorkgroupRule').getRecordTypeId();
		List<CH_Workgroup_Rule__c> newWorkgroupRules = new List<CH_Workgroup_Rule__c>();
		CH_Workgroup_Rule__c rule = new CH_Workgroup_Rule__c ();
		rule.name = 'HWS_Warranty_Rule';
		rule.CH_Workgroup__c = workgroup.Id;
		rule.CH_Workgroup_Type__c='Warranty Only';
		rule.CH_ServiceType__c='Hardware Support';
		rule.CH_OrderNumber__c = 10;
		rule.RecordTypeId = ruleRecordTypeId;
		newWorkgroupRules.add(rule);
		rule = new CH_Workgroup_Rule__c ();
		rule.name = 'HWS_Quotation_Rule';
		rule.CH_Workgroup__c = workgroup.Id;
		rule.CH_Workgroup_Type__c='Quotation Only';
		rule.CH_ServiceType__c='Hardware Support';
		rule.CH_OrderNumber__c = 10;
		rule.RecordTypeId = ruleRecordTypeId;
		newWorkgroupRules.add(rule);
		insert newWorkgroupRules;
	}
	//method to create Suspension records
	public static List<HWS_Suspension__c> createSuspensionRecord(Integer n,Boolean isInsert,Id ServiceContractId,Id contactId){
		List<HWS_Suspension__c> suspensionRecList = new List<HWS_Suspension__c>();
		for(Integer i=0;i<n;i++){
			HWS_Suspension__c sq = new HWS_Suspension__c();
			sq.HWS_Contact_Name__c = contactId;
			sq.HWS_Service_Contract_Name__c = ServiceContractId;
			sq.HWS_Suspension_Status__c ='Pending Review';
			suspensionRecList.add(sq);
		}
		if(isInsert && !suspensionRecList.isEmpty()){
			insert suspensionRecList;
		}
		return suspensionRecList;
	}
	//method to create Service Quote Records
	public static List<HWS_Service_Quote__c> createServiceQuote(Integer n,Id recordtypeId,Boolean isInsert,Id caseId){
		List<HWS_Service_Quote__c> serviceQuoteRecList = new List<HWS_Service_Quote__c>();
		for(Integer i=0;i<n;i++){
			HWS_Service_Quote__c sq = new HWS_Service_Quote__c();
			sq.HWS_Quote_Status__c = 'Draft';
			sq.RecordtypeId = recordtypeId;
			sq.HWS_Support_Ticket__c = caseId;
			sq.HWS_OPT_OnProcess_Status__c='C4';
			sq.HWS_Is_Quotable__c='Yes';
			serviceQuoteRecList.add(sq);
		}
		if(isInsert && !serviceQuoteRecList.isEmpty()){
			insert serviceQuoteRecList;
		}
		return serviceQuoteRecList;
	}
	//method to setup workgroup setup for Service Quote Records
	public static void createWGSetupServiceQuote(){
		//create Workgroups
		Id workgroupRecordTypeId = Schema.SObjectType.CH_Workgroup__c.getRecordTypeInfosByDeveloperName().get('CH_CA_Workgroup').getRecordTypeId();
		List<CH_Workgroup__c> wgList = new List<CH_Workgroup__c>();
		CH_Workgroup__c cdmWG = new CH_Workgroup__c();
		cdmWG.name = 'HWS_EQS-CDM_CDM_NAM_US';
		cdmWG.RecordTypeId = workgroupRecordTypeId;
		cdmWG.CH_Workgroup_Instructions__c = 'This is a workgroup instruction';
		cdmWG.CH_Type__c = 'Exclusions Quotation Support-CDM';
		wgList.add(cdmWG);
		CH_Workgroup__c ocWG = new CH_Workgroup__c();
		ocWG.name = 'HWS_EQS-OC_OC_NAM_US';
		ocWG.RecordTypeId = workgroupRecordTypeId;
		ocWG.CH_Workgroup_Instructions__c = 'This is a workgroup instruction';
		ocWG.CH_Type__c = 'Exclusions Quotation Support-OC';
		wgList.add(ocWG);
		insert wgList;
		// Create workgroup Member
		Id CH_CA_Workgroup_Member = Schema.SObjectType.CH_Workgroup_Member__c.getRecordTypeInfosByDeveloperName().get('CH_CA_WorkgroupMember').getRecordTypeId();
		List<CH_Workgroup_Member__c> newWorkgroupMembers = new List<CH_Workgroup_Member__c>();
		CH_Workgroup_Member__c member = new CH_Workgroup_Member__c ();
		member.Name = 'HWS_Queue';
		member.CH_User__c = UserInfo.getUserId();
		member.CH_Role__c = 'Queue';
		member.CH_Workgroup_Member_Type__c = 'Queue';
		member.CH_Workgroup__c = wgList[0].Id;
		member.RecordTypeId = CH_CA_Workgroup_Member;
		newWorkgroupMembers.add(member);
		member = new CH_Workgroup_Member__c ();
		member.CH_User__c = UserInfo.getUserId();
		member.CH_Role__c = 'Queue';
		member.CH_Workgroup_Member_Type__c = 'Queue';
		member.CH_Workgroup__c = wgList[1].Id;
		member.RecordTypeId = CH_CA_Workgroup_Member;
		newWorkgroupMembers.add(member);
		insert newWorkgroupMembers;
		//create Rules
		Id ruleRecordTypeId = Schema.SObjectType.CH_Workgroup_Rule__c.getRecordTypeInfosByDeveloperName().get('CH_CA_WorkgroupRule').getRecordTypeId();
		List<CH_Workgroup_Rule__c> newWorkgroupRules = new List<CH_Workgroup_Rule__c>();
		CH_Workgroup_Rule__c rule = new CH_Workgroup_Rule__c ();
		rule.name = 'HWS_CDM_Rule';
		rule.CH_Workgroup__c = wgList[0].Id;
		rule.CH_Workgroup_Type__c='Exclusions Quotation Support-CDM';
		rule.CH_ServiceType__c='Hardware Support';
		rule.CH_OrderNumber__c = 10;
		rule.CH_Region1__c = 'Market North America';
		rule.CH_Country1__c = 'United States of America';
		rule.RecordTypeId = ruleRecordTypeId;
		newWorkgroupRules.add(rule);
		rule = new CH_Workgroup_Rule__c ();
		rule.name = 'HWS_OC_Rule';
		rule.CH_Workgroup__c = wgList[1].Id;
		rule.CH_Workgroup_Type__c='Exclusions Quotation Support-OC';
		rule.CH_ServiceType__c='Hardware Support';
		rule.CH_OrderNumber__c = 10;
		rule.CH_Region1__c = 'Market North America';
		rule.CH_Country1__c = 'United States of America';
		rule.RecordTypeId = ruleRecordTypeId;
		newWorkgroupRules.add(rule);
		insert newWorkgroupRules;
	}
	  public static void createServiceFeeDetails(){
		Product2 prod = insertproduct2();  
		prod.HWS_NSNPartCode__c='C112019.A1A';
		prod.HWS_Source__c='test';		
		insert prod;	   
		HWS_ServiceFeeDetails__c sFee = new HWS_ServiceFeeDetails__c();
		sFee.HWS_Product__c =  prod.id ;
		sFee.HWS_Status__c = 'Active';
		sFee.HWS_SupportedQuoteTypes__c ='Damaged Part';
		sFee.HWS_DamagedHWRepairFee__c=10;
		sFee.HWS_DamagedHWReplacementFee__c=10;
		sFee.HWS_RepackingHWPackingFee__c=10;
		sFee.HWS_HWAssessmentFee__c=10;
		sFee.HWS_DocumentationFee__c=10;
		sFee.HWS_HWUnreturnedPartFee__c=10;
		sFee.HWS_OrderCode__c='SF00001';
		insert sFee;		
	}
	 public static void createServiceFeeDiscount(){
	   
		Account sAccount= insertAccount();
		insert sAccount;
		Product2 prod = insertproduct2();
		insert prod;
		ServiceContract sContract= createServiceContract(sAccount.Id); 
		sContract.Pricebook2Id = Test.getStandardPricebookId();
		Id ContractRecordTypeId = Schema.SObjectType.ServiceContract.getRecordTypeInfosByDeveloperName().get('CH_ServiceContract').getRecordTypeId();
		sContract.RecordTypeId = ContractRecordTypeId;
		insert sContract;
		PriceBookEntry pBook = new PriceBookEntry( 
			Pricebook2Id = Test.getStandardPricebookId(),
			Product2Id = prod.id,
			UnitPrice = 0,			
			IsActive = true
		);
		insert pBook;
		ContractLineItem cli=createContractLineItems(sContract.Id,pBook.Id);
		insert cli;		 
		User qUser = createUser();		
		HWS_ServiceFee_Discount__c sDiscount = new HWS_ServiceFee_Discount__c();
		sDiscount.HWS_Service_Contract__c=sContract.Id;
		sDiscount.HWS_Service_Contract_Line_Item__c=cli.Id;		
		sDiscount.HWS_Service_Assurance_Manager__c=qUser.Id;
		sDiscount.HWS_SupportedQuoteTypes__c = 'Unreturned Part';
		sDiscount.HWS_Quote_Eligilibilty_Days__c  = 9;
		sDiscount.HWS_Unreturned_Part_Discount__c = 10;
		sDiscount.HWS_Scope_of_work_Unreturned_Parts_id__c = '000';
		sDiscount.HWS_Email_Template__c = 'Hello';
		sDiscount.HWS_UnSuspension_Email_Text__c = 'Hi';
		sDiscount.HWS_Suspension_Email_Text__c = 'hi';
		insert sDiscount;	   
	}
	public static User createUser(){  	
		Profile profile = [Select Id from Profile where name = 'Data Loader Profile' LIMIT 1];
		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName = orgId + dateString + randomInt+'@mail.com';
		User dLUser = new User();
		dLUser.alias = 'DLoader';
		dLUser.email = 'testmail01@mail.com';
		dLUser.emailencodingkey = 'UTF-8';
		dLUser.lastname = 'DataLoaderr';
		dLUser.languagelocalekey = 'en_US';
		dLUser.localesidkey = 'en_US';
		dLUser.profileid = profile.Id; // Don't Modify the profile
		dLUser.Country__c = 'Canada';
		dLUser.timezonesidkey = 'America/Los_Angeles';
		dLUser.Username = uniqueName;
		insert dLUser;		
		return dLUser;
	}
	
	 Static Public Void createPortalUsers(){
		System.runAs(runAsUser){
			// Create the portal user
			Contact portalContact = [SELECT Id FROM Contact WHERE AssistantName ='Portal Contact' LIMIT 1];
			Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE :'Customers'+'%' LIMIT 1];
			User newUser = new User(
				LastName = 'PORTL2',
				FirstName='PORTAL2',
				Alias = 'TSTP1',
				Email = System.now().millisecond() + testemail,
				Username = math.random() + 'P1@test.com',
				ProfileId = portalProfile.id,
				TimeZoneSidKey = 'GMT',
				LanguageLocaleKey = 'en_US',
				EmailEncodingKey = 'UTF-8',
				LocaleSidKey = 'en_US',
				ContactId = portalContact.Id,
				IsActive = true,
				Nokia_ID__c = 'CHTEST' + String.valueOf(NokiaId++)
			);
			insert newUser; 
		}
	}

}