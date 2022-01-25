@isTest
public class HWS_DataFactory_TEST{
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
}