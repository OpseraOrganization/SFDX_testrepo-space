/****************************************
* Name  : Batch_DesignElement
* Description : Loads data to staging object
* Author	: Accenture
*****************************************/ 
global without sharing class Batch_DesignElement implements Database.Batchable<String>,Database.AllowsCallouts,Database.Stateful,Schedulable {
	
	public String token;
	public static integer count;
	public String url='';
	private boolean status = true;
	
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
		// System.debug('Inside count function:');
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
				//system.debug('Request :'+request);
				
				
				HttpResponse response1 = http1.send(request);

				JSONParser jsonparser = JSON.createParser(response1.getBody());
				while (jsonparser.nextToken() != System.JSONToken.END_OBJECT) {
					if (jsonparser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
						String text = jsonparser.getText();
						if (jsonparser.nextToken() != System.JSONToken.VALUE_NULL && text=='@odata.count') {
							count = jsonparser.getIntegerValue();
							// System.debug(jsonparser.getText());
							
							// System.debug('count is'+count);
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
				//System.debug('Attempting to read again with token: '+token);
				count = getCountofRecords(Query);
				system.debug('Count is: '+count);
				return count;	 
			}
			else
				return 0;
		}	  
	}
	
	global Iterable<String> start(Database.BatchableContext BC){
		token=getToken();
		url = EDP_URLs__c.getInstance('PDEI').URL__c;
		List<String> QueryList = new List<String>(); 
		String Query1 =url;
		
		EDP_CH_Settings__c  pcEntry = EDP_CH_Settings__c.getInstance('ProductDesignElements'); 
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
			System.debug('Exception occured during retreiving response for query:'+path+'Exception: '+ex);
			if(ex.getMessage() == 'Read timed out' || Test.isrunningtest()){
				System.debug('Attempting to read again because of read time out exception...');
				response1 = http1.send(request);
				
			}
		}
		
		if(response1.getStatusCode() != 200){
			System.debug('Error: '+response1.getBody());
		}
		
		List<DesignElement_Items__c> DEIList = new List<DesignElement_Items__c>();
		Set<String> NsnCodeSET= new Set<String>(); 
		
		if(response1.getStatusCode() == 200){
			
			//   System.debug(response1.getBody());
			List<DesignElement> de = (List<DesignElement>)System.JSON.deserialize(response1.getBody().substring(response1.getBody().indexOf('['), response1.getBody().lastIndexOf(']')+1), List<DesignElement>.class);
			
			
			for(DesignElement d: de)
			{
				DesignElement_Items__c DEI=new DesignElement_Items__c();
				DEI.Current__c=d.Current;
				if(d.Description != NULL){
					DEI.Description__c=d.Description;
				} else {
					DEI.Description__c = '#N/A';
				}				
				DEI.EDP_ActiveStatus__c=d.EDP_ActiveStatus;
				DEI.EDP_LastModifiedDate__c=d.EDP_LastModifiedDate;
				DEI.Modified__c=d.Modified;
				DEI.Notes__c=d.Notes;
				DEI.NSNAbbreviation__c=d.NSNAbbreviation;
				DEI.NSNAdditionalECCCheck__c=d.NSNAdditionalECCCheck;
				DEI.NSNAliasName__c=d.NSNAliasName;
				DEI.NSNAlternateCode__c=d.NSNAlternateCode;
				DEI.NSNAlternateCode2__c=d.NSNAlternateCode2;
				DEI.NSNAlternateCodeSpace__c=d.NSNAlternateCodeSpace;
				DEI.NSNAlternateCodeSpace2__c=d.NSNAlternateCodeSpace2;
				DEI.NSNApplicability__c=d.NSNApplicability;
				DEI.NSNApprovedOnBehalf__c=d.NSNApprovedOnBehalf;
				DEI.NSNApprovedOnBehalfDate__c=d.NSNApprovedOnBehalfDate;
				DEI.NSNClassification__c=d.NSNClassification;
				DEI.NSNCode__c=d.NSNCode;
				DEI.NSNCompaApprovalState__c=d.NSNCompaApprovalState;
				DEI.NSNCompatibilityPlanningResponsible__c=d.NSNCompatibilityPlanningResponsible;
				DEI.NSNContacts__c=d.NSNContacts;
				DEI.NSNDataUsage__c=d.NSNDataUsage;
				DEI.NSNDeliveryPackageType__c=d.NSNDeliveryPackageType;
				DEI.NSNDeliveryPriorityType__c=d.NSNDeliveryPriorityType;
				DEI.NSNDesignElementDataSpecialist__c=d.NSNDesignElementDataSpecialist;
				DEI.NSNDesignResponsibility__c=d.NSNDesignResponsibility;
				DEI.NSNEndofProductSupport__c=d.NSNEndofProductSupport;
				DEI.NSNEndofRemoteTechnicalService__c=d.NSNEndofRemoteTechnicalService;
				DEI.NSNEndofReturnforRepair__c=d.NSNEndofReturnforRepair;
				DEI.NSNEndofSWMaintenance__c=d.NSNEndofSWMaintenance;
				DEI.NSNItemUsage__c=d.NSNItemUsage;
				DEI.NSNLegacyCode__c=d.NSNLegacyCode;
				DEI.NSNLegacyNCMCode__c=d.NSNLegacyNCMCode;
				DEI.NSNLegacyRevision__c=d.NSNLegacyRevision;
				DEI.NSNModifiedInSendingSystem__c=d.NSNModifiedInSendingSystem;
				DEI.NSNNameInCustomerNetwork__c=d.NSNNameInCustomerNetwork;
				DEI.NSNOriginalOwnerGroup__c=d.NSNOriginalOwnerGroup;
				DEI.NSNOriginatedOnBehalf__c=d.NSNOriginatedOnBehalf;
				DEI.NSNOriginatingFromApplication__c=d.NSNOriginatingFromApplication;
				DEI.NSNParentClassification__c=d.NSNParentClassification;
				DEI.NSNParentOwnerOrganization__c=d.NSNParentOwnerOrganization;
				DEI.NSNParentProductCategory__c=d.NSNParentProductCategory;
				DEI.NSNParentReleaseModel__c=d.NSNParentReleaseModel;
				DEI.NSNParentTL9000__c=d.NSNParentTL9000;
				DEI.NSNPortfolioDataSpecialist__c=d.NSNPortfolioDataSpecialist;
				DEI.NSNPPVUse__c=d.NSNPPVUse;
				DEI.NSNProgramOrProjectManager__c=d.NSNProgramOrProjectManager;
				DEI.NSNReferences__c=d.NSNReferences;
				DEI.NSNSecurityUpdateType__c=d.NSNSecurityUpdateType;
				DEI.NSNSummary__c=d.NSNSummary;
				DEI.NSNSWConfigurationManager__c=d.NSNSWConfigurationManager;
				DEI.NSNSWMaintenanceManager__c=d.NSNSWMaintenanceManager;
				DEI.NSNUse__c=d.NSNUse;
				DEI.NSNUsedPlatform__c=d.NSNUsedPlatform;
				DEI.Originated__c=d.Originated;
				DEI.Policy__c=d.Policy;
				DEI.Revision__c=d.Revision;
				DEI.StateCommittedActual__c=d.StateCommittedActual;
				DEI.StateCommittedScheduled__c=d.StateCommittedScheduled;
				DEI.StateCreateActual__c=d.StateCreateActual;
				DEI.StateInitialActual__c=d.StateInitialActual;
				DEI.StateInitialScheduled__c=d.StateInitialScheduled;
				DEI.StateMaintainActual__c=d.StateMaintainActual;
				DEI.StateMaintainScheduled__c=d.StateMaintainScheduled;
				DEI.StateObsoleteActual__c=d.StateObsoleteActual;
				DEI.StateObsoleteScheduled__c=d.StateObsoleteScheduled;
				DEI.StatePlannedActual__c=d.StatePlannedActual;
				DEI.StatePlannedScheduled__c=d.StatePlannedScheduled;
				DEI.Type__c=d.Type;
				DEI.CH_Processed__c=false;
				if(!NsnCodeSET.contains(DEI.NSNCode__c))
				{
					DEIList.add(DEI);
					NsnCodeSET.add(DEI.NSNCode__c);
				}
			}
		}
		
		
		List<Database.UpsertResult> results_pr = Database.upsert(DEIList,DesignElement_Items__c.NSNCode__c,false);
		//// Callout Interface Logs////
		//string prod_code_str = string.join(sample,', '); 
		Interface_Log__c ilog_callout = new Interface_Log__c();
		ilog_callout.Interface_Type__c = 'EDP Design Element Stage';
		ilog_callout.Message_Type__c = 'Inbound';
		ilog_callout.Operation_Type__c = 'Insert';
		//ilog_callout.Status__c = 'Success';
		// ilog_callout.Name = 'Design Element Rest Callout';
		
		if(response1.getStatuscode() ==200){
			ilog_callout.Interface_Request_Sent__c = 'Request URL: '+Queries[0]+ '\n'+
				'Response: '+response1.getStatus()+'\n'+
				'Response Code'+response1.getStatuscode();				
			ilog_callout.Status__c = 'Success';
			ilog_callout.Name = 'Design Element Class Rest Callout success';
		} 
		else {
			ilog_callout.Interface_Request_Sent__c = 'Request URL: '+Queries[0]+ '\n'+
				'Response: '+response1.getStatus()+'\n'+
				'Response Code'+response1.getStatuscode();
			ilog_callout.Status__c = 'Failure';
			ilog_callout.Name = 'Design Element Class Rest Callout Failed';
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
				ilog_pr.Interface_Type__c = 'EDP Design Element Stage';
				ilog_pr.Message_Type__c = 'Inbound';
				ilog_pr.Operation_Type__c = Operationtype;
				ilog_pr.Status__c = 'Failure';
				ilog_pr.Interface_Request_Sent__c = 'Request URL: '+path+ '\n'+
					'NSNCode: '+ DEIList[index].NSNCode__c +'\n'+
					'Type: '+ DEIList[index].Type__c +'\n'+
					'Description: '+ DEIList[index].Description__c +'\n'+
					'NSNLegacyCode: '+ DEIList[index].NSNLegacyCode__c +'\n'+
					'EDP_LastModifiedDate: '+ DEIList[index].EDP_LastModifiedDate__c;
				ilog_pr.Name = 'Design Element '+Operationtype+' Failure with NSNCode: '+ DEIList[index].NSNCode__c;
				ilogs.add(ilog_pr);
				
				//system.debug('Failure is:'+ilog_pr.Interface_Request_Sent__c );
				
			}
			else{ 
				////PR Success Interface Logs///
				Interface_Log__c ilog_pr = new Interface_Log__c();
				ilog_pr.comment__c = 'Success';
				ilog_pr.Interface_Type__c = 'EDP Design Element Stage';
				ilog_pr.Message_Type__c = 'Inbound';
				ilog_pr.Operation_Type__c = Operationtype;
				ilog_pr.Status__c = 'Success';
				ilog_pr.Interface_Request_Sent__c = 'Request URL: '+path+ '\n'+
					'NSNCode: '+DEIList[index].NSNCode__c +'\n'+
					'Type: '+DEIList[index].Type__c +'\n'+
					'Description: '+DEIList[index].Description__c +'\n'+
					'NSNLegacyCode: '+DEIList[index].NSNLegacyCode__c +'\n'+
					'EDP_LastModifiedDate: '+DEIList[index].EDP_LastModifiedDate__c;
				ilog_pr.Name = 'Design Element  '+Operationtype+ ' Success with NSNcode: '+DEIList[index].NSNCode__c;
				ilogs.add(ilog_pr);
				//system.debug('Success is:'+ilog_pr.Interface_Request_Sent__c);
				
			}	  
		}
		
		Database.Insert(Ilogs,false);  
		
	}  
	
	
	global void finish(Database.BatchableContext BC)
	{
		// System.debug('Finally....');
		//  System.debug('Status is '+status);
		
		if(status==false){
			
			unscheduleMe();
			rescheduleMethod();	
		}
		else{
			clearcustomsetting();
		}
	}
	public class DesignElement{
		
		Public string Current;
		Public string Description;
		Public string EDP_ActiveStatus;
		Public string EDP_LastModifiedDate;
		Public string Modified;
		Public string Notes;
		Public string NSNAbbreviation;
		Public string NSNAdditionalECCCheck;
		Public string NSNAliasName;
		Public string NSNAlternateCode;
		Public string NSNAlternateCode2;
		Public string NSNAlternateCodeSpace;
		Public string NSNAlternateCodeSpace2;
		Public string NSNApplicability;
		Public string NSNApprovedOnBehalf;
		Public string NSNApprovedOnBehalfDate;
		Public string NSNClassification;
		Public string NSNCode;
		Public string NSNCompaApprovalState;
		Public string NSNCompatibilityPlanningResponsible;
		Public string NSNContacts;
		Public string NSNDataUsage;
		Public string NSNDeliveryPackageType;
		Public string NSNDeliveryPriorityType;
		Public string NSNDesignElementDataSpecialist;
		Public string NSNDesignResponsibility;
		Public string NSNEndofProductSupport;
		Public string NSNEndofRemoteTechnicalService;
		Public string NSNEndofReturnforRepair;
		Public string NSNEndofSWMaintenance;
		Public string NSNItemUsage;
		Public string NSNLegacyCode;
		Public string NSNLegacyNCMCode;
		Public string NSNLegacyRevision;
		Public string NSNModifiedInSendingSystem;
		Public string NSNNameInCustomerNetwork;
		Public string NSNOriginalOwnerGroup;
		Public string NSNOriginatedOnBehalf;
		Public string NSNOriginatingFromApplication;
		Public string NSNParentClassification;
		Public string NSNParentOwnerOrganization;
		Public string NSNParentProductCategory;
		Public string NSNParentReleaseModel;
		Public string NSNParentTL9000;
		Public string NSNPortfolioDataSpecialist;
		Public string NSNPPVUse;
		Public string NSNProgramOrProjectManager;
		Public string NSNReferences;
		Public string NSNSecurityUpdateType;
		Public string NSNSummary;
		Public string NSNSWConfigurationManager;
		Public string NSNSWMaintenanceManager;
		Public string NSNUse;
		Public string NSNUsedPlatform;
		Public string Originated;
		Public string Policy;
		Public string Revision;
		Public string StateCommittedActual;
		Public string StateCommittedScheduled;
		Public string StateCreateActual;
		Public string StateInitialActual;
		Public string StateInitialScheduled;
		Public string StateMaintainActual;
		Public string StateMaintainScheduled;
		Public string StateObsoleteActual;
		Public string StateObsoleteScheduled;
		Public string StatePlannedActual;
		Public string StatePlannedScheduled;
		Public string Type;
		
	}
	public void calloutmethod(){
		//check if there are 5 active batch jobs
		integer count = [SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND status in ('Processing','Preparing','Queued')];
		if (count < 5)
		{ 
			Batch_DesignElement batch= new Batch_DesignElement();
			Database.executebatch(batch,1); 
			//system.debug('Success!!!');
		} 
		else {
			//schedule this same schedulable class again in 60 mins
			//unscheduleMe();		
			Batch_DesignElement  prsch= new Batch_DesignElement();
			Datetime dt = Datetime.now().addMinutes(60);  // i.e. 60 mins
			String timeForScheduler = dt.format('s m H * * \'?\' *');
			system.schedule('Design Element ReSchedule',timeForScheduler, prsch);
			//system.abortJob(pcsch.Id);
			
			
			//Add 25 hrs to custom setting modified date time	  
			List<EDP_CH_Settings__c> edpEntryList = [Select Id,Name,ModifiedDate__c from EDP_CH_Settings__c Where Name='ProductDesignElements'];
			//  system.debug('It is: '+edpEntryList);
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
		
		for ( CronJobDetail ct : [SELECT Id,JobType,Name FROM CronJobDetail WHERE Name like 'ProductDesignElements%'] ) {
			System.abortJob(ct.Id);
		}
		
	}
	public void rescheduleMethod(){
		Batch_DesignElement  pcsch= new Batch_DesignElement();
		Datetime dt = Datetime.now().addMinutes(60);  // i.e. 60 mins
		String timeForScheduler = dt.format('s m H * * \'?\' *');
		system.schedule('Design Element ReSchedule',timeForScheduler, pcsch);
		
		
		//Add 25 hrs to custom setting modified date time	  
		List<EDP_CH_Settings__c> edpEntryList = [Select Id,Name,ModifiedDate__c from EDP_CH_Settings__c Where Name='ProductDesignElements'];
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
		EDP_CH_Settings__c  pcEntry = EDP_CH_Settings__c.getInstance('ProductDesignElements'); 
		pcEntry.ModifiedDate__c = null;
		pcEntry.Full_Load_Filter__c= '';  
		pcEntry.Full_Load__c = false;
		update pcEntry;
	}  
}