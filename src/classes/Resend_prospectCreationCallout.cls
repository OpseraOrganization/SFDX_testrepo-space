/****************************************
*By : SDC Adam
*E  : xin.2.zhang.ext@nokia.com
*D  : For a failed interface to resend, refer to class name: prospectCreationCallout
*
 *****************************************/
global class Resend_prospectCreationCallout{

	public class Resend_CalloutCustomException extends Exception {}
	
	/********************
	*Method Name: Resend_createbulkProspect
	*Parameter: AccountId List
	*Description: Used to make a callout to NAIP
	*******************/
	@future(callout=true)
	public static void Resend_createbulkProspect(List<String> acctIdList){
		List<Interface_Log__c> list_interfacelog = new List<Interface_Log__c>();
		try{
			if(acctIdList.size()>0){
	if(acctIdList.size()<=100){
		for(string accountId : acctIdList){
			Interface_Log__c lg = Resend_prospectCreationCallout.Resend_createProspect(accountId);
			list_interfacelog.add(lg);
		}
	}
			}
			if (list_interfacelog.size()>0) {
	insert list_interfacelog;
			}
		}catch(Exception exc){
			ExceptionHandler.addException(exc,GlobalConstants.PROSPECT_CREATION_CALLOUT ,GlobalConstants.CREATE_BULK_PROSPECT);
		}
	}
	
	/********************
	*Method Name: Resend_createProspect
	*Parameter: AccountId 
	*Description: Used to create and send request to NAIP
	*******************/
	public static Interface_Log__c Resend_createProspect(String acctId)
	{   
		CreateProspectCreateRequest cpcr = new CreateProspectCreateRequest(acctId);
		HttpRequest req = new HttpRequest();
		req.setMethod(GlobalConstants.POST);
		UseProspectCreationCertificate__c certificateUse = UseProspectCreationCertificate__c.getOrgDefaults();
		if(certificateUse.CertificateAllow__c){
			req.setEndpoint(System.Label.ProspectCalloutEndpooint);
			req.setClientCertificateName(System.Label.ProspectCalloutCertificate);
		}
		else
			{
				req.setEndpoint('callout:Prospect_Creation_NAIP');
			}
		req.setHeader('Content-Type', 'text/xml');
		req.setBodyDocument(cpcr.createRequest());
		req.setTimeout(120000);
			
		Http http = new Http();
		HttpResponse res;
		String status;

		String description;
		try{
			res = http.send(req);
			system.debug('response...'+res);
			if(res.getStatusCode()<204){
	status = GlobalConstants.SUCCESS;
			}else{
	status = GlobalConstants.FAILURE;
			}
			description = res + GlobalConstants.BLANK_VALUE;
		}catch (System.CalloutException e){
			status = GlobalConstants.FAILURE;
			description = e.getMessage();
			system.debug('e.getMessage():'+e.getMessage());
		}catch (System.Exception e){
			status = GlobalConstants.FAILURE;
			description = e.getMessage();
			System.debug('ERROR:' + e);
		}finally{ 
			Interface_Log__c interfaceLog = New Interface_Log__c();
			interfaceLog.Name = GlobalConstants.ACCOUNT_NUMBER +cpcr.accountName +GlobalConstants.HASH_SYMBOL+cpcr.SFDCID;
			/***************************************************************/
			interfaceLog.Message_Type__c = GlobalConstants.OUTBOUND;
			if(!String.isBlank(description)){
	interfaceLog.Status__c = status;
	interfaceLog.Comment__c =description;
			}
			interfaceLog.Operation_type__c = GlobalConstants.INSERT_VALUE; 
			interfaceLog.Interface_Request_Sent__c = cpcr.createRequest().toXmlString();
			interfaceLog.Interface_Type__c = 'Prospect Creation Interface';
			interfaceLog.Message_Type__c = GlobalConstants.OUTBOUND;
			interfaceLog.Comment__c ='Resend at '+System.now()+' '+interfaceLog.Comment__c;
			return interfaceLog;			
		}
		return null;
	}
		 
}