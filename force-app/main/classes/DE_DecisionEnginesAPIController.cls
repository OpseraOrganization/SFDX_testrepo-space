public with sharing class DE_DecisionEnginesAPIController {

	public boolean DisplayPopup {get; set;}	
	public string documentVersionId {get; set;}
	public string AgreementId {get;set;}
	public string APIStatus {get;set;}

	public DE_DecisionEnginesAPIController() {
	   documentVersionId = apexpages.currentpage().getparameters().get('id'); 
		if(string.isBlank(DE_DataStorage.token)){
			DE_Token_Creation.acquire();
		}
		DisplayPopup = true;
		system.debug(' url test ');
	   
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setHeader('Content-Type','application/json;');
		request.setMethod('POST');
		//request.setEndpoint('https://cso.dev.decisionengines.ai/opsserver/process/ad821f45-d7a9-4da2-8a35-d2a69944a751/execute');
		//https://cso30.dev.decisionengines.ai/opsserver/process/ad821f45-d7a9-4da2-8a35-d2a69944a751/execute
		string deEndpoint = System.Label.DE_Process_endpoint;
		//string deEndpoint = 'https://40.dev.decisionengines.ai/opsserver/process/6349848e-aa3c-48b7-a738-d35f8e925e79/execute';
		//request.setEndpoint('https://cso30.dev.decisionengines.ai/opsserver/process/ad821f45-d7a9-4da2-8a35-d2a69944a751/execute');
		request.setEndpoint(deEndpoint);
		request.setHeader('Authorization', 'Bearer ' + DE_DataStorage.token);
		
		Apttus__DocumentVersion__c docu = [SELECT Id,DE_Submitting_User_To_DE__c,Apttus__View__c,Apttus__Title__c,Apttus__ReferenceId__c,Apttus__AgreementId__c FROM Apttus__DocumentVersion__c WHERE Id =: documentVersionId LIMIT 1];	   
		AgreementId = docu.Apttus__AgreementId__c;
		
		RequestBody reqBody = new RequestBody();
		input inp = new input();
		inp.documentId = documentVersionId;
		reqBody.input = inp;
		reqBody.userReferenceId = docu.Apttus__AgreementId__c;
		request.setHeader('Content-Length',String.valueof(JSON.serialize(reqBody).length()));
		
		request.setBody(JSON.serialize(reqBody));
		//request.setBody(bodyPayload);
		system.debug('***************JSON' + JSON.serialize(reqBody));
		
		HttpResponse response = http.send(request);
		Map<String, Object> m2 = (Map<String, Object>) JSON.deserializeUntyped(response.getbody()); 
		String workItemId = (String) m2.get('workItemId');
		
		system.debug('*********final*****' + response);
		APIStatus = ' Decision Engines API Response WorkItemId ' + workItemId;  
		
	} 
	//added on 13-10-21
	//@future
	public static void updateDocVersionRec() {
		try{
		string documentVersionId = apexpages.currentpage().getparameters().get('id');
		Apttus__DocumentVersion__c docu = [SELECT Id,DE_Submitting_User_To_DE__c from Apttus__DocumentVersion__c where Id=:documentVersionId];
		docu.DE_Submitting_User_To_DE__c = userinfo.getUserId();
		update docu;
		}
		catch (exception e)
		{
			system.debug('==>'+e.getStackTraceString());
		}
		}
	
	public PageReference ClosePopup() { 
		DisplayPopup = false;  
		PageReference ref = new PageReference('/lightning/r/Apttus__APTS_Agreement__c/'+ AgreementId + '/related/Apttus__DocumentVersions__r/view');
		
		ref.setRedirect(true);
		return ref;
	}
	
	public void ShowPopup() {	   
		DisplayPopup = true;   
	}
	
	public class RequestBody {
		public string  userReferenceId;
		public input input;
	}
	public class input {
		public string documentId;
	}
}