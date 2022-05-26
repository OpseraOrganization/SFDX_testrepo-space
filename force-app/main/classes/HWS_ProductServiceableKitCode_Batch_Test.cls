/****************************************
 * Class Name : HWS_ProductServiceableKitCode_Batch_Test
 * Created Date: 01 mar 2021
 * Created By : TCS
 * Last Modified by: 
 * Last Modified Date: 
 * Description : 
*****************************************/
@isTest
public class HWS_ProductServiceableKitCode_Batch_Test { 
  
	public static final String ciPath = 'https://edpqaapi.azurewebsites.net/api/Product_ServicableKitBundle';
	public static final String tokenPath = 'https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token';
  @testSetup
  public static void createTestData()
  {
	List<EDP_HWS_Settings__c> edpEntryList = new List<EDP_HWS_Settings__c>();
	 
	 //Create custom settings entries for test data
	 EDP_HWS_Settings__c edpEntry = new EDP_HWS_Settings__c();
	 edpEntry.Name = 'KITPartcode';
	 edpEntry.Full_Load_Filter__c ='Yes';
	 edpEntry.Full_Load__c = true;
	 edpEntry.ModifiedDate__c = Date.today();
	 edpEntryList.add(edpEntry);  
	 insert edpEntryList;
		  
	 List<EDP_URLs__c> edpURLList = new List<EDP_URLs__c>();
	 EDP_URLs__c edpURL1 = new EDP_URLs__c();
	 edpURL1.name = 'KIT';
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
	skipEntry1.name = 'KIT';
	skipEntry1.Skip_Count__c = null;
	skipEntryList.add(skipEntry1);
	insert skipEntryList;
	
	 Product2 prod = new Product2();
	prod.Name ='Test Product 1';
	prod.ProductCode = HWS_Constants.CodeNumber;
	prod.NokiaCPQ_Item_Type__c = 'Hardware';
	prod.HWS_NSNPartCode__c = 'Kit1234';
	insert prod;
	System.assertNotEquals(prod.Name, null);
	
	Product2 prod1 = new Product2();
	prod1.Name ='Test Product 2';
	prod1.ProductCode = HWS_Constants.CodeNumber;
	prod1.NokiaCPQ_Item_Type__c = 'OTHER';
	prod1.HWS_NSNPartCode__c = 'Kit01032021';
	insert prod1;
	
	Product2 prod2 = new Product2();
	prod2.Name ='Test Product 2';
	prod2.ProductCode = HWS_Constants.CodeNumber;
	prod2.NokiaCPQ_Item_Type__c = 'OTHER';
	prod2.HWS_NSNPartCode__c = 'Part01032021';
	insert prod2;
 
  } 
  
  @isTest 
  static void testproductServicableKitcode() 
  {
  //As per sonarcube fixes removed unused local variables
	//Setting callout mock for loading data from static resource	
	MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();

	String calloutPath = HWS_Constants.EDP_Login;
	
	multimock.setStaticResource(ciPath, 'ProductServiceableKitCode');
	multimock.setStaticResource(tokenPath,'ProductToken');
	multimock.setStaticResource(calloutPath,'ProductToken');
	multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/Product_ServicableKitBundle?&$count=true&$top=1','ProductServiceableKitCodeCount');
	
	multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/Product_ServicableKitBundle?&$skip=1000&$top=1000','ProductServiceableKitCodeCount');
	multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/Product_ServicableKitBundle?&$skip=2000&$top=1000','ProductServiceableKitCodeCount');
	multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/Product_ServicableKitBundle?&$skip=3000&$top=1000','ProductServiceableKitCodeCount');
	multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/Product_ServicableKitBundle?&$skip=4000&$top=1000','ProductServiceableKitCodeCount');
	multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/Product_ServicableKitBundle?&$skip=5000&$top=1000','ProductServiceableKitCodeCount');
	multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/Product_ServicableKitBundle?&$skip=6000&$top=1000','ProductServiceableKitCodeCount');
	String url1 = ciPath;
	
	multimock.setStaticResource(url1,'ProductServiceableKitCode'); 
	
	multimock.setStatusCode(200);
	multimock.setHeader(HWS_Constants.content, HWS_Constants.json);
	
	Test.startTest();
	
	//Prepare url list for the start method
	List<String> queryList = new List<String>();
	queryList.add(ciPath); 
	
	//set mock callout mode
	Test.setMock(HttpCalloutMock.class, multimock);
	
	HWS_ProductServiceableKitCode_Batch batch = new HWS_ProductServiceableKitCode_Batch();
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
	
	multimock1.setStaticResource(ciPath, 'ProductServiceableKitCode');
	multimock1.setStaticResource(tokenPath,'ProductToken');
	multimock1.setStaticResource(calloutPath1,'ProductToken');
	multimock1.setStaticResource('https://edpqaapi.azurewebsites.net/api/Product_ServicableKitBundle?&$count=true&$top=1','ProductServiceableKitCodeCount');
	
	multimock1.setStaticResource('https://edpqaapi.azurewebsites.net/api/Product_ServicableKitBundle?&$skip=1000&$top=1000','ProductServiceableKitCodeCount');
	multimock1.setStaticResource('https://edpqaapi.azurewebsites.net/api/Product_ServicableKitBundle?&$skip=2000&$top=1000','ProductServiceableKitCodeCount');
	multimock1.setStaticResource('https://edpqaapi.azurewebsites.net/api/Product_ServicableKitBundle?&$skip=3000&$top=1000','ProductServiceableKitCodeCount');
	multimock1.setStaticResource('https://edpqaapi.azurewebsites.net/api/Product_ServicableKitBundle?&$skip=4000&$top=1000','ProductServiceableKitCodeCount');
	multimock1.setStaticResource('https://edpqaapi.azurewebsites.net/api/Product_ServicableKitBundle?&$skip=5000&$top=1000','ProductServiceableKitCodeCount');
	multimock1.setStaticResource('https://edpqaapi.azurewebsites.net/api/Product_ServicableKitBundle?&$skip=6000&$top=1000','ProductServiceableKitCodeCount');
	 String url11 = ciPath;
	
	multimock1.setStaticResource(url11,'ProductServiceableKitCode'); 
	
	multimock1.setStatusCode(201);
	multimock1.setHeader(HWS_Constants.content, HWS_Constants.json);
	
	Test.startTest();
	
	//Prepare url list for the start method
	List<String> queryList1 = new List<String>();
	queryList1.add(ciPath); 
	
	//set mock callout mode
	Test.setMock(HttpCalloutMock.class, multimock1);
	
	HWS_ProductServiceableKitCode_Batch batch1 = new HWS_ProductServiceableKitCode_Batch();
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
	edpEntry2.Name = 'KITPartcode';
	edpEntry2.Full_Load_Filter__c ='Yes';
	edpEntry2.ModifiedDate__c = Date.newInstance(2019,03,26);
	edpEntryList12.add(edpEntry2);
	insert edpEntryList12;
	
	HWS_Skipcount__c skipCountValue2 = HWS_Skipcount__c.getInstance('KIT');
	skipCountValue2.Skip_Count__c = 5100;
	update skipCountValue2;
	 //Setting callout mock for loading data from static resource	
	 MultiStaticResourceCalloutMock multimock2 = new MultiStaticResourceCalloutMock();

	 
	 String calloutPath2 = HWS_Constants.EDP_Login;
	 
	 multimock2.setStaticResource(ciPath, 'ProductServiceableKitCode');
	 multimock2.setStaticResource(tokenPath,'ProductToken');
	 multimock2.setStaticResource(calloutPath2,'ProductToken');
	 multimock2.setStaticResource('https://edpqaapi.azurewebsites.net/api/Product_ServicableKitBundle?$filter=PMDSOR_UpdateDateTime%20gt%202019-03-26T05:30:00Z&$count=true&$top=1','ProductServiceableKitCodeCount');
	 
	 String url12 = ciPath;
	 
	 multimock2.setStaticResource(url12,'ProductServiceableKitCode'); 
	 
	 multimock2.setStatusCode(200);
	 multimock2.setHeader(HWS_Constants.content, HWS_Constants.json);
	 
	 Test.startTest();
	 
	 //Prepare url list for the start method
	 List<String> queryList2 = new List<String>();
	 queryList2.add(ciPath); 
	 
	 //set mock callout mode
	 Test.setMock(HttpCalloutMock.class, multimock2);
	 
	 HWS_ProductServiceableKitCode_Batch batch2 = new HWS_ProductServiceableKitCode_Batch();
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
	EDP_HWS_Settings__c edpEntry3 = EDP_HWS_Settings__c.getInstance('KITPartcode');
	edpEntry3.Full_Load_Filter__c ='Yes';
	edpEntry3.Full_Load__c = false;
	edpEntry3.ModifiedDate__c = Date.newInstance(2019,03,26);
	update edpEntry3;
	
	//Setting callout mock for loading data from static resource	
	MultiStaticResourceCalloutMock multimock3 = new MultiStaticResourceCalloutMock();

	String calloutPath3 = HWS_Constants.EDP_Login;
	
	multimock3.setStaticResource(ciPath, 'ProductServiceableKitCode');
	multimock3.setStaticResource(tokenPath,'ProductToken');
	multimock3.setStaticResource(calloutPath3,'ProductToken');
	multimock3.setStaticResource('https://edpqaapi.azurewebsites.net/api/Product_ServicableKitBundle?$filter=PMDSOR_UpdateDateTime%20gt%202019-03-26T05:30:00Z&$count=true&$top=1','ProductServiceableKitCodeCount');
	
	multimock3.setStaticResource('https://edpqaapi.azurewebsites.net/api/Product_ServicableKitBundle?$filter=PMDSOR_UpdateDateTime%20gt%202019-03-26T05:30:00Z&$skip=1000&$top=1000','ProductServiceableKitCodeCount');
	multimock3.setStaticResource('https://edpqaapi.azurewebsites.net/api/Product_ServicableKitBundle?$filter=PMDSOR_UpdateDateTime%20gt%202019-03-26T05:30:00Z&$skip=2000&$top=1000','ProductServiceableKitCodeCount');
	multimock3.setStaticResource('https://edpqaapi.azurewebsites.net/api/Product_ServicableKitBundle?$filter=PMDSOR_UpdateDateTime%20gt%202019-03-26T05:30:00Z&$skip=3000&$top=1000','ProductServiceableKitCodeCount');
	multimock3.setStaticResource('https://edpqaapi.azurewebsites.net/api/Product_ServicableKitBundle?$filter=PMDSOR_UpdateDateTime%20gt%202019-03-26T05:30:00Z&$skip=4000&$top=1000','ProductServiceableKitCodeCount');
	multimock3.setStaticResource('https://edpqaapi.azurewebsites.net/api/Product_ServicableKitBundle?$filter=PMDSOR_UpdateDateTime%20gt%202019-03-26T05:30:00Z&$skip=5000&$top=1000','ProductServiceableKitCodeCount');
	multimock3.setStaticResource('https://edpqaapi.azurewebsites.net/api/Product_ServicableKitBundle?$filter=PMDSOR_UpdateDateTime%20gt%202019-03-26T05:30:00Z&$skip=6000&$top=1000','ProductServiceableKitCodeCount');
						
	String url13 = ciPath;
	
	multimock3.setStaticResource(url13,'ProductServiceableKitCode'); 
	
	multimock3.setStatusCode(200);
	multimock3.setHeader(HWS_Constants.content, HWS_Constants.json);
	
	Test.startTest();
	
	//Prepare url list for the start method
	List<String> queryList3 = new List<String>();
	queryList3.add(ciPath); 
	
	//set mock callout mode
	Test.setMock(HttpCalloutMock.class, multimock3);
	
	HWS_ProductServiceableKitCode_Batch batch3 = new HWS_ProductServiceableKitCode_Batch();
	Database.BatchableContext bc3;
	
	batch3.start(bc3);
	batch3.execute(bc3,queryList3);	 
	 batch3.finish(bc3);
	
	Test.StopTest();
  }
  @isTest 
   static void testproductServicableVersionWrapper() 
   {
	 HWS_UploadKITPartcodetoAlternateCode.KITCodesStatgintableWr wrap = new HWS_UploadKITPartcodetoAlternateCode.KITCodesStatgintableWr();
	 wrap.PMDSOR_ActiveStatus = true;
	 wrap.PMDSOR_DeletedAtSource = true;
	 wrap.PMDSOR_UpdateDateTime = date.today();
	 wrap.SourceSystem = 'test';
	 wrap.Kit_BundleCode = 'Kit01032021';
	 wrap.Status = 'Test class';
	 wrap.Comments = 'Comments';
	 wrap.Quantity = 2;
	 wrap.PartNumber = 'Part01032021';
	 
	
   }
	
	 @isTest
	 static void getAlternateProductCodeNull(){
		 List<HWS_AlternateProductCode__c> altProdcCodeList = new List<HWS_AlternateProductCode__c>();
		 HWS_AlternateProductCode__c altprodcode = new HWS_AlternateProductCode__c();
		 altprodcode.name = '';
		 altprodcode.HWS_NSNCode__c = 'test12';		
		 altProdcCodeList.add(altprodcode);		
		 HttpResponse res = new HttpResponse();
		 res.setBody('OKAY!');
		 res.setStatus('OK');
		 res.setStatusCode(200);		 
		 test.startTest();
		 HWS_UploadKITPartcodetoAlternateCode.createInterfaceLogsAndAlternateProductCode(res,altProdcCodeList,'test');
		 test.stopTest();
	}
}