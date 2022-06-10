/****************************************
* Class Name : CH_ErrorLogUtils
* Created Date: 07 Apr 2020
* Created By : TCS
* Description : This class is used to create the error log record whenever async methods are failed.
	Created as part of NOKIASC-27623 Code Opt.
* Test Class: CH_ErrorLogUtils_Test
*****************************************/
public without sharing class CH_ErrorLogUtils {
	/********************
	*Method Name: createErrorLog
	*Parameter: String parameters 
	*Created by: TCS 6th Apr 2020
	*Description: This method will retung error log.


	*******************/
	Public static ErrorLog__c createErrorLog(String errorMessage,String className_MethodName,String triggerEvent_methodRunType, String ProcessName, String RecordId){
		
		ErrorLog__c newErrorLog = New ErrorLog__c();
		newErrorLog.Application__c = 'Case Handling';
		newErrorLog.OwnerId = System.Label.CH_Archived_Case_No_Owner;//NOKIASC-34657
		newErrorLog.ErrorMessage__c = errorMessage;
		newErrorLog.ProcessName__c = ProcessName;
		newErrorLog.Status__c = 'Fail';
		newErrorLog.SFID__c = RecordId;
		Id recId = String.isNotBlank(RecordId)?(Id)RecordId:null;
		newErrorLog.ObjectName__c = String.isNotBlank(recId)?recId.getSObjectType().getDescribe().getName():'';
		String[] classString = className_MethodName.split('-');
		newErrorLog.className__c = (classString.Size()>0 && String.isNotBlank(classString.get(0)))?classString.get(0):'';
		newErrorLog.methodName__c = (classString.Size()>1 && String.isNotBlank(classString.get(1)))?classString.get(0):'';
		String[] eventString = triggerEvent_methodRunType.split('-');
		newErrorLog.TriggerEvent__c = (eventString.Size()>0 && String.isNotBlank(eventString.get(0)))?eventString.get(0):'';
		newErrorLog.MethodRunType__c = (eventString.Size()>1 && String.isNotBlank(eventString.get(1)))?eventString.get(1):'';
		return newErrorLog;	
	}	
	/********************
	*Method Name: insertErrorLog
	*Parameter:  List of ErrorLog__c records
	*Created by: TCS 6th Apr 2020
	*Description: This method will inserts the error log records.  
	*******************/
	Public static void insertErrorLog(List<ErrorLog__c> errorLogList){
		if(errorLogList.Size()>0 && (Limits.getDMLStatements()<Limits.getLimitDMLStatements())){
			Database.SaveResult[] srList = Database.insert(errorLogList,false);			
		}
	}   
	
}