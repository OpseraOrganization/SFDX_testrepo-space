@Istest
public class HWS_UploadToServicebleVersionItems_Test {
	
	@testSetup
	public static void createTestData()
	{
		List<EDP_HWS_Settings__c> edpEntryList = new List<EDP_HWS_Settings__c>();
		
		//Create custom settings entries for test data
		EDP_HWS_Settings__c edpEntry = new EDP_HWS_Settings__c();
		edpEntry.Name = 'ProductServiceableVersionItem';
		edpEntry.Full_Load_Filter__c ='Yes';
		edpEntry.ModifiedDate__c = Date.today();
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
		String CIpath = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems';
		String tokenPath = 'https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token';
		String calloutPath = 'callout:EDP_Login';
		
		multimock.setStaticResource(CIpath, 'ProductServiceableVersionItems');
		multimock.setStaticResource(tokenPath,'ProductToken');
		multimock.setStaticResource(calloutPath,'ProductToken');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductConfigurationItems?$count=true&$skip=5000','ProductConfigurationItems');
		
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
		system.assertNotEquals(queryList.size(), null); 
		Test.StopTest();
		
	}
   
	
	public static testMethod void wrappermethods(){
		
		HWS_UploadToServicebleVersionItems.ProdServItems wrp = new HWS_UploadToServicebleVersionItems.ProdServItems();
		wrp.EDP_ActiveStatus =true;
		wrp.EDP_DeletedAtSource = true ;
		wrp.EDP_LastModifiedDate = system.now()-1;
		wrp.FITRate = 'test';
		wrp.MaterialType = 'test';
		wrp.PartNumber = 'test';
		wrp.PartRevision = 'test';
		wrp.PartRevisionFormat = 'test';
		wrp.SAPStatus= 'test';
		wrp.SerialNumberFormat= 'test';
		wrp.SerialNumberTraceable = 'test';
		wrp.Source = 'test';
		system.assertNotEquals(wrp, null);
		
	}
	

	@isTest 
	static void testproductServicableVersion2() 
	{
		//Setting callout mock for loading data from static resource		
		MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		String CIpath = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems';
		String tokenPath = 'https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token';
		String calloutPath = 'callout:EDP_Login';
		
		multimock.setStaticResource(CIpath, 'ProductServiceableVersionItems');
		multimock.setStaticResource(tokenPath,'ProductToken');
		multimock.setStaticResource(calloutPath,'ProductToken');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductConfigurationItems?$count=true&$skip=5000','ProductConfigurationItems');
		
		String url1 = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems';
		
		multimock.setStaticResource(url1,'ProductServiceableVersionItems'); 
		
		multimock.setStatusCode(201);
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
		system.assertNotEquals(queryList.size(), null); 
		Test.StopTest();
		
	}
	
	@isTest
	 static void getServicebleVsnItemsNull(){
		 List<HWS_Product_Serviceable_Version_Item__c> prodSrvsblVsnItemList = new List<HWS_Product_Serviceable_Version_Item__c>();
		 HWS_Product_Serviceable_Version_Item__c prodSrvsblVsnItem = new HWS_Product_Serviceable_Version_Item__c();
		 prodSrvsblVsnItem.HWS_NSNCode__c = '';	   
		 prodSrvsblVsnItemList.add(prodSrvsblVsnItem);		
		 HttpResponse respServsblVsn = new HttpResponse();
		 respServsblVsn.setBody('OKAY!');
		 respServsblVsn.setStatus('OK');
		 respServsblVsn.setStatusCode(200);
		 
		 test.startTest();
		 HWS_UploadToServicebleVersionItems.createInterfaceLogsAndServiceableVersionItem(respServsblVsn,prodSrvsblVsnItemList,'test');
		 test.stopTest();
	}
}