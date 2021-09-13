/****************************************
* Class Name : Batch_EDPSupplierDataLoadToStagingTest
* Created Date: 22-06-2019
* Created By : Raj Dubey
* Last Modified by:  
* Last Modified Date: 
* Description : Test classs for Batch_EDPSupplierDataLoadToStaging
*****************************************/
@isTest
public class Batch_EDPSupplierDataLoadToStagingTest 
{  
	@testSetup
	static void createTestData()
	{
		

		 List<EDP_URLs__c> edpEntryList = new List<EDP_URLs__c>();
		EDP_URLs__c edpURL1 = new EDP_URLs__c();
		edpURL1.isActive__c=true;
		edpURL1.name = 'resource';
		edpURL1.URL__c = 'https://edpqaapi.azurewebsites.net';
		edpEntryList.add(edpURL1);
		
		insert edpEntryList;	 
		List <Supplier_Staging__c> supplierList = new List <Supplier_Staging__c>();
		
		
	}
	
	
	
	@isTest
	static void testSuppliers()
	{
		List<EDP_URLs__c> edpEntryList = new List<EDP_URLs__c>();
		
		//Create custom settings entries for test data
		EDP_URLs__c edpEntry = new EDP_URLs__c();
		edpEntry.Full_Load__c = true;
		edpEntry.isActive__c=true;
		edpEntry.Name = 'SUPPLIERS';
		edpEntry.URL__c = 'https://edpqaapi.azurewebsites.net/api/Suppliers';		
		edpEntryList.add(edpEntry);
		insert edpEntryList;
		Test.startTest();
		
		//Setting callout mock for loading data from static resource		
		MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		
		String supplierCountURL = 'https://edpqaapi.azurewebsites.net/api/Suppliers?&$top=1&$count=true';
		String CIpath = 'https://edpqaapi.azurewebsites.net/api/Suppliers';
		String calloutPath = 'callout:EDP_Login';
		String path1 = 'https://edpqaapi.azurewebsites.net/api/Suppliers?&$orderby=Supplier_ID&$top=1200';

		multimock.setStaticResource(path1,'Suppliers');
		multimock.setStaticResource(supplierCountURL,'Suppliercount'); 
		multimock.setStaticResource(CIpath, 'Suppliers');
		multimock.setStaticResource(calloutPath,'SupplierToken');
		multimock.setStatusCode(200);
		multimock.setHeader('Content-Type', 'application/json');	  
		//set mock callout mode
		Test.setMock(HttpCalloutMock.class, multimock);
		
		Batch_EDPSupplierDataLoadToStaging batch = new Batch_EDPSupplierDataLoadToStaging();
		Database.executeBatch(batch, 1200) ;
	 
		Test.StopTest();
		
	}
	
   @isTest
	static void testScheduleMethod()
	{
		
		Test.startTest();
		Batch_EDPSupplierDataLoadToStaging sh1 = new Batch_EDPSupplierDataLoadToStaging();
		String sch = '0 0 2 * * ?'; 
		system.schedule('Test Schedule', sch, sh1); 
		Test.stopTest();
	}

	@isTest
	static void testCreateErrorLogs()
	{
		
		Batch_EDPSupplierDataLoadToStaging batch = new Batch_EDPSupplierDataLoadToStaging();
		batch.unschedule();
		batch.scheduleJob();
		batch.getCountofRecords('https://edpqaapi.azurewebsites.net/test', 'SuppliersTest');
		Batch_EDPSupplierDataLoadToStaging.getResponse('https://edpqaapi.azurewebsites.net/test', 'SuppliersTest');
		batch.CreateErrorLogs('Failure',400,'Callout Failed','https://Suppliers');
	}
	
	
		@isTest
 static void testSuppliersNegative()
	{
		List<EDP_URLs__c> edpEntryList = new List<EDP_URLs__c>();
		
		//Create custom settings entries for test data
		EDP_URLs__c edpEntry = new EDP_URLs__c();
		edpEntry.Full_Load__c = false;
		edpEntry.isActive__c=true;
		edpEntry.Full_Load_Filter__c = 'CompanyLifecycleStatus=\'Active\'';
		edpEntry.Maximum_Timestamp__c =  DateTime.valueOf('2019-06-25 16:13:22');
		edpEntry.Name = 'SUPPLIERS';
		edpEntry.URL__c = 'https://edpqaapi.azurewebsites.net/api/Suppliers';		
		edpEntryList.add(edpEntry);
		insert edpEntryList;
		Test.startTest();
		
		//Setting callout mock for loading data from static resource		
		MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		
		String supplierCountURL = 'https://edpqaapi.azurewebsites.net/api/Suppliers?&$top=1&$count=false';
		String CIpath = 'https://edpqaapi.azurewebsites.net/api/Suppliers';
		String calloutPath = 'callout:EDP_Login';
		String path1 = 'https://edpqaapi.azurewebsites.net/api/Suppliers?&$orderby=Supplier_ID&$top=1200';
		String filterPath = 'https://edpqaapi.azurewebsites.net/api/Suppliers?$filter=CompanyLifecycleStatus%20eq%20\'Active\'%20and%20EDP_LastModifiedDate%20gt%202019-06-25T16%3A13%3A22Z&$top=1&$count=true';

		multimock.setStaticResource(path1,'Suppliers');
		multimock.setStaticResource(filterPath,'Suppliers');
		multimock.setStaticResource(supplierCountURL,'Suppliercount'); 
		multimock.setStaticResource(CIpath, 'Suppliers');
		multimock.setStaticResource(calloutPath,'SupplierToken');
		multimock.setStatusCode(400);
		multimock.setHeader('Content-Type', 'application/json');	  
		//set mock callout mode
		Test.setMock(HttpCalloutMock.class, multimock);
		
		Batch_EDPSupplierDataLoadToStaging batch = new Batch_EDPSupplierDataLoadToStaging();
		Database.executeBatch(batch, 1200) ;
	 
		Test.StopTest();
		
	}
	
	
}