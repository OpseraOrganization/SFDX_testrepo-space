/***********************************************
*	Class Name : InterfaceLogHandler
*	Created By : Accenture IDC
*	Created Date :2/Dec/2016
*	Description : Handler class for Interface log creation.
*	Requirement : 
*********************************************/
public class InterfaceLogHandler{
	/*Method Name: interfaceTransactionHandler
	*Purpose: helper method to log interface transaction detail.
	*/
	public static void interfaceTransactionHandler(String interfaceType, String messageType, 
		String operationType, String name, String status, String errorMessage) {
		Map<String, Interface_Log__c> iLogIdAndiLogMap = new Map<String, Interface_Log__c>();
		DateTime currentTime = System.now();
		for(Interface_Log__c iLog : [Select Id, Name from Interface_Log__c where Name = : name AND Interface_Type__c = : interfaceType AND LastModifiedDate =: currentTime LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]){
			iLogIdAndiLogMap.put(iLog.Name, iLog);		  
		}
		//Create the Interface log record
		Interface_Log__c iLog = new Interface_Log__c();
		if(iLogIdAndiLogMap.containsKey(name)){
			iLog.Id = iLogIdAndiLogMap.get(name).Id;
			iLog.Name = name;
		} else {
			iLog.Name = name;
		}  
		iLog.Interface_Type__c = interfaceType;
		iLog.Message_Type__c = messageType;   
		iLog.Operation_type__c = operationType;
		iLog.Status__c = status; 
		if(errorMessage != '' && errorMessage.length()>255){
			iLog.Comment__c = errorMessage.subString(0, 254);
		}else{
			iLog.Comment__c = errorMessage;
		}
		//iLog.Interface_Request_Sent__c = interfaceRequestSent;
		//upsert the log record 
		system.debug('iLog'+iLog);
		upsert iLog Id;
		
		//iterate and setup detail error logs
		Interface_Record_Detail_Log__c recordLogDetail = new Interface_Record_Detail_Log__c();
		//if(status == 'Failure' && errorMessage != 'No errors'){
		if(status.equalsIgnoreCase(GlobalConstants.FAILURE) && !errorMessage.equals(GlobalConstants.NO_ERRORS)){
			if(errorMessage.length()>255){
				recordLogDetail.Error_Message__c = errorMessage.subString(0, 254);
			}else{
				recordLogDetail.Error_Message__c = errorMessage;
			}
			recordLogDetail.Object_Name__c = GlobalConstants.OBJECT_ACCOUNT;
			recordLogDetail.name = name;
			recordLogDetail.Interface_Log__c = iLog.Id;
			system.debug('recordLogDetail'+recordLogDetail);
			insert recordLogDetail;
		}
	}	  
}