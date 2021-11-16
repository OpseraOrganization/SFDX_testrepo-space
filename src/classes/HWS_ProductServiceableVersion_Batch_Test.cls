/****************************************
 * Class Name : HWS_ProductServiceableVersion_Batch_Test
 * Created Date: 2 JAN 2019
 * Created By : TCS
 * Last Modified by: 
 * Last Modified Date: 
 * Description : Test class for loading product Servicable Sales Item master data from edp to salesforce 
*****************************************/
@isTest
public class HWS_ProductServiceableVersion_Batch_Test {
	@testSetup
	public static void createTestData()
	{
		List<EDP_HWS_Settings__c> edpEntryList = new List<EDP_HWS_Settings__c>();
		 
		 //Create custom settings entries for test data
		 EDP_HWS_Settings__c edpEntry = new EDP_HWS_Settings__c();
		 edpEntry.Name = 'ProductServiceableVersionItem';
		 edpEntry.Full_Load_Filter__c ='Yes';
		 edpEntry.Full_Load__c = true;
		 edpEntry.ModifiedDate__c = Date.today();
		 //edpEntry.ModifiedDate__c = Date.newInstance(2019,03,26);
		 edpEntryList.add(edpEntry);	
		 insert edpEntryList;
				  
		 List<EDP_URLs__c> edpURLList = new List<EDP_URLs__c>();
		 EDP_URLs__c edpURL1 = new EDP_URLs__c();
		 edpURL1.name = 'PSVI';
		 edpURL1.URL__c = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems';
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
		skipEntry1.name = 'PSVI';
		skipEntry1.Skip_Count__c = null;
		skipEntryList.add(skipEntry1);
		insert skipEntryList;
	} 
  
	@isTest 
	 static void testproductServicableVersion() 
	 {
		 //Setting callout mock for loading data from static resource		
		 MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		 String ciPath = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems';
		 String tokenPath = 'https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token';
		 String calloutPath = 'callout:EDP_Login';
		 
		 multimock.setStaticResource(ciPath, 'ProductServiceableVersionItems');
		 multimock.setStaticResource(tokenPath,'ProductToken');
		 multimock.setStaticResource(calloutPath,'ProductToken');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?&$count=true&$top=1','ProductServiceableVersionItemsCount');
		// multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?&$skip=2000&$top=2000','ProductServiceableVersionItemsCount');
		  multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?&$skip=1000&$top=1000','ProductServiceableVersionItemsCount');
		// multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?&$skip=4000&$top=2000','ProductServiceableVersionItemsCount');
		// multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?&$skip=6000&$top=2000','ProductServiceableVersionItemsCount');
		  multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?&$skip=1000&$top=1000','ProductServiceableVersionItemsCount');
		  multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?&$skip=2000&$top=1000','ProductServiceableVersionItemsCount');
		  multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?&$skip=3000&$top=1000','ProductServiceableVersionItemsCount');
		  multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?&$skip=4000&$top=1000','ProductServiceableVersionItemsCount');
		  multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?&$skip=5000&$top=1000','ProductServiceableVersionItemsCount');
		  multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?&$skip=6000&$top=1000','ProductServiceableVersionItemsCount');
		String url1 = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems';
		 
		 multimock.setStaticResource(url1,'ProductServiceableVersionItems'); 
	   
		 multimock.setStatusCode(200);
		 multimock.setHeader('Content-Type', 'application/json');
		 
		 Test.startTest();
		 
		 //Prepare url list for the start method
		 List<String> queryList = new List<String>();
	  queryList.add('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems'); 
		 
		 //set mock callout mode
		 Test.setMock(HttpCalloutMock.class, multimock);
		 
		 HWS_ProductServiceableVersionItem_Batch batch = new HWS_ProductServiceableVersionItem_Batch();
		 Database.BatchableContext bc;
		 SchedulableContext sc;
		 batch.start(bc);
		 batch.execute(sc);
		 batch.execute(bc,queryList);		 
	batch.finish(bc);
		 system.assertNotEquals(tokenPath, null);	
		 Test.StopTest();

	 }
	
	@isTest 
	static void testproductServicableVersion1() 
	{
		
		//Setting callout mock for loading data from static resource		
		MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		String ciPath = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems';
		String tokenPath = 'https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token';
		String calloutPath = 'callout:EDP_Login';
		String url1 = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems';
		multimock.setStaticResource(ciPath, 'ProductServiceableVersionItems');
		multimock.setStaticResource(tokenPath,'ProductToken');
		multimock.setStaticResource(calloutPath,'ProductToken');
		//multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems?$filter=EDP_LastModifiedDate%20gt%202019-03-19T05:30:00Z&$count=true&$top=1','ProductServiceableSalesItemsCount');
		 multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?&$count=true&$top=1','ProductServiceableVersionItemsCount');
		 //multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?&$skip=2000&$top=2000','ProductServiceableVersionItemsCount');
		 //multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?&$skip=4000&$top=2000','ProductServiceableVersionItemsCount');
	   // multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?&$skip=6000&$top=2000','ProductServiceableVersionItemsCount');
multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?&$skip=1000&$top=1000','ProductServiceableVersionItemsCount');
		  multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?&$skip=2000&$top=1000','ProductServiceableVersionItemsCount');
		  multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?&$skip=3000&$top=1000','ProductServiceableVersionItemsCount');
		  multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?&$skip=4000&$top=1000','ProductServiceableVersionItemsCount');
		  multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?&$skip=5000&$top=1000','ProductServiceableVersionItemsCount');
		  multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?&$skip=6000&$top=1000','ProductServiceableVersionItemsCount');
		multimock.setStatusCode(201);
		multimock.setHeader('Content-Type', 'application/json');
		Test.startTest();
		//Prepare url list for the start method
		List<String> queryList = new List<String>();
		queryList.add('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems'); 
		//set mock callout mode
		Test.setMock(HttpCalloutMock.class, multimock);
	   
		HWS_ProductServiceableVersionItem_Batch batch=new HWS_ProductServiceableVersionItem_Batch();
		Database.BatchableContext bc;
		SchedulableContext sc;
		batch.start(bc);
		batch.execute(sc);
		batch.execute(bc,queryList);		 
		batch.finish(bc);
		system.assertNotEquals(tokenPath, null); 
		Test.StopTest();
		
	}   
	
	
	@isTest 
	 static void testproductServicableVersion5000() 
	 {
		 List<EDP_HWS_Settings__c> edpEntryList = new List<EDP_HWS_Settings__c>();
		//Create custom settings entries for test data
		EDP_HWS_Settings__c edpEntry = new EDP_HWS_Settings__c();
		edpEntry.Name = 'ProductServiceableVersionItem';
		//edpEntry.Full_Load__c = true;
		edpEntry.Full_Load_Filter__c ='Yes';
		edpEntry.ModifiedDate__c = Date.newInstance(2019,03,26);
		edpEntryList.add(edpEntry);
		insert edpEntryList;
		HWS_Skipcount__c skipCountValue = HWS_Skipcount__c.getInstance('PSVI');
		skipCountValue.Skip_Count__c = 5100;
		update skipCountValue;
		 //Setting callout mock for loading data from static resource		
		 MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		 String ciPath = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems';
		 String tokenPath = 'https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token';
		 String calloutPath = 'callout:EDP_Login';
		 
		 multimock.setStaticResource(ciPath, 'ProductServiceableVersionItems');
		 multimock.setStaticResource(tokenPath,'ProductToken');
		 multimock.setStaticResource(calloutPath,'ProductToken');
		 multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00ZZ&$count=true&$top=1','ProductServiceableVersionItemsCount');
		 multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$count=true&$top=1','ProductServiceableVersionItemsCount');
		 
		 String url1 = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems';
		 
		 multimock.setStaticResource(url1,'ProductServiceableVersionItems'); 
	   
		 multimock.setStatusCode(200);
		 multimock.setHeader('Content-Type', 'application/json');
		 
		 Test.startTest();
		 
		 //Prepare url list for the start method
		 List<String> queryList = new List<String>();
	  queryList.add('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems'); 
		 
		 //set mock callout mode
		 Test.setMock(HttpCalloutMock.class, multimock);
		 
		 HWS_ProductServiceableVersionItem_Batch batch = new HWS_ProductServiceableVersionItem_Batch();
		 Database.BatchableContext bc;
		 SchedulableContext sc;
		 batch.start(bc);
		 batch.execute(sc);
		 batch.execute(bc,queryList);		 
	batch.finish(bc); 
		 system.assertNotEquals(tokenPath, null);	
		 Test.StopTest();

	 }


@isTest 
	static void testproductServicableVersion5001() 
	{
		List<EDP_HWS_Settings__c> edpEntryList = new List<EDP_HWS_Settings__c>();
		//Create custom settings entries for test data
		EDP_HWS_Settings__c edpEntry = new EDP_HWS_Settings__c();
		edpEntry.Name = 'ProductServiceableVersionItem';
		edpEntry.Full_Load__c = false;
		edpEntry.Full_Load_Filter__c ='Yes';
		//edpEntry.ModifiedDate__c = Date.today()-1;
		edpEntry.ModifiedDate__c=Date.newInstance(2019,03,26);
		edpEntryList.add(edpEntry);
		insert edpEntryList;
		
		
		
	   //Setting callout mock for loading data from static resource		
		MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		 String ciPath = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems';
		 String tokenPath = 'https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token';
		 String calloutPath = 'callout:EDP_Login';
		 
		 multimock.setStaticResource(ciPath, 'ProductServiceableVersionItems');
		 multimock.setStaticResource(tokenPath,'ProductToken');
		 multimock.setStaticResource(calloutPath,'ProductToken');
		// multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00ZZ&$count=true&$top=1','ProductServiceableVersionItemsCount');
		  multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$count=true&$top=1','ProductServiceableVersionItemsCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=2000&$top=2000','ProductServiceableVersionItemsCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=4000&$top=2000','ProductServiceableVersionItemsCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=6000&$top=2000','ProductServiceableVersionItemsCount');
multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=1000&$top=1000','ProductServiceableVersionItemsCount');
multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=2000&$top=1000','ProductServiceableVersionItemsCount');
multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=3000&$top=1000','ProductServiceableVersionItemsCount');
multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=4000&$top=1000','ProductServiceableVersionItemsCount');
multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=5000&$top=1000','ProductServiceableVersionItemsCount');
multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=6000&$top=1000','ProductServiceableVersionItemsCount');

		 String url1 = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems';
		 
		 multimock.setStaticResource(url1,'ProductServiceableVersionItems'); 
	   
		 multimock.setStatusCode(200);
		 multimock.setHeader('Content-Type', 'application/json');
		 
		 Test.startTest();
		 
		 //Prepare url list for the start method
		 List<String> queryList = new List<String>();
	  queryList.add('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems'); 
		 
		 //set mock callout mode
		 Test.setMock(HttpCalloutMock.class, multimock);
		 
		 HWS_ProductServiceableVersionItem_Batch batch = new HWS_ProductServiceableVersionItem_Batch();
		 Database.BatchableContext bc;
		 SchedulableContext sc;
		 batch.start(bc);
		 batch.execute(sc);
		 batch.execute(bc,queryList);		 
	batch.finish(bc); 
		 system.assertNotEquals(tokenPath, null); 
		 Test.StopTest();

		
	}	
	

	@isTest 
	 static void testproductServicableVersionWrapper() 
	 {
		 HWS_UploadToServicebleVersionItems.ProdServItems wrap = new HWS_UploadToServicebleVersionItems.ProdServItems();
		 wrap.EDP_ActiveStatus = true;
		 wrap.EDP_DeletedAtSource = true;
		 wrap.EDP_LastModifiedDate = date.today();
		 wrap.FITRate='2';
		 wrap.MaterialType = 'none';
		 //wrap.NSNCode = '90983747576';
		 wrap.PartNumber='223';
		 wrap.PartRevision = 'test';
		 wrap.PartRevisionFormat='test';
		 wrap.SAPStatus='test';
		 wrap.SerialNumberFormat='test';
		 wrap.SerialNumberTraceable='test';
		 wrap.Source='test';
	 }
}