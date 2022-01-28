/****************************************
* Class Name : HWS_ProductServiceableSales_Batch_Test
* Created Date: 2 JAN 2019
* Created By : TCS
* Last Modified by: 
* Last Modified Date: 
* Description : Test class for loading product Servicable Sales Item master data from edp to salesforce 
*****************************************/
@isTest
public class HWS_ProductServiceableSales_Batch_Test {
	@testSetup
	static void createTestData()
	{
		List<EDP_HWS_Settings__c> edpEntryList = new List<EDP_HWS_Settings__c>();
		
		//Create custom settings entries for test data
		EDP_HWS_Settings__c edpEntry = new EDP_HWS_Settings__c();
		edpEntry.Name = 'ProductServiceableSalesItem';
		edpEntry.Full_Load__c = true;
		edpEntry.Full_Load_Filter__c ='Yes';
		edpEntry.ModifiedDate__c = Date.today();
		edpEntryList.add(edpEntry);
		insert edpEntryList;
		
		List<EDP_URLs__c> edpURLList = new List<EDP_URLs__c>();
		EDP_URLs__c edpURL1 = new EDP_URLs__c();
		edpURL1.name = 'PSSI';
		edpURL1.URL__c = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems';
		edpURLList.add(edpURL1);
		
		// inserting resource data required to generate the Token
		EDP_URLs__c edpURL2 = new EDP_URLs__c();
		edpURL2.name = 'resource';
		edpURL2.URL__c = 'https://edpqaapi.azurewebsites.net';
		edpURLList.add(edpURL2);
		insert edpURLList;
	  //creating data for Skip Count
		List<HWS_Skipcount__c> skipEntryList = new List<HWS_Skipcount__c>();
		HWS_Skipcount__c skipEntry1 = new HWS_Skipcount__c();
		skipEntry1.name = 'PSSI';
		skipEntry1.Skip_Count__c = null;
		skipEntryList.add(skipEntry1);
		insert skipEntryList;
		
	}
	@isTest 
	static void testproductServicableSales() 
	{
		
		//Setting callout mock for loading data from static resource		
		MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		String cIpath = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems';
		String tokenPath = 'https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token';
		String calloutPath = 'callout:EDP_Login';
		String url1 = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems';
		multimock.setStaticResource(cIpath, 'ProductServiceableSalesItems');
		multimock.setStaticResource(tokenPath,'ProductToken');
		multimock.setStaticResource(calloutPath,'ProductToken');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems?&$count=true&$top=1', 'ProductServiceableSalesItemsCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems?&$skip=1000&$top=1000', 'ProductServiceableSalesItemsCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems?&$skip=2000&$top=1000', 'ProductServiceableSalesItemsCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems?&$skip=3000&$top=1000', 'ProductServiceableSalesItemsCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems?&$skip=4000&$top=1000', 'ProductServiceableSalesItemsCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems?&$skip=5000&$top=1000', 'ProductServiceableSalesItemsCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems?&$skip=6000&$top=1000', 'ProductServiceableSalesItemsCount');
		multimock.setStatusCode(200);
		multimock.setHeader('Content-Type', 'application/json');
		Test.startTest();
		//Prepare url list for the start method
		List<String> queryList = new List<String>();
		queryList.add('https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems'); 
		//set mock callout mode
		Test.setMock(HttpCalloutMock.class, multimock);
		HWS_ProductServiceableSalesItem_Batch batch=new HWS_ProductServiceableSalesItem_Batch();
		Database.BatchableContext bC;
		SchedulableContext sC;
		batch.start(bC);
		batch.execute(bC,queryList);		 
		batch.finish(bC);
		batch.execute(sC);
		System.assertNotEquals(queryList.size(), null);
		Test.StopTest();
		
	}	
	
	 @isTest 
	static void testproductServicableSales1() 
	{
		
		//Setting callout mock for loading data from static resource		
		MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		String cIpath = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems';
		String tokenPath = 'https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token';
		String calloutPath = 'callout:EDP_Login';
		String url1 = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems';
		multimock.setStaticResource(cIpath, 'ProductServiceableSalesItems');
		multimock.setStaticResource(tokenPath,'ProductToken');
		multimock.setStaticResource(calloutPath,'ProductToken');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems?&$count=true&$top=1', 'ProductServiceableSalesItemsCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems?&$skip=1000&$top=1000', 'ProductServiceableSalesItemsCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems?&$skip=2000&$top=1000', 'ProductServiceableSalesItemsCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems?&$skip=3000&$top=1000', 'ProductServiceableSalesItemsCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems?&$skip=4000&$top=1000', 'ProductServiceableSalesItemsCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems?&$skip=5000&$top=1000', 'ProductServiceableSalesItemsCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems?&$skip=6000&$top=1000', 'ProductServiceableSalesItemsCount');
		
		multimock.setStaticResource(url1,'ProductServiceableSalesItems'); 
		multimock.setStatusCode(201);
		multimock.setHeader('Content-Type', 'application/json');
		Test.startTest();
		//Prepare url list for the start method
		List<String> queryList = new List<String>();
		queryList.add('https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems'); 
		//set mock callout mode
		Test.setMock(HttpCalloutMock.class, multimock);
		HWS_ProductServiceableSalesItem_Batch batch=new HWS_ProductServiceableSalesItem_Batch();
		Database.BatchableContext bC;
		SchedulableContext sC;
		batch.start(bC);
		//batch.execute(sC);
		batch.execute(bC,queryList);		 
		batch.finish(bC);
		System.assertNotEquals(queryList.size(), null);
		Test.StopTest();
		
	}	
	
	@isTest 
	static void testproductServicableSales5000() 
	{
		List<EDP_HWS_Settings__c> edpEntryList = new List<EDP_HWS_Settings__c>();
		//Create custom settings entries for test data
		EDP_HWS_Settings__c edpEntry = new EDP_HWS_Settings__c();
		edpEntry.Name = 'ProductServiceableSalesItem';
		//edpEntry.Full_Load__c = true;
		edpEntry.Full_Load_Filter__c ='Yes';
		edpEntry.ModifiedDate__c = Date.newInstance(2019,03,26);
		edpEntryList.add(edpEntry);
		insert edpEntryList;
		HWS_Skipcount__c skipCountValue = HWS_Skipcount__c.getInstance('PSSI');
		skipCountValue.Skip_Count__c = 5100;
		update skipCountValue;
		//Setting callout mock for loading data from static resource		
		MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		String cIpath = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems';
		String tokenPath = 'https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token';
		String calloutPath = 'callout:EDP_Login';
		multimock.setStaticResource(cIpath, 'ProductServiceableSalesItems');
		multimock.setStaticResource(tokenPath,'ProductToken');
		multimock.setStaticResource(calloutPath,'ProductToken');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$count=true&$top=1','ProductServiceableSalesItemsCount');
		String url1 = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems';
		multimock.setStaticResource(url1,'ProductServiceableSalesItems'); 
		multimock.setStatusCode(200);
		multimock.setHeader('Content-Type', 'application/json');
		Test.startTest();
		//Prepare url list for the start method
		List<String> queryList = new List<String>();
		queryList.add('https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems'); 
		//set mock callout mode
		Test.setMock(HttpCalloutMock.class, multimock);
		HWS_ProductServiceableSalesItem_Batch batch = new HWS_ProductServiceableSalesItem_Batch();
		Database.BatchableContext bC;
		SchedulableContext sC;
		batch.start(bC);
		//batch.execute(sC);
		batch.execute(bC,queryList);   
		System.assertNotEquals(queryList.size(), null);
		Test.StopTest();
		
	}	
	
	 
	@isTest 
	static void testproductServicableSales5001() 
	{
		List<EDP_HWS_Settings__c> edpEntryList = new List<EDP_HWS_Settings__c>();
		//Create custom settings entries for test data
		EDP_HWS_Settings__c edpEntry = new EDP_HWS_Settings__c();
		edpEntry.Name = 'ProductServiceableSalesItem';
		//edpEntry.Full_Load__c = true;
		edpEntry.Full_Load_Filter__c ='Yes';
		//edpEntry.ModifiedDate__c = Date.today()-1;
		edpEntry.ModifiedDate__c=Date.newInstance(2019,03,26);
		edpEntryList.add(edpEntry);
		insert edpEntryList;
		//Setting callout mock for loading data from static resource		
		MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		String cIpath = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems';
		String tokenPath = 'https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token';
		String calloutPath = 'callout:EDP_Login';
		multimock.setStaticResource(cIpath, 'ProductServiceableSalesItems');
		multimock.setStaticResource(tokenPath,'ProductToken');
		multimock.setStaticResource(calloutPath,'ProductToken');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$count=true&$top=1','ProductServiceableSalesItemsCount');
		String url1 = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems';
		multimock.setStaticResource(url1,'ProductServiceableSalesItems'); 
		multimock.setStatusCode(200);
		multimock.setHeader('Content-Type', 'application/json');
		Test.startTest();
		//Prepare url list for the start method
		List<String> queryList = new List<String>();
		queryList.add('https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems'); 
		//set mock callout mode
		Test.setMock(HttpCalloutMock.class, multimock);
		HWS_ProductServiceableSalesItem_Batch batch = new HWS_ProductServiceableSalesItem_Batch();
		Database.BatchableContext bC;
		SchedulableContext sC;
		batch.start(bC);
	   // batch.execute(sC);
		batch.execute(bC,queryList);
		System.assertNotEquals(queryList.size(), null);
		Test.StopTest();
		
	}	
	 
	@isTest 
	static void testproductServicableSalesWrapper() 
	{
		HWS_UploadToServicebleSalesItems.ProdServiceSalesItem wrap = new HWS_UploadToServicebleSalesItems.ProdServiceSalesItem();
		wrap.AlternateCodeType = 'test';
		wrap.AlternateCodeValue = 'test';
		wrap.DiscontinuedAdvancedExchangeDate = date.today();
		wrap.DiscontinuedRepairDate = date.today();
		wrap.EDP_ActiveStatus = true;
		wrap.EDP_DeletedAtSource = false;
		wrap.EDP_LastModifiedDate = date.today();
		wrap.Hazardousflag ='yes';
		wrap.IsProcessed = false;
		wrap.LifeExtender = 'test';
		wrap.Manufacturer = 'test';
		wrap.MaterialType ='test';
		wrap.NoSwapFlag = 'test';
		wrap.OEMmanufacturerpartcode ='test';
		wrap.Partname = 'test';
		wrap.PartNumber ='2';
		wrap.ProprietaryNote = 'test';
		wrap.Restrictedflag = 'test';
		wrap.SAPStatus ='test';
		wrap.SPSLastorderdate = Date.today(); 
		wrap.SupportbyDerogation  = 'tets';
		wrap.SupportbyDerogationEndDate =Date.today();
		System.assertNotEquals(wrap, null);
	}
}