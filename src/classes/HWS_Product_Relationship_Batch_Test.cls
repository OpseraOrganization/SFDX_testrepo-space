/****************************************
* Class Name : HWS_Product_Relationship_Batch_Test
* Created Date: 3rd mar 2019
* Created By : TCS
* Last Modified by: 
* Last Modified Date: 
* Description : Test class for loading product relationship master data from edp to salesforce 
*****************************************/
@isTest
public class HWS_Product_Relationship_Batch_Test {
	@testSetup
	static void createTestData()
	{
		List<EDP_HWS_Settings__c> edpEntryList = new List<EDP_HWS_Settings__c>();
		
		//Create custom settings entries for test data
		EDP_HWS_Settings__c edpEntry = new EDP_HWS_Settings__c();
		edpEntry.Name = 'ProductRelation';
		edpEntry.Full_Load__c = true;
		edpEntry.Full_Load_Filter__c ='Yes';
		edpEntry.ModifiedDate__c = Date.today();
		edpEntryList.add(edpEntry);
		insert edpEntryList;
		
		edpEntry.ModifiedDate__c = null;
	
		
		List<EDP_URLs__c> edpURLList = new List<EDP_URLs__c>();
		EDP_URLs__c edpURL1 = new EDP_URLs__c();
		edpURL1.name = 'Product_Relation';
		edpURL1.URL__c = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations';
		edpURLList.add(edpURL1);
		
		// inserting resource data required to generate the Token
		EDP_URLs__c edpURL2 = new EDP_URLs__c();
		edpURL2.name = 'resource';
		edpURL2.URL__c = 'https://edpqaapi.azurewebsites.net';
		edpURLList.add(edpURL2);
		
		insert edpURLList;
		
		Product_Relation__c productRel = new Product_Relation__c();
		productRel.Child_ID__c	 = '00000001';
		productRel.Child_Name__c			= '00000001';
		productRel.Parent_ID__c	= '133-060762_00';
		productRel.EDPActiveStatus__c	= true;
		productRel.RelationType__c	= 'EBOM';
		productRel.Combined_key__c	= '00000001_133-060762_00';
		insert productRel;
		
		
		//creating data for Skip Count
		List<HWS_Skipcount__c> skipEntryList = new List<HWS_Skipcount__c>();
		HWS_Skipcount__c skipEntry1 = new HWS_Skipcount__c();
		skipEntry1.name = 'PSR';
		skipEntry1.Skip_Count__c = null;
		skipEntryList.add(skipEntry1);
		insert skipEntryList;
		
	}
	@isTest 
	static void testproductServicableRelation() 
	{
		//Setting callout mock for loading data from static resource		
		MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		String ciPath = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations';
		String tokenPath = 'https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token';
		String calloutPath = 'callout:EDP_Login';
		
		multimock.setStaticResource(ciPath, 'ProductServiceableRelations');
		multimock.setStaticResource(tokenPath,'ProductToken');
		multimock.setStaticResource(calloutPath,'ProductToken');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations?&$count=true&$top=1','ProductServiceableRelationsCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations?&$skip=1000&$top=1000','ProductServiceableRelationsCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations?&$skip=2000&$top=1000','ProductServiceableRelationsCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations?&$skip=3000&$top=1000','ProductServiceableRelationsCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations?&$skip=4000&$top=1000','ProductServiceableRelationsCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations?&$skip=5000&$top=1000','ProductServiceableRelationsCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations?&$skip=6000&$top=1000','ProductServiceableRelationsCount');
		
		String url1 = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations';
		system.assertEquals(url1, 'https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations');
		multimock.setStaticResource(url1,'ProductServiceableRelations'); 
		
		multimock.setStatusCode(200);
		multimock.setHeader('Content-Type', 'application/json');
		
		Test.startTest();
		
		//Prepare url list for the start method
		List<String> queryList = new List<String>();
		queryList.add('https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations'); 
		
		//set mock callout mode
		Test.setMock(HttpCalloutMock.class, multimock);
		
		HWS_Product_Relationship_Batch batch = new HWS_Product_Relationship_Batch();
		Database.BatchableContext bc;
		SchedulableContext sc;
		batch.start(bc);
		batch.execute(sc);
		batch.execute(bc,queryList);		 
		batch.finish(bc);
		Test.StopTest();
		
	}   
	
	 @isTest 
	static void testproductServicableRelationship1() 
	{
		
		//Setting callout mock for loading data from static resource		
		MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		String ciPath = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations';
		String tokenPath = 'https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token';
		String calloutPath = 'callout:EDP_Login';
		
		multimock.setStaticResource(ciPath, 'ProductServiceableRelations');
		multimock.setStaticResource(tokenPath,'ProductToken');
		multimock.setStaticResource(calloutPath,'ProductToken');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations?&$count=true&$top=1','ProductServiceableRelationsCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations?&$skip=1000&$top=1000','ProductServiceableRelationsCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations?&$skip=2000&$top=1000','ProductServiceableRelationsCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations?&$skip=3000&$top=1000','ProductServiceableRelationsCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations?&$skip=4000&$top=1000','ProductServiceableRelationsCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations?&$skip=5000&$top=1000','ProductServiceableRelationsCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations?&$skip=6000&$top=1000','ProductServiceableRelationsCount');
		 String url1 = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations';
		system.assertEquals(url1, 'https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations');
		multimock.setStaticResource(url1,'ProductServiceableRelations'); 
		
		multimock.setStatusCode(201);
		multimock.setHeader('Content-Type', 'application/json');
		
		Test.startTest();
		
		//Prepare url list for the start method
		List<String> queryList = new List<String>();
		queryList.add('https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations'); 
		
		//set mock callout mode
		Test.setMock(HttpCalloutMock.class, multimock);
		
		HWS_Product_Relationship_Batch batch = new HWS_Product_Relationship_Batch();
		Database.BatchableContext bc;
		SchedulableContext sc;
		batch.start(bc);
		batch.execute(sc);
		batch.execute(bc,queryList);		 
		 batch.finish(bc);
		Test.StopTest();
	
		
	}   
	
	
	
	 @isTest 
	static void testproductServicableRelationship5000() 
	{

	List<EDP_HWS_Settings__c> edpEntryList = new List<EDP_HWS_Settings__c>();
		//Create custom settings entries for test data
		EDP_HWS_Settings__c edpEntry = new EDP_HWS_Settings__c();
		edpEntry.Name = 'ProductRelation';
		
		edpEntry.Full_Load_Filter__c ='Yes';
		edpEntry.ModifiedDate__c = Date.newInstance(2019,03,26);
		edpEntryList.add(edpEntry);
		insert edpEntryList;
		HWS_Skipcount__c skipCountValue = HWS_Skipcount__c.getInstance('PSR');
		skipCountValue.Skip_Count__c = 5100;
		update skipCountValue;
		 //Setting callout mock for loading data from static resource		
		 MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		 String ciPath = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations';
		 String tokenPath = 'https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token';
		 String calloutPath = 'callout:EDP_Login';
		 
		 multimock.setStaticResource(ciPath, 'ProductServiceableRelations');
		 multimock.setStaticResource(tokenPath,'ProductToken');
		 multimock.setStaticResource(calloutPath,'ProductToken');
		 multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$count=true&$top=1','ProductServiceableRelationsCount');
		 
		 String url1 = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations';
		 system.assertEquals(url1, 'https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations');
		 multimock.setStaticResource(url1,'ProductServiceableRelations'); 
	
		 multimock.setStatusCode(200);
		 multimock.setHeader('Content-Type', 'application/json');
		 
		 Test.startTest();
		 
		 //Prepare url list for the start method
		 List<String> queryList = new List<String>();
		 queryList.add('https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations'); 
		 
		 //set mock callout mode
		 Test.setMock(HttpCalloutMock.class, multimock);
		 
		 HWS_Product_Relationship_Batch batch = new HWS_Product_Relationship_Batch();
		 Database.BatchableContext bc;
		 SchedulableContext sc;
		 batch.start(bc);
		 batch.execute(sc);
		 batch.execute(bc,queryList);		 
		 batch.finish(bc);	  
		 Test.StopTest();
		
	}   
	
	
	@isTest 
	static void testproductServicableRelationship5001() 
	{
	 
		
		EDP_HWS_Settings__c edpEntry = EDP_HWS_Settings__c.getInstance('ProductRelation');
		edpEntry.Full_Load_Filter__c ='Yes';
		edpEntry.Full_Load__c = false;
		edpEntry.ModifiedDate__c = Date.newInstance(2019,03,26);
		update edpEntry;
		
		//Setting callout mock for loading data from static resource		
		MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		String ciPath = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations';
		String tokenPath = 'https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token';
		String calloutPath = 'callout:EDP_Login';
		
		multimock.setStaticResource(ciPath, 'ProductServiceableRelations');
		multimock.setStaticResource(tokenPath,'ProductToken');
		multimock.setStaticResource(calloutPath,'ProductToken');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$count=true&$top=1','ProductServiceableRelationsCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=1000&$top=1000','ProductServiceableRelationsCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=2000&$top=1000','ProductServiceableRelationsCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=3000&$top=1000','ProductServiceableRelationsCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=4000&$top=1000','ProductServiceableRelationsCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=5000&$top=1000','ProductServiceableRelationsCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=6000&$top=1000','ProductServiceableRelationsCount');

		
		String url1 = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations';
		system.assertEquals(url1, 'https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations');
		multimock.setStaticResource(url1,'ProductServiceableRelations'); 
		
		multimock.setStatusCode(200);
		multimock.setHeader('Content-Type', 'application/json');
		
		Test.startTest();
		
		//Prepare url list for the start method
		List<String> queryList = new List<String>();
		queryList.add('https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations'); 
		
		//set mock callout mode
		Test.setMock(HttpCalloutMock.class, multimock);
		
		HWS_Product_Relationship_Batch batch = new HWS_Product_Relationship_Batch();
		Database.BatchableContext bc;
		SchedulableContext sc;
		batch.start(bc);
		batch.execute(sc);
		batch.execute(bc,queryList);		 
		 batch.finish(bc);
		Test.StopTest();
	
		
	}
	
	@isTest 
	static void testproductServicableSalesWrapper() 
	{
	HWS_UploadToProductRelation.ProdRelWrapper wrap = new HWS_UploadToProductRelation.ProdRelWrapper();
		//wrap.AlternateCode = 'test';
		//wrap.AlternateSpace = 'test';
		// variable names updated as per the HWS_UploadToServicebleSalesItems class
		wrap.HWSSIPartNumber = 'test';
		wrap.HWSVIPartNumber = 'test';
		wrap.HWSVIPartRevisionHWSVIToICS = 'test';
		wrap.PCIIdentifier = 'test';
			
			wrap.EDP_ActiveStatus = true;
			wrap.EDP_DeletedAtSource = false;
			wrap.EDP_LastModifiedDate = date.today();
		
			wrap.PrimaryProductCode ='yes';
			
			wrap.ProductCode = 'test';
			wrap.Source = 'test';
		
			system.assertEquals( wrap.PrimaryProductCode, 'yes');
	}
	
	@isTest
	 static void getprodServiceblereltnNameNull(){
		 List<HWS_Product_Serviceable_Relations__c> prodSrvsblRelNameList = new List<HWS_Product_Serviceable_Relations__c>();
		 HWS_Product_Serviceable_Relations__c prodSrvsblRelName = new HWS_Product_Serviceable_Relations__c();
		 prodSrvsblRelName.HWS_ProductCode__c = '';	   
		 prodSrvsblRelNameList.add(prodSrvsblRelName);		
		 HttpResponse respRelName = new HttpResponse();
		 respRelName.setBody('OKAY!');
		 respRelName.setStatus('OK');
		 respRelName.setStatusCode(200);
		 
		 test.startTest();
		 HWS_UploadToProductRelation.createInterfaceLogsAndProductRelationship(respRelName,prodSrvsblRelNameList,'test');
		 test.stopTest();
	}
}