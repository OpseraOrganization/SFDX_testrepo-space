public class CMDPack4Callout implements Queueable,Database.AllowsCallouts {
	
	
	public void execute(QueueableContext context) {
	  CMDPack4__mdt cmd = [select Client_Id__c,Client_Secret__c,Login_Endpoint__c,Request_Endpoint__c,Grant_Type__c,Method_Type__c,Login_Content_type__c,Content_type__c
		from CMDPack4__mdt where DeveloperName =: 'CMDPack4'];
		system.debug(cmd);
		CMDPack4Callout.stubHandler(IpaasAuthenticationHandler.authenticate(cmd),cmd);
	} 
	
	public static Map<String,list<Sales_Role_Audit__c>> dataManipulation(){
		List<Sales_Role_Audit__c> auditList;
		auditList = [SELECT BG__c,Hierarchy_Id__c,Id,Is_Processed__c,Operation_Type__c,OwnerId,Role_Code__c,Role_End_Date__c,Role_Owner_ID__c,Role_Start_Date__c,User__c 
							FROM Sales_Role_Audit__c 
							WHERE Is_Processed__c = false
							order by createddate];
		 List<Sales_Role_Audit__c> auditList1;
		system.debug('list of records'+auditList);
		
		Map<String,list<Sales_Role_Audit__c>> auditRecordMap = new Map<String,List<Sales_Role_Audit__c>>();
		
		for(Sales_Role_Audit__c salesRoleAudit:auditList){
			auditList1 = auditRecordMap.get(salesRoleAudit.Hierarchy_Id__c);
			system.debug('auditList1 is'+auditList1);
			if(auditList1==null) {  
				system.debug('auditList1 is'+auditRecordMap);
				auditRecordMap.put(salesRoleAudit.Hierarchy_Id__c, new List<Sales_Role_Audit__c> {salesRoleAudit});
				system.debug('auditList1 is'+auditRecordMap);
			}else{
				system.debug('auditList1 is'+auditList1);
				auditList1.add(salesRoleAudit);
				auditRecordMap.put(salesRoleAudit.Hierarchy_Id__c, auditList1);
				system.debug('auditList1 is'+auditList1);
			}
		}			
		
		System.debug('map is'+auditRecordMap);
		return auditRecordMap;
		
	}
	
	public static void stubHandler(string accesstoken,CMDPack4__mdt cmd){
		nsnComCmdService.CMDOrgStrMaintenancePort stub = new nsnComCmdService.CMDOrgStrMaintenancePort();
		stub.timeout_x = 120000;
		list<nsnComCmdService.salesHierarchyRequest> requestList = new list<nsnComCmdService.salesHierarchyRequest>();
		Map<String,List<Sales_Role_Audit__c>>  unprocessedRecords = CMDPack4Callout.dataManipulation();
		
		for(String salesHierarchyID : unprocessedRecords.keySet()){
			nsnComCmdService.salesHierarchyRequest salesHierarchyRequest = new nsnComCmdService.salesHierarchyRequest();
			salesHierarchyRequest.SalesHierarchyID = salesHierarchyID;
			List<nsnComCmdService.rodRequest> rodReqList = new List<nsnComCmdService.rodRequest>();
			
			for(Sales_Role_Audit__c SRTAudit: unprocessedRecords.get(salesHierarchyID)){
				nsnComCmdService.rodRequest rodReq= new nsnComCmdService.rodRequest();
				rodReq.RoleCode = SRTAudit.Role_Code__c;
				rodReq.RoleOwnerNokiaID = SRTAudit.Role_Owner_ID__c;
				rodReq.RoleStartDate = SRTAudit.Role_Start_Date__c;
				//rodReq.RoleEndDate = SRTAudit.Role_End_Date__c;
				rodReq.RoleEndDate = Datetime.newInstance(9999,12,31);
				rodReq.BGAttribute = SRTAudit.BG__c;
				rodReq.OperationType = SRTAudit.Operation_Type__c;
				rodReqList.add(rodReq);
			}
			salesHierarchyRequest.roleOwnerDetails = rodReqList;  
			requestList.add(salesHierarchyRequest);
		}
		
		stub.inputHttpHeaders_x = new Map<String,String>();
		stub.inputHttpHeaders_x.put('Authorization', 'Bearer '+accesstoken); 
		stub.inputHttpHeaders_x.put('SOAPAction','"updateRoleOwnerDetails"');
		stub.inputHttpHeaders_x.put('Content-Type','text/xml');
		
		nsnComCmdService.response res = stub.updateRoleOwnerDetails(requestList,cmd);
		try{	
			System.debug('response....'+res);
			System.debug('response....'+res.response);
			System.debug('saleshierarch response....'+res.salesHierarhyResponse);
			System.debug('saleshierarch response status....'+res.salesHierarhyResponse[0].executionStatus);
			System.debug('SRT response....'+res.salesHierarhyResponse[0].roleOwnerDetailsResponse);
			System.debug('SRT response status....'+res.salesHierarhyResponse[0].roleOwnerDetailsResponse[0]);
		
			SRTAuditProcess.updateRepsonse(unprocessedRecords,res);
			SRTAuditProcess.insertInterfaceLog(res,unprocessedRecords,GlobalConstants.SUCCESS);
		}catch(Exception exc){
			SRTAuditProcess.insertInterfaceLog(res,unprocessedRecords,GlobalConstants.FAILURE);
		}
	}
	
	 public static void customCallout(string accesstoken,CMDPack4__mdt cmd){
		HttpRequest req = new HttpRequest();
		//req.setMethod('POST');
		req.setMethod(cmd.Method_Type__c);
		//req.setEndpoint('https://nok-ipaas-int-we-apm-01.azure-api.net/cmd-orgstr');
		req.setEndpoint(cmd.Request_Endpoint__c);
		 req.setHeader('Authorization', 'Bearer '+accesstoken); 
		req.setHeader('SOAPAction','"updateRoleOwnerDetails"');
		//req.setHeader('Content-Type','text/xml');
		req.setHeader('Content-Type',cmd.Content_type__c);
		req.setBodyDocument(CreateCMDPack4Request.createRequest(CMDPack4Callout.dataManipulation()));
		req.setTimeout(120000);
		
		Http http = new Http();
		HttpResponse res = http.send(req);
		system.debug('response...'+res);
		system.debug('response...'+res.getBody());
	 }
}