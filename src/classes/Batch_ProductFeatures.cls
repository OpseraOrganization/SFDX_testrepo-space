/****************************************
		 * Name		: Batch_ProductFeatures
		 * Description : Loads data to staging object
		 * Author	  : Accenture
*****************************************/ 



global class Batch_ProductFeatures implements Database.Batchable<String>,Database.AllowsCallouts,Database.Stateful,Schedulable {

	public String token;
	public static integer count;
	public String url='';
	private boolean status = true;
	
	global void execute(SchedulableContext SC)	  
		 {
		  calloutmethod();					  
		 } 
   /* public Batch_ProductFeatures(){
								   token = getToken();	 
								  } */
	
	public String getToken(){
		
		try{
			AuthProvider auth =[SELECT ConsumerKey,ConsumerSecret,DeveloperName,Id FROM AuthProvider where DeveloperName = 'AzureEDP' Limit 1];
			string clientId = auth.ConsumerKey; 
			 string clientSecret = auth.ConsumerSecret; 
		   // if(auth.ConsumerSecret == 'test')
			 //   clientSecret = '';
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
			System.debug('BODY: '+response.getBody());
	 /*System.debug('Req BODY: '+clientSecret);
		System.debug('BODY: '+response.getBody());
		System.debug('STATUS:'+response.getStatus());
	   System.debug('STATUS_CODE:'+response.getStatusCode());
	 */   
		deserializeResponse resp1 = (deserializeResponse)JSON.deserialize(response.getbody(),deserializeResponse.class);
		token = resp1.access_token;
			  system.debug(token);
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
				System.debug('REsponse count:'+response1);
				JSONParser jsonparser = JSON.createParser(response1.getBody());
				while (jsonparser.nextToken() != System.JSONToken.END_OBJECT) {
					if (jsonparser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
						String text = jsonparser.getText();
						if (jsonparser.nextToken() != System.JSONToken.VALUE_NULL) {
							if(text=='@odata.count'){
								count = jsonparser.getIntegerValue();
							   // System.debug(jsonparser.getText());

											   // System.debug('count is'+count);
							}
						}
					}
				}
				return count;
			}else{
				return 0;
			}
			
			 }catch(Exception ex){
		   // System.debug('CAllout Exception: '+ex);
			if(ex.getMessage() == 'Read timed out'){
			   // System.debug('Attempting to read again with token: '+token);
		count = getCountofRecords(Query);
		return count;				
			}
			else
			  return 0;
		}		
	}
	
	global Iterable<String> start(Database.BatchableContext BC){
		 
	  token=getToken();
	  url= EDP_URLs__c.getInstance('PF').URL__c;
	  List<String> QueryList = new List<String>(); 
	  String Query1 =url;
		
	  EDP_CH_Settings__c  pcEntry =   EDP_CH_Settings__c.getInstance('ProductFeatures'); 
	  String ModifiedDate1 = String.valueOf(pcEntry.ModifiedDate__c);
	  String FullLoadFilter= String.valueOf(pcEntry.Full_Load_Filter__c);
		
	  if(pcEntry.Full_Load__c){
								
		  if(pcEntry.Full_Load_Filter__c!=Null)
				  {
					 FullLoadFilter = FullLoadFilter.replaceAll('=', '%20eq%20').replaceall('!=', '%20ne%20').replaceall('>','%20gt%20').replaceall('<','%20lt%20');
					 Query1=Query1+'?$filter='+FullLoadFilter+'&$orderby=Name';	
				  }
					else{
							Query1=url+'?$orderby=Name'; 
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
					 Query1 = url+'?$filter='+'EDP_LastModifiedDate%20gt%20' + ModifiedDate1; 
				   
				   
		}
		System.debug('Query1 is: '+Query1);
		system.debug('URL is:'+url);
	  //check count of records
	  integer countSI = getCountofRecords(Query1);
	   if(countSI>2000)
	   {
			integer noOfTimes = count / 2000;
					integer skipCount = 2000;
					//System.debug('No of times query should run '+noOfTimes);
					
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
		//String path='https://edpqaapi.azurewebsites.net/api/ProductFeatures';
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
		   // System.debug('Exception occured during retreiving response for query:'+path+'Exception: '+ex);
			if(ex.getMessage() == 'Read timed out'){
			   // System.debug('Attempting to read again because of read time out exception...');
		response1 = http1.send(request);
					   
			}
		}
		
		Map<String,ProductFeature__c> FeatureMap = new Map<String,ProductFeature__c>();
		List<ProductFeature__c> FeatureList = new List<ProductFeature__c>();
		Set<String> FeatureItemIdSET= new Set<String>();
		
		try{
		
		if(response1.getStatusCode() != 200){
			//System.debug('Error: '+response1.getBody());
		}
		
		if(response1.getStatusCode() == 200){

					 //  System.debug(response1.getBody());
			
		   
	//Deserialize the response in to Product Features list
  	List<ProdFeature> Prfearr = (List<ProdFeature>)System.JSON.deserialize(response1.getBody().substring(response1.getBody().indexOf('['), response1.getBody().lastIndexOf(']')+1), List< ProdFeature>.class);
			
			 
				for(ProdFeature Pr: Prfearr)
			{
				ProductFeature__c Prodfeature= new ProductFeature__c();
				Prodfeature.AlternateCode__c=Pr.AlternateCode;
				Prodfeature.AlternateCode2__c=Pr.AlternateCode2;
				Prodfeature.Description__c=Pr.Description;
				Prodfeature.EDP_ActiveStatus__c=Pr.EDP_ActiveStatus;
				Prodfeature.EDP_LastModifiedDate__c=Pr.EDP_LastModifiedDate;
				Prodfeature.FeatureItemId__c=Pr.FeatureItemId;
				Prodfeature.ItemID__c =Pr.ItemID;
				Prodfeature.LastUpdate__c=Pr.LastUpdate;
				Prodfeature.LifeCycleStatus__c=Pr.LifeCycleStatus;
				Prodfeature.ItemType__c=Pr.ItemType;
				Prodfeature.NSNAdditionalInformation__c=Pr.NSNAdditionalInformation;
				Prodfeature.NSNFocalPointId__c=Pr.NSNFocalPointId;
				Prodfeature.NSNClassification__c=Pr.NSNClassification;
				Prodfeature.NSNLegacyFeatureId__c=Pr.NSNLegacyFeatureId;
				Prodfeature.NSNLegacyNcmCode__c=Pr.NSNLegacyNcmCode;
				Prodfeature.NSNLegacyRevision__c=Pr.NSNLegacyRevision;
				Prodfeature.NSNNameInCustomerNetwork__c=Pr.NSNNameInCustomerNetwork;
				Prodfeature.NSNLicenced__c=Pr.NSNLicenced;
				Prodfeature.NSNSummary__c=Pr.NSNSummary;
				Prodfeature.Originated__c=Pr.Originated;
				Prodfeature.PDMModified__c=Pr.PDMModified;
				Prodfeature.PDMTimestamp__c=Pr.PDMTimestamp;
				Prodfeature.Owner__c=Pr.Owner;
				Prodfeature.Policy__c=Pr.Policy;
				Prodfeature.Vault__c=Pr.Vault;
				Prodfeature.Type__c=Pr.Type;
				Prodfeature.Name__c=Pr.Name;
				Prodfeature.NSN_Code__c = Pr.NSNCode;
				Prodfeature.Created_by_PMDI__c = true;
				if(Pr.NSNFocalPointId != Null && Pr.NSNFocalPointId.contains(CSWXGlobalConstant.LTE)){
					
					string Focalpoint = Pr.NSNFocalPointId.replace('RA LTE_FC_', CSWXGlobalConstant.LTE);
					Prodfeature.Feature_Commercial_Number__c = Focalpoint;
				}
				
				if(!FeatureItemIdSET.contains(Prodfeature.FeatureItemId__c))
				{
				   //FeatureList.add(Prodfeature);
				   FeatureMap.put(Prodfeature.FeatureItemId__c,Prodfeature);
				   FeatureItemIdSET.add(Prodfeature.FeatureItemId__c);
				} 
				}
				
			//Query existing product features to check if its a insert or update
			//if insert,mark created by PMDI field as true
			for(ProductFeature__c productFeature : [Select Id,FeatureItemId__c,Created_by_PMDI__c
												 from ProductFeature__c
												where FeatureItemId__c in :FeatureItemIdSET
												  ])
				if(FeatureMap.get(productFeature.FeatureItemId__c) <> null &&
				  !productFeature.Created_by_PMDI__c ){
					FeatureMap.get(productFeature.FeatureItemId__c).Created_by_PMDI__c = false;
				}
			}
 
		
		FeatureList = FeatureMap.values();
		//Insert or update the result in to product feature object
			List<Database.UpsertResult> results_pf = Database.upsert(FeatureList,ProductFeature__c.FeatureItemId__c, false);
				//// Callout Interface Logs////
		
				  Interface_Log__c ilog_callout = new Interface_Log__c();
				  ilog_callout.Interface_Type__c = 'EDP Feature Stage';
				  ilog_callout.Message_Type__c = 'Inbound';
				  ilog_callout.Operation_Type__c = 'Insert';
				  //ilog_callout.Status__c = 'Success';
				  // ilog_callout.Name = 'SI Rest Callout';
						 
				   if(response1.getStatuscode() ==200){
					  ilog_callout.Interface_Request_Sent__c = 'Request URL: '+Queries[0]+ '\n'+
															   'Response: '+response1.getStatus()+'\n'+
															   'Response Code'+response1.getStatuscode();
					  ilog_callout.Status__c = 'Success';
					  ilog_callout.Name = 'Product Feature Rest Callout success';
					} 
					else {
					   ilog_callout.Interface_Request_Sent__c = 'Request URL: '+Queries[0]+ '\n'+
																'Response: '+response1.getStatus()+'\n'+
																'Response Code'+response1.getStatuscode();
					   ilog_callout.Status__c = 'Failure';
					  ilog_callout.Name = 'Product Feature Rest Callout Failed';
					}
				ilogs.add(ilog_callout);
			
			  ////Interface Logs////
	  for(Integer index = 0, size = results_pf.size(); index < size; index++) {
			String Operationtype= results_pf[index].isCreated()?'Insert':'Update';
			if(!results_pf[index].isSuccess()) { 
				////Prod feature Error Interface Logs///
				Interface_Log__c ilog_pf = new Interface_Log__c();
				for (Database.Error err : results_pf[index].getErrors()){
					ilog_pf.comment__c = 'Fields: '+err.getFields()+'Message: '+err.getMessage()+
											'Status Code: '+err.getStatusCode();
				}
				
				//ilog_pf.comment__c = results_pci[index].getMessage();
				ilog_pf.Interface_Type__c = 'EDP Feature Stage';
				ilog_pf.Message_Type__c = 'Inbound';
				ilog_pf.Operation_Type__c = Operationtype;
				ilog_pf.Status__c = 'Failure';
				ilog_pf.Interface_Request_Sent__c = 'Request URL: '+path+ '\n'+
													'Name: '+FeatureList[index].Name__c+ '\n'+
													'Type: '+ FeatureList[index].Type__c +'\n'+
													'Description: '+ FeatureList[index].Description__c +'\n'+
													'LifeCycleStatus: '+ FeatureList[index].LifeCycleStatus__c +'\n'+
													'EDP_LastModifiedDate: '+ FeatureList[index].  EDP_LastModifiedDate__c;
				ilog_pf.Name = 'Prod feature '+Operationtype+' Failed with FeatureItemId: '+ FeatureList[index].FeatureItemId__c;
			 ilogs.add(ilog_pf);
				
			   // system.debug('Failure is:'+ilog_pf.Interface_Request_Sent__c );
								   
			}
			else{ 
				////Prod Feature Success Interface Logs///
			Interface_Log__c ilog_pf = new Interface_Log__c();
				ilog_pf.comment__c = 'Success';
				ilog_pf.Interface_Type__c = 'EDP Feature Stage';
				ilog_pf.Message_Type__c = 'Inbound';
				ilog_pf.Operation_Type__c = Operationtype;
				ilog_pf.Status__c = 'Success';
				ilog_pf.Interface_Request_Sent__c = 'Request URL: '+path+ '\n'+
													'Name: '+FeatureList[index].Name__c+ '\n'+
													'Type: '+FeatureList[index].Type__c +'\n'+
												   'Description: '+FeatureList[index].Description__c +'\n'+
													'LifeCycleStatus: '+FeatureList[index].LifeCycleStatus__c +'\n'+
													'EDP_LastModifiedDate: '+FeatureList[index].EDP_LastModifiedDate__c;
				ilog_pf.Name = 'Prod feature '+Operationtype+ ' Success with FeatureItemId: '+FeatureList[index].FeatureItemId__c;
			 ilogs.add(ilog_pf);
				// system.debug('Success is:'+ilog_pf.Interface_Request_Sent__c);
			   
				   }
				
		}

	Database.Insert (Ilogs,false);
		}catch(Exception ex)
		{
			ExceptionHandler.addException(ex,'Batch Product Features' , 'Execute');
		}
		
 }
	  global void finish(Database.BatchableContext BC)
		{
		   
			//System.debug('Finally....');
			//System.debug('Status is '+status);
			
			if(status==false){
			   
					  unscheduleMe();
					  rescheduleMethod();			   
			}
			else
			{
				clearcustomsetting();
	
			}
			
		
		}
	
	
 public class ProdFeature{
				
		Public string Description;
		Public string FeatureItemId;
		Public string ItemID;
		Public string ItemType;
		Public string Lifecyclestatus;
		Public string NSNAdditionalInformation;
		Public string AlternateCode2;
		Public string AlternateCode;
		Public string NSNLegacyNcmCode;
		Public string NSNLegacyRevision;
		Public string NSNNameInCustomerNetwork;
		Public string NSNClassification;
		Public string NSNSummary;
		Public string Owner;
		Public string Policy;
		Public string Vault;
		Public string Type;
		Public string NSNFocalPointId;
		Public string NSNLicenced;
		Public string NSNLegacyFeatureId;
		Public string Name;
		Public boolean EDP_ActiveStatus;
		Public DateTime PDMTimestamp;
		Public DateTime PDMModified;
		Public DateTime Originated;
		Public DateTime LastUpdate;
		Public DateTime EDP_LastModifiedDate; 
		Public string NSNCode;
				
			}
	
	public void calloutmethod(){
		  //check if there are 5 active batch jobs
			integer count = [SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND status in ('Processing','Preparing','Queued')];
		   if (count < 5)
		   { 
			   Batch_ProductFeatures batch= new Batch_ProductFeatures();
			   Database.executebatch(batch,1); 
			   system.debug('Success!!!');
			} 
		  else {
			   //schedule this same schedulable class again in 60 mins
						  //unscheduleMe();			  
						Batch_ProductFeatures  pcsch= new Batch_ProductFeatures ();
						  Datetime dt = Datetime.now().addMinutes(60);  // i.e. 60 mins
						  String timeForScheduler = dt.format('s m H * * \'?\' *');
						  system.schedule('PostSch-FeaturesSchedule',timeForScheduler, pcsch);
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
	}
	public void unscheduleMe(){
							  
		for ( CronJobDetail ct : [SELECT Id,JobType,Name FROM CronJobDetail WHERE Name like 'ProductFeature%'] ) {System.abortJob(ct.Id); }
							  
						  }
	public void rescheduleMethod(){
		Batch_ProductFeatures  Prsch= new Batch_ProductFeatures();
						  Datetime dt = Datetime.now().addMinutes(60);  // i.e. 60 mins
						  String timeForScheduler = dt.format('s m H * * \'?\' *');
						  system.schedule('PostSch-FeaturesSchedule',timeForScheduler, Prsch);
								   
				
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
		EDP_CH_Settings__c  pcEntry = EDP_CH_Settings__c.getInstance('ProductFeatures'); 
		pcEntry.ModifiedDate__c = null;
		pcEntry.Full_Load_Filter__c= '';  
		pcEntry.Full_Load__c = false;
		update pcEntry;
	}
	
}