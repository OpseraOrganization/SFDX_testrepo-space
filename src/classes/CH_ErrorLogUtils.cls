/****************************************
* Class Name : CH_ErrorLogUtils
* Created Date: 07 Apr 2020
* Created By : TCS
* Description : This class is used to create the error log record whenever async methods are failed.
	Created as part of NOKIASC-27623 Code Opt.
* Test Class: CH_CaseProcessQueueable_Test
*****************************************/
public class CH_ErrorLogUtils {
	/********************
	*Method Name: createErrorLog
	*Parameter: String parameters 
	*Created by: TCS 6th Apr 2020
	*Description: This method will retung error log.   
	*******************/
	Public static ErrorLog__c createErrorLog(String errorMessage, String className, String methodName, String eventType, String processType, String RecordId){
		ErrorLog__c newErrorLog = New ErrorLog__c();
		newErrorLog.Application__c = 'Case Handling';
		newErrorLog.ErrorMessage__c = errorMessage;
		newErrorLog.className__c = className;
		newErrorLog.methodName__c = methodName;
		newErrorLog.TriggerEvent__c = eventType;
		newErrorLog.MethodRunType__c = processType;
		newErrorLog.SFID__c = RecordId;
		newErrorLog.Status__c = 'Fail';
		return newErrorLog;
	}
	/********************
	*Method Name: insertErrorLog
	*Parameter:  List of ErrorLog__c records
	*Created by: TCS 6th Apr 2020
	*Description: This method will inserts the error log records.  
	*******************/
	Public static void insertErrorLog(List<ErrorLog__c> errorLogList){
		if((Limits.getDMLStatements()<Limits.getLimitDMLStatements())){
			Database.SaveResult[] srList = Database.insert(errorLogList,false);			
		}
	}
	/********************
	*Method Name: getErrorLogChatterGroup
	*Parameter:  
	*Created by: TCS 6th Apr 2020
	*Description: This method will return the chatter group.
	*******************/
	Public static List<CollaborationGroup> getErrorLogChatterGroup(){
		List<CollaborationGroup> errorLogChatGroupList = [SELECT Id from CollaborationGroup WHERE Name = 'Error - Case Handling' LIMIT 1];
		return errorLogChatGroupList;
	}
	/********************
	*Method Name: postToErrorLogChatGroup
	*Parameter:  Id chatterGroupId, String Body
	*Created by: TCS 6th Apr 2020
	*Description: This method will create the chatterpost to error handling group when ever a async method fails.
	*******************/
	Public static FeedItem postToErrorLogChatGroup(Id chatterGroupId, String Body){
		FeedItem newPost = new FeedItem();
		newPost.ParentId = ChatterGroupId;
		newPost.Body = Body;
		return newPost;
	}
	/********************
	*Method Name: insertchatterPost
	*Parameter:  List<FeedItem> feedItemList
	*Created by: TCS 6th Apr 2020
	*Description: This method will inserts the feed item records.  
	*******************/
	Public static void insertchatterPost(List<FeedItem> feedItemList){
		if((Limits.getDMLStatements()<Limits.getLimitDMLStatements())){
			Database.SaveResult[] srList = Database.insert(feedItemList,false);			
		}
	}
	/********************
	*Method Name: createChatterbody
	*Parameter:  String className, String methodName, Database.Error error
	*Created by: TCS 6th Apr 2020
	*Description: This method will be used to generate the body of hte chantter post
	*******************/
	Public static String createChatterbody(String className, String methodName, Database.Error error){
		String body = ' Error Details:  \r\n';
		body += 'Error: '+error.getMessage()+ '\r\n';
		body += 'method: '+methodName+'\r\n';
		body+= 'Clas :' +className+'\r\n';
		return body;
	}
}