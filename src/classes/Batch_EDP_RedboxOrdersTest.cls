/****************************************
 * Class Name : class Batch_EDP_RedboxOrdersTest
 * Created Date: 1 August 2018
 * Created By : Accenture
 * Last Modified by: 
 * Last Modified Date: 
 * Description : Test class for loading data to dataset from EDP RedBox Orders
*****************************************/


@isTest
public class Batch_EDP_RedboxOrdersTest {
   @isTest
	static void test()
	{
		User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
		System.runAs(thisUser){
		RedboxSettings__c red=new RedboxSettings__c();
		red.Name='ValueRedBoxOrders';
		red.StartPeriod__c='01.2017';
		red.CustomFilter__c='EDB_RBID=1198';
		insert red;
		RB_Folder_Names__c fol=new RB_Folder_Names__c();
		fol.Name='Developer';
		fol.Folder__c='Developer';
		insert fol;
		RB_Names__c name=new RB_Names__c();
		name.Name='RB_Orders';
		name.Value__c='Redbox_Orders';
		insert name;
		RB_URLs__c url=new RB_URLs__c();
		url.Name='RedBoxOrders';
		url.URL__c='https://edpqaapi.azurewebsites.net/api/RedboxOrders';
		insert url;
		EDP_URLs__c edpURL = new EDP_URLs__c();
		edpURL.name = 'resource';
		edpURL.URL__c = 'https://edpqaapi.azurewebsites.net';
		insert edpURL;
		
		
		
		
		List<String> QueryList = new List<String>();
		QueryList.add('https://edpqaapi.azurewebsites.net/api/RedboxOrders?$filter=RBPeriodID%20eq%20\'P01\'%20and%20RBYearID%20eq%20\'Y2017\'%20and%20EDP_RBID%20eq%201198');
		
		
		
		
	   MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
	   String redpath='https://edpqaapi.azurewebsites.net/api/RedboxOrders';
	   String tokenpath='https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token'; 
	   String calloutpath='callout:EDP_RB_Login';
	   
	   multimock.setStaticResource(redpath,'RedboxOrdersTest');
	   multimock.setStaticResource(tokenpath,'ProductToken');
	   multimock.setStaticResource(calloutpath,'ProductToken'); 
	   multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/RedboxOrders?$count=true&$skip=3500','RedboxOrdersTest');
	 
	   
	   String url1='https://edpqaapi.azurewebsites.net/api/RedboxOrders?$filter=RBPeriodID%20eq%20\'P01\'%20and%20RBYearID%20eq%20\'Y2017\'%20and%20EDP_RBID%20eq%201198';
	   String url2='https://edpqaapi.azurewebsites.net/api/RedboxOrders?$filter=RBPeriodID%20eq%20\'P01\'%20and%20RBYearID%20eq%20\'Y2017\'%20and%20EDP_RBID%20eq%201198&$count=true&$top=1'; 
	
	   multimock.setStaticResource(url1,'RedboxOrdersTest');
	   multimock.setStaticResource(url2,'RedboxFilterTest');
	   
	   multimock.setStatusCode(200);
	   multimock.setHeader('Content-Type', 'application/json'); 
		
	   Test.startTest();
	   
		
	   
	   Test.setMock(HttpCalloutMock.class, multimock);
		
	   Batch_EDP_RedboxOrders batch=new Batch_EDP_RedboxOrders();
	   Database.BatchableContext BC;
	   batch.start(BC);
	   batch.execute(BC,QueryList);
	   batch.finish(BC); 


	  
	   Test.stopTest(); 
	  }	  
	}
	
	@isTest
	static void test1(){
		
		
		 RedboxSettings__c red=new RedboxSettings__c();
		red.Name='ValueRedBoxOrders';
		red.StartPeriod__c='01.2017';
		red.CustomFilter__c='';
		insert red;
		RB_Folder_Names__c fol=new RB_Folder_Names__c();
		fol.Name='Developer';
		fol.Folder__c='Developer';
		insert fol;
		RB_Names__c name=new RB_Names__c();
		name.Name='RB_Orders';
		name.Value__c='Redbox_Orders';
		insert name;
		RB_URLs__c url=new RB_URLs__c();
		url.Name='RedBoxOrders';
		url.URL__c='https://edpqaapi.azurewebsites.net/api/RedboxOrders';
		insert url;
		EDP_URLs__c edpURL = new EDP_URLs__c();
		edpURL.name = 'resource';
		edpURL.URL__c = 'https://edpqaapi.azurewebsites.net';
		insert edpURL;
		
		//Test.startTest();
		EDP_URLs__c edpURL1 =EDP_URLs__c.getInstance('resource');
		edpURL1.URL__c= 'https://edpqaapi.azurewebsites.net.get';
		List<String> QueryList = new List<String>();
	  QueryList.add('https://edpqaapi.azurewebsites.net/api/RedboxOrders'); 
		
		//Setting callout mock for loading data from static resource		
		 MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		
		String Redboxpath = 'https://edpqaapi.azurewebsites.net/api/RedboxOrders';
		multimock.setStaticResource(Redboxpath, 'RedboxOrdersTest');
		multimock.setStatusCode(200);
		multimock.setStatus('Success');
		 multimock.setHeader('Content-Type', 'application/json');
		 String urls = 'https://edpqaapi.azurewebsites.net/api/RedboxOrders?$count=true&$top=1';
		 String url1='https://edpqaapi.azurewebsites.net/api/RedboxOrders?$filter=RBPeriodID%20eq%20\'P01\'%20and%20RBYearID%20eq%20\'Y2017\'';
		 String url2='https://edpqaapi.azurewebsites.net/api/RedboxOrders?$filter=RBPeriodID%20eq%20\'P01\'%20and%20RBYearID%20eq%20\'Y2017\'&$count=true&$top=1'; 
	   
	   multimock.setStaticResource(url1,'RedboxOrdersTest');
	   multimock.setStaticResource(url2,'RedboxFilterTest');
		 multimock.setStaticResource(urls,'RedboxFilterTest'); 
	  
		 String calloutPath = 'callout:EDP_RB_Login';
		 multimock.setStaticResource(calloutPath,'ProductToken');
		
		 //set mock callout mode
		 Test.startTest();
		 Test.setMock(HttpCalloutMock.class, multimock);
		
		
		 
		
		
		Batch_EDP_RedboxOrders batch = new Batch_EDP_RedboxOrders();
		
		batch.getToken();
		update edpURL1;
		batch.getCountofRecords(Redboxpath);
		Database.BatchableContext BC;
		
		
		Test.stopTest();
		
	}
	
	 @isTest
	static void testCreateErrorLogs()
	{
		 RedboxSettings__c red=new RedboxSettings__c();
		red.Name='ValueRedBoxOrders';
		red.StartPeriod__c='01.2017';
		red.CustomFilter__c='EDB_RBID=1198';
		insert red;
		RB_Folder_Names__c fol=new RB_Folder_Names__c();
		fol.Name='Developer';
		fol.Folder__c='Developer';
		insert fol;
		RB_Names__c name=new RB_Names__c();
		name.Name='RB_Orders';
		name.Value__c='Redbox_Orders';
		insert name;
		RB_URLs__c url=new RB_URLs__c();
		url.Name='RedBoxOrders';
		url.URL__c='https://edpqaapi.azurewebsites.net/api/RedboxOrders';
		insert url;
		EDP_URLs__c edpURL = new EDP_URLs__c();
		edpURL.name = 'resource';
		edpURL.URL__c = 'https://edpqaapi.azurewebsites.net';
		insert edpURL;
		Batch_EDP_RedboxOrders batch = new Batch_EDP_RedboxOrders();
		batch.CreateErrorLogs('Failure',400,'Rest Callout Failed','https://Redbox');
	   
		
	}
}