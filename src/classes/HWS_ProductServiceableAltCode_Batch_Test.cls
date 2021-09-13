/****************************************
 * Class Name : HWS_ProductServiceableAltCode_Batch_Test
 * Created Date: 15th mar 2019
 * Created By : TCS
 * Last Modified by: 
 * Last Modified Date: 
 * Description : Test class for loading product Servicable code master data from edp to salesforce 
*****************************************/
@isTest
public class HWS_ProductServiceableAltCode_Batch_Test {
	
	public static final String ciPath = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableAlternateCode';
	public static final String tokenPath = 'https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token';
	@testSetup
	public static void createTestData()
	{
		List<EDP_HWS_Settings__c> edpEntryList = new List<EDP_HWS_Settings__c>();
		 
		 //Create custom settings entries for test data
		 EDP_HWS_Settings__c edpEntry = new EDP_HWS_Settings__c();
		 edpEntry.Name = 'ProductServiceableAltCode';
		 edpEntry.Full_Load_Filter__c ='Yes';
		 edpEntry.Full_Load__c = true;
		 edpEntry.ModifiedDate__c = Date.today();
		 edpEntryList.add(edpEntry);	
		 insert edpEntryList;
	  
		 List<EDP_URLs__c> edpURLList = new List<EDP_URLs__c>();
		 EDP_URLs__c edpURL1 = new EDP_URLs__c();
		 edpURL1.name = 'PSAC';
		 edpURL1.URL__c = ciPath;
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
		skipEntry1.name = 'PSAC';
		skipEntry1.Skip_Count__c = null;
		skipEntryList.add(skipEntry1);
		insert skipEntryList;
	} 
  
	@isTest 
	static void testproductServicableAltcode() 
	{
	//As per sonarcube fixes removed unused local variables
		//Setting callout mock for loading data from static resource		
		MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();

		String calloutPath = HWS_Constants.EDP_Login;
		
		multimock.setStaticResource(ciPath, 'ProductServiceableAltCode');
		multimock.setStaticResource(tokenPath,'ProductToken');
		multimock.setStaticResource(calloutPath,'ProductToken');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableAlternateCode?&$count=true&$top=1','ProductServiceableAltCodeCount');
		
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableAlternateCode?&$skip=1000&$top=1000','ProductServiceableAltCodeCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableAlternateCode?&$skip=2000&$top=1000','ProductServiceableAltCodeCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableAlternateCode?&$skip=3000&$top=1000','ProductServiceableAltCodeCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableAlternateCode?&$skip=4000&$top=1000','ProductServiceableAltCodeCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableAlternateCode?&$skip=5000&$top=1000','ProductServiceableAltCodeCount');
		multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableAlternateCode?&$skip=6000&$top=1000','ProductServiceableAltCodeCount');
		String url1 = ciPath;
		
		multimock.setStaticResource(url1,'ProductServiceableAltCode'); 
		
		multimock.setStatusCode(200);
		multimock.setHeader(HWS_Constants.content, HWS_Constants.json);
		
		Test.startTest();
		
		//Prepare url list for the start method
		List<String> queryList = new List<String>();
		queryList.add(ciPath); 
		
		//set mock callout mode
		Test.setMock(HttpCalloutMock.class, multimock);
		
		HWS_ProductServiceableAltCode_Batch batch = new HWS_ProductServiceableAltCode_Batch();
		Database.BatchableContext bc;
		
		batch.start(bc);
		
		batch.execute(bc,queryList);		 
		batch.finish(bc);
		Test.StopTest();
		
	}   
	
	 @isTest 
	static void testproductServicableAltcode1() 
	{
		
		//Setting callout mock for loading data from static resource		
		MultiStaticResourceCalloutMock multimock1 = new MultiStaticResourceCalloutMock();
		
		
		String calloutPath1= HWS_Constants.EDP_Login;
		
		multimock1.setStaticResource(ciPath, 'ProductServiceableAltCode');
		multimock1.setStaticResource(tokenPath,'ProductToken');
		multimock1.setStaticResource(calloutPath1,'ProductToken');
		multimock1.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableAlternateCode?&$count=true&$top=1','ProductServiceableAltCodeCount');
		
		multimock1.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableAlternateCode?&$skip=1000&$top=1000','ProductServiceableAltCodeCount');
		multimock1.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableAlternateCode?&$skip=2000&$top=1000','ProductServiceableAltCodeCount');
		multimock1.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableAlternateCode?&$skip=3000&$top=1000','ProductServiceableAltCodeCount');
		multimock1.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableAlternateCode?&$skip=4000&$top=1000','ProductServiceableAltCodeCount');
		multimock1.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableAlternateCode?&$skip=5000&$top=1000','ProductServiceableAltCodeCount');
		multimock1.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableAlternateCode?&$skip=6000&$top=1000','ProductServiceableAltCodeCount');
		 String url11 = ciPath;
		
		multimock1.setStaticResource(url11,'ProductServiceableAltCode'); 
		
		multimock1.setStatusCode(201);
		multimock1.setHeader(HWS_Constants.content, HWS_Constants.json);
		
		Test.startTest();
		
		//Prepare url list for the start method
		List<String> queryList1 = new List<String>();
		queryList1.add(ciPath); 
		
		//set mock callout mode
		Test.setMock(HttpCalloutMock.class, multimock1);
		
		HWS_ProductServiceableAltCode_Batch batch1 = new HWS_ProductServiceableAltCode_Batch();
		Database.BatchableContext bc1;
		SchedulableContext sc1;
		batch1.start(bc1);
		batch1.execute(bc1,queryList1);		 
		 batch1.finish(bc1);
		 batch1.execute(sc1);
		Test.StopTest();
		
		
	
	
		
	}   
	
	
	
	 @isTest 
	static void testproductServicableAltcode5000() 
	{
//As per sonarcube fixes removed unused local variables
	List<EDP_HWS_Settings__c> edpEntryList12 = new List<EDP_HWS_Settings__c>();
		//Create custom settings entries for test data
		EDP_HWS_Settings__c edpEntry2 = new EDP_HWS_Settings__c();
		edpEntry2.Name = 'ProductServiceableAltCode';
		edpEntry2.Full_Load_Filter__c ='Yes';
		edpEntry2.ModifiedDate__c = Date.newInstance(2019,03,26);
		edpEntryList12.add(edpEntry2);
		insert edpEntryList12;
		
		HWS_Skipcount__c skipCountValue2 = HWS_Skipcount__c.getInstance('PSAC');
		skipCountValue2.Skip_Count__c = 5100;
		update skipCountValue2;
		 //Setting callout mock for loading data from static resource		
		 MultiStaticResourceCalloutMock multimock2 = new MultiStaticResourceCalloutMock();

		 
		 String calloutPath2 = HWS_Constants.EDP_Login;
		 
		 multimock2.setStaticResource(ciPath, 'ProductServiceableAltCode');
		 multimock2.setStaticResource(tokenPath,'ProductToken');
		 multimock2.setStaticResource(calloutPath2,'ProductToken');
		 multimock2.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableAlternateCode?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$count=true&$top=1','ProductServiceableAltCodeCount');
		 
		 String url12 = ciPath;
		 
		 multimock2.setStaticResource(url12,'ProductServiceableAltCode'); 
	
		 multimock2.setStatusCode(200);
		 multimock2.setHeader(HWS_Constants.content, HWS_Constants.json);
		 
		 Test.startTest();
		 
		 //Prepare url list for the start method
		 List<String> queryList2 = new List<String>();
		 queryList2.add(ciPath); 
		 
		 //set mock callout mode
		 Test.setMock(HttpCalloutMock.class, multimock2);
		 
		 HWS_ProductServiceableAltCode_Batch batch2 = new HWS_ProductServiceableAltCode_Batch();
		 Database.BatchableContext bc2;
		
		 batch2.start(bc2);
		
		 batch2.execute(bc2,queryList2);		 
		 batch2.finish(bc2);	  
		 Test.StopTest();
		
	}   
	
	
	@isTest 
	static void testproductServicableAltcode5001() 
	{
	//As per sonarcube fixes removed unused local variables
		EDP_HWS_Settings__c edpEntry3 = EDP_HWS_Settings__c.getInstance('ProductServiceableAltCode');
		edpEntry3.Full_Load_Filter__c ='Yes';
		edpEntry3.Full_Load__c = false;
		edpEntry3.ModifiedDate__c = Date.newInstance(2019,03,26);
		update edpEntry3;
		
		//Setting callout mock for loading data from static resource		
		MultiStaticResourceCalloutMock multimock3 = new MultiStaticResourceCalloutMock();

		String calloutPath3 = HWS_Constants.EDP_Login;
		
		multimock3.setStaticResource(ciPath, 'ProductServiceableAltCode');
		multimock3.setStaticResource(tokenPath,'ProductToken');
		multimock3.setStaticResource(calloutPath3,'ProductToken');
		multimock3.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableAlternateCode?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$count=true&$top=1','ProductServiceableAltCodeCount');
		
		multimock3.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableAlternateCode?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=1000&$top=1000','ProductServiceableAltCodeCount');
		multimock3.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableAlternateCode?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=2000&$top=1000','ProductServiceableAltCodeCount');
		multimock3.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableAlternateCode?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=3000&$top=1000','ProductServiceableAltCodeCount');
		multimock3.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableAlternateCode?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=4000&$top=1000','ProductServiceableAltCodeCount');
		multimock3.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableAlternateCode?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=5000&$top=1000','ProductServiceableAltCodeCount');
		multimock3.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableAlternateCode?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=6000&$top=1000','ProductServiceableAltCodeCount');
			
		String url13 = ciPath;
		
		multimock3.setStaticResource(url13,'ProductServiceableAltCode'); 
		
		multimock3.setStatusCode(200);
		multimock3.setHeader(HWS_Constants.content, HWS_Constants.json);
		
		Test.startTest();
		
		//Prepare url list for the start method
		List<String> queryList3 = new List<String>();
		queryList3.add(ciPath); 
		
		//set mock callout mode
		Test.setMock(HttpCalloutMock.class, multimock3);
		
		HWS_ProductServiceableAltCode_Batch batch3 = new HWS_ProductServiceableAltCode_Batch();
		Database.BatchableContext bc3;
		
		batch3.start(bc3);
		batch3.execute(bc3,queryList3);		 
		 batch3.finish(bc3);
		
		Test.StopTest();
	
		
	}
	
   
	@isTest 
	 static void testproductServicableVersionWrapper() 
	 {
		 HWS_UploadToProductServicableAltCodes.ProdAltCodeWrapper wrap = new HWS_UploadToProductServicableAltCodes.ProdAltCodeWrapper();
		 wrap.EDP_ActiveStatus = true;
		 wrap.EDP_DeletedAtSource = true;
		 wrap.EDP_LastModifiedDate = date.today();
		 wrap.NSNCode='2';
		 wrap.AlternateCodeValue = 'none';
		
		 wrap.AlternateCodeType='223';
		 wrap.PartType = 'test';
		 
		 wrap.Source='test';
		
	 }
	 
	 @isTest
	 static void getAltServicbleProductCodeNull(){
		 List<HWS_AlternateProductCode__c> altServicbleProdcCodeList = new List<HWS_AlternateProductCode__c>();
		 HWS_AlternateProductCode__c altservbleprodcode = new HWS_AlternateProductCode__c();
		 altservbleprodcode.name = '';
		 altservbleprodcode.HWS_NSNCode__c = 'test12';		
		 altServicbleProdcCodeList.add(altservbleprodcode);		
		 HttpResponse resps = new HttpResponse();
		 resps.setBody('OKAY!');
		 resps.setStatus('OK');
		 resps.setStatusCode(200);
		 
		 test.startTest();
		 HWS_UploadToProductServicableAltCodes.createInterfaceLogsAndProductServiceableAltCode(resps,altServicbleProdcCodeList,'test');
		 test.stopTest();
	}
}