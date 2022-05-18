@isTest
public class CPQ_BOMUploadControllerTest {
	@isTest
	public static void test_uploadBOM(){
		 List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		List<Account> accounts1 = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		accounts1[0].Acc_No__c = 'Testing1';
		accounts1[0].Partner_Program__c ='';
		accounts1[0].Partner_Type__c = '';
		accounts1[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		insert accounts1;

		//create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Premium';
		accreditations[1].Pricing_Level_Override__c = 'Premium';   
		insert accreditations; 
		
		//Create Opportunity
		List<opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities1[0].End_Customer_LE__c = accounts1[0].Id;
		opportunities1[0].Account_Role__c = 'Alliance Partner';
		insert opportunities1;
		
		//Create Product
		List<Product2> prods = new List<Product2>();
		Product2 prod1 = new product2(
			Name = 'Test1', 
			ProductCode = '123', 
			Business_Group__c = 'MN', 
			CurrencyIsoCode = 'USD',
			IsActive = false,
			NokiaCPQ_Item_Type__c='Software',
			Apttus_Config2__ConfigurationType__c='Bundle'
			
		); 
		prods.add(prod1);
		
		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
			Name = 'Commercial Price List', 
			Apttus_Config2__Active__c = True
		);
		insert ApttusTestPriceList;
		
		//create price list items
		List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
		Apttus_Config2__PriceListItem__c pLI1 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = prod1.Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		//insert pLI1;
		plistItems.add(pLI1);
		
		test.startTest();
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities1[0].Id;
		 proposals[0].NokiaCPQ_Is_Maintenance_Quote__c=false;
	
		proposals[0].NokiaCPQ_Portfolio__c = 'IP Routing'; //MN airscale wifi portfolio
		//proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Indirect Quote').getRecordTypeId();
		insert proposals;	 
		
		//create product configuration
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
			Name = 'APTTUS Test Config', 
			Apttus_Config2__AccountId__c = accounts[0].Id, 
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
			Apttus_QPConfig__Proposald__c = proposals[0].Id, 
			Apttus_Config2__Status__c = 'New', 
			Apttus_Config2__VersionNumber__c = 1, 
			Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__BusinessObjectId__c = String.valueOf(proposals[0].Id),
			Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
		insert ProdConfig;
		
		Demo__c dm = new Demo__c(Name='Test');
		insert dm;
		
		String csv = 'Line No,Product Code,Parent Line No,Quantity,Proposed Price,Product Description,Sub Heading,Flexible Group\n1,300465598,,1,100,Service "Test" Product,subheading,group1';
		
	Blob b = Blob.valueOf(csv);
	Attachment attachment = new Attachment();
	attachment.ParentId = dm.Id;
	attachment.Name = 'Test Attachment for Parent';
	attachment.Body = b;
	insert attachment;
		
		//Test.startTest();
		CPQ_BOMUploadController.WrapperData wrapper = new CPQ_BOMUploadController.WrapperData();
		wrapper = CPQ_BOMUploadController.uploadBOM(EncodingUtil.base64Encode(attachment.Body), ProdConfig.Id);
		List<CPQ_QTC_CartServices.ProductData> csvDataRows = wrapper.csvData;
		Test.stopTest();
		
		System.assertNotEquals(null, csvDataRows, 'CSV read successfully');
		
		CPQ_BOMUploadController.addProductsToCart(ProdConfig.Id, csvDataRows);
		try {
			CPQ_BOMUploadController.repriceCart(ProdConfig.Id);
		} catch(Exception e) {
			System.debug('reprice exception: ' +e.getStackTraceString());
		}
		
	}
}