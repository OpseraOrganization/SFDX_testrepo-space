@isTest
public class HWS_PMDSoRComponentToProductBatch_Test {
   public static final String cIpath = 'https://pmd-qa-api.azurewebsites.net/api/StandardHWComponents?$expand=MainAttributes';
   public static  final String product = 'https://pmd-qa-api.azurewebsites.net/api/StandardHWComponents?$expand=MainAttributes&$filter=Modified%20gt%202019-03-26T05:30:00Z&$top=1&$count=true';
   public static final String product1 = 'https://pmd-qa-api.azurewebsites.net/api/StandardHWComponents?$expand=MainAttributes?&$count=true&$top=1';
   public static final String product2 = 'https://pmd-qa-api.azurewebsites.net/api/StandardHWComponents?$expand=MainAttributes?&$skip=1000&$top=1000';
	@testSetup
	Static void createCustSettingData(){
		
		List<EDP_URLs__c> edpURLs = new List<EDP_URLs__c>();
		EDP_URLs__c eURL1 = new EDP_URLs__c();
		eURL1.name = 'PMDSoRComponentToProduct';
		eURL1.URL__c = cIpath;
		edpURLs.add(eURL1);
		
		EDP_URLs__c eURL2 = new EDP_URLs__c();
	eURL2.name = 'PMDResource';
	eURL2.URL__c = 'https://pmd-qa-api.azurewebsites.net';
	edpURLs.add(eURL2);
	insert edpURLs;
		
		List<EDP_HWS_Settings__c> edpSettingList = new List<EDP_HWS_Settings__c>();
		EDP_HWS_Settings__c edpSetting = new EDP_HWS_Settings__c();
		edpSetting.Name = 'PMDSoRComponentToProduct';
		edpSetting.Full_Load_Filter__c ='Yes';
		edpSetting.Full_Load__c = true;
		edpSetting.ModifiedDate__c = Date.today();
		edpSettingList.add(edpSetting);
		insert edpSettingList;
		
		List<HWS_Skipcount__c> skipCountList = new List<HWS_Skipcount__c>();
		HWS_Skipcount__c skipCount = new HWS_Skipcount__c();
		skipCount.name = 'PMDSoRComponentToProduct';
		skipCount.Skip_Count__c = null;
		skipCountList.add(skipCount);
		insert skipCountList;
		List<HWS_Product_Serviceable_Sales_Item__c> pssiList = new List<HWS_Product_Serviceable_Sales_Item__c>();
		HWS_Product_Serviceable_Sales_Item__c pssi = new HWS_Product_Serviceable_Sales_Item__c();
		pssi.HWS_Part_Number__c='12345';
		pssi.HWS_NSNCode__c='12345';
		pssi.HWS_Item_Type__c='Component';
		HWS_Product_Serviceable_Sales_Item__c pssi1 = new HWS_Product_Serviceable_Sales_Item__c();
		pssi1.HWS_Part_Number__c='P403499';
		pssi1.HWS_NSNCode__c='P403499';
		pssi1.HWS_Item_Type__c='Component';
		pssiList.add(pssi);
		pssiList.add(pssi1);
		insert pssiList;
		Id devRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Sales_Product').getRecordTypeId();
		Product2 prod = new Product2();
		prod.RecordTypeId = devRecordTypeId;
		prod.HWS_NSNPartCode__c='P403499';
		prod.PMD_Product_Item_Type__c='HW Standard Component';
		prod.Name = 'test454'; 
		insert prod;
		
	}
	Public Static MultiStaticResourceCalloutMock createMockResponse(integer statusCode){
		MultiStaticResourceCalloutMock mockCallout = new MultiStaticResourceCalloutMock();
		
	String tokenPath = 'https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token';
	String calloutPath = 'callout:EDP_Login';
	mockCallout.setStaticResource(cIpath, 'PMDSoRComponentToProduct');
	mockCallout.setStaticResource(tokenPath,'ProductToken');
	mockCallout.setStaticResource(calloutPath,'ProductToken');
		mockCallout.setStatusCode(statusCode);
	mockCallout.setHeader('Content-Type', 'application/json');
		return mockCallout;
	}
	@isTest
	Static void PMDSoRComponentToProductBatch1(){
		
		MultiStaticResourceCalloutMock mockCallout = createMockResponse(200);
		test.startTest();
		List<String> queryList = new List<String>();
		queryList.add(cIpath);
		mockCallout.setStaticResource(product1, 'PMDSoRComponentToProduct');
		mockCallout.setStaticResource(product2, 'PMDSoRComponentToProduct');
		Test.setMock(HttpCalloutMock.class, mockCallout);
		HWS_PMDSoRComponentToProductBatch productBatch = new HWS_PMDSoRComponentToProductBatch();
		Database.BatchableContext bC;
		SchedulableContext sC;
		productBatch.start(bC);
		productBatch.execute(bC,queryList);	 
		productBatch.finish(bC);
		productBatch.execute(sC);
		test.stopTest();
	}
	@isTest
	static void updatepssiList(){
		List<HWS_Product_Serviceable_Sales_Item__c> pssiList1= new List<HWS_Product_Serviceable_Sales_Item__c>();
		List<HWS_Product_Serviceable_Sales_Item__c> pssiList = [Select Id,HWS_Part_Number__c from HWS_Product_Serviceable_Sales_Item__c where HWS_Item_Type__c='Component'];
		for(HWS_Product_Serviceable_Sales_Item__c pss : pssiList){
			pss.HWS_isComponentInsertToProduct2__c=true;
			pssiList1.add(pss);
		}
		update pssiList1;
		EDP_HWS_Settings__c  pcEntry = EDP_HWS_Settings__c.getInstance('PMDSoRComponentToProduct');
		pcEntry.Full_Load__c =false;
		pcEntry.ModifiedDate__c = Date.newInstance(2019,03,26);
		update pcEntry;
	}
	@isTest
	static void updatepssiList1(){
		EDP_HWS_Settings__c  pcEntry = EDP_HWS_Settings__c.getInstance('PMDSoRComponentToProduct');
		pcEntry.Full_Load__c =false;
		pcEntry.ModifiedDate__c = Date.newInstance(2019,03,26);
		update pcEntry;
	}
	@isTest
	Static void PMDSoRComponentToProductBatch2(){
		updatepssiList();
	   
		MultiStaticResourceCalloutMock mockCallout = createMockResponse(200);
		test.startTest();
		List<String> queryList = new List<String>();
		queryList.add(cIpath);
		mockCallout.setStaticResource(product,'PMDSoRComponentToProductCount');
		mockCallout.setStaticResource(product1, 'PMDSoRComponentToProduct');
		mockCallout.setStaticResource(product2, 'PMDSoRComponentToProduct');
		Test.setMock(HttpCalloutMock.class, mockCallout);
		HWS_PMDSoRComponentToProductBatch productBatch = new HWS_PMDSoRComponentToProductBatch();
		Database.BatchableContext bC;
		SchedulableContext sC;
		productBatch.start(bC);
		productBatch.execute(bC,queryList);	 
		productBatch.finish(bC);
		productBatch.execute(sC);
		test.stopTest();
	}
	@isTest
	Static void PMDSoRComponentToProductBatch3(){
		
		updatepssiList1();
		
		MultiStaticResourceCalloutMock mockCallout = createMockResponse(200);
		test.startTest();
		List<String> queryList = new List<String>();
		queryList.add(cIpath);
		mockCallout.setStaticResource(product, 'PMDSoRComponentToProductCount');
		mockCallout.setStaticResource(product1, 'PMDSoRComponentToProduct');
		mockCallout.setStaticResource(product2, 'PMDSoRComponentToProduct');
		Test.setMock(HttpCalloutMock.class, mockCallout);
		HWS_PMDSoRComponentToProductBatch productBatch = new HWS_PMDSoRComponentToProductBatch();
		Database.BatchableContext bC;
		SchedulableContext sC;
		productBatch.start(bC);
		productBatch.execute(bC,queryList);	 
		productBatch.finish(bC);
		productBatch.execute(sC);
		test.stopTest();
	}
}