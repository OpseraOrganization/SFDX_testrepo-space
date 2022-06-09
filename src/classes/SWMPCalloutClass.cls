global class SWMPCalloutClass implements Queueable,Database.AllowsCallouts {
	
	private  ID recordId; 
	
	
	/******************************************************************************************************
Method Name : execute
parameter   : QueueableContext context
Created Date: 20th July 2018
Created by  : Accenture
Description : This method is Queueable Interface Standard method
*********************************************************************************************************/		   
	global void execute(QueueableContext context) {
		try{
			CallingRESTAPI();
		}catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_StagingObjParsing ,CSWXGlobalConstant.execute);
		}
	}
	
   /******************************************************************************************************
Method Name : cxmDPCreation
parameter   : 
Created Date: 20th July 2018
Created by  : Accenture
Description : This method is used to parse JSON Stored in Staging Object and create Digital Proposal and Line Item
*********************************************************************************************************/	  
	
	 public static HttpRequest httpRequestGenerator(String reqMethod, String endpoint, String accessToken, String reqBody){
		
		String authorizationHeader = 'Bearer ' +accessToken;
		HttpRequest httpRequest = new HttpRequest();
		httpRequest.setMethod(reqMethod);
		httpRequest.setTimeout(120000);
		httpRequest.setEndpoint(endpoint);
		httpRequest.setHeader('Authorization', authorizationHeader);
		httpRequest.setHeader('Content-Type', 'application/json;charset=UTF-8');
		httpRequest.setHeader('Accept', 'application/json;charset=UTF-8');
		httpRequest.setBody(reqBody);
		
		System.debug('httpRequest--->'+httpRequest);
		return httpRequest;
	}
	
	/********* Method to insert error/success message in interface log object during sfdc and eccenca Integration *********/
	public static void InsertInterfaceLogRecord(String Message_Type, String Interface_Type, String Status, String DS_Payload,String Operation_Type,Id dpId,String Comment){
		try{
			Interface_Log__c log = new Interface_Log__c();
					log.Message_Type__c =Message_Type;
					log.Interface_Type__c = Interface_Type;
					log.Status__c = Status;
					log.DS_Payload__c=DS_Payload;
					log.Operation_Type__c = Operation_Type;
					log.Digital_Proposal__c=dpId;
					log.Comment__c = Comment;
					
					insert log;
		 }
		 catch(Exception ex){
			  ExceptionHandler.addException(ex,CSWXGlobalConstant.SWMPCalloutClass ,CSWXGlobalConstant.InsertInterfaceLogRecord);
		 }
		   
	
	}
	
	
	/*********  method to call IPass API *************/
	public void CallingRESTAPI() 
	{
		String jsonString ;
		
		try{
			
			DS_Eccenca_Integration__c dsCS = DS_Eccenca_Integration__c.getValues(CSWXGlobalConstant.APIDetails);
			String response ='' ;
			String oAuthResponse ;
			string endPointURL = '';
			String accessToken = '';
			Map<String, Object> m = new  Map<String, Object> ();
			HttpRequest req = new HttpRequest();
			req.setMethod('POST');
			
			String baseUrl= dsCS.baseURL__c+'?'+'username='+dsCS.username__c+'&password='+dsCS.password__c+'&client_id='+dsCS.client_id__c+'&client_secret='+dsCS.client_secret__c+'&grant_type='+dsCS.grant_type__c ;
		   
			req.setHeader('Content-Length', '0');
			
			System.debug('baseUrl--->'+baseUrl);
		 
			req.setEndpoint(baseUrl);
		 
			String code  = dsCS.failure_code__c;
			
			List<String> errorCode = code.split(',');
					   
			Http h = new Http();
			System.debug('req--->'+req);
			System.debug('req body--->'+req.getBody());
			
			HTTPResponse res = h.send(req);
			
			System.debug('Body----> ' + res.getBody());
			System.debug('Status---> ' + res.getStatus());
			system.debug( ' dsCS.successcode__c -> ' + dsCS.successcode__c);
			
			if(String.valueOf(res.getStatusCode()) == dsCS.successcode__c){
			
				m = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
				
				accessToken = String.valueOf(m.get('access_token'));
				
				endPointURL = dsCS.endpointURL__c;
				System.debug('recordId--->'+recordId);
				jsonString =  DS_BusinessRulesCheck_Controller.getJsonFile(recordId);
				System.debug('jsonString --inside future->'+jsonString);
				System.debug('Status code ----->' + res.getStatusCode());
				system.debug( ' accessToken -> ' + accessToken);
				
				Http http = new Http();
				HttpRequest httpRequest = httpRequestGenerator('POST', endPointURL, accessToken,jsonString);
				System.debug('httpRequestinCall ---->'+httpRequest);
				HTTPResponse httpResponse = http.send(httpRequest);
				response = httpResponse.getBody();
				system.debug('httpResponse.getBody()--- ->'+httpResponse.getBody());
				system.debug('httpResponse--- ->'+httpResponse);
				System.debug('final status code --->' + httpResponse.getStatusCode());
				
					if(String.valueOf(httpResponse.getStatusCode())==dsCS.successcode__c){
					   String comment = 'Status code - '+ String.valueOf(httpResponse.getStatusCode());
					   InsertInterfaceLogRecord(CSWXGlobalConstant.Message_Type_Outbound,CSWXGlobalConstant.InterfaceType,CSWXGlobalConstant.Success,jsonString,CSWXGlobalConstant.Operation_Type_Update,recordId,comment);
					  
					}
					else if(errorCode.contains(String.valueOf(httpResponse.getStatusCode()))){
					
					   String comment;
					   if(httpResponse.getStatusCode()==500){
							
							 comment = 'Status code - ' + String.valueOf(httpResponse.getStatusCode())+' - '+ System.Label.DS_Eccenca_Connection_Error_Msg;
						}
						else{
							 comment = 'Status code - '+ String.valueOf(httpResponse.getStatusCode()) +' - '+ String.valueOf(httpResponse.getBody());
							
						}
						
					   InsertInterfaceLogRecord(CSWXGlobalConstant.Message_Type_Outbound,CSWXGlobalConstant.InterfaceType,CSWXGlobalConstant.Failure,jsonString,CSWXGlobalConstant.Operation_Type_Update,recordId,comment);
					}
					
					else
					{
						String comment = 'Status code - '+ String.valueOf(httpResponse.getStatusCode()) +' - '+ String.valueOf(httpResponse.getBody());
						InsertInterfaceLogRecord(CSWXGlobalConstant.Message_Type_Outbound,CSWXGlobalConstant.InterfaceType,CSWXGlobalConstant.Failure,jsonString,CSWXGlobalConstant.Operation_Type_Update,recordId,comment);
							  
					}
			  }
			 else{
				
				   String comment = 'Status code - '+ String.valueOf(res.getStatusCode()) +' - '+ String.valueOf(res.getBody());
				   InsertInterfaceLogRecord(CSWXGlobalConstant.Message_Type_Outbound,CSWXGlobalConstant.InterfaceType,CSWXGlobalConstant.Failure,jsonString,CSWXGlobalConstant.Operation_Type_Update,recordId,comment);
						 
			  }
			
			
		}catch(Exception ex){
			
			System.debug('ex--->'+ex);
			
			String comment = ex.getMessage();
			InsertInterfaceLogRecord(CSWXGlobalConstant.Message_Type_Outbound,CSWXGlobalConstant.InterfaceType,CSWXGlobalConstant.Failure,jsonString,CSWXGlobalConstant.Operation_Type_Update,recordId,comment);
			 ExceptionHandler.addException(ex,CSWXGlobalConstant.SWMPCalloutClass ,CSWXGlobalConstant.CallingRESTAPI);
		   
		}	   
		
		
	}
   
	/******************************************************************************************************
Method Name : DS_StagingObjParsing
parameter   : String jsonPayload,DS_Staging__c stagingObjRec,id AccountID
Created Date:
Created by  : 
Description : This method is used update DP on failure of 1st Business Rule
*********************************************************************************************************/
	public SWMPCalloutClass(id recordId) {
		
		this.recordId = recordId;
		
		
	}
}