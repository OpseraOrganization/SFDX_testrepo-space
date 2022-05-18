public without sharing class NokiaCPQ_RealTimeTurboSync {
	
	public static void syncToTurbo(set<id> objIds, string objectAPI, string syncType) {
		try {
			String vfContent;
			Apttus_Proposal_Proposal__c turboData = Apttus_Proposal_Proposal__c.getInstance();
			HttpRequest req = new HttpRequest();
			if(syncType == 'elasticsearch') {
				req.setEndpoint(turboData.Elastic_Sync_API__c.removeEnd('/')+'/'+objectAPI);
			}
			else if(syncType == 'extensibility') {
				req.setEndpoint(turboData.Extensibility_Sync_API__c.removeEnd('/')+'/'+objectAPI);
			}
			PageReference sessionIdPage = Page.NokiaCPQ_GetSessionVF;
			if(!Test.isRunningTest()) {
				vfContent = sessionIdPage.getContent().toString();
			}
			else {
				vfContent = 'Start_Of_Session_IdcxmnxcdsfdEnd_Of_Session_Id';
			}
			Integer startPosition = vfContent.indexOf('Start_Of_Session_Id') + 'Start_Of_Session_Id'.length(),
			endPosition = vfContent.indexOf('End_Of_Session_Id');
			String sessionId1 = vfContent.substring(startPosition, endPosition);
			req.setHeader('Authorization', 'Bearer '+sessionId1);
			req.setMethod('POST');
			req.setTimeout(120000);
			req.setHeader('Content-Type', 'application/json');
			req.setBody(JSON.serialize(objIds));
			
			Http http = new Http();
			HTTPResponse res = http.send(req);
			if(res.getStatusCode() == 200) {
				updateRecords(objIds,objectAPI, 'Completed');
			}
			else {
				logException('NokiaCPQ_RealTimeTurboSync','syncToTurbo',JSON.serialize(res.getBody()),'API');
				updateRecords(objIds,objectAPI, 'Failed');
			}
		}
		catch(exception e) {
			logException('NokiaCPQ_RealTimeTurboSync','syncToTurbo',e.getMessage(),'API');
		}
	}
	
	public static void updateRecords(set<id> objIds,string objectAPI, string status) {
		list<sObject> sObjectList =new list<sObject>();
		for(Id objId : objIds) {
			sObject objectVar = objId.getSObjectType().newSObject(objId);
			objectVar.put('Sync_to_Turbo__c', status);
			sObjectList.add(objectVar);
		}
		if(!sObjectList.isEmpty()) {
			update sObjectList;
		}
	}
	
	public static void logException(string className, string methodName, string errorMessage, string runType) {
		ErrorLog__c errLog = new ErrorLog__c();
		errLog.ClassName__c = className;
		errLog.MethodName__c = methodName;
		errLog.ErrorMessage__c = errorMessage;
		errLog.MethodRunType__c = runType;
		insert errLog;
	}
}