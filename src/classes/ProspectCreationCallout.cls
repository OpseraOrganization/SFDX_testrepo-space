/****************************************
 * Class Name : ProspectCreationCallout
 * Created Date: 28 September 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 28 September 2017
 * Description : Make callout to NAIP interface for prospect Creation and log the respone in Interface Log
 * Test Class: 
 *****************************************/
global class ProspectCreationCallout{
	/********************
	*Class Name: CalloutCustomException 
	*Description: Used to Create Custom Exception
	*******************/
	public class CalloutCustomException extends Exception {}
	
	/********************
	*Method Name: createbulkProspect
	*Parameter: AccountId List
	*Description: Used to make a callout to NAIP
	*******************/
	@future(callout=true)
	public static void createbulkProspect(List<String> acctIdList){
		try{
			if(acctIdList.size()>0){
	if(acctIdList.size()<=100){
		for(string accountId : acctIdList){
			ProspectCreationCallout.createProspect(accountId);
		}
	}else{
		throw new CalloutCustomException(GlobalConstants.CALLOUT_CUSTOM_EXCEPTION); 
	}
			}
		}catch(Exception exc){
			ExceptionHandler.addException(exc,GlobalConstants.PROSPECT_CREATION_CALLOUT ,GlobalConstants.CREATE_BULK_PROSPECT);
		}
	}
	
	/********************
	*Method Name: createProspect
	*Parameter: AccountId 
	*Description: Used to create and send request to NAIP
	*******************/
	public static void createProspect(String acctId)
	{ 
		Http http = new Http();
		HttpResponse res;
		String status;
		String description;
		CreateProspectCreateRequest cpcr = new CreateProspectCreateRequest(acctId);
		HttpRequest req = new HttpRequest();
		try{  
			
			system.debug('inside try...............!!!!');
			req.setMethod(GlobalConstants.POST);
			UseProspectCreationCertificate__c certificateUse = UseProspectCreationCertificate__c.getOrgDefaults();
			if(certificateUse.CertificateAllow__c)
			{
			req.setEndpoint(System.Label.ProspectCalloutEndpooint);
			req.setClientCertificateName(System.Label.ProspectCalloutCertificate);
			}
		else
			{
				req.setEndpoint('callout:Prospect_Creation_NAIP');
			}
			system.debug(certificateUse);
			system.debug(certificateUse.CertificateAllow__c);
			req.setHeader('Content-Type', 'text/xml');
			req.setBodyDocument(cpcr.createRequest());
			req.setTimeout(120000);
	
	 
			system.debug('just before callout');
			res = http.send(req);
			system.debug('response...'+res);
			system.debug('response body...'+res.getBody());
			
			
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
			system.debug('Request...'+req.getBody());
			ProspectCreationCallout.insertInterfaceLog(req,cpcr,status,description);
		}
	}
	
	/********************
	*Method Name: createProspect
	*Parameter: AccountId 
	*Description: Used to create a log to track the response
	*******************/
	private static void insertInterfaceLog(HttpRequest req,CreateProspectCreateRequest cpcr,String status,String description){
		
		Interface_Log__c interfaceLog = New Interface_Log__c();
		interfaceLog.Name = GlobalConstants.ACCOUNT_NUMBER +cpcr.accountName +GlobalConstants.HASH_SYMBOL+cpcr.SFDCID;
		/***************************************************************/
		interfaceLog.Message_Type__c = GlobalConstants.OUTBOUND;
		if(!String.isBlank(description)){
			interfaceLog.Status__c = status;
			interfaceLog.Comment__c = description;
		}
		interfaceLog.Operation_type__c = GlobalConstants.INSERT_VALUE; 
		interfaceLog.Interface_Request_Sent__c = cpcr.createRequest().toXmlString();
		interfaceLog.Interface_Type__c = GlobalConstants.PROSPECT_CREATION_INTERFACE;
		interfaceLog.Message_Type__c = GlobalConstants.OUTBOUND;  
		insert interfaceLog;
	}
	 
}