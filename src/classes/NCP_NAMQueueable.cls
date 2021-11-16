public class NCP_NAMQueueable implements Queueable, Database.AllowsCallouts {
	
	public Integer max;
	private Integer counter = 1;
	public ID caseId;
	
	public NCP_NAMQueueable(Id id){
		this.caseId = id;
	}
	public void execute(QueueableContext context){		 
		system.debug('### AES QueueableContext');
		NCP_NAMQueueable job = new NCP_NAMQueueable(caseId);
		List<Case> myCase = [Select CaseNumber,NCP_NAM_Entitlement_Requested__c,NCP_List_of_Requested_Available_Services__c,Issue_Reported_By__r.FederationIdentifier, Issue_Reported_By__r.NokiaUID__c from Case where Id =: caseId limit 1];
		if(!myCase.isEmpty()){
			
			NCP_IPaaSNamService_WS_DATA_SCHEMAS.UserRoleData urd = new NCP_IPaaSNamService_WS_DATA_SCHEMAS.UserRoleData();
			urd.FederationIdentifier = myCase[0].Issue_Reported_By__r.FederationIdentifier;
			urd.NokiaID = myCase[0].Issue_Reported_By__r.NokiaUID__c;
			urd.ServiceName = myCase[0].NCP_List_of_Requested_Available_Services__c;
			
			// Create the stub
			NCP_IPaaSNamService_WS_tempuriOrg.BasicHttpBinding_INamSyncService NAM = new NCP_IPaaSNamService_WS_tempuriOrg.BasicHttpBinding_INamSyncService();
									
			NAM.inputHttpHeaders_x = new Map<String, String>();
			NAM.inputHttpHeaders_x.put('SOAPAction', 'UpdateUserRole');
			NAM.inputHttpHeaders_x.put('Content-Type', 'text/xml');
						
			// Make the web service call
			
			try {
		NCP_IPaaSNamService_WS_tempuriOrg.UpdateUserRoleResponse_element response = NAM.UpdateUserRole(urd);
				system.debug('### response: ' + response.UpdateUserRoleResult);
				system.debug('### response: ' + response.UpdateUserRoleErrorMessage);				
				myCase[0].NCP_NAM_Entitlement_Requested__c = response.UpdateUserRoleResult;
				myCase[0].NCP_NAM_Entitlement_Requested_Err_Resp__c = response.UpdateUserRoleErrorMessage;
				system.debug('### '+urd);
				if(response.UpdateUserRoleResult == 'FAILED'){
					NCP_InterfaceLog.insertInterfaceLog('NAM Pre-Approval','Outbound','Update','NAM Integration','Partial Success (Race Conditions Occurred)',response.UpdateUserRoleErrorMessage,''+urd);
				}else{
					NCP_InterfaceLog.insertInterfaceLog('NAM Pre-Approval','Outbound','Update','NAM Integration',response.UpdateUserRoleResult,response.UpdateUserRoleErrorMessage,''+urd);
				}
				
				// Todo: Add integration log record 
			} catch (Exception e) {
				system.debug(': '  + e.getMessage());
				myCase[0].NCP_NAM_Entitlement_Requested__c = 'FAILED';
				myCase[0].NCP_NAM_Entitlement_Requested_Err_Resp__c = e.getMessage();
				NCP_InterfaceLog.insertInterfaceLog('NAM Pre-Approval','Outbound','Update','NAM Integration','Failure',e.getMessage(),''+urd);
				// Todo: Add integration log record 
			}
			update myCase;
			
		}
		job.max = max;
		job.counter = counter+1;
		if(max >= job.counter) {
			System.enqueueJob(job);	
		}
	}
}