@isTest
public class Batch_DesignElementTest {
	@isTest static void DesignElementMock2(){
	EDP_CH_Settings__c pcEntry =	 new EDP_CH_Settings__c ();
		pcEntry.Name='ProductDesignElements';
		pcEntry.Full_Load__c=true;  
	  //  pcEntry.Full_Load_Filter__c='NSNCode="P385915"'; 
		insert pcEntry;
	
		List<EDP_URLs__c> urlList = new List<EDP_URLs__c>();
		EDP_URLs__c edpentry=new EDP_URLs__c();
		edpentry.Name='resource';
		edpentry.URL__c='https://edpqaapi.azurewebsites.net';
		urlList.add(edpentry);  
		
		EDP_URLs__c entry= new EDP_URLs__c();
		entry.Name='PDEI';
		entry.URL__c='https://edpqaapi.azurewebsites.net/api/ProductDesignElementItems';
		urlList.add(entry);
		insert urlList;
		 
  
		List<String> Queries=new List<String>();
	
		 List<String> QueryList = new List<String>();
		 QueryList.add('https://edpqaapi.azurewebsites.net/api/ProductDesignElementItems?$orderby=NSNCode');
	Queries=QueryList; 
		 
		 MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
	multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductDesignElementItems?$orderby=NSNCode','ProductDesignElementItems');
	multimock.setStaticResource('https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token','ProductToken');
	multimock.setStaticResource('callout:EDP_Login','ProductToken');
	String url = 'https://edpqaapi.azurewebsites.net/api/ProductDesignElementItems?$orderby=NSNCode&$count=true&$top=1';
	multimock.setStaticResource(url,'ProductDesignElementItemsCount');
	multimock.setStatusCode(200);
	multimock.setHeader('Content-Type', 'application/json');
		 
		 
	
		 Test.startTest();  
		
		Test.setMock(HttpCalloutMock.class, multimock);
		SchedulableContext SC = null;
		Batch_DesignElement tsc=new Batch_DesignElement();
		tsc.execute(SC);
		Batch_DesignElement batch= new Batch_DesignElement();
		Database.executebatch(batch,1);
		Database.BatchableContext BC;
		batch.finish(BC);
		batch.unscheduleMe();
		//batch.rescheduleMethod();
		Test.stopTest();

		
		 
}   

   @isTest static void DesignElementMock3(){
		
	EDP_CH_Settings__c pcEntry =	 new EDP_CH_Settings__c ();
		pcEntry.Name='ProductDesignElements';
		pcEntry.Full_Load__c=false;  
	// pcEntry.Full_Load_Filter__c='NSNCode="P23189"';
		//pcEntry.ModifiedDate__c=DateTime.valueOf('2018-06-25 16:13:22');
		insert pcEntry;
	
		List<EDP_URLs__c> urlList = new List<EDP_URLs__c>();
		EDP_URLs__c edpentry=new EDP_URLs__c();
		edpentry.Name='resource';
		edpentry.URL__c='https://edpqaapi.azurewebsites.net';
		urlList.add(edpentry);  
		
		EDP_URLs__c entry= new EDP_URLs__c();
		entry.Name='PDEI';
		entry.URL__c='https://edpqaapi.azurewebsites.net/api/ProductDesignElementItems';
		urlList.add(entry);
		insert urlList;
		 
 
		List<String> Queries=new List<String>();
	
	List<String> QueryList = new List<String>();
		 QueryList.add('https://edpqaapi.azurewebsites.net/api/ProductDesignElementItems?$orderby=NSNCode');
	Queries=QueryList;
		 
		 MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
	multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductDesignElementItems?$orderby=NSNCode','ProductDesignElementItems');
	multimock.setStaticResource('https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token','ProductToken');
	multimock.setStaticResource('callout:EDP_Login','ProductToken');
	String url = 'https://edpqaapi.azurewebsites.net/api/ProductDesignElementItems?$orderby=NSNCode&$count=true&$top=1';
	multimock.setStaticResource(url,'ProductDesignElementItemsCount');
	multimock.setStatusCode(400);
	multimock.setHeader('Content-Type', 'application/json');
		 
	
		 Test.startTest();
		
		Test.setMock(HttpCalloutMock.class, multimock);
		SchedulableContext SC = null;
		Batch_DesignElement tsc=new Batch_DesignElement();
		tsc.execute(SC);
		Batch_DesignElement batch= new Batch_DesignElement();
		Database.executebatch(batch,1);
		Database.BatchableContext BC;
		batch.finish(BC);
		batch.unscheduleMe();
		//batch.rescheduleMethod();
		Test.stopTest();

		
		 
}
	@isTest static void DesignElementMock4(){
		
	EDP_CH_Settings__c pcEntry =	 new EDP_CH_Settings__c ();
		pcEntry.Name='ProductDesignElements';
		pcEntry.Full_Load__c=false;  
		pcEntry.Full_Load_Filter__c='NSNCode="P23189"';
		//pcEntry.ModifiedDate__c=DateTime.valueOf('2018-06-25 16:13:22');
		insert pcEntry;
	
		List<EDP_URLs__c> urlList = new List<EDP_URLs__c>();
		EDP_URLs__c edpentry=new EDP_URLs__c();
		edpentry.Name='resource';
		edpentry.URL__c='https://edpqaapi.azurewebsites.net';
		urlList.add(edpentry);  
		
		EDP_URLs__c entry= new EDP_URLs__c();
		entry.Name='PDEI';
		entry.URL__c='https://edpqaapi.azurewebsites.net/api/ProductDesignElementItems';
		urlList.add(entry);
		insert urlList;
		 
  
		List<String> Queries=new List<String>();
	
		 List<String> QueryList = new List<String>();
		 QueryList.add('https://edpqaapi.azurewebsites.net/api/ProductDesignElementItems?$orderby=NSNCode');
	Queries=QueryList;
		 
		 MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
	multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductDesignElementItems?$orderby=NSNCode','ProductDesignElementItems');
	multimock.setStaticResource('https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token','ProductToken');
	multimock.setStaticResource('callout:EDP_Login','ProductToken');
	String url = 'https://edpqaapi.azurewebsites.net/api/ProductDesignElementItems?$orderby=NSNCode&$count=true&$top=1';
	multimock.setStaticResource(url,'ProductDesignElementItemsCount');
	multimock.setStatusCode(200);
	multimock.setHeader('Content-Type', 'application/json');
			
		 
	
		 Test.startTest();
		
		Test.setMock(HttpCalloutMock.class, multimock);
		SchedulableContext SC = null;
		Batch_DesignElement tsc=new Batch_DesignElement();
		tsc.execute(SC);
		Batch_DesignElement batch= new Batch_DesignElement();
		Database.executebatch(batch,1);
		Database.BatchableContext BC;
		batch.finish(BC);
		batch.unscheduleMe();
		//batch.rescheduleMethod();
		Test.stopTest();

		
		 
} 
	@isTest static void DesignElementMock1(){
		
		 EDP_CH_Settings__c pcEntry =   new EDP_CH_Settings__c ();
		pcEntry.Name='ProductDesignElements';
		pcEntry.Full_Load__c=true;  
	// pcEntry.Full_Load_Filter__c='NSNCode="P23189"';
		//pcEntry.ModifiedDate__c=DateTime.valueOf('2018-06-25 16:13:22');
		insert pcEntry;
	
		List<EDP_URLs__c> urlList = new List<EDP_URLs__c>();
		EDP_URLs__c edpentry=new EDP_URLs__c();
		edpentry.Name='resource';
		edpentry.URL__c='https://edpqaapi.azurewebsites.net';
		urlList.add(edpentry);  
		
		EDP_URLs__c entry= new EDP_URLs__c();
		entry.Name='PDEI';
		entry.URL__c='https://edpqaapi.azurewebsites.net/api/ProductDesignElementItems';
		urlList.add(entry);
		insert urlList;
		 
 
		List<String> Queries=new List<String>();
	
	List<String> QueryList = new List<String>();
		 QueryList.add('https://edpqaapi.azurewebsites.net/api/ProductDesignElementItems?$orderby=NSNCode');
	Queries=QueryList;
		 
		 MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
	multimock.setStaticResource('https://edpqaapi.azurewebsites.net/api/ProductDesignElementItems?$orderby=NSNCode','ProductDesignElementItems');
	multimock.setStaticResource('https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token','ProductToken');
	multimock.setStaticResource('callout:EDP_Login','ProductToken');
	String url = 'https://edpqaapi.azurewebsites.net/api/ProductDesignElementItems?$orderby=NSNCode&$count=true&$top=1';
	multimock.setStaticResource(url,'ProductDesignElementItemsCount');
	multimock.setStatusCode(200);
	multimock.setHeader('Content-Type', 'application/json');
		 
	
		 Test.startTest();
		
		Test.setMock(HttpCalloutMock.class, multimock);
		Batch_DesignElement tsc=new Batch_DesignElement();
		Database.BatchableContext BC;
		tsc.execute(BC,Queries);
		Batch_DesignElement batch= new Batch_DesignElement();
		
		Database.executebatch(batch,1);
		
		
		batch.finish(BC);
		batch.unscheduleMe();
		//batch.rescheduleMethod();
		Test.stopTest();

		

		 
}   
}