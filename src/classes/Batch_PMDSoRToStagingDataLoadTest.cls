/****************************************
 * Class Name : Batch_PMDSoRToStagingDataLoadTest
 * Created Date: 01 Dec 2021
 * Created By : Standav
 * Last Modified by: 
 * Last Modified Date: 
 * Description : Test class for loading PMDSOR surround product master data from edp to salesforce 
*****************************************/
@isTest
public without sharing class Batch_PMDSoRToStagingDataLoadTest {
	
	@testSetup
	static void createTestData() {

		//Create custom settings entries for test data
		EDP_URLs__c e1 = new EDP_URLs__c();
		e1.isActive__c=true;
		e1.Name = 'PMDSOR_Resource';
		e1.URL__c = 'https://pmd-qa-api.azurewebsites.net';

		insert e1;

		List<Product2> productList = new List<Product2>();
		Product2 product = new Product2();
		product.Name = 'Product1';
		product.APTS_Ext_ID__c = 'prd1';
		product.ProductCode = 'prd1';
		product.CPQ_Stream__c = 'QTC';
		productList.add(product);
	
		Product2 product1 = new Product2();
		product1.Name = 'Product2';
		product1.APTS_Ext_ID__c = 'prd2';
		product1.ProductCode = 'prd2';
		product.CPQ_Stream__c = 'QTC';
		productList.add(product1);
	
		Product2 product2 = new Product2();
		product2.Name = 'Product3';
		product2.APTS_Ext_ID__c = 'prd3';
		product2.ProductCode = 'prd3';
		productList.add(product2);
	
		insert productList;  
		
		CPQ_PMDSOR_Staging_Data__c staging = new CPQ_PMDSOR_Staging_Data__c();
		staging.NSNCode__c='prd1';
		staging.Is_Data_Processed__c = false;

		staging.NSN_Secondary_Category__c = 'Site Model';
		staging.NSN_Tertiary_Category__c = 'OPS';
		staging.Finance_Reporting_BG__c = 'FN';
		staging.Finance_Reporting_BU__c = 'GSSIV';
		staging.Finance_Reporting_PP_Code__c = 'p';
		staging.Finance_Reporting_BL_Code__c = 'b';

		staging.PMDSOR_PCI_UpdateDateTime__c = system.today();
		staging.PMDSOR_SI_UpdateDateTime__c = system.today();
		staging.NSN_Published_to_QtC__c = true;
		insert staging;
		
	}

	@isTest
	static void testProductSalesItems() {

		List<EDP_URLs__c> edpEntryList = new List<EDP_URLs__c>();
		 
		//Create custom settings entries for test data
		EDP_URLs__c e1 = new EDP_URLs__c();
		e1.isActive__c=true;
		e1.Name = 'PMDSOR_SI';
		e1.Batch_Size__c = 3;
		e1.Custom_Query__c = '';
		e1.Full_Load__c = false;
		e1.Full_Load_Filter__c = '';
		e1.Maximum_Timestamp__c = DateTime.valueOf('2018-06-25 16:13:22');
		e1.Product_Code__c = '';
		e1.URL__c = 'https://pmd-qa-api.azurewebsites.net/api/SalesItems';
		edpEntryList.add(e1);
		 
		EDP_URLs__c e2 = new EDP_URLs__c();
		e2.isActive__c=true;
		e2.Name = 'PMDSOR_PCI';
		e2.Batch_Size__c = 3;
		e2.Custom_Query__c = '';
		e2.Full_Load__c = true;
		e2.Full_Load_Filter__c = '';
		e2.Maximum_Timestamp__c = null;
		e2.Product_Code__c = '';
		e2.URL__c = 'https://pmd-qa-api.azurewebsites.net/api/ProductConfigurationItems';
		edpEntryList.add(e2);
		insert edpEntryList;

		Test.startTest();
		
		//Setting callout mock for loading data from static resource		
		MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		
		String tokenPath = 'https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token';
		String SIpath = 'https://pmd-qa-api.azurewebsites.net/api/SalesItems?$expand=MainAttributes&$filter=PMDSOR_UpdateDateTime%20gt%202018-06-25T16%3A13%3A22Z';
		String SICount = 'https://pmd-qa-api.azurewebsites.net/api/SalesItems?$expand=MainAttributes&$filter=PMDSOR_UpdateDateTime%20gt%202018-06-25T16%3A13%3A22Z&$select=Name&$count=true&$top=1';
		
		multimock.setStaticResource(tokenPath, 'PMDSORAuthToken');
		multimock.setStaticResource(SIpath, 'PMDSORSalesItemsResponse');
		multimock.setStaticResource(SICount, 'PMDSORSalesItemsCount');
		
		multimock.setStatusCode(200);
		multimock.setHeader('Content-Type', 'application/json');
		
		//set mock callout mode
		Test.setMock(HttpCalloutMock.class, multimock);
		
		// List<String> QueryList = new List<String>();
		// QueryList.add('https://edpqaapi.azurewebsites.net/api/ProductSalesItems?$filter=EDP_LastModifiedDate%20gt%202018-06-25T16%3A13%3A22Z');
			
		Batch_PMDSoRToStagingDataLoad batch = new Batch_PMDSoRToStagingDataLoad();
		//  Database.BatchableContext BC; 
		// batch.execute(BC,QueryList);
		// DataBase.executeBatch(batch);
		batch.executeMethod();
		Test.StopTest();

	}

	@isTest
	static void testProductConfigurationItems() {

		List<EDP_URLs__c> edpEntryList = new List<EDP_URLs__c>();
		 
		//Create custom settings entries for test data
		EDP_URLs__c e1 = new EDP_URLs__c();
		e1.isActive__c=true;
		e1.Name = 'PMDSOR_SI';
		e1.Batch_Size__c = 3;
		e1.Custom_Query__c = '';
		e1.Full_Load__c = false;
		e1.Full_Load_Filter__c = '';
		e1.Maximum_Timestamp__c = DateTime.valueOf('2018-06-25 16:13:22');
		e1.Product_Code__c = '';
		e1.URL__c = 'https://pmd-qa-api.azurewebsites.net/api/SalesItems';
		edpEntryList.add(e1);
		 
		EDP_URLs__c e2 = new EDP_URLs__c();
		e2.isActive__c=true;
		e2.Name = 'PMDSOR_PCI';
		e2.Batch_Size__c = 3;
		e2.Custom_Query__c = '';
		e2.Full_Load__c = false;
		e2.Full_Load_Filter__c = '';
		e2.Maximum_Timestamp__c = null;
		e2.Product_Code__c = '';
		e2.URL__c = 'https://pmd-qa-api.azurewebsites.net/api/ProductConfigurationItems';
		edpEntryList.add(e2);
		insert edpEntryList;

		Test.startTest();
		
		//Setting callout mock for loading data from static resource		
		MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		
		String tokenPath = 'https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token';
		String SIpath = 'https://pmd-qa-api.azurewebsites.net/api/SalesItems?$expand=MainAttributes&$filter=PMDSOR_UpdateDateTime%20gt%202018-06-25T16%3A13%3A22Z';
		String SICount = 'https://pmd-qa-api.azurewebsites.net/api/SalesItems?$expand=MainAttributes&$filter=PMDSOR_UpdateDateTime%20gt%202018-06-25T16%3A13%3A22Z&$select=Name&$count=true&$top=1';
		

		String PCIPath = 'https://pmd-qa-api.azurewebsites.net/api/ProductConfigurationItems?$expand=MainAttributes(%24filter%3DName%20eq%20\'NSN%20Finance%20Reporting%20Structure\')%2CRelationInfo';
		
		multimock.setStaticResource(tokenPath, 'PMDSORAuthToken');
		multimock.setStaticResource(SIpath, 'PMDSORSalesItemsResponse');
		multimock.setStaticResource(SICount, 'PMDSORSalesItemsCount');

		multimock.setStaticResource(PCIPath, 'PMDSORPCIPathResponse');
		// multimock.setStaticResource(SICount, 'PMDSORSalesItemsCount');
		
		multimock.setStatusCode(200);
		multimock.setHeader('Content-Type', 'application/json');
		
		//set mock callout mode
		Test.setMock(HttpCalloutMock.class, multimock);
		
		List<String> QueryList = new List<String>();
		QueryList.add(PCIPath);
			
		Batch_PMDSoRToStagingDataLoad batch = new Batch_PMDSoRToStagingDataLoad();
		Database.BatchableContext BC; 
		batch.execute(BC,QueryList);

		Test.stopTest();

	}

	@isTest
	static void testTokenExceptionItems() {

		List<EDP_URLs__c> edpEntryList = new List<EDP_URLs__c>();
		 
		//Create custom settings entries for test data
		EDP_URLs__c e1 = new EDP_URLs__c();
		e1.isActive__c=true;
		e1.Name = 'PMDSOR_SI';
		e1.Batch_Size__c = 3;
		e1.Custom_Query__c = '';
		e1.Full_Load__c = false;
		e1.Full_Load_Filter__c = '';
		e1.Maximum_Timestamp__c = DateTime.valueOf('2018-06-25 16:13:22');
		e1.Product_Code__c = '';
		e1.URL__c = 'https://pmd-qa-api.azurewebsites.net/api/SalesItems';
		edpEntryList.add(e1);
		 
		EDP_URLs__c e2 = new EDP_URLs__c();
		e2.isActive__c=true;
		e2.Name = 'PMDSOR_PCI';
		e2.Batch_Size__c = 3;
		e2.Custom_Query__c = '';
		e2.Full_Load__c = false;
		e2.Full_Load_Filter__c = '';
		e2.Maximum_Timestamp__c = null;
		e2.Product_Code__c = '';
		e2.URL__c = 'https://pmd-qa-api.azurewebsites.net/api/ProductConfigurationItems';
		edpEntryList.add(e2);
		insert edpEntryList;

		Test.startTest();
		
		//Setting callout mock for loading data from static resource		
		MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		
		
		multimock.setStatusCode(200);
		multimock.setHeader('Content-Type', 'application/json');
		
		//set mock callout mode
		Test.setMock(HttpCalloutMock.class, multimock);
			
		Batch_PMDSoRToStagingDataLoad batch = new Batch_PMDSoRToStagingDataLoad();
		DataBase.executeBatch(batch);
		Test.stopTest();

	}

	@isTest
	static void testCalloutExceptionItems() {

		List<EDP_URLs__c> edpEntryList = new List<EDP_URLs__c>();
		 
		//Create custom settings entries for test data
		EDP_URLs__c e1 = new EDP_URLs__c();
		e1.isActive__c=true;
		e1.Name = 'PMDSOR_SI';
		e1.Batch_Size__c = 3;
		e1.Custom_Query__c = '';
		e1.Full_Load__c = false;
		e1.Full_Load_Filter__c = '';
		e1.Maximum_Timestamp__c = DateTime.valueOf('2018-06-25 16:13:22');
		e1.Product_Code__c = '';
		e1.URL__c = 'https://pmd-qa-api.azurewebsites.net/api/SalesItems';
		edpEntryList.add(e1);
		 
		EDP_URLs__c e2 = new EDP_URLs__c();
		e2.isActive__c=true;
		e2.Name = 'PMDSOR_PCI';
		e2.Batch_Size__c = 3;
		e2.Custom_Query__c = '';
		e2.Full_Load__c = false;
		e2.Full_Load_Filter__c = '';
		e2.Maximum_Timestamp__c = null;
		e2.Product_Code__c = '';
		e2.URL__c = 'https://pmd-qa-api.azurewebsites.net/api/ProductConfigurationItems';
		edpEntryList.add(e2);
		insert edpEntryList;

		Test.startTest();
		
		//Setting callout mock for loading data from static resource		
		MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		
		String tokenPath = 'https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token';
		String SIpath = 'Test::https://pmd-qa-api.azurewebsites.net/api/SalesItems?$expand=MainAttributes&$filter=PMDSOR_UpdateDateTime%20gt%202018-06-25T16%3A13%3A22Z';
		
		multimock.setStaticResource(tokenPath, 'PMDSORAuthToken');
		multimock.setStaticResource(SIpath, 'PMDSORSalesItemsResponse');
		
		multimock.setStatusCode(200);
		multimock.setHeader('Content-Type', 'application/json');
		
		//set mock callout mode
		Test.setMock(HttpCalloutMock.class, multimock);
			
		Batch_PMDSoRToStagingDataLoad batch = new Batch_PMDSoRToStagingDataLoad();
		DataBase.executeBatch(batch);
		Test.stopTest();
	}

	@isTest
	static void testSILastModifiedFilterTest() {

		List<EDP_URLs__c> edpEntryList = new List<EDP_URLs__c>();
		 
		//Create custom settings entries for test data
		EDP_URLs__c e1 = new EDP_URLs__c();
		e1.isActive__c=true;
		e1.Name = 'PMDSOR_SI';
		e1.Batch_Size__c = 3;
		e1.Custom_Query__c = '';
		e1.Full_Load__c = false;
		e1.Full_Load_Filter__c = '';
		e1.Maximum_Timestamp__c = null;
		e1.Product_Code__c = '';
		e1.URL__c = 'https://pmd-qa-api.azurewebsites.net/api/SalesItems';
		edpEntryList.add(e1);
		 
		EDP_URLs__c e2 = new EDP_URLs__c();
		e2.isActive__c=true;
		e2.Name = 'PMDSOR_PCI';
		e2.Batch_Size__c = 3;
		e2.Custom_Query__c = '';
		e2.Full_Load__c = false;
		e2.Full_Load_Filter__c = '';
		e2.Maximum_Timestamp__c = null;
		e2.Product_Code__c = '';
		e2.URL__c = 'https://pmd-qa-api.azurewebsites.net/api/ProductConfigurationItems';
		edpEntryList.add(e2);
		insert edpEntryList;

		Test.startTest();
		
		//Setting callout mock for loading data from static resource		
		MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		
		String tokenPath = 'https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token';
		String SIpath = 'Test::https://pmd-qa-api.azurewebsites.net/api/SalesItems?$expand=MainAttributes&$filter=PMDSOR_UpdateDateTime%20gt%202018-06-25T16%3A13%3A22Z';
		
		multimock.setStaticResource(tokenPath, 'PMDSORAuthToken');
		multimock.setStaticResource(SIpath, 'PMDSORSalesItemsResponse');
		
		multimock.setStatusCode(200);
		multimock.setHeader('Content-Type', 'application/json');
		
		//set mock callout mode
		Test.setMock(HttpCalloutMock.class, multimock);
			
		Batch_PMDSoRToStagingDataLoad batch = new Batch_PMDSoRToStagingDataLoad();
		DataBase.executeBatch(batch);
		Test.stopTest();
	}

	
	@isTest
	static void testCreateErrorLogs() {
		Test.startTest();
		Batch_PMDSoRToStagingDataLoad batch = new Batch_PMDSoRToStagingDataLoad();
		batch.createErrorLogs('status', 404, 'resource not found', 'www.testurl.com');
		Test.stopTest();
	}

	@isTest
	static void testCreateErrorLogsForStagingToProductBatch() {
		Test.startTest();
		Batch_PMDSoRStagingDataToProductMaster batch = new Batch_PMDSoRStagingDataToProductMaster();
		List<product2> prdList = [select id,ProductCode,CPQ_Secondary_Category__c,CPQ_Tertiary_Category__c,CPQ_QTC_Business_Group__c,CPQ_QTC_Business_Unit__c,Business_Line_Code__c,NokiaCPQ_Portfolio_Package_Code__c from product2];
		batch.createErrorLog(new List<Database.Error>(), prdList[0], 'Insert');
		Test.stopTest();
	}
  
	
	@isTest
	static void testUpdateStagingRecords() {
		Test.startTest();
		Batch_PMDSoRStagingDataToProductMaster batch = new Batch_PMDSoRStagingDataToProductMaster();
		List<product2> prdList = [select id,ProductCode,CPQ_Secondary_Category__c,CPQ_Tertiary_Category__c,CPQ_QTC_Business_Group__c,CPQ_QTC_Business_Unit__c,Business_Line_Code__c,NokiaCPQ_Portfolio_Package_Code__c from product2];
		batch.createErrorLog(new List<Database.Error>(), prdList[0], 'Insert');
		Test.stopTest();
	}

}