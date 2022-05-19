/****************************************
* Name	 : Batch_ProductReleaseCls
* Description : Loads data to staging object
* Author	 : Accenture
*****************************************/ 
global without sharing class Batch_ProductReleaseCls implements Database.Batchable<String>,Database.AllowsCallouts,Database.Stateful,Schedulable {
	
	public String token;
	public static integer count;
	public String url='';
	private boolean status = true;
	private string JOB_Name = 'Product Releases Schedule';
	
	global void execute(SchedulableContext SC)	
	{
		calloutmethod();	
	} 
	/* global Batch_ProductReleaseCls(){

token = getToken();
} */
	
	public String getToken(){
		
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
			//System.debug('Req BODY: '+clientSecret);
			//System.debug('BODY: '+response.getBody());
			//System.debug('STATUS:'+response.getStatus());
			//System.debug('STATUS_CODE:'+response.getStatusCode());
			
			deserializeResponse resp1 = (deserializeResponse)JSON.deserialize(response.getbody(),deserializeResponse.class);
			token = resp1.access_token;
			// system.debug(token);
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
		
		try
		{
			if(token!=null){
				HttpRequest request = new HttpRequest();
				request.setMethod('GET');	 
				request.setEndpoint(Q);
				request.setHeader('Authorization', 'Bearer '+token);
				request.setHeader('Content-Type','application/json');
				request.setTimeout(20000);
				Http http1 = new Http();
				HttpResponse response1 = http1.send(request);

				JSONParser jsonparser = JSON.createParser(response1.getBody());
				while (jsonparser.nextToken() != System.JSONToken.END_OBJECT) {
					if (jsonparser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
						String text = jsonparser.getText();
						if (jsonparser.nextToken() != System.JSONToken.VALUE_NULL && text=='@odata.count') {
							count = jsonparser.getIntegerValue();
							// System.debug(jsonparser.getText());
							
							//System.debug('count is'+count);
						}
					}
				}
				return count;
			}else{
				return 0;
			}
		}catch(Exception ex){
			//System.debug('CAllout Exception: '+ex);
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
		url = EDP_URLs__c.getInstance('PRL').URL__c;
		List<String> QueryList = new List<String>(); 
		String Query1 =url;
		
		EDP_CH_Settings__c  pcEntry = EDP_CH_Settings__c.getInstance('ProductReleases'); 
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
			Query1 =url+'?$filter='+'EDP_LastModifiedDate%20gt%20' + ModifiedDate1;	 
		}
		
		// System.debug('Query1: '+Query1);
		
		//checks count of records
		integer batchsize= integer.valueof(label.Product_ReleaseBatch_Size);
		integer countSI = getCountofRecords(Query1);
		if(countSI> batchsize)
		{
			integer noOfTimes = count / batchsize;
			integer skipCount = batchsize;
			//System.debug('No of times query should run '+noOfTimes);
			
			QueryList.add(Query1+'&$top='+ batchsize );
			for(integer i=0;i<noOfTimes;i++)
			{
				QueryList.add(Query1+'&$skip='+skipCount+'&$top=' + batchsize);
				skipCount = skipCount + batchsize;
			}
		}
		else if(count>0)
		{
			QueryList.add(Query1);
		}
		// System.debug('QueryList:'+QueryList);
		
		return QueryList;  
	}
	
	global void execute(Database.BatchableContext BC,List<String> Queries){
		
		
		String tok = getToken();
		
		List<interface_log__c> ilogs = new List<interface_log__c>();
		
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
			// System.debug('After response : '+response1.getStatus());
		}
		catch(Exception ex)
		{
			// System.debug('Exception occured during retreiving response for query:'+path+'Exception: '+ex);
			if(ex.getMessage() == 'Read timed out'){
				//System.debug('Attempting to read again because of read time out exception...');
				response1 = http1.send(request);
				
			}
		}
		
		
		system.debug('Response:'+response1);
		system.debug('Response:'+response1.getBody());
		system.debug('response1.getStatusCode():'+response1.getStatusCode());
		
		
		if(response1.getStatusCode() != 200){
			// System.debug('Error: '+response1.getBody());
		} 
		
		List<ProductRelease__c> ReleasesList = new List<ProductRelease__c>();
		Set<String> NsnCodeSET= new Set<String>(); 
		// String[] sample=new String[]{};
		if(response1.getStatusCode() == 200){
			
			//System.debug(response1.getBody());
			List<ProdRel> prarr = (List<ProdRel>)System.JSON.deserialize(response1.getBody().substring(response1.getBody().indexOf('['), response1.getBody().lastIndexOf(']')+1), List<ProdRel>.class);
			
			
			for(ProdRel pr: prarr)
			{
				ProductRelease__c prodRel= new ProductRelease__c();
				prodRel.C1ReadyForProgram__c=pr.C1ReadyForProgram;
				prodRel.C2ReadyForMarketing__c=pr.C2ReadyForMarketing;
				prodRel.C3ReadyForOffering__c=pr.C3ReadyForOffering;
				prodRel.C4ReadyForOrdering__c=pr.C4ReadyForOrdering;
				prodRel.C5ReleaseAvailable__c=pr.C5ReleaseAvailable;
				prodRel.C6ReadyForRampdown__c=pr.C6ReadyForRampdown;
				prodRel.C7EndOfMarketing__c=pr.C7EndOfMarketing;
				prodRel.C8EndOfOrdering__c=pr.C8EndOfOrdering;
				prodRel.C9EndOfDeliveries__c=pr.C9EndOfDeliveries;
				if(pr.Description != NULL){
					prodRel.Description__c=pr.Description;
				} else {
					prodRel.Description__c = '#N/A';
				}				
				prodRel.EDP_ActiveStatus__c =pr.EDP_ActiveStatus;  
				prodRel.EDP_LastModifiedDate__c=pr.EDP_LastModifiedDate;
				prodRel.Implement__c=pr.Implement;
				prodRel.ItemID__c =pr.ItemID;
				prodRel.LastUpdate__c=pr.LastUpdate;
				prodRel.Lifecyclestatus__c=pr.Lifecyclestatus;
				prodRel.Maintain__c=pr.Maintain;
				prodRel.NSNAliasName__c=pr.NSNAliasName;
				prodRel.NSNCode__c=pr.NSNCode;
				prodRel.NSNDesignResponsibility__c=pr.NSNDesignResponsibility;
				prodRel.NSNLegacyCode__c=pr.NSNLegacyCode;
				prodRel.NSNLegacyNcmCode__c=pr.NSNLegacyNcmCode;
				prodRel.NSNLegacyRevision__c=pr.NSNLegacyRevision;
				prodRel.NSNNameInCustomerNetwork__c=pr.NSNNameInCustomerNetwork;
				prodRel.NSNOriginalOwnerGroup__c=pr.NSNOriginalOwnerGroup;
				prodRel.NSNParentClassification__c=pr.NSNParentClassification;
				prodRel.NSNPartner__c=pr.NSNPartner;
				prodRel.NSNReleaseProductManager__c=pr.NSNReleaseProductManager;
				prodRel.NSNSummary__c=pr.NSNSummary;
				prodRel.Obsolete__c=pr.Obsolete;
				prodRel.PDMModified__c=pr.PDMModified;
				prodRel.PDMTimestamp__c=pr.PDMTimestamp;
				prodRel.Rampdown__c=pr.Rampdown;
				prodRel.Rejected__c=pr.Rejected;
				prodRel.Relation_NSNMainProduct_Code__c=pr.Relation_NSNMainProduct_Code;
				prodRel.Relation_Products_Code__c=pr.Relation_Products_Code;
				prodRel.Relation_Status_NSNMainProducts__c=pr.Relation_Status_NSNMainProduct;
				prodRel.Relation_Status_Products__c=pr.Relation_Status_Products;
				prodRel.Release_ID__c=pr.Release_ID;
				prodRel.ReleaseStatus__c=pr.ReleaseStatus;
				prodRel.Type__c=pr.Type;
				prodRel.CH_Processed__c=false;
				
				if(!NsnCodeSET.contains(prodRel.NSNCode__c))
				{
					ReleasesList.add(prodRel);
					NsnCodeSET.add(prodRel.NSNCode__c);
				}
			}
		}
		
		
		List<Database.UpsertResult> results_pr = Database.upsert(ReleasesList,ProductRelease__c.NSNCode__c,false);
		//// Callout Interface Logs////
		//string prod_code_str = string.join(sample,', '); 
		Interface_Log__c ilog_callout = new Interface_Log__c();
		ilog_callout.Interface_Type__c = 'EDP Release Stage';
		ilog_callout.Message_Type__c = 'Inbound';
		ilog_callout.Operation_Type__c = 'Insert';
		//ilog_callout.Status__c = 'Success';
		// ilog_callout.Name = 'Product Release Rest Callout';
		
		if(response1.getStatuscode() ==200){
			ilog_callout.Interface_Request_Sent__c = 'Request URL: '+Queries[0]+ '\n'+
				'Response: '+response1.getStatus()+'\n'+
				'Response Code'+response1.getStatuscode();	 
			ilog_callout.Status__c = 'Success';
			ilog_callout.Name = 'Product Releases Class Rest Callout success';
		} 
		else {
			ilog_callout.Interface_Request_Sent__c = 'Request URL: '+Queries[0]+ '\n'+
				'Response: '+response1.getStatus()+'\n'+
				'Response Code'+response1.getStatuscode();
			ilog_callout.Status__c = 'Failure';
			ilog_callout.Name = 'Product Releases Class Rest Callout Failed';
		}
		ilogs.add(ilog_callout);
		
		////Product Release Interface Logs////
		for(Integer index = 0, size = results_pr.size(); index < size; index++) {
			String Operationtype= results_pr[index].isCreated()?'Insert':'Update';
			
			if(!results_pr[index].isSuccess()) { 
				////PR Error Interface Logs///
				Interface_Log__c ilog_pr = new Interface_Log__c();
				for (Database.Error err : results_pr[index].getErrors()){
					ilog_pr.comment__c = 'Fields: '+err.getFields()+'Message: '+err.getMessage()+
						'Status Code: '+err.getStatusCode();
				}
				
				//ilog_pr.comment__c = results_pci[index].getMessage();
				ilog_pr.Interface_Type__c = 'EDP Release Stage';
				ilog_pr.Message_Type__c = 'Inbound';
				ilog_pr.Operation_Type__c = Operationtype;
				ilog_pr.Status__c = 'Failure';
				ilog_pr.Interface_Request_Sent__c = 'Request URL: '+path+ '\n'+
					'NSNCode: '+ ReleasesList[index].NSNCode__c +'\n'+
					'Type: '+ ReleasesList[index].Type__c +'\n'+
					'Description: '+ ReleasesList[index].Description__c +'\n'+
					'LifeCycleStatus: '+ ReleasesList[index].Lifecyclestatus__c +'\n'+
					'EDP_LastModifiedDate: '+ ReleasesList[index].EDP_LastModifiedDate__c;
				ilog_pr.Name = 'Product Release '+Operationtype+' Failure with NSNCode: '+ ReleasesList[index].NSNCode__c;
				ilogs.add(ilog_pr);
				
				//system.debug('Failure is:'+ilog_pr.Interface_Request_Sent__c );
				
			}
			else{ 
				////PR Success Interface Logs///
				Interface_Log__c ilog_pr = new Interface_Log__c();
				ilog_pr.comment__c = 'Success';
				ilog_pr.Interface_Type__c = 'EDP Release Stage';
				ilog_pr.Message_Type__c = 'Inbound';
				ilog_pr.Operation_Type__c = Operationtype;
				ilog_pr.Status__c = 'Success';
				ilog_pr.Interface_Request_Sent__c = 'Request URL: '+path+ '\n'+
					'NSNCode: '+ReleasesList[index].NSNCode__c +'\n'+
					'Type: '+ReleasesList[index].Type__c +'\n'+
					'Description: '+ReleasesList[index].Description__c +'\n'+
					'LifeCycleStatus: '+ReleasesList[index].Lifecyclestatus__c +'\n'+
					'EDP_LastModifiedDate: '+ReleasesList[index].EDP_LastModifiedDate__c;
				ilog_pr.Name = 'Product Release  '+Operationtype+ ' Success with NSNcode: '+ReleasesList[index].NSNCode__c;
				ilogs.add(ilog_pr);
				//system.debug('Success is:'+ilog_pr.Interface_Request_Sent__c);
				
			}	  
		}
		
		Database.Insert(Ilogs,false);  
		
	}  
	
	
	global void finish(Database.BatchableContext BC)
	{
		//System.debug('Finally....');
		// System.debug('Status is '+status);
		
		if(status==false){
			
			unschedule();
			rescheduleMethod();	 
		}
		else
		{
			clearcustomsetting();
			
		}
	}
	public class ProdRel{
		
		Public string Description;
		Public string Implement;
		Public string ItemID;
		Public string Lifecyclestatus;
		Public string NSNAliasName;
		Public string NSNCode;
		Public string NSNDesignResponsibility;
		Public string NSNLegacyCode;
		Public string NSNLegacyNcmCode;
		Public string NSNLegacyRevision;
		Public string NSNNameInCustomerNetwork;
		Public string NSNOriginalOwnerGroup;
		Public string NSNParentClassification;
		Public string NSNPartner;
		Public string NSNReleaseProductManager;
		Public string NSNSummary;
		Public string Rampdown;
		Public string Rejected;
		Public string Relation_NSNMainProduct_Code;
		Public string Relation_Products_Code;
		Public string Release_ID;
		Public string ReleaseStatus;
		Public string Type;
		Public boolean Relation_Status_Products;
		Public boolean Relation_Status_NSNMainProduct;
		Public boolean EDP_ActiveStatus;
		Public DateTime PDMTimestamp;
		Public DateTime PDMModified;
		Public DateTime Obsolete;
		Public DateTime LastUpdate;
		Public DateTime EDP_LastModifiedDate;
		Public DateTime Maintain;
		Public DateTime C1ReadyForProgram;
		Public DateTime C2ReadyForMarketing;
		Public DateTime C3ReadyForOffering;
		Public DateTime C4ReadyForOrdering;
		Public DateTime C5ReleaseAvailable;
		Public DateTime C6ReadyForRampdown;
		Public DateTime C7EndOfMarketing;
		Public DateTime C8EndOfOrdering;
		Public DateTime C9EndOfDeliveries;
	} 
	
	public void calloutmethod(){
		//check if there are 5 active batch jobs
		integer count = [SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND status in ('Processing','Preparing','Queued')];
		if (count < 5)
		{ 
			Batch_ProductReleaseCls batch= new Batch_ProductReleaseCls();
			Database.executebatch(batch,1); 
			//system.debug('Success!!!');
		} 
		else {
			//schedule this same schedulable class again in 60 mins
			//unscheduleMe();	 
			Batch_ProductReleaseCls  prsch= new Batch_ProductReleaseCls();
			Datetime dt = Datetime.now().addMinutes(60);  // i.e. 60 mins
			String timeForScheduler = dt.format('s m H * * \'?\' *');
			system.schedule('PostSch-ReleaseSchedule',timeForScheduler, prsch);
			//system.abortJob(pcsch.Id);
			
			
			//Add 25 hrs to custom setting modified date time		 
			List<EDP_CH_Settings__c> edpEntryList = [Select Id,Name,ModifiedDate__c from EDP_CH_Settings__c Where Name='ProductReleases'];
			// system.debug('It is: '+edpEntryList);
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
		Batch_ProductReleaseCls pcsch= new Batch_ProductReleaseCls();
		Datetime dt = Datetime.now().addMinutes(60);  // i.e. 60 mins
		String timeForScheduler = dt.format('s m H * * \'?\' *');
		system.schedule(JOB_NAME,timeForScheduler, pcsch);
		
		
		//Add 25 hrs to custom setting modified date time		 
		List<EDP_CH_Settings__c> edpEntryList = [Select Id,Name,ModifiedDate__c from EDP_CH_Settings__c Where Name='ProductReleases'];
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
		EDP_CH_Settings__c  pcEntry = EDP_CH_Settings__c.getInstance('ProductReleases'); 
		pcEntry.ModifiedDate__c = null;
		pcEntry.Full_Load_Filter__c= '';  
		pcEntry.Full_Load__c = false;
		update pcEntry;
	}
}