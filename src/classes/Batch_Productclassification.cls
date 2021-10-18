/****************************************
		 * Name		: Batch_Productclassification
		 * Description : Loads data to staging object
		 * Author	  : Accenture
*****************************************/ 



global class Batch_Productclassification implements Database.Batchable<String>,Database.AllowsCallouts,Database.Stateful,Schedulable {
	public String token;
	public static integer count;
	public String url='';
	private boolean status = true;
	private string JOB_Name = 'Product Classification Schedule';
   
	
	global void execute(SchedulableContext SC)	  
		 {
		   //Database.executebatch(batch,1);   
		   calloutmethod();				 
		 } 
	
   /* global Batch_Productclassification(){
		
	  token = getToken();
	} */
		
	public  String getToken(){
		
		try{
		AuthProvider auth =[SELECT ConsumerKey,ConsumerSecret,DeveloperName,Id FROM AuthProvider where DeveloperName = 'AzureEDP' Limit 1];
	 	string clientId = auth.ConsumerKey; 
		string clientSecret = auth.ConsumerSecret; 
		string resource =EDP_URLs__c.getInstance('resource').URL__c;  
		
	 	HttpRequest req = new HttpRequest();  
		req.setMethod('POST');
		req.setEndpoint('callout:EDP_Login');
		req.setBody('grant_type=password' +
			'&client_id=' + EncodingUtil.urlEncode(clientId, 'UTF-8') +
			'&client_secret=' + EncodingUtil.urlEncode(clientSecret, 'UTF-8') +
			'&username=' + '{!HTMLENCODE($Credential.Username)}' +
			'&password=' + '{!HTMLENCODE($Credential.Password)}' +
			   '&resource=' +EncodingUtil.urlEncode(resource, 'UTF-8')   );
	 
		Http http = new Http();
		HTTPResponse response = http.send(req);
 		/*
 		System.debug('Req BODY: '+clientSecret);
		System.debug('BODY: '+response.getBody());
		System.debug('STATUS:'+response.getStatus());
		System.debug('STATUS_CODE:'+response.getStatusCode());
		*/
		deserializeResponse resp1 = (deserializeResponse)JSON.deserialize(response.getbody(),deserializeResponse.class);
		token = resp1.access_token;
			   //system.debug('token is:'+token);
			 //return token;
		}
		catch(CalloutException ex){
			System.debug('CAllout Exception: '+ex);
			if(ex.getMessage() == 'Read timed out'){
	token = getToken();
	return token;				
			}
	 else{
				status = false;
				return null;
			}
		}
		return token;
	}
	
	  public Integer getCountofRecords(String Query){
		//System.debug('Inside count function:');
		string Q;
		 Q=Query+'&$count=true&$top=1';
		  //Q = Query+'?$count=true&$top=1';  
		
	   
		try
		{
			if(token!=null){
			HttpRequest request = new HttpRequest();
				 request.setMethod('GET');						   
					request.setEndpoint(Q);
				   // request.setEndpoint('https://edpqaapi.azurewebsites.net/api/ProductFeatures');
					request.setHeader('Authorization', 'Bearer '+token);
					request.setHeader('Content-Type','application/json');
					request.setTimeout(20000);
					Http http1 = new Http();
					HttpResponse response1 = http1.send(request);
					//System.debug('After response');
					String responseStr = response1.getBody();
				//System.debug('REsponse count:'+responseStr);
				JSONParser jsonparser = JSON.createParser(response1.getBody());
				while (jsonparser.nextToken() != System.JSONToken.END_OBJECT) {
					if (jsonparser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
						String text = jsonparser.getText();
						if (jsonparser.nextToken() != System.JSONToken.VALUE_NULL) {
							if(text=='@odata.count'){
								count = jsonparser.getIntegerValue();
								//System.debug(jsonparser.getText());

											   System.debug('count is: '+count);
							}
						}
					}
				}
				return count;
			}else{
				return 0;
			}
			
			 }catch(Exception ex){
			System.debug('CAllout Exception: '+ex);
			if(ex.getMessage() == 'Read timed out'){
			   System.debug('Attempting to read again with token: '+token);
	count = getCountofRecords(Query);
	return count;				
			}
			else
				return 0;
		}		
	}
	
global Iterable<String> start(Database.BatchableContext BC){
	token=getToken();
		
	 List<String> QueryList = new List<String>(); 
	   
		url = EDP_URLs__c.getInstance('PCL').URL__c;
	   System.debug('url: '+url);
		String Query1=url;
					EDP_CH_Settings__c  pcEntry = 	EDP_CH_Settings__c.getInstance('ProductClassifications'); 
						String ModifiedDate1 = String.valueOf(pcEntry.ModifiedDate__c);
						String FullLoadFilter= String.valueOf(pcEntry.Full_Load_Filter__c);
	   
	   if(pcEntry.Full_Load__c){
				  if(pcEntry.Full_Load_Filter__c!=Null)
				  {
					 FullLoadFilter = FullLoadFilter.replaceAll('=', '%20eq%20').replaceall('!=', '%20ne%20').replaceall('>','%20gt%20').replaceall('<','%20lt%20');
					 Query1=Query1+'?$filter='+FullLoadFilter+'&$orderby=NSNCode';	
				  }
					else{
					  Query1 =Query1+'?$orderby=NSNCode';
						 }
		   
				   }
		else{
					  
			if(String.valueOf(pcEntry.ModifiedDate__c) == null){
																 DateTime currDate = system.now() - 1;
															 ModifiedDate1 = currDate.format('yyyy-MM-dd HH:mm:ss');
																}
					//ModifiedDate= ModifiedDate.format('yyyy-MM-dd HH:mm:ss');
					ModifiedDate1 = ModifiedDate1.replace(' ','T') +'Z';
					//System.debug('Curr time:'+ModifiedDate1); 
					Query1 = Query1+'?$filter='+'EDP_LastModifiedDate%20gt%20' + ModifiedDate1+'&$orderby=NSNCode';
		   }			  
		  //system.debug('Query1 is: '+Query1); 
	   //checks count of records
	  integer countSI = getCountofRecords(Query1);

	   if(countSI>2000)
	   {
			integer noOfTimes = count / 2000;
					integer skipCount = 2000;
					System.debug('No of times query should run '+noOfTimes);
					
					QueryList.add(Query1+'&$top=2000');
					for(integer i=0;i<noOfTimes;i++)
					{
						QueryList.add(Query1+'&$skip='+skipCount+'&$top=2000');
						skipCount = skipCount + 2000;
					}
	   }
		else if(countSI>0 && countSI<2000)
		{
			QueryList.add(Query1);
		}

	   
	  return QueryList;  
   }   

global void execute(Database.BatchableContext BC,List<String> Queries){
	
		  String tok = getToken();
	   List<Interface_Log__c> ilogs = new List<Interface_Log__c>();
		
		 //Retreive response for the query
		HttpRequest request = new HttpRequest();
		 String path = Queries[0];
		 Http http1 = new Http();
		 HttpResponse response1;
		try
		{			
					request.setMethod('GET');					
					request.setEndpoint(path);
					request.setHeader('Authorization', 'Bearer '+tok);
					request.setHeader('Content-Type','application/json');
					request.setTimeout(20000);					
					response1 = http1.send(request);
					//System.debug('After response : '+response1.getStatus());
		}
		catch(Exception ex)
		{
		   System.debug('Exception occured during retreiving response for query:'+path+'Exception: '+ex);
			if(ex.getMessage() == 'Read timed out'){
				//System.debug('Attempting to read again because of read time out exception...');
	response1 = http1.send(request);
				   
			}
		}
		
		if(response1.getStatusCode() != 200){
		   // System.debug('Error: '+response1.getBody());
			status=false;
		}
		
	   List<ProductClassification__c> ClassifList = new List<ProductClassification__c>(); 
		//String[] sample=new String[]{};
			
		if(response1.getStatusCode() == 200){

					 //  System.debug(response1.getBody());
		 status=true;
			
		 List<ProductClassifcls> pcarr = (List<ProductClassifcls>)System.JSON.deserialize(response1.getBody().substring(response1.getBody().indexOf('['), response1.getBody().lastIndexOf(']')+1), List<ProductClassifcls>.class);
		 Set<String> NsnCodeSet= new Set<String>();   
		   
				for(ProductClassifcls s: pcarr)
			{
				ProductClassification__c pc= new ProductClassification__c();
				
				 pc.ItemType__c= s.ItemType;
				 pc.Name__c=s.Name;
				 pc.NSNClassnumber__c=s.NSNClassNumber;
				 pc.NSNClassOrder__c=s.NSNClassOrder;
				 pc.NSNClassType__c=s.NSNClassType;
				 pc.ActionType__c=s.ActionType;
				 pc.PDMTimestamp__c=s.PDMTimestamp;
				 pc.PDMModified__c=s.PDMModified;
				 pc.Revision__c=s.Revision;
				 pc.NSNClassLibrary__c=s.NSNClassLibrary;
				 pc.Lifecyclestatus__c=s.LifeCycleStatus;	
				 pc.ClassificationStatus__c=s.ClassificationStatus;
				 pc.EDP_LastModifiedDate__c=s.EDP_LastModifiedDate;   
				 pc.EDP_ActiveStatus__c=s.EDP_ActiveStatus;
				 pc.NSNCode__c=s.NSNCode;
				
				if(!NsnCodeSet.contains(pc.NSNCode__c))
				{
					ClassifList.add(pc);
					NsnCodeSet.add(pc.NSNCode__c);
				}
				
				
					
			}
		}
		 
	 
	   List<Database.UpsertResult> results_pc = Database.upsert(ClassifList,ProductClassification__c.NSNCode__c,false);
				//// Callout Interface Logs////
			//string prod_code_str = string.join(sample,', '); 
				
			Interface_Log__c ilog_callout1 = new Interface_Log__c();
				  ilog_callout1.Interface_Type__c = 'EDP Product Classification Stage';
				  ilog_callout1.Message_Type__c = 'Inbound';
				  ilog_callout1.Operation_Type__c ='Insert';
				  //ilog_callout1.Status__c = 'Success';
				  // ilog_callout1.Name = 'Product Classification Rest Callout';
						 
				   if(response1.getStatuscode() ==200){
					  ilog_callout1.Interface_Request_Sent__c = 'Request URL: '+Queries[0]+ '\n'+
															   'Response: '+response1.getStatus()+'\n'+
															   'Response Code'+response1.getStatuscode();
					  ilog_callout1.Status__c = 'Success';
					  ilog_callout1.Name = 'Product Classification Rest Callout success';
					   //system.debug('Product Classification Rest Callout success');
					} 
					else {
					   ilog_callout1.Interface_Request_Sent__c = 'Request URL: '+Queries[0]+ '\n'+
																'Response: '+response1.getStatus()+'\n'+
																'Response Code'+response1.getStatuscode();
					   ilog_callout1.Status__c = 'Failure';
					   ilog_callout1.Name = 'Product Classification Rest Callout Failed';
					}
				ilogs.add(ilog_callout1);
			
			  ////Interface Logs////
			  //
			for(Integer index = 0, size = results_pc.size(); index < size; index++) {
			String Operationtype= results_pc[index].isCreated()?'Insert':'Update';
			if(!results_pc[index].isSuccess()) { 
				////Prod Classification Error Interface Logs///
				Interface_Log__c ilog_pc = new Interface_Log__c();
				for (Database.Error err : results_pc[index].getErrors()){
					ilog_pc.comment__c = 'Fields: '+err.getFields()+'Message: '+err.getMessage()+
											'Status Code: '+err.getStatusCode();
				}
				
				//ilog_pc.comment__c = results_pc[index].getMessage();
				ilog_pc.Interface_Type__c = 'EDP Product Classification Stage';
				ilog_pc.Message_Type__c = 'Inbound';
				ilog_pc.Operation_Type__c = Operationtype;  
				ilog_pc.Status__c = 'Failure';
				ilog_pc.Interface_Request_Sent__c = 'Request URL: '+path+ '\n'+
													'ItemType: '+ ClassifList[index].ItemType__c+'\n'+
													'NSN Code: '+ ClassifList[index].NSNCode__c+'\n'+
													'LifeCycleStatus: '+ ClassifList[index].LifecycleStatus__c +'\n'+
													'EDP_LastModifiedDate: '+ ClassifList[index].EDP_LastModifiedDate__c;
			   ilog_pc.Name = 'Product classiffication record '+Operationtype+ ' Failure with NSNCode'+ ClassifList[index].NSNCode__c;
			 ilogs.add(ilog_pc);
				
			   // system.debug('Failure is:'+ilog_pc.Interface_Request_Sent__c );
								   
			}
			else{ 
				////Prod Classification Success Interface Logs///
			Interface_Log__c ilog_pc = new Interface_Log__c();
				ilog_pc.comment__c = 'Success';
				ilog_pc.Interface_Type__c = 'EDP Product Classification Stage';
				ilog_pc.Message_Type__c = 'Inbound';
				ilog_pc.Operation_Type__c =Operationtype;
				ilog_pc.Status__c = 'Success';
				ilog_pc.Interface_Request_Sent__c = 'Request URL: '+path+ '\n'+
													'ItemType: '+ClassifList[index].ItemType__c+ '\n'+
													 'NSN Code: '+ ClassifList[index].NSNCode__c+'\n'+
													'LifeCycleStatus: '+ClassifList[index].LifecycleStatus__c +'\n'+
													'EDP_LastModifiedDate: '+ClassifList[index].EDP_LastModifiedDate__c;
				ilog_pc.Name = 'Product classification record '+Operationtype+' Success with NSN code'+ClassifList[index].NSNCode__c;
			 ilogs.add(ilog_pc);
				 //system.debug('Success is:'+ilog_pc.Interface_Request_Sent__c);
			   
				   }
			   
		}
			Database.Insert(Ilogs,false);
		 
	 
	/*System.debug('**Data loaded to Product successfully**'); 
	System.debug('Heap size : '+Limits.getHeapSize());
	System.debug('Number of SOQL Queries: '+Limits.getQueries());
	System.debug('Number of Query rows : '+Limits.getQueryRows());
	System.debug('Number of DML rows : '+Limits.getDmlRows());
	System.debug('CPU time limit of : '+Limits.getCpuTime());*/
	
}
	   
		global void finish(Database.BatchableContext BC)
		{
			System.debug('Finally....');
			System.debug('Status is '+status);
			
		 // status=false;
		  //System.debug('Now status is set to: '+status);
			
			if(status==false){
			   
					  unschedule();
					  rescheduleMethod();			   
			}
			else
			{
				clearcustomsetting();
	
			}
		} 
	
public class ProductClassifcls{
		
Public string ItemType;
Public string Name;
Public string NSNClassNumber;
Public string NSNClassOrder;
Public string NSNClassType;
Public string ActionType;
Public DateTime PDMTimestamp;
Public Datetime PDMModified;
Public string Revision;
Public string NSNClassLibrary;
Public string LifeCycleStatus;
Public string ClassificationStatus;
Public string NSNCode;
Public DateTime EDP_LastModifiedDate;
Public boolean EDP_ActiveStatus; 
	}
	
public void calloutmethod(){
		  //check if there are 5 active batch jobs
			integer count = [SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND status in ('Processing','Preparing','Queued')];
		   if (count < 5 )
		   { 
			   Batch_Productclassification batch= new Batch_Productclassification();
			   Database.executebatch(batch,1); 
			   //system.debug('Success!!!');
			} 
		  else {
			   //schedule this same schedulable class again in 60 mins
						  //unscheduleMe();			  
						  Batch_Productclassification  pcsch= new Batch_Productclassification ();
						  Datetime dt = Datetime.now().addMinutes(60);  // i.e. 60 mins
						  String timeForScheduler = dt.format('s m H * * \'?\' *');
						  system.schedule('PostSch-ClassificationSchedule',timeForScheduler, pcsch);
						  //system.abortJob(pcsch.Id);
								 
				
			  //Add 25 hrs to custom setting modified date time			
				List<EDP_CH_Settings__c> edpEntryList = [Select Id,Name,ModifiedDate__c from EDP_CH_Settings__c];
			  //system.debug('It is: '+edpEntryList);
			  if(edpEntryList != null)
				{
					for(EDP_CH_Settings__c edpEntry : edpEntryList)
				  {
					  edpEntry.ModifiedDate__c = Datetime.now().addHours(-25);
				  }
				}
				
					Database.update(edpEntryList,false);
				
			  
			}
	}
	 public void unschedule()
	{
		try
		{
			CronTrigger[] cronTrigger = [SELECT Id 
										 FROM CronTrigger 
										 where CronJobDetail.Name = :JOB_Name];
			if(cronTrigger != null && !cronTrigger.isEmpty())
				System.abortJob(cronTrigger[0].Id);
		}catch(Exception e)
		{
			System.debug('Error while aborting job :'+JOB_Name+'Exception: '+e);
		}
	}
	
	public void rescheduleMethod(){
	   Batch_Productclassification  pcsch= new Batch_Productclassification ();
						  Datetime dt = Datetime.now().addMinutes(60);  // i.e. 60 mins
						  String timeForScheduler = dt.format('s m H * * \'?\' *');
						  system.schedule(JOB_NAME,timeForScheduler, pcsch);
						  //system.abortJob(pcsch.Id);
								 
				
			  //Add 25 hrs to custom setting modified date time			
				List<EDP_CH_Settings__c> edpEntryList = [Select Id,Name,ModifiedDate__c from EDP_CH_Settings__c];
			  system.debug('It is: '+edpEntryList);
			  if(edpEntryList != null)
				{
					for(EDP_CH_Settings__c edpEntry : edpEntryList)
				  {
					  edpEntry.ModifiedDate__c = Datetime.now().addHours(-25);
				  }
				}
				
					Database.update(edpEntryList,false);
				  
	}
	 public void clearcustomsetting()
	{
		EDP_CH_Settings__c  pcEntry = EDP_CH_Settings__c.getInstance('ProductClassifications'); 
		pcEntry.ModifiedDate__c = null;
		pcEntry.Full_Load_Filter__c= '';  
		pcEntry.Full_Load__c = false;
		update pcEntry;
	}
}