@isTest
public class Batch_ProductRelationsTest {
  public static EDP_URLs__c edpURL1 = new EDP_URLs__c();
	
	@testSetup
	static void createTestData()
	{
		List<PMDI_Settings__c> edpEntryList = new List<PMDI_Settings__c>();
		
		 
		 
		 
		 PMDI_Settings__c edpEntry3 = new PMDI_Settings__c();
		 edpEntry3.Name = 'ProductRelations';
		 edpEntry3.Full_Load__c = true;
		// edpEntry3.Full_Load_Filter__c = 'RelationType != null';
		 edpEntry3.NSNCode__c = '';
		 edpEntry3.ModifiedDate__c = system.now();
		 edpEntryList.add(edpEntry3);	   
		 
		 insert edpEntryList;
		 
		 List<EDP_URLs__c> edpURLList = new List<EDP_URLs__c>();
		
		 edpURL1.name = 'resource';
		 edpURL1.URL__c = 'https://edpqaapi.azurewebsites.net';
	   
		 EDP_URLs__c edpURL4 = new EDP_URLs__c();
		 edpURL4.name = 'PR_PCI_EBOM';
		 edpURL4.URL__c = 'https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'EBOM\'';
		 edpURL4.isActive__c = true;
		 edpURL4.Maximum_Timestamp__c=system.now();
		 
		 edpURLList.add(edpURL4);
		 
		 EDP_URLs__c edpURL5 = new EDP_URLs__c();
		 edpURL5.name = 'PR_PCI_GBOM';
		 edpURL5.URL__c = 'https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'GBOM\'';
		 edpURL5.isActive__c = true;
		 edpURL5.Maximum_Timestamp__c=system.now();
		 edpURL5.Full_Load__c =true;
		 edpURL5.Full_Load_Filter__c ='NSNLegacyCode=2134';
		 edpURL5.Product_Code__c ='2134';
		 edpURLList.add(edpURL5);
		
		 EDP_URLs__c edpURL6 = new EDP_URLs__c();
		 edpURL6.name = 'PR_PCI_NSN Care Select Class';
		 edpURL6.URL__c = 'https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'NSN%20Care%20Select%20Class\'';
		 edpURL6.isActive__c = true;
		 edpURL6.Maximum_Timestamp__c=system.now();
		 edpURL6.Product_Code__c ='2134';
		 edpURLList.add(edpURL6);
		 
		  EDP_URLs__c edpURL7 = new EDP_URLs__c();
		 edpURL7.name = 'PR_PCI_NSN Has Design Element';
		 edpURL7.URL__c = 'https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'NSN%20Has%20Design%20Element\'';
		 edpURL7.isActive__c = true;
		 edpURL7.Maximum_Timestamp__c=system.now();
		 edpURL7.Product_Code__c ='2134,1234';
		 edpURLList.add(edpURL7);

		  insert edpURL1;
		 insert edpURLList;
		 
		
		
		 Product_Relation__c productRel = new Product_Relation__c();
		 productRel.Child_ID__c	 = '00000001';
		 productRel.Child_Name__c   = '00000001';
		 productRel.Parent_ID__c	= '133-060762_00';
		 productRel.EDPActiveStatus__c	  = true;
		 productRel.RelationType__c		 = 'EBOM';
		productRel.Combined_key__c		= '00000001_133-060762_00';
		insert productRel;
		
	}
	
	 @isTest 
	 static void testCalloutWithStaticResources() 
	 {
		  Test.startTest();
		 //Setting callout mock for loading data from static resource	   
		 MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		
		 String PRpath = 'https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'EBOM\'%20and%20RelationType%20ne%20null';
		 String tokenPath = 'https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token';
		 String calloutPath = 'callout:EDP_Login';
		 
		  
		 multimock.setStaticResource(PRpath, 'ProductRelations');
		 multimock.setStaticResource(tokenPath,'ProductToken');
		 multimock.setStaticResource(calloutPath,'ProductToken');
		 //multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductConfigurationItems?$count=true&$skip=5000','ProductConfigurationItems');
		 
	
		 String url3 = 'https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'EBOM\'%20and%20RelationType%20ne%20null\'&$count=true&$top=1';
		 //String url31 = 'https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'EBOM History\'%20and%20RelationType%20ne%20null\'&$count=true&$top=1';
		 //String url4='https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'EBOM\'&$count=true&$top=1';
		 
		 //String urls = 'https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'EBOM History\'%20and%20RelationType%20ne%20null';
		
		 
		 
		 multimock.setStaticResource(url3,'ProductRelations'); 
				 
		 multimock.setStatusCode(200);
		 multimock.setHeader('Content-Type', 'application/json');
		 
		
		 
		 //Prepare url list for the start method
		 List<String> QueryList = new List<String>();
	  QueryList.add('https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'EBOM\'%20and%20RelationType%20ne%20null'); 
		 
		 //set mock callout mode
		 Test.setMock(HttpCalloutMock.class, multimock);
		 
		 Batch_ProductRelations batch = new  Batch_ProductRelations();
		 Database.BatchableContext BC;
		 SchedulableContext SC;
		 batch.start(BC);
		 batch.execute(SC);
		batch.execute(BC,QueryList);		 
		  
		 Test.StopTest();

	 }
   @isTest
	static void testgetCountofRecordsFailure()
	{
		Test.startTest();
		
		 PMDI_Settings__c edpEntry3 = PMDI_Settings__c.getInstance('ProductRelations');
		 edpEntry3.Full_Load_Filter__c = 'RelationType != null';
		   
		//Setting callout mock for loading data from static resource		
		 MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		
		String SIpath = 'https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'EBOM\'%20and%20RelationType%20ne%20null';
		multimock.setStaticResource(SIpath, 'ProductRelations');
		multimock.setStatusCode(200);
		multimock.setStatus('Failure');
		 multimock.setHeader('Content-Type', 'application/json');
		
		 String urls = 'https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'EBOM\'%20and%20RelationType%20ne%20null&$count=true&$top=1';
		
		 multimock.setStaticResource(urls,'ProductStagingCount'); 
		 String calloutPath = 'callout:EDP_Login';
		 multimock.setStaticResource(calloutPath,'ProductToken');
		
		 //set mock callout mode
		 Test.setMock(HttpCalloutMock.class, multimock);
		
		List<String> QueryList = new List<String>();
	  QueryList.add('https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'EBOM\'%20and%20RelationType%20ne%20null'); 
		 
		 Batch_ProductRelations batch = new  Batch_ProductRelations();
		batch.status_map.put('PR_PCI_EBOM',true);
		batch.getToken();
		update edpEntry3;
		batch.getCountofRecords(SIpath,' ');
		Database.BatchableContext BC;
		batch.finish(BC);
		batch.unschedule();
		 Test.StopTest();

	}
	 @isTest
	static void testprepareURLMethod()
	{
		//Setting callout mock for loading data from static resource		
		 MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		 
		 String PRpath = 'https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'EBOM\'%20and%20RelationType%20ne%20null';
		
		 multimock.setStaticResource(PRpath, 'ProductRelations');
		
		
		 String url3='https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'EBOM\'%20and%20RelationType%20ne%20null&$count=true&$top=1';
		 String urls = 'https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'EBOM\'%20and%20RelationType%20ne%20null&$count=true&$top=1';
				
		 multimock.setStaticResource(urls,'ProductStagingCount'); 
	  
		 multimock.setStatusCode(200);
		 multimock.setHeader('Content-Type', 'application/json');
		 
		 Test.startTest();
		 
		 PMDI_Settings__c edpEntry3 = PMDI_Settings__c.getInstance('ProductRelations');
		edpEntry3.Full_Load__c = true; 
		edpEntry3.Full_Load_Filter__c = 'RelationType != null';
		 
		update edpEntry3;
		
		 //set mock callout mode
		 Test.setMock(HttpCalloutMock.class, multimock);
		 Batch_ProductRelations batch = new  Batch_ProductRelations();
		batch.prepareURL('ProductRelations');
	}
	
   
	@isTest
	static void testgetTokenFailure()
	{
		Test.startTest();
		
		 PMDI_Settings__c edpEntry3 = PMDI_Settings__c.getInstance('ProductRelations');
		 edpEntry3.Full_Load_Filter__c = 'RelationType != null';
		   
		//Setting callout mock for loading data from static resource		
		 MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		
		String SIpath = 'https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'EBOM\'%20and%20RelationType%20ne%20null';
		multimock.setStaticResource(SIpath, 'ProductRelations');
		multimock.setStatusCode(200);
		multimock.setStatus('Failure');
		 multimock.setHeader('Content-Type', 'application/json');	  
					
		 String urls = 'https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'EBOM\'%20and%20RelationType%20ne%20null&$count=true&$top=1';
		
		 multimock.setStaticResource(urls,'ProductStagingCount'); 
		 String calloutPath = 'callout:EDP_Login';
		 multimock.setStaticResource(calloutPath,'ProductToken');
		
		 //set mock callout mode
		 Test.setMock(HttpCalloutMock.class, multimock);
		
		List<String> QueryList = new List<String>();
	  QueryList.add('https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'EBOM\'%20and%20RelationType%20ne%20null'); 
		 
		 Batch_ProductRelations batch = new  Batch_ProductRelations();
		batch.CreateErrorLogs('sdfsdf', 2232, 'asaaw', 'dasdasdsawas');
		batch.getCountofRecords(SIpath,' ');
		update edpEntry3;
		batch.getToken();
		 Test.StopTest();

	}
	
   
	@isTest
	static void testexecuteMethod()
	{
		Test.startTest();
		
		 PMDI_Settings__c edpEntry3 = PMDI_Settings__c.getInstance('ProductRelations');
		 edpEntry3.Full_Load_Filter__c = 'RelationType != null';
		 
		
			
		//Setting callout mock for loading data from static resource		
		 MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();	 
		String SIpath = 'https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'EBOM\'%20and%20RelationType%20ne%20null';
		multimock.setStaticResource(SIpath, 'ProductRelations');
		multimock.setStatusCode(300);
		multimock.setStatus('Failure');
		 multimock.setHeader('Content-Type', 'application/json');
		
		 String urls = 'https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'EBOM\'%20and%20RelationType%20ne%20null&$count=true&$top=1';
		
		 multimock.setStaticResource(urls,'ProductStagingCount'); 
		 String calloutPath = 'callout:EDP_Login';
		 multimock.setStaticResource(calloutPath,'ProductToken');
		
		 //set mock callout mode
		 Test.setMock(HttpCalloutMock.class, multimock);
		
		List<String> QueryList = new List<String>();
	  QueryList.add('https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'EBOM\'%20and%20RelationType%20ne%20null'); 
		 
		 Batch_ProductRelations batch = new  Batch_ProductRelations();
		  Database.BatchableContext BC;
		batch.start(BC);
		 batch.Execute(BC,QueryList);
		batch.getToken();
		update edpEntry3;
		Batch_ProductRelations.getResponse(SIpath,'123');
		Test.StopTest();

	}
 @isTest
	static void testexecuteMethod1()
	{
		Test.startTest();
		/*
		 PMDI_Settings__c edpEntry3 = PMDI_Settings__c.getInstance('ProductRelations');
		 edpEntry3.Full_Load_Filter__c = 'RelationType != null';
		edpURL1.name = 'resource';
		edpURL1.URL__c = 'https://edpqaapi.azurewebsites.net';
		edpURL1.Full_Load__c=true;
		  update edpURL1;
			*/
		//Setting callout mock for loading data from static resource		
		 MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		String SIpath = 'https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'EBOM\'%20and%20RelationType%20ne%20null';
		multimock.setStaticResource(SIpath, 'ProductRelations');
		multimock.setStatusCode(300);
		multimock.setStatus('Failure');
		 multimock.setHeader('Content-Type', 'application/json');
		
		 String urls = 'https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'EBOM\'%20and%20RelationType%20ne%20null&$count=true&$top=1';
		
		 multimock.setStaticResource(urls,'ProductStagingCount'); 
		 String calloutPath = 'callout:EDP_Login';
		 multimock.setStaticResource(calloutPath,'ProductToken');
		
		 //set mock callout mode
		 Test.setMock(HttpCalloutMock.class, multimock);
		
		List<String> QueryList = new List<String>();
	  QueryList.add('https://edpqaapi.azurewebsites.net/api/ProductRelations?$filter=RelationType%20eq%20\'EBOM\'%20and%20RelationType%20ne%20null'); 
		 
		 Batch_ProductRelations batch = new  Batch_ProductRelations();
		  Database.BatchableContext BC;
		batch.start(BC);

		 batch.Execute(BC,QueryList);
		batch.getToken();
		batch.modifyEDPCustomSettings();
		batch.JOB_Name='testbatch';
		batch.scheduleJob();
	   // update edpEntry3;
		Batch_ProductRelations.getResponse(SIpath,'123');
		Test.StopTest();

	}

}