/****************************************
* Class Name : CH_CN_NotificationSubContentQueueable
* Created Date: 16 Jul 2020
* Created By : TCS
* Last Modified by: TCS
* Description : To perform asynchronous calls from CH_CaseTriggerHandler for Subscription Notifications
* US : NOKIASC-29170
*****************************************/
public class CH_CN_NotificationSubContentQueueable implements Queueable, Database.AllowsCallouts{
	Set<Id> caseIdSet = new Set<Id>();
	Public  List<ErrorLog__c> ErrLstP = new List<ErrorLog__c>();
	Public Map<Case, Map<String, List<CH_NotificationSubscription__c>>> casEvtNSMap = new Map<Case, Map<String, List<CH_NotificationSubscription__c>>>();
	String jobId = '';
	public CH_CN_NotificationSubContentQueueable(Map<Case, Map<String, List<CH_NotificationSubscription__c>>> casEvtNSMap,Set<Id> caseIdSet, String jobId){
		this.casEvtNSMap = casEvtNSMap;
		this.caseIdSet = caseIdSet;	
		this.jobId = jobId;
	}
	public void execute(QueueableContext context){		
		if(casEvtNSMap.size()>0){	
			CH_CN_NotificationSubscriptionContent.Contentselection(casEvtNSMap,jobId);	
		}		
	}	
}