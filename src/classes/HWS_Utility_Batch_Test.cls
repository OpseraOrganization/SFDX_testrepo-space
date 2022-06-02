/****************************************
* Name : HWS_Utility_Batch_Test
* Author : TCS
* Description : This class is for util batch for HWS
* ReqNo : 
****************************************/
@isTest
public class HWS_Utility_Batch_Test {
	public static final String PSRUrl = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations';
	public static final String PSSUrl = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems';
	public static final String PSVUrl = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems';
	public static final String PVUrl = 'https://edpqaapi.azurewebsites.net/api/ProductVersionItems';
	public static final String MAUrl = 'https://pmd-qa-api.azurewebsites.net/api/StandardHWComponents?$expand=MainAttributes';
	public static final String TokenPathUrl = 'https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token';
	public static final String PSAUrl = 'https://edpqaapi.azurewebsites.net/api/ProductServiceableAlternateCode';
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
		
		EDP_HWS_Settings__c edpEntry1 = new EDP_HWS_Settings__c();
		edpEntry1.Name = 'ProductServiceableSalesItem';
		edpEntry1.Full_Load_Filter__c ='Yes';
		edpEntry1.Full_Load__c = true;
		edpEntry1.ModifiedDate__c = Date.today();
		edpEntryList.add(edpEntry1);
		
		EDP_HWS_Settings__c edpEntry2 = new EDP_HWS_Settings__c();
		edpEntry2.Name = 'ProductServiceableVersionItem';
		edpEntry2.Full_Load_Filter__c ='Yes';
		edpEntry2.Full_Load__c = true;
		edpEntry2.ModifiedDate__c = Date.today();
		edpEntryList.add(edpEntry2);
		
		//start changes
		EDP_HWS_Settings__c edpEntry3 = new EDP_HWS_Settings__c();
		edpEntry3.Name = 'ProductServiceableAltCode';
		edpEntry3.Full_Load_Filter__c ='Yes';
		edpEntry3.ModifiedDate__c = Date.today();
		edpEntryList.add(edpEntry3);
		
		EDP_HWS_Settings__c edpEntry4 = new EDP_HWS_Settings__c();
		edpEntry4.Name = 'ProductVersionItem';
		edpEntry4.Full_Load_Filter__c ='Yes';
		edpEntry4.ModifiedDate__c = Date.today();
		edpEntryList.add(edpEntry4);
		
		EDP_HWS_Settings__c edpSetting = new EDP_HWS_Settings__c();
		edpSetting.Name = 'PMDSoRComponentToProduct';
		edpSetting.Full_Load_Filter__c ='Yes';
		edpSetting.ModifiedDate__c = Date.today();
		edpEntryList.add(edpSetting);
		
		// end changes
		insert edpEntryList;
		
		List<EDP_URLs__c> edpURLList = new List<EDP_URLs__c>();
		EDP_URLs__c edpURL1 = new EDP_URLs__c();
		edpURL1.name = 'Product_Relation';
		edpURL1.URL__c = PSRUrl;
		edpURLList.add(edpURL1);
		
		EDP_URLs__c edpURL2 = new EDP_URLs__c();
		edpURL2.name = 'PSSI';
		edpURL2.URL__c = PSSUrl;
		edpURLList.add(edpURL2);
		
		EDP_URLs__c edpURL3 = new EDP_URLs__c();
		edpURL3.name = 'PSVI';
		edpURL3.URL__c = PSVUrl;
		edpURLList.add(edpURL3);
		
		EDP_URLs__c edpURL4 = new EDP_URLs__c();
		edpURL4.name = 'resource';
		edpURL4.URL__c = 'https://edpqaapi.azurewebsites.net';
		edpURLList.add(edpURL4);
		// start changes
		EDP_URLs__c edpURL5 = new EDP_URLs__c();
		edpURL5.name = 'PSAC';
		edpURL5.URL__c = 'https://edpqaapi.azurewebsites.net/api/Productserviceablealernatecodes';
		edpURLList.add(edpURL5);
		
		EDP_URLs__c edpURL6 = new EDP_URLs__c();
		edpURL6.name = 'PVI';
		edpURL6.URL__c = PVUrl;
		edpURLList.add(edpURL6);
		
		EDP_URLs__c eURL7 = new EDP_URLs__c();
		eURL7.name = 'PMDSoRComponentToProduct';
		eURL7.URL__c = MAUrl;
		edpURLList.add(eURL7);
		
		EDP_URLs__c eURL8 = new EDP_URLs__c();
		eURL8.name = 'PMDResource';
		eURL8.URL__c = 'https://pmd-qa-api.azurewebsites.net';
		edpURLList.add(eURL8);
		//End Changes	   
		insert edpURLList;
		
		Product_Relation__c productRel = new Product_Relation__c();
		productRel.Child_ID__c   = '00000001';
		productRel.Child_Name__c			= '00000001';
		productRel.Parent_ID__c = '133-060762_00';
		productRel.EDPActiveStatus__c   = true;
		productRel.RelationType__c   ='test';
		productRel.Combined_key__c  = '00000001_133-060762_00';
		insert productRel;
		
		//start changes
		//creating data for Skip Count
		List<HWS_Skipcount__c> skipEntryList = new List<HWS_Skipcount__c>();
		HWS_Skipcount__c skipEntry1 = new HWS_Skipcount__c();
		skipEntry1.name = 'PSAC';
		skipEntry1.Skip_Count__c = null;
		skipEntryList.add(skipEntry1);
		
		HWS_Skipcount__c skipEntry2 = new HWS_Skipcount__c();
		skipEntry2.name = 'PVI';
		skipEntry2.Skip_Count__c = null;
		skipEntryList.add(skipEntry2);
		
		HWS_Skipcount__c skipEntry3 = new HWS_Skipcount__c();
		skipEntry3.name = 'PSR';
		skipEntry3.Skip_Count__c = null;
		skipEntryList.add(skipEntry3);
		
		HWS_Skipcount__c skipEntry4 = new HWS_Skipcount__c();
		skipEntry4.name = 'PSVI';
		skipEntry4.Skip_Count__c = null;
		skipEntryList.add(skipEntry4);
		
		HWS_Skipcount__c skipEntry5 = new HWS_Skipcount__c();
		skipEntry5.name = 'PSSI';
		skipEntry5.Skip_Count__c = null;
		skipEntryList.add(skipEntry5); 
		
		HWS_Skipcount__c skipEntry6 = new HWS_Skipcount__c();
		skipEntry6.name = 'PMDSoRComponentToProduct';
		skipEntry6.Skip_Count__c = null;
		skipEntryList.add(skipEntry6);
		insert skipEntryList;
		
		List<HWS_Product_Serviceable_Sales_Item__c> pssiList = new List<HWS_Product_Serviceable_Sales_Item__c>();
		HWS_Product_Serviceable_Sales_Item__c pssi = new HWS_Product_Serviceable_Sales_Item__c();
		pssi.HWS_Part_Number__c='12345';
		pssi.HWS_NSNCode__c='12345';
		pssiList.add(pssi);
		HWS_Product_Serviceable_Sales_Item__c pssi1 = new HWS_Product_Serviceable_Sales_Item__c();
		pssi1.HWS_Part_Number__c='123456';
		pssi1.HWS_NSNCode__c='123456';
		pssiList.add(pssi1);
		insert pssiList;
		
		List<HWS_Product_Serviceable_Relations__c> prodServiceRelationList = new List<HWS_Product_Serviceable_Relations__c>();
		HWS_Product_Serviceable_Relations__c prodServiceRelation = new HWS_Product_Serviceable_Relations__c();
		prodServiceRelation.HWS_HWSSIPartNumber__c = HWS_Constants.CodeNumber;
		prodServiceRelation.HWS_Product_Code__c = HWS_Constants.CodeNumber;
		prodServiceRelation.HWS_Is_Processed__c = false;
		prodServiceRelationList.add(prodServiceRelation);
		insert prodServiceRelationList;
		
		Product2 prod = new Product2();
		prod.Name ='Test Product 1';
		prod.ProductCode = HWS_Constants.CodeNumber;
		prod.NokiaCPQ_Item_Type__c = 'Hardware';
		insert prod;
		System.assertNotEquals(prod.Name, null);
		
		Product2 prod1 = new Product2();
		prod1.Name ='Test Product 2';
		prod1.ProductCode = HWS_Constants.CodeNumber;
		prod1.NokiaCPQ_Item_Type__c = 'OTHER';
		insert prod1;
		
		CH_ProductRelation__c chProdRelation = new CH_ProductRelation__c();
		chProdRelation.CH_Child_Product__c = prod.Id;
		chProdRelation.CH_Parent_Product__c = prod1.Id;
		chProdRelation.CH_ExternalId__c = '085849A833-049122_00';
		insert chProdRelation;

	}
	Public Static MultiStaticResourceCalloutMock createMockResponse(integer statusCode){
		MultiStaticResourceCalloutMock mockCallout = new MultiStaticResourceCalloutMock();
		String calloutPath = HWS_Constants.EDP_Login;
		mockCallout.setStaticResource(MAUrl, 'PMDSoRComponentToProduct');
		mockCallout.setStaticResource(TokenPathUrl,'ProductToken');
		mockCallout.setStaticResource(calloutPath,'ProductToken');
		
		mockCallout.setStatusCode(statusCode);
		mockCallout.setHeader(HWS_Constants.Content, HWS_Constants.json);
		return mockCallout;
	}
	@isTest
	Static void PMDSoRComponentToProductBatch1(){
		
		MultiStaticResourceCalloutMock mockCallout = createMockResponse(200);
		test.startTest();
		List<String> queryList = new List<String>();
		queryList.add(MAUrl);
		mockCallout.setStaticResource('https://pmd-qa-api.azurewebsites.net/api/StandardHWComponents?$expand=MainAttributes?&$count=true&$top=1', 'PMDSoRComponentToProduct');
		mockCallout.setStaticResource('https://pmd-qa-api.azurewebsites.net/api/StandardHWComponents?$expand=MainAttributes?&$skip=1000&$top=1000', 'PMDSoRComponentToProduct');
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
	static void testproductServicableVersion() 
	{
		//Setting callout mock for loading data from static resource		
		MultiStaticResourceCalloutMock multimock1 = new MultiStaticResourceCalloutMock();
		String calloutPath1 = HWS_Constants.EDP_Login;
		
		multimock1.setStaticResource(PSVUrl, 'ProductServiceableVersionItems');
		multimock1.setStaticResource(TokenPathUrl,'ProductToken');
		multimock1.setStaticResource(calloutPath1,'ProductToken');
		multimock1.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?&$count=true&$top=1','ProductServiceableVersionItemsCount');
		
		multimock1.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?&$skip=1000&$top=1000','ProductServiceableVersionItemsCount');
		multimock1.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?&$skip=2000&$top=1000','ProductServiceableVersionItemsCount');
		multimock1.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?&$skip=3000&$top=1000','ProductServiceableVersionItemsCount');
		multimock1.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?&$skip=4000&$top=1000','ProductServiceableVersionItemsCount');
		multimock1.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?&$skip=5000&$top=1000','ProductServiceableVersionItemsCount');
		multimock1.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?&$skip=6000&$top=1000','ProductServiceableVersionItemsCount');
		
		
		multimock1.setStaticResource(PSVUrl,'ProductServiceableVersionItems'); 
		
		multimock1.setStatusCode(200);
		multimock1.setHeader(HWS_Constants.Content, HWS_Constants.json);
		
		Test.startTest();
		
		//Prepare url list for the start method
		List<String> queryList1 = new List<String>();
		queryList1.add(PSVUrl); 
		
		//set mock callout mode
		Test.setMock(HttpCalloutMock.class, multimock1);
		
		HWS_ProductServiceableVersionItem_Batch batch1 = new HWS_ProductServiceableVersionItem_Batch();
		Database.BatchableContext bc1;
		SchedulableContext sc1;
		batch1.start(bc1);
		batch1.execute(sc1);
		batch1.execute(bc1,queryList1);	  
		batch1.finish(bc1);		 
		Test.StopTest();
		
	}
	@isTest 
	static void testproductServicableVersion5000() 
	{
		List<EDP_HWS_Settings__c> edpEntryList2 = new List<EDP_HWS_Settings__c>();
		//Create custom settings entries for test data
		EDP_HWS_Settings__c edpEntry2 = new EDP_HWS_Settings__c();
		edpEntry2.Name = 'ProductServiceableVersionItem';
		
		edpEntry2.Full_Load_Filter__c ='Yes';
		edpEntry2.ModifiedDate__c = Date.newInstance(2019,03,26);
		edpEntryList2.add(edpEntry2);
		insert edpEntryList2;
		HWS_Skipcount__c skipCountValue1 = HWS_Skipcount__c.getInstance('PSVI');
		skipCountValue1.Skip_Count__c = 5100;
		update skipCountValue1;
		//Setting callout mock for loading data from static resource		
		MultiStaticResourceCalloutMock multimock2 = new MultiStaticResourceCalloutMock();
		String calloutPath2 = HWS_Constants.EDP_Login;
		
		multimock2.setStaticResource(PSVUrl, 'ProductServiceableVersionItems');
		multimock2.setStaticResource(TokenPathUrl,'ProductToken');
		multimock2.setStaticResource(calloutPath2,'ProductToken');
		multimock2.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableVersionItems?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$count=true&$top=1','ProductServiceableVersionItemsCount');
		
		
		multimock2.setStaticResource(PSVUrl,'ProductServiceableVersionItems'); 
		
		multimock2.setStatusCode(200);
		multimock2.setHeader(HWS_Constants.Content, HWS_Constants.json);
		
		Test.startTest();
		
		//Prepare url list for the start method
		List<String> queryList2 = new List<String>();
		queryList2.add(PSVUrl); 
		
		//set mock callout mode
		Test.setMock(HttpCalloutMock.class, multimock2);
		
		HWS_ProductServiceableVersionItem_Batch batch2 = new HWS_ProductServiceableVersionItem_Batch();
		Database.BatchableContext bc2;
		SchedulableContext sc2;
		batch2.start(bc2);
		batch2.execute(sc2);
		batch2.execute(bc2,queryList2);	  
		batch2.finish(bc2);   
		Test.StopTest();
	}
	
	@isTest 
	static void testproductServicableSales() 
	{
		//Setting callout mock for loading data from static resource		
		MultiStaticResourceCalloutMock multimock3 = new MultiStaticResourceCalloutMock();
		String calloutPath3 = HWS_Constants.EDP_Login;
		multimock3.setStaticResource(PSSUrl, 'ProductServiceableSalesItems');
		multimock3.setStaticResource(TokenPathUrl,'ProductToken');
		multimock3.setStaticResource(calloutPath3,'ProductToken');
		multimock3.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems?&$count=true&$top=1', 'ProductServiceableSalesItemsCount');
		multimock3.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems?&$skip=1000&$top=1000', 'ProductServiceableSalesItemsCount');
		multimock3.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems?&$skip=2000&$top=1000', 'ProductServiceableSalesItemsCount');
		multimock3.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems?&$skip=3000&$top=1000', 'ProductServiceableSalesItemsCount');
		multimock3.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems?&$skip=4000&$top=1000', 'ProductServiceableSalesItemsCount');
		multimock3.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems?&$skip=5000&$top=1000', 'ProductServiceableSalesItemsCount');
		multimock3.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems?&$skip=6000&$top=1000', 'ProductServiceableSalesItemsCount');
		multimock3.setStaticResource(PSSUrl,'ProductServiceableSalesItems'); 
		multimock3.setStatusCode(200);
		multimock3.setHeader(HWS_Constants.Content, HWS_Constants.json);
		Test.startTest();
		//Prepare url list for the start method
		List<String> queryList3 = new List<String>();
		queryList3.add(PSSUrl); 
		//set mock callout mode
		Test.setMock(HttpCalloutMock.class, multimock3);
		
		HWS_ProductServiceableSalesItem_Batch batch3=new HWS_ProductServiceableSalesItem_Batch();
		
		Database.BatchableContext bc3;
		
		
		batch3.start(bc3);
		batch3.execute(bc3,queryList3);  
		batch3.finish(bc3);
		
		Test.StopTest();
		
	}   
	@isTest 
	static void testproductServicableSales5001() 
	{
		List<EDP_HWS_Settings__c> edpEntryList4 = new List<EDP_HWS_Settings__c>();
		//Create custom settings entries for test data
		EDP_HWS_Settings__c edpEntry4 = new EDP_HWS_Settings__c();
		edpEntry4.Name = 'ProductServiceableSalesItem';
		edpEntry4.Full_Load_Filter__c ='Yes';
		edpEntry4.ModifiedDate__c = Date.newInstance(2019,03,26);
		edpEntryList4.add(edpEntry4);
		insert edpEntryList4;
	   
		HWS_Skipcount__c skipCountValue4 = HWS_Skipcount__c.getInstance('PSSI');
		skipCountValue4.Skip_Count__c = 5100;
		update skipCountValue4;
		//Setting callout mock for loading data from static resource		
		MultiStaticResourceCalloutMock multimock4 = new MultiStaticResourceCalloutMock();
		String calloutPath4 = HWS_Constants.EDP_Login;
		multimock4.setStaticResource(PSSUrl, 'ProductServiceableSalesItems');
		multimock4.setStaticResource(TokenPathUrl,'ProductToken');
		multimock4.setStaticResource(calloutPath4,'ProductToken');
		multimock4.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableSalesItems?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$count=true&$top=1','ProductServiceableSalesItemsCount');
		multimock4.setStaticResource(PSSUrl,'ProductServiceableSalesItems'); 
		multimock4.setStatusCode(200);
		multimock4.setHeader(HWS_Constants.Content, HWS_Constants.json);
		Test.startTest();
		//Prepare url list for the start method
		List<String> queryList4 = new List<String>();
		queryList4.add(PSSUrl); 
		//set mock callout mode
		Test.setMock(HttpCalloutMock.class, multimock4);
		HWS_ProductServiceableSalesItem_Batch batch4 = new HWS_ProductServiceableSalesItem_Batch();
		Database.BatchableContext bc4;
		
		batch4.start(bc4);
		
		batch4.execute(bc4,queryList4);	  
		Test.StopTest();
		
	}   
	
	@isTest 
	static void testproductServicableAlternateVersion() 
	{
		List<EDP_HWS_Settings__c> edpEntryList15 = new List<EDP_HWS_Settings__c>();
		EDP_HWS_Settings__c edpEntry5 = new EDP_HWS_Settings__c();
		edpEntry5.Name = 'ProductServiceableAltCode';
		edpEntry5.Full_Load_Filter__c ='Yes';
		edpEntry5.ModifiedDate__c = Date.newInstance(2019,03,26);
		edpEntryList15.add(edpEntry5);
		insert edpEntryList15;
		
		//Setting callout mock for loading data from static resource		
		MultiStaticResourceCalloutMock multimock5 = new MultiStaticResourceCalloutMock();
		String calloutPath5 = HWS_Constants.EDP_Login;
		
		multimock5.setStaticResource(PSAUrl, 'ProductServiceableAltCode');
		multimock5.setStaticResource(TokenPathUrl,'ProductToken');
		multimock5.setStaticResource(calloutPath5,'ProductToken');
		multimock5.setStaticResource('https://edpqaapi.azurewebsites.net/api/Productserviceablealernatecodes?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$count=true&$top=1','ProductServiceableAltCodeCount');
		
		multimock5.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableAlternateCode?&$count=true&$top=1','ProductServiceableAltCodeCount');
		
		multimock5.setStaticResource('https://edpqaapi.azurewebsites.net/api/Productserviceablealernatecodes?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=1000&$top=1000','ProductServiceableAltCodeCount');
		multimock5.setStaticResource('https://edpqaapi.azurewebsites.net/api/Productserviceablealernatecodes?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=2000&$top=1000','ProductServiceableAltCodeCount');
		multimock5.setStaticResource('https://edpqaapi.azurewebsites.net/api/Productserviceablealernatecodes?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=3000&$top=1000','ProductServiceableAltCodeCount');
		multimock5.setStaticResource('https://edpqaapi.azurewebsites.net/api/Productserviceablealernatecodes?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=4000&$top=1000','ProductServiceableAltCodeCount');
		multimock5.setStaticResource('https://edpqaapi.azurewebsites.net/api/Productserviceablealernatecodes?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=5000&$top=1000','ProductServiceableAltCodeCount');
		multimock5.setStaticResource('https://edpqaapi.azurewebsites.net/api/Productserviceablealernatecodes?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=6000&$top=1000','ProductServiceableAltCodeCount');
		
		
		multimock5.setStaticResource(PSAUrl,'ProductServiceableAltCode'); 
		
		multimock5.setStatusCode(200);
		multimock5.setHeader(HWS_Constants.Content, HWS_Constants.json);
		
		Test.startTest();
		
		//Prepare url list for the start method
		List<String> queryList5 = new List<String>();
		queryList5.add(PSAUrl); 
		
		//set mock callout mode
		Test.setMock(HttpCalloutMock.class, multimock5);
		
		HWS_ProductServiceableAltCode_Batch batch5 = new HWS_ProductServiceableAltCode_Batch();
		Database.BatchableContext bc5;
		
		batch5.start(bc5);
		
		batch5.execute(bc5,queryList5);	  
		batch5.finish(bc5);
		Test.StopTest();
		
		
	}
	
	@isTest 
	static void testproductServicableAltcode5000() 
	{
		
		List<EDP_HWS_Settings__c> edpEntryList16 = new List<EDP_HWS_Settings__c>();
		//Create custom settings entries for test data
		EDP_HWS_Settings__c edpEntry6 = new EDP_HWS_Settings__c();
		edpEntry6.Name = 'ProductServiceableAltCode';
		edpEntry6.Full_Load_Filter__c ='Yes';
		edpEntry6.ModifiedDate__c = Date.newInstance(2019,03,26);
		edpEntryList16.add(edpEntry6);
		insert edpEntryList16;
		
		HWS_Skipcount__c skipCountValue6 = HWS_Skipcount__c.getInstance('PSAC');
		skipCountValue6.Skip_Count__c = 5100;
		update skipCountValue6;
		//Setting callout mock for loading data from static resource		
		MultiStaticResourceCalloutMock multimock6 = new MultiStaticResourceCalloutMock();
		String calloutPath6 = HWS_Constants.EDP_Login;
		
		multimock6.setStaticResource(PSAUrl, 'ProductServiceableAltCode');
		multimock6.setStaticResource(TokenPathUrl,'ProductToken');
		multimock6.setStaticResource(calloutPath6,'ProductToken');
		multimock6.setStaticResource('https://edpqaapi.azurewebsites.net/api/Productserviceablealernatecodes?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$count=true&$top=1','ProductServiceableAltCodeCount');
		
		multimock6.setStaticResource(PSAUrl,'ProductServiceableAltCode'); 
		
		multimock6.setStatusCode(200);
		multimock6.setHeader(HWS_Constants.Content, HWS_Constants.json);
		
		Test.startTest();
		
		//Prepare url list for the start method
		List<String> queryList6 = new List<String>();
		queryList6.add(PSAUrl); 
		
		//set mock callout mode
		Test.setMock(HttpCalloutMock.class, multimock6);
		
		HWS_ProductServiceableAltCode_Batch batch6 = new HWS_ProductServiceableAltCode_Batch();
		Database.BatchableContext bc6;
		
		batch6.start(bc6);
		
		batch6.execute(bc6,queryList6);	  
		batch6.finish(bc6);   
		Test.StopTest();
		
	}   
	
	
	@isTest
	static void testrescheduleMethod(){
		HWS_Utility_Batch hwsbatch=new HWS_Utility_Batch();
		hwsbatch.rescheduleMethod('test','ProductVersionItemBatch');
		HWS_Utility_Batch hwsbatch1=new HWS_Utility_Batch();
		hwsbatch1.rescheduleMethod('test1','ProductServiceableVersionItemBatch');
		HWS_Utility_Batch hwsbatch2=new HWS_Utility_Batch();
		hwsbatch2.rescheduleMethod('test2','ProductServiceableSalesItemBatch');
		HWS_Utility_Batch hwsbatch3=new HWS_Utility_Batch();
		hwsbatch3.rescheduleMethod('test3','ProductRelationBatch');
		HWS_Utility_Batch hwsbatch4=new HWS_Utility_Batch();
		hwsbatch4.rescheduleMethod('test4','ProductServiceableAltCodeBatch');
		HWS_Utility_Batch hwsbatch5=new HWS_Utility_Batch();
		hwsbatch5.rescheduleMethod('test5','PMDSORComponentToProductBatch');
	}
	
	@isTest 
	static void testcustsetting(){
		
		HWS_Utility_Batch bat=new HWS_Utility_Batch();
		bat.clearcustomsetting('ProductRelation');
		
	}
	
	
	
	@isTest 
	static void testproductServicableRelation() 
	{
		//Setting callout mock for loading data from static resource		
		MultiStaticResourceCalloutMock multimock7 = new MultiStaticResourceCalloutMock();
		String ciPath7 = PSRUrl;
		String calloutPath7 = HWS_Constants.EDP_Login;
		
		multimock7.setStaticResource(ciPath7, 'ProductServiceableRelations');
		multimock7.setStaticResource(TokenPathUrl,'ProductToken');
		multimock7.setStaticResource(calloutPath7,'ProductToken');
		multimock7.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations?&$count=true&$top=1','ProductServiceableRelationsCount');

		multimock7.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations?&$skip=1000&$top=1000','ProductServiceableRelationsCount');
		multimock7.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations?&$skip=2000&$top=1000','ProductServiceableRelationsCount');
		multimock7.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations?&$skip=3000&$top=1000','ProductServiceableRelationsCount');
		multimock7.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations?&$skip=4000&$top=1000','ProductServiceableRelationsCount');
		multimock7.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations?&$skip=5000&$top=1000','ProductServiceableRelationsCount');
		multimock7.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations?&$skip=6000&$top=1000','ProductServiceableRelationsCount');
		
		
		multimock7.setStaticResource(PSRUrl,'ProductServiceableRelations'); 
		
		multimock7.setStatusCode(200);
		multimock7.setHeader(HWS_Constants.Content, HWS_Constants.json);
		
		Test.startTest();
		
		//Prepare url list for the start method
		List<String> queryList7 = new List<String>();
		queryList7.add(PSRUrl); 
		
		//set mock callout mode
		Test.setMock(HttpCalloutMock.class, multimock7);
		
		HWS_Product_Relationship_Batch batch7 = new HWS_Product_Relationship_Batch();
		Database.BatchableContext bc7;
		SchedulableContext sc7;
		batch7.start(bc7);
		batch7.execute(sc7);
		batch7.execute(bc7,queryList7);	  
		batch7.finish(bc7);
		Test.StopTest();
		
		
	}   
	
	
	
	@isTest 
	static void testproductServicableRelationship5000() 
	{
		List<EDP_HWS_Settings__c> edpEntryList8 = new List<EDP_HWS_Settings__c>();
		//Create custom settings entries for test data
		EDP_HWS_Settings__c edpEntry8 = new EDP_HWS_Settings__c();
		edpEntry8.Name = 'ProductRelation';
		
		edpEntry8.Full_Load_Filter__c ='Yes';
		edpEntry8.ModifiedDate__c = Date.newInstance(2019,03,26);
		edpEntryList8.add(edpEntry8);
		insert edpEntryList8;
		HWS_Skipcount__c skipCountValue8 = HWS_Skipcount__c.getInstance('PSR');
		skipCountValue8.Skip_Count__c = 5100;
		update skipCountValue8;
		//Setting callout mock for loading data from static resource		
		MultiStaticResourceCalloutMock multimock8 = new MultiStaticResourceCalloutMock();
		String calloutPath8 = HWS_Constants.EDP_Login;
		
		multimock8.setStaticResource(PSRUrl, 'ProductServiceableRelations');
		multimock8.setStaticResource(TokenPathUrl,'ProductToken');
		multimock8.setStaticResource(calloutPath8,'ProductToken');
		multimock8.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductServiceableRelations?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$count=true&$top=1','ProductServiceableRelationsCount');
		
		
		multimock8.setStaticResource(PSRUrl,'ProductServiceableRelations'); 
		
		multimock8.setStatusCode(200);
		multimock8.setHeader(HWS_Constants.Content, HWS_Constants.json);
		
		Test.startTest();
		
		//Prepare url list for the start method
		List<String> queryList8 = new List<String>();
		queryList8.add(PSRUrl); 
		
		//set mock callout mode
		Test.setMock(HttpCalloutMock.class, multimock8);
		
		HWS_Product_Relationship_Batch batch8 = new HWS_Product_Relationship_Batch();
		Database.BatchableContext bc8;
		SchedulableContext sc8;
		batch8.start(bc8);
		batch8.execute(sc8);
		batch8.execute(bc8,queryList8);	  
		batch8.finish(bc8);   
		Test.StopTest();
		
	}
	
	
	@isTest 
	static void testproductVersionItem() 
	{
		List<EDP_HWS_Settings__c> edpEntryList9 = new List<EDP_HWS_Settings__c>();
		//Create custom settings entries for test data
		EDP_HWS_Settings__c edpEntry9 = new EDP_HWS_Settings__c();
		edpEntry9.Name = 'ProductVersionItem';

		edpEntry9.Full_Load_Filter__c ='Yes';
		edpEntry9.ModifiedDate__c = Date.newInstance(2019,03,26);
		edpEntryList9.add(edpEntry9);
		insert edpEntryList9;
		//Setting callout mock for loading data from static resource		
		MultiStaticResourceCalloutMock multimock9 = new MultiStaticResourceCalloutMock();
		String calloutPath9 = HWS_Constants.EDP_Login;
		
		multimock9.setStaticResource(PVUrl, 'ProductVersionItem');
		multimock9.setStaticResource(TokenPathUrl,'ProductToken');
		multimock9.setStaticResource(calloutPath9,'ProductToken');
		multimock9.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductVersionItems?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$count=true&$top=1','ProductVersionItemCount');
		multimock9.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductVersionItems?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=1000&$top=1000','ProductVersionItemCount');
		multimock9.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductVersionItems?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=2000&$top=1000','ProductVersionItemCount');
		multimock9.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductVersionItems?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=3000&$top=1000','ProductVersionItemCount');
		multimock9.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductVersionItems?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=4000&$top=1000','ProductVersionItemCount');
		multimock9.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductVersionItems?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=5000&$top=1000','ProductVersionItemCount');
		multimock9.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductVersionItems?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$skip=6000&$top=1000','ProductVersionItemCount');
		
		
		multimock9.setStaticResource(PVUrl,'ProductVersionItem'); 
		
		multimock9.setStatusCode(200);
		multimock9.setHeader(HWS_Constants.Content, HWS_Constants.json);
		
		Test.startTest();
		
		//Prepare url list for the start method
		List<String> queryList9 = new List<String>();
		queryList9.add(PVUrl); 
		
		//set mock callout mode
		Test.setMock(HttpCalloutMock.class, multimock9);
		
		HWS_ProductVersionItem_Batch batch9 = new HWS_ProductVersionItem_Batch();
		Database.BatchableContext bc9;
		SchedulableContext sc9;
		batch9.start(bc9);
		batch9.execute(sc9);
		batch9.execute(bc9,queryList9);	  
		batch9.finish(bc9);
		Test.StopTest();
		
	}
	
	@isTest 
	static void testproductVersionItemstatus() 
	{
		List<EDP_HWS_Settings__c> edpEntryList0 = new List<EDP_HWS_Settings__c>();
		//Create custom settings entries for test data
		EDP_HWS_Settings__c edpEntry0 = new EDP_HWS_Settings__c();
		edpEntry0.Name = 'ProductVersionItem';
		
		edpEntry0.Full_Load_Filter__c ='Yes';
		edpEntry0.ModifiedDate__c = Date.newInstance(2019,03,26);
		edpEntryList0.add(edpEntry0);
		insert edpEntryList0;
		HWS_Skipcount__c skipCountValue0 = HWS_Skipcount__c.getInstance('PVI');
		skipCountValue0.Skip_Count__c = 5100;
		update skipCountValue0;
		//Setting callout mock for loading data from static resource		
		MultiStaticResourceCalloutMock multimock0 = new MultiStaticResourceCalloutMock();
		String calloutPath0 = HWS_Constants.EDP_Login;
		
		multimock0.setStaticResource(PVUrl, 'ProductVersionItem');
		multimock0.setStaticResource(TokenPathUrl,'ProductToken');
		multimock0.setStaticResource(calloutPath0,'ProductToken');
		multimock0.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductVersionItems?$filter=EDP_LastModifiedDate%20gt%202019-03-26T05:30:00Z&$count=true&$top=1','ProductVersionItemCount');
		
		multimock0.setStaticResource(PVUrl,'ProductVersionItem'); 
		
		multimock0.setStatusCode(200);
		multimock0.setHeader(HWS_Constants.Content, HWS_Constants.json);
		
		Test.startTest();
		
		//Prepare url list for the start method
		List<String> queryList0 = new List<String>();
		queryList0.add(PVUrl); 
		
		//set mock callout mode
		Test.setMock(HttpCalloutMock.class, multimock0);
		 
		HWS_ProductVersionItem_Batch batch0 = new HWS_ProductVersionItem_Batch();
		Database.BatchableContext bc0;
		SchedulableContext sc0;
		batch0.start(bc0);
		batch0.execute(sc0);
		batch0.execute(bc0,queryList0);	  
		batch0.finish(bc0);   
		Test.StopTest();
		
	}

	@isTest
	static void testcreateInterfaceLogs(){
		HWS_Utility_Batch.createInterfaceLogs('test Data', 'test', 'test', 'this is a test msg', '', '',null);
	}
	
	
	
  
}