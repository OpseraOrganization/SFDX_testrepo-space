/*****************************************************************
@description:	Service request to Submit the Json created by HWS_CancelSRRequest class to SOO 
History									
DATE		AUTHOR	CHANGE
12/04/2019	  Vinod T		 Created
*****************************************************************/
Public without sharing class HWS_CancelcaseSendSRtoSOO_SVC{	
	
	
	/****************************************
* Name : sendToSOO
* @description : Create this wrapper method to call all the existing sendToSOO method calling
* @param : parent CaseId, child caseId
* @return : processResponse
* By Afif Reja
* Created Date: 28 Oct 2020
* User story : NOKIASC-31236
*****************************************/
	@AuraEnabled
	Public Static processResponse sendToSOO(Id parentCaseId,Id childId)
	{ 
		
		String actionName='Cancel';
		//If DefaultRestCallout value is false then we will call from default API.If Value true then endpoint sould be SOO
		String SOOCallRequired='true';
		return CallingSOO(parentCaseId,childId,actionName,SOOCallRequired);
	}
	
	/****************************************
* Name : GetEscalationInstruction
* @description : This method is uesd get Escalation Instruction from SOO calout
* By Afif Reja
* Created Date: 28 Oct 2020
* User story : NOKIASC-31236
*****************************************/
	@AuraEnabled
	Public Static processResponse getEscalationInstruction(Id parentCaseId,Id childId,String actionName)
	{ 
		
		//If SOOCallRequired value is false then we will call from default API.If Value true then endpoint sould be SOO
		String SOOCallRequired=  System.Label.HWS_SOOCallRequired;
		return CallingSOO(parentCaseId,childId,actionName,SOOCallRequired);
	}   
	
	/*****************************************************************
@description: Future method callout to submit parent case to SOO
Parameters: ParentCaseId
Returns: NA
Throws [Exceptions]: [optional]				
History						
DATE			AUTHOR	CHANGE
12/04/2019	  Vinod T		 Created
29/10/2020	Afif		   NOKIASC-31236 change the method name .Also added extra parameter for Action
*****************************************************************/
	
	@AuraEnabled
	Public Static processResponse CallingSOO(Id parentCaseId,Id childId,String actionName,String SOOCallRequired)
	{ 
		ProcessResponse pr=new ProcessResponse();
		HWS_CancelCaseSRRequest objSR = new HWS_CancelCaseSRRequest();
		HWS_CancelCaseSRRequest.SOORequestBody createSRJSON =objSR.cancelSRRequest(parentCaseId,childId,actionName);	
		HTTP http; 
		HTTPResponse response; 
		HTTPRequest request ;
		String stCaseNumber=createSRJSON.caseNumber;
		try{ 
			//commenting unused variable - NOKIASC-32425
			//String caseNumber;
			request = new HTTPRequest();
			//NOKIASC-31236:If DefaultRestCallout value is false then we will call from default API.If Value true then endpoint sould be SOO
			if (actionName=='GetEscalationInstruction' && SOOCallRequired=='false'){
				request.setEndpoint('https://getescalationinstruction.free.beeceptor.com/GetEscalationInstruction');  
			}
			else{
				request.setEndpoint('callout:IPAAS_CANCEL_SR');
			}
						
			request.setHeader('Content-Type','application/json');
			request.setbody(createSRJSON.jsonPayload);			
			request.setMethod('POST');
			request.setTimeout(12000);
			http = new HTTP();
			response =http.send(request);			
			//commenting unused variable - NOKIASC-32425 
			//Case parentCase = new Case(id=parentCaseId);
			//parentCase.HWS_Sent_To_SOO__c =true;
			if(response.getStatusCode()==200){
				pr = (ProcessResponse)JSon.deserialize(response.getBody(),ProcessResponse.class);				
				pr.isError=false;
				pr.statusCode=response.getStatusCode();
				pr.message=response.getStatus();				
			}else{
				
				pr.isError=true;
				pr.SOORequestID=null;
				pr.statusCode=response.getStatusCode();
				pr.message=response.getStatus();  
				//NOKIASC-31236 :Set ErrorLog for GetEscalationInstruction Child Case
				if (actionName=='Cancel'){
					createOutboundErrorLog(pr,parentCaseId,null,stCaseNumber);
				}
				else {
					createOutboundErrorLog(pr,childId,null,stCaseNumber);
				}
			}
			
			
		}catch(exception ex){
			pr.isError=true;
			pr.SOORequestID=null;
			pr.statusCode=null;
			pr.message=ex.getMessage();
			System.debug(LoggingLevel.DEBUG,'Exception ===== '+ex.getMessage());
			//NOKIASC-31236 :Set ErrorLog for GetEscalationInstruction Child Case
			if (actionName=='Cancel'){
				createOutboundErrorLog(pr,parentCaseId,null,stCaseNumber); 
			}
			else {
				createOutboundErrorLog(pr,childId,null,stCaseNumber);
			}
			
		}
		return pr;
	}
	/*****************************************************************
@description: Method used to log the inbound response errors
@return : null
@param : response , CaseId, Response's status Code, Case number
************************/
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
			System.debug(LoggingLevel.DEBUG,'Exception***'+ex.getMessage());
			
		}
	}
	
	Public class ProcessResponse{
		@AuraEnabled Public String message;
		@AuraEnabled Public Integer statusCode;
		@AuraEnabled Public String SOORequestID;
		@AuraEnabled Public Boolean isError;
		@AuraEnabled Public String Status;
		//NOKIASC-31236 :To store EscalationInstruction value.
		@AuraEnabled Public String EscalationInstruction;
		@AuraEnabled Public String CaseNumber;
		
		public ProcessResponse(){
			message='';
			isError=false;
			
		}
	}
}