/*****************************************************************
Description:	Service request to Submit the Json created by HWS_CreateSRRequest class to SOO 
History								 
DATE		AUTHOR  CHANGE
11/11/2018  Shiv Maila	Created
12/18/2018  Vinod Ch		Updated 
1/24/2018   Nikita Jain  Updated
*****************************************************************/
Public without sharing class HWS_SendServiceRequesttoSOO_SVC {
	//Public  HWS_SendServiceRequesttoSOO_SVC(){}
	//@AuraEnabled
	//Public Boolean isSenttoSOO; 
	/*****************************************************************
	Description: Future method callout to submit parent case to SOO
	Parameters: ParentCaseId
	Returns: NA
	Throws [Exceptions]: [optional]			 
	History					 
	DATE		AUTHOR  CHANGE
	11/11/2018  Shiv Maila	Created
	12/18/2018  Vinod Ch		Updated 
	*****************************************************************/

	//34122 
	@AuraEnabled
	Public Static processResponse sendToSOO(Id parentCaseId,String condition)
	{ 
		ProcessResponse pr=new ProcessResponse();
		HWS_CreateSRRequest objSR = new HWS_CreateSRRequest();
		HWS_CreateSRRequest.SOORequestBody createSRJSON =objSR.createSRRequest(parentCaseId,condition); 
		HTTP http; 
		HTTPResponse response; 
		HTTPRequest request ;
		String stCaseNumber=createSRJSON.caseNumber;
		try{ 
			String caseNumber;
			request = new HTTPRequest();
			request.setEndpoint('callout:IPASS_LOGIN');
			System.debug('Json created ===='+createSRJSON);
			request.setHeader('Content-Type','application/json');
			request.setbody(createSRJSON.jsonPayload);
		
			request.setMethod('POST');
			request.setTimeout(120000);//NOKIASC-35423 timeout error fix
			http = new HTTP();
			response =http.send(request);
			System.debug('Code**'+response.getStatus());
			Case parentCase = new Case(id=parentCaseId);
	
			if(response.getStatusCode()==200){
	System.debug('**Body**'+response.getBody());
	pr = (ProcessResponse)JSon.deserialize(response.getBody(),ProcessResponse.class);
	pr.isError=false;
	pr.statusCode=response.getStatusCode();
	pr.message=response.getStatus();
	System.debug('response status'+pr.Status);
			}else{
	
	pr.isError=true;
	pr.SOORequestID=null;
	pr.statusCode=response.getStatusCode();
	pr.message=response.getStatus();  
	createOutboundErrorLog(pr,parentCaseId,null,stCaseNumber);
			}
			
			
		}catch(exception ex){
			pr.isError=true;
			pr.SOORequestID=null;
			pr.statusCode=null;
			pr.message=ex.getMessage();
			System.debug('Exception ===== '+ex.getMessage());
			createOutboundErrorLog(pr,parentCaseId,null,stCaseNumber); 
			
		}
		return pr;
	}
	
	//NOKIASC-34752 
	@AuraEnabled
	Public Static processResponse sendBulkToSOO(Id parentCaseId)
	{ 
		ProcessResponse pr = new ProcessResponse();
		HWS_CreateSRRequest objSR = new HWS_CreateSRRequest();
		HWS_CreateSRRequest.SOORequestBody createSRJSON = objSR.createBulkSRRequest(parentCaseId);  
		HTTP http; 
		HTTPResponse response; 
		HTTPRequest request;
		String stCaseNumber = createSRJSON.caseNumber;
		try { 
			String caseNumber;
			request = new HTTPRequest();
			request.setEndpoint('callout:IPAAS_WARRANTY_CHECK');
			System.debug('Json created ===='+createSRJSON);
			request.setHeader('Content-Type','application/json');
			request.setbody(createSRJSON.jsonPayload);
	
			request.setMethod('POST');
			request.setTimeout(12000);
			http = new HTTP();
			response =http.send(request);
			System.debug('Code**'+response.getStatus());
			Case parentCase = new Case(id=parentCaseId);
			
			if(response.getStatusCode()==200){
	System.debug('**Body**'+response.getBody());
	pr = (ProcessResponse)JSon.deserialize(response.getBody(),ProcessResponse.class);
	pr.isError=false;
	pr.statusCode=response.getStatusCode();
	pr.message=response.getStatus();
	System.debug('response status'+pr.Status);
				updateIsErrorFlagonSuccess(String.valueOf(parentCaseId));
			} else {	
	pr.isError=true;
	pr.SOORequestID=null;
	pr.statusCode=response.getStatusCode();
	pr.message=response.getStatus();  
	createOutboundErrorLogBulk(pr,parentCaseId,null,stCaseNumber);
			}
		} catch(exception ex) {
			pr.isError=true;
			pr.SOORequestID=null;
			pr.statusCode=null;
			pr.message=ex.getMessage();
			System.debug('Exception ===== '+ex.getMessage());
			createOutboundErrorLogBulk(pr,parentCaseId,null,stCaseNumber);
		}
		return pr;
	}
	
	//Method used to log the inbound response errors
	Public Static void createOutboundErrorLog(ProcessResponse response,Id caseId,Integer resStatusCode,String caseNumber){
		
		try{
			Interface_log__c ilogCallout = new Interface_log__c();
			ilogCallout.Name='CaseNumber ' + caseNumber;
			ilogCallout.Interface_Type__c = 'SOO';
			ilogCallout.Message_Type__c = 'Outbound';
			ilogCallout.Status__c ='Failure';
			ilogCallout.Comment__c=response.message;	
			Database.insert(ilogCallout);
			
		}
		catch(exception ex){
			System.debug('Exception***'+ex.getMessage());
			
		}
	}
	
	Public Static void createOutboundErrorLogBulk(ProcessResponse response,Id caseId,Integer resStatusCode,String caseNumber){
	try{
		Interface_log__c ilogCallout = new Interface_log__c();
		ilogCallout.Name='CaseNumber ' + caseNumber;
		ilogCallout.Interface_Type__c = 'SOO';
		ilogCallout.Message_Type__c = 'Outbound';
		ilogCallout.Status__c ='Failure';
		ilogCallout.Comment__c=response.message;
		Database.insert(ilogCallout);
		// Update case for failure
		case failedCase = new case();
		failedCase.Id = caseId;
	   failedCase.HWS_ErrorReason__c ='BulkWarrantyCheckFailed';
		failedCase.CH_InternalStatus__c='Warranty Verification Required';
		update failedCase;
		List<case> updateCaseList = new List<case>();
		// Update all child case
		for (case childCase :[SELECT Id,CH_EntitlementStatus__c,CH_EntitlementException__c,Status FROM Case WHERE parentId =:caseId]) {
		childCase.CH_EntitlementStatus__c='Pending Warranty Verification';
		childCase.CH_EntitlementException__c='Warranty Status Check Failed';
		childCase.Status='On Hold';
		updateCaseList.add(childCase);
		}
		if( !updateCaseList.isEmpty()){
		update updateCaseList;
		}
	}
	catch(exception ex){
		System.debug('Exception***'+ex.getMessage());
	}
	}
	
	//Method used to log the callout failure errors
	Public Static void createCalloutErrorLog(String failureInfo){
		InterfaceComms__c logCalloutFailure = new InterfaceComms__c();
		logCalloutFailure.Failure_Details__c=failureInfo;
		Database.insert(logCalloutFailure,false);	   
	}
	
	public static void updateIsErrorFlagonSuccess (Id parentCaseId) {
		List<case> caseList = new List<case>();
		for (case cas : [SELECT Id, HWS_ErrorReason__c,HWS_Sent_To_SOO__c FROM Case WHERE Id =:parentCaseId AND HWS_ErrorReason__c = 'BulkWarrantyCheckFailed']) {
			case sucesscase = new case();
			sucesscase.Id = cas.Id;
			sucesscase.HWS_ErrorReason__c = 'false';
			//sucesscase.HWS_Sent_To_SOO__c=true;
			caseList.add(sucesscase);
		}
		if (!caseList.isEmpty()) {
			update caseList;	
		}
	}
	
	
	Public class ProcessResponse{
		@AuraEnabled Public String message;
		@AuraEnabled Public Integer statusCode;
		@AuraEnabled Public String SOORequestID;
		@AuraEnabled Public Boolean isError;
		@AuraEnabled Public String Status;
		
		public ProcessResponse(){
			message='';
			isError=false;
			
		}
	}
}