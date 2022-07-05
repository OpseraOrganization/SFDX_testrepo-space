/** 
 * About 
 * ----- 
 * @Description : DML_CriticalErrorHandler.
 * @testClass	: DML_SObject_Test.
 * @project		: All. 
 * @changeLog 	: 
 *  Created  : 2021 05 31 – tiago.almeida@nokia.com
 * ----- 
**/
public class DML_CriticalErrorHandler {
	private static Set<String> sLogKeySet = null;
	//
	public DML_CriticalErrorHandler(Exception e, String operation, List<SObject> targetObjects){
		String errorMessage = e.getMessage();
		String errorTrace = e.getStackTraceString();
		String objectApiList = DML_Controller__c.getInstance().Object_API_Name__c;
		System.debug('###Exception from ' + targetObjects.get(0).getSObjectType() + ' ' + operation + ': ' + errorMessage);
		System.debug('###Exception Records: ' + targetObjects);
		System.debug('###Exception Stack Trace: ' + errorTrace);
		String errorMsgBody = 'Exception Report\nMessage: ' + errorMessage + '\n\nRecords: ' + targetObjects + '\n\nTrace:' +
	targetObjects.get(0).getSObjectType() + ' ' + operation + '\n' + errorTrace + '\n\nAt: ' + System.now();
		if(checkIfCritical(errorMessage) && errorTrace.indexOf('Class.DML_SObject_Batch') == -1) {
			if(objectApiList.contains(String.valueOf(targetObjects.get(0).getSObjectType()))){ //Log Error if Object type matches list of objects in Object_API_Name__c
	String triggerEvent = operation;
	String methodRunType = 'OTHERS';
	Quiddity q = System.Request.getCurrent().getQuiddity();
	if(allowedQuiddities.contains(q)){
		methodRunType = String.valueOf(q);
	}
	ErrorLog__c errlog = CH_ErrorLogUtils.createErrorLog(errorMsgBody,'',triggerEvent+'-'+methodRunType,'HWS-Service Quotation',targetObjects[0].Id);
	errlog.Application__c = 'Case Handling - HWS';
	DML_SObject.doInsert(errlog,true); //insert in without sharing
			}else{
	String chatterGroup = DML_Controller__c.getInstance().DML_LogGroup__c;
	List<CollaborationGroup> oCollaborationGroupList = DML_SObject.doQuery('SELECT Id FROM CollaborationGroup WHERE Name = "' + chatterGroup + '" LIMIT 1', true);
	if(oCollaborationGroupList.size() == 1) {
		DML_SObject.doInsert(new FeedItem(ParentId = oCollaborationGroupList.get(0).Id,Body = errorMsgBody), true, true);
	}
	else System.debug('###Exception from DML_CriticalErrorHandler: No chatter group "' + chatterGroup + '" to post message.');
			}
		}
		throw e;
	}
	public static List<Quiddity> allowedQuiddities = new List<Quiddity>{Quiddity.QUEUEABLE,Quiddity.BATCH_APEX,Quiddity.FUTURE};
	private Boolean checkIfCritical(String errorMessage) {
		if(sLogKeySet == null) { sLogKeySet = smartSplit(DML_Controller__c.getInstance().DML_LogKeys__c); }
		for(String logKey : sLogKeySet) {
			if(String.isNotBlank(logKey) && errorMessage.indexOf(logKey) != -1) {
	return true;
			}
		}
		return false;
	}
	
	private Set<String> smartSplit(String input) {
		if(String.isBlank(input)){ return new Set<String>(); }
		input = input.replaceAll(',',';').replaceAll('\\r?\\n|\\r','').replaceAll(';\\s',';');
		return (input.indexOf(';') != -1 ? new Set<String>(input.split(';')) : new Set<String>{input});
	}
}