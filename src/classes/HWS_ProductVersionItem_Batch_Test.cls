/****************************************
 * Class Name : HWS_ProductversionItem_Batch_Test
 * Created Date: 15th march 2019
 * Created By : TCS
 * Last Modified by: 
 * Last Modified Date: 
 * Description : Test class for loading product Version Item master data from edp to salesforce 
*****************************************/
@isTest
public class HWS_ProductVersionItem_Batch_Test {
	@testSetup
	public static void createTestData()
	{
		List<EDP_HWS_Settings__c> edpEntryList = new List<EDP_HWS_Settings__c>();
		 
		 //Create custom settings entries for test data
		 EDP_HWS_Settings__c edpEntry = new EDP_HWS_Settings__c();
		 edpEntry.Name = 'ProductVersionItem';
		 edpEntry.Full_Load_Filter__c ='Yes';
		edpEntry.Full_Load__c=true;
		 edpEntry.ModifiedDate__c = Date.today();
		 edpEntryList.add(edpEntry);	
		 insert edpEntryList;
	  
		 List<EDP_URLs__c> edpURLList = new List<EDP_URLs__c>();
		 EDP_URLs__c edpURL1 = new EDP_URLs__c();
		 edpURL1.name = 'PVI';
		 edpURL1.URL__c = 'https://edpqaapi.azurewebsites.net/api/ProductVersionItems';
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
		skipEntry1.name = 'PVI';
		skipEntry1.Skip_Count__c = null;
		skipEntryList.add(skipEntry1);
		insert skipEntryList;
	} 
  
   @isTest 
	static void testproductversionitem() 
	{
		//Setting callout mock for loading data from static resource		
		MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		String ciPath = 'https://edpqaapi.azurewebsites.net/api/ProductVersionItems';
		String tokenPath = 'https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token';
		String calloutPath = 'callout:EDP_Login';
		
		multimock.setStaticResource(ciPath, 'ProductVersionItem');
		multimock.setStaticResource(tokenPath,'ProductToken');
		multimock.setStaticResource(calloutPath,'ProductToken');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductVersionItems?&$count=true&$top=1','ProductVersionItemCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductVersionItems?&$skip=1000&$top=1000','ProductVersionItemCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductVersionItems?&$skip=2000&$top=1000','ProductVersionItemCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductVersionItems?&$skip=3000&$top=1000','ProductVersionItemCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductVersionItems?&$skip=4000&$top=1000','ProductVersionItemCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductVersionItems?&$skip=5000&$top=1000','ProductVersionItemCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductVersionItems?&$skip=6000&$top=1000','ProductVersionItemCount');
		String url1 = 'https://edpqaapi.azurewebsites.net/api/ProductVersionItems';
		system.assertEquals(url1, 'https://edpqaapi.azurewebsites.net/api/ProductVersionItems');
		multimock.setStaticResource(url1,'ProductVersionItem'); 
		
		multimock.setStatusCode(200);
		multimock.setHeader('Content-Type', 'application/json');
		
		Test.startTest();
		
		//Prepare url list for the start method
		List<String> queryList = new List<String>();
		queryList.add('https://edpqaapi.azurewebsites.net/api/ProductVersionItems'); 
		
		//set mock callout mode
		Test.setMock(HttpCalloutMock.class, multimock);
		
		HWS_ProductVersionItem_Batch batch = new HWS_ProductVersionItem_Batch();
		Database.BatchableContext bc;
		SchedulableContext sc;
		batch.start(bc);
		batch.execute(sc);
		batch.execute(bc,queryList);		 
		batch.finish(bc);
		Test.StopTest();
		
	}	
	
	 @isTest 
	static void testproductversionitem1() 
	{
		
		//Setting callout mock for loading data from static resource		
		MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		String ciPath = 'https://edpqaapi.azurewebsites.net/api/ProductVersionItems';
		String tokenPath = 'https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token';
		String calloutPath = 'callout:EDP_Login';
		
		multimock.setStaticResource(ciPath, 'ProductVersionItem');
		multimock.setStaticResource(tokenPath,'ProductToken');
		multimock.setStaticResource(calloutPath,'ProductToken');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductVersionItems?&$count=true&$top=1','ProductVersionItemCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductVersionItems?&$skip=1000&$top=1000','ProductVersionItemCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductVersionItems?&$skip=2000&$top=1000','ProductVersionItemCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductVersionItems?&$skip=3000&$top=1000','ProductVersionItemCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductVersionItems?&$skip=4000&$top=1000','ProductVersionItemCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductVersionItems?&$skip=5000&$top=1000','ProductVersionItemCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductVersionItems?&$skip=6000&$top=1000','ProductVersionItemCount');
		 String url1 = 'https://edpqaapi.azurewebsites.net/api/ProductVersionItems';
		system.assertEquals(url1, 'https://edpqaapi.azurewebsites.net/api/ProductVersionItems');
		multimock.setStaticResource(url1,'ProductVersionItem'); 
		
		multimock.setStatusCode(201);
		multimock.setHeader('Content-Type', 'application/json');
		
		Test.startTest();
		
		//Prepare url list for the start method
		List<String> queryList = new List<String>();
		queryList.add('https://edpqaapi.azurewebsites.net/api/ProductVersionItems'); 
		
		//set mock callout mode
		Test.setMock(HttpCalloutMock.class, multimock);
		
		HWS_ProductVersionItem_Batch batch = new HWS_ProductVersionItem_Batch();
		Database.BatchableContext bc;
		SchedulableContext sc;
		batch.start(bc);
		batch.execute(sc);
		batch.execute(bc,queryList);		 
		batch.finish(bc);
		Test.StopTest();
	
		
	}	
	
	
	
	 @isTest 
	static void testproductversionitem5000() 
	{

 	List<EDP_HWS_Settings__c> edpEntryList = new List<EDP_HWS_Settings__c>();
		//Create custom settings entries for test data
		EDP_HWS_Settings__c edpEntry = new EDP_HWS_Settings__c();
		edpEntry.Name = 'ProductVersionItem';
		
		edpEntry.Full_Load_Filter__c ='Yes';
		edpEntry.ModifiedDate__c = Date.newInstance(2019,03,26);
		edpEntryList.add(edpEntry);
		insert edpEntryList;
		HWS_Skipcount__c skipCountValue = HWS_Skipcount__c.getInstance('PVI');
		skipCountValue.Skip_Count__c = 5100;
		update skipCountValue;
		 //Setting callout mock for loading data from static resource		
		 MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		 String ciPath = 'https://edpqaapi.azurewebsites.net/api/ProductVersionItems';
		 String tokenPath = 'https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token';
		 String calloutPath = 'callout:EDP_Login';
		 
		 multimock.setStaticResource(ciPath, 'ProductVersionItem');
		 multimock.setStaticResource(tokenPath,'ProductToken');
		 multimock.setStaticResource(calloutPath,'ProductToken');
		 multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductVersionItems?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$count=true&$top=1','ProductVersionItemCount');
		 
		 String url1 = 'https://edpqaapi.azurewebsites.net/api/ProductVersionItems';
		system.assertEquals(url1, 'https://edpqaapi.azurewebsites.net/api/ProductVersionItems');
		 multimock.setStaticResource(url1,'ProductVersionItem'); 
	
		 multimock.setStatusCode(200);
		 multimock.setHeader('Content-Type', 'application/json');
		 
		 Test.startTest();
		 
		 //Prepare url list for the start method
		 List<String> queryList = new List<String>();
	  queryList.add('https://edpqaapi.azurewebsites.net/api/ProductVersionItems'); 
		 
		 //set mock callout mode
		 Test.setMock(HttpCalloutMock.class, multimock);
		 
		 HWS_ProductVersionItem_Batch batch = new HWS_ProductVersionItem_Batch();
		 Database.BatchableContext bc;
		 SchedulableContext sc;
		 batch.start(bc);
		 batch.execute(sc);
		 batch.execute(bc,queryList);		 
	batch.finish(bc);	  
		 Test.StopTest();
		
	}	
	
	
	@isTest 
	static void testproductversionitem5001() 
	{
		
		
		EDP_HWS_Settings__c edpEntry = EDP_HWS_Settings__c.getInstance('ProductVersionItem');
		edpEntry.Full_Load_Filter__c ='Yes';
		edpEntry.Full_Load__c = false;
		edpEntry.ModifiedDate__c = Date.newInstance(2019,03,26);
		update edpEntry;
		
		//Setting callout mock for loading data from static resource		
		MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		String ciPath = 'https://edpqaapi.azurewebsites.net/api/ProductVersionItems';
		String tokenPath = 'https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token';
		String calloutPath = 'callout:EDP_Login';
		
		multimock.setStaticResource(ciPath, 'ProductVersionItem');
		multimock.setStaticResource(tokenPath,'ProductToken');
		multimock.setStaticResource(calloutPath,'ProductToken');
		 multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductVersionItems?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$count=true&$top=1','ProductVersionItemCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductVersionItems?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=1000&$top=1000','ProductVersionItemCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductVersionItems?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=2000&$top=1000','ProductVersionItemCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductVersionItems?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=3000&$top=1000','ProductVersionItemCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductVersionItems?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=4000&$top=1000','ProductVersionItemCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductVersionItems?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=5000&$top=1000','ProductVersionItemCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductVersionItems?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=6000&$top=1000','ProductVersionItemCount');
		String url1 = 'https://edpqaapi.azurewebsites.net/api/ProductVersionItems';
		system.assertEquals(url1, 'https://edpqaapi.azurewebsites.net/api/ProductVersionItems');
		multimock.setStaticResource(url1,'ProductVersionItem'); 
		
		multimock.setStatusCode(200);
		multimock.setHeader('Content-Type', 'application/json');
		
		Test.startTest();
		
		//Prepare url list for the start method
		List<String> queryList = new List<String>();
		queryList.add('https://edpqaapi.azurewebsites.net/api/ProductVersionItems'); 
		
		//set mock callout mode
		Test.setMock(HttpCalloutMock.class, multimock);
		
		HWS_ProductVersionItem_Batch batch = new HWS_ProductVersionItem_Batch();
		Database.BatchableContext bc;
		SchedulableContext sc;
		batch.start(bc);
		batch.execute(sc);
		batch.execute(bc,queryList);		 
		 batch.finish(bc);
		Test.StopTest();
	
		
	}
	
	
	
	
	@isTest 
	 static void testproductServicableVersionWrapper() 
	 {
		 HWS_UploadToProductVersionItems.PVItemWrapper wrap = new HWS_UploadToProductVersionItems.PVItemWrapper();
		 wrap.Name='test';
		 wrap.Current='test';
		 wrap.Description='test';
		 wrap.NSNCode='90983747576';
		 wrap.NSNSourceSystem='puma';
		 wrap.Revision='test2';
		 wrap.Type='aeh';
		 wrap.UnitofMeasure='tests';
		 wrap.EDP_LastModifiedDate=Date.newInstance(2019,03,26);
		 wrap.EDP_ActiveStatus=true;
		 wrap.SparePart='sparepartsales';
		 system.assertEquals(wrap.SparePart, 'sparepartsales');
	 }
	 @isTest
	 static void getProductVersionItemNull(){
		 List<HWS_Product_Version_Item__c> prodVsnItemList = new List<HWS_Product_Version_Item__c>();
		 HWS_Product_Version_Item__c prodVsnItem = new HWS_Product_Version_Item__c();
		 prodVsnItem.HWS_NSNCode__c = '';
		 prodVsnItem.Name = '';		
		 prodVsnItemList.add(prodVsnItem);		
		 HttpResponse respVsn = new HttpResponse();
		 respVsn.setBody('OKAY!');
		 respVsn.setStatus('OK');
		 respVsn.setStatusCode(200);
		 
		 test.startTest();
		 HWS_UploadToProductVersionItems.createInterfaceLogsAndProductVersionItem(respVsn,prodVsnItemList,'test');
		 test.stopTest();
	}
}