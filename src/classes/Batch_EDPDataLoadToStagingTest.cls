/****************************************
 * Class Name : Batch_EDPDataLoadToStagingTest
 * Created Date: 19 June 2018
 * Created By : Accenture
 * Last Modified by: 
 * Last Modified Date: 
 * Description : Test class for loading product master data from edp to salesforce 
*****************************************/
@isTest
public class Batch_EDPDataLoadToStagingTest 
{  
	@testSetup
	static void createTestData()
	{
		List<EDP_URLs__c> edpEntryList = new List<EDP_URLs__c>();
		 
		 //Create custom settings entries for test data
		 EDP_URLs__c edpEntry = new EDP_URLs__c();
		 edpEntry.isActive__c=true;
		 edpEntry.Name = 'ProductConfigurationItems';
		 edpEntry.Product_Code__c = 'CDC2018';
		// edpEntry.Maximum_Timestamp__c = '';
		 edpEntryList.add(edpEntry);
		 
		 EDP_URLs__c edpEntry1 = new EDP_URLs__c();
		 edpEntry1.isActive__c=true;
		 edpEntry1.Name = 'ProductSalesItems';
		 edpEntry1.Product_Code__c = '';
		 edpEntry1.Maximum_Timestamp__c = DateTime.valueOf('2018-06-25 16:13:22');
		 edpEntryList.add(edpEntry1);
		 
		 EDP_URLs__c edpEntry2 = new EDP_URLs__c();
		 edpEntry2.isActive__c=true;
		 edpEntry2.Name = 'PI';
		 edpEntry2.Product_Code__c = 'PI2018,PI2019';
		 //edpEntry2.Maximum_Timestamp__c = system.now();
		 edpEntryList.add(edpEntry2);
		 
		/* EDP_URLs__c edpEntry3 = new EDP_URLs__c(); 
		 edpEntry3.Name = 'ProductRelations';
		 edpEntry3.Full_Load__c = true;
		// edpEntry3.Full_Load_Filter__c = 'RelationType != null';
		 edpEntry3.Product_Code__c = '';
		 edpEntry3.Maximum_Timestamp__c = system.now();
		 edpEntryList.add(edpEntry3);   */	 
		 
		 insert edpEntryList;
		 
		 List<EDP_URLs__c> edpURLList = new List<EDP_URLs__c>();
		 EDP_URLs__c edpURL1 = new EDP_URLs__c();
		 edpURL1.isActive__c=true;
		 edpURL1.name = 'resource';
		 edpURL1.URL__c = 'https://edpqaapi.azurewebsites.net';
		 edpURLList.add(edpURL1);
		 
		 EDP_URLs__c edpURL2 = new EDP_URLs__c();
		 edpURL2.isActive__c=true;
		 edpURL2.name = 'PCI';
		 edpURL2.URL__c = 'https://edpqaapi.azurewebsites.net/api/ProductConfigurationItems';
		 edpURLList.add(edpURL2);
		 
		  /*EDP_URLs__c edpURL3 = new EDP_URLs__c();
		 edpURL3.isActive__c=true;
		 edpURL3.name = 'PI';
		 edpURL3.URL__c = 'https://edpqaapi.azurewebsites.net/api/ProductPortfolioItems';
		 edpURLList.add(edpURL3);
		 
		EDP_URLs__c edpURL4 = new EDP_URLs__c();
		 edpURL4.name = 'PR_PCI_EBOM';
		 edpURL4.URL__c = 'https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'EBOM\'';
		 edpURL4.isActive__c = true;
		 edpURLList.add(edpURL4); */
		 
		 EDP_URLs__c edpURL5 = new EDP_URLs__c();
		 edpURL5.isActive__c=true;
		 edpURL5.name = 'PSI';
		 edpURL5.URL__c = 'https://edpqaapi.azurewebsites.net/api/ProductSalesItems';
		 edpURLList.add(edpURL5);
		 
		/*EDP_URLs__c edpURL6 = new EDP_URLs__c();
		 edpURL6.name = 'PR_PCI_EBOMHistory';
		 edpURL6.URL__c = 'https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'EBOM History\'';
		 edpURL6.isActive__c = true;
		 edpURLList.add(edpURL6);
		 */
		 insert edpURLList;
		 
		List<Product2> productList = new List<Product2>();
		 Product2 product = new Product2();
		 product.Name = 'Product';
		 product.APTS_Ext_ID__c = 'TP451847';
		 product.ProductCode = 'TP451847';
		 productList.add(product);
		
		 Product2 product1 = new Product2();
		 product1.Name = 'Product 1';
		 product1.APTS_Ext_ID__c = '00000001';
		 product1.ProductCode = '00000001';
		 productList.add(product1);
		
		 Product2 product2 = new Product2();
		 product2.Name = 'Product';
		 product2.APTS_Ext_ID__c = '133-060762_00';
		 product2.ProductCode = '133-060762_00';
		 productList.add(product2);
		
		 insert productList;  
		
		 /*Product_Relation__c productRel = new Product_Relation__c();
		 productRel.Child_ID__c		= '00000001';
		 productRel.Child_Name__c	= '00000001';
		 productRel.Parent_ID__c	= '133-060762_00';
		 productRel.EDPActiveStatus__c		= true;
		 productRel.RelationType__c			= 'EBOM';
		productRel.Combined_key__c		  = '00000001_133-060762_00';
		insert productRel;*/
		
		List<NokiaCPQ_PMDI_Parameter__c> ParameterList = new List<NokiaCPQ_PMDI_Parameter__c>();
		
		 NokiaCPQ_PMDI_Parameter__c m_p= new NokiaCPQ_PMDI_Parameter__c();
		m_p.Name='ProductCode';
		m_p.NokiaCPQ_ObjNameSrc__c='Product_Sales_Item__c';
		m_p.NokiaCPQ_ObjNameTrg__c='Product2';
		m_p.NokiaCPQ_ParaFrom__c='NSNCode__c';
		m_p.NokiaCPQ_ParaTo__c='PRODUCTCODE';
		m_p.NokiaCPQ_ParaType__c='MAPPING RULE';
		m_p.NokiaCPQ_ReqMap__c=false;
		m_p.NokiaCPQ_Active__c=true;
		
		ParameterList.add(m_p); 
		
		NokiaCPQ_PMDI_Parameter__c c_p = new NokiaCPQ_PMDI_Parameter__c();
		c_p.Name='DESCRIPTION';
		c_p.NokiaCPQ_ObjNameSrc__c='Product_Configuration_Item__c';
		c_p.NokiaCPQ_ObjNameTrg__c='Product2';
		c_p.NokiaCPQ_ParaFrom__c='NSNCode__c';
		c_p.NokiaCPQ_ParaTo__c='PRODUCTCODE';
		c_p.NokiaCPQ_ParaType__c='MAPPING RULE';
		c_p.NokiaCPQ_ReqMap__c=false;
		c_p.NokiaCPQ_Active__c=true;
		
		ParameterList.add(c_p);
		
		 NokiaCPQ_PMDI_Parameter__c l_paras = new NokiaCPQ_PMDI_Parameter__c();
		l_paras.Name='PMDI_Product2';
		l_paras.NokiaCPQ_ObjNameSrc__c='Product_Portfolio_Item__c';
		l_paras.NokiaCPQ_ObjNameTrg__c='Product2';
		l_paras.NokiaCPQ_ParaFrom__c='NSNLegacyCode__c';
		l_paras.NokiaCPQ_ParaTo__c='PRODUCTCODE';
		l_paras.NokiaCPQ_ParaType__c='MAPPING RULE';
		l_paras.NokiaCPQ_ReqMap__c=true;
		l_paras.NokiaCPQ_Active__c=true;
		
		ParameterList.add(l_paras);
		
		insert ParameterList;
		
		
	   Product_Configuration_Item__c CI = new Product_Configuration_Item__c();
		CI.NSNCode__c='106742596';
		CI.Description__c = 'CI';
		CI.Is_Processed__c = false;
		CI.EDP_LastModifiedDate__c = system.today();
		insert CI;
		
		Product_Portfolio_Item__c  PPI = new Product_Portfolio_Item__c();
		PPI.NSNCode__c='106742596';
		PPI.Description__c = 'PI';
		PPI.Is_Processed__c = false;
		PPI.EDP_LastModifiedDate__c = system.today();
		insert PPI;
		
		 Product_Sales_Item__c psi=new Product_Sales_Item__c();
		psi.NSNCode__c='106742596';
		psi.Description__c = 'PSI';
		psi.Is_Processed__c = false;
		psi.EDPLastModifiedDate__c = system.today();
		insert psi;
		
	}
	
	
	
	@isTest
	static void testProductConfigurationItems()
	{
		Test.startTest();
		
		//Setting callout mock for loading data from static resource		
		 MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		
		
		String CIpath = 'https://edpqaapi.azurewebsites.net/api/ProductConfigurationItems';
		multimock.setStaticResource(CIpath, 'ProductConfigurationItems');
		multimock.setStatusCode(200);
		 multimock.setHeader('Content-Type', 'application/json');
		
		 String url4 = 'https://edpqaapi.azurewebsites.net/api/ProductConfigurationItems?$filter=EDP_LastModifiedDate%20gt%202018-06-25T16%3A13%3A22Z&$count=true&$top=1';
		
		 multimock.setStaticResource(url4,'ProductStagingCount'); 
		 String calloutPath = 'callout:EDP_Login';
		 multimock.setStaticResource(calloutPath,'ProductToken');
		
		 //set mock callout mode
		 Test.setMock(HttpCalloutMock.class, multimock);
		
		List<String> QueryList = new List<String>();
	  QueryList.add('https://edpqaapi.azurewebsites.net/api/ProductConfigurationItems');
		 
		Batch_EDPDataLoadToStaging batch = new Batch_EDPDataLoadToStaging();
		 Database.BatchableContext BC; 
				 batch.start(BC);
		batch.execute(BC,QueryList); 
		 Test.StopTest();

	}

	  @isTest 
	 static void testCalloutWithStaticResources() 
	 {
		 //Setting callout mock for loading data from static resource		
		 MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		 String CIpath = 'https://edpqaapi.azurewebsites.net/api/ProductConfigurationItems';
		 String PIpath = 'https://edpqaapi.azurewebsites.net/api/ProductPortfolioItems?$filter=ItemId%20eq%20\'PI2018\'20or%20ItemId%20eq%20\'PI2019\'';
		 String SIpath = 'https://edpqaapi.azurewebsites.net/api/ProductSalesItems?$filter=EDP_LastModifiedDate%20gt%202018-06-25T16%3A13%3A22Z';
		 String PRpath = 'https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'EBOM\'%20and%20RelationType%20ne%20null';
		 String tokenPath = 'https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token';
		 String calloutPath = 'callout:EDP_Login';
		
		 multimock.setStaticResource(CIpath, 'ProductConfigurationItems');
		 multimock.setStaticResource(SIpath, 'ProductSalesItemLoad');
		 multimock.setStaticResource(PIpath, 'ProductPortfolioItem');  
		 multimock.setStaticResource(PRpath, 'ProductRelations');
		 multimock.setStaticResource(tokenPath,'ProductToken');
		 multimock.setStaticResource(calloutPath,'ProductToken');
		 multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductConfigurationItems?$count=true&$skip=5000','ProductConfigurationItems');
		 
		 String url1 = 'https://edpqaapi.azurewebsites.net/api/ProductConfigurationItems?$filter=ConfId%20eq%20\'CDC2018\'&$count=true&$top=1';
		 String url = 'https://edpqaapi.azurewebsites.net/api/ProductConfigurationItems?$filter=ConfId%20eq%20\'CDC2018\'';
		 String url2 = 'https://edpqaapi.azurewebsites.net/api/ProductPortfolioItems?$filter=ItemId%20eq%20\'PI2018\'%20or%20ItemId%20eq%20\'PI2019\'&$count=true&$top=1';
		// String url3 = 'https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'EBOM\'%20and%20RelationType%20ne%20null\'&$count=true&$top=1';
		// String url31 = 'https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'EBOM History\'%20and%20RelationType%20ne%20null\'&$count=true&$top=1';
		 String url3='https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'EBOM\'&$count=true&$top=1';
		 String url4 = 'https://edpqaapi.azurewebsites.net/api/ProductSalesItems?$filter=EDP_LastModifiedDate%20gt%202018-06-25T16%3A13%3A22Z&$count=true&$top=1';
		 String urls = 'https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'EBOM History\'%20and%20RelationType%20ne%20null';
		
		 
		 multimock.setStaticResource(url,'ProductConfigurationItems'); 
		 multimock.setStaticResource(urls,'ProductRelations'); 
		 multimock.setStaticResource(url1,'ProductStagingCount');
		 multimock.setStaticResource(url2,'ProductStagingCount');
		 multimock.setStaticResource(url3,'ProductStagingCount');
		// multimock.setStaticResource(url31,'ProductStagingCount');
		 multimock.setStaticResource(url4,'ProductStagingCount');
		 
		 multimock.setStatusCode(200);
		 multimock.setHeader('Content-Type', 'application/json');
		 
		 Test.startTest();
		 
		 //Prepare url list for the start method
		 List<String> QueryList = new List<String>();
	  QueryList.add('https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'EBOM\'%20and%20RelationType%20ne%20null'); 
		   
		 //set mock callout mode
		 Test.setMock(HttpCalloutMock.class, multimock);
		 
		 Batch_EDPDataLoadToStaging batch = new Batch_EDPDataLoadToStaging();
		 Database.BatchableContext BC;
		 SchedulableContext SC;
		 batch.start(BC);
		 //batch.execute(SC);
		batch.execute(BC,QueryList);		 
		  
		 Test.StopTest();

	 }
  
	@isTest
	static void testProductSalesItems()
	{
		Test.startTest();
		
		//Setting callout mock for loading data from static resource		
		 MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		
		String SIpath = 'https://edpqaapi.azurewebsites.net/api/ProductSalesItems?$filter=EDP_LastModifiedDate%20gt%202018-06-25T16%3A13%3A22Z';
		multimock.setStaticResource(SIpath, 'ProductSalesItemLoad');
		multimock.setStatusCode(200);
		 multimock.setHeader('Content-Type', 'application/json');
		
		 //set mock callout mode
		 Test.setMock(HttpCalloutMock.class, multimock);
		
		List<String> QueryList = new List<String>();
	  QueryList.add('https://edpqaapi.azurewebsites.net/api/ProductSalesItems?$filter=EDP_LastModifiedDate%20gt%202018-06-25T16%3A13%3A22Z');
		 
		Batch_EDPDataLoadToStaging batch = new Batch_EDPDataLoadToStaging();
		 Database.BatchableContext BC; 
		batch.execute(BC,QueryList); 
		 Test.StopTest();

	}
	@isTest
	static void testProductPortfolioItems()
	{
		Test.startTest();
		
		//Setting callout mock for loading data from static resource		
		 MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		
		
		String PIpath = 'https://edpqaapi.azurewebsites.net/api/ProductPortfolioItems?$filter=ItemId%20eq%20\'PI2018\'20or%20ItemId%20eq%20\'PI2019\'';
		multimock.setStaticResource(PIpath, 'ProductPortfolioItem');
		multimock.setStatusCode(200);
		 multimock.setHeader('Content-Type', 'application/json');
		
		 //set mock callout mode
		 Test.setMock(HttpCalloutMock.class, multimock);
		
		List<String> QueryList = new List<String>();
	  QueryList.add('https://edpqaapi.azurewebsites.net/api/ProductPortfolioItems?$filter=ItemId%20eq%20\'PI2018\'20or%20ItemId%20eq%20\'PI2019\'');
		   

		Batch_EDPDataLoadToStaging batch = new Batch_EDPDataLoadToStaging();
		 Database.BatchableContext BC; 
		// batch.start(BC);
			  
		
		batch.execute(BC,QueryList); 
		
		 Test.StopTest();
 
	}
	
   
	
	@isTest
	static void testclearPMDISetting()
	{
		Test.startTest();
		Batch_EDPDataLoadToStaging batch = new Batch_EDPDataLoadToStaging();
		batch.clearPMDISetting();
		 Test.StopTest();
	}
	
	@isTest
	static void testmodifyEDPCustomSettings()
	{
		Test.startTest();
		Batch_EDPDataLoadToStaging batch = new Batch_EDPDataLoadToStaging();
		batch.modifyEDPCustomSettings();
		 Test.StopTest();
	}
	
	@isTest
	static void testCreateErrorLogs()
	{
		Test.startTest();
		Batch_EDPDataLoadToStaging batch = new Batch_EDPDataLoadToStaging();
		batch.CreateErrorLogs('Failure',400,'Callout Failed','https://ProductSalesItems');
		 Test.StopTest();
	}
	
	@isTest
	static void testgetResponseFailure()
	{
		Test.startTest();
		String SIpath = 'https://edpqaapi.azurewebsites.net/api/ProductSalesItems?$filter=EDP_LastModifiedDate%20gt%202018-06-25T16%3A13%3A22Z';
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource('ProductSalesItemLoad');
		mock.setStatusCode(400);
		mock.setHeader('Content-Type', 'application/json');	
		Test.setMock(HttpCalloutMock.class, mock);
		//Batch_EDPDataLoadToStaging batch = new Batch_EDPDataLoadToStaging();
		Batch_EDPDataLoadToStaging.getResponse(SIpath,'123');
		Batch_EDPDataLoadToStaging batch = new Batch_EDPDataLoadToStaging();
		Database.BatchableContext BC; 
		 batch.start(BC);
		SchedulableContext SC;
		//batch.execute(SC);
		List<String> QueryList = new List<String>();
	  QueryList.add(SIpath);
		batch.execute(BC,QueryList);
		Test.stopTest();
	}
	 @isTest
	static void testexecuteMethod()
	{
		Test.startTest();
		
		 EDP_URLs__c edpEntry1 = EDP_URLs__c.getInstance('ProductSalesItems');
		 edpEntry1.Full_Load_Filter__c = 'RelationType != null';
					
		//Setting callout mock for loading data from static resource		
		 MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		
		

	   String SIpath = 'https://edpqaapi.azurewebsites.net/api/ProductSalesItems?$filter=EDP_LastModifiedDate%20gt%202018-06-25T16%3A13%3A22Z';
		multimock.setStaticResource(SIpath, 'ProductSalesItems');
		multimock.setStatusCode(200);
		multimock.setStatus('Failure');
		 multimock.setHeader('Content-Type', 'application/json');
		
		String url4 = 'https://edpqaapi.azurewebsites.net/api/ProductSalesItems?$filter=EDP_LastModifiedDate%20gt%202018-06-25T16%3A13%3A22Z&$count=true&$top=1';
		
		 multimock.setStaticResource(url4,'ProductStagingCount'); 
		 String calloutPath = 'callout:EDP_Login';
		 multimock.setStaticResource(calloutPath,'ProductToken');
		
		 //set mock callout mode
		 Test.setMock(HttpCalloutMock.class, multimock);
		
		List<String> QueryList = new List<String>();
	  QueryList.add('https://edpqaapi.azurewebsites.net/api/ProductSalesItems?$filter=EDP_LastModifiedDate%20gt%202018-06-25T16%3A13%3A22Z'); 
		 
		Batch_EDPDataLoadToStaging batch = new Batch_EDPDataLoadToStaging();
		 SchedulableContext SC;
		
		batch.getToken();
		update edpEntry1;
		Batch_EDPDataLoadToStaging.getResponse(SIpath,'123');
		 Test.StopTest();

	}
	
	@isTest
	static void testgetCountofRecordsFailure()
	{
		 String Item='';
		Test.startTest();
		
		EDP_URLs__c edpEntry1 = EDP_URLs__c.getInstance('ProductSalesItems');
		 edpEntry1.Full_Load_Filter__c = 'RelationType != null';
		   
		//Setting callout mock for loading data from static resource		
		 MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		
	   String SIpath = 'https://edpqaapi.azurewebsites.net/api/ProductSalesItems?$filter=EDP_LastModifiedDate%20gt%202018-06-25T16%3A13%3A22Z';
		multimock.setStaticResource(SIpath, 'ProductSalesItems');
		multimock.setStatusCode(400);
		multimock.setStatus('Failure');
		 multimock.setHeader('Content-Type', 'application/json');
		
		String url4 = 'https://edpqaapi.azurewebsites.net/api/ProductSalesItems?$filter=EDP_LastModifiedDate%20gt%202018-06-25T16%3A13%3A22Z&$count=true&$top=1';
		
		 multimock.setStaticResource(url4,'ProductStagingCount'); 
		 String calloutPath = 'callout:EDP_Login';
		 multimock.setStaticResource(calloutPath,'ProductToken');
		
		 //set mock callout mode
		 Test.setMock(HttpCalloutMock.class, multimock);
		
		List<String> QueryList = new List<String>();
	  QueryList.add('https://edpqaapi.azurewebsites.net/api/ProductSalesItems?$filter=EDP_LastModifiedDate%20gt%202018-06-25T16%3A13%3A22Z'); 
		 
		Batch_EDPDataLoadToStaging batch = new Batch_EDPDataLoadToStaging();
		
		
		batch.getToken();
		update edpEntry1;
		batch.getCountofRecords(SIpath,Item);
		Database.BatchableContext BC;
		//batch.finish(BC);
	   // batch.unschedule();
		 Test.StopTest();

	}
	
	@isTest
	static void testgetTokenFailure()
	{
		 String Item1='';
		Test.startTest();
		
		 EDP_URLs__c edpEntry1 = EDP_URLs__c.getInstance('ProductSalesItems');
		 edpEntry1.Full_Load_Filter__c = 'RelationType != null';
		   
		//Setting callout mock for loading data from static resource		
		 MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		
		String SIpath = 'https://edpqaapi.azurewebsites.net/api/ProductSalesItems?$filter=EDP_LastModifiedDate%20gt%202018-06-25T16%3A13%3A22Z';
		multimock.setStaticResource(SIpath, 'ProductSalesItems');
		multimock.setStatusCode(200);
		multimock.setStatus('Failure');
		 multimock.setHeader('Content-Type', 'application/json');
		
		String url4 = 'https://edpqaapi.azurewebsites.net/api/ProductSalesItems?$filter=EDP_LastModifiedDate%20gt%202018-06-25T16%3A13%3A22Z&$count=true&$top=1';
		
		 multimock.setStaticResource(url4,'ProductSalesItems'); 
		 String calloutPath = 'callout:EDP_Login';
		 multimock.setStaticResource(calloutPath,'ProductToken');
		
		 //set mock callout mode
		 Test.setMock(HttpCalloutMock.class, multimock);
		
		List<String> QueryList = new List<String>();
	 QueryList.add('https://edpqaapi.azurewebsites.net/api/ProductSalesItems?$filter=EDP_LastModifiedDate%20gt%202018-06-25T16%3A13%3A22Z'); 
		
		Batch_EDPDataLoadToStaging batch = new Batch_EDPDataLoadToStaging();
		batch.getCountofRecords(SIpath,Item1);
		update edpEntry1;
		batch.getToken();
		 Test.StopTest();

	}
	
	@isTest
	static void testprepareURLMethod()
	{
  
		//Setting callout mock for loading data from static resource		
		 MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		 
		String SIpath = 'https://edpqaapi.azurewebsites.net/api/ProductSalesItems?$filter=EDP_LastModifiedDate%20gt%202018-06-25T16%3A13%3A22Z';
		
		 multimock.setStaticResource(SIpath, 'ProductSalesItems');
		
		
		 //String url3='https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'EBOM\'%20and%20RelationType%20ne%20null&$count=true&$top=1';
		 String url4 = 'https://edpqaapi.azurewebsites.net/api/ProductSalesItems?$filter=EDP_LastModifiedDate%20gt%202018-06-25T16%3A13%3A22Z&$count=true&$top=1';
		 //String urls = 'https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'EBOM\'%20and%20RelationType%20ne%20null&$count=true&$top=1';
				
		 multimock.setStaticResource(url4,'ProductSalesItems'); 
	  
		 multimock.setStatusCode(200);
		 multimock.setHeader('Content-Type', 'application/json');
		 
		 Test.startTest();
		 
		 EDP_URLs__c edpEntry1 = EDP_URLs__c.getInstance('ProductSalesItems');
		edpEntry1.Full_Load__c = true; 
		//edpEntry1.Full_Load_Filter__c = 'RelationType != null';
		 
		update edpEntry1;
		
		
		 //set mock callout mode
		Test.setMock(HttpCalloutMock.class, multimock);
		Batch_EDPDataLoadToStaging batch = new Batch_EDPDataLoadToStaging();
	   // batch.getCountofRecords(SIpath,Item);
		Database.BatchableContext BC;
		batch.start(BC);
		Test.StopTest();
	}

}