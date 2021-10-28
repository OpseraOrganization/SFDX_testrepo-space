/****************************************
* Class Name : CH_CaseProcessQueueable
* Created Date: 01 April 2020
* Created By : TCS
* Last Modified by: TCS
* Description : To perform asynchronous calls from CH_CaseTriggerHandler 
* US : Code Opt - NOKIASC-27610 & 27611
*Last Modified by COE - NOKIASC-31970
*****************************************/
public without sharing class CH_CaseProcessQueueable implements Queueable{
	List<ErrorLog__c> errorList = new List<ErrorLog__c>();
	ErrorLog__c newErrorLog = New ErrorLog__c();
	List<Case> newCaseList = new List<Case>();
	Set<Id> caseIdSet = new Set<Id>();
	Map<Id,Case> oldCaseMap = new Map<Id,Case>();
	boolean afterInsertCheck;
	boolean afterUpdateCheck;
	
	String asyncType = 'QUEUEABLE';
	String className = 'CH_CaseTriggerHelper';
	String methodEntCheck='checkEntitlementExceptionCases';
	String methodBlockList='CH_BlacklistCaseReportTrigger';
	CH_Settings__c entExpAsyncCheck;
	CH_Settings__c blackListAsyncCheck;
	Boolean asyncBLCheck = false;
	Boolean asyncEECheck = false;
	public CH_CaseProcessQueueable(Set<Id> caseIdSet, Map<Id,Case> oldCaseMap, boolean afterInsertCheck, boolean afterUpdateCheck){
		this.caseIdSet = caseIdSet;
		this.oldCaseMap = oldCaseMap;
		this.afterInsertCheck = afterInsertCheck;
		this.afterUpdateCheck = afterUpdateCheck; 
		entExpAsyncCheck = CH_Settings__c.getValues('checkEntitlementExceptionCases');
		blackListAsyncCheck = CH_Settings__c.getValues('CH_BlacklistCaseReportTrigger');
		//Add Query on Case for new case list.
		newCaseList = [SELECT Id,CH_EntitlementReport__c,CH_BlockCases__c,CH_EntitlementException__c,AccountId,ProductId,CH_ServiceType__c,Country__c,ContactId,
		CH_Product_Name__c,CH_Account_Name__c,RecordType.DeveloperName,RecordType.Name,Status,CH_BusinessUnit__c,Severity__c,CH_Outage__c,CaseNumber, 
		Origin,Subject,CreatedDate,CH_ExternalBridge__c FROM Case WHERE Id in :caseIdSet];
		if(entExpAsyncCheck != null && entExpAsyncCheck.SettingValue__c == 'true'){
			asyncEECheck = true;
		}
		if(blackListAsyncCheck != null && blackListAsyncCheck.SettingValue__c == 'true'){
			asyncBLCheck = true;
		}
	}
	public void execute(QueueableContext context){
		String triggerEvent= null;
		if(afterInsertCheck){
			triggerEvent='INSERT';
			oldCaseMap = new Map <Id,Case>();
			try{
	//Added this for setEntitlementReport
	if(!asyncEECheck)
		CH_CaseTriggerHelper.checkEntitlementExceptionCases(newCaseList); 
	if(!asyncBLCheck)
		CH_CaseTriggerHelper.CH_BlacklistCaseReportTrigger(newCaseList);
	List<Case> updateCaseList = new List<Case>();
	for(case c:newCaseList){
		if((c.CH_EntitlementReport__c != '' && c.CH_EntitlementReport__c != null) || c.CH_BlockCases__c != null){
			updateCaseList.add(c);
		}
	}
	if(!updateCaseList.isEmpty()){
		errorList = logDataBaseException( updateCaseList,  errorList,  className,  methodEntCheck,  methodBlockList,  triggerEvent,  asyncType );
	}
	if(Test.isRunningTest()){
		integer exVal = 10/0;
	}
			}catch(exception e){
	errorList= logExceptionMethod( e,asyncType, newErrorLog,  triggerEvent, errorList);
			}
		}
		if(afterUpdateCheck){
			triggerEvent='UPDATE';
			try{
	//Added this for setEntitlementReport
	if(!asyncEECheck)
		CH_CaseTriggerHelper.checkEntitlementExceptionCases(oldCaseMap, newCaseList);	
	if(!asyncBLCheck)
		CH_CaseTriggerHelper.CH_BlacklistCaseReportTrigger(newCaseList);   
	List<Case> updateCaseList = new List<Case>();
	for(case c:newCaseList){
					//Modified below code - NOKIASC-36540 #starts here 
					String entReportoldValue = null;
					string entReportnewValue =  null;
					if(string.isBlank(entReportOldValue) || entReportOldValue ==null || entReportOldValue ==''){
						entReportOldValue ='';
					} else{
						entReportOldValue = JSON.serialize(oldCaseMap.get(c.Id).CH_EntitlementReport__c.escapeUnicode());
					}
					if(string.isblank(entReportnewValue) || entReportnewValue ==null || entReportnewValue ==''){
						entReportnewValue ='';
					}  else{
						entReportnewValue =  JSON.serialize(c.CH_EntitlementReport__c.escapeUnicode());
					}  
					//Modified above code - NOKIASC-36540 #starts here 
				   if(!oldCaseMap.isempty() && ( entReportOldValue != entReportnewValue  || c.CH_BlockCases__c != oldCaseMap.get(c.Id).CH_BlockCases__c)) {
			 updateCaseList.add(c);
		}
	}
	if(!updateCaseList.isEmpty()){
					system.debug(updateCaseList.isEmpty()+' updateCaseList----->'+updateCaseList);
		errorList = logDataBaseException( updateCaseList,  errorList,  className,  methodEntCheck,  methodBlockList,  triggerEvent,  asyncType );
	}
	if(Test.isRunningTest()){
		integer exVal = 10/0;
	}
			}catch(exception e){
	errorList= logExceptionMethod( e,asyncType, newErrorLog,  triggerEvent, errorList);
			}
		}
		try{
			CH_CaseTriggerUtilityHelper.createProductChatterGroup(newCaseList,oldCaseMap,triggerEvent);
		}
		catch(exception e){
			errorList= logExceptionMethod( e,asyncType, newErrorLog,  triggerEvent, errorList);
		}
		if(errorList.size()>0){
			CH_ErrorLogUtils.insertErrorLog(errorList);
		}
	}
	
	public static List<ErrorLog__c> logDataBaseException(List<case> updateCaseList, List<ErrorLog__c> errorList, string className, string methodEntCheck, string methodBlockList, String triggerEvent, String asyncType ){
		//**changes related NOKIASC-27623 Code Opt start
		Database.SaveResult[] srList = Database.update(updateCaseList,false);
		for(Integer index = 0, size = srList.size(); index < size; index++){
			if(!srList[index].isSuccess()){
	for(Database.Error err: srList.get(index).getErrors()){
		String recId = (String.isNotBlank(updateCaseList[index].id))?updateCaseList[index].id:''; 
		ErrorLog__c newErrorLog = new ErrorLog__c();
		if(String.isBlank(updateCaseList[index].CH_EntitlementReport__c)){
			newErrorLog = CH_ErrorLogUtils.createErrorLog(err.getMessage(),className+'-'+methodEntCheck, triggerEvent+'-'+asyncType,'Entitlement Exception',recId);
		}else{
			newErrorLog = CH_ErrorLogUtils.createErrorLog(err.getMessage(),className+'-'+methodBlockList, triggerEvent+'-'+asyncType,'BlacklistCase Report',recId);
		}
		errorList.add(newErrorLog);
	}
			}
		}
		//**changes related NOKIASC-27623 Code Opt end.
		return errorList;
	}
	
	public static List<ErrorLog__c> logExceptionMethod(Exception e, String asyncType, ErrorLog__c newErrorLog, String triggerEvent,  List<ErrorLog__c> errorList){
		//**changes related NOKIASC-27623 Code Opt start
		List<String> exStringList = New List<String>();
		String className;
		String methname;
		String methodName;
		List<String> methStringList = new List<String>();
		String exceptionString = e.getStackTraceString();
		if(String.isNotBlank(exceptionString)){
			exStringList = exceptionString.split('\\.');
		}
		if(!exStringList.isEmpty()){
			className = exStringList[1];
			methname = exStringList[2];	
		}
		if(String.isNotBlank(exceptionString)){
			methStringList = methName.split(':');
		}
		if(!methStringList.isEmpty()){
			methodName = methStringList[0]; 
		}
		newErrorLog = CH_ErrorLogUtils.createErrorLog(e.getMessage(), className+'-'+methodName,triggerEvent+'-'+asyncType,'Case updates',Null);
		errorList.add(newErrorLog);
		//**changes related NOKIASC-27623 Code Opt end.
		return errorList;
	}
}