/****************************************
 * Class Name : class Batch_EDP_RedBoxProductDimensionTest
 * Created Date: 1 August 2018
 * Created By : Accenture
 * Last Modified by: 
 * Last Modified Date: 
 * Description : Test class for loading data to dataset from EDP RedBoxProductDimension
*****************************************/


@isTest
public class Batch_EDP_RedBoxProductDimensionTest {
  @isTest
	static void test()
	{
		User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
		System.runAs(thisUser){
		RB_Folder_Names__c fol=new RB_Folder_Names__c();
		fol.Name='Developer';
		fol.Folder__c='Developer';
		insert fol;
		RB_Names__c name=new RB_Names__c();
		name.Name='RB_Products';
		name.Value__c='Redbox_Products';
		insert name;
		RB_URLs__c url=new RB_URLs__c();
		url.Name='RedBoxProductDimension';
		url.URL__c='https://edpqaapi.azurewebsites.net/api/RedboxProductDimension';
		insert url;
		EDP_URLs__c edpURL = new EDP_URLs__c();
		edpURL.name = 'resource';
		edpURL.URL__c = 'https://edpqaapi.azurewebsites.net';
		insert edpURL;
		
		
		
		
		List<String> QueryList = new List<String>();
		QueryList.add('https://edpqaapi.azurewebsites.net/api/RedboxProductDimension');
		
		
		
		
	   MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
	   String redpath='https://edpqaapi.azurewebsites.net/api/RedboxProductDimension';
	   String tokenpath='https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token'; 
	   String calloutpath='callout:EDP_RB_Login';
	   
	   multimock.setStaticResource(redpath,'RedboxOrdersTest');
	   multimock.setStaticResource(tokenpath,'ProductToken');
	   multimock.setStaticResource(calloutpath,'ProductToken'); 
	   multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/RedboxProductDimension?$count=true&$skip=1000','RedboxOrdersTest');
	 
	   
	   String url1='https://edpqaapi.azurewebsites.net/api/RedboxProductDimension';
	   String url2='https://edpqaapi.azurewebsites.net/api/RedboxProductDimension?$count=true&$top=1'; 
	   
	   multimock.setStaticResource(url1,'RedboxOrdersTest');
	   multimock.setStaticResource(url2,'RedboxFilterTest');
	   
	   multimock.setStatusCode(200);
	   multimock.setHeader('Content-Type', 'application/json'); 
		
	   Test.startTest();
	   
		
	   
	   Test.setMock(HttpCalloutMock.class, multimock);
	   Batch_EDP_RedBoxProductDimension batch=new Batch_EDP_RedBoxProductDimension();
	   Database.BatchableContext BC;
	   batch.start(BC);
	   batch.execute(BC,QueryList);
	   batch.finish(BC); 
		
	   Test.stopTest(); 
	  }	  
	}
	
	 @isTest
	static void test1(){
		
		
		RB_Folder_Names__c fol=new RB_Folder_Names__c();
		fol.Name='Developer';
		fol.Folder__c='Developer';
		insert fol;
		RB_Names__c name=new RB_Names__c();
		name.Name='RB_Products';
		name.Value__c='Redbox_Products';
		insert name;
		RB_URLs__c url=new RB_URLs__c();
		url.Name='RedBoxProductDimension';
		url.URL__c='https://edpqaapi.azurewebsites.net/api/RedboxProductDimension';
		insert url;	
		EDP_URLs__c edpURL = new EDP_URLs__c();
		edpURL.name = 'resource';
		edpURL.URL__c = 'https://edpqaapi.azurewebsites.net';
		insert edpURL;
		
		Test.startTest();
		EDP_URLs__c edpURL1 =EDP_URLs__c.getInstance('resource');
		edpURL1.URL__c= 'https://edpqaapi.azurewebsites.net.get';
		
		//Setting callout mock for loading data from static resource		
		 MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		
		String Propath = 'https://edpqaapi.azurewebsites.net/api/RedboxProductDimension';
		multimock.setStaticResource(Propath, 'RedboxOrdersTest');
		multimock.setStatusCode(200);
		multimock.setStatus('Failure');
		 multimock.setHeader('Content-Type', 'application/json');
		 String urls = 'https://edpqaapi.azurewebsites.net/api/RedboxProductDimension?$count=true&$top=1';
		 multimock.setStaticResource(urls,'RedboxFilterTest'); 
	  
		 String calloutPath = 'callout:EDP_RB_Login';
		 multimock.setStaticResource(calloutPath,'ProductToken');
		
		 //set mock callout mode
		 Test.setMock(HttpCalloutMock.class, multimock);
		
		List<String> QueryList = new List<String>();
	  QueryList.add('https://edpqaapi.azurewebsites.net/api/RedboxProductDimension'); 
		 
		Batch_EDP_RedBoxProductDimension batch = new Batch_EDP_RedBoxProductDimension();
		
		batch.getToken();
		update edpURL1;
		batch.getCountofRecords(Propath);
		Database.BatchableContext BC;
		Test.stopTest();
		
	}
	
	 @isTest
	static void testCreateErrorLogs()
	{
		RB_Folder_Names__c fol=new RB_Folder_Names__c();
		fol.Name='Developer';
		fol.Folder__c='Developer';
		insert fol;
		RB_Names__c name=new RB_Names__c();
		name.Name='RB_Products';
		name.Value__c='Redbox_Products';
		insert name;
		RB_URLs__c url=new RB_URLs__c();
		url.Name='RedboxProductDimension';
		url.URL__c='https://edpqaapi.azurewebsites.net/api/RedboxProductDimension';
		insert url;
		EDP_URLs__c edpURL = new EDP_URLs__c();
		edpURL.name = 'resource';
		edpURL.URL__c = 'https://edpqaapi.azurewebsites.net';
		insert edpURL;
		Batch_EDP_RedBoxProductDimension batch = new Batch_EDP_RedBoxProductDimension();
		batch.CreateErrorLogs('Failure',400,'Rest Callout Failed','https://Redbox');
	}
}