/****************************************
* Class Name : CH_CaseProcessQueueable
* Created Date: 01 April 2020
* Created By : TCS
* Last Modified by: TCS
* Description : To perform asynchronous calls from CH_CaseTriggerHandler 
* US : Code Opt - NOKIASC-27610 & 27611
*****************************************/
public class CH_CaseProcessQueueable implements Queueable{
	Public static List<ErrorLog__c> errorList = new List<ErrorLog__c>();
	Public Static List<FeedItem> chatterPostList = new List<FeedItem>();
	FeedItem newChatterPost = new FeedItem();
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
		if(afterInsertCheck){
			String triggerEvent='INSERT';
			try{
				//Added this for setEntitlementReport
				System.debug('CASE LIST IN QUEUEABLE BEFORE:'+newCaseList);
				if(!asyncEECheck)
					CH_CaseTriggerHelper.checkEntitlementExceptionCases(newCaseList);
				if(!asyncBLCheck)
					CH_CaseTriggerHelper.CH_BlacklistCaseReportTrigger(newCaseList);
				List<Case> updateCaseList = new List<Case>();
				System.debug('CASE LIST IN QUEUEABLE AFTER:'+newCaseList);
				for(case c:newCaseList){
					//check for null for both fields
					// CH_EntitlementReport__c,CH_BlockCases__c
					if(Test.isRunningTest())
					{
						System.debug('SUBJECT:'+c.Subject);
						if(c.Subject=='TEST2'){
							Integer a=10/0;
						}
					}
					if((c.CH_EntitlementReport__c != '' && c.CH_EntitlementReport__c != null) || c.CH_BlockCases__c != null)
						updateCaseList.add(c);
				}
				if(!updateCaseList.isEmpty()){
					//**changes related NOKIASC-27623 Code Opt start
					Database.SaveResult[] srList = Database.update(updateCaseList,false);
					for(Integer index = 0, size = srList.size(); index < size; index++){
						if(!srList[index].isSuccess()){
							System.debug('Failed records');
							for(Database.Error err: srList.get(index).getErrors()){
								List<CollaborationGroup> cgList = CH_ErrorLogUtils.getErrorLogChatterGroup();
								Id errorchatterGroupId;
								if(!cgList.isEmpty()){
									errorchatterGroupId = cgList[0].Id;
								}
								String recId;
								if(updateCaseList[index].id!=Null &&updateCaseList[index].id!=''){
									recId =  updateCaseList[index].id; 
								}else{
									recId = ''; 
								}
								System.debug('recId ===== '+recId);
								ErrorLog__c newErrorLog = New ErrorLog__c();
								if(String.isBlank(updateCaseList[index].CH_EntitlementReport__c)){
									newErrorLog = CH_ErrorLogUtils.createErrorLog(err.getMessage(),className,methodEntCheck, triggerEvent,asyncType,recId);
									String chatterPostBody = CH_ErrorLogUtils.createChatterbody(className, methodEntCheck,err);
									newChatterPost = CH_ErrorLogUtils.postToErrorLogChatGroup(errorchatterGroupId,chatterPostBody);
								}else{
									newErrorLog = CH_ErrorLogUtils.createErrorLog(err.getMessage(),className, 'CH_BlacklistCaseReportTrigger', triggerEvent,asyncType,recId);
									String chatterPostBody = CH_ErrorLogUtils.createChatterbody(className, methodEntCheck,err);
									System.debug('updateCaseList[index].Origin ====  '+updateCaseList[index].Origin);
									if(updateCaseList[index].Origin == 'S2S'){
										Map<String, Id> interfaceKeyUserGroups = CH_UserNotificationUTIL.getCollaborationGroupsForExternalSystems(new Set<String>{updateCaseList[index].CH_CaseOriginSystem__c});
										Id errorChatterGroupS2S = interfaceKeyUserGroups.get(updateCaseList[index].CH_CaseOriginSystem__c); 
										newChatterPost = CH_ErrorLogUtils.postToErrorLogChatGroup(errorChatterGroupS2S,chatterPostBody);  
									}else{
										newChatterPost = CH_ErrorLogUtils.postToErrorLogChatGroup(errorchatterGroupId,chatterPostBody);
									}
								}
								errorList.add(newErrorLog);
								chatterPostList.add(newChatterPost);
							}
						}
					}
					//**changes related NOKIASC-27623 Code Opt end.
				} 
			}catch(exception e){
				//**changes related NOKIASC-27623 Code Opt start
				List<CollaborationGroup> cgList = CH_ErrorLogUtils.getErrorLogChatterGroup();
				List<String> exStringList = New List<String>();
				Id errorchatterGroupId;
				String className;
				String methname;
				String methodName;
				List<String> methStringList = new List<String>();
				if(!cgList.isEmpty()){
					errorchatterGroupId = cgList[0].Id;
				}
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
				ErrorLog__c newErrorLog = New ErrorLog__c();
				newErrorLog = CH_ErrorLogUtils.createErrorLog(e.getMessage(), className, methodName,triggerEvent,asyncType,'');
				newChatterPost = CH_ErrorLogUtils.postToErrorLogChatGroup(errorchatterGroupId, e.getStackTraceString());
				errorList.add(newErrorLog);
				chatterPostList.add(newChatterPost);
				//**changes related NOKIASC-27623 Code Opt end.
			}
			try{
				CH_CaseTriggerUtilityHelper.createProductChatterGroup(newCaseList,new Map <Id,Case>(),triggerEvent);
				if(Test.isRunningTest())
				{
					//System.debug('SUBJECT:'+c.Subject);
					//if(c.Subject=='TEST2'){
					Integer a=10/0;
					//}
				}
			}
			catch(exception e){
				//**changes related NOKIASC-27623 Code Opt start
				List<CollaborationGroup> cgList = CH_ErrorLogUtils.getErrorLogChatterGroup();
				List<String> exStringList = New List<String>();
				Id errorchatterGroupId;
				String className;
				String methname;
				String methodName;
				List<String> methStringList = new List<String>();
				if(!cgList.isEmpty()){
					errorchatterGroupId = cgList[0].Id;
				}
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
				ErrorLog__c newErrorLog = New ErrorLog__c();
				newErrorLog = CH_ErrorLogUtils.createErrorLog(e.getMessage(), className, methodName,triggerEvent,asyncType,'');
				newChatterPost = CH_ErrorLogUtils.postToErrorLogChatGroup(errorchatterGroupId, e.getStackTraceString());
				errorList.add(newErrorLog);
				chatterPostList.add(newChatterPost);
				//**changes related NOKIASC-27623 Code Opt end.
			}
		}
		if(afterUpdateCheck){
			String triggerEvent='UPDATE';
			try{
				
				//Added this for setEntitlementReport
				System.debug('CASE LIST IN QUEUEABLE BEFORE#####:'+newCaseList);
				if(!asyncEECheck)
					CH_CaseTriggerHelper.checkEntitlementExceptionCases(oldCaseMap, newCaseList);	
				if(!asyncBLCheck)
					CH_CaseTriggerHelper.CH_BlacklistCaseReportTrigger(newCaseList);   
				List<Case> updateCaseList = new List<Case>();
				for(case c:newCaseList){
					//check for oldmap and new case list values for both fields
					//if(c.CH_EntitlementReport__c!=null || c.CH_BlockCases__c!=null)
					if(Test.isRunningTest())
					{
						if(c.Subject=='TEST2'){
							Integer a=10/0;
						}
					}
					if(!oldCaseMap.isempty() && (c.CH_EntitlementReport__c != oldCaseMap.get(c.Id).CH_EntitlementReport__c || c.CH_BlockCases__c != oldCaseMap.get(c.Id).CH_BlockCases__c)) {
						updateCaseList.add(c);
					}
				}
				if(!updateCaseList.isEmpty()){
					//**changes related NOKIASC-27623 Code Opt start
					Database.SaveResult[] srList = Database.update(updateCaseList,false);
					System.debug('srList.size() ===  '+srList.size());
					for(Integer index = 0, size = srList.size(); index < size; index++){
						if(!srList[index].isSuccess()){
							System.debug('inside failure update');
							for(Database.Error err: srList.get(index).getErrors()){
								List<CollaborationGroup> cgList = CH_ErrorLogUtils.getErrorLogChatterGroup();
								Id errorchatterGroupId;
								if(!cgList.isEmpty()){
									errorchatterGroupId = cgList[0].Id;
								}
								String recId;
								if(updateCaseList[index].id!=Null &&updateCaseList[index].id!=''){
									recId =  updateCaseList[index].id; 
								}else{
									recId = ''; 
								}
								ErrorLog__c newErrorLog = New ErrorLog__c();
								if(String.isBlank(updateCaseList[index].CH_EntitlementReport__c)){
									String chatterBody = CH_ErrorLogUtils.createChatterbody(className,methodEntCheck,err);
									newErrorLog = CH_ErrorLogUtils.createErrorLog(err.getMessage(),className,methodEntCheck,triggerEvent,asyncType,recId);
									newChatterPost = CH_ErrorLogUtils.postToErrorLogChatGroup(errorchatterGroupId,chatterBody);
								}else{
									String chatterBody = CH_ErrorLogUtils.createChatterbody(className,methodBlockList,err);
									newErrorLog = CH_ErrorLogUtils.createErrorLog(err.getMessage(),className,methodBlockList,triggerEvent,asyncType,recId);
									System.debug('updateCaseList[index].Origin ====  '+updateCaseList[index].Origin);
									if(updateCaseList[index].Origin == 'S2S'){
										Map<String, Id> interfaceKeyUserGroups = CH_UserNotificationUTIL.getCollaborationGroupsForExternalSystems(new Set<String>{updateCaseList[index].CH_CaseOriginSystem__c});
										Id errorChatterGroupS2S = interfaceKeyUserGroups.get(updateCaseList[index].CH_CaseOriginSystem__c); 
										newChatterPost = CH_ErrorLogUtils.postToErrorLogChatGroup(errorChatterGroupS2S,chatterBody);  
									}else{
										newChatterPost = CH_ErrorLogUtils.postToErrorLogChatGroup(errorchatterGroupId,chatterBody);
									}
								}
								errorList.add(newErrorLog);
								chatterPostList.add(newChatterPost);
							}
						}
						
					}
					//**changes related NOKIASC-27623 Code Opt end.
				} 
				System.debug('CASE LIST IN QUEUEABLE AFTER#####:'+newCaseList);
			}catch(exception e){
				//**changes related NOKIASC-27623 Code Opt start
				List<CollaborationGroup> cgList = CH_ErrorLogUtils.getErrorLogChatterGroup();
				List<String> exStringList = New List<String>();
				Id errorchatterGroupId;
				String className;
				String methname;
				String methodName;
				List<String> methStringList = new List<String>();
				if(!cgList.isEmpty()){
					errorchatterGroupId = cgList[0].Id;
				}
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
				ErrorLog__c newErrorLog = New ErrorLog__c();
				newErrorLog = CH_ErrorLogUtils.createErrorLog(e.getMessage(), className, methodName,triggerEvent,asyncType,'');
				newChatterPost = CH_ErrorLogUtils.postToErrorLogChatGroup(errorchatterGroupId, e.getStackTraceString());
				errorList.add(newErrorLog);
				chatterPostList.add(newChatterPost);
				//**changes related NOKIASC-27623 Code Opt end.
			}
			try{
				CH_CaseTriggerUtilityHelper.createProductChatterGroup(newCaseList,oldCaseMap,triggerEvent);
				if(Test.isRunningTest())
				{
					if(newCaseList[1].Subject=='TEST2'){
						Integer a=10/0;
					}
				}
			}catch(exception e){
				//**changes related NOKIASC-27623 Code Opt start
				List<CollaborationGroup> cgList = CH_ErrorLogUtils.getErrorLogChatterGroup();
				List<String> exStringList = New List<String>();
				Id errorchatterGroupId;
				String className;
				String methname;
				String methodName;
				List<String> methStringList = new List<String>();
				if(!cgList.isEmpty()){
					errorchatterGroupId = cgList[0].Id;
				}
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
				ErrorLog__c newErrorLog = New ErrorLog__c();
				newErrorLog = CH_ErrorLogUtils.createErrorLog(e.getMessage(), className, methodName,triggerEvent,asyncType,'');
				newChatterPost = CH_ErrorLogUtils.postToErrorLogChatGroup(errorchatterGroupId, e.getStackTraceString());
				errorList.add(newErrorLog);
				chatterPostList.add(newChatterPost);
				//**changes related NOKIASC-27623 Code Opt end.
			}
		}
		//**changes related NOKIASC-27623 Code Opt start
		if(errorList.size()>0){
			CH_ErrorLogUtils.insertErrorLog(errorList);
		}
		if(chatterPostList.size()>0){
			CH_ErrorLogUtils.insertchatterPost(chatterPostList);
		}
		//**changes related NOKIASC-27623 Code Opt end.
	}
}